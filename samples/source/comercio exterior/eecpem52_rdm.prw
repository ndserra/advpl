/*
Programa        : EECPEM52_RDM.
Objetivo        : Impressao da Commercial Invoice (Modelo 4).
Autor           : Jeferson Barros Jr.
Data/Hora       : 13/12/2003 16:14
Obs.            : Inicialmente desenvolvido p/ S.Magalhães. (ECSME01.prw)
*/

#INCLUDE "eecpem52.ch"
#include "EECRDM.CH"
#DEFINE TAMDESC 41
#DEFINE TAMSPEC 46

Static aMESES := {"ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"}

/*
Funcao      : EECPEM52.
Parametros  : Nenhum.
Retorno     : .t.
Objetivos   : Impressao da Commercial Invoice (Modelo 2).
Autor       : Jeferson Barros Jr.
Data/Hora   : 13/12/2003 16:15.
Revisao     : Wilsimar Fabrício da Silva - 20/07/2010
              Este modelo não possui conversão de unidade de medidas. Sendo assim,
              foi retirada da tela de pré-impressão as opções de edição das unidades
              de medida dos pesos, quantidade e preço, sendo considerada as do processo.
Obs.        :
*/
*---------------------*
User Function EECPEM52
*---------------------*
Local lRet:= .t., aOrd := SaveOrd({"EEC","EE9","SA2","SX5","SYR"}),cMemo:="",cWkTexto:="",cSY0Seq:="",;
      nTotLin:=0,cObsParam:="",nItensEE9:=0, nLinMmBank := 0, nCubAux:=0, i:=0, nx:=0

Private cCondPad:=Space(60),cTotAmount:=Space(10),cUnPrice:=Space(20),cBank:="",cOrigem:=Space(60)

Private cTitulo:="",dData:=AvCTod("  /  /  "),cRespon:="",nOriCpy:=3,;
        cQuantity   := Space(15),cNetWeight := Space(15),cGrWeight := Space(15),;
        cVolume     := Space(15),cUnWeiNet:=Space(10),cUnWeiGros:=Space(10),;
        nSldini     := 0,nCubage:=0,cMemoMarca:="",nLinhasSp:=0,;
        nLinhasMemo := 0

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
Private cMarca := GetMark(), lInverte := .f.
PRIVATE cFILEWK,cIMPMEMO,cEXPMEMO,;
        aNEW      := {},;
        aVEL      := {},;
        lINGLES   := UPPER(GetMv("MV_AVG0037",,"INGLES")) $ UPPER(WORKID->EEA_IDIOMA),;
        lFRANCES  := "FRANCE" $ UPPER(WORKID->EEA_IDIOMA),;
        lESPANHOL := "ESP."   $ UPPER(WORKID->EEA_IDIOMA),;
        aDESP     := {"I-Incoterm","B-FOB","F-Frete","S-Seguro","D-Desconto","O-Outro"},;
        aIDIO     := {{"F","Freight"  ,"Flete"},;
                      {"S","Insurance","Seguro"},;
                      {"D","Discount" ,"Descuento"},;
                      {"O","Others"   ,"Otros"}}

//Usado no EECF3EE3 via SXB "E34" para Get de Assinante
M->cSEEKEXF  := ""
M->cSEEKLOJA := ""

Begin Sequence   
   
   cIMPMEMO := "" 
   cEXPMEMO := ""

   Pem52WkTot() // ** Gera o tmp das despesas e observações.

   // ** Para set das variáveis verifica os dados da última impressão.
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
         cRespon   := HEADER_H->AVG_C13_60
         cCondPad  := HEADER_H->AVG_C14_60
         cOrigem   := HEADER_H->AVG_C12_60
      Else
         cTitulo   := WORKID->EEA_TITULO
         dData     := dDataBase 
         cRespon   := PADR(EEC->EEC_RESPON,60," ")
      EndIf

      DETAIL_H->(DbSetOrder(1))
      If DETAIL_H->( dbSeek( xFilial("SY0") + cSY0Seq ) )
         // ** Busca a despesa do cabecario do historico
         Do While DETAIL_H->(!Eof()) .And. DETAIL_H->AVG_SEQREL = cSY0Seq
            If DETAIL_H->AVG_CHAVE = "_ESPE"
               If !( AllTrim(DETAIL_H->AVG_C03_60) $ cWkTexto)
                  cWkTexto  += ALLTRIM(DETAIL_H->AVG_C03_60)+ENTER
               EndIf
            ElseIf DETAIL_H->AVG_CONT = "_OBS"
                   cObsParam += ALLTRIM(DETAIL_H->AVG_C01_60)+ENTER
            ELSEIF DETAIL_H->AVG_CHAVE = "_DESP"
                   DETAIL_H->(AADD(aVEL,{ALLTRIM(AVG_C05_10),AVG_C03_60,AVG_C01_10}))
            ELSEIF DETAIL_H->AVG_CHAVE = "_EXPO"
                   If !( AllTrim(DETAIL_H->AVG_C01_60) $ cEXPMEMO)
                      cEXPMEMO := cEXPMEMO+ALLTRIM(DETAIL_H->AVG_C01_60)+ENTER
                   EndIf
            ELSEIF DETAIL_H->AVG_CHAVE = "_IMPO"
                   If  !( AllTrim(DETAIL_H->AVG_C01_60) $ cIMPMEMO) 
                      cIMPMEMO := cIMPMEMO+ALLTRIM(DETAIL_H->AVG_C01_60)+ENTER
                   EndIf
            ElseIf DETAIL_H->AVG_CHAVE = "_BANK"
                   If !( AllTrim(DETAIL_H->AVG_C01_60) $ cBank)
                      cBank := cBank + AllTrim(DETAIL_H->AVG_C01_60)+ENTER
                   EndIf
            /* nopado por WFS em 21/07/10
            ElseIf !Empty( DETAIL_H->AVG_C08_20 )
                   cQuantity  := LEFT(DETAIL_H->AVG_C08_20,15)
                   cNetWeight := LEFT(DETAIL_H->AVG_C09_20,15)
                   cGrWeight  := LEFT(DETAIL_H->AVG_C10_20,15)
                   cVolume    := LEFT(DETAIL_H->AVG_C02_60,15)
                   cUnPrice   := DETAIL_H->AVG_C07_20
                   cTotAmount := LEFT(DETAIL_H->AVG_C01120,10)*/
            ElseIf !Empty(DETAIL_H->AVG_C02_60) .Or. !Empty(DETAIL_H->AVG_C01120)
                   cVolume    := LEFT(DETAIL_H->AVG_C02_60,15)
                   cTotAmount := LEFT(DETAIL_H->AVG_C01120,10)
            EndIf
            DETAIL_H->(DbSkip())
         EndDo
      Else
         cUnPrice := cGrWeight := cNetWeight := cQuantity := Space(15)

         EE9->(DbSetOrder(2))
         EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB))

         EE2->(DbSetOrder(1))
         /* nopado por WFS em 21/07/10
         If EE2->(DbSeek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
            cQuantity := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
         EndIf

         If EE2->(DbSeek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNPES))
            cNetWeight := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
            cGrWeight  := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
         EndIf */

         cVolume := "M3"
         /* nopado por WFS em 21/07/10
         If EE2->(DbSeek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNPRC))
            cUnPrice := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
         EndIf*/

         cTotAmount := EEC->EEC_MOEDA
         cCondPad   := IncSpace(SY6Descricao(EEC->EEC_CONDPA+STR(EEC->EEC_DIASPA,AVSX3("Y6_DIAS_PA",3)),EEC->EEC_IDIOMA),60,.f.)

         SA2->(DbSetOrder(1))
         If !Empty(EE9->EE9_FABR)
            SA2->(DbSeek(xFilial("SA2")+EE9->EE9_FABR+EE9->EE9_FALOJA))
         Else
            SA2->(DbSeek(xFilial("SA2")+EE9->EE9_FORN+EE9->EE9_FOLOJA))
         EndIf
    
         cOrigem :=Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM")

         // ** Carrega a marcação para edição no campo memo da tela de parametros.
         cMemoMarca:= MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
      EndIf
   ELSE
      // ** Set das variáveis...
      cTitulo   := WORKID->EEA_TITULO
      dData     := dDataBase 
      cRespon   := PADR(EEC->EEC_RESPON,60," ")

      EE9->(DbSetOrder(2))
      EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB))
      EE2->(DbSetOrder(1))
      EE2->(DbSeek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))

      cUnPrice := cGrWeight := cNetWeight := cQuantity := Space(15)

      EE9->(DbSetOrder(2))
      EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB))
      /* nopado por WFS em 21/07/10
      EE2->(DbSetOrder(1))
      If EE2->(DbSeek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
         cQuantity := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
      EndIf

      If EE2->(DbSeek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNPES))
         cNetWeight := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
         cGrWeight  := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
      EndIf */

      cVolume := "M3"
      /* nopado por WFS em 21/07/10
      If EE2->(DbSeek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNPRC))
         cUnPrice := Memoline(AllTrim(EE2->EE2_DESCMA),15,1)
      EndIf */

      cTotAmount := EEC->EEC_MOEDA
      cCondPad   := IncSpace(SY6Descricao(EEC->EEC_CONDPA+STR(EEC->EEC_DIASPA,AVSX3("Y6_DIAS_PA",3)),EEC->EEC_IDIOMA),60,.f.)

      // Banco da carta de crédito...
      EEL->(dbSetOrder(1))
      If EEL->(DbSeek(xFilial("EEL")+EEC->EEC_LC_NUM))
         If SA6->(dbSeek(xFilial()+EEL->EEL_BCOEM+EEL->EEL_AGCEM))
            cBank := AllTrim(SA6->A6_NOME)
         EndIf
      EndIf

      cBank := cBank + AllTrim(If(!Empty(cBank),ENTER+PADR(BUSCAINST(EEC->EEC_PREEMB,OC_EM,BC_DIM),60," "),;
                                        PADR(BUSCAINST(EEC->EEC_PREEMB,OC_EM,BC_DIM),60," ")))
      SA6->(DbSetOrder(1))
      If SA6->(DbSeek(xFilial("SA6")+EEJ->EEJ_CODIGO))
         cBank += ENTER
         cBank += AllTrim(SA6->A6_END)+ENTER
         cBank += AllTrim(SA6->A6_BAIRRO)+" - "+AllTrim(SA6->A6_MUN)+ENTER
         cBank += AllTrim(Transf(SA6->A6_CEP,AVSX3("A6_CEP",AV_PICTURE)))+" - "+AllTrim(SA6->A6_EST)+" - "+;
                  AllTrim(Posicione("SYA",1,xFilial("SYA")+SA6->A6_COD_P,"YA_DESCR"))
      EndIf

      EE9->(DbSetOrder(2))
      EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB))

      SA2->(DbSetOrder(1))
      If !Empty(EE9->EE9_FABR)   
         SA2->(DbSeek(xFilial("SA2")+EE9->EE9_FABR+EE9->EE9_FALOJA))
      Else
         SA2->(DbSeek(xFilial("SA2")+EE9->EE9_FORN+EE9->EE9_FOLOJA))   
      EndIf

      cOrigem :=Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM")

      // ** Carrega a marcação para edição no campo memo da tela de parametros.
      cMemoMarca:= MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
   EndIf   

   If Empty(cTotAmount)
      cTotAmount := EEC->EEC_MOEDA
   EndIf
   
   If Empty(cMemoMarca)
      cMemoMarca:= MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
   EndIf
   
   If Empty(cOrigem)
      EE9->(DbSetOrder(2))
      EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB))

      SA2->(DbSetOrder(1))
      If !Empty(EE9->EE9_FABR)   
         SA2->(DbSeek(xFilial("SA2")+EE9->EE9_FABR+EE9->EE9_FALOJA))
      Else
         SA2->(DbSeek(xFilial("SA2")+EE9->EE9_FORN+EE9->EE9_FOLOJA))   
      EndIf

      cOrigem :=Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM")
   EndIf
   
   //Campos utilizados para o consulta padra("E34") passado como parametros na função EECF3EE3 - BAK - 29/07/2011
   If !Empty(EEC->EEC_FORN)
      M->cSEEKEXF  := EEC->EEC_FORN
      M->cSEEKLOJA := ""
   EndIf
   
   If !MemoImex(0) .OR.;  // ** Get dos memos de importador e exportador.
      !TelaGets(cWKTEXTO,cOBSPARAM)   // ** Edição dos dados para impressão da invoice.
      lRet := .f.
      Break
   EndIf
   
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
   HEADER_P->AVG_C01100 := "_MARK" // ** Marcação.
   HEADER_P->AVG_C02100 := "_ESPE" // ** Specifications.
   HEADER_P->AVG_C03100 := "_DESP" // ** Despesas.
   HEADER_P->AVG_C04100 := "_EXPO" // ** Exportador.

   // ** Grava o título do relatório...
   HEADER_P->AVG_C01_60:= AllTrim(cTitulo)

   //** Grava os dados do exportador/fornecedor...
   HEADER_P->AVG_C02_60 := MEMOLINE(cEXPMEMO,60,1)

   SX5->(DbSetOrder(1))
   SX5->(DbSeek(xFilial("SX5")+"12"+SA2->A2_EST))

   // ** Referencia do importador.
   HEADER_P->AVG_C06_60:= AllTrim(EEC->EEC_REFIMP)

   // ** Processo de referencia.
   HEADER_P->AVG_C01_20:= AllTrim(EEC->EEC_PEDREF)                                                    
 //HEADER_P->AVG_C02_20:= AllTrim(EEC->EEC_PEDREF) // DFS - 30/05/11 - Retirada do número do Pedido de Referência
   HEADER_P->AVG_C02_20:= AllTrim(EEC->EEC_PREEMB) // DFS - 30/05/11 - Inclusão do número do Embarque.

   // ** Vessel's Name.
   HEADER_P->AVG_C07_60:= AllTrim(Posicione("EE6",1,xFilial("EE6")+EEC->EEC_EMBARCAC,"EE6_NOME"))
 
   SYR->(dbSeek(xFilial()+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))   
   HEADER_P->AVG_C02_30 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // Porto de Destino
   HEADER_P->AVG_C01_30 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))  // Porto de Origem

   // ** Condicao de pagamento...
   HEADER_P->AVG_C14_60:= AllTrim(cCondPad)

   // ** Carta de crédito...
   HEADER_P->AVG_C04_20:= AllTrim(EEC->EEC_LC_NUM)

   nLinMmBank := MlCount(AllTrim(cBank),45)

   For i:=1 To nLinMmBank
      AppendDet("_BANK")
      DETAIL_P->AVG_C01_60 := MemoLine(cBank,45,i)
   Next

   EE9->(DbSetOrder(2))
   EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB))

   SA2->(DbSetOrder(1))
   If !Empty(EE9->EE9_FABR)
      SA2->(DbSeek(xFilial("SA2")+EE9->EE9_FABR+EE9->EE9_FALOJA))
   Else
      SA2->(DbSeek(xFilial("SA2")+EE9->EE9_FORN+EE9->EE9_FOLOJA))
   EndIf

   // ** Origem dos produtos.
   HEADER_P->AVG_C12_60:= cOrigem

   // ** Grava a data do relatorio.
   HEADER_P->AVG_C11_60:=AllTrim(SX5->X5_DESCRI)+", "+AllTrim(IF(lEspanhol,IF(EMPTY(dData),"",aMeses[Month(dData)]),cMonth(dData)))+" "+;
                         Space(1)+AllTrim(Str(Day(dData),2))+", "+Space(1)+AllTrim(Str(Year(dData)))
 
   HEADER_P->AVG_D01_08:=dData

   // ** Responsavel ...
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
   
   HEADER_P->AVG_C03_10:="C"

   // ** Grava o detalhe
   AppendDet()

   // ** Grava as unidades de medida.
   /* nopado por WFS em 20/07/2010
   DETAIL_P->AVG_C08_20 := cQuantity  // Qtde.
   DETAIL_P->AVG_C09_20 := cNetWeight // Peso liquido
   DETAIL_P->AVG_C10_20 := cGrWeight  // Peso Bruto
   DETAIL_P->AVG_C02_60 := cVolume    // Volume
   DETAIL_P->AVG_C07_20 := cUnPrice   // Preco unitario
   DETAIL_P->AVG_C01120 := cTotAmount // Preco total */

   DETAIL_P->AVG_C02_60 := cVolume    // Volume
   DETAIL_P->AVG_C01120 := cTotAmount // Preco total
   
   Do While ! EE9->(EOF()) .AND.;
      EE9->(EE9_FILIAL+EE9_PREEMB) = (XFILIAL("EEC")+EEC->EEC_PREEMB)

      nItensEE9++
      IF nITENSEE9 > 1
         APPENDDET()
      ENDIF
      cMemo := AA100Idioma(EE9->EE9_COD_I) //AllTrim(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",AV_TAMANHO)))  //GFP - 29/05/2012 - Tratamento de idiomas.
      FOR nX := 1 TO MLCOUNT(cMEMO,TAMDESC)
          IF nX > 1
             APPENDDET()
          ENDIF
          DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,nX)
          IF (nX+1) > MLCOUNT(cMEMO,TAMDESC)

             DETAIL_P->AVG_C04_60 := AllTrim(EE9->EE9_PACKAG)                   // Package.
             DETAIL_P->AVG_C01_20 := AllTrim(Transf(EE9->EE9_SLDINI,cPictQtde)) // Quantidade.
             DETAIL_P->AVG_C02_20 := AllTrim(Transf(EE9->EE9_PSLQTO,cPictPeso)) // Peso liquido.
             DETAIL_P->AVG_C03_20 := AllTrim(Transf(EE9->EE9_PSBRTO,cPictPeso)) // Peso bruto.

             // ** Calculos para a Cubage.
             EE5->(DbSetOrder(1))
             If EE5->(DbSeek(xFilial("EE5")+EE9->EE9_EMBAL1))
                nCubAux := (EE9->EE9_QTDEM1*(EE5->EE5_CCOM*EE5->EE5_LLARG*EE5->EE5_HALT))
             Else
                nCubAux := 0
             EndIf
             DETAIL_P->AVG_C04_20 := AllTrim(Transf(nCubAux,cPictVol)) // Cubage.

             DETAIL_P->AVG_C05_20 := AllTrim(Transf(EE9->EE9_PRECO,cPICTPRECO)) // Preco.

             IF EEC->EEC_PRECOA = "1" // PRECO ABERTO
                DETAIL_P->AVG_C06_20 := AllTrim(Transf(Round(EE9->EE9_PRCINC,2),cPict)) //Preco total.
             ELSE
                DETAIL_P->AVG_C06_20 := AllTrim(Transf(Round(EE9->EE9_PRCTOT,2),cPict)) //Preco total.
             ENDIF

             //WFS 21/07/2010
             DETAIL_P->AVG_C08_20 := EE9->EE9_UNIDAD // Unidade da qtde.
             DETAIL_P->AVG_C09_20 := IIf(!Empty(EE9->EE9_UNPES), EE9->EE9_UNPES, "KG") // Unidade do peso liquido
             DETAIL_P->AVG_C10_20 := IIF(!Empty(EE9->EE9_UNPES), EE9->EE9_UNPES, "KG")  // Unidade do peso bruto
             DETAIL_P->AVG_C07_20 := IIf(!Empty(EE9->EE9_UNPRC), EE9->EE9_UNPRC, EE9->EE9_UNIDAD) // Unidade do preco unitário

             APPENDDET()
          ENDIF
      NEXT

      nSldini += EE9->EE9_SLDINI
      nCubage += nCubAux
      EE9->(DbSkip())                 
   EndDo

   // ** Package...
   HEADER_P->AVG_C17_60:=AllTrim(EEC->EEC_PACKAG)

   // ** Totais...
   HEADER_P->AVG_C08_20 := AllTrim(Transf(EEC->EEC_PESLIQ,cPictPeso)) // Peso liquido.
   HEADER_P->AVG_C09_20 := AllTrim(Transf(EEC->EEC_PESBRU,cPictPeso)) // Peso bruto.
   HEADER_P->AVG_C10_20 := AllTrim(Transf(nSldini,cPictQtde))         // Qtde.   
   HEADER_P->AVG_C11_20 := AllTrim(Transf(nCubage,cPictVol))          // Cubage.
   
   // ** Total.
   WKTOT->(DBSETORDER(1))
   WKTOT->(DBGOTOP())
   HEADER_P->AVG_C12_20 := WKTOT->WKVALOR
   HEADER_P->AVG_C03_20 := WKTOT->WKDESPESA
   HEADER_P->AVG_C05_10 := WKTOT->WKTIPO
   WKTOT->(DBDELETE())
   WKTOT->(DBSKIP())

   // ** Gravação dos campos para os sub-relatórios.
   // ** Sub-Relatorio Exportador.
   FOR nX := 1 TO MLCOUNT(cEXPMEMO,60)
      APPENDDET("_EXPO")
      DETAIL_P->AVG_CONT   := "_EXPO"
      DETAIL_P->AVG_C01_60 := MEMOLINE(cEXPMEMO,60,nX)
   NEXT

   // ** Sub-Relatorio Importador.
   FOR nX := 1 TO MLCOUNT(cIMPMEMO,60)
      APPENDDET("_IMPO")
      DETAIL_P->AVG_CONT   := "_IMPO"
      DETAIL_P->AVG_C01_60 := MEMOLINE(cIMPMEMO,60,nX)
   NEXT

   // ** Sub-Relatório (Despesa).
   DO WHILE ! WKTOT->(EOF())
      If !Empty(WkTot->WKMARCA)      
         APPENDDET("_DESP")   
         DETAIL_P->AVG_CONT   := "_DESP" // ** Link para Despesa.
         DETAIL_P->AVG_C01_20 := WKTOT->WKDESPESA
         DETAIL_P->AVG_C03_60 := WKTOT->WKVALOR
         DETAIL_P->AVG_C05_10 := WKTOT->WKTIPO
         DETAIL_P->AVG_C01_10 := WkTot->WKMARCA
      EndIf
      WKTOT->(DBSKIP())
   ENDDO

   // ** Grava Observação.
   /*IF Select("Work_Men") > 0
      Work_Men->(dbGoTop())

      DO While !Work_Men->(Eof())
         nTotLin := MlCount(Work_Men->WKOBS,TAMDESC) 
         For nX := 1 To nTotLin
             If (nX=1,AppendDet(""),"")
             cObsParam := Work_Men->WKOBS
             If ! Empty(MemoLine(cObsParam,TAMDESC,nX))
                AppendDet("")
                DETAIL_P->AVG_C01_60 := MemoLine(cObsParam,TAMDESC,nX)
                DETAIL_P->AVG_CONT   := "_OBS"
             EndIf
         Next
         Work_Men->(dbSkip())
      Enddo
   EndIf*/
      
   // ** Sub-relatório (Marcação)
   nLinhasMemo:=MlCount(cMemoMarca,60)

   If nLinhasMemo > 0
      AppendDet("_MARK")   
      DETAIL_P->AVG_CONT:="_MARK" // ** Link para marcação.   
      DETAIL_P->AVG_C03_60:= MemoLine(cMemoMarca,60,1)   
         
      If nLinhasMemo > 1
         For nX:=2 To nLinhasMemo
             AppendDet("_MARK")   
             DETAIL_P->AVG_CONT:="_MARK" // ** Link para marcação.   
             DETAIL_P->AVG_C03_60:= MemoLine(cMemoMarca,60,nX)
         Next     
      EndIf
   EndIf
   
   // ** Sub-relatório (Specifications)"   
   WKMSG->(DbGoTop())   
   Do While WKMSG->(!Eof())
      If ! Empty(WKMSG->WKMARCA)
         cWkTexto  := WKMSG->WKTEXTO
         ///cWkTexto  := RTRIM(STRTRAN(WKMSG->WKTEXTO,ENTER," "))
         nLinhasSp := MlCount(cWkTexto,TAMSPEC)
         If nLinhasSp > 0
            AppendDet("_ESPE")   
            DETAIL_P->AVG_CONT   := "_ESPE" // ** Link para Specifications.   
            DETAIL_P->AVG_C03_60 := MemoLine(cWkTexto,TAMSPEC,1)
            If nLinhasSp > 1
               For nX := 2 To nLinhasSp
                   AppendDet("_ESPE")   
                   DETAIL_P->AVG_CONT   := "_ESPE"
                   DETAIL_P->AVG_C03_60 := MemoLine(WKMSG->WKTEXTO,TAMSPEC,nX)
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

   DETAIL_H->( dbCommit() )

End Sequence

IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cFileMen))
Endif

IF SELECT("WKTOT") > 0
   WKTOT->(E_ERASEARQ(cFILEWK))
ENDIF

IF SELECT("WKMSG") > 0
   OBSERVACOES("END")
ENDIF

RestOrd(aOrd)
Return(lRet)

/*
Funcao      : AppendDet.
Parametros  : cTipo - Identifica o sub-relatorio.
Retorno     : Nil.
Objetivos   : Adiciona registros no arquivo de detalhes.
Autor       : Cristiano A. Ferreira.
Data/Hora   : 05/05/2000.
Revisao     : Jeferson Barros Jr.
Obs.        : 15/12/2003 - 11:01.
*/
*------------------------------*
Static Function AppendDet(cTipo)
*------------------------------*
Default cTipo := ""

Begin Sequence
   
   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSEQREL
   
   If !Empty(cTipo)
      If cTipo == "_MARK"
         DETAIL_P->AVG_CHAVE := "_MARK"
      ElseIf cTipo == "_ESPE"
             DETAIL_P->AVG_CHAVE := "_ESPE"      
      ElseIf cTipo == "_DESP"
             DETAIL_P->AVG_CHAVE := "_DESP"            
      ELSEIF cTIPO = "_OBS"
             DETAIL_P->AVG_CHAVE := "_OBS"                  
      ELSEIF cTIPO = "_EXPO"
             DETAIL_P->AVG_CHAVE := "_EXPO"
      ELSEIF cTIPO = "_IMPO"
             DETAIL_P->AVG_CHAVE := "_IMPO"
      ELSEIF cTIPO = "_BANK"
             DETAIL_P->AVG_CHAVE := "_BANK"
      EndIf            
   Else
      DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
   EndIf
   
End Sequence

Return Nil

/*
Funcao      : UnlockDet
Parametros  : Nenhum
Retorno     : Nil.
Objetivos   : Desaloca registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira 
Data/Hora   : 05/05/2000
Revisao     : Jeferson Barros Jr
Obs.        : 15/05/2003 - 11:02.
*/
/*
Static Function UnlockDet()

Begin Sequence
   DETAIL_P->(dbUnlock())
End Sequence

Return NIL
*/
/*
Funcao      : TelaGets
Parametros  : Nenhum
Retorno     : .T./.F.
Objetivos   : Montar tela de parametros.
Autor       : Jeferson Barros Jr.
Data/Hora   : 28/02/2002 - 10:32.
Revisao     : Jeferson Barros Jr.
Data/Hora   : 15/12/2003 - 11:03.
Obs.        :
*/
*------------------------------------------*
Static Function TelaGets(cWKTEXTO,cOBSPARAM)
*------------------------------------------*
Local lRet := .f.
Local nOpc := 0
Local oDlg,oRadio
Local bOk     := {||If(ValCpos(),Eval({||lRet:=.t.,oDlg:End()}),)}
Local bCancel := {||nOpc:=0,oDlg:End()}
/*
Local aCampos := {{"WKMARCA",," "},;
                  {"WKCODIGO",,"Código"},; 
                  {"WKDESCR",,"Descrição"}} 
*/                  
                  
Local oFld, oFldDoc, oBtnOk, oBtnCancel,oFldMemo
Local oYes, oNo, oYesP, oNoP, oMark, oMark2, oMark3, oMARK4

Local bHide    := {|nTela| if(nTela==2,oMark2:oBrowse:Hide(),;
                              if(nTela==4,oMark3:oBrowse:Hide(),;
                                 IF(nTELA==5,oMARK4:oBROWSE:HIDE(),)))}
                                 
Local bHideAll := {|| Eval(bHide,2), Eval(bHide,4), EVAL(bHIDE,5) }

Local bShow    := {|nTela,o| if(nTela==2,dbSelectArea("WkMsg"),;
                                 if(nTela==4,dbSelectArea("Work_Men"),;
                                    IF(nTELA==5,DBSELECTAREA("WKTOT"),))),;
                              If(nTela<>3,o :=  if(nTela==2,oMark2,;
                                                   If(nTela==4,oMark3,;
                                                      IF(nTELA==5,oMARK4,))):oBrowse,),;
                              If(nTela<>3,o:Show(),),If(nTela<>3,o:SetFocus(),)}
Local xx := "",oFont2
Local bBarras := {|| Pem52Bar(oFld:aDialogs[5])}

Private aMarcados[2], nMarcado := 0

Begin Sequence

   Define MsDialog oDlg Title WorkId->EEA_TITULO From 9,0 To 38,80 Of oMainWnd

     oFld := TFolder():New(1,1,{STR0003,STR0004,STR0005,STR0006,STR0007},{"IPC","IBC","OBS","OB2","TOT"},oDlg,,,,.T.,.F.,315,196) //"&Parametros"###"&Specifications"###"Shipping &Marks"###"&Observação"###"&Totais"

     aEval(oFld:aControls,{|x| x:SetFont(oDlg:oFont)})

     // Documentos Para.
     oFldDoc := oFld:aDialogs[1]

     @ 06,05 TO 67,309 LABEL STR0008 OF oFldDoc PIXEL //"Detalhes"

     @ 15,10 SAY STR0009 OF oFldDoc PIXEL //"Titulo"
     @ 15,45 MSGET cTitulo PICTURE "@!" SIZE 170,07 OF oFldDoc PIXEL

     @ 27,10 SAY STR0010 OF oFldDoc PIXEL //"Data"
     @ 27,45 GET dData  SIZE 50,07  OF oFldDoc PIXEL

     @ 39,10 SAY STR0011 OF oFldDoc PIXEL //"Responsavel"
     @ 39,45 MSGET cRespon PICTURE "@!" SIZE 170,07  F3 "E34"  OF oFldDoc PIXEL

     @ 51,10 SAY STR0012 OF oFldDoc PIXEL //"Cond. Pagto."
     @ 51,45 MSGET cCondPad PICTURE "@!" SIZE 170,07 OF oFldDoc PIXEL

     @ 15,230 SAY STR0013 OF oFldDoc PIXEL //"Impressao:"
     @ 15,260 RADIO oRadio VAR nOriCpy ITEMS STR0014,STR0015,STR0016 3D SIZE 30,10 OF oFldDoc //"Original"###"Copia"###"Branco"

     @ 68,05 TO 120,309 LABEL STR0017 OF oFldDoc PIXEL //"Unidades de Medida"

     /* nopado por WFS em 21/07/2010
     @ 79,10 SAY STR0018 OF oFldDoc PIXEL //"Quantity"
     @ 79,45 GET cQuantity PICTURE "@!" SIZE 50,07  OF oFldDoc PIXEL

     @ 91,10 SAY STR0019 OF oFldDoc PIXEL //"Net Weight"
     @ 91,45 GET cNetWeight PICTURE "@!" SIZE 50,07  OF oFldDoc PIXEL          

     @ 103,10 SAY STR0020 OF oFldDoc PIXEL //"Gross Weight"
     @ 103,45 GET cGrWeight  PICTURE "@!" SIZE 50,07  OF oFldDoc PIXEL          

     @ 79,120 SAY STR0021     OF oFldDoc PIXEL //"Unit Price"
     @ 79,170 GET cUnPrice PICTURE "@!" SIZE 50,07  OF oFldDoc PIXEL

     @ 91,120 SAY STR0022   OF oFldDoc PIXEL //"Total Amount"
     @ 91,170 GET cTotAmount  PICTURE "@!" SIZE 50,07 OF oFldDoc PIXEL                

     @ 103,120 SAY STR0023 OF oFldDoc PIXEL //"Volumes"
     @ 103,170 GET cVolume PICTURE "@!" SIZE 50,07  OF oFldDoc PIXEL */

     @ 79,10 SAY STR0022   OF oFldDoc PIXEL //"Total Amount"
     @ 79,45 GET cTotAmount  PICTURE "@!" SIZE 50,07 When Empty(cTotAmount) OF oFldDoc PIXEL

     @ 79,120 SAY STR0023 OF oFldDoc PIXEL //"Volumes"
     @ 79,170 GET cVolume PICTURE "@!" SIZE 50,07 When OF oFldDoc PIXEL


     @ 122,05 TO 180,309 LABEL STR0024 OF oFldDoc PIXEL //"Dados Adicionais"

     @ 133,10 SAY STR0025   OF oFldDoc PIXEL //"Origem of Goods"
     @ 133,55 GET cOrigem SIZE 170,07 OF oFldDoc PIXEL

     @ 145,10 SAY STR0026   OF oFldDoc PIXEL //"Issuing Bank"
     @ 145,55 GET cBank MEMO SIZE 170,30 OF oFldDoc PIXEL HSCROLL

     // Folder Specification
     oMark2 := Observacoes("New",cMarca,cWKTEXTO)
     @ 14,043 GET xx OF oFld:aDialogs[2]

     AddColMark(oMark2,"WKMARCA")
     // Folder Mensagens ...
     @ 14,043 GET xx OF oFld:aDialogs[3]

     oFldMemo := oFld:aDialogs[3]
     @ 13,03 GET cMemoMarca MEMO SIZE 305,145 OF oFldMemo PIXEL HSCROLL

     // Folder Observacoes
     @ 14,043 GET xx OF oFld:aDialogs[4]
     oMark3 := EECMensagem(EEC->EEC_IDIOMA,"3",{18,3,175,312},,,,oDlg)

     IF ! EMPTY(cOBSPARAM)  // CARREGA AS OBERVACOES QUE JA FORAM IMPRESSAS NO DOCUMENTO
        WORK_MEN->(DBAPPEND())
        WORK_MEN->WKORDEM := '00000'
        WORK_MEN->WKOBS   := cOBSPARAM
        WORK_MEN->WKOBS1  := MEMOLINE(cOBSPARAM,50)
     ENDIF

     // TOTAIS
     @ 14,043 GET xx OF oFld:aDialogs[5]
     oMark4 := Pem52Tot(cMARCA)

     Eval(bHideAll)
     oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),;
                                           IF(nOption <> 1,Eval(bShow,nOption),) }

     DEFINE SBUTTON oBtnOk     FROM 200,258 TYPE 1 ACTION Eval(bOk)     ENABLE OF oDlg
     DEFINE SBUTTON oBtnCancel FROM 200,288 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg

   ACTIVATE MSDIALOG oDlg CENTERED ON INIT (Eval(bBarras))

   IF nOpc == 0
      Break
   Endif
   lRet := .t.
   cEXP_CONTATO := M->cCONTATO

End Sequence

Return lRet

/*
Funcao      : Observacoes
Parametros  : cAcao := New/End
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Jeferson Barros Jr
              15/12/2003 - 11:21.
Obs.        :
*/
*------------------------------------------------*
Static Function Observacoes(cAcao,cMarca,cWKTEXTO)
*------------------------------------------------*
Local xRet := nil
Local nAreaOld, aOrd, aSemSx3
Local cTipMen, cIdioma, cTexto
Local oMark
Local lInverte := .F.
LOCAL I,Z,Y

Static aOld

Begin Sequence
   cAcao := Upper(AllTrim(cAcao))

   If cAcao == "NEW"
      Private aHeader := {}, aCAMPOS := array(EE4->(fcount()))
      aSemSX3 := { {"WKMARCA","C",02,0},{"WKTEXTO","M",10,0}}
      aOld    := {Select(), E_CriaTrab("EE4",aSemSX3,"WkMsg")}
      
      // ** Carrega as Specifications que foram impressas na última impressão.
      IF ! EMPTY(cWKTEXTO)
         WKMSG->(DBAPPEND())
         WKMSG->WKMARCA    := cMARCA
         WKMSG->EE4_TIPMEN := "REIMPRESSAO"
         FOR I := 1 TO MLCOUNT(cWKTEXTO,TAMSPEC)
             WKMSG->WKTEXTO := WKMSG->WKTEXTO+MEMOLINE(cWKTEXTO,TAMSPEC,I)+ENTER
         NEXT
      ENDIF

      // ** Busca as Specifications padrao do sistema.
      aOrd := SaveOrd("EE4")
      EE4->(dbSetOrder(2))
      EE4->(dbSeek(xFilial()+EEC->EEC_IDIOMA))
      DO While !EE4->(Eof()) .And. EE4->EE4_FILIAL == xFilial("EE4") .And. EE4->EE4_IDIOMA == EEC->EEC_IDIOMA 
         If Left(EE4->EE4_TIPMEN,1) = "3"
            WkMsg->(dbAppend())
            cTexto := MSMM(EE4->EE4_TEXTO,AVSX3("EE4_VM_TEX",AV_TAMANHO))
            Z := ""
            FOR I := 1 TO MLCOUNT(cTexto,AVSX3("EE4_VM_TEX",AV_TAMANHO))
                Z := RTRIM(MEMOLINE(cTEXTO,AVSX3("EE4_VM_TEX",AV_TAMANHO),I))
                IF ! EMPTY(Z)
                   FOR Y := 1 TO MLCOUNT(Z,TAMSPEC)
                       WKMSG->WKTEXTO := WKMSG->WKTEXTO+RTRIM(MEMOLINE(z,TAMSPEC,Y))+" "
                   NEXT
                ELSE
                   WKMSG->WKTEXTO := WKMSG->WKTEXTO+ENTER+ENTER
                ENDIF
            NEXT
            WkMsg->EE4_TIPMEN := EE4->EE4_TIPMEN
            WkMsg->EE4_COD    := EE4->EE4_COD
         EndIf
         EE4->(DbSkip())
     EndDo
     dbSelectArea("WkMsg")
     WkMsg->(dbGoTop())
     aCampos     := {{"WKMARCA",," "},;
                     ColBrw("EE4_COD","WkMsg"),;
                     ColBrw("EE4_TIPMEN","WkMsg"),;
                     {{|| MemoLine(WkMsg->WKTEXTO,AVSX3("EE4_VM_TEX",AV_TAMANHO),1)},"",AVSX3("EE4_VM_TEX",AV_TITULO)}}
     
     //GFP 25/10/2010
     aCampos := AddCpoUser(aCampos,"EE4","2")
     
     oMark       := MsSelect():New("WkMsg","WKMARCA",,aCampos,lInverte,@cMarca,{18,3,175,312}) 
     oMark:bAval := {|| EditObs(cMarca), oMark:oBrowse:Refresh() }      
     xRet        := oMark                                                
     RestOrd(aOrd)
   Elseif cAcao == "END"
      If Select("WkMsg") > 0
         WkMsg->(E_EraseArq(aOld[2]))
      Endif

      Select(aOld[1])
   Endif

End Sequence

Return(xRet)

/*
Funcao      : EditObs
Parametros  : cMarca.
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Jeferson Barros Jr.
              13/12/2003 - 11:25.
Obs.        :
*/
*-----------------------------*
Static Function EditObs(cMarca)
*-----------------------------*
Local nOpc, cMemo, oDlg

Local bOk     := {|| nOpc:=1, oDlg:End() }
Local bCancel := {|| oDlg:End() }

Local nRec,oFont2

IF WkMsg->(!Eof())
   IF Empty(WkMsg->WKMARCA)
      nOpc:=0
      cMemo := WkMsg->WKTEXTO

      DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 7,0.5 TO 26,79.5 OF oMainWnd
      
         @ 05,05 SAY STR0027 PIXEL  //"Tipo Mensagem"
         @ 05,45 GET WkMsg->EE4_TIPMEN WHEN .F. PIXEL
         @ 20,05 GET cMemo MEMO SIZE 150,105 OF oDlg PIXEL HSCROLL

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
     
Return Nil

/*
Funcao      : ValCpos.
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Validar entrada de parâmetros na tela de edição.
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/12/2003 - 11:27.
Revisao     :
Obs.        :
*/
*-----------------------*
Static Function ValCpos()
*-----------------------*
Local lRet:=.t.

Begin Sequence

   If Empty(cTitulo)
      MsgInfo(STR0028,STR0029) //"O título do relatório deve ser informado!"###"Aviso"
      lRet:=.f.
      Break
   EndIf    

   If Empty(dData)
      MsgInfo(STR0030,STR0029) //"A data de impressão deve ser informada!"###"Aviso"
      lRet:=.f.
      Break
   EndIf 

   If Empty(cRespon)
      MsgInfo(STR0031,STR0029) //"O responsável deve ser informado!"###"Aviso"
      lRet:=.f.
      Break
   EndIf          

   If Empty(cCondPad)
      MsgInfo(STR0032,STR0029) //"A Condição de pagamento deve ser informada!"###"Aviso"
      lRet:=.f.
      Break
   EndIf
   /* nopado por WFS em 21/07/2010
   If Empty(cQuantity)
      MsgInfo(STR0033,STR0029) //"A unidade de medida para a quantidade deve ser informada!"###"Aviso"
      lRet:=.f.
      Break   
   EndIf          
   
   If Empty(cNetWeight)
      MsgInfo(STR0034,STR0029) //"A unidade de medida para o peso liquido deve ser informada!"###"Aviso"
      lRet:=.f.
      Break      
   EndIf          

   If Empty(cGrWeight)
      MsgInfo(STR0035,STR0029) //"A unidade de medida para o peso bruto deve ser informada!"###"Aviso"
      lRet:=.f.
      Break
   EndIf */

   If Empty(cVolume)
      MsgInfo(STR0036,STR0029) //"A unidade de medida para o volume deve ser informada!"###"Aviso"
      lRet:=.f.
      Break
   EndIf            

   /* Nopado por WFS em 21/07/10
   If Empty(cUnPrice)
      MsgInfo(STR0037,STR0029) //"O unidade de medida para o preço unitário deve ser informada!"###"Aviso" 
      lRet:=.f.
      Break
   EndIf */

   If Empty(cTotAmount)
      MsgInfo(STR0038,STR0029) //"A unidade de medida para o total geral deve ser informada!"###"Aviso"
      lRet:=.f.
      Break
   EndIf
  
End Sequence

Return lRet

/*
Funcao      : Pem52Tot(cP_MARCA)
Parametros  : cP_Marca.
Retorno     : .t./.f.
Objetivos   : Carregar as despesas (Totais).
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/13/2003 - 11:29.
Revisao     :
Obs.        :
*/
*--------------------------------*
Static Function Pem52Tot(cP_MARCA)
*--------------------------------*
LOCAL oMARK,nFOB,c1,cFRETE,cSEGURO,cDESCONTO,cDESPESA,I,n1,n2,;
      lINVERTE := .F.

PRIVATE aCAMPOS := {},;
        aHEADER := {}

Begin Sequence

   // ** Busca os valores atuais do processo.
   FOR I := 1 TO LEN(aDESP)
       VERIFICA(LEFT(aDESP[I],1))
   NEXT
   
   // ** Compara com o Histórico e atualiza as despesas.
   FOR I := 1 TO LEN(aVEL)
       n1 := 0
       FOR n2 := 1 TO LEN(aNEW)
           IF aNEW[n2,1] = aVEL[I,1]
              n1 := n2
              EXIT
           ENDIF
       NEXT
       IF n1 # 0
          c1 := ASCAN(aIDIO,{|X| X[1] = aVEL[I,1]})
          IF c1 = 0
             c1 := IF(aVEL[I,1]="I",EEC->EEC_INCOTE,"FOB")
          ELSE
             c1 := aIDIO[c1,IF(lINGLES,2,3)]
          ENDIF
          WKTOT->(DBAPPEND())
          WKTOT->WKDESPESA := UPPER(c1)
          WKTOT->WKVALOR   := aNEW[n1,2] // VALOR
          WKTOT->WKTIPO    := aVEL[I,1]  // TIPO DE DESPESA
          WKTOT->WKINDICE  := STRZERO(WKTOT->(RECNO()),2,0)

          If !Empty(aVel[i][3])
             WKTOT->WKMARCA := cMarca
          EndIf

          aNEW[n1,3]       := .F.
       ENDIF
   NEXT

   // ** Inclui as novas despesas.
   FOR I := 1 TO LEN(aNEW)
       IF aNEW[I,3]
          c1 := ASCAN(aIDIO,{|X| X[1] = aNEW[I,1]})
          IF c1 = 0
             c1 := IF(aNEW[I,1]="I",EEC->EEC_INCOTE,"FOB")
          ELSE
             c1 := aIDIO[c1,IF(lINGLES,2,3)]
          ENDIF
          IF c1 # "FOB" .OR. (EEC->EEC_INCOTE # "EXW" .and. EEC->EEC_INCOTE # "DAF")
             WKTOT->(DBAPPEND())
             WKTOT->WKDESPESA := UPPER(c1)
             WKTOT->WKVALOR   := aNEW[I,2] // VALOR
             WKTOT->WKTIPO    := aNEW[I,1] // TIPO DE DESPESA
             WKTOT->WKINDICE  := STRZERO(WKTOT->(RECNO()),2,0)
             WKTOT->WKMARCA   := cMarca
          ENDIF
       ENDIF
   NEXT
   WKTOT->(DBSETORDER(1))
   WKTOT->(DBGOTOP())
   aCAMPOS := {{"WKMARCA"  ,"","  "},;
               {"WKDESPESA","","DESPESA"},;
               {"WKVALOR"  ,"","VALOR"}}

   oMARK := MSSELECT():NEW("WKTOT","WKMARCA",,aCAMPOS,lINVERTE,@cP_MARCA,{23,2,175,316})

End Sequence

RETURN(oMARK)

/*
Funcao      : Pem52Bar(oDlg)
Parametros  : oDlg.
Retorno     : Nil.
Objetivos   : Barra de ferramentas.
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/13/2003 - 11:33.
Revisao     :
Obs.        :
*/
*----------------------------*
Static Function Pem52Bar(oDlg)
*----------------------------*
Local oBar,oUP,oDW

Begin Sequence

   oBAR   := TBar():New(oDLG,,20,,"TOP",)
   oUP  := TBtnBmp():NewBar("VCUP"  ,,,,,{||SME01BARSD("S")},,oBar,,,"Sobe" ,,,,,,,,,)
   oDW  := TBtnBmp():NewBar("VCDOWN",,,,,{||SME01BARSD("D")},,oBar,,,"Desce",,,,,,,,,)

End Sequence

Return Nil

/*
Funcao      : Pem52BarSd(cP_MODO)
Parametros  : cP_MODO
Retorno     : .t./.f.
Objetivos   : Barra de ferramentas.
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/13/2003 - 11:33.
Revisao     :
Obs.        :
*/
/*
*---------------------------------*
Static Function Pem52BarSd(cP_MODO)
*---------------------------------*
LOCAL nREC

Begin Sequence

   IF cP_MODO = "S"
      nREC := WKTOT->(RECNO())
      WKTOT->(DBSKIP(-1))
      IF ! WKTOT->(BOF()) .AND. ! WKTOT->(EOF())
         WKTOT->WKINDICE := STRZERO(VAL(WKTOT->WKINDICE)+1,2,0)
         WKTOT->(DBGOTO(nREC))
         WKTOT->WKINDICE := STRZERO(VAL(WKTOT->WKINDICE)-1,2,0)
      ELSE
         WKTOT->(DBGOTO(nREC))
      ENDIF
   ELSEIF cP_MODO = "D"
          nREC := WKTOT->(RECNO())
          WKTOT->(DBSKIP())
          IF ! WKTOT->(BOF()) .AND. ! WKTOT->(EOF())
             WKTOT->WKINDICE := STRZERO(VAL(WKTOT->WKINDICE)-1,2,0)
             WKTOT->(DBGOTO(nREC))
             WKTOT->WKINDICE := STRZERO(VAL(WKTOT->WKINDICE)+1,2,0)
          ELSE
             WKTOT->(DBGOTO(nREC))
          ENDIF
   ENDIF

End Sequence

RETURN Nil
*/
/*
Funcao      : Pem52WkTot.
Parametros  : Nenhum.
Retorno     : Nil.
Objetivos   : Gerar arquivo temporário de despesas.
Autor       : Jeferson Barros Jr.
Data/Hora   : 13/12/2003 16:15.
Revisao     :
Obs.        :
*/

*--------------------------*
Static Function Pem52WkTot()
*--------------------------*
Local aEstru := {{"WKDESPESA","C",15,0},;
                 {"WKVALOR"  ,"C",15,0},;
                 {"WKINDICE" ,"C",02,0},;
                 {"WKTIPO"   ,"C",01,0},;
                 {"WKMARCA"  ,"C",02,0}}
Local c1

Private aCampos := {}, aHeader := {}

Begin Sequence

   // ARQUIVO TMP DE DESPESAS
   cFILEWK := E_CRIATRAB(,aESTRU,"WKTOT")
   IndRegua("WKTOT",cFILEWK+ORDBAGEXT(),"WKINDICE","AllwaysTrue()","AllwaysTrue()","Processando")
   c1 := CriaTrab(Nil,.f.)

   IndRegua("WKTOT",c1+ORDBAGEXT(),"WKDESPESA","AllwaysTrue()","AllwaysTrue()","Processando")
   SET INDEX TO (cFILEWK+OrdBagExt()),(c1+OrdBagExt())
   
   WkTot->(DbSetOrder(1))

End Sequence

Return Nil

/*
Funcao      : Verifica(cP_DESPESA).
Parametros  : Nenhum.
Retorno     : Nil.
Objetivos   : Verificação de Despesas.
Autor       : Jeferson Barros Jr.
Data/Hora   : 15/12/2003 11:48.
Revisao     :
Obs.        :
*/
*----------------------------------*
Static Function Verifica(cP_DESPESA)
*----------------------------------*
LOCAL nFOB

Begin Sequence

   IF cP_DESPESA = "I"
      AADD(aNEW,{"I",PADL(ALLTRIM(TRANSFORM(EEC->(EEC_TOTPED),cPICT)),15," "),.T.})

   ELSEIF cP_DESPESA = "B"
          IF EEC->EEC_INCOTE # "FOB" .AND. EEC->EEC_INCOTE # "FCA"
             nFOB := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+;
                      AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2")) // ** Valor Fob
             AADD(aNEW,{"B",PADL(ALLTRIM(TRANSFORM(nFOB,cPICT)),15," "),.T.})
          ENDIF

   ELSEIF cP_DESPESA = "F"
         IF EEC->(EEC_FRPREV+EEC_FRPCOM) > 0
            AADD(aNEW,{"F",PADL(ALLTRIM(TRANSFORM(EEC->(EEC_FRPREV+EEC_FRPCOM),cPICT)),15," "),.T.})
         ENDIF

   ELSEIF cP_DESPESA = "S"
         IF EEC->EEC_SEGPRE > 0
            AADD(aNEW,{"S",PADL(ALLTRIM(TRANSFORM(EEC->EEC_SEGPRE,cPICT)),15," "),.T.})
         ENDIF

   ELSEIF cP_DESPESA = "D"
         IF EEC->EEC_DESCON > 0
            AADD(aNEW,{"D",PADL(ALLTRIM(TRANSFORM(EEC->(EEC_DESCON),cPICT)),15," "),.T.})
         ENDIF

   ELSEIF cP_DESPESA = "O"
         IF EEC->(EEC_DESPIN+AVGETCPO("EEC->EEC_DESP1")+AVGETCPO("EEC->EEC_DESP2")) > 0
            AADD(aNEW,{"O",PADL(ALLTRIM(TRANSFORM(EEC->(EEC_DESPIN+AVGETCPO("EEC->EEC_DESP1")+AVGETCPO("EEC->EEC_DESP2")),cPICT)),15," "),.T.})
         ENDIF
   ENDIF

End Sequence

RETURN Nil

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
Revisao     : Jeferson Barros Jr.
              15/12/2003 - 10:19.
Obs.        :
*/
*------------------------------------------*
Static Function MEMOIMEX(nP_LINHA,nP_LINIMP)
*------------------------------------------*
Local lRET,bOK,bCANCEL,oDLG,oFLD,aDLG,aBUTTONS,Z,nLI
Local cDesPais := ""
Private cCAMPO

Begin Sequence

   nP_LINHA    := IF(nP_LINHA   =NIL,0       ,nP_LINHA)
   nP_LINIMP   := IF(nP_LINIMP  =NIL,nP_LINHA,nP_LINIMP)
   lRET        := .F.
   nLI         := 3
   aBUTTONS    := {}
   bOK         := {|| lRET := .T.,oDLG:END()}
   bCANCEL     := {|| lRET := .F.,oDLG:END()}
   
   IF EMPTY(cIMPMEMO)
      // Carrega as Linhas Do Importador.
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
      SA1->(DBSEEK(XFILIAL("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
      cIMPMEMO := cIMPMEMO+IF(!EMPTY(SA1->A1_TEL),STR0039,"") +ALLTRIM(SA1->A1_TEL)+; //"Tel.: "
                           IF(!EMPTY(SA1->A1_FAX),STR0040,"")+ALLTRIM(SA1->A1_FAX) //" FAX.: "
   ENDIF

   IF EMPTY(cEXPMEMO)
      SA2->(DBSETORDER(1))
      SA2->(DBSEEK(XFILIAL("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
      cDesPais := Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM")
      cEXPMEMO := AllTrim(SA2->A2_NOME) + ENTER
      cEXPMEMO += AllTrim(SA2->A2_END) + ", " + AllTrim(SA2->A2_NR_END) + If(!Empty(SA2->A2_ENDCOMP),SA2->A2_ENDCOMP,"") + ENTER      
      cEXPMEMO += AllTrim(SA2->A2_MUN) + " - " + AllTrim(SA2->A2_EST) + If(!Empty(cDesPais), " - " + cDesPais,"" ) + " - " + If(!Empty(SA2->A2_CEP),SA2->A2_CEP,"") + ENTER      
      cEXPMEMO += IF(!EMPTY(SA2->A2_TEL),STR0039,"") +ALLTRIM(SA2->A2_TEL)+; //"Tel.: "
                  IF(!EMPTY(SA2->A2_FAX),STR0040,"")+ALLTRIM(SA2->A2_FAX) //" FAX.: "
   ENDIF

   DEFINE MSDIALOG oDlg TITLE ALLTRIM(WORKID->EEA_TITULO) FROM 0,0 TO 255,380 OF oMainWnd PIXEL

	      oFLD := TFolder():New(13,5.5,{STR0041,STR0042},{"IMP","EXP"},oDlg,,,,.T.,.F.,180,98) //"&Importador"###"&Exportador"
      IF nP_LINHA > 0
         @ 03,04 SAY STR0043+ALLTRIM(STR(nP_LINHA ,2,0))+STR0044 PIXEL OF oFLD:aDIALOGS[1] //"Máximo de "###" linhas para impressão"
         @ 03,04 SAY STR0043+ALLTRIM(STR(nP_LINIMP,2,0))+STR0044 PIXEL OF oFLD:aDIALOGS[2] //"Máximo de "###" linhas para impressão"
         nLI := 11
      ENDIF

      @ nLI,04 GET cIMPMEMO MEMO SIZE 170,80 OF oFLD:aDIALOGS[1] PIXEL HSCROLL
      @ nLI,04 GET cEXPMEMO MEMO SIZE 170,80 OF oFLD:aDIALOGS[2] PIXEL HSCROLL

   ACTIVATE MSDIALOG oDLG CENTERED ON INIT ENCHOICEBAR(oDLG,bOK,bCANCEL,,aBUTTONS)

End Sequence

Return(lRet)

*----------------------------------------------------------------------------------------------------------------*
* Fim do Programa EECPEM52_RDM                                                                                   *
*----------------------------------------------------------------------------------------------------------------*
