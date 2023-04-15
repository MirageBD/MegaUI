; ----------------------------------------------------------------------------------------------------

uitextbox_layout
        jsr uielement_layout
    	rts

uitextbox_focus
	    rts

uitextbox_enter
	    rts

uitextbox_leave
		rts

uitextbox_move
		rts

uitextbox_keypress

		ldx keyboard_pressedeventarg

		lda keyboard_keytypes,x
		cmp #UIKEYBOARD_KEYTYPE::control
		beq uitextbox_keypress_control

uitextbox_keypress_noncontrol
		cmp #UIKEYBOARD_KEYTYPE::alpha
		beq uitextbox_keypress_alphanumericpunctuation
		cmp #UIKEYBOARD_KEYTYPE::numeric
		beq uitextbox_keypress_alphanumericpunctuation
		cmp #UIKEYBOARD_KEYTYPE::punctuation
		beq uitextbox_keypress_alphanumericpunctuation
		rts

uitextbox_keypress_alphanumericpunctuation
		jsr uitextbox_inserttext
		jsr uitextbox_updatecursor
		rts		

uitextbox_keypress_control
		txa
		cmp KEYBOARD_CURSORRIGHT
		bne :+
		jsr uitextbox_increasecursorxpos
		jsr uitextbox_updatecursor
		rts

:		cmp KEYBOARD_CURSORLEFT
		bne :+
		jsr uitextbox_decreasecursorxpos
		jsr uitextbox_updatecursor
		rts

:		cmp KEYBOARD_INSERTDEL
		bne :+
		jsr uitextbox_backspacetext
		jsr uitextbox_updatecursor
		rts

:		rts

uitextbox_keyrelease
		rts

uitextbox_press

		jsr uimouse_calculate_pos_in_uielement

		jsr ui_getelementdataptr_1

		clc
		lda uimouse_uielement_xpos+0
		adc #$04
		sta uimouse_uielement_xpos+0
		lda uimouse_uielement_xpos+1
		adc #$00
		sta uimouse_uielement_xpos+1

		lsr uimouse_uielement_xpos+1
		ror uimouse_uielement_xpos+0
		lsr uimouse_uielement_xpos+1
		ror uimouse_uielement_xpos+0
		lsr uimouse_uielement_xpos+1
		ror uimouse_uielement_xpos+0

		ldy #$04
		lda uimouse_uielement_xpos+0
		sta (zpptr1),y
		iny
		lda uimouse_uielement_xpos+1
		sta (zpptr1),y

		jsr uitextbox_updatecursor

    	rts

uitextbox_doubleclick
		rts

uitextbox_release
    	rts

; ----------------------------------------------------------------------------------------------------

uitextbox_inserttext

		jsr ui_getelementdataptr_1

        ldy #$02								; get pointer to text in zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$04								; get pointer to cursor pos
		lda (zpptr1),y
		sta zpptrtmp+0

		ldy #$00								; set y to where string ends
:		lda (zpptr2),y
		beq :+
		iny
		bra :-

:		clc										; copy y to y+1
		lda zpptr2+0
		adc #$01
		sta zpptr3+0
		lda zpptr2+1
		adc #$00
		sta zpptr3+1

:		lda (zpptr2),y							; while decreasing until cursor position
		sta (zpptr3),y
		cpy zpptrtmp+0
		beq :+
		dey
		bra :-

:		ldx keyboard_pressedeventarg
		lda keyboard_toascii,x
		sta (zpptr2),y

		jsr uitextbox_increasecursorxpos
		jsr uitextbox_draw

		rts

uitextbox_deletetext

		jsr ui_getelementdataptr_1

        ldy #$02								; get pointer to text in zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$04								; get pointer to cursor pos
		lda (zpptr1),y
		sta zpptrtmp+0

		clc										; copy y+1 to y
		lda zpptr2+0
		adc #$01
		sta zpptr3+0
		lda zpptr2+1
		adc #$00
		sta zpptr3+1

:		lda (zpptr3),y							; while increasing until end of string
		sta (zpptr2),y
		beq :+
		iny
		bra :-

:		;jsr uitextbox_decreasecursorxpos
		jsr uitextbox_draw

		rts

uitextbox_backspacetext

		jsr ui_getelementdataptr_1

        ldy #$02								; get pointer to text in zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		jsr uitextbox_decreasecursorxpos

		ldy #$04								; get pointer to cursor pos
		lda (zpptr1),y
		tay

		clc										; copy y+1 to y
		lda zpptr2+0
		adc #$01
		sta zpptr3+0
		lda zpptr2+1
		adc #$00
		sta zpptr3+1

:		lda (zpptr3),y							; while increasing until end of string
		sta (zpptr2),y
		beq :+
		iny
		bra :-

:		jsr uitextbox_draw

		rts
; ----------------------------------------------------------------------------------------------------

uitextbox_increasecursorxpos
		jsr ui_getelementdataptr_1
		ldy #$04								; get pointer to cursor pos
		clc
		lda (zpptr1),y
		adc #$01
		sta (zpptr1),y
		rts

uitextbox_decreasecursorxpos
		jsr ui_getelementdataptr_1
		ldy #$04								; get pointer to cursor pos
		sec
		lda (zpptr1),y
		sbc #$01
		sta (zpptr1),y
		rts

; ----------------------------------------------------------------------------------------------------

uitextbox_confine
		jsr ui_getelementdataptr_1

		ldy #$02								; get pointer to text in zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$00
:		lda (zpptr2),y
		beq :+
		iny
		bra :-

:		sty zpptrtmp+0
		ldy #$04								; get pointer to cursor pos
		lda (zpptr1),y
		bpl :+
		lda #$00
		sta (zpptr1),y

:		cmp zpptrtmp+0
		bmi :+
		lda zpptrtmp+0
		sta (zpptr1),y

:		rts


uitextbox_draw
		jsr uitextbox_drawbkgreleased
		jsr uitextbox_drawreleased
		rts

; ----------------------------------------------------------------------------------------------------

uitextbox_drawbkgreleased
		jsr uidraw_set_draw_position

		ldy #UIELEMENT::width
		lda (zpptr0),y
		sec
		sbc #$01										; LV TODO - do something about this madness
		sta uidraw_width

		ldx uidraw_width
		ldz #$00
:		lda #$20
		sta [uidraw_scrptr],z
		lda #$00										; mid gray background
		sta [uidraw_colptr],z
		inz
		inz
		dex
		bne :-

		rts

uitextbox_drawreleased

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_1

        ldy #$02
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$00
		ldz #$00
:		lda (zpptr2),y
		beq :+
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz
		iny
 		bra :-
:
    	rts

; ----------------------------------------------------------------------------------------------------

uitextbox_updatecursor

		jsr uitextbox_confine

		lda #$00
		sta uikeyboard_cursorxpos+1
		sta uikeyboard_cursorypos+1

		clc
		ldy #UIELEMENT::layoutxpos
		lda (zpptr0),y
		sta uikeyboard_cursorxpos+0

		clc
		ldy #UIELEMENT::layoutypos
		lda (zpptr0),y
		sta uikeyboard_cursorypos+0

		asl uikeyboard_cursorxpos+0
		rol uikeyboard_cursorxpos+1
		asl uikeyboard_cursorxpos+0
		rol uikeyboard_cursorxpos+1
		asl uikeyboard_cursorxpos+0
		rol uikeyboard_cursorxpos+1

		asl uikeyboard_cursorypos+0
		rol uikeyboard_cursorypos+1
		asl uikeyboard_cursorypos+0
		rol uikeyboard_cursorypos+1
		asl uikeyboard_cursorypos+0
		rol uikeyboard_cursorypos+1

		sec
		lda uikeyboard_cursorxpos+0
		sbc #$02
		sta uikeyboard_cursorxpos+0
		lda uikeyboard_cursorxpos+1
		sbc #$00
		sta uikeyboard_cursorxpos+1

		jsr ui_getelementdataptr_1

		ldy #$04
		lda (zpptr1),y
		asl
		asl
		asl

		clc
		adc uikeyboard_cursorxpos+0
		sta uikeyboard_cursorxpos+0
		lda uikeyboard_cursorxpos+1
		adc #$00
		sta uikeyboard_cursorxpos+1

		jsr uikeyboard_setcursorpos

		rts

; ----------------------------------------------------------------------------------------------------
