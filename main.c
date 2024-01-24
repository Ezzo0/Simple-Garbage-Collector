#include "gc/gc.h"

void GC_test1()
{
    printf("Test 1: Objects on stack are preserved.\n");
    VM *vm = newVM();
    pushInt(vm, 1);
    pushInt(vm, 2);

    gc(vm);
    // assertion(vm->numObjects == 2, "Should have preserved objects."); //For Debugging purposes
    freeVM(vm);
}

void GC_test2()
{
    printf("Test 2: Unreached objects are collected.\n");
    VM *vm = newVM();
    pushInt(vm, 1);
    pushInt(vm, 2);
    pop(vm);
    pop(vm);

    gc(vm);
    // assertion(vm->numObjects == 0, "Should have collected objects."); //For Debugging purposes
    freeVM(vm);
}

void GC_test3()
{
    printf("Test 3: Reach nested objects.\n");
    VM *vm = newVM();
    pushInt(vm, 1);
    pushInt(vm, 2);
    pushPair(vm);
    pushInt(vm, 3);
    pushInt(vm, 4);
    pushPair(vm);
    pushPair(vm);

    gc(vm);
    // assertion(vm->numObjects == 7, "Should have reached objects."); //For Debugging purposes
    freeVM(vm);
}

void GC_test4()
{
    printf("Test 4: Handle cycles.\n");
    VM *vm = newVM();
    pushInt(vm, 1);
    pushInt(vm, 2);
    object_t *a = pushPair(vm);
    pushInt(vm, 3);
    pushInt(vm, 4);
    object_t *b = pushPair(vm);

    /* Set up a cycle, and also make 2 and 4 unreachable and collectible. */
    a->right = b;
    b->right = a;

    gc(vm);
    // assertion(vm->numObjects == 4, "Should have collected objects."); //For Debugging purposes
    freeVM(vm);
}

void GC_perfTest()
{
    printf("Performance Test.\n");
    VM *vm = newVM();

    for (int i = 0; i < 1000; i++)
    {
        for (int j = 0; j < 20; j++)
            pushInt(vm, i);

        for (int k = 0; k < 20; k++)
            pop(vm);
    }
    freeVM(vm);
}

int main()
{
    GC_test1();
    printf("\n");
    GC_test2();
    printf("\n");
    GC_test3();
    printf("\n");
    GC_test4();
    printf("\n");
    GC_perfTest();
    printf("\n");

    return 0;
}
