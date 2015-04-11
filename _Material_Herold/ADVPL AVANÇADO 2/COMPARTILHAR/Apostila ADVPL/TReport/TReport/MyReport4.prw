/*
TReport usando método TRSection:SetParentQuery 
Revisão: 03/05/2006
Abrangência
Versão 8.11
Para utilizar o exemplo abaixo verifique se o seu repositório está com Release 4 do Protheus
*/

#include "protheus.ch"

User Function MyReport4()
Local oReport

If TRepInUse()
	Pergunte("MTR530",.F.)

	oReport := ReportDef()
	oReport:PrintDialog()	
EndIf
Return

Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2

oReport := TReport():New("MYREPORT","Relatorio de Visitas","MTR530",{|oReport| PrintReport(oReport)},"Relatorio de visitas de vendedores nos clientes")

oSection1 := TRSection():New(oReport,"Vendedores","SA3")

TRCell():New(oSection1,"A3_COD","SA3","Vendedor")
TRCell():New(oSection1,"A3_NOME","SA3")

TRFunction():New(oSection1:Cell("A3_COD"),NIL,"COUNT",NIL,NIL,NIL,NIL,.F.)

oSection2 := TRSection():New(oSection1,"Clientes","SA1")

TRCell():New(oSection2,"A1_COD","SA1","Cliente")
TRCell():New(oSection2,"A1_LOJA","SA1")
TRCell():New(oSection2,"A1_NOME","SA1")
TRCell():New(oSection2,"A1_ULTVIS","SA1")
TRCell():New(oSection2,"A1_TEMVIS","SA1")
TRCell():New(oSection2,"A1_CONTATO","SA1")
TRCell():New(oSection2,"A1_TEL","SA1")

TRFunction():New(oSection2:Cell("A1_COD"),NIL,"COUNT")
TRFunction():New(oSection2:Cell("A1_TEMVIS"),NIL,"SUM")

Return oReport

Static Function PrintReport(oReport)
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cFiltro   := ""

#IFDEF TOP

	oSection1:BeginQuery()

	If ( mv_par03 == 1 )
		cPart := "%AND (" + Dtos(dDataBase) + " - A1_ULTVIS) > A1_TEMVIS%"
	Else
		cPart := "%%"
	EndIf
		
	BeginSql alias "QRYSA3"
		SELECT A1_COD,A1_LOJA,A1_NOME,A1_VEND,A1_ULTVIS,A1_TEMVIS,A1_TEL,A1_CONTATO,A3_NOME,A3_COD
		FROM %table:SA1% SA1,%table:SA3% SA3        
		WHERE A1_VEND = A3_COD AND A1_FILIAL = %xfilial:SA1% AND
			  A1_TEMVIS > 0 AND SA1.%notDel%
		ORDER BY A1_VEND
	EndSql

	/*
	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 
	pela funcao MakeSqlExpr para serem adicionados a query
	*/
	oSection1:EndQuery(mv_par04)

	oSection2:SetParentQuery()
	oSection2:SetParentFilter({|cParam| QRYSA3->A1_VEND >= cParam .and. QRYSA3->A1_VEND <= cParam},{|| QRYSA3->A3_COD})

#ELSE

	cFiltro := " A1_TEMVIS > 0 "

	If ( mv_par03 == 1 )
		cFiltro += ' .AND. ('+DtoC(dDataBase)+'-A1_ULTVIS) > A1_TEMVIS'
	EndIf
	
	oSection2:SetFilter(cFiltro,"A1_VEND")
	oSection2:SetRelation({|| SA3->A3_COD})
	oSection2:SetParentFilter({|cParam| SA1->A1_VEND >= cParam .and. SA1->A1_VEND <= cParam},{|| SA3->A3_COD})
	
#ENDIF	

oSection1:Print()

Return
