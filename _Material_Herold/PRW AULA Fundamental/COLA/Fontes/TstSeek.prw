User Function TstSeek()

Local cCod
Local cLoja

dbSelectArea("SA1")
dbSetOrder(1)

cCod := "000010"
cLoja := "01"
dbSeek(xFilial("SA1") + cCod + cLoja)
MsgAlert(SA1->A1_Nome)

MsgAlert(IIf(EOF(), "Fim de arquivo", Str(Recno())))

cCod := "ABC123"
cLoja := "00"
If dbSeek(xFilial("SA1") + cCod + cLoja)
   MsgAlert(SA1->A1_Nome)
 Else
   MsgAlert("Cliente nao encontrado.")
EndIf

MsgAlert(IIf(EOF(), "Fim de arquivo", Str(Recno())))

Return Nil

//--------------------------------------------------------------------//
// Escreva uma funcao para mostrar os clientes em ordem alfabetica de nome.
User Function TstOrdem()

dbSelectArea("SA1")
dbSetOrder(2)
dbGoTop()

While !EOF()

   MsgAlert(SA1->A1_Nome)
   dbSkip()

   Exit
   
End

Return Nil

