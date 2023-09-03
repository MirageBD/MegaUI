; ----------------------------------------------------------------------------------------------------

uiroot_layout
		jsr uielement_layout

		lda #$01
		sta uirect_xdeflate
		lda #$01
		sta uirect_ydeflate

		jsr uirect_deflate

    	rts

uiroot_hide
		;jsr uielement_hide
		rts

uiroot_focus
		jsr uielement_focus
	    rts

uiroot_enter
		jsr uielement_enter
	    rts

uiroot_leave
		jsr uielement_leave
		rts

uiroot_draw
	   	rts

uiroot_press
		;jsr uielement_press
    	rts

uiroot_longpress
		rts

uiroot_doubleclick
		jsr uielement_doubleclick
		rts

uiroot_release
		jsr uielement_release
    	rts

uiroot_move
		jsr uielement_move
		rts

uiroot_keypress
		jsr uielement_keypress

		lda keyboard_pressedeventarg
		cmp #KEYBOARD_ESC
		bne uiroot_keypress_end

		sei
		bra :+
romfilename .byte .sprintf("MEGA65.ROM"), 0
:		lda #$37
		sta $01
		; Disable C65 ROM write protection via Hypervisor trap
		lda #$02
		sta $d641
		clv
		; copy rom filename to bank 0
		ldx #$0b
:	    lda romfilename,x
		sta $0200,x
		dex
		bpl :-
		; set rom filename
		ldy #$02
		lda #$2e
		sta $d640
		clv
		; load rom file to $20000
		lda #$00
		tax
		tay
	    ldz #$02
	    lda #$36
	    sta $d640
	    clv
		; Set bit 7 - HOTREG
		lda #%10000000
		tsb $d05d
		; disable Super-Extended Attribute Mode
		lda #$00
		sta $d054
		; disable SPRENV400
		lda #$00
		sta $d076
		; restore palette
		lda #$00
		sta $d070
		; RESET!
		;jmp $e4b8
		jmp ($fffc)

uiroot_keypress_end
		rts
    
uiroot_keyrelease
		jsr uielement_keyrelease
		rts
		
; ----------------------------------------------------------------------------------------------------
