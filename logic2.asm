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
    li $a2 1 #color
    forw2:    convertBoardCoords $a0 $a1 $t1
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