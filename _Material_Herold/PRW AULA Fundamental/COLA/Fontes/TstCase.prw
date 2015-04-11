User Function TstCase()

Local nOpc := 2

Do Case
   Case nOpc == 1
        MsgAlert("Opção 1 selecionada")
   Case nOpc == 2
        MsgAlert("Opção 2 selecionada")
   Case nOpc == 3
        MsgAlert("Opção 3 selecionada")
   Otherwise
        MsgAlert("Nenhuma opção selecionada")
EndCase

Return