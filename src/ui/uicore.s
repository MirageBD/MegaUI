.align 256

.define uidraw_scrptr		$80
.define uidraw_colptr		$84

.define zpptr0				$88
.define zpptr1		        $8a
.define zpptr2		        $8c
.define zpptr3		        $8e
.define zpptrtmp	        $90			; used for z indexing into higher ram, so 4 bytes

uicounter					.byte 0
q160						.dword 160

; ----------------------------------------------------------------------------------------------------

.macro DEBUG_COLOUR
.scope
		sta $d020
		ldy #$10
		ldx #$00
:		dex
		bne :-
		dey
		bne :-
.endscope
.endmacro

.macro UICORE_SELECT_ELEMENT element
		lda #<element
		sta zpptr0+0
		lda #>element
		sta zpptr0+1
.endmacro

.macro UICORE_CALLELEMENTFUNCTION element, function
		UICORE_SELECT_ELEMENT element
		jsr function
.endmacro

; ----------------------------------------------------------------------------------------------------

.struct UIVARIABLES
		parent		.word
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
		xpos		.byte
		ypos		.byte
		width		.byte
		height		.byte
		depth		.byte
		data		.word
		flags		.byte

		parent		.word			; variables
		state		.byte
		layoutxpos	.byte
		layoutypos	.byte
		xmin		.word
		xmax		.word
		ymin		.word
		ymax		.word
.endstruct

.enum UIELEMENTTYPE
		null
		element												; LV TODO - add ui in front of these for consistency?
		root
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
		filebox
		checkbox
		radiobutton
		image
		patternview
.endenum

.enum UIEVENTTYPE
		press						;
		longpress					;
		release						;
		doubleclick					;
		keypress					;
		keyrelease

		layout						;
		draw						;
		focus
		enter						;
		leave						;
		move						;
.endenum

.enum UISTATE
		hover		= %00000001		;
									; %00000010 is used in code to decide hover flag
		pressed		= %00000100		; also called 'active'
.endenum

.enum UISTATEMASK
		hover		= %11111110		;
									; %00000010 is used in code to decide hover flag
		pressed		= %11111011		; also called 'active'
.endenum

.enum UIFLAGS
		enabled		= %00000001
		visible		= %00000010
.endenum

.define uidefaultflags	%00000011

; ----------------------------------------------------------------------------------------------------

.macro UIELEMENT_ADD name, elementtype, child, xpos, ypos, width, height, depth, data, flags
.ident(.sprintf("%s", .string(name)))
		.byte UIELEMENTTYPE::elementtype
		.word child
		.byte xpos, ypos, width, height, depth
		.word data
		.byte flags
		.res .sizeof(UIVARIABLES)
.endmacro

.macro UIELEMENT_END
		.byte UIELEMENTTYPE::null
.endmacro

; ----------------------------------------------------------------------------------------------------

ui_element_indiceslo										; maximum allowed number of ui children is 32
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
			.byte <.ident(.sprintf("uiroot_%s",			.string(eventtype))), >.ident(.sprintf("uiroot_%s",			.string(eventtype)))
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
			.byte <.ident(.sprintf("uifilebox_%s",		.string(eventtype))), >.ident(.sprintf("uifilebox_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uicheckbox_%s",		.string(eventtype))), >.ident(.sprintf("uicheckbox_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uiradiobutton_%s",	.string(eventtype))), >.ident(.sprintf("uiradiobutton_%s",	.string(eventtype)))
			.byte <.ident(.sprintf("uiimage_%s",		.string(eventtype))), >.ident(.sprintf("uiimage_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uipatternview_%s",	.string(eventtype))), >.ident(.sprintf("uipatternview_%s",	.string(eventtype)))
.endmacro

		IMPLEMENT_UIEVENT layout
		IMPLEMENT_UIEVENT draw
		IMPLEMENT_UIEVENT focus
		IMPLEMENT_UIEVENT enter
		IMPLEMENT_UIEVENT leave
		IMPLEMENT_UIEVENT press
		IMPLEMENT_UIEVENT release
		IMPLEMENT_UIEVENT doubleclick
		IMPLEMENT_UIEVENT move
		IMPLEMENT_UIEVENT keypress
		IMPLEMENT_UIEVENT keyrelease

; ----------------------------------------------------------------------------------------------------

ui_getelementdataptr_1

		pha
		phy
		ldy #UIELEMENT::data+0
        lda (zpptr0),y
		sta zpptr1+0
		ldy #UIELEMENT::data+1
        lda (zpptr0),y
		sta zpptr1+1
		ply
		pla
		rts

ui_getelementdataptr_tmp

		pha
		phy
		ldy #UIELEMENT::data+0
		lda (zpptr0),y
		sta zpptrtmp+0
		ldy #UIELEMENT::data+1
		lda (zpptr0),y
		sta zpptrtmp+1
		ply
		pla
		rts

; ----------------------------------------------------------------------------------------------------

ui_textremap
		.byte $00, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $20, $3f, $3f, $3f, $24, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $2c, $2d, $2e, $3f ; [s             . ]
		.byte $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3f, $3f, $3f, $3f, $3f, $3f ; [0123456789      ]
		.byte $3f, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f ; [@abcdefghijklmno]
		.byte $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $3f, $3f, $3f, $3f, $3f ; [pqrstuvwxyz     ]
		.byte $3f, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f ; [@abcdefghijklmno]
		.byte $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $3f, $3f, $3f, $3f, $3f ; [pqrstuvwxyz     ]
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f

ui_bkgtextremap
		.byte $00, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $20, $3f, $3f, $3f, $24, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $2d, $2e, $3f ; [s             . ]
		.byte $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3f, $3f, $3f, $3f, $3f, $3f ; [0123456789      ]
		.byte $3f, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f ; [@abcdefghijklmno]
		.byte $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $3f, $3f, $3f, $3f, $3f ; [pqrstuvwxyz     ]
		.byte $3f, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f ; [@abcdefghijklmno]
		.byte $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $3f, $3f, $3f, $3f, $3f ; [pqrstuvwxyz     ]
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f

ui_colouredtextremap
		.byte $00, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $a0, $3f, $3f, $3f, $24, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $2d, $2e, $3f ; [s             . ]
		.byte $b0, $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9, $3f, $3f, $3f, $3f, $3f, $3f ; [0123456789      ]
		.byte $3f, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f ; [@abcdefghijklmno]
		.byte $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $3f, $3f, $3f, $3f, $3f ; [pqrstuvwxyz     ]
		.byte $3f, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f ; [@abcdefghijklmno]
		.byte $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $3f, $3f, $3f, $3f, $3f ; [pqrstuvwxyz     ]
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
		.byte $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
