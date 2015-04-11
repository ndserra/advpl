#INCLUDE "rwmake.ch"

User Function Exerc18

// Declaracao de Variaveis.

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relatorio de Softwares"
Local cPict         := ""
Local titulo        := "Relatorio de Softwares"

// Var. nLin é o num. da linha a ser impresso. Inicializa com 80 para que, na primeira
// vez, no teste "If nLin>55" na funcao RunReport() já imprima o primeiro cabecalho.
Local nLin          := 80

Local Cabec1        := "Codigo Nome"
Local Cabec2        := "-------- ---------------------"
Local imprime       := .T.

Private aOrd        := {"Código","Nome"}
Private lEnd        := .F.
Private lAbortPrint := .F.  // Usado na RunReport() -> se usuario cancelou, contem .T.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "Exerc18" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18        // Caracter de compressao. Usado em Cabec().
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1} // Preenchido pela SetPrint().
Private nLastKey    := 0
Private cPerg       := "RSZ1"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "Exerc18" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZ1"

dbSelectArea("SZ1")
dbSetOrder(1)

Pergunte(cPerg,.F.)

// Monta a interface padrao com o usuario.

wnRel := SetPrint(cString, NomeProg, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .T., aOrd, .T., Tamanho, , .T.)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)   // Comprimido/Normal.

// RPTSTATUS monta a janela com a regua de processamento.
RptStatus({|| RunReport(Cabec1, Cabec2, Titulo, nLin) }, Titulo)

Return

//----------------------------------------------------------------------------------------------------------------// 
// Funcao auxiliar chamada pela RPTSTATUS.
//----------------------------------------------------------------------------------------------------------------// 
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento das ordens. A ordem selecionada pelo usuario esta contida³
//³ na posicao 8 do array aReturn. E um numero que indica a opcao sele- ³
//³ cionada na mesma ordem em que foi definida no array aOrd. Portanto, ³
//³ basta selecionar a ordem do indice ideal para a ordem selecionada   ³
//³ pelo usuario, ou criar um indice temporario para uma que nao exista.³
//³ Por exemplo:                                                        ³
//³                                                                     ³
//³ nOrdem := aReturn[8]                                                ³
//³ If nOrdem < 5                                                       ³
//³     dbSetOrder(nOrdem)                                              ³
//³ Else                                                                ³
//³     cInd := CriaTrab(NIL,.F.)                                       ³
//³     IndRegua(cString,cInd,"??_FILIAL+??_ESPEC",,,"Selec.Registros") ³
//³ Endif                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nOrdem := aReturn[8]
dbSetOrder(nOrdem)

// SETREGUA -> Indica quantos registros serao processados para a regua.
SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O tratamento dos parametros deve ser feito dentro da logica do seu  ³
//³ relatorio. Geralmente a chave principal e a filial (isto vale prin- ³
//³ cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- ³
//³ meiro registro pela filial + pela chave secundaria (codigo por exem ³
//³ plo), e processa enquanto estes valores estiverem dentro dos parame ³
//³ tros definidos. Suponha por exemplo o uso de dois parametros:       ³
//³ mv_par01 -> Indica o codigo inicial a processar                     ³
//³ mv_par02 -> Indica o codigo final a processar                       ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³ Assim o processamento ocorrera enquanto o codigo do registro posicio³
//³ nado for menor ou igual ao parametro mv_par02, que indica o codigo  ³
//³ limite para o processamento. Caso existam outros parametros a serem ³
//³ checados, isto deve ser feito dentro da estrutura de laço (WHILE):  ³
//³                                                                     ³
//³ mv_par01 -> Indica o codigo inicial a processar                     ³
//³ mv_par02 -> Indica o codigo final a processar                       ³
//³ mv_par03 -> Considera qual estado?                                  ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³     If A1_EST <> mv_par03                                           ³
//³         dbSkip()                                                    ³
//³         Loop                                                        ³
//³     Endif                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Note que o descrito acima deve ser tratado de acordo com as ordens  ³
//³ definidas. Para cada ordem, o indice muda. Portanto a condicao deve ³
//³ ser tratada de acordo com a ordem selecionada. Um modo de fazer isto³
//³ pode ser como a seguir:                                             ³
//³                                                                     ³
//³ nOrdem := aReturn[8]                                                ³
//³ If nOrdem == 1                                                      ³
//³     dbSetOrder(1)                                                   ³
//³     cCond := "A1_COD <= mv_par02"                                   ³
//³ ElseIf nOrdem == 2                                                  ³
//³     dbSetOrder(2)                                                   ³
//³     cCond := "A1_NOME <= mv_par02"                                  ³
//³ ElseIf nOrdem == 3                                                  ³
//³     dbSetOrder(3)                                                   ³
//³     cCond := "A1_CGC <= mv_par02"                                   ³
//³ Endif                                                               ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.)                                      ³
//³ While !EOF() .And. &cCond                                           ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbGoTop()
//dbSeek(xFilial("SZ1")+mv_Par01,.T.)

While !EOF() //.And. SZ1->Z1_Codigo <= MV_Par02

   // Verifica o cancelamento pelo usuario.

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   // Impressao do cabecalho do relatorio.

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD

   @nLin,000 PSay SZ1->Z1_Codigo
   @nLin,008 PSay SZ1->Z1_Nome
   @nLin,061 PSay SZ1->Z1_Emissao
   @nLin,071 PSay SZ1->Z1_DtAquis

   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo

   IncRegua()

EndDo

// Finaliza a execucao do relatorio.

SET DEVICE TO SCREEN

// Se impressao em disco, chama o gerenciador de impressao.

If aReturn[5]==1   // Impressao em disco.
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()         // Libera o spool para a efetiva impressao.

Return
