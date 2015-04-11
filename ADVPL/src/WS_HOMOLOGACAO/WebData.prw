#Include 'Protheus.ch'

User Function WebData()

Local oXML := NIL
Local xData
Local xH


oXML := WSLISTA_DATA():NEW()

oXML:MOSTRAHORA("  ")
oXML:MOSTRADATA("  ")

MsgInfo("Data: " + oXML:MOSTRADATARESULT )

MsgInfo( "Hora: " + oXML:MOSTRAHORARESULT )

MsgInfo("x")

Return

