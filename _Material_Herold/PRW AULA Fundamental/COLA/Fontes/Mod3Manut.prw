//----------------------------------------------------------------------------------------------------------------//
// Modelo 3.
//----------------------------------------------------------------------------------------------------------------//

User Function Mod3Manut(cAlias, nRecno, nOpc)

Local i        := 0
Local cLinOK   := "AllwaysTrue"
Local cTudoOK  := "u_Md3TudOK"
Local nOpcE    := nOpc
Local nOpcG    := nOpc
Local cFieldOK := "AllwaysTrue"
Local lVirtual := .T.
Local nLinhas  := 99
Local nFreeze  := 0
Local lRet     := .T.

Private aCols        := {}
Private aHeader      :={}
Private aCpoEnchoice := {}
Private aAltEnchoice := {}
Private aAlt         := {}

// Cria variaveis de memoria dos campos da tabela Pai.
RegToMemory(cAlias1, (nOpc==3))

// Cria variaveis de memoria dos campos da tabela Filho.
RegToMemory(cAlias2, (nOpc==3))

CriaHeader()

CriaCols()

lRet := Modelo3(cCadastro, cAlias1, cAlias2, aCpoEnchoice, cLinOK, cTudoOK, nOpcE, nOpcG, cFieldOK, lVirtual, nLinhas, aAltEnchoice, nFreeze)

If lRet
   If      nOpc == 3
           If MsgYesNo("Confirma a gravação dos dados?", cCadastro)
              Processa({||GrvDados()}, cCadastro, "Gravando os dados, aguarde...")
           EndIf
    ElseIf nOpc == 4
           If MsgYesNo("Confirma a alteração dos dados?", cCadastro)
              Processa({||AltDados()}, cCadastro, "Alterando os dados, aguarde...")
           EndIf
    ElseIf nOpc == 5
           If MsgYesNo("Confirma a exclusão dos dados?", cCadastro)
              Processa({||ExcluiDados()}, cCadastro, "Excluindo os dados, aguarde...")
           EndIf

   EndIf
 Else
   RollBackSX8()
EndIf

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function CriaHeader()

aHeader      := {}
aCpoEnchoice := {}
aAltEnchoice := {}

// aHeader é igual ao do Modelo2.

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias2)

While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias2

   If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
      cNivel >= SX3->X3_Nivel                         // Nivel do Usuario é maior que o Nivel do Campo.

      AAdd(aHeader, {Trim(SX3->X3_Titulo),;
                     SX3->X3_Campo       ,;
                     SX3->X3_Picture     ,;
                     SX3->X3_Tamanho     ,;
                     SX3->X3_Decimal     ,;
                     SX3->X3_Valid       ,;
                     SX3->X3_Usado       ,;
                     SX3->X3_Tipo        ,;
                     SX3->X3_Arquivo     ,;
                     SX3->X3_Context})

   EndIf

   SX3->(dbSkip())

End

// Campos da Enchoice.

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias1)

While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias1

   If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
      cNivel >= SX3->X3_Nivel                         // Nivel do Usuario é maior que o Nivel do Campo.

      // Campos da Enchoice.
      AAdd(aCpoEnchoice, X3_Campo)

      // Campos da Enchoice que podem ser editadas.
      // Se tiver algum campo que nao deve ser editada, nao incluir aqui.
      AAdd(aAltEnchoice, X3_Campo)

   EndIf

   SX3->(dbSkip())

End

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function CriaCols(nOpc)

Local nQtdCpo := 0
Local i       := 0
Local nCols   := 0

nQtdCpo := Len(aHeader)
aCols   := {}
aAlt    := {}

If nOpc == 3       // Inclusao.

   AAdd(aCols, Array(nQtdCpo+1))

   For i := 1 To nQtdCpo
       aCols[1][i] := CriaVar(aHeader[i][2])
   Next

   aCols[1][nQtdCpo+1] := .F.

 Else

   dbSelectArea(cAlias2)
   dbSetOrder(1)
   dbSeek(xFilial(cAlias2) + (cAlias1)->Z2_Numero)

   While !EOF() .And. (cAlias2)->Z3_Filial == xFilial(cAlias2) .And. (cAlias2)->Z3_Numero == (cAlias1)->Z2_Numero

      AAdd(aCols, Array(nQtdCpo+1))
      nCols++

      For i := 1 To nQtdCpo
          If aHeader[i][10] <> "V"
             aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))
           Else
             aCols[nCols][i] := CriaVar(aHeader[i][2], .T.)
          EndIf
      Next

      aCols[nCols][nQtdCpo+1] := .F.

      AAdd(aAlt, Recno())

      dbSelectArea(cAlias2)
      dbSkip()

   End

EndIf
 
Return Nil
 
//----------------------------------------------------------------------------------------------------------------//
Static Function GrvDados()

Local bCampo := {|nField| Field(nField)}
Local i      := 0
Local y      := 0
Local nItem  := 0

ProcRegua(Len(aCols) + FCount())

// Grava o registro da tabela Pai, obtendo o valor de cada campo
// a partir da var. de memoria correspondente.

dbSelectArea(cAlias1)
RecLock(cAlias1, .T.)
For i := 1 To FCount()
    IncProc()
    If "FILIAL" $ FieldName(i)
       FieldPut(i, xFilial(cAlias1))
     Else
       FieldPut(i, M->&(Eval(bCampo,i)))
    EndIf
Next
MSUnlock()

// Grava os registros da tabela Filho.

dbSelectArea(cAlias2)
dbSetOrder(1)

For i := 1 To Len(aCols)

    IncProc()

    If !aCols[i][Len(aHeader)+1]       // A linha nao esta deletada, logo, pode gravar.

       RecLock(cAlias2, .T.)

       For y := 1 To Len(aHeader)
           FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
       Next

       nItem++

       (cAlias2)->Z3_Filial := xFilial(cAlias2)
       (cAlias2)->Z3_Numero := (cAlias1)->Z2_Numero
       (cAlias2)->Z3_Item   := StrZero(nItem, 2, 0)

       MSUnlock()

    EndIf

Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function AltDados()

Local bCampo := {|nField| Field(nField)}
Local i      := 0
Local y      := 0
Local nItem  := 0

ProcRegua(Len(aCols) + FCount())

dbSelectArea(cAlias1)
RecLock(cAlias1, .F.)

For i := 1 To FCount()
    IncProc()
    If "FILIAL" $ FieldName(i)
       FieldPut(i, xFilial(cAlias1))
     Else
       FieldPut(i, M->&(Eval(bCampo,i)))
    EndIf
Next
MSUnlock()
    
dbSelectArea(cAlias2)
dbSetOrder(1)

nItem := Len(aAlt) + 1

For i := 1 To Len(aCols)

    If i <= Len(aAlt)

       dbGoTo(aAlt[i])
       RecLock(cAlias2, .F.)

       If aCols[i][Len(aHeader)+1]
          dbDelete()
        Else
          For y := 1 To Len(aHeader)
              FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
          Next
       EndIf

       MSUnlock()

     Else

       If !aCols[i][Len(aHeader)+1]
          RecLock(cAlias2, .T.)
          For y := 1 To Len(aHeader)
              FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
          Next
          (cAlias2)->Z3_Filial := xFilial(cAlias2)
          (cAlias2)->Z3_Numero := (cAlias1)->Z2_Numero
          (cAlias2)->Z3_Item   := StrZero(nItem, 2, 0)
          MSUnlock()
          nItem++
       EndIf

    EndIf

Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function ExcluiDados()

ProcRegua(Len(aCols)+1)   // +1 é por causa da exclusao do arq. de cabeçalho.

dbSelectArea(cAlias2)
dbSetOrder(1)
dbSeek(xFilial(cAlias2) + (cAlias1)->Z2_Numero)

While !EOF() .And. (cAlias2)->Z3_Filial == xFilial(cAlias2) .And. (cAlias2)->Z3_Numero == (cAlias1)->Z2_Numero
   IncProc()
   RecLock(cAlias2, .F.)
   dbDelete()
   MSUnlock()
   dbSkip()
End

dbSelectArea(cAlias1)
dbSetOrder(1)
IndProc()
RecLock(cAlias1, .F.)
dbDelete()
MSUnlock()

Return Nil

//----------------------------------------------------------------------------------------------------------------//
User Function Md3TudOK()

Local lRet := .T.
Local i    := 0
Local nDel := 0

/*
For i := 1 To Len(aCols)
    If aCols[i][Len(aHeader)+1]
       nDel++
    EndIf
Next

If nDel == Len(aCols)
   MsgInfo("Para excluir todos os itens, utilize a opção EXCLUIR", cCadastro)
   lRet := .F.
EndIf
*/

For i := 1 To Len(aCols) - 1

    For j := i + 1 To Len(aCols)

        If aCols[i][1] == aCols[j][1] .And. !aCols[j][Len(aHeader)+1]
           MsgAlert("Produto repetido")
           Return .F.
        EndIf

    Next

Next

Return lRet
