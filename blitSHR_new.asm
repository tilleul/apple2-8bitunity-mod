


hiresXZP 		equ $ec		; hires X offset (xcol)
hiresYZP 		equ $ed		; hires Y offset (yrow)
hiresAddrZP 		equ $fc		; 16 bit address of hires line (from LUT)
inputAddrZP 		equ $fa		; 16 bit input address	(bitmap to draw)
outputAddrZP 		equ $ee		; 16 bit output address (buffer to save)
scr2outRowsZP 		equ $ce		; number of rows (output) (height)
inp2scrRowsZP 		equ $eb		; number of rows (input) (height)
bytesPerRowZP 		equ $e3		; bytes per row	(width)
toggleMainAuxZP 	equ $42		; not used here

ycounter		equ $08
xcounter		equ $09

               
                
blitSHR_I	subroutine

ycounter		equ $08
xcounter		equ $09

		; input 2 screen (no output)
                ; 2372 + 11 = 2383 (= -19% ! vs 2942)

		ldy hiresYZP		; +3	ypos
                lda inp2scrRowsZP	; +3	height
                sta ycounter		; +3
                clc			; +2
                			; = 11
                
.nextline	lda hiresLinesHI,y	; +4
                sta .inp2scr+2		; +4
                lda hiresLinesLO,y	; +4
                sta .inp2scr+1		; +4
                			; = 16

		lda bytesPerRowZP	; +3 	width
                sta xcounter		; +3
                ldx hiresXZP		; +3	xpos	
                			; = 9

inp_addr2   	lda $1000,x		; +(4|)5
.inp2scr	sta $2000,x		; +5
.cont		inx			; +2
		dec xcounter		; +6
                bne inp_addr2		; +(2|)3
                			; xloop = 5 + 5 + 2 + 6 + 3 = 21 x width = 63
                
                iny			; +2
                lda inp_addr2+1		; +4
                adc bytesPerRowZP	; +3
                sta inp_addr2+1		; +4
                bcc .dec_ycounter	; +(2|)3
                			; = 2 + 4 + 3 + 4 + (3 or +2+6+2) = 16
                
                inc inp_addr2+2		; +6
                clc			; +2
                
                			
                
.dec_ycounter   dec ycounter		; +6
                bne .nextline		; +(2)|3
                			; = 9
                
					; yloop = (16 + 9 + 63 + 16 + 9)*21 - 1 = 2373 - 1 = 2372

		rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

blitSHR_IO	subroutine

		; screen 2 output AND
		; input 2 screen 
                
                ; 3401 + 11 = 3412 vs 4097 = -17%


ycounter		equ $08
xcounter		equ $09


		ldy hiresYZP		; +3	ypos
                lda inp2scrRowsZP	; +3	height
                sta ycounter		; +3
                clc			; +2
                			; = 11
                
.nextline	lda hiresLinesHI,y	; +4
                sta .inp2scr+2		; +4
                sta .scr_addr+2		; +4
                lda hiresLinesLO,y	; +4
                sta .inp2scr+1		; +4
                sta .scr_addr+1		; +4
                			; =24

		lda bytesPerRowZP	; +3 	width
                sta xcounter		; +3
                ldx hiresXZP		; +3	xpos	
					; = 9
                
.nextbyte       
.scr_addr	lda $2000,x             ; +4
out_addr3	sta $1000,x		; +5(|4)

inp_addr3   	lda $1000,x		; +5(|4)
.inp2scr	sta $2000,x		; +5
		
                inx			; +2                        
		dec xcounter		; +6
                bne .nextbyte		; +(2|)3
                			; xloop = 4+5+5+5+2+6+3 = 30 x width = 90 - 1
                
                iny			; +2
                lda inp_addr3+1 	; +4
                adc bytesPerRowZP	; +3
                sta inp_addr3+1		; +4
                bcc .inc_outp_addr	; +(2|)3
                			; = 2 + 4 + 3 + 4 + (3 or +2+6+2) = 16
                
                inc inp_addr3+2		; +6
                clc			; +2
                

.inc_outp_addr	lda out_addr3+1		; +4
		adc bytesPerRowZP	; +3
                sta out_addr3+1		; +4
                bcc .dec_ycounter	; +(2|)3
                			; = 4 + 3 + 4 + (3 or +2+6+2) = 14
                                        
                inc out_addr3+2		; +6
                clc			; +2

                
.dec_ycounter   dec ycounter		; +6
                bne .nextline		; +(2)|3
                			; = 9
                
					; yloop = (24 + 9 + 90 + 16 + 14 + 9)*21 - 1 = 3402 - 1 = 3401

		rts
                
;;;;;;;;;;;;;;;;;;;;;;;;; test routines

		; test input 2 screen only
                
t_blitSHR_I    subroutine

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


		ldx xcol		; 3		
.loop_mario_x   
		
		stx hiresXZP		; 3
                lda yrow		; 3
                sta hiresYZP		; 3
                			; = 9
                
                sec
                lda #<mario		; 2
                sbc xcol		; 3
                sta inp_addr2+1		; 4
                lda #>mario		; 2
                sbc #0			; 2
                sta inp_addr2+2		; 4
                			; = 13
                


		jsr blitSHR_I		; 2383
               
                
                
		
                ldx xcol
                inx
                stx xcol
                cpx #38
                bcc .loop_mario_x
                
                ldx #0
                stx xcol
                ldy yrow
                iny
                sty yrow
                cpy #172
                bcc .loop_mario_x

.rts		rts


t_blitSHR_IO    subroutine

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


		ldx xcol		; 3	

                
.loop_mario_x   
		stx hiresXZP		; 3
                lda yrow		; 3
                sta hiresYZP		; 3
                			; = 9
                
                sec
                lda #<mario		; 2
                sbc xcol		; 3
                sta inp_addr3+1		; 4
                lda #>mario		; 2
                sbc #0			; 2
                sta inp_addr3+2		; 4
                			; = 13
                
		sec
                lda #<buffer		; 2
                sbc xcol		; 3
                sta out_addr3+1		; 4
                sta inp_addr2+1		; 4
                lda #>buffer		; 2
                sbc #0			; 2
                sta out_addr3+2		; 4
                sta inp_addr2+2		; 4
                			; = 25

		jsr blitSHR_IO		; 3412

		jsr blitSHR_I		; 2320

                
                
		
                ldx xcol
                inx
                stx xcol
                cpx #38
                bcc .loop_mario_x
                
                ldx #0
                stx xcol
                ldy yrow
                iny
                sty yrow
                cpy #172
                bcc .loop_mario_x

.rts		rts

                
                
                
                