#bai2
.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.data
Message: .asciiz " Oh my god. Someone's presed a button \n"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MAIN Procedure
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.text
main:
li $t1, IN_ADRESS_HEXA_KEYBOARD
li $t2, OUT_ADRESS_HEXA_KEYBOARD

li $t4, 0x01 # row1: 0 1 2 3
li $t5, 0x02 # row2: 4 5 6 7
li $t6, 0x04 # row3: 8 9 a b
li $t7, 0x08 # row4: c d e f

 #---------------------------------------------------------
 # Enable interrupts you expect
 #---------------------------------------------------------
 # Enable the interrupt of Keyboard matrix 4x4 of Digital Lab Sim
 li $t3, 0x80 # bit 7 of = 1 to enable interrupt
 sb $t3, 0($t1)
 #---------------------------------------------------------
 # No-end loop, main program, to demo the effective of interrupt
 #---------------------------------------------------------
Loop: nop
 nop
 nop
 nop
 b  Loop # Wait for interrupt
end_main:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# GENERAL INTERRUPT SERVED ROUTINE for all interrupts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.ktext 0x80000180
 #--------------------------------------------------------
 # Processing
 #--------------------------------------------------------
 polling: 
 sb $t4, 0($t1) # must reassign expected row
 lb $a0, 0($t2) # read scan code of key button
 bnez $a0, print
 
 sb $t5, 0($t1) # must reassign expected row
 lb $a0, 0($t2) # read scan code of key button
 bnez $a0, print

 sb $t6, 0($t1) # must reassign expected row
 lb $a0, 0($t2) # read scan code of key button
 bnez $a0, print

 sb $t7, 0($t1) # must reassign expected row
 lb $a0, 0($t2) # read scan code of key button
 bnez $a0, print
 
print: li $v0, 34 # print integer (hexa)
 syscall
IntSR:
 addi $v0, $zero, 4 # show message
 la $a0, Message
 syscall
 
 #--------------------------------------------------------
 # Evaluate the return address of main routine
 # epc <= epc + 4
 #--------------------------------------------------------
next_pc:mfc0 $at, $14 # $at <= Coproc0.$14 = Coproc0.epc
 addi $at, $at, 4 # $at = $at + 4 (next instruction)
 mtc0 $at, $14 # Coproc0.$14 = Coproc0.epc <= $at
 li $t3, 0x80 # bit 7 of = 1 to enable interrupt
 sb $t3, 0($t1)
return: eret # Return from exception
