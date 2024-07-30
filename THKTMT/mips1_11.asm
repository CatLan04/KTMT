#BAI1 
#------------------------------------------------------
# col 0x1 col 0x2 col 0x4 col 0x8
#
# row 0x1 0     1    2    3
#        0x11 0x21 0x41 0x81
#
# row 0x2 4    5    6   7
#       0x12 0x22 0x42 0x82
#
# row 0x4 8    9    a   b
#       0x14 0x24 0x44 0x84
#
# row 0x8 c    d    e    f
#       0x18 0x28 0x48 0x88
#
#------------------------------------------------------
.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.text
main: 
 li $t1, IN_ADRESS_HEXA_KEYBOARD
 li $t2, OUT_ADRESS_HEXA_KEYBOARD

polling: 
row1:
 li $t3, 0x01 # row1: 0 1 2 3
 sb $t3, 0($t1) # must reassign expected row
lb $a0, 0($t2) # read scan code of key button
 bnez $a0, print
 
row2:
 li $t4, 0x02 # row2: 4 5 6 7 
 sb $t4, 0($t1) # must reassign expected row
 lb $a0, 0($t2) # read scan code of key button
 bnez $a0, print
  
 row3:
 li $t5, 0x04 # row3: 8 9 a b
 sb $t5, 0($t1) # must reassign expected row
 lb $a0, 0($t2) # read scan code of key button
bnez $a0, print
  
 row4:
 li $t6, 0x08 # row4: c d e f
 sb $t6, 0($t1) # must reassign expected row
 lb $a0, 0($t2) # read scan code of key button
  bnez $a0, print
  
 print: li $v0, 34 # print integer (hexa)
 syscall
 sleep: li $a0, 100 # sleep 100ms
 li $v0, 32
 syscall
back_to_polling: j polling # continue polling
