#INCLUDE "EECPEM13.ch"

/*
Programa        : EECPEM13.PRW
Objetivo        : Certificado de Origem - Aladi
Autor           : Cristiano A. Ferreira
Data/Hora       : 14/01/2000
considera que estah posicionado no registro de embarque (EEC)
*/
#include "EECRDM.CH"
#define MARGEM     Space(10)
#DEFINE LENCON1    06
#DEFINE LENCON2    99
#define TOT_NORMAS 07
#define LENCOL1    06
#define LENCOL2    20
#define LENCOL3    80
#define TOT_ITENS  15
#DEFINE TAMOBS     99
*--------------------------------------------------------------------
USER FUNCTION EECPEM13
LOCAL mDET,mROD,mCOMPL,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1"}),;
      aLENCOL := {{"ORDEM"    ,LENCOL1,"C",STR0001             },; //"Ordem"
                  {"COD_NALAD",LENCOL2,"C",STR0002     },; //"Cod.NALADI/SH"
                  {"DESCRICAO",LENCOL3,"M",STR0003         }} //"Descricao"
      aLENCON := {{"ORDEM"    ,LENCON1,"C",STR0001           },; //"Ordem"
                  {"DESCRICAO",LENCON2,"C",STR0004}} //"Normas de Origem"
PRIVATE cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}
*
IF COVERI("ALA")
   IF CODET(aLENCOL,aLENCON,"EE9_NALSH",TOT_NORMAS,"PEM13",TOT_ITENS) // DETALHES
      aCAB    := COCAB()        // CABECALHO
      aROD    := COROD(TAMOBS) // RODAPE
      aROD[4] := STR(DAY(dDATABASE),2)+SPACE(13)+PADR(UPPER(MESEXTENSO(MONTH(dDATABASE))),20)+SPACE(06)+STR(YEAR(dDATABASE),4) // DATA DE EMISSAO DO CERTIFICADO
      // EDICAO DOS DADOS
      IF COTELAGETS(STR0005,"2") //"Aladi"
          // EXPORTADOR
          mDET := ""
          mDET := mDET+REPLICATE(ENTER,06)               // LINHAS EM BRANCO
          mDET := mDET+MARGEM+SPACE(82)+aCAB[2,4]+ENTER  // PAIS DO EXPORTADOR
          mDET := mDET+REPLICATE(ENTER,3)
          // RODAPE
          mROD := ""
          mROD := mROD+MARGEM+SPACE(09)+aROD[5]+ENTER  // DATA DA IMPRESSAO DO CERTIFICADO
          mROD := mROD+REPLICATE(ENTER,6)              // LINHAS EM BRANCO
          mROD := mROD+MARGEM+aROD[1,1]+ENTER          // LINHA 1 DA OBS.          
          mROD := mROD+MARGEM+aROD[1,2]+ENTER          // LINHA 2 DA OBS.
          mROD := mROD+REPLICATE(ENTER,4)              // LINHAS EM BRANCO
          mROD := mROD+MARGEM+SPACE(15)+aROD[4]        // DATA DE EMISSAO DO CERTIFICADO
          // COMPLEMENTO
          mCOMPL := ""
          mCOMPL := mCOMPL+REPLICATE(ENTER,2)  // LINHAS EM BRANCO ENTRE DET E COMPL
          mCOMPL := mCOMPL+MARGEM+SPACE(13)+TRANSFORM(aCAB[7],AVSX3("EEC_NRINVO",AV_PICTURE))+ENTER  // NUMERO DA INVOICE
          mCOMPL := mCOMPL+MARGEM+SPACE(13)+aROD[2]+ENTER  // INSTRUMENTO DE NEGOCIACAO
          mCOMPL := mCOMPL+REPLICATE(ENTER,4)  // LINHAS EM BRANCO ENTER O COMPL E AS NORMAS
         // DETALHES
         lRET := COIMP(mDET,mROD,MARGEM,2,mCOMPL)
      ENDIF
   ENDIF
ENDIF
RESTORD(aOrd)
RETURN(lRET)
*--------------------------------------------------------------------
USER FUNCTION PEM13()
*
// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem
TMP->ORDEM     := TMP->TMP_ORIGEM
TMP->COD_NALAD := TRANSFORM(TMP->EE9_NALSH,AVSX3("EE9_NALSH",AV_PICTURE))
TMP->DESCRICAO := ALLTRIM(STRTRAN(MEMOLINE(TMP->TMP_DSCMEM,LENCOL3,1),ENTER,""))
RETURN(NIL)
*--------------------------------------------------------------------
