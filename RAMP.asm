; RAMP

MAIN    SEI
        LDX #255
        TXS
        LDY #2
        LDA #0
        STA ENABLE
ZEROP   STA D6510,Y
        INY
        BNE ZEROP       
        LDA #%00100101
        STA R6510
        LDA #%10010100  ; BANK 2
        STA CIA2
        LDA #%11011000  ; CHAR &E000
        STA VICMCR      ; SCR  &F800
        LDA #%11011000
        STA VICCR2
        LDA #%00000011  ; BLANK OUT
        STA VICCR1
        LDA #>NMIA
        STA &FFFA
        LDA #<NMIA
        STA &FFFB
        LDA #>RESET
        STA &FFFC
        LDA #<RESET
        STA &FFFD
        LDA #>IRQ
        STA &FFFE
        LDA #<IRQ
        STA &FFFF
        LDA #1
        STA VICIMR
        LDA #&7F
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
        
        CLI
        JSR CLEARN      ; NYBBLES
        JSR CRUM
        LDY #62
        LDA #0
BKANSP  STA [BL*64]+BANK,Y
        STA [253*64]+BANK,Y     ; ON
        STA [254*64]+BANK,Y     ; BORDER
        STA [(SO0+0)*64]+BANK,Y
        STA [(SO0+1)*64]+BANK,Y
        STA [(SO0+2)*64]+BANK,Y
        STA [(SO0+3)*64]+BANK,Y
        STA [(SO0+4)*64]+BANK,Y
        STA [(SO0+5)*64]+BANK,Y
        STA [(SO1+0)*64]+BANK,Y
        STA [(SO1+1)*64]+BANK,Y
        STA [(SO1+2)*64]+BANK,Y
        STA [(SO1+3)*64]+BANK,Y
        STA [(SO1+4)*64]+BANK,Y
        STA [(SO1+5)*64]+BANK,Y
        STA [(SO2+0)*64]+BANK,Y
        STA [(SO2+1)*64]+BANK,Y
        STA [(SO2+2)*64]+BANK,Y
        STA [(SO2+3)*64]+BANK,Y
        STA [(SO2+4)*64]+BANK,Y
        STA [(SO2+5)*64]+BANK,Y
        
        DEY
        BPL BKANSP
        LDA #0
        STA BORDER
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
        STA ENABLE
        JSR AIR
LOOP    JSR JOYGET      ; JOYGET !!
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
EAR     JSR DRAWBUILD
        LDA SYNC
SMO     CMP SYNC
        BEQ SMO
        JMP LOOP

AWALK           EQU 1   ; WALKING
APUNCHW EQU 2   ; PUNCH GROUND
ACLIMB          EQU 3   ; CLIMB
APUNCHC EQU 4   ; PUNCH CLIMB
AJUMP           EQU 5   ; JUMP
AGRAWL          EQU 6   ; GRAWLING
AOUCH           EQU 7   ; BEING HIT
ASUPRISE        EQU 8
ATRANS          EQU 9
ADIE            EQU 10
ASTARE          EQU 11
AFALL           EQU 12
AGROWL          EQU 13
AEAT            EQU 14
ADEAD           EQU 15
        ; DIRECTION 0 FACING LEFT
ACTTABL 
        DB >WALK
        DB >PUNCHW
        DB >CLIMB
        DB >PUNCHC
        DB >JUMP
        DB >GRAWL
        DB >OUCH
        DB >SUPRISE
        DB >TRANS
        DB >DIE
        DB >STARE
        DB >FALL
        DB >GROWL
        DB >EAT
       DB >DEAD
ACTTABH
        DB <WALK
        DB <PUNCHW
        DB <CLIMB
        DB <PUNCHC
        DB <JUMP
        DB <GRAWL
        DB <OUCH
        DB <SUPRISE
        DB <TRANS
        DB <DIE
        DB <STARE
        DB <FALL
        DB <GROWL
        DB <EAT
        DB <DEAD

MOVE    LDY ACTION,X
        LDA ACTTABL-1,Y
        STA SOMET+1
        LDA ACTTABH-1,Y
        STA SOMET+2
SOMET   JSR &FFFF       ; SMC
        LDA ACTION,X    
        CMP #ADEAD
        BNE AST
        RTS
AST     JSR KILCAR
        LDA ACTION,X
        CMP #AWALK
        BEQ CANBE
        CMP #ACLIMB
        BNE MOVM
CANBE   STA LASTA,X
        JSR ANYKEY      ; IF NO
        BNE MOVM        ; MOVEMENT
        LDA #ASTARE     ; DO A DELAY
        STA ACTION,X
MOVM    JMP CREATE
        

        BLOCK           ; ACTION 1
WALK    JSR WA
        JSR CLIM
CHECKF  LDA Y,X
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
        LDA #&20        ; JUMP FRAME
        STA FRAME,X
        LDA #0
        STA COUNT,X
        PLA
        PLA
        RTS

JUWA    LDA LEFT,X
        BEQ :NOM
        LDA DIR,X
        BPL :ALSET
        INC DIR,X
:ALSET  JMP WALKL       ; WALK LEFT

:NOM    LDA RIGHT,X
        BLOCK
        BEQ OFFB
        LDA DIR,X
        BMI :ALSET
        DEC DIR,X
:ALSET  JMP WALKR

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
SAVEM   STA X,X
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
        NOPP
MINS    LDA #4
GOTV    CLC
        ADC X,X
        STA X,X
NOCH    LDA X,X
        AND #%11111100
        STA X,X
        LDA TMP         ; NEW DIRECTION
        STA DIR,X
        LDA #&1B
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
        LDA #&06
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
        BCC :LESS
        LDA #0
:LESS   STA STEP,X
        LSR A
        LSR A
        CLC
        ADC #8  
        STA FRAME,X
:NOM    RTS

OYT0    DB 6,2,3,3
OXT1    DB 0,-2,-2,-4
OXT2    DB -1,2,2,4

FISTPO  LDY HANDY,X
        LDA Y,X
        LSR A
        LSR A
        LSR A
        SEC
        SBC OYT0,Y
        STA FISY,X
        LDA X,X
        LSR A
        LSR A
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
SPF     RTS

HITC    LDA YTEMP       ; HELI CHR CORD
        CMP FISY,X      ; APE HAND
        BEQ JOL
        CLC
        ADC #1
        CMP FISY,X
        BNE CANN

JOL     LDA XTEMP
        CMP FISX,X
        BEQ CAN
        CLC
        ADC #1
        CMP FISX,X
        BEQ CAN
CANN    CLC     ; MISSED
        RTS     

CAN     SEC     ; HIT
        RTS

CHK0    LDA HEY0
        LSR A   
        LSR A
        LSR A
        SEC
        SBC #5
        STA YTEMP
        LDA HEX0
        CMP #8
        BCC EXI
        CMP #&9E
        BCS EXI
        LSR A
        LSR A
        SEC
        SBC #2
        STA XTEMP
        CLC
        RTS
CHK1    LDA HEY1
        LSR A
        LSR A
        LSR A
        SEC
        SBC #5
        STA YTEMP
        LDA HEX1
        CMP #8
        BCC EXI
        CMP #&9E
        BCS EXI
        LSR A
        LSR A   
        SEC
        SBC #2
        STA XTEMP
        CLC
        RTS

EXI     SEC
        RTS
                ; PUNCH FOR WALKING
TRYP1   LDA LEFT,X
        BEQ :TRR
        LDA DIR,X
        BNE EXI ;NOTHN  ; BACKP
        BEQ :THIW
:TRR    LDA RIGHT,X
        BEQ :TRR2
        LDA DIR,X
        BEQ EXI;        NOTHN   ; BACKP 
        BNE :THIW
:TRR2   LDA UP,X
        BEQ :GOTTB
        LDY #0
        LDA #&18        ; PUNCH UP
        JMP :STF
:GOTTB  LDA #7          ; PUNCH DOWN
        LDY #1
        JMP :STF
:THIW   LDA #4          ; PUNCH LEFT
        LDY #2
        JMP :STF
:BACKP  LDA #&16        ; PUNCH RIGHT
        LDY #3
:STF    STA FRAME,X
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
TC      RTS
        
PUNCHW  LDA FIRE,X
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
STEX    STA COUNT,X
        RTS

CLIMBCHECK
        LDA FIRE,X
        BNE CRUNCH
        LDA UP,X
        BEQ EXI
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
DS      LSR A
        LSR A
        CLC
        ADC #1
        STA TMP
        LDY #7
GETL    LDA SBTOP,Y
        CMP Y,X
        BCS NOTW
        LDA SBXSTART,Y
        CMP TMP
        BEQ ONBEG
        LDA SBXEND,Y
        CMP TMP
        BEQ ONEND
NOTW    DEY
        BPL GETL
CRUNCH  SEC
        RTS

ONBEG   LDA #255        ; DIRECTION
        NOPP            ; FACEING
ONEND   LDA #0
        STA TMP
        TYA
        STA MONONB,X
        LDA SBXSTART,Y
        ASL A   
        ASL A
        STA ONBX,X
        LDA SBXEND,Y
        ASL A
        ASL A
        STA ONBX1,X
        CLC
        RTS

SIDE    LDA Y,X         
        SEC
        SBC #5*8
        LSR A           
        LSR A
        LSR A
        TAY
        LDA DIR,X
        BPL TO2
        LDA #4
        NOPP
TO2     LDA #-4
        CLC
        ADC X,X
        LSR A
        LSR A
        JSR MEMXY
        LDY #0
        LDA (MIKE1),Y
        CMP #&0C
        BEQ TH
        CMP #&0D
        BEQ TH
        CMP #&0F
        BEQ TH
        CMP #&10
        BEQ TH
        CMP #&40
        BEQ TH
        CMP #&41
        BEQ TH
        CMP #&25        ; &25   
        BCC NOT         ; TO &28
        CMP #&29
        BCC TH
        CMP #&46        
        BEQ TH
        CMP #&47
        BEQ TH
        CMP #&53        ; &53
        BCC NOT         ; TO &73
        CMP #&74
        BCC TH
NOT     SEC
        RTS

TH      CLC
        RTS

        BLOCK
CLIMB   LDA FIRE,X      ; ACTION 3
        BEQ JOM
        LDA RIGHT,X
        ORA LEFT,X
        ORA UP,X
        ORA DOWN,X
        BNE TRYP2       ; A PUNCH

        LDA #AFALL      ; IF NO DIR
        STA ACTION,X    ; FALL ALL
        LDA DIR,X       ; BUILDING
        BPL AD4
        LDA #-4
        NOPP
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
        NOPP
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
        ADC #&1B
        STA FRAME,X
LES     RTS

        BLOCK   ; PUNCH FOR CLIMBING
TRYP2   LDA LEFT,X
        BEQ :TRR
        LDA DIR,X
        BNE :BACKP
        BEQ :THIW
:TRR    LDA RIGHT,X
        BEQ :TRR2
        LDA DIR,X
        BEQ :BACKP      
        BNE :THIW
:TRR2   LDA UP,X
        BEQ :GOTTB
        LDY #0
        LDA #&19                ; PUNCH UP
        JMP :STF
:GOTTB  LDA #&1A        ; PUNCH DOWN
        LDY #1
        JMP :STF
:THIW   LDA #23         ; PUNCH LEFT
        LDY #2  
        JMP :STF
:BACKP  LDA #&16        ; PUNCH RIGHT
        LDY #3
:STF    STA FRAME,X
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

LESB    RTS
        
OYT02   DB 6,2,4,4
OXT12   DB 0,0,-3,2
OXT22   DB -1,1,2,-3

FISTP   LDA Y,X
        LSR A
        LSR A
        LSR A
        SEC
        SBC OYT02,Y
        STA FISY,X
        LDA X,X
        LSR A
        LSR A
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
        LDA #&1B        ; ACTION 2
        STA FRAME,X
        LDA #ACLIMB     ; BACK TO CLIMB
        STA ACTION,X
        JMP HIT
STEX2   RTS

JUMP    LDA DIR,X       ; ACTION 5
        BMI THIW
        LDA #-2
        NOPP
THIW    LDA #2
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

GRAWL   RTS     ; ACTION 6

OUCH    LDA COUNT,X     ACTION 7
        CLC
        ADC #1
        CMP #10
        BCS BACKT
        STA COUNT,X
        LDA X,X
        CLC
        ADC HITAD,X
UI      STA X,X 
        LDA #&1F
        STA FRAME,X
        RTS

BACKT   LDA #AFALL
        STA ACTION,X
        LDA #0
        STA COUNT,X
        RTS

HITAD   DS 3,0

SUPRISE RTS     ; ACTION 8

TRANS   LDA COUNT,X     ; ACTION 9
        CLC     
        ADC #1
        CMP #8*8
        BCS WALKO       ;WALK OFF SCREEN        
        STA COUNT,X
        LSR A
        LSR A
        LSR A
        TAY
        LDA TRANT,Y     ;
        STA FRAME,X
        RTS
WALKO   LDA #ADIE       ; SMALL MAN ?
        STA ACTION,X
        RTS

TRANT   DB &20,&21,&20,&21
        DB &22,&23,&22,&23      

DIE     LDA DIR,X       ; ACTION 10
        BPL FCNL        
        LDA #1
        NOPP    
FCNL    LDA #-1
        CLC
        ADC X,X
        STA X,X
        CMP #&F8
        BEQ KNIGHT
        CMP #&A6
        BEQ KNIGHT
        LDA COUNT,X
        CLC
        ADC #1
        STA COUNT,X
        LSR A
        LSR A
        AND #1
        CLC
        ADC #&24
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
        LDA #&1B
        NOPP
WALKF   LDA #8
        STA FRAME,X
WHAT    RTS

OUTOF   JSR HANDWATER
        BCS WHAT
        LDA LASTA,X     
        CMP #AWALK
        BEQ ATN
        CMP #ACLIMB
        BNE NOM 
        LDA #&15
        NOPP
ATN     LDA #0
        STA FRAME,X
NOM     RTS     ; STAY AS YOU ARE

ANYKEY  LDA FIRE,X
        ORA LEFT,X
        ORA RIGHT,X
        ORA UP,X
        ORA DOWN,X
        RTS

        BLOCK   ; ACTION 12
FALL    LDA Y,X
        CLC
        ADC #8
        STA Y,X
        CMP #189+7
        BCS :AAO
        JSR MODEL       
        BCS :AAD        ; ON PLAT
:GETL   RTS

:AAD    LDA Y,X
        AND #15
        CMP #12
        BEQ :NOF
        CMP #4
        BEQ :NOF
        RTS

:AAO    LDA #189+7      ; ?
        STA Y,X
:NOF    LDA #AWALK
        STA ACTION,X
        RTS

MODEL   LDA Y,X
        LSR A
        LSR A
        LSR A
        TAY
        LDA X,X
        LSR A
        LSR A
        JSR MEMXY
        LDY #0
        LDA (MIKE1),Y
        CMP #9
        BEQ :AAD
        CMP #10
        BEQ :AAD
        CMP #11
        BEQ :AAD
        CMP #33
        BEQ :ADD
        CMP #34
        BEQ :AAD
        CMP #35
        BEQ :AAD
        CMP #36
        BEQ :AAD
        CMP #37
        BEQ :AAD
        CMP #&40
        BEQ :ADD
        CMP #&41
        BEQ :ADD
        CMP #&20
        BEQ :ADD
       CMP #&21
        BEQ :ADD
        CMP #&22
        BEQ :ADD
        CMP #&23
        BEQ :ADD
        CMP #&24
        BEQ :ADD
        CMP #255-32
        RTS

:ADD    SEC
        RTS

HITW    DB 1,0,0
HITW2   DB 2,2,1

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
CLA     LDA #AFALL      ; ELSE FALL
        NOPP
AOU     LDA #AOUCH
        STA ACTION,Y
        LDA DIR,X
        BPL SBT
        LDA #4
        NOPP
SBT     LDA #-4
        STA HITAD,Y
MISS    RTS

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

UY      CMP #1
        BNE TY
        LDA #2
        STA CARB+1
        RTS

POL     LDA CARS        ; EXPLODE IT
        ORA #%01000000
        STA CARS
        LDA #0
        STA COUNT+3
TY      RTS

DE      LDA Y,X
        CMP #189+7
        BCC NOGJ                
        LDA TRANX
        LSR A
        LSR A
        CMP FISX,X
        BEQ RED
        CLC
        ADC #1
        CMP FISX,X
        BEQ RED
        CLC
        RTS

RED     SEC
        RTS

LESTH   ADC #24         ; PIXELS X 12
        CMP TRANX
NOHIT   RTS

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


GRFT    DB 1,2,0,1,1,2,0,1,2,0

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

DEAD    RTS


CLIMEAT DB &05,&05,&05
                DB &05,&05,&05
                DB &0F,&0F,&0F
                DB &10,&10,&10
                DB &11,&11,&11
                DB &10,&10,&10
                DB &11,&0F,&10
                DB &11,&11
WALKEAT         DB &0D,&0D,&0D
                DB &0D,&0D,&0D
                DB &12,&12,&12
                DB &13,&13,&13
                DB &14,&14,&14
                DB &12,&12,&12
                DB &12,&13,&14
                DB &12,&13

STG2    LDA LASTA,X
        STA ACTION,X
        LDA #0
        STA COUNT,X
        RTS

O       EQU 189+7+20    ; SPRITE OFFSET
ONBX    DB 0,0,0
ONBX1   DB 0,0,0
BUILDPOINT      DB 0
SBXSTART        DB 0,0,0,0,0,0,0,0
SBXEND  DB 0,0,0,0,0,0,0,0
SBTOP   DB 0,0,0
        DB 0,0,0,0,0
MONONB  DS 3

SY      EQU 2   ; FASTER ?

YADT    DB SY*0,SY*-3,SY*-3,SY*-3
        DB SY*-2,SY*-2,SY*-1,SY*-1
        DB SY*0,SY*0,SY*0,SY*2
        DB SY*2,SY*2,SY*3,SY*3
        DB SY*3,SY*3,SY*3,SY*2
        DB SY*3,SY*1,SY*2,SY*0

EXPLTT  DB 54+SS0,56+SS0,57+SS0 
        DB 58+SS0,60+SS0,62+SS0,BL
EXPLTB  DB 55+SS0,57+SS0,123+SS0
        DB 59+SS0,61+SS0,63+SS0,BL

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
CARL    DB 42+SS0,42+SS0,44+SS0,44+SS0
        DB 46+SS0,46+SS0,48+SS0,48+SS0
        DB 52+SS0,52+SS0,50+SS0,50+SS0
        DB 42+SS0,46+SS0,50+SS0,42+SS0

CARR    DB 43+SS0,43+SS0,45+SS0,45+SS0
        DB 47+SS0,47+SS0,49+SS0,49+SS0
        DB 53+SS0,53+SS0,51+SS0,51+SS0
        DB 43+SS0,47+SS0,51+SS0,43+SS0

CSTCT   DB 0-24,0-24,172,172
        DB 0-24,0-24,172,172
        DB 0-24,0-24,172,172
        DB 0-24,0-24,172,172

CADT    DB 1,2,-1,-2    
        DB 1,2,-1,-2
        DB 1,1,-1,-1
        DB 1,1,-1,-1

        ; HELI MOVEMENT TABLES
        ; AND ROUTINES
        ; CALLED FROM RASTER IRQ

MOVTL   DB >HM0,>HM1,>HM2,>HM3  
        DB >HM4,>HM5,>HM6,>HM7
        DB >HM8,>HM9,>HM10,>HM11
       DB >HM12
MOVTH   DB <HM0,<HM1,<HM2,<HM3  
        DB <HM4,<HM5,<HM6,<HM7
        DB <HM8,<HM9,<HM10,<HM11
       DB <HM12
HM0     DB 0,-1,0+SS0
HM1     DB -1,0,4+SS0
HM2     DB -1,1,8+SS0
HM3     DB 0,-1,12+SS0
HM4     DB 1,0,16+SS0
HM5     DB 1,1,20+SS0
HM6     DB 0,0,0+SS0
HM7     DB 0,0,12+SS0
HM8     DB 0,0,0+SS1    ; EXPLODE
HM9     DB 0,0,1+SS1    ; &F000
HM10    DB 0,0,2+SS1
HM11    DB 0,0,3+SS1
HM12    DB 0,0,BL

M0      DB 1,140        ; LEFT
        DB 6,100        ; HOVER
        DB 0,50         ; UP
        DB 5,40         ; DIAG
        DB 4,130        ; LEFT
        DB 255

M1      DB 1,140        ; LEFT
        DB 6,20         ; HOVER
        DB 4,100        ; RIGHT
        DB 7,20         ; HOVER
        DB 3,60         ; UP
        DB 2,50         ; DIAG
        DB 1,100        ; LEFT
        DB 255

M2      DB 1,160        ; LEFT          
        DB 6,20         ; HOVER
        DB 4,100        ; RIGHT
        DB 3,20         ; UP
        DB 4,70         ; RIGHT
        DB 255

M3      DB 4,140        ; RIGHT
        DB 7,50         ; HOVER
        DB 3,30         ; UP
        DB 2,40         ; DIAG
        DB 1,120        ; LEFT
        DB 255

M4      DB 1,50         ; LEFT
        DB 6,40         ; HOVER
        DB 0,60         ; UP
        DB 2,50         ; DIAG
        DB 1,90 ; LEFT
        DB 255  

M5      DB 1,100        ; LEFT
        DB 3,60         ; UP
        DB 2,50         ; DIAG
        DB 3,60         ; UP
        DB 5,50         ; DIAG
        DB 4,100        ; RIGHT
        DB 255

M6      DB 4,80         ; RIGHT
        DB 5,30         ; DIAG
        DB 4,60         ; RIGHT
        DB 255

M7      DB 1,80         ; LEFT
        DB 2,30         ; DIAG
        DB 1,80         ; LEFT
        DB 255

M8      DB 8,10
        DB 9,10 
        DB 10,10
        ;DB 11,10
        ;DB 12,50
        DB 255


HECYT1  DB 180,190,195,170,180,190,160,160,160
HECXT1  DB 180,180,180,0,180,180,0,180,160

PATHTL  DB >(M0-2),>(M1-2),>(M2-2)
        DB >(M3-2),>(M4-2),>(M5-2)
        DB >(M6-2),>(M7-2),>(M8-2)

PATHTH  DB <(M0-2),<(M1-2),<(M2-2)
        DB <(M3-2),<(M4-2),<(M5-2)
        DB <(M6-2),<(M7-2),<(M8-2)

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
        LDA (TABML0),Y
        CMP #255        ; END OF LIST
        BNE NOE0
        LDA #255
        STA HUSED0
OFFS    RTS

NOE0    TAY     ; HELI 0
        STA HEACT0
        LDA MOVTL,Y
        STA TMPMEM
        LDA MOVTH,Y
        STA TMPMEM+1
        LDY #1
        LDA (TABML0),Y
        STA SPD0
        DEY
        LDA (TMPMEM),Y
        STA THX0+1
        INY
        LDA (TMPMEM),Y
        STA THY0+1
        INY
        LDA (TMPMEM),Y
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

SET1    LDA HUSED1
        BPL OFFS
FIRS1   LDY #9
        JSR RAND
        AND #7
        TAY
EXPI1   LDA PATHTL,Y
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
NEXTB1  LDA TABML1      
        CLC
        ADC #2
        STA TABML1
        BCC SD1
        INC TABML1+1
SD1     LDY #0
        LDA (TABML1),Y
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
        LDA (TABML1),Y
        STA SPD1
        DEY
        LDA (TMPMEM),Y
        STA THX1+1
        INY
        LDA (TMPMEM),Y
        STA THY1+1
        INY
        LDA (TMPMEM),Y
        STA PRT1+1
NOF     RTS     

        ; WORK OUT MEM FOR X,Y
        ; FOR BIT COLOUR MEMORY

MEMXY   CLC
        ADC COLRAML,Y
        STA MIKE1+0     ; COLOUR LOW
        LDA SCREENTEMP
        EOR #SCEOR      ; NOT BUFFER
        ADC COLRAMH,Y
        STA MIKE1+1     ; COLOUR HIGH
        RTS

COLRAML DB &00,&28,&50,&78
        DB &A0,&C8,&F0,&18
        DB &40,&68,&90,&B8
        DB &E0,&08,&30,&58
        DB &80,&A8,&D0,&F8
        DB &20,&48,&70,&98
        DB &C0

COLRAMH DB 0,0,0,0,0,0
        DB 0,1,1,1,1,1,1
        DB 2,2,2,2,2,2,2
        DB 3,3,3,3,3


        ; UTILITIES FOR GAME

        ; SCAN JOYSTICK
JOYGET  LDX #0
        LDA CHUMAN,X
        BEQ RJOY
        JSR AUTOPLAY
        JMP RJOYA
RJOY    STX CIA1+2
        JSR JOYST       ; PORT 1
RJOYA   LDX #1          ; PORT 2
        LDA CHUMAN,X
        BEQ RJOY1
        JSR AUTOPLAY
        JMP RJOY1A
RJOY1   JSR JOYST
       LDX #2
        LDA CHUMAN,X
        BEQ RJOY1A
        JSR AUTOPLAY
        RTS
RJOY1A  LDA #255        ; KEYBOARD
        STA CIA1+2
        LDA #%10111111
        STA CIA1
        LDA CIA1+1
        EOR #%11111111
        STA JOY
        LDA #0
        ASL JOY
        ROL A
        STA RIGHT+2
        LDA #0
        ASL JOY
        ASL JOY
        ROL A
        STA FIRE+2
        LDA #%11011111
        STA CIA1
        LDA CIA1+1
        EOR #%11111111
        STA JOY
        LDA #0
        ASL JOY
        ROL A
        STA LEFT+2
        LDA #0
        ASL JOY
        ROL A
        STA UP+2
        LDA #0
        ASL JOY
        ROL A
        STA DOWN+2

NOFIRE  RTS

JOYST   LDA CIA1,X
        EOR #%00011111
        STA JOY
        LDA #0
        LSR JOY
        ROL A
        STA UP,X
        LDA #0
        LSR JOY
        ROL A
        STA DOWN,X
        LDA #0
        LSR JOY
        ROL A
        STA LEFT,X
        LDA #0
        LSR JOY
        ROL A
        STA RIGHT,X
        LDA #0
        LSR JOY
        ROL A
        STA FIRE,X
        RTS
SCREENWIPE
CLEARN LDY #0
CLEN    LDA #%00000110
        STA NYBBLE+&000,Y
        STA NYBBLE+&100,Y
        STA NYBBLE+&200,Y
        STA NYBBLE+&300,Y
        LDA #0
        STA &F400,Y
        STA &F800,Y
        DEY
        BNE CLEN
        RTS
