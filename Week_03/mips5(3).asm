# a) i<n:
.data 
A: .word 2,4,6,8,10 # mảng A
n: .word 5 # số lượng phần tử
step: .word 1 # giá trị bước

.text
addi $s5, $zero, 0 # sum=0
addi $s1, $zero, 0 # i=0
la $s2, A # Địa chỉ bắt đầu của mảng A
lw $s3, n # Số lượng phần tử trong mảng
lw $s4, step # Giá trị bước

loop: 
add $s1,$s1,$s4 #i=i+step
add $t1,$s1,$s1 #t1=2*s1
add $t1,$t1,$t1 #t1=4*s1
add $t1,$t1,$s2 #t1 store the address of A[i]
lw $t0,0($t1) #load value of A[i] in $t0
add $s5,$s5,$t0 #sum=sum+A[i]
bne $s1,$s3,loop #if i != n, goto loop

# b) i<=n:
.data 
A: .word 2,4,6,8,10 # mảng A
n: .word 5 # số lượng phần tử
step: .word 1 # giá trị bước

.text
addi $s5, $zero, 0 # sum=0
addi $s1, $zero, 0 # i=0
la $s2, A # Địa chỉ bắt đầu của mảng A
lw $s3, n # Số lượng phần tử trong mảng
lw $s4, step # Giá trị bước

loop: 
slt $t2,$s3,$s1 # if n<i? 1:0
bne $t2, $zero, enloop # nếu $t2 khác 0 thì chuyển đến enloop
add $s1,$s1,$s4 #i=i+step
add $t1,$s1,$s1 #t1=2*s1
add $t1,$t1,$t1 #t1=4*s1
add $t1,$t1,$s2 #t1 store the address of A[i]
lw $t0,0($t1) #load value of A[i] in $t0
add $s5,$s5,$t0 #sum=sum+A[i]
j loop # nhảy về loop
enloop:

# c) sum >=0:
.data 
A: .word 0,2,4,-10,5,6,8-6,11,-5
.text 
li $s3, 10 #n=10
li $s4, 1 #step=1
la $s2,A # địa chỉ A[0]
addi $s5, $zero, 0 #sum = 0 
addi $s1, $zero, 0 #i = 0 
loop: 
bltz $s5, endloop # endloop nếu sum < 0 
add $t1,$s1,$s1 #$t1=2*$s1 
add $t1,$t1,$t1	#$t1=4*$s1 
add $t1,$t1,$s2 #$t1 lưu trữ đại chỉ của A[i] 
lw $t0,0($t1) #load giá trị A[i]
add $s5,$s5,$t0 #sum=sum+A[i] 
add $s1,$s1,$s4 #i=i+step 
j loop #goto loop 
endloop:

# d) A[i]==0:
.data 
A: .word 12,15,9,7,0,-8,23,1,56
.text 
li $s3, 9 #n=9
li $s4, 1 #step=1
la $s2,A # địa chỉ A[0]
addi $s5, $zero, 0 #sum = 0 
addi $s1, $zero, 0 #i = 0 
loop: 
add $t1,$s1,$s1 #$t1=2*$s1 
add $t1,$t1,$t1 #$t1=4*$s1 
add $t1,$t1,$s2 #$t1 lưu trữ địa chỉ của A[i] 
lw $t0,0($t1) #load giá trị A[i] vào $t0 
beqz $t0, endloop # endloop nếu A[i] == 0 
add $s5,$s5,$t0 #sum=sum+A[i] 
add $s1,$s1,$s4	#i=i+step 
j loop #goto loop 
endloop:
