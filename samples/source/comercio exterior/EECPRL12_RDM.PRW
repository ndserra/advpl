#INCLUDE "EECPRL12.ch"

/*
Programa        : EECPRL12.PRW
Objetivo        : Demonstr.Mercadorias Faturadas e não embarcadas
Autor           : Cristiane C. Figueiredo
Data/Hora       : 04/06/2000 10:40
Obs.            :

*/
#include "EECRDM.CH"

/*
Funcao      : EECPRL12
Parametros  : 
Retorno     : 
Objetivos   : Ajustar o relatório para a versão 811 - Release 4
Autor       : Juliano Paulino Alves - JPA
Data 	    : 26/07/2006
Revisao     :
Obs.        :
*/
**********************
User Function EECPRL12
**********************
lRet := EECP12R3(.T.)
RETURN lRet

/*
Funcao      : EECP12R3
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 04/06/2000 10:40
Obs.        :
Revisao     : Juliano Paulino Alves
Data 	    : 26/07/2006
*/
*--------------------------------------------------------------------
Static Function EECP12R3(p_R4)
LOCAL lRET := .F.,;
      lEECFAT := IsIntFat(),; // ** By JBJ 29/05/02 - GetMV("MV_EECFAT"),;
      aORD    := SaveOrd({"EE8","EEM","EEC","EEB","EE7"})
      
//JPA - 26/07/2006 - Relatório Personalizavel - Release 4
Private oReport
Private lR4   := If(p_R4 == NIL,.F.,.T.) .AND. FindFunction("TRepInUse") .And. TRepInUse()
*

lRET := IF(!lEECFAT,EECPRL12B(),EECPRL12A())
RESTORD(aORD)
RETURN(lRET)
*--------------------------------------------------------------------
STATIC FUNCTION EECPRL12A
LOCAL oDLG,nOPC,bOK,bCANCEL,aTIPO,cARQRPT,cTITRPT,cQRY,lZERO,;
      cNOMDBFC,aCMPC,aCMPD,aARQS,aSEMSX3,cTEMP,cCONDEEC,cPERIODO,oPanel
PRIVATE cCONDSD2,aCAMPOS := {},aHEADER := {},dDATAI,dDATAF,lTOP, cTIPO
*
#IFDEF TOP
   IF TCSRVTYPE() <> "AS/400"
      lTOP := .T.
   ELSE
#ENDIF
      lTOP := .F.
#IFDEF TOP
   ENDIF
#ENDIF
aTIPO   := {STR0009,STR0010} //"1-Nao Embarcadas"###"2-Embarcadas"
bOK     := {|| nOPC := 1,oDlg:End()}
bCANCEL := {|| nOPC := 0,oDlg:End()}
dDATAI  := dDATAF := CTOD("  /  /  ")
cTIPO   := " "
nOPC    := 0
DEFINE MSDIALOG oDLG TITLE STR0011 From 9,0 To 17,50 Of oMainWnd //"Relatorio de Mercadorias Faturadas"

   oPanel:= TPanel():New(0, 0, "",oDlg,, .F., .F.,,, 50, 17)
   // GFP - 29/08/2012 - Ajuste de posicionamento das informações na tela.
   @  /*12*/06,05 SAY STR0012 PIXEL Of oPanel //"Tipo do Relatorio"
   @  /*12*/06,50 COMBOBOX cTIPO ITEMS aTIPO SIZE 60,8 PIXEL Of oPanel

   @  /*25*/19,05 SAY STR0004      PIXEL Of oPanel //"Data Inicial"
   @  /*25*/19,50 MSGET dDATAI SIZE 40,8  PIXEL Of oPanel
   @  /*38*/32,05 SAY STR0005        PIXEL  Of oPanel//"Data Final"
   @  /*38*/32,50 MSGET dDATAF SIZE 40,8  PIXEL of oPanel

   oPanel:Align:= CONTROL_ALIGN_ALLCLIENT
   
ACTIVATE MSDIALOG oDLG ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED

If lR4
   oReport := ReportDef()
EndIf

IF nOPC = 1
   cSEQREL := GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()   
   cArqRpt  := "REL12I.RPT"
   cTitRpt  := STR0011 //"Relatorio de Mercadorias Faturadas"
   cNOMDBFC := "WORK12CI"
   aCMPC    := {{"SEQREL" ,"C",008,0},;
                {"TITULO" ,"C",100,0},;
                {"PERIODO","C",100,0}}
   cNOMDBFD := "WORK12DI"
   aCMPD    := {{"SEQREL"  ,"C",008                           ,0},;
                {"FASE"    ,"C",003                           ,0},;
                {"PROCESSO","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;
                {"NFISCAL" ,"C",AVSX3("EE9_NF"    ,AV_TAMANHO),0},;
                {"DATANF"  ,"C",010                           ,0},;
                {"CLIENTE" ,"C",AVSX3("EEC_IMPODE",AV_TAMANHO),0},;
                {"PRODUTO" ,"C",AVSX3("B1_DESC"   ,AV_TAMANHO),0},;
                {"QTDE"    ,"N",AVSX3("D2_QTDE"   ,AV_TAMANHO),AVSX3("D2_QTDE"  ,AV_DECIMAL)},;
                {"PRECO"   ,"N",AVSX3("D2_PRUNIT" ,AV_TAMANHO),AVSX3("D2_PRUNIT",AV_DECIMAL)},;
                {"TOTAL"   ,"N",AVSX3("D2_TOTAL"  ,AV_TAMANHO),AVSX3("D2_TOTAL" ,AV_DECIMAL)},;
                {"DTPREVEM","C",010                           ,0},;
                {"DTEMBARQ","C",010                           ,0},;
                {"FLAG"    ,"C",001                           ,0}}
   aARQS    := {{cNOMDBFC,aCMPC,"CAB","SEQREL"},;
                {cNOMDBFD,aCMPD,"DET","SEQREL"}}
   aRETCRW  := CRWNEWFILE(aARQS)
   *
   cCONDEEC := IF(LEFT(cTIPO,1)="1","        ","00000000")
   IF ! EMPTY(dDATAI) .AND. ! EMPTY(dDATAF)                               
      cCONDSD2 := IF(lTOP,"SD2.D2_EMISSAO >= '"+DTOS(dDATAI)+"' AND SD2.D2_EMISSAO <= '"+DTOS(dDATAF)+"'",;
                          "SD2->(DTOS(D2_EMISSAO) >= DTOS(dDATAI) .AND. DTOS(D2_EMISSAO) <= DTOS(dDATAF))")
      cPERIODO := STR0013+DTOC(dDATAI)+STR0014+DTOC(dDATAF) //"DE "###" ATE "
   ELSEIF ! EMPTY(dDATAI) .AND. EMPTY(dDATAF)
          cCONDSD2 := IF(lTOP,"SD2.D2_EMISSAO >= '"+DTOS(dDATAI)+"'",;
                              "(DTOS(SD2->D2_EMISSAO) >= DTOS(dDATAI))")
          cPERIODO := STR0015+DTOC(dDATAI) //"A PARTIR DE "
   ELSEIF EMPTY(dDATAI) .AND. ! EMPTY(dDATAF)   
          cCONDSD2 := IF(lTOP,"SD2.D2_EMISSAO <= '"+DTOS(dDATAF)+"'",;
                              "DTOS(SD2->D2_EMISSAO) <= DTOS(dDATAF)")
          cPERIODO := STR0016+DTOC(dDATAF) //"ATE "
   ELSE
      cCONDSD2 := IF(lTOP,"",".T.")
      cPERIODO := STR0017 //"TODOS"
   ENDIF
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         cCONDEEC := IF(EMPTY(cCONDEEC),"=",">")
         cQRY := "SELECT 'E'             AS FASE, "    +;
                        "EE9.EE9_PREEMB  AS PROCESSO, "+;
                        "EE9.EE9_NF      AS NFISCAL, " +;
                        "SD2.D2_EMISSAO  AS DATANF, "  +;
                        "EEC.EEC_IMPODE  AS CLIENTE, " +;
                        "SB1.B1_DESC     AS PRODUTO, " +;
                        "SD2.D2_QUANT    AS QTDE, "    +;
                        "SD2.D2_PRCVEN   AS PRECO, "   +;
                        "SD2.D2_TOTAL    AS TOTAL, "   +;
                        "EEC.EEC_ETD     AS DTPREVEM, "+;
                        "EEC.EEC_DTEMBA  AS DTEMBARQ " +;
                 "FROM "+RETSQLNAME("EEC")+" EEC, "+RETSQLNAME("EE9")+" EE9, "+;
                         RETSQLNAME("EE7")+" EE7, "+RETSQLNAME("EE8")+" EE8, "+;
                         RETSQLNAME("SD2")+" SD2, "+RETSQLNAME("SB1")+" SB1 " +;
                 "WHERE EEC.EEC_FILIAL = '"+XFILIAL("EEC")+"' AND " +;
                       "EEC.EEC_DTEMBA "+cCONDEEC+" '        ' AND "+;
                       "EEC.EEC_STATUS <> '*'       AND "           +;
                       "EEC.D_E_L_E_T_ <> '*'       AND "           +;
                       "EEC.EEC_PREEMB = EE9.EE9_PREEMB AND "       +;
                       "EE9.EE9_FILIAL = '"+XFILIAL("EE9")+"' AND " +;
                       "EE9.D_E_L_E_T_ <> '*' AND "                 +;
                       "EE9.EE9_PEDIDO = EE7.EE7_PEDIDO AND "       +;
                       "EE7.EE7_FILIAL = '"+XFILIAL("EE7")+"' AND " +;
                       "EE7.D_E_L_E_T_ <> '*' AND "                 +;
                       "EE9.EE9_PEDIDO = EE8.EE8_PEDIDO AND "       +;
                       "EE9.EE9_SEQUEN = EE8.EE8_SEQUEN AND "       +;
                       "EE8.EE8_FILIAL = '"+XFILIAL("EE8")+"' AND " +;
                       "EE8.D_E_L_E_T_ <> '*' AND "                 +;
                       "EE7.EE7_PEDFAT = SD2.D2_PEDIDO AND "        +;
                       "EE8.EE8_FATIT  = SD2.D2_ITEMPV AND "        +;
                       "SD2.D2_FILIAL  = '"+XFILIAL("SD2")+"' AND " +;
                       "SD2.D2_SERIE   = EE9.EE9_SERIE AND "        +;
                       "SD2.D2_DOC     = EE9.EE9_NF    AND "        +;
                       cCONDSD2+IF(EMPTY(cCONDSD2),""," AND ")      +;
                       "SD2.D_E_L_E_T_ <> '*'          AND "        +;
                       "EE9.EE9_COD_I  = SB1.B1_COD AND "           +;
                       "SB1.B1_FILIAL  = '"+xFilial("SB1")+"' AND " +;
                       "SB1.D_E_L_E_T_ <> '*' "
         IF LEFT(cTIPO,1) = "1"
            cQRY := cQRY+"UNION "                         +;
                    "SELECT 'P'             AS FASE, "    +;
                           "EE7.EE7_PEDIDO  AS PROCESSO, "+;
                           "SD2.D2_DOC      AS NFISCAL, " +;
                           "SD2.D2_EMISSAO  AS DATANF, "  +;
                           "EE7.EE7_IMPODE  AS CLIENTE, " +;
                           "SB1.B1_DESC     AS PRODUTO, " +;
                           "SD2.D2_QUANT    AS QTDE, "    +;
                           "SD2.D2_PRCVEN   AS PRECO, "   +;
                           "SD2.D2_TOTAL    AS TOTAL, "   +;
                           "EE8.EE8_DTPREM  AS DTPREVEM, "+;
                           "' '             AS DTEMBARQ " +;
                    "FROM "+RETSQLNAME("EE7")+" EE7, "+;
                            RETSQLNAME("EE8")+" EE8, "+;
                            RETSQLNAME("SD2")+" SD2, "+;
                            RETSQLNAME("SB1")+" SB1 " +;
                    "WHERE EE7.EE7_FILIAL = '"+XFILIAL("EE7")+"' AND "+;
                          "EE7.EE7_STATUS <> '*' AND "                +;
                          "EE7.D_E_L_E_T_ = ' ' AND "                 +;
                          "EE7.EE7_PEDIDO = EE8.EE8_PEDIDO AND "      +;
                          "EE8.EE8_FILIAL = '"+XFILIAL("EE8")+"' AND "+;
                          "EE8.EE8_SLDATU > 0 AND "                   +;
                          "EE8.D_E_L_E_T_ = ' ' AND "                 +;
                          "EE7.EE7_PEDFAT = SD2.D2_PEDIDO AND "       +;
                          "EE8.EE8_FATIT  = SD2.D2_ITEMPV AND "       +;
                          "SD2.D2_FILIAL  = '"+XFILIAL("SD2")+"' AND "+;
                          "SD2.D2_PREEMB  = '' AND "                  +;
                          "SD2.D2_DOC     <> '' AND "                 +;
                          cCONDSD2+IF(EMPTY(cCONDSD2),""," AND ")     +;
                          "SD2.D_E_L_E_T_ <> '*' AND "                +;
                          "EE8.EE8_COD_I = SB1.B1_COD AND "           +;
                          "SB1.B1_FILIAL = '"+XFILIAL("SB1")+"' AND " +;
                          "SB1.D_E_L_E_T_ = ' ' AND "                     +;
                          "SD2.D2_DOC NOT IN "                            +;
                          "(SELECT EEM_NRNF FROM "+RETSQLNAME("EEM")+" "  +;
                          "WHERE EEM_FILIAL = '" + XFILIAL("EEM")+"' AND "+;
                          "D_E_L_E_T_ <> '*') "
         ENDIF
         cQRY := cQRY+"ORDER BY PROCESSO"
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQRY)), "QRY", .F., .T.)
      ELSE
   #ENDIF
         EEC->(DBSETORDER(12))
         EEC->(DBSEEK(XFILIAL("EEC")+cCONDEEC,.T.))
         cCONDEEC := IF(EMPTY(cCONDEEC)," ","!")+"EMPTY(EEC->EEC_DTEMBA)"
         aSEMSX3  := {{"FASE"    ,"C",003                           ,0},;
                      {"PROCESSO","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;
                      {"NFISCAL" ,"C",AVSX3("EE9_NF"    ,AV_TAMANHO),0},;
                      {"DATANF"  ,"C",008                           ,0},;
                      {"CLIENTE" ,"C",AVSX3("EEC_IMPODE",AV_TAMANHO),0},;
                      {"PRODUTO" ,"C",AVSX3("B1_DESC"   ,AV_TAMANHO),0},;
                      {"QTDE"    ,"N",AVSX3("D2_QTDE"   ,AV_TAMANHO),AVSX3("D2_QTDE"  ,AV_DECIMAL)},;
                      {"PRECO"   ,"N",AVSX3("D2_PRUNIT" ,AV_TAMANHO),AVSX3("D2_PRUNIT",AV_DECIMAL)},;
                      {"TOTAL"   ,"N",AVSX3("D2_TOTAL"  ,AV_TAMANHO),AVSX3("D2_TOTAL" ,AV_DECIMAL)},;
                      {"DTPREVEM","C",008                           ,0},;
                      {"DTEMBARQ","C",008                           ,0}}
         cTEMP   := E_CRIATRAB(,aSemSX3,"QRY")
         INDREGUA("QRY",cTEMP+OrdBagExt(),"PROCESSO+NFISCAL","AllwayTrue()","AllwaysTrue()",STR0018) //"Processando Arquivo Temporario"
         SET INDEX TO (cTEMP+OrdBagExt())
         // EEC
         DO WHILE ! EEC->(EOF()) .AND. EEC->EEC_FILIAL = XFILIAL("EEC") .AND. &cCONDEEC
            IF EEC->EEC_STATUS # ST_PC
               EE9->(DBSETORDER(3))
               EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
               DO WHILE ! EE9->(EOF()) .AND.;
                  EE9->(EE9_FILIAL+EE9_PREEMB) = (XFILIAL("EE9")+EEC->EEC_PREEMB)
                  *
                  EE7->(DBSETORDER(1))
                  IF (EE7->(DBSEEK(XFILIAL("EE7")+EE9->EE9_PEDIDO)))
                     EE8->(DBSETORDER(1))
                     IF (EE8->(DBSEEK(XFILIAL("EE8")+EE9->(EE9_PEDIDO+EE9_SEQUEN))))
                        SD2->(DBSETORDER(8))
                        SD2->(DBSEEK(XFILIAL("SD2")+EE7->EE7_PEDFAT+EE8->EE8_FATIT))
                        DO WHILE ! SD2->(EOF()) .AND.;
                           SD2->(D2_FILIAL+D2_PEDIDO+D2_ITEMPV) = (XFILIAL("SD2")+EE7->EE7_PEDFAT+EE8->EE8_FATIT)
                           *
                           IF SD2->(D2_SERIE+D2_DOC) = EE9->(EE9_SERIE+EE9_NF) .AND. &cCONDSD2
                              PRL12QRY(EE9->EE9_COD_I,EE9->EE9_PREEMB,EE9->EE9_NF,EEC->EEC_IMPODE,EEC->EEC_ETD,EEC->EEC_DTEMBA,"E")
                              EXIT
                           ENDIF
                           SD2->(DBSKIP())
                        ENDDO
                     ENDIF
                  ENDIF
                  EE9->(DBSKIP())
               ENDDO
            ENDIF
            EEC->(DBSKIP())
         ENDDO
         IF LEFT(cTIPO,1) = "1"  &&& NAO EMBARCADOS
            EE7->(DBSETORDER(1))
            EE7->(DBSEEK(XFILIAL("EE7")))
            DO WHILE ! EE7->(EOF()) .AND. EE7->EE7_FILIAL = XFILIAL("EE7")
               IF EE7->EE7_STATUS # ST_PC
                  EE8->(DBSETORDER(1))
                  EE8->(DBSEEK(XFILIAL("EE8")+EE7->EE7_PEDIDO))
                  DO WHILE ! EE8->(EOF()) .AND.;
                     EE8->(EE8_FILIAL+EE8_PEDIDO) = (XFILIAL("EE8")+EE7->EE7_PEDIDO)
                     *
                     IF ! EMPTY(EE8->EE8_SLDATU) // ** Processos com saldo 
                        SD2->(DBSETORDER(8))
                        SD2->(DBSEEK(XFILIAL("SD2")+AVKEY(EE7->EE7_PEDFAT,"D2_PEDIDO")+EE8->EE8_FATIT))
                        DO WHILE ! SD2->(EOF()) .AND.;
                           SD2->(D2_FILIAL+D2_PEDIDO+D2_ITEMPV) = (XFILIAL("SD2")+AVKEY(EE7->EE7_PEDFAT,"D2_PEDIDO")+EE8->EE8_FATIT)
                           *
                           // ** Nota fiscal nao vinculada a processo                     
                           IF SD2->(EMPTY(D2_PREEMB) .AND. ! EMPTY(D2_DOC)) .AND. &cCONDSD2
                              PRL12QRY(EE8->EE8_COD_I,EE7->EE7_PEDIDO,SD2->D2_DOC,EE7->EE7_IMPODE,EE8->EE8_DTPREM,CTOD("  /  /  "),"P")
                              EXIT
                           ENDIF
                           SD2->(DBSKIP())
                        ENDDO
                     ENDIF
                     EE8->(DBSKIP())
                  ENDDO
               ENDIF  
               EE7->(DbSkip())
            ENDDO
         ENDIF
   #IFDEF TOP
      ENDIF
   #ENDIF
   QRY->(DBGOTOP())
   IF QRY->(EOF() .OR. BOF())
      MSGINFO(STR0019,STR0003) //"Intervalo sem dados p/ impressao"###"Aviso"
      lZERO := .T.
   ELSE
      PROCESSA({|| PRL12IMP(cTIPO,cPERIODO) })
      lZERO := .F.
   ENDIF
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         QRY->(DBCLOSEAREA())
      ELSE
   #ENDIF
         QRY->(E_EraseArq(cTEMP))
   #IFDEF TOP
      ENDIF
   #ENDIF
   IF ! lZERO
      If lR4   //JPA - 26/07/2006
         oReport:PrintDialog()
         CrwCloseFile(aRetCrw,.T.)
      Else                    
         CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
      EndIf
   ELSE
      CrwCloseFile(aRetCrw,.T.)
   ENDIF
ENDIF
RETURN(.F.)
*--------------------------------------------------------------------
STATIC FUNCTION EECPRL12B
Local lRet := .T.
Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw, lZero := .t.
Local nMesAnt, nAnoAnt, dDataAnt, cDescPro // nContaCol, cDescPro1

Private dDtIni   := AVCTOD("  /  /  ")                
Private dDtFim   := AVCTOD("  /  /  ")                
Private cResp    := SPACE(AVSX3("EE3_NOME",3))      
Private dData    := DDATABASE                       

Begin Sequence

   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("61","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("61","EEA_COD"),"EEA_TITULO"))
   Endif
   
   cNomDbfC:= "WORK12C"
   aCamposC:= {}
   AADD(aCamposC,{"SEQREL" ,"C", 8,0})
   AADD(aCamposC,{"MES"    ,"C",14,0})
   AADD(aCamposC,{"RESP"   ,"C",60,0})
   AADD(aCamposC,{"XDATA"   ,"D", 8,0})


   cNomDbfD:= "WORK12D"
   aCamposD:= {}
   AADD(aCamposD,{"SEQREL" ,"C", 8,0})
   AADD(aCamposD,{"NRNF"   ,"C",20,0})
   AADD(aCamposD,{"DTEMIS" ,"D", 8,0})
   AADD(aCamposD,{"CLIENTE","C",30,0})
   AADD(aCamposD,{"PRODUTO","M",10,0})
   AADD(aCamposD,{"QTDE"   ,"N",10,2})
   AADD(aCamposD,{"DTEMBEF","D", 8,0})
   AADD(aCamposD,{"DTEMBPR","D", 8,0})
   AADD(aCamposD,{"VLRNF"  ,"N",15,2})
   AADD(aCamposD,{"CRUZE"  ,"C",30,0})


   aArqs := {}
   AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
   AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

   aRetCrw := crwnewfile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   SysRefresh()
   
   lZero := .t.
   EEM->(DBGOTOP())
   While EEM->(!Eof() .And. EEM->EEM_FILIAL==xFilial("EEM"))
     
     EEC->(DBSETORDER(1))
     EEC->(DBSEEK(XFILIAL("EEC")+EEM->EEM_PREEMB))
     
     EE9->(DBSETORDER(2))
     EE9->(DBSEEK(XFILIAL("EE9")+EEM->EEM_PREEMB))
     
     IF ( EMPTY(EEM->EEM_DTNF)) .or. dDtIni > EEM->EEM_DTNF .OR. IF(EMPTY(dDtFim),.f.,dDtFim < EEM->EEM_DTNF)
         EEM->(DBSKIP())
         LOOP
     ENDIF                  
     IF ( !EMPTY(EE9->EE9_DTAVRB) .OR. EEM->EEM_TIPONF<>"1" .or. EMPTY(EEM->EEM_DTNF))
        EEM->(DBSKIP())
        Loop 
     ENDIF
        
     DET->(DBAPPEND())
     DET->SEQREL    := cSeqRel 
     DET->NRNF      := EEM->EEM_NRNF
     DET->DTEMIS    := EEM->EEM_DTNF
     DET->CLIENTE   := EEC->EEC_IMPODE
     DET->QTDE      := EEC->EEC_PESLIQ
     DET->DTEMBEF   := EEC->EEC_DTEMBA
     DET->DTEMBPR   := IF(EMPTY(EEC->EEC_DTCONH),EEC->EEC_ETA,AVCTOD("  /  /  "))
     DET->VLRNF     := EEM->EEM_VLNF
     IF EMPTY(EE9->EE9_DTAVRB) .AND. !EMPTY(EEC->EEC_DTEMBA)
        DET->CRUZE  := STR0001 //"AGUARDANDO CRUZE EM FONTEIRA"
     ENDIF   
     cDescPro       := MSMM(EEC->EEC_DSCGEN,AVSX3("EEC_GENERI",3))
/*   cDescPro1      := MEMOLINE(cDescPro,25,1)
     nContaCol      := 1
     Do while !empty(cDescPro1)  
        if nContaCol > 1
           DET->(DBAPPEND())
           DET->SEQREL    := cSeqRel 
        endif
        DET->PRODUTO := cDescPro1
        nContaCol    := nContaCol + 1
        cDescPro1      := MEMOLINE(cDescPro,25,nContaCol)
     Enddo     */
     DET->PRODUTO := cDescPro
     lZero := .f.
     
     EEM->(DBSKIP())
   Enddo   
  
   IF ( lZero )
      MSGINFO(STR0002, STR0003) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   ELSE
      CAB->(DBAPPEND())
      nMESANT := MONTH(dDATA) - 1
      nAnoAnt := Year(dData)
      IF MONTH(dDATA) == 1
         cMESANT := 12
         nAnoAnt := Year(dData) - 1
      Endif   
      dDataAnt   := AVCTOD(strzero(day(dData),2)+"/"+strzero(nMesAnt,2)+"/"+strzero(nAnoAnt,4))
      CAB->SEQREL:= cSeqRel 
      CAB->MES   := ALLTRIM(cMONTH(dDataAnt)+"/"+STR(YEAR(dDataAnt),4))
      CAB->RESP  := cResp
      CAB->XDATA  := dData 
      CAB->(MSUNLOCK())
   ENDIF
   
     
End Sequence

IF ( lRet )
   If !lR4   //JPA - 26/07/2006
      oReport := ReportDef()
      oReport:PrintDialog()
      CrwCloseFile(aRetCrw,.T.)
   Else
      lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   EndIf
ELSE
   // Fecha e apaga os arquivos temporarios
   CrwCloseFile(aRetCrw,.T.)
ENDIF


Return .f.
         
//----------------------------------------------------------------------
Static Function TelaGets

   Local lRet  := .f.

   Local oDlg

   Local nOpc := 0
   Local bOk  := {|| nOpc:=1, oDlg:End() }
   Local bCancel := {|| oDlg:End() }
   Local oPanel // GFP - 29/08/2012
      
   Begin Sequence
      
      // GFP - 29/08/2012 - Ajuste de posicionamento das informações na tela. 
      DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 20,50 OF oMainWnd
      
      oPanel := TPanel():New(0, 0, "",oDlg,, .F., .F.,,, 50, 17)
      
      @  /*20*/12,05 SAY STR0004 PIXEL of oPanel //"Data Inicial"
      @  /*20*/12,60 MSGET dDtIni SIZE 40,8 PIXEL of oPanel 
      
      @  /*33*/25,05 SAY STR0005  PIXEL of oPanel //"Data Final"
      @  /*33*/25,60 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim, dDtIni) PIXEL of oPanel 
      
      @  /*46*/38,05 SAY STR0006 PIXEL of oPanel //"Feito por"
      @  /*46*/38,60 MSGET cResp SIZE 115,8 F3 "E33" PIXEL of oPanel                   
                                                            
      @  /*59*/51,05 SAY STR0007  PIXEL of oPanel //"Data"
      @  /*59*/51,60 MSGET dData SIZE 40,8 PIXEL of oPanel 
      
      oPanel:Align:= CONTROL_ALIGN_ALLCLIENT
      
      ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED

      IF nOpc == 1
         lret := .t.
      ENDIF
      
   End Sequence

   Return lRet
   

/*
Funcao      : fConfData
Parametros  : Data Final, Data Inicial
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 28/08/2000 11:00       
Revisao     :
Obs.        :
*/
Static Function fConfData(dFim,dIni)

Local lRet  := .f.

Begin Sequence
      
   if !empty(dFim) .and. dFim < dIni
      MsgInfo(STR0008,STR0003) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
   Else
      lRet := .t.
   Endif   

End Sequence
      
Return lRet
*--------------------------------------------------------------------
STATIC FUNCTION PRL12QRY(cP_ITEM,cP_PROC,cP_NOTA,cP_IMPO,cP_DTPR,cP_DTEM,cP_FASE)
cP_ITEM := IF(cP_ITEM=NIL,"",cP_ITEM)
cP_PROC := IF(cP_PROC=NIL,"",cP_PROC)
cP_NOTA := IF(cP_NOTA=NIL,"",cP_NOTA)
cP_IMPO := IF(cP_IMPO=NIL,"",cP_IMPO)
cP_DTPR := IF(cP_DTPR=NIL,"",DTOS(cP_DTPR))
cP_DTEM := IF(cP_DTEM=NIL,"",DTOS(cP_DTEM))
cP_FASE := IF(cP_FASE=NIL,"",cP_FASE)
*
SB1->(DBSETORDER(1))
SB1->(DBSEEK(XFILIAL("SB1")+cP_ITEM))
QRY->(DBAPPEND())
QRY->FASE     := cP_FASE
QRY->PROCESSO := cP_PROC
QRY->NFISCAL  := cP_NOTA
QRY->DATANF   := DTOS(SD2->D2_EMISSAO)
QRY->CLIENTE  := cP_IMPO
QRY->PRODUTO  := SB1->B1_DESC
QRY->QTDE     := SD2->D2_QUANT
QRY->PRECO    := SD2->D2_PRCVEN
QRY->TOTAL    := SD2->D2_TOTAL
QRY->DTPREVEM := cP_DTPR
QRY->DTEMBARQ := cP_DTEM
RETURN(NIL)
*--------------------------------------------------------------------
STATIC FUNCTIO PRL12IMP(cP_TITU,cP_PERI)
LOCAL cFLAG := "",cPROCESSO := "",cCHAVE := ""
CAB->(DBAPPEND())
CAB->SEQREL  := cSEQREL
CAB->TITULO  := SUBSTR(cP_TITU,3)
CAB->PERIODO := cP_PERI
QRY->(DBGOTOP())
DO WHILE ! QRY->(EOF())       
   IncProc(STR0020+QRY->PROCESSO) //"Imprimindo:"
   IF cPROCESSO # QRY->PROCESSO
      cFLAG := IF(cFLAG="2","1","2")
      cPROCESSO := QRY->PROCESSO
   ENDIF
   DET->(DBAPPEND())
   DET->SEQREL   := cSEQREL
   IF cCHAVE # QRY->(PROCESSO+NFISCAL)
      cCHAVE := QRY->(PROCESSO+NFISCAL)
      DET->FASE     := QRY->FASE
      DET->PROCESSO := QRY->PROCESSO
      DET->NFISCAL  := QRY->NFISCAL
      DET->DATANF   := TRANSDATA(QRY->DATANF)
      DET->CLIENTE  := QRY->CLIENTE
   ENDIF
   DET->PRODUTO  := QRY->PRODUTO
   DET->QTDE     := QRY->QTDE
   DET->PRECO    := QRY->PRECO
   DET->TOTAL    := QRY->TOTAL
   DET->DTPREVEM := TRANSDATA(QRY->DTPREVEM)
   DET->DTEMBARQ := TRANSDATA(QRY->DTEMBARQ)
   DET->FLAG     := cFLAG
   QRY->(DBSKIP())
ENDDO
RETURN(NIL)
*--------------------------------------------------------------------
STATIC FUNCTION TRANSDATA(cP_DATA)
cP_DATA := IF(EMPTY(cP_DATA),"  /  /  ",;
                         RIGHT(cP_DATA,2)+"/"+SUBSTR(cP_DATA,5,2)+"/"+LEFT(cP_DATA,4))
RETURN(cP_DATA)
*--------------------------------------------------------------------

//JPA - 26/07/2006 - Definições do relatório personalizável
****************************
Static Function ReportDef()
****************************
Local lFat    := IsIntFat()
Local cTitulo := "Demonstrativos de Mercadorias Faturadas"
Local cEmbarc := " - Embarcadas"
Local cNaoEmb := " - Não Embarcadas"
Local cDescr  := "Este relatorio irá exibir uma estatística sobre Mercadorias Faturadas"
//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas := {"EE9", "EEC"}

If lFat   
   AADD(aTabelas, "SD2")
   AADD(aTabelas, "SB1")
Else
   AADD(aTabelas, "EEM")
EndIf

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := {}

//Parâmetros:            Relatório , Titulo ,  Pergunte , Código de Bloco do Botão OK da tela de impressão.
oReport := TReport():New("EECPRL12", cTitulo + If(cTipo == "2-Embarcadas",cEmbarc,cNaoEmb),"", {|oReport| ReportPrint(oReport)}, cDescr)

//ER - 20/10/2006 - Inicia o relatório como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.

//Define o objeto com a seção do relatório
oSecao1 := TRSection():New(oReport,"Seção 1",aTabelas,aOrdem)

If lFat
   //Definição das colunas de impressão da seção 1
   TRCell():New(oSecao1,"FASE"    , "DET", "Fase"       , /*Picture*/        , 003                           , /*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New(oSecao1,"PROCESSO", "DET", "Processo"   , /*Picture*/        , AVSX3("EEC_PREEMB",AV_TAMANHO), /*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New(oSecao1,"NFISCAL" , "DET", "Nota F."    , /*Picture*/        , AVSX3("EE9_NF"    ,AV_TAMANHO), /*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New(oSecao1,"DATANF"  , "DET", "Data N. F." , /*Picture*/        , 010                      	  , /*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New(oSecao1,"CLIENTE" , "DET", "Cliente"    , /*Picture*/        , 030							  , /*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New(oSecao1,"PRODUTO" , "DET", "Produto"    , /*Picture*/        , 040							  , /*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New(oSecao1,"QTDE"    , "DET", "Quantidade" , "@E 999,999,999.99", AVSX3("D2_QTDE"   ,AV_TAMANHO), /*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New(oSecao1,"PRECO"   , "DET", "Preço Unit.", "@E 999,999,999.99", AVSX3("D2_PRUNIT" ,AV_TAMANHO), /*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New(oSecao1,"TOTAL"   , "DET", "Total (R$)" , "@E 999,999,999.99", AVSX3("D2_TOTAL"  ,AV_TAMANHO), /*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New(oSecao1,"DTPREVEM", "DET", "Prev.Emb."  , /*Picture*/        , 010      	  				  , /*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New(oSecao1,"DTEMBARQ", "DET", "Dt. Emb."   , /*Picture*/        , 010 				      	  , /*lPixel*/, /*{|| code-block de impressao }*/)
EndIf

//Necessário para carregar os perguntes mv_par**
//Pergunte(oReport:uParam,.F.)

Return oReport

************************************
Static Function ReportPrint(oReport)
************************************
Local oSection := oReport:Section("Seção 1")

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 1"),"EEC",1,{|| xFilial("EEC") + EEC->EEC_PREEMB})
TRPosition():New(oReport:Section("Seção 1"),"EE9",2,{|| xFilial("EE9") + EEC->EEC_PREEMB})
TRPosition():New(oReport:Section("Seção 1"),"SD2",2,{|| xFilial("SD2") + EE7->EE7_PEDFAT + EE8->EE8_FATIT})
TRPosition():New(oReport:Section("Seção 1"),"SB1",2,{|| xFilial("SB1") + EE9->EE9_COD_I})

oReport:SetMeter(DET->(RecCount()))
DET->(dbGoTop())

//Inicio da impressão da seção 1. Sempre que se inicia a impressão de uma seção é impresso automaticamente
//o cabeçalho dela.
oReport:Section("Seção 1"):Init()

//Laço principal
Do While DET->(!EoF()) .And. !oReport:Cancel()
   oReport:Section("Seção 1"):PrintLine() //Impressão da linha
   oReport:IncMeter()                     //Incrementa a barra de progresso
   
   DET->( dbSkip() )
EndDo

//Fim da impressão da seção 1
oReport:Section("Seção 1"):Finish()                                

return .T.        
