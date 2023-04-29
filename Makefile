# -----------------------------------------------------------------------------

megabuild		= 0
finalbuild		= 1
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
ASFLAGS			= -g -D finalbuild=$(finalbuild) -D megabuild=$(megabuild) --cpu 45GS02 -U --feature force_range -I ./exe
LD				= ld65
C1541			= c1541
CC1541			= cc1541
SED				= sed
PU				= pucrunch
BBMEGA			= b2mega
LC				= crush 6
GCC				= gcc
MC				= MegaConvert
ADDADDR			= addaddr
MEGAMOD			= MegaMod
XMEGA65			= F:\xemu\xmega65.exe

CONVERTBREAK	= 's/al [0-9A-F]* \.br_\([a-z]*\)/\0\nbreak \.br_\1/'
CONVERTWATCH	= 's/al [0-9A-F]* \.wh_\([a-z]*\)/\0\nwatch store \.wh_\1/'

CONVERTVICEMAP	= 's/al //'

.SUFFIXES: .o .s .out .bin .pu .b2 .a

default: all

OBJS = $(EXE_DIR)/boot.o $(EXE_DIR)/main.o

# % is a wildcard
# $< is the first dependency
# $@ is the target
# $^ is all dependencies

# -----------------------------------------------------------------------------

$(BIN_DIR)/font_chars1.bin: $(BIN_DIR)/font.bin
	$(MC)
	$(MC) $< cm1:1 d1:0 cl1:10000 rc1:0

$(BIN_DIR)/glyphs_chars1.bin: $(BIN_DIR)/glyphs.bin
	$(MC)
	$(MC) $< cm1:1 d1:0 cl1:14000 rc1:0

$(BIN_DIR)/cursor_sprites1.bin: $(BIN_DIR)/cursor.bin
	$(MC)
	$(MC) $< cm1:1 d1:0 cl1:14000 rc1:0 sm1:1

$(BIN_DIR)/kbcursor_sprites1.bin: $(BIN_DIR)/kbcursor.bin
	$(MC)
	$(MC) $< cm1:1 d1:0 cl1:14000 rc1:0 sm1:1

$(EXE_DIR)/boot.o:	$(SRC_DIR)/boot.s \
					$(SRC_DIR)/main.s \
					$(SRC_DIR)/irqload.s \
					$(SRC_DIR)/macros.s \
					$(SRC_DIR)/mathmacros.s \
					$(SRC_DIR)/uidata.s \
					$(SRC_DIR)/uitext.s \
					$(SRC_DIR)/modplay.s \
					$(DRVRS_SRC_DIR)/mouse.s \
					$(DRVRS_SRC_DIR)/sdc.s \
					$(DRVRS_SRC_DIR)/keyboard.s \
					$(UI_SRC_DIR)/uimacros.s \
					$(UI_SRC_DIR)/uicore.s \
					$(UI_SRC_DIR)/uirect.s \
					$(UI_SRC_DIR)/uidraw.s \
					$(UI_SRC_DIR)/ui.s \
					$(UI_SRC_DIR)/uidebug.s \
					$(UI_SRC_DIR)/uimouse.s \
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
					$(UIELT_SRC_DIR)/uipatternview.s \
					$(UIELT_SRC_DIR)/uisequenceview.s \
					$(UIELT_SRC_DIR)/uichannelview.s \
					$(UIELT_SRC_DIR)/uitab.s \
					$(UIELT_SRC_DIR)/uigroup.s \
					$(UIELT_SRC_DIR)/uisampleview.s \
					$(UIELT_SRC_DIR)/uiscaletrack.s \
					Makefile Linkfile
	$(AS) $(ASFLAGS) -o $@ $<

$(EXE_DIR)/boot.prg: $(EXE_DIR)/boot.o Linkfile
	$(LD) -Ln $(EXE_DIR)/boot.maptemp --dbgfile $(EXE_DIR)/boot.dbg -C Linkfile -o $@ $(EXE_DIR)/boot.o
	$(ADDADDR) $(EXE_DIR)/boot.prg $(EXE_DIR)/bootaddr.prg 8193
	$(SED) $(CONVERTVICEMAP) < $(EXE_DIR)/boot.maptemp > boot.map
	$(SED) $(CONVERTVICEMAP) < $(EXE_DIR)/boot.maptemp > boot.list

$(EXE_DIR)/disk.d81: $(EXE_DIR)/boot.prg $(BIN_DIR)/font_chars1.bin $(BIN_DIR)/glyphs_chars1.bin $(BIN_DIR)/cursor_sprites1.bin $(BIN_DIR)/kbcursor_sprites1.bin
	$(RM) $@
	$(CC1541) -n "mega" -i " 2022" -d 19 -v\
	 \
	 -f "boot" -w $(EXE_DIR)/bootaddr.prg \
	 -f "00" -w $(BIN_DIR)/font_chars1.bin \
	 -f "01" -w $(BIN_DIR)/glyphs_chars1.bin \
	 -f "02" -w $(BIN_DIR)/glyphs_pal1.bin \
	 -f "03" -w $(BIN_DIR)/cursor_sprites1.bin \
	 -f "04" -w $(BIN_DIR)/kbcursor_sprites1.bin \
	 -f "05" -w $(BIN_DIR)/cursor_pal1.bin \
	 -f "06" -w $(BIN_DIR)/song.mod \
	$@

# -----------------------------------------------------------------------------

run: $(EXE_DIR)/disk.d81

ifeq ($(megabuild), 1)

	m65 -l COM3 -F
	mega65_ftp.exe -l COM3 -s 2000000 -c "cd /" \
	-c "put D:\Mega\MegaUI\exe\disk.d81 megaui.d81"

	m65 -l COM3 -F
	m65 -l COM3 -T 'list'
	m65 -l COM3 -T 'list'
	m65 -l COM3 -T 'list'
	m65 -l COM3 -T 'mount "megaui.d81"'
	m65 -l COM3 -T 'load "$$"'
	m65 -l COM3 -T 'list'
	m65 -l COM3 -T 'list'
	m65 -l COM3 -T 'load "boot"'
	m65 -l COM3 -T 'list'
	m65 -l COM3 -T 'run'

ifeq ($(attachdebugger), 1)
	m65dbg --device /dev/ttyS2
endif

else

#	cmd.exe /c $(XMEGA65) -mastervolume 50 -autoload -8 $(EXE_DIR)/disk.d81
	cmd.exe /c $(XMEGA65) -autoload -8 $(EXE_DIR)/disk.d81

endif

clean:
	$(RM) $(EXE_DIR)/*.*
	$(RM) $(EXE_DIR)/*

