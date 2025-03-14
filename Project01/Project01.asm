.data
banner : .asciiz "Please input the numerical grade (0~100):"
grade : .asciiz "The letter grade is "
dot : .asciiz ".\n"
description : .asciiz "Description: "

na : .asciiz "N/A"
badinput : .asciiz "Illegal numerical grade."

x : .asciiz "X"
xdes : .asciiz "Not graded due to unexcused absences or other reasons."

plus: .asciiz "+"
minus: .asciiz "-"
grades: .asciiz "A", "B", "C", "D", "E"
scores: .word 89, 84, 79, 76, 72, 69, 66, 62, 59, 49, 0

apdes : .asciiz "Superior."
andes : .asciiz "Excellent."
amdes : .asciiz "Excellent, but needs improvement."
bpdes : .asciiz "Very good."
bndes : .asciiz "Good."
bmdes : .asciiz "Good, but needs improvement."
cpdes : .asciiz "Satisfactory."
cndes : .asciiz "Satisfactory, but needs improvement."
cmdes : .asciiz "Satisfactory with major flaws."
dndes : .asciiz "Unsatisfactory, repeat recommended."
endes : .asciiz "Failure."

gradesDesc : .word apdes, andes, amdes, bpdes, bndes, bmdes, cpdes, cndes, cmdes, dndes, endes

.text
main:
	la $a0 , banner # Load banner string
	jal print       # Print string
	
	li $v0, 0x5     # Read int syscall value
	syscall         # Read int
	
	li $t0, 0x64     # 100
	la $t1, na       # BAD
	la $t2, badinput # BAD
	bgtu $v0, $t0, specialCase # if (value > 100) : specialCase
	la $t1, x        # BAD
	la $t2, xdes     # BAD
	beq $v0, $zero, specialCase # if (value == 0) : specialCase
	
	la $t0, scores  # Load scores address
	li $t1, 0x0     # for (size_t i = 0;
	li $t2, 0xc     # i < 12;
	
compare:
	lw $t3, 0($t0)   # Load score from array
	addi $t0, $t0, 4 # index ++
	bgtu $v0, $t3, foundGrade # if (value > grades[i])
	
	bgt $t1, $t2, TerminateProcess # Jump out
	addi $t1, $t1, 1 # i++;)
	j compare
	
TerminateProcess:
	li $v0, 0xa     # Exit syscall value
	syscall         # Exit

printDescription:
	la $a0, dot
	jal print

	la $a0, description
	jal print
	
	la $t0, gradesDesc # Load gradesDesc Base
	li $t3, 0x4        # Let index become offset
	mult $t1, $t3      # Compute descraiption RVA
	mflo $t1           # Get RVA
	add $t0, $t0, $t1  # Get gradesDesc VMA
	lw $a0, 0($t0)     # Load score from array
	jal print
	
	nop
	j TerminateProcess

printPlus: # print("+")
	la $a0, plus
	jal print
	j printDescription

printMinus: # print("-")
	la $a0, minus
	jal print
	j printDescription

symbol:
	li $t4, 0x3  # Divisor
	li $t5, 0x4  # if (index // 3 == 4) : printDescription
	li $t6, 0x1  # if (index % 3 == 1) : printDescription
	li $t7, 0x2  # if (index % 3 == 2) : printMinus
	div $t1, $t4 # index / 3
	mflo $t0                       # Load Quotient
	beq $t0, $t5, printDescription # if (index / 3 == 4) : printDescription
	mfhi $t0                       # Load Remainder
	beq $t0, $zero, printPlus      # if (index % 3 == 0) : printPlus
	beq $t0, $t6, printDescription # if (index % 3 == 0) : printDescription
	beq $t0, $t7, printMinus       # if (index % 3 == 0) : printMinus

foundGrade:
	la $t0, grades    # Load Grades Base
	li $t2, 0x3       # Div 3
	div $t1, $t2      # index / 3
	mflo $t2          # Load Quotient
	li $t3, 0x2       # Let index become offset
	mult $t2, $t3     # Compute string offset
	mflo $t2          # Load Result
	add $t0, $t0, $t2 # Add Grade RVA to Grade VMA
	
	la $a0, grade     # Load grade text
	jal print         # Print grade text
	
	move $a0, $t0     # Argument is Grade VMA
	jal print         # Print Grade
	
	jal symbol        # Print is plus or minus or none
	
print: # print()
	li $v0, 0x4    # print syscall value
	syscall        # print string
	jr $ra         # Return

specialCase:
	la $a0, grade
	jal print
	move $a0, $t1
	jal print
	la $a0, dot
	jal print
	la $a0, description
	jal print
	move $a0, $t2
	jal print
	j TerminateProcess
