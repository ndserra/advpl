#INCLUDE "Eicpo558.ch"
#include "Average.ch"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçao    : EICPO558 - Autor - AVERAGE / A.W.R.        Data : 25.11.99 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descricao : Emissao da Comercial Invoice.                              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   : EICPO558()                                                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      : SIGAEIC - PROTHEUS                                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 24/11/99
#include "AvPrint.ch"

#DEFINE  DATA_SISTEMA    UPPER( CMONTH( dDataBase ) )  + ", " + ;
                         STRZERO( DAY( dDataBase ), 2 )+ ", " + ;
                         STR(YEAR( dDataBase ), 4 )

#xtranslate :TIMES_NEW_ROMAN_12            => \[1\]
#xtranslate :TIMES_NEW_ROMAN_14_BOLD       => \[2\]
                         
*---------------------------*
User Function Eicpo558()
*---------------------------*


nLinha := 0
nSpread:=0
If ExistBlock("EICPO57S")
   ExecBlock("EICPO57S",.f.,.f.)
Endif

WHILE .T.
  nPage := 0
  lpDop := .f.
  lpPag := .T.
  cHouse     := SPACE(LEN(SW6->W6_HAWB))
  dImpressao := dDATABASE
  aMsgs      := { Space(45), Space(45), Space(45), Space(45), Space(45) }
  
  cMsg:= Space(AVSX3("Y7_COD", AV_TAMANHO))  // TDF - 08/06/10

  DEFINE MSDIALOG oDlg TITLE "Emissão da Commercial Invoice" FROM 8, 0 TO  30, 80 //"Emissão da Comercial Invoice"

  nLin   := 30.5
  nCol   := 10.0
  nOpcao := 0

  @ nLin , nCol       SAY "Processo" SIZE  35, 8 
  @ nLin , nCol+40.0  GET cHouse  F3 "SW6" PICTURE "@!" VALID PO558Val() SIZE  70, 8 // - BHF

  @ nLin , nCol+120.0 SAY STR0003          SIZE  35, 8 //"Dt. Impressão"

  @ nLin , nCol+160.0 GET dImpressao        SIZE  45, 8

  nLin := nLin + 25
  @ nLin , nCol       SAY STR0004          SIZE  35, 8 //"Observação"

  @ nLin , nCol+40.0 GET aMsgs[1]          SIZE 230,20
  nLin := nLin + 12
  @ nLin , nCol+40.0 GET aMsgs[2]          SIZE 230,20
  nLin := nLin + 12
  @ nLin , nCol+40.0 GET aMsgs[3]          SIZE 230,20
  nLin := nLin + 12
  @ nLin , nCol+40.0 GET aMsgs[4]          SIZE 230,20
  nLin := nLin + 12
  @ nLin , nCol+40.0 GET aMsgs[5]          SIZE 230,20
  
  // TDF - 08/06/10
  nLin := nLin + 25 
  @ nLin , nCol      SAY "Mensagem"     SIZE 35,8 PIXEL //"Mensagem"
  
  @ nLin , nCol+40.0 MSGET cMsg F3 "SY7" SIZE 33,8 OF oDlg PIXEL    

  DEFINE SBUTTON FROM 20,260 TYPE 6 ACTION (nOpcao:=1,oDlg:End()) ENABLE OF oDlg PIXEL

  bOk    := {||If( PO558Val(), (nOpcao:=1,oDlg:End()) , ) }
  bCancel:= {||nOpcao:=0,oDlg:End()}

  ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED

  If nOpcao == 1
     Processa({|| PO558Relatorio()},STR0005) //"Processando Relatorio..."
     LOOP
  Endif
  EXIT
ENDDO

RETURN NIL
//--------------------------------------------------------------------------------------
Static FUNCTION PO558Val()
//--------------------------------------------------------------------------------------
  If Empty( cHouse )
     Help("", 1, "AVG0000117")
     Return .F.
  Endif

  SW6->( DbSetOrder( 1 ) ) 
  If !SW6->( DbSeek( xFilial("SW6")+cHouse ) ) 
     Help("", 1, "AVG0000118")
     Return .F.
  Endif

Return .T.

*--------------------------------------------------------------------------------------
Static FUNCTION Po558Relatorio()
*--------------------------------------------------------------------------------------
Local W:=0, I:=0, X:=0, Y:=0, Z:=0
Local cMoeDolar:=GETMV("MV_SIMB2",,"US$")
mDescri:=''
aVetLI:={}
nNetWeight :=0
aVetor:={}
aPgis:={}
nFob_Tot:= 0
nPari_1:= 0
lComissaoRetida:=.F.
nVal_Com:=SW2->W2_VAL_COM
lLooping := .T.

nInvoice:=GetMv("MV_INVOICE")
cTexto:=""
cEndeImport:=""

nLi_Ini  := 0
nLi_Fim  := 0
nLi_Fim2 := 0
//---------> Invoices (Itens).
SW9->(DbSetOrder(3))
SW9->( DbSeek( xFilial("SW9")+SW6->W6_HAWB ) )  //Declaracao
SW8->(DbSetOrder(1))
SW8->( DbSeek( xFilial("SW8")+SW6->W6_HAWB ) )

//---------> P.O. (Capa).
SW2->(DbSetOrder(1))
SW2->( DbSeek( xFilial("SW2")+SW8->W8_PO_NUM) ) //It_Declaracao

//---------> Importador.
SYT->(DbSetOrder(1))
SYT->( DbSeek( xFilial("SYT")+SW2->W2_IMPORT ) ) //Pedidos

//---------> País.
SYA->(DbSetOrder(1))
SYA->(Dbseek( xFilial("SYA")+SYT->YT_PAIS))  //TRP-03/09/07
cEndeImport := cEndeImport + If( !Empty(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+" - ", "")
cEndeImport := cEndeImport + If( !Empty(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO)+" - ", "")
cEndeImport := cEndeImport + If( !Empty(SYT->YT_PAIS  ), ALLTRIM(SYA->YA_PAIS_I  )+" - ", "")
cEndeImport := Left( cEndeImport, Len( cEndeImport ) )

//---------> Condicao de pagamento.
IF ! EMPTY(ALLTRIM(SW2->W2_COND_EX))
   SY6->( DbSeek( xFilial("SY6")+SW2->W2_COND_EX+STR(SW2->W2_DIAS_EX,3,0) ) )
ELSE
   SY6->( DbSeek( xFilial("SY6")+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0) ) )
ENDIF

//---------> Textos.
cTexto :=MSMM( SY6->Y6_DESC_I,AVSX3("Y6_VM_DESI",03) )
STRTRAN( cTexto,CHR(13)+ CHR(10)," " )

SA2->(DbSetOrder(1))
SB1->(DbSetOrder(1))
SA5->(DbSetOrder(3))
SWP->(DbSetOrder(1))

Begin Sequence

//*** GFP 16/06/2011 :: 11h37 - Verifica se há Invoices cadastradas 
SW9->( DbSetOrder(3) )
If !SW9->( DbSeek( xFilial("SW9")+SW6->W6_HAWB ) )  //Declaracao  
   MsgAlert("Não há Invoice(s) cadastrada(s) para este processo.","Atenção")
   Break
EndIf
//*** Fim GFP

AVPRINT oPrn NAME STR0009 //"Commercial Invoice"

   ProcRegua(5+SW7->(LASTREC()))

   //                              Font            W  H  Bold          Device
   oFont1 := oSend(TFont(),"New","Times New Roman",0,10,,.F.,,,,,,,,,,,oPrn )
   oFont2 := oSend(TFont(),"New","Times New Roman",0,14,,.T.,,,,,,,,,,,oPrn )

   aFontes := { oFont1, oFont2 } 
   
  AVPAGE
  IncProc( STR0010 ) //"Imprimindo..."
    
    // *** - BHF - 22/10/2008 - Novo Tratamento para Invoice/Moeda 
    
    SW9->( DbSetOrder(3) )
    SW9->( DbSeek( xFilial("SW9")+SW6->W6_HAWB ) )  //Declaracao  
                
    Do while ! SW9->(EOF()) .AND. SW9->W9_FILIAL == xFilial("SW9") .AND. SW9->W9_HAWB == cHouse    
       
       lLooping := .T.
       
       IF EMPTY(SW6->W6_NR_PRO)
          nInvoice := nInvoice + 1
       ELSE
          nInvoice:=VAL(SW6->W6_NR_PRO)
       ENDIF
       PO558CAB_INI()
       nLinha := nLinha - 90

       SY9->(DBSETORDER(2))
       SY9->(DBSEEK(xFilial("SY9")+ SW2->W2_DEST))
       nLinha := nLinha + 50

       oPrn:Say( nLinha , 110 , STR0011 + SY9->Y9_DESCR,aFontes:TIMES_NEW_ROMAN_12  ) //"DISCHARGE PORT.: "
       SY9->(DBSETORDER(1))

       nLinha := nLinha + 90

       nLi_Ini := nLinha

       PO558_CAB2()

       nFob_Tot:= 0
       nPari_1 := 0
               
	   If SW8->(!DbSeek(xFilial("SW8")+cHouse+SW9->W9_INVOICE+SW9->W9_FORN))
          Exit
       EndIf
       
       Do while ! SW8->(EOF()) .AND. SW8->W8_FILIAL == xFilial("SW8") .AND. SW8->W8_INVOICE == SW9->W9_INVOICE .AND. SW8->W8_FORN == SW9->W9_FORN
       
          IncProc(STR0010) //"Imprimindo..."

          If !Empty( SW8->W8_PGI_NUM )
             If SubStr(Alltrim(SW8->W8_PGI_NUM),1,1) #"*"
                Aadd( aPgis, ALLTRIM(SW8->W8_PGI_NUM) )
             Endif
          Endif
           
          nLi_Fim:=nLinha
          PO558VerFim(1)

          SW2->(DBSEEK(xFilial("SW2")+SW8->W8_PO_NUM ) )
          SB1->(DBSEEK(xFilial("SB1")+SW8->W8_COD_I))
          SA5->(DBSEEK(xFilial("SA5")+SW8->W8_COD_I+SW8->W8_FABR+SW8->W8_FORN))
          SYG->(DBSEEK(xFilial("SYG")+SW2->W2_IMPORT+SW8->W8_FABR+SW8->W8_COD_I))
          mDescri := ''
          mDescri := MSMM(SB1->B1_DESC_I,AVSX3("B1_VM_GI",03))
          STRTRAN(mDescri,CHR(13)+CHR(10)," ")
           
           
           

          nLinha := nLinha + 20
           
          oPrn:Say( nLinha ,430  ,TRANS(SW8->W8_QTDE,AVSX3("W8_QTDE",6)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
          oPrn:Say( nLinha ,500  ,MEMOLINE(mDescri,35,1),aFontes:TIMES_NEW_ROMAN_12)
          oPrn:Say( nLinha ,1710 ,trans(SW8->W8_PRECO*SW2->W2_PARID_U,AVSX3("W8_PRECO",6)),aFontes:TIMES_NEW_ROMAN_12,,,,1)
          oPrn:Say( nLinha ,2180 ,trans(SW8->W8_QTDE*(SW8->W8_PRECO*SW2->W2_PARID_U),AVSX3("W8_PRECO",6)),aFontes:TIMES_NEW_ROMAN_12,,,,1)

          nFob_Tot := nFob_Tot + ( SW8->W8_QTDE*(SW8->W8_PRECO*SW2->W2_PARID_U) )

          IF EMPTY(nPari_1)
             nPari_1:= SW2->W2_PARID_U
          ENDIF
          nNetWeight := nNetWeight + (SW8->W8_QTDE*W5Peso() )// FCD 04/07/01

          FOR W:=2 TO MLCOUNT(mDescri,35)//(LEN(mDescri)/30)+1
              IF ! EMPTY(memoline(mDescri,35,W))
                 nLinha := nLinha + 50
                                              nLi_Fim:=nLinha  
                 PO558VerFim(1)
                 oPrn:Say( nLinha,500  ,memoline(mDescri,35,W), aFontes:TIMES_NEW_ROMAN_12,,,1)
              ENDIF
          NEXT

          If SW3->(FieldPos("W3_PART_N")) # 0  //ASK 08/10/2007
             SW3->(DbSetOrder(8))
             SW3->(DbSeek(xFilial("SW3") + SW8->W8_PO_NUM + SW8->W8_POSICAO))
             nLinha := nLinha + 50
             nLi_Fim:=nLinha
             PO558VerFim(1)
             If  !EMPTY(SW3->W3_PART_N) 
                oPrn:Say( nLinha ,500 ,ALLTRIM(SW3->W3_PART_N), aFontes:TIMES_NEW_ROMAN_12,,,1)
             Else
                oPrn:Say( nLinha ,500 ,ALLTRIM(SA5->A5_CODPRF), aFontes:TIMES_NEW_ROMAN_12,,,1)                 
             EndIf   
          Else
             IF ! EMPTY(ALLTRIM(SA5->A5_CODPRF))
                nLinha := nLinha + 50
                nLi_Fim:=nLinha
                PO558VerFim(1)
                oPrn:Say( nLinha ,500 ,ALLTRIM(SA5->A5_CODPRF), aFontes:TIMES_NEW_ROMAN_12,,,1)
             ENDIF
          EndIf   
          IF ! EMPTY(ALLTRIM(SA5->A5_PARTOPC))
             nLinha := nLinha + 50
             nLi_Fim:=nLinha 
             PO558VerFim(1)
             oPrn:Say( nLinha ,500 ,MEMOLINE(ALLTRIM(SA5->A5_PARTOPC),36,1), aFontes:TIMES_NEW_ROMAN_12,,,1)
             nLinha := nLinha + 50
             nLi_Fim:=nLinha
             PO558VerFim(1)
             oPrn:Say( nLinha ,500 ,MEMOLINE(ALLTRIM(SA5->A5_PARTOPC),36,2), aFontes:TIMES_NEW_ROMAN_12,,,1)
          ENDIF
          IF ! EMPTY(ALLTRIM(SYG->YG_REG_MIN))
             nLinha := nLinha + 50
             nLi_Fim:=nLinha
             PO558VerFim(1)
             oPrn:Say( nLinha ,500 ,ALLTRIM(SYG->YG_REG_MIN), aFontes:TIMES_NEW_ROMAN_12,,,1)
          ENDIF

          nLinha := nLinha + 50
          nLi_Fim:=nLinha
          PO558VerFim(1)
          oPrn:Say( nLinha,500  ,STR0025+alltrim(trans(SW8->W8_QTDE*W5Peso(),AVSX3("W6_PESO_BR",6)+STR0013)), aFontes:TIMES_NEW_ROMAN_12) //"PESO LIQUIDO: "###" KGS" //FCD 04/07/01  //ASR 27/01/2006 - AVSX3("B1_PESO",6)
          nLinha := nLinha + 50
          oPrn:Line( nLinha , 110, nLinha  , 2240 )
          oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )

          IF ASCAN(aVetor,SW8->W8_FABR) == 0
             AADD(aVetor,SW8->W8_FABR)
          ENDIF

          SWP->(DBSEEK(xFilial("SWP")+SW8->W8_PGI_NUM+SW8->W8_SEQ_LI))

          IF ! SWP->(EOF()) .AND. ASCAN(aVetLI,{|x| x[1] == SWP->WP_REGIST }) == 0
             AADD(aVetLI,{SWP->WP_REGIST,SWP->WP_ENV_ORI,SWP->WP_VENCTO})
          ENDIF
          SW8->(DBSKIP())
       
       EndDo
       
       lpDop := .T.
       nLi_Fim:=nLinha
       PO558VerFim(2)
       nLinha := nLinha + 20
       oPrn:Say( nLinha , 130  ,STR0014, aFontes:TIMES_NEW_ROMAN_12) //"VALUE TOTAL"
       oPrn:Say( nLinha ,2180 ,trans(nFob_Tot,AVSX3("W9_FOB_TOT",6)), aFontes:TIMES_NEW_ROMAN_12 ,,,,1)
       PO558VerFim(2)
       nLinha := nLinha + 50
       oPrn:Say( nLinha   , 130  ,STR0015, aFontes:TIMES_NEW_ROMAN_12  ) //"INTERNATIONAL FREIGHT"
       //oPrn:Say( nLinha   ,2180 ,trans(SW6->W6_FRETEIN * nPari_1 ,AVSX3("W6_FRETEIN",6)), aFontes:TIMES_NEW_ROMAN_12 ,,,,1)
       oPrn:Say( nLinha   ,2180 ,trans(If(SW9->W9_FREINC $ cNao,SW9->W9_FRETEIN,0),AVSX3("W9_FRETEIN",6)), aFontes:TIMES_NEW_ROMAN_12 ,,,,1)  //TRP-18/02/08   // GFP - 02/08/2013
       //nFob_Tot := nFob_Tot + SW6->W6_FRETEIN * nPari_1
       nFob_Tot := nFob_Tot + If(SW9->W9_FREINC $ cNao,SW9->W9_FRETEIN,0)  //TRP-18/02/08    // GFP - 02/08/2013
       PO558VerFim(2)

       nLinha := nLinha + 50
       oPrn:Say( nLinha , 130  ,STR0016, aFontes:TIMES_NEW_ROMAN_12  ) //"FREIGHT"
       //oPrn:Say( nLinha ,2180 ,trans(SW6->W6_INLAND * nPari_1 ,AVSX3("W6_INLAND",6)), aFontes:TIMES_NEW_ROMAN_12 ,,,,1)
       oPrn:Say( nLinha ,2180 ,trans(SW9->W9_INLAND,AVSX3("W9_INLAND",6)), aFontes:TIMES_NEW_ROMAN_12 ,,,,1) //TRP-18/02/08
       //nFob_Tot := nFob_Tot + SW6->W6_INLAND * nPari_1
       nFob_Tot := nFob_Tot + SW9->W9_INLAND  //TRP-18/02/08
       PO558VerFim(2)
       nLinha := nLinha + 50
       oPrn:Say( nLinha , 130  ,STR0017, aFontes:TIMES_NEW_ROMAN_12 ) //"PACKING"
       //oPrn:Say( nLinha ,2180 ,trans(SW6->W6_PACKING * nPari_1 ,AVSX3("W6_PACKING",6)), aFontes:TIMES_NEW_ROMAN_12 ,,,,1)
       oPrn:Say( nLinha ,2180 ,trans(SW9->W9_PACKING,AVSX3("W9_PACKING",6)), aFontes:TIMES_NEW_ROMAN_12 ,,,,1)  //TRP-18/02/08
       //nFob_Tot := nFob_Tot + SW6->W6_PACKING * nPari_1
       nFob_Tot := nFob_Tot + SW9->W9_PACKING  //TRP-18/02/08
       PO558VerFim(2)
       nLinha := nLinha + 50
       oPrn:Say( nLinha , 130  ,STR0018, aFontes:TIMES_NEW_ROMAN_12 ) //"DISCOUNT"
       //oPrn:Say( nLinha ,2180 ,trans(SW6->W6_DESCONT * nPari_1 ,AVSX3("W6_DESCONT",6)), aFontes:TIMES_NEW_ROMAN_12,,,,1)
       oPrn:Say( nLinha ,2180 ,trans(SW9->W9_DESCONT,AVSX3("W9_DESCONT",6)), aFontes:TIMES_NEW_ROMAN_12,,,,1)  //TRP-18/02/08
       //nFob_Tot := nFob_Tot - SW6->W6_DESCONT * nPari_1
       nFob_Tot := nFob_Tot - SW9->W9_DESCONT  //TRP-18/02/08 
       PO558VerFim(2)
       nLinha := nLinha + 50
       oPrn:Say( nLinha , 130  ,STR0019+ALLTRIM(BuscaIncoterm())+STR0020, aFontes:TIMES_NEW_ROMAN_12 ) //"TOTAL "###" VALUE"
       oPrn:Say( nLinha ,2180 ,trans(nFob_Tot,AVSX3("W9_FOB_TOT" ,6)), aFontes:TIMES_NEW_ROMAN_12,,,,1)
       nLi_Fim2:=(nLinha+50)
       PO558FIM()

       IncProc(STR0010) //"Imprimindo..."
       PO558VerFim(0)
       nLinha := nLinha + 90
       oPrn:Say( nLinha     ,110  ,STR0021, aFontes:TIMES_NEW_ROMAN_12 ) //"IMPORT LICENSE: "
       oPrn:Say( nLinha     ,550  ,STR0022, aFontes:TIMES_NEW_ROMAN_12 ) //"L.I."
       oPrn:Say( nLinha     ,1000 ,STR0023, aFontes:TIMES_NEW_ROMAN_12 ) //"ISSUED"
       oPrn:Say( nLinha     ,1300 ,STR0024, aFontes:TIMES_NEW_ROMAN_12 ) //"VALID"

       FOR X:=1 TO LEN(aVetLI)
           PO558VerFim(0)
           nLinha := nLinha + 50
           oPrn:Say( nLinha     ,550 , aVetLI[X,1], aFontes:TIMES_NEW_ROMAN_12  )
           oPrn:Say( nLinha     ,1000, DTOC(aVetLI[X,2]), aFontes:TIMES_NEW_ROMAN_12 )
           oPrn:Say( nLinha     ,1300, DTOC(aVetLI[X,3]), aFontes:TIMES_NEW_ROMAN_12 )
       NEXT

       //PO558VerFim(0)
       //nLinha := nLinha + 90
       //oPrn:Say( nLinha ,110  ,STR0025+ trans(nNetWeight,AVSX3("W6_PESO_BR",6))+STR0013, aFontes:TIMES_NEW_ROMAN_12) //"NET WEIGHT: "###" KGS"  //ASR 27/01/2006 - AVSX3("B1_PESO",6)
       PO558VerFim(0)
       nLinha := nLinha + 90
       oPrn:Say( nLinha ,110  ,STR0027, aFontes:TIMES_NEW_ROMAN_12) //"PRODUCER(S)"

       FOR I:=1 TO LEN(aVetor)
           SA2->(DBSEEK(xFILIAL("SA2")+aVetor[I]))
           PO558VerFim(0)
           nLinha := nLinha + 70
           oPrn:Say( nLinha ,110  ,SA2->A2_NOME, aFontes:TIMES_NEW_ROMAN_12)
           PO558VerFim(0)
           nLinha := nLinha + 50
           oPrn:Say( nLinha ,110  ,SA2->A2_END, aFontes:TIMES_NEW_ROMAN_12 )
           PO558VerFim(0)
           IF ! (EMPTY(ALLTRIM(SA2->A2_MUN)) .AND. EMPTY(ALLTRIM(SA2->A2_EST)))
              nLinha := nLinha + 50
              oPrn:Say( nLinha ,110  ,ALLTRIM(SA2->A2_MUN)+IF(EMPTY(ALLTRIM(SA2->A2_EST)).OR.EMPTY(ALLTRIM(SA2->A2_MUN)),'',' / ')+SA2->A2_EST,aFontes:TIMES_NEW_ROMAN_12 )
              PO558VerFim(0)
           ENDIF
           IF ! (EMPTY(Alltrim(SA2->A2_BAIRRO)) .AND. EMPTY(ALLTRIM(SA2->A2_ESTADO)))
              nLinha := nLinha + 50
              oPrn:Say( nLinha ,110  ,Alltrim(SA2->A2_BAIRRO)+IF(EMPTY(ALLTRIM(SA2->A2_ESTADO)).OR.EMPTY(Alltrim(SA2->A2_BAIRRO)),'',' / ')+SA2->A2_ESTADO,aFontes:TIMES_NEW_ROMAN_12 )
              PO558VerFim(0)
           ENDIF
           IF ! EMPTY(ALLTRIM(SA2->A2_CEP))
              nLinha := nLinha + 50
              oPrn:Say( nLinha ,110  ,TRANS(SA2->A2_CEP,'@R 99999-999' ),aFontes:TIMES_NEW_ROMAN_12 )
           ENDIF
       NEXT

       IncProc(STR0010) //"Imprimindo..."

       SA2->(DBSEEK(xFilial("SA2")+SW2->W2_FORN))
       PO558VerFim(0)
       nLinha := nLinha + 90
       oPrn:Say( nLinha ,110  ,STR0028,aFontes:TIMES_NEW_ROMAN_12) //"AGENT IN BRAZIL"

       IF EMPTY(SA2->A2_REPRES)
          nLinha := nLinha + 50
          oPrn:Say( nLinha ,110  ,STR0029,aFontes:TIMES_NEW_ROMAN_12) //"*** NONE ***"
       ELSE
          lComissaoRetida:=.T.
          nLinha := nLinha + 50
          oPrn:Say( nLinha ,110 , SA2->A2_REPRES,aFontes:TIMES_NEW_ROMAN_12)
          IF ! EMPTY(SA2->A2_REPR_EN)
             nLinha := nLinha + 50
             oPrn:Say( nLinha ,110 , SA2->A2_REPR_EN + IF(!EMPTY(SA2->A2_REPBAIR)," - "+ALLTRIM(SA2->A2_REPBAIR)," ");
             ,aFontes:TIMES_NEW_ROMAN_12)
          ENDIF
       ENDIF
       PO558VerFim(0)
       nLinha := nLinha + 90
       oPrn:Say( nLinha ,110  ,STR0030, aFontes:TIMES_NEW_ROMAN_12) //"AGENT'S COMMISSION"

       IF SW2->W2_COMIS #'S'
          nLinha := nLinha + 50
          oPrn:Say( nLinha ,110  ,STR0029, aFontes:TIMES_NEW_ROMAN_12) //"*** NONE ***"
       ELSE
          IF SW2->W2_TIP_COM == '1'
             nLinha := nLinha + 50
             oPrn:Say( nLinha ,110 , trans(SW2->W2_PER_COM,"@ 9,999.99")+'%', aFontes:TIMES_NEW_ROMAN_12 )
          ELSEIF SW2->W2_TIP_COM $ '2,3'
             If SW2->W2_MOEDA # cMoeDolar
                nVal_Com := ( SW2->W2_VAL_COM * SW2->W2_PARID_U )
             EndIf
             nLinha := nLinha + 50
             oPrn:Say( nLinha ,110 ,cMoeDolar+trans(nVal_Com,AVSX3("W2_VAL_COM",6)),aFontes:TIMES_NEW_ROMAN_12 )
          ELSEIF SW2->W2_TIP_COM == '4'
             nLinha := nLinha + 50
             oPrn:Say( nLinha ,110 , SW2->W2_OUT_COM, aFontes:TIMES_NEW_ROMAN_12 )
          ENDIF

       ENDIF

       IncProc(STR0010) //"Imprimindo..."
       PO558VerFim(0)
       nLinha := nLinha + 90
       oPrn:Say( nLinha ,110 , STR0031, aFontes:TIMES_NEW_ROMAN_12) //"CERTIFIED TRUE AND CORRECT."
       
       //ISS - 21/05/10 - Inclusão do valor total em "extenso", por exemplo, 100R$ -> Cem reais
       PO558VerFim(0)
       nLinha := nLinha + 90   
       oPrn:Say( nLinha , 110 ,STR0019+ALLTRIM(BuscaIncoterm())+STR0020+" : ", aFontes:TIMES_NEW_ROMAN_12 )
       oPrn:Say( nLinha , 380 ,Upper(ExtPlusE(val(trans(nFob_Tot,AVSX3("W9_FOB_TOT" ,6))),"US$")), aFontes:TIMES_NEW_ROMAN_12)
       
       IF ! EMPTY(aMsgs[1]+aMsgs[2]+aMsgs[3]+aMsgs[4]+aMsgs[5])
          nLinha := nLinha + 90
          oPrn:Say( nLinha, 110 , 'REMARKS:', aFontes:TIMES_NEW_ROMAN_12)
          FOR Y:=1 TO 5
              IF ! EMPTY(aMsgs[Y])
                 oPrn:Say( nLinha, 330, aMsgs[Y], aFontes:TIMES_NEW_ROMAN_12)
                 nLinha := nLinha + 50
                 PO558VerFim(0)
              ENDIF
          NEXT
       ENDIF
       
       // TDF - 08/06/10
       IF ! Empty(cMsg)
          nLinha := nLinha + 90
          oPrn:Say( nLinha, 110 , 'REMARKS:', aFontes:TIMES_NEW_ROMAN_12)
          DbSeek(xFilial("SY7")+cMsg)
          For Z:= 1 To MLCOUNT(MSMM(SY7->Y7_TEXTO,60)) //DFS - 05/02/11 - Tratamento para imprimir todas as linhas do campo de mensagem.
	          cMsg:= MSMM(SY7->Y7_TEXTO,60,Z)
	          oPrn:Say( nLinha, 330, cMsg, aFontes:TIMES_NEW_ROMAN_12)
	          nLinha := nLinha + 50
          Next
          PO558VerFim(0)

       ENDIF

       IF ! EMPTY(SW2->W2_EXPORTA) .AND. !EICEmptyLJ("SW2","W2_EXPLOJ")  //TRP-03/09/07
          SA2->(DBSEEK(xFilial("SA2")+SW2->W2_EXPORTA+EICRetLoja("SW2","W2_EXPLOJ")))
          PO558VerFim(0)
          nLinha := nLinha + 120
          oPrn:Say( nLinha ,1200 , ALLTRIM(SA2->A2_NOME) ,aFontes:TIMES_NEW_ROMAN_12,,,,2)
          PO558VerFim(0)
          nLinha := nLinha + 50
          oPrn:Say( nLinha ,1200 , STR0032, aFontes:TIMES_NEW_ROMAN_12,,,,2) //"Correspondence Address"
          PO558VerFim(0)
          nLinha := nLinha + 50
          oPrn:Say( nLinha ,1200 , ALLTRIM(SA2->A2_END)+','+ALLTRIM(SA2->A2_NR_END)+'-'+ALLTRIM(SA2->A2_BAIRRO)+'-'+ALLTRIM(SA2->A2_MUN)+'/'+ALLTRIM(SA2->A2_ESTADO),aFontes:TIMES_NEW_ROMAN_12,,,,2)

          IncProc(STR0010) //"Imprimindo..."
       ENDIF
       SW9->(dbskip())
	   IF !SW9->(eof()) .AND. SW9->W9_HAWB == cHouse
          nLinha := 2901
          PO558VerFim(0)       
       ENDIF
    ENDDO          
    AVENDPAGE
       

                                     
AVENDPRINT

oFont1:End()
oFont2:End()


SETMV("MV_INVOICE",ALLTRIM(STR(nInvoice)))


cAlias:=ALIAS()

Reclock("SW6",.F.)

IF EMPTY(SW6->W6_NR_PRO)
   SW6->W6_NR_PRO := ALLTRIM(STR(nInvoice))
ENDIF
DBSELECTAREA(cAlias)
SA5->(DbSetOrder(1))

End Sequence

RETURN NIL

*--------------------------------------------------------------------------------------
Static FUNCTION PO558VerFim(PARTE2)
*--------------------------------------------------------------------------------------

IF nLinha >= 2900
   IF PARTE2 > 0
      IF PARTE2 == 1
         nLi_Fim2:=nLinha
      ELSE
         nLi_Fim2:=(nLinha+50)
      ENDIF
      PO558FIM()
   ENDIF

   AVNEWPAGE

   PO558CAB_INI()

   IF PARTE2 > 0
     nLi_fim:=nLi_Ini:=930

     IF !lpDop

        PO558_CAB2()

     ELSE
        oPrn:Line( nLinha+20, 110, nLinha+20  , 2240 )
     ENDIF

   ENDIF
   RETURN .T.
ENDIF


RETURN .F.
*--------------------------------------------------------------------------------------
Static FUNCTION PO558_CAB2()
*--------------------------------------------------------------------------------------

oPrn:Line( nLinha , 110, nLinha  , 2240 )
oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )
oPrn:Box( nLinha     , 110 , nLinha+60 , 111 )
oPrn:Box( nLinha     , 450 , nLinha+60 , 451  ) //370
oPrn:Box( nLinha     , 1400, nLinha+60 , 1401 )
oPrn:Box( nLinha     , 1750, nLinha+60 , 1751 )
oPrn:Box( nLinha     , 2240, nLinha+60 , 2241 )
nLinha := nLinha + 10
oPrn:Say( nLinha     , 180 ,STR0033,aFontes:TIMES_NEW_ROMAN_12 ) //"QTD."
oPrn:Say( nLinha     , 650 ,STR0034 ,aFontes:TIMES_NEW_ROMAN_12) //"DESCRIPTION"
oPrn:Say( nLinha     , 1480,STR0035+" "+SW9->W9_MOE_FOB ,aFontes:TIMES_NEW_ROMAN_12) //"UNIT" + Moeda
oPrn:Say( nLinha     , 1880,STR0036+" "+SW9->W9_MOE_FOB ,aFontes:TIMES_NEW_ROMAN_12) //"TOTAL" + Moeda
nLinha := nLinha + 50
oPrn:Line( nLinha    , 110, nLinha  , 2240 ) 
oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )

RETURN NIL

*--------------------------------------------------------------------------------------
Static FUNCTION PO558FIM()
*--------------------------------------------------------------------------------------

oPrn:Box( nLi_Fim2, 110, nLi_Fim2+1, 2240)
oPrn:Box( nLi_Ini , 110, nLi_Fim2  , 111 )

oPrn:Box( nLi_Ini , 450 , IF(nLi_Fim==0,nLi_Fim2,nLi_Fim) , 451  )
oPrn:Box( nLi_Ini , 1400, IF(nLi_Fim==0,nLi_Fim2,nLi_Fim) , 1401 )

oPrn:Box( nLi_Ini , 1750, nLi_Fim2   , 1751 )
oPrn:Box( nLi_Ini , 2240, nLi_Fim2   , 2241 )

RETURN NIL
*--------------------------------------------------------------------------------------
Static FUNCTION PO558CAB_INI()
*--------------------------------------------------------------------------------------
LOCAL W:=0
nLinTexto:=0     

nPage := nPage + 1
nLinha:=100
//oPrn:oFont := aFontes:TIMES_NEW_ROMAN_12
SA2->(DBSEEK(xFilial("SA2")+SW2->W2_EXPORTA))
//oPrn:Say( nLinha, 110,SA2->A2_NOME, aFontes:TIMES_NEW_ROMAN_12)
oPrn:Say( nLinha, 1450,STR0009, aFontes:TIMES_NEW_ROMAN_14_BOLD ) //"COMMERCIAL INVOICE"
nLinha := nLinha + 90
oPrn:Box( nLinha     , 110  , nLinha+400, 1030 )

oPrn:Say( nLinha     , 1120 , STR0037 + ALLTRIM(STR(nInvoice)), aFontes:TIMES_NEW_ROMAN_12 ) //"REF.: INVOICE NUMBER "
nLinha := nLinha + 30
oPrn:Say( nLinha , 130  , memoline(SYT->YT_NOME,30,1), aFontes:TIMES_NEW_ROMAN_12 )
nLinha := nLinha + 20
oPrn:Say( nLinha , 1120 , STR0038 + DATA_SISTEMA, aFontes:TIMES_NEW_ROMAN_12 ) //"DATE: "
nLinha := nLinha + 30
oPrn:Say( nLinha , 130  , memoline(SYT->YT_NOME,30,2), aFontes:TIMES_NEW_ROMAN_12 )

oPrn:Say( nLinha+50 , 130  , memoline(SYT->YT_ENDE,30,1), aFontes:TIMES_NEW_ROMAN_12 )

oPrn:Say( nLinha+100 , 130  , memoline(SYT->YT_ENDE,30,2), aFontes:TIMES_NEW_ROMAN_12 )
oPrn:Say( nLinha+150 , 130  , ALLTRIM( cEndeImport ), aFontes:TIMES_NEW_ROMAN_12 )
oPrn:Say( nLinha+200 , 130  , TRANS(SYT->YT_CEP,'@R 99999-999' ), aFontes:TIMES_NEW_ROMAN_12 )
oPrn:Say( nLinha+250 , 130  , AVSX3("YT_CGC",5) +": " + Trans(SYT->YT_CGC,AVSX3("YT_CGC",6)), aFontes:TIMES_NEW_ROMAN_12 ) //"C.G.C.: "

oPrn:Say( nLinha := nLinha+20 , 1120 , STR0040, aFontes:TIMES_NEW_ROMAN_12 ) //"PAYMENT:"
W:=1
DO WHILE nLinTexto <= 6 .AND. W <= MLCOUNT(cTexto,40)

   IF !EMPTY(memoline(cTexto,40,W))
      oPrn:Say( nLinha, 1370 , memoline(cTexto,40,W), aFontes:TIMES_NEW_ROMAN_12 )
      nLinTexto := nLinTexto + 1
      nLinha := nLinha + 50
   ENDIF
   W := W + 1

ENDDO

nLinha := nLinha + (7-nLinTexto) * 50
nLinha := nLinha + 120
oPrn:Say( nLinha, 1450 , STR0041 + dtoc(SW6->W6_DT_EMB), aFontes:TIMES_NEW_ROMAN_12 ) //"SHIPPING DATE: "
nLinha := nLinha + 60
oPrn:Line( nLinha, 110, nLinha  , 2240 )
oPrn:Line( nLinha+1,  110, nLinha+1, 2240 )

nLinha := nLinha + 90
oPrn:Say( 3100 ,1900 , STR0042+STR(nPage), aFontes:TIMES_NEW_ROMAN_12 ) //"PAGE: "

RETURN NIL

