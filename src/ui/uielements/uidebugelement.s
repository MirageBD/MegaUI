; ----------------------------------------------------------------------------------------------------

uidebugelement_layout
		jsr uielement_layout
    	rts

uidebugelement_hide
		;jsr uielement_hide
		rts

uidebugelement_focus
		jsr uielement_focus
	    rts

uidebugelement_enter
		jsr uielement_enter
		lda #6*16+8
		sta uidebug_debugcolour
		jsr uidebug_drawelement
	    rts

uidebugelement_leave
		jsr uielement_leave
		lda #6*16+0
		sta uidebug_debugcolour
		jsr uidebug_drawelement
		rts

uidebugelement_draw
		lda #6*16+0
		sta uidebug_debugcolour
		jsr uidebug_drawelement
    	rts

uidebugelement_press
    	rts

uidebugelement_longpress
		rts

uidebugelement_doubleclick
		rts

uidebugelement_release
    	rts

uidebugelement_move
		rts

uidebugelement_keypress
		rts

uidebugelement_keyrelease
		rts
		
; ----------------------------------------------------------------------------------------------------
