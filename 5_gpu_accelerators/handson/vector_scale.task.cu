#include <cstdio>
#include <algorithm>



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



    // TODO: do the scaling on the GPU
    for(int i = 0; i < count; i++)
    {
        h_vector[i] *= scalar;
    }



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
