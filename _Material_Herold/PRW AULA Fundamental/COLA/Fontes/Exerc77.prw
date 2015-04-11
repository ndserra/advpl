#Include "PROTHEUS.CH"

User Function Exerc77()

Private aRotina := {}
Private cCadastro := "Chamados"

AAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
AAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
AAdd(aRotina, {"Incluir"   , "AxInclui", 0, 3})
AAdd(aRotina, {"Alterar"   , "AxAltera", 0, 4})
AAdd(aRotina, {"Excluir"   , "u_DelSZ8", 0, 5})
                                               
dbSelectArea("SZ8")

If AllTrim(cUserName) <> "Administrador"
   Set Filter To AllTrim(SZ8->Z8_Usuario) == AllTrim(cUserName)
EndIf

dbSelectArea("SZ8")
dbSetOrder(1)
dbGoTop()

mBrowse(,,,,"SZ8")

dbSelectArea("SZ8")
Set Filter To

Return Nil

//-----------------------------------------------------------------------//
User Function DelSZ8(cAlias, nRecno, nOpc)

If !Empty(SZ8->Z8_Solu)
   MsgAlert("Chamado atendido. Não poderá ser excluido!", "Atenção!")
 Else
   nExcl := AxDeleta(cAlias, nRecno, nOpc)
   If nExcl == 2
      MsgInfo("Chamado excluido!")
   EndIf
EndIf

Return