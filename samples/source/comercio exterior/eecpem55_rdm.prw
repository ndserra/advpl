
/*
Programa        : EECPEM55_RDM.PRW.
Objetivo        : Impressao do Packing List (Modelo 4).
Autor           : Jeferson Barros Jr.
Data/Hora       : 15/12/2003 18:11.
Obs.            : Desenvolvido Inicialmente para a S.M. (ECSME03).
*/

#Include "EECRDM.CH"
#Include "EECPEM55.CH"

#DEFINE TAMDESC 37

/*
Funcao      : EECPEM55.
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivo    : Impressao do Packing List (Modelo 4).
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/12/2003 18:11.
Revisao     : 
Obs.        :
*/
*---------------------*
User Function EECPEM55
*---------------------*
Local lRet := .t., aOrd := SaveOrd({"EEC","EE9","SA2","SX5","SYR"})
Local cMemo:="", cWkTexto:="", cSY0Seq:="", nItensEE9:=0, z, nX:=0

Private cTitulo:="",dData:=AvCTod("  /  /  "),cRespon:="",nOriCpy:=3,;
        cQuantity := Space(15),cNetWeight := Space(15),;
        cGrWeight := Space(15),cVolume    := Space(15),;
        cUnWeiNet:=Space(10),cUnWeiGros:=Space(10),nSldini:=0,nCubage:=0,cMemoMarca:="",nLinhasSp:=0,;
        nLinhasMemo:=0

// ** Definicao de pictures de acordo com as casas decimais definidas na capa do embarque.
Private cPict := "@E 999,999,999.99"
Private cPictDim := "@E 999,999,999.999999"
Private cPictDecPrc := if(EEC->EEC_DECPRC > 0, "."+Replic("9",EEC->EEC_DECPRC),"")
Private cPictDecPes := if(EEC->EEC_DECPES > 0, "."+Replic("9",EEC->EEC_DECPES),"")
Private cPictDecQtd := if(EEC->EEC_DECQTD > 0, "."+Replic("9",EEC->EEC_DECQTD),"")
Private cPictPreco := "@E 9,999"+cPictDecPrc
Private cPictPeso  := "@E 9,999,999"+cPictDecPes
Private cPictQtde  := "@E 9,999,999"+cPictDecQtd
Private cPictVol   := "@EZ 999,999.999999"
   
Private cObs   := "", cFileMen:=""
Private cMarca := GetMark(), lInverte := .f.//,cSEQREL
PRIVATE lINGLES,lFRANCES,lESPANHOL,cIMPMEMO,cEXPMEMO

Static aMESES := {"ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"}

//Usado no EECF3EE3 via SXB "E34" para Get de Assinante
M->cSEEKEXF:=""
M->cSEEKLOJA:=""

Begin Sequence   

   // BAK - Desvio para o rdmake correto - 29/07/2011
   If FindFunction("U_EECPEM54")
      U_EECPEM54()
      Break
   EndIf

   cIMPMEMO  := cEXPMEMO := ""
   lINGLES   := "INGLES" $ UPPER(WORKID->EEA_IDIOMA)
   lFRANCES  := "FRANCE" $ UPPER(WORKID->EEA_IDIOMA)
   lESPANHOL := "ESP."   $ UPPER(WORKID->EEA_IDIOMA)
   
   SY0->(DBSETORDER(4))
   IF ( SY0->(DBSEEK(XFILIAL("SY0")+EEC->EEC_PREEMB+"2"+WorkId->EEA_COD))) .AND.;
      MSGYESNO(STR0001,STR0002) //"Deseja manter os dados da ultima impressão ?"###"Atenção"

      Do While !SY0->(EOF()) .AND. SY0->Y0_FILIAL = XFILIAL("SY0") .and. SY0->Y0_PROCESS = EEC->EEC_PREEMB .AND.;
                SY0->Y0_FASE = "2" .AND. SY0->Y0_CODRPT = WorkId->EEA_COD
         cSY0Seq:= SY0->Y0_SEQREL
         SY0->(DbSkip())
      EndDo

      HEADER_H->(DbSetOrder(1))
      If (HEADER_H->(DbSeek("  "+cSY0Seq+EEC->EEC_PREEMB)))
         cTitulo   := HEADER_H->AVG_C01_60
         dData     := HEADER_H->AVG_D01_08
         cRespon   := PADR(HEADER_H->AVG_C13_60,35," ")
      Else
         // ** Set dos variáveis...
         cTitulo   := WORKID->EEA_TITULO
         dData     := dDataBase 
         cRespon   := PADR(EEC->EEC_RESPON,35," ")
      EndIf
      
      DETAIL_H->(DbSetOrder(1))
      If (DETAIL_H->(DbSeek("  "+cSY0Seq+EEC->EEC_PREEMB)))                           
         cQuantity  := LEFT(DETAIL_H->AVG_C05_20,15)
         cNETWEIGHT := LEFT(DETAIL_H->AVG_C03100,15)
         cGRWEIGHT  := LEFT(DETAIL_H->AVG_C02100,15)
         cVOLUME    := LEFT(DETAIL_H->AVG_C01120,15)

         DETAIL_H->(DbSeek("  "+cSY0Seq))
         Do While DETAIL_H->(!Eof()) .And. DETAIL_H->AVG_SEQREL = cSY0Seq         
            If DETAIL_H->AVG_CHAVE = "_MARK"
               cMemoMarca+= DETAIL_H->AVG_C03_60+ENTER
            ElseIf DETAIL_H->AVG_CHAVE = "_ESPE"
                   cWkTexto  += RTRIM(DETAIL_H->AVG_C03_60)+ENTER
            ELSEIF DETAIL_H->AVG_CHAVE = "_EXPO"
                   cEXPMEMO := cEXPMEMO+ALLTRIM(DETAIL_H->AVG_C01_60)+ENTER
            ELSEIF DETAIL_H->AVG_CHAVE = "_IMPO"
                   cIMPMEMO := cIMPMEMO+ALLTRIM(DETAIL_H->AVG_C01_60)+ENTER
            EndIf
            DETAIL_H->(DbSkip())
         EndDo
      Else

         cQuantity  := cNetWeight := cGrWeight := cVolume := Space(15)

         EE9->(DbSetOrder(2))
         EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB))

         EE2->(DbSetOrder(1))

         If EE2->(DbSeek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
            cQuantity := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
         EndIf

         If EE2->(DbSeek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNPES))
            cNetWeight := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
            cGrWeight  := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
         EndIf

         cVolume := "M3"

         // ** Carrega a marcação para edição no campo memo da tela de parametros.
         cMemoMarca:= MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))      
      EndIf
   Else
      // ** Set das variáveis...
      cTitulo    := WORKID->EEA_TITULO
      dData      := dDataBase
      cRespon    := PADR(EEC->EEC_RESPON,35," ")

      cQuantity  := cNetWeight := cGrWeight := cVolume := Space(15)

      EE9->(DbSetOrder(2))
      EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB))

      EE2->(DbSetOrder(1))
      If EE2->(DbSeek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
         cQuantity := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
      EndIf

      If EE2->(DbSeek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNPES))
         cNetWeight := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
         cGrWeight  := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
      EndIf

      cVolume := "M3"

      // ** Carrega a marcação para edição no campo memo da tela de parametros.
      cMemoMarca:= MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
   EndIf
   
   IF !MEMOIMEX(0,) .OR. !TelaGets(cWKTEXTO)
      lRet := .f.
      Break
   Endif

   SA2->(dbSetOrder(1))
   If !Empty(EEC->EEC_EXPORT)
      SA2->(DbSeek(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
   Else
      SA2->(DbSeek(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
   EndIf

   //** Adciona registro no header.
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()

   HEADER_P->(DBAPPEND())
   HEADER_P->AVG_FILIAL:=xFilial("SY0")
   HEADER_P->AVG_SEQREL:=cSEQREL
   HEADER_P->AVG_CHAVE :=EEC->EEC_PREEMB

   // ** Chave p/ link de sub-relatórios...      
   HEADER_P->AVG_C01100:="_MARK" // ** Marcação
   HEADER_P->AVG_C02100:="_ESPE" // ** Specifications
   
   // ** Grava o título do relatório...
   HEADER_P->AVG_C01_60:= AllTrim(cTitulo)

   //** Grava os dados do exportador/fornecedor...   
   HEADER_P->AVG_C02_60 := MEMOLINE(cEXPMEMO,60,1)
   // SUB-RELATORIO EXPORTADOR
   FOR Z := 1 TO MLCOUNT(cEXPMEMO,60)
      APPENDDET("_EXPO")
      DETAIL_P->AVG_CONT   := "_EXPO"
      DETAIL_P->AVG_C01_60 := MEMOLINE(cEXPMEMO,60,Z)
   NEXT

   SX5->(DbSetOrder(1))
   SX5->(DbSeek(xFilial("SX5")+"12"+SA2->A2_EST))

   // ** Referencia do importador.
   HEADER_P->AVG_C06_60:= AllTrim(EEC->EEC_REFIMP)

   // ** Processo de referencia.
   HEADER_P->AVG_C01_20:= AllTrim(EEC->EEC_PEDREF)
   HEADER_P->AVG_C02_20:= AllTrim(EEC->EEC_NRINVO)

   // ** Vessel's Name.
   HEADER_P->AVG_C07_60:= AllTrim(Posicione("EE6",1,xFilial("EE6")+EEC->EEC_EMBARCAC,"EE6_NOME"))

   SYR->(dbSeek(xFilial()+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))   
   HEADER_P->AVG_C02_30 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // Porto de Destino
   HEADER_P->AVG_C01_30 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))  // Porto de Origem

   // ** Buyer.
   // SUB-RELATORIO IMPORTADOR
   FOR Z := 1 TO MLCOUNT(cIMPMEMO,60)
      APPENDDET("_IMPO")
      DETAIL_P->AVG_CONT   := "_IMPO"
      DETAIL_P->AVG_C01_60 := MEMOLINE(cIMPMEMO,60,Z)
   NEXT

   EE9->(DbSetOrder(2))
   EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB))

   SA2->(DbSetOrder(1))
   If !Empty(EE9->EE9_FABR)   
      SA2->(DbSeek(xFilial("SA2")+EE9->EE9_FABR+EE9->EE9_FALOJA))
   Else
      SA2->(DbSeek(xFilial("SA2")+EE9->EE9_FORN+EE9->EE9_FOLOJA))   
   EndIf
   
   // ** Origem dos produtos.
   HEADER_P->AVG_C12_60:= AllTrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM"))
   
   // ** Grava a data do relatorio.
   HEADER_P->AVG_C11_60:=AllTrim(SX5->X5_DESCRI)+", "+AllTrim(IF(lEspanhol,IF(EMPTY(dData),"",aMeses[Month(dData)]),cMonth(dData)))+" "+;
                         Space(1)+AllTrim(Str(Day(dData),2))+", "+Space(1)+AllTrim(Str(Year(dData)))
                         
   HEADER_P->AVG_D01_08:=dData

   HEADER_P->AVG_C13_60:=AllTrim(cRespon)
   
   IF lINGLES
      HEADER_P->AVG_C01_10 := If(nOriCpy=2,"Copy",;
                                 IF(nORICPY=1,"Original",""))
   ELSEIF lFRANCES
          HEADER_P->AVG_C01_10 := If(nOriCpy=2,"Copie",;
                                     IF(nORICPY=1,"Originel",""))
   ELSEIF lESPANHOL
          HEADER_P->AVG_C01_10 := If(nOriCpy=2,"Copia",;
                                     IF(nORICPY=1,"Original",""))
   ENDIF

   // ** Grava o detalhe
   APPENDDET()
   DETAIL_P->AVG_C05_20 := cQuantity
   DETAIL_P->AVG_C03100 := cNETWEIGHT
   DETAIL_P->AVG_C02100 := cGRWEIGHT
   DETAIL_P->AVG_C01120 := cVOLUME

   EE9->(DBSETORDER(2))
   EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
   DO WHILE ! EE9->(EOF()) .AND.;
      EE9->(EE9_FILIAL+EE9_PREEMB) = (XFILIAL("EEC")+EEC->EEC_PREEMB)

      nItensEE9++
      IF nITENSEE9 > 1
         APPENDDET()
      ENDIF
      cMemo := AA100Idioma(EE9->EE9_COD_I) //AllTrim(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",AV_TAMANHO)))   //GFP - 29/05/2012 - Tratamento de idiomas.  
      FOR nX := 1 TO MLCOUNT(cMEMO,TAMDESC)
          IF nX > 1
             APPENDDET()
          ENDIF
          DETAIL_P->AVG_C01_60 := MEMOLINE(cMEMO,TAMDESC,nX)
          IF (nX+1) > MLCOUNT(cMEMO,TAMDESC)

             DETAIL_P->AVG_C04_60 := AllTrim(EE9->EE9_PACKAG)                     // Package.
             DETAIL_P->AVG_C01_20 := AllTrim(Transf(EE9->EE9_SLDINI,cPictQtde))   // Quantidade.
             DETAIL_P->AVG_C02_20 := AllTrim(Transf(EE9->EE9_PSLQTO,cPictPeso))   // Peso liquido.
             DETAIL_P->AVG_C03_20 := AllTrim(Transf(EE9->EE9_PSBRTO,cPictPeso))   // Peso bruto.

             // ** Calculos para a Cubage.
             EE5->(DbSetOrder(1))
             If EE5->(DbSeek(xFilial("EE5")+EE9->EE9_EMBAL1))
                nCubAux := (EE9->EE9_QTDEM1*(EE5->EE5_CCOM*EE5->EE5_LLARG*EE5->EE5_HALT))
                cDimens := EE5->EE5_DIMENS
             Else
                nCubAux := 0 ; cDimens := ""
             EndIf

             DETAIL_P->AVG_C04_20 := AllTrim(Transf(nCubAux,cPictVol)) // Cubage.
             DETAIL_P->AVG_C01100 := AllTrim(cDimens) // Dimensão. 

             APPENDDET()
          ENDIF
      NEXT

      nSldini += EE9->EE9_SLDINI
      nCubage += nCubAux
      EE9->(DbSkip())
   EndDo

   DETAIL_P->AVG_C02_60:=AllTrim(EEC->EEC_PACKAG)

   // ** Totais...
   DETAIL_P->AVG_C08_20:=AllTrim(Transf(EEC->EEC_PESLIQ,cPictPeso)) // Peso liquido.
   DETAIL_P->AVG_C09_20:=AllTrim(Transf(EEC->EEC_PESBRU,cPictPeso)) // Peso bruto.
   DETAIL_P->AVG_C10_20:=AllTrim(Transf(nSldini,cPictQtde))         // Qtde.
   DETAIL_P->AVG_C05_60:=AllTrim(Transf(nCubage,cPictVol))          // Cubage. (Volume)

   // ** Gravação dos campos para os sub-relatórios **
   // ** Sub-relatório (Marcação)"
   nLinhasMemo:=MlCount(cMemoMarca,60)
   If nLinhasMemo > 0
      AppendDet("_MARK")   
      DETAIL_P->AVG_CONT:="_MARK" // ** Link para marcação.   
      DETAIL_P->AVG_C03_60:= MemoLine(cMemoMarca,60,1)   
      If nLinhasMemo > 1
         For nX:=2 To nLinhasMemo
             AppendDet("_MARK")   
             DETAIL_P->AVG_CONT:="_MARK"
             DETAIL_P->AVG_C03_60:= MemoLine(cMemoMarca,60,nX)
         Next     
      EndIf
   EndIf
   // ** Sub-relatório (Specifications)"   
   WKMSG->(DbGoTop())   
   Do While WKMSG->(!Eof())
      If !Empty(WKMSG->WKMARCA)
         cWkTexto:=WKMSG->WKTEXTO
         nLinhasSp:=MlCount(cWkTexto,60)
         If nLinhasSp > 0
            AppendDet("_ESPE")   
            DETAIL_P->AVG_CONT:="_ESPE" // ** Link para Specifications.   
            DETAIL_P->AVG_C03_60:= MemoLine(cWkTexto,60,1)            
            If nLinhasSp>1
               For nX:=2 To nLinhasSp
                   AppendDet("_ESPE")   
                   DETAIL_P->AVG_CONT  := "_ESPE"
                   DETAIL_P->AVG_C03_60:= MemoLine(WKMSG->WKTEXTO,60,nX)
               Next                 
            EndIf
         EndIF
      EndIf
      WKMSG->(DbSkip())
   EndDo 
   HEADER_H->(dbAppend())
   AvReplace("HEADER_P","HEADER_H")

   DETAIL_P->(DbGoTop())
   Do While ! DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo

End Sequence

IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cFileMen))
Endif

IF SELECT("WKMSG") > 0
   OBSERVACOES("END")
ENDIF

RestOrd(aOrd)

Return(lRet)

/*
Funcao      : AppendDet
Parametros  : cTIPO
Retorno     : Nil.
Objetivos   : Adiciona registros no arquivo de detalhes
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/12/2003.
Revisao     : 
Obs.        :
*/
*------------------------------*
Static Function AppendDet(cTIPO)
*------------------------------*
cTIPO := IF(cTIPO=NIL,"",cTIPO)

Begin Sequence
   
   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSEQREL
   /*IF cTIPO = "_MARK"     // Nopado por GFP - 24/09/2012
      DETAIL_P->AVG_CHAVE := "_MARK"
   ELSE*/IF cTIPO = "_ESPE"
          DETAIL_P->AVG_CHAVE := "_ESPE"
   ELSEIF cTIPO = "_EXPO"
          DETAIL_P->AVG_CHAVE := "_EXPO"
   ELSEIF cTIPO = "_IMPO"
          DETAIL_P->AVG_CHAVE := "_IMPO"
   ELSE
      DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
   ENDIF
   
End Sequence

Return NIL

/*
Funcao      : TelaGets
Parametros  : Nenhum
Retorno     : .T./.F.
Objetivos   : Montar tela de parametros.
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/12/2003 - 18:55.
Revisao     : 
Obs.        :
*/
*---------------------------------*
Static Function TelaGets(cWKTEXTO)
*---------------------------------*
Local lRet := .f.
Local nOpc := 0
Local oDlg,oRadio

Local bOk     := {||If(ValCpos(),Eval({||lRet:=.t.,oDlg:End()}),)}
Local bCancel := {||nOpc:=0,oDlg:End()}

Local bSet  := {|x,o| lNcm := x, o:Refresh(), lNcm }
Local bSetP := {|x,o| lPesoBru := x, o:Refresh(), lPesoBru }

Local aCampos := {{"WKMARCA",," "},;
                   {"WKCODIGO",,STR0003},;  //"Código"
                   {"WKDESCR",,STR0004}}  //"Descrição"

Local oFld, oFldDoc, oFldNot, oBtnOk, oBtnCancel,oFldMemo
Local oYes, oNo, oYesP, oNoP, oMark, oMark2, oMark3

Local bHide    := {|nTela| if(nTela==2,oMark2:oBrowse:Hide(),)}                          

Local bHideAll := {|| Eval(bHide,2)}  

Local bShow    := {|nTela,o|  if(nTela==2,dbSelectArea("WkMsg"),),;
                              If(nTela==2,o:=If(nTela==2,oMark2,):oBrowse,),;
                              If(nTela==2,o:Show(),),If(nTela=2,o:SetFocus(),)}

Local xx := "",oFont2

Private aMarcados[2], nMarcado := 0

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 9,0 TO 30,80 OF oMainWnd
   
     oFld := TFolder():New(1,1,{STR0005,STR0006,STR0007},{"IPC","IBC","OBS"},oDlg,,,,.T.,.F.,315,140) //"Parametros"###"Specifications"###"Shipping Marks"

     aEval(oFld:aControls,{|x| x:SetFont(oDlg:oFont) })

     oFldDoc := oFld:aDialogs[1]  // FOLDER PARAMETROS
     @ 06,05 TO 55,309 LABEL STR0008 OF oFldDoc PIXEL   //"Detalhes"
     @ 15,10 SAY STR0009 OF oFldDoc PIXEL //"Titulo"
     @ 15,45 MSGET cTitulo  SIZE 170,07 OF oFldDoc PIXEL

     @ 27,10 SAY STR0010 OF oFldDoc PIXEL //"Data"
     @ 27,45 GET dData  SIZE 50,07  OF oFldDoc PIXEL
     
     @ 39,10 SAY STR0011 OF oFldDoc PIXEL //"Responsavel"
     @ 39,45 MSGET cRespon  SIZE 170,07  F3 "E34"  OF oFldDoc PIXEL
     
     @ 15,230 SAY STR0012 OF oFldDoc PIXEL //"Impressao:"
     @ 15,260 RADIO oRadio VAR nOriCpy ITEMS STR0013,STR0014,STR0015 3D SIZE 30,10 OF oFldDoc //"Original"###"Copia"###"Branco"
        
     @ 58,05 TO 120,309 LABEL STR0016 OF oFldDoc PIXEL   //"Unidades de Medida"

     @ 67,10 SAY STR0017 OF oFldDoc PIXEL //"Quantity"
     @ 67,45 GET cQuantity  SIZE 50,07  OF oFldDoc PIXEL

     @ 79,10 SAY STR0018 OF oFldDoc PIXEL //"Net Weight"
     @ 79,45 GET cNetWeight  SIZE 50,07  OF oFldDoc PIXEL          
     
     @ 91,10 SAY STR0019 OF oFldDoc PIXEL //"Gross Weight"
     @ 91,45 GET cGrWeight  SIZE 50,07  OF oFldDoc PIXEL          
                                                                                
     @ 103,10 SAY STR0020 OF oFldDoc PIXEL //"Volumes"
     @ 103,45 GET cVolume  SIZE 50,07  OF oFldDoc PIXEL          

     @ 14,043 GET xx OF oFld:aDialogs[2] // FOLDER SPECIFICATIONS
     oMark2 := Observacoes("New",cMarca,cWKTEXTO)
     AddColMark(oMark2,"WKMARCA")

     // Folder Shipping Marks
     @ 14,043 GET xx OF oFld:aDialogs[3]
     oFldMemo := oFld:aDialogs[3] 
     @ 13,03 GET cMemoMarca MEMO SIZE 305,110 OF oFldMemo PIXEL HSCROLL

     Eval(bHideAll)

     oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),;
                                           IF(nOption <> 1,Eval(bShow,nOption),) }

     DEFINE SBUTTON oBtnOk     FROM 143,258 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
     DEFINE SBUTTON oBtnCancel FROM 143,288 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg

   ACTIVATE MSDIALOG oDlg CENTERED
   
   IF nOpc == 0
      Break
   Endif

   lRet := .t.

   cEXP_CONTATO := M->cCONTATO

End Sequence

Return lRet

/*
Funcao      : Observacoes.
Parametros  : cAcao := New/End.
Retorno     : Nil.
Objetivos   : Manutenção de observações.
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/12/2003 - 18:50.
Obs.        :
*/
*------------------------------------------------*
Static Function Observacoes(cAcao,cMarca,cWKTEXTO)
*------------------------------------------------*
Local xRet := nil
Local nAreaOld, aOrd, aSemSx3
Local cTipMen, cIdioma, cTexto, i

Local oMark
Local lInverte := .F.

Static aOld

Begin Sequence
   cAcao := Upper(AllTrim(cAcao))

   IF cAcao == "NEW"
      Private aHeader := {}, aCAMPOS := array(EE4->(fcount()))
      aSemSX3 := {{"WKMARCA","C",02,0},{"WKTEXTO","M",10,0}}
      aOld    := {Select(), E_CriaTrab("EE4",aSemSX3,"WkMsg")}
      aOrd    := SaveOrd("EE4")

      // CARREGANDO AS SPECIFICATIONS QUE FORAM IMPRESSAS NO ULTIMO DOCUMENTO
      IF ! EMPTY(cWKTEXTO)
         WKMSG->(DBAPPEND())
         WKMSG->WKMARCA    := cMARCA
         WKMSG->EE4_TIPMEN := "REIMPRESSAO"
         WKMSG->WKTEXTO    := cWKTEXTO
      ENDIF

      // BUSCA AS SPECIFICATION PADROES DO SISTEMA
      EE4->(dbSetOrder(2))
      EE4->(dbSeek(xFilial()+EEC->EEC_IDIOMA))
      DO While !EE4->(Eof()) .And. EE4->EE4_FILIAL == xFilial("EE4") .And. EE4->EE4_IDIOMA == EEC->EEC_IDIOMA 

         If Left(EE4->EE4_TIPMEN,1) = "P"
            WkMsg->(dbAppend())
         
            cTexto := MSMM(EE4->EE4_TEXTO,AVSX3("EE4_VM_TEX",AV_TAMANHO))
         
            For i:=1 To MlCount(cTexto,AVSX3("EE4_VM_TEX",AV_TAMANHO))
               WkMsg->WKTEXTO := WkMsg->WKTEXTO+MemoLine(cTexto,AVSX3("EE4_VM_TEX",AV_TAMANHO),i)+ENTER
            Next     
         
            WkMsg->EE4_TIPMEN := EE4->EE4_TIPMEN
            WkMsg->EE4_COD    := EE4->EE4_COD
         EndIf
         
         EE4->(DbSkip())
     EndDo
                     
     dbSelectArea("WkMsg")
     WkMsg->(dbGoTop())

     aCampos := { {"WKMARCA",," "},;
                  ColBrw("EE4_COD","WkMsg"),;
                  ColBrw("EE4_TIPMEN","WkMsg"),;
                  {{|| MemoLine(WkMsg->WKTEXTO,AVSX3("EE4_VM_TEX",AV_TAMANHO),1)},"",AVSX3("EE4_VM_TEX",AV_TITULO)}}
     
     //GFP 25/10/2010
     aCampos := AddCpoUser(aCampos,"EE4","2")
                       
     oMark := MsSelect():New("WkMsg","WKMARCA",,aCampos,lInverte,@cMarca,{18,3,125,312}) 
     oMark:bAval := {|| EditObs(cMarca), oMark:oBrowse:Refresh() }      
     xRet := oMark                                                
     
     RestOrd(aOrd)
     
   Elseif cAcao == "END"
   
      IF Select("WkMsg") > 0
         WkMsg->(E_EraseArq(aOld[2]))
      Endif
      
      Select(aOld[1])
   Endif
End Sequence

Return xRet

/*
Funcao      : EditObs
Parametros  : cMarca
Retorno     : Nil.
Objetivos   : Manutenção para observação.
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/12/2003 - 18:40.
Obs.        :
*/
*-----------------------------*
Static Function EditObs(cMarca)
*-----------------------------*
Local nOpc, cMemo, oDlg, nRec,oFont2
Local bOk     := {|| nOpc:=1, oDlg:End() }
Local bCancel := {|| oDlg:End() }

Begin Sequence

   IF WkMsg->(!Eof())
      IF Empty(WkMsg->WKMARCA)
         nOpc:=0
         cMemo := WkMsg->WKTEXTO

        DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 7,0.5 TO 26,79.5 OF oMainWnd
        
            @ 05,05 SAY STR0021 PIXEL  //"Tipo Mensagem"
            @ 05,45 GET WkMsg->EE4_TIPMEN WHEN .F. PIXEL
   
            @ 20,05 GET cMemo MEMO SIZE 300,105 OF oDlg PIXEL HSCROLL

            DEFINE SBUTTON oBtnOk     FROM 130,246 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
            DEFINE SBUTTON oBtnCancel FROM 130,278 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg

         ACTIVATE MSDIALOG oDlg CENTERED 

         IF nOpc == 1
            IF !Empty(nMarcado)
               nRec := WkMsg->(RecNo())
               WkMsg->(dbGoTo(nMarcado))
               WkMsg->WKMARCA := Space(2)
               WkMsg->(dbGoTo(nRec))
            Endif
            cObs := cObs + CMemo
            WkMsg->WKTEXTO := cMemo
            WkMsg->WKMARCA := cMarca
            nMarcado := nRec
         Endif
      Else
         cObs := ""
         WkMsg->WKMARCA := Space(2)
         nMarcado := 0
      Endif
   Endif

End Sequence
     
Return NIL

/*
Funcao      : ValCpos
Parametros  : Nenhum
Retorno     : .t./.f.
Objetivos   : Validar entrada de parâmetros na tela de edição.
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/12/2003 - 19:00.
Revisao     :               
Obs.        :
*/
*-----------------------*
Static Function ValCpos() 
*-----------------------*
Local lRet:=.t.

Begin Sequence

   If Empty(dData)
      MsgInfo(STR0022,STR0023) //"A data de impressão deve ser informada!"###"Aviso"
      lRet:=.f.
      Break
   EndIf 

   If Empty(cTitulo)
      MsgInfo(STR0024,STR0023) //"O título do relatório deve ser informado!"###"Aviso"
      lRet:=.f.
      Break
   EndIf    

   If Empty(cRespon)
      MsgInfo(STR0025,STR0023) //"O responsável deve ser informado!"###"Aviso"
      lRet:=.f.
      Break
   EndIf          

   If Empty(cQuantity)
      MsgInfo(STR0026,STR0023) //"A unidade de medida para a quantidade deve ser informada!"###"Aviso"
      lRet:=.f.
      Break   
   EndIf          
   
   If Empty(cNetWeight)
      MsgInfo(STR0027,STR0023) //"A unidade de medida para o peso liquido deve ser informada!"###"Aviso"
      lRet:=.f.
      Break      
   EndIf          

   If Empty(cGrWeight)
      MsgInfo(STR0028,STR0023) //"A unidade de medida para o peso bruto deve ser informada!"###"Aviso"
      lRet:=.f.
      Break
   EndIf          

   If Empty(cVolume)
      MsgInfo(STR0029,STR0023) //"A unidade de medida para o volume deve ser informada!"###"Aviso"
      lRet:=.f.
      Break
   EndIf          

End Sequence

Return lRet

/*
Funcao      : MEMOIMEX
Parametros  : nP_LINHA    -> NUMERO DE LINHAS QUE SERA IMPRESSO NO DOCUMENTO.
                             SE 0, É INFINITO
              nP_LINIMP   -> NUMERO DE LINHAS DISPONIVEIS P/ IMPRESSAO. SE NAO FOR PASSADO
                             SERA ASSUMIDO O nP_LINHA
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Jeferson Barros Jr
              13/12/2003 - 14:06.
Obs.        :
*/
*------------------------------------------------------*
Static Function MemoImex(nP_LINHA,cP_PROGRAMA,nP_LINIMP)
*------------------------------------------------------*
LOCAL lRET,bOK,bCANCEL,oDLG,oFLD,aDLG,aBUTTONS,Z,nLI

PRIVATE cCAMPO

Begin Sequence

   nP_LINHA    := IF(nP_LINHA   =NIL,0       ,nP_LINHA)
   cP_PROGRAMA := IF(cP_PROGRAMA=NIL,""      ,cP_PROGRAMA)
   nP_LINIMP   := IF(nP_LINIMP  =NIL,nP_LINHA,nP_LINIMP)
   lRET        := .F.
   nLI         := 3
   aBUTTONS    := {}
   bOK         := {|| lRET := .T.,oDLG:END()}
   bCANCEL     := {|| lRET := .F.,oDLG:END()}

   IF EMPTY(cIMPMEMO) // CARREGA AS LINHAS DO IMPORTADOR
  
      FOR Z := 1 TO 3
          IF Z = 1
             cCAMPO := "EEC->EEC_IMPODE"
          ELSEIF Z = 2
                 cCAMPO := "EEC->EEC_ENDIMP"
          ELSEIF Z = 3
                 cCAMPO := "EEC->EEC_END2IM"
          ENDIF
          IF ! EMPTY(&cCAMPO)
             cIMPMEMO := cIMPMEMO+ALLTRIM(&cCAMPO)+ENTER
          ENDIF
      NEXT
      SA1->(DBSETORDER(1))
      SA1->(DBSEEK(XFILIAL("SA1")+EEC->EEC_IMPORT))
      cIMPMEMO := cIMPMEMO+IF(!EMPTY(SA1->A1_TEL),STR0030,"") +ALLTRIM(SA1->A1_TEL)+; //"Tel.: "
                           IF(!EMPTY(SA1->A1_FAX),STR0031,"")+ALLTRIM(SA1->A1_FAX) //" FAX.: "
   ENDIF
   // CRF 10/11/2010
   IF EMPTY(cEXPMEMO)
     If Empty(EEC->EEC_EXPORT)
        cEXPMEMO := cEXPMEMO+ALLTRIM(CriaVar("EEC_FORNDE"))+ENTER
        SA2->(DBSETORDER(1))
     //   If SA2->(DBSEEK(XFILIAL("SA2")+M->EEC_FORNDE+EEC->EEC_FOLOJA))
           cEXPMEMO += SA2->A2_END + ENTER
           cEXPMEMO += SA2->A2_BAIRRO + " " + SA2->A2_EST + " " +SA2->A2_MUN + " " + SA2->A2_CEP + ENTER
           cEXPMEMO := cEXPMEMO+IF(!EMPTY(SA2->A2_TEL),STR0030,"") +ALLTRIM(SA2->A2_TEL)+; //"Tel.: "
                                IF(!EMPTY(SA2->A2_FAX),STR0031,"")+ALLTRIM(SA2->A2_FAX) //" FAX.: "
      //  EndIf
     Else
        SA2->(DBSETORDER(1))
        If SA2->(DBSEEK(XFILIAL("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
           cEXPMEMO := cEXPMEMO+ALLTRIM(SA2->A2_NOME)+ENTER
           cEXPMEMO += SA2->A2_END + ENTER
           cEXPMEMO += SA2->A2_BAIRRO + " " + SA2->A2_EST + " " +SA2->A2_MUN + " " + SA2->A2_CEP + ENTER
           cEXPMEMO := cEXPMEMO+IF(!EMPTY(SA2->A2_TEL),STR0030,"") +ALLTRIM(SA2->A2_TEL)+; //"Tel.: "
                                IF(!EMPTY(SA2->A2_FAX),STR0031,"")+ALLTRIM(SA2->A2_FAX) //" FAX.: "
        EndIf
     EndIf
   ENDIF    



  /*

   IF EMPTY(cEXPMEMO)
      SA2->(DBSETORDER(1))
      SA2->(DBSEEK(XFILIAL("SA2")+EEC->(IF(!EMPTY(EEC_EXPORT),;
                                                  EEC_EXPORT+EEC_EXLOJA,;
                                                  EEC_FORN+EEC_FOLOJA))))
      cEXPMEMO := cEXPMEMO+If(!Empty(SA2->A2_TEL),STR0030,"")+AllTrim(SA2->A2_TEL) //"Tel.: "
   ENDIF
    */

   DEFINE MSDIALOG oDlg TITLE ALLTRIM(WORKID->EEA_TITULO) FROM 0,0 TO 240,357 OF oMainWnd PIXEL
      oFLD := TFolder():New(13,0,{STR0032,STR0033},{"IMP","EXP"},oDlg,,,,.T.,.F.,180,108) //"&Importador"###"&Exportador"
      IF nP_LINHA > 0
         @ 03,04 SAY STR0034+ALLTRIM(STR(nP_LINHA ,2,0))+STR0035 PIXEL OF oFLD:aDIALOGS[1] //"Máximo de "###" linhas para impressão"
         @ 03,04 SAY STR0034+ALLTRIM(STR(nP_LINIMP,2,0))+STR0035 PIXEL OF oFLD:aDIALOGS[2] //"Máximo de "###" linhas para impressão"
         nLI := 11
      ENDIF

      @ nLI,04 GET cIMPMEMO MEMO SIZE 170,80 OF oFLD:aDIALOGS[1] PIXEL HSCROLL
      @ nLI,04 GET cEXPMEMO MEMO SIZE 170,80 OF oFLD:aDIALOGS[2] PIXEL HSCROLL

   ACTIVATE MSDIALOG oDLG CENTERED ON INIT ENCHOICEBAR(oDLG,bOK,bCANCEL,,aBUTTONS)

End Sequence

Return(lRET)
*----------------------------------------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM55_RDM.PRW                                                                               *
*----------------------------------------------------------------------------------------------------------------*