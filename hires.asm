

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
        
        
        
        
