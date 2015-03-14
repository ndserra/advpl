/*
Programa        : EECPEM72_RDM.PRW
Objetivo        : Certificado de Origem - Aladi - FIEP
Autor           : Julio de Paula Paz
Data/Hora       : 08/06/2006 - 17:00
Obs.            : considera que esta posicionado no registro de embarque (EEC)
Revisão         : Fabrício e Diogo - 22/10/2009.
                  Atualização do layout para a versão 5.
*/
#include "EECRDM.CH"
#INCLUDE "EECPEM72.ch"

#define MARGEM     Space(03)
#DEFINE LENCON1    08
#DEFINE LENCON2    93
#define TOT_NORMAS 06
#define LENCOL1    08
#define LENCOL2    13
#define LENCOL3    78
#define TOT_ITENS  09  //10
#DEFINE TAMOBS     80  //tamanho máximo para gravação na tabela EX0
*---------------------*
USER FUNCTION EECPEM72
*---------------------*
Local cParam := If(Type("ParamIxb") = "A" , ParamIxb[1],"")

Local mDET,mROD,mCOMPL,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"EE9","EEI","SB1","SA2","SA1"}),;
      aLENCOL := {{"ORDEM"    ,LENCOL1,"C",STR0001 },; //"Ordem"
                  {"COD_NALAD",LENCOL2,"C",STR0002 },; //"Cod.NALADI/SH"
                  {"DESCRICAO",LENCOL3,"M",STR0003 }} //"Descricao"
      aLENCON := {{"ORDEM"    ,LENCON1,"C",STR0001 },; //"Ordem"
                  {"DESCRICAO",LENCON2,"C",STR0004 }} //"Normas de Origem"
                  
Private cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}
*
IF COVERI("ALA")

   If CODet(aLENCOL, aLENCON, "EE9_NALSH", TOT_NORMAS, "PEM72", TOT_ITENS,,, "B") //Detalhes; B-Fiep
      aCAB    := COCAB()       // CABECALHO
      aROD    := COROD(TAMOBS) // RODAPE

      // EDICAO DOS DADOS
      // B2: Fiep Aladi e México
      If COTELAGETS(STR0005, "B2") //Aladi

         // IMPORTADOR
         mDET := ""
         mDET := mDET+Replicate(ENTER,12)               // LINHAS EM BRANCO
         mDET := mDET+MARGEM+Space(50)+aCAB[2,4]+ENTER  // Pais do inportador 
         mDET := mDET+Replicate(ENTER,3)

         // COMPLEMENTO
         mCOMPL := ""
         mCOMPL := mCOMPL+Replicate(ENTER,1)  // LINHAS EM BRANCO ENTRE DET E COMPL
         mCOMPL := mCOMPL+MARGEM+Space(92)+Transform(aCAB[7],AVSX3("EEC_NRINVO",AV_PICTURE))+ENTER  // NUMERO DA INVOICE
         mCOMPL := mCOMPL+Replicate(ENTER,5)  // LINHAS EM BRANCO ENTER O COMPL E AS NORMAS

         // EXPORTADOR
         mROD := ""

         // DATA DA IMPRESSAO DO CERTIFICADO
         //Data por extenso
         mRod:= mRod + MARGEM + Space(4)+Str(Day(CtoD(aRod[5])), 2) + " DE " + AllTrim(Upper(MesExtenso(Month(CtoD(aRod[5]))))) +;
                " DE " + Str(Year(CtoD(aRod[5])), 4)
         
         //Data no formato DD/MM/AA
        // mROD := mROD+MARGEM+Space(04)+aROD[5] + ENTER //DATA DE EMISSAO

         mROD := mROD+Replicate(ENTER,2)              // LINHAS EM BRANCO
         mROD := mRod+MARGEM+aCAB[1,1]                // Nome do Exportador

         mRod := mRod+Replicate(ENTER,4)              // LINHAS EM BRANCO
         mROD := mROD+MARGEM+aROD[1,1]+ENTER          // LINHA 1 DA OBS.          
         mROD := mROD+MARGEM+aROD[1,2]+ENTER          // LINHA 2 DA OBS.
         mROD := mROD+MARGEM+aROD[1,3]+ENTER          // LINHA 3 DA OBS.          
         mROD := mROD+MARGEM+aROD[1,4]+ENTER          // LINHA 4 DA OBS.
         
         mROD := mROD+Replicate(ENTER, 6)             // LINHAS EM BRANCO

         // IMPRESSÃO
         lRet := COIMP(mDET,mROD,MARGEM,1,mCOMPL)

         If lRet
            HEADER_P->(RecLock("HEADER_P",.f.))
            HEADER_P->AVG_C01_10 := cParam
            HEADER_P->(MsUnlock())
         EndIf
         
      EndIf
   EndIf
EndIf
Restord(aOrd)
Return(lRET)

*-------------------*
User Function PEM72()
*-------------------*

// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem

TMP->ORDEM     := TMP->TMP_ORIGEM
TMP->COD_NALAD := Transform(TMP->EE9_NALSH,AVSX3("EE9_NALSH",AV_PICTURE))
TMP->DESCRICAO := AllTrim(StrTran(MemoLine(TMP->TMP_DSCMEM,LENCOL3,1),ENTER,""))

Return(Nil)
*--------------------------------------------------------------------
