#bitmap settings: 2by2 unit size, 512 by 512 display size

.data
  displayAddress:	.word	0x10008000 # base address of the display
.text
  lw  $t0, displayAddress	# $t0 stores the base address for display
  li  $t1, 0xfed700	# $t1 stores the red chip color
  li  $t2, 0xff00000	# $t2 stores the yellow chip color
  li  $t3, 0x0020fb	# $t3 stores the primary color of the board
  
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
    
    li 		$t6, 0  # number of rows of circles
    li		$t7, 6 # maximum rows of circles
    
    
    
    markPoints:
    	
    	
  	move	$a0, $t4
  	move	$a1, $t6
   	jal 	makeCircle
   	addi	$t4, $t4, 1
   	bne	$t4, $t5, markPoints
   	
   	addi	$t6, $t6, 1
	li	$t4, 0
	bne	$t6, $t7, markPoints
   	
  Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
  
   makeCircle: #a0 -> x pos, a1 -> ypos
   	lw  	$t0, displayAddress
    	addi	$t0, $t0, 49280 #(32 rows * 256 units * 4) + (16 units of left padding * 4 + 16 units to the center * 4) 
    	
    	
    	
    	
    	sll	$a1, $a1, 15
    	
    	
    	
    	sll	$a0, $a0, 7
    	    	
    	add 	$t0, $t0, $a1 	
    	add 	$t0, $t0, $a0
    	
    	sw	$t1, ($t0)
    	
    	
    	sw	$t1, 56($t0)
    	sw	$t1, 60($t0)
    	sw	$t1, 64($t0)
    	sw	$t1, -64($t0)
    	sw	$t1, -60($t0)
    	sw	$t1, -56($t0)
    	
    	sw	$t1, 14336($t0)
    	sw	$t1, -14336($t0)
    	
    	
    	jr	$ra
    		
    	
  
 
   
    