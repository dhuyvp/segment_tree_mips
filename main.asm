############################ Main program ##################################
.include "printf_scanf.asm"
.include "math.asm"
.include "segment_tree.asm"

.data
	fileInput:	.asciiz "/home/dhuyvp/Documents/KTMT/Final/input01"
	fileName: 	.space 1024
	data:		.word 0:10000
	buildTree:	.word 0x80000000:100000
	choice:		.space 120
.text
	
.globl main
main:
   	printf("\n_______________________________________________________________________________\n")
    	printf("1. Nhap du lieu tu file\n")
    	printf("2. Nhap du lieu tu ban phim\n")
    	printf("3. Gan gia tri phan tu thu i trong mang thanh val(tuc la a[i] := val)\n")
    	printf("4. Tim gia tri phan tu lon nhat trong doan [l,r]\n")
    	printf("5. In ra so nguyen n va mang so nguyen\n")
    	printf("6. Thoat\n")
    	printf("Lua chon: ")
    	li $v0, 8
    	la $a0, choice
    	li $a1, 100
    	syscall
    	# Switch - case
    	lb $v0, choice($0)
    	li $a1, 1
    	lb $a1, choice($a1)
    	li $t7, '\n'
    	bne $a1, $t7, caseError
    	
    	li $t7, '1'
    	beq $v0, $t7, case1
    	li $t7, '2'
    	beq $v0, $t7, case2
    	li $t7, '3'
    	beq $v0, $t7, case3
    	li $t7, '4'
    	beq $v0, $t7, case4
    	li $t7, '5'
    	beq $v0, $t7, case5
    	li $t7, '6'
    	beq $v0, $t7, case6
    	    	
    	printf("Vui long dua ra lua chon phu hop\n")
     j main
    
case1:
	printf("Nhap duong dan den file: ")
	readFileName(fileName)
	readDataFromFile(fileName, data, main)
	checkData(data, main)
	
	printf("So nguyen n va mang so nguyen la: ")
	printf_fullarray(data)
	
	li $s6, 1
	build(data, buildTree)
    	j main

case2:
	readFromKeyBoard(data)
	checkData(data, main)
	
	printf("So nguyen n va mang so nguyen la: ")
	printf_fullarray(data)
	
	li $s6, 1
	build(data, buildTree)
    	j main

case3:
	bne $s6, 1, caseInputData
	
	readIndexAndValue($s1, $s2)
	
	checkIndex($s1, data, main)
	
	updateValue(data, $s1, $s2, buildTree)
	
	#printf_fullarray(data)
    	j main

case4:
	bne $s6, 1, caseInputData
	
	#printf_fullarray(data)
	readLeftRight($s1, $s2)
	
	checkPairIndex($s1, $s2, data, main)
	
	getValue(data, $s1, $s2, buildTree)
	j main

case5:
	printf("So nguyen n va mang so nguyen la: ")
	printf_fullarray(data)
	
	j main
case6:
    	exit
    	
caseError:
	printf("Vui long dua ra lua chon phu hop\n")
     j main
     
caseInputData:
	printf("Vui long nhap du lieu so nguyen n va mang so nguyen!\n")
	j main