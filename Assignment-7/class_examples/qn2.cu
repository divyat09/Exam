#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>

#define SEED 0x7457
#define NUM 10000000

#define CUDA_ERROR_EXIT(str) do{\
                                    cudaError err = cudaGetLastError();\
                                    if( err != cudaSuccess){\
                                             printf("Cuda Error: '%s' for %s\n", cudaGetErrorString(err), str);\
                                             exit(-1);\
                                    }\
                             }while(0);
#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))


__global__ void XOR(long long int *Data, int Size, int Odd)
{
      int tid = blockDim.x * blockIdx.x + threadIdx.x;
      int size = Size;
      int Bool= Odd;

      while(size!=0){
        if( tid < size )
            if( tid == size -1 && Bool == 1 ){
                // Do Nothing
            }
            else{
                Data[tid] = Data[tid] ^ Data[ tid + size ];
            }

            __syncthreads();
        
        // To avoid Infinite While Loop
        if (size==1)
        {
            return;
        }

        // Odd Number Case
        if( size % 2){

                size = size/2 +1;
                Bool = 1;
        }        
        else{

                Bool = 0;
                size = size / 2;    
        }
      }
}


int main(int argc, char **argv)
{
    struct timeval start, end, t_start, t_end;
    long long int *HArray;
    long long int *DArray;
    unsigned long num = NUM;   /*Default value of num from MACRO*/
    // int blocks;
    unsigned long Seed = SEED; /*Default value of Seed from MACRO*/

    if(argc == 3){
         num = atoi(argv[1]);   /*Update after checking*/
         if(num <= 0)
               num = NUM;
         
         Seed= atoi(argv[2]);
         if(Seed <= 0)
                Seed = SEED;
    }
    else{
        printf("%d", argc);
	    printf("Not Correct Number of Arguments");
        return -1;
    }


    /* Allocate host (CPU) memory and initialize*/

    HArray = (long long int*) malloc(num * sizeof(long long int) );
    if(!HArray){
          perror("malloc");
          exit(-1);
    }    

    srand(Seed);  
    for(int i=0;i<num;i++){
       HArray[i]= random();
    }

    for(int i=0;i<num;i++){
       printf("%lld ", HArray[i] );       
	if (i<num-1)
		printf("^ ");
    }

        
    gettimeofday(&t_start, NULL);
    
    /* Allocate GPU memory and copy from CPU --> GPU*/

    cudaMalloc(&DArray, num * sizeof(long long int));
    CUDA_ERROR_EXIT("cudaMalloc");

    cudaMemcpy(DArray, HArray, num * sizeof(long long int) , cudaMemcpyHostToDevice);
    CUDA_ERROR_EXIT("cudaMemcpy");
    
    gettimeofday(&start, NULL);
    
    int blocks = num;
    
    if(num % 1024)
           ++blocks;

    // XOR<<<1, (num + num%2)/2>>>(DArray, num%2);

    if( num%2 ){
        XOR<<<blocks, 1024>>>(DArray, (num + 1)/2, 1);
        CUDA_ERROR_EXIT("kernel invocation");
    }
    else{
        XOR<<<blocks, 1024>>>(DArray, num/2, 0);
        CUDA_ERROR_EXIT("kernel invocation");
    }

    gettimeofday(&end, NULL);
    
    /* Copy back result*/

    cudaMemcpy(HArray, DArray, num * sizeof(long long int) , cudaMemcpyDeviceToHost);
    CUDA_ERROR_EXIT("memcpy");
    gettimeofday(&t_end, NULL);
    
    printf("\nTotal time = %ld microsecs Processsing =%ld microsecs\n", TDIFF(t_start, t_end), TDIFF(start, end));
    cudaFree(DArray);
   
    /*Print the last element for sanity check*/ 
    printf("XOR: %lld\n", HArray[0]);
    
    free(HArray);
}
