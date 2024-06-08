#include <cstdio>
#include <algorithm>



// TODO: write the vector_add kernel
__global__ void vector_add(float * a, float * b, float * c, int count)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if(idx < count)
    {
        c[idx] = a[idx] + b[idx];
    }
}



int main()
{
    int count = 1234567;
    int count_print = std::min(count, 10);

    float * h_a = new float[count];
    float * h_b = new float[count];
    float * h_c = new float[count];
    for(int i = 0; i < count; i++) h_a[i] = i;
    for(int i = 0; i < count; i++) h_b[i] = 10 * i;

    printf("A:");
    for(int i = 0; i < count_print; i++) printf(" %7.2f", h_a[i]);
    printf("\n");

    printf("B:");
    for(int i = 0; i < count_print; i++) printf(" %7.2f", h_b[i]);
    printf("\n");



    // TODO: allocate GPU memory
    float * d_a;
    float * d_b;
    float * d_c;
    cudaMalloc(&d_a, count * sizeof(float));
    cudaMalloc(&d_b, count * sizeof(float));
    cudaMalloc(&d_c, count * sizeof(float));

    // TODO: copy vectors A and B to the device
    cudaMemcpy(d_a, h_a, count * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, count * sizeof(float), cudaMemcpyHostToDevice);

    // TODO: set the number of threds per block
    int tpb = 256;
    // TODO: compute the total number of blocks needed to cover all elements of the vectors
    int bpg = (count - 1) / tpb + 1;
    // TODO: launch the vector add kernel
    vector_add<<<bpg,tpb>>>(d_a, d_b, d_c, count);

    // TODO: copy the vector C from the device
    cudaMemcpy(h_c, d_c, count * sizeof(float), cudaMemcpyDeviceToHost);

    // TODO: release GPU memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);



    printf("C:");
    for(int i = 0; i < count_print; i++) printf(" %7.2f", h_c[i]);
    printf("\n");

    int errors = 0;
    for(int i = 0; i < count; i++)
    {
        float correct = 11 * i;
        float result = h_c[i];
        if(std::abs((correct - result) / correct) > 1e-4)
        {
            errors++;
            if(errors <= 5) printf("Error on index %d: correct is %f, but result is %f\n", i, correct, h_c[i]);
        }
    }
    if(errors == 0) printf("Correct!\n");
    else printf("Total errors: %d\n", errors);

    delete[] h_a;
    delete[] h_b;
    delete[] h_c;

    return 0;
}
