#INCLUDE "EECPEM07.ch"

/*
Programa        : EECPEM07.PRW
Objetivo        : Impressao de Solicitacao de Paletizacao no AVGLTT.RPT
Autor           : Heder M Oliveira
Data/Hora       : 26/09/99
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM07
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder M Oliveira
Data/Hora   : 
Revisao     :
Obs.        :
*/
User Function EECPEM07

Local nAlias := Select()
Local lRet := .f.
Local cPEDIDO,cTO_NOME,cTO_ATTN,cTO_FAX
Local cEXP_NOME,cEXP_CONTATO,cEXP_FONE,cEXP_FAX     
Local cAg_Nome,x

Private mDetalhe

Begin Sequence
   
   //TO
   cPEDIDO :=AVKey(EEC->EEC_PREEMB,"EEB_PEDIDO")
   
   cTO_NOME := BuscaEmpresa(cPEDIDO,OC_EM,CD_PAL)
   cTO_ATTN := EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1) //nome do contato seq 1
   cTO_FAX  := EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",7) //fax do contato seq 1
   
   IF Empty(cTo_Nome)
      HELP(" ",1,"AVG0005044") //MsgStop("Não exite(m) Empresa(s) do tipo Paletizadora cadastrada(s) !","Atenção")
      Break
   Endif

   //gerar arquivo padrao de edicao de carta
   IF !E_AVGLTT("G")
      Break
   Endif
   
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
   
   cTO_NOME     :=ALLTRIM(cTO_NOME)
   cTO_ATTN     :=ALLTRIM(cTO_ATTN)
   cTO_FAX      :=ALLTRIM(cTO_FAX)
   
   cAg_Nome := ""

   // Verifica se o tipo de transporte ...                                                              
   x := Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1)                              
																										
   do Case                                                                                              
	  Case x == "7" // Rodoviario                                                                       
		   cTRANS_NOME:=BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA)                                                                  
      OtherWise                                                                           
		   cEMB_NOME := Posicione("EE6",1,XFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")
   End Case                                                                                             
   
   cAG_NOME := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_AGE) 
   
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C01_60:=cEXP_NOME
   AVGLTT->AVG_C02_60:=WORKID->EEA_TITULO

   //carregar detalhe
   mDETALHE:=STR0001+cTO_FAX+SPACE(20)+STR0002+DTOC(dDATABASE)+ENTER //"FAC SIMILE NUMBER: "###"DATE: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0003+cTO_NOME+ENTER //"TO  : "
   mDETALHE:=mDETALHE+STR0004+cTO_ATTN+ENTER //"ATTN: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0005+cEXP_CONTATO+ENTER //"FROM: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0006+ENTER //"TOTAL NUMBER PAGES INCLUDING THIS COVER: 1"
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0007+ENTER //"MESSAGE"
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0008+EEC->EEC_PREEMB+ENTER //"REF.: N/EXPORTACAO: "
   mDETALHE:=mDETALHE+STR0009+EEC->EEC_IMPODE+ENTER //"      CLIENTE.....: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0010+ENTER //"FAVOR PALETIZAR E PLASTIFICAR OS PRODUTOS ABAIXO RELACIONADOS:"
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0011+SPACE(35)+STR0012+SPACE(11)+STR0013+ENTER //"PRODUCT"###"QUANTITY"###"LOTE "
   
   //adiciona itens aos textos
   GravaItens()

   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   //Marcas
   PEMARCAS()
   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0014+DTOC(EEC->EEC_ETA)+ENTER //"EMBARQUE PREVISTO: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0015 //"TRANSPORTADORA / NAVIO: "
   
   IF x == "7"
      mDETALHE:=mDETALHE + cTRANS_NOME+ENTER
   ELSE 
      mDETALHE:=mDETALHE + cEMB_NOME+ENTER
   ENDIF	  
	  	  
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0016+ENTER //"OBSERVACOES:"
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+cAG_NOME+ENTER
   mDETALHE:=mDETALHE+STR0017+ENTER   //"RESERVA  NR: "
   mDETALHE:=mDETALHE+STR0018+EEC->EEC_PACKAG+ENTER  //"EMBARQUE DE: "
   mDETALHE:=mDETALHE+STR0019+EEC->EEC_CONFEC+ENTER  //"CONFECCIONAR "
   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0020+ENTER //"SAUDACOES,"
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0021+cEXP_FONE //" IF YOU NOT RECEIVE ALL PAGES, PLEASE CALL US PHONE "

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

Local cDesc,cEE9_SLDINI

Begin Sequence
   
   EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
   
   WHILE ( !EE9->(EOF()).AND.EE9->EE9_FILIAL==xFILIAL("EE9").AND.;
      EE9->EE9_PREEMB==EEC->EEC_PREEMB)
      
      cDESC :=MEMOLINE(MSMM(EE9->EE9_DESC,60,1),34,1)
      cEE9_SLDINI:=TRANSF(EE9->EE9_SLDINI,"@E 999,999,999"+IF(EEC->EEC_DECQTD==0,"","."+REPL("9",EEC->EEC_DECQTD)))
      mDETALHE   :=mDETALHE+cDESC+SPACE(35-LEN(cDESC))+cEE9_SLDINI+;
                SPACE(11-LEN(cEE9_SLDINI))+ENTER
      EE9->(DBSKIP())
   END
   
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
      mDETALHE:=mDETALHE+(IF(nCONT==1,STR0022,"        ")+MEMOLINE(cMARCAS,AVSX3("EEC_MARCAC",AV_TAMANHO),nCONT))+ENTER //"MARCAS: "
   NEXT nCONT

End Sequence
  
Return NIL
