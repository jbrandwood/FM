					EXPORT	RS232C_SEND_BUFFER_BEGIN
					EXPORT	RS232C_SEND_BUFFER_SIZE
					EXPORT	RS232C_SEND_ASCIIDUMP_BYTEPERLINE
					EXPORT	RS232C_SEND_ASCII
					EXPORT	RS232C_SEND_BINARY
					EXPORT	RS232C_SEND_CRLF

					EXPORT	RS232C_SEND_WORD_ASCII_DATA
					EXPORT	RS232C_SEND_WORD_ASCII




RS232C_SEND_ASCII_TOASCII
					PSHS	A,B
					TFR		A,B
					LSRA
					LSRA
					LSRA
					LSRA
					ANDB	#$0F

					CMPA	#10
					BGE		RS232C_SEND_ASCII_TOASCII_A_GREATER_THAN9
					ADDA	#'0'
					BRA		RS232C_SEND_ASCII_TOASCII_A_DONE
RS232C_SEND_ASCII_TOASCII_A_GREATER_THAN9
					ADDA	#'A'-10
RS232C_SEND_ASCII_TOASCII_A_DONE
					STA		RS232C_SEND_ASCII_BYTE,PCR

					CMPB	#10
					BGE		RS232C_SEND_ASCII_TOASCII_B_GREATER_THAN9
					ADDB	#'0'
					BRA		RS232C_SEND_ASCII_TOASCII_B_DONE
RS232C_SEND_ASCII_TOASCII_B_GREATER_THAN9
					ADDB	#'A'-10
RS232C_SEND_ASCII_TOASCII_B_DONE
					STB		RS232C_SEND_ASCII_BYTE+1,PCR
					PULS A,B,PC



RS232C_SEND_BUFFER_BEGIN	FDB		$6F00
RS232C_SEND_BUFFER_SIZE		FDB		$0100
RS232C_SEND_ASCIIDUMP_BYTEPERLINE	FCB	16

RS232C_SEND_ASCII_BYTE		FDB		0

RS232C_SEND_ASCII	PSHS	A,B,X,Y,CC

					ORCC	#$50
					STA		$FD0F

					LDX		RS232C_SEND_BUFFER_BEGIN,PCR
					LDB		RS232C_SEND_ASCIIDUMP_BYTEPERLINE,PCR
					LDY		RS232C_SEND_BUFFER_SIZE,PCR
					BEQ		RS232C_SEND_ASCII_EXIT	; Nothing to transmit?

RS232C_SEND_ASCII_LOOP
					LDA		$FD04
					ANDA	#2
					BEQ		RS232C_SEND_ASCII_EXIT					; Break key?

					LDA		,X+
					BSR		RS232C_SEND_ASCII_TOASCII

					LDA		RS232C_SEND_ASCII_BYTE,PCR
					BSR		RS232C_SEND_ONEBYTE
					LDA		RS232C_SEND_ASCII_BYTE+1,PCR
					BSR		RS232C_SEND_ONEBYTE

					DECB
					BNE		RS232C_SEND_ASCII_LINEBREAKCHECKED

					BSR		RS232C_SEND_CRLF
					LDB		RS232C_SEND_ASCIIDUMP_BYTEPERLINE,PCR

RS232C_SEND_ASCII_LINEBREAKCHECKED

					LEAY	-1,Y
					BNE		RS232C_SEND_ASCII_LOOP

					CMPB	RS232C_SEND_ASCIIDUMP_BYTEPERLINE,PCR
					BEQ		RS232C_SEND_ASCII_EXIT

					BSR		RS232C_SEND_CRLF

RS232C_SEND_ASCII_EXIT
					LDA		$FD0F
					PULS	A,B,X,Y,CC,PC



RS232C_SEND_BINARY	PSHS	A,B,X,Y,CC

					ORCC	#$50
					STA		$FD0F

					LDX		RS232C_SEND_BUFFER_BEGIN,PCR
					LDY		RS232C_SEND_BUFFER_SIZE,PCR
					BEQ		RS232C_SEND_BINARY_EXIT		; Nothing to transmit?

RS232C_SEND_BINARY_LOOP
					LDA		$FD04
					ANDA	#2
					BEQ		RS232C_SEND_BINARY_EXIT					; Break key?

					LDA		,X+
					BSR		RS232C_SEND_ONEBYTE

					LEAY	-1,Y
					BNE		RS232C_SEND_BINARY_LOOP


RS232C_SEND_BINARY_EXIT
					LDA		$FD0F
					PULS	A,B,X,Y,CC,PC


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RS232C_SEND_ONEBYTE
					PSHS	A,B,U

					LDU		RS232C_IO,PCR

RS232C_SEND_ONEBYTE_WAITREADY
					LDB		$FD04
					ANDB	#2
					BEQ		RS232C_SEND_ONEBYTE_EXIT

					LDB		1,U
					ANDB	#1
					BEQ		RS232C_SEND_ONEBYTE_WAITREADY

					STA		,U

RS232C_SEND_ONEBYTE_EXIT
					PULS	A,B,U,PC



RS232C_SEND_CRLF
					PSHS	A,CC

					ORCC	#$50

					LDA		#$0D
					BSR		RS232C_SEND_ONEBYTE
					LDA		#$0A
					BSR		RS232C_SEND_ONEBYTE

					PULS	A,CC,PC




RS232C_SEND_WORD_ASCII_DATA	FDB	0

RS232C_SEND_WORD_ASCII	
					PSHS	A,CC
					ORCC	#$50

					LDA		RS232C_SEND_WORD_ASCII_DATA,PCR
					LBSR	RS232C_SEND_ASCII_TOASCII

					LDA		RS232C_SEND_ASCII_BYTE,PCR
					BSR		RS232C_SEND_ONEBYTE
					LDA		RS232C_SEND_ASCII_BYTE+1,PCR
					BSR		RS232C_SEND_ONEBYTE

					LDA		RS232C_SEND_WORD_ASCII_DATA+1,PCR
					LBSR	RS232C_SEND_ASCII_TOASCII

					LDA		RS232C_SEND_ASCII_BYTE,PCR
					BSR		RS232C_SEND_ONEBYTE
					LDA		RS232C_SEND_ASCII_BYTE+1,PCR
					BSR		RS232C_SEND_ONEBYTE

					PULS	A,CC,PC
