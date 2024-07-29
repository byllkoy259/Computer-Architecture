# a) i<j:
.data
.text
main:
li $s1,4 # i=4
li $s2,5 # j=5
li $t1,1 # x=1
li $t2,2 # y=2
li $t3,3 # z=3
slt $t0,$s2,$s1 # j<i
bne $t0,$zero,else # branch to else if j<i
addi $t1,$t1,1 # then part: x=x+1
addi $t3,$zero,1 # z=1
j endif # skip “else” part
else: 
addi $t2,$t2,-1 # begin else part: y=y-1
add $t3,$t3,$t3 # z=2*z
endif:

# b) i>=j:
.data
.text
main:
li $s1,4 # i=5
li $s2,5 # j=5
li $t1,1 # x=1
li $t2,2 # y=2
li $t3,3 # z=3
slt $t0,$s2,$s1 # j<i
bne $t0,$zero,else # branch to else if j<i
addi $t1,$t1,1 # then part: x=x+1
addi $t3,$zero,1 # z=1
j endif # skip “else” part
else: 
addi $t2,$t2,-1 # begin else part: y=y-1
add $t3,$t3,$t3 # z=2*z
endif:

# c) i+j <= 0:
.text
li $s1, 3 # i = 3
li $s2, -4 # j = -4	
li $t1,1 # x=1
li $t2,2 # y=2
li $t3,3 # z=3		
add $t0, $s1, $s2 # Tính i + j
bgtz $t0, else # Nhảy đến else nếu i + j > 0
then:    			
addi $t1, $t1, 1 # x = x + 1
addi $t3, $zero, 1 # z = 1
j endif # Bỏ qua phần "else"
else:
addi $t2, $t2, -1 # y = y - 1
add $t3, $t3, $t3 # z = 2 * z
endif:

# d) i+j > m+n
.text
li $s1, 3 # i = 3
li $s2, 4 # j = 4
li $s3, 5 # m=5
li $s4, 9 # n=9
li $t1,1 # x=1
li $t2,2 # y=2
li $t3,3 # z=3		
add $t0, $s1, $s2 # Tính i + j
add $t4, $s3, $s4 # Tính m+n
slt $t5,$t0,$t4 # t0 < t4? 1:0
bne $t5,$zero,else # Nhảy đến else nếu i + j <= m+n
then:
addi $t1, $t1, 1 # x = x + 1
addi $t3, $zero, 1 # z = 1
j endif # Bỏ qua phần "else"
else:
addi $t2, $t2, -1 # y = y - 1
add $t3, $t3, $t3 # z = 2 * z
endif:
