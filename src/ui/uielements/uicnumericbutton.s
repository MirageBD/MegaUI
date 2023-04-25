; ----------------------------------------------------------------------------------------------------

uicnumericbutton_numberofbytes
		.byte 0

; ----------------------------------------------------------------------------------------------------

uicnumericbutton_layout

		jsr uielement_layout

		lda #$05
		sta uirect_xdeflate
		lda #$05
		sta uirect_ydeflate

		jsr uirect_deflate

		rts

uicnumericbutton_hide
		;jsr uielement_hide
		rts

uicnumericbutton_focus
		rts

uicnumericbutton_enter
		jsr uielement_enter
		rts

uicnumericbutton_leave
		rts

uicnumericbutton_move
		rts

uicnumericbutton_keypress
		rts

uicnumericbutton_keyrelease
		rts

uicnumericbutton_press
		rts

uicnumericbutton_release

		jsr uimouse_calculate_pos_in_uielement

		lda uimouse_uielement_xpos+0

		cmp #11
		bpl :+
		jsr uicnumericbutton_decrease
		jsr uicnumericbutton_redraw
		rts

:		cmp #20
		bpl :+
		jsr uicnumericbutton_increase
		jsr uicnumericbutton_redraw
		rts

:	   	rts

uicnumericbutton_doubleclick
		rts

; ----------------------------------------------------------------------------------------------------

uicnumericbutton_increase
		ldy #$02
		jsr ui_getelementdata_2

		clc
		ldy #$02
		lda (zpptr1),y
		adc #$01
		sta (zpptr1),y
		iny
		lda (zpptr1),y
		adc #$00
		sta (zpptr1),y

		jsr uicnumericbutton_storevalue

		rts

uicnumericbutton_decrease
		ldy #$02
		jsr ui_getelementdata_2

		sec
		ldy #$02
		lda (zpptr1),y
		sbc #$01
		sta (zpptr1),y
		iny
		lda (zpptr1),y
		sbc #$00
		sta (zpptr1),y

		jsr uicnumericbutton_storevalue

		rts

uicnumericbutton_storevalue

		ldy #$06
		lda (zpptr1),y
		sta uicnumericbutton_numberofbytes

		ldy #$04
		lda (zpptr1),y
		sta zpptr2+0
		ldy #$05
		lda (zpptr1),y
		sta zpptr2+1

		ldx uicnumericbutton_numberofbytes

:		ldy #$02
		lda (zpptr1),y
		ldy #$00
		sta (zpptr2),y

		clc
		lda zpptr1+0
		adc #$01
		sta zpptr1+1
		lda zpptr1+0
		adc #$00
		sta zpptr1+1

		lda zpptr2+0
		adc #$01
		sta zpptr2+1
		lda zpptr2+0
		adc #$00
		sta zpptr2+1

		dex
		bne :-

		rts

; ----------------------------------------------------------------------------------------------------

uicnumericbutton_draw
		jsr uicbutton_draw											; LV TODO - combine draw + drawpressed
uicnumericbutton_redraw
		jsr uicbutton_draw_pressed

		lda #$01
		sta uidraw_xposoffset
		lda #$01
		sta uidraw_yposoffset

		jsr uidraw_set_draw_position

        ldy #$02
		jsr ui_getelementdata_2

		ldz #$00

		lda #7*16+0
		sta [uidraw_scrptr],z
		inz
		lda #$05
		sta [uidraw_scrptr],z
		inz

		lda #7*16+1
		sta [uidraw_scrptr],z
		inz
		lda #$05
		sta [uidraw_scrptr],z
		inz

		inz
		inz

		ldy #$06
		lda (zpptr1),y
		sta uicnumericbutton_numberofbytes

		ldy uicnumericbutton_numberofbytes
		dey
:		lda zpptr2,y

		lsr
		lsr
		lsr
		lsr
		tax
		lda hextodec,x
		clc
		adc #$80
		sta [uidraw_scrptr],z
		lda #3*16+9
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz

		lda zpptr2,y
		and #$0f
		tax
		lda hextodec,x
		clc
		adc #$80
		sta [uidraw_scrptr],z
		lda #3*16+9
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz

		dey
		bpl :-

		lda #$00
		sta uidraw_xposoffset
		sta uidraw_yposoffset

		rts

; ----------------------------------------------------------------------------------------------------
