; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ main windows

root
		UIELEMENT_ADD ui_root1,					root,				windows,				0,  0, 80, 50,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ main windows

windows

		UIELEMENT_ADD ui_windows1,				window,				window1area,			 0,  0, 49, 18,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD ui_windows2,				window,				window2area,			44,  0, 30, 18, 20,		$ffff,						uidefaultflags

		;UIELEMENT_ADD ptrnidxlabel,			hexlabel,			$ffff,					 1, 19,  2,  1,  0,		hexlabelptrnidx_data,		uidefaultflags
		;UIELEMENT_ADD ptrnptrlabel,			hexlabel,			$ffff,					 4, 19,  2,  1,  0,		hexlabelptrnptr_data,		uidefaultflags
		;UIELEMENT_ADD ptrnrowlabel,			hexlabel,			$ffff,					14, 19,  2,  1,  0,		hexlabelptrnrow_data,		uidefaultflags

		;UIELEMENT_ADD ui_textbox,				nineslice,			textboxelements,		 1, 18, 8+3+1+2,  3,  0,		$ffff,						uidefaultflags	

		UIELEMENT_ADD ui_tabgroup,				group,				tabgroupchildren,		 0, 17,  80, 3,  0,		tabgroup1_data,				uidefaultflags	

		UIELEMENT_ADD ui_tab1_window,			window,				tab1_contents,			 1, 21, 78, 25,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_tab2_window,			window,				tab2_contents,			 1, 21, 78, 25,  0,		$ffff,						%00000001	
		UIELEMENT_ADD ui_tab3_window,			window,				tab3_contents,			 1, 21, 78, 25,  0,		$ffff,						%00000001	

		UIELEMENT_ADD ui_logo,					image,				$ffff,					68, 47, 11,  2,  0,		uilogo_data,				uidefaultflags

		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

tabgroupchildren
		UIELEMENT_ADD ui_tab1,					tab,				$ffff,					 1, 0,  8,  3,  0,		tab1_data,					uidefaultflags	
		UIELEMENT_ADD ui_tab2,					tab,				$ffff,					 9, 0,  8,  3,  0,		tab2_data,					uidefaultflags
		UIELEMENT_ADD ui_tab3,					tab,				$ffff,					17, 0,  8,  3,  0,		tab3_data,					uidefaultflags	
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

tab1_contents
		UIELEMENT_ADD ui_sequenceview,			nineslice,			sequenceviewelements,	 0,  0, 78,  4,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_patternview,			nineslice,			patternviewelements,	 0,  4, 78, 22,  0,		$ffff,						uidefaultflags	
		UIELEMENT_END

tab2_contents
		UIELEMENT_ADD ui_textbox,				nineslice,			textboxelements,		 0,  0, 14,  3,  0,		$ffff,						%00000001
		UIELEMENT_ADD ui_sampleview,			nineslice,			sampleviewelements,		33,  6, 34, 10,  0,		$ffff,						%00000001
		UIELEMENT_END

tab3_contents
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

window1area
		UIELEMENT_ADD debugelementfa1,			window,				filearea1,				 0,  0, 20, 16,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD debugelementcba1,			window,				cbuttonarea1,			18,  0, 15,  9,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD debugelementca1,			window,				checkboxarea1,			18,  9, 15,  7,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD debugelementrba1,			window,				radiobtnarea1,			31,  0, 15,  9,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD debugelementmsa1,			window,				mousedebugarea1,		31,  9, 15,  7,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

window2area
		UIELEMENT_ADD debugelementla1,			window,				listarea1,				 0,  0, -1, 16,  0,		$ffff,						uidefaultflags
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
		UIELEMENT_ADD fa1scrollbartrack,		scrolltrack,		$ffff,					-3,  1,  2, -2,  0,		fa1scrollbar_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

listarea1elements
		UIELEMENT_ADD la1listbox,				listbox,			$ffff,					 1,  1, -5, -2,  0,		la1listbox_data,			uidefaultflags
		UIELEMENT_ADD la1scrollbartrack,		scrolltrack,		$ffff,					-3,  1,  2, -2,  0,		la1scrollbar_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

sequenceviewelements
		UIELEMENT_ADD sequenceview1,			sequenceview,		$ffff,					 1,  1,-2, -1,  0,		sequenceview_data,			uidefaultflags
		UIELEMENT_END

patternviewelements
		UIELEMENT_ADD chanview1,				channelview,		$ffff,					 5,  2, 13,  2,  0,		chanview1_data,				uidefaultflags
		UIELEMENT_ADD chanview2,				channelview,		$ffff,					22,  2, 13,  2,  0,		chanview2_data,				uidefaultflags
		UIELEMENT_ADD chanview3,				channelview,		$ffff,					39,  2, 13,  2,  0,		chanview3_data,				uidefaultflags
		UIELEMENT_ADD chanview4,				channelview,		$ffff,					56,  2, 13,  2,  0,		chanview4_data,				uidefaultflags
		UIELEMENT_ADD tvlistbox,				patternview,		$ffff,					 5,  5,-14, -7,  0,		tvlistbox_data,				uidefaultflags
		UIELEMENT_ADD tvscrollbartrack,			scrolltrack,		$ffff,					-3,  5,  2, -7,  0,		tvscrollbar_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

textboxelements
		UIELEMENT_ADD textbox1,					textbox,			$ffff,					 1,  1,-1, -1,  0,		textbox1_data,				uidefaultflags
		UIELEMENT_END

sampleviewelements
		UIELEMENT_ADD sampleview1,				sampleview,			$ffff,					 1,  1,-1, -1,  0,		sampleview1_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

chanview1_data				.word $ffff,														0, $3d, $00				; channel, colour, vu strength
chanview2_data				.word $ffff,														1, $31, $00
chanview3_data				.word $ffff,														2, $7a, $00
chanview4_data				.word $ffff,														3, $a0, $00

sequenceview_data			.word $ffff,														0

textbox1_data				.word $ffff,														uitxt_textbox1, 0, 0	; ptr to text, cursor position, end position

paddlexlabel_data			.word $ffff,														uitxt_paddlex
hexlabel1_data				.word $ffff,														mouse_d419, 1
paddleylabel_data			.word $ffff,														uitxt_paddley
hexlabel2_data				.word $ffff,														mouse_d41a, 1

hexlabelptrnidx_data		.word $ffff,														uisequenceview_patternindex, 1
hexlabelptrnptr_data		.word $ffff,														uipatternview_patternptr, 4
hexlabelptrnrow_data		.word $ffff,														uipatternview_patternrow, 1

tabgroup1_data				.word $ffff,														0								; group bitmask

uilogo_data					.word $ffff,														((14*16+ 0) | (14*16+ 0)<<8)

checkboxlabel_data			.word $ffff,														uitxt_checkbox
radiobuttonlabel_data		.word $ffff,														uitxt_radiobutton

ctextbutton1_data			.word ctextbutton1_functions,										uitxt_button0, KEYBOARD_F1
ctextbutton2_data			.word ctextbutton2_functions,										uitxt_button1, KEYBOARD_F3
ctextbutton3_data			.word ctextbutton3_functions,										uitxt_button2, KEYBOARD_F5

fa1scrollbar_data			.word fa1scrollbar_functions, 										0, 0, 20, fa1filebox			; start position, selection index, number of entries, ptr to list
fa1filebox_data				.word fa1scrollbar_functions,			filebox1_functions,			fa1scrollbar_data, fa1boxtxt

la1scrollbar_data			.word la1scrollbar_functions, 										0, 0, 19, la1listbox			; start position, selection index, number of entries, ptr to list
la1listbox_data				.word la1scrollbar_functions,			listbox1_functions,			la1scrollbar_data, la1boxtxt

tvscrollbar_data			.word tvscrollbar_functions, 										0, 1, 64+2*7, tvlistbox			; start position, selection index, number of entries, ptr to list
tvlistbox_data				.word tvscrollbar_functions,										tvscrollbar_data, tvboxtxt

checkbox1_data				.word $ffff,														1, ((3*16+ 8) | (3*16+10)<<8)
checkbox2_data				.word $ffff,														0, ((3*16+ 8) | (3*16+10)<<8)

radiobuttongroupindex		.word 1
radiobutton1_data			.word radiobutton_functions,										0, radiobuttongroupindex
radiobutton2_data			.word radiobutton_functions,										1, radiobuttongroupindex
radiobutton3_data			.word radiobutton_functions,										2, radiobuttongroupindex

tab1_data					.word tab_functions,												0, ui_tab1_window
tab2_data					.word tab_functions,												1, ui_tab2_window
tab3_data					.word tab_functions,												2, ui_tab3_window

playbutton_data				.word $ffff,														((8*16+0) | (8*16+4)<<8)

sampleview1_data			.word $ffff,														2

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ listeners

fa1scrollbar_functions			.word fa1scrollbartrack,				uiscrolltrack_draw
								.word fa1filebox,						uifilebox_draw
								.word $ffff

la1scrollbar_functions			.word la1scrollbartrack,				uiscrolltrack_draw
								.word la1listbox,						uilistbox_draw
								.word $ffff

tvscrollbar_functions			.word tvscrollbartrack,					uiscrolltrack_draw
								.word tvlistbox,						uipatternview_draw
								.word $ffff

radiobutton_functions			.word radiobutton1,						uiradiobutton_draw
								.word radiobutton2,						uiradiobutton_draw
								.word radiobutton3,						uiradiobutton_draw
								.word $ffff

tab_functions					.word ui_tab1,							uitab_draw
								.word ui_tab2,							uitab_draw
								.word ui_tab3,							uitab_draw
								.word $ffff

ctextbutton1_functions			.word ctextbutton1,						userfunc_playmod
								.word $ffff

ctextbutton2_functions			.word ctextbutton2,						userfunc_stopmod
								.word $ffff

ctextbutton3_functions			.word ctextbutton3,						userfunc_pausemod
								.word $ffff

listbox1_functions				.word la1listbox,						userfunc_populatesample
								.word $ffff

filebox1_functions				.word fa1filebox,						userfunc_openfile
								.word $ffff

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

userfunc_playmod
		UICORE_CALLELEMENTFUNCTION tvlistbox, uipatternview_storepositions
		jsr peppitoInit
		lda #$01
		sta peppitoPlaying
		rts

userfunc_stopmod
		jsr peppitoStop
		jsr peppitoInit
		lda #$00
		sta peppitoPlaying
		UICORE_CALLELEMENTFUNCTION tvlistbox, uipatternview_restorepositions
		rts

userfunc_pausemod
		;UICORE_CALLELEMENTFUNCTION ui_tab1_window, uiwindow_hide
		rts

userfunc_populatesample

		lda #<la1scrollbar_data
		sta zpptr1+0
		lda #>la1scrollbar_data
		sta zpptr1+1

		ldy #$04
		lda (zpptr1),y
		tax

		lda #<sampleview1_data
		sta zpptr1+0
		lda #>sampleview1_data
		sta zpptr1+1

		txa
		ldy #$02
		sta (zpptr1),y

		UICORE_CALLELEMENTFUNCTION sampleview1, uisampleview_draw

		rts

userfunc_openfile
		rts

peppitoPlaying
		.byte $00

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
