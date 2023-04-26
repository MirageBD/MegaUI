; ----------------------------------------------------------------------------------------------------

uicbutton_layout

		jsr uielement_layout

		lda #$05
		sta uirect_xdeflate
		lda #$05
		sta uirect_ydeflate

		jsr uirect_deflate

		rts

; ----------------------------------------------------------------------------------------------------

uicbutton_hide
		;jsr uielement_hide
		rts

; ----------------------------------------------------------------------------------------------------

uicbutton_focus
		rts

; ----------------------------------------------------------------------------------------------------

uicbutton_enter
		jsr uielement_enter
		rts

; ----------------------------------------------------------------------------------------------------

uicbutton_leave
		jsr uielement_leave
		jsr uicbutton_draw_released
		rts

; ----------------------------------------------------------------------------------------------------

uicbutton_move
		;jsr uielement_move
		rts

; ----------------------------------------------------------------------------------------------------

uicbutton_keypress
		rts

; ----------------------------------------------------------------------------------------------------

uicbutton_keyrelease
		rts	

; ----------------------------------------------------------------------------------------------------

uicbutton_draw

		jsr uidraw_set_draw_position
		lda #$02
		sta uidraw_xdeflate
		sta uidraw_ydeflate
		jsr uidraw_deflate
		ldx uidraw_width
		ldy uidraw_height

		ldz #$00						; draw top of button
		lda [uidraw_scrptr],z
		ora #0*16+1
		sta [uidraw_scrptr],z
		inz
		inz
		phx
:		lda [uidraw_scrptr],z
		ora #1*16+1
		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		lda [uidraw_scrptr],z
		ora #2*16+1
		sta [uidraw_scrptr],z

		jsr uidraw_increase_row

:		ldz #$00						; draw center of button
		lda #0*16+2
		sta [uidraw_scrptr],z
		inz
		inz
		phx
		lda #$03
:		sta [uidraw_colptr],z
		inz
		inz
		dex
		bne :-
		plx
		lda #2*16+2
		sta [uidraw_scrptr],z

		jsr uidraw_increase_row

		dey
		bne :--

		ldz #$00						; draw bottom of button
		lda #0*16+4
		sta [uidraw_scrptr],z
		inz
		inz
		phx
:		lda #1*16+4
		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		lda #2*16+4
		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------

uicbutton_press
		;jsr uielement_press
		jsr uicbutton_draw_pressed
		rts

uicbutton_longpress
		rts

; ----------------------------------------------------------------------------------------------------

uicbutton_doubleclick
		rts
		
; ----------------------------------------------------------------------------------------------------

uicbutton_release
		;jsr uielement_release
		jsr uicbutton_draw_released

		lda zpptr0+0
		DEBUG_COLOUR

	   	rts

; ----------------------------------------------------------------------------------------------------

uicbutton_draw_released

		jsr uidraw_set_draw_position
		lda #$02
		sta uidraw_xdeflate
		sta uidraw_ydeflate
		jsr uidraw_deflate
		ldx uidraw_width
		ldy uidraw_height

		ldz #$00						; draw top of button
		lda [uidraw_scrptr],z
		and #%11111101
		sta [uidraw_scrptr],z
		inz
		inz
		phx
:		lda [uidraw_scrptr],z
		and #%11111101
		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		lda [uidraw_scrptr],z
		and #%11111101
		sta [uidraw_scrptr],z

		jsr uidraw_increase_row

:		ldz #$00						; draw center of button
		lda [uidraw_scrptr],z
		and #%11111011
		sta [uidraw_scrptr],z
		inz
		inz
		phx
		lda #$03
:		sta [uidraw_colptr],z
		inz
		inz
		dex
		bne :-
		plx
		lda [uidraw_scrptr],z
		and #%11111011
		sta [uidraw_scrptr],z

		jsr uidraw_increase_row

		dey
		bne :--

		ldz #$00						; draw bottom of button
		lda [uidraw_scrptr],z
		and #%11110111
		sta [uidraw_scrptr],z
		inz
		inz
		phx
:		lda [uidraw_scrptr],z
		and #%11110111
		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		lda [uidraw_scrptr],z
		and #%11110111
		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------

uicbutton_draw_pressed

		jsr uidraw_set_draw_position
		lda #$02
		sta uidraw_xdeflate
		sta uidraw_ydeflate
		jsr uidraw_deflate
		ldx uidraw_width
		ldy uidraw_height

		ldz #$00						; draw top of button
		lda [uidraw_scrptr],z
		ora #%00000010
		sta [uidraw_scrptr],z
		inz
		inz
		phx
:		lda [uidraw_scrptr],z
		ora #%00000010
		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		lda [uidraw_scrptr],z
		ora #%00000010
		sta [uidraw_scrptr],z

		jsr uidraw_increase_row

:		ldz #$00						; draw center of button
		lda [uidraw_scrptr],z
		ora #%00000100
		sta [uidraw_scrptr],z
		inz
		inz
		phx
		lda #$02
:		sta [uidraw_colptr],z
		inz
		inz
		dex
		bne :-
		plx
		lda [uidraw_scrptr],z
		ora #%00000100
		sta [uidraw_scrptr],z

		jsr uidraw_increase_row

		dey
		bne :--

		ldz #$00						; draw bottom of button
		lda [uidraw_scrptr],z
		ora #%00001000
		sta [uidraw_scrptr],z
		inz
		inz
		phx
:		lda [uidraw_scrptr],z
		ora #%00001000
		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		lda [uidraw_scrptr],z
		ora #%00001000
		sta [uidraw_scrptr],z

    	rts

; ----------------------------------------------------------------------------------------------------
