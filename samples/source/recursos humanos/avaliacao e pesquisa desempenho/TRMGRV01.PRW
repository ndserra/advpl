User function TRMGRV01()
Local cDescAnt 	:=ParamIxb[2]
Local lNew		:=.F.

dbSelectArea("SQT")
dbSetOrder(2)
lNew:=!dbSeek(xFilial("SQT")+cDescAnt)

RecLock("SQT",lNew)
If lNew //Inclusao
	Replace QT_FILIAL with xFilial("SQT")
	Replace QT_CURSO  with GetSX8Num("SQT","QT_CURSO")
	ConfirmSx8()
EndIf	
Replace QT_DESCRIC  with RA1->RA1_DESC
Replace QT_TIPO		with RA1->RA1_TIPOPP
dbCommit()        
MsUnLock()                                                                
RA1->(dbSkip())

Return Nil