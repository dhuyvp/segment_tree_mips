# In chuoi ma khong thay doi gia tri cac thanh ghi
.macro printf(%string)
	.data 
		str: 	.asciiz %string
	.text
		addi $sp, $sp, -8
		sw $v0, 0($sp)
		sw $a0, 4($sp)
	
		li $v0, 4
		la $a0, str
		syscall
		lw $v0, 0($sp)
		lw $a0, 4($sp)
	
		addi $sp, $sp, 8
.end_macro

# In ra loi du lieu
.macro printfError
	.data 
		tempError: .asciiz "\nDu lieu nhap vao khong phai la so nguyen\n"
	.text
		addi $sp, $sp, -8
		sw $v0, 0($sp)
		sw $a0, 4($sp)
	
		li $v0, 4
		la $a0, tempError
		syscall
		lw $v0, 0($sp)
		lw $a0, 4($sp)
	
		addi $sp, $sp, 8
.end_macro


######################################
######################################
.macro getline(%dataSpace, %dataReg)
	.text  
	   #khoi tao gia tri
        addi $sp, $sp, -8
        li $t7, 1
        sw $t7, ($sp) # dau cua so nguyen -1 neu la so am va 1 neu la so khong am
        sw $zero, 4($sp)
        
        getArrayIntegerInLine:
            lb $t7, (%dataReg)       
            addi $a1, %dataReg, 1
            li $t6, '\n'
            beq $t7, $t6, lastNumber # luu so nguyen cuoi cung va thoat
            li $t6, ' '
            beq $t7, $t6, nextNumber # luu so nguyen 
            li $t6, '-'
            beq $t7, $t6, toNegative # doi dau thanh so am '-'
            sge $t5, $t7, '0'
            sle $t6, $t7, '9'
            and $t6, $t5, $t6
            beq $t6, $0, errorCharacter
            
            j convertCharacter
        
        toNegative:
            li $t7, -1
            sw $t7, ($sp)
            j getArrayIntegerInLine
        
        convertCharacter:
            subi $t7, $t7, '0'
            lw $t6, 0($sp)
            mul $t7, $t7, $t6
            lw $t6, 4($sp)
            mul $t6, $t6, 10
            add $t7, $t7, $t6
            sw $t7, 4($sp)
            
            j getArrayIntegerInLine
            
            
        nextNumber:
            #luu gia tri nguyen
            lw $t7, 4($sp)
            lw $t6, %dataSpace($0)
            addi $t6, $t6, 1
            sw $t6, %dataSpace($0)
            mul $t6, $t6, 4
            sw $t7, %dataSpace($t6)
            
            #khoi tao lai 
            li $t7, 1
            sw $t7, ($sp)
            sw $zero 4($sp)
            
            j getArrayIntegerInLine
        
        lastNumber:
            #luu gia tri nguyen
            lw $t7, 4($sp)  
            lw $t6, %dataSpace($0)
            addi $t6, $t6, 1
            sw $t6, %dataSpace($0)
            mul $t6, $t6, 4
            sw $t7, %dataSpace($t6)

            #khoi tao lai 
            li $t7, 1
            sw $t7, ($sp)
            sw $zero, 4($sp)
            
            j finish
            
        errorCharacter:
            printfError
            j finish
        finish:
            addi $sp, $sp, 8 
.end_macro 


##############################################################################################
#In ra mang gia tri
.macro printf_array(%data, %left, %right)
	.text
		addi $sp, $sp, -8
		sw $v0, 0($sp)
		sw $a0, 4($sp)
		
		li $t6, %left
		mul $t6, $t6, 4
		lw $t7, %data($0)
		loopPrintArray:		
			blez $t7, exitLoopPrintArray
			div $t6, $t6, 4
			bgt $t6, %right, exitLoopPrintArray
			mul $t6, $t6, 4
			
			addi $t7, $t7, -1
			addi $t6, $t6, 4
			li $v0, 1
			lw $a0, %data($t6)
			syscall
			printf(" ")
			
			j loopPrintArray
		exitLoopPrintArray:
			printf("\n")
			
			lw $v0, 0($sp)
			lw $a0, 4($sp)
	
			addi $sp, $sp, 8
		
.end_macro

.macro printf_fullarray(%data)
	.text
		addi $sp, $sp, -8
		sw $v0, 0($sp)
		sw $a0, 4($sp)

		add $t6, $0, $0
		lw $t7, %data($0)
		loopPrintArray:		
			blez $t7, exitLoopPrintArray

			addi $t7, $t7, -1
			addi $t6, $t6, 4
			li $v0, 1
			lw $a0, %data($t6)
			syscall
			printf(" ")
			
			j loopPrintArray
		exitLoopPrintArray:
			printf("\n")
			
			lw $v0, 0($sp)
			lw $a0, 4($sp)
	
			addi $sp, $sp, 8
		
.end_macro

####################################################################################
#read data tu file
.macro readDataFromFile(%filename, %data, %main)
	.data
		dataInputFile:		.space 10000	
	.text
		  	 addi $sp, $sp, -16
                sw $v0, 0($sp)
                sw $a0, 4($sp)
                sw $a1, 8($sp)
                sw $a2, 12($sp)
            
                #open file 
                li $v0, 13
                la $a0, %filename
                #flag = 0 -> read file, flag = 1 -> write file
                li $a1, 0
                syscall
                #save file descriptor
                move $s0, $v0
                
                #read file 
                li $v0, 14
                move $a0, $s0           #file descriptor
                la $a1, dataInputFile           #address of input buffer
                la $a2, 1024            #max length to read
                syscall 
                
                ble $v0, $0, error
                
                #close file 
                li $v0, 16
                move $a0, $s0
                syscall
                
                
                getline(%data, $a1)
                getline(%data, $a1)
                
                lw $v0, 0($sp)
                lw $a0, 4($sp)
                lw $a1, 8($sp)
                lw $a2, 12($sp)
                addi $sp, $sp, 16
              
              	 j finish
		error:
			printf("Duong dan file khong dung\n")
			j %main
		finish:
.end_macro


#######################################################
.macro readFileName(%fileName)
	.text
		addi $sp, $sp, -12
		sw $v0, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		
		li $v0, 8
		la $a0, %fileName
		li $a1, 1000
		syscall
		
		li $a1, 0
		loop:
			lb $v0, %fileName($a1)
			li $t7, '\n'
			beq $v0, $t7, end_loop
			
			addi $a1, $a1, 1
			j loop
		end_loop:
			li $t7, '\0'
			sb $t7, %fileName($a1)
						
		lw $v0, 0($sp)
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		addi $sp, $sp, 12
.end_macro
#######################################################
.macro readIndexAndValue(%reg1, %reg2)
	.data 
		temp1: .asciiz "Nhap vi tri i: "
		temp2: .asciiz "Nhap gia tri val: "
	.text
		addi $sp, $sp, -8
		sw $v0, ($sp)
		sw $a0, 4($sp)
		### nhap index
		la $a0, temp1
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		move %reg1, $v0
		## nhap value
		la $a0, temp2
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		move %reg2, $v0
		
		
		lw $v0, ($sp)
		lw $a0, 4($sp)
		addi $sp, $sp, 8

.end_macro

##################################################
.macro readLeftRight(%reg1, %reg2)
	.data 
		temp1: .asciiz "Nhap vi tri bat dau l: "
		temp2: .asciiz "Nhap vi tri ket thuc r: "
	.text
		addi $sp, $sp, -8
		sw $v0, ($sp)
		sw $a0, 4($sp)
		### nhap index
		la $a0, temp1
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		move %reg1, $v0
		## nhap value
		la $a0, temp2
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		move %reg2, $v0
		
		
		lw $v0, ($sp)
		lw $a0, 4($sp)
		addi $sp, $sp, 8

.end_macro
##################################################
.macro readFromKeyBoard(%data)
	.data 
		dataInputFile:		.space 10000
		nhapSoNguyenN:		.asciiz "Nhap so nguyen duong n: "
		nhapMangNSoNguyen:	.asciiz "Nhap mang n so nguyen: "
	.text
		addi $sp, $sp, -12
		sw $v0, 0($sp)
		sw $a0, 4($sp)
		sw $a1, 8($sp)
		### nhap so nguyen n
		li $v0, 4
		la $a0, nhapSoNguyenN
		syscall
		li $v0, 8
		la $a0, dataInputFile
		li $a1, 1000
		syscall
		
		move $a1, $a0
		getline(%data, $a1)
		### nhap manng so nguyen
		li $v0, 4
		la $a0, nhapMangNSoNguyen
		syscall
		li $v0, 8
		la $a0, dataInputFile
		li $a1, 10000
		syscall
		
		move $a1, $a0
		getline(%data, $a1)
		
		
		lw $v0, 0($sp)
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		addi $sp, $sp, 12
	
.end_macro