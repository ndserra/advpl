/*
Codigo       Item    Descricao do Software                                       Quantidade        Vlr.Unitario           Vlr.Total
 Orçamento: 999999   Cliente: 999999 99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   Emissao: 99/99/99   Validade: 99/99/99
 999999      99      xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx      999,999,999.99      999,999,999.99      999,999,999.99
012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
0         1         2         3         4         5         6         7         8         9        10        11        12        13
*/

User Function Exerc11()

//+-------------------------
//| Declaracoes de variaveis
//+-------------------------
Local cDesc1  := "Este relatorio ira imprimir informacoes do orçamento de software conforme"
Local cDesc2  := "parâmetros informados pelo usuário"
Local cDesc3  := "[Utilizando Posicionamento e Condições p/ Registros]"

Private cString  := "SZ2"
Private Tamanho  := "M"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "EXERC11"
Private NomeProg := wnrel
Private nLastKey := 0
Private Limite   := 132
Private Titulo   := "Orcamento de software"
Private cPerg    := "EXEC11"
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Li       := 80
Private m_pag    := 1
Private aOrd     := {}
Private Cabec1  := "Código Item Descricao do Software                                       Quantidade        Vlr.Unitario           Vlr.Total"
Private Cabec2   := ""

/*
+-------------------------------------------------------
| Parametros do aReturn que é preenchido pelo SetPrint() 
+-------------------------------------------------------
aReturn[1] - Reservado para formulario
aReturn[2] - Reservado para numero de vias
aReturn[3] - Destinatario
aReturn[4] - Formato 1=Paisagem 2=Retrato
aReturn[5] - Midia 1-Disco 2=Impressora
aReturn[6] - Prota ou arquivo 1-Lpt1... 4-Com1...
aReturn[7] - Expressao do filtro
aReturn[8] - Ordem a ser selecionada
aReturn[9] [10] [n] - Campos a processar se houver
*/

//+-----------------------------------------
//| Parametros de perguntas para o relatorio
//+-----------------------------------------
//| mv_par01 - Orçamento de       ?
//| mv_par02 - Orçamento ate      ?
//| mv_par03 - Cliente de         ?
//| mv_par04 - Cliente ate        ?
//| mv_par05 - Emissão de ?       ?
//| mv_par06 - Emissão ate ?      ?
//+-----------------------------------------
CriaSx1()

//+-------------------------------------------------
//| Disponibiliza para usuario digitar os parametros
//+-------------------------------------------------
Pergunte(cPerg,.F.)

//+--------------------------------------------------
//| Solicita ao usuario a parametrizacao do relatorio
//+--------------------------------------------------
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,;
Tamanho,.F.,.F.)
//+-------------------------------------------------------------------------
//| Parâmetros da função SetPrint
//| SetPrint(cAlias,cNome,cPerg,cDesc,cCnt1,cCnt2,cCnt3,lDic,aOrd,lCompres,;
//| cSize,aFilter,lFiltro,lCrystal,cNameDrv,lNoAsk,lServer,cPortToPrint)
//+-------------------------------------------------------------------------

//+--------------------
//| Se teclar ESC, sair
//+--------------------
If nLastKey == 27
Return
Endif

//+------------------------------------------------------------------
//| Estabelece os padroes para impressao, conforme escolha do usuario
//+------------------------------------------------------------------
SetDefault(aReturn,cString)

//+-------------------------------------
//| Verificar se sera reduzido ou normal
//+-------------------------------------
nTipo := Iif(aReturn[4] == 1, 15, 18)

//+--------------------
//| Se teclar ESC, sair
//+--------------------
If nLastKey == 27
Return
Endif

//+-----------------------------------
//| Chama funcao que processa os dados
//+-----------------------------------
RptStatus({|lEnd| Exerc11Imp(@lEnd) },"Aguarde...","Imprimindo os dados...", .T.)
Return
Static Function Exerc11Imp(lEnd)
Local nTPedido  := 0

//+--------------------------------------------
//| Selecionar e posicionar na tabela principal
//+--------------------------------------------
dbSelectArea("SZ2")
dbSetOrder(1)
dbSeek(xFilial("SZ2")+mv_par01,.T.)

While !Eof() .And. SZ2->(Z2_FILIAL+Z2_NUMERO) <= xFilial("SZ2")+mv_par02
If lEnd
@ Li,000 PSay cCancel
Exit
Endif
   
   //+----------------------------------------------------------------------
//| Se o registro estiver fora dos parâmetros, ir para o próximo registro
   //+----------------------------------------------------------------------
If SZ2->Z2_CLIENTE < mv_par03 .Or. SZ2->Z2_CLIENTE > mv_par04
dbSkip()
Loop
Endif
   
   //+----------------------------------------------------------------------
//| Se o registro estiver fora dos parâmetros, ir para o próximo registro
   //+----------------------------------------------------------------------
If SZ2->Z2_EMISSAO < mv_par05 .Or. SZ2->Z2_EMISSAO > mv_par06
dbSkip()
Loop
Endif
   
If Li > 55
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif
@ Li,001 PSay "No. Orcamento: "+SZ2->Z2_NUMERO
@ Li,024 PSay "Cliente: "+SZ2->(Z2_CLIENTE+" "+Z2_LOJA)+" "+Posicione("SA1",1,xFilial("SA1")+SZ2->(Z2_CLIENTE+Z2_LOJA),"A1_NOME")
@ Li,093 PSay "Emissao: "+Dtoc(SZ2->Z2_EMISSAO)
@ Li,113 PSay "Validade: "+Dtoc(SZ2->Z2_DTVALID)
Li+=2
   
dbSelectArea("SZ3")
dbSetOrder(1)
dbSeek(xFilial("SZ3")+SZ2->Z2_NUMERO)
While !Eof() .And. SZ3->Z3_FILIAL+SZ3->Z3_NUMERO == xFilial("SZ3")+SZ2->Z2_NUMERO
If lEnd
@ Li,000 PSay cCancel
Exit
Endif
If Li > 55
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif
@ Li,001 PSay SZ3->Z3_CODSOFT
@ Li,013 PSay SZ3->Z3_ITEM
@ Li,021 PSay Posicione("SZ1",1,xFilial("SZ1")+SZ3->Z3_CODSOFT,"Z1_NOME")
@ Li,077 PSay SZ3->Z3_QUANT  PICTURE "@E 999,999,999.99"
@ Li,097 PSay SZ3->Z3_UNIT   PICTURE "@E 999,999,999.99"
@ Li,117 PSay SZ3->Z3_VLRTOT PICTURE "@E 999,999,999.99"
nTPedido += SZ3->Z3_VLRTOT
Li++
dbSelectArea("SZ3")
dbSkip()
End
@ Li,000 PSay __PrtThinLine()
Li++
@ Li,000 PSay "Total do Pedido: "
@ Li,117 PSay nTPedido PICTURE "@E 999,999,999.99"
nTPedido := 0
Li++
@ Li,000 PSay __PrtThinLine()
Li+=2
   
dbSelectArea("SZ2")
dbSkip()
End
dbSelectArea("SZ2")
dbSetOrder(1)
dbGoTop()

dbSelectArea("SZ3")
dbSetOrder(1)
dbGoTop()

If aReturn[5] == 1
Set Printer TO
dbCommitAll()
Ourspool(wnrel)
EndIf
Ms_Flush()
Return
/******
// *
//o	Parametros que devem ser passados para a função criar as perguntas no arquivo SX1
// * ---------------------------------------------------------------------------------
//o	1o.Parametro -> Nome do grupo
//o	2o.Parametro -> Numero da ordem
//o	3o.Parametro -> Texto da pergunta em portugues
//o	4o.Parametro -> Texto da pergunta em espanhol
//o	5o.Parametro -> Texto  da pergunta em ingles
//o	6o.Parametro -> Nome da variavel
//o	7o.Parametro -> Tipo do dado C=caractere, D=Data, N=Numerico
//o	8o.Parametro -> Tamanho do dado
//o	9o.Parametro -> Quantidade de casas decimais para o dado
//o	10o.Parametro -> Numero da pre-selecao
//o	11o.Parametro -> O tipo do dado sera G=get, S=scroll, C=choice
//o	12o.Parametro -> Sintaxe em advpl, ou funcao para validacao
//o	13o.Parametro -> Consistencia com alguma tabela do sistema via <F3>
//o	14o.Parametro -> Nome do grupo para SXG
//o	15o.Parametro -> Pyme
//o	16o.Parametro -> Nome da variavel que será utilizada no programa
//o	17o.Parametro -> Primeira definicao do texto em portugues se caso o tipo do dado for choice, exemplo: SIM ou Nao
//o	18o.Parametro -> Primeira definicao do texto em espanhol se caso o tipo do dado for choice, exemplo: Si o No
//o	19o.Parametro -> Primeira definicao do texto em ingles se caso o tipo do dado for choice, exemplo: Yes or No
//o	20o.Parametro -> Conteudo da ultima resposta informada no parametro se caso o tipo do dados for get
//o	21o.Parametro -> Segunda definicao do texto em portugues se caso o tipo do dado for choice, exemplo: SIM ou Nao
//o	22o.Parametro -> Segunda definicao do texto em espanhol se caso o tipo do dado for choice, exemplo: Si o No
//o	23o.Parametro -> Segunda definicao do texto em ingles se caso o tipo do dado for choice, exemplo: Yes or No
//o	24o.Parametro -> Terceira definicao do texto em portugues se caso o tipo do dado for choice, exemplo: SIM ou Nao
//o	25o.Parametro -> Terceira definicao do texto em espanhol se caso o tipo do dado for choice, exemplo: Si o No
//o	26o.Parametro -> Terceira definicao do texto em ingles se caso o tipo do dado for choice, exemplo: Yes or No
//o	27o.Parametro -> Quarta definicao do texto em portugues se caso o tipo do dado for choice, exemplo: SIM ou Nao
//o	28o.Parametro -> Quarta definicao do texto em espanhol se caso o tipo do dado for choice, exemplo: Si o No
//o	29o.Parametro -> Quarta definicao do texto em ingles se caso o tipo do dado for choice, exemplo: Yes or No
//o	30o.Parametro -> Quinta definicao do texto em portugues se caso o tipo do dado for choice, exemplo: SIM ou Nao
//o	31o.Parametro -> Quinta definicao do texto em espanhol se caso o tipo do dado for choice, exemplo: Si o No
//o	32o.Parametro -> Quinta definicao do texto em ingles se caso o tipo do dado for choice, exemplo: Yes or No
//o	33o.Parametro -> Vetor com o texto do help em portugues
//o	34o.Parametro -> Vetor com o texto do help em espanhol
//o	35o.Parametro -> Vetor com o texto do help em ingles
//o	36o.Parametro -> Nome do grupo do help
 //*
 //*/
Static Function CriaSx1()
Local aHelp := {}

aAdd( aHelp , {{"Informe o número do orçcamento inicial"} , {""} , {""}} )
aAdd( aHelp , {{"Informe o número do orçamento final"}    , {""} , {""}} )
aAdd( aHelp , {{"Informe o código do cliente de início"}  , {""} , {""}} )
aAdd( aHelp , {{"Informe o código do cliente para fim"}   , {""} , {""}} )
aAdd( aHelp , {{"Emitir os orçamento a partir da data"}   , {""} , {""}} )
aAdd( aHelp , {{"Emitir os orçamento até a data"}         , {""} , {""}} )
//texto do help português                                    inglês espanhol

PutSx1(cPerg,"01","Orcamento de?","","","mv_ch1","C",06,00,00,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",;
aHelp[1,1],aHelp[1,2],aHelp[1,3],"")

PutSx1(cPerg,"02","Orcamento ate?","","","mv_ch2","C",06,00,00,;
"G","","","","","mv_par02","","","","","","","","","","","","","","","","",;
aHelp[2,1],aHelp[2,2],aHelp[2,3],"")

PutSx1(cPerg,"03","Cliente de?","","","mv_ch3","C",06,00,00,"G","","SA1",;
"","","mv_par03","","","","","","","","","","","","","","","","",;
aHelp[3,1],aHelp[3,2],aHelp[3,3],"")

PutSx1(cPerg,"04","Clienteate?","","","mv_ch4","C",06,00,00,"G","","SA1",;
"","","mv_par04","","","","","","","","","","","","","","","","",aHelp[4,1],;
aHelp[4,2],aHelp[4,3],"")

PutSx1(cPerg,"05","Emissao de?","","","mv_ch5","D",08,00,00,"G","","","","",;
"mv_par05","","","","","","","","","","","","","","","","",aHelp[5,1],aHelp[5,2],;
aHelp[5,3],"")

PutSx1(cPerg,"06","Emissao ate?","","","mv_ch6","D",08,00,00,"G","","","","",;
"mv_par06","","","","","","","","","","","","","","","","",aHelp[6,1],aHelp[6,2],;
aHelp[6,3],"")
//     1      2    3                4  5   6        7  8  9  10  11 12 13 14 15  16        17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32    33         34         35         37
Return
