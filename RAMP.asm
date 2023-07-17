!to "rampage.prg",cbm

*=$0801 
!byte $0c,$08,$01,$00,$9e,$34,$30,$39,$36,$00,$00,$00,$00,$00  ; 1 sys 4096 ;basic loader
;!byte $0c,$08,$01,$00,$9e,$33,$30,$37,$32,$30,$00,$00,$00,$00  ; 1 sys 30720, $7800 ;basic loader

; stop getting warnings about unused label
!nowarn w1000

!macro NOPP
  !byte $2C
!end

*=$1000 ; start address for 6502 code
jmp MAIN

;*=$7800
;jmp MAIN


!source "ram-map.asm"
;!source "ramp.asm"
;!PSEUDOPC $7800
!source "build.asm"
!source "irq.asm"
!source "debug.asm"
!source "copy.asm"
!source "djcode.asm"
!source "move.asm"
!source "dis.asm"
!source "ape0.asm"
!source "ape1.asm"
!source "ape2.asm"

; RAMP
MAIN
  SEI
  LDX #255
  TXS
  LDY #2
  LDA #0
  STA VIC_SPRITE_ENABLE
  
.ZEROP ; Start at $00, offset 2 and set all zero page to 0
  STA D6510,Y
  INY
  BNE .ZEROP
  
  LDA #%00100101 ; bank the kernal rom out
  STA R6510
  ;LDA #%1001 0101  ; VIC Bit 1-0 = $01 which is Bank2, BANK2=$8000-$BFFF
  LDA #%10010100  ; VIC Bit 1-0 = $00 which is Bank3, BANK3=$C000-$FFFF
  STA CIA2
  ;LDA #%11011000  ; CHAR $2000 offset in VIC bank, SCREEN $3400 offset, CHAR=$E000 SCREEN=$F400
  LDA #%11101000  ; CHAR $2000 offset in VIC bank, SCREEN $3800 offset, CHAR=$E000 SCREEN=$F800
  STA VIC_MEMORY_CONTROL_REGISTER 
  LDA #%11011000
  STA VIC_CONTROL_REGISTER2 ; Set Vic Control Register 2, No horizontal scroll, 40 Column + Multicolor On
  LDA #%00000011  ; BLANK OUT
  STA VIC_CONTROL_REGISTER1 ; Set Vic Control Register 1, Vertical Scroll, 24 row, Screen OFF, Text mode
  ; update non-maskable interrupt service routine
  LDA #<NMIA
  STA $FFFA
  LDA #>NMIA
  STA $FFFB
  ; update cold reset routine
  LDA #<RESET
  STA $FFFC
  LDA #>RESET
  STA $FFFD
  ; update interrupt service routine
  LDA #<IRQ
  STA $FFFE
  LDA #>IRQ
  STA $FFFF
  LDA #1
  STA VICIMR ; Set Vic Interrupt Control Register, Sprite-background collision interrupt enabled
  LDA #$7F
  STA CIA1+13
  STA CIA2+13
  LDA CIA1+13
  LDA CIA2+13
  LDA #0
  STA CIA1+14
  STA CIA1+15
  STA CIA2+14
  STA CIA2+15
  STA NMSB+1
  STA NMSB2+1
  STA BALLON
  STA HEX0
  STA HEX1
  STA XCORD+0
  STA XCORD+1
  STA CIA1+2      ; ELSE DOWN = 1
  STA RASTER
  STA APECOUNT    ; ?
  STA TOGGLE
  STA OSIL
  STA HELLI       ; STOP BIG ONES 
  CLI ; clear interrupt disable (allow interrupts)
  JSR SCREENWIPE ; NYBBLES
  JSR CRUM
  LDY #62
  LDA #0
  
.BKANSP
  STA BL*64+BANK,Y
  STA 253*64+BANK,Y     ; ON
  STA 254*64+BANK,Y     ; BORDER
  TEMP = ((SO0+0)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO0+1)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO0+2)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO0+3)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO0+4)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO0+5)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO1+0)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO1+1)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO1+2)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO1+3)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO1+4)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO1+5)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO2+0)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO2+1)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO2+2)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO2+3)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO2+4)*64+BANK)
  STA TEMP,Y
  TEMP = ((SO2+5)*64+BANK)
  STA TEMP,Y  
  DEY
  BPL .BKANSP
  LDA #0
  STA BORDER ; set border black 
  STA COLOUR0
  STA PRIORITY
  LDA #11
  STA COLOUR1
  LDA #15
  STA COLOUR2
  LDA #7
  STA COLOUR3
  LDA #189+7
  STA Y+0
  STA Y+1
  STA Y+2
  LDA #%00111111
  STA MULTICOL
  LDA #7
  STA MULTI0
  LDA #11
  STA MULTI1
  LDA #2
  STA SPC0
  STA SPC1
  LDA #8
  STA SPC2
  STA SPC3
  LDA #14
  STA SPC4
  STA SPC5
  LDA #5
  STA SPC6
  STA SPC7
  LDA #1
  STA HELDIR
  STA HELDIR+1
  LDA #0
  STA XCORD+0
  STA XCORD+1
  LDA #50
  STA HELDLY+0
  LDA #250
  STA HELDLY+1
  LDA #0
  STA XCORD
  STA XCORD+1
  STA DIR+0       ; DIRECTION
  STA DIR+1       ; FACEING
  STA DIR+2
  STA FRAME+0     ; SPRITE FRAME
  STA FRAME+1
  STA FRAME+2
  STA STEP+0      ; WALK FRAME
  STA STEP+1
  STA STEP+2
  STA COUNT+0     ; COUNTER FOR
  STA COUNT+1     ; ANIMATION
  STA COUNT+2
  STA HUSED0
  STA HUSED1
  LDA #1          ; 1 WALK
  STA ACTION+0    ; DOING WHAT
  STA ACTION+1    ; ACTION
  STA ACTION+2
  JSR INITIALISE
  JSR FIRS0
  JSR FIRS1
  LDA #%11111111
  STA VIC_SPRITE_ENABLE
  JSR AIR
LOOP
  JSR JOYGET      ; JOYGET !!
  LDX #0
  JSR MOVE
  LDX #1
  JSR MOVE
  LDX #2
  JSR MOVE
  JSR SET0
  JSR SET1
  LDA CARB+1
  BNE EAR
  JSR NEWO       
EAR
  JSR DRAWBUILD
  LDA SYNC
SMO
  CMP SYNC
  BEQ SMO
  JMP LOOP

AWALK     = 1   ; WALKING
APUNCHW   = 2   ; PUNCH GROUND
ACLIMB    = 3   ; CLIMB
APUNCHC   = 4   ; PUNCH CLIMB
AJUMP     = 5   ; JUMP
AGRAWL    = 6   ; GRAWLING
AOUCH     = 7   ; BEING HIT
ASUPRISE  = 8
ATRANS    = 9
ADIE      = 10
ASTARE    = 11
AFALL     = 12
AGROWL    = 13
AEAT      = 14
ADEAD     = 15
        ; DIRECTION 0 FACING LEFT
ACTTABL 
        !byte <WALK
        !byte <PUNCHW
        !byte <CLIMB
        !byte <PUNCHC
        !byte <JUMP
        !byte <GRAWL
        !byte <OUCH
        !byte <SUPRISE
        !byte <TRANS
        !byte <DIE
        !byte <STARE
        !byte <FALL
        !byte <GROWL
        !byte <EAT
        !byte <DEAD
ACTTABH
        !byte >WALK
        !byte >PUNCHW
        !byte >CLIMB
        !byte >PUNCHC
        !byte >JUMP
        !byte >GRAWL
        !byte >OUCH
        !byte >SUPRISE
        !byte >TRANS
        !byte >DIE
        !byte >STARE
        !byte >FALL
        !byte >GROWL
        !byte >EAT
        !byte >DEAD
ENDLABEL1

MOVE
  LDY ACTION,X
  LDA ACTTABL-1,Y
  STA SOMET+1
  LDA ACTTABH-1,Y
  STA SOMET+2
   
SOMET
  JSR $FFFF       ; SMC ; 2023/06/26 J.Baldock - Jump to interrupt service routine
  LDA ACTION,X    
  CMP #ADEAD
  BNE AST
  RTS
AST
  JSR KILCAR
  LDA ACTION,X
  CMP #AWALK
  BEQ CANBE
  CMP #ACLIMB
  BNE MOVM
CANBE
  STA LASTA,X
  JSR ANYKEY      ; IF NO
  BNE MOVM        ; MOVEMENT
  LDA #ASTARE     ; DO A DELAY
  STA ACTION,X
MOVM
  JMP CREATE    

;BLOCK           ; ACTION 1

WALK
  JSR WA
  JSR CLIM
CHECKF
  LDA Y,X
        CMP #189+7      ; IF ON GROUND
        BCS ATB ; DONT FALL
        JSR MODEL
        BCS NFAL
        LDA FIRE,X
        BNE FALO
        LDA DOWN,X
        BEQ FALO
        LDA DIR,X       ; BACK DOWN
        EOR #-1         ; LEFT
        STA DIR,X       ; OR
        BMI FROML
        LDA X,X
        CLC
        ADC #4
        STA X,X
FROML   LDA #ACLIMB     ; RIGHT SIDE
        STA ACTION,X    ; OF BUILDING
        LDA Y,X 
        CLC
        ADC #3*8
        STA Y,X
        LDA X,X
        AND #%11111100
        STA X,X
        RTS

ATB     LDA #189+7
        STA Y,X
        RTS

FALO    LDA #12
        STA FRAME,X
        LDA #AFALL
        STA ACTION,X
NFAL    RTS

WA      LDA FIRE,X      ; IF KEY
        BEQ JUWA        ; WITH FIRE
        LDA LEFT,X      ; PRESS
        ORA RIGHT,X     ; THEN DO
        ORA UP,X        ; A PUNCH
        ORA DOWN,X      ; OF SOME SORT
        BEQ OOR 
        JMP TRYP1

OOR     LDA #AJUMP      ; FIRE ONLY
        STA ACTION,X
        LDA #$20        ; JUMP FRAME
        STA FRAME,X
        LDA #0
        STA COUNT,X
        PLA
        PLA
        RTS

JUWA    LDA LEFT,X
        BEQ NOM1
        LDA DIR,X
        BPL ALSET
        INC DIR,X
ALSET
  JMP WALKL       ; WALK LEFT

NOM1
  LDA RIGHT,X
;BLOCK
  BEQ OFFB
  LDA DIR,X
  BMI .ALSET
  DEC DIR,X
.ALSET
  JMP WALKR

WALKL   JSR WALKY       ; LEFT
        LDA X,X
        SEC
        SBC #2
        STA X,X
        RTS
WALKR   JSR WALKY       ; RIGHT
        LDA X,X
        CLC
        ADC #2
SAVEM
  STA X,X
  RTS


CLIM    JSR CLIMBCHECK
        BCS OFFB
        ; PUT INTO SIDE OF BUILDING
        LDA TMP ; 255 LEFT 0 RIGHT
        BEQ RIGHTS
        LDA DIR,X
        BMI NOCH
        LDA #-8
        JMP GOTV
RIGHTS  LDA DIR,X
        BPL MINS
        LDA #12
        +NOPP
MINS    LDA #4
GOTV    CLC
        ADC X,X
        STA X,X
NOCH    LDA X,X
        AND #%11111100
        STA X,X
        LDA TMP         ; NEW DIRECTION
        STA DIR,X
        LDA #$1B
        STA FRAME,X
        LDA #ACLIMB
        STA ACTION,X
        LDA #0
        STA COUNT,X
OFFB    RTS

HANDWATER       
        LDA WATERPOINT
        BNE OFFB
        LDA Y,X
        CMP #189+7
        BCC NOTIN
        LDA X,X
        CMP #10*4
        BCC NOTIN
        CMP #16*4
        BCS NOTIN
        LDA #$06
        STA FRAME,X
        SEC
        RTS
NOTIN   CLC
        RTS
WALKY
        JSR HANDWATER
        BCC WALKFINE
        RTS
WALKFINE
        LDA STEP,X
        CLC
        ADC #1
        CMP #4*4
        BCC LESS
        LDA #0
LESS   
  STA STEP,X
  LSR ;Implied A
  LSR ;Implied A
  CLC
  ADC #8  
  STA FRAME,X
NOM
  RTS

OYT0    !byte 6,2,3,3
OXT1    !byte 0,-2,-2,-4
OXT2    !byte -1,2,2,4

FISTPO  LDY HANDY,X
        LDA Y,X
        LSR ;Implied A
        LSR ;Implied A
        LSR ;Implied A
        SEC
        SBC OYT0,Y
        STA FISY,X
        LDA X,X
        LSR ;Implied A
        LSR ;Implied A
        STA XTEMP
        LDA DIR,X
        BPL SBIT
        LDA OXT2,Y
        JMP SUPER
SBIT    LDA OXT1,Y
SUPER   CLC
        ADC XTEMP
        STA FISX,X
        RTS

HITHEL  JSR CHK0
        BCS SDF ; OUT OF RANGE
        LDA HEACT0
        CMP #8
        BEQ SDF
        JSR HITC        ; FIRST HELI
        BCC SDF
        LDY #8
        LDA HEX0
        STA HECXT1+8
        LDA HEY0
        STA HECYT1+8
        JMP EXPI0
SDF     JSR CHK1
        BCS SPF ; OUT OF RANGE
        LDA HEACT1
        CMP #8
        BEQ SPF
        JSR HITC
        BCC SPF
        LDY #8
        LDA HEX1
        STA HECXT1+8
        LDA HEY1
        CLC
        ADC #20
        STA HECYT1+8
        JMP EXPI1
SPF
  RTS

HITC
  LDA YTEMP       ; HELI CHR CORD
  CMP FISY,X      ; APE HAND
  BEQ JOL
  CLC
  ADC #1
  CMP FISY,X
  BNE CANN

JOL
  LDA XTEMP
  CMP FISX,X
  BEQ CAN
  CLC
  ADC #1
  CMP FISX,X
  BEQ CAN

CANN
  CLC     ; MISSED
  RTS     

CAN
  SEC     ; HIT
  RTS

CHK0
  LDA HEY0
  LSR ;Implied A   
  LSR ;Implied A
  LSR ;Implied A
  SEC
  SBC #5
  STA YTEMP
  LDA HEX0
  CMP #8
  BCC EXI
  CMP #$9E
  BCS EXI
  LSR ;Implied A
  LSR ;Implied A
  SEC
  SBC #2
  STA XTEMP
  CLC
  RTS

CHK1
  LDA HEY1
  LSR ;Implied A
  LSR ;Implied A
  LSR ;Implied A
  SEC
  SBC #5
  STA YTEMP
  LDA HEX1
  CMP #8
  BCC EXI
  CMP #$9E
  BCS EXI
  LSR ;Implied A
  LSR ;Implied A   
  SEC
  SBC #2
  STA XTEMP
  CLC
  RTS

EXI
  SEC
  RTS
                ; PUNCH FOR WALKING
TRYP1
  LDA LEFT,X
  BEQ TRR
  LDA DIR,X
  BNE EXI ;NOTHN  ; BACKP
  BEQ THIW1

TRR
  LDA RIGHT,X
  BEQ TRR2
  LDA DIR,X
  BEQ EXI;        NOTHN   ; BACKP 
  BNE THIW1

TRR2
  LDA UP,X
  BEQ GOTTB1
  LDY #0
  LDA #$18        ; PUNCH UP
  JMP STF

GOTTB1
  LDA #7          ; PUNCH DOWN
  LDY #1
  JMP STF

THIW1
  LDA #4          ; PUNCH LEFT
  LDY #2
  JMP STF

BACKP
  LDA #$16        ; PUNCH RIGHT
  LDY #3

STF
  STA FRAME,X
  TYA
  STA HANDY,X     ; WHAT POS
  LDA #APUNCHW
  STA ACTION,X
  LDA #0
  STA COUNT,X
  JSR HIT ; PUNCH WHAT
  JSR FISTPO
  JSR DETEC2
  JMP HITHEL
  
TC
  RTS
        
PUNCHW
  LDA FIRE,X
  BNE TC
  LDA COUNT,X
  CLC
  ADC #1
  CMP #1  ; 3
  BCC STEX        
  LDA #0
  STA COUNT,X
  LDA #8          ; ACTION 2
  STA FRAME,X
  LDA #AWALK      ; BACK TO WALK
  STA ACTION,X

STEX
  STA COUNT,X
  RTS

CLIMBCHECK
        LDA FIRE,X
        BNE CRUNCH
        LDA UP,X
        ;BEQ EXI
        BNE *+5
        JMP EXI
        JSR SIDE
        BCC OFE
        RTS     ; C=1 UNDER

OFE     LDA DIR,X
        BMI HER
        LDA X,X
        SEC
        SBC #8
        JMP DS
HER     LDA X,X
DS      LSR ;Implied A
        LSR ;Implied A
        CLC
        ADC #1
        STA TMP
        LDY #7
.GETL    LDA SBTOP,Y
        CMP Y,X
        BCS NOTW
        LDA SBXSTART,Y
        CMP TMP
        BEQ ONBEG
        LDA SBXEND,Y
        CMP TMP
        BEQ ONEND
NOTW    DEY
        BPL .GETL
CRUNCH  SEC
        RTS

ONBEG
  LDA #255        ; DIRECTION
  +NOPP            ; FACEING

ONEND
  LDA #0
        STA TMP
        TYA
        STA MONONB,X
        LDA SBXSTART,Y
        ASL ;Implied A   
        ASL ;Implied A
        STA ONBX,X
        LDA SBXEND,Y
        ASL ;Implied A
        ASL ;Implied A
        STA ONBX1,X
        CLC
        RTS

SIDE    LDA Y,X         
        SEC
        SBC #5*8
        LSR ;Implied A           
        LSR ;Implied A
        LSR ;Implied A
        TAY
        LDA DIR,X
        BPL TO2
        LDA #4
        +NOPP
TO2     LDA #-4
        CLC
        ADC X,X
        LSR ;Implied A
        LSR ;Implied A
        JSR MEMXY
        LDY #0
        LDA MIKE1,Y
        CMP #$0C
        BEQ TH
        CMP #$0D
        BEQ TH
        CMP #$0F
        BEQ TH
        CMP #$10
        BEQ TH
        CMP #$40
        BEQ TH
        CMP #$41
        BEQ TH
        CMP #$25        ; $25   
        BCC NOT         ; TO $28
        CMP #$29
        BCC TH
        CMP #$46        
        BEQ TH
        CMP #$47
        BEQ TH
        CMP #$53        ; $53
        BCC NOT         ; TO $73
        CMP #$74
        BCC TH
NOT     SEC
        RTS

TH      CLC
        RTS

;BLOCK

CLIMB   LDA FIRE,X      ; ACTION 3
        BEQ JOM
        LDA RIGHT,X
        ORA LEFT,X
        ORA UP,X
        ORA DOWN,X
        ;BNE TRYP2       ; A PUNCH
        BEQ *+5
        JMP TRYP2
        LDA #AFALL      ; IF NO DIR
        STA ACTION,X    ; FALL ALL
        LDA DIR,X       ; BUILDING
        BPL AD4
        LDA #-4
        +NOPP
AD4     LDA #4  
        CLC
        ADC X,X
        STA X,X
        RTS

JOM     LDA UP,X        
        BEQ THW
        LDA #-4
        JMP FRE
THW     LDA DOWN,X      
        BEQ LES
        LDA #4  
FRE     STA TMP
        LDA FIRE,X
        BNE TRYP2
        LDA Y,X 
        CLC
        ADC TMP
        STA Y,X
        CMP #189+7
        BCC BWL
        LDA #189+7
        STA Y,X
        JMP BATW
BWL     LDA MONONB,X
        TAY
        LDA Y,X
        CMP SBTOP,Y
        BCS LEST
        LDA DIR,X       ; PUT ON
        BPL SBI         ; TOP OF
        LDA #8  ; BUILDING
        +NOPP
SBI     LDA #-8
        CLC
        ADC X,X
        STA X,X
DES     LDA Y,X
        SEC
        SBC #3*8
        STA Y,X
BTW     LDA #8
        STA FRAME,X
        LDA #AWALK
        STA ACTION,X
        RTS

BATW    LDA #AWALK
        STA ACTION,X
LEST    LDA COUNT,X
        EOR #1
        STA COUNT,X
        CLC
        ADC #$1B
        STA FRAME,X
LES
  RTS

;BLOCK   ; PUNCH FOR CLIMBING

TRYP2
  LDA LEFT,X
  BEQ TRR4
  LDA DIR,X
  BNE BACKP2
  BEQ THIW2
TRR4
  LDA RIGHT,X
  BEQ TRR3
  LDA DIR,X
  BEQ BACKP2      
  BNE THIW2
TRR3
  LDA UP,X
  BEQ GOTTB2
  LDY #0
  LDA #$19                ; PUNCH UP
  JMP STF2
GOTTB2
  LDA #$1A        ; PUNCH DOWN
  LDY #1
  JMP STF2
THIW2
  LDA #23         ; PUNCH LEFT
  LDY #2  
  JMP STF2
BACKP2
  LDA #$16        ; PUNCH RIGHT
  LDY #3
STF2
  STA FRAME,X
  TYA
  STA HANDY,X
  LDA #APUNCHC
  STA ACTION,X
  LDA #0
  STA COUNT,X
  LDA DOWN,X
  BEQ LESB
  LDA Y,X
  CLC
  ADC #4
  STA Y,X
  CMP #189+7
  BCC LES ;B
  LDA #189+7
  STA Y,X
  JMP BTW
LESB
  RTS
        
OYT02   !byte 6,2,4,4
OXT12   !byte 0,0,-3,2
OXT22   !byte -1,1,2,-3

FISTP   LDA Y,X
        LSR ;Implied A
        LSR ;Implied A
        LSR ;Implied A
        SEC
        SBC OYT02,Y
        STA FISY,X
        LDA X,X
        LSR ;Implied A
        LSR ;Implied A
        STA XTEMP
        LDA DIR,X
        BPL SBIT2
        LDA OXT22,Y
        JMP SUPER2
SBIT2   LDA OXT12,Y
SUPER2  CLC
        ADC XTEMP
        STA FISX,X
TC2     RTS

PUNCHC  LDA FIRE,X
        BNE TC2
        LDA COUNT,X
        BNE ADR2
        LDY HANDY,X
        JSR FISTP       ; X Y FOR FIST
        JSR HITHEL      ; HIT HELI
ADR2    LDA COUNT,X
        CLC
        ADC #1
        STA COUNT,X
        CMP #1          ;2
        BCC STEX2       
        LDA #0
        STA COUNT,X
        LDA #$1B        ; ACTION 2
        STA FRAME,X
        LDA #ACLIMB     ; BACK TO CLIMB
        STA ACTION,X
        JMP HIT
STEX2   RTS

JUMP    LDA DIR,X       ; ACTION 5
        BMI THIW3
        LDA #-2
        +NOPP
THIW3
  LDA #2
  CLC
  ADC X,X
  STA X,X
  
CHICK   LDY COUNT,X             
        LDA Y,X
        CLC
        ADC YADT,Y
        STA Y,X
        TYA
        CLC
        ADC #1
        STA COUNT,X
        CMP #17         ; 24
        BCC GRAWL
        LDA #0
        STA COUNT,X
        LDA #AWALK
        STA ACTION,X
        JSR CHECKF

GRAWL
  RTS     ; ACTION 6

OUCH
  LDA COUNT,X   ; ACTION 7
        CLC
        ADC #1
        CMP #10
        BCS BACKT
        STA COUNT,X
        LDA X,X
        CLC
        ADC HITAD,X
UI      STA X,X 
        LDA #$1F
        STA FRAME,X
        RTS

BACKT   LDA #AFALL
        STA ACTION,X
        LDA #0
        STA COUNT,X
        RTS

HITAD   !fill 3,0

SUPRISE RTS     ; ACTION 8

TRANS   LDA COUNT,X     ; ACTION 9
        CLC     
        ADC #1
        CMP #8*8
        BCS WALKO       ;WALK OFF SCREEN        
        STA COUNT,X
        LSR ;Implied A
        LSR ;Implied A
        LSR ;Implied A
        TAY
        LDA TRANT,Y     ;
        STA FRAME,X
        RTS
WALKO   LDA #ADIE       ; SMALL MAN ?
        STA ACTION,X
        RTS

TRANT
  !byte $20,$21,$20,$21
  !byte $22,$23,$22,$23      

DIE
  LDA DIR,X       ; ACTION 10
  BPL FCNL        
  LDA #1
  +NOPP 
  
FCNL    LDA #-1
        CLC
        ADC X,X
        STA X,X
        CMP #$F8
        BEQ KNIGHT
        CMP #$A6
        BEQ KNIGHT
        LDA COUNT,X
        CLC
        ADC #1
        STA COUNT,X
        LSR ;Implied A
        LSR ;Implied A
        AND #1
        CLC
        ADC #$24
        STA FRAME,X
        RTS

KNIGHT  LDA #ADEAD
        STA ACTION,X    
        RTS     

STARE   JSR ANYKEY      ; ACTION 11
        BEQ OUTOF       ; STARE AT YOU
        LDA LASTA,X
        STA ACTION,X
        LDA LASTA,X
        STA ACTION,X
        CMP #AWALK
        BEQ WALKF
        CMP #ACLIMB
        BNE WHAT
        JSR HANDWATER
        BCS WHAT
        LDA #$1B
        +NOPP
WALKF   LDA #8
        STA FRAME,X
WHAT    RTS

OUTOF
  JSR HANDWATER
  BCS WHAT
  LDA LASTA,X     
  CMP #AWALK
  BEQ ATN
  CMP #ACLIMB
  BNE .NOM 
  LDA #$15
  +NOPP
  
ATN
  LDA #0
  STA FRAME,X
.NOM
  RTS     ; STAY AS YOU ARE

ANYKEY  LDA FIRE,X
        ORA LEFT,X
        ORA RIGHT,X
        ORA UP,X
        ORA DOWN,X
        RTS

;BLOCK   ; ACTION 12
FALL    LDA Y,X
        CLC
        ADC #8
        STA Y,X
        CMP #189+7
        BCS AAO
        JSR MODEL       
        BCS AAD        ; ON PLAT
GETL
  RTS

AAD
  LDA Y,X
  AND #15
  CMP #12
  BEQ NOF1
  CMP #4
  BEQ NOF1
  RTS

AAO
  LDA #189+7      ; ?
  STA Y,X
  
NOF1
  LDA #AWALK
  STA ACTION,X
  RTS

MODEL
  LDA Y,X
  LSR ;Implied A
  LSR ;Implied A
  LSR ;Implied A
  TAY
  LDA X,X
  LSR ;Implied A
  LSR ;Implied A
  JSR MEMXY
  LDY #0
  LDA MIKE1,Y
  CMP #9
  BEQ AAD
  CMP #10
  BEQ AAD
  CMP #11
  BEQ AAD
  CMP #33
  BEQ ADD
  CMP #34
  BEQ AAD
        CMP #35
        BEQ AAD
        CMP #36
        BEQ AAD
        CMP #37
        BEQ AAD
        CMP #$40
        BEQ ADD
        CMP #$41
        BEQ ADD
        CMP #$20
        BEQ ADD
        CMP #$21
        BEQ ADD
        CMP #$22
        BEQ ADD
        CMP #$23
        BEQ ADD
        CMP #$24
        BEQ ADD
        CMP #255-32
        RTS

ADD
  SEC
  RTS

HITW
  !byte 1,0,0
HITW2
  !byte 2,2,1

HIT     LDA LEFT,X
        ORA RIGHT,X
        BEQ MISS
        LDY HITW,X
        JSR DETECT
        BCC MIS
        JMP WACK        ; HIT
MIS     LDY HITW2,X
        JSR DETECT
        BCC MISS
WACK    LDA #0
        STA COUNT,Y
        LDA ACTION,Y
        CMP #ADIE
        BNE WACK1
        LDA #0
        STA X,Y
        LDA #AEAT
        STA ACTION,X
        LDA #ADEAD
        STA ACTION,Y
        RTS
WACK1   CMP #AWALK
        BEQ AOU
        CMP #ACLIMB
        BEQ CLA
        CMP #ASTARE
        BNE CLA ; OTHER JUST FALL
        LDA LASTA,Y
        CMP #AWALK
        BEQ AOU
CLA
  LDA #AFALL      ; ELSE FALL
  +NOPP
AOU
  LDA #AOUCH
  STA ACTION,Y
  LDA DIR,X
  BPL SBT
  LDA #4
  +NOPP
SBT
  LDA #-4
  STA HITAD,Y
MISS
  RTS

DETECT  LDA X,X
        CMP X,Y         ; SOTWARE
        BCC LESTHN
        LDA X,Y
        CLC
        ADC #8          ; PIXELS X 12
        CMP X,X
        BCS GREATE
NOHITA  RTS

LESTHN  ADC #16         ; PIXELS X 12
        CMP X,Y
        BCC NOHITA
GREATE  LDA Y,X
        CMP Y,Y
        BCC LETHAB
        LDA Y,Y
        CLC
        ADC #8  ; PIXELS Y
        CMP Y,X
        RTS

LETHAB  ADC #1*8        ; PIXELS Y
        CMP Y,Y
NOGJ    RTS

        ; CHECK FOR HIT GROUND OBJECT
DETEC2  LDA DOWN,X
        BEQ NOGJ
        LDA FIRE,X
        BEQ NOGJ
        BIT CARS        ; ALREADY
        BVS NOGJ        ; KILLED
        JSR DE
        BCC NOGJ
        LDA NP62+1
        CMP #42+SS0
        BEQ POL         ; POLICE CAR
        CMP #44+SS0
        BEQ POL
        CMP #50+SS0
        BEQ POL         ; TANK EXPLODE
        CMP #52+SS0
        BEQ POL
        LDA CARB+1
        CMP #-1
        BNE UY
        LDA #-2
        STA CARB+1
        RTS

UY
  CMP #1
  BNE TY
  LDA #2
  STA CARB+1
  RTS

POL
  LDA CARS        ; EXPLODE IT
  ORA #%01000000
  STA CARS
  LDA #0
  STA COUNT+3
TY
  RTS

DE      LDA Y,X
        CMP #189+7
        BCC NOGJ                
        LDA TRANX
        LSR ;Implied A
        LSR ;Implied A
        CMP FISX,X
        BEQ RED
        CLC
        ADC #1
        CMP FISX,X
        BEQ RED
        CLC
        RTS

RED
  SEC
  RTS

LESTH
  ADC #24         ; PIXELS X 12
  CMP TRANX
NOHIT
  RTS

KILCAR  BIT CARS
        BVC NOHIT
        LDA #8
        STA CARCOL+1
        LDA SYNC
        AND #7
        BNE NOHIT
        LDA COUNT+3
        CLC
        ADC #1
        CMP #7
        BCC STD
        LDA #0-24
        STA TRANX

        LDA #%10000000
        STA CARS
        LDA #6
        STA CARCOL+1
        JMP NEWO

STD     STA COUNT+3
        TAY
        LDA EXPLTT,Y
        STA NP62+1
        LDA EXPLTB,Y
        STA NP72+1
        RTS     

GROWL   LDA COUNT,X     ; ACTION 12
        CLC
        ADC #1
        STA COUNT,X
        CMP #10
        BCS STG
        TAY
        LDA GRFT,Y
        STA FRAME,X
        RTS

STG     LDA LASTA,X
        STA ACTION,X
        RTS


GRFT
  !byte 1,2,0,1,1,2,0,1,2,0

EAT     LDA COUNT,X     ; ACTION 13
        CLC
        ADC #1
        STA COUNT,X
        CMP #22
        BCS STG2
        LDA LASTA,X
        CMP #AWALK
        BEQ ONB
        
        
        LDY COUNT,X
        LDA CLIMEAT,Y

        STA FRAME,X
        RTS
ONB     LDY COUNT,X
        LDA WALKEAT,Y
        STA FRAME,X     
        RTS

DEAD
  RTS

CLIMEAT
  !byte $05,$05,$05
  !byte $05,$05,$05
  !byte $0F,$0F,$0F
  !byte $10,$10,$10
  !byte $11,$11,$11
  !byte $10,$10,$10
  !byte $11,$0F,$10
  !byte $11,$11
WALKEAT
  !byte $0D,$0D,$0D
  !byte $0D,$0D,$0D
  !byte $12,$12,$12
  !byte $13,$13,$13
  !byte $14,$14,$14
  !byte $12,$12,$12
  !byte $12,$13,$14
  !byte $12,$13

STG2
  LDA LASTA,X
  STA ACTION,X
  LDA #0
  STA COUNT,X
  RTS

ONBX
  !byte 0,0,0
ONBX1
  !byte 0,0,0
BUILDPOINT
  !byte 0
SBXSTART
  !byte 0,0,0,0,0,0,0,0
SBXEND
  !byte 0,0,0,0,0,0,0,0
SBTOP
  !byte 0,0,0
  !byte 0,0,0,0,0
MONONB
  !fill 3

SY      = 2   ; FASTER ?

YADT    !byte SY*0,SY*-3,SY*-3,SY*-3
        !byte SY*-2,SY*-2,SY*-1,SY*-1
        !byte SY*0,SY*0,SY*0,SY*2
        !byte SY*2,SY*2,SY*3,SY*3
        !byte SY*3,SY*3,SY*3,SY*2
        !byte SY*3,SY*1,SY*2,SY*0

EXPLTT  !byte 54+SS0,56+SS0,57+SS0 
        !byte 58+SS0,60+SS0,62+SS0,BL
EXPLTB  !byte 55+SS0,57+SS0,123+SS0
        !byte 59+SS0,61+SS0,63+SS0,BL

NEWO    JSR RAND
        AND #15
        TAY
        LDA CSTCT,Y
        STA TRANX
        LDA CADT,Y
        STA CARB+1
        LDA CARL,Y
        STA NP62+1
        LDA CARR,Y
        STA NP72+1
        RTS

        ; CAR TRAN ETC TABLES
CARL    !byte 42+SS0,42+SS0,44+SS0,44+SS0
        !byte 46+SS0,46+SS0,48+SS0,48+SS0
        !byte 52+SS0,52+SS0,50+SS0,50+SS0
        !byte 42+SS0,46+SS0,50+SS0,42+SS0

CARR    !byte 43+SS0,43+SS0,45+SS0,45+SS0
        !byte 47+SS0,47+SS0,49+SS0,49+SS0
        !byte 53+SS0,53+SS0,51+SS0,51+SS0
        !byte 43+SS0,47+SS0,51+SS0,43+SS0

CSTCT   !byte 0-24,0-24,172,172
        !byte 0-24,0-24,172,172
        !byte 0-24,0-24,172,172
        !byte 0-24,0-24,172,172

CADT    !byte 1,2,-1,-2    
        !byte 1,2,-1,-2
        !byte 1,1,-1,-1
        !byte 1,1,-1,-1

        ; HELI MOVEMENT TABLES
        ; AND ROUTINES
        ; CALLED FROM RASTER IRQ

MOVTL   !byte <HM0,<HM1,<HM2,<HM3  
        !byte <HM4,<HM5,<HM6,<HM7
        !byte <HM8,<HM9,<HM10,<HM11
        !byte <HM12
MOVTH   !byte >HM0,>HM1,>HM2,>HM3  
        !byte >HM4,>HM5,>HM6,>HM7
        !byte >HM8,>HM9,>HM10,>HM11
        !byte >HM12
        
HM0     !byte 0,-1,0+SS0
HM1     !byte -1,0,4+SS0
HM2     !byte -1,1,8+SS0
HM3     !byte 0,-1,12+SS0
HM4     !byte 1,0,16+SS0
HM5     !byte 1,1,20+SS0
HM6     !byte 0,0,0+SS0
HM7     !byte 0,0,12+SS0
HM8     !byte 0,0,0+SS1    ; EXPLODE
HM9     !byte 0,0,1+SS1    ; $F000
HM10    !byte 0,0,2+SS1
HM11    !byte 0,0,3+SS1
HM12    !byte 0,0,BL

M0      !byte 1,140        ; LEFT
        !byte 6,100        ; HOVER
        !byte 0,50         ; UP
        !byte 5,40         ; DIAG
        !byte 4,130        ; LEFT
        !byte 255

M1      !byte 1,140        ; LEFT
        !byte 6,20         ; HOVER
        !byte 4,100        ; RIGHT
        !byte 7,20         ; HOVER
        !byte 3,60         ; UP
        !byte 2,50         ; DIAG
        !byte 1,100        ; LEFT
        !byte 255

M2      !byte 1,160        ; LEFT          
        !byte 6,20         ; HOVER
        !byte 4,100        ; RIGHT
        !byte 3,20         ; UP
        !byte 4,70         ; RIGHT
        !byte 255

M3      !byte 4,140        ; RIGHT
        !byte 7,50         ; HOVER
        !byte 3,30         ; UP
        !byte 2,40         ; DIAG
        !byte 1,120        ; LEFT
        !byte 255

M4      !byte 1,50 ; LEFT
        !byte 6,40 ; HOVER
        !byte 0,60 ; UP
        !byte 2,50 ; DIAG
        !byte 1,90 ; LEFT
        !byte 255  

M5      !byte 1,100 ; LEFT
        !byte 3,60 ; UP
        !byte 2,50 ; DIAG
        !byte 3,60 ; UP
        !byte 5,50 ; DIAG
        !byte 4,100 ; RIGHT
        !byte 255

M6      !byte 4,80         ; RIGHT
        !byte 5,30         ; DIAG
        !byte 4,60         ; RIGHT
        !byte 255

M7      !byte 1,80         ; LEFT
        !byte 2,30         ; DIAG
        !byte 1,80         ; LEFT
        !byte 255

M8      !byte 8,10
        !byte 9,10 
        !byte 10,10
        ;!byte 11,10
        ;!byte 12,50
        !byte 255


HECYT1  !byte 180,190,195,170,180,190,160,160,160
HECXT1  !byte 180,180,180,0,180,180,0,180,160

PATHTL  !byte <(M0-2),<(M1-2),<(M2-2)
        !byte <(M3-2),<(M4-2),<(M5-2)
        !byte <(M6-2),<(M7-2),<(M8-2)

PATHTH  !byte >(M0-2),>(M1-2),>(M2-2)
        !byte >(M3-2),>(M4-2),>(M5-2)
        !byte >(M6-2),>(M7-2),>(M8-2)

SET0    LDA HUSED0
        BPL OFFS
FIRS0   LDY #8
        JSR RAND
        AND #7
        TAY
EXPI0   LDA PATHTL,Y
        STA TABML0
        LDA PATHTH,Y
        STA TABML0+1
        LDA HECXT1,Y
        STA HEX0
        LDA HECYT1,Y
        STA HEY0
        LDA #0
        STA HUSED0
NEXTB0  LDA TABML0      
        CLC
        ADC #2
        STA TABML0
        BCC SD0
        INC TABML0+1
SD0     LDY #0
        LDA TABML0,Y
        CMP #255        ; END OF LIST
        BNE NOE0
        LDA #255
        STA HUSED0
OFFS
  RTS

NOE0    TAY     ; HELI 0
        STA HEACT0
        LDA MOVTL,Y
        STA TMPMEM
        LDA MOVTH,Y
        STA TMPMEM+1
        LDY #1
        LDA TABML0,Y
        STA SPD0
        DEY
        LDA TMPMEM,Y
        STA THX0+1
        INY
        LDA TMPMEM,Y
        STA THY0+1
        INY
        LDA TMPMEM,Y
        STA PRT0+1
        RTS             

UPHEL0  LDA HUSED0
        BMI NOG
        LDA SPD0
        BEQ NEXTB0
        DEC SPD0
        LDA HEX0
        CLC
THX0    ADC #1
        STA HEX0
        LDA HEY0
        CLC
THY0    ADC #1
        STA HEY0
        STA NY6+1
PRT0    LDA #255
        CLC
        ADC OSIL
        STA NP6+1       
NOG     RTS

UPHEL1  LDA HUSED1
        BMI NOG
        LDA SPD1
        BEQ NEXTB1
        DEC SPD1
        LDA HEX1
        CLC
THX1    ADC #1
        STA HEX1
        LDA HEY1
        CLC
THY1    ADC #1
        STA HEY1
        STA NY7+1
PRT1    LDA #255
        CLC
        ADC OSIL
        STA NP7+1       
        RTS

SET1
  LDA HUSED1
  ;BPL OFFS
  BMI *+5
  JMP OFFS
        
FIRS1
  LDY #9
  JSR RAND
  AND #7
  TAY
  
EXPI1
  LDA PATHTL,Y
  STA TABML1+0
  LDA PATHTH,Y
  STA TABML1+1
  LDA HECXT1,Y
  STA HEX1
  LDA HECYT1,Y
  SEC
  SBC #20 
  STA HEY1
  LDA #0
  STA HUSED1

NEXTB1
  LDA TABML1      
  CLC
  ADC #2
  STA TABML1
  BCC SD1
  INC TABML1+1

SD1     LDY #0
        LDA TABML1,Y
        CMP #255        ; END OF LIST
        BNE NOE1
        LDA #255
        STA HUSED1
        RTS

NOE1    TAY     ; HELI 1
        STA HEACT1
        LDA MOVTL,Y
        STA TMPMEM
        LDA MOVTH,Y
        STA TMPMEM+1
        LDY #1
        LDA TABML1,Y
        STA SPD1
        DEY
        LDA TMPMEM,Y
        STA THX1+1
        INY
        LDA TMPMEM,Y
        STA THY1+1
        INY
        LDA TMPMEM,Y
        STA PRT1+1
NOF2
  RTS     
  ; WORK OUT MEM FOR X,Y
  ; FOR BIT COLOUR MEMORY

MEMXY
  CLC
  ADC COLRAML,Y
   STA MIKE1+0     ; COLOUR LOW
   LDA SCREENTEMP
   EOR #SCEOR      ; NOT BUFFER
   ADC COLRAMH,Y
   STA MIKE1+1     ; COLOUR HIGH
   RTS

COLRAML
  !byte $00,$28,$50,$78
  !byte $A0,$C8,$F0,$18
  !byte $40,$68,$90,$B8
  !byte $E0,$08,$30,$58
  !byte $80,$A8,$D0,$F8
  !byte $20,$48,$70,$98
  !byte $C0

COLRAMH
  !byte 0,0,0,0,0,0
  !byte 0,1,1,1,1,1,1
  !byte 2,2,2,2,2,2,2
  !byte 3,3,3,3,3


; UTILITIES FOR GAME

; -----
; SCAN JOYSTICK
JOYGET
  LDX #0
  LDA CHUMAN,X
  BEQ RJOY
  JSR AUTOPLAY
  JMP RJOYA
RJOY
  STX CIA1+2
  JSR JOYST       ; PORT 1
RJOYA
  LDX #1          ; PORT 2
  LDA CHUMAN,X
  BEQ RJOY1
  JSR AUTOPLAY
  JMP RJOY1A
RJOY1
  JSR JOYST
  LDX #2
  LDA CHUMAN,X
  BEQ RJOY1A
  JSR AUTOPLAY
  RTS
RJOY1A
  LDA #255        ; KEYBOARD
  STA CIA1+2
  LDA #%10111111
  STA CIA1
  LDA CIA1+1
  EOR #%11111111
  STA JOY
  LDA #0
  ASL JOY
  ROL ;Implied A
  STA RIGHT+2
  LDA #0
  ASL JOY
  ASL JOY
  ROL ;Implied A
  STA FIRE+2
  LDA #%11011111
  STA CIA1
  LDA CIA1+1
  EOR #%11111111
  STA JOY
  LDA #0
  ASL JOY
  ROL ;Implied A
  STA LEFT+2
  LDA #0
  ASL JOY
  ROL ;Implied A
  STA UP+2
  LDA #0
  ASL JOY
  ROL ;Implied A
  STA DOWN+2
NOFIRE
  RTS
JOYST
  LDA CIA1,X
  EOR #%00011111
  STA JOY
  LDA #0
  LSR JOY
  ROL ;Implied A
  STA UP,X
  LDA #0
  LSR JOY
  ROL ;Implied A
  STA DOWN,X
  LDA #0
  LSR JOY
  ROL ;Implied A
  STA LEFT,X
  LDA #0
  LSR JOY
  ROL ;Implied A
  STA RIGHT,X
  LDA #0
  LSR JOY
  ROL ;Implied A
  STA FIRE,X
  RTS

; -----
; 2023/06/26 J.Baldock - appears function to clear the screen.
SCREENWIPE
screenwipe.start
  LDY #0 ; set loop counter to 0
screenwipe.loop
  LDA #%00001110 ; colour 14 = light blue
  ; this section is setting colour memory to colour
  STA NYBBLE+$000,Y
  STA NYBBLE+$100,Y
  STA NYBBLE+$200,Y
  STA NYBBLE+$300,Y
  LDA #0
  ; this section is clearing ?
  STA $F400,Y
  STA $F800,Y
  DEY ; decrease y
  BNE screenwipe.loop ; if y NOT 0 then loop
  RTS