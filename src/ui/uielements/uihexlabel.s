; ----------------------------------------------------------------------------------------------------

uihexlabel_layout
        jsr uielement_layout
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

		jsr ui_getelementdataptr_1

        ldy #$00
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldz #$00
		ldy #$00
		lda (zpptr2),y

		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodecfont2,x
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz

		lda (zpptr2),y
		and #$0f
		tax
		lda hextodecfont2,x
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z

    	rts

uihexlabel_press
    	rts

uihexlabel_release
    	rts

; ----------------------------------------------------------------------------------------------------
