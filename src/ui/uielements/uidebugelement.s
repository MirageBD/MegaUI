; ----------------------------------------------------------------------------------------------------

uidebugelement_layout
		jsr uielement_layout
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
		jsr uielement_press

		lda #6*16+8
		sta uidebug_debugcolour
		jsr uidebug_drawelement
    	rts

uidebugelement_doubleclick
		rts

uidebugelement_release
		jsr uielement_release

		lda #6*16+0
		sta uidebug_debugcolour
		jsr uidebug_drawelement
    	rts

uidebugelement_move
		;jsr uielement_move
		rts

uidebugelement_keypress
		rts

uidebugelement_keyrelease
		rts
		
; ----------------------------------------------------------------------------------------------------
