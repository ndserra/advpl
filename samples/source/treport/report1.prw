#include "protheus.ch"
#include "report.ch"

User Function Report1()
Local oReport
Local oSA1
Local oBreak

Pergunte("REPORT",.F.)

DEFINE REPORT oReport NAME "REPORT1" TITLE "Relatorio de Clientes" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}

	DEFINE SECTION oSA1 OF oReport TITLE "Cliente" TABLES "SA1"

		DEFINE CELL NAME "A1_COD" OF oSA1 ALIAS "SA1"
		DEFINE CELL NAME "A1_NOME" OF oSA1 ALIAS "SA1"
		DEFINE CELL NAME "A1_VEND" OF oSA1 ALIAS "SA1"
		DEFINE CELL NAME "A1_MCOMPRA" OF oSA1 ALIAS "SA1"
		
		DEFINE BREAK oBreak OF oSA1 WHEN oSA1:Cell("A1_VEND")
		
		DEFINE FUNCTION FROM oSA1:Cell("A1_COD") FUNCTION COUNT BREAK oBreak
		DEFINE FUNCTION FROM oSA1:Cell("A1_MCOMPRA") FUNCTION SUM BREAK oBreak

oReport:PrintDialog()
Return

Static Function PrintReport(oReport)
#IFDEF TOP
	Local cAlias := GetNextAlias()

	MakeSqlExp("REPORT")
	
	BEGIN REPORT QUERY oReport:Section(1)
	
	BeginSql alias cAlias
		SELECT A1_COD,A1_NOME,A1_VEND,A1_MCOMPRA
		FROM %table:SA1% SA1
		WHERE A1_FILIAL = %xfilial:SA1% AND SA1.%notDel%
		ORDER BY A1_FILIAL,A1_VEND
	EndSql
	
	END REPORT QUERY oReport:Section(1) PARAM mv_par01
	
	oReport:Section(1):Print()
#ENDIF
Return