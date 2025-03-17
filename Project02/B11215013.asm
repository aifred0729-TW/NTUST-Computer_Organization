.data
banner : .asciiz "Please input a non-negative integer:\n"
descraiption : .asciiz "The sum of the digits of "
is : .asciiz " is "
dot : .asciiz ".\n"
badinput : .asciiz "Illegal input.\n"

.text
main:
    la $a0, banner # Load banner string
    jal print      # Print string
    jal read       # Read integer
    blt $v0, $zero, illegalInput # if (value < 0) : illegalInput
    move $t0, $v0  # Save value to t0
    la $a0, descraiption # Load descraiption string
    jal print      # Print string
    move $a0, $t0  # Load value to a0
    li $v0, 1      # Print integer
    syscall        # Print
    la $a0, is     # Load is string
    jal print      # Print string

    move $a0, $t0  # Load value to a0
    addi $sp, $sp, 0x1000 # Allocate 4KB stack space
    jal function   # Call function
    move $a0, $v1  # Load result to a0
    li $v0, 1      # Print integer
    syscall        # Print
    subi $sp, $sp, 0x1000 # Deallocate 4KB stack space
    la $a0, dot    # Load dot string
    jal print      # Print string
    j TerminateProcess # TerminateProcess

function:
    move $v0, $ra  # Save return address on top of stack
    jal push       # Push return address to stack

    beq $a0, $zero, return # S(0) return

    li $t5, 0xa    # 10
    div $a0, $t5   # n / 10

    mflo $a0       # Get quotient
    mfhi $v0       # Get remainder
    jal push       # Push remainder to stack

    jal function   # Recursion
    
    jal pop           # Pop remainder from stack
    add $v1, $v1, $v0 # Add remainder to quotient

    jal pop       # Pop return address from stack
    move $ra, $v0 # Restore return address
    jr $ra        # Return

return:
    nop
    jal pop       # Pop return address from stack
    move $ra, $v0 # Restore return address

    subi $sp, $sp, 4 # Stack pointer - 4
    sw $zero, 0($sp) # Save S(0) to stack
    subi $sp, $sp, 4 # Stack pointer - 4

    move $v1, $zero  # Clear v1
    jr $ra           # Return

push:
    sw $v0, 0($sp)   # Save return address
    subi $sp, $sp, 4 # Stack pointer - 4
    jr $ra           # Return

pop:
    addi $sp, $sp, 4 # Stack pointer + 4
    lw $v0, 0($sp)   # Load return address
    jr $ra           # Return

TerminateProcess:
    li $v0, 10 # Exit syscall value
    syscall    # Exit

print:
    li $v0, 4 # Print string syscall
    syscall   # Print
    jr $ra    # Return

read:
    li $v0, 5 # Read integer syscall
    syscall   # Read integer
    jr $ra    # Return

illegalInput:
    li $v0, 4          # Print string syscall
    la $a0, badinput   # Load badinput string
    syscall            # Print badinput string
    j TerminateProcess # TerminateProcess