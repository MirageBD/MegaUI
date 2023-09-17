

.define uipal					$c700	; size = $0300
.define spritepal				$ca00
.define sprptrs					$cd00
.define sprites					$ce00
.define kbsprites				$cf00

.define screen					$e000	; size = 80*50*2 = $1f40

.define uichars					$10000	; $10000 - $14000     size = $4000
.define glchars					$14000	; $14000 - $18000     size = $9000
.define samplespritesbuf		$1d000	; $18000 - $18800
.define samplesprites			$1d800	; $18800 - $19000

.define moddata					$19000

; ----------------------------------------------------------------------------------------------------

.segment "FONT"
		.incbin "../bin/font_chars1.bin"

.segment "GLYPHS"
		.incbin "../bin/glyphs_chars1.bin"

.segment "GLYPHSPAL"
		.incbin "../bin/glyphs_pal1.bin"

.segment "CURSORSPRITES"
		.incbin "../bin/cursor_sprites1.bin"

.segment "KBSPRITES"
		.incbin "../bin/kbcursor_sprites1.bin"

.segment "SPRITEPAL"
		.incbin "../bin/cursor_pal1.bin"

.segment "SONG"
		.incbin "../bin/song.mod"

.segment "MAIN"

entry_main

		sei

		lda #$35
		sta $01

		lda #%10000000									; Clear bit 7 - HOTREG
		trb $d05d

		lda #$00										; unmap
		tax
		tay
		taz
		map
		eom

		lda #$41										; enable 40MHz
		sta $00

		lda #$47										; enable C65GS/VIC-IV IO registers
		sta $d02f
		lda #$53
		sta $d02f
		eom

		lda #%10000000									; force PAL mode, because I can't be bothered with fixing it for NTSC
		trb $d06f										; clear bit 7 for PAL ; trb $d06f 
		;tsb $d06f										; set bit 7 for NTSC  ; tsb $d06f

		lda #$05										; enable Super-Extended Attribute Mode by asserting the FCLRHI and CHR16 signals - set bits 2 and 0 of $D054.
		sta $d054

		lda #%10100000									; CLEAR bit7=40 column, bit5=Enable extended attributes and 8 bit colour entries
		trb $d031

		lda #80											; set to 80 for etherload
		sta $d05e

		lda #$02
		sta $d020
		lda #$10
		sta $d021

		lda #<.loword(moddata)
		sta adrPepMODL+0
		lda #>.loword(moddata)
		sta adrPepMODL+1
		lda #<.hiword(moddata)
		sta adrPepMODH+0
		lda #>.hiword(moddata)
		sta adrPepMODH+1

		jsr peppitoInit

		jsr mouse_init									; initialise drivers
		jsr joystick_init

		;UICORE_HIDEELEMENT ui_sequenceview				; turn parts of the UI off as a test
		;UICORE_HIDEELEMENT ui_patternview				; turn parts of the UI off as a test

		;UICORE_HIDEELEMENT ui_tab2
		;UICORE_HIDEELEMENT ui_tab3

		jsr ui_init										; initialise UI
		jsr ui_setup

		; fill listbox with samples
		UICORE_CALLELEMENTFUNCTION la1listbox, uilistbox_startaddentries
		jsr populate_samplelist
		UICORE_CALLELEMENTFUNCTION la1listbox, uilistbox_endaddentries
		UICORE_CALLELEMENTFUNCTION la1listbox, uilistbox_draw

		lda #$7f										; disable CIA interrupts
		sta $dc0d
		sta $dd0d
		lda $dc0d
		lda $dd0d

		lda #$00										; disable IRQ raster interrupts because C65 uses raster interrupts in the ROM
		sta $d01a

		lda #$ff										; setup IRQ interrupt
		sta $d012
		lda #<irq1
		sta $fffe
		lda #>irq1
		sta $ffff

		lda #$01										; ACK
		sta $d01a

		cli
		
loop

		lda valPepPlaying
		beq loop

		;UICORE_CALLELEMENTFUNCTION chanview1, uichannelview_capturevu
		;UICORE_CALLELEMENTFUNCTION chanview2, uichannelview_capturevu
		;UICORE_CALLELEMENTFUNCTION chanview3, uichannelview_capturevu
		;UICORE_CALLELEMENTFUNCTION chanview4, uichannelview_capturevu

		jmp loop

; ----------------------------------------------------------------------------------------------------

irq1
		php
		pha
		phx
		phy
		phz

		lda valPepPlaying
		beq :+
		jsr peppitoPlay
:
		;lda #$08
		;sta $d020
		jsr ui_update
		jsr ui_user_update
		;lda #$00
		;sta $d020


.if megabuild = 1
		lda #$ff
.else
		lda #$00
.endif
		sta $d012
		lda #<irq1
		sta $fffe
		lda #>irq1
		sta $ffff
		;lda #$97
		;sta $d012
		;lda #<irq2
		;sta $fffe
		;lda #>irq2
		;sta $ffff

		plz
		ply
		plx
		pla
		plp
		asl $d019
		rti

irq2
		php
		pha
		phx
		phy
		phz

		lda #$01
		sta $d012
		lda #<irq1
		sta $fffe
		lda #>irq1
		sta $ffff

		plz
		ply
		plx
		pla
		plp
		asl $d019
		rti

; ----------------------------------------------------------------------------------------------------