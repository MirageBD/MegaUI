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
		lda #<.loword($babe)
		sta $d72a,x										; CHXCURADDRL
audiodma_samplestart2
		lda #>.loword($babe)
		sta $d72b,x										; CHXCURADDRC
audiodma_samplestart3
		lda #<.hiword($babe)
		sta $d72c,x										; CHXCURADDRM

audiodma_sampleend1
		lda #<($babe)
		sta $d727,x										; CHXTADDRL
audiodma_sampleend2
		lda #<($babe)
		sta $d728,x										; CHXTADDRM

		tya
		clc
		adc #1*12										; add 2 octaves to start at C-1
		tay

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





; -------------------------------------------------------------------------
; Motorola 68000 clocked at:
;     PAL:  7.09 MHz = 7093789.2 Hz
;     NTSC: 7.16 Mhz = 7159090.5 Hz

; Here are the magic formulas:

;               7093789.2 Hz
; SampleRate = --------------    (For a PAL machine)
;                Period * 2

;               7159090.5 Hz
; SampleRate = --------------    (For an NTSC machine)
;                Period * 2

; So, the most normal rate is (C-3, period 214):

;   7093789.2 Hz
;  -------------- = 16574.27 Hz     (For a PAL machine)
;     214 * 2

;   7159090.5 Hz
;  -------------- = 16726.85 Hz     (For an NTSC machine)
;     214 * 2
; -------------------------------------------------------------------------



; Start with 16574.27 Hz (amiga PAL normal rate for C-3, period 214)

; 16574.27*2^24 / 40.5M = 6866 for period = 214

; for c-3 (130.81Hz)
;	(16574.27 * 2^24     / 40500000) / 130.81Hz = 52.487795951780029653790579305958
;	(16574.27 * 16777216 / 40500000) / 130.81Hz = 52.487795951780029653790579305958




; https://pages.mtu.edu/~suits/notefreqs.html

audiodma_freql
.byte <.loword($00035A)				; C-0
.byte <.loword($00038D)
.byte <.loword($0003C3)
.byte <.loword($0003FC)
.byte <.loword($000439)
.byte <.loword($000479)
.byte <.loword($0004BD)
.byte <.loword($000505)
.byte <.loword($000552)
.byte <.loword($0005A3)
.byte <.loword($0005F9)
.byte <.loword($000654)

.byte <.loword($0006B4)				; C-1
.byte <.loword($00071A)
.byte <.loword($000786)
.byte <.loword($0007F9)
.byte <.loword($000872)
.byte <.loword($0008F3)
.byte <.loword($00097B)
.byte <.loword($000A0B)
.byte <.loword($000AA4)
.byte <.loword($000B46)
.byte <.loword($000BF2)
.byte <.loword($000CA8)

.byte <.loword($000D69)				; C-2
.byte <.loword($000E35)
.byte <.loword($000F0D)
.byte <.loword($000FF2)
.byte <.loword($0010E5)
.byte <.loword($0011E6)
.byte <.loword($0012F7)
.byte <.loword($001417)
.byte <.loword($001549)
.byte <.loword($00168D)
.byte <.loword($0017E4)
.byte <.loword($001950)

.byte <.loword($001AD1)				; C-3
.byte <.loword($001C6A)
.byte <.loword($001E1A)
.byte <.loword($001FE5)
.byte <.loword($0021CA)
.byte <.loword($0023CC)
.byte <.loword($0025EE)
.byte <.loword($00282F)
.byte <.loword($002A93)
.byte <.loword($002D1B)
.byte <.loword($002FC9)
.byte <.loword($0032A1)

.byte <.loword($0035A4)				; C-4
.byte <.loword($0038D4)
.byte <.loword($003C35)
.byte <.loword($003FCA)
.byte <.loword($004395)
.byte <.loword($00479A)
.byte <.loword($004BDB)
.byte <.loword($00505F)
.byte <.loword($005526)
.byte <.loword($005A36)
.byte <.loword($005F93)
.byte <.loword($006542)

.byte <.loword($006B48)				; C-5
.byte <.loword($0071A9)
.byte <.loword($00786B)
.byte <.loword($007F94)
.byte <.loword($00872A)
.byte <.loword($008F34)
.byte <.loword($0097B8)
.byte <.loword($00A0BD)
.byte <.loword($00AA4C)
.byte <.loword($00B46D)
.byte <.loword($00BF27)
.byte <.loword($00CA85)

.byte <.loword($00D690)				; C-6
.byte <.loword($00E352)
.byte <.loword($00F0D7)
.byte <.loword($00FF29)
.byte <.loword($010E55)
.byte <.loword($011E68)
.byte <.loword($012F70)
.byte <.loword($01417B)
.byte <.loword($015499)
.byte <.loword($0168DA)
.byte <.loword($017E4F)
.byte <.loword($01950B)

.byte <.loword($01AD20)				; C-7
.byte <.loword($01C6A5)
.byte <.loword($01E1AE)
.byte <.loword($01FE53)
.byte <.loword($021CAB)
.byte <.loword($023CD1)
.byte <.loword($025EE1)
.byte <.loword($0282F7)
.byte <.loword($02A933)
.byte <.loword($02D1B5)
.byte <.loword($02FC9F)
.byte <.loword($032A16)

.byte <.loword($035A42)				; C-8
.byte <.loword($038D4B)
.byte <.loword($03C35C)
.byte <.loword($03FCA5)
.byte <.loword($043956)
.byte <.loword($0479A3)
.byte <.loword($04BDC3)
.byte <.loword($0505EF)
.byte <.loword($055267)
.byte <.loword($05A36A)
.byte <.loword($05F93E)
.byte <.loword($06542D)

audiodma_freqm

.byte >.loword($00035A)
.byte >.loword($00038D)
.byte >.loword($0003C3)
.byte >.loword($0003FC)
.byte >.loword($000439)
.byte >.loword($000479)
.byte >.loword($0004BD)
.byte >.loword($000505)
.byte >.loword($000552)
.byte >.loword($0005A3)
.byte >.loword($0005F9)
.byte >.loword($000654)

.byte >.loword($0006B4)
.byte >.loword($00071A)
.byte >.loword($000786)
.byte >.loword($0007F9)
.byte >.loword($000872)
.byte >.loword($0008F3)
.byte >.loword($00097B)
.byte >.loword($000A0B)
.byte >.loword($000AA4)
.byte >.loword($000B46)
.byte >.loword($000BF2)
.byte >.loword($000CA8)

.byte >.loword($000D69)
.byte >.loword($000E35)
.byte >.loword($000F0D)
.byte >.loword($000FF2)
.byte >.loword($0010E5)
.byte >.loword($0011E6)
.byte >.loword($0012F7)
.byte >.loword($001417)
.byte >.loword($001549)
.byte >.loword($00168D)
.byte >.loword($0017E4)
.byte >.loword($001950)

.byte >.loword($001AD1)
.byte >.loword($001C6A)
.byte >.loword($001E1A)
.byte >.loword($001FE5)
.byte >.loword($0021CA)
.byte >.loword($0023CC)
.byte >.loword($0025EE)
.byte >.loword($00282F)
.byte >.loword($002A93)
.byte >.loword($002D1B)
.byte >.loword($002FC9)
.byte >.loword($0032A1)

.byte >.loword($0035A4)
.byte >.loword($0038D4)
.byte >.loword($003C35)
.byte >.loword($003FCA)
.byte >.loword($004395)
.byte >.loword($00479A)
.byte >.loword($004BDB)
.byte >.loword($00505F)
.byte >.loword($005526)
.byte >.loword($005A36)
.byte >.loword($005F93)
.byte >.loword($006542)

.byte >.loword($006B48)
.byte >.loword($0071A9)
.byte >.loword($00786B)
.byte >.loword($007F94)
.byte >.loword($00872A)
.byte >.loword($008F34)
.byte >.loword($0097B8)
.byte >.loword($00A0BD)
.byte >.loword($00AA4C)
.byte >.loword($00B46D)
.byte >.loword($00BF27)
.byte >.loword($00CA85)

.byte >.loword($00D690)
.byte >.loword($00E352)
.byte >.loword($00F0D7)
.byte >.loword($00FF29)
.byte >.loword($010E55)
.byte >.loword($011E68)
.byte >.loword($012F70)
.byte >.loword($01417B)
.byte >.loword($015499)
.byte >.loword($0168DA)
.byte >.loword($017E4F)
.byte >.loword($01950B)

.byte >.loword($01AD20)
.byte >.loword($01C6A5)
.byte >.loword($01E1AE)
.byte >.loword($01FE53)
.byte >.loword($021CAB)
.byte >.loword($023CD1)
.byte >.loword($025EE1)
.byte >.loword($0282F7)
.byte >.loword($02A933)
.byte >.loword($02D1B5)
.byte >.loword($02FC9F)
.byte >.loword($032A16)

.byte >.loword($035A42)
.byte >.loword($038D4B)
.byte >.loword($03C35C)
.byte >.loword($03FCA5)
.byte >.loword($043956)
.byte >.loword($0479A3)
.byte >.loword($04BDC3)
.byte >.loword($0505EF)
.byte >.loword($055267)
.byte >.loword($05A36A)
.byte >.loword($05F93E)
.byte >.loword($06542D)


audiodma_freqh

.byte <.hiword($00035A)
.byte <.hiword($00038D)
.byte <.hiword($0003C3)
.byte <.hiword($0003FC)
.byte <.hiword($000439)
.byte <.hiword($000479)
.byte <.hiword($0004BD)
.byte <.hiword($000505)
.byte <.hiword($000552)
.byte <.hiword($0005A3)
.byte <.hiword($0005F9)
.byte <.hiword($000654)

.byte <.hiword($0006B4)
.byte <.hiword($00071A)
.byte <.hiword($000786)
.byte <.hiword($0007F9)
.byte <.hiword($000872)
.byte <.hiword($0008F3)
.byte <.hiword($00097B)
.byte <.hiword($000A0B)
.byte <.hiword($000AA4)
.byte <.hiword($000B46)
.byte <.hiword($000BF2)
.byte <.hiword($000CA8)

.byte <.hiword($000D69)
.byte <.hiword($000E35)
.byte <.hiword($000F0D)
.byte <.hiword($000FF2)
.byte <.hiword($0010E5)
.byte <.hiword($0011E6)
.byte <.hiword($0012F7)
.byte <.hiword($001417)
.byte <.hiword($001549)
.byte <.hiword($00168D)
.byte <.hiword($0017E4)
.byte <.hiword($001950)

.byte <.hiword($001AD1)
.byte <.hiword($001C6A)
.byte <.hiword($001E1A)
.byte <.hiword($001FE5)
.byte <.hiword($0021CA)
.byte <.hiword($0023CC)
.byte <.hiword($0025EE)
.byte <.hiword($00282F)
.byte <.hiword($002A93)
.byte <.hiword($002D1B)
.byte <.hiword($002FC9)
.byte <.hiword($0032A1)

.byte <.hiword($0035A4)
.byte <.hiword($0038D4)
.byte <.hiword($003C35)
.byte <.hiword($003FCA)
.byte <.hiword($004395)
.byte <.hiword($00479A)
.byte <.hiword($004BDB)
.byte <.hiword($00505F)
.byte <.hiword($005526)
.byte <.hiword($005A36)
.byte <.hiword($005F93)
.byte <.hiword($006542)

.byte <.hiword($006B48)
.byte <.hiword($0071A9)
.byte <.hiword($00786B)
.byte <.hiword($007F94)
.byte <.hiword($00872A)
.byte <.hiword($008F34)
.byte <.hiword($0097B8)
.byte <.hiword($00A0BD)
.byte <.hiword($00AA4C)
.byte <.hiword($00B46D)
.byte <.hiword($00BF27)
.byte <.hiword($00CA85)

.byte <.hiword($00D690)
.byte <.hiword($00E352)
.byte <.hiword($00F0D7)
.byte <.hiword($00FF29)
.byte <.hiword($010E55)
.byte <.hiword($011E68)
.byte <.hiword($012F70)
.byte <.hiword($01417B) 
.byte <.hiword($015499)
.byte <.hiword($0168DA)
.byte <.hiword($017E4F)
.byte <.hiword($01950B)

.byte <.hiword($01AD20)
.byte <.hiword($01C6A5)
.byte <.hiword($01E1AE)
.byte <.hiword($01FE53)
.byte <.hiword($021CAB)
.byte <.hiword($023CD1)
.byte <.hiword($025EE1)
.byte <.hiword($0282F7)
.byte <.hiword($02A933)
.byte <.hiword($02D1B5)
.byte <.hiword($02FC9F)
.byte <.hiword($032A16)

.byte <.hiword($035A42)
.byte <.hiword($038D4B)
.byte <.hiword($03C35C)
.byte <.hiword($03FCA5)
.byte <.hiword($043956)
.byte <.hiword($0479A3)
.byte <.hiword($04BDC3)
.byte <.hiword($0505EF)
.byte <.hiword($055267)
.byte <.hiword($05A36A)
.byte <.hiword($05F93E)
.byte <.hiword($06542D)

; ----------------------------------------------------------------------------------------------------
