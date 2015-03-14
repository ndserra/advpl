
/*
Programa  : EECPem57_rdm.prw
Objetivo  : Impressao do Saque (Modelo 2).
Autor     : Jeferson Barros Jr.
Data/Hora : 14/08/1999 14:35.
Obs       : Desenvolvido inicialmente para S.Magalhães. (ECSME04.PRW)
*/        

#INCLUDE "EECPEM57.CH"
#Include "EECRDM.CH"

#DEFINE INGLES   "INGLES-INGLES"
#DEFINE ESPANHOL "ESP.  -ESPANHOL"

/*
Funcao      : EECPEM57
Parametros  : Nenhum
Retorno     : .t./.f.
Objetivos   : Impressao do Saque (Modelo 2).
Autor       : Jeferson Barros Jr.
Data/Hora   : 19/03/2002 11:09
Revisao     : 
Obs.        :
*/
*---------------------*
User Function EECPEM57
*---------------------*
Local lRet:=.t., aOrd := SaveOrd({"EEC","EEL","SA2","EEQ","EE2"})
Local cBanco,cExpMun, cLinha1, cLinha2, cVlExtenso,cDesc:="",cSY0SEQ
Local n1,n2,n3, nAlias := Select(), nx:=0, nCont:=0

Private cVencto:=CriaVar("A2_NOME"), cCondPagto:=CriaVar("A2_NOME"),cValue,cData:=CriaVar("A2_NOME")
Private cFileMen:=""
Private cMarca := GetMark(), lInverte := .f.,aFields

Private aHeader := {}, aCAMPOS := ARRAY(0)
Private nVlParc:=0, cDtVencto
Private bValor:={|| Transform(WORK->WKVL,AVSX3("EEC_TOTPED",AV_PICTURE))}

Private cPARC, cEXPORT, cVALUE2, cVALUE3, lCHKSPF, cOLDCOND,;
        cForn := cIMPO1 := cIMPO2 := cIMPO3 := cIMPO4 := cIMPO5 := Space(60)

cEXPORT := SPACE(60)

BEGIN SEQUENCE
   
   aFields := { {"WKMARCA","C",02,0},;
                {"WKPARC" ,"C",AVSX3("EEQ_PARC",AV_TAMANHO),0},;
                {"WKVCT"  ,"D",AVSX3("EEQ_VCT",AV_TAMANHO) ,0},;
                {"WKVL"   ,"N",AVSX3("EEQ_VL",AV_TAMANHO)  ,2}}

   cFile := E_CriaTrab(,aFields,"Work")
   IndRegua("Work",cFile+OrdBagExt(),"WKPARC")

   aCampos := { {"WKMARCA",," "},;
                {"WKPARC" ,,STR0001},; //"Nr.Parcela"
                {"WKVCT"  ,,STR0002},; //"Dt.Vencto"
                {bValor   ,,STR0003}} //"Vlr.PArcela"

   cSY0SEQ := ""
  
   SA6->(dbSetOrder(1))
   SA2->(DbSetOrder(1))
   DbSelectArea("EEQ")
   EEQ->(DbSetOrder(1))

   // ** Nome do Beneficiario.
   IF !Empty(EEC->EEC_EXPORT)
      SA2->(DbSeek(xFilial("SA2")+EEC->EEC_EXPORT))
   Else
      SA2->(DbSeek(xFilial("SA2")+EEC->EEC_FORN))
   Endif

   cExpMun := Alltrim(SA2->A2_MUN)

   // ** Se tiver embarcado.
   IF !Pem57Vct(1) // ** Busca a data do vencimento e o valor.
      lRET := .F.
      BREAK
   ENDIF

   cCondPagto := Padr(SY6Descricao(EEC->EEC_CONDPA+STR(EEC->EEC_DIASPA,AVSX3("Y6_DIAS_PA",3)),"INGLES-INGLES"),30)   
   //cData      := IncSpace(AllTrim(cExpMun)+", "+Upper(cMonth(EEC->EEC_DTCONH))+" "+PEM57Number(AllTrim(Str(Day(EEC->EEC_DTCONH))))+", "+Str(Year(EEC->EEC_DTCONH),4),60,.f.)  // GFP - 31/07/2012 - Padronização de data americana.
   cData      := IncSpace(AllTrim(cExpMun)+", "+Upper(cMonth(EEC->EEC_DTEMBA))+" "+PEM57Number(AllTrim(Str(Day(EEC->EEC_DTEMBA))))+", "+Str(Year(EEC->EEC_DTEMBA),4),60,.f.)  // GFP - 16/08/2012 - Relatorio deve trazer data de embarque.
   
   // ** Fornecedor.
   cForn := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME")+Space(90)
   IF !Empty(BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_DBR))
      cForn := EEJ->EEJ_NOME+Space(90)
   Endif

   // ** Exportador.
   IF !Empty(EEC->EEC_EXPORT)
      cExport := IncSpace(Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME"),60,.f.)
   Else
      cExport := IncSpace(Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME"),60,.f.)
   Endif
   
   //GFP - 21/07/2012
   EXP->(DbSetOrder(1))  //EXP_FILIAL+EXP_PREEMB+EXP_NRINVO
   EXP->(DbSeek(xFilial("EEC")+EEC->EEC_PREEMB))
      
   // ** Verfica se tem carta de crédito.
   If !Empty(EEC->EEC_LC_NUM)
      cValue := PADR(STR0004+Alltrim(EEC->EEC_LC_NUM)+STR0005+Alltrim(SA6->A6_NOME),60," ") //"DRAWN UNDER IRREVOCABLE L/C NO. "###" OF "
   Else
      cValue := PADR(STR0006+Alltrim(/*EEC->EEC_PEDREF*/ EXP->EXP_NRINVO),60," ") //"OUR COMMERCIAL INVOICE NR. "     // GFP - 21/07/2012 - Inserido numero da Invoice na impressão.
   EndIf

   cVALUE2 := cVALUE3 := SPACE(60)

   // ** Busca dados p/ edição "To" se o processo tiver L/C banco emissor, caso contrario carregas as informações
   // ** do importador. 

   EEL->(dbSetOrder(1))
   EEL->(DBSEEK(XFILIAL("EEL")+EEC->EEC_LC_NUM))

   IF EMPTY(EEC->EEC_LC_NUM) .Or. Empty(EEL->EEL_BCOEM+EEL->EEL_AGCEM)
      IF ! Empty(BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_DIM))
         SA6->(dbSetOrder(1))
         SA6->(dbSeek(xFilial()+EEJ->EEJ_CODIGO+EEJ->EEJ_AGENCI))
         SYA->(DBSETORDER(1))
         SYA->(DBSEEK(XFILIAL("SYA")+SA6->A6_COD_P))
         cIMPO1 := PADR(EEJ->EEJ_NOME,60," ")
         cIMPO2 := PADR(SA6->A6_END  ,60," ")
         cIMPO3 := PADR(ALLTRIM(SA6->A6_MUN)+" "+ALLTRIM(SA6->A6_EST),60," ")
         cIMPO4 := PADR(SYA->YA_DESCR,60," ")
         cIMPO5 := SPACE(60)
      ELSE
         cIMPO1 := PADR(EEC->EEC_IMPODE,60," ")
         cIMPO2 := PADR(EEC->EEC_ENDIMP,60," ")
         cIMPO3 := PADR(EEC->EEC_END2IM,60," ")
         cIMPO4 := cIMPO5 := SPACE(60)
      ENDIF
   ELSE
      IF SA6->(dbSeek(xFilial()+EEL->EEL_BCOEM+EEL->EEL_AGCEM))
         SYA->(DBSETORDER(1))
         SYA->(DBSEEK(XFILIAL("SYA")+SA6->A6_COD_P))
         cIMPO1 := PADR(SA6->A6_NOME,60," ")
         cIMPO2 := PADR(SA6->A6_END ,60," ")
         cIMPO3 := PADR(ALLTRIM(SA6->A6_MUN)+" "+ALLTRIM(SA6->A6_EST),60," ")
         cIMPO4 := PADR(SYA->YA_DESCR,60," ")
         cIMPO5 := SPACE(60)
      ENDIF
   ENDIF

   IF ! TelaGets1()
      lRet := .F.
      BREAK
   Endif

   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   For nCont := 1 To 3         
      cDesc:=""
      HEADER_P->(DBAPPEND())
      IF HEADER_P->(RLOCK())
	     // ** carga obrigatoria
         HEADER_P->AVG_FILIAL := xFilial("SY0")
         HEADER_P->AVG_SEQREL := cSeqRel 
         HEADER_P->AVG_CHAVE  := EEC->EEC_PREEMB
         
         //GFP - 21/07/2012
         EXP->(DbSetOrder(1))  //EXP_FILIAL+EXP_PREEMB+EXP_NRINVO
         EXP->(DbSeek(xFilial("EEC")+EEC->EEC_PREEMB))

         // ** Nro. Pedido Referencia
         HEADER_P->AVG_C01_20 := EXP->EXP_NRINVO //EEC->EEC_PEDREF   // GFP - 21/07/2012 - Inserido numero da Invoice na impressão.
         // ** data da invoice
         HEADER_P->AVG_C01_60 := cVencto
         // ** data emissao do saque
         HEADER_P->AVG_C02_60 := cData
		 // ** total do pedido na moeda da capa
         HEADER_P->AVG_C03_60 := AllTrim(EEC->EEC_MOEDA)+Space(10)+AllTrim(Transf(Work->WKVL,"@E 9,999,999,999.99"))
		 // ** condicoes de pagamento no idioma da capa
         HEADER_P->AVG_C04_60 := cCondPagto
         
         // ** TO: se tiver L/C banco emissor senao importador
         HEADER_P->AVG_C06_60 := cIMPO1
         HEADER_P->AVG_C07_60 := cIMPO2
         HEADER_P->AVG_C08_60 := cIMPO3
         HEADER_P->AVG_C13_60 := cIMPO4
         HEADER_P->AVG_C14_60 := cIMPO5
            
         // ** mensagem padrao definida pelo usuario + NR.INVOICE
         HEADER_P->AVG_C05_60 := cValue
         HEADER_P->AVG_C10_60 := cVALUE2
         HEADER_P->AVG_C11_60 := cVALUE3
         HEADER_P->AVG_C09_60 := cEXPORT

         // ** Fornecedor (Guarda p/ poder carregar do histórico).
         HEADER_P->AVG_C01100 := cFORN
 
         // ** Link para sub-relatório.                 
         If nCont = 1
            HEADER_P->AVG_C02_10:="_DESC1" 
         ElseIf nCont = 2
            HEADER_P->AVG_C02_10:="_DESC2" 
         Else
            HEADER_P->AVG_C02_10:="_DESC3" 
         EndIf
 
         IF nCont == 1 
            cDESC := cDESC+STR0007+AllTrim(cCondPagto)+STR0008+AllTrim(cForn) //"At "###" pay this First Bill of Exchange ( Second and Third unpaid ) to the order of "
         Elseif nCont == 2
            cDESC := cDESC+STR0007+AllTrim(cCondPagto)+STR0009+AllTrim(cForn) //"At "###" pay this Second Bill of Exchange ( First and Third unpaid ) to the order of "
         Else
            cDESC := cDESC+STR0007+AllTrim(cCondPagto)+STR0010+AllTrim(cForn) //"At "###" pay this Third Bill of Exchange ( First and Second unpaid ) to the order of "
         Endif
 
         EE2->(DBSETORDER(1))
         EE2->(DBSEEK(XFILIAL("EE2")+"4*"+EEC->EEC_IDIOMA+EEC->EEC_MOEDA))
         n2 := LEN(ALLTRIM(EE2->EE2_DESC_P))

         nX1        := RIGHT(TRANSFORM(Work->WKVL,"@E 9,999,999,999.99"),2)+"/100 "+ALLTRIM(EE2->EE2_DESC_P)
         cVlExtenso := ExtPlusE(INT(Work->WKVL),EEC->EEC_MOEDA) 
         
         IF LEFT(nX1,2) # "00"
            n1         := LEN(ALLTRIM(cVLEXTENSO))
            cVLEXTENSO := ALLTRIM(LEFT(ALLTRIM(cVLEXTENSO),n1-n2))+", "+nX1
         ENDIF
         
         cLinha1 := Upper(MemoLine(cVlExtenso,77,1))
         cLinha2 := Upper(MemoLine(cVlExtenso,77,2))
         cDesc   := cDESC+" the sum of "+ALLTRIM(cLinha1)+Space(1)+ALLTRIM(cLinha2)
         nLinhas := MlCount(cDesc,95)

         For nX:=1 to nLinhas
            AppendDet(nCont)
            DETAIL_P->AVG_C01150:= MemoLine(cDesc,95,nX)
         Next

         HEADER_P->AVG_C12_60 := BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_DBR) // ** Tipo classificacao doc. no Brasil
		 
         IF EMPTY(HEADER_P->AVG_C12_60)
		    cBanco := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_BANCO")
            HEADER_P->AVG_C12_60 := Posicione("SA6",1,xFilial("SA6")+cBanco,"A6_NOME")
		 ENDIF
         
         // ** numeracao dos saques
         HEADER_P->AVG_C01_10 := If(nCont=1,"FIRST",If(nCont=2,"SECOND","THIRD"))
         
         HEADER_P->(MSUNLOCK())
      ENDIF

      HEADER_H->(dbAppend())
      AvReplace("HEADER_P","HEADER_H")

      DETAIL_P->(dbSetOrder(1))
      DETAIL_P->(DbGoTop())
      Do While ! DETAIL_P->(Eof())
         DETAIL_H->(DbAppend())
         AvReplace("DETAIL_P","DETAIL_H")
         DETAIL_P->(DbSkip())
      EndDo

      DETAIL_P->(dbSetOrder(1))
   Next nCont

END SEQUENCE

Work->(E_EraseArq(cFile))

RestOrd(aOrd)

Select(nAlias)

Return lRet

/*
Funcao      : TelaGets1
Parametros  : Nenhum
Retorno     : .t./.f.
Objetivos   : Tela de Gets.
Autor       : Jeferson Barros Jr.
Data/Hora   : 16/12/2003 10:35.
Revisao     : 
Obs.        :
*/
*-----------------------*
Static Function TelaGets
*-----------------------*
Local lRet:=.f.,nOpc:=0
Local bOk:={||nOpc:=1,oDlg:End()},;
      bCancel := {||nOpc:=0,oDlg:End()}
      
Local oDLG,oMark,xx:=""

Begin Sequence
   Work->(DbGoTop())

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 9,10 TO 35,70 OF oMainWnd
      
      //GFP 25/10/2010
      aCampos := AddCpoUser(aCampos,"EEQ","2")
            
      oMark := MsSelect():New("Work","WKMARCA",,aCampos,.F.,@cMarca,{13,1,196,237})
      oMark:bAval:={|| nOpc:=1, oSend(oDlg, "End") }
   ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,bOk,bCancel)) CENTERED

   IF nOpc == 1
      lRet := .t.
   Endif 
   
End Sequence

Return(lRet)

/*
Funcao      : TelaGets1
Parametros  : Nenhum
Retorno     : .t./.f.
Objetivos   : Tela de Gets.
Autor       : Jeferson Barros Jr.
Data/Hora   : 16/12/2003 10:35.
Revisao     : 
Obs.        :
*/
*-------------------------*
Static Function TelaGets1()
*-------------------------*
Local lRet:=.f.,nOpc:=0
Local bCHKBOX,oDLG
Local bOk:={||nOpc:=1,oDlg:End()},;
      bCancel := {||nOpc:=0,oDlg:End()}

PRIVATE oCONDPA

Begin Sequence

   lCHKSPF := .F.
   bCHKBOX := {|| ChksPem57()}
   
   SA2->(DbSetOrder(1))
   SA2->(DbSeek(xFilial("SA2")+EEC->EEC_FORN))

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 9,10 TO 30,70 OF oMainWnd

      @ 016,05 SAY STR0011 OF oDlg PIXEL //"Vencimento"
      @ 014,45 GET cVencto SIZE 80,8  OF oDlg PIXEL

      @ 025,05 SAY STR0012 OF oDLG PIXEL //"Saque Pr.Fixo"
      TCHECKBOX():NEW(25,45,"",bSETGET(lCHKSPF),oDLG,08,08,,bCHKBOX,oDLG:oFONT,,,,,.T.)

      @ 036,05 SAY STR0013 OF oDlg PIXEL //"Cond.Pagto"
      @ 034,45 MSGET oCONDPA VAR cCondPagto SIZE 175,8 OF oDlg PIXEL

      @ 046,05 SAY STR0014 OF oDlg PIXEL //"Value"
      @ 044,45 GET cValue  SIZE 175,8 OF oDlg PIXEL
      @ 054,45 GET cVALUE2 SIZE 175,8 OF oDLG PIXEL
      @ 064,45 GET cVALUE3 SIZE 175,8 OF oDLG PIXEL

      @ 076,05 SAY STR0015 OF oDlg PIXEL //"Data"
      @ 074,45 GET cData   SIZE 175,8 OF oDlg PIXEL

      @ 086,05 SAY STR0016 OF oDlg PIXEL //"Forn./Banco"
      @ 084,45 GET cForn   SIZE 175,8 OF oDlg PIXEL

      @ 096,05 SAY STR0017 OF oDlg PIXEL //"To"
      @ 094,45 GET cIMPO1  SIZE 175,8 OF oDlg PIXEL
      @ 104,45 GET cIMPO2  SIZE 175,8 OF oDlg PIXEL
      @ 114,45 GET cIMPO3  SIZE 175,8 OF oDlg PIXEL
      @ 124,45 GET cIMPO4  SIZE 175,8 OF oDlg PIXEL
      @ 134,45 GET cIMPO5  SIZE 175,8 OF oDlg PIXEL
  
      @ 146,05 SAY STR0018 OF oDLG PIXEL //"Exportador"
      @ 144,45 GET cEXPORT SIZE 175,8 OF oDLG PIXEL

   ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,bOk,bCancel)) CENTERED
  
   IF nOpc == 1
      lRet := .t.
   Endif 
   
End Sequence

Return(lRet)

/*
Funcao      : AppendDet
Parametros  : lMarca
Retorno     : 
Objetivos   : Adiciona registros no arquivo de detalhes
Autor       : Jeferson Barros Jr.
Data/Hora   : 16/12/2003 11:00.
Revisao     : 
Obs.        :
*/
*-------------------------*
Static Function AppendDet(nCont)
*-------------------------*

Begin Sequence

   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSEQREL
   DETAIL_P->AVG_CONT   := AllTrim(Str(nCont))
    
   If nCont = 1
      DETAIL_P->AVG_CHAVE:="_DESC1" 
   ElseIf nCont = 2
      DETAIL_P->AVG_CHAVE:="_DESC2" 
   Else
      DETAIL_P->AVG_CHAVE:="_DESC3" 
   EndIf
   
End Sequence

Return NIL

/*
Funcao      : Pem57Vct.
Parametros  : nP_ACAO,cP_MODO.
Retorno     : .t./.f.
Objetivos   : Verificar vencimento e valor para pagamento.
Autor       : 
Data/Hora   : 
Revisao     : Jeferson Barros Jr.
Data/Hora   : 16/12/2003 10:27.
Obs.        :
*/
*---------------------------------------*
STATIC FUNCTION Pem57Vct(nP_ACAO,cP_MODO)
*---------------------------------------*
LOCAL dDATA,nVALOR,lRET

Begin Sequence

   lRET    := .t.
   cP_MODO := IF(cP_MODO=NIL,"",cP_MODO)
   cPARC   := ""

   IF nP_ACAO = 1
      SY6->(DbSetOrder(1))
      SY6->(DbSeek(xFilial("SY6")+EEC->EEC_CONDPA+STR(EEC->EEC_DIASPA,3,0)))
      If SY6->Y6_TIPO = "2" // ** A VISTA
         //IF !Empty(EEC->EEC_CBVCT)  TLM 29/11/2007
         IF !Empty(EEC->EEC_DTEMBA)   
            dData := EEC->EEC_DTEMBA
         ELSE
            dDATA := AVCTOD("")
         Endif
         Work->(dbAppend())
         Work->WKPARC := "10"
         Work->WKVCT  := dData
         Work->WKVL   := EEC->EEC_TOTPED
         cPARC        := "01"
         cVENCTO      := PADR(STR0019,25," ") //"At Sight"

      ElseIf SY6->Y6_TIPO = "3" // ** Parcelado
             EEQ->(DBSETORDER(1))
             If (EEQ->(DbSeek(xFilial("EEQ")+EEC->EEC_PREEMB)))
                Do While !EEQ->(Eof()) .And. EEQ->EEQ_FILIAL == xFilial("EEQ") .And. EEQ->EEQ_PREEMB = EEC->EEC_PREEMB
                   Work->(dbAppend())
                   Work->WKPARC := EEQ->EEQ_PARC
                   Work->WKVCT  := EEQ->EEQ_VCT
                   Work->WKVL   := EEQ->EEQ_VL
                   EEQ->(DbSkip())
                EndDo
             Else
                If ! Empty(SY6->Y6_PERC_01)
                   nValor := EEC->EEC_TOTPED*(SY6->Y6_PERC_01/100)
                   dData  := EEC->EEC_DTCONH + SY6->Y6_DIAS_01
                   Work->(dbAppend())
                   Work->WKPARC := "01"
                   IF !Empty(EEC->EEC_DTCONH)
                      Work->WKVCT  := dData
                   Endif
                   Work->WKVL   := nValor
                EndIf
                If !Empty(SY6->Y6_PERC_02)
                   nValor := EEC->EEC_TOTPED*(SY6->Y6_PERC_02/100)
                   dData  := EEC->EEC_DTCONH + SY6->Y6_DIAS_02
                   Work->(dbAppend())
                   Work->WKPARC := "02"
                   IF !Empty(EEC->EEC_DTCONH)
                      Work->WKVCT  := dData
                   Endif
                   Work->WKVL   := nValor
                EndIf
                If !Empty(SY6->Y6_PERC_03)
                   nValor := EEC->EEC_TOTPED*(SY6->Y6_PERC_03/100)
                   dData  := EEC->EEC_DTCONH + SY6->Y6_DIAS_03
                   Work->(dbAppend())
                   Work->WKPARC := "03"
                   IF !Empty(EEC->EEC_DTCONH)
                      Work->WKVCT  := dData
                   Endif
                   Work->WKVL   := nValor
                EndIf
                If !Empty(SY6->Y6_PERC_04)
                   nValor := EEC->EEC_TOTPED*(SY6->Y6_PERC_04/100)
                   dData  := EEC->EEC_DTCONH + SY6->Y6_DIAS_04
                   Work->(dbAppend())
                   Work->WKPARC := "04"
                   IF !Empty(EEC->EEC_DTCONH)
                      Work->WKVCT  := dData
                   Endif
                   Work->WKVL   := nValor
                EndIf
                If !Empty(SY6->Y6_PERC_05)
                   nValor := EEC->EEC_TOTPED*(SY6->Y6_PERC_05/100)
                   dData  := EEC->EEC_DTCONH + SY6->Y6_DIAS_05
                   Work->(dbAppend())
                   Work->WKPARC := "05"
                   IF !Empty(EEC->EEC_DTCONH)
                      Work->WKVCT  := dData
                   Endif
                   Work->WKVL   := nValor
                Endif
                If !Empty(SY6->Y6_PERC_06)
                   nValor := EEC->EEC_TOTPED*(SY6->Y6_PERC_06/100)
                   dData  := EEC->EEC_DTCONH + SY6->Y6_DIAS_06
                   Work->(dbAppend())
                   Work->WKPARC := "06"
                   IF !Empty(EEC->EEC_DTCONH)
                      Work->WKVCT  := dData
                   Endif
                   Work->WKVL   := nValor
                EndIf
                If !Empty(SY6->Y6_PERC_07)
                   nValor := EEC->EEC_TOTPED*(SY6->Y6_PERC_07/100)
                   dData  := EEC->EEC_DTCONH + SY6->Y6_DIAS_07
                   Work->(dbAppend())
                   Work->WKPARC := "07"
                   IF !Empty(EEC->EEC_DTCONH)
                      Work->WKVCT  := dData
                   Endif
                   Work->WKVL   := nValor
                EndIf
                If !Empty(SY6->Y6_PERC_08)
                   nValor := EEC->EEC_TOTPED*(SY6->Y6_PERC_08/100)
                   dData  := EEC->EEC_DTCONH + SY6->Y6_DIAS_08
                   Work->(dbAppend())
                   Work->WKPARC := "08"
                   IF !Empty(EEC->EEC_DTCONH)
                      Work->WKVCT  := dData
                   Endif
                   Work->WKVL   := nValor
                EndIf
                If !Empty(SY6->Y6_PERC_09)
                   nValor := EEC->EEC_TOTPED*(SY6->Y6_PERC_09/100)
                   dData  := EEC->EEC_DTCONH + SY6->Y6_DIAS_09
                   Work->(dbAppend())
                   Work->WKPARC := "09"
                   IF !Empty(EEC->EEC_DTCONH)
                      Work->WKVCT  := dData
                   Endif
                   Work->WKVL   := nValor
                EndIf
                If !Empty(SY6->Y6_PERC_10)
                   nValor := EEC->EEC_TOTPED*(SY6->Y6_PERC_10/100)
                   dData  := EEC->EEC_DTCONH + SY6->Y6_DIAS_10
                   Work->(dbAppend())
                   Work->WKPARC := "10"
                   IF !Empty(EEC->EEC_DTCONH)
                      Work->WKVCT  := dData
                   Endif
                   Work->WKVL   := nValor
                EndIf
             EndIf
             IF ! TelaGets()
                lRet := .F.
             Endif
             cPARC := WORK->WKPARC
      ElseIf SY6->Y6_TIPO = "1" // ** Nomal
             If !Empty(EEC->EEC_DTEMBA)
                EEQ->(DbSetOrder(1))
                If (EEQ->(DbSeek(xFilial("EEQ")+EEC->EEC_PREEMB)))
                   dData := EEQ->EEQ_VCT
                EndIf
             Else
                If !Empty(EEC->EEC_DTCONH)
                   dData := EEC->EEC_DTCONH+EEC->EEC_DIASPA
                EndIf      
             EndIf
             Work->(dbAppend())
             Work->WKPARC := "10"
             Work->WKVCT  := dData
             Work->WKVL   := EEC->EEC_TOTPED
             cPARC        := "01"
      EndIf 

      IF lRET
         cVencto := Space(25)

         IF !Empty(Work->WKVCT)
            If SY6->Y6_TIPO = "2" // ** A VISTA.
               cVENCTO      := PADR(STR0019,25," ") //"At Sight"
            ELSE
               cVencto := IncSpace(cMonth(Work->WKVCT)+" "+PEM57Number(AllTrim(Str(Day(Work->WKVCT))))+", "+Str(Year(Work->WKVCT),4),60,.F.)  // GFP - 31/07/2012 - Padronização de data americana.
            ENDIF
         Endif
      ENDIF
   ENDIF

End Sequence

Return lRet

/*
Funcao      : ChksPem57()
Parametros  : Nenhum.
Retorno     : Nil
Objetivos   : 
Autor       : Jeferson Barros Jr.
Data/Hora   : 16/12/2003 11:00.
Revisao     : 
Obs.        :
*/
*-------------------------*
Static Function ChksPem57()
*-------------------------*
LOCAL cA

Begin Sequence

   cOLDCOND   := IF(cOLDCOND=NIL,cVENCTO,cOLDCOND)
   cA         := cCONDPAGTO
   cCONDPAGTO := PADR(cOLDCOND,AVSX3("A2_NOME",AV_TAMANHO)," ")
   cOLDCOND   := cA
   oCONDPA:REFRESH()

End Sequence

Return Nil

/*
Funcao      : PEM57Number()
Parametros  : Day
Retorno     : cRet :: Ordinal Number
Objetivos   : Padronização de data no formato americano.
Autor       : Guilherme Fernandes Pilan - GFP
Data/Hora   : 31/07/2012 - 10:48
*/
*-------------------------*
Static Function PEM57Number(cDay)
*-------------------------*
Local cNum := "", cRet := ""

Begin Sequence
   
   cNum := Left(cDay,1)
   If cNum == "1"     // De 10 a 19
      cRet := cDay+"th"
   Else              // De 1 a 9 e 20 em diante
      cNum := Right(cDay,1)
      Do Case
         Case cNum == "1"
            cRet := cDay+"st"
         Case cNum == "2"
            cRet := cDay+"nd"
         Case cNum == "3"
            cRet := cDay+"rd"
      Otherwise
         cRet := cDay+"th"
      End Do
   EndIf
   
End Sequence

Return cRet

*-----------------------------------------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM57_RDM.PRW                                                                                *
*-----------------------------------------------------------------------------------------------------------------*