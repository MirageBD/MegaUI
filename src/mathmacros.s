.define MULTINA			$d770
.define MULTINB			$d774

.define MULTOUT			$d778

.define DIVOUTWHOLE		$d76c
.define DIVOUTFRACT		$d768

.define FP_A			$a0
.define FP_B 			$a4
.define FP_C			$a8
.define FP_R			$ac

.macro MATH_ROUND from, to
.scope
		ldq from
		cpx #$80
		bmi :+
		iny
		stq to
:		
.endscope
.endmacro

.macro MATH_ADD from, with, to
.scope
		ldq from
		clc
		adcq with
        stq to
.endscope
.endmacro

.macro MATH_SUB from, with, to
.scope
		ldq from
		sec
		sbcq with
        stq to
.endscope
.endmacro

.macro MATH_MOV from, to
		ldq from
		stq to
.endmacro

.macro MATH_NEG from, to
        lda #0
        tax
        tay
        taz
        sec
        sbcq from
        stq to
.endmacro

.macro MATH_ABS from, to
.scope
        bit from+3
        bpl pos
        MATH_NEG from, to
        bra end
pos		MATH_MOV from, to
end
.endscope
.endmacro

.macro MATH_DIV numerator, denominator, result
.scope
		MATH_ABS numerator, MULTINA
		MATH_ABS denominator, MULTINB

		lda	$d020
		sta	$d020
		lda	$d020
		sta	$d020
		lda	$d020
		sta	$d020
		lda	$d020
		sta	$d020

		lda DIVOUTFRACT+2
		sta FP_A+0
		lda DIVOUTFRACT+3
		sta FP_A+1
		lda DIVOUTWHOLE+0
		sta FP_A+2
		lda DIVOUTWHOLE+1
		sta FP_A+3

        bit numerator+3
        bmi negtive						; a is not negative
        bit denominator+3
        bmi nnegtive					; a is negative, but b is not, use negative result
        bra plus						; a is negative and b also. use result as is
negtive
		bit denominator+3
		bmi plus						; b is also not negative. use result as is
nnegtive
		MATH_NEG FP_A, result
		bra end
plus
		MATH_MOV FP_A, result
end
.endscope
.endmacro

.macro MATH_MUL opA, opB, result
.scope
		MATH_ABS opA, MULTINA
		MATH_ABS opB, MULTINB

        bit opA+3
        bmi negtive						; a is not negative
        bit opB+3
        bmi nnegtive					; a is negative, but b is not, use negative result
        bra plus						; a is negative and b also. use result as is
negtive
		bit opB+3
		bmi plus						; b is also not negative. use result as is
nnegtive
		MATH_NEG MULTOUT+2, result		; add 2 to get new 16.16 fixed point result
		bra end
plus
		MATH_MOV MULTOUT+2, result		; add 2 to get new 16.16 fixed point result
end
.endscope
.endmacro
