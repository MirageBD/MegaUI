; ----------------------------------------------------------------------------------------------------

uiwindow_layout
		jsr uielement_layout
		rts

uiwindow_focus
		jsr uielement_focus
		rts

uiwindow_enter
		jsr uielement_enter
		rts

uiwindow_leave
		jsr uielement_leave
		rts

uiwindow_draw
		jsr uielement_draw
		rts

uiwindow_press
		jsr uielement_draw
		rts

uiwindow_doubleclick
		rts

uiwindow_release
		jsr uielement_draw
		rts

uiwindow_move
		rts

uiwindow_keypress
		rts

uiwindow_keyrelease
		rts		

; ----------------------------------------------------------------------------------------------------
