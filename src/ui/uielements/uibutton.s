; ----------------------------------------------------------------------------------------------------

uibutton_layout

		jsr uielement_layout
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_hide
		;jsr uielement_hide
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_focus
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_enter
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_leave
		jsr uielement_leave
		jsr uibutton_draw_released
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_draw
		jsr uibutton_draw_released
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_press
		jsr uibutton_draw_pressed
		jsr uielement_press

		ldy #$00
		jsr uielement_calluifunc

		rts

uibutton_longpress
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_doubleclick
		jsr uibutton_release
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_release
		jsr uibutton_draw_released
		jsr uielement_release
	   	rts

; ----------------------------------------------------------------------------------------------------

uibutton_move
		;jsr uielement_move
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_keypress
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_keyrelease
		rts
		
; ----------------------------------------------------------------------------------------------------

uibutton_draw_pressed

		jsr uidraw_set_draw_position

		ldy #$03
		jsr ui_getelementdata_2

		ldy zpptr2+0
:		ldx #$00
		ldz #$00						; draw top of button
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
		adc #2
		tay

		dec uidraw_height
		lda uidraw_height
		bne :--

		rts

; ----------------------------------------------------------------------------------------------------

uibutton_draw_released

		jsr uidraw_set_draw_position

		ldy #$02
		jsr ui_getelementdata_2

		ldy zpptr2+0
:		ldx #$00
		ldz #$00						; draw top of button
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
		adc #2
		tay

		dec uidraw_height
		lda uidraw_height
		bne :--

		rts

; ----------------------------------------------------------------------------------------------------
