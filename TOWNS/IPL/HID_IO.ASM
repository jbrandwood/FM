WAIT_BUTTON_RELEASE		PROC

						PUSH	AX
						PUSH	DX

@@:
						MOV		AL,3FH
						MOV		DX,IO_PAD_OUT
						OUT		DX,AL

						MOV		DX,IO_PADA_IN
						IN		AL,DX
						AND		AL,30H
						CMP		AL,30H
						JNE		@b

						MOV		DX,IO_PADB_IN
						IN		AL,DX
						AND		AL,30H
						CMP		AL,30H
						JNE		@b

						POP		DX
						POP		AX
						RET

WAIT_BUTTON_RELEASE		ENDP



WAIT_BUTTON_PRESS		PROC

						PUSH	AX
						PUSH	DX

@@:
						MOV		AL,3FH
						MOV		DX,IO_PAD_OUT
						OUT		DX,AL

						MOV		DX,IO_PADA_IN
						IN		AL,DX
						AND		AL,30H
						CMP		AL,30H
						JNE		@f

						MOV		DX,IO_PADB_IN
						IN		AL,DX
						AND		AL,30H
						CMP		AL,30H
						JE		@b

@@:
						POP		DX
						POP		AX
						RET
WAIT_BUTTON_PRESS		ENDP



WAIT_PADA_RELEASE		PROC

						PUSH	AX
						PUSH	DX

@@:
						MOV		AL,3FH
						MOV		DX,IO_PAD_OUT
						OUT		DX,AL

						MOV		DX,IO_PADA_IN
						IN		AL,DX
						AND		AL,3FH
						CMP		AL,3FH
						JNE		@b

						POP		DX
						POP		AX
						RET

WAIT_PADA_RELEASE		ENDP



READ_PADA				PROC

						PUSH	DX

						MOV		AL,3FH
						MOV		DX,IO_PAD_OUT
						OUT		DX,AL

						MOV		DX,IO_PADA_IN
						IN		AL,DX
						AND		AL,3FH

						POP		DX
						RET

READ_PADA				ENDP