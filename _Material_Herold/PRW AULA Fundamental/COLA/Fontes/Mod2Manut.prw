//----------------------------------------------------------------------------------------------------------------//
// Modelo 2.
//----------------------------------------------------------------------------------------------------------------//

User Function Mod2Manut(cAlias, nReg, nOpc)

Local cChave := ""
Local nCols  := 0
Local i      := 0
Local lRet   := .F.

// Parametros da funcao Modelo2().
Private cTitulo  := cCadastro
Private aC       := {}                 // Campos do Enchoice.
Private aR       := {}                 // Campos do Rodape.
Private aCGD     := {}                 // Coordenadas do objeto GetDados.
Private cLinOK   := ""                 // Funcao para validacao de uma linha da GetDados.
Private cAllOK   := "u_Md2TudOK()"     // Funcao para validacao de tudo.
Private aGetsGD  := {}
Private bF4      := {|| }              // Bloco de Codigo para a tecla F4.
Private cIniCpos := "+Z4_ITEM"         // String com o nome dos campos que devem inicializados ao pressionar
                                       // a seta para baixo. "+Z4_ITEM+Z4_xxx+Z4_yyy"
Private nMax     := 99                 // Nr. maximo de linhas na GetDados.

//Private aCordW   := {}
//Private lDelGetD := .T.
Private aHeader  := {}                 // Cabecalho de cada coluna da GetDados.
Private aCols    := {}                 // Colunas da GetDados.
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField)}
Private dData    := CtoD("  /  /  ")
Private cNumero  := Space(6)
Private aAlt     := {}

// Cria variaveis de memoria: para cada campo da tabela, cria uma variavel de memoria com o mesmo nome.
dbSelectArea(cAlias)

For i := 1 To FCount()
    M->&(Eval(bCampo, i)) := CriaVar(FieldName(i), .T.)
    // Assim tambem funciona: M->&(FieldName(i)) := CriaVar(FieldName(i), .T.)
Next

/////////////////////////////////////////////////////////////////////
// Cria vetor aHeader.                                             //
/////////////////////////////////////////////////////////////////////

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)

While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias

   If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
      cNivel >= SX3->X3_Nivel .And.;                  // Nivel do Usuario é maior que o Nivel do Campo.
      !Trim(SX3->X3_Campo) $ "Z4_NUMERO|Z4_EMISSAO"   // Campos que ficarao na parte da Enchoice.

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

/////////////////////////////////////////////////////////////////////
// Cria o vetor aCols: contem os dados dos campos da tabela.       //
// Cada linha de aCols é uma linha da GetDados e as colunas sao as //
// colunas da GetDados.                                            //
/////////////////////////////////////////////////////////////////////

// Se a opcao nao for INCLUIR, atribui os dados ao vetor aCols.
// Caso contrario, cria o vetor aCols com as caracteristicas de cada campo.

dbSelectArea(cAlias)
dbSetOrder(1)

If nOpc <> 3       // A opcao selecionada nao é INCLUIR.

   cNumero := (cAlias)->Z4_Numero
   
   dbSeek(xFilial(cAlias) + cNumero)
   While !EOF() .And. (cAlias)->(Z4_Filial+Z4_Numero) == xFilial(cAlias)+cNumero
/*
----------------,------------,-------------------,---------,---------,-------,-------,------,---------,--------
     1          |     2      |        3          |    4    |    5    |   6   |   7   |  8   |   9     |   10
   Titulo       |   Campo    |     Picture       | Tamanho | Decimal | Valid | Usado | Tipo | Arquivo | Context
----------------|------------|-------------------|---------|---------|-------|-------|------|---------|--------
1  Item         | Z4_ITEM    | @!                |    2    |    0    |       |       |  C   |   SZ4   |    R
2  Cod.Software | Z4_CODSOFT | @!                |    6    |    0    |       |       |  C   |   SZ4   |    R
3  Descricao    | Z4_DESCR   | @!                |   50    |    0    |       |       |  C   |   SZ4   |    V
4  Quantidade   | Z4_QUANT   | @E 999,999,999.99 |   12    |    2    |       |       |  N   |   SZ4   |    R
5  DT Validade  | Z4_DTVALID | 99/99/99          |    8    |    0    |       |       |  D   |   SZ4   |    R
----------------'------------'-------------------'---------'---------'-------'-------'------'---------'--------
*/
       AAdd(aCols, Array(Len(aHeader)+1))   // Cria uma linha vazia em aCols.
       nCols++

       // Preenche a linha que foi criada com os dados contidos na tabela.       
       For i := 1 To Len(aHeader)
           If aHeader[i][10] <> "V"    // Campo nao é virtual.
              aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))   // Carrega o conteudo do campo.
            Else
              // A funcao CriaVar() le as definicoes do campo no dic.dados e carrega a variavel de acordo com
              // o Inicializador-Padrao, que, se nao foi definido, assume conteudo vazio.
              aCols[nCols][i] := CriaVar(aHeader[i][2], .T.)
           EndIf
       Next
       
       // Cria a ultima coluna para o controle da GetDados: deletado ou nao.
       aCols[nCols][Len(aHeader)+1] := .F.
       
       // Atribui o numero do registro neste vetor para o controle na gravacao.
       AAdd(aAlt, Recno())
       dbSelectArea(cAlias)
       dbSkip()

   End

 Else              // Opcao INCLUIR.
 
   // Atribui à variavel o inicializador padrao do campo.
   cNumero := GetSXENum("SZ4", "Z4_NUMERO")
/*
----------------,------------,-------------------,---------,---------,-------,-------,------,---------,--------
     1          |     2      |        3          |    4    |    5    |   6   |   7   |  8   |   9     |   10
   Titulo       |   Campo    |     Picture       | Tamanho | Decimal | Valid | Usado | Tipo | Arquivo | Context
----------------|------------|-------------------|---------|---------|-------|-------|------|---------|--------
1  Item         | Z4_ITEM    | @!                |    2    |    0    |       |       |  C   |   SZ4   |    R
2  Cod.Software | Z4_CODSOFT | @!                |    6    |    0    |       |       |  C   |   SZ4   |    R
3  Descricao    | Z4_DESCR   | @!                |   50    |    0    |       |       |  C   |   SZ4   |    V
4  Quantidade   | Z4_QUANT   | @E 999,999,999.99 |   12    |    2    |       |       |  N   |   SZ4   |    R
5  DT Validade  | Z4_DTVALID | 99/99/99          |    8    |    0    |       |       |  D   |   SZ4   |    R
----------------'------------'-------------------'---------'---------'-------'-------'------'---------'--------
*/
   // Cria uma linha em branco e preenche de acordo com o Inicializador-Padrao do Dic.Dados.
   AAdd(aCols, Array(Len(aHeader)+1))
   For i := 1 To Len(aHeader)
       aCols[1][i] := CriaVar(aHeader[i][2])
   Next
   
   // Cria a ultima coluna para o controle da GetDados: deletado ou nao.
   aCols[1][Len(aHeader)+1] := .F.
   
   // Atribui 01 para a primeira linha da GetDados.
   aCols[1][AScan(aHeader,{|x| Trim(x[2])=="Z4_ITEM"})] := "01"
   
EndIf

/////////////////////////////////////////////////////////////////////
// Cria o vetor Enchoice.                                          //
/////////////////////////////////////////////////////////////////////

// aC[n][1] = Nome da variavel. Ex.: "cCliente"
// aC[n][2] = Array com as coordenadas do Get [x,y], em Pixel.
// aC[n][3] = Titulo do campo
// aC[n][4] = Picture
// aC[n][5] = Validacao
// aC[n][6] = F3
// aC[n][7] = Se o campo é editavel, .T., senao .F.

AAdd(aC, {"cNumero", {15,10}, "Número"         , "@!"      , , , .F.      })
AAdd(aC, {"dData"  , {15,80}, "Data de Emissao", "99/99/99", , , (nOpc==3)})

// Coordenadas do objeto GetDados.
aCGD := {34,5,128,315}

// Validacao na mudanca de linha e quando clicar no botao OK.
cLinOK := "ExecBlock('AllwaysTrue',.F.,.F.)"     // ExecBlock verifica se a funcao existe.

dData := dDataBase

// Executa a funcao Modelo2().
lRet := Modelo2(cTitulo, aC, aR, aCGD, nOpc, cLinOK, cAllOK, , , cIniCpos, nMax)

If lRet  // Confirmou.

   If      nOpc == 3  // Inclusao
           If MsgYesNo("Confirma a gravacao dos dados?", cTitulo)
              // Cria um dialogo com uma regua de progressao.
              Processa({||Md2Inclu(cAlias)}, cTitulo, "Gravando os dados, aguarde...")
           EndIf
    ElseIf nOpc == 4  // Alteracao
           If MsgYesNo("Confirma a alteracao dos dados?", cTitulo)
              // Cria um dialogo com uma regua de progressao.
              Processa({||Md2Alter(cAlias)}, cTitulo, "Alterando os dados, aguarde...")
           EndIf
    ElseIf nOpc == 5  // Exclusao
           If MsgYesNo("Confirma a exclusao dos dados?", cTitulo)
              // Cria um dialogo com uma regua de progressao.
              Processa({||Md2Exclu(cAlias)}, cTitulo, "Excluindo os dados, aguarde...")
           EndIf
   EndIf

 Else

   RollBackSX8()

EndIf

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function Md2Inclu(cAlias)

Local i := 0
Local y := 0

ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)

For i := 1 To Len(aCols)

    IncProc()

    If !aCols[i][Len(aHeader)+1]  // A linha nao esta deletada, logo, deve ser gravada.

       RecLock(cAlias, .T.)

       For y := 1 To Len(aHeader)
           FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
       Next

       (cAlias)->Z4_Filial  := xFilial(cAlias)
       (cAlias)->Z4_Numero  := cNumero
       (cAlias)->Z4_Emissao := dData

       MSUnlock()

    EndIf

Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function Md2Alter(cAlias)

Local i := 0
Local y := 0

ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)

For i := 1 To Len(aCols)

    If i <= Len(aAlt)

       // aAlt contem os Recno() dos registros originais.
       // O usuario pode ter incluido mais registros na GetDados (aCols).

       dbGoTo(aAlt[i])                 // Posiciona no registro.
       RecLock(cAlias, .F.)
       If aCols[i][Len(aHeader)+1]     // A linha esta deletada.
          dbDelete()                   // Deleta o registro correspondente.
        Else
          // Regrava os dados.
          For y := 1 To Len(aHeader)
              FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
          Next
       EndIf
       MSUnlock()

     Else     // Foram incluidas mais linhas na GetDados (aCols), logo, precisam ser incluidas.

       If !aCols[i][Len(aHeader)+1]
          RecLock(cAlias, .T.)
          For y := 1 To Len(aHeader)
              FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
          Next
          (cAlias)->Z4_Filial := xFilial(cAlias)
          (cAlias)->Z4_Numero := cNumero
          (cAlias)->Z4_Emissao := dData
          MSUnlock()
       EndIf

    EndIf

Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function Md2Exclu(cAlias)

ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias) + cNumero)

While !EOF() .And. (cAlias)->Z4_Filial == xFilial(cAlias) .And. (cAlias)->Z4_Numero == cNumero
   IncProc()
   RecLock(cAlias, .F.)
   dbDelete()
   MSUnlock()
   dbSkip()
End

Return Nil

//----------------------------------------------------------------------------------------------------------------//
User Function Md2TudOK()

Local lRet := .T.
Local i    := 0
Local nDel := 0

For i := 1 To Len(aCols)
    If aCols[i][Len(aHeader)+1]
       nDel++
    EndIf
Next

If nDel == Len(aCols)
   MsgInfo("Para excluir todos os itens, utilize a opção EXCLUIR", cTitulo)
   lRet := .F.
EndIf

Return lRet

//----------------------------------------------------------------------------------------------------------------//
User Function AllwaysTrue()

/*
If aCols[n][2] * aCols[n][3] <> aCols[n][4]
   MsgAlert("Valor total incorreto.", "Atençao!")
   Return .F.
EndIf
*/

If aCols[n][4] == 0
   MsgAlert("Qt. nao pode ser zero.", "Atençao!")
   Return .F.
EndIf

Return .T.
