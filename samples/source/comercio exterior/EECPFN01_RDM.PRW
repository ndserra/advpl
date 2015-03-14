#INCLUDE "EECPFN01.ch"

/*
Programa        : EECPFN01.PRW
Objetivo        : Impressao do Follow-up de Letter of Credit
Autor           : Cristiano A. Ferreira
Data/Hora       : 10/11/1999 10:12
Obs.            :
*/

#include "EECRDM.CH"

/*
Funcao      : EECPFN01
Parametros  : 
Retorno     : 
Objetivos   : Follow-up
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        : // Convertido por CCF em 27.06.00 as 15:41
*/
User Function EECPFN01
// Inicializa variaveis utilizadas ...
LOCAL aOrd := SaveOrd("EEL")

LOCAL cFileRpt:= "FW0003"
LOCAL nTipo := nil , dDataIni := nil , dDataFim := nil, mv_ch1 := 1

LOCAL bWhile := {|| .t.}


cSeqRel := nil

While .T.
   mv_ch1 := 1
      
   IF ! Pergunte("FW0003",.T.)
      Exit
   Endif
   
   // Variaveis definidas na Pergunte
   // nTipo    := 1-A Vencer
   //             2-A Negociar
   //             3-A Embarcar
   // dDataIni := Data Inicial 
   // dDataFim := Data Final
   
   nTipo    := mv_par01
   dDataIni := mv_par02
   dDataFim := mv_par03
   
   do Case 
      Case nTipo == 1
         bWhile := {|| Empty(dDataFim) .Or. EEL->EEL_DT_VEN <= dDataFim }
      Case nTipo == 2
         bWhile := {|| Empty(dDataFim) .Or. EEL->EEL_DT_NEG <= dDataFim }
      Case nTipo == 3
         bWhile := {|| Empty(dDataFim) .Or. EEL->EEL_DT_EMB <= dDataFim }
   OtherWise
      MsgInfo(STR0001,STR0002) //"Opção de Filtro inválida !"###"Aviso"
      Loop
   End Case
   
   EEL->(dbSetOrder(nTipo+1))
   EEL->(dbSeek(xFilial()+Dtos(dDataIni),.T.))
   
   IF Select("Header_p") = 0   // TLM 30/10/2007 Verifica se o header_p está fechado.
      AbreEEC()
   EndIf
   
   cSeqRel := GetSXENum("SY0","Y0_SEQREL")
   ConfirmSX8()
   HEADER_P->(dbAppend())
   HEADER_P->AVG_CHAVE  := cSeqRel
   HEADER_P->AVG_SEQREL := cSeqRel
   HEADER_P->AVG_C01_10 := Str(nTipo,1) 
   HEADER_P->AVG_C01_60 := IF(!Empty(dDataIni).Or.!Empty(dDataFim),STR0003+Dtoc(dDataIni)+STR0004+Dtoc(dDataFim),"") //"Intervalo: "###" a "
   HEADER_P->(dbUnlock())
      
   While EEL->(!Eof() .And. EEL_FILIAL==xFilial("EEL")) 
      SysRefresh()
      
      // Verifica a data final ...
      IF ! Eval(bWhile)
         Exit                       
      Endif
      
      DETAIL_P->(dbAppend())
      DETAIL_P->AVG_CHAVE  := cSeqRel      
      DETAIL_P->AVG_SEQREL := cSeqRel
      DETAIL_P->AVG_C01_20 := EEL->EEL_LC_NUM // Nro. Carta de Credito
      DETAIL_P->AVG_C01_10 := DTOC(EEL->EEL_DT_EMI) // Dt.Emissao
      DETAIL_P->AVG_C02_10 := DTOC(EEL->EEL_DT_VEN) // Dt.Venc.
      DETAIL_P->AVG_C03_10 := DTOC(EEL->EEL_DT_NEG) // Dt.Negociacao
      DETAIL_P->AVG_C04_10 := DTOC(EEL->EEL_DT_EMB) // Dt.Embarque
      DETAIL_P->AVG_C02_20 := EEL->EEL_MOEDA+" "+Transform(EEL->EEL_LCVL,"@E 999,999,999.99") // Valor da Carta
      DETAIL_P->AVG_C02_60 := EEL->EEL_MOEDA+" "+Transform(EEL->EEL_LCVL,"@E 999,999,999.99") // Valor da Carta
      DETAIL_P->(dbUnlock())
      
      EEL->(dbSkip())
   Enddo                         
                          
   IF Empty(cSeqRel)
      HELP(" ",1,"AVG0000063")
      Loop
   Endif

   HEADER_P->(dbCommit())
   
   
   AvgCrw32(cFileRpt,STR0005,cSeqRel) //"Follow-up de Carta de Crédito"

   Exit
Enddo

RestOrd(aOrd)

Return (NIL)

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPFN01.PRW                                                 *
*------------------------------------------------------------------------------*

