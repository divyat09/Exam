#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>

#define NUM 10000000

#define CUDA_ERROR_EXIT(str) do{\
                                    cudaError err = cudaGetLastError();\
                                    if( err != cudaSuccess){\
                                             printf("Cuda Error: '%s' for %s\n", cudaGetErrorString(err), str);\
                                             exit(-1);\
                                    }\
                             }while(0);
#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))

struct num_array{
                    double num1;
                    double num2;
                    double result;
};


__device__ void function(struct num_array *a)
{
    double square = a ->num1 * a->num1 +  a->num2 * a->num2  + 2 * a->num1 * a->num2;
    a->result = log(square)/sin(square);
    return;
}

__global__ void calculate(char *mem, int num)
{
      int i= blockIdx.x*blockDim.x*blockDim.y + blockDim.x*threadIdx.y + threadIdx.x;  
      if(i >= num)
           return;
       struct num_array *a = (struct num_array *)(mem + (i * 3 * sizeof(double)));
      function(a);
}

int main(int argc, char **argv)
{
    struct timeval start, end, t_start, t_end;
    int i;
    struct num_array *pa;
    char *ptr;
    char *sptr;
    char *gpu_mem;   
    unsigned long num = NUM;   /*Default value of num from MACRO*/
    int blocks;
    int NumRows, NumColumns;

    if(argc == 4){
         num = atoi(argv[1]);   /*Update after checking*/
         if(num <= 0)
               num = NUM;
         NumRows= atoi(argv[2]);
         NumColumns= atoi(argv[3]);
         
         if(NumRows==0 || NumColumns==0){
            printf("Error: Provide suitable values for Rows and Columns \n" );
            return -1;            
         }

         if(NumRows*NumColumns > 1024 ){
            printf("Error: Max thread limit per block exceeded \n" );
            return -1;
         }
    }
    else{
        printf("%d", argc);
	    printf("Not Correct Number of Argumnets");
        return -1;
    }

    /* Allocate host (CPU) memory and initialize*/

    ptr = (char *)malloc(num * 3 * sizeof(double));
    sptr = ptr; 
    for(i=0; i<num; ++i){
       pa = (struct num_array *) sptr;
       pa->num1 = (double) i + (double) i * 0.1;
       pa->num2 = pa->num1 + 1.0;
       sptr += 3 * sizeof(double);
    }
    
    
    gettimeofday(&t_start, NULL);
    
    /* Allocate GPU memory and copy from CPU --> GPU*/

    cudaMalloc(&gpu_mem, num * 3 * sizeof(double));
    CUDA_ERROR_EXIT("cudaMalloc");

    cudaMemcpy(gpu_mem, ptr, num * 3 * sizeof(double) , cudaMemcpyHostToDevice);
    CUDA_ERROR_EXIT("cudaMemcpy");
    
    gettimeofday(&start, NULL);

    dim3 threads( NumRows , NumColumns ); 
    
    blocks = num /(NumRows*NumColumns);
    if(num % (NumRows*NumColumns))
           ++blocks;

    calculate<<<blocks, threads>>>(gpu_mem, num);
    CUDA_ERROR_EXIT("kernel invocation");
    gettimeofday(&end, NULL);
    
    /* Copy back result*/

    cudaMemcpy(ptr, gpu_mem, num * 3 * sizeof(double) , cudaMemcpyDeviceToHost);
    CUDA_ERROR_EXIT("memcpy");
    gettimeofday(&t_end, NULL);
    
    printf("Total time = %ld microsecs Processsing =%ld microsecs\n", TDIFF(t_start, t_end), TDIFF(start, end));
    cudaFree(gpu_mem);
    sptr = ptr;
   
    /*Print the last element for sanity check*/ 
    pa = (struct num_array *) (sptr + (num -1)*3*sizeof(double));
    printf("num1=%f num2=%f result=%f\n", pa->num1, pa->num2, pa->result);

    
    free(ptr);
}
