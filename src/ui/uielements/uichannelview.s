; ----------------------------------------------------------------------------------------------------

uichannelview_colour		.byte $00

; ----------------------------------------------------------------------------------------------------

uichannelview_update

		ldy #$06
		jsr ui_getelementdata_2

		ldx zpptr2+0										; decrease vu strength by 1
		beq :+
		dex
		txa
		ldy #$06
		sta (zpptr1),y

:		rts

; ----------------------------------------------------------------------------------------------------

uichannelview_layout
        jsr uielement_layout
    	rts

uichannelview_focus
	    rts

uichannelview_enter
	    rts

uichannelview_leave
		rts

uichannelview_move
		rts

uichannelview_keypress
		rts

uichannelview_keyrelease
		rts

uichannelview_press
    	rts

uichannelview_doubleclick
		rts

uichannelview_release
		rts

uichannelview_draw
		jsr uichannelview_drawbkgreleased
		jsr uichannelview_drawbarsreleased
		rts

; ----------------------------------------------------------------------------------------------------

uichannelview_drawbkgreleased

		jsr uidraw_set_draw_position

		ldy #UIELEMENT::width
		lda (zpptr0),y
		sta uidraw_width
		ldy #UIELEMENT::height
		lda (zpptr0),y
		sta uidraw_height

:		ldx uidraw_width
		ldz #$00
:		lda #$00										; black background
		sta [uidraw_colptr],z
		inz
		inz
		dex
		bne :-

		jsr uidraw_increase_row

		dec uidraw_height
		lda uidraw_height
		bne :--

		rts

; ----------------------------------------------------------------------------------------------------

uichannelview_drawbarsreleased

		jsr uidraw_set_draw_position

		ldy #$04
		jsr ui_getelementdata_2

		lda zpptr2+0
		sta uichannelview_colour

		ldx uidraw_width
		ldz #$00
:		lda #$3e
		sta [uidraw_scrptr],z
		lda uichannelview_colour
		sta [uidraw_colptr],z
		inz
		inz
		dex
		bne :-

		jsr uidraw_increase_row

		ldy #$06							; get VU strength
		lda (zpptr1),y
		beq uichannelview_drawbarsreleased_end
		tax

		ldy #$00
		ldz #10
:		lda #$3e
		sta [uidraw_scrptr],z
		lda ucv_vucolours,y
		sta [uidraw_colptr],z
		dez
		dez
		iny
		dex
		bne :-

		ldy #$06							; get VU strength
		lda (zpptr1),y
		tax

		ldy #$00
		ldz #14
:		lda #$3e
		sta [uidraw_scrptr],z
		lda ucv_vucolours,y
		sta [uidraw_colptr],z
		inz
		inz
		iny
		dex
		bne :-

uichannelview_drawbarsreleased_end

		rts

; ----------------------------------------------------------------------------------------------------

prevd72as	.byte $00
			.byte $00
			.byte $00
			.byte $00

uichannelview_capturevu

		ldy #$02
		jsr ui_getelementdata_2

		lda zpptr2+0									; get channel number
		tax
		asl
		asl
		asl
		asl
		tay

		lda $d72a,y
		cmp prevd72as,x
		bne :+
		rts

:		sta prevd72as,x

;		lda #%00000000									; disable audio DMA, so registers can latch
;		sta $d711

		lda $d72a,y
		sta $10
		lda $d72b,y
		sta $11
		lda $d72c,y
		sta $12
		lda #$00
		sta $13

		ldz #$00
		lda [$10],z
		tay
		lda sampleremap,y
		lsr
		lsr
		lsr
		lsr
		lsr
		clc
		ldy #$06
		adc (zpptr1),y
		lsr
		cmp (zpptr1),y
		bmi :+
		sta (zpptr1),y

:

;		lda #%10000000									; enable audio DMA
;		sta $d711

		rts

; ----------------------------------------------------------------------------------------------------

ucv_vucolours
		.byte $e7, $99, $51, $2d, $39, $4b

.align 256
sampleremap
.repeat 256, I
	.byte ((128 + I) .MOD 256)
.endrepeat		