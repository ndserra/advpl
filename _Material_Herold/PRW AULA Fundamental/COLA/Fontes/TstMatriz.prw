User Function TstMatriz()

Local aMatriz := {"Joao", "Alberto", "Pedro", "Maria"}

AEval(aMatriz, {|x| MsgAlert(x)})

ASort(aMatriz)

MsgAlert("Depois do SORT")

AEval(aMatriz, {|x| MsgAlert(x)})

Return Nil

//---------------------------------------------------------------]
User Function TstMatr1()

Local aMatriz := {{"Joao",15}, {"Alberto",20}, {"Pedro",10}, {"Maria",30}}

ASort(aMatriz,,,{|aX,aY| aX[2] < aY[2]})

Return Nil

//---------------------------------------------------------------]
User Function TstMatr2()

Local nItem
Local aMatriz := {"Joao", "Alberto", "Pedro", "Maria"}

nItem := AScan(aMatriz, "Pedro")

MsgAlert(nItem)

Return Nil

//---------------------------------------------------------------]
User Function TstMatr3()

Local aMatriz := {{"Joao",15}, {"ALBERTO",20}, {"Pedro",10}, {"Maria",30}}

//nItem := AScan(aMatriz, {|aX| aX[1] == "Alberto"})
nItem := AScan(aMatriz, {|aX| aX[1] == Upper("Alberto")})

MsgAlert(nItem)

Return Nil

//---------------------------------------------------------------]
User Function TstClone()

Local aMatriz := {"Joao", "Alberto", "Pedro", "Maria"}
Local aCopia

aCopia := aMatriz

aCopia[1] := "AAAA"
aCopia[2] := "BBBB"
aCopia[3] := "CCCC"
aCopia[4] := "DDDD"

aMatriz := {"Joao", "Alberto", "Pedro", "Maria"}

aCopia := AClone(aMatriz)

aCopia[1] := "AAAA"
aCopia[2] := "BBBB"
aCopia[3] := "CCCC"
aCopia[4] := "DDDD"

Return Nil
