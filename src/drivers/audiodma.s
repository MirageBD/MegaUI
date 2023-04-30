; ----------------------------------------------------------------------------------------------------

audiodma_channel    .byte $00

; ----------------------------------------------------------------------------------------------------

audiodma_playsample

		lda audiodma_channel
		asl
		asl
		asl
		asl
		tax

audiodma_samplestart1
		lda #<.loword($20000+36568+22084)
		sta $d72a,x										; CHXCURADDRL
audiodma_samplestart2
		lda #>.loword($20000+36568+22084)
		sta $d72b,x										; CHXCURADDRC
audiodma_samplestart3
		lda #<.hiword($20000+36568+22084)
		sta $d72c,x										; CHXCURADDRM

audiodma_sampleend1
		lda #<($20000+36568+22084+28956)
		sta $d727,x										; CHXTADDRL
audiodma_sampleend2
		lda #<($20000+36568+22084+28956)
		sta $d728,x										; CHXTADDRM

		lda audiodma_freql,y
		sta $d724,x										; CHXFREQL    Audio DMA channel X frequency LSB
		lda audiodma_freqm,y
		sta $d725,x										; CHXFREQC    Audio DMA channel X frequency middle byte
		lda audiodma_freqh,y
		sta $d726,x										; CHXFREQM    Audio DMA channel X frequency MSB

audiodma_volume
		lda #$40										; set volume
		sta $d729,x										; CHXVOLUME

		lda #%10010000									; enable audio DMA
		sta $d711										; D711                      AUDEN BLKD AUDWRBLK NOMIX – AUDBLKTO

		lda #%10000010									; play DMA (CHXEN)  with loop enabled (CHXLOOP), 8 bit samples (CHXSBITS) (11=16, 10=8, 01=upper nybl, 00=lower nybl)
		sta $d720,x										; D720      CHXEN CHXLOOP CHXSGN CHXSINE CHXSTP – CHXSBITS

		inc audiodma_channel
		lda audiodma_channel
		and #$03
		sta audiodma_channel

		rts

; ----------------------------------------------------------------------------------------------------

audiodma_freql
.byte <($1ad1)
.byte <($1c69)
.byte <($1e1a)
.byte <($1fe4)
.byte <($21c9)
.byte <($23cc)
.byte <($25ed)
.byte <($282e)
.byte <($2a92)
.byte <($2d1a)
.byte <($2fc8)
.byte <($329f)

.byte <($1ad1)
.byte <($1c69)
.byte <($1e1a)
.byte <($1fe4)
.byte <($21c9)
.byte <($23cc)
.byte <($25ed)
.byte <($282e)
.byte <($2a92)
.byte <($2d1a)
.byte <($2fc8)
.byte <($329f)

.byte <($1ad1)
.byte <($1c69)
.byte <($1e1a)
.byte <($1fe4)
.byte <($21c9)
.byte <($23cc)
.byte <($25ed)
.byte <($282e)
.byte <($2a92)
.byte <($2d1a)
.byte <($2fc8)
.byte <($329f)

audiodma_freqm
.byte >($1ad1)
.byte >($1c69)
.byte >($1e1a)
.byte >($1fe4)
.byte >($21c9)
.byte >($23cc)
.byte >($25ed)
.byte >($282e)
.byte >($2a92)
.byte >($2d1a)
.byte >($2fc8)
.byte >($329f)

.byte >($1ad1)
.byte >($1c69)
.byte >($1e1a)
.byte >($1fe4)
.byte >($21c9)
.byte >($23cc)
.byte >($25ed)
.byte >($282e)
.byte >($2a92)
.byte >($2d1a)
.byte >($2fc8)
.byte >($329f)

.byte >($1ad1)
.byte >($1c69)
.byte >($1e1a)
.byte >($1fe4)
.byte >($21c9)
.byte >($23cc)
.byte >($25ed)
.byte >($282e)
.byte >($2a92)
.byte >($2d1a)
.byte >($2fc8)
.byte >($329f)

audiodma_freqh
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ----------------------------------------------------------------------------------------------------
