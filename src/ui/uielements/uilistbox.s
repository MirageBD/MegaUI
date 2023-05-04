; ----------------------------------------------------------------------------------------------------

uilistbox_selected_index		.byte 0
uilistbox_startpos				.byte 0
uilistbox_current_draw_pos		.byte 0

; ----------------------------------------------------------------------------------------------------

uilistbox_layout
		jsr uielement_layout
		rts

uilistbox_hide
		;jsr uielement_hide
		rts

uilistbox_focus
		rts

uilistbox_enter
		rts

uilistbox_leave
		rts

uilistbox_move
		rts

uilistbox_press
		rts

uilistbox_longpress
		rts

uilistbox_doubleclick
		jsr uielement_calluserfunc
		rts

uilistbox_keypress
		lda keyboard_pressedeventarg

		cmp #KEYBOARD_CURSORDOWN
		bne :+
		jsr uilistbox_increase_selection
		jsr uilistbox_confine
		jsr uielement_calluifunc
		rts

:		cmp #KEYBOARD_CURSORUP
		bne :+
		jsr uilistbox_decrease_selection
		jsr uilistbox_confine
		jsr uielement_calluifunc

:		rts

uilistbox_keyrelease
		lda keyboard_pressedeventarg

		cmp #KEYBOARD_RETURN
		bne :+
		jsr uielement_calluserfunc

:		rts

; ----------------------------------------------------------------------------------------------------

uilistbox_draw
		jsr uilistbox_drawbkgreleased
		jsr uilistbox_startdrawlistreleased
		jsr uilistbox_drawlistreleased
		rts

uilistbox_release
		jsr uilistbox_setselectedindex
		jsr uilistbox_draw
		rts

uilistbox_setselectedindex
		jsr uimouse_calculate_pos_in_uielement

		ldy #$04										; put scrollbar1_data in zpptr2
		jsr ui_getelementdata_2

		lda uimouse_uielement_ypos+0					; set selected index + added start address
		lsr
		lsr
		lsr
		clc
		ldy #$02
		adc (zpptr2),y
		ldy #$04
		sta (zpptr2),y

		rts

; ----------------------------------------------------------------------------------------------------

uilistbox_increase_selection
		ldy #$04										; put scrollbar1_data in zpptr2
		jsr ui_getelementdata_2

		clc
		ldy #$04										; get selection index
		lda (zpptr2),y
		adc #$01
		sta (zpptr2),y

		rts

uilistbox_decrease_selection
		ldy #$04										; put scrollbar1_data in zpptr2
		jsr ui_getelementdata_2

		sec
		ldy #$04										; get selection index
		lda (zpptr2),y
		sbc #$01
		sta (zpptr2),y

		rts

uilistbox_confine
		ldy #$04										; put scrollbar1_data in zpptr2
		jsr ui_getelementdata_2

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
		ldy #$04										; get selection
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

uilistbox_startaddentries

		ldy #$04
		jsr ui_getelementdata_2

		lda zpptr2+0
		sta zpptr3+0
		lda zpptr2+1
		sta zpptr3+1

		lda #$00
		ldy #$02
		sta (zpptr3),y									; set scrollbar position to 0
		ldy #$04
		sta (zpptr3),y									; set selection index to 0
		ldy #$06
		sta (zpptr3),y									; set number of entries to 0

		ldy #$06										; put start of text list into zpptr2
		jsr ui_getelementdata_2

		ldy #$00										; put pointer to actual text entry in zpptrtmp
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1

		rts

uilistbox_addentry

		clc													; increase number of entries
		ldy #$06
		lda (zpptr3),y
		adc #$01
		sta (zpptr3),y

		ldy #$00											; set list pointer to text
		lda zpptrtmp+0
		sta (zpptr2),y
		iny
		lda zpptrtmp+1
		sta (zpptr2),y

		clc													; add 2 to move to next list ptr entry
		lda zpptr2+0
		adc #$02
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

		rts

uilistbox_endaddentries
		ldy #$00
		lda #$ff
		sta (zpptr2),y
		iny
		sta (zpptr2),y
		rts

; ----------------------------------------------------------------------------------------------------

uilistbox_getstringptr

		ldy #$06										; put start of text list into zpptr2
		jsr ui_getelementdata_2

		ldy #$04										; get pointer to scrollbar data
		lda (zpptr1),y
		sta zpptrtmp+0
		iny
		lda (zpptr1),y
		sta zpptrtmp+1

		ldy #$04										; get selection index
		lda (zpptrtmp),y
		asl												; *2
		adc zpptr2+0									; add to text list ptr
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

		ldy #$00										; put pointer to actual text entry in zpptrtmp
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1

		rts

; ----------------------------------------------------------------------------------------------------

uilistbox_drawbkgreleased

		jsr uidraw_set_draw_position

		ldy #UIELEMENT::width
		lda (zpptr0),y
		sta uidraw_width
		ldy #UIELEMENT::height
		lda (zpptr0),y
		sta uidraw_height

:		ldx uidraw_width
		ldz #$00
:		lda #$08										; mid gray background
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

uilistbox_startdrawlistreleased

		jsr uidraw_set_draw_position

		ldy #$04										; put scrollbar1_data into zpptr2
		jsr ui_getelementdata_2

		ldy #$02										; store startpos
		lda (zpptr2),y
		sta uilistbox_startpos

		ldy #$04
		lda (zpptr2),y
		sta uilistbox_selected_index

		ldy #$06										; put listboxtxt into zpptr2
		jsr ui_getelementdata_2

		clc
		lda uilistbox_startpos
		sta uilistbox_current_draw_pos
		asl
		adc zpptr2+0
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

		rts

uilistbox_drawlistreleased		

		lda uilistbox_current_draw_pos					; is this line the selected line?
		cmp uilistbox_selected_index
		bne :+
		lda #$c0
		sta ulb_font
		lda #$0f
		sta ulb_fontcolour
		bra :++
:		lda #$80
		sta ulb_font
		lda #$08
		sta ulb_fontcolour
:
		jsr uilistbox_drawemptyline

		ldy #$00
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1
		cmp #$ff										; bail out if at the end of the list
		beq :+

		jsr uilistbox_drawlistitem

		clc
		lda zpptr2+0
		adc #$02
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

:		jsr uidraw_increase_row
		inc uilistbox_current_draw_pos

		dec uidraw_height
		lda uidraw_height
		bne uilistbox_drawlistreleased

		rts

; ----------------------------------------------------------------------------------------------------

uilistbox_drawemptyline

		ldx uidraw_width								; clear line
		ldz #$00
:		lda #$20
		clc
		adc ulb_font
		sta [uidraw_scrptr],z
		lda ulb_fontcolour
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

uilistbox_drawlistitem

		ldz #$00
		lda uilistbox_current_draw_pos
		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodec,x
		clc
		adc ulb_font
		sta [uidraw_scrptr],z
		inz
		inz

		lda uilistbox_current_draw_pos
		and #$0f
		tax
		lda hextodec,x
		clc
		adc ulb_font
		sta [uidraw_scrptr],z
		inz
		inz

		lda #$20
		adc ulb_font
		sta [uidraw_scrptr],z
		inz
		inz

		lda #$3e
		sta [uidraw_scrptr],z
		lda #$93
		sta [uidraw_colptr],z
		inz
		lda #$05
		sta [uidraw_scrptr],z
		inz

		lda #$20
		adc ulb_font
		sta [uidraw_scrptr],z
		inz
		inz

		ldy #$00
:		lda (zpptrtmp),y
		tax
		lda ui_textremap,x
		beq :+
		clc
		adc ulb_font
		sta [uidraw_scrptr],z
		lda ulb_fontcolour
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		iny
 		bra :-

:		rts

; ----------------------------------------------------------------------------------------------------

ulb_font
		.byte $80	; $00 (white text on coloured background) or $80 (coloured text on black background)

ulb_fontcolour
		.byte $0f