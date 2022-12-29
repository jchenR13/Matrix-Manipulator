########### Justin Chen ############
########### juychen ################
########### 113097757 ################

###################################
##### DO NOT ADD A DATA SECTION ###
###################################

.text
.globl hash
hash:
	move $t0, $a0					# $t0 holds the values for the entire string
	li $t2, 0					# total ascii value of all chars in string		----SAVE----$t2
	addAsciiOfString:
		lb $t1, 0($t0)
		beq $t1, $0, exit_addAsciiOfString
		addi $t0, $t0, 1
		add $t2, $t2, $t1
		j addAsciiOfString
	exit_addAsciiOfString:
	move $t0, $a0
	move $v0, $t2
	li $t0, 0
	li $t1, 0
	li $t2, 0
	jr $ra

.globl isPrime
isPrime:
	move $t1, $a0
	li $t3, 2
	checkIsPrime:
		ble $t1, $t3, notPrime
		div $t1, $t3
		mfhi $t4
		beqz $t4, notPrime
		addi $t3, $t3, 1
		beq $t3, $t1, numIsPrime
		move $t1, $a0
		j checkIsPrime
	notPrime:
	li $v0, 0
	li $t1, 0
	li $t3, 0
	li $t4, 0
	jr $ra
	numIsPrime:
	li $v0, 1
	li $t1, 0
	li $t3, 0
	li $t4, 0
 	jr $ra

.globl lcm
lcm:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal gcd
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $t0, $a0
	move $t1, $a1
	move $t3, $v0
	mul $t4, $t0, $t1
	div $t4, $t3
	mflo $t5
	move $v0, $t5
	li $t0, 0
	li $t1, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	jr $ra
	
.globl gcd
gcd:
	move $t0, $a0
	move $t1, $a1
	blt $t0, $t1, secondInputIsLarger				# $a0 < $a1
	li $t0, 0
	li $t1, 0		
	move $t1, $a0							# $a0 > $a1
	move $t0, $a1
	secondInputIsLarger:
		beqz $t0, exit_secondInputIsLarger
		div $t1, $t0
		mfhi $t3
		move $t1, $t0
		move $t0, $t3
		j secondInputIsLarger
	exit_secondInputIsLarger:
	li $v0, 1
	move $v0, $t1
	li $t1, 0
	li $t3, 0
	li $t0, 0
	jr $ra

.globl pubkExp
pubkExp: 
	move $t4, $a0
	move $a1, $a0
	li $t7, 1
	randomNumberLoop:
	addiu $a1, $t4, -2
	li $v0, 42
	syscall
	addiu $a1, $t4, 2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	move $a1, $t4
	jal gcd
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	beq $a0, $t7, randomNumberLoop
	beq $v0, $t7, exit_randomNumberLoop
	j randomNumberLoop
	exit_randomNumberLoop:
	move $v0, $a0
	li $t4, 0
	li $t7, 0
	jr $ra

.globl prikExp
prikExp:
	move $t0, $a0					# x
	move $t1, $a1					# y					# x mod y
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal gcd
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	li $t3, 1
	bne $t3, $v0, inputsNotCoPrime
	move $t0, $a0					# x
	move $t1, $a1					# y
	li $t4, 0					# stores p(i-2)
	li $t7, 1					# stores p(i-1)
	li $t8, 0					# stores q(i-2)
	
	div $t1, $t0					# 26/15
	mfhi $t5					# 11
	mflo $t6					# 1
	move $t1, $t0					# y = 15
	move $t0, $t5					# x = 1
	move $t8, $t6					# q(i-2) = 1
	
	div $t1, $t0					# 15/11					
	mfhi $t5					# 4
	mflo $t6					# 1
	move $t1, $t0					# y = 11
	move $t0, $t5					# x = 4
	
	loopToFindModularInverse:
		mul $t3, $t7, $t8
		sub $t2, $t4, $t3
		isItPositive:
		bgtz $t2, positiveNumber
		add $t2, $t2, $a1
		j isItPositive
			positiveNumber:
			div $t2, $a1
			mfhi $2
			beqz $t5, exit_loopToFindModularInverse
			move $t4, $t7
			move $t7, $t2 
			move $t8, $t6
			div $t1, $t0
			mfhi $t5
			mflo $t6
			move $t1, $t0
			move $t0, $t5
			j loopToFindModularInverse
	exit_loopToFindModularInverse:
	move $v0, $t2
	jr $ra
	
	inputsNotCoPrime: 
	li $t7, -1
	move $v0, $t7
	jr $ra

.globl encrypt
encrypt:
	move $t0, $a0						# m
	move $t1, $a1						# p
	move $t3, $a2						# q
	
	mul $t5, $t1, $t3					# p * q
	addi $t1, $t1, -1
	addi $t3, $t3, -1
	
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	move $a0, $t1
	move $a1, $t3
	jal lcm
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	move $t6, $v0						# lcm of (p1)(q-1) = k
	
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	move $a0, $t6
	jal pubkExp
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	move $t7, $v0						# e
	
	move $t0, $a0						# m
	move $t1, $a1						# p
	move $t3, $a2						# q
	
	mul $t5, $t1, $t3					# p * q
	
	move $t8, $t0
	li $t9, 1
	loopForExponent:
		mul $t8, $t8, $t0
		div $t8, $t5
		mfhi $t2
		move $t8, $t2
		addi $t9, $t9, 1
		blt $t9, $t7, loopForExponent
		j exit_loopForExponent
	exit_loopForExponent:
	move $v0, $t8
	move $v1, $t7
	jr $ra

.globl decrypt
decrypt:
	move $t0, $a0						# c
	move $t1, $a1						# e
	move $t2, $a2						# p
	move $t3, $a3						# q
	
	mul $t4, $t2, $t3					# p * q
	addi $t2, $t2, -1					# p-1
	addi $t3, $t3, -1					# q-1
	
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a3, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	move $a0, $t2
	move $a1, $t3
	jal lcm
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	move $t5, $v0						# lcm of (p1)(q-1) = k
	
	move $t0, $a0						# c
	move $t1, $a1						# e
	move $t2, $a2						# p
	move $t3, $a3						# q
	
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a3, 12($sp)
	sw $a2, 8($sp)
	sw $a1, 4($sp)
	sw $a0, 0($sp)
	move $a0, $t1
	move $a1, $t5
	jal prikExp
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	move $t6, $v0						# d
	
	move $t0, $a0						# c
	move $t1, $a1						# e
	move $t2, $a2						# p
	move $t3, $a3						# q
	
	mul $t4, $t2, $t3					# p * q
	
	move $t7, $t0
	li $t9, 1
	li $t8, 0
	exponentialLoop:
		mul $t7, $t7, $t0
		div $t7, $t4
		mfhi $t8
		move $t7, $t8
		addi $t9, $t9, 1
		blt $t9, $t6, exponentialLoop
		j exit_exponentialLoop
	exit_exponentialLoop:
	move $v0, $t7
	jr $ra
