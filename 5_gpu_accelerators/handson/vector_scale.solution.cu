#include <cstdio>
#include <algorithm>



__global__ void vector_scale(float * vector, int count, float scalar)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if(idx < count)
    {
        vector[idx] *= scalar;
    }
}



int main()
{
    int count = 56789;
    int count_print = std::min(count, 10);
    float scalar = 10;

    float * h_vector = new float[count];
    for(int i = 0; i < count; i++) h_vector[i] = i;

    printf("Input: ");
    for(int i = 0; i < count_print; i++) printf(" %7.2f", h_vector[i]);
    printf("\n");



    float * d_vector;
    cudaMalloc(&d_vector, count * sizeof(float));

    cudaMemcpy(d_vector, h_vector, count * sizeof(float), cudaMemcpyHostToDevice);

    int tpb = 256;
    int bpg = (count - 1) / tpb + 1;
    vector_scale<<< bpg, tpb >>>(d_vector, count, scalar);

    cudaMemcpy(h_vector, d_vector, count * sizeof(float), cudaMemcpyDeviceToHost);

    cudaFree(d_vector);



    printf("Output:");
    for(int i = 0; i < count_print; i++) printf(" %7.2f", h_vector[i]);
    printf("\n");

    int errors = 0;
    for(int i = 0; i < count; i++)
    {
        float correct = i * scalar;
        float observed = h_vector[i];
        if(std::abs((correct - observed) / correct) > 1e-4)
        {
            errors++;
            if(errors <= 5) printf("Wrong result on index %d: correct is %f, but result is %f\n", i, correct, observed);
        }
    }
    if(errors == 0) printf("Correct!\n");
    else printf("Total errors: %d\n", errors);

    delete[] h_vector;

    return 0;
}
