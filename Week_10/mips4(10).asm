.eqv KEY_CODE 	0xFFFF0004 			# ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 			# =1 if has a new keycode ?
# Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C 			# ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008			# =1 if the display has already to do
# Auto clear after sw

.data
exit: .asciiz	"exit"

.text
 li	$k0, KEY_CODE
 li 	$k1, KEY_READY
 li 	$s0, DISPLAY_CODE
 li 	$s1, DISPLAY_READY
 la 	$s2, exit
 li	$t3, 0
		
loop: nop
WaitForKey:
 lw $t1, 0($k1) # $t1 = [$k1] = KEY_READY
 nop
 beq $t1, $zero, WaitForKey # if $t1 == 0 then Polling
 nop
ReadKey:
 lw $t0, 0($k0) # $t0 = [$k0] = KEY_CODE
 nop
WaitForDis:
 lw $t2, 0($s1) # $t2 = [$s1] = DISPLAY_READY
 nop
 beq $t2, $zero, WaitForDis # if $t2 == 0 then Polling
 nop

checkExit:
 add $t4, $t3, $s2
 lb $t4, 0($t4)
 bne $t4, $t0, reset
 addi $t3, $t3, 1
 j ShowKey
reset:
 addi $t3, $0, 0
 beq $t0, 'e', checkExit
 j ShowKey

ShowKey:
 sw $t0, 0($s0) # show key
 nop
 beq $t3, 4, end
 j loop
 
end:
 li $v0, 10
 syscall
