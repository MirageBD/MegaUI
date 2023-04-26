; ----------------------------------------------------------------------------------------------------

uielement_layout
		ldy #UIELEMENT::parent							; set parent
		lda uielement_parent_ptr+0
		sta (zpptr0),y
		sta zpptrtmp+0
		iny
		lda uielement_parent_ptr+1
		sta (zpptr0),y
		sta zpptrtmp+1

		ldy #UIELEMENT::height
		lda (zpptr0),y
		bpl :+

		clc
		lda (zpptrtmp),y
		adc (zpptr0),y
		sta (zpptr0),y

:		ldy #UIELEMENT::width
		lda (zpptr0),y
		bpl :+

		clc
		lda (zpptrtmp),y
		adc (zpptr0),y
		sta (zpptr0),y

:		ldy #UIELEMENT::xpos
		lda (zpptr0),y
		bpl :+

		clc
		ldy #UIELEMENT::width
		lda (zpptrtmp),y
		ldy #UIELEMENT::xpos
		adc (zpptr0),y
		sta (zpptr0),y

:		ldy #UIELEMENT::ypos
		lda (zpptr0),y
		bpl :+

		clc
		ldy #UIELEMENT::height
		lda (zpptrtmp),y
		ldy #UIELEMENT::ypos
		adc (zpptr0),y
		sta (zpptr0),y

:		jsr uirect_calcminmax

    	rts

uielement_hide															; LV TODO - come up with a better way. At the moment every element is calling this which is not always necessary
																		; I.E. tabgroups can just hide themselves instead of clearing themselves.
		jsr uidraw_set_draw_position

		ldy #UIELEMENT::width
		lda (zpptr0),y
		sta uidraw_width
		ldy #UIELEMENT::height
		lda (zpptr0),y
		clc
		adc #$01
		sta uidraw_height

		ldy uidraw_height
:		ldx uidraw_width
		ldz #$00
:		lda #<(glchars/64)
		sta [uidraw_scrptr],z
		lda #$04
		sta [uidraw_colptr],z
		inz
		lda #>(glchars/64)
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		dex
		bne :-

		jsr uidraw_increase_row

		dey
		bne :--

		rts

uielement_focus
	    rts

uielement_enter
		lda zpptr0+0                                    ; is the element being entered the captured one?
		cmp uimouse_captured_element+0
		bne :+
		lda zpptr0+1
		cmp uimouse_captured_element+1
		bne :+

		lda mouse_held
		beq :+
		SEND_EVENT press
:
	    rts

uielement_leave
		rts

uielement_draw
    	rts

uielement_press
		ldy #UIELEMENT::state
		lda (zpptr0),y
		ora #UISTATE::pressed
		sta (zpptr0),y

		jsr uikeyboard_disablecursor

    	rts

uielement_longpress
		rts

uielement_doubleclick
		rts

uielement_release
		ldy #UIELEMENT::state
		lda (zpptr0),y
		and #UISTATEMASK::pressed
		sta (zpptr0),y
		rts

uielement_move
		rts

uielement_keypress
		rts

uielement_keyrelease
		rts

; ----------------------------------------------------------------------------------------------------

rzpptr0	.word 0

uielement_calluifunc

		lda zpptr0+0
		sta rzpptr0+0
		lda zpptr0+1
		sta rzpptr0+1

		ldy #$00
		jsr ui_getelementdata_2

 		lda zpptr2+0							; get ptr to elements and functions
		sta uecuf1+1							; LV TODO - check for ff first before populating everything?
		sta uecuf2+1
		sta uecuf3+1
		sta uecuf4+1
		lda zpptr2+1
		sta uecuf1+2
		sta uecuf2+2
		sta uecuf3+2
		sta uecuf4+2
		cmp #$ff								; early out if element/function ptr is null
		beq uielement_calluifunc_end

		ldy #$00								; read ui element to act upon and put in zpptr0
uecuf1	lda $babe,y
		sta zpptr0+0
		iny
uecuf2	lda $babe,y
		sta zpptr0+1
		cmp #$ff								; back out if element is null
		beq uielement_calluifunc_end

		iny										; read function to call
uecuf3	lda $babe,y
		sta uecuf5+1
		iny
uecuf4	lda $babe,y
		sta uecuf5+2
		iny

		phy
uecuf5	jsr $babe								; execute function
		ply

		bra uecuf1

uielement_calluifunc_end

		lda rzpptr0+0
		sta zpptr0+0
		lda rzpptr0+1
		sta zpptr0+1

		rts

; ----------------------------------------------------------------------------------------------------

uielement_calluserfunc

		lda zpptr0+0
		sta rzpptr0+0
		lda zpptr0+1
		sta rzpptr0+1

		ldy #$02
		jsr ui_getelementdata_2

 		lda zpptr2+0							; get ptr to elements and functions
		sta uecusf1+1							; LV TODO - check for ff first before populating everything?
		sta uecusf2+1
		sta uecusf3+1
		sta uecusf4+1
		lda zpptr2+1
		sta uecusf1+2
		sta uecusf2+2
		sta uecusf3+2
		sta uecusf4+2
		cmp #$ff								; early out if element/function ptr is null
		beq uielement_calluserfunc_end

		ldy #$00								; read ui element to act upon and put in zpptr0
uecusf1	lda $babe,y
		sta zpptr0+0
		iny
uecusf2	lda $babe,y
		sta zpptr0+1
		cmp #$ff								; back out if element is null
		beq uielement_calluserfunc_end

		iny										; read function to call
uecusf3	lda $babe,y
		sta uecusf5+1
		iny
uecusf4	lda $babe,y
		sta uecusf5+2
		iny

		phy
uecusf5	jsr $babe								; execute function
		ply

		bra uecusf1

uielement_calluserfunc_end

		lda rzpptr0+0
		sta zpptr0+0
		lda rzpptr0+1
		sta zpptr0+1

		rts

; ----------------------------------------------------------------------------------------------------
