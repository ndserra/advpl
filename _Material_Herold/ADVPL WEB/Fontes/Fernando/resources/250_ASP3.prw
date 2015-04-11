#Include "APWEBEX.CH"

//----------------------------------------------------------------------------//
// Metodo GET.
//----------------------------------------------------------------------------//
User Function ASP3()

Local cHtml := ""

WEB EXTENDED INIT cHtml

If !Empty(HttpGet->Campo1)
   ConOut(HttpGet->Campo1)       // Exibe na Console do Servidor.
Endif

cHtml := H_255_ASP3()

WEB EXTENDED END

Return(cHtml)
