#INCLUDE "TOTVS.CH"                  


User Function MT010INC() 

Local aAreaSB1 := GetArea()   

If MsgYESNO("Deseja cadastrar o Complemento do Registro ?","ATENÇÃO !!!!")
	
	dbSelectarea("SB5")
	dbSetOrder(1)
	
	If dbSeek( xFilial("SB1")+SB1->B1_COD )
	   RecLock("SB5",.F.)
	Else
		RecLock("SB5",.T.)   
	EndIf	
	
	SB5->B5_FILIAL := SB1->B1_FILIAL
	SB5->B5_COD    := SB1->B1_COD
	SB5->B5_CEME   := SB1->B1_DESC
	                                                                      
	MsUnLock()
                                                                         
EndIf	

MsgInfo("Produto : " + SB1->B1_COD + "Cadastrado com Sucesso!!","Atenção!!!")
	
RestArea(aAreaSB1)       

Return( NIL )