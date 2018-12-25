TITLE Program_1     (Program_1.asm)

; Shifra Schectman:
; July 3, 2018:
; schectms@oregonstate.edu: 
; CS271:
; Program_1:                 July 8, 2018:
; Calculates the sum, difference, product and quotient of 2 numbers:

INCLUDE Irvine32.inc

.data

number_1	DWORD	?
number_2	DWORD	?
remainder	DWORD	0
sum			DWORD	0
dif			DWORD	0
prod		DWORD	0
quotient	DWORD	0
intro_1		BYTE	"Elementary Arithmetic by Shifra T. Schectman",0
intro_2		BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient and remainder.",0
prompt_1	BYTE	"First number: ",0
prompt_2	BYTE	"Second number: ",0
goodbye		BYTE	"Impressed? Bye! ",0
s			BYTE	"SUM: ",0
d			BYTE	"DIFFERENCE: ",0
p			BYTE	"PRODUCT: ",0
q			BYTE	"QUOTIENT: ",0
r			BYTE	"REMAINDER: ",0

.code
main PROC

;display intro messages
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf

;prompt user to input first number
	mov		edx, OFFSET prompt_1
	call	WriteString
	call 	ReadInt
	mov 	number_1, eax
	
;prompt user to input second number
	mov		edx, OFFSET prompt_2
	call	WriteString
	call 	ReadInt
	mov 	number_2, eax

;add 2 numbers and display sum
	mov		eax, number_1
	add		eax, number_2
	mov		sum, eax
	mov		edx, OFFSET s
	call	WriteString
	mov		edx, OFFSET sum
	call	WriteDec
	call	CrLf

;subtract 2 numbers and display difference
	mov		eax, number_1
	sub		eax, number_2
	mov		dif, eax
	mov		edx, OFFSET d
	call	WriteString
	mov		edx, OFFSET dif
	call	WriteDec
	call	CrLf

;multiply 2 numbers and display product
	mov		eax, number_1
	mul		number_2
	mov		prod,eax
	mov		edx, OFFSET p
	call	WriteString
	mov		edx, OFFSET prod
	call	WriteDec
	call	CrLf

;divide 2 numbers and display quotient and remainder
	mov		eax, number_1
	cdq
	mov		ebx, number_2
	div		ebx
	mov		quotient,eax
	mov		remainder,edx
	mov		edx, OFFSET q
	call	WriteString
	mov		edx, OFFSET quotient
	call	WriteDec
	call	CrLf
	mov		edx, OFFSET r
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLf

;say goodbye
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf
	
	exit	; exit to operating system
main ENDP

END main
