.define uidraw_scrptr		$80
.define uidraw_colptr		$84

.define zpptr0				$88
.define zpptr1		        $8a
.define zpptr2		        $8c
.define zpptr3		        $8e
.define zpptrtmp	        $90			; used for z indexing into higher ram, so 4 bytes

.macro DEBUG_COLOUR
.scope
		sta $d020
		ldy #$10
		ldx #$00
:		dex
		bne :-
		dey
		bne :-
.endscope
.endmacro

.macro UICORE_SELECT_ELEMENT element
		lda #<element
		sta zpptr0+0
		lda #>element
		sta zpptr0+1
.endmacro

.macro UICORE_CALLELEMENTFUNCTION element, function
		UICORE_SELECT_ELEMENT element
		jsr function
.endmacro
