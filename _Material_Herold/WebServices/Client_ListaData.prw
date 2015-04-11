#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:888/ws/LISTA_DATA.apw?WSDL
Gerado em        04/11/15 14:40:24
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _GFLJXPJ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSLISTA_DATA
------------------------------------------------------------------------------- */

WSCLIENT WSLISTA_DATA

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD MOSTRADATA
	WSMETHOD MOSTRAHORA

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cPARAMETRO                AS string
	WSDATA   cMOSTRADATARESULT         AS string
	WSDATA   cMOSTRAHORARESULT         AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSLISTA_DATA
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.121227P-20131106] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSLISTA_DATA
Return

WSMETHOD RESET WSCLIENT WSLISTA_DATA
	::cPARAMETRO         := NIL 
	::cMOSTRADATARESULT  := NIL 
	::cMOSTRAHORARESULT  := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSLISTA_DATA
Local oClone := WSLISTA_DATA():New()
	oClone:_URL          := ::_URL 
	oClone:cPARAMETRO    := ::cPARAMETRO
	oClone:cMOSTRADATARESULT := ::cMOSTRADATARESULT
	oClone:cMOSTRAHORARESULT := ::cMOSTRAHORARESULT
Return oClone

// WSDL Method MOSTRADATA of Service WSLISTA_DATA

WSMETHOD MOSTRADATA WSSEND cPARAMETRO WSRECEIVE cMOSTRADATARESULT WSCLIENT WSLISTA_DATA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MOSTRADATA xmlns="http://localhost:888/">'
cSoap += WSSoapValue("PARAMETRO", ::cPARAMETRO, cPARAMETRO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</MOSTRADATA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:888/MOSTRADATA",; 
	"DOCUMENT","http://localhost:888/",,"1.031217",; 
	"http://localhost:888/ws/LISTA_DATA.apw")

::Init()
::cMOSTRADATARESULT  :=  WSAdvValue( oXmlRet,"_MOSTRADATARESPONSE:_MOSTRADATARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method MOSTRAHORA of Service WSLISTA_DATA

WSMETHOD MOSTRAHORA WSSEND cPARAMETRO WSRECEIVE cMOSTRAHORARESULT WSCLIENT WSLISTA_DATA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MOSTRAHORA xmlns="http://localhost:888/">'
cSoap += WSSoapValue("PARAMETRO", ::cPARAMETRO, cPARAMETRO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</MOSTRAHORA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:888/MOSTRAHORA",; 
	"DOCUMENT","http://localhost:888/",,"1.031217",; 
	"http://localhost:888/ws/LISTA_DATA.apw")

::Init()
::cMOSTRAHORARESULT  :=  WSAdvValue( oXmlRet,"_MOSTRAHORARESPONSE:_MOSTRAHORARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



