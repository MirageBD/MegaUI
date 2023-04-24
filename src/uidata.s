; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ main windows

root
		UIELEMENT_ADD ui_root1,					root,				windows,				0,  0, 80, 50,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ main windows

windows

		UIELEMENT_ADD ui_windows0,				window,				window0area,			 0,  0, 80,  3,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD ui_windows1,				window,				window1area,			 0,  3, 49, 18,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD ui_windows2,				window,				window2area,			41,  4, 40, 18, 20,		$ffff,						uidefaultflags
		UIELEMENT_ADD ui_windows3,				window,				window3area,			 0, 21, 80, 25, 20,		$ffff,						uidefaultflags
		UIELEMENT_ADD ui_windows4,				window,				window4area,			 0, 48, 80,  2,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

window0area

		UIELEMENT_ADD ctextbutton1,				ctextbutton,		$ffff,					 0,  0, 12,  3,  0,		ctextbutton1_data,			uidefaultflags
		UIELEMENT_ADD ctextbutton2,				ctextbutton,		$ffff,					12,  0, 12,  3,  0,		ctextbutton2_data,			uidefaultflags
		UIELEMENT_ADD ctextbutton3,				ctextbutton,		$ffff,					24,  0, 12,  3,  0,		ctextbutton3_data,			uidefaultflags

		;UIELEMENT_ADD paddlexlabel,			label,				$ffff,					60,  1,  8,  1,  0,		paddlexlabel_data,			uidefaultflags
		;UIELEMENT_ADD paddleylabel,			label,				$ffff,					70,  1,  8,  1,  0,		paddleylabel_data,			uidefaultflags
		;UIELEMENT_ADD hexlabel1,				hexlabel,			$ffff,					74,  1,  2,  1,  0,		hexlabel1_data,				uidefaultflags
		;UIELEMENT_ADD hexlabel2,				hexlabel,			$ffff,					77,  1,  2,  1,  0,		hexlabel2_data,				uidefaultflags

		UIELEMENT_END

window1area

		UIELEMENT_ADD ui_filetabgroup,			group,				filetabgroupchildren,	 0,  0, 80,  2,  0,		filetabgroup1_data,			uidefaultflags	
		UIELEMENT_ADD ui_filetab1_window,		window,				filetab1_contents,		 0,  2, 40, 15,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_filetab2_window,		window,				filetab2_contents,		 0,  2, 40, 15,  0,		$ffff,						%00000001	
		UIELEMENT_ADD ui_filetab3_window,		window,				filetab3_contents,		 0,  2, 40, 15,  0,		$ffff,						%00000001	

		;UIELEMENT_ADD checkboxlabel1,			label,				$ffff,					20,  9,  8,  1,  0,		checkboxlabel_data,			uidefaultflags
		;UIELEMENT_ADD checkboxlabel2,			label,				$ffff,					20, 11,  8,  1,  0,		checkboxlabel_data,			uidefaultflags
		;UIELEMENT_ADD checkbox1,				checkbox,			$ffff,					30,  9,  2,  1,  0,		checkbox1_data,				uidefaultflags
		;UIELEMENT_ADD checkbox2,				checkbox,			$ffff,					30, 11,  2,  1,  0,		checkbox2_data,				uidefaultflags

		;UIELEMENT_ADD radiolabel1,				label,				$ffff,					33,  2,  8,  1,  0,		radiobuttonlabel_data,		uidefaultflags
		;UIELEMENT_ADD radiolabel2,				label,				$ffff,					33,  4,  8,  1,  0,		radiobuttonlabel_data,		uidefaultflags
		;UIELEMENT_ADD radiolabel3,				label,				$ffff,					33,  6,  8,  1,  0,		radiobuttonlabel_data,		uidefaultflags
		;UIELEMENT_ADD radiobutton1,			radiobutton,		$ffff,					42,  2,  1,  1,  0,		radiobutton1_data,			uidefaultflags
		;UIELEMENT_ADD radiobutton2,			radiobutton,		$ffff,					42,  4,  1,  1,  0,		radiobutton2_data,			uidefaultflags
		;UIELEMENT_ADD radiobutton3,			radiobutton,		$ffff,					42,  6,  1,  1,  0,		radiobutton3_data,			uidefaultflags

		UIELEMENT_END

window2area
		UIELEMENT_ADD la1nineslice,				nineslice,			listarea1elements,		 0,  1, -2, -2,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

window3area
		UIELEMENT_ADD ui_tabgroup,				group,				tabgroupchildren,		 0,  0,  80, 2,  0,		tabgroup1_data,				uidefaultflags	
		UIELEMENT_ADD ui_tab1_window,			window,				tab1_contents,			 0,  2, 80, 24,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_tab2_window,			window,				tab2_contents,			 0,  2, 80, 24,  0,		$ffff,						%00000001	
		UIELEMENT_END

window4area
		UIELEMENT_ADD ui_logogroup,				group,				$ffff,					 0,  0, 80,  2,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_logo,					image,				$ffff,					69,  0, 11,  2,  0,		uilogo_data,				uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

filetabgroupchildren
		UIELEMENT_ADD ui_filetab1,				tab,				$ffff,					 1, 0,  8,  3,  0,		filetab1_data,				uidefaultflags	
		UIELEMENT_ADD ui_filetab2,				tab,				$ffff,					 9, 0,  8,  3,  0,		filetab2_data,				uidefaultflags
		UIELEMENT_ADD ui_filetab3,				tab,				$ffff,					17, 0,  8,  3,  0,		filetab3_data,				uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

filetab1_contents
		UIELEMENT_ADD fa1nineslice,				nineslice,			filearea1elements,		 1,  0, 38, 16,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

filetab2_contents
		UIELEMENT_END

filetab3_contents
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

tabgroupchildren
		UIELEMENT_ADD ui_tab1,					tab,				$ffff,					 1, 0,  8,  2,  0,		tab1_data,					uidefaultflags	
		UIELEMENT_ADD ui_tab2,					tab,				$ffff,					 9, 0,  8,  2,  0,		tab2_data,					uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

tab1_contents
		;UIELEMENT_ADD ui_sequenceview,			nineslice,			sequenceviewelements,	 0,  0, 78,  4,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_patternview,			nineslice,			patternviewelements,	12,  0, 54, 24,  0,		$ffff,						uidefaultflags	
		UIELEMENT_END

tab2_contents
		UIELEMENT_ADD ui_textbox,				nineslice,			textboxelements,		 1,  0, 14,  3,  0,		$ffff,						%00000001
		UIELEMENT_ADD ui_sampleview,			nineslice,			sampleviewelements,		33,  6, 34, 10,  0,		$ffff,						%00000001
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

filearea1elements
		UIELEMENT_ADD fa1filebox,				filebox,			$ffff,					 3,  2, -7, -3,  0,		fa1filebox_data,			uidefaultflags
		UIELEMENT_ADD fa1scrollbartrack,		scrolltrack,		$ffff,					-3,  2,  2, -3,  0,		fa1scrollbar_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

listarea1elements
		UIELEMENT_ADD la1listbox,				listbox,			$ffff,					 3,  2, -7, -4,  0,		la1listbox_data,			uidefaultflags
		UIELEMENT_ADD la1scrollbartrack,		scrolltrack,		$ffff,					-3,  2,  2, -4,  0,		la1scrollbar_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

sequenceviewelements
		UIELEMENT_ADD sequenceview1,			sequenceview,		$ffff,					 1,  1,-2, -1,  0,		sequenceview_data,			uidefaultflags
		UIELEMENT_END

patternviewelements
		UIELEMENT_ADD chanview1,				channelview,		$ffff,					 4,  2, 10,  2,  0,		chanview1_data,				uidefaultflags
		UIELEMENT_ADD chanview2,				channelview,		$ffff,					16,  2, 10,  2,  0,		chanview2_data,				uidefaultflags
		UIELEMENT_ADD chanview3,				channelview,		$ffff,					28,  2, 10,  2,  0,		chanview3_data,				uidefaultflags
		UIELEMENT_ADD chanview4,				channelview,		$ffff,					40,  2, 10,  2,  0,		chanview4_data,				uidefaultflags
		UIELEMENT_ADD tvlistbox,				patternview,		$ffff,					 4,  5, -8, -7,  0,		tvlistbox_data,				uidefaultflags
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

filetabgroup1_data			.word $ffff,														0								; group bitmask

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

;radiobuttongroupindex		.word 1
;radiobutton1_data			.word radiobutton_functions,										0, radiobuttongroupindex
;radiobutton2_data			.word radiobutton_functions,										1, radiobuttongroupindex
;radiobutton3_data			.word radiobutton_functions,										2, radiobuttongroupindex

filetab1_data				.word filetab_functions,											0, ui_filetab1_window
filetab2_data				.word filetab_functions,											1, ui_filetab2_window
filetab3_data				.word filetab_functions,											2, ui_filetab3_window

tab1_data					.word tab_functions,												0, ui_tab1_window
tab2_data					.word tab_functions,												1, ui_tab2_window

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

;radiobutton_functions			.word radiobutton1,						uiradiobutton_draw
;								.word radiobutton2,						uiradiobutton_draw
;								.word radiobutton3,						uiradiobutton_draw
;								.word $ffff

tab_functions					.word ui_tab1,							uitab_draw
								.word ui_tab2,							uitab_draw
								.word $ffff

filetab_functions				.word ui_filetab1,						uitab_draw
								.word ui_filetab2,						uitab_draw
								.word ui_filetab3,						uitab_draw
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
		rts

userfunc_populatesample

		ldy #$02													; if not already selected, select the sample tab
		lda tabgroup1_data,y
		cmp #$01
		beq :+
		UICORE_CALLELEMENTFUNCTION ui_tab2, uitab_release

:		UICORE_SELECT_ELEMENT_1 la1scrollbar_data
		ldy #$04													; get selected index
		lda (zpptr1),y
		tax

		UICORE_SELECT_ELEMENT_1 sampleview1_data					; feed selected index into sampleview element
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
