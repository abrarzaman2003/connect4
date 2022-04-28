




makeCircle: #a0 -> x pos, a1 -> ypos $a3 --> color
   	lw  	$t0, displayAddress
    	addi	$t0, $t0, 49280 #(32 rows * 256 units * 4) + (16 units of left padding * 4 + 16 units to the center * 4) 
    	
    	
    	
    	
    	sll	$a1, $a1, 15
    	
    	
    	
    	sll	$a0, $a0, 7
    	    	
    	add 	$t0, $t0, $a1 	
    	add 	$t0, $t0, $a0
    	
    	sw	$t1, ($t0)
    	
    	
    	
    	
    	
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, 0
    	li	$a2, 10
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, 1 #<---- row number
    	li	$a2, 10 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, 2 #<---- row number
    	li	$a2, 10 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, 3 #<---- row number
    	li	$a2, 10 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, 4 #<---- row number
    	li	$a2, 9 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, 5 #<---- row number
    	li	$a2, 9 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, 6 #<---- row number
    	li	$a2, 8 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, 7 #<---- row number
    	li	$a2, 7 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, 8 #<---- row number
    	li	$a2, 6 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, 9 #<---- row number
    	li	$a2, 5 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, 10 #<---- row number
    	li	$a2, 3 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, -1 #<---- row number
    	li	$a2, 10 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, -2 #<---- row number
    	li	$a2, 10 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, -3 #<---- row number
    	li	$a2, 10 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, -4 #<---- row number
    	li	$a2, 9 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, -5 #<---- row number
    	li	$a2, 9 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, -6 #<---- row number
    	li	$a2, 8 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, -7 #<---- row number
    	li	$a2, 7 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, -8 #<---- row number
    	li	$a2, 6 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, -9 #<---- row number
    	li	$a2, 5 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	addiu   $sp, $sp, -12 #allocates stack memory for the return address
    	sw	$ra, ($sp)
    	sw	$a0, 4($sp)
    	sw	$a1, 8($sp)
    	move 	$a0, $t0
    	li	$a1, -10 #<---- row number
    	li	$a2, 3 #<---- row size
    	jal	drawCircleRow
    	lw	$ra, ($sp)
    	lw	$a0, 4($sp)
    	lw	$a1, 8($sp)
    	addiu	$sp, $sp, 12 #reallocates the stack memory
    	
    	
    	
    	
    	jr	$ra
    		
    	
drawCircleRow: #$a0-> base address $a1-> row num $a2->row size
	
	sll	$a1, $a1, 10
	add	$a0, $a0, $a1
	addi	$t9, $a0, 0
	
	li	$t8, 0
	
	sw	$a3, ($a0)
	
	
	loop:
		
		addi 	$a0, $a0, 4
		sw  	$a3, ($a0)
		
		
		addi	$t9, $t9, -4
		sw	$a3, ($t9)
		
		addi 	$t8, $t8, 1
		
		bne	$t8, $a2, loop
	
	
	jr $ra