#INCLUDE "eecprl22.ch"
#Include "EECRDM.CH"

/*
Programa    : EECPRL22.
Objetivos   : Impressão Relatório de Pré-Calculo (Analítico/Sintético).
Autor       : Jeferson Barros Jr.
Data/Hora   : 23/09/2004 11:54.
Revisao     : 
Obs.        : 1) Para impressão do relatório, o sistema utiliza o arquivo Rel22.RPT;
              2) O relatório de pré-calculo será gerado apenas se o ambiente estiver 
                 configurado para a manutenção de Pré-Calculo em fase de embarque.
                 Todas as informações das despesas são carregas diretamente da tabela
                 EXM - (Histórico de Pré-Calculo) onde constam todas as despesas já
                 apuradas para os processos de embarque.
*/

/*
Funcao          : EECPRL22.
Parametros      : Nenhum.
Retorno         : .t./.f.
Objetivos       : Impressão Relatório de Pré-Calculo (Analítico/Sintético).
Autor           : Jeferson Barros Jr.
Data/Hora       : 23/09/2004 11:58.
Revisao         :
Obs.            :
*/
*----------------------*
User Function EECPRL22()
*----------------------*
Local nOldArea := Select()
Local lRet := .t., lRetC := .f., lAborta:= .F.

Private cProcesso, cCodDesp, cCodClient, cArqRpt, cTitRpt, cNomDbfC, cNomDbfD
Private oProcesso, oCodDesp, oCodClient
Private aArqs, aCamposC, aCamposD
Private lExisteDados:=.f.

#IFDEF TOP
  Private cWhere
#ELSE
  Private cWork
#ENDIF

Begin Sequence

   // ** Validações iniciais.
   If !EECFlags("COMPLE_EMB") .Or. !EECFlags("HIST_PRECALC")
      MsgStop(STR0001+Replic(ENTER,2)+; //"O relatório de Pré-Calculo não poderá ser gerado."
              STR0002+ENTER+; //"Detalhes:"
              STR0003+ENTER+; //"O ambiente não possui os tratamentos de pré-calculo para a fase "
              STR0004,STR0005) //"de embarque habilitados."###"Atenção"
      lAborta := .T. //wfs
      Break
   EndIf

   If Select("WorkId") > 0
      cArqRpt := WorkId->EEA_ARQUIV
      cTitRpt := AllTrim(WorkId->EEA_TITULO)
   EndIf

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()   

   cNomDbfC := "PRL22C"
   aCamposC := {{"SEQREL  ","C",008,0},;
                {"TITULO  ","C",100,0},;
                {"PROCESSO","C",100,0},;
                {"DESP    ","C",100,0},;
                {"CLIENT  ","C",100,0}}

   cNomDbfD := "PRL22D"
   aCamposD := {{"SEQREL    ","C", 8,0},;
                {"PROCESSO  ","C", AvSx3("EXM_PREEMB",AV_TAMANHO),0},;
                {"CLIDESCR  ","C", AvSx3("EEC_CLIEDE",AV_TAMANHO),0},;
                {"CODDESP   ","C", AvSx3("EXM_DESP"  ,AV_TAMANHO),0},;
                {"DESPDESCR ","C", AvSx3("EXM_DESCR" ,AV_TAMANHO),0},;
                {"MOEDA     ","C", AvSx3("EXM_MOEDA" ,AV_TAMANHO),0},;
                {"VALR      ","N", AvSx3("EXM_VALOR" ,AV_TAMANHO),AvSx3("EXM_VALOR" ,AV_DECIMAL)},;
                {"VALOR     ","N", AvSx3("EXM_VALOR" ,AV_TAMANHO),AvSx3("EXM_VALOR" ,AV_DECIMAL)}}

   aArqs := {}
   aAdd(aArqs,{cNomDbfC,aCamposC,"CAB","SEQREL"})
   aAdd(aArqs,{cNomDbfD,aCamposD,"DET","SEQREL"})
   aRetCrw := CrwNewFile(aARQS)

   If !TelaGets()
      lRet := .f.
      Break
   EndIf

   SelectData() // Seleciona os dados a serem impressos.

   If !lExisteDados
      MsgStop(STR0006,STR0005) //"Não há dados que satisfaçam as condições."###"Atenção"
      lRet:=.f.
      Break
   EndIf

   #IFDEF TOP
      Processa({|| lRet := Imprimir()})
      Qry->(DbCloseArea())

   #ELSE
      MsAguarde({||lRet := Imprimir()}, STR0007) //"Imprimindo Despesas ..."
      Qry->(E_EraseArq(cWork))
   #ENDIF

End Sequence

If Select("QRY") > 0
   Qry->(DbCloseArea())
EndIf

If !lAborta //wfs
    If lRet
        lRetC := CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
    Else
        CrwCloseFile(aRetCrw,.t.)
    EndIf
EndIf

DbSelectArea(nOldArea)

Return .f.

/*
Funcao          : SelectData()
Parametros      : Nenhum                  
Retorno         : .t./.f.
Objetivos       : Seleciona as informações a serem impressas.
                  Roda em ambientes Top e CodeBase.
Autor           : Jeferson Barros Jr.
Data/Hora       : 23/10/2004 - 16:29.
Revisao         :
Obs.            : 
*/
*--------------------------*
Static Function SelectData()
*--------------------------*
Local lRet:=.t.

#IFDEF TOP
   Local cCmd
   Private cSelect, cOrder
#ELSE
   Local aSemSx3:={}
   Private aCampos:={}
#ENDIF

Begin Sequence

   #IFDEF TOP
      cSelect := "Select EXM_PREEMB, EXM_DESP,  EXM_DESCR, "+;
                        "EXM_MOEDA , EXM_VALOR, EEC_CLIENT "

      cSelect += "From "+RetSqlName("EEC") + " EEC, "+RetSqlName("EXM")+" EXM "

      cWhere :=  "Where EEC.D_E_L_E_T_<> '*' And EEC_FILIAL = '"+xFilial("EEC")+"' And "+;
                       "EXM.D_E_L_E_T_<> '*' And EXM_FILIAL = '"+xFilial("EXM")+"' And "+;
                       "EEC_PREEMB = EXM_PREEMB And "+;
                       "EEC_DTEMBA = '        ' "

      If !Empty(cProcesso)
         cWhere += " And EEC_PREEMB ='"+cProcesso+"' "
      EndIf

      If !Empty(cCodClient)
         cWhere += " And EEC_CLIENT ='"+cCodClient+"' "
      EndIf

      If !Empty(cCodDesp)
         cWhere += " And EXM_DESP ='"+cCodDesp+"' "
      EndIf

      cOrder := "Order By EEC_PREEMB"

      cCmd := cSelect+cWhere+cOrder
      cCmd := ChangeQuery(cCmd)
      DbUseArea(.t.,"TOPCONN", TCGENQRY(,,cCmd), "Qry", .f., .t.)
      
      lExisteDados := !(Qry->(Eof()) .And. Qry->(Bof()))

   #ELSE

      aSemSX3 := {{"EXM_PREEMB","C",AVSX3("EXM_PREEMB",AV_TAMANHO),0},;     
                  {"EXM_DESP"  ,"C",AVSX3("EXM_DESP"  ,AV_TAMANHO),0},;     
                  {"EXM_DESCR" ,"C",AVSX3("EXM_DESCR" ,AV_TAMANHO),0},;     
                  {"EXM_MOEDA" ,"C",AVSX3("EXM_MOEDA ",AV_TAMANHO),0},;     
                  {"EXM_VALOR" ,"N",AVSX3("EXM_VALOR" ,AV_TAMANHO),AVSX3("EXM_VALOR" ,AV_DECIMAL)},;
                  {"EEC_CLIENT","C",AVSX3("EEC_CLIENT",AV_TAMANHO),0}}

      cWork  := E_CriaTrab(,aSemSX3,"Qry")
      IndRegua("Qry",cWork+OrdBagExt(),"EXM_PREEMB","AllwayTrue()","AllwaysTrue()","Processando Arquivo Temporario")
      Set Index to (cWork+OrdBagExt())

      EXM->(DbSetOrder(1))
      EEC->(DbSetOrder(1))

      If !Empty(cProcesso)
         If EEC->(DbSeek(xFilial("EEC")+AvKey(cProcesso,"EEC_PREEMB")))
            If EXM->(DbSeek(xFilial("EXM")+EEC->EEC_PREEMB))
               If !Empty(cCodDesp)
                  If EXM->EXM_DESP <> cCodDesp
                     Break
                  EndIf
               EndIf               
               
               Qry->(DbAppend())
               Qry->EXM_PREEMB := EXM->EXM_PREEMB
               Qry->EXM_DESP   := EXM->EXM_DESP
               Qry->EXM_DESCR  := EXM->EXM_DESCR
               Qry->EXM_MOEDA  := EXM->EXM_MOEDA
               Qry->EXM_VALOR  := EXM->EXM_VALOR
               Qry->EEC_CLIENT := EEC->EEC_CLIENT
               
               lExisteDados := .t.
            EndIf
         EndIf
      Else
         EEC->(DbSeek(xFilial("EEC")))

         Do While EEC->(!Eof()) .And. EEC->EEC_FILIAL == xFilial("EEC")
            If !Empty(EEC->EEC_DTEMBA)
               EEC->(DbSkip())
               Loop
            EndIf

            If !Empty(cCodClient)
               If EEC->EEC_CLIENT <> cCodClient
                  EEC->(DbSkip())
                  Loop
               EndIf
            EndIf

            If EXM->(DbSeek(xFilial("EXM")+EEC->EEC_PREEMB))
               Do While EXM->(!Eof()) .And. EXM->EXM_FILIAL == xFilial("EXM") .And.;
                                            EXM->EXM_PREEMB == EEC->EEC_PREEMB
                  If !Empty(cCodDesp)
                     If EXM->EXM_DESP <> cCodDesp
                        EXM->(DbSkip())
                        Loop
                     EndIf
                  EndIf

                  Qry->(DbAppend())
                  Qry->EXM_PREEMB := EXM->EXM_PREEMB
                  Qry->EXM_DESP   := EXM->EXM_DESP
                  Qry->EXM_DESCR  := EXM->EXM_DESCR
                  Qry->EXM_MOEDA  := EXM->EXM_MOEDA
                  Qry->EXM_VALOR  := EXM->EXM_VALOR
                  Qry->EEC_CLIENT := EEC->EEC_CLIENT

                  lExisteDados := .t.

                  EXM->(DbSkip())
               EndDo
            EndIf

            EEC->(DbSkip())
         EndDo
         Qry->(DbGoTop())
     EndIf
   #ENDIF

End Sequence

Return lRet

/*
Funcao          : Imprimir().
Parametros      : Nenhum.
Retorno         : .t./.f.
Objetivos       : Gravar os arquivos temporários para geração do relatório.
Autor           : Jeferson Barros Jr.
Data/Hora       : 24/09/2004 - 10:56.
Revisao         :
Obs.            :
*/
*------------------------*
Static Function Imprimir()
*------------------------*
Local lRet := .t.

#IFDEF TOP
   Local cCmd
   Local nOldArea
#ENDIF

Begin Sequence

   #IFDEF TOP
      If TcSrvType() <> "AS/400"
         nOldArea := Alias()

         cCmd := "Select COUNT(*) AS TOTAL From " +;
                     RetSqlName("EEC") + " EEC, "+RetSqlName("EXM")+" EXM "

         cCmd := ChangeQuery(cCmd+cWhere)
         DbUseArea(.t.,"TOPCONN", TcGenQry(,,cCmd),"QryTemp", .f., .t.)

         ProcRegua(QryTemp->TOTAL)

         QryTemp->(DbCloseArea())
         DbSelectArea(nOldArea)
      EndIf
   #ENDIF

   CAB->(DbAppend())
   CAB->SEQREL   := cSeqRel
   CAB->TITULO   := cTitRpt

   If !Empty(cProcesso)
      CAB->PROCESSO := cProcesso
   Else
      CAB->PROCESSO := STR0008 //"TODOS"
   EndIf

   If !Empty(cCodDesp)
      CAB->DESP := AllTrim(Posicione("SYB",1,xFilial("SYB")+cCodDesp,"YB_DESCR"))
   Else
      CAB->DESP := STR0009 //"TODAS"
   EndIf

   If !Empty(cCodClient)
      CAB->CLIENT := AllTrim(Posicione("SA1",1,xFilial("SA1")+cCodClient ,"A1_NREDUZ"))
   Else
      CAB->CLIENT := STR0008 //"TODOS"
   EndIf

   Do While Qry->(!Eof())

      #IFDEF TOP
         IF TcSrvType() <> "AS/400"
            IncProc(STR0010+ AllTrim(Transf(QRY->EXM_PREEMB,AvSx3("EXM_PREEMB",AV_PICTURE)))) //"Imprimindo processo : "
         EndIf
      #ENDIF

      DET->(DBAPPEND())
      DET->SEQREL    := cSeqRel 
      DET->PROCESSO  := Qry->EXM_PREEMB
      DET->CLIDESCR  := Posicione("SA1",1,xFilial("SA1")+Qry->EEC_CLIENT,"A1_NREDUZ")
      DET->CODDESP   := Qry->EXM_DESP
      DET->DESPDESCR := Qry->EXM_DESCR
      DET->MOEDA     := Qry->EXM_MOEDA
      DET->VALOR     := Qry->EXM_VALOR
      DET->VALR      := Round(Qry->EXM_VALOR*BuscaTaxa(Qry->EXM_MOEDA,dDataBase),2)

      Qry->(dbSkip())
   EndDo

End Sequence

Return lRet

/*
Funcao      : TelaGets.
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Tela para digitação dos filtros.
Autor       : Jeferson Barros Jr.
Data/Hora   : 24/09/04 15:27.
Revisao     :
Obs.        :
*/
*------------------------*
Static Function TelaGets()
*------------------------*
Local lRet:=.f.
Local oDlg
Local cGetxx
Local bOk :={|| lRet:=.t., oDlg:End()},;
      bCancel:= {|| oDlg:End()}

Begin Sequence

   cProcesso  := CriaVar("EEC_PREEMB")
   cCodClient := CriaVar("EEC_CLIENT")
   cCodDesp   := CriaVar("EXM_DESP")

   Define MsDialog oDlg Title STR0011 From 0,0 To 195,316 Of oMainWnd Pixel //"Relatório de Pré-Calculo"

      @ 15,004 To 095,155 LABEL STR0012 Pixel Of oDlg //"Filtros Iniciais"

      @ 27,015 Say AvSx3("EXM_PREEMB",AV_TITULO) Pixel Of oDlg
      @ 27,050 MsGet oProcesso Var cProcesso Picture AvSx3("EXM_PREEMB",AV_PICTURE);
                                     Size 055,08;
                                     Valid (Prl22Vld("PROCESSO"));
                                     F3 "EEC" Pixel Of oDlg

      @ 39,015 Say AvSx3("EX6_CLIENT",AV_TITULO) Pixel Of oDlg
      @ 39,050 MsGet oCodClient Var cCodClient Picture AvSx3("EEC_CLIENT",AV_PICTURE);
                                            Size 045,08;
                                            Valid Prl22Vld("CLIENTE");
                                            F3 "CLI" Pixel Of oDlg                                            

                                            

      @ 51,015 Say AvSx3("EXM_DESP",AV_TITULO) Pixel Of oDlg
      @ 51,050 MsGet oCodDesp Var cCodDesp Picture AvSx3("EXM_DESP",AV_PICTURE);
                                           Size 045,08;
                                           Valid Prl22Vld("DESPESA");
                                           F3 "SYB" Pixel Of oDlg

      @ 200,050 MsGet cGetXX 

   Activate MsDialog oDlg On Init EnChoiceBar(oDlg,bOk,bCancel) Centered

End Sequence

Return lRet

/*
Funcao      : Prl22Vld(cValidacao).
Parametros  : cValidacao - Indica qual validação deverá ser realizada.
Retorno     : .t./.f.
Objetivos   : Validações diversas.
Autor       : Jeferson Barros Jr.
Data/Hora   : 27/09/04 09:50.
Revisao     :
Obs.        :
*/
*----------------------------------*
Static Function Prl22Vld(cValidacao)
*----------------------------------*
Local lRet:=.t.

Begin Sequence

   cValidacao := Upper(AllTrim(cValidacao))

   Do Case
      Case cValidacao == "PROCESSO"

           If !Empty(cProcesso)
              lRet := ExistCpo("EEC")
           EndIf
           
           TrataObj()

      Case cValidacao == "CLIENTE"

           If !Empty(cCodClient)
              lRet := ExistCpo("SA1")
           EndIf

      Case cValidacao == "DESPESA"

           If !Empty(cCodDesp)
              lRet := ExistCpo("SYB")
           EndIf
   EndCase

End Sequence

Return lRet

/*
Funcao      : TrataObj().
Parametros  : Nenhum.
Retorno     : .t.
Objetivos   : Tratar os objetos do tipo get.
Autor       : Jeferson Barros Jr.
Data/Hora   : 27/09/04 09:37.
Revisao     :
Obs.        :
*/
*------------------------*
Static Function TrataObj()
*------------------------*
Local lRet:=.t.

Begin Sequence

   oProcesso:Enable()
   oCodClient:Enable()
   oCodDesp:Enable()

   If !Empty(cProcesso)
      EEC->(DbSetOrder(1))
      If EEC->(DbSeek(xFilial("EEC")+AvKey(cProcesso,"EEC_PREEMB")))
         cCodClient := EEC->EEC_CLIENT

         oCodClient:Disable()
         oCodDesp:Disable()

         cCodDesp:=CriaVar("EXM_DESP")
      EndIf
   EndIf

End Sequence

Return lRet                          
*-----------------------------------------------------------------------------------------------------------------*
*                                         FIM DO RDMAKE EECPRL22                                                  *
*-----------------------------------------------------------------------------------------------------------------*