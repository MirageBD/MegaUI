; ----------------------------------------------------------------------------------------------------

uiscaletrack_startpos			.byte $00, $00, $00, $00
uiscaletrack_endpos				.byte $00, $00, $00, $00

; ----------------------------------------------------------------------------------------------------

uiscaletrack_resetqvalues

		lda #$00
		sta uiscaletrack_startpos+0
		sta uiscaletrack_startpos+1
		sta uiscaletrack_startpos+2
		sta uiscaletrack_startpos+3
		sta uiscaletrack_endpos+0
		sta uiscaletrack_endpos+1
		sta uiscaletrack_endpos+2
		sta uiscaletrack_endpos+3

		rts

; ----------------------------------------------------------------------------------------------------

uiscaletrack_layout
		jsr uielement_layout
		rts

uiscaletrack_hide
		;jsr uielement_hide
		rts

uiscaletrack_focus
		rts

uiscaletrack_enter
		rts

uiscaletrack_longpress
		rts

uiscaletrack_leave
		jsr uielement_leave
		rts

uiscaletrack_move
		lda mouse_held
		beq :+
		jsr uiscaletrack_press
:		rts

uiscaletrack_keypress
		rts

uiscaletrack_keyrelease
		rts

uiscaletrack_doubleclick
		rts

uiscaletrack_release
		jsr uielement_release
	   	rts

; ----------------------------------------------------------------------------------------------------

uiscaletrack_draw
		jsr uiscaletrack_draw_released
		jsr uiscaletrack_draw_released_puck
		rts

; ----------------------------------------------------------------------------------------------------

uiscaletrack_press

		;lda #$e0
		;DEBUG_COLOUR
		;lda #$00
		;DEBUG_COLOUR

		jsr uimouse_calculate_pos_in_uielement
		jsr uimouse_calculate_pospressed_in_uielement

		jsr uiscaletrack_resetqvalues
		jsr ui_getelementdataptr_tmp

		lda uimouse_uielement_xpos+1			; check position within track, set position
		beq :+
		rts

:		ldy #$02								; get pointer to sampleview
		lda (zpptrtmp),y
		sta zpptr2+0
		iny
		lda (zpptrtmp),y
		sta zpptr2+1

		ldy #$06								; get start position
		lda (zpptr2),y
		sta foosp1
		clc
		adc #24
		sta foosp2

		ldy #$08								; get end position
		lda (zpptr2),y
		sec
		sbc #8
		sta fooep1
		clc
		adc #24
		bcc :+
		lda #$ff
:		sta fooep2

		; If the C flag is 0, then A (unsigned) < NUM (unsigned)
		lda uimouse_uielement_xpos+0
		clc
		adc #$08
		bcc :+
		lda #$ff
:		cmp foosp1								; are we on the left side of the left side of the start puck?
		bcs insiderightofstartpuck
		rts										; yes, return

insiderightofstartpuck							; no. are we on the left side of the right side of the start puck?
		cmp foosp2
		bcs :+
		jmp setstartpos							; yes. set start pos

:		cmp fooep1								; are we on the left side of the left side of the end puck?
		bcs insiderightofendpuck

		rts										; yes, return. this should scroll eventually

insiderightofendpuck							; no. are we on the left side of the right side of the end puck?
		cmp fooep2
		bcs :+
		jmp setendpos							; yes. set end pos

:		rts

setstartpos
		lda uimouse_uielement_xpos+0
		clc
		adc #32
		bcc :+
		rts

:		ldy #$08								; smaller than end point?
		cmp (zpptr2),y
		bcc :+
		rts

:		lda uimouse_uielement_xpos+0
		sec
		sbc #04
		bcs :+
		lda #$00

:		ldy #$06
		sta (zpptr2),y

		jsr uielement_calluifunc

		rts

setendpos
		lda uimouse_uielement_xpos+0
		sec
		sbc #32
		bcs :+
		rts

:		ldy #$06								; bigger than start point?
		cmp (zpptr2),y
		bcs :+
		rts

:		lda uimouse_uielement_xpos+0
		clc
		adc #$04
		bcc :+
		lda #$ff

:		ldy #$08
		sta (zpptr2),y

		jsr uielement_calluifunc

		rts


foosp1	.byte 0
foosp2	.byte 0

fooep1	.byte 0
fooep2	.byte 0

; ----------------------------------------------------------------------------------------------------

uiscaletrack_draw_released

		jsr uidraw_set_draw_position

		lda #$00
		sta uidraw_xdeflate
		lda #$02
		sta uidraw_ydeflate
		jsr uidraw_deflate
		ldx uidraw_width
		ldy uidraw_height

		lda #5*16+11
		ldz #$00						; draw left of scrolltrack
		sta [uidraw_scrptr],z
		inz
		inz

		clc
		adc #$01

		ldx #$01
:		sta [uidraw_scrptr],z
		inz
		inz
		inx
		cpx uidraw_width
		bne :-

		clc
		adc #$01

		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------

uiscaletrack_draw_released_puck

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_tmp

		ldy #$02								; get pointer to element that holds the list in zpptr2
		lda (zpptrtmp),y
		sta zpptr2+0
		iny
		lda (zpptrtmp),y
		sta zpptr2+1

		ldy #$06								; get start pos
		lda (zpptr2),y
		lsr
		lsr
		lsr
		
		asl ; mul by 2 to get screenptr offset

		taz
		lda #4*16+6
		sta [uidraw_scrptr],z
		inz
		inz
		lda #4*16+7
		sta [uidraw_scrptr],z
		inz
		inz

		ldy #$08								; get end pos
		lda (zpptr2),y
		and #%11111000
		ldy #$06								; get start pos
		sbc (zpptr2),y
		lsr
		lsr
		lsr
		
		sec
		sbc #$02
		tax

		lda #5*16+14
:		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-

		lda #4*16+6
		sta [uidraw_scrptr],z
		inz
		inz
		lda #4*16+7
		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------
