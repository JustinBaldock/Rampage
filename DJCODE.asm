HOLE      = COMMON+1
HOLEUP    = HOLE+2
HOLEDOWN  = HOLE+4
HOLESIDE  = HOLE+6
STEMP   !byte 0
WHTILE  !byte 0
FISTX   !byte 0
FISTY   !byte 0
PUNCHX    !byte 0
PUNCHY    !byte 0
XOFFSET !byte 30,-30
POYT1 !byte 6,2,3,2
POXT1 !byte 0,-2,-4,2
POXT2 !byte -1,2,4,-2
  
TESTER  !byte 0

TRY
  JSR PRINTOUT
  INC TESTER
  LDX TESTER
  LDA SDAMAGE,X
  BEQ TESTED
  ; DEC SDAMAGE,X
  
TESTED
  INC TESTER
  LDA TESTER
  AND #7
  STA TESTER
  LDX #0
  JSR TRY2
  LDX #1
  JSR TRY2
  LDX #2
TRY2
  STX PLAYER  
  LDA ACTION,X
  CMP #APUNCHC
  BEQ TRY3    
  RTS   
TRY3
  LDY HANDY,X
  LDA Y,X
  LSR ;Implied A
  LSR ;Implied A
  LSR ;Implied A
  SEC
  SBC POYT1,Y
  STA FISTY
  LDA X,X
  LSR ;Implied A   
  LSR ;Implied A 
  STA XTEMP
  LDA DIR,X
  BPL SBIT1
  LDA POXT2,Y
  JMP QBIT2
SBIT1
  LDA POXT1,Y
QBIT2
  CLC
  ADC XTEMP
  STA FISTX
  JSR GETCHAR
  STA CGET1
  INY
  LDA BUILD,Y
  STA CGET2
  TYA
  CLC
  ADC #39
  LDA BUILD,Y
  STA CGET3
  INY
  LDA BUILD,Y
  STA CGET4
  LDY #OBJECTEND-OBJECTSTART

EATLIS
  LDA OBJECTSTART,Y
  CMP CGET1
  BEQ EATIT
  CMP CGET2
  BEQ EATIT
  CMP CGET3
  BEQ EATIT
  CMP CGET4
  BEQ EATIT
  DEY
  BNE EATLIS
  JMP SMASHOLE
EATIT
  LDA #AEAT
  STA ACTION,X

SMASHOLE
    
PUNCHCHECK
  STX XSAFE 
  LDX HOWMANY
  INX
  STX BUILDCHECK
  LDX #0
  
GETBUILD
  LDA BUILDTALL,X 
  BEQ NEXTBUILD
  LDA SBXSTART,X
  CMP FISTX
  BCS NEXTBUILD
  LDA SBXEND,X
  CMP FISTX
  BCS GOTBUILD
NEXTBUILD
  INX
  CPX BUILDCHECK
  BNE GETBUILD
  CLC
  LDX XSAFE
  RTS

GOTBUILD  
  LDA #22
  SEC     
  SBC BUILDTALL,X
  BMI NEXTBUILD
  STA STEMP
  LDA FISTY
  SEC
  SBC STEMP

  STA FISTY
  LSR ;Implied A
  STA YHEIGHT      
    
CALCTILE  
    LDA BUILDMAPHB,X
  
    STA HOLE+1
    STA HOLEUP+1
    STA HOLEDOWN+1
    STA HOLESIDE+1
    LDA BUILDMAPLB,X
    STA HOLE  ; !!!
    STA HOLESIDE  
    CLC
    ADC BUILDWIDE,X
    STA HOLEDOWN
    
    LDA HOLE
    SEC
    SBC BUILDWIDE,X
    
    STA HOLEDOWN
    LDA FISTX
    CMP SBXSTART,X
      
    LDA FISTX
    SEC
    SBC SBXSTART,X
    LSR ;Implied A
  
    STA PUNCHX
    BNE NLEFT
    INC HOLESIDE          
NLEFT
  CMP BUILDWIDE,X
  BNE DEMOQ   
  DEC HOLESIDE

DEMOQ      
  LDA YHEIGHT
  TAY
  BEQ ONTOPL
  LDA #0
  CLC

OFF1 
  ADC BUILDWIDE,X
  DEY
  BNE OFF1
ONTOPL
  CLC
  ADC PUNCHX
  TAY
  STY DAVE1
  STX TEMPX
      
FINE      
  LDA HOLE,Y
  TAX
  JSR PRINTOUT1
  LDA BLOCKVALID,X
  CMP #255
  BEQ SMASHED   
  LDA BLOCKVALID,X
  BPL HOLEPUT1
  AND #7
  CLC   
CHEAT
  ADC #$54
  STA HOLE,Y      
  JMP POINTS    

HOLEPUT1
  STA STACK 
  LDA HOLEUP,Y
  CMP #24
  BCS NOUP
  ORA #2
  STA HOLEUP,Y    
  LDA STACK
  ORA #1
  STA STACK
    
NOUP
  LDA HOLEDOWN,Y  
  CMP #24
  BCS NODOWN
  ORA #1
  STA HOLEDOWN,Y    
  LDA STACK
  ORA #2
  STA STACK
  
NODOWN      
  
NOK2
; LDA (HOLESIDE),Y    
;   TAX         
;   LDA BLOCKVALID,X
;   AND #240
;   CMP #128      
;   BNE NOSIDE    
;   LDA STACK       
;   ORA #4      
;   JMP NOSIDE1

NOSIDE
  LDA STACK
  
NOSIDE1   
    STA HOLE,Y    
    
POINTS  
    LDX TEMPX
    LDA SDAMAGE,X
    BEQ SMASHED
    DEC SDAMAGE,X 
    LDX PLAYER
    JSR SCINC
    LDA #0
    LDX #0
    JSR SOUND

SMASHED
  RTS 

UPDATE      !byte 0

PRINTOUT1
  STA UPDATE
PRINTOUT
  RTS
  LDA UPDATE
  AND #15   
  CLC
  ADC #ZERO     
  STA $F401   
  STA $F801
  LDA UPDATE  
  LSR ;Implied A
  LSR ;Implied A
  LSR ;Implied A
  LSR ;Implied A
  ADC #ZERO
  STA $F400
  STA $F800
  RTS 


  
TEMPX   !byte 0
YHEIGHT !byte 0
BUILDCHECK  !byte 0
XSAFE     !byte 0
BLOCKMID    !byte $55,$56,$57,$58
SIDEFLAG  !byte 0
BTCHARS !byte 0
STACK   !byte 0
BLOCKVALID
  !byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  !byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  
  !byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  !byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  !byte $87,$FF,$FF,$88,$87,$FF,$FF,$88
  !byte $89,$FF,$FF,$8A,$10,$83,$84,$18
  !byte $10,$83,$84,$18,$00,$81,$82,$08
  !byte $FF,$81,$82,$00,$10,$FF,$FF,$18
  !byte $FF,$FF,$FF,$FF,$83,$FF,$18,$10
  !byte $00,$FF,$82,$08,$81,$08,$FF,$82
  !byte $18,$89,$8A,$FF,$FF,$FF,$FF,$FF
  !byte $FF,$83,$84,$FF,$FF,$FF,$FF,$81
  !byte $FF,$FF,$00,$81,$FF,$FF,$FF,$FF
  !byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  !byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  !byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

;$00  =  LGREY  LEFT HAND
;$81  =  LGREY  LEFT MIDDLE
;$82  =  LGREY  RIGHT MIDDLE
;$08  =  LGREY  RIGHT HAND
;$10  =  DGREY  LEFT HAND
;$83  =  DGREY  LEFT MIDDLE
;$84  =  DGREY  RIGHT MIDDLE
;$18  =  DGREY  RIGHT HAND
PLAYER  !byte 0
CADD  = 4


CGET1   !byte 0
CGET2   !byte 0
CGET3   !byte 0
CGET4   !byte 0
