//
// Created by 3zz on 12/5/2023.
//

/******************** Includes ********************/

#include "my_malloc.h"

/******************** Macro Declarations ********************/

/******************** Variables Definitions ********************/

void *heap_base = NULL;

/******************** Helper Functions ********************/

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

static meta_block *get_block_ptr(void *ptr)
{
    return ((meta_block *)ptr) - 1;
}

static size_t force_alignment(size_t size)
{
    // size variable indicate the required size in bytes
    size_t aligned_size;
    if (size >= DATABUS_SIZE_IN_BYTES)
    {
        if (size % DATABUS_SIZE_IN_BYTES)
            aligned_size = size + (size % DATABUS_SIZE_IN_BYTES);
        else
            aligned_size = size;
    }
    else
    {
        aligned_size = size + (DATABUS_SIZE_IN_BYTES - size);
    }

    return aligned_size;
}

static void splitting(meta_block **block, meta_block **second_block, size_t aligned_size)
{
    (*second_block)->next = (*block)->next;
    (*second_block)->free = 1;
    (*second_block)->size = (*block)->size - aligned_size;
    (*block)->size = aligned_size;
    (*second_block)->magic = 0x99;

    (*block)->next = (meta_block *)(*second_block);
}

static void merging(void)
{
    meta_block *current = (meta_block *)heap_base;
    while (current && current->next)
    {
        if (current->free && current->next->free)
        {
            meta_block *next_block = current->next;
            current->size += next_block->size;
            current->next = next_block->next;
            next_block->next = NULL;
        }
        current = current->next;
    }
}

/******************** Software Interface Definitions ********************/

/* If it's the first ever call, i.e., heap_base == NULL, request_space and set global_base.
   Otherwise, if we can find a free block, use it.
   If not, request_space.
*/
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

void my_free(void *ptr)
{
    if (!ptr)
        return;

    meta_block *ptr_block = get_block_ptr(ptr);
    ptr_block->free = 1;

    // Merging blocks
    merging();

    ptr_block->magic = 0x55;
}