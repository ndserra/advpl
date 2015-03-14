
/*
Programa..: EECPME01.PRW
Objetivo..: Impressao do Saque
Autor.....: Cristiano A. Ferreira
Data/Hora.: 14/08/1999 14:35
Obs.......: considera que estah posicionado no registro de embarque (EEC)
ALTERACAO.: LCS - 19/02/2003 - IMPRIMIR O SAQUE PARA CADA PARCELA DO PROCESSO
*/        
#include "EECRDM.CH"
#INCLUDE "EECPEM01.ch"
*--------------------------------------------------------------------
User Function EECPEM01
Local nAlias := Select()
Local aOrd := SaveOrd({"EEC","EEL"})
Local nCont
Local cExport, cBanco
Local cLinha1, cLinha2, cVlExtenso
LOCAL nA
Private cVencto, cCondPagto,aSAQUE,cRPT
BEGIN SEQUENCE
   EEL->(dbSetOrder(1))
   SA6->(dbSetOrder(1))
   cVencto := Space(25)
   cRPT    := WORKID->EEA_ARQUIV
   /// LCS - 19/03/2003
   ///IF !Empty(EEC->EEC_CBVCT)
   ///   cVencto := Padr(cMonth(EEC->EEC_CBVCT)+" "+AllTrim(Str(Day(EEC->EEC_CBVCT)))+", "+Str(Year(EEC->EEC_CBVCT),4),25)
   ///Endif
   
   //GFP - 31/07/2012
   EXP->(DbSetOrder(1))  //EXP_FILIAL+EXP_PREEMB+EXP_NRINVO
   EXP->(DbSeek(xFilial("EEC")+EEC->EEC_PREEMB))
      
   cCondPagto := Padr(SY6Descricao(EEC->EEC_CONDPA+STR(EEC->EEC_DIASPA,AVSX3("Y6_DIAS_PA",3)),"INGLES-INGLES"),30)
   aSAQUE     := GPARC()  // CALCULA AS PARCELAS DE SAQUE P/ IMPRESSAO
   IF LEN(aSAQUE) = 0
      MSGINFO(STR0001,STR0002) //"Impressão do Saque cancelada !"###"Atenção"
      BREAK
   ENDIF
   cSEQREL := GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   FOR nA := 1 TO LEN(aSAQUE)
       IF ! TELAGETS(nA)
          LOOP
       Endif
       //rotina principal
       For nCont := 1 To 4
           HEADER_P->(DBAPPEND())
           //carga obrigatoria
           HEADER_P->AVG_FILIAL := xFilial("SY0")
           HEADER_P->AVG_SEQREL := cSeqRel 
           HEADER_P->AVG_CHAVE  := EEC->EEC_PREEMB
           // Nro. Invoice
           HEADER_P->AVG_C01_20 := EXP->EXP_NRINVO //EEC->EEC_NRINVO  // GFP - 31/07/2012
           //data da invoice
           HEADER_P->AVG_C01_60 := cVencto
           //data emissao do saque
           //HEADER_P->AVG_C02_60 := cMonth(EEC->EEC_DTCONH)+" "+AllTrim(Str(Day(EEC->EEC_DTCONH)))+", "+Str(Year(EEC->EEC_DTCONH),4)
           HEADER_P->AVG_C02_60 := cMonth(EEC->EEC_DTEMBA)+" "+PEM01Number(AllTrim(Str(Day(EEC->EEC_DTEMBA))))+", "+Str(Year(EEC->EEC_DTEMBA),4)  // GFP - 31/07/2012 - Padronização de data americana.
           //total do pedido na moeda da capa
           /// LCS - 19/02/2003
           ///HEADER_P->AVG_C03_60 := AllTrim(EEC->EEC_MOEDA)+" "+AllTrim(Transf(EEC->EEC_TOTPED,"9,999,999,999.99"))
           HEADER_P->AVG_C03_60 := AllTrim(EEC->EEC_MOEDA)+" "+AllTrim(Transf(aSAQUE[nA,1],"9,999,999,999.99"))
           //condicoes de pagamento no idioma da capa
           HEADER_P->AVG_C04_60 := cCondPagto
	       //valor total por extenso (por enquanto somente em ingles)
           /// LCS - 19/02/203
           ///cVlExtenso := ExtPlusE(EEC->EEC_TOTPED,EEC->EEC_MOEDA)
           cVlExtenso := ExtPlusE(aSAQUE[nA,1],EEC->EEC_MOEDA)
           cLinha1    := Upper(MemoLine(cVlExtenso,77,1))
           cLinha2    := Upper(MemoLine(cVlExtenso,77,2))
           IF Empty(cLinha2)
              cLinha1 := Padr(AllTrim(cLinha1)+"  ",77,"*")
              cLinha2 := Padr(AllTrim(cLinha2),77,"*")
           Else
              cLinha2 := Padr(AllTrim(cLinha2)+"  ",77,"*")
           Endif
           HEADER_P->AVG_C01100 := cLinha1
           HEADER_P->AVG_C02100 := cLinha2
           //mensagem padrao definida pelo usuario + NR.INVOICE
           HEADER_P->AVG_C05_60 := "COVERING OUR COMMERCIAL INVOICE NR "+EXP->EXP_NRINVO  //EEC->EEC_NRINVO   // GFP - 31/07/2012
           EEL->(DBSEEK(XFILIAL("EEL")+EEC->EEC_LC_NUM))
           //TO: se tiver L/C banco emissor senao importador
           IF EMPTY(EEC->EEC_LC_NUM) .Or. Empty(EEL->EEL_BCOEM+EEL->EEL_AGCEM)
              HEADER_P->AVG_C06_60 := EEC->EEC_IMPODE
              HEADER_P->AVG_C07_60 := LEFT(EEC->EEC_ENDIMP,42)
              HEADER_P->AVG_C08_60 := SUBST(EEC->EEC_ENDIMP,43)
              HEADER_P->AVG_C13_60 := EEC->EEC_END2IM
           ELSEIF SA6->(dbSeek(xFilial()+EEL->EEL_BCOEM+EEL->EEL_AGCEM))
                  HEADER_P->AVG_C06_60 := SA6->A6_NOME
                  HEADER_P->AVG_C07_60 := SA6->(A6_END+A6_BAIRRO)
                  HEADER_P->AVG_C08_60 := SA6->(A6_MUN+A6_UNIDFED)
	       ENDIF
           //nome do beneficiario
           IF !Empty(EEC->EEC_EXPORT)
              cExport := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
           Else
              cExport := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME")
           Endif
           HEADER_P->AVG_C09_60 := cExport
           //mensagem padrao definida pelo usuario
           IF nCont == 1 .Or. nCont == 4
              HEADER_P->AVG_C10_60 := "sight pay this First Bill of Exchange ( Second"
              HEADER_P->AVG_C11_60 := "and Third unpaid ) to the order of"
           Elseif nCont == 2
                  HEADER_P->AVG_C10_60 := "sight pay this Second Bill of Exchange ( First"
                  HEADER_P->AVG_C11_60 := "and Third unpaid ) to the order of"
           Else
              HEADER_P->AVG_C10_60 := "sight pay this Third Bill of Exchange ( First"
              HEADER_P->AVG_C11_60 := "and Second unpaid ) to the order of"
           Endif
           //OF: banco de entrega de documento senao banco do cadastro do fornecedor
           HEADER_P->AVG_C12_60 := BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_DBR) //TIPO CLASSIFICACAO DOC NO BRASIL
           IF EMPTY(HEADER_P->AVG_C12_60)
              cBanco := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_BANCO")
              HEADER_P->AVG_C12_60 := Posicione("SA6",1,xFilial("SA6")+cBanco,"A6_NOME")
           ENDIF
           //numeracao dos saques
           HEADER_P->AVG_C01_10 := IF(nCont==4,"Copy",Str(nCont,1))
           //*** JBJ 19/06/01 11:48 - Gravar histórico de documentos - (INICIO)
           HEADER_H->(dbAppend())
           AvReplace("HEADER_P","HEADER_H")
        Next
        IF ! AVGCRW32(@cRPT,WORKID->EEA_TITULO,cSEQREL)
           BREAK
        Endif
   NEXT
END SEQUENCE
//retorna a situacao anterior ao processamento
RestOrd(aOrd)
Select(nAlias)
Return(.F.)
*--------------------------------------------------------------------
STATIC FUNCTION TELAGETS(nP_POSVT)
Local lRet:=.f.,nOpc:=0,bOk:={||nOpc:=1,oDlg:End()}
Local bCancel := {||nOpc:=0,oDlg:End()}
Local oDlg, cCont,cTITULO
*
// GFP - 31/07/2012 - Padronização de data americana.
cVENCTO := PADR(CMONTH(aSAQUE[nP_POSVT,2])+" "+;
           PEM01Number(ALLTRIM(STR(DAY(aSAQUE[nP_POSVT,2]))))+", "+;
           STR(YEAR(aSAQUE[nP_POSVT,2]),4),25)
cTITULO := ALLTRIM(WORKID->EEA_TITULO)+" - Parcela "+STRZERO(nP_POSVT,2,0)+;
           "/"+STRZERO(LEN(aSAQUE),2,0)
DEFINE MSDIALOG oDlg TITLE cTITULO FROM 9,10 TO 16,58 OF oMainWnd 
   @ 1,1 SAY "Vencimento" OF oDlg
   @ 1,5 GET cVencto    SIZE 080,8 OF oDlg
   @ 2,1 SAY "Cond.Pagto" OF oDlg
   @ 2,5 GET cCondPagto SIZE 115,8 OF oDlg
ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,bOk,bCancel)) CENTERED
IF nOpc == 1
   lRet := .t.
Endif 
RETURN(lRET)
*--------------------------------------------------------------------
STATIC FUNCTION GPARC()
LOCAL Z,I,nTOTAL,aPARC,nCMP_VLR,dCMP_VCT
*
nTOTAL := 0
aPARC  := {}
// CALCULA AS PARCELAS E SEUS VENCIMENTOS
SY6->(DBSETORDER(1))
SY6->(DBSEEK(XFILIAL("SY6")+EEC->(EEC_CONDPA+STR(EEC_DIASPA,3,0))))
IF SY6->Y6_TIPO = "1"       &&& NORMAL
   //AADD(aPARC,{EEC->EEC_TOTPED,EEC->EEC_ETD+EEC->EEC_DIASPA})  // GFP - 31/07/2012 - Considerar data de embarque
   AADD(aPARC,{EEC->EEC_TOTPED,EEC->EEC_DTEMBA+EEC->EEC_DIASPA})
ELSEIF SY6->Y6_TIPO = "2"   &&& A VISTA
       //AADD(aPARC,{EEC->EEC_TOTPED,EEC->EEC_ETD})
       AADD(aPARC,{EEC->EEC_TOTPED,EEC->EEC_DTEMBA})  // GFP - 31/07/2012 - Considerar data de embarque
ELSE   &&& PARCELADO
   FOR Z := 1 TO 10
       nCMP_VLR := "SY6->Y6_PERC_"+STRZERO(Z,2,0)
       dCMP_VCT := "SY6->Y6_DIAS_"+STRZERO(Z,2,0)
       IF &nCMP_VLR = 0
          EXIT
       ENDIF                                         
       //AADD(aPARC,{EEC->EEC_TOTPED*(&nCMP_VLR/100),EEC->EEC_ETD+&dCMP_VCT})   // GFP - 31/07/2012 - Considerar data de embarque
       AADD(aPARC,{EEC->EEC_TOTPED*(&nCMP_VLR/100),EEC->EEC_DTEMBA+&dCMP_VCT})
       nTOTAL := nTOTAL+aPARC[LEN(aPARC),1]
   NEXT
   // ACERTANDO A DIFERENCA DE PARCELAS
   IF LEN(aPARC) > 0
      IF STRZERO(EEC->EEC_TOTPED,20,2) # STRZERO(nTOTAL,20,2)
         aPARC[LEN(aPARC),1] := aPARC[LEN(aPARC),1]+(EEC->EEC_TOTPED-nTOTAL)
      ENDIF
   ELSE
      MSGINFO("Verificar Processo: "+ALLTRIM(EEC->EEC_PREEMB),"Aviso")
   ENDIF
ENDIF         
RETURN(aPARC)

/*
Funcao      : PEM01Number()
Parametros  : Day
Retorno     : cRet :: Ordinal Number
Objetivos   : Padronização de data no formato americano.
Autor       : Guilherme Fernandes Pilan - GFP
Data/Hora   : 31/07/2012 - 10:48
*/
*-------------------------*
Static Function PEM01Number(cDay)
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
*--------------------------------------------------------------------
