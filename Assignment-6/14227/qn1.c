#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>
#include<string.h>
#include<pthread.h>
#include<math.h>

#define SEED 0x7457
#define MAX_THREADS 64

#define USAGE_EXIT(s) do{ \
                             printf("Usage: %s <# of elements> <# of threads> \n %s\n", argv[0], s); \
                            exit(-1);\
                    }while(0);

#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))

struct thread_param
{
   pthread_t      tid;
   int            offset;
   int            *array;
   int            skip;
   int            limit;
   double         max;  
   int            max_index;
};

int isPrime( int num ){
  int i=1;
  int Limit= sqrt(num);
  for(i=2;i<=Limit;i++){
    if( num%i == 0  ){
      return 0;
    }  
  }

  return 1;
}

void* max_prime(void *arg){

     struct thread_param *param = (struct thread_param *) arg;
     int skip= param->skip;
     int limit= param->limit;
     int* Arr= param->array;
     int id=param->offset;
     int iter=0;

     param->max = -1;
     param->max_index = -1;
    
     while(iter < limit){
           int x= Arr[iter];
           // printf("Val %d\n", x);
           if( isPrime(x) && x > param->max){
                param->max = x;
                param->max_index = id+iter;
           }
           iter+= skip;
     }
}

int main(int argc, char **argv)
{

  struct timeval start, end;
  int idx=0;
  int* Array;
  int num_int= atoi(argv[1]);
  int num_threads= atoi(argv[2]);
  Array = malloc(num_int * sizeof(int));

  if(argc !=3)
           USAGE_EXIT("not enough parameters");

  if(num_int <=0)
          USAGE_EXIT("invalid num elements");
  
  if(num_threads <=0 || num_threads > MAX_THREADS){
          USAGE_EXIT("invalid num of threads");
  }

  if(!Array){
          USAGE_EXIT("invalid num elements, not enough memory");
  }
  
  srand(SEED);  
  for(int i=0;i<num_int;i++){
    Array[i]= random();
  }

  // for(int i=0;i<num_int;i++){
  //   printf("%d\n", Array[i]);
  // }
  
  gettimeofday(&start, NULL);
  
  struct thread_param *params;
  params = malloc(num_threads * sizeof(struct thread_param)); 
        
  for(int _iter=0; _iter < num_threads; ++_iter){
      
    struct thread_param *param = params + _iter;
    param->offset= _iter;
    param->limit = num_int - _iter;
    param->skip = num_threads;
    param->array = Array + _iter;
    
    if(pthread_create(&param->tid, NULL, max_prime,(void *) param) != 0){
          perror("pthread_create");
          exit(-1);
    } 
  }

  int max=0;
  int max_index=0;

  /*Wait for threads to finish their execution*/      
  for( int _iter=0; _iter < num_threads; ++_iter){
    struct thread_param *param = params + _iter;
    pthread_join(param->tid, NULL);

    if(_iter == 0 || (_iter > 0 && param->max > max)){
         max = param->max;    
         max_index = param->max_index;
    }
  }

  printf("Max: %d\t Max Index: %d\n", max, max_index);
  // gettimeofday(&end, NULL);
  // printf("Time taken = %ld microsecs\n", TDIFF(start, end));

  free(Array);
  free(params);

  return 0;
}
