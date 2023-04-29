; ----------------------------------------------------------------------------------------------------

uinineslice_layout
		jsr uielement_layout
    	rts

uinineslice_hide
		;jsr uielement_hide
		rts

uinineslice_focus
		jsr uielement_focus
	    rts

uinineslice_enter
		jsr uielement_enter
	    rts

uinineslice_leave
		jsr uielement_leave
		rts

uinineslice_draw
		jsr uinineslice_drawreleased
    	rts

uinineslice_press
		rts

uinineslice_longpress
		rts

uinineslice_doubleclick
		rts

uinineslice_release
		rts

uinineslice_move
		rts

uinineslice_keypress
		rts

uinineslice_keyrelease
		rts
		
; ----------------------------------------------------------------------------------------------------

uinineslice_drawreleased

		jsr uidraw_set_draw_position

		sec
		ldy #UIELEMENT::width
		lda (zpptr0),y
		sbc #$02
		sta uidraw_width
		sec
		ldy #UIELEMENT::height
		lda (zpptr0),y
		sbc #$02
		sta uidraw_height

		lda #3*16
		tay

		ldx uidraw_width

		clc
		ldz #$00						; draw top of nineslice
		tya
		sta [uidraw_scrptr],z
		inz
		inz
		adc #$01
		phx
:		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		adc #$01
		sta [uidraw_scrptr],z

		jsr uidraw_increase_row

		tya
		clc
		adc #3
		tay

:		ldz #$00						; draw center of nineslice
		tya
		sta [uidraw_scrptr],z
		inz
		inz
		pha
		phx
:		lda #$80						; #$80 is a tile that shows the background colour, not colour ram
		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		pla
		adc #$01
		sta [uidraw_scrptr],z

		jsr uidraw_increase_row

		dec uidraw_height
		lda uidraw_height
		bne :--

		tya
		clc
		adc #2

		ldz #$00						; draw bottom of nineslice
		sta [uidraw_scrptr],z
		inz
		inz
		adc #$01
		phx
:		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		adc #$01
		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------
