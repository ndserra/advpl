/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³DefFi2    ³ Autor ³ Claudio D. de Souza   ³ Data ³30.09.05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ocorrencias Defaults conforme a alteracao efetuada no titulo³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINANCEIRO																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DefFI2
Local aCampos	:= ParamIxb[2]
Local aDados	:= ParamIxb[3]
Local lAbatim  := ParamIxb[4]
Local lProtesto:= ParamIxb[5]
Local lCancProt:= ParamIxb[6]
Local aRet		:= {}
Local nX
If !lAbatim .And. !lProtesto .And. !lCancProt
	For nX := 1 To Len(aCampos)
		If AllTrim(aCampos[nX]) = "E1_VENCREA" .And.;
			((ValType(aDados) ="A" .And. aDados[nX] != SE1->&(aCampos[nX])) .Or.;
			(M->&(aCampos[nX]) != SE1->&(aCampos[nX])))
			If SE1->E1_PORTADO = "237"
				Aadd(aRet, { "E1_VENCREA", { || "06" }, { || .T. } } )
			Endif	
		Else
			If AllTrim(aCampos[nX]) != "E1_VENCTO" .And.;
				((ValType(aDados) ="A" .And. aDados[nX] != SE1->&(aCampos[nX])) .Or.;
				(M->&(aCampos[nX]) != SE1->&(aCampos[nX]))) // Alteracao de outros dados, instrucao sera 31
				If SE1->E1_PORTADO = "237"
					Aadd(aRet, { aCampos[nX], { || "31" }, { || .T. } } )
				Endif
			Endif
		Endif
	Next
Endif
If Empty(aRet)
	If !lAbatim .And. !lProtesto .And. !lCancProt
		Aadd(aRet, { Space(10), { || Space(2) }, { || .T. } } )
	Else
		If SE1->E1_PORTADO = "237"
			If lAbatim
				Aadd(aRet, { Space(10), { || "04" }, { || .T. } } ) // Instrucao de abatimento para banco 237
			Elseif lProtesto
				Aadd(aRet, { Space(10), { || "09" }, { || .T. } } ) // Instrucao de Protesto para banco 237
			Elseif lCancProt
				Aadd(aRet, { Space(10), { || "10" }, { || .T. } } ) // Instrucao de Canc. Protesto para banco 237 (Verificar)
			Endif	
		Endif
	Endif	
Endif	
Return aRet