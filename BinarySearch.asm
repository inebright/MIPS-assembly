.data
	length: .word 10  #length of array
	nums: 	.word 1,2,3,4,5,6,7,8,9,10 
	target: .word 11  #search word
	notfound: .asciiz "Target not found"

.text 

main:
	addi $t0, $zero, 0 #initialiszing start of array
	addi $t5, $zero, 4 
	
	lui $1, 0x00001001	#loading address of length
	ori $17,$1,0x00000000
	lw $t1, 0($s1)	#load value of length in array $t1
	
	lui $1, 0x00001001	#loading address of target
	ori $18, $1, 0x0000002c
	lw $t4, 0($s2)	#load value of target in $t4
while:	
	#if a<0, exit code
	sub $t3, $t1, $t0
	beq $t3, $zero, exit
	
	#i=(b+a)/2
	jal dividelength
	
	# mul to get array in addr 
	mul $t3, $t3, $t5
	
	#$t6 = nums[i]
	lui $1, 0x00001001
	add $1, $1, $11
	lw $t6, 0x00000004($1)
	
	#if target = nums[i], end code and print address
	beq $t4, $t6, printvalue
	
	#else if target>nums[i], i=i+1
	slt $at, $t6, $t4
	bne $at, $zero, halfup
	
	#else if target<nums[i], i=i-1
	slt $at, $t4, $t6
	bne $at, $zero, halfdown
	
	#end program
	ori $v0, $zero, 10
	syscall

dividelength:	#func to get i = a+b/2
	add $t3, $t0, $t1
	addi $t2, $zero, 2
	div $t3, $t2
	mflo $t3
	jr $ra
	
halfup:	#i = i-1
	addi $t0, $t0, 1
	j while #return to while with new array indices
	
halfdown: #i = i-1
	addi $t7, $zero, 1
	sub $t1, $t1, $t7
	j while	#return to while with new array indices
	
printvalue: #print value
	addi $t2, $zero, 4
	div $t3, $t2
	mflo $t3
	ori $v0, $zero, 1
	add $a0, $zero, $t3
	syscall
	
	ori $v0, $zero, 10
	syscall

exit:	#exit program
	ori $v0, $zero, 4
	lui $1, 0x00001001
	ori $4, $1, 0x00000030
	syscall
	
	ori $v0, $zero, 10
	syscall
