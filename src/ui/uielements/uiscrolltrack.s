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
		ror
		lda uimouse_uielement_ypos+0
		ror
		clc
		lsr
		lsr

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

uiscrollpuck_draw_released

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_tmp

		ldy #$00
		lda (zpptrtmp),y
		tax

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
