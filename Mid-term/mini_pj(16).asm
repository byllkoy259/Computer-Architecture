.data
sequence: .word 3,9,4,5,6 # Khai báo phần tử của chuỗi 
length: .word 5 # Độ dài của chuỗi
mess1: .asciiz "almostIncreasingSequence(sequence) = "
mess2: .asciiz "true"
mess3: .asciiz "false"

.text
main:
    la $t0, sequence # Load địa chỉ của chuỗi
  
    lw $t1, length # Load độ dài của chuỗi
    li $t2, 0 # Khởi tạo chỉ số i cho chuỗi (i = 0)
    li $t3, 0 # Bộ đếm số phần tử có thể bị loại bỏ 
    addi $t1, $t1, -1 # n = n - 1
    
    # Kiểm tra xem có ít nhất hai phần tử không?
    ble $t1, 1, success # Nếu không, luôn là chuỗi tăng dần

loop: 
    lw $t4, 0($t0) # Tải phần tử hiện tại
    lw $t5, 4($t0) # Tải phần tử kế tiếp
    bgt $t5, $t4, check_next # So sánh xem $t5 > $t4 ?
    
    # Nếu không, tăng bộ đếm phần tử có thể bị loại bỏ
    addi $t3, $t3, 1

check_next:
    addi $t0, $t0, 4 # Di chuyển con trỏ chuỗi lên 4 byte
    addi $t2, $t2, 1 # Tăng chỉ số của chuỗi lên 1
    blt $t2, $t1, loop # Kiểm tra xem chỉ số i đã vượt quá n-1 chưa

end:
    # Kiểm tra bộ đếm số phần tử có thể bị loại bỏ
    li $t7, 1 # Thiết lập ngưỡng là 1
    ble $t3, $t7, success # Nếu số phần tử đã loại bỏ <= 1, chuỗi tăng dần nghiêm ngặt

fail:
    # Ngược lại, chuỗi tăng dần không nghiêm ngặt
    li $v0, 4
    la $a0, mess1
    syscall
    
    li $v0, 4
    la $a0, mess3
    syscall
    j exit

success:
    # Chuỗi tăng dần nghiêm ngặt
    li $v0, 4
    la $a0, mess1
    syscall
    
    li $v0, 4
    la $a0, mess2
    syscall

exit:
    li $v0, 10
    syscall
