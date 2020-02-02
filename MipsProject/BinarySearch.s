#CSE_031
#PROJECT_2
#SUMMER_2018

#Project Partners/Programmers:
#Jacques Fracchia
#Cristian Ortiz




.data 

original_list: .space 100 
sorted_list: .space 100

str0: .asciiz "Enter size of list (between 1 and 25): "
str1: .asciiz "Enter one list element: \n"
str2: .asciiz "Content of original list: "
str3: .asciiz "Enter a key to search for: "
str4: .asciiz "Content of sorted list: "
strYes: .asciiz "Key found!"
strNo: .asciiz "Key not found!"
space: .asciiz " "
nextline: .asciiz "\n"


.text 

#This is the main program.
#It first asks user to enter the size of a list.
#It then asks user to input the elements of the list, one at a time.
#It then calls printList to print out content of the list.
#It then calls inSort to perform insertion sort
#It then asks user to enter a search key and calls bSearch on the sorted list.
#It then prints out search result based on return value of bSearch
main: 
	addi $sp, $sp -8
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, str0 
	syscall 
	li $v0, 5	#read size of list from user
	syscall
	move $s0, $v0
	move $t0, $0
	la $s1, original_list
loop_in:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	li $v0, 5	#read elements from user
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	move $a0, $s1
	move $a1, $s0
	
	jal inSort	#Call inSort to perform insertion sort in original list
	
	sw $v0, 4($sp)
	li $v0, 4 
	la $a0, str2 
	syscall 
	la $a0, original_list
	move $a1, $s0
	jal printList	#Print original list
	li $v0, 4 
	la $a0, str4 
	syscall 
	lw $a0, 4($sp)
	jal printList	#Print sorted list
	
	li $v0, 4 
	la $a0, str3 
	syscall 
	li $v0, 5	#read search key from user
	syscall
	move $a3, $v0
	lw $a0, 4($sp)
	jal bSearch	#call bSearch to perform binary search
	
	beq $v0, $0, notFound
	li $v0, 4 
	la $a0, strYes 
	syscall 
	j end
	
notFound:
	li $v0, 4 
	la $a0, strNo 
	syscall 
end:
	lw $ra, 0($sp)
	addi $sp, $sp 8
	li $v0, 10 
	syscall
	
	
#printList takes in a list and its size as arguments. 
#It prints all the elements in one line.
printList:
	addi $sp, $sp, -4	#make space in stack for arr.
	sw $a0, 0($sp)		#save original array in stack.
	move $t0, $a0		#copy Array to temp register $t0.
	move $t1, $a1		#copy size of array to $t1.
	add $t2, $zero, $zero	#create "int i = 0;" 4 for loop.
	
printElement:
	beq $t1, $t2, exit	#if (arrSize == 0) exit.
	addi $v0, $zero, 1	#system call code for print_int.
	lw $a0, 0($t0)		#load argument for what is in $t0(intArr).
	syscall			#print the int currently in $t0.
	
	addi $v0, $zero, 4 	#system call code for print_str.
	la $a0, space		#copy RAM address of " " into reg $a0
	syscall			#system call ($v0=4) print whats in $a0 (space).
	
	addi $t0, $t0, 4	#add 4 to array to incriment next element.
	addi $t2, $t2, 1	#add one to int i for the for loop.
	j printElement
exit:
	addi $v0, $zero, 4	#system call code for print_str.
	la $a0, nextline	#load "\n" nextline address into $a0.
	syscall			#print next line to indent.
	
	lw $a0, 0($sp)		#restore array to original in $a0
	addi $sp, $sp, 4	#restore stack.
	jr $ra			#leave function
	
	
#inSort takes in a list and it size as arguments. 
#It performs INSERTION sort in ascending order and returns a new sorted list
#You may use the pre-defined sorted_list to store the result





inSort:
	
	#pro:

	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	sw $s2, 16($sp)
	sw $s3, 20($sp)
	sw $s4, 24($sp)
	sw $s5, 28($sp)

copyArr:
	la, $t9, original_list
	la, $t8, sorted_list			#create a copy of the original list in sorted list to keep original intact
	li $t7, 0
	
	
	copy_start:
		beq $t7, $a1, copyEnd 	#	for (int i = 0; i < arrSize; i++){
		lw $t5, 0($t9) 		
		sw $t5, 0($t8) 			#	sorted_list[i] = original_list[i]

		addi $t9, $t9, 4 		#	++original_list
		addi $t8, $t8, 4 		#	++sorted_list
		addi $t7, $t7, 1 		#	++i
		j copy_start		
copyEnd:
		


	la $t8, sorted_list		#put pointer back at the beginning of sorted_list[arr]
	move $s0, $t8
	move $s1, $a1
	li $t0, 1		
	
sortForLoop:
	move $s0, $t8		#copy overy in progress arr
	beq $s1, $t0, allSorted	#if sizeSortedArr == ArrSize, exit
	move $t1, $t0		#$t1 = list of sorted size

sortWhileLoop:		
	move $s0, $t8		#restore $s0 with arr
	mul $t2, $t1, 4		#prepare incriment value for next arr[index],
				#multiplies 4 * sortedSize = location of next element to sort	
	add $s0, $s0, $t2	#incriment arr[index] (restore to next element to sort)
	beq $t1, 0, nextElement	#if list is all sorted next
	lw $s2, 0($s0)		
	lw $s3, -4($s0)		#Prepare next two elements to check
	
	bge $s2, $s3, nextElement	#compare the two, if next element is greater in list add in, otherwise swap loop
	lw $s4, 0($s0)		
	sw $s3, 0($s0)		#swaps the element to sort, with element to the left since new element is smaller
	sw $s4, -4($s0)
	addi $t1, $t1, -1	#decrease the array index to prepare next element to be compared to, if smaller, will swap in loop
	j sortWhileLoop

nextElement:
	addi $t0, $t0, 1	#added in new element in correct spot, incriment to next element to sort.
	j sortForLoop		#continue to sort rest of list

allSorted:
	la $v0, 0($s0)		#returns new sorted array
	
				#epi:
	lw $s5, 28($sp)
	lw $s4, 24($sp)
	lw $s3, 20($sp)
	lw $s2, 16($sp)
	lw $s1, 12($sp)
	lw $s0, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 32
	
	jr $ra			#sorted list
	
#bSearch takes in a list, its size, and a search key as arguments.
#It performs binary search RECURSIVELY to look for the search key.
#It will return a 1 if the key is found, or a 0 otherwise.
#Note: you MUST NOT use iterative approach in this function.

bSearch:

	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a3
	move $s3, $a2
	li $s5, 0

	addi $s1, $s1, -1
	bgt $s3, $s1, rightcheck
	
binLoop:
	blt $s1, $s3, binfalse 
	sub $t0, $s1, $s3
	div $t0, $t0, 2
	add $s5, $s3, $t0
	
	sll $t1, $s5, 2
	add $t2, $s0, $t1
	lw $t1, ($t2)
	
	beq $t1, $s2, bintrue
	
	li $t4, 0
	li $t5, 0
	
	slti $t4, $a3, 1
	slti $t5, $a1, 1
	
	add $t4, $t4, $t5
	li $t5, 2
	beq $t4, $t5, binfalse
	
	bgt $t1, $s2, binsgt
	blt $t1, $s2, binslt
	
	
	
binsgt:
	sub $a1, $s5, $s3
	jal bSearch
	
binslt:
	addi $a2, $s5, 1
	jal bSearch

	rightcheck:
		sll $t6, $s1, 2
		add $t6, $s0, $t6
		lw $t7, ($t6)
		beq $a3, $t7, bintrue
		
	j binLoop
	
bintrue:

	lw $a3, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	li $v0, 1
	jr $ra
	
binfalse:

	lw $a3, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	li $v0, 0
	jr $ra
	

	
	
	
	
	
	
	
	
	
