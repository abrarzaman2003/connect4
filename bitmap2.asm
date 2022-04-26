#bitmap settings: 2by2 unit size, 512 by 512 display size

.data
  displayAddress:	.word	0x10008000 # base address of the display
  heightMap: 		.word 	0x05050505, 0x00050505
  board:		.space	48
  yellowColor: .word 0xfed700
  redColor: .word 0x00ffffff
  
  
.macro max(%a %b) #outputs to $v0
    bgt %a %b b1
    add %a %b $zero
b1:
.end_macro
.macro save ()
addiu   $sp, $sp, -76 #allocates stack memory for the return address
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
.end_macro

.macro restor()
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
        addiu    $sp, $sp, 76 #reallocates the stack 
.end_macro

 .macro set_board (%x %v)#takes the height as an input and checks the heighmap to figure out where to make the circle t0,
    lbu $t0 heightMap(%x) #obtains the height of the column that we need to place the piece on
    
    #moves these parameters to the arguments of the make circle function
    move    $a0, %x 
    move    $a1, $t0
    
    #decrements the height and stores it in the correct position in the height map, and reincrements it to continue with the calculations
    addi $t0, $t0, -1
    sb    $t0, heightMap(%x)
    addi $t0, $t0, 1
    
    
    #shifts the height by 3 to multiply it by 8, since there are 8 bytes in each row of the table, this would be like going down (the height) number of rows
    sll $t0, $t0, 3
    add $t0, $t0, %x #adds x to it to get to the correct position
    sb  %v, board($t0) #stores the correct byte into the position of the board
    
    li $t0, 1 #loads 1 into $t0 for logic with picking the color
    
    beq %v, $t0, yellow #if v == 0, then it places a yellow chip
    
    #else a red chip is placed 
    lw $t0, redColor
    
    move    $a3, $t0
    j over #placed to jump over the yellow code
    
    
    yellow:
    lw $t0, yellowColor
    move    $a3, $t0
    
    over:
    jal makeCircle #calls the make circle function
    
.end_macro

.macro    get_board (%x, %y) #outputs to $t5
    sll    $t0, %y, 3 #shifting to get uh the uh correct row
    add    $t0, $t0, %x #adding to get the correct byte 
    lbu    $t5 board($t0) #loading that byte into the t5 register
.end_macro
  
.macro gcq (%x, %y, %v) #uses $t1-9 and outputs to $v0
#horizontal
	li $v0 0 #g
	li $t1 0 #c
	li $t2 1 #l
	li $t3 1 #r
 	li $t7 1 #i
for1:	sub $t5 %x $t2 #x-l
	blt $t5 $zero b1_2 #x-l<0
	get_board ($t5 %y) #(x-l,y)
	bne $t5 %v b1_2  #v1==b[x-l][y]
	addi $t1 $t1 1 #c++
	addi $t2 $t2 1 #l++
	j inc1
b1_2:	add $t5 %x $t3 #x+r
	li $t6 6
	bgt $t5 $t6 b1_3 #x+r>6
	get_board ($t5 %y) #(x+r,5)
	bne $t5 %v b1_3	#v1=b[x+r][y]
	addi $t1 $t1 1	#c++
	addi $t3 $t3 1	#r++
	j inc1
b1_3:	sub $t5 %x $t2	#x-l
	blt $t5 $zero b1_4 #x-l<0
	get_board ($t5 %y) #v=b[x-l][y]
	bne $t5 $zero b1_4 #v1==0
	addi $t2 $t2 1 #l++
	j inc1
b1_4:	add $t5 %x $t3 #x+r
	li $t6 6
	bgt $t5 $t6 inc1 #x+r>6
	get_board ($t5 %y) #v1=b[x+r][y]
	bne $t5 $zero gend1 #v==0
	addi $t3 $t3 1 #r++
	j inc1
inc1:	addi $t7 $t7 1 #i++
	li $t8 4
	bne $t7 $t8 for1 #i!=4
gend1:	max ($v0 $t1) #v=max(v c)
	
#vertical
	li $t1 0 #c
	li $t2 1 #l
	li $t3 1 #r
 	li $t7 1
for2:	sub $t5 %y $t2
	blt $t5 $zero b2_2
	get_board (%x $t5)
	bne $t5 %v b2_2	
	addi $t1 $t1 1
	addi $t2 $t2 1
	j inc2
b2_2:	add $t5 %y $t3
	li $t6 5
	bgt $t5 $t6 b2_3
	get_board (%x $t5)
	bne $t5 %v b2_3	
	addi $t1 $t1 1
	addi $t3 $t3 1
	j inc2
b2_3:	sub $t5 %y $t2
	blt $t5 $zero b2_4
	get_board (%x $t5)
	bne $t5 $zero b2_4	
	addi $t2 $t2 1
	j inc2
b2_4:	add $t5 %y $t3
	li $t6 5
	bgt $t5 $t6 inc2
	get_board (%x $t5)
	bne $t5 $zero gend2	
	addi $t3 $t3 1
	j inc2
inc2:	addi $t7 $t7 1
	li $t8 4
	bne $t7 $t8 for2
gend2:	max($v0 $t1)

#diagonal like '/'
	li $t1 0 #c
	li $t2 1 #l
	li $t3 1 #r
 	li $t7 1
for3:	sub $t5 %y $t2
	sub $t9 %x $t2
	blt $t5 $zero b3_2
	blt $t9 $zero b3_2
	get_board ($t9 $t5)
	bne $t5 %v b3_2	
	addi $t1 $t1 1
	addi $t2 $t2 1
	j inc3
b3_2:	add $t5 %y $t3
	add $t9 %x $t3
	li $t6 5
	bgt $t5 $t6 b3_3
	li $t6 6
	bgt $t9 $t6 b3_3
	get_board ($t9 $t5)
	bne $t5 %v b3_3	
	addi $t1 $t1 1
	addi $t3 $t3 1
	j inc3
b3_3:	sub $t5 %y $t2
	sub $t9 %x $t2
	blt $t5 $zero b3_4
	blt $t9 $zero b3_4
	get_board ($t9 $t5)
	bne $t5 $zero b3_4	
	addi $t2 $t2 1
	j inc3
b3_4:	add $t5 %y $t3
	add $t9 %x $t3
	li $t6 5
	bgt $t5 $t6 gend3
	li $t6 6
	bgt $t9 $t6 gend3
	get_board ($t9 $t5)
	bne $t5 $zero gend3
	addi $t3 $t3 1
inc3:	addi $t7 $t7 1
	li $t8 4
	bne $t7 $t8 for3
gend3:	max($v0 $t1)

#diagonals that look like '\'
	li $t1 0 #c
	li $t2 1 #l
	li $t3 1 #r
 	li $t7 1
for4:	sub $t5 %y $t2
	add $t9 %x $t2
	blt $t5 $zero b4_2
	li $t6 6
	bgt $t9 $t6 b4_2
	get_board ($t9 $t5)
	bne $t5 %v b4_2	
	addi $t1 $t1 1
	addi $t2 $t2 1
	j inc4
b4_2:	add $t5 %y $t3
	sub $t9 %x $t3
	blt $t9 $zero b4_3
	li $t6 5
	bgt $t9 $t6 b4_3
	get_board ($t9 $t5)
	bne $t5 %v b4_3	
	addi $t1 $t1 1
	addi $t3 $t3 1
	j inc4
b4_3:	li $t7 1
	sub $t5 %y $t2
	add $t9 %x $t2
	blt $t5 $zero b4_4
	li $t6 6
	bgt $t9 $t6 b4_4
	get_board ($t9 $t5)
	bne $t5 $zero b4_4	
	addi $t2 $t2 1
	j inc4
b4_4:	add $t5 %y $t3
	sub $t9 %x $t3
	blt $t9 $zero gend4
	li $t6 5
	bgt $t9 $t6 gend4
	get_board ($t9 $t5)
	bne $t5 $zero gend4
	addi $t3 $t3 1
inc4:	addi $t7 $t7 1
	li $t8 4
	bne $t7 $t8 for4
gend4:	max($v0 $t1)
.end_macro

.macro win () #uses $s0-4, $t0 and outputs to $v1 (1 win, 0 lose)
	li $v1 0
	li $s0 0
	li $s1 7 
	
forw1:	li $s2 0
	li $s3 6
	li $s4 1
forwi:	gcq($s0 $s2 $s4)
	li $t0 3
	bne $v0 $t0 nw
	get_board ($s0 $s2)
	li $t0 1
	bne $v0 $t0 nw
	li $v1 1
nw:	li $s4 2
	gcq($s0 $s2 $s4)
	li $t0 3
	bne $v0 $t0 incw
	get_board ($s0 $s2)
	li $t0 1
	bne $v0 $t0 incw
	li $v1 1
	
incw:	
	addi $s2 $s2 1
	bne $s2 $s3 forwi
	addi $s0 $s0 1
	bne $s0 $s1 forw1
.end_macro

.macro prio (%x) #uses $s0-4, $t0 and outputs to $v1, reorder so small is better
	lbu $s0 heightMap(%x) #y
	blt $s0 $zero pend #y<0
	li $t0 3
	sub $s1 $t0 %x
	sra $t0,$s1,31   
	xor $s1,$s1,$t0
	sub $s1,$s1,$t0
	li $t0 3 
	sub $s1 $t0 $s1 #o
	li $t0 1 
	gcq(%x $s0 $t0)
	add $s3 $v0 $zero #g1
	li $t0 2
	gcq(%x $s0 $t0)
	add $s4 $v0 $zero #g2
	li $t0 3
	bne $s3 $t0 pb1 #g1==3
	addi $v1 $s1 80
	j pend
pb1:	bne $s4 $t0 pb2 #g2==3
	addi $v1 $s1 70
	j pend
pb2:	li $t0 2
	bne $s3 $t0 pb3
		bne $s4 $t0 pb3
		addi $v1 $s1 60
		j pend
pb3:	bne $s4 $t0 pb4
		addi $v1 $s1 50
		j pend
pb4:	bne $s3 $t0 pb5
		addi $v1 $s1 40
		j pend
pb5:	li $t0 1
		bne $s3 $t0 pb6
		addi $v1 $s1 30
		j pend
pb6:	bne $s4 $t0 pb7
		addi $v1 $s1 20
		j pend
pb7:	addi $v1 $s1 10
pend:
.end_macro

.macro opps() #uses $s5-7
	save()
	li $s5 -1 #x
	li $s6 0 #p (score)
	li $s7 0 #i
	prio ($s7)
	blt $v1 $s6 on1
	add $s6 $v1 $zero
	add $s5 $s7 $zero
on1:	li $s7 1 #i
	prio ($s7)
	blt $v1 $s6 on2
	add $s6 $v1 $zero
	add $s5 $s7 $zero
on2:	li $s7 2 #i
	prio ($s7)
	blt $v1 $s6 on3
	add $s6 $v1 $zero
	add $s5 $s7 $zero
on3:	li $s7 3 #i
	prio ($s7)
	blt $v1 $s6 on4
	add $s6 $v1 $zero
	add $s5 $s7 $zero
on4:	li $s7 4 #i
	prio ($s7)
	blt $v1 $s6 on5
	add $s6 $v1 $zero
	add $s5 $s7 $zero
on5:	li $s7 5 #i
	prio ($s7)
	blt $v1 $s6 on6
	add $s6 $v1 $zero
	add $s5 $s7 $zero
on6:	li $s7 6 #i
	prio ($s7)
	blt $v1 $s6 oend
	add $s6 $v1 $zero
	add $s5 $s7 $zero
	li $s6 2
oend:	set_board ($s5 $s6)
	restor()
.end_macro
  
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
	
	li $t1, 1
	set_board $s2, $t1
	
	opps()
	
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
    
