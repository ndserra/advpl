User Function MrkBrw()

Private aRotina := {}
Private cCadastro := "Cadastro de Produtos"
Private cMarca := GetMark()

AAdd(aRotina, {"Pesquisar", "AxPesqui", 0, 1})

MarkBrow("SC5", "C5_OK", "C5_Nota<>Space(Len(SC5->C5_Nota))",,,cMarca)

If MsgYesNo("Confirma ?")
   u_Marca()
EndIf

Return Nil

//----------------------------------------------------------------------------------------------------------------// 
User Function Marca()

dbSelectArea("SC5")
dbSeek(xFilial("SC5"))
While !SC5->(Eof())
   If SC5->C5_OK == cMarca
      MsgInfo("Gerando NF para o pedido " + SC5->C5_Num)
      RecLock("SC5")
      SC5->C5_Nota := "111111"
      MSUnlock()
   EndIf   
   SC5->(dbSkip())
End

Return
