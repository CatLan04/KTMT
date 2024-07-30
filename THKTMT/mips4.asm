.eqv KEY_CODE 0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 # =1 if has a new keycode ?
 # Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C # ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 # =1 if the display has already to do
 # Auto clear after sw
.data
exit_command: .asciiz "exit"

.text
 li $k0, KEY_CODE
 li $k1, KEY_READY

 li $s0, DISPLAY_CODE
 li $s1, DISPLAY_READY
loop: nop
WaitForKey: lw $t1, 0($k1) # $t1 = [$k1] = KEY_READY
 nop
 beq $t1, $zero, WaitForKey # if $t1 == 0 then Polling
 nop
 #-----------------------------------------------------
ReadKey: lw $t0, 0($k0) # $t0 = [$k0] = KEY_CODE
 nop
 #-----------------------------------------------------
WaitForDis: lw $t2, 0($s1) # $t2 = [$s1] = DISPLAY_READY
 nop
 beq $t2, $zero, WaitForDis # if $t2 == 0 then Polling
 nop
 #-----------------------------------------------------
# Encrypt: addi $t0, $t0, 1 # change input key
 #-----------------------------------------------------
ShowKey: sw $t0, 0($s0) # show key
 nop
 CheckExit:
    lb $t3, exit_command($s2)    # N?p ký t? l?nh thoát hi?n t?i
    bne $t0, $t3, NotExitChar    # N?u phím không kh?p v?i ký t? l?nh thoát hi?n t?i, b? qua
    addi $s2, $s2, 1             # Chuy?n ??n ký t? ti?p theo trong l?nh thoát
    lb $t3, exit_command($s2)    # N?p ký t? l?nh thoát ti?p theo
    beqz $t3, Exit               # N?u ký t? ti?p theo là 0 (cu?i chu?i), thoát
    j loop
 NotExitChar:
    li $s2, 0                    # ??t l?i b? ??m l?nh thoát
 #-----------------------------------------------------
 j loop
 nop              # Ng??c l?i, ti?p t?c ??c phím
Exit:
    # Thoát ch??ng trình
    li $v0, 10
    syscall

