; ----------------------------------------------------------------------------------------------------

uisequenceview_patternindex			.byte 0
uisequenceview_numpatterns			.byte 8

uisequenceview_current_draw_pos		.byte 0
uisequenceview_startpos				.byte 0
uisequenceview_middlepos			.byte 0
uisequenceview_rowpos				.byte 0

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

uisequenceview_longpress
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
		jsr uisequenceview_drawlistreleased
		rts

; ----------------------------------------------------------------------------------------------------

uisequenceview_drawbkgreleased

		jsr uidraw_set_draw_position

		ldy #UIELEMENT::width
		lda (zpptr0),y
		sta uidraw_width
		ldy #UIELEMENT::height
		lda (zpptr0),y
		sec
		sbc #$01
		sta uidraw_height

:		ldx uidraw_width
		ldz #$00
:		lda #$20
		sta [uidraw_scrptr],z
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

uisequenceview_drawlistreleased

		jsr uidraw_set_draw_position

		ldy #$02										; put scrollbar1_data into zpptr2
		jsr ui_getelementdata_2

		lda uidraw_height								; $0f
		lsr
		sta uisequenceview_middlepos					; $07

		ldy #$02										; store startpos
		lda (zpptr2),y
		sta uisequenceview_startpos

		ldy #$04										; put sequencedata into zpptr2
		jsr ui_getelementdata_2

		sec
		lda uisequenceview_startpos						; add startpos to listboxtxt pointer
		sbc uisequenceview_middlepos
		sta uisequenceview_current_draw_pos
		bpl :+
		lda #$00
:		clc
		adc zpptr2+0
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

		lda #$00
		sta uisequenceview_rowpos

uisequenceview_drawlistreleased_loop								; start drawing the list

		ldy #$00
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1

		lda uisequenceview_current_draw_pos
		bpl :+

		jsr uisequenceview_drawemptyline							; before start of pattern draw empty lines
		jmp uisequenceview_increaserow

:		lda zpptrtmp+0
		cmp #$ff
		bne :+

		jsr uisequenceview_drawemptyline							; after end of pattern draw empty lines
		jmp uisequenceview_increaserow

:		lda uisequenceview_rowpos
		cmp uisequenceview_middlepos
		bne :+
		jsr uisequenceview_drawmiddleline
		jmp uisequenceview_increasepointerandrow

:		jsr uisequenceview_drawnonmiddleline

uisequenceview_increasepointerandrow
		clc
		lda zpptr2+0
		adc #$01
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

uisequenceview_increaserow
		jsr uidraw_increase_row
		inc uisequenceview_current_draw_pos
		inc uisequenceview_rowpos

		dec uidraw_height
		lda uidraw_height
		beq :+
		jmp uisequenceview_drawlistreleased_loop

:		rts

; ----------------------------------------------------------------------------------------------------

uisequenceview_drawemptyline

		ldx uidraw_width								; clear line
		ldz #$00
:		lda #$20
		clc
		adc #$80
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz
		dex
		bne :-
		rts

; ----------------------------------------------------------------------------------------------------

uisequenceview_drawnonmiddleline

		ldz #$00
		lda uisequenceview_current_draw_pos
		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodec,x
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz

		lda uisequenceview_current_draw_pos
		and #$0f
		tax
		lda hextodec,x
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz

		lda #$20
		sta [uidraw_scrptr],z
		inz
		inz

		ldx #$02
:		lda zpptrtmp+0
		sta [uidraw_scrptr],z
		lda #$10
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		dex
		bne :-

		rts

; ----------------------------------------------------------------------------------------------------

uisequenceview_drawmiddleline

		ldz #$00
		lda uisequenceview_current_draw_pos
		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodec,x
		sta [uidraw_scrptr],z
		lda #$08
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz

		lda uisequenceview_current_draw_pos
		and #$0f
		tax
		lda hextodec,x
		sta [uidraw_scrptr],z
		lda #$08
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz

		lda #$20
		sta [uidraw_scrptr],z
		inz
		inz

		ldx #$02
:		lda zpptrtmp+0
		sta [uidraw_scrptr],z
		lda #$08
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		dex
		bne :-

		rts

; ----------------------------------------------------------------------------------------------------
