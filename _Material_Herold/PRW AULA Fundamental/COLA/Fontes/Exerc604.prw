User Function Exerc604()

Private aRotina := {}
Private cCadastro := "Cadastro de Produtos"

aAdd( aRotina, { "Pesquisar"  , "AxPesqui" , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "AxVisual" , 0 , 2 })
aAdd( aRotina, { "Incluir"    , "AxInclui" , 0 , 3 })
aAdd( aRotina, { "Alterar"    , "AxAltera" , 0 , 4 })
aAdd( aRotina, { "Excluir"    , "AxDeleta" , 0 , 5 })

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()

mBrowse(6,1,22,75,"SB1",,,,"u_PrecoVenda()")

Return Nil

//---------------------------------------------------------------//
User Function PrecoVenda()

Return SB1->B1_Prv1 == 0
