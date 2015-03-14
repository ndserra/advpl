#INCLUDE "EECPEM16.ch"
#include "rwmake.ch"            // incluido pelo assistente de conversao do AP5 IDE em 09/11/00


User Function EECPEM16()        // incluido pelo assistente de conversao do AP5 IDE em 09/11/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LRETR,AORD,CSEQRELAC,CEXP_NOME,CEXP_END,CEXP_BAIRRO")
SetPrvt("CEXP_MUN,CEXP_EST,CEXP_CGC,CEXP_CONTATO,CEXP_FONE,CEXP_FAX")
SetPrvt("CTO_ATTN,CTO_FAX,CTO_NOME,CPERIODIC,CCOBCAMB,CENQ")
SetPrvt("CCONDV,CMOEDA,CIMP_NOME,CIMP_END1,CIMP_END2,CEMBARQUE")
SetPrvt("CNOPADES,CPAISDES,CDESTINO,CPAISDT,CCONTPG")
SetPrvt("NLINHA,LPRIM,CNCM,CMEMO,")

/*
Programa : EECPEM16.PRW
Autor    : Cristiane
Data     : 13/01/2000 09:00
Uso      : SOLICITACAO DE RE
Revisão  : Jeferson Barros Jr.
Data     : 15/08/2001 - 17:12 
*/


/*
considera que estah posicionado no registro de processo de
embarque (EEC)
*/

lRETr := .T.
aOrd := SaveOrd({"EE9","SA2","SA1","SYA","EEB","SY6","SY9","SYR"})
EE9->(DBSETORDER(4))
SA2->(DBSETORDER(1))
SA1->(DBSETORDER(1))              
SYA->(DBSETORDER(1))  
EEB->(DBSETORDER(1))          
SY6->(DBSETORDER(1))   
SY9->(DBSETORDER(2))
SYR->(DBSETORDER(1))
cSEQRELAC:=""		  

//Processamento Principal
While .T.
   //regras para carregar dados    
   cEXP_NOME    := ""
   cEXP_END     := ""
   cEXP_BAIRRO  := ""
   cEXP_MUN     := ""
   cEXP_EST     := ""
   cEXP_CGC     := ""
   cEXP_CONTATO := ""
   cEXP_FONE    := ""
   cEXP_FAX     := ""
											   
   IF !EMPTY(EEC->EEC_EXPORT) .AND. SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))                                                    
      cEXP_NOME    := SA2->A2_NOME                        
      cEXP_END     := SA2->A2_END 
      cEXP_BAIRRO  := SA2->A2_BAIRRO 
      cEXP_MUN     := SA2->A2_MUN 
      cEXP_EST     := SA2->A2_EST 
      cEXP_CGC     := SA2->A2_CGC
      
      cEXP_CONTATO :=EECCONTATO("X",EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1     
      cEXP_FONE    :=EECCONTATO("X",EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1     
      cEXP_FAX     :=EECCONTATO("X",EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1      
   ELSEIF SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))                                                       
      cEXP_NOME    := SA2->A2_NOME 
      cEXP_END     := SA2->A2_END   
      cEXP_BAIRRO  := SA2->A2_BAIRRO
      cEXP_MUN     := SA2->A2_MUN   
      cEXP_EST     := SA2->A2_EST
      cEXP_CGC     := SA2->A2_CGC
      
      cEXP_CONTATO :=EECCONTATO("X",EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1       
      cEXP_FONE    :=EECCONTATO("X",EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1       
      cEXP_FAX     :=EECCONTATO("X",EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1        
   ENDIF                                                                                                                
   
   EEB->(DBSEEK(xFilial("EEB")+EEC->EEC_PREEMB))

   cTO_ATTN :=""
   cTO_FAX  :=""
   cTO_NOME :=""                                                    
   While EEB->(!Eof() .And. EEB->EEB_FILIAL == xFilial("EEB") .AND. EEB->EEB_PEDIDO==EEC->EEC_PREEMB)                                                
      IF LEFT(EEB->EEB_TIPOAG,1) == "6" // Despachante                              
         cTO_NOME:=ALLTRIM(EEB->EEB_NOME)                                                    
         cTO_ATTN:=ALLTRIM(EECCONTATO("E",EEB->EEB_CODAGE,,"1",1)) //nome do contato seq 1   
         cTO_FAX :=ALLTRIM(EECCONTATO("E",EEB->EEB_CODAGE,,"1",7)) //fax do contato seq 1    
	     EXIT
      Endif                                                                         
      EEB->(dbSkip())                                                               
   Enddo  
   
   IF Empty(cTO_NOME)
      MSGINFO(STR0001,STR0002) //"Este processo não está vinculado a um Despachante."###"Aviso"
	  IF !MSGNOYES(STR0003,STR0002) //"Prosseguir Sem Despachante?"###"Aviso"
         lRetr := .F.
         EXIT
	  ENDIF
   ENDIF              
	       									      
   cEXP_NOME    := ALLTRIM(cEXP_NOME)            
   cEXP_END     := ALLTRIM(cEXP_END)         
   cEXP_BAIRRO  := ALLTRIM(cEXP_BAIRRO)      
   cEXP_MUN     := ALLTRIM(cEXP_MUN)         
   cEXP_EST     := ALLTRIM(cEXP_EST)         
   cEXP_CGC     := ALLTRIM(cEXP_CGC)         								       
   cEXP_CONTATO := ALLTRIM(cEXP_CONTATO)
   cEXP_FONE    := ALLTRIM(cEXP_FONE)
   cEXP_FAX     := ALLTRIM(cEXP_FAX)
   
   //PERIODICIDADE
   cPERIODIC := IF(EEC->EEC_DIASPA<=0,0,EEC->EEC_DIASPA)

   //VALOR S/ COBEWRTURA DE CAMBIO
   cCOBCAMB := IF(EEC->EEC_COBCAM="S",EEC->EEC_TOTPED,0)

   // ENQUADRAMENTO
   cENQ	:= EEC->(ALLTRIM(EEC_ENQCOD)+"  "+ALLTRIM(EEC_ENQCO1)+"  "+ALLTRIM(EEC_ENQCO2)+"  "+ALLTRIM(EEC_ENQCO3)+"  "+ALLTRIM(EEC_ENQCO4)+"  "+ALLTRIM(EEC_ENQCO5)+"  ")

   // CONDICAO DE VENDA
   cCONDV := EEC->EEC_INCOTE+"  "+ Posicione("SYJ",1,xFilial("SYJ")+EEC->EEC_INCOTE,"YJ_DESCR")

   // MOEDA
   cMOEDA := EEC->EEC_MOEDA+"  "+ Posicione("SYF",1,xFilial("SYF")+EEC->EEC_MOEDA,"YF_DESC_SI")

   // IMPORTADOR
   SA1->(DBSEEK(xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))   
   cIMP_NOME := IF(!EMPTY(EEC->EEC_IMPODE),EEC->EEC_IMPODE,SA1->A1_NOME)
   cIMP_END1 := IF(!EMPTY(EEC->EEC_ENDIMP),EEC->EEC_ENDIMP,SA1->A1_END+" "+SA1->A1_BAIRRO)
   cIMP_END2 := IF(!EMPTY(EEC->EEC_END2IM),EEC->EEC_END2IM,SA1->A1_MUN+" "+SA1->A1_EST)
   
   // EMBARQUE/DESTINO
   IF !EMPTY(EEC->EEC_ORIGEM) 
      cEMBARQUE := Posicione("SY9",2,xFilial("SY9")+EEC->EEC_ORIGEM,"Y9_DESCR")
   ELSE
      cEMBARQUE := SPACE(AVSX3("Y9_DESCR",3))
   EndIf

   cNOPADES := "" 
   IF !EMPTY(EEC->EEC_ORIGEM) .AND. !EMPTY(EEC->EEC_DEST)
      cPAISDES := Posicione("SYR",1,xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA,"YR_PAIS_DE")
      cDESTINO := Posicione("SYR",1,xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA,"YR_CID_DES")   
      SYA->(DBSEEK(xFilial("SYA")+cPAISDES))
      cNOPADES := Posicione("SYA",1,xFilial("SYA")+cPAISDES,"YA_DESCR")     
   ELSE
      cDESTINO := SPACE(AVSX3("Y9_DESCR",3)) 
   ENDIF      
       
   // PAIS DESTINO
   cPAISDT := Posicione("SYA",1,xFilial("SYA")+EEC->EEC_PAISDT,"YA_DESCR")     
 		    
   cSEQREL :=GETSX8NUM("SY0","Y0_SEQREL")
   CONFIRMSX8()
  
   //gravar arquivo de impressao
   HEADER_P->(DBAPPEND())
   //DFS - 19/07/11 - Comentado para que o relatório funcione corretamente em Ctree
// IF HEADER_P->(RLOCK())
      HEADER_P->AVG_FILIAL := XFILIAL("SY0")
      HEADER_P->AVG_SEQREL := cSEQREL
      HEADER_P->AVG_CHAVE  :=EEC->EEC_PREEMB //nr. do processo
      HEADER_P->AVG_C01_60 :=cEXP_NOME
      HEADER_P->AVG_C02_60 :=WORKID->EEA_TITULO
   	 
      HEADER_P->(DBUNLOCK())
      //gravar arquivo de historico da impressao
      HEADER_H->(DBAPPEND())
      //DFS - 19/07/11 - Comentado para que o relatório funcione corretamente em Ctree
//    IF HEADER_H->(RLOCK())
         HEADER_H->AVG_FILIAL := XFILIAL("SY0")
         HEADER_H->AVG_SEQREL := cSEQREL
   	     HEADER_H->AVG_CHAVE  :=EEC->EEC_PREEMB //nr. do processo
         HEADER_H->AVG_C01_60 :=cEXP_NOME
         HEADER_H->AVG_C02_60 :=WORKID->EEA_TITULO
         HEADER_H->(DBUNLOCK())
//    ENDIF
// ENDIF
   
   //carregar detalhe
   
   cCONTPG := 1 
   nLINHA  := 1
   
   EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
   INCCAB()				
   LPRIM := .T.
   While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And. EE9->EE9_PREEMB == EEC->EEC_PREEMB		 
      IF !LPRIM
	     INCCAB()
      ENDIF
      LPRIM := .F.
      INCDET()
      DETAIL_P ->AVG_C01120 := STR0004 //"10-CODIGO DA MECADORIA: "
      INCDET()
      DETAIL_P ->AVG_C01120 := STR0005+ TRANSF(EE9->EE9_POSIPI,AVSX3("EE9_POSIPI",6)) + " - "+Posicione("SYD",1,xFilial("SYD")+EE9->EE9_POSIPI,"YD_DESC_P") //"   a-N.C.M...................: "
      INCDET()
      DETAIL_P ->AVG_C01120 := STR0006+ Transf(EE9->EE9_NALSH,AVSX3("EE9_NALSH",6)) //"   b-NALADI/SH...............: "
      cNCM := EE9->EE9_POSIPI
   
      INCDET()
      DETAIL_P ->AVG_C01120 := STR0007            //"11-DESCRICAO DA MERCADORIA: "
     
      WHILE EE9->(!EOF()) .AND. xFILIAL("EE9")==EE9->EE9_FILIAL .AND. ;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB .AND. EE9->EE9_POSIPI == cNCM
   
         cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
	  
         INCDET()
         DETAIL_P ->AVG_C01120 := "   "+MemoLine(cMemo,AVSX3("EE9_VM_DES",3),1)
        
         EE9->(DBSKIP())   
      ENDDO    
    
      INCDET()
      INCDET()
      INCDET()
   
      INCDET()
      DETAIL_P ->AVG_C01120 := STR0008 //"12-CATEGORIA TEXTIL: "
   
      INCDET()
      DETAIL_P ->AVG_C01120 := REPLICATE("-",82)
	 
      INCDET()
      DETAIL_P ->AVG_C01120 := STR0009+MSMM(EEC->EEC_CODOBP,AVSX3("EEC_OBSPED",3),,,3)    //"25-OBSERVACAO/EXPORTADOR: "
      cCONTPG := cCONTPG + 1
      
   ENDDO
	  
   Exit
ENDDO

RestOrd(aOrd)

// Substituido pelo assistente de conversao do AP5 IDE em 09/11/00 ==> __RETURN(lRETr)
Return(lRETr)        // incluido pelo assistente de conversao do AP5 IDE em 09/11/00

// Substituido pelo assistente de conversao do AP5 IDE em 09/11/00 ==> FUNCTION INCDET
Static FUNCTION INCDET()
   
   DETAIL_P->(DBAPPEND())
   DETAIL_P->AVG_FILIAL     := XFILIAL("SY0")
   DETAIL_P->AVG_SEQREL     := cSEQREL
   DETAIL_P->AVG_CHAVE      := EEC->EEC_PREEMB
   DETAIL_P->AVG_CONT       := STRZERO(cCONTPG,6)
   DETAIL_P->AVG_LINHA      := STRZERO(nLINHA,6)
   nLINHA := nLINHA + 1
   
RETURN NIL   

// Substituido pelo assistente de conversao do AP5 IDE em 09/11/00 ==> FUNCTION INCCAB
Static FUNCTION INCCAB()

   // *** FJH 01/02/05   
   cPOSIPI := EE9->EE9_POSIPI
   nRecNo := EE9->(recno())
   nTotal := 0
   EE9->(DbSetOrder(4))
   EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB+cPOSIPI))
   While EE9->EE9_FILIAL == xFilial("EE9") .and. EE9->EE9_PREEMB == EEC->EEC_PREEMB ;
            .and. EE9->EE9_POSIPI == cPOSIPI
      nTotal += EE9->EE9_PRCTOT
      EE9->(DBSkip())
   End
   EE9->(DBGoTo(nRecNo))
   // ***

   INCDET()
   DETAIL_P->AVG_C01120 := SPACE(47)+STR0010+DTOC(dDATABASE) //"DATA: "
   INCDET()
   DETAIL_P->AVG_C01120 :=STR0011+ALLTRIM(cEXP_NOME) //"DE       : "
   INCDET()
   DETAIL_P->AVG_C01120 := "           "+cEXP_CONTATO
   INCDET()
   DETAIL_P->AVG_C01120 := STR0012+cTO_NOME //"PARA     : "
   INCDET()
   DETAIL_P->AVG_C01120 := "           "+cTO_ATTN
   INCDET()
   DETAIL_P->AVG_C01120 := STR0013+cTO_FAX //"FAX NR   : "
   INCDET()
   INCDET()
   DETAIL_P->AVG_C01120 :=STR0014+ALLTRIM(EEC->EEC_PREEMB)+"/" + STRZERO(cCONTPG,3) //"NUMERO DO RE......: "
   INCDET()
   INCDET()
   DETAIL_P->AVG_C01120 := STR0015 //"01-EXPORTADOR"
   INCDET()
   DETAIL_P->AVG_C01120 := STR0016+TRANSF(cEXP_CGC,AVSX3("A2_CGC",6)) //"   a-CNPJ/CPF................: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0017+cEXP_NOME //"   b-NOME....................: "
   
   INCDET()
   DETAIL_P->AVG_C01120 := STR0018 //"02-ENQUADRAMENTO OPERACAO"
   INCDET()
   DETAIL_P->AVG_C01120 := STR0019+cENQ //"   a-CODIGO ENQUADRAMENTO....: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0020+EEC->EEC_REGVEN+STR0021+TRANSF(EE9->EE9_ATOCON,AVSX3("EE9_ATOCON",6)) //"   b-NUM REGISTRO VENDA......: "###"      f-NUM ATO CONCESSORIO.:"
   INCDET()
   DETAIL_P->AVG_C01120 := STR0022+transf(EEC->EEC_OPCRED,AVSX3("EEC_OPCRED",6))+STR0023+TRANSF(EEC->EEC_LIMOPE,AVSX3("EEC_LIMOPE",6)) //"   c-NUM OPERACAO CREDITO....: "###"      g-DATA LIMITE OPERACAO:"
   INCDET()
   DETAIL_P->AVG_C01120 := STR0024+transf(EEC->EEC_GEDERE,AVSX3("EEC_GEDERE",6))+STR0025+TRANSF(EEC->EEC_MRGNSC,AVSX3("EEC_MRGNSC",6)) //"   d-GE/DE/RE VINCULADA......: "###"  h-MARGEM NAO SACADA(%):"
   INCDET()
   DETAIL_P->AVG_C01120 := STR0026+EEC->EEC_DIRIVN+STR0051+EEC->EEC_GDRPRO //"   e-DI/RI VINCULADA.........: " //"i-NUMERO PROCESSO.....:"
   
   INCDET()
   DETAIL_P->AVG_C01120 := STR0027+EEC->EEC_URFDSP + "   " + Posicione("SJ0",1,xFilial("SJ0")+EEC->EEC_URFDSP,"J0_DESC") //"03-UNIDADE RF DESPACHO.......: "
   
   INCDET()
   DETAIL_P->AVG_C01120 := STR0028+EEC->EEC_URFENT + "   " + Posicione("SJ0",1,xFilial("SJ0")+EEC->EEC_URFENT,"J0_DESC") //"04-UNIDADE RF EMBARQUE.......: "
   
   INCDET()
   DETAIL_P->AVG_C01120 := STR0029 //"05-IMPORTADOR"
   INCDET()
   DETAIL_P->AVG_C01120 := STR0030+cIMP_NOME //"   a-NOME....................: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0031+cIMP_END1 //"   b-ENDERECO................: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0032+ALLTRIM(cDESTINO) + "/" + cNOPADES  //"   c-PAIS....................: "
   
   INCDET()
   DETAIL_P->AVG_C01120 := STR0033+ EEC->EEC_PAISDT + "  " +cPAISDT                 //"06-PAIS DESTINO FINAL........: "
   
   INCDET()
   DETAIL_P->AVG_C01120 := STR0034+ EEC->EEC_INSCOD + "   " + Posicione("EEE",1,xFilial("EEE")+EEC->EEC_INSCOD,"EEE_DESC") //"07-INSTRUMENTO NEGOCIACAO....: "
   
   INCDET()
   DETAIL_P->AVG_C01120 := STR0035+cCONDV               //"08-CODIGO CONDICAO VENDA.....: "
   
   INCDET()
//   DETAIL_P->AVG_C01120 := STR0036+ TRANSF(EEC->EEC_TOTPED,AVSX3("EEC_TOTPED",6))+STR0037 //"09-ESQUEMA DE PAGAMENTO TOTAL: "###" (calculado)"
// FJH 01/02/06
   DETAIL_P->AVG_C01120 := STR0036+ TRANSF(nTotal,AVSX3("EEC_TOTPED",6))+STR0037 //"09-ESQUEMA DE PAGAMENTO TOTAL: "###" (calculado)"
   INCDET()
   DETAIL_P->AVG_C01120 := STR0038+ EEC->EEC_MPGEXP //"   a-MODALIDADE TRANSACAO....: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0039+ cMOEDA //"   b-MOEDA...................: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0040+ TRANSF(EEC->EEC_ANTECI,AVSX3("EEC_ANTECID",6))  //"   c-VALOR PAGTO ANTECIPADO..: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0041+ TRANSF(EEC->EEC_VISTA,AVSX3("EEC_VISTA",6)) //"   d-VALOR PAGTO A VISTA.....: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0042+ TRANSF(EEC->EEC_NPARC,AVSX3("EEC_NPARC",6)) //"   e-NUMERO PARCELAS.........: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0043+ TRANSF(cPERIODIC, AVSX3("EEC_DIASPA",6)) +STR0044+"D" //"   f-PERIODICIDADE...........: "###"            g-INDICADOR....: "
   INCDET()
//   DETAIL_P->AVG_C01120 := STR0045+ TRANSF(EEC->EEC_PARCEL,AVSX3("EEC_PARCEL",6))  //"   h-VALOR DA PARCELA........: "
// FJH 01/02/06
   DETAIL_P->AVG_C01120 := STR0045+ TRANSF(nTotal/EEC->EEC_NPARC,AVSX3("EEC_PARCEL",6))  //"   h-VALOR DA PARCELA........: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0046+ TRANSF(EEC->EEC_VLMNSC,AVSX3("EEC_VLMNSC",6)) +STR0047 //"   i-VALOR MARGEM NAO SACADA.: "###"(calculado)"
   INCDET()
   DETAIL_P->AVG_C01120 := STR0048+ TRANSF(EEC->EEC_VLCONS,AVSX3("EEC_VLCONS",6)) //"   j-VALOR EM CONSIGNACAO....: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0049+ TRANSF(cCOBCAMB,AVSX3("EEC_TOTPED",6)) //"   l-VALOR S COBERTURA CAMBIO: "
   INCDET()
   DETAIL_P->AVG_C01120 := STR0050+ TRANSF(EEC->EEC_FINCIA,AVSX3("EEC_FINCIA",6))  //"   m-VALOR FINANCIAMENTO RC..: "

RETURN NIL
*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM16.PRW                                                 *
*----------------------------------------------------------------------------*
