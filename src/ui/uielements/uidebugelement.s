; ----------------------------------------------------------------------------------------------------

uidebugelement_layout
		jsr uielement_layout
    	rts

uidebugelement_focus
		jsr uielement_focus
	    rts

uidebugelement_enter
		jsr uielement_enter

		lda #$e8
		sta uidebug_debugcolour
		jsr uidebug_drawelement

	    rts

uidebugelement_leave
		jsr uielement_leave

		lda #$e0
		sta uidebug_debugcolour
		jsr uidebug_drawelement
		rts

uidebugelement_draw

		lda #$e0
		sta uidebug_debugcolour
		jsr uidebug_drawelement
    	rts

uidebugelement_press
		jsr uielement_press

		lda #$f0
		sta uidebug_debugcolour
		jsr uidebug_drawelement
    	rts

uidebugelement_release
		jsr uielement_release

		lda #$e8
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
