
//Modelo de Rdmake utilizado para validacao na funcao PWSA033() do programa PWSA030.PRW

User Function PWSA30Vld()

Local nCompet 	:= val(HttpPost->cPaginaAtual)
Local nx		:= 0   
Local nResp		:= 0
		
For nx := 1 to Len(HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWsCompetences[nCompet]:oWsListOfQuestion:oWsQuestions)
	If &("HttpPost->RSP"+StrZero(nCompet,2)+StrZero(nx,3)) != "---" .And. !Empty(&("HttpPost->RSP"+StrZero(nCompet,2)+StrZero(nx,3)))
		nResp ++
	EndIf
Next nx

If nResp > 1 //Colocar o numero maximo de respostas

	//Retorna status anterior das respostas
	For nx := 1 to Len(HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWsCompetences[nCompet]:oWsListOfQuestion:oWsQuestions)
		&("HttpPost->RSP"+StrZero(nCompet,2)+StrZero(nx,3)) := HttpSession->GetPEvaluate[1]:oWsListOfCompetence:oWsCompetences[nCompet]:oWsListOfQuestion:oWsQuestions[nx]:cAlternativeChoice
	Next nx
	
	HttpSession->_HTMLERRO := { "Pesquisa", "Favor responder apenas "+Str(nResp,2)+" questoes.", "W_PWSA031.APW" }
	cHtml := ExecInPage( "PWSAMSG" )
EndIf

Return Nil