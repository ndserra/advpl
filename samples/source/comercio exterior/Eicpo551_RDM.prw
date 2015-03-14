#INCLUDE "Eicpo551.ch"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 22/11/99
#include "average.ch"
#DEFINE  DATA_ATUAL  SUBSTR(DTOC(dDataBase),1,2)  + " / " + ;
                     SUBSTR(CMONTH(dDataBase),1,3)+ " / " + ;
                     Right(DTOC(dDataBase),2)
#xcommand DEFINE FONT <oFont> ;
	     [ NAME <cName> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ <from:FROM USER> ] ;
	     [ <bold: BOLD> ] ;
	     [ <italic: ITALIC> ] ;
	     [ <underline: UNDERLINE> ] ;
	     [ WEIGHT <nWeight> ] ;
	     [ OF <oDevice> ] ;
	     [ NESCAPEMENT <nEscapement> ] ;
       => ;
	  <oFont> :=  oSend( TFont(), "New", <cName>, <nWidth>, <nHeight>, <.from.>,;
		     [<.bold.>],<nEscapement>,,<nWeight>, [<.italic.>],;
		     [<.underline.>],,,,,, [<oDevice>] )

#xtranslate bSETGET(<uVar>) => ;
	    {|u| If(PCount() == 0, <uVar>, <uVar> := u) }

User Function Eicpo551()        // incluido pelo assistente de conversao do AP5 IDE em 22/11/99

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("OPRINT>,CMARCA,TITULO,NOLDAREA,CCADASTRO,AROTINA")
SetPrvt("BFUNCAO,LINVERTE,LINHA,LIMITE,NPROC,LI")
SetPrvt("MPAG,MLIN,CINDEX,CCOND,NINDEX,OFONT1")
SetPrvt("OFONT2,OFONT3,AFONTES,MCONTA,I,CCIDADEESTADOCEP")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 22/11/99 ==> #DEFINE  DATA_ATUAL  SUBSTR(DTOC(dDataBase),1,2)  + " / " + ;

#xtranslate :TIMES_NEW_ROMAN_14            => \[1\]
#xtranslate :COURIER_12                    => \[2\]
#xtranslate :TIMES_NEW_ROMAN_18_BOLD       => \[3\]

//----------------------------------------------------------------------------//
// Printer
#xcommand AVPRINT [ <oPrint> ] ;
             [ <name:TITLE,NAME,DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> ] ;
             [ TO  <xModel> ] ;
       => ;
      [ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPRINTER [ <oPrint> ] ;
             [ <name:NAME,DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> ] ;
             [ TO  <xModel> ] ;
       => ;
      [ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPAGE => AvPageBegin()

#xcommand AVENDPAGE => AvPageEnd()

#xcommand AVNEWPAGE => AvPageEnd() ; AvPageBegin()

#xcommand AVENDPRINT   => AvPrintEnd() ; AvSetPortrait()
#xcommand AVENDPRINTER => AvPrintEnd() ; AvSetPortrait()
//----------------------------------------------------------------------------//

/*
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ EICPO551 ¦ Autor ¦ Victor Iotti           ¦ Data ¦ 20/08/99 ¦¦¦
¦¦¦Alteraçào ¦ Regina H.Perez                            ¦ Data ¦ 25/05/00 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Carta para envio do Pedido                                  ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   ¦ #EICPO551                                                   ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

Private _PictPo:=ALLTRIM(X3Picture("W2_PO_NUM"))
cMarca  := GetMark()
Titulo  := STR0001 //"Carta para envio do Pedido"
nOldArea:= SELECT()
cMemo := SPACE(10)
cCadastro := OemtoAnsi(STR0001) //"Carta para envio do Pedido"

aRotina := MenuDef()
bFuncao := {|| PO551Print() }// Substituido pelo assistente de conversao do AP5 IDE em 22/11/99 ==> bFuncao := {|| Execute(PO551Print) }

SYT->(DBSETORDER(1))

lInverte:=.F.

MarkBrow("SW2","W2_OK","",,,cMarca)

Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 22/11/99
       
/*
Funcao     : MenuDef()
Parametros : Nenhum
Retorno    : aRotina
Objetivos  : Menu Funcional
Autor      : Adriane Sayuri Kamiya
Data/Hora  : 25/01/07 - 14:56
*/
Static Function MenuDef()
Local aRotAdic := {}
Local aRotina :=  { { STR0002  ,"AxPesqui"    , 0 , 1},;    //"Pesquisar"
                    { STR0021 , "U_PO551Altera"   ,0 ,0},;  //"Alterar Texto"      
                    { STR0003  ,"U_PO551Print", 0 , 0} }    //"Impressao"
                   
// P.E. utilizado para adicionar itens no Menu da mBrowse
If ExistBlock("IPO551MNU")
	aRotAdic := ExecBlock("IPO551MNU",.f.,.f.)
	If ValType(aRotAdic) == "A"
		AEval(aRotAdic,{|x| AAdd(aRotina,x)})
	EndIf
EndIf

Return aRotina

*---------------------------*
User FUNCTION PO551Print()
*---------------------------*

Processa({|lEnd| PO551Cab()},Titulo)// Substituido pelo assistente de conversao do AP5 IDE em 22/11/99 ==> Processa({|lEnd| Execute(PO551Cab)},Titulo)

Return


*--------------------------*
Static FUNCTION PO551Cab()
*--------------------------*
Local I
Linha:=0
limite:=130
nProc:=100
li:=80
Mpag:=0
mLin:=9

cIndex:=CriaTrab(,.f.)
dbSelectArea("SW2")

IF lInverte
	cCond := "W2_OK <> '"+cMarca+"'"
Else
	cCond := "W2_OK = '"+cMarca+"'"
Endif

IndRegua("SW2",cIndex,IndexKey(),,cCond,STR0004) //"Selecionando Registros..."
nIndex:=RetIndex("SW2")

#IFNDEF TOP
   dbSetIndex(cIndex+OrdBagExt())
#ENDIF
dbSetorder(nIndex+1)

ProcRegua(nProc)

SW2->(dbSeek( xFilial("SW2") ))

AVPRINT oPrn NAME STR0005 //"CARTA P/ ENVIO DO PEDIDO"

oPrn:SetPortrait()

   //                              Font            W  H  Bold          Device
   oFont1 := oSend(TFont(),"New","Times New Roman",0,12,,.T.,,,,,,,,,,,oPrn )
   oFont2 := oSend(TFont(),"New","Courier New"    ,0,12,,.T.,,,,,,,,,,,oPrn )
   oFont3 := oSend(TFont(),"New","Times New Roman",0,14,,.T.,,,,,,,,,,,oPrn )

   aFontes := { oFont1, oFont2, oFont3 }

   AVPAGE

      IncProc(STR0006) //"Imprimindo..."
      While !Eof() .and. SW2->W2_FILIAL == xFilial("SW2")
         nProc:=nProc-1
         If nProc >= 5
            IncProc()
         Else
            SysRefresh()
         EndIf

         SA2->(DBSEEK(xFilial()+SW2->W2_FORN))
         IF Getmv("MV_ID_CLI") $ cSim
            SA1->(DBSEEK(xFilial("SA1")+SW2->W2_CLIENTE))
         ELSE
            SY1->(DBSEEK(xFilial("SY1")+SW2->W2_COMPRA))
         ENDIF

         IF ! IsMark("W2_OK",cMarca,lInverte)
             dbSkip()
             Loop
         Endif

         MPag      := 0
         MConta    := 1
         MLin      := 9

         PO551BateCarta()// Substituido pelo assistente de conversao do AP5 IDE em 22/11/99 ==>          Execute(PO551BateCarta)

         Grava_Ocor(SW2->W2_PO_NUM,dDataBase,STR0007) //"Emissao do Shipping Instructions"

         SW2->(dbSkip())

         IF !Eof() .and. W2_FILIAL == xFilial("SW2")
            AVNEWPAGE
         ENDIF

      End
      cMemo := SPACE(10)
      For I:=1 TO nProc
          IncProc()
      Next

   AVENDPAGE


AVENDPRINT

oFont1:End()
oFont2:End()
oFont3:End()
Set Filter To
RetIndex("SW2")
Erase (cIndex+OrdBagExt())
Return .T.

*------------------------------*
Static FUNCTION PO551BateCarta()
*------------------------------*
Local I
cCidadeEstadoCep:=""
Linha := 350
                                                               

oPrn:Say( Linha, 2000 , DATA_ATUAL, aFontes:TIMES_NEW_ROMAN_14)

oPrn:Line( Linha:=Linha+70 , 110, Linha  , 2240 )  ;  oPrn:Line( Linha+1,  100, Linha+1, 2240 )

oPrn:Say( Linha:=Linha+15, 900 , STR0008, aFontes:TIMES_NEW_ROMAN_18_BOLD ) //"PURCHASE ORDER"

oPrn:Line( Linha:=Linha+80 , 110, Linha  , 2240 )  ;  oPrn:Line( Linha+1,  100, Linha+1, 2240 )

oPrn:Say( Linha:=Linha+300 , 200 , STR0009,aFontes:COURIER_12 ) //"TO........:"
oPrn:Say( Linha      , 590 , IF(!EMPTY(SA2->A2_NOME),SA2->A2_NOME,SA2->A2_REPRES),aFontes:TIMES_NEW_ROMAN_14)

oPrn:Say( Linha:=Linha+70  , 200 , STR0010,aFontes:COURIER_12 ) //"ATTN......:"
oPrn:Say( Linha      , 590 , SA2->A2_CONTATO    ,aFontes:TIMES_NEW_ROMAN_14)

oPrn:Say( Linha:=Linha+70  , 200 , STR0011,aFontes:COURIER_12 ) //"FAX NR....:"
oPrn:Say( Linha      , 590 , SA2->A2_FAX ,aFontes:TIMES_NEW_ROMAN_14)

oPrn:Say( Linha:=Linha+70  , 200 , STR0012,aFontes:COURIER_12 ) //"PHONE NR..:"
oPrn:Say( Linha      , 590 , SA2->A2_TEL ,aFontes:TIMES_NEW_ROMAN_14)

oPrn:Say( Linha:=Linha+150, 200 , STR0013 + TRANS(SW2->W2_PO_NUM,_PictPO),aFontes:TIMES_NEW_ROMAN_14) //"OUR REFERENCE P.O. "

IF ExistBlock("IC195PO2")
   // Rdmake para Klabin
   ExecBlock("IC195PO2",.F.,.F.,Linha)
Else
   oPrn:Say( Linha:=Linha+150, 200 , STR0014 + IF(GetMv("MV_ID_CLI")$cSim,SA1->A1_NOME,SY1->Y1_NOME),aFontes:TIMES_NEW_ROMAN_14) //"PURCHASER: "
EndIf
IF !EMPTY(cMemo)          
  Linha := Linha +70
  FOR I:=1 TO MLCOUNT(cMemo,80)
    If i % 70 == 0   //ASK 04/01/2008 - Para pular de pagina a cada 70 linhas     
       AvNewPage       
       Linha := 300
       oPrn:Say( Linha:=Linha+200, 200 ,MEMOLINE( cMemo,80,I),aFontes:TIMES_NEW_ROMAN_14)  //TRP-16/01/08- Acerto na quantidade de caracteres por linha, fixo 80.
    Else   
       oPrn:Say( Linha:=Linha+70, 200 ,MEMOLINE( cMemo,80,I),aFontes:TIMES_NEW_ROMAN_14) 
    EndIf
  NEXT  
ELSE
oPrn:Say( Linha:=Linha+150, 200 , STR0015,aFontes:TIMES_NEW_ROMAN_14) //"PLEASE  FIND  ATTACHED  OUR  PURCHASE  ORDER  AND  CONFIRM  THE"
oPrn:Say( Linha:=Linha+70 , 200 , STR0016 ,aFontes:TIMES_NEW_ROMAN_14) //"REQUESTED SHIPMENT SCHEDULE WITHIN (05) DAYS."
oPrn:Say( Linha:=Linha+70, 200 , STR0022 ,aFontes:TIMES_NEW_ROMAN_14) //
oPrn:Say( Linha:=Linha+70, 200 , STR0017 ,aFontes:TIMES_NEW_ROMAN_14) //"PLEASE NOTE THE REMARKS ON THE ATTACHED P.O."              	

oPrn:Say( Linha:=Linha+150, 200 , STR0018 ,aFontes:TIMES_NEW_ROMAN_14) //"ANY DOUBT PLS CONTACT US"
ENDIF

IF GetMv("MV_ID_EMPR") $ cSim
   oPrn:Say( Linha:=Linha+350, 200 , SM0->M0_NOME ,aFontes:TIMES_NEW_ROMAN_14)
   oPrn:Say( Linha:=Linha+90 , 200 , SM0->M0_ENDCOB ,aFontes:TIMES_NEW_ROMAN_14)
   cCidadeEstadoCep := cCidadeEstadoCep +IF( !EMPTY(SM0->M0_CIDCOB), ALLTRIM(SM0->M0_CIDCOB)+" - ", "" )
   cCidadeEstadoCep := cCidadeEstadoCep +IF( !EMPTY(SM0->M0_ESTCOB), ALLTRIM(SM0->M0_ESTCOB)+" - ", "" )
   cCidadeEstadoCep := cCidadeEstadoCep +IF( !EMPTY(SM0->M0_CEPCOB), ALLTRIM(SM0->M0_CEPCOB)+" - ", "" )
ELSE
   SYT->(DBSEEK(xFilial()+SW2->W2_IMPORT))
   oPrn:Say( Linha:=Linha+350, 200 , SYT->YT_NOME ,aFontes:TIMES_NEW_ROMAN_14)
   oPrn:Say( Linha:=Linha+90 , 200 , SYT->YT_ENDE ,aFontes:TIMES_NEW_ROMAN_14)
   cCidadeEstadoCep := cCidadeEstadoCep +IF( !EMPTY(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+" - ", "" )
   cCidadeEstadoCep := cCidadeEstadoCep +IF( !EMPTY(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO)+" - ", "" )
   cCidadeEstadoCep := cCidadeEstadoCep +IF( !EMPTY(SYT->YT_CEP), ALLTRIM(SYT->YT_CEP)+" - ", "" )
ENDIF


IF !EMPTY( cCidadeEstadoCep )
   cCidadeEstadoCep := LEFT(cCidadeEstadoCep,LEN(cCidadeEstadoCep)-2)
ENDIF

oPrn:Say( Linha:=Linha+90, 200 , cCidadeEstadoCep ,aFontes:COURIER_12 )

oPrn:Say( Linha:=Linha+90, 200 , STR0019,aFontes:COURIER_12 ) //"PHONE...:"
oPrn:Say( Linha    , 540 , IF(GetMv("MV_ID_CLI")$cSim,SA1->A1_TEL,SY1->Y1_TEL) ,aFontes:COURIER_12 )

oPrn:Say( Linha:=Linha+90, 200 , STR0020,aFontes:COURIER_12 ) //"FAX.....:"
oPrn:Say( Linha    , 540 , IF(GetMv("MV_ID_CLI")$cSim,SA1->A1_FAX,SY1->Y1_FAX) ,aFontes:COURIER_12 )


RETURN NIL
*------------------------------*
User FUNCTION PO551Altera()
*------------------------------*
#DEFINE TIMES_NEW_ROMAN_14 oFont2
LOCAL cOcpmemo := 0,cMemo1:=""

Linha := 700             
IF EMPTY(cMemo)
  cMemo := cMemo + STR0015 +CHR(13)+CHR(10) //"PLEASE  FIND  ATTACHED  OUR  PURCHASE  ORDER  AND  CONFIRM  THE"
  cMemo := cMemo + STR0016 +CHR(13)+CHR(10) //"REQUESTED SHIPMENT SCHEDULE WITHIN (05) DAYS."
  cMemo := cMemo + STR0022 +CHR(13)+CHR(10)
  cMemo := CMemo + STR0017 +CHR(13)+CHR(10) //"PLEASE NOTE THE REMARKS ON THE ATTACHED P.O."
  cMemo := cMemo + CHR(13) +CHR(10)
  cMemo := cMemo + STR0018 +CHR(13)+CHR(10) //"ANY DOUBT PLS CONTACT US"
ENDIF
cMemo1  := cMemo
cOpcmemo:= 0
DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 
  @ 0,0 TO 300,600 DIALOG oDlg1 TITLE STR0001 
  @ 120,100 BMPBUTTON TYPE 01 ACTION Close(oDlg1)
  @ 120,250 BMPBUTTON TYPE 02 ACTION (cOpcmemo:=1,oDlg1:End())// Close(oDlg1)
  oMemo  := oSend(TMultiGet(),"New",0,0,bSETGET(cMemo1),,290,110,TIMES_NEW_ROMAN_14,,,,,.F.)
ACTIVATE DIALOG oDlg1 CENTERED

IF cOpcMemo == 0 
   cMemo := cMemo1
ENDIF  

RETURN NIL
