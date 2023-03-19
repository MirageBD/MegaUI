

sdc_doesdrive2exist
	
		; Preserve the current drive so we can restore it later
		lda #$04
		sta $d640
		clv
		bcc sdc_error
		pha

		; Try to select drive 2
		ldx #2
		lda #$06
		sta $d640
		clv
		bcc sdcdd2e1

		; Restore the previously selected drive
		plx
		lda #$06
		sta $d640
		clv
		bcc sdc_error

		; The C flag was already set by the Hyppo service
		rts

sdcdd2e1
		; If the error code in A is $80, the drive doesn’t exist; otherwise some other kind of error occurred
		cmp #$80
		bne sdc_error
		; Forget about the current drive we preserved because it wasn’t changed
		plx
		; Clear the C flag because the drive doesn’t exist
		clc
		rts

sdc_error

	inc $d020
	jmp sdc_error

; ----------------------------------------------------------------------------------------------------

sdc_selectdrive2
		ldx #01
		lda #$06
		sta $d640
		clv
		rts

; ----------------------------------------------------------------------------------------------------

sdc_opendir
		lda #$00
		sta $d640
		nop
		ldz #$00

		; Open the current working directory
		lda #$12
		sta $d640
		clv
		bcc sdc_opendir_error

		; Transfer the directory file descriptor into X
		tax
		; Set Y to the MSB of the transfer area
		ldy #$70; #>$cf00
sdcod1
		; Read the directory entry
		lda #$14
		sta $d640
		clv
		bcc sdcod2

		; Call processdirentry (assumed to be defined elsewhere)
		phx
		phy
		jsr processdirentry
		ply
		plx
		bra sdcod1

sdcod2
		; If the error code in A is $85 we have reached the end of the directory otherwise there’s been an error
		cmp #$85
		bne sdc_opendir_error
		; Close the directory file descriptor in X
		lda #$16
		sta $d640
		clv
		bcc sdc_opendir_error
		rts

sdc_opendir_error
		lda #$38
		sta $d640
		clv
		sta $cfff

:		lda #$06
		sta $d020
		lda #$07
		sta $d020
		jmp :-

; ----------------------------------------------------------------------------------------------------

processdirentry
		ldx #$00
:		lda $7000,x
pde1	sta $4701,x
		inx
		cpx #$10
		bne :-

		clc
		lda pde1+1
		adc #$10
		sta pde1+1

		rts

; ----------------------------------------------------------------------------------------------------
