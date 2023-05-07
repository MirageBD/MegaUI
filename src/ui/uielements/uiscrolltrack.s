; ----------------------------------------------------------------------------------------------------

; Q registers for offset calculations

uiscrolltrack_startpos			.byte $00, $00, $00, $00
uiscrolltrack_numentries		.byte $00, $00, $00, $00
uiscrolltrack_height			.byte $00, $00, $00, $00
uiscrolltrack_listheight		.byte $00, $00, $00, $00

uiscrolltrack_numerator			.byte $00, $00, $00, $00
uiscrolltrack_denominator		.byte $00, $00, $00, $00

; ----------------------------------------------------------------------------------------------------

uiscrolltrack_resetqvalues

		lda #$00
		sta uiscrolltrack_numentries+0
		sta uiscrolltrack_numentries+1
		sta uiscrolltrack_numentries+2
		sta uiscrolltrack_numentries+3
		sta uiscrolltrack_height+0
		sta uiscrolltrack_height+1
		sta uiscrolltrack_height+2
		sta uiscrolltrack_height+3
		sta uiscrolltrack_startpos+0
		sta uiscrolltrack_startpos+1
		sta uiscrolltrack_startpos+2
		sta uiscrolltrack_startpos+3

		rts

; ----------------------------------------------------------------------------------------------------

uiscrolltrack_layout
		jsr uielement_layout
		rts

uiscrolltrack_hide
		;jsr uielement_hide
		rts

uiscrolltrack_focus
		rts

uiscrolltrack_enter
		rts

uiscrolltrack_longpress
		rts

uiscrolltrack_leave
		jsr uielement_leave
		rts

uiscrolltrack_move
		lda mouse_held
		beq :+
		jsr uiscrolltrack_press
:		rts

uiscrolltrack_keypress
		rts

uiscrolltrack_keyrelease
		rts

uiscrolltrack_doubleclick
		rts

uiscrolltrack_release
		jsr uielement_release
	   	rts

; ----------------------------------------------------------------------------------------------------

uiscrolltrack_draw
		jsr uiscrolltrack_draw_released
		jsr uiscrolltrack_draw_released_puck
		rts

; ----------------------------------------------------------------------------------------------------

uiscrolltrack_press
		jsr uimouse_calculate_pos_in_uielement
		jsr uiscrolltrack_resetqvalues
		jsr ui_getelementdataptr_tmp

		lda uimouse_uielement_ypos+1			; check position within track, set position
		cmp #$ff
		bne :+
		rts

:		lda uimouse_uielement_ypos+0			; temporarily put position in track in uiscrolltrack_startpos
		sta uiscrolltrack_startpos+2
		lda uimouse_uielement_ypos+1
		sta uiscrolltrack_startpos+3

		ldy #$08								; get pointer to element that holds the list in zpptr2
		lda (zpptrtmp),y
		sta zpptr2+0
		iny
		lda (zpptrtmp),y
		sta zpptr2+1

		ldy #UIELEMENT::height					; list height: 12
		lda (zpptr2),y
		sta uiscrolltrack_listheight+2

		ldy #UIELEMENT::height
		lda (zpptr0),y
		sec
		sbc #$01
		sta uiscrolltrack_height+2

		ldy #$06
		lda (zpptrtmp),y						; list entries: 30
		sta uiscrolltrack_numentries+2
		iny
		lda (zpptrtmp),y						; list entries: 30
		sta uiscrolltrack_numentries+3

		MATH_SUB uiscrolltrack_numentries,	uiscrolltrack_listheight,	uiscrolltrack_numerator
		MATH_DIV uiscrolltrack_startpos,	uiscrolltrack_height,		uiscrolltrack_denominator
		MATH_MUL uiscrolltrack_denominator,	uiscrolltrack_numerator,	uiscrolltrack_denominator

		lsr uiscrolltrack_denominator+3
		ror uiscrolltrack_denominator+2
		lsr uiscrolltrack_denominator+3
		ror uiscrolltrack_denominator+2
		lsr uiscrolltrack_denominator+3
		ror uiscrolltrack_denominator+2

		ldy #$02
		lda uiscrolltrack_denominator+2
		sta (zpptrtmp),y
		iny
		lda uiscrolltrack_denominator+3
		sta (zpptrtmp),y

		jsr uiscrolltrack_confine

		jsr uielement_calluifunc

		rts

; ----------------------------------------------------------------------------------------------------

uiscrolltrack_confine

		jsr uiscrolltrack_resetqvalues

		ldy #$02										; get start pos
		lda (zpptrtmp),y
		sta uiscrolltrack_startpos+2
		iny
		lda (zpptrtmp),y
		sta uiscrolltrack_startpos+3

		MATH_POSITIVE uiscrolltrack_startpos
		bcs :+											; positive? ok, continue

		ldy #$02										; negative, set to 0
		lda #$00
		sta (zpptrtmp),y
		iny
		sta (zpptrtmp),y
		rts

:		ldy #$06										; store number of entries
		lda (zpptrtmp),y
		sta uiscrolltrack_numentries+2
		iny
		lda (zpptrtmp),y
		sta uiscrolltrack_numentries+3

		ldy #UIELEMENT::height
		lda (zpptr0),y
		sta uiscrolltrack_listheight+2

		MATH_SUB uiscrolltrack_numentries, uiscrolltrack_listheight, uiscrolltrack_numerator
		MATH_POSITIVE uiscrolltrack_numerator
		bcs :+											; carry set   = uiscrolltrack_numentries > uiscrolltrack_listheight

		ldy #$02										; carry clear = uiscrolltrack_numentries < uiscrolltrack_listheight i.e. entries fit into box without scrolling
		lda #$00										; set scrollpos to 0
		sta (zpptrtmp),y
		iny
		sta (zpptrtmp),y
		rts

:		MATH_BIGGER uiscrolltrack_numerator, uiscrolltrack_startpos, uiscrolltrack_denominator
		bcs :+

		ldy #$02
		lda uiscrolltrack_numerator+2
		sta (zpptrtmp),y
		iny
		lda uiscrolltrack_numerator+3
		sta (zpptrtmp),y

:		rts

; ----------------------------------------------------------------------------------------------------

uiscrolltrack_draw_released

		jsr uidraw_set_draw_position

		lda #$00
		sta uidraw_xdeflate
		lda #$02
		sta uidraw_ydeflate
		jsr uidraw_deflate
		ldx uidraw_width
		ldy uidraw_height

		ldy #4*16+0
		ldx #$00
		ldz #$00						; draw top of scrolltrack
		tya
:		sta [uidraw_scrptr],z
		inz
		inz
		clc
		adc #$01
		inx
		cpx #$02
		bne :-

		tya
		clc
		adc #2
		tay

		jsr uidraw_increase_row

:		ldx #$00
		ldz #$00						; draw middle of scrolltrack
		tya
:		sta [uidraw_scrptr],z
		inz
		inz
		clc
		adc #$01
		inx
		cpx #$02
		bne :-

		jsr uidraw_increase_row

		dec uidraw_height
		lda uidraw_height
		bne :--

		tya
		clc
		adc #2
		tay

		ldx #$00
		ldz #$00						; draw bottom of scrolltrack
		tya
:		sta [uidraw_scrptr],z
		inz
		inz
		clc
		adc #$01
		inx
		cpx #$02
		bne :-

		rts

; ----------------------------------------------------------------------------------------------------

uiscrolltrack_draw_released_puck

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_tmp

		jsr uiscrolltrack_resetqvalues

		ldy #$08								; get pointer to element that holds the list
		lda (zpptrtmp),y
		sta zpptr2+0
		iny
		lda (zpptrtmp),y
		sta zpptr2+1

		ldy #$06
		lda (zpptrtmp),y						; num entries: 30
		sta uiscrolltrack_numentries+2
		iny
		lda (zpptrtmp),y						; num entries: 30
		sta uiscrolltrack_numentries+3

		ldy #UIELEMENT::height					; list height: 12
		lda (zpptr2),y
		sta uiscrolltrack_listheight+2

		lda uiscrolltrack_numentries+2
		cmp uiscrolltrack_listheight+2
		;bpl :+
		;rts									; dont draw puck if entries < list height

:		ldy #UIELEMENT::height					; track height: 8-1=7
		lda (zpptr0),y
		sec
		sbc #$01
		sta uiscrolltrack_height+2

		ldy #$02
		lda (zpptrtmp),y						; startpos: 0,1,2,3,4.
		sta uiscrolltrack_startpos+2
		iny
		lda (zpptrtmp),y
		sta uiscrolltrack_startpos+3

		MATH_SUB uiscrolltrack_numentries,	uiscrolltrack_listheight,	uiscrolltrack_numerator		; 20-12=8
		MATH_DIV uiscrolltrack_startpos,	uiscrolltrack_numerator,	uiscrolltrack_denominator	; 0/5, 1/5
		MATH_MUL uiscrolltrack_denominator,	uiscrolltrack_height,		uiscrolltrack_denominator	; 5* 0/5, 5*1/5 = 1

		ldx uiscrolltrack_denominator+2

:		dex
		bmi :+
		jsr uidraw_increase_row
		bra :-

:		lda #4*16+6
		ldz #$00
		sta [uidraw_scrptr],z
		inz
		inz
		lda #4*16+7
		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------
