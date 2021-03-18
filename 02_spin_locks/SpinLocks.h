// No copyright. Vladislav Aleinik 2021
//======================================
// Multithreaded Programming
// Lab#02: Spin-lock Benchmarking
//======================================
#ifndef SPIN_LOCKS_HPP_INCLUDED
#define SPIN_LOCKS_HPP_INCLUDED

#include <stdlib.h>

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
	int lock_taken;
};

void TAS_init(struct TAS_Lock* lock)
{
	lock->lock_taken = 0;
}

void TAS_acquire(struct TAS_Lock* lock)
{
	unsigned backoff_sleep = TAS_MIN_BACKOFF_NANOSECONDS;

	for (unsigned cycle_no = 0; __sync_lock_test_and_set(&lock->lock_taken, 1); ++cycle_no)
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

	// __sync_lock_test_and_set has an implicit ACQUIRE memory-barrier
}

void TAS_release(struct TAS_Lock* lock)
{
	// __sync_lock_release has an implicit RELEASE memory-barrier
	__sync_lock_release(&lock->lock_taken);
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
	int lock_taken;
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

		if (!__sync_lock_test_and_set(&lock->lock_taken, 1)) return;
	}
}

void TTAS_release(struct TTAS_Lock* lock)
{
	// __sync_lock_release has an implicit RELEASE memory-barrier
	__sync_lock_release(&lock->lock_taken);
}

//------------------------------------------------------------------
// Ticket lock 
//------------------------------------------------------------------
// Optimizations:
// - Better fairness
// - Assembler "pause" instruction for power-effective busy-waiting
// - Exponential backoff strategy
//------------------------------------------------------------------

const unsigned TICKET_CYCLES_TO_SPIN          =   100;
const unsigned TICKET_MIN_BACKOFF_NANOSECONDS =  2000;
const unsigned TICKET_MAX_BACKOFF_NANOSECONDS = 32000;

struct TicketLock
{
	unsigned next_ticket;
	unsigned now_serving;
};

void TicketLock_init(struct TicketLock* lock)
{
	lock->next_ticket = 0;
	lock->now_serving = 0;
}

void TicketLock_acquire(struct TicketLock* lock)
{
	// Acquire a ticket in a queue:
	const unsigned ticket = __sync_fetch_and_add(&lock->next_ticket, 1);

	// __sync_fetch_and_add does impose any store/load ordering
	// So we don't need any other ACQUIRE memory barrier. 

	unsigned backoff_sleep = TICKET_MIN_BACKOFF_NANOSECONDS;

	// Initial spin-loop waiting for our time to be served:
	for (unsigned cycle_no = 0; lock->now_serving != ticket && cycle_no < TICKET_CYCLES_TO_SPIN; ++cycle_no)
	{
		spinloop_pause();
	}

	// Perform exponential backoff:
	while (1)
	{
		if (lock->now_serving != ticket)
		{
			struct timespec to_sleep = {
				.tv_sec  = 0,
				.tv_nsec = backoff_sleep
			};

			if (backoff_sleep < TICKET_MAX_BACKOFF_NANOSECONDS) backoff_sleep *= 2;

			// No value-checking, because it doesn't affect correctness:
			nanosleep(&to_sleep, NULL);

			continue;
		}
		else return;
	}
}

void TicketLock_release(struct TicketLock* lock)
{
	// There is no store/load ordering imposed around the critical section yet.
	// So we need an ACQUIRE memory barrier. A total memory barrier will do:
	memory_barrier();

	lock->now_serving += 1;

	// Flush the store buffer in order to other CPU to notice the lock release:
	store_barrier();
}


#endif // SPIN_LOCKS_HPP_INCLUDED