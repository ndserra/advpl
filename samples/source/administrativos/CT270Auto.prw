#include "rwmake.ch"
#include "tbiconn.ch"
#include "topconn.ch"

/* ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³ Rotinas para INCLUSAO (INC_270AUT) e EXCLUSAO (EXC_270AUT) de Rateio Off-Line (CTBA270)  ³
   ³ em modo automatico, utilizando-se a funcao MSExecAuto()                                  ³
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/


/* ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³ INCLUSAO de Rateio Off-Line ³
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
USER FUNCTION INC_270AUT()


Local aCab  	:= {}
Local aItens 	:= {}

PRIVATE lMsErroAuto := .F.
PRIVATE cEmpImp     := "99", cFilImp := "01"
 
ConOut("****************************************")
ConOut("**         Preparando ambiente        **")
ConOut("****************************************")

PREPARE ENVIRONMENT EMPRESA cEmpImp FILIAL cFilImp


/* ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³ Inclusao de um Rateio Off-Line com 2 linhas  ³
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
//
// Dados do Cabecalho da tela de cadastro de Rateio Off-Line
//
aCab	:=	{	{"CCTQ_RATEIO"	,"1"			  				,	NIL},;	//	Codigo do Rateio
				{"CCTQ_DESC"	,"RATEIO OFF AUTO -  1"	,	NIL},;	// Descricao
				{"CCTQ_TIPO"	,"1"							,	NIL},;	//	Tipo ( 1-Movimento Mes ; 2-Saldo Acumulado )
  			 	{"CCTQ_CTPAR"	,"110103"					,	NIL},;	//	Conta de Partida
				{"CCTQ_CCPAR"	,""							,	NIL},;	// Centro de Custo de Partida
			  	{"CCTQ_ITPAR"	,""							,	NIL},;	// Item Contabil   de Partida
				{"CCTQ_CLPAR"	,""							,	NIL},;	// Classe de Valor de Partida
				{"CCTQ_CTORI"	,"110104"					,	NIL},;	// Conta de Origem
  			 	{"CCTQ_CCORI"	,""							,	NIL},;	// Centro de Custo de Origem
				{"CCTQ_ITORI"	,""							,	NIL},;	// Centro de Custo de Origem
			  	{"CCTQ_CLORI"	,""							,	NIL},;	// Centro de Custo de Origem
				{"CCTQ_PERBAS"	,100.00						,	NIL}	}	// Percentual Base

//
// Primeira Linha do Rateio
//
Aadd(aItens,	{	{"CTQ_FILIAL"	,xFilial("CTQ")	,	NIL},;		//	Codigo da Filial
						{"CTQ_SEQUEN"	,"001"				,	NIL},;		// Numero da sequencia
						{"CTQ_CTCPAR"	,"210104"			,	NIL},;		// Conta de Contra Partida
						{"CTQ_CCCPAR"	,"1"					,	NIL},;		// Centro de Custo de Contra Partida
						{"CTQ_ITCPAR"	,"2"					,	NIL},;		// Item Contabil de Contra Partida
						{"CTQ_CLCPAR"	,"3"					,	NIL},;		// Classe de Valor de Contra Partida
						{"CTQ_PERCEN"	,45.00				,	NIL}	}	)	//	Percentual de Rateio

//
// Segunda Linha do Rateio
//
Aadd(aItens,	{	{"CTQ_FILIAL"	,xFilial("CTQ")	,	NIL},;		//	Codigo da Filial
						{"CTQ_SEQUEN"	,"002"				,	NIL},;		// Numero da sequencia ( tem que ser diferente do anterior )
						{"CTQ_CTCPAR"	,"210105"			,	NIL},;		// Conta de Contra Partida
						{"CTQ_CCCPAR"	,"2"					,	NIL},;		// Centro de Custo de Contra Partida
						{"CTQ_ITCPAR"	,"3"					,	NIL},;		// Item Contabil de Contra Partida
						{"CTQ_CLCPAR"	,"1"					,	NIL},;		// Classe de Valor de Contra Partida
						{"CTQ_PERCEN"	,55.00				,	NIL}	}	)	//	Percentual de Rateio

ConOut("**    Inicio - Inclusao de Rateio Off Line - Automatico    **")

//
// Para identificar que é uma INCLUSAO, passar o numero 3 (três) no ultimo parametro
//
MSExecAuto( {|X,Y,Z| CTBA270(X,Y,Z)},aCab,aItens,3)

ConOut("**      Fim - Inclusao de Rateio Off Line - Automatico     **")

If !lMsErroAuto
	MsgInfo("Concluido com Sucesso!")
Else
	MsgAlert("Erro no Processo!")
	MostraErro()
EndIf

RESET ENVIRONMENT

Return


/* ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   ³ EXCLUSAO de Rateio Off-Line ³
   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
USER FUNCTION EXC_270AUT()


Local aCab, aItens

PRIVATE lMsErroAuto := .F.
PRIVATE cEmpImp     := "99", cFilImp := "01"
 
ConOut("****************************************")
ConOut("**         Preparando ambiente        **")
ConOut("****************************************")

PREPARE ENVIRONMENT EMPRESA cEmpImp FILIAL cFilImp 

//
// Diferentemente da Inclusao, na Exclusao basta incluir na primeira matriz, apenas 
// o codigo do rateio a ser excluido.
//                                 
// Observe que para excluir o rateio cujo codigo é "1", por exemplo, é necessário informar seu código e 
// completá-lo com 5 espaços em branco, pois esse campo tem tamanho igual a 6 (seis).
//
aCab	:=	{	{"CCTQ_RATEIO"	,"1     ",	NIL} }	//	Codigo do Rateio

//
// Nao é necessário alimentar a matriz das linhas do rateio
//
aItens := {}


ConOut("**    Inicio - Exclusao de Rateio Off Line - Automatico    **")
                                                    
//
// Para identificar que é uma EXCLUSÃO, passar o numero 5 (cinco) no ultimo parametro
//
MSExecAuto( {|X,Y,Z| CTBA270(X,Y,Z)},aCab,aItens,5)

ConOut("**      Fim - Exclusao de Rateio Off Line - Automatico     **")

If !lMsErroAuto
	MsgInfo("Concluido com Sucesso!")
Else
	MsgAlert("Erro no Processo!")
	MostraErro()
EndIf

RESET ENVIRONMENT

Return
