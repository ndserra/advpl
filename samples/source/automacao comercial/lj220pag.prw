/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºP.Entrada ³LJ220PAG  ºAutor  ³Andre Alves Veiga   º Data ³  03/08/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada que pode ser utilizado para definir a      º±±
±±º          ³forma de pagto do cupom na venda rápida e na venda balcao.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³Se for utilizado dentro do SCRFIS.PRW (rdmake para impressaoº±±
±±º          ³de cupons) a array aParcelas deve ser trocada pela aReceb.  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LJ220PAG()

Local aFormPag := {}
Local aTotForm := {} // array com os totais a pagar
Local sFormaPagto := ''
Local nTrocoAux := ParamIXB[1]

// array com as formas de pagamento que estao cadastradas no ECF
// devera ser alterada conforme a necessidade do cliente
aAdd(aFormPag, { 'DINHEIRO',GetMv('MV_SIMB1') } )
aAdd(aFormPag, { 'CHEQUE','CH' } )
aAdd(aFormPag, { 'FINANCIADO','FI' } )
aAdd(aFormPag, { 'VALES','VA' } )
aAdd(aFormPag, { 'CONVENIO','CO' } )
aAdd(aFormPag, { 'CARTAO','CC' } )
aAdd(aFormPag, { 'CART.DEBITO','CD' } )


aTotForm := Array( Len(aFormPag) )
aFill( aTotForm,0 )

For i := 1 To Len(aParcelas)

	nPos := 	AScan(aFormPag, {|x| Upper(x[2])==Upper(Alltrim(aParcelas[i][3]))})

	if aParcelas[i][3] $ GetMv('MV_SIMB1')+',VA'
		aTotForm[nPos] += aParcelas[i][2] + nTrocoAux
		nTrocoAux := 0
	else
		aTotForm[nPos] += aParcelas[i][2]
	Endif
	
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registra o pagamento da venda                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
sFormaPagto := ''
For i:=1 to Len(aFormPag)
	If aTotForm[i] > 0
		sFormaPagto := sFormaPagto + aFormPag[i][1] + '|' + Alltrim(Str(aTotForm[i],14,2)) + '|'
	Endif
Next i

Return sFormaPagto 
