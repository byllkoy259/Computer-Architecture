.data
a: .word -1, 150, -1, 170, -1, -1, 160, 180 # Khai báo mảng a
length: .word 8 # Độ dài của mảng a
b: .space 32 # Khai báo mảng b (đủ lớn để chứa các phần tử của mảng a)
comma: .asciiz ", "
mess1: .asciiz "sortByHeight(a) = ["
mess2: .asciiz "]"

.text
main:
	la $s0, a # Load địa chỉ của a vào thanh ghi $s0
	la $s1, b # Load địa chỉ của b vào thanh ghi $s1
	lw $s2, length # Load số lượng phần tử của a vào thanh ghi $s2
	li $t0, 0 # Khởi tạo chỉ số i của mảng a (i = 0)
	li $t1, 0 # Khởi tạo chỉ số j của mảng b (j = 0)
	addi $s2, $s2, -1
	j copy_loop 

copy_loop:
	bge $t0, $s2, end_copy_loop # Kiểm tra xem chỉ số i đã vượt quá n-1 chưa
	lw $s3, 0($s0) # Tải giá trị của phần tử thứ i từ mảng a vào $s3
	bne $s3, -1, add_to_b # Nếu giá trị từ mảng a khác -1, lưu vào mảng b và tăng j
	j skip_add_to_b

add_to_b:
	sw $s3, 0($s1) # Lưu giá trị từ $s3 vào mảng b
	addi $s1, $s1, 4 # Di chuyển con trỏ mảng b lên 4 byte
	addi $t1, $t1, 1 # Tăng chỉ số của mảng b

skip_add_to_b:
	addi $s0, $s0, 4 # Di chuyển con trỏ mảng a lên 4 byte
	addi $t0, $t0, 1 # Tăng chỉ số của mảng a
	j copy_loop

end_copy_loop:

sortByHeight_b:
	li $t2, 0 # Khởi tạo biến k (k = 0)
        
loop_1:
	li $t3, 0 # Khởi tạo biến h (h = 0)
	addi $t2, $t2, 1 # k = k + 1
	sub $t4, $s2, $t2 # n = n - k

loop_2:
	add $t5, $t3, $t3 # Nhân h với 2 và lưu vào $t5
	add $t6, $t5, $t5 # Nhân h với 4 và lưu vào $t4
	add $t6, $t6, $s0 # Thêm địa chỉ cơ sở của a vào 4*h
	lw $a0, 0($t6) # Nạp a[h] vào $a0
	lw $a1, 4($t6) # Nạp a[h+1] vào $a1

if:
	slt $t7, $a0, $a1 # a[h] < a[h+1] ?
	bne $t7, $zero, else
	# Đảo a[h] và a[h+1]
	sw $a1, 0($t6)
	sw $a0, 4($t6)

else:
	addi $t3, $t3, 1 # h = h + 1
	slt $a2, $t3, $t4 # $t3 < $t4 ?
	beq $a2, $zero, endloop_2 
	j loop_2

endloop_2:
	slt $a3, $t2, $s2 # $t2 < $s2 ?
	beq $a3, $zero, endloop_1
	j loop_1

endloop_1:

# Sắp xếp lại mảng a
end_sortByHeight_b:
    	la $s0, a
    	la $s1, b
 	li $t0, 0 # Khởi tạo chỉ số i của mảng a (i = 0)
    	li $t1, 0 # Khởi tạo chỉ số j của mảng b (j = 0)

sortByHeight_a:
    	bgt $t0, $s2, print_a
    	lw $t8, 0($s0) # Lấy giá trị của mảng a
    	bne $t8, -1, replace_a # Nếu giá trị tại mảng a khác -1, thay thế bằng giá trị của mảng b 
    	addi $s0, $s0, 4 # Di chuyển con trỏ mảng a lên 4 byte
    	addi $t0, $t0, 1 # Tăng chỉ số của mảng a
    	j sortByHeight_a

replace_a:
    	lw $t9, 0($s1)
    	sw $t9, 0($s0)
    	addi $s0, $s0, 4 # Di chuyển con trỏ mảng a lên 4 byte
    	addi $t0, $t0, 1 # Tăng chỉ số của mảng a
    	addi $s1, $s1, 4 # Di chuyển con trỏ mảng b lên 4 byte
    	addi $t1, $t1, 1 # Tăng chỉ số của mảng b
    	j sortByHeight_a

print_a:
	li $v0, 4
	la $a0, mess1
	syscall
	
    	la $s0, a # Load địa chỉ của mảng a vào thanh ghi $s0
    	lw $s2, length # Load số lượng phần tử của a vào thanh ghi $s2
    	li $t0, 0 # Khởi tạo chỉ số i của mảng a (i = 0)
    	
    	lw $s7, ($s0) # Load giá trị đầu tiên của mảng a
    	li $v0, 1
    	move $a0, $s7 # Load giá trị của mảng a vào thanh ghi $a0 để in ra
    	syscall
    	
    	addi $s0, $s0, 4
    	addi $t0, $t0, 1

print_loop:
    	bge $t0, $s2, end_print_loop # Kiểm tra xem chỉ số i đã vượt quá n-1 chưa
    	
    	li $v0, 4
    	la $a0, comma
    	syscall
    	
    	lw $a0, 0($s0)
    	li $v0, 1
    	syscall

    	addi $s0, $s0, 4
    	addi $t0, $t0, 1
    	j print_loop

end_print_loop:
	li $v0, 4
	la $a0, mess2
	syscall

exit:	
    	li $v0, 10
    	syscall

