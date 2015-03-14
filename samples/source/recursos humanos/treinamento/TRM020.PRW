#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"  
#INCLUDE "TRM020.CH"
#INCLUDE "REPORT.CH"

/*ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠здддддддддддддбддддддддддбдддддддбдддддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤└o       Ё TRM020   Ё Autor Ё Eduardo Ju              Ё Data Ё 24.05.06 Ё╠╠
╠╠цдддддддддддддеддддддддддадддддддадддддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤└o    Ё Relatorio de Treinamentos (Solicitacao)   	               Ё╠╠
╠╠цдддддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso          Ё TRM020                                                       Ё╠╠
╠╠цдддддддддддддеддддддддддбддддддбдддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁProgramador  Ё Data 	   Ё BOPS Ё  Motivo da Alteracao 				       Ё╠╠
╠╠цдддддддддддддеддддддддддеддддддедддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁTania     	Ё18/09/2006Ё100265ЁAcertos para o Relatorio personalizavel, do Ё╠╠
╠╠Ё          	Ё          Ё      ЁRelease 4. Inclusao do Ajusta SX1.          Ё╠╠
╠╠ЁEduardo Ju 	Ё06/01/2007Ё105658ЁCorrecao: filtro da Situacao do Funcionario Ё╠╠ 
╠╠Ё          	Ё          Ё      Ёe da Query.                                 Ё╠╠  
╠╠ЁEduardo Ju 	Ё10/10/2007Ё129103ЁAlteracao da Query R4.                      Ё╠╠ 
╠╠юдддддддддддддаддддддддддаддддддадддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠здддддддддддддбддддддддддбддддддддддддддддбддддддддддддддддддддддддддддддддддддддддддд©╠╠
╠╠ЁProgramador  Ё Data     Ё FNC            Ё  Motivo da Alteracao                      Ё╠╠
╠╠цдддддддддддддеддддддддддеддддддддддддддддедддддддддддддддддддддддддддддддддддддддддддЁ╠╠
╠╠ЁRogerio R.   Ё29/07/2009Ё00000018271/2009ЁCompatibilizacao dos fontes para aumento doЁ╠╠
╠╠Ё             Ё          Ё                Ёcampo filial e gestЦo corporativa.         Ё╠╠
╠╠ЁMauricio MR  Ё26/04/2010Ё00000006249/2010ЁAjuste na impressao do relatorio:			Ё╠╠
╠╠Ё             Ё          Ё                Ёa) Versao personalizada, ajuste na query   Ё╠╠
╠╠Ё             Ё          Ё                Ёpara busca correta do curso por centro de  Ё╠╠
╠╠Ё             Ё          Ё                Ёcusto.									    Ё╠╠
╠╠Ё             Ё          Ё                Ёb.1.) Na versao tradicional, alteracao do  Ё╠╠
╠╠Ё             Ё          Ё                Ёtamanho do campo de codigo do departamento Ё╠╠
╠╠Ё             Ё          Ё                Ёno pergunte e informado o grupo de campo   Ё╠╠
╠╠Ё             Ё          Ё                Ёcorrespondente.   							Ё╠╠
╠╠Ё             Ё          Ё                Ёb.2.) Na versao tradicional, se nao encon- Ё╠╠
╠╠Ё             Ё          Ё                Ёtrado o curso do cargo por centro de custo,Ё╠╠
╠╠Ё             Ё          Ё                Ё, procura apenas pelo cargo.				Ё╠╠
╠╠юдддддддддддддаддддддддддаддддддддддддддддаддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/   
User Function TRM020()

Local oReport
Local aArea := GetArea()

If FindFunction("TRepInUse") .And. TRepInUse()	//Verifica se relatorio personalizal esta disponivel
	//здддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ajusta SX1 para trabalhar com range.     Ё
	//юдддддддддддддддддддддддддддддддддддддддддды
	AjustaTR020RSx1()
	Pergunte("TR020R",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	
Else
	U_TRM020R3()	
EndIf  

RestArea( aArea )

Return

/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддддбдддддддбдддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁReportDef() Ё Autor Ё Eduardo Ju          Ё Data Ё 16.05.06 Ё╠╠
╠╠цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁDefinicao do Componente de Impressao do Relatorio           Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё                                                            Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local aOrdem    := {}
Local cAliasQry := GetNextAlias()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁCriacao do componente de impressao                                      Ё
//ЁTReport():New                                                           Ё
//ЁExpC1 : Nome do relatorio                                               Ё
//ЁExpC2 : Titulo                                                          Ё
//ЁExpC3 : Pergunte                                                        Ё
//ЁExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  Ё
//ЁExpC5 : Descricao                                                       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oReport := TReport():New("TRM020",STR0009,"TR020R",{|oReport| PrintReport(oReport,cAliasQry)},STR0017)	//"SolicitaГЦo de Treinamento"#"Este programa tem como objetivo imprimir a SolicitaГЦo de Treinamento conforme parБmetros selecionados"
oReport:SetTotalInLine(.F.) 
oReport:SetLandscape()	//Imprimir Somente Paisagem
Pergunte("TR020R",.F.)

Aadd( aOrdem, STR0004)	// "Matricula"
Aadd( aOrdem, STR0005)	// "Centro de Custo"
Aadd( aOrdem, STR0006)	// "Nome" 

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁCriacao da celulas da secao do relatorio                                Ё
//ЁTRCell():New                                                            Ё
//ЁExpO1 : Objeto TSection que a secao pertence                            Ё
//ЁExpC2 : Nome da celula do relatСrio. O SX3 serА consultado              Ё
//ЁExpC3 : Nome da tabela de referencia da celula                          Ё
//ЁExpC4 : Titulo da celula                                                Ё
//Ё        Default : X3Titulo()                                            Ё
//ЁExpC5 : Picture                                                         Ё
//Ё        Default : X3_PICTURE                                            Ё
//ЁExpC6 : Tamanho                                                         Ё
//Ё        Default : X3_TAMANHO                                            Ё
//ЁExpL7 : Informe se o tamanho esta em pixel                              Ё
//Ё        Default : False                                                 Ё
//ЁExpB8 : Bloco de cСdigo para impressao.                                 Ё
//Ё        Default : ExpC2                                                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//зддддддддддддддддддддддддддд©
//Ё Criacao da Primeira Secao:Ё
//юддддддддддддддддддддддддддды 
oSection1 := TRSection():New(oReport,STR0018,{"RA3","RA1"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/)	//"Curso"

#IFNDEF TOP
	TRCell():New(oSection1,"RA3_CURSO","RA3",STR0018,,,,{|| TRA->TR_CURSO })	//Codigo do Curso  
	TRPosition():New(oSection1,"RA1",1,{|| xFilial("RA1") + RA3->RA3_CURSO})   	
#ELSE                                                                                                          
	TRCell():New(oSection1,"RA3_CURSO","RA3",STR0018)	//Codigo do Curso    
#ENDIF

TRCell():New(oSection1,"RA1_DESC","RA1","")		//Descricao do Curso    

//зддддддддддддддддддддддддддд©
//Ё Criacao da Segunda Secao: Ё
//юддддддддддддддддддддддддддды

//                 1                  2                  3                           4                5                6             7             8
//TRCell():New(<oParent>	, <cName>			, [ <cAlias> ]			, [ <cTitle> ]		,[ <cPicture> ] , [ <nSize> ]	 , [ <.lPixel.> ], [ <bBlock> ],; 
//             9                    10                  11                          12               13              14             15             16
//		[ <"cAlign"> ]		, [ <.lLineBreak.> ], [ <"cHeaderAlign"> ]	, [ <.lCellBreak.> ],[ <nColSpace> ], [<.lAutoSize.>], [ <nClrBack> ], [ <nClrFore> ])

oSection2 := TRSection():New(oSection1,STR0001,{"RA3","SRA","SQ3","SQ0","SQB"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)	//"Treinamento"	
TRCell():New(oSection2,"RA3_FILIAL","RA3",STR0019)			//Filial
TRCell():New(oSection2,"RA3_MAT","RA3",STR0020,,7) 			//Matricula do Funcionario
TRCell():New(oSection2,"RA_NOME","SRA",STR0021)				//Nome do Funcionario
TRCell():New(oSection2,"Q3_GRUPO","SQ3")					//Codigo do Grupo **SUPRIMIR CAMPO
TRCell():New(oSection2,"Q0_DESCRIC","SQ0",STR0022)			//Descricao do Grupo 
TRCell():New(oSection2,"Q3_DEPTO","SQ3","")					//Codigo do Depto **SUPRIMIR CAMPO
TRCell():New(oSection2,"QB_DESCRIC","SQB",STR0023,,10)		//Descricao do Depto 
TRCell():New(oSection2,"Q3_CARGO","SQ3")					//Cargo:= fGetCargo(SRA->RA_MAT) **SUPRIMIR CAMPO
TRCell():New(oSection2,"Q3_DESCSUM","SQ3",STR0024,,,,,,,,,,.F.)		//Descricao do Cargo  
TRCell():New(oSection2,"RA3_RESERV","RA3",STR0025)			//Status da Reserva (Reservado)
TRCell():New(oSection2,"RA3_DATA","RA3",STR0026,,12)		//Data da Solicitacao
TRCell():New(oSection2,"RA3_CALEND","RA3",STR0027)			//Calendario de Treinamento
TRCell():New(oSection2,"RA2_DESC","RA2","")					//Descricado do Calendario
TRCell():New(oSection2,"RA2_DATAIN","RA2",STR0028,,12)		//Periodo: Data Inicio do Curso
TRCell():New(oSection2,"RA2_DATAFI","RA2",,,12)				//Periodo: Data Final do Curso 
TRCell():New(oSection2,"RA3_TURMA","RA3")					//Turma     
TRCell():New(oSection2,"RA_CC","SRA")						//Centro de Custo
#IFNDEF TOP	
	TRPosition():New(oSection2,"RA2",1,{|| xFilial("RA2") + RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA}) 
	TRPosition():New(oSection2,"SRA",1,{|| xFilial("SRA") + RA3->RA3_MAT})
	TRPosition():New(oSection2,"SQ0",1,{|| xFilial("SQ0") + SQ3->Q3_GRUPO})
	TRPosition():New(oSection2,"SQB",1,{|| xFilial("SQB") + SQ3->Q3_DEPTO})
	TRPosition():New(oSection2,"SI3",1,{|| xFilial("SI3") + SRA->RA_CC})     
	TRCell():New(oSection2,"I3_DESC","SI3","",,,,{|| RhDescCC(TRA->TR_CC)},,,,,,.F.)	//Descricao do Centro de Custo 
#ELSE                                                                                                          
	TRCell():New(oSection2,"I3_DESC","SI3","",,,,{|| RhDescCC(RA_CC)},,,,,,.F.)	//Descricao do Centro de Custo 
#ENDIF

TRFunction():New(oSection2:Cell("RA3_MAT" ),/*cId*/,"COUNT",/*oBreak*/,/*cTitle*/,"9999"/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
oSection2:SetTotalText({|| STR0029 })
oSection2:SetTotalInLine(.F.) 
oSection2:SetAutoSize()

Return oReport

/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддддбдддддддбдддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁReportDef() Ё Autor Ё Eduardo Ju          Ё Data Ё 19.05.06 Ё╠╠
╠╠цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁImpressao do Relatorio (Lista de Presenca)                  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё                                                            Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Static Function PrintReport(oReport,cAliasQry)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local cFil 		:= ""
Local cMat 		:= ""
Local cCc  		:= ""
Local cNom 		:= ""
Local cCur 		:= ""
Local cGru 		:= ""
Local cDep 		:= ""
Local cCar 		:= ""
Local nNecess	:= ""
Local nFerProg  := ""
Local cSitFol   := "" 
Local nOrdem  	:= osection1:GetOrder() 
Local cTamCC	:= Space(TamSx3("RA_CC")[1])

#IFNDEF TOP
	Local cAcessaRA3:= &("{ || " + ChkRH("TRM020","RA3","2") + "}")
	Local cFiltro	:= ""
	Local aFields 	:= {}
	Local cArqDBF	:= ""
#ELSE
	Local lQuery    := .F. 
	Local cExpressao:= ""
	Local cOrder	:= ""
	Local i 		:= 0
#ENDIF

Private cSituacao	:= "" 

#IFNDEF TOP
	//-- Transforma parametros Range em expressao (intervalo)
	MakeAdvplExpr("TR020R")	
#ELSE	
	//-- Transforma parametros Range em expressao SQL
	MakeSqlExpr("TR020R")
#ENDIF

//+--------------------------------------------------------------+
//╕ Carregando variaveis MV_PAR?? para Variaveis do Sistema.     ╕
//+--------------------------------------------------------------+
cFil 		:= MV_PAR01
cMat 		:= MV_PAR02
cCc  		:= MV_PAR03
cNom 		:= MV_PAR04
cCur 		:= MV_PAR05
cGru 		:= MV_PAR06
cDep 		:= MV_PAR07
cCar 		:= MV_PAR08
nNecess		:= If(!Empty(MV_PAR09),nNecess:=MV_PAR09,nNecess:=3)
cSituacao 	:= MV_PAR10
nFerProg  	:= MV_PAR11

#IFNDEF TOP	
	If !Empty(cFil)		//RA3
		cFiltro:= cFil 
	EndIf  
	
	If !Empty(cMat)		//RA3
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cMat
	EndIf  
	       
	If !Empty(cCur)		//RA3
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cCur 
	EndIf  
	
	//Define um filtro para a tabela principal da secao
	oSection2:SetFilter(cFiltro)

	If !Empty(cCc)		//SRA
		cFiltro := cCc
	EndIf  
	       
	If !Empty(cNom)		//SRA
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cNom
	EndIf  
	       
	//Define um filtro para a tabela principal da secao
	oSection2:SetFilter(cFiltro,,,"SRA")

	If !Empty(cGru)		//SQ3
		cFiltro := cGru 
	EndIf  
	
	If !Empty(cDep)		//SQ3
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cDep 
	EndIf  
	
	If !Empty(cCar)		//SQ3
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += cCar 
	EndIf  
	
	//Define um filtro para a tabela principal da secao
	oSection2:SetFilter(cFiltro,,,"SQ3")
	
	cArqDBF  := CriaTrab(NIL,.f.)
	AADD(aFields,{"TR_FILIAL", "C", FWGETTAMFILIAL,           0                       } )
	AADD(aFields,{"TR_CC",     "C", TamSx3("RA_CC")[1],       TamSx3("RA_CC")[2]      } )
	AADD(aFields,{"TR_MAT",    "C", TamSx3("RA_MAT")[1],      TamSx3("RA_MAT")[2]     } )
	AADD(aFields,{"TR_NOME",   "C", TamSx3("RA_NOME")[1],     TamSx3("RA_NOME")[2]    } )
	AADD(aFields,{"TR_CURSO",  "C", TamSx3("RA3_CURSO")[1],   TamSx3("RA3_CURSO")[2]  } )	
	AADD(aFields,{"TR_DESCUR", "C", TamSx3("RA1_DESC")[1],    TamSx3("RA1_DESC")[2]   } )
	AADD(aFields,{"TR_GRUPO",  "C", TamSx3("Q3_GRUPO")[1],    TamSx3("Q3_GRUPO")[2]   } )
	AADD(aFields,{"TR_DEPTO",  "C", TamSx3("Q3_DEPTO")[1],    TamSx3("Q3_DEPTO")[2]   } )
	AADD(aFields,{"TR_CARGO",  "C", TamSx3("Q3_CARGO")[1],    TamSx3("Q3_CARGO")[2]   } )
	AADD(aFields,{"TR_RESERV", "C", TamSx3("RA3_RESERV")[1],  TamSx3("RA3_RESERV")[2] } )
	AADD(aFields,{"TR_DATA",   "D", TamSx3("RA3_DATA")[1],    TamSx3("RA3_DATA")[2]   } )
	AADD(aFields,{"TR_CALEND", "C", TamSx3("RA3_CALEND")[1],  TamSx3("RA3_CALEND")[2] } )
	AADD(aFields,{"TR_TURMA",  "C", TamSx3("RA3_TURMA")[1],   TamSx3("RA3_TURMA")[2]  } )
	AADD(aFields,{"TR_DTINI",  "D", TamSx3("RA2_DATAIN")[1],  TamSx3("RA2_DATAIN")[2] } )
	AADD(aFields,{"TR_DTFIM",  "D", TamSx3("RA2_DATAFI")[1],  TamSx3("RA2_DATAFI")[2] } )

	dbCreate(cArqDbf,aFields)
	dbUseArea(.T.,,cArqDbf,"TRA",.F.)
	
	If nOrdem == 1		// Matricula 
		cIndCond := "TR_FILIAL + TR_CURSO + TR_MAT"
	ElseIf nOrdem == 2	// Centro de Custo + Matricula
		cIndCond := "TR_FILIAL + TR_CURSO + TR_CC + TR_MAT"
	Else				// Nome	
		cIndCond := "TR_FILIAL + TR_CURSO + TR_NOME"
	EndIf
	
	cArqNtx  := CriaTrab(NIL,.f.)
	IndRegua("TRA",cArqNtx,cIndCond,,,STR0015) //"Selecionando Registros..."
	
	dbSelectArea("RA3")
	dbGoTop()
	
	oReport:SetMeter(RecCount())
	
	While !Eof()
		
		oReport:IncMeter()
		
		If oReport:Cancel()
			Exit
		EndIf
				 
		If !Eval(cAcessaRA3)
			dbSkip()
			Loop
		EndIf
	
		dbSelectArea("RA2")
		dbSeek(xFilial("RA2")+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)
			
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё 			Buscar Nome e Centro de Custo  			   Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		dbSelectArea("SRA")
		dbSetOrder(1)	
		dbSeek(RA3->RA3_FILIAL+RA3->RA3_MAT)
				
		//здддддддддддддддддддддддддд©
		//Ё Situacao do Funcionario  Ё
		//юдддддддддддддддддддддддддды
		cSitFol := TrmSitFol( If(Empty(RA2->RA2_DATAIN),RA3->RA3_DATA,RA2->RA2_DATAIN))
		cCargo 	:= fGetCargo(SRA->RA_MAT,SRA->RA_FILIAL)
		
		If	!Empty(cCc) 
			If &("!(SRA->" + cCc + ")")
				dbSelectArea("RA3")
				dbSkip()
				Loop
			EndIf
		EndIf			

		If	!Empty(cNom)
			If &("!(SRA->" + cNom + ")")
				dbSelectArea("RA3")
				dbSkip()
				Loop
			EndIf
		EndIf			

		If	(!(cSitfol $ cSituacao) .And. (cSitFol <> "P")) .Or.;
			(cSitfol == "P" .And. nFerProg == 2)
			dbSelectArea("RA3")
			dbSkip()
			Loop
		EndIf			
				
		//здддддддддддддддддддддддддддддддддддддддд©
		//ЁCargo, Grupo e Departamento		 	   Ё
		//юдддддддддддддддддддддддддддддддддддддддды  
	 	dbSelectArea("SQ3")
		dbSetOrder(1)
		cFil := xFilial("SQ3", SRA->RA_FILIAL)
		If (dbSeek(cFil + cCargo + SRA->RA_CC) .Or. dbSeek( cFil + cCargo ) )

			If !Empty(cGru)
				If &("!" + cGru)
					dbSelectArea("RA3")
					dbSkip()
					Loop
				EndIf
			EndIf 

			If !Empty( cDep)
				If &("!" + cDep)
					dbSelectArea("RA3")
					dbSkip()
					Loop
				EndIf
			EndIf 

			If !Empty(cCar)
				If &("!" + cCar)
					dbSelectArea("RA3")
					dbSkip()
					Loop
				EndIf
			EndIf 
		Else
			dbSelectArea("RA3")
			dbSkip()
			Loop			
		EndIf
	
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё               Grava arquivo Temporario 		           Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		dbSelectArea("TRA")
		RecLock("TRA",.T.)
		
		TRA->TR_FILIAL	:= RA3->RA3_FILIAL
		TRA->TR_MAT		:= RA3->RA3_MAT
		TRA->TR_CURSO	:= RA3->RA3_CURSO
		TRA->TR_RESERV	:= RA3->RA3_RESERV 
		TRA->TR_DATA	:= RA3->RA3_DATA
		TRA->TR_NOME	:= SRA->RA_NOME
		TRA->TR_CC		:= SRA->RA_CC
		TRA->TR_DESCUR	:= RA1->RA1_DESC
		TRA->TR_CARGO  	:= SQ3->Q3_CARGO
		TRA->TR_GRUPO	:= SQ3->Q3_GRUPO
		TRA->TR_DEPTO  	:= SQ3->Q3_DEPTO
		TRA->TR_CALEND 	:= RA3->RA3_CALEND
		TRA->TR_TURMA	:= RA3->RA3_TURMA
		
		dbSelectArea("RA2")
		dbSetOrder(1)                                                 
		cFil := xFilial("RA2", RA3->RA3_FILIAL)
		dbSeek(cFil+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)
		
		dbSelectArea("TRA")
		TRA->TR_DTINI	:= RA2->RA2_DATAIN
		TRA->TR_DTFIM	:= RA2->RA2_DATAFI
		
		MsUnlock()
			
		DbSelectArea("RA3")
		DbSkip()
	EndDo 
	
	dbSelectArea("TRA")
	dbGotop()
	          	
	TRPosition():New(oSection1,"RA1",1,{|| RhFilial("RA1",TRA->TR_FILIAL) + TRA->TR_CURSO})
	TRPosition():New(oSection1,"RA3",1,{|| RhFilial("RA3",TRA->TR_FILIAL) + TRA->TR_MAT})
	TRPosition():New(oSection2,"RA3",1,{|| RhFilial("RA3",TRA->TR_FILIAL) + TRA->TR_MAT}) 
	TRPosition():New(oSection2,"RA2",1,{|| RhFilial("RA2",TRA->TR_FILIAL) + TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA})
	TRPosition():New(oSection2,"SRA",1,{|| RhFilial("SRA",TRA->TR_FILIAL) + TRA->TR_MAT})
	TRPosition():New(oSection2,"SQ0",1,{|| RhFilial("SQ0",TRA->TR_FILIAL) + TRA->TR_GRUPO})
	TRPosition():New(oSection2,"SQ3",2,{|| RhFilial("SQ3",TRA->TR_FILIAL) + TRA->TR_GRUPO + TRA->TR_DEPTO + TRA->TR_CARGO})
	TRPosition():New(oSection2,"SI3",1,{|| RhFilial("SI3",TRA->TR_FILIAL) + TRA->TR_CC})
	   
	Do While ! Eof()
		
		oReport:IncMeter()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		cCurso := TRA->TR_CURSO 
	    
		lFirst := .T.
		
		oSection1:Init()
		oSection1:SetTotalText( {|| STR0029 } )
		oSection1:PrintLine()
		
		oSection2:Init()	
		
		Do While !Eof() .And. cCurso == TRA->TR_CURSO    
			oSection2:SetTotalText( {|| STR0029 } )
		       
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё            Verifica necessidade do Cargo 	           Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды  
			dbSelectArea("RA5")
			dbSetOrder(2)
			cFil := xFilial("RA5", TRA->TR_FILIAL)
			
			lAchou 	:= 	(dbSeek( cFil + TRA->TR_CARGO + TRA->TR_CC + TRA->TR_CURSO )) .Or.;
						(dbSeek( cFil + TRA->TR_CARGO + TRA->TR_CURSO ))		
			
			If nNecess == 1 	//Necessidade do Cargo
	
				If lAchou 
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Impressao da Segunda Secao: Funcionarios			 Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					oSection2:Cell("Q3_GRUPO"):Disable()
					oSection2:Cell("Q3_DEPTO"):Disable()
					oSection2:Cell("Q3_CARGO"):Disable()
					oSection2:PrintLine()
					lFirst := .F.
	        	EndIf
	        
			Else  			//Solicitacao (S/ necessidade do cargo)     
				If !lAchou .Or. nNecess == 3
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Impressao da Segunda Secao: Funcionarios			 Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддды
					oSection2:Cell("Q3_GRUPO"):Disable()
					oSection2:Cell("Q3_DEPTO"):Disable()
					oSection2:Cell("Q3_CARGO"):Disable()
					oSection2:PrintLine()
					lFirst := .F.
				EndIf
			EndIf 
			
			dbSelectArea("TRA")
			dbSkip()
	
		EndDo 
	
		oSection2:Finish()
		oSection1:Finish()
		
	EndDo 
	
	dbSelectArea("TRA")
	dbCloseArea()
	fErase( cArqNtx + OrdBagExt() )
	fErase( cArqDBF )
	
#ELSE

	//-- Filtragem do relatСrio
	//-- Query do relatСrio da secao 1
	lQuery := .T.          

	If nOrdem == 1		// Matricula 
		cOrder := "%RA3_CURSO,RA3_FILIAL,RA3_MAT%"	//"TR_FILIAL + TR_CURSO + TR_MAT"
	ElseIf nOrdem == 2	// Centro de Custo + Matricula
		cOrder := "%RA3_CURSO,RA3_FILIAL,RA_CC,RA3_MAT%"
	Else				// Nome	
		cOrder := "%RA3_CURSO,RA3_FILIAL,RA_NOME%"
	EndIf

	oReport:Section(1):BeginQuery()	
	
	cFilRA1 := "% AND RA1.RA1_FILIAL = " + IIf( Empty(xFilial("RA1")), "'" + Space(FWGETTAMFILIAL) + "'", "RA3.RA3_FILIAL") + "%"
	cFilRA2 := "% AND RA2.RA2_FILIAL = " + IIf( Empty(xFilial("RA2")), "'" + Space(FWGETTAMFILIAL) + "'", "RA3.RA3_FILIAL") + "%"
	cFilSRA := "% AND SRA.RA_FILIAL  = " + IIf( Empty(xFilial("SRA")), "'" + Space(FWGETTAMFILIAL) + "'", "RA3.RA3_FILIAL") + "%"
	cFilSQ3 := "% AND SQ3.Q3_FILIAL  = " + IIf( Empty(xFilial("SQ3")), "'" + Space(FWGETTAMFILIAL) + "'", "SRA.RA_FILIAL") + "%"
	cFilSQ0 := "% AND SQ0.Q0_FILIAL  = " + IIf( Empty(xFilial("SQ0")), "'" + Space(FWGETTAMFILIAL) + "'", "SQ3.Q3_FILIAL") + "%"
	cFilSRJ := "% AND SRJ.RJ_FILIAL  = " + IIf( Empty(xFilial("SRJ")), "'" + Space(FWGETTAMFILIAL) + "'", "SRA.RA_FILIAL") + "%"
		
	If !Empty(MV_PAR01)	
   		cExpressao:= MV_PAR01
	EndIf
	
	If !Empty(MV_PAR02)		
		cExpressao += Iif(!Empty(cExpressao)," AND ","")
		cExpressao += MV_PAR02
	EndIf
	
	If !Empty(MV_PAR03)	
		cExpressao += Iif(!Empty(cExpressao)," AND ","")
		cExpressao += MV_PAR03 
	EndIf
	
	If !Empty(MV_PAR04)	
		cExpressao += Iif(!Empty(cExpressao)," AND ","")
		cExpressao += MV_PAR04
	EndIf
	
	If !Empty(MV_PAR05)	
		cExpressao += Iif(!Empty(cExpressao)," AND ","")
		cExpressao += MV_PAR05
	EndIf
	
	If !Empty(MV_PAR06)	
		cExpressao += Iif(!Empty(cExpressao)," AND ","")
		cExpressao += MV_PAR06
	EndIf
	
	If !Empty(MV_PAR07)	
		cExpressao += Iif(!Empty(cExpressao)," AND ","")
		cExpressao += MV_PAR07
	EndIf
	
	If !Empty(MV_PAR08)	
		cExpressao += Iif(!Empty(cExpressao)," AND ","")
		cExpressao += MV_PAR08
	EndIf
	
	If nNecess == 1 //Necessidade do Cargo
		cExpressao += Iif(!Empty(cExpressao)," AND ","") + "EXISTS ( SELECT 1 FROM " + RetSqlName("RA5") + " RA5 WHERE RA5_CARGO = Q3_CARGO AND ( (RA5_CC = RA_CC) or (RA5_CC = '" + cTamCC + "')) AND RA5_CURSO = RA3_CURSO )"
	ElseIf nNecess == 2	//Solicitacao	
		cExpressao += Iif(!Empty(cExpressao)," AND ","") + "NOT EXISTS ( SELECT 1 FROM " + RetSqlName("RA5")  + " RA5 WHERE RA5_CARGO = Q3_CARGO AND ( (RA5_CC = RA_CC) or (RA5_CC = '" + cTamCC + "')) AND RA5_CURSO = RA3_CURSO )" 
	EndIf	
		
	If !Empty(cExpressao)
		cExpressao += " AND "
	EndIf
	
	cExpressao := "%"+cExpressao+"%"
	
	BeginSql Alias cAliasQry
	
		SELECT DISTINCT	RA3_FILIAL,RA3_CURSO,RA1_DESC,RA3_MAT,RA3_DATA,RA_NOME,Q3_GRUPO,Q0_DESCRIC,Q3_DEPTO,
				QB_DESCRIC,Q3_CARGO,Q3_DESCSUM,RA3_RESERV,RA3_CALEND,RA2_DESC,
				RA2_DATAIN,RA2_DATAFI,RA3_TURMA,RA_CC/*,I3_DESC*/
		FROM 	%table:RA3% RA3		  
		INNER JOIN %table:RA1% RA1
			ON RA1_CURSO = RA3_CURSO
			AND RA1.%NotDel% 
			%exp:cFilRA1%
		LEFT JOIN %table:RA2% RA2
			ON RA2_CALEND = RA3_CALEND
			AND RA2_CURSO = RA3_CURSO
			AND RA2_TURMA = RA3_TURMA
			AND RA2.%NotDel% 
			%exp:cFilRA2%  	  
		INNER JOIN %table:SRA% SRA
			ON RA_MAT = RA3_MAT
			AND SRA.%NotDel% 
			%exp:cFilSRA%  
		INNER JOIN %table:SQ3% SQ3
			ON Q3_CARGO = RA_CARGO
			AND SQ3.%NotDel%			 								
			%exp:cFilSQ3% 
		INNER JOIN %table:SQ0% SQ0
			ON Q0_GRUPO = Q3_GRUPO
			AND SQ0.%NotDel%
			%exp:cFilSQ0% 
		LEFT JOIN %table:SQB% SQB
			ON QB_FILIAL = %xFilial:SQB%
			AND QB_DEPTO = Q3_DEPTO
			AND SQB.%NotDel%					
		WHERE 	%exp:cExpressao%
				RA3.%NotDel%  //Se remover essa expressao podera ocorrer erro na compilacao

	   	UNION 

		SELECT DISTINCT RA3_FILIAL,RA3_CURSO,RA1_DESC,RA3_MAT,RA3_DATA,RA_NOME,Q3_GRUPO,Q0_DESCRIC,Q3_DEPTO,
				QB_DESCRIC,Q3_CARGO,Q3_DESCSUM,RA3_RESERV,RA3_CALEND,RA2_DESC,
				RA2_DATAIN,RA2_DATAFI,RA3_TURMA,RA_CC
		FROM 	%table:RA3% RA3		 
		 
		INNER JOIN %table:RA1% RA1
			ON RA1_CURSO = RA3_CURSO
			AND RA1.%NotDel% 
			%exp:cFilRA1%
		LEFT JOIN %table:RA2% RA2
			ON RA2_CALEND = RA3_CALEND
			AND RA2_CURSO = RA3_CURSO
			AND RA2_TURMA = RA3_TURMA
			AND RA2.%NotDel%
			%exp:cFilRA2%  
		INNER JOIN %table:SRA% SRA
			ON RA_MAT = RA3_MAT
			AND SRA.%NotDel% 
			%exp:cFilSRA%  
		INNER JOIN %table:SRJ% SRJ
			ON RJ_FUNCAO = RA_CODFUNC
			AND SRJ.%NotDel%
			%exp:cFilSRJ% 
		INNER JOIN %table:SQ3% SQ3
			ON Q3_CARGO = RJ_CARGO
			AND SQ3.%NotDel%
			%exp:cFilSQ3% 
		INNER JOIN %table:SQ0% SQ0
			ON Q0_GRUPO = Q3_GRUPO
			AND SQ0.%NotDel%
			%exp:cFilSQ0% 
		LEFT JOIN %table:SQB% SQB
			ON QB_FILIAL = %xFilial:SQB%
			AND QB_DEPTO = Q3_DEPTO
			AND SQB.%NotDel%					 	
		WHERE RA_CARGO = '     ' AND
			%exp:cExpressao%
			RA3.%NotDel% //Se remover essa expressao podera ocorrer erro na compilacao
		  										
		ORDER BY %Exp:cOrder%                 		
	EndSql
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁMetodo EndQuery ( Classe TRSection )                                    Ё
	//ЁPrepara o relatСrio para executar o Embedded SQL.                       Ё
	//ЁExpA1 : Array com os parametros do tipo Range                           Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oReport:Section(1):EndQuery()
		
	//-- Inicio da impressao do fluxo do relatСrio
	oReport:SetMeter(RA3->(LastRec()))

	//-- Utiliza a query do Pai
	oSection2:SetParentQuery()
	oSection2:SetParentFilter( { |cParam| (cAliasQry)->RA3_CURSO == cParam },{ || (cAliasQry)->RA3_CURSO })
	
	//Valida Situacao do Funcionario 
	oSection2:SetLineCondition({|| fChkSit(cAliasQry)})

	oSection2:Cell("Q3_GRUPO"):Disable()
	oSection2:Cell("Q3_DEPTO"):Disable()
	oSection2:Cell("Q3_CARGO"):Disable()
	oSection1:Print()	 //Imprimir

#ENDIF
	
Return Nil

/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддддбдддддддбдддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    ЁfChkSit     Ё Autor Ё Eduardo Ju          Ё Data Ё 10.10.07 Ё╠╠
╠╠цддддддддддеддддддддддддадддддддадддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao ЁCheca a Situacao do Funcionario                             Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁParametrosЁ                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё TRM020                                                     Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Function fChkSit(cAliasQry)   

Local aSaveArea	:= GetArea()
Local lChkSit	:= .F.  

SRA->(dbSeek( (cAliasQry)->RA3_FILIAL+(cAliasQry)->RA3_MAT ))
lChkSit := TrmSitFol( If(Empty((cAliasQry)->RA2_DATAIN),(cAliasQry)->RA3_DATA,(cAliasQry)->RA2_DATAIN)) $ cSituacao
       
RestArea(aSaveArea)

Return(lChkSit)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбдддддддддддддддбдддддддбддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁAjustaTR020RSx1Ё Autor Ё Tania Bronzeri   Ё Data Ё18/09/2006Ё╠╠
╠╠цддддддддддедддддддддддддддадддддддаддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Ajusta SX1 para Trabalhar com Range                        Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё A partir do Release 4                                      Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Function AjustaTR020RSx1()

Local aRegs		:= {}
Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}   
Local cHelp		:= ""

aHelp := {	"Informe intervalo de filiais que ",;
			"deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de filiais que ",;
			"desea considerar para impresion ",;
			"del informe" }
aHelpI:= {	"Enter branch range to be considered ",;
			"to print report." }
cHelp := ".RHFILIAL."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo   Ordem   Pergunta Portugues   Pergunta Espanhol    Pergunta Ingles   Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01 DefSPA1  DefEng1 Cnt01        Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg  cPyme aHelpPor aHelpEng aHelpSpa cHelp   Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Aadd(aRegs,{"TR020R","01","Filial ?"           ,"©Sucursal ?"       ,"Branch ?"       ,"MV_CH1","C" ,99      ,0     ,0     ,"R"  ,""     ,"MV_PAR01",""    ,""      ,""    ,"RA3_FILIAL",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"XM0",""    ,"S"  ,""      ,""     ,""      ,cHelp})


aHelp := {	"Informe intervalo de matriculas que ",;
			"deseja considerar para impressao do ",;
			"relatorio." }
aHelpE:= {	"Informe intervalo de matriculas que ",;
			"desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter registration range to be ",;
			"considered for printing the report." }
cHelp := ".RHMATRIC."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol    Pergunta Ingles  Variavel  Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1  Cnt01     Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05 XF3   GrgSxg  cPyme aHelpPor aHelpEng  aHelpSpa cHelp  Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Aadd(aRegs,{"TR020R","02","Matricula ?"       ,"©Matricula ?"     ,"Registration ?"  ,"MV_CH2" ,"C"  ,99      ,0     ,0     ,"R"  ,""     ,"MV_PAR02",""    ,""      ,""     ,"RA3_MAT",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""  ,"SRA",""    ,"S"  ,""     ,""       ,""     ,cHelp})


aHelp := {	"Informe intervalo de Centros de Custo ",;
			"que deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de centros de costo ",;
			"que desea considerar para impresion ",;
			"del informe." }
aHelpI:= {	"Enter the cost center range to be ",;
			"considered for printing the report." }
cHelp := ".RHCCUSTO."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol   Pergunta Ingles  Variavel Tipo Tamanho  Decimal Presel GSC   Valid   Var01      Def01 DefSPA1  DefEng1  Cnt01   Var02  Def02  DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05 XF3  GrgSxg  cPyme aHelpPor aHelpEng aHelpSpa cHelp   Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Aadd(aRegs,{"TR020R","03","Centro de Custo ?","©Centro de Costo ?","Cost Center ?" ,"MV_CH3","C" ,99      ,0      ,0     ,"R"  ,""     ,"MV_PAR03",""    ,""      ,""    ,"RA_CC",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"CTT","004"  ,"S"  ,""      ,""      ,""     ,cHelp})


aHelp := {	"Informe intervalo de nomes de funcio-",;
			"narios que deseja considerar para im-",;
			"pressao do relatorio." }
aHelpE:= {	"Informe intervalo de nombres de empleados ",;
			"que desea considerar para impresion del ",;
			"informe." }
aHelpI:= {	"Enter range of employee names to be ",;
			"considered for printing the report." }
cHelp := ".RHNOME."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol  Pergunta Ingles  Variavel  Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1  Cnt01    Var02  Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3     GrgSxg  cPyme aHelpPor aHelpEng  aHelpSpa cHelp  Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддxддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Aadd(aRegs,{"TR020R","04" ,"Nome  ?"           ,"©Nombre  ?"       ,"Name   ? "      ,"MV_CH4" ,"C"  ,99      ,0     ,0     ,"R"  ,""     ,"MV_PAR04",""    ,""      ,""     ,"RA_NOME",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""  ,"",""    ,"S"  ,""     ,""      ,""      ,cHelp}) //SRA01


aHelp := {	"Informe intervalo de Cursos que deseja ",;
			"considerar para impressao do relatorio. " }
aHelpE:= {	"Informe intervalo de Cursos que desea ",;
			"considerar para impresion del informe. " }
aHelpI:= {	"Enter range of Courses to be considered ",;
			"for printing the report." }
cHelp := ".TR020R05."
/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel  Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01       Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp   Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Aadd(aRegs,{"TR020R","05" ,"Curso ?"          ,"©Curso ?"       ,"Course ?"     ,"MV_CH5" ,"C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR05",""    ,""      ,""     ,"RA3_CURSO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"RA1",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe intervalo de Grupos que deseja ",;
			"considerar para impressao do relatorio. " }
aHelpE:= {	"Informe intervalo de Grupos que desea ",;
			"considerar para impresion del informe. " }
aHelpI:= {	"Enter range of Groups to be considered ",;
			"for printing the report." }
cHelp := ".TR020R06."
/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01      Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp     Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Aadd(aRegs,{"TR020R","06" ,"Grupo ?"          ,"©Grupo ?"       ,"Group ?"      ,"MV_CH6","C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR06",""    ,""      ,""     ,"Q3_GRUPO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"SQ0",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe intervalo de Departamentos ",;
			"que deseja considerar para impressao ",;
			"do relatorio. " }
aHelpE:= {	"Informe intervalo de Sectores que desea ",;
			"considerar para impresion del informe. " }
aHelpI:= {	"Enter range of Department to be ",;
			"considered for printing the report." }
cHelp := ".TR020R07."
/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01      Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp     Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Aadd(aRegs,{"TR020R","07" ,"Departamento ?"   ,"©Sector ?"      ,"Department ?" ,"MV_CH7","C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR07",""    ,""      ,""     ,"Q3_DEPTO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"SQB",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe intervalo de Cargos que ",;
			"deseja considerar para impressao ",;
			"do relatorio. " }
aHelpE:= {	"Informe intervalo de Funciones que ",;
			"desea considerar para impresion del ",;
			"informe. " }
aHelpI:= {	"Enter range of Jobs to be considered ",;
			"for printing the report." }
cHelp := ".TR020R08."
/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC   Valid   Var01      Def01  DefSPA1  DefEng1 Cnt01      Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3   GrgSxg cPyme aHelpPor aHelpEng  aHelpSpa cHelp     Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Aadd(aRegs,{"TR020R","08" ,"Cargo ?"          ,"©Funcion ?"      ,"Job ?"       ,"MV_CH8","C" ,99     ,0      ,0     ,"R"  ,""     ,"MV_PAR08",""    ,""      ,""     ,"Q3_CARGO",""   ,""    ,""     ,""     ,""  ,""   ,""    ,""      ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"SQ3",""    ,"S"  ,aHelp   ,aHelpI   ,aHelpE  ,cHelp})


aHelp := {	"Informe se deseja gerar o Relatorio ",;
			"de Rreinamento por: Necessidade de ",;
			"Treinamento, Solicitacao de Treina-",;
			"mento ou Ambos. " }
aHelpE:= {	"Especifique si desea generar el ",;
			"informe de entrenamiento por: ",;
			"necesidad de entrenamiento, ",;
			"solicitud de entrenamiento o ambos. " }
aHelpI:= {	"Inform if you want to generate the ",;
			"Training Report by: Training Need, ",;
			"Training Requisition or Both. " }
cHelp := ".TR020R09."
/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo   Ordem   Pergunta Portugues  Pergunta Espanhol      Pergunta Ingles Variavel Tipo Tamanho Decimal Presel GSC Valid          Var01      Def01         DefSPA1     DefEng1     Cnt01 Var02 Def02         DefSpa2      DefEng2       Cnt02 Var03 Def03   DefSpa3  DefEng3 Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05 Def05 DefSpa5 DefEng5 Cnt05  XF3 GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp         Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Aadd(aRegs,{"TR020R","09" ,"Treinamento por ?","©Entrenamiento por ?","Training by ?","MV_CH9","N" ,1      ,0      ,3     ,"C","NaoVazio()" ,"MV_PAR09","Necessidade","Necesidad","Necessity",""   ,""   ,"Solicitacao","Solicitud","Requisition",""   ,""   ,"Ambos","Ambos","Both"  ,""  ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,"" ,""    ,"S"  ,aHelp   ,aHelpI  ,aHelpE  ,cHelp})
Aadd(aRegs,{"TR020R","10","Situacoes ?"       ,"©Situaciones ?"      ,"Status ?"     ,"MV_CHA","C" ,5      ,0      ,0     ,"G","fSituacao()","MV_PAR10",""           ,""         ,""         ,""   ,""   ,""           ,""         ,""           ,""   ,""   ,""     ,""     ,""      ,""  ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,"" ,""    ,"S"  ,""      ,""      ,""      ,".RHSITUA."})


aHelp := {	"Informe se deseja considerar Ferias ",;
			"Programadas." }
aHelpE:= {	"Informe si desea considerar ",;
			"Vacaciones Programadas." }
aHelpI:= {	"Inform if you want to consider ",;
			"Scheduled Vacation. " }
cHelp := ".TR020R11."
/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё           Grupo   Ordem   Pergunta Portugues     Pergunta Espanhol           Pergunta Ingles        Variavel Tipo Tamanho Decimal Presel GSC Valid          Var01      Def01 DefSPA1 DefEng1 Cnt01 Var02 Def02 DefSpa2 DefEng2 Cnt02 Var03 Def03 DefSpa3 DefEng3 Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04 Var05 Def05 DefSpa5 DefEng5 Cnt05  XF3 GrgSxg cPyme aHelpPor aHelpEng aHelpSpa cHelp         Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Aadd(aRegs,{"TR020R","11" ,"Ferias Programadas ?","©Vacaciones Programadas ?","Scheduled Vacation?" ,"MV_CHB","N" ,1      ,0      ,1     ,"C","NaoVazio()" ,"MV_PAR11","Sim","Si"   ,"Yes"  ,""   ,""   ,"Nao","NO"   ,"No"   ,""   ,""   ,""  ,""     ,""     ,""  ,""   ,""   ,""     ,""     ,""   ,""   ,""   ,""     ,""     ,""   ,"" ,""    ,"S"  ,aHelp   ,aHelpI  ,aHelpE  ,cHelp})


ValidPerg(aRegs,"TR020R",.T.)

                








//======>>>>>>>> Daqui para baixo, trata-se do release 3 ou anterior.
/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  Ё TRM020   Ё Autor Ё Equipe R.H.           Ё Data Ё 16/03/99 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Relatorio de Treinamentos (Solicitacao)                    Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё TRM020                                                     Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё RdMake                                                     Ё╠╠
╠╠цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё         ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL.             Ё╠╠
╠╠цддддддддддддбддддддддбддддддбдддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁProgramador Ё Data   Ё BOPS Ё  Motivo da Alteracao                     Ё╠╠
╠╠цддддддддддддеддддддддеддддддедддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё			   Ё		Ё      Ё 										  Ё╠╠
╠╠юддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
User Function TRM020R3()

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("TITULO,AT_PRG,WCABEC0,WCABEC1,CONTFL,LI")
SetPrvt("NPAG,NTAMANHO,CTIT")
SetPrvt("WNREL,NORDEM,CFILDE,CFILATE,CMATDE,CMATATE")
SetPrvt("CCCDE,CCCATE,CNOMDE,CNOMATE,CCURDE,CCURATE")
SetPrvt("CGRUDE,CGRUATE,CDEPDE,CDEPATE,CCARDE,CCARATE")
SetPrvt("NNECESS,CFIL,CINICIO,CFIM,LIMPDET")
SetPrvt("CRESERVA,DET,DETCURSO,LFIRST") 
SetPrvt("CARQDBF,AFIELDS,CACESSARA3,NCHAR,CORDEM") 

cDesc1  := STR0001 //"Treinamento"
cDesc2  := STR0002 //"SerА impresso de acordo com os parametros solicitados pelo"
cDesc3  := STR0003 //"usuАrio."
cString := "RA1"   //-- alias do arquivo principal (Base)
aOrd    := { STR0004,STR0005,STR0006 } //"Matricula"###"Centro de Custo"###"Nome"

//+--------------------------------------------------------------+
//╕ Define Variaveis (Basicas)                                   ╕
//+--------------------------------------------------------------+
aReturn  := { STR0007,1,STR0008,2,2,1,"",1 } //"Zebrado"###"AdministraГДo"
NomeProg := "TRM020"
aLinha   := {}
nLastKey := 0
cPerg    := "TRR040"
lEnd     := .F.

//+--------------------------------------------------------------+
//╕ Define Variaveis (Programa)                                  ╕
//+--------------------------------------------------------------+
Colunas  	:= 220
Titulo   	:= STR0009 //"SOLICITACAO/RESERVA DE TREINAMENTO"
AT_PRG   	:= "TRM020"
wCabec0  	:= 1
wCabec1  	:= STR0011 //"FIL. MATR.  NOME                           GRUPO           DEPARTAMENTO         CARGO                        SITUACAO     DT.SOLIC.  CALENDARIO                        PERIODO         TURMA C.CUSTO"
Contfl   	:= 1
Li       	:= 0
nPag     	:= 0
nTamanho 	:= "G"
nChar		:= 15
cTit     	:= STR0009 //"SOLICITACAO/RESERVA DE TREINAMENTO"

//+--------------------------------------------------------------+
//╕ Verifica as perguntas selecionadas                           ╕
//+--------------------------------------------------------------+
AjustR3SX1("TRR040")
pergunte("TRR040",.F.)

//+--------------------------------------------------------------+
//╕ Variaveis utilizadas para parametros                         ╕
//╕ MV_PAR01        //  Filial  De                               ╕
//╕ MV_PAR02        //  Filial  Ate                              ╕
//╕ MV_PAR03        //  Matricula De                             ╕
//╕ MV_PAR04        //  Matricula Ate                            ╕
//╕ MV_PAR05        //  Centro de Custo                          ╕
//╕ MV_PAR06        //  Centro de Custo                          ╕
//╕ MV_PAR07        //  Nome De                                  ╕
//╕ MV_PAR08        //  Nome Ate                                 ╕
//╕ MV_PAR09        //  Curso De                                 ╕
//╕ MV_PAR10        //  Curso Ate                                ╕
//╕ MV_PAR11        //  Grupo De                                 ╕
//╕ MV_PAR12        //  Grupo Ate                                ╕
//╕ MV_PAR13        //  Departamento De                          ╕
//╕ MV_PAR14        //  Departamento Ate                         ╕
//╕ MV_PAR15        //  Cargo De                                 ╕
//╕ MV_PAR16        //  Cargo Ate                                ╕
//╕ MV_PAR17        //  Treinamento por:Necessidade/Solic./Ambos ╕
//╕ MV_PAR18        //  Status Funcionario                       ╕
//╕ MV_PAR19        //  Ferias Programadas                       ╕
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//╕ Envia controle para a funcao SETPRINT                        ╕
//+--------------------------------------------------------------+
WnRel :="TRM020"  //-- Nome Default do relatorio em Disco.
WnRel :=SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F., nTamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Relato()},cTit)
Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  Ё Relato   Ё Autor Ё Equipe R.H.		    Ё Data Ё 19/03/99 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Rotina Principal do Relatorio.							  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё Relato()	                                                  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё Rdmake	                                                  Ё╠╠
╠╠цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Static Function Relato()

Local lAchou 	:= .F.
Local cCargo	:= "" 

nOrdem  	:= aReturn[8]
cAcessaRA3	:= &("{ || " + ChkRH("TRM020","RA3","2") + "}")

If nOrdem == 1
	cOrdem := STR0004 		// "Matricula"
ElseIf nOrdem == 2
	cOrdem := STR0005 		// "Centro de Custo"
Else
	cOrdem := STR0006 		// "Nome"
EndIf

cOrdem := " ("+STR0016+cOrdem+")"	// "Ordem de "

cTit   := STR0009 + cOrdem 	// "SOLICITACAO/RESERVA DE TREINAMENTO"
Titulo := cTit

//+--------------------------------------------------------------+
//╕ Carregando variaveis MV_PAR?? para Variaveis do Sistema.     ╕
//+--------------------------------------------------------------+
If(!Empty(MV_PAR01),cFilDe :=MV_PAR01,cFilDe := Space(FWGETTAMFILIAL) )
If(!Empty(MV_PAR02),cFilAte:=MV_PAR02,cFilAte:= Replicate("Z", FWGETTAMFILIAL) )
If(!Empty(MV_PAR03),cMatDe :=MV_PAR03,cMatDe := Space(GetSx3Cache("RA_MAT", "X3_TAMANHO" )) )
If(!Empty(MV_PAR04),cMatAte:=MV_PAR04,cMatAte:= Replicate("9", GetSx3Cache("RA_MAT","X3_TAMANHO" )) )
If(!Empty(MV_PAR05),cCcDe  :=MV_PAR05,cCcDe  := Space(GetSx3Cache("RA_CC", "X3_TAMANHO" )))
If(!Empty(MV_PAR06),cCcAte :=MV_PAR06,cCcAte := Replicate("Z", GetSx3Cache("RA_CC","X3_TAMANHO" )) ) 
If(!Empty(MV_PAR07),cNomDe :=MV_PAR07,cNomDe := Space(GetSx3Cache("RA_NOME", "X3_TAMANHO" )))
If(!Empty(MV_PAR08),cNomAte:=MV_PAR08,cNomAte:= Replicate("Z", GetSx3Cache("RA_NOME","X3_TAMANHO" )) ) 
If(!Empty(MV_PAR09),cCurDe :=MV_PAR09,cCurDe := Space(GetSx3Cache("RA3_CURSO", "X3_TAMANHO" )) )
If(!Empty(MV_PAR10),cCurAte:=MV_PAR10,cCurAte:= Replicate("9", GetSx3Cache("RA3_CURSO", "X3_TAMANHO" )) )
If(!Empty(MV_PAR11),cGruDe :=MV_PAR11,cGruDe := Space(GetSx3Cache("Q3_GRUPO", "X3_TAMANHO" )) )
If(!Empty(MV_PAR12),cGruAte:=MV_PAR12,cGruAte:= Replicate("9", GetSx3Cache("Q3_GRUPO", "X3_TAMANHO" )) )
If(!Empty(MV_PAR13),cDepDe :=MV_PAR13,cDepDe := Space(GetSx3Cache("Q3_DEPTO", "X3_TAMANHO" )) )
If(!Empty(MV_PAR14),cDepAte:=MV_PAR14,cDepAte:= Replicate("9", GetSx3Cache("Q3_DEPTO", "X3_TAMANHO" )) )
If(!Empty(MV_PAR15),cCarDe :=MV_PAR15,cCarDe := Space(GetSx3Cache("RA_CARGO", "X3_TAMANHO" )) )
If(!Empty(MV_PAR16),cCarAte:=MV_PAR16,cCarAte:= Replicate("9", GetSx3Cache("RA_CARGO", "X3_TAMANHO" )) )
If(!Empty(MV_PAR17),nNecess:=MV_PAR17,nNecess:=3)
cSituacao := MV_PAR18
nFerProg  := MV_PAR19
cSitFol   := ""

cArqDBF  := CriaTrab(NIL,.f.)
aFields 	:= {}
AADD(aFields,{"TR_FILIAL", "C", FWGETTAMFILIAL,          0                       } )
AADD(aFields,{"TR_CC",     "C", TamSx3("RA_CC")[1],      TamSx3("RA_CC")[2]      } )
AADD(aFields,{"TR_MAT",    "C", TamSx3("RA_MAT")[1],     TamSx3("RA_MAT")[2]     } )
AADD(aFields,{"TR_NOME",   "C", TamSx3("RA_NOME")[1],    TamSx3("RA_NOME")[2]    } )
AADD(aFields,{"TR_CURSO",  "C", TamSx3("RA3_CURSO")[1],  TamSx3("RA3_CURSO")[2]  } )
AADD(aFields,{"TR_DESCUR", "C", TamSx3("RA1_DESC")[1],   TamSx3("RA1_DESC")[2]   } )
AADD(aFields,{"TR_GRUPO",  "C", TamSx3("Q3_GRUPO")[1],   TamSx3("Q3_GRUPO")[2]   } )
AADD(aFields,{"TR_DEPTO",  "C", TamSx3("Q3_DEPTO")[1],   TamSx3("Q3_DEPTO")[2]   } )
AADD(aFields,{"TR_CARGO",  "C", TamSx3("Q3_CARGO")[1],   TamSx3("Q3_CARGO")[2]   } )
AADD(aFields,{"TR_RESERV", "C", TamSx3("RA3_RESERV")[1], TamSx3("RA3_RESERV")[2] } )
AADD(aFields,{"TR_DATA",   "D", TamSx3("RA3_DATA")[1],   TamSx3("RA3_DATA")[2]   } )
AADD(aFields,{"TR_CALEND", "C", TamSx3("RA3_CALEND")[1], TamSx3("RA3_CALEND")[2] } )
AADD(aFields,{"TR_TURMA",  "C", TamSx3("RA3_TURMA")[1],  TamSx3("RA3_TURMA")[2]  } )
AADD(aFields,{"TR_DTINI",  "D", TamSx3("RA2_DATAIN")[1],  TamSx3("RA2_DATAIN")[2] } )
AADD(aFields,{"TR_DTFIM",  "D", TamSx3("RA2_DATAFI")[1],  TamSx3("RA2_DATAFI")[2] } )

dbCreate(cArqDbf,aFields)
dbUseArea(.T., NIL, cArqDbf, "TRA", .F.)

If nOrdem == 1		// Matricula 
	cIndCond := "TR_FILIAL + TR_CURSO + TR_MAT"
ElseIf nOrdem == 2	// Centro de Custo + Matricula
	cIndCond := "TR_FILIAL + TR_CURSO + TR_CC + TR_MAT"
Else				// Nome	
	cIndCond := "TR_FILIAL + TR_CURSO + TR_NOME"
EndIf

cArqNtx  := CriaTrab(NIL,.f.)
IndRegua("TRA",cArqNtx,cIndCond,,,STR0015) //"Selecionando Registros..."
dbGoTop()

dbSelectArea("RA3")
dbSetOrder(1)
dbSeek(cFilDe+cMatDe+cCurDe,.T.)
cInicio	:= "RA3->RA3_FILIAL + RA3->RA3_MAT + RA3->RA3_CURSO" 
cFim	:= cFilAte + cMatAte + cCurAte

lImpDet  := .F.

SetRegua(RecCount())

While !Eof() .And. &cInicio <= cFim

	//+--------------------------------------------------------------+
	//╕ Incrementa Regua de Processamento.                           ╕
	//+--------------------------------------------------------------+
	IncRegua()
		
	If RA3->RA3_CURSO  < cCurDe .Or. RA3->RA3_CURSO  > cCurAte .Or.!Eval(cAcessaRA3)
		dbSkip()
		Loop
	EndIf

	dbSelectArea("RA2")
	dbSeek(xFilial("RA2")+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)
	   
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё 			Buscar Nome e Centro de Custo  			   Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea("SRA")
	dbSetOrder(1)
	dbSeek(RA3->RA3_FILIAL+RA3->RA3_MAT)
	
	//здддддддддддддддддддддддддд©
	//Ё Situacao do Funcionario  Ё
	//юдддддддддддддддддддддддддды
	cSitFol := TrmSitFol( If(Empty(RA2->RA2_DATAIN),RA3->RA3_DATA,RA2->RA2_DATAIN))
	cCargo 	:= fGetCargo(SRA->RA_MAT,SRA->RA_FILIAL)
	
	If 	(SRA->RA_MAT  	< cMatDe)	.Or. (SRA->RA_MAT 	> cMatAte) .Or.;
		(SRA->RA_CC   	< cCcDe) 	.Or. (SRA->RA_CC  	> cCcAte)  .Or.;
		(SRA->RA_NOME 	< cNomDe) 	.Or. (SRA->RA_NOME > cNomAte) .Or.;
		(cCargo			< cCarDe) 	.Or. (cCargo		> cCarAte) .Or.;
		(!(cSitfol $ cSituacao) .And. (cSitFol <> "P")) .Or.;
		(cSitfol == "P" .And. nFerProg == 2)
		dbSelectArea("RA3")
		dbSkip()
		Loop
	EndIf			

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё            Buscar o Grupo e Departamento		 	   Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea( "SQ3" )
	dbSetOrder(1)
	cFil := xFilial("SQ3", SRA->RA_FILIAL)
	If dbSeek( cFil + cCargo + SRA->RA_CC ) .Or. dbSeek( cFil + cCargo ) 
		If 	SQ3->Q3_GRUPO < cGruDe .Or. SQ3->Q3_GRUPO > cGruAte .Or.;
			SQ3->Q3_DEPTO < cDepDe .Or. SQ3->Q3_DEPTO > cDepAte
			dbSelectArea("RA3")
			dbSkip()
			Loop
		EndIf 
	Else
		dbSelectArea("RA3")
		dbSkip()
		Loop			
	EndIf                  
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё                  Descricao do Curso                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea("RA1")
	dbSetOrder(1)
	cFil := xFilial("RA1", RA3->RA3_FILIAL)
	dbSeek(cFil+RA3->RA3_CURSO)

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё               Grava arquivo Temporario 		           Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea("TRA")
	RecLock("TRA",.T.)
	
		TRA->TR_FILIAL	:= RA3->RA3_FILIAL
		TRA->TR_MAT		:= RA3->RA3_MAT
		TRA->TR_CURSO	:= RA3->RA3_CURSO
		TRA->TR_RESERV	:= RA3->RA3_RESERV 
		TRA->TR_DATA	:= RA3->RA3_DATA
		TRA->TR_NOME	:= SRA->RA_NOME
		TRA->TR_CC		:= SRA->RA_CC
		TRA->TR_DESCUR	:= RA1->RA1_DESC
		TRA->TR_CARGO  	:= SQ3->Q3_CARGO
		TRA->TR_GRUPO	:= SQ3->Q3_GRUPO
		TRA->TR_DEPTO  	:= SQ3->Q3_DEPTO
		TRA->TR_CALEND 	:= RA3->RA3_CALEND
		TRA->TR_TURMA	:= RA3->RA3_TURMA
		
		dbSelectArea("RA2")
		dbSetOrder(1)                                                 
		cFil := xFilial("RA2", RA3->RA3_FILIAL)
		dbSeek(cFil+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)
		
		dbSelectArea("TRA")
		TRA->TR_DTINI	:= RA2->RA2_DATAIN
		TRA->TR_DTFIM	:= RA2->RA2_DATAFI
		
	MsUnlock()

    dbSelectArea("RA3")
	dbSkip()
EndDo

dbSelectArea("TRA")
dbGotop()

SetRegua(RecCount())
   
Do While ! Eof()
    cCurso := TRA->TR_CURSO 

	lFirst := .T.
    DETCURSO := STR0010 + PadR(TRA->TR_CURSO,4) + " - " + PadR(TRA->TR_DESCUR,30) //"CURSO: "
	
	Do While ! Eof() .And. cCurso == TRA->TR_CURSO    
	
	    IncRegua()
	    
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё            Verifica necessidade do Cargo 	           Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды 
		 
		dbSelectArea("RA5")
		dbSetOrder(2)
		cFil := xFilial("RA5", TRA->TR_FILIAL)
		
		if ! (lAchou := (dbSeek( cFil + TRA->TR_CARGO + TRA->TR_CC + TRA->TR_CURSO )))
			dbSetOrder(1)
			lAchou := (dbSeek( cFil + TRA->TR_CARGO + TRA->TR_CURSO ))
		endif			
		
		If nNecess == 1 	//Necessidade do Cargo

			If lAchou 
				If lFirst
					IMPR(DETCURSO,"C")
					IMPR("","C")
					lFirst := .F.
				EndIf
			
				lImpDet := .T.
				fImpDet()
        	EndIf
        
		Else  			//Solicitacao (S/ necessidade do cargo)     
			If !lAchou .Or. nNecess == 3
				If lFirst
					IMPR(DETCURSO,"C")
					IMPR("","C")
					lFirst := .F.
				EndIf

				lImpDet := .T.
				fImpDet()
			EndIf
		EndIf
	
		dbSelectArea("TRA")
		dbSkip()
	EndDo
	
	If lImpDet .And. ! Eof()
		IMPR("","P")
	EndIf
EndDo
    
If lImpDet
	IMPR("","F")
EndIf	

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Termino do Relatorio                                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("TRA")
dbCloseArea()
fErase(cArqNtx + OrdBagExt())
fErase(cArqDbf + GetDBExtension())

dbSelectArea("RA3")
dbSetOrder(1)

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return Nil

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  Ё fImpDet  Ё Autor Ё Equipe R.H.		    Ё Data Ё 19/03/99 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Imprime Detalhe											  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё fImpDet()                                                  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё Generico                                                   Ё╠╠
╠╠цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Static Function fImpDet()

If TRA->TR_RESERV == "R"
	cReserva := STR0012 //"RESERVADO"
ElseIf TRA->TR_RESERV == "L"
	cReserva := STR0013 //"LISTA ESPERA"
ElseIf TRA->TR_RESERV == "S"
	cReserva := STR0014 //"SOLICITACAO"
Else
	cReserva := ""
EndIf

DET := TRA->TR_FILIAL + "   " + TRA->TR_MAT + " " + TRA->TR_NOME + " "
DET += PadR(TrmDesc("SQ0",TRA->TR_GRUPO,"SQ0->Q0_DESCRIC"),15)+ " "
DET += PadR(TrmDesc("SQB",TRA->TR_DEPTO,"SQB->QB_DESCRIC"),20) + " "
DET += PadR(TrmDesc("SQ3",TRA->TR_CARGO,"SQ3->Q3_DESCSUM"),28) + " "
DET += PadR(cReserva,12)+ " "
DET += If(__SetCentury(),Dtoc(TRA->TR_DATA),Dtoc(TRA->TR_DATA)+Space(2)) + " "
DET += TRA->TR_CALEND +"-"+PadR(TrmDesc("RA2",TRA->TR_CALEND,"RA2->RA2_DESC"),20) + " "
DET += If(__SetCentury(),Dtoc(TRA->TR_DTINI),Dtoc(TRA->TR_DTINI)+Space(2)) + " - "
DET += If(__SetCentury(),Dtoc(TRA->TR_DTFIM),Dtoc(TRA->TR_DTFIM)+Space(2)) + " "
DET += TRA->TR_TURMA + Space(3)
DET += TRA->TR_CC +" - "+PadR(TrmDesc("SI3",TRA->TR_CC,"SI3->I3_DESC"),20)

IMPR(DET,"C")

Return Nil   


/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  ЁAjustR3SX1Ё Autor Ё Mauricio MR.		    Ё Data Ё 26/04/10 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Ajusta SX1 para versao tradicional (R3)					  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё AjustR3SX1()                                               Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё TRMR020	                                                  Ё╠╠
╠╠цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
Static Function AjustR3SX1(cPerg)
Local aRegs		:= {}       
Local nTamDepto := TamSx3("QB_DEPTO")[1]
	/*
	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё           Grupo  Ordem Pergunta Portugues         Pergunta Espanhol           Pergunta Ingles            Variavel Tipo 	Tamanho 		Decimal Presel 	GSC  	 Valid 			Var01   Def01 DefSPA1 DefEng1 Cnt01  	Var02  Def02 DefSpa2 DefEng2  Cnt02 Var03 	Def03 	DefSpa3 DefEng3 Cnt03 	Var04 	Def04 	DefSpa4 DefEng4 Cnt04 	Var05 	Def05 	DefSpa5 DefEng5 Cnt05 	XF3      	GrgSxg cPyme 	aHelpPor 	aHelpEng  	aHelpSpa cHelp    Ё
	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	Aadd(aRegs,{cPerg,"13","Departamento De  ?"			,"©De Sector ?"				 ,"From Department ?"		,"mv_chd","C"	,nTamDepto		,0		,0		,"G"	,""			,"mv_par13",""	,""		,""		,""			,""		,""	,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"SQB"		,"025"	,"S"	,Nil		,Nil		,Nil	,".RHDPTDE."          })
	Aadd(aRegs,{cPerg,"14","Departamento Ate  ?"		,"©A Sector ?"				 ,"To Department ?"			,"mv_che","C"	,nTamDepto		,0		,0		,"G"	,"NaoVazio","mv_par14",""	,""		,""		,"ZZZZZZZZZ",""		,""	,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,""		,"SQB"		,"025"	,"S"	,Nil		,Nil		,Nil	,".RHDPTAT."          })
	ValidPerg(aRegs,cPerg,.T.)

Return Nil


