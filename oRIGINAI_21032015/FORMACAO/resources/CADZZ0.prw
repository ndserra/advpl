
#include "rwmake.ch"

user function CADZZ0()

local cAlias := "ZZ0"
		
   aRotina  := {} 

   
	Private cCadastro := "Teste SX's'"
	
		
	AADD(aRotina,{"Pesquisar"  ,"AxPesqui", 0 , 1}) 
	AADD(aRotina,{"Visualizar" ,"AxVisual", 0 , 2})
	AADD(aRotina,{"Incluir"    ,"AxInclui", 0 , 3})
	AADD(aRotina,{"Alterar"    ,"AxAltera", 0 , 4})
	AADD(aRotina,{"Excluir"    ,"AxDeleta", 0 , 5})
				
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	mBrowse( 6, 1, 22, 75, cAlias)
	
	
return( NIL )


