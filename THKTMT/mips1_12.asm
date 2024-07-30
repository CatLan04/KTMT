.data
data: .space  1024  # M?ng 16x16 (16 * 16 * 4 byte = 1024 byte)
# Ch??ng tr�nh ch�nh
.text
.globl main
main:
    li $t0, 0                   # Kh?i t?o gi� tr? ban ??u c?a row = 0
    li $t6, 16
    li $t4, 0                # value= 0
col_loop:
    beq $t1, $t6, exit            # N?u col >= 16 th� tho�t kh?i v�ng l?p
    li $t0, 0                    # Kh?i t?o gi� tr? ban ??u c?a col = 0
row_loop:
    beq $t0, $t6, next_col        # N?u row >= 16 th� chuy?n sang d�ng k? ti?p
    la $t2, data                 # Load ??a ch? c?a m?ng data v�o $t2
    sll $t3, $t0, 4             # row * 16
    add $t3,$t3,$t1             # row * 16 + col
    sll $t3, $t3, 2
    add $t3,$t3,$t2
    sw $t4, 0($t3)               # L?u gi� tr? t? $t4 v�o m?ng data
    addi $t4, $t4, 1         	 # T?ng gi� tr? c?a value l�n 1
    addi $t0, $t0, 1             # T?ng gi� tr? c?a row l�n 1
    j row_loop                   # Quay l?i v�ng l?p c?t

next_col:
    addi $t1, $t1, 1             # T?ng gi� tr? c?a col l�n 1
    j col_loop                   # Quay l?i v�ng l?p h�ng

exit:
    # K?t th�c ch??ng tr�nh
    li $v0, 10                   # Code exit
    syscall