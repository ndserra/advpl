///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | AP_Word.prw          | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_ap_word()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Este programa demonstra com fazer uma simples integracao do     |//
//|           | protheus com o ms-word. Para este exemplo eh necessario o       |//
//|           | arquivo cliente.dot                                             |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

#include "Protheus.Ch"
#include "MSOle.Ch"

User Function ap_word()
Local nOpcA := 0
Local cPerg := "MSWORD"

Private cCadastro := "Integração Protheus Vs Ms-Word"
Private aSay := {}
Private aButton := {}

CriaSx1(cPerg)
Pergunte(cPerg,.F.)

aAdd( aSay, "Esta rotina irá imprimir informacoes do cliente" )

aAdd( aButton, { 5,.T.,{|| Pergunte(cPerg,.T. )}})
aAdd( aButton, { 1,.T.,{|| nOpca := 1,FechaBatch()}})
aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSay, aButton )

If nOpcA == 1
	Processa( {|| ImpWord() }, "Processando..." )
Endif

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | AP_Word.prw          | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - ImpWord()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que descarrega as variaveis nas variaveis do word        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function ImpWord()

Local oWord     := Nil
Local cTitulo1  := "Selecione o arquivo"
Local cExtens   := "Modelo Word | *.dot"
Local cFileOpen := ""
Local cFileSave := ""

/***
 * _________________________________________________________
 * cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)
 * ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
 * <ExpC1> - Expressao de filtro
 * <ExpC2> - Titulo da janela
 * <ExpN1> - Numero de mascara default 1 para *.Exe
 * <ExpC3> - Diretório inicial se necessário
 * <ExpL1> - .F. botão salvar - .T. botão abrir
 * <ExpN2> - Mascara de bits para escolher as opções de visualização do objeto (prconst.ch)
 */
cFileOpen := cGetFile(cExtens,cTitulo1,,,.T.)

oWord := OLE_CreateLink()
OLE_NewFile( oWord, cFileOpen )

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek( xFilial("SA1")+mv_par01+mv_par02 )
If !Found()
   Help("",1,"NORECNO")
   RETURN
End
	
OLE_SetDocumentVar( oWord, 'AP5_A1_COD' , SA1->A1_COD  )
OLE_SetDocumentVar( oWord, 'AP5_A1_LOJA', SA1->A1_LOJA )
OLE_SetDocumentVar( oWord, 'AP5_A1_NOME', SA1->A1_NOME )
	
OLE_UpDateFields( oWord )

If mv_par03<>3
   If mv_par03==1
	   OLE_SetProperty( oWord, '208', .F. )
	   OLE_PrintFile( oWord )
   Elseif mv_par03 == 2
      cFileSave := SubStr(cFileOpen,1,At(".",Trim(cFileOpen))-1)
	   OLE_SaveAsFile( oWord, cFileSave+SA1->A1_COD+"_AP5.doc" )
   Endif
   OLE_CloseLink( oWord )
Endif

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | AP_Word.prw          | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - CriaSX1()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Esta funcao cria o grupo de perguntas no SX1 caso nao exista    |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaSx1(cPerg)
Local j  := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Cliente de ?        ","mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SA1"})
aAdd(aReg,{cPerg,"02","Loja de ?           ","mv_ch2","C", 2,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"03","Gerar ?             ","mv_ch3","N", 1,0,0,"C","","mv_par03","Impressora","","","Arquivo","","","MS-Word","","","","","","","",""})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)

For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return Nil