.align 256

.define uidraw_scrptr		$80
.define uidraw_colptr		$84

.define zpptr0				$88
.define zpptr1		        $8a
.define zpptr2		        $8c
.define zpptr3		        $8e
.define zpptrtmp	        $90

uicounter					.byte 0
q160						.dword 160

; ----------------------------------------------------------------------------------------------------

.macro DEBUG_COLOUR
.scope
		sta $d020
		ldy #$40
		ldx #$00
:		dex
		bne :-
		dey
		bne :-
.endscope
.endmacro

.macro DRAW_ELEMENT_NOW element, function
		lda #<element
		sta zpptr0+0
		lda #>element
		sta zpptr0+1
		jsr function
.endmacro

; ----------------------------------------------------------------------------------------------------

.struct UIVARIABLES
		state		.byte
		layoutxpos	.byte
		layoutypos	.byte
		xmin		.word
		xmax		.word
		ymin		.word
		ymax		.word
.endstruct

.struct UIELEMENT
		type		.byte			; immutables
		children	.word
		parent		.word
		xpos		.byte
		ypos		.byte
		width		.byte
		height		.byte
		depth		.byte
		data		.word
		listeners	.word

		state		.byte			; variables
		layoutxpos	.byte
		layoutypos	.byte
		xmin		.word
		xmax		.word
		ymin		.word
		ymax		.word
.endstruct

.enum UIELEMENTTYPE
		null
		element
		debugelement
		hexlabel
		window
		button
		cbutton
		ctextbutton
		scrollbar
		scrolltrack
		label
		nineslice
		listbox
		checkbox
		radiobutton
		image
.endenum

.enum UISTATE
		hover		= %00000001		;
									; %00000010 is used in code to decide hover flag
		enabled		= %00000100		; enabled/disabled.
		pressed		= %00001000		; also called 'active'
		focussed	= %00010000		; for accessability. border around elements
		selected	= %00100000		; checkbox, radiobutton, etc.
		dragged		= %01000000
		on			= %10000000		; on/off. same as selected?
.endenum

.enum UISTATEMASK
		hover		= %11111110		;
									; %00000010 is used in code to decide hover flag
		enabled		= %11111011		; enabled/disabled.
		pressed		= %11110111		; also called 'active'
		focussed	= %11101111		; for accessability. border around elements
		selected	= %11011111		; checkbox, radiobutton, etc.
		dragged		= %10111111
		on			= %01111111		; on/off. same as selected?
.endenum

; ----------------------------------------------------------------------------------------------------

.macro UIELEMENT_ADD name, elementtype, child, parent, xpos, ypos, width, height, depth, data, listeners
.ident(.sprintf("%s", .string(name)))
		.byte UIELEMENTTYPE::elementtype
		.word child
		.word parent
		.byte xpos, ypos, width, height, depth
		.word data
		.word listeners
		.res .sizeof(UIVARIABLES)
.endmacro

.macro UIELEMENT_END
		.byte UIELEMENTTYPE::null
.endmacro

; ----------------------------------------------------------------------------------------------------

ui_element_indiceslo
	.repeat	32, wid
		.byte	<(.sizeof(UIELEMENT) * wid)
	.endrepeat

ui_element_indiceshi
	.repeat	32, wid
		.byte	>(.sizeof(UIELEMENT) * wid)
	.endrepeat

; ----------------------------------------------------------------------------------------------------

.macro SEND_EVENT eventtype
		jsr .ident(.sprintf("uievent_%s", .string(eventtype)))
.endmacro

.macro IMPLEMENT_UIEVENT eventtype
		.ident(.sprintf("uievent_%s", .string(eventtype)))
			ldy #UIELEMENT::type
			lda (zpptr0),y
			asl
			tax
			lda .ident(.sprintf("uieventptrs_%s", .string(eventtype)))+0,x
			sta zpptr1+0
			lda .ident(.sprintf("uieventptrs_%s", .string(eventtype)))+1,x
			sta zpptr1+1
			jmp (zpptr1)

		.ident(.sprintf("uieventptrs_%s", .string(eventtype)))
			.byte $00, $00
			.byte <.ident(.sprintf("uielement_%s",		.string(eventtype))), >.ident(.sprintf("uielement_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uidebugelement_%s",	.string(eventtype))), >.ident(.sprintf("uidebugelement_%s",	.string(eventtype)))
			.byte <.ident(.sprintf("uihexlabel_%s",		.string(eventtype))), >.ident(.sprintf("uihexlabel_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uiwindow_%s",		.string(eventtype))), >.ident(.sprintf("uiwindow_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uibutton_%s",		.string(eventtype))), >.ident(.sprintf("uibutton_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uicbutton_%s",		.string(eventtype))), >.ident(.sprintf("uicbutton_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uictextbutton_%s",	.string(eventtype))), >.ident(.sprintf("uictextbutton_%s",	.string(eventtype)))
			.byte <.ident(.sprintf("uiscrollbar_%s",	.string(eventtype))), >.ident(.sprintf("uiscrollbar_%s",	.string(eventtype)))
			.byte <.ident(.sprintf("uiscrolltrack_%s",	.string(eventtype))), >.ident(.sprintf("uiscrolltrack_%s",	.string(eventtype)))
			.byte <.ident(.sprintf("uilabel_%s",		.string(eventtype))), >.ident(.sprintf("uilabel_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uinineslice_%s",	.string(eventtype))), >.ident(.sprintf("uinineslice_%s",	.string(eventtype)))
			.byte <.ident(.sprintf("uilistbox_%s",		.string(eventtype))), >.ident(.sprintf("uilistbox_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uicheckbox_%s",		.string(eventtype))), >.ident(.sprintf("uicheckbox_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uiradiobutton_%s",	.string(eventtype))), >.ident(.sprintf("uiradiobutton_%s",	.string(eventtype)))
			.byte <.ident(.sprintf("uiimage_%s",		.string(eventtype))), >.ident(.sprintf("uiimage_%s",		.string(eventtype)))
.endmacro

		IMPLEMENT_UIEVENT layout
		IMPLEMENT_UIEVENT draw
		IMPLEMENT_UIEVENT focus
		IMPLEMENT_UIEVENT enter
		IMPLEMENT_UIEVENT leave
		IMPLEMENT_UIEVENT press
		IMPLEMENT_UIEVENT release
		IMPLEMENT_UIEVENT move
		IMPLEMENT_UIEVENT keypress
		IMPLEMENT_UIEVENT keyrelease

; ----------------------------------------------------------------------------------------------------

ui_getelementdataptr_1

		ldy #UIELEMENT::data+0
        lda (zpptr0),y
		sta zpptr1+0
		ldy #UIELEMENT::data+1
        lda (zpptr0),y
		sta zpptr1+1
		rts

ui_getelementdataptr_tmp

		pha
		ldy #UIELEMENT::data+0
		lda (zpptr0),y
		sta zpptrtmp+0
		ldy #UIELEMENT::data+1
		lda (zpptr0),y
		sta zpptrtmp+1
		pla
		rts

; ----------------------------------------------------------------------------------------------------

ui_getelementlistenersptr_3

		ldy #UIELEMENT::listeners+0
        lda (zpptr0),y
		sta zpptr3+0
		ldy #UIELEMENT::listeners+1
        lda (zpptr0),y
		sta zpptr3+1
		rts

; ----------------------------------------------------------------------------------------------------

ui_textremap
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $60, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $6d, $6e, $00 ; [s             . ]
		.byte $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $00, $00, $00, $00, $00, $00 ; [0123456789      ]
		.byte $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f ; [@abcdefghijklmno]
		.byte $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $00, $00, $00, $00, $00 ; [pqrstuvwxyz     ]
		.byte $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f ; [@abcdefghijklmno]
		.byte $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $00, $00, $00, $00, $00 ; [pqrstuvwxyz     ]
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

ui_bkgtextremap
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $60, $00, $00, $00, $64, $00, $00, $00, $00, $00, $00, $00, $00, $6d, $6e, $00 ; [s             . ]
		.byte $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $00, $00, $00, $00, $00, $00 ; [0123456789      ]
		.byte $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f ; [@abcdefghijklmno]
		.byte $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $00, $00, $00, $00, $00 ; [pqrstuvwxyz     ]
		.byte $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f ; [@abcdefghijklmno]
		.byte $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $00, $00, $00, $00, $00 ; [pqrstuvwxyz     ]
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
