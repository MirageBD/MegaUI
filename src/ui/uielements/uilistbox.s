; ----------------------------------------------------------------------------------------------------

uilistbox_selected_index		.byte 0
uilistbox_startpos				.byte 0
uilistbox_current_draw_pos		.byte 0

; ----------------------------------------------------------------------------------------------------

uilistbox_layout
		jsr uielement_layout
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

uilistbox_doubleclick
		rts

uilistbox_keyrelease
		rts

uilistbox_keypress
		lda keyboard_pressedeventarg

		cmp KEYBOARD_CURSORDOWN
		bne :+
		jsr uilistbox_increase_selection
		jsr uilistbox_confine
		jsr uielement_calluifunc		
		rts

:		cmp KEYBOARD_CURSORUP
		bne :+
		jsr uilistbox_decrease_selection
		jsr uilistbox_confine
		jsr uielement_calluifunc		
:		rts

; ----------------------------------------------------------------------------------------------------

uilistbox_draw
		jsr uilistbox_drawbkgreleased
		jsr uilistbox_drawlistreleased
		rts

uilistbox_release
		jsr uimouse_calculate_pos_in_uielement

		jsr ui_getelementdataptr_1						; get data ptr to zpptr1

		ldy #$02										; put scrollbar1_data in zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		lda uimouse_uielement_ypos+0					; set selected index + added start address
		lsr
		lsr
		lsr
		clc
		ldy #$02
		adc (zpptr2),y
		ldy #$04
		sta (zpptr2),y

		jsr uilistbox_draw

		rts

; ----------------------------------------------------------------------------------------------------

uilistbox_startaddentries

		jsr ui_getelementdataptr_1						; get data ptr to zpptr1

		ldy #$02										; put scrollbar1_data in zpptr3
		lda (zpptr1),y
		sta zpptr3+0
		iny
		lda (zpptr1),y
		sta zpptr3+1

		lda #$00
		ldy #$00
		sta (zpptr3),y									; set scrollbar position to 0
		ldy #$01
		sta (zpptr3),y									; set selection index to 0
		ldy #$02
		sta (zpptr3),y									; set number of entries to 0

		ldy #$02										; put start of text list into zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$00										; put pointer to actual text entry in zpptrtmp
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1

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

		jsr ui_getelementdataptr_1						; get data ptr to zpptr1

		ldy #$04										; put start of text list into zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$02										; get pointer to scrollbar data
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

uilistbox_increase_selection
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

uilistbox_decrease_selection
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

uilistbox_confine
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
:		lda #$00
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

uilistbox_drawlistreleased

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_1						; get data ptr to zpptr1

		ldy #$02										; put scrollbar1_data into zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$02										; store startpos
		lda (zpptr2),y
		sta uilistbox_startpos

		ldy #$04
		lda (zpptr2),y
		sta uilistbox_selected_index

		ldy #$04										; put listboxtxt into zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		clc
		ldy #$00
		lda uilistbox_startpos
		sta uilistbox_current_draw_pos
		asl
		adc zpptr2+0
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

uilistbox_drawlistreleased_loop							; start drawing the list

		lda uilistbox_current_draw_pos
		cmp uilistbox_selected_index
		bne :++

		ldx uidraw_width
		ldz #$00
:		;lda #$93 ; dark red
		;lda #$b6 ; dark purple
		;lda #$ca ; dodger blue
		;lda #$8d ; dark orange
		lda #$f0 ; dark blue
		sta [uidraw_colptr],z
		inz
		inz
		dex
		bne :-

:		ldx uidraw_width								; clear line
		ldz #$00
:		lda #$60
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz
		dex
		bne :-

		ldy #$00
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1
		cmp #$ff
		beq :+++

		ldy #$00
		ldz #$00
:		lda (zpptrtmp),y
		tax
		lda ui_textremap,x
		beq :+
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz
		iny
 		bra :-

:		clc
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
		bne uilistbox_drawlistreleased_loop

uilistbox_drawlistreleased_end
		rts

; ----------------------------------------------------------------------------------------------------
