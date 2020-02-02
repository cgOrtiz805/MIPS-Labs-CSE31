
	.text

main:
	li $a0, 0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 1
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 196
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, -1
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, -452
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 2
	jal mystery
	move $a0, $v0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall

	li $a0, 3
	jal mystery
	move $a0, $v0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall

	li 	$v0, 10		# terminate program
	syscall

putDec:   #we want to print $a0

	bne $a0, $0, checker
	zero:
		li $a0, 0
		li $v0, 11
		syscall
		jr $ra
	
	checker:
		slt $t0, $a0, $zero
		beq $t0, 0, loop # if a0 is positive go to loop
		
	negative: 
		move $t0, $a0
		li $a0, '-'
		li $v0, 11
		syscall
		move $a0, $t0
		sub $a0, $0, $a0
	
	loop: 
		li $s7, 10
		beq $a0, $0, return
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		
		remu $t7, $a0, $s7
		divu $a0, $a0, $s7
		addi $t7, $t7, 48
		
		sb $7, 4($sp)
		jal loop
		lw $ra, 0($sp)
		lb $t7, 4($sp)
		move $a0, $t7
		li $v0, 11
		syscall
		addi $sp, $sp, 8
		jr $ra
		
	return:
		jr $ra
	



	## FILL IN ##
	
	

mystery: bne $0, $a0, recur 	#  if $a0 !=0 go to recur
 	li $v0, 0 		#
 	jr $ra 			#
 recur: sub $sp, $sp, 8 	#
 	sw $ra, 4($sp) 	#
 	sub $a0, $a0, 1 	#
 	jal mystery 		#
 	sw $v0, 0($sp) 	#
 	jal mystery 		#
 	lw $t0, 0($sp) 	#
 	addu $v0, $v0, $t0 	#
 	addu $v0, $v0, 1 	#
 	add $a0, $a0, 1 	#
 	lw $ra, 4($sp) 	#
 	add $sp, $sp, 8 	#
 	jr $ra 			#
