uimouse_uielement_xpos			.word $0080
uimouse_uielement_ypos			.word $0080

uimouse_uielement_xpos_pressed	.word $0080
uimouse_uielement_ypos_pressed	.word $0080

; ----------------------------------------------------------------------------------------------------

uimouse_hoverwindows
		.repeat 256
			.byte 0
		.endrepeat

uimouse_prevhoverwindows
		.repeat 256
			.byte 0
		.endrepeat

uimouse_captured_element
		.word 0

; ----------------------------------------------------------------------------------------------------

uimouse_init
		lda #<(sprites/64)
		sta sprptrs+0
		lda #>(sprites/64)
		sta sprptrs+1
        rts

; ----------------------------------------------------------------------------------------------------

uimouse_disablecursor

		lda $d015
		and #%11111110
		sta $d015
		rts

uimouse_enablecursor

		lda $d015
		ora #%00000001
		sta $d015
		rts

; ----------------------------------------------------------------------------------------------------

uimouse_update_sprite

		lda mouse_xpos_plusborder+0						; update sprite position
		sta $d000
		lda $d010
		and #%11111110
		sta $d010
		lda mouse_xpos_plusborder+1
		and #$01
		ora $d010
		sta $d010										; sprite horizontal position MSBs
		lda $d05f
		and #%11111110
		sta $d05f
		lda mouse_xpos_plusborder+1
		and #$02
		lsr
		ora $d05f
		sta $d05f										; Sprite H640 X Super-MSBs

		lda mouse_ypos_plusborder+0
		sta $d001
		lda $d077
		and #%11111110
		sta $d077
		lda mouse_ypos_plusborder+1
		and #$01
		ora $d077
		sta $d077										; Sprite V400 Y position MSBs
		lda #%00000000
		sta $d078										; Sprite V400 Y position super MSBs
		rts

; ----------------------------------------------------------------------------------------------------

uimouse_update

		jsr uimouse_update_sprite

		lda #<ui_root1									; get pointer to window x
		sta uielement_ptr+0
		lda #>ui_root1
		sta uielement_ptr+1
		lda #$00
		sta uielement_layoutxpos
		sta uielement_layoutypos
		lda #$00
		sta uielement_hoverwindowcounter

		lda uimouse_captured_element+0					; ALWAYS handle the captured element
		sta zpptr0+0
		lda uimouse_captured_element+1
		sta zpptr0+1
		beq :+
		jsr uimhe_handle_captured						; This is the captured element - don't do the inside-rect-check but always execute

:		jsr uimouse_handle_event

		ldy uielement_prevhoverwindowcounter			; go through all the previous hovered windows and decrease the hover flag
		sty uielement_temp								; if it's no longer hovered over then send a leave event
:		ldy uielement_temp
		cpy #$00
		beq :+
		dey
		lda uimouse_prevhoverwindows,y
		sta zpptr0+1
		dey
		lda uimouse_prevhoverwindows,y
		sta zpptr0+0
		sty uielement_temp
		sec
		ldy #UIELEMENT::state
		lda (zpptr0),y
		sbc #$01
		sta (zpptr0),y
		and #UISTATE::hover
		cmp #$00
		bne :-
		SEND_EVENT leave
		bra :-

:		ldy uielement_hoverwindowcounter				; copy focussed list to prevfocussed list
		sty uielement_prevhoverwindowcounter
:		dey
		cpy #$ff
		beq :+
		lda uimouse_hoverwindows,y
		sta uimouse_prevhoverwindows,y
		bra :-

:		rts

; ----------------------------------------------------------------------------------------------------

uimouse_test_minmax

		ldy #UIELEMENT::xmin+1
		lda mouse_xpos+1
		cmp (zpptr0),y
		bne :+
		ldy #UIELEMENT::xmin+0
		lda mouse_xpos+0
		cmp (zpptr0),y
:		bcs :+
		rts

:		ldy #UIELEMENT::xmax+1
		lda mouse_xpos+1
		cmp (zpptr0),y
		bne :+
		ldy #UIELEMENT::xmax+0
		lda mouse_xpos+0
		cmp (zpptr0),y
:		bcc :+
		clc
		rts

:		ldy #UIELEMENT::ymin+1
		lda mouse_ypos+1
		cmp (zpptr0),y
		bne :+
		ldy #UIELEMENT::ymin+0
		lda mouse_ypos+0
		cmp (zpptr0),y
:		bcs :+
		rts

:		ldy #UIELEMENT::ymax+1
		lda mouse_ypos+1
		cmp (zpptr0),y
		bne :+
		ldy #UIELEMENT::ymax+0
		lda mouse_ypos+0
		cmp (zpptr0),y
:		bcc :+
		clc
		rts

:		sec
		rts

; ----------------------------------------------------------------------------------------------------

uimouse_handle_event

		lda #$ff
		sta uielement_counter

uimouse_handle_event_loop
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
		bne :+											; nope. test if we're inside the rect or if this is the captured element.
		rts

:		ldy #UIELEMENT::flags							; is the element visible?
		lda (zpptr0),y
		and #UIFLAGS::visible
		bne :+
		bra uimouse_handle_event_loop

:		jsr uimouse_test_minmax
		bcs :+											; we are inside the rect, do the rest
		bra uimouse_handle_event_loop					; we're not inside the rect, continue with the loop

:		ldy uielement_hoverwindowcounter				; we are inside the rect - add to focussed window list
		lda zpptr0+0
		sta uimouse_hoverwindows,y
		iny
		lda zpptr0+1
		sta uimouse_hoverwindows,y
		iny
		sty uielement_hoverwindowcounter

		ldy uielement_prevhoverwindowcounter			; go throught all the previously hovered over windows
		sty uielement_temp								; if the window was already hovered over then set the hover flag

uimhe_loop_prehoverwindows
		ldy uielement_temp
		cpy #$00
		beq uimhe_entered								; otherwise handle the enter event
		dey
		lda uimouse_prevhoverwindows,y
		sta zpptr1+1
		dey
		lda uimouse_prevhoverwindows,y
		sta zpptr1+0
		sty uielement_temp
		lda zpptr0+0
		cmp zpptr1+0
		bne uimhe_loop_prehoverwindows
		lda zpptr0+1
		cmp zpptr1+1
		bne uimhe_loop_prehoverwindows
		clc
		ldy #UIELEMENT::state
		lda (zpptr0),y
		adc #$01
		sta (zpptr0),y
		bra uimhe_notentered

uimhe_entered
		ldy #UIELEMENT::state
		lda #$01
		sta (zpptr0),y
		jsr uimouse_handle_enter						; handle ENTER
		bra uimhe_handle_children

uimhe_notentered

		lda uimouse_captured_element+0
		cmp zpptr0+0
		bne :+
		lda uimouse_captured_element+1
		cmp zpptr0+1
		bne :+
		rts

:
uimhe_handle_captured

		lda mouse_xpos+0
		cmp mouse_prevxpos+0
		bne uimhe_mouse_moved
		lda mouse_xpos+1
		cmp mouse_prevxpos+1
		bne uimhe_mouse_moved
		lda mouse_ypos+0
		cmp mouse_prevypos+0
		bne uimhe_mouse_moved
		lda mouse_ypos+1
		cmp mouse_prevypos+1
		bne uimhe_mouse_moved
		bra uimhe_notmoved

uimhe_mouse_moved
		jsr uimouse_handle_move							; handle MOVE
		rts

uimhe_notmoved
		lda mouse_doubleclicked
		beq uimh_notdoubleclicked
		jsr uimouse_handle_doubleclick
		bra uimhe_handle_children						; if double clicked then skip press/release tests

uimh_notdoubleclicked
		lda mouse_longpressed
		beq uimh_notlongpressed
		jsr uimouse_handle_longpress
		bra uimhe_handle_children

uimh_notlongpressed
		lda mouse_pressed								; handle PRESS
		beq uimhe_notpressed
		jsr uimouse_handle_press
		bra uimhe_handle_children

uimhe_notpressed
		lda mouse_released
		beq uimhe_handle_children
		jsr uimouse_handle_release						; handle RELEASE

uimhe_handle_children

		ldy #UIELEMENT::children
		iny												; add 1 - we want to check for $xx $ff, not $ff xx !!!
		lda (zpptr0),y
		cmp #$ff
		bne :+
		jmp uimouse_handle_event_loop

:		jsr uistack_pushparent							; recursively handle children
		ldy #UIELEMENT::children
		lda (zpptr0),y
		sta uielement_ptr+0
		iny
		lda (zpptr0),y
		sta uielement_ptr+1
		jsr uimouse_handle_event
		jsr uistack_popparent
		jmp uimouse_handle_event_loop

; ----------------------------------------------------------------------------------------------------

uimouse_handle_move

		jsr uimouse_checkflags
		bne :+
		rts

:		SEND_EVENT move
		rts

; ----------------------------------------------------------------------------------------------------

uimouse_handle_enter

		jsr uimouse_checkflags
		bne :+
		rts

:		SEND_EVENT enter
		rts

; ----------------------------------------------------------------------------------------------------

uimouse_handle_release
		jsr uimouse_checkflags
		bne :+
		rts

:		lda zpptr0+0
		cmp uimouse_captured_element+0
		bne :++
		lda zpptr0+1
		cmp uimouse_captured_element+1
		bne :++
		lda #$00
		sta uimouse_captured_element+0
		sta uimouse_captured_element+1

		jsr uimouse_test_minmax
		bcc :+											; we are inside the rect, do the rest

		lda zpptr0+0
		sta uikeyboard_focuselement+0
		lda zpptr0+1
		sta uikeyboard_focuselement+1

		SEND_EVENT release

:		rts

; ----------------------------------------------------------------------------------------------------

uimouse_handle_doubleclick
		jsr uimouse_checkflags
		bne :+
		rts

:		lda zpptr0+0
		cmp uimouse_captured_element+0
		bne :+
		lda zpptr0+1
		cmp uimouse_captured_element+1
		bne :+
		lda #$00
		sta uimouse_captured_element+0
		sta uimouse_captured_element+1
		SEND_EVENT doubleclick

:		rts

; ----------------------------------------------------------------------------------------------------

uimouse_handle_press
		jsr uimouse_checkflags
		bne :+
		rts

:		lda zpptr0+0
		sta uimouse_captured_element+0
		lda zpptr0+1
		sta uimouse_captured_element+1

		jsr uikeyboard_disablecursor					; LV TODO - is this really the best place for this?

		SEND_EVENT press

		rts

; ----------------------------------------------------------------------------------------------------

uimouse_handle_longpress

		jsr uimouse_checkflags
		bne :+
		rts

:;		lda zpptr0+0
;		sta uimouse_captured_element+0
;		lda zpptr0+1
;		sta uimouse_captured_element+1

		SEND_EVENT longpress

		rts

; ----------------------------------------------------------------------------------------------------

uimouse_checkflags
		ldy #UIELEMENT::flags
		lda (zpptr0),y
		and #UIFLAGS::enabled
		rts

; ----------------------------------------------------------------------------------------------------

uimouse_calculate_pos_in_uielement

		sec
		lda mouse_xpos+0
		ldy #UIELEMENT::xmin+0
		sbc (zpptr0),y
		sta uimouse_uielement_xpos+0
		lda mouse_xpos+1
		ldy #UIELEMENT::xmin+1
		sbc (zpptr0),y
		sta uimouse_uielement_xpos+1
		sec
		lda mouse_ypos+0
		ldy #UIELEMENT::ymin+0
		sbc (zpptr0),y
		sta uimouse_uielement_ypos+0
		lda mouse_ypos+1
		ldy #UIELEMENT::ymin+1
		sbc (zpptr0),y
		sta uimouse_uielement_ypos+1

		rts

; ----------------------------------------------------------------------------------------------------

uimouse_calculate_pospressed_in_uielement

		sec
		lda mouse_xpos_pressed+0
		ldy #UIELEMENT::xmin+0
		sbc (zpptr0),y
		sta uimouse_uielement_xpos_pressed+0
		lda mouse_xpos_pressed+1
		ldy #UIELEMENT::xmin+1
		sbc (zpptr0),y
		sta uimouse_uielement_xpos_pressed+1
		sec
		lda mouse_ypos_pressed+0
		ldy #UIELEMENT::ymin+0
		sbc (zpptr0),y
		sta uimouse_uielement_ypos_pressed+0
		lda mouse_ypos_pressed+1
		ldy #UIELEMENT::ymin+1
		sbc (zpptr0),y
		sta uimouse_uielement_ypos_pressed+1

		rts

; ----------------------------------------------------------------------------------------------------
