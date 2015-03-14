#INCLUDE "EECPEM15.ch"

/*
Programa        : EECPEM15.PRW
Objetivo        : FORM B
Autor           : Flavio Yuji Arakaki
Data/Hora       : 05/10/1999 17:30
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM15
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Flavio Yuji Arakaki
Data/Hora   : 05/10/1999 17:30
Revisao     :
Obs.        :
*/
User Function EECPEM15

Local lRet := .T.
Local nAlias := Select()
Local aOrd   := SaveOrd({"EE9"})

Private lCHECK_1 := .T.
//Private cCHECK_1 := "I certify... POSITIVE"
//Private lCHECK_2 := .F.
//Private cCHECK_2 := "I certify... NEGATIVE"

//USADO NO EECF3EE3 VIA SXB "E34" PARA GET ASSINANTE
Private M->cSEEKEXF:=""
Private M->cSEEKLOJA:=""

Private cEXP_NOME,cTO_CON1
cFileMen := ""

Begin Sequence                  
   
   EE9->(dbSetOrder(1))
   
   cEXP_NOME := AllTrim(Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME"))
   
   M->cSEEKEXF  :=EEC->EEC_FORN
   M->cSEEKLOJA :=EEC->EEC_FOLOJA
   
   //regras para carregar dados
   cTO_CON1	:= SPACE(AVSX3("EE3_NOME",3))

   EE9->(DBSEEK(xFilial("EE9")+EEC->EEC_PREEMB))			  
   
   IF !EMPTY(EE9->EE9_FABR)
      cTO_CON1 :=EECCONTATO(CD_SA2,EE9->EE9_FABR,EE9->EE9_FALOJA,"3",1)  //nome do contato seq 1 
      // M->cSEEKEXF  :=EE9->EE9_FABR
      // M->cSEEKLOJA :=EE9->EE9_FALOJA
   ELSE 
      cTO_CON1 :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"3",1)  //nome do contato seq 1  
      // M->cSEEKEXF  :=EEC->EEC_FORN
      // M->cSEEKLOJA :=EEC->EEC_FOLOJA
   ENDIF
                                                                                                                                                                           
   IF !TelaGets()
      lRet := .F.
	  Break
   ENDIF
   
   //gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      lRet := .F.
      Break
   Endif
   
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C02_60:="THIS FORM MUST BE ATTACHED TO THE OUTSIDE OF THE PACKAGE"
   AVGLTT->AVG_C03_60:="FORM B"
   AVGLTT->AVG_C01_60:=cEXP_NOME 

   //carregar detalhe
   mDETALHE:="DATE: "+ DTOC(dDATABASE) + ENTER
   mDETALHE:=mDETALHE+"THL NR : "+EEC->EEC_PREEMB+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+ENTER                       
                          
   mDETALHE:=mDETALHE+"TO: The District Director of Customs"+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"Port of U.S.A."+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"Sir/Madame:" +ENTER
   mDETALHE:=mDETALHE+ENTER 
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"       ("+IF(lCHECK_1,"X"," ")+")   I certify that all chemical substances in this shipment comply"+ENTER     
   mDETALHE:=mDETALHE+"       with all applicable rules or POSITIVE orders under TSCA and that I"+ENTER     
   mDETALHE:=mDETALHE+"       am not offering a chemical substance for entry in violation     of"+ENTER     
   mDETALHE:=mDETALHE+"       TSCA or any applicable rule or order thereunder." + ENTER   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"       ( )   I certify that all chemicals in this shipment NEGATIVE are not" + ENTER
   mDETALHE:=mDETALHE+"       subject to TSCA." + ENTER                             
   
   mDETALHE:=mDETALHE+ENTER  
   mDETALHE:=mDETALHE+ENTER  
   mDETALHE:=mDETALHE+ENTER                                             
   mDETALHE:=mDETALHE+ENTER                                          
     
   mDETALHE:=mDETALHE+"Very truly yours,"
   
   mDETALHE:=mDETALHE+ENTER                 
   mDETALHE:=mDETALHE+ENTER             
   mDETALHE:=mDETALHE+ENTER + ENTER   
   mDETALHE:=mDETALHE+ cTO_CON1 + ENTER 
/*   
   IF SELECT("Work_Men") > 0
      mDETALHE:=mDETALHE+ENTER+ENTER+ENTER
	  mDETALHE:=mDETALHE+"OBSERVACOES"+ENTER

      nCol:=AVSX3("EE4_VM_TEX",3)
      Work_Men->(DBGOTOP())
      DO WHILE !Work_Men->(EOF()) .AND. WORK_MEN->WKORDEM<"zzzzz"

         nTotLin:=MLCOUNT(Work_Men->WKOBS,nCol) 

         FOR W := 1 TO nTotLin
            If !EMPTY(MEMOLINE(Work_Men->WKOBS,nCol,W))
                mDETALHE:=mDETALHE+MEMOLINE(Work_Men->WKOBS,nCol,W)+ENTER
            EndIf
         NEXT
   
         Work_Men->(DBSKIP())
     
      ENDDO
    
    ENDIF
*/   
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",ALLTRIM(WORKID->EEA_TITULO))

End Sequence   

IF(SELECT("Work_Men")>0,Work_Men->(E_EraseArq(cFileMen)),)

RestOrd(aOrd)
Select(nAlias)

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

Local lRet:=.F.
Local cCONTATO:=SPACE(AVSX3("EE3_NOME",3))

Local oDlg, aFldF, oFldF, oMark
Local xx := ""

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 200,1 TO 620,600 OF oMainWnd PIXEL
     
      oFld := TFolder():New(1,1,{STR0001,STR0002},{"CON","MSG"},oDlg,,,,.T.,.F.,300,160) //"Contatos"###"Mensagens"
      
      aFldF := oFld:aDialogs
      aEval(aFldF,{|x| x:SetFont(oDlg:oFont)})
      
      oFLDF:=aFLDF[1] //CONTATOS
      
      //para encontrar a proxima linha, some 9. Ex.: 10+9=19
      @ 10,20 SAY cEXP_NOME PIXEL OF oFldF
      @ 26,20 SAY STR0003 PIXEL OF oFldF //"Contato 1 "
      @ 26,50 MSGET cCONTATO PIXEL OF oFldF F3 "E34" SIZE 140,08
       
      oFLDF:=aFLDF[2] //MENSAGENS
    
      cFileMen:=""
      oMark := EECMensagem(EEC->EEC_IDIOMA,"2",{25,1,137,295},,,,oFLDF)
      @ 14,043 GET xx OF oFldF
       
	  SButton():New(187,50,1,{||lRet:=.T.,oDlg:End()}, oDlg,.T.,,)
      SButton():New( 187,110,2,{||lRet:=.F.,oDlg:End()},oDlg,.T.,,)
      
      oMark:oBrowse:Hide()
      
      oFld:bChange := {|nOption,nOldOption| IF(nOption==1,oMark:oBrowse:Hide(),;
                                               oMark:oBrowse:Show()) }
      
   ACTIVATE MSDIALOG oDlg CENTERED
   
   cTO_CON1 := M->cCONTATO
   
End Sequence

Return lRet

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM15.PRW                                                 *
*------------------------------------------------------------------------------*
