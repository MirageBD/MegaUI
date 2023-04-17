; ----------------------------------------------------------------------------------------------------

uifilebox_selected_index		.byte 0
uifilebox_startpos				.byte 0
uifilebox_current_draw_pos		.byte 0

; ----------------------------------------------------------------------------------------------------

uifilebox_layout
		jsr uilistbox_layout
		jsr uifilebox_opendir
		rts

uifilebox_hide
		jsr uielement_hide
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
		cmp #KEYBOARD_RETURN											; LV TODO - what if this is already checked for in uilistbox?
		bne uifilebox_keypress_end

		jsr uifilebox_doubleclick

uifilebox_keypress_end
		rts

uifilebox_keyrelease
		jsr uilistbox_keyrelease
		rts

uifilebox_opendir

		; turn off disk access when running in xemu

.if megabuild = 1
.else
		rts
.endif		
		
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

uifilebox_draw
		jsr uilistbox_drawbkgreleased
		jsr uifilebox_drawlistreleased
		rts

uifilebox_press
		jsr uilistbox_press
		rts

uifilebox_doubleclick
		jsr uifilebox_getstringptr									; get filename/dir string

		ldx #$00
		ldy #$02														; skip attributes and file type
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
		sta $cf00
		and #%00010000
		cmp #%00010000
		bne :+

		jsr sdc_chdir
		jsr uifilebox_opendir
		jsr uifilebox_draw
		bra :++

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

:		rts

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
		ldy #$04										; put start of text list into zpptr2
		jsr ui_getelementdata_2

		ldy #$02										; get pointer to scrollbar data
		lda (zpptr1),y
		sta zpptrtmp+0
		iny
		lda (zpptr1),y
		sta zpptrtmp+1

		ldy #$04										; get selection index
		lda (zpptrtmp),y
		asl												; *2
		adc zpptr2+0									; add to text list ptr
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

		clc
		ldy #$00										; put pointer to actual text entry in zpptrtmp
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1
		
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

		; 0 Read only
		; 1 Hidden
		; 2 System
		; 3 Volume label
		; 4 Sub-directory
		; 5 Archive
		; 2 bits free

		ldy #$00
		lda sdc_transferbuffer+$0056						; read attribute and store in first byte
		sta (zpptrtmp),y

		and #%00010000
		cmp #%00010000
		bne :+

		lda #$31											; colour directory differently
		bra :++

:		lda #$0f
:		iny
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

		ldx #$00											; read extension
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

		ldy #$02										; put scrollbar1_data into zpptr2
		jsr ui_getelementdata_2

		ldy #$02										; store startpos
		lda (zpptr2),y
		sta uifilebox_startpos

		ldy #$04
		lda (zpptr2),y
		sta uifilebox_selected_index

		ldy #$04										; put listboxtxt into zpptr2
		jsr ui_getelementdata_2

		clc
		lda uifilebox_startpos
		sta uifilebox_current_draw_pos
		asl
		adc zpptr2+0
		sta zpptr2+0
		lda zpptr2+1
		adc #$00
		sta zpptr2+1

uifilebox_drawlistreleased_loop							; start drawing the list

		ldy #$00
		lda (zpptr2),y
		sta zpptrtmp+0
		iny
		lda (zpptr2),y
		sta zpptrtmp+1

		lda uifilebox_current_draw_pos
		cmp uifilebox_selected_index
		bne :+

		lda #$c0
		sta ufb_font
		bra :++

:		lda #$80
		sta ufb_font

:		ldy #$01
		lda (zpptrtmp),y
		sta ufb_fontcolour

		ldx uidraw_width								; clear line
		ldz #$00
:		lda #$20
		clc
		adc ufb_font
		sta [uidraw_scrptr],z
		lda ufb_fontcolour
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		dex
		bne :-

		lda zpptrtmp+1
		cmp #$ff
		beq :+++

		ldy #$00
		lda (zpptrtmp),y
		and #%00010000
		cmp #%00010000
		bne :+
		jsr uifilebox_drawdirectory
		bra :++

:		jsr uifilebox_drawfile

:		clc												; increase textlist pointer by 2 to go to next entry
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
		beq :+
		jmp uifilebox_drawlistreleased_loop

:		rts

; ----------------------------------------------------------------------------------------------------

uifilebox_drawfile

		ldy #$02										; set to 2 to skip 'file type and attribute bits' and 'extension type'
		ldz #$00
:		lda (zpptrtmp),y
		cmp #$2e
		beq :+
		tax
		lda ui_textremap,x
		beq :++
		clc
		adc ufb_font
		sta [uidraw_scrptr],z
		lda ufb_fontcolour
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		iny
 		bra :-

:		lda #$20										; add spaces until extension
		clc
		adc ufb_font
		sta [uidraw_scrptr],z
		lda ufb_fontcolour
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		cpz #2*10
		bne :-

		iny
:		lda (zpptrtmp),y								; draw extension until end of line
		tax
		lda ui_textremap,x
		beq :+
		clc
		adc ufb_font
		sta [uidraw_scrptr],z
		lda ufb_fontcolour
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		iny
 		bra :-		
		
:		rts

; ----------------------------------------------------------------------------------------------------

uifilebox_drawdirectory

		ldy #$02										; set to 2 to skip 'file type and attribute bits' and 'extension type'
		ldz #$00
:		lda (zpptrtmp),y
		beq :+
		tax
		lda ui_textremap,x
		beq :++
		clc
		adc ufb_font
		sta [uidraw_scrptr],z
		lda ufb_fontcolour
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		iny
 		bra :-

:		rts

; ----------------------------------------------------------------------------------------------------

uifilebox_drawemptyline

		ldy #$02										; set to 2 to skip 'file type and attribute bits' and 'extension type'
		ldz #$00
:		lda #$20
		sta [uidraw_scrptr],z
		lda ufb_fontcolour
		sta [uidraw_colptr],z
		inz
		lda #$04
		sta [uidraw_scrptr],z
		lda #$00
		sta [uidraw_colptr],z
		inz
		iny
		cpy uidraw_height
 		bne :-

		rts

; ----------------------------------------------------------------------------------------------------

ufb_font
		.byte $00	; $00 (white text on coloured background) or $80 (coloured text on black background)

ufb_fontcolour
		.byte $04