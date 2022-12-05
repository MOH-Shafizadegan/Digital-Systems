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

#Calculating A - B
sub $t4, $t0, $t2
sub $t5, $t1, $t3
slt $t6, $t0, $t4
sub $t5, $t5, $t6

#Storing result
ori $s4, $s0, 0x0010
sw $t4, 0($s4)
ori $s5, $s0, 0x0014
sw $t5, 0($s5)