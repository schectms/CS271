TITLE Program_4    (program4.asm)

; Author: Shifra Schectman
; CS271		        08/05/2018
; Description:  This program asks the user how many random integers to 
;place into an array so they can be displayed in order. It also calcualtes
;and displays the median of the array.

; Implementation note: Parameters are passed on the system stack.

INCLUDE Irvine32.inc

MAXSIZE	= 200
MINSIZE	= 10

LOWERLIMIT=10
UPPERLIMIT=200

.data
introd		BYTE		"Sorting Random Numbers Programmed by Shifra Schectman",0
descr		BYTE		"This program generates random numbers in the range [100 .. 999], displays the original list, sorts the list, and calculates the median value.",0 
descr2		BYTE		"Finally, it displays the list sorted in descending order.",0
valid		DWORD		0							;flag for data validation
listOfNums	DWORD		MAXSIZE DUP(?)
count		DWORD		?	
prompt1		BYTE		"How many numbers should be generated? [10 .. 200]:  ",0
unsorted	BYTE		"The Unsorted Random Numbers Are: ",0
sorted		BYTE		"The Sorted Random Numbers Are: ",0
median		BYTE		"The median is ",0
num_terms	DWORD		1
space		BYTE		"     ",0

.code
main PROC

	call	intro
	push	OFFSET count
	call	getData			;Get the user's number
	push	OFFSET listOfNums
	push	count
	call	fillArray			;Put that many random numbers into the array
	call	unsortedMssg		
	push	OFFSET listOfNums
	push	count
	call	displayList	;Print the array 
	call	sortedMssg
	push	OFFSET listOfNums	
	push	count
	call	sortList			;sort the array
	push	OFFSET listOfNums
	push	count
	call	displayList	
	push	OFFSET listOfNums	
	push	count
	call	displayMedian

	exit			;exit to operating system

main ENDP

; ***************************************************************
;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
; ***************************************************************
intro	PROC

;Display introduction and description of program
	mov		edx,OFFSET introd
	call	WriteString
	call	Crlf
	mov		edx,OFFSET descr
	call	WriteString
	call	Crlf
	mov		edx,OFFSET descr2
	call	WriteString
	call	Crlf
	ret

intro	ENDP

; ***************************************************************
; Procedure to get the user's input. 
; receives: address of count on system stack
; returns: user input in global count
; preconditions: none
; registers changed: eax, ebx, edx
; ***************************************************************
getData	PROC
data:
	push	ebp
	mov		ebp,esp
	mov		edx,OFFSET prompt1
	call	WriteString		;prompt user
	call	ReadInt			;get user's number
	mov		ebx,[ebp+8]		;address of count in ebx
	mov		[ebx],eax		;store in global variable
	pop		ebp
	call	validate
	cmp		valid, 0
	je		data

	ret	4
	
getData	ENDP


; ***************************************************************
; Procedure to generate random numbers and put them into the array.
; receives: address of array and value of count on system stack
; returns: first count elements of array contain consecutive squares
; preconditions: count is initialized, 10 <= count <= 200
; registers changed: eax, ebx, ecx, edi
; ***************************************************************
fillArray	PROC

	push	ebp
	mov		ebp,esp
	mov		ecx,[ebp+8]			;count in ecx
	mov		edi,[ebp+12]		;address of array in edi
	
	mov		ebx,0
	call	randomize			;seed random

again:
	
	mov		eax, 1000			;set range for numbers
	sub		eax, 100
	inc		eax
	call	randomrange			;generate random numbers
	add		eax, 100
	mov		[edi],eax
	add		edi,4
	inc		ebx
	loop	again
	
	pop		ebp
	ret		8

fillArray	ENDP

; ***************************************************************
; Procedure to sort the array in descending order
; receives: address of array and value of count on system stack
; returns: first count elements of array contain sorted numbers
; preconditions: count is initialized, 10 <= count <= 200
; registers changed: eax, ecx, esi
; ***************************************************************
sortList proc

mov		esi, offset listOfNums

mov		ecx, count
dec		ecx							;decrement count by 1

L2:
	push	ecx						;save outer loop count	
	mov		esi, offset listOfNums	;point to first value

L3:
	mov		eax,[esi]				;get array value
	cmp		[esi+4], eax			;compare a pair of values
	jl		 L4						;if [esi]<=[esi+4], no exchange
	call exchange
	
L4:
	add		esi, 4					;move both pointers forward
	loop	L3						;inner loop
	pop		ecx						;retreive outer loop cpunt
	loop	L2
L5:
ret 4

sortList endp

; ***************************************************************
;Procedure to exchange elements in array
;receives: elements to exchange
;returns: exchanged elements
;preconditions:  none
;registers changed: eax, esi
; ***************************************************************
exchange PROC
	xchg	eax, [esi+4]
	mov		[esi], eax
	ret
exchange ENDP

; ***************************************************************
;Procedure to display unsorted message
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
; ***************************************************************
unsortedmssg PROC
	mov		edx,OFFSET unsorted
	call	WriteString
	call	crlf
	mov		edx,00000000
	ret
unsortedmssg ENDP

; ***************************************************************
;Procedure to display sorted message
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
; ***************************************************************
sortedmssg PROC
	mov		edx,OFFSET sorted
	call	WriteString
	call	crlf
	mov		 edx,00000000
	ret
sortedmssg ENDP

; ***************************************************************
; Procedure to display array
; receives: address of array and value of count on system stack
; returns: first count elements of array
; preconditions: count is initialized, 10 <= count <= 200
;                and the first count elements of array initialized
; registers changed: eax, ebx, edx, esi
; ***************************************************************

displayList PROC

	push	ebp
	mov		ebp,esp
	mov		ecx, [ebp+8]		;count in ecx
	mov		esi,[ebp+12]		;address of array in esi

L2:
	mov		eax,[esi]			;display current term
	call	WriteDec
	
	mov edx, offset space		;print spaces
	call WriteString

	add		esi,4				;increment to next term

	;if 10 terms have been displayed, skip line
	cmp		num_terms, 10
	jne		noNewLine
	call	Crlf
	mov		num_terms, 0

	;otherwise increment number of terms
	noNewLine:	
	inc num_terms		

	

loop l2
	call crlf
	pop		ebp
	mov		num_terms,1
	ret		8
displayList	ENDP

; ***************************************************************
; Procedure to calculate median of array
; receives: address of array and value of count on system stack
; returns: median of array
; preconditions: array is sorted
; registers changed: edx, esi, edi, eax, ebx
; ***************************************************************
displayMedian PROC

mov		edx,00000000				;clear edx
mov		esi, offset listOfNums
mov		edi, esi
mov		eax, count					;move count to eax
mov		ebx,2						
div		ebx							;divide length of array(count) by 2
cmp		edx, 0						;check if there is a remainder
je		evenNum						;if the number is even
mov		eax, [esi + (eax*4)]		;otherwise move the middle number into eax
mov		edx, offset median			;display median mssg
call	WriteString
call	WriteDec
call	CrlF
ret

evenNum:							;if even number
mov		ebx, [esi + (eax*4)]		;move uper middle to ebx
dec		eax							
mov		eax,[esi + (eax*4)]			;move lower middle to eax
add		eax, ebx
mov		ebx, 2
div		ebx

mov edx, offset median
call WriteString
call WriteDec
call crlf
ret

displayMedian ENDP

; ***************************************************************
;Procedure to validate input for INPUT variable
;receives: none
;returns: flag which signals validity of imput
;preconditions:  input is in eax
;registers changed: none
; ***************************************************************
validate PROC

;validate the input
	;check the input against the upper limit(400)	
	cmp		eax, upperlimit
	jg		tryAgain
	;check the limit against 0
	cmp		eax, lowerlimit
	jl		tryAgain
	jmp		inputOk

	;if the input is invalid, set valid to 0 and return	
	tryAgain:
		mov	valid,0
		ret

	;when input is valid, set valid to 1 and return
	inputOK:
	mov valid,1

	ret

validate ENDP

END main
