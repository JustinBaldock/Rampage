!PSEUDOPC $7800

;MSW -1
;EXEC MAIN         

; STARTED 21/05/1987
; COPYRIGHT 1987/88
; MICHAEL ARCHER

;DSECT
;ORG $00

D6510   !fill 1  ; DDR
R6510   !fill 1  ; I/O PORT
SYNC    !fill 1
LEFT    !fill 3
RIGHT   !fill 3
UP      !fill 3
DOWN    !fill 3
FIRE    !fill 3  ; ONLY 2 3 FOR DEMO
JOY     !fill 1  ; DO NOT USE
IRQTEMP !fill 1  ; WORKING OUT STUFF
APECOUNT !fill 1 ; TO COPY WHAT SPRITE
NMIHOLD !fill 2  ; NMI TIMER A AND B
IRQHOLD !fill 3  ; A=0 X=1 Y=2
TMP     !fill 1
DEBUG   !fill 3  ; SPRITE ON BORDER
MIKE1   !fill 2
MIKE2   !fill 2
XTEMP   !fill 1
YTEMP   !fill 1
HELHIT  !fill 1  ; HELI BEEN HIT
HEACT0  !fill 1  ; HELI MOVEMENT TYPE
HEACT1  !fill 1  ; TO CHECK FOR FIRE
SEED    !fill 10
YTABLE  !fill 9  ; NEVER NEVER USE
CORDS   !fill 9  ; LOST OF 21'S
TOGGLE  !fill 1  ; HELI 0 AND 1
X !fill 3  ; X CORDINATE
Y !fill 3  ; Y CORDINATE
FRAME !fill 3  ; SPRITE FRAME
STEP  !fill 3  ; WALKING FRAME
DIR   !fill 3  ; WHAT WAY FACEING
ACTION  !fill 3  ; DOING WHAT
COUNT !fill 6  ; TABLE FRAME COUNTER
  ; +1 FOR CAR EXPLODE COUNTER
  ; +2 FOR HELI EXPLODE COUNTER
XCORD !fill 2  ; HELICOPTYERS X
TRANX !fill 1  ; TRANSPORT CORDINATE
HELDIR  !fill 2  ; HELI DIRECTION 1 255
HELDLY  !fill 2  ; SYNC DELAY FOR NEW 1
FISX  !fill 3  ; FIST CHAR X POS
FISY  !fill 3  ; FIS CHAR Y POS
LASTA !fill 3  ; LAST ACTION
HANDY !fill 3  ; 0 UP 1 DOWN 2 LEFT 3 RIGHT
OSIL  !fill 1  ; 0 1 2 3 2 1 0 1 ETC
OSAD  !fill 1  ; USED FOR ABOVE

HEX0  !fill 1  ; X CORD
HEY0  !fill 1  ; Y CORD
SPD0  !fill 2  ; DELAY
TABML0  !fill 2  ; TABLE POINTER
HUSED0  !fill 1  ; BEING USED ?
HEX1  !fill 1  ; X CORD
HEY1  !fill 1  ; Y CORD
SPD1  !fill 2  ; DELAY
TABML1  !fill 2  ; TABLE POINTER
HUSED1  !fill 1  ; BEING USED ?
BALLON  !fill 1  ; AIR BALLON SCREEN
BLX !fill 1  ; BALLON X CORD
BLH !fill 1  ; MSB BYTE
TMPMEM  !fill 2  ; HELI SPARE BYTES
HELLI !fill 1  ; FLIGHT PATTERNED ONES
CARS  !fill 1  ; MOVE GROUND STUFF
SM  !fill 2  ; R.COPY
CM  !fill 2
BM  !fill 2
LX  !fill 1
LY  !fill 1
BUILD  !fill 2

CRACKSPEED  !fill 1
IMTIRED !fill 1
HOWMANY !fill 1
WHICHBACK !fill 1
COUNT2    !fill 1
BUILDY    !fill 1
BUILDX    !fill 1
WINDOWSCAN  !fill 1
WINDOWPOINT !fill 1
KEEP    !fill 1
CBYTE   !fill 1

RANDY   !fill 1
  ;CRACKX   DS 8
COMMON  !fill 1  ; PASSED AS TEMP AREA
  ; ACROSS ALL ROUTINES
  ;DEND


BLOCKS    = $1000
SCHARS    = $2200
BANK    = $C000
CHAR    = $C000 ; 2K
COL   = $F400 ; 1K
VIC   = $D000
X0    = VIC+0
Y0    = VIC+1
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
MSB   = VIC+16
VICCR1    = VIC+17
RASTER    = VIC+18
ENABLE    = VIC+21
VICCR2    = VIC+22
EXPANDY   = VIC+23
VICMCR    = VIC+24
VICIFR    = VIC+25
VICIMR    = VIC+26
PRIORITY  = VIC+27  
MULTICOL  = VIC+28
EXPANDX   = VIC+29
BORDER    = VIC+32
COLOUR0   = VIC+33
COLOUR1   = VIC+34
COLOUR2   = VIC+35
COLOUR3   = VIC+36
MULTI0    = VIC+37
MULTI1    = VIC+38
SPC0      = VIC+39
SPC1      = VIC+40
SPC2      = VIC+41
SPC3      = VIC+42
SPC4      = VIC+43
SPC5      = VIC+44
SPC6      = VIC+45
SPC7      = VIC+46

NYBBLE    = $D800
CIA1      = $DC00
CIA2      = $DD00

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

  ;DW NMI
  ;DW NMI
  ;!byte $EA
  ;!byte $C3,$C2,$CD,$38,$30

NMIA
  STA NMIHOLD
  LDA CIA2+13
  STA NMIHOLD+1
  AND #2
  BNE NMIB  
  LDA NMIHOLD+1
  AND #1
  BEQ HOLT
  LDA VICMCR
  AND #253
  STA VICMCR
  LDA #%11111111
  STA MULTICOL
  LDA #8  ; 5
  STA SPC0
  STA SPC1
NMSB
  LDA #0
  STA MSB
NX6
  LDA #0
  STA X0
NY6
  LDA #0
  STA Y0
NX7
  LDA #0
  STA X1
NY7
  LDA #0
  STA Y1
NP6
  LDA #BL
  STA SPRITE0A
  STA SPRITE0B
NP7
  LDA #BL
  STA SPRITE1A
  STA SPRITE1B
  LDA #0
  STA CIA2+14
  LDA CIA2+13
  LDA CIA2+14
HOLT
  LDA NMIHOLD
RESET
  RTI
  
NMIB
NX62
  LDA #0
  STA X0
NX72
  LDA #0
  STA X1
  LDA #228
  STA Y0
  STA Y1
NMSB2
  LDA #0
  STA MSB
NP62
  LDA #BL
  STA SPRITE1A
  STA SPRITE1B
NP72
  LDA #BL
  STA SPRITE0A
  STA SPRITE0B
CARCOL
  LDA #6
  STA SPC0
  STA SPC1
  LDA #0
  STA CIA2+15
  LDA CIA2+13
  LDA CIA2+15
  LDA NMIHOLD
  RTI

IRQ
  STA IRQHOLD+0
  LDA #1
  STA VICIFR  
  LDA VICMCR
  ORA #2
  STA VICMCR
  DEC SYNC
  LDA #0  ;240  ; LOW FOR A,B
  STA CIA2+4
  LDA #240
  STA CIA2+6
  LDA #18   ; TIMER A HIGH
  STA CIA2+5
  LDA #52   ; TIMER B HIGH
  STA CIA2+7
  LDA #$83
  BIT CIA2+13 ; CLEAR ANY NMI
  STA CIA2+13
  LDA #$99  ; FORCE LOAD
  STA CIA2+14 ; TIMERS AND
  STA CIA2+15 ; START GOING
  LDA VICMCR
  ORA #2
  STA VICMCR
  DEC SYNC
YCOR0
  LDA #255  ; APE 0
  STA Y2
  STA Y3
YCOR1
  LDA #255  ; APE 1
  STA Y4
  STA Y5
YCOR2
  LDA #255  ; APE 2
  STA Y6
  STA Y7

  LDA #SO0+0  ; 0 TOP LEFT    
  STA SPRITE2A
  STA SPRITE2B
  LDA #SO0+1  ; 0 TOP RIGHT
  STA SPRITE3A
  STA SPRITE3B
  LDA #SO1+0  ; 1 TOP LEFT
  STA SPRITE4A
  STA SPRITE4B
  LDA #SO1+1  ; 1 TOP RIGHT
  STA SPRITE5A
  STA SPRITE5B
  LDA #SO2+0  ; 2 TOP LEFT
  STA SPRITE6A
  STA SPRITE6B
  LDA #SO2+1  ; 2 TOP RIGHT
  STA SPRITE7A
  STA SPRITE7B

  LDA APECOUNT
  CLC
  ADC #1
  CMP #3
  BCC DING
  LDA #0
DING  STA APECOUNT
  BEQ .COP0
  CMP #1
  BEQ .COP1  
  JSR COPYB2  
  JMP .BOR
.COP0
  JSR COPYB0
  JMP .BOR
.COP1
  JSR COPYB1
.BOR
  ;STX IRQHOLD+1
  ;STY IRQHOLD+2
  !fill 20,$EA
  ;LDA FIRE
  ;BEQ EW
  ;LDX #0 ; X CHANNEL A=EFFECT
  ;JSR SOUND
  ;LDX IRQHOLD+1
  ;LDY IRQHOLD+2
EW
  LDA #>SPIRQ1  ; D1
  STA $FFFE
  LDA #<SPIRQ1  ; D1
  STA $FFFF
RAST1
  LDA #70+18  ; CHANGES
  STA RASTER
  LDA IRQHOLD+0
  RTI

SPIRQ1
  STA IRQHOLD
  LDA #1
  STA VICIFR
CORD1
  LDA #255
SPR1
  STA Y0
SPR12
  STA Y1
POV1
  LDA #BL
POI1
  STA SPRITE0A
  STA SPRITE0B
POV12
  LDA #BL
POI12
  STA SPRITE0A
  STA SPRITE0B
BRA1
  JMP CORD2
  LDA #>SPIRQ2
  STA $FFFE
  LDA #<SPIRQ2
  STA $FFFF
RAST2
  LDA #80
  STA RASTER
  LDA IRQHOLD
  RTI

SPIRQ2 
  STA IRQHOLD
  LDA #1
  STA VICIFR
CORD2 LDA #255
SPR2  STA Y2
SPR22 STA Y3
POV2  LDA #BL
POI2  STA SPRITE2A
  STA SPRITE2B
POV22 LDA #BL
POI22 STA SPRITE3A
  STA SPRITE3B
BRA2  JMP CORD3
  LDA #>SPIRQ3
  STA $FFFE
  LDA #<SPIRQ3
  STA $FFFF
RAST3 LDA #90
  STA RASTER
  LDA IRQHOLD
  RTI

SPIRQ3  STA IRQHOLD
  LDA #1
  STA VICIFR
CORD3 LDA #255
SPR3  STA Y4
SPR32 STA Y5
POV3  LDA #BL
POI3  STA SPRITE4A
  STA SPRITE4B
POV32 LDA #BL
POI32 STA SPRITE5A
  STA SPRITE5B
BRA3  JMP CORD4
  LDA #>SPIRQ4
  STA $FFFE
  LDA #<SPIRQ5
  STA $FFFF
RAST4 LDA #100
  STA RASTER
  LDA IRQHOLD
  RTI

SPIRQ4  STA IRQHOLD
  LDA #1
  STA VICIFR
CORD4 LDA #255
SPR4  STA Y6
SPR42 STA Y7
POV4  LDA #BL
POI4  STA SPRITE0A
  STA SPRITE0B
POV42 LDA #BL
POI42 STA SPRITE1A
  STA SPRITE1B
BRA4  JMP CORD5
  LDA #>SPIRQ5
  STA $FFFE
  LDA #<SPIRQ5
  STA $FFFF
RAST5 LDA #110
  STA RASTER
  LDA IRQHOLD
  RTI

SPIRQ5  STA IRQHOLD
  LDA #1
  STA VICIFR
CORD5 LDA #255
SPR5  STA Y2
SPR52 STA Y3
POV5  LDA #BL
POI5  STA SPRITE2A
  STA SPRITE2B
POV52 LDA #BL
POI52 STA SPRITE3A
  STA SPRITE3B
BRA5  JMP CORD6
  LDA #>SPIRQ6
       STA $FFFE
  LDA #<SPIRQ6
  STA $FFFF
RAST6 LDA #120
  STA RASTER
  LDA IRQHOLD
  RTI

SPIRQ6  STA IRQHOLD
  LDA #1
  STA VICIFR
CORD6 LDA #255
SPR6  STA Y2
SPR62 STA Y3
POV6  LDA #BL
POI6  STA SPRITE2A
  STA SPRITE2B
POV62 LDA #BL
POI62 STA SPRITE3A
  STA SPRITE3B
BRA6  JMP CORD7
  LDA #>SPIRQ7
  STA $FFFE
  LDA #<SPIRQ7
  STA $FFFF
RAST7 LDA #140
  STA RASTER
  LDA IRQHOLD
  RTI

SPIRQ7  STA IRQHOLD
  LDA #1
  STA VICIFR
CORD7 LDA #255
SPR7  STA Y2
SPR72 STA Y3
POV7  LDA #BL
POI7  STA SPRITE2A
  STA SPRITE2B
POV72 LDA #BL
POI72 STA SPRITE3A
  STA SPRITE3B
BRA7  JMP CORD8
  LDA #>SPIRQ8
  STA $FFFE
  LDA #<SPIRQ8
  STA $FFFF
RAST8 LDA #150
  STA RASTER
  LDA IRQHOLD
  RTI

SPIRQ8  STA IRQHOLD
  LDA #1
  STA VICIFR
CORD8 LDA #255
SPR8  STA Y4
SPR82 STA Y5
POV8  LDA #BL
POI8  STA SPRITE4A
  STA SPRITE4B
POV82 LDA #BL
POI82 STA SPRITE5A
  STA SPRITE5B
BRA8  JMP CORD9
  LDA #>SPIRQ9
  STA $FFFE
  LDA #<SPIRQ9
  STA $FFFF
RAST9 LDA #160
  STA RASTER
  LDA IRQHOLD
  RTI

SPIRQ9  STA IRQHOLD
  LDA #1
  STA VICIFR
CORD9 LDA #255
SPR9  STA Y4
SPR92 STA Y5
POV9  LDA #BL
POI9  STA SPRITE4A
  STA SPRITE4B
POV92 LDA #BL
POI92 STA SPRITE5A
  STA SPRITE5B
  LDA #>SORT1
  STA $FFFE
  LDA #<SORT1
  STA $FFFF
  LDA #249
  STA RASTER
  LDA IRQHOLD
  RTI

SORT1 STA IRQHOLD
  LDA #1
  STA VICIFR
  STX IRQHOLD+1
  STY IRQHOLD+2
          
V0  = 18  ; FIRST RASTER
V1  = 17  ; SECEND RASTER
V2  = 15  ; THIRD RASTER 17
C1  = 2 ; LINES TO COMPARE

THCOL LDA #%11111100
  STA MULTICOL

; **************************
  LDA Y+0
  STA YCOR0+1
  CLC
  ADC #V0
  STA YTABLE+0
  ADC #V1
  STA YTABLE+1  ; NEXT SPR
  ADC #V2
  STA YTABLE+2  ; TURN BLANK
  LDA Y+0
  ADC #21
  STA CORDS+0
  ADC #21
  STA CORDS+1
  ADC #21
  STA CORDS+2

  LDA Y+1
  STA YCOR1+1
  ADC #V0
  STA YTABLE+3  
  ADC #V1
  STA YTABLE+4
  ADC #V2
  STA YTABLE+5
  LDA Y+1
  ADC #21
  STA CORDS+3
  ADC #21
  STA CORDS+4
  ADC #21
  STA CORDS+5

  LDA Y+2
  STA YCOR2+1
  ADC #V0
  STA YTABLE+6
  ADC #V1
  STA YTABLE+7
  ADC #V2
  STA YTABLE+8  
  LDA Y+2
  ADC #21 
  STA CORDS+6
  ADC #21
  STA CORDS+7
  ADC #21
  STA CORDS+8

  ; *********** 1 ************
  LDA YTABLE+0
  JSR SORT
  STA RAST1+1 ; VALUE
  LDA CORDS,X
  STA CORD1+1 ; NEW CORD
  LDA CORDNT,X
  STA SPR1+1  ; NUMBER
  LDA CORDN1,X
  STA SPR12+1 ; NEXT DOOR
  LDA BLP,X ; BOTTOM LEFT
  STA POV1+1  ; SPRITE
  LDA BRP,X ; BOTTOM RIGHT
  STA POV12+1 ; SPRITE
  LDA WHSPR,X ; POINTER
  STA POI1+1  ; VALUE
  LDA WHSPR1,X
  STA POI12+1
  LDA WHSPRB,X
  STA POI1+4
  LDA WHSPRB1,X
  STA POI12+4

  ; *********** 2 ************
  LDA YTABLE+1
  JSR SORT
  LDY #$2C
  STA RAST2+1 ; VALUE
  LDA CORDS,X
  STA CORD2+1
  LDA RAST1+1
  CLC
  ADC #C1
  CMP RAST2+1
  BCC NSAME1
  LDY #$4C
NSAME1  STY BRA1
  LDA CORDNT,X
  STA SPR2+1  ; NUMBER
  LDA CORDN1,X
  STA SPR22+1
  LDA BLP,X ; BOTTOM LEFT
  STA POV2+1  ; SPRITE
  LDA BRP,X ; BOTTOM RIGHT
  STA POV22+1 ; SPRITE
  LDA WHSPR,X ; POINTER
  STA POI2+1  ; VALUE
  LDA WHSPR1,X
  STA POI22+1
  LDA WHSPRB,X
  STA POI2+4
  LDA WHSPRB1,X
  STA POI22+4
  ; *********** 3 ************
  LDA YTABLE+2
  JSR SORT
  LDY #$2C
  STA RAST3+1 ; VALUE
  LDA CORDS,X
  STA CORD3+1
  LDA RAST2+1
  CLC
  ADC #C1
  CMP RAST3+1
  BCC NSAME2
  LDY #$4C
NSAME2  STY BRA2
  LDA CORDNT,X
  STA SPR3+1  ; NUMBER
  LDA CORDN1,X
  STA SPR32+1
  LDA BLP,X ; BOTTOM LEFT
  STA POV3+1  ; SPRITE
  LDA BRP,X ; BOTTOM RIGHT
  STA POV32+1 ; SPRITE
  LDA WHSPR,X ; POINTER
  STA POI3+1  ; VALUE
  LDA WHSPR1,X
  STA POI32+1
  LDA WHSPRB,X
  STA POI3+4
  LDA WHSPRB1,X
  STA POI32+4
  ; *********** 4 ************
  LDA YTABLE+3
  JSR SORT
  LDY #$2C
  STA RAST4+1 ; VALUE
  LDA CORDS,X
  STA CORD4+1
  LDA RAST3+1
  CLC
  ADC #C1
  CMP RAST4+1
  BCC NSAME3
  LDY #$4C
NSAME3  STY BRA3
  LDA CORDNT,X
  STA SPR4+1  ; NUMBER
  LDA CORDN1,X
  STA SPR42+1
  LDA BLP,X ; BOTTOM LEFT
  STA POV4+1  ; SPRITE
  LDA BRP,X ; BOTTOM RIGHT
  STA POV42+1 ; SPRITE
  LDA WHSPR,X ; POINTER
  STA POI4+1  ; VALUE
  LDA WHSPR1,X
  STA POI42+1
  LDA WHSPRB,X
  STA POI4+4
  LDA WHSPRB1,X
  STA POI42+4
  ; *********** 5 ************
  LDA YTABLE+4
  JSR SORT
  LDY #$2C
  STA RAST5+1 ; VALUE
  LDA CORDS,X
  STA CORD5+1
  LDA RAST4+1
  CLC
  ADC #C1
  CMP RAST5+1
  BCC NSAME4
  LDY #$4C
NSAME4  STY BRA4
  LDA CORDNT,X
  STA SPR5+1  ; NUMBER
  LDA CORDN1,X
  STA SPR52+1
  LDA BLP,X ; BOTTOM LEFT
  STA POV5+1  ; SPRITE
  LDA BRP,X ; BOTTOM RIGHT
  STA POV52+1 ; SPRITE
  LDA WHSPR,X ; POINTER
  STA POI5+1  ; VALUE
  LDA WHSPR1,X
  STA POI52+1
  LDA WHSPRB,X
  STA POI5+4
  LDA WHSPRB1,X
  STA POI52+4
  ; *********** 6 ************
  LDA YTABLE+5
  JSR SORT
  LDY #$2C
  STA RAST6+1 ; VALUE
  LDA CORDS,X
  STA CORD6+1
  LDA RAST5+1
  CLC
  ADC #C1
  CMP RAST6+1
  BCC NSAME5
  LDY #$4C
NSAME5  STY BRA5
  LDA CORDNT,X
  STA SPR6+1  ; NUMBER
  LDA CORDN1,X
  STA SPR62+1
  LDA BLP,X ; BOTTOM LEFT
  STA POV6+1  ; SPRITE
  LDA BRP,X ; BOTTOM RIGHT
  STA POV62+1 ; SPRITE
  LDA WHSPR,X ; POINTER
  STA POI6+1  ; VALUE
  LDA WHSPR1,X
  STA POI62+1
  LDA WHSPRB,X
  STA POI6+4
  LDA WHSPRB1,X
  STA POI62+4
  ; *********** 7 ************
  LDA YTABLE+6
  JSR SORT
  LDY #$2C
  STA RAST7+1 ; VALUE
  LDA CORDS,X
  STA CORD7+1
  LDA RAST6+1
  CLC
  ADC #C1
  CMP RAST7+1
  BCC NSAME6
  LDY #$4C
NSAME6  STY BRA6
  LDA CORDNT,X
  STA SPR7+1  ; NUMBER
  LDA CORDN1,X
  STA SPR72+1
  LDA BLP,X ; BOTTOM LEFT
  STA POV7+1  ; SPRITE
  LDA BRP,X ; BOTTOM RIGHT
  STA POV72+1 ; SPRITE
  LDA WHSPR,X ; POINTER
  STA POI7+1  ; VALUE
  LDA WHSPR1,X
  STA POI72+1
  LDA WHSPRB,X
  STA POI7+4
  LDA WHSPRB1,X
  STA POI72+4
  ; *********** 8 ***********
  LDA YTABLE+7
  JSR SORT
  LDY #$2C
  STA RAST8+1 ; VALUE
  LDA CORDS,X
  STA CORD8+1
  LDA RAST7+1
  CLC
  ADC #C1
  CMP RAST8+1
  BCC NSAME7
  LDY #$4C
NSAME7  STY BRA7
  LDA CORDNT,X
  STA SPR8+1  ; NUMBER
  LDA CORDN1,X
  STA SPR82+1
  LDA BLP,X ; BOTTOM LEFT
  STA POV8+1  ; SPRITE
  LDA BRP,X ; BOTTOM RIGHT
  STA POV82+1 ; SPRITE
  LDA WHSPR,X ; POINTER
  STA POI8+1  ; VALUE
  LDA WHSPR1,X
  STA POI82+1
  LDA WHSPRB,X
  STA POI8+4
  LDA WHSPRB1,X
  STA POI82+4
  ; ************ 9 **********
  LDA YTABLE+8
  JSR SORT
  LDY #$2C
  STA RAST9+1 ; VALUE
  LDA CORDS,X
  STA CORD9+1
  LDA RAST8+1
  CLC
  ADC #C1
  CMP RAST9+1
  BCC NSAME8
  LDY #$4C
NSAME8  STY BRA8
  LDA CORDNT,X
  STA SPR9+1  ; NUMBER
  LDA CORDN1,X
  STA SPR92+1
  LDA BLP,X ; BOTTOM LEFT
  STA POV9+1  ; SPRITE
  LDA BRP,X ; BOTTOM RIGHT
  STA POV92+1 ; SPRITE
  LDA WHSPR,X ; POINTER
  STA POI9+1  ; VALUE
  LDA WHSPR1,X
  STA POI92+1
  LDA WHSPRB,X
  STA POI9+4
  LDA WHSPRB1,X
  STA POI92+4

  LDA TOGGLE
  BEQ POWER
  JSR OSSIL
POWER LDA #%00000000
  STA EXPANDX
  STA EXPANDY
SPCP  LDA #0  ; BLACK
  STA SPC0
  STA SPC1
PHY0  LDA #51 ; AND THERE Y CORDS
  STA Y0
PHY1  LDA #53
  STA Y1
  BIT BALLON  
  BMI SPV0
  BIT HELDIR
  BPL FACR
  LDA #24+SS0
  +NOPP
FACR  LDA #28+SS0
  CLC
  ADC OSIL
  STA SPV0+1
  BIT HELDIR+1
  BPL FACR2
  LDA #32+SS0
  +NOPP
FACR2 LDA #36+SS0
  CLC
  ADC OSIL
  STA SPV1+1
  LDA TOGGLE
  EOR #1
  STA TOGGLE
  BEQ NEXO
  LDA HELDLY
  BEQ ATNU
  DEC HELDLY
  JMP SECO  
ATNU  LDX #0
  LDA HELDIR
  JSR XADD
SECO  LDA HELDLY+1
  BEQ ATN2
  DEC HELDLY+1
  JMP NEXO
ATN2  LDX #1
  LDA HELDIR+1
  JSR XADD
NEXO  LDA XCORD+0
  STA POKE1+1
  LDA XCORD+1
  STA POKE2+1

SPV0  LDA #BL
  STA SPRITE0A
  STA SPRITE0B
SPV1  LDA #BL
  STA SPRITE1A
  STA SPRITE1B
POKE1 LDA #255  ; HIRES HELLI OR
  STA X0    
POKE2 LDA #255  ; BALLON
  STA X1
  LDA #0
  STA IRQTEMP
  LDA HEX0  ; HELI 0
  ASL ;Implied A
  STA NX6+1 
  ROR IRQTEMP
  LDA HEX1  ; HELI 1
  ASL ;Implied A
  STA NX7+1
  ROR IRQTEMP 


  LDA X+0   ; APE 0
  ASL ;Implied A
  ROR IRQTEMP
  STA X2
  LDA X+0   ; APE 0
  CLC
AX0 ADC #0
  ASL ;Implied A
  ROR IRQTEMP
  STA X3

  LDA X+1   ; APE 1
  ASL ;Implied A
  ROR IRQTEMP
  STA X4
  LDA X+1   ; APE 1
  CLC
AX1 ADC #0
  ASL ;Implied A
  ROR IRQTEMP
  STA X5

  LDA X+2   ; APE 2
  ASL ;Implied A
  ROR IRQTEMP
  STA X6
  LDA X+2   ; APE 2
  CLC
AX2 ADC #0
  ASL ;Implied A
  ROR IRQTEMP
  STA X7

  LDA IRQTEMP
  STA NMSB+1  ; NMI MSB
  AND #%11111100
HMSB  ORA #0    ; SMC SMALL HELI
  STA MSB
  BIT HELLI ; HELLI
  BPL DNMOV ; AND TRANSPORT
  JSR UPHEL0  
  JSR UPHEL1  
DNMOV BIT CARS
  BPL DNMOV2
  BVS DNMOV2  ; BEING HIT
  LDA #0
  STA BLH
  LDA TRANX
  CLC
CARB
  ADC #1  ; DIRECTION  1 / 255
  CMP #172
  BCC SD
  CMP #0-24 ; VERY LEFT EDGE
  BCS SD  
  LDA #0  ; CHECK IN MAIN LOOP
  STA CARB+1
  LDA #0-24
SD
  STA TRANX
  ASL ;Implied A
  STA NX72+1
  ROL BLH
  LDA TRANX
  CLC
  ADC #12
  ASL ;Implied A
  STA NX62+1
  ROL BLH
  LDA IRQTEMP ; LAST BIT SET
  AND #%11111100  ; APES ONLY
  ORA BLH   ; ADD TRANSPORT
  STA NMSB2+1 ; SECOND NMI    

DNMOV2
  LDX IRQHOLD+1
  LDY IRQHOLD+2
  LDA #>IRQ
  STA $FFFE
  LDA #<IRQ
  STA $FFFF
  LDA #0
  STA RASTER
  LDA IRQHOLD
  RTI

OSSIL LDA OSIL
  CLC
  ADC OSAD
  CMP #255
  BEQ CRUM
  CMP #4
  BEQ CRUM2
  STA OSIL
  RTS

CRUM2 LDA #2
  STA OSIL
  LDA #255
  STA OSAD
  RTS

CRUM  LDA #1
  STA OSIL
  STA OSAD
  RTS
  
SORT
  CMP YTABLE+8  ; VERY QUICK
  BCC LES8  ; SORT ROUTINE
  LDX #8
  LDA YTABLE+8
LES8
  CMP YTABLE+7
  BCC LES7
  LDX #7
  LDA YTABLE+7
LES7
  CMP YTABLE+6
  BCC LES6
  LDX #6
  LDA YTABLE+6
LES6
  CMP YTABLE+5  
  BCC LES5
  LDX #5
  LDA YTABLE+5
LES5
  CMP YTABLE+4
  BCC LES4
  LDX #4
  LDA YTABLE+4
LES4  CMP YTABLE+3
  BCC LES3
  LDX #3
  LDA YTABLE+3
LES3
  CMP YTABLE+2
  BCC LES2
  LDX #2
  LDA YTABLE+2
LES2
  CMP YTABLE+1
  BCC LES1
  LDX #1
  LDA YTABLE+1
LES1
  CMP YTABLE+0
  BCC LES0
  LDX #0
  LDA YTABLE+0
LES0
  LDY #255
  STY YTABLE+0
  RTS

XADD  BMI XMIN
  CLC
  ADC XCORD,X
  STA XCORD,X
  BCC STILON  ; NOT OVER 256
  LDA HMSB+1  ; ELSE SET
  ORA ONTAB,X ; MSB OF
  STA HMSB+1  ; CORDINATE
  RTS

STILON  LDA XCORD,X
  CMP #>344 ; 344
  BCC STON  ; LESS THAN
  LDA ONTAB,X ; IGNORE IT
  AND HMSB+1  ; IF MSB SET
  BEQ STON  ; RESET POS.
  LDA #>344 ; PUT BACK
  STA XCORD,X ; TO EDGE
  LDA HELDIR,X
  EOR #254
  STA HELDIR,X
  JSR RAND
  ORA #1
  STA HELDLY,X
STON  RTS

XMIN  EOR #-1
  CLC
  ADC #1
  STA JOY
  LDA XCORD,X
  SEC
  SBC JOY
  STA XCORD,X
  BCS NOMS
  LDA HMSB+1
  AND OFTAB,X
  STA HMSB+1
  RTS

NOMS  LDA XCORD,X
  CMP #1
  BCS STION
  LDA ONTAB,X
  AND HMSB+1  ; IF MSB SET
  BNE STION ; DONT RESET
  LDA #1    ; PUT BACK
  STA XCORD,X ; TO EDGE
  LDA HELDIR,X
  EOR #254
  STA HELDIR,X
  JSR RAND
  ORA #1
  STA HELDLY,X
STION RTS

ONTAB !byte %00000001
  !byte %00000010

OFTAB !byte %11111110
  !byte %11111101

WHSPR !byte >SPRITE2A
  !byte >SPRITE2A
  !byte >SPRITE2A
  !byte >SPRITE4A
  !byte >SPRITE4A
  !byte >SPRITE4A
  !byte >SPRITE6A
  !byte >SPRITE6A
  !byte >SPRITE6A

WHSPR1  !byte >SPRITE3A
  !byte >SPRITE3A
  !byte >SPRITE3A
  !byte >SPRITE5A
  !byte >SPRITE5A
  !byte >SPRITE5A
  !byte >SPRITE7A
  !byte >SPRITE7A
  !byte >SPRITE7A

WHSPRB  !byte >SPRITE2B
  !byte >SPRITE2B
  !byte >SPRITE2B
  !byte >SPRITE4B
  !byte >SPRITE4B
  !byte >SPRITE4B
  !byte >SPRITE6B
  !byte >SPRITE6B
  !byte >SPRITE6B

WHSPRB1 !byte >SPRITE3B
  !byte >SPRITE3B
  !byte >SPRITE3B
  !byte >SPRITE5B
  !byte >SPRITE5B
  !byte >SPRITE5B
  !byte >SPRITE7B
  !byte >SPRITE7B
  !byte >SPRITE7B

CORDNT
  !byte 5,5,5,9,9,9,13,13,13
CORDN1
  !byte 7,7,7,11,11,11,15,15,15  
BLP
  !byte SO0+2,SO0+4,BL
  !byte SO1+2,SO1+4,BL
  !byte SO2+2,SO2+4,BL
BRP
  !byte SO0+3,SO0+5,BL
  !byte SO1+3,SO1+5,BL
  !byte SO2+3,SO2+5,BL


AIR LDA #255
  STA THCOL+1
  STA BALLON
  LDA #0
  STA X
  STA X+1
  STA X+2
  STA AX0+1
  STA AX1+1
  STA AX2+1
  LDA #1
  STA SPCP+1
  LDA #40+SS0 ; AIR
  STA SPV1+1  ; BALLON
  LDA #41+SS0               
  STA SPV0+1
  LDA #0
  STA HMSB+1
  STA HELLI
  STA CARS
  LDA #BL
  STA NP6+1
  STA NP7+1
  JSR INITIALISE
  JSR DRAWBUILD
  JSR DRAWBUILD
  LDA #%00011011
  STA VICCR1
  LDX #0  
  LDA #12
  STA AX0+1
  JSR THISI
  LDX #1
  LDA #12
  STA AX1+1
  JSR THISI
  LDX #2
  LDA #12
  STA AX2+1
  JSR THISI
  LDA #0
  STA BALLON
  STA HMSB+1
  STA SPCP+1
  LDA #51
  STA PHY0+1
  LDA #53
  STA PHY1+1
  LDA #%11111100
  STA THCOL+1
  LDA #1
  STA ACTION+0
  LDA #128
  STA HELLI
  STA CARS
  RTS


THISI  LDA #0
  STA BLX
  STA X,X
  LDA #255
  STA DIR,X
  LDA #55   ; 52
  STA PHY0+1
  STA PHY1+1
  LDA #55+15  ; 52+15
  STA Y,X
  LDA #$19  ; FALLING
  STA FRAME,X
  STX MIKE1
  JSR CREATE
  JSR COPYB0
  LDX MIKE1
BOUBLE  LDA #0
  STA BLH
  LDA BLX
  CLC
  ADC #1
  STA BLX
  ASL ;Implied A
  STA POKE2+1
  ROL BLH
  LDA BLX
  CLC
  ADC #12
  ASL ;Implied A
  STA POKE1+1
  ROL BLH
  LDA BLH
  STA HMSB+1
  LDA X,X
  CMP DROPXC,X
  BEQ ATTOY
  CLC
  ADC #1
  STA X,X
  JMP DX
ATTOY LDA FRAME,X
  CMP #$1F
  BEQ ALT
  LDA #$1F
  STA FRAME,X
  STX MIKE1
  JSR CREATE
  LDX MIKE1
ALT LDA PHY0+1
  SEC
  SBC #1
  CMP #10
  BCS SDD3
  LDA #0
  STA BLX ; TO START
  BEQ SDD
SDD3  STA PHY0+1
SDD STA PHY1+1
  LDA Y,X
  CLC
  ADC #2
  STA Y,X
  CMP #189+7
  BCS EXF
DX  LDA SYNC
REW CMP SYNC
  BEQ REW
  JMP BOUBLE
EXF LDA #0    ; STAND $ STARE
  STA FRAME,X
  JMP CREATE

DROPXC  !byte 50,70,90


  ; CALL SOUND WITH
  ; A=FX, X=CHANNEL
  ; CALL FX IN INTS

TFLAG !byte 0
TRCOUNT !byte 0
TNT
XOR !byte 0
XTEMP1  !byte 0
SNDFLAG !byte 0,0,0
INDEX !byte 0,7,$0E
FREQ  !byte 0,0,0
WAVE  !byte 0,0,0
AD  !byte 0,0,0
SR  !byte 0,0,0
SWEEP !byte 0,0,0
FFREQ !byte 0
FTYPE !byte 0,0,0
CHANNEL !byte 0
FTEMP !byte 0
FREQDEC !byte 0,0,0

SOUND
  ASL ;Implied A
  ASL ;Implied A
  ASL ;Implied A
  STA XTEMP1
FND0  STX CHANNEL
  LDY INDEX,X
  LDA WAVE,X
  AND #254
  STA $D404,Y
  LDX XTEMP1
  LDY CHANNEL
  LDA #100
  STA FTEMP
  LDA DATA,X
  STA FREQ,Y
  LDA DATA+1,X
  STA SNDFLAG,Y
  LDA DATA+2,X
  STA WAVE,Y
  LDA DATA+3,X
  STA FTYPE,Y
  ORA #15
  STA $D418
  LDA #$FF
  STA $D417
  LDA DATA+4,X
  STA FFREQ
  STA $D416
  LDA DATA+5,X
  STA AD,Y
  LDA DATA+6,X
  STA SR,Y
  LDA DATA+7,X
  STA FREQDEC,Y
  LDX INDEX,Y
  LDA WAVE,Y
  STA $D404,X
  LDA AD,Y
  STA $D405,X
  LDA SR,Y
  STA $D406,X
  LDA FREQ,Y
  STA $D401,X
  RTS
STARTTRAN INC TFLAG
  RTS

XTEMP2  !byte 0
FX  LDX #2
FXLP1 STX XTEMP2
  LDA SNDFLAG,X
  BNE FND2
NXT LDX XTEMP2
  DEX
  BPL FXLP1
NFSW  RTS

FND2  DEC SNDFLAG,X
  BEQ CANCEL
  LDA FREQ,X
  CLC
  ADC FREQDEC,X
  STA FREQ,X
  LDY INDEX,X
  STA $D401,Y
  DEC FFREQ
  LDA FFREQ
  STA $D416
  JMP NXT

CANCEL  LDY INDEX,X
  LDA WAVE,X
  AND #254
  STA $D404,Y
  JMP NXT

  ; FREQ =0 TO 255
  ; NINTS =1 TO 6
  ; WAVE 17,33,129
  ; FTYPE 16,32,64
  ; FFREQ =FREQ OR CUT OFF
  ; AD  0 INSTANT ,DECAY 0-15
  ; SR  0          AS ABOVE
  ; FREQDEC  ,+- ADD

;FREQ,NINTS,WAVE,FTYPE,FFREQ,AD,SR,FREQDEC

DATA
  !byte 30,1,129,32,35,15,11,30
  !byte 80,4,129,32,70,12,9,10
  !byte 50,2,129,32,50,8,9,64
  !byte 40,3,129,0,100,10,10,20
  !byte 100,3,17,32,100,10,10,0
