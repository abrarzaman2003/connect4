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