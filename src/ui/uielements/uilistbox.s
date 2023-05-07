; ----------------------------------------------------------------------------------------------------

uilistbox_selected_index		.byte 0, 0, 0, 0
uilistbox_startpos				.byte 0, 0, 0, 0
uilistbox_numentries			.byte 0, 0, 0, 0
uilistbox_listheight			.byte 0, 0, 0, 0
uilistbox_current_draw_pos		.byte 0, 0, 0, 0
uilistbox_current_draw_posx2	.byte 0, 0, 0, 0
uilistbox_numerator				.byte 0, 0, 0, 0
uilistbox_denominator			.byte 0, 0, 0, 0

; ----------------------------------------------------------------------------------------------------

uilistbox_resetqvalues
		lda #$00
		sta uilistbox_selected_index+0
		sta uilistbox_selected_index+1
		sta uilistbox_selected_index+2
		sta uilistbox_selected_index+3
		sta uilistbox_startpos+0
		sta uilistbox_startpos+1
		sta uilistbox_startpos+2
		sta uilistbox_startpos+3
		sta uilistbox_numentries+0
		sta uilistbox_numentries+1
		sta uilistbox_numentries+2
		sta uilistbox_numentries+3
		sta uilistbox_current_draw_pos+0
		sta uilistbox_current_draw_pos+1
		sta uilistbox_current_draw_pos+2
		sta uilistbox_current_draw_pos+3
		sta uilistbox_current_draw_posx2+0
		sta uilistbox_current_draw_posx2+1
		sta uilistbox_current_draw_posx2+2
		sta uilistbox_current_draw_posx2+3
		sta uilistbox_numerator+0
		sta uilistbox_numerator+1
		sta uilistbox_numerator+2
		sta uilistbox_numerator+3
		sta uilistbox_denominator+0
		sta uilistbox_denominator+1
		sta uilistbox_denominator+2
		sta uilistbox_denominator+3
		rts

; ----------------------------------------------------------------------------------------------------


uilistbox_update
		lda valPepPlaying
		bne :+
		rts

:		jsr populate_samplestate
		jsr uilistbox_draw

		rts

; ----------------------------------------------------------------------------------------------------

uilistbox_init
		jsr populate_samplestate
		jsr uilistbox_draw
		rts

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
		ldy #$03
		adc #$00
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
		iny
		lda (zpptr2),y
		adc #$00
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
		iny
		lda (zpptr2),y
		sbc #$00
		sta (zpptr2),y

		rts

uilistbox_confine

		ldy #$04										; put scrollbar1_data in zpptr2
		jsr ui_getelementdata_2

		ldy #$04										; get selection index
		lda (zpptr2),y
		sta uilistbox_selected_index+2
		iny
		lda (zpptr2),y
		sta uilistbox_selected_index+3

		MATH_POSITIVE uilistbox_selected_index

		bcs :+											; positive -> ok
		ldy #$04										; negative -> underflow
		lda #$00
		sta (zpptr2),y
		iny
		sta (zpptr2),y

:		ldy #$06
		lda (zpptr2),y									; store numentries
		sta uilistbox_numentries+2
		iny
		lda (zpptr2),y
		sta uilistbox_numentries+3

		MATH_BIGGER uilistbox_numentries, uilistbox_selected_index, uilistbox_numerator
		bcs :+											; numentries > selected -> ok

		sec												; selected > numentries -> set selected to numentries - 1
		ldy #$06
		lda (zpptr2),y
		sbc #$01
		ldy #$04
		sta (zpptr2),y
		ldy #$07
		lda (zpptr2),y
		sbc #$00
		ldy #$05
		sta (zpptr2),y
		rts

:		ldy #$02
		lda (zpptr2),y
		sta uilistbox_startpos+2
		iny
		lda (zpptr2),y
		sta uilistbox_startpos+3

		MATH_SUB uilistbox_selected_index, uilistbox_startpos, uilistbox_numerator
		MATH_POSITIVE uilistbox_numerator				; is selection index bigger than startpos?
		bcs :+											; yes, so not going up

		ldy #$04										; nope, put selection index in startpos so we move up
		lda (zpptr2),y
		ldy #$02
		sta (zpptr2),y
		ldy #$05
		lda (zpptr2),y
		ldy #$03
		sta (zpptr2),y
		rts

:		ldy #UIELEMENT::height							; compare with height
		lda (zpptr0),y
		sta uilistbox_listheight+2
		MATH_BIGGER uilistbox_numerator, uilistbox_listheight, uilistbox_denominator
		bcs :+											; ok if < height
		rts

:		MATH_SUB uilistbox_selected_index, uilistbox_listheight, uilistbox_denominator
		clc
		ldy #$02										; put in startpos
		lda uilistbox_denominator+2
		adc #$01
		sta (zpptr2),y
		iny
		lda uilistbox_denominator+3
		adc #$00
		sta (zpptr2),y

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
		iny
		sta (zpptr3),y
		iny
		sta (zpptr3),y									; set selection index to 0
		iny
		sta (zpptr3),y
		iny
		sta (zpptr3),y									; set number of entries to 0
		iny
		sta (zpptr3),y

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
		iny		
		lda (zpptr3),y
		adc #$00
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

		jsr uilistbox_resetqvalues
		jsr uidraw_set_draw_position

		ldy #$04										; put scrollbar1_data into zpptr2
		jsr ui_getelementdata_2

		ldy #$02										; store startpos
		lda (zpptr2),y
		sta uilistbox_startpos+2
		iny
		lda (zpptr2),y
		sta uilistbox_startpos+3
		iny

		ldy #$04										; store selected index
		lda (zpptr2),y
		sta uilistbox_selected_index+2
		iny
		lda (zpptr2),y
		sta uilistbox_selected_index+3

		ldy #$06										; put listboxtxt into zpptr2
		jsr ui_getelementdata_2

		lda uilistbox_startpos+2
		sta uilistbox_current_draw_pos+2
		sta uilistbox_current_draw_posx2+2
		lda uilistbox_startpos+3
		sta uilistbox_current_draw_pos+3
		sta uilistbox_current_draw_posx2+3

		asl uilistbox_current_draw_posx2+2
		rol uilistbox_current_draw_posx2+3

		clc
		lda zpptr2+0
		adc uilistbox_current_draw_posx2+2
		sta zpptr2+0
		lda zpptr2+1
		adc uilistbox_current_draw_posx2+3
		sta zpptr2+1

		rts

uilistbox_drawlistreleased		

		MATH_EQUAL uilistbox_current_draw_pos, uilistbox_selected_index 				; is this line the selected line?
		bcc :+

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
		clc
		lda uilistbox_current_draw_pos+2
		adc #$01
		sta uilistbox_current_draw_pos+2
		lda uilistbox_current_draw_pos+3
		adc #$00
		sta uilistbox_current_draw_pos+3

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
		lda uilistbox_current_draw_pos+2
		clc
		adc #$01
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

		lda uilistbox_current_draw_pos+2
		clc
		adc #$01
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

		ldy #$00
		lda (zpptrtmp),y
		and #%00000001
		bne :+									; not sample with 0 length?

		lda #$3e
		sta [uidraw_scrptr],z
		lda #$10								; sample with 0 length = black
		sta [uidraw_colptr],z
		inz
		lda #$05
		sta [uidraw_scrptr],z
		inz
		bra uilistbox_drawlistitem_skipbox

:		lda (zpptrtmp),y
		and #%00000010
		cmp #%00000010
		bne :+									; sample that is currently playing?
		lda #$3e
		sta [uidraw_scrptr],z
		lda #$43								; sample with some length + playing = nice colour
		sta [uidraw_colptr],z
		inz
		lda #$05
		sta [uidraw_scrptr],z
		inz
		bra uilistbox_drawlistitem_skipbox

:		lda #$3e
		sta [uidraw_scrptr],z
		lda #$04								; sample with some length = middle gray
		sta [uidraw_colptr],z
		inz
		lda #$05
		sta [uidraw_scrptr],z
		inz
		bra uilistbox_drawlistitem_skipbox

uilistbox_drawlistitem_skipbox

		lda #$20
		clc
		adc ulb_font
		sta [uidraw_scrptr],z
		inz
		inz

		iny
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

; ----------------------------------------------------------------------------------------------------
