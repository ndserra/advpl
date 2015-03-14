#INCLUDE "ecoiv20a.ch"
#include "Average.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ ECOIV200 ³ Autor ³ VICTOR IOTTI          ³ Data ³ 21.04.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Integracao Easy / Contabil e Rel. de Critica               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAECO                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	Last change:  US   23 Dec 99    3:42 pm
*/

#include "rwmake.ch"
#DEFINE TIPO_HOUSE "H"
#DEFINE TIPO_INVOICE "I"
#DEFINE indDESP_GI     1
#DEFINE indVL_FRETE    2
#DEFINE indVL_USSEG    3
#DEFINE indVL_II       4
#DEFINE indVL_IPI      5
#DEFINE indVL_ICMS     6
#DEFINE indVL_ARM      7
#DEFINE indICMS_C      8
#DEFINE indVL_DAP      9
#DEFINE indVL_DESP    10
#DEFINE indVL_DCI     11
#DEFINE indDESP_CL    12
#DEFINE indFRETE_RO   13
#DEFINE indVL_APORT   14
#DEFINE indVL_AAER    15
#DEFINE indVL_ADAP    16
#DEFINE indVL_701     17
#DEFINE indVL_509     18
#DEFINE indVL_NFT     19
#DEFINE indFOB_TOT    20
#DEFINE indFOBMOE      1
#DEFINE indCOMAG       2
#DEFINE indRETIDO      3
#DEFINE indVL_CORR     4
#DEFINE indDESPESA     5

*--------------------------*
User Function Ecoiv20a()        // incluido pelo assistente de conversao do AP5 IDE em 21/12/99
*--------------------------*
Private lAtuDtCont:=.F.
Private lTop := .F.

// ** AAF 08/01/08 - Execucao por Agendamento
If Type("lScheduled") <> "L"
   Private lScheduled := .F.
EndIf
// **

#IFDEF TOP                                      
  IF (TcSrvType() != "AS/400") // Considerar qdo for AS/400 para que tenha o tratamento de Codbase
     lTop := .T.
  Endif
#ENDIF 

// Verifica se existe o campo EC9_FORN / EC8_FORN
Private lExisteECF := .F., lExisteECG := .F., nTransito := 1

nTransito  := GetNewPar("MV_TRANSIT",1)

SX3->(DbSetOrder(1))

// Verifica se existe o arquivo de pagamento antecipado ECF / ECG
lExisteECF := GetMV("MV_PAGANT", .F., .F.)
If lExisteECF 
   cFilECF    := xFilial('ECF')			
   lExisteECG := .T.   
   cFilECG    := xFilial('ECG')			
Endif                    


lRetIV200:=.T.; lAberto:=.F.
aARQ_EIC := {"W6","W8","W2","W9","W0","W1","YS","WB","WD","YT","Y6"}
cAliasOld := Alias()
lAbre:=.T.

// ** AAF 08/01/08 - Execucao por Schedule
If lScheduled
   bMSG :={|msg| AvE_Msg(msg,1)}   
Else
   bMSG :={|msg| MsProcTxt(msg)}
EndIf

lAtuDtCont:= lScheduled .OR. MsgYesNo(STR0001,STR0020) //"Integração Efetiva ?" ###"Questão ?"
AvPAguarde({|| E_Open(bMSG,aARQ_EIC,@lAbre) },STR0002) //"Abertura de Arquivos"

cCC_ESTOQ := SPACE(10)
cSUB_SET := SPACE(10)
lRetIV200:=lAbre
cImpCGC:="01"

SY6->(DBSETORDER(1))

SW6->(DBSETORDER(1))
SW8->(DBSETORDER(1))
SW2->(DBSETORDER(1))
SW9->(DBSETORDER(1))
SW1->(DBSETORDER(1))
SYS->(DBSETORDER(1))
SWB->(DBSETORDER(1))
SWD->(DBSETORDER(1))
SYT->(DBSETORDER(1))
SW0->(DBSETORDER(1))                                          
EC5->(DBSETORDER(1))
EC6->(DBSETORDER(1))
ECC->(DBSETORDER(1))                                                                       
EC2->(DBSETORDER(1))
EC8->(DBSETORDER(1))
EC9->(DBSETORDER(1))
EC4->(DBSETORDER(1))
EC0->(DBSETORDER(1))

If lRetIV200
   cPathCont := ALLTRIM(GETMV("MV_PATH_CO"))

   IF(Right(cPathCont,1)#"\", cPathCont := cPathCont+"\",)      

   IF ! lIsDir(Left(cPathCont,Len(cPathCont)-1))
      // Path nao existe
      Help(" ",1,"E_PATH_CO")
      lRetIV200:=.F.
   ENDIF                                                  
      
   If lRetIV200
      lRetIV200:=ExecBlock("ECOIV20B",.F.,.F.)
   EndIf

   If lRetIV200
      lRetIV200:=ExecIV200()// Substituido pelo assistente de conversao do AP5 IDE em 21/12/99 ==>       lRetIV200:=Execute(ExecIV200)
   EndIf
EndIF

If lAberto
   DI_Ctb->(DbCloseArea())
   IVH_Ctb->(DbCloseArea())
   IV_Ctb->(DbCloseArea())
   APD_Ctb->(DbCloseArea())   
   If lExisteECF 		
      ANT_Ctb->(DbCloseArea())      
   Endif
EndIf

dbSelectArea(cAliasOld)

Return(lRetIV200) 


*--------------------------*
Static FUNCTION ExecIV200()
*--------------------------*
lRetFunc:=.T.
dIniEncerra:=dFimEncerra:=NIL

PRIVATE MTab_PO[30],MTab_IV[30], dIniEncerra, dFimEncerra, cIdentCT, lPrimeiroPo
PRIVATE MTab_HAWB[1590],MTabVlr_H[1590],MTab_CADT[1590],MTab_BCO[1590]  && LAB 26.10.98

Mvl_ii := Mvl_ipi := Mvl_desp := Mvl_701 := Mvl_702 := Mvl_703 := 0
Mvl_dci := Mvl_icms := Micms_c := Mvl_arm := Mvl_dap := Mdesp_gi := 0
Mdesp_cl := Mvl_frete := Mfrete_ro := Mvl_aport := Mvl_aaer := 0
Mvl_adap := Mvl_509 := Mvl_NFT := 0
Mvl_totdesp := 0

MImport := cIdentCT := ""

dIniEncerra := AVCTOD('')
dFimEncerra := AVCTOD("31/12/00")

While .T.
   IF !(lStatus:=Pergunte( "EICIV2", !lScheduled ))  .OR.  ! U_IV_VALID("*")
      IF !lStatus
          lRetFunc:=.F.
          Exit
      ENDIF
      LOOP
   ENDIF

   EXIT
End

If lRetFunc
   dIniEncerra := mv_par01
   dFimEncerra := mv_par02
   cImport1    := mv_par03
   cImport2    := mv_par04
   cImport3    := mv_par05
   cImport4    := mv_par06
   MImport     := cImport1+"/"+cImport2+"/"+cImport3+"/"+cImport4+"/"
   AvProcessa({|| ApagaEcos() })       			                               // Victor
   AvProcessa({|| GRVEC4() })       			                               // Victor
   AvProcessa({|| LIMPAECA() })
   
   If lExisteECF .And. lExisteECG
      AvProcessa({||ApagaECFECG()},STR0003)   //'Aguarde... Atualizando Dados'
      AvProcessa({||GeraPagtos()}, STR0004) //'Aguarde... Apurando Pagamentos Antecipados'
   Endif

   AvProcessa({|| IV200GrvDI() })
   AvProcessa({|| IV200GrvAPD() })

   AvE_Msg(AnsiToOem(STR0005),1) //"Geração concluída. Clique OK para continuar ..."
EndIf

RETURN lRetFunc

*---------------------------*
Static FUNCTION IV200GrvDI()
*---------------------------*
Local i, dDtIni, dDtFim
lEntrou := .F.; nLastRec:=0
cFil_SW6:=xFilial("SW6"); cFil_SW8:=xFilial("SW8"); cFil_SYS:=xFilial("SYS"); cFil_SW7:=xFilial("SW7")
cFil_SW2:=xFilial("SW2")
MConta := 0
cCC_ESTOQ := SPACE(10)
cSUB_SET := SPACE(10)

aTotal:={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Soma dos valores gravados por CCusto³
//³==============================================================³
//³ 1. DIDESP_GI       2. DIVL_FRETE            3. DIVL_USSEG    ³
//³ 4. DIVL_II         5. DIVL_IPI              6. DIVL_ICMS     ³
//³ 7. DIVL_ARM        8. DIICMS_C              9. DIVL_DAP      ³
//³ 10.DIVL_DESP       11.DIVL_DCI              12.DIDESP_CL     ³
//³ 13.DIFRETE_RO      14.DIVL_APORT            15.DIVL_AAER     ³
//³ 16.DIVL_ADAP       17.DIVL_701              18.DIVL_509      ³
//³ 19.DIVL_NFT        20.DIFOB_TOT                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MPrimeiro := .T.; MGrava := .F.

dbSelectArea("SW6")
cFil_SW6:=xFilial("SW6")
cFil_SW8:=xFilial("SW8")

SW6->(dbSeek(cFil_SW6))
ProcRegua( SW6->(LastRec()) )

DO WHILE  SW6->(!EOF()) .AND. cFil_SW6 == SW6->W6_FILIAL

   MConta++
   IncProc(STR0006+Str(MConta)) //"Registros Processos: "
   SysRefresh()
   MGrava := .F.
   MPrimeiro := .T.
   
   //FSM - 24/10/2012   
   dDtIni := GetDt("INICIO")
   dDtFim := GetDt("FIM")

   If !Empty(dDtFim) .AND. dIniEncerra > dDtFim .OR. Empty(dDtIni)
      SW6->(dbSkip())
      Loop
   EndIf

   /* //FSM - 24/10/2012
   If nTransito = 1
      If (!Empty(SW6->W6_DT_ENCE) .And.;
         (dIniEncerra > SW6->W6_DT_ENCE .Or. dFimEncerra < SW6->W6_DT_ENCE)) 
         SW6->(DBSKIP())
         Loop
      EndIf
      If Empty(SW6->W6_DT_EMB) //.OR. dFimEncerra < SW6->W6_DT_EMB
         SW6->(DBSKIP())
         Loop
      EndIf
      
   Else // embarque
      If !Empty(SW6->W6_DT_ENCE) .and. SW6->W6_DT_ENCE > dFimEncerra
         SW6->(DBSKIP())
         Loop
      EndIf   
      If Empty(SW6->W6_DT_EMB) .or. SW6->W6_DT_EMB > dFimEncerra
         SW6->(DBSKIP())
         Loop
      EndIf
   Endif   
   */
   
   SW8->(DbSEEK(cFil_SW8+SW6->W6_HAWB ))

   DO WHILE .NOT. SW8->(EOF()) .AND. SW6->W6_HAWB == SW8->W8_HAWB .AND. cFil_SW8 == SW8->W8_FILIAL
      SysRefresh()

      // Localiza a Moeda correspondente no SW9
      SW9->(DbSetOrder(01))
      SW9->(DbSeek(xFilial()+SW8->W8_INVOICE+SW8->W8_FORN))

      IF ! SW2->( dbSEEK( xFilial()+SW8->W8_PO_NUM ) )
         DbSelectArea("SW8")
         SW8->( DBSKIP() )
         LOOP
      ENDIF

      IF !lExisteECF .Or. !lExisteECG
      If ! EMPTY(SW9->W9_COND_PA) .AND. SW9->W9_DIAS_PA >= 900 // VI 14/05/01 desprezar invoice com pagto antecipado
         If ! SY6->(DBSEEK(xFilial('SY6')+SW9->W9_COND_PA+STR(SW9->W9_DIAS_PA,3,0)))
            DbSelectArea("SW8")
            SW8->( DBSKIP() )
            LOOP         
         ElseIf SY6->Y6_TIPOCOB = "4"
            DbSelectArea("SW8")
            SW8->( DBSKIP() )
            LOOP
         Else
            lLoop:=.F.
            For i:= 1 to 10
                _Dias:= "Y6_DIAS_" + STRZERO(i,2) 
                _Dias:= SY6->(FIELDGET( FIELDPOS(_Dias) ))
                IF _Dias < 0
                   lLoop:=.T.
                   i:=11
                ENDIF
            NEXT
            
            If lLoop
               DbSelectArea("SW8")
               SW8->( DBSKIP() )
               LOOP
            EndIf
         EndIf
//    ElseIf ! EMPTY(SW9->W9_COND_PA) .AND. SW9->W9_DIAS_PA < 0 // VI 25/08/01 desprezar invoice com pagto antecipado
//       DbSelectArea("SW8")
//       SW8->( DBSKIP() )
//       LOOP
 
 //       ElseIf ! EMPTY(SW9->W9_COND_PA) .AND. SY6->(DBSEEK(xFilial('SY6')+SW9->W9_COND_PA+STR(SW9->W9_DIAS_PA,3,0))) // VI 14/05/01
 //          If SY6->Y6_TIPOCOB = "4"  // Sem cobertura cambial
 //             DbSelectArea("SW8")
 //             SW8->( DBSKIP() )
 //             LOOP
 //          EndIf         
 
      ElseIF EMPTY(SW9->W9_COND_PA) .AND. SW2->W2_DIAS_PAG >= 900   && desprezar invoice com pagto antecipado
         If ! SY6->(DBSEEK(xFilial('SY6')+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0)))
            DbSelectArea("SW8")
            SW8->( DBSKIP() )
            LOOP         
         ElseIf SY6->Y6_TIPOCOB = "4"
            DbSelectArea("SW8")
            SW8->( DBSKIP() )
            LOOP
         Else
            lLoop:=.F.
            For i:= 1 to 10
                _Dias:= "Y6_DIAS_" + STRZERO(i,2) 
                _Dias:= SY6->(FIELDGET( FIELDPOS(_Dias) ))
                IF _Dias < 0
                   lLoop:=.T.
                   i:=11
                ENDIF
            NEXT
            
            If lLoop
               DbSelectArea("SW8")
               SW8->( DBSKIP() )
               LOOP
            EndIf
         EndIf   
//    ElseIF EMPTY(SW9->W9_COND_PA) .AND. SW2->W2_DIAS_PAG < 0   && desprezar invoice com pagto antecipado
//       DbSelectArea("SW8")
//       SW8->( DBSKIP() )
//       LOOP

//        ElseIf EMPTY(SW9->W9_COND_PA) .AND. SY6->(DBSEEK(xFilial('SY6')+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0))) // VI 14/05/01
//          If SY6->Y6_TIPOCOB = "4"
//            DbSelectArea("SW8")
//             SW8->( DBSKIP() )
//             LOOP
//          EndIf         
         EndIf         
      ENDIF

      IF !AllTrim(SW2->W2_IMPORT) $ MImport  && SELECAO DE IMPORTADOR //AOM - 10/07/2012 - Alltrim
         SW8->( DBSKIP() )
         LOOP
      ENDIF

      
      // Verifica se possui cobertura cambial 
      If ! EMPTY(SW9->W9_COND_PA) .AND. SY6->(DBSEEK(xFilial('SY6')+SW9->W9_COND_PA+STR(SW9->W9_DIAS_PA,3,0))) // VI 14/05/01
         If SY6->Y6_TIPOCOB = "4"  // Sem cobertura cambial
            DbSelectArea("SW8")
            SW8->( DBSKIP() )
            LOOP
         EndIf         
      ElseIf EMPTY(SW9->W9_COND_PA) .AND. SY6->(DBSEEK(xFilial('SY6')+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0))) // VI 14/05/01
         If SY6->Y6_TIPOCOB = "4"
            DbSelectArea("SW8")
            SW8->( DBSKIP() )
            LOOP
         EndIf         
      Endif
      
       
      cImpCGC:="01"
      IF SYT->(DbSeek(xFilial()+AVKEY(SW2->W2_IMPORT,"YT_COD_IMP")))////AOM - 12/07/2012
         cImpCGC:=SUBSTR(SYT->YT_CGC,11,2)
      Endif

      IF ! SW9->( DBSEEK(xFilial()+SW8->W8_INVOICE+SW8->W8_FORN) )
         AvE_MSG( STR0007 + SW8->W8_INVOICE + STR0008+ SW8->W8_FORN + STR0009,1000 ) //### //"INVOICE SEM HEADER "###" - "###" FAVOR ANOTAR E TECLAR ENTER"
         SW8->( DBSKIP() )
         LOOP
      ENDIF

//    para iniciar a utilização do sistema de contabilização 
//
//    IF Empty(SW6->W6_DT_ENCE) .And. SW9->W9_DT_EMIS < AVCTOD("01/03/00")   // LAB 24.03.00      
//       DbSelectArea("SW8")            
//       SW8->( DBSKIP() )            
//       LOOP
//    ENDIF
            
      SW7->(dbSeek(xFilial()+SW6->W6_HAWB))
      SW0->(dbSeek(xFilial()+SW7->W7_CC+SW7->W7_SI_NUM))
      SW1->(dbSeek(xFilial()+SW7->W7_CC+SW7->W7_SI_NUM+SW7->W7_COD_I))

      cSUB_SET   := SPACE(10)
      cCC_CODIGO := SPACE(10)
      cW1_CLASS  := SW1->W1_CLASS
//    DO CASE
//       CASE SW1->W1_CLASS == "1" .OR. SW1->W1_CLASS == "5"
//            cSUB_SET   := SPACE(10)
//            cCC_CODIGO := " "                             && LAB 14.06.99
//       CASE SW1->W1_CLASS == "2" .OR. SW1->W1_CLASS == "4"
//            cSUB_SET   := SW0->W0_DAI
//            cCC_CODIGO := " "                             && LAB 14.06.99
//       CASE SW1->W1_CLASS == "3"
//            cSUB_SET   := SPACE(10)
//            cCC_CODIGO := SPACE(05)
//    ENDCASE*/
//      dbSelectArea("IV_CTb")

      // IF ! IV_Ctb->( dbSeek( SW8->W8_INVOICE ))//+SW8->W8_FORN ) )
      IV_Ctb->(DbSetOrder(2))
      IF ! IV_Ctb->( dbSeek( SW8->W8_INVOICE + SW8->W8_FORN ))  

         SWB->(DBSETORDER(1))
         SWB->(DBSEEK(xFilial()+SW8->W8_HAWB))
         MDt_Vencto:= SWB->WB_DT_VEN
         Iv200_Grava("1")
         MPrimeiro := .T.
         nRecno := IV_Ctb->(Recno())
         IV_Ctb->(DbSetOrder(1))   
         IV_Ctb->(DbGoto(nRecno))               
      Else    
         nRecno := IV_Ctb->(Recno())
         IV_Ctb->(DbSetOrder(1))
         IV_Ctb->(DbGoto(nRecno))               
      ENDIF

//      dbSelectArea("IVH_Ctb")
      Iv200_Grava("2")

      SW8->(dbSkip())
   ENDDO

   IF MGrava
      // Rotina de verificacao no SWB se ha pagamento antecipado para este processo
      If lExisteECF .And. lExisteECG
         VerifPagAnt()
      Endif   
      IV20GRVDI_Ctb()
      IF lAtuDtCont
         SW6->(RECLOCK("SW6",.F.))
         SW6->W6_CONTAB := dDataBase
         SW6->(MSUnlock())
      ENDIF
   ENDIF
   SW6->(DBSKIP())
ENDDO

RETURN .T.

*-----------------------------*
Static FUNCTION IV200GrvAPD()
*-----------------------------*    
Local lPagAnt := .F., lDI100 := .F., i

cFil_SWB:=xFilial("SWB"); cFil_SW9:=xFilial("SW9"); cFil_SYS:=xFilial("SYS"); cFilEC5 := xFilial("EC5");cFil_SW8:=xFilial("SW8")
aTotal:={0,0,0,0,0}; lPagAnt := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Soma dos valores gravados por CCusto³
//³==============================================================³
//³ 1. APDFOBMOE          2. APDCOMAG           3. APDRETIDO     ³
//³ 4. APDVL_CORR         5. APDDESPESA                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SWB->(DBSETORDER(3))
SWB->(DBGOTOP())

AFILL(MTab_HAWB,SPACE(28))
AFILL(MTabVlr_H,0)
AFILL(MTab_CADT,AVCTOD("  /  /  "))
AFILL(MTab_BCO,SPACE(20))
MT_h_ind = 0

ProcRegua( SWB->(LASTREC()) )
SysRefresh()
MConta:=0
SWB->(DBSEEK(cFil_SWB+DTOS(dIniEncerra - 5),.T.))

DO WHILE .NOT. SWB->(EOF()) .AND. SWB->WB_CA_DT <= (dFimEncerra + 5) ;  && pagto no mes
         .AND. cFil_SWB == SWB->WB_FILIAL
   MConta++
   IncProc(STR0006+Str(MConta)) //"Registros Processos: "
   lDI100 := .F.
   SW8->(dbSeek(cFil_SW8+SWB->WB_HAWB))
   cForn:=SW8->W8_FORN
   // Localiza moeda correspondente da Invoice no SW9
   SW9->(dbSeek(xFilial()+SW8->W8_INVOICE+cForn))
   SW6->(dbSeek(xFilial()+SWB->WB_HAWB))   
   
   IF ! SW2->(dbSeek(xFilial()+SW8->W8_PO_NUM))
      SWB->(DBSKIP())
      LOOP
   ENDIF

   IF SWB->WB_DT_DESE < dIniEncerra .OR. SWB->WB_DT_DESE > dFimEncerra .OR. SWB->WB_FOBMOE <= 0 //FSM - 12/12/2012
      SWB->(DBSKIP())
      LOOP
   ENDIF
   
   // Verifica se e adiantamento antes da DI e apos o embarque
   lPagAnt := If(nTransito=2,.T.,.F.)
                                    
   If !lPagAnt .and. ! lExisteECF
      If ! EMPTY(SW9->W9_COND_PA) .AND. SW9->W9_DIAS_PA >= 900 // VI 14/05/01 desprezar invoice com pagto antecipado
         If ! SY6->(DBSEEK(xFilial('SY6')+SW9->W9_COND_PA+STR(SW9->W9_DIAS_PA,3,0)))
            DbSelectArea("SW8")
            SWB->( DBSKIP() )
            LOOP         
         ElseIf SY6->Y6_TIPOCOB = "4"
            DbSelectArea("SW8")
            SWB->( DBSKIP() )
            LOOP
         Else
            lLoop:=.F.
            For i:= 1 to 10
                _Dias:= "Y6_DIAS_" + STRZERO(i,2) 
                _Dias:= SY6->(FIELDGET( FIELDPOS(_Dias) ))
                IF _Dias < 0
                   lLoop:=.T.
                   i:=11
                ENDIF
            NEXT
         
            If lLoop
               DbSelectArea("SW8")
               SWB->( DBSKIP() )
               LOOP
            EndIf
         EndIf
      ElseIf ! EMPTY(SW9->W9_COND_PA) .AND. SW9->W9_DIAS_PA < 0 // VI 25/08/01 desprezar invoice com pagto antecipado
         DbSelectArea("SW8")
         SWB->( DBSKIP() )
         LOOP
      //ElseIf ! EMPTY(SW9->W9_COND_PA) .AND. SY6->(DBSEEK(xFilial('SY6')+SW9->W9_COND_PA+STR(SW9->W9_DIAS_PA,3,0))) // VI 14/05/01
      //   If SY6->Y6_TIPOCOB = "4"  // Sem cobertura cambial
      //      DbSelectArea("SW8")
      //      SWB->( DBSKIP() )
      //      LOOP
      //   EndIf         
      ElseIF EMPTY(SW9->W9_COND_PA) .AND. SW2->W2_DIAS_PAG >= 900   && desprezar invoice com pagto antecipado
         If ! SY6->(DBSEEK(xFilial('SY6')+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0)))
            DbSelectArea("SW8")
            SWB->( DBSKIP() )
            LOOP         
         ElseIf SY6->Y6_TIPOCOB = "4"
            DbSelectArea("SW8")
            SWB->( DBSKIP() )
            LOOP
         Else
            lLoop:=.F.
            For i:= 1 to 10
               _Dias:= "Y6_DIAS_" + STRZERO(i,2) 
               _Dias:= SY6->(FIELDGET( FIELDPOS(_Dias) ))
               IF _Dias < 0
                  lLoop:=.T.
                  i:=11
               ENDIF
            NEXT
            If lLoop
               DbSelectArea("SW8")
               SWB->( DBSKIP() )
               LOOP
            EndIf
         EndIf   
      ElseIF EMPTY(SW9->W9_COND_PA) .AND. SW2->W2_DIAS_PAG < 0   && desprezar invoice com pagto antecipado
         DbSelectArea("SW8")
         SWB->( DBSKIP() )
         LOOP
      //ElseIf EMPTY(SW9->W9_COND_PA) .AND. SY6->(DBSEEK(xFilial('SY6')+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0))) // VI 14/05/01      
      //   If SY6->Y6_TIPOCOB = "4"
      //      DbSelectArea("SW8")
      //      SWB->( DBSKIP() )
      //      LOOP
      //   EndIf         
      ENDIF   
   Endif  
   
   // Testa a condicao de pagamento e verfica se possui cobertura cambial
   If ! EMPTY(SW9->W9_COND_PA) .AND. SY6->(DBSEEK(xFilial('SY6')+SW9->W9_COND_PA+STR(SW9->W9_DIAS_PA,3,0))) // VI 14/05/01
      If SY6->Y6_TIPOCOB = "4"  // Sem cobertura cambial
         DbSelectArea("SW8")
         SWB->( DBSKIP() )
         LOOP
      EndIf         
      ElseIf EMPTY(SW9->W9_COND_PA) .AND. SY6->(DBSEEK(xFilial('SY6')+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0))) // VI 14/05/01
         If SY6->Y6_TIPOCOB = "4"
            DbSelectArea("SW8")
            SWB->( DBSKIP() )
            LOOP
         EndIf         
      ENDIF   
   
   IF !AllTrim(SW2->W2_IMPORT) $ MImport  && SELECAO DE IMPORTADOR  //AOM - 12/07/2012
      SWB->(DBSKIP())
      LOOP
   ENDIF

   &&  LAB 07.09.98 gravar house e invoices ref. ao pagamento existente no APD100
	EC2->(DBSETORDER(1))
   //lDI100 := DI_Ctb->(DBSEEK(SWB->WB_HAWB))
   lDI100 := (DI_Ctb->(DBSEEK(SWB->WB_HAWB)) .or. EC2->(DBSEEK(XFILIAL("EC2")+SWB->WB_HAWB)))
   If lPagAnt //FSM - 24/10/2012
      nOldECFOrd := ECF->(IndexOrd())
      ECF->(dbSetOrder(5))//ECF_FILIAL+ECF_TPMODU+ECF_HAWB+ECF_FORN+ECF_ORIGEM+ECF_SEQ+ECF_ID_CAM+ECF_IDENTC
      lDI100 := !Empty(GetDt("INICIO")) .AND. (Empty(SWB->WB_DT_DESE) .OR. SWB->WB_DT_DESE >= GetDt("INICIO")) .AND. !ECF->(DBSEEK(cFilECF+"IMPORT"+SWB->WB_HAWB+SW9->W9_FORN+"PR"+SWB->WB_LINHA+"608")) //FSM - 05/12/2012
      ECF->(dbSetOrder(nOldECFOrd))
   EndIf
   
   IF  ! lDI100 .And. !lPagAnt
			   	
       cCC_CODIGO := SPACE(10)

       MPrimeiro = .T.
       MGrava = .F.                    
       SW8->(dbSeek(cFil_SW8+SW6->W6_HAWB))
                                                                  	
       DO WHILE !SW8->(EOF()) .AND. SW6->W6_HAWB = SW8->W8_HAWB .AND. ;
                                    cFil_SW8     = SW8->W8_FILIAL
          
          SW9->( DBSETORDER(1) )
          IF ! SW9->( DBSEEK(xFilial()+SW8->W8_INVOICE+SW8->W8_FORN) )
             AvE_Msg( STR0010 + SW8->W8_INVOICE + STR0008+ SW8->W8_FORN + STR0011,STR0012)//### //"INVOICE SEM CAPA "###" - "###" FAVOR ANOTAR"###"Informação"
             SW8->( DBSKIP() )
             LOOP
          ENDIF
          
          IV_Ctb->(DbSetOrder(2))

          IF !IV_Ctb->( dbSeek( SW8->W8_INVOICE + SW8->W8_FORN  ) ) //Prepara o ECO para tratar mesmo número de invoice para fornecedores diferentes +SW8->W8_FORN
             nRegSWB := SWB->(RECNO()) // VI
             SWB->(DBSETORDER(1))
             SWB->(DBSEEK(xFilial()+SW8->W8_HAWB))
             MDt_Vencto = SWB->WB_DT_VEN
             Iv200_Grava("1")
             MPrimeiro := .T.
             SWB->(DBSETORDER(3)) // VI
             SWB->(DBGOTO(nRegSWB)) // VI
             IV_Ctb->(DbSetOrder(1))   
          ELSE
             nRecno := IV_Ctb->(Recno())
             IV_Ctb->(DbSetOrder(1))
             IV_Ctb->(DbGoto(nRecno))               
          Endif
                             
          dbSelectArea("DI_Ctb")
          Iv200_Grava("2")
       
          SW8->( DBSKIP() )
      ENDDO

      IF MGrava
         IV20GRVDI_Ctb()                   
      ENDIF

   ENDIF

   //GFP - 08/11/2011 - Tratamento Loja
   If EICLOJA()
      SYS->(dbSeek(cFil_SYS+"I"+TIPO_INVOICE+SW9->W9_HAWB+SW9->W9_FORN+SW9->W9_FORLOJ+SW9->W9_MOE_FOB+SW9->W9_INVOICE)) 
   Else
      SYS->(dbSeek(cFil_SYS+"I"+TIPO_INVOICE+SW9->W9_HAWB+SW9->W9_FORN+SW9->W9_MOE_FOB+SW9->W9_INVOICE))
   EndIf
   
   lEntrou := .F.
   aTotal:={0,0,0,0,0}

 && LAB 03.08.99
 DO WHILE SYS->(!EOF()) .AND. SYS->YS_FILIAL==cFil_SYS .AND. SYS->YS_TPMODU == "I" .AND. SYS->YS_TIPO+SYS->YS_HAWB+SYS->YS_FORN+SYS->YS_MOEDA+SYS->YS_INVOICE==TIPO_INVOICE+SWB->WB_HAWB+SWB->WB_FORN+SWB->WB_MOEDA+SWB->WB_INVOICE
   SysRefresh()
   lEntrou := .T.
   cIdentCT := SYS->YS_CC

   IF  SWB->WB_TIPOREG = "3"      && LAB 03.11.98  i.r. nao processar
       SWB->(DBSKIP())
       LOOP
   ENDIF

   IF  SWB->WB_TIPOREG $ "2/6"      && LAB 28.10.98  juros, e Desp.bancarias nao geram VCF, e sim DDI
       IF  Di_Ctb->(DBSEEK(SWB->WB_HAWB))
           SA6->(DBSEEK(xFilial()+SWB->WB_BANCO+SWB->WB_AGENCIA))
           DBSELECTAREA("Di_Ctb")
           DO  CASE
               CASE  SWB->WB_TIPOREG = "2"     && LAB 28.10.98 juros
                     REPLACE DIVL_620   WITH DIVL_620+VAL(STR(SWB->(WB_FOBMOE * WB_CA_TX),15,2)) ,;
                             DIDT_620   WITH SWB->WB_DT_DESE  ,;//LAB 02/03/2000
                             DICC_620   WITH SA6->A6_CONTABI
               CASE  SWB->WB_TIPOREG = "6"     && LAB 09.09.98 despesas
                     REPLACE DIVL_623   WITH DIVL_623+VAL(STR(SWB->(WB_FOBMOE * WB_CA_TX),15,2)) ,;
                             DIDT_623   WITH SWB->WB_DT_DESE  ,;//LAB 02/03/2000
                             DICC_623   WITH SA6->A6_CONTABI
           ENDCASE 
    
           IF ASCAN(MTab_HAWB,SWB->WB_HAWB + cIdentCT) = 0  && LAB 26.10.98
              MT_h_ind = MT_h_ind + 1
              MTab_HAWB[MT_h_ind] := SWB->WB_HAWB + cIdentCT
              MTabVlr_H[MT_h_ind] := MTabVlr_H[MT_h_ind] + VAL(STR(SWB->(WB_FOBMOE * WB_CA_TX),15,2))
              MTab_CADT[MT_h_ind] := SWB->WB_DT_DESE  //LAB 02/03/2000
              MTab_BCO[MT_h_ind]  := SA6->A6_CONTABI
           ELSE
              Wk_Ind := ASCAN(MTab_HAWB,SWB->WB_HAWB + cIdentCT) 
              MTabVlr_H[Wk_Ind] := MTabVlr_H[Wk_Ind] + VAL(STR(SWB->(WB_FOBMOE * WB_CA_TX),15,2))
           ENDIF
       ENDIF
       SWB->(DBSKIP())
       LOOP
   ENDIF
   
   IF lDI100 .OR. !lPagAnt
      DBSELECTAREA("APD_Ctb")
      APD_Ctb->(RecLock("APD_Ctb",.T.)) // inclui registro.
      APD_Ctb->APDTIPOREG := SWB->WB_TIPOREG
      APD_Ctb->APDHAWB    := SWB->WB_HAWB
      APD_Ctb->APDNUM     := SWB->WB_NUM
      APD_Ctb->APDDT      := SWB->WB_DT
      APD_Ctb->APDBANCO   := SWB->WB_BANCO
      APD_Ctb->APDAGENCIA := SWB->WB_AGENCIA
	  APD_Ctb->APDCONTA   := SWB->WB_CONTA    //FSM - 13/12/2012
      APD_Ctb->APDLC_NUM  := SWB->WB_LC_NUM
      APD_Ctb->APDCA_NUM  := SWB->WB_CA_NUM
      APD_Ctb->APDCA_DT   := SWB->WB_DT_DESE  //LAB 02/03/2000
      APD_Ctb->APDCA_TX   := SWB->WB_CA_TX
      APD_Ctb->APDDT_VEN  := SWB->WB_DT_VEN
      APD_Ctb->APDTIPO    := SWB->WB_TIPO
      APD_Ctb->APDOBS     := SWB->WB_OBS
      APD_Ctb->APDNR_ROF  := SWB->WB_NR_ROF
      APD_Ctb->APDDT_ROF  := SWB->WB_DT_ROF
      APD_Ctb->APDDT_CONT := SWB->WB_DT_CONT
      APD_Ctb->APDLIM_BAC := SWB->WB_LIM_BAC
      APD_Ctb->APDENV_BAC := SWB->WB_ENV_BAC
      APD_Ctb->APDDT_DIG  := SWB->WB_DT_DIG
      APD_Ctb->APDINVOICE := SWB->WB_INVOICE

      APD_Ctb->APDDT_REAL := SWB->WB_DT_REAL
      APD_Ctb->APDLOTE    := SWB->WB_LOTE
      APD_Ctb->APDDT_DESE := SWB->WB_DT_DESE
      APD_Ctb->APDDT_PAG  := SWB->WB_DT_PAG
      APD_Ctb->APDCOMAG   := SYS->YS_PERC * SWB->WB_COMAG
      APD_Ctb->APDRETIDO  := SYS->YS_PERC * SWB->WB_RETIDO
      APD_Ctb->APDCORRETO := SWB->WB_CORRETO
      APD_Ctb->APDVL_CORR := SYS->YS_PERC * SWB->WB_VL_CORR
      APD_Ctb->APDDESPESA := SYS->YS_PERC * SWB->WB_DESPESA
      APD_Ctb->APDFORMPAG := SWB->WB_FORMPAG
      APD_Ctb->APDIDENTCT := cIdentCT

      APD_Ctb->APDFOBMOE  := SYS->YS_PERC * SWB->WB_FOBMOE

      IF SA6->(DBSEEK(xFilial()+SWB->WB_BANCO+SWB->WB_AGENCIA))
         APD_Ctb->APDBCO_CON := SA6->A6_CONTABI
      ENDIF                 
      APD_Ctb->APDFORN    := cForn
      APD_Ctb->APDSEQ    := SWB->WB_LINHA
      APD_Ctb->(MSUNLOCK())
   Else
   
      SW9->( DBSEEK(xFilial()+SWB->WB_INVOICE+cForn) )

      DBSELECTAREA("ANT_Ctb")
      ANT_Ctb->(RecLock("ANT_Ctb",.T.)) // inclui registro.
      ANT_Ctb->ANTTIPOREG := SWB->WB_TIPOREG
      ANT_Ctb->ANTHAWB    := SWB->WB_HAWB
      ANT_Ctb->ANTNUM     := SWB->WB_NUM
      ANT_Ctb->ANTDT      := SWB->WB_DT
      ANT_Ctb->ANTBANCO   := SWB->WB_BANCO
      ANT_Ctb->ANTAGENCIA := SWB->WB_AGENCIA
	  ANT_Ctb->ANTCONTA   := SWB->WB_CONTA   //FSM - 13/12/2012
      ANT_Ctb->ANTLC_NUM  := SWB->WB_LC_NUM
      ANT_Ctb->ANTCA_NUM  := SWB->WB_CA_NUM
      ANT_Ctb->ANTCA_DT   := SWB->WB_CA_DT
      ANT_Ctb->ANTCA_TX   := SWB->WB_CA_TX
      ANT_Ctb->ANTDT_VEN  := SWB->WB_DT_VEN
      ANT_Ctb->ANTTIPO    := SWB->WB_TIPO
      ANT_Ctb->ANTOBS     := SWB->WB_OBS
      ANT_Ctb->ANTNR_ROF  := SWB->WB_NR_ROF
      ANT_Ctb->ANTDT_ROF  := SWB->WB_DT_ROF
      ANT_Ctb->ANTDT_CONT := SWB->WB_DT_CONT
      ANT_Ctb->ANTLIM_BAC := SWB->WB_LIM_BAC
      ANT_Ctb->ANTENV_BAC := SWB->WB_ENV_BAC
      ANT_Ctb->ANTDT_DIG  := SWB->WB_DT_DIG
      ANT_Ctb->ANTINVOICE := SWB->WB_INVOICE
      ANT_Ctb->ANTDT_REAL := SWB->WB_DT_REAL
      ANT_Ctb->ANTLOTE    := SWB->WB_LOTE
      ANT_Ctb->ANTDT_DESE := SWB->WB_DT_DESE
      ANT_Ctb->ANTDT_PAG  := SWB->WB_DT_PAG
      ANT_Ctb->ANTCOMAG   := SYS->YS_PERC * SWB->WB_COMAG
      ANT_Ctb->ANTRETIDO  := SYS->YS_PERC * SWB->WB_RETIDO
      ANT_Ctb->ANTCORRETO := SWB->WB_CORRETO
      ANT_Ctb->ANTVL_CORR := SYS->YS_PERC * SWB->WB_VL_CORR
      ANT_Ctb->ANTDESPESA := SYS->YS_PERC * SWB->WB_DESPESA
      ANT_Ctb->ANTFORMPAG := SWB->WB_FORMPAG
      ANT_Ctb->ANTIDENTCT := cIdentCT
      ANT_Ctb->ANTFOBMOE  := SYS->YS_PERC * SWB->WB_FOBMOE
      ANT_Ctb->ANTTRANS   := '2'    // Nao transferido      
      ANT_Ctb->ANTMOEDA   := SW9->W9_MOE_FOB
      ANT_Ctb->ANTSEQ     := SWB->WB_LINHA
      ANT_Ctb->ANTFORN    := cForn   
      
	  If lPagAnt
		 ANT_Ctb->ANTORIGEM   := "PR"		  
	  Endif
      IF SA6->(DBSEEK(xFilial()+SWB->WB_BANCO+SWB->WB_AGENCIA))
         ANT_Ctb->ANTBCO_CON := SA6->A6_CONTABI
      Endif   

      ANT_Ctb->(MSUNLOCK())      
   Endif
   
   IF  SWB->WB_TIPOREG $ "4/5"  && LAB 28.10.98 Liquid.Futura e Abatimento/Desconto
   ELSE
       IF ASCAN(MTab_HAWB,SWB->WB_HAWB + cIdentCT) = 0  && LAB 26.10.98
          MT_h_ind = MT_h_ind + 1
          MTab_HAWB[MT_h_ind] := SWB->WB_HAWB + cIdentCT
          If !lPagAnt
             MTabVlr_H[MT_h_ind] := MTabVlr_H[MT_h_ind] + VAL(STR(APD_Ctb->(APDFOBMOE * APDCA_TX),15,2))
          Else
             MTabVlr_H[MT_h_ind] := MTabVlr_H[MT_h_ind] + VAL(STR(ANT_Ctb->(ANTFOBMOE * ANTCA_TX),15,2))
          Endif   
          MTab_CADT[MT_h_ind] := SWB->WB_DT_DESE  //LAB 02/03/2000
          MTab_BCO[MT_h_ind]  := SA6->A6_CONTABI
       ELSE
          Wk_Ind = ASCAN(MTab_HAWB,SWB->WB_HAWB + cIdentCT)                                      
          If lDI100 .OR. !lPagAnt
             MTabVlr_H[Wk_Ind] := MTabVlr_H[Wk_Ind] + VAL(STR(APD_Ctb->(APDFOBMOE * APDCA_TX),15,2))
          Else
             MTabVlr_H[Wk_Ind] := MTabVlr_H[Wk_Ind] + VAL(STR(ANT_Ctb->(ANTFOBMOE * ANTCA_TX),15,2))
          Endif   
       ENDIF
   ENDIF

   CalcTotal( aTotal, If( ldi100 .or. !lPagAnt,"APD100","ANT100"))
   SYS->(dbSkip())
 ENDDO

 IF lEntrou
    SYS->(DBSKIP(-1))
    If lPagAnt .AND. ! lDI100
       ANT_Ctb->(RecLock("ANT_Ctb",.F.))
       ANT_Ctb->ANTFOBMOE :=IV200Acerta( aTotal, indFOBMOE  , ANT_Ctb->ANTFOBMOE , SWB->WB_FOBMOE )
       ANT_Ctb->ANTCOMAG  :=IV200Acerta( aTotal, indCOMAG   , ANT_Ctb->ANTCOMAG  , SWB->WB_COMAG )
       ANT_Ctb->ANTRETIDO :=IV200Acerta( aTotal, indRETIDO  , ANT_Ctb->ANTRETIDO , SWB->WB_RETIDO )
       ANT_Ctb->ANTVL_CORR:=IV200Acerta( aTotal, indVL_CORR , ANT_Ctb->ANTVL_CORR, SWB->WB_VL_CORR )
       ANT_Ctb->ANTDESPESA:=IV200Acerta( aTotal, indDESPESA , ANT_Ctb->ANTDESPESA, SWB->WB_DESPESA )
       ANT_Ctb->(MsUnlock())        
    Else
       APD_Ctb->(RecLock("APD_Ctb",.F.))
       APD_Ctb->APDFOBMOE :=IV200Acerta( aTotal, indFOBMOE  , APD_Ctb->APDFOBMOE , SWB->WB_FOBMOE )
       APD_Ctb->APDCOMAG  :=IV200Acerta( aTotal, indCOMAG   , APD_Ctb->APDCOMAG  , SWB->WB_COMAG )
       APD_Ctb->APDRETIDO :=IV200Acerta( aTotal, indRETIDO  , APD_Ctb->APDRETIDO , SWB->WB_RETIDO )
       APD_Ctb->APDVL_CORR:=IV200Acerta( aTotal, indVL_CORR , APD_Ctb->APDVL_CORR, SWB->WB_VL_CORR )
       APD_Ctb->APDDESPESA:=IV200Acerta( aTotal, indDESPESA , APD_Ctb->APDDESPESA, SWB->WB_DESPESA )
       APD_Ctb->(MsUnlock())
    Endif
    //FSM - 24/10/2012
    IF lAtuDtCont
       SWB->(RECLock("SWB",.F.))
       SWB->WB_CONTAB := dDataBase
       SWB->(MSUnlock())
    ENDIF
 ENDIF
 
 SWB->(DBSKIP())
ENDDO

//Rotina para lancamento de crédito no banco pelo valor total gasto.
//MT_h_ind = 1
//
//DO WHILE .T.
//
//   IF MTab_HAWB[MT_h_ind] = SPACE(28)
//      EXIT
//   ENDIF
//    
//   IF Di_Ctb->(DBSEEK(MTab_HAWB[MT_h_ind]))
//      DBSELECTARE("Di_Ctb")
//
//      REPLACE DIVL_699   WITH MTabVlr_H[MT_h_ind]  ,;
//              DIDT_699   WITH MTab_CADT[MT_h_ind]  ,;
//              DICC_699   WITH MTab_BCO[MT_h_ind]
//   ENDIF
//
//   MT_h_ind += 1
//
//ENDDO  

SWB->(DBSETORDER(1))
SW9->(DBSETORDER(1))

RETURN .T.


*-----------------------------------*
Static FUNCTION Iv200_Grava(PArq)
*-----------------------------------*
Local nTotAntecipado := 0
cFil_SYS:=xFilial("SYS"); nTotal:=0; lEntrou :=.f.; dData_Ven := AVCtod(""); MGrava := .T.
If lExisteECF
   ECF->(DBSETORDER(2))
Endif          
nOrdemSWB := SWB->(IndexOrd())
SWB->(DBSETORDER(1))


IF PArq == "1"
   
   SYS->(DBSETORDER(1))  //YS_FILIAL+YS_TPMODU+YS_TIPO+YS_HAWB+YS_FORN+YS_FORLOJ+YS_MOEDA+YS_INVOICE+YS_CC
   
   //GFP - 08/11/2011 - Tratamento Loja
   If EICLOJA()
      SYS->(dbSeek(cFil_SYS+"I"+TIPO_INVOICE+SW9->W9_HAWB+SW9->W9_FORN+SW9->W9_FORLOJ+SW9->W9_MOE_FOB+SW9->W9_INVOICE)) 
   Else
      SYS->(dbSeek(cFil_SYS+"I"+TIPO_INVOICE+SW9->W9_HAWB+SW9->W9_FORN+SW9->W9_MOE_FOB+SW9->W9_INVOICE))
   EndIf
   
   DO WHILE SYS->(!EOF()) .AND. SYS->YS_FILIAL==cFil_SYS .AND. SYS->YS_TPMODU == "I" .AND. SYS->YS_TIPO+SYS->YS_HAWB+SYS->YS_FORN+SYS->YS_MOEDA+SYS->YS_INVOICE==TIPO_INVOICE+SW9->W9_HAWB+SW9->W9_FORN+SW9->W9_MOE_FOB+SW9->W9_INVOICE
      lEntrou := .T.
      cIdentCT := SYS->YS_CC
      nTotAntecipado := 0
      TPagto := SPACE(01)
      TAmostra := "N"
//    DO CASE
//       CASE SW2->W2_DIAS_PAG == -1
//            TPagto := "1"
//       CASE SW2->W2_COND_PAG == "35416"
//            TAmostra := "S"
//       OTHERWISE
//            TPagto := "2"
//    ENDCASE

      dData_Ven := AVCtod("")
      SWB->(dbSeek(xFilial()+SW9->W9_HAWB+"D"))
      Do While SWB->(!EOF()) .And. SWB->WB_FILIAL == xFilial("SWB") .And.;
               SWB->WB_HAWB == SW9->W9_HAWB                                   
          If SWB->WB_INVOICE == SW9->W9_INVOICE .And. SWB->WB_TIPOREG=="1"
                nTotAntecipado += SWB->WB_PGTANT
                If lExisteECF .and. (ECF->(DBSEEK(cFilECF+"IMPORT"+SW9->W9_FORN+SWB->WB_INVOICE+AVKEY(SYS->YS_CC,"ECF_IDENTC")+"608"+SWB->WB_LINHA+"PR")) .Or. !Empty(SWB->WB_DT_DESE) .AND. !Empty(GetDt("INICIO")) .AND. SWB->WB_DT_DESE < GetDt("INICIO")) // Nick 09/10/06 //FSM - 06/12/2012
                   nTotAntecipado += SWB->WB_FOBMOE
                EndIf
             If SWB->WB_FOBMOE # 0
                dData_Ven := SWB->WB_DT_VEN
             EndIf
          Endif
          SWB->(dbSkip())
      Enddo 
      
      nTotSYS := SYS->YS_PERC*(SW9->(W9_FOB_TOT + W9_INLAND+W9_PACKING-W9_DESCONTO+W9_FRETEINT)-nTotAntecipado)
      If nTotSYS > 0    
         DBSELECTAREA("IV_Ctb")
         IV_Ctb->(RecLock("IV_Ctb",.T.)) // inclui registro e aloca.
         
         
         REPLACE IVINVOICE WITH SW9->W9_INVOICE  ,;
                 IVDT_EMIS WITH GetDt("INICIO")  ,; //SW6->W6_DT_EMB   ,; //FSM - 11/08/2012
                 IVFORN    WITH SW9->W9_FORN     ,;
                 IVNOM_FOR WITH SW9->W9_NOM_FOR  ,;
                 IVMOE_FOB WITH SW9->W9_MOE_FOB  ,;
                 IVHAWB    WITH SW8->W8_HAWB    ,;
                 IVFOB_TOT WITH nTotSys,; //SYS->YS_PERC*SW9->(W9_FOB_TOT + W9_INLAND+W9_PACKING-W9_DESCONTO+W9_FRETEINT) ,;
                 IVCD_PGTO WITH "2"                  ,;   && pagto com prazo
                 IVCT_D    WITH "T"                  ,;   && LAB 17.06.98 transito
                 IV_AMOST  WITH TAmostra,;
                 IVIDENTCT WITH cIdentCT,;
                 IVDT_VEN  WITH dData_Ven

                 nTotal := nTotal+IV_Ctb->IVFOB_TOT
                 MSUNLOCK()                        
       EndIf
       SYS->(DBSKIP())
   ENDDO

   IF lEntrou .AND. nTotal # 0 .and. nTotal #(SW9->(W9_FOB_TOT+W9_INLAND+W9_PACKING-W9_DESCONTO+W9_OUTDESP+IF(W9_FREINC='1',0,W9_FRETEINT))-nTotAntecipado)
      SYS->(DBSKIP(-1))
      nTotal :=  nTotal-IV_Ctb->IVFOB_TOT
      IV_Ctb->(RecLock("DI_Ctb",.F.))
      //IV_Ctb->IVFOB_TOT := (SW9->(W9_FOB_TOT+W9_INLAND+W9_PACKING-W9_DESCONTO+W9_FRETEINT)-nTotAntecipado)-nTotal
      IV_Ctb->IVFOB_TOT := (SW9->(W9_FOB_TOT+W9_INLAND+W9_PACKING-W9_DESCONTO+W9_OUTDESP+IF(W9_FREINC='1',0,W9_FRETEINT))-nTotAntecipado)-nTotal
      IV_Ctb->(MsUnlock())
   ENDIF

ENDIF

IF PArq == "2"

   MfreteInt := 0
   IF MPrimeiro
      MfreteInt := SW9->(W9_INLAND+W9_PACKING-W9_DESCONTO+W9_OUTDESP+IF(W9_FREINC='1',0,W9_FRETEINT)) / SW8->W8_QTDE  && rateio frete intl so'no 1 item
      MPrimeiro := .F.
   ENDIF

// If (SW9->(W9_FOB_TOT+W9_INLAND+W9_PACKING-W9_DESCONTO+W9_OUTDESP+IF(W9_FREINC='1',0,W9_FRETEINT))-nTotAntecipado) > 0
   RecLock("IVH_Ctb",.T.)

   REPLACE IVHHAWB      WITH  SW8->W8_HAWB     ,;
           IVHFORN      WITH  SW8->W8_FORN     ,;
           IVHINVOICE   WITH  SW8->W8_INVOICE  ,;
           IVHCC        WITH  SW8->W8_CC       ,;
           IVHSI_NUM    WITH  SW8->W8_SI_NUM   ,;
           IVHFABR      WITH  SW8->W8_FABR     ,;
           IVHREG       WITH  SW8->W8_REG      ,;
           IVHCOD_I     WITH  SW8->W8_COD_I    ,;
           IVHQTDE      WITH  SW8->W8_QTDE     ,;
           IVHPRECO     WITH  SW8->W8_PRECO + MfreteInt ,;
           IVHPO_NUM    WITH  SW8->W8_PO_NUM ,;
           IVHIDENTCT   WITH  cIdentCT

   MSUNLOCK()
// EndIf
ENDIF
If lExisteECF
   ECF->(DBSETORDER(1))
Endif   
SWB->(DBSETORDER(nOrdemSWB))
RETURN .T.

*----------------------------------------------------------------------------*
STATIC FUNCTION IV200B_BusDes
*----------------------------------------------------------------------------*
LOCAL cFilSWD
IF !SWD->(DBSEEK((cFilSWD:=xFilial("SWD"))+SW6->W6_HAWB))

    Mvl_ii    := Mvl_icms  := Mdesp_gi  := Mvl_aport := Mvl_702   := Mvl_disis := 0
    Mvl_ipi   := Micms_c   := Mdesp_cl  := Mvl_aaer  := Mvl_703   := Mvl_LI    := 0
    Mvl_desp  := Mvl_arm   := Mvl_frete := Mvl_adap  := Mvl_509   := 0
    Mvl_dci   := Mvl_dap   := Mfrete_ro := Mvl_701   := Mvl_NFT   := 0
    Mcc_ii    := SPACE(10)    && LAB 20.01.99
    Mcc_ipi   := SPACE(10)
    Mcc_icms  := SPACE(10)
    Mvl_totdesp := 0

    Return .F.
ENDIF

DO WHILE SWD->WD_FILIAL == cFilSWD      .AND.;
         SWD->WD_HAWB   == SW6->W6_HAWB .AND.;
         SWD->(!EOF())


// IF SWD->WD_DESPESA $ "101/102/103/901/902/903"  && FOB/FRETE/SEGURO/AD.DESP.
// IF SWD->WD_DESPESA $ ""  && NÃO CONTABILIZA NEHUMA DESPESA PARA 3M.
      SWD->(DBSKIP())
      LOOP
// ENDIF

   DO  CASE

       CASE  SWD->WD_DESPESA = "203" .and. SWD->WD_BASEADI $ cSim  && icms
             Mvl_icms  := Mvl_icms + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA = "203" .and. SWD->WD_BASEADI $ (cNao+" ")  && icms
             Micms_c   := Micms_c  + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA $ "416/436/441/442/504" .and. SWD->WD_BASEADI $ cSim   && multas
             Mvl_arm   := Mvl_arm  + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA $ "416/436/441/442/504" .and. SWD->WD_BASEADI $ (cNao+" ")   && multas
             Mvl_dap   := Mvl_dap  + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA = "417" .and. SWD->WD_BASEADI $ cSim   && icms s/ multas
             Mdesp_gi  := Mdesp_gi  + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA = "417" .and. SWD->WD_BASEADI $ (cNao+" ")   && icms s/ multas
             Mdesp_cl  := Mdesp_cl  + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
//     CASE  SWD->WD_DESPESA $ "406/414/456/501"    && transporte interno LAB 01.06.98
//           Mfrete_ro := Mfrete_ro + SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA $ "502/501"            && solic. via fax     LAB 01.06.98
             Mfrete_ro := Mfrete_ro + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA = "509"                && solic. via fax     LAB 01.06.98
             Mvl_509   := Mvl_509   + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA = "402"    && armazenagem portuaria
             Mvl_aport := Mvl_aport + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA $ "425/433"    && armazenagem aerea
             Mvl_aaer  := Mvl_aaer  + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA $ "431/451"    && armazenagem dap e multiterminais
             Mvl_adap  := Mvl_adap  + SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA = "201"    && i.i.
             Mvl_ii    := Mvl_ii    + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA = "202"    && i.p.i.
             Mvl_ipi   := Mvl_ipi   + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA $ "701/711"    && var.cambial + compl. FOB
             Mvl_701   := Mvl_701   + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA $ "702/712"    && var.cambial + compl. FRETE
             Mvl_702   := Mvl_702   + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA $ "703/713"    && var.cambial + compl. SEGURO
             Mvl_703   := Mvl_703   + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA = "510"    && LAB 08.01.99 D.I. no siscomex
             Mvl_disis := Mvl_disis + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_DESPESA = "511"    && LAB 22.06.99 L.I.
             Mvl_LI    := Mvl_LI    + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R
       CASE  SWD->WD_BASEADI $ cSim
             Mvl_desp  := Mvl_desp  + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R             
       OTHERWISE
             Mvl_dci   := Mvl_dci   + SWD->WD_VALOR_R
             Mvl_totdesp += SWD->WD_VALOR_R             
   ENDCASE

   IF SA6->(DBSEEK(xFilial("SA6")+SWD->WD_BANCO+SWD->WD_AGENCIA))   && LAB 20.01.99
      DO  CASE  
          CASE  SWD->WD_DESPESA = "201"    && i.i.
                Mcc_ii   := SA6->A6_CONTABI
          CASE  SWD->WD_DESPESA = "202"    && i.p.i.
                Mcc_ipi  := SA6->A6_CONTABI
          CASE  SWD->WD_DESPESA = "203"    && icms
                Mcc_icms := SA6->A6_CONTABI
      ENDCASE
   ENDIF

   SWD->(DBSKIP())
ENDDO
/*LOCAL cFil_SWD
cFil_SWD:=xFilial()
IF !SWD->(dbSeek(cFil_SWD+SW6->W6_HAWB))
   MDespach = 0
   MOutras  = 0
   MDevoluc = 0
   MComplem = 0
   MFret_Pg = 0
   Return .T.
ENDIF

DO WHILE SWD->WD_HAWB == SW6->W6_HAWB .AND. .NOT. SWD->(EOF()) .AND. SWD->WD_FILIAL == cFil_SWD

   IF SWD->WD_DESPESA $ "101/103/406/408"  && FOB/SEGURO/TRANSP.INTERNO
      SWD->(DBSKIP())
      LOOP
   ENDIF

   DO CASE

      CASE SWD->WD_DESPESA = "901"

      CASE SWD->WD_DESPESA = "102"   && frete
           MFret_Pg := MFret_Pg + SWD->WD_VALOR_R

      CASE SWD->WD_DESPESA = "902"
           MComplem := MComplem + SWD->WD_VALOR_R

      CASE SWD->WD_DESPESA = "903"
           MDevoluc := MDevoluc + SWD->WD_VALOR_R

      CASE SWD->WD_BASEADI = "N" .AND. SWD->WD_DESPESA = "203"
           MDesp_Gi := MDesp_Gi + SWD->WD_VALOR_R

      CASE SWD->WD_BASEADI $ cSim
           MDespach := MDespach + SWD->WD_VALOR_R

      OTHERWISE
            MOutras  := MOutras  + SWD->WD_VALOR_R

   ENDCASE

   SWD->(DBSKIP())
ENDDO*/

RETURN


*-------------------------------------*
Static Function CalcTotal(aTotal,cArq)
*-------------------------------------*
cArq := UPPER(ALLTRIM(cArq))
IF cArq == "DI100"
   aTotal[indDESP_GI  ] := aTotal[indDESP_GI  ] +DI_Ctb->DIDESP_GI
   aTotal[indVL_FRETE ] := aTotal[indVL_FRETE ] +DI_Ctb->DIVL_FRETE
   aTotal[indVL_USSEG ] := aTotal[indVL_USSEG ] +DI_Ctb->DIVL_USSEG
   aTotal[indVL_II    ] := aTotal[indVL_II    ] +DI_Ctb->DIVL_II
   aTotal[indVL_IPI   ] := aTotal[indVL_IPI   ] +DI_Ctb->DIVL_IPI
   aTotal[indVL_ICMS  ] := aTotal[indVL_ICMS  ] +DI_Ctb->DIVL_ICMS
   aTotal[indVL_ARM   ] := aTotal[indVL_ARM   ] +DI_Ctb->DIVL_ARM
   aTotal[indICMS_C   ] := aTotal[indICMS_C   ] +DI_Ctb->DIICMS_C
   aTotal[indVL_DAP   ] := aTotal[indVL_DAP   ] +DI_Ctb->DIVL_DAP
   aTotal[indVL_DESP  ] := aTotal[indVL_DESP  ] +DI_Ctb->DIVL_DESP
   aTotal[indVL_DCI   ] := aTotal[indVL_DCI   ] +DI_Ctb->DIVL_DCI
   aTotal[indDESP_CL  ] := aTotal[indDESP_CL  ] +DI_Ctb->DIDESP_CL
   aTotal[indFRETE_RO ] := aTotal[indFRETE_RO ] +DI_Ctb->DIFRETE_RO
   aTotal[indVL_APORT ] := aTotal[indVL_APORT ] +DI_Ctb->DIVL_APORT
   aTotal[indVL_AAER  ] := aTotal[indVL_AAER  ] +DI_Ctb->DIVL_AAER
   aTotal[indVL_ADAP  ] := aTotal[indVL_ADAP  ] +DI_Ctb->DIVL_ADAP
   aTotal[indVL_701   ] := aTotal[indVL_701   ] +DI_Ctb->DIVL_701
   aTotal[indVL_509   ] := aTotal[indVL_509   ] +DI_Ctb->DIVL_509
   aTotal[indVL_NFT   ] := aTotal[indVL_NFT   ] +DI_Ctb->DIVL_NFT
   aTotal[indFOB_TOT  ] := aTotal[indFOB_TOT  ] +DI_Ctb->DIFOB_TOT
ELSEIF cArq == "APD100"
   aTotal[indFOBMOE   ] := aTotal[indFOBMOE   ] +APD_Ctb->APDFOBMOE
   aTotal[indCOMAG    ] := aTotal[indCOMAG    ] +APD_Ctb->APDCOMAG
   aTotal[indRETIDO   ] := aTotal[indRETIDO   ] +APD_Ctb->APDRETIDO
   aTotal[indVL_CORR  ] := aTotal[indVL_CORR  ] +APD_Ctb->APDVL_CORR
   aTotal[indDESPESA  ] := aTotal[indDESPESA  ] +APD_Ctb->APDDESPESA
ELSEIF cArq == "ANT100"
   aTotal[indFOBMOE   ] := aTotal[indFOBMOE   ] +ANT_Ctb->ANTFOBMOE
   aTotal[indCOMAG    ] := aTotal[indCOMAG    ] +ANT_Ctb->ANTCOMAG
   aTotal[indRETIDO   ] := aTotal[indRETIDO   ] +ANT_Ctb->ANTRETIDO
   aTotal[indVL_CORR  ] := aTotal[indVL_CORR  ] +ANT_Ctb->ANTVL_CORR
   aTotal[indDESPESA  ] := aTotal[indDESPESA  ] +ANT_Ctb->ANTDESPESA
ELSEIF cArq == "ANTPGT0"
   aTotal[indFOBMOE   ] := aTotal[indFOBMOE   ] +ECF->ECF_VL_MOE
ENDIF

Return .T.

*--------------------------------------------------------*
Static Function IV200Acerta(aTotal,nIndice,nCampo,nValor)
*--------------------------------------------------------*
nCampoAux:=0
IF aTotal[nIndice] #nValor
   aTotal[nIndice] := aTotal[nIndice]-nCampo
   nCampoAux:=nValor-aTotal[nIndice]
   aTotal[nIndice] := aTotal[nIndice] +nCampoAux
Else
   nCampoAux:=nCampo
ENDIF

Return nCampoAux

*---------------------------*
User Function Ecoiv20b() 
*---------------------------*

lRet20B:=.T.

If FILE(cPathCont+("DI100.DBF"))
   FErase(cPathCont+("DI100.DBF"))
EndIf				  

If FILE(cPathCont+("IV100.DBF"))
   FErase(cPathCont+("IV100.DBF"))
EndIf				  

If FILE(cPathCont+("IVH100.DBF"))
   FErase(cPathCont+("IVH100.DBF"))
EndIf				  

If FILE(cPathCont+("APD100.DBF"))
   FErase(cPathCont+("APD100.DBF"))
EndIf				  
                                   
If lExisteECF
   If FILE(cPathCont+("ANT100.DBF"))
      FErase(cPathCont+("ANT100.DBF"))
   EndIf				  
Endif   

aDBF_DI := {}
AADD(aDBF_DI,{"DIDESP_GI"  ,"N", 15,2})
AADD(aDBF_DI,{"DIDI_NUM"   ,AVSX3("W6_DI_NUM",2), 10,0})
AADD(aDBF_DI,{"DIDT"       ,"D",  8,0})
AADD(aDBF_DI,{"DILOTE"     ,"C",  6,0})
AADD(aDBF_DI,{"DIHAWB"     ,"C", 17,0})
AADD(aDBF_DI,{"DIDESP"     ,"C",  3,0})
AADD(aDBF_DI,{"DINF_ENT"   ,"C", 20,0})
AADD(aDBF_DI,{"DIDT_NF"    ,"D",  8,0})
AADD(aDBF_DI,{"DIVL_NF"    ,"N", 15,2})
AADD(aDBF_DI,{"DIDT_DESEM" ,"D",  8,0})
AADD(aDBF_DI,{"DIVL_FRETE" ,"N", 15,2})
AADD(aDBF_DI,{"DINF_COMP"  ,"C",  6,0})
AADD(aDBF_DI,{"DIDT_NFC"   ,"D",  8,0})
AADD(aDBF_DI,{"DIVL_NFC"   ,"N", 15,2})
AADD(aDBF_DI,{"DIVL_USSEG" ,"N", 15,2})
AADD(aDBF_DI,{"DITX_FOB"   ,"N", 15,8})
AADD(aDBF_DI,{"DIIDENTCT"  ,"C", 10,0})
AADD(aDBF_DI,{"DIVL_II"    ,"N", 15,2})
AADD(aDBF_DI,{"DIVL_IPI"   ,"N", 15,2})
AADD(aDBF_DI,{"DIVL_ICMS"  ,"N", 15,2})
AADD(aDBF_DI,{"DIVL_ARM"   ,"N", 15,2})
AADD(aDBF_DI,{"DIDT_ARMZ"  ,"D",  8,0})
AADD(aDBF_DI,{"DIICMS_C"   ,"N", 15,2})
AADD(aDBF_DI,{"DIVL_DAP"   ,"N", 15,2})
AADD(aDBF_DI,{"DIVL_DESP"  ,"N", 15,2})
AADD(aDBF_DI,{"DIDTP_DESP" ,"D",  8,0})
AADD(aDBF_DI,{"DIVL_DCI"   ,"N", 15,2})
AADD(aDBF_DI,{"DIDT_DCI"   ,"D",  8,0})
AADD(aDBF_DI,{"DIDTP_FRE"  ,"D",  8,0})
AADD(aDBF_DI,{"DIDESP_CL"  ,"N", 15,2})
AADD(aDBF_DI,{"DIFRETE_RO" ,"N", 15,2})
AADD(aDBF_DI,{"DIDTP_ROD"  ,"D",  8,0})
AADD(aDBF_DI,{"DISUB_SET"  ,"C", 10,0})
AADD(aDBF_DI,{"DIVL_APORT" ,"N", 15,2})
AADD(aDBF_DI,{"DIVL_AAER"  ,"N", 15,2})
AADD(aDBF_DI,{"DIVL_ADAP"  ,"N", 15,2})
AADD(aDBF_DI,{"DIVL_701"   ,"N", 15,2})
AADD(aDBF_DI,{"DIVL_702"   ,"N", 15,2})     && LAB 02.05.00
AADD(aDBF_DI,{"DIVL_509"   ,"N", 15,2})
AADD(aDBF_DI,{"DIVL_NFT"   ,"N", 15,2})
AADD(aDBF_DI,{"DICHEG"     ,"D",  8,0})
AADD(aDBF_DI,{"DIDT_HAWB"  ,"D",  8,0})
AADD(aDBF_DI,{"DIOBS"      ,"C",  6,0})
AADD(aDBF_DI,{"DIMAWB"     ,"C", 11,0})
AADD(aDBF_DI,{"DIAGENTE"   ,"C",  3,0})
AADD(aDBF_DI,{"DIDTRECDOC" ,"D",  8,0})
AADD(aDBF_DI,{"DIDT_ENTR"  ,"D",  8,0})
AADD(aDBF_DI,{"DIDT_EMB"   ,"D",  8,0})
AADD(aDBF_DI,{"DIINVOICE"  ,"C", 15,0})
AADD(aDBF_DI,{"DILOCAL"    ,"C",  3,0})
AADD(aDBF_DI,{"DIREF_DESP" ,"C", 15,0})
AADD(aDBF_DI,{"DIPROB_DI"  ,"C",  1,0})
AADD(aDBF_DI,{"DIFOB_TOT"  ,"N", 15,2})
AADD(aDBF_DI,{"DIDT_ENCE"  ,"D",  8,0})
AADD(aDBF_DI,{"DIVL_702_P" ,"N", 15,2})
AADD(aDBF_DI,{"DICC_ESTOQ" ,"C", 10,0})
AADD(aDBF_DI,{"DIVL_621"   ,"N", 15,2})
AADD(aDBF_DI,{"DIDT_621"   ,"D",  8,0})
AADD(aDBF_DI,{"DICC_621"   ,"C", 20,0})
AADD(aDBF_DI,{"DIVL_623"   ,"N", 15,2})
AADD(aDBF_DI,{"DIDT_623"   ,"D",  8,0})
AADD(aDBF_DI,{"DICC_623"   ,"C", 20,0})
AADD(aDBF_DI,{"DIVL_620"   ,"N", 15,2})
AADD(aDBF_DI,{"DIDT_620"   ,"D",  8,0})
AADD(aDBF_DI,{"DICC_620"   ,"C", 20,0})
AADD(aDBF_DI,{"DIVL_699"   ,"N", 15,2})
AADD(aDBF_DI,{"DIDT_699"   ,"D",  8,0})
AADD(aDBF_DI,{"DICC_699"   ,"C", 20,0})
AADD(aDBF_DI,{"DITX_DIUSD" ,"N", 15,8})
AADD(aDBF_DI,{"DIFORN"     ,"C", 06,0})
AADD(aDBF_DI,{"DIMOEDA"    ,"C", 03,8})

aDBF_IV := {}
AADD(aDBF_IV,{"IVINVOICE"  ,"C", 15,0})
AADD(aDBF_IV,{"IVDT_EMIS"  ,"D",  8,0})
AADD(aDBF_IV,{"IVFORN"     ,"C",  6,0})//N
AADD(aDBF_IV,{"IVNOM_FOR"  ,"C", 20,0})
AADD(aDBF_IV,{"IVMOE_FOB"  ,"C",  3,0})
AADD(aDBF_IV,{"IVFOB_TOT"  ,"N", 13,2})
AADD(aDBF_IV,{"IVHAWB"     ,"C", 17,0})
AADD(aDBF_IV,{"IVCD_PGTO"  ,"C",  1,0})
AADD(aDBF_IV,{"IV_AMOST"   ,"C",  1,0})
AADD(aDBF_IV,{"IVIDENTCT"  ,"C", 10,0})
AADD(aDBF_IV,{"IVCT_D"     ,"C",  1,0})
AADD(aDBF_IV,{"IVDT_VEN"   ,"D",  8,0})

aDBF_IVH := {}  
AADD(aDBF_IVH,{"IVHHAWB"   ,"C", 17,0})
AADD(aDBF_IVH,{"IVHFORN"   ,"C",  6,0})//N AWR
AADD(aDBF_IVH,{"IVHINVOICE","C", 15,0})
AADD(aDBF_IVH,{"IVHCC"     ,"C",  5,0})
AADD(aDBF_IVH,{"IVHSI_NUM" ,"C",  6,0})
AADD(aDBF_IVH,{"IVHFABR"   ,"C",  6,0})
AADD(aDBF_IVH,{"IVHCOD_I"  ,"C", 30,0})
AADD(aDBF_IVH,{"IVHREG"    ,"N",  2,0})
AADD(aDBF_IVH,{"IVHQTDE"   ,"N", 13,3})
AADD(aDBF_IVH,{"IVHPRECO"  ,"N", 18,8})
AADD(aDBF_IVH,{"IVHPO_NUM" ,"C", 15,0})
AADD(aDBF_IVH,{"IVHIDENTCT","C", 10,0})

aDBF_APD := {}  
AADD(aDBF_APD,{"APDHAWB   ","C", 17,0}) 
AADD(aDBF_APD,{"APDCA_DT  ","D",  8,0}) 
AADD(aDBF_APD,{"APDCA_TX  ","N", 15,8}) 
AADD(aDBF_APD,{"APDFOBMOE ","N", 15,4}) 
AADD(aDBF_APD,{"APDTIPOREG","C",  1,0}) 
AADD(aDBF_APD,{"APDDT_CONT","D",  8,0}) 
AADD(aDBF_APD,{"APDINVOICE","C", 15,0}) 
AADD(aDBF_APD,{"APDBCO_CON","C", 10,0}) 
AADD(aDBF_APD,{"APDNUM    ","C", 10,0}) 
AADD(aDBF_APD,{"APDDT     ","D",  8,0}) 
AADD(aDBF_APD,{"APDBANCO  ","C",  AvSX3("A6_COD",3)    ,0}) //FSM - 24/10/2012
AADD(aDBF_APD,{"APDAGENCIA","C",  AvSX3("A6_AGENCIA",3),0}) //FSM - 24/10/2012
AADD(aDBF_APD,{"APDCONTA"  ,"C",  AvSX3("A6_NUMCON",3) ,0}) //FSM - 13/12/2012
AADD(aDBF_APD,{"APDLC_NUM ","C", 10,0}) 
AADD(aDBF_APD,{"APDCA_NUM ","C", 15,0}) 
AADD(aDBF_APD,{"APDDT_VEN ","D",  8,0}) 
AADD(aDBF_APD,{"APDTIPO   ","C", 20,0}) 
AADD(aDBF_APD,{"APDOBS    ","C",  6,0}) 
AADD(aDBF_APD,{"APDNR_ROF ","C",  8,0}) 
AADD(aDBF_APD,{"APDDT_ROF ","D",  8,0}) 
AADD(aDBF_APD,{"APDLIM_BAC","D",  8,0}) 
AADD(aDBF_APD,{"APDDT_DIG ","D",  8,0}) 
AADD(aDBF_APD,{"APDENV_BAC","D",  8,0}) 
AADD(aDBF_APD,{"APDDT_REAL","D",  8,0}) 
AADD(aDBF_APD,{"APDLOTE   ","C",  7,0}) 
AADD(aDBF_APD,{"APDDT_DESE","D",  8,0})
AADD(aDBF_APD,{"APDDT_PAG ","D",  8,0})
AADD(aDBF_APD,{"APDCOMAG  ","N", 15,4})
AADD(aDBF_APD,{"APDRETIDO ","N", 15,4})
AADD(aDBF_APD,{"APDCORRETO","C",  3,0})
AADD(aDBF_APD,{"APDVL_CORR","N", 15,2})
AADD(aDBF_APD,{"APDDESPESA","N", 15,2})
AADD(aDBF_APD,{"APDFORMPAG","C", 20,0})
AADD(aDBF_APD,{"APDIDENTCT","C", 10,0})          
AADD(aDBF_APD,{"APDSEQ"    ,"C", 04,0})    
AADD(aDBF_APD,{"APDFORN"   ,"C", AvSX3("A2_COD",3),0})    //FSM - 24/10/2012
If lExisteECF
   aANT_ANT := {}  
   AADD(aANT_ANT,{"ANTHAWB   ","C", 17,0}) 
   AADD(aANT_ANT,{"ANTCA_DT  ","D",  8,0}) 
   AADD(aANT_ANT,{"ANTCA_TX  ","N", 15,8}) 
   AADD(aANT_ANT,{"ANTFOBMOE ","N", 15,4}) 
   AADD(aANT_ANT,{"ANTTIPOREG","C",  1,0}) 
   AADD(aANT_ANT,{"ANTDT_CONT","D",  8,0}) 
   AADD(aANT_ANT,{"ANTINVOICE","C", 15,0}) 
   AADD(aANT_ANT,{"ANTBCO_CON","C", 10,0}) 
   AADD(aANT_ANT,{"ANTNUM    ","C", 10,0}) 
   AADD(aANT_ANT,{"ANTDT     ","D",  8,0}) 
   AADD(aANT_ANT,{"ANTBANCO  ","C", AvSX3("A6_COD",3)    ,0}) //FSM - 24/10/2012
   AADD(aANT_ANT,{"ANTAGENCIA","C", AvSX3("A6_AGENCIA",3),0}) //FSM - 24/10/2012
   AADD(aANT_ANT,{"ANTCONTA","C", AvSX3("A6_NUMCON",3) ,0}) //FSM - 13/12/2012
   AADD(aANT_ANT,{"ANTLC_NUM ","C", 10,0}) 
   AADD(aANT_ANT,{"ANTCA_NUM ","C", 15,0}) 
   AADD(aANT_ANT,{"ANTDT_VEN ","D",  8,0}) 
   AADD(aANT_ANT,{"ANTTIPO   ","C", 20,0}) 
   AADD(aANT_ANT,{"ANTOBS    ","C",  6,0}) 
   AADD(aANT_ANT,{"ANTNR_ROF ","C",  8,0}) 
   AADD(aANT_ANT,{"ANTDT_ROF ","D",  8,0}) 
   AADD(aANT_ANT,{"ANTLIM_BAC","D",  8,0}) 
   AADD(aANT_ANT,{"ANTDT_DIG ","D",  8,0}) 
   AADD(aANT_ANT,{"ANTENV_BAC","D",  8,0}) 
   AADD(aANT_ANT,{"ANTDT_REAL","D",  8,0}) 
   AADD(aANT_ANT,{"ANTLOTE   ","C",  7,0}) 
   AADD(aANT_ANT,{"ANTDT_DESE","D",  8,0})
   AADD(aANT_ANT,{"ANTDT_PAG ","D",  8,0})
   AADD(aANT_ANT,{"ANTCOMAG  ","N", 15,4})
   AADD(aANT_ANT,{"ANTRETIDO ","N", 15,4})
   AADD(aANT_ANT,{"ANTCORRETO","C",  3,0})
   AADD(aANT_ANT,{"ANTVL_CORR","N", 15,2})
   AADD(aANT_ANT,{"ANTDESPESA","N", 15,2})
   AADD(aANT_ANT,{"ANTFORMPAG","C", 20,0})
   AADD(aANT_ANT,{"ANTIDENTCT","C", 10,0})          
   AADD(aANT_ANT,{"ANTTRANS"  ,"C", 01,0})          
   AADD(aANT_ANT,{"ANTMOEDA"  ,"C", 03,0})          
   AADD(aANT_ANT,{"ANTORIGEM" ,"C", 02,0})             
   AADD(aANT_ANT,{"ANTFORN"   ,"C", AvSX3("A2_COD",3),0})    //FSM - 24/10/2012
   AADD(aANT_ANT,{"ANTSEQ"    ,"C", 04,0})    
Endif

Do While .T.

   FErase(cPathCont+"DI100"+OrdBagExt())
   DBCREATE(cPathCont+"DI100",aDBF_DI)
   DBUSEAREA(.T.,,cPathCont+"DI100","Di_Ctb", .F.)
   IF ! USED()
      IVMsgAlert(STR0013+cPathCont+"DI100",STR0014) //"Não foi possivel abrir o arquivo "###"Atenção"
      lRet20B:=.F.
   ENDIF
   IndRegua("DI_Ctb",cPathCont+"DI100"+OrdBagExt(),"DIHAWB")

   FErase(cPathCont+"IVH100"+OrdBagExt())
   DBCREATE(cPathCont+"IVH100",aDBF_IVH)
   DBUSEAREA(.T.,,cPathCont+"IVH100","IVH_Ctb", .F.)
   IF ! USED()
      DI_Ctb->(DbCloseArea())
      IVMsgAlert(STR0013+cPathCont+"IVH100",STR0014) //"Não foi possivel abrir o arquivo "###"Atenção"
      lRet20B:=.F.
   ENDIF
// IndRegua("IVH_Ctb",cPathCont+("IVH100"+OrdBagExt()),"IVHINVOICE+IVHIDENTCT")


   FErase(cPathCont+"IV100"+OrdBagExt())
   FErase(cPathCont+"IV102"+OrdBagExt())
   DBCREATE(cPathCont+"IV100",aDBF_IV)
   DBUSEAREA(.T.,,cPathCont+"IV100","IV_Ctb", .F.)
   IF ! USED()
      DI_Ctb->(DbCloseArea())
      IVH_Ctb->(DbCloseArea())
      IVMsgAlert(STR0013+cPathCont+"IV100",STR0014) //"Não foi possivel abrir o arquivo "###"Atenção"
      lRet20B:=.F.
   ENDIF
   IndRegua("IV_Ctb",cPathCont+("IV100"+OrdBagExt()),"IVINVOICE+IVIDENTCT")
   IndRegua("IV_Ctb",cPathCont+("IV102"+OrdBagExt()),"IVINVOICE+IVFORN+IVIDENTCT")  
                                                 
   SET INDEX TO (cPathCont+("IV100"+OrdBagExt())),(cPathCont+("IV102"+OrdBagExt()))         

   DBCREATE(cPathCont+"APD100",aDBF_APD)
   DBUSEAREA(.T.,,cPathCont+"APD100","APD_Ctb", .F.)
   IF ! USED()
      DI_Ctb->(DbCloseArea())
      IVH_Ctb->(DbCloseArea())
      IV_Ctb->(DbCloseArea())
      IVMsgAlert(STR0013+cPathCont+"APD100",STR0014) //"Não foi possivel abrir o arquivo "###"Atenção"
      lRet20B:=.F.
   ENDIF
   IndRegua("APD_Ctb",cPathCont+("APD100"+OrdBagExt()),"APDHAWB+APDTIPOREG+APDINVOICE")
   
   
   If lExisteECF
      DBCREATE(cPathCont+"ANT100",aANT_ANT)
      DBUSEAREA(.T.,,cPathCont+"ANT100","ANT_Ctb", .F.)
      IF ! USED()
         DI_Ctb->(DbCloseArea())
         IVH_Ctb->(DbCloseArea())
         IV_Ctb->(DbCloseArea())
         APD_Ctb->(DbCloseArea())
         IVMsgAlert(STR0013+cPathCont+"ANT100",STR0014) //"Não foi possivel abrir o arquivo "###"Atenção"
         lRet20B:=.F.
      ENDIF                                                

      IndRegua("ANT_Ctb",cPathCont+("ANT100"+OrdBagExt()),"ANTFORN+ANTINVOICE+ANTIDENTCT")
   
   Endif
   
   EXIT
EndDo  
lAberto:=lRet20B

Return(lRet20B)   

*----------------------------------------------*
USER FUNCTION IV_VALID(cCampo)
*----------------------------------------------*
dIniEncerra := mv_par01
dFimEncerra := mv_par02
cImport1    := mv_par03
cImport2    := mv_par04
cImport3    := mv_par05
cImport4    := mv_par06

IF cCampo == "*" .Or. cCampo == "DTINI"
   IF dIniEncerra > dFimEncerra
      AvE_Msg( STR0015,STR0012) //"DATA INICIAL MAIOR QUE A DATA FINAL"###"Informação"
      RETURN IF(cCampo=="*",.F.,.T.)
   ENDIF
ENDIF

IF cCampo == "*" .Or. cCampo== "DTFIM"
   IF EMPTY( dFimEncerra )
      mv_par02 :=  dFimEncerra := AVCTOD( '31/12/99' )
   ENDIF

   IF dIniEncerra > dFimEncerra
      AvE_Msg( STR0015,STR0012) //"DATA INICIAL MAIOR QUE A DATA FINAL"###"Informação"
      RETURN IF(cCampo=="*",.F.,.T.)
   ENDIF
ENDIF

IF cCampo == "*" .Or. cCampo== "IMPOR1"
   IF !EMPTY(cImport1)
      IF  ! SYT->(DbSeek(xFilial()+cImport1))
          AvE_Msg(STR0016,STR0012) //"IMPORTADOR NAO CADASTRADO"###"Informação"
          RETURN IF(cCampo=="*",.F.,.T.)
      ENDIF
   ENDIF
ENDIF

IF cCampo == "*" .Or. cCampo== "IMPOR2"
   IF !EMPTY(cImport2)
      IF ! SYT->(DbSeek(xFilial()+cImport2))
         AvE_Msg(STR0016,"Informação") //"IMPORTADOR NAO CADASTRADO"
         RETURN IF(cCampo=="*",.F.,.T.)
      ENDIF
   ENDIF
ENDIF

IF cCampo == "*" .Or. cCampo== "IMPOR3"
   IF !EMPTY(cImport3)
      IF ! SYT->(DbSeek(xFilial()+cImport3))
         AvE_Msg(STR0016,STR0012) //"IMPORTADOR NAO CADASTRADO"###"Informação"
         RETURN IF(cCampo=="*",.F.,.T.)
      ENDIF
   ENDIF
ENDIF

IF cCampo == "*" .Or. cCampo== "IMPOR4"
   IF !EMPTY(cImport4)
      IF ! SYT->(DbSeek(xFilial()+cImport4))
         AvE_Msg(STR0016,STR0012) //"IMPORTADOR NAO CADASTRADO"###"Informação"
         RETURN IF(cCampo=="*",.F.,.T.)
      ENDIF
   ENDIF
ENDIF

IF cCampo == "*" .And. Empty(cImport1+cImport2+cImport3+cImport4)
   AvE_Msg(AnsiToOem(STR0017),STR0012) //"Não há importadores selecionado"###"Informação"
   RETURN (.F.)
ENDIF

RETURN .T.

*------------------------------*
Static Function IV20GRVDI_Ctb()
*------------------------------*         
Local nOrdemSWB := SWB->(IndexOrd()), nRecNoSWB := SWB->(Recno()) , ;
      nOrdSW9   := SW9->(IndexOrd()), nRecnoSW9 := SW9->(Recno()), aFornMoeda := {}, nPos := 0         

Local nTotAntecipado := 0

Local dDtFim := GetDt("FIM") //FSM - 24/10/2012

      Mvl_ii := Mvl_ipi := Mvl_desp := Mvl_701 := Mvl_702 := Mvl_703 := 0
      Mvl_dci := Mvl_icms := Micms_c := Mvl_arm := Mvl_dap := Mdesp_gi := 0
      Mdesp_cl := Mvl_frete := Mfrete_ro := Mvl_aport := Mvl_aaer := 0
      Mvl_adap := Mvl_509 := Mvl_usseg := Mvl_NFT := Mvl_disis := Mvl_LI := 0
      Mvl_totdesp := 0

      MDespach = 0
      MOutras  = 0
      MDevoluc = 0
      MComplem = 0
      MFret_Pg = 0

      IV200B_BusDes()  

//    Mvl_usseg := VAL(STR(IF(SW6->W6_SEGMOEDA=="US$",SW6->(W6_VL_USSEG * W6_TX_US_DI),SW6->(W6_VL_USSEG * W6_TX_FOB)),15,2))
//    Mvl_FRETE := IF(SW6->W6_FRETEIN # 0,0,SW6->W6_VL_FRETE*SW6->W6_TX_FRETE)
//    Mdesp_gi  := Mdesp_gi - Mvl_usseg  && SOMENTE PARA CIBIE LAB 02.08.99

      dbSelectArea("DI_Ctb")
      TDt_Arm := SW6->W6_DT   && DATA DA D.I. COMO DATA DOS PAGTOS

      SW7->(dbSeek(xFilial()+SW6->W6_HAWB))
      SW0->(dbSeek(xFilial()+SW7->W7_CC+SW7->W7_SI_NUM))
      SW1->(dbSeek(xFilial()+SW7->W7_CC+SW7->W7_SI_NUM+SW7->W7_COD_I))
      
      cSUB_SET   := SPACE(10)
      cCC_CODIGO := SPACE(10)
      cW1_CLASS  := SW1->W1_CLASS
//    DO CASE
//       CASE SW1->W1_CLASS == "1" .OR. SW1->W1_CLASS == "5"
//            cSUB_SET   := SPACE(10)
//            cCC_CODIGO := " "                             && LAB 14.06.99
//       CASE SW1->W1_CLASS == "2" .OR. SW1->W1_CLASS == "4"
//            cSUB_SET   := SW0->W0_DAI
//            cCC_CODIGO := " "                             && LAB 14.06.99
//       CASE SW1->W1_CLASS == "3"
//            cSUB_SET   := SPACE(10)
//            cCC_CODIGO := SPACE(05)
//    ENDCASE

      // Agrupa por Invoice e Fornecedor      
      SW9->(DbSetOrder(3))
      SW9->( DBSEEK(xFilial()+SW6->W6_HAWB) )
      Do While !Sw9->(Eof()) .And. SW9->W9_FILIAL = SW9->(xFilial()) .And. SW6->W6_HAWB == SW9->W9_HAWB //FSM - 12/12/2012
         
         nPos := AScan(aFornMoeda,{|x| x[1] == SW9->W9_FORN  .AND. x[2] == SW9->W9_MOE_FOB })          
         // Ordem do Array :
         // 1-SW9->W9_FORN / 2-SW9->W9_MOE_FOB / 3-W9_FOB_TOT / 4-W9_INLAND / 5-W9_FRETEINT / 6-W9_PACKING / 7-W9_DESCONTO / 8-W9_TX_FOB  
         
         If nPos > 0
            If SW9->W9_FREINC == "1"
               aFornMoeda[nPos, 3] += SW9->W9_FOB_TOT
               aFornMoeda[nPos, 4] += SW9->W9_INLAND
               aFornMoeda[nPos, 5] += 0
               aFornMoeda[nPos, 6] += SW9->W9_PACKING
               aFornMoeda[nPos, 7] += SW9->W9_DESCONTO
            Else
               aFornMoeda[nPos, 3] += SW9->W9_FOB_TOT
               aFornMoeda[nPos, 4] += SW9->W9_INLAND
               aFornMoeda[nPos, 5] += SW9->W9_FRETEINT
               aFornMoeda[nPos, 6] += SW9->W9_PACKING
               aFornMoeda[nPos, 7] += SW9->W9_DESCONTO               
            Endif
            If !EMPTY(SW9->W9_TX_FOB) .AND. !EMPTY(aFornMoeda[nPos, 8]) .AND. aFornMoeda[nPos, 8] # SW9->W9_TX_FOB 
               // Coloca Mensagem
               // A TX DI PARA O MESMO FORNECEDOR FOR #
            Elseif Empty(aFornMoeda[nPos,8])
               aFornMoeda[nPos,8] := SW9->W9_TX_FOB
            Endif
         Else
            AAdd( aFornMoeda, {SW9->W9_FORN, SW9->W9_MOE_FOB, SW9->W9_FOB_TOT, SW9->W9_INLAND, IF(SW9->W9_FREINC='1',0,SW9->W9_FRETEINT), SW9->W9_PACKING, SW9->W9_DESCONTO, SW9->W9_TX_FOB } )
         Endif   
               
         SW9->(DbSkip())  
      Enddo
      SW9->( DBSEEK(xFilial()+SW6->W6_HAWB) ) //GFC 12/08/04
          
      cFil_SYS:=xFilial("SYS")
      SYS->(DbSeek(cFil_SYS+"I"+TIPO_HOUSE+SW6->W6_HAWB))

      aTotal:={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}      
      lEntrou:= .F.
      If lExisteECF
         ECF->(DBSETORDER(2))
      Endif   
      nOrdemSWB := SWB->(IndexOrd())
      SWB->(DBSETORDER(1))
      DO WHILE SYS->(!EOF()) .AND. SYS->YS_TPMODU == "I" .AND. TIPO_HOUSE+SW6->W6_HAWB == SYS->YS_TIPO+SYS->YS_HAWB .AND. SYS->YS_FILIAL == cFil_SYS
      
         nPos := AScan(aFornMoeda,{|x| x[1] == SYS->YS_FORN  .AND. x[2] == SYS->YS_MOEDA })          
         If nPos = 0
            SYS->(DbSkip())
            Loop
         Endif    

         lEntrou  := .T.
         cIdentCT := SYS->YS_CC
         nTotAntecipado := 0
         nValFob  := 0

            SWB->(dbSeek(xFilial()+SW6->W6_HAWB+"D"))   // Nick 18/05/06
//            SWB->(dbSeek(xFilial()+SW9->W9_HAWB+If(lExisteWBP,"D",""))) 
         Do While SWB->(!EOF()) .And. SWB->WB_FILIAL == xFilial("SWB") .And.;
                  SWB->WB_HAWB == SW9->W9_HAWB
            If SWB->WB_INVOICE == SW9->W9_INVOICE .And. SWB->WB_TIPOREG=="1"
                  nTotAntecipado += SWB->WB_PGTANT
                  If lExisteECF .And. (ECF->(DBSEEK(cFilECF+"IMPORT"+SW9->W9_FORN+SWB->WB_INVOICE+AVKEY(SYS->YS_CC,"ECF_IDENTC")+"608"+SWB->WB_LINHA+"PR")) .Or. !Empty(SWB->WB_DT_DESE) .AND. !Empty(GetDt("INICIO")) .AND. SWB->WB_DT_DESE < GetDt("INICIO")) // Nick 09/10/06 //FSM - 06/12/2012
                     nTotAntecipado += SWB->WB_FOBMOE
                  Endif    
            EndIf
            SWB->(dbSkip())
         Enddo
         //FSM - 24/10/2012
         //IF (! EMPTY(SW6->W6_DT_ENCE) .AND. ;  
         //   (SW6->W6_DT_ENCE >= dIniEncerra  .AND.  SW6->W6_DT_ENCE <= dFimEncerra))  && LAB 29.03.00
         If !Empty(dDtFim) .AND. dDtFim >= dIniEncerra
            nValFob := SYS->YS_PERC * ((aFornMoeda[nPos,3]+aFornMoeda[nPos,4]+aFornMoeda[nPos,5]+;
                                           aFornMoeda[nPos,6]-aFornMoeda[nPos,7])-nTotAntecipado)
         Else
            nValFob := SYS->YS_PERC * ((aFornMoeda[nPos,3]+aFornMoeda[nPos,4]+aFornMoeda[nPos,5]+;
                                       aFornMoeda[nPos,6]-aFornMoeda[nPos,7])-nTotAntecipado)
         EndIf         
         
         
         If nValFob > 0 .Or. Mvl_totdesp # 0

            DI_Ctb->(RecLock("DI_Ctb",.T.))

            // LAB 24.03.00
            //FSM - 24/10/2012
//            IF (! EMPTY(SW6->W6_DT_ENCE) .AND. ;  
//                  (SW6->W6_DT_ENCE >= dIniEncerra  .AND.  SW6->W6_DT_ENCE <= dFimEncerra))  && LAB 29.03.00
            If !Empty(dDtFim) .AND. dDtFim >= dIniEncerra

               DI_Ctb->DIDI_NUM    := SW6->W6_DI_NUM
               DI_Ctb->DIDT        := SW6->W6_DT
   //          DI_Ctb->DILOTE      := cLote              && LAB 24.08.00
               DI_Ctb->DICHEG      := SW6->W6_CHEG
               DI_Ctb->DIHAWB      := SW6->W6_HAWB
               DI_Ctb->DIDT_HAWB   := SW6->W6_DT_HAWB
               DI_Ctb->DIMAWB      := SW6->W6_MAWB
               DI_Ctb->DIDT_ARMZ   := TDt_Arm
               DI_Ctb->DIDT_DCI    := TDt_Arm
               DI_Ctb->DIOBS       := SW6->W6_OBS
               DI_Ctb->DIDESP      := SW6->W6_DESP
               DI_Ctb->DIAGENTE    := SW6->W6_AGENTE
               DI_Ctb->DINF_ENT    := SW6->W6_NF_ENT
               DI_Ctb->DIDT_NF     := SW6->W6_DT_NF
               DI_Ctb->DIDTRECDOC  := SW6->W6_DTRECDOC
               DI_Ctb->DIDT_DESEM  := SW6->W6_DT_DESEM
               DI_Ctb->DIDT_ENTR   := SW6->W6_DT_ENTR

               DI_Ctb->DIVL_DCI    := SYS->YS_PERC * Mvl_dci
               DI_Ctb->DIVL_ICMS   := SYS->YS_PERC * Mvl_icms
               DI_Ctb->DIICMS_C    := SYS->YS_PERC * Micms_c
               DI_Ctb->DIVL_ARM    := SYS->YS_PERC * Mvl_arm
               DI_Ctb->DIVL_DAP    := SYS->YS_PERC * Mvl_dap
               DI_Ctb->DIDESP_GI   := SYS->YS_PERC * Mdesp_gi
               DI_Ctb->DIDESP_CL   := SYS->YS_PERC * Mdesp_cl
               DI_Ctb->DIVL_FRETE  := SYS->YS_PERC * Mvl_frete    
               DI_Ctb->DIVL_DESP   := SYS->YS_PERC * Mvl_desp     

               DI_Ctb->DIFRETE_RO  := SYS->YS_PERC * Mfrete_ro
               DI_Ctb->DIVL_APORT  := SYS->YS_PERC * Mvl_aport
               DI_Ctb->DIVL_AAER   := SYS->YS_PERC * Mvl_aaer
               DI_Ctb->DIVL_ADAP   := SYS->YS_PERC * Mvl_adap
               DI_Ctb->DIVL_II     := SYS->YS_PERC * Mvl_ii
               DI_Ctb->DIVL_IPI    := SYS->YS_PERC * Mvl_ipi
               DI_Ctb->DIVL_701    := SYS->YS_PERC * Mvl_701      // var.cambial + compl. FOB

               DI_Ctb->DIVL_509    := SYS->YS_PERC * Mvl_509

               DI_Ctb->DIVL_USSEG  := SYS->YS_PERC * MVL_USSEG
               DI_Ctb->DIDT_EMB    := SW6->W6_DT_EMB
               
               IF SW6->(FieldPos("W6_INVOICE")) > 0
                  DI_Ctb->DIINVOICE   := SW6->W6_INVOICE
               ELSE
                  SW7->(DbSetOrder(1))
                  SW7->(DbSeek(xFilial("SW6")+SW6->W6_HAWB))
                  DI_Ctb->DIINVOICE   := SW7->W7_INVOICE
               ENDIF
               
               DI_Ctb->DINF_COMP   := SW6->W6_NF_COMP
               DI_Ctb->DIDT_ENCE   := dDtFim //SW6->W6_DT_ENCE //FSM - 24/10/2012
               DI_Ctb->DILOCAL     := SW6->W6_LOCAL
               DI_Ctb->DIREF_DESP  := SW6->W6_REF_DESP
               DI_Ctb->DIPROB_DI   := SW6->W6_PROB_DI
               DI_Ctb->DIDTP_FRE   := TDt_Arm
               DI_Ctb->DIDTP_DESP  := TDt_Arm
               DI_Ctb->DITX_FOB    := aFornMoeda[nPos, 8]    
               DI_Ctb->DIFOB_TOT   := nValFob                //SYS->YS_PERC * (SW6->(W6_FOB_TOT+W6_INLAND+W6_FRETEINT+W6_PACKING-W6_DESCONTO))                                                              
               DI_Ctb->DIDTP_ROD   := TDt_Arm
               DI_Ctb->DIIDENTCT   := cIdentCT
            
               // Grava Fornecedor e Moeda
               DI_Ctb->DIFORN      := aFornMoeda[nPos,1]
               DI_Ctb->DIMOEDA     := aFornMoeda[nPos,2]

               MVl_NFT  :=   0         && LAB 24.08.99

               DI_Ctb->DIVL_NFT    := Mvl_NFT      // Limpar a conta importacao em transito
               DI_Ctb->DICC_ESTOQ  := cCC_ESTOQ
               DI_Ctb->DISUB_SET   := cSUB_SET    && LAB 16.03.00

//          Usado para somar o valor do frete internacional como despesa do despachante
//          ou frete pago pelo importador.
//          SOL 26/09/00 NOPOU
//          IF  MFre_Ad == "S"            && LAB 28.07.00 frete collect adiantado 
//              DI_Ctb->DIDESP_CL   := DI_Ctb->DIDESP_CL + DI_Ctb->DIVL_FRETE
//          ELSE
//              DI_Ctb->DIVL_DESP   := DI_Ctb->DIVL_DESP + DI_Ctb->DIVL_FRETE
//          ENDIF
        
               DI_Ctb->DIVL_FRETE      := 0  && LAB 28.07.00

               MConta := MConta + 1

           ELSE
//            DI_Ctb->DILOTE      := cLote              && LAB 24.08.00
              DI_Ctb->DICHEG      := SW6->W6_CHEG
              DI_Ctb->DIHAWB      := SW6->W6_HAWB
              DI_Ctb->DIDT_HAWB   := SW6->W6_DT_HAWB
              DI_Ctb->DIMAWB      := SW6->W6_MAWB
              DI_Ctb->DIOBS       := SW6->W6_OBS
              DI_Ctb->DIDESP      := SW6->W6_DESP
              DI_Ctb->DIAGENTE    := SW6->W6_AGENTE
              DI_Ctb->DINF_ENT    := SW6->W6_NF_ENT
              DI_Ctb->DIDT_NF     := SW6->W6_DT_NF
              DI_Ctb->DIDTRECDOC  := SW6->W6_DTRECDOC
              DI_Ctb->DIDT_DESEM  := SW6->W6_DT_DESEM
              DI_Ctb->DIDT_ENTR   := SW6->W6_DT_ENTR
              DI_Ctb->DIDT_EMB    := SW6->W6_DT_EMB
              //AOM - 12/07/2012
              IF SW6->(FieldPos("W6_INVOICE")) > 0
                 DI_Ctb->DIINVOICE   := SW6->W6_INVOICE
              EndIf
              DI_Ctb->DINF_COMP   := SW6->W6_NF_COMP
              DI_Ctb->DILOCAL     := SW6->W6_LOCAL
              DI_Ctb->DIREF_DESP  := SW6->W6_REF_DESP
              DI_Ctb->DIPROB_DI   := SW6->W6_PROB_DI
              DI_Ctb->DIFOB_TOT   := nValFob           //SYS->YS_PERC*(aFornMoeda[nPos,3]+aFornMoeda[nPos,4]+aFornMoeda[nPos,5]+aFornMoeda[nPos,6]-aFornMoeda[nPos,7])                                    
              DI_Ctb->DIIDENTCT   := cIdentCT
              DI_Ctb->DICC_ESTOQ  := cCC_ESTOQ
              DI_Ctb->DISUB_SET   := cSUB_SET      && LAB 16.03.00
            
              // Grava Fornecedor e Moeda                                   
              // DI_Ctb->DITX_FOB    := aFornMoeda[nPos,8]    //SW6->W6_TX_FOB
              DI_Ctb->DIFORN      := aFornMoeda[nPos,1]
              DI_Ctb->DIMOEDA     := aFornMoeda[nPos,2]

           ENDIF

           CalcTotal( aTotal, "DI100" ) // Soma valores em aTotal
           DI_Ctb->(MSUNLOCK())                                  
           
         EndIf
         SYS->(DBSKIP())
      ENDDO

//     IF  MFre_Ad == "S"            && LAB 28.07.00 frete collect adiantado 
//         MDESP_CL   := MDESP_CL + MVL_FRETE
//     ELSE
//         MVL_DESP   := MVL_DESP + MVL_FRETE
//     ENDIF
//     MVL_FRETE := 0

    IF lEntrou
       SYS->(DBSKIP(-1))
 
       DI_Ctb->(RecLock("DI_Ctb",.F.))

         // LAB 24.03.00
         //FSM - 24/10/2012
//       IF (! EMPTY(SW6->W6_DT_ENCE) .AND. ;  
//          (SW6->W6_DT_ENCE >= dIniEncerra  .AND.  SW6->W6_DT_ENCE <= dFimEncerra))   && LAB 29.03.00
         If !Empty(dDtFim) .AND. dDtFim >= dIniEncerra

          DI_Ctb->DIVL_DCI  :=IV200Acerta( aTotal, indVL_DCI  , DI_Ctb->DIVL_DCI  , mVl_DCI )
          DI_Ctb->DIVL_FRETE:=IV200Acerta( aTotal, indVL_FRETE, DI_Ctb->DIVL_FRETE, mvl_frete)   && LAB 28.07.00
          DI_Ctb->DIVL_ICMS :=IV200Acerta( aTotal, indVL_ICMS , DI_Ctb->DIVL_ICMS , mVl_ICMS )
          DI_Ctb->DIICMS_C  :=IV200Acerta( aTotal, indICMS_C  , DI_Ctb->DIICMS_C  , mICMS_C )
          DI_Ctb->DIVL_ARM  :=IV200Acerta( aTotal, indVL_ARM  , DI_Ctb->DIVL_ARM  , mVl_ARM )
          DI_Ctb->DIVL_DAP  :=IV200Acerta( aTotal, indVL_DAP  , DI_Ctb->DIVL_DAP  , mVl_DAP )
          DI_Ctb->DIDESP_GI :=IV200Acerta( aTotal, indDESP_GI , DI_Ctb->DIDESP_GI , mDesp_GI)
          DI_Ctb->DIDESP_CL :=IV200Acerta( aTotal, indDESP_CL , DI_Ctb->DIDESP_CL , mDesp_CL)
          DI_Ctb->DIVL_DESP :=IV200Acerta( aTotal, indVL_DESP , DI_Ctb->DIVL_DESP , mVL_Desp)
          DI_Ctb->DIFRETE_RO:=IV200Acerta( aTotal, indFRETE_RO, DI_Ctb->DIFRETE_RO, mFrete_RO)
          DI_Ctb->DIVL_APORT:=IV200Acerta( aTotal, indVL_APORT, DI_Ctb->DIVL_APORT, mVl_APort)
          DI_Ctb->DIVL_AAER :=IV200Acerta( aTotal, indVL_AAER , DI_Ctb->DIVL_AAER , mVl_AAER )
          DI_Ctb->DIVL_ADAP :=IV200Acerta( aTotal, indVL_ADAP , DI_Ctb->DIVL_ADAP , mVl_ADAP )
          DI_Ctb->DIVL_II   :=IV200Acerta( aTotal, indVL_II   , DI_Ctb->DIVL_II   , mVl_II )
          DI_Ctb->DIVL_IPI  :=IV200Acerta( aTotal, indVL_IPI  , DI_Ctb->DIVL_IPI  , mVl_IPI )
          DI_Ctb->DIVL_701  :=IV200Acerta( aTotal, indVL_701  , DI_Ctb->DIVL_701  , mVl_701 )
          DI_Ctb->DIVL_509  :=IV200Acerta( aTotal, indVL_509  , DI_Ctb->DIVL_509  , mVl_509 )
          DI_Ctb->DIVL_USSEG:=IV200Acerta( aTotal, indVL_USSEG, DI_Ctb->DIVL_USSEG, IF(SW6->W6_SEGMOEDA=="US$",SW6->(W6_VL_USSEG * W6_TX_US_DI),SW6->(W6_VL_USSEG * W6_TX_FOB)) )
          If nPos > 0
             DI_Ctb->DIFOB_TOT :=IV200Acerta( aTotal, indFOB_TOT , DI_Ctb->DIFOB_TOT , (aFornMoeda[nPos,3]+aFornMoeda[nPos,4]+aFornMoeda[nPos,5]+aFornMoeda[nPos,6]-aFornMoeda[nPos,7])-nTotAntecipado)
          Endif   
//          DI_Ctb->DIVL_NFT  :=IV200Acerta( aTotal, indVL_NFT  , DI_Ctb->DIVL_NFT  , mVl_NFT )

//          Mvl_NFT   =  IF(SW6->W6_FRETEINT <> 0,0,VAL(STR(SW6->(W6_VL_FRETE * W6_TX_FRETE),15,2))) + ;
//                       IF(SW6->W6_SEGMOEDA == "US$",VAL(STR(SW6->(W6_VL_USSEG * W6_TX_US_DI),15,2)),VAL(STR(SW6->(W6_VL_USSEG * W6_TX_FOB),15,2))) + ;
//                       VAL(STR( (SW6->(W6_FOB_TOT+W6_INLAND + ;
//                       W6_FRETEINT+W6_PACKING-W6_DESCONTO)) * SW6->W6_TX_FOB,15,2)) + MVl_II 

//          MVl_NFT  :=   VAL(STR(  DI_Ctb->DIFOB_TOT * SW6->W6_TX_FOB,15,2))

          DI_Ctb->DIVL_NFT  := Mvl_NFT      // Limpar a conta importacao em transito

       ELSE
          If nPos > 0
             DI_Ctb->DIFOB_TOT := IV200Acerta( aTotal, indFOB_TOT, DI_Ctb->DIFOB_TOT, (aFornMoeda[nPos,3]+aFornMoeda[nPos,4]+aFornMoeda[nPos,5]+aFornMoeda[nPos,6]-aFornMoeda[nPos,7])-nTotAntecipado )
          Endif   
       ENDIF
  
       DI_Ctb->(MsUnlock())
    ENDIF   
    If lExisteECF   
       ECF->(DBSETORDER(2))
    Endif   

    SWB->(DBSETORDER(nOrdemSWB))
    SWB->(DBGOTO(nRecNoSWB)) // Nick 18/05/06
    // Retorna o SW9 p/ a ordem e registro anterior
    SW9->(DbSetOrder(nOrdSW9))
    SW9->(DbGoto(nRecnoSW9))
    
RETURN .T.
*-----------------------------*
STATIC FUNCTION ApagaECFECG()            
*-----------------------------*
ProcRegua(ECF->(Lastrec()+1))
ECF->(DBSETORDER(4))
ECG->(DBSETORDER(1))
ECF->(DbSeek(cFilECF+"IMPORT"+'9999'))
cHawb:=ECF->ECF_HAWB
cOrigem:=ECF->ECF_ORIGEM
cIdentc:=ECF->ECF_IDENTC      
cForn  :=ECF->ECF_FORN
DO WHILE ! ECF->(EOF()) .AND. ECF->ECF_FILIAL = cFilECF
        
   IncProc(STR0018 + ECF->ECF_INVOIC)   //"Invoice : "
   
   If ECF->ECF_NR_CONT = '9999'
      
	  If ECF->ECF_ID_CAM $ "101" .AND. ECF->ECF_ORIGEM == "PO"
         //AAF 29/09/2012 - Estornar o numero da contabilizacao para pagamento pré-embarque.
         cLoja := If(SWB->(FieldPos("WB_LOJA"))>0,Posicione("SA2",1,xFilial("SA2")+ECF->ECF_FORN,"A2_LOJA"),"")
		 
		 SWB->(dbSetOrder(1))
		 If SWB->(DBSEEK(xFilial("SWB")+ECF->ECF_PROCOR+"D"+ECF->ECF_INVORI+ECF->ECF_FORN+cLoja+ECF->ECF_SEQ))
            Reclock("SWB",.F.)
            SWB->WB_CONTAB := CTOD('  /   /  ')
            SWB->(MsUnLock())      
         EndIf
      EndIf
	  
      Reclock('ECF',.F.)
      ECF->(DBDELETE())
      ECF->(MSUNLOCK())
   ENDIF
   ECF->(DbSkip())

   If ECF->(EOF()) .or. cHawb # ECF->ECF_HAWB .or. cOrigem # ECF->ECF_ORIGEM .or. cIdentc # ECF->ECF_IDENTC .or. cForn # ECF->ECF_FORN
      ECF->(DBSETORDER(3))
      If ECG->(DbSeek(cFilECG+"IMPORT"+cHawb+cForn+cIdentc+cOrigem)) .AND. ! ECF->(DbSeek(cFilECF+"IMPORT"+cHawb+cForn+cIdentc+cOrigem))
         If ECG->ECG_NR_CON = '9999' .OR. Empty(Alltrim(ECG->ECG_NR_CON))
            Reclock('ECG',.F.)
            ECG->(DBDELETE())
            ECG->(MSUNLOCK())
         ENDIF
      EndIf
      ECF->(DBSETORDER(4))
      ECF->(DbSeek(cFilECF+"IMPORT"+'9999'))
      cHawb:=ECF->ECF_HAWB
      cOrigem:=ECF->ECF_ORIGEM
      cIdentc:=ECF->ECF_IDENTC      
      cForn  :=ECF->ECF_FORN      
   EndIf
   
ENDDO             

ECF->(DBSETORDER(1))
Return .T.              

*-----------------------------*
Static FUNCTION GeraPagtos()            
*-----------------------------*
Local cFornSW2
Private aTotal:={0}
cFil_SWB:=xFilial("SWB")   
cFil_SW8:=xFilial("SW8")
cFil_SYS:=xFilial("SYS")
cFil_SW9:=xFilial("SW9")          
cFil_SW2:=xFilial("SW2")

ECG->(DbSetOrder(2))
ECF->(DbSetOrder(5))
SWB->(DbSetOrder(3))
SW9->(DbSetOrder(1))           
SW2->(DbSetOrder(1))           

ProcRegua(SWB->(LASTREC()+1))

SWB->(DBSEEK(cFil_SWB+DTOS(dIniEncerra - 5),.T.))

DO WHILE .NOT. SWB->(EOF()) .AND. SWB->WB_CA_DT <= (dFimEncerra + 5) ;  && pagto no mes
         .AND. cFil_SWB == SWB->WB_FILIAL

   IF SWB->WB_DT_DESE < dIniEncerra .OR. SWB->WB_DT_DESE > dFimEncerra   // Pagto no mes
      SWB->(DBSKIP())
      LOOP
   ENDIF                                            

   If SWB->WB_PO_DI = 'A' .And. SWB->WB_TIPOREG = 'P'               
      IF lAtuDtCont
        SWB->(RECLock("SWB",.F.))
        SWB->WB_CONTAB := dDataBase
        SWB->(MSUnlock())
      ENDIF                                      
      
      //SW8->(DbSeek(cFil_SW8+SWB->WB_HAWB))
      SW2->(DbSeek(cFil_SW2+SWB->WB_HAWB))      
      cFornSW2 := SW2->W2_FORN
      //SW9->(DBSEEK(cFil_SW9+SWB->WB_INVOICE+cFornSW8) )                                 
      SYS->(dbSeek(cFil_SYS+"I"+"P"+SWB->WB_HAWB))                 
      lEntrou := .F.
      aTotal:={0}
      DO WHILE SYS->(!EOF()) .AND. SYS->YS_FILIAL==cFil_SYS .AND. SYS->YS_TPMODU == "I" .AND. SYS->YS_TIPO+SYS->YS_HAWB == "P"+SWB->WB_HAWB

         If !ECG->(DbSeek(cFilECG+"IMPORT"+Avkey(SWB->WB_HAWB, "WB_HAWB")+cFornSW2+"PO"+SYS->YS_CC)) //Nick 09/10/06
            Reclock("ECG",.T.)
            ECG->ECG_FILIAL  := cFilECG
            ECG->ECG_HAWB    := SWB->WB_HAWB
            ECG->ECG_IDENTC  := SYS->YS_CC
            ECG->ECG_SIS_OR  := "1"
            ECG->ECG_DT      := dDataBase
            ECG->ECG_ORIGEM  := "PO"  
            ECG->ECG_FORN 	 := cFornSW2
            ECG->ECG_DTENCE  := CTOD(' /  / ')         
            ECG->ECG_NR_CON  := '9999'
            ECG->ECG_TPMODU := "IMPORT"
            ECG->(MSUNLOCK())                           
         ElseIf ! Empty(ECG->ECG_DTENCE)
            //CR200LOCK("ECG",.F.)
            Reclock("ECG",.F.)  // TLM 08/05/2008
            ECG->ECG_DTENCE := CTOD("")
            ECG->(MSUNLOCK())             
         Endif                              
         // Grava o evento 609      
         //If !ECF->(DbSeek(cFilECF+Avkey(SWB->WB_HAWB, "WB_HAWB")+cFornSW2+"PO"+SWB->WB_LINHA+"609"+AVKEY(SYS->YS_CC,"ECF_IDENTC")))
         If !ECF->(DbSeek(cFilECF+"IMPORT"+Avkey(SWB->WB_HAWB, "WB_HAWB")+cFornSW2+"PO"+SWB->WB_LINHA+"609"+AVKEY(SYS->YS_CC,"ECF_IDENTC")))
            lEntrou := .T.
            GravaECF("609", SWB->WB_CA_TX, SW2->W2_MOEDA, SYS->YS_CC, cFornSW2, .T.)                        
            CalcTotal( aTotal, "ANTPGT0")
         ENDIF     
         SYS->(DbSkip())      
      Enddo
      If lEntrou 
         Reclock("ECF",.F.)
         ECF->ECF_VL_MOE :=IV200Acerta( aTotal, indFOBMOE  , ECF->ECF_VL_MOE , SWB->WB_PGTANT )
         ECF->ECF_VALOR  :=ECF->ECF_VL_MOE * SWB->WB_CA_TX
         ECF->(MSUNLOCK())
	  EndIf
   Endif   
   SWB->(DbSkip())
Enddo

ECG->(DbSetOrder(1))
SWB->(DbSetOrder(1))

Return .T.

*------------------------------*
Static Function VerifPagAnt()   // Rotina de verificacao de pagamento antecipado
*------------------------------*
Local nOrdemSWB := SWB->(IndexOrd()), nOrdemSA6 := SA6->(IndexOrd()),;
      nOrdemSW8 := SW8->(IndexOrd()), ;
      nOrdemSYS := SYS->(IndexOrd()), nOrdemECF := ECF->(IndexOrd()),;
      nOrdemECG := ECG->(IndexOrd()),;
      nTxAplic  := 0, cFornSW8,;
      cIdentCusto := "", aInv := {}, nPos := 0, i := 0, j := 0, num := 0, aCCInv := {},;
      aVlInv := {}, cPo

Local dDtIni := GetDt("INICIO") //FSM - 24/10/2012

//  nOrdemSW9 := SW9->(IndexOrd()), Nick 24/05/06
cFil_SWB := xFilial("SWB")
cFil_SA6 := xFilial("SA6")
cFil_SYS := xFilial("SYS")
cFil_ECF := xFilial("ECF")
// cFil_SW9 := xFilial("SW9") Nick 24/05/06

SWB->(DbSetOrder(1))  // HAWB+Tipo de Registro
ECF->(DbSetOrder(6))
SW8->(DbSetOrder(1))
// SW9->(DbSetOrder(1)) Nick 24/05/06
SYS->(DbSetOrder(1))
SA6->(DbSetOrder(1))
ECG->(DbSetOrder(2))
IF SWB->(DBSEEK(cFil_SWB+SW6->W6_HAWB+"D")) .And. !Empty(dDtIni) //!Empty(SW6->W6_DT_EMB) //.And. Empty(SW6->W6_DT_ENCE) // Nick 25/05/06 !Empty(SW6->W6_DT_ENCE) // Tipo de registro de pagamento antecipado para o embarque/desembaraco
   DO WHILE .NOT. SWB->(EOF()) .AND. SWB->WB_HAWB = SW6->W6_HAWB ;  
            .AND. SWB->WB_PO_DI == "D" .AND. cFil_SWB == SWB->WB_FILIAL
                                        
      If SWB->WB_TIPOREG <> "P" .Or. !Empty(SWB->WB_CONTAB)      // Verifica se e pagamento antecipado ou se ja foi contabilizado
         SWB->(DbSkip())
         Loop
      Endif                                   
                  
      SW8->(DbSeek(cFil_SW8+SWB->WB_HAWB))
      cFornSW8 := SW8->W8_FORN                                         
      nTxAplic := SWB->WB_CA_TX             
      cPo  := AVkey(SWB->WB_NUMPO, "WB_HAWB")
      nPos := AScan(aInv,{|x| x[1]==cPo })
      If nPos = 0
         AADD(aInv, {cPo, SWB->WB_PGTANT, SWB->WB_LINHA, SWB->WB_INVOICE, cFornSW8, SWB->WB_MOEDA} )  
      Else
         aInv[nPos,2] += SWB->WB_PGTANT
      Endif
      
      IF lAtuDtCont
         SWB->(RECLock("SWB",.F.))
         SWB->WB_CONTAB := dDataBase
         SWB->(MSUnlock())
      ENDIF                                      
      SWB->(DbSkip())
   ENDDO     
                             
   // Rateia por C.Custo                                             
   For i := 1 to Len(aInv)                                       
   	   // SW9->(DbSeek(cFil_SW9+aInv[i,4]))      Nick 24/05/06
	   aCCInv := {}
	   aVlInv := {}
       cPo := AVkey(aInv[i,1], "YS_HAWB")   // Formata p/ que fique do tamanho do campo do YS_HAWB
       SYS->(dbSeek(cFil_SYS+"I"+"A"+SW6->W6_HAWB)) // SYS->(dbSeek(cFil_SYS+"P"+cPo))              
       DO WHILE SYS->(!EOF()) .AND. SYS->YS_FILIAL==cFil_SYS .AND. SYS->YS_TPMODU == "I" .AND. SYS->YS_TIPO+SYS->YS_HAWB == "A"+SW6->W6_HAWB// "P"+cPo
      
          cIdentCusto := SYS->YS_CC+Space(Len(ECF->ECF_IDENTC)-LEN(SYS->YS_CC))         

          If ECF->(DBSEEK(cFil_ECF+"IMPORT"+aInv[i,1]+aInv[i,5]+cIdentCusto+'PO'+'101'))
             SYS->(DbSkip())
             Loop
          Endif

          nPos := AScan(aCCInv, {|x| x[1]==cPo .And. x[4]==cIdentCusto})
          If nPos = 0
             AAdd(aCCInv, {cPo, aInv[i,2]*SYS->YS_PERC, aInv[i,3], cIdentCusto, aInv[i,5] })            
          Else
             aCCInv[nPos,2] += aInv[i,2]*SYS->YS_PERC           
          Endif
          SYS->(DbSkip()) 
       Enddo
                                                                     
       For j:=1  to Len(aCCInv)
           //ECF->(DbSeek(cFilECF+aCCInv[j,1]+aCCInv[j,5]+aCCInv[j,4]+"PO"))
           ECF->(DbSeek(cFilECF+"IMPORT"+aCCInv[j,1]+aCCInv[j,5]+aCCInv[j,4]+"PO"))
                      
           Do While ECF->(!Eof()) .And. aCCinv[j,1] = ECF->ECF_HAWB .And. ECF->ECF_IDENTC = aCCInv[j,4] .And. ECF->ECF_ORIGEM = "PO"                    
          
              If ECF->ECF_ID_CAM = '101' .Or. ECF->ECF_ID_CAM = '609'
                 nPos := AScan(aVlInv,{|x| x[1]==ECF->ECF_HAWB .And. x[2]==ECF->ECF_SEQ .And. x[3]==ECF->ECF_IDENTC .And. x[7]==ECF->ECF_INVOIC })
                 If nPos = 0
                    AAdd(aVlInv, {ECF->ECF_HAWB, ECF->ECF_SEQ, ECF->ECF_IDENTC, ECF->ECF_VL_MOE, ECF->ECF_VL_MOE, GetDt("INICIO"), ECF->ECF_INVOIC}) //FSM - 11/10/2012
                 Else
                    If ECF->ECF_ID_CAM = '101'
                       aVlInv[nPos,4] -= ECF->ECF_VL_MOE
                    Elseif ECF->ECF_ID_CAM = '609'                              
                       aVlInv[nPos,4] += ECF->ECF_VL_MOE
                    Endif
                 Endif          
              Endif            
              ECF->(DbSkip())
           Enddo
       Next   
   
       // Grava no ECF
       For nPos:=1  to Len(aCCInv)
           nValorInv := aCCInv[nPos,2]
           For num:=1  to Len(aVlInv)
               If aCCInv[nPos,4] == aVlInv[num,3] .and. aVlInv[num,4] > 0 .And. nValorInv > 0                
                  If aVlInv[num,4] <= nValorInv                                                                    
                     // Incluir no ECF o evento 101 e gravar o abatimento como igual a aVlInv[i,4]
//                     GravaECF("101", nTxAplic, SW9->W9_MOE_FOB, aVlInv[num,3], cFornSW8, .F., cPo, aVlInv[num,2], aVlInv[num,7], aVlInv[num,4], aVlInv[num,6], SW6->W6_DI_NUM, aInv[i,4])                              
                     GravaECF("101", nTxAplic, aInv[i,6], aVlInv[num,3], cFornSW8, .F., cPo, aVlInv[num,2], aVlInv[num,7], aVlInv[num,4], aVlInv[num,6], SW6->W6_DI_NUM, aInv[i,4])                              
                     Reclock("ECF", .F.)
                     ECF->ECF_PROCOR := SW6->W6_HAWB
					 ECF->(MsUnlock())                     
                     nValorInv -= aVlInv[num,4]                                        
                  Else
                     // Incluir no ECF o evento 101 e gravar o abatimento como igual a nvalorinv
//                     GravaECF("101", nTxAplic, SW9->W9_MOE_FOB, aVlInv[num,3], cFornSW8, .F., cPo, aVlInv[num,2], aVlInv[num,7], nValorInv, aVlInv[num,6], SW6->W6_DI_NUM, aInv[i,4] )         
                     GravaECF("101", nTxAplic, aInv[i,6], aVlInv[num,3], cFornSW8, .F., cPo, aVlInv[num,2], aVlInv[num,7], nValorInv, aVlInv[num,6], SW6->W6_DI_NUM, aInv[i,4] )         
                     Reclock("ECF", .F.)
                     ECF->ECF_PROCOR := SW6->W6_HAWB
					 ECF->(MsUnlock())
                     nValorInv := 0                               
                  Endif                                     
               Endif
           Next
       Next
   Next
Endif

SWB->(DbSetOrder(nOrdemSWB))
SA6->(DbSetOrder(nOrdemSA6))
SW8->(DbSetOrder(nOrdemSW8))
// SW9->(DbSetOrder(nOrdemSW9)) Nick 24/05/06
SYS->(DbSetOrder(nOrdemSYS))
ECF->(DbSetOrder(nOrdemECF))
ECG->(DbSetOrder(nOrdemECG))

Return .T.
*-----------------------------------------------------------------------------------------------------------------------------------*
STATIC FUNCTION GRAVAECF(cEvento, nTxUsada, cMoeda, cCusto, cFornec, lRateia, cPoNum, cLinha, cInvoice, nValor, dData, cDi, cInvOri)
*-----------------------------------------------------------------------------------------------------------------------------------*
Local nValorFOBMOE := 0, cFilSA2 := xFilial("SA2"),;
	  MCTA_DEB := " ", MCTA_CRE := " " 

nValorFobMoe := If(lRateia, SYS->YS_PERC, 1) * If(nValor # NIL, nValor, SWB->WB_PGTANT)

SA2->(DbSetOrder(1))
EC6->(DbSetOrder(1))

//AAF - 29/09/2012 - Usar a configuração do centro de custo padrão caso não haja cadastro no EC6 para o centro de custo especifico.
If !EC6->(DbSeek(xFilial()+"IMPORT"+cEvento+cCusto))
   EC6->(DbSeek(xFilial()+"IMPORT"+cEvento))
EndIf

//AAF - 29/09/2012 - Traduzir as mascaras de conta contabil.
MCTA_DEB := EasyMascCon(EC6->EC6_CTA_DB,cFornec,"",/* cImport */,/* cLojaImp */,SWB->WB_BANCO,SWB->WB_AGENCIA,SWB->WB_CONTA,'IMPORT',cEvento) //MCTA_DEB := EC6->EC6_CTA_DB
MCTA_CRE := EasyMascCon(EC6->EC6_CTA_CR,cFornec,"",/* cImport */,/* cLojaImp */,SWB->WB_BANCO,SWB->WB_AGENCIA,SWB->WB_CONTA,'IMPORT',cEvento) //MCTA_CRE := EC6->EC6_CTA_CR

If Empty( MCTA_CRE ) .And. cEvento$"609/608"
   Sa6->( DbSetOrder( 1 ) )
   SA6->(DBSEEK(xFilial()+SWB->WB_BANCO+SWB->WB_AGENCIA))
   MCTA_CRE := Sa6->A6_Contabi

End

If cPoNum # NIL .And. cLinha # NIL .And. cEvento # NIL .And. cCusto # NIL                     
   If !ECF->(DbSeek(cFilECF+"IMPORT"+cPoNum+cFornec+cCusto+"PO"+cLinha+cEvento)) // Nick 20/06/06
      RecLock("ECF",.T.)      
   Else
      RecLock("ECF",.F.)      
   Endif
Else
   RecLock("ECF",.T.)      
Endif   

ECF->ECF_FILIAL  := cFilECF
ECF->ECF_INVOIC  := If(cInvoice # NIL, cInvoice, SWB->WB_INVOICE)
ECF->ECF_HAWB    := If(cPoNum # NIL, cPoNum, SWB->WB_HAWB)	                
ECF->ECF_IDENTC  := If(cCusto # NIL, cCusto, Space(Len(ECF->ECF_IDENTC)))
ECF->ECF_ID_CAM  := cEvento
ECF->ECF_DTCONT  := If(dData = NIL, SWB->WB_CA_DT, dData)
ECF->ECF_DTCONV  := AVCTOD("  /  /  ")
ECF->ECF_PARIDA  := nTxUsada
ECF->ECF_NR_CON  := '9999'
ECF->ECF_VL_MOE  := nValorFobMoe
ECF->ECF_VALOR   := VAL(STR( nValorFobMoe * If(nTxUsada = 0, 1, nTxUsada),15,2))
ECF->ECF_MOEDA   := cMoeda
ECF->ECF_ORIGEM  := "PO"
ECF->ECF_FORN    := cFornec    
ECF->ECF_SEQ     := If(cLinha # NIL, cLinha, SWB->WB_LINHA)    
ECF->ECF_INVORI  := cInvOri
ECF->ECF_DI_NUM  := cDI
ECF->ECF_DESCR   := EC6->EC6_DESC
If MCTA_DEB = "999999999999999"
   IF SA2->(DBSEEK(cFilSA2+cFornec)) .AND. ! EMPTY(ALLTRIM(cFornec))
      MCTA_DEB = IF(!EMPTY(ALLTRIM(SA2->A2_CONTAB)), ALLTRIM(SA2->A2_CONTAB),"999999999999999")
   ENDIF
Endif
If MCTA_CRE = "999999999999999"
   IF SA2->(DBSEEK(cFilSA2+cFornec)) .AND. ! EMPTY(ALLTRIM(cFornec))
      MCTA_CRE = IF(!EMPTY(ALLTRIM(SA2->A2_CONTAB)), ALLTRIM(SA2->A2_CONTAB),"999999999999999")
   ENDIF
Endif
ECF->ECF_CTA_DB := MCTA_DEB
ECF->ECF_CTA_CR := MCTA_CRE
ECF->ECF_LINK   := cEvento
   ECF->ECF_TPMODU := "IMPORT"
ECF->(MsUnlock())   

Return .T.          
// ***************************************************************************************
//                                  FIM DO PROGRAMA ECOIV20A_AP5
// ***************************************************************************************


Static Function ApagaEcos()
             
Private cFilEC3 := xFilial("EC3"), cFilEC4 := xFilial("EC4"), cFilEC5 := xFilial("EC5") ,;
        cFilEC7 := xFilial("EC7"), cFilEC9 := xFilial("EC9"), cFilECF := xFilial("ECF") ,;
        cFilECG := xFilial("ECG"), cFilEC2 := xFilial("EC2"), cFilEC8 := xFilial("EC8")


EC3->(DbsetOrder(1))
EC4->(DbsetOrder(1))
EC5->(DbsetOrder(1))
EC7->(DbsetOrder(2))
EC9->(DbsetOrder(1))
ECF->(DbsetOrder(1))
ECG->(DbsetOrder(1))
EC2->(DbsetOrder(1))
EC8->(DbSetOrder(1))

AvProcessa({||Atualiza()},"Aguarde... Atualizando Arquivos ...") 

EC7->(DbSetOrder(1))

Return 

Static FUNCTION LIMPAECA()
*-------------------------*
ProcRegua( 1 )
If lTop
   If Select("ECA") <> 0 //Nick 18/05/06
      cQuery := "DELETE FROM " + retsqlname("ECA")
      cQuery := cQuery + " WHERE ECA_TPMODU = 'IMPORT' " // Nick ECA_FILIAL = " + xFilial("ECA")
      // cQuery := cQuery + " AND ECA_TPMODU = 'IMPORT' " // Nick
      // cQuery := cQuery + " AND ECA_NR_CON IN ('0000','9999','    ')"
      TCSQLEXEC(cQuery)
   //   cQuery := 'TRUNCATE TABLE ' + 'ECA020'
   //   TCSQLEXEC(cQuery)
   endif
Else
   DBSELECTAREA("ECA")
   DO WHILE !ECA->(EOF())
      If ECA->ECA_TPMODU = 'IMPORT' // Nick 07/10/06 ECA->ECA_NR_CON $ "9999/0000/    "
         ECA->(DELETE())
      Endif 
   Enddo
Endif
IncProc("Limpando registros...")

Return .T.


*--------------------------*
Static Function Atualiza()
*--------------------------*
Local cQuery, RecNoSX2 := 8, cArqSQL, lDeleta := .F., aDeletaEC8 := {}, X
Local cFilEC2 := xFilial("EC2")
//Local cFilEC4 := xFilial("EC4") , MConta := 0, 
ProcRegua(RecNoSX2)

// EC2
RecNoSX2:="/"+Trim(Str(RecnoSX2,7,0))+")"

SX2->(DbSeek('EC2'))
cArqSQL := AllTrim(SX2->X2_ARQUIVO)
IncProc("Limpando Tabela "+cArqSQL, 1)

EC2->(DbSeek(cFilEC2))
Do While EC2->(!EOF()) .And. EC2->EC2_FILIAL = cFilEC2
   lDeleta := .T.
   aDeletaEC8 := {}
   If EC8->(DbSeek(cFilEC8+EC2->EC2_HAWB+EC2->EC2_FORN+EC2->EC2_MOEDA+EC2->EC2_IDENTC))
      Do While EC8->(!EOF()) .And. cFilEC8 = EC8->EC8_FILIAL .And. (EC8->EC8_HAWB+EC8->EC8_FORN+EC8->EC8_MOEDA+EC8->EC8_IDENTC) = (EC2->EC2_HAWB+EC2->EC2_FORN+EC2->EC2_MOEDA+EC2->EC2_IDENTC)

         // EC5
         If EC5->(DbSeek(cFilEC5+EC8->EC8_FORN+EC8->EC8_INVOIC+EC8->EC8_IDENTC))
            Do While EC5->(!EOF()) .And. EC5->EC5_FILIAL = cFilEC5 .And. EC5->EC5_FORN = EC8->EC8_FORN .And. ;
               EC5->EC5_INVOIC = EC8->EC8_INVOIC .And. EC5->EC5_IDENTC = EC8->EC8_IDENTC
               If Alltrim(EC5->EC5_HAWB) = Alltrim(EC2->EC2_HAWB)
                  If !Empty(Val(EC5->EC5_NR_CON)) .And. EC5->EC5_NR_CON # '9999'
                     lDeleta := .F.
                     Exit
                  Endif
               Endif
               EC5->(DbSkip())
            Enddo
         Endif

         // EC9
         If lDeleta
            If EC9->(DbSeek(cFilEC9+EC8->EC8_FORN+EC8->EC8_INVOIC+EC8->EC8_IDENTC))
               Do While EC9->(!EOF()) .And. EC9->EC9_FILIAL = cFilEC9 .And. EC9->EC9_FORN = EC8->EC8_FORN .And. ;
                  EC9->EC9_INVOIC = EC8->EC8_INVOIC .And. EC9->EC9_IDENTC = EC8->EC8_IDENTC
                  If !Empty(Val(EC9->EC9_NR_CON)) .And. EC9->EC9_NR_CON # '9999'
                     lDeleta := .F.
                     Exit
                  Endif
                  EC9->(DbSkip())
               Enddo
            Endif
         Endif
         If !lDeleta
            Exit
         Else
            Aadd(aDeletaEC8, EC8->(Recno()) )
            EC8->(DbSkip())
         Endif
      Enddo
   Endif

   // EC7
   If lDeleta
      If EC7->(DbSeek(cFilEC7+EC2->EC2_HAWB+EC2->EC2_FORN+EC2->EC2_MOEDA+EC2->EC2_IDENTC))
         Do While EC7->(!EOF()) .And. cFilEC7 = EC7->EC7_FILIAL .And. (EC7->EC7_HAWB+EC7->EC7_FORN+EC7->EC7_MOEDA+EC7->EC7_IDENTC) = (EC2->EC2_HAWB+EC2->EC2_FORN+EC2->EC2_MOEDA+EC2->EC2_IDENTC)
            If !Empty(Val(EC7->EC7_NR_CON)) .And. EC7->EC7_NR_CON # '9999'
              lDeleta := .F.
              Exit
            Endif
            EC7->(DbSkip())
         Enddo
      Endif
   Endif

   If lDeleta
      Reclock('EC2',.F.)
      EC2->(DbDelete())
      EC2->(MsUnlock())
      // Deleta os processos correspondentes do EC8
      For x:=1 to Len(aDeletaEC8)
          EC8->(DbGoto(aDeletaEC8[x]))
      	  Reclock('EC8',.F.)
          EC8->(DbDelete())
      	  EC8->(MsUnlock())
      Next
   Endif
   EC2->(DbSkip())
Enddo

// EC3
SX2->(DbSeek('EC3'))
cArqSQL := AllTrim(SX2->X2_ARQUIVO)

If TCCANOPEN(cArqSQL)
   IncProc("Limpando Tabela "+cArqSQL, 2)
   cQuery := 'SELECT MAX(R_E_C_N_O_) RECNO FROM ' + cArqSQL
   dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)
   nCont := 1
   // APAGA A CADA 1024 PARA NÃO ENCHER O LOG DO BANCO!
   While nCont <= CONT->RECNO
      cQuery := "DELETE FROM " + cArqSQL
      cQuery := cQuery + " WHERE R_E_C_N_O_ between "+Str(nCont)+" AND "+Str(nCont+1024)
      cQuery := cQuery + " AND EC3_NR_CON IN ('0000','9999','    ')"
	  nCont := nCont + 1024
   	  TCSQLEXEC(cQuery)
   Enddo
   CONT->(dbCloseArea())
Endif


// EC4
SX2->(DbSeek('EC4'))
cArqSQL := AllTrim(SX2->X2_ARQUIVO)

If TCCANOPEN(cArqSQL)
   IncProc("Limpando Tabela "+cArqSQL, 3)
   cQuery := 'SELECT MAX(R_E_C_N_O_) RECNO FROM ' + cArqSQL
   dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)
   nCont := 1
   // APAGA A CADA 1024 PARA NÃO ENCHER O LOG DO BANCO!
   While nCont <= CONT->RECNO
      cQuery := "DELETE FROM " + cArqSQL
      cQuery := cQuery + " WHERE R_E_C_N_O_ between "+Str(nCont)+" AND "+Str(nCont+1024)
      cQuery := cQuery + " AND EC4_NR_CON IN ('0000','9999','    ')"
	  nCont := nCont + 1024
   	  TCSQLEXEC(cQuery)
   Enddo
   CONT->(dbCloseArea())
Endif



// EC5
SX2->(DbSeek('EC5'))
cArqSQL := AllTrim(SX2->X2_ARQUIVO)

If TCCANOPEN(cArqSQL)
   IncProc("Limpando Tabela "+cArqSQL, 4)
   cQuery := 'SELECT MAX(R_E_C_N_O_) RECNO FROM ' + cArqSQL
   dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)
   nCont := 1
   // APAGA A CADA 1024 PARA NÃO ENCHER O LOG DO BANCO!
   While nCont <= CONT->RECNO
      cQuery := "DELETE FROM " + cArqSQL
      cQuery := cQuery + " WHERE R_E_C_N_O_ between "+Str(nCont)+" AND "+Str(nCont+1024)
      cQuery := cQuery + " AND EC5_NR_CON IN ('0000','9999','    ')"
	  nCont := nCont + 1024
   	  TCSQLEXEC(cQuery)
   Enddo
   CONT->(dbCloseArea())
Endif


// EC7
SX2->(DbSeek('EC7'))
cArqSQL := AllTrim(SX2->X2_ARQUIVO)

If TCCANOPEN(cArqSQL)
   IncProc("Limpando Tabela "+cArqSQL, 5)
   cQuery := 'SELECT MAX(R_E_C_N_O_) RECNO FROM ' + cArqSQL
   dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)
   nCont := 1
   // APAGA A CADA 1024 PARA NÃO ENCHER O LOG DO BANCO!
   While nCont <= CONT->RECNO
      cQuery := "DELETE FROM " + cArqSQL
      cQuery := cQuery + " WHERE R_E_C_N_O_ between "+Str(nCont)+" AND "+Str(nCont+1024)
      cQuery := cQuery + " AND EC7_NR_CON IN ('0000','9999','    ')"
	  nCont := nCont + 1024
   	  TCSQLEXEC(cQuery)
   Enddo
   CONT->(dbCloseArea())
Endif


// EC9
SX2->(DbSeek('EC9'))
cArqSQL := AllTrim(SX2->X2_ARQUIVO)

If TCCANOPEN(cArqSQL)
   IncProc("Limpando Tabela "+cArqSQL, 6)
   cQuery := 'SELECT MAX(R_E_C_N_O_) RECNO FROM ' + cArqSQL
   dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)
   nCont := 1
   // APAGA A CADA 1024 PARA NÃO ENCHER O LOG DO BANCO!
   While nCont <= CONT->RECNO
      cQuery := "DELETE FROM " + cArqSQL
      cQuery := cQuery + " WHERE R_E_C_N_O_ between "+Str(nCont)+" AND "+Str(nCont+1024)
      cQuery := cQuery + " AND EC9_NR_CON IN ('0000','9999','    ')"
	  nCont := nCont + 1024
   	  TCSQLEXEC(cQuery)
   Enddo
   CONT->(dbCloseArea())
Endif


// ECF
/*SX2->(DbSeek('ECF'))
cArqSQL := AllTrim(SX2->X2_ARQUIVO)

If TCCANOPEN(cArqSQL)
   IncProc("Limpando Tabela "+cArqSQL, 7)
   cQuery := 'SELECT MAX(R_E_C_N_O_) RECNO FROM ' + cArqSQL
   dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)
   nCont := 1
   // APAGA A CADA 1024 PARA NÃO ENCHER O LOG DO BANCO!
   While nCont <= CONT->RECNO
      cQuery := "DELETE FROM " + cArqSQL
      cQuery := cQuery + " WHERE R_E_C_N_O_ between "+Str(nCont)+" AND "+Str(nCont+1024)
      cQuery := cQuery + " AND ECF_NR_CON IN ('0000','9999')"
	  nCont := nCont + 1024
   	  TCSQLEXEC(cQuery)
   Enddo
   CONT->(dbCloseArea())
Endif
*/

// ECG
/*SX2->(DbSeek('ECG'))
cArqSQL := AllTrim(SX2->X2_ARQUIVO)

If TCCANOPEN(cArqSQL)
   IncProc("Limpando Tabela "+cArqSQL, 8)
   cQuery := 'SELECT MAX(R_E_C_N_O_) RECNO FROM ' + cArqSQL
   dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)
   nCont := 1
   // APAGA A CADA 1024 PARA NÃO ENCHER O LOG DO BANCO!
   While nCont <= CONT->RECNO
      cQuery := "DELETE FROM " + cArqSQL
      cQuery := cQuery + " WHERE R_E_C_N_O_ between "+Str(nCont)+" AND "+Str(nCont+1024)
      cQuery := cQuery + " AND ECG_NR_CON IN ('0000','9999')"
	  nCont := nCont + 1024
   	  TCSQLEXEC(cQuery)
   Enddo
   CONT->(dbCloseArea())
Endif
*/
Return                                               


STATIC FUNCTION GRVEC4()

Local cFilEC2 := xFilial("EC2"), cFilEC4 := xFilial("EC4"),MConta:=0

EC2->(DbSetOrder(1))       
EC4->(DbSetOrder(1))       

nTotEC2:=EC2->(LastRec())
ProcRegua( nTotEC2 )
                                                                       
EC2->(DbSeek(cFilEC2, .T.))

Do While EC2->(!Eof()) .And. EC2->EC2_FILIAL = cFilEC2                        
   MConta+=1
   IncProc("Acertando DI´s (201): "+Alltrim(Str(MConta))+"/"+Alltrim(Str(nTotEC2)))

   If !Empty(EC2->EC2_TX_DI) 
      If !EC4->(DbSeek(cFilEC4+EC2->EC2_HAWB+EC2->EC2_FORN+EC2->EC2_MOEDA+EC2->EC2_IDENTC+"201"))                       
         Reclock("EC2", .F.)
         EC2->EC2_DI_NUM := SPACE(LEN(EC2->EC2_DI_NUM))
         EC2->EC2_TX_DI  := 0  
         EC2->(MsUnlock())
      Endif
   Endif
   
   EC2->(DbSkip())
Enddo             

Return 
/*
*-----------------*
// Substituido pelo assistente de conversao do AP5 IDE em 01/12/99 ==> Function CR200LOCK
Static Function CR200LOCK()
*-----------------*
SYSREFRESH()
cAliasLock := Alias()
lRetLock:=.T.
lRetLock:=Reclock(cTravaAlias,lTrava)
DbSelectArea( cAliasLock )
Return lRetLock             */

//** AAF 08/01/08 - Execucao por Schedule
*---------------------------------------*
STATIC FUNCTION IVMsgAlert(cMsg,cTitulo)
*---------------------------------------*

If Type("lScheduled") == "L" .AND. lScheduled
   AvE_Msg(cTitulo + " - " + cMsg,1)
Else
   MSGALERT(cMsg,cTitulo)
EndIf

Return
//**

//FSM - 24/10/2012

Static Function GetDt(cDt)
Local dDt := SW6->(&(GetCpoDt(cDt)))

If dDt > dFimEncerra
   dDt := CToD("  /  /  ")
EndIf

Return dDt

Static Function GetCpoDt(cDt)
Local cRet     := ""
Local cMv      := ""
Local cDefault := ""

If cDt == "INICIO"
   cMv      := "MV_ECO0001"  //Inicio de Transito / compensação
   cDefault := "2"    //Embarque
ElseIf cDt == "FIM"
   cMv      := "MV_ECO0002" //Fim de Transito
   cDefault := "4"    //Encerramento
EndIf

If !Empty(cMv)
   If GetMV(cMv,,cDefault) == "1" //Encerramento
      cRet   := "W6_DT_ENCE"
   ElseIf GetMV(cMv,,cDefault) == "2" //Embarque
      cRet   := "W6_DT_EMB"
   ElseIf GetMV(cMv,,cDefault) == "3" //Registro DI
      cRet   := "W6_DTREG_D"
   ElseIf GetMV(cMv,,cDefault) == "4" //Emissão NF
      cRet   := "W6_DT_NF"
   ElseIf GetMV(cMv,,cDefault) == "5" //Data de Entrega
      cRet   := "W6_DT_ENTR"
   EndIf
EndIf

Return cRet
