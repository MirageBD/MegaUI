; ----------------------------------------------------------------------------------------------------

uitextbox_layout
        jsr uielement_layout
    	rts

uitextbox_focus
	    rts

uitextbox_enter
	    rts

uitextbox_leave
		rts

uitextbox_move
		rts

uitextbox_keypress
		rts

uitextbox_keyrelease
		rts

uitextbox_press
    	rts

uitextbox_doubleclick
		rts

uitextbox_release
    	rts

; ----------------------------------------------------------------------------------------------------

uitextbox_draw

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_1

        ldy #$02
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

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
    	rts

; ----------------------------------------------------------------------------------------------------
