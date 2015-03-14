
/*
Programa  : EECPEM58_RDM.
Objetivo  : Impressão do Certificado de Origem (OIC).
Autor     : Jeferson Barros Jr.
Data/Hora : 18/12/2003 16:59.
Obs       : considera que esta posicionado EEC.
*/

#include "EECPEM58.CH"
#include "EECRDM.CH"

#DEFINE MARGEM Space(07)
#DEFINE PORTUGUES "PORT. -PORTUGUES         "
#DEFINE DF_TAMLIN 80

/*
Funcao      : EECPEM58.
Parametros  : Nenhum.
Retorno     : .t.
Objetivos   : Impressão do Certificado de Origem (OIC).
Autor       : Jeferson Barros Jr.
Data/Hora   : 17/12/2003 16:56.
Revisao     :
Obs.        : Revisão - Inicialmente desenvolvido para a Nestle.
*/
*---------------------*
User Function EECPEM58
*---------------------*
Local lRet := .f.
Local aFields := {{"WKMARCA","C",02,0},;
                  {"WKCODIGO","C",AVSX3("EEN_IMPORT",3)+AVSX3("EEN_IMLOJA",3),0},;
                  {"WKDESCR","C",AVSX3("EEN_IMPODE",3),0}}
Local cFile
Local aORD
Local xARABICA,xROBUSTA,xTORRADO,xSOLUVEL,xOUTROS,xSECA,xUMIDA,xDESCAFEI,;
      xORGANICO,cPAISFOR,xSACAS,xGRANEL,xCONTAIN,xEMOUTROS,;
      xUNKG,xUNLB,cEND2FOR

Private aHeader[0],aCampos[0]
Private lInverte := .F.,cMarca := GetMark()
Private aNotify[0]
Private mDET := ""
Private cPack   := "", cUmPeso := "", cCoffee := "", cProcessam := ""
Private aPack   := {STR0038,STR0039,STR0040,STR0041} //"Sacas"###"Granel"###"Containers"###"Outro"
Private aCoffee := {STR0042,STR0043,STR0044,STR0045,STR0046} //"Arábica"###"Robusta"###"Torrado"###"Solúvel"###"Outros"
Private aProcessam := {STR0047,STR0048,STR0049,STR0050} //"Via Seca (Não Lavado)"###"Via Úmida (Lavado)"###"Descafeinado"###"Orgânico"
Private cMemoInfo:=""
Private cCODFORN,cCODIMP,cPAISDES,cPAISTRA,cMARCAOIC,cOUTROS,cPAISOR,;
        cCODPORTO,cMEIOTRA,aUNPESO,cUNPESO

Begin Sequence

   cFileMen := ""
   aORD     := SAVEORD({"EE9","SA2","EEN","SY9","SYA","SYQ","EE2"})
   xARABICA := xROBUSTA := xTORRADO  := xSOLUVEL  := xOUTROS := " "
   xSECA    := xUMIDA   := xDESCAFEI := xORGANICO := xSACAS  := " "
   xGRANEL  := xCONTAIN := xEMOUTROS := xUNKG     := xUNLB   := " "
   aUNPESO  := {"Kg","Lb"}

   // Criacao do Arquivo de Trabalho ...
   cFile := E_CriaTrab(,aFields,"WorkNOT")
   IndRegua("WorkNOT",cFile+OrdBagExt(),"WKCODIGO")
   IF ! TELAGETS()
      BREAK
   ENDIF

   // Gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      Break
   Endif

   // Adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())
   AVGLTT->AVG_CHAVE := EEC->EEC_PREEMB

   // ** Monta Variavel P/ Impressao
   mDET := REPLICATE(ENTER,4)
   
   // ** Exportador
   SA2->(DBSETORDER(1))
   SA2->(DBSEEK(XFILIAL("SA2")+ALLTRIM(cCODFORN)))
   SYA->(DBSETORDER(1))
   SYA->(DBSEEK(XFILIAL("SYA")+SA2->A2_PAIS))

   cPAISFOR := SYA->YA_DESCR
   cEND2FOR := ALLTRIM(EECMEND("SA2",1,cCODFORN+EEC->EEC_FOLOJA,.T.,,2))

   mDET := mDET+MARGEM+ALLTRIM(SA2->A2_NOME)+ENTER
   mDET := mDET+MARGEM+ALLTRIM(EECMEND("SA2",1,cCODFORN+EEC->EEC_FOLOJA,.T.,,1))+ENTER
   mDET := mDET+MARGEM+MEMOLINE(cEND2FOR,54,1)+ENTER
   mDET := mDET+MARGEM+MEMOLINE(cEND2FOR,54,2)+ENTER
   mDET := mDET+MARGEM+SPACE(40)+TRANSFORM(SA2->A2_ABICS,"@R 9  9  9  9")+REPLICATE(ENTER,3)

   // NUMERO DE REFERENCIA INTERNA
   mDET := mDET+MARGEM+SPACE(70)+ALLTRIM(EEC->EEC_REFIMP)+ENTER

   // NOTIFY / CODIGO DO PAIS DE ORIGEM / CODIGO DO PORTO DE ORIGEM
   // PAIS PRODUTOR (FORNECEDOR)
   SY9->(DBSETORDER(1))
   SY9->(DBSEEK(XFILIAL("SY9")+cCODPORTO))
   SYA->(DBSEEK(XFILIAL("SYA")+cPAISOR))
   mDET := mDET+MARGEM+PADR(aNOTIFY[1,1],54," ")+ENTER
   mDET := mDET+MARGEM+PADR(aNOTIFY[1,2],54," ")+;
           SPACE(05)+TRANSFORM(SYA->YA_ABICS,"@R 999")+SPACE(17)+TRANSFORM(SY9->Y9_ABICS,"@R 99999")+ENTER 
   
   SA1->(DBSETORDER(1))
   SA1->(DBSEEK(XFILIAL("SA1")+aNOTIFY[1][4]))
   mDET := mDET+MARGEM+PADR(aNOTIFY[1,3],60," ")+ENTER
   mDET := mDET+MARGEM+SPACE(41)+TRANSFORM(SA1->A1_ABICS,"@R 9  9  9  9")+;
           SPACE(21)+PADR(cPAISFOR,20," ")+SPACE(07)+;
           TRANSFORM(SYA->YA_ABICS,"@R 9  9  9")+REPLICATE(ENTER,4)

   SYA->(DBSETORDER(1))
   SYA->(DBSEEK(XFILIAL("SYA")+cPAISDES))
   mDET := mDET+MARGEM+SYA->YA_DESCR+;
           SPACE(18)+TRANSFORM(SYA->YA_ABICS,"@R 9  9  9")+;
           SPACE(10)+STR(DAY(EEC->EEC_DTINVO),2,0)+" / "+;
           UPPER(MESEXTENSO(MONTH(EEC->EEC_DTINVO)))+" / "+;
           STR(YEAR(EEC->EEC_DTINVO),4,0)+REPLICATE(ENTER,4)
   
   // PAIS DE TRANSBORDO / MEIO DE TRANSPORTE
   SYQ->(DBSETORDER(1))
   SYQ->(DBSEEK(XFILIAL("SYQ")+cMEIOTRA))
   SYA->(DBSEEK(XFILIAL("SYA")+cPAISTRA)) 
   
   mDET := mDET+MARGEM+PADR(SYA->YA_DESCR,20)+;
           SPACE(23)+TRANSFORM(SYA->YA_ABICS,"@R 9  9  9")+;
           SPACE(10)+PADR(SYQ->YQ_DESCR,20," ")+SPACE(13)+;
           TRANSFORM(SYQ->YQ_ABICS,"@R 9  9  9  9  9")+REPLICATE(ENTER,2)

   // EMBARCADO EM (TIPO DE EMBALAGEM)
   IF cPACK == aPACK[1] // "Sacas"      
      xSACAS := "X"
   ELSEIF cPACK == aPACK[2] // "Granel"
          xGRANEL := "X"
   ElseIf cPack == aPack[3] // "Containers"
          xCONTAIN := "X"
   ELSE  // Outros
      xEMOUTROS := "X"
   ENDIF

   mDET := mDET+MARGEM+SPACE(75)+xSACAS  +SPACE(22)+xGRANEL  +REPLICATE(ENTER,1)
   mDET := mDET+MARGEM+SPACE(75)+xCONTAIN+SPACE(22)+xEMOUTROS+ENTER

   // MARCA DE IDENTIFICACAO DA OIC
   mDET := mDET+MARGEM+SPACE(11)+;
           TRANSFORM(cMARCAOIC,"@R 99 999-9 999 !!!!!!!!!!!!!!")+REPLICATE(ENTER,4)

   // PESO LIQUIDO DA PARTIDA
   IF cUNPESO == aUNPESO[1] // KILOS
      xUNKG := "X"
   ELSE  // LIBRAS
      xUNLB := "X"
   ENDIF

   mDET := mDET+MARGEM+SPACE(65)+TRANSFORM(EEC->EEC_PESLIQ,"@E 9,999,999.999")+;
           SPACE(09)+xUNKG+SPACE(10)+xUNLB+REPLICATE(ENTER,3)

   // DESCRICAO DO CAFE
   IF cCOFFEE == aCOFFEE[1] // "Arábica"
      xARABICA := "X"
   ELSEIF cCOFFEE == aCOFFEE[2] // "Robusta"
          xROBUSTA := "X"
   ELSEIF cCOFFEE == aCOFFEE[3] // "Torrado"
          xTORRADO := "X"
   ELSEIF cCOFFEE == aCOFFEE[4] // "Soluvel"
          xSOLUVEL := "X"
   ELSE  // "Outros"
      xOUTROS := "X"
   ENDIF

   mDET := mDET+MARGEM+SPACE(18)+xARABICA+SPACE(23)+xROBUSTA+SPACE(23)+;
           xTORRADO+SPACE(23)+xSOLUVEL+REPLICATE(ENTER,2)
   mDET := mDET+MARGEM+SPACE(18)+xOUTROS+SPACE(18)+ALLTRIM(cOUTROS)+REPLICATE(ENTER,2)

   // METODO DE PROCESSAMENTO
   IF cPROCESSAM == aPROCESSAM[1] // "Via Seca (Não Lavado)"
      xSECA := "X"
   ELSEIF cPROCESSAM == aPROCESSAM[2] // Via Umida (lavado)"
          xUMIDA := "X"
   ELSEIF cPROCESSAM == aPROCESSAM[3] // "Descafeinado"
          xDESCAFEI := "X"
   ELSE // "Orgânico"
      xORGANICO := "X"
   ENDIF

   mDET := mDET+MARGEM+SPACE(25)+xSECA+SPACE(20)+xUMIDA+SPACE(19)+;
           xDESCAFEI+SPACE(16)+xORGANICO+REPLICATE(ENTER,19)

   // ** Outras informações.
   mDET := mDET+MARGEM+Memoline(cMemoInfo,DF_TAMLIN,01)+ENTER
   mDET := mDET+MARGEM+Memoline(cMemoInfo,DF_TAMLIN,02)+ENTER
   mDET := mDET+MARGEM+Memoline(cMemoInfo,DF_TAMLIN,03)+ENTER
   mDET := mDET+MARGEM+Memoline(cMemoInfo,DF_TAMLIN,04)+ENTER
   mDET := mDET+MARGEM+Memoline(cMemoInfo,DF_TAMLIN,05)+ENTER
   mDET := mDET+MARGEM+Memoline(cMemoInfo,DF_TAMLIN,06)+ENTER
   mDET := mDET+MARGEM+Memoline(cMemoInfo,DF_TAMLIN,07)+ENTER
   mDET := mDET+MARGEM+Memoline(cMemoInfo,DF_TAMLIN,08)+ENTER
   mDET := mDET+MARGEM+Memoline(cMemoInfo,DF_TAMLIN,09)+ENTER
   mDET := mDET+MARGEM+Memoline(cMemoInfo,DF_TAMLIN,10)+ENTER

   AVGLTT->WK_DETALHE := mDET
   cSEQREL := GETSXENUM("SY0","Y0_SEQREL")
   CONFIRMSX8()

   //executar rotina de manutencao de caixa de texto.
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO)

END SEQUENCE 

IF SELECT("WORKNOT") >  0
    WORKNOT->(E_ERASEARQ(cFILE))
ENDIF    

RESTORD(aORD)

RETURN(lRET)

/*
Funcao      : TelaGets()
Parametros  : Nenhum.
Retorno     : .t.
Objetivos   : Get dos dados para impressão do Certificado de Origem. (Oic).
Autor       : Jeferson Barros Jr.
Data/Hora   : 17/12/2003 17:02.
Revisao     :
Obs.        :
*/
*------------------------*
Static Function TelaGets()
*------------------------*
Local nopc:=0
Local lRet:= .f.
Local bOk  := {|| lRet:=.t.,nopc:=1,oDlg:End()}
Local bCancel := {|| lRet:=.f.,nopc:=0,oDlg:End()}
Local aCampos := { {"WKMARCA",," "},;
                   {"WKCODIGO",,STR0028},; // "Código"
                   {"WKDESCR",,STR0029}} // "Descrição"
Local aMarcados[4]
Local nTamLoj,cKey,cLoja,cImport,aMEMO,Z,cAUX,cRE,cSUF,X, i:=0
Local aRE

Begin Sequence
   
   GravaWork()

   // ** Set das variaveis.   
   Ini_Get()

   aRE       := {}
   aMEMO     := {}
   cPACK     := aPACK[1] 
   cUNPESO   := aUNPESO[1]

   EE9->(DBSETORDER(3))
   EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
   DO WHILE ! EE9->(EOF()) .AND.;
      EE9->(EE9_FILIAL+EE9_PREEMB) = (XFILIAL("EE9")+EEC->EEC_PREEMB)

      SB1->(DBSETORDER(1))
      SB1->(DBSEEK(XFILIAL("SB1")+EE9->EE9_COD_I))
      If SB1->(Fieldpos("B1_CAFE")) > 0    // JPP - 26/04/2005 - 14:00 - Verificar se o campo B1_CAFE existe antes de usa-lo
         IF ! EMPTY(EE9->EE9_RE) .AND. SB1->B1_CAFE $ cSIM
            AADD(aRE,EE9->EE9_RE)
            EE2->(DBSETORDER(1))
            EE2->(DBSEEK(XFILIAL("EE2")+"3*"+PORTUGUES+EE9->EE9_COD_I))
            AADD(aMEMO,MSMM(EE2->EE2_TEXTO,AVSX3("EE2_VM_TEX",AV_TAMANHO)))
         ENDIF
      Else
         IF ! EMPTY(EE9->EE9_RE)  // JPP - 26/04/2005 - 14:00 
            AADD(aRE,EE9->EE9_RE)
            EE2->(DBSETORDER(1))
            EE2->(DBSEEK(XFILIAL("EE2")+"3*"+PORTUGUES+EE9->EE9_COD_I))
            AADD(aMEMO,MSMM(EE2->EE2_TEXTO,AVSX3("EE2_VM_TEX",AV_TAMANHO)))
         ENDIF
      EndIf
      EE9->(DBSKIP())
   ENDDO

   aRE  := ASORT(aRE)
   cAUX := "R.E.: "
   
   // ** Carrega Primeiro Os REs
   FOR Z := 1 TO LEN(aRE)
       cAUX := cAUX+TRANSFORM(aRE[Z],AVSX3("EE9_RE",AV_PICTURE))
       cRE  := LEFT(aRE[Z],LEN(aRE[Z])-3)
       DO WHILE cRE = LEFT(aRE[Z],LEN(aRE[Z])-3)
          cSUF := RIGHT(aRE[Z],3)
          Z    := Z+1
          IF Z > LEN(aRE)
             EXIT
          ENDIF
       ENDDO
       Z := Z-1
       IF cSUF <> "001"
          cAUX := cAUX+"/"+cSUF
       ENDIF
       cAUX := cAUX+" "
   NEXT

   cRE := ALLTRIM(cAUX)+ENTER

   // ** Carrega o Peso do Cafe Cru em Grao
   cRE := cRE+"P.E. CAFÉ CRU EM GRÃO - "+ALLTRIM(TRANSFORM(EEC->EEC_PESLIQ*2.60,"@E 9,999,999.999"))+"KG"+ENTER

   // ** Carrega a descrição dos produtos.
   cAUX := ""
   FOR Z := 1 TO LEN(aMEMO)
       FOR X := 1 TO MLCOUNT(aMEMO[Z])
           cAUX := cAUX+ALLTRIM(MEMOLINE(aMEMO[Z],AVSX3("EE2_VM_TEX",AV_TAMANHO),X))+" "
       NEXT
       cAUX := ALLTRIM(cAUX)+ENTER
   NEXT

   // ** Monta o texto no tamanho da Impressao.
   cMEMOINFO := ""
   
   FOR Z := 1 TO MLCOUNT(cRE+cAUX,DF_TAMLIN)
      cMEMOINFO := cMEMOINFO+MEMOLINE(cRE+cAUX,DF_TAMLIN,Z)+ENTER
   NEXT

   DEFINE MSDIALOG oDLG TITLE ALLTRIM(WORKID->EEA_TITULO) FROM 9,0 TO 43,80 OF oMainWnd

      @ 15,04 To 63,313 LABEL STR0051 PIXEL //"Meio Transporte/Descrição do Café"
      @ 24,09 Say STR0052          SIZE 50,08 PIXEL //"Transporte "
      @ 24,45 ComboBox cPack Items aPack SIZE 80,08 PIXEL

      @ 024,150 SAY STR0053 SIZE 50,08 PIXEL //"Marca da IOC"
      @ 024,200 MSGET cMARCAOIC PICTURE "@R 99 999-9 999 !!!!!!!!!!!!!!" Size 80,08 PIXEL

      @ 37,009 SAY STR0054 SIZE 50,08 PIXEL //"Descr.Café "
      @ 37,045 COMBOBOX cCOFFEE ITEMS aCOFFEE SIZE 080,08 PIXEL
      @ 37,125 MSGET cOUTROS                  SIZE 120,08 PIXEL WHEN(cCOFFEE=STR0046) //"Outros"

      @ 49,009 Say STR0055 Size 50,08 PIXEL //"Método Proc."
      @ 49,045 ComboBox cProcessam Items aProcessam Size 80,08 PIXEL

      @ 49,150 SAY STR0056            SIZE 50,08 PIXEL //"Unidade de Peso"
      @ 49,200 COMBOBOX cUNPESO ITEMS aUNPESO   SIZE 30,08 PIXEL

      @ 067,004 TO 117,313 LABEL STR0057                 PIXEL //"Códigos"

      @ 076,009 SAY STR0058           SIZE 60,08 PIXEL //"Exportador"
      @ 076,055 MSGET cCODFORN  VALID(EMPTY(cCODFORN) .OR. EXISTCPO("SA2")) F3("SA2") SIZE 20,08 PIXEL

      @ 076,090 SAY STR0059        SIZE 60,08 PIXEL //"País de Transbordo"
      @ 076,145 MSGET cPAISTRA  VALID(EMPTY(cPAISTRA) .OR. EXISTCPO("SYA")) F3("SYA")   SIZE 20,08 PIXEL

      @ 076,181 SAY STR0060        SIZE 60,08 PIXEL //"Meio de Transporte"
      @ 076,235 MSGET cMEIOTRA  VALID(EMPTY(cMEIOTRA) .OR. EXISTCPO("SYQ")) F3("SYQ") SIZE 20,08 PIXEL

      @ 089,009 SAY STR0061           SIZE 60,08 PIXEL //"Porto de Origem"
      @ 089,055 MSGET cCODPORTO F3("SY9")  SIZE 25,08 PIXEL
      *
      @ 089,090 SAY STR0062            SIZE 60,08 PIXEL //"País de Origem"
      @ 089,145 MSGET cPAISOR   VALID(EMPTY(cPAISOR) .OR. EXISTCPO("SYA")) F3("SYA")   SIZE 20,08 PIXEL
      
      @ 101,009 SAY STR0063           SIZE 60,08 PIXEL //"País de Destino"
      @ 101,055 MSGET cPAISDES  VALID(EMPTY(cPAISDES) .OR. EXISTCPO("SYA")) F3("SYA")  SIZE 20,08 PIXEL
      
      @ 120,04 To 185,313 LABEL STR0064 PIXEL //"Outras Informações"
      @ 130,10 GET cMemoInfo MEMO PIXEL OF oDlg SIZE 297,50
      
      //GFP 25/10/2010
      aCampos := AddCpoUser(aCampos,"EEN","2")

      oMark := MsSelect():New("WorkNOT","WKMARCA",,aCampos,@lInverte,@cMarca,{190,1,250,315})
      oMark:bAval := {|| ChkMarca(aMarcados,oMark) }

      AddColMark(oMark,"WKMARCA")

   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

   For i := 1 To LEN(aMarcados)
      IF ! Empty(aMarcados[i])
         nTamLoj := AVSX3("EEN_IMLOJA",3)
         cKey    := aMarcados[i]
         cLoja   := Right(cKey,nTamLoj) 
         cImport := Subst(cKey,1,Len(cKey)-nTamLoj)
         IF EEN->(dbSeek(xFilial()+AvKey(EEC->EEC_PREEMB,"EEN_PROCES")+OC_EM+AvKey(cImport,"EEN_IMPORT")+AvKey(cLoja,"EEN_IMLOJA")))
            AADD(aNotify,{EEN->EEN_IMPODE,EEN->EEN_ENDIMP,EEN->EEN_END2IM,EEN->EEN_IMPORT})
         Endif
      Endif
   Next

   cOUTROS := IF(cCOFFEE<>"Outros",SPACE(60),cOUTROS)

   If (nOpc = 1 .And. !ValOic())
      If ! TelaGets() 
         lRet := .f.
      EndIf   
   EndIf

End Sequence

Return(lRet)

/*
Funcao      : CHKMARCA()
Parametros  : aMARCADOS,oMARK
Retorno     : .t.
Objetivos   : 
Autor       : Jeferson Barros Jr.
Data/Hora   : 17/12/2003 17:11.
Revisao     :
Obs.        :
*/
*---------------------------------------*
STATIC FUNCTION CHKMARCA(aMARCADOS,oMARK)
*---------------------------------------*
Local n

Begin Sequence

   IF !Empty(WorkNOT->WKMARCA) 
      // ** Desmarca
      n := aScan(aMarcados,WorkNOT->WKCODIGO)
      IF n > 0
         aMarcados[n] := ""
      Endif
      WorkNOT->WKMARCA := Space(2)
   Else
      // ** Marca
      IF Empty(aMarcados[1])
         aMarcados[1] := WorkNOT->WKCODIGO
      Else
         aMarcados[2] := WorkNOT->WKCODIGO
      Endif
      WorkNOT->WKMARCA := cMarca   
   Endif
   oMark:oBrowse:Refresh()

End Sequence

Return NIL

/*
Funcao      : GravaWork
Parametros  : Nenhum.
Retorno     : .t.
Objetivos   : Gravar a work dos notifys.
Autor       : Jeferson Barros Jr.
Data/Hora   : 18/12/2003 14:00.
Revisao     :
Obs.        :
*/
*-------------------------*
Static Function GravaWork()
*-------------------------*
Begin Sequence

   WorkNot->(__dbZap())
   
   EEN->(dbSeek(xFilial()+EEC->EEC_PREEMB+OC_EM))
   DO While EEN->(!Eof() .And. EEN_FILIAL == xFilial("EEN")) .And.;
      EEN->EEN_PROCES+EEN->EEN_OCORRE == EEC->EEC_PREEMB+OC_EM

      WorkNOT->(dbAppend())
      WorkNOT->WKCODIGO := EEN->EEN_IMPORT+EEN->EEN_IMLOJA
      WorkNOT->WKDESCR  := EEN->EEN_IMPODE
      EEN->(dbSkip())
   Enddo
   WorkNOT->(dbGoTop())
   
End Sequence

Return(Nil)

/*
Funcao      : Ini_Get.
Parametros  : Nenhum.
Retorno     : .t.
Objetivos   : Inicializar as variaveis de get.
Autor       : Jeferson Barros Jr.
Data/Hora   : 18/12/2003 13:56.
Revisao     :
Obs.        : 
*/
*----------------------*
Static Function Ini_Get
*----------------------*

Begin Sequence

   SA1->(DBSETORDER(1))
   SA2->(DBSETORDER(1))
   SA2->(DBSEEK(XFILIAL("SA2")+EEC->EEC_FORN))
   SA1->(DBSEEK(XFILIAL("SA1")+EEC->EEC_IMPORT))
   
   cCODFORN  := EEC->EEC_FORN
   cPAISOR   := POSICIONE("SY9",2,XFILIAL("SY9")+EEC->EEC_ORIGEM,"Y9_PAIS")
   cPAISDES  := POSICIONE("SY9",2,XFILIAL("SY9")+EEC->EEC_DEST,"Y9_PAIS")
   
   // Verificar.
   // cPAISTRA  := EEC->EEC_PAISTR
   
   cMARCAOIC := SPACE(35)
   cOUTROS   := SPACE(60)
   cMEIOTRA  := POSICIONE("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_VIA")
   cCODPORTO := POSICIONE("SY9",2,XFILIAL("SY9")+EEC->EEC_ORIGEM,"Y9_COD")

End Sequence

Return Nil

/*
Funcao      : ValOic.
Parametros  : Nenhum.
Retorno     : .t.
Objetivos   : Validar os gets do C.O. OIC.
Autor       : Jeferson Barros Jr.
Data/Hora   : 18/12/2003 15:21.
Revisao     :
Obs.        :
*/
*----------------------*
Static Function ValOic()
*----------------------*
Local lRet:=.t.

Begin Sequence

  // ** Valida os Notifys
  If Len(aNotify) == 0
     MsgStop(STR0065,STR0066) //"Nenhum Notify foi selecionado!"###"Atenção"
     lRet:=.f.
     Break
  EndIf

End Sequence

Return lRet

*----------------------------------------------------------------------------------------------------------------*
* FIM DO RDMAKE EECPEM58_RDM.PRW                                                                                 *
*----------------------------------------------------------------------------------------------------------------*