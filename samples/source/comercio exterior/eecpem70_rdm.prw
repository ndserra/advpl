/*
Programa   : EECPEM70_RDM.PRW
Objetivo   : Certificado de Origem - Mercosul - FIEP
Autor      : Julio de Paula Paz
Data/Hora  : 07/06/2006 16:00
Obs.       : Considera que esta posicionado no registro de processos (embarque) (EEC)
Revisão    : Fabrício e Diogo - 22/10/2009.
             Atualização do Layout para a Versão 5 e padronização para quatro linhas nos campos 
             1.Produtor/ Exportador, 2.Importador e 3.Consignatário quando ativar o parâmetro MV_AVG0033.
*/
#include "EECRDM.CH"
#INCLUDE "EECPEM70.CH"

#define MARGEM     Space(05)
#DEFINE LENCON1    10
#DEFINE LENCON2    93
#define TOT_NORMAS 06
#define LENCOL1    09
#define LENCOL2    12
#define LENCOL3    60
#define LENCOL4    16
#define LENCOL5    14
#define TOT_ITENS  09
#DEFINE TAMOBS     80 //Tamanho máximo para gravação na tabela EX0

*--------------------*
User Function EECPEM70
*--------------------*
Local cParam := If(Type("ParamIxb") = "A" , ParamIxb[1],"")

LOCAL mDET,mROD,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1"}),;
      aLENCOL := {{"ORDEM"    ,LENCOL1,"C",STR0001},;  //"Ordem"
                  {"COD_NCM"  ,LENCOL2,"C",STR0002},;  //"Cod.NALADI/SH"
                  {"DESCRICAO",LENCOL3,"M",STR0003},;  //"Descricao"
                  {"PESO_QTDE",LENCOL4,"C",STR0004},;  //"Peso Liq. ou Qtde."
                  {"VALOR_FOB",LENCOL5,"C",STR0005}},; //"Valor Fob em Dolar"
      aLENCON := {{"ORDEM"    ,LENCON1,"C",STR0001},;  //"Ordem"
                  {"DESCRICAO",LENCON2,"C",STR0006}}   //"Normas de Origem"

PRIVATE cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}
*
IF COVERI("MER")
   IF CODET(aLENCOL,aLENCON,"EE9_POSIPI",TOT_NORMAS,"PEM70",TOT_ITENS,,,"1") // DETALHES
   
      aCAB := COCAB()       // CABECALHO
      aROD := COROD(TAMOBS) // RODAPE

      // EDICAO DOS DADOS
      IF COTELAGETS(STR0007, "B") // FIEP - Mercosul

         // EXPORTADOR
         mDET := ""
         mDET := mDET+REPLICATE(ENTER,4)
         mDET := mDET+MARGEM+aCAB[1,1]+ENTER
         mDET := mDET+MARGEM+aCAB[1,2]+ENTER
         mDET := mDET+MARGEM+aCAB[1,3]+ENTER
         mDET := mDET+MARGEM+aCAB[1,5]+ENTER //wfs 22/10/09

         // IMPORTADOR
         mDET := mDET+REPLICATE(ENTER,2)
         mDET := mDET+MARGEM+aCAB[2,1]+ENTER
         mDET := mDET+MARGEM+aCAB[2,2]+ENTER
         mDET := mDET+MARGEM+aCAB[2,3]+ENTER
         mDET := mDET+MARGEM+aCAB[2,5]+ENTER //wfs 22/10/09

         // CONSIGNATARIO
         mDET := mDET+REPLICATE(ENTER,2)
         mDET := mDET+MARGEM+aCAB[3,1]+ENTER
         mDET := mDET+MARGEM+aCAB[3,2]+ENTER
         mDET := mDET+MARGEM+aCAB[3,3]+ENTER //wfs 22/10/09
         mDET := mDET+MARGEM+aCAB[3,4]+ENTER //wfs 22/10/09
         
         // PORTO OU LOCAL DE EMBARQUE / PAIS DE DESTINO DAS MERCADORIAS
         mDET := mDET+REPLICATE(ENTER,3)
         mDET := mDET+MARGEM+aCAB[4]+SPACE(11)+;
                             aCAB[5]+ENTER

         // VIA DE TRANSPORTE / N.FATURA / DATA DA FATURA
         mDET := mDET+REPLICATE(ENTER,5)
         mDET := mDET+MARGEM+aCAB[6]+SPACE(16)+;
                             aCAB[7]+SPACE(07)+;
                             aCAB[8]+ENTER
         mDET := mDET+REPLICATE(ENTER,5)

         // RODAPE
         mROD := ""+ENTER
         
         mROD := mROD+MARGEM+aROD[1,1]+ENTER  // LINHA 1 DA OBS.
         mROD := mROD+MARGEM+aROD[1,2]+ENTER  // LINHA 2 DA OBS.
         mROD := mROD+MARGEM+aROD[1,3]+ENTER  // LINHA 3 DA OBS.
         mROD := mROD+MARGEM+aROD[1,4]+ENTER  // LINHA 4 DA OBS.
         mROD := mROD+REPLICATE(ENTER,12)     // LINHAS EM BRANCO
      
         //mROD := mROD+cMargem+Space(06)+aROD[2]+REPLICATE(ENTER,02)   // INSTRUMENTO DE NEGOCIACAO
         
         //Data por extenso         
         mRod:= mRod + MARGEM +Space(06)+ Str(Day(CtoD(aRod[5])), 2) + " DE " + AllTrim(Upper(MesExtenso(Month(CtoD(aRod[5]))))) +;
                " DE " + Str(Year(CtoD(aRod[5])), 4)
         
         //Data no formato DD/MM/AA
         // mROD := mROD+MARGEM+Space(08)+aROD[5]+ENTER //DATA DE EMISSAO

         mROD := mROD+REPLICATE(ENTER,12)
         
         // DETALHES
         lRET := COIMP(mDET,mROD,MARGEM,03)
         
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



USER FUNCTION PEM70()
// Estrutura do parâmetro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Número da Ordem
// 2. Posicao em diante = Número dos registro que estão relacionados na ordem
LOCAL cPictPeso  := "@E 9,999,999"+if(EEC->EEC_DECPES > 0, "."+REPLICATE("9",EEC->EEC_DECPES),""),;
      cPictPreco := AVSX3("EE9_PRCTOT",AV_PICTURE)

TMP->ORDEM     := TMP->TMP_ORIGEM
TMP->COD_NCM   := TRANSFORM(TMP->EE9_POSIPI,AVSX3("EE9_POSIPI",AV_PICTURE))
TMP->PESO_QTDE := PADL(ALLTRIM(TRANSFORM(TMP->TMP_PLQTDE,cPICTPESO)) ,LENCOL4," ")
TMP->VALOR_FOB := PADL(ALLTRIM(TRANSFORM(TMP->TMP_VALFOB,cPICTPRECO)),LENCOL5," ")
TMP->DESCRICAO := TMP->TMP_DSCMEM

RETURN(NIL)
