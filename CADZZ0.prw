
#include "rwmake.ch"

user function CADZZ0()
local cAlias

	aRotina := {}
	
	cAlias := "ZZ0"
	
	dbSelectArea(cAlias)
	//indices
	dbSetOrder(1) 
	
	private cCadastro := "Teste SX's'"
		
	AADD(aRotina,{"Pesquisar" 	,"AxPesqui"		,0,	1})  //+-----------------------------------------// quando a função FilBrowse for utilizada a função de pesquisa deverá ser a PesqBrw ao invés da AxPesqui//+-----------------------------------------//
	AADD(aRotina,{"Visualizar" 	,"AxVisual"		,0,	2})
	AADD(aRotina,{"Incluir" 	,"AxInclui"		,0,	3})
	AADD(aRotina,{"Alterar" 	,"AxAltera"		,0,	4})
	AADD(aRotina,{"Excluir" 	,"AxDeleta"		,0,	5})
	AADD(aRotina,{"Teste" 	,"U_REL00001()"		,0,	6})
	AADD(aRotina,{"PesqPag" ,"PesqBrw" 		,0,	7})//+-----------------------------------------
	dbSelectArea(cAlias)
	
	dbSetOrder(1)
	
	mBrowse( 6, 1, 22, 75, cAlias)
	
return( NIL )


