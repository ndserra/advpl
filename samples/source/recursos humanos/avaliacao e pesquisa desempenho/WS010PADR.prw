User Function WS010PADR()

Local aAval	:= ParamIxb[1]
Local nCompetence := 0
Local nQuestion	:= 0            
   //Ordenar todas as listas de alternativas pelo valor (percentage)
   For nCompetence := 1 to Len(aAval:ListOfCompetence)
	   For nQuestion := 1 to Len(aAval:ListOfCompetence[nCompetence]:ListOfQuestion)
    		Asort(aAval:ListOfCompetence[nCompetence]:ListOfQuestion[nQuestion]:ListOfAlternative,,, {|x,y| x:Percentage < y:Percentage })
		Next nQuestion
	Next nCompetence

Return aAval