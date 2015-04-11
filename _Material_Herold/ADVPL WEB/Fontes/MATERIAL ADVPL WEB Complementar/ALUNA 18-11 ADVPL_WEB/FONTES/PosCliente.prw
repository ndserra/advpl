#INCLUDE 'PROTHEUS.CH'
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

User Function PosCliente()

	Local cHtml := ""
	Local cPos  := 0
	WEB EXTENDED INIT cHtml
		
		HTTPSESSION->cPos := AScan(HTTPSESSION->aCliente,{|x| Trim(x[1])== HTTPPOST->cCodigo} )
	
		cHtml := H_VisCliente()   //ExecInPage("245_ASP2")
	
	WEB EXTENDED END
	
		
	
Return( cHtml )
