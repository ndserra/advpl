#INCLUDE "Eco_ctb.ch"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 01/12/99
#include "Average.ch"


User Function Eco_ctb()        // incluido pelo assistente de conversao do AP5 IDE em 01/12/99
Local i
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPV,ADBF_TXT,CNOMTMP,MSEQ_LOTE,MLANC,MPERIODO")
SetPrvt("NCONT,CEMPCTB,NAUXCONT,MFOLHA,RLINHA,MDT_LANC")
SetPrvt("MVLR_TXT,MVALOR,CFORN,NSUBSETOR,NIDENTCT,MCCP")
SetPrvt("MSUBCT2,PBARRA,MSSTRING,SBARRA,MCONTA_P,MCOD_HIST")
SetPrvt("MHISTORICO,MNOME_ARQ,I,")

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ ECO_CTB  ¦ Autor ¦ VICTOR IOTTI          ¦ Data ¦ 22.12.98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ RDMAKE de geracao do TXT de integracao contabil.           ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Cliente   ¦ Degussa                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

cPV:=";"

aDBF_TXT := {}
AADD(aDBF_TXT,{"CTB_LOTE"  ,"C",  3,0 })
AADD(aDBF_TXT,{"CTB_F01"   ,"C",  1,0 })
AADD(aDBF_TXT,{"CTBCOD_LOT","C",  6,0 })
AADD(aDBF_TXT,{"CTBSEQ"    ,"C",  4,0 })
AADD(aDBF_TXT,{"CTBPERIODO","C",  2,0 })
AADD(aDBF_TXT,{"CTB_F02"   ,"C",  2,0 })
AADD(aDBF_TXT,{"CTBDT_CONT","C",  6,0 })
AADD(aDBF_TXT,{"CTB_F03"   ,"C",  2,0 })
AADD(aDBF_TXT,{"CTB_CIA"   ,"C",  3,0 })
AADD(aDBF_TXT,{"CTB_F04"   ,"C",  1,0 })
AADD(aDBF_TXT,{"CTBCONTA_P","C", 16,0 })
AADD(aDBF_TXT,{"CTB_CCP"   ,"C", 12,0 })
AADD(aDBF_TXT,{"CTBIND"    ,"C",  1,0 })
AADD(aDBF_TXT,{"CTB_HP"    ,"C",  3,0 })
AADD(aDBF_TXT,{"CTB_HIST"  ,"C",100,0 })
AADD(aDBF_TXT,{"CTB_VALOR" ,"C", 15,0 })
AADD(aDBF_TXT,{"CTB_SAC"   ,"C",  3,0 })
AADD(aDBF_TXT,{"CTB_LANC"  ,"C",  6,0 })
AADD(aDBF_TXT,{"CTB_SUBCT1","C",  2,0 })
AADD(aDBF_TXT,{"CTB_SUBCT2","C", 12,0 })
AADD(aDBF_TXT,{"CTB_F05"   ,"C",  3,0 })
AADD(aDBF_TXT,{"CTB_F06"   ,"C", 15,0 })
AADD(aDBF_TXT,{"CTB_F07"   ,"C", 31,0 })
AADD(aDBF_TXT,{"CTB_F08"   ,"C",  2,0 })
AADD(aDBF_TXT,{"CTB_F09"   ,"C",  1,0 })
AADD(aDBF_TXT,{"CTB_SIST"  ,"C",  8,0 })
AADD(aDBF_TXT,{"CTB_DT"    ,"C",  6,0 })
AADD(aDBF_TXT,{"CTB_HORA"  ,"C",  7,0 })
AADD(aDBF_TXT,{"CTB_F10"   ,"C", 56,0 })
AADD(aDBF_TXT,{"CTB_F11"   ,"C",  1,0 })
AADD(aDBF_TXT,{"CTB_F12"   ,"C",  1,0 })
AADD(aDBF_TXT,{"CTB_F13"   ,"C",  6,0 })
AADD(aDBF_TXT,{"CTB_F14"   ,"C",  1,0 })

cNomTMP:=E_Create(aDBF_TXT,.F.)
DBCREATE(cNomTMP,aDBF_TXT)
DBUSEAREA(.T.,,cNomTMP,"GERA_CTB",.F.)
IF ! USED()
   E_Msg(STR0001,20) //"Näo ha area disponivel para abertura do arquivo temporario."
   RETURN .F.
ENDIF

IndRegua("Gera_Ctb",cNomTMP+OrdBagExt(),"CTB_HIST",;
"AllwaysTrue()",;
"AllwaysTrue()",;
STR0002) //"Indexando Arquivo Temporario..."

SET INDEX TO (cNomTMP+OrdBagExt())

MSeq_Lote := 2
MLanc     := 1

DO  CASE
    CASE  MONTH(dData_Con) == 10
          MPeriodo := "01"
    CASE  MONTH(dData_Con) == 11
          MPeriodo := "02"
    CASE  MONTH(dData_Con) == 12
          MPeriodo := "03"
    CASE  MONTH(dData_Con) == 01
          MPeriodo := "04"
    CASE  MONTH(dData_Con) == 02
          MPeriodo := "05"
    CASE  MONTH(dData_Con) == 03
          MPeriodo := "06"
    CASE  MONTH(dData_Con) == 04
          MPeriodo := "07"
    CASE  MONTH(dData_Con) == 05
          MPeriodo := "08"
    CASE  MONTH(dData_Con) == 06
          MPeriodo := "09"
    CASE  MONTH(dData_Con) == 07
          MPeriodo := "10"
    CASE  MONTH(dData_Con) == 08
          MPeriodo := "11"
    CASE  MONTH(dData_Con) == 09
          MPeriodo := "12"
ENDCASE

nCont:=0
ECA->(DBSETORDER(7))
ECA->(DBSeek(cFilECA+"IMPORT"))
cEmpCtb:= GETMV("MV_EMP_CTB")

nAuxCont:=1
ProcRegua(502)
IncProc(STR0003) //'Atualizando Arq. Temporário.'

DO WHILE ! ECA->(EOF()) .AND. ECA->ECA_FILIAL == cFilECA .AND. ECA->ECA_TPMODU = "IMPORT"

   MFolha   := 1
   RLinha   := 1
   MDt_Lanc := ECA->ECA_DT_CON
   MVlr_Txt := 0

   If nAuxCont < 495
      IncProc()
      nAuxCont:=nAuxCont+1
   Else
      SYSREFRESH()
   EndIf

   DO WHILE ! ECA->(EOF()) .AND. MDt_Lanc == ECA->ECA_DT_CON .AND. ECA->ECA_FILIAL == cFilECA .AND. ECA->ECA_TPMODU = "IMPORT"
   
      IF ECA->ECA_VALOR < 0
         MValor := ECA->ECA_VALOR * (-1)
      ELSE
         MValor := ECA->ECA_VALOR
      ENDIF

//    cForn     := SPACE(06)
//    nSubSetor := SPACE(10)
      nIdentCt  := PR200IdentCt(ECA->ECA_INVOIC,ECA->ECA_HAWB,'Rd')
      nIdentCt  := ECA->ECA_IDENTC

      MCCP     := SPACE(12)
      MSUBCT2  := SPACE(12)

      IF ! EMPTY(ECA->ECA_HAWB)
          PBarra   := AT("/",ECA->ECA_HAWB)
          IF  PBarra > 4
             PBarra   := AT("-",ECA->ECA_HAWB)  && procura por Br-
          ENDIF
          MSString := SUBS(ECA->ECA_HAWB,IF(PBarra<>0,PBarra+1,1),30)
          SBarra   := AT("/",MSString)
          IF  SBarra == 0
              SBarra := AT(" ",MSString)
          ENDIF
          IF  PBarra<>0 .AND. SBarra<>0 .AND. SBarra > PBarra
              MSUBCT2  := STRZERO(VAL(SUBS(ECA->ECA_HAWB,PBarra+1,SBarra-1)),4)
          ENDIF
      ENDIF

      IF VAL(ECA->ECA_CTA_DB) #0

         MCONTA_P := IF(VAL(ECA->ECA_CTA_DB)#0,LEFT(ALLTRIM(STR(VAL(ECA->ECA_CTA_DB),15,0)),10),SPACE(10))

         DO  CASE
             CASE LEFT(MCONTA_P,1) $ "45"
                  MCCP := ALLTRIM(nSubSetor)
             CASE LEFT(MCONTA_P,7) $ "1410200/2293302" .AND. LEFT(ECA->ECA_HAWB,2) $ "52.53.57"  && LAB 02.03.99 imp. andamento e seguro
                  MCCP := LEFT(ECA->ECA_HAWB,2)
             CASE LEFT(MCONTA_P,7) $ "1410200/2293302" .AND. LEFT(ECA->ECA_HAWB,2) $ "HD.QI"     && LAB 02.03.99 imp. andamento e seguro
                  MCCP := "53"
         ENDCASE

         MCod_Hist  := STRZERO(VAL(ECA->ECA_COD_HI),3,0)
         MHistorico := IF(! EMPTY(ALLTRIM(ECA->ECA_HAWB)),ALLTRIM(ECA->ECA_HAWB)+cPV,ALLTRIM(ECA->ECA_INVOIC)+"."+cPV)   && LAB 02.12.98

         IF  LEFT(ECA->ECA_ID_CAM,2) == "62"                                                      && LAB 03.11.98 juros, ir, desp.
             MHistorico := ALLTRIM(ECA->ECA_DESCAM)+STR0004+DTOC(ECA->ECA_DT_CON)+STR0005+ALLTRIM(ECA->ECA_HAWB)+cPV  && LAB 04.01.99 //" AVISO DE "###" IMP.: "
         ENDIF

         GERA_CTB->(DBAPPEND())
         GERA_CTB->CTB_LOTE    := cEmpCtb
         GERA_CTB->CTBCOD_LOT  := cCod_Lote
         GERA_CTB->CTBSEQ      := STRZERO(MSeq_Lote,4)
         GERA_CTB->CTBPERIODO  := MPeriodo
         GERA_CTB->CTBDT_CONT  := SUBSTR(STR(YEAR(dData_Con),4,0),3,2) + STRZERO(MONTH(dData_Con),2,0) + STRZERO(DAY(dData_Con),2,0)
         GERA_CTB->CTB_CIA     := cEmpCtb
         GERA_CTB->CTBCONTA_P  := MCONTA_P
         GERA_CTB->CTB_CCP     := MCCP
         GERA_CTB->CTBIND      := "D"
         GERA_CTB->CTB_HP      := MCod_Hist
         GERA_CTB->CTB_HIST    := MHistorico
         GERA_CTB->CTB_VALOR   := "0"+SUBSTR(STRZERO(MValor,15,2),1,12)+SUBSTR(STRZERO(MValor,15,2),14,2)
         GERA_CTB->CTB_SAC     := "SAC"
         GERA_CTB->CTB_LANC    := SUBS(ECA->ECA_HAWB,4,6)
         GERA_CTB->CTB_SUBCT1  := IF(MConta_P=="1410200","99"," ")
         GERA_CTB->CTB_SUBCT2  := IF(MConta_P=="1410200",MSUBCT2," ")
         GERA_CTB->CTB_SIST    := "ITA_CON "
         GERA_CTB->CTB_DT      := SUBSTR(STR(YEAR(dDataBase),4,0),3,2) + STRZERO(MONTH(dDataBase),2,0) + STRZERO(DAY(dDataBase),2,0)
         GERA_CTB->CTB_HORA    := SUBS(cHora,1,2)+SUBS(cHora,4,2)+SUBS(cHora,7,2)+"1"
         GERA_CTB->CTB_F01     := SPACE(001)
         GERA_CTB->CTB_F03     := MPeriodo
         GERA_CTB->CTB_F04     := SPACE(001)
         GERA_CTB->CTB_F05     := SPACE(003)
         GERA_CTB->CTB_F07     := SPACE(031)
         GERA_CTB->CTB_F09     := SPACE(001)
         GERA_CTB->CTB_F10     := SPACE(055)
         GERA_CTB->CTB_F12     := SPACE(001)
         GERA_CTB->CTB_F02     := REPL("0",02)
         GERA_CTB->CTB_F06     := REPL("0",15)
         GERA_CTB->CTB_F08     := REPL("0",02)
         GERA_CTB->CTB_F11     := REPL("0",01)
         GERA_CTB->CTB_F13     := REPL("0",06)

         MLanc := MLanc + 1
         MSeq_Lote := MSeq_Lote + 2
      ENDIF

      MCCP     := SPACE(12)

      IF VAL(ECA->ECA_CTA_CR)#0

         MCONTA_P := IF(VAL(ECA->ECA_CTA_CR)#0,LEFT(ALLTRIM(STR(VAL(ECA->ECA_CTA_CRE),15,0)),10),SPACE(10))

         DO  CASE
             CASE LEFT(MCONTA_P,1) $ "45"
                  MCCP := ALLTRIM(nSubSetor)
             CASE LEFT(MCONTA_P,7) $ "1410200/2293302" .AND. LEFT(ECA->ECA_HAWB,2) $ "52.53.57"  && LAB 02.03.99 imp. andamento e seguro
                  MCCP := LEFT(ECA->ECA_HAWB,2)
             CASE LEFT(MCONTA_P,7) $ "1410200/2293302" .AND. LEFT(ECA->ECA_HAWB,2) $ "HD.QI"     && LAB 02.03.99 imp. andamento e seguro
                  MCCP := "53"
         ENDCASE

         MCod_Hist  := STRZERO(VAL(ECA->ECA_COD_HI),3,0)
         MHistorico := IF(!EMPTY(ALLTRIM(ECA->ECA_HAWB)),ALLTRIM(ECA->ECA_HAWB) + cPV,ALLTRIM(ECA->ECA_INVOIC)+"."+cPV)   && LAB 02.12.98

         IF  LEFT(ECA->ECA_ID_CAMP,2) == "62"         && LAB 03.11.98 juros, ir, desp.
             MHistorico := ALLTRIM(ECA->ECA_DESCAM)+STR0004+DTOC(ECA->ECA_DT_CON)+STR0005+ALLTRIM(ECA->ECA_HAWB)+cPV   && LAB 04.01.99 //" AVISO DE "###" IMP.: "
         ENDIF

         IF  ECA->ECA_ID_CAMP == "699"        && LAB 03.11.98 credito a banco
             IF  LEFT(MCONTA_P,7) == "2100299"  && transitoria de banco
                 MHistorico := STR0006+DTOC(ECA->ECA_DT_CON)+STR0005+ALLTRIM(ECA->ECA_HAWB)+cPV  && LAB 04.01.99 //"AVISO DE "###" IMP.: "
                 MCod_Hist  := STRZERO(0,3,0)
             ELSE
                 MHistorico := DTOC(ECA->ECA_DT_CON)+cPV  && LAB 04.01.99
             ENDIF
         ENDIF

         GERA_CTB->(DBAPPEND())
                 GERA_CTB->CTB_LOTE    := cEmpCtb
                 GERA_CTB->CTBCOD_LOT  := cCod_Lote
                 GERA_CTB->CTBSEQ      := STRZERO(MSeq_Lote,4)
                 GERA_CTB->CTBPERIODO  := MPeriodo
                 GERA_CTB->CTBDT_CONT  := SUBSTR(STR(YEAR(dData_Con),4,0),3,2) + STRZERO(MONTH(dData_Con),2,0) + STRZERO(DAY(dData_Con),2,0)
                 GERA_CTB->CTB_CIA     := cEmpCtb
                 GERA_CTB->CTBCONTA_P  := MCONTA_P
                 GERA_CTB->CTB_CCP     := MCCP
                 GERA_CTB->CTBIND      := "C"
                 GERA_CTB->CTB_HP      := MCod_Hist
                 GERA_CTB->CTB_HIST    := MHistorico
                 GERA_CTB->CTB_VALOR   := "0"+SUBSTR(STRZERO(MValor,15,2),1,12)+SUBSTR(STRZERO(MValor,15,2),14,2)
                 GERA_CTB->CTB_SAC     := "SAC"
                 GERA_CTB->CTB_LANC    := SUBS(ECA->ECA_HAWB,4,6)
                 GERA_CTB->CTB_SUBCT1  := IF(MConta_P=="1410200","99"," ")
                 GERA_CTB->CTB_SUBCT2  := IF(MConta_P=="1410200",MSUBCT2," ")
                 GERA_CTB->CTB_SIST    := "ITA_CON "
                 GERA_CTB->CTB_DT      := SUBSTR(STR(YEAR(dDataBase),4,0),3,2) + STRZERO(MONTH(dDataBase),2,0) + STRZERO(DAY(dDataBase),2,0)
         GERA_CTB->CTB_HORA    := SUBS(cHora,1,2)+SUBS(cHora,4,2)+SUBS(cHora,7,2)+"1"
                 GERA_CTB->CTB_F01     := SPACE(001)
                 GERA_CTB->CTB_F03     := MPeriodo
                 GERA_CTB->CTB_F04     := SPACE(001)
                 GERA_CTB->CTB_F05     := SPACE(003)
                 GERA_CTB->CTB_F07     := SPACE(031)
                 GERA_CTB->CTB_F09     := SPACE(001)
                 GERA_CTB->CTB_F10     := SPACE(055)
                 GERA_CTB->CTB_F12     := SPACE(001)
                 GERA_CTB->CTB_F02     := REPL("0",02)
                 GERA_CTB->CTB_F06     := REPL("0",15)
                 GERA_CTB->CTB_F08     := REPL("0",02)
                 GERA_CTB->CTB_F11     := REPL("0",01)
                 GERA_CTB->CTB_F13     := REPL("0",06)

         MLanc := MLanc + 1
         MSeq_Lote := MSeq_Lote + 2
      ENDIF

      IF RLinha == 99
         MFolha := MFolha + 1
         RLinha := 0
      ENDIF
      RLinha := RLinha + 1

      MVlr_Txt := MVlr_Txt + MValor
      ECA->(DBSKIP())
   ENDDO

ENDDO

DBSELECTAREA("Gera_Ctb")
MNome_Arq := SUBSTR(cMesProc,1,2)+LEFT(SM0->M0_FILIAL,3)+SUBSTR(STRZERO(nNR_Cont+1,4,0),2,3)+".TXT"

IF FILE(MNome_Arq)
   ERASE &MNome_Arq
ENDIF

Gera_Ctb->(DBGOTOP())

MSeq_Lote := 2

DO WHILE ! Gera_Ctb->(EOF())
   Gera_Ctb->CTBSEQ := STRZERO(MSeq_Lote,4,0)
   MSeq_Lote := MSeq_Lote + 2
   Gera_Ctb->(DBSKIP())
ENDDO

Gera_Ctb->(DBGOTOP())
COPY TO &MNome_Arq SDF

Gera_Ctb->(E_EraseArq(cNomTMP))

For I:=nAuxCont to 502
    IncProc()
Next

DBSELECTAREA("ECA")

RETURN

