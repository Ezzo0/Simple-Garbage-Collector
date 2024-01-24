//
// Created by 3zz on 12/6/2023.
//

#ifndef GC_H
#define GC_H

/******************** Includes ********************/

#include <stdio.h>
#include <stdlib.h>
#include <stdlib.h>
#include "../my_malloc/my_malloc.h"

/******************** Macro Declarations ********************/

#define STACK_MAX_SIZE 256

/******************** Data Types Declarations ********************/

typedef unsigned char uint8_t;

typedef enum
{
    INT_TYPE,
    PAIR_TYPE
} obj_type;

typedef struct object
{
    obj_type type;
    uint8_t marked;

    struct object *next;

    union
    {
        int val;
        struct
        {
            struct object *left;
            struct object *right;
        };
    };
} object_t;

typedef struct
{
    object_t *STACK[STACK_MAX_SIZE];
    object_t *first_obj;
    int stack_size;

    /* The total number of currently allocated objects. */
    int numObjects;

    /* The number of objects required to trigger a GC. */
    int maxObjects;
} VM;

/******************** Software Interface Declarations ********************/
void assertion(int condition, const char *message);
VM *newVM();
object_t *newObject(VM *vm, obj_type type);
void push(VM *vm, object_t *obj);
object_t *pop(VM *vm);
void pushInt(VM *vm, int val);
object_t *pushPair(VM *vm);
void markAll(VM *vm);
void mark(object_t *obj);
void sweep(VM *vm);
void gc(VM *vm);
void print_object(object_t *obj);
void freeVM(VM *vm);

#endif // GC_H