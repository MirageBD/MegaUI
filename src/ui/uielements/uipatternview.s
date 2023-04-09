; ----------------------------------------------------------------------------------------------------

uipatternview_startpos				.byte 0
uipatternview_current_draw_pos		.byte 0
uipatternview_middlepos				.byte 0
uipatternview_rowpos					.byte 0

; ----------------------------------------------------------------------------------------------------

uipatternview_patternindex			.byte 0
uipatternview_patternptr				.dword 0
uipatternview_patternrow				.byte 0

; ----------------------------------------------------------------------------------------------------

uipatternview_update
		lda cntPepSeqP
		sta uipatternview_patternindex

		taz
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

:
		jsr ui_getelementdataptr_1						; get data ptr to zpptr1

		ldy #$02										; put scrollbar1_data into zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$02										; store startpos
		lda uipatternview_patternrow
		sta (zpptr2),y

		jsr uielement_calluifunc

		rts

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
		sta uipatternview_sample
		ldz #$02
		lda [zpptrtmp],z
		lsr
		lsr
		lsr
		lsr
		ora uipatternview_sample
		sta uipatternview_sample

		ldz #$01									; get note period
		lda [zpptrtmp],z
		sta uipatternview_noteperiod+0
		ldz #$00
		lda [zpptrtmp],z
		and #$0f
		sta uipatternview_noteperiod+1

		ldz #$02									; get effect command
		lda [zpptrtmp],z
		and #$0f
		sta uipatternview_effectcommand
		ldz #$03									; get effect data
		lda [zpptrtmp],z
		sta uipatternview_effectdata

		ldx #$00									; find string for note period
:		lda upv_tunefreq+0,x
		cmp uipatternview_noteperiod+0
		bne :+
		lda upv_tunefreq+1,x
		cmp uipatternview_noteperiod+1
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

		lda uipatternview_sample					; write sample num to list
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

:		lda uipatternview_sample					; write sample num to list
		beq :+
		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodec,x
		sta (zpptr2),y
		iny
		lda uipatternview_sample
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
		ldx uipatternview_effectcommand
		lda upv_effectcommandtocolour,x
		sta (zpptr2),y
		iny

		lda uipatternview_effectcommand				; write effect command to list
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

:		lda uipatternview_effectdata				; write effect data to list
		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodec,x
		sta (zpptr2),y
		iny
		lda uipatternview_effectdata
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

upv_decodechannel
		.byte 0

upv_decoderow
		.byte 0

uipatternview_sample
		.byte 0

uipatternview_noteperiod
		.word 0

uipatternview_effectcommand
		.byte 0

uipatternview_effectdata
		.byte 0

uipatternview_notestring
		.byte 0, 0, 0

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
		rts

uipatternview_keyrelease
		rts

uipatternview_keypress
		lda keyboard_pressedeventarg

		cmp KEYBOARD_CURSORDOWN
		bne :+
		jsr uipatternview_increase_selection
		jsr uipatternview_confine
		jsr uielement_calluifunc		
		rts

:		cmp KEYBOARD_CURSORUP
		bne :+
		jsr uipatternview_decrease_selection
		jsr uipatternview_confine
		jsr uielement_calluifunc		
:		rts

; ----------------------------------------------------------------------------------------------------

uipatternview_draw
		;jsr uipatternview_drawbkgreleased
		jsr uipatternview_drawlistreleased
		rts

uipatternview_release
		jsr uipatternview_setselectedindex
		jsr uipatternview_draw
		rts

uipatternview_setselectedindex
		jsr uimouse_calculate_pos_in_uielement

		jsr ui_getelementdataptr_1						; get data ptr to zpptr1

		ldy #$02										; put scrollbar1_data in zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

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

		rts

; ----------------------------------------------------------------------------------------------------

uipatternview_increase_selection
		jsr ui_getelementdataptr_1						; get data ptr to zpptr1

		ldy #$02										; put scrollbar1_data in zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		clc
		ldy #$04										; get selection index
		lda (zpptr2),y
		adc #$01
		sta (zpptr2),y

		rts

uipatternview_decrease_selection
		jsr ui_getelementdataptr_1						; get data ptr to zpptr1

		ldy #$02										; put scrollbar1_data in zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		sec
		ldy #$04										; get selection index
		lda (zpptr2),y
		sbc #$01
		sta (zpptr2),y

		rts

uipatternview_confine
		jsr ui_getelementdataptr_1						; get data ptr to zpptr1

		ldy #$02										; put scrollbar1_data in zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$04										; get selection index
		lda (zpptr2),y
		bpl :+											; if negative then it's definitely wrong
		lda #$00
		sta (zpptr2),y

:		ldy #$06
		cmp (zpptr2),y									; compare with numentries
		bmi :+											; ok when smaller
		lda (zpptr2),y
		sec
		sbc #$01
		ldy #$04										 ; get selection
		sta (zpptr2),y
		rts

:		sec												; get selection index and subtract startpos
		ldy #$02
		sbc (zpptr2),y

		bpl :+											; ok when > 0
		ldy #$04										; when < get selection index and put in startpos
		lda (zpptr2),y
		ldy #$02
		sta (zpptr2),y
		rts

:		ldy #UIELEMENT::height							; compare with height
		cmp (zpptr0),y
		bpl :+											; ok if < height
		rts

:		ldy #$04										; get selection index
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

		jsr ui_getelementdataptr_1						; get data ptr to zpptr1

		ldy #$02										; put scrollbar1_data into zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		lda uidraw_height								; $0f
		lsr
		sta uipatternview_middlepos						; $07

		ldy #$02										; store startpos
		lda (zpptr2),y
		sta uipatternview_startpos

		ldy #$04										; put listboxtxt into zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

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

		lda uipatternview_rowpos
		cmp uipatternview_middlepos
		bne :+
		lda #$c0
		sta upv_font
		lda #$f0
		sta upv_fontcolour
		bra :++

:		lda #$80
		sta upv_font
		lda #$f0
		sta upv_fontcolour

:		ldx uidraw_width								; clear line
		ldz #$00
:		lda #$20
		clc
		adc upv_font
		sta [uidraw_scrptr],z
		lda upv_fontcolour
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		dex
		bne :-

		lda uipatternview_current_draw_pos
		bmi uipatternview_increaserow

		lda zpptrtmp+1
		cmp #$ff
		beq uipatternview_increaserow

		ldy #$00
		ldz #$00
:		lda (zpptrtmp),y
		beq uipatternview_increasepointerandrow
		cmp #$ff
		bne :+
		iny
		lda (zpptrtmp),y
		sta upv_fontcolour
		iny
		bra :-

:		clc
		adc upv_font
		sta [uidraw_scrptr],z
		lda upv_fontcolour
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		iny
 		bra :--

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

upv_font
		.byte $80

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

upv_effectcommandtocolour
		.byte $04, $be, $be, $be, $be, $be, $be, $be, $be, $be, $be, $3d, $be, $3d, $be, $3d

; ----------------------------------------------------------------------------------------------------
