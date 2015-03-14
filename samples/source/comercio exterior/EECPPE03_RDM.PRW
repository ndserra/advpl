#INCLUDE "EECRDM.CH"
#INCLUDE "EECPPE03.ch"
#INCLUDE "EEC.ch"                      
/*
Programa   : EECPPE03.PRW
Objetivo   : Impressao do Follow-up em fase de processo
Autor      : Jeferson Barros Jr.
Data/Hora  : 20/08/2001 13:43
Obs.       : Considera que esta posicionado no registro de processos (pedidos) (EE7)

Funcao      : EECPPE03
Parametros  : Nenhum
Retorno     : .F.
Objetivos   : 
Autor       : Jeferson Barros Jr. 
Data/Hora   : 20/08/2001 - 13:47
Obs.        : Arquivo - FW0001.RPT
*/
*------------------------------
User Function EECPPE03()       
*------------------------------

Local nOldArea := Alias(), aOrd := SaveOrd("EE7"), nTipo,;
      lImpresso, cCmd, lRet := .F. 


Private cArqRpt, cTitRpt,;
        dDtIni    := AVCTOD("  /  /  "), dDtFim := AVCTOD("  /  /  "),lZero:=.t.,;
        lIntegra := IsIntFat() // ** By JBJ 29/05/02        

Private aCombo := If(lIntegra,{STR0004,STR0005},; //"Aguardando Faturamento"###"Faturados e Sem Embarque"
                    {STR0006,STR0007,STR0008})   //"Sem Solicitação de Crédito"###"Ag. Aprovação de Crédito"###"Crédito Aprovado"

Private cCombo := aCombo[1], cWork:=""

Private aArqs,;
   cNomDbfC := "PPE03C",;
   aCamposC := {{"SEQREL  ","C", 08,0},;
                {"TITULO  ","C",100,0},;
                {"PERIODO ","C",100,0}},;
   cNomDbfD := "PPE03D",;
   aCamposD := {{"SEQREL  ","C", 08,0},;
                {"PEDIDO  ","C",AVSX3("EE7_PEDIDO",AV_TAMANHO),0},;
                {"PEDFAT  ","C",AVSX3("EE7_PEDFAT",AV_TAMANHO),0},;
                {"IMPODE  ","C",AVSX3("EE7_IMPODE",AV_TAMANHO),0},;
                {"DOC     ","C",AVSX3("D2_DOC",AV_TAMANHO),0},;                   
                {"QUANT   ","C",AVSX3("D2_QUANT",AV_TAMANHO)  ,0},;
                {"SLDATU  ","C",AVSX3("EE8_SLDATU",AV_TAMANHO),0},;                           
                {"DTPROC  ","C", 10,0},;      
                {"DTPEDI  ","C", 10,0},;
                {"ITEM    ","C",100,0},;
                {"FLAG    ","C",  1,0},;  // ** Flag p/ tratamento do Zebrado no Crystal
                {"FLAGI   ","C",  1,0},;  // ** Flag p/ tratamento dos Headers no Crystal (Integrado ou Não)                
                {"FLAGP   ","C",  1,0},;  // ** Flag p/ tratamento do campo processo no Crystal
                {"FLAGPV  ","C",  1,0},;  // ** Flag p/ tratamento do campo pedido de venda no Crystal               
                {"FLAGNF  ","C",  1,0}}   // ** Flag p/ tratamento do campo nota fiscal no Crystal                               

// ** BY JBJ - 29/08/01 - 16:55 
Private cSeqRel:=""

// ** Variáveis utilizadas pela função E_CriaTrab()
Private aCampos := Array(EE7->(FCount()))
Private aHeader[0]

// **                

Begin Sequence
 
   IF Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   Else 
      cArqRpt := "FW0001.RPT"
      cTitRpt := STR0001 //"Follow-up em Fase de Processo"
   Endif

   IF ! TelaGets()
      lRet := .F.
      Break
   Endif

   aArqs := {}
   AADD(aArqs,{cNomDbfC,aCamposC,"CAB","SEQREL"})
   AADD(aArqs,{cNomDbfD,aCamposD,"DET","SEQREL"})

   aRetCrw := CrwNewFilee(aARQS)   
	#IFDEF TOP
	   IF TCSRVTYPE() <> "AS/400"
         cCmd := MontaQuery()
         cCmd := ChangeQuery(cCmd)
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRY", .F., .T.) 
         Processa({|| lRet := Imprimir() })
	   ELSE
	#ENDIF
         // ** Grava Arquivo temporário ...
         GravaDBF()       
         MsAguarde({||lRet := Imprimir()},STR0009)  //"Imprimindo Registros ..."
	#IFDEF TOP
	   ENDIF
	#ENDIF
   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()   
   
   If ( lZero )
      MsgInfo(STR0010,STR0003) //"Intervalo sem dados para impressão."###"Aviso"
      lRet := .f.
   EndIf

   QRY->(E_EraseArq(cWork))

   If ( lRet )
      lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   Else
      // Fecha e apaga os arquivos temporarios ...
      CrwCloseFile(aRetCrw,.T.)
   EndIf

   IF Select("Work_Men") > 0
      Work_Men->(E_EraseArq(cWork))
   Endif              
   
End Sequence   

dbSelectArea(nOldArea)

RestOrd(aOrd)

Return (.F.)
            
/*
Funcao      : TelaGets
Parametros  : Nenhum                  
Retorno     : .T./.F.
Objetivos   : Criar Tela de Parametos
Autor       : Jeferson Barros Jr.
Data/Hora   : 20/08/2001 - 14:00
Revisao     : WFS - 31/05/12: Alinhamento de tela
Obs.        : 
*/

*------------------------*
Static Function TelaGets()
*------------------------*
Local oDlg,;
      bOk     := {|| nOpc := 1,if(fConfData(dDtFim,dDtIni),oDlg:End(),"")},;
      bCancel := {|| oDlg:End() },;
      lRet    := .f.,;
      nOpc    :=  0,;
      oPanel
                               
Begin Sequence

   Define MsDialog oDlg Title cTitRpt From 1,1 To 150,395 Of oMainWnd Pixel //136,264 320//AOM - 16/07/2011 - Alterado o tamanho versao M11.5
      
      AvBorda(oDlg,.f.)     
      
      oPanel:= TPanel():New(0, 0, "",oDlg,, .F., .F.,,, 394, 149)
            
      @  20,07 SAY STR0011 Pixel Of oPanel //"Tipo Relatório:"
      @  18,45 COMBOBOX cCombo ITEMS aCombo SIZE 80,8 PIXEL Of oPanel

      @  35,07 Say STR0012 Pixel Of oPanel //"Data Inicial:"
      @  33,45 MsGet dDtIni Size 40,8  Pixel Of oPanel
      
      @  50,07 Say STR0013 Pixel Of oPanel //"Data Final:"
      @  48,45 MsGet dDtFim Size 40,8  Pixel Of oPanel

      oPanel:Align:= CONTROL_ALIGN_ALLCLIENT

   Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) Centered
  
   If nOpc == 1
      lRet  := .t.
   EndIf 

End Sequence

Return(lRet) 


*-----------------------------------------
Static Function fConfData(dFim,dIni)                                    
*-----------------------------------------
Local lRet  := .f.

Begin Sequence

  If !Empty(dFim) .And. !Empty(dIni)
     If dFim < dIni                                                       
        MsgInfo(STR0014,STR0003) //"Data Final Não Pode Ser Menor Que Data Inicial"###"Aviso"
     Else
        lRet:=.T.
     EndIf                
  Else
     lRet:=.T.     
  EndIf     
  
End Sequence

Return(lRet)               

#IFDEF TOP
   *-----------------------------------*
   Static Function TransData(sData)
   *-----------------------------------*
   If Empty(sData)
      sData := "  /  /  "
   Else
      sData := SubStr(AllTrim(sData),7,2) + "/" + SubStr(AllTrim(sData),5,2) + "/" +   SubStr(AllTrim(sData),3,2)
   Endif

   Return sData

   /*
   Funcao          : MontaQuery
   Parametros      : Nenhum
   Retorno         : cQry+cWhere+cOrder
   Objetivos       : Montar a query para selecionar registros para a impressao
   Autor           : Jeferon Barros Jr.
   Data/Hora       : 20/08/2001 15:27
   Revisao         :
   Obs.            : 
   */
   *------------------------------------*
   Static Function MontaQuery()
   *------------------------------------*
   Local cQry := "", cOrder := "", cWhere := ""
         
   /*
      *-----------*
      * INTEGRADO *
      *-----------*
   
      ==================================================   
      - Aguardando Faturamento  
      ==================================================
   
      SELECT EE7_PEDIDO, EE7_PEDFAT, EE7_DTPROC, EE7_IMPODE, 
             EE8_SLDATU, EE8_PEDIDO, EE8_FATIT, B1_COD, 
             '' AS D2_DOC, 0 AS D2_QUANT, '' AS D2_PEDIDO, 
             '' AS D2_ITEMPV, B1_DESC, '' AS D2_PREEMB
      FROM EE7990 EE7, SD2990 SD2, EE8990 EE8, 
           SB1990 SB1
      WHERE EE7.D_E_L_E_T_ <> '*' AND EE7_FILIAL = '  ' AND 
            EE7_STATUS <> '*' AND EE8_PEDIDO = EE7_PEDIDO AND 
            EE8.D_E_L_E_T_ <> '*' AND EE8_FILIAL = '  ' AND 
            EE8_SLDATU <> 0 AND (NOT (EXISTS
            (SELECT *
             FROM SD2990 SD2
             WHERE SD2.D_E_L_E_T_ <> '*' AND D2_FILIAL = '  ' AND 
                   D2_PEDIDO = EE7_PEDFAT AND 
                   D2_ITEMPV = EE8_FATIT))) AND 
             B1_COD = EE8_COD_I
      UNION
      SELECT EE7_PEDIDO, EE7_PEDFAT, EE7_DTPROC, EE7_IMPODE, 
             EE8_SLDATU, EE8_PEDIDO, EE8_FATIT, B1_COD, D2_DOC, 
             D2_QUANT, D2_PEDIDO, D2_ITEMPV, D2_PREEMB, 
             B1_DESC
      FROM EE7990 EE7, SD2990 SD2, EE8990 EE8, 
           SB1990 SB1
      WHERE EE7.D_E_L_E_T_ <> '*' AND EE7_FILIAL = '  ' AND 
            EE7_STATUS <> '*' AND EE8_PEDIDO = EE7_PEDIDO AND 
            EE8.D_E_L_E_T_ <> '*' AND EE8_FILIAL = '  ' AND 
            EE8_SLDATU <> 0 AND D2_PEDIDO = EE7_PEDFAT AND 
            D2_ITEMPV = EE8_FATIT AND SD2.D_E_L_E_T_ <> '*' AND 
            D2_FILIAL = '  ' AND D2_PREEMB <> '                    ' AND 
            B1_COD = EE8_COD_I AND SB1.D_E_L_E_T_ <> '*' AND 
            B1_FILIAL = '  '

      ORDER BY EE7_PEDIDO, EE8_FATIT
         
      ==================================================       
      - Faturados e sem Embarque
      ==================================================
      SELECT EE7_PEDIDO, EE7_PEDFAT, EE7_DTPROC, EE7_IMPODE, 
          EE8_SLDATU, EE8_PEDIDO, EE8_FATIT, B1_COD, D2_DOC, 
          D2_QUANT, D2_PEDIDO, D2_ITEMPV, D2_PREEMB, 
          B1_DESC
      FROM EE7990 EE7, SD2990 SD2, EE8990 EE8, 
          SB1990 SB1
      WHERE EE7.D_E_L_E_T_ <> '*' AND EE7_FILIAL = '  ' AND 
          EE7_STATUS <> '*' AND EE8_PEDIDO = EE7_PEDIDO AND 
          EE8.D_E_L_E_T_ <> '*' AND EE8_FILIAL = '  ' AND 
          EE8_SLDATU <> 0 AND D2_PEDIDO = EE7_PEDFAT AND 
          D2_ITEMPV = EE8_FATIT AND SD2.D_E_L_E_T_ <> '*' AND 
          D2_FILIAL = '  ' AND D2_PREEMB = '                    ' AND 
          B1_COD = EE8_COD_I AND SB1.D_E_L_E_T_ <> '*' AND 
          B1_FILIAL = '  '
      ORDER BY EE7_PEDIDO, EE8_FATIT
  
      *---------------*
      * NAO INTEGRADO
      *---------------*
      ==================================================
      Sem solicitação de crédito
      ==================================================
      SELECT 
         EE7_PEDIDO, EE7_DTPROC, EE7_DTPEDI, EE7_IMPODE
      FROM
         EE7990 EE7
      WHERE      
         EE7.D_E_L_E_T_ <> '*' AND  EE7_FILIAL = '  ' AND EE7_DTSLCR = '        '
      ORDER BY
         EE7_PEDIDO
   
      ==================================================
      Ag. Aprovação de Crédito
      ==================================================
      SELECT 
         EE7_PEDIDO, EE7_DTPROC, EE7_DTPEDI, EE7_IMPODE
      FROM
         EE7990 EE7
      WHERE      
         EE7.D_E_L_E_T_ <> '*' AND  EE7_FILIAL = '  ' AND 
         EE7_DTSLCR = '        ' AND EE7_DTAPCR <> '        '
      ORDER BY    
         EE7_PEDIDO

      ==================================================
      Crédito Aprovado
      ==================================================
      SELECT 
         EE7_PEDIDO, EE7_DTPROC, EE7_DTPEDI, EE7_IMPODE, EE8_SLDATU 
      FROM
         EE7990 EE7, EE8990 EE8 
      WHERE      
         EE7.D_E_L_E_T_ <> '*' AND  EE7_FILIAL = '  ' AND 
         EE7_DTAPCR <> '        ' AND EE8_SLDATU <> '' AND
         EE7_PEDIDO = EE8_PEDIDO 
      ORDER BY    
         EE7_PEDIDO
                   
   */
                 
   Begin Sequence

      If lIntegra // ** Integrado ao SIGAFAT
      
         If cCombo = STR0004     //"Aguardando Faturamento"

            // ** Pedidos sem Nota ...

            cQry := "SELECT EE7_PEDIDO, EE7_PEDFAT, EE7_DTPROC, EE7_IMPODE, EE8_SLDATU, EE8_PEDIDO, EE8_FATIT, B1_COD, '"+;
                    Space(AVSX3("D2_DOC",AV_TAMANHO))+"' AS D2_DOC, 0 AS D2_QUANT, '"+;
                    Space(AVSX3("D2_PEDIDO",AV_TAMANHO))+"' AS D2_PEDIDO, '"+Space(AVSX3("D2_ITEMPV",AV_TAMANHO))+"' AS D2_ITEMPV,"+;
                    "B1_DESC, '"+Space(AVSX3("D2_PREEMB",AV_TAMANHO)) +"' AS D2_PREEMB"  
      
            cQry += " FROM "+RetSqlName("EE7")+" EE7, " +RetSqlName("EE8")+" EE8, " +RetSqlName("SD2")+" SD2,"+;
                    RetSqlName("SB1")+" SB1"      

            cWhere :=  " WHERE EE7.D_E_L_E_T_ <> '*' AND EE7_FILIAL = '" +xFilial("EE7")+"' AND EE7_STATUS <> '"+ST_PC+"'"+;
                           " AND EE8_PEDIDO = EE7_PEDIDO"+;
                           " AND EE8.D_E_L_E_T_ <> '*' AND EE8_FILIAL = '" +xFilial("EE8")+"' AND EE8_SLDATU <> 0"+;                            
                           " AND (NOT (EXISTS ( SELECT * FROM "+RetSqlName("SD2")+" SD2 WHERE SD2.D_E_L_E_T_ <> '*' AND"+;
                           " D2_FILIAL = '" +xFilial("SD2")+"'AND D2_PEDIDO = EE7_PEDFAT AND D2_ITEMPV = EE8_FATIT))) AND "+;
                           " B1_COD = EE8_COD_I" + " AND SB1.D_E_L_E_T_ <> '*' AND B1_FILIAL = '" +xFilial("SB1")+"'" 

            If !Empty(dDtIni)
               cWhere := cWhere + " AND EE7_DTPROC >= '" + DtoS(dDtIni)+"'"
            EndIf
     
            If !Empty(dDtFim)
               cWhere := cWhere + " AND EE7_DTPROC <= '" + DtoS(dDtFim)+"'"
            EndIf                    
         
            cWhere+= " UNION "
         
            cWhere+= cQry
         
            // ** Pedidos com Nota e sem Embarque ...
            cWhere+=  " WHERE EE7.D_E_L_E_T_ <> '*' AND EE7_FILIAL = '" +xFilial("EE7")+"' AND EE7_STATUS <> '"+ST_PC+"'"+;
                           " AND EE8_PEDIDO = EE7_PEDIDO"+;
                           " AND EE8.D_E_L_E_T_ <> '*' AND EE8_FILIAL = '" +xFilial("EE8")+"' AND EE8_SLDATU <> 0"+;      
                           " AND D2_PEDIDO = EE7_PEDFAT AND D2_ITEMPV = EE8_FATIT AND"+;
                           " SD2.D_E_L_E_T_ <> '*' AND D2_FILIAL = '" +xFilial("SD2")+"' AND "+;
                           " D2_PREEMB <> '"+Space(AvSX3("D2_PREEMB",AV_TAMANHO))+"' AND B1_COD = EE8_COD_I AND"+;
                           " SB1.D_E_L_E_T_ <> '*' AND B1_FILIAL = '" +xFilial("SB1")+"'"
                                      
         Else  // **  Faturados e sem embarque ...

            cQry := "SELECT EE7_PEDIDO, EE7_PEDFAT, EE7_DTPROC, EE7_IMPODE, "+;
                    " D2_DOC, D2_QUANT, B1_DESC, B1_COD"                 
   
            cQry += " FROM "+RetSqlName("EE7")+" EE7, " +RetSqlName("EE8")+" EE8, " +RetSqlName("SD2")+" SD2,"+;
                    RetSqlName("SB1")+" SB1"             
         
            cWhere:=   " WHERE EE7.D_E_L_E_T_ <> '*' AND EE7_FILIAL = '" +xFilial("EE7")+"' AND EE7_STATUS <> '"+ST_PC+"'"+;
                       " AND EE8_PEDIDO = EE7_PEDIDO"+;
                       " AND EE8.D_E_L_E_T_ <> '*' AND EE8_FILIAL = '" +xFilial("EE8")+"' AND EE8_SLDATU <> 0"+;      
                       " AND D2_PEDIDO = EE7_PEDFAT AND D2_ITEMPV = EE8_FATIT AND"+;
                       " SD2.D_E_L_E_T_ <> '*' AND D2_FILIAL = '" +xFilial("SD2")+"' AND "+;
                       " D2_PREEMB = '"+Space(AvSX3("D2_PREEMB",AV_TAMANHO))+"' AND B1_COD = EE8_COD_I AND"+;
                       " SB1.D_E_L_E_T_ <> '*' AND B1_FILIAL = '" +xFilial("SB1")+"'"

         EndIf                        
    
      Else // ** Não Integrado ao SIGAFAT...
          
         If cCombo = "Sem Solicitação de Crédito" .Or. cCombo = STR0007 //"Ag. Aprovação de Crédito"
            cQry := "SELECT EE7_PEDIDO, EE7_DTPROC, EE7_DTPEDI, EE7_IMPODE"
         Else
            cQry := "SELECT EE7_PEDIDO, EE7_DTPROC, EE7_DTPEDI, EE7_IMPODE, EE8_SLDATU"      
         EndIf
      
         If cCombo = "Sem Solicitação de Crédito"
         
            cQry += " FROM "+RetSqlName("EE7")+" EE7" 
         
            cWhere := " WHERE EE7.D_E_L_E_T_ <> '*' AND "+; 
                      " EE7_FILIAL = '" +xFilial("EE7")+"' AND EE7_STATUS <> '"+ST_PC+"' AND EE7_DTSLCR = '        '"
                    
         ElseIf cCombo = "Ag. Aprovação de Crédito"  
         
            cQry += " FROM "+RetSqlName("EE7")+" EE7"
        
            cWhere := " WHERE EE7.D_E_L_E_T_ <> '*' AND "+; 
                      " EE7_FILIAL = '" +xFilial("EE7")+ "' AND EE7_STATUS <> '"+ST_PC+"' AND EE7_DTSLCR <> '        ' "+;
                      " AND EE7_DTAPCR = '        '"
        
         Else // ** Credito Aprovado
         
            cQry += " FROM "+RetSqlName("EE7")+" EE7," +RetSqlName("EE8")+" EE8"
        
            cWhere := " WHERE EE7.D_E_L_E_T_ <> '*' AND "+; 
                      " EE7_FILIAL = '" +xFilial("EE7")+ "' AND EE7_STATUS <>'"+ST_PC+"' AND EE7_DTAPCR <> '        '"+;
                      " AND EE7_PEDIDO = EE8_PEDIDO AND "+;
                      " EE8.D_E_L_E_T_ <> '*' AND EE8_FILIAL = '"+xFilial("EE8")+"'"+; 
                      " AND EE8_SLDATU <> 0"

         EndIf  
      EndIf  
  
      If !Empty(dDtIni)
         cWhere := cWhere + " AND EE7_DTPROC >= '" + DtoS(dDtIni)+"'"
      EndIf
     
      If !Empty(dDtFim)
         cWhere := cWhere + " AND EE7_DTPROC <= '" + DtoS(dDtFim)+"'"
      EndIf                    
     
      cOrder := " ORDER BY EE7_PEDIDO"
      
   End Sequence

   Return(cQry+cWhere+cOrder)
   
#ENDIF

/*
Funcao          : GravaDBF
Parametros      : Nenhum
Retorno         : .T.
Objetivos       : Gravar DBF com os registros para impressao
Autor           : Jeferson Barros Jr.
Data/Hora       : 20/08/2001 - 17:20
Revisao         : WFS - 30/05: Correção na exibição dos itens faturados parcialmente (ambiente DBF).
Obs.            : 
*/

*-----------------------------------*
Static Function GravaDBF
*-----------------------------------*


Local aSemSX3 := {}, aOrd:=SaveOrd({"EE7","EE8","SD2","SB1"}),;
      cMacro:="", lRet:= .T., lExiste:=.T. 


// ** Variaveis p/ tratamento do periodo digitado ...
// ** cComDtIni    - Com Data Inicial;
// ** cComDtFim    - Com Data Final;
// ** cComDtIniFim - Com Data Inicial e Final;
// ** cSemData     - Sem Data


Local cComDtIni:="", cComDtFim:="", cComDtIniFim:="", cSemData:=""
Local nQtdNf:= 0

aSemSX3 := {{"D2_DOC  ","C",AVSX3("D2_DOC  ",AV_TAMANHO),0},;
            {"D2_QUANT","N",AVSX3("D2_QUANT",AV_TAMANHO),AVSX3("D2_QUANT",AV_DECIMAL)},;
            {"EE8_SLDATU","N",aVSX3("EE8_SLDATU",AV_TAMANHO),AVSX3("EE8_SLDATU",AV_DECIMAL)},;
            {"ITEM    ","C",100,0},;
            {"FLAG    ","C", 01,0}}
                                                                                                   
cWork  := E_CRIATRAB("EE7",aSemSX3,"QRY")

IndRegua("QRY",cWork+OrdBagExt(),"D2_DOC" ,"AllwayTrue()","AllwaysTrue()",STR0015) //"Processando Arquivo Temporário"

Set Index to (cWork+OrdBagExt())
Begin Sequence

   EE7->(DbSetOrder(1))                                                                   
   EE8->(DbSetOrder(1))
   SD2->(DbSetOrder(8)) // ** Filial+Pedido+ItemPV       
   
   // ** Trata o periodo informado ...
   If !Empty(dDtini) .And. !Empty(dDtFim)                               
      cComDtIniFim:= " EE7->EE7_DTPROC >= dDtini .And. EE7->EE7_DTPROC <= dDtfim"
      cMacro := cComDtIniFim
   ElseIf !Empty(dDtini) .And. Empty(dDtFim)
      cComDtIni := " EE7->EE7_DTPROC >= dDtini"
      cMacro := cComDtIni
   ElseIf Empty(dDtini) .And. !Empty(dDtFim)   
      cComDtFim := " EE7->EE7_DTPROC <= dDtfim"
      cMacro    := cComDtFim
   Else
      cSemData :=".T."
      cMacro   := cSemData
   EndIf      
    
   EE7->(DbSeek(xFilial()))
 
   If lIntegra  // ** Integrado ao SIGAFAT
   
      If cCombo = "Aguardando Faturamento"      

         Do While EE7->(!Eof()) .And. EE7->EE7_FILIAL == xFilial("EE7")
            If EE7->EE7_STATUS <> ST_PC  // ** Processo nao estiver cancelado ...            
               If &cMacro               
                  
                  EE8->(DbSeek(xFilial("EE8")+EE7->EE7_PEDIDO))              
                  Do While EE8->(!Eof()) .And. EE8->EE8_FILIAL ==xFilial("EE8") .And. EE7->EE7_PEDIDO = EE8->EE8_PEDIDO
                     
                     If !Empty(EE8->EE8_SLDATU) // ** Processos com Saldo                         

                        lExiste:= SD2->(DbSeek(xFilial("SD2")+EE7->EE7_PEDFAT+EE8->EE8_FATIT))
                        
                        If !lExiste
                           QRY->(DbAppend())
                           QRY->EE7_PEDIDO := EE7->EE7_PEDIDO
                           QRY->EE7_PEDFAT := EE7->EE7_PEDFAT
                           QRY->EE7_DTPROC := EE7->EE7_DTPROC
                           QRY->EE7_IMPODE := EE7->EE7_IMPODE
                           QRY->ITEM       := AllTrim(Posicione("SB1",1,xFilial("SB1")+EE8->EE8_COD_I,"B1_COD"))+" - "+;
                                              AllTrim(Posicione("SB1",1,xFilial("SB1")+EE8->EE8_COD_I,"B1_DESC"))
                           QRY->EE8_SLDATU := EE8->EE8_SLDATU                                 
                        
                        Else 
                           nQtdNf:= 0
                           Do While SD2->(!Eof()) .And. SD2->D2_FILIAL ==xFilial("SD2") .And. EE7->EE7_PEDFAT == SD2->D2_PEDIDO;
                                   .And. SD2->D2_ITEMPV == EE8->EE8_FATIT  

                                 //somatória da quantidade faturada, porém não embarcada, para abatimento do saldo do item
                                 If Empty(SD2->D2_PREEMB)
                                    nQtdNf += SD2->D2_QUANT
                                 EndIf
                                 
                              SD2->(DbSkip())
                           EndDo
                           
                           //Se o item não estiver totalmente embarcado, exibe no relatório
                           If (EE8->EE8_SLDATU - nQtdNf) <> 0                         
                              QRY->(DbAppend())
                              QRY->EE7_PEDIDO := EE7->EE7_PEDIDO
                              QRY->EE7_PEDFAT := EE7->EE7_PEDFAT
                              QRY->EE7_DTPROC := EE7->EE7_DTPROC
                              QRY->EE7_IMPODE := EE7->EE7_IMPODE
                              QRY->ITEM        := AllTrim(Posicione("SB1",1,xFilial("SB1")+EE8->EE8_COD_I,"B1_COD"))+" - "+;
                                                 AllTrim(Posicione("SB1",1,xFilial("SB1")+EE8->EE8_COD_I,"B1_DESC"))
                              QRY->EE8_SLDATU := EE8->EE8_SLDATU - nQtdNf
                           EndIf
                        EndIf
                                                
                     EndIf                                       
                     EE8->(DbSkip())
                  EndDo                             
               EndIf
            Else  // ** Processo Cancelado 
               EE7->(DbSkip())
               Loop
            EndIf            
            EE7->(DbSkip())
         EndDo
                            
      Else // ** Faturados e sem embarque

         Do While EE7->(!Eof()) .And. EE7->EE7_FILIAL == xFilial("EE7")
            If EE7->EE7_STATUS <> ST_PC  // ** Processo nao estiver cancelado ...                        
               If &cMacro

                  EE8->(DbSeek(xFilial("EE8")+EE7->EE7_PEDIDO))

                  Do While EE8->(!Eof()) .And. EE8->EE8_FILIAL ==xFilial("EE8") .And. EE7->EE7_PEDIDO = EE8->EE8_PEDIDO

                     If !Empty(EE8->EE8_SLDATU) // ** Processos com saldo 

                        SD2->(DbSeek(xFilial("SD2")+EE7->EE7_PEDFAT+EE8->EE8_FATIT))                                  
                        
                        Do While SD2->(!Eof()) .And. SD2->D2_FILIAL ==xFilial("SD2") .And. EE7->EE7_PEDFAT == SD2->D2_PEDIDO;
                           .And. SD2->D2_ITEMPV == EE8->EE8_FATIT  
                           // ** Nota fiscal nao vinculada a processo                     
                           If Empty(SD2->D2_PREEMB) .And. !Empty(SD2->D2_DOC)
                              QRY->(DbAppend())
                              QRY->EE7_PEDIDO := EE7->EE7_PEDIDO
                              QRY->EE7_PEDFAT := EE7->EE7_PEDFAT
                              QRY->EE7_DTPROC := EE7->EE7_DTPROC
                              QRY->EE7_IMPODE := EE7->EE7_IMPODE
                              QRY->D2_DOC     := SD2->D2_DOC
        
                              // ** Busca o codigo e a descrição do item ...
                              QRY->ITEM   := AllTrim(Posicione("SB1",1,xFilial("SB1")+EE8->EE8_COD_I,"B1_COD"))+" - "+;
                                             AllTrim(Posicione("SB1",1,xFilial("SB1")+EE8->EE8_COD_I,"B1_DESC"))
                             
                              QRY->D2_QUANT := SD2->D2_QUANT
                           EndIf                                    
                           SD2->(DbSkip())                                                                                                                 
                        EndDo                     
                     EndIf                                                             
                     EE8->(DbSkip())                                                                    
                  EndDo                        
               EndIf
            Else  // ** Processo Cancelado 
               EE7->(DbSkip())
               Loop
            EndIf             
                                   
            EE7->(DbSkip())
         EndDo

      EndIf

   Else  // ** Nao integrado ao SIGAFAT
   
      If cCombo = "Sem Solicitação de Crédito"         
         
         Do While EE7->(!Eof()) .And. EE7->EE7_FILIAL == xFilial("EE7")
            If EE7->EE7_STATUS <> ST_PC  //Processo nao cancelado ...
               If &cMacro .And. Empty(EE7->EE7_DTSLCR) // ** Processo sem data de solicitação  de crédito
                  QRY->(DbAppend())
                  QRY->EE7_PEDIDO := EE7->EE7_PEDIDO
                  QRY->EE7_DTPROC := EE7->EE7_DTPROC 
                  QRY->EE7_DTPEDI := EE7->EE7_DTPEDI
                  QRY->EE7_IMPODE := EE7->EE7_IMPODE
               EndIf
            Else  // ** Processo Cancelado ...
               EE7->(DbSkip())
               Loop
            EndIf
            EE7->(DbSkip())
         EndDo
  
      ElseIf cCombo = "Ag. Aprovação de Crédito"
         
         Do While EE7->(!Eof()) .And. EE7->EE7_FILIAL == xFilial("EE7")
            If EE7->EE7_STATUS <> ST_PC  //Processo nao cancelado ...                        
               // ** Processo sem data de solicitação e de aprovação de crédito  
               If &cMacro .And. !Empty(EE7->EE7_DTSLCR) .And. Empty(EE7->EE7_DTAPCR) 
                  QRY->(DbAppend())            
                  QRY->EE7_PEDIDO := EE7->EE7_PEDIDO               
                  QRY->EE7_DTPROC := EE7->EE7_DTPROC                     
                  QRY->EE7_DTPEDI := EE7->EE7_DTPEDI
                  QRY->EE7_IMPODE := EE7->EE7_IMPODE
               EndIf
            Else  // ** Processo cancelado ...
               EE7->(DbSkip())
               Loop
            EndIf            
            EE7->(DbSkip())
         EndDo
      
      Else // ** "Crédito Aprovado"
              
         Do While EE7->(!Eof()) .And. EE7->EE7_FILIAL == xFilial("EE7")
            If EE7->EE7_STATUS <> ST_PC  //Processo não cancelado ...                                    
               If &cMacro .And. !Empty(EE7->EE7_DTAPCR) //** Processo sem data de aprovação de crédito
                  EE8->(DbSeek(xFilial("EE8")+EE7->EE7_PEDIDO))                
                  Do While EE8->(!Eof()) .And. EE8->EE8_FILIAL ==xFilial("EE8") .And. EE8->EE8_PEDIDO = EE7->EE7_PEDIDO
                     If !Empty(EE8->EE8_SLDATU)
                        QRY->(DbAppend())            
                        QRY->EE7_PEDIDO := EE7->EE7_PEDIDO               
                        QRY->EE7_DTPROC := EE7->EE7_DTPROC                     
                        QRY->EE7_DTPEDI := EE7->EE7_DTPEDI
                        QRY->EE7_IMPODE := EE7->EE7_IMPODE                                     
                        Exit
                     EndIf
                     EE8->(DbSkip())
                  EndDo
               Endif
            Else   // ** Processo Cancelado
               EE7->(DbSkip())
               Loop
            EndIf                                     
            EE7->(DbSkip())
         EndDo              
         
      EndIf  
   Endif 
   
   RestOrd(aOrd)

   QRY->(DbGoTop())   

End Sequence

Return lRet

/*
Funcao          : Imprimir
Parametros      : Nenhum
Retorno         : .T.
Objetivos       : Gravar DBF p/ impressão no relatório
Autor           : Jeferson Barros Jr.
Data/Hora       : 21/08/2001 - 11:08
Revisao         :
Obs.            : Considera se estiver rodando em TOP ou em DBF.
*/

*-----------------------------------*
Static Function Imprimir
*-----------------------------------*
Local lRet := .f.
Local cPeriodo, cPedidoAtual:="", cOldPedido:="", cPVAtual:="",;
      cOldNF:="", cOldProc:="", lFlag:=.T.

#IFDEF TOP
   Local nOldArea
#ENDIF

Begin Sequence
   lZero := .T.
	#IFDEF TOP
	   IF TCSRVTYPE() <> "AS/400"
         cCmd := MontaQuery()
         cCmd := ChangeQuery(cCmd)
         nOldArea := Alias()
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRYTEMP", .F., .T.) 
         QRYTEMP->(dbCloseArea())
         dbSelectArea(nOldArea)
	   ELSE
	#ENDIF
         // ... DBF ...
	#IFDEF TOP
	   ENDIF
	#ENDIF
   CAB->(DBAPPEND())
   CAB->SEQREL  := cSeqRel
   CAB->TITULO  := ""

   // ** Define Titulo do Relatório
   If lIntegra  // ** Integrado ao SIGAFAT  
      If cCombo = STR0004 //"Aguardando Faturamento"
         CAB->TITULO  := UPPER(STR0004) //"AGUARDANDO FATURAMENTO"
      Else // ** Faturados e Sem Embarque
         CAB->TITULO  := UPPER(STR0005) //"FATURADOS E SEM EMBARQUE"
      EndIf   

   Else // ** Não integrado ao SIGAFAT                                     
      If cCombo = STR0006    //"Sem Solicitação de Crédito"
         CAB->TITULO  := STR0023 //"SEM SOLICITAÇÃO DE CRÉDITO"
      ElseIf cCombo = STR0007 //"Ag. Aprovação de Crédito"
         CAB->TITULO  := STR0016 //"AG. APROVAÇAO DE CREDITO"
      Else // ** Crédito Aprovado
         CAB->TITULO  := STR0024 //"CRÉDITO APROVADO"
      EndIF
   EndIf                            
       
   // ** Define o Período do Relatório        
   If !Empty(dDtini) .And. !Empty(dDtfim)
      cPeriodo := STR0017+Dtoc(dDtini)+STR0018+Dtoc(dDtfim) //"De  "###"  Até  "
   ElseIf !Empty(dDtini) .And. Empty(dDtfim)
      cPeriodo := STR0019+Dtoc(dDtini)  //"A partir de  "
   ElseIf Empty(dDtini) .And. !Empty(dDtfim)      
      cPeriodo := STR0020+Dtoc(dDtfim)  //"Até  "
   Else
      cPeriodo := STR0021  //"Todos"
   EndIf
         
   CAB->PERIODO  := cPeriodo

   CAB->(MSUNLOCK())        
    
   Do While QRY->(!Eof())
      #IFDEF TOP
         IF TCSRVTYPE() <> "AS/400"
            IncProc(STR0022 + QRY->EE7_PEDIDO) //"Imprimindo: "
         ELSE
      #ENDIF
            //... DBF ...
      #IFDEF TOP
         ENDIF
      #ENDIF
      cPedidoAtual := QRY->EE7_PEDIDO

      If lIntegra // ** Integrado ao SIGAFAT
                                        
         Do While QRY->(!Eof()) .And. cPedidoAtual = QRY->EE7_PEDIDO
                  
            cPVAtual := QRY->EE7_PEDFAT
            
            DET->(DBAPPEND())
            DET->SEQREL := cSeqRel 
            DET->PEDIDO := AllTrim(QRY->EE7_PEDIDO)
            DET->PEDFAT := AllTrim(QRY->EE7_PEDFAT)
            DET->IMPODE := AllTrim(QRY->EE7_IMPODE)
            DET->DOC    := AllTrim(QRY->D2_DOC)
            DET->QUANT  := Str(QRY->D2_QUANT,AVSX3("D2_QUANT",AV_TAMANHO),AVSX3("D2_QUANT",AV_DECIMAL))
            #IFDEF TOP
               IF TCSRVTYPE() <> "AS/400"
                  DET->DTPROC := TransData(QRY->EE7_DTPROC)            
                  If cCombo = STR0004 //"Aguardando Faturamento"
                     DET->SLDATU:=Str(QRY->EE8_SLDATU,AVSX3("EE8_SLDATU",AV_TAMANHO),AVSX3("EE8_SLDATU",AV_DECIMAL))
                  EndIF
                  DET->ITEM := AllTrim(QRY->B1_COD) +" - "+ AllTrim(QRY->B1_DESC)
               ELSE
            #ENDIF
                  DET->DTPROC := Dtoc(QRY->EE7_DTPROC)            
                  If cCombo = STR0004 //"Aguardando Faturamento"
                     DET->SLDATU:=Str(QRY->EE8_SLDATU,AVSX3("EE8_SLDATU",AV_TAMANHO),AVSX3("EE8_SLDATU",AV_DECIMAL))
                  EndIF                 
                  DET->ITEM := AllTrim(QRY->ITEM)
            #IFDEF TOP
               ENDIF
            #ENDIF
            // ** Grava Flag p/ tratamento no Crystal para Details
            IF cOldPedido <> QRY->EE7_PEDIDO
               cOldPedido := QRY->EE7_PEDIDO
               lFlag := !lFlag
            Endif
            
            // ** Grava Flag para tratamento do zebrado.
            DET->FLAG := IF(lFlag,"1","0") 

            // ** Grava Flag p/ tratamento dos campos Processo, Pedido Venda, Dt Processo, Importador
            If cOldProc <> QRY->EE7_PEDIDO
               DET->FLAGP ="1"
               cOldProc := QRY->EE7_PEDIDO
            Else
               DET->FLAGP ="0"
            Endif
            
            // ** Grava Flag p/ tratamento do campo Nota Fiscal
            If cOldNF <> QRY->D2_DOC
               DET->FLAGNF :="1" 
               cOldNF := QRY->D2_DOC
            Else
               DET->FLAGNF :="0"
            EndIf               
                       
            // ** Grava Flag p/ tratamento no Crystal para Headers (Integrado ou Não) ...                          
            DET->FLAGI := "1" 
          
            DET->(MSUNLOCK())      	 
      	 
      	    lNovo := .T.              
            lZero := .F.
            lRet  := .T.

            QRY->(dbSkip())        
         Enddo              
    	
      Else // ** Nao integrado ao SIGAFAT            
         
         DET->(DBAPPEND())    	  
         DET->SEQREL := cSeqRel 
         DET->PEDIDO := AllTrim(QRY->EE7_PEDIDO)
         DET->IMPODE := AllTrim(QRY->EE7_IMPODE)
         #IFDEF TOP
            IF TCSRVTYPE() <> "AS/400"
               DET->DTPROC := TransData(QRY->EE7_DTPROC)
               DET->DTPEDI := TransData(QRY->EE7_DTPEDI) 
            ELSE
         #ENDIF
               DET->DTPROC := Dtoc(QRY->EE7_DTPROC)
               DET->DTPEDI := Dtoc(QRY->EE7_DTPEDI) 
         #IFDEF TOP
            ENDIF
         #ENDIF
         // ** Grava Flag p/ tratamento no Crystal para Details
         IF cOldPedido <> QRY->EE7_PEDIDO
            cOldPedido := QRY->EE7_PEDIDO
            lFlag := !lFlag
         Endif
            
         // ** Grava Flag para tratamento do zebrado.
         DET->FLAG := IF(lFlag,"1","0") 
         
         // ** Grava Flag p/ tratamento no Crystal para Headers (Integrado ou Não) ...                 
         DET->FLAGI := "0" 
            
         DET->(MSUNLOCK())

         QRY->(dbSkip())      

      EndIf 
 
      lNovo := .T.              
      lZero := .F.
      lRet  := .T.             
      
   EndDo

End Sequence
Return lRet   
 
/*
Funcao          : Borda()
Parametros      : oDialog - dialog onde será desenhada a borda
                  lDupla  - define se a borda será simples ou dupla: .f. - simples (-)(default)
Retorno         : nil                                                .t. - Dupla   (=)
Objetivos       : Desenhar borda para a MsDialog
Autor           : João Pedro Macimiano Trabbold
Data/Hora       : 29/10/2004 - 17:15
Revisao         :
Obs.            : 
*/
/*
*---------------------------------------*
Static Function Borda(oDialog,lDupla)
*---------------------------------------*  
Private nBorda1 := 0, nBorda2 := 0  
default lDupla := .f.   
nBorda1 := (oDialog:nClientHeight - 2)/2   
nBorda2 := (oDialog:nClientWidth - 1)/2 
                  
if lDupla
   @ 11,3 to nBorda1+1,nBorda2-1 PIXEL 
   @ 13,1 to nBorda1-1,nBorda2+1 PIXEL   
   @ 11,1 to nBorda1+1,nBorda2+1 PIXEL 
Else  
   @ 12,2 to nBorda1,nBorda2 PIXEL      
Endif 

Return nil
*/

**********************************************************************************************************
* FIM DO PRORAMA EECPPE03.PRW                                                                            *
**********************************************************************************************************
                            
