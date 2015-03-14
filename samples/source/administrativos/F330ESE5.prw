/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F330ESE5 ºAutor  ³Fabricio Pequeno     º Data ³  10/13/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para que o registro na SE5 seja           º±±
±±º          ³ posicionado corretamente quando existir diferenças no 	  º±±
±±º          ³ tamanho dos campos envolvidos no indice do SEEK.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F330ESE5()

Local nZ		:= 0
Local nY		:= 0
Local aSeek		:= {}
Local nCont		:= 1
Local cBusca	:= ""
Local cBusca5	:= ""
Local cOpc5		:= ""

//-- Passado por parâmetro do fonte FINA330
Local aLstDOC2	:= PARAMIXB[1]
Local cTipoDoc2	:= PARAMIXB[2]
Local nTamTit2	:= PARAMIXB[3]
Local nTamTip2	:= PARAMIXB[4]
Local nI		:= PARAMIXB[5]

//-- Tratamento incluido para que seja buscado o tamanho do campo no SX3 para completar o campo com espaços "  "
//-- para que a busca seja feita corretamente.
//-- Indice de busca: 2-E5_FILIAL + E5_TIPODOC + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_DATA + E5_CLIFOR + E5_LOJA + E5_SEQ
Aadd(aSeek, {"E5_FILIAL",TamSX3("E5_FILIAL")[1]})
Aadd(aSeek, {"E5_TIPODOC",TamSX3("E5_TIPODOC")[1]})
Aadd(aSeek, {"E5_PREFIXO",TamSX3("E5_PREFIXO")[1]})
Aadd(aSeek, {"E5_NUMERO",TamSX3("E5_NUMERO")[1]})
Aadd(aSeek, {"E5_PARCELA",TamSX3("E5_PARCELA")[1]})
Aadd(aSeek, {"E5_TIPO",TamSX3("E5_TIPO")[1]})
Aadd(aSeek, {"E5_DATA",TamSX3("E5_DATA")[1]})
Aadd(aSeek, {"E5_CLIFOR",TamSX3("E5_CLIFOR")[1]})
Aadd(aSeek, {"E5_LOJA",TamSX3("E5_LOJA")[1]})
Aadd(aSeek, {"E5_SEQ",TamSX3("E5_SEQ")[1]})

For nZ := 1 to Len(aSeek)
	If nZ == 4
		//-- Se o próximo caractere for alfabético, pois não é mais o E5_NUMERO
		If (ISALPHA(SubStr(aLstDOC2[nI][1] + cTipoDoc2 + Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2),nCont+9,aSeek[6][2])))
			cBusca += SubStr(SubStr(aLstDOC2[nI][1] + cTipoDoc2 + Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2),nCont,aSeek[nZ][2]),1,Len(SubStr(aLstDOC2[nI][1] + cTipoDoc2 + Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2),nCont,aSeek[nZ][2]))-TamSX3("E5_TIPO")[1])
			cOpc5 := SubStr(SubStr(aLstDOC2[nI][1] + cTipoDoc2 + Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2),nCont,aSeek[nZ][2]),1,Len(SubStr(aLstDOC2[nI][1] + cTipoDoc2 + Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2),nCont,aSeek[nZ][2]))-TamSX3("E5_TIPO")[1])
			//-- Adciona " " espaços em branco para preencher a quantidade do campo E5_NUMERO
			cBusca += REPLICATE(" ", TamSX3("E5_NUMERO")[1]-Len(SubStr(SubStr(aLstDOC2[nI][1] + cTipoDoc2 + Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2),nCont,aSeek[nZ][2]),1,Len(SubStr(aLstDOC2[nI][1] + cTipoDoc2 + Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2),nCont,aSeek[nZ][2]))-TamSX3("E5_TIPO")[1])))
		EndIf
	ElseIf nZ == 5	
		For nY := 0 to 2
			//-- Se o próximo caractere for alfabético, pois não é mais o E5_PARCELA
			If (ISALPHA(Substr(Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2),AT(cOpc5,aLstDOC2[nI][2])+Len(cOpc5)+nY,TamSX3("E5_PARCELA")[1])))
				cBusca5 += Substr(Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2),AT(cOpc5,aLstDOC2[nI][2])+Len(cOpc5)+nY-1,TamSX3("E5_PARCELA")[1])
				//-- Adciona " " espaços em branco para preencher a quantidade do campo E5_PARCELA
				cBusca5 += REPLICATE(" ", TamSX3("E5_PARCELA")[1]-Len(Substr(Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2),AT(cOpc5,aLstDOC2[nI][2])+Len(cOpc5)+nY-1,TamSX3("E5_PARCELA")[1])))
				nY := 2
				nZ := Len(aSeek)
				cBusca5 += Substr(Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2),AT(cOpc5,aLstDOC2[nI][2])+Len(cOpc5)+TamSX3("E5_PARCELA")[1],Len(Substr(aLstDOC2[nI][2],1,nTamTit2+nTamTip2)))		
			EndIf
		Next
		If !Empty(cBusca5)
			cBusca += cBusca5
			cBusca += Substr(AllTrim(aLstDOC2[nI][2]),AT(cOpc5,aLstDOC2[nI][2])+Len(cOpc5),Len(AllTrim(aLstDOC2[nI][2])))
		Else
			cBusca += Substr(AllTrim(aLstDOC2[nI][2]),AT(cOpc5,aLstDOC2[nI][2])+Len(cOpc5),Len(AllTrim(aLstDOC2[nI][2])))
			nZ := Len(aSeek)
		EndIf
	Else
		cBusca += Substr(aLstDoc2[nI][1] + cTipoDoc2 + Substr(aLstDoc2[nI][2],1,nTamTit2+nTamTip2),Iif(nZ==1,1,nCont),aSeek[nZ][2])
	EndIf
	nCont := nCont+aSeek[nZ][2]
Next

SE5->(dbSeek(Substr(cBusca,1,Len(cBusca)-2)))

Return Nil