; ----------------------------------------------------------------------------------------------------

uitextbox_textlength	.word 0, 0, 0, 0
uitextbox_cursorpos		.byte 0, 0, 0, 0
uitextbox_startpos		.word 0, 0, 0, 0
uitextbox_boxwidth		.word 0, 0, 0, 0

uitextbox_numerator		.word 0, 0, 0, 0
uitextbox_denominator	.word 0, 0, 0, 0

; ----------------------------------------------------------------------------------------------------

uitextbox_resetqvalues

		lda #$00
		sta uitextbox_textlength+0
		sta uitextbox_textlength+1
		sta uitextbox_textlength+2
		sta uitextbox_textlength+3
		sta uitextbox_cursorpos+0
		sta uitextbox_cursorpos+1
		sta uitextbox_cursorpos+2
		sta uitextbox_cursorpos+3
		sta uitextbox_startpos+0
		sta uitextbox_startpos+1
		sta uitextbox_startpos+2
		sta uitextbox_startpos+3
		sta uitextbox_boxwidth+0
		sta uitextbox_boxwidth+1
		sta uitextbox_boxwidth+2
		sta uitextbox_boxwidth+3
		sta uitextbox_numerator+0
		sta uitextbox_numerator+1
		sta uitextbox_numerator+2
		sta uitextbox_numerator+3
		sta uitextbox_denominator+0
		sta uitextbox_denominator+1
		sta uitextbox_denominator+2
		sta uitextbox_denominator+3
		rts

; ----------------------------------------------------------------------------------------------------

uitextbox_layout
        jsr uielement_layout
    	rts

uitextbox_hide
		;jsr uielement_hide
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

		rts		

uitextbox_keypress_control
		txa
		cmp #KEYBOARD_CURSORRIGHT
		bne :+
		jsr uitextbox_increasecursorxpos
		jsr uitextbox_confine_cursor
		jsr uitextbox_updatecursor
		jsr uitextbox_draw
		rts

:		cmp #KEYBOARD_CURSORLEFT
		bne :+
		jsr uitextbox_decreasecursorxpos
		jsr uitextbox_confine_cursor
		jsr uitextbox_updatecursor
		jsr uitextbox_draw
		rts

:		cmp #KEYBOARD_INSERTDEL
		bne :+
		jsr uitextbox_backspacetext
		jsr uitextbox_confine_cursor
		jsr uitextbox_updatecursor
		jsr uitextbox_draw
		rts

:		rts

uitextbox_keyrelease
		rts

uitextbox_press

		jsr uikeyboard_enablecursor

		jsr uimouse_calculate_pos_in_uielement

		ldy #$04
		jsr ui_getelementdata_2

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

		jsr uitextbox_confine_cursor
		jsr uitextbox_updatecursor

    	rts

uitextbox_longpress
		rts

uitextbox_doubleclick
		rts

uitextbox_release
    	rts

; ----------------------------------------------------------------------------------------------------

uitextbox_inserttext

        ldy #$0a								; get pointer to text in zpptr2
		jsr ui_getelementdata_2

		ldy #$08								; get max text size
		lda (zpptr1),y
		ldy #$06								; get text length
		cmp (zpptr1),y
		bpl :+
		rts

:		ldy #$04								; get pointer to cursor pos
		lda (zpptr1),y
		sta uitextbox_cursorpos+2
		iny
		lda (zpptr1),y
		sta uitextbox_cursorpos+3

		ldy #$06								; get text length
		lda (zpptr1),y
		tay

:		clc										; copy y to y+1
		lda zpptr2+0
		adc #$01
		sta zpptr3+0
		lda zpptr2+1
		adc #$00
		sta zpptr3+1

:		lda (zpptr2),y							; while decreasing until cursor position
		sta (zpptr3),y
		cpy uitextbox_cursorpos+2
		beq :+
		dey
		bra :-

:		ldx keyboard_pressedeventarg
		lda keyboard_toascii,x
		sta (zpptr2),y

		clc										; increase text length
		ldy #$06
		lda (zpptr1),y
		adc #$01
		sta (zpptr1),y
		iny
		lda (zpptr1),y
		adc #$00
		sta (zpptr1),y

		jsr uitextbox_increasecursorxpos
		jsr uitextbox_confine_cursor
		jsr uitextbox_updatecursor
		jsr uitextbox_draw

		rts

uitextbox_backspacetext

		jsr uitextbox_decreasecursorxpos

        ldy #$0a								; get pointer to text in zpptr2
		jsr ui_getelementdata_2

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

:		sec										; decrease text length
		ldy #$06
		lda (zpptr1),y
		sbc #$01
		sta (zpptr1),y
		lda (zpptr1),y
		sbc #$00
		sta (zpptr1),y

		rts
; ----------------------------------------------------------------------------------------------------

uitextbox_increasecursorxpos

		ldy #$04
		jsr ui_getelementdata_2

		clc
		ldy #$04								; get pointer to cursor pos
		lda (zpptr1),y
		adc #$01
		sta (zpptr1),y
		iny
		lda (zpptr1),y
		adc #$00
		sta (zpptr1),y

		rts

uitextbox_decreasecursorxpos

		ldy #$04
		jsr ui_getelementdata_2

		sec
		ldy #$04								; get pointer to cursor pos
		lda (zpptr1),y
		sbc #$01
		sta (zpptr1),y
		iny
		lda (zpptr1),y
		sbc #$00
		sta (zpptr1),y

		rts

; ----------------------------------------------------------------------------------------------------

uitextbox_confine_cursor

		ldy #$04										; get cursor pos
		lda (zpptr1),y
		sta uitextbox_cursorpos+2
		iny
		lda (zpptr1),y
		sta uitextbox_cursorpos+3

		MATH_POSITIVE uitextbox_cursorpos
		bcs :+											; positive -> ok

		ldy #$04										; negative -> underflow
		lda #$00
		sta (zpptr1),y
		iny
		sta (zpptr1),y
		rts

:		ldy #$06										; store text length
		lda (zpptr1),y
		sta uitextbox_textlength+2
		iny
		lda (zpptr1),y
		sta uitextbox_textlength+3

		MATH_BIGGER uitextbox_textlength, uitextbox_cursorpos, uitextbox_numerator
		bcs :+											; textlength > cursorpos -> ok

		ldy #$06										; cursorpos > textlength -> set cursorpos to textlength
		lda (zpptr1),y
		ldy #$04
		sta (zpptr1),y
		ldy #$07
		lda (zpptr1),y
		ldy #$05
		sta (zpptr1),y
		rts

:		ldy #$02
		lda (zpptr1),y
		sta uitextbox_startpos+2
		iny
		lda (zpptr1),y
		sta uitextbox_startpos+3

		MATH_SUB uitextbox_cursorpos, uitextbox_startpos, uitextbox_numerator
		MATH_POSITIVE uitextbox_numerator				; is cursorpos bigger than startpos?
		bcs :+											; yes, so not going left

		ldy #$04										; nope, put cursorpos in startpos so we move left
		lda (zpptr1),y
		ldy #$02
		sta (zpptr1),y
		ldy #$05
		lda (zpptr1),y
		ldy #$03
		sta (zpptr1),y
		rts

:		ldy #UIELEMENT::width							; compare with width
		lda (zpptr0),y
		sta uitextbox_boxwidth+2
		MATH_BIGGER uitextbox_numerator, uitextbox_boxwidth, uitextbox_denominator
		bcs :+											; ok if < boxwidth
		rts

:		MATH_SUB uitextbox_cursorpos, uitextbox_boxwidth, uitextbox_denominator
		clc
		ldy #$02										; put in startpos
		lda uitextbox_denominator+2
		adc #$01
		sta (zpptr1),y
		iny
		lda uitextbox_denominator+3
		adc #$00
		sta (zpptr1),y

		rts


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
		lda #$10										; black background
		sta [uidraw_colptr],z
		inz
		inz
		dex
		bne :-

		rts

uitextbox_drawreleased

		jsr uidraw_set_draw_position

		ldy #$0a										; get pointer to text
		jsr ui_getelementdata_2

		ldy #UIELEMENT::width
		sec
		lda (zpptr0),y
		sbc #$02
		tax

		ldy #$02										; get start pos
		lda (zpptr1),y
		tay

		ldz #$00
:		lda (zpptr2),y
		beq :+
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz
		iny
		dex
 		bpl :-
:
    	rts

; ----------------------------------------------------------------------------------------------------

uitextbox_updatecursor

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

		ldy #$04										; position of cursor in text
		jsr ui_getelementdata_2

		lda zpptr2+0
		sec
		ldy #$02										; subtract start pos
		sbc (zpptr1),y

		asl
		asl
		asl

		clc
		adc uikeyboard_cursorxpos+0
		sta uikeyboard_cursorxpos+0
		lda uikeyboard_cursorxpos+1
		adc #$00
		sta uikeyboard_cursorxpos+1

		rts

; ----------------------------------------------------------------------------------------------------
