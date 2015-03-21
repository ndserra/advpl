#Include 'Protheus.ch'
#Include 'TBICONN.ch'


User Function xTela()

Local cTitulo := "Parametro" 
Local cPar    := ""
Local LCON  := .F.
Private oDlg    := Nil

If Select("SX2") = 0
	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' TABLES 'SA1' MODULO 'FAT'
	lCon := .T.
EndIf	

cPar := GetMv("MV_DATAFIS")

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 300,300 PIXEL

 @ 006,010 SAY "MV_DATAFIS: " SIZE 50,10 OF oDlg PIXEL
 @ 005,050 MSGET cPar         SIZE 50,10 OF oDlg PIXEL

 @ 035,050 BUTTON "Confirmar" SIZE 030,015 ACTION(fGrava(cPar)) PIXEL OF oDlg 
 
 DEFINE SBUTTON FROM 035, 100 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg
 
ACTIVATE MSDIALOG oDlg CENTERED

If lCon
	RESET ENVIRONMENT
EndIf	

Return( NIL )
//-------------------------------------------------------------
Static Function fGrava(cPar)


PUTMV("MV_DATAFIS",cPar )

MsgAlert("Parametro alterado","Atenção")

oDlg:End()
Return( NIL )

