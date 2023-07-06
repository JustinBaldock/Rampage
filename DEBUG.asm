CHSET     = $E000
CHARHB    = ($E0)/8
CBASE     = CHSET+(220*8)


;DRAWBULLETS   ; JUST CALL IT AFTER COL
;FIREBULLET   ;X Y A

;DRAWOBJECTS  ; JUST CALL IT BEFORE COL
;SETUPOBJECTS
       
GETCHAR
DISPCHAR  
  LDY FISTY
  LDA MULT40L,Y
  STA BUILD
  LDA MULT40H,Y
  CLC
  ADC #$F4
  STA BUILD+1
  LDY FISTX
  
  
DISMC
  LDA BUILD,Y
  RTS

BEFORECOLOUR
  JSR DRAWOBJECTS    
  JSR DRAWWATER

MMYOU
  LDX #0
  JSR MOVE
  LDX #1
  JSR MOVE
  LDX #2
  JMP MOVE

AFTERCOLOUR
  JSR DRAWBULLETS
  JSR SETUPOBJECTS
  LDA #20
  STA MIKE1

BEER
  JSR OPENWINDOWS
  BCC BOUNC
  DEC MIKE1
  BPL BEER
  
BOUNC
  JSR HELISFIRE
  JMP MMYOU

HELISFIRE
  LDA HEACT0
  CMP #2
  BEQ HELIS1
  CMP #5
  BEQ HELIS1
  RTS
  
HELIS1
  DEC HELFIRE
  LDA HELFIRE
  AND #1
  BEQ HELIS2
  
HELI3
  RTS

HELIS2
  JSR CHK0
  BCS HELI3
  LDX XTEMP
  LDY YTEMP
  LDA HEACT0
  CMP #2
  BEQ LFV 
  ;DEX
  ;DEX
  LDA #3
  JMP DSW
  LFV LDA #5
  ;INX
  ;INX
DSW
  STA DIRECTION
  INY
  INY
  LDA #1
  JSR FIREBULLET
  LDA #1
  LDX #1
  JSR SOUND
  RTS
  
NOBULLETJ
  JMP NOBULLET
  
HELFIRE !byte 0

DRAWBULLETS
  LDX #2
DSET1
  LDA #0
  STA PHIT,X
  LDA X,X 
  LSR ;Implied A
  LSR ;Implied A
  SBC #1
  STA MXMIN,X
  CLC
  ADC #2
  STA MXMAX,X
  LDA Y,X
  LSR ;Implied A   
  LSR ;Implied A
  LSR ;Implied A
  SBC #1
  STA MYMAX,X           
  SEC
  SBC #3
  STA MYMIN,X
  DEX
  BPL DSET1
  LDA MXMIN
  STA FISTX
  LDA MYMIN
  STA FISTY             
  ;JSR DISPCHAR
  LDA MXMAX
  STA FISTX
  LDA MYMAX
  STA FISTY
  ;JSR DISPCHAR
  LDY #31

DRAW1
  LDA BULL2,Y     ; TYPE
  BEQ NOBULLETJ
  LDA SCREENTEMP
  EOR #$C
  CLC
  ADC BULL0,Y
  STA DBSMC+2
  STA DB3SMC+2
  LDA BULL1,Y     ; MLOW
  STA DBSMC+1
  STA DB3SMC+1
  LDA BULL3,Y
  BEQ DBSMC

DBSMC
  LDA $FFFF
  STA DB1SMC+1
  LDA #CHARHB
  ASL DB1SMC+1
  ROL ;Implied A
  ASL DB1SMC+1
  ROL ;Implied A
  ASL DB1SMC+1
  ROL ;Implied A
  STA DB1SMC+2
  LDA BULL8L,Y
  STA DB2SMC+1
  LDA BULL8H,Y
  STA DB2SMC+2
  LDX #7
  
DB1SMC
  LDA $C000,X
  AND BULLETMASK,X
  ORA BULLET,X

DB2SMC
  STA $C000,X
  DEX
  BPL DB1SMC
  TYA
  CLC
  ADC #220
  
DB3SMC
  STA $FFFF

CPLAYER1
  LDA BULL4,Y
  CMP MXMIN
  BCC CPLAYER2
  CMP MXMAX    
  BCS CPLAYER2 
  LDA BULL5,Y
  CMP MYMIN  ;MYMIN  
  BCC CPLAYER2
  CMP MYMAX  ;MYMAX
  BCS CPLAYER2
  LDA #1
  STA PHIT 

CANCELJ
  JMP CANCELBULLET

CPLAYER2
     LDA BULL4,Y
     CMP MXMIN+1
     BCC CPLAYER3
     CMP MXMAX+1
     BCS CPLAYER3
     LDA BULL5,Y
     CMP MYMIN+1  
     BCC CPLAYER3
     CMP MYMAX+1  
     BCS CPLAYER3 
     LDA #1
     STA PHIT+1
     JMP CANCELBULLET

CPLAYER3
  LDA BULL4,Y
  CMP MXMIN+2
  BCC CPLAYER4
  CMP MXMAX+2
  BCS CPLAYER4
  LDA BULL5,Y
  CMP MYMIN+2
  BCC CPLAYER4
  CMP MYMAX+2  
  BCS CPLAYER4
  LDA #1
  STA PHIT+1
  JMP CANCELBULLET
  
CPLAYER4
          LDA BULL3,Y     ; DIRECTION
          TAX
          LDA BULL4,Y
          CLC
          ADC BULXDIR,X
          STA BULL4,Y
          CMP #40
          BCS CANCELJ
          LDA BULL5,Y
          CLC
          ADC BULYDIR,X
          STA BULL5,Y
          CMP #24
          BCS CANCELJ
          CMP #3
          BCC CANCELJ
          LDA BULL1,Y
          CLC
          ADC BUDIRECTL,X
          STA BULL1,Y
          LDA BULL0,Y
          ADC BUDIRECTH,X
          STA BULL0,Y

NOBULLET
  DEY
  BMI ALDONE
DRAW1J
  JMP DRAW1
ALDONE
     LDX #2
NOACTION1
  LDA PHIT,X      
  BEQ NOACTION
  TXA
  PHA
  ;JSR LOSENERGY
  LDA #2
  JSR SOUND
  PLA
  TAX
  
NOACTION
  DEX
  BPL NOACTION1
  RTS

CANCELBULLET
  LDA #0
  STA BULL2,Y
  DEY
  BPL DRAW1J
  BMI ALDONE
          
MANSAVE   !byte 0
FIRERATE  !byte 0

MANFIRE 
  DEC FIRERATE
  LDA FIRERATE
  AND #7
  BNE MANFIRE1
  STY MANSAVE
  LDA OBJ3,Y
  CLC
  ADC #1
  AND #7  
  STA OBJ3,Y
  STA DIRECTION
  LDA OBJ4,Y  ;X
  TAX
  LDA OBJ5,Y
  TAY
  LDA #1
  JSR FIREBULLET
  LDY MANSAVE
  
MANFIRE1
  RTS
  
FIRETEST
          LDA DIRECTION
          AND #3
          STA DIRECTION
          LDX #10
          LDY #10
          LDA #1

FIREBULLET
  ;X Y A=TYPE
  STX BULLETX
  STY BULLETY
  STA BULLETYPE
  LDA DIRECTION
  AND #7
  STA DIRECTION
  LDY #31
  
FIRE1     LDA BULL2,Y
          BEQ GOTSPARE
          DEY
          BPL FIRE1
          RTS
GOTSPARE
          LDA BULLETX
          STA BULL4,Y
          LDA BULLETY
          STA BULL5,Y
          TAX
          LDA MULT40L,X
          CLC
          ADC BULLETX
          STA BULL1,Y
          LDA MULT40H,X
          ADC #0
          STA BULL0,Y
          LDA BULLETYPE
          STA BULL2,Y
          LDA DIRECTION
          STA BULL3,Y
          RTS

;MANINWINDOW INC WINDOWCOUNT
          BEQ PUTMAN
          RTS

PUTMAN    LDA #8
          STA DIRECTION
          INC WINDOW1
          LDA WINDOW1
          AND #7
          STA WINDOW1
          TAY
          LDX MANWX,Y
          LDA MANWY,Y
          TAY
          LDA WINDOW1
          CLC
          ADC #15
          JMP SETUPOBJECT
          ;************************
     ;*


DRAWOBJECTS
  LDY #31

DRAW2
  LDA OBJ2,Y     ; TYPE
  BEQ DNOBJ
  LDA SCREENTEMP
  CLC
  ADC OBJ0,Y
  STA DO3SMC+2
  STA DO4SMC+2
  LDA OBJ1,Y     ; MLOW
  STA DO3SMC+1
  STA DO4SMC+1
  LDA OBJ2,Y
  CMP #$A8
  BCS DO4SMC
  LDA #$A0
  ADC OBJ3,Y       

DO4SMC
  LDX $FFFF
  CPX #$19
  BEQ DO3SMC
  CPX #$E3
  BEQ DO3SMC
  CPX #$53
  BCC CANCELOBJ
  CPX #76
  BCS CANCELOBJ
  BNE CANCELOBJ ;;; WRONG

DO3SMC
  STA $FFFF
  LDA OBJ2,Y
  CMP #$A7
  BCS DNOBJ
  JSR MANFIRE
DNOBJ
  DEY
  BMI ALDONEO1
DRAW2J
  JMP DRAW2
ALDONEO1
          RTS


CANCELOBJ
          LDA #0
          STA OBJ2,Y
          DEY
          BPL DRAW2J
          RTS

SETUPOBJECTS
  INC MANWX 
  BNE SETM1
  INC MANWY
  BNE SETM1
  LDA SYNC
  STA MANWX
  STA MANWY
SETM1 
  LDA SYNC
  AND #15
  TAY
  LDA BULLETCHARS,Y
  CMP #$FF
  BNE PUTOBJON  
  RTS
PUTOBJON
  PHA
  LDA MANWY
  AND #15
  CLC
  ADC #7
  TAY
  LDA MANWX
  AND #31
  CLC
  ADC #7
  TAX
  PLA
SETUPOBJECT
  ;X Y A=TYPE
  STX BULLETX
  STY BULLETY
  STA BULLETYPE
  LDY #31
SW2
  LDA OBJ2,Y
  BEQ GOTSPARE1
  DEY
  BPL SW2
  RTS
GOTSPARE1
  LDA BULLETX
  STA OBJ4,Y
  LDA BULLETY
  STA OBJ5,Y
  TAX
  LDA MULT40L,X
  CLC
  ADC BULLETX
  STA OBJ1,Y
  LDA MULT40H,X
  ADC #0
  STA OBJ0,Y
  LDA BULLETYPE
  STA OBJ2,Y
  LDA #0
  STA OBJ3,Y
  RTS

MXMAX
  !fill 3
MYMAX
  !fill 3
MXMIN
  !fill 3
MYMIN
  !fill 3
WINDOW1   !byte 0
WINDOWCOUNT !byte 0
OBJECTPOINT !byte 0
BULLETX   !byte 0
BULLETY   !byte 0
BULLETYPE !byte 0
DIRECTION !byte 0
MANWY     !byte 5,20,15,17,4,5,6,8,10
MANWX     !byte 10,20,12,4,5,6,16,2,20,26
BUDIRECTL !byte >-40,>-39,>1,>41,>40,>39,>-1,>-41,0
BUDIRECTH !byte <-40,<-39,<1,<41,<40,<39,<-1,<-41,0
BULXDIR   !byte 0,1,1,1,0,-1,-1,-1,0
BULYDIR   !byte -1,-1,0,1,1,1,0,-1,0

BULLETMEM ; MEM
          ; DIR,TYPE,X,Y,TPOS
    

BULLETWIPE
BULL0     !fill 32 ; MEM HIGH
BULL1     !fill 32 ; MEM LOW
BULL2     !fill 32 ; TYPE
BULL3     !fill 32 ; DIRECTION
BULL4     !fill 32 ; XPOS
BULL5     !fill 32 ; YPOS
BULL6     !fill 32 ; TPOS
BULL7     !fill 32 ; CHAR

OBJECTWIPE
OBJ0      !fill 32 ; MEM HIGH
OBJ1      !fill 32 ; MEM LOW
OBJ2      !fill 32 ; TYPE
OBJ3      !fill 32 ; DIRECTION
OBJ4      !fill 32 ; XPOS
OBJ5      !fill 32 ; YPOS
OBJ6      !fill 32 ; TPOS
OBJ7      !fill 32 ; CHAR

BUILDTYPE  !fill 8,$FF
BUILDWIDE  !fill 8,$FF 
BUILDWIDE1 !fill 8,$FF
BUILDTALL  !fill 8,$FF
BUILDDUST  !fill 8,$FF
  

BULL8H
          !byte <((0*8)+CBASE)
          !byte <((1*8)+CBASE)
          !byte <((2*8)+CBASE)
          !byte <((3*8)+CBASE)
          !byte <((4*8)+CBASE)
          !byte <((5*8)+CBASE)
          !byte <((6*8)+CBASE)
          !byte <((7*8)+CBASE)
          !byte <((8*8)+CBASE)
          !byte <((9*8)+CBASE)
          !byte <((10*8)+CBASE)
          !byte <((11*8)+CBASE)
          !byte <((12*8)+CBASE)
          !byte <((13*8)+CBASE)
          !byte <((14*8)+CBASE)
          !byte <((15*8)+CBASE)
          !byte <((16*8)+CBASE)
          !byte <((17*8)+CBASE)
          !byte <((18*8)+CBASE)
          !byte <((19*8)+CBASE)
          !byte <((20*8)+CBASE)
          !byte <((21*8)+CBASE)
          !byte <((22*8)+CBASE)
          !byte <((23*8)+CBASE)
          !byte <((24*8)+CBASE)
          !byte <((25*8)+CBASE)
          !byte <((26*8)+CBASE)
          !byte <((27*8)+CBASE)
          !byte <((28*8)+CBASE)
          !byte <((29*8)+CBASE)
          !byte <((30*8)+CBASE)
          !byte <((31*8)+CBASE)

BULL8L
          !byte >((0*8)+CBASE)
          !byte >((1*8)+CBASE)
          !byte >((2*8)+CBASE)
          !byte >((3*8)+CBASE)
          !byte >((4*8)+CBASE)
          !byte >((5*8)+CBASE)
          !byte >((6*8)+CBASE)
          !byte >((7*8)+CBASE)
          !byte >((8*8)+CBASE)
          !byte >((9*8)+CBASE)
          !byte >((10*8)+CBASE)
          !byte >((11*8)+CBASE)
          !byte >((12*8)+CBASE)
          !byte >((13*8)+CBASE)
          !byte >((14*8)+CBASE)
          !byte >((15*8)+CBASE)
          !byte >((16*8)+CBASE)
          !byte >((17*8)+CBASE)
          !byte >((18*8)+CBASE)
          !byte >((19*8)+CBASE)
          !byte >((20*8)+CBASE)
          !byte >((21*8)+CBASE)
          !byte >((22*8)+CBASE)
          !byte >((23*8)+CBASE)
          !byte >((24*8)+CBASE)
          !byte >((25*8)+CBASE)
          !byte >((26*8)+CBASE)
          !byte >((27*8)+CBASE)
          !byte >((28*8)+CBASE)
          !byte >((29*8)+CBASE)
          !byte >((30*8)+CBASE)
          !byte >((31*8)+CBASE)
BULLETMASK
          !byte %11111111
          !byte %11111111
          !byte %11001111
          !byte %00000011
          !byte %00000011
          !byte %11001111
          !byte %11111111
          !byte %11111111

BULLET
          !byte %00000000
          !byte %00000000
          !byte %00010000
          !byte %01100100
          !byte %01100100
          !byte %00010000
          !byte %00000000
          !byte %00000000

OBJECTSTART

BULLETCHARS
  !byte $FE ; BULLET 0
  !byte $FE ; GRENADE 1
  !byte $CD ; BONUS 0TURKEY
  !byte $CE ; BONUS 1BULBOFF
  !byte $C2 ; BONUS 2MILK
  !byte $C3 ; BONUS 3SAFE
  !byte $C4 ; BONUS 4MONEY
  !byte $C5 ; BONUS 5TV
  !byte $C5 ; POT
  !byte $CF ; DANGER 0BULB ON
  !byte $D0 ; DANGER 1CACTUS
  !byte $A0 ; DANGER 2
  !byte $A1 ; DANGER 3
  !byte $A2 ; DANGER 4
  !byte $A3 ; DANGER 5
  !byte $A4 ; MAN 0
  !byte $A1 ; MAN 1
  !byte $A2 ; MAN 2
  !byte $A3 ; MAN 3
  !byte $A4 ; MAN 4
  !byte $A5 ; MAN 5
  !byte $A6 ; MAN 6
  !byte $A7 ; MAN 7
  !byte $FF ; END OF LIST   

OBJECTEND
  !byte $FF
  !byte $FF

MULT40L
  !word >0*40
  !word >1*40
  !word >2*40
  !word >3*40
  !word >4*40
  !word >5*40
  !word >6*40
  !word >7*40
  !word >8*40
  !word >9*40
  !word >10*40
  !word >11*40
  !word >12*40
  !word >13*40
  !word >14*40
  !word >15*40
  !word >16*40
  !word >17*40
  !word >18*40
  !word >19*40
  !word >20*40
  !word >21*40
  !word >22*40
  !word >23*40
  !word >24*40
  !word >25*40

MULT40H
  !word <0*40
  !word <1*40
  !word <2*40
  !word <3*40
  !word <4*40
  !word <5*40
  !word <6*40
  !word <7*40
  !word <8*40
  !word <9*40
  !word <10*40
  !word <11*40
  !word <12*40
  !word <13*40
  !word <14*40
  !word <15*40
  !word <16*40
  !word <17*40
  !word <18*40
  !word <19*40
  !word <20*40
  !word <21*40
  !word <22*40
  !word <23*40
  !word <24*40
  !word <25*40

BXPOINT
  !word BXS0,BXS1,BXS2,BXS3,BXS4
  !word BXS5,BXS6,BXS7,BXS8,BXS9
  !word BXS10,BXS11,BXS12,BXS13
  !word BXS14,BXS15,BXS16,BXS17
  !word BXS18,BXS19,BXS0,BXS0

TYPOINT
  !word BTYPE0,BTYPE1,BTYPE2,BTYPE3  
  !word BTYPE4,BTYPE5,BTYPE6,BTYPE7
  !word BTYPE8,BTYPE9,BTYPE10,BTYPE11
  !word BTYPE12,BTYPE13,BTYPE14,BTYPE15
  !word BTYPE16,BTYPE17,BTYPE18,BTYPE19,BTYPE20,BTYPE20
    ; BUILDING X'S

BXS0    !byte 10,4,26
BXS1    !byte 4,12,24,6,18,30
BXS2    !byte 4,16,30,6,20
BXS3    !byte 2,16,10,28
BXS4    !byte 26,4,20
BXS5    !byte 10,22,4,16,28
BXS6    !byte 8,22,4,26
BXS7    !byte 6,18,12,30
BXS8    !byte 26,16,4,22,10
BXS9    !byte 14,26,6,30
BXS10   !byte 26,4,10
BXS11   !byte 30,18,6,24,12,0
BXS12   !byte 20,6,30,16,4
BXS13   !byte 28,10,16,2
BXS14   !byte 20,4,26
BXS15   !byte 28,16,4,22,10
BXS16   !byte 26,4,22,8
BXS17   !byte 30,12,18,6
BXS18   !byte 10,22,4,16,28
BXS19   !byte 30,6,26,14
BXS20   !byte 20,$FF

    ; BUILDING TYPES


BTYPE0    !byte 0,1,2,$FF
BTYPE1    !byte 4,5,0,0,2,$FF
BTYPE2    !byte 2,1,0,5,3,$FF
BTYPE3    !byte 4,5,0,0,$FF
BTYPE4    !byte 4,2,0,$FF
BTYPE5    !byte 5,3,0,2,1,$FF
BTYPE6    !byte 4,5,1,1,$FF
BTYPE7    !byte 0,0,5,3,$FF
BTYPE8    !byte 3,5,3,1,2,$FF
BTYPE9    !byte 5,4,1,0,$FF
BTYPE10 !byte 3,2,5,$FF
BTYPE11 !byte 2,0,0,5,3,4,$FF
BTYPE12 !byte 3,5,0,1,2,$FF
BTYPE13 !byte 0,0,5,4,$FF
BTYPE14 !byte 0,2,4,$FF
BTYPE15 !byte 1,2,0,3,5,$FF
BTYPE16 !byte 1,1,5,4,$FF
BTYPE17 !byte 0,0,5,3,$FF
BTYPE18 !byte 2,1,3,5,3,$FF
BTYPE19 !byte 0,1,4,5,$FF
BTYPE20 !byte 0,$FF


DAVE1  !byte 0
DAVE2   !byte 0
DAVE3 !byte 0
PHIT    !fill 3
