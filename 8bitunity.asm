

	processor 6502
	
        
kbd = $c000
kbstrb = $c010
speaker	= $c030

graphx = $c050
text = $c051
page1 = $c054
hires = $c057
        
        
	org $803
        
        

	jsr clear_hgr1
        
        sta graphx
        sta text
     
     
Start	jmp Start


	include "8bitunity-plot_scroll.asm"
	include "hires.asm"
