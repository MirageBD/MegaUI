; ----------------------------------------------------------------------------------------------------

uidivider_layout
		jsr uielement_layout
		rts

uidivider_leave
		jsr uielement_leave
		rts

uidivider_release
		jsr uielement_release
	   	rts

uidivider_hide
uidivider_focus
uidivider_enter
uidivider_longpress
uidivider_move
uidivider_keypress
uidivider_keyrelease
uidivider_doubleclick
uidivider_press
		rts

; ----------------------------------------------------------------------------------------------------

uidivider_draw

		jsr uidraw_set_draw_position

		ldx uidraw_height

		ldz #$00
:		lda #3*16+14
		sta [uidraw_scrptr],z
		jsr uidraw_increase_row
		dex
		bne :-

		rts

; ----------------------------------------------------------------------------------------------------
