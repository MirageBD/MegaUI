uirect_xdeflate     .byte $00
uirect_ydeflate     .byte $00

uirect_calcminmax

		clc
		ldy #UIELEMENT::xpos
		lda (zpptr0),y
		adc uielement_layoutxpos
		ldy #UIELEMENT::layoutxpos
		sta (zpptr0),y
        ldy #UIELEMENT::xmin
        sta (zpptr0),y

        clc
		ldy #UIELEMENT::width
        lda (zpptr0),y
		ldy #UIELEMENT::layoutxpos
		adc (zpptr0),y
        ldy #UIELEMENT::xmax
        sta (zpptr0),y

		clc
		ldy #UIELEMENT::ypos
		lda (zpptr0),y
		adc uielement_layoutypos
		ldy #UIELEMENT::layoutypos
		sta (zpptr0),y
        ldy #UIELEMENT::ymin
        sta (zpptr0),y

        clc
		ldy #UIELEMENT::height
        lda (zpptr0),y
		ldy #UIELEMENT::layoutypos
		adc (zpptr0),y
        ldy #UIELEMENT::ymax
        sta (zpptr0),y

		ldx #$00
:		ldy #UIELEMENT::xmin
		lda (zpptr0),y
		asl
		sta (zpptr0),y
		iny
		lda (zpptr0),y
		rol
		sta (zpptr0),y

		ldy #UIELEMENT::xmax
		lda (zpptr0),y
		asl
		sta (zpptr0),y
		iny
		lda (zpptr0),y
		rol
		sta (zpptr0),y

		ldy #UIELEMENT::ymin
		lda (zpptr0),y
		asl
		sta (zpptr0),y
		iny
		lda (zpptr0),y
		rol
		sta (zpptr0),y

		ldy #UIELEMENT::ymax
		lda (zpptr0),y
		asl
		sta (zpptr0),y
		iny
		lda (zpptr0),y
		rol
		sta (zpptr0),y
		inx
		cpx #$03
		bne :-

		; have to subtract one pixel in x (because of the BB calculations, most likely)
		sec
		ldy #UIELEMENT::xmin
		lda (zpptr0),y
		sbc #$01
		sta (zpptr0),y
		iny
		lda (zpptr0),y
		sbc #$00
		sta (zpptr0),y

		sec
		ldy #UIELEMENT::xmax
		lda (zpptr0),y
		sbc #$01
		sta (zpptr0),y
		iny
		lda (zpptr0),y
		sbc #$00
		sta (zpptr0),y

        rts

; ----------------------------------------------------------------------------------------------------

uirect_deflate

   		clc
		ldy #UIELEMENT::xmin
		lda (zpptr0),y
		adc uirect_xdeflate
		sta (zpptr0),y
		iny
		lda (zpptr0),y
		adc #$00
		sta (zpptr0),y

		clc
		ldy #UIELEMENT::ymin
		lda (zpptr0),y
		adc uirect_ydeflate
		sta (zpptr0),y
		iny
		lda (zpptr0),y
		adc #$00
		sta (zpptr0),y

		sec
		ldy #UIELEMENT::xmax
		lda (zpptr0),y
		sbc uirect_xdeflate
		sta (zpptr0),y
		iny
		lda (zpptr0),y
		sbc #$00
		sta (zpptr0),y

		sec
		ldy #UIELEMENT::ymax
		lda (zpptr0),y
		sbc uirect_ydeflate
		sta (zpptr0),y
		iny
		lda (zpptr0),y
		sbc #$00
		sta (zpptr0),y

        rts

; ----------------------------------------------------------------------------------------------------
