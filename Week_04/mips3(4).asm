a. 
 
.text
addi $s1, $zero, -9 # Khởi tạo giá trị -9 cho $s1
blez $s1, NEGATIVE # Kiểm tra xem $s1 có là số dương không (<=0)
j EXIT
NEGATIVE:
negu $s1, $s1 # Đảo dấu $s1 để lấy giá trị tuyệt đối
EXIT:

b.
 
.text
addu $s0, $zero, $s1

c.
 
.text
addi $s1, $zero, 15
li $t0, 0xffffffff
xor $s0, $s1, $t0

d. 
 
 
.text
slt $at, $s2, $s1 # $at = 1 nếu $s2 < $s1
beq $at, $zero, L  # Chuyển đến L nếu $s2 >= $s1
