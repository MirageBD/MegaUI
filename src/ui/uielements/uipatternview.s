; ----------------------------------------------------------------------------------------------------

uipatternview_startpos					.byte 0
uipatternview_current_draw_pos			.byte 0
uipatternview_middlepos					.byte 0
uipatternview_rowpos					.byte 0
uipatternview_columninchannelindex		.byte 0
uipatternview_columnindex				.byte 0
uipatternview_cursorstart				.byte 0
uipatternview_cursorend					.byte 5
uipatternview_patternptr				.dword 0
uipatternview_patternrow				.byte 0

uipatternview_storedstartpos			.byte 0

uipatternview_storepositions
		ldy #$02										; put scrollbar1_data into zpptr2
		jsr ui_getelementdata_2

		ldy #$02										; store startpos
		lda (zpptr2),y
		sta uipatternview_storedstartpos

		rts

uipatternview_restorepositions
		ldy #$02										; put scrollbar1_data into zpptr2
		jsr ui_getelementdata_2

		ldy #$02										; restore startpos
		lda uipatternview_storedstartpos
		sta (zpptr2),y

		rts

upv_columnstarts
		.byte      0,      6,      11,      16,      19
		.byte 25 + 0, 25 + 6, 25 + 11, 25 + 16, 25 + 19
		.byte 50 + 0, 50 + 6, 50 + 11, 50 + 16, 50 + 19
		.byte 75 + 0, 75 + 6, 75 + 11, 75 + 16, 75 + 19

upv_columnends		
		.byte      5,      10,      15,      18,      21
		.byte 25 + 5, 25 + 10, 25 + 15, 25 + 18, 25 + 21
		.byte 50 + 5, 50 + 10, 50 + 15, 50 + 18, 50 + 21
		.byte 75 + 5, 75 + 10, 75 + 15, 75 + 18, 75 + 21

upv_reversecolumnlookup

		; "... .. .. ...    "    4*17-4 = 64 wide    4*13+3*4 = 64 wide
		.byte    0,    0,    0,    1,    1,    1,    2,    2,    2,    3,    3,    4,    4,    4,    4,    4,    4
		.byte  5+0,  5+0,  5+0,  5+1,  5+1,  5+1,  5+2,  5+2,  5+2,  5+3,  5+3,  5+4,  5+4,  5+4,  5+4,  5+4,  5+4
		.byte 10+0, 10+0, 10+0, 10+1, 10+1, 10+1, 10+2, 10+2, 10+2, 10+3, 10+3, 10+4, 10+4, 10+4, 10+4, 10+4, 10+4
		.byte 15+0, 15+0, 15+0, 15+1, 15+1, 15+1, 15+2, 15+2, 15+2, 15+3, 15+3, 15+4, 15+4

upv_reversecolumninchannellookup

		; "... .. .. ...    "    4*17-4 = 64 wide    4*13+3*4 = 64 wide
		.byte    0,    0,    0,    1,    1,    1,    2,    2,    2,    3,    3,    4,    4,    4,    4,    4,    4
		.byte    0,    0,    0,    1,    1,    1,    2,    2,    2,    3,    3,    4,    4,    4,    4,    4,    4
		.byte    0,    0,    0,    1,    1,    1,    2,    2,    2,    3,    3,    4,    4,    4,    4,    4,    4
		.byte    0,    0,    0,    1,    1,    1,    2,    2,    2,    3,    3,    4,    4,    4,    4,    4,    4

upv_reversecolumnfoolookup
		.byte    0, 1, 2, 3, 4
		.byte    0, 1, 2, 3, 4
		.byte    0, 1, 2, 3, 4
		.byte    0, 1, 2, 3, 4

; ----------------------------------------------------------------------------------------------------

uipatternview_update
		ldz cntPepSeqP
		lda	[ptrPepMSeq],z
		asl
		asl
		tax

		lda	adrPepPtn0+0,x
		sta	uipatternview_patternptr+0
		lda	adrPepPtn0+1,x
		sta	uipatternview_patternptr+1
		lda	adrPepPtn0+2,x
		sta	uipatternview_patternptr+2
		lda	adrPepPtn0+3,x
		sta	uipatternview_patternptr+3

		lda cntPepPRow
		sta uipatternview_patternrow

		jsr uipatternview_decodepattern

		lda peppitoPlaying
		bne :+
		rts

:		ldy #$02										; put scrollbar1_data into zpptr2
		jsr ui_getelementdata_2

		ldy #$02										; store startpos
		lda uipatternview_patternrow
		sta (zpptr2),y

		jsr uielement_calluifunc

		rts

; ----------------------------------------------------------------------------------------------------

uipatternview_clearpattern

		lda uipatternview_patternptr+0
		sta zpptrtmp+0
		lda uipatternview_patternptr+1
		sta zpptrtmp+1
		lda uipatternview_patternptr+2
		sta zpptrtmp+2
		lda uipatternview_patternptr+3
		sta zpptrtmp+3

		ldx #$00

:		ldz #$00									; clear highest 4 bits of note
		lda #$00
:		sta [zpptrtmp],z
		inz
		bne :-

		clc
		lda zpptrtmp+1
		adc #$01
		sta zpptrtmp+1

		inx
		cpx #16
		bne :--

		rts
; ----------------------------------------------------------------------------------------------------

uipatternview_encodepattern

		lda uipatternview_patternptr+0
		sta zpptrtmp+0
		lda uipatternview_patternptr+1
		sta zpptrtmp+1
		lda uipatternview_patternptr+2
		sta zpptrtmp+2
		lda uipatternview_patternptr+3
		sta zpptrtmp+3

		lda #<tvboxtxt0
		sta zpptr2+0
		lda #>tvboxtxt0
		sta zpptr2+1

		lda #$00
		sta upv_encoderow

upvep_rowloop
		lda #$00
		sta upv_encodechannel

upvep_channelloop

		ldz #$00									; clear highest 4 bits of note
		lda [zpptrtmp],z
		and #%11110000
		sta [zpptrtmp],z

		ldy #$02
		lda (zpptr2),y
		sta upv_encodenotestring+0
		iny
		lda (zpptr2),y
		sta upv_encodenotestring+1
		iny
		lda (zpptr2),y
		sta upv_encodenotestring+2

		ldy #$00									; look up note from string
upvep2	lda upv_times3table,y
		tax
		lda upv_encodenotestring+0
		cmp upv_tunenote+0,x
		beq :+
		iny
		bra upvep2
:		lda upv_encodenotestring+1
		cmp upv_tunenote+1,x
		beq :+
		iny
		bra upvep2
:		lda upv_encodenotestring+2
		cmp upv_tunenote+2,x
		beq :+
		iny
		bra upvep2

:		tya											; store note
		asl
		tay
		ldz #$01
		lda upv_tunefreq+0,y
		sta [zpptrtmp],z
		ldz #$00
		lda upv_tunefreq+1,y
		ora [zpptrtmp],z
		sta [zpptrtmp],z

		ldz #$00									; clear higher 4 bits of sample number
		lda [zpptrtmp],z
		and #%00001111
		sta [zpptrtmp],z

		ldy #$08									; get higher 4 bits of sample number
		lda (zpptr2),y
		tax
		lda upv_chartohex,x
		asl
		asl
		asl
		asl
		ldz #$00
		ora [zpptrtmp],z
		sta [zpptrtmp],z

		ldz #$02									; clear lower 4 bits of sample number
		lda [zpptrtmp],z
		and #%00001111
		sta [zpptrtmp],z

		ldy #$09									; get lower 4 bits of sample number
		lda (zpptr2),y
		tax
		lda upv_chartohex,x
		asl
		asl
		asl
		asl
		ldz #$02
		ora [zpptrtmp],z
		sta [zpptrtmp],z

		ldz #$02									; clear effect command
		lda [zpptrtmp],z
		and #%11110000
		sta [zpptrtmp],z

		ldy #$12									; get effect
		lda (zpptr2),y
		tax
		lda upv_chartohex,x
		ldz #$02
		ora [zpptrtmp],z
		sta [zpptrtmp],z

		ldz #$03									; clear effect data
		lda #$00
		sta [zpptrtmp],z

		ldy #$13									; get higher 4 bits of sample number
		lda (zpptr2),y
		tax
		lda upv_chartohex,x
		asl
		asl
		asl
		asl
		ldz #$03
		ora [zpptrtmp],z
		sta [zpptrtmp],z

		ldy #$14									; get higher 4 bits of sample number
		lda (zpptr2),y
		tax
		lda upv_chartohex,x
		ldz #$03
		ora [zpptrtmp],z
		sta [zpptrtmp],z

		clc											; add 4 to get to second channel
		lda zpptrtmp+0
		adc #$04
		sta zpptrtmp+0
		lda zpptrtmp+1
		adc #$00
		sta zpptrtmp+1
		lda zpptrtmp+2
		adc #$00
		sta zpptrtmp+2
		lda zpptrtmp+3
		adc #$00
		sta zpptrtmp+3

		clc											; add 25 to get to second channel
		lda zpptr2+0
		adc #25
		sta zpptr2+0
		lda zpptr2+1
		adc #0
		sta zpptr2+1

		inc upv_encodechannel
		lda upv_encodechannel
		cmp #$04
		beq :+

		jmp upvep_channelloop

:		sec											; subtract 3 to skip trailing zero byte
		lda zpptr2+0
		sbc #03
		sta zpptr2+0
		lda zpptr2+1
		sbc #0
		sta zpptr2+1

		inc upv_encoderow
		lda upv_encoderow
		cmp #64
		beq :+

		jmp upvep_rowloop

:		jsr uipatternview_decodepattern
		rts

upv_encodechannel			.byte 0
upv_encoderow				.byte 0
upv_encodesample			.byte 0
upv_encodenoteperiod		.word 0
upv_encodeeffectcommand		.byte 0
upv_encodeeffectdata		.byte 0
upv_encodenotestring		.byte 0, 0, 0

; ----------------------------------------------------------------------------------------------------

uipatternview_decodepattern

		lda uipatternview_patternptr+0
		sta zpptrtmp+0
		lda uipatternview_patternptr+1
		sta zpptrtmp+1
		lda uipatternview_patternptr+2
		sta zpptrtmp+2
		lda uipatternview_patternptr+3
		sta zpptrtmp+3

		lda #<tvboxtxt0
		sta zpptr2+0
		lda #>tvboxtxt0
		sta zpptr2+1

		lda #$00
		sta upv_decoderow

upvdp_rowloop
		lda #$00
		sta upv_decodechannel

upvdp_channelloop
		ldy #$00

		ldz #$00									; get sample number
		lda [zpptrtmp],z
		and #$f0
		sta upv_decodesample
		ldz #$02
		lda [zpptrtmp],z
		lsr
		lsr
		lsr
		lsr
		ora upv_decodesample
		sta upv_decodesample

		ldz #$01									; get note period
		lda [zpptrtmp],z
		sta upv_decodenoteperiod+0
		ldz #$00
		lda [zpptrtmp],z
		and #$0f
		sta upv_decodenoteperiod+1

		ldz #$02									; get effect command
		lda [zpptrtmp],z
		and #$0f
		sta upv_decodeeffectcommand
		ldz #$03									; get effect data
		lda [zpptrtmp],z
		sta upv_decodeeffectdata

		ldx #$00									; find string for note period
:		lda upv_tunefreq+0,x
		cmp upv_decodenoteperiod+0
		bne :+
		lda upv_tunefreq+1,x
		cmp upv_decodenoteperiod+1
		beq :++
:		inx
		inx
		cpx #36*2
		bne :--

:		txa
		lsr
		tax
		lda upv_times3table,x
		tax

		lda upv_tunenote+0,x						; write note string to list
		cmp #$2e
		bne :+

		lda #$ff									; write gray note colour code to list
		sta (zpptr2),y
		iny
		lda #$04
		sta (zpptr2),y
		iny
		bra :++

:		lda #$ff									; write note colour code to list
		sta (zpptr2),y
		iny
		lda #$0c
		sta (zpptr2),y
		iny

:		lda upv_tunenote+0,x						; write note string to list
		sta (zpptr2),y
		iny
		lda upv_tunenote+1,x
		sta (zpptr2),y
		iny
		lda upv_tunenote+2,x
		sta (zpptr2),y
		iny

		iny

		lda upv_decodesample						; write sample num to list
		bne :+

		lda #$ff									; write gray sample colour code to list
		sta (zpptr2),y
		iny
		lda #$04
		sta (zpptr2),y
		iny
		bra :++

:		lda #$ff									; write sample colour code to list
		sta (zpptr2),y
		iny
		lda #$31
		sta (zpptr2),y
		iny

:		lda upv_decodesample						; write sample num to list
		beq :+
		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodec,x
		sta (zpptr2),y
		iny
		lda upv_decodesample
		and #$0f
		tax
		lda hextodec,x
		sta (zpptr2),y
		iny
		bra :++

:		lda #$2e									; write .. if sample number is 0
		sta (zpptr2),y
		iny
		sta (zpptr2),y
		iny

:		iny

		lda #$ff									; write volume colour code to list
		sta (zpptr2),y
		iny
		lda #$04
		sta (zpptr2),y
		iny

		lda #$2d									; write volume to list
		sta (zpptr2),y
		iny
		sta (zpptr2),y
		iny

		iny

		lda #$ff									; write effect command colour code to list
		sta (zpptr2),y
		iny
		ldx upv_decodeeffectcommand
		lda upv_effectcommandtocolour,x
		sta (zpptr2),y
		iny

		lda upv_decodeeffectcommand					; write effect command to list
		beq :+
		tax
		lda hextodec,x
		sta (zpptr2),y
		iny
		bra :++

:		lda #$2e									; write ... if effect command is 0
		sta (zpptr2),y
		iny
		sta (zpptr2),y
		iny
		sta (zpptr2),y
		iny
		bra :++

:		lda upv_decodeeffectdata					; write effect data to list
		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodec,x
		sta (zpptr2),y
		iny
		lda upv_decodeeffectdata
		and #$0f
		tax
		lda hextodec,x
		sta (zpptr2),y
		iny

:		clc											; add 4 to get to second channel
		lda zpptrtmp+0
		adc #$04
		sta zpptrtmp+0
		lda zpptrtmp+1
		adc #$00
		sta zpptrtmp+1
		lda zpptrtmp+2
		adc #$00
		sta zpptrtmp+2
		lda zpptrtmp+3
		adc #$00
		sta zpptrtmp+3

		clc											; add 25 to get to second channel
		lda zpptr2+0
		adc #25
		sta zpptr2+0
		lda zpptr2+1
		adc #0
		sta zpptr2+1

		inc upv_decodechannel
		lda upv_decodechannel
		cmp #$04
		beq :+

		jmp upvdp_channelloop

:		sec											; subtract 3 to skip trailing zero byte
		lda zpptr2+0
		sbc #03
		sta zpptr2+0
		lda zpptr2+1
		sbc #0
		sta zpptr2+1

		inc upv_decoderow
		lda upv_decoderow
		cmp #64
		beq :+

		jmp upvdp_rowloop

:		rts

upv_decodechannel			.byte 0
upv_decoderow				.byte 0
upv_decodesample			.byte 0
upv_decodenoteperiod		.word 0
upv_decodeeffectcommand		.byte 0
upv_decodeeffectdata		.byte 0
upv_decodenotestring		.byte 0, 0, 0

; ----------------------------------------------------------------------------------------------------

uipatternview_layout
		jsr uielement_layout
		rts

uipatternview_focus
		rts

uipatternview_enter
		rts

uipatternview_leave
		rts

uipatternview_move
		rts

uipatternview_press
		rts

uipatternview_doubleclick
		jsr uipatternview_release
		rts

uipatternview_keypress
		ldx keyboard_pressedeventarg
		lda keyboard_keytypes,x
		cmp #UIKEYBOARD_KEYTYPE::function
		bne :+
		rts

:		txa		

		cmp #KEYBOARD_CURSORDOWN
		bne :+
		jsr uipatternview_increase_selection
		jsr uipatternview_confinevertical
		jsr uielement_calluifunc
		rts

:		cmp #KEYBOARD_CURSORUP
		bne :+
		jsr uipatternview_decrease_selection
		jsr uipatternview_confinevertical
		jsr uielement_calluifunc
		rts
:		
		cmp #KEYBOARD_CURSORLEFT
		bne :+
		dec uipatternview_columnindex
		jsr uipatternview_setvariablesfromindex
		ldx uipatternview_columnindex
		lda upv_reversecolumnfoolookup,x
		sta uipatternview_columninchannelindex
		jsr uielement_calluifunc
		rts

:		cmp #KEYBOARD_CURSORRIGHT
		bne :+
		inc uipatternview_columnindex
		jsr uipatternview_setvariablesfromindex
		ldx uipatternview_columnindex
		lda upv_reversecolumnfoolookup,x
		sta uipatternview_columninchannelindex
		jsr uielement_calluifunc
		rts

:		lda uipatternview_columninchannelindex
		beq uipatternview_keyincolumn0
		cmp #$01
		beq uipatternview_keyincolumn1
		cmp #$02
		beq uipatternview_keyincolumn2
		cmp #$03
		beq uipatternview_keyincolumn3
		cmp #$04
		beq uipatternview_keyincolumn4
		rts

uipatternview_keyincolumn0
		jsr upv_insert_note
		jsr uielement_calluifunc
		jsr uipatternview_encodepattern
		rts

uipatternview_keyincolumn1		
		jsr upv_insert_sample
		jsr uielement_calluifunc
		jsr uipatternview_encodepattern
		rts

uipatternview_keyincolumn2
		rts

uipatternview_keyincolumn3
		jsr upv_insert_effect
		jsr uipatternview_encodepattern
		rts

uipatternview_keyincolumn4
		jsr upv_insert_effectdata
		jsr uielement_calluifunc
		jsr uipatternview_encodepattern
		rts

; ----------------------------------------------------------------------------------------------------

uipatternview_keyrelease
		rts

; ----------------------------------------------------------------------------------------------------

upv_prepareinsert

		ldx uipatternview_startpos
		lda upv_times97tablelo,x
		sta zpptr2+0
		lda upv_times97tablehi,x
		sta zpptr2+1

		clc
		lda zpptr2+0
		adc #<tvboxtxt0
		sta zpptr2+0
		lda zpptr2+1
		adc #>tvboxtxt0
		sta zpptr2+1

		clc
		lda zpptr2+0
		adc uipatternview_cursorstart
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1
		rts

; ----------------------------------------------------------------------------------------------------

upv_insert_note

		jsr upv_prepareinsert

		lda keyboard_pressedeventarg
		cmp #KEYBOARD_INSERTDEL
		bne :+
		lda #$2e
		ldy #$02
		sta (zpptr2),y
		iny
		sta (zpptr2),y
		iny
		sta (zpptr2),y
		rts

:		ldx keyboard_pressedeventarg
		lda upv_tonoteindex,x
		tax
		lda upv_times3table,x
		tax

		ldy #$02
		lda upv_tunenote,x
		sta (zpptr2),y
		inx
		iny
		lda upv_tunenote,x
		sta (zpptr2),y
		inx
		iny
		lda upv_tunenote,x
		sta (zpptr2),y

		rts

; ----------------------------------------------------------------------------------------------------

upv_insert_sample

		jsr upv_prepareinsert

		lda keyboard_pressedeventarg
		cmp #KEYBOARD_INSERTDEL
		bne :+
		lda #$2e
		ldy #$02
		sta (zpptr2),y
		iny
		sta (zpptr2),y
		rts

:		ldy #$03
		lda (zpptr2),y
		ldy #$02
		sta (zpptr2),y

		ldy #$03
		ldx keyboard_pressedeventarg
		lda keyboard_toascii,x
		sta (zpptr2),y
		rts

; ----------------------------------------------------------------------------------------------------

upv_insert_effect

		jsr upv_prepareinsert

		lda keyboard_pressedeventarg
		cmp #KEYBOARD_INSERTDEL
		bne :+
		ldy #$02
		lda #$2e
		sta (zpptr2),y
		rts

:		ldy #$02
		ldx keyboard_pressedeventarg
		lda keyboard_toascii,x
		sta (zpptr2),y
		rts

; ----------------------------------------------------------------------------------------------------

upv_insert_effectdata

		jsr upv_prepareinsert

		lda keyboard_pressedeventarg
		cmp #KEYBOARD_INSERTDEL
		bne :+
		lda #$2e
		ldy #$00
		sta (zpptr2),y
		iny
		sta (zpptr2),y
		rts

:		ldy #$01
		lda (zpptr2),y
		ldy #$00
		sta (zpptr2),y

		ldy #$01
		ldx keyboard_pressedeventarg
		lda keyboard_toascii,x
		sta (zpptr2),y
		rts

; ----------------------------------------------------------------------------------------------------

uipatternview_draw
		;jsr uipatternview_drawbkgreleased
		jsr uipatternview_drawlistreleased
		rts

uipatternview_release
		jsr uipatternview_setselectedindex
		jsr uipatternview_confinevertical
		jsr uipatternview_draw

		jsr uielement_calluifunc

		rts

uipatternview_setselectedindex
		jsr uimouse_calculate_pos_in_uielement

		ldy #$02										; put scrollbar1_data in zpptr2
		jsr ui_getelementdata_2

		ldy #UIELEMENT::height
		lda (zpptr0),y
		lsr
		sta uipatternview_middlepos

		lda uimouse_uielement_ypos+0					; set selected index + added start address
		lsr
		lsr
		lsr
		clc
		ldy #$02
		adc (zpptr2),y
		sec
		sbc uipatternview_middlepos
		ldy #$02
		sta (zpptr2),y

		lsr uimouse_uielement_xpos+1
		ror uimouse_uielement_xpos+0
		lsr uimouse_uielement_xpos+1
		ror uimouse_uielement_xpos+0
		lsr uimouse_uielement_xpos+1
		ror uimouse_uielement_xpos+0
		ldx uimouse_uielement_xpos+0

		lda upv_reversecolumninchannellookup,x
		sta uipatternview_columninchannelindex

		lda upv_reversecolumnlookup,x
		sta uipatternview_columnindex
		
		jsr uipatternview_setvariablesfromindex

		rts

; ----------------------------------------------------------------------------------------------------

uipatternview_setvariablesfromindex

		jsr uipatternview_confinehorizontal

		ldx uipatternview_columnindex
		lda upv_columnstarts,x
		sta uipatternview_cursorstart
		lda upv_columnends,x
		sta uipatternview_cursorend
		rts

; ----------------------------------------------------------------------------------------------------

uipatternview_increase_selection
		ldy #$02										; put scrollbar1_data in zpptr2
		jsr ui_getelementdata_2

		clc
		ldy #$02										; get start index
		lda (zpptr2),y
		adc #$01
		sta (zpptr2),y

		rts

uipatternview_decrease_selection
		ldy #$02										; put scrollbar1_data in zpptr2
		jsr ui_getelementdata_2

		sec
		ldy #$02										; get start index
		lda (zpptr2),y
		sbc #$01
		sta (zpptr2),y

		rts

uipatternview_confinehorizontal

		lda uipatternview_columnindex
		bpl :+
		lda #$00
		sta uipatternview_columnindex
:		cmp #20
		bmi :+
		lda #19
		sta uipatternview_columnindex
:		rts

uipatternview_confinevertical
		ldy #$02										; put scrollbar1_data in zpptr2
		jsr ui_getelementdata_2

		ldy #$02										; get start index
		lda (zpptr2),y
		bpl :+											; if negative then it's definitely wrong
		lda #$00
		sta (zpptr2),y

:		cmp #64											; compare with pattern height
		bmi :+											; ok when smaller
		lda #64
		sec
		sbc #$01
		ldy #$02										; get start
		sta (zpptr2),y
		rts

:		sec												; get selection index and subtract startpos
		ldy #$02
		sbc (zpptr2),y

		bpl :+											; ok when > 0
		ldy #$02										; when < get start index and put in startpos
		lda (zpptr2),y
		ldy #$02
		sta (zpptr2),y
		rts

:		ldy #UIELEMENT::height							; compare with height
		cmp (zpptr0),y
		bpl :+											; ok if < height
		rts

:		ldy #$02										; get start index
		lda (zpptr2),y
		sec
		ldy #UIELEMENT::height
		sbc (zpptr0),y
		clc
		adc #$01
		ldy #$02
		sta (zpptr2),y									; put in startpos

		rts

; ----------------------------------------------------------------------------------------------------

uipatternview_drawbkgreleased

		jsr uidraw_set_draw_position

		ldy #UIELEMENT::width
		lda (zpptr0),y
		sta uidraw_width
		ldy #UIELEMENT::height
		lda (zpptr0),y
		sta uidraw_height

:		ldx uidraw_width
		ldz #$00
:		lda #$f0										; dark blue background
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

uipatternview_drawlistreleased

		jsr uidraw_set_draw_position

		ldy #$02										; put scrollbar1_data into zpptr2
		jsr ui_getelementdata_2

		lda uidraw_height								; $0f
		lsr
		sta uipatternview_middlepos						; $07

		ldy #$02										; store startpos
		lda (zpptr2),y
		sta uipatternview_startpos

		ldy #$04										; put listboxtxt into zpptr2
		jsr ui_getelementdata_2

		sec
		lda uipatternview_startpos						; add startpos to listboxtxt pointer
		sbc uipatternview_middlepos
		sta uipatternview_current_draw_pos
		bpl :+
		lda #$00
:		asl
		clc
		adc zpptr2+0
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

		lda #$00
		sta uipatternview_rowpos

uipatternview_drawlistreleased_loop						; start drawing the list

		ldy #$00
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1

		lda uipatternview_current_draw_pos
		bpl :+

		jsr uipatternview_drawemptyline							; before start of pattern draw empty lines
		jmp uipatternview_increaserow

:		lda zpptrtmp+1
		cmp #$ff
		bne :+
		
		jsr uipatternview_drawemptyline							; after end of pattern draw empty lines
		jmp uipatternview_increaserow

:		lda uipatternview_rowpos
		cmp uipatternview_middlepos
		bne :+
		jsr uipatternview_drawmiddleline
		jmp uipatternview_increasepointerandrow

:		jsr uipatternview_drawnonmiddleline

uipatternview_increasepointerandrow
		clc
		lda zpptr2+0
		adc #$02
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

uipatternview_increaserow
		jsr uidraw_increase_row
		inc uipatternview_current_draw_pos
		inc uipatternview_rowpos

		dec uidraw_height
		lda uidraw_height
		beq :+
		jmp uipatternview_drawlistreleased_loop

:		rts

; ----------------------------------------------------------------------------------------------------

uipatternview_drawemptyline

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

uipatternview_drawnonmiddleline

		ldy #$00
		ldz #$00
:		lda (zpptrtmp),y
		beq :++
		cmp #$ff
		bne :+
		iny
		lda (zpptrtmp),y
		sta upvdnml+1
		iny
		bra :-

:		clc
		adc #$80
		sta [uidraw_scrptr],z
upvdnml	lda #$00
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		iny
 		bra :--

:		rts

; ----------------------------------------------------------------------------------------------------

uipatternview_drawmiddleline

		ldy #$00
		ldz #$00
:
		cpy uipatternview_cursorstart
		bmi :+
		cpy uipatternview_cursorend
		bpl :+

		lda #$00
		sta upvdml1+1
		lda #$06
		sta upvdml2+1
		lda (zpptrtmp),y
		beq uipatternview_drawmiddleline_end
		cmp #$ff
		bne :+++
		iny
		iny
		bra :++

:		lda #$c0
		sta upvdml1+1
:		lda (zpptrtmp),y
		beq uipatternview_drawmiddleline_end
		cmp #$ff
		bne :+
		iny
		lda (zpptrtmp),y
		sta upvdml2+1
		iny
		bra :-

:		clc
upvdml1	adc #$c0
		sta [uidraw_scrptr],z
upvdml2	lda #$00
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		iny
 		bra :----

uipatternview_drawmiddleline_end
		rts

; ----------------------------------------------------------------------------------------------------

upv_chartohex
		.byte 0, 10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0
		.byte 0,  0,  0,  0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		.byte 0,  0,  0,  0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		.byte 0,  1,  2,  3,  4,  5,  6, 7, 8, 9, 0, 0, 0, 0, 0, 0

upv_fontcolour
		.byte $f0

upv_tunefreq
		.word 0
		.word 856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 453
		.word 428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226
		.word 214, 202, 190, 180, 170, 160, 151, 143, 135, 127, 120, 113

upv_tunenote
		; "C-1", "C#1", "D-1", "D#1", "E-1", "F-1", "F#1", "G-1", "G#1", "A-1", "A#1", "B-1"
		; "C-2", "C#2", "D-2", "D#2", "E-2", "F-2", "F#2", "G-2", "G#2", "A-2", "A#2", "B-2"
		; "C-3", "C#3", "D-3", "D#3", "E-3", "F-3", "F#3", "G-3", "G#3", "A-3", "A#3", "B-3"

		.byte "..."
		.byte $03, $2d, $31,    $03, $23, $31,    $04, $2d, $31,    $04, $23, $31,    $05, $2d, $31,    $06, $2d, $31,    $06, $23, $31,    $07, $2d, $31,    $07, $23, $31,    $01, $2d, $31,    $01, $23, $31,    $02, $2d, $31
		.byte $03, $2d, $32,    $03, $23, $32,    $04, $2d, $32,    $04, $23, $32,    $05, $2d, $32,    $06, $2d, $32,    $06, $23, $32,    $07, $2d, $32,    $07, $23, $32,    $01, $2d, $32,    $01, $23, $32,    $02, $2d, $32
		.byte $03, $2d, $33,    $03, $23, $33,    $04, $2d, $33,    $04, $23, $33,    $05, $2d, $33,    $06, $2d, $33,    $06, $23, $33,    $07, $2d, $33,    $07, $23, $33,    $01, $2d, $33,    $01, $23, $33,    $02, $2d, $33

upv_times3table
.repeat 37, I
		.byte I*3
.endrepeat

upv_times97tablelo
.repeat 64, I
		.byte <(I*97)
.endrepeat

upv_times97tablehi
.repeat 64, I
		.byte >(I*97)
.endrepeat

upv_effectcommandtocolour
		.byte $04, $be, $be, $be, $be, $be, $be, $be, $be, $be, $be, $3d, $be, $3d, $be, $3d

;         0        1        2         3       4         5       6        7
; +---+--------+--------+--------+--------+--------+--------+--------+--------+
; | 0 | INST   | RETURN | CURS → | F7     | F1     | F3     | F5     | CURS ↓ |
; |   | DEL    |        |        |        |        |        |        |        |
; +---+--------+--------+--------+--------+--------+--------+--------+--------+
; | 1 | 3      | W      | A      | 4      | Z      | S      | E      | SHIFT  |
; |   |        |        |        |        |        |        |        | left   |
; +---+--------+--------+--------+--------+--------+--------+--------+--------+
; | 2 | 5      | R      | D      | 6      | C      | F      | T      | X      |
; |   |        |        |        |        |        |        |        |        |
; +---+--------+--------+--------+--------+--------+--------+--------+--------+
; | 3 | 7      | Y      | G      | 8      | B      | H      | U      | V      |
; |   |        |        |        |        |        |        |        |        |
; +---+--------+--------+--------+--------+--------+--------+--------+--------+
; | 4 | 9      | I      | J      | 0      | M      | K      | O      | N      |
; |   |        |        |        |        |        |        |        |        |
; +---+--------+--------+--------+--------+--------+--------+--------+--------+
; | 5 | +      | P      | L      | -      | .      | :      | @      | ,      |
; |   |        |        |        |        |        |        |        |        |
; +---+--------+--------+--------+--------+--------+--------+--------+--------+
; | 6 | £      | *      | ;      | CLR    | SHIFT  | =      | ↑      | /      |
; |   |        |        |        | HOME   | right  |        |        |        |
; +---+--------+--------+--------+--------+--------+--------+--------+--------+
; | 7 | 1      | ←      | CTRL   | 2      | SPC    | MEGA   | Q      | RUN    |
; |   |        |        |        |        |        |        |        | STOP   |
; +---+--------+--------+--------+--------+--------+--------+--------+--------+
; | 8 | NO     | TAB    | ALT    | HELP   | F9     | F11    | F13    | ESC    |
; |   | SCROLL |        |        |        |        |        |        |        |
; +---+--------+--------+--------+--------+--------+--------+--------+--------+

;          111 111111122222
; 123456789012 345678901234
; ZSXDCVGBHNJM Q2W3ER5T6Y7U

;  11111
;  34567
;  ,l.:/

upv_tonoteindex
;              0   1   2   3   4   5   6   7
		.byte  0,  0,  0,  0,  0,  0,  0,  0; 0
		.byte 16, 15,  0,  0,  1,  2, 17,  0; 1
		.byte 19, 18,  4, 21,  5,  0, 20,  3; 2
		.byte 23, 22,  7,  0,  8,  9, 24,  6; 3
		.byte  0,  0, 11,  0, 12,  0,  0, 10; 4
		.byte  0,  0, 14,  0, 15, 16,  0, 13; 5
		.byte  0,  0,  0,  0,  0,  0,  0, 17; 6
		.byte  0,  0,  0, 14,  0,  0, 13,  0; 7
		.byte  0,  0,  0,  0,  0,  0,  0,  0; 8

		.byte  0,  0,  0,  0,  0,  0,  0,  0; 9

; ----------------------------------------------------------------------------------------------------
