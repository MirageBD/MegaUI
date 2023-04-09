.align 256

uitxt_button0		.byte "play", 0
uitxt_button1		.byte "stop", 0
uitxt_button2		.byte "pause", 0

uitxt_checkbox		.byte "checkbox", 0
uitxt_radiobutton	.byte "radiobtn", 0

uitxt_paddlex		.byte "$d419", 0
uitxt_paddley		.byte "$d41a", 0

.align 256

la1boxtxt			.word la1boxtxt00
					.word la1boxtxt01
					.word la1boxtxt02
					.word la1boxtxt03
					.word la1boxtxt04
					.word la1boxtxt05
					.word la1boxtxt06
					.word la1boxtxt07
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

.align 256

la1boxtxt00			.byte "Lorem ipsum  ", 0
la1boxtxt01			.byte "dolor sit    ", 0
la1boxtxt02			.byte "amet, consec-", 0
la1boxtxt03			.byte "tetur adipis-", 0
la1boxtxt04			.byte "cing elit.   ", 0
la1boxtxt05			.byte "Integer a    ", 0
la1boxtxt06			.byte "ligula sed   ", 0
la1boxtxt07			.byte "velit aliquet", 0
la1boxtxt08			.byte "iaculis.     ", 0
la1boxtxt09			.byte "Vestibulum et", 0
la1boxtxt10			.byte "mauris tellus", 0
la1boxtxt11			.byte "Aliquam com- ", 0
la1boxtxt12			.byte "modo, neque  ", 0
la1boxtxt13			.byte "et vulputate ", 0
la1boxtxt14			.byte "viverra, quam", 0
la1boxtxt15			.byte "mauris rhon- ", 0
la1boxtxt16			.byte "cus ante, in ", 0
la1boxtxt17			.byte "sagittis ante", 0
la1boxtxt18			.byte "nibh ut mi.  ", 0

.align 256

tvboxtxt
.repeat 64, I
					.word .ident(.sprintf("tvboxtxt%s", .string(I)))
.endrepeat
					.word $ffff

.align 256

.repeat 64,I
	.ident(.sprintf("tvboxtxt%s", .string(I)))

		.byte $ff, $e0, "... ", $ff, $e0, ".. ", $ff, $e0, ".. ", $ff, $e0, "..."
		.byte "    "
		.byte $ff, $e0, "... ", $ff, $e0, ".. ", $ff, $e0, ".. ", $ff, $e0, "..."
		.byte "    "
		.byte $ff, $e0, "... ", $ff, $e0, ".. ", $ff, $e0, ".. ", $ff, $e0, "..."
		.byte "    "
		.byte $ff, $e0, "... ", $ff, $e0, ".. ", $ff, $e0, ".. ", $ff, $e0, "..."

		.byte 0
.endrepeat


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

.align 256
fa1boxtxt00			.byte %00010000, $c0, ".", 0
fa1boxtxt01			.byte %00010000, $c0, "..", 0
fa1boxtxt02			.byte %00010000, $c0, "directory", 0
fa1boxtxt03			.byte %00100000, $31, "xmas65.d81", 0
fa1boxtxt04			.byte %00100000, $31, "megaui.d81", 0
fa1boxtxt05			.byte %00100000, $31, "xmas65.d81", 0
fa1boxtxt06			.byte %00000000, $3d, "alphavil.mod", 0
fa1boxtxt07			.byte %00000000, $3d, "cyberno2.mod", 0
fa1boxtxt08			.byte %00000000, $3d, "impact14.mod", 0
fa1boxtxt09			.byte %00000000, $3d, "spankit.mod", 0
fa1boxtxt10			.byte %00000000, $3d, "testlast.mod", 0
fa1boxtxt11			.byte %00000000, $3d, "spiritmx.mod", 0
fa1boxtxt12			.byte %00000000, $3d, "nuseup42.mod", 0
fa1boxtxt13			.byte %00100000, $0d, "samples.bin", 0
fa1boxtxt14			.byte %00100000, $0d, "glyphs.bin", 0
fa1boxtxt15			.byte %00100000, $0d, "font.bin", 0
fa1boxtxt16			.byte %00100000, $0d, "to.bin", 0
fa1boxtxt17			.byte %00100000, $0d, "cs.bin", 0
fa1boxtxt18			.byte %00100000, $0d, "foo.bin", 0
fa1boxtxt19			.byte %00100000, $0d, "bar.bin", 0
