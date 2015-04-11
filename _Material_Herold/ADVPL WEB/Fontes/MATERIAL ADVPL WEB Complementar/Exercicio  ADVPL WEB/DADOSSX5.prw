#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "APWEBEX.CH"

	
User Function SX5DADOS()	

Local cHtml := ""
Local cTabela := HTTPPOST->cTab	
Local cChave  := HTTPPOST->cChave

Private cDados := ""

If Select("SX2") == 0
  Prepare Environment Empresa '99' Filial '01' Tables 'SA1'
EndIf   
                    
WEB EXTENDED INIT cHtml	

SX5->( dbSetOrder(1) )
If SX5->(dbSeek( xFilial("SX5")+cTabela+cChave ))
	cDados := AllTrim(SX5->X5_DESCRI)
	HttpSession->cDados := cDados
Else	
	cHtml := "Tabela ou Chave não LOCALIZADA"
	Return( cHtml )	
EndIf

/*While ! SX5->(EOF()) .AND. SX5->X5_TABELA == cTabela .AND. SX5->X5_CHAVE == cChave 
	aAdd ( aDados, AllTrim(SX5->X5_DESCRI) )
	SX5->( dbSkip() )
EndDo
*/       

cHtml := H_SX5DADOS()

WEB EXTENDED END	
                    

RESET ENVIRONMENT	

Return( cHtml )	


