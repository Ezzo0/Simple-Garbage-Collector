cmake_minimum_required(VERSION 3.10)

project(SIMPLEGC VERSION 1.0.0)

set (SRC_FILES 
     main.c 
     gc/gc.c
     my_malloc/my_malloc.c)

add_executable(SIMPLEGC ${SRC_FILES})

target_include_directories(SIMPLEGC PUBLIC gc/ my_malloc/)
