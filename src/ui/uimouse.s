uimouse_uielement_xpos		.word $0080
uimouse_uielement_ypos		.word $0080

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

		lda #%00000001									; enable sprite 0
		sta $d015
		sta $d057										; enable 64 pixel wide sprites. 16 pixels if in Full Colour Mode
		sta $d06b										; enable Full Colour Mode (SPR16EN)
		sta $d055										; sprite height enable (SPRHGTEN)
		sta $d076										; enable SPRENVV400 for this sprite
		lda #%00010000
		tsb $d054										; enable SPR640 for all sprites

		lda #%00000000
		sta $d017										; expand so I can see better
		sta $d01d

		lda #16											; set sprite height to 16 pixels (SPRHGHT)
		sta $d056

		lda #<(sprites/64)
		sta sprptrs+0
		lda #>(sprites/64)
		sta sprptrs+1

		lda #<sprptrs									; tell VIC-IV where the sprite pointers are (SPRPTRADR)
		sta $d06c
		lda #>sprptrs
		sta $d06d
		lda #(sprptrs & $ff0000) >> 16					; SPRPTRBNK
		sta $d06e

		lda #%10000000									; tell VIC-IV to expect two bytes per sprite pointer instead of one
		tsb $d06e										; do this after setting sprite pointer address, because that uses $d06e as well

		lda #$80										; sprite 0 position
		sta $d000
		lda #%00000000
		sta $d010										; sprite horizontal position MSBs
		lda #%00000001
		sta $d05f										; Sprite H640 X Super-MSBs

		lda #$80
		sta $d001
		lda #%00000000
		sta $d077										; Sprite V400 Y position MSBs
		lda #%00000000
		sta $d078										; Sprite V400 Y position super MSBs

		lda $d070										; select mapped bank with the upper 2 bits of $d070
		and #%00111111
		ora #%01000000									; select palette 01
		sta $d070

		ldx #$00										; set sprite palette - each sprite has a 16 colour palette
:		lda spritepal+0*$0100,x
		sta $d100,x
		lda spritepal+1*$0100,x
		sta $d200,x
		lda spritepal+2*$0100,x
		sta $d300,x
		inx
		cpx #$10
		bne :-

		lda #$00										; set transparent colours
		sta $d027
		sta $d028

		lda $d070
		and #%11110011									; set sprite palette to 01
		ora #%00000100
		sta $d070

        rts

; ----------------------------------------------------------------------------------------------------

uimouse_update_sprite

		lda mouse_xpos_plusborder+0						; update sprite position
		sta $d000
		lda mouse_xpos_plusborder+1
		and #$01
		sta $d010										; sprite horizontal position MSBs
		lda mouse_xpos_plusborder+1
		and #$02
		lsr
		sta $d05f										; Sprite H640 X Super-MSBs

		lda mouse_ypos_plusborder+0
		sta $d001
		lda mouse_ypos_plusborder+1
		and #$01
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

		lda uimouse_captured_element+1					; is there a captured element?
		beq :+
		lda uimouse_captured_element+0
		sta zpptr0+0
		lda uimouse_captured_element+1
		sta zpptr0+1
		jsr uimouse_handle_events2
		rts

:		jsr uimouse_handle_event						; no captured element - go through all elements

:		ldy uielement_prevhoverwindowcounter			; go through all the previous hovered windows and decrease the hover flag
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
		bne :+											; nope, test if we're inside the rect
		rts

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
		ldy uielement_temp								; otherwise handle the enter event
		cpy #$00
		beq uimhe_entered
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
		bra uimhe_handle_this

uimhe_entered
		ldy #UIELEMENT::state
		lda #$01
		sta (zpptr0),y
		jsr uimouse_handle_enter						; handle ENTER
		bra uimhe_handle_children

uimhe_handle_this

		jsr uimouse_handle_events2

uimhe_handle_children

		ldy #UIELEMENT::children
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

uimouse_handle_events2

uimhe_notentered
		lda mouse_pressed								; handle PRESS
		beq uimhe_notpressed
		jsr uimouse_handle_press
		bra uimhe_checkmove

uimhe_notpressed
		lda mouse_doubleclicked
		beq uimh_notdoubleclicked
		jsr uimouse_handle_doubleclick
		bra uimhe_checkmove

uimh_notdoubleclicked		
		lda mouse_released
		beq uimhe_checkmove
		jsr uimouse_handle_release						; handle RELEASE

uimhe_checkmove

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
		bra uimhe_mouse_didnt_move

uimhe_mouse_moved
		jsr uimouse_handle_move

uimhe_mouse_didnt_move
		
		rts

; ----------------------------------------------------------------------------------------------------

uimouse_handle_move

		jsr uimouse_checkflags
		bne :+
		rts

:		lda uimouse_captured_element+1					; is there a captured element?
		bne :+
		rts

:		lda zpptr0+0
		pha
		lda zpptr0+1
		pha

		lda uimouse_captured_element+0
		sta zpptr0+0
		lda uimouse_captured_element+1
		sta zpptr0+1

		SEND_EVENT move

		pla
		sta zpptr0+1
		pla
		sta zpptr0+0

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
		bne :+
		lda zpptr0+1
		cmp uimouse_captured_element+1
		bne :+
		lda #$00
		sta uimouse_captured_element+0
		sta uimouse_captured_element+1
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
		SEND_EVENT press

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
