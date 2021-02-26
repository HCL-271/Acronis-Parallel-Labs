#================#
# COMPILER FLAGS #
#================#

CCFLAGS += -std=c99 -Werror -Wall -O0 -mavx -pthread

#=============#
# COMPILATION #
#=============#

matrix_multiply : matrix_multiply.c
	gcc -D L1D_LINESIZE=$(shell getconf LEVEL1_DCACHE_LINESIZE) ${CCFLAGS} $< -o $@