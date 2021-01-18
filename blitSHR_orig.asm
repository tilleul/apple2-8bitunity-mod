

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

blitSHR_orig 	subroutine		; 4095 + 2 = 4097
					; w/o output = 2940 + 2 = 2942
        
        	ldx #0			; +2
; Copy Screen Address from Hires Tables (using Line Offset Y and Byte Offset X)

.loopRow				; loopRow = 20 + 61 + 65 + 18 + 18 + 13 = 195 x height = 195 x 21 = 4095
					; w/o outp= 20+ 3+3 + 65 + 18 + 18 + 13 = 140 x height = 2940
                ldy hiresYZP		; +3	Y-Offset to Hires Line (ytop)
		lda hiresLinesHI,y	; +4
		sta hiresAddrZP+1	; +3

		lda hiresLinesLO,y	; +4
		adc hiresXZP		; +3	X-Offset to Hires Byte (xcol)
		sta hiresAddrZP		; +3
                
; Copy bytes from SHR buffer to ouput	
.screen2output				; =  7 + loopCopy1 + 3 + 2 = 61
		lda outputAddrZP+1	; +3
		beq .input2screen  	; +2(|3) 	If high-byte is zero, then skip
		ldy #0			; +2		Y loop: Copy xxx bytes per row
.loopCopy1				; loopCopy1 = 19 x width - 1 = 19 x 3 - 1 = 56
		lda (hiresAddrZP),y	; +5
		sta (outputAddrZP),y	; +6
		iny			; +2	
		cpy bytesPerRowZP	; +3
		bne .loopCopy1		; +(2|)3 	Iterate Y loop
	
; Copy bytes from input to SHR buffer
		cpx inp2scrRowsZP	; +3		Check number of input rows (for cropped sprites)
		bcs .incAddress1	; +(2|)3
.input2screen				; = 9 + loopCopy2 = 65
		clc			; +2
		lda inputAddrZP+1	; +3
		beq .incAddress1   	; +2(|3)	If high-byte is zero, then skip	
		ldy #0			; +2		Y loop: Copy xxx bytes per row
.loopCopy2				; loopCopy2 = 19 x width - 1 = 19 x 3 - 1 = 56
		lda (inputAddrZP),y	; +5		Copy 1 byte
		sta (hiresAddrZP),y	; +6
		iny			; +2	
		cpy bytesPerRowZP	; +3		Iterate Y loop
		bne .loopCopy2		; +(2|)3
		
.incAddress1				; = 18
		clc			; +2	Increment address of output block
		lda outputAddrZP	; +3		
		adc bytesPerRowZP	; +3	Move by xxx bytes
		sta outputAddrZP	; +3
		bcc .nocarry1		; +2(|3)  Check if carry to high-byte
		inc outputAddrZP+1	; +5
.nocarry1
	
.incAddress2				; = 18
		clc			; +2	Increment address of input block
		lda inputAddrZP		; +3
		adc bytesPerRowZP	; +3	Move by xxx bytes
		sta inputAddrZP		; +3
		bcc .nocarry2		; +2(|3)  Check if carry to high byte
		inc inputAddrZP+1	; +5
.nocarry2

.nextRow
	; Move to next row		; = 13
		inc hiresYZP		; +5	Increment Hires Line offset
		inx			; +2
		cpx scr2outRowsZP	; +3
		bcc .loopRow		; +(2|)3	 Iterate X loop (rows)
	
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
		lda #<buffer		; 2
                sta outputAddrZP	; 3
                lda #>buffer		; 2
                sta outputAddrZP+1	; 3
                			; = 10
                
                lda #<mario		; 2
                sta inputAddrZP		; 3
                lda #>mario		; 2
                sta inputAddrZP+1	; 3
                			; = 10

		lda xcol		; 3
		sta hiresXZP		; 3
                lda yrow		; 3
                sta hiresYZP		; 3
                			; = 12


		jsr blitSHR_orig	; 10 + 10 + 12 + 4097 = 4129
                
                lda #<buffer		; 2
                sta inputAddrZP		; 3
                lda #>buffer		; 2
                sta inputAddrZP+1	; 3
                			; = 10
                
                lda #0			; 2
                sta outputAddrZP+1	; 3
                			; = 5
                
                lda xcol		; 3
		sta hiresXZP		; 3
                lda yrow		; 3
                sta hiresYZP		; 3
                			; = 12

		clc			; +2      needed because not in routine !
                			
		jsr blitSHR_orig	; 10 + 5 + 12 + 2 + 2942 = 2971
                
                			; 2971 + 4129 = 7100
		
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
                cpx #172
                bcc .loop_mario_x

.rts		rts
                
                
                
                
                