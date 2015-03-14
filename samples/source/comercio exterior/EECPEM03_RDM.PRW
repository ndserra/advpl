/*
Programa        : EECPEM03.PRW
Objetivo        : Final Shipment Details
Autor           : Cristiano A. Ferreira
Data/Hora       : 25/09/1999 12:54
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM03
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 25/09/1999 12:54
Revisao     :
Obs.        :
*/
User Function EECPEM03

Local lRet := .T.
Local aOrd := SaveOrd({"SA2"})
Local nAlias := Select()

Local cEXP_NOME,cEXP_CONTATO,cEXP_FONE,cEXP_FAX
Local cPEDIDO,cTO_NOME,cTO_ATTN,cTO_FAX
Local mDetalhe, cTransp

Private cNBR,cCOURIER

Begin Sequence
   SA2->(dbSetOrder(1))
   
   IF ! TelaGets()
      lRet := .f.
      Break
   Endif

   //regras para carregar dados
   IF !EMPTY(EEC->EEC_EXPORT) .AND. ;
       SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
      cEXP_NOME    :=SA2->A2_NOME
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
   ELSE
      SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
      cEXP_NOME    := SA2->A2_NOME
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
   ENDIF
   
   cEXP_NOME    :=ALLTRIM(cEXP_NOME)
   cEXP_CONTATO :=ALLTRIM(cEXP_CONTATO)
   cEXP_FONE    :=ALLTRIM(cEXP_FONE)
   cEXP_FAX     :=ALLTRIM(cEXP_FAX)

   //TO
   cPEDIDO:=AVKey(EE7->EE7_PEDIDO,"EEB_PEDIDO")
   
   cTO_NOME:=RecDocImp(cPedido,OC_PE,1)
   cTO_ATTN:=RecDocImp(cPedido,OC_PE,2)
   cTO_FAX :=RecDocImp(cPedido,OC_PE,3)

   //gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      lRet := .F.
      Break
   Endif
   
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C01_60:=cEXP_NOME
   AVGLTT->AVG_C02_60:=WORKID->EEA_TITULO

   //carregar detalhe
   mDETALHE:="FAC SIMILE NUMBER: "+cTO_FAX+SPACE(20)+"DATE: "+DTOC(dDATABASE)+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"TO  : "+cTO_NOME+ENTER
   mDETALHE:=mDETALHE+"ATTN: "+cTO_ATTN+SPACE(20)+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"FROM: "+cEXP_CONTATO+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"TOTAL NUMBER OF PAGES INCLUDING THIS COVER: 01"+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"MESSAGE"+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"  Y/ORDER (S) ...: "+EEC->EEC_REFIMP+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"  O/ORDER (S) ...: "+EEC->EEC_PREEMB+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"THIS WILL CONFIRM FINAL SHIPPING DETAILS OF ABOVE ORDER:"+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   // Verifica se o tipo de transporte eh rodoviario
   IF Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1) == "7"
      cTRANSP := ""
      mDETALHE:=mDETALHE+"TRUCKER .........: "+BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA)+ENTER
   Else
      mDETALHE:=mDETALHE+"VESSEL NAME .....: "+Posicione("EE6",1,XFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")+ENTER+ENTER
      mDETALHE:=mDETALHE+"STEAMSHIP LINE ..: "+BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_AGE)+ENTER
   Endif   
   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"B/L No. .........: "+EEC->EEC_NRCONH+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"DATED ...........: "+DTOC(EEC->EEC_DTCONH)+ENTER
   mDETALHE:=mDETALHE+ENTER+ENTER+ENTER
   
   mDETALHE:=mDETALHE+"ORIGINAL DOCUMENTS DISPATCHED DATE AS WELL AS "+cCOURIER+ENTER
   mDETALHE:=mDETALHE+"NBR "+ALLTRIM(cNBR)+" WILL BE INFORMED WHEN COPIES FAXED."+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+"BEST REGARDS"+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+ENTER+ENTER
   
   mDETALHE:=mDETALHE+"IF YOU DO NOT RECEIVE ALL PAGES, PLEASE CALL US "
   mDETALHE:=mDETALHE+"PHONE "+cEXP_FONE
     
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO)
   
End Sequence

RestOrd(aOrd)
Select(nAlias)

Return lRet

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 25/09/1999 12:54
Revisao     :
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.
Local nOpcA:=0,oDlg

Local bOk := {|| nOpcA := 1, oDlg:End() }
Local bCancel := {|| oDlg:End() }

Local oGetNbr, oGetCourier, lGetNbr := .f.
Local bSetGetOld

Begin Sequence

   cNBR  := IF(!EMPTY(EEC->EEC_COURIE),EEC->EEC_COURIE,Space(AVSX3("EEC_COURIE",AV_TAMANHO)))  //NBR REF COURIER
   cCOURIER := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_COU)      

   DEFINE MSDIALOG oDlg TITLE AllTrim(WORKID->EEA_TITULO) FROM 10,1 TO 160,500 PIXEL OF oMainWnd
      
      @ 18,020 SAY "ORIGINAL DOCUMENTS DISPATCHED DATE AS WELL AS:" PIXEL
      @ 18,175 MSGET oGetCourier VAR cCOURIER SIZE 55,08 PIXEL
      
      @ 30,020 SAY "NBR " PIXEL
      @ 30,040 MSGET oGetNbr VAR cNBR SIZE 55,08 PIXEL // WHEN !Empty(cCOURIER)
      
      @ 30,100 SAY "WILL BE INFORMED WHEN COPIES FAXED" PIXEL
      
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

   IF nOpcA == 1
      lRet := .t.
      Break
   Endif
   
End Sequence

Return lRet

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM03.PRW                                                 *
*------------------------------------------------------------------------------*