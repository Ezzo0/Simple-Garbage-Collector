# Simple Garbage Collector using my Own Malloc

First we are going to talk about malloc, then the garbage collector using mark and sweep. So, get a deep breath because we will dive into the realm of memory.

## My Malloc

Setting aside initial considerations, the function signature of malloc is as follows: `void *malloc(size_t size);`
This function requires a specified number of bytes as input and provides a pointer to a memory block of that particular size as output.
There are a number of ways we can implement this. We're going to arbitrarily choose to use [sbrk](https://man7.org/linux/man-pages/man2/sbrk.2.html). The OS reserves stack and heap space for processes and sbrk lets us manipulate the heap.
`sbrk(0)` returns a pointer to the current top of the heap, while `sbrk(x)` increments the heap size by x and returns a pointer to the previous top of the heap.

![memory_layout](https://open4tech.com/wp-content/uploads/2017/04/Memory_Layout.jpg)

To create a straightforward implementation of malloc, we can employ a code snippet like the one below:

```
#include <assert.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

void *malloc(size_t size) {
  void *current_ptr = sbrk(0);
  void *allocated_ptr = sbrk(size);

  if (allocated_ptr == (void*) -1) {
    return NULL; // sbrk failed.
  } else {
    assert(current_ptr == allocated_ptr); // Not thread safe.
    return current_ptr;
  }
}
```

When a program requests memory space using malloc, the function invokes sbrk to increase the heap size and then returns a pointer to the beginning of the newly allocated region on the heap.
It's important to note a technical detail: `malloc(0)` should either return NULL or another pointer that can be passed to free without causing havoc, but it basically works.

Now, turning our attention to the free function, let's explore how it operates. The prototype for free is: `void free(void *ptr);`.
When free is provided with a pointer previously obtained from malloc, its purpose is to release the allocated memory space.
However, when dealing with a pointer to an object allocated by our malloc, determining the size of the associated block becomes challenging.
The question arises: how should we store that information? While one option could be to use a working malloc to allocate some space and store the size information there,
a dilemma arises if we must repeatedly call malloc to reserve space each time we attempt to allocate space with malloc.

Our trick to work around this issue is to store additional information about a memory region in a reserved space just below the pointer that is returned.
For instance, assuming the current top of the heap is at 0x1000 and a request for 0x400 bytes is made, our existing malloc would ask sbrk for 0x400 bytes and return a pointer to 0x1000.
However, if we allocate, let's say, 0x10 bytes to store details about the block, our modified malloc would request 0x410 bytes from sbrk and furnish a pointer to 0x1010.
This way, the 0x10-byte block of meta-information remains concealed from the calling code that utilizes malloc.

That lets us free a block, but another problem has appeared. The heap region we get from the OS has to be contiguous, so we can't return a block of memory in the middle to the OS.
Even if we were willing to copy everything above the newly freed region down to fill the hole,
so we could return space at the end, there's no way to notify all of the code with pointers to the heap that those pointers need to be adjusted.
Alternatively, we can indicate that the block has been freed without releasing it back to the operating system, allowing future calls to malloc to reuse the block.
To achieve this, we must have access to the meta-information for each block. For the sake of simplicity, we will opt for a single linked list.

So, for each block, we'll want to have:

```
typedef struct meta
{
    struct meta *next ALIGNED;
    size_t size ALIGNED;
    uint8_t free ALIGNED;
    uint8_t magic ALIGNED; // For debugging only.
} meta_block;

#define META_DATA_SIZE ((size_t)sizeof(meta_block))
```

Now, a head for our linked list is required: `void *global_base = NULL;`.
In designing our malloc, the goal is to utilize available free space whenever possible and allocate new space only when reusing existing space is not feasible.
With our linked list structure in place, the process of checking for the availability of a free block and returning it becomes straightforward.
Upon receiving a request for a certain size, we simply iterate through our linked list to determine if there is a sufficiently large free block.

```
// Iterate through blocks until we find the one that's large enough.
static meta_block *find_free_block(meta_block **last, size_t size)
{
    meta_block *current = (meta_block *)heap_base;
    while (current && !(current->free && current->size >= size))
    {
        *last = current;
        current = current->next;
    }
    return current;
}
```

If we don't find a free block, we'll have to request space from the OS using sbrk and add our new block to the end of the linked list.

```
static meta_block *request_space(meta_block **last, size_t size)
{
    meta_block *block = NULL;
    block = (meta_block *)sbrk(0);
    void *request = sbrk(size + META_DATA_SIZE);
    assert((void *)block == request); // Not thread safe.
    if (request == (void *)-1)
        return NULL; // sbrk failed.

    if (last) // NULL on first request.
        (*last)->next = block;

    block->size = size;
    block->next = NULL;
    block->free = 0;
    block->magic = 0x12;

    return block;
}
```

With the inclusion of helper functions for examining the availability of existing free space and requesting additional space, our malloc function becomes straightforward.
When our global base pointer is NULL, indicating no existing allocated space, we request space and set the base pointer to our new block.
On the other hand, if the base pointer is not NULL, we assess whether we can repurpose any existing space.
If reusing space is viable, we proceed with it; otherwise, we request new space and utilize the newly acquired region.

```
void *my_malloc(size_t size)
{
    meta_block *block = NULL;
    size_t aligned_size = force_alignment(size);

    if (size <= 0)
        return NULL;

    // First call.
    if (!heap_base)
    {
        block = request_space(NULL, aligned_size);
        if (!block)
            return NULL;
        heap_base = block;
    }
    else
    {
        meta_block *last = heap_base;
        block = find_free_block(&last, aligned_size);
        if (!block) // Failed to find a free block.
        {
            block = request_space(&last, aligned_size);
            if (!block)
                return NULL;
        }
        else // Found a free block
        {
            // splitting the free, if it's size is larger than aligned size, into two blocks.
            if (block->size > aligned_size)
            {
                // The second block (free one) of the large free block
                void *second_block = block;
                second_block += aligned_size;
                second_block += META_DATA_SIZE;
                second_block = (meta_block *)second_block;
                splitting(&block, &second_block, aligned_size);
            }
            block->free = 0;
            block->magic = 0x77;
        }
    }

    return (block + 1);
}
```

Now, let's write free! The main thing free needs to do is set->free and merge free spaces.

```
void my_free(void *ptr)
{
    if (!ptr)
        return;

    meta_block *ptr_block = get_block_ptr(ptr);
    ptr_block->free = 1;

    // Merging blocks
    merging();
}
```

Since free shouldn't be called on arbitrary addresses or on blocks that are already freed, we can assert that those things never happen.

## Garbage Collector

Garbage collection is considered one of the more shark-infested waters of programming, but in about two hundered lines of C I managed to whip up a basic [mark-and-sweep](https://en.wikipedia.org/wiki/Tracing_garbage_collection#Na%C3%AFve_mark-and-sweep) collector.

[Various methods](https://en.wikipedia.org/wiki/Tracing_garbage_collection) exist for implementing the procedure of identifying and recovering all unused objects.
However, the most basic and earliest algorithm devised for this purpose is known as "mark-sweep."
The algorithm works almost exactly like our definition of reachability:
1.Starting at the roots, traverse the entire object graph. Every time you reach an object, set a “mark” bit on it to true.
2.Once that’s done, find all of the objects whose mark bits are not set and delete them.

### A pair of objects

Before delving into the implementation of those two stages, let's address a few initial considerations. We won't be developing an interpreter for a language, complete with a parser, bytecode, or any similar complexities, but we do require a basic amount of code to generate some garbage that we can subsequently collect.
Let’s pretend that we’re writing an interpreter for a little language. It’s dynamically typed, and has two types of objects: ints and pairs. Here’s an enum to identify an object’s type:

```
typedef enum
{
    INT_TYPE,
    PAIR_TYPE
} obj_type;
```

A pair can encompass various combinations, such as two integers, an integer paired with another pair, or any other combinations. Surprisingly, a considerable range of possibilities can be explored using this simple concept.Since an object in the VM can be either of these, the best way in C to implement it is with a [tagged union](https://blog.ryanmartin.me/tagged-unions). We define it thusly:

```
typedef struct object
{
    obj_type type;
    uint8_t marked;
    /* The next object in the list of all objects. */
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
```

The main Object struct has a type field that identifies what kind of value it is—either an int or a pair. Then it has a union to hold the data for the int or pair.

### A minimal virtual machine

Now we can employ this data type within a small virtual machine. In this narrative, the virtual machine's function is to maintain a stack that holds the variables currently in scope. Many language virtual machines follow a stack-based architecture, similar to the JVM.We model that explicitly and simply like so:

```
typedef struct
{
    object_t *STACK[STACK_MAX_SIZE];
    /* The first object in the list of all objects. */
    object_t *first_obj;
    int stack_size;

    /* The total number of currently allocated objects. */
    int numObjects;

    /* The number of objects required to trigger a GC. */
    int maxObjects;
} VM;
```

Now that we’ve got our basic data structures in place. First, let’s write a function that creates and initializes a VM:

```
VM *newVM()
{
    VM *vm = (VM *)my_malloc(sizeof(VM));
    vm->stack_size = 0;
    vm->first_obj = NULL;
    vm->numObjects = 0;
    vm->maxObjects = INIT_OBJ_NUM_MAX;
    return vm;
}
```

Once we have a VM, we need to be able to manipulate its stack:

```
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
```

Now, we need to be able to create objects:

```
object_t *newObject(VM *vm, obj_type typ)
{
    if (vm->numObjects == vm->maxObjects)
        gc(vm);

    object_t *obj = my_malloc(sizeof(object_t));
    obj->type = typ;
    obj->marked = 0;

    /* Insert it into the list of allocated objects. */
    obj->next = vm->first_obj;
    vm->first_obj = obj;

    vm->numObjects++;

    return obj;
}
```

Using that, we can write functions to push each kind of object onto the VM’s stack:

```
void pushInt(VM *vm, int val)
{
    object_t *obj = newObject(vm, INT_TYPE);
    obj->val = val;
    push(vm, obj);
}

object_t *pushPair(VM *vm)
{
    object_t *obj = newObject(vm, PAIR_TYPE);
    obj->left = pop(vm);
    obj->right = pop(vm);
    push(vm, obj);
    return obj;
}
```

And that’s it for our little VM. If we had infinite memory, it would even be able to run real programs. Since we don’t, let’s start collecting some garbage.

### Marking Phase

In this stage, We need to walk all of the reachable objects and set their mark bit. When we create a new object, we initialize marked to zero.
To mark all of the reachable objects, we start with the variables that are in memory. That looks like this:

```
void markAll(VM *vm)
{
    for (int i = 0; i < vm->stack_size; ++i)
        mark(vm->STACK[i]);
}
```

### Sweeping Phase

The next phase is to sweep through all of the objects we’ve allocated and free any of them that aren’t marked. But there’s a problem here: all of the unmarked objects are unreachable! The VM has implemented the language’s semantics for object references, so we’re only storing pointers to objects in variables and the pair fields. As soon as an object is no longer pointed to by one of those, the VM has lost it entirely and actually leaked memory. Our trick to solve this is that the VM can have its own references to objects that are distinct from the semantics that are visible to the language user.
The simplest way to do this is to just maintain a linked list of every object we’ve ever allocated. This is implemented in `object_t` structure as: `struct sObject* next;`. Also, the VM keeps track of the head of that list, which is implemented in `VM` as: `Object* firstObject;`.

In newVM() we make sure to initialize firstObject to NULL. Whenever we create an object, we add it to the list:

```
object_t *newObject(VM *vm, obj_type typ)
{
  /* Previous stuff... */
  /* Insert it into the list of allocated objects. */
  object->next = vm->firstObject;
  vm->firstObject = object;
}
```

This way, even if the language can’t find an object, the language implementation still can.

To sweep through and delete the unmarked objects, we traverse the list:

```
void sweep(VM *vm)
{
    object_t **obj = &vm->first_obj;
    while (*obj)
    {
        if (!(*obj)->marked)
        {
            /* This object wasn't reached, so remove it from the list
            and free it. */
            object_t *garbage = *obj;
            *obj = garbage->next;
            my_free(garbage);
            vm->numObjects--;
        }
        else
        {
            /* This object was reached, so unmark it (for the next GC)
            and move on to the next. */
            (*obj)->marked = 0;
            obj = &(*obj)->next;
        }
    }
}
```

Code just walks the entire linked list. Whenever it hits an object that isn’t marked, it frees its memory and removes it from the list. When this is done, we will have deleted every unreachable object.
Now, we have our own garbage collector.

This is the deepest part of my shark-infested waters; you may go to shore, diver.
