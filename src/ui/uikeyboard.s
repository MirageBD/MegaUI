; ----------------------------------------------------------------------------------------------------

uikeyboard_focuselement				.word 0

; ----------------------------------------------------------------------------------------------------

uikeyboard_update

        lda keyboard_shouldsendreleaseevent
        beq :+
        jsr uikeyboard_handlereleaseevent
		rts

:       lda keyboard_shouldsendpressevent
        beq :+
		jsr uikeyboard_handlepressevent
		rts

:       rts

; ----------------------------------------------------------------------------------------------------

uikeyboard_handlereleaseevent

		lda uikeyboard_focuselement+0
		sta zpptr0+0
		lda uikeyboard_focuselement+1
		sta zpptr0+1

		SEND_EVENT keyrelease
		rts

; ----------------------------------------------------------------------------------------------------

uikeyboard_handlepressevent

		lda uikeyboard_focuselement+0
		sta zpptr0+0
		lda uikeyboard_focuselement+1
		sta zpptr0+1

		SEND_EVENT keypress
		rts

; ----------------------------------------------------------------------------------------------------
