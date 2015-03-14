#INCLUDE "EECPEM46.ch"

/*
Programa        : EECPEM46.PRW
Objetivo        : Impressao Packing List
Autor           : Osman Medeiros Jr. (OMJ)
Data/Hora       : 20/05/2002 16:00
Obs.            : 

considera que esta posicionado no registro de processos (embarque) (EEC)
*/
#include "EECRDM.CH"

#Define TAMDESC 60

/*
Funcao      : EECPEM46
Parametros  : 
Retorno     : lRet (.T.) - Se for Confirmado
                   (.F.) - Se for Cancelado
Objetivos   : Impressao Packing List
Autor       : Osman Medeiros Jr. (OMJ)
Data/Hora   : 20/05/2002 16:00
Revisao     :
Obs.        :
*/
*--------------------------------------------------------*
User Function EECPEM46()
*--------------------------------------------------------*
Local lRet := .t.
Local nAlias := Select(), i:=0
Local cFile1,cFile2,aFields,cMemo
Local cPortDest, cPortOrig
Local aOrd   := SaveOrd({"EE9","SA2","SY9","SA1",;
                         "SYA","SYQ","EEK","EE5",;
                         "SB1","EEV","EEW","SY0"})                         
Local lIngles := "INGLES" $ Upper(WorkId->EEA_IDIOMA)
Local aMeses := {"ENERO" ,"FEBRERO" ,"MARZO"     ,"ABRIL"  ,"MAYO"     ,"JUNIO"    ,;
                 "JULIO" ,"AGOSTO"  ,"SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"}

Private cFileMen:=""
Private lHistorico := .f.
Private lProdPai := .f.
Private aMarcados[2], nMarcado := 0
Private cPict := "999,999,999.99"

Private cPictDecPrc := if(EEC->EEC_DECPRC > 0, "."+Replic("9",EEC->EEC_DECPRC),"")
Private cPictDecPes := if(EEC->EEC_DECPES > 0, "."+Replic("9",EEC->EEC_DECPES),"")
Private cPictDecQtd := if(EEC->EEC_DECQTD > 0, "."+Replic("9",EEC->EEC_DECQTD),"")

Private cPictPreco := "9,999"+cPictDecPrc
Private cPictPeso  := "9,999,999"+cPictDecPes
Private cPictQtde  := "9,999,999"+cPictDecQtd

Private aHeader := {}, aCampos := Array(0)

Begin Sequence

   EEV->(dbSetOrder(1))
   EEW->(dbSetOrder(1))
   SB1->(dbSetOrder(1))

   // Notify
   nCod := AVSX3("EEN_IMPORT",3)+AVSX3("EEN_IMLOJA",3)
   aFields := {{"WKMARCA","C",02,0},;
               {"WKCODIGO","C",nCod,0},;
               {"WKDESCR","C",AVSX3("EEN_IMPODE",3),0}} 
               
   //GFP 25/10/201
   aFields := AddWkCpoUser(aFields,"EEN")            
                        
   cFile1 := E_CriaTrab(,aFields,"WkNoti")
   IndRegua("WkNoti",cFile1+OrdBagExt(),"WKCODIGO")

   aHeader := {}
   aCampos := Array(0)

   aFields := {{"WKCAIXA" ,"C",AvSx3("EE5_CODEMB",AV_TAMANHO),AvSx3("EE5_CODEMB",AV_DECIMAL)},;
               {"WKDESCR" ,"M",TAMDESC,0},;
               {"WKPESOB" ,"N",AvSx3("EE9_PSBRUN",AV_TAMANHO),AvSx3("EE9_PSBRUN",AV_DECIMAL)},;
               {"WKDIMENS","C",AvSx3("EE5_DIMENS",AV_TAMANHO),AvSx3("EE5_DIMENS",AV_DECIMAL)}}
            
   cFile2 := E_CriaTrab(,aFields,"Work")

   If !TelaGets1()
      lRet := .f.
      Break   
   EndIf
   
   If lHistorico
      If !BuscaHist()
         MsgInfo(STR0001+ENTER+; //"Não foram encontrados dados no Histórico"
                 STR0002,STR0003) //"para este documento, as informações virão do Embarque."###"Informação"
         GravaItens()
      EndIf
   Else
      GravaItens()
   EndIf   

   If !TelaGets2()
      lRet := .f.
      Break   
   EndIf

   cSeqRel := GetSXENum("SY0","Y0_SEQREL")
   ConfirmSX8()
   
   HEADER_P->(Add())



   IF !Empty(EEC->EEC_EXPORT)
      cCod := EEC->EEC_EXPORT
      cLoja:= EEC->EEC_EXLOJA
   Else
      cCod := EEC->EEC_FORN
      cLoja:= EEC->EEC_FOLOJA
   Endif
   
   HEADER_P->AVG_C09_60 := EECContato(CD_SA2,cCod,cLoja,"1",1,EEC->EEC_RESPON)
   
   // Exportador
   HEADER_P->AVG_C10_60 := Posicione("SA2",1,xFilial("SA2")+cCod+cLoja,"A2_NOME")
   HEADER_P->AVG_C11_60 := EECMEND("SA2",1,cCod+cLoja,.F.,60)
   HEADER_P->AVG_C12_60 := STR0004 + AllTrim(SA2->A2_TEL) + STR0005 + AllTrim(SA2->A2_FAX) //"Tel.: "###"  Fax.: "
   
   //Contato
   HEADER_P->AVG_C09_60 := EECContato(CD_SA2,cCod,cLoja,"1",1,EEC->EEC_RESPON)

   // To
   HEADER_P->AVG_C01_60 := EEC->EEC_IMPODE
   HEADER_P->AVG_C02_60 := EEC->EEC_ENDIMP
   HEADER_P->AVG_C03_60 := EEC->EEC_END2IM
   
   // Consignee
   HEADER_P->AVG_C05_60 := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_CONSIG+EEC->EEC_COLOJA,"A1_NOME")
   HEADER_P->AVG_C06_60 := EECMEND("SA1",1,EEC->EEC_CONSIG+EEC->EEC_COLOJA,.T.,58,1)
   HEADER_P->AVG_C07_60 := EECMEND("SA1",1,EEC->EEC_CONSIG+EEC->EEC_COLOJA,.T.,60,2)

   //Notify
   n := 1
   For i:=1 To 2
      IF !Empty(aMarcados[i])
         nTamLoj := AVSX3("EEN_IMLOJA",3)
         cKey    := aMarcados[i]
         cLoja   := Right(cKey,nTamLoj) 
         cImport := Subst(cKey,1,Len(cKey)-nTamLoj)
         
         IF EEN->(dbSeek(xFilial()+AvKey(EEC->EEC_PREEMB,"EEN_PROCES")+OC_EM+AvKey(cImport,"EEN_IMPORT")+AvKey(cLoja,"EEN_IMLOJA")))
            If n = 1  
               HEADER_P->AVG_C13_60 := EEN->EEN_IMPODE
               HEADER_P->AVG_C14_60 := EEN->EEN_ENDIMP
               HEADER_P->AVG_C15_60 := EEN->EEN_END2IM
            Else
               HEADER_P->AVG_C16_60 := EEN->EEN_IMPODE
               HEADER_P->AVG_C17_60 := EEN->EEN_ENDIMP
               HEADER_P->AVG_C18_60 := EEN->EEN_END2IM
            EndIf
            n++
         Endif
      Endif
   Next

  //Route
   x := AllTrim(Posicione("SYQ",1,xFilial("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"))
   HEADER_P->AVG_C01_10 := Substr(x,At("-",x)+1)

   // Port of Discharge
   cPortDest := Posicione("SY9",2,xFilial("SY9")+EEC->EEC_DEST,"Y9_DESCR")
   HEADER_P->AVG_C01_20 := IF("/"$cPortDest,Subst(cPortDest,1,At("/",cPortDest)-1),cPortDest)
   
   // Port of Loading
   cPortOrig := Posicione("SY9",2,xFilial("SY9")+EEC->EEC_ORIGEM,"Y9_DESCR")
   HEADER_P->AVG_C04_20 := IF("/"$cPortOrig,Subst(cPortOrig,1,At("/",cPortOrig)-1),cPortOrig)

   // Coutry of Discharge
   cCodPais := Posicione("SYR",1,xFilial("SYR")+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA,"YR_PAIS_DE")
   HEADER_P->AVG_C02_20 := Posicione("SYA",1,xFilial("SYA")+cCodPais,"YA_DESCR")
   
   // Invoice Nr.
   HEADER_P->AVG_C02_10 := AllTrim(EEC->EEC_NRINVO)
   
   // Date 
   HEADER_P->AVG_C03_20 := Upper(IF(lIngles,cMonth(EEC->EEC_DTINVO),IF(EMPTY(EEC->EEC_DTINVO),"",aMeses[Month(EEC->EEC_DTINVO)])))+" "+StrZero(Day(EEC->EEC_DTINVO),2)+", "+Str(Year(EEC->EEC_DTINVO),4)+"."

   // Marks
   HEADER_P->AVG_C07_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),1)
   HEADER_P->AVG_C08_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),2)
   HEADER_P->AVG_C09_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),3)
   HEADER_P->AVG_C10_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),4)
   HEADER_P->AVG_C11_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),5)
   HEADER_P->AVG_C12_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),6)
  
   Work->(dbGoTop())   
   
   nPesoBru := 0
   nTotEmb  := 0 
   
   While !Work->(Eof())

      DETAIL_P->(Add())     
      
      DETAIL_P->AVG_C01_20 := Work->WKCAIXA
      DETAIL_P->AVG_C02_20 := Work->WKDIMENS
      DETAIL_P->AVG_C03_20 := Trans(Work->WKPESOB,cPictPeso)
      
      nPesoBru += Work->WKPESOB
      nTotEmb++

      cMemo := Work->WKDESCR

      DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,1)

      For i := 2 To MlCount(cMemo,TAMDESC)
          DETAIL_P->(dbUnlock())   
          DETAIL_P->(Add())     
          DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,i)
      Next

      DETAIL_P->(dbUnlock())   
    
      DETAIL_P->(Add())     
      DETAIL_P->(dbUnlock())
      
      Work->(dbSkip())
   
   EndDo

   HEADER_P->AVG_C13_20 := AllTrim(StrZero(nTotEmb,3))
   HEADER_P->AVG_C14_20 := AllTrim(Tran(EEC->EEC_PESLIQ,cPictPeso))
   HEADER_P->AVG_C15_20 := AllTrim(Tran(nPesoBru,cPictPeso))
   
   If Select("Work_Men") > 0
      Work_Men->(dbGoTop())   
      While !Work_Men->(Eof()) .And. Work_Men->WKORDEM < "zzzzz"
         For i := 1 To MlCount(Work_Men->WKOBS,TAMDESC)
            If !Empty(MemoLine(Work_Men->WKOBS,TAMDESC,i))
               DETAIL_P->(Add())     
               DETAIL_P->AVG_C01_60 := MemoLine(Work_Men->WKOBS,TAMDESC,i)
               DETAIL_P->(dbUnlock())
            EndIf
         Next
         Work_Men->(dbSkip())
      Enddo
   Endif

   HEADER_P->(dbUnlock())

   //***  - Gravar histórico de documentos  - ***/  
   HEADER_H->(dbAppend())
   AvReplace("HEADER_P","HEADER_H")  

   DETAIL_P->(dbSetOrder(0),dbGoTop())
   Do While ! DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo
   DETAIL_P->(dbSetOrder(1))

   HEADER_P->(dbCommit())
   DETAIL_P->(dbCommit())

End Sequence

IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cFileMen))
Endif

Work->(E_EraseArq(cFile2))
WkNoti->(E_EraseArq(cFile1))

RestOrd(aOrd)
Select(nAlias)

Return lRet


/*
Funcao      : TelaGets1
Parametros  : 
Retorno     : lRet (.T.) - Se for Confirmado
                   (.F.) - Se for Cancelado
Objetivos   : Tela para selecao de parametros
Autor       : Osman Medeiros Jr. (OMJ)
Data/Hora   : 21/05/2002 15:00
Revisao     : 
Obs.        :
*/
*--------------------------------------------------------*
Static Function TelaGets1()
*--------------------------------------------------------*
Local oDlg, oYesH, oNoH, oYesP, oNoP
Local lRet    := .f.
Local nOpc    := 0
Local bOk     := {|| nOpc:=1 , oDlg:End() }
Local bCancel := {|| nOpc:=0 , oDlg:End() }
Local bSetH   := {|x,o| lHistorico := x, o:Refresh(), lHistorico }
Local bSetP   := {|x,o| lProdPai := x, o:Refresh(), lProdPai }

Begin Sequence

   Define MsDialog oDlg Title WorkId->EEA_TITULO From 9,0 TO 21,50 Of oMainWnd

     @ 25,20 Say STR0006 Size 232,10 Pixel Of oDlg //"Produto Pai?"

     oYesP := TCheckBox():New(25,110,STR0007,; //"Sim"
              {|x| If(PCount()==0, lProdPai,Eval(bSetP, x,oNoP ))},oDlg,21,10,,,,,,,,.T.) 
     oNoP  := TCheckBox():New(35,110,STR0008,; //"Nao"
              {|x| If(PCount()==0,!lProdPai,Eval(bSetP,!x,oYesP))},oDlg,21,10,,,,,,,,.T.) 

     @ 50,20 Say STR0009 Size 232,10 Pixel Of oDlg //"Buscar última Impressão?"

     oYesH := TCheckBox():New(50,110,STR0007,; //"Sim"
              {|x| If(PCount()==0, lHistorico,Eval(bSetH, x,oNoH ))},oDlg,21,10,,,,,,,,.T.) 
     oNoH  := TCheckBox():New(60,110,STR0010,; //"Não"
              {|x| If(PCount()==0,!lHistorico,Eval(bSetH,!x,oYesH))},oDlg,21,10,,,,,,,,.T.) 

   Activate MsDialog oDlg Centered On Init EnchoiceBar(oDlg,bOk,bCancel)

   If nOpc == 0
      Break
   EndIf
   
   lRet:= .T.

End Sequence

Return lRet


/*
Funcao      : TelaGets2
Parametros  : 
Retorno     : lRet (.T.) - Se for Confirmado
                   (.F.) - Se for Cancelado
Objetivos   : Tela para Edicao/Visualizacao do itens.
Autor       : Osman Medeiros Jr. (OMJ)
Data/Hora   : 21/05/2002 15:00
Revisao     : 
Obs.        :
*/
*--------------------------------------------------------*
Static Function TelaGets2()
*--------------------------------------------------------*
Local oDlg, oMark,oFld
Local lRet    := .f.
Local nOpc    := 0
Local bOk     := {|| nOpc:=1 , oDlg:End() }
Local bCancel := {|| nOpc:=0 , oDlg:End() }
Local xx      := ""
Local aPos

Local cMarca  := GetMark(), lInverte := .F.
Local aIt_Campos := {{"WKCAIXA" ,,STR0011   },; //"Embalagem"
                    {{|| MemoLine(Work->WKDESCR,TAMDESC,1) },,STR0012},; //"Descricao"
                    {"WKDIMENS",,STR0013    },; //"Dimensão"
                    {"WKPESOB" ,,STR0014,"@E " + cPictPeso}} //"Peso Bruto"

Local aNt_Campos := {{"WKMARCA",," "},;
                    {"WKCODIGO",,STR0015},;  //"Código"
                    {"WKDESCR",,STR0016}}  //"Descrição"

Local bHide    := {|nTela| if(nTela==1,oMark:oBrowse:Hide(),;
                           if(nTela==2,oMark2:oBrowse:Hide(),;
                           if(nTela==3,oMark3:oBrowse:Hide(),))) }

Local bHideAll := {|| Eval(bHide,2), Eval(bHide,3) }

Local bShow    := {|nTela,o| if(nTela==1,dbSelectArea("Work"),if(nTela==2,dbSelectArea("WkNoti"),;
                              if(nTela==3,dbSelectArea("Work_Men"),))),;
                              o := if(nTela==1,oMark,if(nTela==2,oMark2,oMark3)):oBrowse,;
                              o:Show(),o:SetFocus() }

Private aHeader := {}, aCampos := Array(0)

Begin Sequence

   If Work->(RecCount()) = 0
      MsgInfo(STR0017,STR0003) //"Não foram encontrados dados para este documento."###"Informação"
      Break   
   EndIf

   EEN->(dbSeek(xFilial()+EEC->EEC_PREEMB+OC_EM))

   While EEN->(!Eof() .And. EEN_FILIAL == xFilial("EEN")) .And.;
       EEN->EEN_PROCES+EEN->EEN_OCORRE == EEC->EEC_PREEMB+OC_EM
       
      SysRefresh()
      
      WkNoti->(dbAppend())
      WkNoti->WKCODIGO := EEN->EEN_IMPORT+EEN->EEN_IMLOJA
      WkNoti->WKDESCR  := EEN->EEN_IMPODE
       
      EEN->(dbSkip())
      
   Enddo   

   WkNoti->(dbGoTop())
   Work->(dbGoTop())  
  
   Define MsDialog oDlg Title WorkId->EEA_TITULO From 9,0 TO 30,100 Of oMainWnd

     aPos  := PosDlg(oDlg)        
     oFld := TFolder():New(aPos[1],aPos[2],{STR0018,STR0019,STR0020},{"IBC","OBS","MEN"},oDlg,,,,.T.,.F.,aPos[4],aPos[3]-15)  //"Itens"###"Notify's"###"Observações"
     aEval(oFld:aControls,{|x| x:SetFont(oDlg:oFont) })

     // Folder Itens ...
     aPos   := PosDlg(oFld)
     aPos[1]+= 15
     aPos[2]+= 4
     aPos[3]+= 15
     oMark := MsSelect():New("Work","",,aIt_Campos,@lInverte,@cMarca,aPos)
     @ 14,043 GET xx OF oFld:aDialogs[1]     
     oMark:bAval := {|| EditMemo() } 
     
     //GFP 25/10/2010
     aNt_Campos := AddCpoUser(aNt_Campos,"EEN","2")
    
     // Folder Notify's ...
     oMark2 := MsSelect():New("WkNoti","WKMARCA",,aNt_Campos,@lInverte,@cMarca,aPos)
     oMark2:bAval := {|| ChkMarca(oMark,cMarca) }
     @ 14,043 GET xx OF oFld:aDialogs[2]     
     AddColMark(oMark2,"WKMARCA")
     
     // Folder Observações ...
     @ 14,043 GET xx OF oFld:aDialogs[3]
     oMark3 := EECMensagem(EEC->EEC_IDIOMA,"#",aPos,,,,oDlg)

     Eval(bHideAll)
     
     oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),Eval(bShow,nOption) }
 
   Activate MsDialog oDlg Centered On Init EnchoiceBar(oDlg,bOk,bCancel)

   If nOpc == 0
      Break
   EndIf

   lRet:= .T.

End Sequence

Return lRet

/*
Funcao      : EditMemo
Parametros  : 
Retorno     : 
Objetivos   : Edicao dos itens do Packing List.
Autor       : Osman Medeiros Jr. (OMJ)
Data/Hora   : 21/05/2002 15:00
Revisao     :
Obs.        :
*/
*--------------------------------------------------------*
Static Function EditMemo()
*--------------------------------------------------------*
Local nOpc, cMemo, nPesoB, cDimens, oDlg, oFont2, aPos

Local bOk     := {|| nOpc:=1, oDlg:End() }
Local bCancel := {|| nOpc:=0, oDlg:End() }

Begin Sequence

   cMemo   := Work->WKDESCR
   nPesoB  := Work->WKPESOB
   cDimens := Work->WKDIMENS

   Define MsDialog oDlg Title WorkId->EEA_TITULO From 9,0 TO 30,100 Of oMainWnd

     oFont2 := TFont():New("Courier New",8,15)
     
     aPos := PosDlg(oDlg)
     oGroup := TGroup():New(aPos[1],aPos[2],aPos[3],aPos[4],,oDlg,,,.T.,.T.)
      
     @ 20,05 Say STR0011 Pixel //"Embalagem"
     @ 20,55 Get Work->WKCAIXA Size 40,08 When .F. Pixel

     @ 35,05 Say STR0016 Pixel //"Descrição"
     @ 35,55 Get cMemo MEMO Size 270,75 Pixel HSCROLL FONT oFont2

     @ 115,05 Say STR0013 Pixel //"Dimensão"
     @ 115,55 Get cDimens Picture "@!" Size 80,08 Pixel

     @ 130,05 Say STR0014 Pixel //"Peso Bruto"
     @ 130,55 Get nPesoB Picture AvSx3("EE9_PSBRTO",AV_PICTURE) Size 60,08 Pixel

   Activate MsDialog oDlg Centered On Init EnchoiceBar(oDlg,bOk,bCancel)

   If nOpc == 1
      Work->WKDESCR  := cMemo
      Work->WKPESOB  := nPesoB
      Work->WKDIMENS := cDimens
   EndIf

End Sequence
     
Return Nil

/*
Funcao      : GravaItens
Parametros  : 
Retorno     : 
Objetivos   : Gravacao dos Itens do Packing List na Work.
Autor       : Osman Medeiros Jr. (OMJ)
Data/Hora   : 21/05/2002 15:00
Revisao     :
Obs.        :
*/
*--------------------------------------------------------*
Static Function GravaItens()
*--------------------------------------------------------*
Local cFilEEW := xFilial("EEW") ,; 
      cFilEEV := xFilial("EEV") ,; 
      cFilSB1 := xFilial("SB1") ,; 
      cFilEE9 := xFilial("EE9") 

Local nRecEEV, nRecWork
Local bExec,bFor,bWhile
Local nPesoBru := nVez := nTotEmb := nEmb := 0
Local cOnThePackage := AllTrim(EEC->EEC_ONTHEP)
      
Begin Sequence

   EE9->(dbSeek(cFilEE9+EEC->EEC_PREEMB))

   While !EE9->(Eof()) .And. EE9->EE9_FILIAL == cFilEE9 .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB
      

      If lProdPai  // Produto Pai...
         
         If !EEV->(dbSeek(cFilEEV+EE9->EE9_COD_I))
            MsgStop(STR0021 +; //"Não foi encontrada composição de embalagens para o produto: "
                    AllTrim(EE9->EE9_COD_I),STR0022) //"Atenção"
            EE9->(dbSkip())        
            Loop
         EndIf

         nVez := 0          
         
         While !EEV->(Eof()) .And. EEV->EEV_FILIAL == cFilEEV .And.;
               EEV->EEV_COD_I  == EE9->EE9_COD_I

            EEW->(dbSeek(cFilEEW+EEV->(EEV_COD_I+EEV_SEQUEN)))


            Work->(dbAppend())

            Work->WKDIMENS := EEV->EEV_DIMENS
            Work->WKPESOB  := EEV->EEV_PESBRU
            
            If nVez = 0 
               
               SB1->(dbSeek(cFilSB1+EE9->EE9_COD_I))         
               
               Work->WKDESCR := Trans(EE9->EE9_SLDINI,cPictQtde) +;
                                " P/N " + AllTrim(EE9->EE9_COD_I) + " " +;
                                AllTrim(SB1->B1_DESC) + ENTER
            EndIf

            nRecWork := Work->(RecNo())                 
            
            While !EEW->(Eof()) .And. EEW->EEW_FILIAL  == cFilEEW .And.;
                  EEW->(EEW_COD_I+EEW_SEQUEN) == EEV->(EEV_COD_I+EEV_SEQUEN)
                  
               SB1->(dbSeek(cFilSB1+EEW->EEW_PROEMB))                              
                             
               Work->WKDESCR := Work->WKDESCR +;
                                Trans(EEW->EEW_QTDE,cPictQtde) +;
                                " P/N " + AllTrim(EEW->EEW_PROEMB) + " " + ;
                                AllTrim(SB1->B1_DESC) + ENTER
                                
               EEW->(dbSkip())
    
            EndDo   
                        
            nVez++
            EEV->(dbSkip())

         EndDo                 
      
      Else 
         
         If !Empty(EEC->EEC_EMBAFI) // Campo Volume 
            
            If nVez = 0
            
               Work->(dbAppend())
     
               EE5->(dbSeek(xFilial()+EEC->EEC_EMBAFI))

               cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
   
               Work->WKDIMENS := EE5->EE5_DIMENS
               Work->WKDESCR  := Trans(EE9->EE9_SLDINI,cPictQtde) +;
                                 " P/N " + AllTrim(EE9->EE9_COD_I) + " " + ;
                                 AllTrim(cMemo) + ENTER

               Work->WKPESOB := EEC->EEC_PESBRU
             
            Else 

               cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))

               Work->WKDESCR  := Work->WKDESCR + ENTER +;
                                 Trans(EE9->EE9_SLDINI,cPictQtde) +;
                                 " P/N " + AllTrim(EE9->EE9_COD_I) + " " +;
                                 AllTrim(cMemo) + ENTER
            
            
            EndIf
            nVez++
            
         Else
            
            Work->(dbAppend())

            If EEK->(AVSeekLast(xFilial()+OC_EM+EEC->EEC_PREEMB+EE9->EE9_SEQEMB+EE9->EE9_EMBAL1))
               cEmb := EEK->EEK_EMB
            Else
               cEmb := EE9->EE9_EMBAL1
            Endif
      
            EE5->(dbSeek(xFilial()+cEmb))

            cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))

            Work->WKDIMENS := EE5->EE5_DIMENS
            Work->WKDESCR  := Trans(EE9->EE9_SLDINI,cPictQtde) +;
                              " P/N " + AllTrim(EE9->EE9_COD_I) + " " +;
                              AllTrim(cMemo) + ENTER

            Work->WKPESOB := EE9->EE9_PSBRTO
            
            cOnThePackage := ""

         EndIf      
      
      EndIf
      
      EE9->(dbSkip())       
      
   Enddo
      
   Work->(dbGoTop())

   nEmb    := 0
   nTotEmb := Work->(RecCount())
   bExec   := {|| nEmb++,Work->WKCAIXA := AllTrim(StrZero(nEmb,3)) + "/" + AllTrim(StrZero(nTotEmb,3))}
   bFor    := {|| .T.}
   bWhile  := {|| .T.}
   
   Work->(dbEval(bExec,bFor,bWhile))       


End Sequence
                                                          
Return Nil

/*
Funcao      : Add
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Osman Medeiros Jr. (OMJ)
Data/Hora   : 21/05/2002 15:00
Revisao     :
Obs.        :
*/
*--------------------------------------------------------*
Static Function Add()
*--------------------------------------------------------*

Begin Sequence
   dbAppend()

   bAux:=FieldWBlock("AVG_FILIAL",Select())

   IF ValType(bAux) == "B"
      Eval(bAux,xFilial("SY0"))
   Endif

   bAux:=FieldWBlock("AVG_CHAVE",Select())

   IF ValType(bAux) == "B"
      Eval(bAux,EEC->EEC_PREEMB)
   Endif

   bAux:=FieldWBlock("AVG_SEQREL",Select())

   IF ValType(bAux) == "B"
      Eval(bAux,cSeqRel)
   Endif

End Sequence

Return Nil


/*
Funcao      : BuscaHist
Parametros  : 
Retorno     : lRet (.T.) - Se encontrou os dados
                   (.F.) - Se nao encontrou os dados
Objetivos   : Buscar do Historico de Documentos os dados 
              da ultima impressao do documento selecionado.
Autor       : Osman Medeiros Jr. (OMJ)
Data/Hora   : 21/05/2002 15:00
Revisao     :
Obs.        :
*/
*--------------------------------------------------------*
Static Function BuscaHist()
*--------------------------------------------------------*
Local cSY0Seq := ""
Local lRet := .f.

Begin Sequence

   SY0->(dbSetOrder(4))
   If ( SY0->(dbSeek(xFilial("SY0")+EEC->EEC_PREEMB+"2"+WorkId->EEA_COD))) 

      Do While !SY0->(Eof()) .AND. SY0->Y0_FILIAL = xFilial("SY0") .and. SY0->Y0_PROCESS = EEC->EEC_PREEMB .AND.;
                SY0->Y0_FASE = "2" .AND. SY0->Y0_CODRPT = WorkId->EEA_COD         
         cSY0Seq:= SY0->Y0_SEQREL
         SY0->(DbSkip())
      EndDo    

      //HEADER_H->(DbSetOrder(1))
      //If HEADER_H->(DbSeek("  "+cSY0Seq+EEC->EEC_PREEMB)) 
      //EndIf

      DETAIL_H->(DbSetOrder(1))
      If DETAIL_H->(DbSeek("  "+cSY0Seq+EEC->EEC_PREEMB))                           

         Do While DETAIL_H->(!Eof()) .And. DETAIL_H->AVG_SEQREL = cSY0Seq                                 
            
            If !Empty(DETAIL_H->AVG_C01_20) 
            
               Work->(dbAppend())  
               Work->WKCAIXA  := DETAIL_H->AVG_C01_20               
               Work->WKDIMENS := DETAIL_H->AVG_C02_20 
               Work->WKPESOB  := Val(StrTran(DETAIL_H->AVG_C03_20,",",""))
               
            EndIf   

            Work->WKDESCR  := Work->WKDESCR + DETAIL_H->AVG_C01_60 + ENTER
        
            DETAIL_H->(DbSkip())

         EndDo

         lRet := .T.      

      EndIf               
     
   EndIf

End Sequence

Return lRet

/*
Funcao      : ChkMarca
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function ChkMarca(oMark,cMarca)

Local n

Begin Sequence

   If ! WkNoti->(Eof() .Or. Bof())

      If !Empty(WkNoti->WKMARCA) 
         // Desmarca
         n := aScan(aMarcados,WkNoti->WKCODIGO)
         IF n > 0
            aMarcados[n] := ""
         Endif
         
         WkNoti->WKMARCA := Space(2)

      Else
         // Marca
         IF !Empty(aMarcados[1]) .And. !Empty(aMarcados[2])
            HELP(" ",1,"AVG0005046") //MsgStop("Já existem dois notify's selecionados !","Aviso")
            Break
         Endif
         
         IF Empty(aMarcados[1])
            aMarcados[1] := WkNoti->WKCODIGO
         Else
            aMarcados[2] := WkNoti->WKCODIGO
         Endif
         
         WkNoti->WKMARCA := cMarca

      Endif
      
      oMark:oBrowse:Refresh()

   Endif

End Sequence

Return NIL