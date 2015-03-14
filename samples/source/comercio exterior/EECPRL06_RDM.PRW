#INCLUDE "EECPRL06.ch"

/*
Programa        : EECPRL06.PRW
Objetivo        : Impressao Processo por Data de Atracação
Autor           : Cristiane C. Figueiredo
Data/Hora       : 30/05/2000 20:25
Revisão         : Juliano Paulino Alves - Relatório personalisável - Release 4
Data/Hora       : 01/08/06 15:00
*/

#include "EECRDM.CH"

/*
Funcao      : EECPRL06
Objetivos   : Ajustar o relatório para a versão 811 - Release 4
Autor       : Juliano Paulino Alves - JPA
Data 	    : 01/08/2006
Obs         :
Revisão     :
*/
**********************
User Function EECPRL06
**********************
lRet := U_EECP06R3(.T.)
RETURN lRet

/*
Funcao      : EECP06R3
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 30/05/2000 20:25   
Revisão     : Juliano Paulino Alves - Relatório personalisável - Release 4
Data/Hora   : 01/08/06 10:20
Obs.        :
*/
User Function EECP06R3(p_R4)

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7"})

Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw, lZero := .t.
Local cPeriodo

Private dDtIni   := AVCTOD("  /  /  ")
Private dDtFim   := AVCTOD("  /  /  ")
Private cExport  := SPACE(AVSX3("A2_COD",3))
Private cFabr    := SPACE(AVSX3("A2_COD",3))
Private cPorto   := SPACE(AVSX3("EEC_PREEMB",3))
Private aTpOrdem := {AVSX3("EEC_ETA",AV_TITULO),AVSX3("EEC_VIA",AV_TITULO)}
Private cTpOrdem := aTpOrdem[1]

Private cArqRpt, cTitRpt

//JPA - 01/08/2006 - Relatório Personalizavel - Release 4
Private oReport
Private lR4   := If(p_R4 == NIL,.F.,.T.) .AND. FindFunction("TRepInUse") .And. TRepInUse()

cNomDbfC:= "WORK06C"
aCamposC:= {}
AADD(aCamposC,{"SEQREL"  ,"C", 8,0})
AADD(aCamposC,{"EMPRESA" ,"C",60,0})
AADD(aCamposC,{"PERIODO" ,"C",30,0})
AADD(aCamposC,{"EMBARQUE","C",60,0})
AADD(aCamposC,{"EXPORT"  ,"C",60,0})

cNomDbfD:= "WORK06D"
aCamposD:= {}
AADD(aCamposD,{"SEQREL"  ,"C", 8,0})
AADD(aCamposD,{"ORDEM"   ,"C",60,0})
AADD(aCamposD,{"VIATRANS","C", 1,0})
AADD(aCamposD,{"TRANSP"  ,"C",30,0})
AADD(aCamposD,{"ETA"     ,"D", 8,0})
AADD(aCamposD,{"ETD"     ,"D", 8,0})
AADD(aCamposD,{"ETADEST" ,"D", 8,0})
AADD(aCamposD,{"EMB"     ,"C",15,0})
AADD(aCamposD,{"PESLIQ"  ,"N",15,3})
AADD(aCamposD,{"PESBRU"  ,"N",15,3})
AADD(aCamposD,{"DTEMB"   ,"D", 8,0})
AADD(aCamposD,{"FRETE"   ,"N",15,2})
AADD(aCamposD,{"PORTEMB" ,"C",20,0})
AADD(aCamposD,{"PORTDEST","C",20,0})
AADD(aCamposD,{"AGEMB"   ,"C",30,0})
AADD(aCamposD,{"AGDEST"  ,"C",30,0})
AADD(aCamposD,{"CUBAGEM" ,"N",15,3})

aArqs := {}
AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

Begin Sequence
   
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("56","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("56","EEA_COD"),"EEA_TITULO"))
   Endif
   
   aRetCrw := crwnewfile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif
   
   EEC->(DBSETORDER(12))
   EEC->(DBSEEK(XFILIAL("EEC")+DTOS(dDtIni),.T.))
   IF ( Empty(dDtIni) .and. Empty(dDtFim) )
      cPeriodo := STR0001 //"TODOS"
   Else   
      cPeriodo := DtoC(dDtIni) + STR0002 + DtoC(dDtFim) //" ATE "
   Endif
      
   IF empty(cPorto)
      cPorto := STR0001  //"TODOS"
   ENDIF
   IF empty(cExport)
      cExport := STR0001  //"TODOS"
   ENDIF
   
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo
   CAB->EMBARQUE:= IF(cPorto <> STR0001,Posicione("SY9",2,xFilial("SY9")+cPorto,"Y9_DESCR"),cPorto) //"TODOS"
   CAB->EXPORT  := IF(cExport <> STR0001,Posicione("SA2",1,xFilial("SA2")+cExport,"A2_NREDUZ"),cExport) //"TODOS"
   CAB->(MSUNLOCK())
   
   lZero := .t.
   
   While EEC->(!Eof() .And. EEC->EEC_FILIAL==xFilial("EEC")) .and. EEC->EEC_DTEMBA >= dDtIni .And.  If(Empty(dDtFim),.t.,EEC->EEC_DTEMBA <= dDtFim)
      EE9->(DBSETORDER(2))
      EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
      
      lFabr9 := .f.
      cFABR1 := EE9->EE9_FABR
      
      While EE9->(!EOF() .AND. EE9->EE9_FILIAL==xFilial("EE9")) .and. EE9->EE9_PREEMB == EEC->EEC_PREEMB
         IF EE9->EE9_FABR == cFabr
            lFabr9 := .t.
         ENDIF
        
         EE9->(DBSKIP())
      End
     
      lPorto  := cPorto <> STR0001 .and. cPorto <> EEC->EEC_ORIGEM //"TODOS"
      lFabr   := !(empty(cFabr)) .and. !lFabr9
      lExport := cExport<>STR0001 .and. IF(EMPTY(EEC->EEC_EXPORT),cExport <> EEC->EEC_FORN,cExport <> EEC->EEC_EXPORT) //"TODOS"
     
      IF lPorto .or. lFabr .or. lExport
         EEC->(DBSKIP())
         Loop
      ENDIF
   
      DET->(DBAPPEND())
      DET->SEQREL  := cSeqRel 
     
      IF cTpOrdem==aTpOrdem[1]
         DET->ORDEM := DTOS(EEC->EEC_ETA)
      ELSE
         DET->ORDEM := EEC->EEC_VIA
      ENDIF
     
      DET->VIATRANS:= SUBST(POSICIONE("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),3,1) //SUBST(EEC->EEC_VIA,1,1)
      DET->TRANSP  := BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_TRA)
      DET->ETA     := EEC->EEC_ETA
      DET->ETD     := EEC->EEC_ETD
      DET->ETADEST := EEC->EEC_ETADES
      DET->EMB     := EEC->EEC_PREEMB
      DET->PESLIQ  := EEC->EEC_PESLIQ
      DET->PESBRU  := EEC->EEC_PESBRU
      DET->DTEMB   := EEC->EEC_DTEMBA
      DET->FRETE   := EEC->EEC_FRPREV
      DET->PORTEMB := IF(EMPTY(EEC->EEC_ORIGEM),"",POSICIONE("SY9",2,XFILIAL("SY9")+EEC->EEC_ORIGEM,"Y9_DESCR"))
      DET->PORTDEST:= IF(EMPTY(EEC->EEC_DEST),"",POSICIONE("SY9",2,XFILIAL("SY9")+EEC->EEC_DEST,"Y9_DESCR"))
      DET->AGEMB   := BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_AGE)
      DET->AGDEST  := BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_ARM)
      
      IF Empty(EEC->EEC_EMBAFI) .Or.;
           GetMv("MV_AVG0005") // Deixar de gravar embalagens ? 
         nCubagem := EEC->EEC_CUBAGE
      Else
         nCubagem := EEC->EEC_CUBAGE*EEC->EEC_TOTVOL
      Endif     
   
      DET->CUBAGEM := nCubagem
      DET->(MSUNLOCK())
      
      EEC->(DBSKIP())
      lZero := .f.
   Enddo   
  
   IF ( lZero )
      MSGINFO(STR0003, STR0004) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   Else
      If lR4      //JPA - 01/08/2006
         oReport := ReportDef()
      EndIf
   ENDIF
     
End Sequence

//retorna a situacao anterior ao processamento
RestOrd(aOrd)

IF ( lRet )
   If lR4   //JPA - 01/08/2006
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
Data/Hora   : 30/05/2000 20:25   
Revisao     :
Obs.        :
*/
Static Function TelaGets

Local lRet  := .f.

Local oDlg

Local nOpc := 0
Local bOk  := {|| nOpc:=1, oDlg:End() }
Local bCancel := {|| oDlg:End() }
   
Begin Sequence
   
   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO /*21,50*/23,50 OF oMainWnd //FDR - 16/01/12 - Ajuste de tela
   
      @ 20,05 SAY STR0005 PIXEL //"Data Inicial"
      @ 20,45 MSGET dDtIni SIZE 40,8 PIXEL
      
      @ 33,05 SAY STR0006 PIXEL //"Data Final"
      @ 33,45 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim, dDtIni) PIXEL
      
      @ 46,05 SAY STR0007 PIXEL //"Fabricante"
      @ 46,45 MSGET cFabr SIZE 40,8 F3 "SA2" PICT AVSX3("A2_COD",6) valid (Empty(cFabr).or.ExistCpo("SA2")) PIXEL

      @ 59,05 SAY STR0008 PIXEL //"Exportador"
      @ 59,45 MSGET cExport SIZE 40,8 PICT AVSX3("A2_COD",6) valid (Empty(cExport).or.ExistCpo("SA2")) F3 "SA2" PIXEL
      
      @ 72,05 SAY STR0009 PIXEL //"P. Embarque"
      @ 72,45 MSGET cPorto SIZE 40,8 F3 "EY9" PIXEL PICT AVSX3("Y9_SIGLA",AV_PICTURE) VALID Vazio() .Or. ExistCpo("SY9",cPorto,2)

      @ 85,05 SAY STR0010 //"Ordenar por"
      TComboBox():New(111,40,bSETGET(cTpOrdem),aTpOrdem,115,60,oDlg,,,,,,.T.)
                                                     
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
      MsgInfo(STR0011,STR0004) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
   Else
      lRet := .t.
   Endif   

End Sequence
      
Return lRet

//JPA - 01/08/2006 - Definições do relatório personalizável
****************************
Static Function ReportDef()
****************************
Local cTitulo := "Processo por Data de Atracação"
Local cDescr  := "Processo por Data de Atracação"
//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas := {"EEC"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := {}

//Parâmetros:            Relatório , Titulo ,  Pergunte , Código de Bloco do Botão OK da tela de impressão.
oReport := TReport():New("EECPRL06", cTitulo ,"", {|oReport| ReportPrint(oReport)}, cDescr)

//ER - 20/10/2006 - Inicia o relatório como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.

//Define os objetos com as seções do relatório
oSecao1 := TRSection():New(oReport,"Seção 1",aTabelas,aOrdem)
oSecao2 := TRSection():New(oReport,"Seção 2",{"CAB"},{})  // JPA - 04/08/06

//Definição das colunas de impressão da seção 1
TRCell():New(oSecao1,"VIATRANS", "DET", "Via"     	       , /*Picture*/        , 001 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"TRANSP"  , "DET", "Transporte"       , /*Picture*/        , 025 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"ETA"     , "DET", "ETA"              , /*Picture*/        , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"ETD"     , "DET", "ETD"              , /*Picture*/        , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"ETADEST" , "DET", "ETA Destino"      , /*Picture*/        , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"EMB"     , "DET", "Embarque"         , /*Picture*/        , 015 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PESLIQ"  , "DET", "Peso Liquido"     , "@E 999,999,999.99", 015 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PESBRU"  , "DET", "Peso Bruto"       , "@E 999,999,999.99", 015 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"DTEMB"   , "DET", "Dt. Embarque"     , /*Picture*/        , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"FRETE"   , "DET", "Frete"            , "@E 999,999,999.99", 015 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PORTEMB" , "DET", "Porto Embarque"   , /*Picture*/        , 020 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PORTDEST", "DET", "Porto Destino"    , /*Picture*/        , 020 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"AGEMB"   , "DET", "Agente Embarcador", /*Picture*/        , 025 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"AGDEST"  , "DET", "Agente Destino"   , /*Picture*/        , 025 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"CUBAGEM" , "DET", "Cubagem"          , "@E 999.99"        , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)

//TRP- 20/09/2006 
oReport:Section("Seção 1"):Cell("PESBRU"   ):SetColSpace(5)
oReport:Section("Seção 1"):Cell("FRETE"    ):SetColSpace(5)
oReport:Section("Seção 1"):Cell("AGEMB"    ):SetColSpace(5)
oReport:Section("Seção 1"):Cell("AGDEST"   ):SetColSpace(5)

oSecao1:SetTotalInLine(.F.)
oSecao1:SetTotalText("Total Geral")

oTotal:= TRFunction():New(oSecao1:Cell("PESLIQ"),NIL,"SUM",/*oBreak*/,"",,{|| DET->PESLIQ},.T.,.F.)
oTotal:SetTotalInLine(.F.)

oTotal:= TRFunction():New(oSecao1:Cell("PESBRU"),NIL,"SUM",/*oBreak*/,"",,{|| DET->PESBRU},.T.,.F.)
oTotal:SetTotalInLine(.F.)

oTotal:= TRFunction():New(oSecao1:Cell("FRETE"),NIL,"SUM",/*oBreak*/,"",,{|| DET->FRETE},.T.,.F.)
oTotal:SetTotalInLine(.F.)

// JPA - 04/08/06 - Definição das colunas de impressão da seção 2
TRCell():New(oSecao2,"PERIODO"  , "CAB", "Periodo: "   , /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("PERIODO"):SetCellBreak()

TRCell():New(oSecao2,"EMBARQUE", "CAB", "P.Embarque: "     , /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("EMBARQUE"):SetCellBreak()

TRCell():New(oSecao2,"EXPORT"  , "CAB", "Exportador: ", /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("EXPORT"):SetCellBreak()

oReport:bOnPageBreak :={||oReport:Section("Seção 2"):PrintLine()}

Return oReport
                             

************************************
Static Function ReportPrint(oReport)
************************************
Local oSection := oReport:Section("Seção 1")

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 1"),"EEC",12,{|| xFilial("EEC")+DTOS(dDtIni)})

oReport:SetMeter(DET->(RecCount()))
DET->(dbGoTop())

// JPA - 04/08/06 - Inicio da impressão da seção 2.
oReport:Section("Seção 2"):Init()
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
//Fim da impressão da seção 2
oReport:Section("Seção 2"):Finish()                                

Return .T.
   
*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL06.PRW                                                 *
*------------------------------------------------------------------------------*