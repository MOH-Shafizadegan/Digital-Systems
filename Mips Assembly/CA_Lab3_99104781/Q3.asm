# Loading  A
lui $s0, 0x1001
lw $a0, 0($s0)

#Loading B
ori $s1, $s0, 0x0004
lw $a1, 0($s1)

# Filters
lui $s2, 0x8000
lui $s3, 0x7F80
lui $s4, 0x007F
ori $s4, $s4, 0xFFFF

#Extracting parts of A
and $t0, $s2, $a0		#sign
and $t2, $s3, $a0		#exp
and $t4, $s4, $a0		#frac

#extracting parts of B
and $t1, $s2, $a1		#sign
and $t3, $s3, $a1		#exp
and $t5, $s4, $a1		#frac

addi $s5, $zero, 1		# s5 = 1
#comparing
bne $t0, $t1, target1
bne $t2, $t3, target2
bne $t4, $t5, target3

# A > B
sw $a0, 0($s0)
sw $a1, 0($s1)
j done

target1:
	sltu $t6, $t0, $t1
	beq $zero, $t6, less
	j done

target2:
	sltu $t7, $t2, $t3
	beq $s5, $t7, less
	j done
	
target3:
	sltu $t8, $t4, $t5
	beq $s5, $t8, less	
	j done
	
less :	# A < B
	sw $a1, 0($s0)
	sw $a0, 0($s1)
	
done:
