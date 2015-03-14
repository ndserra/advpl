/*
Programa :	EFFPPF00.PRW
Objetivo :	Calculo de Valor US$ automatico
Autor    :	Heder M Oliveira 
Data/Hora:	28/04/99 18:21
*/


#include "EFFRDM.CH"
#include "Average.ch"

User Function Effppf00()

   If ! EMPTY(M->WG_DT_DESE) .AND. M->WG_VL_USS == 0 .AND. ! EMPTY(M->WG_VL_DESE) .AND. M->WG_MOE_DES#'US$'
   	   M->WG_VL_USS := M->WG_VL_DESE*(BuscaTaxa(M->WG_MOE_DES,M->WG_DT_DESE)/ ;
                                      BuscaTaxa(cMoedaUSS,M->WG_DT_DESE))
   	   M->WG_VL_DEVE:= M->WG_VL_USS
   ElseIf M->WG_MOE_DES=='US$'
      M->WG_VL_USS := M->WG_VL_DESE
      M->WG_VL_DEVE:= M->WG_VL_USS
   EndIf
   
Return(NIL)
