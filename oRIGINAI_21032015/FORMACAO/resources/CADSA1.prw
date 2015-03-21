// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : CADSA1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 14/03/15 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"


//------------------------------------------------------------------------------------------
user function CADSA1()

	Local cAlias := "SA1"	
	//Título a ser utilizado nas operações
	Private cCadastro := "Cadastro de Cliente"
			
	aRotina := {;
				{" Pesquisar " , "AxPesqui"  , 0, 1},;
				{" Visualizar" , "AxVisual"  , 0, 2},;
				{"INC PROTHEUS", "U_xINCSA1" , 0, 3},;
				{" Alterar   " , "AxAltera"  , 0, 4},;
				{" Excluir   " , "U_DELSA1"  , 0, 5},;
				{"Parametro  " , "U_xTela"   , 0, 6},;
				{" Incluir   " , "U_fTelaCli", 0, 7};				
				}
	
	dbSelectArea(cAlias) // Abrindo a area da tabela
	(cAlias)->( dbSetOrder(1) ) //// indices
	
	mBrowse( 6, 1, 22, 75, cAlias)
Return( NIL)

//***************************************************************************

User Function xINCSA1(cTABELA,NRECNO,NBOTAO)

MsgInfo(cTABELA + " " + cValToChar(NRECNO ) + " " + cValToChar(NBOTAO ) )


If MsgYESNO("Gostaria de incluir um\ novo registro")
		
	AxInclui(cTABELA, NRECNO,NBOTAO)	
	
EndIf	
	
Return( NIL)
//********************************************************

User Function DELSA1(cTABELA,NRECNO,NBOTAO)

dbSelectArea("SE1")
SE1->(dbSetOrder(2))

If SE1->(dbSeek(xFilial("SE1")+SA1->A1_COD +SA1->A1_LOJA ))
	MsgInfo("Não pode excluir o Cliente: " + SA1->A1_NREDUZ )
Else
	If MsgYESNO("Deseja visualizar os dados do Cliente: "  + SA1->A1_NREDUZ )
		
		If 2 == AxDeleta( cTABELA, NRECNO, NBOTAO)
			MsgInfo(" Cliente Excluido " )
		EndIf
		
	Else
	
		RecLock("SA1",.F.)
			SA1->( dbDelete() )
		SA1->(MsUnLock())
	EndIf
EndIf
			
				






Return( NIL)
//********************************************************


















