#INCLUDE "EECPEM74.ch"

/*
Programa. : EECPEM74_RDM.PRW
Objetivo..: Certificado Comum FIEP
Autor.....: Julio de Paula Paz
Data/Hora.: 12/06/2006
Obs.......: considera que estah posicionado no registro de processos (embarque) (EEC)
Revisão...: Fabrício e Diogo - 22/10/2009.
            Atualização do layout para a versão 5 e padronização para quatro linhas nos campos 1.Produtor/ Exportador,
            2.Importador e 3.Consignatário quando ativado o parâmetro MV_AVG0033.
*/
#include "EECRDM.CH"
//#define MARGEM Space(6)
//#define LENCOL1    17
//#define LENCOL2    21
//#define LENCOL3    45

//#DEFINE LENCOL4    20
#define TOT_ITENS  12
#DEFINE TAMOBS     80 //DFS - Tamanho máximo permitido
*--------------------------------------------------------------------
USER FUNCTION EECPEM74
LOCAL mDET,mROD,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"SYR","SYA"}),;
      aLENCOL

Private nLenCol1
Private cMargem
cMargem := Space(5)
nLenCol1 := 99

aLENCOL := {{"DESCRICAO",nLenCol1,"M",STR0001}} //"Denominação das Mercadorias"
//{"DESCRICAO",LENCOL3,"M",STR0003}

PRIVATE cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {}

IF COVERI()

   IF CODET(aLENCOL,, "EE9_POSIPI",, "PEM74", TOT_ITENS,,, "7") // 7 - Comum Fiep

      // CABECALHO
      aCAB    := COCAB()
      aROD    := COROD(TAMOBS) 
      aCAB[1,3] := StrTran(aCAB[1,3],"-"+AllTrim(aCAB[1,4])," ")

      // EDICAO DOS DADOS
      IF COTELAGETS(STR0002,"7") //"Comum FIEP"

         // N.FATURA / DATA DA FATURA 
         mDET := ""
         mDET := mDET+Replicate(ENTER,11)
         mDET := mDET+cMargem+Space(19)+aCAB[7]+SPACE(32)+aCAB[8]+ENTER

         // EXPORTADOR
         mDet := mDet + ENTER
         mDET := mDET+cMargem+Space(13)+aCAB[1,1]+Replicate(ENTER,2) 
         mDET := mDET+cMargem+Space(13)+aCAB[1,2]+ENTER
         mDET := mDET+cMargem+Space(13)+aCAB[1,3]+ENTER
         mDET := mDET+cMargem+Space(27)+aCAB[1,4]+Replicate(ENTER,2)

         // IMPORTADOR
         mDET := mDET+cMargem+Space(13)+aCAB[2,1]+Replicate(ENTER,2)
         mDET := mDET+cMargem+Space(13)+aCAB[2,2]+ENTER
         mDET := mDET+cMargem+Space(13)+aCAB[2,3]+ENTER  
         mDET := mDET+cMargem+Space(27)+aCAB[2,4]+Replicate(ENTER,2)  

         // CONSIGNATARIO
         mDET := mDET+cMargem+Space(13)+aCAB[3,1]+ENTER
         mDET := mDET+cmargem+Space(13)+aCAB[3,3]+ENTER
         mDET := mDET+cmargem+Space(27)+aCAB[3,2]+ENTER
         mDET := mDET+Replicate(ENTER,2)   

         // RODAPE
         mROD := ""        
         mROD := mROD+cMargem+Space(22)+aROD[1,1]+ENTER // LINHA 1 DA OBS.          
         mROD := mROD+cMargem+Space(22)+aROD[1,2]+ENTER // LINHA 2 DA OBS.
         mROD := mROD+cMargem+Space(22)+aROD[1,3]+ENTER // LINHA 3 DA OBS.
         mROD := mROD+cMargem+Space(22)+aROD[1,4]+ENTER // LINHA 4 DA OBS.
         mROD := mROD+Replicate(ENTER,10)

         //Data por extenso         
         mRod:= mRod + cMargem +Space(10)+ Str(Day(CtoD(aRod[5])), 2) + " DE " + AllTrim(Upper(MesExtenso(Month(CtoD(aRod[5]))))) +;
                " DE " + Str(Year(CtoD(aRod[5])), 4)
         
         //Data no formato DD/MM/AA         
         //mROD := mROD+cMargem+Space(10)+aROD[5]+Replicate(ENTER,11)   // Data emissão
         
         // DETALHES
         lRET := COIMP(mDET,mROD,cMargem,0)
      ENDIF
   ENDIF
ENDIF
RESTORD(aOrd)
RETURN(lRET)
*--------------------------------------------------------------------
/*USER FUNCTION PEM20()
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
      TMP->INVOICE   := EEC->EEC_NRINVO
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
   Z     := MSMM(EE9->EE9_DESC,nDESC)
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
   TMP->DESCRICAO := Y
   nLI            := nLI+Z
   EE9->(DBSKIP())
ENDDO
*
RESTORD(aORD)
RETURN(NIL)
  */
USER FUNCTION PEM74()
// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem
//LOCAL cPictPeso  := "@E 9,999,999"+if(EEC->EEC_DECPES > 0, "."+REPLICATE("9",EEC->EEC_DECPES),""),;
//      cPictPreco := AVSX3("EE9_PRCTOT",AV_PICTURE)

TMP->DESCRICAO := TMP->TMP_DSCMEM

RETURN(NIL)