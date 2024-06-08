
#include "omp.h"
#include <cstdio>

int main(int argc, char **argv)
{
	for (int s = 0; s < 100; ++s) {
		double time = omp_get_wtime();
		while (omp_get_wtime() - time < 1);
		printf("%3d/100\n", s);
	}

}
