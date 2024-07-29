* Trái sang phải:

.eqv MONITOR_SCREEN 0x10010000 # Địa chỉ bắt đầu của bộ nhớ màn hình
.eqv RED 0x00FF0000 # Các giá trị màu thường sử dụng
.eqv BLACK 0x00000000

.text
main:
 li $v0, 32
 li $k0, MONITOR_SCREEN # Nạp địa chỉ bắt đầu của màn hình
 li $t1, RED
 li $t2, BLACK
 
 # Dùng vòng lặp để lặp lại quá trình ghi màu
 li $t3, 60 # Bắt đầu từ offset 60
 li $t4, 0  # Khởi tạo biến đếm
 li $t5, 10  # Cho tối đa 10 lần đổi vị trí 

loop:
 sw $t1, ($k0)  # Ghi màu đỏ vào địa chỉ $k0
 li $a0, 1000
 syscall
 sw $t2, ($k0)  # Ghi màu đen vào địa chỉ $k0 (tô đè lên màu đỏ)
 addi $k0, $k0, 4  # Dịch con trỏ đến ô nhớ tiếp theo
 addi $t4, $t4, 1  # Tăng biến đếm lên 1
 beq $t4, $t5, exit  # Nếu số lần đổi vị trí đạt giá trị tối đa như đã cho thì thoát
 j loop

exit:
 li $v0, 10
 syscall

* Phải sang trái:

.eqv MONITOR_SCREEN 0x10010000 # Địa chỉ bắt đầu của bộ nhớ màn hình
.eqv RED 0x00FF0000 # Các giá trị màu thường sử dụng
.eqv BLACK 0x00000000

.text
main:
 li $v0, 32
 li $k0, MONITOR_SCREEN # Nạp địa chỉ bắt đầu của màn hình
 addi $k0, $k0, 60
 li $t1, RED
 li $t2, BLACK
 
 # Dùng vòng lặp để lặp lại quá trình ghi màu
 li $t3, 60 # Bắt đầu từ offset 60
 li $t4, 0  # Khởi tạo biến đếm
 li $t5, 10  # Cho tối đa 10 lần đổi vị trí 

loop:
 sw $t1, ($k0)  # Ghi màu đỏ vào địa chỉ $k0
 li $a0, 1000
 syscall
 sw $t2, ($k0)  # Ghi màu đen vào địa chỉ $k0 (tô đè lên màu đỏ)
 addi $k0, $k0, -4  # Dịch con trỏ đến ô nhớ tiếp theo
 addi $t4, $t4, 1  # Tăng biến đếm lên 1
 beq $t4, $t5, exit  # Nếu số lần đổi vị trí đạt giá trị tối đa như đã cho thì thoát
 j loop

exit:
 li $v0, 10
 syscall
