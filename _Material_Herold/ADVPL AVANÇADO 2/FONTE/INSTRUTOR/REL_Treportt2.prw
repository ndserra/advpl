
#include "protheus.ch"

User Function Treport12()
Local oReport

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	Pergunte("MTR025",.F.)
	
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf                  

Return( NIL )

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function ReportDef()
Local oReport
Local oSection

oReport := TReport():New("MATR025","Relacao das Sugestoes de Orcamentos","MTR025",{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir a relacao das Sugestoes de Venda conforme os parametros solicitados.")

oSection := TRSection():New(oReport,OemToAnsi("Sugestoes de Orcamentos"),{"SBG","SBH","SB1"})

TRCell():New(oSection,"BG_PRODUTO","SBG")
TRCell():New(oSection,"B1_DESC","SB1")
TRCell():New(oSection,"BG_GERAPV","SBG")
TRCell():New(oSection,"BG_GERAOP","SBG")
TRCell():New(oSection,"BG_GERAOPI","SBG")
TRCell():New(oSection,"BG_GERAEMP","SBG")
TRCell():New(oSection,"BH_SEQUENC","SBH")
TRCell():New(oSection,"BH_CODCOMP","SBH")
TRCell():New(oSection,"B1_DESC","SB1")
TRCell():New(oSection,"BH_QUANT","SBH")

Return oReport

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)

DbSelectArea("SBG")
DbSetOrder(1)
DbSeek(xFilial()+MV_PAR01,.T.)

oReport:SetMeter(RecCount())

While ( !Eof() .And. xFilial("SBG") == SBG->BG_FILIAL .And. ;
	SBG->BG_PRODUTO >= MV_PAR01 .And. ;
	SBG->BG_PRODUTO <= MV_PAR02 )
	
	If oReport:Cancel()
		Exit
	EndIf
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+SBG->BG_PRODUTO)
	
	oSection:Init()
	
	oSection:Cell("B1_DESC"):SetValue(SB1->B1_DESC)
	
	oSection:Cell("BG_PRODUTO"):Show()
	oSection:Cell("B1_DESC"):Show()
	oSection:Cell("BG_GERAPV"):Show()
	oSection:Cell("BG_GERAOP"):Show()
	oSection:Cell("BG_GERAOPI"):Show()
	oSection:Cell("BG_GERAEMP"):Show()
	
	dbSelectArea("SBH")
	dbSetOrder(1)
	dbSeek(xFilial("SBH")+SBG->BG_PRODUTO,.T.)
	
	While ( !Eof() .And. SBH->BH_FILIAL == xFilial("SBH") .And.;
		SBH->BH_PRODUTO == SBG->BG_PRODUTO )
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SBH->BH_CODCOMP)
		
		oSection:PrintLine()
		
		oSection:Cell("BG_PRODUTO"):Hide()
		oSection:Cell("B1_DESC"):Hide()
		oSection:Cell("BG_GERAPV"):Hide()
		oSection:Cell("BG_GERAOP"):Hide()
		oSection:Cell("BG_GERAOPI"):Hide()
		oSection:Cell("BG_GERAEMP"):Hide()
		
		dbSelectArea("SBH")
		dbSkip()
	EndDo
	
	DbSelectArea("SBG")
	DbSkip()
	
	oSection:Finish()
	
	oReport:SkipLine()
	oReport:IncMeter()
EndDo
Return
