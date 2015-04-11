#Include 'Protheus.ch'

User Function WebData()


Local oXML := NIL

oXML := WSLISTA_DATA():NEW()

oXML:MOSTRADATA(" ")
oXML:MOSTRAHORA(" ")
	

msginfo("Data: " + oXML:CMOSTRADATARESULT	)
msginfo("HORA: " + oXML:CMOSTRAHORARESULT	)




Return

