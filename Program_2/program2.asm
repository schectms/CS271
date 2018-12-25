TITLE Program_2     (Program_2.asm)

; Shifra Schectman:
; July 9, 2018:
; schectms@oregonstate.edu: 
; CS271:
; Program_2:                 July 15, 2018:
; Returns fibonacci numbers up to number input by user:

INCLUDE Irvine32.inc

upperLimit=46

.data

intro_1		BYTE	"Fibonacci Numbers Programmed by Shifra Schectman",0
prompt_1	BYTE	"What is your name?",0
hello		BYTE	"Hello, ",0
intro_2		BYTE	"Enter the number of Fibonacci terms to be displayed: ",0
intro_3		BYTE	"Give the number as an integer in the range [1 .. 46]",0
prompt_2	BYTE	"How many Fibonacci terms do you want? ",0
prompt_3	BYTE	"Invalid input. Please enter an integer between 1 and 46.",0
userName	BYTE	33 DUP(0)
input		DWORD	?
current		DWORD	?
prev		DWORD	?
num_terms	DWORD	1
goodbye_1	BYTE	"Results certified by Shifra Schectman.",0
goodbye_2	BYTE	"Goodbye,  ",0
space		BYTE	"     ",0
.code
main PROC


;display intro message
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf

;prompt user to enter name
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx,32
	call	ReadString
	
;say hello to user
	mov		edx, OFFSET hello
	Call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	;display prompts
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	CrLf
	call	ReadInt
	mov		input, eax

	;validate the input
inputInvalid:
	;check the input against the upper limit(46)	
	mov		ebx,upperLimit
	cmp		ebx,eax
	jae		inputOK
	;check the limit against 0
	cmp		ebx,1
	jl	inputOK

		
	;if the input is invalid, reprompt	
		tryAgain:
		mov		edx, OFFSET prompt_3
		call	WriteString
		call	CrLf
		call	ReadInt
		mov		input, eax
		jmp		inputInvalid

	;when input is valid
	inputOK:
	
	;initalize values in eax and ebx and display first fibonacci number
	mov		eax, 1
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	mov		ebx,0
	mov		eax,1
	cmp		input,1
	
	;when input is one, skip loop
	je		one
	
	;initialize loop for remaining terms
	mov		ecx, input
	dec		ecx

	L1:
	;add current and previous terms
	mov		current, eax 
	mov		prev,ebx
    add		eax, ebx
	;set previous term
	mov		prev,ebx
	;move result to current term
	mov		ebx,current
	;display value
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	;keep track of terms displayed, so 5 on a line
	inc		num_terms
	cmp		num_terms,5
	jne		noNewLine
		;only called after each fifth term, skip line and reset count
		call	Crlf
		mov		num_terms, 0
	noNewLine:
	loop	L1
	;print space
	call	CrlF
			
	;skip to when input is one
	one:
	call	Crlf

	;display exit message
	mov		edx, OFFSET goodbye_1
	call	WriteString
	call	CrLf

	;say goodbye to user
	mov		edx, OFFSET goodbye_2
	Call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
		
		exit	; exit to operating system

main ENDP


END main

