.data
data: .space  1024  # M?ng 16x16 (16 * 16 * 4 byte = 1024 byte)
# Ch??ng trình chính
.text
.globl main
main:
    li $t0, 0                   # Kh?i t?o giá tr? ban ??u c?a row = 0
    li $t6, 16
    li $t4, 0                # value= 0
col_loop:
    beq $t1, $t6, exit            # N?u col >= 16 thì thoát kh?i vòng l?p
    li $t0, 0                    # Kh?i t?o giá tr? ban ??u c?a col = 0
row_loop:
    beq $t0, $t6, next_col        # N?u row >= 16 thì chuy?n sang dòng k? ti?p
    la $t2, data                 # Load ??a ch? c?a m?ng data vào $t2
    sll $t3, $t0, 4             # row * 16
    add $t3,$t3,$t1             # row * 16 + col
    sll $t3, $t3, 2
    add $t3,$t3,$t2
    sw $t4, 0($t3)               # L?u giá tr? t? $t4 vào m?ng data
    addi $t4, $t4, 1         	 # T?ng giá tr? c?a value lên 1
    addi $t0, $t0, 1             # T?ng giá tr? c?a row lên 1
    j row_loop                   # Quay l?i vòng l?p c?t

next_col:
    addi $t1, $t1, 1             # T?ng giá tr? c?a col lên 1
    j col_loop                   # Quay l?i vòng l?p hàng

exit:
    # K?t thúc ch??ng trình
    li $v0, 10                   # Code exit
    syscall