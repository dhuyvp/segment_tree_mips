#lay gia tri theo index
.macro get(%buildTree, %index, %reg)
	move $t5, %index
	lw %reg, %buildTree($t5)
.end_macro

#lay gia tri 2^n nho nhat sao cho 2^n >= val
.macro getminlog(%reg)
	.text 
		li $t6, 1
		loop:
			bge $t6, %reg, exit
			mul $t6, $t6, 2
			
			j loop
		exit:
			move %reg, $t6
.end_macro

#lay gia tri lon nhat trong doan [l, r]
.macro getValue(%data, %regLeft, %regRight, %buildTree)
	.data 
		dataTree:		.word -1:100000
	.text	
		li $s0, 0x80000000
		move $s1, %regLeft # gia tri u
		move $s2, %regRight # gia tri v
		
		li $t1, 1
		li $t2, 4
		lw $t2, %data($t2)	#$t2 = length of array
		getminlog($t2)
		li $t3, 12
		sw $t1, dataTree($t3)
		addi $t3, $t3, 4
		sw $t1, dataTree($t3)
		addi $t3, $t3, 4
		sw $t2, dataTree($t3)

		#Dequi (id, l, r, u, v) voi u = $s1, v = $s2
		mainDeQui:
			li $t4, 8
			ble $t3, $t4, exit
		
			lw $t7, dataTree($t3)
			addi $t3, $t3, -4
			lw $t6, dataTree($t3)
			addi $t3, $t3, -4
			lw $t5, dataTree($t3)
			addi $t3, $t3, -4
			
			sge $t1, $t6, $s1		# l >= u
			sle $t2, $t7, $s2		# r <= v
			and $t1, $t1, $t2
			bne $t1, $zero, getValueOfIndex
			
			blt $t7, $s1, deleteIndex		# r < u
			bgt $t6, $s2, deleteIndex		# l > v
			bgt $t6, $t7, deleteIndex 		# l > r
			bgt $t6, $t7, deleteIndex		# l == r
			
			######them (l, mid) va (mid + 1, r)
			add $t1, $t6, $t7
			div $t1, $t1, 2		#$t3 = mid
			# (id*2, l, mid)
			mul $t5, $t5, 2
			
			addi $t3, $t3, 4
			sw $t5, dataTree($t3)
			addi $t3, $t3, 4
			sw $t6, dataTree($t3)
			addi $t3, $t3, 4
			sw $t1, dataTree($t3)
			#(id*2+1, mid+1, r)
			addi $t5, $t5, 1
			addi $t1, $t1, 1
			
			addi $t3, $t3, 4
			sw $t5, dataTree($t3)
			addi $t3, $t3, 4
			sw $t1, dataTree($t3)
			addi $t3, $t3, 4
			sw $t7, dataTree($t3)
			
			j mainDeQui
			
		getValueOfIndex:
		################################
		#	addi $sp, $sp, -8
		#	sw $v0, 0($sp)
		#	sw $a0, 4($sp)
		#	
		#	move $a0, $t5
		#	li $v0, 1
		#	syscall
		#	printf(" getvalue\n")
		#	lw $v0, 0($sp)
		#	lw $a0, 4($sp)
		#
		#	addi $sp, $sp, 8
		#######################
			mul $t5, $t5, 4
			get(%buildTree, $t5, $s3)
			blt $s0, $s3, swapValue
			
			j deleteIndex
		swapValue:
			move $s0, $s3
			j deleteIndex
		deleteIndex:
			li $t4, 8
			beq $t3, $t4, exit
			j mainDeQui
		exit:
			addi $sp, $sp, -8
			sw $v0, 0($sp)
			sw $a0, 4($sp)
			
			printf("Gia tri phan tu lon nhat trong doan [l, r]: ")
			move $a0, $s0
			li $v0, 1
			syscall
			
			lw $v0, 0($sp)
			lw $a0, 4($sp)
	
			addi $sp, $sp, 8

.end_macro
##################################################
.macro build(%data, %buildTree)
	.text
		li $t7, 4
        	lw $t7, %data($t7) #length of array
        	li $t6, 0
        	loop:
        		li $t5, 1
        		sllv $t5, $t5, $t6
        		bge $t5, $t7, initial
        		addi $t6, $t6, 1
        	
        		j loop
        	initial:
        		add $t0, $0, $t6	#$t6 chua so nguyen n lon nhat ma 2^n <= length
  	     	li $t1, 1
        		sllv $t0, $t1, $t0	# 2^(depth-1)
   	     	mul $t0, $t0, 4
        
 	     	li $t1, 8
   	     	move $t2, $t7
        		mul $t2, $t2, 4
        		addi $t2, $t2, 4
        		
        		j loop1
        	loop1:
     	  	bgt $t1, $t2, finishLoop1
            	lw $t4, %data($t1)
            	sw $t4, %buildTree($t0)
            
            	addi $t0, $t0, 4
            	addi $t1, $t1, 4
            
            	j loop1
                
        	finishLoop1:
            	add $t0, $t6, $0
            	li $t1, 1
            	sllv $t0, $t1, $t0
            	mul $t0, $t0, 4
            	addi $t0, $t0, -4

            	j loop2
        
        	loop2:
            	ble $t0, $zero, exit
            	mul $t3, $t0, 2
            	lw $t6, %buildTree($t3)		#value at index = 2*id
            	addi $t3, $t3, 4
            	lw $t5, %buildTree($t3)		#value at index = 2*id+1
            	blt $t6, $t5, swapValue
            
            	sw $t6, %buildTree($t0)
            	addi $t0, $t0, -4
            	
            	j loop2
        	swapValue: 
            	move $t6, $t5
            	sw $t6, %buildTree($t0)
            	addi $t0, $t0, -4
            	j loop2
                
        	exit:   

.end_macro

###################################################
.macro updateValue(%data, %regLeft, %regRight, %buildTree)
	.text
		move $s1, %regLeft # gia tri u
		move $s2, %regRight # gia tri v
		
		##thay doi trong data
		move $t7, $s1 
		addi $t7, $t7, 1
		mul $t7, $t7, 4
		sw $s2, %data($t7)
		
		### cap nhap buildTree
		li $t7, 0
		lw $t3, %buildTree($t7)
		addi $t7, $t7, 4
		lw $t4, %buildTree($t7)
		addi $t7, $t7, -4
		loop:
			li $t6, 1
			sllv $t6, $t6, $t7
			bge $t6, $t4, exit
			addi $t7, $t7, 1
			j loop
		
		exit:
			add $s1, $t6, $s1
			addi $s1, $s1, -1
			mul $s1, $s1, 4
			
			sw $s2, %buildTree($s1)
			div $s1, $s1, 2
			
			j loop2
		loop2:
			li $t3, 4
			blt $s1, $t3, exitloop2
     		
     		mul $t7, $s1, 2
     		addi $t6, $t7, 4
     		lw $t7, %buildTree($t7)
     		lw $t6, %buildTree($t6)
     		
     		bgt $t6, $t7, swapValue
     		sw $t7, %buildTree($s1)
     		div $s1, $s1, 2
     		
     		j loop2
     		
     	swapValue:
     		sw $t6, %buildTree($s1)
     		div $s1, $s1, 2
     		
     		j loop2
     		
     
     	exitloop2:
     		printf("Thay doi gia tri thanh cong!\n")
     	
.end_macro
