// No copyright. Vladislav Aleinik, 2021
//===============================================
// Multithreaded Programming
// Lab#01: Block Matrix Concurrent Multiplication
//===============================================

//---------------------------------------
// Chapter i: Matrix creation and access 
//---------------------------------------

#define _ISOC11_SOURCE
#define _GNU_SOURCE

#include <stdlib.h>

#include <stddef.h>
#include <stdio.h>

struct Matrix
{
	double* elements;
	size_t size_x, aligned_size_x;
	size_t size_y, aligned_size_y;
};

#define BLOCK_SIZE (L1D_LINESIZE / sizeof(double))

void create_matrix(struct Matrix* matrix, size_t size_x, size_t size_y)
{
	matrix->size_x = size_x;
	matrix->size_y = size_y;

	matrix->aligned_size_x = BLOCK_SIZE * (size_x/BLOCK_SIZE + ((size_x % BLOCK_SIZE == 0)? 0 : 1));
	matrix->aligned_size_y = BLOCK_SIZE * (size_y/BLOCK_SIZE + ((size_y % BLOCK_SIZE == 0)? 0 : 1));

	matrix->elements = aligned_alloc(L1D_LINESIZE, matrix->aligned_size_x * matrix->aligned_size_y * sizeof(double));
	if (matrix->elements == NULL)
	{
		fprintf(stderr, "[Error] Unable to allocate memory\n");
		exit(EXIT_FAILURE);
	}
}

void delete_matrix(struct Matrix* matrix)
{
	free(matrix->elements);
}

double matrix_get(struct Matrix* matrix, size_t x, size_t y)
{
	return matrix->elements[y * matrix->aligned_size_x + x];
}

double* matrix_ptr(struct Matrix* matrix, size_t x, size_t y)
{
	return matrix->elements + y * matrix->aligned_size_x + x;
}

void matrix_set(struct Matrix* matrix, size_t x, size_t y, double value)
{
	matrix->elements[y * matrix->aligned_size_x + x] = value;
}

void fill_lower_triangle(struct Matrix* matrix)
{
	for (size_t y = 0; y < matrix->aligned_size_y; ++y)
	{
		for (size_t x = 0; x < matrix->aligned_size_x; ++x)
		{
			if (y < matrix->size_y && x < matrix->size_x && x <= y)
			{
				matrix_set(matrix, x, y, 1.0);
			}
			else matrix_set(matrix, x, y, 0.0);
		}
	}
}

void fill_upper_triangle(struct Matrix* matrix)
{
	for (size_t y = 0; y < matrix->aligned_size_y; ++y)
	{
		for (size_t x = 0; x < matrix->aligned_size_x; ++x)
		{
			if (y < matrix->size_y && x < matrix->size_x && y <= x)
			{
				matrix_set(matrix, x, y, 1.0);
			}
			else matrix_set(matrix, x, y, 0.0);
		}
	}
}

//----------------------------------
// Chapter ii: Block multiplication 
//----------------------------------

#include <immintrin.h>

void zero_block(struct Matrix* matrix, size_t block_x, size_t block_y)
{
	for (size_t y = block_y; y < block_y + BLOCK_SIZE; ++y)
	{
		for (size_t x = block_x; x < block_x + BLOCK_SIZE; ++x)
		{
			matrix_set(matrix, x, y, 0.0);
		}		
	}
}

void multiply_blocks(struct Matrix* m_a, struct Matrix* m_b, struct Matrix* m_c,
                     size_t c_bl_x, size_t c_bl_y, size_t run_bl_i)
{
	size_t a_bl_x = run_bl_i;
	size_t a_bl_y = c_bl_y;
	size_t b_bl_x = c_bl_x;
	size_t b_bl_y = run_bl_i;

	for (size_t c_y = 0; c_y < BLOCK_SIZE; ++c_y)
	{
		for (size_t c_x = 0; c_x < BLOCK_SIZE; c_x += 4)
		{
			__m256d* line_c = (__m256d*) matrix_ptr(m_c, c_bl_x + c_x, c_bl_y + c_y);

			for (size_t run_i = 0; run_i < BLOCK_SIZE; ++run_i)
			{
				double elem_a = matrix_get(m_a, a_bl_x + run_i, a_bl_y + c_y);
				
				__m256d line_a = _mm256_set_pd(elem_a, elem_a, elem_a, elem_a);

				__m256d* line_b = (__m256d*) matrix_ptr(m_b, b_bl_x + c_x, b_bl_y + run_i);

				*line_c = _mm256_add_pd(*line_c, _mm256_mul_pd(line_a, *line_b));
			}
		}
	}
}

void calculate_block(struct Matrix* m_a, struct Matrix* m_b,
                     struct Matrix* m_c, size_t c_bl_x, size_t c_bl_y)
{
	zero_block(m_c, c_bl_x, c_bl_y);

	for (size_t run_bl_i = 0; run_bl_i < m_a->aligned_size_x; run_bl_i += BLOCK_SIZE)
	{
		multiply_blocks(m_a, m_b, m_c, c_bl_x, c_bl_y, run_bl_i);
	}
}

//--------------------------------------------
// Chapter iii: Dividing jobs between threads 
//--------------------------------------------

#include <pthread.h>
#include <sched.h>
#include <sys/sysinfo.h>

struct ThreadArgs
{
	pthread_t thread_id;

	struct Matrix* m_a;
	struct Matrix* m_b;
	struct Matrix* m_c;

	size_t thread_i;
	size_t num_threads;
};

void* one_thread_job(void* arg)
{
	struct ThreadArgs* thread_args = (struct ThreadArgs*) arg;

	struct Matrix* m_a = thread_args->m_a;
	struct Matrix* m_b = thread_args->m_b;
	struct Matrix* m_c = thread_args->m_c;

	size_t thread_i    = thread_args->thread_i;
	size_t num_threads = thread_args->num_threads;

	for (size_t bl_y = thread_i * BLOCK_SIZE; bl_y < m_c->aligned_size_y; bl_y += num_threads * BLOCK_SIZE)
	{
		for (size_t bl_x = 0; bl_x < m_c->aligned_size_x; bl_x += BLOCK_SIZE)
		{
			calculate_block(m_a, m_b, m_c, bl_x, bl_y);
		}
	}

	return NULL;
}

void matrix_mul_parallel(struct Matrix* m_a, struct Matrix* m_b, struct Matrix* m_c)
{
	if (m_c->size_y != m_a->size_y || m_c->size_x != m_b->size_x || m_a->size_x != m_b->size_y)
	{
		fprintf(stderr, "[Error] Invalid matrix dimensions\n");
		exit(EXIT_FAILURE);
	}

	// Get number of availible cores:
	unsigned num_procs = get_nprocs();

	// INitialize thread handles:
	struct ThreadArgs* args = calloc(num_procs, sizeof(struct ThreadArgs));
	if (args == NULL)
	{
		fprintf(stderr, "[Error] Unable to allocate memory\n");
		exit(EXIT_FAILURE);
	}

	// Init thread attributes:
	pthread_attr_t attr;
    if (pthread_attr_init(&attr) != 0)
	{
		fprintf(stderr, "[Error] Unable to init thread attributes\n");
		exit(EXIT_FAILURE);
	}

	for (size_t thread_i = 0; thread_i < num_procs; ++thread_i)
	{
		args[thread_i] = (struct ThreadArgs)
		{
			.m_a         = m_a,
			.m_b         = m_b,
			.m_c         = m_c,
			.thread_i    = thread_i,
			.num_threads = num_procs
		};

		// Set thread affinity:
		cpu_set_t cpu_to_run_on;
		CPU_ZERO(&cpu_to_run_on);
		CPU_SET(thread_i, &cpu_to_run_on);
		if (pthread_attr_setaffinity_np(&attr, sizeof(cpu_to_run_on), &cpu_to_run_on) != 0)
		{
			fprintf(stderr, "[Error] Unable to call pthread_attr_setaffinity_np()");
			exit(EXIT_FAILURE);
		}

		// Create thread:
		if (pthread_create(&args[thread_i].thread_id, &attr, &one_thread_job, &args[thread_i]) != 0)
		{
			fprintf(stderr, "[Error] Unable to create computation thread");
			exit(EXIT_FAILURE);
		}
	}

	// Wait for all computations to finish:	
	for (size_t thread_i = 0; thread_i < num_procs; ++thread_i)
	{
		if (pthread_join(args[thread_i].thread_id, NULL) != 0)
		{
			fprintf(stderr, "[Error] Unable to join a thread");
			exit(EXIT_FAILURE);
		}
	}
}

//--------------------------------------------
// Chapter iv: Dumb matrix multiplication     
//--------------------------------------------

void matrix_mul_degenerate(struct Matrix* m_a, struct Matrix* m_b, struct Matrix* m_c)
{
	if (m_c->size_y != m_a->size_y || m_c->size_x != m_b->size_x || m_a->size_x != m_b->size_y)
	{
		fprintf(stderr, "[Error] Invalid matrix dimensions\n");
		exit(EXIT_FAILURE);
	}

	for (size_t c_x = 0; c_x < m_c->size_x; ++c_x)
	{
		for (size_t c_y = 0; c_y < m_c->size_y; ++c_y)
		{
			double* cur = matrix_ptr(m_c, c_x, c_y);
			*cur = 0.0;

			for (size_t run_i = 0; run_i < m_a->size_x; ++run_i)
			{
				*cur += matrix_get(m_a, run_i, c_y) * matrix_get(m_b, c_x, run_i);
			}
		}
	}
}

//--------------------------------------------
// Chapter v: Main function
//--------------------------------------------

#include <string.h>

int main(int argc, char* argv[])
{
	if (argc != 2)
	{
		fprintf(stderr, "[Usage] matrix_multilply [--parallel|--degenerate]\n");
		exit(EXIT_FAILURE);
	}

	struct Matrix m_a, m_b, m_c;

	create_matrix(&m_a, 512, 512);
	create_matrix(&m_b, 512, 512);
	create_matrix(&m_c, 512, 512);

	fill_lower_triangle(&m_a);
	fill_upper_triangle(&m_b);

	if (strcmp(argv[1], "--parallel") == 0)
	{
		for (size_t iter = 0; iter < 10; ++iter)
		{
			matrix_mul_parallel(&m_a, &m_b, &m_c);
		}
	}
	else if (strcmp(argv[1], "--degenerate") == 0)
	{
		for (size_t iter = 0; iter < 10; ++iter)
		{
			matrix_mul_degenerate(&m_a, &m_b, &m_c);
		}
	}

	return EXIT_SUCCESS;
}
