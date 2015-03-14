#INCLUDE "EECPEM27.ch"

/*
Programa        : EECPEM27.PRW
Objetivo        : Envio de Saque ao cliente
Autor           : Heder M Oliveira
Data/Hora       : 06/12/99 21:30
Obs.            :  
*/

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"
  
/*
Funcao      : EECPEM27
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Jeferson Barros Jr. - 09/10/01 - 17:12
Obs.        : Alteração na gravação dos dados do fornecedor 
*/
User Function EECPEM27

Local lRet := .f.
Local aOrd := SaveOrd({"EEC"})

Local cTO_NOME,cTO_ATTN,cTO_FAX,cQUEM,cTO_END,cTO_COMEND
Local mDetalhe, cPhone:="", cFax:=""

Private cAssinante := Space(40)

//USADO NO EECF3EE3 VIA SXB "E34" PARA GET ASSINANTE
Private M->cSEEKEXF:=""
Private M->cSEEKLOJA:=""


Begin Sequence

   //regras para carregar dados
   IF !EMPTY(EEC->EEC_EXPORT)
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      M->cSEEKEXF  :=EEC->EEC_EXPORT
      M->cSEEKLOJA :=EEC->EEC_EXLOJA
   ELSE
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME") 
      M->cSEEKEXF  :=EEC->EEC_FORN
      M->cSEEKLOJA :=EEC->EEC_FOLOJA
   ENDIF
   
   IF ! TelaGets()
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
      
   // ** JBJ 08/10/01 - Buscar os dados do Fornecedor ... (Inicio)   
   cPhone  := POSICIONE("SA2",1,XFILIAL("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_TEL")
   cFax    := POSICIONE("SA2",1,XFILIAL("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_FAX")

   AVGLTT->AVG_C02_60:= EECMEND("SA2",1,EEC->EEC_FORN+EEC->EEC_FOLOJA,.T.)[1]
   AVGLTT->AVG_C03_60:= EECMEND("SA2",1,EEC->EEC_FORN+EEC->EEC_FOLOJA,.T.)[2]
   AVGLTT->AVG_C04_60:= "PHONE: "+AllTrim(cPhone)+" FAX: "+AllTrim(cFax)
   
   /*
   AVGLTT->AVG_C02_60:= "HEAD OFFICE: RUA DR. EDUARDO DE SOUZA ARANHA, 153"
   AVGLTT->AVG_C03_60:= "CEP 04543-904 - SAO PAULO - BRASIL"
   AVGLTT->AVG_C04_60:= "PHONE: 005511-828-1140 / 1229 FAX: 005511-828-1009"
   */
   // ** (Fim)
   
   cTO_NOME:= RecDocImp(EEC->EEC_PREEMB,OC_EM,1) // Nome 
   cTO_ATTN:= RecDocImp(EEC->EEC_PREEMB,OC_EM,2) 
   cTO_FAX := RecDocImp(EEC->EEC_PREEMB,OC_EM,3) 
   cQUEM   := RECDOCIMP(EEC->EEC_PREEMB,OC_EM,4) //QUEM 
   cTO_END := RecDocImp(EEC->EEC_PREEMB,OC_EM,5)  //ENDERECO
   cTO_COMEND:= RecDocImp(EEC->EEC_PREEMB,OC_EM,6)  //COMP.ENDERECO

   mDetalhe:=ENTER+ENTER
   mDetalhe:=mDetalhe+"SAO PAULO "+Upper(cMonth(dDataBase))+" "+AllTrim(Str(Day(dDataBase)))+", "+Str(Year(dDataBase),4)+ENTER
   
   mDetalhe:=mDetalhe+ENTER+ENTER
   mDETALHE:=mDetalhe+cTO_NOME+ENTER
   mDETALHE:=mDetalhe+cTO_END+ENTER
   mDETALHE:=mDetalhe+cTO_COMEND+ENTER+ENTER+ENTER
   
   mDETALHE:=mDetalhe+"ATTENTION:         "+cTO_ATTN+ENTER+ENTER+ENTER
 
   mDETALHE:=mDetalhe+"REF.: O/ORDER NBR : "+EEC->EEC_PREEMB+ENTER
   mDETALHE:=mDetalhe+"      Y/ORDER NBR : "+IF(!EMPTY(EEC->EEC_REFAGE),EEC->EEC_REFAGE,EEC->EEC_REFIMP)+ENTER
   mDETALHE:=mDetalhe+"      CUSTOMER    : "+EEC->EEC_IMPODE+ENTER+ENTER+ENTER
   
   mDETALHE:=mDetalhe+"DEARS SIRS,"+ENTER+ENTER
   
   mDETALHE:=mDetalhe+"PLEASE FIND ATTACHED THE FOLLOWING DOCUMENTS:"+ENTER+ENTER
   
   mDETALHE:=mDetalhe+"* ORIGINAL - DRAFT NBR "+EEC->EEC_NRINVO+ENTER+ENTER
   
   mDETALHE:=mDetalhe+"SPECIAL REMARKS: DRAFT MUST BE SIGNED (IN THE BACK AND CONTAING COMPANY STAMP) BY "+ENTER
   mDETALHE:=mDetalhe+"PERSON WHO HAS POWER OF ATTORNEY FOR THIS MATTER (THE SAME ONE THAT USUALLY SIGN "+ENTER
   mDETALHE:=mDetalhe+"THIS DOCUMENT AT BANK) AND RETURN BACK BY WORLD COURIER TO "+POSICIONE("SA2",1,XFILIAL("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME")+ENTER
   mDETALHE:=mDetalhe+"IN ORDER TO BE ABLE TO RELEASE SHIPMENTS."+ENTER+ENTER
   
   mDETALHE:=mDetalhe+"WE REMAIN,"+ENTER
   mDETALHE:=mDetalhe+"YOURS FAITHFULLY"+ENTER
   
   mDETALHE:=mDetalhe+ENTER+ENTER+ENTER
   mDetalhe:=mDetalhe+cAssinante
   
   
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",ALLTRIM(WORKID->EEA_TITULO))
   
End Sequence

//retorna a situacao anterior ao processamento
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

Local bOk     := {||lRet:=.t.,oDlg:End()}
Local bCancel := {||oDlg:End()}

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 9,10 TO 15,70 OF oMainWnd
   
      M->cCONTATO:=cAssinante

      @ 20,1 SAY STR0001 PIXEL //"Assinante"
      @ 20,30 MSGET M->cCONTATO PICTURE "@!" SIZE 120,8 F3 "E34" PIXEL
   
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

   IF lRet
      cAssinante:=M->cCONTATO
   Endif
End Sequence

Return lRet

