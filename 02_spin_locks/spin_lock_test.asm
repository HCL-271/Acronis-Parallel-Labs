	.file	"spin_lock_test.c"
	.text
	.globl	MAX_THREADS
	.section	.rodata
	.align 4
	.type	MAX_THREADS, @object
	.size	MAX_THREADS, 4
MAX_THREADS:
	.long	1024
	.globl	CORRECTNESS_TEST_NUM_LOCK_ACQISITIONS
	.align 8
	.type	CORRECTNESS_TEST_NUM_LOCK_ACQISITIONS, @object
	.size	CORRECTNESS_TEST_NUM_LOCK_ACQISITIONS, 8
CORRECTNESS_TEST_NUM_LOCK_ACQISITIONS:
	.quad	100
	.globl	CORRECTNESS_TEST_NUMBER_OF_CYCLES
	.align 8
	.type	CORRECTNESS_TEST_NUMBER_OF_CYCLES, @object
	.size	CORRECTNESS_TEST_NUMBER_OF_CYCLES, 8
CORRECTNESS_TEST_NUMBER_OF_CYCLES:
	.quad	100
	.globl	PERFORMANCE_TEST_NUM_LOCK_ACQISITIONS
	.align 8
	.type	PERFORMANCE_TEST_NUM_LOCK_ACQISITIONS, @object
	.size	PERFORMANCE_TEST_NUM_LOCK_ACQISITIONS, 8
PERFORMANCE_TEST_NUM_LOCK_ACQISITIONS:
	.quad	10000
	.globl	PERFORMANCE_TEST_NUMBER_OF_CYCLES
	.align 8
	.type	PERFORMANCE_TEST_NUMBER_OF_CYCLES, @object
	.size	PERFORMANCE_TEST_NUMBER_OF_CYCLES, 8
PERFORMANCE_TEST_NUMBER_OF_CYCLES:
	.quad	100
	.globl	FAIRNESS_TEST_NUM_LOCK_ACQISITIONS
	.align 8
	.type	FAIRNESS_TEST_NUM_LOCK_ACQISITIONS, @object
	.size	FAIRNESS_TEST_NUM_LOCK_ACQISITIONS, 8
FAIRNESS_TEST_NUM_LOCK_ACQISITIONS:
	.quad	10000
	.globl	FAIRNESS_TEST_NUMBER_OF_CYCLES
	.align 8
	.type	FAIRNESS_TEST_NUMBER_OF_CYCLES, @object
	.size	FAIRNESS_TEST_NUMBER_OF_CYCLES, 8
FAIRNESS_TEST_NUMBER_OF_CYCLES:
	.quad	100
	.align 8
.LC0:
	.string	"\033[1;35m[Error] Unable to get real time\n\033[0m"
	.text
	.globl	one_thread_job
	.type	one_thread_job, @function
one_thread_job:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movq	%rdi, -88(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-88(%rbp), %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	leaq	-48(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	cmpl	$-1, %eax
	jne	.L2
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$43, %edx
	movl	$1, %esi
	leaq	.LC0(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L2:
	movq	$0, -80(%rbp)
	jmp	.L3
.L6:
	movq	-56(%rbp), %rax
	movq	(%rax), %rdx
	movl	$0, %eax
	call	*%rdx
	movq	$0, -72(%rbp)
	jmp	.L4
.L5:
	movq	-56(%rbp), %rax
	movq	32(%rax), %rax
	leaq	1(%rax), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, 32(%rax)
	addq	$1, -72(%rbp)
.L4:
	movq	-56(%rbp), %rax
	movq	24(%rax), %rax
	cmpq	%rax, -72(%rbp)
	jb	.L5
	movq	-56(%rbp), %rax
	movq	8(%rax), %rdx
	movl	$0, %eax
	call	*%rdx
	addq	$1, -80(%rbp)
.L3:
	movq	-56(%rbp), %rax
	movq	16(%rax), %rax
	cmpq	%rax, -80(%rbp)
	jb	.L6
	leaq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	call	clock_gettime@PLT
	cmpl	$-1, %eax
	jne	.L7
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$43, %edx
	movl	$1, %esi
	leaq	.LC0(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L7:
	movq	-32(%rbp), %rdx
	movq	-48(%rbp), %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm1
	movq	-24(%rbp), %rdx
	movq	-40(%rbp), %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC1(%rip), %xmm2
	mulsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movq	-64(%rbp), %rax
	movsd	%xmm0, 16(%rax)
	movl	$0, %eax
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L9
	call	__stack_chk_fail@PLT
.L9:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	one_thread_job, .-one_thread_job
	.section	.rodata
	.align 8
.LC2:
	.string	"\033[1;35m[Error] Unable to get allocate memory\n\033[0m"
	.align 8
.LC3:
	.string	"\033[1;35m[Error] Unable to init thread attributes\n\033[0m"
	.align 8
.LC4:
	.string	"\033[1;35m[Error] Unable to create thread\n\033[0m"
	.align 8
.LC5:
	.string	"\033[1;35m[Error] Unable to join thread\n\033[0m"
	.text
	.globl	run_test
	.type	run_test, @function
run_test:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$208, %rsp
	movq	%rdi, -168(%rbp)
	movq	%rsi, -176(%rbp)
	movq	%rdx, -184(%rbp)
	movq	%rcx, -192(%rbp)
	movq	%r8, -200(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-168(%rbp), %rax
	movq	%rax, -112(%rbp)
	movq	-176(%rbp), %rax
	movq	%rax, -104(%rbp)
	movq	-192(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-200(%rbp), %rax
	movq	%rax, -88(%rbp)
	movq	$0, -80(%rbp)
	movl	$1024, %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -120(%rbp)
	cmpq	$0, -120(%rbp)
	jne	.L11
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$49, %edx
	movl	$1, %esi
	leaq	.LC2(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L11:
	movq	$0, -152(%rbp)
	jmp	.L12
.L13:
	movq	-152(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	addq	%rax, %rdx
	leaq	-112(%rbp), %rax
	movq	%rax, (%rdx)
	addq	$1, -152(%rbp)
.L12:
	movl	$1024, %eax
	cltq
	cmpq	%rax, -152(%rbp)
	jb	.L13
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	pthread_attr_init@PLT
	testl	%eax, %eax
	je	.L14
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$52, %edx
	movl	$1, %esi
	leaq	.LC3(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L14:
	movq	$1, -144(%rbp)
	jmp	.L15
.L22:
	movq	$0, -80(%rbp)
	movq	$0, -136(%rbp)
	jmp	.L16
.L18:
	movq	-136(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-136(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	addq	%rdx, %rax
	leaq	8(%rax), %rdi
	leaq	-64(%rbp), %rax
	leaq	one_thread_job(%rip), %rdx
	movq	%rax, %rsi
	call	pthread_create@PLT
	testl	%eax, %eax
	je	.L17
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$43, %edx
	movl	$1, %esi
	leaq	.LC4(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L17:
	addq	$1, -136(%rbp)
.L16:
	movq	-136(%rbp), %rax
	cmpq	-144(%rbp), %rax
	jb	.L18
	movq	$0, -128(%rbp)
	jmp	.L19
.L21:
	movq	-128(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	addq	%rdx, %rax
	movq	8(%rax), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	testl	%eax, %eax
	je	.L20
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$41, %edx
	movl	$1, %esi
	leaq	.LC5(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L20:
	addq	$1, -128(%rbp)
.L19:
	movq	-128(%rbp), %rax
	cmpq	-144(%rbp), %rax
	jb	.L21
	movq	-144(%rbp), %rdx
	movq	-120(%rbp), %rsi
	leaq	-112(%rbp), %rcx
	movq	-184(%rbp), %rax
	movq	%rcx, %rdi
	call	*%rax
	salq	-144(%rbp)
.L15:
	movl	$1024, %eax
	cltq
	cmpq	%rax, -144(%rbp)
	jb	.L22
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L23
	call	__stack_chk_fail@PLT
.L23:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	run_test, .-run_test
	.section	.rodata
	.align 8
.LC6:
	.string	"\033[1;33mThe result for %4zu threads is \033[1;32mCORRECT\n\033[0m"
	.align 8
.LC7:
	.string	"\033[1;33mThe result for %4zu threads is \033[1;31mWRONG\n\033[0m"
	.text
	.globl	correctness_test_printout
	.type	correctness_test_printout, @function
correctness_test_printout:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-8(%rbp), %rax
	movq	32(%rax), %rax
	movq	%rax, %rcx
	movq	-8(%rbp), %rax
	movq	16(%rax), %rax
	imulq	-24(%rbp), %rax
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	imulq	%rdx, %rax
	cmpq	%rax, %rcx
	jne	.L25
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC6(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L27
.L25:
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
.L27:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	correctness_test_printout, .-correctness_test_printout
	.globl	run_correctness_test
	.type	run_correctness_test, @function
run_correctness_test:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$100, %eax
	movq	%rax, %rcx
	movl	$100, %eax
	movq	%rax, %rdx
	movq	-16(%rbp), %rsi
	movq	-8(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	leaq	correctness_test_printout(%rip), %rdx
	movq	%rax, %rdi
	call	run_test
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	run_correctness_test, .-run_correctness_test
	.section	.rodata
.LC9:
	.string	"\033[1;33m%4zu %10f\n\033[0m"
	.text
	.globl	performance_test_printout
	.type	performance_test_printout, @function
performance_test_printout:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -16(%rbp)
	movq	$0, -8(%rbp)
	jmp	.L30
.L31:
	movq	-8(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movsd	16(%rax), %xmm0
	movsd	-16(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	addq	$1, -8(%rbp)
.L30:
	movq	-8(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L31
	movq	-40(%rbp), %rax
	testq	%rax, %rax
	js	.L32
	cvtsi2sdq	%rax, %xmm0
	jmp	.L33
.L32:
	movq	%rax, %rdx
	shrq	%rdx
	andl	$1, %eax
	orq	%rax, %rdx
	cvtsi2sdq	%rdx, %xmm0
	addsd	%xmm0, %xmm0
.L33:
	movsd	-16(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, -48(%rbp)
	movsd	-48(%rbp), %xmm0
	movq	%rax, %rsi
	leaq	.LC9(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	performance_test_printout, .-performance_test_printout
	.globl	run_performance_test
	.type	run_performance_test, @function
run_performance_test:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$100, %eax
	movq	%rax, %rcx
	movl	$10000, %eax
	movq	%rax, %rdx
	movq	-16(%rbp), %rsi
	movq	-8(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	leaq	performance_test_printout(%rip), %rdx
	movq	%rax, %rdi
	call	run_test
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	run_performance_test, .-run_performance_test
	.globl	fairness_test_printout
	.type	fairness_test_printout, @function
fairness_test_printout:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -16(%rbp)
	movq	$0, -8(%rbp)
	jmp	.L36
.L39:
	movq	-8(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movsd	16(%rax), %xmm0
	ucomisd	-16(%rbp), %xmm0
	jbe	.L37
	movq	-8(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movsd	16(%rax), %xmm0
	movsd	%xmm0, -16(%rbp)
.L37:
	addq	$1, -8(%rbp)
.L36:
	movq	-8(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L39
	movq	-16(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, -48(%rbp)
	movsd	-48(%rbp), %xmm0
	movq	%rax, %rsi
	leaq	.LC9(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	fairness_test_printout, .-fairness_test_printout
	.globl	run_fairness_test
	.type	run_fairness_test, @function
run_fairness_test:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$100, %eax
	movq	%rax, %rcx
	movl	$10000, %eax
	movq	%rax, %rdx
	movq	-16(%rbp), %rsi
	movq	-8(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	leaq	fairness_test_printout(%rip), %rdx
	movq	%rax, %rdi
	call	run_test
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	run_fairness_test, .-run_fairness_test
	.globl	TAS_CYCLES_TO_SPIN
	.section	.rodata
	.align 4
	.type	TAS_CYCLES_TO_SPIN, @object
	.size	TAS_CYCLES_TO_SPIN, 4
TAS_CYCLES_TO_SPIN:
	.long	10
	.globl	TAS_MIN_BACKOFF_NANOSECONDS
	.align 4
	.type	TAS_MIN_BACKOFF_NANOSECONDS, @object
	.size	TAS_MIN_BACKOFF_NANOSECONDS, 4
TAS_MIN_BACKOFF_NANOSECONDS:
	.long	1000
	.globl	TAS_MAX_BACKOFF_NANOSECONDS
	.align 4
	.type	TAS_MAX_BACKOFF_NANOSECONDS, @object
	.size	TAS_MAX_BACKOFF_NANOSECONDS, 4
TAS_MAX_BACKOFF_NANOSECONDS:
	.long	64000
	.text
	.globl	TAS_init
	.type	TAS_init, @function
TAS_init:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	TAS_init, .-TAS_init
	.globl	TAS_acquire
	.type	TAS_acquire, @function
TAS_acquire:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1000, -40(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L44
.L47:
#APP
# 49 "SpinLocks.h" 1
	pause
# 0 "" 2
#NO_APP
	movl	$10, %eax
	cmpl	%eax, -36(%rbp)
	jne	.L45
	movq	$0, -32(%rbp)
	call	rand@PLT
	movl	$1000, %ecx
	movl	$0, %edx
	divl	%ecx
	movl	-40(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, %eax
	movq	%rax, -24(%rbp)
	movl	$64000, %eax
	cmpl	%eax, -40(%rbp)
	jnb	.L46
	sall	-40(%rbp)
.L46:
	movl	$10, %eax
	subl	$1, %eax
	movl	%eax, -36(%rbp)
	leaq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	nanosleep@PLT
.L45:
	addl	$1, -36(%rbp)
.L44:
	movq	-56(%rbp), %rdx
	movl	$1, %eax
	xchgl	(%rdx), %eax
	testl	%eax, %eax
	jne	.L47
	movl	$1000, -40(%rbp)
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L48
	call	__stack_chk_fail@PLT
.L48:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	TAS_acquire, .-TAS_acquire
	.globl	TAS_release
	.type	TAS_release, @function
TAS_release:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, %edx
	movl	%edx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	TAS_release, .-TAS_release
	.globl	TTAS_CYCLES_TO_SPIN
	.section	.rodata
	.align 4
	.type	TTAS_CYCLES_TO_SPIN, @object
	.size	TTAS_CYCLES_TO_SPIN, 4
TTAS_CYCLES_TO_SPIN:
	.long	10
	.globl	TTAS_MIN_BACKOFF_NANOSECONDS
	.align 4
	.type	TTAS_MIN_BACKOFF_NANOSECONDS, @object
	.size	TTAS_MIN_BACKOFF_NANOSECONDS, 4
TTAS_MIN_BACKOFF_NANOSECONDS:
	.long	1000
	.globl	TTAS_MAX_BACKOFF_NANOSECONDS
	.align 4
	.type	TTAS_MAX_BACKOFF_NANOSECONDS, @object
	.size	TTAS_MAX_BACKOFF_NANOSECONDS, 4
TTAS_MAX_BACKOFF_NANOSECONDS:
	.long	64000
	.text
	.globl	TTAS_init
	.type	TTAS_init, @function
TTAS_init:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	TTAS_init, .-TTAS_init
	.globl	TTAS_acquire
	.type	TTAS_acquire, @function
TTAS_acquire:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1000, -40(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L52
.L54:
#APP
# 107 "SpinLocks.h" 1
	pause
# 0 "" 2
#NO_APP
	addl	$1, -36(%rbp)
.L52:
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L59
	movl	$10, %eax
	cmpl	%eax, -36(%rbp)
	jb	.L54
.L59:
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	je	.L55
	movq	$0, -32(%rbp)
	call	rand@PLT
	movl	$1000, %ecx
	movl	$0, %edx
	divl	%ecx
	movl	-40(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, %eax
	movq	%rax, -24(%rbp)
	movl	$64000, %eax
	cmpl	%eax, -40(%rbp)
	jnb	.L56
	sall	-40(%rbp)
.L56:
	leaq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	nanosleep@PLT
	jmp	.L59
.L55:
	movq	-56(%rbp), %rdx
	movl	$1, %eax
	xchgl	(%rdx), %eax
	testl	%eax, %eax
	je	.L62
	jmp	.L59
.L62:
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L60
	call	__stack_chk_fail@PLT
.L60:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	TTAS_acquire, .-TTAS_acquire
	.globl	TTAS_release
	.type	TTAS_release, @function
TTAS_release:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, %edx
	movl	%edx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	TTAS_release, .-TTAS_release
	.globl	TICKET_CYCLES_TO_SPIN
	.section	.rodata
	.align 4
	.type	TICKET_CYCLES_TO_SPIN, @object
	.size	TICKET_CYCLES_TO_SPIN, 4
TICKET_CYCLES_TO_SPIN:
	.long	100
	.globl	TICKET_MIN_BACKOFF_NANOSECONDS
	.align 4
	.type	TICKET_MIN_BACKOFF_NANOSECONDS, @object
	.size	TICKET_MIN_BACKOFF_NANOSECONDS, 4
TICKET_MIN_BACKOFF_NANOSECONDS:
	.long	2000
	.globl	TICKET_MAX_BACKOFF_NANOSECONDS
	.align 4
	.type	TICKET_MAX_BACKOFF_NANOSECONDS, @object
	.size	TICKET_MAX_BACKOFF_NANOSECONDS, 4
TICKET_MAX_BACKOFF_NANOSECONDS:
	.long	32000
	.text
	.globl	TicketLock_init
	.type	TicketLock_init, @function
TicketLock_init:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, (%rax)
	movq	-8(%rbp), %rax
	movl	$0, 4(%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	TicketLock_init, .-TicketLock_init
	.globl	TicketLock_acquire
	.type	TicketLock_acquire, @function
TicketLock_acquire:
.LFB15:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-56(%rbp), %rax
	movl	$1, %edx
	lock xaddl	%edx, (%rax)
	movl	%edx, -36(%rbp)
	movl	$2000, -44(%rbp)
	movl	$0, -40(%rbp)
	jmp	.L66
.L68:
#APP
# 176 "SpinLocks.h" 1
	pause
# 0 "" 2
#NO_APP
	addl	$1, -40(%rbp)
.L66:
	movq	-56(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, -36(%rbp)
	je	.L71
	movl	$100, %eax
	cmpl	%eax, -40(%rbp)
	jb	.L68
.L71:
	movq	-56(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, -36(%rbp)
	je	.L74
	movq	$0, -32(%rbp)
	movl	-44(%rbp), %eax
	movq	%rax, -24(%rbp)
	movl	$32000, %eax
	cmpl	%eax, -44(%rbp)
	jnb	.L70
	sall	-44(%rbp)
.L70:
	leaq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	nanosleep@PLT
	jmp	.L71
.L74:
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L73
	call	__stack_chk_fail@PLT
.L73:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	TicketLock_acquire, .-TicketLock_acquire
	.globl	TicketLock_release
	.type	TicketLock_release, @function
TicketLock_release:
.LFB16:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
#APP
# 204 "SpinLocks.h" 1
	mfence
# 0 "" 2
#NO_APP
	movq	-8(%rbp), %rax
	movl	4(%rax), %eax
	leal	1(%rax), %edx
	movq	-8(%rbp), %rax
	movl	%edx, 4(%rax)
#APP
# 209 "SpinLocks.h" 1
	sfence
# 0 "" 2
#NO_APP
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	TicketLock_release, .-TicketLock_release
	.comm	TAS_test,4,4
	.globl	TAS_test_init
	.type	TAS_test_init, @function
TAS_test_init:
.LFB17:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	TAS_test(%rip), %rdi
	call	TAS_init
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	TAS_test_init, .-TAS_test_init
	.globl	TAS_test_acquire
	.type	TAS_test_acquire, @function
TAS_test_acquire:
.LFB18:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	TAS_test(%rip), %rdi
	call	TAS_acquire
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	TAS_test_acquire, .-TAS_test_acquire
	.globl	TAS_test_release
	.type	TAS_test_release, @function
TAS_test_release:
.LFB19:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	TAS_test(%rip), %rdi
	call	TAS_release
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	TAS_test_release, .-TAS_test_release
	.comm	TTAS_test,4,4
	.globl	TTAS_test_init
	.type	TTAS_test_init, @function
TTAS_test_init:
.LFB20:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	TTAS_test(%rip), %rdi
	call	TTAS_init
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	TTAS_test_init, .-TTAS_test_init
	.globl	TTAS_test_acquire
	.type	TTAS_test_acquire, @function
TTAS_test_acquire:
.LFB21:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	TTAS_test(%rip), %rdi
	call	TTAS_acquire
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	TTAS_test_acquire, .-TTAS_test_acquire
	.globl	TTAS_test_release
	.type	TTAS_test_release, @function
TTAS_test_release:
.LFB22:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	TTAS_test(%rip), %rdi
	call	TTAS_release
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	TTAS_test_release, .-TTAS_test_release
	.comm	ticket_test,8,8
	.globl	ticket_test_init
	.type	ticket_test_init, @function
ticket_test_init:
.LFB23:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	ticket_test(%rip), %rdi
	call	TicketLock_init
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	ticket_test_init, .-ticket_test_init
	.globl	ticket_test_acquire
	.type	ticket_test_acquire, @function
ticket_test_acquire:
.LFB24:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	ticket_test(%rip), %rdi
	call	TicketLock_acquire
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	ticket_test_acquire, .-ticket_test_acquire
	.globl	ticket_test_release
	.type	ticket_test_release, @function
ticket_test_release:
.LFB25:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	ticket_test(%rip), %rdi
	call	TicketLock_release
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	ticket_test_release, .-ticket_test_release
	.globl	LOCK_NAMES
	.section	.rodata
.LC10:
	.string	"Ticket lock"
.LC11:
	.string	"TAS lock"
.LC12:
	.string	"TTAS lock"
	.section	.data.rel.local,"aw",@progbits
	.align 16
	.type	LOCK_NAMES, @object
	.size	LOCK_NAMES, 24
LOCK_NAMES:
	.quad	.LC10
	.quad	.LC11
	.quad	.LC12
	.globl	LOCK_INITS
	.align 16
	.type	LOCK_INITS, @object
	.size	LOCK_INITS, 24
LOCK_INITS:
	.quad	ticket_test_init
	.quad	TAS_test_init
	.quad	TTAS_test_init
	.globl	LOCK_ACQUIRES
	.align 16
	.type	LOCK_ACQUIRES, @object
	.size	LOCK_ACQUIRES, 24
LOCK_ACQUIRES:
	.quad	ticket_test_acquire
	.quad	TAS_test_acquire
	.quad	TTAS_test_acquire
	.globl	LOCK_RELEASES
	.align 16
	.type	LOCK_RELEASES, @object
	.size	LOCK_RELEASES, 24
LOCK_RELEASES:
	.quad	ticket_test_release
	.quad	TAS_test_release
	.quad	TTAS_test_release
	.section	.rodata
	.align 8
.LC13:
	.string	"\033[1;36m%s correctness test:\n\033[0m"
	.align 8
.LC14:
	.string	"\033[1;36m%s performance test:\n\033[0m"
.LC15:
	.string	"\033[1;36m%s fairness test:\n\033[0m"
	.text
	.globl	main
	.type	main, @function
main:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	jmp	.L86
.L87:
	movl	-4(%rbp), %eax
	leaq	0(,%rax,8), %rdx
	leaq	LOCK_INITS(%rip), %rax
	movq	(%rdx,%rax), %rdx
	movl	$0, %eax
	call	*%rdx
	movl	-4(%rbp), %eax
	leaq	0(,%rax,8), %rdx
	leaq	LOCK_NAMES(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, %rsi
	leaq	.LC13(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-4(%rbp), %eax
	leaq	0(,%rax,8), %rdx
	leaq	LOCK_RELEASES(%rip), %rax
	movq	(%rdx,%rax), %rdx
	movl	-4(%rbp), %eax
	leaq	0(,%rax,8), %rcx
	leaq	LOCK_ACQUIRES(%rip), %rax
	movq	(%rcx,%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	run_correctness_test
	movl	-4(%rbp), %eax
	leaq	0(,%rax,8), %rdx
	leaq	LOCK_NAMES(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, %rsi
	leaq	.LC14(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-4(%rbp), %eax
	leaq	0(,%rax,8), %rdx
	leaq	LOCK_RELEASES(%rip), %rax
	movq	(%rdx,%rax), %rdx
	movl	-4(%rbp), %eax
	leaq	0(,%rax,8), %rcx
	leaq	LOCK_ACQUIRES(%rip), %rax
	movq	(%rcx,%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	run_performance_test
	movl	-4(%rbp), %eax
	leaq	0(,%rax,8), %rdx
	leaq	LOCK_NAMES(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, %rsi
	leaq	.LC15(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-4(%rbp), %eax
	leaq	0(,%rax,8), %rdx
	leaq	LOCK_RELEASES(%rip), %rax
	movq	(%rdx,%rax), %rdx
	movl	-4(%rbp), %eax
	leaq	0(,%rax,8), %rcx
	leaq	LOCK_ACQUIRES(%rip), %rax
	movq	(%rcx,%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	run_fairness_test
	addl	$1, -4(%rbp)
.L86:
	cmpl	$2, -4(%rbp)
	jbe	.L87
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC1:
	.long	3894859413
	.long	1041313291
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
