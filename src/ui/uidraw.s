uidraw_xpos					.byte $00
uidraw_ypos					.byte $00
uidraw_width				.byte $00
uidraw_height				.byte $00

uidraw_xposoffset			.byte $00
uidraw_yposoffset			.byte $00

uidraw_xdeflate   			.byte $00
uidraw_ydeflate   			.byte $00

; ----------------------------------------------------------------------------------------------------

uidraw_clearscreen

		DMA_RUN_JOB clearcolorramjob
		DMA_RUN_JOB clearscreenjob
		rts

; ----------------------------------------------------------------------------------------------------

uidraw_increase_row

		clc
		lda uidraw_scrptr+0
		adc #160
		sta uidraw_scrptr+0
		lda uidraw_scrptr+1
		adc #$00
		sta uidraw_scrptr+1

		clc
		lda uidraw_colptr+0
		adc #160
		sta uidraw_colptr+0
		lda uidraw_colptr+1
		adc #$00
		sta uidraw_colptr+1

		rts

; ----------------------------------------------------------------------------------------------------

uidraw_set_draw_position

		clc
		ldy #UIELEMENT::layoutxpos
		lda (zpptr0),y
		adc uidraw_xposoffset
		sta uidraw_xpos
		clc
		ldy #UIELEMENT::layoutypos
		lda (zpptr0),y
		adc uidraw_yposoffset
		sta uidraw_ypos

		ldx uidraw_xpos
		ldy uidraw_ypos

		clc
		lda #<screen
		adc times160tablelo,y
		sta uidraw_scrptr+0
		lda #>screen
		adc times160tablehi,y
		sta uidraw_scrptr+1

		clc
		lda #<.loword(SAFE_COLOR_RAM_PLUS_ONE)
		adc times160tablelo,y
		sta uidraw_colptr+0
		lda #>.loword(SAFE_COLOR_RAM_PLUS_ONE)
		adc times160tablehi,y
		sta uidraw_colptr+1
		lda #<.hiword(SAFE_COLOR_RAM_PLUS_ONE)
		adc #$00
		sta uidraw_colptr+2
		lda #>.hiword(SAFE_COLOR_RAM_PLUS_ONE)
		adc #$00
		sta uidraw_colptr+3

		clc
		txa
		asl
		adc uidraw_scrptr+0
		sta uidraw_scrptr+0
		lda uidraw_scrptr+1
		adc #$00
		sta uidraw_scrptr+1

		clc
		txa
		asl
		adc uidraw_colptr+0
		sta uidraw_colptr+0
		lda uidraw_colptr+1
		adc #$00
		sta uidraw_colptr+1
		lda uidraw_colptr+2
		adc #$00
		sta uidraw_colptr+2
		lda uidraw_colptr+3
		adc #$00
		sta uidraw_colptr+3

		ldy #UIELEMENT::width
		lda (zpptr0),y
		sta uidraw_width
		ldy #UIELEMENT::height
		lda (zpptr0),y
		sta uidraw_height

		rts

; ----------------------------------------------------------------------------------------------------

uidraw_resetoffsets
		lda #$00
		sta uidraw_xposoffset
		sta uidraw_yposoffset
		rts

; ----------------------------------------------------------------------------------------------------

uidraw_deflate

		sec
		lda uidraw_width
		sbc #$02
		sta uidraw_width
		sec
		lda uidraw_height
		sbc #$02
		sta uidraw_height

		rts

; ----------------------------------------------------------------------------------------------------

clearcolorramjob
				.byte $0a										; Request format (f018a = 11 bytes (Command MSB is $00), f018b is 12 bytes (Extra Command MSB))
				.byte $80, $00									; source megabyte   ($0000000 >> 20) ($00 is  chip ram)
				.byte $81, (SAFE_COLOR_RAM) >> 20				; dest megabyte   ($0000000 >> 20) ($00 is  chip ram)
				.byte $84, $00									; Destination skip rate (256ths of bytes)
				.byte $85, $02									; Destination skip rate (whole bytes)

				.byte $00										; No more options

																; 12 byte DMA List structure starts here
				.byte %00000111									; Command LSB
																;     0–1 DMA Operation Type (Only Copy and Fill implemented at the time of writing)
																;             %00 = Copy
																;             %01 = Mix (via MINTERMs)
																;             %10 = Swap
																;             %11 = Fill
																;       2 Chain (i.e., another DMA list follows)
																;       3 Yield to interrupts
																;       4 MINTERM -SA,-DA bit
																;       5 MINTERM -SA, DA bit
																;       6 MINTERM  SA,-DA bit
																;       7 MINTERM  SA, DA bit

				.word 80*50										; Count LSB + Count MSB

				.word $0000										; this is normally the source addres, but contains the fill value now
				.byte $00										; source bank (ignored)

				.word (SAFE_COLOR_RAM) & $ffff					; Destination Address LSB + Destination Address MSB
				.byte (((SAFE_COLOR_RAM) >> 16) & $0f)			; Destination Address BANK and FLAGS (copy to rbBaseMem)
																;     0–3 Memory BANK within the selected MB (0-15)
																;       4 HOLD,      i.e., do not change the address
																;       5 MODULO,    i.e., apply the MODULO field to wraparound within a limited memory space
																;       6 DIRECTION. If set, then the address is decremented instead of incremented.
																;       7 I/O.       If set, then I/O registers are visible during the DMA controller at $D000 – $DFFF.
				;.byte %00000000									; Command MSB

				.word $0000

				.byte $00										; No more options
				.byte %00000011									; Command LSB
																;     0–1 DMA Operation Type (Only Copy and Fill implemented at the time of writing)
																;             %00 = Copy
																;             %01 = Mix (via MINTERMs)
																;             %10 = Swap
																;             %11 = Fill
																;       2 Chain (i.e., another DMA list follows)
																;       3 Yield to interrupts
																;       4 MINTERM -SA,-DA bit
																;       5 MINTERM -SA, DA bit
																;       6 MINTERM  SA,-DA bit
																;       7 MINTERM  SA, DA bit

				.word 80*50										; Count LSB + Count MSB

				.word $0004										; this is normally the source addres, but contains the fill value now
				.byte $00										; source bank (ignored)

				.word (SAFE_COLOR_RAM+1) & $ffff				; Destination Address LSB + Destination Address MSB
				.byte (((SAFE_COLOR_RAM+1) >> 16) & $0f)		; Destination Address BANK and FLAGS (copy to rbBaseMem)
																;     0–3 Memory BANK within the selected MB (0-15)
																;       4 HOLD,      i.e., do not change the address
																;       5 MODULO,    i.e., apply the MODULO field to wraparound within a limited memory space
																;       6 DIRECTION. If set, then the address is decremented instead of incremented.
																;       7 I/O.       If set, then I/O registers are visible during the DMA controller at $D000 – $DFFF.
				;.byte %00000000								; Command MSB

				.word $0000

; ----------------------------------------------------------------------------------------------------

clearscreenjob
				.byte $0a										; Request format (f018a = 11 bytes (Command MSB is $00), f018b is 12 bytes (Extra Command MSB))
				.byte $80, $00									; source megabyte   ($0000000 >> 20) ($00 is  chip ram)
				.byte $81, (screen) >> 20						; dest megabyte   ($0000000 >> 20) ($00 is  chip ram)
				.byte $84, $00									; Destination skip rate (256ths of bytes)
				.byte $85, $02									; Destination skip rate (whole bytes)

				.byte $00										; No more options

																; 12 byte DMA List structure starts here
				.byte %00000111									; Command LSB
																;     0–1 DMA Operation Type (Only Copy and Fill implemented at the time of writing)
																;             %00 = Copy
																;             %01 = Mix (via MINTERMs)
																;             %10 = Swap
																;             %11 = Fill
																;       2 Chain (i.e., another DMA list follows)
																;       3 Yield to interrupts
																;       4 MINTERM -SA,-DA bit
																;       5 MINTERM -SA, DA bit
																;       6 MINTERM  SA,-DA bit
																;       7 MINTERM  SA, DA bit

				.word 80*50										; Count LSB + Count MSB

				.word $0000										; this is normally the source addres, but contains the fill value now
				.byte $00										; source bank (ignored)

				.word (screen) & $ffff							; Destination Address LSB + Destination Address MSB
				.byte (((screen) >> 16) & $0f)					; Destination Address BANK and FLAGS (copy to rbBaseMem)
																;     0–3 Memory BANK within the selected MB (0-15)
																;       4 HOLD,      i.e., do not change the address
																;       5 MODULO,    i.e., apply the MODULO field to wraparound within a limited memory space
																;       6 DIRECTION. If set, then the address is decremented instead of incremented.
																;       7 I/O.       If set, then I/O registers are visible during the DMA controller at $D000 – $DFFF.
				;.byte %00000000									; Command MSB

				.word $0000

				.byte $00										; No more options
				.byte %00000011									; Command LSB
																;     0–1 DMA Operation Type (Only Copy and Fill implemented at the time of writing)
																;             %00 = Copy
																;             %01 = Mix (via MINTERMs)
																;             %10 = Swap
																;             %11 = Fill
																;       2 Chain (i.e., another DMA list follows)
																;       3 Yield to interrupts
																;       4 MINTERM -SA,-DA bit
																;       5 MINTERM -SA, DA bit
																;       6 MINTERM  SA,-DA bit
																;       7 MINTERM  SA, DA bit

				.word 80*50										; Count LSB + Count MSB

				.word $0005										; this is normally the source addres, but contains the fill value now
				.byte $00										; source bank (ignored)

				.word (screen+1) & $ffff						; Destination Address LSB + Destination Address MSB
				.byte (((screen+1) >> 16) & $0f)				; Destination Address BANK and FLAGS (copy to rbBaseMem)
																;     0–3 Memory BANK within the selected MB (0-15)
																;       4 HOLD,      i.e., do not change the address
																;       5 MODULO,    i.e., apply the MODULO field to wraparound within a limited memory space
																;       6 DIRECTION. If set, then the address is decremented instead of incremented.
																;       7 I/O.       If set, then I/O registers are visible during the DMA controller at $D000 – $DFFF.
				;.byte %00000000								; Command MSB

				.word $0000

; ----------------------------------------------------------------------------------------------------

