.data 
  heightMap: 	.word 	0x05050505, 0x00050505
  board:	.space	48
  newLine: 	.asciiz "\n"
  
.macro convert %a
 	addi %a %a -5
 	sra $t1,%a,31   
	xor %a,%a,$t1   
	sub %a,%a,$t1 
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
    li $t0, 0xff00000
    
    move    $a3, $t0
    j over #placed to jump over the yellow code
    
    
    yellow:
    li $t0, 0xfed700
    move    $a3, $t0
    
    over:
    #jal makeCircle #calls the make circle function
    
.end_macro
  
.text


li $a0 0
li $a1 1

addiu $sp, $sp, -8
sw $t0, ($sp)
sw $ra, 4($sp)
jal set_board
lw $t0, ($sp)
lw $ra, 4($sp)
addiu $sp, $sp, 8

addiu $sp, $sp, -24
	sw $t2, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $ra, 20($sp)
	jal printBoard
	lw $t2, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $ra, 20($sp)
addiu $sp, $sp, 24





Exit:
	li $v0 10
	syscall



set_board:
#implement- the input should be the column number ($a0) and either a 1 or 2 depending on the color of the chip ($a1), no return
#registers used: $t0, $ra

	lbu $t0, heightMap($a0)
	
	addi $t0, $t0, -1
	sb $t0, heightMap($a0)
	addi $t0, $t0, 1
	
	sll $t0, $t0, 3
	add $t0, $t0, $a0
	
	sb $a1, board($t0)
	
	jr $ra

get_board:
#implement - arguments should be the column number($a0) and makecircle row number ($a1), puts either a 1 or a 2 in $v0
	sll $a1, $a1, 3
	add $a0, $a0, $a1
	lbu $v1, board($a0)
	
	jr $ra

printBoard:
#implement registers used: $t0, $t1, $t2, $s0, $s1
	li $v0, 1
	li $t0, 0 #for each row, there needs to be 8 bytes outputted
	li $s0, 7
	
	li $t1, 0 #there should be 6 columns outputted as well
	li $s1, 6
	loop:
	
	
	sll $t2, $t1, 3
	add $t2, $t2, $t0
	
	lbu $a0, board($t2)
	syscall
	
	addi $t0, $t0, 1
	
	bne $t0, $s0, loop
	
	li $t0 0
	addi $t1, $t1, 1
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	li $v0 1
	
	bne $t1, $s1, loop
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	jr $ra
	
	
	
	
#implement
