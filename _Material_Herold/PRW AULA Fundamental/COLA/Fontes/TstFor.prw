User Function TstFor()

Local i

For i := 1 To 10
    MsgAlert(i)
Next

Return

//----------------------------------------------------------------------------------------------------------------//
User Function TstFor1()

Local i
Local nIni, nFim

nIni := 100
nFim := 120

For i := nIni To nFim Step 2
    MsgAlert(i)
    If i > 110
       Exit      // Break tambem encerra.
    EndIf
Next

Return

//----------------------------------------------------------------------------------------------------------------//
User Function TstFor2()

Local i
Local nIni, nFim

nIni := 1
nFim := 10

For i := nFim To nIni Step -1
    MsgAlert(i)
Next

Return

//----------------------------------------------------------------------------------------------------------------//
User Function TstFor3()

Local i
Local j

For i := 20 To 25
    MsgAlert("i=" + Str(i))
    For j := 1 To 5
        MsgAlert("i=" + Str(i) + "   j=" + Str(j))
    Next
Next

Return
