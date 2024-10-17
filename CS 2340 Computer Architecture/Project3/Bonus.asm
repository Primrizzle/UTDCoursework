Ashley Primrose - AMP190009
SE 2340.002 - Zhang
Project 3 - MergeSort
4.26.23

Bonus.asm
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.data	
		.globl	count
count:		.word   8		
		.globl 	list		
list:		.word	-2,3,12,0,10,-3,9,5
		.globl  str
str:   		.asciiz "The result is:"
		.globl  space
space:  	.asciiz " "
        	.globl  newln
newln:  	.asciiz "\n"
		.align  2
 
.text 
.globl main
main:
	
	lui $at, 0x1001 	#get start address of the data area
	ori $t3, $at, 4 	#load address of -2 from the array
	lui $at, 0x1001 	#load start address of the data area
	lw  $t6, 0($at) 	#get count value
	sll $t4, $t6, 2 	#multiply count by 4 to get 32
	addu $s4, $0, $t4 	#make value absolute
	sra $t5, $t6, 1 	#divide count by 2 to get 4
	add $t4, $t4, $t3 	
	sll $t5, $t5, 2 	
	add $t5, $t5, $t3 	#get address of 10 in the array
	addi $t4, $t4, -4 	#get address of 5 in the array
loop:	lw $t7, 0($t3)		#get -2 from the array
	lw $s0, 0($t4)		#get 5 from the array
	sw $s0, 0($t3)		#replace 5 with -2
	sw $t7, 0($t4)		#replace -2 with 5
	addi $t3, $t3, 4	#get address of 3 from the array
	sub $s1, $t3, $t5	#find 10 - 3 
	bne $s1, $0, loop	#check if 0 reached
	ori $v0, $0, 4 		
	la $a0, str
        	syscall     	#print string         	
        li   	$15, 0 		
print: 	li   	$v0, 4 		
        la  	$a0, space 	
        	syscall		#print space			
       	lw   	$a0, list($15)		
       	li   	$v0, 1 		
       		syscall		#print               		
        addi 	$15, $15, 4 			
        slt  	$8, $15, $20	
        bnez 	$8, print 	 
        li   	$v0, 4 
       	la   	$a0, newln			
        	syscall		#print newline character			
       	li   	$v0, 10		
   		syscall 	#exit        
