#INCLUDE "rwmake.ch"

User Function TstImpCad()

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
Private Limite      := 80
Private Tamanho     := "G"
Private NomeProg    := "Exerc18" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18        // Caracter de compressao. Usado em Cabec().
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1} // Preenchido pela SetPrint().
Private nLastKey    := 0
Private cPerg       := "RSZ1"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_Pag       := 01
Private wnRel       := "Exerc18" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SA1"

Pergunte(cPerg,.F.)

// Monta a interface padrao com o usuario.
wnRel := SetPrint(cString, NomeProg, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .T., aOrd, .F., Tamanho, , .T.)

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

Private aParDef := {}
Private aLinha := {}
Private Li := 80

If Len(aReturn) > 8
	Mont_Dic(cString)
 Else
	Mont_Array(cString)
Endif

ImpCadast("Cab1", "Cab2", "Cab3", NomeProg, Tamanho, Limite, cString)

// Finaliza a execucao do relatorio.
SET DEVICE TO SCREEN

// Se impressao em disco, chama o gerenciador de impressao.
If aReturn[5]==1   // Impressao em disco.
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnRel)
Endif

MS_FLUSH()         // Libera o spool para a efetiva impressao.

Return
