#include <cstdio>



// TODO: write the say_hello kernel
__global__ void say_hello()
{
    int global_idx = blockIdx.x * blockDim.x + threadIdx.x;
    int total_threads = blockDim.x * gridDim.x;

    printf("Hello world from thread %d/%d, block %d/%d, my global index is %d/%d\n", threadIdx.x, blockDim.x, blockIdx.x, gridDim.x, global_idx, total_threads);
}



int main()
{
    // TODO: launch the say_hello kernel
    say_hello<<< 2, 4 >>>();

    // TODO: wait for the kernel to finish -- synchronize with the device
    cudaDeviceSynchronize();

    return 0;
}
