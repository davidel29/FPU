cmake_minimum_required(VERSION 2.8)
project(FPU_cpp)

set(CMAKE_CXX_STANDARD 20)

add_executable(FPU_cpp main.cpp Binary_operations.h Binary_operations.cpp FPU.h FPU.cpp)
