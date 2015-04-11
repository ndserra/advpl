#INCLUDE "TOTVS.CH"
#INCLUDE "TopConn.CH"
#INCLUDE "APWEBEX.CH"

User Function TACSX5()
Local cHtml := ""

WEB EXTENDED INIT cHtml

cHtml := H_TACSX5()

WEB EXTENDED END

Return( cHtml )