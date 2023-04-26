; ----------------------------------------------------------------------------------------------------

uictextbutton_layout

		jsr uielement_layout

		lda #$05
		sta uirect_xdeflate
		lda #$05
		sta uirect_ydeflate

		jsr uirect_deflate

		rts

uictextbutton_hide
		;jsr uielement_hide
		rts

uictextbutton_focus
		rts

uictextbutton_enter
		jsr uielement_enter
		rts

uictextbutton_leave
		jsr uicbutton_draw_released
		rts

uictextbutton_move
		rts

uictextbutton_keypress
		ldy #$04
		jsr ui_getelementdata_2

		lda zpptr2+0						; pointer to shortcut key
		cmp keyboard_pressedeventarg
		bne :+
		jsr uictextbutton_press
:		rts

uictextbutton_keyrelease
		ldy #$04
		jsr ui_getelementdata_2

		lda zpptr2+0						; pointer to shortcut key
		cmp keyboard_pressedeventarg
		bne :+
		jsr uictextbutton_release
:		rts

uictextbutton_press
		jsr uicbutton_draw_pressed
		rts

uictextbutton_longpress
		rts

uictextbutton_doubleclick
		jsr uicbutton_draw_released
		rts
	
; ----------------------------------------------------------------------------------------------------

uictextbutton_draw
		jsr uicbutton_draw

		lda #$02
		sta uidraw_xposoffset
		lda #$01
		sta uidraw_yposoffset

		jsr uidraw_set_draw_position

        ldy #$02
		jsr ui_getelementdata_2

		ldy #$00
		ldz #$00
:		lda (zpptr2),y
		beq :+
		tax
		lda ui_textremap,x
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz
		iny
 		bra :-

:		jsr uidraw_resetoffsets
		rts

uictextbutton_release
		jsr uicbutton_draw_released
		jsr uielement_calluifunc

	   	rts

; ----------------------------------------------------------------------------------------------------
