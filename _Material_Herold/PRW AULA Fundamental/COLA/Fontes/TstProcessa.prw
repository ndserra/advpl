
// Teste das funcoes Processa(), ProcRegua() e IncProc().

User Function TstProcessa()

Local lCancel := .T.  // Habilita o botao Cancelar.

Processa({|lFim|u_Contagem(@lFim)},"Processando...", "Teste da função Processa()", lCancel)

Return

//-----------------------------------------------------------------------//
User Function Contagem(lFim)

Local i
Local nAte := 5000

ProcRegua(nAte)

For i := 1 To nAte
   If lFim
      Exit
   EndIf
   IncProc()
Next

Return
