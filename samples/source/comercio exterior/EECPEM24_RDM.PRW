#INCLUDE "EECPEM24.ch"

/*
Programa        : EECPEM24.PRW
Objetivo        : Certificado de Origem - Mercosul
Autor           : Cristiano A. Ferreira
Data/Hora       : 18/01/2000 14:19
Obs.            : 
     considera que estah posicionado no registro de processos (embarque) (EEC)
*/
#include "EECRDM.CH"
#INCLUDE "EECPEM24.CH"
#define MARGEM    " "  // SPACE(01)
#DEFINE LENCON1    10
#DEFINE LENCON2    93
#define TOT_NORMAS 04
#define LENCOL1    10
#define LENCOL2    20
#define LENCOL3    45
#define LENCOL4    17
#define LENCOL5    17
#define TOT_ITENS  14
#DEFINE TAMOBS     93
*--------------------------------------------------------------------
User Function EECPEM24
LOCAL mDET,mROD,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1"}),;
      aLENCOL := {{"ORDEM"    ,LENCOL1,"C",STR0001             },; //"Ordem"
                  {"COD_NCM"  ,LENCOL2,"C",STR0002     },; //"Cod.NALADI/SH"
                  {"DESCRICAO",LENCOL3,"M",STR0003         },; //"Descricao"
                  {"PESO_QTDE",LENCOL4,"C",STR0004},; //"Peso Liq. ou Qtde."
                  {"VALOR_FOB",LENCOL5,"C",STR0005}},; //"Valor Fob em Dolar"
      aLENCON := {{"ORDEM"    ,LENCON1,"C",STR0001           },; //"Ordem"
                  {"DESCRICAO",LENCON2,"C",STR0006}} //"Normas de Origem"
PRIVATE cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}
*
IF COVERI("MER")
   IF CODET(aLENCOL,aLENCON,"EE9_POSIPI",TOT_NORMAS,"PEM24",TOT_ITENS,,,"1") // DETALHES
      aCAB := COCAB()       // CABECALHO
      aROD := COROD(TAMOBS) // RODAPE
      // EDICAO DOS DADOS
      IF COTELAGETS(STR0007) //"Mercosul"
         // EXPORTADOR
         mDET := ""
         mDET := mDET+REPLICATE(ENTER,8)
         mDET := mDET+MARGEM+aCAB[1,1]+ENTER
         mDET := mDET+MARGEM+aCAB[1,2]+ENTER
         mDET := mDET+MARGEM+aCAB[1,3]+ENTER
         // IMPORTADOR
         mDET := mDET+REPLICATE(ENTER,2)
         mDET := mDET+MARGEM+aCAB[2,1]+ENTER
         mDET := mDET+MARGEM+aCAB[2,2]+ENTER
         mDET := mDET+MARGEM+aCAB[2,3]+ENTER
         // CONSIGNATARIO
         mDET := mDET+REPLICATE(ENTER,3)
         mDET := mDET+MARGEM+aCAB[3,1]+ENTER
         mDET := mDET+MARGEM+aCAB[3,2]+ENTER
         // PORTO OU LOCAL DE EMBARQUE / PAIS DE DESTINO DAS MERCADORIAS
         mDET := mDET+REPLICATE(ENTER,1)
         mDET := mDET+MARGEM+aCAB[4]+SPACE(02)+;
                             aCAB[5]+ENTER
         // VIA DE TRANSPORTE / N.FATURA / DATA DA FATURA
         mDET := mDET+REPLICATE(ENTER,2)
         mDET := mDET+MARGEM+aCAB[6]+SPACE(15)+;
                             aCAB[7]+SPACE(07)+;
                             aCAB[8]+ENTER
         mDET := mDET+REPLICATE(ENTER,3)
         // RODAPE
         mROD := ""
         mROD := mROD+MARGEM+aROD[1,1]+ENTER  // LINHA 1 DA OBS.
         mROD := mROD+MARGEM+aROD[1,2]+ENTER  // LINHA 2 DA OBS.
         mROD := mROD+MARGEM+aROD[1,3]+ENTER  // LINHA 3 DA OBS.
         mROD := mROD+MARGEM+aROD[1,4]+ENTER  // LINHA 4 DA OBS.
         mROD := mROD+REPLICATE(ENTER,8)      // LINHAS EM BRANCO
         mROD := mROD+MARGEM+aROD[2]+ENTER    // INSTRUMENTO DE NEGOCIACAO
         mROD := mROD+MARGEM+aROD[3]+ENTER    // NOME DO EXPORTADOR
         mROD := mROD+MARGEM+aROD[4]+ENTER    // MUNICIPIO/DATA DE EMISSAO
         // DETALHES
         lRET := COIMP(mDET,mROD,MARGEM,2)
      ENDIF
   ENDIF
ENDIF
RESTORD(aOrd)
RETURN(lRET)
*--------------------------------------------------------------------
USER FUNCTION PEM24()
// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem
LOCAL cPictPeso  := "@E 9,999,999"+if(EEC->EEC_DECPES > 0, "."+REPLICATE("9",EEC->EEC_DECPES),""),;
      cPictPreco := AVSX3("EE9_PRCTOT",AV_PICTURE)

TMP->ORDEM     := TMP->TMP_ORIGEM
TMP->COD_NCM   := TRANSFORM(TMP->EE9_POSIPI,AVSX3("EE9_POSIPI",AV_PICTURE))
TMP->DESCRICAO := TMP->TMP_DSCMEM
TMP->PESO_QTDE := PADL(ALLTRIM(TRANSFORM(TMP->TMP_PLQTDE,cPICTPESO)) ,LENCOL4," ")
TMP->VALOR_FOB := PADL(ALLTRIM(TRANSFORM(TMP->TMP_VALFOB,cPICTPRECO)),LENCOL5," ")
RETURN(NIL)
*--------------------------------------------------------------------
