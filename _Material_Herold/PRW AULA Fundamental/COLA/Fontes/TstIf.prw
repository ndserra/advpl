User Function TstIf()

Local nX := 10

If nX > 5
   MsgAlert("Maior")
EndIf

Return

//----------------------------------------------------------------------------------------------------------------//
User Function TstElse()

Local nX := 10
Local cMsg

If nX < 5
   cMsg := "Maior"
 Else
   cMsg := "Menor"
EndIf

MsgAlert(cMsg)

Return

//----------------------------------------------------------------------------------------------------------------//
User Function TstElseIf()

Local cRegiao := "NE"
Local nICMS

If cRegiao == "SE"
   nICMS := 18
 ElseIf cRegiao == "NE"
   nICMS := 7
 Else
   nICMS := 12
EndIf

MsgAlert(nICMS)

Return
