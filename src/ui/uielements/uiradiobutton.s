; ----------------------------------------------------------------------------------------------------

uiradiobutton_layout
		jsr uielement_layout
		rts

uiradiobutton_hide
		;jsr uielement_hide
		rts

uiradiobutton_focus
		rts

uiradiobutton_enter
		rts

uiradiobutton_leave
		rts

uiradiobutton_move
		rts

uiradiobutton_keypress
		rts

uiradiobutton_keyrelease
		rts

uiradiobutton_press
		rts

uiradiobutton_longpress
		rts

uiradiobutton_doubleclick
		rts

uiradiobutton_draw

		jsr uidraw_set_draw_position

		ldy #$04							; pointer to group index goes to zpptr2
		jsr ui_getelementdata_2

		ldy #$00							; read group index
		lda (zpptr2),y
		ldy #$02
		cmp (zpptr1),y						; compare with this index
		beq :+

		ldz #$00							; uiradiobutton not selected
		lda #3*16+12
		sta [uidraw_scrptr],z
		rts

:		ldz #$00							; uiradiobutton selected
		lda #3*16+13
		sta [uidraw_scrptr],z
		rts

; ----------------------------------------------------------------------------------------------------

uiradiobutton_release
		ldy #$04							; pointer to group index goes to zpptr2
		jsr ui_getelementdata_2

		ldy #$02							; read index
		lda (zpptr1),y
		ldy #$00
		sta (zpptr2),y						; put in group index

		jsr uielement_calluifunc

	   	rts

; ----------------------------------------------------------------------------------------------------
