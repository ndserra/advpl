#INCLUDE "rwmake.ch"

User Function CADSA1

Private cCadastro := "Cadastro de Cliente"

Private aRotina := { {"Pesquisar"  ,"AxPesqui"  ,0,1},;
		             	{"Visualizar" ,"AxVisual"  ,0,2},;
      		       	{"Incluir"    ,"AxInclui"  ,0,3},;
            		 	{"Alterar"    ,"AxAltera"  ,0,4},;
		             	{"Excluir"    ,"AxDeleta"  ,0,5},;
		             	{ "Legenda"   ,"U_LegSA1()",0,6}}  
		             	
Private aCores  := { { "A1_TIPO == 'F'"  , "BR_VERDE"  },;		             	
				   	   { "A1_TIPO == 'L'"  , "BR_PRETO"  },;		             	
				   	   { "A1_TIPO == 'S'"  , "BR_BRANCO" },;		             	
  				   	   { "A1_TIPO == 'R'"  , "BR_PINK"   },;
				   	   { "A1_TIPO == 'X'"  , "BR_CINZA"  }}
dbSelectArea("SA1")
dbSetOrder(1)

 mBrowse(,,,,"SA1",,,,,, aCores )


Return( NIL )                
//********************************************************************************************
User Function LegSA1()  

                              
Local    aLegenda := {{"BR_VERDE" , "F = Cons. Fiscal" },;
                      {"BR_PRETO" , "L = Produto Rural"},;
                      {"BR_PINK"  , "R = Revendedor"   },;
                      {"BR_BRANCO", "S = Solidario"    },;
                      {"BR_CINZA" , "X = Exportação"   }}
                      

 BrwLegenda("Tipo do Cliente!!! " ," Legenda ",aLegenda)

Return( NIL )    

