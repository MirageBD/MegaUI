; ----------------------------------------------------------------------------------------------------

uitrackview_startpos				.byte 0
uitrackview_current_draw_pos		.byte 0
uitrackview_middlepos				.byte 0
uitrackview_rowpos					.byte 0

; ----------------------------------------------------------------------------------------------------

uitrackview_patternindex			.byte 0
uitrackview_patternptr				.dword 0
uitrackview_patternrow				.byte 0

; ----------------------------------------------------------------------------------------------------

uitrackview_update
		lda cntPepSeqP
		sta uitrackview_patternindex

		taz
		lda	[ptrPepMSeq],z
		asl
		asl
		tax

		lda	adrPepPtn0+0,x
		sta	uitrackview_patternptr+0
		lda	adrPepPtn0+1,x
		sta	uitrackview_patternptr+1
		lda	adrPepPtn0+2,x
		sta	uitrackview_patternptr+2
		lda	adrPepPtn0+3,x
		sta	uitrackview_patternptr+3

		lda cntPepPRow
		sta uitrackview_patternrow

		jsr uitrackview_decodepattern

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
		lda uitrackview_patternrow
		sta (zpptr2),y

		jsr uielement_calluifunc

		rts

; ----------------------------------------------------------------------------------------------------

uitrackview_decodepattern

		lda uitrackview_patternptr+0
		sta zpptrtmp+0
		lda uitrackview_patternptr+1
		sta zpptrtmp+1
		lda uitrackview_patternptr+2
		sta zpptrtmp+2
		lda uitrackview_patternptr+3
		sta zpptrtmp+3

		lda #<tvboxtxt0
		sta zpptr2+0
		lda #>tvboxtxt0
		sta zpptr2+1

		lda #$00
		sta utv_decoderow

utvdp_rowloop
		lda #$00
		sta utv_decodechannel

utvdp_channelloop
		ldy #$00

		ldz #$00									; get sample number
		lda [zpptrtmp],z
		and #$f0
		sta uitrackview_sample
		ldz #$02
		lda [zpptrtmp],z
		lsr
		lsr
		lsr
		lsr
		ora uitrackview_sample
		sta uitrackview_sample

		ldz #$01									; get note period
		lda [zpptrtmp],z
		sta uitrackview_noteperiod+0
		ldz #$00
		lda [zpptrtmp],z
		and #$0f
		sta uitrackview_noteperiod+1

		ldz #$02									; get effect command
		lda [zpptrtmp],z
		and #$0f
		sta uitrackview_effectcommand
		ldz #$03									; get effect data
		lda [zpptrtmp],z
		sta uitrackview_effectdata

		ldx #$00									; find string for note period
:		lda utv_tunefreq+0,x
		cmp uitrackview_noteperiod+0
		bne :+
		lda utv_tunefreq+1,x
		cmp uitrackview_noteperiod+1
		beq :++
:		inx
		inx
		cpx #36*2
		bne :--

:		txa
		lsr
		tax
		lda utv_times3table,x
		tax

		lda #$ff									; write note colour code to list
		sta (zpptr2),y
		iny
		lda #$e0
		sta (zpptr2),y
		iny

		lda utv_tunenote+0,x						; write note string to list
		sta (zpptr2),y
		iny
		lda utv_tunenote+1,x
		sta (zpptr2),y
		iny
		lda utv_tunenote+2,x
		sta (zpptr2),y
		iny

		iny

		lda #$ff									; write sample colour code to list
		sta (zpptr2),y
		iny
		lda #$d0
		sta (zpptr2),y
		iny

		lda uitrackview_sample						; write sample num to list
		beq :+
		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodec,x
		sta (zpptr2),y
		iny
		lda uitrackview_sample
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
		lda #$08
		sta (zpptr2),y
		iny

		lda #$2e									; write volume to list
		sta (zpptr2),y
		iny
		sta (zpptr2),y
		iny

		iny

		lda #$ff									; write effect command colour code to list
		sta (zpptr2),y
		iny
		lda #$b0
		sta (zpptr2),y
		iny

		lda uitrackview_effectcommand				; write effect command to list
		beq :+
		tax
		lda hextodec,x
		sta (zpptr2),y
		iny
		bra :++

:		lda #$2e									; write ... if effect command is 0
		sta (zpptr2),y
		iny

		lda #$ff									; write effect command colour code to list
		sta (zpptr2),y
		iny
		lda #$08
		sta (zpptr2),y
		iny

		lda #$2e
		sta (zpptr2),y
		iny
		sta (zpptr2),y
		iny
		bra :++

:		lda #$ff									; write effect command colour code to list
		sta (zpptr2),y
		iny
		lda #$a0
		sta (zpptr2),y
		iny

		lda uitrackview_effectdata					; write effect data to list
		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodec,x
		sta (zpptr2),y
		iny
		lda uitrackview_effectdata
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

		clc											; add 27 to get to second channel
		lda zpptr2+0
		adc #27
		sta zpptr2+0
		lda zpptr2+1
		adc #0
		sta zpptr2+1

		inc utv_decodechannel
		lda utv_decodechannel
		cmp #$04
		beq :+

		jmp utvdp_channelloop

:		sec											; subtract 3 to skip trailing zero byte
		lda zpptr2+0
		sbc #03
		sta zpptr2+0
		lda zpptr2+1
		sbc #0
		sta zpptr2+1

		inc utv_decoderow
		lda utv_decoderow
		cmp #64
		beq :+

		jmp utvdp_rowloop

:		rts

utv_decodechannel
		.byte 0

utv_decoderow
		.byte 0

uitrackview_sample
		.byte 0

uitrackview_noteperiod
		.word 0

uitrackview_effectcommand
		.byte 0

uitrackview_effectdata
		.byte 0

uitrackview_notestring
		.byte 0, 0, 0

; ----------------------------------------------------------------------------------------------------

uitrackview_layout
		jsr uielement_layout
		rts

uitrackview_focus
		rts

uitrackview_enter
		rts

uitrackview_leave
		rts

uitrackview_move
		rts

uitrackview_press
		rts

uitrackview_doubleclick
		rts

uitrackview_keyrelease
		rts

uitrackview_keypress
		lda keyboard_pressedeventarg

		cmp KEYBOARD_CURSORDOWN
		bne :+
		jsr uitrackview_increase_selection
		jsr uitrackview_confine
		jsr uielement_calluifunc		
		rts

:		cmp KEYBOARD_CURSORUP
		bne :+
		jsr uitrackview_decrease_selection
		jsr uitrackview_confine
		jsr uielement_calluifunc		
:		rts

; ----------------------------------------------------------------------------------------------------

uitrackview_draw
		;jsr uitrackview_drawbkgreleased
		jsr uitrackview_drawlistreleased
		rts

uitrackview_release
		jsr uitrackview_setselectedindex
		jsr uitrackview_draw
		rts

uitrackview_setselectedindex
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
		sta uitrackview_middlepos

		lda uimouse_uielement_ypos+0					; set selected index + added start address
		lsr
		lsr
		lsr
		clc
		ldy #$02
		adc (zpptr2),y
		sec
		sbc uitrackview_middlepos
		ldy #$02
		sta (zpptr2),y

		rts

; ----------------------------------------------------------------------------------------------------

uitrackview_increase_selection
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

uitrackview_decrease_selection
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

uitrackview_confine
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

uitrackview_drawbkgreleased

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

uitrackview_drawlistreleased

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
		sta uitrackview_middlepos						; $07

		ldy #$02										; store startpos
		lda (zpptr2),y
		sta uitrackview_startpos

		ldy #$04										; put listboxtxt into zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		sec
		lda uitrackview_startpos						; add startpos to listboxtxt pointer
		sbc uitrackview_middlepos
		sta uitrackview_current_draw_pos
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
		sta uitrackview_rowpos

uitrackview_drawlistreleased_loop						; start drawing the list

		ldy #$00
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1

		lda uitrackview_rowpos
		cmp uitrackview_middlepos
		bne :+
		lda #$00
		sta utv_font
		lda #$f0
		sta utv_fontcolour
		bra :++

:		lda #$80
		sta utv_font
		lda #$f0
		sta utv_fontcolour

:		ldx uidraw_width								; clear line
		ldz #$00
:		lda #$20
		clc
		adc utv_font
		sta [uidraw_scrptr],z
		lda utv_fontcolour
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		dex
		bne :-

		lda uitrackview_current_draw_pos
		bmi uitrackview_increaserow

		lda zpptrtmp+1
		cmp #$ff
		beq uitrackview_increaserow

		ldy #$00
		ldz #$00
:		lda (zpptrtmp),y
		beq uitrackview_increasepointerandrow
		cmp #$ff
		bne :+
		iny
		lda (zpptrtmp),y
		sta utv_fontcolour
		iny
		bra :-

:		clc
		adc utv_font
		sta [uidraw_scrptr],z
		lda utv_fontcolour
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		iny
 		bra :--

uitrackview_increasepointerandrow
		clc
		lda zpptr2+0
		adc #$02
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

uitrackview_increaserow
		jsr uidraw_increase_row
		inc uitrackview_current_draw_pos
		inc uitrackview_rowpos

		dec uidraw_height
		lda uidraw_height
		beq :+
		jmp uitrackview_drawlistreleased_loop

:		rts

; ----------------------------------------------------------------------------------------------------

utv_font
		.byte $80	; $00 (white text on coloured background) or $80 (coloured text on black background)

utv_fontcolour
		.byte $f0

utv_tunefreq
		.word 856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 453
		.word 428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226
		.word 214, 202, 190, 180, 170, 160, 151, 143, 135, 127, 120, 113
		.word 0

utv_tunenote
		; "C-1", "C#1", "D-1", "D#1", "E-1", "F-1", "F#1", "G-1", "G#1", "A-1", "A#1", "B-1"
		; "C-2", "C#2", "D-2", "D#2", "E-2", "F-2", "F#2", "G-2", "G#2", "A-2", "A#2", "B-2"
		; "C-3", "C#3", "D-3", "D#3", "E-3", "F-3", "F#3", "G-3", "G#3", "A-3", "A#3", "B-3"

		.byte $03, $2d, $31,    $03, $23, $31,    $04, $2d, $31,    $04, $23, $31,    $05, $2d, $31,    $06, $2d, $31,    $06, $23, $31,    $07, $2d, $31,    $07, $23, $31,    $01, $2d, $31,    $01, $23, $31,    $02, $2d, $31
		.byte $03, $2d, $32,    $03, $23, $32,    $04, $2d, $32,    $04, $23, $32,    $05, $2d, $32,    $06, $2d, $32,    $06, $23, $32,    $07, $2d, $32,    $07, $23, $32,    $01, $2d, $32,    $01, $23, $32,    $02, $2d, $32
		.byte $03, $2d, $33,    $03, $23, $33,    $04, $2d, $33,    $04, $23, $33,    $05, $2d, $33,    $06, $2d, $33,    $06, $23, $33,    $07, $2d, $33,    $07, $23, $33,    $01, $2d, $33,    $01, $23, $33,    $02, $2d, $33
		.byte "..."

utv_times3table
.repeat 37, I
		.byte I*3
.endrepeat

; ----------------------------------------------------------------------------------------------------
