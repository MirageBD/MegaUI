; ----------------------------------------------------------------------------------------------------

; Q registers for offset calculations

uiscaletrack_startpos			.byte $00, $00, $00, $00
uiscaletrack_numentries			.byte $00, $00, $00, $00
uiscaletrack_height				.byte $00, $00, $00, $00
uiscaletrack_listheight			.byte $00, $00, $00, $00

uiscaletrack_numerator			.byte $00, $00, $00, $00
uiscaletrack_denominator		.byte $00, $00, $00, $00

; ----------------------------------------------------------------------------------------------------

uiscaletrack_resetqvalues

		lda #$00
		sta uiscaletrack_numentries+0
		sta uiscaletrack_numentries+1
		sta uiscaletrack_numentries+2
		sta uiscaletrack_numentries+3
		sta uiscaletrack_height+0
		sta uiscaletrack_height+1
		sta uiscaletrack_height+2
		sta uiscaletrack_height+3
		sta uiscaletrack_startpos+0
		sta uiscaletrack_startpos+1
		sta uiscaletrack_startpos+2
		sta uiscaletrack_startpos+3

		rts

; ----------------------------------------------------------------------------------------------------

uiscaletrack_layout
		jsr uielement_layout
		rts

uiscaletrack_hide
		;jsr uielement_hide
		rts

uiscaletrack_focus
		rts

uiscaletrack_enter
		rts

uiscaletrack_longpress
		rts

uiscaletrack_leave
		jsr uielement_leave
		rts

uiscaletrack_move
		lda mouse_held
		beq :+
		jsr uiscaletrack_press
:		rts

uiscaletrack_keypress
		rts

uiscaletrack_keyrelease
		rts

uiscaletrack_doubleclick
		rts

uiscaletrack_release
		jsr uielement_release
	   	rts

; ----------------------------------------------------------------------------------------------------

uiscaletrack_draw
		jsr uiscaletrack_draw_released
		jsr uiscaletrack_draw_released_puck
		rts

; ----------------------------------------------------------------------------------------------------

uiscaletrack_press
		jsr uimouse_calculate_pos_in_uielement
		jsr uiscaletrack_resetqvalues
		jsr ui_getelementdataptr_tmp

		lda uimouse_uielement_ypos+1			; check position within track, set position
		cmp #$ff
		bne :+
		rts

:		lda uimouse_uielement_ypos+0			; for now, put position in track in uiscaletrack_startpos
		sta uiscaletrack_startpos+2
		lda uimouse_uielement_ypos+1
		sta uiscaletrack_startpos+3

		ldy #$08								; get pointer to element that holds the list in zpptr2
		lda (zpptrtmp),y
		sta zpptr2+0
		iny
		lda (zpptrtmp),y
		sta zpptr2+1

		ldy #UIELEMENT::height					; list height: 12
		lda (zpptr2),y
		sta uiscaletrack_listheight+2

		ldy #UIELEMENT::height
		lda (zpptr0),y
		sec
		sbc #$01
		sta uiscaletrack_height+2

		ldy #$06
		lda (zpptrtmp),y						; list entries: 30
		sta uiscaletrack_numentries+2

		MATH_SUB uiscaletrack_numentries,	uiscaletrack_listheight,	uiscaletrack_numerator
		MATH_DIV uiscaletrack_startpos,		uiscaletrack_height,		uiscaletrack_denominator
		MATH_MUL uiscaletrack_denominator,	uiscaletrack_numerator,		uiscaletrack_denominator

		lsr uiscaletrack_denominator+3
		ror uiscaletrack_denominator+2
		lsr uiscaletrack_denominator+3
		ror uiscaletrack_denominator+2
		lsr uiscaletrack_denominator+3
		ror uiscaletrack_denominator+2

		lda uiscaletrack_denominator+2

		ldy #$02
		sta (zpptrtmp),y

		jsr uielement_calluifunc

		rts

; ----------------------------------------------------------------------------------------------------

uiscaletrack_draw_released

		jsr uidraw_set_draw_position

		lda #$00
		sta uidraw_xdeflate
		lda #$02
		sta uidraw_ydeflate
		jsr uidraw_deflate
		ldx uidraw_width
		ldy uidraw_height

		lda #5*16+11
		ldz #$00						; draw left of scrolltrack
		sta [uidraw_scrptr],z
		inz
		inz

		clc
		adc #$01

		ldx #$01
:		sta [uidraw_scrptr],z
		inz
		inz
		inx
		cpx uidraw_width
		bne :-

		clc
		adc #$01

		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------

uiscaletrack_draw_released_puck

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_tmp

		ldy #$02
		lda (zpptrtmp),y
		sta uiscaletrack_startpos+2

		ldz #$00
		lda #5*16+14
		sta [uidraw_scrptr],z
		inz
		inz
		lda #5*16+15
		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------
