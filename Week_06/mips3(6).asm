# sắp xếp nổi bọt tăng dần 
.data
A: .word 5,9,-6,2,-10,33,25 # khai báo mảng bất kì 
.text
main: 
la $a0,A # load địa chỉ mảng A vào thanh ghi $a0
li $a1,7 # load số phần tử của mảng A vào thanh ghi $a1
j sort  
after_sort: 
li $v0, 10 # exit
syscall
end_main:
sort:
addi $t0, $zero, 0 # khai báo biến i (i = 0)
loop_1:
addi $t1, $zero, 0 # khai báo biến j (j = 0)
addi $t0, $t0, 1 # i = i + 1
sub $t2, $a1, $t0 # n - i
loop_2:
add $t3, $t1, $t1 # put 2j in $t1
add $t4, $t3, $t3 # put 4j in $t2
add $t4, $t4, $a0  
lw $a2, 0($t4) # A[j]
lw $a3, 4($t4) # A[j+1]
if:
ble $a2, $a3, else # Nếu A[j] < A[j+1] thì không swap
# Swap A[j] và A[j+1]
sw $a3, 0($t4)
sw $a2, 4($t4)
else:
addi $t1, $t1, 1 # Tăng j lên 1
slt $t5, $t1, $t2 # $t1 < $t2 
beq $t5, $zero, endloop_2 
j loop_2
endloop_2:
slt $t6, $t0, $a1 # $t0 < $t1
beq $t6, $zero, endloop_1
j loop_1
endloop_1:

