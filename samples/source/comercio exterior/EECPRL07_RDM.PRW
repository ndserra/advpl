#INCLUDE "EECPRL07.ch"


/*
Programa        : EECPRL07.PRW
Objetivo        : Comissões Pendentes
Autor           : Cristiane C. Figueiredo
Data/Hora       : 22/05/2000 17:18
Obs.            :

*/

#include "EECRDM.CH"

#define EV_COM_AR     "120" // Comissão do Tipo A Remeter. (Utilizada nos tratamentos de Frete Seguro e Comissão).
#define EV_COM_CG     "121" // Comissão do Tipo Conta Gráfica. (Utilizada nos tratamentos de Frete Seguro e Comissão).
#define EV_COM_DF     "122" // Comissão do Deduzir da Fatura. (Utilizada nos tratamentos de Frete Seguro e Comissão).

/*
Funcao      : EECPRL07
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 22/05/2000 17:18
Revisao     :
Obs.        :
*/

User Function EECPRL07

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7","EEQ"})

Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw, lZero := .t.
Local cPeriodo
Local aTPCOMB := {STR0001,STR0002,STR0003} //"Remeter"###"Conta Grafica"###"Deduzir Fatura"
Local lEmba, cAgeCom, lRecCom, lExport, lFornec, lTpCom, lRecebe, lValCom
Local nValFob, nPercom, nValCom, nDiasCP
Local nValLiq := 0
Local nTotCom := 0
Local cFilEEQ := xFilial("EEQ")
   
Private dDtIni  := AVCTOD("  /  /  ")
Private dDtFim  := AVCTOD("  /  /  ")
Private cExport := SPACE(AVSX3("A2_COD",3))
Private cFabric := SPACE(AVSX3("A2_COD",3))
Private cRepres := SPACE(AVSX3("EEB_CODAGE",3))
Private aTpCom  := {STR0004, STR0005,STR0006, STR0007} //"0-Todos"###"1-Remeter"###"2-Conta Gráfica"###"3-Deduzir Fatura"
Private cTpCom := aTpCom[1]

Private cArqRpt, cTitRpt

//JVR - 11/12/09 - Relatório Personalizavel
Private oReport
Private lRelPersonal := FindFunction("TRepInUse") .And. TRepInUse()

Begin Sequence
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("57","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("57","EEA_COD"),"EEA_TITULO"))
   Endif

   cNomDbfC:= "WORK07C"
   aCamposC:= {}
   AADD(aCamposC,{"SEQREL","C", 8,0})
   AADD(aCamposC,{"PERIODO","C",30,0})
   AADD(aCamposC,{"EMPRESA","C",60,0})
   AADD(aCamposC,{"FABRIC","C",60,0})
   AADD(aCamposC,{"EXPORT","C",60,0})


   cNomDbfD:= "WORK07D"
   aCamposD:= {}
   AADD(aCamposD,{"SEQREL","C", 8,0})
   AADD(aCamposD,{"DTEMBA","C",10,0})
   AADD(aCamposD,{"DTVENC","C",10,0})
   AADD(aCamposD,{"AGECOM","C",40,0})
   AADD(aCamposD,{"IMPORT","C",20,0})
   AADD(aCamposD,{"PREEMB","C",20,0})
   AADD(aCamposD,{"CONDPA","C",60,0})
   AADD(aCamposD,{"NRINVO","C",20,0})
   AADD(aCamposD,{"TPCOM","C",20,0})
   AADD(aCamposD,{"CODIMP","C",60,0})
   AADD(aCamposD,{"CODAGE","C",60,0})
   AADD(aCamposD,{"VALFOB","N",15,3})
   AADD(aCamposD,{"PERCOM","N",6,2})
   AADD(aCamposD,{"VALCOM","N",15,3})
   //** PLB 01/06/07
   AADD(aCamposD,{"TOTCOM","N",15,3})
   AADD(aCamposD,{"VALLIQ","N",15,3})
   //**

   aArqs := {}
   AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
   AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

   aRetCrw := crwnewfile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif

   EEQ->( DBSetOrder(1) )

   EEC->(dbsetorder(12))
   EEC->(DBSEEK(XFILIAL("EEC")+DTOS(dDtIni),.T.))
   
   IF ( Empty(dDtIni) .and. Empty(dDtFim) )
      cPeriodo := STR0008 //"TODOS"
   Else   
      cPeriodo := DtoC(dDtIni) + STR0009 + DtoC(dDtFim) //" ATE "
   Endif
   
   IF empty(cExport)
      cExport := STR0008  //"TODOS"
   ENDIF
   
   IF empty(cFabric)
      cFabric := STR0008  //"TODOS"
   ENDIF
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   SysRefresh()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo
   CAB->FABRIC  := If(cFabric <> STR0008, Posicione("SA2",1,XFILIAL("SA2")+cFabric,"A2_NREDUZ"),cFabric) //"TODOS"
   CAB->EXPORT  := If(cExport <> STR0008, Posicione("SA2",1,XFILIAL("SA2")+cExport,"A2_NREDUZ"),cExport) //"TODOS"
   
   CAB->(MSUNLOCK())
   lZero := .t.
   
    While EEC->(!Eof() .And. EEC->EEC_FILIAL==xFilial("EEC")) .and. EEC->EEC_DTEMBA >= dDtIni .And.  If(Empty(dDtFim),.t.,EEC->EEC_DTEMBA <= dDtFim)
     
     EE9->(DBSETORDER(3))
     EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
     if cFabric == STR0008 //"TODOS"
        lFornec := .f.
     Else
        lFornec := .t.
        Do while EE9->(!eof()) .and. xFilial("EE9") ==  EE9->EE9_FILIAL .AND. EE9->EE9_PREEMB == EEC->EEC_PREEMB
           if cFabric == EE9->EE9_FABR
              lFornec := .f.
           Endif
           EE9->(DBSKIP())
        Enddo   
     endif      
     EEB->(DBSETORDER(1))
     lEmba   := EMPTY(EEC->EEC_DTEMBA)
     cAgeCom := BUSCAEMPRESA(EEC->EEC_PREEMB,"Q","3")
     lRecCom := empty(cAgecom)
     lValCom := empty(EEC->EEC_VALCOM)
     lExport := cExport<>STR0008 .and. cExport <> if(empty(EEC->EEC_EXPORT),EEC->EEC_FORN,EEC->EEC_EXPORT) //"TODOS"
     lTpCom  := substr(cTpCom,1,1) <> "0" .and. substr(cTpCom,1,1) <> EEC->EEC_TIPCOM
     lRecebe := !EMPTY(cRepres) .and. !(EEB->(DBSEEK(XFILIAL("EEB")+EEC->EEC_PREEMB+"Q"+cRepres+"3")))
     
     IF ( lExport .or. lFornec .or. lTpCom .or. lRecCom .or. lRecebe .or. lEmba .or. lValCom)
        EEC->(DBSKIP())
        Loop
     ENDIF
     
     lZero := .f.
     If !GetMv("MV_AVG0086",,.F.)  //LBL - 07/06/2013
        nValFOB := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
     Else
        nValFOB := EEC->EEC_TOTPED - (EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
     EndIf        
     nPerCom := if(EEC->EEC_TIPCVL=="1",EEC->EEC_VALCOM,(EEC->EEC_VALCOM/nValFOB)*100)
     //nValCom := if(EEC->EEC_TIPCVL=="1",(EEC->EEC_VALCOM*nValFOB)/100,EEC->EEC_VALCOM)

     //** PLB 01/06/07 - Tratamento para exibição de Comissões Liquidadas
     nTotCom := if(EEC->EEC_TIPCVL=="1",(EEC->EEC_VALCOM*nValFOB)/100,EEC->EEC_VALCOM)
     nValLiq := 0

     EEQ->( DBSeek(cFilEEQ+EEC->EEC_PREEMB) )
     Do While EEQ->( !EoF()  .And.  cFilEEQ+EEC->EEC_PREEMB == EEQ_FILIAL+EEQ_PREEMB )
        If EEQ->EEQ_EVENT $ (EV_COM_AR + "___" + EV_COM_CG + "___" + EV_COM_DF)
           If !Empty(EEQ->EEQ_PGT)
              nValLiq += EEQ->EEQ_VL
           EndIf
        EndIf
        EEQ->( DBSkip() )
     EndDo

     nValCom := nTotCom - nValLiq
     //**

     //TRP-25/06/07 - Exibição apenas das comissões pendentes
     If nValCom > 0
        DET->(DBAPPEND())
        DET->SEQREL := cSeqRel 
        DET->DTEMBA := dtoc(EEC->EEC_DTEMBA)
        nDIASCP := POSICIONE("SY6",1,XFILIAL("SY6")+EEC->EEC_CONDPA,"Y6_DIAS_PA")
        DET->DTVENC := DTOC(EEC->EEC_DTEMBA + nDIASCP)
        DET->AGECOM := cAgeCom
        DET->IMPORT := Posicione("SA1",1,XFILIAL("SA1")+EEC->EEC_IMPORT,"A1_NREDUZ")
        DET->PREEMB := EEC->EEC_PREEMB
        DET->CONDPA := MSMM(Posicione("SY6",1,xFILIAL("SY6")+EEC->EEC_CONDPA,"Y6_DESC_P"),AVSX3("Y6_VM_DESP",3))
        DET->VALFOB := nValFOB
        DET->PERCOM := Round(nPerCom, 2)
        //** PLB 01/06/07
        DET->TOTCOM := Round(nTotCom, 3)
        DET->VALLIQ := Round(nValLiq, 3)
        //**
        DET->VALCOM := Round(nValCom, 3)
        DET->NRINVO := EEC->EEC_NRINVO
        DET->TPCOM  := IF(!EMPTY(EEC->EEC_TIPCOM),aTPCOMB[VAL(EEC->EEC_TIPCOM)],"")
        DET->CODIMP := EEC->EEC_IMPORT
        DET->CODAGE := EEB->EEB_CODAGE
        DET->(MSUNLOCK())
     Endif
     EEC->(DBSKIP())
   Enddo   
  
   IF ( lZero )
     MSGINFO(STR0010, STR0011) //"Não existe comissão para o intervalo escolhido"###"Aviso"
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
      
      DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 24,50 OF oMainWnd
   
      @ 20,05 SAY STR0012 PIXEL //"Data Inicial"
      @ 20,45 MSGET dDtIni SIZE 40,8 PIXEL
      
      @ 33,05 SAY STR0013 PIXEL //"Data Final"
      @ 33,45 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim, dDtIni) PIXEL
      
      @ 46,05 SAY STR0014 PIXEL //"Representante"
      @ 46,45 MSGET cRepres SIZE 20,8 PICT AVSX3("Y5_COD",6) valid (Empty(cRepres).or.ExistCpo("SY5")) F3 "SY5" PIXEL
   
      @ 59,05 SAY STR0015 PIXEL //"Exportador"
      @ 59,45 MSGET cExport SIZE 40,8 PICT AVSX3("A2_COD",6) valid (Empty(cExport).or.ExistCpo("SA2")) F3 "SA2" PIXEL
      
      @ 72,05 SAY STR0016 PIXEL //"Fabricante"
      @ 72,45 MSGET cFabric SIZE 40,8 PICT AVSX3("A2_COD",6) valid (Empty(cFabric).or.ExistCpo("SA2")) F3 "SA2" PIXEL
   
      @ 85,05 SAY STR0017 PIXEL //"Tipo Comissão"
      TComboBox():New(85,45,bSETGET(cTpCom),aTpCom,80,50,oDlg,,,,,,.T.)
        
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
         MsgInfo(STR0018,STR0011) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
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
Data/Hora   : 11/12/2009
Revisao     :
Obs.        :
*/
*-------------------------*
Static Function ReportDef()
*-------------------------*                                                                

//Variaveis
Local cDescr := cTitulo := cTitRpt

//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas := {"DET", "EEC", "EEQ"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := {} 
//
//Parâmetros:            Relatório , Titulo  ,  Pergunte , Código de Bloco do Botão OK da tela de impressão , Descrição
oReport := TReport():New("EECPRL07", cTitulo ,""         , {|oReport| ReportPrint(oReport)}                 , cDescr    )

//Inicia o relatório como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.
  
//Define os objetos com as seções do relatório
oSecao1 := TRSection():New(oReport,"Seção 1",{"CAB"},{})
oSecao2 := TRSection():New(oReport,"Seção 2",aTabelas,aOrdem)

//Definição das colunas de impressão da seção 1
TRCell():New(oSecao1,"PERIODO" , "CAB", "Periodo"                 ,            ,     ,           ,       )
TRCell():New(oSecao1,"EXPORT"  , "CAB", "Exportador"              ,            ,     ,           ,       )
TRCell():New(oSecao1,"FABRIC"  , "CAB", "Fabricante"              ,            ,     ,           ,       )

//Definição das colunas de impressão da seção 2
//           objeto ,cName       ,cAlias,cTitle             ,cPicture             ,nSize,lPixel     ,bBlock ,cAlign ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold
TRCell():New(oSecao2,"AGECOM"   , "DET", "Agente"           ,                     , 015 ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"IMPORT"   , "DET", "Importador"       ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PREEMB"   , "DET", "Embarque"         ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"DTEMBA"   , "DET", "Dt.Embarque"      ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"DTVENC"   , "DET", "Dt.Vencimento"    ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"CONDPA"   , "DET", "Cond.Pagamento"   ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"VALFOB"   , "DET", "Valor FOB"        ,"@E 9,999,999,999.99", 014 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PERCOM"   , "DET", "% Comissão"       ,"@E 999,999,999.9999", 010 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"VALCOM"   , "DET", "Tot. Comissão"    ,"@E 9,999,999,999.99", 014 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"NRINVO"   , "DET", "Nro. Fatura"      ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"TPCOM"    , "DET", "Tp. Comissão"     ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )

//Quebra de acordo com a Ordem selecionada
oBreak:= TRBreak():New(oSecao2,{|| DET->IMPORT },,.F.)                       
oBreak:bOnBreak:={||oReport:SkipLine(1),oReport:PrintText("Total por Importador: ",,)}
oBreak1 := TRBreak():New(oSecao2,{|| DET->AGECOM },,.F.)  
oBreak1:bOnBreak:={||oReport:SkipLine(1),oReport:PrintText("Total por Agente: ",,)}
oTotal:=TRFunction():New(oSecao2:Cell("VALFOB"),NIL,"SUM",oBreak, , ,{|| DET->VALFOB },.F.,.F.) 
oTotal:=TRFunction():New(oSecao2:Cell("VALCOM"),NIL,"SUM",oBreak, , ,{|| DET->VALCOM },.F.,.F.) 
oTotal1:=TRFunction():New(oSecao2:Cell("VALFOB"),NIL,"SUM",oBreak1, , ,{|| DET->VALFOB },.F.,.T.) 
oTotal1:=TRFunction():New(oSecao2:Cell("VALCOM"),NIL,"SUM",oBreak1, , ,{|| DET->VALCOM },.F.,.T.) 
oSecao2:SetTotalText("")

oReport:bOnPageBreak :={||oReport:Section("Seção 1"):PrintLine()} 
oSecao1:SkipLine(2)

Return oReport


*----------------------------------*
Static Function ReportPrint(oReport)
*----------------------------------*

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 2"),"EEC", 1,{|| xFilial("EEC") + DET->PREEMB  })
TRPosition():New(oReport:Section("Seção 2"),"EEQ", 1,{|| xFilial("EEQ") + EEC->EEC_PREEMB   })
 
//Inicio da impressão da seção 1.
oReport:Section("Seção 1"):Init()

//Inicio da impressão da seção 2.
oReport:Section("Seção 2"):Init()

oReport:SetMeter(DET->(RecCount()))
DET->(dbGoTop())

FilePrint:=E_Create(,.F.)
IndRegua("DET",FilePrint+OrdBagExt(),"AGECOM+IMPORT")

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
* FIM DO PROGRAMA EECPRL07.PRW                                                 *
*------------------------------------------------------------------------------*
