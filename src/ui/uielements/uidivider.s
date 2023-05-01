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

		sec
		lda uidraw_height
		sbc #$02
		tax

		ldz #$00
		lda #7*16+2
		sta [uidraw_scrptr],z
		jsr uidraw_increase_row

		ldz #$00
:		lda #7*16+3
		sta [uidraw_scrptr],z
		jsr uidraw_increase_row
		dex
		bne :-

		ldz #$00
		lda #7*16+4
		sta [uidraw_scrptr],z
		jsr uidraw_increase_row

		rts

; ----------------------------------------------------------------------------------------------------
