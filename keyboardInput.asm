.data
	
stateArray: 		.word 	0x05050505, 0x00050505
.text

li $t0, 0xffff0000

gameLoop:
	li	$s0, 7
	lw $t1, ($t0)
	beq $t1, $zero, checkAgain
	
	lw $t2, 4($t0)
	subi $t2, $t2, 48
	
	lbu $t4 stateArray($s0)
	lbu $t3, stateArray($t2)
	addi $t3, $t3, -1
	not  $t4, $t4
	
	sb  $t4 stateArray($s0)
	sb  $t3, stateArray($t2)
	
	
	
checkAgain:
	j gameLoop

Exit:
	li $v0 10
	syscall