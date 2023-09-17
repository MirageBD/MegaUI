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

		; $dc00 = data port A
		;	read/write:	bit 0...7 keyboard matrix columns
		;	read:		joystick port 2:	bit 0..3 direction, but 4 fire button, 0 = activated
		;	read:		lightpen:			bit 4 (as fire button), connected also with '/LP' (pin 9) of the vic
		;	read:		paddles:			bit 2..3 fire buttons, bit 6..7 switch control port 1 (%01=Paddles A) or 2 (%10=Paddles B)
		; $dc01 = data port B
		;	read/write:	bit 0...7 keyboard matrix columns
		;	read:		joystick port 1:	bit 0..3 direction, but 4 fire button, 0 = activated
		;	read:		bit 6:				Timer A: Toggle/Impulse output (see register 14 bit 2)
		;	read:		bit 7:				Timer B: Toggle/Impulse output (see register 15 bit 2)
		; $dc02 = Data Direction Port A
		; 	Bit X: 0=Input (read only), 1=Output (read and write)
		; $dc03 = Data Direction Port B
		; 	Bit X: 0=Input (read only), 1=Output (read and write)

		rts

		ldx $dc00									; #$7f when nothing is pressed

		txa
		and #%00000001								; up
		bne joystick_down
		sec
		lda mouse_paddley
		sbc #$04
		sta mouse_paddley
		jmp joystick_left
joystick_down
		txa
		and #%00000010								; down
		bne joystick_left
		clc
		lda mouse_paddley
		adc #$04
		sta mouse_paddley
joystick_left
		txa
		and #%00000100								; left
		bne joystick_right
		clc
		lda mouse_paddlex
		adc #$04
		sta mouse_paddlex
		jmp joystick_fire
joystick_right
		txa
		and #%00001000								; right
		bne joystick_fire
		sec
		lda mouse_paddlex
		sbc #$04
		sta mouse_paddlex
joystick_fire
		txa
		and #%00010000								; fire
		bne joystick_end_test
		jsr mouse_event_pressed
		rts

joystick_end_test
		;jsr mouse_event_released
		rts
		