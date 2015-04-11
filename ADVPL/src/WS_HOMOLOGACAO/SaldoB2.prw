#Include 'Protheus.ch'
#Include 'apWebSRV.ch'

WSService xMOstraSaldo Description "Saldo de produtos de SB2."
		
	WsData Saldo 		as Float
	WsData Produto 	as String
	
	WsMethod MostraSaldo Description "Informa o Saldo"
	
EndWSService	


WsMethod MostraSaldo WsReceive Produto WsSend Saldo WsService xMostraSaldo 

dbSelectArea('SB2')// Seleciona Tabela SB2 (Produtos)
dbSetOrder(1) // Seleciona o Index 1: Filial + Codigo

if SB2->( dbSeek(xFILIAL("SB2") + Produto) )
	::Saldo := SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QEMP // SALDO=QTD.ATUAL-QTD.RESERVADA-QTD.EMPENHADA
Else
	::Saldo := 0
EndIf



Return .T.

