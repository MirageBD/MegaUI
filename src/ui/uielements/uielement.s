; ----------------------------------------------------------------------------------------------------

uielement_layout
		jsr uirect_calcminmax

		jsr uistack_peekparent
		ldy #UIELEMENT::parent							; set parent
		lda uielement_parent_ptr+0
		sta (zpptr0),y
		iny
		lda uielement_parent_ptr+1
		sta (zpptr0),y

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
    	rts

uielement_iterator
		.byte $00

uielement_calluifunc

		jsr ui_getelementdataptr_1

		; LV TODO - check for ff first before populating everything?

		ldy #$00								; put ptr to elements and functions in zpptr1
 		lda (zpptr1),y
		sta uecuf1+1
		sta uecuf2+1
		sta uecuf3+1
		sta uecuf4+1
		iny
		lda (zpptr1),y
		sta uecuf1+2
		sta uecuf2+2
		sta uecuf3+2
		sta uecuf4+2
		cmp #$ff								; back out if element/function ptr is null
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
uecuf5	jsr $babe							; execute function
		ply

		bra uecuf1

uielement_calluifunc_end
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