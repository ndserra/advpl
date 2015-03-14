#INCLUDE "EECPRL13.ch"

/*
Programa        : EECPRL13.PRW
Objetivo        : Carteira de Pedidos
Autor           : Cristiane C. Figueiredo
Data/Hora       : 04/06/2000 17:25
Obs.            :

*/


//armazena situacao atual
#include "EECRDM.CH"

/*
Funcao      : EECPRL13
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 04/06/2000 17:25
Revisao     :
Obs.        :
*/

User Function EECPRL13

Local lRet := .T.
Local aOrd := SaveOrd({"EE8","EEM","EEC","EEB","EE7"})

Local aArqs
Local cNomDbfC, aCamposC, cNomDbfD, aCamposD
Local aRetCrw, lZero := .t.
Local cPeriodo
Local cPedAntx, lPrimx, cRE, dDTBL := AVCtod(""), lPais, lFabr, lExport, lPedido, lPedQuit
Local cProd, cProd1, ncontalin, nCor := 2
Local cUnidade  := ""
Local nTotQtde  := 0
Local nTotGeral := 0


Private dDtIni   := AVCTOD("  /  /  ")                                      
Private dDtFim   := AVCTOD("  /  /  ")                                      
Private cFabr    := SPACE(AVSX3("A2_COD",3))                              
Private cImport  := SPACE(AVSX3("A1_COD",3))                              
Private cExport  := SPACE(AVSX3("A2_COD",3))                              
Private cPais    := SPACE(AVSX3("YA_CODGI",3))                            
Private cPedido  := SPACE(AVSX3("EE7_PEDIDO",3))                          
Private aTpOrdem := {STR0001,STR0002,STR0003,STR0004}  //"Importador"###"Data Pedido"###"Pedido"###"Prazo Entrega"
Private cTpOrdem := aTpOrdem[1]                                           
Private aTpProd  := {STR0005,STR0006}                                 //"Codigo"###"Descrição"
Private cTpProd  := aTpProd[1]                                            
Private aTpPed   := {STR0007,STR0008}                                          //"Sim"###"Não"
Private cTpPed   := aTpPed[1]
Private cUnMed   := "KG"
Private cMoeda   := "US$"                                             

Begin Sequence

   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := Posicione("EEA",1,xFilial("EEA")+AvKey("62","EEA_COD"),"EEA_ARQUIV")
      cTitRpt := AllTrim(Posicione("EEA",1,xFilial("EEA")+AvKey("62","EEA_COD"),"EEA_TITULO"))
   Endif
   

   cNomDbfC:= "WORK13C"
   aCamposC:= {}
   AADD(aCamposC,{"SEQREL" ,"C", 8,0})
   AADD(aCamposC,{"EMPRESA","C",60,0})
   AADD(aCamposC,{"PERIODO","C",30,0})
   AADD(aCamposC,{"PAISIMP","C",30,0})
   AADD(aCamposC,{"FABRIC" ,"C",30,0})
   AADD(aCamposC,{"EXPORT" ,"C",30,0})
   AADD(aCamposC,{"TIPO"   ,"C",30,0})
   AADD(aCamposC,{"UNIDAD" ,"C", 2,0})
   AADD(aCamposC,{"TOTQTD" ,"N",30,2})   
   AADD(aCamposC,{"MOEDA"  ,"C", 3,0})
   AADD(aCamposC,{"TOTAL"  ,"N",30,2})

   cNomDbfD:= "WORK13D"
   aCamposD:= {}
   AADD(aCamposD,{"SEQREL"   ,"C", 8,0})
   AADD(aCamposD,{"CONTRCOR" ,"N", 1,0})
   AADD(aCamposD,{"PEDIDO"   ,"C",20,0})
   AADD(aCamposD,{"ORDEM"    ,"C",60,0})
   AADD(aCamposD,{"DTPEDIDO" ,"D", 8,0})
   AADD(aCamposD,{"DTENTREG" ,"D", 8,0})
   AADD(aCamposD,{"IMPORT"   ,"C",20,0})
   AADD(aCamposD,{"REFIMPORT","C",40,0})
   AADD(aCamposD,{"CLIENTE"  ,"C",20,0})
   AADD(aCamposD,{"PRODUTO"  ,"M",30,0})
   AADD(aCamposD,{"FABRIC"   ,"C",30,0})
   AADD(aCamposD,{"NOMFABRI" ,"C",30,0})
   AADD(aCamposD,{"UNIDAD"   ,"C", 2,0}) //ER - 26/07/2006
   AADD(aCamposD,{"QTDE"     ,"N",15,2})
   AADD(aCamposD,{"PUNIT"    ,"N",15,2})
   AADD(aCamposD,{"MOEDA"    ,"C", 5,0})
   AADD(aCamposD,{"TOTAL"    ,"N",15,2})
   AADD(aCamposD,{"EMBARQUE" ,"C",20,0})
   AADD(aCamposD,{"RE"       ,"C",20,0})
   AADD(aCamposD,{"QTDEEMB"  ,"N",15,2})
   AADD(aCamposD,{"SLDQTDE"  ,"N",15,2})
   AADD(aCamposD,{"DTBL"     ,"D", 8,0})
   AADD(aCamposD,{"TOTALF"   ,"C",20,0})

   aArqs := {}
   AADD( aArqs, {cNomDbfc,aCamposc,"CAB","SEQREL"})
   AADD( aArqs, {cNomDbfd,aCamposd,"DET","SEQREL"})

   aRetCrw := crwnewfile(aArqs)
   
   IF ! TelaGets()
      lRet := .F.
      Break
   Endif
   
   IF ( Empty(dDtIni) .and. Empty(dDtFim) )
      cPeriodo := STR0009 //"TODOS"
   Else   
      cPeriodo := DtoC(dDtIni) + STR0010 + DtoC(dDtFim) //" ATE "
   Endif
         
   IF empty(cPais)
      cPais := STR0009  //"TODOS"
   ENDIF
   IF empty(cExport)
      cExport := STR0009  //"TODOS"
   ENDIF
   IF empty(cFabr)
      cFabr := STR0009  //"TODOS"
   ENDIF
   IF empty(cImport)
      cImport := STR0009  //"TODOS"
   ENDIF
   
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel 
   CAB->EMPRESA := SM0->M0_NOME
   CAB->PERIODO := cPeriodo
   CAB->PAISIMP := If(cPais <> STR0009, Posicione("SYA",1,XFILIAL("SYA")+POSICIONE("SA1",1,XFILIAL("SA1")+EE7->EE7_IMPORT,"A1_PAIS"),"YA_DESCR"),cPais) //"TODOS"
   CAB->FABRIC  := alltrim(If(cFabr <> STR0009, Posicione("SA2",1,XFILIAL("SA2")+cFabr,"A2_NREDUZ"),cFabr))+STR0011+alltrim(If(cImport <> STR0009, Posicione("SA1",1,XFILIAL("SA1")+cImport,"A1_NREDUZ"),cImport)) //"TODOS"###"/ IMPORTADOR: "###"TODOS"
   CAB->EXPORT  := If(cExport <> STR0009, Posicione("SA2",1,XFILIAL("SA2")+cExport,"A2_NREDUZ"),cExport) //"TODOS"
   CAB->TIPO    := cTpOrdem
   CAB->UNIDAD  := cUnMed
   CAB->MOEDA   := cMoeda
   lZero := .t.
   cPedAntx := EE8->EE8_PEDIDO                             
   
   LPrimX := .t.

// EE8->(dbGotop())
   EE8->( dbSetOrder(1) )
   EE8->( dbSeek( xFilial("EE8") ) )

   While EE8->(!Eof()) .and. EE8->EE8_FILIAL==xFilial("EE8") 
   
      cRE := ""
      cEMBARQ := ""
      dDTBL := AVCTOD("  /  /  ")
   
      If EE8->EE8_DTENTR < dDtIni .or. If(Empty(dDtFim),.f.,EE8->EE8_DTENTR > dDtFim)
         EE8->(DBSKIP())
         Loop
      ENDIF
   
     EE7->(DBSETORDER(1))
     EE7->(DBSEEK(XFILIAL("EE7")+EE8->EE8_PEDIDO))
     EE9->(DBSETORDER(1))

      //WFS 07/08/09
      //Filtro da tela de parâmetros do relatório
      //Quando não for preenchida a unidade de medida do peso do item, o sistema assumirá kg por default
      If AllTrim(cMoeda) <> AllTrim(EE7->EE7_MOEDA) .Or.;
         (!Empty(EE8->EE8_UNPES) .And. AllTrim(cUnMed) <> AllTrim(EE8->EE8_UNPES)) .Or.;
         (Empty(EE8->EE8_UNPES) .And. AllTrim(Upper(cUnMed)) <> "KG")
         
         EE8->(DBSkip())
         Loop
      EndIf

     IF EE9->(DBSEEK(XFILIAL("EE9")+EE8->(EE8_PEDIDO+EE8_SEQUEN))) //Alterado pelo Ricardo.
        cRE := if(EMPTY(EE9->EE9_RE),"",transf(EE9->EE9_RE,avsx3("EE9_RE",6)))
        cEMBARQ := EE9->EE9_PREEMB
        EEC->(DBSETORDER(1))
        IF EEC->(DBSEEK(XFILIAL("EEC")+EE9->EE9_PREEMB))
           dDTBL := EEC->EEC_DTCONH
        ENDIF
     ENDIF   
   
     lPais   := cPais <> STR0009 .and. cPais <> POSICIONE("SA1",1,XFILIAL("SA1")+EE7->EE7_IMPORT,"A1_PAIS") //"TODOS"
     lFabr   := cFabr <> STR0009 .and. If( !Empty( EE8->EE8_FABR ), cFabr <> EE8->EE8_FABR, cFabr <> EE8->EE8_FORN ) //"TODOS" - Alterado p/ agrupar tb por Fornecedor.
     lExport := cExport<>STR0009 .and. IF(EMPTY(EE7->EE7_EXPORT),cExport <> EE7->EE7_FORN,cExport <> EE7->EE7_EXPORT) //"TODOS"
     lImport := cImport<>STR0009 .and. EE7->EE7_IMPORT <> cImport //"TODOS"
     lPedido := !EMPTY(cPedido) .and. EE8->EE8_PEDIDO <> cPedido
     lPedQuit:= cTpPed==aTpPed[2] .and. EE8->EE8_SLDATU == 0
   
     IF ( lPais .or. lFabr .or. lExport .or. lImport .or. lPedido .or. lPedQuit)
         EE8->(DBSKIP())
         Loop
     ENDIF
     
     DET->(DBAPPEND())
     DET->SEQREL  := cSeqRel 
     
     IF cTpOrdem==aTpOrdem[1]
        DET->ORDEM := EE7->EE7_IMPORT
     ELSEIF cTpOrdem==aTpOrdem[2]
        DET->ORDEM := DTOC(EE7->EE7_DTPEDI)
     ELSEIF cTpOrdem==aTpOrdem[3]
        DET->ORDEM := EE7->EE7_PEDIDO
     ELSE
        DET->ORDEM := DTOC(EE8->EE8_DTENTR)
     ENDIF
     DET->PEDIDO   := EE7->EE7_PEDIDO
     DET->DTPEDIDO := EE7->EE7_DTPEDI
     DET->DTENTREG := EE8->EE8_DTENTR
     DET->IMPORT   := Posicione("SA1",1,XFILIAL("SA1")+EE7->EE7_IMPORT,"A1_NREDUZ")
     DET->REFIMPORT:= EE7->EE7_REFIMP
//   DET->FABRIC   := Posicione("SA2",1,XFILIAL("SA2")+EE8->EE8_FABR,"A2_NREDUZ")
     DET->FABRIC   := Posicione("SA2",1,XFILIAL("SA2")+If( !Empty( EE8->EE8_FABR ), EE8->EE8_FABR, EE8->EE8_FORN ),"A2_COD") + Posicione("SA2",1,XFILIAL("SA2")+If( !Empty( EE8->EE8_FABR ), EE8->EE8_FABR, EE8->EE8_FORN ),"A2_LOJA")
     DET->NOMFABRI := Posicione("SA2",1,XFILIAL("SA2")+If( !Empty( EE8->EE8_FABR ), EE8->EE8_FABR, EE8->EE8_FORN ),"A2_NREDUZ")
     DET->RE       := cRE
     cPedAntx      := EE8->EE8_PEDIDO
     lPrimX := .f.
     
      cUnidade    := If(!Empty(EE8->EE8_UNIDAD),EE8->EE8_UNIDAD,"KG")                                                  
      DET->UNIDAD := cUnidade
      DET->QTDE   := EE8->EE8_SLDINI
      nTotQtde    += AVTransUnid(cUnidade,cUnMed,EE8->EE8_COD_I,EE8->EE8_SLDINI)
     
      DET->PUNIT := EE8->EE8_PRECOI
      DET->MOEDA := EE7->EE7_MOEDA
     
      DET->TOTAL := EE8->EE8_PRCINC
      nTotGeral  += EECCalcTaxa(EE7->EE7_MOEDA,cMoeda,EE8->EE8_PRCINC,2)
        
      DET->EMBARQUE := cEMBARQ
      DET->QTDEEMB  := EE8->EE8_SLDINI - EE8->EE8_SLDATU
      DET->SLDQTDE  := EE8->EE8_SLDATU
      DET->DTBL     := dDTBL
      
      nCor := 2
      IF cTpProd==aTpProd[2] // ### "Descrição"
        cProd := MSMM(EE8->EE8_DESC,AVSX3("EE8_VM_DES",3))
        cProd1 := memoline(cProd,30,1)
        ncontaLin:= 1
        Do while  !empty(cProd1)
           If ncontalin > 1
              nCor := 1
              DET->(DBAPPEND())
              DET->SEQREL  := cSeqRel 
              IF cTpOrdem==aTpOrdem[1]
                 DET->ORDEM := EE7->EE7_IMPORT
              ELSEIF cTpOrdem==aTpOrdem[2]  
                 DET->ORDEM := DTOC(EE7->EE7_DTPEDI)
              ELSEIF cTpOrdem==aTpOrdem[3]
                 DET->ORDEM := EE7->EE7_PEDIDO
              ELSE
                 DET->ORDEM := DTOC(EE8->EE8_DTENTR)
              ENDIF
               
               // HFD - 30.mar.2009 - Campos necessários devido aos agrupamentos em rel13.rpt
               DET->MOEDA  := EE7->EE7_MOEDA
               DET->UNIDAD := cUnidade       
               DET->FABRIC   := Posicione("SA2",1,XFILIAL("SA2")+If( !Empty( EE8->EE8_FABR ), EE8->EE8_FABR, EE8->EE8_FORN ),"A2_COD") + Posicione("SA2",1,XFILIAL("SA2")+If( !Empty( EE8->EE8_FABR ), EE8->EE8_FABR, EE8->EE8_FORN ),"A2_LOJA") 
               DET->NOMFABRI := Posicione("SA2",1,XFILIAL("SA2")+If( !Empty( EE8->EE8_FABR ), EE8->EE8_FABR, EE8->EE8_FORN ),"A2_NREDUZ")
            Endif
            DET->PRODUTO  := cProd1
            DET->CONTRCOR := nCor
            ncontaLin += 1
            cProd1 := memoline(cProd,27,ncontalin)
        Enddo
     ELSE
        DET->PRODUTO  := EE8->EE8_COD_I
        DET->CONTRCOR := nCor
     ENDIF
     
     EE8->(DBSKIP())
     lZero := .f.
   Enddo
   
   IF ( lZero )
      MSGINFO(STR0012, STR0013) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
      Break
   ENDIF

   //Imprime o Total Geral   
   CAB->TOTQTD := nTotQtde
   CAB->TOTAL  := nTotGeral
   
End Sequence

IF ( lRet )
   lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
ELSE
   // Fecha e apaga os arquivos temporarios
   CrwCloseFile(aRetCrw,.T.)
ENDIF
            
//retorna a situacao anterior ao processamento
RestOrd(aOrd)

Return .f.
         
//----------------------------------------------------------------------
Static Function TelaGets

   Local lRet  := .f.

   Local oDlg

   Local nOpc := 0, cImpd
   Local bOk  := {|| nOpc:=1, oDlg:End() }
   Local bCancel := {|| oDlg:End() }
   Local oPanel
      
   Begin Sequence
      
      DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 35,50 /*33,50*/ OF oMainWnd //FDR - 16/01/12 - Ajuste de tela
            
      oPanel:= TPanel():New(0, 0, "",oDlg,, .F., .F.,,, 50, 26)
   
      @  17,05 SAY STR0014 PIXEL Of oPanel //"Data Inicial"
      @  17,50 MSGET dDtIni SIZE 40,8 PIXEL Of oPanel
      
      @  30,05 SAY STR0015 PIXEL Of oPanel //"Data Final"
      @  30,50 MSGET dDtFim SIZE 40,8 Valid fConfData(dDtFim, dDtIni)  PIXEL Of oPanel
      
      @  43,05 SAY STR0016  PIXEL Of oPanel //"Fabricante"
      @  43,50 MSGET cFabr PICT AVSX3("A2_COD",6) valid (Empty(cFabr).or.ExistCpo("SA2")) SIZE 40,8 F3 "SA2" PIXEL Of oPanel
   
      @  56,05 SAY STR0017 PIXEL Of oPanel //"Exportador"
      @  56,50 MSGET cExport PICT AVSX3("A2_COD",6) valid (Empty(cExport).or.ExistCpo("SA2")) SIZE 40,8 F3 "SA2" PIXEL Of oPanel
      
      @  69,05 SAY STR0001 PIXEL Of oPanel //"Importador"
      @  69,50 MSGET cImport PICT AVSX3("A1_COD",6) valid (Empty(cImport).or.ExistCpo("SA1")) SIZE 40,8 F3 "SA1" PIXEL Of oPanel 
      @  69,50 MSGET cImpD pixel Of oPanel
      
      @  82,05 SAY STR0018 PIXEL Of oPanel //"Pais Importador"
      @  82,50 MSGET cPais PICT AVSX3("YA_CODGI",6) valid (Empty(cPais).or.ExistCpo("SYA")) SIZE 30,8 F3 "SYA" PIXEL Of oPanel 
        
      @  95,05 SAY STR0003 PIXEL Of oPanel //"Pedido"
      @  95,50 MSGET cPedido PICT AVSX3("EE7_PEDIDO",6) valid fProcPro(cPedido) SIZE 60,8 F3 "EE7" PIXEL Of oPanel

      @ 108,05  SAY STR0019 PIXEL Of oPanel //"Ordenar por"
      TComboBox():New(108,50,bSETGET(cTpOrdem),aTpOrdem,60,60,oPanel,,,,,,.T.)
    
      @ 121,05  SAY STR0020 PIXEL Of oPanel //"Produto"
      TComboBox():New(121,50,bSETGET(cTpProd),aTpProd,60,60,oPanel,,,,,,.T.)
    
      @ 134,05  SAY STR0021 PIXEL Of oPanel //"Pedidos Quitados"
      TComboBox():New(134,50,bSETGET(cTpPed),aTpPed,30,60,oPanel,,,,,,.T.)
                                                        
      @ 147,05 SAY STR0023 PIXEL Of oPanel //"Unidade do Total"
      @ 147,50 MSGET cUnMed PICT AVSX3("EE8_UNIDAD",6) valid (!Empty(cUnMed) .and. ExistCpo("SAH")) SIZE 20,8 F3 "SAH" PIXEL Of oPanel

      @ 160,05 SAY STR0024 PIXEL Of oPanel //"Moeda do Total"
      @ 160,50 MSGET cMoeda PICT AVSX3("EE7_MOEDA",6) valid (!Empty(cMoeda) .and. ExistCpo("SYF")) SIZE 30,8 F3 "SYF" PIXEL Of oPanel
                                                        
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
         MsgInfo(STR0022,STR0013) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
      Else
         lRet := .t.
      Endif   

End Sequence
      
Return lRet

/*
Funcao      : fProcPro(cProc)
Parametros  : numero do processo
Retorno     : .T. ou .F.
Objetivos   : Validar entrada de dados
Autor       : Cristiane de Campos Figueiredo
Data/Hora   : 05/09/00 10:05
Revisao     :
Obs.        :
*/
Static Function fProcPro(cProc)
   lRet := .T.
   Begin Sequence
      EE7->(DBSETORDER(1))
      If !(EE7->(DBSEEK(XFILIAL("EE7")+cProc)) .and. EE7->EE7_STATUS <> ST_PC) .and. !Empty(cProc)
         HELP(" ",1,"REGNOIS")
         lRet := .f.
      Endif

  End Sequence

Return lRet
*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL13.PRW                                                 *
*------------------------------------------------------------------------------*
