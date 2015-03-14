#INCLUDE "EECPRL09.ch"

/*
Programa        : EECPRL09.PRW
Objetivo        : Fornecedores por Dt Embarque
Autor           : Cristiane C. Figueiredo
Data/Hora       : 02/06/2000 11:17
Obs.            :
*/

#include "EECRDM.CH"

/*
Funcao      : EECPRL09
Objetivos   : Ajustar o relatório para a versão 811 - Release 4
Autor       : Juliano Paulino Alves - JPA
Data 	    : 27/07/2006
Obs         :
Revisão     :
*/
**********************
User Function EECPRL09
**********************
lRet := U_EECP09R3(.T.)
RETURN lRet

/*
Funcao      : EECP09R3
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 02/06/2000 11:17
Obs.        :
Revisao     : Juliano Paulino Alves - Relatório personalisável - Release 4
Data/Hora   : 27/07/06 15:20
*/
User Function EECP09R3(p_R4)

Local lRet  := .T.
Local aOrd  := SaveOrd({"EE9","EEM","EEC","EEB","EE7"})
Local lZero := .t.

Local cNomDbfC, aCamposC, cNomDbfD, aCamposD, aArqs

Private dDtIni   := AVCTOD("  /  /  ")
Private dDtFim   := AVCTOD("  /  /  ")
Private cForn    := SPACE(AVSX3("A2_COD",3))
Private cFamilia := SPACE(AVSX3("YC_COD",3))
Private cRemarks := space(120)
Private cCopia   := space(120)
Private cCopia1  := space(120)
Private cArqRpt, cTitRpt

//JPA - 27/07/2006 - Relatório Personalizavel - Release 4
Private oReport
Private lR4   := If(p_R4 == NIL,.F.,.T.) .AND. FindFunction("TRepInUse") .And. TRepInUse()

cNomDbfC:= "WORK09C"
aCamposC:= {}
AADD(aCamposC,{"SEQREL","C",  8,0})
AADD(aCamposC,{"TITULO","C",240,0})
AADD(aCamposC,{"REMARK","C",120,0})
AADD(aCamposC,{"COPIA" ,"C",120,0})
AADD(aCamposC,{"COPIA1","C",120,0})

cNomDbfD:= "WORK09D"
aCamposD:= {}
AADD(aCamposD,{"SEQREL"    ,"C", 8,0})
AADD(aCamposD,{"ORDEM"     ,"C",15,0})
AADD(aCamposD,{"ORDNBR"    ,"C",20,0})
AADD(aCamposD,{"COUNTNAME" ,"C",20,0})
AADD(aCamposD,{"CUSTNAME"  ,"C",20,0})
AADD(aCamposD,{"CUSTREFNBR","C",20,0})
AADD(aCamposD,{"QTYMTSO"   ,"N",15,2})
AADD(aCamposD,{"QTYMTSS"   ,"N",15,2})
AADD(aCamposD,{"PRICEUSD"  ,"N",15,2})
AADD(aCamposD,{"TERMS"     ,"C",10,0})
AADD(aCamposD,{"TOTPRICE"  ,"N",15,2})
AADD(aCamposD,{"TOTFREI"   ,"N",15,2})
AADD(aCamposD,{"INSURAN"   ,"N",15,2})
AADD(aCamposD,{"TOTCCPRICE","N",15,2})
AADD(aCamposD,{"TERMSDD"   ,"N", 4,0})
AADD(aCamposD,{"VESTRU"    ,"C",60,0})
AADD(aCamposD,{"SHIPM"     ,"C",10,0})
AADD(aCamposD,{"ETSORI"    ,"D", 8,0})
AADD(aCamposD,{"ETADEST"   ,"D", 8,0})
AADD(aCamposD,{"BLDATE"    ,"D", 8,0})
AADD(aCamposD,{"BLNBR"     ,"C",20,0})
AADD(aCamposD,{"ATOCONC"   ,"C",10,0})

aArqs := {}
AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

Begin Sequence

   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("59","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("59","EEA_COD"),"EEA_TITULO"))
   Endif
   
   aRetCrw := CrwNewFile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif
   
   EEC->(DBSETORDER(12))
   EEC->(DBSEEK(XFILIAL("EEC")+DTOS(dDtIni),.T.))
   
   cDatas := if(DTOC(dDTIni)<>"  /  /  ",DTOC(dDTini),"")
   cDatas := cDatas + if(!empty(cDatas) .or. DTOC(dDTFim)<>"  /  /  ",STR0001,"") //" ATE "
   cDatas := cDatas + if(DTOC(dDTfim)<>"  /  /  ",DTOC(dDTFim),"")
   cTitulo:= Alltrim(cForn) + if(!empty(cforn)," -  ","")+" EXPORT REPORT "+IF(!Empty(cDatas),"- ","")+Alltrim(cDatas)
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->TITULO  := cTitulo
   CAB->REMARK  := cRemarks
   CAB->COPIA   := cCopia 
   CAB->COPIA1  := cCopia1
   CAB->(MSUNLOCK())
   
   lZero := .t.
   
   While EEC->(!Eof() .And. EEC->EEC_FILIAL==xFilial("EEC")) .and. EEC->EEC_DTEMBA >= dDtIni .And.  if(Empty(dDtFim), .T.,EEC->EEC_DTEMBA <= dDtFim)
     
      IF (!empty(cForn) .and. EEC->EEC_FORN <> cForn)
         EEC->(DBSKIP())
         Loop
      ENDIF
      
      EE9->(DBSETORDER(2))
      EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
     
      nQtdOrd  := 0
      nQtdEmb  := 0
      
      nValor   := 0
      nValorPed:= 0
      nValINC  := 0
      
      While (EE9->(!EOF() .AND. EE9->EE9_FILIAL==xFilial("EE9")) .and. EE9->EE9_PREEMB == EEC->EEC_PREEMB)
        
         IF (!Empty(cFamilia) .and. EE9->EE9_FPCOD <> cFamilia)
            EE9->(DBSKIP())
            Loop
         ENDIF
         
         nQtdEmb := nQtdEmb+ EE9->EE9_SLDINI
         nValor  := nValor + EE9->EE9_PRCINC
         nValINC := nValINC+ EE9->EE9_PRCTOT
         
         EE8->(DBSETORDER(1))
         EE8->(DBSEEK(XFILIAL("EE8")+EE9->EE9_PEDIDO+EE9->EE9_SEQUEN))
         
         nQtdOrd := nQtdOrd + EE8->EE8_SLDINI
         nValorPed:= nValorPed + EE8->EE8_PRCTOT
         
         EE9->(DBSKIP())
      Enddo
      
      IF Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1) == "7"
         cTRANSP := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA)
      Else
         cTRANSP := Posicione("EE6",1,XFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")
      Endif   
         
      DET->(DBAPPEND())
      
      DET->SEQREL    := cSeqRel 
      DET->ORDNBR    := EEC->EEC_PREEMB
      DET->COUNTNAME := POSICIONE("SYA",1,XFILIAL("SYA")+EEC->EEC_PAISET, "YA_DESCR")
      DET->CUSTNAME  := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA,"A1_NREDUZ")
      DET->CUSTREFNBR:= EEC->EEC_REFIMP
      DET->QTYMTSO   := nQtdOrd
      DET->QTYMTSS   := if(empty(EEC->EEC_DTEMBA),0,nQtdEmb)
      DET->PRICEUSD  := (nValINC/if(empty(EEC->EEC_DTEMBA),nQtdOrd,nQtdEmb))
      DET->TERMS     := EEC->EEC_INCOTE
      DET->TOTPRICE  := IF(EMPTY(EEC->EEC_DTEMBA), nValorPed, nValor)
      DET->TOTFREI   := EEC->EEC_FRPREV
      DET->INSURAN   := EEC->EEC_SEGPRE
      DET->TOTCCPRICE:= nValINC
      DET->TERMSDD   := Posicione("SY6",1,XFILIAL("SY6")+EEC->EEC_CONDPA,"Y6_DIAS_PA")
      DET->VESTRU    := cTransp
      DET->SHIPM     := POSICIONE("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_DESCR")
      DET->ETSORI    := EEC->EEC_ETA
      DET->ETADEST   := EEC->EEC_ETADES
      DET->BLDATE    := EEC->EEC_DTCONH
      DET->BLNBR     := EEC->EEC_NRCONH
      DET->ATOCONC   := EE9->EE9_ATOCON
      DET->(MSUNLOCK())
     
      lZero := .f.
     
      EEC->(DBSKIP())
   Enddo   
  
   IF ( lZero )
      MSGINFO(STR0002, STR0003) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   Else
      If lR4      //JPA - 27/07/2006
         oReport := ReportDef()
      EndIf
   ENDIF

End Sequence   

//retorna a situacao anterior ao processamento
RestOrd(aOrd)

IF ( lRet )
   If lR4   //JPA - 27/07/2006
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
         
/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 02/06/2000 11:17
Revisao     :
Obs.        :
*/
Static Function TelaGets

Local lRet  := .f.
Local nOpc  := 0
Local bOk, bCancel

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 23,50 OF oMainWnd

      @  20,05 SAY STR0004 PIXEL //"Data Inicial"
      @  20,60 MSGET dDtIni SIZE 40,8 PIXEL
      
      @  33,05 SAY STR0005 PIXEL //"Data Final"
      @  33,60 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim,dDtIni) PIXEL
      
      @  46,05 SAY STR0006 PIXEL //"Fornecedor"
      @  46,60 MSGET cForn SIZE 40,8 F3 "SA2" VALID (Vazio() .Or. ExistCpo("SA2")) PIXEL
                                                            
      // @  59,05 SAY "Família" PIXEL
      // @  59,60 MSGET cFamilia SIZE 29,8 F3 "SYC" VALID (Vazio() .Or. ExistCpo("SYC")) PIXEL

      @  59,05 SAY STR0007 PIXEL //"Remarks"
      @  59,60 MSGET cRemarks SIZE 115,8 PIXEL
      
      @  72,05 SAY "Copy To" PIXEL
      @  72,60 MSGET cCopia SIZE 115,8 PIXEL
      @  85,60 MSGET cCopia1 SIZE 115,8 PIXEL
      
      bOk     := {|| nOpc:=1, oDlg:End() }
      bCancel := {|| oDlg:End() }
   
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
   
   IF nOpc == 1
      lRet := .t.
   Endif 

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

//JPA - 27/07/2006 - Definições do relatório personalizável
****************************
Static Function ReportDef()
****************************
Local cTitulo := "Export Report"
Local cDescr  := "Export Report"
//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas := {"EE9", "EEC"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := {}

//Parâmetros:            Relatório , Titulo ,  Pergunte , Código de Bloco do Botão OK da tela de impressão.
oReport := TReport():New("EECPRL09", cTitulo ,"", {|oReport| ReportPrint(oReport)}, cDescr)

//ER - 20/10/2006 - Inicia o relatório como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.

//Define o objeto com a seção do relatório
oSecao1 := TRSection():New(oReport,"Seção 1",aTabelas,aOrdem)

//Definição das colunas de impressão da seção 1
TRCell():New(oSecao1,"ORDNBR"    , "DET", "P. O. NBR"      , /*Picture*/        , 015 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"COUNTNAME" , "DET", "Country Name"   , /*Picture*/        , 012 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"CUSTNAME"  , "DET", "Cust. Name"     , /*Picture*/        , 012 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"CUSTREFNBR", "DET", "Cust. Ref. NBR" , /*Picture*/        , 012 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"QTYMTSO"   , "DET", "QTY MTS Ordered", "@E 999,999,999.99", 012 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"QTYMTSS"   , "DET", "QTY MTS Shipped", "@E 999,999,999.99", 012 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PRICEUSD"  , "DET", "Price USD/MT"   , "@E 999,999,999.99", 012 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"TERMS"     , "DET", "Terms"          , /*Picture*/        , 005 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"TOTPRICE"  , "DET", "Total FOB Price", "@E 999,999,999.99", 012 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"TOTFREI"   , "DET", "Total Freight"  , "@E 999,999,999.99", 012 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"INSURAN"   , "DET", "Insurance"      , /*Picture*/        , 010 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"TOTCCPRICE", "DET", "Total CNF/CIF " , "@E 999,999,999.99", 014 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"TERMSDD"   , "DET", "Terms D/D"      , /*Picture*/        , 004 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"SHIPM"     , "DET", "Ship Mode"      , /*Picture*/        , 010 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"ETSORI"    , "DET", "ETS Origin"     , /*Picture*/        , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"ETADEST"   , "DET", "ETA Dest."      , /*Picture*/        , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"BLDATE"    , "DET", "B/L Date"       , /*Picture*/        , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"BLNBR"     , "DET", "B/L NBR"        , /*Picture*/        , 012 , /*lPixel*/, /*{|| code-block de impressao }*/)             

oSecao1:SetTotalInLine(.F.)
oSecao1:SetTotalText("Totals")

oTotal:= TRFunction():New(oSecao1:Cell("QTYMTSO"),NIL,"SUM",/*oBreak*/,"",,{|| DET->QTYMTSO},.T.,.F.)
oTotal:SetTotalInLine(.F.)

oTotal:= TRFunction():New(oSecao1:Cell("QTYMTSS"),NIL,"SUM",/*oBreak*/,"",,{|| DET->QTYMTSS},.T.,.F.)
oTotal:SetTotalInLine(.F.)

oTotal:= TRFunction():New(oSecao1:Cell("TOTPRICE"),NIL,"SUM",/*oBreak*/,"",,{|| DET->TOTPRICE},.T.,.F.)
oTotal:SetTotalInLine(.F.)

oTotal:= TRFunction():New(oSecao1:Cell("TOTFREI"),NIL,"SUM",/*oBreak*/,"",,{|| DET->TOTFREI},.T.,.F.)
oTotal:SetTotalInLine(.F.)

oTotal:= TRFunction():New(oSecao1:Cell("TOTCCPRICE"),NIL,"SUM",/*oBreak*/,"",,{|| DET->TOTCCPRICE},.T.,.F.)
oTotal:SetTotalInLine(.F.)

oReport:bOnPageBreak := {|| ImpRod() }
//oReport:bOnPageBreak := {|| ImpRod(),oReport:PrintLine() }
Return oReport                        


************************************
Static Function ReportPrint(oReport)
************************************
Local oSection := oReport:Section("Seção 1")

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 1"),"EEC",1,{|| xFilial("EEC") + EEC->EEC_PREEMB})
TRPosition():New(oReport:Section("Seção 1"),"EE9",2,{|| xFilial("EE9") + EEC->EEC_PREEMB})

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

**********************   
Static Function ImpRod
**********************

oReport:Say(oReport:oPage:PageHeight() - 175, 30, "REMARKS:  " + CAB->REMARK)
oReport:Say(oReport:oPage:PageHeight() - 110, 30, "COPY TO:  " + CAB->COPIA)
oReport:Say(oReport:oPage:PageHeight() -  70, 218, CAB->COPIA1)

//oReport:Say(oReport:oPage:nPageHeight - 175, 30, "REMARKS:  " + CAB->REMARK)
//oReport:Say(oReport:oPage:nPageHeight - 110, 30, "COPY TO:  " + CAB->COPIA)
//oReport:Say(oReport:oPage:nPageHeight -  70, 218, CAB->COPIA1)

Return

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL09.PRW                                                 *
*------------------------------------------------------------------------------*