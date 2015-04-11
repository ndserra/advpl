User Function CadSZ1()

Private aRotina := {}
Private cCadastro := "Cadastro de Software"

aAdd( aRotina, { "Pesquisar"  , "AxPesqui" , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "AxVisual" , 0 , 2 })
aAdd( aRotina, { "Incluir"    , "AxInclui" , 0 , 3 })
aAdd( aRotina, { "Alterar"    , "AxAltera" , 0 , 4 })
aAdd( aRotina, { "Excluir"    , "AxDeleta" , 0 , 5 })

dbSelectArea("SZ1")
dbSetOrder(1)
dbGoTop()

mBrowse(6,1,22,75,"SZ1")

Return Nil