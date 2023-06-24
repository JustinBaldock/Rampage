;CHECK CRUMBL
CHECKCRUMBLE  ; FALL +CRACK
  LDA HOWMANY
  STA BUILDPOINT
CHCR
  LDX BUILDPOINT
  LDA BUILDTALL,X
  BEQ BEND1        ; BUILD GONE !
  LDA SDAMAGE,X
  BEQ DROPIT      ; FALLING

@BEND  ; DO CRACKS HERE

@NODAMAGE
  DEC BUILDPOINT
  BPL CHCR
  RTS

DROPIT
  LDA CRACKING,X
  BEQ FALLIT
  DEC CRACKING,X
  JMP CDOWN
FALLIT
  LDA #AFALL
  CPX MONONB
  BNE NPLAY
  STA ACTION
NPLAY 
  CPX MONONB+1
  BNE NPLAY1
  STA ACTION+1
NPLAY1
  CPX MONONB+2
  BNE NPLAY2
  STA ACTION+2
NPLAY2      
  DEC BUILDTALL,X
CDOWN
  TXA
  JSR @CRACKUP 
  LDX #2
  JSR RAND
  CMP #200
  BCS NOSOD
  LDA #2
  LDX #1
  JSR SOUND
NOSOD LDA #1
  LDX #2
  JSR SOUND
  JMP @BEND    

BEND1 
  JMP @NODAMAGE
  
PUTDUSTON
  TAX
  LDA BUILDTYPE,X
  TAY
  LDA SBXEND,X
  SEC
       SBC SBXSTART,X
  STA COUNTDOWN
  LDA SBXSTART,X
  TAX
  LDA SCREENTEMP
  CLC
  ADC #3
  STA DUSMC+2
  

PUTDUST
  TXA
  EOR BANANA
  AND #15
  TAY
  LDA DUSTCHARS,Y

DUSMC STA $F400+(22*40),X
  ;STA $F800+(22*40),X
  INX
  DEC COUNTDOWN
  BPL PUTDUST
  LDA BANANA

  ADC #21
  STA BANANA

NODUST RTS
SCREENSETUP
  LDY #7
SETUP1  LDA #0
  STA SHIT,Y
  LDA #20
  STA SDAMAGE,Y
  DEY
  BPL SETUP1
  RTS
COUNTDOWN !byte 0
XSTORE    !byte 0
BANANA    !byte 0
DUSTCHARS !byte $D9,$DA,$DB,$DC,$DD,$DE
          !byte $DB,$D9,$DC,$DD,$DA,$D9,$DD,$DE
          !byte $D9,$D9,$D9,$D9,$D9,$D9

CRACKING  !fill 10,10

TEMPC !byte 0
TEMPR !byte 0

SDAMAGE !byte 50,50,50,50,50,50,50,50,50
  ;BUILDTALL
SHIT  !byte 0,0,0,0,0,0,0,0,0

SCREENDRAW
  ASL ;Implied A
  TAY
  LDA TYPOINT,Y
  STA SMCBT+1
  LDA TYPOINT+1,Y
  STA SMCBT+2

  LDA BXPOINT,Y
  STA SMCBX+21
  LDA BXPOINT+1,Y
  STA SMCBX+2
  RTS

JOYGETPLAY
AUTOPLAY


AUTOG TXA
    TAY
  
AUP LDX #0
  JSR RAND
  CMP #252
  BCS QJUMP
  CMP #200
  BCC KEEPGOING
       JSR RAND
  AND #15
  TAX
  AND #1
  STA LEFT,Y
  EOR #1
  STA RIGHT,Y
  JMP KEEPUP
AUTO1 LDA #1
  STA LEFT,Y
  LDA #0
  STA RIGHT,Y
KEEPUP
  TXA
  CMP #12
  BCS AUTO2
  LDA #1
  STA UP+2
  LDA #0
  STA DOWN,Y
  JMP KEEPGOING
AUTO2
  LDA #0
  STA UP+2
  LDA #1
  STA DOWN,Y
KEEPGOING


  LDX #3
  JSR RAND
  CMP #200
  LDA #0
  ADC #0
  STA FIRE,Y
  RTS

QJUMP
  LDA #0
  STA UP,Y
  STA LEFT,Y
  STA RIGHT,Y
  STA DOWN,Y
  LDA #1
  STA FIRE,Y
  RTS
