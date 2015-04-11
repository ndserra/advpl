#Include 'Protheus.ch'
#Include "apWebSRV.ch"

WSService XMostraSaldo Description "Saldo do produto no SB2"

	
	WsData Saldo     as Float
	WsData Produto   as String
	
	
 	WsMethod MostraSaldo Description "Informa a Data"

EndWSService
 	
WsMethod MostraSaldo WsReceive Produto WsSend Saldo WsService XMostraSaldo  
 
 	dbSelectArea("SB2")
 	dbSetOrder(1) // FILIAL + CODIGO
 	If SB2->(dbSeek(xFILIAL("SB2")+Produto ))
 	 ::Saldo := SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QEMP
 	Else 
 	  ::Saldo := 0
 	EndIf
 
Return .T. 
