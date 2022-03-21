# Demo for painting
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
# - 192 pixels wide, 224 pixels tall
# - 32 pixels of right and left padding
.data
	displayAddress:	.word	0x10008000
.text
	addi 	$a0, $zero, 0
	li	$v0, 32
	
	lw 	$t0, displayAddress	# $t0 stores the base address for display
	li 	$t1, 0xfed700	# $t1 stores the red chip color
	li 	$t2, 0xff00000	# $t2 stores the yellow chip color
	li 	$t3, 0x0020fb	# $t3 stores the primary color of the board
	
	li	$t7, 0		#row counter
	li	$t6, 48		#makes sure that there will be 48 rows
	
	
	
	addi	$t0, $t0, 2064 #adds 2064 to the base address to start at the bottom portion of the sreen
	addi	$t4, $zero, 0 #  column counter starts off at 0
	addi	$t5, $zero, 56 # column counter should end at 56, this means that a row will have 56 units in it
	
loop: 	
	sw	$t3, ($t0)
	addi	$t0, $t0, 4
	addi	$t4, $t4, 1
	bne	$t4, $t5, loop
	
movedownrow:
	addi 	$t0, $t0, 32 	#increments the address by 32 in order to get to the correct starting position in the next row
	addi 	$t7, $t7, 1
	li	$t4, 0
	bne	$t7, $t6, loop

	#row counters
	li 	$t6, 1
	li	$t7, 7
	
	#column counter
	li	$t4, 1
	li	$t5, 8
	
	
	
markPoints:	
	add	$a0, $t4, $zero
	add	$a1, $t6, $zero
	addi	$t4, $t4, 1
	jal	makeCircle
	bne	$t4, $t5, markPoints
	
	addi	$t6, $t6, 1
	li	$t4, 1
	bne	$t6, $t7, markPoints
	

Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
	

makeCircle:
	
	#a0 --> col pos
	#a1 --> row pos
	
	lw 	$t0, displayAddress
	
	sll	$s0, $a0, 5
	
	sll	$s1, $a1, 11
	addi	$s1, $s1, 1024
	add	$s3, $s1, $s0
	add	$t0, $t0, $s3
	
	sw	$t2, ($t0)
	sw	$t2, -4($t0)
	sw	$t2, -8($t0)
	sw	$t2, 4($t0)
	sw	$t2, 8($t0)
	sw	$t2, -12($t0)
	
	sw	$t2, -252($t0)
	sw	$t2, -256($t0)
	sw	$t2, -260($t0)
	sw	$t2, -264($t0)
	
	
	sw	$t2, 248($t0)
	sw	$t2, 252($t0)
	sw	$t2, 256($t0)
	sw	$t2, 260($t0)
	
	
	sw	$t2, 512($t0)
	sw	$t2, 508($t0)
	
	sw	$t2, -516($t0)
	sw	$t2, -512($t0)
	
	jr	$ra