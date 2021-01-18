

hiresXZP 		equ $ec		; hires X offset (xcol)
hiresYZP 		equ $ed		; hires Y offset (yrow)
hiresAddrZP 		equ $fc		; 16 bit address of hires line (from LUT)
inputAddrZP 		equ $fa		; 16 bit input address	(bitmap to draw)
outputAddrZP 		equ $ee		; 16 bit output address (buffer to save)
scr2outRowsZP 		equ $ce		; number of rows (output) (height)
inp2scrRowsZP 		equ $eb		; number of rows (input) (height)
bytesPerRowZP 		equ $e3		; bytes per row	(width)
toggleMainAuxZP 	equ $42		; not used here


;; blitSHR original code

blitSHR_orig 	subroutine
        
        	ldx #0
; Copy Screen Address from Hires Tables (using Line Offset Y and Byte Offset X)
.loopRow	
                ldy hiresYZP		; Y-Offset to Hires Line (ytop)
		lda hiresLinesHI,y
		sta hiresAddrZP+1

		lda hiresLinesLO,y
		adc hiresXZP		; X-Offset to Hires Byte (xcol)
		sta hiresAddrZP
                
; Copy bytes from SHR buffer to ouput	
.screen2output
		lda outputAddrZP+1
		beq .input2screen  	; If high-byte is zero, then skip
		ldy #0			; Y loop: Copy xxx bytes per row
.loopCopy1				; Copy 1 byte
		lda (hiresAddrZP),y	
		sta (outputAddrZP),y
		iny					
		cpy bytesPerRowZP
		bne .loopCopy1		; Iterate Y loop
	
; Copy bytes from input to SHR buffer
		cpx inp2scrRowsZP	; Check number of input rows (for cropped sprites)
		bcs .incAddress1
.input2screen
		clc
		lda inputAddrZP+1
		beq .incAddress1   	; If high-byte is zero, then skip	
		ldy #0			; Y loop: Copy xxx bytes per row
.loopCopy2
		lda (inputAddrZP),y	; Copy 1 byte
		sta (hiresAddrZP),y		
		iny					
		cpy bytesPerRowZP	; Iterate Y loop
		bne .loopCopy2
		
.incAddress1
		clc			; Increment address of output block
		lda outputAddrZP			
		adc bytesPerRowZP	; Move by xxx bytes
		sta outputAddrZP	
		bcc .nocarry1		; Check if carry to high-byte
		inc outputAddrZP+1
.nocarry1
	
.incAddress2
		clc			; Increment address of input block
		lda inputAddrZP			
		adc bytesPerRowZP	; Move by xxx bytes
		sta inputAddrZP	
		bcc .nocarry2		; Check if carry to high byte
		inc inputAddrZP+1
.nocarry2

.nextRow
	; Move to next row
		inc hiresYZP		; Increment Hires Line offset
		inx				
		cpx scr2outRowsZP
		bcc .loopRow		; Iterate X loop (rows)
	
		rts
                
                
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                
                
test_blitSHR_orig subroutine

xcol		equ $06
yrow		equ $07

		lda #0
                sta xcol
                sta yrow
                
		lda #3
                sta bytesPerRowZP	; width
                
                lda #21			; height
                sta inp2scrRowsZP
                sta scr2outRowsZP


		clc			; needed because not in routine !
.loop_mario_x   
		lda #<buffer
                sta outputAddrZP
                lda #>buffer
                sta outputAddrZP+1
                
                lda #<mario
                sta inputAddrZP
                lda #>mario
                sta inputAddrZP+1

		lda xcol
		sta hiresXZP
                lda yrow
                sta hiresYZP


		jsr blitSHR_orig
                
                lda #<buffer
                sta inputAddrZP
                lda #>buffer
                sta inputAddrZP+1
                
                lda #0
                sta outputAddrZP+1
                
                lda xcol
		sta hiresXZP
                lda yrow
                sta hiresYZP

		clc			; needed because not in routine !
		jsr blitSHR_orig
                
		
                ldx xcol
                inx
                stx xcol
                cpx #38
                bcc .loop_mario_x
                
                ldx #0
                stx xcol
                ldx yrow
                inx
                stx yrow
                cpx #191-21
                bcc .loop_mario_x

.rts		rts
                
                
                
                
                