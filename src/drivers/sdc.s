; ----------------------------------------------------------------------------------------------------

.define sdc_transferbuffer $7000

; ----------------------------------------------------------------------------------------------------

sdc_opendir

		lda #$00
		sta $d640
		nop
		ldz #$00

		lda #$12										; hyppo_opendir - open the current working directory
		sta $d640
		clv
		bcc sdc_opendir_error

		tax												; transfer the directory file descriptor into X
		ldy #>sdc_transferbuffer						; set Y to the MSB of the transfer area

sdcod1	lda #$14										; hyppo_readdir - read the directory entry
		sta $d640
		clv
		bcc sdcod2

		phx
		phy
sdc_processdirentryptr		
		jsr $babe										; call function that handles the retrieved filename
		ply
		plx
		bra sdcod1

sdcod2	cmp #$85										; if the error code in A is $85 we have reached the end of the directory otherwise there’s been an error
		bne sdc_opendir_error
		lda #$16										; close the directory file descriptor in X
		sta $d640
		clv
		bcc sdc_opendir_error
		rts

sdc_opendir_error
		lda #$38
		sta $d640
		clv

:		lda #$06
		sta $d020
		lda #$07
		sta $d020
		jmp :-

; ----------------------------------------------------------------------------------------------------

sdc_chdir

		lda #$00
		sta sdc_transferbuffer,y

		ldy #>sdc_transferbuffer						; set the hyppo filename from transferbuffer
		lda #$2e
		sta $d640
		clv
		bcc :+
		lda #$34										; find the FAT dir entry
		sta $d640
		clv
		bcc :+
		lda #$0c										; chdir into the directory
		sta $d640
		clv
		rts

:		;inc $d020
		;jmp :-
		rts

; ----------------------------------------------------------------------------------------------------
