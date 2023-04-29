; ----------------------------------------------------------------------------------------------------

stored_zpptrtmp				.word 0

zoomfactor					.word 1

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

; Q registers for math
uisampleview_samplength		.byte $00, $00, $00, $00
uisampleview_sampviewlength	.byte $00, $00, $00, $00
uisampleview_samprendstep	.byte $00, $00, $00, $00
uisampleview_sp				.byte $00, $00, $00, $00
uisampleview_ep				.byte $00, $00, $00, $00
uisampleview_newsamplength	.byte $00, $00, $00, $00


.align 256
sampleremap					
							;.repeat 256, I
							;	.byte (<(-1-I)) >> 2
							;.endrepeat

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
							.byte $03, $03, $03, $03, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01

samplebuffermin				.repeat 256, I
								.byte 0
							.endrepeat

samplebuffermax				.repeat 256, I
								.byte 0
							.endrepeat

uisampleview_sampleindex	.byte 2; 2

uisampleview_startpos		.byte 0, 0, 128, 0		; 0-255
uisampleview_endpos			.byte 0, 0, 255, 0		; 0-255

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

		lda $d01b
		and #%11000011
		ora #%00111100
		sta $d01b

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

		lda #$5f+0*64									; sprite x positions
		sta $d000+2*2+0
		lda #$5f+1*64									; sprite x positions
		sta $d000+3*2+0
		lda #$5f+2*64									; sprite x positions
		sta $d000+4*2+0
		lda #$5f+3*64									; sprite x positions
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
		jsr uisampleview_drawbackground
		jsr uisampleview_rendersample
		jsr uisampleview_plotsample
		jsr uisampleview_xorfill
		jsr uisampleview_copytosprites

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

		lda #<.loword(samplespritesbuf)
		sta zpptrtmp+0
		lda #>.loword(samplespritesbuf)
		sta zpptrtmp+1
		lda #<.hiword(samplespritesbuf)					; set up pointer to $00 1d 00 00
		sta zpptrtmp+2
		lda #>.hiword(samplespritesbuf)
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

uisampleview_copytosprites

		lda #<.loword(samplespritesbuf)
		sta zpptrtmp+0
		lda #>.loword(samplespritesbuf)
		sta zpptrtmp+1
		lda #<.hiword(samplespritesbuf)					; set up pointer to $00 1d 00 00
		sta zpptrtmp+2
		lda #>.hiword(samplespritesbuf)
		sta zpptrtmp+3

		lda #<.loword(samplesprites)
		sta zpptrtmp2+0
		lda #>.loword(samplesprites)
		sta zpptrtmp2+1
		lda #<.hiword(samplesprites)					; set up pointer to $00 1d 00 00
		sta zpptrtmp2+2
		lda #>.hiword(samplesprites)
		sta zpptrtmp2+3

		ldx #$00										; copy buffer - use DMA for this!
		lda #$00
		ldz #$00
:		lda [zpptrtmp],z
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

		ldy #$06
		lda (zpptr1),y									; get start pos
		sta uisampleview_startpos+2

		ldy #$08
		lda (zpptr1),y									; get end pos
		sta uisampleview_endpos+2

		; samplelength									00 00 3e 0e
		lda #$00
		sta uisampleview_samplength+0
		sta uisampleview_samplength+1
		ldy #6
		lda (zpptrtmp),y
		sta uisampleview_samplength+2
		ldy #7
		lda (zpptrtmp),y
		sta uisampleview_samplength+3

		; tracklength									00 00 00 01
		sta uisampleview_sampviewlength+0
		sta uisampleview_sampviewlength+1
		sta uisampleview_sampviewlength+2
		lda #$01
		sta uisampleview_sampviewlength+3

		; rendstep = samplelength / tracklength			00 00 3e 0e / 00 00 00 01 = 00 3e 0e 00
		MATH_DIV uisampleview_samplength, uisampleview_sampviewlength, uisampleview_samprendstep
		; sp = startpos * rendstep = sp					00 00 08 00 * 00 3e 0e 00 = 00 f0 71 00
		; from now on, sp is used as the new start addresss
		MATH_MUL uisampleview_startpos, uisampleview_samprendstep, uisampleview_sp
		; ep = endpos * rendstep = ep					00 00 00 01 * 00 3e 0e 00 = 00 00 3e 0e
		MATH_MUL uisampleview_endpos, uisampleview_samprendstep, uisampleview_ep
		; newlength = ep - sp							00 00 3e 0e - 00 f0 71 00 = 00 10 cc 0d
		MATH_SUB uisampleview_ep, uisampleview_sp, uisampleview_newsamplength
		; newrendstep = newlength / 256					00 10 cc 0d / 00 00 00 01 = 10 cc 0d 00
		MATH_DIV uisampleview_newsamplength, uisampleview_sampviewlength, uisampleview_samprendstep

		; samplestart									3c 7c 02 00 (zpptrtmp2)
		ldy #12
		lda (zpptrtmp),y
		adc uisampleview_sp+2
		sta zpptrtmp2+0
		iny
		lda (zpptrtmp),y
		adc uisampleview_sp+3
		sta zpptrtmp2+1
		iny
		lda (zpptrtmp),y
		adc #$00
		sta zpptrtmp2+2
		iny
		lda (zpptrtmp),y
		adc #$00
		sta zpptrtmp2+3


		ldx #$00

uisampleview_rendersample_loop

		lda #255
		sta uisampleview_minvalue
		lda #0
		sta uisampleview_maxvalue

		ldz #$00
:		lda [zpptrtmp2],z
		clc
		adc #128
		cmp uisampleview_minvalue						; carry 0 : A < minvalue
		bcs :+
		sta uisampleview_minvalue
:		cmp uisampleview_maxvalue
		bcc :+											; carry 0 : A < maxvalue
		sta uisampleview_maxvalue
:		inz
		cpz uisampleview_samprendstep+2
		bmi :---

		lda uisampleview_minvalue
		sta samplebuffermin,x
		lda uisampleview_maxvalue
		sta samplebuffermax,x

		phx
		MATH_ADD uisampleview_sp, uisampleview_samprendstep, uisampleview_sampviewlength
		plx

		lda uisampleview_sampviewlength+0				; BAH ! Do I really have to do this? why can't I just MATH_ADD to the same address?
		sta uisampleview_sp+0
		lda uisampleview_sampviewlength+1
		sta uisampleview_sp+1
		lda uisampleview_sampviewlength+2
		sta uisampleview_sp+2
		lda uisampleview_sampviewlength+3
		sta uisampleview_sp+3

		clc
		ldy #12											; sample address in instrument
		lda (zpptrtmp),y
		adc uisampleview_sp+2
		sta zpptrtmp2+0
		iny
		lda (zpptrtmp),y
		adc uisampleview_sp+3
		sta zpptrtmp2+1
		iny
		lda (zpptrtmp),y
		adc #$00
		sta zpptrtmp2+2
		iny
		lda (zpptrtmp),y
		adc #$00
		sta zpptrtmp2+3

		inx
		beq :+
		jmp uisampleview_rendersample_loop

:		rts

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


		lda #<.loword(samplespritesbuf)					; $00
		sta zpptrtmp+0
		lda #>.loword(samplespritesbuf)					; $d0
		sta zpptrtmp+1
		lda #<.hiword(samplespritesbuf)					; set up pointer to $00 1d 00 00
		sta zpptrtmp+2
		lda #>.hiword(samplespritesbuf)
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

		lda #<.loword(samplespritesbuf)					; $00
		sta zpptrtmp+0
		lda #>.loword(samplespritesbuf)					; $d0
		sta zpptrtmp+1
		lda #<.hiword(samplespritesbuf)					; set up pointer to $00 1d 00 00
		sta zpptrtmp+2
		lda #>.hiword(samplespritesbuf)
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

uisampleview_drawbackground

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

		jsr uidraw_increase_row
		jsr uidraw_increase_row
		jsr uidraw_increase_row

		ldx uidraw_width

		ldz #$00						; draw center of nineslice
		lda #9*16+9
:		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bpl :-

		rts

; ----------------------------------------------------------------------------------------------------
