; ----------------------------------------------------------------------------------------------------

uicheckbox_layout

		jsr uielement_layout
		rts

; ----------------------------------------------------------------------------------------------------

uicheckbox_focus
		rts

; ----------------------------------------------------------------------------------------------------

uicheckbox_enter
		rts

; ----------------------------------------------------------------------------------------------------

uicheckbox_leave
		jsr uielement_leave
		rts

; ----------------------------------------------------------------------------------------------------

uicheckbox_move
		;jsr uielement_move
		rts

; ----------------------------------------------------------------------------------------------------

uicheckbox_draw

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_1

		ldy #$00							; store off or on
		lda (zpptr1),y
		clc
		adc #$01
		tay

		lda (zpptr1),y
		tay

		ldx #$00
		ldz #$00
		tya
:		sta [uidraw_scrptr],z
		inz
		inz
		adc #$01
		inx
		cpx uidraw_width
		bne :-
		
		rts

; ----------------------------------------------------------------------------------------------------

uicheckbox_press
		jsr uielement_press
		rts

; ----------------------------------------------------------------------------------------------------

uicheckbox_release
		jsr uielement_release

		jsr ui_getelementdataptr_1

		ldy #$00							; get off or on
		lda (zpptr1),y
		beq :+
		lda #$00
		sta (zpptr1),y
		bra :++

:		lda #$01
		sta (zpptr1),y

:		jsr uicheckbox_draw
	   	rts

; ----------------------------------------------------------------------------------------------------
