/*
Programa. : EECPEM45.PRW
Objetivo..: CERTIFICADO DE ORIGEM ARABE
Autor.....: LUCIANO CAMPOS DE SANTANA
Data/Hora.: 29/7/2002 - 15:00
OBS.......: CONSIDERA QUE ESTAH POSICIONADO NO REGISTRO DE PROCESSOS (EMBARQUE) (EEC)
*/
#include "EECRDM.CH"
#INCLUDE "EECPEM45.ch"
#define MARGEM Space(8)
#define LENCOL1    26   // MARKS AND NUMBERS
#DEFINE LENCOL2    60   // QUANTITY AND KIND OF PACKAGES + DESCRIPTION OF GOODS
#DEFINE LENCOL3    20   // WEIGHT (GROSS & NET)
#define TOT_ITENS  28
#DEFINE TAMOBS     99
*--------------------------------------------------------------------
USER FUNCTION EECPEM45
LOCAL mDET,mROD,;
      lRET    := .F.,;
      aOrd    := SaveOrd({"SYR","SYA","SA1","SA2","SAH","EE9","EE5","SYD","EEL","SA6"}),;
      aLENCOL := {{"DESCRICAO",LENCOL1+LENCOL2+LENCOL3+2,"M",STR0001}} //"Especificação das Mercadorias"

//Local nItem, nPagina, nLinha, cComplemento, c:=0, n:=0

PRIVATE cEDITA,;
        aRECNO   := {},aROD     := {},aCAB := {},;
        aC_ITEM  := {},aC_NORMA := {},;
        aH_ITEM  := {},aH_NORMA := {},;
        cObs     := ""
*
IF COVERI("ARABE")
   // CABECALHO
   aCAB := COCAB()
   // RODAPE
   aROD := COROD(TAMOBS)
   IF CODET(aLENCOL,,"EE9_SEQEMB",,"PEM45",TOT_ITENS,.T.) // DETALHES (MONTA TMP)
      // EDICAO DOS DADOS
      IF COTELAGETS(STR0002,"4") //"Arabe"
          // EXPORTADOR
          mDET := ""
          mDET := mDET+REPLICATE(ENTER,2)
          mDET := mDET+MARGEM+aCAB[1,1]+ENTER 
          mDET := mDET+MARGEM+aCAB[1,2]+SPACE(35)+TRANSFORM(EEC->EEC_PREEMB,AVSX3("EEC_PREEMB",AV_PICTURE))+ENTER
          mDET := mDET+MARGEM+aCAB[1,3]+ENTER
          // IMPORTADOR
          mDET := mDET+REPLICATE(ENTER,2)
          mDET := mDET+MARGEM+aCAB[2,1]+ENTER
          mDET := mDET+MARGEM+aCAB[2,2]+ENTER
          mDET := mDET+MARGEM+aCAB[2,3]+ENTER
          // CONSIGNATATIO
          mDET := mDET+REPLICATE(ENTER,3)
          mDET := mDET+MARGEM+aCAB[3,1]+ENTER
          mDET := mDET+MARGEM+aCAB[3,2]+ENTER
          mDET := mDET+MARGEM+aCAB[3,3]+ENTER
          // MEIO DE TRANSPORTE / DESTINO
          mDET := mDET+REPLICATE(ENTER,3)
          mDET := mDET+MARGEM+aCAB[9,1]+ENTER
          mDET := mDET+MARGEM+aCAB[9,2]+ENTER
          mDET := mDET+MARGEM+aCAB[9,3]+ENTER
          mDET := mDET+MARGEM+aCAB[9,4]+ENTER
          mDET := mDET+MARGEM+aCAB[9,5]+ENTER
          mDET := mDET+MARGEM+aCAB[9,6]+ENTER
          mDET := mDET+REPLICATE(ENTER,3)

          /*   
             //Nopado por TRP-14/03/2007
             //Observação. AMS - 05/01/2004 às 14:20.
 			 If EX0->(FieldPos("EX0_CODOBS")) <> 0

                cComplemento := Chr(244) + ENTER
                cObs := cComplemento + cObs

 			    For c := 0 To Len(ac_Item)-1
 			       nItem := Len(ac_Item)-c
 			 	   If !Empty(ac_Item[nItem,3]+ac_Item[nItem,4]+ac_Item[nItem,5]+ac_Item[nItem,6])
 		    	      nPagina := ac_Item[nItem,1]
 			 	      nLinha  := ac_Item[nItem,2]
 			 	      Exit
                   EndIf
 			    Next
		    
                For c := 1 To MLCount(cObs, LENCOL2+LENCOL3+LENCOL4)
             
                   If nLinha = TOT_ITENS
                      nPagina := nPagina + 1
                      nLinha  := 1
                   Else
				      nLinha  := nLinha +1
                   EndIf			       
 			       
			       ac_Item[nItem+1,1] := nPagina
 			 	   ac_Item[nItem+1,2] := nLinha
 			 	   ac_Item[nItem+1,3] := Space(23)
 			 	   ac_Item[nItem+1,4] := SubStr(MemoLine(cObs, LENCOL2+LENCOL3+LENCOL4, c ), 1, LENCOL2)
 			   	   ac_Item[nItem+1,5] := SubStr(MemoLine(cObs, LENCOL2+LENCOL3+LENCOL4, c ), LENCOL2+1, LENCOL3)
 			 	   ac_Item[nItem+1,6] := SubStr(MemoLine(cObs, LENCOL2+LENCOL3+LENCOL4, c ), LENCOL2+LENCOL3+1, LENCOL4)
 			 	   ac_Item[nItem+1,7] := .F.

                   nItem := nItem + 1

                   If nItem = Len(ac_Item)
                      For n := 1 To TOT_ITENS
                         aAdd( ac_Item, { nPagina+1, n, "", "", "", "", .F. } )
                      Next
                   EndIf

                Next

				
                EX0->(RecLock("EX0", .F.))
                EX0->EX0_OBS := StrTran( cObs, cComplemento, "" )
                EX0->(MSUnlock())
                
                
                MSMM(, AVSX3("EX0_OBS", AV_TAMANHO),, StrTran(cObs, cComplemento, ""), 1,,, "EX0", "EX0_CODOBS")
             
             EndIf
             //Fim da Obs.
          */
          // RODAPE
          mROD := ""
          mROD := mROD+REPLICATE(ENTER,1)
          mROD := mROD+MARGEM+SPACE(10)+aROD[4]+ENTER
         // DETALHES
         lRET := COIMP(mDET,mROD,MARGEM,0)
      ENDIF
   ENDIF
ENDIF
RESTORD(aOrd)
RETURN(lRET)
*--------------------------------------------------------------------
USER FUNCTION PEM45()
// Estrutura do parametro que o ponto de entrada recebe (PARAMIXB)
// 1. Posicao = Numero da Ordem
// 2. Posicao em diante = numero dos registro que estao relacionados na ordem
LOCAL cDESC,Z,lEECUNIDAD,cPICQTDEM1,cPICSLDINI,cUNIDEEC,nTAMLI,;
      cLENCOL1,cLENCOL2,cLENCOL3,X,;
      lPRI        := .T.,;
      cPictDecPes := if(EEC->EEC_DECPES > 0,"."+Replic("9",EEC->EEC_DECPES),"")

Local cPictPeso   := "@E 999,999,999"+cPictDecPes

lEECUNIDAD := EEC->(FIELDPOS("EEC_UNIDAD")) # 0
cPICQTDEM1 := AVSX3("EE9_QTDEM1",AV_PICTURE)
cPICSLDINI := AVSX3("EE9_SLDINI",AV_PICTURE)
cUNIDEEC := ""
nTAMLI     := LENCOL1+LENCOL2+LENCOL3+2
cLENCOL1   := PADR("||",LENCOL1," ")
EE9->(DBSETORDER(3))
EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
DO WHILE ! EE9->(EOF()) .AND.;
   EE9->(EE9_FILIAL+EE9_PREEMB) = (XFILIAL("EE9")+EEC->EEC_PREEMB)
   *
   IF lPRI
      // BUSCA A UNI.MED DO EMBARQUE
      cUNIDEEC := STR0003 //"KGS"
      IF lEECUNIDAD .AND. ! EMPTY(EEC->EEC_UNIDAD)
         SAH->(DBSETORDER(1))
         IF (SAH->(DBSEEK(XFILIAL("SAH")+EEC->EEC_UNIDAD)))
            cUNIDEEC := ALLTRIM(SAH->AH_UMRES)
         ENDIF
      ENDIF
      // 1.a LINHA. (PACKAGE)
      TMP->(DBAPPEND())
      TMP->DESCRICAO := cLENCOL1+" "+;
                        PADR(ALLTRIM(EEC->EEC_PACKAGE)+STR0004,LENCOL2," ")+" "+; //" WITH:"
                        PADL(ALLTRIM(TRANSFORM(EEC->EEC_PESBRU,cPICTPESO)),LENCOL3," ")
      // 2.a LINHA (UNIDADE DE MEDIDA - GROSS)
      TMP->(DBAPPEND())
      TMP->DESCRICAO := cLENCOL1+" "+;
                        PADR("",LENCOL2," ")+" "+;
                        PADL(cUNIDEEC+STR0005,LENCOL3," ") //" GROSS"
      // 3.a LINHA (QTDEMB+DESCR.EMB)
      EE5->(DBSETORDER(1))
      EE5->(DBSEEK(XFILIAL("EE5")+EE9->EE9_EMBAL1))
      cLENCOL2 := PADR(ALLTRIM(TRANSFORM(EE9->EE9_QTDEM1,cPICQTDEM1))+" "+;
                       ALLTRIM(EE5->EE5_DESC)+STR0006,LENCOL2," ") //" CONTAINING"
      cLENCOL3 := PADL(ALLTRIM(TRANSFORM(EEC->EEC_PESLIQ,cPICTPESO)),LENCOL3," ")
      TMP->(DBAPPEND())
      TMP->DESCRICAO := cLENCOL1+" "+cLENCOL2+" "+cLENCOL3
      *
      cLENCOL3 := PADL(cUNIDEEC+STR0007,LENCOL3," ") //" NET"
      lPRI     := .F.
   ELSE
      cLENCOL3 := PADL("",LENCOL3," ")
   ENDIF
   // IMPRESSAO DOS ITENS (SLDINI+UNI.MED.+DESCRICAO DO ITEM)
   SAH->(DBSETORDER(1))
   SAH->(DBSEEK(XFILIAL("SAH")+EE9->EE9_UNIDAD))
   X     := ""
   cDESC := AA100Idioma(EE9->EE9_COD_I) //MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",AV_TAMANHO))    //GFP - 29/05/2012 - Tratamento de idiomas.
   FOR Z := 1 TO MLCOUNT(cDESC,AVSX3("EE9_VM_DES",AV_TAMANHO))
       X := X+ALLTRIM(MEMOLINE(cDESC,AVSX3("EE9_VM_DES",AV_TAMANHO),Z))+" "
   NEXT
   cDESC := ALLTRIM(TRANSFORM(EE9->EE9_SLDINI,cPICSLDINI))+" "+;
            ALLTRIM(SAH->AH_UMRES)+STR0008+X //" OF "
   X     := ""
   FOR Z := 1 TO MLCOUNT(cDESC,LENCOL2)
       cLENCOL2 := PADR(MEMOLINE(cDESC,LENCOL2,Z),LENCOL2," ")
       X        := X+cLENCOL1+" "+cLENCOL2+" "+cLENCOL3+ENTER
       cLENCOL3 := SPACE(LENCOL3)
   NEXT
   TMP->(DBAPPEND())
   TMP->DESCRICAO := X
   EE9->(DBSKIP())
ENDDO
// LINHA DA FLECHA
cLENCOL1 := PADR("\/",LENCOL1," ")
cLENCOL2 := SPACE(LENCOL2)
cLENCOL3 := SPACE(LENCOL3)
TMP->(DBAPPEND())
TMP->DESCRICAO := cLENCOL1+" "+cLENCOL2+" "+cLENCOL3
// MARCACAO
cDESC := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
FOR Z := 1 TO MLCOUNT(cDESC,nTAMLI)
    TMP->(DBAPPEND())
    TMP->DESCRICAO := MEMOLINE(cDESC,nTAMLI,Z)
NEXT
// MANUFACTURE/EXPORTER
TMP->(DBAPPEND()) // PULA UMA LINHA
TMP->(DBAPPEND())
TMP->DESCRICAO := STR0009+ENTER+; //"MANUFACTURER/EXPORTER: "
                   ALLTRIM(aCAB[1,1])+ENTER+;
                   ALLTRIM(aCAB[1,2])+ENTER+;
                   ALLTRIM(aCAB[1,3])+ENTER
// CARTA DE CREDITO
IF ! EMPTY(EEC->EEC_LC_NUM)
   EEL->(DBSETORDER(1))
   EEL->(DBSEEK(XFILIAL("EEL")+AVKEY(EEC->EEC_LC_NUM,"EEL_LC_NUM")))
   SA6->(DBSETORDER(1))
   SA6->(DBSEEK(XFILIAL("SA6")+AVKEY(EEL->EEL_BCOEM,"A6_COD")))
   TMP->(DBAPPEND()) // PULA UMA LINHA
   TMP->(DBAPPEND())
   TMP->DESCRICAO := STR0010+ALLTRIM(TRANSFORM(EEC->EEC_LC_NUM,AVSX3("EEC_LC_NUM",AV_PICTURE)))+; //"LETTER OF CREDIT NO.: DOK "
                     STR0011+EEL->(RIGHT(STRZERO(YEAR(EEL_DT_EMI),4,0),2)+"/"+STRZERO(MONTH(EEL_DT_EMI),2,0)+"/"+STRZERO(DAY(EEL_DT_EMI),2,0))+STR0012+ENTER+; //" ISSUED ON "###" BY"
                     ALLTRIM(SA6->A6_NOME)+STR0013 //" - DOKKI BRANCH"
ENDIF
// TEXTO FIXO
TMP->(DBAPPEND()) // PULA UMA LINHA
TMP->(DBAPPEND())
TMP->DESCRICAO := STR0014                       //"NATIONALITY OF THE MANUFACTURER/EXPORTER: BRAZILIAN"
RETURN(NIL)
*--------------------------------------------------------------------
