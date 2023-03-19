; ----------------------------------------------------------------------------------------------------

uiscrollbar_layout
        jsr uielement_layout
    	rts

uiscrollbar_focus
        jsr uielement_focus
	    rts

uiscrollbar_enter
        jsr uielement_enter
	    rts

uiscrollbar_leave
		jsr uielement_leave
		rts

uiscrollbar_draw
    	rts

uiscrollbar_press
    	rts

uiscrollbar_release
    	rts

uiscrollbar_move
		rts

uiscrollbar_increase
		jsr ui_getelementdataptr_tmp

		ldy #$00
		lda (zpptrtmp),y
		clc
		adc #$01
		sta (zpptrtmp),y

		jsr uiscrollbar_confine

		jsr uielement_listeners

		rts

uiscrollbar_decrease
		jsr ui_getelementdataptr_tmp

		ldy #$00
		lda (zpptrtmp),y
		sec
		sbc #$01
		sta (zpptrtmp),y

		jsr uiscrollbar_confine

:		jsr uielement_listeners

		rts

uiscrollbar_setposition
		jsr ui_getelementdataptr_tmp

		ldy #$00
		sta (zpptrtmp),y

		jsr uiscrollbar_confine

		jsr uielement_listeners

		rts

; ----------------------------------------------------------------------------------------------------

uiscrollbar_confine

		ldy #$00
		lda (zpptrtmp),y
		bpl :+
		lda #$00
		sta (zpptrtmp),y
		rts

:		ldy #UIELEMENT::height
		lda (zpptr0),y
		sec
		sbc #$01
		ldy #$00
		cmp (zpptrtmp),y
		bpl :+
		sta (zpptrtmp),y

:		rts

; ----------------------------------------------------------------------------------------------------
