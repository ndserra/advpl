#INCLUDE "EECPEM75.ch"
#include "EECRDM.CH"
/*
Programa. : EECPEM75_RDM.PRW
Objetivo..: Certificado GSTP FIEP
Autor.....: Julio de Paula Paz
Data/Hora.: 14/06/2006
Obs.......: considera que estah posicionado no registro de processos (embarque) (EEC)
Revisão...: Fabrício e Diogo - 22/10/2009.
            Atualização do layout para a versão 5 e padronização para quatro linhas nos campos 1.Produtor/ Exportador,
            2.Importador e 3.Consignatário quando ativado o parâmetro MV_AVG0033.
*/

#DEFINE LENCOL4    20
#define TOT_ITENS  21
#DEFINE TAMOBS     80 //tamanho máximo para gravação na tabela EX0
*--------------------------------------------------------------------
USER FUNCTION EECPEM75
LOCAL mDET,mROD,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"SYR","SYA"}),;
      aLENCOL

Private nLenCol1, nLenCol2, nLenCol3, nLenCol4, nLenCol5
Private cMargem

cMargem := Space(1)
nLenCol0 := 07
nLenCol1 := 18
nLenCol2 := 38
nLenCol3 := 16
nLenCol4 := 13
nLenCol5 := 20

aLENCOL := {{"ORDEM"    ,nLenCol0,"C",STR0007},;  //"Ordem"
            {"PACKAGE"  ,nLenCol1,"C",STR0001},; //"Package"
            {"DESCRICAO",nLenCol2,"M",STR0002},; //"Qtd. Emb. Descrição"
            {"ORICRITER",nLenCol3,"C",STR0003},; //"Critério de Origem"
            {"PESBRUTO" ,nLenCol4,"C",STR0004},; //"Peso Bruto"
            {"INVOICE"  ,nLenCol5,"C",STR0005}}  //"N.Fatura/Data"

PRIVATE cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}

IF COVERI()

   // DETALHES
   IF CODET(aLENCOL,,"EE9_COD_I",,"PEM75",TOT_ITENS,.T.)

      // CABECALHO
      aCAB    := COCAB() 

      // Endereço do Consignatario
      SA1->(DbSetOrder(1))
      SA1->(DbSeek(xFilial("SA1")+EEC->EEC_CONSIG+EEC->EEC_COLOJA))
      aCAB[3,3] := SA1->(Alltrim(A1_END)+" - "+Alltrim(A1_MUN)+" - "+AllTrim(A1_ESTADO))
      aCAB[1,3] := StrTran(aCAB[1,3],"-"+Alltrim(aCAB[1,4])," ")

      // RODAPE
      aROD := COROD(TAMOBS)

      // EDICAO DOS DADOS
      IF COTELAGETS(STR0006,"8") //"GSTP"

          // EXPORTADOR
          mDET := ""
          mDET := mDET+REPLICATE(ENTER,09)
          mDET := mDET+cMargem+aCAB[1,1]+ENTER 
          mDET := mDET+cMargem+aCAB[1,2]+ENTER
          mDET := mDET+cMargem+aCAB[1,3]+ENTER 
          mDET := mDET+cMargem+aCAB[1,4]+ENTER
          
          // CONSIGNATARIO
          mDET := mDET+REPLICATE(ENTER,02)
          mDET := mDET+cMargem+aCAB[3,1]+ENTER 
          mDET := mDET+cmargem+aCAB[3,3]+ENTER 
          mDET := mDET+cMargem+aCAB[3,2]+ENTER
          mDET := mDET+cMargem+aCAB[3,4]+ENTER
     
          // VIA DE TRANSPORTE // ROTA 
          mDET := mDET+REPLICATE(ENTER,3)
          mDET := mDET+cMargem+aCAB[6]+ENTER
          mDET := mDET+cMargem+AllTrim(aCAB[9,1])+ENTER
          mDET := mDET+cMargem+AllTrim(aCAB[9,2])+ENTER
          mDET := mDET+cMargem+AllTrim(aCAB[9,3])+ENTER
          mDET := mDET+cMargem+AllTrim(aCAB[9,4])
          mDET := mDET+REPLICATE(ENTER,05)
          
          // RODAPE
          mROD := ""
          mRod := Repl(ENTER,15) 
          mRod := mROD+cMargem+Space(20)+aCAB[2,4]+REPLICATE(ENTER,05) // PAÍS IMPORTADOR

         //Data por extenso         
         mRod:= mRod + cMargem +Space(10)+ Str(Day(CtoD(aRod[5])), 2) + " DE " + AllTrim(Upper(MesExtenso(Month(CtoD(aRod[5]))))) +;
                " DE " + Str(Year(CtoD(aRod[5])), 4)
         
         //Data no formato DD/MM/AA         
         //mROD := mROD+cMargem+Space(19)+aROD[5]+Replicate(ENTER,11)
                   
          // DETALHES
          lRET := COIMP(mDET,mROD,cMargem,0)
      ENDIF
   ENDIF
ENDIF
RESTORD(aOrd)
RETURN(lRET)
*--------------------------------------------------------------------
USER Function PEM75()
// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem
Local cDESC,I,Z,Y,nLI,;
      nDESC       := AVSX3("EE9_VM_DES",AV_TAMANHO),;
      aORD        := SAVEORD({"EE9"}),;
      lPRI        := .T.
Local cPictDecPes := if(EEC->EEC_DECPES > 0,"."+Replic("9",EEC->EEC_DECPES),"")
Local cPictPeso   := "@E 9,999,999"+cPictDecPes  
Local nItem := 1

EE9->(DbSetOrder(4))
EE9->(DbSeek(xFilial("EE9")+EEC->EEC_PREEMB))
Do While ! EE9->(Eof()) .And.;
   EE9->(EE9_FILIAL+EE9_PREEMB) = (XFILIAL("EE9")+EEC->EEC_PREEMB)
   *  
   
   IF lPRI
      TMP->(DbAppend())
      nLI := 1
   EndIf
   // MONTA A DESCRICAO DO PRODUTO
   cDESC := AllTrim(Transform(EE9->EE9_SLDINI,"99999999"))+" "+ALLTRIM(EE9->EE9_UNIDAD)+" "
   Z     := MSMM(EE9->EE9_DESC,nDESC)
   For I := 1 To MLCOUNT(Z,nDESC)
       cDESC := cDESC+ALLTRIM(STRTRAN(MEMOLINE(Z,nDESC,I),ENTER,""))+" "
   Next
   Z := MLCOUNT(cDESC,nLenCol2)
   If (nLI+Z) > TOT_ITENS
      If ! lPRI
         For I := 1 To (TOT_ITENS-nLI)
             TMP->(DbAppend())
         Next
         lPRI := .T.
         Loop
      EndIf
   Else
      If lPRI
         lPRI := .F.
      Else
         TMP->(DbAppend())
      EndIf
   EndIf
   // GRAVA NO TMP A DESCRICAO DO PRODUTO
   Y := ""
   For I := 1 To MlCount(cDESC,nLenCol2)
       Y := Y+MemoLine(cDESC,nLenCol2,I)+ENTER
   NEXT 
   TMP->ORDEM     := StrZero(nItem,4)
   TMP->INVOICE   := AllTrim(EEC->EEC_NRINVO)+"-"+Dtoc(EEC->EEC_DTINVO)
   TMP->PACKAGE   := EE9->EE9_PACKAG
   TMP->ORICRITER := Space(nLenCol3)                             
   TMP->PESBRUTO  := Transform(EE9->EE9_PSBRTO,cPictPeso)+EE9->EE9_UNPES
   TMP->DESCRICAO := Y
   nLI            := nLI+Z
   nItem += 1
   EE9->(DbSkip())
EndDo
*
Restord(aORD)
Return(Nil)