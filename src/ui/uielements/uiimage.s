; ----------------------------------------------------------------------------------------------------

uiimage_layout
		jsr uielement_layout
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

uiimage_doubleclick
		rts

uiimage_release
	   	rts

uiimage_draw

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_1

		ldy #$01
		lda (zpptr1),y
		tay

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
