//
// Created by 3zz on 12/5/2023.
//

#ifndef MY_MALLOC_H
#define MY_MALLOC_H

/******************** Includes ********************/

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>

/******************** Macro Declarations ********************/

#define META_DATA_SIZE ((size_t)sizeof(meta_block))
#define DATABUS_SIZE_IN_BYTES 8
#define ALIGNED __attribute__((aligned(DATABUS_SIZE_IN_BYTES * 8)));

/******************** Data Types Declarations ********************/

typedef unsigned char uint8_t;

typedef struct meta
{
    struct meta *next ALIGNED;
    size_t size ALIGNED;
    uint8_t free ALIGNED;
    uint8_t magic ALIGNED; // For debugging only.
} meta_block;

/******************** Software Interface Declarations ********************/

void *my_malloc(size_t size);
void my_free(void *ptr);

#endif // MY_MALLOC_H
