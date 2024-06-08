
cmake_minimum_required(VERSION 3.0)
project (SLURM23)

set(CMAKE_CXX_FLAGS "-O0 -g -fopenmp")

include_directories(src)

find_package(MPI REQUIRED)
include_directories(SYSTEM ${MPI_INCLUDE_PATH})

add_executable(mapping src/mapping.cpp)
add_executable(work src/work.cpp)
add_executable(parallel src/parallel.cpp)
target_link_libraries(mapping ${MPI_CXX_LIBRARIES})
target_link_libraries(work ${MPI_CXX_LIBRARIES})
target_link_libraries(parallel ${MPI_CXX_LIBRARIES})

set(CMAKE_CXX_FLAGS "-O3 -g -fopenmp -march=native")
add_executable(threaded src/threaded.cpp)
target_link_libraries(threaded ${MPI_CXX_LIBRARIES})
