; -------------------------------------------------------------------

ui_init

		lda #$05										; enable Super-Extended Attribute Mode by asserting the FCLRHI and CHR16 signals - set bits 2 and 0 of $D054.
		sta $d054

		lda #$50										; set TEXTXPOS to same as SDBDRWDLSB
		sta $d04c

		lda #80*2										; logical chars per row
		sta $d058
		lda #$00
		sta $d059

		lda #%10001000									; set H640, V400
		sta $d031

		lda #$00
		sta $d05b										; Set display to V400
		lda #50
		sta $d07b										; Display 50 rows of text

		lda #<screen									; set pointer to screen ram
		sta $d060
		lda #>screen
		sta $d061
		lda #(screen & $ff0000) >> 16
		sta $d062
		lda #$00
		sta $d063

		lda #<$0800										; set (offset!) pointer to colour ram
		sta $d064
		lda #>$0800
		sta $d065

		lda $d070										; select mapped bank with the upper 2 bits of $d070
		and #%00111111
		sta $d070

		ldx #$00										; set bitmap palette
:		lda uipal+0*$0100,x
		sta $d100,x
		lda uipal+1*$0100,x
		sta $d200,x
		lda uipal+2*$0100,x
		sta $d300,x
		inx
		bne :-

		lda $d070
		and #%11001111									; clear bits 4 and 5 (BTPALSEL) so bitmap uses palette 0
		sta $d070

		; pal y border start
		lda #<104
		sta verticalcenter+0
		lda #>104
		sta verticalcenter+1

		bit $d06f
		bpl pal

ntsc	lda #<55
		sta verticalcenter+0
		lda #>55
		sta verticalcenter+1

pal		lda verticalcenter+0
		sta $d048
		lda #%00001111
		trb $d049
		lda verticalcenter+1
		tsb $d049

        rts

verticalcenter
		.word 0

; ----------------------------------------------------------------------------------------------------

ui_setup        
        
        lda #$00
		sta uidraw_scrptr+0
		sta uidraw_scrptr+1
		sta uidraw_scrptr+2
		sta uidraw_scrptr+3

        jsr uidraw_clearscreen
 		jsr uimouse_init

		lda #<ui_root1								; get pointer to window x
		sta uielement_ptr+0
		lda #>ui_root1
		sta uielement_ptr+1
		lda #$00
		sta uielement_layoutxpos
		sta uielement_layoutypos
		lda #$00
		sta uielement_hoverwindowcounter
		jsr ui_draw_windows

        rts

; ----------------------------------------------------------------------------------------------------

uielement_ptr
		.word 0
uielement_parent_ptr
		.word 0

uielement_counter
		.byte 0

uielement_hoverwindowcounter
		.byte 0

uielement_prevhoverwindowcounter		
		.byte 0

uielement_temp
		.byte 0

uielement_layoutxpos
		.byte 0
uielement_layoutypos
		.byte 0

uistack
		.repeat 256
			.byte 0
		.endrepeat

uistackptr
		.byte $00

uistack_pushparent
		ldx uistackptr
		lda uielement_counter
		sta uistack+0,x
		lda uielement_ptr+0
		sta uistack+1,x
		lda uielement_ptr+1
		sta uistack+2,x
		lda uielement_layoutxpos
		sta uistack+3,x
		lda uielement_layoutypos
		sta uistack+4,x

		inc uistackptr
		inc uistackptr
		inc uistackptr
		inc uistackptr
		inc uistackptr
		rts

uistack_popparent
		dec uistackptr
		dec uistackptr
		dec uistackptr
		dec uistackptr
		dec uistackptr

		ldx uistackptr
		lda uistack+0,x
		sta uielement_counter
		lda uistack+1,x
		sta uielement_ptr+0
		lda uistack+2,x
		sta uielement_ptr+1
		lda uistack+3,x
		sta uielement_layoutxpos
		lda uistack+4,x
		sta uielement_layoutypos
		rts

; ----------------------------------------------------------------------------------------------------

ui_draw_windows

		lda #$ff
		sta uielement_counter

:		inc uielement_counter
		ldy uielement_counter

		clc
		lda uielement_ptr+0								; get pointer to window x
		adc ui_element_indiceslo,y
		sta zpptr0+0
		lda uielement_ptr+1
		adc ui_element_indiceshi,y
		sta zpptr0+1

		ldy #UIELEMENT::type							; are we at the end of the list?
		lda (zpptr0),y
		cmp #UIELEMENTTYPE::null
		bne :+
		rts

:		SEND_EVENT layout
		SEND_EVENT draw

		ldy #UIELEMENT::children
		lda (zpptr0),y
		cmp #$ff
		bne :+
		bra :--

:		; recursively handle children
		lda zpptr0+0
		sta uielement_parent_ptr+0
		lda zpptr0+1
		sta uielement_parent_ptr+1
		jsr uistack_pushparent
		jsr uihelper_store_minxy
		ldy #UIELEMENT::children
		lda (zpptr0),y
		sta uielement_ptr+0
		iny
		lda (zpptr0),y
		sta uielement_ptr+1
		jsr ui_draw_windows
		jsr uistack_popparent
		bra :---

uihelper_store_minxy

		clc
		lda uielement_layoutxpos
		ldy #UIELEMENT::xpos
		adc (zpptr0),y
		sta uielement_layoutxpos

		clc
		lda uielement_layoutypos
		ldy #UIELEMENT::ypos
		adc (zpptr0),y
		sta uielement_layoutypos

		rts

; ----------------------------------------------------------------------------------------------------

ui_update

		jsr mouse_update
		jsr uimouse_update
		jsr keyboard_update
		jsr uikeyboard_update

		UICORE_CALLELEMENTFUNCTION hexlabel1, uihexlabel_draw			; LV TODO - add update timer and move this to manager of some kind
		UICORE_CALLELEMENTFUNCTION hexlabel2, uihexlabel_draw

		UICORE_CALLELEMENTFUNCTION tvlistbox, uitrackview_update

		UICORE_CALLELEMENTFUNCTION ptrnidxlabel, uihexlabel_draw
		UICORE_CALLELEMENTFUNCTION ptrnptrlabel, uihexlabel_draw
		UICORE_CALLELEMENTFUNCTION tvlistbox, uitrackview_draw
		;UICORE_CALLELEMENTFUNCTION ptrnrowlabel, uihexlabel_draw

        rts

; ----------------------------------------------------------------------------------------------------

hextodec
		.byte $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $01, $02, $03, $04, $05, $06

hextodec_normalized
		.byte $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f

; line is 80 chars wide. 50 rows on a screen
times160tablelo
		.repeat 50, I
				.byte <(I*160)
		.endrepeat

times160tablehi
		.repeat 50, I
				.byte >(I*160)
		.endrepeat

; ----------------------------------------------------------------------------------------------------
