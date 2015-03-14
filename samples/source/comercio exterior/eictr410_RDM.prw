#include "avprint.ch"
#include "Average.ch"


#COMMAND E_RESET_AREA => Work->(E_EraseArq(cNomArq)) ;
                        ; DBSELECTAREA(nOldArea) ;
                        ; Return .F.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ EICTR410 ³ Autor ³ AVERAGE/REGINA H.PEREZ³ Data ³ 05.12.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ RELATORIO DIVERGENCIA PLI/EMBARQUE                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ EICTR410()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAEIC - GRADIENTE                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


USER FUNCTION EICTR410()     

LOCAL indice


PRIVATE TB_Campos:={{"WKHAWB",""   , "Processo"         } ,;
                  {"WKCOD_I",""   ,"Item",AVSX3('B1_COD',6)},;
                  {"WKPGI_NUM","" , "PLI"  ,AVSX3('W5_PGI_NUM',6)},;
                  {"WKSEQ_LI" ,"" ,"Seq."},; 
                  {"WKSUFRAMA","" , "No. Suframa"     } ,;
                  {"WKQTDE"  ,""  , "Qtde L.I."  ,AVSX3('W7_QTDE',6)     } ,;
                  {"WKQTDE_E",""  , "Qtde Embarcada",AVSX3('W7_QTDE',6)  } ,;
                  {"WKMSG"   ,""  , "Mensagem"        } }

PRIVATE aCampos := {"WKHAWB","WKCOD_I","WKPGI_NUM","WKSUFRAMA","WKQTDE","WKQTDE_E","WKMSG"}
        

PRIVATE aHeader[0],aDados:=Array(12)//,nUsado:=0
PRIVATE aSemSX3:={ { "WKHAWB"    , "C" , 17 , 0 } ,;   
               { "WKCOD_I"    , AVSX3("B1_COD",2),AVSX3("B1_COD",3),AVSX3("B1_COD",4)},;
               { "WKDESCR"    , "C" , 25 , 0 } ,;
               { "WKPGI_NUM"  , "C" , 10 , 0 } ,;
               { "WKSEQ_LI"   , "C" , 03 , 0 } ,;
               { "WKSUFRAMA"  , "C" , 10 , 0 } ,;
               { "WKQTDE"     , "N" , 13 , 3 } ,;
               { "WKQTDE_E"   , "N" , 13 , 3 } ,;
               { "WKMSG"      , "C" , 18 , 0 } }
Private cMarca := GetMark(), lInverte := .F.
R_Campos:={}
aPli :={}
nOldArea := SELECT()

cNomArq:=E_CriaTrab(,aSemSX3,"Work")
IndRegua("Work",cNomArq+OrdBagExt(),"WKHAWB+WKCOD_I")
aRCampos:= E_CriaRCampos(TB_Campos,"C")
aRcampos[1,3] := "C*" // PARA NÃO REPETIR O PROCESSO 
aDados:= {"Work",;
          "Este relat¢rio imprime as Divergências entre PLI e Embarque",;
          "",;
          "",;
          "M",;
          132,;
          "",;
          "",;
          "Relatório de Divergências",;  
          { "Zebrado", 1,"Importação", 1, 2, 1, "",1 } ,;
          "EICTR410",;
          {{|| .T. },{|| .T. } }}
cCadastro := "Relatório de Divergências"

PROCESSA({||TR410Grv()},"Processando")              
AEVAL(aPli,{|pli| TR410Pli(pli)})

WHILE .T.
      oMainWnd:ReadClientCoors()

//      DEFINE MSDIALOG oDlg TITLE cCadastro ;
  //       From oMainWnd:nTop+125,oMainWnd:nLeft+5 To oMainWnd:nBottom-60,oMainWnd:nRight-10 OF oMainWnd PIXEL
   DEFINE MSDIALOG oDlg TITLE cCadastro ;
       FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 TO oMainWnd:nBottom-60,oMainWnd:nRight - 10 ;
   	     OF oMainWnd PIXEL                          

   nOpca := 0
   DBSELECTAREA("Work")
   Work->(DBGOTOP())
   oMark:= MsSelect():New("Work",,,TB_Campos,@lInverte,@cMarca,{25,1,(oDlg:nHeight-30)/2,(oDlg:nClientWidth-4)/2})
//   DEFINE SBUTTON FROM 18,285 TYPE 6 ;
  //            ACTION (TR410Rel(aDados,aRCampos,oMark),oMark:oBrowse:Refresh()) ENABLE OF oDlg
   ACTIVATE MSDIALOG oDlg ON INIT ;
     EnchoiceBar(oDlg,{||nOpca:=1,oDlg:End()},;
                      {||nOpca:=0,oDlg:End()},,{{"IMPRESSAO",{||TR410Rel(aDados,aRCampos,oMark)},"Impressao"}}) 
     
   IF nOpca = 0
      E_RESET_AREA
   ENDIF
  EXIT
END
*-------------------------------------------*
STATIC FUNCTION TR410Grv()
*-------------------------------------------*
SW6->(DBSEEK(xFilial("SW6")))
ProcRegua(SW6->(LASTREC()))
DO WHILE  !SW6->(EOF()) .AND. xFilial("SW6") == SW6->W6_FILIAL
  IncProc("PESQUISANDO CONHECIMENTO - " +SW6->W6_HAWB,"Atenção")

  IF !EMPTY(SW6->W6_DI_NUM  )
    SW6->(DBSKIP())
    LOOP
  ENDIF  

  IF ! SW7->(DBSEEK(xFilial("SW7")+SW6->W6_HAWB))
    SW6->(DBSKIP())
    LOOP
  ENDIF

  WHILE ! SW7->(EOF()).AND. xFilial("SW7") == SW7->W7_FILIAL .AND. SW6->W6_HAWB == SW7->W7_HAWB
    IF LEFT(SW7->W7_PGI_NUM,1) == "*"
       SW7->(DBSKIP())  ; LOOP
    ENDIF

    IF ASCAN(aPli,SW7->W7_PGI_NUM+SW7->W7_SEQ_LI) = 0
       AADD(aPli,SW7->W7_PGI_NUM+SW7->W7_SEQ_LI)
    ENDIF

    DBSELECTAREA("SW5")
    IF ! PosOrd1_It_Guias(SW7->W7_PGI_NUM,SW7->W7_CC,SW7->W7_SI_NUM,;
                         SW7->W7_COD_I,SW7->W7_FABR,;
                         SW7->W7_FORN,SW7->W7_REG,0)
       SW7->(DBSKIP())  ; LOOP
    ENDIF

    IF SW7->W7_QTDE = SW5->W5_QTDE
      IF EMPTY(SW7->W7_SEQ_LI)
         SB1->(DBSEEK(xFilial("SB1")+SW7->W7_COD_I))
         SWP->(DBSEEK(xFilial("SWP")+SW7->W7_PGI_NUM+SW7->W7_SEQ_LI))
         Work->(DBAPPEND())
         Work->WKHAWB   := SW6->W6_HAWB
         Work->WKCOD_I   := SW7->W7_COD_I
         Work->WKDESCR   := MSMM( SB1->B1_DESC_P,25,1 )
         Work->WKPGI_NUM := SW7->SW7_PGI_NUM
         Work->WKSEQ_LI  := SW7->SW7_SEQ_LI
         Work->WKSUFRAMA := SWP->WP_SUFRAMA
         Work->WKQTDE_E  := SW7->SW7_QTDE
         Work->WKQTDE    := SW5->SW5_QTDE
         Work->WKMSG     := IF(EMPTY(SWP->WP_REGIST),"Embarque sem L.I. ","Qtde Diferente")//IF(EMPTY(SW7->SW7_SEQ_LI),"Embarque sem L.I. ","Qtde Diferente")
      ENDIF
      SW7->(DBSKIP())  ; LOOP
    ENDIF

    SB1->(DBSEEK(xFilial("SB1")+SW7->W7_COD_I))
    SWP->(DBSEEK(xFilial("SWP")+SW7->W7_PGI_NUM+SW7->W7_SEQ_LI))

    Work->(DBAPPEND())
    Work->WKHAWB   := SW6->W6_HAWB
    Work->WKCOD_I   := SW7->W7_COD_I
    Work->WKDESCR   := MSMM( SB1->B1_DESC_P,25,1 )
    Work->WKPGI_NUM := SW7->W7_PGI_NUM
    Work->WKSEQ_LI  := SW7->W7_SEQ_LI
    Work->WKSUFRAMA := SWP->WP_SUFRAMA
    Work->WKQTDE_E  := SW7->W7_QTDE
    Work->WKQTDE    := SW5->W5_QTDE
    Work->WKMSG     := IF(EMPTY(SWP->WP_REGIST),"Embarque sem L.I. ","Qtde Diferente    ")

    SW7->(DBSKIP())
  ENDDO
  SW6->(DBSKIP())
ENDDO  
RETURN .T.
*-------------------------------------*
STATIC FUNCTION TR410Pli(Pli)
*-------------------------------------*

LOCAL bWhile := {|| W5_SEQ = 0 .AND. Pli == W5_PGI_NUM+W5_SEQ_LI}
LOCAL bFor   := {|| W5_SALDO_Q = W5_QTDE}
LOCAL bCond  := {|| Work->(DBAPPEND())                                   ,;
                    SB1->(DBSEEK(xFilial("SB1")+SW5->W5_COD_I))          ,;
                    SWP->(DBSEEK(SW5->W5_PGI_NUM+SW5->W5_SEQ_LI))  ,;
                    Work->WKHAWB   := SW6->W6_HAWB               ,;
                    Work->WKCOD_I   := SW5->W5_COD_I                 ,;
                    Work->WKDESCR   := MSMM( SB1->B1_DESC_P,25,1 )  ,;
                    Work->WKPGI_NUM := SW5->W5_PGI_NUM               ,;
                    Work->WKSEQ_LI  := SW5->W5_SEQ_LI                ,;
                    Work->WKSUFRAMA := SWP->WP_SUFRAMA               ,;
                    Work->WKQTDE    := SW5->W5_QTDE                  ,;
                    Work->WKMSG     := "Item nao Embarcado"               }

SW5->(DBSETORDER(7))
SW5->(DBSEEK(Pli+STR(0,2)))
SW5->(DBEVAL(bCond,bFor,bWhile))
RETURN .T.

*---------------------------------------*
STATIC Function TR410Rel(aDados,aRCampos,oMark)
*---------------------------------------*
LOCAL nRecno:=RECNO()
E_Report(aDados,aRCampos)
DBGOTO(nRecno)
oMark:oBrowse:Refresh()
RETURN .T.
