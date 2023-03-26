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

		jsr uifilebox_getstringptr									; get 
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

uifilebox_keypress_end
		rts

uifilebox_opendir
		rts

		jsr uifilebox_startaddentries

		lda #<uifilebox_processdirentry
		sta sdc_processdirentryptr+1
		lda #>uifilebox_processdirentry
		sta sdc_processdirentryptr+2

		jsr sdc_opendir
		
		jsr uifilebox_endaddentries
		rts

uifilebox_keyrelease
		jsr uilistbox_keyrelease
		rts
		
uifilebox_draw
		jsr uilistbox_draw
		rts

uifilebox_press
		jsr uilistbox_press
		rts

uifilebox_release
		jsr uilistbox_release
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

uifilebox_processdirentry

		clc												; increase number of entries
		ldy #$02
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

		ldy #$00											; read until 0
:		lda sdc_transferbuffer,y
		beq :+
		sta (zpptrtmp),y
		iny
		bra :-

:		sta (zpptrtmp),y									; add length of text to pointer
		iny
		tya
		clc
		adc zpptrtmp+0
		sta zpptrtmp+0
		lda zpptrtmp+1
		adc #$00
		sta zpptrtmp+1

		rts

; ----------------------------------------------------------------------------------------------------

