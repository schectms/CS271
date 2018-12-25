TITLE Program_3   (Program_3.asm)

; Shifra Schectman:
; July 29, 2018:
; schectms@oregonstate.edu: 
; CS271:
; Program_3:                 July 29, 2018:
; Calculates  and displays composites up to number propmted by user

INCLUDE Irvine32.inc

upperlimit=400 ;upper limit of 400

.data
introd		BYTE		"Composite Numbers Programmed by Shifra Schectman",0
input		DWORD		?		;number of composites to display
rules1		BYTE		"Enter the number of composite numbers you would like to see.",0
rules2		BYTE		"I will accept orders for up to 400 composites.",0
prompt1		BYTE		"Number of Composites: ",0
goodbye		BYTE		"Results certified by Shifra. Goodbye!",0
valid		DWORD		0 ;flag for data validation
number		DWORD		4
comp		DWORD		?
num_terms	DWORD		1
space		BYTE		"   ",0
more		BYTE		"Would you like to see the next 400 composite numbers? 1.YES 2.NO",0
cont		DWORD		?
EC			BYTE		"Extra Credit: Display more composites, but show them one page at a time.",0

.code

main PROC

	call	intro
	call	getUserData
	call	showComposites
	call	farewell

	exit

main ENDP

;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
intro	PROC

;Display introduction and rules
	mov		edx,OFFSET introd
	call	WriteString
	call	Crlf
	mov		edx,OFFSET rules1
	call	WriteString
	call	Crlf
	mov		edx,OFFSET rules2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET EC
	call	WriteString
	call	Crlf
	ret

intro	ENDP

;Procedure to get values for the number of composites from user
;receives: none
;returns: user input values for global variables input
;preconditions:  none
;registers changed: eax
getUserData	PROC

;get an integer for input
data:
	mov		edx, OFFSET prompt1
	call	WriteString
	call	CrLf
	call	ReadInt
	mov		input, eax
	call	validate
	cmp		valid, 0
	je		data

	ret

getUserData	ENDP

;Procedure to validate input for INPUT variable
;receives: none
;returns: flag which signals validity of imput
;preconditions:  input is in eax
;registers changed: none
validate PROC

;validate the input
	;check the input against the upper limit(400)	
	cmp		eax, upperlimit
	jg		tryAgain
	;check the limit against 0
	cmp		eax, 1
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

;Procedure to show composite numbers
;receives: none
;returns: composite numbers
;preconditions:  none
;registers changed: eax, ecx, edx
showComposites PROC

mov		ecx, input ;initialize loop to input
L1:
;if number is not a composite, move to next number
call	isComposite
cmp		comp,1
jne		nxtnum

;if number is a composite, display
mov		eax, number
call	WriteDec
mov		edx, OFFSET space
call	WriteString
cmp		num_terms, 10
jne		noNewLine
call	Crlf
mov		num_terms, 0

noNewLine:	
inc num_terms

inc		number 

loop L1

;if number isn't composite, increment number and ecx
nxtnum:
inc		number
inc		ecx


loop L1

;if user chooses to continue displaying composites, continue more
mov		edx,OFFSET more
call	WriteString
call	ReadInt
mov		cont, eax
mov		ecx,400
cmp		cont,1
je		L1



endLoop:
ret
showComposites ENDP

;Procedure to check if a number is composite
;receives: none
;returns: flag which signals if number is composite
;preconditions:  none
;registers changed: eax, ebx, edx
isComposite PROC

;skip numbers 5 and 7 as they are prime
cmp		number, 5
je		false1
cmp		number, 7
je		false1

;divide number by 2 until the number itself to det if it has any multiples
mov		ebx,2
divide:
mov		edx, 00000000 ;clear edx
mov		eax, number
div		ebx
cmp		edx, 0
;if no remainder, skip to next
je		next
;otherwise increase the number being divided by
inc		ebx
cmp		ebx, number
je		false1 ;jump to false if no prime

jmp divide

;if prime, set comp to 0
false1:
mov comp,0
ret

;if composite, set comp to 1
next:
mov comp, 1
ret

iscomposite ENDP

;Procedure to exit the program.
;receives: none
;returns: none
;preconditions:  none
;registers changed: edx
farewell	PROC

;Display introduction and rules
	mov		edx,OFFSET goodbye
	call	WriteString
	call	Crlf

	ret

farewell	ENDP

END main
