.data
	

.text

li $t0, 0xffff0000

gameLoop:
	
	lw $t1, ($t0)
	beq $t1, $zero, checkAgain
	
	lw $t2, 4($t0)
	
	
checkAgain:
	j gameLoop

Exit:
	li $v0 10
	syscall