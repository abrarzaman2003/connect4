#bitmap settings: 2by2 unit size, 512 by 512 display size

.data
  newLine: .asciiz "\n"
  displayAddress:	.word	0x10008000 # base address of the display
  heightMap: 		.word 	0x05050505, 0x00050505
  board:		.space	48
  yellowColor: .word 0xfed700
  redColor: .word 0x00ffffff
  white: .word 0x00ffffff
  black: .word 0x00000000
  invalidMessage: .asciiz "INVALID MOVE"
  


  .include "macros.asm"

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
  
   
	
.include "graphics.asm"	

.include "sounds.asm"
 
.include "logic2.asm" 


.include "render.asm"
