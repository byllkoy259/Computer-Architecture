.data
A: .word 1,2,3,4,5,6,8,9,10
.text
li $s7,10 # $s7=10
la $s6,A # gán nhãn A cho $s6
lw $s1,0($s6) # lưu A[0] vào $s1
abs $s2, $s1 # max=|A[0]|
addi $s3,$zero,1 # i=1
loop: 
beq $s3,$s7,enloop # nếu i=n thoát
sll $s5,$s3,2 # $s5=i*4
add $s5,$s6,$s5
lw $s1,0($s5) # $s1=A[i];
abs $s1,$s1 # $s1=|A[i]|
slt $s0,$s1,$s2 # nếu A[i]>max thì $s0=0
bne $s0,$zero, L2 # nếu $s0!=0 thì nhảy đến else
add $s2,$zero,$s1 # max=A[i]
else:
addi $s3,$s3,1 # i=i+1
j for # quay lại for
enloop:
