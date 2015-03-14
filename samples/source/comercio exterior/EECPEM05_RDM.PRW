#INCLUDE "EECPEM05.ch"

/*
Programa        : EECPEM05.PRW
Objetivo        : Impressao da Confirmacao de Inspecao
Autor           : Cristiano A. Ferreira
Data/Hora       : 25/09/1999 10:00
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM05
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 25/09/1999 10:00
Revisao     :
Obs.        :
*/
User Function EECPEM05

Local lRet := .T.
Local nAlias := Select()

Local cEXP_NOME,cEXP_CONTATO,cEXP_FONE,cEXP_FAX
Local cPEDIDO,cTO_NOME,cTO_ATTN,cTO_FAX
  
Begin Sequence

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

   //TO
   cPEDIDO :=AVKey(EEC->EEC_PREEMB,"EEB_PEDIDO")
   cTO_NOME:=""
   cTO_ATTN:=""
   cTO_FAX :=""
   
   IF EEB->(dbSeek(xFilial("EEB")+cPEDIDO+OC_EM))
      While EEB->(!Eof() .And. EEB_FILIAL == xFilial("EEB") .AND.;
                   EEB_PEDIDO==cPEDIDO .AND. EEB->EEB_OCORRE == OC_EM)
         IF Left(EEB->EEB_TIPOAG,1) == CD_INS // Inspetora
            cTO_NOME:=EEB->EEB_NOME
            cTO_ATTN:=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1) //nome do contato seq 1
            cTO_FAX :=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",7) //fax do contato seq 1
            Exit
         Endif
         EEB->(dbSkip())
      Enddo
   ENDIF
            
   cEXP_NOME    :=ALLTRIM(cEXP_NOME)
   cEXP_CONTATO :=ALLTRIM(cEXP_CONTATO)
   cEXP_FONE    :=ALLTRIM(cEXP_FONE)
   cEXP_FAX     :=ALLTRIM(cEXP_FAX)
   
   cTO_NOME     :=ALLTRIM(cTO_NOME)
   cTO_ATTN     :=ALLTRIM(cTO_ATTN)
   cTO_FAX      :=ALLTRIM(cTO_FAX)
   
   IF Empty(cTo_Nome)
      HELP(" ",1,"AVG0005043") //MsgStop("Não exite(m) Empresa(s) do tipo Inspetora cadastrada(s) !","Atenção")
      lRet := .F.
      Break
   Endif
   
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
   mDETALHE:=STR0001+cTO_FAX+SPACE(20)+STR0002+DTOC(dDATABASE)+ENTER //"FAC SIMILE NUMBER: "###"DATE: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0003+cTO_NOME+ENTER //"TO..: "
   mDETALHE:=mDETALHE+STR0004+cTO_ATTN+SPACE(20)+STR0005+EEC->EEC_NRINSP+ENTER //"ATTN: "###"REF. INSPECAO: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0006+cEXP_CONTATO+ENTER //"FROM: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0007+EEC->EEC_NRINVO+ENTER //"SEGUE ANEXO COPIA DOS DOCUMENTOS REFERENTE EMBARQUE DE N/FAT. "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0008+EEC->EEC_NRINVO+ENTER //"FATURA NR.   "
   mDETALHE:=mDETALHE+STR0009+EEC->EEC_NRINVO+ENTER //"PACKING LIST "
   mDETALHE:=mDETALHE+STR0010+EEC->EEC_NRCONH+ENTER //"B/L "
   mDETALHE:=mDETALHE+STR0011+ENTER //"CERTIFICADO ANALISE"
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0012+ENTER+ENTER+ENTER //"FAVOR PROVIDENCIAR CERTIFICADO DE INSPECAO"
   mDETALHE:=mDETALHE+STR0013+ENTER+ENTER //"SAUDACOES"
   mDETALHE:=mDETALHE+STR0014+cEXP_FAX+ENTER+ENTER //"NOSSO FAX NR "
   mDETALHE:=mDETALHE+STR0015 //"IF YOU NOT RECEIVE ALL PAGES, PLEASE CALL US "
   mDETALHE:=mDETALHE+STR0016+cEXP_FONE //"PHONE "
     
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO)

End Sequence   

Select(nAlias)

Return lRet

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM05.PRW                                                 *
*------------------------------------------------------------------------------*
