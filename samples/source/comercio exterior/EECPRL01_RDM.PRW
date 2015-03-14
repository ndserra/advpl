#INCLUDE "EECPRL01.ch"

/*
Programa        : EECPRL01.PRW
Objetivo        : Status do Processo
Autor           : Cristiane C. Figueiredo
Data/Hora       : 06/06/2000 17:25
Obs.            :
Alteracao       : CAF 25/08/2000 17:00 - Protheus
*/

#include "EECRDM.CH"

/*
Funcao      : EECPRL01
Objetivos   : Ajustar o relatório para a versão 811 - Release 4
Autor       : Juliano Paulino Alves - JPA
Data 	    : 02/08/2006
Obs         :
Revisão     :
*/
**********************
User Function EECPRL01
**********************
lRet := U_EECP01R3(.T.)
RETURN lRet

/*
Funcao      : EECP01R3
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 06/06/2000 17:25       
Obs.        :
Revisão     : Juliano Paulino Alves - Relatório personalisável - Release 4
Data/Hora   : 02/08/06 15:55
*/
User Function EECP01R3(p_R4)

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7"})
Local lZero := .t.

Local aDocsimp, aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw

Local nNroEmb, i:=0

Private dDtIni   := AVCTOD("  /  /  ")
Private dDtFim   := AVCTOD("  /  /  ")
Private cEMBARQ  := SPACE(AVSX3("EEC_PREEMB",3))
Private cImport  := SPACE(AVSX3("A1_COD",3))
Private aTpOrdem := {AVSX3("EEC_DTCONH",AV_TITULO),AVSX3("EEC_DTPROC",AV_TITULO)}
Private cTpOrdem := aTpOrdem[1]

Private cArqRpt, cTitRpt

//JPA - 02/08/2006 - Relatório Personalizavel - Release 4
Private oReport
Private lR4   := If(p_R4 == NIL,.F.,.T.) .AND. FindFunction("TRepInUse") .And. TRepInUse()

Begin Sequence
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("51","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("51","EEA_COD"),"EEA_TITULO"))
   Endif
   
   aDocsimp:= {}
   AADD(aDocsImp,{"RE" ,"  ","xx             "})
   AADD(aDocsImp,{"IE" ,"  ","14             "})
   AADD(aDocsImp,{"PL" ,"  ","13             "})
   AADD(aDocsImp,{"PL2","  ","xx             "})
   AADD(aDocsImp,{"FC" ,"  ","39             "})
   AADD(aDocsImp,{"CO" ,"  ","xx             "})
   AADD(aDocsImp,{"SQ" ,"  ","04             "})
   AADD(aDocsImp,{"CRB","  ","15             "})
   
   cNomDbfC:= "WORK01C"
   aCamposC:= {}
   AADD(aCamposC,{"SEQREL" ,"C", 8,0})
   AADD(aCamposC,{"EMPRESA","C",60,0})
   AADD(aCamposC,{"PERIODO","C",30,0})
   AADD(aCamposC,{"ORDEM"  ,"C",30,0})
   AADD(aCamposC,{"IMPORT" ,"C",30,0})
   AADD(aCamposC,{"EMBARQ" ,"C",30,0})
   
   cNomDbfD:= "WORK01D"
   aCamposD:= {}
   AADD(aCamposD,{"SEQREL"   ,"C", 8,0})
   AADD(aCamposD,{"ORDEM"    ,"D", 8,0})
   AADD(aCamposD,{"REFIMP"   ,"C",20,0})
   AADD(aCamposD,{"EMBARQ"   ,"C",20,0})
   AADD(aCamposD,{"IMPORT"   ,"C",20,0})
   AADD(aCamposD,{"NOMEIMP"  ,"C",60,0})
   AADD(aCamposD,{"PAIS"     ,"C",30,0})
   AADD(aCamposD,{"CV"       ,"C", 3,0})
   AADD(aCamposD,{"VOL"      ,"N",15,0})
   AADD(aCamposD,{"DESC"     ,"C",60,0})
   AADD(aCamposD,{"DTINI"    ,"D", 8,0})
   AADD(aCamposD,{"SAIFABR"  ,"D", 8,0})
   AADD(aCamposD,{"DTBL"     ,"D", 8,0})
   AADD(aCamposD,{"RE"       ,"C", 2,0})
   AADD(aCamposD,{"IE"       ,"C", 2,0})
   AADD(aCamposD,{"PL"       ,"C", 2,0})
   AADD(aCamposD,{"PL2"      ,"C", 2,0})
   AADD(aCamposD,{"FC"       ,"C", 2,0})
   AADD(aCamposD,{"CO"       ,"C", 2,0})
   AADD(aCamposD,{"SQ"       ,"C", 2,0})
   AADD(aCamposD,{"CRB"      ,"C", 2,0})
   
   aArqs := {}
   AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
   AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})
   
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
      
   IF empty(cEmbarq)
      cEmbarq := STR0001  //"TODOS"
   ENDIF
   IF empty(cImport)
      cImport := STR0001  //"TODOS"
   ENDIF
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo
   CAB->ORDEM   := cTpOrdem
   CAB->IMPORT  := IF(cImport <> STR0001,Posicione("SA1",1,xFilial("SA1")+cImport,"A1_NREDUZ"),cImport) //"TODOS"
   CAB->EMBARQ  := cEmbarq
   CAB->(MSUNLOCK())
      
   lZero := .t.
   
   While EEC->(!Eof() .And. EEC->EEC_FILIAL==xFilial("EEC")) .and. EEC->EEC_DTEMBA >= dDtIni .And.  If(Empty(dDtFim),.t.,EEC->EEC_DTEMBA <= dDtFim)
      
      nNroEmb := 0
      
      EEO->(dbSetOrder(1)) // FILIAL+PREEMB+SEQ+NIVEL
      EEO->(dbSeek(xFilial()+EEC->EEC_PREEMB+AvKey(1,"EEO_SEQ")))

      While EEO->(!Eof() .And. EEO->EEO_FILIAL==xFilial("EEO")) .And.;
            EEO->EEO_SEQ == AvKey(1,"EEO_SEQ") .And. nNroEmb < 3
            
         IF EEO->EEO_TIPO == TIPO_ITEM
            EEO->(dbSkip())
            Loop
         Endif
            
         IF EEO->EEO_CODEMB != EEC->EEC_EMBAFI
            nNroEmb := nNroEmb + 1
         Endif
         
         EEO->(dbSkip())
      Enddo
      
      lVerEE9 := .f.
      
      If nNroEmb == 1 
         lVerEE9 := .T.
         nQtdVol := 0
      Else
         nQtdVol := EEC->EEC_TOTVOL  
      Endif
      
      EE9->(DBSETORDER(2))
      IF EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
         cRE := "OK"
         cDescEmb := POSICIONE("EE5",1,XFILIAL("EE5")+EE9->EE9_EMBAL1,"EE5_DESC")
      ENDIF 
      
      WHILE ( EE9->(!EOF().AND. EE9->EE9_FILIAL==xFilial("EE9")) .and. EE9->EE9_PREEMB == EEC->EEC_PREEMB)
         IF ( Empty(EE9->EE9_RE ))
            cRE := ""
         ENDIF
         IF ( lVerEE9 )
            nQtdVol := nQtdVol + EE9->EE9_QTDEM1
         ENDIF
         EE9->(DBSKIP())
      Enddo
        
      lEmbarq := cEmbarq <> STR0001 .and. cEmbarq <> EEC->EEC_PREEMB //"TODOS"
      lImport := cImport <> STR0001 .and. cImport <> EEC->EEC_IMPORT //"TODOS"
     
      IF (lEmbarq .or. lImport)
         EEC->(DBSKIP())
         Loop
      ENDIF
        
      DET->(DBAPPEND())
      DET->SEQREL  := cSeqRel 
        
      IF cTpOrdem==aTpOrdem[1]
         DET->ORDEM := EEC->EEC_DTCONH
      ELSE
         DET->ORDEM := EEC->EEC_DTPROC
      ENDIF
     
      DET->EMBARQ   := EEC->EEC_PREEMB
      DET->IMPORT   := EEC->EEC_IMPORT
      DET->REFIMP   := EEC->EEC_REFIMP
      DET->NOMEIMP  := EEC->EEC_IMPODE
      DET->PAIS     := (Posicione("SYA",1,xFilial("SYA")+EEC->EEC_PAISET,"YA_DESCR"))
      DET->CV       := EEC->EEC_INCOTE
      DET->VOL      := nQtdVol
      DET->DESC     := IF(EMPTY(EEC->EEC_EMBAFI),cDescEmb,POSICIONE("EE5",1,XFILIAL("EE5")+EEC->EEC_EMBAFI,"EE5_DESC"))
      DET->DTINI    := EEC->EEC_DTPROC
      DET->SAIFABR  := EEC->EEC_DTSDFB
      DET->DTBL     := EEC->EEC_DTCONH
        
      FOR I:=1 TO 8
         SY0->(DBSETORDER(4))
         
         IF SY0->(DBSEEK(XFILIAL("SY0")+EEC->EEC_PREEMB+"2"+aDOCSIMP[I,3]))
            aDOCSIMP[I,2] := "OK"
         ELSE
            aDOCSIMP[I,2] := "  "
         ENDIF
      NEXT      
     
      DET->RE  := cRE  
      DET->IE  := aDOCSIMP[2,2]
      DET->PL  := aDOCSIMP[3,2]
      DET->PL2 := aDOCSIMP[4,2]
      DET->FC  := aDOCSIMP[5,2]
      DET->CO  := If(!EMPTY(EEC->EEC_NRCTOR),"OK","")
      DET->SQ  := aDOCSIMP[7,2]
      DET->CRB := aDOCSIMP[8,2]
      DET->(MSUNLOCK())
      EEC->(DBSKIP())
      lZero := .f.
   Enddo
      
   IF ( lZero )
      MSGINFO(STR0003, STR0004) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   Else
      If lR4      //JPA - 02/08/2006
         oReport := ReportDef()
      EndIf
   ENDIF

End Sequence      

//retorna a situacao anterior ao processamento
RestOrd(aOrd)

IF ( lRet )
   If lR4   //JPA - 02/08/2006
      oReport:PrintDialog()
      CrwCloseFile(aRetCrw,.T.)
   Else
      lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   EndIf
ELSE
   // Fecha e apaga os arquivos temporarios
   CrwCloseFile(aRetCrw,.T.)
ENDIF

Return .F.
         
/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 06/06/2000 17:25       
Obs.        :
Revisão     : Juliano Paulino Alves - Relatório personalisável - Release 4
Data/Hora   : 03/08/06 14:15
*/
Static Function TelaGets

Local lRet  := .f.

Local oDlg

Local nOpc := 0
Local bOk  := {|| nOpc:=1, oDlg:End() }
Local bCancel := {|| oDlg:End() }

Begin Sequence
      
   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 20,50 OF oMainWnd
   
      @  20,05 SAY STR0005 PIXEL //"Data Inicial"
      @  20,45 MSGET dDtIni SIZE 40,8 PIXEL
      
      @  33,05 SAY STR0006 PIXEL //"Data Final"
      @  33,45 MSGET dDtFim SIZE 40,8 Valid (fConfData(dDtFim,dDtIni)) PIXEL
      
      @  46,05 SAY STR0007 PIXEL //"Embarque"
      @  46,45 MSGET cEmbarq SIZE 80,8 Valid (empty(cEmbarq) .or. ExistEmbarq(cEmbarq)) F3 "EEC" PIXEL
   
      @  59,05 SAY STR0008 PIXEL //"Importador"
      @  59,45 MSGET cImport SIZE 40,8 VALID (empty(cImport).or.ExistCpo("SA1")) F3 "SA1" PIXEL
      
      If ! lR4          //JPA - 03/08/2006
         @  72,05 SAY STR0009 PIXEL //"Ordenar por"
         TComboBox():New(72,45,bSETGET(cTpOrdem),aTpOrdem,80,60,oDlg,,,,,,.T.)
      EndIf
      
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
         MsgInfo(STR0010,STR0004) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
      Else
         lRet := .t.
      Endif   

End Sequence
      
Return lRet
   

//JPA - 03/08/2006 - Definições do relatório personalizável
****************************
Static Function ReportDef()
****************************                         
Local cTitulo := "Status do Processo"
Local cDescr  := "Status do Processo"
//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas := {"DET","EEC", "EE9"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := { AvSx3("EEC_DTCONH",5) ,; 
              AvSx3("EEC_DTPROC",5) } 

//Parâmetros:            Relatório , Titulo ,  Pergunte , Código de Bloco do Botão OK da tela de impressão.
oReport := TReport():New("EECPRL01", cTitulo ,"", {|oReport| ReportPrint(oReport)}, cDescr)

//ER - 20/10/2006 - Inicia o relatório como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.

//Define os objetos com as seções do relatório
oSecao1 := TRSection():New(oReport,"Seção 1",aTabelas,aOrdem)
oSecao2 := TRSection():New(oReport,"Seção 2",{"CAB"},{})  // JPA - 04/08/06

//Definição das colunas de impressão da seção 1
TRCell():New(oSecao1,"EMBARQ" , "DET", "Embarque"       , /*Picture*/  , 020 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"REFIMP" , "DET", "Ref. Importador", /*Picture*/  , 020 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"IMPORT" , "DET", "Importador"     , /*Picture*/  , 012 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"NOMEIMP", "DET", "Nome Importador", /*Picture*/  , 025 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PAIS"   , "DET", "Pais"           , /*Picture*/  , 022 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"CV"     , "DET", "C.V."      	    , /*Picture*/  , 003 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"VOL"    , "DET", "Vol."           , "@!"         , 012 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"DESC"   , "DET", "Desc."          , /*Picture*/  , 025 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"DTINI"  , "DET", "Dt Processo"    , /*Picture*/  , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"SAIFABR", "DET", "Saida Fab"      , /*Picture*/  , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"DTBL"   , "DET", "Dt Conhec"      , /*Picture*/  , 008 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"RE"     , "DET", "RE"             , "@!"         , 002 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"IE"     , "DET", "IE"     		, /*Picture*/  , 002 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"PL"     , "DET", "PL"   	        , /*Picture*/  , 002 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"FC"     , "DET", "FC"             , /*Picture*/  , 002 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"CO"     , "DET", "CO"             , /*Picture*/  , 002 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"SQ"     , "DET", "SQ"             , /*Picture*/  , 002 , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSecao1,"CRB"    , "DET", "CRB"      		, /*Picture*/  , 002 , /*lPixel*/, /*{|| code-block de impressao }*/)

oReport:Section("Seção 1"):Cell("NOMEIMP"):SetColSpace(6)
oReport:Section("Seção 1"):Cell("VOL"):SetColSpace(4)

// JPA - 04/08/06 - Definição das colunas de impressão da seção 2
TRCell():New(oSecao2,"PERIODO", "CAB", "Periodo"   , /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("PERIODO"):SetCellBreak()

TRCell():New(oSecao2,"ORDEM"  , "CAB", "Ordem"     , /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("ORDEM"):SetCellBreak()

TRCell():New(oSecao2,"IMPORT" , "CAB", "Importador", /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("IMPORT"):SetCellBreak()

TRCell():New(oSecao2,"EMBARQ" , "CAB", "Embarque"  , /*Picture*/, 030 , /*lPixel*/, /*{|| code-block de impressao }*/)
oReport:Section("Seção 2"):Cell("EMBARQ"):SetCellBreak()

oReport:bOnPageBreak :={||oReport:Section("Seção 2"):PrintLine()} 

Return oReport


************************************
Static Function ReportPrint(oReport)
************************************
Local oSection := oReport:Section("Seção 1")
Local aIndexKey:= { "DTos(DTBL)" ,; //Primeira Ordem
                    "DTos(DTINI)"  } //Segunda  Ordem

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 1"),"EEC",12,{|| xFilial("EEC")+DTOS(dDtIni)})
TRPosition():New(oReport:Section("Seção 1"),"EE9",2,{|| xFilial("EE9")+EEC->EEC_PREEMB})

oReport:SetMeter(DET->(RecCount()))
DET->(dbGoTop())

FilePrint:=E_Create(,.F.)
IndRegua("DET",FilePrint+OrdBagExt(),aIndexKey[oReport:Section("Seção 1"):nOrder])

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

FERASE(FilePrint+OrdBagExt())
Return .T.                                                                      

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL01.PRW                                                 *
*------------------------------------------------------------------------------*