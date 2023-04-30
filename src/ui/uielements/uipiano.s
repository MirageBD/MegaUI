; ----------------------------------------------------------------------------------------------------

uipiano_layout
		jsr uielement_layout
		rts

uipiano_hide
		;jsr uielement_hide
		rts

uipiano_focus
		rts

uipiano_enter
		rts

uipiano_longpress
		rts

uipiano_leave
		jsr uielement_leave
		rts

uipiano_move
		lda mouse_held
		beq :+
		jsr uipiano_press
:		rts

uipiano_keypress
		rts

uipiano_keyrelease
		rts

uipiano_doubleclick
		rts

uipiano_release
		jsr uielement_release
	   	rts

uipiano_press
		jsr uimouse_calculate_pos_in_uielement
		jsr ui_getelementdataptr_tmp

		lda uimouse_uielement_xpos+1
		cmp #$ff
		bne :+
		rts

:		jsr uipiano_draw

		rts

; ----------------------------------------------------------------------------------------------------

uipiano_draw

		jsr uidraw_set_draw_position

		jsr uipiano_draw_toprow
		jsr uidraw_increase_row
		jsr uipiano_draw_toprow
		jsr uidraw_increase_row
		jsr uipiano_draw_toprow
		jsr uidraw_increase_row
		jsr uipiano_draw_middlerow
		jsr uidraw_increase_row
		jsr uipiano_draw_bottomrow

		rts

; ----------------------------------------------------------------------------------------------------

uipiano_draw_toprow

		ldx #$00
		ldz #$00
:		lda keys+0,x
		asl
		asl
		ora keys+1,x
		asl
		asl
		ora keys+2,x
		tay
		lda keycombinationstop,y
		sta [uidraw_scrptr],z
		inz
		inz
		inx
		inx
		cpx #4*14
		bne :-
		rts

uipiano_draw_middlerow

		ldx #$00
		ldz #$00
:		lda keys+0,x
		asl
		asl
		ora keys+1,x
		asl
		asl
		ora keys+2,x
		tay
		lda keycombinationmiddle,y
		sta [uidraw_scrptr],z
		inz
		inz
		inx
		inx
		cpx #4*14
		bne :-
		rts

uipiano_draw_bottomrow

		ldx #$00
		ldz #$00
:		lda keys+0,x
		asl
		asl
		ora keys+1,x
		asl
		asl
		ora keys+2,x
		tay
		lda keycombinationbottom,y
		sta [uidraw_scrptr],z
		inz
		inz
		inx
		inx
		cpx #4*14
		bne :-
		rts

; ----------------------------------------------------------------------------------------------------

keyindices
		.repeat 4, I
			.byte I*14+1, I*14+2, I*14+3, I*14+4, I*14+5, I*14+7, I*14+8, I*14+9, I*14+10, I*14+11, I*14+12, I*14+13
		.endrepeat
keys
		.byte 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1 ; 1 = 1 or 2
		.byte 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1 ; 1 = 1 or 2
		.byte 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1 ; 1 = 1 or 2
		.byte 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1 ; 1 = 1 or 2

		;.byte %000101, %000110, %001001, %001010									;      $05, $06,      $09, $0a
		;.byte %010100, %010101, %010110, %011000, %011001, %011010					; $14, $15, $16, $18, $19, $1a
		;.byte %100100, %100101, %100110, %101000, %101001, %101010					; $24, $25, $26, $28, $29, $2a

keycombinationstop
		.byte   0,   0,   0,   0,   0, 160, 161,   0,   0, 162, 163,   0,   0,   0,   0,   0
		.byte   0,   0,   0,   0, 164, 165, 166,   0, 167, 168, 169,   0,   0,   0,   0,   0
		.byte   0,   0,   0,   0, 170, 171, 172,   0, 173, 174, 175,   0,   0,   0,   0,   0

keycombinationmiddle
		.byte   0,   0,   0,   0,   0, 176, 176,   0,   0, 177, 177,   0,   0,   0,   0,   0
		.byte   0,   0,   0,   0, 178, 179, 179,   0, 180, 181, 181,   0,   0,   0,   0,   0
		.byte   0,   0,   0,   0, 178, 179, 179,   0, 180, 181, 181,   0,   0,   0,   0,   0

keycombinationbottom
		.byte   0,   0,   0,   0,   0, 182, 182,   0,   0, 183, 183,   0,   0,   0,   0,   0
		.byte   0,   0,   0,   0, 182, 182, 182,   0, 183, 183, 183,   0,   0,   0,   0,   0
		.byte   0,   0,   0,   0, 182, 182, 182,   0, 183, 183, 183,   0,   0,   0,   0,   0

