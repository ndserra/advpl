#INCLUDE "EECPEM22.ch"

/*
Programa        : EECPEM22.PRW
Objetivo        : Certificado de Seguro
Autor           : Heder M Oliveira
Data/Hora       : 30/10/99 11:28
Obs.            : 
Revisao         : Cristiano A. Ferreira
Data            : 18/11/1999 14:20
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

#define LenCol1 19 // +1
#define LenCol2 10 // +1
#define LenCol3 11 // +1
#define LenCol4 12 // +1
#define LenCol5 50 // +1
#define LenCol6 19

#define INICIO_ITENS 25
#define FIM_ITENS    30

#define INICIO_OBS   32
#define FIM_OBS      36

#define MARGEM Space(14)

/*
Funcao      : EECPEM22
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     :
Obs.        :
*/
User Function EECPEM22

Local aOrd := SaveOrd({"EE9","SA2","SA1","SYR"})
Local lRet := .F.

Private mDet := ""
Private cPictPeso  := "@E 99,999,999.99"
Private cPictQtde  := "@E 999,999"

cFileMen := ""

Begin Sequence

   EE9->(dbSetOrder(2)) // FILIAL+PREEMB...
   SA2->(dbSetOrder(1)) // FILIAL+CODIGO+LOJA
   SA1->(dbSetOrder(1)) // FILIAL+CODIGO+LOJA
   SYR->(dbSetOrder(1)) // FILIAL+VIA+ORIGEM+DESTINO+TIPO TRANSP.

   cAPLCSG:=EEC->EEC_APLCSG
   cNRAVSG:=EEC->EEC_NRAVSG
   dDTSEGU:=EEC->EEC_DTSEGU
   cNRCTSG:=EEC->EEC_NRCTSG
      
   IF !TelaGets()
      Break
   Endif
   
   // Exportador ...
   IF !Empty(EEC->EEC_EXPORT) .And.;
      SA2->(dbSeek(xFilial()+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
   Else
      SA2->(dbSeek(xFilial()+EEC->EEC_FORN+EEC->EEC_FOLOJA))
   Endif

   //gerar arquivo padrao de edicao de carta 
   IF ! E_AVGLTT("G")                        
      Break
   Endif                                     
                                             
   //adicionar registro no AVGLTT            
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C01_60:=SA2->A2_NOME
   AVGLTT->AVG_C02_60:=WORKID->EEA_TITULO
   
   mDet := mDet+Replicate(ENTER,13)
   mDet := mDet+MARGEM+SPACE(20)+SA2->A2_NOME+ENTER
   mDet := mDet+ENTER+ENTER
   mDet := mDet+MARGEM+SPACE(92)+cAPLCSG+ENTER
   mDet := mDet+ENTER
   mDet := mDet+MARGEM+SPACE(20)+cNRAVSG+Space(10)
   mDet := mDet+Dtoc(dDTSEGU)+ENTER

   // Grava Itens em mDet ...
   GravaItens()

   // Grava Observaocoes em mDet ...
   GravaObs()
   // Alterado por Heder M Oliveira - 4/6/2000
   mDet := mDet+Replicate(ENTER,5)
   // franquia          
   mDET := mDET+MARGEM+STR0001+ENTER //"1% DEDUTIVEL SOBRE O TOTAL"
   mDET := mDET+MARGEM+STR0002 //"DO EMBARQUE.              "
   // Origem e Destino 
   mDet := mDet+Space(20)+Posicione("SY9",2,xFilial("SY9")+EEC->EEC_ORIGEM,"Y9_DESCR")
//   mDet := mDet+Space(20)+Posicione("SYR",1,xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA,"YR_CID_DES")+ENTER
   mDet := mDet+Space(20)+Posicione("SY9",2,xFilial("SY9")+EEC->EEC_DEST,"Y9_DESCR")+ENTER
//   mDET := mDET+MARGEM+"DO EMBARQUE."+ENTER
   mDet := mDet+ENTER+ENTER
//   mDet := mDet+MARGEM+EEC->EEC_EMBARC
   mDet := mDet+MARGEM+POSICIONE("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_DESCR")
   mDet := mDet+Space(23)+LEFT(Posicione("SY9",2,xFilial("SY9")+EEC->EEC_ORIGEM,"Y9_DESCR"),16)
   mDet := mDet+SPACE(12)+INCSPACE(LEFT(Posicione("SY9",2,xFilial("SY9")+EEC->EEC_DEST,"Y9_DESCR"),21),21,.F.)
   mDET := mDET+SPACE(2)+EEC->EEC_MOEDA+TRANSF(EEC->EEC_SEGPRE,AVSX3("EEC_SEGPRE",6))+ENTER

   mDet := mDet+MARGEM+SPACE(20)+DTOC(EEC->EEC_ETD)
   
   mDET := mDET+REPLICATE(ENTER,8)
   mDET := mDET+MARGEM+SPACE(16)+"LLOYD'S AGENT"+ENTER
   mDET := mDET+REPLICATE(ENTER,2)
   mDET := mDET+MARGEM+STR0003+SPACE(35)+DTOC(dDATABASE)                                //"SAO PAULO"
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDet

   cSeqRel :=GetSXENum("SY0","Y0_SEQREL")
   ConfirmSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",ALLTRIM(WORKID->EEA_TITULO),"AVG_C01150")

End Sequence

IF(Select("Work_Men")>0,Work_Men->(E_EraseArq(cFileMen)),)

RestOrd(aORD)

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

   DEFINE MSDIALOG oDlg TITLE ALLTRIM(WorkId->EEA_TITULO) FROM 09,0 TO 27,50 OF oMainWnd

      @ 20,5  SAY STR0004 PIXEL //"No. Apólice"
      @ 20,50 MSGET cAPLCSG SIZE 80,8 PIXEL
      
      @ 33,5 SAY STR0005 PIXEL //"No. Averbação"
      @ 33,50 MSGET cNRAVSG SIZE 115,8 PIXEL
      
      @ 46,5  SAY STR0006 PIXEL //"Dt. Seguro"
      @ 46,50 GET dDTSEGU SIZE 40,8 PIXEL
      
      @ 59,5  SAY STR0007 PIXEL //"Nr. Cert. Seguro"
      @ 59,50 GET cNRCTSG SIZE 115,8 PIXEL
   
      EECMensagem(EEC->EEC_IDIOMA,"2",{72,1,140,198})
   
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

Local cQtde := ""
Local cDesc := ""

Local cFam, cMemo, i, cPeso, cCntr, cValor, nTot, nLin
Local aCols, cMarks

Begin Sequence

   EE9->(DBSEEK(xFilial()+EEC->EEC_PREEMB))

   cFam := MemoLine(AllTrim(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),2)),LenCol5,1)

   While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB

      SysRefresh()

      cMemo := MemoLine(AllTrim(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),1)),LenCol5,1)

      For i := 1 To MlCount(cMemo,LenCol5)
         SysRefresh()

         IF i == 1
            cQtde := cQtde+Padl(AllTrim(Transf(EE9->EE9_SLDINI,cPictQtde))+EE9->EE9_UNIDAD,LenCol4)+ENTER
         Else
            cQtde := cQtde+ENTER
         Endif

         cDesc := cDesc+Padr(AllTrim(MemoLine(cMemo,LenCol5,i)),LenCol5)+ENTER
      Next

      EE9->(dbSkip())
   Enddo

   cDesc := cDesc+cFam+ENTER
   cDesc := cDesc+"Invoice "+TRANSFORM(EEC->EEC_NRINVO,AVSX3("EEC_NRINVO",AV_PICTURE))
   // LCS - 23/09/2002 - SUBSTITUIDO PELA LINHA ACIMA
   //cDesc := cDesc+"Invoice "+EEC->EEC_PREEMB

   // aCols por dimensao:
   // aCols[x][1] => Campo memo
   // aCols[x][2] => Total de Linhas do memo
   // aCols[x][3] => Largura da Coluna
   aCols := {}

   cMarks := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3))
   aAdd(aCols, {cMarks,MlCount(cMarks,LenCol1),LenCol1})

   cPeso := "NET"+ENTER+Padl(AllTrim(Transf(EEC->EEC_PESLIQ,cPictPeso)),LenCol4)+ENTER+EEC->EEC_UNIDAD+ENTER
   aAdd(aCols, {cPeso,MlCount(cPeso,LenCol2),LenCol2})

   cCntr := EEC->EEC_PACKAG+" "+EEC->EEC_NETWGT
   aAdd(aCols, {cCntr,MlCount(cCntr,LenCol3),LenCol3})

   aAdd(aCols,{cQtde,MlCount(cQtde,LenCol4),LenCol4})
   aAdd(aCols,{cDesc,MlCount(cDesc,LenCol5),LenCol5})

   cValor := Padc(AllTrim(EEC->EEC_INCOTE),LenCol6)+ENTER+Padc(AllTrim(EEC->EEC_MOEDA),LenCol6)+ENTER+Padl(Transf(EEC->EEC_TOTPED,AVSX3("EEC_TOTPED",6)),LenCol6)
   aAdd(aCols, {cValor,MlCount(cValor,LenCol6),LenCol6})

   nTot := 0
   aEval(aCols,{|x| nTot := Max(nTot,x[2]) })

   nLin := INICIO_ITENS
   mDet := mDet+Replic(ENTER,nLin-MlCount(mDet,150))

   For i := 1 To nTot
      SysRefresh()

      IF nLin > FIM_ITENS
         Exit
      Endif

      mDet := mDet+MARGEM
      aEval(aCols,{|x| mDet:=mDet+IF(i<=x[2],Padr(MemoLine(x[1],x[3],i),x[3]),Space(x[3]))+" "})
      mDet := mDet+ENTER

      nLin := nLin+1
   Next

   mDet := mDet+Replic(ENTER,FIM_ITENS-(nLin-1))
   
End Sequence

Return NIL

/*
Funcao      : GravaObs
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function GravaObs

Local nCol, nLinha, nTotLin

Begin Sequence

   mDet := mDet+Replic(ENTER,INICIO_OBS-MlCount(mDet,150))

   nCol  := 93
   nLinha:= INICIO_OBS
  
   //COLOCAR MENSAGEM PADRAO
   nTOTLIN:=3	
   mDet   := mDet+MARGEM+STR0008 //"SEGURO EFETUADO DE CASA A CASA, COBRINDO TODOS OS RISCOS,"
   mDET   := mDET+STR0009+ENTER //"INCLUSIVE OS RISCOS DE GUERRA E"
   mDET   := mDET+MARGEM+STR0010 //"GREVES, DE CONFORMIDADE COM AS CLAUSULAS DE CARGA (TODOS "
   mDET   := mDET+STR0011+ENTER //"OS RISCOS), CLAUSULAS DE GUERRA E"
   mDET   := mDET+MARGEM+STR0012 //"CLAUSULAS DE GREVES, DO INSTITUTO DE SEGURADORES DE LONDRES."
   nLINHA:=nLinha+3
  
   // *** Observacoes ...
   //IF Select("Work_Men") > 0
   /*   Work_Men->(dbGoTop())
      
      While ! Work_Men->(Eof()) .And. Work_Men->WKORDEM < "zzzzz"
         nTotLin:=MlCount(Work_Men->WKOBS,nCol) 
         
         IF nLinha > FIM_OBS
            Exit
         Endif
         
         For w := 1 To nTotLin
            IF nLinha > FIM_OBS 
               Exit
            Endif
            
            IF !Empty(MemoLine(Work_Men->WKOBS,nCol,w))
               mDet   := mDet+MARGEM+MemoLine(Work_Men->WKOBS,nCol,w)+ENTER
               nLinha := nLinha+1
            EndIf
         Next
         
         Work_Men->(dbSkip())
      Enddo
   Endif
   */
   mDet := mDet+Replic(ENTER,FIM_OBS-(nLinha-1))
   
End Sequence

Return (NIL)

*---------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM22.PRW                                              *
*---------------------------------------------------------------------------*
