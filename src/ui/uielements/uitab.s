; ----------------------------------------------------------------------------------------------------



; ----------------------------------------------------------------------------------------------------

uitab_layout
		jsr uielement_layout
		rts

uitab_hide
		jsr uielement_hide
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

uitab_doubleclick
		rts

uitab_draw

		jsr uidraw_set_draw_position

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
		lda #3*16+12
		sta [uidraw_scrptr],z
		rts

:		ldz #$00							; uitab selected
		lda #3*16+13
		sta [uidraw_scrptr],z
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

		;ldy #$04							; read pointer to contents
		;jsr ui_getelementdata_2

		;lda zpptr2+0
		;sta zpptr0+0
		;lda zpptr2+1
		;sta zpptr0+1
		;jsr uiwindow_hide					; call hide on the content element to clear contents of tab

		lda zpptr3+0						; make parent the element to call
		sta zpptr0+0
		lda zpptr3+1
		sta zpptr0+1

		jsr uigroup_update

	   	rts

; ----------------------------------------------------------------------------------------------------
