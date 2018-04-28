#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>
#include<string.h>
#include<pthread.h>
#include<math.h>

#define SEED 0x7457
#define MAX_THREADS 64

#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))

#define USAGE_EXIT(s) do{ \
                             printf("Usage: %s <# of elements> <# of threads> \n %s\n", argv[0], s); \
                            exit(-1);\
                    }while(0);

struct Account
{
  int     Num;
  double  Val;
};

struct Trans
{
  pthread_t      tid;
  int       Seq;
  int       Type;
  double    Val;
  int       Num1;
  int       Num2;
};

pthread_mutex_t lock;
struct Account Array[10000];

void* update_account(void *arg){
  struct Trans *param = (struct Trans *) arg;
  int type=  param->Type;
  double amount= param->Val;
  int Num1= param->Num1;
  int Num2= param->Num2;

  pthread_mutex_lock(&lock);

  if(type==1){
    Array[ Num1-1001 ].Val+= amount*0.99;
  }
  else if( type==2 ){
    Array[ Num1-1001 ].Val= Array[Num1 - 1001].Val - amount*1.01;
  }
  else if( type==3 ){
    Array[ Num1-1001 ].Val= Array[Num1 - 1001].Val*(1.071);   
  }
  else if( type==4 ){
    Array[ Num1-1001 ].Val= Array[Num1 - 1001].Val - amount*1.01;
    Array[ Num2-1001 ].Val+= amount*0.99;    
  }

  pthread_mutex_unlock(&lock);

  return NULL;
}

int main(int argc, char **argv)
{

  struct timeval start, end;
  int idx=0;
  int num_transactions= atoi(argv[3]);
  int num_threads= atoi(argv[4]);

  if(argc !=5)
          USAGE_EXIT("not enough parameters");
  
  if(num_threads <=0 || num_threads > MAX_THREADS){
          USAGE_EXIT("invalid num of threads");
  }

  struct Trans *Array2;
  Array2= malloc(num_transactions * sizeof(struct Trans)); 

  FILE* f=fopen(argv[1],"r");
  while (fscanf(f, "%d %lf", &Array[idx].Num, &Array[idx].Val) != EOF)
  {
    ++idx;
  } 
  fclose(f);

  idx=0;

  f=fopen(argv[2],"r");
  while (fscanf(f, "%d %d %lf %d %d", &Array2[idx].Seq, &Array2[idx].Type, &Array2[idx].Val, &Array2[idx].Num1, &Array2[idx].Num2 ) != EOF)
  {
    ++idx;
  }
  fclose(f);

  gettimeofday(&start, NULL);

  int counter=0;
  while( counter < num_transactions ){
    int limit;
    if( num_transactions < counter + num_threads ){
       limit= num_transactions - counter; 
    }
    else{
      limit= num_threads;
    }

    int ThreadSize=0;
    int SpecialCase=0;

    // Thread Creation
    pthread_mutex_init(&lock, NULL);

    while( ThreadSize < limit ){
        struct Trans *param = Array2 + counter + ThreadSize;

        if( param->Type == 3 ){
          SpecialCase= 1;
          break;
        }

        if(pthread_create(&param->tid, NULL, update_account, param) != 0){
              perror("pthread_create");
              exit(-1);
        }

        ThreadSize= ThreadSize + 1;
    }

    // Thread Join
    for(int _iter=0; _iter < ThreadSize; ++_iter){
          struct Trans *param = Array2 + _iter + counter;
          pthread_join(param->tid, NULL); 
    }      

    //Case of Type 3 instruction
    if(SpecialCase){
        struct Trans *param = Array2 + counter + ThreadSize;
        if(pthread_create(&param->tid, NULL, update_account, param) != 0){
              perror("pthread_create");
              exit(-1);
        }
        counter+=1;
        pthread_join(param->tid, NULL); 
    }

    counter+=ThreadSize;
  }

  for(int iter=0; iter<10000; iter++){
    printf("%d %.2lf\n", Array[iter].Num, Array[iter].Val);
  }

  // gettimeofday(&end, NULL);
  // printf("Time taken = %ld microsecs\n", TDIFF(start, end));

  free(Array2); 
  return 0;
}
