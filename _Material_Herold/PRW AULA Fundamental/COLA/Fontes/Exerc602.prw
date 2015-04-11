User Function Exerc602()

Private aRotina := {}
Private cCadastro := "Cadastro de Produtos"

aAdd( aRotina, { "Pesquisar"  , "AxPesqui" , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "AxVisual" , 0 , 2 })
aAdd( aRotina, { "Incluir"    , "AxInclui" , 0 , 3 })
aAdd( aRotina, { "Alterar"    , "AxAltera" , 0 , 4 })
aAdd( aRotina, { "Excluir"    , "AxDeleta" , 0 , 5 })
aAdd( aRotina, { "Compl.Prod.", "MATA180"  , 0 , 6 })

dbSelectArea("SB1")
dbSetOrder(1)
SET FILTER TO SB1->B1_Tipo $ "PA"
dbGoTop()

mBrowse(6,1,22,75,"SB1")

dbSelectArea("SB1")
SET FILTER TO

Return Nil