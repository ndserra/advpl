#INCLUDE "EECPEM29.ch"

/*
Programa        : EECPEM29.PRW
Objetivo        : Carta COLLECT LETTER
Autor           : Cristiano A. Ferreira
Data/Hora       : 07/12/1999
Obs.            :  
*/

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"
  
#xTranslate xLin1(<nVar>) => (<nVar> := <nVar>+10)
#xTranslate xLin2(<nVar>) => (<nVar> := <nVar>+08)

/*
Funcao      : EECPEM29
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
User Function EECPEM29

Local lRet := .f.
Local aOrd := SaveOrd({"SA6","EEL"})

Local cEXP_NOME,mDetalhe

//USADO NO EECF3EE3 VIA SXB "E34" PARA GET ASSINANTE
Private M->cSEEKEXF:=""
Private M->cSEEKLOJA:=""

Private cBcoAvis1,cBcoAvis2
Private cBcoCred1,cBcoCred2,cBcoCred3
Private cAss1,cAss2

Begin Sequence

   SA6->(dbSetOrder(1))
   EEL->(dbSetOrder(1))

   //regras para carregar dados
   IF !EMPTY(EEC->EEC_EXPORT)
      cEXP_NOME := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      M->cSEEKEXF  :=EEC->EEC_EXPORT
      M->cSEEKLOJA :=EEC->EEC_EXLOJA
   ELSE
      cEXP_NOME := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME")
      M->cSEEKEXF  :=EEC->EEC_FORN
      M->cSEEKLOJA :=EEC->EEC_FOLOJA
   ENDIF

   cBcoAvis1 := Padr(BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_AVI),60)
   cBcoAvis2 := Space(60)

   cBcoCred1 := "ABN AMRO BANK - NY - USA"
   cBcoCred2 := "ACCOUNT NR. 673.079.756.141 - CHIPS 0958"
   cBcoCred3 := "ABA 026009580 - ABNAF 33"
   
   cAss1 := Padr(EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1),60)
   cAss2 := Padr(EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",2),60)

   IF !TelaGets()
      Break
   Endif

   IF ! E_AVGLTT("G")
      Break
   Endif
   
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C01_60:=cEXP_NOME
   
   AVGLTT->AVG_C02_60:= "HEAD OFFICE: RUA DR. EDUARDO DE SOUZA ARANHA, 153"
   AVGLTT->AVG_C03_60:= "CEP 04543-904 - SAO PAULO - BRASIL"
   AVGLTT->AVG_C04_60:= "PHONE: 005511-828-1140 / 1229 FAX: 005511-828-1009"
   
   mDetalhe:= ""
   
   mDetalhe:= mDetalhe+Padc("COLLECTION LETTER",90)+ENTER
   mDetalhe:= mDetalhe+Padc("-----------------",90)+ENTER
   
   mDetalhe:= mDetalhe+Space(50)+"DATE: "+Upper(cMonth(dDataBase))+" "+AllTrim(Str(Day(dDataBase)))+", "+Str(Year(dDataBase),4)+ENTER
   mDetalhe:= mDetalhe+Space(50)+"COURIER NBR.: "+EEC->EEC_COURIE+ENTER
   
   // Posiciona o arquivo EEJ ...
   BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_DIM)
   
   SA6->(dbSeek(xFilial()+EEJ->EEJ_CODIGO+EEJ->EEJ_AGENCI))
   
   mDetalhe:= mDetalhe+"TO: "+SA6->A6_NOME+ENTER
   mDetalhe:= mDetalhe+"    "+SA6->A6_END+ENTER
   mDetalhe:= mDetalhe+"    "+AllTrim(SA6->A6_MUN)+" "+AllTrim(SA6->A6_UNIDFED)+" "+Posicione("SYA",1,xFilial("SYA")+SA6->A6_COD_P,"YA_DESCR")+ENTER
   mDetalhe:= mDetalhe+"    ATN: "+AllTrim(EECCONTATO(CD_SA6,SA6->A6_COD,,"1",1))+" PHONE: "+AllTrim(EECCONTATO(CD_SA6,SA6->A6_COD,,"1",4))+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+"REF.: DOCUMENTARY COLLECTION"+ENTER
   mDetalhe:= mDetalhe+'REMARKS : " ALWAYS QUOTE OUR REF. NBR. '+AllTrim(EEC->EEC_PREEMB)+' "'+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+"WE ENCLOSE DOCUMENTS AS PER BELOW LIST, FOR ACCEPTANCE AND/OR COLLECTION"+ENTER
   mDetalhe:= mDetalhe+"ACCORDING INSTRUCTIONS SHOWN BELOW:"+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+"DRAWBEE: "+EEC->EEC_IMPODE+ENTER
   mDetalhe:= mDetalhe+"         "+EEC->EEC_ENDIMP+ENTER
   mDetalhe:= mDetalhe+"         "+EEC->EEC_END2IM+ENTER
   mDetalhe:= mDetalhe+"DRAWER'S NBR.: "+EEC->EEC_PREEMB+ENTER
   mDetalhe:= mDetalhe+"TERM AMOUNT: "+EEC->EEC_MOEDA+" "+Transf(EEC->EEC_TOTPED,AVSX3("EEC_TOTPED",6))+ENTER

   // ** By JBJ - 06/01/2004 - Faz a leitura do Draft maturity a partir do EEQ (Parcelas de Câmbio).
   EEQ->(DbSetOrder(1))
   If EEQ->(DbSeek(xFilial("EEQ")+EEC->EEC_PREEMB))
      Do While EEQ->(!Eof()) .And. EEQ->EEQ_FILIAL == xFilial("EEQ") .And.;
                                   EEQ->EEQ_PREEMB == EEC->EEC_PREEMB
         If !Empty(EEQ->EEQ_VCT)
            mDetalhe:= mDetalhe+"DRAFT MATURITY: "+Dtoc(EEQ->EEQ_VCT)+ENTER
            Exit
         EndIf
         EEQ->(DbSkip())
      EndDo
   Else
      mDetalhe:= mDetalhe+"DRAFT MATURITY: "+ENTER
   EndIf

   mDetalhe:= mDetalhe+"INSTRUCTIONS:"+ENTER
   mDetalhe:= mDetalhe+"=> ACKNOWLEDGE RECEIPT OF THE ENCLOSED DOCUMENTS TO "+AllTrim(BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_FOR))+" GIVING"+ENTER
   mDetalhe:= mDetalhe+"   YOUR REFERENCE."+ENTER
   mDetalhe:= mDetalhe+"=> DOCUMENTS TO BE DELIVERED AGAINST ACCEPTANCE."+ENTER
   mDetalhe:= mDetalhe+"=> PROTEST FOR NON-PAYMENT AND/OR NON-ACCEPTANCE ADVISE "+AllTrim(cBcoAvis1)+" BY SWIFT"+ENTER
   mDetalhe:= mDetalhe+"   CODE - "+AllTrim(cBcoAvis2)+"."+ENTER
   mDetalhe:= mDetalhe+"=> PLEASE CREDIT TOTAL AMOUNT TO: "
   mDetalhe:= mDetalhe+cBcoCred1+ENTER
   mDetalhe:= mDetalhe+"                                  "+cBcoCred2+ENTER
   mDetalhe:= mDetalhe+"                                  "+cBcoCred3+ENTER
   mDetalhe:= mDetalhe+"                                  TO CREDIT: "+cEXP_NOME+ENTER+ENTER
   mDetalhe:= mDetalhe+"=> INTERESTS AFTER MATURY: LIBOR + 4% THE SPREAD."+ENTER
   mDetalhe:= mDetalhe+"   COMMERCIAL PAPERS (I.C.C. BROCHURE 522)."+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+Padr("   DOCUMENTS LIST",40)+Padc("ORIGINAL",10)+Padc("COPIES",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   --------------",40)+Padc("--------",10)+Padc("------",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   DRAFT",40)+Padc("01",10)+Padc("02",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   BILL OF LOADING",40)+Padc("03",10)+Padc("03",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   COMMERCIAL INVOICE",40)+Padc("01",10)+Padc("03",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   CERTIFICATE OF ORIGIN",40)+Padc("01",10)+Padc("02",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   INSURANCE CERTIFICATE",40)+Padc("01",10)+Padc("02",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   PACKING LIST",40)+Padc("01",10)+Padc("03",10)+ENTER
   mDetalhe:= mDetalhe+Padr("   LETTERS",40)+Padc("00",10)+Padc("00",10)+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+"YOURS VERY TRULY,"+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+cAss1+ENTER
   mDetalhe:= mDetalhe+cAss2
   
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet:=E_AVGLTT("M",WORKID->EEA_TITULO)
   
End Sequence

RestOrd(aOrd)

Return lRet

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.

Local bOk     := {||lRet := .t., oDlg:End()}
Local bCancel := {||oDlg:End()}
   
Local y := 20
Local oDlg

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 9,10 TO 28,70 OF oMainWnd
   
      @ y,01 SAY STR0001 PIXEL //"Banco Avisador"
      @ xLin2(y),01 MSGET cBcoAvis1 PICTURE "@!" SIZE 210,08 PIXEL
      @ xLin1(y),01 MSGET cBcoAvis2 PICTURE "@!" SIZE 210,08 PIXEL
      
      xLin2(y)
      
      @ xLin2(y),01 SAY STR0002 PIXEL //"Banco para Crédito"
      @ xLin2(y),01 MSGET cBcoCred1 PICTURE "@!" SIZE 210,08 PIXEL
      @ xLin1(y),01 MSGET cBcoCred2 PICTURE "@!" SIZE 210,08 PIXEL
      @ xLin1(y),01 MSGET cBcoCred3 PICTURE "@!" SIZE 210,08 PIXEL
      
      xLin2(y)
      M->cCONTATO:=cAss1
      @ xLin2(y),01 SAY STR0003 PIXEL //"Assinante"
      @ xLin2(y),01 MSGET M->cCONTATO PICTURE "@!" SIZE 210,08 F3 "E34" PIXEL
      @ xLin1(y),01 MSGET cAss2 PICTURE "@!" SIZE 210,08 F3 "E33" PIXEL
   
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

End Sequence

cAss1:=M->cCONTATO

Return lRet

*-------------------------------------------------------------------------*
* FIM DO ARQUIVO EECPEM29.PRW                                             *
*-------------------------------------------------------------------------*
