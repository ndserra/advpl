
/*
Programa..: EECPEM47.PRW
Objetivo..: GERACAO DO TXT IN86 BASEADO NO EMBARQUE
Autor.....: Luciano Campos de Santana
Data/Hora.: 11/03/2001
Obs.......:
*/
#include "EEC.CH"
#INCLUDE "EECPEM47.ch"
*--------------------------------------------------------------------
USER FUNCTION EECPEM47
LOCAL aORD    := SAVEORD({"EEC","SA2","EEM","EE9","SA1"}),;
      bOKC    := {|| nOPC := 1,IF(!PEM47(4),nOPC := 0,oDLG:END())},;
      bOK     := {|| nOPC := 1,IF(!PEM47(3),nOPC := 0,oDLG:END())},;
      bOKM    := {|| nOPC := 1,oDLG:END()},;
      bCANCEL := {|| nOPC := 0,oDLG:END()},;
      aTIPO   := {STR0001,STR0002,STR0003},; //"1-Nao Enviados"###"2-Ja Enviados "###"3-Ambos       "
      aPOS    := {},;                                    
      aCPOS   := {{"WRK_FLAG"  ,," "        } ,;
                  {"WRK_ENVIO" ,,STR0004    } ,; //"Enviado"
                   COLBRW("EEC_PREEMB","WRK") ,;
                   COLBRW("EEC_DTEMBA","WRK") ,;
                   COLBRW("EEC_DTPROC","WRK") ,;
                  {"WRK_STATUS",,STR0005    } ,; //"Status"
                  {"WRK_IMPORT",,STR0006    }},; //"Importador"
      nOPC    := 0,;
      oDLG,cSA2FILIAL,oMARK
PRIVATE aCAMPOS  := {},;
        aHEADER  := {},;
        aBUTTONS := {{"LBTIK",{|| PEM47(7)} ,STR0007}},; //"Marca/Desmarca Todos"
        lINVERTE := .F.,;
        cMARCA   := GETMARK(),;
        cPREEMB,cESTAB,dDTREI,dDTREF,dDTEMBAI,dDTEMBAF,cTIPO,cFILE,cPATH,;
        cMODELO,nHANDLE,cCOND,cWRKFILE,cTMPFILE,dDTNFI,dDTNFF
*
BEGIN SEQUENCE
   IF EEC->(FIELDPOS("EEC_IN86")) = 0
      MSGINFO(STR0008+ENTER+; //"Campo de controle da Integracao-IN86 nao existe."
              STR0009+ENTER+; //"Entre no configurador e crie o campo com as seguintes carasteristicas:"
              STR0010+ENTER+; //"Campo: EEC_IN86"
              STR0011+ENTER+; //"Tipo: Caracter"
              STR0012+ENTER+; //"Tamanho: 1"
              STR0013+ENTER+; //"Formato: !"
              STR0014+ENTER+; //"Cabecalho e Descricao: Flag IN86"
              STR0015,STR0016) //"Propriedade: marcar a opcao Visualiza"###"Atencao"
      BREAK
   ENDIF
   cPREEMB := SPACE(AVSX3("EEC_PREEMB",AV_TAMANHO))
   cESTAB  := SPACE(AVSX3("A2_COD"    ,AV_TAMANHO))
   dDTREI  := dDTREF := dDTEMBAI := dDTEMBAF := dDTNFI := dDTNFF := CTOD("  /  /  ")
   cTIPO   := SPACE(14)
   *
   DEFINE MSDIALOG oDLG TITLE STR0017 FROM 0,0 TO 221,350 OF oMainWnd PIXEL //"Integracao - IN86"
      @ 20,003 SAY AVSX3("EEC_PREEMB",AV_TITULO) PIXEL OF oDLG
      @ 20,053 MSGET cPREEMB  SIZE 90,08         PIXEL F3("EEC") VALID(PEM47(1)) OF oDLG
      *
      @ 35,003 SAY STR0018                PIXEL OF oDLG //"Estabelecimento"
      @ 35,053 MSGET cESTAB   SIZE 40,08  PIXEL F3("SA2") VALID(PEM47(2))OF oDLG
      *
      @ 50,003 SAY STR0019                PIXEL OF oDLG //"Data da R.E."
      @ 50,053 MSGET dDTREI   SIZE 35,08  PIXEL OF oDLG
      @ 50,093 SAY STR0020                PIXEL OF oDLG //"Ate"
      @ 50,108 MSGET dDTREF   SIZE 35,08  PIXEL OF oDLG
      *
      @ 65,003 SAY STR0021                PIXEL OF oDLG //"Data do embarque"
      @ 65,053 MSGET dDTEMBAI SIZE 35,08  PIXEL OF oDLG
      @ 65,093 SAY STR0020                PIXEL OF oDLG //"Ate"
      @ 65,108 MSGET dDTEMBAF SIZE 35,08  PIXEL OF oDLG      
      *
      @ 80,003 SAY STR0053                PIXEL OF oDLG //"Data da Nota Fiscal"
      @ 80,053 MSGET dDTNFI   SIZE 35,08  PIXEL OF oDLG
      @ 80,093 SAY STR0020                PIXEL OF oDLG //"Ate"
      @ 80,108 MSGET dDTNFF   SIZE 35,08  PIXEL OF oDLG      
      *
      @ 95,003 SAY STR0022                PIXEL OF oDLG //"Tipo"
      @ 95,053 COMBOBOX cTIPO SIZE 55,08  PIXEL OF oDLG ITEMS aTIPO 
      *     
   ACTIVATE MSDIALOG oDLG ON INIT ENCHOICEBAR(oDLG,bOK,bCANCEL) CENTERED
   IF nOPC = 1
      MSAGUARDE({|| PEM47SEL(),STR0023}) //"Selecioando Processos"
      WRK->(DBGOTOP())
      IF WRK->(EOF() .OR. BOF())
         MSGINFO(STR0024,STR0016) //"Nao a dados para gerar o arquivo !"###"Atencao"
         BREAK
      ELSEIF EMPTY(cPREEMB)
             // MONTA BROWSE P/ SELECAO DOS PROCESSOS
             nOPC := 0
             DEFINE MSDIALOG oDlg TITLE STR0025 FROM DLG_LIN_INI,DLG_COL_INI TO DLG_LIN_FIM,DLG_COL_FIM OF oMainWnd PIXEL //"Selecao de Processos - Integracao IN86"
                aPOS    := POSDLG(oDLG)
                aPOS[1] := 20
                
                //GFP 25/10/2010
                aCPOS := AddCpoUser(aCPOS,"EEC","2")
                
                oMark   := MSSELECT():NEW("WRK","WRK_FLAG",,aCPOS,@lINVERTE,@cMARCA,aPOS)
             ACTIVATE MSDIALOG oDlg ON INIT ENCHOICEBAR(oDlg,bOKM,bCANCEL,,aBUTTONS)
             IF nOPC = 0
                MSGINFO(STR0026,STR0027) //"Integracao cancelada pelo usuario !"###"Aviso"
                BREAK
             ENDIF
      ENDIF
      PROCESSA({|| PEM47TMP(),STR0028,STR0029}) //"Processando"###"Aguarde"
      IF TMP->(EOF() .OR. BOF())
         MSGINFO(STR0024,STR0016) //"Nao a dados para gerar o arquivo !"###"Atencao"
         BREAK
      ENDIF
      // TELA DE CONFIGURACAO P/ GERAR O TXT
      nOPC    := 0
      cFILE   := PADR(RIGHT(STRZERO(YEAR(dDATABASE),4,0),2)+STRZERO(MONTH(dDATABASE),2,0)+ALLTRIM(LEFT(cESTAB,4))+".TXT",12," ")
      cPATH   := PADR(ALLTRIM(GETNEWPAR("MV_AVG0018"," ")),20," ")
      cPATH   := IF(ALLTRIM(cPATH)=".",SPACE(20),cPATH)
      cMODELO := PADR(ALLTRIM(GETNEWPAR("MV_AVG0019"," ")),02," ")
      DEFINE MSDIALOG oDLG TITLE STR0030 FROM 0,0 TO 196,350 OF oMainWnd PIXEL //"Integracao - IN86 - Configuracao"
         @ 20,03 SAY STR0031            PIXEL OF oDLG //"Arquivo"
         @ 20,33 MSGET cFILE   SIZE 90,08 PIXEL OF oDLG
         *
         @ 35,03 SAY STR0032            PIXEL OF oDLG //"Caminho"
         @ 35,33 MSGET cPATH   SIZE 40,08 PIXEL OF oDLG
         *
         @ 50,03 SAY STR0033             PIXEL OF oDLG //"Modelo"
         @ 50,33 MSGET cMODELO SIZE 15,08 PIXEL OF oDLG
         @ 50,55 SAY STR0034    PIXEL OF oDLG //"Conforme Tabela de Modelos de"
         @ 60,55 SAY STR0035   PIXEL OF oDLG  //"Documentos Fiscais prevista no"
         @ 70,55 SAY STR0036 PIXEL OF oDLG //"manual de orientacao do Convenio"
         @ 80,55 SAY STR0037               PIXEL OF oDLG //"ICMS n.57, de 1995"
         *
      ACTIVATE MSDIALOG oDLG ON INIT ENCHOICEBAR(oDLG,bOKC,bCANCEL) CENTERED
      IF nOPC = 1
         // GUARDA OS VALORES DIGITADOS P/ PROXIMA INTEGRACAO
         BEGIN TRANSACTION
            SX6->(DBSETORDER(1))
            IF ! (SX6->(DBSEEK("  MV_AVG0018")))
               SX6->(RECLOCK("SX6",.T.))
               SX6->X6_VAR     := "MV_AVG0018"
               SX6->X6_TIPO    := "C"
               SX6->X6_DESCRIC := "Caminho de geracao do arquivo de integracao IN86"
            ENDIF
            IF ! (SX6->(DBSEEK("  MV_AVG0019")))
               SX6->(RECLOCK("SX6",.T.))
               SX6->X6_VAR     := "MV_AVG0019"
               SX6->X6_TIPO    := "C"
               SX6->X6_DESCRIC := "Modelo do documento p/ Integracao IN86"
            ENDIF
            SETMV("MV_AVG0018",cPATH)
            SETMV("MV_AVG0019",cMODELO)
            PROCESSA({|| PEM47TXT()},STR0038,STR0029) //"Gerando o arquivo texto"###"Aguarde"
         END TRANSACTION
         FCLOSE(nHANDLE)
         MSGINFO(STR0039,STR0027) //"Arquivo gerado com sucesso !"###"Aviso"
      ELSE
         MSGINFO(STR0026,STR0027) //"Integracao cancelada pelo usuario !"###"Aviso"
      ENDIF
   ENDIF
END SEQUENCE
IF SELECT("TMP") <> 0
   DBSELECTAREA("TMP")
   TMP->(E_ERASEARQ(cTMPFILE))
ENDIF
IF SELECT("WRK") <> 0
   DBSELECTAREA("WRK")
   WRK->(E_ERASEARQ(cWRKFILE))
ENDIF
RESTORD(aORD)
RETURN(NIL)
*--------------------------------------------------------------------
STATIC FUNCTION PEM47(nP_ACAO)
LOCAL lRET := .T.,;
      c1
IF nP_ACAO = 1 .AND. ! EMPTY(cPREEMB)
   EEC->(DBSETORDER(1))
   IF ! (EEC->(DBSEEK(XFILIAL("EEC")+cPREEMB)))
      MSGINFO(STR0040,STR0016) //"Processo de embarque nao cadastrado !"###"Atencao"
      lRET := .F.
   ENDIF
ELSEIF nP_ACAO = 2 .AND. ! EMPTY(cESTAB)
       SA2->(DBSETORDER(1))
       IF ! (SA2->(DBSEEK(XFILIAL("SA2")+cESTAB)))
          MSGINFO(STR0041,STR0016) //"Estabelecimento Invalido !"###"Atencao"
          lRET := .F.
       ENDIF
ELSEIF nP_ACAO = 3
       IF EMPTY(cPREEMB) .AND. EMPTY(cESTAB)
          MSGINFO(STR0042,STR0016) //"Preencha o Processo ou o Estabelecimento !"###"Atencao"
          lRET := .F.
       ELSEIF ! PEM47(1) .OR. ! PEM47(2) .OR. ! PEM47(5)
              lRET := .F.
       ENDIF
ELSEIF nP_ACAO = 4
       c1 := ALLTRIM(cPATH)
       c1 := c1+IF(RIGHT(c1,1)#"\","\","")
       // VERIFICA SE O ARQUIVO JA EXISTE
       IF FILE(c1+ALLTRIM(cFILE)) .AND.;
          ! MSGYESNO(STR0043,STR0016) //"Ja existe um arquivo com este nome. Deseja sobrepor ?"###"Atencao"
          *
          lRET := .F.
       ELSE
          // TENTA CRIAR O ARQUIVO NO LOCAL ESPECIFICADO
          nHANDLE := FCREATE(c1+ALLTRIM(cFILE),0)
          IF nHANDLE = -1
             MSGINFO(STR0044,STR0016) //"Nao foi possivel criar o arquivo !"###"Atencao"
             lRET := .F.
          ENDIF
       ENDIF
ELSEIF nP_ACAO = 5
       IF EMPTY(cPREEMB) .AND. ! EMPTY(cESTAB)
          IF ! EMPTY(dDTREF) .AND. ! EMPTY(dDTREI) .AND. DTOS(dDTREF) < DTOS(dDTREI)
             MSGINFO(STR0045,STR0016) //"Intervalo de R.E. invalido !"###"Atencao"
             lRET := .F.
          ELSEIF ! EMPTY(dDTEMBAF) .AND. ! EMPTY(dDTEMBAI) .AND. DTOS(dDTEMBAF) < DTOS(dDTEMBAI)
                 MSGINFO(STR0046,STR0016) //"Intervalo da data de embarque invalido !"###"Atencao"
                 lRET := .F.
          ELSEIF ! EMPTY(dDTNFF) .AND. ! EMPTY(dDTNFI) .AND. DTOS(dDTNFF) < DTOS(dDTNFI)
                 MSGINFO(STR0054,STR0016) //"Intevalo de datas das notas fiscais invalido !"
                 lRET := .F.
          ENDIF
       ENDIF
ELSEIF nP_ACAO = 6
       IF EMPTY(cPREEMB)
          IF (! EMPTY(dDTEMBAI)   .AND. DTOS(dDTEMBAI) > DTOS(EEC->EEC_DTEMBA)) .OR.;
             (! EMPTY(dDTEMBAF)   .AND. DTOS(dDTEMBAF) < DTOS(EEC->EEC_DTEMBA)) .OR.;
             (LEFT(cTIPO,1) # "3" .AND. (LEFT(cTIPO,1) = "1" .AND. EEC->EEC_IN86 = "2") .OR.;
                                        (LEFT(cTIPO,1) = "2" .AND. AT(EEC->EEC_IN86,"1 ") # 0))
             *
             lRET := .F.
          ENDIF
       ENDIF
ELSEIF nP_ACAO = 7
       c1 := {WRK->(RECNO()),;
              IF(EMPTY(WRK->WRK_FLAG),cMARCA,"  ")}
       WRK->(DBGOTOP())
       DO WHILE ! WRK->(EOF())
          WRK->WRK_FLAG := c1[2]
          WRK->(DBSKIP())
       ENDDO
       WRK->(DBGOTO(c1[1]))
ENDIF
RETURN(lRET)
*--------------------------------------------------------------------
STATIC FUNCTION PEM47SEL()
LOCAL n1,n3,lOK,;
      aWORK := {{"WRK_FLAG"  ,"C",02,0},;
                {"WRK_ENVIO" ,"C",03,0},;
                {"EEC_PREEMB","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0},;
                {"EEC_DTEMBA","D",08,0},;
                {"EEC_DTPROC","D",08,0},;
                {"WRK_STATUS","C",40,0},;
                {"WRK_IMPORT","C",50,0}}
*
// ARQUIVO DE SELECAO DOS PROCESSOS
cWRKFILE := E_CRIATRAB(,aWORK,"WRK")
INDREGUA("WRK",cWRKFILE+ORDBAGEXT(),"EEC_PREEMB")
IF ! EMPTY(cPREEMB)
   cESTAB := EEC->(IF(EMPTY(EEC_EXPORT),EEC_FORN,EEC_EXPORT))
   cCOND  := "EEC->(EEC_FILIAL+EEC_PREEMB) = (XFILIAL('EEC')+cPREEMB)"
   n3     := 1
ELSE
   EEC->(DBSETORDER(9)) // EXPORTADOR
   EEC->(DBSEEK(XFILIAL("EE9")+AVKEY(cESTAB,"EEC_EXPORT")))
   cCOND := "EEC->(EEC_FILIAL+EEC_EXPORT) = (XFILIAL('EEC')+AVKEY(cESTAB,'EEC_EXPORT'))"
   n3    := 2
ENDIF
FOR n1 := 1 TO n3
    DO WHILE ! EEC->(EOF()) .AND. &cCOND
       MSPROCTXT(STR0047+EEC->EEC_PREEMB) //"Verificando Processo "
       IF PEM47(6)
          lOK   := .F.
          // VERIFICANDO SE NFs ESTAO CORRETAS
          EEM->(DBSETORDER(1))
          EEM->(DBSEEK(xFILIAL("EEM")+EEC->EEC_PREEMB))
          DO WHILE ! EEM->(EOF()) .AND.;
             EEM->(EEM_FILIAL+EEM_PREEMB) = (XFILIAL("EEM")+EEC->EEC_PREEMB)
             *          
             If EEM->EEM_TIPONF == EEM_CP // By JPP 23/03/2006 - 17:30 - Nota fiscal complementar
                EEM->(DbSkip())
                Loop
             EndIf
             IF EEM->(EMPTY(EEM_NRNF) .OR. EMPTY(EEM_SERIE) .OR. EMPTY(EEM_DTNF)) .OR.;
                (EMPTY(cPREEMB) .AND. (! EMPTY(dDTNFI) .AND. DTOS(dDTNFI) > DTOS(EEM->EEM_DTNF)) .OR.;
                                      (! EMPTY(dDTNFF) .AND. DTOS(dDTNFF) < DTOS(EEM->EEM_DTNF)))
                *
                lOK := .F.
                EXIT
             ENDIF
             lOK := .T.
             EEM->(DBSKIP())
          ENDDO
          IF lOK
             // VERIFICANDO SE OS DADOS DOS ITENS ESTAO CORRETOS
             lOK := .F.
             EE9->(DBSETORDER(3))
             EE9->(DBSEEK(XFILIAL("EE9")+EEC->EEC_PREEMB))
             DO WHILE ! EE9->(EOF()) .AND.;
                EE9->(EE9_FILIAL+EE9_PREEMB) = (XFILIAL("EE9")+EEC->EEC_PREEMB)
                *
                IF EE9->(EMPTY(EE9_NRSD) .OR. EMPTY(EE9_RE)) .OR.;
                   (! EMPTY(dDTREI) .AND. DTOS(dDTREI) > DTOS(EE9->EE9_DTRE)) .OR.;
                   (! EMPTY(dDTREF) .AND. DTOS(dDTREF) < DTOS(EE9->EE9_DTRE))
                   *
                   lOK := .F.
                   EXIT
                ENDIF
                lOK := .T.
                EE9->(DBSKIP())
             ENDDO
             IF lOK
                WRK->(DBSETORDER(1))
                IF ! (WRK->(DBSEEK(EEC->EEC_PREEMB)))
                   SA1->(DBSETORDER(1))
                   SA1->(DBSEEK(XFILIAL("SA1")+EEC->EEC_IMPORT))
                   M->EEC_STATUS := EEC->EEC_STATUS
                   WRK->(DBAPPEND())
                   WRK->WRK_FLAG   := cMARCA
                   WRK->WRK_ENVIO  := IF(EEC->EEC_PREEMB="1",STR0048,STR0049) //"Sim"###"Nao"
                   WRK->EEC_PREEMB := EEC->EEC_PREEMB
                   WRK->EEC_DTEMBA := EEC->EEC_DTEMBA
                   WRK->EEC_DTPROC := EEC->EEC_DTPROC
                   WRK->WRK_STATUS := DSCSITEE7(,"E")
                   WRK->WRK_IMPORT := SA1->(ALLTRIM(A1_COD)+"-"+A1_NOME)
                ENDIF
             ELSEIF ! EMPTY(cPREEMB)
                    MSGINFO(STR0050+ALLTRIM(cPREEMB)+".",STR0016) //"Verifique se todos os itens do processo estao com numero de RE e SD preenchidos. Processo "###"Atencao"
             ENDIF
          ELSEIF ! EMPTY(cPREEMB)
                 MSGINFO(STR0051+ALLTRIM(cPREEMB)+STR0052,STR0016) //"Existe alguma nota fiscal faltando informacoes. Processo "###". Verifique !"###"Atencao"
          ENDIF
       ENDIF
       EEC->(DBSKIP())
    ENDDO
    IF n3 = 2
       EEC->(DBSETORDER(8)) // FORNECEDOR
       EEC->(DBSEEK(XFILIAL("EE9")+AVKEY(cESTAB,"EEC_FORN")))
       cCOND := "EEC->(EEC_FILIAL+EEC_FORN) = (XFILIAL('EEC')+AVKEY(cESTAB,'EEC_FORN'))"
    ENDIF
NEXT
RETURN(NIL)
*--------------------------------------------------------------------
STATIC FUNCTION PEM47TMP()
LOCAL n1,;
      aNRSD  := {},;
      aESTRU := {{"TMP_SERIE" ,"C",05,0},;
                 {"TMP_NOTA"  ,"C",06,0},;
                 {"TMP_DTNF"  ,"C",08,0},;
                 {"TMP_RE"    ,"C",12,0},;
                 {"TMP_SD"    ,"C",11,0},;
                 {"TMP_PREEMB","C",AVSX3("EEC_PREEMB",AV_TAMANHO),0}}
*
PROCREGUA(WRK->(LASTREC()))
// CRIA/GRAVA O TMP P/ GERAR O TXT
cTMPFILE := E_CRIATRAB(,aESTRU,"TMP")
WRK->(DBGOTOP())
DO WHILE ! WRK->(EOF())
   IF ! EMPTY(WRK->WRK_FLAG)
      aNRSD := {}
      EE9->(DBSETORDER(3))
      EE9->(DBSEEK(XFILIAL("EE9")+WRK->EEC_PREEMB))
      DO WHILE ! EE9->(EOF()) .AND.;
         EE9->(EE9_FILIAL+EE9_PREEMB) = (XFILIAL("EE9")+WRK->EEC_PREEMB)
         *
         IF ASCAN(aNRSD,{|X|X[1] = EE9->EE9_NRSD}) = 0
            EE9->(AADD(aNRSD,{EE9_NRSD,EE9_RE}))
         ENDIF
         EE9->(DBSKIP())
      ENDDO
      FOR n1 := 1 TO LEN(aNRSD)
          EEM->(DBSETORDER(1))
          EEM->(DBSEEK(xFILIAL("EEM")+WRK->EEC_PREEMB))
          DO WHILE ! EEM->(EOF()) .AND.;
             EEM->(EEM_FILIAL+EEM_PREEMB) = (XFILIAL("EEM")+WRK->EEC_PREEMB)
             *
             If EEM->EEM_TIPONF == EEM_CP // By JPP 23/03/2006 - 17:30 - Nota fiscal complementar
                EEM->(DbSkip())
                Loop
             EndIf
             TMP->(DBAPPEND())
             TMP->TMP_SERIE  := EEM->EEM_SERIE
             TMP->TMP_NOTA   := STRZERO(VAL(LEFT(ALLTRIM(EEM->EEM_NRNF),6)),6,0)
             TMP->TMP_DTNF   := EEM->(STRZERO(DAY(EEM_DTNF),2,0)+STRZERO(MONTH(EEM_DTNF),2,0)+STRZERO(YEAR(EEM_DTNF),4,0))
             TMP->TMP_RE     := STRZERO(VAL(aNRSD[n1,2]),12,0)
             TMP->TMP_SD     := STRZERO(VAL(LEFT(ALLTRIM(aNRSD[n1,1]),11)),11,0)
             TMP->TMP_PREEMB := WRK->EEC_PREEMB
             EEM->(DBSKIP())
          ENDDO
      NEXT
   ENDIF
   INCPROC()
   WRK->(DBSKIP())
ENDDO
RETURN(NIL)
*--------------------------------------------------------------------
STATIC FUNCTION PEM47TXT()
// GERA O TXT
PROCREGUA(TMP->(LASTREC()))
TMP->(DBGOTOP())
DO WHILE ! TMP->(EOF())
   TMP->(FWRITE(nHANDLE,cMODELO+TMP_SERIE+TMP_NOTA+;
                        TMP_DTNF+TMP_RE+TMP_SD+ENTER))
   EEC->(DBSETORDER(1))
   EEC->(DBSEEK(XFILIAL("EEC")+TMP->TMP_PREEMB))
   EEC->(RECLOCK("EEC",.F.))
   EEC->EEC_IN86 := "2"
   INCPROC()
   TMP->(DBSKIP())
ENDDO
RETURN(NIL)
*--------------------------------------------------------------------
