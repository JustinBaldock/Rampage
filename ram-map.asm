;*********************************************************
; master list, organised by address
;*********************************************************
D6510     = $00  ; DDR
R6510     = $01  ; I/O PORT
BACKDROP  = $0B00 ;to 1300 - JB this appears to be used
;BLOCKS    = $1000 ; JB - Not used
COLMEM    = $1300 ; JB - This is used
COLMEM1   = $1400 ; JB - This is used
CHRTAB    = $1500 ; START OF TABLES
BL0       = $1C00 ; GEORGE
BL1       = $1C00+$558  ; RALPH
BL2       = $1C00+($558*2)  ; LIZZY
BLR0      = $1C00+($558*3)  ; GRORGE REVERSED
BLR1      = $1C00+($558*4)  ; RALPH REVERSED
BLR2      = $1C00+($558*5)  ; LIZZY REVERSED
;SCHARS    = $2200 ; JB - Not used
BLSTART   = $3C10 ;to 4000      ; BLOCK
DTILES    = $7000  ;to $7500
CODE      = $7800
BANK      = $C000
CHAR      = $C000 ; 2K
BUF0      = $CCA0; 48*6 TO STORE
BUF1      = $CCA0+(48*6)
BUF2      = $CCA0+(48*12) ; $33C
NYBBLE    = $D800
CIA1      = $DC00
CIA2      = $DD00
COL       = $F400 ; 1K
TEMPCOL   = $F400
TEMPCOL1  = $F800


COLOR_BLACK   = 0
COLOR_WHITE   = 1
COLOR_RED     = 2
COLOR_CYAN    = 3
COLOR_PURPLE  = 4
COLOR_GREEN   = 5
COLOR_BLUE    = 6
COLOR_YELLOW  = 7
COLOR_ORANGE  = 8
COLOR_BROWN   = 9
COLOR_RED_LIGHT = 10
COLOR_GREY_DARK = 11
COLOR_GREY      = 12
COLOR_GREEN_LIGHT = 13
COLOR_BLUE_LIGHT  = 14
COLOR_GREY_LIGHT  = 15








;*********************************************************
; from build.asm
;*********************************************************
;MUSIC          = $200  ;to $B00
STORE           = $0900
BACKDROP        = $0B00 ;to 1300
COLMEM          = $1300
COLMEM1         = $1400
BLSTART         = $3C10 ;to 4000      ; BLOCK
DTILES          = $7000  ;to $7500
CODE            = $7800
CHSET           = $E000
CHARHB          = ($E0)/8
CBASE           = CHSET+(220*8)
TEMPCOL         = $F400
TEMPCOL1        = $F800

;*********************************************************
; from copy.asm
;*********************************************************
CHRTAB  = $1500 ; START OF TABLES
BL0 = $1C00 ; GEORGE
BL1 = $1C00+$558  ; RALPH
BL2 = $1C00+($558*2)  ; LIZZY
BLR0  = $1C00+($558*3)  ; GRORGE REVERSED
BLR1  = $1C00+($558*4)  ; RALPH REVERSED
BLR2  = $1C00+($558*5)  ; LIZZY REVERSED

BUF0  = $CCA0; 48*6 TO STORE
BUF1  = $CCA0+(48*6)
BUF2  = $CCA0+(48*12) ; $33C

;*********************************************************
; from debug.asm
;*********************************************************
CHSET     = $E000
CHARHB    = ($E0)/8
CBASE     = CHSET+(220*8)

;*********************************************************
; from djcode.asm
;*********************************************************
STORE   = $0900

;*********************************************************
; from irq.asm
;*********************************************************
D6510   = $00  ; DDR
R6510   = $01  ; I/O PORT

BLOCKS  = $1000
SCHARS  = $2200
BANK    = $C000
CHAR    = $C000 ; 2K
COL     = $F400 ; 1K
VIC     = $D000
SPRITE_0_X = VIC+0 ; Was named X0
SPRITE_0_Y = VIC+1 ; Was named Y0
X1    = VIC+2
Y1    = VIC+3
X2    = VIC+4
Y2    = VIC+5
X3    = VIC+6
Y3    = VIC+7
X4    = VIC+8
Y4    = VIC+9
X5    = VIC+10
Y5    = VIC+11
X6    = VIC+12
Y6    = VIC+13
X7    = VIC+14
Y7    = VIC+15
SPRITE_7  = VIC+16 ; Was named MSB
VIC_CONTROL_REGISTER1 = $D011 ; screen heigth, mode, etc etc. 
RASTER    = $D012
VIC_SPRITE_ENABLE     = $D015
VIC_CONTROL_REGISTER2 = $D016 
EXPANDY   = $D017 ; Sprite double height
VIC_MEMORY_CONTROL_REGISTER = $D018 ; Set vic memory config
VIC_INTERRUPT_STATUS_REGISTER = $D019
VICIMR    = VIC+26 ; VIC-Interrupt-control-register
PRIORITY  = VIC+27  
VIC_SPRITE_MULTICOLOR = $D01C ; MULTICOL
EXPANDX   = VIC+29
BORDER    = $D020
COLOUR0   = $D021
COLOUR1   = $D022
COLOUR2   = $D023
COLOUR3   = $D024
VIC_SPRITE_EXTRA_COLOR1 = $D025 ; Sprite extra colour 1
VIC_SPRITE_EXTRA_COLOR2 = $D026 ; Sprite extra colour 2
VIC_SPRITE_0_COLOR  = $D027 ; Was SPC0
VIC_SPRITE_1_COLOR  = $D028 ; Was SPC1 
VIC_SPRITE_2_COLOR  = $D029
VIC_SPRITE_3_COLOR  = $D02A
VIC_SPRITE_4_COLOR  = $D02B
VIC_SPRITE_5_COLOR  = $D02C
VIC_SPRITE_6_COLOR  = $D02D
VIC_SPRITE_7_COLOR  = $D02E ; Was SPC7

NYBBLE    = $D800
CIA1      = $DC00
CIA2      = $DD00

JOYSTICK2 = $DC00
JOYSTICK1 = $DC01
CIA1_PORTA = $DC02
CIA1_PORTB = $DC03
CIA1_INTERRUPT_CONTROL_STATUS = $DC0D
CIA1_TIMER_A_CTRL = $DC0E
CIA1_TIMER_B_CTRL = $DC0F

CIA2_PORTA = $DD02
CIA2_TIMER_A_CURRENT_L = $DD04
CIA2_TIMER_A_CURRENT_H = $DD05
CIA2_TIMER_B_CURRENT_L = $DD06
CIA2_TIMER_B_CURRENT_H = $DD07
CIA2_INTERRUPT_CONTROL_STATUS = $DD0D
CIA2_TIMER_A_CTRL = $DD0E
CIA2_TIMER_B_CTRL = $DD0F

SPRITE0A  = COL+$3F8
SPRITE1A  = SPRITE0A+1
SPRITE2A  = SPRITE1A+1
SPRITE3A  = SPRITE2A+1
SPRITE4A  = SPRITE3A+1
SPRITE5A  = SPRITE4A+1
SPRITE6A  = SPRITE5A+1
SPRITE7A  = SPRITE6A+1

SPRITE0B  = COL+$3F8+$400
SPRITE1B  = SPRITE0B+1
SPRITE2B  = SPRITE1B+1
SPRITE3B  = SPRITE2B+1
SPRITE4B  = SPRITE3B+1
SPRITE5B  = SPRITE4B+1
SPRITE6B  = SPRITE5B+1
SPRITE7B  = SPRITE6B+1

SS0 = 64  ; SPRITE START 0 $D000
SS1 = 192 ; SPRITE START 1 $F000
SO0 = 202 ; APE START $F280 $F3C0
SO1 = 240 ; APE START $FC00 $FD40
SO2 = 246 ; APE START $FD80 $FEC0
BL  = 252 ; BLANK SPRITE $FF00

;*********************************************************
; from ramp.asm
;*********************************************************
O       = 189+7+20    ; SPRITE OFFSET




