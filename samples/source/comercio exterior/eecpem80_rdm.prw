#include "EECRDM.CH"
#INCLUDE "EECPEM80.ch"

#define MARGEM     Space(03)
#DEFINE LENCON1    08
#DEFINE LENCON2    93
#define TOT_NORMAS 06
#define LENCOL1    10
#define LENCOL2    12
#define LENCOL3    78
#define TOT_ITENS  09  //10
#DEFINE TAMOBS     80  //tamanho máximo para gravação na tabela EX0

/*
Programa        : EECPEM80_RDM.PRW
Objetivo        : Certificado de Origem Méxixo
Autor           : Wilsimar Fabrício da Silva
Data/Hora       : 14/10/2009
Obs.            : Reutilização do programa EECPEM72_RDM, Aladi FIEP, para atender o cliente Milênia
Revisão         : 
*/
USER FUNCTION EECPEM80

Local cParam := If(Type("ParamIxb") = "A", ParamIxb[1], ParamIxb)

Local mDET,mROD,mCOMPL,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1", "SYA"}),;
      aLENCOL := {{"ORDEM"    ,LENCOL1,"C",STR0001 },; //"Ordem"
                  {"COD_NALAD",LENCOL2,"C",STR0002 },; //"Cod.NALADI/SH"
                  {"DESCRICAO",LENCOL3,"M",STR0003 }}  //"Descricao"
      aLENCON := {{"ORDEM"    ,LENCON1,"C",STR0001 },; //"Ordem"
                  {"DESCRICAO",LENCON2,"C",STR0004 }}  //"Normas de Origem"
                  
Private cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}

Begin Sequence

   If !COVeri("MEX")
      Break
   EndIf

   If CODet(aLENCOL, aLENCON, "EE9_NALSH", TOT_NORMAS, "PEM80", TOT_ITENS,,, "B2") //Detalhes; B2-Fiep México

      aCAB    := COCAB()       // CABECALHO
      aROD    := COROD(TAMOBS) // RODAPE

      // EDICAO DOS DADOS
      If COTELAGETS(STR0005,"B2") //Fiep México

         // IMPORTADOR
         mDET := ""
         mDET := mDET+Replicate(ENTER,12)               // LINHAS EM BRANCO
         mDET := mDET+MARGEM+Space(50)+aCAB[2,4]+ENTER  // Pais do importador 
         mDET := mDET+Replicate(ENTER,3)

         // COMPLEMENTO
         mCOMPL:= ""
         mCOMPL:= mCOMPL+Replicate(ENTER,1)  // LINHAS EM BRANCO ENTRE DET E COMPL
         mCOMPL:= mCOMPL+MARGEM+Space(92)+Transform(aCAB[7],AVSX3("EEC_NRINVO",AV_PICTURE)) + ENTER  // NUMERO DA INVOICE
         mCOMPL:= mCOMPL+Replicate(ENTER,5)  // LINHAS EM BRANCO ENTER O COMPL E AS NORMAS

         // EXPORTADOR
         mROD := ""
         //Data por extenso         
         mRod:= mRod + MARGEM +Space(04)+ Str(Day(CtoD(aRod[5])), 2) + " DE " + AllTrim(Upper(MesExtenso(Month(CtoD(aRod[5]))))) +;
                " DE " + Str(Year(CtoD(aRod[5])), 4)         
         //Data no formato DD/MM/AA
         //mROD := mROD+MARGEM+Space(08)+aROD[5]+ENTER
         mROD := mROD+Replicate(ENTER,2)              // LINHAS EM BRANCO
         mROD := mRod+MARGEM+aCAB[1,1]                // Nome do Exportador
         
         //OBSERVAÇÕES
         mRod := mRod+Replicate(ENTER,4)              // LINHAS EM BRANCO
         mROD := mROD+MARGEM+aROD[1,1]+ENTER          // LINHA 1 DA OBS.
         mROD := mROD+MARGEM+aROD[1,2]+ENTER          // LINHA 2 DA OBS.
         mROD := mROD+MARGEM+aROD[1,3]+ENTER          // LINHA 3 DA OBS.
         mROD := mROD+MARGEM+aROD[1,4]+ENTER          // LINHA 4 DA OBS.
         
         // IMPRESSÃO
         lRet := COIMP(mDET,mROD,MARGEM,1,mCOMPL)

         If lRet
            HEADER_P->(RecLock("HEADER_P",.f.))
            HEADER_P->AVG_C01_10 := cParam
            HEADER_P->(MsUnlock())
         EndIf
         
      EndIf
   EndIf

End Sequence

Restord(aOrd)
Return lRet

*-------------------*
User Function PEM80()
*-------------------*

// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem

TMP->ORDEM     := TMP->TMP_ORIGEM
TMP->COD_NALAD := Transform(TMP->EE9_NALSH,AVSX3("EE9_NALSH",AV_PICTURE))
TMP->DESCRICAO := AllTrim(StrTran(MemoLine(TMP->TMP_DSCMEM,LENCOL3,1),ENTER,""))

Return(Nil)