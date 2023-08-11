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
		rts