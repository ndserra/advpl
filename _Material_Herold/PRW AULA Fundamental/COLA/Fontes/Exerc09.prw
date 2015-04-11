#Include "PROTHEUS.CH"

User Function Exerc09()

Private aRotina := {}
Private cCadastro := "Orçamento de Venda"
Private cAlias1 := "SZ2"                    // Alias da Enchoice.
Private cAlias2 := "SZ3"                    // Alias da GetDados.

AAdd(aRotina, {"Pesquisar" , "AxPesqui"   , 0, 1})
AAdd(aRotina, {"Visualizar", "u_Mod3Manut", 0, 2})
AAdd(aRotina, {"Incluir"   , "u_Mod3Manut", 0, 3})
AAdd(aRotina, {"Alterar"   , "u_Mod3Manut", 0, 4})
AAdd(aRotina, {"Excluir"   , "u_Mod3Manut", 0, 5})
                                               
dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTop()

mBrowse(,,,,cAlias1)

Return Nil
