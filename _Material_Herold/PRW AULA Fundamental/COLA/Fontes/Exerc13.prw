User Function Exerc13()

// Declaracoes de variaveis.

Local cDesc1  := "Este relatorio ira imprimir informacoes do orçamento de software conforme"
Local cDesc2  := "parâmetros informados pelo usuário"
Local cDesc3  := "[Utilizando Arquivo de trabalho]"

Private cString  := "SZ2"
Private Tamanho  := "M"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "EXERC13"
Private NomeProg := wnrel
Private nLastKey := 0
Private Limite   := 132
Private Titulo   := "Orcamento de software"
Private cPerg    := "EXEC13"
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Li       := 80
Private m_pag    := 1
Private aOrd     := {}
Private Cabec1   := "Codigo       Item    Descricao do Software                                       Quantidade        Vlr.Unitario           Vlr.Total"
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
wnRel := SetPrint(cString, wnRel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F., aOrd, .F., Tamanho, .F., .F.)
//+-------------------------------------------------------------------------
//| Parâmetros da função SetPrint
//| SetPrint(cAlias,cNome,cPerg,cDesc,cCnt1,cCnt2,cCnt3,lDic,aOrd,lCompres,;
//| cSize,aFilter,lFiltro,lCrystal,cNameDrv,lNoAsk,lServer,cPortToPrint)
//+-------------------------------------------------------------------------

// Se teclou ESC, sai.
If nLastKey == 27
   Return
EndIf

// Estabelece os padroes para impressao, conforme escolha do usuario.
SetDefault(aReturn, cString)

// Verifica se sera reduzido ou normal.
nTipo := IIf(aReturn[4] == 1, 15, 18)

// Se teclou ESC, sai.
If nLastKey == 27
   Return
EndIf

// Chama funcao que processa os dados.
RptStatus({|lEnd| Exerc13Imp(@lEnd) }, "Aguarde...", "Imprimindo os dados...", .T.)

Return

//----------------------------------------------------------------------------------------------------------------// 
Static Function Exerc13Imp(lEnd)

Local nTPedido := 0
Local cNomCli := ""
Local cDescr := ""
Local cArqTrb := ""
Local aArqTrb := {}
Local cOrc := ""

// Estrutura do arquivo de trabalho.
AAdd( aArqTrb, {"ORC"    , "C", 06, 0} )
AAdd( aArqTrb, {"CLIENTE", "C", 06, 0} )
AAdd( aArqTrb, {"LOJA"   , "C", 02, 0} )
AAdd( aArqTrb, {"NOMCLI" , "C", 40, 0} )
AAdd( aArqTrb, {"DTEMISS", "D", 08, 0} )
AAdd( aArqTrb, {"DTVALID", "D", 08, 0} )
AAdd( aArqTrb, {"CODIGO" , "C", 06, 0} )
AAdd( aArqTrb, {"ITEM"   , "C", 02, 0} )
AAdd( aArqTrb, {"DESCR"  , "C", 50, 0} )
AAdd( aArqTrb, {"QTDE"   , "N", 12, 2} )
AAdd( aArqTrb, {"UNIT"   , "N", 12, 2} )
AAdd( aArqTrb, {"TOT"    , "N", 12, 2} )

// Cria o arquivo de trabalho.
cArqTrb := CriaTrab(aArqTrb, .T.)

// Abre o arquivo criado.
dbUseArea(.T., __LocalDriver, cArqTrb, "TRB", .T., .F.)

// Cria um indice.
IndRegua("TRB", cArqTrb, "ORC+ITEM")

// Seleciona e posiciona na tabela principal
dbSelectArea("SZ2")
dbSetOrder(1)
dbSeek(xFilial("SZ2")+mv_par01,.T.)

While !Eof() .And. SZ2->(Z2_FILIAL+Z2_NUMERO) <= xFilial("SZ2")+mv_par02
	
	If lEnd
		MsgInfo(cCancel,titulo)
		Exit
	EndIf
	
	// Se o registro estiver fora dos parâmetros, vai para o próximo registro.
	
	If SZ2->Z2_CLIENTE < mv_par03 .Or. SZ2->Z2_CLIENTE > mv_par04
		dbSkip()
		Loop
	EndIf
	
	// Se o registro estiver fora dos parâmetros, vai para o próximo registro
	
	If SZ2->Z2_EMISSAO < mv_par05 .Or. SZ2->Z2_EMISSAO > mv_par06
		dbSkip()
		Loop
	EndIf
	
	cNomCli := Posicione("SA1", 1, xFilial("SA1")+SZ2->(Z2_CLIENTE+Z2_LOJA), "A1_NOME")
	
	dbSelectArea("SZ3")
	dbSetOrder(1)
	dbSeek(xFilial("SZ3")+SZ2->Z2_NUMERO)
	
	While !Eof() .And. SZ3->Z3_FILIAL+SZ3->Z3_NUMERO == xFilial("SZ3")+SZ2->Z2_NUMERO
		
		If lEnd
			MsgInfo(cCancel,titulo)
			Exit
		EndIf
		
		cDescr := Posicione("SZ1",1,xFilial("SZ1")+SZ3->Z3_CODSOFT,"Z1_NOME")

		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->ORC     := SZ2->Z2_NUMERO
		TRB->CLIENTE := SZ2->Z2_CLIENTE
		TRB->LOJA    := SZ2->Z2_LOJA
		TRB->NOMCLI  := cNomCli
		TRB->DTEMISS := SZ2->Z2_EMISSAO
		TRB->DTVALID := SZ2->Z2_DTVALID
		TRB->CODIGO  := SZ3->Z3_CODSOFT
		TRB->ITEM    := SZ3->Z3_ITEM
		TRB->DESCR   := cDescr
		TRB->QTDE    := SZ3->Z3_QUANT
		TRB->UNIT    := SZ3->Z3_UNIT
		TRB->TOT     := SZ3->Z3_VLRTOT
		MsUnLock()

		dbSelectArea("SZ3")
		dbSkip()

	End
	
	dbSelectArea("SZ2")
	dbSkip()

End

// Ler a tabela temporaria e descarregar para impressao.

dbSelectArea("TRB")
dbGoTop()

While !Eof()

	If lEnd
		@ Li,000 PSay cCancel
		Exit
	Endif
	
	If Li > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	Endif

	@ Li,001 PSay "No. Orcamento: "+TRB->ORC
	@ Li,024 PSay "Cliente: "+TRB->CLIENTE+" "+TRB->LOJA+" "+TRB->NOMCLI
	@ Li,093 PSay "Emissao: "+Dtoc(TRB->DTEMISS)
	@ Li,113 PSay "Validade: "+Dtoc(TRB->DTVALID)
	Li+=2
	
	cOrc := TRB->ORC

	While !Eof() .And. TRB->ORC == cOrc
		If lEnd
			@ Li,000 PSay cCancel
			Exit
		Endif
		If Li > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		Endif
		@ Li,001 PSay TRB->CODIGO
		@ Li,013 PSay TRB->ITEM
		@ Li,021 PSay TRB->DESCR
		@ Li,077 PSay TRB->QTDE PICTURE "@E 999,999,999.99"
		@ Li,097 PSay TRB->UNIT PICTURE "@E 999,999,999.99"
		@ Li,117 PSay TRB->TOT  PICTURE "@E 999,999,999.99"
		nTPedido += TRB->TOT
		Li++
		dbSelectArea("TRB")
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

End

dbSelectArea("TRB")
dbCloseArea()

If !Empty( cArqTrb )
	FErase( cArqTrb+".*")
Endif

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnRel)
EndIf

Ms_Flush()

Return

//----------------------------------------------------------------------------------------------------------------// 
// Funcao que cria as perguntas no SX1.
// Parametros:
// 1o.Parametro -> Nome do grupo
// 2o.Parametro -> Numero da ordem
// 3o.Parametro -> Texto da pergunta em portugues
// 4o.Parametro -> Texto da pergunta em espanhol
// 5o.Parametro -> Texto  da pergunta em ingles
// 6o.Parametro -> Nome da variavel
// 7o.Parametro -> Tipo do dado C=caractere, D=Data, N=Numerico
// 8o.Parametro -> Tamanho do dado
// 9o.Parametro -> Quantidade de casas decimais para o dado
// 10o.Parametro -> Numero da pre-selecao
// 11o.Parametro -> O tipo do dado sera G=get, S=scroll, C=choice
// 12o.Parametro -> Sintaxe em advpl, ou funcao para validacao
// 13o.Parametro -> Consistencia com alguma tabela do sistema via <F3>
// 14o.Parametro -> Nome do grupo para SXG
// 15o.Parametro -> Pyme
// 16o.Parametro -> Nome da variavel que será utilizada no programa
// 17o.Parametro -> Primeira definicao do texto em portugues se caso o tipo do dado for choice, exemplo: SIM ou Nao
// 18o.Parametro -> Primeira definicao do texto em espanhol se caso o tipo do dado for choice, exemplo: Si o No
// 19o.Parametro -> Primeira definicao do texto em ingles se caso o tipo do dado for choice, exemplo: Yes or No
// 20o.Parametro -> Conteudo da ultima resposta informada no parametro se caso o tipo do dados for get
// 21o.Parametro -> Segunda definicao do texto em portugues se caso o tipo do dado for choice, exemplo: SIM ou Nao
// 22o.Parametro -> Segunda definicao do texto em espanhol se caso o tipo do dado for choice, exemplo: Si o No
// 23o.Parametro -> Segunda definicao do texto em ingles se caso o tipo do dado for choice, exemplo: Yes or No
// 24o.Parametro -> Terceira definicao do texto em portugues se caso o tipo do dado for choice, exemplo: SIM ou Nao
// 25o.Parametro -> Terceira definicao do texto em espanhol se caso o tipo do dado for choice, exemplo: Si o No
// 26o.Parametro -> Terceira definicao do texto em ingles se caso o tipo do dado for choice, exemplo: Yes or No
// 27o.Parametro -> Quarta definicao do texto em portugues se caso o tipo do dado for choice, exemplo: SIM ou Nao
// 28o.Parametro -> Quarta definicao do texto em espanhol se caso o tipo do dado for choice, exemplo: Si o No
// 29o.Parametro -> Quarta definicao do texto em ingles se caso o tipo do dado for choice, exemplo: Yes or No
// 30o.Parametro -> Quinta definicao do texto em portugues se caso o tipo do dado for choice, exemplo: SIM ou Nao
// 31o.Parametro -> Quinta definicao do texto em espanhol se caso o tipo do dado for choice, exemplo: Si o No
// 32o.Parametro -> Quinta definicao do texto em ingles se caso o tipo do dado for choice, exemplo: Yes or No
// 33o.Parametro -> Vetor com o texto do help em portugues
// 34o.Parametro -> Vetor com o texto do help em espanhol
// 35o.Parametro -> Vetor com o texto do help em ingles
// 36o.Parametro -> Nome do grupo do help
//----------------------------------------------------------------------------------------------------------------// 
Static Function CriaSx1()

Local aHelp := {}

AAdd( aHelp, {{"Informe o número do orçcamento inicial"}, {""} , {""}} )
AAdd( aHelp, {{"Informe o número do orçamento final"   }, {""} , {""}} )
AAdd( aHelp, {{"Informe o código do cliente de início" }, {""} , {""}} )
AAdd( aHelp, {{"Informe o código do cliente para fim"  }, {""} , {""}} )
AAdd( aHelp, {{"Emitir os orçamento a partir da data"  }, {""} , {""}} )
AAdd( aHelp, {{"Emitir os orçamento até a data"        }, {""} , {""}} )

PutSx1(cPerg, "01", "Orçamento de?" ,"","","mv_ch1","C",06,00,00,"G","",""   ,"","","mv_par01","","","","","","","","","","","","","","","","",aHelp[1,1],aHelp[1,2],aHelp[1,3],"")
PutSx1(cPerg, "02", "Orcamento ate?","","","mv_ch2","C",06,00,00,"G","",""   ,"","","mv_par02","","","","","","","","","","","","","","","","",aHelp[2,1],aHelp[2,2],aHelp[2,3],"")
PutSx1(cPerg, "03", "Cliente de?"   ,"","","mv_ch3","C",06,00,00,"G","","SA1","","","mv_par03","","","","","","","","","","","","","","","","",aHelp[3,1],aHelp[3,2],aHelp[3,3],"")
PutSx1(cPerg, "04", "Cliente ate?"  ,"","","mv_ch4","C",06,00,00,"G","","SA1","","","mv_par04","","","","","","","","","","","","","","","","",aHelp[4,1],aHelp[4,2],aHelp[4,3],"")
PutSx1(cPerg, "05", "Emissao de?"   ,"","","mv_ch5","D",08,00,00,"G","",""   ,"","","mv_par05","","","","","","","","","","","","","","","","",aHelp[5,1],aHelp[5,2],aHelp[5,3],"")
PutSx1(cPerg, "06", "Emissao ate?"  ,"","","mv_ch6","D",08,00,00,"G","",""   ,"","","mv_par06","","","","","","","","","","","","","","","","",aHelp[6,1],aHelp[6,2],aHelp[6,3],"")

Return
