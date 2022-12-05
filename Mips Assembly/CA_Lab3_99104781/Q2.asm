# Loading words of A
lui $s0, 0x1001
lw $t0, 0($s0)
ori $s1, $s0, 0x0004
lw $t1, 0($s1)

# Loading words of B
ori $s2, $s0, 0x0008
lw $t2, 0($s2)
ori $s3, $s0, 0x000C
lw $t3, 0($s3)

multu $t0, $t2
mflo $a0
mfhi $a1

multu $t0, $t3
mflo $a2
mfhi $a3

multu $t1, $t2
mflo $k0
mfhi $k1

multu $t1, $t3
mflo $v0
mfhi $v1

add $t4, $a0, $zero

addu $t5, $a2, $k0
addu $t6, $a3, $k1
sltu $t7, $t5, $a2
addu $t6, $t6, $t7

addu $t8, $t5, $a1
addu $t9, $t6, $zero
sltu $gp, $t8, $t5
addu $t9, $t9, $gp

addu $s4, $v0, $t9
addu $s5, $v1, $zero
sltu $s6, $s4, $v0
addu $s5, $s5, $s6

#Storing data
ori $s7, $s0, 0x0010
sw $t4, 0($s7)
ori $s7, $s0, 0x0014
sw $t8, 0($s7)
ori $s7, $s0, 0x0018
sw $s4, 0($s7)
ori $s7, $s0, 0x001C
sw $s5, 0($s7)