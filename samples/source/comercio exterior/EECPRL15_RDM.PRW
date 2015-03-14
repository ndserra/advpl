//Alcir Alves - Revisão - 21-11-05 - correções no conceito de multifilial nas consultas
#INCLUDE "EECPRL15.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "EECRDM.CH"
#INCLUDE "RWMAKE.CH"
/*                                                                             
Funcao      : EECPRL15().
Parametros  : Nenhum.
Retorno     : .F.
Objetivos   : Follow-up de Cambio.
Autor       : Jeferson Barros Jr.
Data/Hora   : 10/08/2001 - 8:42.
Obs.        : Arquivo - REL15.RPT.
Revisao     : 
*/

*-----------------------------------*
User Function EECPRL15()
*-----------------------------------*

Local nOldArea  := ALIAS()
Local lRet      := .f.
Local aOrd      := SaveOrd({"EE9","EEM","EEC","EEB","EE7"})
Private xcFil   := cFilAnt //LRL 23/12/04 
Private aSelFil :={}
Private lTipCon := EEQ->(FieldPos("EEQ_TP_CON")) > 0
Private aArqs,;
      cNomDbfC := "R28001C",;
      aCamposC := {{"SEQREL    ","C",08,0},;
                   {"CHAVE     ","C",15,0},;
                   {"LBLIMPORT ","C",12,0},;
                   {"IMPORT    ","C",83,0},;
                   {"TITULO    ","C",100,0},;
                   {"PERIODO   ","C",100,0},;
                   {"LBLMOEDA  ","C",07,0},;
                   {"MOEDA     ","C",12,0},;
                   {"SOMAVLNFS ","C",18,0},;
                   {"SOMAVLRS  ","C",18,0},;
                   {"LBLEVENTO ","C",10,0},;
                   {"EVENTO    ","C",15,0},;
                   {"CODFILIAL ","C",02,0},;
                   {"LBLCABIMP ","C",12,0}},; // JPP 23/03/05 - 14:00
      cNomDbfD := "R28001D",;
      aCamposD := {{"SEQREL    ","C", 8,0},;
                   {"CHAVE     ","C",15,0},;
                   {"PROCESSO  ","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;   
                   {"DTPROCESSO","C",10,0},;   
                   {"DTVENC    ","C",10,0},;
                   {"DTPGT     ","C",10,0},;
                   {"IMPODE    ","C",60,0},; 
                   {"MOEDA     ","C",AVSX3("EEC_MOEDA" ,AV_TAMANHO),0},;  // By JPP - 27/08/04 14:00 - conversão dos campos utilizados no relatório para caracter.
                   {"VALORNFS  ","C",18,0},;               // AVSX3("EEM_VLNF"  ,AV_TAMANHO),AVSX3("EEM_VLNF"  ,AV_DECIMAL)},;
                   {"VALORUSS  ","C",18,0},;               // AVSX3("EEC_TOTPED",AV_TAMANHO),AVSX3("EEC_TOTPED",AV_DECIMAL)},;
                   {"TXCAMBIO  ","C",15,0},;               // AVSX3("EEC_CBTX"  ,AV_TAMANHO),AVSX3("EEC_CBTX"  ,AV_DECIMAL)},;
                   {"VALORRS   ","C",18,0},;               // AVSX3("EEC_CBTX"  ,AV_TAMANHO),AVSX3("EEC_CBTX"  ,AV_DECIMAL)},;
                   {"BANCO     ","C",50,0},;
                   {"EVENTDESCR","C",24,0},;
                   {"FLAG      ","C",01,0}}
                   Aadd(aCamposD,{"FILORI    ","C",02,0})//LRL 23/12/04 
                   Aadd(aCamposD,{"FILNAME   ","C",15,0})//AAF 04/01/05 
                   Aadd(aCamposD,{"FLAG2     ","C",01,0})//LRL 23/12/04

                   /*
                   AMS - 26/11/2005. Adicionado campo Tipo de Contrato no aCamposD.
                   */
                   If lTipCon
                      aAdd(aCamposD, {"TIPCON", "C", 30, 0}) //AMS 26/11/2005.
                   EndIf

Private cPictNfs :=AVSX3("EEM_VLNF"  ,AV_PICTURE), cPictUss := AVSX3("EEC_TOTPED",AV_PICTURE),;  
        cPictRs := AVSX3("EEQ_VL"  ,AV_PICTURE), cPictTx := AVSX3("EEQ_TX"  ,AV_PICTURE) 
Private dDtIni    := AVCTOD("  /  /  ")
Private dDtFim    := AVCTOD("  /  /  ")
Private cImport   := Space(AVSX3("A1_COD",3))
Private cArqRpt, cTitRpt
Private aRadio := {STR0002,STR0003,STR0004,STR0005} //"Em Aberto - Embarcado"###"Em Aberto - Previsão de Emb."###"Em Aberto - Ambos"###"Liquidados "
Private nRadio := 1
Private aCombo := {STR0006,STR0007} //"Sim"###"Nao"
Private cCombo := aCombo[2]
Private lZero  := .T.
Private lNovo  := .F.
Private cFile
Private cAlias
Private cTitulo, oCbxTitulo
Private aBoxTitulo:={STR0039,STR0040} // "A pagar"###"A receber"
Private cFornec := Space(AVSX3("A2_COD",AV_TAMANHO))
Private cMoeda := Space(AVSX3("YF_MOEDA",AV_TAMANHO))
Private cNomeFor := Space(AVSX3("A2_NOME",AV_TAMANHO)), cNomeImp := Space(AVSX3("A1_NOME",AV_TAMANHO))
Private aSomaMoeda := {}
Private aSomaMoefil:= {} //LRL 03/01/2005
Private oGetFor, oGetImp, oGetNomeFor, oGetNomeImp
Private oGetEve, cEvento := Space(3)
Private lEvento
Private cTipCon := ""

If lTipCon
   Private aTipCon := ComboX3Box("EEQ_TP_CON", X3Cbox())
   aAdd(aTipCon, "")
EndIf

Begin Sequence

   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := "REL15.RPT"
      cTitRpt := STR0008 //"Follow-up de Cambio"
   Endif 
   If EEQ->(FieldPos("EEQ_EVENT")) > 0   // By JPP - 30/03/2005 - 15:00
      lEvento := .t.
   Else
      lEvento := .f.
   EndIf  
   //LRL-23/12/04----------------Seleção de Filiais----------------------------------------
//   If lMultiFil
      aSelFil:=AvgSelectFil(.T.,"EEC")
//   EndIf
   //----------------------------Seleção de Filiais-----------------------------LRL-23/12/04
   IF ! TelaGets()
      lRet := .F.
      Break
   Endif

   aARQS := {}
   AADD(aARQS,{cNOMDBFC,aCAMPOSC,"CAB","SEQREL"})
   AADD(aARQS,{cNOMDBFD,aCAMPOSD,"DET","SEQREL"})

   aRetCrw := CrwNewFilee(aARQS)   

   IF nRadio = 2 .Or. nRadio = 3 // A Vencer - Previsão de Emb. ou Ambos
      cAlias := "QRY2"
   Else
      cAlias := "QRY"
   Endif
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         cCmd := MontaQuery(nRadio)
         cCmd := ChangeQuery(cCmd)
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), cAlias, .F., .T.)
         Processa({|| lRet := Imprimir() })
      ELSE
   #ENDIF
         // ** Grava arquivo temporário ...     
         GravaDBF(nRadio,cAlias)
         MsAguarde({||lRet := Imprimir()},STR0009)                                                                  //"Imprimindo registros ..."
   #IFDEF TOP
      ENDIF
   #ENDIF
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()   

   IF ( lZero )
      MSGINFO(STR0010, STR0011) //"Intervalo sem dados para impressão"###"Aviso"
      lRet := .f.
   ENDIF

   IF Empty(cFile)
      QRY->(dbCloseArea())
   Else 
      QRY->(E_EraseArq(cFile))
   Endif

   IF ( lRet )
      lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   ELSE
      // Fecha e apaga os arquivos temporarios
      CrwCloseFile(aRetCrw,.T.)
   ENDIF

   IF Select("Work_Men") > 0
      Work_Men->(E_EraseArq(cWork))
   Endif              
   
End Sequence   

dbSelectArea(nOldArea)
cFilAnt := xcFil
RestOrd(aOrd)

Return (.F.)


*-----------------------------------*
Static Function TelaGets
*-----------------------------------*

Local lRet  := .f.
Local nOpc  := 0
Local bOk, bCancel 
Local nLin, nCol, lSelecao := .f.,oRadio

Begin Sequence
   if ! EECFlags("FRESEGCOM")    // By JPP - 19/08/04 09:45 - Se a estrutura de dados EEQ é antiga. Mantém a tela original.
      If lEvento
         nLin := 26
         nCol := 45 //42  
      Else   
         nLin := 25
         nCol := 30
      EndIf
   Else // Se a estrutura da tabela EEQ é nova, define a nova tela.
      aRadio[4] := STR0041 // "Liquidados"
      nLin := 32.5
      nCol :=  50 //42 // By JPP - 18/10/2006 - 17:45 - Correção na dimensão da tela para ambiente MDI.

      /*
      AMS - 26/11/2005. Ajuste da Dialog para apresentar o combo para seleção do Tipo de Contrato.
      */
      If lTipCon
         nLin += 3
      EndIf
   EndIf

   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO nLin,nCol OF oMainWnd //27,30 

      If ! EECFlags("FRESEGCOM")  // By JPP - 19/08/04 09:45 - Se a estrutura de dados EEQ é antiga. Mantém a tela Original. 
         If lEvento
            @ 16,03 To 58.5,164 TITLE STR0012  //"Cambios"
            //@ 23,07 RADIO aRadio VAR nRadio
            @ 23,07 Radio nRadio Items aRadio[1],aRadio[2],aRadio[3],aRadio[4]  On Change(ConfTitulo(nRadio))  size 100,08 of Odlg pixel 
         
            @ 60,07 SAY STR0013 PIXEL //"Cliente"
            @ 60,42 MSGET cImport F3 "SA1" Valid (Empty(cImport) .or. ExistCPO("SA1") .And. TipoCorreto("IMPORT")) SIZE 40,8 PIXEL
                
            @ 72,07 Say STR0038 Pixel  // "Descrição" 
            @ 72,42 MsGet oGetNomeImp Var cNomeImp Size 120,8 Pixel
            
            @ 84,07 Say STR0058 Pixel  // "Evento"  
            @ 84,42 MsGet oGetEve Var cEvento F3 "E24" Valid (Empty(cEvento) .or. ExistEvent(cEvento) ) Size 20,8 Pixel

            @ 96,07 SAY STR0014 PIXEL //"Data Inicial"
            @ 96,42 MSGET dDtIni SIZE 40,8 PIXEL
      
            @ 108,07 SAY STR0015 PIXEL //"Data Final"
            @ 108,42 MSGET dDtFim valid(fConfData(dDtFim,dDtIni)) SIZE 40,8 PIXEL
            
            oGetNomeImp:Disable()
         Else   
            @ 16,10 To 59,112 TITLE STR0012  //"Cambios"
            @ 23,15 RADIO aRadio VAR nRadio 
         
            @ 65,15 SAY STR0013 PIXEL //"Cliente"
            @ 65,70 MSGET cImport F3 "SA1" Valid (Empty(cImport) .or. ExistCPO("SA1")) SIZE 40,8 PIXEL

            @ 80,15 SAY STR0014 PIXEL //"Data Inicial"
            @ 80,70 MSGET dDtIni SIZE 40,8 PIXEL
      
            @ 95,15 SAY STR0015 PIXEL //"Data Final"
            @ 95,70 MSGET dDtFim valid(fConfData(dDtFim,dDtIni)) SIZE 40,8 PIXEL
         EndIf
      Else // Se a estrutura da tabela EEQ é nova, define a nova tela, com os novos filtros.
         @ 16,03 To 59,164 Title STR0012  //"Cambios"  110 -10
         @ 23,07 Radio nRadio Items aRadio[1],aRadio[2],aRadio[3],aRadio[4]  On Change(ConfTitulo(nRadio))  size 100,08 of Odlg pixel

         If lTipCon
            @ 60,03 to 196,164 Title STR0042
         Else
            @ 60,03 to 176,164 Title STR0042
         EndIf

         @ 68,07 Say STR0035 Pixel // "Titulo"
         @ 5.155, 5.3 ComboBox oCbxTitulo Var cTitulo Items  aBoxTitulo valid(DefineTit(cTitulo)) Size 40, 40 Of oDlg //65,70

         @ 79,07 Say STR0036 Pixel // "Moeda"
         @ 79,42 MsGet cMoeda F3 "SYF" Valid (Empty(cMoeda) .or. ExistCPO("SYF")) Size 20,8 Pixel

         @ 91,07 Say STR0037 Pixel  // "Fornecedor"
         @ 91,42 MsGet oGetFor Var cFornec F3 "SA2" Valid (Empty(cFornec) .or. ExistCPO("SA2") .And. TipoCorreto("FORNEC")) Size 20,8 Pixel

         @ 103,07 Say STR0038 Pixel  // "Descrição"
         @ 103,42 MsGet oGetNomeFor Var cNomeFor Size 120,8 Pixel

         @ 114,07 Say STR0051 Pixel  // "Importador"
         @ 114,42 MsGet oGetImp Var cImport F3 "SA1" Valid (Empty(cImport) .or. ExistCPO("SA1") .And. TipoCorreto("IMPORT")) Size 20,8 Pixel

         @ 126,07 Say STR0038 Pixel  // "Descrição"
         @ 126,42 MsGet oGetNomeImp Var cNomeImp Size 120,8 Pixel

         @ 137,07 Say STR0058 Pixel  // "Evento"
         @ 137,42 MsGet oGetEve Var cEvento F3 "E24" Valid (Empty(cEvento) .or. ExistEvent(cEvento) ) Size 20,8 Pixel

         @ 149,07 Say STR0014 Pixel //"Data Inicial"
         @ 149,42 MsGet dDtIni Size 40,8 Pixel

         @ 161,07 Say STR0015 PIXEL //"Data Final"
         @ 161,42 MsGet dDtFim valid(fConfData(dDtFim,dDtIni)) Size 40,8 Pixel

         /*
         AMS - 26/11/2005. Inclusão do filtro Tipo de Contrato.
         */
         If lTipCon
            @ 175,07 Say AvSX3("EEQ_TP_CON", AV_TITULO) Pixel
            @ 13.350, 5.3 ComboBox oCbxTipCon Var cTipCon Items aTipCon Size 90, 40 Of oDlg
         EndIf

         oGetNomeFor:Disable()
         oGetNomeImp:Disable()
         If ! lSelecao
            cTitulo := aBoxTitulo[1]
            DefineTit(cTitulo)
            lSelecao := .t. 
         EndIf
      EndIf
      bOk     := {|| If(fConfData(dDtFim,dDtIni),(nOpc:=1, oDlg:End()),nOpc:=0)}
      bCancel := {|| oDlg:End() }

   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED

   IF nOpc == 1
      lRet := .t.
   Endif 

End Sequence

Return lRet   
   
*-----------------------------------*
Static Function fConfData(dFim,dIni)
*-----------------------------------*
Local lRet  := .f.

Begin Sequence      
   if !empty(dFim) .and. dFim < dIni
      MsgInfo(STR0016,STR0011) //"Data Final não pode ser menor que Data Inicial" //"Aviso"
   Else
      lRet := .t.
   Endif   
End Sequence
      
Return lRet
  
#IFDEF TOP
   *-----------------------------------*
   Static Function TransData(sData)
   *-----------------------------------*
   if Empty(sData)
      sData := "  /  /  "
   Else
      sData := SubStr(AllTrim(sData),7,2) + "/" + SubStr(AllTrim(sData),5,2) + "/" +   SubStr(AllTrim(sData),3,2)
   Endif

   Return sData 
#ENDIF
 
*--------------------------------------------------------------------
Static FUNCTION GPARC(cProc)
LOCAL Z,nTOTAL := 0,aPARC  := {}
LOCAL nCMP_VLR,dCMP_VCT

Begin Sequence

   EEC->(dbSetOrder(1))
   EEC->(dbSeek(xFilial()+cProc))
   
   // CALCULA AS PARCELAS E SEUS VENCIMENTOS
   SY6->(DBSETORDER(1))
   SY6->(DBSEEK(XFILIAL("SY6")+EEC->(EEC_CONDPA+STR(EEC_DIASPA,3,0))))
   
   IF SY6->Y6_TIPO = "1"       &&& NORMAL
      AADD(aPARC,{EEC->EEC_TOTPED,EEC->EEC_ETD+EEC->EEC_DIASPA})
   ELSEIF SY6->Y6_TIPO = "2"   &&& A VISTA
      AADD(aPARC,{EEC->EEC_TOTPED,EEC->EEC_ETD})
   
   ELSE   &&& PARCELADO
      FOR Z := 1 TO 10
          nCMP_VLR := "SY6->Y6_PERC_"+STRZERO(Z,2,0)
          dCMP_VCT := "SY6->Y6_DIAS_"+STRZERO(Z,2,0)
          
          IF &nCMP_VLR = 0
             EXIT
          ENDIF                                         
          
          AADD(aPARC,{EEC->EEC_TOTPED*(&nCMP_VLR/100),EEC->EEC_ETD+&dCMP_VCT})
          nTOTAL := nTOTAL+aPARC[LEN(aPARC),1]
      NEXT
      
      // ACERTANDO A DIFERENCA DE PARCELAS
      IF LEN(aPARC) > 0
         IF STRZERO(EEC->EEC_TOTPED,20,2) # STRZERO(nTOTAL,20,2)
            aPARC[LEN(aPARC),1] := aPARC[LEN(aPARC),1]+(EEC->EEC_TOTPED-nTOTAL)
         ENDIF
      ELSE
         MSGINFO(STR0017+ALLTRIM(EEC->EEC_PREEMB),STR0011) //"Verificar Processo: " //"Aviso"
      ENDIF
   ENDIF         
End Sequence

RETURN(aParc)

/*
Funcao          : MontaQuery
Parametros      : nRad => Tipo de seleção
Retorno         : Query
Objetivos       : Montar a query para selecionar registros para a impressao
Autor           : CAF / JBJ
Data/Hora       : 14/07/2001 13:25
Revisao         :
Obs.            : 
*/
Static Function MontaQuery(nRad,cSelect)

Local cQry := cSelect ,;
      cWhere2 := "", cOrder := "", cWhere := ""    
      
Local cFil := "", i

If lMulTiFil //LRL 23/12/04
   For i:= 1 to len(aSelFil)
      cFil+="'"+aSelFil[i]+"'"
      If i < len(aSelFil)
         cFil+=","
      EndIf 
   Next
EndIF
      

//Private cWhere

/*
   cCmd   := "SELECT EEC_PREEMB, EEC_DTPROC, EEC_CBVCT, EEC_CBPGT, EEC_IMPODE, EEC_TOTPED, EEC_CBTX, EEC_MOEDA, EEC_DTEMBA FROM " +;  
             RetSqlName("EEC") + " EEC "
   
   cWhere := " WHERE D_E_L_E_T_ <> '*' AND "+; 
             " EEC_FILIAL = '" +xFilial("EEC")+ "' AND "+;
             " EEC_DTEMBA <> '' "
   
   A-A Vencer - Embarcado, Recebidos
   ==================================================
   SELECT 
      EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, 
      EEC_DTEMBA, EEQ_VCT, EEQ_PGT, EEQ_VL, EEQ_TX
   FROM
       EEC990 EEC, EEQ990 EEQ
   WHERE
      EEC.D_E_L_E_T_ <> '*' AND  EEC_FILIAL = '  ' AND 
      EEC_DTEMBA <> '' AND EEQ_PREEMB = EEC_PREEMB AND 
      EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL = '  '

   B-A Vencer - Previsão de Emb. (nRadio = 2)
   ==================================================
   SELECT 
      EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, 
      EEC_DTEMBA, '        ' AS EEQ_VCT, '        ' AS EEQ_PGT, 0 AS EEQ_VL, 0 AS EEQ_TX
   FROM
      EEC990 EEC
   WHERE
      EEC.D_E_L_E_T_ <> '*' AND
      EEC_FILIAL = '  ' AND EEC_DTEMBA = '' AND 
      EEC_ETD <> ''
      
   C-A Vencer - Ambos (nRadio = 3)
   ==================================================
   SELECT 
      EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, 
      EEC_DTEMBA, EEQ_VCT, EEQ_PGT, EEQ_VL, EEQ_TX
   FROM
      EEC990 EEC, EEQ990 EEQ
   WHERE
      EEC.D_E_L_E_T_ <> '*' AND  EEC_FILIAL = '  ' AND 
      EEC_DTEMBA <> '' AND EEQ_PREEMB = EEC_PREEMB AND 
      EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL = '  '
   UNION
   SELECT 
      EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, 
      EEC_DTEMBA,  '        ' AS EEQ_VCT, '        ' AS EEQ_PGT, 0 AS EEQ_VL, 0 AS EEQ_TX
   FROM
      EEC990 EEC
   WHERE
      EEC.D_E_L_E_T_ <> '*' AND
      EEC_FILIAL = '  ' AND EEC_DTEMBA = '' AND 
      EEC_ETD <> ''
*/                                         

Begin Sequence
   
   IF Empty(cQry)
      If ! EECFlags("FRESEGCOM")  // By JPP - 18/08/04 19:15 - Se a estrutura de dados EEQ é antiga. Mantém select antigo.
         If lEvento // By JPP - 30/03/2005 - 17:40
            If nRad <> 2
               cQry := "SELECT "+if(lMultiFil,"EEC_FILIAL , ","")+" EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, EEC_DTEMBA, EEC_ETD, EEQ_EVENT" 
            Else
               cQry := "SELECT "+if(lMultiFil,"EEC_FILIAL , ","")+" EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, EEC_DTEMBA, EEC_ETD,'  ' AS EEQ_EVENT"
            EndIf              
         Else
            cQry := "SELECT "+if(lMultiFil,"EEC_FILIAL , ","")+" EEC_PREEMB, EEC_DTPROC, EEC_IMPODE, EEC_MOEDA, EEC_DTEMBA, EEC_ETD"
         EndIf
      Else // Se a estrutura de dados EEQ é Nova. Define o novo select.
         If nRad <> 2
            cQry := "SELECT "+if(lMultiFil,"EEC_FILIAL, ","")+" EEC_PREEMB, EEC_DTPROC, EEQ_IMPORT, EEQ_IMLOJA, EEQ_FORN, EEQ_FOLOJA,"
            cQry += " EEQ_MOEDA, EEC_DTEMBA, EEC_ETD, EEQ_EVENT"
         Else
            cQry := "SELECT "+if(lMultiFil,"EEC_FILIAL, ","")+" EEC_PREEMB, EEC_DTPROC, EEC_IMPORT As EEQ_IMPORT, EEC_IMLOJA AS EEQ_IMLOJA,"
            cQry +=" EEC_FORN AS EEQ_FORN, EEC_FOLOJA AS EEQ_FOLOJA, EEC_MOEDA AS EEQ_MOEDA, EEC_DTEMBA, EEC_ETD, '  ' AS EEQ_EVENT"
         EndIf
      EndIf 

      IF nRad <> 2
         cQry += ", EEQ_VCT, EEQ_PGT, EEQ_VL, EEQ_TX, EEQ_BANC"
         /*
         AMS - 26/11/2005. Adicionado o campo Tipo de Contrato.
         */
         If lTipCon
            cQry += ", EEQ_TP_CON"
         EndIf
      Else
         cQry += ", '        ' AS EEQ_VCT, '        ' AS EEQ_PGT, 0 AS EEQ_VL, 0 AS EEQ_TX, ' ' AS EEQ_BANC"
         If lTipCon  // By JPP - 19/05/2006 - Este campo deve exitir na Query para nRad = 2 na utlização da Clausula UNION.
            cQry += ", ' ' AS EEQ_TP_CON"
         EndIf
      Endif
   Endif 

   cQry += " FROM "+RetSqlName("EEC")+" EEC"

   IF nRad <> 2
      cQry += ", "+RetSqlName("EEQ")+" EEQ"
   Endif

   IF nRad <> 2
      cWhere := " WHERE EEC.D_E_L_E_T_ <> '*' AND " 
      //LRL 23/12/04----Considerar outras filiais-----------------------------------------------------------------------------------------------
      If !lMultiFil
         cWhere += " EEC_FILIAL = '" +xFilial("EEC")+ "' AND "
         cWhere += " EEC_DTEMBA <> '        ' AND EEQ_PREEMB = EEC_PREEMB AND EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL = '"+xFilial("EEQ")+"'"
      Else
         cWhere += " EEC_FILIAL IN (" +cFil+ ") AND "
         cWhere += " EEC_DTEMBA <> '        ' AND EEQ_PREEMB = EEC_PREEMB AND EEQ.D_E_L_E_T_ <> '*' AND EEQ_FILIAL IN (" +cFil+ ") "
      EndIf
   Else
      cWhere := " WHERE EEC.D_E_L_E_T_ <> '*' AND "
      If !lMultiFil
         cWhere += " EEC_FILIAL = '" +xFilial("EEC")+ "' AND "
      Else                                                    
         cWhere += " EEC_FILIAL IN (" +cFil+ ") AND "
      EndIF   
      cWhere += " EEC_DTEMBA = '        ' AND EEC_ETD <> '        '"
       //-----------------------------------------------------------------------------------------------LRL 23/12/04----Considerar outras filiais      
   Endif
   If ! EECFlags("FRESEGCOM")   // By JPP - 19/08/04 09:54 - Se a estrutura de dados EEQ é Antiga.
      If !Empty(cImport)
         cWhere := cWhere + " AND EEC_IMPORT = '" + cImport + "' "
      Endif
      If lEvento // By JPP - 30/03/2005 - 17:50 
         If !Empty(cEvento)       
            If nRad <> 2 .And. nRad <> 3 
               cWhere := cWhere + " AND EEQ_EVENT = '" + cEvento + "' "
            EndIf   
         EndIf      
      EndIf  
   Else  // Se a estrutura de dados EEQ é nova. Define os novos Filtros.
      If nRad <> 2
         If cTitulo = aBoxTitulo[1]  // "Titulos a pagar"
            cWhere := cWhere + " AND EEQ_TIPO = 'P' "
         Else  // "Titulos a receber"
            cWhere := cWhere + " AND EEQ_TIPO = 'R' " 
         Endif
      EndIf   
      If !Empty(cEvento) 
         If nRad <> 2 .And. nRad <> 3 
            cWhere := cWhere + " AND EEQ_EVENT = '" + cEvento + "' "
         EndIf   
      EndIf     
      If !Empty(cMoeda) 
         If nRad <> 2
            cWhere := cWhere + " AND EEQ_MOEDA = '" + cMoeda + "' "
         Else
            cWhere := cWhere + " AND EEC_MOEDA = '" + cMoeda + "' "
         EndIf
      EndIf                                   
      If !Empty(cFornec)
         If nRad <> 2
            cWhere := cWhere + " AND EEQ_FORN = '" + cFornec + "' "
         Else
            cWhere := cWhere + " AND EEC_FORN = '" + cFornec + "' "
         EndIf
      EndIf
      If !Empty(cImport)
         If nRad <> 2
            cWhere := cWhere + " AND EEQ_IMPORT = '" + cImport + "' "   
         Else
            cWhere := cWhere + " AND EEC_IMPORT = '" + cImport + "' "
         EndIf   
      Endif

      /*
      AMS - 26/11/2005. Filtro para o Tipo de Contrato.
      */
      If lTipCon .and. !Empty(cTipCon)
         If nRad <> 2
            cWhere += " AND EEQ_TP_CON = '" + cTipCon + "' "
         EndIf
      EndIf

   EndIf 

   If nRad = 1 // A Vencer - Embarcado
     If !Empty(dDtIni)
        cWhere := cWhere + " AND EEQ_VCT >= '" + DtoS(dDtIni)+"'"
     EndIf

     If !Empty(dDtFim)
        cWhere := cWhere + " AND EEQ_VCT <= '" + DtoS(dDtFim)+"'"
     EndIf                    
     cWhere := cWhere + " AND EEQ_PGT = '        ' "         
     if !("COUNT"$upper(cQry) .or. "SUM"$upper(cQry)) //Alcir Alves - 21-11-05 -no caso de funçoes de agregações o Order by acusa erro
        cOrder := " ORDER BY "+if(lMultiFil," EEC_FILIAL, ","")+"EEQ_VCT"    
     endif
     //
   Elseif nRad = 2 // A Vencer - Previsão Emb.


    
   Elseif nRad = 3 // A Vencer - Ambos
      If !Empty(dDtIni)
         cWhere := cWhere + " AND EEQ_VCT >= '" + DtoS(dDtIni)+"'"
      EndIf
      If !Empty(dDtFim)
         cWhere := cWhere + " AND EEQ_VCT <= '" + DtoS(dDtFim)+"'"         
      EndIf                    
      cWhere := cWhere + " AND EEQ_PGT = '        ' "         
      //cOrder := " ORDER BY EEQ_VCT"     
      
      // Joga o 1o. select para a variavel cCmd            
      cQRY   += cWhere+" UNION "
      cQRY   += MontaQuery(2)
      if !("COUNT"$upper(cQry) .or. "SUM"$upper(cQry)) //Alcir Alves - 21-11-05 -no caso de funçoes de agregações o Order by acusa erro
         cQRY   += " ORDER BY"+if(lMultiFil," EEC_FILIAL, ","")+" EEQ_VCT"
      endif
      cWhere := ""
      cOrder := ""   
         
   Else // Recebidos
      If !Empty(dDtIni)
         cWhere2 := " AND EEQ_PGT >= '" + DtoS(dDtIni)+"'"
      EndIf
      If !Empty(dDtFim)
         cWhere2 := cWhere2 + " AND EEQ_PGT <= '" + DtoS(dDtFim)+"'"         
      EndIf                    
      If Empty(cWhere2)
         cWhere := cWhere + " AND EEQ_PGT > '     ' "         
      Else
         cWhere := cWhere + cWhere2 
      Endif
      if !("COUNT"$upper(cQry) .or. "SUM"$upper(cQry)) //Alcir Alves - 21-11-05 -no caso de funçoes de agregações o Order by acusa erro
      cOrder := " ORDER BY "+if(lMultiFil," EEC_FILIAL , ","")+"EEQ_PGT" 
      endif
   EnDif

End Sequence

Return cQry+cWhere+cOrder
*--------------------------------------------------------------------
Static Function GravaDBF(nRad,cAlias)
Local i ,cFilTemp := cFilAnt
Local cWork,cCONDEEQ,;
      aSemSX3 := {},;
      aOrd    := SaveOrd({"EEC","EEQ","SIX"}),;
      lRet:= .T.

      /*
      aConds:={"EEC->EEC_IMPORT = cImport"+if(!Empty(dDtini).OR.!EMPTY(dDTFIM)," .And.",""),;
               "EEQ->EEQ_VCT >= dDtini ",;
               "EEQ->EEQ_VCT <= dDtfim ",;
               "Empty(EEC->EEC_DTEMBA) ",; 
               "!Empty(EEC->EEC_DTEMBA)",;
               "EEQ->EEQ_PGT >= dDtini ",;
               "EEQ->EEQ_PGT <= dDtfim ",;
               "EEC->EEC_IMPORT = cImport",;
               "EEC->EEC_DTPROC >= dDtini",;               
               "EEC->EEC_DTPROC <= dDtfim"}
      */              
*
aSemSX3 := {{"EEC_FILIAL","C",AVSX3("EEC_FILIAL",AV_TAMANHO),0},;  
            {"EEC_PREEMB","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;  
            {"EEC_IMPODE","C",AVSX3("EEC_IMPODE",AV_TAMANHO),0},;  
            {"EEC_IMPORT","C",AVSX3("EEC_IMPORT",AV_TAMANHO),0},;
            {"EEC_IMLOJA","C",AVSX3("EEC_IMLOJA",AV_TAMANHO),0},;
            {"EEC_FORN"  ,"C",AVSX3("EEC_FORN"  ,AV_TAMANHO),0},;
            {"EEC_FOLOJA","C",AVSX3("EEC_FOLOJA",AV_TAMANHO),0},;
            {"EEC_MOEDA ","C",AVSX3("EEC_MOEDA ",AV_TAMANHO),0},;   
            {"EEC_ETD"   ,"D",AVSX3("EEC_ETD   ",AV_TAMANHO),0},;   
            {"EEC_DTEMBA","D",AVSX3("EEC_DTEMBA",AV_TAMANHO),0},;   
            {"EEC_DTPROC","D",AVSX3("EEC_DTPROC",AV_TAMANHO),0}}
            If EECFlags("FRESEGCOM")//JPP - LRL 30/12/04  
               AaDD(aSemSX3,{"EEQ_IMPORT","C",AVSX3("EEQ_IMPORT",AV_TAMANHO),0})
               Aadd(aSemSX3,{"EEQ_IMLOJA","C",AVSX3("EEQ_IMLOJA",AV_TAMANHO),0})                                                    
            EndIf

cWork  := E_CRIATRAB("EEQ",aSemSX3,cAlias)
IF nRADIO = 4
   IndRegua(cAlias,cWork+OrdBagExt(),if(lMultiFil,"EEC_FILIAL","")+"EEQ_PGT" ,"AllwayTrue()","AllwaysTrue()",STR0001) //"Processando Arquivo Temporario"
ELSE
   IndRegua(cAlias,cWork+OrdBagExt(),if(lMultiFil,"EEC_FILIAL","")+"EEQ_VCT" ,"AllwayTrue()","AllwaysTrue()",STR0001) //"Processando Arquivo Temporario"
ENDIF

Set Index to (cWork+OrdBagExt())

Begin Sequence
For i:= 1 To Len(aSelFil)
   cFilAnt:=aSelFil[i]
   If nRad = 1 // ** A Vencer - Embarcado
      PRL15A()
   ElseIf nRad = 2  // ** A Vencer - Previsão de Embarque.
          PRL15B()
   ELSEIF nRAD = 3  // ** A Vencer - Ambos  ...
          PRL15A()
          PRL15B()
   ELSE   // ** Recebidos
      cCONDEEQ := .F.
      // VERIFICA SE EXISTE O INDICE POR DATA DE PAGAMENTO
      SIX->(DBSETORDER(1))
      SIX->(DBSEEK("EEQ"))
      DO WHILE ! SIX->(EOF()) .AND. SIX->INDICE = "EEQ"
         IF LEFT(UPPER(SIX->CHAVE),24) = "EEQ_FILIAL+DTOS(EEQ_PGT)"
            cCONDEEQ := .T.
            EXIT
         ENDIF
         SIX->(DBSKIP())
      ENDDO
      // GERA O TMP
      IF cCONDEEQ
         EEQ->(DBSETORDER(VAL(SIX->ORDEM)))
         EEQ->(DBSEEK(XFILIAL("EEQ")+STRTRAN(DTOS(dDTINI)," ","0"),.T.))
         IF EMPTY(dDTINI) .AND. EMPTY(dDTFIM)
            cCONDEEQ := ".T."
         ELSEIF ! EMPTY(dDTINI) .AND. EMPTY(dDTFIM)
                cCONDEEQ := "DTOS(EEQ->EEQ_PGT) >= DTOS(dDTINI)"
         ELSEIF EMPTY(dDTINI) .AND. ! EMPTY(dDTFIM)
                cCONDEEQ := "DTOS(EEQ->EEQ_PGT) <= DTOS(dDTFIM)"
         ELSE
            cCONDEEQ := "EEQ->(DTOS(EEQ_PGT) >= DTOS(dDTINI) .AND. DTOS(EEQ_PGT) <= DTOS(dDTFIM))"
         ENDIF
      ELSE
         EEQ->(DBSETORDER(1))
         EEQ->(DBSEEK(XFILIAL("EEQ")))
         cCONDEEQ := ".T."
      ENDIF
      DO WHILE ! EEQ->(EOF()) .AND.;
         EEQ->EEQ_FILIAL = XFILIAL("EEQ") .AND. &cCONDEEQ
         *
         IF ! EMPTY(EEQ->EEQ_PGT)
            EEC->(DBSETORDER(1))
            EEC->(DBSEEK(XFILIAL("EEC")+EEQ->EEQ_PREEMB))

            If ! EECFlags("FRESEGCOM")  // By JPP - 18/08/04 15:54 - Se a estrutura de dados EEQ é antiga. Mantem a gravação de dados antiga.
               IF (EMPTY(cIMPORT) .OR. EEC->EEC_IMPORT = cIMPORT)          .AND.;
                  (EMPTY(dDTINI)  .OR. DTOS(EEQ->EEQ_PGT) >= DTOS(dDTINI)) .AND.;
                  (EMPTY(dDTFIM)  .OR. DTOS(EEQ->EEQ_PGT) <= DTOS(dDTFIM))
                  *
                  (cAlias)->(DBAPPEND())
                  //LRL 30/12/04-----------------------------
                  If lMulTiFil
                     (cAlias)->EEC_FILIAL := EEC->EEC_FILIAL
                  EndIf
                 //-----------------------------LRL 30/12/04
                  (cAlias)->EEC_PREEMB := EEC->EEC_PREEMB  
                  (cAlias)->EEC_DTPROC := EEC->EEC_DTPROC
                  (cAlias)->EEC_IMPODE := EEC->EEC_IMPODE
                  (cAlias)->EEC_MOEDA  := EEC->EEC_MOEDA
                  (cAlias)->EEC_DTEMBA := EEC->EEC_DTEMBA              
                  (cAlias)->EEQ_VCT    := EEQ->EEQ_VCT
                  (cAlias)->EEQ_PGT    := EEQ->EEQ_PGT
                  (cAlias)->EEQ_VL     := EEQ->EEQ_VL
                  (cAlias)->EEQ_TX     := EEQ->EEQ_TX                      
                  (cAlias)->EEQ_BANC   := EEQ->EEQ_BANC
                  If lEvento
                     (cAlias)->EEQ_EVENT  := EEQ->EEQ_EVENT
                  EndIf
               ENDIF
            Else   // Se a estrutura de dados EEQ é nova. Grava os dados de acordo com os novos filtros e os novos campos da tabela EEQ.
               IF (Empty(cImport) .Or. EEQ->EEQ_IMPORT = cImport)          .And.;
                  (Empty(cFornec) .Or. EEQ->EEQ_FORN = cFornec)            .And.;
                  (Empty(cMoeda)  .Or. EEQ->EEQ_MOEDA = cMoeda)            .And.;
                  (Empty(dDtIni)  .Or. DToS(EEQ->EEQ_PGT) >= DToS(dDtIni)) .And.;
                  (Empty(dDtFim)  .Or. DToS(EEQ->EEQ_PGT) <= DToS(dDtFim))
                  *

                  /*
                  AMS - 26/11/2005. Filtro para o tipo de contrato.
                  */
                  If lTipCon .and. !Empty(cTipCon) .and. EEQ->EEQ_TP_CON <> cTipCon
                     EEQ->(dbSkip())
                     Loop
                  EndIf

                  (cAlias)->(DBAPPEND())
                  //LRL 30/12/04-----------------------------
                  If lMulTiFil
                     (cAlias)->EEC_FILIAL := EEC->EEC_FILIAL
                  EndIf
                 //-----------------------------LRL 30/12/04
                  (cAlias)->EEC_PREEMB := EEC->EEC_PREEMB
                  (cAlias)->EEC_DTPROC := EEC->EEC_DTPROC
                  (cAlias)->EEQ_IMPORT := EEQ->EEQ_IMPORT
                  (cAlias)->EEQ_IMLOJA := EEQ->EEQ_IMLOJA
                  (cAlias)->EEQ_FORN   := EEQ->EEQ_FORN
                  (cAlias)->EEQ_FOLOJA := EEQ->EEQ_FOLOJA
                  (cAlias)->EEQ_MOEDA  := EEQ->EEQ_MOEDA
                  (cAlias)->EEC_DTEMBA := EEC->EEC_DTEMBA
                  (cAlias)->EEQ_VCT    := EEQ->EEQ_VCT
                  (cAlias)->EEQ_PGT    := EEQ->EEQ_PGT
                  (cAlias)->EEQ_VL     := EEQ->EEQ_VL
                  (cAlias)->EEQ_TX     := EEQ->EEQ_TX 
                  (cAlias)->EEQ_BANC   := EEQ->EEQ_BANC
                  (cAlias)->EEQ_EVENT  := EEQ->EEQ_EVENT

                  /*
                  AMS - 26/11/2005. Gravação do campo tipo de contrato.
                  */
                  If lTipCon
                     (cAlias)->EEQ_TP_CON := EEQ->EEQ_TP_CON
                  EndIf

               ENDIF 
            EndIf
         ENDIF
         EEQ->(DBSKIP())
      ENDDO
   ENDIF
Next
   cFilAnt := cFilTemp
   RestOrd(aOrd)
   (cAlias)->(DbGoTop())   
End Sequence
Return lRet
*--------------------------------------------------------------------
Static Function Imprimir
Local lRet := .f., nInd, cDescricao
Local cPeriodo, cChave 
Local nValorNfs := 0, nValorUss := 0, nValorRs := 0
Local nSomaVlNfs := 0, nSomaVlRs := 0
lZero := .t.
#IFDEF TOP
   IF TCSRVTYPE() <> "AS/400"
      IF nRadio <> 3
         cCmd     := MontaQuery(nRadio," SELECT COUNT(*) AS NCOUNT, ' ' AS EEQ_VCT, ' 'AS EEQ_PGT ")
         cCmd     := ChangeQuery(cCmd)
         nOldArea := Alias()
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRYTEMP", .F., .T.) 
         ProcRegua(QRYTEMP->NCOUNT)
         QRYTEMP->(dbCloseArea())
         dbSelectArea(nOldArea)
      EndIf
   ELSE
#ENDIF
      //... DBF ...
#IFDEF TOP
   ENDIF
#ENDIF
IF nRadio = 2 .Or. nRadio = 3 // A Vencer - Previsão de Emb. ou Ambos
   cFile := MontaWork(cAlias)
   QRY2->(dbCloseArea())
Endif   

CAB->(DBAPPEND())
CAB->SEQREL  := cSeqRel
CAB->CHAVE   := "_ITEMSDETALHE"
CAB->TITULO  := ""

// ** Define Titulo do Relatório 
If nRadio = 1 
   CAB->TITULO  := STR0018   //"CÂMBIO EM ABERTO - EMBARCADO"  
   cDescricao := STR0018
ElseIf nRadio = 2 
   CAB->TITULO  := STR0019   //"EM ABERTO - PREVISÃO DE EMBARQUE"
   cDescricao := STR0019
ElseIf nRadio = 3
   CAB->TITULO  := STR0034  //"EM ABERTO - AMBOS"
   cDescricao := STR0034
Else
   If ! EECFlags("FRESEGCOM")
      CAB->TITULO  := STR0020   //"LIQUIDADOS"
      cDescricao := STR0020 
   Else
      CAB->TITULO  := STR0043 //"LIQUIDADOS" 
      cDescricao := STR0043 //"LIQUIDADOS"
   EndIf      
Endif

If EECFlags("FRESEGCOM")  // // JPP - 19/08/04 17:50 - Se a estrutura de dados EEQ é Nova. Define o novo Titulo.
   cDescricao  += If(cTitulo = aBoxTitulo[1],STR0044,;  // " - TITULOS A PAGAR"
                                             STR0045)   // " - TITULOS A RECEBER"
   CAB->TITULO := cDescricao 
   CAB->LBLMOEDA := STR0046 // "MOEDA:"
   If !Empty(cMoeda)
      CAB->MOEDA := cMoeda
   Else
      CAB->MOEDA := STR0047 // "Todas"
   EndIf                                           
EndIf
cDescricao:= ""
// ** Define o Período do Relatório   
If !Empty(dDtini) .And. !Empty(dDtfim)
   If nRadio = 1 .or. nRadio = 3
      cPeriodo := STR0021+Dtoc(dDtini)+STR0022+Dtoc(dDtfim)  //"Vencimentos de  "###"  Até  "
   ElseIf nRadio = 2
      cPeriodo := STR0023+Dtoc(dDtini)+STR0022+Dtoc(dDtfim)  //"Vencimentos previstos de  " //"  Até  "
   Else
      cPeriodo := STR0024+Dtoc(dDtini)+STR0022+Dtoc(dDtfim)           //"Pagamentos de  " //"  Até  "
   EndIf
ElseIf !Empty(dDtini) .And. Empty(dDtfim)
   If nRadio = 1 .or. nRadio = 3
      cPeriodo := STR0025+Dtoc(dDtini) //"Vencimentos a partir de  "
   ElseIf nRadio = 2
      cPeriodo := STR0026+Dtoc(dDtini) //"Vencimentos previstos a partir de  "
   Else
      cPeriodo := STR0027+Dtoc(dDtini) //"Pagamentos a partir de  "
   EndIf
ElseIf Empty(dDtini) .And. !Empty(dDtfim)   
   If nRadio = 1 .or. nRadio = 3
      cPeriodo := STR0028+Dtoc(dDtfim) //"Vencimentos até  "
   ElseIf nRadio = 2
      cPeriodo := STR0029+Dtoc(dDtfim) //"Vencimentos previstos até  "
   Else
      cPeriodo := STR0030+Dtoc(dDtfim) //"Pagamentos até  "
   EndIf  
Else   
   cPeriodo := STR0033    //"Todos"
EndIf

CAB->PERIODO  := cPeriodo

If ! EECFlags("FRESEGCOM")     // JPP - 19/08/04 16:40  - Se a estrutura de dados na tabela EEQ é antiga. Mantem o cabeçalho Original.
   CAB->LBLIMPORT:= STR0048 // "CLIENTE:"
   CAB->IMPORT := If(Empty(cImport),STR0031,AllTrim(QRY->EEC_IMPODE)) //" Todos "
   If lEvento   // JPP - 31/03/2005  -  9:50
      CAB->LBLEVENTO := STR0060 // "EVENTO:"
      CAB->EVENTO    := If(Empty(cEvento),STR0031,cEvento)  // "TODOS" 
   EndIf
Else  // Se a estrutura de dados na tabela EEQ é nova. Define um novo Cabeçalho.
   If cTitulo = aBoxTitulo[1]   // Titulos a pagar
      CAB->LBLIMPORT:= STR0049  // "FORNECEDOR:"
      If Empty(cFornec)                     
         CAB->IMPORT :=AllTrim(STR0031) //" Todos "  
      Else
         cChave:=QRY->EEQ_FORN + QRY->EEQ_FOLOJA 
         CAB->IMPORT :=  Posicione("SA2",1,xFilial("SA2")+cChave,"A2_NOME") 
      EndIf
   Else   // Titulos a receber
      CAB->LBLIMPORT:= STR0050  // "IMPORTADOR:"
      If Empty(cImport)                     
         CAB->IMPORT := AllTrim(STR0031) //" Todos "  
      Else
         cChave:=QRY->EEQ_IMPORT + QRY->EEQ_IMLOJA 
         CAB->IMPORT :=  Posicione("SA1",1,xFilial("SA1")+cChave,"A1_NOME") 
      EndIf 
   EndIf  
   CAB->LBLEVENTO := STR0060 // "EVENTO:"
   CAB->EVENTO    := If(Empty(cEvento),STR0031,cEvento)  // "TODOS" 
EndIf   
CAB->CODFILIAL := SM0->M0_CODFIL // Este codigo de filial definira o logotipo impresso nos relatorios GE-DAKO ou MABE Itu.

If cTitulo = STR0039 // "A pagar"   - By JPP - 31/03/2005 - 13:50
   CAB->LBLCABIMP := STR0037 // "Fornecedor"
Else
   CAB->LBLCABIMP := STR0013 // "Cliente"
EndIf 

CAB->(MSUNLOCK())

While QRY->(!Eof())       
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         IncProc(STR0032 + QRY->EEC_PREEMB) //"Imprimindo: "
      ELSE
   #ENDIF
         //... DBF ...
   #IFDEF TOP
      ENDIF
   #ENDIF 

   DET->(DBAPPEND())    
   DET->SEQREL   := cSeqRel    
   DET->CHAVE    := "_ITEMSDETALHE"
   IF lMultiFil
      If !EmpTy(QRY->EEC_FILIAL)
        DET->FILORI := QRY->EEC_FILIAL 
        DET->FILNAME:= AvgFilName({QRY->EEC_FILIAL})[1]
        DET->FLAG2 := "0"
      Else
        DET->FLAG2 := "1"  
      EndIf
   Else                                      
      DET->FLAG2 := "1"
   EndIF   
   DET->PROCESSO := AllTrim(QRY->EEC_PREEMB)
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         DET->DTPROCESSO := TransData(QRY->EEC_DTPROC)
         DET->DTVENC     := TransData(QRY->EEQ_VCT) 
      ELSE
   #ENDIF
         DET->DTPROCESSO := Dtoc(QRY->EEC_DTPROC)
         DET->DTVENC     := Dtoc(QRY->EEQ_VCT) 
   #IFDEF TOP
      ENDIF
   #ENDIF
   If ! EECFlags("FRESEGCOM") // JPP - 19/08/04 16:40 - Se a estrutura de dados da tabela EEQ é antiga. Mantem a leitura original do cliente. 
      DET->IMPODE   := ALLTRIM(QRY->EEC_IMPODE)
      DET->MOEDA    := QRY->EEC_MOEDA
      cChave := "EXPORT" + "101"
      cDescricao := Posicione("EC6",1,xFilial("EC6")+cChave,"EC6_DESC") 
      DET->EVENTDESCR := "101-" + If(Empty(cDescricao),"F.O.B.",cDescricao)
      If lEvento   // JPP - 31/03/2005  -  9:50
         If ! Empty(QRY->EEQ_EVENT)
            cChave := "EXPORT" + QRY->EEQ_EVENT
            DET->EVENTDESCR := QRY->EEQ_EVENT + "-" + Posicione("EC6",1,xFilial("EC6")+cChave,"EC6_DESC") 
         EndIf
      EndIf
   Else // Se a estrutura de dados da tabela EEQ é nova, o cliente é gravado a partir do cadastro de clientes.
      If cTitulo = STR0039 // "A pagar"   - By JPP - 31/03/2005 - 13:50
         cChave:=QRY->EEQ_FORN + QRY->EEQ_FOLOJA 
         DET->IMPODE :=  Posicione("SA2",1,xFilial("SA2")+cChave,"A2_NREDUZ") 
      Else
         cChave:= QRY->EEQ_IMPORT + QRY->EEQ_IMLOJA 
         DET->IMPODE   := Posicione("SA1",1,xFilial("SA1")+cChave,"A1_NOME") 
      EndIf
      DET->MOEDA    := QRY->EEQ_MOEDA 
      If Empty(QRY->EEQ_EVENT)
         cChave := "EXPORT" + "101"
         DET->EVENTDESCR := "101-" + Posicione("EC6",1,xFilial("EC6")+cChave,"EC6_DESC")       
      Else
         cChave := "EXPORT" + QRY->EEQ_EVENT
         DET->EVENTDESCR := QRY->EEQ_EVENT + "-" + Posicione("EC6",1,xFilial("EC6")+cChave,"EC6_DESC") 
      EndIf

      /*
      AMS - 26/11/2005. Gravação do Tipo de Contrato.
      */
      If lTipCon
         DET->TIPCON := Eval({|x| If(x > 0, SubStr(aTipCon[x], 3), "")}, Val(QRY->EEQ_TP_CON))
      EndIf

   EndIf
   nValorUss := QRY->EEQ_VL
   DET->VALORUSS := Alltrim(Transform(nValorUss, cPictUss))
   IF EMPTY(QRY->EEC_DTEMBA) .AND. ! EMPTY(QRY->EEC_ETD)
      DET->FLAG := "1"
   ELSE
      DET->FLAG := "0"
   ENDIF
   If nRadio = 4 // Recebidos 
      DET->TXCAMBIO := Transform(QRY->EEQ_TX,cPictTx) 
      nValorRs := QRY->EEQ_TX * QRY->EEQ_VL               
      DET->VALORRS  := Alltrim(Transform(nValorRs,cPictRs))  
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            DET->DTPGT := TransData(QRY->EEQ_PGT)    
         ELSE
      #ENDIF
            DET->DTPGT := Dtoc(QRY->EEQ_PGT)
      #IFDEF TOP
         ENDIF
      #ENDIF
      DET->BANCO := Posicione("SA6",1,xFilial("SA6")+QRY->EEQ_BANC,"A6_NOME") // CAF 19/07/2001 20:22 BuscaInst(QRY->EEC_PREEMB,OC_EM,BC_COC)
   //Else // JPP - 31/03/2005  -  9:50 - Disponibilizar os valores em Reais taxa de embarque para a opção recebidos.
   EndIf
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         If ! EECFlags("FRESEGCOM") // JPP - 19/08/04 16:40 - Se a estrutura de dados da tabela EEQ é antiga. Mantem a leitura original do cliente. 
            nValorNfs := QRY->EEQ_VL * BuscaTaxa(QRY->EEC_MOEDA,AVCTOD(TRANSDATA(QRY->EEC_DTEMBA)),,.f.)
            nValorNfs := Val(StrZero(nValorNfs,18,2))       // Correção das Casas Decimais.
            DET->VALORNFS := Transform(nValorNfs,cPictNfs)
         Else
            nValorNfs := QRY->EEQ_VL * BuscaTaxa(QRY->EEQ_MOEDA,AVCTOD(TRANSDATA(QRY->EEC_DTEMBA)),,.f.)
            nValorNfs := Val(StrZero(nValorNfs,18,2)) // Correção das Casas Decimais.
            DET->VALORNFS := Transform(nValorNfs,cPictNfs)
         EndIf
      ELSE
   #ENDIF
         If ! EECFlags("FRESEGCOM") // JPP - 19/08/04 16:40 - Se a estrutura de dados da tabela EEQ é antiga. Mantem a leitura original do cliente. 
            nValorNfs := QRY->EEQ_VL * BuscaTaxa(QRY->EEC_MOEDA,AVCTOD(DTOC(QRY->EEC_DTEMBA)),,.f.)
            nValorNfs := Val(StrZero(nValorNfs,18,2))   // Correção das Casas Decimais.
            DET->VALORNFS := Transform(nValorNfs,cPictNfs)
         Else
            nValorNfs := QRY->EEQ_VL * BuscaTaxa(QRY->EEQ_MOEDA,AVCTOD(DTOC(QRY->EEC_DTEMBA)),,.f.)
            nValorNfs := Val(StrZero(nValorNfs,18,2)) // Correção das Casas Decimais.
            DET->VALORNFS := Transform(nValorNfs,cPictNfs)
         EndIf
   #IFDEF TOP
      ENDIF
   #ENDIF
   // Endif  // JPP - 31/03/2005  -  9:50 
   nSomaVlNfs += nValorNfs    // By JPP 27/08/04 14:00 - Efetua o calculo dos totais.
   nSomaVlRs += nValorRs
   nInd :=Ascan(aSomaMoeda,{|aParamet| aParamet[1] = DET->MOEDA})    // By JPP 26/08/04 - Efetua a somatória dos valores para cada moeda
   If nInd > 0
      aSomaMoeda[nInd,2] := aSomaMoeda[nInd,2] + nValorUss
   Else
      AADD(aSomaMoeda,{DET->MOEDA,nValorUss})
   EndIf   
   If lMultiFil
      nInd :=Ascan(aSomaMoeFil,{|aParamet| aParamet[1] = DET->FILORI .AND. aParamet[2] = DET->MOEDA})    // By JPP 26/08/04 - Efetua a somatória dos valores para cada moeda
      If nInd > 0
         aSomaMoeFil[nInd,3] := aSomaMoeFil[nInd,3] + nValorUss
      Else
         AADD(aSomaMoeFil,{DET->FILORI,DET->MOEDA,nValorUss})
      EndIf   
   ENDIF

   DET->(MSUNLOCK())

   lNovo := .T.              
   lZero := .f.
     
   QRY->(dbSkip())
   lRet := .t.
Enddo  

CAB->SOMAVLNFS := If(nSomaVlNfs = 0,"",Transform(nSomaVlNfs,cPictNfs)) // By JPP 27/08/04 14:00 - Grava os totais do relatorio   
CAB->SOMAVLRS  := If(nSomaVlRs = 0,"",Alltrim(Transform(nSomaVlRs,cPictRs))) 
CAB->(MSUNLOCK())

For nInd := 1 to len(aSomaMoeda)       // Grava os dados do subrelatório
    DET->(DbAppend())    
    DET->SEQREL   := cSeqRel    
    DET->CHAVE    := "_ITEMSSUB_REL"
    DET->FLAG2    := "2"
    DET->FILORI   := "XX"
    DET->MOEDA    := aSomaMoeda[nInd,1]
    DET->VALORUSS := Transform(aSomaMoeda[nInd,2],cPictUss) 
    DET->(MSUNLOCK())
next

For nInd := 1 to len(aSomaMoeFil)       // Grava os dados do subrelatório
    DET->(DbAppend())    
    DET->SEQREL   := cSeqRel    
    DET->CHAVE    := "_ITEMSSUB_REL"
    DET->FLAG2    := "2"
    DET->FILORI   := aSomaMoeFil[nInd,1]
    DET->MOEDA    := aSomaMoeFil[nInd,2]
    DET->VALORUSS := Transform(aSomaMoeFil[nInd,3],cPictUss) 
    DET->(MSUNLOCK())
next
   
Return lRet
*--------------------------------------------------------------------
/*
Funcao          : MontaWork()                  
Parametros      : Alias
Retorno         : cWork                
Objetivos       : Montar arquivo temporário
Autor           : CAF/JBJ
Data/Hora       : 14/07/01 - 14:49
Revisao         :
Obs.            : 
*/
Static Function MontaWork(cAlias)
Local cWork, aSemSX3 := (cAlias)->(dbStruct()), nZ:=0, i:=0
#IFDEF TOP
   IF TCSRVTYPE() <> "AS/400"
      aESTRU := {}
      FOR I := 1 TO LEN(aSEMSX3)
          cAX := {AVSX3(aSEMSX3[I,1],AV_TIPO),;
                  AVSX3(aSEMSX3[I,1],AV_TAMANHO),;
                  AVSX3(aSEMSX3[I,1],AV_DECIMAL)}
          IF cAX[1] = "D"
             cAX := {"C",8,0}
          ENDIF
          AADD(aESTRU,{aSEMSX3[I,1],cAX[1],cAX[2],cAX[3]})
      NEXT
      aSEMSX3 := aCLONE(aESTRU)
   ELSE
#ENDIF
      ///... DBF ...
#IFDEF TOP
   ENDIF
#ENDIF
cWORK  := E_CRIATRAB("",aSemSX3,"QRY")

INDREGUA("QRY",cWORK+OrdBagExt(),if(lMultiFil,"EEC_FILIAL+","")+"EEQ_VCT" ,"AllwayTrue()","AllwaysTrue()",STR0001) //"Processando Arquivo Temporario"
Set Index to (cWORK+OrdBagExt())

Do While ! (cAlias)->(Eof())
   QRY->(DbAppend())
   AvReplace(cAlias,"QRY")   
   If lMultiFil //LRL 04/01/04 - MultiFiliais
      QRY->EEC_FILIAL:=(cAlias)->EEC_FILIAL
   EndIF
   IF nRADIO = 2
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            QRY->EEC_ETD := ""
         ELSE
      #ENDIF
            QRY->EEC_ETD := CTOD("  /  /  ")
      #IFDEF TOP
         ENDIF
      #ENDIF
   ENDIF
   If Empty((cAlias)->EEQ_VCT)
      aParc := GParc((cAlias)->EEC_PREEMB)
      If  Len(aParc) > 1
         For nZ := 1 To QRY->(Fcount())
            M->&(QRY->(FIELDNAME(nZ))) := QRY->(FIELDGET(nZ))
         Next
      Endif      
      For nZ:=1 to Len(aParc)                                     
         IF ! Empty(dDtIni) .And. aParc[nZ,2] < dDtIni  .Or.;
            ! Empty(dDtFim) .And. aParc[nZ,2] > dDtFim            
            IF nZ == 1
               QRY->(dbDelete())
            Endif            
            Loop
         Endif
         IF nZ > 1
            QRY->(dbAppend()) 
            AvReplace("M","QRY")
         Endif
         QRY->EEQ_VL  := aParc[nZ,1]
         #IFDEF TOP
            IF TCSRVTYPE() <> "AS/400"
               QRY->EEQ_VCT := Dtos(aParc[nZ,2])
            ELSE
         #ENDIF
               QRY->EEQ_VCT := aParc[nZ,2]
         #IFDEF TOP
            ENDIF
         #ENDIF
      Next    
   Endif        
   (cAlias)->(DBSKIP())
EndDo   
QRY->(DBGOTOP())   
Return(cWork)
*--------------------------------------------------------------------
STATIC FUNCTION PRL15A() // A VENCER - EMBARCADOS
LOCAL cCONDEEQ := .F.
// VERIFICA SE EXISTE O INDICE POR DATA DE VENCIMENTO
SIX->(DBSETORDER(1))
SIX->(DBSEEK("EEQ"))
DO WHILE ! SIX->(EOF()) .AND. SIX->INDICE = "EEQ"
   IF LEFT(UPPER(SIX->CHAVE),24) = "EEQ_FILIAL+DTOS(EEQ_VCT)"
      cCONDEEQ := .T.
      EXIT
   ENDIF
   SIX->(DBSKIP())
ENDDO
// GERA O TMP
IF cCONDEEQ
   EEQ->(DBSETORDER(VAL(SIX->ORDEM)))
   EEQ->(DBSEEK(XFILIAL("EEQ")+DTOS(dDTINI),.T.))
   IF EMPTY(dDTINI) .AND. EMPTY(dDTFIM)
      cCONDEEQ := ".T."
   ELSEIF ! EMPTY(dDTINI) .AND. EMPTY(dDTFIM)
          cCONDEEQ := "DTOS(EEQ->EEQ_VCT) >= DTOS(dDTINI)"
   ELSEIF EMPTY(dDTINI) .AND. ! EMPTY(dDTFIM)
          cCONDEEQ := "DTOS(EEQ->EEQ_VCT) <= DTOS(dDTFIM)"
   ELSE
      cCONDEEQ := "EEQ->(DTOS(EEQ_VCT) >= DTOS(dDTINI) .AND. DTOS(EEQ_VCT) <= DTOS(dDTFIM))"
   ENDIF
ELSE
   EEQ->(DBSETORDER(1))
   EEQ->(DBSEEK(XFILIAL("EEQ")))
   cCONDEEQ := ".T."
ENDIF
DO WHILE ! EEQ->(EOF()) .AND.;
   EEQ->EEQ_FILIAL = XFILIAL("EEQ") .AND. &cCONDEEQ
   *
   IF EMPTY(EEQ->EEQ_PGT)
      EEC->(DBSETORDER(1))
      EEC->(DBSEEK(XFILIAL("EEC")+EEQ->EEQ_PREEMB))
      If ! EECFlags("FRESEGCOM")  // JPP - 19/08/04 11:49 - Se a estrutura da tabela EEQ é antiga. Mantem a gravação de dados original.
         // Filtro por evento
         If lEvento  // JPP - 31/03/2005 10:55
            If !Empty(cEvento) 
               If EEQ->EEQ_EVENT <> AvKey(cEvento,"EEQ_EVENT")
                  EEQ->(DbSkip())
                  Loop
               EndIf
            EndIf     
         EndIf
         IF (EMPTY(cIMPORT) .OR. EEC->EEC_IMPORT = cIMPORT)          .AND.;
            (EMPTY(dDTINI)  .OR. DTOS(EEQ->EEQ_VCT) >= DTOS(dDTINI)) .AND.;
            (EMPTY(dDTFIM)  .OR. DTOS(EEQ->EEQ_VCT) <= DTOS(dDTFIM))
            *
            (cAlias)->(DBAPPEND())
            //LRL 30/12/04-----------------------------
            If lMulTiFil
               (cAlias)->EEC_FILIAL := EEC->EEC_FILIAL
            EndIf
           //-----------------------------LRL 30/12/04
            (cAlias)->EEC_PREEMB := EEC->EEC_PREEMB
            (cAlias)->EEC_DTPROC := EEC->EEC_DTPROC
            (cAlias)->EEC_IMPODE := EEC->EEC_IMPODE
            (cAlias)->EEC_MOEDA  := EEC->EEC_MOEDA
            (cAlias)->EEC_DTEMBA := EEC->EEC_DTEMBA
            (cAlias)->EEQ_VCT    := EEQ->EEQ_VCT
            (cAlias)->EEQ_PGT    := EEQ->EEQ_PGT
            (cAlias)->EEQ_VL     := EEQ->EEQ_VL
            (cAlias)->EEQ_TX     := EEQ->EEQ_TX                      
            If lEvento // JPP - 31/03/2005 10:55
               (cAlias)->EEQ_EVENT  := EEQ->EEQ_EVENT
            EndIf   
         ENDIF
      Else // Se a estrutura de dados da tabela EEQ é nova, Grava os dados de acordo com os novos campos da tabela EEQ e os novos filtros.
         // Filtro por titulo
         If cTitulo = aBoxTitulo[1]  // "Titulos a pagar"
            If EEQ->EEQ_TIPO <> "P"
               EEQ->(DbSkip())
               Loop
            Endif
         Else  // "Titulos a receber"
            If EEQ->EEQ_TIPO <> "R"
               EEQ->(DbSkip())
               Loop
            EndIf    
         Endif 
         // Filtro pelo importador.
         If !Empty(cImport)
            If EEQ->EEQ_IMPORT <> AvKey(cImport,"EEQ_IMPORT")
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf    
         // Filtro pelo fornecedor             
         If !Empty(cFornec)
            If EEQ->EEQ_FORN <> AvKey(cFornec,"EEQ_FORN")
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf   
         // Filtro pela Moeda             
         If !Empty(cMoeda)
            If EEQ->EEQ_MOEDA <> AvKey(cMoeda,"EEQ_MOEDA")
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf  
         // Filtro por evento
         If !Empty(cEvento) 
            If EEQ->EEQ_EVENT <> AvKey(cEvento,"EEQ_EVENT")
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf  
         // Filtro pela Data Inicial             
         If !Empty(dDtIni)
            If DTOS(EEQ->EEQ_VCT) < DTOS(dDtIni)
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf
         // Filtro pela Data Final
         If !Empty(dDtFim)
            If DTOS(EEQ->EEQ_VCT) > DTOS(dDtFim)
               EEQ->(DbSkip())
               Loop
            EndIf
         EndIf
         /*
         AMS - 26/11/2005 - Filtro pelo Tipo de Contrato.
         */
         If lTipCon .and. !Empty(cTipCon) .and. EEQ->EEQ_TP_CON <> cTipCon
            EEQ->(dbSkip())
            Loop
         EndIf

         (cAlias)->(DBAPPEND())
         //LRL 30/12/04-----------------------------
         If lMulTiFil
            (cAlias)->EEC_FILIAL := EEC->EEC_FILIAL
         EndIf
         //-----------------------------LRL 30/12/04
         (cAlias)->EEC_PREEMB := EEC->EEC_PREEMB
         (cAlias)->EEC_DTPROC := EEC->EEC_DTPROC
         (cAlias)->EEQ_IMPORT := EEQ->EEQ_IMPORT
         (cAlias)->EEQ_IMLOJA := EEQ->EEQ_IMLOJA
         (cAlias)->EEQ_FORN   := EEQ->EEQ_FORN
         (cAlias)->EEQ_FOLOJA := EEQ->EEQ_FOLOJA
         (cAlias)->EEQ_MOEDA  := EEQ->EEQ_MOEDA
         (cAlias)->EEC_DTEMBA := EEC->EEC_DTEMBA
         (cAlias)->EEQ_VCT    := EEQ->EEQ_VCT
         (cAlias)->EEQ_PGT    := EEQ->EEQ_PGT
         (cAlias)->EEQ_VL     := EEQ->EEQ_VL
         (cAlias)->EEQ_TX     := EEQ->EEQ_TX 
         (cAlias)->EEQ_EVENT  := EEQ->EEQ_EVENT

         /*
         AMS - 26/11/2005. Gravação do Tipo de Contrato.
         */
         If lTipCon
            (cAlias)->EEQ_TP_CON := EEQ->EEQ_TP_CON
         EndIf

      EndIf   
   ENDIF
   EEQ->(DBSKIP())
ENDDO
RETURN(NIL)
*--------------------------------------------------------------------
STATIC FUNCTION PRL15B() // A VENCER COM PREVISAO DE EMBARQUE
EEC->(DBSETORDER(12))
EEC->(DBSEEK(XFILIAL("EEC")+"        "))
DO WHILE ! EEC->(EOF()) .AND.;
   EEC->(EEC_FILIAL+DTOS(EEC_DTEMBA)) = (XFILIAL("EEC")+"        ")
   *  
   If ! EECFlags("FRESEGCOM")  // JPP - 19/08/04 13:42 -  Se a estrutura de dados da tabela EEQ é antiga, Mantem a gravação original de dados. 
      IF EEC->EEC_STATUS # ST_PC .AND. ! EMPTY(EEC->EEC_ETD) .AND.;
         (EMPTY(cIMPORT) .OR. EEC->EEC_IMPORT = cIMPORT)
         *
         (cAlias)->(DBAPPEND()) 
         //LRL 30/12/04-----------------------------
         If lMulTiFil
            (cAlias)->EEC_FILIAL := EEC->EEC_FILIAL
         EndIf
         //-----------------------------LRL 30/12/04
         (cAlias)->EEC_PREEMB := EEC->EEC_PREEMB
         (cAlias)->EEC_DTPROC := EEC->EEC_DTPROC
         (cAlias)->EEC_IMPODE := EEC->EEC_IMPODE
         (cAlias)->EEC_MOEDA  := EEC->EEC_MOEDA
         (cALIAS)->EEC_ETD    := EEC->EEC_ETD
      ENDIF
   Else   // Se a estrutura da tabela EEQ é nova. Os dados serão gravados de acordo com os novos campos da tabela EEQ e os novos Filtros.
      IF EEC->EEC_STATUS = ST_PC //.And. Empty(EEC->EEC_ETD) 
         EEC->(DBSKIP())
         Loop
      EndIf
      If ! Empty(cIMPORT) 
         If EEC->EEC_IMPORT <> AvKey(cImport,"EEC_IMPORT")
            EEC->(DBSKIP())
            Loop
         EndIf
      EndIf
      If ! Empty(cFornec)
         If EEC->EEC_FORN <> AvKey(cFornec,"EEC_FORN")
            EEC->(DBSKIP())
            Loop
         EndIf
      EndIf   
      If ! Empty(cMoeda) 
         If EEC->EEC_MOEDA <> AvKey(cMoeda,"EEC_MOEDA")
            EEC->(DBSKIP())
            Loop
         EndIf
      EndIf
      If Empty(EEC->EEC_ETD) 
         EEC->(DBSKIP())
         Loop
      EndIf                 
      *  
      (cAlias)->(DBAPPEND())
      //LRL 30/12/04-----------------------------
      If lMulTiFil
         (cAlias)->EEC_FILIAL := EEC->EEC_FILIAL
      EndIf
      //-----------------------------LRL 30/12/04
      (cAlias)->EEC_PREEMB := EEC->EEC_PREEMB
      (cAlias)->EEC_DTPROC := EEC->EEC_DTPROC
      (cAlias)->EEC_IMPORT := EEC->EEC_IMPORT
      (cAlias)->EEC_IMLOJA := EEC->EEC_IMLOJA
      (cAlias)->EEC_FORN   := EEC->EEC_FORN
      (cAlias)->EEC_FOLOJA := EEC->EEC_FOLOJA
      (cAlias)->EEC_MOEDA  := EEC->EEC_MOEDA
      (cAlias)->EEQ_IMPORT := EEC->EEC_IMPORT 
      (cAlias)->EEQ_IMLOJA := EEC->EEC_IMLOJA
      (cAlias)->EEQ_FORN   := EEC->EEC_FORN
      (cAlias)->EEQ_FOLOJA := EEC->EEC_FOLOJA
      (cAlias)->EEQ_MOEDA  := EEC->EEC_MOEDA  
      (cALIAS)->EEC_ETD    := EEC->EEC_ETD
   EndIf
   
   EEC->(DBSKIP())
ENDDO
RETURN(NIL)    
/*
Funcao      : DefineTit()
Parametros  : cTit := A pagar
                      A receber
Retorno     : .T.
Objetivos   : Definir se o filtro fornecedor e Importador serão ou não editados.
Autor       : Julio de Paula Paz
Data/Hora   : 19/08/04 09:41.
*/
Static Function DefineTit(cTit)   

Local lRet := .t.

If aBoxTitulo[1] = cTit    // Titulo a pagar
   oGetFor:Enable()
   //oGetImp:Disable() 
   cImport   := Space(AVSX3("A1_COD",AV_TAMANHO))
   cNomeImp := Space(AVSX3("A1_NOME",AV_TAMANHO))
Else // Titulo a receber
   oGetFor:Disable()
   //oGetImp:Enable() 
   cFornec := Space(AVSX3("A2_COD",AV_TAMANHO))
   cNomeFor := Space(AVSX3("A2_NOME",AV_TAMANHO))
EndIf

Return lRet

/*
Funcao      : TipoCorreto()
Parametros  : cTipo := "FORNEC" 
                       "IMPORT"
Retorno     : .T. ou .F.
Objetivos   : Definir se o tipo selecionado é fornecedor, Importador ou Todos.
Autor       : Julio de Paula Paz
Data/Hora   : 23/08/04 10:35.
*/
Static Function TipoCorreto(cTipo)

Local lRet := .f.

If cTipo = "FORNEC"
   If SA2->A2_ID_FBFN = "3" .Or. SA2->A2_ID_FBFN = "4"   // "3" = "Todos"  - "4" = "Exportador"
      cNomeFor := SA2->A2_NOME
      lRet := .t.
   Else
      MsgInfo(STR0055+ENTER; // "Fornecedor Inválido! "
             +STR0056+ENTER; // "Selecionar um Fornecedor que esteja cadastrado como "
             +STR0057)       // "Exportador ou Todos!"
      cNomeFor := Space(AVSX3("A2_NOME",AV_TAMANHO))
      oGetNomeFor:Refresh()
   Endif
EndIf
If cTipo = "IMPORT"
   If SA1->A1_TIPCLI = "1" .Or. SA1->A1_TIPCLI = "4"   // "1" = "Importador" - "4" = "Todos" 
      cNomeImp := SA1->A1_NOME
      lRet := .t.
   Else
      MsgInfo(STR0052+ENTER;  // "Importador Inválido! "
             +STR0053+ENTER;  // "Selecionar um Importador que esteja cadastrado como "
             +STR0054)        // "Importador ou Todos!" 
      cNomeImp := Space(AVSX3("A1_NOME",AV_TAMANHO))
      oGetNomeImp:Refresh()
   EndIf
EndIf

Return lRet 

/*
Funcao      : ConfTitulo()
Parametros  : nRad := 1 ou 2 ou 3 ou 4
Retorno     : .T.
Objetivos   : Desabilitar a opcao titulos a pagar se nRad for igual a 2 e 
              habilitar se nRad for diferente de 2 
Autor       : Julio de Paula Paz
Data/Hora   : 10/09/04 11:50
*/
Static Function ConfTitulo(nRad)   

Local lRet := .t.

If nRad = 2 .or. nRad = 3  
   If EECFlags("FRESEGCOM")  // By JPP - 31/03/2005 - 11:30 
      oCbxTitulo:Enable()
      cTitulo := aBoxTitulo[2] // A receber
      oCbxTitulo:Refresh()
      DefineTit(cTitulo)
      oCbxTitulo:Disable()
      If lTipCon
         If nRad = 2
            oCbxTipCon:Disable()
         Else
            oCbxTipCon:Enable()
         EndIf
      EndIf
   EndIf
   oGetEve:Disable()
   cEvento := Space(AVSX3("EEQ_EVENT",AV_TAMANHO))
   oGetEve:Refresh()
Else
   If EECFlags("FRESEGCOM")  // By JPP - 31/03/2005 - 11:30 
      oCbxTitulo:Enable()
   EndIf   
   oGetEve:Enable()
   If lTipCon
      oCbxTipCon:Enable()
   EndIf
EndIf

Return lRet 

/*
Funcao      : ExitEvent()
Parametros  : Codigo do evento
Retorno     : .T. ou .F.
Objetivos   : Verificar se existe o codigo do evento no cadastro de eventos.

Autor       : Julio de Paula Paz
Data/Hora   : 18/10/04 14:05
*/
Static Function ExistEvent(cEvento)   

Local lRet := .t.

EC6->(DbSetOrder(1))
If ! EC6->(DbSeek(xFilial("EC6")+"EXPORT"+cEvento))
   MsgInfo(STR0059)  // "Codigo Inválido! Selecione um código válido."
   lRet := .f.
EndIf

Return lRet
