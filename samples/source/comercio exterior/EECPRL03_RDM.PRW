#INCLUDE "EECPRL03.ch"

/*
Programa        : EECPRL03.PRW
Objetivo        : Programação de Embarques
Autor           : Cristiane C. Figueiredo
Data/Hora       : 31/05/2000 19:18
Obs.            :

*/


#include "EECRDM.CH"

/*
Funcao      : EECPRL03
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 31/05/2000 19:18       
Revisao     :
Obs.        :
*/
User Function EECPRL03

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7"})

Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw, lZero := .t.
Local cPeriodo
Local lFabr1, lPorto, lexport, laber, lPrim, lFabr, lPrev, lRetC, lDiv

Private dDtIni   := AVCTOD("  /  /  ")
Private dDtFim   := AVCTOD("  /  /  ")
Private cPorto   := SPACE(AVSX3("Y9_COD",3))
Private cFabr    := SPACE(AVSX3("A2_COD",3))
Private cExport  := SPACE(AVSX3("A2_COD",3))
Private cDiv     := SPACE(AVSX3("YC_COD",3))
Private aTpOrdem  := {STR0001,STR0002} //"Produto + Via"###"Fabricante + Local de Destino"
Private cTpOrdem  := aTpOrdem[1]
Private aTpProd := {STR0003,STR0004} //"Código"###"Descrição"
Private cTpProd := aTpProd[1]

Private cArqRpt, cTitRpt

//JVR - 01/12/09 - Relatório Personalizavel
Private oReport
Private lRelPersonal := FindFunction("TRepInUse") .And. TRepInUse()

Begin Sequence
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("53","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("53","EEA_COD"),"EEA_TITULO"))
   Endif

   //armazena situacao atual
   lzero := .t.

   cNomDbfC:= "WORK03C"
   aCamposC:= {}
   AADD(aCamposC,{"SEQREL"  ,"C", 8,0})
   AADD(aCamposC,{"EMPRESA" ,"C",60,0})
   AADD(aCamposC,{"PERIODO" ,"C",30,0})

   // ** by JBJ 22/11/01 - 10:49
   AADD(aCamposC,{"FAMILIA" ,"C",45,0})   
   //AADD(aCamposC,{"DIVISAO" ,"C",30,0})
   
   AADD(aCamposC,{"FABR"    ,"C",30,0})
   AADD(aCamposC,{"PORTDEST","C",30,0})
   AADD(aCamposC,{"EXPORT"  ,"C",30,0})

   cNomDbfD:= "WORK03D"
   aCamposD:= {}
   AADD(aCamposD,{"SEQREL"   ,"C", 8,0})
   AADD(aCamposD,{"ORDEM"    ,"C",60,0})
   AADD(aCamposD,{"ORDEM1"   ,"C",30,0})
   AADD(aCamposD,{"PORTODEST","C",30,0})
   AADD(aCamposD,{"VIA"      ,"C", 1,0})
   AADD(aCamposD,{"PORTOEMB" ,"C",30,0})
   AADD(aCamposD,{"PEDIDO"   ,"C",15,0})
   AADD(aCamposD,{"DTSOL"    ,"D", 8,0})
   AADD(aCamposD,{"DTPREVEMB","D", 8,0})
   AADD(aCamposD,{"PRODUTO"  ,"C",60,0})
   AADD(aCamposD,{"PSLIQ"    ,"N",15,3})
   AADD(aCamposD,{"QTDE"     ,"N",15,3})
   AADD(aCamposD,{"PRUNIT"   ,"N",18,8}) //DFS - 21/03/12 - Ajuste no tamanho e decimal do campo referente ao preço unitário
   AADD(aCamposD,{"TOTAL"    ,"N",15,3})
   AADD(aCamposD,{"PSBRUTO"  ,"N",15,3})
   AADD(aCamposD,{"CUBAGEM"  ,"N",15,3})
   AADD(aCamposD,{"IMPORT"   ,"C",15,0})
   AADD(aCamposD,{"EMBALAG"  ,"C",10,0})

   aArqs := {}
   AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
   AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

   aRetCrw := crwnewfile(aArqs)
   
   IF ! TelaGets()
      lRet := .F.
      Break
   Endif
   
   EE7->(dbSetOrder(1))
   EE7->(dbSeek(xFilial()))
   
   IF ( Empty(dDtIni) .and. Empty(dDtFim) )
      cPeriodo := STR0005 //"TODOS"
   Else   
      cPeriodo := DtoC(dDtIni) + STR0006 + DtoC(dDtFim) //" ATE "
   Endif
         
   IF empty(cPorto)
      cPorto := STR0005  //"TODOS"
   ENDIF
   IF empty(cFabr)
      cFabr := STR0005  //"TODOS"
   ENDIF
   IF empty(cDiv)
      cDiv := STR0005  //"TODOS"
   ENDIF
   IF empty(cExport)
      cExport := STR0005  //"TODOS"
   ENDIF
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   SysRefresh()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo
   CAB->PORTDEST:= IF(cPorto <> STR0005,Posicione("SY9",2,xFilial("SY9")+cPorto,"Y9_DESCR"),cPorto) //"TODOS"
   CAB->FABR    := IF(cFabr <> STR0005,Posicione("SA2",1,xFilial("SA1")+cFabr,"A2_NREDUZ"),cFabr) //"TODOS"

   // **  by JBJ - 22/01/01 10:19 
   CAB->FAMILIA := IF(cDiv <> STR0005,Posicione("SYC",1,xFilial("SYC")+cDiv,"YC_NOME"),cDiv) //"TODOS"
   //CAB->DIVISAO := IF(cDiv <> STR0005,Posicione("SYC",1,xFilial("SYC")+cDiv,"YC_DESCR"),cDiv) //"TODOS"
   
   CAB->EXPORT  := IF(cExport <> STR0005,Posicione("SA2",1,xFilial("SA1")+cExport,"A2_NREDUZ"),cExport) //"TODOS"
   CAB->(MSUNLOCK())
   
   lZero := .t.
   
   While EE7->(!Eof() .And. EE7->EE7_FILIAL==xFilial("EE7"))
     
      lFabr1 := .f.
     
      EE8->(DBSETORDER(1))
      EE8->(DBSEEK(XFILIAL("EE8")+EE7->EE7_PEDIDO))

      lPorto := cPorto <> STR0005 .and. cPorto<> EE7->EE7_DEST //"TODOS"
      lExport:= cExport <> STR0005 .and. If(EMPTY(EE7->EE7_EXPORT),cExport<>EE7->EE7_FORN,cExport<>EE7->EE7_EXPORT) //"TODOS"
        
      IF (lPorto .or. lExport)
          EE7->(DBSKIP())
          Loop
      ENDIF

      lPrim:=.t.
      
      Do WHILE ( EE8->(!EOF() .AND. EE8->EE8_FILIAL==xFilial("EE8")) .and. EE8->EE8_PEDIDO == EE7->EE7_PEDIDO)
         nQtIt := EE8->EE8_SLDATU
         lAber := .f.
         
         EE9->(DBSETORDER(1))
         EE9->(DBSEEK(XFILIAL("EE9")+EE7->EE7_PEDIDO+EE8->EE8_SEQUEN))
         
         While EE9->(!EOF()) .AND. EE9->EE9_FILIAL == XFILIAL("EE8") .AND. EE8->EE8_PEDIDO == EE9->EE9_PEDIDO .AND. EE9->EE9_SEQUEN == EE8->EE8_SEQUEN
            EEC->(DBSETORDER(1))
            IF EEC->(DBSEEK(XFILIAL("EEC")+EE9->EE9_PREEMB))
               If Empty(EEC->EEC_DTCONH) .AND. EEC->EEC_STATUS != ST_PC
                  nQtIt := nQtIt + EE9->EE9_SLDINI
               Endif   
            ENDIF
            EE9->(DBSKIP())
         ENDDO
         
         lAber  := nQtIt == 0   
         lFabr  := cFabr <> STR0005 .and. cFabr <> EE8->EE8_FABR //"TODOS"
         lPrev  := dDtIni > EE8->EE8_DTPREM .OR. IF(EMPTY(dDtFim),.f.,dDtFim < EE8->EE8_DTPREM)
         lDiv   := cDiv <> STR0005 .and. cDiv <> EE8->EE8_FPCOD //"TODOS"
         
         IF (lFabr .OR. lPrev .or. lAber .or. lDiv)
            EE8->(DBSKIP())
            Loop
         ENDIF
       
         DET->(DBAPPEND())
         DET->SEQREL  := cSeqRel 
        
         IF cTpOrdem==aTpOrdem[1]
            DET->ORDEM := EE8->EE8_COD_I
            DET->ORDEM1:= EE7->EE7_VIA
         ELSE
            DET->ORDEM := EE8->EE8_FABR
            DET->ORDEM1:= EE7->EE7_DEST
         ENDIF
        
         IF cTpProd==aTpProd[1]
            DET->PRODUTO := EE8->EE8_COD_I
         ELSE
            DET->PRODUTO := MSMM(EE8->EE8_DESC,AVSX3("EE8_VM_DES",3))
         ENDIF

         DET->PORTODEST:= IF(EMPTY(EE7->EE7_DEST),"",POSICIONE("SY9",2,XFILIAL("SY9")+EE7->EE7_DEST,"Y9_DESCR"))
         DET->PORTOEMB := IF(EMPTY(EE7->EE7_ORIGEM),"",POSICIONE("SY9",2,XFILIAL("SY9")+EE7->EE7_ORIGEM,"Y9_DESCR"))
         DET->VIA      := SUBST(POSICIONE("SYQ",1,XFILIAL("SYQ")+EE7->EE7_VIA,"YQ_COD_DI"),3,1)
         DET->PEDIDO   := EE7->EE7_PEDIDO
         DET->DTSOL    := EE7->EE7_DTPEDI
         DET->DTPREVEMB:= EE8->EE8_DTPREM
         DET->PSLIQ    := nQtIt * EE8->EE8_PSLQUN
         DET->QTDE     := nQtIt
         DET->PRUNIT   := EE8->EE8_PRECOI
         DET->TOTAL    := nQtIt * EE8->EE8_PRECOI
         DET->PSBRUTO  := (nQtIt/EE8->EE8_QE)*EE8->EE8_PSBRUN
        
         If lPrim
            DET->CUBAGEM  := EE7->EE7_CUBAGE
            lPrim:=.f.
         Endif   
        
         DET->IMPORT   := EE7->EE7_IMPORT
         DET->EMBALAG  := EE8->EE8_EMBAL1
         DET->(MSUNLOCK())
         
         lZero := .f.
         
         EE8->(DBSKIP())
      Enddo
     
      EE7->(DBSKIP())
   Enddo   
  
   IF ( lZero )
      MSGINFO(STR0007, STR0008) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.                          
   ELSE
      //JVR - 01/12/09 - Relatório Personalizavel
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

Return .F.
         
//----------------------------------------------------------------------
STATIC Function TelaGets

Local lRet  := .f.

Local oDlg

Local nOpc := 0
Local bOk  := {|| nOpc:=1, oDlg:End() }
Local bCancel := {|| oDlg:End() }
   
Begin Sequence
   
   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 27,50 OF oMainWnd

      @  20,05 SAY STR0009 PIXEL //"Data Inicial"
      @  20,40 MSGET dDtIni SIZE 40,8 PIXEL
      
      @  33,05 SAY STR0010 PIXEL //"Data Final"
      @  33,40 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim, dDtIni) PIXEL
      
      @  46,05 SAY STR0011 PIXEL //"Porto Destino"
      @  46,40 MSGET cPorto PICT AVSX3("Y9_COD",6) valid (Empty(cPorto).or.ExistCpo("SY9",cPorto,2)) size 35,8 PIXEL F3 "EY9" 
                                                           
      @  59,05 SAY STR0012 PIXEL //"Fabricante"
      @  59,40 MSGET cFabr PICT AVSX3("A2_COD",6) valid (Empty(cFabr).or.ExistCpo("SA2")) SIZE 40,8 F3 "SA2" PIXEL                 
                                                               
      @  72,05 SAY STR0013 PIXEL //"Exportador"
      @  72,40 MSGET cExport PICT AVSX3("A2_COD",6) valid (Empty(cExport).or.ExistCpo("SA2")) SIZE 40,8 F3 "SA2" PIXEL                 
                                                               
      @  85,05 SAY STR0014 PIXEL                                     //"Família"
      @  85,40 MSGET cDiv PICT AVSX3("YC_COD",6) valid (Empty(cDiv).or.ExistCpo("SYC")) SIZE 20,8 F3 "SYC" PIXEL
                                                               
      @  98,05 SAY STR0015 PIXEL //"Produto"
      TComboBox():New(98,40,bSETGET(cTpProd),aTpProd,50,60,oDlg,,,,,,.T.)
      
      @  111,05 SAY STR0016 PIXEL //"Ordem"
      TComboBox():New(111,40,bSETGET(cTpOrdem),aTpOrdem,115,60,oDlg,,,,,,.T.)
                                                    
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
      MsgInfo(STR0017,STR0008) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
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
Data/Hora   : 01/12/2009
Revisao     :
Obs.        :
*/
*-------------------------*
Static Function ReportDef()
*-------------------------*                                                                

//Variaveis
Local cDescr := cTitulo := cTitRpt
Local oQuebra
Local i

//Alias que podem ser utilizadas para adicionar campos personalizados no relatório
aTabelas := {"DET", "EE7", "EE8", "EEC", "EE9"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := {} 
//
//Parâmetros:            Relatório , Titulo  ,  Pergunte , Código de Bloco do Botão OK da tela de impressão , Descrição
oReport := TReport():New("EECPRL03", cTitulo ,""         , {|oReport| ReportPrint(oReport)}                 , cDescr    )

//Inicia o relatório como paisagem.
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.
  
//Define os objetos com as seções do relatório
oSecao1 := TRSection():New(oReport,"Seção 1",{"CAB"},{})
oSecao2 := TRSection():New(oReport,"Seção 2",aTabelas,aOrdem)

//Definição das colunas de impressão da seção 1
TRCell():New(oSecao1,"PERIODO" , "CAB", "Periodo"                       ,            ,     ,           ,       )
TRCell():New(oSecao1,"FAMILIA" , "CAB", "Familia"                       ,            ,     ,           ,       )
TRCell():New(oSecao1,"FABR"    , "CAB", "Fabricante"                    ,            ,     ,           ,       )
TRCell():New(oSecao1,"PORTDEST", "CAB", "Porto de Destino"              ,            ,     ,           ,       )
TRCell():New(oSecao1,"EXPORT"  , "CAB", "Exportador"                    ,            ,     ,           ,       )
             
//Definição das colunas de impressão da seção 2
//           objeto ,cName       ,cAlias,cTitle                         ,cPicture             ,nSize,lPixel     ,bBlock ,cAlign ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold
TRCell():New(oSecao2,"PORTODEST" , "DET", "Porto Destino"               ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"VIA"       , "DET", "Via"                         ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PORTOEMB"  , "DET", "Porto Embarque"              ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PEDIDO"    , "DET", "Pedido"                      ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
//TRCell():New(oSecao2,"DTSOL"     , "DET", "Dt. Solic."                  ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"DTPREVEMB" , "DET", "Dt. Prev. Emb."              ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PRODUTO"   , "DET", "Produto"                     ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PSLIQ"     , "DET", "Peso Líquido"                ,"@E 9,999,999,999.99", 015 ,           ,       ,"RIGHT",          , "RIGHT"    ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"QTDE"      , "DET", "Quantidade"                  ,"@E 9,999,999,999.99", 015 ,           ,       ,"RIGHT",          , "RIGHT"    ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PRUNIT"    , "DET", "Preço Unitário"              ,"@E 9,999,999,999.99", 015 ,           ,       ,"RIGHT",          , "RIGHT"    ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"TOTAL"     , "DET", "Total"                       ,"@E 9,999,999,999.99", 015 ,           ,       ,"RIGHT",          , "RIGHT"    ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"PSBRUTO"   , "DET", "Peso Bruto"                  ,"@E 9,999,999,999.99", 015 ,           ,       ,"RIGHT",          , "RIGHT"    ,          ,         , .T.     ,        ,        ,     )
//TRCell():New(oSecao2,"CUBAGEM"   , "DET", "Cubagem"                     ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"IMPORT"    , "DET", "Importador"                  ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"EMBALAG"   , "DET", "Embalagem"                   ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )

//Quebra de acordo com a Ordem
oBreak := TRBreak():New(oSecao2,{|| DET->ORDEM + DET->ORDEM1 },,.F.)  
oBreak:bOnBreak:={||oReport:SkipLine(1),oReport:PrintText("Total.......: ",,)}
oTotal:=TRFunction():New(oSecao2:Cell("TOTAL"),NIL,"SUM",oBreak, , ,{|| DET->TOTAL },.T.,.F.) 
oTotal:SkipLine(3)
oSecao2:SetTotalText("")

oReport:bOnPageBreak :={||oReport:Section("Seção 1"):PrintLine()} 
oSecao1:SkipLine(2)

Return oReport


*----------------------------------*
Static Function ReportPrint(oReport)
*----------------------------------*

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 2"),"EE7", 1,{|| xFilial("EE7")+DET->PEDIDO})
TRPosition():New(oReport:Section("Seção 2"),"EE8", 1,{|| xFilial("EE8")+EE7->EE7_PEDIDO})
TRPosition():New(oReport:Section("Seção 2"),"EE9", 1,{|| xFilial("EE9")+EE8->EE8_PEDIDO+EE8->EE8_SEQUEN})
TRPosition():New(oReport:Section("Seção 2"),"EEC", 1,{|| xFilial("EEC")+EE9->EE9_PEDIDO+EE9->EE9_SEQUEN})
 
//Inicio da impressão da seção 1.
oReport:Section("Seção 1"):Init()

//Inicio da impressão da seção 2.
oReport:Section("Seção 2"):Init()

oReport:SetMeter(DET->(RecCount()))
DET->(dbGoTop())

FilePrint:=E_Create(,.F.)
IndRegua("DET",FilePrint+OrdBagExt(),"ORDEM+ORDEM1")

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
* FIM DO PROGRAMA EECPRL03.PRW                                                 *
*------------------------------------------------------------------------------*
