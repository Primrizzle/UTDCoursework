# The following is an implementation of the Merge Sort algorithm in MIPS 

Ashley Primrose - AMP190009
SE2340.002 - Zhao
Project 3 - MergeSort
4.26.23

MergeSort.asm
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.data
listA: 		.space 128	#space to save first array 
listAarray: 	.word  0 	#first array size
listB:		.space 128	#space to save second array
listBarray:	.word 0		#second array size
mergedlist: 	.space 128	#space for merged lists
listSize: 	.word 8		#list size
list:           .word 		6,5,9,1,7,0,-3,2
.text
.globl main

main:
	li $s0, 1		#length = 1
	lw $s1, listSize	#n = list size
mSortLoop:
	bge $s0, $s1, printList	#if length >= n, end
	li  $s2, 0		#i = 0
while1:
	bge $s2, $s1, endWhile1	#if i >= n, end While loop
	move $s3, $s2		#L1 = i
	add  $s5, $s2, $s0	#L2 = i + length
	addi $s4, $s5, -1	#R2 = i + length - 1
	add  $s6, $s5, $s0	#i + 2*length
	addi $s6, $s6, -1	#R2 = i + 2*length - 1
	bge  $s5, $s1, printList #if L2 >= n, end loop
	blt  $s6, $s1, doMerge	#if R2 < n, go to merge
	addi $s6, $s1, -1	#else, R2 = n - 1
doMerge: 
	move $t0, $s3		#j = L1
	li   $t1, 0		#k = 0 
forL1:
	bgt  $t0, $s4, endForL1 #if j > R1, end for
	sll  $t2, $t0, 2	#j*4
	lw   $t3, list($t2)	#load list[j]
	sll  $t2, $t1, 2	#k*4
	sw   $t3, listA($t2)	#list[k] = list[j]
	addi $t0, $t0, 1	#j++
	addi $t1, $t1, 1	#k++
	j    forL1
endForL1:
	sw   $t1, listAarray	#save size for list1
	move $t0, $s5		#j = L2
	li   $t1, 0		#k = 0
forL2: 
	bgt  $t0, $s6, endForL2 #if j> R2, end for
	sll  $t2, $t0, 2	# j*4
	lw   $t3, list($t2)	#load list[j]
	sll  $t2, $t1, 2	#k*4
	sw   $t3, listB($t2)	#listA = list[j]
	addi $t0, $t0,1		#j++
	addi $t1, $t1, 1	#k++
	j    forL2
endForL2:
	sw   $t1, listBarray	#save size for listB	
	la   $a0, listA		#load first array pointer
	lw   $a1, listAarray	#load the size of the first array
	la   $a2, listB		#load second array pointer
	lw   $a3, listBarray	#load the size of the second array
	la   $t0, mergedlist	#load merge array pointer
	addi $sp, $sp, -4	#allocate space in stack to save argument
	sw   $t0, 0($sp)	#save last argument in stack
	jal  merge		#merge
	addi $sp, $sp, 4	#remove space from stack
	sub  $t1, $s6, $s3	# R2 - L1
	addi $t1, $t1, 1 	# R2 - L1 + 1
	li   $t0, 0 		#j = 0 
for1: 
	bge  $t0, $t1, endFor1	#if j >- R2 - L1 + 1, end for
	sll  $t2, $t0, 2	# j*4 
	lw   $t3, mergedlist($t2) #load mergedlist[j]
	add  $t2, $t0, $s2	#i + j
	sll  $t2, $t2, 2	#(i + j)*4
	sw   $t3, list($t2) 	#list[i + j] = mergedlist[j]
	addi $t0, $t0, 1	#j++
	j    for1
endFor1:
	sll  $t0, $s0, 1	#length*2
	add  $s2, $s2, $t0	#i = i + 2*length
	j    while1
endWhile1: 
	sll  $s0, $s0, 1	#length = 2*length
	j    mSortLoop	
printList:
	lw   $t1, listsize	#list size
	la   $t2, list		#point to start of list
	li   $t0, 0		#list index
looppr:				#repeat to print all elements
	beq  $t0, $t1, terminate # if i >= n, exit loop
	lw   $a0, 0($t2)	#else load element from list
	li   $v0, 1		#prints list element
	syscall
	li   $a0, 32		#load ascii space
	li   $v0, 11		#syscall to print character
	syscall
	add  $t2, $t2, 4	#next element in the list	
	add  $t0, $t0, 1	#index ++
	j    looppr
terminate: 
	li   $v0, 10
	syscall 
merge:		
	lw   $t4, 0($sp)	#load merge list pointer from stack
	li   $t0, 0 		#i
	li   $t1, 0		#j
loop:
	beq  $t0, $a1, loop1	#if i >= n1, exit loop
	lw   $t2, 0($a0)	#load elemetn from array 1
	beq  $t1, $a3, loop1	# if j >= n2, exit the loop
	lw   $t3, 0($a2)	#load element from array 2
	ble  $t2, $t3, add1	#if arr1[i] <= arr2[j], add from first
	sw   $t3, 0($t4)	#else, adds from second to merge list
	add  $t1, $t1, 1	#j++
	add  $a2, $a2, 4	#next element of list2
	j    second
add1: 
	sw   $t2, 0($t4)	#save from listA to merged list
	add  $t0, $t0, 1	#i++
	add  $a0, $a0, 4	#next element of listA
second: 
	add  $t4, $t4, 4	
	j    loop	
loop1: 				#if listA has remaining elements, add them to megerdlist
	beq  $t0, $a1, loop2	#if listA empty, go to second
	lw   $t2, 0($a0)	#save in first merge list
	sw   $t2, 0($t4)	#save in merged list 
	add  $a0, $a0, 4	#next element in listA
	add  $t4, $t4, 4	#next element in merged list
	add  $t0, $t0, 1	#i++
	j    loop1		#repeat to add all elements in listA
loop2: 				#if listA has remaining elements, add them to megerdlist
	beq  $t1, $a1, loopex	#if listB empty, end
	lw   $t2, 0($a2)	#load element from listB
	sw   $t2, 0($t4)	#save in merged list
	add  $a2, $a2, 4	#next element in listB	
	add  $t4, $t4, 4	#next element in merged list
	add  $t1, $t1, 1	#j++
	j    loop2
loopex:
	jr   $ra	
	
