uijoystick_init
		lda #<(sprites/64)
		sta sprptrs+0
		lda #>(sprites/64)
		sta sprptrs+1
		rts

uijoystick_update
		rts