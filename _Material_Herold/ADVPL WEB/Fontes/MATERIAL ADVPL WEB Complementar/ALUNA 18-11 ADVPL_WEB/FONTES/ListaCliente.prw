#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

User Function LisTaCliente()

Local cHtml := ""
Local cAlias2 := "SA1"
Local aCliente := {}
Local aHeader := {}

If Select("SX2") == 0
  Prepare Environment Empresa '99' Filial '01' Tables 'SA1'
EndIf                                                                          

WEB EXTENDED INIT cHtml

	HTTPSESSION->aHeader  := {}
	HTTPSESSION->aCliente := {}

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAlias2)
		
	While ! SX3->(EOF()) .And. SX3->X3_ARQUIVO == cAlias2
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. X3Obrigat(SX3->X3_CAMPO) 
		      AADD( aHeader, { Trim( X3Titulo() ) ,	SX3->X3_CAMPO })    
		Endif
	   SX3->(dbSkip())
	EndDo
		
	dbSelectArea("SA1")
	SA1->( dbSetOrder(1) )
	SA1->( dbGoTop())
	
	While ! SA1->( EOF() ) 
		
		AADD( aCliente, Array( Len( aHeader ) ) ) 
		
		For x := 1 To Len(aHeader)
								
			aCliente[Len(aCliente),x] := &("SA1->" + aHeader[x,2]) 
									 			  			           
		Next x
		
		SA1->(dbSkip())
	
	EndDo

	HTTPSESSION->aHeader  := aHeader
	HTTPSESSION->aCliente := aCliente			
		
	cHtml := H_LisTaCliente()

WEB EXTENDED END

Return( cHtml )