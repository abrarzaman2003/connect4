invalidMove:
	li	$v0, 3
	jal	choose_sound
	
	li $v0, 55
	la $a0, invalidMessage
	li $a1, 0
	syscall 
	
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
  
