#INCLUDE "EECPEM25.ch"

/*
Programa        : EECPEM25.PRW
Objetivo        : Cobertura de Seguro Exportacao
Autor           : Heder M Oliveira
Data/Hora       : 10/11/99 13:59
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM25
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     :
Obs.        :
*/
User Function EECPEM25

Local lRet := .f.
Local aOrd := SaveOrd({"EE9"})

Local cTO_ATTN,cTO_FAX
Local cEXP_NOME,cEXP_CONTATO,cEXP_FONE,cEXP_FAX

Local nCol,nTotLin, w:=0

Private mDETALHE := ""
Private nFobValue   := EEC->EEC_TOTPED//(EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN)
Private nTaxa := .26
Private cPict := AVSX3("EEC_TOTPED",6)//"@E 999,999,999"+IF(EEC_DECPRC==0),"","."+Repl("9",EEC->EEC_DECPRC)

cFileMen := ""

Begin Sequence
   
   EE9->(dbSetOrder(4))

   IF EMPTY(cTO_NOME:=BUSCAEMPRESA(EEC->EEC_PREEMB,OC_EM,CD_SEG))
      MSGINFO(STR0001,STR0002) //"Não existe Seguradora para este Processo"###"Atenção"
      Break
   ENDIF
   
   IF !TelaGets()
   	  Break
   Endif
   
   cTO_ATTN:=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1) //nome do contato seq 1
   cTO_FAX :=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",7) //fax do contato seq 1

   //regras para carregar dados
   IF !EMPTY(EEC->EEC_EXPORT)
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1,EE7->EE7_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4,EE7->EE7_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7,EE7->EE7_RESPON)  //fax do contato seq 1
   ELSE
      SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME")
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EE7->EE7_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EE7->EE7_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EE7->EE7_RESPON)  //fax do contato seq 1
   ENDIF
   
   //gerar arquivo padrao de edicao de carta
   IF ( E_AVGLTT("G") )
      //adicionar registro no AVGLTT
      AVGLTT->(DBAPPEND())

      //gravar dados a serem editados
      AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
      AVGLTT->AVG_C01_60:=cEXP_NOME
      AVGLTT->AVG_C02_60:=WORKID->EEA_TITULO
          
      //carregar detalhe
      mDETALHE:=""
      mDETALHE:=mDETALHE+"FAC SIMILE NUMBER: "+cTO_FAX
      mDETALHE:=mDETALHE+SPACE(15)+"DATE: "+DTOC(dDATABASE)+ENTER+ENTER //data logada no sistema
      mDETALHE:=mDETALHE+"TO  : "+cTO_NOME+ENTER+ENTER
      mDETALHE:=mDETALHE+"AT  : "+cTO_ATTN+ENTER+ENTER
      mDETALHE:=mDETALHE+"FROM: "+cEXP_CONTATO+ENTER+ENTER
      mDETALHE:=mDETALHE+"TOTAL NUMBER PAGES INCLUDING THIS COVER: 01"+ENTER+ENTER
      mDETALHE:=mDETALHE+"MESSAGE"+ENTER+ENTER
      mDETALHE:=mDETALHE+STR0003+EEC->EEC_PREEMB+ENTER+ENTER //"N/REFERENCIA.: "
      mDETALHE:=mDETALHE+STR0004+SPACE(AVSX3("EE9_VM_DES",3)-20)+STR0005+ENTER //"MERCADORIA"###" EMBALAGEM                 QUANTIDADE"
	  
	  GravaItens()
      
	  mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+ENTER
	  mDETALHE:=mDETALHE+STR0006+Posicione("SYQ",1,xFilial("SYQ")+EEC->EEC_VIA, "YQ_DESCR")+ENTER //"MOD. EMBARQUE: "
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+STR0007+Posicione("SY9",2,xFilial("SY9")+EEC->EEC_DEST,"Y9_DESCR")+ENTER //"DESTINO......: "
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+STR0008+Posicione("EE6",1,XFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")+ENTER //"NAVIO........: "
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+STR0009+EEC->EEC_INCOTE+"....: "+Transf(nFobValue,cPict)+ENTER //"VALOR "
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+STR0010+TRANS(nTaxa,"@E 999.999")+"%"+ENTER //"TAXA.........: "
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+ENTER
   
      IF SELECT("Work_Men") > 0
         nCol:=80 //AVSX3("EE4_VM_TEX",3)
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

      mDETALHE:=mDETALHE+ENTER+ENTER

      mDETALHE:=mDETALHE+STR0011+ENTER //"SAUDACOES,"
      mDETALHE:=mDETALHE+ENTER
      mDETALHE:=mDETALHE+ENTER
      
      mDETALHE:=mDETALHE+"IF YOU NOT RECEIVE ALL PAGES, PLEASE CALL US ON PHONE "+cEXP_FONE+ENTER
   	 //gravar detalhe
      AVGLTT->WK_DETALHE := mDETALHE
      
      cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
      CONFIRMSX8()
      //executar rotina de manutencao de caixa de texto
      lRet:=E_AVGLTT("M",WORKID->EEA_TITULO)
   ENDIF
   
End Sequence

IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cFileMen))
Endif

RestOrd(aOrd)

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

Local bOk     := {||lRet:=.t.,oDlg:End()}
Local bCancel := {||oDlg:End()}

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM  9,0 TO 24,70 OF oMainWnd
   
      @ 20,5  SAY STR0009+EEC->EEC_INCOTE PIXEL //"Valor "
      @ 20,42 MSGET nFobValue SIZE 75,8 PICT cPict PIXEL
      
      @ 33,5  SAY STR0012 PIXEL //"Taxa"
      @ 33,42 MSGET nTaxa SIZE 25,8 PICT "@E 999.999" PIXEL
      
      EECMensagem(EEC->EEC_IDIOMA,"2",{050,1,110,250})
      
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)
   
End Sequence

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

Local cMemo,nTot1,nTot2,cTexto,i1,i2,i

Begin Sequence

   EE9->(DBSEEK(XFILIAL()+EEC->EEC_PREEMB))

   WHILE EE9->(!EOF()) .AND. EE9->EE9_FILIAL==XFILIAL("EE9") .AND.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB
         
      cMemo := MSMM(EE9->EE9_DESC,48)   
      nTot1 := MlCount(cMemo,48)
      nTot2 := MlCount(EEC->EEC_PACKAG,23)
      cTexto := ""
      
      i1 := 1
      i2 := 1
      
      While .t.
         if i1>nTot1 .And. i2>nTot2
            Exit
         Endif
         
         IF i1<=nTot1
            cTexto := cTexto+MemoLine(cMemo,48,i1)
            i1 := i1+1
         Else
            cTexto := cTexto+Space(48)
         Endif
         
         cTexto := cTexto+Space(3)
         
         IF i2<=nTot2
            cTexto := cTexto+MemoLine(EEC->EEC_PACKAG,23,i2)
            i2 := i2+1
         Else
            cTexto := cTexto+Space(23)
         Endif
         
         cTexto := cTexto+Space(3)
         cTexto := cTexto+ENTER
      Enddo
      
      mDETALHE:=mDETALHE+MemoLine(cTexto,77,1)
      mDETALHE:=mDETALHE+" "+TRANSFORM(EE9->EE9_SLDINI,"@E 9,999,999"+IF(EEC->EEC_DECQTD>0,"."+REPL("9",EEC->EEC_DECQTD),""))
      mDETALHE:=mDETALHE+ENTER
      
      For i := 2 to MlCount(cTexto,77)
         mDETALHE:=mDETALHE+MemoLine(cTexto,77,i)+ENTER
      Next
      
      EE9->(DBSKIP())
   ENDDO
   
End Sequence 
     
Return NIL

