
; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ main windows

root
		UIELEMENT_ADD ui_root1,					root,				windows,				0,  0, 80, 50,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ main windows

windows

		UIELEMENT_ADD ui_windows1,				debugelement,		window1area,			 1,  0, 38, 18,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD ui_windows2,				debugelement,		window2area,			40,  0, 39, 18, 20,		$ffff,						uidefaultflags

		;UIELEMENT_ADD ptrnidxlabel,			hexlabel,			$ffff,					 1, 19,  2,  1,  0,		hexlabelptrnidx_data,		uidefaultflags
		;UIELEMENT_ADD ptrnptrlabel,			hexlabel,			$ffff,					 4, 19,  2,  1,  0,		hexlabelptrnptr_data,		uidefaultflags
		;UIELEMENT_ADD ptrnrowlabel,			hexlabel,			$ffff,					14, 19,  2,  1,  0,		hexlabelptrnrow_data,		uidefaultflags

		UIELEMENT_ADD ui_sequenceview,			nineslice,			sequenceviewelements,	 1, 22, 78,  4, 20,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_patternview,			nineslice,			patternviewelements,	 1, 26, 78, 21, 20,		$ffff,						uidefaultflags	

		UIELEMENT_ADD ui_logo,					image,				$ffff,					68, 47, 11,  2,  0,		uilogo_data,				uidefaultflags

		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

window1area
		UIELEMENT_ADD debugelementfa1,			debugelement,		filearea1,				 1,  1, 20, 16,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD debugelementcba1,			debugelement,		cbuttonarea1,			22,  1, 15,  9,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD debugelementca1,			debugelement,		checkboxarea1,			22, 10, 15,  7,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

window2area
		UIELEMENT_ADD debugelementla1,			debugelement,		listarea1,				 1,  1, 20, 16,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD debugelementrba1,			debugelement,		radiobtnarea1,			22,  1, 15,  9,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD debugelementmsa1,			debugelement,		mousedebugarea1,		22, 10, 15,  7,  0,		$ffff,						uidefaultflags
		;UIELEMENT_ADD playbutton,				button,				$ffff,					 2,  2,  2,  2,  0,		playbutton_data,			uidefaultflags
		;UIELEMENT_ADD debugelement2,			debugelement,		$ffff,					 1,  1, 37, 19,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

listarea1
		UIELEMENT_ADD la1nineslice,				nineslice,			listarea1elements,		 1,  1, -2, -2,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

filearea1
		UIELEMENT_ADD fa1nineslice,				nineslice,			filearea1elements,		 1,  1, -2, -2,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

cbuttonarea1
		UIELEMENT_ADD ctextbutton1,				ctextbutton,		$ffff,					 1,  1, -2,  3,  0,		ctextbutton1_data,			uidefaultflags
		UIELEMENT_ADD ctextbutton2,				ctextbutton,		$ffff,					 1,  3, -2,  3,  0,		ctextbutton2_data,			uidefaultflags
		UIELEMENT_ADD ctextbutton3,				ctextbutton,		$ffff,					 1,  5, -2,  3,  0,		ctextbutton3_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

checkboxarea1
		UIELEMENT_ADD checkboxlabel1,			label,				$ffff,					 2,  2,  8,  1,  0,		checkboxlabel_data,			uidefaultflags
		UIELEMENT_ADD checkboxlabel2,			label,				$ffff,					 2,  4,  8,  1,  0,		checkboxlabel_data,			uidefaultflags
		UIELEMENT_ADD checkbox1,				checkbox,			$ffff,					-4,  2,  2,  1,  0,		checkbox1_data,				uidefaultflags
		UIELEMENT_ADD checkbox2,				checkbox,			$ffff,					-4,  4,  2,  1,  0,		checkbox2_data,				uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

radiobtnarea1
		UIELEMENT_ADD radiolabel1,				label,				$ffff,					 2,  2,  8,  1,  0,		radiobuttonlabel_data,		uidefaultflags
		UIELEMENT_ADD radiolabel2,				label,				$ffff,					 2,  4,  8,  1,  0,		radiobuttonlabel_data,		uidefaultflags
		UIELEMENT_ADD radiolabel3,				label,				$ffff,					 2,  6,  8,  1,  0,		radiobuttonlabel_data,		uidefaultflags
		UIELEMENT_ADD radiobutton1,				radiobutton,		$ffff,					-3,  2,  1,  1,  0,		radiobutton1_data,			uidefaultflags
		UIELEMENT_ADD radiobutton2,				radiobutton,		$ffff,					-3,  4,  1,  1,  0,		radiobutton2_data,			uidefaultflags
		UIELEMENT_ADD radiobutton3,				radiobutton,		$ffff,					-3,  6,  1,  1,  0,		radiobutton3_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

mousedebugarea1
		UIELEMENT_ADD paddlexlabel,				label,				$ffff,					 2,  2,  8,  1,  0,		paddlexlabel_data,			uidefaultflags
		UIELEMENT_ADD paddleylabel,				label,				$ffff,					 2,  4,  8,  1,  0,		paddleylabel_data,			uidefaultflags
		UIELEMENT_ADD hexlabel1,				hexlabel,			$ffff,					-4,  2,  2,  1,  0,		hexlabel1_data,				uidefaultflags
		UIELEMENT_ADD hexlabel2,				hexlabel,			$ffff,					-4,  4,  2,  1,  0,		hexlabel2_data,				uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

filearea1elements
		UIELEMENT_ADD fa1filebox,				filebox,			$ffff,					 1,  1, -5, -2,  0,		fa1filebox_data,			uidefaultflags
		UIELEMENT_ADD fa1scrollbar,				scrollbar,			fa1scrollbarelements,	-3,  1,  2, -2,  0,		fa1scrollbar_data,			uidefaultflags
		UIELEMENT_END

fa1scrollbarelements
		UIELEMENT_ADD fa1scrollbarbuttonup,		button,				$ffff,					 0,  0,  2,  2,  0,		fa1scrollbuttonup_data,		uidefaultflags
		UIELEMENT_ADD fa1scrollbarbuttondown,	button,				$ffff,					 0, -2,  2,  2,  0,		fa1scrollbuttondown_data,	uidefaultflags
		UIELEMENT_ADD fa1scrollbartrack,		scrolltrack,		$ffff,					 0,  2,  2,  8,  0,		fa1scrollbar_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

listarea1elements
		UIELEMENT_ADD la1listbox,				listbox,			$ffff,					 1,  1, -5, -2,  0,		la1listbox_data,			uidefaultflags
		UIELEMENT_ADD la1scrollbar,				scrollbar,			la1scrollbarelements,	-3,  1,  2, -2,  0,		la1scrollbar_data,			uidefaultflags
		UIELEMENT_END

la1scrollbarelements
		UIELEMENT_ADD la1scrollbarbutton1,		button,				$ffff,					 0,  0,  2,  2,  0,		la1scrollbuttonup_data,		uidefaultflags
		UIELEMENT_ADD la1scrollbarbutton2,		button,				$ffff,					 0, -2,  2,  2,  0,		la1scrollbuttondown_data,	uidefaultflags
		UIELEMENT_ADD la1scrollbartrack,		scrolltrack,		$ffff,					 0,  2,  2, -4,  0,		la1scrollbar_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

patternviewelements
		UIELEMENT_ADD tvlistbox,				patternview,		$ffff,					 5,  4,-14, -6,  0,		tvlistbox_data,				uidefaultflags
		UIELEMENT_ADD tvscrollbar,				scrollbar,			tvscrollbarelements,	-4,  4,  2, -6,  0,		tvscrollbar_data,			uidefaultflags
		UIELEMENT_END

tvscrollbarelements
		UIELEMENT_ADD tvscrollbarbutton1,		button,				$ffff,					 0,  0,  2,  2,  0,		tvscrollbuttonup_data,		uidefaultflags
		UIELEMENT_ADD tvscrollbarbutton2,		button,				$ffff,					 0, -2,  2,  2,  0,		tvscrollbuttondown_data,	uidefaultflags
		UIELEMENT_ADD tvscrollbartrack,			scrolltrack,		$ffff,					 0,  2,  2, -4,  0,		tvscrollbar_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

sequenceviewelements
		UIELEMENT_ADD sequenceview1,			sequenceview,			$ffff,				 1,  1,-1, -1,  0,		sequenceview_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

sequenceview_data			.word $ffff,							0

paddlexlabel_data			.word $ffff,							uitxt_paddlex
hexlabel1_data				.word $ffff,							mouse_d419, 1
paddleylabel_data			.word $ffff,							uitxt_paddley
hexlabel2_data				.word $ffff,							mouse_d41a, 1

hexlabelptrnidx_data		.word $ffff,							uisequenceview_patternindex, 1
hexlabelptrnptr_data		.word $ffff,							uipatternview_patternptr, 4
hexlabelptrnrow_data		.word $ffff,							uipatternview_patternrow, 1

uilogo_data					.word $ffff,							((14*16+ 0) | (14*16+ 0)<<8)


checkboxlabel_data			.word $ffff,							uitxt_checkbox
radiobuttonlabel_data		.word $ffff,							uitxt_radiobutton

ctextbutton1_data			.word ctextbutton1_functions,			uitxt_button0
ctextbutton2_data			.word ctextbutton2_functions,			uitxt_button1
ctextbutton3_data			.word ctextbutton3_functions,			uitxt_button2

fa1scrollbar_data			.word fa1scrollbar_functions, 			0, 0, 20, fa1filebox			; start position, selection index, number of entries, ptr to list
fa1filebox_data				.word fa1scrollbar_functions,			fa1scrollbar_data, fa1boxtxt
fa1scrollbuttonup_data		.word fa1scrollbuttonup_functions,		((4*16+ 0) | (4*16+ 4)<<8)
fa1scrollbuttondown_data	.word fa1scrollbuttondown_functions,	((4*16+ 8) | (4*16+12)<<8)

la1scrollbar_data			.word la1scrollbar_functions, 			0, 0, 19, la1listbox			; start position, selection index, number of entries, ptr to list
la1listbox_data				.word la1scrollbar_functions,			la1scrollbar_data, la1boxtxt
la1scrollbuttonup_data		.word la1scrollbuttonup_functions,		((4*16+ 0) | (4*16+ 4)<<8)
la1scrollbuttondown_data	.word la1scrollbuttondown_functions,	((4*16+ 8) | (4*16+12)<<8)

tvscrollbar_data			.word tvscrollbar_functions, 			0, 1, 64+2*7, tvlistbox			; start position, selection index, number of entries, ptr to list
tvlistbox_data				.word tvscrollbar_functions,			tvscrollbar_data, tvboxtxt
tvscrollbuttonup_data		.word tvscrollbuttonup_functions,		((4*16+ 0) | (4*16+ 4)<<8)
tvscrollbuttondown_data		.word tvscrollbuttondown_functions,		((4*16+ 8) | (4*16+12)<<8)

checkbox1_data				.word $ffff,							1, ((3*16+ 8) | (3*16+10)<<8)
checkbox2_data				.word $ffff,							0, ((3*16+ 8) | (3*16+10)<<8)

radiobuttongroupindex		.word 1
radiobutton1_data			.word radiobutton_functions,			0, radiobuttongroupindex
radiobutton2_data			.word radiobutton_functions,			1, radiobuttongroupindex
radiobutton3_data			.word radiobutton_functions,			2, radiobuttongroupindex

playbutton_data				.word $ffff,							((8*16+0) | (8*16+4)<<8)

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ listeners

fa1scrollbuttonup_functions		.word fa1scrollbartrack,				uiscrollbar_decrease
								.word fa1scrollbartrack,				uiscrolltrack_draw
								.word fa1filebox,						uifilebox_draw
								.word $ffff

fa1scrollbuttondown_functions	.word fa1scrollbartrack,				uiscrollbar_increase
								.word fa1scrollbartrack,				uiscrolltrack_draw
								.word fa1filebox,						uifilebox_draw
								.word $ffff

fa1scrollbar_functions			.word fa1scrollbartrack,				uiscrolltrack_draw
								.word fa1filebox,						uifilebox_draw
								.word $ffff




la1scrollbuttonup_functions		.word la1scrollbartrack,				uiscrollbar_decrease
								.word la1scrollbartrack,				uiscrolltrack_draw
								.word la1listbox,						uilistbox_draw
								.word $ffff

la1scrollbuttondown_functions	.word la1scrollbartrack,				uiscrollbar_increase
								.word la1scrollbartrack,				uiscrolltrack_draw
								.word la1listbox,						uilistbox_draw
								.word $ffff

la1scrollbar_functions			.word la1scrollbartrack,				uiscrolltrack_draw
								.word la1listbox,						uilistbox_draw
								.word $ffff



tvscrollbuttonup_functions		.word tvscrollbartrack,					uiscrollbar_decrease
								.word tvscrollbartrack,					uiscrolltrack_draw
								.word tvlistbox,						uipatternview_draw
								.word $ffff

tvscrollbuttondown_functions	.word tvscrollbartrack,					uiscrollbar_increase
								.word tvscrollbartrack,					uiscrolltrack_draw
								.word tvlistbox,						uipatternview_draw
								.word $ffff

tvscrollbar_functions			.word tvscrollbartrack,					uiscrolltrack_draw
								.word tvlistbox,						uipatternview_draw
								.word $ffff




radiobutton_functions			.word radiobutton1,						uiradiobutton_draw
								.word radiobutton2,						uiradiobutton_draw
								.word radiobutton3,						uiradiobutton_draw
								.word $ffff

ctextbutton1_functions			.word ctextbutton1,						userfunc_playmod
								.word $ffff

ctextbutton2_functions			.word ctextbutton2,						userfunc_stopmod
								.word $ffff

ctextbutton3_functions			.word ctextbutton3,						userfunc_pausemod
								.word $ffff

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

userfunc_playmod

		jsr peppitoInit
		lda #$01
		sta peppitoPlaying
		rts

userfunc_stopmod

		jsr peppitoStop
		jsr peppitoInit
		lda #$00
		sta peppitoPlaying
		rts

userfunc_pausemod

		;lda #$c0
		;DEBUG_COLOUR
		;DEBUG_COLOUR
		;DEBUG_COLOUR
		;DEBUG_COLOUR
		;lda #$00
		;DEBUG_COLOUR
		rts

peppitoPlaying
		.byte $00

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
