#INCLUDE "EECPEM20.ch"

/*
Programa. : EECPEM20.PRW
Objetivo..: Certificado Fiesp Comum
Autor.....: Regiane A Dadario/Regina H.Perez
Data/Hora.: 13/01/1999
Obs.......: considera que estah posicionado no registro de processos (embarque) (EEC)
Revisão...: João Pedro Macimiano Trabbold - 13/06/05 - Impressão do certificado com o Layout da FIESP
Revisão...: Guilherme Fernandes Pilan - GFP - 03/12/2012 - Atualização de layout.
*/
#INCLUDE "EECPEM20.ch"
#include "EECRDM.CH"
//#define MARGEM Space(6)
//#define LENCOL1    17
//#define LENCOL2    21
//#define LENCOL3    45
#DEFINE LENCOL4    20
#define TOT_ITENS  20
#DEFINE TAMOBS     99
*--------------------------------------------------------------------
USER FUNCTION EECPEM20
LOCAL mDET,mROD,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"SYR","SYA"}),;
      aLENCOL

Private lLayOut := !Empty(ParamIxb)//JPM - 10/06/05

Private nLenCol1, nLenCol2, nLenCol3
Private cMargem
If lLayout
   cMargem := Space(3)
   nLenCol1 := 15 //20  // GFP - 03/12/2012
   nLenCol2 := 26
   nLenCol3 := 34   
Else
   cMargem := Space(6)
   nLenCol1 := 17
   nLenCol2 := 21
   nLenCol3 := 45   
EndIf

aLENCOL := {{/*"INVOICE"*/"ITEM"  ,nLenCol1,"C",/*STR0001*/STR0008                    },; //"N.Fatura"//"Item"  // GFP - 03/12/2012
            {"PACKAGE"  ,nLenCol2,"C",STR0002             },; //"Qtde. Tipo Emb."
            {"DESCRICAO",nLenCol3,"M",STR0003},; //"Especificacao das Mercadorias"
            {"PESLIQBRU",LENCOL4,"C",STR0004       }} //"Peso (Bruto e Liquido)"

PRIVATE cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}

IF COVERI()
   IF CODET(aLENCOL,,"EE9_COD_I",,"PEM20",TOT_ITENS,.T.) // DETALHES
      // CABECALHO
      aCAB    := COCAB()
      // CITY OF DESTINATION (Cidade do porto de destino)
      SYR->(DBSETORDER(1))
      SYR->(DBSEEK(XFILIAL("SYR")+EEC->(EEC_VIA+EEC_ORIGEM+EEC_DEST+EEC_TIPTRA)))
      aCAB[4] := SYR->YR_CID_DES
      // COUNTRY - PAIS DO DESTINO
      SYA->(DBSETORDER(1))
      SYA->(DBSEEK(XFILIAL("SYA")+SYR->YR_PAIS_DE))
      aCAB[5] := SYA->YA_DESCR
      // RODAPE
      aROD := COROD(TAMOBS)
      // EDICAO DOS DADOS
      IF COTELAGETS(STR0005,"3",,,,,,.T.) //"Comum"    // GFP - 03/12/2012
          // EXPORTADOR
          mDET := ""
          mDET := mDET+REPLICATE(ENTER,4)
          mDET := mDET+cMargem+aCAB[1,1]+ENTER 
          mDET := mDET+cMargem+aCAB[1,2]+ENTER
          mDET := mDET+cMargem+aCAB[1,3]+ENTER
          // IMPORTADOR
          mDET := mDET+REPLICATE(ENTER,If(lLayOut,7,5))
          mDET := mDET+cMargem+aCAB[2,1]+ENTER
          mDET := mDET+cMargem+aCAB[2,2]+ENTER
          mDET := mDET+cMargem+aCAB[2,3]+ENTER
          mDET := mDET+REPLICATE(ENTER,6) //8) // GFP - 03/12/2012
          // CIDADE/PAIS DE DESTINO
          mDET := mDET+cMargem+LEFT(aCAB[4],25)+SPACE(If(lLayOut,03,04))+LEFT(aCAB[5],25)+ENTER
          mDET := mDET+REPLICATE(ENTER,5) //+REPLICATE(ENTER,If(lLayOut,13,8)) // GFP - 03/12/2012
          // MEIO DE TRANSPORTE / PAÍS   // GFP - 03/12/2012
          mDET := mDET+cMargem+LEFT(aCAB[6],25)+SPACE(If(lLayOut,03,04))+LEFT(aCAB[7],25)+ENTER
          mDET := mDET+REPLICATE(ENTER,If(lLayOut,10,8))
          // RODAPE
          mROD := ""
          /*   Nopado por GFP - 03/12/2012
          If lLayOut
             mRod += Repl(ENTER,3)
          EndIf
          */
          // GFP - 03/12/2012
          mROD := mROD+Repl(cMargem,7)+aROD[1,1]+ENTER          // LINHA 1 DA OBS.          
          mROD := mROD+Repl(cMargem,7)+aROD[1,2]+ENTER          // LINHA 2 DA OBS.
          mROD := mROD+Repl(cMargem,7)+aROD[1,3]+ENTER          // LINHA 3 DA OBS.          
          /*   GFP - 03/12/2012
          mROD := mROD+Repl(cMargem,5)+aROD[1,4]+ENTER          // LINHA 4 DA OBS.
          mROD := mROD+Repl(cMargem,5)+aROD[1,5]+ENTER          // LINHA 5 DA OBS.          
          mROD := mROD+Repl(cMargem,5)+aROD[1,6]+ENTER          // LINHA 6 DA OBS.
          mROD := mROD+Repl(cMargem,5)+aROD[1,7]+ENTER          // LINHA 7 DA OBS.          
          mROD := mROD+Repl(cMargem,5)+aROD[1,8]+ENTER          // LINHA 8 DA OBS.
          */
          // DETALHES
          lRET := COIMP(mDET,mROD,cMargem,4,,,.T.)   // GFP - 03/12/2012
      ENDIF
   ENDIF
ENDIF
RESTORD(aOrd)
RETURN(lRET)
*--------------------------------------------------------------------
USER FUNCTION PEM20()
// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem
LOCAL cDESC,I,Z,Y,nLI,;
      nDESC       := AVSX3("EE9_VM_DES",AV_TAMANHO),;
      aORD        := SAVEORD({"EE9"}),;
      lPRI        := .T.
Local cPictDecPes := if(EEC->EEC_DECPES > 0,"."+Replic("9",EEC->EEC_DECPES),"")
Local cPictPeso   := "@E 999,999,999"+cPictDecPes

EE9->(DBSETORDER(4))
EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
DO WHILE ! EE9->(EOF()) .AND.;
   EE9->(EE9_FILIAL+EE9_PREEMB) = (XFILIAL("EE9")+EEC->EEC_PREEMB)
   *
   IF lPRI
      TMP->(DBAPPEND())
      //TMP->INVOICE   := EEC->EEC_NRINVO  // GFP - 03/12/2012
      IF TMP->(RECNO()) = 1
         TMP->PESLIQBRU := TRANSFORM(EEC->EEC_PESLIQ,cPictPeso)+STR0006 //" KG"
      ENDIF
      nLI := 1
      TMP->(DBAPPEND())
      TMP->PACKAGE   := EEC->EEC_PACKAGE
      IF TMP->(RECNO()) = 2
         TMP->PESLIQBRU := TRANSFORM(EEC->EEC_PESBRU,cPictPeso)+STR0007 //" KGS"
      ENDIF
   ENDIF
   // MONTA A DESCRICAO DO PRODUTO
   cDESC := ALLTRIM(TRANSFORM(EE9->EE9_SLDINI,"99999999"))+" "+ALLTRIM(EE9->EE9_UNIDAD)+" "
   Z     := AA100Idioma(EE9->EE9_COD_I) //MSMM(EE9->EE9_DESC,nDESC)    //GFP - 29/05/2012 - Tratamento de idiomas.
   FOR I := 1 TO MLCOUNT(Z,nDESC)
       cDESC := cDESC+ALLTRIM(STRTRAN(MEMOLINE(Z,nDESC,I),ENTER,""))+" "
   NEXT
   Z := MLCOUNT(cDESC,nLenCol3)
   IF (nLI+Z) > TOT_ITENS
      IF ! lPRI
         FOR I := 1 TO (TOT_ITENS-nLI)
             TMP->(DBAPPEND())
         NEXT
         lPRI := .T.
         LOOP
      ENDIF
   ELSE
      IF lPRI
         lPRI := .F.
      ELSE
         TMP->(DBAPPEND())
      ENDIF
   ENDIF
   // GRAVA NO TMP A DESCRICAO DO PRODUTO
   Y := ""
   FOR I := 1 TO MLCOUNT(cDESC,nLenCol3)
       Y := Y+MEMOLINE(cDESC,nLenCol3,I)+ENTER
   NEXT
   TMP->ITEM  := EE9->EE9_COD_I  // GFP - 03/12/2012
   TMP->DESCRICAO := Y
   nLI            := nLI+Z
   EE9->(DBSKIP())
ENDDO
*
RESTORD(aORD)
RETURN(NIL)
*--------------------------------------------------------------------