#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 16/02/00
#INCLUDE "Eicgi210.ch"      
#include "AVERAGE.CH"
#define INCLUSAO  3
#define ALTERACAO 4
#define EXCLUSAO  5
#define TOTAL     50


User Function Eicgi210()        // incluido pelo assistente de conversao do AP5 IDE em 16/02/00

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 16/02/00 ==> #INCLUDE "Eicgi210.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³EICGI210  ³ Autor ³ Cristiano A. Ferreira ³ Data ³29/04/1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Manutencao de Lote / PLI                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExecBlock(NameInt("EICGI210"))                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³SIGAEIC - PADRAO                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
SIX->(DBSETORDER(1))
DO While .T.
   nOpcao1  := 0
   
   IF cPaisLoc <> "BRA"
      IF SIX->(DBSEEK("SWV2")) .AND. SWV->(FIELDPOS("WV_INVOICE")) # 0
         MSGSTOP("¡El mantenimiento de lotes debe ser hecha en la rutina de despacho!")//"A manutencao de Lotes deve ser feita no Desembaraço."
         nOpcao1  := 0
      ELSE
         nOpcao1  := 1
         nAnuente := 2
      ENDIF
   ELSEIF SIX->(DBSEEK("SWV2")) .AND. SWV->(FIELDPOS("WV_INVOICE")) # 0
      nOpcao1  := 1
      nAnuente := 1
   ELSE
      oDlg1 := oSend( MSDialog(), "New", 9, 0, 17, 35,;
                      STR0046,,,.F.,,,,,oMainWnd,.F.,,,.F.) //"Manutenção de Lote"
      aRadAnuent:= {OemToAnsi(STR0047),OemToAnsi(STR0048)} //"Anuentes"###"NÆo Anuentes"
      nAnuente := 1
      @ 25,10 SAY STR0049 SIZE 50,8 //"Lote para Itens : "
      @ 25,54 RADIO aRadAnuent var nAnuente 
               
      bOk     := {||nOpcao1:=1,oSend(oDlg1,"End")}
      bCancel := {||nOpcao1:=0,oSend(oDlg1,"End")}

      bInit := {|| EnchoiceBar(oDlg1,bOk,bCancel) }
      oSend( oDlg1, "Activate",,,,.T.,,, bInit )
   ENDIF
   If nOpcao1 == 0
     EXIT
   ELSEIF nOpcao1 == 1

      lReturn:=GI210Inicio()
      IF cPaisLoc <> "BRA" .OR. (SIX->(DBSEEK("SWV2")) .AND. SWV->(FIELDPOS("WV_INVOICE")) # 0) .OR. !lReturn
         EXIT
      ENDIF
   ENDIF
ENDDO


Return(NIL) 


*----------------------------*
Static FUNCTION GI210Inicio()
*----------------------------*
LOCAL bOk, bCancel,oDlg,lReturn:=.F.

IF nAnuente == 1 
   cTitulo1 := STR0001 //"Seleção de PLI"
   cTitulo2 := STR0002 //"Seleção de Item - P.L.I."
   cTitulo3 := STR0003 //"Manutenção de Lote / P.L.I."
ELSE
  cTitulo1 := STR0050 //"Seleção de Processos"
  cTitulo2 := STR0051 //"Seleção de Item - Processo"
  cTitulo3 := STR0052 //"Manutenção de Lote / Processo"
ENDIF
nOpcao   := 0
cPGI_Num := Space(Len(SW4->W4_PGI_NUM))
cProcesso:= SPACE(Len(SW6->W6_HAWB))
// Variaveis da MSSELECT                                        ³
lInverte := .F.
cMarca   := GetMark()

// AWR - 15/7/4   \/\/\/\/\/\/\/
SX3->(DBSETORDER(2))
IF SX3->(DBSEEK("WV_FORN")) .AND. SX3->X3_PROPRI == "U"
   SX3->(RECLOCK("SX3",.F.))
   SX3->X3_PROPRI := "S"
   SX3->(MSUNLOCK())
ENDIF
IF SX3->(DBSEEK("WV_POSICAO")) .AND. SX3->X3_PROPRI == "U"
   SX3->(RECLOCK("SX3",.F.))
   SX3->X3_PROPRI := "S"
   SX3->(MSUNLOCK())
ENDIF
IF SX3->(DBSEEK("WV_INVOICE")) .AND. SX3->X3_PROPRI == "U"
   SX3->(RECLOCK("SX3",.F.))
   SX3->X3_PROPRI := "S"
   SX3->(MSUNLOCK())
ENDIF
SX3->(DBSETORDER(1))
// AWR - 15/7/4   /\/\/\/\/\/\/\

aCampos  := IF(nAnuente == 1 ,Array(SW5->(FCount())),Array(SW5->(FCount())))
aHeader  := {}
aSemSX3:={{"FLAG" ,"L",1,0}}
AADD(aSemSX3,{"TRB_ALI_WT","C",03,0}) //TRP - 25/01/07 - Campos do WalkThru
AADD(aSemSX3,{"TRB_REC_WT","N",10,0}) 

IF nAnuente == 1
   cFile1   := E_CriaTrab("SW5",aSemSX3,"Work1")
ELSE
   cFile1   := E_CriaTrab("SW7",aSemSX3,"Work1")
ENDIF

aCampos  := Array(SWV->(FCount()))
aSemSX3:={{"RECNO","N",6,0}}
AADD(aSemSX3,{"TRB_ALI_WT","C",03,0}) //TRP - 25/01/07 - Campos do WalkThru
AADD(aSemSX3,{"TRB_REC_WT","N",10,0})

cFile2   := E_CriaTrab("SWV",aSemSX3,"Work2")

IF nAnuente == 1
   IndRegua("Work1",cFile1,"W5_PO_NUM+W5_CC+W5_SI_NUM+W5_COD_I+Str(W5_REG,"+Alltrim(Str(AVSX3("W5_REG",3)))+")")
ELSE
   IndRegua("Work1",cFile1,"W7_PO_NUM+W7_CC+W7_SI_NUM+W7_COD_I+Str(W7_REG,"+Alltrim(Str(AVSX3("W7_REG",3)))+")")
ENDIF
IndRegua("Work2",cFile2,"WV_LOTE")

// Variaveis para controlar a exclusao de registros             ³
aDelSWV  := Array(0)

DO While .T.
   nOpcao  := 9

   oDlg := oSend( MSDialog(), "New", 9, 0, 15, 49,;
                  cTitulo1,,,.F.,,,,,oMainWnd,.F.,,,.F.) 

   @ 25,30 SAY IF(nAnuente == 1,STR0006,STR0053) SIZE 50,8 Pixel //"Nro. da PLI:" //"Processo:" //LRL 03/02/04
   IF nAnuente ==1 
      @ 25,75 GET cPGI_NUM F3 "SW4"  PICTURE "@!" SIZE 55,8   ;
               VALID GI210ValPGI() 
   ELSE
      @ 25,75 GET cProcesso F3 "SW6"  PICTURE "@!" SIZE 60,8  ;
               VALID GI210ValPGI() 
   ENDIF
   bOk     := {||nOpcao:=1,If(GI210ValPGI(),oSend(oDlg,"End"),nOpcao:=0)}
   bCancel := {||nOpcao:=0,oSend(oDlg,"End")}

   bInit := {|| EnchoiceBar(oDlg,bOk,bCancel) }

   oSend( oDlg, "Activate",,,,.T.,,, bInit )

   If nOpcao == 0
      lReturn:=.T.
      Exit
   Endif
   If nOpcao == 9
      lReturn:=.F.
      Exit
   Endif

   Processa({|| GravaWork1() },STR0007) //"Gravando arquivos de trabalho ..."

   IF ManutSW5()
      LOOP
   ENDIF
   EXIT
ENDDO

Work1->(E_EraseArq(cFile1))
Work2->(E_EraseArq(cFile2))

Return lReturn

*--------------------------------------*
Static Function GI210ValPGI()
*--------------------------------------*
lGI210Val := .T.

Do While .T.
 IF nAnuente == 1
   IF Empty(cPGI_Num)
      Help("", 1, "AVG0000128")//E_Msg(STR0009,1000,.T.) //"N£mero da P.L.I. deve ser preenchido"
      lGI210Val := .F.
      Exit
   Endif

   SW4->(dbSetOrder(1))
   IF ! SW4->(dbSeek(xFilial()+cPGI_Num))
      Help("", 1, "AVG0000129")//E_Msg(STR0010,1000,.T.) //"N£mero da P.L.I. n„o cadastrado"
      lGI210Val := .F.
      Exit
   Endif
ELSE
  IF Empty(cProcesso)
      Help("", 1, "AVG0000130")//E_Msg(STR0054,1000,.T.) //"N£mero do Processo deve ser preenchido"
      lGI210Val := .F.
      Exit
   Endif

   SW6->(dbSetOrder(1))
   IF ! SW6->(dbSeek(xFilial()+cProcesso))
      Help("", 1, "AVG0000131")//E_Msg(STR0055,1000,.T.) //"N£mero do Processo n„o cadastrado"
      lGI210Val := .F.
   Exit
   Endif

endif
   Exit
EndDo

Return lGI210Val

*--------------------------------------------*
Static Function GravaWork1()
*--------------------------------------------*
Local i
i := 0
xValue := nil

nCont := 1
ProcRegua(TOTAL)

Work1->(__dbZap())
IF nAnuente == 1
SW5->(dbSetOrder(1))
SW5->(dbSeek(xFilial()+cPGI_Num))
  cFilSW5 := SW5->(xFilial("SW5"))
  While ! SW5->(Eof()) .And. SW5->W5_FILIAL == cFilSW5 .And.;
       SW5->W5_PGI_NUM == cPGI_Num

      IF nCont > TOTAL
         ProcRegua(TOTAL)
         nCont := 0
      ELSE
         IncProc()
         nCont := nCont + 1
      Endif

   IF SW5->W5_SEQ != 0
      SW5->(dbSkip())
      LOOP
   Endif

   Work1->(dbAppend())

   For i := 1 To Work1->(FCount())
      If Work1->(FieldName(i)) $ "RECNO,FLAG,DELETE,W5_DESC_P,W5_FABR_N,W5_FORN_N,TRB_ALI_WT,TRB_REC_WT" .Or.;
         SW5->(FieldPos(Work1->(FieldName(i)))) == 0
         LOOP
      Endif
      xValue := SW5->(FieldGet(FieldPos(Work1->(FieldName(i)))))          
      Work1->(FieldPut(i,xValue))
   Next
      
   Work1->Flag:=SW5->W5_QTDE == SW5->W5_SALDO_Q
   Work1->TRB_ALI_WT:= "SW5"
   Work1->TRB_REC_WT:= SW5->(Recno())
   
   // Grava os campos virtuais	  
   SA2->(DbSeek(xFilial("SA2")+Work1->W5_FABR))
   Work1->W5_FABR_N := SA2->A2_NREDUZ
   
   SA2->(DbSeek(xFilial("SA2")+Work1->W5_FORN))
   Work1->W5_FORN_N := SA2->A2_NREDUZ	     
   
   SB1->(DBSEEK(xFilial()+ Work1->W5_COD_I))   	      
   Work1->W5_DESC_P := SB1->B1_DESC_P

   SW5->(dbSkip())
   EndDo
ELSE
  SW7->(DBSETORDER(1))
  SW7->(dbSeek(xFilial()+cProcesso))
  cFilSW7 := xFilial("SW7")

  While ! SW7->(Eof()) .And. SW7->W7_FILIAL == cFilSW7 .And.;
       SW7->W7_HAWB == cProcesso
      IF nCont > TOTAL
         ProcRegua(TOTAL)
         nCont := 0
      ELSE
      IncProc()
      nCont := nCont + 1
    Endif
    IF LEFT(SW7->W7_PGI_NUM,1) #"*"
      SW7->(DBSKIP())
      LOOP
    ENDIF

   Work1->(dbAppend())

   For i := 1 To Work1->(FCount())
      If Work1->(FieldName(i)) $ "RECNO,FLAG,DELETE,TRB_ALI_WT,TRB_REC_WT"
         LOOP
      Endif
      xValue := SW7->(FieldGet(FieldPos(Work1->(FieldName(i)))))
      Work1->(FieldPut(i,xValue))
   Next

   Work1->Flag:=SW7->W7_QTDE == SW7->W7_SALDO_Q
   Work1->TRB_ALI_WT:= "SW7"
   Work1->TRB_REC_WT:= SW7->(Recno())
   
   SW7->(dbSkip())
   EndDo

ENDIF

Return

*--------------------------------------------*
Static Function ManutSW5()
*--------------------------------------------*
LOCAL bOk, bCancel,oDlg,lReturn:=.F.
PRIVATE cPictQtd
nOpcSW5 := 0
nSaldo  := 0
IF nAnuente ==1
   cPictQtd:=AVSX3("W5_QTDE",6)
   aCpos_SW5 := { { {||Work1->W5_PGI_NUM},,STR0011},; //"Nro. da PLI"
                  { {||Work1->W5_PO_NUM },,STR0012} ,; //"Nro. do PO"
                  { {||Work1->W5_CC     },,STR0013},; //"Und.Requis."
                  { {||Work1->W5_SI_NUM },,STR0014} ,; //"Nro. da SI"
                  { {||Work1->W5_COD_I  },,STR0015},; //"Codigo Item"
                  { {||LOTECodProd(Work1->W5_COD_I)},,STR0016},; //"Descrição Item"
                  { {||TranSf(Work1->W5_QTDE,cPictQtd)},,STR0017} } //"Qtde"
   aCpos_SW5:= AddCpoUser(aCpos_SW5,"SW5", "5", "Work1")

ELSE
   cPictQtd:=AVSX3("W7_QTDE",6)
  aCpos_SW5 := { { {||Work1->W7_HAWB   },,STR0056},; //"Processo"
               { {||Work1->W7_PO_NUM   },,STR0012},; //"Nro. do PO"
               { {||Work1->W7_CC       },,STR0013},; //"Und.Requis."
               { {||Work1->W7_SI_NUM   },,STR0014},; //"Nro. da SI"
               { {||Work1->W7_COD_I    },,STR0015},; //"Codigo Item"
                { {||LOTECodProd(Work1->W7_COD_I) },,STR0016},; //"Descrição Item"
                { {||TranSf(Work1->W7_QTDE,cPictQtd)},,STR0017} } //"Qtde"

   aCpos_SW5:= AddCpoUser(aCpos_SW5,"SW7", "5", "Work1")
ENDIF
Work1->(dbGotop())

Do While (.T.)
   nOpcSW5 := 9
   
   oMainWnd:ReadClientCoords()
   DEFINE MSDIALOG oDlg TITLE cTitulo2; 
         FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 TO oMainWnd:nBottom-60,oMainWnd:nRight-10 ;
         OF oMainWnd PIXEL  

   @ 20,04 SAY IF(nAnuente==1,STR0006,(STR0053)) SIZE 50,8 Pixel //"Nro. da PLI:" //"Processo:"
   IF nAnuente==1
      @ 20,40 GET cPGI_NUM  F3 "SW4" PICTURE "@!" SIZE 60,8 WHEN .F.
   ELSE
      @ 20,40 GET cProcesso F3 "SW6" PICTURE "@!" SIZE 60,8 WHEN .F.
   ENDIF

   oMark := oSend( MsSelect(), "New", "Work1",,,aCpos_SW5, @lInverte,@cMarca,{35,1,(oDlg:nHeight-30)/2,(oDlg:nClientWidth-4)/2})
   oMark:bAval:={|| nOpcSW5:=1, oSend(oDlg, "End") }
   @ 00,00 MsPanel oPanSW5 Prompt "" Size 15,15 of oDlg
   @ 01.5,(oDlg:nClientWidth-111)/2 BUTTON STR0018 SIZE 54,11 ACTION (nOpcSW5:=1,oSend(oDlg,'End')) of oPanSW5 PIXEL // LRL 13/02/04  //"Manutenção _Lote"

   bOk     := {||nOpcSW5:=1,oSend(oDlg,"End")}
   bCancel := {||nOpcSW5:=0,oSend(oDlg,"End")}
   bInit   := {||(EnchoiceBar(oDlg,bOk,bCancel),;
              oPanSW5:Align:=CONTROL_ALIGN_TOP,oMark:oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT)} //LRL 24/03/04 - Alinhamento MDI

   oSend( oDlg, "Activate",,,,/*.T.*/,,, bInit )

   If nOpcSW5 == 0 // Cancel
      lReturn := .T.
      Exit
   Endif

   If nOpcSW5 == 9 // x da Tela
      lReturn := .F.
      Exit
   Endif

   // Manutencao de Lotes de um item
   aSize(aDelSWV,0)
   nSaldo :=IF(nAnuente==1, Work1->W5_QTDE,Work1->W7_QTDE)

   Processa({|| GravaWork2()},STR0007) //"Gravando arquivos de trabalho ..."

   IF ManutSWV()
      LOOP
   ENDIF
   EXIT
EndDo

Return lReturn

*--------------------------------------------*
Static Function GravaWork2()
*--------------------------------------------*
Local i
i := 0
xValue := nil

ProcRegua(TOTAL)
nCont := 1

Work2->(__dbZap())

cPgi :=IF(nAnuente ==1, Work1->W5_PGI_NUM,Work1->W7_PGI_NUM)
cPO  :=IF(nAnuente ==1, Work1->W5_PO_NUM,Work1->W7_PO_NUM)
cCC  :=IF(nAnuente ==1, Work1->W5_CC,Work1->W7_CC)
cSI  :=IF(nAnuente ==1, Work1->W5_SI_NUM,Work1->W7_SI_NUM)
cCod :=IF(nAnuente ==1, Work1->W5_COD_I,Work1->W7_COD_I)
cReg :=IF(nAnuente ==1, Work1->W5_REG,Work1->W7_REG)

SWV->(dbSeek(xFilial()+cProcesso+cPgi+cPO+cCC+cSI+cCOD+Str(cREG,AVSX3("W5_REG",3))))
Do While !SWV->(Eof()) .And. SWV->WV_FILIAL == xFilial("SWV") .And.;
         cProcesso+cPgi+cPO+cCC+cSI+cCod+STR(cReg,AVSX3("WV_REG",3)) == ;
         SWV->(WV_HAWB+WV_PGI_NUM+WV_PO_NUM+WV_CC+WV_SI_NUM+WV_COD_I+Str(WV_REG,AVSX3("WV_REG",3)))

   IF nCont > TOTAL
      ProcRegua(TOTAL)
      nCont := 0
   ELSE
      IncProc()
      nCont := nCont + 1
   Endif

   IF SIX->(DBSEEK("SWV2")) .AND. SWV->(FIELDPOS("WV_INVOICE")) # 0
      IF !EMPTY(SWV->WV_INVOICE)
         SWV->(dbSkip())
         LOOP
      ENDIF
   ENDIF

   Work2->(dbAppend())

// For i := 1 To Work2->(FCount())
//    If AllTrim(Work2->(FieldName(i))) $ "RECNO,FLAG,DELETE"
//       LOOP
//    Endif

//    xValue := SWV->(FieldGet(FieldPos(Work2->(FieldName(i)))))
//    Work2->(FieldPut(i,xValue))
// Next
   AVREPLACE("SWV","Work2")

   Work2->RECNO := SWV->(Recno())

   nSaldo := nSaldo - SWV->WV_QTDE
   Work2->TRB_ALI_WT:= "SWV"
   Work2->TRB_REC_WT:= SWV->(Recno())
   SWV->(dbSkip())
EndDo

Return

*--------------------------------------------*
Static Function ManutSWV()
*--------------------------------------------*
LOCAL bOk, bCancel,oDlg
Local oPanTopSWV, oPanButtonSWV //LRL 24/03/04

nOpcSWV := 0

bManut  := {|x| nOpc := x, EditSWV() }

bAdd    := {|| Eval(bManut,INCLUSAO) }
bEdit   := {|| Eval(bManut,ALTERACAO) }
bDelete := {|| Eval(bManut,EXCLUSAO) }

aRotina := { { STR0019  ,"AllWaysTrue()", 0 , 1},; //"Pesqusar"
             { STR0020  ,"AllWaysTrue()", 0 , 2},; //"Visual"
             { STR0021  ,"Eval(bAdd)"   , 0 , 3},; //"Incluir"
             { STR0022  ,"Eval(bEdit)"  , 0 , 4},; //"Alterar"
             { STR0023  ,"Eval(bDelete)", 0 , 5} } //"Excluir"

aCpos_SWV := { { {||Transf(Work2->WV_QTDE,AVSX3("WV_QTDE",6))},,STR0024},; //"Qtde. Lote"
               { {||Work2->WV_LOTE }    ,,STR0025},; //"Nro. do Lote"
               { {||Work2->WV_DT_VALI } ,,STR0026},; //"Dt. Validade"
               { {||Work2->WV_OBS}      ,,STR0027} } //"Observação"


aCpos_SWV:= AddCpoUser(aCpos_SWV,"SWV","5","Work2")

Work2->(dbGoTop())

Do While (.T.)
   nOpcSWV:= 0

   oMainWnd:ReadClientCoords()
   DEFINE MSDIALOG oDlg TITLE cTitulo3; 
         FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 TO oMainWnd:nBottom-60,oMainWnd:nRight-10 ;
         OF oMainWnd PIXEL  
      @ 00,00 MsPanel oPanTopSWV Prompt "" Size 19,41 of oDlg //LRL 24/03/04 Painel do Topo p/ alinhamento MDI
      @ 03,004 SAY IF(nAnuente==1,STR0006,STR0053) SIZE 45,8 of oPanTopSWV PIXEL // LRL 13/02/04 //"Nro. da PLI:" //"Processo:"
      IF nAnuente ==1
         @ 03,040 MSGET cPGI_NUM  F3 "SW4" PICTURE "@!" SIZE 45,8 of oPanTopSWV Pixel WHEN .F.
      ELSE
         @ 03,040 MSGET cProcesso F3 "SW6" PICTURE "@!" SIZE 45,8 of oPanTopSWV Pixel WHEN .F.
      ENDIF

      @ 03,097 SAY OemToAnsi(STR0028) SIZE 50,8 of oPanTopSWV PIXEL // LRL 13/02/04 //"Nro. do PO:"
      IF nAnuente ==1
         @ 03,130 GET Work1->W5_PO_NUM PICTURE "@!" SIZE 40,8 of oPanTopSWV Pixel WHEN .F.
      ELSE
         @ 03,130 GET Work1->W7_PO_NUM PICTURE "@!" SIZE 40,8 of oPanTopSWV Pixel WHEN .F.
      ENDIF

      @ 15,004 SAY OemToAnsi(STR0029)  SIZE 50,8 of oPanTopSWV PIXEL // LRL 13/02/04 //"Unid.Requis.:"
      IF nAnuente ==1 
         @ 15,040 GET Work1->W5_CC PICTURE "@!" SIZE 30,8 of oPanTopSWV Pixel WHEN .F.
      ELSE
         @ 15,040 GET Work1->W7_CC PICTURE "@!" SIZE 30,8 of oPanTopSWV Pixel WHEN .F.
      ENDIF

      @ 15,097 SAY OemToAnsi(STR0030)  SIZE 45,8 of oPanTopSWV PIXEL // LRL 13/02/04  //"Nro. da SI:"
      IF nAnuente ==1
        @ 15,130 GET Work1->W5_SI_NUM PICTURE "@!" SIZE 60,8 of oPanTopSWV Pixel WHEN .F.
      ELSE
        @ 15,130 GET Work1->W7_SI_NUM PICTURE "@!" SIZE 60,8 of oPanTopSWV Pixel WHEN .F.
      ENDIF

      @ 27,004 SAY OemToAnsi(STR0031)  SIZE 45,8 of oPanTopSWV PIXEL // LRL 13/02/04  //"Cod. Item:"
      IF nAnuente ==1 
         @ 27,040 GET Work1->W5_COD_I PICTURE "@!" SIZE 105,8 of oPanTopSWV Pixel WHEN .F.
      ELSE
         @ 27,040 GET Work1->W7_COD_I PICTURE "@!" SIZE 105,8 of oPanTopSWV Pixel WHEN .F.
      ENDIF

      @ 27,198 SAY OemToAnsi(STR0032)  SIZE 45,8 of oPanTopSWV PIXEL // LRL 13/02/04 //"Descr.Item:"
      
      xAux := LOTECodProd(IF(nAnuente==1,Work1->W5_COD_I,Work1->W7_COD_I))
      @ 27,232 GET xAux PICTURE "@!" SIZE 105,8 of oPanTopSWV Pixel  WHEN .F.

      @ 15,198 SAY OemToAnsi(STR0033)  SIZE 45,8 of oPanTopSWV PIXEL // LRL 13/02/04 //"Qtde. Item:"
      IF nAnuente == 1
         @ 15,232 GET Work1->W5_QTDE PICTURE AVSX3("W5_QTDE",6) SIZE 70,8 of oPanTopSWV Pixel  WHEN .F.
      ELSE
         @ 15,232 GET Work1->W7_QTDE PICTURE AVSX3("W7_QTDE",6) SIZE 70,8 of oPanTopSWV Pixel  WHEN .F.
      ENDIF

      @ 03,198 SAY OemToAnsi(STR0034)  SIZE 45,8 of oPanTopSWV PIXEL // LRL 13/02/04 //"Saldo Item:"
      @ 03,232 GET nSaldo PICTURE AVSX3("WV_QTDE",6) SIZE 70,8 of oPanTopSWV Pixel  WHEN .F.

   oMark:= oSend( MsSelect(), "New", "Work2",,,aCpos_SWV, @lInverte,@cMarca,{57,1,(oDlg:nHeight-30)/2,(oDlg:nClientWidth-90)/2})
   IF Work1->Flag
      oMark:bAval:={|| nOpcSWV:=2, oSend(oDlg, "End") }
   ENDIF
   @ 00,50 MsPanel oPanButtonSWV Prompt "" Size 40,50 of oDlg
   @ 60,(oDlg:nClientWidth-70)/2 BUTTON STR0035 SIZE 34,11 ACTION (nOpcSWV:=1,oSend(oDlg,'End')) OBJECT oBott1 //"_Incluir"
   @ 75,(oDlg:nClientWidth-70)/2 BUTTON STR0036 SIZE 34,11 ACTION (nOpcSWV:=2,oSend(oDlg,'End')) OBJECT oBott2 //"_Alterar"
   @ 90,(oDlg:nClientWidth-70)/2 BUTTON STR0037 SIZE 34,11 ACTION (nOpcSWV:=3,oSend(oDlg,'End')) OBJECT oBott3 //"_Excluir"

   IF !Work1->Flag
      oSend(oBott1,'Disable')
      oSend(oBott2,'Disable')
      oSend(oBott3,'Disable')
   ENDIF

   bOk     := {||nOpcSWV:=4,oSend(oDlg,"End")}
   bCancel := {||nOpcSWV:=0,oSend(oDlg,"End")}

   bInit := {|| (EnchoiceBar(oDlg,bOk,bCancel),;
            oPanTopSWV:ALIGN:=CONTROL_ALIGN_TOP,;           //LRL 24/03/04
            oPanButtonSWV:ALIGN:=CONTROL_ALIGN_RIGHT,;      //  Alinhamento Mdi
            oMark:oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT) } //

   oSend( oDlg, "Activate",,,,/*.T.*/,,, bInit )

   If nOpcSWV == 0 // Cancel
      Exit

   Elseif nOpcSWV == 1 // Incluir
      Eval(bAdd)
      loop

   Elseif nOpcSWV == 2 // Alteracao
      Eval(bEdit)
      loop

   Elseif nOpcSWV == 3 // Exclusao
      Eval(bDelete)
      loop

   Elseif nOpcSWV == 4 // Ok
      If !ValidQtd()
         LOOP
      Endif

   Endif

   // Ok

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Gravacao do work2                                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   Processa({||GravaSWV()},STR0038) //"Gravando arquivos do sistema ..."

   Exit
EndDo

Return .T.
*---------------------------------------*
Static Function ValidQtd()
*---------------------------------------*

IF nSaldo #0 .AND. nSaldo # IF(nAnuente==1,Work1->W5_QTDE,Work1->W7_QTDE)
   Help("", 1, "AVG0000132")//E_Msg(STR0039,1) //"Somat¢ria das quantidades nos lotes nÆo esta igual a quantidade do Item !"
   Return .F.
Endif

Return .T.

*---------------------------------------*
Static Function GravaSWV()
*---------------------------------------*
LOCAL I
xValue := nil
xPos   := nil

ProcRegua(Work2->(LastRec())+Len(aDelSWV))

Work2->(dbGotop())

Do While ! Work2->(Eof())

   IncProc()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Grava campos do SWV                                          ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   IF Work2->RECNO == 0
      SWV->(RecLock("SWV",.T.))
      SWV->WV_FILIAL := xFilial("SWV")
   Else
      SWV->(dbGoTo(Work2->RECNO))
      SWV->(RecLock("SWV",.F.))
   Endif

   /* For i := 1 To SWV->(FCount())
      IF SWV->(FieldName(i)) == "WV_FILIAL"
         LOOP
      Endif

      xValue := Work2->(FieldGet(FieldPos(SWV->(FieldName(i)))))
      SWV->(FieldPut(i,xValue))
   Next
   */
   
/* For i := 1 To Work2->(FCount())
      If AllTrim(Work2->(FieldName(i))) $ "RECNO,FLAG,DELETE"
         LOOP
      Endif
      
      xValue := Work2->(FieldGet(FieldPos(Work2->(FieldName(i)))))
      xPos   := SWV->(FieldPos(Work2->(FieldName(i))))
      SWV->(FieldPut(xPos,xValue))
   Next*/
   AVREPLACE("Work2","SWV")// AWR - LOTE - 14/06/2004
      
   SWV->WV_HAWB    := cProcesso
   SWV->WV_PGI_NUM := IF(nAnuente==1,Work1->W5_PGI_NUM,Work1->W7_PGI_NUM)
   SWV->WV_PO_NUM  := IF(nAnuente==1,Work1->W5_PO_NUM,Work1->W7_PO_NUM)
   SWV->WV_CC      := IF(nAnuente==1,Work1->W5_CC,Work1->W7_CC)
   SWV->WV_SI_NUM  := IF(nAnuente==1,Work1->W5_SI_NUM,Work1->W7_SI_NUM)
   SWV->WV_REG     := IF(nAnuente==1,Work1->W5_REG,Work1->W7_REG)
   SWV->WV_COD_I   := IF(nAnuente==1,Work1->W5_COD_I,Work1->W7_COD_I)

   SWV->(MSUnlock())

   Work2->(dbSkip())
EndDo

For i:=1 To Len(aDelSWV)
   IncProc()
   SWV->(dbGoTo(aDelSWV[i]))

   SWV->(RecLock("SWV",.F.))
   SWV->(dbDelete())
   SWV->(MSUnlock())
Next

aSize(aDelSWV,0)

Return

*------------------------------------------------*
Static FUNCTION EditSWV()
*------------------------------------------------*
LOCAL bOk, bCancel,oDlg
Local aOrd:= {}
Private oPanelTop
nEditSWV_Select := Select()

dbSelectArea("Work2")

Do While .T.
   IF nOpc == INCLUSAO
      IF nSaldo == 0
         Help("", 1, "AVG0000133")//MsgInfo(STR0040) //"Não há saldo disponível para a inclusão !"
         Exit
      Endif
      cTitulo4 := cTitulo3+STR0041 //" - Inclusão de Lote"
   Elseif nOpc == ALTERACAO
      IF Work2->(Eof()) .Or. Work2->(Bof())
         Help("", 1, "AVG0000134")//MsgInfo(STR0042) //"Não existem registros para a alteração !"
         Exit
      Endif
      cTitulo4 := cTitulo3+STR0043 //" - Alteração de Lote"
   Else
      IF Work2->(Eof()) .Or. Work2->(Bof())
         Help("", 1, "AVG0000135")//MsgInfo(STR0044) //"Não existem registros para a exclusão !"
         Exit
      Endif
      cTitulo4 := cTitulo3+STR0045 //" - Exclusão de Lote"
   Endif
   nOpcA := 0
   aTela := Array(0,0)
   aGets := Array(0)
   lRefresh := .T.

   M->WV_QTDE := M->WV_LOTE := M->WV_DT_VALI := M->WV_OBS := nil

   IF nOpc == INCLUSAO
      M->WV_QTDE    := 0
      M->WV_LOTE    := Space(Len(SWV->WV_LOTE))
      M->WV_DT_VALI := AVCTOD("")
      M->WV_OBS     := Space(Len(SWV->WV_OBS))
      aOrd := SaveOrd("SX3",1)      
      SX3->(dbSeek("SWV"))       
      While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SWV" 
         If SX3->X3_PROPRI=="U" .AND. X3Uso(SX3->X3_USADO)
            If SX3->X3_TIPO == "C"
               M->&(SX3->X3_CAMPO):= Space(Len(SX3->X3_CAMPO))   
            Elseif SX3->X3_TIPO == "N"
               M->&(SX3->X3_CAMPO):= 0
            Elseif SX3->X3_TIPO == "D"
               M->&(SX3->X3_CAMPO):= AVCTOD("")
            Endif
         EndIF   
         SX3->(dbSkip())
      Enddo
      RestOrd(aOrd)
   Else
      M->WV_QTDE    := Work2->WV_QTDE
      M->WV_LOTE    := Work2->WV_LOTE
      M->WV_DT_VALI := Work2->WV_DT_VALI
      M->WV_OBS     := Work2->WV_OBS
      aOrd := SaveOrd("SX3",1)      
      SX3->(dbSeek("SWV"))       
      While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SWV" 
         If SX3->X3_PROPRI=="U" .AND. X3Uso(SX3->X3_USADO)
            M->&(SX3->X3_CAMPO):= Work2->&(SX3->X3_CAMPO)   
         EndIF   
         SX3->(dbSkip())
      Enddo
      RestOrd(aOrd)
   Endif

   nSaldo := nSaldo + M->WV_QTDE

   nSaldo:= (round(nSaldo,avsx3("W7_QTDE",4)*100/100))
   Do While .T.
      nOpcA:=0

   oMainWnd:ReadClientCoords()
   DEFINE MSDIALOG oDlg TITLE cTitulo4; 
         FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 TO oMainWnd:nBottom-60,oMainWnd:nRight-10 ;
         OF oMainWnd PIXEL  
      @ 00,00 MsPanel oPanelTop Prompt "" Size 19,41 of oDlg //LRL 24/03/04 Painel do Topo p/ alinhamento MDI
      @ 15,004 SAY IF(nAnuente==1,STR0006,STR0053) SIZE 45,8 Pixel //"Nro. da PLI:" //"Processo:"
      IF nAnuente ==1
         @ 15,040 GET cPGI_NUM  F3 "SW4" PICTURE "@!" SIZE 45,8  WHEN .F.
      ELSE
         @ 15,040 GET cProcesso F3 "SW6" PICTURE "@!" SIZE 45,8  WHEN .F.
      ENDIF

      @ 15,097 SAY OemToAnsi(STR0028) SIZE 50,8 Pixel //"Nro. do PO:"
      IF nAnuente ==1
         @ 15,130 GET Work1->W5_PO_NUM PICTURE "@!" SIZE 40,8 of oDlg Pixel WHEN .F.
      ELSE
         @ 15,130 GET Work1->W7_PO_NUM PICTURE "@!" SIZE 40,8 of oDlg Pixel WHEN .F.
      ENDIF

      @ 27,004 SAY OemToAnsi(STR0029)  SIZE 50,8 Pixel //"Unid.Requis.:"
      IF nAnuente ==1 
         @ 27,040 GET Work1->W5_CC PICTURE "@!" SIZE 30,8 of oDlg Pixel WHEN .F.
      ELSE
         @ 27,040 GET Work1->W7_CC PICTURE "@!" SIZE 30,8 of oDlg Pixel WHEN .F.
      ENDIF

      @ 27,097 SAY OemToAnsi(STR0030)  SIZE 45,8 Pixel //"Nro. da SI:"
      IF nAnuente ==1
        @ 27,130 GET Work1->W5_SI_NUM PICTURE "@!" SIZE 30,8 of oDlg Pixel WHEN .F.
      ELSE
        @ 27,130 GET Work1->W7_SI_NUM PICTURE "@!" SIZE 30,8 of oDlg Pixel WHEN .F.
      ENDIF

      @ 39,004 SAY OemToAnsi(STR0031)  SIZE 45,8 Pixel //"Cod. Item:"
      IF nAnuente ==1 
         @ 39,040 GET Work1->W5_COD_I PICTURE "@!" SIZE 45,8 of oDlg Pixel WHEN .F.
      ELSE
         @ 39,040 GET Work1->W7_COD_I PICTURE "@!" SIZE 45,8 of oDlg Pixel WHEN .F.
      ENDIF

      @ 39,097 SAY OemToAnsi(STR0032)  SIZE 45,8 Pixel //"Descr.Item:"
      
      xAux := LOTECodProd(IF(nAnuente==1,Work1->W5_COD_I,Work1->W7_COD_I))
      @ 39,130 GET xAux PICTURE "@!" SIZE 105,8 of oDlg Pixel WHEN .F.

      @ 15,198 SAY OemToAnsi(STR0033)  SIZE 45,8 Pixel //"Qtde. Item:"
      IF nAnuente == 1
         @ 15,232 GET Work1->W5_QTDE PICTURE AVSX3("W5_QTDE",6)  SIZE 70,8 of oDlg Pixel WHEN .F.
      ELSE
         @ 15,232 GET Work1->W7_QTDE PICTURE  AVSX3("W7_QTDE",6) SIZE 70,8 of oDlg Pixel WHEN .F.
      ENDIF

      @ 27,198 SAY OemToAnsi(STR0034)  SIZE 45,8 Pixel //"Saldo Item:"
      @ 27,232 GET nSaldo PICTURE AVSX3("WV_QTDE",6) SIZE 70,8 of oDlg Pixel WHEN .F.

      aMostra := {"WV_QTDE","WV_LOTE","WV_DT_VALI","WV_OBS"}// AWR - LOTE - 14/06/2004
      
      aMostra:= AddCPoUser(aMostra,"SWV","1")
      
      aChg := IF(nOpc == EXCLUSAO,{},Nil)                  
      nOp  := IF(nOpc == INCLUSAO,3,4)

      oMsMGet := oSend( MsMGet(), "New","SWV",Work2->(Recno()),nOp,,,,aMostra,{57,1,(oDlg:nHeight-30)/2,(oDlg:nClientWidth-4)/2},aChg,3)
            
      bOk    := {||nOpcA:=1,if(Obrigatorio(aGets,aTela),oSend(oDlg,"End"),nOpcA:=0)}
      bCancel:={||nOpcA:=0,oSend(oDlg,"End")}

      bInit := {|| (EnchoiceBar(oDlg,bOk,bCancel),;
                oPanelTop:Align:=CONTROL_ALIGN_TOP,oMsMGet:oBox:Align:=CONTROL_ALIGN_ALLCLIENT)} //LRL 24/03/04 -ALinhamento Mdi

      oSend( oDlg, "Activate",,,,,,, bInit )

      IF nOpcA == 0 // Cancel
         IF nOpc != INCLUSAO
            nSaldo := nSaldo - M->WV_QTDE
         Endif
         Exit
      Endif

      // Ok

      IF nOpc == EXCLUSAO
         IF Work2->RECNO != 0
            aAdd(aDelSWV,Work2->RECNO)
         Endif
         Work2->(dbDelete())
         Work2->(dbSkip(-1))
         IF Work2->(BOF()) ; Work2->(dbGoTop()) ; ENDIF
      Else
         IF nOpc == INCLUSAO
            Work2->(dbAppend())
         Endif

//       For j := 1 To Work2->(FCount())
//          x := MemVarBlock(Work2->(FieldName(j)))
//          IF !(Work2->(FieldName(j))$"RECNO,FLAG,DELETE")
//             Work2->(FieldPut(j,Eval(x)))
//          Endif
//       Next
         AVREPLACE("M","Work2")// AWR - LOTE - 14/06/2004

         nSaldo := nSaldo - M->WV_QTDE
         Work2->TRB_ALI_WT:= "SWV"
         Work2->TRB_REC_WT:= SWV->(Recno())
      
      ENDIF

      IF nOpc == INCLUSAO .And. nSaldo > 0
         M->WV_LOTE := Space(Len(SWV->WV_LOTE))
         M->WV_QTDE    := 0
         M->WV_DT_VALI := AVCTOD("")
         M->WV_OBS     := Space(Len(SWV->WV_OBS))
         aOrd := SaveOrd("SX3",1)      
         SX3->(dbSeek("SWV"))       
         While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SWV" 
            If SX3->X3_PROPRI=="U" .AND. X3Uso(SX3->X3_USADO)
               If SX3->X3_TIPO == "C"
                  M->&(SX3->X3_CAMPO):= Space(Len(SX3->X3_CAMPO))   
               Elseif SX3->X3_TIPO == "N"
                  M->&(SX3->X3_CAMPO):= 0
               Elseif SX3->X3_TIPO == "D"
                  M->&(SX3->X3_CAMPO):= AVCTOD("")
               Endif
            EndIF   
            SX3->(dbSkip())
         Enddo
         RestOrd(aOrd)
         Loop
      Endif

      Exit
   EndDo

   Exit
EndDo

Select(nEditSWV_Select)

Return .T.

*------------------------------------*
Static Function LOTECodProd(cCodigo)
*------------------------------------*
cDescr := SPACE(LEN(SB1->B1_DESC))

IF !Empty(cCodigo) .AND.;
   SB1->(dbSeek(xFilial()+cCodigo))
   cDescr :=  SB1->B1_DESC
ENDIF

Return (cDescr)

*-------------------------------------------------------------------------*
* FIM DO PROGRAMA EICGI210.PRW                                            *
*-------------------------------------------------------------------------*

