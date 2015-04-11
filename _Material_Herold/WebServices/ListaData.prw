#Include 'Protheus.ch'
#Include "apWebSRV.ch"



WSService LISTA_DATA Description "Mostra a Data de Hoje"

	WsData dData     as String 
	WsData Parametro as String
	WsData cHora     as String
	
 	WsMethod MostraData Description "Informa a Data"
 	WsMethod MostraHora Description "Informa a Hora"
 	
 
 EndWSService
 	
WsMethod MostraData WsReceive Parametro WsSend dData WsService LISTA_DATA  
 
 ::dData := Dtos( Date() ) 

Return .T. 


WsMethod MostraHora WsReceive Parametro WsSend cHora WsService LISTA_DATA  
 
 ::cHora := Time()


Return .T. 

