// No copyright. Vladislav Aleinik 2021
//======================================
// Multithreaded Programming
// Lab#02: Spin-lock Benchmarking
//======================================
#ifndef SPIN_LOCKS_HPP_INCLUDED
#define SPIN_LOCKS_HPP_INCLUDED

#include <stdlib.h>
#include <stdint.h>
#include <immintrin.h>

//------------------
// Asm instructions 
//------------------

#define memory_barrier() __asm__ volatile("mfence" ::: "memory")
#define load_barrier()   __asm__ volatile("lfence" ::: "memory")
#define store_barrier()  __asm__ volatile("sfence" ::: "memory")

#define spinloop_pause() __asm__ volatile("pause")

//------------------------------------------------------------------
// TAS lock
//------------------------------------------------------------------
// Optimizations:
// - Assembler "pause" instruction for power-effective busy-waiting
// - Exponential backoff strategy
//------------------------------------------------------------------

const unsigned TAS_CYCLES_TO_SPIN          =    10;
const unsigned TAS_MIN_BACKOFF_NANOSECONDS =  1000;
const unsigned TAS_MAX_BACKOFF_NANOSECONDS = 64000;

struct TAS_Lock
{
	volatile char lock_taken;
};

void TAS_init(struct TAS_Lock* lock)
{
	lock->lock_taken = 0;
}

void TAS_acquire(struct TAS_Lock* lock)
{
	unsigned backoff_sleep = TAS_MIN_BACKOFF_NANOSECONDS;

	for (unsigned cycle_no = 0; __atomic_test_and_set(&lock->lock_taken, __ATOMIC_ACQUIRE); ++cycle_no)
	{
		spinloop_pause();

		if (cycle_no == TAS_CYCLES_TO_SPIN)
		{
			struct timespec to_sleep = {
				.tv_sec  = 0,
				.tv_nsec = backoff_sleep + (rand() % TAS_MIN_BACKOFF_NANOSECONDS)
			};

			if (backoff_sleep < TAS_MAX_BACKOFF_NANOSECONDS) backoff_sleep *= 2;
			cycle_no = TAS_CYCLES_TO_SPIN - 1;

			// No value-checking, because it doesn't affect correctness
			nanosleep(&to_sleep, NULL);
		}
	}

	backoff_sleep = TAS_MIN_BACKOFF_NANOSECONDS;
}

void TAS_release(struct TAS_Lock* lock)
{
	__atomic_clear(&lock->lock_taken, __ATOMIC_RELEASE);
}

//------------------------------------------------------------------
// TTAS lock 
//------------------------------------------------------------------
// Optimizations:
// - Better cache-handling policy
// - Assembler "pause" instruction for power-effective busy-waiting
// - Exponential backoff strategy
//------------------------------------------------------------------

const unsigned TTAS_CYCLES_TO_SPIN          =    10;
const unsigned TTAS_MIN_BACKOFF_NANOSECONDS =  1000;
const unsigned TTAS_MAX_BACKOFF_NANOSECONDS = 64000;

struct TTAS_Lock
{
	volatile char lock_taken;
};

void TTAS_init(struct TTAS_Lock* lock)
{
	lock->lock_taken = 0;
}

void TTAS_acquire(struct TTAS_Lock* lock)
{
	unsigned backoff_sleep = TTAS_MIN_BACKOFF_NANOSECONDS;

	// On start spin-loop waiting for the lock to be released:
	for (unsigned cycle_no = 0; lock->lock_taken && cycle_no < TTAS_CYCLES_TO_SPIN; ++cycle_no)
	{
		spinloop_pause();
	}

	// Then, perform exponential backoff:
	while (1)
	{
		if (lock->lock_taken)
		{
			struct timespec to_sleep = {
				.tv_sec  = 0,
				.tv_nsec = backoff_sleep + (rand() % TTAS_MIN_BACKOFF_NANOSECONDS)
			};

			if (backoff_sleep < TTAS_MAX_BACKOFF_NANOSECONDS) backoff_sleep *= 2;

			// No value-checking, because it doesn't affect correctness:
			nanosleep(&to_sleep, NULL);

			continue;
		}

		if (!__atomic_test_and_set(&lock->lock_taken, __ATOMIC_ACQUIRE)) return;
	}
}

void TTAS_release(struct TTAS_Lock* lock)
{
	__atomic_clear(&lock->lock_taken, __ATOMIC_RELEASE);
}

//------------------------------------------------------------------
// Ticket lock 
//------------------------------------------------------------------
// Optimizations:
// - Better fairness
// - Assembler "pause" instruction for power-effective busy-waiting
// - Schedule the next thread if the lock is taken
//------------------------------------------------------------------

const unsigned TICKET_CYCLES_TO_SPIN = 100;

struct TicketLock
{
	volatile unsigned next_ticket;
	volatile unsigned now_serving;
};

void TicketLock_init(struct TicketLock* lock)
{
	lock->next_ticket = 0;
	lock->now_serving = 0;
}

void TicketLock_acquire(struct TicketLock* lock)
{
	// Acquire a ticket in a queue:
	const unsigned ticket = __atomic_fetch_add(&lock->next_ticket, 1, __ATOMIC_RELAXED);

	// Initial spin-loop waiting for our time to be served:
	for (unsigned cycle_no = 0; __atomic_fetch_add(&lock->now_serving, 0, __ATOMIC_ACQUIRE) != ticket
	                            && cycle_no < TICKET_CYCLES_TO_SPIN; ++cycle_no)
	{
		spinloop_pause();
	}

	// Keep scheduling the next thread if the lock is taken:
	while (__atomic_load_n(&lock->now_serving, __ATOMIC_ACQUIRE) != ticket)
	{
		sched_yield();
	}
}

void TicketLock_release(struct TicketLock* lock)
{
	__atomic_store_n(&lock->now_serving, lock->now_serving + 1, __ATOMIC_RELEASE);
}

#endif // SPIN_LOCKS_HPP_INCLUDED