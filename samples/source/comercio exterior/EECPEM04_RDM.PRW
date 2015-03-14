#INCLUDE "EECPEM04.ch"


/*
Programa        : EECPEM04.PRW
Objetivo        : Solicitacao de Inspecao
Autor           : Cristiano A. Ferreira
Data/Hora       : 25/09/1999 10:00
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM04
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 25/09/1999 10:00
Revisao     :
Obs.        :
*/
User Function EECPEM04

Local lRet := .t.
Local nAlias := Select()
Local aOrd := SaveOrd({"EEC","EEB","EE9","SA2"})

Local nTipo,cEmpr1,cEmpr2,cEmpr3 
Local cLocal1,cLocal2,cLocal3
Local cContato := ""
Local x,x1,lCopia,cTocc

Local cPEDIDO,cTO_NOME,cTO_ATTN,cTO_FAX
Local cEXP_NOME,cEXP_CONTATO,cEXP_FONE,cEXP_FAX
Local cCliente

Private mDetalhe

Begin Sequence

   cPEDIDO:=AVKey(EEC->EEC_PREEMB,"EEB_PEDIDO")
 
   cTO_NOME:=BuscaEmpresa(cPedido,OC_EM,CD_INS) // Inspetora
   cTO_ATTN:=""
   cTO_FAX :=""
   
   IF ! EEB->(Eof())
      cTO_ATTN:=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1) //nome do contato seq 1
      cTO_FAX :=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",7) //fax do contato seq 1
   Endif
   
   IF Empty(cTo_Nome)
      HELP(" ",1,"AVG0005043") //MsgStop("Não exite(m) Empresa(s) do tipo Inspetora cadastrada(s) !","Atenção")
      lRet := .f.
      Break
   Endif
   
   // Local de Inspecao   
   IF ! Pergunte("PEM040",.T.)
      lRet := .F.
      Break
   Endif
   
   // Variaveis definidas na Pergunte
   // nTipo    := 1-Fabricante
   //             2-Empresa
   // cEmpr1  := Empresa1
   // cEmpr2  := Empresa2
   // cEmpr3  := Empresa3
   nTipo    := mv_par01
   cEmpr1 := mv_par02
   cEmpr2 := mv_par03
   cEmpr3 := mv_par04
   
   IF nTipo == 1 // Fabricante
      EE9->(dbSetOrder(3))
      EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
      cLocal1 := Posicione("SA2",1,xFilial("SA2")+EE9->EE9_FABR+EE9->EE9_FALOJA,"A2_NOME")
      cLocal2 := EECMEnd("SA2",1,EE9->EE9_FABR+EE9->EE9_FALOJA,.T.,60,1)
      cLocal3 := EECMEnd("SA2",1,EE9->EE9_FABR+EE9->EE9_FALOJA,.T.,60,2)
      cContato := EECCONTATO(CD_SA2,EE9->EE9_FABR,EE9->EE9_FALOJA,"1",1)
      cFone    := EECCONTATO(CD_SA2,EE9->EE9_FABR,EE9->EE9_FALOJA,"1",4) 
      cContato := ALLTRIM(cContato)+STR0001+cFone //" - FONE: "
   Else
      cPedido := EEC->EEC_PREEMB
      cLocal1 := ""
      cLocal2 := ""
      cLocal3 := ""
      cContato:= ""
      cFone   := ""
                                          
      EEB->(dbSetOrder(1))
      IF EEB->(dbSeek(xFilial("EEB")+cPEDIDO+OC_EM))
         While EEB->(!Eof() .And. EEB_FILIAL == xFilial("EEB") .AND.;
               EEB_PEDIDO==cPEDIDO .AND. EEB->EEB_OCORRE == OC_EM)
            IF Left(EEB->EEB_TIPOAG,1) == CD_PAL // Paletizadora
               cLocal1  := EEB->EEB_NOME
               cLocal2  := EECMEnd("SY5",1,EEB->EEB_CODAGE,.T.,60,1)
               cLocal3  := EECMEnd("SY5",1,EEB->EEB_CODAGE,.T.,60,2)
               cContato := EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1)
               cFone    := EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",4)
               cContato := ALLTRIM(cContato)+STR0001+cFone   //" - FONE: "
               Exit
            Endif
            EEB->(dbSkip())
         Enddo
      Endif
   Endif
   
   cTOcc := STR0002 //"CC  : "
   lCopia := .F.
   
   IF !Empty(cEmpr1)
      lCopia := .T.
      x1:=""
      x := Posicione("EEB",1,xFilial("EEB")+EEC->EEC_PREEMB+OC_EM+cEmpr1,"EEB_NOME")  ///Posicione("SY5",1,XFILIAL("SY5")+cEmpr1,"Y5_NOME")
      IF !Empty(x)
         x1:=x1+AllTrim(x)+ENTER
      Endif
      x := EECCONTATO(CD_SY5,cEmpr1,,"1",1)
      IF !Empty(x)
         x1:=x1+STR0003+AllTrim(x)+ENTER //"      AT: "
      Endif
      x := EECCONTATO(CD_SY5,cEmpr1,,"1",7)
      IF !Empty(x)
         x1:=x1+STR0004+AllTrim(x) //"      FAX: "
      Endif
      IF !Empty(x1)
         cTOcc:=cTOcc+x1+ENTER+Space(6)
      Endif
   Endif
      
   IF !Empty(cEmpr2)
      lCopia := .T.
      x1:=""
      x := Posicione("EEB",1,xFilial("EEB")+EEC->EEC_PREEMB+OC_EM+cEmpr2,"EEB_NOME")
      // Posicione("SY5",1,XFILIAL("SY5")+cEmpr2,"Y5_NOME")
      IF !Empty(x)
         x1:=x1+AllTrim(x)+ENTER
      Endif
      x := EECCONTATO(CD_SY5,cEmpr2,,"1",1)
      IF !Empty(x)
         x1:=x1+STR0003+AllTrim(x)+ENTER //"      AT: "
      Endif
      x := EECCONTATO(CD_SY5,cEmpr2,,"1",7)
      IF !Empty(x)
         x1:=x1+STR0004+AllTrim(x) //"      FAX: "
      Endif
      IF !Empty(x1)
         cTOcc:=cTOcc+x1+ENTER+Space(6)
      Endif
   Endif
      
   IF !Empty(cEmpr3)
      lCopia := .T.
      x1:=""
      x := Posicione("EEB",1,xFilial("EEB")+EEC->EEC_PREEMB+OC_EM+cEmpr3,"EEB_NOME")
      //Posicione("SY5",1,XFILIAL("SY5")+cEmpr3,"Y5_NOME")
      IF !Empty(x)
         x1:=x1+AllTrim(x)+ENTER
      Endif
      x := EECCONTATO(CD_SY5,cEmpr3,,"1",1)
      IF !Empty(x)
         x1:=x1+STR0003+AllTrim(x)+ENTER //"      AT: "
      Endif   
      x := EECCONTATO(CD_SY5,cEmpr3,,"1",7)
      IF !Empty(x)
         x1:=x1+STR0004+AllTrim(x) //"      FAX: "
      Endif
      IF !Empty(x1)
         cTOcc:=cTOcc+x1+ENTER+Space(6)
      Endif
   Endif
   
   IF ! lCopia
      cTOcc := ""
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
        
   //TO
   cEXP_NOME    :=ALLTRIM(cEXP_NOME)
   cEXP_CONTATO :=ALLTRIM(cEXP_CONTATO)
   cEXP_FONE    :=ALLTRIM(cEXP_FONE)
   cEXP_FAX     :=ALLTRIM(cEXP_FAX)
   
   cTO_NOME     :=ALLTRIM(cTO_NOME)
   cTO_ATTN     :=ALLTRIM(cTO_ATTN)
   cTO_FAX      :=ALLTRIM(cTO_FAX)
   
        
   // Carrega dados do Cliente
   cCliente := ""
   
   IF !Empty(EEC->EEC_CLIENT)
      cCliente := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_CLIENT+EEC->EEC_CLLOJA,"A1_NOME")
   Else
      cCliente := EEC->EEC_IMPODE
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
   mDETALHE:=STR0005+cTO_FAX+SPACE(20)+STR0006+DTOC(dDATABASE)+ENTER //"FAC SIMILE NUMBER: "###"DATE: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0007+cTO_NOME+ENTER //"TO  : "
   mDETALHE:=mDETALHE+STR0008+cTO_ATTN+ENTER //"ATTN: "
   mDETALHE:=mDETALHE+ENTER
   
   IF !EMPTY(cTOcc)
      mDETALHE:=mDETALHE+cTOcc+ENTER
   ENDIF
   
   mDETALHE:=mDETALHE+STR0009+cEXP_CONTATO+ENTER //"FROM: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0010+ENTER //"SOLICITAMOS PROVIDENCIAR INSPECAO NA MERCADORIA ABAIXO:"
   mDETALHE:=mDETALHE+STR0011+EEC->EEC_NRINSP+ENTER //"REF. INSPECAO NR "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0012+cCliente+ENTER //"1) CLIENTE............: "
   mDETALHE:=mDETALHE+STR0013+Posicione("SY9",2,xFilial("SY9")+EEC->EEC_ORIGEM,"Y9_DESCR")+ENTER //"2) PORTO DE EMBARQUE..: "
   mDETALHE:=mDETALHE+STR0014+Posicione("SY9",2,xFilial("SY9")+EEC->EEC_DEST,"Y9_DESCR")+ENTER //"3) DESTINO............: "
   mDETALHE:=mDETALHE+STR0015 //"4) PRODUTO............: "
   
   GravaItens()
   
   mDETALHE:=mDETALHE+STR0016+TRANSF(EEC->EEC_PESLIQ,AVSX3("EEC_PESLIQ",6))+ENTER //"5) P.LIQUIDO..........: "
   mDETALHE:=mDETALHE+STR0017+TRANSF(EEC->EEC_PESBRU,AVSX3("EEC_PESBRU",6))+ENTER //"   P. BRUTO...........: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0018+EEC->EEC_PACKAG+ENTER //"6) EMBALAGEM..........: "
   
   // Verifica se o tipo de transporte ...
   x := Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1)
   
   do Case
      Case x == "7" // Rodoviario
         mDETALHE:=mDETALHE+STR0019+ENTER //"7) RODOVIARIO.........: "
      Case x == "4" // Maritimo   
         mDETALHE:=mDETALHE+STR0020+EEC->EEC_MAWB+ENTER  //"7) AIRFREIGHT.........: "
   OtherWise // Navio
      mDETALHE:=mDETALHE+STR0021+Posicione("EE6",1,XFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")+ENTER //"7) NAVIO..............: "
   End Case
   
   mDETALHE:=mDETALHE+STR0022+DTOC(EEC->EEC_ETA)+ENTER //"8) DATA EMBARQUE......: "
   mDETALHE:=mDETALHE+STR0023+cLocal1+ENTER //"9) LOCAL..............: "
   mDETALHE:=mDETALHE+"                        "+cLocal2+ENTER
   mDETALHE:=mDETALHE+"                        "+cLocal3+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0024+cContato+ENTER //"10) CONTATO...........: "
   mDETALHE:=mDETALHE+STR0025+DTOC(EEC->EEC_DTINSP)+ENTER //"11) DATA PARA INSPECAO: "
   mDETALHE:=mDETALHE+STR0026+ENTER //"OBS. .................: ANEXO COPIA FATURA E PACKING LIST"
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0027+EEC->EEC_PREEMB+ENTER //"NOSSA REFERENCIA......: "
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0028+ENTER //"ESTAMOS A SUA INTEIRA DISPOSICAO PARA QUAISQUER ESCLARECIMENTOS QUE"
   mDETALHE:=mDETALHE+STR0029+ENTER //"VENHAM A SER NECESSARIOS."
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0030+ENTER //"SAUDACOES"
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0031+cEXP_FAX+ENTER+ENTER //"NOSSO FAX NR "
   mDETALHE:=mDETALHE+STR0032 //"IF YOU NOT RECEIVE ALL PAGES, PLEASE CALL US "
   mDETALHE:=mDETALHE+STR0033+cEXP_FONE //"PHONE "
     
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
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 25/09/1999 10:00
Revisao     :
Obs.        :
*/
Static Function GravaItens

Local nMARGEM := 0
Local cMemo,nTot,i

Begin Sequence

   // Alterado por Heder M Oliveira - 1/10/2000
   EE9->(dbSetOrder(2))
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))

   While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB
      
      cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
      
      mDETALHE:=mDETALHE+SPACE(nMARGEM)+MemoLine(cMemo,AVSX3("EE9_VM_DES",3),1)+ENTER
      nMARGEM :=24
      nTot := MlCount(cMemo,AVSX3("EE9_VM_DES",3))
      
      For i := 2 To nTot
         mDETALHE:=mDETALHE+Space(nMARGEM)+MemoLine(cMemo,AVSX3("EE9_VM_DES",3),i)+ENTER
      Next
      
      EE9->(dbSkip())
   Enddo

   mDETALHE:=mDETALHE+ENTER
   
End Sequence

Return NIL
          
*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM04.PRW                                                 *
*------------------------------------------------------------------------------*
