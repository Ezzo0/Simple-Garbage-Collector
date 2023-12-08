cmake_minimum_required(VERSION 3.26)
project(Simple_Garbage_Collector C)

set(CMAKE_C_STANDARD 23)

add_executable(Simple_Garbage_Collector main.c
        gc/gc.h
        gc/gc.c)
