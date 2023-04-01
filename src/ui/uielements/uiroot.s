; ----------------------------------------------------------------------------------------------------

uiroot_layout
		jsr uielement_layout

		lda #$01
		sta uirect_xdeflate
		lda #$01
		sta uirect_ydeflate

		jsr uirect_deflate

    	rts

uiroot_focus
		jsr uielement_focus
	    rts

uiroot_enter
		jsr uielement_enter
	    rts

uiroot_leave
		jsr uielement_leave
		rts

uiroot_draw
	   	rts

uiroot_press
		jsr uielement_press
    	rts

uiroot_doubleclick
		jsr uielement_doubleclick
		rts

uiroot_release
		jsr uielement_release
    	rts

uiroot_move
		jsr uielement_move
		rts

uiroot_keypress
		jsr uielement_keypress
		rts

uiroot_keyrelease
		jsr uielement_keyrelease
		rts
		
; ----------------------------------------------------------------------------------------------------
