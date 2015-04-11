// Passagem de parametros por Valor e por Referencia.

User Function TstParam()

Local i := 1
Local j := 2
Local x

x := Teste2(@i, j)

MsgAlert(Teste2(i, j))

Return



Static Function Teste2(a, b)

Local nRetorno

a := 5
b := 10

nRetorno := a + b

Return nRetorno
