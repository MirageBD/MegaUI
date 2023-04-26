; ----------------------------------------------------------------------------------------------------

uilabel_layout
        jsr uielement_layout
    	rts

uilabel_hide
		;jsr uielement_hide
		rts

uilabel_focus
	    rts

uilabel_enter
	    rts

uilabel_leave
		rts

uilabel_move
		rts

uilabel_keypress
		rts

uilabel_keyrelease
		rts

uilabel_press
    	rts

uilabel_longpress
		rts

uilabel_doubleclick
		rts

uilabel_release
    	rts

; ----------------------------------------------------------------------------------------------------

uilabel_draw

		jsr uidraw_set_draw_position

		ldy #$02
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
    	rts

; ----------------------------------------------------------------------------------------------------
