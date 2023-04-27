; ----------------------------------------------------------------------------------------------------

uiglyphbutton_colour	.byte $00

; ----------------------------------------------------------------------------------------------------

uiglyphbutton_layout
		jsr uielement_layout
    	rts

uiglyphbutton_hide
		;jsr uielement_hide
		rts

uiglyphbutton_focus
		jsr uielement_focus
	    rts

uiglyphbutton_enter
		jsr uielement_enter
	    rts

uiglyphbutton_leave
		jsr uielement_leave
		rts

uiglyphbutton_draw
		lda #3
		sta uiglyphbutton_colour
		jsr uiglyphbutton_drawreleased
    	rts

uiglyphbutton_press
		lda #3*16+9
		sta uiglyphbutton_colour
		jsr uiglyphbutton_drawreleased
		jsr uielement_press
		rts

uiglyphbutton_longpress
		rts

uiglyphbutton_doubleclick
		rts

uiglyphbutton_release
		lda #3
		sta uiglyphbutton_colour
		jsr uiglyphbutton_drawreleased
		jsr uielement_release

		ldy #$00
		jsr uielement_calluifunc
		rts

uiglyphbutton_move
		rts

uiglyphbutton_keypress
		rts

uiglyphbutton_keyrelease
		rts
		
; ----------------------------------------------------------------------------------------------------

uiglyphbutton_drawreleased

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

		lda #4*16+8
		tay

		ldx uidraw_width

		clc
		ldz #$00						; draw top of nineslice
		tya
		sta [uidraw_scrptr],z
		pha
		lda uiglyphbutton_colour
		sta [uidraw_colptr],z
		pla
		inz
		inz
		adc #$01
		phx
:		sta [uidraw_scrptr],z
		pha
		lda uiglyphbutton_colour
		sta [uidraw_colptr],z
		pla
		inz
		inz
		dex
		bne :-
		plx
		adc #$01
		sta [uidraw_scrptr],z
		pha
		lda uiglyphbutton_colour
		sta [uidraw_colptr],z
		pla

		jsr uidraw_increase_row

		tya
		clc
		adc #3
		tay

:		ldz #$00						; draw center of nineslice
		tya
		sta [uidraw_scrptr],z
		pha
		lda uiglyphbutton_colour
		sta [uidraw_colptr],z
		pla
		inz
		inz
		pha
		phx
:		lda #$00
		sta [uidraw_colptr],z
		pha
		lda uiglyphbutton_colour
		sta [uidraw_colptr],z
		pla
		inz
		inz
		dex
		bne :-
		plx
		pla
		adc #$01
		sta [uidraw_scrptr],z
		pha
		lda uiglyphbutton_colour
		sta [uidraw_colptr],z
		pla

		jsr uidraw_increase_row

		dec uidraw_height
		lda uidraw_height
		bne :--

		tya
		clc
		adc #2

		ldz #$00						; draw bottom of nineslice
		sta [uidraw_scrptr],z
		pha
		lda uiglyphbutton_colour
		sta [uidraw_colptr],z
		pla
		inz
		inz
		adc #$01
		phx
:		sta [uidraw_scrptr],z
		pha
		lda uiglyphbutton_colour
		sta [uidraw_colptr],z
		pla
		inz
		inz
		dex
		bne :-
		plx
		adc #$01
		sta [uidraw_scrptr],z
		pha
		lda uiglyphbutton_colour
		sta [uidraw_colptr],z
		pla

		rts

; ----------------------------------------------------------------------------------------------------
