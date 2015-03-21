#Include 'Protheus.ch'
#Include 'TBICONN.ch'

User Function xMacro()


Local cAlert := "msgInfo('Macro')"
Local cSoma  := "20 + 10"
Local cCampo := "A1_COD"
Local lCon   := .F.

If Select("SX2") = 0
	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' TABLES 'SA1' MODULO "FAT"
	lCon := .T.
EndIf	

dbSelectArea("SA1")
ConOut(cCampo + " : " +  &cCampo )
 
If lCon
	RESET ENVIRONMENT
EndIf	
	

Return( NIL )

//************************************************


User Function xPar()


Local cNome := " " 

If Select("SX2") = 0
	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' TABLES 'SA1' MODULO "FAT"
	lCon := .T.
EndIf	

cNome := GetMv("XX_NOME")

MsgInfo(cNome)

PutMv("XX_NOME","NOVO VALOR")


If lCon
	RESET ENVIRONMENT
EndIf	
	


Return( NIL )






















































 