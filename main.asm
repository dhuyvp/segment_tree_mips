############################ Main program ##################################
.include "printf_scanf.asm"
.include "math.asm"
.include "segment_tree.asm"

.data
	fileInput:	.asciiz "/home/dhuyvp/Documents/KTMT/Final/input01"
	fileName: 	.space 1024
	data:		.word 0:10000
	buildTree:	.word 0x80000000:100000
.text
	
.globl main
main:
   	printf("\n______________________________________________\n")
    	printf("1. Nhap du lieu tu file\n")
    	printf("2. Nhap du lieu tu ban phim\n")
    	printf("3. Thay doi gia tri phan tu thu i trong mang thanh val\n")
    	printf("4. Tim gia tri phan tu lon nhat trong doan [l,r]\n")
    	printf("5. Thoat\n")
    	printf("Lua chon: ")
    	addi $v0, $0, 5
    	syscall
    	# Switch - case
    	beq $v0, 1, case1
    	beq $v0, 2, case2
    	beq $v0, 3, case3
   	beq $v0, 4, case4
   	beq $v0, 5, case5
    	printf("Vui long dua ra lua chon phu hop\n")
    j main
    
case1:
	printf("Nhap duong dan den file: ")
	readFileName(fileName)
	readDataFromFile(fileName, data, main)
	checkData(data, main)
	
	#printf_fullarray(data)
	
	build(data, buildTree)
    	j main

case2:
	readFromKeyBoard(data)
	checkData(data, main)
	
	#printf_fullarray(data)
	
	build(data, buildTree)
    	j main

case3:
	readIndexAndValue($s1, $s2)
	
	checkIndex($s1, data, main)
	
	updateValue(data, $s1, $s2, buildTree)
	
	#printf_fullarray(data)
    	j main

case4:
	#printf_fullarray(data)
	readLeftRight($s1, $s2)
	
	checkPairIndex($s1, $s2, data, main)
	
	getValue(data, $s1, $s2, buildTree)
	j main

case5:
    	exit
