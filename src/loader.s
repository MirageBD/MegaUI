loader

.org $0400

FileNamePtr			= $f0
BufferPtr			= $f2
NextTrack			= $f4
NextSector			= $f5
PotentialTrack		= $f6
PotentialSector		= $f7
SectorHalf			= $f8

; -----------------

SetLoadAddress
		sta DMACopyToDest+0
		stx DMACopyToDest+1
		sty ory+1
		lda DMACopyToDest+2
		and #$f0
ory		ora #$ef
		sta DMACopyToDest+2
mbank	lda #$ef
		sta DMACopyToDestination+4
		rts

; -----------------

LoadFile
		stx FileNamePtr
		sty FileNamePtr+1

		ldx #40											; first get directory listing track/sector
		ldy #0
		jsr ReadBufferedSector							; read buffered sector to $ffd6c00
		bcs FileNotFoundError

		jsr CopyToBuffer								; read first directory
		ldx filebuffer									; track, first byte of directory entry
		ldy filebuffer+1								; sector, second byte of directory entry

NextDirectoryPage
		jsr FetchNext
		jsr CopyToBuffer

		ldy #$00										; get first entry pointer to next track/sector
		ldx #$00										; store for beginning of entry
LoopEntry
		lda (BufferPtr),y
		beq :+											; dont store next track if 0
		sta NextTrack
:		iny
		lda (BufferPtr),y
		beq :+											; dont store next sector if 0
		sta NextSector
:		iny

		lda (BufferPtr),y								; filetype
		iny

		lda (BufferPtr),y								; get this entries track/sector info
		beq FileNotFoundError							; track 00 implies no file here
		sta PotentialTrack
		iny

		lda (BufferPtr),y
		sta PotentialSector
		iny

		ldz #$00
FilenameLoop
		lda (BufferPtr),y
		cmp #$a0										; reached the end of 16 characters and terminating string is $a0, so file found
		beq FileFound
		cmp (FileNamePtr),z
		bne NextEntry									; filename not same, get next
		iny
		inz
		cpz #$10										; compare 16 characters
		bne FilenameLoop

FileFound
		txa
		clc
		adc #$1e
		tay

		lda PotentialTrack								; if a match set track/sector
		sta NextTrack
		lda PotentialSector
		sta NextSector
		jmp FetchFile

NextEntry
		txa												; advance $20 bytes to next entry
		clc
		adc #$20
		tax
		tay
		bcc LoopEntry
														; if crossing page is it still in the sector buffer?
		jsr AdvanceSectorPtr							; returns 0 if we need to fetch next sector buffer
		bne LoopEntry

		ldx #<NextTrack									; otherwise we need to fetch new sector buffer
		ldy #<NextSector
		jmp NextDirectoryPage

FileNotFoundError										; fall through into Floppy error below
		lda #$0a
		sta $d021
		jmp FloppyExit

FloppyError
		lda #$02
		sta $d021
		jmp FloppyExit

FloppyExit
		lda #$00
		sta $d080
		rts

FetchFile
LoopFetchNext
		ldx NextTrack
		ldy NextSector
		jsr FetchNext
		jsr CopyToBuffer

LoopFileRead
		ldy #$00
		lda (BufferPtr),y
		sta NextTrack
		tax
		iny
		lda (BufferPtr),y
		sta NextSector
		taz
		dez
		iny
		lda #$fe
		cpx #$00
		bne :+
		tza
:		sta DMACopyToDestLength
		jsr CopyFileToPosition
		lda NextTrack
		beq FloppyDone

		clc												; increase dest
		lda DMACopyToDest+0
		adc #$fe
		sta DMACopyToDest+0
		bcc :+
		inc DMACopyToDest+1
		bne :+
		inc DMACopyToDest+2
:		jsr AdvanceSectorPtr
		bne LoopFileRead

		jmp LoopFetchNext								; otherwise we need to fetch new sector buffer

FloppyDone
		bra FloppyExit

CopyFileToPosition
		lda #$02
		clc
		adc SectorHalf
		sta DMACopyToDestSource+1

		lda #$00										; execute DMA job
		sta $d702
		sta $d704
		lda #>DMACopyToDestination
		sta $d701
		lda #<DMACopyToDestination
		sta $d705
		rts

AdvanceSectorPtr										; returns 0 if we need to fetch next sector buffer
		inc BufferPtr+1
		lda SectorHalf
		eor #$01
		sta SectorHalf
		rts

FetchNext												; reads next sector, sets carry if an error occurs
		jsr ReadBufferedSector
		bcc :+

		pla												; abort if the sector read failed
		pla												; break out of the parent method
:		rts

ReadBufferedSector										; x = track (1 to 80), y = sector (0 to 39)
		lda #$60										; motor and LED on
		sta $d080

		lda #$20										; write SPINUP command
		sta $d801

														; can do some other stuff while the drive is spinning up
		dex												; tracks begin at 0 not 1
		stx $d084

		tya												; convert sector
		lsr												; carry indicates we need second half of sector
		tay

		iny												; sectors begin at 1, not 0
		sty $d085
		lda #$00
		sta $d086

		adc #$00										; apply carry to select sector
		sta SectorHalf

		lda #$41										; read sector
		sta $d081

:		lda $d082										; waitForBusy
		bmi :-

		lda $d082										; check for read error
		and #$18
		beq :+

		sec												; abort if the sector read failed
:		rts

CopyToBuffer
		jsr CopySector
		ldx #<filebuffer
		stx BufferPtr+0
		lda #>filebuffer
		adc SectorHalf
		sta BufferPtr+1
		rts

CopySector
		lda #$80										; set pointer to buffer. Select FDC buffer
		trb $d689

		lda #$00										; execute DMA job
		sta $d702										; dma list is in bank 0
		sta $d704										; dma list is in bank 0
		lda #>DMACopyBuffer
		sta $d701
		lda #<DMACopyBuffer
		sta $d705
		rts

; ----------------------------------------------------------------------------------------------------

DMACopyToDestination									; DMA Job to copy from buffer at $200-$3FF to destination
		.byte $0a										; use 11 byte F011A DMA list format
		.byte $80,$00									; $80 = Bank Source address bits 20 – 27
		.byte $81,$00									; $81 = Bank Destination address bits 20 – 27
		.byte $00										; no more options

		.byte 0											; command low byte: COPY + last request in chain
DMACopyToDestLength
		.word $00fe										; size of copy
DMACopyToDestSource
		.word filebuffer+2								; starting at
		.byte $00										; of bank
DMACopyToDest
		.word $0800										; destination addr
		.byte $00										; of bank
		.byte 0											; command high byte
		.byte 0											; no modulo / chain

; ----------------------------------------------------------------------------------------------------

DMACopyBuffer											; DMA Job to copy 512 bytes from sector buffer at $FFD6C00 to temp buffer at $200-$3ff
		.byte $0a										; use 11 byte F011A DMA list format
		.byte $80,$ff									; $80 = Bank Source address bits 20 – 27			source      MB is $FFxxxxx
		.byte $81,$00									; $81 = Bank Destination address bits 20 – 27		destination MB is $00xxxxx
		.byte $00										; no more options

		.byte 0											; command low byte: COPY + last request in chain
		.word $0200										; count: $0200 bytes
		.word $6c00										; starting at
		.byte $0d										; of bank
		.word filebuffer								; destination addr
		.byte $00										; of bank
		.byte 0											; command high byte
		.byte 0											; no modulo / chain

; ----------------------------------------------------------------------------------------------------
