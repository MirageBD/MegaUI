joystick_pressed				.byte $00			; this will be 1 for every frame that the button is pressed, not just 1 frame
joystick_held					.byte $00
joystick_longpressed			.byte $00
joystick_released				.byte $00			; this will only be 1 in the frame in which the button was released
joystick_doubleclicked			.byte $00

joystick_released_timer			.byte $00
joystick_doubleclickthreshold	.byte $10

joystick_pressedtimer			.byte $00
joystick_longpressedtimer		.byte $00

; TODO - what happens if both mouse and joystick can control the cursor?
; split off mouse_xpos_plusborder into cursor_xpos_plusborder?
; move all cursor stuff into its own file and let mouse and joystick reference it?

joystick_init
		rts

joystick_update
		ldx $dc00									; #$7f when nothing is pressed

		txa
		and #%00000001								; up
		bne joystick_down
		;dec cursor_y_pos
		jmp joystick_left
joystick_down
		txa
		and #%00000010								; down
		bne joystick_left
		;inc cursor_y_pos
joystick_left
		txa
		and #%00000100								; left
		bne joystick_right
		;dec cursor_x_pos
		jmp joystick_fire
joystick_right
		txa
		and #%00001000								; right
		bne joystick_fire
		;inc cursor_x_pos
joystick_fire
		txa
		and #%00010000								; fire

		rts