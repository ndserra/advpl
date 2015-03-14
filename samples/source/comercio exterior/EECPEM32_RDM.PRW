#INCLUDE "EECPEM32.ch"

/*
Programa : EECPEM32.PRW
Autor    : Heder M Oliveira    
Data     : 10/12/99 16:49
Revisao  : 10/12/99 16:49
Uso      : Solicitacao para emissao de nota fiscal para exportacao
Alteracao: Cristiano Alves Ferreira 03/01/2000
*/

/*
considera que estah posicionado no registro de embarque (EEC)
*/

#include "EECRDM.CH"
#define TAMCOLDESC 27
/*
Funcao      : EECPEM32
Parametros  : 
Retorno     : 
Objetivos   : Solicitacao para emissao de nota fiscal para exportacao
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
User Function EECPEM32
LOCAL aOrd, cAux, nFOBValue, lRet, nCol, x, w, nTotLin, cVar, nTotalFOB, nTotalFOB2  // GFP - 21/08/2012
PRIVATE cPictPreco, cPictPeso, cPictQtde, cAssinante, cNatureza, nTaxa, cSEEKEXF, cSEEKLOJA
PRIVATE cEXP_NOME, cEXP_CONTATO, cEXP_FONE, cEXP_FAX,cFileMen,nTotal   // GFP - 21/08/2012

//armazena situacao atual
aOrd   := SaveOrd({"EE9","SA1"})

SA2->(dbSetOrder(1))
EE9->(dbSetOrder(4)) // filial+ncm+cod

cPictPreco := "@E 999,999,999"+if(EEC->EEC_DECPRC > 0,"."+Replic("9",EEC->EEC_DECPRC),"") 
cPictPeso  := "@E 999,999,999"+if(EEC->EEC_DECPES > 0,"."+Replic("9",EEC->EEC_DECPES),"") 
cPictQtde  := "@E 999,999,999"+if(EEC->EEC_DECQTD > 0,"."+Replic("9",EEC->EEC_DECQTD),"") 

cAssinante := Space(60)
cNatureza  := Space(20)
nTaxa      := BuscaTaxa(EEC->EEC_MOEDA,dDataBase)

//USADO NO EECF3EE3 VIA SXB "E34" PARA GET ASSINANTE

M->cSEEKEXF:=""
M->cSEEKLOJA:=""

lRet := .f.

Begin Sequence

   //regras para carregar dados
   IF !EMPTY(EEC->EEC_EXPORT) .AND. ;
      SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
      cEXP_NOME    := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
      M->cSEEKEXF  :=EEC->EEC_EXPORT
      M->cSEEKLOJA :=EEC->EEC_EXLOJA
   ELSE
      SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
      cEXP_NOME    := SA2->A2_NOME
      cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
      M->cSEEKEXF  :=EEC->EEC_FORN
      M->cSEEKLOJA :=EEC->EEC_FOLOJA
   ENDIF
   
   cAssinante := IncSpace(cEXP_CONTATO,60,.f.)

   IF ! TelaGets()
      lRet := .F. // by JBJ 14/01/2002
      Break
   Endif
   
   nFobValue := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
      //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   HEADER_P->(DBAPPEND())
   //carga obrigatoria
   HEADER_P->AVG_FILIAL := xFilial("SY0")
   HEADER_P->AVG_SEQREL := cSeqRel 
   HEADER_P->AVG_CHAVE  := EEC->EEC_PREEMB
    
   // Cabecalho ...
   HEADER_P->AVG_C01_60:=ALLTRIM(cEXP_NOME)
   HEADER_P->AVG_C02_60:=ALLTRIM(SA2->A2_END)
   HEADER_P->AVG_C03_60:=ALLTRIM(SA2->A2_EST+" "+AllTrim(BuscaPais(SA2->A2_PAIS))+STR0001+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6))) //" CEP: "
   HEADER_P->AVG_C04_60:=ALLTRIM(STR0002+AllTrim(cEXP_FONE)+STR0003+AllTrim(cEXP_FAX)) //"TEL.: "###" FAX: "
   
   HEADER_P->AVG_C05_60 := STR0004 //"SOLICITAÇÃO PARA EMISSÃO DE NOTA FISCAL PARA EXPORTAÇÃO"
   
   // Razao Social/Endereco
   HEADER_P->AVG_C06_60 := EEC->EEC_IMPODE
   HEADER_P->AVG_C07_60 := EEC->EEC_ENDIMP
   HEADER_P->AVG_C08_60 := EEC->EEC_END2IM
   HEADER_P->AVG_C09_60 := EEC->EEC_REFIMP
   
   // Pedido Nr.
   HEADER_P->AVG_C01_20 := EEC->EEC_PREEMB
   // Natureza de Operacao
   HEADER_P->AVG_C02_20 := cNatureza
   // Via Transporte
   HEADER_P->AVG_C01_30 := SUBSTR(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),3,AVSX3("YQ_COD_DI",3)-2)
   // C.N.P.J.
   HEADER_P->AVG_C03_20 := Transf(SA2->A2_CGC,AVSX3("A2_CGC",6))
   // Insc. Estadual       
   HEADER_P->AVG_C04_20 := Transf(SA2->A2_INSCR,AVSX3("A2_INSCR",6))
   // Cond. Pagto
   HEADER_P->AVG_C10_60 := SY6Descricao(EEC->EEC_CONDPA+STR(EEC->EEC_DIASPA,AVSX3("Y6_DIAS_PA",3),0), cSXBID,1)  //EEC->EEC_IDIOMA,1)  // GFP - 01/08/2012 - Considerar idioma escolhido no combobox
   HEADER_P->AVG_C05_20 := Transf(nTaxa,"@E 999.999999")  //TAXA
   // Comissao do Agente                                             
   //Substituição do AVG_C19_60 e AVG_C20_60 - ASK 04/10/06 16:55
   HEADER_P->AVG_C26_60 := BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_AGC)
   IF EEC->EEC_TIPCVL == "2"  // VALOR
      HEADER_P->AVG_C27_60 := "R$ "+ALLTRIM(TRANSFORM(EEC->EEC_VALCOM*nTaxa,"@E 9,999,999.99"))
   ELSE  // PERCENTUAL
      HEADER_P->AVG_C20_60 := ALLTRIM(TRANSFORM(EEC->EEC_VALCOM,"@E 9,999,999.99"))+"% = R$ "+;
                              ALLTRIM(TRANSFORM(((nFOBVALUE*EEC->EEC_VALCOM)/100)*nTAXA,"@E 9,999,999.99"))
   ENDIF
   /// LCS - 23/09/2002 - AS 5 LINHAS ABAIXO FORAM SUBSTITUIDAS PELAS 7 ACIMA
   ///IF EEC->EEC_TIPCVL == "1"
   ///  HEADER_P->AVG_C18_20 := "R$ "+ALLTRIM(TRANSF(ROUND(EEC->EEC_TOTPED * nTaxa * EEC->EEC_VALCOM /100,2),"@E 9999,999,999.99"))
   ///ELSE
   ///  HEADER_P->AVG_C18_20 := "R$ "+ALLTRIM(TRANSF(ROUND(nTaxa * EEC->EEC_VALCOM ,2), "@E 9999,999,999.99"))
   ///ENDIF
   //Transportadora
   // Verifica se o tipo de transporte eh rodoviario
   cAux := Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1)
   IF cAux == "7" // Rodoviario
      HEADER_P->AVG_C11_60 := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA)
   Else
      HEADER_P->AVG_C11_60 := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_AGE)
   Endif   
   
   //Porto Destino / Origem
   HEADER_P->AVG_C02_30 := If(Left(EEC->EEC_INCOTE,1) == "F",Posicione("SY9",2,xFilial("SY9")+EEC->EEC_ORIGEM,"Y9_DESCR"),Posicione("SY9",2,xFilial("SY9")+EEC->EEC_DEST,"Y9_DESCR"))  // GFP - 21/08/2012
   
   // Marks
   HEADER_P->AVG_C12_60 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO),1) 
   HEADER_P->AVG_C13_60 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO),2) 
   HEADER_P->AVG_C14_60 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO),3) 
   HEADER_P->AVG_C15_60 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO),4) 
   HEADER_P->AVG_C16_60 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO),5) 
   HEADER_P->AVG_C17_60 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO),6) 
   
   // Qtde./Especie Volumes
   HEADER_P->AVG_C18_60 := EEC->EEC_PACKAG
   // Peso Liquido/Vol.
   HEADER_P->AVG_C06_20 := EEC->EEC_NETWGT
   // Peso Bruto/Vol.
   HEADER_P->AVG_C07_20 := EEC->EEC_GROSSW
   
   // Peso Liquido Total
   HEADER_P->AVG_C16_20 := Transf(EEC->EEC_PESLIQ,AVSX3("EEC_PESLIQ",6))
   // Peso Bruto Total
   HEADER_P->AVG_C17_20 := Transf(EEC->EEC_PESBRU,AVSX3("EEC_PESBRU",6))
   
   //Totais
   // gravado depois dos itens ... HEADER_P->AVG_C08_20 := //
   
   GravaItens()  // GFP - 21/08/2012 - Gravação dos itens deve ser feita antes dos calculos de totalizadores.
   
   nTotalFOB  := nTotal + (nTaxa*(EEC->EEC_DESPIN + EEC->EEC_FRPCOM)) - (nTaxa*EEC->EEC_DESCON)    // GFP - 21/08/2012 - Calculo Total FOB 
   nTotalFOB2 := nTotalFOB + (nTaxa*(EEC->EEC_FRPREV + EEC->EEC_SEGPRE))   // GFP - 21/08/2012 - Calculo Total FOB Porto
   
   HEADER_P->AVG_C09_20 := Transf(nTaxa*EEC->EEC_FRPCOM,AVSX3("EEC_FRPCOM",6))
   HEADER_P->AVG_C10_20 := Transf(nTaxa*(EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2")),"@E 999,999,999.99")
   HEADER_P->AVG_C11_20 := Transf(nTaxa*EEC->EEC_DESCON,AVSX3("EEC_DESCON",6))
   //HEADER_P->AVG_C12_20 := Transf(nTaxa*nFobValue,AVSX3("EEC_TOTPED",6))
   //HEADER_P->AVG_C12_20 := Transf(nTaxa*EEC->EEC_TOTPED,AVSX3("EEC_TOTPED",6))
   HEADER_P->AVG_C12_20 := Transf(nTotalFOB,AVSX3("EEC_TOTPED",6))
   HEADER_P->AVG_C13_20 := Transf(nTaxa*EEC->EEC_FRPREV,AVSX3("EEC_FRPREV",6))
   HEADER_P->AVG_C14_20 := Transf(nTaxa*EEC->EEC_SEGPRE,AVSX3("EEC_SEGPRE",6))
   HEADER_P->AVG_C15_20 := Transf(nTotalFOB2,AVSX3("EEC_TOTPED",6))
   //HEADER_P->AVG_C15_20 := Transf(nTaxa*EEC->EEC_TOTPED,AVSX3("EEC_TOTPED",6))
   
   HEADER_P->AVG_C02_10 := EEC->EEC_INCOTE
   // LCS 23/09/2002 - MANTEVE O CAMPO Y9_DESCR
   //HEADER_P->AVG_C02_30 := Posicione("SY9",1,xFilial("SY9")+EEC->EEC_DEST,"Y9_CIDADE")
   //Observacoes
   //chamar rotina de mensagens
   IF SELECT("Work_Men") > 0
      nCol:=60
      x:=1
      Work_Men->(DBGOTOP())
      DO WHILE !Work_Men->(EOF()) .And. Work_Men->WKORDEM < "zzzzz"				  	
         nTotLin:=MLCOUNT(Work_Men->WKOBS,nCol) 
         FOR W := 1 TO nTotLin															
            IF x == 5
               BREAK
            Endif
            If !EMPTY(MEMOLINE(Work_Men->WKOBS,nCol,W))
               cVar := "AVG_C"+Padl(x+18,2,"0")+"_60"
               HEADER_P->(FieldPut(FieldPos(cVar),MEMOLINE(Work_Men->WKOBS,nCol,W)))
               x := x+1
            EndIf
         NEXT
         IF x == 5
            Break
         Endif
         Work_Men->(DBSKIP())
      ENDDO
   ENDIF
   
   //Export/Assinante
   HEADER_P->AVG_C23_60 := cEXP_NOME
   HEADER_P->AVG_C24_60 := cAssinante
   
   //Data
   HEADER_P->AVG_C25_60 := AllTrim(SA2->A2_MUN)+", "+StrZero(Day(dDataBase),2)+STR0005+Upper(MesExtenso(Month(dDataBase)))+STR0005+Str(Year(dDataBase),4) //" DE "###" DE "
   
   // Moeda
   HEADER_P->AVG_C01_10 := EEC->EEC_MOEDA
   
   //GravaItens()  // Nopado por GFP - 21/08/2012
   
   HEADER_P->(dbUnlock())

   //*** JBJ - 19/06/01 - 13:21 - Gravar histórico de documentos - (INICIO)
   
   HEADER_H->(dbAppend())
   AvReplace("HEADER_P","HEADER_H") 
   
   DETAIL_P->(DbGoTop())
   Do While ! DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo

   //*** (FIM) 
   
   lRet := .t.

End Sequence

IF(SELECT("Work_Men")>0,Work_Men->(E_EraseArq(cFileMen)),)

//retorna a situacao anterior ao processamento
RestOrd(aOrd)

// ** By JBJ - 14/01/2002 - 10:48   
Return lRet
//Return nil

//----------------------------------------------------------------------
STATIC Function TelaGets
LOCAL lRet, nOpc, bOk, bCancel, oDlg, cFileMen, bInit
PRIVATE cCONTATO

lRet := .f.
nOpc := 0

bOk  := bCancel := nil

Begin Sequence
   
   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 9,0 TO 28,80 OF oMainWnd
   
   M->cCONTATO:=cAssinante
           
   @ 20,01 SAY "Assinante" PIXEL
   @ 20,45 MSGET M->cCONTATO PICTURE "@!" SIZE 120,8 F3 "E34" PIXEL
   
   @ 34,01 SAY "Natureza de Op." PIXEL
   @ 34,45 MSGET cNatureza  PICTURE "@!" PIXEL
   
   @ 48,01 SAY "Taxa" PIXEL
   @ 48,45 MSGET nTaxa PICTURE "@E 999.999999" PIXEL
   
   cFileMen := ""
   EECMensagem(/*EEC->EEC_IDIOMA*/ cSXBID,"3",{62,1,140,325})    // GFP - 01/08/2012 - Considerar idioma escolhido no combobox
   
   bOk     := {||nOpc:=1,oSend(oDlg,"End")}
   bCancel := {||nOpc:=0,oSend(oDlg,"End")}         
   bInit := {|| EnchoiceBar(oDlg,bOk,bCancel) }

   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

End Sequence

IF nOpc == 1
   lRet := .t.
Endif 
cAssinante:=M->cCONTATO

Return lRet

//--------------------------------------------------------------------
STATIC FUNCTION GravaItens
LOCAL cUnidad, cNCM, cMemo, nTot, i //,nTotal
EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))

cUnidad := ""
cNcm    := ""
nTotal  := 0

Begin Sequence

While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
      EE9->EE9_PREEMB == EEC->EEC_PREEMB

   IF cUnidad <> EE9->EE9_UNIDAD
      cUnidad := EE9->EE9_UNIDAD
      DETAIL_P->(dbAppend())
      DETAIL_P->AVG_FILIAL := xFilial("SY0")
      DETAIL_P->AVG_SEQREL := cSeqRel 
      DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
      
      DETAIL_P->AVG_C04_20 := Padc("R$/"+AllTrim(EE9->EE9_UNIDAD),20)

      DETAIL_P->(dbUnlock())
      Loop
   Endif
   
   IF cNcm <> EE9->EE9_POSIPI
      cNcm := EE9->EE9_POSIPI
      DETAIL_P->(dbAppend())
      DETAIL_P->AVG_FILIAL := xFilial("SY0")
      DETAIL_P->AVG_SEQREL := cSeqRel 
      DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
      
      DETAIL_P->AVG_C01_60 := AllTrim(Posicione("SYD",1,xFilial("SYD")+cNcm,"YD_DESC_P"))
      DETAIL_P->(dbUnlock())
      Loop
   Endif   
   
   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSeqRel 
   DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
   
   DETAIL_P->AVG_C01_20 := AllTrim(Transf(EE9->EE9_SLDINI,cPictQtde))
   DETAIL_P->AVG_C02_20 := AllTrim(Transf(EE9->EE9_PSLQTO,cPictPeso))
   DETAIL_P->AVG_C03_20 := AllTrim(Transf(EE9->EE9_POSIPI,AVSX3("EE9_POSIPI",6)))
   DETAIL_P->AVG_C04_20 := AllTrim(Transf(nTaxa*EE9->EE9_PRECO,cPictPreco))
   DETAIL_P->AVG_C05_20 := AllTrim(Transf(Round(nTaxa*EE9->EE9_PRECO,2)*EE9->EE9_SLDINI,AVSX3("EE9_PRCTOT",6))) //AllTrim(Transf(nTaxa*EE9->EE9_PRCTOT,AVSX3("EE9_PRCTOT",6)))  // GFP - 21/07/2012 - Acerto de arredondamento

   //TRP 21/11/2007 - Acerto na impressão do campo memo EE9_VM_DES
   cMemo := AA100Idioma(EE9->EE9_COD_I)  //Alltrim(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",AV_TAMANHO)))  // GFP - 03/09/2012 - Tratamento de Idiomas
   cMemo := StrTran(cMemo,ENTER,Space(1))
   nTot  := MlCount(cMemo,TAMCOLDESC)
   
   For i := 1 to nTot
      IF i <> 1
         DETAIL_P->(dbAppend())
         DETAIL_P->AVG_FILIAL := xFilial("SY0")
         DETAIL_P->AVG_SEQREL := cSeqRel 
         DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
      Endif
      
      //DETAIL_P->AVG_C01_60 := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),i)
      DETAIL_P->AVG_C01_60 := Memoline(cMemo,TAMCOLDESC,i)  //TRP 21/11/2007   // GFP - 03/09/2012
   Next
      
   DETAIL_P->(dbUnlock()) 
   
   nTotal := nTotal+(EE9->EE9_SLDINI*Round(nTaxa*EE9->EE9_PRECO,2))  //GFP - 21/07/2012 - Acerto de arredondamento
	  
   EE9->(dbSkip())
  

Enddo

HEADER_P->AVG_C08_20 := Transf(nTotal,AVSX3("EEC_TOTPED",6))     

End Sequence

RETURN (NIL)

*-------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM32.PRW                                            *
*-------------------------------------------------------------------------*
