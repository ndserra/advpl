User Function TstBloc1()

Local bBloco := {|x| x * 2}
Local nResult
Local i

For i := 1 To 10

    nResult := EVal(bBloco, i)

    Alert(nResult)

Next

Return Nil

//-----------------------------------------------------------------------------//
User Function TstBloc2()

Local bBloco := {|x,y|If(x>y,"Maior","Menor")}

MsgAlert(EVal(bBloco, 2, 4))
MsgAlert(EVal(bBloco, 5, 3))

Return Nil

//-----------------------------------------------------------------------------//
User Function TstBloc3()

Local x
Local y
Local bBloco := {|| x := 10, y := 20}

MsgAlert(EVal(bBloco))

Return Nil

//-----------------------------------------------------------------------------//
User Function TstBloc4()

Local x
Local y
Local cBloco := "{|| x := 10, y := 20}"
Local bBloco

bBloco := &cBloco

MsgAlert(EVal(bBloco))

Return Nil
