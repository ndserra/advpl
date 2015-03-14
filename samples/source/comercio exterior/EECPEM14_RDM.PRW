#INCLUDE "EECPEM14.ch"

/*
Programa        : EECPEM14.PRW
Objetivo        : Solicitacao de laudo de analise
Autor           : Flavio Yuji Arakaki
Data/Hora       : 04/10/1999 14:20
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM14
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Flavio Yuji Arakaki
Data/Hora   : 04/10/1999 14:20
Revisao     :
Obs.        :
*/
User Function EECPEM14

Local lRet := .f.
Local nAlias := Select()
Local aOrd := SaveOrd({"EE9","SA2","SA1","SYA"})

Local cEXP_NOME,cEXP_CONTATO,cEXP_FONE,cEXP_FAX
Local cTO_NOME,cTO_FAX, cCliente

Local nCol,W,nTotLin

Private cTO_CON1,cTO_CON2,cTO_CON3,cTO_CON4
Private cF3COD,cF3LOJ,mDETALHE
cFileMen := ""

Begin Sequence

   EE9->(DBSETORDER(2))
   SA2->(DBSETORDER(1))
   SA1->(DBSETORDER(1))              
   SYA->(DBSETORDER(1))              
                  
   //regras para carregar dados                                                                                         
   IF !EMPTY(EEC->EEC_EXPORT)
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")                        
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1     
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1     
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1      
   ELSE                                                                                                                 
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME")                        
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1       
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1       
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1        
   ENDIF                                                                                                                
   
   //TO   
   EE9->(DBSEEK(xFilial("EE9")+EEC->EEC_PREEMB))              
              
   //regras para carregar dados
   cTO_CON1 := SPACE(AVSX3("EE3_NOME",3))
   cTO_CON2 := SPACE(AVSX3("EE3_NOME",3))
   cTO_CON3 := SPACE(AVSX3("EE3_NOME",3))
   cTO_CON4 := SPACE(AVSX3("EE3_NOME",3))
   
   cF3COD   := ""
   cF3LOJ   := ""
   
   IF !EMPTY(EE9->EE9_FABR) 
      cTO_CON1 :=EECCONTATO(CD_SA2,EE9->EE9_FABR,EE9->EE9_FALOJA,"1",1)  //nome do contato seq 1 
      cTO_FAX  :=EECCONTATO(CD_SA2,EE9->EE9_FABR,EE9->EE9_FALOJA,"1",7) //FAX
      cTO_CON2 :=EECCONTATO(CD_SA2,EE9->EE9_FABR,EE9->EE9_FALOJA,"2",1)  //nome do contato seq 2
      cTO_CON3 :=EECCONTATO(CD_SA2,EE9->EE9_FABR,EE9->EE9_FALOJA,"3",1)  //nome do contato seq 3 
      cTO_CON4 :=EECCONTATO(CD_SA2,EE9->EE9_FABR,EE9->EE9_FALOJA,"4",1)  //nome do contato seq 4 
      cTO_NOME :=Posicione("SA2",1,xFilial("SA2")+EE9->EE9_FABR+EE9->EE9_FALOJA,"A2_NOME")    
      cF3COD   := EE9->EE9_FABR
      cF3LOJ   := EE9->EE9_FALOJA
   Elseif !EMPTY(EE9->EE9_FORN)
      cTO_CON1 :=EECCONTATO(CD_SA2,EE9->EE9_FORN,EE9->EE9_FOLOJA,"1",1)  //nome do contato seq 1  
      cTO_FAX  :=EECCONTATO(CD_SA2,EE9->EE9_FORN,EE9->EE9_FOLOJA,"1",7) //FAX
      cTO_CON2 :=EECCONTATO(CD_SA2,EE9->EE9_FORN,EE9->EE9_FOLOJA,"2",1)  //nome do contato seq 2   
      cTO_CON3 :=EECCONTATO(CD_SA2,EE9->EE9_FORN,EE9->EE9_FOLOJA,"3",1)  //nome do contato seq 3  
      cTO_CON4 :=EECCONTATO(CD_SA2,EE9->EE9_FORN,EE9->EE9_FOLOJA,"4",1)  //nome do contato seq 4   
      cTO_NOME :=Posicione("SA2",1,xFilial("SA2")+EE9->EE9_FORN+EE9->EE9_FOLOJA,"A2_NOME")    
      cF3COD   := EE9->EE9_FORN
      cF3LOJ   := EE9->EE9_FOLOJA
   ELSE
      cTO_CON1 :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1)  //nome do contato seq 1  
      cTO_FAX  :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7) //FAX
      cTO_CON2 :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"2",1)  //nome do contato seq 2  
      cTO_CON3 :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"3",1)  //nome do contato seq 3  
      cTO_CON4 :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"4",1)  //nome do contato seq 4  
      cTO_NOME :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME")    
      cF3COD   := EEC->EEC_FORN
      cF3LOJ   := EEC->EEC_FOLOJA
   ENDIF
   
   cEXP_NOME    :=ALLTRIM(cEXP_NOME)
   cEXP_CONTATO :=ALLTRIM(cEXP_CONTATO)
   cEXP_FONE    :=ALLTRIM(cEXP_FONE)
   cEXP_FAX     :=ALLTRIM(cEXP_FAX)
   
   IF (!TELAGETS())
      Break
   ENDIF
   
   cTO_FAX  :=EECCONTATO(CD_SA2,cF3COD,cF3LOJ,"1",7,cTO_CON1) //FAX
   
   IF EMPTY(cTO_FAX)
      cTO_FAX := Posicione("SA2",1,xFilial("SA2")+cF3COD+cF3LOJ,"A2_FAX")
   ENDIF

   cTO_FAX  :=ALLTRIM(cTO_FAX)
   cTO_NOME :=ALLTRIM(cTO_NOME)
   cTO_CON1 :=ALLTRIM(cTO_CON1)
   cTO_CON2 :=ALLTRIM(cTO_CON2)
   cTO_CON3 :=ALLTRIM(cTO_CON3)
   cTO_CON4 :=ALLTRIM(cTO_CON4)
                                                         
   IF !EMPTY(EEC->EEC_CLIENT)
      cCliente := POSICIONE("SA1",1,XFILIAL("SA1")+EEC->EEC_CLIENTE+EEC->EEC_CLLOJA,"A1_NOME")
   ELSEIF !EMPTY(EEC->EEC_IMPORT) 
      cCliente := EEC->EEC_IMPODE
   ENDIF  
                                         
   SYA->(DBSEEK(xFilial("SYA")+EEC->EEC_PAISET))
                                   
   //gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      Break
   Endif
   
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C01_60:=cEXP_NOME
   AVGLTT->AVG_C02_60:=WORKID->EEA_TITULO

   //carregar detalhe
   mDETALHE:="FAC SIMILE NUMBER: "+cTO_FAX+SPACE(2)+"DATE: "+DTOC(dDATABASE)+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"TO  : "+cTO_NOME+ENTER
   mDETALHE:=mDETALHE+"      "+cTO_CON1+ENTER
   mDETALHE:=mDETALHE+"C/C : "+cTO_CON2+ENTER
   mDETALHE:=mDETALHE+"      "+cTO_CON3+ENTER
   mDETALHE:=mDETALHE+"      "+cTO_CON4+ENTER
   mDETALHE:=mDETALHE+ENTER                       
                          
   mDETALHE:=mDETALHE+"FROM: "+cEXP_CONTATO+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"TOTAL NUMBER PAGES INCLUDING THIS COVER: 01"+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"MESSAGE "                                   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+ENTER                                        
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+ENTER 
      
   mDETALHE:=mDETALHE+STR0001+EEC->EEC_PREEMB+ENTER //"REF: N/EXPORTACAO: "
   
   mDETALHE:=mDETALHE+STR0002 + ALLTRIM(cCLIENTE) + ENTER    //"     CLIENTE.....: "
   mDETALHE:=mDETALHE+STR0003 + SYA->YA_DESCR + ENTER  //"     PAIS........: "
                                               //cPais
   mDETALHE:=mDETALHE+ENTER  
   mDETALHE:=mDETALHE+STR0004+ENTER //"PARA ATENDIMENTO DO PEDIDO DE EXPORTACAO EM REFERENCIA ENVIAR"
   mDETALHE:=mDETALHE+STR0005 + ENTER   //"A ESTE DEPARTAMENTO LAUDO DE ANALISE."
   
   mDETALHE:=mDETALHE+ENTER  
   mDETALHE:=mDETALHE+ENTER  
   
   mDETALHE:=mDETALHE+STR0006 + ENTER   //" PRODUTO                                           LOTE"
   mDETALHE:=mDETALHE+STR0007 + ENTER //" -------                                           ----"
     
   mDETALHE:=mDETALHE+ENTER                          

   GravaItens()
   
   mDETALHE:=mDETALHE+ENTER                 
   mDETALHE:=mDETALHE+ENTER             
                             
   mDETALHE:=mDETALHE+STR0008+ENTER    //"OBS: OS CERTIFICADOS ACIMA DEVERAO SER EMITIDOS NO PRAZO MAXIMO DE 48 HORAS."
   mDETALHE:=mDETALHE+           STR0009+ENTER  //"     FAVOR ENVIAR ORIGINAIS VIA MALOTE."
   
   mDETALHE:=mDETALHE+ENTER
   
   IF SELECT("Work_Men") > 0

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
    
      mDETALHE:=mDETALHE+ENTER
   ENDIF
       
   mDETALHE:=mDETALHE+"IF YOU NOT RECEIVE ALL PAGES, PLEASE CALL US ON PHONE "+ cEXP_FONE + ENTER                              
   mDETALHE:=mDETALHE+"======================================================"+ REPL("=",LEN(cEXP_FONE))+ENTER 
   
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO)
   
End Sequence

RestOrd(aOrd)

IF(SELECT("Work_Men")>0,Work_Men->(E_EraseArq(cFileMen)),)
Select(nAlias)

Return lRet

/*
Funcao      : GravaItens
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function GravaItens

Local cCodAnt,cFamilia
Local cMemo,nTot,i

Begin Sequence

   cCODANT:=""
   cFAMILIA:=""
   
   EE9->(DBSEEK(XFILIAL()+EEC->EEC_PREEMB))
   
   DO WHILE EE9->(!EOF()) .AND. EE9->EE9_FILIAL==XFILIAL("EE9") .AND.;
            EE9->EE9_PREEMB == EEC->EEC_PREEMB
      
      IF (cCODANT#EE9->EE9_COD_I)
         cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
         nTot  := MlCount(cMemo,AVSX3("EE9_VM_DES",3))
         For i := 1 To nTot
            mDETALHE:=mDETALHE+" "+MemoLine(cMemo,AVSX3("EE9_VM_DES",3),i)+ENTER
         Next
         cCODANT:=EE9->EE9_COD_I
      ENDIF
      EE9->(DBSKIP())
   ENDDO
End Sequence
     
Return NIL

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

Begin Sequence
    
   IF ! Pergunte("PEM014",.T.)
      Break
   Endif
   
   cTO_CON1:=MV_PAR01
   cTO_CON2:=MV_PAR02
   cTO_CON3:=MV_PAR03
   cTO_CON4:=MV_PAR04
    
   DEFINE MSDIALOG oDlg TITLE ALLTRIM(WORKID->EEA_TITULO) FROM 200,1 TO 520,600 OF oMainWnd PIXEL
          
      EECMensagem(EEC->EEC_IDIOMA,"2",{4,1,137,305},,,,oDlg)
          
      SButton():New(147,50,1,{||lRet:=.T.,oDlg:End()},oDlg,.T.,,)
      SButton():New(147,110,2,{||oDlg:End()}, oDlg,.T.,,)
      
   ACTIVATE MSDIALOG oDlg CENTERED

End Sequence

Return lRet

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM14.PRW                                                 *
*------------------------------------------------------------------------------*
