# -----------------------------------------------------------------------------

megabuild		= 1
attachdebugger	= 0

# -----------------------------------------------------------------------------

MAKE			= make
CP				= cp
MV				= mv 
RM				= rm -f

SRC_DIR			= ./src
UI_SRC_DIR		= ./src/ui
UIELT_SRC_DIR	= ./src/ui/uielements
DRVRS_SRC_DIR	= ./src/drivers
EXE_DIR			= ./exe
BIN_DIR			= ./bin

# mega65 fork of ca65: https://github.com/dillof/cc65
AS				= ca65mega
ASFLAGS			= -g -D megabuild=$(megabuild) --cpu 45GS02 -U --feature force_range -I ./exe
LD				= ld65
C1541			= c1541
CC1541			= cc1541
SED				= sed
PU				= pucrunch
BBMEGA			= b2mega
LC				= crush 6
GCC				= gcc
MC				= MegaConvert
MEGAADDRESS		= megatool -a
MEGACRUNCH		= megatool -c
MEGAIFFL		= megatool -i
MEGAMOD			= MegaMod
EL				= etherload -i 192.168.1.255
XMEGA65			= H:\xemu\xmega65.exe
MEGAFTP			= mega65_ftp -i 192.168.1.255

CONVERTBREAK	= 's/al [0-9A-F]* \.br_\([a-z]*\)/\0\nbreak \.br_\1/'
CONVERTWATCH	= 's/al [0-9A-F]* \.wh_\([a-z]*\)/\0\nwatch store \.wh_\1/'

CONVERTVICEMAP	= 's/al //'

.SUFFIXES: .o .s .out .bin .pu .b2 .a

default: all

OBJS = $(EXE_DIR)/boot.o $(EXE_DIR)/main.o

BINFILES  = $(BIN_DIR)/font_chars1.bin
BINFILES += $(BIN_DIR)/glyphs_chars1.bin
BINFILES += $(BIN_DIR)/glyphs_pal1.bin
BINFILES += $(BIN_DIR)/cursor_sprites1.bin
BINFILES += $(BIN_DIR)/kbcursor_sprites1.bin
BINFILES += $(BIN_DIR)/cursor_pal1.bin
BINFILES += $(BIN_DIR)/song.mod

# -----------------------------------------------------------------------------

$(BIN_DIR)/font_chars1.bin: $(BIN_DIR)/font.bin
	$(MC) $< cm1:1 d1:0 cl1:10000 rc1:0

$(BIN_DIR)/glyphs_chars1.bin: $(BIN_DIR)/glyphs.bin
	$(MC) $< cm1:1 d1:0 cl1:14000 rc1:0

$(BIN_DIR)/cursor_sprites1.bin: $(BIN_DIR)/cursor.bin
	$(MC) $< cm1:1 d1:0 cl1:14000 rc1:0 sm1:1

$(BIN_DIR)/kbcursor_sprites1.bin: $(BIN_DIR)/kbcursor.bin
	$(MC) $< cm1:1 d1:0 cl1:14000 rc1:0 sm1:1

$(EXE_DIR)/boot.o:	$(SRC_DIR)/boot.s \
					$(SRC_DIR)/main.s \
					$(SRC_DIR)/macros.s \
					$(SRC_DIR)/mathmacros.s \
					$(SRC_DIR)/uidata.s \
					$(SRC_DIR)/uitext.s \
					$(SRC_DIR)/modplay.s \
					$(DRVRS_SRC_DIR)/mouse.s \
					$(DRVRS_SRC_DIR)/joystick.s \
					$(DRVRS_SRC_DIR)/sdc.s \
					$(DRVRS_SRC_DIR)/keyboard.s \
					$(DRVRS_SRC_DIR)/audiodma.s \
					$(UI_SRC_DIR)/uimacros.s \
					$(UI_SRC_DIR)/uicore.s \
					$(UI_SRC_DIR)/uirect.s \
					$(UI_SRC_DIR)/uidraw.s \
					$(UI_SRC_DIR)/ui.s \
					$(UI_SRC_DIR)/uidebug.s \
					$(UI_SRC_DIR)/uimouse.s \
					$(UI_SRC_DIR)/uijoystick.s \
					$(UI_SRC_DIR)/uikeyboard.s \
					$(UIELT_SRC_DIR)/uielement.s \
					$(UIELT_SRC_DIR)/uiroot.s \
					$(UIELT_SRC_DIR)/uidebugelement.s \
					$(UIELT_SRC_DIR)/uihexlabel.s \
					$(UIELT_SRC_DIR)/uiwindow.s \
					$(UIELT_SRC_DIR)/uibutton.s \
					$(UIELT_SRC_DIR)/uiglyphbutton.s \
					$(UIELT_SRC_DIR)/uicbutton.s \
					$(UIELT_SRC_DIR)/uictextbutton.s \
					$(UIELT_SRC_DIR)/uicnumericbutton.s \
					$(UIELT_SRC_DIR)/uiscrolltrack.s \
					$(UIELT_SRC_DIR)/uislider.s \
					$(UIELT_SRC_DIR)/uilabel.s \
					$(UIELT_SRC_DIR)/uinineslice.s \
					$(UIELT_SRC_DIR)/uilistbox.s \
					$(UIELT_SRC_DIR)/uifilebox.s \
					$(UIELT_SRC_DIR)/uicheckbox.s \
					$(UIELT_SRC_DIR)/uiradiobutton.s \
					$(UIELT_SRC_DIR)/uiimage.s \
					$(UIELT_SRC_DIR)/uitextbox.s \
					$(UIELT_SRC_DIR)/uidivider.s \
					$(UIELT_SRC_DIR)/uipatternview.s \
					$(UIELT_SRC_DIR)/uisequenceview.s \
					$(UIELT_SRC_DIR)/uichannelview.s \
					$(UIELT_SRC_DIR)/uitab.s \
					$(UIELT_SRC_DIR)/uigroup.s \
					$(UIELT_SRC_DIR)/uisampleview.s \
					$(UIELT_SRC_DIR)/uiscaletrack.s \
					$(UIELT_SRC_DIR)/uipiano.s \
					Makefile Linkfile
	$(AS) $(ASFLAGS) -o $@ $<

$(EXE_DIR)/boot.prg.addr.mc: $(BINFILES) $(EXE_DIR)/boot.o Linkfile
	$(LD) -Ln $(EXE_DIR)/boot.maptemp --dbgfile $(EXE_DIR)/boot.dbg -C Linkfile -o $(EXE_DIR)/boot.prg $(EXE_DIR)/boot.o
	$(MEGAADDRESS) $(EXE_DIR)/boot.prg 00000600
	$(MEGACRUNCH) -e 00000600 $(EXE_DIR)/boot.prg.addr

$(EXE_DIR)/megamod.d81: $(EXE_DIR)/boot.prg.addr.mc
	$(RM) $@
	$(CC1541) -n "megamod" -i " 2023" -d 19 -v\
	 \
	 -f "megamod" -w $(EXE_DIR)/boot.prg.addr.mc \
	$@

# -----------------------------------------------------------------------------

run: $(EXE_DIR)/megamod.d81

ifeq ($(megabuild), 1)
	$(MEGAFTP) -c "put D:\Mega\MegaUI\exe\megamod.d81 megamod.d81" -c "quit"
	$(EL) -r $(EXE_DIR)/boot.prg.addr.mc
ifeq ($(attachdebugger), 1)
	m65dbg --device /dev/ttyS2
endif
else
	cmd.exe /c $(XMEGA65) -autoload -8 $(EXE_DIR)/megamod.d81
endif

clean:
	$(RM) $(EXE_DIR)/*.*
	$(RM) $(EXE_DIR)/*

