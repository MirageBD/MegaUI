uicounter					.byte 0
q160						.dword 160

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
		glyphbutton
		cbutton
		ctextbutton
		cnumericbutton
		scrolltrack
		slider
		label
		nineslice
		listbox
		filebox
		checkbox
		radiobutton
		image
		textbox
		tab
		group

		patternview
		sequenceview
		channelview
		sampleview
		scaletrack
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
			.byte <.ident(.sprintf("uielement_%s",			.string(eventtype))), >.ident(.sprintf("uielement_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uiroot_%s",				.string(eventtype))), >.ident(.sprintf("uiroot_%s",				.string(eventtype)))
			.byte <.ident(.sprintf("uidebugelement_%s",		.string(eventtype))), >.ident(.sprintf("uidebugelement_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uihexlabel_%s",			.string(eventtype))), >.ident(.sprintf("uihexlabel_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uiwindow_%s",			.string(eventtype))), >.ident(.sprintf("uiwindow_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uibutton_%s",			.string(eventtype))), >.ident(.sprintf("uibutton_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uiglyphbutton_%s",		.string(eventtype))), >.ident(.sprintf("uiglyphbutton_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uicbutton_%s",			.string(eventtype))), >.ident(.sprintf("uicbutton_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uictextbutton_%s",		.string(eventtype))), >.ident(.sprintf("uictextbutton_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uicnumericbutton_%s",	.string(eventtype))), >.ident(.sprintf("uicnumericbutton_%s",	.string(eventtype)))
			.byte <.ident(.sprintf("uiscrolltrack_%s",		.string(eventtype))), >.ident(.sprintf("uiscrolltrack_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uislider_%s",			.string(eventtype))), >.ident(.sprintf("uislider_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uilabel_%s",			.string(eventtype))), >.ident(.sprintf("uilabel_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uinineslice_%s",		.string(eventtype))), >.ident(.sprintf("uinineslice_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uilistbox_%s",			.string(eventtype))), >.ident(.sprintf("uilistbox_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uifilebox_%s",			.string(eventtype))), >.ident(.sprintf("uifilebox_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uicheckbox_%s",			.string(eventtype))), >.ident(.sprintf("uicheckbox_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uiradiobutton_%s",		.string(eventtype))), >.ident(.sprintf("uiradiobutton_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uiimage_%s",			.string(eventtype))), >.ident(.sprintf("uiimage_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uitextbox_%s",			.string(eventtype))), >.ident(.sprintf("uitextbox_%s",			.string(eventtype)))
			.byte <.ident(.sprintf("uitab_%s",				.string(eventtype))), >.ident(.sprintf("uitab_%s",				.string(eventtype)))
			.byte <.ident(.sprintf("uigroup_%s",			.string(eventtype))), >.ident(.sprintf("uigroup_%s",			.string(eventtype)))

			.byte <.ident(.sprintf("uipatternview_%s",		.string(eventtype))), >.ident(.sprintf("uipatternview_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uisequenceview_%s",		.string(eventtype))), >.ident(.sprintf("uisequenceview_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uichannelview_%s",		.string(eventtype))), >.ident(.sprintf("uichannelview_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uisampleview_%s",		.string(eventtype))), >.ident(.sprintf("uisampleview_%s",		.string(eventtype)))
			.byte <.ident(.sprintf("uiscaletrack_%s",		.string(eventtype))), >.ident(.sprintf("uiscaletrack_%s",		.string(eventtype)))
.endmacro

		IMPLEMENT_UIEVENT layout
		IMPLEMENT_UIEVENT draw
		IMPLEMENT_UIEVENT hide
		IMPLEMENT_UIEVENT focus
		IMPLEMENT_UIEVENT enter
		IMPLEMENT_UIEVENT leave
		IMPLEMENT_UIEVENT press
		IMPLEMENT_UIEVENT longpress
		IMPLEMENT_UIEVENT release
		IMPLEMENT_UIEVENT doubleclick
		IMPLEMENT_UIEVENT move
		IMPLEMENT_UIEVENT keypress
		IMPLEMENT_UIEVENT keyrelease

; ----------------------------------------------------------------------------------------------------

ui_getelementdata_2
		pha
		phy
		ldy #UIELEMENT::data+0
        lda (zpptr0),y
		sta zpptr1+0
		ldy #UIELEMENT::data+1
        lda (zpptr0),y
		sta zpptr1+1
		ply

		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1
		dey

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
		.byte $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $3f ; [s!"#$%&'()*+,-./]
		.byte $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f ; [0123456789:;<=>?]
		.byte $3f, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f ; [@abcdefghijklmno]
		.byte $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1c, $1c, $1c, $1c, $1c ; [pqrstuvwxyz     ]
		.byte $3f, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f ; [@abcdefghijklmno]
		.byte $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $3c, $3c, $3c, $3c, $3c ; [pqrstuvwxyz     ]
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