

;draw_bmp	subroutine
;		ldy ypos
;                lda height
;                sta ycounter
;.nextline	lda ytableh,y
;                sta draw_bmp_eor+2
;                sta .draw_sta+2
;                lda ytablel,y
;                sta draw_bmp_eor+1
;                sta .draw_sta+1
;                lda width
;                sta xcounter
;                ldx xpos
;draw_byteaddr   lda $1000
;		cpx #$28
;                bcs .incxl
;                cpy #$bf
;                bcs .incxl
;draw_bmp_eor	sta $2000,x
;.draw_sta	sta $2000,x
;.incxl		inc draw_byteaddr+1
;		bne .cont
;                inc draw_byteaddr+2
;.cont		inx
;		dec xcounter
;                bne draw_byteaddr
;                iny
;                dec ycounter
;                bne .nextline
;                stx xpos
;		rts

        
clear_hgr1	subroutine

		lda #$20
        	sta .base_addr+2
        	ldy #$1F
        	lda #$00
        	sta .base_addr+1
.loop          	ldx #$00   
.base_addr   	sta $2000,x
        	inx
        	bne .base_addr
        	inc .base_addr+2
        	dey
        	bpl .loop
        	rts
        
        
hiresLinesHI	
		hex     2024282C3034383C
        	hex     2024282C3034383C
        	hex     2125292D3135393D
        	hex     2125292D3135393D
        	hex     22262A2E32363A3E
        	hex     22262A2E32363A3E
        	hex     23272B2F33373B3F
        	hex     23272B2F33373B3F
        	hex     2024282C3034383C
        	hex     2024282C3034383C
        	hex     2125292D3135393D
        	hex     2125292D3135393D
        	hex     22262A2E32363A3E
        	hex     22262A2E32363A3E
        	hex     23272B2F33373B3F
        	hex     23272B2F33373B3F
        	hex     2024282C3034383C
        	hex     2024282C3034383C
        	hex     2125292D3135393D
        	hex     2125292D3135393D
        	hex     22262A2E32363A3E
        	hex     22262A2E32363A3E
        	hex     23272B2F33373B3F
        	hex     23272B2F33373B3F
        
hiresLinesLO
		hex     0000000000000000
                hex     8080808080808080
                hex     0000000000000000
                hex     8080808080808080
                hex     0000000000000000
                hex     8080808080808080
                hex     0000000000000000
                hex     8080808080808080
                hex     2828282828282828
                hex     A8A8A8A8A8A8A8A8
                hex     2828282828282828
                hex     A8A8A8A8A8A8A8A8
                hex     2828282828282828
                hex     A8A8A8A8A8A8A8A8
                hex     2828282828282828
                hex     A8A8A8A8A8A8A8A8
                hex     5050505050505050
                hex     D0D0D0D0D0D0D0D0
                hex     5050505050505050
                hex     D0D0D0D0D0D0D0D0
                hex     5050505050505050
                hex     D0D0D0D0D0D0D0D0
                hex     5050505050505050
                hex     D0D0D0D0D0D0D0D0
        
        
mario		; 3x21
		hex 80A880
		hex 80AA80
		hex C0AA85
		hex A09D80
		hex E88D87
		hex E8FF9F
		hex A8FF80
		hex A8DF82
		hex 80FF81
		hex C09580
		hex A89681
		hex AA9683
		hex AB968B
		hex A3AA8B
		hex C7AAFB
		hex C7AAFD
		hex C0AA85
		hex D08285
		hex D08295
		hex A8808A
		hex AA80AA

buffer		; 3x21
		ds.b 63,00