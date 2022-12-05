sw	$zero,00($zero)

addiu	$t1,$zero,0x1111
sw	$t1,04($zero)

addu	$t2,$t1,$t1
sw	$t2,08($zero)

add	$t2,$t2,$t2
sw	$t2,12($zero)

sub	$t3,$t2,$t1
sw	$t3,16($zero)

and	$t4,$t1,$t3
sw	$t4,20($zero)

or	$t5,$t2,$t1	
sw	$t5,24($zero)

xor	$t6,$t2,$t3	
sw	$t6,28($zero)

lw	$t3,24($zero)
sw	$t3,32($zero)

addi	$t3,$zero,-1
sltu	$a0,$t1,$t3
sw	$a0,36($zero)

slt	$a1,$t3,$t1
sw	$a1,40($zero)

slti	$a2,$t6,-1
sw	$a2,44($zero)

sltiu	$a3,$t6,-1
sw	$a3,48($zero)

addi	$v0,$zero,-1

beq	$t1,$t4,next1
sw	$v0,52($zero)
next1:
sw	$t6,56($zero)

beq	$t1,$t3,next2
sw	$t6,60($zero)
next2:
sw	$v0,64($zero)

bne	$t6,$t5,next3
sw	$v0,68($zero)
next3:
sw	$t6,72($zero)

bne	$t1,$t4,next4
sw	$t6,76($zero)
next4:
sw	$v0,80($zero)


l1:
j	l1
