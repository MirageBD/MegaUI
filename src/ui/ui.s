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

		lda $d070										; select mapped bank with the upper 2 bits of $d070
		and #%00111111
		ora #%01000000									; select palette 01
		sta $d070

		ldx #$00										; set sprite palette - each sprite has a 16 colour palette
:		lda spritepal+0*$0100,x
		sta $d100,x
		sta $d110,x
		lda spritepal+1*$0100,x
		sta $d200,x
		sta $d210,x
		lda spritepal+2*$0100,x
		sta $d300,x
		sta $d310,x
		inx
		cpx #$10
		bne :-

		lda #$00										; set transparent colours
		sta $d027
		sta $d028

		lda $d070
		and #%11110011									; set sprite palette to 01
		ora #%00000100
		sta $d070

		lda #<sprptrs									; tell VIC-IV where the sprite pointers are (SPRPTRADR)
		sta $d06c
		lda #>sprptrs
		sta $d06d
		lda #(sprptrs & $ff0000) >> 16					; SPRPTRBNK
		sta $d06e

		lda #%10000000									; tell VIC-IV to expect two bytes per sprite pointer instead of one
		tsb $d06e										; do this after setting sprite pointer address, because that uses $d06e as well

		lda #%00000000
		sta $d015
		sta $d01b										; sprite background priority
		jsr uimouse_enablecursor

		lda #%11111111
		sta $d076										; enable SPRENVV400 for this sprite
		sta $d057										; enable 64 pixel wide sprites. 16 pixels if in Full Colour Mode
		lda #%00000011
		sta $d06b										; enable Full Colour Mode (SPR16EN)
		lda #%11111100
		sta $d055										; sprite height enable (SPRHGTEN)
		lda #%00010000
		tsb $d054										; enable SPR640 for all sprites

		lda #64											; set sprite height to 64 pixels (SPRHGHT) for sprites that have SPRHGTEN enabled (sample sprites)
		sta $d056

		lda #%00000000									; disable stretch for both
		sta $d017
		sta $d01d


		jsr uimouse_init
		jsr uikeyboard_init

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
 
		lda #<ui_root1								; get pointer to window x
		sta uielement_ptr+0
		sta uikeyboard_focuselement+0
		lda #>ui_root1
		sta uielement_ptr+1
		sta uikeyboard_focuselement+1
		lda #$00
		sta uielement_layoutxpos
		sta uielement_layoutypos
		lda #$00
		sta uielement_hoverwindowcounter

		jsr ui_layout_windows

		lda #<ui_root1								; get pointer to window x
		sta uielement_ptr+0
		sta uikeyboard_focuselement+0
		lda #>ui_root1
		sta uielement_ptr+1
		sta uikeyboard_focuselement+1
		lda #$00
		sta uielement_layoutxpos
		sta uielement_layoutypos
		lda #$00
		sta uielement_hoverwindowcounter

		jsr ui_draw_windows

        rts

; ----------------------------------------------------------------------------------------------------

uielement_ptr						.word 0
uielementlist_ptr					.word 0
uielement_parent_ptr				.word 0

uielementlist_counter				.byte 0
uielement_counter					.byte 0

uielement_hoverwindowcounter		.byte 0
uielement_prevhoverwindowcounter	.byte 0

uielement_temp						.byte 0

uielement_layoutxpos				.byte 0
uielement_layoutypos				.byte 0

uistackptr							.byte 0

uistack
		.repeat 256
			.byte 0
		.endrepeat

ui_flagtoset						.byte $00
ui_flagtoclear						.byte $00
ui_currentflag						.byte $00
ui_setflagindex						.byte $00

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

ui_setselectiveflags

		ldy #UIELEMENT::children						; does the group have children?
		iny												; add 1 - we want to check for $xx $ff, not $ff xx !!!
		lda (zpptr0),y
		cmp #$ff
		bne :+
		rts

:		ldy #UIELEMENT::children						; get children/tabs of the tab group
		lda (zpptr0),y
		sta uielementlist_ptr+0
		iny
		lda (zpptr0),y
		sta uielementlist_ptr+1



		lda uielementlist_ptr+0							; prepare to call hide on first tab contents
		sta zpptr0+0
		lda uielementlist_ptr+1
		sta zpptr0+1

		ldy #UIELEMENT::data+0							; get pointer to the data
        lda (zpptr0),y
		sta zpptr1+0
		ldy #UIELEMENT::data+1
        lda (zpptr0),y
		sta zpptr1+1
		ldy #$04										; get pointer to the contents
		lda (zpptr1),y
		sta zpptr0+0
		iny
		lda (zpptr1),y
		sta zpptr0+1

		jsr uiwindow_hide								; call hide on the first tab so the contents get cleared




		lda #$ff										; go through the three tabs, get their content and set the flags
		sta uielementlist_counter

tabflagloop
		inc uielementlist_counter
		ldy uielementlist_counter

		clc
		lda uielementlist_ptr+0							; get pointer to ui element
		adc ui_element_indiceslo,y
		sta zpptr0+0
		lda uielementlist_ptr+1
		adc ui_element_indiceshi,y
		sta zpptr0+1

		ldy #UIELEMENT::type							; are we at the end of the list?
		lda (zpptr0),y
		cmp #UIELEMENTTYPE::null
		bne :+
		jmp tabflagend

:		lda uielementlist_counter						; should we set or clear flags
		cmp ui_setflagindex
		bne :+
		lda ui_flagtoset
		sta ui_currentflag
		bra :++
:		lda ui_flagtoclear
		sta ui_currentflag
:

		ldy #UIELEMENT::data+0							; get pointer to the data
        lda (zpptr0),y
		sta zpptr1+0
		ldy #UIELEMENT::data+1
        lda (zpptr0),y
		sta zpptr1+1
		ldy #$04										; get pointer to the contents
		lda (zpptr1),y
		sta uielement_ptr+0
		iny
		lda (zpptr1),y
		sta uielement_ptr+1

		jsr ui_setselectiveflags_recursive

		jmp tabflagloop

tabflagend

		lda #$ff										; go through the three tabs, get their content and set the flags
		sta uielementlist_counter

tabdrawloop
		inc uielementlist_counter
		ldy uielementlist_counter

		clc
		lda uielementlist_ptr+0							; get pointer to ui element
		adc ui_element_indiceslo,y
		sta zpptr0+0
		lda uielementlist_ptr+1
		adc ui_element_indiceshi,y
		sta zpptr0+1

		ldy #UIELEMENT::type							; are we at the end of the list?
		lda (zpptr0),y
		cmp #UIELEMENTTYPE::null
		bne :+
		jmp tabdrawend

:		ldy #UIELEMENT::data+0							; get pointer to the data
        lda (zpptr0),y
		sta zpptr1+0
		ldy #UIELEMENT::data+1
        lda (zpptr0),y
		sta zpptr1+1
		ldy #$04										; get pointer to the contents
		lda (zpptr1),y
		sta uielement_ptr+0
		iny
		lda (zpptr1),y
		sta uielement_ptr+1

		jsr ui_draw_windows

		jmp tabdrawloop

tabdrawend

		rts


ui_setselectiveflags_recursive

		lda #$ff
		sta uielement_counter

ui_setselectiveflags_recursive_loop

		inc uielement_counter
		ldy uielement_counter

		clc
		lda uielement_ptr+0								; get pointer to ui element
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

:		ldy #UIELEMENT::flags
		lda ui_currentflag
		sta (zpptr0),y

		cmp #%00000001									; CALL HIDE - CURRENTLY THIS IS ONLY REALLY USEFUL FOR ELEMENTS THAT NEED TO HIDE SPRITES, LIKE SAMPLEVIEW
		bne :+
		SEND_EVENT hide

:		ldy #UIELEMENT::children
		iny												; add 1 - we want to check for $xx $ff, not $ff xx !!!
		lda (zpptr0),y
		cmp #$ff
		bne :+
		bra ui_setselectiveflags_recursive_loop

:		lda zpptr0+0									; recursively handle children
		sta uielement_parent_ptr+0
		lda zpptr0+1
		sta uielement_parent_ptr+1
		jsr uistack_pushparent
		ldy #UIELEMENT::children
		lda (zpptr0),y
		sta uielement_ptr+0
		iny
		lda (zpptr0),y
		sta uielement_ptr+1
		jsr ui_setselectiveflags_recursive
		jsr uistack_popparent
		jmp ui_setselectiveflags_recursive_loop


ui_setflags

		clc
		lda uielement_ptr+0								; get pointer to element
		adc ui_element_indiceslo
		sta zpptr0+0
		lda uielement_ptr+1
		adc ui_element_indiceshi
		sta zpptr0+1

		ldy #UIELEMENT::flags
		lda ui_flagtoset
		sta (zpptr0),y

		ldy #UIELEMENT::children
		iny												; add 1 - we want to check for $xx $ff, not $ff xx !!!
		lda (zpptr0),y
		cmp #$ff
		bne :+
		rts

:		ldy #UIELEMENT::children
		lda (zpptr0),y
		sta uielement_ptr+0
		iny
		lda (zpptr0),y
		sta uielement_ptr+1

		jsr ui_setflags_recursive
		rts

ui_setflags_recursive

		lda #$ff
		sta uielement_counter

ui_setflags_recursive_loop

		inc uielement_counter
		ldy uielement_counter

		clc
		lda uielement_ptr+0								; get pointer to ui element
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

:		ldy #UIELEMENT::flags							; are we at the end of the list?
		lda ui_flagtoset
		sta (zpptr0),y

		ldy #UIELEMENT::children
		iny												; add 1 - we want to check for $xx $ff, not $ff xx !!!
		lda (zpptr0),y
		cmp #$ff
		bne :+
		bra ui_setflags_recursive_loop

:		lda zpptr0+0									; recursively handle children
		sta uielement_parent_ptr+0
		lda zpptr0+1
		sta uielement_parent_ptr+1
		jsr uistack_pushparent
		ldy #UIELEMENT::children
		lda (zpptr0),y
		sta uielement_ptr+0
		iny
		lda (zpptr0),y
		sta uielement_ptr+1
		jsr ui_setflags_recursive
		jsr uistack_popparent
		bra ui_setflags_recursive_loop

; ----------------------------------------------------------------------------------------------------

ui_layout_windows

		lda #$ff
		sta uielement_counter

ui_layout_window_loop
		inc uielement_counter
		ldy uielement_counter

		clc
		lda uielement_ptr+0								; get pointer to ui root
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

		ldy #UIELEMENT::children
		iny												; add 1 - we want to check for $xx $ff, not $ff xx !!!
		lda (zpptr0),y
		cmp #$ff
		bne :+
		bra ui_layout_window_loop

:		lda zpptr0+0									; recursively handle children
		sta uielement_parent_ptr+0
		lda zpptr0+1
		sta uielement_parent_ptr+1
		jsr uistack_pushparent
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
		ldy #UIELEMENT::children
		lda (zpptr0),y
		sta uielement_ptr+0
		iny
		lda (zpptr0),y
		sta uielement_ptr+1
		jsr ui_layout_windows
		jsr uistack_popparent
		bra ui_layout_window_loop

; ----------------------------------------------------------------------------------------------------

ui_draw_windows

		lda #$ff
		sta uielement_counter

ui_draw_window_loop
		inc uielement_counter
		ldy uielement_counter

		clc
		lda uielement_ptr+0								; get pointer to ui root
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

:		ldy #UIELEMENT::flags							; is the element visible?
		lda (zpptr0),y
		and #UIFLAGS::visible
		bne :+
		bra ui_draw_window_loop

:		ldy #UIELEMENT::type
		SEND_EVENT draw

		ldy #UIELEMENT::children
		iny												; add 1 - we want to check for $xx $ff, not $ff xx !!!
		lda (zpptr0),y
		cmp #$ff
		bne :+
		bra ui_draw_window_loop

:		lda zpptr0+0									; recursively handle children
		sta uielement_parent_ptr+0
		lda zpptr0+1
		sta uielement_parent_ptr+1
		jsr uistack_pushparent
		ldy #UIELEMENT::children
		lda (zpptr0),y
		sta uielement_ptr+0
		iny
		lda (zpptr0),y
		sta uielement_ptr+1
		jsr ui_draw_windows
		jsr uistack_popparent
		bra ui_draw_window_loop

; ----------------------------------------------------------------------------------------------------

ui_eventqueue_index		.byte 0

ui_eventqueue_element	.word 0
ui_eventqueue_function	.word 0

ui_eventqueue
.repeat 256
		.byte 0
.endrepeat

ui_eventqueue_add
		ldx ui_eventqueue_index
		lda ui_eventqueue_element+0
		sta ui_eventqueue+0,x
		lda ui_eventqueue_element+1
		sta ui_eventqueue+1,x
		lda ui_eventqueue_function+0
		sta ui_eventqueue+2,x
		lda ui_eventqueue_function+1
		sta ui_eventqueue+3,x
		inx
		inx
		inx
		inx
		stx ui_eventqueue_index
		rts

ui_eventqueue_execute
		lda ui_eventqueue_index
		bne :+
		rts

:		ldx #$00
:		lda ui_eventqueue+0,x
		sta zpptr0+0
		lda ui_eventqueue+1,x
		sta zpptr0+1
		lda ui_eventqueue+2,x
		sta ueqe1+1
		lda ui_eventqueue+3,x
		sta ueqe1+2

		phx
ueqe1	jsr $babe
		plx

		inx
		inx
		inx
		inx
		cpx ui_eventqueue_index
		bne :-
		lda #$00
		sta ui_eventqueue_index
		rts

; ----------------------------------------------------------------------------------------------------

ui_update

		jsr mouse_update
		jsr uimouse_update
		jsr keyboard_update
		jsr uikeyboard_update
		jsr ui_eventqueue_execute
		rts

ui_user_update

		;UICORE_CALLELEMENTFUNCTION hexlabel1, uihexlabel_draw			; LV TODO - add update timer and move this to manager of some kind
		;UICORE_CALLELEMENTFUNCTION hexlabel2, uihexlabel_draw

		;UICORE_CALLELEMENTFUNCTION ptrnidxlabel, uihexlabel_draw
		;UICORE_CALLELEMENTFUNCTION ptrnptrlabel, uihexlabel_draw
		;UICORE_CALLELEMENTFUNCTION ptrnrowlabel, uihexlabel_draw
		
		lda #<tvlistbox
		sta zpptr1+0
		lda #>tvlistbox
		sta zpptr1+1
		ldy #UIELEMENT::flags
		lda (zpptr1),y
		and #UIFLAGS::visible
		bne :+
		rts

:		UICORE_CALLELEMENTFUNCTION la1listbox, uilistbox_update
		UICORE_CALLELEMENTFUNCTION la1listbox, uilistbox_draw

		UICORE_CALLELEMENTFUNCTION tvlistbox, uipatternview_update
		UICORE_CALLELEMENTFUNCTION tvlistbox, uipatternview_draw

		UICORE_CALLELEMENTFUNCTION sequenceview1, uisequenceview_update
		UICORE_CALLELEMENTFUNCTION sequenceview1, uisequenceview_draw

		UICORE_CALLELEMENTFUNCTION chanview1, uichannelview_update
		UICORE_CALLELEMENTFUNCTION chanview2, uichannelview_update
		UICORE_CALLELEMENTFUNCTION chanview3, uichannelview_update
		UICORE_CALLELEMENTFUNCTION chanview4, uichannelview_update

		UICORE_CALLELEMENTFUNCTION chanview1, uichannelview_draw
		UICORE_CALLELEMENTFUNCTION chanview2, uichannelview_draw
		UICORE_CALLELEMENTFUNCTION chanview3, uichannelview_draw
		UICORE_CALLELEMENTFUNCTION chanview4, uichannelview_draw

		;UICORE_CALLELEMENTFUNCTION chanview4, uilistbox_update
		;UICORE_CALLELEMENTFUNCTION chanview4, uilistbox_draw

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
