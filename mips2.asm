.data
	length: .word 10
	nums: 	.word 1,2,3,4,5,6,7,8,9,10 
	target: .word 11
	notfound: .asciiz "Target not found"

.text 

main:
	addi $t5, $t5, 5
	
	ori $v0, $zero, 4
	la $a0, notfound
	syscall
	
exit:
	addi $t4, $t4, 4
	
	ori $v0, $zero, 10
	syscall
	
tt:
	addi $t4, $t4, 4
	
	ori $v0, $zero, 1
	add $a0, $zero, $t4
	syscall