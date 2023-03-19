uidebug_debugcolour
		.byte $00

uidebug_drawelement

		jsr uidraw_set_draw_position

		sec
		ldy #UIELEMENT::width
		lda (zpptr0),y
		sbc #$02
		sta uidraw_width
		sec
		ldy #UIELEMENT::height
		lda (zpptr0),y
		sbc #$02
		sta uidraw_height

		lda uidebug_debugcolour
		tay

		ldx uidraw_width

		clc
		ldz #$00						; draw top of nineslice
		tya
		sta [uidraw_scrptr],z
		inz
		inz
		adc #$01
		phx
:		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		adc #$01
		sta [uidraw_scrptr],z

		jsr uidraw_increase_row

		tya
		clc
		adc #3
		tay

:		ldz #$00						; draw center of nineslice
		tya
		sta [uidraw_scrptr],z
		inz
		inz
		pha
		phx
:		inz
		inz
		dex
		bne :-
		plx
		pla
		adc #$01
		sta [uidraw_scrptr],z

		jsr uidraw_increase_row

		dec uidraw_height
		lda uidraw_height
		bne :--

		tya
		clc
		adc #2

		ldz #$00						; draw bottom of nineslice
		sta [uidraw_scrptr],z
		inz
		inz
		adc #$01
		phx
:		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-
		plx
		adc #$01
		sta [uidraw_scrptr],z

		rts

