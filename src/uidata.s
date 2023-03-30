
.align 256

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ dummies

dummy_data				.word $ffff
dummy_listeners			.word $ffff

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ main windows

		UIELEMENT_ADD ui_windows1,			debugelement,		window1area,			$ffff,	 1,  1, 38, 45,  0,		dummy_data,				dummy_listeners,		uidefaultflags
		UIELEMENT_ADD ui_windows2,			debugelement,		window2area,			$ffff,	40,  1, 39, 45, 20,		dummy_data,				dummy_listeners,		uidefaultflags
		UIELEMENT_ADD ui_logo,				image,				$ffff,					$ffff,	68, 47, 11,  2,  0,		uilogo_data,			dummy_listeners,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

window1area
		UIELEMENT_ADD debugelement3,		debugelement,		filearea1,				$ffff,	 1,  1, 20, 29,  0,		dummy_data,				dummy_listeners,		uidefaultflags
		UIELEMENT_ADD debugelement4,		debugelement,		cbuttonarea1,			$ffff,	22,  1, 15,  9,  0,		dummy_data,				dummy_listeners,		uidefaultflags
		UIELEMENT_ADD debugelement5,		debugelement,		checkboxarea1,			$ffff,	22, 10, 15,  7,  0,		dummy_data,				dummy_listeners,		uidefaultflags
		UIELEMENT_ADD debugelement6,		debugelement,		radiobtnarea1,			$ffff,	22, 17, 15,  9,  0,		dummy_data,				dummy_listeners,		uidefaultflags
		UIELEMENT_ADD debugelement7,		debugelement,		mousedebugarea1,		$ffff,	22, 26, 15,  7,  0,		dummy_data,				dummy_listeners,		uidefaultflags
		UIELEMENT_END

window2area
		UIELEMENT_ADD debugelement2,		debugelement,		$ffff,					$ffff,	 1,  1, 37, 19,  0,		dummy_data,				dummy_listeners,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

filearea1
		UIELEMENT_ADD nineslice1,			nineslice,			nineslice1elements,		$ffff,	 1,  1, 18, 18,  0,		dummy_data,				dummy_listeners,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

cbuttonarea1
		UIELEMENT_ADD textbutton1,			ctextbutton,		$ffff,					$ffff,	 1,  1, 13,  3,  0,		ctextbutton1_data,		dummy_listeners,		uidefaultflags
		UIELEMENT_ADD textbutton2,			ctextbutton,		$ffff,					$ffff,	 1,  3, 13,  3,  0,		ctextbutton2_data,		dummy_listeners,		0
		UIELEMENT_ADD textbutton3,			ctextbutton,		$ffff,					$ffff,	 1,  5, 13,  3,  0,		ctextbutton3_data,		dummy_listeners,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

checkboxarea1
		UIELEMENT_ADD checkboxlabel1,		label,				$ffff,					$ffff,	 2,  2,  8,  1,  0,		checkboxlabel_data,		dummy_listeners,		uidefaultflags
		UIELEMENT_ADD checkboxlabel2,		label,				$ffff,					$ffff,	 2,  4,  8,  1,  0,		checkboxlabel_data,		dummy_listeners,		uidefaultflags
		UIELEMENT_ADD checkbox1,			checkbox,			$ffff,					$ffff,	11,  2,  2,  1,  0,		checkbox1_data,			dummy_listeners,		uidefaultflags
		UIELEMENT_ADD checkbox2,			checkbox,			$ffff,					$ffff,	11,  4,  2,  1,  0,		checkbox2_data,			dummy_listeners,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

radiobtnarea1
		UIELEMENT_ADD radiolabel1,			label,				$ffff,					$ffff,	 2,  2,  8,  1,  0,		radiobuttonlabel_data,	dummy_listeners,		uidefaultflags
		UIELEMENT_ADD radiolabel2,			label,				$ffff,					$ffff,	 2,  4,  8,  1,  0,		radiobuttonlabel_data,	dummy_listeners,		uidefaultflags
		UIELEMENT_ADD radiolabel3,			label,				$ffff,					$ffff,	 2,  6,  8,  1,  0,		radiobuttonlabel_data,	dummy_listeners,		uidefaultflags
		UIELEMENT_ADD radiobutton1,			radiobutton,		$ffff,					$ffff,	12,  2,  1,  1,  0,		radiobutton1_data,		radiobutton1_listeners,	uidefaultflags
		UIELEMENT_ADD radiobutton2,			radiobutton,		$ffff,					$ffff,	12,  4,  1,  1,  0,		radiobutton2_data,		radiobutton2_listeners,	uidefaultflags
		UIELEMENT_ADD radiobutton3,			radiobutton,		$ffff,					$ffff,	12,  6,  1,  1,  0,		radiobutton3_data,		radiobutton3_listeners,	uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

mousedebugarea1
		UIELEMENT_ADD paddlexlabel,			label,				$ffff,					$ffff,	 2,  2,  8,  1,  0,		paddlexlabel_data,		dummy_listeners,		uidefaultflags
		UIELEMENT_ADD paddleylabel,			label,				$ffff,					$ffff,	 2,  4,  8,  1,  0,		paddleylabel_data,		dummy_listeners,		uidefaultflags
		UIELEMENT_ADD hexlabel1,			hexlabel,			$ffff,					$ffff,	11,  2,  2,  1,  0,		hexlabel1_data,			dummy_listeners,		uidefaultflags
		UIELEMENT_ADD hexlabel2,			hexlabel,			$ffff,					$ffff,	11,  4,  2,  1,  0,		hexlabel2_data,			dummy_listeners,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

scrollbar1elements
		UIELEMENT_ADD scrollbar1button1,	scrollbutton,		$ffff,					$ffff,	0,  0,  2,  2,  0,		button1_data,			scrollbar1_listeners,	uidefaultflags
		UIELEMENT_ADD scrollbar1button2,	scrollbutton,		$ffff,					$ffff,	0, 14,  2,  2,  0,		button2_data,			scrollbar1_listeners,	uidefaultflags
		UIELEMENT_ADD scrollbar1track,		scrolltrack,		$ffff,					$ffff,	0,  2,  2, 12,  0,		scrollbar1_data,		scrollbar1_listeners,	uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

nineslice1elements
		UIELEMENT_ADD filebox1,				filebox,			$ffff,					$ffff,	1,  1, 13, 16,  0,		filebox1_data,			scrollbar1_listeners,	uidefaultflags
		UIELEMENT_ADD scrollbar1,			scrollbar,			scrollbar1elements,		$ffff, 15,  1,  2, 16,  0,		scrollbar1_data,		dummy_listeners,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

paddlexlabel_data		.word uitxt_paddlex
hexlabel1_data			.word mouse_d419
paddleylabel_data		.word uitxt_paddley
hexlabel2_data			.word mouse_d41a

uilogo_data				.byte 14*16+0, 14*16+0							; disabled glyph, enabled glyph
scrollbar1_data			.byte 0											; scrollbar position
						.byte 0											; selection index
						.byte 30										; number of entries

checkboxlabel_data		.word uitxt_checkbox
radiobuttonlabel_data	.word uitxt_radiobutton
ctextbutton1_data		.word uitxt_button0
ctextbutton2_data		.word uitxt_button1
ctextbutton3_data		.word uitxt_button2
button1_data			.byte 4*16+0, 4*16+4							; not pressed glyph, pressed glyph
						.word scrollbar1track, uiscrollbar_decrease
button2_data			.byte 4*16+8, 4*16+12							; not pressed glyph, pressed glyph
						.word scrollbar1track, uiscrollbar_increase
filebox1_data			.word scrollbar1_data							; pointer to start position
						.word listboxtxt								; pointer to list of texts
checkbox1_data			.byte 1											; disabled/enabled
						.byte 3*16+8, 3*16+10							; disabled glyph, enabled glyph
checkbox2_data			.byte 0											; disabled/enabled
						.byte 3*16+8, 3*16+10							; disabled glyph, enabled glyph
radiobutton1_data		.byte 0											; index
						.word radiobuttongroupindex						; pointer to group index
						.byte 3*16+12, 3*16+13							; disabled glyph, enabled glyph
radiobutton2_data		.byte 1											; index
						.word radiobuttongroupindex						; pointer to group index
						.byte 3*16+12, 3*16+13							; disabled glyph, enabled glyph
radiobutton3_data		.byte 2											; index
						.word radiobuttongroupindex						; pointer to group index
						.byte 3*16+12, 3*16+13							; disabled glyph, enabled glyph
radiobuttongroupindex	.byte 1

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ listeners

scrollbar1_listeners	.word scrollbar1track
						.word uiscrolltrack_draw
						.word filebox1
						.word uilistbox_draw
						.word $ffff

radiobutton1_listeners	.word radiobutton2
						.word uiradiobutton_draw
						.word radiobutton3
						.word uiradiobutton_draw
						.word $ffff

radiobutton2_listeners	.word radiobutton1
						.word uiradiobutton_draw
						.word radiobutton3
						.word uiradiobutton_draw
						.word $ffff

radiobutton3_listeners	.word radiobutton1
						.word uiradiobutton_draw
						.word radiobutton2
						.word uiradiobutton_draw
						.word $ffff

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
