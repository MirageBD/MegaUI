; ----------------------------------------------------------------------------------------------------

uislider_layout
		jsr uielement_layout
		rts

uislider_leave
		jsr uielement_leave
		rts

uislider_move
		lda mouse_held
		beq :+
		jsr uislider_press
:		rts

uislider_release
		jsr uielement_release
	   	rts

uislider_focus
uislider_enter
uislider_longpress
uislider_keypress
uislider_keyrelease
uislider_doubleclick
uislider_hide
		rts

; ----------------------------------------------------------------------------------------------------

uislider_draw
		jsr uislider_draw_released
		jsr uislider_draw_released_puck
		rts

; ----------------------------------------------------------------------------------------------------

uislider_press
		jsr uimouse_calculate_pos_in_uielement
		jsr ui_getelementdataptr_tmp

		lda uimouse_uielement_xpos+1			; check position within track, set position
		cmp #$ff
		bne :+
		rts

:		lda uimouse_uielement_xpos+0
		asl										; for now, just *2 because my slider is 128 and I want values from 0-256
		bcc :+
		rts

:		ldy #$02
		sta (zpptrtmp),y

		jsr uislider_draw
		;jsr uielement_calluifunc

		rts

; ----------------------------------------------------------------------------------------------------

uislider_draw_released

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_tmp

		ldx uidraw_width

		ldz #$00						; draw background slider
		lda #3*16+10
:		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-

		ldy #$02
		lda (zpptrtmp),y
		lsr
		lsr
		lsr
		lsr
		tax
		inx

		ldz #$00						; draw bit that's filled now
		lda #3*16+12
:		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-

		rts

; ----------------------------------------------------------------------------------------------------

uislider_draw_released_puck

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_tmp

		ldy #$02
		lda (zpptrtmp),y
		lsr
		lsr
		lsr
		lsr
		asl
		taz

		lda #3*16+9
		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------
