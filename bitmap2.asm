#bitmap settings: 2by2 unit size, 512 by 512 display size

.data
  displayAddress:	.word	0x10008000 # base address of the display
  heightMap: 		.word 	0x05050505, 0x00050505
  board:		.space	48
  
  
  
.text
  lw  $t0, displayAddress	# $t0 stores the base address for display
  li  $t1, 0xfed700	# $t1 stores the yellow chip color
  li  $t2, 0xff00000	# $t2 stores the red chip color
  li  $t3, 0x0020fb	# $t3 stores the primary color of the board
  li  $s0, 0x00000000
  
  li  $t4, 0 #units in the row counter
  li  $t5, 224 #max units in the row
  
  li	$t6, 0 #row counter
  li	$t7, 192 #number of rows
  
  addi		$t0, $t0, 32832 #(32 rows * 256 units * 4) + (16 units of left padding * 4)
  
  
  makeRow:
    sw  	$t3, ($t0)
    addi	$t0, $t0, 4
    addi	$t4, $t4, 1
    bne		$t4, $t5, makeRow
    
    addi 	$t6, $t6, 1
    addi	$t0, $t0, 128 #(32 units of right and left padding * 4)
    li 		$t4, 0
    bne		$t6, $t7, makeRow
    
    
    li 		$t4, 0  # circles in a row incrementer
    li		$t5, 7 # maximum circles in the row
    
    li 		$t6, -1  # number of rows of circles
    li		$t7, 6 # maximum rows of circles
    
    
    
    markPoints:
    	
    	
  	move	$a0, $t4
  	move	$a1, $t6
  	move 	$a3, $s0
   	jal 	makeCircle
   	addi	$t4, $t4, 1
   	bne	$t4, $t5, markPoints
   	
   	addi	$t6, $t6, 1
	li	$t4, 0
	bne	$t6, $t7, markPoints

	li	$s3, 7
	li $s0, 0xffff0000
gameLoop:
	lw $s1, ($s0)
	beq $s1, $zero, checkAgain
	li	$s6, -1
	li	$s7, 6
	lw $s2, 4($s0)
	
	subi $s2, $s2, 48
	
	blt $s2, $zero, invalidMove #invalid character Checking
	bgt $s2, $s7, invalidMove #invalid character Checking
	
	move	$a0, $s2
	
	
		
	lb $s4 heightMap($s3)
	
	lb $s5, heightMap($s2)
	
	beq $s5, $s6, invalidMove #if theres too many chips, then it just goes back to game loop
	
	move $a1, $s5
	
	addi $s5, $s5, -1
	
	beq $s4, $zero, yellow
	
	move $a3, $t2
	j cont
	
	yellow:
	move $a3, $t1
	
	cont:
	not  $s4, $s4
	
	sb  $s4 heightMap($s3)
	sb  $s5, heightMap($s2)
	
	
		
	
	jal makeCircle

	li $a0, 2
	li $v0, 32
	li $a0, 60
	li $a1, 300
	li $a2, 104
	li $a3, 127
	li $v0, 33
	syscall
	li $a0, 67
	li $a1, 300
	li $a2, 104
	li $a3, 127
	li $v0, 33
	syscall
	
	
	
	
	
checkAgain:
	j gameLoop
	

  
   	
  Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
  
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
	
	

invalidMove:
	li	$v0, 3
	jal	choose_sound
	j gameLoop
		
choose_sound:
beq $v0, 0, sound_place
beq $v0, 1, sound_win
beq $v0, 2, sound_lose
beq $v0, 3, sound_invalid
beq $v0, 4, sound_computer_place


sound_place:
li $a0, 60
li $a1, 300
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 67
li $a1, 300
li $a2, 104
li $a3, 127
li $v0, 33
syscall
j end

sound_win:
li $a0, 55
li $a1, 200
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 60
li $a1, 200
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 64
li $a1, 200
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 67
li $a1, 400
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 64
li $a1, 200
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 67
li $a1, 400
li $a2, 104
li $a3, 127
li $v0, 33
syscall
j end

sound_lose:
li $a0, 67
li $a1, 100
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 63
li $a1, 100
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 60
li $a1, 100
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 48
li $a1, 100
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 44
li $a1, 100
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 41
li $a1, 100
li $a2, 104
li $a3, 127
li $v0, 33
syscall
j end

sound_invalid:
li $a0, 45
li $a1, 200
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 45
li $a1, 200
li $a2, 104
li $a3, 127
li $v0, 33
syscall
j end

sound_computer_place:
li $a0, 67
li $a1, 300
li $a2, 104
li $a3, 127
li $v0, 33
syscall
li $a0, 60
li $a1, 300
li $a2, 104
li $a3, 127
li $v0, 33
syscall
j end

end:
  jr $ra
    
