User function WSHISTSAL()

Local nX := 0
Local cArqSR3	:="\\DADOSCORP-ADS\SIGA2000\AP5RH\DADOSRH\SR3010" 
Local cArqSR7	:="\\DADOSCORP-ADS\SIGA2000\AP5RH\DADOSRH\SR7010" 

//Local cArqSR3	:="\\emerson-rocha\mp8_old\data\SR3010"
//Local cArqSR7	:="\\emerson-rocha\mp8_old\data\SR7010"

SR3->(dbCloseArea())
SR7->(dbCloseArea())

For nX := 1 to 3
	dbUseArea(.T.,__LocalDriver,cArqSR3 ,"SR3",.T.,.T.)
	If Used()
		Exit
	EndIf
Next nX

For nX := 1 to 3
	dbUseArea(.T.,__LocalDriver,cArqSR7 ,"SR7",.T.,.T.)
	If Used()
		Exit
	EndIf
Next nX

dbSelectArea("SR3")
dbSetOrder(1) 

dbSelectArea("SR7") 
dbSetOrder(1)

Return Nil
