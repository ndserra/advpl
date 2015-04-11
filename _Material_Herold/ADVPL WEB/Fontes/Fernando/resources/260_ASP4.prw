#Include "APWEBEX.CH"

//----------------------------------------------------------------------------//
// Uso de variaveis SESSION. Comandos AdvPL dentro do HTML.
//----------------------------------------------------------------------------//
User Function ASP4()

Local cHtml := ""

WEB EXTENDED INIT cHtml

	HttpSession->dData := Date()
	HttpSession->cHora := Time()
	
	HttpSession->aSemana := {"Domingo", "Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sábado"}
	
	cHtml += H_265_ASP4()
	
WEB EXTENDED END

Return( cHtml )
