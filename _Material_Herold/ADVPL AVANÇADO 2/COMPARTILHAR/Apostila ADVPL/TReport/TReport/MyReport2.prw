/*
TReport sem usar método TRSection:Print com seções
Revisão: 03/05/2006
Abrangência
Versão 8.11
Para utilizar o exemplo abaixo verifique se o seu repositório está com Release 4 do Protheus
*/
#include "protheus.ch"

User Function MyReport2()
Local oReport

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	Pergunte("MTR025",.F.)
	
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2

oReport := TReport():New("MATR025","Relacao das Sugestoes de Orcamentos","MTR025",{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir a relacao das Sugestoes de Venda conforme os parametros solicitados.")

oSection1 := TRSection():New(oReport,"Produtos",{"SBG","SB1"})

TRCell():New(oSection1,"BG_PRODUTO","SBG")
TRCell():New(oSection1,"B1_DESC","SB1")
TRCell():New(oSection1,"BG_GERAPV","SBG")
TRCell():New(oSection1,"BG_GERAOP","SBG")
TRCell():New(oSection1,"BG_GERAOPI","SBG")
TRCell():New(oSection1,"BG_GERAEMP","SBG")

TRPosition(oSection1,"SB1",1,{|| xFilial("SB1") + SBG->BG_PRODUTO})

oSection2 := TRSection():New(oSection1,"Componentes",{"SBH","SB1"})

TRCell():New(oSection2,"BH_SEQUENC","SBH")
TRCell():New(oSection2,"BH_CODCOMP","SBH")
TRCell():New(oSection2,"B1_DESC","SB1")
TRCell():New(oSection2,"BH_QUANT","SBH")

TRPosition(oSection2,"SB1",1,{|| xFilial("SB1") + SBH->BH_CODCOMP})

Return oReport

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)

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
	
	oSection1:Init()
	oSection1:PrintLine()
	
	dbSelectArea("SBH")
	dbSetOrder(1)
	dbSeek(xFilial("SBH")+SBG->BG_PRODUTO,.T.)
	
	oSection2:Init()
	
	While ( !Eof() .And. SBH->BH_FILIAL == xFilial("SBH") .And.;
		SBH->BH_PRODUTO == SBG->BG_PRODUTO )
		
		oSection2:PrintLine()
		
		dbSelectArea("SBH")
		dbSkip()
	End
	
	oSection2:Finish()
	
	DbSelectArea("SBG")
	DbSkip()
	
	oSection1:Finish()
	
	oReport:IncMeter()
End
Return
