; ----------------------------------------------------------------------------------------------------

uiradiobutton_layout

		jsr uielement_layout
		rts

; ----------------------------------------------------------------------------------------------------

uiradiobutton_focus
		rts

; ----------------------------------------------------------------------------------------------------

uiradiobutton_enter
		rts

; ----------------------------------------------------------------------------------------------------

uiradiobutton_leave
		jsr uielement_leave
		rts

; ----------------------------------------------------------------------------------------------------

uiradiobutton_move
		rts

; ----------------------------------------------------------------------------------------------------

uiradiobutton_keypress
		rts

; ----------------------------------------------------------------------------------------------------

uiradiobutton_keyrelease
		rts

; ----------------------------------------------------------------------------------------------------

uiradiobutton_draw

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_1

		ldy #$01							; pointer to group index goes to zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$00							; read group index
		lda (zpptr2),y
		cmp (zpptr1),y						; compare with this index
		beq uiradiobutton_selected

		; uiradiobutton_not_selected

		ldz #$00
		lda #3*16+12
		sta [uidraw_scrptr],z
		rts

uiradiobutton_selected
		ldz #$00
		lda #3*16+13
		sta [uidraw_scrptr],z
		rts

; ----------------------------------------------------------------------------------------------------

uiradiobutton_press
		jsr uielement_press
		rts

; ----------------------------------------------------------------------------------------------------

uiradiobutton_doubleclick
		rts

; ----------------------------------------------------------------------------------------------------

uiradiobutton_release
		jsr uielement_release

		jsr ui_getelementdataptr_1

		ldy #$01							; pointer to group index goes to zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$00							; read index
		lda (zpptr1),y
		sta (zpptr2),y						; put in group index

		jsr uiradiobutton_draw

		jsr uielement_listeners

	   	rts

; ----------------------------------------------------------------------------------------------------
