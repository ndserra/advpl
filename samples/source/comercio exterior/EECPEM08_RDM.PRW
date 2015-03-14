#INCLUDE "EECPEM08.ch"

/*
Programa        : EECPEM08.PRW
Objetivo        : Impressao de Solicitacao de Seguro no AVGLTT.RPT
Autor           : Heder M Oliveira
Data/Hora       : 27/09/99
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM08
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder M Oliveira
Data/Hora   : 
Revisao     :
Obs.        :
*/
User Function EECPEM08

Local lRet := .f.
Local nAlias := Select()

Local cEXP_NOME
Local cPEDIDO,cTO_NOME,cTO_ATTN,cTO_FAX
Local cBancoEmissor,cTransp

Local nFobValue,cPict

//USADO NO EECF3EE3 VIA SXB "E34" PARA GET ASSINANTE
Private M->cSEEKEXF:=""
Private M->cSEEKLOJA:=""

Private cEXP_CONTATO

Begin Sequence

   //regras para carregar dados
   IF !EMPTY(EEC->EEC_EXPORT)
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1) //nome do contato seq 1
      M->cSEEKEXF  :=EEC->EEC_EXPORT
      M->cSEEKLOJA :=EEC->EEC_EXLOJA
   ELSE
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME") 
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1)  //nome do contato seq 1
      M->cSEEKEXF  :=EEC->EEC_FORN
      M->cSEEKLOJA :=EEC->EEC_FOLOJA
   ENDIF

   cEXP_NOME    :=ALLTRIM(cEXP_NOME)
   cEXP_CONTATO :=ALLTRIM(cEXP_CONTATO)
   
   IF ! TelaGets()
      Break
   Endif
   
   //TO
   cPEDIDO :=AVKey(EEC->EEC_PREEMB,"EEB_PEDIDO")
   cTO_NOME:=BuscaEmpresa(cPedido,OC_EM,CD_SEG) // Seguradora
   cTO_ATTN:=""
   cTO_FAX :=""
   
   IF !EEB->(Eof())
      cTO_ATTN:=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1) //nome do contato seq 1
      cTO_FAX :=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",7) //fax do contato seq 1
   Endif
      
   IF Empty(cTO_NOME)
      HELP(" ",1,"AVG0005045") //MsgStop("Não existe(m) empresa(s) do tipo Seguradora cadastrada(s) !","Aviso")
      Break
   Endif
   
   //gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      Break
   Endif
   
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C01_60:=cEXP_NOME
   AVGLTT->AVG_C02_60:=WORKID->EEA_TITULO

   mDETALHE:="RE..: CREDIT NBR.......: "+EEC->EEC_LC_NUM+ENTER
   
   cBancoEmissor := Posicione("EEL",1,xFilial("EEL")+EEC->EEC_LC_NUM,"EEL_BCOEM")
   cBancoEmissor := cBancoEmissor+Posicione("EEL",1,xFilial("EEL")+EEC->EEC_LC_NUM,"EEL_AGCEM")
   
   mDETALHE:=mDETALHE+"      ISSUANCE BANK....: "+Posicione("SA6",1,xFilial("SA6")+cBancoEmissor,"A6_NOME")+ENTER
   mDETALHE:=mDETALHE+"      CUSTOMER NAME....: "+EEC->EEC_IMPODE+ENTER   
   mDETALHE:=mDETALHE+"      REFERENCE........: "+EEC->EEC_PREEMB+ENTER   
   mDETALHE:=mDETALHE+"      IMPORT LICENSE NR: "+EEC->EEC_LICIMP+ENTER   
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+"TO..: "+ENTER// cTO_NOME+ENTER
   mDETALHE:=mDETALHE+"ATTN: "+ENTER// cTO_ATTN+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"AS PER L/C'S REQUEST UNDER MENTIONED YOU CAN FIND DETAILS FOR "
   mDETALHE:=mDETALHE+"INSURANCE PURPOSE:"+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   // Verifica se o tipo de transporte eh rodoviario
   IF Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1) == "7"
      mDETALHE:=mDETALHE+"SHIPMENT SCHEDULE HAD BEEN DONE AS FOLLOWS:"+ENTER
      mDETALHE:=mDETALHE+ENTER

      cTransp := BuscaEmpresa(cPEDIDO,OC_EM,CD_TRA)
      
      mDETALHE:=mDETALHE+PADR("TRUCKER",21,".")+cTRANSP+ENTER
   Else
      //cAGEMB := BuscaEmpresa(cPedido,OC_EM,CD_AGE) // Agente Embarcador
      
      mDETALHE:=mDETALHE+Padr("VESSEL NAME",23,".")+": "+Posicione("EE6",1,XFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")+ENTER
   Endif   
   
   mDETALHE:=mDETALHE+Padr("ETS "+AllTrim(Posicione("SY9",2,XFILIAL("SY9")+EEC->EEC_ORIGEM,"Y9_DESCR")),23,".")+": "+DTOC(EEC->EEC_ETD)+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   //adiciona itens aos textos
   GravaItens()

   mDETALHE:=mDETALHE+ENTER
   
   IF (EEC->EEC_DECPES==0)
      cPict := "@E 999,999,999"
   ELSE   
      cPict := "@E 999,999,999."+Repl("9",EEC->EEC_DECPES)
   ENDIF

   mDETALHE:=mDETALHE+"PACKAGE................: "+EEC->EEC_PACKAG+ENTER
   mDETALHE:=mDETALHE+"NET WEIGHT KGS.........: "+TRANSF(EEC->EEC_PESLIQ,AVSX3("EEC_PESLIQ",6))+ENTER
   mDETALHE:=mDETALHE+"GROSS WEIGHT KGS.......: "+TRANSF(EEC->EEC_PESBRU,AVSX3("EEC_PESBRU",6))+ENTER
   mDETALHE:=mDETALHE+"MEASUREMENTS...........: "+Transf(EEC->EEC_CUBAGE,cPict)+ENTER//AVSX3("EEC_CUBAGE",6))+ENTER
   mDETALHE:=mDETALHE+"PORT OF DESTINATION....: "+Posicione("SY9",2,XFILIAL("SY9")+EEC->EEC_DEST,"Y9_DESCR")+ENTER
   
   //Marcas
   PEMARCAS()
   
   nFobValue := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
   
   cPict := AVSX3("EEC_TOTPED",AV_PICTURE)//"@E 999,999,999"+IF(EEC->EEC_DECPRC==0,"","."+."+Repl("9",EEC->EEC_DECPRC))
   
   mDETALHE:=mDETALHE+"FOB VALUE..............: "+Transf(nFobValue,cPict)+ENTER
   mDETALHE:=mDETALHE+"FREIGHT................: "+Transf(EEC->EEC_FRPREV,cPict)+ENTER
   mDETALHE:=mDETALHE+"INSURANCE..............: "+Transf(EEC->EEC_SEGPRE,cPict)+ENTER
   mDETALHE:=mDETALHE+"OTHERS.................: "+Transf(EEC->EEC_FRPCOM+EEC->EEC_DESPIN-EEC->EEC_DESCON+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"),cPict)+ENTER
   mDETALHE:=mDETALHE+"TOTAL..................: "+Transf(EEC->EEC_TOTPED,cPict)+ENTER
   mDETALHE:=mDETALHE+"OUR ORDER NBR..........: "+EEC->EEC_PREEMB+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"YOURS FAITHFULLY"+ENTER
   mDETALHE:=mDETALHE+cEXP_CONTATO+ENTER
     
     //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRET:=E_AVGLTT("M",WORKID->EEA_TITULO)
   
End Sequence

Select(nAlias)

Return lRet

/*
Funcao      : GravaItens
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder M Oliveira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function GravaItens

Local cMemo,cEE9_DESC,cEE9_SLDINI
Local nTot,i

Begin Sequence   

   mDETALHE:=mDETALHE+Padr("PRODUCT",61)+"QUANTITY"+ENTER

   EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
   
   WHILE (!EE9->(EOF()).AND.EE9->EE9_FILIAL==xFILIAL("EE9").AND.;
           EE9->EE9_PREEMB==EEC->EEC_PREEMB)
      
      cMemo      := MSMM(EE9->EE9_DESC)
      cEE9_DESC  := MEMOLINE(cMemo,50,1)
      cEE9_SLDINI:= TRANSF(EE9->EE9_SLDINI,"@E 999,999,999"+IF(EEC->EEC_DECQTD==0,"","."+Replicate("9",EEC->EEC_DECQTD)))
      mDETALHE   := mDETALHE+cEE9_DESC+SPACE(54-LEN(cEE9_DESC))+cEE9_SLDINI+;
                SPACE(11-LEN(cEE9_SLDINI))+ENTER
      
      nTot := MlCount(cMemo,50)
      
      For i:=2 to nTot
         mDETALHE:=mDETALHE+MemoLine(cMemo,50,i)+ENTER
      Next
      
      EE9->(DBSKIP())
   ENDDO
End Sequence

Return NIL

/*
Funcao      : PEMARCAS
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder M Oliveira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function PEMARCAS

Local cMarcas, nCont

Begin Sequence
   cMARCAS:=EEC->(MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO)))
   
   FOR nCONT:=1 TO MLCOUNT(cMARCAS,AVSX3("EEC_MARCAC",AV_TAMANHO))
      mDETALHE:=mDETALHE+(IF(nCONT==1,"MARKS..................: ",SPACE(25))+MEMOLINE(cMARCAS,AVSX3("EEC_MARCAC",AV_TAMANHO),nCONT))+ENTER
   NEXT nCONT
End Sequence

Return NIL

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder M Oliveira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.
Local bOk, bCancel
Local oDlg

Private M->cCONTATO := IncSpace(cEXP_CONTATO,60,.F.)

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 09,0 TO 15,70 OF oMainWnd
    
      @ 26,5  SAY STR0001 PIXEL //"Assinante"
      @ 26,38 MSGET M->cCONTATO SIZE 200,08 F3 "E34" PIXEL
   
      bOk     := {||lRet := .t.,oDlg:End()}
      bCancel := {||oDlg:End()}

   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
   
End Sequence

cEXP_CONTATO:=M->cCONTATO

Return lRet
   
