#Include "PROTHEUS.CH"

User Function Modelo2_1()

//Framework do mBrowser que é chamado diretamente do menu

Private aRotina := {}
Private cCadastro := "Solicitação de Software"

AAdd(aRotina, {"Pesquisar" , "AxPesqui"   , 0, 1})
AAdd(aRotina, {"Visualizar", "u_Mod2Manut", 0, 2})
AAdd(aRotina, {"Incluir"   , "u_Mod2Manut", 0, 3})
AAdd(aRotina, {"Alterar"   , "u_Mod2Manut", 0, 4})
AAdd(aRotina, {"Excluir"   , "u_Mod2Manut", 0, 5})
                                               
dbSelectArea("SZ1")
dbSetOrder(1)
dbGoTop()

mBrowse(,,,,"SZ1")

Return Nil
