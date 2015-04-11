#Include "PROTHEUS.CH"

//----------------------------------------------------------------------------------------------------------------// 
// Demonstracao do ListBox.
//----------------------------------------------------------------------------------------------------------------// 
User Function LstBox()

Local oDlg, oBrw, oBtnOk, oBtnVolta, oBtnMTodos, oBtnDTodos
Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )
Local nBrwLin, nBrwCol
Local nValor
Local oVrTotal, nVrTotal:=0
Local aItens := {}

// Carrega no array "aItens" os dados dos pedidos ainda nao gerados.

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5"))

While SC5->C5_Filial == xFilial("SC5") .And. !SC5->(Eof())

   If Empty(SC5->C5_Nota)    // Ainda nao foi gerada a NF para este pedido.

      // Posiciona no Cadastro do Cliente.
      dbSelectArea("SA1")
      dbSetOrder(1)
      dbSeek(xFilial("SA1") + SC5->C5_Cliente + SC5->C5_LojaCli)

      nValor := 0

      // Posiciona no arquivo de Itens dos Pedidos.
      dbSelectArea("SC6")
      dbSetOrder(1)
      dbSeek(xFilial("SC6") + SC5->C5_Num)

      // Le os itens do pedido e soma o valor.
      While xFilial("SC6") + SC6->C6_Num == xFilial("SC5") + SC5->C5_Num .And. !SC6->(Eof())
         nValor += SC6->C6_Valor
         SC6->(dbSkip())
      End

      AAdd(aItens, {.F., SC5->C5_Num, SC5->C5_Cliente, SC5->C5_LojaCli, If(SA1->(Found()), SA1->A1_Nome, "Não cadastrado"), SC5->C5_Emissao, nValor})

   EndIf

   SC5->(dbSkip())

End

// Define a janela principal.
Define MSDialog oDlg Title "Pedidos de Venda" From 0,0 To 400,750 Pixel

// Desenha um box.
@03,05 To 22,(oDlg:nClientWidth-10)/2 Pixel Of oDlg

// Mostra uma mensagem.
@08,40 Say "Marque os Pedidos para a geração da Nota Fiscal" Pixel Font u_Fonte("Courier", 0, -20, "Bold") Of oDlg

// Define o ListBox.
@nBrwLin:=26,nBrwCol:=5 ListBox oBrw;
   Fields;
   Header   "", "Número", "Cliente", "Loja", "Nome Cliente", "Emissão", "Valor";
   ColSizes 0                                              ,;
            CalcFieldSize("C", Len(SC5->C5_Num), 0, "")    ,;
            CalcFieldSize("C", Len(SC5->C5_Cliente), 0, ""),;
            CalcFieldSize("C", Len(SC5->C5_LojaCli), 0, ""),;
            CalcFieldSize("C", Len(SA1->A1_Nome), 0, "")   ,;
            CalcFieldSize("D", 8, 0, "")                   ,;
            CalcFieldSize("N", 12, 2, "")                   ;
   Font     u_Fonte("Arial", 0, -12);
   Size     u_LstLarg(oDlg, nBrwCol),u_LstAlt(oDlg, nBrwLin)-7 Pixel Of oDlg

   oBrw:SetArray(aItens)

   oBrw:bLDblClick := {|| IIf(oBrw:Cargo==0,.F.,aItens[oBrw:nAt, 1]:=!aItens[oBrw:nAt, 1]), oBrw:Refresh()                      ,;  // Marca/Desmarca.
                          nVrTotal += IIf(oBrw:Cargo==0,0,IIf(aItens[oBrw:nAt, 1], aItens[oBrw:nAt, 7], aItens[oBrw:nAt, 7]*-1)),;  // Soma ou subtrai do Vr.Total.
                          oVrTotal:SetText(nVrTotal)                                                                             ;  // Atualiza o Vr.Total.
                      }

   // Mesmo que nao tenha nenhum item, ou seja, a array está vazia, o Browse precisa ser mostrado.
   // Porem, na atribuicao dos dados a serem mostrados (propriedade 'bLine'), ocorreria o erro
   // 'Array out of bound', pois a array está vazia. Uma possivel solucao seria usar a funcao
   // Len(Array), porem, degradaria muito a performance, ja que esta funcao seria executada para
   // todas as linhas e colunas do browse.
   // Portanto, guarda-se o Len(Array) na propriedade 'Cargo' e esta sim é avaliada em 'bLine'.
   oBrw:bWhen := {|SELF| SELF:Cargo := Len(SELF:aArray) }
   oBrw:Cargo := Len(oBrw:aArray)      // Quando se usa oBrw:bLine ao inves de Add Column, precisa forcar a inicializacao.

   oBrw:bLine := {|| {IIf(IIf(oBrw:Cargo==0,.F.,aItens[oBrw:nAt,1]), oOk, oNo)               ,;
                      IIf(oBrw:Cargo==0,"",aItens[oBrw:nAt,2])                               ,;
                      IIf(oBrw:Cargo==0,"",aItens[oBrw:nAt,3])                               ,;
                      IIf(oBrw:Cargo==0,"",aItens[oBrw:nAt,4])                               ,;
                      IIf(oBrw:Cargo==0,"",aItens[oBrw:nAt,5])                               ,;
                      IIf(oBrw:Cargo==0,"",aItens[oBrw:nAt,6])                               ,;
                      Transform(IIf(oBrw:Cargo==0,0,aItens[oBrw:nAt,7]), "@E 999,999,999.99") ;
                     } }

// Define os botoes.
@oBrw:nBottom/2+3,oBrw:nLeft/2      Button oBtnMTodos Prompt "&Marcar todos"    Size 47,15 Pixel Action (u_Todos(aItens, .T., oVrTotal, @nVrTotal), oBrw:Refresh()) Message "Marca todos os itens"    Of oDlg
@oBrw:nBottom/2+3,oBrw:nLeft/2+047  Button oBtnDTodos Prompt "&Desmarcar todos" Size 47,15 Pixel Action (u_Todos(aItens, .F., oVrTotal, @nVrTotal), oBrw:Refresh()) Message "Desmarca todos os itens" Of oDlg

@oBrw:nBottom/2+6,oBrw:nLeft/2+100 Say "Valor total:" Pixel Font u_Fonte("Arial", 0, -12, "Bold") Of oDlg
@oBrw:nBottom/2+6,oBrw:nLeft/2+150 Say oVrTotal Var nVrTotal Pixel Picture "@E 9,999,999.99" Font u_Fonte("Arial", 0, -12, "Bold") Of oDlg

@oBrw:nBottom/2+3,oBrw:nRight/2-060 Button oBtnOk    Prompt "Gravar"  Size 30,15 Pixel Action (u_Grava(aItens), oDlg:End()) Of oDlg                                                                                  // senao, nao faz nada.
@oBrw:nBottom/2+3,oBrw:nRight/2-030 Button oBtnVolta Prompt "&Voltar" Size 30,15 Pixel Action oDlg:End() Cancel Message "Volta ao menu anterior" Of oDlg

// Ativa (desenha) a janela.
Activate MSDialog oDlg Centered

Return Nil

//----------------------------------------------------------------------------------------------------------------// 
// Marca ou desmarca todos os itens.
User Function Todos(aItens, lMarca, oVrTotal, nVrTotal)

Local i

// Zera o valor. Se a opcao for "desmarcar todos", permanecera zerado. Senao, serao somados todos os valores.
nVrTotal := 0

For i := 1 To Len(aItens)
    aItens[i, 1] := lMarca          // Marca ou desmarca, dependendo de como veio o parametro.
    If lMarca                       // A opcao é "marcar todos";
       nVrTotal += aItens[i, 7]     // Soma os valores.
    EndIf
Next

oVrTotal:SetText(nVrTotal)

Return Nil

//----------------------------------------------------------------------------------------------------------------// 
// Grava o campo de Nr. da Nota, como se estivesse gerando a NF.
User Function Grava(aItens)

Local i

For i := 1 To Len(aItens)

    If aItens[i, 1]          // Está marcado.

       dbSelectArea("SC5")
       dbSetOrder(1)
       If dbSeek(xFilial("SC5") + aItens[i, 2])
          MsgInfo("Gerando NF do Pedido " + SC5->C5_Num)
          RecLock("SC5")
          SC5->C5_Nota := "999999"
          MSUnlock()
       EndIf       

    EndIf

Next

Return Nil

//----------------------------------------------------------------------------------------------------------------// 
User Function Fonte(cFont, nLarg, nAlt, cBold)

Local oFont

Default cBold := ""
   
If Upper(cBold) == "BOLD"
   Define Font oFont Name cFont Size nLarg,nAlt Bold
 Else
   Define Font oFont Name cFont Size nLarg,nAlt
EndIf      

Return oFont

//----------------------------------------------------------------------------------------------------------------//
// Calcula a largura do listbox de modo a ficar centralizado na janela.
User Function LstLarg(oDlg, nLstCol)
// Desconta, da largura da janela, o espaco esquerdo para sobrar o mesmo espaco no lado direito.
Return (oDlg:nClientWidth - (nLstCol*4))/2

//----------------------------------------------------------------------------------------------------------------//
// Calcula a altura do listbox de modo a ficar centralizado na janela.
User Function LstAlt(oDlg, nLstLin)
// Desconta, da altura da janela, o espaco superior para sobrar o mesmo espaco na parte inferior.
Return  (oDlg:nClientHeight - (nLstLin*4))/2
