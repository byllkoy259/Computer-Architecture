.data
Mess1: .asciiz "Lon nhat: "
Mess2: .asciiz "\nNho nhat: "
Comma: .asciiz ","
.text 
main: # khởi tạo giá trị cho thanh ghi $s0-$s7
li $s0, 15 
li $s1, 5
li $s2, 9
li $s3, 30
li $s4, 169
li $s5, 99
li $s6, -17
li $s7, -2
jal init
nop
li $v0, 4
la $a0, Mess1 # print Mess1
syscall
li $v0, 1
add $a0, $t0, $zero # print max value
syscall 
li $v0, 4
la $a0, Comma # print ","
syscall
li $v0, 1
add $a0, $t5, $zero # print max value's position
syscall
li $v0, 4
la $a0, Mess2 # print Mess2
syscall
li $v0, 1
add $a0, $t1, $zero # print min value
syscall
li $v0, 4
la $a0, Comma # print ","
syscall
li $v0, 1
add $a0, $t6, $zero # print min value's position 
syscall
li $v0, 10 # exit
syscall 
endmain:
swapMax:
add $t0, $t3, $zero # set Max = $t3
add $t5, $t2, $zero # set i of max = $t2
jr $ra
swapMin:
add $t1, $t3, $zero # set Min = $t3
add $t6, $t2, $zero # set i of min = $t2
jr $ra
init:
add $fp, $sp, $zero
addi $sp, $sp, -36
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $s7, 28($sp)
sw $ra, 32($sp)
add $t0, $s0, $zero # set Max = $s0
# $t0 lưu giá trị max
add $t1, $s0, $zero # set Min = $s0
# $t1 lưu giá trị min
li $t5, 0
li $t6, 0
li $t2, 0 # i = 0
max_min:
addi $sp, $sp, 4
lw $t3, -4($sp)
sub $t4, $sp, $fp # check if meet $ra
beq $t4, $zero, done
addi $t2, $t2, 1 # i++
sub $t4, $t0, $t3
bltzal $t4, swapMax
sub $t4, $t3, $t1
bltzal $t4, swapMin
j max_min # repeat
done:
lw $ra, -4($sp)
jr $ra
