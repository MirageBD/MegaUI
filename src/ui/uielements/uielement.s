; ----------------------------------------------------------------------------------------------------

uielement_layout
		jsr uirect_calcminmax

		jsr uistack_peekparent
		ldy #UIELEMENT::parent				; set parent
		lda uielement_parent_ptr+0
		sta (zpptr0),y
		iny
		lda uielement_parent_ptr+1
		sta (zpptr0),y

    	rts

uielement_focus
	    rts

uielement_enter
		lda zpptr0+0                                    ; is the element being entered the captured one?
		cmp uimouse_captured_element+0
		bne :+
		lda zpptr0+1
		cmp uimouse_captured_element+1
		bne :+

		lda mouse_held
		beq :+
		SEND_EVENT press
:
	    rts

uielement_leave
		rts

uielement_draw
    	rts

uielement_press
		ldy #UIELEMENT::state
		lda (zpptr0),y
		ora #UISTATE::pressed
		sta (zpptr0),y
    	rts

uielement_release
		ldy #UIELEMENT::state
		lda (zpptr0),y
		and #UISTATEMASK::pressed
		sta (zpptr0),y
    	rts

uielement_move
		rts

uielement_listeners

		jsr ui_getelementlistenersptr_3

		ldy #$00					; read pointer to ui element to act upon

:		lda (zpptr3),y
		sta zpptr0+0
		iny
		lda (zpptr3),y
		cmp #$ff
		bne :+
		rts

:		sta zpptr0+1

		iny
		lda (zpptr3),y
		sta ui_sbl+1
		iny
		lda (zpptr3),y
		sta ui_sbl+2

		phy
ui_sbl	jsr $babe
		ply

		iny
		bra :--

; ----------------------------------------------------------------------------------------------------
