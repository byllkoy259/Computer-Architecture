.text 
li $s1, 0x7fffffff 
li $s2, 0x00000001 
start: 
li $t0,0  # No Overflow is default status
addu $s3,$s1,$s2 # s3 = s1 + s2 
xor $t1,$s1,$s2 # Test if $s1 and $s2 have the same sign
bltz $t1,EXIT # If not, exit ($t1 < 0 là khác dấu, không tràn) 
xor $t2,$s1,$s3 # Test if $s1 and $s3 have the same sign 
bgtz $t2,EXIT # If not, exit ($t2 > 0 là cùng dấu, không tràn) 
li $t0,1 # The result is overflow 
EXIT:
