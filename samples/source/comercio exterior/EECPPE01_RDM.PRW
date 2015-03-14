
/*
Programa        : EECPPE01.PRW
Objetivo        : Impressao de Pedido Recebido no AVGLTT.RPT 
Autor           : Heder M Oliveira
Data/Hora       : 15/09/99
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (pedidos) (EE7)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPPE01
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder
Data/Hora   : 
Revisao     :
Obs.        :
*/
User Function EECPPE01

Local lRet := .F.
Local nAlias := Select()

Local cEXP_NOME,cEXP_CONTATO,cEXP_FONE,cEXP_FAX
Local cPEDIDO,cTO_NOME,cTO_ATTN,cTO_FAX,mDetalhe

Begin Sequence

   //regras para carregar dados
   IF !EMPTY(EE7->EE7_EXPORT)
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EE7->EE7_EXPORT+EE7->EE7_EXLOJA,"A2_NOME")
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",1,EE7->EE7_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",4,EE7->EE7_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",7,EE7->EE7_RESPON)  //fax do contato seq 1
   ELSE
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EE7->EE7_FORN+EE7->EE7_FOLOJA,"A2_NOME")
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",1,EE7->EE7_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",4,EE7->EE7_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",7,EE7->EE7_RESPON)  //fax do contato seq 1
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
   IF ( E_AVGLTT("G") )
      //adicionar registro no AVGLTT
      AVGLTT->(DBAPPEND())

      //gravar dados a serem editados
      AVGLTT->AVG_CHAVE :=EE7->EE7_PEDIDO //nr. do processo
      AVGLTT->AVG_C01_60:=cEXP_NOME
      AVGLTT->AVG_C02_60:=WORKID->EEA_TITULO

         //carregar detalhe
      mDETALHE:=""
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+"FAC SIMILE NUMBER: "+ALLTRIM(cTO_FAX)+SPACE(10)+"DATE: "+DTOC(dDATABASE)+ENTER
      mDETALHE:=mDETALHE+"TO  : "+cTO_NOME+ENTER
      mDETALHE:=mDETALHE+"ATTN: "+cTO_ATTN+ENTER
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+"FROM: "+cEXP_CONTATO+ENTER
      mDETALHE:=mDETALHE+ENTER
      
      mDETALHE:=mDETALHE+"TOTAL NUMBER PAGES INCLUDING THIS COVER: 1"+ENTER
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+"ADVICE OF ORDER RECEIPT AS FOLLOWS"+ENTER
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+"YOUR REF NBR ........:"+ALLTRIM(EE7->EE7_REFIMP)+ENTER // Referencia Importador   C 40
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+"CUSTOMER ............:"+ALLTRIM(EE7->EE7_IMPODE)+ENTER // Importador C 30
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+"OUR ORDER NBR WILL BE:"+ALLTRIM(EE7->EE7_PEDIDO)+ENTER // Nr. Pedido        C 20
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+"ACCEPTANCE REGARDING ALL ORDER DETAILS WILL BE SENT SOON."+ENTER
      
      mDETALHE:=mDETALHE+ENTER
    
      mDETALHE:=mDETALHE+ENTER
      
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+ENTER
      
      mDETALHE:=mDETALHE+"BEST REGARDS"+ENTER
      mDETALHE:=mDETALHE+ENTER
      
      mDETALHE:=mDETALHE+"REMARKS: OUR FAX NUMBER "+cEXP_FAX+ENTER
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+"IF YOU NOT RECEIVE ALL PAGES, PLEASE CALL US PHONE "+cEXP_FONE+ENTER
   	 //gravar detalhe
      AVGLTT->WK_DETALHE := mDETALHE
      
      cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
      CONFIRMSX8()
      
      //executar rotina de manutencao de caixa de texto
      lRet:=E_AVGLTT("M",WORKID->EEA_TITULO)
   ENDIF

End Sequence

Select(nAlias)

Return lRet

