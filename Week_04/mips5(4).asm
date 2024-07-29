.text
li $s1, 10 # khởi tạo 1 giá trị bất kì cho thanh ghi $s1
li $s2,128 # khởi tạo giá trị lũy thừa (2^7)
loop:
beq $s2, 1, exit # nếu $s2 = 1 chuyển tới exit
sll $s1, $s1, 1 # $s1 * 2
srl $s2, $s2, 1 # $s2 / 2
j loop
exit:
