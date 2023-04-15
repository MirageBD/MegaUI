; ----------------------------------------------------------------------------------------------------

uikeyboard_focuselement				.word 0

uikeyboard_cursorxpos				.word 0
uikeyboard_cursorypos				.word 0

; ----------------------------------------------------------------------------------------------------

uikeyboard_init

		lda #<(kbsprites/64)
		sta sprptrs+2
		lda #>(kbsprites/64)
		sta sprptrs+3
		rts

; ----------------------------------------------------------------------------------------------------

uikeyboard_setcursorpos

		clc
		lda uikeyboard_cursorxpos+0
		adc #$50
		sta uikeyboard_cursorxpos+0
		lda uikeyboard_cursorxpos+1
		adc #$00
		sta uikeyboard_cursorxpos+1

		clc
		lda uikeyboard_cursorypos+0
		adc #$67
		sta uikeyboard_cursorypos+0
		lda uikeyboard_cursorypos+1
		adc #$00
		sta uikeyboard_cursorypos+1

		lda uikeyboard_cursorxpos+0						; update sprite position
		sta $d002
		lda $d010
		and #%11111101
		sta $d010
		lda uikeyboard_cursorxpos+1
		and #$01
		asl
		ora $d010
		sta $d010										; sprite horizontal position MSBs
		lda $d05f
		and #%11111101
		sta $d05f
		lda uikeyboard_cursorxpos+1
		and #%00000010
		ora $d05f
		sta $d05f										; Sprite H640 X Super-MSBs

		lda uikeyboard_cursorypos+0
		sta $d003
		lda $d077
		and #%11111101
		sta $d077
		lda uikeyboard_cursorypos+1
		and #$01
		asl
		ora $d077
		sta $d077										; Sprite V400 Y position MSBs
		lda #%00000000
		sta $d078										; Sprite V400 Y position super MSBs

		rts

; ----------------------------------------------------------------------------------------------------

uikeyboard_update

        lda keyboard_shouldsendreleaseevent
        beq :+
        jsr uikeyboard_handlereleaseevent
		rts

:       lda keyboard_shouldsendpressevent
        beq :+
		jsr uikeyboard_handlepressevent
		rts

:       rts

; ----------------------------------------------------------------------------------------------------

uikeyboard_handlereleaseevent

		lda uikeyboard_focuselement+0
		sta zpptr0+0
		lda uikeyboard_focuselement+1
		sta zpptr0+1

		SEND_EVENT keyrelease

		lda #<ui_root1								; get pointer to window x
		sta uielement_ptr+0
		lda #>ui_root1
		sta uielement_ptr+1

		jsr ukb_handlereleaseevent_recursive

		rts

; ----------------------------------------------------------------------------------------------------

uikeyboard_handlepressevent

		lda uikeyboard_focuselement+0
		sta zpptr0+0
		lda uikeyboard_focuselement+1
		sta zpptr0+1

		SEND_EVENT keypress

		lda #<ui_root1								; get pointer to window x
		sta uielement_ptr+0
		lda #>ui_root1
		sta uielement_ptr+1

        jsr ukb_handlepressedevent_recursive

		rts

; ----------------------------------------------------------------------------------------------------

ukb_handlepressedevent_recursive

		lda #$ff
		sta uielement_counter

ukb_handlepressedeventloop

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

ukhe_handlechildren

		ldy #UIELEMENT::children
		iny												; add 1 - we want to check for $xx $ff, not $ff xx !!!
		lda (zpptr0),y
		cmp #$ff
		bne :+
		jmp ukb_handlepressedeventloop

:		jsr uistack_pushparent							; recursively handle children
		ldy #UIELEMENT::children
		lda (zpptr0),y
		sta uielement_ptr+0
		iny
		lda (zpptr0),y
		sta uielement_ptr+1
		jsr ukb_handlepressedevent_recursive
		jsr uistack_popparent
		jmp ukb_handlepressedeventloop

; ----------------------------------------------------------------------------------------------------


ukb_handlereleaseevent_recursive

		lda #$ff
		sta uielement_counter

ukb_handlereleaseeventloop

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

:		jsr uikeyboard_handle_release					; handle RELEASE

		ldy #UIELEMENT::children
		iny												; add 1 - we want to check for $xx $ff, not $ff xx !!!
		lda (zpptr0),y
		cmp #$ff
		bne :+
		jmp ukb_handlereleaseeventloop

:		jsr uistack_pushparent							; recursively handle children
		ldy #UIELEMENT::children
		lda (zpptr0),y
		sta uielement_ptr+0
		iny
		lda (zpptr0),y
		sta uielement_ptr+1
		jsr ukb_handlereleaseevent_recursive
		jsr uistack_popparent
		jmp ukb_handlereleaseeventloop

; ----------------------------------------------------------------------------------------------------

uikeyboard_handle_press

		ldy #UIELEMENT::type
		lda (zpptr0),y
		cmp #UIELEMENTTYPE::ctextbutton
		bne :+

		SEND_EVENT keypress

:		rts

uikeyboard_handle_release

		ldy #UIELEMENT::type
		lda (zpptr0),y
		cmp #UIELEMENTTYPE::ctextbutton
		bne :+

		SEND_EVENT keyrelease

:		rts

; ----------------------------------------------------------------------------------------------------
