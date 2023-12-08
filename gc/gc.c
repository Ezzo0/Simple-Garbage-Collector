//
// Created by 3zz on 12/6/2023.
//

/******************** Includes ********************/

#include "gc.h"

/******************** Macro Declarations ********************/

#define INIT_OBJ_NUM_MAX 8

/******************** Variables Definitions ********************/

/******************** Helper Functions ********************/

/******************** Software Interface Definitions ********************/

void assertion(int condition, const char *message)
{
    if (!condition)
    {
        printf("%s\n", message);
        exit(1);
    }
}

VM *newVM()
{
    VM *vm = (VM *)malloc(sizeof(VM));
    vm->stack_size = 0;
    vm->first_obj = NULL;
    vm->numObjects = 0;
    vm->maxObjects = INIT_OBJ_NUM_MAX;
    return vm;
}

object_t *newObject(VM* vm, obj_type typ)
{
    if (vm->numObjects == vm->maxObjects)
        gc(vm);

    object_t *obj = malloc(sizeof(object_t));
    obj->type = typ;
    obj->marked = 0;

    obj->next = vm->first_obj;
    vm->first_obj = obj;

    vm->numObjects++;

    return obj;
}

void push(VM *vm, object_t *obj)
{
    assertion(vm->stack_size < STACK_MAX_SIZE, "STACK OVERFLOW");
    vm->STACK[vm->stack_size++] = obj;
}

object_t *pop(VM *vm)
{
    assertion(vm->stack_size > 0, "STACK UNDERFLOW");
    return vm->STACK[--vm->stack_size];
}

void pushInt(VM* vm, int val)
{
    object_t *obj = newObject(vm,INT_TYPE);
    obj->val = val;
    push(vm,obj);
}

object_t *pushPair(VM* vm)
{
    object_t *obj = newObject(vm,PAIR_TYPE);
    obj->left  = pop(vm);
    obj->right = pop(vm);
    push(vm,obj);
    return obj;
}

void mark(object_t *obj)
{
    if(!obj || obj->marked)
        return;

    obj->marked = 1;
    if(obj->type == PAIR_TYPE)
    {
        mark(obj->left);
        mark(obj->right);
    }
}

void markAll(VM* vm)
{
    for (int i = 0; i < vm->stack_size; ++i)
        mark(vm->STACK[i]);
}

void sweep(VM* vm)
{
    object_t **obj = &vm->first_obj;
    while (*obj)
    {
        if(!(*obj)->marked)
        {
            object_t *garbage = *obj;
            *obj = garbage->next;
            free(garbage);
            vm->numObjects--;
        }
        else
        {
            (*obj)->marked = 0;
            obj = &(*obj)->next;
        }
    }
}

void gc(VM* vm)
{
    int numObjects = vm->numObjects;

    markAll(vm);
    sweep(vm);

    vm->maxObjects = vm->numObjects == 0 ? INIT_OBJ_NUM_MAX : vm->numObjects * 2;

    printf("Collected %d objects, %d remaining.\n", numObjects - vm->numObjects, vm->numObjects);
}

void print_obj(object_t *obj)
{
    switch (obj->type)
    {
        case INT_TYPE:
            printf("%d", obj->val);
            break;

        case PAIR_TYPE:
            printf("(");
            print_obj(obj->left);
            printf(", ");
            print_obj(obj->right);
            printf(")");
            break;
    }
}
void freeVM(VM *vm)
{
    vm->stack_size = 0;
    gc(vm);
    free(vm);
}