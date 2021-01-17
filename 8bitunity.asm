
	processor 6502
	seg.u ZEROPAGE	; uninitialized zero-page variables
	org $0

_hiresLinesHI = $00
_hiresLinesLO = $01


hiresXZP = $ec
hiresYZP = $ed
hiresAddrZP = $fc
inputAddrZP = $fa
outputAddrZP = $ee
scr2outRowsZP = $ce
inp2scrRowsZP = $eb
bytesPerRowZP = $e3
toggleMainAuxZP = $42

	seg CODE
	org $803	; starting address

Start
	jmp Start	; endless loop
        
        
        
        ldx #0
loopRow:
	; Copy Screen Address from Hires Tables (using Line Offset Y and Byte Offset X)
	ldy hiresYZP			; Y-Offset to Hires Line
	lda _hiresLinesHI,y
	sta loopCopy1+2			; LDA $HIlo,Y  -- SMC -- +2 cycle
        sta loopCopy2+5			; STA $HIlo,Y  -- SMC -- +5 cycles
	lda _hiresLinesLO,y
	adc hiresXZP			; X-Offset to Hires Byte
	sta loopCopy1+1			; LDA $hiLO,Y  -- SMC -- +2 cycle
        sta loopCopy2+8			; STA $hiLO,Y  -- SMC -- +5 cycles
	
	; Copy bytes from SHR buffer to ouput	
screen2output:
	lda outputAddrZP+1
	beq input2screen  ; If high-byte is zero, then skip
	ldy #0				; Y loop: Copy xxx bytes per row
loopCopy1:				; Copy 1 byte
	lda $2000,y			; SMC: -1 cycle /byteperrow / line 
	sta (outputAddrZP),y
	iny					
	cpy bytesPerRowZP
	bne loopCopy1			; Iterate Y loop
	
	; Copy bytes from input to SHR buffer
	cpx inp2scrRowsZP		; Check number of input rows (for cropped sprites)
	bcs incAddress1
input2screen:	
	clc
	lda inputAddrZP+1
	beq incAddress1   ; If high-byte is zero, then skip	
	ldy #0				; Y loop: Copy xxx bytes per row
loopCopy2:
	lda (inputAddrZP),y		; Copy 1 byte
	sta $2000,y			; SMC: -1 cycle / byteperrow / line
	iny					
	cpy bytesPerRowZP		; Iterate Y loop
	bne loopCopy2
		
incAddress1:
	clc				; Increment address of output block
	lda outputAddrZP			
	adc bytesPerRowZP	; Move by xxx bytes
	sta outputAddrZP	
	bcc nocarry1		; Check if carry to high-byte
	inc outputAddrZP+1
nocarry1:
	
incAddress2:
	clc				; Increment address of input block
	lda inputAddrZP			
	adc bytesPerRowZP	; Move by xxx bytes
	sta inputAddrZP	
	bcc nocarry2		; Check if carry to high byte
	inc inputAddrZP+1
nocarry2:

nextRow:
	; Move to next row
	inc hiresYZP		; Increment Hires Line offset
	inx				
	cpx scr2outRowsZP
	bcc loopRow		; Iterate X loop (rows)
	
	rts
