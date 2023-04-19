; ----------------------------------------------------------------------------------------------------

uigroup_layout
		jsr uielement_layout

		lda #$01
		sta uirect_xdeflate
		lda #$01
		sta uirect_ydeflate

		jsr uirect_deflate

		rts

uigroup_hide
		jsr uielement_hide
		rts

uigroup_focus
		jsr uielement_focus
		rts

uigroup_enter
		jsr uielement_enter
		rts

uigroup_leave
		jsr uielement_leave
		rts

uigroup_draw

		jsr uidraw_set_draw_position

		sec
		ldy #UIELEMENT::width
		lda (zpptr0),y
		;sbc #$02
		sta uidraw_width
		sec
		ldy #UIELEMENT::height
		lda (zpptr0),y
		sbc #$02
		sta uidraw_height

		jsr uidraw_increase_row
		jsr uidraw_increase_row

		ldx uidraw_width

		clc
		ldz #$00
		lda #7*16+8
:		sta [uidraw_scrptr],z
		inz
		inz
		dex
		bne :-

		rts

uigroup_press
		rts

uigroup_doubleclick
		rts

uigroup_release
		rts

uigroup_move
		rts

uigroup_keypress
		rts

uigroup_keyrelease
		rts		

; ----------------------------------------------------------------------------------------------------

; uigroup_update is called from children. I.E. uitab

uigroup_update

		ldy #$02							; read index
		jsr ui_getelementdata_2

		lda zpptr2+0						; LV TODO - feed this into ui_sendqueue
		sta ui_setflagindex
		lda #%00000011
		sta ui_flagtoset
		lda #%00000001
		sta ui_flagtoclear

		lda zpptr0+0						; queue call to set flags
		sta ui_eventqueue_element+0
		lda zpptr0+1
		sta ui_eventqueue_element+1
		lda #<ui_setselectiveflags
		sta ui_eventqueue_function+0
		lda #>ui_setselectiveflags
		sta ui_eventqueue_function+1
		jsr ui_eventqueue_add

		rts

; ----------------------------------------------------------------------------------------------------
