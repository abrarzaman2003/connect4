.data
	white: .word 0x00ffffff
	black: .word 0x00000000
	green: .word 0x0000ff00
	red:   .word 0x00ff0000
	displayAddress:	.word 0x10008000

.text
	li $a0, 85
	
	
	jal gameover
	
	


gameover: #registers used : $t0, $t1
	lw $s0, displayAddress
	lw $s1, white
	
	
	
	sll	$a0, $a0, 10
	
	add $s0, $s0, $a0
	
	li $t0, 256
	li $t1, 53
	
	loop:
	sw	$s1, ($s0)
	addi	$s0, $s0, 4
	addi 	$t0, $t0, -1
	
	bne	$t0, $zero, loop
	
	
	addi	$t1, $t1, -1
	li 	$t0, 256
	
	bne	$t1, $zero, loop
	
	lw	$s2, black
	
	lw $s0, displayAddress
	sll	$a0, $a0, 10
	
	
sw $s2, 90472($s0)
sw $s2, 91496($s0)
sw $s2, 92520($s0)
sw $s2, 93544($s0)
sw $s2, 94568($s0)
sw $s2, 95592($s0)
sw $s2, 96616($s0)
sw $s2, 97640($s0)
sw $s2, 98664($s0)
sw $s2, 99688($s0)
sw $s2, 100712($s0)
sw $s2, 101736($s0)
sw $s2, 102760($s0)
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
sw $s2, 90476($s0)
sw $s2, 91500($s0)
sw $s2, 92524($s0)
sw $s2, 93548($s0)
sw $s2, 94572($s0)
sw $s2, 95596($s0)
sw $s2, 96620($s0)
sw $s2, 97644($s0)
sw $s2, 98668($s0)
sw $s2, 99692($s0)
sw $s2, 100716($s0)
sw $s2, 101740($s0)
sw $s2, 102764($s0)
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
sw $s2, 90480($s0)
sw $s2, 91504($s0)
sw $s2, 92528($s0)
sw $s2, 93552($s0)
sw $s2, 94576($s0)
sw $s2, 95600($s0)
sw $s2, 96624($s0)
sw $s2, 97648($s0)
sw $s2, 98672($s0)
sw $s2, 99696($s0)
sw $s2, 100720($s0)
sw $s2, 101744($s0)
sw $s2, 102768($s0)
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
sw $s2, 90484($s0)
sw $s2, 91508($s0)
sw $s2, 101748($s0)
sw $s2, 102772($s0)
sw $s2, 105844($s0)
sw $s2, 110964($s0)
sw $s2, 90488($s0)
sw $s2, 91512($s0)
sw $s2, 101752($s0)
sw $s2, 102776($s0)
sw $s2, 105848($s0)
sw $s2, 110968($s0)
sw $s2, 90492($s0)
sw $s2, 91516($s0)
sw $s2, 92540($s0)
sw $s2, 95612($s0)
sw $s2, 96636($s0)
sw $s2, 97660($s0)
sw $s2, 98684($s0)
sw $s2, 99708($s0)
sw $s2, 100732($s0)
sw $s2, 101756($s0)
sw $s2, 102780($s0)
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
sw $s2, 90496($s0)
sw $s2, 91520($s0)
sw $s2, 92544($s0)
sw $s2, 95616($s0)
sw $s2, 96640($s0)
sw $s2, 97664($s0)
sw $s2, 98688($s0)
sw $s2, 99712($s0)
sw $s2, 100736($s0)
sw $s2, 101760($s0)
sw $s2, 102784($s0)
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
sw $s2, 90500($s0)
sw $s2, 91524($s0)
sw $s2, 92548($s0)
sw $s2, 95620($s0)
sw $s2, 96644($s0)
sw $s2, 97668($s0)
sw $s2, 98692($s0)
sw $s2, 99716($s0)
sw $s2, 100740($s0)
sw $s2, 101764($s0)
sw $s2, 102788($s0)
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
sw $s2, 101776($s0)
sw $s2, 102800($s0)
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
sw $s2, 90516($s0)
sw $s2, 91540($s0)
sw $s2, 92564($s0)
sw $s2, 93588($s0)
sw $s2, 94612($s0)
sw $s2, 95636($s0)
sw $s2, 96660($s0)
sw $s2, 97684($s0)
sw $s2, 98708($s0)
sw $s2, 99732($s0)
sw $s2, 100756($s0)
sw $s2, 101780($s0)
sw $s2, 102804($s0)
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
sw $s2, 90520($s0)
sw $s2, 91544($s0)
sw $s2, 92568($s0)
sw $s2, 93592($s0)
sw $s2, 94616($s0)
sw $s2, 95640($s0)
sw $s2, 96664($s0)
sw $s2, 97688($s0)
sw $s2, 98712($s0)
sw $s2, 99736($s0)
sw $s2, 100760($s0)
sw $s2, 101784($s0)
sw $s2, 102808($s0)
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
sw $s2, 90524($s0)
sw $s2, 91548($s0)
sw $s2, 95644($s0)
sw $s2, 105884($s0)
sw $s2, 111004($s0)
sw $s2, 117148($s0)
sw $s2, 118172($s0)
sw $s2, 90528($s0)
sw $s2, 91552($s0)
sw $s2, 95648($s0)
sw $s2, 105888($s0)
sw $s2, 111008($s0)
sw $s2, 117152($s0)
sw $s2, 118176($s0)
sw $s2, 90532($s0)
sw $s2, 91556($s0)
sw $s2, 92580($s0)
sw $s2, 93604($s0)
sw $s2, 94628($s0)
sw $s2, 95652($s0)
sw $s2, 96676($s0)
sw $s2, 97700($s0)
sw $s2, 98724($s0)
sw $s2, 99748($s0)
sw $s2, 100772($s0)
sw $s2, 101796($s0)
sw $s2, 102820($s0)
sw $s2, 105892($s0)
sw $s2, 106916($s0)
sw $s2, 107940($s0)
sw $s2, 111012($s0)
sw $s2, 115108($s0)
sw $s2, 116132($s0)
sw $s2, 117156($s0)
sw $s2, 118180($s0)
sw $s2, 90536($s0)
sw $s2, 91560($s0)
sw $s2, 92584($s0)
sw $s2, 93608($s0)
sw $s2, 94632($s0)
sw $s2, 95656($s0)
sw $s2, 96680($s0)
sw $s2, 97704($s0)
sw $s2, 98728($s0)
sw $s2, 99752($s0)
sw $s2, 100776($s0)
sw $s2, 101800($s0)
sw $s2, 102824($s0)
sw $s2, 105896($s0)
sw $s2, 106920($s0)
sw $s2, 107944($s0)
sw $s2, 115112($s0)
sw $s2, 116136($s0)
sw $s2, 117160($s0)
sw $s2, 118184($s0)
sw $s2, 90540($s0)
sw $s2, 91564($s0)
sw $s2, 92588($s0)
sw $s2, 93612($s0)
sw $s2, 94636($s0)
sw $s2, 95660($s0)
sw $s2, 96684($s0)
sw $s2, 97708($s0)
sw $s2, 98732($s0)
sw $s2, 99756($s0)
sw $s2, 100780($s0)
sw $s2, 101804($s0)
sw $s2, 102828($s0)
sw $s2, 105900($s0)
sw $s2, 106924($s0)
sw $s2, 107948($s0)
sw $s2, 115116($s0)
sw $s2, 116140($s0)
sw $s2, 117164($s0)
sw $s2, 118188($s0)
sw $s2, 90552($s0)
sw $s2, 91576($s0)
sw $s2, 92600($s0)
sw $s2, 93624($s0)
sw $s2, 94648($s0)
sw $s2, 95672($s0)
sw $s2, 96696($s0)
sw $s2, 97720($s0)
sw $s2, 98744($s0)
sw $s2, 99768($s0)
sw $s2, 100792($s0)
sw $s2, 101816($s0)
sw $s2, 102840($s0)
sw $s2, 105912($s0)
sw $s2, 106936($s0)
sw $s2, 107960($s0)
sw $s2, 108984($s0)
sw $s2, 110008($s0)
sw $s2, 115128($s0)
sw $s2, 116152($s0)
sw $s2, 117176($s0)
sw $s2, 118200($s0)
sw $s2, 90556($s0)
sw $s2, 91580($s0)
sw $s2, 92604($s0)
sw $s2, 93628($s0)
sw $s2, 94652($s0)
sw $s2, 95676($s0)
sw $s2, 96700($s0)
sw $s2, 97724($s0)
sw $s2, 98748($s0)
sw $s2, 99772($s0)
sw $s2, 100796($s0)
sw $s2, 101820($s0)
sw $s2, 102844($s0)
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
sw $s2, 90560($s0)
sw $s2, 91584($s0)
sw $s2, 92608($s0)
sw $s2, 93632($s0)
sw $s2, 94656($s0)
sw $s2, 95680($s0)
sw $s2, 96704($s0)
sw $s2, 97728($s0)
sw $s2, 98752($s0)
sw $s2, 99776($s0)
sw $s2, 100800($s0)
sw $s2, 101824($s0)
sw $s2, 102848($s0)
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
sw $s2, 92612($s0)
sw $s2, 93636($s0)
sw $s2, 94660($s0)
sw $s2, 105924($s0)
sw $s2, 111044($s0)
sw $s2, 117188($s0)
sw $s2, 118212($s0)
sw $s2, 92616($s0)
sw $s2, 93640($s0)
sw $s2, 94664($s0)
sw $s2, 105928($s0)
sw $s2, 111048($s0)
sw $s2, 117192($s0)
sw $s2, 118216($s0)
sw $s2, 93644($s0)
sw $s2, 94668($s0)
sw $s2, 95692($s0)
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
sw $s2, 90584($s0)
sw $s2, 91608($s0)
sw $s2, 92632($s0)
sw $s2, 93656($s0)
sw $s2, 94680($s0)
sw $s2, 95704($s0)
sw $s2, 96728($s0)
sw $s2, 97752($s0)
sw $s2, 98776($s0)
sw $s2, 99800($s0)
sw $s2, 100824($s0)
sw $s2, 101848($s0)
sw $s2, 102872($s0)
sw $s2, 125400($s0)
sw $s2, 126424($s0)
sw $s2, 127448($s0)
sw $s2, 128472($s0)
sw $s2, 129496($s0)
sw $s2, 90588($s0)
sw $s2, 91612($s0)
sw $s2, 92636($s0)
sw $s2, 93660($s0)
sw $s2, 94684($s0)
sw $s2, 95708($s0)
sw $s2, 96732($s0)
sw $s2, 97756($s0)
sw $s2, 98780($s0)
sw $s2, 99804($s0)
sw $s2, 100828($s0)
sw $s2, 101852($s0)
sw $s2, 102876($s0)
sw $s2, 105948($s0)
sw $s2, 125404($s0)
sw $s2, 126428($s0)
sw $s2, 127452($s0)
sw $s2, 128476($s0)
sw $s2, 129500($s0)
sw $s2, 130524($s0)
sw $s2, 131548($s0)
sw $s2, 90592($s0)
sw $s2, 91616($s0)
sw $s2, 92640($s0)
sw $s2, 93664($s0)
sw $s2, 94688($s0)
sw $s2, 95712($s0)
sw $s2, 96736($s0)
sw $s2, 97760($s0)
sw $s2, 98784($s0)
sw $s2, 99808($s0)
sw $s2, 100832($s0)
sw $s2, 101856($s0)
sw $s2, 102880($s0)
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
sw $s2, 90604($s0)
sw $s2, 91628($s0)
sw $s2, 92652($s0)
sw $s2, 93676($s0)
sw $s2, 94700($s0)
sw $s2, 95724($s0)
sw $s2, 96748($s0)
sw $s2, 97772($s0)
sw $s2, 98796($s0)
sw $s2, 99820($s0)
sw $s2, 100844($s0)
sw $s2, 101868($s0)
sw $s2, 102892($s0)
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
sw $s2, 90608($s0)
sw $s2, 91632($s0)
sw $s2, 92656($s0)
sw $s2, 93680($s0)
sw $s2, 94704($s0)
sw $s2, 95728($s0)
sw $s2, 96752($s0)
sw $s2, 97776($s0)
sw $s2, 98800($s0)
sw $s2, 99824($s0)
sw $s2, 100848($s0)
sw $s2, 101872($s0)
sw $s2, 102896($s0)
sw $s2, 105968($s0)
sw $s2, 125424($s0)
sw $s2, 126448($s0)
sw $s2, 127472($s0)
sw $s2, 128496($s0)
sw $s2, 129520($s0)
sw $s2, 130544($s0)
sw $s2, 131568($s0)
sw $s2, 90612($s0)
sw $s2, 91636($s0)
sw $s2, 92660($s0)
sw $s2, 93684($s0)
sw $s2, 94708($s0)
sw $s2, 95732($s0)
sw $s2, 96756($s0)
sw $s2, 97780($s0)
sw $s2, 98804($s0)
sw $s2, 99828($s0)
sw $s2, 100852($s0)
sw $s2, 101876($s0)
sw $s2, 102900($s0)
sw $s2, 105972($s0)
sw $s2, 90616($s0)
sw $s2, 91640($s0)
sw $s2, 95736($s0)
sw $s2, 101880($s0)
sw $s2, 102904($s0)
sw $s2, 90620($s0)
sw $s2, 91644($s0)
sw $s2, 95740($s0)
sw $s2, 101884($s0)
sw $s2, 102908($s0)
sw $s2, 135676($s0)
sw $s2, 136700($s0)
sw $s2, 137724($s0)
sw $s2, 90624($s0)
sw $s2, 91648($s0)
sw $s2, 92672($s0)
sw $s2, 95744($s0)
sw $s2, 100864($s0)
sw $s2, 101888($s0)
sw $s2, 102912($s0)
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
sw $s2, 90628($s0)
sw $s2, 91652($s0)
sw $s2, 92676($s0)
sw $s2, 100868($s0)
sw $s2, 101892($s0)
sw $s2, 102916($s0)
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
sw $s2, 90632($s0)
sw $s2, 91656($s0)
sw $s2, 92680($s0)
sw $s2, 100872($s0)
sw $s2, 101896($s0)
sw $s2, 102920($s0)
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
sw $s2, 106000($s0)
sw $s2, 111120($s0)
sw $s2, 125456($s0)
sw $s2, 126480($s0)
sw $s2, 127504($s0)
sw $s2, 128528($s0)
sw $s2, 129552($s0)
sw $s2, 130576($s0)
sw $s2, 131600($s0)
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
sw $s2, 90656($s0)
sw $s2, 91680($s0)
sw $s2, 92704($s0)
sw $s2, 93728($s0)
sw $s2, 94752($s0)
sw $s2, 95776($s0)
sw $s2, 96800($s0)
sw $s2, 97824($s0)
sw $s2, 98848($s0)
sw $s2, 99872($s0)
sw $s2, 100896($s0)
sw $s2, 101920($s0)
sw $s2, 102944($s0)
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
sw $s2, 101924($s0)
sw $s2, 102948($s0)
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
sw $s2, 101928($s0)
sw $s2, 102952($s0)
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
sw $s2, 90668($s0)
sw $s2, 91692($s0)
sw $s2, 101932($s0)
sw $s2, 102956($s0)
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
sw $s2, 90672($s0)
sw $s2, 91696($s0)
sw $s2, 101936($s0)
sw $s2, 102960($s0)
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
sw $s2, 90676($s0)
sw $s2, 91700($s0)
sw $s2, 92724($s0)
sw $s2, 93748($s0)
sw $s2, 94772($s0)
sw $s2, 95796($s0)
sw $s2, 96820($s0)
sw $s2, 97844($s0)
sw $s2, 98868($s0)
sw $s2, 99892($s0)
sw $s2, 100916($s0)
sw $s2, 101940($s0)
sw $s2, 102964($s0)
sw $s2, 106036($s0)
sw $s2, 111156($s0)
sw $s2, 127540($s0)
sw $s2, 128564($s0)
sw $s2, 129588($s0)
sw $s2, 90680($s0)
sw $s2, 91704($s0)
sw $s2, 92728($s0)
sw $s2, 93752($s0)
sw $s2, 94776($s0)
sw $s2, 95800($s0)
sw $s2, 96824($s0)
sw $s2, 97848($s0)
sw $s2, 98872($s0)
sw $s2, 99896($s0)
sw $s2, 100920($s0)
sw $s2, 101944($s0)
sw $s2, 102968($s0)
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
sw $s2, 101948($s0)
sw $s2, 102972($s0)
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
sw $s2, 90700($s0)
sw $s2, 91724($s0)
sw $s2, 92748($s0)
sw $s2, 93772($s0)
sw $s2, 94796($s0)
sw $s2, 95820($s0)
sw $s2, 96844($s0)
sw $s2, 97868($s0)
sw $s2, 98892($s0)
sw $s2, 99916($s0)
sw $s2, 100940($s0)
sw $s2, 106060($s0)
sw $s2, 90704($s0)
sw $s2, 91728($s0)
sw $s2, 92752($s0)
sw $s2, 93776($s0)
sw $s2, 94800($s0)
sw $s2, 95824($s0)
sw $s2, 96848($s0)
sw $s2, 97872($s0)
sw $s2, 98896($s0)
sw $s2, 99920($s0)
sw $s2, 100944($s0)
sw $s2, 106064($s0)
sw $s2, 100948($s0)
sw $s2, 101972($s0)
sw $s2, 102996($s0)
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
sw $s2, 100952($s0)
sw $s2, 101976($s0)
sw $s2, 103000($s0)
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
sw $s2, 90716($s0)
sw $s2, 91740($s0)
sw $s2, 92764($s0)
sw $s2, 93788($s0)
sw $s2, 94812($s0)
sw $s2, 95836($s0)
sw $s2, 96860($s0)
sw $s2, 97884($s0)
sw $s2, 98908($s0)
sw $s2, 99932($s0)
sw $s2, 100956($s0)
sw $s2, 101980($s0)
sw $s2, 103004($s0)
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
sw $s2, 90720($s0)
sw $s2, 91744($s0)
sw $s2, 92768($s0)
sw $s2, 93792($s0)
sw $s2, 94816($s0)
sw $s2, 95840($s0)
sw $s2, 96864($s0)
sw $s2, 97888($s0)
sw $s2, 98912($s0)
sw $s2, 99936($s0)
sw $s2, 100960($s0)
sw $s2, 101984($s0)
sw $s2, 103008($s0)
sw $s2, 106080($s0)
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
sw $s2, 101988($s0)
sw $s2, 103012($s0)
sw $s2, 106084($s0)
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
sw $s2, 102000($s0)
sw $s2, 103024($s0)
sw $s2, 107120($s0)
sw $s2, 108144($s0)
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
sw $s2, 102004($s0)
sw $s2, 103028($s0)
sw $s2, 106100($s0)
sw $s2, 107124($s0)
sw $s2, 108148($s0)
sw $s2, 90744($s0)
sw $s2, 91768($s0)
sw $s2, 92792($s0)
sw $s2, 93816($s0)
sw $s2, 94840($s0)
sw $s2, 95864($s0)
sw $s2, 96888($s0)
sw $s2, 97912($s0)
sw $s2, 98936($s0)
sw $s2, 99960($s0)
sw $s2, 100984($s0)
sw $s2, 102008($s0)
sw $s2, 103032($s0)
sw $s2, 106104($s0)
sw $s2, 107128($s0)
sw $s2, 108152($s0)
sw $s2, 90748($s0)
sw $s2, 91772($s0)
sw $s2, 95868($s0)
sw $s2, 102012($s0)
sw $s2, 103036($s0)
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
sw $s2, 90752($s0)
sw $s2, 91776($s0)
sw $s2, 95872($s0)
sw $s2, 102016($s0)
sw $s2, 103040($s0)
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
sw $s2, 90756($s0)
sw $s2, 91780($s0)
sw $s2, 92804($s0)
sw $s2, 95876($s0)
sw $s2, 100996($s0)
sw $s2, 102020($s0)
sw $s2, 103044($s0)
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
sw $s2, 90760($s0)
sw $s2, 91784($s0)
sw $s2, 92808($s0)
sw $s2, 101000($s0)
sw $s2, 102024($s0)
sw $s2, 103048($s0)
sw $s2, 106120($s0)
sw $s2, 107144($s0)
sw $s2, 108168($s0)
sw $s2, 109192($s0)
sw $s2, 110216($s0)
sw $s2, 111240($s0)
sw $s2, 90764($s0)
sw $s2, 91788($s0)
sw $s2, 92812($s0)
sw $s2, 101004($s0)
sw $s2, 102028($s0)
sw $s2, 103052($s0)
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
sw $s2, 90776($s0)
sw $s2, 91800($s0)
sw $s2, 92824($s0)
sw $s2, 93848($s0)
sw $s2, 94872($s0)
sw $s2, 95896($s0)
sw $s2, 96920($s0)
sw $s2, 97944($s0)
sw $s2, 98968($s0)
sw $s2, 99992($s0)
sw $s2, 101016($s0)
sw $s2, 102040($s0)
sw $s2, 103064($s0)
sw $s2, 90780($s0)
sw $s2, 91804($s0)
sw $s2, 92828($s0)
sw $s2, 93852($s0)
sw $s2, 94876($s0)
sw $s2, 95900($s0)
sw $s2, 96924($s0)
sw $s2, 97948($s0)
sw $s2, 98972($s0)
sw $s2, 99996($s0)
sw $s2, 101020($s0)
sw $s2, 102044($s0)
sw $s2, 103068($s0)
sw $s2, 90784($s0)
sw $s2, 91808($s0)
sw $s2, 92832($s0)
sw $s2, 93856($s0)
sw $s2, 94880($s0)
sw $s2, 95904($s0)
sw $s2, 96928($s0)
sw $s2, 97952($s0)
sw $s2, 98976($s0)
sw $s2, 100000($s0)
sw $s2, 101024($s0)
sw $s2, 102048($s0)
sw $s2, 103072($s0)
sw $s2, 90788($s0)
sw $s2, 91812($s0)
sw $s2, 95908($s0)
sw $s2, 90792($s0)
sw $s2, 91816($s0)
sw $s2, 92840($s0)
sw $s2, 93864($s0)
sw $s2, 94888($s0)
sw $s2, 95912($s0)
sw $s2, 96936($s0)
sw $s2, 97960($s0)
sw $s2, 98984($s0)
sw $s2, 100008($s0)
sw $s2, 101032($s0)
sw $s2, 102056($s0)
sw $s2, 103080($s0)
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
sw $s2, 102060($s0)
sw $s2, 103084($s0)
sw $s2, 90800($s0)
sw $s2, 91824($s0)
sw $s2, 92848($s0)
sw $s2, 93872($s0)
sw $s2, 94896($s0)
sw $s2, 96944($s0)
sw $s2, 97968($s0)
sw $s2, 98992($s0)
sw $s2, 100016($s0)
sw $s2, 101040($s0)
sw $s2, 102064($s0)
sw $s2, 103088($s0)
sw $s2, 90804($s0)
sw $s2, 91828($s0)
sw $s2, 92852($s0)
sw $s2, 93876($s0)
sw $s2, 94900($s0)
sw $s2, 96948($s0)
sw $s2, 97972($s0)
sw $s2, 98996($s0)
sw $s2, 100020($s0)
sw $s2, 101044($s0)
sw $s2, 102068($s0)
sw $s2, 103092($s0)



	
	
	
	