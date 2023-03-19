; ----------------------------------------------------------------------------------------------------

uibutton_layout

		jsr uielement_layout
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
		jsr uielement_press
		jsr uibutton_draw_pressed
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_release
		jsr uielement_release
		jsr uibutton_draw_released

		jsr ui_getelementdataptr_1

        ldy #$02					; read pointer to ui element to act upon
		lda (zpptr1),y
		sta zpptr0+0
		iny
		lda (zpptr1),y
		sta zpptr0+1

        ldy #$04					; read function to call (second and third byte of data)
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		jsr (zpptr2)				; execute function

	   	rts

; ----------------------------------------------------------------------------------------------------

uibutton_move
		;jsr uielement_move
		rts

; ----------------------------------------------------------------------------------------------------

uibutton_draw_pressed

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_1

        ldy #$01
		lda (zpptr1),y
		tay

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

		jsr ui_getelementdataptr_1

		ldy #$00
		lda (zpptr1),y
		tay

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
