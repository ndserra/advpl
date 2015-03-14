#INCLUDE "EECPRL04.ch"

/*
Programa        : EECPRL04.PRW
Objetivo        : Impressao Processos por Via de Transporte
Autor           : Cristiane C. Figueiredo
Data/Hora       : 26/05/2000 08:18
Obs.            :

*/

#include "EECRDM.CH"

/*
Funcao      : EECPRL04
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 26/05/2000 08:18   
Revisao     :
Obs.        :
*/

User Function EECPRL04

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7"})

Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw, lZero := .t.
Local cPeriodo
Local lVia, lExport, lImport, cTransp, I

Private dDtIni   := AVCTOD("  /  /  ")
Private dDtFim   := AVCTOD("  /  /  ")
Private cExport  := SPACE(AVSX3("A2_COD",3))
Private cImport  := SPACE(AVSX3("A1_COD",3))
//Private cTpOrdem := ""
Private cViaTrans:= SPACE(AVSX3("YQ_VIA",3))
Private aTpOrdem := {AVSX3("EEC_PREEMB",AV_TITULO),AVSX3("EEC_DTCONH",AV_TITULO)}
Private cTpOrdem := aTpOrdem[1]

// **By JBJ - 02/09/2002 - 17:44
Private aTpProc    := {STR0001,STR0012,STR0013} //"Todos"###"Embarcados"###"Não Embarcados"
Private cTpProc    := aTpOrdem[1]
Private lEmbarcado := .f. 

Private cArqRpt, cTitRpt

//JVR - 04/12/09 - Relatório Personalizavel
Private oReport
Private lRelPersonal := FindFunction("TRepInUse") .And. TRepInUse()

Begin Sequence
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("54","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("54","EEA_COD"),"EEA_TITULO"))
   Endif

   cNomDbfC:= "WORK04C"
   aCamposC:= {}
   AADD(aCamposC,{"SEQREL" ,"C", 8,0})
   AADD(aCamposC,{"EMPRESA","C",60,0})
   AADD(aCamposC,{"PERIODO","C",30,0})
   AADD(aCamposC,{"IMPORT" ,"C",60,0})
   AADD(aCamposC,{"EXPORT" ,"C",60,0})
   AADD(aCamposC,{"VIATRAN","C",30,0})//JVR-04/12/09 - utilizado no Treport
   
   cNomDbfD:= "WORK04D"
   aCamposD:= {}
   AADD(aCamposD,{"SEQREL"   ,"C", 8,0})
   AADD(aCamposD,{"ORDEM"    ,"C",60,0})
   AADD(aCamposD,{"PROCESSO" ,"C",20,0})
   AADD(aCamposD,{"PREVEMB"  ,"D", 8,0})
   AADD(aCamposD,{"DTSAIFAB" ,"D", 8,0})
   AADD(aCamposD,{"DTBL"     ,"D", 8,0})
   AADD(aCamposD,{"DTAVERB"  ,"D", 8,0})
   AADD(aCamposD,{"DESPACH"  ,"C",20,0})
   AADD(aCamposD,{"TRANSP"   ,"C",20,0})
   AADD(aCamposD,{"CLIENTE"  ,"C",20,0})
   AADD(aCamposD,{"NOMECLI"  ,"C",60,0})
   AADD(aCamposD,{"PAIS"     ,"C",20,0})
   AADD(aCamposD,{"VLRVENDA" ,"N",15,2})
   AADD(aCamposD,{"INCOTERM" ,"C",10,0})
   AADD(aCamposD,{"VIATRANSP","C",30,0})

   aArqs := {}
   AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
   AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

   aRetCrw := crwnewfile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      BREAK
   Endif
   
   // ** By JBJ - 02/09/2002 17:45 ...
   lEmbarcado := If(cTpProc == aTpProc[2],.t.,.f.)

   EEC->(dbSetOrder(1))
   EEC->(dbSeek(xFilial()))
   
   IF ( Empty(dDtIni) .and. Empty(dDtFim) )
      cPeriodo := STR0001 //"TODOS"
   Else
      cPeriodo := DtoC(dDtIni) + STR0002 + DtoC(dDtFim) //" ATE "
   Endif

   IF empty(cExport)
      cExport := STR0001  //"TODOS"
   ENDIF

   IF empty(cImport)
      cImport := STR0001  //"TODOS"
   ENDIF

   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   SysRefresh()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo
   CAB->IMPORT  := IF(cImport <> STR0001,Posicione("SA1",1,xFilial("SA1")+cImport,"A1_NREDUZ"),cImport) //"TODOS"
   CAB->EXPORT  := IF(cExport <> STR0001,Posicione("SA2",1,xFilial("SA2")+cImport,"A2_NREDUZ"),cExport) //"TODOS"
   CAB->VIATRAN := IF(EMPTY(cViaTrans),STR0001,Posicione("SYQ",1,xFilial("SYQ")+cViaTrans,"YQ_DESCR"))//"TODOS" //JVR-04/12/09
   
   lZero := .t.
   aDTAVERB := {}

   While EEC->(!Eof() .And. EEC->EEC_FILIAL==xFilial("EEC"))
   
      IF EEC->EEC_DTCONH < dDtIni .Or. (! Empty(dDtFim) .And. EEC->EEC_DTCONH > dDtFim)
         EEC->(dbSkip())
         Loop
      Endif
     
      // ** By JBJ - 02/09/2002 17:46 ...
      If cTpProc <> aTpProc[1]
         If (!Empty(EEC->EEC_DTEMBA) .And. !lEmbarcado) .Or. (Empty(EEC->EEC_DTEMBA) .And. lEmbarcado)
            EEC->(dbSkip())
            Loop
         EndIf
      EndIf

      EE9->(DBSETORDER(2))
      EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
      aDTAVERB := {}
      
      While EE9->(!Eof()) .And. EE9->EE9_FILIAL==xFilial("EE9") .and. EE9->EE9_PREEMB == EEC->EEC_PREEMB
         if !EMPTY(EE9->EE9_DTAVRB) .And. aScan(aDTAVERB,{|X| X == EE9->EE9_DTAVRB}) == 0
            AADD( aDTAVERB,EE9->EE9_DTAVRB)
         ENDIF
         EE9->(DBSKIP())   
      Enddo
      
      lVia    := !(EMPTY(cViaTrans)) .and. cViaTrans <> EEC->EEC_VIA
      lExport := cExport<>STR0001 .and. IF(EMPTY(EEC->EEC_EXPORT),cExport <> EEC->EEC_FORN,cExport <> EEC->EEC_EXPORT) //"TODOS"
      lImport := cImport<>STR0001 .and. cImport <> EEC->EEC_IMPORT //"TODOS"
     
      IF ( lExport .or. lImport .or. lVia)
         EEC->(DBSKIP())
         Loop
      ENDIF
      
      lZero := .f.
      
      IF Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1) == "7"
         cTRANSP := BuscaEmpresa(EEC->EEC_PREEMB,"Q","B")
      Else
         cTransp := Posicione("EE6",1,XFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")
      Endif   
      DET->(DBAPPEND())
      DET->SEQREL := cSeqRel 
      IF cTpOrdem==aTpOrdem[1]
         DET->ORDEM := EEC->EEC_PREEMB
      ELSE
         DET->ORDEM := DtoC(EEC->EEC_DTCONH)
      ENDIF
      DET->PROCESSO := EEC->EEC_PREEMB
      DET->PREVEMB  := EEC->EEC_ETD
      DET->DTSAIFAB := EEC->EEC_DTSDFB
      DET->DTBL     := EEC->EEC_DTCONH
      DET->DESPACH  := BUSCAEMPRESA(EEC->EEC_PREEMB,"Q","6")
      DET->TRANSP   := cTRANSP
      DET->CLIENTE  := EEC->EEC_IMPORT
      DET->NOMECLI  := EEC->EEC_IMPODE
      DET->PAIS     := POSICIONE("SYA",1,XFILIAL("SYA")+EEC->EEC_PAISET,"YA_DESCR")
      DET->VLRVENDA := EEC->EEC_TOTPED
      DET->INCOTERM := EEC->EEC_INCOTE
      DET->VIATRANSP:= Posicione("SYQ",1,xFilial("SYQ")+EEC->EEC_VIA,"YQ_DESCR")
      FOR I:=1 TO LEN(aDTAVERB)
         IF I > 1
            DET->(DBAPPEND())
            DET->VIATRANSP:= Posicione("SYQ",1,xFilial("SYQ")+EEC->EEC_VIA,"YQ_DESCR")
            DET->SEQREL := cSeqRel 
            IF cTpOrdem==aTpOrdem[1]
               DET->ORDEM := EEC->EEC_PREEMB
            ELSE
               DET->ORDEM := DtoC(EEC->EEC_DTCONH)
            ENDIF
         ENDIF
         DET->DTAVERB := aDTAVERB[I]
      NEXT
      EEC->(DBSKIP())
   Enddo   
  
   IF ( lZero )
     MSGINFO(STR0003, STR0004) //"Intervalo sem dados para impressão"###"Aviso"
     lRet := .f.
   ELSE
      //JVR - 04/12/09 - Relatório Personalizavel
      If lRelPersonal
         oReport := ReportDef()
      EndIf
   ENDIF
     
End Sequence

//retorna a situacao anterior ao processamento
RestOrd(aOrd)

IF ( lRet )
   //JVR - 01/12/09 - Relatório Personalizavel
   If lRelPersonal
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
   
Begin Sequence
   
   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 27,50 OF oMainWnd // 22,50

      // ** By JBJ - 02/09/2002 17:49 ...
      @ 20,05 SAY STR0014 PIXEL //"Tipo"
      TComboBox():New(20,50,bSETGET(cTpProc),aTpProc,60,60,oDlg,,,,,,.T.)
      
      @ 33,05 SAY STR0005 PIXEL //"Data Inicial"
      @ 33,50 MSGET dDtIni SIZE 40,8 PIXEL

      @ 46,05 SAY STR0006 PIXEL //"Data Final"
      @ 46,50 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim, dDtIni) PIXEL

      @ 59,05 SAY STR0007 PIXEL //"Via de Transporte"
      @ 59,50 MSGET cViaTrans PICT AVSX3("YQ_VIA",6) valid (Empty(cViaTrans).or.ExistCpo("SYQ")) SIZE 20,8  F3 "SYQ" PIXEL

      @ 72,05 SAY STR0008 PIXEL //"Exportador"
      @ 72,50 MSGET cExport SIZE 40,8 PICT AVSX3("A2_COD",6) valid (Empty(cExport).or.ExistCpo("SA2"))  F3 "SA2" PIXEL
      
      @ 85,05 SAY STR0009 PIXEL //"Importador"
      @ 85,50 MSGET cImport SIZE 40,8 PICT AVSX3("A1_COD",6) valid (Empty(cImport).or.ExistCpo("SA1")) F3 "SA1" PIXEL

      @ 98,05 SAY STR0010 PIXEL //"Ordenar  por"
      TComboBox():New(98,50,bSETGET(cTpOrdem),aTpOrdem,60,60,oDlg,,,,,,.T.)

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

/*
Funcao      : ReportDef
Parametros  : 
Retorno     : 
Objetivos   : Relatório Personalizavel TReport
Autor       : Jean Victor Rocha
Data/Hora   : 04/12/2009
Revisao     :
Obs.        :
*/
*-------------------------*
Static Function ReportDef()
*-------------------------*                                                                

//Variaveis
Local cDescr := cTitulo := cTitRpt

//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas := {"DET", "EEC", "SYQ", "EE6"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := {} 
//
//Parâmetros:            Relatório , Titulo  ,  Pergunte , Código de Bloco do Botão OK da tela de impressão , Descrição
oReport := TReport():New("EECPRL04", cTitulo ,""         , {|oReport| ReportPrint(oReport)}                 , cDescr    )

//Inicia o relatório como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.
  
//Define os objetos com as seções do relatório
oSecao1 := TRSection():New(oReport,"Seção 1",{"CAB"},{})
oSecao2 := TRSection():New(oReport,"Seção 2",aTabelas,aOrdem)

//Definição das colunas de impressão da seção 1
TRCell():New(oSecao1,"PERIODO" , "CAB", "Periodo"                 ,            ,     ,           ,       )
TRCell():New(oSecao1,"IMPORT"  , "CAB", "Importador"              ,            ,     ,           ,       )
TRCell():New(oSecao1,"EXPORT"  , "CAB", "Exportador"              ,            ,     ,           ,       )
TRCell():New(oSecao1,"VIATRAN" , "CAB", "Via Transporte"          ,            ,     ,           ,       )

//Definição das colunas de impressão da seção 2
//           objeto ,cName       ,cAlias,cTitle                   ,cPicture             ,nSize,lPixel     ,bBlock ,cAlign ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold
TRCell():New(oSecao2,"PROCESSO"  , "DET", "Processo"              ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PREVEMB"   , "DET", "Prev. Embarque"        ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"DTSAIFAB"  , "DET", "Saida Fabr."           ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"DTBL"      , "DET", "Data B/L"              ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"DTAVERB"   , "DET", "Dt. Averbacao"         ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"DESPACH"   , "DET", "Despachante"           ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"TRANSP"    , "DET", "Transportador"         ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"CLIENTE"   , "DET", "Cod. Cliente"          ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"NOMECLI"   , "DET", "Nome Cliente"          ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PAIS"      , "DET", "Pais"                  ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"VLRVENDA"  , "DET", "Valor na C.Venda"      ,"@E 9,999,999,999.99", 015 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"VIATRANSP" , "DET", "Via Transporte"        ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )

//Quebra de acordo com a Ordem selecionada
oBreak := TRBreak():New(oSecao2,{|| DET->ORDEM },,.F.)  
oBreak:bOnBreak:={||oReport:SkipLine(1),oReport:PrintText("Total.......: ",,)}

oTotal:=TRFunction():New(oSecao2:Cell("VLRVENDA"),NIL,"SUM",oBreak, , ,{|| DET->VLRVENDA },.T.,.F.) 
oSecao2:SetTotalText("")

oReport:bOnPageBreak :={||oReport:Section("Seção 1"):PrintLine()} 
oSecao1:SkipLine(2)

Return oReport


*----------------------------------*
Static Function ReportPrint(oReport)
*----------------------------------*

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 2"),"EEC", 1,{|| xFilial("EEC") + DET->PROCESSO  })
TRPosition():New(oReport:Section("Seção 2"),"SYQ", 1,{|| xFilial("SYQ") + EEC->EEC_VIA   })
TRPosition():New(oReport:Section("Seção 2"),"EE6", 1,{|| xFilial("EE6") + EEC->EEC_EMBARC})
 
//Inicio da impressão da seção 1.
oReport:Section("Seção 1"):Init()

//Inicio da impressão da seção 2.
oReport:Section("Seção 2"):Init()

oReport:SetMeter(DET->(RecCount()))
DET->(dbGoTop())

FilePrint:=E_Create(,.F.)
IndRegua("DET",FilePrint+OrdBagExt(),"ORDEM")

//Laço principal
Do While DET->(!EoF()) .And. !oReport:Cancel()
   oReport:Section("Seção 2"):PrintLine() //Impressão da linha
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
* FIM DO PROGRAMA EECPRL04.PRW                                                 *
*------------------------------------------------------------------------------*