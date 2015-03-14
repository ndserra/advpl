/*
Programa        : EECPEM59_rdm.PRW
Objetivo        : Certificado de Origem - Aladi - FIEB
Autor           : Cristiano A. Ferreira
Data/Hora       : 14/01/2000
Obs.            : considera que estah posicionado no registro de embarque (EEC)
Revisão         : João Pedro Macimiano Trabbold - 13/06/05 - impressão dos certificados FIESP, FIEP E FEDERASUL.
*/
#include "EECRDM.CH"
#INCLUDE "EECPEM59.ch"

#define MARGEM     Space(10)
#DEFINE LENCON1    08
#DEFINE LENCON2    93
#define TOT_NORMAS 07
#define LENCOL1    08
#define LENCOL2    14
#define LENCOL3    78
#define TOT_ITENS  10
#DEFINE TAMOBS     99
*---------------------*
USER FUNCTION EECPEM59
*---------------------*
Local cParam := If(Type("ParamIxb") = "A" , ParamIxb[1],"")

LOCAL mDET,mROD,mCOMPL,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1"}),;
      aLENCOL := {{"ORDEM"    ,LENCOL1,"C",STR0001 },; //"Ordem"
                  {"COD_NALAD",LENCOL2,"C",STR0002 },; //"Cod.NALADI/SH"
                  {"DESCRICAO",LENCOL3,"M",STR0003 }} //"Descricao"
      aLENCON := {{"ORDEM"    ,LENCON1,"C",STR0001 },; //"Ordem"
                  {"DESCRICAO",LENCON2,"C",STR0004 }} //"Normas de Origem"
                  
PRIVATE cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}
*
IF COVERI("ALA")
   IF CODET(aLENCOL,aLENCON,"EE9_NALSH",TOT_NORMAS,"PEM59",TOT_ITENS) // DETALHES
      aCAB    := COCAB()        // CABECALHO
      aROD    := COROD(TAMOBS) // RODAPE
      // DATA DE EMISSAO DO CERTIFICADO
      aROD[4] := STR(DAY(dDATABASE),2)+" DE "+Alltrim(UPPER(MESEXTENSO(MONTH(dDATABASE))))+" DE "+STR(YEAR(dDATABASE),4)

      // EDICAO DOS DADOS
      IF COTELAGETS(STR0005,"2") //"Aladi"
         // EXPORTADOR
         mDET := ""
         mDET := mDET+REPLICATE(ENTER,08)               // LINHAS EM BRANCO
         mDET := mDET+MARGEM+SPACE(70)+aCAB[2,4]+ENTER  // PAIS DO EXPORTADOR
         mDET := mDET+REPLICATE(ENTER,3)
         // RODAPE
         mROD := ""
         // DATA DA IMPRESSAO DO CERTIFICADO
         mROD := mROD+MARGEM+Space(08)+STR(DAY(ctod(arod[5])),2)+" DE "+;
                 Alltrim(UPPER(MESEXTENSO(MONTH(ctod(arod[5])))))+" DE "+;
                 STR(YEAR(ctod(arod[5])),4)+ENTER
         mROD := mROD+REPLICATE(ENTER,6)              // LINHAS EM BRANCO
         mROD := mROD+MARGEM+aROD[1,1]+ENTER          // LINHA 1 DA OBS.          
         mROD := mROD+MARGEM+aROD[1,2]+ENTER          // LINHA 2 DA OBS.
         mROD := mROD+REPLICATE(ENTER,8) //4             // LINHAS EM BRANCO
         mROD := mROD+MARGEM+aROD[4]        // DATA DE EMISSAO DO CERTIFICADO
         // COMPLEMENTO
         mCOMPL := ""
         mCOMPL := mCOMPL+REPLICATE(ENTER,2)  // LINHAS EM BRANCO ENTRE DET E COMPL
         mCOMPL := mCOMPL+MARGEM+SPACE(75)+TRANSFORM(aCAB[7],AVSX3("EEC_NRINVO",AV_PICTURE))+ENTER  // NUMERO DA INVOICE
         mCOMPL := mCOMPL+MARGEM+SPACE(42)+aROD[2]+ENTER  // INSTRUMENTO DE NEGOCIACAO
         mCOMPL := mCOMPL+REPLICATE(ENTER,4)  // LINHAS EM BRANCO ENTER O COMPL E AS NORMAS
         // DETALHES
         lRet := COIMP(mDET,mROD,MARGEM,1,mCOMPL)

         If lRet
            HEADER_P->(RecLock("HEADER_P",.f.))
            HEADER_P->AVG_C01_10 := cParam
            HEADER_P->(MsUnlock())
         EndIf
         
      ENDIF
   ENDIF
ENDIF
RESTORD(aOrd)
RETURN(lRET)

*-------------------*
USER FUNCTION PEM59()
*-------------------*

// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem

TMP->ORDEM     := TMP->TMP_ORIGEM
TMP->COD_NALAD := TRANSFORM(TMP->EE9_NALSH,AVSX3("EE9_NALSH",AV_PICTURE))
TMP->DESCRICAO := ALLTRIM(STRTRAN(MEMOLINE(TMP->TMP_DSCMEM,LENCOL3,1),ENTER,""))

RETURN(NIL)
*--------------------------------------------------------------------
