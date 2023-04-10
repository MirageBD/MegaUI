; ----------------------------------------------------------------------------------------------------

uikeyboard_update

        lda keyboard_shouldsendreleaseevent
        beq uikeyboard_update_end

		lda #<ui_root1								; get pointer to window x
		sta uielement_ptr+0
		lda #>ui_root1
		sta uielement_ptr+1

        jsr uikeyboard_handle_event

uikeyboard_update_end
        rts

; ----------------------------------------------------------------------------------------------------

uikeyboard_handle_event

		lda #$ff
		sta uielement_counter

uikeyboard_handle_event_loop

		inc uielement_counter
		ldy uielement_counter

		clc
		lda uielement_ptr+0								; get pointer to window x
		adc ui_element_indiceslo,y
		sta zpptr0+0
		lda uielement_ptr+1
		adc ui_element_indiceshi,y
		sta zpptr0+1

		ldy #UIELEMENT::type							; are we at the end of the list?
		lda (zpptr0),y
		cmp #UIELEMENTTYPE::null
		bne :+											; nope, continue
		rts

:		jsr uikeyboard_handle_press						; handle PRESS

khe_handle_children

		ldy #UIELEMENT::children
		iny												; add 1 - we want to check for $xx $ff, not $ff xx !!!
		lda (zpptr0),y
		cmp #$ff
		bne :+
		jmp uikeyboard_handle_event_loop

:		jsr uistack_pushparent							; recursively handle children
		ldy #UIELEMENT::children
		lda (zpptr0),y
		sta uielement_ptr+0
		iny
		lda (zpptr0),y
		sta uielement_ptr+1
		jsr uikeyboard_handle_event
		jsr uistack_popparent
		jmp uikeyboard_handle_event_loop

; ----------------------------------------------------------------------------------------------------

uikeyboard_handle_press
        SEND_EVENT keypress

        rts

; ----------------------------------------------------------------------------------------------------
