; ----------------------------------------------------------------------------------------------------

uislider_layout
		jsr uielement_layout
		rts

uislider_hide
		;jsr uielement_hide
		rts

uislider_focus
		rts

uislider_enter
		rts

uislider_longpress
		rts

uislider_leave
		jsr uielement_leave
		rts

uislider_move
		lda mouse_held
		beq :+
		jsr uislider_press
:		rts

uislider_keypress
		rts

uislider_keyrelease
		rts

uislider_doubleclick
		rts

uislider_release
		jsr uielement_release
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

		ldx uidraw_width

		ldz #$00						; draw background slider
		lda #3*16+10
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
		inz
		inz

		rts

; ----------------------------------------------------------------------------------------------------
