; ----------------------------------------------------------------------------------------------------

uihexlabel_numberofbytes
		.byte 0

; ----------------------------------------------------------------------------------------------------

uihexlabel_layout
        jsr uielement_layout
    	rts

uihexlabel_hide
		;jsr uielement_hide
		rts

uihexlabel_focus
	    rts

uihexlabel_enter
	    rts

uihexlabel_leave
		rts

uihexlabel_move
		rts

uihexlabel_keypress
		rts

uihexlabel_keyrelease
		rts
		
; ----------------------------------------------------------------------------------------------------

uihexlabel_draw

		jsr uidraw_set_draw_position

		ldy #$02
		jsr ui_getelementdata_2

		ldy #$04
		lda (zpptr1),y
		sta uihexlabel_numberofbytes

		ldz #$00
		ldy uihexlabel_numberofbytes
		dey
:		lda (zpptr2),y

		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodec,x
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz

		lda (zpptr2),y
		and #$0f
		tax
		lda hextodec,x
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz

		dey
		bpl :-

    	rts

uihexlabel_press
    	rts

uihexlabel_doubleclick
		rts

uihexlabel_release
    	rts

; ----------------------------------------------------------------------------------------------------
