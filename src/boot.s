.feature pc_assignment
.feature labels_without_colons
.feature c_comments
; .feature org_per_seg

.include "macros.s"
.include "mathmacros.s"

filebuffer = $0200

; -----------------------------------------------------------------------------------------------

.segment "BASIC"

			.word basicend
			.word 0										; 0
			.byte $fe, $02								; bank
			.byte $30									; 0
			.byte $3a									; :
			.byte $9e									; sys xxxx
			.byte .sprintf("%d", $2011)					; sys xxxx
			.byte 0
basicend	.byte 0
			.byte 0

			jmp entry_main

.include "ui/uimacros.s"

.include "main.s"
.include "irqload.s"
.include "modplay.s"

.include "drivers/mouse.s"
.include "drivers/sdc.s"
.include "drivers/keyboard.s"

.include "ui/uicore.s"
.include "ui/uirect.s"
.include "ui/uidraw.s"
.include "ui/ui.s"
.include "ui/uidebug.s"
.include "ui/uimouse.s"
.include "ui/uikeyboard.s"

.include "ui/uielements/uielement.s"
.include "ui/uielements/uiroot.s"
.include "ui/uielements/uidebugelement.s"
.include "ui/uielements/uihexlabel.s"
.include "ui/uielements/uiwindow.s"
.include "ui/uielements/uibutton.s"
.include "ui/uielements/uicbutton.s"
.include "ui/uielements/uictextbutton.s"
.include "ui/uielements/uicnumericbutton.s"
.include "ui/uielements/uiscrolltrack.s"
.include "ui/uielements/uilabel.s"
.include "ui/uielements/uinineslice.s"
.include "ui/uielements/uilistbox.s"
.include "ui/uielements/uifilebox.s"
.include "ui/uielements/uicheckbox.s"
.include "ui/uielements/uiradiobutton.s"
.include "ui/uielements/uiimage.s"
.include "ui/uielements/uitextbox.s"
.include "ui/uielements/uitab.s"
.include "ui/uielements/uigroup.s"

.include "ui/uielements/uipatternview.s"
.include "ui/uielements/uisequenceview.s"
.include "ui/uielements/uichannelview.s"
.include "ui/uielements/uisampleview.s"

.include "uidata.s"
.include "uitext.s"

; ----------------------------------------------------------------------------------------------------
