User Function Exerc605()

Local aCores := {}

Private aRotina := {}
Private cCadastro := "Cadastro de Produtos"

aAdd( aRotina, { "Pesquisar"  , "AxPesqui" , 0 , 1 })
aAdd( aRotina, { "Visualizar" , "AxVisual" , 0 , 2 })
aAdd( aRotina, { "Incluir"    , "AxInclui" , 0 , 3 })
aAdd( aRotina, { "Alterar"    , "AxAltera" , 0 , 4 })
aAdd( aRotina, { "Excluir"    , "AxDeleta" , 0 , 5 })
aAdd( aRotina, { "Legenda"    , "u_Legenda()", 0 , 6 })

aCores := {{"B1_PRV1 == 0"                      , "BR_VERMELHO"},;
           {"B1_PRV1 > 0   .And. B1_PRV1 <= 100", "BR_LARANJA" },;                                         
           {"B1_PRV1 > 100 .And. B1_PRV1 <= 200", "BR_AZUL"    },;                                         
           {"B1_PRV1 > 200"                     , "BR_VERDE"   }}                                         

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()

mBrowse(6,1,22,75,"SB1",,,,,6,aCores)

Return Nil

//---------------------------------------------------------------------//
Static Function Legenda()

BrwLegenda(cCadastro, "Valores", {{"BR_VERMELHO", "Preço nao informado"},;
                                  {"BR_LARANJA" , "Preço > 0 e <= 100"},;
                                  {"BR_AZUL"    , "Preço > 100 e <= 200"},;
                                  {"BR_VERDE"   , "Preço > 200"}})

Return .T.
                                  