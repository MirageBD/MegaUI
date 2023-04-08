; ----------------------------------------------------------------------------------------------------

uitrackview_selected_index			.byte 0
uitrackview_startpos				.byte 0
uitrackview_current_draw_pos		.byte 0
uitrackview_middlepos				.byte 0
uitrackview_rowpos					.byte 0

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
		jsr uitrackview_drawbkgreleased
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
		ldy #$04
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

		ldy #$04
		lda (zpptr2),y
		sta uitrackview_selected_index

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
		bra :+++

:		lda uitrackview_current_draw_pos
		cmp uitrackview_selected_index
		bne :+
		lda #$80
		sta utv_font
		lda #$3f
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
		tax
		lda ui_textremap,x
		beq uitrackview_increasepointerandrow
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
		iny
 		bra :-

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

; ----------------------------------------------------------------------------------------------------
