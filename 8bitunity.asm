

	processor 6502
	
        
kbd 		equ $c000
kbstrb 		equ $c010
speaker		equ $c030

graphics  	equ $c050
text 		equ $c051
fullpage	equ $c052
page1 		equ $c054
hires 		equ $c057

        
        
	org $803
        
       
        sta hires
        sta fullpage
        sta graphics
        sta page1
     
     
Start	
	jsr test_blitSHR_orig



end	jmp end


	include "blitSHR_orig.asm"
	include "hires.asm"

	org $2000
        incbin "marioluigi-apple2.hires.bin"