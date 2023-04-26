; ----------------------------------------------------------------------------------------------------

uiimage_layout
		jsr uielement_layout
		rts

uiimage_hide
		;jsr uielement_hide
		rts

uiimage_focus
		rts

uiimage_enter
		rts

uiimage_leave
		rts

uiimage_move
		rts

uiimage_keypress
		rts

uiimage_keyrelease
		rts

uiimage_press
		rts

uiimage_longpress
		rts

uiimage_doubleclick
		rts

uiimage_release
	   	rts

uiimage_draw

		jsr uidraw_set_draw_position

		ldy #$02
		jsr ui_getelementdata_2

		ldy zpptr2+0

:		ldx #$00
		ldz #$00
		tya
:		sta [uidraw_scrptr],z
		inz
		inz
		adc #$01
		inx
		cpx uidraw_width
		bne :-

		jsr uidraw_increase_row

		tya
		clc
		adc #16
		tay

		dec uidraw_height
		lda uidraw_height
		bne :--

		rts

; ----------------------------------------------------------------------------------------------------
