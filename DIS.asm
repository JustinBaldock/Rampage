SHB   = $F8  ;SCREEN AT $F400 
COLDIFF   = $1C

BLCOLOR = COLMEM1
BLDAVE    = >DTILES  ;BLOCK DEFF BASE ADDRESS

DEMO
  LDA #1

PLAYERSELECT    
  ;JSR MANYPLAY

INTERCITY
  JSR DRIVER

HIGHSCOREPROG
  JSR DRIVER2

BONUS
  JSR DRIVER3
  INC STATUS
  JMP MAIN

INITIALISE
  LDA STATUS
  BEQ DEMO
  JMP NODEM

;***********************************

DRIVER2
  JSR DRISET ;SCORE
  LDX #0
  ;JSR PLAYTUNE
  LDY #14
  STY TILENUM
ABCDR2
  LDA PLAYSELE,Y
  STA SELBUFF,Y
  DEY
  BPL ABCDR2
  JSR DISPLAY
  JSR PUTONCOL
  LDA #10
  STA NEWLINE
  LDA #<SELTEXT
  STA GETTEXT+1
  LDA #>SELTEXT
  STA GETTEXT+2
  LDA #45
  STA PUTTEXT+1
  LDA #SHB
  STA PUTTEXT+2
  JSR GETTEXT
  LDA #<SCOTEXTH  
  STA GETTEXT+1
  LDA #>SCOTEXTH
  STA GETTEXT+2
  LDA STEXTPOSL
  STA PUTTEXT+1
  LDA STEXTPOSH
  STA PUTTEXT+2
  JSR GETTEXT
  LDA #<SCOTEXTL
  STA GETTEXT+1
  LDA #>SCOTEXTL
  STA GETTEXT+2
  LDA HTEXTPOSL
  STA PUTTEXT+1
  LDA HTEXTPOSH
  STA PUTTEXT+2
  JSR GETTEXT
  LDY #2
  STY STEMP
SCONSC
  LDY STEMP   
  LDX PLAYCHAR,Y
  JSR HIGHSCORE
  JSR SCPUTON
  DEC STEMP
  BPL SCONSC
  LDX #39
  LDA #0
CLBOT
  STA SHB*256+960,X
  DEX
  BPL CLBOT
  JSR PUTONCOL
  JMP DELAY

;************************************

HIGHSCORE
  LDX #2
CHPOINTPUT
  LDA SCOLB,X
  STA SCCH+1
  STA SCCH2+1
  LDA SCOHB,X
  STA SCCH+2
  STA SCCH2+2
  LDA HILB,X
  STA HICH+1
  STA HICH2+1
  LDA HIHB,X
  STA HICH+2
  STA HICH2+2
  LDY #0
HICH
  LDA $FFFF,Y
SCCH
  CMP $FFFF,Y
  BCC NEXTDIGIT
  BEQ NEXTDIGIT
UPHIGH
  LDY #5
SCCH2
  LDA $FFFF,Y
HICH2
  STA $FFFF,Y
  DEY
  BPL SCCH2
  BMI NEXTSCORE
NEXTDIGIT
  INY
  CPY #6
  BNE HICH
NEXTSCORE
  DEX
  BPL CHPOINTPUT
  RTS

;************************************

SCPUTON
  LDA SCOLB,X
    STA GETTEXT+1
    LDA SCOHB,X
    STA GETTEXT+2
    LDA SCPOSL,X
    STA PUTTEXT+1
    LDA SCPOSH,X
    STA PUTTEXT+2
    JSR GETTEXT
    LDA HILB,X
    STA GETTEXT+1
    LDA HIHB,X
    STA GETTEXT+2
    LDA HPOSL,X
    STA PUTTEXT+1
    LDA HPOSH,X
    STA PUTTEXT+2
    JSR GETTEXT
    JSR PUTONCOL
    RTS

;********************************

; 2023-07-17 Justin Baldock
; 
DRISET
  LDA #0
  STA $FFFA ; why change part of NMI service routine pointer?
  SEI ; disable interrupt
  STA VIC_SPRITE_ENABLE ; turn off all sprites
  LDA #$1B ; %0001 1011
  STA VIC_CONTROL_REGISTER1 ; bit 0=unused, bits 1-3=char memory $2800-$2FFF in vic bank, bits 4-7=Screen ram $0400-$07FF in vic bank
  LDA #7
  STA COLOUR1 ; set colour1 to be yellow
  LDA #11   
  STA COLOUR2 ; set colour2 to be dark grey
  RTS 

;*********************************

DRIVER3
  JSR DRISET
  LDX #1
  ;JSR PLAYTUNE
  LDA #12
  STA NEWLINE
  LDX #0
  TXA

CLEAR
  STA SHB*256+0,X
  STA SHB*256+256,X
  STA SHB*256+512,X
  STA SHB*256+768-24,X
  DEX
  BNE CLEAR
  LDA #44
  STA PUTTEXT+1
  LDA #SHB
  STA PUTTEXT+2
  LDA #<DBONUS
  STA GETTEXT+1
  LDA #>DBONUS
  STA GETTEXT+2
  JSR GETTEXT
  JSR PUTONCOL
  JMP DELAY

;**********************************

DELPROG
  LDA #60
  STA DELDAVE
.INDEL
  JSR JOYDAVE
  DEC DELDAVE+1             
  BNE .INDEL
  DEC DELDAVE
  BNE .INDEL
  RTS

;***********************************
;
DELAY
  LDA #100    
  STA DELDAVE+1
  LDX #255
  LDY #255
.delay.loop
  JSR ALLFIRE
  BNE .delay.end
  DEY
  BNE .delay.loop
  DEX
  BNE .delay.loop
  DEC DELDAVE+1
  BNE .delay.loop
.delay.end
  JSR ALLFIRE
  BNE .delay.end
  RTS

;*****************************
;
ALLFIRE
  JSR JOYGET
  LDA FIRE
  ORA FIRE+1 ; 
  ORA FIRE+2
  RTS

;*****************************

TEXTRAND
  LDA TEXTSEED
  ASL ;Implied A
  ASL ;Implied A
  CLC
  ADC TEXTSEED
  CLC
  ADC #127
  STA TEXTSEED
  RTS

;*****************************

DRIVER
  JSR DRISET    
  LDX #2
  ;JSR PLAYTUNE ; something happening in music which loops
  JSR MAPMOD ; JB It appears to load a screens worth of data
  JSR TEXTMAIN 
  LDA #<((SHB*256)+960)
  STA PUTTEXT+1
  LDA #>((SHB*256)+960)
  STA PUTTEXT+2
  LDA #<FIRETEXT
  STA GETTEXT+1
  LDA #>FIRETEXT
  STA GETTEXT+2
  JSR GETTEXT
  JSR PUTONCOL    
  JSR DELPROG
  RTS

;********************************

MANYPLAY
  JSR DRISET
  LDX #0
  ;JSR PLAYTUNE
  LDA #<[[SHB*256]+960]
  STA PUTTEXT+1
  LDA #>[[SHB*256]+960]
  STA PUTTEXT+2
  LDA #<FIRETEXT1
  STA GETTEXT+1
  LDA #>FIRETEXT1
  STA GETTEXT+2
  JSR GETTEXT
  LDA #24
  STA NEWLINE
  LDX #1
  STX ENERGY
  STX ENERGY+1
  STX ENERGY+2
  LDX #0
  STX TAKEN
  STX TAKEN+1
  STX TAKEN+2
  STX XXXXXX

MANYLOOP
  LDY #9*8
  STY CDEL

MANYLOOPIN
  JSR MAPMOD
  LDX XXXXXX
  LDA TEXTPOSLB,X
  STA PUTTEXT+1
  SEC
  SBC #4
  STA PUTCDOWN+1
  LDA TEXTPOSHB,X
  STA PUTTEXT+2
  STA PUTCDOWN+2
  LDA #<PLFO
  STA GETTEXT+1
  LDA #>PLFO
  STA GETTEXT+2
  JSR GETTEXT
  LDA PLPOINTLB,X
  STA GETTEXT+1
  LDA PLPOINTHB,X
  STA GETTEXT+2
  JSR GETTEXT
  LDA CDEL
  LSR ;Implied A
  LSR ;Implied A
  LSR ;Implied A
  CLC
  ADC #$40
    
PUTCDOWN
  STA $FFFF
  JSR PUTONCOL
  JSR JOYGET
  LDX XXXXXX
  LDY PLAYCHAR,X
  LDA ENERGY,X
  CMP #6
  LDA #50
  STA PDEL+1
  BEQ DELCHECK

PLAYDEL
  DEC PDEL
  BNE PLAYDEL
  DEC PDEL+1
  BNE PLAYDEL
  LDA LEFT,X
  BEQ DJNOLEFT
  DEY     
  BPL DJFCHECK
  LDY #2

DJNOLEFT
  LDA RIGHT,X
  BEQ DJFCHECK
  INY
  CPY #3
  BNE DJFCHECK
  LDY #0

DJFCHECK
  TYA
  STA PLAYCHAR,X
  LDA FIRE,X
  BEQ DELCHECK
  LDA TAKEN,Y
  BNE DELCHECK
  LDA #6
  STA ENERGY,X
  STA TAKEN,Y
  JMP TOOK

DELCHECK
  TYA
  STA PLAYCHAR,X
  DEC CDEL
  BEQ TOOK
  JMP MANYLOOPIN

TOOK
  INC XXXXXX
  LDX XXXXXX
  CPX #3
  BEQ DWH
  JMP MANYLOOP

DWH
  LDX #2

ENEVERT
  LDA ENERGY,X
  CMP #6
  BNE NOTINP
  LDA #127
  BPL PLAYERIN

NOTINP
  LDA #255

PLAYERIN
  STA ENERGY,X
  DEX
  BPL ENEVERT
  RTS

;*******************************

TEXTMAIN
  LDX #2
  STX TCOUNT
  LDA #68
  STA NEWLINE
PLAYTEXT
  LDY TCOUNT
  LDA ENERGY,Y
  BNE PL1CH
  LDY #10
  JMP SETTEXT
PL1CH
  BPL PL2CH
  LDY #0    
  JMP SETTEXT
PL2CH
  CMP #127
  BNE PLAING
  LDY #1
  JMP SETTEXT
PLAING
  LDA TCOUNT  
  CLC
  ADC SCREEN
  EOR #3
  AND #7
  TAY
  INY   
  INY
SETTEXT
  LDA TEXTLB,Y
  STA GETTEXT+1
  LDA TEXTHB,Y
  STA GETTEXT+2
  LDY TCOUNT
  LDA TEXTPOSLB,Y
  STA PUTTEXT+1
  LDA TEXTPOSHB,Y
  STA PUTTEXT+2
  JSR GETTEXT
  DEC TCOUNT
  BPL PLAYTEXT
  RTS

;******************************

MAPMOD
  LDY #14
  STY TILENUM
BUFLOOP
  LDA SELDEFF,Y   
  STA SELBUFF,Y
  DEY
  BPL BUFLOOP
  LDX #2
DEAD2
  LDA ENERGY,X
  BEQ DEAD1
  BMI DEAD1
  LDY PLAYCHAR,X
  LDA GERALZ,Y
  LDY MODTILEL,X
  STA SELBUFF,Y
  LDA ENERGY,X
  CMP #127
  BEQ DEAD1   
  LDY PLAYCHAR,X
  LDA GERALZ1,Y
  LDY MODTILER,X
  STA SELBUFF,Y
DEAD1
  DEX       
  BPL DEAD2
DISPLAY
  LDX TILENUM    ; X=SCPOS
  LDY SELBUFF,X  ; Y=TILE
  JSR TILETEST
  DEC TILENUM
  BPL DISPLAY
  RTS

;**********************************

PUTONCOL
  LDY #0
PUTINCOL
  LDX $F800,Y     
  TXA
  STA $F400,Y
  LDA BLCOLOR,X   
  STA $D800,Y     
  LDX $F900,Y
  TXA
  STA $F500,Y
  LDA BLCOLOR,X
  STA $D900,Y
  LDX $FA00,Y
  TXA
  STA $F600,Y
  LDA BLCOLOR,X
  STA $DA00,Y
  LDX $FB00,Y
  TXA
  STA $F700,Y
  LDA BLCOLOR,X
  STA $DB00,Y 
  DEY
  BNE PUTINCOL
  RTS

;******************************

GETTEXT
  LDA $FFFF
  CMP #254
  BEQ NEXTLINE
  CMP #255    
  BNE PUTTEXT
  RTS
PUTTEXT
  STA $FFFF
  LDA GETTEXT+1
  CLC
  ADC #1
  STA GETTEXT+1
  LDA GETTEXT+2
  ADC #0
  STA GETTEXT+2
  LDA PUTTEXT+1
  CLC
  ADC #1
  STA PUTTEXT+1
  LDA PUTTEXT+2
  ADC #0
  STA PUTTEXT+2
  JMP GETTEXT
NEXTLINE
  LDA GETTEXT+1
  CLC
  ADC #1
  STA GETTEXT+1
  LDA GETTEXT+2
  ADC #0
  STA GETTEXT+2
  LDA PUTTEXT+1
  CLC
  ADC NEWLINE
  STA PUTTEXT+1
  LDA PUTTEXT+2
  ADC #0
  STA PUTTEXT+2
  JMP GETTEXT

;*******************************

JOYDAVE
  JSR JOYGET
  LDY #2
  STY JOYY
JOYLOOP
  LDY JOYY      
  LDA FIRE,Y
  BEQ NODJ2
  LDA ENERGY,Y
  CMP #127
  BNE NODJ2
  LDA #6  
  STA ENERGY,Y
  JSR MAPMOD
  JSR TEXTMAIN
  JSR PUTONCOL
NODJ2
  DEC JOYY
  BPL JOYLOOP
  RTS

;*********************************

    ; Y=TILE      
    ; X=TILE POS

;********************************

TILETEST
  LDA BLOMLB,Y
  STA TILELOP+1
  LDA BLOMHB,Y
  STA TILELOP+2
  LDA SCRMLB,X
  STA TSMC1+1
  LDA SCRMHB,X
  STA TSMC1+2
  LDX #0
  LDY #0
TILELOP
  LDA $FFFF,X
TSMC1
  STA $FFFF,Y
  INX
  INY
  CPY #8    
  BNE TILELOP
  LDA TSMC1+1         
  CLC
  ADC #40
  STA TSMC1+1
  LDA TSMC1+2
  ADC #0    
  STA TSMC1+2
  LDY #0
  CPX #8*8
  BNE TILELOP
  RTS

;************************************
; X=TUNE
PLAYTUNE
  LDX #0  
  SEI   ; 0 1 3
  LDA #0
  STA $207
  LDA #<MUSIC     ; FF STOP
  STA $FFFE
  LDA #>MUSIC   
  STA $FFFF
  JSR SIDWIPE
  JSR $203
  INC $207
  CLI
  RTS

; -----
; 2023/06/26 J.Baldock - clear all sid settings from D400 to D41C
SIDWIPE
  ; set loop counter and variable
  LDA #0
  LDY #$1C
sidwipe.loop
  STA $D400,Y
  DEY
  BPL sidwipe.loop ; if Y >= 0 then loop
  RTS

;**************************************

MUSIC
  PHA   
  TXA   
  PHA
  TYA
  PHA
  JSR $0200
    
NOMUS
  LDA #1    
  STA $D019
  LDA #%11011010
  STA $D018
  LDA #200
  STA $D012
  PLA
  TAY
  PLA
  TAX
  PLA
  RTI

;**********************************

TEXT
;JOIN  THE
; ACTION
    !byte $12,$17,$11,$16,$51,$51,$1C,$10,$0D,$51,$51,$51,$FE
    !byte $51,$09,$0B,$1C,$11,$17,$16,$FF

TEXT1
;READY  FOR
; ACTION
    !byte $1A,$0D,$09,$0C,$21,$51,$51,$0E,$17,$1A,$51,$51,$FE
    !byte $51,$09,$0B,$1C,$11,$17,$16,$51,$51,$51,$51,$51,$FF

TEXT2
;HINT... WANT
;TO EAT. WELL   
;PUNCH SLOWER
    !byte $10,$11,$16,$1C,$4A,$4A,$4A,$51,$1F,$09,$16,$1C,$FE
    !byte $1C,$17,$51,$0D,$09,$1C,$4A,$51,$1F,$0D,$14,$14,$FE
    !byte $18,$1D,$16,$0B,$10,$51,$1B,$14,$17,$1F,$0D,$1A,$FF

TEXT3
;HINT... JUMP
;WHEN YOU SEE
;DUST  CLOWDS
    !byte $10,$11,$16,$1C,$4A,$4A,$4A,$51,$12,$1D,$15,$18,$FE
    !byte $1F,$10,$0D,$16,$51,$21,$17,$1D,$51,$1B,$0D,$0D,$FE
    !byte $0C,$1D,$1B,$1C,$51,$51,$0B,$14,$17,$1F,$0C,$1B,$FF

TEXT4
;SPOUSE  OF
;MUTANT FILES
;LEGAL ACTION
    !byte $1B,$18,$17,$1D,$1B,$0D,$51,$51,$17,$0E,$51,$51,$FE
    !byte $15,$1D,$1C,$09,$16,$1C,$51,$0E,$11,$14,$0D,$1B,$FE
    !byte $14,$0D,$0F,$09,$14,$51,$09,$0B,$1C,$11,$17,$16,$FF

TEXT5
;OVER GROWING
;CONCERN OVER
;MEGA VITAMIN
    !byte $17,$1E,$0D,$1A,$51,$0F,$1A,$17,$1F,$11,$16,$0F,$FE
    !byte $0B,$17,$16,$0B,$0D,$1A,$16,$51,$17,$1E,$0D,$1A,$FE
    !byte $15,$0D,$0F,$09,$51,$1E,$11,$1C,$09,$15,$11,$16,$FF

TEXT6
;EXPERIMENTAL
;VITAMIN  HAS
;ILL  EFFECTS
    !byte $0D,$20,$18,$0D,$1A,$11,$15,$0D,$16,$1C,$09,$14,$FE
    !byte $1E,$11,$1C,$09,$15,$11,$16,$51,$51,$10,$09,$1B,$FE
    !byte $11,$14,$14,$51,$51,$0D,$0E,$0E,$0D,$0B,$1C,$1B,$FF

TEXT7
;WOMAN  FINDS
;LAKE  TO  BE
;RADIOACTIVE
    !byte $1F,$17,$15,$09,$16,$51,$51,$0E,$11,$16,$0C,$1B,$FE
    !byte $14,$09,$13,$0D,$51,$51,$1C,$17,$51,$51,$0A,$0D,$FE
    !byte $1A,$09,$0C,$11,$17,$09,$0B,$1C,$11,$1E,$0D,$4A,$FF

TEXT8
;UNUSUAL FOOD
;ADDITIVE MAY
;BE  RECALLED
    !byte $1D,$16,$1D,$1B,$1D,$09,$14,$51,$0E,$17,$17,$0C,$FE
    !byte $09,$0C,$0C,$11,$1C,$11,$1E,$0D,$51,$15,$09,$21,$FE
    !byte $0A,$0D,$51,$51,$1A,$0D,$0B,$09,$14,$14,$0D,$0C,$FF

TEXT9
;SUSPECTED..
;POLLUTION OF
;WATER SUPPLY
    !byte $1B,$1D,$1B,$18,$0D,$0B,$1C,$0D,$0C,$4A,$4A,$51,$FE
    !byte $18,$17,$14,$14,$1D,$1C,$11,$17,$16,$51,$17,$0E,$FE
    !byte $1F,$09,$1C,$0D,$1A,$51,$1B,$1D,$18,$18,$14,$21,$FF

TEXT10
;...CURED....
;GO  BACK  TO
;NORMAL  LIFE
    !byte $4A,$4A,$4A,$0B,$1D,$1A,$0D,$0C,$4A,$4A,$4A,$4A,$FE
    !byte $0F,$17,$51,$51,$0A,$09,$0B,$13,$51,$51,$1C,$17,$FE
    !byte $16,$17,$1A,$15,$09,$14,$51,$51,$14,$11,$0E,$0D,$FF

;TEXT POINTERS

TEXTLB
  !byte <TEXT,<TEXT1,<TEXT2,<TEXT3,<TEXT4,<TEXT5,<TEXT6,<TEXT7,<TEXT8,<TEXT9,<TEXT10

TEXTHB
  !byte >TEXT,>TEXT1,>TEXT2,>TEXT3,>TEXT4,>TEXT5,>TEXT6,>TEXT7,>TEXT8,>TEXT9,>TEXT10

;*********************************

SELTEXT

; YOU MUST EAT FOOD TO SURVIVE
;
;CLIMB BUILDINGS AND PUNCH OPEN
;     WINDOWS TO FIND FOOD
;
;   DESTROY ALL BUILDINGS TO
;     ADVANCE TO NEXT CITY
    !byte $51,$21,$17,$1D,$51,$15,$1D,$1B,$1C,$51
    !byte $0D,$09,$1C,$51,$0E,$17,$17,$0C,$51,$1C
    !byte $17,$51,$1B,$1D,$1A,$1E,$11,$1E,$0D,$51,$FE
    !byte $30,$51
    !byte $FE
    !byte $0B,$14,$11,$15,$0A,$51,$0A,$1D,$11,$14
    !byte $0C,$11,$16,$0F,$1B,$51,$09,$16,$0C,$51
    !byte $18,$1D,$16,$0B,$10,$51,$17,$18,$0D,$16,$FE
    !byte $51,$51,$51,$51,$51,$1F,$11,$16,$0C,$17
    !byte $1F,$1B,$51,$1C,$17,$51,$0E,$11,$16,$0C
    !byte $51,$0E,$17,$17,$0C,$51,$51,$51,$51,$51,$FE
    !byte 30,$51
    !byte $FE
    !byte $51,$51,$51,$0C,$0D,$1B,$1C,$1A,$17,$21
    !byte $51,$09,$14,$14,$51,$0A,$1D,$11,$14,$0C
    !byte $11,$16,$0F,$1B,$51,$1C,$17,$51,$51,$51,$FE
    !byte $51,$51,$51,$51,$51,$09,$0C,$1E,$09,$16
    !byte $0B,$0D,$51,$1C,$17,$51,$16,$0D,$20,$1C
    !byte $51,$0B,$11,$1C,$21,$51,$51,$51,$51,$51,$FF
RESETALL
MESPRI
  !byte $2F,$2B,$35,$35,$00,$3B,$31,$37,$FE
  !byte $25,$37,$26,$26,$2E,$27,$00,$39,$2A,$37,$2F,$32,$00,$28,$2E,$37,$2F,$32,$00,$26,$37,$30,$2D,$35,$FF

FIRETEXT
  ;PRESS FIRE TO JOIN THE ACTION
    !byte $00,$00,$00,$00,$00,$32,$34,$27,$35,$35,$00,$28,$2B,$34,$27,$00,$36,$31,$00,$2C,$31,$2B,$30
    !byte $00,$36,$2A,$27,$00,$23,$25,$36,$2B,$31,$30,$00,$00,$00,$00,$00,$00,$FF
FIRETEXT1
;THEN PRESS FIRE
    !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$36,$2A,$27,$30,$00,$32,$34,$27
    !byte $35,$35,$00,$28,$2B,$34,$27,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F

PLFO    
;LEFT OR RIGHT TO
;SELECT CHARACTER
;PLAYER
  !byte $14,$0D,$0E,$1C,$51,$17,$1A,$51,$1A,$11,$0F,$10,$1C,$51,$1C,$17,$FE
  !byte $1B,$0D,$14,$0D,$0B,$1C,$51,$0B,$10,$09,$1A,$09,$0B,$1C,$0D,$1A,$FE
  !byte $18,$14,$09,$21,$0D,$1A,$51,$FF
PLNUM
;ONE
  !byte $17,$16,$0D,$FF
PLNUM1
;TWO
  !byte $1C,$1F,$17,$FF
PLNUM2
;THREE
  !byte $1C,$10,$1A,$0D,$0D,$FF

PLPOINTLB
  !byte <PLNUM,<PLNUM1,<PLNUM2 

PLPOINTHB
  !byte >PLNUM,>PLNUM1,>PLNUM2

;********************************

;BONUS  ITEMS
;
;EXTRA SCORE
;
;LIGHT BULB OFF           100 PTS
;TELEVISION                 75 PTS
;SAFE                      50 PTS
;MONEY BAG                125 PTS
;
;        EXTRA ENERGY
;CASSEROLE POT
;TURKEY
;GLASS OF MILK
;BOTTLE OF MILK
;
;
;       LOSS OF ENERGY
;LIGHT BULB ON
;CACTUS
;BOTTLE OF POISON
;
DBONUS
  !byte $00,$00,$00,$00,$00,$00,$00,$00,$24,$31,$30,$37,$35,$00,$00,$2B,$36,$27,$2F,$35,$00,$00,$00,$00,$00,$00,$00,$00,$FE
  !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FE
  !byte $0D,$20,$1C,$1A,$09,$51,$1B,$0B,$17,$1A,$0D,$51,$51,$51,$51,$51,$51,$51,$51,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FE
  !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FE
  !byte $2E,$2B,$29,$2A,$36,$00,$24,$37,$2E,$24,$00,$31,$28,$28,$00,$00,$41,$40,$40,$00,$32,$36,$35,$00,$00,$00,$84,$00,$FE
  !byte $36,$27,$2E,$27,$38,$2B,$35,$2B,$31,$30,$00,$00,$00,$00,$00,$00,$00,$47,$45,$00,$32,$36,$35,$00,$00,$00,$00,$A4,$FE
  !byte $35,$23,$28,$27,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$45,$40,$00,$32,$36,$35,$00,$00,$00,$C5,$00,$FE
  !byte $2F,$31,$30,$27,$3B,$00,$24,$23,$29,$00,$00,$00,$00,$00,$00,$00,$41,$42,$45,$00,$32,$36,$35,$00,$00,$00,$00,$C6,$FE
  !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FE
  !byte $0D,$20,$1C,$1A,$09,$51,$0D,$16,$0D,$1A,$0F,$21,$51,$51,$51,$51,$51,$51,$51,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FE
  !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FE
  !byte $25,$23,$35,$35,$27,$34,$31,$2E,$27,$00,$32,$31,$36,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$A5,$00,$FE
  !byte $36,$37,$34,$2D,$27,$3B,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$A6,$FE
  !byte $29,$2E,$23,$35,$35,$00,$31,$28,$00,$2F,$2B,$2E,$2D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E5,$00,$FE
  !byte $24,$31,$36,$36,$2E,$27,$00,$31,$28,$00,$2F,$2B,$2E,$2D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C3,$FE
  !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E3,$FE
  !byte $14,$17,$1B,$1B,$51,$17,$0E,$51,$0D,$16,$0D,$1A,$0F,$21,$51,$51,$51,$51,$51,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FE
  !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FE
  !byte $2E,$2B,$29,$2A,$36,$00,$24,$37,$2E,$24,$00,$31,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$85,$00,$FE
  !byte $25,$23,$25,$36,$37,$35,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$86,$FE
  !byte $24,$31,$36,$36,$2E,$27,$00,$31,$28,$00,$32,$31,$2B,$35,$31,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C4,$00,$FE
  !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E4,$FF

SCOTEXTH
  !byte $2A,$2B,$29,$2A,$00,$35,$25,$31,$34,$27,$FF
  
SCOTEXTL
  !byte $29,$23,$2F,$27,$00,$35,$25,$31,$34,$27,$FF

;*********************************

SELDEFF
  !byte 0,12,12,13,2
  !byte 4,12,12,13,6
  !byte 8,12,12,13,10

PLAYSELE
  !byte 12,12,12,12,12
  !byte 14,14,14,14,14
  !byte 15,16,17,18,19

SELBUFF
  !byte 0,0,0,0,0
  !byte 0,0,0,0,0
  !byte 0,0,0,0,0

TILENUM
  !byte 0

ENERGY
  !byte 127,127,127

BLOMLB
  !byte 0,64,128,192
  !byte 0,64,128,192
  !byte 0,64,128,192
  !byte 0,64,128,192
  !byte 0,64,128,192

BLOMHB    
  !byte BLDAVE+0,BLDAVE+0,BLDAVE+0,BLDAVE+0
  !byte BLDAVE+1,BLDAVE+1,BLDAVE+1,BLDAVE+1
  !byte BLDAVE+2,BLDAVE+2,BLDAVE+2,BLDAVE+2
  !byte BLDAVE+3,BLDAVE+3,BLDAVE+3,BLDAVE+3
  !byte BLDAVE+4,BLDAVE+4,BLDAVE+4,BLDAVE+4

SCRMLB
  !byte 0,8,16,24,32
  !byte 64,72,80,88,96
  !byte 128,136,144,152,160

SCRMHB
  !byte SHB+0,SHB+0,SHB+0,SHB+0,SHB+0
  !byte SHB+1,SHB+1,SHB+1,SHB+1,SHB+1
  !byte SHB+2,SHB+2,SHB+2,SHB+2,SHB+2

TCOUNT
  !byte 0
  
TEXTPOSLB !byte 93,157,221
TEXTPOSHB !byte SHB+0,SHB+1,SHB+2
DELDAVE !byte 0,0,0
TEXTSEED  !byte 0
PLAYCHAR  !byte 2,1,0
MINK    !byte 0
NEWLINE !byte 0
MODX    !byte 0
MODTILEL  !byte 0,5,10
MODTILER  !byte 4,9,14

JOYY    !byte 0
GERALZ1 !byte 3,7,11
GERALZ    !byte 1,5,9
DSCREEN !byte 1
PLAYERSEL !byte 0
PLNUMLB !byte >PLNUM,>PLNUM1,>PLNUM2
PLNUMHB !byte <PLNUM,<PLNUM1,<PLNUM2
MANYTEMP  !byte 0
CDEL    !byte 0
XXXXXX    !byte 0
TAKEN   !byte 0,0,0
PDEL    !byte 0,0

;YOU MUST FINISH SCORE DATA WITH $FF

HISCORE1  !byte ZERO,ZERO,ZERO,ZERO,ZERO,ZERO,$FF
HISCORE2  !byte ZERO,ZERO,ZERO,ZERO,ZERO,ZERO,$FF
HISCORE3  !byte ZERO,ZERO,ZERO,ZERO,ZERO,ZERO,$FF
SCOLB   !byte <SCORE1,<SCORE2,<SCORE3
SCOHB   !byte >SCORE1,>SCORE2,>SCORE3
HILB    !byte <HISCORE1,<HISCORE2,<HISCORE3
HIHB    !byte >HISCORE1,>HISCORE2,>HISCORE3
SCPOSL    !byte 15,25,36
SCPOSH    !byte SHB+2,SHB+2,SHB+2
HPOSL   !byte 149,161,173
HPOSH   !byte SHB+1,SHB+1,SHB+1
STEXTPOSL !byte 119
STEXTPOSH !byte SHB+1
HTEXTPOSL !byte 239
HTEXTPOSH !byte SHB+1
