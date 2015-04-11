#INCLUDE "rwmake.ch"

User Function BrowserSB1()  

Private cCadastro := "Cadastro de Produto"

Private aRotina := { {"Pesquisar" ,"AxPesqui" ,0,1} ,;
	                 {"Visualizar","AxVisual" ,0,2} ,;
        	         {"Incluir"   ,"AxInclui" ,0,3} ,;
			         {"Alterar"   ,"AxAltera" ,0,4} ,;
          	         {"Excluir"   ,"U_DeletSB1" ,0,5} ,;  
          	         { "Legenda"  ,"U_LegSB1()", 0, 6 } }  

Private aCores    := { { "B1_CUSTD >= 0   .AND. B1_CUSTD <= 50"  , "BR_VERDE"    },;
                       { "B1_CUSTD >= 51  .AND. B1_CUSTD <= 200" , "BR_VERMELHO" },;
                       { "B1_CUSTD >= 201 .AND. B1_CUSTD <= 400" , "BR_AMARELO"  },;
                       { "B1_CUSTD >= 401 .AND. B1_CUSTD <= 600" , "BR_PRETO"    },;
                       { "B1_CUSTD >= 601 .AND. B1_CUSTD <= 800" , "BR_BRANCO"   },;
                       { "B1_CUSTD >  801", "BR_LARANJA"                        }}

dbSelectArea("SB1")                                                          

dbSetOrder(1)

//mBrowse( ,,,,"SB1",,"B1_CUSTD") Exemplo da Validação quando o campo esta vazio"
//mBrowse( ,,,,"SB1",,,,"B1_CUSTD > 100") Exemplo com Validação "
//mBrowse( ,,,,"SB1",,,,,3) //Define o número da opção do aRotina que será executada quando o usuário efetuar um duplo clique em um registro do browse
  mBrowse( ,,,,"SB1",,,,,3,aCores )
Return( NIL )

//---------------------------------------------------------------------------------------------------------------------------------------------------

User Function LegSB1()
                              
         aLegenda := {{"BR_VERDE"    , "B1_CUSTD >= 0   .AND. B1_CUSTD <= 50"   },;
                      {"BR_VERMELHO" , "B1_CUSTD >= 51  .AND. B1_CUSTD <= 200"  },;
                      {"BR_AMARELO"  , "B1_CUSTD >= 201 .AND. B1_CUSTD <= 400"  },;
                      {"BR_PRETO"    , "B1_CUSTD >= 401 .AND. B1_CUSTD <= 600"  },;
                      {"BR_BRANCO"   , "B1_CUSTD >= 601 .AND. B1_CUSTD <= 800"  },;
                      {"BR_LARANJA"  , "B1_CUSTD >  801"                        }} 

 BrwLegenda("Preço de Custo !!! " ," Legenda ",aLegenda)

Return( NIL )    
//----------------------------------------------------------------------------------------------------------------------------------------------------

User Function DeletSB1(cAlias, nReg, nOpc)
                                                                
Local PulaLinha := chr(10)+chr(13)  
Local nExcl := 0     

If nOpc == 5

	dbSelectArea("SC6")                            
	SC6->(dbSetOrder(2))       
	
	If dbSeek(xfilial("SC6")+SB1->B1_COD)
		MsgInfo("Não pode deletar o produto: " + SB1->B1_COD + PulaLinha + "possiu pedidos relacionado com esse produto" )
	Else 	

	 nExcl := AxDeleta(cAlias, nReg, nOpc)
/*
	 	ReckLock()
	  		dbDelete() 
	  	MsUnLock()
*/              

	If nExcl == 2
      MsgInfo("Produto excluido!")
   Else
		MsgAlert("Nao foi possivel excluir o produto!")   	   
   EndIf
  
	EndIf  
	
EndIf	

  
	
Return()