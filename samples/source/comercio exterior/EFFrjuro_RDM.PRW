
/*
Programa        : EFFRJURO
Objetivo        : Calcular valor dos juros
Autor           : Heder M Oliveira
Data/Hora       : 19/02/99 16:47
Obs.            :
*/
#include "EFFRDM.CH" 
#include "Average.ch"

User Function Effrjuro

   M->WL_VL_JURO:=(M->WL_VL_DEVE * M->WL_DIAS *(M->WG_SPREAD+M->WL_TXLIBOR))/36000
   
Return NIL
