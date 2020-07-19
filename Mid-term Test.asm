#NguyenLongNhat-20176840
#Create a program to: 
#- Input an array of integers from the keyboard.
#- Find the maximum element of the array.
#- Calculate the number of elements in the range of (m, M). Range m, M are inputted from the keyboard.

#-----------------------------------------------------------------------------------------------------------
.data
list: 		.space 40
mess1: 		.asciiz","
message: 	.asciiz"Input a integer"
maxmessage:	.asciiz"Max number is "
mess2: 		.asciiz"The array : "
space: 		.asciiz "\n"
mees1:		.asciiz"Input the number of elements in the array:"
mess3: 		.asciiz"Input the first number of range"
mess4: 		.asciiz"Input the second number of range"
mess5: 		.asciiz"The number of elements that is in the range: "
rsel: 		.asciiz"): "
comma : 	.asciiz","
errmess1: 	.asciiz"You have inputted wrong type of element."
errmess2: 	.asciiz"Please input again."
errmess3: 	.asciiz"The first smaller number of the range is bigger than the bigger one."
errmess4:	.asciiz"Please input again."
inputErr:	.asciiz"Invalid input number of elements in array."
cancelChoose:	.asciiz"You have choosed cancel."
noData:		.asciiz"You don't input data."
.text


main:
	jal inputInt				# jump and link to inputInt functions
	nop
	jal findMax				# jump and link to findMax
	nop
	jal CalculateNumbersOfElements		# jump and link to CalculateNumbersOfElements
	nop
	jal printArray				#jumo and link to printArray
	nop
	li $v0, 10 				# exit system call
	syscall


#Functions

inputInt: 				 	#user input from keyboard and put the inputted element into array
	
	la $a0,mees1
	li $v0,51   			 	# read the number of elements in the array
	syscall	
	beq $a1,-1,showInputError2	 	#wrong type of data, not integer
	beq $a1,-2,exit			 	#press cancel
	beq $a1,-3,NoData		 	#press enter without input
	add $s1,$a0,$zero 		 	# register $s1 is n or the number of element the user want to input into array(aka the number of elements of the array)
	blt $s1,$0,showInputError		#if user input an negative integer, show error
	
	li $t0,1			 	# i = 1
	la $t3,list			 	# load the address of first element of the array 
loop2:
	bgt $t0,$s1,jumpout 	    	 	#if user has input all the elements, jump 
	la $a0,message
	li $v0, 51				# read integer
	syscall
	beq $a1,-1,showError 			# if user don't input an integer then show error message
	beq $a1,-2,exit				#if user click Cancel,exit 
	beq $a1,-3,NoData2			# if user didn't input anything, show error
	add $s0, $a0, $zero			#store input to s0
	sw $s0, 0($t3) 				# save inputted element into the array or array[i] = a
	addi $t3,$t3,4 				#go to the address of the next element in array
	addi $t0,$t0,1 				#i=i+1
	j loop2

	showError: 				#show error if user input wrong type of element
	la $a0,errmess1 			#load message
	la $a1,errmess2 			#load message
	li $v0,59
	syscall
	j loop2 				# jump back to input the element one more time
	
	showInputError:				#show error when user input an negative integer
	la $a0,inputErr
	la $a1,errmess2
	li $v0,59
	syscall
	j inputInt
	showInputError2:			#show error when user didn't input integer type of element
	la $a0,errmess1			 	#load message
	la $a1,errmess2			 	#load message
	li $v0,59
	syscall
	j inputInt
	
	NoData:					#show error when user input nothing at all when input the number of element of the array
	la $a0,noData
	la $a1,errmess2 			#load message
	li $v0,59
	syscall
	j inputInt
	NoData2:				#show error when user input nothing at all when inputting the value of an element in the array
	la $a0,noData
	la $a1,errmess2 			#load message
	li $v0,59
	syscall
	j loop2
	jumpout:				# when finish the task, jump out the function
	jr $ra					#
	
	exit :
	li $v0, 10 				# exit system call
	syscall
	
	
	
	
CalculateNumbersOfElements:			#Calculate the number of elements that is in the range that user had inputted
inputFirstNumber:				#input the first number of the range
	la $a0,mess3
	li $v0,51 
	syscall
	beq $a1,-1,showInputError3		#if user didn't input integer type of element, show error
	beq $a1,-2,exit1			#if user clicked Cancel,exit
	beq $a1,-3,NoData3			#if user input nothing at all, show error
	add $s2,$a0,$zero 			# the first number of the range or the smaller number : b1
inputSecondNumber:				#input the second number of the range

	la $a0,mess4
	li $v0,51				# read the number of elements in the array
	syscall
	beq $a1,-1,showInputError4		#if user didn't input integer type of element, show error
	beq $a1,-2,exit1			#if user clicked Cancel,exit
	beq $a1,-3,NoData4			#if user input nothing at all, show error
	add $s3,$a0,$zero 			# the second number of the range or the bigger number : b2
	bgt $s2,$s3,showErr2
	li $t0,1				#i=1
	la $t3,list    				#load address of the first element of array into $t3
	li $t1,0				#number of elemnts of integer that is in the range
loop4:
	bgt $t0,$s1,printCalculateNumber 	#check to see if run all the elements of array, if so jump to ...
	lw $t4,0($t3) 				#load the value of element in array
	bgt $t4,$s2,next 			#if current element is bigger than the first number of the range jump to next
	addi $t3,$t3,4 				#go to the address of the next element in array
	addi $t0,$t0,1 				#i=i+1
	j loop4
next:						
	blt $t4,$s3,next2			#if current element if smaller than the second number of the range jump to next2
	addi $t3,$t3,4
	addi $t0,$t0,1
	j loop4
next2:
	addi $t1,$t1,1 				# count = count+1
	addi $t3,$t3,4
	addi $t0,$t0,1
	j loop4

	showErr2:				# show error if the first number of the range is bigger than the second one
	la $a0,errmess3 			#load message
	la $a1,errmess4				#load message
	li $v0,59
	syscall
	j CalculateNumbersOfElements 		# jump back to input the element one more time
	showInputError3:			#show error if user input wrong type of element when input the first number of the range
	la $a0,errmess1				#load message
	la $a1,errmess2 			#load message
	li $v0,59
	syscall
	j inputFirstNumber
	showInputError4:			#show error if user input wrong type of element when input the second number of the range
	la $a0,errmess1 			#load message
	la $a1,errmess2 			#load message
	li $v0,59
	syscall
	j inputSecondNumber
	NoData3:				#show error if user input nothing when input the first number of the range
	la $a0,noData
	la $a1,errmess2 			#load message
	li $v0,59
	syscall
	j inputFirstNumber
	NoData4:				#show error if user input nothing when input the second number of the range
	la $a0,noData
	la $a1,errmess2 			#load message
	li $v0,59
	syscall
	j inputSecondNumber
	exit1:					#exit 
	li $v0, 10 				# exit system call
	syscall
printCalculateNumber:				# print the number of elements that in the range to the screen
	la $a0,mess5
	move $a1,$t1				# move the value of register $t1(count) to register $a1 to print the value on the screen
	li $v0,56
	syscall
	jr $ra


findMax:					#Find the maximum element in the array
 	 la $t3,list				#load address of the first element of array into $t3
 	 li $t0,1 			 	#i=1
 	 lw $t4, 0($t3) 			# get the value from the array cell
  	 add $t5,$t5,$t4			# set max = value of the first element in the array
 loop1:
	bgt $t0,$s1,printMax
	lw $t4, 0($t3) 			 	# get the value from the array cell
	bgt $t4, $t5, Max 		 	# checks for max
	addi $t3, $t3, 4  		 	# increments address
	addi $t0, $t0, 1 		 	# increments count
	j loop1
  Max:						#change the value of max
	add $t5,$t4,0 				#change value of max 
	addi $t3, $t3, 4 			# increments address
	addi $t0, $t0, 1 			# increments count
	j loop1

printMax:					#Print the maximum value to the screen
	la $a0,maxmessage
	move $a1,$t5				# move the value of register $t5(max) to register $a1 to print the value on the screen	
	li $v0,56

	syscall
	jr $ra					
	
	 
	   
printArray: 					#print array
	la $t3, list 				# put address of list into $t3
	li $t0,1 				#i=1

	li $v0,4				#print message "the array:"
	la $a0,mess2
	syscall

loop:
	bgt $t0,$s1,jumpOut
	lw $t4, 0($t3) 				# get the value from the array cell
	li $v0, 1 				# print integer
	move $a0, $t4			        # what to print is stored at $s1
	syscall 				# make system call
	li $v0,4
	la $a0,mess1
	syscall
	addi $t3,$t3,4 				#go to the address of the next element in array
	addi $t0,$t0,1 				#i=i+1
	j loop
jumpOut:					#jump out when finish printing the array
	jr $ra


