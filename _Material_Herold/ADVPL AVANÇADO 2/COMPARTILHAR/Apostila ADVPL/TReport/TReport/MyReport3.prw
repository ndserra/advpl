/*
TReport usando método TRSection:Print com 1 seção 
Revisão: 03/05/2006
 

Abrangência

Versão 8.11
 


Para utilizar o exemplo abaixo verifique se o seu repositório está com Release 4 do Protheus
*/
#include "protheus.ch"

User Function MyReport3()
Local oReport

If TRepInUse()
	Pergunte("MTR530",.F.)

	oReport := ReportDef()
	oReport:PrintDialog()	
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak

oReport := TReport():New("MYREPORT","Relatorio de Visitas","MTR530",{|oReport| PrintReport(oReport)},"Relatorio de visitas de vendedores nos clientes")

oSection := TRSection():New(oReport,"Clientes",{"SA1","SA3"})

TRCell():New(oSection,"A1_VEND","SA1")
TRCell():New(oSection,"A3_NOME","SA3")
TRCell():New(oSection,"A1_COD","SA1","Cliente")
TRCell():New(oSection,"A1_LOJA","SA1")
TRCell():New(oSection,"A1_NOME","SA1")
TRCell():New(oSection,"A1_ULTVIS","SA1")
TRCell():New(oSection,"A1_TEMVIS","SA1")
TRCell():New(oSection,"A1_CONTATO","SA1")
TRCell():New(oSection,"A1_TEL","SA1")

oBreak := TRBreak():New(oSection,oSection:Cell("A1_VEND"),"Sub Total Vendedores")

TRFunction():New(oSection:Cell("A1_COD"),NIL,"COUNT",oBreak)
TRFunction():New(oSection:Cell("A1_TEMVIS"),NIL,"SUM",oBreak)

Return oReport

Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)
Local cPart
Local cFiltro   := ""

#IFDEF TOP

	//Transforma parametros do tipo Range em expressao SQL para ser utilizada na query 
	MakeSqlExpr("MTR530")

	oSection:BeginQuery()

	If ( mv_par03 == 1 )
		cPart := "%AND (" + Dtos(dDataBase) + " - A1_ULTVIS) > A1_TEMVIS%"
	Else
		cPart := "%%"
	EndIf
		
	BeginSql alias "QRYSA1"
		SELECT A1_COD,A1_LOJA,A1_NOME,A1_VEND,A1_ULTVIS,A1_TEMVIS,A1_TEL,A1_CONTATO,A3_NOME
		FROM %table:SA1% SA1,%table:SA3% SA3        
		WHERE A1_VEND = A3_COD AND A1_FILIAL = %xfilial:SA1% AND
			  A1_TEMVIS > 0 AND SA1.%notDel% %exp:cPart%
		ORDER BY A1_VEND
	EndSql

	/*
	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 
	pela funcao MakeSqlExpr para serem adicionados a query
	*/
	oSection:EndQuery(mv_par04)

#ELSE

	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	MakeAdvplExpr("MTR530")

	//Adiciona no filtro o parametro tipo Range
	If !Empty(mv_par04)
		cFiltro += mv_par04 + " .AND. "
	EndIf

	cFiltro += " A1_TEMVIS > 0 "

	If ( mv_par03 == 1 )
		cFiltro += ' .AND. ('+DtoC(dDataBase)+'-A1_ULTVIS) > A1_TEMVIS'
	EndIf

	oSection:SetFilter(cFiltro,"A1_VEND")
	
	TRPosition():New(oReport:Section(1),"SA3",1,{|| xFilial() + SA1->A1_VEND})
	
#ENDIF	

oSection:Print()

Return
