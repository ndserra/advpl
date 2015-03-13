#Include 'Protheus.ch'
#Include 'TBICONN.ch'

User Function xTela()

	Local cTitulo := "Parametro"
	//Local oDlg := Nil
	Local oDlg := Nil
	Local cPar := ""
	//Local lCon := .F.
	
	
	If Select("SX2") = 0
		PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' TABLES 'SA1' MODULO 'FAT'
		lCon := .T.
	EndIf
	
	cPar := GetMv("MV_DATAFIS")
	//cPar := 0
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 200,450 PIXEL
	
	@ 005,010 SAY "MV_DATAFIS" 	SIZE 55,07 OF oDlg PIXEL
	@ 005,050 MSGET cPar 		SIZE 50,10 OF oDlg PIXEL //PICTURE "@R 99.999.999/9999-99"
	
	//@ 005,010 MSGET cCNPJ SIZE 55,11 OF oDlg PIXEL PICTURE “@R 99.999.999/9999-99”;
	
	@ 50,50 BUTTON "Gravar" SIZE 20, 10 PIXEL OF oDlg ACTION ( fGrava(cPar) )
	
	DEFINE SBUTTON FROM 50, 150 TYPE 2 ACTION (nOpca := 2, oDlg:End()) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If lCon
		RESET ENVIRONMENT
	EndIf	
	

Return ( NIL )

// ---------------------------------------------------------------

Static Function fGrava(pPar)

	PutMv("MV_DATAFIS",pPar)
	MsgInfo("Parâmetro Gravado com Sucesso!","Atenção")

Return ( NIL )
