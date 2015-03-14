#include "protheus.ch"
#include "report.ch"

User Function Report3()
Local oReport
Local oSA1
Local oSC5
Local oSC6

Pergunte("REPORT",.F.)

DEFINE REPORT oReport NAME "REPORT3" TITLE "Pedidos de Venda" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}

	DEFINE SECTION oSA1 OF oReport TITLE "Cliente" TABLES "SA1"

		DEFINE CELL NAME "A1_COD" OF oSA1 ALIAS "SA1"
		DEFINE CELL NAME "A1_NOME" OF oSA1 ALIAS "SA1"
		DEFINE CELL NAME "A1_VEND" OF oSA1 ALIAS "SA1"
		DEFINE CELL NAME "A1_MCOMPRA" OF oSA1 ALIAS "SA1"

	DEFINE SECTION oSC5 OF oSA1 TITLE "Pedido" TABLE "SC5"

		DEFINE CELL NAME "NUM" OF oSC5 TITLE "Pedido" SIZE 10
		DEFINE CELL NAME "C5_NUM" OF oSC5 ALIAS "SC5"
		DEFINE CELL NAME "C5_TIPO" OF oSC5 ALIAS "SC5"
		DEFINE CELL NAME "C5_VEND1" OF oSC5 ALIAS "SC5"

		DEFINE FUNCTION FROM oSC5:Cell("C5_NUM") OF oSA1 FUNCTION COUNT TITLE "Pedidos"


		DEFINE SECTION oSC6 OF oSC5 TITLE "Itens" TABLE "SC6","SB1" TOTAL TEXT "Valor total do pedido" TOTAL IN COLUMN

			DEFINE CELL NAME "C6_ITEM" OF oSC6 ALIAS "SC6"
			DEFINE CELL NAME "C6_PRODUTO" OF oSC6 ALIAS "SC6"
			DEFINE CELL NAME "B1_DESC" OF oSC6 ALIAS "SB1"
			DEFINE CELL NAME "B1_GRUPO" OF oSC6 ALIAS "SB1"
			DEFINE CELL NAME "C6_UM" OF oSC6 ALIAS "SC6"
			DEFINE CELL NAME "C6_QTDVEN" OF oSC6 ALIAS "SC6"
			DEFINE CELL NAME "C6_PRCVEN" OF oSC6 ALIAS "SC6"
			DEFINE CELL NAME "C6_VALOR" OF oSC6 ALIAS "SC6"
			
			DEFINE FUNCTION FROM oSC6:Cell("C6_ITEM") FUNCTION COUNT END PAGE
			DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION SUM
			DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MAX TITLE "Maior Valor"
			DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MIN NO END SECTION TITLE "Menor Valor"
			DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION AVERAGE NO END SECTION TITLE "Valor Médio"

oReport:PrintDialog()
Return

Static Function PrintReport(oReport)

MakeAdvplExpr("REPORT")
	
DbSelectArea("SA1")
DbSetOrder(1)
	
If ( !Empty(mv_par01) )
	oReport:Section(1):SetFilter(mv_par01)
EndIf
	
oReport:Section(1):Section(1):SetRelation({|| xFilial("SC5")+SA1->A1_COD},"SC5",3,.T.)
oReport:Section(1):Section(1):SetParentFilter({|cParam| SC5->C5_CLIENTE == cParam},{|| SA1->A1_COD})

oReport:Section(1):Section(1):Section(1):SetRelation({|| xFilial("SC6")+SC5->C5_NUM},"SC6",1,.T.)
oReport:Section(1):Section(1):Section(1):SetParentFilter({|cParam| SC6->C6_NUM == cParam},{|| SC5->C5_NUM})
	
TRPosition():New(oReport:Section(1):Section(1):Section(1),"SB1",1,{|| xFilial("SB1")+SC6->C6_PRODUTO})
oReport:Section(1):Section(1):Section(1):SetLineCondition({|| SB1->B1_GRUPO >= MV_PAR02 .and. SB1->B1_GRUPO <= MV_PAR03})

oReport:Section(1):Print()
Return