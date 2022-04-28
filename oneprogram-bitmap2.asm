#bitmap settings: 2by2 unit size, 512 by 512 display size

.data
  newLine: .asciiz "\n"
  displayAddress:	.word	0x10008000 # base address of the display
  heightMap: 		.word 	0x05050505, 0x00050505
  board:		.space	48

  
  .macro convertBoardCoords %x %y %r #takes in the x,y values and converts into the offset to store in r
 	sll %r %y 3
 	add %r %r %x
 .end_macro 
 
 .macro max %x %y %r #sets r to the max of x and y
 	blt  %x, %y, g
 	move %r %x
 	j s
 	g:
 	move %r %y
 	s:
 .end_macro


 .macro save
	addiu   $sp, $sp, -92 #allocates stack memory for the return address
        sw $ra, ($sp)
        sw $t0 4($sp)
        sw $t1 8($sp)
        sw $t2 12($sp)
        sw $t3 16($sp)
        sw $t4 20($sp)
        sw $t5 24($sp)
        sw $t6 28($sp)
        sw $t7 32($sp)
        sw $t8 36($sp)
        sw $t9 40($sp)
        sw $s0 44($sp)
        sw $s1 48($sp)
        sw $s2 52($sp)
        sw $s3 56($sp)
        sw $s4 60($sp)
        sw $s5 64($sp)
        sw $s6 68($sp)
        sw $s7 72($sp)
        sw $a0 76($sp)
        sw $a1 80($sp)
        sw $a2 84($sp)
        sw $a3 88($sp)
	.end_macro

	.macro restor
    lw    $ra, ($sp)
        lw    $t0, 4($sp)
        lw    $t1, 8($sp)
        lw $t2 12($sp)
        lw $t3 16($sp)
        lw $t4 20($sp)
        lw $t5 24($sp)
        lw $t6 28($sp)
        lw $t7 32($sp)
        lw $t8 36($sp)
        lw $t9 40($sp)
        lw $s0 44($sp)
        lw $s1 48($sp)
        lw $s2 52($sp)
        lw $s3 56($sp)
        lw $s4 60($sp)
        lw $s5 64($sp)
        lw $s6 68($sp)
        lw $s7 72($sp)
        lw $a0 76($sp)
        lw $a1 80($sp)
        lw $a2 84($sp)
        lw $a3 88($sp)
        addiu    $sp, $sp, 92 #reallocates the stack 
	.end_macro
  
.text
main:
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
	
	subi $s2, $s2, 49
	
	blt $s2, $zero, invalidMove #invalid character Checking
	bgt $s2, $s7, invalidMove #invalid character Checking
	
		
	lb $s5, heightMap($s2) #holds the current height of the column
	
	beq $s5, $s6, invalidMove #if theres too many chips, then it just goes back to game loop
	
	save()
	move $a0, $s2
	li   $a1, 1
	jal set_board
	restor()
	
	li $v0, 0
	jal win
	bne $v0, $zero, userWin
	
	save()
	jal printBoard
	restor()
	
	jal opps
	
	li $v0, 0
	jal win
	bne $v0, $zero, userLose
	
	save
	jal checkDraw
	restor
	
	#move	$a0, $s2
	
	
		
	#lb $s4 heightMap($s3) #holds the turn byte
	
	#lb $s5, heightMap($s2) #holds the current height of the column
	
	#beq $s5, $s6, invalidMove #if theres too many chips, then it just goes back to game loop
	
	#move $a1, $s5
	
	#addi $s5, $s5, -1 #decrements the column size 
	
	#move $a3, $t1
	
	#sb  $s5, heightMap($s2)
	
	
		
	
	#jal makeCircle

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
	
	
	
	
	# end of user move
	
	
	
	
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
  
  
gcq: #args: a0 == x, a1==y (bottom row 5, top 0) a2==v, output to v0 {
	save()
	li $s0 0 #g
	
	
	li $s6, 6 #holds constant 6
	li $s5, 5 #holds constant 5
	
	li $s1 0 #c
	li $s2 1 #l
	li $s3 1 #r
	
	li $t0, 1 #int i = 1
	li $t1, 4 # holds 4 for i<4
	
	horizontalForLoop:
		
		sub $t2, $a0, $s2 #x-l ==> t2
		blt $t2, $zero, helse1 #x-l < 0	
			convertBoardCoords $t2, $a1, $t3 
			lbu $t4, board($t3) #places the value of board[x-l][y] into t4 for comparison
			bne $t4, $a2, helse1 #board[x-l][y] == v #using bne becuase if its not equal, then it goes to else, but if it is equal, it just starts executing code below the line
				addi $s1 $s1, 1 #c++
				addi $s2 $s2, 1 #l++
				j hdone
		helse1:
		add $t5, $a0, $s3 #x+r ==> t5
		bgt $t5, $s6, helse2 #x+r > 6
			convertBoardCoords $t5, $a1, $t6 #places value of board[x+r][y] into t6 for comparison
			lbu $t7, board($t6) #places the value of board[x-l][y] into t7 for comparison
			bne $t7, $a2, helse2 #board[x+r][y] == v
				addi $s1 $s1, 1 #c++
				addi $s3 $s3, 1 #r++
				j hdone
		helse2:
		blt $t2, $zero, helse3 #x-1 < 0
			bne $t4, $zero, helse3 #board[x-l][y] == 0
				addi $s2 $s2, 1 #l++
				j hdone
		helse3:
		bgt $t5, $s6, helse4 #x+r > 6
			bne $t7, $zero, helse4 #board[x+r][y] == 0
				addi $s3 $s3, 1 #r++
				j hdone
		helse4:
			j break1 #breaks out the loop
		
		hdone:	#outside of the if
		addi $t0, $t0, 1 #i++
		blt $t0, $t1, horizontalForLoop #i<4
		# end of loop
		
		break1:
		
		max $s0, $s1, $s0 #g = max (g,c)


		li $s1 0 #c
		li $s2 1 #l
		li $s3 1 #r
	
		li $t0, 1 #int i = 1
		li $t1, 4 # holds 4 for i<4
	
	verticalForLoop: #{
		
		sub $t2, $a1, $s2 #y-l ==> t2
		blt $t2, $zero, velse1 #y-l < 0	
			convertBoardCoords $a0, $t2, $t3 
			lbu $t4, board($t3) #places the value of board[x-l][y] into t4 for comparison
			bne $t4, $a2, velse1 #board[x][y-l] == v #using bne becuase if its not equal, then it goes to else, but if it is equal, it just starts executing code below the line
				addi $s1 $s1, 1 #c++
				addi $s2 $s2, 1 #l++
				j vdone
		velse1:
		add $t5, $a1, $s3 #y+r ==> t5
		bgt $t5, $s5, velse2 #y+r > 5
			convertBoardCoords $a0, $t5, $t6 #places value of board[x+r][y] into t6 for comparison
			lbu $t7, board($t6) #places the value of board[x][y+r] into t7 for comparison
			bne $t7, $a2, velse2 #board[x][y+r] == v
				addi $s1 $s1, 1 #c++
				addi $s3 $s3, 1 #r++
				j vdone
		velse2:
		blt $t2, $zero, velse3 #x-1 < 0
			bne $t4, $zero, velse3 #board[x][y-l] == 0
				addi $s2 $s2, 1 #l++
				j vdone
		velse3:
		bgt $t5, $s5, velse4 #y+r > 6
			bne $t7, $zero, velse4 #board[x][y+r] == 0
				addi $s3 $s3, 1 #r++
				j vdone
		velse4:
			j break2 #breaks out the loop
		
		vdone:	#outside of the if
		addi $t0, $t0, 1 #i++
		blt $t0, $t1, verticalForLoop #i<4
		# end of loop
		
		break2:
		
		max $s0, $s1, $s0 #g = max (g,c) #}

		li $s1 0 #c
		li $s2 1 #l
		li $s3 1 #r
	
		li $t0, 1 #int i = 1
		li $t1, 4 # holds 4 for i<4

	diagonalForLoop1: #like \ {

		sub $t2, $a0, $s2 #x-l ==> t2
		sub $t8, $a1, $s2 #y-l ==> t8
		blt $t2, $zero, d1else1 #x-l < 0	
		blt $t8, $zero, d1else1 #y-l <0
			convertBoardCoords $t2, $t8, $t3 
			lbu $t4, board($t3) #places the value of board[x-l][y-l] into t4 for comparison
			bne $t4, $a2, d1else1 #board[x-l][y-l] == v #using bne becuase if its not equal, then it goes to else, but if it is equal, it just starts executing code below the line
				addi $s1 $s1, 1 #c++
				addi $s2 $s2, 1 #l++
				j d1done
		d1else1:
		add $t5, $a0, $s3 #x+r ==> t5
		add $t9, $a1, $s3 #y+r ==> t9
		bgt $t5, $s6, d1else2 #x+r > 6
		bgt $t9, $s5, d1else2 #y+r > 5
			convertBoardCoords $t5, $t9, $t6 #places value of board[x+r][y] into t6 for comparison
			lbu $t7, board($t6) #places the value of board[x-l][y] into t7 for comparison
			bne $t7, $a2, d1else2 #board[x+r][y+r] == v
				addi $s1 $s1, 1 #c++
				addi $s3 $s3, 1 #r++
				j d1done
		d1else2:
		bgt $t5, $s6, d1else3 #x+r > 6
		bgt $t9, $s5, d1else3 #y+r > 5
			bne $t7, $zero, d1else3 #board[x+r][y+r] == 0
				addi $s3 $s3, 1 #r++
				j d1done
		d1else3:
		blt $t2, $zero, d1else4 #x-1 < 0
		blt $t8, $zero, d1else4 #y-l <0
			bne $t4, $zero, d1else4 #board[x-l][y-l] == 0
				addi $s2 $s2, 1 #l++
				j d1done
		d1else4:
			j break3 #breaks out the loop
		
		d1done:	#outside of the if
		addi $t0, $t0, 1 #i++
		blt $t0, $t1, diagonalForLoop1 #i<4
		# end of loop
		
		break3:
		
		max $s0, $s1, $s0 #g = max (g,c) #}


		li $s1 0 #c
		li $s2 1 #l
		li $s3 1 #r
	
		li $t0, 1 #int i = 1
		li $t1, 4 # holds 4 for i<4

	diagonalForLoop2: #like /

		sub $t2, $a0, $s2 #x-l ==> t2
		add $t9, $a1, $s2 #y+l ==> t9
		blt $t2, $zero, d2else1 #x-l < 0	
		bgt $t9, $s5, d2else1 #y+l > 5
			convertBoardCoords $t2, $t9, $t3 
			lbu $t4, board($t3) #places the value of board[x-l][y+l] into t4 for comparison
			bne $t4, $a2, d2else1 #board[x-l][y+l] == v #using bne becuase if its not equal, then it goes to else, but if it is equal, it just starts executing code below the line
				addi $s1 $s1, 1 #c++
				addi $s2 $s2, 1 #l++
				j d2done
		d2else1:
		add $t5, $a0, $s3 #x+r ==> t5
		sub $t8, $a1, $s3 #y-r ==> t8
		bgt $t5, $s6, d2else2 #x+r > 6
		blt $t8, $zero d2else2 #y-r < 0
			convertBoardCoords $t5, $t8, $t6 #places value of board[x+r][y-r] into t6 for comparison
			lbu $t7, board($t6) #places the value of board[x+r][y-r] into t7 for comparison
			bne $t7, $a2, d2else2 #board[x+r][y+r] == v
				addi $s1 $s1, 1 #c++
				addi $s3 $s3, 1 #r++
				j d2done
		d2else2:
		blt $t2, $zero, d2else3 #x-l < 0	
		bgt $t9, $s5, d2else3 #y+l > 5
			bne $t4, $zero, d2else3 #board[x-l][y+l] == 0
				addi $s2 $s2, 1 #l++
				j d2done
		d2else3:
		bgt $t5, $s6, d2else4 #x+r > 6
		blt $t8, $zero d2else4 #y-r < 0
			bne $t7, $zero, d2else4 #board[x+r][y-r] == 0
				addi $s3 $s3, 1 #r++
				j d2done
		d2else4:
			j break4 #breaks out the loop
		
		d2done:	#outside of the if
		addi $t0, $t0, 1 #i++
		blt $t0, $t1, diagonalForLoop2 #i<4
		# end of loop
		
		break4:
		
		max $s0, $s1, $s0 #g = max (g,c)
		move $v0 $s0
		restor()
		jr $ra #} 

prio: # $a0 == x, output to $v0
	save()
	lbu $a1 heightMap($a0) #s0 = y
	blt $a1 $zero pend #y<0
	li $t0 3
	sub $s1 $t0 $a0
	sra $t0,$s1,31   
	xor $s1,$s1,$t0
	sub $s1,$s1,$t0 #s1 = abs(3-x)
	li $t0 3 
	sub $s1 $t0 $s1 #s1 = o = 3-abs(3-x)
	li $a2 1 
	jal gcq
	add $s3 $v0 $zero #$s3 = g1
	li $a2 2
	jal gcq
	add $s4 $v0 $zero #$s4 = g2
	li $t0 3
		bne $s3 $t0 pb1 #g1==3
		addi $v0 $s1 80
		j pend
	pb1:	bne $s4 $t0 pb2 #g2==3
		addi $v0 $s1 70
		j pend
	pb2:	li $t0 2
		bne $s3 $t0 pb3 #g1==2
		bne $s4 $t0 pb3 #g2==2
		addi $v0 $s1 60
		j pend
	pb3:	bne $s4 $t0 pb4 #g1==2
		addi $v0 $s1 50
		j pend
	pb4:	bne $s3 $t0 pb5 #g2==2
		addi $v0 $s1 40
		j pend
	pb5:	li $t0 1
		bne $s3 $t0 pb6 #g1==1
		addi $v0 $s1 30
		j pend
	pb6:	bne $s4 $t0 pb7 #g2==1
		addi $v0 $s1 20
		j pend
	pb7:	addi $v0 $s1 10
	pend: restor()
		jr $ra

opps: #no input, no return
	save
	li $s0, -1
	li $s1, 0
	li $s2, 7
	
	li $t0, 0
	
	forOp:
		move $a0, $t0
		jal prio
			 #a would be in v(0)
		blt $v0, $s1, elseO # if (a<p) #used bge so that if its greater than or equal it would go to else, if not it will execute the shit below
			move $s1, $v0
			move $s0, $t0
		elseO:		
	addi $t0, $t0, 1
	blt $t0, $s2, forOp
		#end of loop

	addiu $sp, $sp, -12
	sw $ra ($sp)
	sw $t0 4($sp)
	
	move $a0, $s0
	li $a1, 2
	jal set_board
	
	lw $ra ($sp)
	lw $t0 4($sp)
	addiu $sp, $sp, 12

	restor
	jr $ra


printBoard:
#implement registers used: $t0, $t1, $t2, $s0, $s1 {
    li $v0, 1
    li $t0, 0 #for each row, there needs to be 8 bytes outputted
    li $s0, 7

    li $t1, 0 #there should be 6 columns outputted as well
    li $s1, 6
    ploop:


    sll $t2, $t1, 3
    add $t2, $t2, $t0

    lbu $a0, board($t2)
    syscall

    addi $t0, $t0, 1

    bne $t0, $s0, ploop

    li $t0 0
    addi $t1, $t1, 1

    la $a0, newLine
    li $v0, 4
    syscall

    li $v0 1

    bne $t1, $s1, ploop

    la $a0, newLine
    li $v0, 4
    syscall

    jr $ra#}

set_board:
#implement- the input should be the column number ($a0) and either a 1 or 2 depending on the color of the chip ($a1), no return
#registers used: $t0, $ra {

    lbu $t0, heightMap($a0)
    
    addi $t0, $t0, -1
    sb $t0, heightMap($a0)
    addi $t0, $t0, 1
    
   li $s0, 1
    
    
    save()
    beq $a1, $s0, yellow
    li 	$a3, 0xff0000
    j over1
    
    yellow:
    li 	$a3, 0xfed700
    
    over1:
    #a0 is already set
    move $a1, $t0
    jal makeCircle
    restor()
    
    sll $t0, $t0, 3
    add $t0, $t0, $a0
    
    sb $a1, board($t0)
    
    jr $ra #}

checkDraw:
	li $t0, 0
	li $t1, 7
	li $s0, -1
	
	 dLoop:
	  beq	$t0, $t1, renderDraw
	  lb $t2, heightMap($t0)
	  addi $t0, $t0, 1
	  beq $t2, $s0, dLoop
	  jr $ra
	  
win: #outputs lose (0) win (1) to $v0
    save()
    li $v0 0 
    li $a0 0 #i
    forw1:    li $a1 0 #j
    forw2:    li $a2 1 #color
    convertBoardCoords $a0 $a1 $t1
    lbu $t1 board($t1)
    jal gcq
    li $t0 3
    bne $v0 $t0 woth
    bne $t1 $a2 woth
    li $v0 1
    j wend
    woth: li $a2 2
    jal gcq
    li $t0 3
    bne $v0 $t0 incw
    bne $t1 $a2 incw
    li $v0 1
    j wend
    incw: li $v0 0
    addi $a1 $a1 1
    blt $a1 6 forw2
    addi $a0 $a0 1
    blt $a0 7 forw1
    wend:    restor()
    jr $ra



userLose:
	li $v0, 2
	jal choose_sound
	j renderLose
	
userWin:
	li $v0, 1
	jal choose_sound
	j renderWin
	
restart:
	li $t0, 0x05050505
	li $t1, 0x00050505
	
	la $s0, heightMap
	sw $t0, heightMap
	sw $t1, 4($s0)
	li $v0, 0
	li $t0, 48
	
	rLoop:
		addi $t0, $t0, -1
		sb, $zero, board($t0)
		bge $t0, $zero, rLoop
	
	j main
		
checkRestart: 

li $s0, 0xffff0000
gLoop1:
	lw $s1, ($s0)
	beq $s1, $zero, checkAgain1
	
	lw $s2, 4($s0)
	li $t0, 'y'
	li $t1, 'n'
	
	beq $s2, $t0, restart
	beq $s2, $t1, Exit
	
	
	checkAgain1:
		j gLoop1


renderDraw: #registers used : $t0, $t1
	li $v0, 2
	jal choose_sound
	
	li $a0, 80
	
	lw $s0, displayAddress
	li $s1, 0
	
	
	
	sll	$a0, $a0, 10
	
	add $s0, $s0, $a0
	
	li $t0, 256
	li $t1, 60
	
	loopD:
	sw	$s1, ($s0)
	addi	$s0, $s0, 4
	addi 	$t0, $t0, -1
	
	bne	$t0, $zero, loopD
	
	
	addi	$t1, $t1, -1
	li 	$t0, 256
	
	bne	$t1, $zero, loopD
	
	li	$s2, 0x00ffffff
	
	lw $s0, displayAddress
	sll	$a0, $a0, 10
	
	
sw $s2, 105832($s0)
sw $s2, 106856($s0)
sw $s2, 107880($s0)
sw $s2, 108904($s0)
sw $s2, 109928($s0)
sw $s2, 110952($s0)
sw $s2, 111976($s0)
sw $s2, 113000($s0)
sw $s2, 114024($s0)
sw $s2, 115048($s0)
sw $s2, 116072($s0)
sw $s2, 117096($s0)
sw $s2, 118120($s0)
sw $s2, 105836($s0)
sw $s2, 106860($s0)
sw $s2, 107884($s0)
sw $s2, 108908($s0)
sw $s2, 109932($s0)
sw $s2, 110956($s0)
sw $s2, 111980($s0)
sw $s2, 113004($s0)
sw $s2, 114028($s0)
sw $s2, 115052($s0)
sw $s2, 116076($s0)
sw $s2, 117100($s0)
sw $s2, 118124($s0)
sw $s2, 105840($s0)
sw $s2, 106864($s0)
sw $s2, 107888($s0)
sw $s2, 108912($s0)
sw $s2, 109936($s0)
sw $s2, 110960($s0)
sw $s2, 111984($s0)
sw $s2, 113008($s0)
sw $s2, 114032($s0)
sw $s2, 115056($s0)
sw $s2, 116080($s0)
sw $s2, 117104($s0)
sw $s2, 118128($s0)
sw $s2, 105844($s0)
sw $s2, 110964($s0)
sw $s2, 105848($s0)
sw $s2, 110968($s0)
sw $s2, 105852($s0)
sw $s2, 106876($s0)
sw $s2, 107900($s0)
sw $s2, 108924($s0)
sw $s2, 109948($s0)
sw $s2, 110972($s0)
sw $s2, 111996($s0)
sw $s2, 113020($s0)
sw $s2, 114044($s0)
sw $s2, 115068($s0)
sw $s2, 116092($s0)
sw $s2, 117116($s0)
sw $s2, 118140($s0)
sw $s2, 105856($s0)
sw $s2, 106880($s0)
sw $s2, 107904($s0)
sw $s2, 108928($s0)
sw $s2, 109952($s0)
sw $s2, 112000($s0)
sw $s2, 113024($s0)
sw $s2, 114048($s0)
sw $s2, 115072($s0)
sw $s2, 116096($s0)
sw $s2, 117120($s0)
sw $s2, 118144($s0)
sw $s2, 105860($s0)
sw $s2, 106884($s0)
sw $s2, 107908($s0)
sw $s2, 108932($s0)
sw $s2, 109956($s0)
sw $s2, 112004($s0)
sw $s2, 113028($s0)
sw $s2, 114052($s0)
sw $s2, 115076($s0)
sw $s2, 116100($s0)
sw $s2, 117124($s0)
sw $s2, 118148($s0)
sw $s2, 86408($s0)
sw $s2, 87432($s0)
sw $s2, 88456($s0)
sw $s2, 89480($s0)
sw $s2, 90504($s0)
sw $s2, 91528($s0)
sw $s2, 92552($s0)
sw $s2, 93576($s0)
sw $s2, 94600($s0)
sw $s2, 95624($s0)
sw $s2, 96648($s0)
sw $s2, 97672($s0)
sw $s2, 98696($s0)
sw $s2, 99720($s0)
sw $s2, 100744($s0)
sw $s2, 86412($s0)
sw $s2, 87436($s0)
sw $s2, 88460($s0)
sw $s2, 89484($s0)
sw $s2, 90508($s0)
sw $s2, 91532($s0)
sw $s2, 92556($s0)
sw $s2, 93580($s0)
sw $s2, 94604($s0)
sw $s2, 95628($s0)
sw $s2, 96652($s0)
sw $s2, 97676($s0)
sw $s2, 98700($s0)
sw $s2, 99724($s0)
sw $s2, 100748($s0)
sw $s2, 86416($s0)
sw $s2, 87440($s0)
sw $s2, 88464($s0)
sw $s2, 89488($s0)
sw $s2, 90512($s0)
sw $s2, 91536($s0)
sw $s2, 92560($s0)
sw $s2, 93584($s0)
sw $s2, 94608($s0)
sw $s2, 95632($s0)
sw $s2, 96656($s0)
sw $s2, 97680($s0)
sw $s2, 98704($s0)
sw $s2, 99728($s0)
sw $s2, 100752($s0)
sw $s2, 105872($s0)
sw $s2, 106896($s0)
sw $s2, 107920($s0)
sw $s2, 108944($s0)
sw $s2, 109968($s0)
sw $s2, 110992($s0)
sw $s2, 112016($s0)
sw $s2, 113040($s0)
sw $s2, 114064($s0)
sw $s2, 115088($s0)
sw $s2, 116112($s0)
sw $s2, 117136($s0)
sw $s2, 118160($s0)
sw $s2, 86420($s0)
sw $s2, 87444($s0)
sw $s2, 88468($s0)
sw $s2, 98708($s0)
sw $s2, 99732($s0)
sw $s2, 100756($s0)
sw $s2, 105876($s0)
sw $s2, 106900($s0)
sw $s2, 107924($s0)
sw $s2, 108948($s0)
sw $s2, 109972($s0)
sw $s2, 110996($s0)
sw $s2, 112020($s0)
sw $s2, 113044($s0)
sw $s2, 114068($s0)
sw $s2, 115092($s0)
sw $s2, 116116($s0)
sw $s2, 117140($s0)
sw $s2, 118164($s0)
sw $s2, 86424($s0)
sw $s2, 87448($s0)
sw $s2, 88472($s0)
sw $s2, 98712($s0)
sw $s2, 99736($s0)
sw $s2, 100760($s0)
sw $s2, 105880($s0)
sw $s2, 106904($s0)
sw $s2, 107928($s0)
sw $s2, 108952($s0)
sw $s2, 109976($s0)
sw $s2, 111000($s0)
sw $s2, 112024($s0)
sw $s2, 113048($s0)
sw $s2, 114072($s0)
sw $s2, 115096($s0)
sw $s2, 116120($s0)
sw $s2, 117144($s0)
sw $s2, 118168($s0)
sw $s2, 86428($s0)
sw $s2, 87452($s0)
sw $s2, 88476($s0)
sw $s2, 98716($s0)
sw $s2, 99740($s0)
sw $s2, 100764($s0)
sw $s2, 105884($s0)
sw $s2, 111004($s0)
sw $s2, 117148($s0)
sw $s2, 118172($s0)
sw $s2, 86432($s0)
sw $s2, 87456($s0)
sw $s2, 88480($s0)
sw $s2, 98720($s0)
sw $s2, 99744($s0)
sw $s2, 100768($s0)
sw $s2, 105888($s0)
sw $s2, 111008($s0)
sw $s2, 117152($s0)
sw $s2, 118176($s0)
sw $s2, 86436($s0)
sw $s2, 87460($s0)
sw $s2, 88484($s0)
sw $s2, 98724($s0)
sw $s2, 99748($s0)
sw $s2, 100772($s0)
sw $s2, 105892($s0)
sw $s2, 106916($s0)
sw $s2, 107940($s0)
sw $s2, 111012($s0)
sw $s2, 115108($s0)
sw $s2, 116132($s0)
sw $s2, 117156($s0)
sw $s2, 118180($s0)
sw $s2, 86440($s0)
sw $s2, 87464($s0)
sw $s2, 88488($s0)
sw $s2, 98728($s0)
sw $s2, 99752($s0)
sw $s2, 100776($s0)
sw $s2, 105896($s0)
sw $s2, 106920($s0)
sw $s2, 107944($s0)
sw $s2, 115112($s0)
sw $s2, 116136($s0)
sw $s2, 117160($s0)
sw $s2, 118184($s0)
sw $s2, 89516($s0)
sw $s2, 90540($s0)
sw $s2, 91564($s0)
sw $s2, 92588($s0)
sw $s2, 93612($s0)
sw $s2, 94636($s0)
sw $s2, 95660($s0)
sw $s2, 96684($s0)
sw $s2, 97708($s0)
sw $s2, 105900($s0)
sw $s2, 106924($s0)
sw $s2, 107948($s0)
sw $s2, 115116($s0)
sw $s2, 116140($s0)
sw $s2, 117164($s0)
sw $s2, 118188($s0)
sw $s2, 89520($s0)
sw $s2, 90544($s0)
sw $s2, 91568($s0)
sw $s2, 92592($s0)
sw $s2, 93616($s0)
sw $s2, 94640($s0)
sw $s2, 95664($s0)
sw $s2, 96688($s0)
sw $s2, 97712($s0)
sw $s2, 89524($s0)
sw $s2, 90548($s0)
sw $s2, 91572($s0)
sw $s2, 92596($s0)
sw $s2, 93620($s0)
sw $s2, 94644($s0)
sw $s2, 95668($s0)
sw $s2, 96692($s0)
sw $s2, 97716($s0)
sw $s2, 105912($s0)
sw $s2, 106936($s0)
sw $s2, 107960($s0)
sw $s2, 108984($s0)
sw $s2, 110008($s0)
sw $s2, 115128($s0)
sw $s2, 116152($s0)
sw $s2, 117176($s0)
sw $s2, 118200($s0)
sw $s2, 105916($s0)
sw $s2, 106940($s0)
sw $s2, 107964($s0)
sw $s2, 108988($s0)
sw $s2, 110012($s0)
sw $s2, 111036($s0)
sw $s2, 115132($s0)
sw $s2, 116156($s0)
sw $s2, 117180($s0)
sw $s2, 118204($s0)
sw $s2, 105920($s0)
sw $s2, 106944($s0)
sw $s2, 107968($s0)
sw $s2, 108992($s0)
sw $s2, 110016($s0)
sw $s2, 111040($s0)
sw $s2, 115136($s0)
sw $s2, 116160($s0)
sw $s2, 117184($s0)
sw $s2, 118208($s0)
sw $s2, 86468($s0)
sw $s2, 87492($s0)
sw $s2, 88516($s0)
sw $s2, 89540($s0)
sw $s2, 90564($s0)
sw $s2, 91588($s0)
sw $s2, 92612($s0)
sw $s2, 93636($s0)
sw $s2, 94660($s0)
sw $s2, 95684($s0)
sw $s2, 96708($s0)
sw $s2, 97732($s0)
sw $s2, 98756($s0)
sw $s2, 99780($s0)
sw $s2, 100804($s0)
sw $s2, 105924($s0)
sw $s2, 111044($s0)
sw $s2, 117188($s0)
sw $s2, 118212($s0)
sw $s2, 86472($s0)
sw $s2, 87496($s0)
sw $s2, 88520($s0)
sw $s2, 89544($s0)
sw $s2, 90568($s0)
sw $s2, 91592($s0)
sw $s2, 92616($s0)
sw $s2, 93640($s0)
sw $s2, 94664($s0)
sw $s2, 95688($s0)
sw $s2, 96712($s0)
sw $s2, 97736($s0)
sw $s2, 98760($s0)
sw $s2, 99784($s0)
sw $s2, 100808($s0)
sw $s2, 105928($s0)
sw $s2, 111048($s0)
sw $s2, 117192($s0)
sw $s2, 118216($s0)
sw $s2, 86476($s0)
sw $s2, 87500($s0)
sw $s2, 88524($s0)
sw $s2, 89548($s0)
sw $s2, 90572($s0)
sw $s2, 91596($s0)
sw $s2, 92620($s0)
sw $s2, 93644($s0)
sw $s2, 94668($s0)
sw $s2, 95692($s0)
sw $s2, 96716($s0)
sw $s2, 97740($s0)
sw $s2, 98764($s0)
sw $s2, 99788($s0)
sw $s2, 100812($s0)
sw $s2, 105932($s0)
sw $s2, 106956($s0)
sw $s2, 107980($s0)
sw $s2, 111052($s0)
sw $s2, 112076($s0)
sw $s2, 113100($s0)
sw $s2, 114124($s0)
sw $s2, 115148($s0)
sw $s2, 116172($s0)
sw $s2, 117196($s0)
sw $s2, 118220($s0)
sw $s2, 86480($s0)
sw $s2, 87504($s0)
sw $s2, 88528($s0)
sw $s2, 92624($s0)
sw $s2, 93648($s0)
sw $s2, 94672($s0)
sw $s2, 105936($s0)
sw $s2, 106960($s0)
sw $s2, 107984($s0)
sw $s2, 112080($s0)
sw $s2, 113104($s0)
sw $s2, 114128($s0)
sw $s2, 115152($s0)
sw $s2, 116176($s0)
sw $s2, 117200($s0)
sw $s2, 118224($s0)
sw $s2, 86484($s0)
sw $s2, 87508($s0)
sw $s2, 88532($s0)
sw $s2, 92628($s0)
sw $s2, 93652($s0)
sw $s2, 94676($s0)
sw $s2, 105940($s0)
sw $s2, 106964($s0)
sw $s2, 107988($s0)
sw $s2, 112084($s0)
sw $s2, 113108($s0)
sw $s2, 114132($s0)
sw $s2, 115156($s0)
sw $s2, 116180($s0)
sw $s2, 117204($s0)
sw $s2, 118228($s0)
sw $s2, 125396($s0)
sw $s2, 126420($s0)
sw $s2, 127444($s0)
sw $s2, 128468($s0)
sw $s2, 129492($s0)
sw $s2, 86488($s0)
sw $s2, 87512($s0)
sw $s2, 88536($s0)
sw $s2, 92632($s0)
sw $s2, 93656($s0)
sw $s2, 94680($s0)
sw $s2, 125400($s0)
sw $s2, 126424($s0)
sw $s2, 127448($s0)
sw $s2, 128472($s0)
sw $s2, 129496($s0)
sw $s2, 86492($s0)
sw $s2, 87516($s0)
sw $s2, 88540($s0)
sw $s2, 92636($s0)
sw $s2, 93660($s0)
sw $s2, 94684($s0)
sw $s2, 95708($s0)
sw $s2, 96732($s0)
sw $s2, 97756($s0)
sw $s2, 105948($s0)
sw $s2, 125404($s0)
sw $s2, 126428($s0)
sw $s2, 127452($s0)
sw $s2, 128476($s0)
sw $s2, 129500($s0)
sw $s2, 130524($s0)
sw $s2, 131548($s0)
sw $s2, 86496($s0)
sw $s2, 87520($s0)
sw $s2, 88544($s0)
sw $s2, 92640($s0)
sw $s2, 93664($s0)
sw $s2, 94688($s0)
sw $s2, 95712($s0)
sw $s2, 96736($s0)
sw $s2, 97760($s0)
sw $s2, 105952($s0)
sw $s2, 130528($s0)
sw $s2, 131552($s0)
sw $s2, 132576($s0)
sw $s2, 133600($s0)
sw $s2, 134624($s0)
sw $s2, 135648($s0)
sw $s2, 136672($s0)
sw $s2, 137696($s0)
sw $s2, 86500($s0)
sw $s2, 87524($s0)
sw $s2, 88548($s0)
sw $s2, 92644($s0)
sw $s2, 93668($s0)
sw $s2, 94692($s0)
sw $s2, 95716($s0)
sw $s2, 96740($s0)
sw $s2, 97764($s0)
sw $s2, 105956($s0)
sw $s2, 106980($s0)
sw $s2, 108004($s0)
sw $s2, 109028($s0)
sw $s2, 110052($s0)
sw $s2, 111076($s0)
sw $s2, 112100($s0)
sw $s2, 113124($s0)
sw $s2, 114148($s0)
sw $s2, 115172($s0)
sw $s2, 116196($s0)
sw $s2, 117220($s0)
sw $s2, 118244($s0)
sw $s2, 130532($s0)
sw $s2, 131556($s0)
sw $s2, 132580($s0)
sw $s2, 133604($s0)
sw $s2, 134628($s0)
sw $s2, 135652($s0)
sw $s2, 136676($s0)
sw $s2, 137700($s0)
sw $s2, 89576($s0)
sw $s2, 90600($s0)
sw $s2, 91624($s0)
sw $s2, 98792($s0)
sw $s2, 99816($s0)
sw $s2, 100840($s0)
sw $s2, 105960($s0)
sw $s2, 106984($s0)
sw $s2, 108008($s0)
sw $s2, 109032($s0)
sw $s2, 110056($s0)
sw $s2, 111080($s0)
sw $s2, 112104($s0)
sw $s2, 113128($s0)
sw $s2, 114152($s0)
sw $s2, 115176($s0)
sw $s2, 116200($s0)
sw $s2, 117224($s0)
sw $s2, 118248($s0)
sw $s2, 125416($s0)
sw $s2, 126440($s0)
sw $s2, 127464($s0)
sw $s2, 128488($s0)
sw $s2, 129512($s0)
sw $s2, 130536($s0)
sw $s2, 131560($s0)
sw $s2, 132584($s0)
sw $s2, 133608($s0)
sw $s2, 134632($s0)
sw $s2, 135656($s0)
sw $s2, 136680($s0)
sw $s2, 137704($s0)
sw $s2, 89580($s0)
sw $s2, 90604($s0)
sw $s2, 91628($s0)
sw $s2, 98796($s0)
sw $s2, 99820($s0)
sw $s2, 100844($s0)
sw $s2, 105964($s0)
sw $s2, 106988($s0)
sw $s2, 108012($s0)
sw $s2, 109036($s0)
sw $s2, 110060($s0)
sw $s2, 111084($s0)
sw $s2, 112108($s0)
sw $s2, 113132($s0)
sw $s2, 114156($s0)
sw $s2, 115180($s0)
sw $s2, 116204($s0)
sw $s2, 117228($s0)
sw $s2, 118252($s0)
sw $s2, 125420($s0)
sw $s2, 126444($s0)
sw $s2, 127468($s0)
sw $s2, 128492($s0)
sw $s2, 129516($s0)
sw $s2, 130540($s0)
sw $s2, 131564($s0)
sw $s2, 132588($s0)
sw $s2, 133612($s0)
sw $s2, 134636($s0)
sw $s2, 135660($s0)
sw $s2, 136684($s0)
sw $s2, 137708($s0)
sw $s2, 89584($s0)
sw $s2, 90608($s0)
sw $s2, 91632($s0)
sw $s2, 98800($s0)
sw $s2, 99824($s0)
sw $s2, 100848($s0)
sw $s2, 105968($s0)
sw $s2, 125424($s0)
sw $s2, 126448($s0)
sw $s2, 127472($s0)
sw $s2, 128496($s0)
sw $s2, 129520($s0)
sw $s2, 130544($s0)
sw $s2, 131568($s0)
sw $s2, 105972($s0)
sw $s2, 135676($s0)
sw $s2, 136700($s0)
sw $s2, 137724($s0)
sw $s2, 89600($s0)
sw $s2, 90624($s0)
sw $s2, 91648($s0)
sw $s2, 92672($s0)
sw $s2, 93696($s0)
sw $s2, 94720($s0)
sw $s2, 95744($s0)
sw $s2, 96768($s0)
sw $s2, 97792($s0)
sw $s2, 98816($s0)
sw $s2, 99840($s0)
sw $s2, 100864($s0)
sw $s2, 105984($s0)
sw $s2, 107008($s0)
sw $s2, 108032($s0)
sw $s2, 109056($s0)
sw $s2, 110080($s0)
sw $s2, 111104($s0)
sw $s2, 112128($s0)
sw $s2, 113152($s0)
sw $s2, 114176($s0)
sw $s2, 115200($s0)
sw $s2, 116224($s0)
sw $s2, 117248($s0)
sw $s2, 118272($s0)
sw $s2, 135680($s0)
sw $s2, 136704($s0)
sw $s2, 137728($s0)
sw $s2, 89604($s0)
sw $s2, 90628($s0)
sw $s2, 91652($s0)
sw $s2, 92676($s0)
sw $s2, 93700($s0)
sw $s2, 94724($s0)
sw $s2, 95748($s0)
sw $s2, 96772($s0)
sw $s2, 97796($s0)
sw $s2, 98820($s0)
sw $s2, 99844($s0)
sw $s2, 100868($s0)
sw $s2, 105988($s0)
sw $s2, 107012($s0)
sw $s2, 108036($s0)
sw $s2, 109060($s0)
sw $s2, 110084($s0)
sw $s2, 111108($s0)
sw $s2, 112132($s0)
sw $s2, 113156($s0)
sw $s2, 114180($s0)
sw $s2, 115204($s0)
sw $s2, 116228($s0)
sw $s2, 117252($s0)
sw $s2, 118276($s0)
sw $s2, 132612($s0)
sw $s2, 133636($s0)
sw $s2, 134660($s0)
sw $s2, 135684($s0)
sw $s2, 136708($s0)
sw $s2, 137732($s0)
sw $s2, 89608($s0)
sw $s2, 90632($s0)
sw $s2, 91656($s0)
sw $s2, 92680($s0)
sw $s2, 93704($s0)
sw $s2, 94728($s0)
sw $s2, 95752($s0)
sw $s2, 96776($s0)
sw $s2, 97800($s0)
sw $s2, 98824($s0)
sw $s2, 99848($s0)
sw $s2, 100872($s0)
sw $s2, 105992($s0)
sw $s2, 107016($s0)
sw $s2, 108040($s0)
sw $s2, 109064($s0)
sw $s2, 110088($s0)
sw $s2, 111112($s0)
sw $s2, 112136($s0)
sw $s2, 113160($s0)
sw $s2, 114184($s0)
sw $s2, 115208($s0)
sw $s2, 116232($s0)
sw $s2, 117256($s0)
sw $s2, 118280($s0)
sw $s2, 129544($s0)
sw $s2, 130568($s0)
sw $s2, 131592($s0)
sw $s2, 132616($s0)
sw $s2, 133640($s0)
sw $s2, 134664($s0)
sw $s2, 86540($s0)
sw $s2, 87564($s0)
sw $s2, 88588($s0)
sw $s2, 92684($s0)
sw $s2, 93708($s0)
sw $s2, 94732($s0)
sw $s2, 105996($s0)
sw $s2, 111116($s0)
sw $s2, 129548($s0)
sw $s2, 130572($s0)
sw $s2, 131596($s0)
sw $s2, 132620($s0)
sw $s2, 133644($s0)
sw $s2, 134668($s0)
sw $s2, 86544($s0)
sw $s2, 87568($s0)
sw $s2, 88592($s0)
sw $s2, 92688($s0)
sw $s2, 93712($s0)
sw $s2, 94736($s0)
sw $s2, 106000($s0)
sw $s2, 111120($s0)
sw $s2, 125456($s0)
sw $s2, 126480($s0)
sw $s2, 127504($s0)
sw $s2, 128528($s0)
sw $s2, 129552($s0)
sw $s2, 130576($s0)
sw $s2, 131600($s0)
sw $s2, 86548($s0)
sw $s2, 87572($s0)
sw $s2, 88596($s0)
sw $s2, 92692($s0)
sw $s2, 93716($s0)
sw $s2, 94740($s0)
sw $s2, 106004($s0)
sw $s2, 107028($s0)
sw $s2, 108052($s0)
sw $s2, 109076($s0)
sw $s2, 110100($s0)
sw $s2, 111124($s0)
sw $s2, 112148($s0)
sw $s2, 113172($s0)
sw $s2, 114196($s0)
sw $s2, 115220($s0)
sw $s2, 116244($s0)
sw $s2, 117268($s0)
sw $s2, 118292($s0)
sw $s2, 125460($s0)
sw $s2, 126484($s0)
sw $s2, 127508($s0)
sw $s2, 128532($s0)
sw $s2, 86552($s0)
sw $s2, 87576($s0)
sw $s2, 88600($s0)
sw $s2, 92696($s0)
sw $s2, 93720($s0)
sw $s2, 94744($s0)
sw $s2, 106008($s0)
sw $s2, 107032($s0)
sw $s2, 108056($s0)
sw $s2, 109080($s0)
sw $s2, 110104($s0)
sw $s2, 111128($s0)
sw $s2, 112152($s0)
sw $s2, 113176($s0)
sw $s2, 114200($s0)
sw $s2, 115224($s0)
sw $s2, 116248($s0)
sw $s2, 117272($s0)
sw $s2, 118296($s0)
sw $s2, 125464($s0)
sw $s2, 126488($s0)
sw $s2, 127512($s0)
sw $s2, 128536($s0)
sw $s2, 86556($s0)
sw $s2, 87580($s0)
sw $s2, 88604($s0)
sw $s2, 92700($s0)
sw $s2, 93724($s0)
sw $s2, 94748($s0)
sw $s2, 106012($s0)
sw $s2, 107036($s0)
sw $s2, 108060($s0)
sw $s2, 109084($s0)
sw $s2, 110108($s0)
sw $s2, 111132($s0)
sw $s2, 112156($s0)
sw $s2, 113180($s0)
sw $s2, 114204($s0)
sw $s2, 115228($s0)
sw $s2, 116252($s0)
sw $s2, 117276($s0)
sw $s2, 118300($s0)
sw $s2, 86560($s0)
sw $s2, 87584($s0)
sw $s2, 88608($s0)
sw $s2, 92704($s0)
sw $s2, 93728($s0)
sw $s2, 94752($s0)
sw $s2, 89636($s0)
sw $s2, 90660($s0)
sw $s2, 91684($s0)
sw $s2, 92708($s0)
sw $s2, 93732($s0)
sw $s2, 94756($s0)
sw $s2, 95780($s0)
sw $s2, 96804($s0)
sw $s2, 97828($s0)
sw $s2, 98852($s0)
sw $s2, 99876($s0)
sw $s2, 100900($s0)
sw $s2, 125476($s0)
sw $s2, 126500($s0)
sw $s2, 127524($s0)
sw $s2, 128548($s0)
sw $s2, 129572($s0)
sw $s2, 130596($s0)
sw $s2, 131620($s0)
sw $s2, 132644($s0)
sw $s2, 133668($s0)
sw $s2, 134692($s0)
sw $s2, 135716($s0)
sw $s2, 136740($s0)
sw $s2, 137764($s0)
sw $s2, 89640($s0)
sw $s2, 90664($s0)
sw $s2, 91688($s0)
sw $s2, 92712($s0)
sw $s2, 93736($s0)
sw $s2, 94760($s0)
sw $s2, 95784($s0)
sw $s2, 96808($s0)
sw $s2, 97832($s0)
sw $s2, 98856($s0)
sw $s2, 99880($s0)
sw $s2, 100904($s0)
sw $s2, 106024($s0)
sw $s2, 107048($s0)
sw $s2, 108072($s0)
sw $s2, 109096($s0)
sw $s2, 110120($s0)
sw $s2, 111144($s0)
sw $s2, 112168($s0)
sw $s2, 113192($s0)
sw $s2, 114216($s0)
sw $s2, 115240($s0)
sw $s2, 116264($s0)
sw $s2, 117288($s0)
sw $s2, 118312($s0)
sw $s2, 125480($s0)
sw $s2, 126504($s0)
sw $s2, 127528($s0)
sw $s2, 128552($s0)
sw $s2, 129576($s0)
sw $s2, 130600($s0)
sw $s2, 131624($s0)
sw $s2, 132648($s0)
sw $s2, 133672($s0)
sw $s2, 134696($s0)
sw $s2, 135720($s0)
sw $s2, 136744($s0)
sw $s2, 137768($s0)
sw $s2, 89644($s0)
sw $s2, 90668($s0)
sw $s2, 91692($s0)
sw $s2, 92716($s0)
sw $s2, 93740($s0)
sw $s2, 94764($s0)
sw $s2, 95788($s0)
sw $s2, 96812($s0)
sw $s2, 97836($s0)
sw $s2, 98860($s0)
sw $s2, 99884($s0)
sw $s2, 100908($s0)
sw $s2, 106028($s0)
sw $s2, 107052($s0)
sw $s2, 108076($s0)
sw $s2, 109100($s0)
sw $s2, 110124($s0)
sw $s2, 111148($s0)
sw $s2, 112172($s0)
sw $s2, 113196($s0)
sw $s2, 114220($s0)
sw $s2, 115244($s0)
sw $s2, 116268($s0)
sw $s2, 117292($s0)
sw $s2, 118316($s0)
sw $s2, 125484($s0)
sw $s2, 126508($s0)
sw $s2, 127532($s0)
sw $s2, 128556($s0)
sw $s2, 129580($s0)
sw $s2, 130604($s0)
sw $s2, 131628($s0)
sw $s2, 132652($s0)
sw $s2, 133676($s0)
sw $s2, 134700($s0)
sw $s2, 135724($s0)
sw $s2, 136748($s0)
sw $s2, 137772($s0)
sw $s2, 106032($s0)
sw $s2, 107056($s0)
sw $s2, 108080($s0)
sw $s2, 109104($s0)
sw $s2, 110128($s0)
sw $s2, 111152($s0)
sw $s2, 112176($s0)
sw $s2, 113200($s0)
sw $s2, 114224($s0)
sw $s2, 115248($s0)
sw $s2, 116272($s0)
sw $s2, 117296($s0)
sw $s2, 118320($s0)
sw $s2, 127536($s0)
sw $s2, 128560($s0)
sw $s2, 129584($s0)
sw $s2, 106036($s0)
sw $s2, 111156($s0)
sw $s2, 127540($s0)
sw $s2, 128564($s0)
sw $s2, 129588($s0)
sw $s2, 106040($s0)
sw $s2, 107064($s0)
sw $s2, 108088($s0)
sw $s2, 109112($s0)
sw $s2, 110136($s0)
sw $s2, 111160($s0)
sw $s2, 112184($s0)
sw $s2, 113208($s0)
sw $s2, 114232($s0)
sw $s2, 115256($s0)
sw $s2, 116280($s0)
sw $s2, 117304($s0)
sw $s2, 118328($s0)
sw $s2, 129592($s0)
sw $s2, 130616($s0)
sw $s2, 131640($s0)
sw $s2, 86588($s0)
sw $s2, 87612($s0)
sw $s2, 88636($s0)
sw $s2, 89660($s0)
sw $s2, 90684($s0)
sw $s2, 91708($s0)
sw $s2, 92732($s0)
sw $s2, 93756($s0)
sw $s2, 94780($s0)
sw $s2, 95804($s0)
sw $s2, 96828($s0)
sw $s2, 97852($s0)
sw $s2, 98876($s0)
sw $s2, 99900($s0)
sw $s2, 100924($s0)
sw $s2, 106044($s0)
sw $s2, 107068($s0)
sw $s2, 108092($s0)
sw $s2, 109116($s0)
sw $s2, 110140($s0)
sw $s2, 111164($s0)
sw $s2, 112188($s0)
sw $s2, 113212($s0)
sw $s2, 114236($s0)
sw $s2, 115260($s0)
sw $s2, 116284($s0)
sw $s2, 117308($s0)
sw $s2, 118332($s0)
sw $s2, 125500($s0)
sw $s2, 126524($s0)
sw $s2, 127548($s0)
sw $s2, 128572($s0)
sw $s2, 129596($s0)
sw $s2, 130620($s0)
sw $s2, 131644($s0)
sw $s2, 132668($s0)
sw $s2, 133692($s0)
sw $s2, 134716($s0)
sw $s2, 135740($s0)
sw $s2, 136764($s0)
sw $s2, 137788($s0)
sw $s2, 86592($s0)
sw $s2, 87616($s0)
sw $s2, 88640($s0)
sw $s2, 89664($s0)
sw $s2, 90688($s0)
sw $s2, 91712($s0)
sw $s2, 92736($s0)
sw $s2, 93760($s0)
sw $s2, 94784($s0)
sw $s2, 95808($s0)
sw $s2, 96832($s0)
sw $s2, 97856($s0)
sw $s2, 98880($s0)
sw $s2, 99904($s0)
sw $s2, 100928($s0)
sw $s2, 106048($s0)
sw $s2, 107072($s0)
sw $s2, 108096($s0)
sw $s2, 109120($s0)
sw $s2, 110144($s0)
sw $s2, 112192($s0)
sw $s2, 113216($s0)
sw $s2, 114240($s0)
sw $s2, 115264($s0)
sw $s2, 116288($s0)
sw $s2, 117312($s0)
sw $s2, 118336($s0)
sw $s2, 125504($s0)
sw $s2, 126528($s0)
sw $s2, 127552($s0)
sw $s2, 128576($s0)
sw $s2, 129600($s0)
sw $s2, 130624($s0)
sw $s2, 131648($s0)
sw $s2, 132672($s0)
sw $s2, 133696($s0)
sw $s2, 134720($s0)
sw $s2, 135744($s0)
sw $s2, 136768($s0)
sw $s2, 137792($s0)
sw $s2, 86596($s0)
sw $s2, 87620($s0)
sw $s2, 88644($s0)
sw $s2, 89668($s0)
sw $s2, 90692($s0)
sw $s2, 91716($s0)
sw $s2, 92740($s0)
sw $s2, 93764($s0)
sw $s2, 94788($s0)
sw $s2, 95812($s0)
sw $s2, 96836($s0)
sw $s2, 97860($s0)
sw $s2, 98884($s0)
sw $s2, 99908($s0)
sw $s2, 100932($s0)
sw $s2, 106052($s0)
sw $s2, 107076($s0)
sw $s2, 108100($s0)
sw $s2, 109124($s0)
sw $s2, 110148($s0)
sw $s2, 112196($s0)
sw $s2, 113220($s0)
sw $s2, 114244($s0)
sw $s2, 115268($s0)
sw $s2, 116292($s0)
sw $s2, 117316($s0)
sw $s2, 118340($s0)
sw $s2, 125508($s0)
sw $s2, 126532($s0)
sw $s2, 127556($s0)
sw $s2, 128580($s0)
sw $s2, 129604($s0)
sw $s2, 130628($s0)
sw $s2, 131652($s0)
sw $s2, 132676($s0)
sw $s2, 133700($s0)
sw $s2, 134724($s0)
sw $s2, 135748($s0)
sw $s2, 136772($s0)
sw $s2, 137796($s0)
sw $s2, 95816($s0)
sw $s2, 96840($s0)
sw $s2, 97864($s0)
sw $s2, 125512($s0)
sw $s2, 126536($s0)
sw $s2, 127560($s0)
sw $s2, 128584($s0)
sw $s2, 129608($s0)
sw $s2, 130632($s0)
sw $s2, 131656($s0)
sw $s2, 132680($s0)
sw $s2, 133704($s0)
sw $s2, 134728($s0)
sw $s2, 135752($s0)
sw $s2, 136776($s0)
sw $s2, 137800($s0)
sw $s2, 95820($s0)
sw $s2, 96844($s0)
sw $s2, 97868($s0)
sw $s2, 106060($s0)
sw $s2, 95824($s0)
sw $s2, 96848($s0)
sw $s2, 97872($s0)
sw $s2, 106064($s0)
sw $s2, 92756($s0)
sw $s2, 93780($s0)
sw $s2, 94804($s0)
sw $s2, 106068($s0)
sw $s2, 107092($s0)
sw $s2, 108116($s0)
sw $s2, 109140($s0)
sw $s2, 110164($s0)
sw $s2, 111188($s0)
sw $s2, 112212($s0)
sw $s2, 113236($s0)
sw $s2, 114260($s0)
sw $s2, 115284($s0)
sw $s2, 116308($s0)
sw $s2, 117332($s0)
sw $s2, 118356($s0)
sw $s2, 92760($s0)
sw $s2, 93784($s0)
sw $s2, 94808($s0)
sw $s2, 106072($s0)
sw $s2, 107096($s0)
sw $s2, 108120($s0)
sw $s2, 109144($s0)
sw $s2, 110168($s0)
sw $s2, 111192($s0)
sw $s2, 112216($s0)
sw $s2, 113240($s0)
sw $s2, 114264($s0)
sw $s2, 115288($s0)
sw $s2, 116312($s0)
sw $s2, 117336($s0)
sw $s2, 118360($s0)
sw $s2, 92764($s0)
sw $s2, 93788($s0)
sw $s2, 94812($s0)
sw $s2, 106076($s0)
sw $s2, 107100($s0)
sw $s2, 108124($s0)
sw $s2, 109148($s0)
sw $s2, 110172($s0)
sw $s2, 111196($s0)
sw $s2, 112220($s0)
sw $s2, 113244($s0)
sw $s2, 114268($s0)
sw $s2, 115292($s0)
sw $s2, 116316($s0)
sw $s2, 117340($s0)
sw $s2, 118364($s0)
sw $s2, 95840($s0)
sw $s2, 96864($s0)
sw $s2, 97888($s0)
sw $s2, 106080($s0)
sw $s2, 95844($s0)
sw $s2, 96868($s0)
sw $s2, 97892($s0)
sw $s2, 106084($s0)
sw $s2, 95848($s0)
sw $s2, 96872($s0)
sw $s2, 97896($s0)
sw $s2, 86636($s0)
sw $s2, 87660($s0)
sw $s2, 88684($s0)
sw $s2, 89708($s0)
sw $s2, 90732($s0)
sw $s2, 91756($s0)
sw $s2, 92780($s0)
sw $s2, 93804($s0)
sw $s2, 94828($s0)
sw $s2, 95852($s0)
sw $s2, 96876($s0)
sw $s2, 97900($s0)
sw $s2, 98924($s0)
sw $s2, 99948($s0)
sw $s2, 100972($s0)
sw $s2, 86640($s0)
sw $s2, 87664($s0)
sw $s2, 88688($s0)
sw $s2, 89712($s0)
sw $s2, 90736($s0)
sw $s2, 91760($s0)
sw $s2, 92784($s0)
sw $s2, 93808($s0)
sw $s2, 94832($s0)
sw $s2, 95856($s0)
sw $s2, 96880($s0)
sw $s2, 97904($s0)
sw $s2, 98928($s0)
sw $s2, 99952($s0)
sw $s2, 100976($s0)
sw $s2, 107120($s0)
sw $s2, 108144($s0)
sw $s2, 86644($s0)
sw $s2, 87668($s0)
sw $s2, 88692($s0)
sw $s2, 89716($s0)
sw $s2, 90740($s0)
sw $s2, 91764($s0)
sw $s2, 92788($s0)
sw $s2, 93812($s0)
sw $s2, 94836($s0)
sw $s2, 95860($s0)
sw $s2, 96884($s0)
sw $s2, 97908($s0)
sw $s2, 98932($s0)
sw $s2, 99956($s0)
sw $s2, 100980($s0)
sw $s2, 106100($s0)
sw $s2, 107124($s0)
sw $s2, 108148($s0)
sw $s2, 106104($s0)
sw $s2, 107128($s0)
sw $s2, 108152($s0)
sw $s2, 106108($s0)
sw $s2, 107132($s0)
sw $s2, 108156($s0)
sw $s2, 111228($s0)
sw $s2, 112252($s0)
sw $s2, 113276($s0)
sw $s2, 115324($s0)
sw $s2, 116348($s0)
sw $s2, 117372($s0)
sw $s2, 118396($s0)
sw $s2, 106112($s0)
sw $s2, 107136($s0)
sw $s2, 108160($s0)
sw $s2, 111232($s0)
sw $s2, 112256($s0)
sw $s2, 113280($s0)
sw $s2, 115328($s0)
sw $s2, 116352($s0)
sw $s2, 117376($s0)
sw $s2, 118400($s0)
sw $s2, 106116($s0)
sw $s2, 107140($s0)
sw $s2, 108164($s0)
sw $s2, 111236($s0)
sw $s2, 112260($s0)
sw $s2, 113284($s0)
sw $s2, 115332($s0)
sw $s2, 116356($s0)
sw $s2, 117380($s0)
sw $s2, 118404($s0)
sw $s2, 106120($s0)
sw $s2, 107144($s0)
sw $s2, 108168($s0)
sw $s2, 109192($s0)
sw $s2, 110216($s0)
sw $s2, 111240($s0)
sw $s2, 106124($s0)
sw $s2, 107148($s0)
sw $s2, 108172($s0)
sw $s2, 109196($s0)
sw $s2, 110220($s0)
sw $s2, 111244($s0)
sw $s2, 107152($s0)
sw $s2, 108176($s0)
sw $s2, 109200($s0)
sw $s2, 110224($s0)
sw $s2, 107156($s0)
sw $s2, 108180($s0)
sw $s2, 109204($s0)
sw $s2, 110228($s0)
 j checkRestart	




renderLose: #registers used : $t0, $t1

	li $a0, 80
	
	lw $s0, displayAddress
	li $s1, 0
	
	
	
	sll	$a0, $a0, 10
	
	add $s0, $s0, $a0
	
	li $t0, 256
	li $t1, 60
	
	loopL:
	sw	$s1, ($s0)
	addi	$s0, $s0, 4
	addi 	$t0, $t0, -1
	
	bne	$t0, $zero, loopL
	
	
	addi	$t1, $t1, -1
	li 	$t0, 256
	
	bne	$t1, $zero, loopL
	
	li	$s2, 0x00ffffff
	
	lw $s0, displayAddress
	sll	$a0, $a0, 10
	
	
sw $s2, 86304($s0)
sw $s2, 87328($s0)
sw $s2, 88352($s0)
sw $s2, 89376($s0)
sw $s2, 90400($s0)
sw $s2, 91424($s0)
sw $s2, 86308($s0)
sw $s2, 87332($s0)
sw $s2, 88356($s0)
sw $s2, 89380($s0)
sw $s2, 90404($s0)
sw $s2, 91428($s0)
sw $s2, 86312($s0)
sw $s2, 87336($s0)
sw $s2, 88360($s0)
sw $s2, 89384($s0)
sw $s2, 90408($s0)
sw $s2, 91432($s0)
sw $s2, 92460($s0)
sw $s2, 93484($s0)
sw $s2, 94508($s0)
sw $s2, 92464($s0)
sw $s2, 93488($s0)
sw $s2, 94512($s0)
sw $s2, 92468($s0)
sw $s2, 93492($s0)
sw $s2, 94516($s0)
sw $s2, 92472($s0)
sw $s2, 93496($s0)
sw $s2, 94520($s0)
sw $s2, 95544($s0)
sw $s2, 96568($s0)
sw $s2, 97592($s0)
sw $s2, 98616($s0)
sw $s2, 99640($s0)
sw $s2, 100664($s0)
sw $s2, 92476($s0)
sw $s2, 93500($s0)
sw $s2, 94524($s0)
sw $s2, 95548($s0)
sw $s2, 96572($s0)
sw $s2, 97596($s0)
sw $s2, 98620($s0)
sw $s2, 99644($s0)
sw $s2, 100668($s0)
sw $s2, 92480($s0)
sw $s2, 93504($s0)
sw $s2, 94528($s0)
sw $s2, 95552($s0)
sw $s2, 96576($s0)
sw $s2, 97600($s0)
sw $s2, 98624($s0)
sw $s2, 99648($s0)
sw $s2, 100672($s0)
sw $s2, 92484($s0)
sw $s2, 93508($s0)
sw $s2, 94532($s0)
sw $s2, 92488($s0)
sw $s2, 93512($s0)
sw $s2, 94536($s0)
sw $s2, 92492($s0)
sw $s2, 93516($s0)
sw $s2, 94540($s0)
sw $s2, 86352($s0)
sw $s2, 87376($s0)
sw $s2, 88400($s0)
sw $s2, 89424($s0)
sw $s2, 90448($s0)
sw $s2, 91472($s0)
sw $s2, 86356($s0)
sw $s2, 87380($s0)
sw $s2, 88404($s0)
sw $s2, 89428($s0)
sw $s2, 90452($s0)
sw $s2, 91476($s0)
sw $s2, 86360($s0)
sw $s2, 87384($s0)
sw $s2, 88408($s0)
sw $s2, 89432($s0)
sw $s2, 90456($s0)
sw $s2, 91480($s0)
sw $s2, 89448($s0)
sw $s2, 90472($s0)
sw $s2, 91496($s0)
sw $s2, 92520($s0)
sw $s2, 93544($s0)
sw $s2, 94568($s0)
sw $s2, 95592($s0)
sw $s2, 96616($s0)
sw $s2, 97640($s0)
sw $s2, 105832($s0)
sw $s2, 106856($s0)
sw $s2, 107880($s0)
sw $s2, 108904($s0)
sw $s2, 109928($s0)
sw $s2, 110952($s0)
sw $s2, 111976($s0)
sw $s2, 113000($s0)
sw $s2, 114024($s0)
sw $s2, 115048($s0)
sw $s2, 116072($s0)
sw $s2, 117096($s0)
sw $s2, 118120($s0)
sw $s2, 89452($s0)
sw $s2, 90476($s0)
sw $s2, 91500($s0)
sw $s2, 92524($s0)
sw $s2, 93548($s0)
sw $s2, 94572($s0)
sw $s2, 95596($s0)
sw $s2, 96620($s0)
sw $s2, 97644($s0)
sw $s2, 105836($s0)
sw $s2, 106860($s0)
sw $s2, 107884($s0)
sw $s2, 108908($s0)
sw $s2, 109932($s0)
sw $s2, 110956($s0)
sw $s2, 111980($s0)
sw $s2, 113004($s0)
sw $s2, 114028($s0)
sw $s2, 115052($s0)
sw $s2, 116076($s0)
sw $s2, 117100($s0)
sw $s2, 118124($s0)
sw $s2, 89456($s0)
sw $s2, 90480($s0)
sw $s2, 91504($s0)
sw $s2, 92528($s0)
sw $s2, 93552($s0)
sw $s2, 94576($s0)
sw $s2, 95600($s0)
sw $s2, 96624($s0)
sw $s2, 97648($s0)
sw $s2, 105840($s0)
sw $s2, 106864($s0)
sw $s2, 107888($s0)
sw $s2, 108912($s0)
sw $s2, 109936($s0)
sw $s2, 110960($s0)
sw $s2, 111984($s0)
sw $s2, 113008($s0)
sw $s2, 114032($s0)
sw $s2, 115056($s0)
sw $s2, 116080($s0)
sw $s2, 117104($s0)
sw $s2, 118128($s0)
sw $s2, 86388($s0)
sw $s2, 87412($s0)
sw $s2, 88436($s0)
sw $s2, 98676($s0)
sw $s2, 99700($s0)
sw $s2, 100724($s0)
sw $s2, 105844($s0)
sw $s2, 110964($s0)
sw $s2, 86392($s0)
sw $s2, 87416($s0)
sw $s2, 88440($s0)
sw $s2, 98680($s0)
sw $s2, 99704($s0)
sw $s2, 100728($s0)
sw $s2, 105848($s0)
sw $s2, 110968($s0)
sw $s2, 86396($s0)
sw $s2, 87420($s0)
sw $s2, 88444($s0)
sw $s2, 98684($s0)
sw $s2, 99708($s0)
sw $s2, 100732($s0)
sw $s2, 105852($s0)
sw $s2, 106876($s0)
sw $s2, 107900($s0)
sw $s2, 108924($s0)
sw $s2, 109948($s0)
sw $s2, 110972($s0)
sw $s2, 111996($s0)
sw $s2, 113020($s0)
sw $s2, 114044($s0)
sw $s2, 115068($s0)
sw $s2, 116092($s0)
sw $s2, 117116($s0)
sw $s2, 118140($s0)
sw $s2, 86400($s0)
sw $s2, 87424($s0)
sw $s2, 88448($s0)
sw $s2, 98688($s0)
sw $s2, 99712($s0)
sw $s2, 100736($s0)
sw $s2, 105856($s0)
sw $s2, 106880($s0)
sw $s2, 107904($s0)
sw $s2, 108928($s0)
sw $s2, 109952($s0)
sw $s2, 112000($s0)
sw $s2, 113024($s0)
sw $s2, 114048($s0)
sw $s2, 115072($s0)
sw $s2, 116096($s0)
sw $s2, 117120($s0)
sw $s2, 118144($s0)
sw $s2, 86404($s0)
sw $s2, 87428($s0)
sw $s2, 88452($s0)
sw $s2, 98692($s0)
sw $s2, 99716($s0)
sw $s2, 100740($s0)
sw $s2, 105860($s0)
sw $s2, 106884($s0)
sw $s2, 107908($s0)
sw $s2, 108932($s0)
sw $s2, 109956($s0)
sw $s2, 112004($s0)
sw $s2, 113028($s0)
sw $s2, 114052($s0)
sw $s2, 115076($s0)
sw $s2, 116100($s0)
sw $s2, 117124($s0)
sw $s2, 118148($s0)
sw $s2, 86408($s0)
sw $s2, 87432($s0)
sw $s2, 88456($s0)
sw $s2, 98696($s0)
sw $s2, 99720($s0)
sw $s2, 100744($s0)
sw $s2, 89484($s0)
sw $s2, 90508($s0)
sw $s2, 91532($s0)
sw $s2, 92556($s0)
sw $s2, 93580($s0)
sw $s2, 94604($s0)
sw $s2, 95628($s0)
sw $s2, 96652($s0)
sw $s2, 97676($s0)
sw $s2, 89488($s0)
sw $s2, 90512($s0)
sw $s2, 91536($s0)
sw $s2, 92560($s0)
sw $s2, 93584($s0)
sw $s2, 94608($s0)
sw $s2, 95632($s0)
sw $s2, 96656($s0)
sw $s2, 97680($s0)
sw $s2, 105872($s0)
sw $s2, 106896($s0)
sw $s2, 107920($s0)
sw $s2, 108944($s0)
sw $s2, 109968($s0)
sw $s2, 110992($s0)
sw $s2, 112016($s0)
sw $s2, 113040($s0)
sw $s2, 114064($s0)
sw $s2, 115088($s0)
sw $s2, 116112($s0)
sw $s2, 117136($s0)
sw $s2, 118160($s0)
sw $s2, 89492($s0)
sw $s2, 90516($s0)
sw $s2, 91540($s0)
sw $s2, 92564($s0)
sw $s2, 93588($s0)
sw $s2, 94612($s0)
sw $s2, 95636($s0)
sw $s2, 96660($s0)
sw $s2, 97684($s0)
sw $s2, 105876($s0)
sw $s2, 106900($s0)
sw $s2, 107924($s0)
sw $s2, 108948($s0)
sw $s2, 109972($s0)
sw $s2, 110996($s0)
sw $s2, 112020($s0)
sw $s2, 113044($s0)
sw $s2, 114068($s0)
sw $s2, 115092($s0)
sw $s2, 116116($s0)
sw $s2, 117140($s0)
sw $s2, 118164($s0)
sw $s2, 105880($s0)
sw $s2, 106904($s0)
sw $s2, 107928($s0)
sw $s2, 108952($s0)
sw $s2, 109976($s0)
sw $s2, 111000($s0)
sw $s2, 112024($s0)
sw $s2, 113048($s0)
sw $s2, 114072($s0)
sw $s2, 115096($s0)
sw $s2, 116120($s0)
sw $s2, 117144($s0)
sw $s2, 118168($s0)
sw $s2, 105884($s0)
sw $s2, 111004($s0)
sw $s2, 117148($s0)
sw $s2, 118172($s0)
sw $s2, 105888($s0)
sw $s2, 111008($s0)
sw $s2, 117152($s0)
sw $s2, 118176($s0)
sw $s2, 86436($s0)
sw $s2, 87460($s0)
sw $s2, 88484($s0)
sw $s2, 89508($s0)
sw $s2, 90532($s0)
sw $s2, 91556($s0)
sw $s2, 92580($s0)
sw $s2, 93604($s0)
sw $s2, 94628($s0)
sw $s2, 95652($s0)
sw $s2, 96676($s0)
sw $s2, 97700($s0)
sw $s2, 105892($s0)
sw $s2, 106916($s0)
sw $s2, 107940($s0)
sw $s2, 111012($s0)
sw $s2, 115108($s0)
sw $s2, 116132($s0)
sw $s2, 117156($s0)
sw $s2, 118180($s0)
sw $s2, 86440($s0)
sw $s2, 87464($s0)
sw $s2, 88488($s0)
sw $s2, 89512($s0)
sw $s2, 90536($s0)
sw $s2, 91560($s0)
sw $s2, 92584($s0)
sw $s2, 93608($s0)
sw $s2, 94632($s0)
sw $s2, 95656($s0)
sw $s2, 96680($s0)
sw $s2, 97704($s0)
sw $s2, 105896($s0)
sw $s2, 106920($s0)
sw $s2, 107944($s0)
sw $s2, 115112($s0)
sw $s2, 116136($s0)
sw $s2, 117160($s0)
sw $s2, 118184($s0)
sw $s2, 86444($s0)
sw $s2, 87468($s0)
sw $s2, 88492($s0)
sw $s2, 89516($s0)
sw $s2, 90540($s0)
sw $s2, 91564($s0)
sw $s2, 92588($s0)
sw $s2, 93612($s0)
sw $s2, 94636($s0)
sw $s2, 95660($s0)
sw $s2, 96684($s0)
sw $s2, 97708($s0)
sw $s2, 105900($s0)
sw $s2, 106924($s0)
sw $s2, 107948($s0)
sw $s2, 115116($s0)
sw $s2, 116140($s0)
sw $s2, 117164($s0)
sw $s2, 118188($s0)
sw $s2, 98736($s0)
sw $s2, 99760($s0)
sw $s2, 100784($s0)
sw $s2, 98740($s0)
sw $s2, 99764($s0)
sw $s2, 100788($s0)
sw $s2, 98744($s0)
sw $s2, 99768($s0)
sw $s2, 100792($s0)
sw $s2, 105912($s0)
sw $s2, 106936($s0)
sw $s2, 107960($s0)
sw $s2, 108984($s0)
sw $s2, 110008($s0)
sw $s2, 115128($s0)
sw $s2, 116152($s0)
sw $s2, 117176($s0)
sw $s2, 118200($s0)
sw $s2, 98748($s0)
sw $s2, 99772($s0)
sw $s2, 100796($s0)
sw $s2, 105916($s0)
sw $s2, 106940($s0)
sw $s2, 107964($s0)
sw $s2, 108988($s0)
sw $s2, 110012($s0)
sw $s2, 111036($s0)
sw $s2, 115132($s0)
sw $s2, 116156($s0)
sw $s2, 117180($s0)
sw $s2, 118204($s0)
sw $s2, 98752($s0)
sw $s2, 99776($s0)
sw $s2, 100800($s0)
sw $s2, 105920($s0)
sw $s2, 106944($s0)
sw $s2, 107968($s0)
sw $s2, 108992($s0)
sw $s2, 110016($s0)
sw $s2, 111040($s0)
sw $s2, 115136($s0)
sw $s2, 116160($s0)
sw $s2, 117184($s0)
sw $s2, 118208($s0)
sw $s2, 98756($s0)
sw $s2, 99780($s0)
sw $s2, 100804($s0)
sw $s2, 105924($s0)
sw $s2, 111044($s0)
sw $s2, 117188($s0)
sw $s2, 118212($s0)
sw $s2, 86472($s0)
sw $s2, 87496($s0)
sw $s2, 88520($s0)
sw $s2, 89544($s0)
sw $s2, 90568($s0)
sw $s2, 91592($s0)
sw $s2, 92616($s0)
sw $s2, 93640($s0)
sw $s2, 94664($s0)
sw $s2, 95688($s0)
sw $s2, 96712($s0)
sw $s2, 97736($s0)
sw $s2, 105928($s0)
sw $s2, 111048($s0)
sw $s2, 117192($s0)
sw $s2, 118216($s0)
sw $s2, 86476($s0)
sw $s2, 87500($s0)
sw $s2, 88524($s0)
sw $s2, 89548($s0)
sw $s2, 90572($s0)
sw $s2, 91596($s0)
sw $s2, 92620($s0)
sw $s2, 93644($s0)
sw $s2, 94668($s0)
sw $s2, 95692($s0)
sw $s2, 96716($s0)
sw $s2, 97740($s0)
sw $s2, 105932($s0)
sw $s2, 106956($s0)
sw $s2, 107980($s0)
sw $s2, 111052($s0)
sw $s2, 112076($s0)
sw $s2, 113100($s0)
sw $s2, 114124($s0)
sw $s2, 115148($s0)
sw $s2, 116172($s0)
sw $s2, 117196($s0)
sw $s2, 118220($s0)
sw $s2, 86480($s0)
sw $s2, 87504($s0)
sw $s2, 88528($s0)
sw $s2, 89552($s0)
sw $s2, 90576($s0)
sw $s2, 91600($s0)
sw $s2, 92624($s0)
sw $s2, 93648($s0)
sw $s2, 94672($s0)
sw $s2, 95696($s0)
sw $s2, 96720($s0)
sw $s2, 97744($s0)
sw $s2, 105936($s0)
sw $s2, 106960($s0)
sw $s2, 107984($s0)
sw $s2, 112080($s0)
sw $s2, 113104($s0)
sw $s2, 114128($s0)
sw $s2, 115152($s0)
sw $s2, 116176($s0)
sw $s2, 117200($s0)
sw $s2, 118224($s0)
sw $s2, 105940($s0)
sw $s2, 106964($s0)
sw $s2, 107988($s0)
sw $s2, 112084($s0)
sw $s2, 113108($s0)
sw $s2, 114132($s0)
sw $s2, 115156($s0)
sw $s2, 116180($s0)
sw $s2, 117204($s0)
sw $s2, 118228($s0)
sw $s2, 125396($s0)
sw $s2, 126420($s0)
sw $s2, 127444($s0)
sw $s2, 128468($s0)
sw $s2, 129492($s0)
sw $s2, 125400($s0)
sw $s2, 126424($s0)
sw $s2, 127448($s0)
sw $s2, 128472($s0)
sw $s2, 129496($s0)
sw $s2, 105948($s0)
sw $s2, 125404($s0)
sw $s2, 126428($s0)
sw $s2, 127452($s0)
sw $s2, 128476($s0)
sw $s2, 129500($s0)
sw $s2, 130524($s0)
sw $s2, 131548($s0)
sw $s2, 105952($s0)
sw $s2, 130528($s0)
sw $s2, 131552($s0)
sw $s2, 132576($s0)
sw $s2, 133600($s0)
sw $s2, 134624($s0)
sw $s2, 135648($s0)
sw $s2, 136672($s0)
sw $s2, 137696($s0)
sw $s2, 105956($s0)
sw $s2, 106980($s0)
sw $s2, 108004($s0)
sw $s2, 109028($s0)
sw $s2, 110052($s0)
sw $s2, 111076($s0)
sw $s2, 112100($s0)
sw $s2, 113124($s0)
sw $s2, 114148($s0)
sw $s2, 115172($s0)
sw $s2, 116196($s0)
sw $s2, 117220($s0)
sw $s2, 118244($s0)
sw $s2, 130532($s0)
sw $s2, 131556($s0)
sw $s2, 132580($s0)
sw $s2, 133604($s0)
sw $s2, 134628($s0)
sw $s2, 135652($s0)
sw $s2, 136676($s0)
sw $s2, 137700($s0)
sw $s2, 105960($s0)
sw $s2, 106984($s0)
sw $s2, 108008($s0)
sw $s2, 109032($s0)
sw $s2, 110056($s0)
sw $s2, 111080($s0)
sw $s2, 112104($s0)
sw $s2, 113128($s0)
sw $s2, 114152($s0)
sw $s2, 115176($s0)
sw $s2, 116200($s0)
sw $s2, 117224($s0)
sw $s2, 118248($s0)
sw $s2, 125416($s0)
sw $s2, 126440($s0)
sw $s2, 127464($s0)
sw $s2, 128488($s0)
sw $s2, 129512($s0)
sw $s2, 130536($s0)
sw $s2, 131560($s0)
sw $s2, 132584($s0)
sw $s2, 133608($s0)
sw $s2, 134632($s0)
sw $s2, 135656($s0)
sw $s2, 136680($s0)
sw $s2, 137704($s0)
sw $s2, 105964($s0)
sw $s2, 106988($s0)
sw $s2, 108012($s0)
sw $s2, 109036($s0)
sw $s2, 110060($s0)
sw $s2, 111084($s0)
sw $s2, 112108($s0)
sw $s2, 113132($s0)
sw $s2, 114156($s0)
sw $s2, 115180($s0)
sw $s2, 116204($s0)
sw $s2, 117228($s0)
sw $s2, 118252($s0)
sw $s2, 125420($s0)
sw $s2, 126444($s0)
sw $s2, 127468($s0)
sw $s2, 128492($s0)
sw $s2, 129516($s0)
sw $s2, 130540($s0)
sw $s2, 131564($s0)
sw $s2, 132588($s0)
sw $s2, 133612($s0)
sw $s2, 134636($s0)
sw $s2, 135660($s0)
sw $s2, 136684($s0)
sw $s2, 137708($s0)
sw $s2, 105968($s0)
sw $s2, 125424($s0)
sw $s2, 126448($s0)
sw $s2, 127472($s0)
sw $s2, 128496($s0)
sw $s2, 129520($s0)
sw $s2, 130544($s0)
sw $s2, 131568($s0)
sw $s2, 105972($s0)
sw $s2, 86520($s0)
sw $s2, 87544($s0)
sw $s2, 88568($s0)
sw $s2, 89592($s0)
sw $s2, 90616($s0)
sw $s2, 91640($s0)
sw $s2, 92664($s0)
sw $s2, 93688($s0)
sw $s2, 94712($s0)
sw $s2, 95736($s0)
sw $s2, 96760($s0)
sw $s2, 97784($s0)
sw $s2, 98808($s0)
sw $s2, 99832($s0)
sw $s2, 100856($s0)
sw $s2, 86524($s0)
sw $s2, 87548($s0)
sw $s2, 88572($s0)
sw $s2, 89596($s0)
sw $s2, 90620($s0)
sw $s2, 91644($s0)
sw $s2, 92668($s0)
sw $s2, 93692($s0)
sw $s2, 94716($s0)
sw $s2, 95740($s0)
sw $s2, 96764($s0)
sw $s2, 97788($s0)
sw $s2, 98812($s0)
sw $s2, 99836($s0)
sw $s2, 100860($s0)
sw $s2, 135676($s0)
sw $s2, 136700($s0)
sw $s2, 137724($s0)
sw $s2, 86528($s0)
sw $s2, 87552($s0)
sw $s2, 88576($s0)
sw $s2, 89600($s0)
sw $s2, 90624($s0)
sw $s2, 91648($s0)
sw $s2, 92672($s0)
sw $s2, 93696($s0)
sw $s2, 94720($s0)
sw $s2, 95744($s0)
sw $s2, 96768($s0)
sw $s2, 97792($s0)
sw $s2, 98816($s0)
sw $s2, 99840($s0)
sw $s2, 100864($s0)
sw $s2, 105984($s0)
sw $s2, 107008($s0)
sw $s2, 108032($s0)
sw $s2, 109056($s0)
sw $s2, 110080($s0)
sw $s2, 111104($s0)
sw $s2, 112128($s0)
sw $s2, 113152($s0)
sw $s2, 114176($s0)
sw $s2, 115200($s0)
sw $s2, 116224($s0)
sw $s2, 117248($s0)
sw $s2, 118272($s0)
sw $s2, 135680($s0)
sw $s2, 136704($s0)
sw $s2, 137728($s0)
sw $s2, 98820($s0)
sw $s2, 99844($s0)
sw $s2, 100868($s0)
sw $s2, 105988($s0)
sw $s2, 107012($s0)
sw $s2, 108036($s0)
sw $s2, 109060($s0)
sw $s2, 110084($s0)
sw $s2, 111108($s0)
sw $s2, 112132($s0)
sw $s2, 113156($s0)
sw $s2, 114180($s0)
sw $s2, 115204($s0)
sw $s2, 116228($s0)
sw $s2, 117252($s0)
sw $s2, 118276($s0)
sw $s2, 132612($s0)
sw $s2, 133636($s0)
sw $s2, 134660($s0)
sw $s2, 135684($s0)
sw $s2, 136708($s0)
sw $s2, 137732($s0)
sw $s2, 98824($s0)
sw $s2, 99848($s0)
sw $s2, 100872($s0)
sw $s2, 105992($s0)
sw $s2, 107016($s0)
sw $s2, 108040($s0)
sw $s2, 109064($s0)
sw $s2, 110088($s0)
sw $s2, 111112($s0)
sw $s2, 112136($s0)
sw $s2, 113160($s0)
sw $s2, 114184($s0)
sw $s2, 115208($s0)
sw $s2, 116232($s0)
sw $s2, 117256($s0)
sw $s2, 118280($s0)
sw $s2, 129544($s0)
sw $s2, 130568($s0)
sw $s2, 131592($s0)
sw $s2, 132616($s0)
sw $s2, 133640($s0)
sw $s2, 134664($s0)
sw $s2, 98828($s0)
sw $s2, 99852($s0)
sw $s2, 100876($s0)
sw $s2, 105996($s0)
sw $s2, 111116($s0)
sw $s2, 129548($s0)
sw $s2, 130572($s0)
sw $s2, 131596($s0)
sw $s2, 132620($s0)
sw $s2, 133644($s0)
sw $s2, 134668($s0)
sw $s2, 98832($s0)
sw $s2, 99856($s0)
sw $s2, 100880($s0)
sw $s2, 106000($s0)
sw $s2, 111120($s0)
sw $s2, 125456($s0)
sw $s2, 126480($s0)
sw $s2, 127504($s0)
sw $s2, 128528($s0)
sw $s2, 129552($s0)
sw $s2, 130576($s0)
sw $s2, 131600($s0)
sw $s2, 98836($s0)
sw $s2, 99860($s0)
sw $s2, 100884($s0)
sw $s2, 106004($s0)
sw $s2, 107028($s0)
sw $s2, 108052($s0)
sw $s2, 109076($s0)
sw $s2, 110100($s0)
sw $s2, 111124($s0)
sw $s2, 112148($s0)
sw $s2, 113172($s0)
sw $s2, 114196($s0)
sw $s2, 115220($s0)
sw $s2, 116244($s0)
sw $s2, 117268($s0)
sw $s2, 118292($s0)
sw $s2, 125460($s0)
sw $s2, 126484($s0)
sw $s2, 127508($s0)
sw $s2, 128532($s0)
sw $s2, 98840($s0)
sw $s2, 99864($s0)
sw $s2, 100888($s0)
sw $s2, 106008($s0)
sw $s2, 107032($s0)
sw $s2, 108056($s0)
sw $s2, 109080($s0)
sw $s2, 110104($s0)
sw $s2, 111128($s0)
sw $s2, 112152($s0)
sw $s2, 113176($s0)
sw $s2, 114200($s0)
sw $s2, 115224($s0)
sw $s2, 116248($s0)
sw $s2, 117272($s0)
sw $s2, 118296($s0)
sw $s2, 125464($s0)
sw $s2, 126488($s0)
sw $s2, 127512($s0)
sw $s2, 128536($s0)
sw $s2, 98844($s0)
sw $s2, 99868($s0)
sw $s2, 100892($s0)
sw $s2, 106012($s0)
sw $s2, 107036($s0)
sw $s2, 108060($s0)
sw $s2, 109084($s0)
sw $s2, 110108($s0)
sw $s2, 111132($s0)
sw $s2, 112156($s0)
sw $s2, 113180($s0)
sw $s2, 114204($s0)
sw $s2, 115228($s0)
sw $s2, 116252($s0)
sw $s2, 117276($s0)
sw $s2, 118300($s0)
sw $s2, 98848($s0)
sw $s2, 99872($s0)
sw $s2, 100896($s0)
sw $s2, 98852($s0)
sw $s2, 99876($s0)
sw $s2, 100900($s0)
sw $s2, 125476($s0)
sw $s2, 126500($s0)
sw $s2, 127524($s0)
sw $s2, 128548($s0)
sw $s2, 129572($s0)
sw $s2, 130596($s0)
sw $s2, 131620($s0)
sw $s2, 132644($s0)
sw $s2, 133668($s0)
sw $s2, 134692($s0)
sw $s2, 135716($s0)
sw $s2, 136740($s0)
sw $s2, 137764($s0)
sw $s2, 106024($s0)
sw $s2, 107048($s0)
sw $s2, 108072($s0)
sw $s2, 109096($s0)
sw $s2, 110120($s0)
sw $s2, 111144($s0)
sw $s2, 112168($s0)
sw $s2, 113192($s0)
sw $s2, 114216($s0)
sw $s2, 115240($s0)
sw $s2, 116264($s0)
sw $s2, 117288($s0)
sw $s2, 118312($s0)
sw $s2, 125480($s0)
sw $s2, 126504($s0)
sw $s2, 127528($s0)
sw $s2, 128552($s0)
sw $s2, 129576($s0)
sw $s2, 130600($s0)
sw $s2, 131624($s0)
sw $s2, 132648($s0)
sw $s2, 133672($s0)
sw $s2, 134696($s0)
sw $s2, 135720($s0)
sw $s2, 136744($s0)
sw $s2, 137768($s0)
sw $s2, 106028($s0)
sw $s2, 107052($s0)
sw $s2, 108076($s0)
sw $s2, 109100($s0)
sw $s2, 110124($s0)
sw $s2, 111148($s0)
sw $s2, 112172($s0)
sw $s2, 113196($s0)
sw $s2, 114220($s0)
sw $s2, 115244($s0)
sw $s2, 116268($s0)
sw $s2, 117292($s0)
sw $s2, 118316($s0)
sw $s2, 125484($s0)
sw $s2, 126508($s0)
sw $s2, 127532($s0)
sw $s2, 128556($s0)
sw $s2, 129580($s0)
sw $s2, 130604($s0)
sw $s2, 131628($s0)
sw $s2, 132652($s0)
sw $s2, 133676($s0)
sw $s2, 134700($s0)
sw $s2, 135724($s0)
sw $s2, 136748($s0)
sw $s2, 137772($s0)
sw $s2, 106032($s0)
sw $s2, 107056($s0)
sw $s2, 108080($s0)
sw $s2, 109104($s0)
sw $s2, 110128($s0)
sw $s2, 111152($s0)
sw $s2, 112176($s0)
sw $s2, 113200($s0)
sw $s2, 114224($s0)
sw $s2, 115248($s0)
sw $s2, 116272($s0)
sw $s2, 117296($s0)
sw $s2, 118320($s0)
sw $s2, 127536($s0)
sw $s2, 128560($s0)
sw $s2, 129584($s0)
sw $s2, 89652($s0)
sw $s2, 90676($s0)
sw $s2, 91700($s0)
sw $s2, 92724($s0)
sw $s2, 93748($s0)
sw $s2, 94772($s0)
sw $s2, 95796($s0)
sw $s2, 96820($s0)
sw $s2, 97844($s0)
sw $s2, 106036($s0)
sw $s2, 111156($s0)
sw $s2, 127540($s0)
sw $s2, 128564($s0)
sw $s2, 129588($s0)
sw $s2, 89656($s0)
sw $s2, 90680($s0)
sw $s2, 91704($s0)
sw $s2, 92728($s0)
sw $s2, 93752($s0)
sw $s2, 94776($s0)
sw $s2, 95800($s0)
sw $s2, 96824($s0)
sw $s2, 97848($s0)
sw $s2, 106040($s0)
sw $s2, 107064($s0)
sw $s2, 108088($s0)
sw $s2, 109112($s0)
sw $s2, 110136($s0)
sw $s2, 111160($s0)
sw $s2, 112184($s0)
sw $s2, 113208($s0)
sw $s2, 114232($s0)
sw $s2, 115256($s0)
sw $s2, 116280($s0)
sw $s2, 117304($s0)
sw $s2, 118328($s0)
sw $s2, 129592($s0)
sw $s2, 130616($s0)
sw $s2, 131640($s0)
sw $s2, 89660($s0)
sw $s2, 90684($s0)
sw $s2, 91708($s0)
sw $s2, 92732($s0)
sw $s2, 93756($s0)
sw $s2, 94780($s0)
sw $s2, 95804($s0)
sw $s2, 96828($s0)
sw $s2, 97852($s0)
sw $s2, 106044($s0)
sw $s2, 107068($s0)
sw $s2, 108092($s0)
sw $s2, 109116($s0)
sw $s2, 110140($s0)
sw $s2, 111164($s0)
sw $s2, 112188($s0)
sw $s2, 113212($s0)
sw $s2, 114236($s0)
sw $s2, 115260($s0)
sw $s2, 116284($s0)
sw $s2, 117308($s0)
sw $s2, 118332($s0)
sw $s2, 125500($s0)
sw $s2, 126524($s0)
sw $s2, 127548($s0)
sw $s2, 128572($s0)
sw $s2, 129596($s0)
sw $s2, 130620($s0)
sw $s2, 131644($s0)
sw $s2, 132668($s0)
sw $s2, 133692($s0)
sw $s2, 134716($s0)
sw $s2, 135740($s0)
sw $s2, 136764($s0)
sw $s2, 137788($s0)
sw $s2, 86592($s0)
sw $s2, 87616($s0)
sw $s2, 88640($s0)
sw $s2, 98880($s0)
sw $s2, 99904($s0)
sw $s2, 100928($s0)
sw $s2, 106048($s0)
sw $s2, 107072($s0)
sw $s2, 108096($s0)
sw $s2, 109120($s0)
sw $s2, 110144($s0)
sw $s2, 112192($s0)
sw $s2, 113216($s0)
sw $s2, 114240($s0)
sw $s2, 115264($s0)
sw $s2, 116288($s0)
sw $s2, 117312($s0)
sw $s2, 118336($s0)
sw $s2, 125504($s0)
sw $s2, 126528($s0)
sw $s2, 127552($s0)
sw $s2, 128576($s0)
sw $s2, 129600($s0)
sw $s2, 130624($s0)
sw $s2, 131648($s0)
sw $s2, 132672($s0)
sw $s2, 133696($s0)
sw $s2, 134720($s0)
sw $s2, 135744($s0)
sw $s2, 136768($s0)
sw $s2, 137792($s0)
sw $s2, 86596($s0)
sw $s2, 87620($s0)
sw $s2, 88644($s0)
sw $s2, 98884($s0)
sw $s2, 99908($s0)
sw $s2, 100932($s0)
sw $s2, 106052($s0)
sw $s2, 107076($s0)
sw $s2, 108100($s0)
sw $s2, 109124($s0)
sw $s2, 110148($s0)
sw $s2, 112196($s0)
sw $s2, 113220($s0)
sw $s2, 114244($s0)
sw $s2, 115268($s0)
sw $s2, 116292($s0)
sw $s2, 117316($s0)
sw $s2, 118340($s0)
sw $s2, 125508($s0)
sw $s2, 126532($s0)
sw $s2, 127556($s0)
sw $s2, 128580($s0)
sw $s2, 129604($s0)
sw $s2, 130628($s0)
sw $s2, 131652($s0)
sw $s2, 132676($s0)
sw $s2, 133700($s0)
sw $s2, 134724($s0)
sw $s2, 135748($s0)
sw $s2, 136772($s0)
sw $s2, 137796($s0)
sw $s2, 86600($s0)
sw $s2, 87624($s0)
sw $s2, 88648($s0)
sw $s2, 98888($s0)
sw $s2, 99912($s0)
sw $s2, 100936($s0)
sw $s2, 125512($s0)
sw $s2, 126536($s0)
sw $s2, 127560($s0)
sw $s2, 128584($s0)
sw $s2, 129608($s0)
sw $s2, 130632($s0)
sw $s2, 131656($s0)
sw $s2, 132680($s0)
sw $s2, 133704($s0)
sw $s2, 134728($s0)
sw $s2, 135752($s0)
sw $s2, 136776($s0)
sw $s2, 137800($s0)
sw $s2, 86604($s0)
sw $s2, 87628($s0)
sw $s2, 88652($s0)
sw $s2, 98892($s0)
sw $s2, 99916($s0)
sw $s2, 100940($s0)
sw $s2, 106060($s0)
sw $s2, 86608($s0)
sw $s2, 87632($s0)
sw $s2, 88656($s0)
sw $s2, 98896($s0)
sw $s2, 99920($s0)
sw $s2, 100944($s0)
sw $s2, 106064($s0)
sw $s2, 86612($s0)
sw $s2, 87636($s0)
sw $s2, 88660($s0)
sw $s2, 98900($s0)
sw $s2, 99924($s0)
sw $s2, 100948($s0)
sw $s2, 106068($s0)
sw $s2, 107092($s0)
sw $s2, 108116($s0)
sw $s2, 109140($s0)
sw $s2, 110164($s0)
sw $s2, 111188($s0)
sw $s2, 112212($s0)
sw $s2, 113236($s0)
sw $s2, 114260($s0)
sw $s2, 115284($s0)
sw $s2, 116308($s0)
sw $s2, 117332($s0)
sw $s2, 118356($s0)
sw $s2, 89688($s0)
sw $s2, 90712($s0)
sw $s2, 91736($s0)
sw $s2, 92760($s0)
sw $s2, 93784($s0)
sw $s2, 94808($s0)
sw $s2, 95832($s0)
sw $s2, 96856($s0)
sw $s2, 97880($s0)
sw $s2, 106072($s0)
sw $s2, 107096($s0)
sw $s2, 108120($s0)
sw $s2, 109144($s0)
sw $s2, 110168($s0)
sw $s2, 111192($s0)
sw $s2, 112216($s0)
sw $s2, 113240($s0)
sw $s2, 114264($s0)
sw $s2, 115288($s0)
sw $s2, 116312($s0)
sw $s2, 117336($s0)
sw $s2, 118360($s0)
sw $s2, 89692($s0)
sw $s2, 90716($s0)
sw $s2, 91740($s0)
sw $s2, 92764($s0)
sw $s2, 93788($s0)
sw $s2, 94812($s0)
sw $s2, 95836($s0)
sw $s2, 96860($s0)
sw $s2, 97884($s0)
sw $s2, 106076($s0)
sw $s2, 107100($s0)
sw $s2, 108124($s0)
sw $s2, 109148($s0)
sw $s2, 110172($s0)
sw $s2, 111196($s0)
sw $s2, 112220($s0)
sw $s2, 113244($s0)
sw $s2, 114268($s0)
sw $s2, 115292($s0)
sw $s2, 116316($s0)
sw $s2, 117340($s0)
sw $s2, 118364($s0)
sw $s2, 89696($s0)
sw $s2, 90720($s0)
sw $s2, 91744($s0)
sw $s2, 92768($s0)
sw $s2, 93792($s0)
sw $s2, 94816($s0)
sw $s2, 95840($s0)
sw $s2, 96864($s0)
sw $s2, 97888($s0)
sw $s2, 106080($s0)
sw $s2, 106084($s0)
sw $s2, 89712($s0)
sw $s2, 90736($s0)
sw $s2, 91760($s0)
sw $s2, 98928($s0)
sw $s2, 99952($s0)
sw $s2, 100976($s0)
sw $s2, 107120($s0)
sw $s2, 108144($s0)
sw $s2, 89716($s0)
sw $s2, 90740($s0)
sw $s2, 91764($s0)
sw $s2, 98932($s0)
sw $s2, 99956($s0)
sw $s2, 100980($s0)
sw $s2, 106100($s0)
sw $s2, 107124($s0)
sw $s2, 108148($s0)
sw $s2, 89720($s0)
sw $s2, 90744($s0)
sw $s2, 91768($s0)
sw $s2, 98936($s0)
sw $s2, 99960($s0)
sw $s2, 100984($s0)
sw $s2, 106104($s0)
sw $s2, 107128($s0)
sw $s2, 108152($s0)
sw $s2, 86652($s0)
sw $s2, 87676($s0)
sw $s2, 88700($s0)
sw $s2, 92796($s0)
sw $s2, 93820($s0)
sw $s2, 94844($s0)
sw $s2, 98940($s0)
sw $s2, 99964($s0)
sw $s2, 100988($s0)
sw $s2, 106108($s0)
sw $s2, 107132($s0)
sw $s2, 108156($s0)
sw $s2, 111228($s0)
sw $s2, 112252($s0)
sw $s2, 113276($s0)
sw $s2, 115324($s0)
sw $s2, 116348($s0)
sw $s2, 117372($s0)
sw $s2, 118396($s0)
sw $s2, 86656($s0)
sw $s2, 87680($s0)
sw $s2, 88704($s0)
sw $s2, 92800($s0)
sw $s2, 93824($s0)
sw $s2, 94848($s0)
sw $s2, 98944($s0)
sw $s2, 99968($s0)
sw $s2, 100992($s0)
sw $s2, 106112($s0)
sw $s2, 107136($s0)
sw $s2, 108160($s0)
sw $s2, 111232($s0)
sw $s2, 112256($s0)
sw $s2, 113280($s0)
sw $s2, 115328($s0)
sw $s2, 116352($s0)
sw $s2, 117376($s0)
sw $s2, 118400($s0)
sw $s2, 86660($s0)
sw $s2, 87684($s0)
sw $s2, 88708($s0)
sw $s2, 92804($s0)
sw $s2, 93828($s0)
sw $s2, 94852($s0)
sw $s2, 98948($s0)
sw $s2, 99972($s0)
sw $s2, 100996($s0)
sw $s2, 106116($s0)
sw $s2, 107140($s0)
sw $s2, 108164($s0)
sw $s2, 111236($s0)
sw $s2, 112260($s0)
sw $s2, 113284($s0)
sw $s2, 115332($s0)
sw $s2, 116356($s0)
sw $s2, 117380($s0)
sw $s2, 118404($s0)
sw $s2, 86664($s0)
sw $s2, 87688($s0)
sw $s2, 88712($s0)
sw $s2, 92808($s0)
sw $s2, 93832($s0)
sw $s2, 94856($s0)
sw $s2, 98952($s0)
sw $s2, 99976($s0)
sw $s2, 101000($s0)
sw $s2, 106120($s0)
sw $s2, 107144($s0)
sw $s2, 108168($s0)
sw $s2, 109192($s0)
sw $s2, 110216($s0)
sw $s2, 111240($s0)
sw $s2, 86668($s0)
sw $s2, 87692($s0)
sw $s2, 88716($s0)
sw $s2, 92812($s0)
sw $s2, 93836($s0)
sw $s2, 94860($s0)
sw $s2, 98956($s0)
sw $s2, 99980($s0)
sw $s2, 101004($s0)
sw $s2, 106124($s0)
sw $s2, 107148($s0)
sw $s2, 108172($s0)
sw $s2, 109196($s0)
sw $s2, 110220($s0)
sw $s2, 111244($s0)
sw $s2, 86672($s0)
sw $s2, 87696($s0)
sw $s2, 88720($s0)
sw $s2, 92816($s0)
sw $s2, 93840($s0)
sw $s2, 94864($s0)
sw $s2, 98960($s0)
sw $s2, 99984($s0)
sw $s2, 101008($s0)
sw $s2, 107152($s0)
sw $s2, 108176($s0)
sw $s2, 109200($s0)
sw $s2, 110224($s0)
sw $s2, 86676($s0)
sw $s2, 87700($s0)
sw $s2, 88724($s0)
sw $s2, 95892($s0)
sw $s2, 96916($s0)
sw $s2, 97940($s0)
sw $s2, 107156($s0)
sw $s2, 108180($s0)
sw $s2, 109204($s0)
sw $s2, 110228($s0)
sw $s2, 86680($s0)
sw $s2, 87704($s0)
sw $s2, 88728($s0)
sw $s2, 95896($s0)
sw $s2, 96920($s0)
sw $s2, 97944($s0)
sw $s2, 86684($s0)
sw $s2, 87708($s0)
sw $s2, 88732($s0)
sw $s2, 95900($s0)
sw $s2, 96924($s0)
sw $s2, 97948($s0)
sw $s2, 86700($s0)
sw $s2, 87724($s0)
sw $s2, 88748($s0)
sw $s2, 89772($s0)
sw $s2, 90796($s0)
sw $s2, 91820($s0)
sw $s2, 92844($s0)
sw $s2, 93868($s0)
sw $s2, 94892($s0)
sw $s2, 95916($s0)
sw $s2, 96940($s0)
sw $s2, 97964($s0)
sw $s2, 98988($s0)
sw $s2, 100012($s0)
sw $s2, 101036($s0)
sw $s2, 86704($s0)
sw $s2, 87728($s0)
sw $s2, 88752($s0)
sw $s2, 89776($s0)
sw $s2, 90800($s0)
sw $s2, 91824($s0)
sw $s2, 92848($s0)
sw $s2, 93872($s0)
sw $s2, 94896($s0)
sw $s2, 95920($s0)
sw $s2, 96944($s0)
sw $s2, 97968($s0)
sw $s2, 98992($s0)
sw $s2, 100016($s0)
sw $s2, 101040($s0)
sw $s2, 86708($s0)
sw $s2, 87732($s0)
sw $s2, 88756($s0)
sw $s2, 89780($s0)
sw $s2, 90804($s0)
sw $s2, 91828($s0)
sw $s2, 92852($s0)
sw $s2, 93876($s0)
sw $s2, 94900($s0)
sw $s2, 95924($s0)
sw $s2, 96948($s0)
sw $s2, 97972($s0)
sw $s2, 98996($s0)
sw $s2, 100020($s0)
sw $s2, 101044($s0)
sw $s2, 86712($s0)
sw $s2, 87736($s0)
sw $s2, 88760($s0)
sw $s2, 92856($s0)
sw $s2, 93880($s0)
sw $s2, 94904($s0)
sw $s2, 99000($s0)
sw $s2, 100024($s0)
sw $s2, 101048($s0)
sw $s2, 86716($s0)
sw $s2, 87740($s0)
sw $s2, 88764($s0)
sw $s2, 92860($s0)
sw $s2, 93884($s0)
sw $s2, 94908($s0)
sw $s2, 99004($s0)
sw $s2, 100028($s0)
sw $s2, 101052($s0)
sw $s2, 86720($s0)
sw $s2, 87744($s0)
sw $s2, 88768($s0)
sw $s2, 92864($s0)
sw $s2, 93888($s0)
sw $s2, 94912($s0)
sw $s2, 99008($s0)
sw $s2, 100032($s0)
sw $s2, 101056($s0)
sw $s2, 86724($s0)
sw $s2, 87748($s0)
sw $s2, 88772($s0)
sw $s2, 92868($s0)
sw $s2, 93892($s0)
sw $s2, 94916($s0)
sw $s2, 99012($s0)
sw $s2, 100036($s0)
sw $s2, 101060($s0)
sw $s2, 86728($s0)
sw $s2, 87752($s0)
sw $s2, 88776($s0)
sw $s2, 92872($s0)
sw $s2, 93896($s0)
sw $s2, 94920($s0)
sw $s2, 99016($s0)
sw $s2, 100040($s0)
sw $s2, 101064($s0)
sw $s2, 86732($s0)
sw $s2, 87756($s0)
sw $s2, 88780($s0)
sw $s2, 92876($s0)
sw $s2, 93900($s0)
sw $s2, 94924($s0)
sw $s2, 99020($s0)
sw $s2, 100044($s0)
sw $s2, 101068($s0)
sw $s2, 86736($s0)
sw $s2, 87760($s0)
sw $s2, 88784($s0)
sw $s2, 99024($s0)
sw $s2, 100048($s0)
sw $s2, 101072($s0)
sw $s2, 86740($s0)
sw $s2, 87764($s0)
sw $s2, 88788($s0)
sw $s2, 99028($s0)
sw $s2, 100052($s0)
sw $s2, 101076($s0)
sw $s2, 86744($s0)
sw $s2, 87768($s0)
sw $s2, 88792($s0)
sw $s2, 99032($s0)
sw $s2, 100056($s0)
sw $s2, 101080($s0)
j checkRestart



renderWin: #registers used : $t0, $t1

	li $a0, 80
	
	lw $s0, displayAddress
	li $s1, 0
	
	
	
	sll	$a0, $a0, 10
	
	add $s0, $s0, $a0
	
	li $t0, 256
	li $t1, 60
	
	loopW:
	sw	$s1, ($s0)
	addi	$s0, $s0, 4
	addi 	$t0, $t0, -1
	
	bne	$t0, $zero, loopW
	
	
	addi	$t1, $t1, -1
	li 	$t0, 256
	
	bne	$t1, $zero, loopW
	
	li	$s2, 0x00ffffff
	
	lw $s0, displayAddress
	sll	$a0, $a0, 10
	
	
sw $s2, 86328($s0)
sw $s2, 87352($s0)
sw $s2, 88376($s0)
sw $s2, 89400($s0)
sw $s2, 90424($s0)
sw $s2, 91448($s0)
sw $s2, 86332($s0)
sw $s2, 87356($s0)
sw $s2, 88380($s0)
sw $s2, 89404($s0)
sw $s2, 90428($s0)
sw $s2, 91452($s0)
sw $s2, 86336($s0)
sw $s2, 87360($s0)
sw $s2, 88384($s0)
sw $s2, 89408($s0)
sw $s2, 90432($s0)
sw $s2, 91456($s0)
sw $s2, 92484($s0)
sw $s2, 93508($s0)
sw $s2, 94532($s0)
sw $s2, 92488($s0)
sw $s2, 93512($s0)
sw $s2, 94536($s0)
sw $s2, 92492($s0)
sw $s2, 93516($s0)
sw $s2, 94540($s0)
sw $s2, 92496($s0)
sw $s2, 93520($s0)
sw $s2, 94544($s0)
sw $s2, 95568($s0)
sw $s2, 96592($s0)
sw $s2, 97616($s0)
sw $s2, 98640($s0)
sw $s2, 99664($s0)
sw $s2, 100688($s0)
sw $s2, 92500($s0)
sw $s2, 93524($s0)
sw $s2, 94548($s0)
sw $s2, 95572($s0)
sw $s2, 96596($s0)
sw $s2, 97620($s0)
sw $s2, 98644($s0)
sw $s2, 99668($s0)
sw $s2, 100692($s0)
sw $s2, 92504($s0)
sw $s2, 93528($s0)
sw $s2, 94552($s0)
sw $s2, 95576($s0)
sw $s2, 96600($s0)
sw $s2, 97624($s0)
sw $s2, 98648($s0)
sw $s2, 99672($s0)
sw $s2, 100696($s0)
sw $s2, 92508($s0)
sw $s2, 93532($s0)
sw $s2, 94556($s0)
sw $s2, 92512($s0)
sw $s2, 93536($s0)
sw $s2, 94560($s0)
sw $s2, 92516($s0)
sw $s2, 93540($s0)
sw $s2, 94564($s0)
sw $s2, 86376($s0)
sw $s2, 87400($s0)
sw $s2, 88424($s0)
sw $s2, 89448($s0)
sw $s2, 90472($s0)
sw $s2, 91496($s0)
sw $s2, 105832($s0)
sw $s2, 106856($s0)
sw $s2, 107880($s0)
sw $s2, 108904($s0)
sw $s2, 109928($s0)
sw $s2, 110952($s0)
sw $s2, 111976($s0)
sw $s2, 113000($s0)
sw $s2, 114024($s0)
sw $s2, 115048($s0)
sw $s2, 116072($s0)
sw $s2, 117096($s0)
sw $s2, 118120($s0)
sw $s2, 86380($s0)
sw $s2, 87404($s0)
sw $s2, 88428($s0)
sw $s2, 89452($s0)
sw $s2, 90476($s0)
sw $s2, 91500($s0)
sw $s2, 105836($s0)
sw $s2, 106860($s0)
sw $s2, 107884($s0)
sw $s2, 108908($s0)
sw $s2, 109932($s0)
sw $s2, 110956($s0)
sw $s2, 111980($s0)
sw $s2, 113004($s0)
sw $s2, 114028($s0)
sw $s2, 115052($s0)
sw $s2, 116076($s0)
sw $s2, 117100($s0)
sw $s2, 118124($s0)
sw $s2, 86384($s0)
sw $s2, 87408($s0)
sw $s2, 88432($s0)
sw $s2, 89456($s0)
sw $s2, 90480($s0)
sw $s2, 91504($s0)
sw $s2, 105840($s0)
sw $s2, 106864($s0)
sw $s2, 107888($s0)
sw $s2, 108912($s0)
sw $s2, 109936($s0)
sw $s2, 110960($s0)
sw $s2, 111984($s0)
sw $s2, 113008($s0)
sw $s2, 114032($s0)
sw $s2, 115056($s0)
sw $s2, 116080($s0)
sw $s2, 117104($s0)
sw $s2, 118128($s0)
sw $s2, 105844($s0)
sw $s2, 110964($s0)
sw $s2, 105848($s0)
sw $s2, 110968($s0)
sw $s2, 105852($s0)
sw $s2, 106876($s0)
sw $s2, 107900($s0)
sw $s2, 108924($s0)
sw $s2, 109948($s0)
sw $s2, 110972($s0)
sw $s2, 111996($s0)
sw $s2, 113020($s0)
sw $s2, 114044($s0)
sw $s2, 115068($s0)
sw $s2, 116092($s0)
sw $s2, 117116($s0)
sw $s2, 118140($s0)
sw $s2, 89472($s0)
sw $s2, 90496($s0)
sw $s2, 91520($s0)
sw $s2, 92544($s0)
sw $s2, 93568($s0)
sw $s2, 94592($s0)
sw $s2, 95616($s0)
sw $s2, 96640($s0)
sw $s2, 97664($s0)
sw $s2, 105856($s0)
sw $s2, 106880($s0)
sw $s2, 107904($s0)
sw $s2, 108928($s0)
sw $s2, 109952($s0)
sw $s2, 112000($s0)
sw $s2, 113024($s0)
sw $s2, 114048($s0)
sw $s2, 115072($s0)
sw $s2, 116096($s0)
sw $s2, 117120($s0)
sw $s2, 118144($s0)
sw $s2, 89476($s0)
sw $s2, 90500($s0)
sw $s2, 91524($s0)
sw $s2, 92548($s0)
sw $s2, 93572($s0)
sw $s2, 94596($s0)
sw $s2, 95620($s0)
sw $s2, 96644($s0)
sw $s2, 97668($s0)
sw $s2, 105860($s0)
sw $s2, 106884($s0)
sw $s2, 107908($s0)
sw $s2, 108932($s0)
sw $s2, 109956($s0)
sw $s2, 112004($s0)
sw $s2, 113028($s0)
sw $s2, 114052($s0)
sw $s2, 115076($s0)
sw $s2, 116100($s0)
sw $s2, 117124($s0)
sw $s2, 118148($s0)
sw $s2, 89480($s0)
sw $s2, 90504($s0)
sw $s2, 91528($s0)
sw $s2, 92552($s0)
sw $s2, 93576($s0)
sw $s2, 94600($s0)
sw $s2, 95624($s0)
sw $s2, 96648($s0)
sw $s2, 97672($s0)
sw $s2, 86412($s0)
sw $s2, 87436($s0)
sw $s2, 88460($s0)
sw $s2, 98700($s0)
sw $s2, 99724($s0)
sw $s2, 100748($s0)
sw $s2, 86416($s0)
sw $s2, 87440($s0)
sw $s2, 88464($s0)
sw $s2, 98704($s0)
sw $s2, 99728($s0)
sw $s2, 100752($s0)
sw $s2, 105872($s0)
sw $s2, 106896($s0)
sw $s2, 107920($s0)
sw $s2, 108944($s0)
sw $s2, 109968($s0)
sw $s2, 110992($s0)
sw $s2, 112016($s0)
sw $s2, 113040($s0)
sw $s2, 114064($s0)
sw $s2, 115088($s0)
sw $s2, 116112($s0)
sw $s2, 117136($s0)
sw $s2, 118160($s0)
sw $s2, 86420($s0)
sw $s2, 87444($s0)
sw $s2, 88468($s0)
sw $s2, 98708($s0)
sw $s2, 99732($s0)
sw $s2, 100756($s0)
sw $s2, 105876($s0)
sw $s2, 106900($s0)
sw $s2, 107924($s0)
sw $s2, 108948($s0)
sw $s2, 109972($s0)
sw $s2, 110996($s0)
sw $s2, 112020($s0)
sw $s2, 113044($s0)
sw $s2, 114068($s0)
sw $s2, 115092($s0)
sw $s2, 116116($s0)
sw $s2, 117140($s0)
sw $s2, 118164($s0)
sw $s2, 86424($s0)
sw $s2, 87448($s0)
sw $s2, 88472($s0)
sw $s2, 98712($s0)
sw $s2, 99736($s0)
sw $s2, 100760($s0)
sw $s2, 105880($s0)
sw $s2, 106904($s0)
sw $s2, 107928($s0)
sw $s2, 108952($s0)
sw $s2, 109976($s0)
sw $s2, 111000($s0)
sw $s2, 112024($s0)
sw $s2, 113048($s0)
sw $s2, 114072($s0)
sw $s2, 115096($s0)
sw $s2, 116120($s0)
sw $s2, 117144($s0)
sw $s2, 118168($s0)
sw $s2, 86428($s0)
sw $s2, 87452($s0)
sw $s2, 88476($s0)
sw $s2, 98716($s0)
sw $s2, 99740($s0)
sw $s2, 100764($s0)
sw $s2, 105884($s0)
sw $s2, 111004($s0)
sw $s2, 117148($s0)
sw $s2, 118172($s0)
sw $s2, 86432($s0)
sw $s2, 87456($s0)
sw $s2, 88480($s0)
sw $s2, 98720($s0)
sw $s2, 99744($s0)
sw $s2, 100768($s0)
sw $s2, 105888($s0)
sw $s2, 111008($s0)
sw $s2, 117152($s0)
sw $s2, 118176($s0)
sw $s2, 89508($s0)
sw $s2, 90532($s0)
sw $s2, 91556($s0)
sw $s2, 92580($s0)
sw $s2, 93604($s0)
sw $s2, 94628($s0)
sw $s2, 95652($s0)
sw $s2, 96676($s0)
sw $s2, 97700($s0)
sw $s2, 105892($s0)
sw $s2, 106916($s0)
sw $s2, 107940($s0)
sw $s2, 111012($s0)
sw $s2, 115108($s0)
sw $s2, 116132($s0)
sw $s2, 117156($s0)
sw $s2, 118180($s0)
sw $s2, 89512($s0)
sw $s2, 90536($s0)
sw $s2, 91560($s0)
sw $s2, 92584($s0)
sw $s2, 93608($s0)
sw $s2, 94632($s0)
sw $s2, 95656($s0)
sw $s2, 96680($s0)
sw $s2, 97704($s0)
sw $s2, 105896($s0)
sw $s2, 106920($s0)
sw $s2, 107944($s0)
sw $s2, 115112($s0)
sw $s2, 116136($s0)
sw $s2, 117160($s0)
sw $s2, 118184($s0)
sw $s2, 89516($s0)
sw $s2, 90540($s0)
sw $s2, 91564($s0)
sw $s2, 92588($s0)
sw $s2, 93612($s0)
sw $s2, 94636($s0)
sw $s2, 95660($s0)
sw $s2, 96684($s0)
sw $s2, 97708($s0)
sw $s2, 105900($s0)
sw $s2, 106924($s0)
sw $s2, 107948($s0)
sw $s2, 115116($s0)
sw $s2, 116140($s0)
sw $s2, 117164($s0)
sw $s2, 118188($s0)
sw $s2, 105912($s0)
sw $s2, 106936($s0)
sw $s2, 107960($s0)
sw $s2, 108984($s0)
sw $s2, 110008($s0)
sw $s2, 115128($s0)
sw $s2, 116152($s0)
sw $s2, 117176($s0)
sw $s2, 118200($s0)
sw $s2, 86460($s0)
sw $s2, 87484($s0)
sw $s2, 88508($s0)
sw $s2, 89532($s0)
sw $s2, 90556($s0)
sw $s2, 91580($s0)
sw $s2, 92604($s0)
sw $s2, 93628($s0)
sw $s2, 94652($s0)
sw $s2, 95676($s0)
sw $s2, 96700($s0)
sw $s2, 97724($s0)
sw $s2, 105916($s0)
sw $s2, 106940($s0)
sw $s2, 107964($s0)
sw $s2, 108988($s0)
sw $s2, 110012($s0)
sw $s2, 111036($s0)
sw $s2, 115132($s0)
sw $s2, 116156($s0)
sw $s2, 117180($s0)
sw $s2, 118204($s0)
sw $s2, 86464($s0)
sw $s2, 87488($s0)
sw $s2, 88512($s0)
sw $s2, 89536($s0)
sw $s2, 90560($s0)
sw $s2, 91584($s0)
sw $s2, 92608($s0)
sw $s2, 93632($s0)
sw $s2, 94656($s0)
sw $s2, 95680($s0)
sw $s2, 96704($s0)
sw $s2, 97728($s0)
sw $s2, 105920($s0)
sw $s2, 106944($s0)
sw $s2, 107968($s0)
sw $s2, 108992($s0)
sw $s2, 110016($s0)
sw $s2, 111040($s0)
sw $s2, 115136($s0)
sw $s2, 116160($s0)
sw $s2, 117184($s0)
sw $s2, 118208($s0)
sw $s2, 86468($s0)
sw $s2, 87492($s0)
sw $s2, 88516($s0)
sw $s2, 89540($s0)
sw $s2, 90564($s0)
sw $s2, 91588($s0)
sw $s2, 92612($s0)
sw $s2, 93636($s0)
sw $s2, 94660($s0)
sw $s2, 95684($s0)
sw $s2, 96708($s0)
sw $s2, 97732($s0)
sw $s2, 105924($s0)
sw $s2, 111044($s0)
sw $s2, 117188($s0)
sw $s2, 118212($s0)
sw $s2, 98760($s0)
sw $s2, 99784($s0)
sw $s2, 100808($s0)
sw $s2, 105928($s0)
sw $s2, 111048($s0)
sw $s2, 117192($s0)
sw $s2, 118216($s0)
sw $s2, 98764($s0)
sw $s2, 99788($s0)
sw $s2, 100812($s0)
sw $s2, 105932($s0)
sw $s2, 106956($s0)
sw $s2, 107980($s0)
sw $s2, 111052($s0)
sw $s2, 112076($s0)
sw $s2, 113100($s0)
sw $s2, 114124($s0)
sw $s2, 115148($s0)
sw $s2, 116172($s0)
sw $s2, 117196($s0)
sw $s2, 118220($s0)
sw $s2, 98768($s0)
sw $s2, 99792($s0)
sw $s2, 100816($s0)
sw $s2, 105936($s0)
sw $s2, 106960($s0)
sw $s2, 107984($s0)
sw $s2, 112080($s0)
sw $s2, 113104($s0)
sw $s2, 114128($s0)
sw $s2, 115152($s0)
sw $s2, 116176($s0)
sw $s2, 117200($s0)
sw $s2, 118224($s0)
sw $s2, 98772($s0)
sw $s2, 99796($s0)
sw $s2, 100820($s0)
sw $s2, 105940($s0)
sw $s2, 106964($s0)
sw $s2, 107988($s0)
sw $s2, 112084($s0)
sw $s2, 113108($s0)
sw $s2, 114132($s0)
sw $s2, 115156($s0)
sw $s2, 116180($s0)
sw $s2, 117204($s0)
sw $s2, 118228($s0)
sw $s2, 125396($s0)
sw $s2, 126420($s0)
sw $s2, 127444($s0)
sw $s2, 128468($s0)
sw $s2, 129492($s0)
sw $s2, 98776($s0)
sw $s2, 99800($s0)
sw $s2, 100824($s0)
sw $s2, 125400($s0)
sw $s2, 126424($s0)
sw $s2, 127448($s0)
sw $s2, 128472($s0)
sw $s2, 129496($s0)
sw $s2, 98780($s0)
sw $s2, 99804($s0)
sw $s2, 100828($s0)
sw $s2, 105948($s0)
sw $s2, 125404($s0)
sw $s2, 126428($s0)
sw $s2, 127452($s0)
sw $s2, 128476($s0)
sw $s2, 129500($s0)
sw $s2, 130524($s0)
sw $s2, 131548($s0)
sw $s2, 86496($s0)
sw $s2, 87520($s0)
sw $s2, 88544($s0)
sw $s2, 89568($s0)
sw $s2, 90592($s0)
sw $s2, 91616($s0)
sw $s2, 92640($s0)
sw $s2, 93664($s0)
sw $s2, 94688($s0)
sw $s2, 95712($s0)
sw $s2, 96736($s0)
sw $s2, 97760($s0)
sw $s2, 105952($s0)
sw $s2, 130528($s0)
sw $s2, 131552($s0)
sw $s2, 132576($s0)
sw $s2, 133600($s0)
sw $s2, 134624($s0)
sw $s2, 135648($s0)
sw $s2, 136672($s0)
sw $s2, 137696($s0)
sw $s2, 86500($s0)
sw $s2, 87524($s0)
sw $s2, 88548($s0)
sw $s2, 89572($s0)
sw $s2, 90596($s0)
sw $s2, 91620($s0)
sw $s2, 92644($s0)
sw $s2, 93668($s0)
sw $s2, 94692($s0)
sw $s2, 95716($s0)
sw $s2, 96740($s0)
sw $s2, 97764($s0)
sw $s2, 105956($s0)
sw $s2, 106980($s0)
sw $s2, 108004($s0)
sw $s2, 109028($s0)
sw $s2, 110052($s0)
sw $s2, 111076($s0)
sw $s2, 112100($s0)
sw $s2, 113124($s0)
sw $s2, 114148($s0)
sw $s2, 115172($s0)
sw $s2, 116196($s0)
sw $s2, 117220($s0)
sw $s2, 118244($s0)
sw $s2, 130532($s0)
sw $s2, 131556($s0)
sw $s2, 132580($s0)
sw $s2, 133604($s0)
sw $s2, 134628($s0)
sw $s2, 135652($s0)
sw $s2, 136676($s0)
sw $s2, 137700($s0)
sw $s2, 86504($s0)
sw $s2, 87528($s0)
sw $s2, 88552($s0)
sw $s2, 89576($s0)
sw $s2, 90600($s0)
sw $s2, 91624($s0)
sw $s2, 92648($s0)
sw $s2, 93672($s0)
sw $s2, 94696($s0)
sw $s2, 95720($s0)
sw $s2, 96744($s0)
sw $s2, 97768($s0)
sw $s2, 105960($s0)
sw $s2, 106984($s0)
sw $s2, 108008($s0)
sw $s2, 109032($s0)
sw $s2, 110056($s0)
sw $s2, 111080($s0)
sw $s2, 112104($s0)
sw $s2, 113128($s0)
sw $s2, 114152($s0)
sw $s2, 115176($s0)
sw $s2, 116200($s0)
sw $s2, 117224($s0)
sw $s2, 118248($s0)
sw $s2, 125416($s0)
sw $s2, 126440($s0)
sw $s2, 127464($s0)
sw $s2, 128488($s0)
sw $s2, 129512($s0)
sw $s2, 130536($s0)
sw $s2, 131560($s0)
sw $s2, 132584($s0)
sw $s2, 133608($s0)
sw $s2, 134632($s0)
sw $s2, 135656($s0)
sw $s2, 136680($s0)
sw $s2, 137704($s0)
sw $s2, 105964($s0)
sw $s2, 106988($s0)
sw $s2, 108012($s0)
sw $s2, 109036($s0)
sw $s2, 110060($s0)
sw $s2, 111084($s0)
sw $s2, 112108($s0)
sw $s2, 113132($s0)
sw $s2, 114156($s0)
sw $s2, 115180($s0)
sw $s2, 116204($s0)
sw $s2, 117228($s0)
sw $s2, 118252($s0)
sw $s2, 125420($s0)
sw $s2, 126444($s0)
sw $s2, 127468($s0)
sw $s2, 128492($s0)
sw $s2, 129516($s0)
sw $s2, 130540($s0)
sw $s2, 131564($s0)
sw $s2, 132588($s0)
sw $s2, 133612($s0)
sw $s2, 134636($s0)
sw $s2, 135660($s0)
sw $s2, 136684($s0)
sw $s2, 137708($s0)
sw $s2, 105968($s0)
sw $s2, 125424($s0)
sw $s2, 126448($s0)
sw $s2, 127472($s0)
sw $s2, 128496($s0)
sw $s2, 129520($s0)
sw $s2, 130544($s0)
sw $s2, 131568($s0)
sw $s2, 105972($s0)
sw $s2, 135676($s0)
sw $s2, 136700($s0)
sw $s2, 137724($s0)
sw $s2, 105984($s0)
sw $s2, 107008($s0)
sw $s2, 108032($s0)
sw $s2, 109056($s0)
sw $s2, 110080($s0)
sw $s2, 111104($s0)
sw $s2, 112128($s0)
sw $s2, 113152($s0)
sw $s2, 114176($s0)
sw $s2, 115200($s0)
sw $s2, 116224($s0)
sw $s2, 117248($s0)
sw $s2, 118272($s0)
sw $s2, 135680($s0)
sw $s2, 136704($s0)
sw $s2, 137728($s0)
sw $s2, 105988($s0)
sw $s2, 107012($s0)
sw $s2, 108036($s0)
sw $s2, 109060($s0)
sw $s2, 110084($s0)
sw $s2, 111108($s0)
sw $s2, 112132($s0)
sw $s2, 113156($s0)
sw $s2, 114180($s0)
sw $s2, 115204($s0)
sw $s2, 116228($s0)
sw $s2, 117252($s0)
sw $s2, 118276($s0)
sw $s2, 132612($s0)
sw $s2, 133636($s0)
sw $s2, 134660($s0)
sw $s2, 135684($s0)
sw $s2, 136708($s0)
sw $s2, 137732($s0)
sw $s2, 105992($s0)
sw $s2, 107016($s0)
sw $s2, 108040($s0)
sw $s2, 109064($s0)
sw $s2, 110088($s0)
sw $s2, 111112($s0)
sw $s2, 112136($s0)
sw $s2, 113160($s0)
sw $s2, 114184($s0)
sw $s2, 115208($s0)
sw $s2, 116232($s0)
sw $s2, 117256($s0)
sw $s2, 118280($s0)
sw $s2, 129544($s0)
sw $s2, 130568($s0)
sw $s2, 131592($s0)
sw $s2, 132616($s0)
sw $s2, 133640($s0)
sw $s2, 134664($s0)
sw $s2, 105996($s0)
sw $s2, 111116($s0)
sw $s2, 129548($s0)
sw $s2, 130572($s0)
sw $s2, 131596($s0)
sw $s2, 132620($s0)
sw $s2, 133644($s0)
sw $s2, 134668($s0)
sw $s2, 86544($s0)
sw $s2, 87568($s0)
sw $s2, 88592($s0)
sw $s2, 89616($s0)
sw $s2, 90640($s0)
sw $s2, 91664($s0)
sw $s2, 92688($s0)
sw $s2, 93712($s0)
sw $s2, 94736($s0)
sw $s2, 95760($s0)
sw $s2, 96784($s0)
sw $s2, 97808($s0)
sw $s2, 98832($s0)
sw $s2, 99856($s0)
sw $s2, 100880($s0)
sw $s2, 106000($s0)
sw $s2, 111120($s0)
sw $s2, 125456($s0)
sw $s2, 126480($s0)
sw $s2, 127504($s0)
sw $s2, 128528($s0)
sw $s2, 129552($s0)
sw $s2, 130576($s0)
sw $s2, 131600($s0)
sw $s2, 86548($s0)
sw $s2, 87572($s0)
sw $s2, 88596($s0)
sw $s2, 89620($s0)
sw $s2, 90644($s0)
sw $s2, 91668($s0)
sw $s2, 92692($s0)
sw $s2, 93716($s0)
sw $s2, 94740($s0)
sw $s2, 95764($s0)
sw $s2, 96788($s0)
sw $s2, 97812($s0)
sw $s2, 98836($s0)
sw $s2, 99860($s0)
sw $s2, 100884($s0)
sw $s2, 106004($s0)
sw $s2, 107028($s0)
sw $s2, 108052($s0)
sw $s2, 109076($s0)
sw $s2, 110100($s0)
sw $s2, 111124($s0)
sw $s2, 112148($s0)
sw $s2, 113172($s0)
sw $s2, 114196($s0)
sw $s2, 115220($s0)
sw $s2, 116244($s0)
sw $s2, 117268($s0)
sw $s2, 118292($s0)
sw $s2, 125460($s0)
sw $s2, 126484($s0)
sw $s2, 127508($s0)
sw $s2, 128532($s0)
sw $s2, 86552($s0)
sw $s2, 87576($s0)
sw $s2, 88600($s0)
sw $s2, 89624($s0)
sw $s2, 90648($s0)
sw $s2, 91672($s0)
sw $s2, 92696($s0)
sw $s2, 93720($s0)
sw $s2, 94744($s0)
sw $s2, 95768($s0)
sw $s2, 96792($s0)
sw $s2, 97816($s0)
sw $s2, 98840($s0)
sw $s2, 99864($s0)
sw $s2, 100888($s0)
sw $s2, 106008($s0)
sw $s2, 107032($s0)
sw $s2, 108056($s0)
sw $s2, 109080($s0)
sw $s2, 110104($s0)
sw $s2, 111128($s0)
sw $s2, 112152($s0)
sw $s2, 113176($s0)
sw $s2, 114200($s0)
sw $s2, 115224($s0)
sw $s2, 116248($s0)
sw $s2, 117272($s0)
sw $s2, 118296($s0)
sw $s2, 125464($s0)
sw $s2, 126488($s0)
sw $s2, 127512($s0)
sw $s2, 128536($s0)
sw $s2, 95772($s0)
sw $s2, 96796($s0)
sw $s2, 97820($s0)
sw $s2, 106012($s0)
sw $s2, 107036($s0)
sw $s2, 108060($s0)
sw $s2, 109084($s0)
sw $s2, 110108($s0)
sw $s2, 111132($s0)
sw $s2, 112156($s0)
sw $s2, 113180($s0)
sw $s2, 114204($s0)
sw $s2, 115228($s0)
sw $s2, 116252($s0)
sw $s2, 117276($s0)
sw $s2, 118300($s0)
sw $s2, 95776($s0)
sw $s2, 96800($s0)
sw $s2, 97824($s0)
sw $s2, 95780($s0)
sw $s2, 96804($s0)
sw $s2, 97828($s0)
sw $s2, 125476($s0)
sw $s2, 126500($s0)
sw $s2, 127524($s0)
sw $s2, 128548($s0)
sw $s2, 129572($s0)
sw $s2, 130596($s0)
sw $s2, 131620($s0)
sw $s2, 132644($s0)
sw $s2, 133668($s0)
sw $s2, 134692($s0)
sw $s2, 135716($s0)
sw $s2, 136740($s0)
sw $s2, 137764($s0)
sw $s2, 92712($s0)
sw $s2, 93736($s0)
sw $s2, 94760($s0)
sw $s2, 106024($s0)
sw $s2, 107048($s0)
sw $s2, 108072($s0)
sw $s2, 109096($s0)
sw $s2, 110120($s0)
sw $s2, 111144($s0)
sw $s2, 112168($s0)
sw $s2, 113192($s0)
sw $s2, 114216($s0)
sw $s2, 115240($s0)
sw $s2, 116264($s0)
sw $s2, 117288($s0)
sw $s2, 118312($s0)
sw $s2, 125480($s0)
sw $s2, 126504($s0)
sw $s2, 127528($s0)
sw $s2, 128552($s0)
sw $s2, 129576($s0)
sw $s2, 130600($s0)
sw $s2, 131624($s0)
sw $s2, 132648($s0)
sw $s2, 133672($s0)
sw $s2, 134696($s0)
sw $s2, 135720($s0)
sw $s2, 136744($s0)
sw $s2, 137768($s0)
sw $s2, 92716($s0)
sw $s2, 93740($s0)
sw $s2, 94764($s0)
sw $s2, 106028($s0)
sw $s2, 107052($s0)
sw $s2, 108076($s0)
sw $s2, 109100($s0)
sw $s2, 110124($s0)
sw $s2, 111148($s0)
sw $s2, 112172($s0)
sw $s2, 113196($s0)
sw $s2, 114220($s0)
sw $s2, 115244($s0)
sw $s2, 116268($s0)
sw $s2, 117292($s0)
sw $s2, 118316($s0)
sw $s2, 125484($s0)
sw $s2, 126508($s0)
sw $s2, 127532($s0)
sw $s2, 128556($s0)
sw $s2, 129580($s0)
sw $s2, 130604($s0)
sw $s2, 131628($s0)
sw $s2, 132652($s0)
sw $s2, 133676($s0)
sw $s2, 134700($s0)
sw $s2, 135724($s0)
sw $s2, 136748($s0)
sw $s2, 137772($s0)
sw $s2, 92720($s0)
sw $s2, 93744($s0)
sw $s2, 94768($s0)
sw $s2, 106032($s0)
sw $s2, 107056($s0)
sw $s2, 108080($s0)
sw $s2, 109104($s0)
sw $s2, 110128($s0)
sw $s2, 111152($s0)
sw $s2, 112176($s0)
sw $s2, 113200($s0)
sw $s2, 114224($s0)
sw $s2, 115248($s0)
sw $s2, 116272($s0)
sw $s2, 117296($s0)
sw $s2, 118320($s0)
sw $s2, 127536($s0)
sw $s2, 128560($s0)
sw $s2, 129584($s0)
sw $s2, 95796($s0)
sw $s2, 96820($s0)
sw $s2, 97844($s0)
sw $s2, 106036($s0)
sw $s2, 111156($s0)
sw $s2, 127540($s0)
sw $s2, 128564($s0)
sw $s2, 129588($s0)
sw $s2, 95800($s0)
sw $s2, 96824($s0)
sw $s2, 97848($s0)
sw $s2, 106040($s0)
sw $s2, 107064($s0)
sw $s2, 108088($s0)
sw $s2, 109112($s0)
sw $s2, 110136($s0)
sw $s2, 111160($s0)
sw $s2, 112184($s0)
sw $s2, 113208($s0)
sw $s2, 114232($s0)
sw $s2, 115256($s0)
sw $s2, 116280($s0)
sw $s2, 117304($s0)
sw $s2, 118328($s0)
sw $s2, 129592($s0)
sw $s2, 130616($s0)
sw $s2, 131640($s0)
sw $s2, 95804($s0)
sw $s2, 96828($s0)
sw $s2, 97852($s0)
sw $s2, 106044($s0)
sw $s2, 107068($s0)
sw $s2, 108092($s0)
sw $s2, 109116($s0)
sw $s2, 110140($s0)
sw $s2, 111164($s0)
sw $s2, 112188($s0)
sw $s2, 113212($s0)
sw $s2, 114236($s0)
sw $s2, 115260($s0)
sw $s2, 116284($s0)
sw $s2, 117308($s0)
sw $s2, 118332($s0)
sw $s2, 125500($s0)
sw $s2, 126524($s0)
sw $s2, 127548($s0)
sw $s2, 128572($s0)
sw $s2, 129596($s0)
sw $s2, 130620($s0)
sw $s2, 131644($s0)
sw $s2, 132668($s0)
sw $s2, 133692($s0)
sw $s2, 134716($s0)
sw $s2, 135740($s0)
sw $s2, 136764($s0)
sw $s2, 137788($s0)
sw $s2, 86592($s0)
sw $s2, 87616($s0)
sw $s2, 88640($s0)
sw $s2, 89664($s0)
sw $s2, 90688($s0)
sw $s2, 91712($s0)
sw $s2, 92736($s0)
sw $s2, 93760($s0)
sw $s2, 94784($s0)
sw $s2, 95808($s0)
sw $s2, 96832($s0)
sw $s2, 97856($s0)
sw $s2, 98880($s0)
sw $s2, 99904($s0)
sw $s2, 100928($s0)
sw $s2, 106048($s0)
sw $s2, 107072($s0)
sw $s2, 108096($s0)
sw $s2, 109120($s0)
sw $s2, 110144($s0)
sw $s2, 112192($s0)
sw $s2, 113216($s0)
sw $s2, 114240($s0)
sw $s2, 115264($s0)
sw $s2, 116288($s0)
sw $s2, 117312($s0)
sw $s2, 118336($s0)
sw $s2, 125504($s0)
sw $s2, 126528($s0)
sw $s2, 127552($s0)
sw $s2, 128576($s0)
sw $s2, 129600($s0)
sw $s2, 130624($s0)
sw $s2, 131648($s0)
sw $s2, 132672($s0)
sw $s2, 133696($s0)
sw $s2, 134720($s0)
sw $s2, 135744($s0)
sw $s2, 136768($s0)
sw $s2, 137792($s0)
sw $s2, 86596($s0)
sw $s2, 87620($s0)
sw $s2, 88644($s0)
sw $s2, 89668($s0)
sw $s2, 90692($s0)
sw $s2, 91716($s0)
sw $s2, 92740($s0)
sw $s2, 93764($s0)
sw $s2, 94788($s0)
sw $s2, 95812($s0)
sw $s2, 96836($s0)
sw $s2, 97860($s0)
sw $s2, 98884($s0)
sw $s2, 99908($s0)
sw $s2, 100932($s0)
sw $s2, 106052($s0)
sw $s2, 107076($s0)
sw $s2, 108100($s0)
sw $s2, 109124($s0)
sw $s2, 110148($s0)
sw $s2, 112196($s0)
sw $s2, 113220($s0)
sw $s2, 114244($s0)
sw $s2, 115268($s0)
sw $s2, 116292($s0)
sw $s2, 117316($s0)
sw $s2, 118340($s0)
sw $s2, 125508($s0)
sw $s2, 126532($s0)
sw $s2, 127556($s0)
sw $s2, 128580($s0)
sw $s2, 129604($s0)
sw $s2, 130628($s0)
sw $s2, 131652($s0)
sw $s2, 132676($s0)
sw $s2, 133700($s0)
sw $s2, 134724($s0)
sw $s2, 135748($s0)
sw $s2, 136772($s0)
sw $s2, 137796($s0)
sw $s2, 86600($s0)
sw $s2, 87624($s0)
sw $s2, 88648($s0)
sw $s2, 89672($s0)
sw $s2, 90696($s0)
sw $s2, 91720($s0)
sw $s2, 92744($s0)
sw $s2, 93768($s0)
sw $s2, 94792($s0)
sw $s2, 95816($s0)
sw $s2, 96840($s0)
sw $s2, 97864($s0)
sw $s2, 98888($s0)
sw $s2, 99912($s0)
sw $s2, 100936($s0)
sw $s2, 125512($s0)
sw $s2, 126536($s0)
sw $s2, 127560($s0)
sw $s2, 128584($s0)
sw $s2, 129608($s0)
sw $s2, 130632($s0)
sw $s2, 131656($s0)
sw $s2, 132680($s0)
sw $s2, 133704($s0)
sw $s2, 134728($s0)
sw $s2, 135752($s0)
sw $s2, 136776($s0)
sw $s2, 137800($s0)
sw $s2, 106060($s0)
sw $s2, 106064($s0)
sw $s2, 106068($s0)
sw $s2, 107092($s0)
sw $s2, 108116($s0)
sw $s2, 109140($s0)
sw $s2, 110164($s0)
sw $s2, 111188($s0)
sw $s2, 112212($s0)
sw $s2, 113236($s0)
sw $s2, 114260($s0)
sw $s2, 115284($s0)
sw $s2, 116308($s0)
sw $s2, 117332($s0)
sw $s2, 118356($s0)
sw $s2, 86616($s0)
sw $s2, 87640($s0)
sw $s2, 88664($s0)
sw $s2, 98904($s0)
sw $s2, 99928($s0)
sw $s2, 100952($s0)
sw $s2, 106072($s0)
sw $s2, 107096($s0)
sw $s2, 108120($s0)
sw $s2, 109144($s0)
sw $s2, 110168($s0)
sw $s2, 111192($s0)
sw $s2, 112216($s0)
sw $s2, 113240($s0)
sw $s2, 114264($s0)
sw $s2, 115288($s0)
sw $s2, 116312($s0)
sw $s2, 117336($s0)
sw $s2, 118360($s0)
sw $s2, 86620($s0)
sw $s2, 87644($s0)
sw $s2, 88668($s0)
sw $s2, 98908($s0)
sw $s2, 99932($s0)
sw $s2, 100956($s0)
sw $s2, 106076($s0)
sw $s2, 107100($s0)
sw $s2, 108124($s0)
sw $s2, 109148($s0)
sw $s2, 110172($s0)
sw $s2, 111196($s0)
sw $s2, 112220($s0)
sw $s2, 113244($s0)
sw $s2, 114268($s0)
sw $s2, 115292($s0)
sw $s2, 116316($s0)
sw $s2, 117340($s0)
sw $s2, 118364($s0)
sw $s2, 86624($s0)
sw $s2, 87648($s0)
sw $s2, 88672($s0)
sw $s2, 98912($s0)
sw $s2, 99936($s0)
sw $s2, 100960($s0)
sw $s2, 106080($s0)
sw $s2, 86628($s0)
sw $s2, 87652($s0)
sw $s2, 88676($s0)
sw $s2, 89700($s0)
sw $s2, 90724($s0)
sw $s2, 91748($s0)
sw $s2, 92772($s0)
sw $s2, 93796($s0)
sw $s2, 94820($s0)
sw $s2, 95844($s0)
sw $s2, 96868($s0)
sw $s2, 97892($s0)
sw $s2, 98916($s0)
sw $s2, 99940($s0)
sw $s2, 100964($s0)
sw $s2, 106084($s0)
sw $s2, 86632($s0)
sw $s2, 87656($s0)
sw $s2, 88680($s0)
sw $s2, 89704($s0)
sw $s2, 90728($s0)
sw $s2, 91752($s0)
sw $s2, 92776($s0)
sw $s2, 93800($s0)
sw $s2, 94824($s0)
sw $s2, 95848($s0)
sw $s2, 96872($s0)
sw $s2, 97896($s0)
sw $s2, 98920($s0)
sw $s2, 99944($s0)
sw $s2, 100968($s0)
sw $s2, 86636($s0)
sw $s2, 87660($s0)
sw $s2, 88684($s0)
sw $s2, 89708($s0)
sw $s2, 90732($s0)
sw $s2, 91756($s0)
sw $s2, 92780($s0)
sw $s2, 93804($s0)
sw $s2, 94828($s0)
sw $s2, 95852($s0)
sw $s2, 96876($s0)
sw $s2, 97900($s0)
sw $s2, 98924($s0)
sw $s2, 99948($s0)
sw $s2, 100972($s0)
sw $s2, 86640($s0)
sw $s2, 87664($s0)
sw $s2, 88688($s0)
sw $s2, 98928($s0)
sw $s2, 99952($s0)
sw $s2, 100976($s0)
sw $s2, 107120($s0)
sw $s2, 108144($s0)
sw $s2, 86644($s0)
sw $s2, 87668($s0)
sw $s2, 88692($s0)
sw $s2, 98932($s0)
sw $s2, 99956($s0)
sw $s2, 100980($s0)
sw $s2, 106100($s0)
sw $s2, 107124($s0)
sw $s2, 108148($s0)
sw $s2, 86648($s0)
sw $s2, 87672($s0)
sw $s2, 88696($s0)
sw $s2, 98936($s0)
sw $s2, 99960($s0)
sw $s2, 100984($s0)
sw $s2, 106104($s0)
sw $s2, 107128($s0)
sw $s2, 108152($s0)
sw $s2, 106108($s0)
sw $s2, 107132($s0)
sw $s2, 108156($s0)
sw $s2, 111228($s0)
sw $s2, 112252($s0)
sw $s2, 113276($s0)
sw $s2, 115324($s0)
sw $s2, 116348($s0)
sw $s2, 117372($s0)
sw $s2, 118396($s0)
sw $s2, 106112($s0)
sw $s2, 107136($s0)
sw $s2, 108160($s0)
sw $s2, 111232($s0)
sw $s2, 112256($s0)
sw $s2, 113280($s0)
sw $s2, 115328($s0)
sw $s2, 116352($s0)
sw $s2, 117376($s0)
sw $s2, 118400($s0)
sw $s2, 106116($s0)
sw $s2, 107140($s0)
sw $s2, 108164($s0)
sw $s2, 111236($s0)
sw $s2, 112260($s0)
sw $s2, 113284($s0)
sw $s2, 115332($s0)
sw $s2, 116356($s0)
sw $s2, 117380($s0)
sw $s2, 118404($s0)
sw $s2, 86664($s0)
sw $s2, 87688($s0)
sw $s2, 88712($s0)
sw $s2, 89736($s0)
sw $s2, 90760($s0)
sw $s2, 91784($s0)
sw $s2, 92808($s0)
sw $s2, 93832($s0)
sw $s2, 94856($s0)
sw $s2, 95880($s0)
sw $s2, 96904($s0)
sw $s2, 97928($s0)
sw $s2, 98952($s0)
sw $s2, 99976($s0)
sw $s2, 101000($s0)
sw $s2, 106120($s0)
sw $s2, 107144($s0)
sw $s2, 108168($s0)
sw $s2, 109192($s0)
sw $s2, 110216($s0)
sw $s2, 111240($s0)
sw $s2, 86668($s0)
sw $s2, 87692($s0)
sw $s2, 88716($s0)
sw $s2, 89740($s0)
sw $s2, 90764($s0)
sw $s2, 91788($s0)
sw $s2, 92812($s0)
sw $s2, 93836($s0)
sw $s2, 94860($s0)
sw $s2, 95884($s0)
sw $s2, 96908($s0)
sw $s2, 97932($s0)
sw $s2, 98956($s0)
sw $s2, 99980($s0)
sw $s2, 101004($s0)
sw $s2, 106124($s0)
sw $s2, 107148($s0)
sw $s2, 108172($s0)
sw $s2, 109196($s0)
sw $s2, 110220($s0)
sw $s2, 111244($s0)
sw $s2, 86672($s0)
sw $s2, 87696($s0)
sw $s2, 88720($s0)
sw $s2, 89744($s0)
sw $s2, 90768($s0)
sw $s2, 91792($s0)
sw $s2, 92816($s0)
sw $s2, 93840($s0)
sw $s2, 94864($s0)
sw $s2, 95888($s0)
sw $s2, 96912($s0)
sw $s2, 97936($s0)
sw $s2, 98960($s0)
sw $s2, 99984($s0)
sw $s2, 101008($s0)
sw $s2, 107152($s0)
sw $s2, 108176($s0)
sw $s2, 109200($s0)
sw $s2, 110224($s0)
sw $s2, 89748($s0)
sw $s2, 90772($s0)
sw $s2, 91796($s0)
sw $s2, 107156($s0)
sw $s2, 108180($s0)
sw $s2, 109204($s0)
sw $s2, 110228($s0)
sw $s2, 89752($s0)
sw $s2, 90776($s0)
sw $s2, 91800($s0)
sw $s2, 89756($s0)
sw $s2, 90780($s0)
sw $s2, 91804($s0)
sw $s2, 92832($s0)
sw $s2, 93856($s0)
sw $s2, 94880($s0)
sw $s2, 92836($s0)
sw $s2, 93860($s0)
sw $s2, 94884($s0)
sw $s2, 92840($s0)
sw $s2, 93864($s0)
sw $s2, 94888($s0)
sw $s2, 86700($s0)
sw $s2, 87724($s0)
sw $s2, 88748($s0)
sw $s2, 89772($s0)
sw $s2, 90796($s0)
sw $s2, 91820($s0)
sw $s2, 92844($s0)
sw $s2, 93868($s0)
sw $s2, 94892($s0)
sw $s2, 95916($s0)
sw $s2, 96940($s0)
sw $s2, 97964($s0)
sw $s2, 98988($s0)
sw $s2, 100012($s0)
sw $s2, 101036($s0)
sw $s2, 86704($s0)
sw $s2, 87728($s0)
sw $s2, 88752($s0)
sw $s2, 89776($s0)
sw $s2, 90800($s0)
sw $s2, 91824($s0)
sw $s2, 92848($s0)
sw $s2, 93872($s0)
sw $s2, 94896($s0)
sw $s2, 95920($s0)
sw $s2, 96944($s0)
sw $s2, 97968($s0)
sw $s2, 98992($s0)
sw $s2, 100016($s0)
sw $s2, 101040($s0)
sw $s2, 86708($s0)
sw $s2, 87732($s0)
sw $s2, 88756($s0)
sw $s2, 89780($s0)
sw $s2, 90804($s0)
sw $s2, 91828($s0)
sw $s2, 92852($s0)
sw $s2, 93876($s0)
sw $s2, 94900($s0)
sw $s2, 95924($s0)
sw $s2, 96948($s0)
sw $s2, 97972($s0)
sw $s2, 98996($s0)
sw $s2, 100020($s0)
sw $s2, 101044($s0)
j checkRestart
