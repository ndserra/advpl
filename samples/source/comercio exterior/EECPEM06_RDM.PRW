
/*
Programa        : EECPEM06.PRW
Objetivo        : Impressao Detalhes do Courier
Autor           : Heder M Oliveira
Data/Hora       : 25/09/1999 21:58
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM06
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder M Oliveira
Data/Hora   : 25/09/1999 21:58
Revisao     :
Obs.        :
*/
User Function EECPEM06

Local nAlias := Select()
Local cPEDIDO,cTO_NOME,cTO_ATTN,cTO_FAX
Local cQuem
Local lRet:=.F.

Private cCourier := ""
Private lCHECK_1,cCHECK_11,cCHECK_12
Private cCHECKG12,lCHECK_2,cCHECK_21,cCHECK_22,cCHECKG22,lCHECK_3,cCHECK_31

Begin Sequence

   cPEDIDO:=AVKey(EEC->EEC_PREEMB,"EEB_PEDIDO")

   //localizar recebedor documentos
   //TO
   cTO_NOME:= RecDocImp(cPedido,OC_EM,1) // Nome 
   cTO_ATTN:= RecDocImp(cPedido,OC_EM,2) 
   cTO_FAX := RecDocImp(cPedido,OC_EM,3) 
   
   // De quem sao os dados do TO,
   // 1-Agente Rec. Documentos
   // 2-Agente Comissao
   // 3-Importador
   cQuem := RecDocImp(cPedido,OC_EM,4)
   
   //localizar agente courier
   cCOURIER:= BuscaEmpresa(cPedido,OC_EM,CD_COU)
   
   IF ! TelaGets()
      Break
   Endif
        
   //gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      Break
   Endif
   
   //regras para carregar dados
   IF lCheck_1
      cCHECK_11:="(X)"+cCHECK_11
      cCHECK_12:=cCHECK_12+cCHECKG12
      IF cQuem $ "12"  // agente
         cCHECK_12:=cCHECK_12+" TO "+EEC->EEC_IMPODE
      Endif
   Else
      cCHECK_11:=""
      cCHECK_12:=""
   Endif
   
   IF lCheck_2
      cCHECK_21:="(X)"+cCHECK_21
      cCHECK_22:=cCHECK_22+cCHECKG22
      cCHECK_23:="FOR YOURSELF "+BuscaInst(cPedido,OC_EM,BC_DIM) // Banco doctos p/ Importador
   Else
      cCHECK_21:=""
      cCHECK_22:=""
      cCHECK_23:=""
   Endif
   
   IF lCheck_3
      cCHECK_31:="(X)"+cCHECK_31
   Else
      cCHECK_31:=""
   Endif

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
   cTO_NOME     :=ALLTRIM(cTO_NOME)
   cTO_ATTN     :=ALLTRIM(cTO_ATTN)
   cTO_FAX      :=ALLTRIM(cTO_FAX)

   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C01_60:=cEXP_NOME
   AVGLTT->AVG_C02_60:=WORKID->EEA_TITULO

   //carregar detalhe
   mDETALHE:="FAC SIMILE NUMBER: "+cTO_FAX+SPACE(20)+"DATE: "+DTOC(dDATABASE)+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"TO: "+cTO_NOME+ENTER
   mDETALHE:=mDETALHE+"    AT: "+cTO_ATTN+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"FROM: "+cEXP_CONTATO+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"RE: Y/ORDER NBR: "+EEC->EEC_REFIMP+ENTER // Referencia Importador   C 40
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"    O/ORDER NBR: "+EEC->EEC_PREEMB+ENTER // Nr. Pedido        C 20
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"PLEASE FIND ATTACHED DOCUMENTS COPIES REGARDING ABOVE ORDER:"+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   IF !Empty(cCHECK_11+cCHECK_12)
      mDETALHE:=mDETALHE+cCHECK_11+ENTER
      mDETALHE:=mDETALHE+"   "+cCHECK_12+ENTER
      mDETALHE:=mDETALHE+ENTER
   Endif
   
   IF !EMPTY(cCHECK_21+cCHECK_22+cCHECK_23)
      mDETALHE:=mDETALHE+cCHECK_21+ENTER
      mDETALHE:=mDETALHE+"   "+cCHECK_22+ENTER
      mDETALHE:=mDETALHE+"   "+cCHECK_23+ENTER
      mDETALHE:=mDETALHE+ENTER
   Endif
   
   IF !EMPTY(cCHECK_31)
      mDETALHE:=mDETALHE+cCHECK_31+ENTER
      mDETALHE:=mDETALHE+ENTER
   Endif
   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"BEST REGARDS"+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"REMARKS:"+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"TOTAL NUMBER OF PAGES INCLUDING THIS COVER: 01"+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"IF YOU NOT RECEIVE ALL PAGES, PLEASE CALL US "
   mDETALHE:=mDETALHE+"PHONE "+cEXP_FONE+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO)

End Sequence   

Select(nAlias)

Return lRet

/*
    Funcao   : BANCODOC
    Autor    : Heder M Oliveira     
    Data     : 27/09/99 11:28
    Revisao  : 27/09/99 11:28
    Uso      : Retornar Banco Documentos
    Recebe   :
    Retorna  :

*/
Static FUNCTION BANCODOC
Local cBANCO

Begin Sequence
   // DOCTOS NO EXTERIOR IMPORTADOR
   cBNCRET:=BuscaInst(EEC->EEC_PREEMB,OC_EM,BC_DBR) //TIPO CLASSIFICACAO DOC NO BRASIL
   
   IF EMPTY(cBNCRET)
      cBanco  := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_BANCO")
      cBNCRET := Posicione("SA6",1,xFilial("SA6")+cBanco,"A6_NOME")
   ENDIF
End Sequence
   
RETURN(cBNCRET)

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder M. Oliveira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.
Local oDlg

Local bChange1,bChange2,oGet1,oGet2

Begin Sequence   
   
   lCHECK_1 := .F. //ORIGINAL WILL BE SENT....
   cCHECK_11:="ORIGINALS WILL BE SENT DIRECTLY BY "+AllTrim(cCOURIER)
   cCHECK_12:="NBR "
   
   cCHECKG12:=EEC->EEC_COURIE //NBR
   lCHECK_2 := .F. //COPIES WILL BE SENT....
   cCHECK_21:="COPIES WILL BE SENT THROUGH OUR "+AllTrim(BANCODOC())
   cCHECK_22:="BY "+AllTrim(cCOURIER)+" NBR "
   cCHECKG22:=EEC->EEC_COURIE //NBR
   lCHECK_3 := .F. //PART OF ORIGINAL....
   cCHECK_31:="PART OF ORIGINAL DOCUMENTS SENT TOGETHER WITH GOODS."
   
   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 200,1 TO 410,480 PIXEL
   
      @ 10,10 SAY "PLEASE FIND ATTACHED DOCUMENTS COPIES REGARDING ABOVE ORDER:" PIXEL
      
      bChange1 := {|| IF(lCheck_1,oGet1:Enable(),oGet1:Disable()) }
      
      TCheckBox():New(26,10,cCHECK_11,bSETGET(lCHECK_1),oDLG,215,10,,bChange1,oDLG:oFONT,,,,,.T.)
      @ 38,20 SAY cCHECK_12 PIXEL //SIZE 215,10 
      @ 38,35 MSGET oGet1 VAR cCHECKG12 SIZE 100,08 PIXEL  // WHEN !EMPTY(EEC->EEC_COURIE).AND.lCHECK_1
      
      bChange2 := {|| IF(lCheck_2,oGet2:Enable(),oGet2:Disable()) }
      
	  TCheckBox():New(48,10,cCHECK_21,bSETGET(lCHECK_2),oDLG,215,10,,bChange2,oDLG:oFONT,,,,,.T.)
      @ 59,20 SAY cCHECK_22 PIXEL // SIZE 215,10 
      @ 59,45 /*160*/ MSGET oGet2 VAR cCHECKG22 SIZE 70,08 PIXEL // WHEN !EMPTY(EEC->EEC_COURIE).AND.lCHECK_2
      
	  TCheckBox():New(69,10,cCHECK_31,bSETGET(lCHECK_3),oDLG,215,10,,,oDLG:oFONT,,,,,.T.)
      
      SButton():New( 83, 50,1,{||lRet:=.T.,oDLG:End()},oDLG,.T.,,)
      SButton():New( 83, 100,2,{||oDLG:End()},oDLG,.T.,,)
      
      oGet1:Disable()
      oGet2:Disable()
      
   ACTIVATE MSDIALOG oDlg CENTERED
   
End Sequence

Return lRet 
