#INCLUDE "EECPRL10.ch"

/*
Programa        : EECPRL10.PRW
Objetivo        : Controle de Embarque
Autor           : Cristiane C. Figueiredo
Data/Hora       : 04/06/2000 14:40
Obs.            : 
*/

// Alterado por Heder M Oliveira - 6/13/2000
// Alterado por João Pedro Macimiano Trabbold - Passado para tipo "Documento"

#include "EECRDM.CH"

/*
Funcao      : EECPRL10
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiane C. Figueiredo
Data/Hora   : 04/06/2000 14:40
Revisao     :
Obs.        :
*/

User Function EECPRL10

Local aOrd := SaveOrd({"EE5","EEC","EEB","EE9","EXB","SY0","EEA"})
Local cSD:=""
Local lColuna1, cTituloEEA, aImpressos := {}
Local cEfetuado, nRec, aRE := {}, nPos, i
Local cVolume, lRet := .t.

Begin Sequence

   //rotina principal
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   cVOLUME:=posicione("EE5",1,XFILIAL("EE5")+AVKEY(EEC->EEC_EMBAFI,"EE5_COD"),"EE5_DESC")
   
   //Impressão dos itens
   EE9->(DBSETORDER(2))
   EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
   While EE9->(!Eof()) .AND. XFILIAL("EE9")+EE9->EE9_PREEMB == EEC->(EEC_FILIAL+EEC_PREEMB)

      DETAIL_P->(DBAPPEND())
      DETAIL_P->AVG_SEQREL := cSeqRel 
      DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
      DETAIL_P->AVG_FILIAL := xFilial("EEC")
      DETAIL_P->AVG_CONT   := "A" //FLAG
      DETAIL_P->AVG_C01_60 := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",AV_TAMANHO))//Descrição do Produto
      DETAIL_P->AVG_C01_20 := Transform(EE9->EE9_SLDINI,AvSx3("EE9_SLDINI",AV_PICTURE))//Quantidade
    //DETAIL_P->AVG_C02_20 := Transform(EE9->EE9_PRECOI,AvSx3("EE9_PRECOI",AV_PICTURE))//Preco FOB
      DETAIL_P->AVG_C02_20 := Transform(EE9->EE9_PRECOI,EECPreco("EE9_PRECOI", AV_PICTURE))//Preco FOB
    //DETAIL_P->AVG_C03_20 := Transform(EE9->EE9_PRCINC,AvSx3("EE9_PRCINC",AV_PICTURE))//Valor Total
      DETAIL_P->AVG_C03_20 := Transform(EE9->EE9_PRCINC,EECPreco("EE9_PRCINC", AV_PICTURE) )//Valor Total

      If !Empty(EE9->EE9_RE)
         nPos := AScan(aRE,{ |x| x[1] == Left(EE9->EE9_RE,9) } )//Procura se já existe o RE no array
         If nPos > 0 
            If Val(Right(EE9->EE9_RE,3)) > Val(aRE[nPos][2])//se houver e o anexo do RE da base for
               aRE[nPos][2] := Right(EE9->EE9_RE,3)         //maior que o anexo do RE do Array, substitui
            EndIf
         Else
            AAdd(aRE , {Left(EE9->EE9_RE,9),Right(EE9->EE9_RE,3)} )
         EndIf
      EndIf
         
      If empty(cSD)
         cSD := alltrim(EE9->EE9_NRSD)//Pega sempre a primeira SD que encontra nos itens
      EndIf
         
      EE9->(DBSKIP())
   EndDo
   
   //Título das Atividades / Documentos
   DETAIL_P->(DBAPPEND())
   DETAIL_P->AVG_SEQREL := cSeqRel 
   DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
   DETAIL_P->AVG_FILIAL := xFilial("EEC")
   DETAIL_P->AVG_CONT   := "B" //FLAG
   
   AAdd(aImpressos,WORKID->EEA_COD)//Para que o relatório atual(controle de Embarque) não entre na relação de docs.
   
   //Impressão das atividades / documentos
   lColuna1 := .f.
   SY0->(DbSetOrder(4))//Y0_FILIAL+Y0_PROCESS+Y0_FASE+Y0_CODRPT
   EXB->(DbSetOrder(1))
   EXB->(DbSeek(xFilial("EXB")+EEC->EEC_PREEMB))
   While EXB->(!EoF()) .And. xFilial("EXB") == EXB->EXB_FILIAL .And. EXB->EXB_PREEMB == EEC->EEC_PREEMB
      
      If AScan(aImpressos,EXB->EXB_CODATV) > 0
         EXB->(DbSkip())
         Loop
      EndIf
      
      lColuna1 := !lColuna1
      
      cTituloEEA := Posicione("EEA",1,xFilial("EEA")+EXB->EXB_CODATV,"EEA_TITULO")//descrição do doc.
      
      AAdd(aImpressos,EXB->EXB_CODATV)
      If lColuna1
         DETAIL_P->(DBAPPEND())
         DETAIL_P->AVG_SEQREL := cSeqRel 
         DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
         DETAIL_P->AVG_FILIAL := xFilial("EEC")
         DETAIL_P->AVG_CONT   := "C" //FLAG
         DETAIL_P->AVG_C01_60 := cTituloEEA
      Else
         DETAIL_P->AVG_C02_60 := cTituloEEA
      EndIf
      
      cEfetuado := ""
      
      If Left(EEA->EEA_TIPDOC,1) == "2"
         If SY0->(AvSeekLast(xFilial("SY0")+EEC->EEC_PREEMB+"2"+EXB->EXB_CODATV))
            cEfetuado := DtoC(SY0->Y0_DATA) //Efetuado
         Else
            cEfetuado := STR0005 //"Pendente"
         EndIf

      Else
         If Empty(EXB->EXB_DTREAL)
            cEfetuado := STR0005 //"Pendente"
         Else
            cEfetuado := DtoC(EXB->EXB_DTREAL)
         EndIf
         
      EndIf
      
      If lColuna1
         DETAIL_P->AVG_C02_10 := cEfetuado
      Else
         DETAIL_P->AVG_C04_10 := cEfetuado
      EndIf
      
      EXB->(DbSkip())
      
   EndDo
   
   //Ordem - Y0_FILIAL+Y0_PROCESS+Y0_FASE+Y0_CODRPT
   
   SY0->(DbSeek(xFilial("SY0")+EEC->EEC_PREEMB+"2"))
   While SY0->(!EoF()) .And. SY0->Y0_FILIAL == xFilial("SY0") .And. SY0->Y0_PROCESS == EEC->EEC_PREEMB .And.;
                             SY0->Y0_FASE == "2"
                             
      If AScan(aImpressos,SY0->Y0_CODRPT) > 0
         SY0->(DbSkip())
         Loop
      EndIf
      
      lColuna1 := !lColuna1
      
      If !Empty(SY0->Y0_CODRPT)
         cTituloEEA := Posicione("EEA",1,xFilial("EEA")+AvKey(SY0->Y0_CODRPT,"EEA_COD"),"EEA_TITULO")//descrição do doc.
      Else
         cTituloEEA := Upper(SY0->Y0_DOC)
      EndIf
      
      If lColuna1
         DETAIL_P->(DBAPPEND())
         DETAIL_P->AVG_SEQREL := cSeqRel 
         DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
         DETAIL_P->AVG_FILIAL := xFilial("EEC")
         DETAIL_P->AVG_CONT   := "C" //FLAG
         DETAIL_P->AVG_C01_60 := cTituloEEA
      Else
         DETAIL_P->AVG_C02_60 := cTituloEEA
      EndIf
      
      AAdd(aImpressos,SY0->Y0_CODRPT)
      
      SY0->(AvSeekLast(xFilial("SY0")+EEC->EEC_PREEMB+"2"+SY0->Y0_CODRPT))
      
      cEfetuado := DtoC(SY0->Y0_DATA)
      
      If lColuna1
         DETAIL_P->AVG_C02_10 := cEfetuado
      Else
         DETAIL_P->AVG_C04_10 := cEfetuado
      EndIf
      
      SY0->(DbSkip())   
   EndDo
   
   If Len(aImpressos) <= 1 //pois o mínimo é um, ao início é adicionado o código do Rel. atual para ele próprio 
                           //não sair na impressão das atividades/documentos
      lRet := .f.
      MsgInfo(STR0003,STR0004)//"Nao ha atividades/documentos a serem impressos.","Aviso"
      Break
   EndIf
                        
   //Impressão do cabeçalho/rodapé
   HEADER_P->(DBAPPEND())
   HEADER_P->AVG_SEQREL := cSeqRel
   HEADER_P->AVG_CHAVE  := EEC->EEC_PREEMB
   HEADER_P->AVG_FILIAL := xFilial("EEC")
   
   HEADER_P->AVG_C08_60 := EEC->EEC_PREEMB
   HEADER_P->AVG_C03_30 := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_IMPORT,"A1_NREDUZ") //Cliente
   HEADER_P->AVG_C01_60 := SM0->M0_NOME //Empresa
   HEADER_P->AVG_C12_20 := IF(Empty(EEC->EEC_LC_NUM),STR0001,STR0002) //"NAO"###"SIM" //LC
   HEADER_P->AVG_C02_60 := EEC->EEC_REFIMP // Referência Imp.
   
   EE9->(DBSETORDER(2))
   EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
   HEADER_P->AVG_C11_20 := EE9->EE9_PEDIDO //Nr. Exportação
   HEADER_P->AVG_C04_30 := cVolume //Volume
   
   HEADER_P->AVG_C03_60 := IF(EMPTY(EEC->EEC_DEST),"",POSICIONE("SY9",2,XFILIAL("SY9")+EEC->EEC_DEST,"Y9_DESCR"))//Destino
   
   IF LEFT(SYQ->YQ_COD_DI,1) == "7" // Rodoviario  (já está posicionado pelo comando acima)
      HEADER_P->AVG_C04_60 := BuscaEmpresa(EEC->EEC_PREEMB,"Q","B") //Agencia
   ELSE
      HEADER_P->AVG_C04_60 := BuscaEmpresa(EEC->EEC_PREEMB,"Q","1") //Agencia
   ENDIF
   
   IF !EEB->(Eof())
      HEADER_P->AVG_C05_60 := EECCONTATO("E",EEB->EEB_CODAGE,,"1",1) //contato - EEB posicionado pelo BuscaEmpresa
   ENDIF
   
   HEADER_P->AVG_C05_30 := Posicione("EE6",1,xFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")
   HEADER_P->AVG_C16_20 := DToC(EEC->EEC_ETA)//ETA
   HEADER_P->AVG_C17_20 := DToC(EEC->EEC_ETD)//ETD
   HEADER_P->AVG_C13_20 := DToC(EEC->EEC_ETADES) //ETA destino
   //EEB_FILIAL+EEB_PEDIDO+EEB_OCORRE+EEB_CODAGE+EEB_TIPOAG

   EEB->(DbSetOrder(1))
   EEB->(DbSeek(xFilial("EEB")+EEC->EEC_PREEMB+OC_EM))
   While EEB->(!EoF()) .And. EEB->EEB_FILIAL == xFilial("EEB") .And. EEB->EEB_PEDIDO == EEC->EEC_PREEMB .And. ;
         EEB->EEB_OCORRE == OC_EM
      
      If LefT(EEB->EEB_TIPOAG,1) == "E"
         HEADER_P->AVG_C07_30 := EEB->EEB_NOME // Terminal
         Exit
      EndIf
      EEB->(DbSkip())
   EndDo
   
   HEADER_P->AVG_C14_20 := Transf(cSD, AVSX3("EE9_NRSD",AV_PICTURE))
   aSort(aRE,,,{|x,y| x[1] < y[1]})
   For i := 1 to Len(aRE) Step 2
      DETAIL_P->(DBAPPEND())
      DETAIL_P->AVG_SEQREL := cSeqRel 
      DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
      DETAIL_P->AVG_FILIAL := xFilial("EEC")
      DETAIL_P->AVG_CONT   := "D" //FLAG
      DETAIL_P->AVG_C01_60 := Transf(aRE[i][1] + aRE[i][2], AVSX3("EE9_RE",AV_PICTURE)) +;
      If(Len(aRe) >= (i+1),", " + Transf(aRE[i+1][1] + aRE[i+1][2], AVSX3("EE9_RE",AV_PICTURE)),"")+;
      If(Len(aRe) >= (i+2),",","")
   Next
   
   //gravar historico de documentos

   HEADER_H->(dbAppend())
   AvReplace("HEADER_P","HEADER_H")
   
   DETAIL_P->(dbSetOrder(0))      
   DETAIL_P->(DbGoTop())
   Do While ! DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo 

End Sequence

//retorna a situacao anterior ao processamento
RestOrd(aOrd)


Return lRet
         
//----------------------------------------------------------------------
/*Static Function TelaGets

   Local lRet  := .f.

   Local oDlg

   Local nOpc := 0, cPictProc
   Local bOk  := {|| nOpc:=1, oDlg:End() }
   Local bCancel := {|| oDlg:End() }
      
   Begin Sequence
      
      DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 16,50 OF oMainWnd
      If AVSX3("EE7_PEDIDO",6) == AVSX3("EEC_PREEMB",6)
         cPictPro := AVSX3("EE7_PEDIDO",6)
      Endif
      @  20,05 SAY STR0003 PIXEL //"Processo"
     If Empty(cPictPro)
         @  20,60 MSGET cProces SIZE 115,8 F3 "EYC" valid (fProcEmb(cProces)) PIXEL
      Else
         @  20,60 MSGET cProces PICT cPictProc SIZE 115,8 F3 "EYC" valid fProcEmb(cProces) PIXEL
      Endif   
      @  33,05 SAY STR0004 PIXEL //"Volume"
      @  33,60 MSGET cVolume SIZE 115,8 PIXEL
      
      ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED

      IF nOpc == 1
         lret := .t.
      ENDIF
      
   End Sequence

   Return lRet
*/
/*
Funcao      : fProcEmb(cProc)
Parametros  : numero do processo
Retorno     : .T. ou .F.
Objetivos   : Validar entrada de dados e trazer Descricao do volume
Autor       : Cristiane de Campos Figueiredo
Data/Hora   : 05/09/00 10:05
Revisao     :
Obs.        :
*/
/*Static Function fProcEmb(cProc)
   LOCAL lExPro, lRet := .T.
   Begin Sequence
      EEC->(DBSETORDER(1))
      EE7->(DBSETORDER(1))
      lTpEmb := EEC->(DBSEEK(XFILIAL("EEC")+cProc)) .and. EEC->EEC_STATUS <> ST_PC
      lExPro := EE7->(DBSEEK(XFILIAL("EE7")+cProc)) .and. EE7->EE7_STATUS <> ST_PC
      
      IF !lTpEmb .and. !lExPro
         HELP(" ",1,"REGNOIS")
         lRet := .f.
      Endif

      If Empty(cVolume)
         If lTpEmb 
            cVOLUME:=posicione("EE5",1,XFILIAL("EE5")+AVKEY(EEC->EEC_EMBAFI,"EE5_COD"),"EE5_DESC")
         Else 
            cVOLUME:=posicione("EE5",1,XFILIAL("EE5")+AVKEY(EE7->EE7_EMBAFI,"EE5_COD"),"EE5_DESC")
         Endif
     Endif
     
   End Sequence

   Return lRet
                  */
*-----------------------------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPRL10.PRW                                                                        *
*-----------------------------------------------------------------------------------------------------*