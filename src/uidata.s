; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ main windows

root
		UIELEMENT_ADD ui_root1,					root,				windows,				0,  0, 80, 50,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ main windows

windows

		UIELEMENT_ADD ui_windows0,				window,				window0area,			 0,  0, 80,  3,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD ui_windows1,				window,				window1area,			 0,  3, 49, 19,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD ui_windows2,				window,				window2area,			41,  4, 40, 19, 20,		$ffff,						uidefaultflags
		UIELEMENT_ADD ui_windows3,				window,				window3area,			 0, 22, 80, 25, 20,		$ffff,						uidefaultflags
		UIELEMENT_ADD ui_windows4,				window,				window4area,			 0, 48, 80,  2,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

window0area

		UIELEMENT_ADD playbutton,				glyphbutton,		$ffff,					 1,  0,  3,  3,  0,		playbutton_data,			uidefaultflags
		UIELEMENT_ADD playpatternbutton,		glyphbutton,		$ffff,					 4,  0,  3,  3,  0,		playpatternbutton_data,		uidefaultflags
		UIELEMENT_ADD stopbutton,				glyphbutton,		$ffff,					 7,  0,  3,  3,  0,		stopbutton_data,			uidefaultflags
		UIELEMENT_ADD recordbutton,				glyphbutton,		$ffff,					10,  0,  3,  3,  0,		recordbutton_data,			uidefaultflags

		UIELEMENT_ADD topdivider1,				divider,			$ffff,					14,  0,  1,  3,  0,		$ffff,						uidefaultflags

		UIELEMENT_ADD volumeslider,				slider,				$ffff,					16,  1, 16,  1,  0,		volumeslider_data,			uidefaultflags

		UIELEMENT_ADD topdivider2,				divider,			$ffff,					33,  0,  1,  3,  0,		$ffff,						uidefaultflags

		UIELEMENT_ADD bpmlabel,					label,				$ffff,					35,  1,  3,  1,  0,		bpmlabel_data,				uidefaultflags
		UIELEMENT_ADD nbbpm,					cnumericbutton,		$ffff,					38,  0,  7,  3,  0,		nbbpm_data,					uidefaultflags

		UIELEMENT_ADD topdivider3,				divider,			$ffff,					45,  0,  1,  3,  0,		$ffff,						uidefaultflags

		UIELEMENT_ADD filenamens,				nineslice,			filenametextboxelements,47,  0, 24,  3,  0,		$ffff,						uidefaultflags

		UIELEMENT_ADD savefilebutton,			ctextbutton,		$ffff,					72,  0,  8,  3,  0,		savefilebutton_data,		uidefaultflags

		;UIELEMENT_ADD ctextbutton1,			ctextbutton,		$ffff,					 4,  0, 12,  3,  0,		ctextbutton1_data,			uidefaultflags
		;UIELEMENT_ADD ctextbutton2,			ctextbutton,		$ffff,					16,  0, 12,  3,  0,		ctextbutton2_data,			uidefaultflags
		;UIELEMENT_ADD ctextbutton3,			ctextbutton,		$ffff,					28,  0, 12,  3,  0,		ctextbutton3_data,			uidefaultflags

		;UIELEMENT_ADD cnumericbutton1,			cnumericbutton,		$ffff,					40,  0,  9,  3,  0,		cnumericbutton1_data,		uidefaultflags

		;UIELEMENT_ADD paddlexlabel,			label,				$ffff,					60,  1,  8,  1,  0,		paddlexlabel_data,			uidefaultflags
		;UIELEMENT_ADD paddleylabel,			label,				$ffff,					70,  1,  8,  1,  0,		paddleylabel_data,			uidefaultflags
		;UIELEMENT_ADD hexlabel1,				hexlabel,			$ffff,					74,  1,  2,  1,  0,		hexlabel1_data,				uidefaultflags
		;UIELEMENT_ADD hexlabel2,				hexlabel,			$ffff,					77,  1,  2,  1,  0,		hexlabel2_data,				uidefaultflags

		UIELEMENT_END

window1area

		UIELEMENT_ADD ui_filetabgroup,			group,				filetabgroupchildren,	 0,  0, 80,  2,  0,		filetabgroup1_data,			uidefaultflags	
		UIELEMENT_ADD ui_filetab1_window,		window,				filetab1_contents,		 0,  2, 40, 16,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_filetab2_window,		window,				filetab2_contents,		 0,  2, 40, 16,  0,		$ffff,						%00000001	
		UIELEMENT_ADD ui_filetab3_window,		window,				filetab3_contents,		 0,  2, 40, 16,  0,		$ffff,						%00000001	

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
		UIELEMENT_ADD ui_tab1_window,			window,				tab1_contents,			 0,  2, 80, 23,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_tab2_window,			window,				tab2_contents,			 0,  2, 80, 23,  0,		$ffff,						%00000001	
		UIELEMENT_END

window4area
		UIELEMENT_ADD ui_logogroup,				group,				$ffff,					 0,  0, 80,  2,  0,		$ffff,						uidefaultflags
		UIELEMENT_ADD lblstatus,				label,				$ffff,					 0,  1, 40,  1,  0,		lblstatus_data,				uidefaultflags
		UIELEMENT_ADD ui_logo,					image,				$ffff,					69,  0, 11,  2,  0,		uilogo_data,				uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

filetabgroupchildren
		UIELEMENT_ADD ui_filetab1,				tab,				$ffff,					 1, 0,  7,  3,  0,		filetab1_data,				uidefaultflags	
		UIELEMENT_ADD ui_filetab2,				tab,				$ffff,					 8, 0, 13,  3,  0,		filetab2_data,				uidefaultflags
		UIELEMENT_ADD ui_filetab3,				tab,				$ffff,					21, 0,  9,  3,  0,		filetab3_data,				uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

filetab1_contents
		UIELEMENT_ADD fa1nineslice,				nineslice,			filearea1elements,		 1,  0, 38, 17,  0,		$ffff,						uidefaultflags
		UIELEMENT_END

filetab2_contents
		UIELEMENT_END

filetab3_contents
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

tabgroupchildren
		UIELEMENT_ADD ui_tab1,					tab,				$ffff,					 1, 0,  6,  2,  0,		tab1_data,					uidefaultflags	
		UIELEMENT_ADD ui_tab2,					tab,				$ffff,					 7, 0,  8,  2,  0,		tab2_data,					uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

tab1_contents
		UIELEMENT_ADD ui_sequenceview,			nineslice,			sequenceviewelements,	 1,  0, 12, 24,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_patternview,			nineslice,			patternviewelements,	14,  0, 54, 24,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_scopeview1,			nineslice,			$ffff,					69,  0, 10,  6,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_scopeview2,			nineslice,			$ffff,					69,  6, 10,  6,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_scopeview3,			nineslice,			$ffff,					69, 12, 10,  6,  0,		$ffff,						uidefaultflags	
		UIELEMENT_ADD ui_scopeview4,			nineslice,			$ffff,					69, 18, 10,  6,  0,		$ffff,						uidefaultflags	
		UIELEMENT_END

tab2_contents
		UIELEMENT_ADD sample_textbox,			nineslice,			sampletextboxelements,	 5,  2, 24,  3,  0,		$ffff,						%00000001

		UIELEMENT_ADD lblfinetune,				label,				$ffff,					12,  6,  9,  1,  0,		lblfinetune_data,			%00000001
		UIELEMENT_ADD lblvolume,				label,				$ffff,					14,  8,  9,  1,  0,		lblvolume_data,				%00000001
		UIELEMENT_ADD lbllength,				label,				$ffff,					14, 10,  9,  1,  0,		lbllength_data,				%00000001
		UIELEMENT_ADD lblrepeat,				label,				$ffff,					14, 12,  9,  1,  0,		lblrepeat_data,				%00000001
		UIELEMENT_ADD lblrepeatlen,				label,				$ffff,					11, 14,  9,  1,  0,		lblrepeatlen_data,			%00000001

		UIELEMENT_ADD nbfinetune,				cnumericbutton,		$ffff,					20,  5,  9,  3,  0,		nbfinetune_data,			%00000001
		UIELEMENT_ADD nbvolume,					cnumericbutton,		$ffff,					20,  7,  9,  3,  0,		nbvolume_data,				%00000001
		UIELEMENT_ADD nblength,					cnumericbutton,		$ffff,					20,  9,  9,  3,  0,		nblength_data,				%00000001
		UIELEMENT_ADD nbrepeat,					cnumericbutton,		$ffff,					20, 11,  9,  3,  0,		nbrepeat_data,				%00000001
		UIELEMENT_ADD nbrepeatlen,				cnumericbutton,		$ffff,					20, 13,  9,  3,  0,		nbrepeatlen_data,			%00000001

		UIELEMENT_ADD sampledivider,			divider,			$ffff,					30,  2,  1, 20,  0,		$ffff,						%00000001

		UIELEMENT_ADD ui_sampleview,			nineslice,			sampleviewelements,		33,  5, 34, 11,  0,		$ffff,						%00000001
		UIELEMENT_ADD ui_piano,					piano,				$ffff,					36, 17, 34,  5,  0,		piano_data,					%00000001

		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ child windows

filearea1elements
		UIELEMENT_ADD fa1filebox,				filebox,			$ffff,					 3,  2, -7, -4,  0,		fa1filebox_data,			uidefaultflags
		UIELEMENT_ADD fa1scrollbartrack,		scrolltrack,		$ffff,					-3,  2,  2, -4,  0,		fa1scrollbar_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

listarea1elements
		UIELEMENT_ADD la1listbox,				listbox,			$ffff,					 3,  2, -7, -4,  0,		la1listbox_data,			uidefaultflags
		UIELEMENT_ADD la1scrollbartrack,		scrolltrack,		$ffff,					-3,  2,  2, -4,  0,		la1scrollbar_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ scrollbar elements

sequenceviewelements
		UIELEMENT_ADD sequenceview1,			sequenceview,		$ffff,					 2,  5, -5, -7,  0,		sequenceview_data,			uidefaultflags
		UIELEMENT_ADD svscrollbartrack,			scrolltrack,		$ffff,					-3,  5,  2, -7,  0,		svscrollbar_data,			uidefaultflags
		UIELEMENT_END

patternviewelements
		UIELEMENT_ADD chanview1,				channelview,		$ffff,					 4,  2, 10,  2,  0,		chanview1_data,				uidefaultflags
		UIELEMENT_ADD chanview2,				channelview,		$ffff,					16,  2, 10,  2,  0,		chanview2_data,				uidefaultflags
		UIELEMENT_ADD chanview3,				channelview,		$ffff,					28,  2, 10,  2,  0,		chanview3_data,				uidefaultflags
		UIELEMENT_ADD chanview4,				channelview,		$ffff,					40,  2, 10,  2,  0,		chanview4_data,				uidefaultflags
		UIELEMENT_ADD tvlistbox,				patternview,		$ffff,					 1,  5, -5, -7,  0,		tvlistbox_data,				uidefaultflags
		UIELEMENT_ADD tvscrollbartrack,			scrolltrack,		$ffff,					-3,  5,  2, -7,  0,		tvscrollbar_data,			uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

sampletextboxelements
		UIELEMENT_ADD sampletextbox,			textbox,			$ffff,					 1,  1,-1, -1,  0,		sampletextbox_data,			uidefaultflags
		UIELEMENT_END

filenametextboxelements
		UIELEMENT_ADD filenametextbox,			textbox,			$ffff,					 1,  1,-1, -1,  0,		filenametextbox_data,		uidefaultflags
		UIELEMENT_END

sampleviewelements
		UIELEMENT_ADD sampleview1,				sampleview,			$ffff,					 1,  1,-1, -1,  0,		sampleview1_data,			uidefaultflags
		UIELEMENT_ADD samplescaletrack,			scaletrack,			$ffff,					 1,  9,-1,  1,  0,		samplescaletrack_data,		uidefaultflags
		UIELEMENT_END

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ data

chanview1_data				.word $ffff,														0, $b7, $00				; channel, colour, vu strength
chanview2_data				.word $ffff,														1, $b7, $00
chanview3_data				.word $ffff,														2, $b7, $00
chanview4_data				.word $ffff,														3, $b7, $00

svscrollbar_data			.word svscrollbar_functions, 										0, 1, 128+2*7+2, sequenceview1	; start position, selection index, number of entries, ptr to list
sequenceview_data			.word svscrollbar_functions,										svscrollbar_data, idxPepPtn0

bpmlabel_data				.word $ffff,														uitxt_bpm

sampletextbox_data			.word $ffff,														0, 0, 0, 22, uitxt_samplebox 		; start position, cursor pos, text length, max text size, ptr to text
filenametextbox_data		.word $ffff,														0, 0, 0, 30, uitxt_filenamebox		; start position, cursor pos, text length, max text size, ptr to text

savefilebutton_data			.word $ffff,														uitxt_save, 0, 0, 0, 0			; ptr to text, position of cursor, start pos, selection start, selection end

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

playbutton_data				.word playbutton_functions,											9*16+0, KEYBOARD_F1
playpatternbutton_data		.word playpatternbutton_functions,									9*16+2, KEYBOARD_F3
stopbutton_data				.word stopbutton_functions,											9*16+4, KEYBOARD_F5
recordbutton_data			.word recordbutton_functions,										9*16+6, KEYBOARD_F7

volumeslider_data			.word volumeslider_functions,										255

cnumericbutton1_data		.word $ffff,														$1234, $0000, $babe, 2		; value, address, number of bytes

lblstatus_data				.word $ffff,														uitxt_status

lblfinetune_data			.word $ffff,														uitxt_finetune
lblvolume_data				.word $ffff,														uitxt_volume
lbllength_data				.word $ffff,														uitxt_length
lblrepeat_data				.word $ffff,														uitxt_repeat
lblrepeatlen_data			.word $ffff,														uitxt_repeatlen

nbfinetune_data				.word $ffff,														$0000, $babe, 1, 0, 0,   255, 0		; value, address, number of bytes, hexadecimal or not, min value, max value, signed offset
nbvolume_data				.word $ffff,														$0000, $babe, 1, 0, 0,   255, 0
nblength_data				.word $ffff,														$0000, $babe, 2, 0, 0, 65535, 0
nbrepeat_data				.word $ffff,														$0000, $babe, 2, 0, 0, 65535, 0
nbrepeatlen_data			.word $ffff,														$0000, $babe, 2, 0, 0, 65535, 0

nbbpm_data					.word $ffff,														$0000, $babe, 1, 0, 0,   255, 0

fa1scrollbar_data			.word fa1scrollbar_functions, 										0, 0, 20, fa1filebox			; start position, selection index, number of entries, ptr to list
fa1filebox_data				.word fa1scrollbar_functions,			filebox1_functions,			fa1scrollbar_data, fa1boxtxt, fa1directorytxt

la1scrollbar_data			.word la1scrollbar_functions, 										0, 0, 19, la1listbox			; start position, selection index, number of entries, ptr to list
la1listbox_data				.word la1scrollbar_functions,			listbox1_functions,			la1scrollbar_data, la1boxtxt

tvscrollbar_data			.word tvscrollbar_functions, 										0, 1, 64+2*7+2, tvlistbox			; start position, selection index, number of entries, ptr to list
tvlistbox_data				.word tvscrollbar_functions,										tvscrollbar_data, tvboxtxt

checkbox1_data				.word $ffff,														1, ((3*16+ 8) | (3*16+10)<<8)
checkbox2_data				.word $ffff,														0, ((3*16+ 8) | (3*16+10)<<8)

;radiobuttongroupindex		.word 1
;radiobutton1_data			.word radiobutton_functions,										0, radiobuttongroupindex
;radiobutton2_data			.word radiobutton_functions,										1, radiobuttongroupindex
;radiobutton3_data			.word radiobutton_functions,										2, radiobuttongroupindex

filetab1_data				.word filetab_functions,											0, ui_filetab1_window, uitxt_songs
filetab2_data				.word filetab_functions,											1, ui_filetab2_window, uitxt_instruments
filetab3_data				.word filetab_functions,											2, ui_filetab3_window, uitxt_samples

tab1_data					.word tab_functions,												0, ui_tab1_window, uitxt_edit
tab2_data					.word tab_functions,												1, ui_tab2_window, uitxt_sample

sampleview1_data			.word $ffff,														2, 0, 255						; sample index, startpos, endpos
samplescaletrack_data		.word scaletrack_functions,											sampleview1_data				; ptr to sampleview

piano_data					.word $ffff,														2								; sample index

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

svscrollbar_functions			.word svscrollbartrack,					uiscrolltrack_draw
								.word sequenceview1,					uisequenceview_draw
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

scaletrack_functions			.word samplescaletrack,					uiscaletrack_draw
								.word sampleview1,						uisampleview_draw
								.word $ffff

playbutton_functions			.word playbutton,						userfunc_playmod
								.word $ffff

playpatternbutton_functions		.word playpatternbutton,				uiglyphbutton_drawreleased
								.word $ffff

stopbutton_functions			.word playbutton,						uiglyphbutton_drawreleased
								.word recordbutton,						uiglyphbutton_drawreleased
								.word stopbutton,						uiglyphbutton_drawreleased
								.word stopbutton,						userfunc_stopmod
								.word $ffff

recordbutton_functions			.word recordbutton,						userfunc_recordmod
								.word $ffff

listbox1_functions				.word la1listbox,						userfunc_populatesample
								.word $ffff

filebox1_functions				.word fa1filebox,						userfunc_openfile
								.word $ffff

volumeslider_functions			.word volumeslider,						userfunc_setvolume
								.word $ffff


; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

userfunc_playmod
		UICORE_CALLELEMENTFUNCTION tvlistbox, uipatternview_storepositions
		;jsr peppitoReset
		;jsr peppitoInit
		lda #$01
		sta valPepPlaying
		rts

userfunc_stopmod
		jsr peppitoStop
		jsr peppitoClearChans
		jsr peppitoClearCurrentSamples
		;jsr peppitoInit
		lda #$00
		sta valPepPlaying
		UICORE_CALLELEMENTFUNCTION la1listbox, uilistbox_init
		UICORE_CALLELEMENTFUNCTION tvlistbox, uipatternview_restorepositions
		rts

userfunc_recordmod
		rts

userfunc_resetsampleindex
		lda #$01
		sta (zpptr1),y
		rts

userfunc_setvolume
		ldy #$02
		lda volumeslider_data,y
		sta valPepGlobalVolume
		;STA	$D729+0*16
		;STA	$D729+1*16
		;STA	$D729+2*16
		;STA	$D729+3*16
		rts

userfunc_selectsampletab

		ldy #$02
		lda tabgroup1_data,y
		cmp #$01
		beq :+
		UICORE_CALLELEMENTFUNCTION ui_tab2, uitab_release
		rts

userfunc_populatesample

		jsr userfunc_selectsampletab								; if not already selected, select the sample tab

:		UICORE_SELECT_ELEMENT_1 la1scrollbar_data
		ldy #$04													; get selected index
		lda (zpptr1),y
		tax
		inx															; skip 1 because sample 0 doesn't exist

		UICORE_SELECT_ELEMENT_1 sampleview1_data
		txa															; feed selected index into sampleview element
		ldy #$02
		sta (zpptr1),y	

		lda #$00													; set start and end pos 0, 255
		ldy #$04
		sta (zpptr1),y
		lda #$ff
		ldy #$06
		sta (zpptr1),y

		UICORE_SELECT_ELEMENT_1 piano_data
		txa															; feed selected index into piano element
		ldy #$02
		sta (zpptr1),y	

		asl
		tax
		lda idxPepIns0+0,x											; put pointer to instrument struct into zpptrtmp
		sta zpptrtmp+0												; $2e
		lda idxPepIns0+1,x
		sta zpptrtmp+1												; $3c

		ldy #0														; put pointer to instrument header (4 bytes) into zpptrtmp2
		lda (zpptrtmp),y
		sta zpptrtmp2+0
		iny
		lda (zpptrtmp),y
		sta zpptrtmp2+1
		iny
		lda (zpptrtmp),y
		sta zpptrtmp2+2
		iny
		lda (zpptrtmp),y
		sta zpptrtmp2+3

		ldy #$00
		ldz #$00
:		lda [zpptrtmp2],z
		tax
		lda ui_textremap,x
		sta uitxt_samplebox,y
		iny
		inz
		cpz #22
		bne :-
		lda #$00
		sta uitxt_samplebox,y

		ldy #4														; feed volume into volume button
		lda (zpptrtmp),y
		sta nbvolume_data+2
		clc															; feed address to original volume location into volume button
		lda zpptrtmp+0
		adc #4
		sta nbvolume_data+4
		lda zpptrtmp+1
		adc #0
		sta nbvolume_data+5

		ldy #5
		lda (zpptrtmp),y
		sta nbfinetune_data+2
		clc
		lda zpptrtmp+0
		adc #5
		sta nbfinetune_data+4
		lda zpptrtmp+1
		adc #0
		sta nbfinetune_data+5

		ldy #6
		lda (zpptrtmp),y
		sta nblength_data+2
		ldy #7
		lda (zpptrtmp),y
		sta nblength_data+3
		clc
		lda zpptrtmp+0
		adc #6
		sta nblength_data+4
		lda zpptrtmp+1
		adc #0
		sta nblength_data+5

		ldy #8
		lda (zpptrtmp),y
		sta nbrepeat_data+2
		ldy #9
		lda (zpptrtmp),y
		sta nbrepeat_data+3
		clc
		lda zpptrtmp+0
		adc #8
		sta nbrepeat_data+4
		lda zpptrtmp+1
		adc #0
		sta nbrepeat_data+5

		ldy #10
		lda (zpptrtmp),y
		sta nbrepeatlen_data+2
		ldy #11
		lda (zpptrtmp),y
		sta nbrepeatlen_data+3
		clc
		lda zpptrtmp+0
		adc #10
		sta nbrepeatlen_data+4
		lda zpptrtmp+1
		adc #0
		sta nbrepeatlen_data+5

		UICORE_CALLELEMENTFUNCTION sampletextbox, uitextbox_draw

		UICORE_CALLELEMENTFUNCTION sampleview1, uisampleview_draw
		UICORE_CALLELEMENTFUNCTION samplescaletrack, uiscaletrack_draw

		UICORE_CALLELEMENTFUNCTION nbfinetune, uicnumericbutton_draw
		UICORE_CALLELEMENTFUNCTION nbvolume, uicnumericbutton_draw
		UICORE_CALLELEMENTFUNCTION nblength, uicnumericbutton_draw
		UICORE_CALLELEMENTFUNCTION nbrepeat, uicnumericbutton_draw
		UICORE_CALLELEMENTFUNCTION nbrepeatlen, uicnumericbutton_draw

		rts

userfunc_openfile
		jsr peppitoStop

		jsr uifilebox_getstringptr									; get filename/dir string

		ldx #$00
		ldy #$03													; skip attributes, file type and length-until-extension
:		lda (zpptrtmp),y
		beq :+
		and #$7f
		sta sdc_transferbuffer,x
		iny
		inx
		bra :-

:		sta sdc_transferbuffer,x

		ldy #$00													; get attribute and check if it's a directory
		lda (zpptrtmp),y
		and #%00010000
		cmp #%00010000
		bne :+

		jsr sdc_chdir
		jsr uifilebox_opendir
		jsr uifilebox_draw
		rts

:		jsr sdc_openfile

		lda #<.loword(moddata)
		sta adrPepMODL+0
		lda #>.loword(moddata)
		sta adrPepMODL+1
		lda #<.hiword(moddata)
		sta adrPepMODH+0
		lda #>.hiword(moddata)
		sta adrPepMODH+1
		jsr peppitoInit

		ldy #$04
		lda #<idxPepPtn0
		sta sequenceview_data+0,y
		lda #>idxPepPtn0
		sta sequenceview_data+1,y

		ldx #$00												; copy loaded filename to filename textbox
:		lda sdc_transferbuffer,x
		beq :+
		tay
		lda ui_textremap,y
		sta uitxt_filenamebox,x
		inx
		bra :-
:		sta uitxt_filenamebox,x
		stx filenametextbox_data+6								; store length of filename

		UICORE_CALLELEMENTFUNCTION filenametextbox, uitextbox_draw

		UICORE_CALLELEMENTFUNCTION la1listbox, uilistbox_startaddentries
		jsr populate_samplelist
		UICORE_CALLELEMENTFUNCTION la1listbox, uilistbox_endaddentries
		UICORE_CALLELEMENTFUNCTION la1listbox, uilistbox_draw

		rts

; ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

populate_samplelist

		ldx #$01

populate_samplelist_loop

		UICORE_CALLELEMENTFUNCTION la1listbox, uilistbox_addentry

		txa												; instrument index
		asl
		tay
		lda idxPepIns0+0,y
		sta zpptr0+0
		lda idxPepIns0+1,y
		sta zpptr0+1

		ldy #00											; get pointer to header in zpptr1
		lda (zpptr0),y
		sta zpptrtmp2+0
		iny
		lda (zpptr0),y
		sta zpptrtmp2+1
		iny
		lda (zpptr0),y
		sta zpptrtmp2+2
		iny
		lda (zpptr0),y
		sta zpptrtmp2+3

		ldz #22											; sample length (word) specified after sample name
		lda [zpptrtmp2],z
		bne :+
		inz
		lda [zpptrtmp2],z
		bne :+
		lda #$00
		bra :++
:		lda #$01
:
		ldy #$00
		sta (zpptrtmp),y
		iny

		ldz #$00
:		lda [zpptrtmp2],z								; sample name is the first thing in the header
		sta (zpptrtmp),y
		iny
		inz
		cpz #22
		bne :-
		lda #$00
		sta (zpptrtmp),y
		iny

		clc												; add length of string to start populating the next line
		tya
		adc zpptrtmp+0
		sta zpptrtmp+0
		lda zpptrtmp+1
		adc #$00
		sta zpptrtmp+1

		inx
		cpx #32
		bne populate_samplelist_loop

		rts

; ----------------------------------------------------------------------------------------------------

populate_samplestate

		lda #<la1boxtxt
		sta zpptr2+0
		lda #>la1boxtxt
		sta zpptr2+1

:		ldy #$00
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1
		cmp #$ff										; bail out if at the end of the list
		bne :+
		bra populate_samplestate_setstates

:		ldy #$00
		lda (zpptrtmp),y
		and #%00000001
		sta (zpptrtmp),y

		clc
		lda zpptr2+0
		adc #$02
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1
		bra :--

populate_samplestate_setstates

		lda #<la1boxtxt
		sta zpptr2+0
		lda #>la1boxtxt
		sta zpptr2+1

		ldx #$00

populate_samplestate_loop

		lda valPepCurrentSamples,x
		sec
		sbc #$01
		bpl :+
		bra populate_samplestate_continue
:		asl
		tay

		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1

		ldy #$00
		lda (zpptrtmp),y
		ora #%00000010
		sta (zpptrtmp),y

populate_samplestate_continue
		inx
		cpx #$04
		bne populate_samplestate_loop

		rts

; ----------------------------------------------------------------------------------------------------
