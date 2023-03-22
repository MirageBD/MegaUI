; ----------------------------------------------------------------------------------------------------

uictextbutton_layout

		jsr uielement_layout

		lda #$05
		sta uirect_xdeflate
		lda #$05
		sta uirect_ydeflate

		jsr uirect_deflate

		rts

; ----------------------------------------------------------------------------------------------------

uictextbutton_focus
		rts

; ----------------------------------------------------------------------------------------------------

uictextbutton_enter
		jsr uielement_enter
		rts

; ----------------------------------------------------------------------------------------------------

uictextbutton_leave
		jsr uielement_leave
		jsr uicbutton_draw_released
		rts

; ----------------------------------------------------------------------------------------------------

uictextbutton_move
		;jsr uielement_move
		rts

; ----------------------------------------------------------------------------------------------------

uictextbutton_keypress
		rts

; ----------------------------------------------------------------------------------------------------

uictextbutton_keyrelease
		rts
		
; ----------------------------------------------------------------------------------------------------

uictextbutton_draw
		jsr uicbutton_draw

		lda #$02
		sta uidraw_xposoffset
		lda #$01
		sta uidraw_yposoffset

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_1

        ldy #$00
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$00
		ldz #$00
:		lda (zpptr2),y
		beq :+
		sec
		sbc #32
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz
		iny
 		bra :-
:

		lda #$00
		sta uidraw_xposoffset
		sta uidraw_yposoffset

		rts

; ----------------------------------------------------------------------------------------------------

uictextbutton_press
		jsr uielement_press
		jsr uicbutton_draw_pressed
		rts

; ----------------------------------------------------------------------------------------------------

uictextbutton_release
		jsr uielement_release
		jsr uicbutton_draw_released

		lda zpptr0+0
		DEBUG_COLOUR

	   	rts

; ----------------------------------------------------------------------------------------------------
