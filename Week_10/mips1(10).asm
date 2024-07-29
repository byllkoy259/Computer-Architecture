.eqv SEVENSEG_LEFT 0xFFFF0011 # Dia chi cua den led 7 doan trai.
 # Bit 0 = doan a; 
 # Bit 1 = doan b; ... 
 # Bit 7 = dau .
.eqv SEVENSEG_RIGHT 0xFFFF0010 # Dia chi cua den led 7 doan phai

.data
n0: .byte 63
n1: .byte 6
n2: .byte 91
n3: .byte 79
n4: .byte 102
n5: .byte 109
n6: .byte 125
n7: .byte 7
n8: .byte 127
n9: .byte 111

.text
main:
 li $t1, 0       # Khởi tạo biến đếm $t1
 li $v0, 32
 li $t0, SEVENSEG_RIGHT 
loop1:
 beq $t1, 10, loop2 # Nếu đã hiển thị hết các giá trị từ n0 đến n9 thì thoát khỏi vòng lặp
 lb $a0, n0($t1)   # Lấy giá trị tương ứng với $t1 (tức là n0, n1, n2,...)
 jal SHOW_7SEG_RIGHT # Hiển thị giá trị lấy được
 li $a0, 1000
 syscall
 nop
 addi $t1, $t1, 1   # Tăng biến đếm để lấy giá trị tiếp theo
 j loop1
loop2:
 addi $t1, $t1, -1   # Tăng biến đếm để lấy giá trị tiếp theo
 blt $t1, 0, loop2 # Nếu đã hiển thị hết các giá trị từ n0 đến n9 thì thoát khỏi vòng lặp
 lb $a0, n0($t1)   # Lấy giá trị tương ứng với $t1 (tức là n0, n1, n2,...)
 jal SHOW_7SEG_RIGHT # Hiển thị giá trị lấy được
 li $a0, 1000
 syscall
 nop
 j loop2
 nop
exit: li $v0, 10
 syscall
endmain:
#---------------------------------------------------------------
# Function SHOW_7SEG_LEFT : turn on/off the 7seg
# param[in] $a0 value to shown 
# remark $t0 changed
#---------------------------------------------------------------
SHOW_7SEG_LEFT: 
 li $t0, SEVENSEG_LEFT # assign port's address
 sb $a0, 0($t0) # assign new value 
 nop
 jr $ra
 nop
#---------------------------------------------------------------
# Function SHOW_7SEG_RIGHT : turn on/off the 7seg
# param[in] $a0 value to shown 
# remark $t0 changed
#---------------------------------------------------------------
SHOW_7SEG_RIGHT: 
 li $t0, SEVENSEG_RIGHT # assign port's address
 sb $a0, 0($t0) # assign new value
 nop
 jr $ra 
 nop
