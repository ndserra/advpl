#Include "RWMake.ch"

User Function Exerc05()

AxCadastro("SB1","Exerc05","(MsgAlert('Teste Del'),.T.)","(MsgAlert('Teste Tela'),.T.)")
//AxCadastro("SB1","Exerc05","Execblock('VDel')","(MsgAlert('Teste Tela'),.T.)")
//AxCadastro("SB1","Exerc05","Execblock('VDel1')","(MsgAlert('Teste Tela'),.T.)")

Return

//-------------------------------------------------
User Function VDel()

Local cArea := Alias()
Local nRecno := Recno()
Local cInd := IndexOrd()
Local cCod := SB1->B1_Cod
Local lDel := .T.

MsgBox("Verificando amarração do produto " + cCod, "Atenção!")

dbSelectArea("SC4")

If dbSeek(xFilial("SC4") + cCod)
   MsgBox("Produto nao pode ser excluido!")
   lDel := .F.
EndIf

dbSelectArea(cArea)
dbSetOrder(cInd)
dbGoTo(nRecno)

Return lDel

//-------------------------------------------------
User Function VDel1()

Local aArea := GetArea()
Local cCod := SB1->B1_Cod
Local lDel := .T.

MsgBox("Verificando amarração do produto " + cCod, "Atenção!")

dbSelectArea("SC4")

If dbSeek(xFilial("SC4") + cCod)

   If MsgBox("Deseja excluir a Previsao de Venda?","Previsao de Vendas", "YESNO")
      lDel := .T.
      If RecLock("SC4")
         dbDelete()
       Else
         MsgBox("Registro em uso, o produto nao será excluido!")
         lDel := .F.
      EndIf
    Else
      MsgBox("Produto nao pode ser excluido!")
      lDel := .F.
   EndIf

EndIf

RestArea(aArea)

Return lDel
