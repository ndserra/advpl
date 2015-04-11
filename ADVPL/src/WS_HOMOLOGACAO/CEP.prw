#Include 'Protheus.ch'

User Function CEP()

	Local cCEP 	:= "02012021"
	Local url		:= "viacep.com.br/ws/" + cCEP +"/xml/"
	Local cRetorno
	Local oXML		:= Nil
	
	Local cError := ""
	Local cWarning := ""
	
	cRetorno := HTTPGET(url)
	
	oXML := XmlParser( cRetorno, "_", @cError, @cWarning )
	
	MsgInfo(cRetorno)

Return ( Nil )

