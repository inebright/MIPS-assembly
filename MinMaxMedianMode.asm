.data
sums:       .word     92, 31, 92, 6, 54, 54, 62, 33, 8, 52
length:    .word 10
space:     .asciiz   " "
min:       .word 0   #saved in s5	
max:       .word 0   #saved in s6
median:    .word 0   #saved in s7
# $t0 => base address of sums (&sums[0])
# $t1 => number of elements in sums (n)
# $v0 => i
.text
.globl main

main:lui     $1, 0x00001001
    ori     $8, $1, 0x00000000   	# set the starting address of the array in $s0
    lui     $1, 0x00001001
    lw      $9, 0x00000028($1)
    jal     gnome           		# Perform gnome sort
    ori     $t2, $zero, 0
    lw	    $21, 0x00000000($8)		#This contains min
    lw	    $22, 0x00000014($8)		#This contains median
    lw	    $23, 0x00000028($8)		#This contains max
 
       
print:beq     $t2, $t1, exit       	# exit if reached the max count
     lw      $a0, 0($t0)          	# get the element from the sumsay
     ori     $v0, $0, 1           	# $v0 = 1 to print an int value
     syscall
     lui     $1, 0x00001001
     ori     $4, $1, 0x0000002c
     ori     $v0, $0, 4           	# $v0 = 4 to print ascii
     syscall
     addiu   $t0, $t0, 4          	# increment the index by 4
     addiu   $t2, $t2, 1          	# increment the count by 1
     j       print
     
exit:ori     $v0, $0, 4
     syscall
     ori     $v0, $0, 10          	# set command to stop program,
     syscall

gnome:
     addiu   $sp, $sp, -4
     sw      $ra, 0($sp)          	# store $ra into the stack
     sll     $t1, $t1, 2          	# count = count * 2
     ori     $v0, $zero, 0              # int i = 0
     
loop:slt     $t3, $v0, $t1        	# if (i < n) => $t3 = 1
     beq     $t3, $zero, end      	# while (i < n) {
     bne     $v0, $zero, comp  		# if (i == 0)
     addiu   $v0, $v0, 4          	# i = i + 1
     
comp:addu    $t2, $t0, $v0        	# $s2 = &sums[i]
     lw      $t4, -4($t2)         	# $t4 = sums[i-1]
     lw      $t5, 0($t2)          	# $t5 = sums[i]
     slt     $1, $13, $12       	# swap if (nums[i] < nums[i-1])
     bne     $at, $zero, swap       	# swap if (sums[i] < sums[i-1])
     addiu   $v0, $v0, 4          	# i = i+ 1
     j       loop

swap:sw      $t4, 0($t2)          	# swap (sums[i], sums[i-1])
     sw      $t5, -4($t2)
     addiu   $v0, $v0, -4         	# i = i - 1
     j       loop
     
end:srl     $t1, $t1, 2
    lw      $31, 0x00000000($29)         # copy from stack to $ra
    addi    $sp, $sp, 4           	# increment stack pointer by 4
    jr      $ra                   	# return to main
