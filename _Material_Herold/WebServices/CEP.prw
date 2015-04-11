#Include 'Protheus.ch'

User Function CEP()

Local cCep := M->A1_CEP
Local  url := "viacep.com.br/ws/"+cCep+"/xml/"
Local cRetorno   
Local oXml := Nil 

Local cError   := ""
Local cWarning := ""


cRetorno := HTTPGET(url)

oXml := XmlParser( cRetorno, "_", @cError, @cWarning )


M->A1_EST := oXml:_XMLCEP:_UF:TEXT
M->A1_END := oXml:_XMLCEP:_LOGRADOURO:TEXT
M->A1_MUN := oXml:_XMLCEP:_LOCALIDADE:TEXT   
M->A1_COD_MUN := oXml:_XMLCEP:_IBGE:TEXT
//oXml:_XMLCEP:_BAIRRO:TEXT



Return( .T. )