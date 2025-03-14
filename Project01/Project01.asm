.data
banner : .asciiz "Please input the numerical grade (0~100):"
grade : .asciiz "The letter grade is "
dot : .asciiz "."
description : .asciiz "Description: "

ap : .asciiz "A+"
an : .asciiz "A"
am : .asciiz "A-"
bp : .asciiz "B+"
bn : .asciiz "B"
bm : .asciiz "B-"
cp : .asciiz "C+"
cn : .asciiz "C"
cm : .asciiz "C-"
d : .asciiz "D"
e : .asciiz "E"
x : .asciiz "X"
na : .asciiz "N/A"

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
xdes : .asciiz "Not graded due to unexcused absences or other reasons."
badinput : .asciiz "Illegal numerical grade."


scores: .word 90, 85, 80, 77, 73, 70, 67, 63, 60, 50, 1, 0
apv : .word 90
anv : .word 85
amv : .word 80
bpv : .word 77
bnv : .word 73
bmv : .word 70
cpv : .word 67
cnv : .word 63
cmv : .word 60
dv : .word 50
ev : .word 1
xv : .word 0

.text
main:
	la $a0 , banner # Load banner string
	jal print       # Print string
	
	li $v0, 5       # Read int syscall value
	syscall         # Read int
	
	la $t0, scores  # Load scores address
	li $t1, 0
	li $t2, 12
	
compare:
	
	lw $a0, 0($t0)
	
	addi $t0, $t0, 4
	
	bgt $t1, $t2, foundGrade # Jump out
	j compare
	
foundGrade:
	nop

	
TerminateProcess:
	li $v0, 10      # Exit syscall value
	syscall         # Exit
	
print:
	li $v0, 4      # print syscall value
	syscall        # print string
	jr $ra         # Return





#	.text
 #   li   $v0, 999999
#	li   $v0, 5				#specify read integer service
#	syscall					#input integer
#	la   $t1, value				#load the memory address of the preset value
#	lw   $t1, 0($t1)			#load the preset value
#	sub  $t2, $v0, $t1			#compare input with the preset value
#	beq  $t2, $zero, EQ			#jump to "EQ" if input equal to the preset value
#	bgtz $t2, GT				#jump to "GT" if input greater than the preset value
#	bltz $t2, LT				#jump to "LT" if input greater than the preset value



#LT:	la   $a0, small				#load the address of the "small" string
#	li   $v0, 4				#specify print integer service
#	syscall 				#print the "small" string
#	li   $v0, 10				#system call for exit
#	syscall 				#exit
