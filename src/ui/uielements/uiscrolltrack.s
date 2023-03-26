; ----------------------------------------------------------------------------------------------------

uiscrolltrack_layout
		jsr uielement_layout
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

; ----------------------------------------------------------------------------------------------------

uiscrolltrack_draw
		jsr uiscrolltrack_draw_released
		jsr uiscrollpuck_draw_released
		rts

; ----------------------------------------------------------------------------------------------------

uiscrolltrack_press
		jsr uielement_press

		jsr uimouse_calculate_pos_in_uielement

		; check position within track, set position
		jsr ui_getelementdataptr_tmp

		lda uimouse_uielement_ypos+1
		cmp #$ff
		bne :+
		lda #$00
		bra :++

:		lda uimouse_uielement_ypos+1
		;ror
		lda uimouse_uielement_ypos+0
		;ror
		;clc
		;lsr
		;lsr

:		jsr uiscrollbar_setposition
		rts

; ----------------------------------------------------------------------------------------------------

uiscrolltrack_release
		jsr uielement_release
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

		ldy #6*16+6
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

uiscrolltrack_startpos			.byte $00, $00, $00, $00
uiscrolltrack_numentries		.byte $00, $00, $00, $00
uiscrolltrack_height			.byte $00, $00, $00, $00
uiscrolltrack_numerator			.byte $00, $00, $00, $00
uiscrolltrack_denominator		.byte $00, $00, $00, $00

uiscrollpuck_draw_released

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_tmp

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

		ldy #$02
		lda (zpptrtmp),y						; num entries: 20
		sta uiscrolltrack_numentries+2

		ldy #UIELEMENT::height					; height: 14
		lda (zpptr0),y
		clc
		adc #$02
		sta uiscrolltrack_height+2

		lda uiscrolltrack_numentries+2
		cmp uiscrolltrack_height+2
		bpl :+
		rts										; dont draw puck if entries < height

:		ldy #$00
		lda (zpptrtmp),y						; startpos: 0,1,2,3, etc.
		sta uiscrolltrack_startpos+2

		MATH_SUB uiscrolltrack_numentries,	uiscrolltrack_height,		uiscrolltrack_denominator ; 20-14=6
		MATH_MUL uiscrolltrack_numentries,	uiscrolltrack_denominator,	uiscrolltrack_denominator ; 20*6=120

		MATH_MUL uiscrolltrack_numentries,	uiscrolltrack_startpos,		uiscrolltrack_numerator ; 0, 20, 40, 80, etc.

		MATH_DIV uiscrolltrack_numerator,	uiscrolltrack_denominator,	uiscrolltrack_denominator

		sec
		lda uiscrolltrack_height+2
		sbc #$03
		sta uiscrolltrack_height+2

		MATH_MUL uiscrolltrack_height,		uiscrolltrack_denominator,	uiscrolltrack_denominator ; 0, 20, 40, 80, etc.

		MATH_ROUND uiscrolltrack_denominator, uiscrolltrack_denominator

		ldx uiscrolltrack_denominator+2

:		dex
		bmi :+
		jsr uidraw_increase_row
		bra :-

:
		lda #6*16+12
		ldz #$00
		sta [uidraw_scrptr],z
		inz
		inz
		lda #6*16+13
		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------
