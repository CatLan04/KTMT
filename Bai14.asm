.data
inputString1: .space 100 # Chuoi nhap vào 1
inputString2: .space 100 # Chuoi nhap vào 2
array1: .word 0:256 # Tao mang 26 phan tu chua so lan xuat hien cua các kí tu tu 'a' -> 'z' trong chuoi 1
array2: .word 0:256 # Tao mang 26 phan tu chua so lan xuat hien cua các kí tu tu 'a' -> 'z' trong chuoi 2

input1_msg: .asciiz "Nhap chuoi 1: "
input2_msg: .asciiz "Nhap chuoi 2: "
result: .asciiz "Ket qua bai toan la: "


.text
main:
#--------------------------------------------------------------------------------------------
# @brief	Nhan vao 1 xau tu nguoi dung (xau 1)
#--------------------------------------------------------------------------------------------
getString1:
	li $v0, 4
    	la $a0, input1_msg
    	syscall
    	
    	li $v0, 8
    	la $a0, inputString1
    	li $a1, 100
    	syscall
#--------------------------------------------------------------------------------------------
# @brief		Tim so lan xuat hien cac ki tu 'a'-'z' trong string1
# @param[in]	$s0	Dia chi string1 can duyet
# @param[out]	$s1	Do dai cua string1
# @param[out]	$t0	Chi so cua ki tu cuoi cung (Tinh tu 0)
#--------------------------------------------------------------------------------------------
For_string1:
	la $s0, inputString1
	la $s4, array1
	addi $s1, $zero, 0	#s1 = length = 0
	addi $t0, $zero, 0	#t0 = i = 0
findNullChar_string1:
	add $t2, $s0, $t0	#t2 = pointer = inputString + i 
	lb $t3, 0($t2) 		#t3 = inputString1[i]
	
	beq $t3, $zero,finish_for_string1 #if inputString1[i] == '\0' -> finish_for_string1
	
	addi $s7, $zero, 10
	beq $t3, $s7, updateString #if inputString1[i] == '\n' -> bo di '\n'
	
	addi $s7, $t3, 0
	sll $s7, $s7, 2
	add $s7, $s7, $s4
	lw $t4, 0($s7)
	addi $t4, $t4, 1
	sw  $t4, 0($s7)
	
	addi $s1, $s1, 1
	addi $t0, $t0, 1
	j findNullChar_string1
updateString:
	add $t0, $s0, $t0
	sb $zero, 0($t0)
finish_for_string1:
#--------------------------------------------------------------------------------------------
# @brief	Nhan vao 1 xau tu nguoi dung (xau 2)
#--------------------------------------------------------------------------------------------
getString2:
	li $v0, 4
    	la $a0, input2_msg
    	syscall
    	
    	li $v0, 8
    	la $a0, inputString2
    	li $a1, 100
    	syscall
#--------------------------------------------------------------------------------------------
# @brief		Tim so lan xuat hien cac ki tu 'a'-'z' trong string2
# @param[in]	$s2	Dia chi string2 can duyet
# @param[out]	$s3	Do dai cua string2
# @param[out]	$t1	Chi so cua ki tu cuoi cung (Tinh tu 0)
#--------------------------------------------------------------------------------------------
For_string2:
	la $s2, inputString2
	la $s5, array2
	addi $s3, $zero, 0	#s3 = length2 = 0
	addi $t1, $zero, 0	#t1 = i = 0
findNullChar_string2:
	add $t2, $s2, $t1	#t2 = pointer = inputString2 + i 
	lb $t3, 0($t2) 		#t3 = inputString2[i]
	
	beq $t3, $zero,finish_for_string2 #if inputString2[i] == '\0' -> finish_for_string2
	
	addi $s7, $zero, 10
	beq $t3, $s7, updateString2 #if inputString2[i] == '\n' -> bo di '\n'
	
	addi $s7, $t3, 0 #Lay vi tri ki tu trong bang ma ASKII
	sll $s7, $s7, 2
	add $s7, $s7, $s5
	lw $t4, 0($s7)
	addi $t4, $t4, 1
	sw  $t4, 0($s7)
	
	addi $s3, $s3, 1
	addi $t1, $t1, 1
	j findNullChar_string2
updateString2:
	add $t1, $s2, $t1
	sb $zero, 0($t1)
finish_for_string2:
#--------------------------------------------------------------------------------------------
# @brief		Tim so ki tu chung cua 2 xau
# @param[in]	$s4	Dia chi mang luu so lan xuat hien cac ki tu trong string1
# @param[in]	$s5	Dia chi mang luu so lan xuat hien cac ki tu trong string2
# @param[out]	$t8	So ki tu chung cua mang
#--------------------------------------------------------------------------------------------
common_characters:
	addi $t8, $zero, 0
	addi $t3, $zero, 0 # i = 0
	
Cacl:
	beq $t3,256, print_result
	addi $t4, $t3, 0
	sll $t4, $t4, 2 # i*4
	add $t5, $t4, $s4 
	lw $s6, 0($t5) # $s6 = array1[i]
	add $t4, $t4, $s5
	lw $s7, 0($t4) # $s7 = array2[i]
	slt $t6, $s6, $s7 
	beq $t6, $zero, else
	add $t8, $t8, $s6
	j Exit
else: 
	add $t8, $t8, $s7
Exit:	addi $t3, $t3, 1
	j Cacl
#--------------------------------------------------------------------------------------------
# @brief		In ket qua
# @param[out]		In ket qua ra console hoac man hinh
#--------------------------------------------------------------------------------------------	
print_result:
	li $v0, 4          
    	la $a0, result
    	syscall	
    	
    	li $v0, 1           # System call de in ra gia tri
    	add $a0, $zero, $t8
    	syscall	
	
