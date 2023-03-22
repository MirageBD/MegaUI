; ----------------------------------------------------------------------------------------------------

uilabel_layout
        jsr uielement_layout
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
		
; ----------------------------------------------------------------------------------------------------

uilabel_draw

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_1

        ldy #$00
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$00
		ldz #$00
:		lda (zpptr2),y
		beq :+
		clc
		adc #32
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz
		iny
 		bra :-
:
    	rts

uilabel_press
    	rts

uilabel_release
    	rts

; ----------------------------------------------------------------------------------------------------
