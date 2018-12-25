TITLE Prog05A     (prog05a.asm)

; Author: Shifra Schectman
; CS271	PROGRAM 5        8/12/2018
; Description:  This program  gets 10 valid integers 
;from the user and stores the numeric values in an array.  
;The program then displays the integers, their sum, and 
;their average. 

INCLUDE Irvine32.inc

MAXSIZE=100

.data
intro1		BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
intro2		BYTE	"Written by: Shifra Schectman",0
rules		BYTE	"Please provide 10 unsigned decimal integers. Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting the raw numbers I will display a list	of the integers, their sum, and their average value. ",0
inString	BYTE	MAXSIZE DUP(?)		; User's string
outString	BYTE	MAXSIZE DUP(?)		; User's string after converted from numeric
prompt1		BYTE	"Please enter an unsigned number: ",0
listOfNums	DWORD	10 DUP(?)			 ;array of numbers
error		BYTE	"Not a Valid Integer. Try Again", 0
count		DWORD	10					;number of ints to be entered
saveDigit	DWORD	0					;for converting int
space		BYTE "   ",0
summssg		BYTE	"SUM: ",0
avgmssg		BYTE	"AVERAGE: ",0
numberOfDigs DWORD	 0
.code

; ***************************************************************
; MACRO to display a string. 
; receives: address of string to be displayed
; returns: writes string to output
; preconditions: none
; registers changed: edx
; ***************************************************************
mDisplayStr MACRO buffer
push	edx
mov		edx, OFFSET buffer
call	WriteString
call	Crlf
pop		edx
ENDM

; ***************************************************************
; MACRO that prompts user to enter string and stores it in memory
; receives: memory location for string input
; returns: variable containing string, length of string in eax
; preconditions: none
; registers changed: edx, ecx, eax
; ***************************************************************
mGetStr MACRO varName
push	ecx
push	edx
mov		edx, OFFSET prompt1
call	WriteString
call	Crlf
mov		edx, OFFSET varName
mov		ecx, (SIZEOF varName) - 1
call	ReadString 
pop		edx
pop		ecx
ENDM

main PROC
mDisplayStr intro1			;display intro1
mDisplayStr intro2			;display intro2
mDisplayStr rules				;display rules
push	OFFSET listOfNums
push	count
call	fillArray			;fill the array with numbers input by user
push	OFFSET listOfNums
push	count
call	displayList			;print the array 
push	OFFSET listOfNums
push	count
call	sumandAverage		;print the sum of the array and the average

	exit			;exit to operating system

main ENDP

; ***************************************************************
; PROC that validates the user input and converts it to a string
; receives: string input by user, length of string
; returns: value input by user as an integer
; preconditions: none
; registers changed:  eax
; ***************************************************************
readVal PROC
;save registers that will be changed, except eax which is needed
push	ecx
push	edx
push	esi
push	ebx


;calls readStr to get user input
enterNum:
mGetStr inString
mov		edx,OFFSET inString		;move address of inString to edx
mov		esi ,OFFSET inString	;move address of inString to esu
cld


mov		ecx, eax		;sets loop counter to length of string
counter:
	;check each character from string entered to ensure it is numeric
	lodsb
	cmp		al,48	; '0' is character 48
	jb		notNum
	cmp		al,57	; '9' is character 57
	ja		notNum
	loop	counter

; ***************************************************************
; string conversion adapted from "ParseInteger32" function in Irvine32.asm
; ***************************************************************
	mov		esi, edx			;save offset in SI
	mov		eax, 0				;clear accumulator
	mov		ebx,10				;ebx is divisor
				;set loop counter equal to length of string
	L1:
	mov		dl, [esi]			;get character from buffer
	cmp		dl,'0'				;char < '0'
	jb		theEnd				
	cmp		dl,'9'				;char > '9'
	ja		theEnd				
	and		edx, 0fh			;if not convert to binary

	mov		saveDigit,edx
	imul	ebx				;edx:eax=eax*ebx
	mov		edx, saveDigit
		
	jo		notNum               	; quit if overflow
	add		eax,edx            	; add new digit to AX
	inc		esi					;point to next digit
	jmp L1


jmp		theEnd					;skip error message
	
	;if non-numeric input, display error and prompt for new input
	notNum:
	mov		edx, Offset error
	call	WriteString
	jmp		enterNum
	
 theEnd:
 
 pop	ebx
 pop	esi
 pop	edx
 pop	ecx
 ret
readVal ENDP

; ***************************************************************
; PROC to call readVal and fill array with input values
; receives: address of array and value of count on system stack
; returns: first count elements of array contain input values
; preconditions: count is initialized to 10 
; registers changed: ecx, edi
; ***************************************************************
fillArray	PROC

	push	ebp
	mov		ebp,esp
	mov		ecx,[ebp+8]			;count in ecx
	mov		edi,[ebp+12]		;address of array in edi

	cld
again:
	call	 readVal				;get user input for ints of array
	stosd
	loop	again
	pop		ebp
	ret		8

fillArray	ENDP

; ***************************************************************
; PROC to display array
; receives: address of array and value of count on system stack
; returns: first count elements of array
; preconditions: count is initialized to 10 
;                and the first count elements of array initialized
; registers changed: edx, ebx, edx, esi
; ***************************************************************
displayList PROC

	push	ebp
	mov		ebp,esp
	mov		ecx, [ebp+8]		;count in ecx
	mov		esi,[ebp+12]		;address of array in esi

L2:
	mov		eax,[esi]			;display current term
	call	WriteDec
	
	mov		edx, offset space		;print spaces
	call	 WriteString

	add		esi,4				;increment to next term	

loop l2
	call	crlf
	pop		ebp
	ret		8
displayList	ENDP

; ***************************************************************
; PROC to display sum and average of number
; receives: address of array and value of count 
; returns: sum and average of numbers
; preconditions: count and array initialized
; registers changed: ecx, esi, eax, ebx
; ***************************************************************
sumandAverage PROC

	push	ebp
	mov		ebp,esp
	mov		ecx, [ebp+8]		;count in ecx
	mov		esi,[ebp+12]		;address of array in esi
	mov		eax, 0

L3:
	add		eax,[esi]			;add 2 terms
	add		esi,4			;increment to next term	
loop l3

mDisplayStr summssg			;display sum
call	writeval
mov		edx, 00000000			;clear edx register
mov		ebx, count				;calculate average
div		ebx

mDisplayStr avgmssg			;display average
;call writedec
call	writeval
pop		ebp
ret		8

sumAndAverage	ENDP

; ***************************************************************
; PROC to convert integer to string for display
; receives: int value in eax
; returns: converted string in edx
; preconditions: int in eax
; registers changed: ecx, esi, eax, ebx, edx
; ***************************************************************
writeVal PROC
;save registers
pushad
mov		edi, offset outstring 
            
;start conversion
l5:             
	;divide by 10
    mov		ebx, 10            
    cdq                 
    div		ebx  
	;convert to ascii
    add		edx, 48         
    push    eax            
    mov		eax, edx          
   
	stosb             
   inc		numberofdigs		;keep track of length of number
   pop		eax             
   cmp		eax, 0
   je		endLoop           

    jmp		L5    

	;after finished converting, reverse string
endLoop:
	
	mov		ecx, numberofdigs		;loop for length of string
	mov		esi, 0
	L6: 
	;push values
	movzx	eax, outstring[esi]
	push	eax
	inc		esi 
	loop	l6

	mov		ecx, numberofdigs
	mov		esi, 0
	L7: 
	;pop values
	pop		eax
	mov		outstring[esi],al
	inc		esi
	loop	l7
 
	;write converted and reversed string to ouput
	mDisplayStr outstring

	;clear string for next conversion
	xor		al, al
	mov		edi, offset outstring
	mov		ecx, 100
	cld
	mov		numberofdigs, 0
	rep		stosb
popad
ret
writeVal ENDP 

END Main
