
#include "mpi.h"
#include <iostream>
#include <chrono>

#define ROWS 131072
#define COLS 32768
#define ITER 16

//#define ROWS 1024
//#define COLS 1024
//#define ITER 1024

struct Grid {
	static size_t rows, cols;

	double K = 1, C = 2, rho = 2, t = 1, dx = 1, dy = 1;
	double *vals;

	Grid()
	{
		vals = new double[(rows + 2) * (cols + 2)]; // + halo

		#pragma omp parallel for collapse(2)
		for (size_t r = 0; r <= rows + 1; ++r) {
			for (size_t c = 0; c <= cols + 1; ++c) {
				this->operator ()(r, c) = 2000;
			}
		}
	}

	~Grid()
	{
		delete[] vals;
	}

	const double& operator()(size_t r, size_t c) const
	{
		return vals[r * cols + c];
	}
	double& operator()(size_t r, size_t c)
	{
		return vals[r * cols + c];
	}

	inline double stencil1(size_t r, size_t c) const
	{
		double rc = operator()(r, c);
		double dc = operator()(r - 1, c) - 2 * operator()(r, c) + operator()(r + 1, c);
		double dr = operator()(r, c - 1) - 2 * operator()(r, c) + operator()(r, c + 1);
		return rc + K * t * (dr / (dx * dx) + dc / (dy * dy)) / (C * rho);
	}

	inline double stencil2(size_t r, size_t c) const
	{
		double dc = operator()(r - 1, c) - 2 * operator()(r, c) + operator()(r + 1, c);
		double dr = operator()(r, c - 1) - 2 * operator()(r, c) + operator()(r, c + 1);
		return dr + dc;

	}

	inline double stencil3(size_t r, size_t c) const
	{
		return operator()(r, c);
	}

	void swap(Grid &other)
	{
		double *tmp = other.vals;
		other.vals = vals;
		vals = tmp;
	}
};

size_t Grid::rows;
size_t Grid::cols;

int main(int argc, char **argv)
{
	MPI_Init(&argc, &argv);

	int rank, size;
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);

	Grid::rows = ROWS / size;
	Grid::cols = COLS;

	int lower = (rank + 1) % size;
	int upper = (rank - 1 + size) % size;

	MPI_Request req[4];
	Grid curr, next, third;

	MPI_Barrier(MPI_COMM_WORLD);
	auto start = std::chrono::steady_clock::now();
	for (int i = 0; i < ITER; ++i) {
		#pragma omp parallel for collapse(2)
		for (size_t r = 1; r <= Grid::rows; ++r) {
			for (size_t c = 1; c <= Grid::cols; ++c) {
				next(r, c) = curr.stencil2(r, c);
			}
		}

		MPI_Irecv(&next(0, 0)             , Grid::cols + 2, MPI_DOUBLE, upper, 0, MPI_COMM_WORLD, req + 0);
		MPI_Isend(&next(1, 0)             , Grid::cols + 2, MPI_DOUBLE, upper, 0, MPI_COMM_WORLD, req + 1);
		MPI_Isend(&next(Grid::rows    , 0), Grid::cols + 2, MPI_DOUBLE, lower, 0, MPI_COMM_WORLD, req + 2);
		MPI_Irecv(&next(Grid::rows + 1, 0), Grid::cols + 2, MPI_DOUBLE, lower, 0, MPI_COMM_WORLD, req + 3);
		MPI_Waitall(4, req, MPI_STATUSES_IGNORE);
	}
	MPI_Barrier(MPI_COMM_WORLD);
	auto end = std::chrono::steady_clock::now();

	std::chrono::duration<double> diff = end - start;
	if (rank == 0) std::cout << "iteration process takes " << diff.count() << " s\n";

	MPI_Finalize();
}

