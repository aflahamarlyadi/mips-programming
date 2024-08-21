# Sorts an array of integers in ascending order using the Insertion Sort algorithm.

# Data section to store the global variables required
	.data
space: .asciiz " "
newline: .asciiz "\n"

# Instruction set begins here
	.text
	.globl main
	.globl insertion_sort
main:
	# set $fp and allocate local variables in the stack
	add $fp, $0, $sp 	# copy $sp into $fp
	addi $sp, $sp, -8 	# 2 local variables = 8 bytes

	# -8($fp) <- i
	# -4($fp) <- input
	
	# input = [6, -2, 7, 4, -10]
	addi $v0, $0, 9		# allocate memory
	addi $t0, $0, 5		# 5 elements
	sll $t1, $t0, 2		# 5*4
	addi $a0, $t1, 4	# allocate (5*4)+4 = 16 bytes
	syscall
	sw $v0, -4($fp)		# input stores the first byte of the array address
	sw $t0, ($v0)		# stores the length of the array to address stored in input
	
	lw $t0, -4($fp)		# load address of input
	addi $t1, $0, 6
	sw $t1, 4($t0)		# input[0] = 6
	addi $t1, $0, -2
	sw $t1, 8($t0)		# input[1] = -2
	addi $t1, $0, 7
	sw $t1, 12($t0)		# input[2] = 7
	addi $t1, $0, 4
	sw $t1, 16($t0)		# input[1] = 4
	addi $t1, $0, -10
	sw $t1, 20($t0)		# input[2] = -10
	
	# allocate arguments in the stack and call insertion_sort(input)
	addi $sp, $sp, -4
	
	# first argument = input
	lw $t0, -4($fp)		# load address of input
	sw $t0, ($sp)
	
	jal insertion_sort	# call insertion_sort(input)
	
	addi $sp, $sp, 4	# remove arguments from stack
	
	sw $0, -8($fp)		# i = 0

	# for i in range(len(input)):	
while_i_lt_size:
	lw $t0, -8($fp)		# load i
	lw $t1, -4($fp)		# load address of input
	lw $t1, ($t1)		# load len(input)
	slt $t0, $t0, $t1	# is i < len(input)?
	beq $t0, $0, end_while	# if not, go to end
	
	# print input[i]
	lw $t0, -4($fp)		# load address of input
	lw $t1, -8($fp)		# load i
	sll $t1, $t1, 2		# i*4
	add $t0, $t0, $t1	# address in array + i*4
	addi $v0, $0, 1
	lw $a0, 4($t0)		# load input[i]
	syscall
	
	# print " "
	addi $v0, $0, 4
	la $a0, space
	syscall
	
	# i += 1
	lw $t0, -8($fp)		# load i
	addi $t0, $t0, 1	# i + 1
	sw $t0, -8($fp)		# store i + 1 to i
	
	j while_i_lt_size	# jump to the start of the loop

end_while:
	# print a new line
	addi $v0, $0, 4
	la $a0, newline
	syscall
	
	addi $sp, $sp, 8	# remove local variables
	
	# exit program
	addi $v0, $0, 10
	syscall
	
insertion_sort:
	# save $ra and $fp in the stack
	addi $sp, $sp, -8	# allocate 8 bytes
	sw $ra, 4($sp)		# save $ra
	sw $fp, ($sp)		# save $fp
	
	addi $fp, $sp, 0	# copy $sp to $fp
	
	addi $sp, $sp, -16	# allocate 16 bytes for 4 local variables

	# -16($fp) <- j
	# -12($fp) <- key	
	# -8($fp) <- i
	# -4($fp) <- length
	# ($fp) <-  saved $fp
	# 4($fp) <- saved $ra
	# 8($fp) <- array
	
	# length = len(array)
	lw $t0, 8($fp)		# load address of array
	lw $t0, ($t0)		# load len(array)
	sw $t0, -4($fp)		# store len(array) to length
	
	# i = 1
	addi $t0, $0, 1
	sw $t0, -8($fp)		# store 1 to i
	
	# for i in range(1, length):
outer_loop:
	lw $t0, -8($fp)		# load i
	lw $t1, -4($fp)		# load length
	slt $t0, $t0, $t1	# is i < length?
	beq $t0, $0, end_outer	# if not, go to end_outer

	# key = array[i]
	lw $t0, 8($fp)		# load address of array
	lw $t1, -8($fp)		# load i
	sll $t1, $t1, 2		# i*4
	add $t0, $t0, $t1	# address in array + i*4
	lw $t0, 4($t0)		# load array[i]
	sw $t0, -12($fp)	# store array[i] to key
	
	# j = i-1
	lw $t0, -8($fp)		# load i
	addi $t0, $t0, -1	# i - 1
	sw $t0, -16($fp)	# store i - 1 to j
	
	# while j >= 0 and key < array[j]:
inner_loop:
	lw $t0, -16($fp)	# load j
	slt $t1, $t0, $0	# is j >= 0?
	bne $t1, $0, end_inner	# if not, go to end_inner
	
	lw $t0, -12($fp)	# load key
	lw $t1, 8($fp)		# load address of array
	lw $t2, -16($fp)	# load j
	sll $t2, $t2, 2		# j*4
	add $t1, $t1, $t2	# address in array + j*4
	lw $t1, 4($t1)		# load array[j]
	slt $t0, $t0, $t1	# is key < array[j]?
	beq $t0, $0, end_inner	# if not, go to end_inner

	# array[j+1] = array[j]
	lw $t0, 8($fp)		# load address of array
	lw $t1, -16($fp)	# load j
	sll $t1, $t1, 2		# j*4
	add $t0, $t0, $t1	# address in array + j*4
	lw $t1, 4($t0)		# load array[j]
	sw $t1, 8($t0)		# stores the value to the address in array + i*4 + 8	
	
	# j -= 1
	lw $t0, -16($fp)	# load j
	addi $t0, $t0, -1	# j - 1
	sw $t0, -16($fp)	# store j - 1 to j
	
	j inner_loop		# jump to the start of the inner loop
	
end_inner:
	# array[j+1] = key
	lw $t0, -12($fp)	# load key
	lw $t1, 8($fp)		# load address of array
	lw $t2, -16($fp)	# load j
	sll $t2, $t2, 2		# j*4
	add $t1, $t1, $t2	# address in array + j*4
	sw $t0, 8($t1)		# stores the value to the address in array + i*4 + 8
	
	# i += 1
	lw $t0, -8($fp)		# load i
	addi $t0, $t0, 1	# i + 1
	sw $t0, -8($fp)		# store i + 1
	
	j outer_loop		# jump to the start of the outer loop
	
end_outer:
	addi $sp, $sp, 16	# remove local var from the stack

	# restore saved $fp and $ra from the stack
	lw $fp, ($sp)		# restore $fp
	lw $ra, 4($sp)		# restore $ra
	addi $sp, $sp 8		# remove $fp and $ra from stack
	
	jr $ra			# return to caller
