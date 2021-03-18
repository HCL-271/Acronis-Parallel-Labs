#================#
# COMPILER FLAGS #
#================#

CCFLAGS += -std=c11 -Werror -Wall -O0 -pthread -lrt

#=============#
# COMPILATION #
#=============#

spin_lock_test : spin_lock_test.c SpinLocks.h SpinLockBenchmarks.h
	gcc ${CCFLAGS} $< -o $@
	gcc -S ${CCFLAGS} $< -o $@.asm