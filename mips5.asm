.data
	length: .word 10
	nums: 	.word 1,2,3,4,5,6,7,8,9,10 
	target: .word 1
	notfound: .asciiz "Target not found"

.text 

main:
	addi $t0, $zero, 0
	addi $t5, $zero, 4
	lw $t1, length($zero)
	lw $t4, target($zero)

while:	
	sub $t3, $t1, $t0
	beq $t3, $zero, exit
	
	#b-a/2
	jal dividelength
	
	# if equal to 
	mul $t3, $t3, $t5
	lw $t6, nums($t3)

	beq $t4, $t6, printvalue
	#increase i 
	bgt $t4, $t6, halfup
	#increase j
	blt $t4, $t6, halfdown
	
	#end program
	li $v0, 10
	syscall

dividelength:
	add $t3, $t0, $t1
	addi $t2, $zero, 2
	div $t3, $t2
	mflo $t3
	jr $ra
	
halfup:
	addi $t0, $t0, 1
	j while
	
halfdown: 
	subi $t1, $t1, 1
	j while
	
printvalue: #print value
	li $v0 1
	add $a0, $zero, $t3
	syscall
	
	li $v0 10
	syscall

exit:	#exit program
	li $v0 4
	la $a0, notfound
	syscall
