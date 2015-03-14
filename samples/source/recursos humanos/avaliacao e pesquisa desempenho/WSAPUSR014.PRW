User Function WSAPUSR014()

Local cTitulo	:= ParamIxb[1]
Local cNome		:= ""           
   
	//cTitulo: Contem o a descricao do item no menu
	//Validar com o nome que deseja incluindo acentuacao.
	//Retorna o nome da funcao que chamara a pagina de usuario
	//If AllTrim(Upper(cTitulo)) == "CERTIFICAÇÕES MICROSIGA" .Or. AllTrim(Upper(cTitulo)) == "CERTIFICACOES MICROSIGA"
	If AllTrim(Lower(cTitulo)) == "certificação interna" //.Or. AllTrim(Upper(cTitulo)) == "CERTIFICACOES MICROSIGA"
		cNome := "W_PWSA088()"	
	EndIf

Return cNome