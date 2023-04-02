; ----------------------------------------------------------------------------------------------------

uifilebox_selected_index		.byte 0
uifilebox_startpos				.byte 0
uifilebox_current_draw_pos		.byte 0

; ----------------------------------------------------------------------------------------------------

uifilebox_layout
		jsr uilistbox_layout
		jsr uifilebox_opendir
		rts

uifilebox_focus
		jsr uilistbox_focus
		rts

uifilebox_enter
		jsr uilistbox_enter
		rts

uifilebox_leave
		jsr uilistbox_leave
		rts

uifilebox_move
		jsr uilistbox_move
		rts

uifilebox_keypress
		jsr uilistbox_keypress

		lda keyboard_pressedeventarg
		cmp KEYBOARD_RETURN											; LV TODO - what if this is already checked for in uilistbox?
		bne uifilebox_keypress_end

		jsr uifilebox_doubleclick

uifilebox_keypress_end
		rts

uifilebox_opendir
		rts
		
		jsr uifilebox_startaddentries

		; handle directories first
		lda #<uifilebox_processdirentry_directory
		sta sdc_processdirentryptr+1
		lda #>uifilebox_processdirentry_directory
		sta sdc_processdirentryptr+2

		jsr sdc_opendir

		; then handle regular files

		lda #<uifilebox_processdirentry_file
		sta sdc_processdirentryptr+1
		lda #>uifilebox_processdirentry_file
		sta sdc_processdirentryptr+2

		jsr sdc_opendir

		jsr uifilebox_endaddentries
		rts

uifilebox_keyrelease
		jsr uilistbox_keyrelease
		rts
		
uifilebox_draw
		jsr uilistbox_drawbkgreleased
		jsr uifilebox_drawlistreleased
		rts

uifilebox_press
		jsr uilistbox_press
		rts

uifilebox_doubleclick
		jsr uifilebox_getstringptr									; get filename/dir string
		ldy #0
:		lda (zpptrtmp),y
		beq :+
		and #$7f
		sta sdc_transferbuffer,y
		iny
		bra :-
:		sta sdc_transferbuffer,y
		jsr sdc_chdir
		jsr uifilebox_opendir
		jsr uifilebox_draw
		rts

uifilebox_release
		jsr uilistbox_setselectedindex
		jsr uifilebox_draw
		rts

; ----------------------------------------------------------------------------------------------------

uifilebox_startaddentries
		jsr uilistbox_startaddentries
		rts

uifilebox_endaddentries
		jsr uilistbox_endaddentries
		rts

uifilebox_getstringptr
		jsr uilistbox_getstringptr
		rts

uifilebox_increase_selection
		jsr uilistbox_increase_selection
		rts

uifilebox_decrease_selection
		jsr uilistbox_decrease_selection
		rts

uifilebox_confine
		jsr uilistbox_confine
		rts

; ----------------------------------------------------------------------------------------------------

uifilebox_processdirentry_file

		lda sdc_transferbuffer+$0056
		and #%00010000
		cmp #%00010000
		beq :+												; if it's a directoy then skip
		jmp uifilebox_processdirentry
:		rts		

uifilebox_processdirentry_directory

		lda sdc_transferbuffer+$0056
		and #%00010000
		cmp #%00010000
		bne :+												; if it's not a directoy then skip
		jmp uifilebox_processdirentry
:		rts		

; ----------------------------------------------------------------------------------------------------

uifilebox_processdirentry

		clc													; increase number of entries
		ldy #$06
		lda (zpptr3),y
		adc #$01
		sta (zpptr3),y

		ldy #$00											; set list pointer to text
		lda zpptrtmp+0
		sta (zpptr2),y
		iny
		lda zpptrtmp+1
		sta (zpptr2),y

		clc													; add 2 to move to next list ptr entry
		lda zpptr2+0
		adc #$02
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

		ldy #$00

		lda sdc_transferbuffer+$0056,x
		sta (zpptrtmp),y
		iny

		ldx #$00
:		lda sdc_transferbuffer+$0041,x
		cmp #$20
		beq :+
		sta (zpptrtmp),y
		iny
		inx
		cpx #$08
		bne :-

:		lda sdc_transferbuffer+$0041+8						; read extension. if it's a space then don't add dot or extension
		cmp #$20
		beq :++

		lda #$2e											; add dot
		sta (zpptrtmp),y
		iny

		ldx #$00
:		lda sdc_transferbuffer+$0041+8,x
		sta (zpptrtmp),y
		iny
		inx
		cpx #$03
		bne :-

:		lda #$00											; add 0 string terminator
		sta (zpptrtmp),y
		iny

		clc
		tya
		adc zpptrtmp+0
		sta zpptrtmp+0
		lda zpptrtmp+1
		adc #$00
		sta zpptrtmp+1

		rts

; ----------------------------------------------------------------------------------------------------

uifilebox_drawlistreleased

		jsr uidraw_set_draw_position

		jsr ui_getelementdataptr_1						; get data ptr to zpptr1

		ldy #$02										; put scrollbar1_data into zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		ldy #$02										; store startpos
		lda (zpptr2),y
		sta uifilebox_startpos

		ldy #$04
		lda (zpptr2),y
		sta uifilebox_selected_index

		ldy #$04										; put listboxtxt into zpptr2
		lda (zpptr1),y
		sta zpptr2+0
		iny
		lda (zpptr1),y
		sta zpptr2+1

		clc
		ldy #$00
		lda uifilebox_startpos
		sta uifilebox_current_draw_pos
		asl
		adc zpptr2+0
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

uifilebox_drawlistreleased_loop							; start drawing the list

		lda uifilebox_current_draw_pos
		cmp uifilebox_selected_index
		bne :++

		ldx uidraw_width
		ldz #$00
:		lda #$f0 ; dark blue
		sta [uidraw_colptr],z
		inz
		inz
		dex
		bne :-

:		ldx uidraw_width								; clear line
		ldz #$00
:		lda #$60
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz
		dex
		bne :-

		ldy #$00
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1
		cmp #$ff
		beq :+++

		ldy #$01										; set to 1 to skip file type and attribute bits
		ldz #$00
:		lda (zpptrtmp),y
		tax
		lda ui_textremap,x
		beq :+
		sta [uidraw_scrptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		inz
		iny
 		bra :-

:		clc
		lda zpptr2+0
		adc #$02
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

:		jsr uidraw_increase_row
		inc uifilebox_current_draw_pos

		dec uidraw_height
		lda uidraw_height
		bne uifilebox_drawlistreleased_loop

		rts

; ----------------------------------------------------------------------------------------------------
