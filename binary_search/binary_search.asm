# Searches for the given integer in a sorted array using the Binary Search algorithm.

# Data section to store the global variables required
	.data
newline: .asciiz "\n"
	
# Instruction set begins here
	.text
	.globl main
	.globl binary_search
main:
	# set $fp and make space for locals
	addi $fp, $sp, 0	# copy $sp into $fp
	addi $sp, $sp, -8	# 2 local variable = 8 bytes

	# -8($fp) <- index
	# -4($fp) <- input

	# input = [1, 5, 10, 11, 12]
	addi $v0, $0, 9		# allocate memory
	addi $t0, $0, 5		# 5 elements
	sll $t1, $t0, 2		# 5*4
	addi $a0, $t1, 4	# allocate(5*4)+4 bytes
	syscall
	sw $v0, -4($fp)		# input stores the first byte of the array address
	sw $t0, ($v0)		# stores the length of array to address stored in input

	lw $t0, -4($fp)		# load address of input
	addi $t1, $0, 1
	sw $t1, 4($t0)		# input[0] = 1
	addi $t1, $0, 5
	sw $t1, 8($t0)		# input[1] = 5
	addi $t1, $0, 10
	sw $t1, 12($t0)		# input[2] = 10
	addi $t1, $0, 11
	sw $t1, 16($t0)		# input[3] = 11
	addi $t1, $0, 12
	sw $t1, 20($t0)		# input[4] = 12

	# index = binary_search(input, 11, 0, len(input) - 1)
	# allocate arguments in the stack and call binary_search(array, 11, 0, len(input) - 1)
	addi $sp, $sp, -16 	# push 4 arguments, 4*4 = 16 bytes
	
	# first argument = array
	lw $t0, -4($fp)		# load address of input
	sw $t0, 12($sp)
	
	# second argument = item
	addi $t0, $0, 11	# item = 11
	sw $t0, 8($sp)
	
	# third argument = low
	sw $0, 4($sp)		# low = 0
	
	# fourth argument = high
	lw $t0, -4($fp)		# load address of input
	lw $t0, ($t0)		# load len(input)
	addi $t0, $t0, -1	# len(input) - 1
	sw $t0, ($sp)		# high = len(input) - 1

	jal binary_search	# call binary_search(array, 11, 0, len(input) - 1)

	addi $sp, $sp, 16	# remove arguments from stack
	
	sw $v0, -8($fp)		# store return value to index

	# print index
	addi $v0, $0, 1
	lw $a0, -8($fp)
	syscall

	# print a new line
	addi $v0, $0, 4
	la $a0, newline
	syscall
	
	addi $sp, $sp, 8	# remove local variables

	# exit program
	addi $v0, $0, 10
	syscall
	
binary_search:
	# save $ra and $fp in the stack
	addi $sp, $sp, -8	# allocate 8 bytes
	sw $ra, 4($sp)		# save $ra
	sw $fp, ($sp)		# save $fp

	addi $fp, $sp, 0	# copy sp to fp
	
	addi $sp, $sp, -4	# allocate 4 bytes for 1 local variable

	# -4($fp) <- mid
	# ($fp) <-  saved $fp
	# 4($fp) <- saved $ra
	# 8($fp) <- high
	# 12($fp) <- low
	# 16($fp) <- item
	# 20($fp) <- array

	# if low > high
	lw $t0, 12($fp)		# load low
	lw $t1, 8($fp)		# load high
	slt $t0, $t1, $t0	# is low > high?
	beq $t0, $0, else	# if not, go to else
	
	# return -1
	addi $v0, $0, -1	# store -1 in $v0
	
	addi $sp, $sp, 4	# remove local variable from stack
	
	# restore saved $fp and $ra from the stack
	lw $fp, ($sp)		# restore $fp
	lw $ra, 4($sp)		# restore $ra
	addi $sp, $sp, 8	# remove $fp and $ra from stack
	
	jr $ra			# return to caller

else:
	# mid = (high + low) // 2
	lw $t0, 8($fp)		# load high
	lw $t1, 12($fp)		# load low
	add $t2, $t0, $t1	# high + low
	addi $t3, $0, 2
	div $t2, $t3
	mflo $t4		# (high + low) // 2
	sw $t4, -4($fp)		# mid = (high + low) // 2

if_equal_target:
	# if array[mid] == item:	
	lw $t0, 20($fp)		# load address of array
	lw $t1, -4($fp)		# load mid
	sll $t1, $t1, 2		# mid*4
	add $t2, $t0, $t1	# address in array + mid*4
	lw $t0, 4($t2)		# load array[mid]

	lw $t1, 16($fp)		# load item
	bne $t0, $t1, elif_gt_target	# if array[mid] != item, go to elif_gt_target
	
	# return mid
	lw $v0, -4($fp)
	
	addi $sp, $sp, 4	# remove local variable from stack
	
	# restore saved $fp and $ra from the stack
	lw $fp, ($sp)		# restore $fp
	lw $ra, 4($sp)		# restore $ra
	addi $sp, $sp, 8	# remove $fp and $ra from stack
	
	jr $ra			# return to caller

elif_gt_target:
	# elif array[mid] > item:
	lw $t0, 20($fp)		# load address of array
	lw $t1, -4($fp)		# load mid
	sll $t1, $t1, 2		# mid*4
	add $t2, $t0, $t1	# address in array + mid*4
	lw $t0, 4($t2)		# load array[mid]

	lw $t1, 16($fp)		# load item
	slt $t0, $t1, $t0	# is array[mid] > item?
	beq $t0, $0, else_lt_target	# if no, go to else_lt_target

	# return binary_search(array, item, low, mid-1)
	# allocate arguments in the stack and call binary_search(array, item, low, mid-1)
	addi $sp, $sp, -16 	# push 4 arguments, 4*4 = 16 bytes
	
	# first argument = array
	lw $t0, 20($fp)		# load address of array
	sw $t0, 12($sp)
	
	# second argument = item
	lw $t0, 16($fp)		# load item
	sw $t0, 8($sp)
	
	# third argument = low
	lw $t0, 12($fp)		# load low
	sw $t0, 4($sp)
	
	# fourth argument = mid - 1
	lw $t0, -4($fp)		# load mid
	addi $t0, $t0, -1	# mid - 1
	sw $t0, ($sp)		# high = mid - 1

	jal binary_search	# call binary_search(array, item, low, mid-1)

	addi $sp, $sp, 16	# remove arguments from stack
	addi $sp, $sp, 4	# remove local variable from stack
	
	# restore saved $fp and $ra from the stack
	lw $fp, ($sp)		# restore $fp
	lw $ra, 4($sp)		# restore $ra
	addi $sp, $sp, 8	# remove $fp and $ra from stack
	
	# return to caller
	jr $ra
	
else_lt_target:
	# return binary_search(array, item, mid+1, high)
	# allocate arguments in the stack and call binary_search(array, item, mid + 1, high)
	addi $sp, $sp, -16 	# push 4 arguments, 4*4 = 16 bytes
	
	# first argument = array
	lw $t0, 20($fp)		# load array
	sw $t0, 12($sp)
	
	# second argument = item
	lw $t0, 16($fp)		# load item
	sw $t0, 8($sp)
	
	# third argument = mid + 1
	lw $t0, -4($fp)		# load mid
	addi $t0, $t0, 1	# mid + 1
	sw $t0, 4($sp)		# low = mid + 1
	
	# fourth argument = high
	lw $t0, 8($fp)		# load high
	sw $t0, ($sp)

	jal binary_search	# call binary_search(array, item, mid + 1, high)
	
	addi $sp, $sp, 16	# remove arguments from stack
	addi $sp, $sp, 4	# remove local variable from stack
	
	# restore saved $fp and $ra from the stack
	lw $fp, ($sp)		# restore $fp
	lw $ra, 4($sp)		# restore $ra
	addi $sp, $sp, 8	# remove $fp and $ra from stack

	jr $ra			# return to caller
