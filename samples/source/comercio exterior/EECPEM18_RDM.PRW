#INCLUDE "EECPEM18.ch"

/*
Programa        : EECPEM18.PRW
Objetivo        : REQUISICAO DE MEMORANDO DE EXPORTACAO
Autor           : Flavio Yuji Arakaki
Data/Hora       : 15/10/1999 09:20
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM18
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Flavio Yuji Arakaki
Data/Hora   : 15/10/1999 09:20
Revisao     :
Obs.        :
*/
User Function EECPEM18

Local lRet := .T.
Local nAlias := Select()
Local aOrd   := SaveOrd({"EEC","EE9","SA2","SYR","SY9"})

Local cEXP_NOME    := SPACE(AVSX3("A2_NOME",3))  
Local cEXP_CODP    := SPACE(AVSX3("A2_PAIS",3))
Local cEXP_CONTATO := SPACE(35)
Local cEXP_FONE    := SPACE(30)
Local cEXP_FAX     := SPACE(30)
Local cEXP_PAIS    := SPACE(AVSX3("YA_DESCR",3))

Local cDE_CONTATO := SPACE(35) 
Local cDE_FONE    := SPACE(30)
Local cDE_FAX     := SPACE(30)

Local cPAIS_DES,cPOSIPI,mDETALHE // ,aQtdIten    // By JPP - 22/12/04 13:00 
Local mProd,nLProd,nLAtu 
Local cPicture

// ** Valida a fase do documento...
If !ValidFaseDoc(VD_EMB)
   Return .F.
EndIf

Begin Sequence

   SA2->(DBSETORDER(1)) 
   SYR->(DBSETORDER(1))                                               
   
   //regras para carregar dados 
   IF !EMPTY(EEC->EEC_EXPORT) .AND. ;                                                                                    
      SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))                                                      
      cEXP_NOME    :=SA2->A2_NOME
      cEXP_CODP    :=SA2->A2_PAIS
      cEXP_FAX     :=SA2->A2_TEL
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1)  //nome do contato seq 1      
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4)  //fone do contato seq 1      
   ELSE
      HELP(" ",1,"AVG0005052") //MSGINFO("Exportador não cadastrado.","Aviso")
      lRet := .F.
      Break
   ENDIF                                                                                                                 
      
   cEXP_PAIS   := Posicione("SYA",1,xFilial("SYA")+cEXP_CODP,"YA_DESCR")          
   
   IF !EMPTY(EEC->EEC_RESPON)
      cDE_CONTATO := EEC->EEC_RESPON
      cDE_FONE    := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)
      cDE_FAX     := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)
   ELSE     
      IF !EMPTY(EEC->EEC_FORN)
         cDE_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1)  //nome do contato seq 1                
         cDE_FONE    := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4)  //fone do contato seq 1 
         cDE_FAX     := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7)  //fax do contato seq 1  
      ENDIF  
   ENDIF                                                                                         
         
   SY9->(DBSETORDER(2))                                                    
   SY9->(DBSEEK(xFILIAL("SY9")+EEC->EEC_DEST))                             
   cPAIS_DES := Posicione("SYA",1,xFilial("SYA")+SY9->Y9_PAIS,"YA_NOIDIOM")
   
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
   mDETALHE:="FAC SIMILE NUMBER: "+TRIM(cEXP_FAX)+SPACE(01)+"DATE: "+DTOC(dDATABASE)+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"TO:        "+cEXP_CONTATO+ENTER
   mDETALHE:=mDETALHE+"COMPANY:   "+cEXP_NOME+ENTER
   mDETALHE:=mDETALHE+"COUNTRY:   "+cEXP_PAIS+ENTER 
   mDETALHE:=mDETALHE+"PHONE NR.: "+cEXP_FONE+ENTER 
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+"FROM:      "+cDE_CONTATO+ENTER
   mDETALHE:=mDETALHE+"PHONE NR.  "+cDE_FONE+ENTER
   mDETALHE:=mDETALHE+"FAX   NR.  "+cDE_FAX+ENTER
   mDETALHE:=mDETALHE+ENTER
  
   mDETALHE:=mDETALHE+"NR. OF PAGES INCLUDING THIS ONE: 1"+ENTER 
   
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+STR0001+EEC->EEC_REFIMP+ENTER //"S/PEDIDO DE COMPRA         "
   
   EE9->(DBSETORDER(4))                                                                                                                                                               
   EE9->(DBSEEK(xFILIAL()+EEC->EEC_PREEMB))                                                                                                                                           
   cPOSIPI := EE9->EE9_POSIPI
   mProd := Posicione("SYD",1,xFilial("SYD")+EE9->EE9_POSIPI,"YD_DESC_P")
   
   // mDETALHE := mDETALHE + STR0002+mProd+ENTER //"PRODUTO                    "     // By JPP - 22/12/04 13:00 - Alteração do Programa para exibir as quantidades e unidades na mesma linha que a descrição do produto. 
   mDETALHE := mDETALHE + Space(28)+mProd+ENTER
   mDETALHE := mDETALHE + STR0003 +ENTER     // By JPP - 22/12/04 13:00 
                     
   // aQtdIten:= {}  // By JPP - 22/12/04 13:00 
   // AADD(aQtdIten,{EE9->EE9_SLDINI,EE9->EE9_UNIDAD})    //  By JPP - 22/12/04 13:00 
                                                                                                                                                                                      
   WHILE EE9->(!EOF()) .AND. xFILIAL("EE9")==EE9->EE9_FILIAL .AND. EEC->EEC_PREEMB==EE9->EE9_PREEMB
      
      IF cPOSIPI # EE9->EE9_POSIPI
         
         cPOSIPI:=EE9->EE9_POSIPI                                                                                                                                                     
         mProd   := Posicione("SYD",1,xFilial("SYD")+EE9->EE9_POSIPI,"YD_DESC_P")
         mDETALHE:= mDETALHE+ENTER 
         mDETALHE := mDETALHE + Space(28)+ mProd + ENTER                           // By JPP - 22/12/04 13:00 
         mDETALHE := mDETALHE + STR0003 +ENTER     
         // mDETALHE:= mDETALHE + "                           "+mProd+ENTER   
         // AADD(aQtdIten,{EE9->EE9_SLDINI,EE9->EE9_UNIDAD})   
      ENDIF                                                                                                                                                                           
      
      mProd :=MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",AV_TAMANHO))                                                                                                                         
      nLProd := MLCOUNT(mProd,AVSX3("EE9_VM_DES",AV_TAMANHO))                                                                                                                                    
      nLAtu := 0
                                                                                                                                                                            
      cPicture := "@E 999,999,999"+IF(EEC->EEC_DECQTD==0,"","."+REPL("9",EEC->EEC_DECQTD))      // By JPP - 22/12/04 13:00 - Alteração do Programa para exibir as quantidades e unidades na mesma linha que a descrição do produto.
      FOR nLAtu := 1 to nLProd 
          If nLAtu == 1             // By JPP - 22/12/04 13:00
             mDETALHE := mDETALHE +Space(19-(len(cPicture)-3)) +TRANSFORM(EE9->EE9_SLDINI,cPicture)+Space(1)+;
                         EE9->EE9_UNIDAD+Space(6)+MEMOLINE(mProd,AVSX3("EE9_VM_DES",3),nLAtu)+ENTER  
          Else
             mDetalhe := mDETALHE +Space(28)+MEMOLINE(mProd,AVSX3("EE9_VM_DES",3),nLAtu)+ENTER               
          EndIf                                                                                                                                                   
          //  mDetalhe := mDETALHE +"                           "+MEMOLINE(mProd,AVSX3("EE9_VM_DES",3),nLAtu)+ENTER    //  By JPP - 22/12/04 13:00     
      NEXT                   
      
      EE9->(DBSKIP())                                                                                                                                                                 
   
   ENDDO                                                                                                                                                                              

   EE9->(DBSEEK(xFILIAL()+EEC->EEC_PREEMB))                                                                                                
                                                                                                                                           
   // nLProd:=LEN(aQtdIten)         // By JPP - 22/12/04 13:00
   
   // FOR nLAtu := 1 TO nLProd
   //     IF nLAtu == 1
   //        mDETALHE := mDETALHE + STR0003+ TRANSFORM(aQtdIten[nLAtu,1],"@E 999,999,999"+IF(EEC->EEC_DECQTD==0,"","."+REPL("9",EEC->EEC_DECQTD)))+" "+aQtdIten[nLAtu,2]+ENTER //"QUANTIDADE                 "
   //     ELSE
   //        mDETALHE := mDETALHE + "                           "+ TRANSFORM(aQtdIten[nLAtu,1],"@E 999,999,999"+IF(EEC->EEC_DECQTD==0,"","."+REPL("9",EEC->EEC_DECQTD)))+" "+aQtdIten[nLAtu,2]+ENTER
   //     ENDIF                                                                                                                             
   // NEXT
   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+             STR0004+cPAIS_DES+ENTER //"DESTINO                    "
   
   mDETALHE:=mDETALHE+             STR0005+EEC->EEC_PREEMB+ENTER //"N/REFERENCIA               "
    
   mDETALHE:=mDETALHE+ENTER+ENTER
   
   mDETALHE:=mDETALHE+STR0006+ENTER //"PARA QUE POSSAMOS ATENDER OS REQUESITOS JUNTO AOS  ORGAOS  COMPETENTES  NO  QUE  SE"
   mDETALHE:=mDETALHE+STR0007+ENTER //"REFERE A SUSPENSAO DO IPI E NAO INCIDENCIA DO ICMS DO FATURAMENTO EFETUADO A V.SAS."
   mDETALHE:=mDETALHE+STR0008+ENTER                 //"PARA POSTERIOR EXPORTACAO, NECESSITAMOS QUE NOS SEJA ENVIADO OPORTUNAMENTE OS DOCU-"
   mDETALHE:=mDETALHE+STR0009+ENTER //"MENTOS ABAIXOS MENCIONADOS:"
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+STR0010+ENTER //"1) MEMORANDO DE EXPORTACAO EM 1 VIA ORIGINAL, QUE DEVERA CONTER OS SEGUINTES DADOS:"
   mDETALHE:=mDETALHE+STR0011+ENTER //"   # O NUMERO DE ORDEM E O NUMERO DE VIAS;"
   mDETALHE:=mDETALHE+STR0012+ENTER //"   # A DATA DE EMISSAO;"
   mDETALHE:=mDETALHE+STR0013+ENTER //"   # NOME, ENDERECO E OS NUMEROS DE INSCRICAO ESTADUAL E CNPJ DO ESTABELECIMENTO"
   mDETALHE:=mDETALHE+STR0014+ENTER //"     EMITENTE;"
   mDETALHE:=mDETALHE+STR0013+ENTER  //"   # NOME, ENDERECO E OS NUMEROS DE INSCRICAO ESTADUAL E CNPJ DO ESTABELECIMENTO"
   mDETALHE:=mDETALHE+STR0015+ENTER //"     REMETENTE DA MERCADORIA;"
   mDETALHE:=mDETALHE+STR0016+ENTER //"   # NUMERO, SERIE E DATA DA NOTA FISCAL DO ESTABELECIMENTO REMETENTE E DO"
   mDETALHE:=mDETALHE+STR0017+ENTER //"     DESTINATARIO - EXPORTADOR DA MERCADORIA;"
   mDETALHE:=mDETALHE+STR0018+ENTER //"   # NUMERO DO DESPACHO DE EXPORTACAO, A DATA DE SEU ATO FINAL E O NUMERO DO"
   mDETALHE:=mDETALHE+STR0019+ENTER //"     REGISTRO DE EXPORTACAO;"
   mDETALHE:=mDETALHE+STR0020+ENTER //"   # O NUMERO E A DATA DO CONHECIMENTO DE EMBARQUE;"
   mDETALHE:=mDETALHE+STR0021+ENTER //"   # A DESCRICAO E QUANTIDADE DA MERCADORIA EXPORTADA;"
   mDETALHE:=mDETALHE+STR0022+ENTER  //"   # O PAIS DE DESTINO DA MERCADORIA;"
   mDETALHE:=mDETALHE+STR0023+ENTER  //"   # A DATA;"
   mDETALHE:=mDETALHE+STR0024+ENTER  //"   # ASSINATURA DO REPRESENTANTE LEGAL."
   mDETALHE:=mDETALHE+ENTER  
   mDETALHE:=mDETALHE+STR0025+ENTER                                                                       //"2) COPIA ORIGINAL DO CONHECIMENTO DE EMBARQUE;"
   mDETALHE:=mDETALHE+STR0026+ENTER                                                  //"3) COPIA ORIGINAL DO REGISTRO DE EXPORTACAO (R.E.);"
   mDETALHE:=mDETALHE+STR0027+ENTER                                                                                                                         //"4) COPIA ORIGINAL DA SOLICITACAO DE DESPACHO (S.D.)."
   mDETALHE:=mDETALHE+ENTER                                             
   mDETALHE:=mDETALHE+ENTER                                              
   mDETALHE:=mDETALHE+STR0028+ENTER   //"ATENCIOSAMENTE"
                                                                      
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

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM18.PRW                                                 *
*------------------------------------------------------------------------------*
