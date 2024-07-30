.data
inputString: .space 100 # Chuoi nhap vao
palindrome_list: .space 1000 

input_msg: .asciiz "Nhap chuoi: "
result: .asciiz "Chuoi da nhap "
palindrome_msg: .asciiz "la palindrome."
not_palindrome_msg: .asciiz "khong phai la palindrome."
confirm_msg: .asciiz "Ban co tiep tuc nhap chuoi khong?\n"
finish_store_msg:.asciiz "Da luu tru xau trong bo nho!\n"
duplicate_msg: .asciiz "Chuoi palindrome da duoc nhap truoc do!\n"
.text
main:
#--------------------------------------------------------------------------------------------
# @brief	Nhan vao 1 xau tu nguoi dung
#--------------------------------------------------------------------------------------------
getString:
	li $v0, 54
	la $a0, input_msg
	la $a1, inputString
	la $a2, 100
	syscall
#--------------------------------------------------------------------------------------------
# @brief		Tim do dai 1 xau
# @param[in]	$s0	Dia chi string can tim do dai
# @param[out]	$s1	Do dai cua string
# @param[out]	$t1	Chi so cua ki tu cuoi cung (Tinh tu 0)
#--------------------------------------------------------------------------------------------
getLength:
	la $s0, inputString
	addi $s1, $zero, 0	#s1 = length = 0
	addi $t1, $zero, 0	#t1 = i = 0
findNullChar:
	add $t2, $s0, $t1	#t2 = pointer = inputString + i 
	lb $t3, 0($t2) 		#t3 = inputString[i]
	
	beq $t3, $zero,finishGetLength #if inputString[i] == '\0' -> finishGetLength
	
	addi $s7, $zero, 10
	beq $t3, $s7, updateString#if inputString[i] == '\n' -> bo di '\n'
	
	addi $s1, $s1, 1
	addi $t1, $t1, 1
	j findNullChar
updateString:
	add $t1, $s0, $t1
	sb $zero, 0($t1)
finishGetLength:
	add $t1, $zero, $s1 # i = length
	addi $t1, $t1, -1 #i = length - 1
#--------------------------------------------------------------------------------------------
# @brief		Kiem tra xem xau nhap vao co trong palindrome_list khong
# @param[in]	$s0	Dia chi cua inputString
# @param[in]	$s2	Dia chi cua palindrome_list
# @param[in]	$s1	Do dai cua string
# @param[out]	$t8	Gia tri 0 hoac 1, 1 la inputString da co trong palindrome_list
#					0 la chua co
#--------------------------------------------------------------------------------------------
isStoredInMemory:		
	la $s2, palindrome_list
	addi $t2, $zero, 0	#t2 = i = 0
	addi $t8, $zero, 0	#t8 = check = 0
	
loop_String_list:
	add $t5, $s2, $t2 	#t5 = palindrome_list + i
	lb $t5, 0($t5)
	beq $t5, $zero, finish_check_list
	addi $t3, $zero, 0	#t3 = k = 0
		
compareString:	
	add $t6, $s2, $t2	#t6 = palindrome_list + i
	add $t6, $t6, $t3	#t6 = t6 + k
	lb $t6, 0($t6)		#t6 = palindrome_list[i+k]
	add $t7, $s0, $t3	#t7 = inputString + k
	lb $t7, 0($t7)		#t7 = inputString[k]
	bne $t6, $t7, notEqual	#inputString[k]!=palindrome_list[i+k]
	beq $t6, $zero, isEqual #inputString[k]=palindrome_list[i+k]
	addi $t3, $t3, 1	#k++
	j compareString
			
isEqual:
	addi $t8, $zero, 1
	j finish_check_list
notEqual: 
	add $t2, $t2, $s1
	j loop_String_list
finish_check_list:
	bne $t8,$zero, string_is_store
#--------------------------------------------------------------------------------------------
# @brief		Kiem tra xem inputString co phai palindrome khong
# @param[in]	$s0	Dia chi cua inputString
# @param[in]	$s1	Do dai cua inputString
# @param[in]	$t1	Chi so cua ki tu cuoi cung cua inputString (Tinh tu 0)
# @param[out]		Thong bao ra man hinh
#--------------------------------------------------------------------------------------------		 
add $t1, $zero, $s1
addi $t1, $t1, -1  #t1 = j = strlength - 1
addi $t2, $zero, 0	#t2 = i = 0
checkPalindrome:		
		
	add $t3, $s0, $t2	#t3 = inputString + i
	lb $t3, 0($t3)		#t3 = inputString[i]
	
	add $t4, $s0, $t1	#t4 = inputString + j
	lb $t4, 0($t4)		#t4 = inputString[j]
	bne $t3, $t4, notIsPalindrome
	addi $t1, $t1, -1 	#j--
	addi $t2, $t2, 1	#i++
	slt $t5, $t2, $t1	#i < j?
	beq $t5, $zero, isPalindrome
	j checkPalindrome
	
notIsPalindrome:
	la $a1, not_palindrome_msg
	li $v0, 59
	la $a0, result
	syscall
	j confirmDialog
isPalindrome:
	la $a1, palindrome_msg
	li $v0, 59
	la $a0, result
	syscall
	j storeStringInMemory
#--------------------------------------------------------------------------------------------
# @brief		Luu tru inputString vao palindrome_list
# @param[in]	$s0	Dia chi cua inputString
# @param[in] 	$s2	Dia chi cua palindrome_list
# @param[in]	$s1	Do dai cua inputString
# @param[in]	$t1	Chi so cua ki tu cuoi cung cua inputString (Tinh tu 0)
#--------------------------------------------------------------------------------------------	
storeStringInMemory:
	addi $t1, $s1, -1 	#t1 = i = length - 1
	addi $t2, $zero, 0 	#t2 = i = 0
	addi $t6, $zero, 0 	#t6 = k = 0
findLastString:
	add $t3, $s2, $t2	#t3 = recentStringList + i
	lb $t3, 0($t3)
	beq $t3, $zero, copyString #palindrome_list == '\0' -> copyString
	add $t2, $t2, $s1	#i = i + strlength
	j findLastString
copyString:
	slt $t5, $t1, $t6
	bne $t5, $zero, finish_store_string
	add $t7, $t2, $t6	#t7 = i + k
	add $t7, $t7, $s2	#t7 = t7 + palindrome_list
	add $t8, $t6, $s0	#t8 = t6 + inputString
	lb  $t8, 0($t8)
	sb $t8, 0($t7)		#palindrome_list[i+k] = inputString[k]			
	addi $t6, $t6, 1	#k++
	j copyString
#--------------------------------------------------------------------------------------------
# @brief		Hien ra cac message
# @param[out]		In message ra console hoac man hinh
#--------------------------------------------------------------------------------------------	
finish_store_string:	
	li $v0, 4
	la $a0, finish_store_msg
	syscall
	j confirmDialog
	
string_is_store:
	li $v0, 4
	la $a0, duplicate_msg
	syscall	
	j confirmDialog			
#--------------------------------------------------------------------------------------------
# @brief		Nhan xem nguoi dung co muon tiep tuc nhap khong
#			Chi khi an yes moi cho nhap tiep
# @param[out]	$a0	0: Yes
#			1: No
#			2: Cancel
#--------------------------------------------------------------------------------------------		
confirmDialog:
	li $v0, 50
	la $a0, confirm_msg
	syscall
	beq $a0, $zero, main
	
