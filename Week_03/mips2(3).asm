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
