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
		jsr uielement_hide
		rts

uiscrolltrack_focus
		rts

uiscrolltrack_enter
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

:		lda uimouse_uielement_ypos+0			; for now, put position in track in uiscrolltrack_startpos
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

		ldy #UIELEMENT::height					; track height: 8-1=7
		lda (zpptr0),y
		sec
		sbc #$01
		sta uiscrolltrack_height+2

		ldy #$06
		lda (zpptrtmp),y						; list entries: 30
		sta uiscrolltrack_numentries+2

		MATH_SUB uiscrolltrack_numentries,	uiscrolltrack_height,		uiscrolltrack_numerator ; $17
		MATH_MUL uiscrolltrack_startpos,	uiscrolltrack_numerator,	uiscrolltrack_numerator

		clc
		lda uiscrolltrack_height+2
		adc #$01
		sta uiscrolltrack_height+2

		MATH_DIV uiscrolltrack_numerator, uiscrolltrack_height, uiscrolltrack_denominator

		clc
		ror uiscrolltrack_denominator+3
		ror uiscrolltrack_denominator+2
		clc
		ror uiscrolltrack_denominator+3
		ror uiscrolltrack_denominator+2
		clc
		ror uiscrolltrack_denominator+3
		ror uiscrolltrack_denominator+2

		lda uiscrolltrack_denominator+2

		jsr uiscrollbar_setposition
		jsr uielement_calluifunc

		rts

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

		ldy #5*16+0
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

		ldy #UIELEMENT::height					; list height: 12
		lda (zpptr2),y
		sta uiscrolltrack_listheight+2

		lda uiscrolltrack_numentries+2
		cmp uiscrolltrack_listheight+2
		bpl :+
		rts										; dont draw puck if entries < list height

:		ldy #UIELEMENT::height					; track height: 8-1=7
		lda (zpptr0),y
		sec
		sbc #$01
		sta uiscrolltrack_height+2

		ldy #$02
		lda (zpptrtmp),y						; startpos: 0,1,2,3,4.
		sta uiscrolltrack_startpos+2

		MATH_SUB uiscrolltrack_numentries,	uiscrolltrack_listheight,	uiscrolltrack_numerator		; 20-12=8
		MATH_DIV uiscrolltrack_startpos,	uiscrolltrack_numerator,	uiscrolltrack_denominator	; 0/5, 1/5
		MATH_MUL uiscrolltrack_denominator,	uiscrolltrack_height,		uiscrolltrack_denominator	; 5* 0/5, 5*1/5 = 1
		;MATH_ROUND uiscrolltrack_denominator, uiscrolltrack_denominator

		ldx uiscrolltrack_denominator+2

:		dex
		bmi :+
		jsr uidraw_increase_row
		bra :-

:		lda #5*16+6
		ldz #$00
		sta [uidraw_scrptr],z
		inz
		inz
		lda #5*16+7
		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------
