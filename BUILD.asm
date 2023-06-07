*=$0801 
            byte    $0c,$08,$01,$00,$9e,$34,$30,$39,$36,$00,$00,$00,$00,$00  ; 1 sys 4096       ;basic loader

;MUSIC          EQU &200  ;to &B00
DTILES          = $7000  ;to &7500
BACKDROP        = $B00 ;to 1300
COLMEM          = $1300
COLMEM1         = $1400
BLSTART         = $3C10 ;to 4000      ; BLOCK
SMDJ            = $75   ; +&76


CODE            = $7800



BW              = 79
ZERO            = 64
TEMPCOL         = $F400
TEMPCOL1        = $F800
BACKWIDE        = 80
BACKTALL        = 12
SCREENTEMP      = $F8
SCEOR           = %00001100
                ; EOR WITH %xxxx1100
                ; SCR1 F400 %1101xxxx
                ; EOR WITH  %0011xxxx
                ; SCR2 F800 %1110xxxx
SCREENCHSET     DB %11010000   ; TO &F0
CHEOR           = %00110000

NEXTLEVEL       DB 72,70,72,72,70,72
CRACKX          DB 0,0,0,0,0,0,0,0,0,0
BUILDWIDTH      DB 4,5,4,4,5,4
BUILDWIDTH1     DB 8,10,8,8,10,8
BUILDHEIGHT     DB 8,14,10,6,10,12
DREQUIRED       DB 10,12,8,4,10,9
SBTOPTAB        DB O-80,O-128,O-96      
                DB O-72,O-120,O-120

BACKPOINT       DB 60
WATERTABLE      DB 39,47,55,00
WATERPOINT      DB 0
SCREEN          DB 0
BUILDSTARTLB
        DB 72,32
        DB 248,208,168,128,88,48,8
        DB 224,184,144,104,64,24
        DB 240,200,160,120,80,40,0

BUILDSTARTHB
        DB 3,3
        DB 2,2,2,2,2,2,2
        DB 1,1,1,1,1,1
        DB 0,0,0,0,0,0,0

PATTERNHB       DB <BUILDING1,<BUILDING2,<BUILDING3,<BUILDING4,<BUILDING5,<BUILDING6
PATTERNLB       DB >BUILDING1,>BUILDING2,>BUILDING3,>BUILDING4,>BUILDING5,>BUILDING6

BUILDMAPLB
        DB 0,64,128,192,0,64,128,192
BUILDMAPHB
        DB SMDJ,SMDJ,SMDJ,SMDJ  
        DB SMDJ+1,SMDJ+1

SCBACKPOINT     DB 40,50,79,70,45,60,55
        DB 70,66,42,50,61,53,56,47,74,42        
STATUS  DB 0
NODEM  LDA #0
        STA STEMP
        LDY RILY
NODEM2 LDX STEMP
        LDA PLAYCHAR,X
        ASL A
        ASL A
        ASL A
        TAY
        LDX #0
NODEM1  LDA GEORGETEXT,X
        STA P1TEXT,Y    
        INY             
        INX
        CPX #8
        BNE NODEM1
        INC STEMP
       LDA STEMP
        CMP #3
        BNE NODEM2
        

        LDX #2
RESED   LDA ENERGY,X
        BEQ COMPUTER
        BMI COMPUTER
        CMP #127
        BEQ COMPUTER    
        LDA #0
        STA CHUMAN,X
        JMP NCOMP1
COMPUTER
        LDA #&FF
        STA CHUMAN,X
NCOMP1  
       DEX
        BPL RESED
        LDA #0
        TAY
INIB1   STA BULLETWIPE,Y
        STA OBJECTWIPE,Y
        DEY             
        BNE INIB1

        LDA PLAYCHAR
        STA PLAYCHAR1
        LDA PLAYCHAR+1
        STA PLAYCHAR1+2
        LDA PLAYCHAR+2
        STA PLAYCHAR1+1

        LDA #%11011000
        STA &D018       
        LDA #0
        STA &D021
        LDX #0
        JSR RAND
        AND #15
        STA &D022
        JSR RAND
        AND #15
        STA &D023



        LDA SCREEN
        CMP #18
        BNE INI1


        LDA #255
        STA SCREEN
INI1    INC SCREEN
        LDA SCREEN
        ASL A
        TAY
        LDA TYPOINT,Y
        STA SMCBT+1
        LDA TYPOINT+1,Y
        STA SMCBT+2
        LDA BXPOINT,Y
        STA SMCBX+1
        LDA BXPOINT+1,Y
        STA SMCBX+2
        LDA VICCR2
        ORA #16
        STA VICCR2
        JSR SETUPBUILDINGS
        JSR COPYSETS
        JSR SIDWIPE
        JSR SCREENWIPE
        RTS     
FOUND   INC &D020
        JMP FOUND
DRAWBUILD
        LDA FIRE+2
        BEQ NONK        
        LDA #AEAT
        STA ACTION

NONK
        ;LDX #1
        ;JSR LOSENERGY
        JSR TRY
        JSR BACKDROPDRAW
        JSR PUTBUILD
        JSR DSCORE
        JSR BEFORECOLOUR        
        JSR CHECKCRUMBLE
        JSR FLIPSCREEN
        JSR AFTERCOLOUR 

        JMP CHSCREENDONE

NEWSCREEN
        JSR DRIVER      ;INTER CITY
        JMP MAIN

CHSCREENDONE
        INC CBYTE
        LDA CBYTE
        AND #15 ; 31
        BEQ CHSC2
        RTS

CHSC2   LDY HOWMANY
CHSC1   LDA BUILDTALL,Y
        BNE STILLUP
        DEY
        BPL CHSC1
        JSR DRIVER      ;INTERCITYREPORT
        JMP MAIN
STILLUP RTS

FLIPSCREEN
        
        LDA SCREENTEMP
        EOR #SCEOR
        STA SCREENTEMP
        LDA SCREENCHSET ; FROM &F000
        EOR #CHEOR      ; TO   &E000
        STA SCREENCHSET
        LDA VICMCR
        AND #%00001111
        ORA SCREENCHSET
        STA VICMCR
        LDA SCREENTEMP
        CMP #&F8
        BEQ COPYCOL1
        JMP COPYCOL2

COPYCOL1
        LDY #39
COPYCOL
        LDX TEMPCOL+(24*40),Y
        LDA COLMEM,X
        STA NYBBLE+(24*40),Y
        LDX TEMPCOL+(23*40),Y
        LDA COLMEM,X
        STA NYBBLE+(23*40),Y
        LDX TEMPCOL+(22*40),Y
        LDA COLMEM,X
        STA NYBBLE+(22*40),Y

        LDX TEMPCOL+(21*40),Y
        LDA COLMEM,X
        STA NYBBLE+(21*40),Y
        LDX TEMPCOL+(20*40),Y
        LDA COLMEM,X
        STA NYBBLE+(20*40),Y
        LDX TEMPCOL+(19*40),Y
        LDA COLMEM,X
        STA NYBBLE+(19*40),Y
        LDX TEMPCOL+(18*40),Y
        LDA COLMEM,X
        STA NYBBLE+(18*40),Y
        LDX TEMPCOL+(17*40),Y
        LDA COLMEM,X
        STA NYBBLE+(17*40),Y
        LDX TEMPCOL+(16*40),Y
        LDA COLMEM,X
        STA NYBBLE+(16*40),Y
        LDX TEMPCOL+(15*40),Y
        LDA COLMEM,X
        STA NYBBLE+(15*40),Y
        LDX TEMPCOL+(14*40),Y
        LDA COLMEM,X
        STA NYBBLE+(14*40),Y
        LDX TEMPCOL+(13*40),Y
        LDA COLMEM,X
        STA NYBBLE+(13*40),Y
        LDX TEMPCOL+(12*40),Y
        LDA COLMEM,X
        STA NYBBLE+(12*40),Y
        LDX TEMPCOL+(11*40),Y
        LDA COLMEM,X
        STA NYBBLE+(11*40),Y
        LDX TEMPCOL+(10*40),Y
        LDA COLMEM,X            
        STA NYBBLE+(10*40),Y
        LDX TEMPCOL+(09*40),Y
        LDA COLMEM,X
        STA NYBBLE+(09*40),Y
        LDX TEMPCOL+(08*40),Y
        LDA COLMEM,X
        STA NYBBLE+(08*40),Y
        LDX TEMPCOL+(07*40),Y
        LDA COLMEM,X
        STA NYBBLE+(07*40),Y
        LDX TEMPCOL+(06*40),Y
        LDA COLMEM,X
        STA NYBBLE+(06*40),Y
        LDX TEMPCOL+(05*40),Y
        LDA COLMEM,X
        STA NYBBLE+(05*40),Y
        LDX TEMPCOL+(4*40),Y
        LDA COLMEM,X
        STA NYBBLE+(4*40),Y
        DEY
        BMI COPOUT1
        JMP COPYCOL
COPOUT1 RTS



COPYCOL2
        LDY #39
COPYCOLR2
       LDX TEMPCOL1+(24*40),Y
        LDA COLMEM,X
        STA NYBBLE+(24*40),Y
        LDX TEMPCOL1+(23*40),Y
        LDA COLMEM,X
        STA NYBBLE+(23*40),Y
        LDX TEMPCOL1+(22*40),Y
        LDA COLMEM,X
        STA NYBBLE+(22*40),Y
        LDX TEMPCOL+(21*40),Y
        LDA COLMEM,X
        STA NYBBLE+(21*40),Y
        LDX TEMPCOL1+(20*40),Y
        LDA COLMEM,X
        STA NYBBLE+(20*40),Y
        LDX TEMPCOL1+(19*40),Y
        LDA COLMEM,X
        STA NYBBLE+(19*40),Y
        LDX TEMPCOL1+(18*40),Y
        LDA COLMEM,X
        STA NYBBLE+(18*40),Y
        LDX TEMPCOL1+(17*40),Y
        LDA COLMEM,X
        STA NYBBLE+(17*40),Y
        LDX TEMPCOL1+(16*40),Y
        LDA COLMEM,X
        STA NYBBLE+(16*40),Y
        LDX TEMPCOL1+(15*40),Y
        LDA COLMEM,X
        STA NYBBLE+(15*40),Y
        LDX TEMPCOL1+(14*40),Y
        LDA COLMEM,X
        STA NYBBLE+(14*40),Y
        LDX TEMPCOL1+(13*40),Y
        LDA COLMEM,X
        STA NYBBLE+(13*40),Y
        LDX TEMPCOL1+(12*40),Y
        LDA COLMEM,X
        STA NYBBLE+(12*40),Y
        LDX TEMPCOL1+(11*40),Y
        LDA COLMEM,X
        STA NYBBLE+(11*40),Y
        LDX TEMPCOL1+(10*40),Y
        LDA COLMEM,X            
        STA NYBBLE+(10*40),Y
        LDX TEMPCOL1+(09*40),Y
        LDA COLMEM,X
        STA NYBBLE+(09*40),Y
        LDX TEMPCOL1+(08*40),Y
        LDA COLMEM,X
        STA NYBBLE+(08*40),Y
        LDX TEMPCOL1+(07*40),Y
        LDA COLMEM,X
        STA NYBBLE+(07*40),Y
        LDX TEMPCOL1+(06*40),Y
        LDA COLMEM,X
        STA NYBBLE+(06*40),Y
        LDX TEMPCOL1+(05*40),Y
        LDA COLMEM,X
        STA NYBBLE+(05*40),Y
        LDX TEMPCOL1+(04*40),Y
        LDA COLMEM,X
        STA NYBBLE+(04*40),Y
        DEY
        BMI COPYCOLR3
        JMP COPYCOLR2
COPYCOLR3       RTS
CRACKUP
BUILDCRACK
        TAX
        PHA
BCRAK   LDA BUILDMAPLB,X
        STA CRACK+1
        STA CRACK1+1
        LDA BUILDMAPHB,X
        STA CRACK+2
        STA CRACK1+2
        LDA CRACKX,X
        BEQ CRACKEDUP1
        LDY BUILDWIDE,X
        TAX
CRACK   LDA &FFFF,X
        CMP #&64
        BCS CRACK2
        ;CLC    
        ;AND #32
        ADC #&64
CRACK1  STA &FFFF,X
CRACK2  DEX
        BMI CRACKEDUP1
        DEY
        BNE CRACK
        PLA
        TAY
        TXA
        STA CRACKX,Y
        BMI CRACKEDUP2
        RTS

CRACKEDUP1
        PLA
        TAX
        LDA #0
        STA CRACKX,X
CRACKEDUP
        

CRACKEDUP2
        LDA #0
        STA CRACKX,Y
        RTS


SETUPBUILDINGS
        LDY #0
BUILDSET        LDX #0
SMCBT   LDA &FFFF,Y
        STA IMTIRED
        BMI ALLBUILDS
        LDA #0
        STA SHIT,Y
        LDA #6
        STA SDAMAGE,Y
        LDA #63
        STA CRACKX,Y
        LDA #15
        STA CRACKING,Y
SMCBX   LDA &FFFF,Y   ;SMODIFIDED
        LDX IMTIRED
        STA SBXSTART,Y
        STA BUILDDUST,Y
        CLC
        ADC BUILDWIDTH1,X
        SEC
        SBC #1
        STA SBXEND,Y
        LDA SBTOPTAB,X
        STA SBTOP,Y
        LDA DREQUIRED,X
        STA SDAMAGE,Y
        LDA IMTIRED
        TAX
        STA BUILDTYPE,Y
        LDA BUILDWIDTH,X
        STA BUILDWIDE,Y
        LDA BUILDHEIGHT,X
        STA BUILDTALL,Y
        LDA BUILDWIDTH1,X
        STA BUILDWIDE1,Y
        LDA PATTERNLB,X
        STA GETPAT+1
        LDA PATTERNHB,X
        STA GETPAT+2
        LDA BUILDMAPLB,Y
        STA PUTPAT+1
        LDA BUILDMAPHB,Y
        STA PUTPAT+2
        LDX #63
GETPAT  LDA &FFFF,X
PUTPAT  STA &FFFF,X
        DEX
        BPL GETPAT
        INY
        CPY #7
        BNE BUILDSET
ALLBUILDS       
        DEY
        STY HOWMANY
ALLB1   LDA #0
        STA SBTOP+1,Y
        STA SBXEND+1,Y
        STA SBXSTART+1,Y
        STA SHIT+1,Y
        STA SDAMAGE+1,Y
        STA BUILDTALL+1,Y
        STA CRACKING+1,Y
        LDA #63
        STA CRACKX+1,Y
        INY
        CPY #6
        BNE ALLB1
        RTS

PUTBUILD
        LDY HOWMANY
BUILDV  LDA BUILDTALL,Y
        BNE NOBUIL1
        JMP NOBUIL
NOBUIL1 STA BUILDY
        LDA BUILDMAPLB,Y
        STA BLPOINT+1
        LDA BUILDMAPHB,Y
        STA BLPOINT+2
        LDX BUILDTALL,Y
        LDA BUILDSTARTLB,X
        CLC
        ADC BUILDDUST,Y
        STA SCRPOINT+1
        LDA BUILDSTARTHB,X
        ADC SCREENTEMP
        STA SCRPOINT+2
BUILDH  LDA BUILDWIDE,Y
        STA BUILDX
BLPOINT LDA &FFFF
        STA DEFPOINT+1
        LDA #0          ;<(BLSTART/4)
        ASL DEFPOINT+1
        ROL A
        ASL DEFPOINT+1
        ROL A
        STA DEFPOINT+2
        LDA DEFPOINT+1
        CLC
        ADC #>BLSTART
        STA DEFPOINT+1
        LDA DEFPOINT+2
        ADC #<BLSTART
        STA DEFPOINT+2
PUTLEVEL
        JSR TILEPUT
        LDA SCRPOINT+1
        SEC
        SBC #78
        STA SCRPOINT+1
        LDA SCRPOINT+2
        SBC #0
        STA SCRPOINT+2
        INC BLPOINT+1
        BNE SPEED4
        INC BLPOINT+2
SPEED4  DEC BUILDX
        BNE BLPOINT
        LDX BUILDTYPE,Y
        LDA NEXTLEVEL,X
        CLC
        ADC SCRPOINT+1
        STA SCRPOINT+1
        ;STA DEBUG+2
        BCC SPEED5
        INC SCRPOINT+2
SPEED5  DEC BUILDY
        LDA SCRPOINT+2
        ;STA DEBUG+1
        DEC BUILDY
        BPL BUILDH
        TYA
        STA KEEP
        LDA SDAMAGE,Y
        BNE NOBUIL
        LDA KEEP
        JSR PUTDUSTON
        LDY KEEP
NOBUIL  DEY
        BMI PUTBEXIT
        JMP BUILDV
PUTBEXIT        RTS

TILEPUT LDA #1
        STA COUNT2
TLOOP   LDX #1
DEFPOINT        LDA &FFFF,X
SCRPOINT        STA &FFFF,X
        DEX
        BPL DEFPOINT
        LDA DEFPOINT+1
        CLC
        ADC #2
        STA DEFPOINT+1
        BCC SPEED2
        INC DEFPOINT+2
SPEED2  CLC
        LDA SCRPOINT+1
        ADC #40
        STA SCRPOINT+1
        BCC SPEED1
        INC SCRPOINT+2
SPEED1  DEC COUNT2
        BPL TLOOP
        RTS
DMOUNTSJ        JMP DMOUNTS
BACKDROPDRAW
        LDA SCREEN
        AND #15
        TAY
        LDA SCBACKPOINT,Y
        TAY
        
        LDA SCREEN
        AND #4
        BEQ DMOUNTSJ
        LDX SCREENTEMP
        CPX #&F4
        BEQ BACKD1
        JMP BACKD2

BACKD1  LDX #39
COPYLOOP
        LDA BACKDROP+(BW*00),Y
        STA &F400+(40*00),X
        LDA BACKDROP+(BW*01),Y
        STA &F400+(40*01),X
        LDA BACKDROP+(BW*02),Y
        STA &F400+(40*02),X
        LDA BACKDROP+(BW*03),Y
        STA &F400+(40*03),X
        LDA BACKDROP+(BW*04),Y
        STA &F400+(40*04),X
        LDA BACKDROP+(BW*05),Y
        STA &F400+(40*05),X
        LDA BACKDROP+(BW*06),Y
        STA &F400+(40*06),X
        LDA BACKDROP+(BW*07),Y
        STA &F400+(40*07),X
        LDA BACKDROP+(BW*08),Y
        STA &F400+(40*08),X
        LDA BACKDROP+(BW*09),Y
        STA &F400+(40*09),X
        LDA BACKDROP+(BW*10),Y
        STA &F400+(40*10),X
        LDA BACKDROP+(BW*11),Y
        STA &F400+(40*11),X
        LDA BACKDROP+(BW*12),Y
        STA &F400+(40*12),X
        LDA #0
        STA &F400+(40*13),X
        STA &F400+(40*14),X
        STA &F400+(40*15),X
        STA &F400+(40*16),X
        STA &F400+(40*17),X
        STA &F400+(40*18),X
        STA &F400+(40*19),X
        LDA BACKDROP+(BW*20),Y
        STA &F400+(40*20),X
        LDA BACKDROP+(BW*21),Y
        STA &F400+(40*21),X
        LDA BACKDROP+(BW*22),Y
        STA &F400+(40*22),X
        LDA BACKDROP+(BW*23),X
        STA &F400+(40*23),X
        LDA BACKDROP+(BW*24),X
        STA &F400+(40*24),X
        DEY
        DEX
        BMI COPYED
        JMP COPYLOOP
COPYED  RTS

BACKD2  LDX #39
COPYLOOP1
        LDA BACKDROP+(BW*00),Y
        STA &F800+(40*00),X
        LDA BACKDROP+(BW*01),Y
        STA &F800+(40*01),X
        LDA BACKDROP+(BW*02),Y
        STA &F800+(40*02),X
        LDA BACKDROP+(BW*03),Y
        STA &F800+(40*03),X
        LDA BACKDROP+(BW*04),Y
        STA &F800+(40*04),X
        LDA BACKDROP+(BW*05),Y
        STA &F800+(40*05),X
        LDA BACKDROP+(BW*06),Y
        STA &F800+(40*06),X
        LDA BACKDROP+(BW*07),Y
        STA &F800+(40*07),X
        LDA BACKDROP+(BW*08),Y
        STA &F800+(40*08),X
        LDA BACKDROP+(BW*09),Y
        STA &F800+(40*09),X
        LDA BACKDROP+(BW*10),Y
        STA &F800+(40*10),X
        LDA BACKDROP+(BW*11),Y
        STA &F800+(40*11),X
        LDA BACKDROP+(BW*12),Y
        STA &F800+(40*12),X
        LDA BACKDROP+(BW*13),Y
        LDA #0
        STA &F800+(40*13),X
        STA &F800+(40*14),X
        STA &F800+(40*15),X
        STA &F800+(40*16),X
        STA &F800+(40*17),X
        STA &F800+(40*18),X
        STA &F800+(40*19),X
        LDA BACKDROP+(BW*20),Y
        STA &F800+(40*20),X
        LDA BACKDROP+(BW*21),Y
        STA &F800+(40*21),X
        LDA BACKDROP+(BW*22),Y
        STA &F800+(40*22),X
        LDA BACKDROP+(BW*23),X
        STA &F800+(40*23),X
        LDA BACKDROP+(BW*24),X
        STA &F800+(40*24),X
        DEY
        DEX
        BMI COPYED1
        JMP COPYLOOP1
COPYED1 RTS
MOUNT EQU BACKDROP+(BW*13)
DMOUNTS
        LDA SCREENTEMP
        CMP #&F8
        BEQ DMOUNTS1


      LDX #39

MOUNT1  LDA MOUNT+(BW*0),Y
        STA &F400+(40*3),X
        LDA MOUNT+(BW*1),Y
        STA &F400+(40*4),X
        LDA MOUNT+(BW*2),Y
        STA &F400+(40*5),X
        LDA MOUNT+(BW*3),Y
        STA &F400+(40*6),X
        LDA MOUNT+(BW*4),Y
        STA &F400+(40*7),X
        LDA MOUNT+(BW*5),Y
        STA &F400+(40*8),X
        LDA #1
        STA &F400+(40*0),X
        STA &F400+(40*1),X
        STA &F400+(40*2),X
        LDA #0
        STA &F400+(40*09),X
        STA &F400+(40*10),X
        STA &F400+(40*11),X
        STA &F400+(40*11),X
        STA &F400+(40*12),X
        STA &F400+(40*13),X
        STA &F400+(40*14),X
        STA &F400+(40*15),X
        STA &F400+(40*16),X
        STA &F400+(40*17),X
        ;LDA BACKDROP+(BW*18),Y
        STA &F400+(40*18),X
        LDA BACKDROP+(BW*19),Y
        STA &F400+(40*19),X
        LDA BACKDROP+(BW*20),Y
        STA &F400+(40*20),X
        LDA BACKDROP+(BW*21),Y
        STA &F400+(40*21),X
        LDA BACKDROP+(BW*22),Y
        STA &F400+(40*22),X
        LDA BACKDROP+(BW*23),X
        STA &F400+(40*23),X
        LDA BACKDROP+(BW*24),X
        STA &F400+(40*24),X
        DEY
        DEX
        BPL MOUNT1      
        RTS                             

DMOUNTS1

      LDX #39
        
MOUNT2  LDA MOUNT+(BW*00),Y     
        STA &F800+(40*03),X
        LDA MOUNT+(BW*01),Y     
        STA &F800+(40*04),X
        LDA MOUNT+(BW*02),Y
        STA &F800+(40*05),X
        LDA MOUNT+(BW*03),Y
        STA &F800+(40*06),X
        LDA MOUNT+(BW*04),Y
        STA &F800+(40*07),X
        LDA MOUNT+(BW*05),Y
        STA &F800+(40*08),X
        LDA #1
        STA &F800+(40*0),X
        STA &F800+(40*1),X
        STA &F800+(40*2),X
        LDA #0
        STA &F800+(40*09),X
        STA &F800+(40*10),X
        STA &F800+(40*11),X
        STA &F800+(40*12),X
        STA &F800+(40*13),X
        STA &F800+(40*14),X
        STA &F800+(40*15),X
        STA &F800+(40*16),X
        STA &F800+(40*17),X
        ;LDA BACKDROP+(BW*18),Y
        STA &F800+(40*18),X
        LDA BACKDROP+(BW*19),Y
        STA &F800+(40*19),X
        LDA BACKDROP+(BW*20),Y
        STA &F800+(40*20),X
        LDA BACKDROP+(BW*21),Y
        STA &F800+(40*21),X
        LDA BACKDROP+(BW*22),Y
        STA &F800+(40*22),X
        LDA BACKDROP+(BW*23),X
        STA &F800+(40*23),X
        LDA BACKDROP+(BW*24),X
        STA &F800+(40*24),X
        DEY
        DEX     
        BPL MOUNT2
        RTS












DRAWWATER
        LDY WATERPOINT
        BMI NODRAW
        ;JSR WATERPROCES



        LDA WATERTABLE,Y
        TAY
        LDX #0
DW1     LDA BACKDROP+(BW*24),Y
        STA &F400+(40*24)+10,X
        STA &F800+(40*24)+10,X
        LDA BACKDROP+(BW*23),Y
        STA &F400+(40*23)+10,X
        STA &F800+(40*23)+10,X
        INY
        INX
        CPX #8
        BNE DW1         
NODRAW  RTS

SCINC   ; CALL X= PLAYER
        
        TXA     
        ASL A
        ASL A
        ASL A
        TAX
        LDY #ZERO

        INC SCORES+3,X
        LDA SCORES+3,X
        CMP #10+ZERO    
        BEQ SCINC1
        RTS

SCINC1  TYA     
        STA SCORES+3,X
        INC SCORES+2,X
        LDA SCORES+2,X
        CMP #10+ZERO
        BEQ SCINC2
        RTS

SCINC2  TYA     
        STA SCORES+2,X
        INC SCORES+1,X
        LDA SCORES+1,X
        CMP #10+ZERO    
        BEQ SCINC3
        RTS

SCINC3  TYA     
        STA SCORES+1,X
        INC SCORES,X
        RTS

RAND    LDA SEED,X
        ASL A
        ASL A
        CLC
        ADC SEED,X
        CLC
        ADC #21
        STA SEED,X
        RTS

DSCORE  LDY #5
BARS    LDA SCORE1+0,Y
        STA &F400+3+40,Y
        STA &F800+3+40,Y
        LDA SCORE2,Y
        STA &F400+18+40,Y
        STA &F800+18+40,Y
        LDA SCORE3,Y
        STA &F400+32+40,Y
        STA &F800+32+40,Y
        LDA DAMAGETEXT,Y
        STA &F400+3+80,Y
        STA &F800+3+80,Y
        STA &F400+18+80,Y
        STA &F800+18+80,Y
        STA &F400+32+80,Y
        STA &F800+32+80,Y
        LDA P1TEXT,Y
        STA &F400+3,Y
        STA &F800+3,Y
        LDA P2TEXT,Y
        STA &F400+18,Y
        STA &F800+18,Y
        LDA P3TEXT,Y
        STA &F400+32,Y
        STA &F800+32,Y

        LDA #6
        STA &D800+3,Y
        STA &D800+18,Y
        STA &D800+32,Y

        LDA DAMAGE1,Y

        STA &D800+80+3,Y
        LDA DAMAGE2,Y
        STA &D800+80+18,Y
        LDA DAMAGE3,Y
        STA &D800+80+32,Y
        LDA #5
        STA &D800+40+32,Y
        LDA #2
        STA &D800+40+3,Y
        LDA #3                  
        STA &D800+40+18,Y
        DEY
        BPL BARS
        RTS

OPENWINDOWS
        INC WINDOWSCAN
        LDA WINDOWSCAN
        AND #7
        TAY
        STA WINDOWSCAN
        
        LDA BUILDMAPLB,Y
        STA BUILD
        LDA BUILDMAPHB,Y
        STA BUILD+1     
        ;LDX #5
        LDA SYNC
        EOR CIA2+4
        AND #63 
        TAY
OPSMC   LDA (BUILD),Y
        LDX #&59
        CMP #&2D
        BEQ ITSAWINDOW
        INX
        CMP #&2E
        BEQ ITSAWINDOW
        LDX #&39
        CMP #&35
        BEQ ITSAWINDOW
        INX
        CMP #&36
        BEQ ITSAWINDOW
        SEC
        RTS             
        
ITSAWINDOW
        TXA
        STA (BUILD),Y
        CLC
        RTS

BUILDING1
        DB &20,&21,&22,&23
        DB &34,&35,&36,&37
        DB &34,&35,&36,&37
        DB &34,&35,&36,&37
        DB &48,&49,&4A,&4B

BUILDING2
        HEX "6021382261"
        ;HEX "2021222223"
        HEX "34354C3637"
        HEX "34354C3637"
        HEX "34354C3637"
        HEX "34354C3637"
        HEX "34354C3637"
        HEX "34354C3637"
        HEX "62635F4E4D"

BUILDING3

        DB &24,&25,&26,&27
        DB &34,&35,&36,&37
        DB &34,&35,&36,&37
        DB &34,&35,&36,&37
        DB &34,&35,&36,&37
        DB &62,&63,&4A,&4B

BUILDING4
        HEX "28292A2B"
        HEX "2C2D2E2F"
        HEX "2C2D2E2F"
        HEX "30313E3F"

BUILDING5
        HEX "2829402A2B"
        HEX "2C2D422E2F"
        HEX "2C2D422E2F"
        HEX "2C2D422E2F"
        HEX "2C44433233"
        HEX "3041314546"

BUILDING6
        HEX "51545352"
        HEX "472D2E50"
        HEX "472D2E50"
        HEX "472D2E50"
        HEX "472D2E50"
        HEX "472D2E50"
        HEX "3C3D3233"

AS      EQU 34
AS1     EQU 8
DAMAGETEXT
        DB AS1+4,AS1+1,AS1+13,AS1+1,AS1+7,AS1+5,1
GEORGETEXT
        DB AS1+7,AS1+5,AS1+15,AS1+18,AS1+7,AS1+5
RALPHTEXT
        DB AS1+18,AS1+1,AS1+12,AS1+16,AS1+8,1
LIZZYTEXT
        DB AS1+12,AS1+9,AS1+26,AS1+26,AS1+25,1


        DB AS1+18,AS1+8,AS1+15,AS1+14,AS1+1,1,1,1
        DB AS1+9,1,AS1+12,AS1+15,AS1+22,AS1+5,1,1
        DB AS1+25,AS1+15,AS1+21,1,1,1

RILY    DB 0


P1TEXT  DS 8
P2TEXT  DS 8
P3TEXT DS 8


DAMAGE1
        DB 3,3,3,3,3,3,3,3
DAMAGE2
        DB 1,1,1,1,1,1,1,1
DAMAGE3
        DB 2,2,2,2,2,2,2,2
        DS 10
SCORES
SCORE1 DB ZERO,ZERO,ZERO,ZERO,ZERO,ZERO,&FF,&FF,&FF
SCORE2 DB ZERO,ZERO,ZERO,ZERO,ZERO,ZERO,&FF,&FF,&FF
SCORE3 DB ZERO,ZERO,ZERO,ZERO,ZERO,ZERO,&FF,&FF,&FF
ENH     DS 3,64
LOSPEED DS 0,0,0
LOSENERGY
        

        INC LOSPEED,X
        LDA LOSPEED,X
        AND #7
        BEQ LOSOME
LOSOME  LDA ENH,X
        BEQ LDEAD
        DEC ENH,X
        LDA ENH,X
        BEQ LDEAD       
        JMP SETUPEN
       RTS
GAINENERGY
        
        
        CLC
        ADC ENH,X
        BCS GAOV
        STA ENH,X
        JMP SETUPEN
GAOV    RTS
LDEAD  LDA ACTION,X     
        CMP #ATRANS
        BEQ ALRED
        CMP #ADIE
        BEQ ALRED
        LDA Y,X
        CMP #189+7
        
        BCS GOTRAN
        LDA #AFALL
        STA ACTION,X
        RTS
GOTRAN  LDA #0
        STA COUNT,X
        LDA #ATRANS
        STA ACTION,X

ALRED   RTS

        
SETUPEN

        LDY #23
        LDA #2          ;RED
WQOUT   STA DAMAGE1,Y
        DEY
        BPL WQOUT

        LDA ENH
        LSR A   
        LSR A
        LSR A
        AND #7
        TAY
        LDA #1
QSET1   STA DAMAGE1,Y
        DEY
        BPL QSET1

        LDA ENH+1
        LSR A
        LSR A
        LSR A
        AND #7
       TAY
        LDA #1
QSET2  STA DAMAGE2,Y
        DEY
        BPL QSET2

        LDA ENH+2
        LSR A
        LSR A
        LSR A
        AND #7
        TAY
        LDA #1
QSET3  STA DAMAGE3,Y
        DEY
        BPL QSET3
        RTS


COPYSETS
        LDA SCREEN
        AND #4
        ;JMP COPYMO
        BEQ COPYMO

        LDY #71
COMP1   LDA CSET2,Y
        STA &E000,Y     
        STA &E800,Y
        DEY
        BPL COMP1
       RTS

COPYMO  
        LDY #71
COMP2   LDA CSET1,Y
        
        
        STA &E000,Y
        STA &E800,Y
        DEY
        BPL COMP2
        RTS
CSET2
        HEX "0000000000000000"
        HEX "FFFFFFFFFFFFFFFF"
        HEX "FEFCF8F0E0C08000"
        HEX "7F3F1F0F07030100"
        HEX "001E66780078661E"
        HEX "E7E7E7E7E7C3A55A"
        HEX "E7E7E7E7E7E7E7E7"
        HEX "DECDE3E3D1D48383"
        HEX "0703010000000000"
        


CSET1
        HEX "0000000000000000"
        HEX "FFFFFFFFFFFFFFFF"
        HEX "7F3F0F0300000000"
        HEX "FEFCF8F0E0C08000"
        HEX "7F3F1F0F07030100"
        HEX "FFFFFFFFFFC38000"
        HEX "FFFFFFFFFF1F0000"
        HEX "F7F7E3E3E3C1C1C1"
        HEX "8094B6F7F7E7E381"

VALUES
        RTS
        LDA DEBUG
        AND #15
        CLC
        ADC #ZERO
        STA SCORE2+1
        LDA DEBUG
        LSR A
        LSR A
        LSR A
        LSR A
        ADC #ZERO
        STA SCORE2+2

        RTS

CHUMAN  DS 3

NEWGAME

        LDA #ZERO
        LDY #7
INIY    STA SCORE1,Y
        STA SCORE2,Y    
        STA SCORE3,Y
        DEY
        BPL INIY        
        LDA #&FF                
        STA SCORE1+5
        STA SCORE2+5
        STA SCORE3+5
        LDA #0
        STA SCREEN
        LDX #2
NCOMP   LDA #64
        STA ENH,X
        DEX                             
        BPL NCOMP       

       RTS
