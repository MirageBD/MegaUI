; ----------------------------------------------------------------------------------------------------

uitab_layout
		jsr uielement_layout
		rts

uitab_hide
		;jsr uielement_hide
		rts

uitab_focus
		rts

uitab_enter
		rts

uitab_leave
		rts

uitab_move
		rts

uitab_keypress
		rts

uitab_keyrelease
		rts

uitab_press
		rts

uitab_longpress
		rts

uitab_doubleclick
		rts

uitab_draw

		jsr uidraw_set_draw_position

		sec
		ldy #UIELEMENT::width
		lda (zpptr0),y
		sbc #$02
		sta uidraw_width
		sec
		ldy #UIELEMENT::height
		lda (zpptr0),y
		sbc #$02
		sta uidraw_height

		ldx uidraw_width

		ldy #$02							; read index
		jsr ui_getelementdata_2

		ldy #UIELEMENT::parent				; get pointer to parent
		lda (zpptr0),y
		sta zpptr3+0
		iny
		lda (zpptr0),y
		sta zpptr3+1

		ldy #UIELEMENT::data+0				; get pointer to parent data
		lda (zpptr3),y
		sta zpptr1+0
		iny
		lda (zpptr3),y
		sta zpptr1+1

		lda zpptr2+0						; read index
		ldy #$02
		cmp (zpptr1),y						; compare with group index
		beq :+

		ldz #$00							; uitab not selected
		ldy #5*16+5
		jsr uitab_drawinactive
		rts

:		ldz #$00							; uitab selected
		ldy #5*16+0
		jsr uitab_drawactive
		rts

; ----------------------------------------------------------------------------------------------------

uitab_drawactive

		clc
		ldz #$00
		tya
		sta [uidraw_scrptr],z					; draw left glyph
		inz
		inz
		adc #$01
		phx
:		sta [uidraw_scrptr],z					; draw middle glyph
		inz
		inz
		dex
		bne :-
		plx
		adc #$01
		sta [uidraw_scrptr],z					; draw right glyph

		jsr uidraw_increase_row

		tya
		clc
		adc #3
		tay

		ldz #$00
		tya
		sta [uidraw_scrptr],z					; draw left glyph
		inz
		inz
		pha
		phx
:		lda #$04
		sta [uidraw_colptr],z					; draw middle glyph - just colour
		inz
		inz
		dex
		bne :-
		plx
		pla
		adc #$01
		sta [uidraw_scrptr],z					; draw right glyph

		jsr uitab_drawlabel

		rts

; ----------------------------------------------------------------------------------------------------

uitab_drawinactive

		clc
		ldz #$00
		tya
		sta [uidraw_scrptr],z
		inz
		inz
		adc #$01
		phx
:		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		adc #$01
		sta [uidraw_scrptr],z

		jsr uidraw_increase_row

		tya
		clc
		adc #3
		tay

		ldz #$00
		tya
		sta [uidraw_scrptr],z
		inz
		inz
		pha
		phx
:		lda #$03
		sta [uidraw_colptr],z
		inz
		inz
		dex
		bne :-
		plx
		pla
		adc #$01
		sta [uidraw_scrptr],z

		jsr uitab_drawlabel

		rts

; ----------------------------------------------------------------------------------------------------

uitab_drawlabel

		lda #$01
		sta uidraw_xposoffset
		lda #$01
		sta uidraw_yposoffset

		jsr uidraw_set_draw_position

		ldy #$06
		jsr ui_getelementdata_2

		ldy #$00
		ldz #$00
:		lda (zpptr2),y
		beq :+
		tax
		lda ui_bkgtextremap,x
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz
		iny
 		bra :-
:
		jsr uidraw_resetoffsets
		rts

; ----------------------------------------------------------------------------------------------------

uitab_release
		ldy #$02							; read index
		jsr ui_getelementdata_2

		ldy #UIELEMENT::parent				; get pointer to parent
		lda (zpptr0),y
		sta zpptr3+0
		iny
		lda (zpptr0),y
		sta zpptr3+1

		ldy #UIELEMENT::data+0				; get pointer to parent data
		lda (zpptr3),y
		sta zpptr1+0
		iny
		lda (zpptr3),y
		sta zpptr1+1

		lda zpptr2+0						; read index
		ldy #$02
		sta (zpptr1),y						; put in group index

		jsr uielement_calluifunc			; call draw on all the other tab labels in this tab group

		lda zpptr3+0						; make parent the element to call
		sta zpptr0+0
		lda zpptr3+1
		sta zpptr0+1

		jsr uigroup_update

	   	rts

; ----------------------------------------------------------------------------------------------------
