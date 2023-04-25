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
	   	rts

uicnumericbutton_doubleclick
		rts
	
; ----------------------------------------------------------------------------------------------------

uicnumericbutton_draw
		jsr uicbutton_draw											; LV TODO - combine draw + drawpressed
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

        ldy #$08
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
