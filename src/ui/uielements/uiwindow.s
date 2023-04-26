; ----------------------------------------------------------------------------------------------------

uiwindow_layout
		jsr uielement_layout

		lda #$01								; LV TODO - should all elements be deflated by 1 by default?
		sta uirect_xdeflate
		lda #$01
		sta uirect_ydeflate

		jsr uirect_deflate

		rts

uiwindow_hide
		jsr uielement_hide
		rts

uiwindow_focus
		jsr uielement_focus
		rts

uiwindow_enter
		rts

uiwindow_leave
		rts

uiwindow_draw
		;jsr uielement_draw
		rts

uiwindow_press
		;jsr uielement_draw
		rts

uiwindow_longpress
		rts

uiwindow_doubleclick
		rts

uiwindow_release
		;jsr uielement_draw
		rts

uiwindow_move
		rts

uiwindow_keypress
		rts

uiwindow_keyrelease
		rts		

; ----------------------------------------------------------------------------------------------------
