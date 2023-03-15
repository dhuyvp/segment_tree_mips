.macro exit
	.text 
		li $v0, 10
		syscall
.end_macro

#########################
.macro checkData(%data, %main)
	.text 
		li $s6, 0 #khoi tao nhap du lieu loi
		li $t5, 0
		lw $t6, %data($t5)
		addi $t5, $t5, 4
		lw $t7, %data($t5)
	
		ble $t7, $0, errorN
		addi $t7, $t7, 1
		bne $t6, $t7, errorData
		
		j exit
		errorN:
			printf("So nguyen n khong phai so nguyen duong\n")
			j %main
		errorData:
			printf("Nhap chua du mang so nguyen hoac nhap thua mang so nguyen\n")
			j %main	
		exit:
			li $s6, 1 #Kiem tra du lieu dung
.end_macro

##########################
.macro checkIndex(%regIndex, %data, %main)
	.text
		li $t5, 4
		li $t6, 1
		lw $t7, %data($t5)
		
		sle $t1, %regIndex, $t7
		sge $t2, %regIndex, $t6
		and $t1, $t1, $t2
		
		beq $t1, $0, error
		
		j exit
		error:
			printf("Chi so i khong nam trong doan [1, n]\n")
			
			j %main
		exit:
		
.end_macro

##########################
.macro checkPairIndex(%reg1, %reg2, %data, %main)
	.text
		li $t5, 4
		li $t6, 1
		lw $t7, %data($t5)
		
		sle $t1, %reg1, $t7
		sge $t2, %reg1, $t6
		and $t1, $t1, $t2
		beq $t1, $0, errorLeft
		
		sle $t1, %reg2, $t7
		sge $t2, %reg2, $t6
		and $t1, $t1, $t2
		beq $t1, $0, errorRight		
		
		bgt %reg1, %reg2, error
		
		j exit
		errorLeft:
			printf("Chi so l khong nam trong doan [1, n]\n")
			
			j %main
		errorRight:
			printf("Chi so r khong nam trong doan [1, n]\n")
			
			j %main
		error:
			printf("Chi so l lon hon chi so r\n")
			
			j %main
		exit:
		
.end_macro

