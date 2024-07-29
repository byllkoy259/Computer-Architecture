.data
	command: .asciiz "Enter a command: "
	string1: .asciiz "opcode: "
	string2: .asciiz "operand: "
	string3: .asciiz ", correct!\n"
	string4: .asciiz ", incorrect!\n"
	msg_correct: .asciiz "The command you entered has correct syntax.\n"
	msg_incorrect: .asciiz "The command you entered has incorrect syntax.\n"
	msg_continue: .asciiz "Do you want to continue the program ? Enter '1' for Yes and '0' for No: "
	input: .space 100	
		# Không gian tạm thời dành để lưu trữ chuỗi nhập từ người dùng
	token: .space 20	
		# Không gian tạm thời để lưu trữ opcode hoặc toán hạng khi tách chuỗi nhập
	list: .asciiz "add**111;addi*112;addu*111;and**111;andi*112;beq**113;bgez*130;bgtz*130;blez*130;bltz*130;bne**113;div**110;eret*000;jr***100;jal**300;j****300;lui**120;lb***121;lh***121;lw***121;mfhi*100;mflo*100;mul**111;mult*110;nop**000;nor**111;ori**112;or***111;srl**112;srlv*111;sll**112;sllv*111;slt**111;slti*112;sra**112;sb***121;sh***121;sw***121;sub**111;teq**110;teqi*120;xor**111;xori*112"
		# Danh sách các lệnh hợp lệ của ngôn ngữ hợp ngữ MIPS
	char: .asciiz "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
		# Chuỗi chứa tất cả các kí tự hợp lệ có thể là một phần thuộc câu lệnh
	register: .asciiz "$zero*;$at***;$v0***;$v1***;$a0***;$a1***;$a2***;$a3***;$t0***;$t1***;$t2***;$t3***;$t4***;$t5***;$t6***;$t7***;$s0***;$s1***;$s2***;$s3***;$s4***;$s5***;$s6***;$s7***;$t8***;$t9***;$k0***;$k1***;$gp***;$sp***;$fp***;$ra***;$0****;$1****;$2****;$3****;$4****;$5****;$6****;$7****;$8****;$9****;$10***;$11***;$12***;$13***;$14***;$15***;$16***;$17***;$18***;$19***;$20***;$21***;$22***;$23***;$24***;$25***;$26***;$27***;$28***;$29***;$30***;$31***;$32***"
		# Danh sách các thanh ghi hợp lệ của ngôn ngữ hợp ngữ MIPS
		
.text
main:

getInput:
	li $v0, 4
	la $a0, command
	syscall
	
	# Nhận chuỗi đầu vào từ người dùng và lưu vào 'input'
	li $v0, 8 # Đọc một chuỗi
	la $a0, input # $a0 = địa chỉ của chuỗi đầu vào
	li $a1, 100
	syscall
	
	# $a1 = địa chỉ của chuỗi 'token' (chuỗi con của chuỗi đầu vào, dùng để lưu opcode hoặc toán hạng)
	la $a1, token 
	
	# Khởi tạo biến chỉ số
	li $s7, 0 
	
	# $t8, $t9 kiểm tra xem chuỗi nhập có chứa kí tự '(' hoặc ')' không
	li $t8, 0
	li $t9, 0 
	
	# Nhảy đến nhãn 'getOpcode' để bắt đầu xử lí chuỗi đầu vào
	j getOpcode
	
exit:
# Thoát khỏi chương trình
	li $v0, 10
	syscall

end_main:
		
getOpcode:	
# Trích xuất opcode từ chuỗi nhập và lưu vào 'token'
	
	# Lấy kí tự từ chuỗi đầu vào và lưu vào 'token'
        add $t1, $a0, $s7 # $t1 = địa chỉ của input[i]
        add $t3, $a1, $s7 # $t3 = địa chỉ của token[i]
        lb $t2, 0($t1)
        
	# Kết thúc trích xuất opcode khi gặp dấu cách hoặc dấu xuống dòng
        beq $t2, ' ', done
	beq $t2, '\n', done
	
	# Lưu kí tự vào vào token rồi tăng chỉ số
        sb $t2, 0($t3)         	
	addi $s7, $s7, 1
	
	j getOpcode	

done:		
        li $t2,'\0'
        sb $t2,0($t3) # Thêm kí tự null '\0' vào cuối 'token'		
	la $a2, list # $a2 = địa chỉ của chuỗi 'list'
	jal checkOpcode
	
	beq $s2, 1, correctOpcode 	
	j incorrectOpcode
        		     		    		     		
correctOpcode:			
# Nếu opcode đúng, in ra thông báo và chuẩn bị xét đến toán hạng

	li $v0, 4
	la $a0, string1		
	syscall
	
	li $v0, 4
	la $a0, token
	syscall
	
	li $v0, 4
	la $a0, string3
	syscall
	
	li $s5, 5 # Lấy loại của toán hạng đầu tiên từ trong danh sách 'list'
	li $s6, 8 # Sử dụng để kiểm tra điều kiện sau khi đã kiểm tra xong 3 loại toán hạng 
	j getOpr
	
incorrectOpcode:
# Nếu opcode sai, in ra thông báo lỗi và nhảy về nhãn 'incorrect'

	li $v0, 4
	la $a0, string1		
	syscall
	
	li $v0, 4
	la $a0, token
	syscall
	
	li $v0, 4
	la $a0, string4
	syscall
	
	j incorrect

checkOpcode:
        # Khởi tạo giá trị ban đầu để kiểm tra 
        # Thanh ghi $s2 được sử dụng để lưu trữ kết quả kiểm tra (0: không tìm thấy, 1: tìm thấy)
        li $s2, 0 
        li $s0, 0 # i = 0
    
    
    loop1:
    # Kiểm tra từng opcode có trong danh sách
        add $t0, $a2, $s0 # $t0 = địa chỉ của list[i]
        lb $t0, 0($t0) # $t0 = list[i]
        beq $t0, 0, finish # Không tìm thấy kết quả phù hợp, chuyển tới 'finish'
        move $s1, $s0 # j = i
        li $s3, 0 # k = 0 
    
    inner_loop:     
    # So sánh giữa opcode trong danh sách với trong 'token'  
        add $t0, $a2, $s1 # $t0 = địa chỉ của list[j]
        lb $t0, 0($t0) # $t0 = list[j]
        
        add $t1, $a1, $s3 # $t1 = địa chỉ của token[k]
        lb $t1, 0($t1) # $t1 = token[k]
        
        bne $t0, '*', skip 
        bne $t1, '\0', end # 'token' phải kết thúc tại kí tự này
        li $s2, 1 # Tìm thấy opcode khớp
        j finish
        
    skip:
        beq $t0, $t1, cont1 # Nếu list[j] == token[k], tiếp tục kiểm tra opcode của lệnh này
        j end
    
    cont1:
        addi $s1, $s1, 1 # j++
        addi $s3, $s3, 1 # k++
        j inner_loop
   
    end:
        addi $s0, $s0, 9 # Tiếp tục với các opcode tiếp theo
	j loop1
    
    finish:
    # Kết thúc khi đã tìm thấy hoặc duyệt hết danh sách vẫn không tìm được
        jr $ra    

getOpr:        	
# Trích xuất toán hạng từ chuỗi đầu vào và lưu trữ vào 'token'

	# Đặt địa chỉ của chuỗi đầu vào và khởi tạo chỉ số
        la $a0, input
        li $t0, 0  # i = 0
        
        add $t1, $a0, $s7
        lb $t2, 0($t1)
        beq $t2, '(', openBracket

    truncate:	
    # Bỏ qua dấu cách và dấu câu
        addi $s7, $s7, 1 
        add $t1, $a0, $s7
        lb $t2, 0($t1)
        beq $t2, ' ', truncate  
        beq $t2, ',', truncate
        beq $t2, '(', openBracket
        
    loop2:   
    # Lấy kí tự toán hạng từ chuỗi đầu vào và lưu vào token     
        add $t1, $a0, $s7 # $t1 = địa chỉ của chuỗi kí tự đầu vào tiếp theo
        add $t3, $a1, $t0 # $t3 = địa chỉ của token[i]
        lb $t2, 0($t1)
        beq $t2, ',', doneGetOpr
	beq $t2, '\n', doneGetOpr
	beq $t2, '\0', doneGetOpr
	beq $t2, ' ', closeBracket
	beq $t2, '(', doneGetOpr
	beq $t2, ')', closeBracket
        sb $t2, 0($t3)
    
    cont2:         	
	addi $t0, $t0, 1
	addi $s7, $s7, 1
	j loop2
	
doneGetOpr:
# Kết thúc trích xuất toán hạng và chuyển sang kiểm tra loại toán hạng

        li $t2, '\0'
        sb $t2, 0($t3) # Thêm '\0' vào 'token' 
        
        add $t0, $s0, $s5 # $t0 = chỉ số của loại toán hạng đầu tiên trong định dạng lệnh này
        add $t0, $a2, $t0 
        lb $t0, 0($t0) 
        addi $t0, $t0, -48 # $t0 = loại của toán hạng đầu tiên
        li $s4, 0 # Khởi tạo checkOpr = 0
    
    case0:		
	bne $t0, 0, case1		
	jal checkNullOpr 	
	j checked			
    
    case1:	
	bne $t0, 1, case2 					
	jal checkRegisterOpr 		
	j checked			

    case2:
	bne $t0, 2, case3 		
	jal checkIntegerOpr		
	j checked				
    
    case3:		
	jal checkLabelOpr		
	j checked	
    
    checked:
        addi $t2, $s5, 1
        bne $t2, $s6, skipBracket
        xor $t1, $t8, $t9
        bne $t1, $zero, incorrect

    skipBracket:
	beq $s4, 1, correctOpr	# Nếu checkOpr = 1, in thông báo chính xác
	j incorrectOpr			
	
checkNullOpr: 	
# Kiểm tra toán hạng null (không tồn tại)

        lb $t2, 0($a1)
        beq $t2, '\0', isEmpty
        j endCheckNullOpr
    
    isEmpty:
        li $s4, 1

endCheckNullOpr:
        jr $ra
        
checkRegisterOpr: 
# Kiểm tra toán hạng là thanh ghi
# So sánh giữ toán hạng trong danh sách với trong 'token'

       	li $s4, 1 
       	la $a3, register # $a3 = địa chỉ của chuỗi thanh ghi
       	li $t1, 0 # i = 0          
    
    loop5:  
       	move $t2, $t1 # j = i
       	li $t5, 0 # k = 0
    
    inner_loop5:
       	add $t3, $a3, $t2
       	lb $t3, 0($t3) # $t3 = register[j]
       	add $t4, $a1, $t5
       	lb $t4, 0($t4) # $t4 = token[k]   
       	beq $t3, '\0', isNotRegister
       	beq $t3, '*', skip5 # 'token' phải kết thúc tại kí tự này
       	bne $t3, $t4, outer5
       	j cont5
    
    skip5:
       	beq $t4, '\0', endCheckRegisterOpr
       	j outer5
    
    cont5:
       	addi $t2, $t2, 1 # j++
       	addi $t5, $t5, 1 # k++
       	j inner_loop5
    
    outer5:
       	addi $t1, $t1, 7 # Tiếp tục với các thanh ghi tiếp theo
       	j loop5
    
    isNotRegister:
       	li $s4, 0
       
endCheckRegisterOpr:
        jr $ra
        
checkIntegerOpr: 
# Kiểm tra toán hạng là số nguyên

       	li $s4, 1
       	li $t1, 0 # i = 0     
       	add $t2, $a1, $t1 
       	lb $t2, 0($t2) # $t2 = token[0]
       	beq $t2, '\0', isNotInteger # Tránh trường hợp 'token' trống
       	bne $t2, '-', loop3
       	addi $t1, $t1, 1 # i++
       	add $t2, $a1, $t1 
       	lb $t2, 0($t2)
       	beq $t2, '\0', isNotInteger # Tránh trường hợp 'token' chỉ có dấu '-'
    
    loop3:
       	add $t2, $a1, $t1 
       	lb $t2, 0($t2) # $t2 = token[i]
       	beq $t2, '\0', endCheckIntegerOpr
       	blt $t2, 48, isNotInteger
       	bgt $t2, 57, isNotInteger
       	addi $t1, $t1, 1 # i++
       	j loop3
    
    isNotInteger:
       	li $s4, 0

endCheckIntegerOpr:
       	jr $ra
        
checkLabelOpr: 
# Kiểm tra toán hạng là nhãn 

       	li $s4, 1 
       	li $t1, 0 # i = 0    
       	add $t2, $a1, $t1 
       	lb $t2, 0($t2) # $t2 = token[0]
       	beq $t2, '\0', isNotLabel # Tránh trường hợp 'token' trống
       	la $a3, char # $a3 = địa chỉ của chuỗi kí tự được chấp nhận      
       	add $t2, $a1, $t1 
       	lb $t2, 0($t2) # $t2 = token[0]  
       	slti $t3, $t2, 58
       	li $at, 47
       	slt $t4, $at, $t2
       	and $t5, $t3, $t4
       	beq $t5, 1, isNotLabel
    
    loop4:
       	add $t2, $a1, $t1 
       	lb $t2, 0($t2) # $t2 = token[i]
       	beq $t2, '\0', endCheckLabelOpr
       	li $t6, 0 # j = 0
    
    inner_loop4:
       	add $t7, $a3, $t6
       	lb $t7, 0($t7) # $t7 = char[j]
       	beq $t7, '\0', isNotLabel
       	beq $t7, $t2, outer3
       	addi $t6, $t6, 1 # j++
       	j inner_loop4
    
    outer3:
       	addi $t1, $t1, 1 # i++
       	j loop4
    
    isNotLabel:
       	li $s4, 0

endCheckLabelOpr:
       	jr $ra

correctOpr:

       	beq $t0, 0, correct
	li $v0, 4
	la $a0, string2		
	syscall
	
	li $v0, 4
	la $a0, token
	syscall
	
	li $v0, 4
	la $a0, string3
	syscall
	
        addi $s5, $s5, 1
	blt $s5, $s6, getOpr # Tiếp tục lấy toán hạng tiếp theo nếu không đủ 3 toán hạng trong câu lệnh
	
	j correct        

incorrectOpr:
        
	li $v0, 4
	la $a0, string2		
	syscall
	
	li $v0, 4
	la $a0, token
	syscall
	
	li $v0, 4
	la $a0, string4
	syscall

incorrect:
# Khi cấu trúc câu lệnh sai

	li $v0, 4
	la $a0, msg_incorrect
	syscall
	j continue
	
correct: 	
# Khi cấu trúc câu lệnh đúng

	li $v0, 4
	la $a0, msg_correct
	syscall

continue:	
# Hỏi xem có muốn tiếp tục chương trình nữa không

	li $v0, 4
	la $a0, msg_continue
	syscall
	
	li $v0, 5
	syscall
	
	# Nếu nhập vào khác 0 (= 1) thì quay trở về và chạy lại từ đầu chương trình
	bne $v0, $zero, getInput
	j exit

openBracket:
# Xử lí dấu ngoặc mở trong chuỗi đầu vào
        
        li $t8, 1
        j truncate

closeBracket:
# Xử lí dấu ngoặc đóng trong chuỗi đầu vào
        
        move $t4, $s7
    
    loop6:
        add $t2, $a0, $t4
        lb $t2, 0($t2)
        beq $t2, '\0', skip6
        beq $t2, ')', close
        j cont6
    
    close:
        li $t9, 1
        j skip6
    
    cont6:
        addi $t4, $t4, 1
        j loop6
    
    skip6:
        j doneGetOpr	
