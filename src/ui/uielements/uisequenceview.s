; ----------------------------------------------------------------------------------------------------

uisequenceview_patternindex			.byte 0
uisequenceview_numpatterns			.byte 8

; ----------------------------------------------------------------------------------------------------

uisequenceview_update
		lda cntPepSeqP
		sta uisequenceview_patternindex

		lda valPepSLen
		sta uisequenceview_numpatterns

		rts

; ----------------------------------------------------------------------------------------------------

uisequenceview_layout
        jsr uielement_layout
    	rts

uisequenceview_hide
		;jsr uielement_hide
		rts

uisequenceview_focus
	    rts

uisequenceview_enter
	    rts

uisequenceview_leave
		rts

uisequenceview_move
		rts

uisequenceview_keypress
		lda keyboard_pressedeventarg
		cmp #KEYBOARD_INSERTDEL
		bne :+
		UICORE_CALLELEMENTFUNCTION tvlistbox, uipatternview_clearpattern
		rts

:		rts

uisequenceview_keyrelease
		rts

uisequenceview_press
    	rts

uisequenceview_doubleclick
		rts

uisequenceview_release

		jsr uimouse_calculate_pos_in_uielement

		lsr uimouse_uielement_xpos+1
		ror uimouse_uielement_xpos+0
		lsr uimouse_uielement_xpos+1
		ror uimouse_uielement_xpos+0
		lsr uimouse_uielement_xpos+1
		ror uimouse_uielement_xpos+0
		lda uimouse_uielement_xpos+0
		cmp uisequenceview_numpatterns
		bpl :+

		sta cntPepSeqP
		lda #$00
		sta cntPepPRow

:		rts

uisequenceview_draw
		jsr uisequenceview_drawbkgreleased
		jsr uisequenceview_drawpucksreleased
		rts

; ----------------------------------------------------------------------------------------------------

uisequenceview_drawbkgreleased

		jsr uidraw_set_draw_position

		ldy #UIELEMENT::width
		lda (zpptr0),y
		sta uidraw_width
		ldy #UIELEMENT::height
		lda (zpptr0),y
		sta uidraw_height
		dec uidraw_height

:		ldx uidraw_width
		ldz #$00
:		lda #$20
		sta [uidraw_scrptr],z
		lda #$00										; black background
		sta [uidraw_colptr],z
		inz
		inz
		dex
		bne :-

		jsr uidraw_increase_row

		dec uidraw_height
		lda uidraw_height
		bne :--

		rts

; ----------------------------------------------------------------------------------------------------

uisequenceview_drawpucksreleased

		jsr uidraw_set_draw_position

		ldy #$00
		ldz #$00
:		cpy uisequenceview_patternindex
		beq :+
		lda #$58
		bra :++
:		lda #$5a		
:		sta [uidraw_scrptr],z
		inz
		inz
		iny
		cpy uisequenceview_numpatterns
		bne :---

		jsr uidraw_increase_row

		ldy #$00
		ldz #$00
:		cpy uisequenceview_patternindex
		beq :+
		lda #$59
		bra :++
:		lda #$5b		
:		sta [uidraw_scrptr],z
		inz
		inz
		iny
		cpy uisequenceview_numpatterns
		bne :---

		rts

; ----------------------------------------------------------------------------------------------------
