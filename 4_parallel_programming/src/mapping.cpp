
#include "mpi.h"
#include "omp.h"
#include <sched.h>

int main(int argc, char **argv)
{
	int rank, size, namelen, provided;
	char name[MPI_MAX_PROCESSOR_NAME];

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Get_processor_name(name, &namelen);

	#pragma omp parallel
	{
		printf("%2d/%02d on %s/%02d\n", rank, omp_get_thread_num(), name, sched_getcpu());
	}

	MPI_Finalize();
}
