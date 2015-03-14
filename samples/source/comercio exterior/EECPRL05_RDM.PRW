#INCLUDE "EECPRL05.ch"

/*
Programa        : EECPRL05.PRW
Objetivo        : RE'S EMITIDOS
Autor           : Cristiane C. Figueiredo
Data/Hora       : 01/06/2000 08:34
Obs.            :

*/

#include "EECRDM.CH"

/*
Funcao      : EECPRL05
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 01/06/2000 08:34   
Revisao     :
Obs.        :
*/

User Function EECPRL05

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7"})

Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw
Local cPeriodo
Local dDataZ:= AVCTOD("  /  /  ")
//Local aRE, lFabr1, nValFob, nValCom, nValLiq, aNFS, lFabr, lExport, lRE, lSD//TESTE*********************************************************************JVR testeeeee......................
Local dDTNF, nReg, nFrete, nSeguro, cExp, cImpRed, cFabRed, cExpRed

Local i:=0
Private aRE, lFabr1, nValFob, nValCom, nValLiq, aNFS, lFabr, lExport, lRE, lSD//TESTE*********************************************************************JVR testeeeee......................
Private dDtIni   := AVCTOD("  /  /  ")
Private dDtFim   := AVCTOD("  /  /  ")
Private cFabr    := SPACE(AVSX3("A2_COD",3))
Private cExport  := SPACE(AVSX3("A2_COD",3))
Private cRE      := SPACE(AVSX3("EE9_RE",3))
Private cSD      := SPACE(AVSX3("EE9_NRSD",3))
Private cArqRpt, cTitRpt           

//JVR - 11/12/09 - Relatório Personalizavel
Private oReport
Private lRelPersonal := FindFunction("TRepInUse") .And. TRepInUse()

Begin Sequence

   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("55","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("55","EEA_COD"),"EEA_TITULO"))
   Endif
   
   cNomDbfC:= "WORK05C"
   aCamposC:= {}
   AADD(aCamposC,{"SEQREL" ,"C", 8,0})
   AADD(aCamposC,{"EMPRESA","C",60,0})
   AADD(aCamposC,{"PERIODO","C",30,0}) 
   AADD(aCamposC,{"EXPORT" ,"C",60,0})
   AADD(aCamposC,{"FABRIC" ,"C",60,0})


   cNomDbfD:= "WORK05D"
   aCamposD:= {}
   AADD(aCamposD,{"SEQREL"  ,"C", 8,0})
   AADD(aCamposD,{"ORDEM"   ,"C",60,0})
   AADD(aCamposD,{"NRORE"   ,"C",15,0})
   AADD(aCamposD,{"DTEMIS"  ,"D", 8,0})
   AADD(aCamposD,{"VALID"   ,"D", 8,0})
   AADD(aCamposD,{"DTBL"    ,"D", 8,0})
   AADD(aCamposD,{"DTINF"   ,"D", 8,0})
   AADD(aCamposD,{"EMBARQ"  ,"C",30,0})
   AADD(aCamposD,{"IMPORT"  ,"C",30,0})
   AADD(aCamposD,{"NRSD"    ,"C",30,0})
   AADD(aCamposD,{"NRNF"    ,"C",15,0})
   AADD(aCamposD,{"VLFOB"   ,"N",15,2})
   AADD(aCamposD,{"FRETE"   ,"N",15,2})
   AADD(aCamposD,{"SEGURO"  ,"N",15,2})
   AADD(aCamposD,{"VLLIQ"   ,"N",15,2})
   AADD(aCamposD,{"VLTOT"   ,"N",15,2})
   AADD(aCamposD,{"FABRIC_G","C",60,0})
   AADD(aCamposD,{"IMPORT_G","C",60,0})

   aArqs := {}
   AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
   AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

   aRetCrw := crwnewfile(aArqs)

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif
   
   EE9->(DBSETORDER(1))
   EE9  ->(DBSEEK(XFILIAL("EE9")))
   
   IF ( Empty(dDtIni) .and. Empty(dDtFim) )
      cPeriodo := STR0001 //"TODOS"
   Else   
      cPeriodo := DtoC(dDtIni) + STR0002 + DtoC(dDtFim) //" ATE "
   Endif
      
   IF empty(cFabr)
      cFabr := STR0001  //"TODOS"
   ENDIF
   
   IF empty(cExport)
      cExport := STR0001  //"TODOS"
   ENDIF
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   SysRefresh()
   
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo                 
   CAB->FABRIC  := If(cFabr <> STR0001, Posicione("SA2",1,XFILIAL("SA2")+cFabr,"A2_NREDUZ"),cFabr) //"TODOS"
   CAB->EXPORT  := If(cExport <> STR0001, Posicione("SA2",1,XFILIAL("SA2")+cExport,"A2_NREDUZ"),cExport) //"TODOS"
   
   CAB->(MSUNLOCK())
   
   aRE := {}
   
   While EE9->(!Eof() .And. EE9->EE9_FILIAL==xFilial("EE9"))
     
      IF ( EMPTY(EE9->EE9_RE)) .or. dDtIni > EE9->EE9_DTRE .OR. IF(EMPTY(dDtFim),.f.,dDtFim < EE9->EE9_DTRE)
          EE9->(DBSKIP())
          LOOP
      ENDIF                  
      lFabr1 := .f.
     
      EEC->(DBSETORDER(1))
      EEC->(DBSEEK(XFILIAL("EEC")+EE9->EE9_PREEMB))
     
      nValFOB := (EEC->EEC_TOTPED-EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
      nValCom := (if(EEC->EEC_TIPCVL=="1",(EEC->EEC_VALCOM*nValFOB)/100,EEC->EEC_VALCOM))
      nValLiq := EE9->EE9_PRCINC - ((nValCom*EE9->EE9_PRCINC)/nValFOB)
     
      EEM->(DBSETORDER(1))
         EEM->(DBGOTOP())
      EEM->(DBSEEK(XFILIAL("EEM")+EE9->EE9_PREEMB))
      aNFS := {}
      WHILE ( EEM->(!EOF() .AND. EEM->EEM_FILIAL==xFilial("EEM")) .and. EEM->EEM_PREEMB == EE9->EE9_PREEMB )
         IF ( EEM->EEM_TIPONF <> "1" .or. empty(EEM->EEM_DTNF))
            EEM->(DBSKIP())
            LOOP
         ENDIF
         AADD(aNFS, {EEM->EEM_NRNF,EEM->EEM_DTNF})
         EEM->(DBSKIP())
      ENDDO
     
      lFabr  := cFabr <> STR0001 .and. cFabr <> EE9->EE9_FABR //"TODOS"
      lExport:= cExport <> STR0001 .and. cExport <> IF(EMPTY(EEC->EEC_EXPORT),EEC->EEC_FORN,EEC->EEC_EXPORT) //"TODOS"
      lRE    := !Empty(cRE) .and. cRE <> EE9->EE9_RE
      lSD    := !Empty(cSD) .and. cSD <> EE9->EE9_NRSD
     
      IF (lFabr .OR. lExport .OR. lRE .or. lSD )
          EE9->(DBSKIP())
          Loop
      ENDIF
     
         dDTNF := AVCTOD("  /  /  ") 
         cNRNF := ""
         IF ( LEN(aNFS)>0 )
         dDTNF := aNFS[1,2]
               cNRNF := ALLTRIM(aNFS[1,1]) + If(Len(aNFS)>1,STR0003 + aLLTRIM(aNFS[Len(aNFS),1]),"") //" A "
         ENDIF
     
         nReg   := aSCAN(aRE,{|X| X[1]+X[15] == TRANSF(EE9->EE9_RE,AVSX3("EE9_RE",6))+EE9->EE9_FABR})
      nFrete := (EEC->EEC_FRPREV*EE9->EE9_PRCINC)/nValFOB
      nSeguro:= (EEC->EEC_SEGPRE*EE9->EE9_PRCINC)/nValFOB
      cExp   := IF(EMPTY(EEC->EEC_EXPORT),EEC->EEC_FORN,EEC->EEC_EXPORT)
      cImpRed:= Posicione("SA1",1,XFILIAL("SA1")+EEC->EEC_IMPORT,"A1_NREDUZ")
      cFabRed:= Posicione("SA2",1,XFILIAL("SA2")+EE9->EE9_FABR,"A2_NREDUZ")
      cExpRed:= Posicione("SA2",1,XFILIAL("SA2")+cExp,"A2_NREDUZ")
      IF ( nReg == 0 )      
         aADD(aRE,{TRANSF(EE9->EE9_RE,AVSX3("EE9_RE",6)),;// 1- numero do RE
                   EE9->EE9_DTRE,;                        // 2- Data RE
                   ,;                                     // 3- Validade
                   EEC->EEC_DTCONH,;                      // 4- Data Conhec.
                   EEC->EEC_PREEMB,;                      // 5- Nro. Embarque
                   cIMPRED,;                              // 6- Importador
                   EE9->EE9_NRSD,;                        // 7- Nro SD
                   EE9->EE9_PRCINC,;                      // 8- Valor FOB
                   nFrete,;                               // 9- Frete
                   nSeguro,;                              //10- Seguro
                   nValLiq,;                              //11- Vlr. Liquido
                         EE9->EE9_PRCINC+nFRETE+nSEGURO,;          //12- Vlr. Total
                              dDTNF,;                                //13- Data da NF
                              cNRNF,;                                //14- Nro's da NF
                             cFabRed,;                              //15- FABRICANTE
                               cExpRed})                              //16- EXPORTADOR
      Else
         aRE[nReg, 8] := aRE[nReg, 8] + EE9->EE9_PRCINC
         aRE[nReg, 9] := aRE[nReg, 9] + nFrete
         aRE[nReg,10] := aRE[nReg,10] + nSeguro
         aRE[nReg,11] := aRE[nReg,11] + nValLiq
         aRE[nReg,12] := aRE[nReg,12] + EE9->EE9_PRCINC+nFRETE+nSEGURO  
            FOR I:= 1 TO LEN(ANFS)
               aADD(aRE,{"",dDATAZ,dDATAZ,dDATAZ,"","","",0,0,0,0,0,dDTNF,cNRNF,cFabRed,cExpRed})
            NEXT
      Endif
     
         EE9->(DBSKIP())
   Enddo   

//U_Ferrarel(aRe)//TESTE*********************************************************************JVR testeeeee......................   
   FOR i:=1 to len(aRE)
      DET->(DBAPPEND())
      DET->SEQREL  := cSeqRel 
         DET->ORDEM   := STR(I, 6)
      DET->NRORE   := aRE[I, 1]
      DET->DTEMIS  := aRE[I, 2]
      DET->DTBL    := aRE[I, 4]
      DET->EMBARQ  := aRE[I, 5]
      DET->IMPORT  := aRE[I, 6]
      DET->NRSD    := aRE[I, 7]
      DET->VLFOB   := aRE[I, 8] 
      DET->FRETE   := aRE[I, 9] 
      DET->SEGURO  := aRE[I,10] 
      DET->VLLIQ   := aRE[I,11] 
      DET->VLTOT   := aRE[I,12] 
      DET->DTINF   := aRE[I,13]
      DET->NRNF    := aRE[i,14]
      DET->FABRIC_G:= aRE[I,15]
      DET->IMPORT_G:= aRE[i,16]
      DET->(MSUNLOCK())
   NEXT
     
   IF (empty(aRE))
      MSGINFO(STR0004, STR0005) //"Intervalo sem dados para impressão"###"Aviso"
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

   Local oDlg,oPanel

   Local nOpc := 0
   Local bOk  := {|| nOpc:=1, oDlg:End() }
   Local bCancel := {|| oDlg:End() }
      
   Begin Sequence
      
      DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO /*23,50*/ 25,50 OF oMainWnd //FDR - 16/01/12 - Ajuste de tela
   
      oPanel:= TPanel():New(0, 0, "",oDlg,, .F., .F.,,, 50, 16)
      
      @  20,05 SAY STR0006 PIXEL Of oPanel //"Data Inicial"
      @  20,40 MSGET dDtIni SIZE 40,8  PIXEL Of oPanel
      
      @  33,05 SAY STR0007  PIXEL Of oPanel//"Data Final"
      @  33,40 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim, dDtIni) PIXEL Of oPanel
      
      @  46,05 SAY STR0008  PIXEL Of oPanel//"Fabricante"
      @  46,40 MSGET cFabr SIZE 40,8 PICT AVSX3("A2_COD",6) valid (Empty(cFabr).or.ExistCpo("SA2")) F3 "SA2" PIXEL Of oPanel
                                                            
      @  59,05 SAY STR0009 PIXEL Of oPanel//"Exportador"
      @  59,40 MSGET cExport SIZE 40,8 PICT AVSX3("A2_COD",6) valid (Empty(cExport).or.ExistCpo("SA2")) F3 "SA2" PIXEL Of oPanel
                                                                
      @  72,05 SAY STR0010 PIXEL Of oPanel//"R.E."
      @  72,40 MSGET cRE PICT AVSX3("EE9_RE",6) SIZE 60,8 PIXEL Of oPanel
                                                                
      @  85,05 SAY STR0011 PIXEL Of oPanel                     //"S.D."
      @  85,40 MSGET cSD PICT AVSX3("EE9_NRSD",6) SIZE 70,8 PIXEL Of oPanel
                                                                
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
         MsgInfo(STR0012,STR0005) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
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
aTabelas := {"DET", "EEC"}

//Array com o titulo e com a chave das ordens disponiveis para escolha do usuário
aOrdem   := {} 
//
//Parâmetros:            Relatório , Titulo  ,  Pergunte , Código de Bloco do Botão OK da tela de impressão , Descrição
oReport := TReport():New("EECPRL05", cTitulo ,""         , {|oReport| ReportPrint(oReport)}                 , cDescr    )

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
//           objeto ,cName      ,cAlias,cTitle            ,cPicture             ,nSize,lPixel     ,bBlock ,cAlign ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold
TRCell():New(oSecao2,"NRORE"    , "DET", "Nro. R.E."      ,                     , 015 ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"DTEMIS"   , "DET", "Dt. Emissão"    ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"DTBL"     , "DET", "Dt. B/L"        ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"NRNF"     , "DET", "Dt. NF"         ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"EMBARQ"   , "DET", "Embarque"       ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"IMPORT"   , "DET", "Importador"     ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"NRSD"     , "DET", "Nro. S.D."      ,                     ,     ,           ,       ,"LEFT" ,          ,            ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"VLFOB"    , "DET", "Val. FOB"       ,"@E 9,999,999,999.99", 014 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"FRETE"    , "DET", "Frete"          ,"@E 9,999,999,999.99", 014 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"SEGURO"   , "DET", "Seguro"         ,"@E 9,999,999,999.99", 014 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"VLLIQ"    , "DET", "Val. Liq."      ,"@E 9,999,999,999.99", 014 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )
TRCell():New(oSecao2,"VLTOT"    , "DET", "Val. Total"     ,"@E 9,999,999,999.99", 014 ,           ,       ,"RIGHT",          ,"RIGHT"     ,          ,         , .T.     ,        ,        ,     )

//Quebra de acordo com a Ordem selecionada
oBreak:= TRBreak():New(oSecao2,{|| DET->IMPORT_G },,.F.)                       
oBreak:bOnPrintTotal:={||oReport:SkipLine(1),oReport:PrintText(DET->IMPORT_G,,)}

oBreak1:= TRBreak():New(oSecao2,{|| DET->IMPORT_G+DET->FABRIC_G },,.F.)                       
oBreak1:bOnPrintTotal:={||oReport:SkipLine(1),oReport:PrintText("  " + DET->FABRIC_G,,)}

oTotal :=TRFunction():New(oSecao2:Cell("VLFOB"),NIL,"SUM",oBreak1 , , ,{|| DET->VLFOB },.F.,.T.) 
oTotal :=TRFunction():New(oSecao2:Cell("VLLIQ"),NIL,"SUM",oBreak1 , , ,{|| DET->VLLIQ },.F.,.T.) 
oTotal :=TRFunction():New(oSecao2:Cell("VLTOT"),NIL,"SUM",oBreak1 , , ,{|| DET->VLTOT },.F.,.T.) 

oSecao2:SetTotalText("") 

oReport:bOnPageBreak :={||oReport:Section("Seção 1"):PrintLine()} 
oSecao1:SkipLine(2)

Return oReport


*----------------------------------*
Static Function ReportPrint(oReport)
*----------------------------------*

//Faz o posicionamento de outros alias para utilização pelo usuário na adição de novas colunas.
TRPosition():New(oReport:Section("Seção 2"),"EEC", 1,{|| xFilial("EEC") + DET->EMBARQ  })
 
//Inicio da impressão da seção 1.
oReport:Section("Seção 1"):Init()

//Inicio da impressão da seção 2.
oReport:Section("Seção 2"):Init()

FilePrint:=E_Create(,.F.)
IndRegua("DET",FilePrint+OrdBagExt(),"IMPORT_G+FABRIC_G")
oReport:SetMeter(DET->(RecCount()))
DET->(dbGoTop())

If DET->(!EoF())      
   oReport:Section("Seção 2"):PrintHeader()
   oReport:Section("Seção 2"):lHeaderSection:=.F.
   oReport:SkipLine(1)
   oReport:PrintText(DET->IMPORT_G,,) 
   oReport:SkipLine(1)
   oReport:PrintText("  " + DET->FABRIC_G,,) 
   oReport:FatLine()  
EndIf
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
* FIM DO PROGRAMA EECPRL05.PRW                                                 *
*------------------------------------------------------------------------------*
