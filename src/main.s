
.define uipal					$b800	; size = $0300

.define screen					$e000	; size = 80*50*2 = $1f40

.define sprptrs					$c000
.define sprites					$c100
.define kbsprites				$c300
.define spritepal				$c800
.define emptychar				$cf80	; size = 64

.define uichars					$10000	; $10000 - $14000     size = $4000
.define glchars					$14000	; $14000 - $1d000     size = $9000
.define samplespritesbuf		$1d000	; $1d000 - $1d800
.define samplesprites			$1d800	; $1d000 - $1d800


.define moddata					$20000

; ----------------------------------------------------------------------------------------------------

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

		lda #$47										; enable C65GS/VIC-IV IO registers
		sta $d02f
		lda #$53
		sta $d02f
		eom

		lda #%10000000									; force PAL mode, because I can't be bothered with fixing it for NTSC
		trb $d06f										; clear bit 7 for PAL ; trb $d06f 
		;tsb $d06f										; set bit 7 for NTSC  ; tsb $d06f

		lda #$41										; enable 40MHz
		sta $00

		lda #$70										; Disable C65 rom protection using hypervisor trap (see mega65 manual)
		sta $d640
		eom

		lda #%11111000									; unmap c65 roms $d030 by clearing bits 3-7
		trb $d030

		lda #$05										; enable Super-Extended Attribute Mode by asserting the FCLRHI and CHR16 signals - set bits 2 and 0 of $D054.
		sta $d054

		lda #%10100000									; CLEAR bit7=40 column, bit5=Enable extended attributes and 8 bit colour entries
		trb $d031

		lda #40*2										; logical chars per row
		sta $d058
		lda #$00
		sta $d059

		ldx #$00
		lda #$00
:		sta emptychar,x
		inx
		cpx #64
		bne :-

		ldx #$00
:		lda #<(emptychar/64)
		sta screen+0*$0100+0,x
		sta screen+1*$0100+0,x
		sta screen+2*$0100+0,x
		sta screen+3*$0100+0,x
		sta screen+4*$0100+0,x
		sta screen+5*$0100+0,x
		sta screen+6*$0100+0,x
		sta screen+7*$0100+0,x
		lda #>(emptychar/64)
		sta screen+0*$0100+1,x
		sta screen+1*$0100+1,x
		sta screen+2*$0100+1,x
		sta screen+3*$0100+1,x
		sta screen+4*$0100+1,x
		sta screen+5*$0100+1,x
		sta screen+6*$0100+1,x
		sta screen+7*$0100+1,x
		inx
		inx
		bne :-

		DMA_RUN_JOB clearcolorramjob

		lda #<screen									; set pointer to screen ram
		sta $d060
		lda #>screen
		sta $d061
		lda #(screen & $ff0000) >> 16
		sta $d062
		lda #$00
		sta $d063

		lda #<$0800										; set (offset!) pointer to colour ram
		sta $d064
		lda #>$0800
		sta $d065

		lda #$7f										; disable CIA interrupts
		sta $dc0d
		sta $dd0d
		lda $dc0d
		lda $dd0d

		lda #$00										; disable IRQ raster interrupts because C65 uses raster interrupts in the ROM
		sta $d01a

		lda #$00
		sta $d012
		lda #<fastload_irq_handler
		sta $fffe
		lda #>fastload_irq_handler
		sta $ffff

		lda #$01										; ACK
		sta $d01a

		cli

		jsr fl_init
		jsr fl_waiting
		FLOPPY_FAST_LOAD uichars,			$30, $30
		FLOPPY_FAST_LOAD glchars,			$30, $31
		FLOPPY_FAST_LOAD uipal,				$30, $32
		FLOPPY_FAST_LOAD sprites,			$30, $33
		FLOPPY_FAST_LOAD kbsprites,			$30, $34
		FLOPPY_FAST_LOAD spritepal,			$30, $35
		FLOPPY_FAST_LOAD moddata,			$30, $36
		jsr fl_exit

		sei

		lda #$35
		sta $01

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

populate_samplelist

		ldx #$01

populate_samplelist_loop

		UICORE_CALLELEMENTFUNCTION la1listbox, uilistbox_addentry

		txa												; instrument index
		asl
		tay
		lda idxPepIns0+0,y
		sta zpptr0+0
		lda idxPepIns0+1,y
		sta zpptr0+1

		ldy #00											; get pointer to header in zpptr1
		lda (zpptr0),y
		sta zpptrtmp2+0
		iny
		lda (zpptr0),y
		sta zpptrtmp2+1
		iny
		lda (zpptr0),y
		sta zpptrtmp2+2
		iny
		lda (zpptr0),y
		sta zpptrtmp2+3

		ldz #$00
		ldy #$00
:		lda [zpptrtmp2],z
		sta (zpptrtmp),y
		iny
		inz
		cpz #22
		bne :-
		lda #$00
		sta (zpptrtmp),y
		iny

		clc												; add length of string to start populating the next line
		tya
		adc zpptrtmp+0
		sta zpptrtmp+0
		lda zpptrtmp+1
		adc #$00
		sta zpptrtmp+1

		inx
		cpx #32
		bne populate_samplelist_loop

		rts

; ----------------------------------------------------------------------------------------------------
