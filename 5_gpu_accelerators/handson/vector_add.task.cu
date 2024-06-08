#include <cstdio>
#include <algorithm>



// TODO: write the vector_add kernel




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
    
    // TODO: copy vectors A and B to the device
    

    // TODO: set the number of threds per block
    
    // TODO: compute the total number of blocks needed to cover all elements of the vectors
    
    // TODO: launch the vector add kernel
    

    // TODO: copy the vector C from the device
    

    // TODO: release GPU memory
    



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
