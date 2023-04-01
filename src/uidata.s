
.align 256

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ main windows

root
		UIELEMENT_ADD ui_root1,				root,				windows,				0,  0, 80, 50,  0,		$ffff,					uidefaultflags

		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ main windows

windows
		UIELEMENT_ADD ui_windows1,			debugelement,		window1area,			 1,  0, 38, 45,  0,		$ffff,					uidefaultflags
		UIELEMENT_ADD ui_windows2,			debugelement,		window2area,			40,  0, 39, 45, 20,		$ffff,					uidefaultflags
		UIELEMENT_ADD ui_logo,				image,				$ffff,					68, 47, 11,  2,  0,		uilogo_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

window1area
		UIELEMENT_ADD debugelement3,		debugelement,		filearea1,				 1,  1, 20, 29,  0,		$ffff,					uidefaultflags
		UIELEMENT_ADD debugelement4,		debugelement,		cbuttonarea1,			22,  1, 15,  9,  0,		$ffff,					uidefaultflags
		UIELEMENT_ADD debugelement5,		debugelement,		checkboxarea1,			22, 10, 15,  7,  0,		$ffff,					uidefaultflags
		UIELEMENT_ADD debugelement6,		debugelement,		radiobtnarea1,			22, 17, 15,  9,  0,		$ffff,					uidefaultflags
		UIELEMENT_ADD debugelement7,		debugelement,		mousedebugarea1,		22, 26, 15,  7,  0,		$ffff,					uidefaultflags
		UIELEMENT_END

window2area
		UIELEMENT_ADD playbutton,			button,				$ffff,					 1,  1,  2,  2,  0,		playbutton_data,		uidefaultflags
		;UIELEMENT_ADD debugelement2,		debugelement,		$ffff,					 1,  1, 37, 19,  0,		$ffff,					uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

filearea1
		UIELEMENT_ADD nineslice1,			nineslice,			nineslice1elements,		 1,  1, 18, 18,  0,		$ffff,					uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

cbuttonarea1
		UIELEMENT_ADD textbutton1,			ctextbutton,		$ffff,					 1,  1, 13,  3,  0,		ctextbutton1_data,		uidefaultflags
		UIELEMENT_ADD textbutton2,			ctextbutton,		$ffff,					 1,  3, 13,  3,  0,		ctextbutton2_data,		0
		UIELEMENT_ADD textbutton3,			ctextbutton,		$ffff,					 1,  5, 13,  3,  0,		ctextbutton3_data,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

checkboxarea1
		UIELEMENT_ADD checkboxlabel1,		label,				$ffff,					 2,  2,  8,  1,  0,		checkboxlabel_data,		uidefaultflags
		UIELEMENT_ADD checkboxlabel2,		label,				$ffff,					 2,  4,  8,  1,  0,		checkboxlabel_data,		uidefaultflags
		UIELEMENT_ADD checkbox1,			checkbox,			$ffff,					11,  2,  2,  1,  0,		checkbox1_data,			uidefaultflags
		UIELEMENT_ADD checkbox2,			checkbox,			$ffff,					11,  4,  2,  1,  0,		checkbox2_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

radiobtnarea1
		UIELEMENT_ADD radiolabel1,			label,				$ffff,					 2,  2,  8,  1,  0,		radiobuttonlabel_data,	uidefaultflags
		UIELEMENT_ADD radiolabel2,			label,				$ffff,					 2,  4,  8,  1,  0,		radiobuttonlabel_data,	uidefaultflags
		UIELEMENT_ADD radiolabel3,			label,				$ffff,					 2,  6,  8,  1,  0,		radiobuttonlabel_data,	uidefaultflags
		UIELEMENT_ADD radiobutton1,			radiobutton,		$ffff,					12,  2,  1,  1,  0,		radiobutton1_data,		uidefaultflags
		UIELEMENT_ADD radiobutton2,			radiobutton,		$ffff,					12,  4,  1,  1,  0,		radiobutton2_data,		uidefaultflags
		UIELEMENT_ADD radiobutton3,			radiobutton,		$ffff,					12,  6,  1,  1,  0,		radiobutton3_data,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

mousedebugarea1
		UIELEMENT_ADD paddlexlabel,			label,				$ffff,					 2,  2,  8,  1,  0,		paddlexlabel_data,		uidefaultflags
		UIELEMENT_ADD paddleylabel,			label,				$ffff,					 2,  4,  8,  1,  0,		paddleylabel_data,		uidefaultflags
		UIELEMENT_ADD hexlabel1,			hexlabel,			$ffff,					11,  2,  2,  1,  0,		hexlabel1_data,			uidefaultflags
		UIELEMENT_ADD hexlabel2,			hexlabel,			$ffff,					11,  4,  2,  1,  0,		hexlabel2_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

scrollbar1elements
		UIELEMENT_ADD scrollbar1button1,	button,				$ffff,					 0,  0,  2,  2,  0,		button1_data,			uidefaultflags
		UIELEMENT_ADD scrollbar1button2,	button,				$ffff,					 0, 14,  2,  2,  0,		button2_data,			uidefaultflags
		UIELEMENT_ADD scrollbar1track,		scrolltrack,		$ffff,					 0,  2,  2, 12,  0,		scrollbar1_data,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

nineslice1elements
		UIELEMENT_ADD filebox1,				filebox,			$ffff,					 1,  1, 13, 16,  0,		filebox1_data,			uidefaultflags
		UIELEMENT_ADD scrollbar1,			scrollbar,			scrollbar1elements,		15,  1,  2, 16,  0,		scrollbar1_data,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

paddlexlabel_data		.word uitxt_paddlex
hexlabel1_data			.word mouse_d419
paddleylabel_data		.word uitxt_paddley
hexlabel2_data			.word mouse_d41a

uilogo_data				.byte 14*16+0, 14*16+0							; disabled glyph, enabled glyph
scrollbar1_data			.word scrollbar1_functions
						.byte 0, 0, 30									; scrollbar position, selection index, number of entries

checkboxlabel_data		.word uitxt_checkbox
radiobuttonlabel_data	.word uitxt_radiobutton
ctextbutton1_data		.word uitxt_button0
ctextbutton2_data		.word uitxt_button1
ctextbutton3_data		.word uitxt_button2
button1_data			.word button1_functions
						.byte 4*16+0, 4*16+4							; not pressed glyph, pressed glyph
button2_data			.word button2_functions
						.byte 4*16+8, 4*16+12							; not pressed glyph, pressed glyph

filebox1_data			.word scrollbar1_functions
						.word scrollbar1_data							; pointer to start position
						.word listboxtxt								; pointer to list of texts
checkbox1_data			.byte 1											; disabled/enabled
						.byte 3*16+8, 3*16+10							; disabled glyph, enabled glyph
checkbox2_data			.byte 0											; disabled/enabled
						.byte 3*16+8, 3*16+10							; disabled glyph, enabled glyph

radiobuttongroupindex	.byte 1
radiobutton1_data		.word radiobutton_functions
						.byte 0											; index
						.word radiobuttongroupindex						; pointer to group index
radiobutton2_data		.word radiobutton_functions
						.byte 1											; index
						.word radiobuttongroupindex						; pointer to group index
radiobutton3_data		.word radiobutton_functions
						.byte 2											; index
						.word radiobuttongroupindex						; pointer to group index

playbutton_data			.word $ffff										; press UI event
						.byte 8*16+0, 8*16+4							; not pressed glyph, pressed glyph

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ listeners

button1_functions		.word scrollbar1track, uiscrollbar_decrease
						.word scrollbar1track, uiscrolltrack_draw
						.word filebox1, uilistbox_draw
						.word $ffff

button2_functions		.word scrollbar1track, uiscrollbar_increase
						.word scrollbar1track, uiscrolltrack_draw
						.word filebox1, uilistbox_draw
						.word $ffff

scrollbar1_functions	.word scrollbar1track, uiscrolltrack_draw		; called on uilistbox_keypress, uifilebox_doubleclick, uiscrollbar_increase, uiscrollbar_decrease, uiscrollbar_setposition
						.word filebox1, uilistbox_draw
						.word $ffff

radiobutton_functions	.word radiobutton1, uiradiobutton_draw
						.word radiobutton2, uiradiobutton_draw
						.word radiobutton3, uiradiobutton_draw
						.word $ffff

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
