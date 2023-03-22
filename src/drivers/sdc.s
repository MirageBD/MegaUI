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
pde1	sta listboxtxt00,x					; temp - copy to where listbox entries are
		inx
		cpx #$10
		bne :-

		clc
		lda pde1+1
		adc #$10
		sta pde1+1

		rts

; ----------------------------------------------------------------------------------------------------
