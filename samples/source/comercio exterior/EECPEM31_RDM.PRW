#INCLUDE "EECPEM31.ch"

/*
Programa        : EECPEM31.PRW
Objetivo        : Carta Remessa AO IMPORTADOR
Autor           : Cristiano A. Ferreira
Data/Hora       : 07/12/1999
Obs.            :  
*/

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"
  
/*
Funcao      : EECPEM31
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
User Function EECPEM31

Local lRet := .f.
Local cEXP_NOME,mDetalhe

Private cAssinante := Space(40)
//USADO NO EECF3EE3 VIA SXB "E34" PARA GET ASSINANTE
M->cSEEKEXF:=""
M->cSEEKLOJA:=""

Begin Sequence

   //regras para carregar dados
   IF !EMPTY(EEC->EEC_EXPORT)
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      M->cSEEKEXF  :=EEC->EEC_EXPORT
      M->cSEEKLOJA :=EEC->EEC_EXLOJA
   ELSE
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME") 
      M->cSEEKEXF  :=EEC->EEC_FORN
      M->cSEEKLOJA :=EEC->EEC_FOLOJA
   ENDIF

   IF !TelaGets()
      Break
   Endif

   IF ! E_AVGLTT("G")
      Break
   Endif
           
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C01_60:=cEXP_NOME
   AVGLTT->AVG_C02_60:= "HEAD OFFICE: "+SA2->A2_END
   AVGLTT->AVG_C03_60:= STR0001+SA2->A2_CEP+" - "+ALLTRIM(SA2->A2_MUN)+" - "+; //"CEP "
           ALLTRIM(Posicione("SYA",1,xFilial("SA2")+SA2->A2_PAIS,"YA_DESCR"))
   AVGLTT->AVG_C04_60:= SA2->("PHONE: "+ALLTRIM(A2_TEL)+" FAX: "+ALLTRIM(A2_FAX))

   mDetalhe:= ENTER+ENTER
   
   mDetalhe:= mDetalhe+"SAO PAULO "+Upper(cMonth(dDataBase))+" "+AllTrim(Str(Day(dDataBase)))+", "+Str(Year(dDataBase),4)+ENTER
   mDetalhe:= mDetalhe+ENTER+ENTER
   mDetalhe:= mDetalhe+EEC->EEC_IMPODE+ENTER
   mDetalhe:= mDetalhe+EEC->EEC_ENDIMP+ENTER
   mDetalhe:= mDetalhe+EEC->EEC_END2IM+ENTER
   mDetalhe:= mDetalhe+ENTER+ENTER
   mDetalhe:= mDetalhe+"REF: O/ORDER NBR.: "+EEC->EEC_PREEMB+ENTER
   mDetalhe:= mDetalhe+"     L/C BR "+EEC->EEC_LC_NUM+ENTER
   mDetalhe:= mDetalhe+"     REF. "+EEC->EEC_REFIMP+ENTER
   mDetalhe:= mDetalhe+ENTER+ENTER
   mDetalhe:= mDetalhe+"DEAR SIRS,"+ENTER
   mDetalhe:= mDetalhe+ENTER+ENTER
   mDetalhe:= mDetalhe+"PLEASE FIND ATTACHED THE FOLLOWING DOCUMENTS: "+ENTER
   mDetalhe:= mDetalhe+ENTER
   mDetalhe:= mDetalhe+"- (1) ORIGINAL   (3) COPY - COMMERCIAL INVOICE NBR "+EEC->EEC_NRINVO+ENTER
   mDetalhe:= mDetalhe+"- (3) ORIGINAL   (3) COPY - ROADWAY BILL NBR. "+EEC->EEC_NRCONH+ENTER
   mDetalhe:= mDetalhe+"- (1) ORIGINAL   (3) COPY - PACKING LIST"+ENTER
   mDetalhe:= mDetalhe+"- (-) ORIGINAL   (-) COPY - CERTIFICATE OF INSURANCE NBR "+EEC->EEC_NRCTSG+ENTER
   mDetalhe:= mDetalhe+"- (1) ORIGINAL   (2) COPY - CERTIFICATE OF ORIGIN NBR "+EEC->EEC_NRCTOR+ENTER
   mDetalhe:= mDetalhe+'- (-) ORIGINAL   (-) COPY - CERT. ORIGIN "FORM A " NBR '+ENTER
   mDetalhe:= mDetalhe+"- (1) ORIGINAL   (-) COPY - CERTIFICATE OF ANALYSIS"+ENTER
   mDetalhe:= mDetalhe+"- (-) ORIGINAL   (-) COPY - MATERIAL SAETY DATA SHEET"+ENTER
   mDetalhe:= mDetalhe+"- (-) ORIGINAL   (-) COPY - CARGO MANIFEST"+ENTER
   mDetalhe:= mDetalhe+ENTER+ENTER
   mDetalhe:= mDetalhe+"WE REMAIN,"+ENTER
   mDetalhe:= mDetalhe+"YOUR FAITHFULLY"+ENTER
   mDetalhe:= mDetalhe+ENTER+ENTER
   mDetalhe:= mDetalhe+cAssinante
   
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet:=E_AVGLTT("M",WORKID->EEA_TITULO)
   
End Sequence

Return lRet

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.

Local bOk  :=  {|| lRet := .t., oDlg:End() }
Local bCancel := {|| oDlg:End()}

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 9,10 TO 15,60 OF oMainWnd //50
      
      M->cCONTATO:=cAssinante
              
      @ 20,5 SAY STR0002 PIXEL //"Assinante"
      @ 20,35 MSGET M->cCONTATO PICTURE "@!" SIZE 120,8 F3 "E34" PIXEL
   
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

End Sequence

cAssinante:=M->cCONTATO

Return lRet

*-------------------------------------------------------------------------*
* FIM DO ARQUIVO EECPEM31.PRW                                             *
*-------------------------------------------------------------------------*
