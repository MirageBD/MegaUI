; ----------------------------------------------------------------------------------------------------

uiscaletrack_startpos			.byte $00, $00, $00, $00

; ----------------------------------------------------------------------------------------------------

uiscaletrack_resetqvalues

		lda #$00
		sta uiscaletrack_startpos+0
		sta uiscaletrack_startpos+1
		sta uiscaletrack_startpos+2
		sta uiscaletrack_startpos+3

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
		jsr uimouse_calculate_pos_in_uielement
		jsr uiscaletrack_resetqvalues
		jsr ui_getelementdataptr_tmp

		lda uimouse_uielement_xpos+1			; check position within track, set position
		cmp #$ff
		bne :+
		rts

:		lda uimouse_uielement_xpos+0			; for now, put position in track in uiscaletrack_startpos
		sta uiscaletrack_startpos+2
		lda uimouse_uielement_xpos+1
		sta uiscaletrack_startpos+3

		ldy #$02								; get pointer to element that holds the list in zpptr2
		lda (zpptrtmp),y
		sta zpptr2+0
		iny
		lda (zpptrtmp),y
		sta zpptr2+1

		; set start pos
		ldy #$06
		lda uiscaletrack_startpos+2
		sta (zpptr2),y

		jsr uielement_calluifunc

		rts

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
		lda #5*16+14
		sta [uidraw_scrptr],z
		inz
		inz
		lda #5*16+15
		sta [uidraw_scrptr],z

		rts

; ----------------------------------------------------------------------------------------------------
