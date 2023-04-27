; ----------------------------------------------------------------------------------------------------

uisampleviewtmp0			.dword 0

stored_zpptrtmp				.word 0

sampbit						.byte 0

sampbits					.byte %10000000
							.byte %01000000
							.byte %00100000
							.byte %00010000
							.byte %00001000
							.byte %00000100
							.byte %00000010
							.byte %00000001

times8tablelo				.repeat 64, I
								.byte <(I*8)
							.endrepeat

times8tablehi				.repeat 64, I
								.byte >(I*8)
							.endrepeat

columntospritehi			.byte $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0
							.byte $d2, $d2, $d2, $d2, $d2, $d2, $d2, $d2
							.byte $d4, $d4, $d4, $d4, $d4, $d4, $d4, $d4
							.byte $d6, $d6, $d6, $d6, $d6, $d6, $d6, $d6

.align 256
sampleremap					
							;.repeat 256, I
							;	.byte (<(-I)) >> 2
							;.endrepeat

							.byte $01

							.byte $3e, $3e, $3e, $3e, $3e, $3e, $3e, $3e, $3d, $3d, $3d, $3d, $3c, $3c, $3c, $3c
							.byte $3b, $3b, $3b, $3b, $3a, $3a, $3a, $3a, $39, $39, $39, $39, $38, $38, $38, $38
							.byte $37, $37, $37, $37, $36, $36, $36, $36, $35, $35, $35, $35, $34, $34, $34, $34
							.byte $33, $33, $33, $33, $32, $32, $32, $32, $31, $31, $31, $31, $30, $30, $30, $30

							.byte $2f, $2f, $2f, $2f, $2e, $2e, $2e, $2e, $2d, $2d, $2d, $2d, $2c, $2c, $2c, $2c
							.byte $2b, $2b, $2b, $2b, $2a, $2a, $2a, $2a, $29, $29, $29, $29, $28, $28, $28, $28
							.byte $27, $27, $27, $27, $26, $26, $26, $26, $25, $25, $25, $25, $24, $24, $24, $24
							.byte $23, $23, $23, $23, $22, $22, $22, $22, $21, $21, $21, $21, $20, $20, $20, $20

							.byte $1f, $1f, $1f, $1f, $1e, $1e, $1e, $1e, $1d, $1d, $1d, $1d, $1c, $1c, $1c, $1c
							.byte $1b, $1b, $1b, $1b, $1a, $1a, $1a, $1a, $19, $19, $19, $19, $18, $18, $18, $18
							.byte $17, $17, $17, $17, $16, $16, $16, $16, $15, $15, $15, $15, $14, $14, $14, $14
							.byte $13, $13, $13, $13, $12, $12, $12, $12, $11, $11, $11, $11, $10, $10, $10, $10

							.byte $0f, $0f, $0f, $0f, $0e, $0e, $0e, $0e, $0d, $0d, $0d, $0d, $0c, $0c, $0c, $0c
							.byte $0b, $0b, $0b, $0b, $0a, $0a, $0a, $0a, $09, $09, $09, $09, $08, $08, $08, $08
							.byte $07, $07, $07, $07, $06, $06, $06, $06, $05, $05, $05, $05, $04, $04, $04, $04
							.byte $03, $03, $03, $03, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01

samplebuffermin				.repeat 256, I
								.byte 0
							.endrepeat

samplebuffermax				.repeat 256, I
								.byte 0
							.endrepeat

uisampleview_sampleindex	.byte 2; 2

; ----------------------------------------------------------------------------------------------------


uisampleview_layout

		jsr uielement_layout

		lda #<((samplesprites+0*512)/64)
		sta sprptrs+2*2+0
		lda #>((samplesprites+0*512)/64)
		sta sprptrs+2*2+1

		lda #<((samplesprites+1*512)/64)
		sta sprptrs+3*2+0
		lda #>((samplesprites+1*512)/64)
		sta sprptrs+3*2+1

		lda #<((samplesprites+2*512)/64)
		sta sprptrs+4*2+0
		lda #>((samplesprites+2*512)/64)
		sta sprptrs+4*2+1

		lda #<((samplesprites+3*512)/64)
		sta sprptrs+5*2+0
		lda #>((samplesprites+3*512)/64)
		sta sprptrs+5*2+1

    	rts

uisampleview_hide
		;jsr uielement_hide

		lda $d015
		and #%11000011
		sta $d015

		rts

uisampleview_focus
	    rts

uisampleview_enter
	    rts

uisampleview_leave
		rts

uisampleview_draw

		lda $d015
		and #%11000011
		ora #%00111100
		sta $d015

		lda $d010
		and #%11000011
		ora #%00011100
		sta $d010										; sprite horizontal position MSBs
		lda $d05f										; Sprite H640 X Super-MSBs
		and #%11000011
		ora #%00100000
		sta $d05f										; Sprite H640 X Super-MSBs

		lda $d077
		and #%11000011
		ora #%00111100
		sta $d077										; Sprite V400 Y position MSBs

		lda #$50										; sprite y positions
		sta $d000+2*2+1
		sta $d000+3*2+1
		sta $d000+4*2+1
		sta $d000+5*2+1

		lda #$60+0*64									; sprite x positions
		sta $d000+2*2+0
		lda #$60+1*64									; sprite x positions
		sta $d000+3*2+0
		lda #$60+2*64									; sprite x positions
		sta $d000+4*2+0
		lda #$60+3*64									; sprite x positions
		sta $d000+5*2+0
		
		lda #$03
		sta $d027+2
		lda #$03
		sta $d027+3
		lda #$03
		sta $d027+4
		lda #$03
		sta $d027+5
		
		jsr uisampleview_clearsample

		ldy #$00										; dummy to get zpptr1 data
		jsr ui_getelementdata_2
		ldy #$05
		lda (zpptr1),y									; skip drawing if sample length == 0
		bne :+
		ldy #$04
		lda (zpptr1),y
		bne :+
		rts
:
		jsr uisampleview_rendersample
		jsr uisampleview_plotsample
		jsr uisampleview_xorfill

		rts

uisampleview_press
		;jsr uisampleview_draw
    	rts

uisampleview_longpress
		rts

uisampleview_doubleclick
		rts

uisampleview_release
		rts

uisampleview_move
		rts

uisampleview_keypress
		rts

uisampleview_keyrelease
		rts

; ----------------------------------------------------------------------------------------------------

uisampleview_clearsample

		lda #<.loword(samplesprites)
		sta zpptrtmp+0
		lda #>.loword(samplesprites)
		sta zpptrtmp+1
		lda #<.hiword(samplesprites)					; set up pointer to $00 1d 00 00
		sta zpptrtmp+2
		lda #>.hiword(samplesprites)
		sta zpptrtmp+3

		ldx #$00										; clear sprites - use DMA for this!
		lda #$00
		ldz #$00
:		sta [zpptrtmp],z
		inz
		bne :-
		inc zpptrtmp+1
		inx
		cpx #$08
		bne :-

		rts

; ----------------------------------------------------------------------------------------------------

uisampleview_minvalue	.byte $00
uisampleview_maxvalue	.byte $00

uisampleview_step		.word $00

uisampleview_rendersample

		ldy #$00										; dummy to get zpptr1 data
		jsr ui_getelementdata_2

		ldy #$02
		lda (zpptr1),y									; get sample index

		asl
		tax
		lda idxPepIns0+0,x
		sta zpptrtmp+0
		lda idxPepIns0+1,x
		sta zpptrtmp+1

		ldy #6
		lda (zpptrtmp),y
		sta uisampleview_step+0
		ldy #7
		lda (zpptrtmp),y
		sta uisampleview_step+1

		lsr uisampleview_step+1
		ror uisampleview_step+0
		lsr uisampleview_step+1
		ror uisampleview_step+0
		lsr uisampleview_step+1
		ror uisampleview_step+0
		lsr uisampleview_step+1
		ror uisampleview_step+0
		lsr uisampleview_step+1
		ror uisampleview_step+0
		lsr uisampleview_step+1
		ror uisampleview_step+0
		lsr uisampleview_step+1
		ror uisampleview_step+0
		lsr uisampleview_step+1
		ror uisampleview_step+0

		ldy #12											; sample address in instrument
		lda (zpptrtmp),y
		sta zpptrtmp2+0
		iny
		lda (zpptrtmp),y
		sta zpptrtmp2+1
		iny
		lda (zpptrtmp),y
		sta zpptrtmp2+2
		iny
		lda (zpptrtmp),y
		sta zpptrtmp2+3

		; sample address = zpptrtmp2

		ldx #$00

uisampleview_rendersample_loop

		lda #255
		sta uisampleview_minvalue
		lda #0
		sta uisampleview_maxvalue

		ldz #$00
:		lda [zpptrtmp2],z
		clc
		adc #129
		cmp uisampleview_minvalue				; carry 0 : A < minvalue
		bcs :+
		sta uisampleview_minvalue
:		cmp uisampleview_maxvalue
		bcc :+									; carry 0 : A < maxvalue
		sta uisampleview_maxvalue
:		inz
		cpz uisampleview_step+0
		bne :---

		lda uisampleview_minvalue
		sta samplebuffermin,x
		lda uisampleview_maxvalue
		sta samplebuffermax,x

		clc
		lda zpptrtmp2+0
		adc uisampleview_step+0
		sta zpptrtmp2+0
		lda zpptrtmp2+1
		adc #$00
		sta zpptrtmp2+1
		lda zpptrtmp2+2
		adc #$00
		sta zpptrtmp2+2
		lda zpptrtmp2+3
		adc #$00
		sta zpptrtmp2+3

		inx
		bne uisampleview_rendersample_loop

		rts

; ----------------------------------------------------------------------------------------------------


uisampleview_plotsample

		ldy #$00										; dummy to get zpptr1 data
		jsr ui_getelementdata_2

		ldy #$02
		lda (zpptr1),y									; get sample index

		asl
		tax
		lda idxPepIns0+0,x
		sta zpptrtmp+0
		lda idxPepIns0+1,x
		sta zpptrtmp+1

		ldy #12											; sample address in instrument
		lda (zpptrtmp),y
		sta zpptrtmp2+0
		iny
		lda (zpptrtmp),y
		sta zpptrtmp2+1
		iny
		lda (zpptrtmp),y
		sta zpptrtmp2+2
		iny
		lda (zpptrtmp),y
		sta zpptrtmp2+3


		lda #<.loword(samplesprites)					; $00
		sta zpptrtmp+0
		lda #>.loword(samplesprites)					; $d0
		sta zpptrtmp+1
		lda #<.hiword(samplesprites)					; set up pointer to $00 1d 00 00
		sta zpptrtmp+2
		lda #>.hiword(samplesprites)
		sta zpptrtmp+3

		ldz #$00
		ldx #$00

uisampleview_plotsample_loop

		txa												; calculate char column
		lsr
		lsr
		lsr
		clc
		tay
		and #%00000111
		sta zpptrtmp+0
		sta stored_zpptrtmp+0
		lda columntospritehi,y
		sta zpptrtmp+1
		sta stored_zpptrtmp+1

		txa												; get pixel within char
		and #%00000111
		tay
		lda sampbits,y
		sta sampbit



		lda samplebuffermin,x							; get sample min value
		tay
		lda sampleremap,y
		tay
		lda times8tablelo,y
		clc
		adc zpptrtmp+0
		sta zpptrtmp+0
		clc
		lda times8tablehi,y
		adc zpptrtmp+1
		sta zpptrtmp+1

		lda sampbit
		ora [zpptrtmp],z
		sta [zpptrtmp],z



		lda stored_zpptrtmp+0
		sta zpptrtmp+0
		lda stored_zpptrtmp+1
		sta zpptrtmp+1





		lda samplebuffermax,x							; get sample data and bring into 0-64 range
		tay
		lda sampleremap,y
		sec
		sbc #$01
		tay
		lda times8tablelo,y								; get height of pixel
		clc
		adc zpptrtmp+0
		sta zpptrtmp+0
		clc
		lda times8tablehi,y
		adc zpptrtmp+1
		sta zpptrtmp+1

		lda sampbit
		ora [zpptrtmp],z
		sta [zpptrtmp],z





		inx
		beq :+
		jmp uisampleview_plotsample_loop

:		rts

; ----------------------------------------------------------------------------------------------------

uisampleview_xorfill

		lda #<.loword(samplesprites)					; $00
		sta zpptrtmp+0
		lda #>.loword(samplesprites)					; $d0
		sta zpptrtmp+1
		lda #<.hiword(samplesprites)					; set up pointer to $00 1d 00 00
		sta zpptrtmp+2
		lda #>.hiword(samplesprites)
		sta zpptrtmp+3

		clc
		lda zpptrtmp+0
		adc #$08
		sta zpptrtmp2+0
		lda zpptrtmp+1
		adc #$00
		sta zpptrtmp2+1
		lda zpptrtmp+2
		adc #$00
		sta zpptrtmp2+2
		lda zpptrtmp+3
		adc #$00
		sta zpptrtmp2+3

		ldx #$00
		ldz #$00
:		lda [zpptrtmp],z
		eor [zpptrtmp2],z
		sta [zpptrtmp2],z
		inz
		bne :-

		inc zpptrtmp+1	
		inc zpptrtmp2+1	

		inx
		cpx #$08
		bne :-

		rts

; ----------------------------------------------------------------------------------------------------

