.segment "TEXT"

uitxt_button0		.byte "f1 play", 0
uitxt_button1		.byte "f3 stop", 0
uitxt_button2		.byte "f5 pause", 0

uitxt_checkbox		.byte "checkbox", 0
uitxt_radiobutton	.byte "radiobtn", 0

uitxt_paddlex		.byte "$d419", 0
uitxt_paddley		.byte "$d41a", 0

la1boxtxt			.word la1boxtxt00
					.word la1boxtxt00
					.word la1boxtxt00
					.word la1boxtxt00
					.word la1boxtxt00
					.word la1boxtxt00
					.word la1boxtxt00
					.word la1boxtxt00
					.word la1boxtxt08
					.word la1boxtxt09
					.word la1boxtxt10
					.word la1boxtxt11
					.word la1boxtxt12
					.word la1boxtxt13
					.word la1boxtxt14
					.word la1boxtxt15
					.word la1boxtxt16
					.word la1boxtxt17
					.word la1boxtxt18
					.word $ffff

la1boxtxt00			.byte "             ", 0
la1boxtxt01			.byte "             ", 0
la1boxtxt02			.byte "             ", 0
la1boxtxt03			.byte "             ", 0
la1boxtxt04			.byte "             ", 0
la1boxtxt05			.byte "             ", 0
la1boxtxt06			.byte "             ", 0
la1boxtxt07			.byte "             ", 0
la1boxtxt08			.byte "             ", 0
la1boxtxt09			.byte "             ", 0
la1boxtxt10			.byte "             ", 0
la1boxtxt11			.byte "             ", 0
la1boxtxt12			.byte "             ", 0
la1boxtxt13			.byte "             ", 0
la1boxtxt14			.byte "             ", 0
la1boxtxt15			.byte "             ", 0
la1boxtxt16			.byte "             ", 0
la1boxtxt17			.byte "             ", 0
la1boxtxt18			.byte "             ", 0

tvboxtxt
.repeat 64, I
					.word .ident(.sprintf("tvboxtxt%s", .string(I)))
.endrepeat
					.word $ffff

.repeat 64,I
	.ident(.sprintf("tvboxtxt%s", .string(I)))

		.byte $ff, $0f, "... ", $ff, $0f, ".. ", $ff, $0f, ".. ", $ff, $0f, "..."
		.byte "    "
		.byte $ff, $0f, "... ", $ff, $0f, ".. ", $ff, $0f, ".. ", $ff, $0f, "..."
		.byte "    "
		.byte $ff, $0f, "... ", $ff, $0f, ".. ", $ff, $0f, ".. ", $ff, $0f, "..."
		.byte "    "
		.byte $ff, $0f, "... ", $ff, $0f, ".. ", $ff, $0f, ".. ", $ff, $0f, "..."

		.byte 0
.endrepeat

uitxt_textbox1		.byte 0, "                "

.align 256

fa1boxtxt			.word fa1boxtxt00
					.word fa1boxtxt01
					.word fa1boxtxt02
					.word fa1boxtxt03
					.word fa1boxtxt04
					.word fa1boxtxt05
					.word fa1boxtxt06
					.word fa1boxtxt07
					.word fa1boxtxt08
					.word fa1boxtxt09
					.word fa1boxtxt10
					.word fa1boxtxt11
					.word fa1boxtxt12
					.word fa1boxtxt13
					.word fa1boxtxt14
					.word fa1boxtxt15
					.word fa1boxtxt16
					.word fa1boxtxt17
					.word fa1boxtxt18
					.word fa1boxtxt19
					.word $ffff

.align 256			; leave enough room for fa1boxtxt to grow. 128 directory entries allowed

fa1boxtxt00			.byte %00010000, $31, ".",            0
fa1boxtxt01			.byte %00010000, $31, "..",           0
fa1boxtxt02			.byte %00010000, $31, "mods",    0
fa1boxtxt03			.byte %00100000, $0f, "xmas65.d81",   0
fa1boxtxt04			.byte %00100000, $0f, "megaui.d81",   0
fa1boxtxt05			.byte %00100000, $0f, "xmas65.d81",   0
fa1boxtxt06			.byte %00100000, $0f, "alphavil.mod", 0
fa1boxtxt07			.byte %00100000, $0f, "cyberno2.mod", 0
fa1boxtxt08			.byte %00100000, $0f, "impact14.mod", 0
fa1boxtxt09			.byte %00100000, $0f, "spankit.mod",  0
fa1boxtxt10			.byte %00100000, $0f, "testlast.mod", 0
fa1boxtxt11			.byte %00100000, $0f, "spiritmx.mod", 0
fa1boxtxt12			.byte %00100000, $0f, "nuseup42.mod", 0
fa1boxtxt13			.byte %00100000, $0d, "samples.bin",  0
fa1boxtxt14			.byte %00100000, $0d, "glyphs.bin",   0
fa1boxtxt15			.byte %00100000, $0d, "font.bin",     0
fa1boxtxt16			.byte %00100000, $0d, "to.bin",       0
fa1boxtxt17			.byte %00100000, $0d, "cs.bin",       0
fa1boxtxt18			.byte %00100000, $0d, "foo.bin",      0
fa1boxtxt19			.byte %00100000, $0d, "bar.bin",      0
