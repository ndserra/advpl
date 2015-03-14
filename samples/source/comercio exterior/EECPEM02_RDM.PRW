
/*
Programa : EECPEM02.PRW
Autor    : Cristiano A. Ferreira
Data     : 25/09/1999 14:25
Uso      : Booking
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM02
Parametros  : Nenhum
Retorno     : NIL
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
User Function EECPEM02

Local lRet := .T.
Local nAlias := Select()
Local aOrd := SaveOrd({"EEC","EE9"})

Local cExp_Nome, cExp_Contato, cExp_Fone, cExp_Fax
Local cPedido, cTo_Nome, cTo_Attn, cTo_Fax
Local cAux, cTransp, cAgEmb

Private mDetalhe

Begin Sequence

   EE9->(dbSetOrder(4))

   //regras para carregar dados
   IF !EMPTY(EEC->EEC_EXPORT)
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
   ELSE
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME") 
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
   ENDIF
   
   cEXP_NOME    :=ALLTRIM(cEXP_NOME)
   cEXP_CONTATO :=ALLTRIM(cEXP_CONTATO)
   cEXP_FONE    :=ALLTRIM(cEXP_FONE)
   cEXP_FAX     :=ALLTRIM(cEXP_FAX)
   
   //TO
   cPEDIDO:=AVKey(EEC->EEC_PREEMB,"EEB_PEDIDO")
   cTO_NOME:=RecDocImp(cPedido,OC_EM,1)
   cTO_ATTN:=RecDocImp(cPedido,OC_EM,2)
   cTO_FAX :=RecDocImp(cPedido,OC_EM,3)
   
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
   mDETALHE:="FAC SIMILE NUMBER: "+ALLTRIM(cTO_FAX)+SPACE(6)+"DATE: "+DTOC(dDATABASE)+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"TO  : "+cTO_NOME+ENTER
   mDETALHE:=mDETALHE+"ATTN: "+cTO_ATTN+SPACE(20)+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"FROM: "+cEXP_CONTATO+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"TOTAL NUMBER OF PAGES INCLUDING THIS COVER: 01"+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"RE: Y/ORDER (S) ...: "+EEC->EEC_REFIMP+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"    O/ORDER (S) ...: "+EEC->EEC_PREEMB+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   // Verifica se o tipo de transporte eh rodoviario
   cAux := Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1)
   IF cAux == "7" // Rodoviario
      mDETALHE:=mDETALHE+"SHIPMENT SCHEDULE HAD BEEN DONE AS FOLLOWS:"+ENTER
      mDETALHE:=mDETALHE+ENTER
      
      cTRANSP := BuscaEmpresa(cPedido,OC_EM,CD_TRA) // Busca Transp.
           
      mDETALHE:=mDETALHE+"TRUCKER ...........: "+cTRANSP+ENTER
   Elseif cAux == "4" // Aereo
      mDETALHE:=mDETALHE+"SHIPMENT SCHEDULE HAD BEEN DONE AS FOLLOWS:"+ENTER
      mDETALHE:=mDETALHE+ENTER
      
      cAGEMB := ""
      //tentar 1. o agente recebedor documentos
      cAgEmb := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_AGE)
           
      mDETALHE:=mDETALHE+"SHIPPING LINE .....: "+cAgEmb+ENTER
   
   Else // Maritimo / outros
      mDETALHE:=mDETALHE+"OCEAN VESSEL BOOKING HAS BEEN MADE AS FOLLOWS:"+ENTER
      mDETALHE:=mDETALHE+ENTER
   
      cAGEMB := ""
      //tentar 1. o agente recebedor documentos
      cAgEmb := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_AGE)
      
      // ARMADOR
      cArmador := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_ARM)
      
      mDETALHE:=mDETALHE+"VESSEL NAME .......: "+Posicione("EE6",1,XFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")+ENTER+ENTER
      mDETALHE:=mDETALHE+"SHIPPING LINE .....: "+cAgEmb+ENTER+ENTER
      mDETALHE:=mDETALHE+"SHIPOWNER .........: "+cArmador+ENTER
   Endif   
   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"PORT OF SHIPMENT ..: "+Posicione("SY9",2,XFILIAL("SY9")+EEC->EEC_ORIGEM,"Y9_DESCR")+"  ETS: "+DTOC(EEC->EEC_ETD)+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"PORT OF DESTINATION: "+Posicione("SY9",2,XFILIAL("SY9")+EEC->EEC_DEST  ,"Y9_DESCR")+"  ETA: "+DTOC(EEC->EEC_ETADES)+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   GravaItens()
   
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+"PACKAGE ...........: "+EEC->EEC_PACKAG+ENTER
   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"NET WEIGTH KGS ....: "+TRANSF(EEC->EEC_PESLIQ,"@E 999,999,999.99")+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"GROSS WEIGTH KGS ..: "+TRANSF(EEC->EEC_PESBRU,"@E 999,999,999.99")+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+"REMARKS"+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+"REGARDS"+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+"IF YOU DO NOT RECEIVE ALL PAGES, PLEASE CALL US "
   mDETALHE:=mDETALHE+"PHONE "+cEXP_FONE
     
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO)
   
End Sequence

//retorna a situacao anterior ao processamento
RestOrd(aOrd)
Select(nAlias)

Return lRet

/*
Funcao      : GravaItens
Parametros  : Nenhum
Retorno     : NIL
Objetivos   : Itens do Embarque (EE9)
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function GravaItens

Local cMemo := ""
Local nSpaces := 0
Local nTot := 0, i := 0

Begin Sequence
   mDETALHE:=mDETALHE+"PRODUCT(S):"+ENTER
   mDETALHE:=mDETALHE+ENTER

   EE9->(DBSEEK(XFILIAL()+EEC->EEC_PREEMB))

   DO WHILE EE9->(!EOF()) .AND. EE9->EE9_FILIAL==XFILIAL("EE9") .AND.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB
      
      cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
      
      // *** CAF 05/01/2000 mDETALHE:=mDETALHE+TRANSFORM(EE9->EE9_PSLQTO,"@E 999,999,999"+IF(EEC->EEC_DECPES==0,"","."+REPL("9",EEC->EEC_DECPES)))+" "+EE9->EE9_UNIDAD+" "+MemoLine(cMemo,AVSX3("EE9_VM_DES",3),1)
      mDETALHE:=mDETALHE+TRANSFORM(EE9->EE9_SLDINI,"@E 999,999,999"+IF(EEC->EEC_DECQTD==0,"","."+REPL("9",EEC->EEC_DECQTD)))+" "+EE9->EE9_UNIDAD+" "+MemoLine(cMemo,AVSX3("EE9_VM_DES",3),1)
      mDETALHE:=mDETALHE+ENTER
      
      nSpaces := Len(TRANSFORM(EE9->EE9_PSLQTO,"@E 999,999,999"+IF(EEC->EEC_DECPES==0,"","."+REPL("9",EEC->EEC_DECPES)))+" "+EE9->EE9_UNIDAD+" ")
      nTot := MlCount(cMemo,AVSX3("EE9_VM_DES",3))
      
      For i:=2 To nTot
         mDetalhe:=mDetalhe+Space(nSpaces)+MemoLine(cMemo,AVSX3("EE9_VM_DES",3),i)+ENTER
      Next
      
      EE9->(DBSKIP())
   ENDDO

End Sequence
     
RETURN NIL

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM02.PRW                                                 *
*------------------------------------------------------------------------------*
