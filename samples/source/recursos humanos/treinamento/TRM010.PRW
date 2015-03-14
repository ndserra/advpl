#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"  
#INCLUDE "TRM010.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o       ³ TRM010   ³ Autor ³ Eduardo Ju              ³ Data ³ 19.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o    ³ Lista de Presenca                       		               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso          ³ TRM010                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data     ³ BOPS ³  Motivo da Alteracao 					   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Eduardo Ju / ³13/09/2006³099036³Transformacao em relatorio personalizavel   ³±±
±±³Tania        ³          ³      ³para o release 4.                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programador  ³ Data     ³ FNC            ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³Rogerio R.   ³29/07/2009³00000018271/2009³Compatibilizacao dos fontes para aumento do³±±
±±³             ³          ³                ³campo filial e gestão corporativa.         ³±±
±±³Allyson M.   ³08/10/2009³00000023953/2009³Ajuste na query do relatorio R4 p/ imprimir³±±
±±³             ³          ³                ³funcionarios de outras filiais.            ³±±
±±³Luciana      ³06/08/2010³00000017893/2010³Ajuste na chamada da funcao fGetCargo para ³±±
±±³             ³          ³                ³considerar a filial do funcionario e nao a ³±±
±±³             ³          ³                ³filial que esta logado para a geracao do   ³±±
±±³             ³          ³                ³relatorio evitando que o cargo saia em     |±± 
±±³             ³          ³                ³branco.                                    ³±±  
±±³Luciana S.   ³10/08/2011³00000016958/2011³Ajuste na exibicao dos titulos do relatorio³±±
±±³Fabio G.     ³10/09/2013³				³Ajuste na funcao AjustaSx1 para carregar   ³±±
±±³             ³          ³                ³inf. corretas no parametro Relatorio Pers. ³±±
±±³             ³          ³                ³e Ajuste p/ que o relatorio Nao Personali- ³±±
±±³             ³          ³                ³zado nao mostre dados de Cargo fora de Ali-³±±
±±³             ³          ³                ³nhamento e apresentar informacoes corretas.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TRM010()

Local oReport
Local aArea := GetArea()

If FindFunction("TRepInUse") .And. TRepInUse()	//Verifica se relatorio personalizal esta disponivel
	AjustaSx1()

	Pergunte("TRR030",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	
Else
	U_TRM010R3()	
EndIf  

RestArea( aArea )

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 16.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Definicao do Componente de Impressao do Relatorio           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2 
Local aOrdem    := {}
Local cAliasQry := GetNextAlias()
//Private cCargo

oReport := TReport():New("TRM010",OemToAnsi(STR0001),"TRR030",{|oReport| PrintReport(oReport,cAliasQry)},OemToAnsi(STR0046)+" - "+OemToAnsi(STR0002)+" "+OemToAnsi(STR0003))
	//"Lista de Presença"###"Emite Lista de Presenca para os Treinamentos."###"Será impresso de acordo com os parametros solicitados pelo usuario"
oReport:SetLandscape()	//Imprimir Somente Paisagem
oReport:SetTotalInLine(.F.) 
Pergunte("TRR030",.F.)

Aadd( aOrdem, STR0004)	// "Nome"
Aadd( aOrdem, STR0005)	// "Matricula"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Primeira Secao: Cabecalho				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
oSection1 := TRSection():New(oReport,OemToAnsi(STR0034),{"RA3","RA2","RA1","RA7","RA9"},aOrdem) 	//"Curso"
oSection1:SetTotalInLine(.F.)  
oSection1:SetHeaderBreak(.T.)
oSection1:SetPageBreak(.T.)

TRCell():New(oSection1,"RA3_CALEND","RA3",STR0033,,25,.T.)	//Codigo do Calendario 
TRCell():New(oSection1,"RA2_DESC","RA2","")	   			//Descricado do Calendario
TRCell():New(oSection1,"RA3_CURSO","RA3",STR0034,,20,.T.)	//Codigo do Curso
TRCell():New(oSection1,"RA1_DESC","RA1","")	   			//Descricao do Curso 
TRCell():New(oSection1,"RA2_SINON","RA2",STR0037,,20,.T.)	//Sinonimo do Curso
TRCell():New(oSection1,"RA9_DESCR","RA9","")  	  			//Descricao do Sinonimo do Curso  
TRCell():New(oSection1,"RA3_TURMA","RA3",STR0035,,20,.T.)	//Turma
TRCell():New(oSection1,"RA2_INSTRU","RA2",STR0036,,20,.T.)	//Codigo do Instrutor
TRCell():New(oSection1,"RA7_NOME","RA7","") 	  			//Nome do Instrutor
TRCell():New(oSection1,"RA2_DATAIN","RA2",STR0038)			//Periodo: Data Inicio do Curso
TRCell():New(oSection1,"RA2_DATAFI","RA2","") 	   			//Periodo: Data Final do Curso 
TRCell():New(oSection1,"RA2_HORARI","RA2",STR0040)			//Horario
TRCell():New(oSection1,"RA2_LOCAL","RA2",STR0041) 			//Local

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Segunda Secao: Impressao dos Funcionarios ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,OemToAnsi(STR0047),{"RA3","SRA","SQ3","SQ0","SQB"})	//"Relacao dos Participantes"
oSection2:SetTotalInLine(.F.)  
oSection2:SetHeaderBreak(.T.)
oSection2:SetLeftMargin(2)	//Identacao da Secao

TRCell():New(oSection2,"RA_FILIAL","SRA",STR0043)	//Filial
TRCell():New(oSection2,"RA3_MAT","RA3",STR0044)	//Matricula do Funcionario 
TRCell():New(oSection2,"RA_NOME","SRA")				//Nome do Funcionario
TRCell():New(oSection2,"VISTO"," " ,STR0042,/*Picture*/,10          ,/*lPixel*/, {|| '__________' } )	//"Visto"
TRCell():New(oSection2,"RA3_RESERV","RA3",STR0030,)	//Status da Reserva (Reservado) 
TRCell():New(oSection2,"Q3_GRUPO","SQ3")			//Codigo do Grupo 
TRCell():New(oSection2,"Q0_DESCRIC","SQ0","")		//Descricao do Grupo 
TRCell():New(oSection2,"Q3_DEPTO","SQ3",STR0031)	//Codigo do Depto
TRCell():New(oSection2,"QB_DESCRIC","SQB","")		//Descricao do Depto 
TRCell():New(oSection2,"Q3_CARGO","SQ3",STR0032)	//Cargo:= fGetCargo(SRA->RA_MAT)
TRCell():New(oSection2,"Q3_DESCSUM","SQ3","")		//Descricao do Cargo  

TRFunction():New(oSection2:Cell("RA3_MAT"),/*cId*/,"COUNT",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
oSection2:SetTotalText(OemToAnsi(STR0045))

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 19.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Relatorio (Lista de Presenca)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrintReport(oReport,cAliasQry)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local cFil 		:= ""
Local cInicio 	:= ""
Local cFim    	:= ""
Local cCalend	:= ""
Local cCurso	:= ""                                           
Local cTurma	:= ""
Local cGrupo 	:= ""
Local cDepto	:= ""
Local cCC		:= ""
Local nOrdem  	:= osection1:GetOrder()
Local nImprVias	:= 0

#IFNDEF TOP
	Local cAcessaRA3:= &("{ || " + ChkRH("TRM010","RA3","2") + "}")
	Local cFiltro	:= ""
	Local aFields 	:= {}
	Local cArqDBF	:= ""
#ELSE
	Local lQuery    := .F. 
	Local cExpressao:= ""
	Local cFilSRA 	:= ""
	Local i			:= 0
	Local cSitQuery := ""
	Local cOrder	:= ""
#ENDIF

//+--------------------------------------------------------------+
//¦ Carregando variaveis MV_PAR?? para Variaveis do Sistema.     ¦
//+--------------------------------------------------------------+
Local cFilDe 	:= If(!Empty(MV_PAR01),MV_PAR01, Space(FWGETTAMFILIAL))
Local cFilAte	:= If(!Empty(MV_PAR02),MV_PAR02, Replicate("Z", FWGETTAMFILIAL))
Local cMatDe 	:= If(!Empty(MV_PAR03),MV_PAR03, Space(GetSx3Cache("RA_MAT", "X3_TAMANHO" )) )
Local cMatAte	:= If(!Empty(MV_PAR04),MV_PAR04, Replicate("9", GetSx3Cache("RA_MAT","X3_TAMANHO" )) )
Local cNomDe 	:= If(!Empty(MV_PAR05),MV_PAR05, Space(GetSx3Cache("RA_NOME", "X3_TAMANHO" )))
Local cNomAte	:= If(!Empty(MV_PAR06),MV_PAR06, Replicate("Z", GetSx3Cache("RA_NOME","X3_TAMANHO" )) ) 
Local cCalDe 	:= If(!Empty(MV_PAR07),MV_PAR07, Space(GetSx3Cache("RA3_CALEND", "X3_TAMANHO" )) )
Local cCalAte	:= If(!Empty(MV_PAR08),MV_PAR08, Replicate("9", GetSx3Cache("RA3_CALEND","X3_TAMANHO" )) ) 
Local cCurDe 	:= If(!Empty(MV_PAR09),MV_PAR09, Space(GetSx3Cache("RA3_CURSO", "X3_TAMANHO" )) )
Local cCurAte	:= If(!Empty(MV_PAR10),MV_PAR10, Replicate("9", GetSx3Cache("RA3_CURSO", "X3_TAMANHO" )) )
Local cTurDe 	:= If(!Empty(MV_PAR11),MV_PAR11, Space(GetSx3Cache("RA3_TURMA", "X3_TAMANHO" )) )
Local cTurAte	:= If(!Empty(MV_PAR12),MV_PAR12, Replicate("9", GetSx3Cache("RA3_TURMA", "X3_TAMANHO" )) )
Local cGruDe 	:= If(!Empty(MV_PAR13),MV_PAR13, Space(GetSx3Cache("Q3_GRUPO", "X3_TAMANHO" )) )
Local cGruAte	:= If(!Empty(MV_PAR14),MV_PAR14, Replicate("9", GetSx3Cache("Q3_GRUPO", "X3_TAMANHO" )) )
Local cDepDe 	:= If(!Empty(MV_PAR15),MV_PAR15, Space(GetSx3Cache("Q3_DEPTO", "X3_TAMANHO" )) )
Local cDepAte	:= If(!Empty(MV_PAR16),MV_PAR16, Replicate("9", GetSx3Cache("Q3_DEPTO", "X3_TAMANHO" )) )
Local cCarDe 	:= If(!Empty(MV_PAR17),MV_PAR17, Space(GetSx3Cache("RA_CARGO", "X3_TAMANHO" )) )
Local cCarAte	:= If(!Empty(MV_PAR18),MV_PAR18, Replicate("9", GetSx3Cache("RA_CARGO", "X3_TAMANHO" )) )
Local cSitCur	:= If(!Empty(MV_PAR19),MV_PAR19, "LRS")
Local nVias  	:= If(!Empty(MV_PAR20),MV_PAR20, 1)
Local nFerProg 	:= MV_PAR22
Local cSitFol  	:= "" 

Private cSituacao	:= MV_PAR21

#IFNDEF TOP
	//+--------------------------------------------------------------+
	//¦ Criando Arquivo Temporario pela ordem selecionada            ¦
	//+--------------------------------------------------------------+
	cArqDBF	:= CriaTrab(NIL,.f.)
	aFields := {}
	AADD(aFields,{"TR_FILIAL", "C", FWGETTAMFILIAL,          0                       } )
	AADD(aFields,{"TR_CC",     "C", TamSx3("RA_CC")[1],      TamSx3("RA_CC")[2]      } )
	AADD(aFields,{"TR_MAT",    "C", TamSx3("RA_MAT")[1],     TamSx3("RA_MAT")[2]     } )
	AADD(aFields,{"TR_NOME",   "C", TamSx3("RA_NOME")[1],    TamSx3("RA_NOME")[2]    } )
	AADD(aFields,{"TR_CALEND", "C", TamSx3("RA3_CALEND")[1], TamSx3("RA3_CALEND")[2] } )
	AADD(aFields,{"TR_CURSO",  "C", TamSx3("RA3_CURSO")[1],  TamSx3("RA3_CURSO")[2]  } )
	AADD(aFields,{"TR_TURMA",  "C", TamSx3("RA3_TURMA")[1],  TamSx3("RA3_TURMA")[2]  } )
	AADD(aFields,{"TR_SITCUR", "C", TamSx3("RA3_RESERV")[1], TamSx3("RA3_RESERV")[2] } )
	AADD(aFields,{"TR_GRUPO",  "C", TamSx3("Q3_GRUPO")[1],   TamSx3("Q3_GRUPO")[2]   } )
	AADD(aFields,{"TR_NOMEG",  "C", TamSx3("Q0_DESCRIC")[1], TamSx3("Q0_DESCRIC")[2] } )
	AADD(aFields,{"TR_DEPTO",  "C", TamSx3("Q3_DEPTO")[1],   TamSx3("Q3_DEPTO")[2]   } )
	AADD(aFields,{"TR_NOMED",  "C", TamSx3("QB_DESCRIC")[1], TamSx3("QB_DESCRIC")[2] } )
	AADD(aFields,{"TR_CARGO",  "C", TamSx3("Q3_CARGO")[1],   TamSx3("Q3_CARGO")[2]   } )
	AADD(aFields,{"TR_NOMEC",  "C", TamSx3("Q3_DESCSUM")[1], TamSx3("Q3_DESCSUM")[2] } )
	
	DbCreate(cArqDbf,aFields)
	DbUseArea(.T.,,cArqDbf,"TRA",.F.)
	
	If nOrdem == 1
		cIndCond := "TR_CALEND + TR_CURSO + TR_TURMA + TR_FILIAL + TR_NOME + TR_MAT"
	ElseIf nOrdem == 2
		cIndCond := "TR_CALEND + TR_CURSO + TR_TURMA + TR_FILIAL + TR_MAT"
	EndIf
	
	cArqNtx  := CriaTrab(NIL,.f.)
	IndRegua("TRA",cArqNtx,cIndCond,,,STR0012) //"Selecionando Registros..."
	dbGoTop()
	
	dbSelectArea("RA3")
	dbSetOrder(2)
	dbGoTop()
	
	cFil 	:= xFilial("RA3", cFilDe)
	cInicio := "RA3->RA3_FILIAL + RA3->RA3_CALEND"
	cFim    := cFilAte + cCalAte
	dbSeek( cFilDe + cCalDe ,.T.)
	
	While !Eof() .And. &cInicio <= cFim
		
		oReport:IncMeter()
		
		If oReport:Cancel()
			Exit
		EndIf
		
		If !Eval(cAcessaRA3)
			dbSkip()  
			Loop
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Intervalo de Impressao                          	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If 	(RA3->RA3_FILIAL 	< cFilDe) .Or. (RA3->RA3_FILIAL 	> cFilAte) .Or.;
			(RA3->RA3_MAT 		< cMatDe) .Or. (RA3->RA3_MAT 		> cMatAte) .Or.;
			(RA3->RA3_TURMA		< cTurDe) .Or. (RA3->RA3_TURMA		> cTurAte) .Or.;
			(RA3->RA3_CALEND 	< cCalDe) .Or. (RA3->RA3_CALEND 	> cCalAte) .Or.;
			(RA3->RA3_CURSO  	< cCurDe) .Or. (RA3->RA3_CURSO 	> cCurAte) .Or.;
		   	!(RA3->RA3_RESERV $ cSitCur)
			dbSkip()
			Loop
		EndIf 
				
		cGrupo 	:= ""
		cDepto	:= ""
		cCargo	:= ""
		cCC		:= ""
		
		dbSelectArea("RA2")
		dbSeek(xFilial("RA2")+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)	
		
		dbSelectArea( "SRA" )
		dbSetOrder(1)	
		
		If dbSeek( RA3->RA3_FILIAL + RA3->RA3_MAT )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Situacao do Funcionario  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSitFol := TrmSitFol()
			
			If (!(cSitfol $ cSituacao) .And. (cSitFol <> "P")) .Or.;
				(cSitfol == "P"	 .And. nFerProg == 2) .Or.; 
				(SRA->RA_NOME < cNomDe) .Or. (SRA->RA_NOME > cNomAte) 
				dbSelectArea("RA3")
				RA3->(dbSkip())
				Loop
			EndIf                      
			
			cCargo  := fGetCargo(SRA->RA_MAT, SRA->RA_FILIAL)
			cCC		:= SRA->RA_CC
				
			dbSelectArea("SQ3")
			dbSetOrder(1)
			cFil := xFilial("SQ3" ,SRA->RA_FILIAL)
			
			If dbSeek( cFil + cCargo + cCC ) .Or. dbSeek( cFil + cCargo )
				cGrupo:= SQ3->Q3_GRUPO            
				cDepto:= SQ3->Q3_DEPTO            
	
				If 	(cGrupo < cGruDe) .Or. (cGrupo > cGruAte) .Or.;
					(cDepto < cDepDe) .Or. (cDepto > cDepAte) .Or.;
					(cCargo < cCarDe) .Or. (cCargo > cCarAte)
						
					dbSelectArea("RA3")
					RA3->(dbSkip())
					Loop					
				EndIf
			EndIf
			Reclock("TRA",.T.)
			TRA->TR_CALEND  := RA3->RA3_CALEND
			TRA->TR_CURSO   := RA3->RA3_CURSO
			TRA->TR_TURMA   := RA3->RA3_TURMA
			TRA->TR_FILIAL  := SRA->RA_FILIAL
			TRA->TR_CC      := SRA->RA_CC
			TRA->TR_MAT     := SRA->RA_MAT
			TRA->TR_NOME    := SRA->RA_NOME
			TRA->TR_SITCUR  := RA3->RA3_RESERV
			TRA->TR_GRUPO   := cGrupo 
			TRA->TR_NOMEG   := IIf(!Empty(cGrupo), TrmDesc("SQ0", cGrupo, "SQ0->Q0_DESCRIC"), Space(GetSx3Cache("Q0_DESCRIC", "X3_TAMANHO")) )
			TRA->TR_DEPTO   := cDepto 
			TRA->TR_NOMED   := IIf(!Empty(cDepto), TrmDesc("SQB", cDepto, "SQB->QB_DESCRIC"), Space(GetSx3Cache("QB_DESCRIC", "X3_TAMANHO")) )
			TRA->TR_CARGO   := cCargo 
			TRA->TR_NOMEC   := IIf(!Empty(cCargo), TrmDesc("SQ3", cCargo, "SQ3->Q3_DESCSUM"), Space(GetSx3Cache("Q3_DESCSUM", "X3_TAMANHO")) )
			MsUnlock()	
		EndIf
		
		
		
		dbSelectArea("RA3")
		dbSkip()
	EndDo	
			
	dbSelectArea("TRA")
	dbGotop()
	
	TRPosition():New(oSection1,"RA3",2,{|| xFilial("RA3") + TRA->TR_CALEND+TRA->TR_MAT})
	TRPosition():New(oSection1,"RA2",1,{|| xFilial("RA2") + TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA})  //VER SE USO .T. 
	TRPosition():New(oSection1,"RA1",1,{|| xFilial("RA1") + TRA->TR_CURSO})
	TRPosition():New(oSection1,"RA7",1,{|| xFilial("RA7") + RA2->RA2_INSTRU})	//ATENCAO
	TRPosition():New(oSection1,"RA9",2,{|| xFilial("RA9") + TRA->TR_CURSO})	//VER SE POSICIONO NO RA2
	
	TRPosition():New(oSection2,"RA3",2,{|| xFilial("RA3") + TRA->TR_CALEND+TRA->TR_MAT})
	TRPosition():New(oSection2,"SRA",1,{|| xFilial("SRA") + TRA->TR_MAT})
	TRPosition():New(oSection2,"SQ3",2,{|| xFilial("SQ3") + TRA->TR_GRUPO + TRA->TR_DEPTO + TRA->TR_CARGO})
	TRPosition():New(oSection2,"SQ0",1,{|| xFilial("SQ0") + TRA->TR_GRUPO})
	TRPosition():New(oSection2,"SQB",1,{|| xFilial("SQB") + TRA->TR_DEPTO})
	  
	For nImprVias := 1 To nVias	
		Do While ! Eof()
		    	
			oReport:IncMeter()
				
			If oReport:Cancel()
				Exit
			EndIf
		   	
			cCalend	:= TRA->TR_CALEND
		    cCurso	:= TRA->TR_CURSO
	    	cTurma	:= TRA->TR_TURMA
		    cFil1	:= TRA->TR_FILIAL
	         	
		    oSection1:Init()
			oSection1:PrintLine()	
			oSection2:Init()
	        	
			Do While ! Eof() .And.	cCalend + cCurso + cTurma + cFil1  == TRA->TR_CALEND + TRA->TR_CURSO + TRA->TR_TURMA + TRA->TR_FILIAL		
				oReport:SkipLine()
				oSection2:PrintLine()	
				DbSelectArea("TRA")
				DbSkip()	
			EndDo
			oSection2:Finish()
			oSection1:Finish()
		EndDo	
	Next nImprVias
	
	TRA->(dbCloseArea())
	fErase(cArqNtx + OrdBagExt())
	fErase(cArqDbf + GetDBExtension())

#ELSE	
	//-- Filtragem do relatório
	//-- Query do relatório da secao 1
	lQuery := .T.  
	
	If nOrdem == 1 	// Nome	
		cOrder := "%RA3_CALEND,RA3_CURSO,RA3_TURMA,RA3_FILIAL,RA_NOME,RA3_MAT%"
	Else			// Matricula
		cOrder := "%RA3_CALEND,RA3_CURSO,RA3_TURMA,RA3_FILIAL,RA3_MAT%"
	EndIf        
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Treinamento Aberto-Baixado-Ambos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	          
	
	For i :=1 to Len(cSitCur)
   	cSitQuery += "'"+Subs(cSitCur,i,1)+"'"
   	If ( i+1 ) <= Len(cSitCur)
    	cSitQuery += "," 
   	Endif
	Next i     

	oReport:Section(1):BeginQuery()	

	cFilSRA := "% AND SRA.RA_FILIAL  = " + IIf( Empty(xFilial("SRA")), "'" + Space(FWGETTAMFILIAL) + "'", "RA3.RA3_FILIAL") + "%"

	cExpressao := " (RA3_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"') "
	cExpressao += "AND (RA3_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"') " 
	cExpressao += "AND (RA_NOME BETWEEN '"+cNomDe+"' AND '"+cNomAte+"') " 
	cExpressao += "AND (RA3_CALEND BETWEEN '"+cCalDe+"' AND '"+cCalAte+"') "
	cExpressao += "AND (RA3_CURSO BETWEEN '"+cCurDe+"' AND '"+cCurAte+"') "
	cExpressao += "AND (RA3_TURMA BETWEEN '"+cTurDe+"' AND '"+cTurAte+"') "
	cExpressao += "AND (Q3_GRUPO BETWEEN '"+cGruDe+"' AND '"+cGruAte+"') "
	cExpressao += "AND (Q3_DEPTO BETWEEN '"+cDepDe+"' AND '"+cDepAte+"') "
	cExpressao += "AND (Q3_CARGO BETWEEN '"+cCarDe+"' AND '"+cCarAte+"') "
 	cExpressao += "AND (RA3_RESERV IN ("+Upper(cSitQuery)+")) "	
  	cExpressao := "% "+cExpressao+" %"	

	BeginSql Alias cAliasQry
	
		SELECT DISTINCT	RA3_FILIAL,RA3_CURSO,RA1_DESC,RA3_MAT,RA3_DATA,RA_NOME,Q3_GRUPO,Q0_DESCRIC,Q3_DEPTO,
				QB_DESCRIC,Q3_CARGO,Q3_DESCSUM,RA3_RESERV,RA3_CALEND,RA2_DESC,RA9_DESCR,RA7_NOME,
				RA2_DATAIN,RA2_DATAFI,RA3_TURMA,RA2_SINON,RA2_INSTRU,RA2_LOCAL,RA2_HORARI
				
		FROM 	%table:RA3% RA3		  

		INNER JOIN %table:RA1% RA1
			ON RA1_FILIAL = %xFilial:RA1%
			AND RA1_CURSO = RA3_CURSO
			AND RA1.%NotDel%
		LEFT JOIN %table:RA2% RA2
			ON RA2_FILIAL = %xFilial:RA2%
			AND RA2_CALEND = RA3_CALEND
			AND RA2_CURSO = RA3_CURSO
			AND RA2_TURMA = RA3_TURMA
			AND RA2.%NotDel% 
		INNER JOIN %table:SRA% SRA
			ON RA_MAT = RA3_MAT
			AND SRA.%NotDel%
			%exp:cFilSRA%			
		INNER JOIN %table:SRJ% SRJ
			ON RJ_FILIAL = %xFilial:SRJ%
			AND RJ_FUNCAO = RA_CODFUNC
			AND SRJ.%NotDel%
		INNER JOIN %table:SQ3% SQ3
			ON Q3_FILIAL = %xFilial:SQ3%
			AND Q3_CARGO = RA_CARGO
			AND SQ3.%NotDel%			 								
		INNER JOIN %table:SQ0% SQ0
			ON Q0_FILIAL = %xFilial:SQ0%
			AND Q0_GRUPO = Q3_GRUPO
			AND SQ0.%NotDel%
		LEFT JOIN %table:SQB% SQB
			ON QB_FILIAL = %xFilial:SQB%
			AND QB_DEPTO = Q3_DEPTO
			AND SQB.%NotDel%
		LEFT JOIN %table:RA9% RA9
			ON RA9_FILIAL = %xFilial:RA9%
			AND RA9_SINONI   = RA2_SINON
			AND RA9.%NotDel%
		LEFT JOIN %table:RA7% RA7
			ON RA7_FILIAL = %xFilial:RA7%
			AND RA7_INSTRU = RA2_INSTRU
			AND RA7.%NotDel%   			
		WHERE %exp:cExpressao%
			AND	RA3.%NotDel%  

	   	UNION 

		SELECT DISTINCT RA3_FILIAL,RA3_CURSO,RA1_DESC,RA3_MAT,RA3_DATA,RA_NOME,Q3_GRUPO,Q0_DESCRIC,Q3_DEPTO,
				QB_DESCRIC,Q3_CARGO,Q3_DESCSUM,RA3_RESERV,RA3_CALEND,RA2_DESC,RA9_DESCR,RA7_NOME,
				RA2_DATAIN,RA2_DATAFI,RA3_TURMA,RA2_SINON,RA2_INSTRU,RA2_LOCAL,RA2_HORARI

		FROM 	%table:RA3% RA3		 
		 
		INNER JOIN %table:RA1% RA1
			ON RA1_FILIAL = %xFilial:RA1%
			AND RA1_CURSO = RA3_CURSO
			AND RA1.%NotDel% 
		LEFT JOIN %table:RA2% RA2
			ON RA2_FILIAL = %xFilial:RA2%
			AND RA2_CALEND = RA3_CALEND
			AND RA2_CURSO = RA3_CURSO
			AND RA2_TURMA = RA3_TURMA
			AND RA2.%NotDel% 
		INNER JOIN %table:SRA% SRA
			ON RA_MAT = RA3_MAT
			AND SRA.%NotDel%  
			%exp:cFilSRA%						
		INNER JOIN %table:SRJ% SRJ
			ON RJ_FILIAL = %xFilial:SRJ%
			AND RJ_FUNCAO = RA_CODFUNC
			AND SRJ.%NotDel%
		INNER JOIN %table:SQ3% SQ3
			ON Q3_FILIAL = %xFilial:SQ3%
			AND Q3_CARGO = RA_CARGO
			AND SQ3.%NotDel%			 								
		INNER JOIN %table:SQ0% SQ0
			ON Q0_FILIAL = %xFilial:SQ0%
			AND Q0_GRUPO = Q3_GRUPO
			AND SQ0.%NotDel%
		LEFT JOIN %table:SQB% SQB
			ON QB_FILIAL = %xFilial:SQB%
			AND QB_DEPTO = Q3_DEPTO
			AND SQB.%NotDel%					
		LEFT JOIN %table:RA9% RA9
			ON RA9_FILIAL = %xFilial:RA9%
			AND RA9_SINONI = RA2_SINON
			AND RA9.%NotDel%
		LEFT JOIN %table:RA7% RA7
			ON RA7_FILIAL = %xFilial:RA7%
			AND RA7_INSTRU = RA2_INSTRU
			AND RA7.%NotDel% 					 	
		WHERE RA_CARGO = '     ' 
			AND %exp:cExpressao%
			AND	RA3.%NotDel%
		  										
		ORDER BY %Exp:cOrder%                 		

	EndSql
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery()	//*Array com os parametros do tipo Range*
		
	//-- Inicio da impressao do fluxo do relatório
	oReport:SetMeter(RA3->(LastRec()))

	//-- Utiliza a query do Pai
	oSection2:SetParentQuery()
	oSection2:SetParentFilter( { |cParam| (cAliasQry)->RA3_CALEND + (cAliasQry)->RA3_CURSO + (cAliasQry)->RA3_TURMA  == cParam },{ || (cAliasQry)->RA3_CALEND + (cAliasQry)->RA3_CURSO + (cAliasQry)->RA3_TURMA})	
	
	//Valida Situacao do Funcionario 
	oSection2:SetLineCondition({|| fChkSit(cAliasQry)})
	
	For nImprVias := 1 To nVias	
		oSection1:Print()	 //Imprimir	
	Next nImprVias	
#ENDIF

Return Nil	

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaSx1		 ³ Autor ³ Allyson Mesashi	³ Data ³08.10.2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajuste dos parametros 15 e 16 do pergunte TRR030     	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSx1()

Local aRegs	:= {}
Local cPerg := "TRR030"

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³                Grupo   Ordem    Perg.Port.              Perg.Esp.                Perg.Ingles                Variavel    Tipo   Tamanho Decimal Presel   GSC          Valid              Var01         Def01     DefSPA1    DefEng1    Cnt01    Var02     Def02      DefSpa2   DefEng2	   Cnt02    Var03    Def03   DefSpa3   DefEng3    Cnt03    Var04    Def04    DefSpa4    DefEng4     Cnt04 	    Var05     Def05     DefSpa5     DefEng5     Cnt05  	  XF3      GrgSxg     cPyme    aHelpPor   aHelpEng	 aHelpSpa    cHelp      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd( aRegs,{   cPerg ,  '15'  , "Departamento De?"	, "¨ De Sector ?"		, "From Department ?"		, "mv_chf" ,  "C" ,    9  ,     0   ,   0   , "G" ,         ""          ,   "mv_par15"  ,   " "	,   " "   ,    " "   ,   " "   ,  " "  ,   " "	,   " "   ,   " "   ,   " "   ,  " "  ,   " "   ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   ,    "SQB"    ,  "025"   ,   "S"   ,          ,           ,       ,  ".RHDPTDE."    } )
Aadd( aRegs,{   cPerg ,  '16'  , "Departamento Ate?"	, "¨ A Sector ?"		, "To Department ?"		    , "mv_chg" ,  "C" ,    9  ,     0   ,   0   , "G" ,      "NaoVazio"     ,   "mv_par16"  ,   " "	,   " "   ,    " "   ,   " "   ,  " "  ,   " "	,   " "   ,   " "   ,   " "   ,  " "  ,   " "   ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   ,    "SQB"    ,  "025"   ,   "S"   ,          ,           ,       ,  ".RHDPTAT."    } )

ValidPerg(aRegs,cPerg,.T.)

Return Nil 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³fChkSit     ³ Autor ³ Eduardo Ju          ³ Data ³ 10.10.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Checa a Situacao do Funcionario                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fChkSit(cAliasQry)   

Local aSaveArea	:= GetArea()
Local lChkSit	:= .F.  

SRA->(dbSeek( (cAliasQry)->RA3_FILIAL+(cAliasQry)->RA3_MAT ))
lChkSit := TrmSitFol( If(Empty((cAliasQry)->RA2_DATAIN),(cAliasQry)->RA3_DATA,(cAliasQry)->RA2_DATAIN)) $ cSituacao
       
RestArea(aSaveArea)

Return(lChkSit)









//=====>>>>>>> Daqui para baixo trata-se do release 3 e anterior.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	³ BOPS ³  Motivo da Alteracao 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³		³	   ³ 										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TRM010R3()        

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("TITULO,AT_PRG,WCABEC0,WCABEC1,CONTFL,LI")
SetPrvt("NPAG,NTAMANHO,CTIT,WNREL,NORDEM,CFILDE")
SetPrvt("CFILATE,CMATDE,CMATATE,CNOMDE,CNOMEDE,CNOMATE")
SetPrvt("CNOMEATE,CCALDE,CCALATE,CCURDE,CCURATE,CTURDE")
SetPrvt("CTURATE,CGRUDE,CGRUATE,CDEPDE,CDEPATE,CCARDE")
SetPrvt("CCARATE,CSITCUR,NVIAS,CARQDBF,AFIELDS,CINDCOND")
SetPrvt("CARQNTX,CFIL,CINICIO,CFIM,NIMPRVIAS,DET")
SetPrvt("CRESERVA,CCALEND,CCURSO,CTURMA,CFIL1")
SetPrvt("CGRUPO,CDEPTO,CCARGO,CCC") 
SetPrvt("CACESSARA3")
SetPrvt("LFALTA")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TRM010   ³ Autor ³ Equipe RH		        ³ Data ³ 16/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Lista de Prsenca.										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRM010	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RdMake	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
cDesc1  := STR0001 //"Lista de Presença"
cDesc2  := STR0002 //"Será impresso de acordo com os parametros solicitados pelo"
cDesc3  := STR0003 //"usuário."
cString := "RA3"   //-- alias do arquivo principal (Base)
aOrd    := { STR0004,STR0005 } //"Nome"###"Matricula"

//+--------------------------------------------------------------+
//¦ Define Variaveis (Basicas)                                   ¦
//+--------------------------------------------------------------+
aReturn  := { STR0006,1,STR0007,2,2,1,"",1 } //"Zebrado"###"Administraçäo"
NomeProg := "TRM010"
aLinha   := {}
nLastKey := 0
cPerg    := "TRR030"
lEnd     := .F.
lImp	 := .F.

//+--------------------------------------------------------------+
//¦ Define Variaveis (Programa)                                  ¦
//+--------------------------------------------------------------+
Colunas  := 132
Titulo   := STR0011 //"LISTA DE PRESENCA"
AT_PRG   := "TRM010"
wCabec0  := 1
wCabec1  := ""
Contfl   := 1
Li       := 0
nPag     := 0
nTamanho := "M"

cTit     := STR0011 //"LISTA DE PRESENCA"

//+--------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                           ¦
//+--------------------------------------------------------------+
pergunte("TRR030",.F.)

//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ MV_PAR01        //  Filial  De                               ¦
//¦ MV_PAR02        //  Filial  Ate                              ¦
//¦ MV_PAR03        //  Matricula De                             ¦
//¦ MV_PAR04        //  Matricula Ate                            ¦
//¦ MV_PAR05        //  Nome De                                  ¦
//¦ MV_PAR06        //  Nome Ate                                 ¦
//¦ MV_PAR07        //  Calendario De                            ¦
//¦ MV_PAR08        //  Calendario Ate                           ¦
//¦ MV_PAR09        //  Curso De                                 ¦
//¦ MV_PAR10        //  Curso Ate                                ¦
//¦ MV_PAR11        //  Turma De                                 ¦
//¦ MV_PAR12        //  Turma Ate                                ¦
//¦ MV_PAR13        //  Grupo De                                 ¦
//¦ MV_PAR14        //  Grupo Ate                                ¦
//¦ MV_PAR15        //  Departamento De                          ¦
//¦ MV_PAR16        //  Departamento Ate                         ¦
//¦ MV_PAR17        //  Cargo De                                 ¦
//¦ MV_PAR18        //  Cargo Ate                                ¦
//¦ MV_PAR19        //  Situacao                                 ¦
//¦ MV_PAR20        //  Numeros de Vias                          ¦
//¦ MV_PAR21        //  Status Funcionario                       ¦
//¦ MV_PAR22        //  Ferias Programadas                       ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
WnRel :="TRM010"  //-- Nome Default do relatorio em Disco.
WnRel :=SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd)

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Relato   ³ Autor ³  Equipe RH        	³ Data ³ 19/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina Principal do Relatorio.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Relato()	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Rdmake	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Relato()
Local nImprVias	:= 0

nOrdem  	:= aReturn[8]
cAcessaRA3	:= &("{ || " + ChkRH("TRM010","RA3","2") + "}")

//+--------------------------------------------------------------+
//¦ Carregando variaveis MV_PAR?? para Variaveis do Sistema.     ¦
//+--------------------------------------------------------------+
cFilDe 	:= If(!Empty(MV_PAR01),MV_PAR01, Space(FWGETTAMFILIAL))
cFilAte	:= If(!Empty(MV_PAR02),MV_PAR02, Replicate("Z", FWGETTAMFILIAL))
cMatDe 	:= If(!Empty(MV_PAR03),MV_PAR03, Space(GetSx3Cache("RA_MAT", "X3_TAMANHO" )) )
cMatAte	:= If(!Empty(MV_PAR04),MV_PAR04, Replicate("9", GetSx3Cache("RA_MAT","X3_TAMANHO" )) )
cNomDe 	:= If(!Empty(MV_PAR05),MV_PAR05, Space(GetSx3Cache("RA_NOME", "X3_TAMANHO" )))
cNomAte	:= If(!Empty(MV_PAR06),MV_PAR06, Replicate("Z", GetSx3Cache("RA_NOME","X3_TAMANHO" )) ) 
cCalDe 	:= If(!Empty(MV_PAR07),MV_PAR07, Space(GetSx3Cache("RA3_CALEND", "X3_TAMANHO" )) )
cCalAte	:= If(!Empty(MV_PAR08),MV_PAR08, Replicate("9", GetSx3Cache("RA3_CALEND","X3_TAMANHO" )) ) 
cCurDe 	:= If(!Empty(MV_PAR09),MV_PAR09, Space(GetSx3Cache("RA3_CURSO", "X3_TAMANHO" )) )
cCurAte	:= If(!Empty(MV_PAR10),MV_PAR10, Replicate("9", GetSx3Cache("RA3_CURSO", "X3_TAMANHO" )) )
cTurDe 	:= If(!Empty(MV_PAR11),MV_PAR11, Space(GetSx3Cache("RA3_TURMA", "X3_TAMANHO" )) )
cTurAte	:= If(!Empty(MV_PAR12),MV_PAR12, Replicate("9", GetSx3Cache("RA3_TURMA", "X3_TAMANHO" )) )
cGruDe 	:= If(!Empty(MV_PAR13),MV_PAR13, Space(GetSx3Cache("Q3_GRUPO", "X3_TAMANHO" )) )
cGruAte	:= If(!Empty(MV_PAR14),MV_PAR14, Replicate("9", GetSx3Cache("Q3_GRUPO", "X3_TAMANHO" )) )
cDepDe 	:= If(!Empty(MV_PAR15),MV_PAR15, Space(GetSx3Cache("Q3_DEPTO", "X3_TAMANHO" )) )
cDepAte	:= If(!Empty(MV_PAR16),MV_PAR16, Replicate("9", GetSx3Cache("Q3_DEPTO", "X3_TAMANHO" )) )
cCarDe 	:= If(!Empty(MV_PAR17),MV_PAR17, Space(GetSx3Cache("RA_CARGO", "X3_TAMANHO" )) )
cCarAte	:= If(!Empty(MV_PAR18),MV_PAR18, Replicate("9", GetSx3Cache("RA_CARGO", "X3_TAMANHO" )) )
cSitCur := If(!Empty(MV_PAR19),MV_PAR19, "LRS")
nVias   := If(!Empty(MV_PAR20),MV_PAR20, 1)
cSituacao:= MV_PAR21
nFerProg := MV_PAR22
cSitFol  := ""

//+--------------------------------------------------------------+
//¦ Criando Arquivo Temporario pela ordem selecionada            ¦
//+--------------------------------------------------------------+
cArqDBF	:= CriaTrab(NIL,.f.)
aFields := {}
AADD(aFields,{"TR_FILIAL", "C", FWGETTAMFILIAL,          0                       } )
AADD(aFields,{"TR_CC",     "C", TamSx3("RA_CC")[1],      TamSx3("RA_CC")[2]      } )
AADD(aFields,{"TR_MAT",    "C", TamSx3("RA_MAT")[1],     TamSx3("RA_MAT")[2]     } )
AADD(aFields,{"TR_NOME",   "C", TamSx3("RA_NOME")[1],    TamSx3("RA_NOME")[2]    } )
AADD(aFields,{"TR_CALEND", "C", TamSx3("RA3_CALEND")[1], TamSx3("RA3_CALEND")[2] } )
AADD(aFields,{"TR_CURSO",  "C", TamSx3("RA3_CURSO")[1],  TamSx3("RA3_CURSO")[2]  } )
AADD(aFields,{"TR_TURMA",  "C", TamSx3("RA3_TURMA")[1],  TamSx3("RA3_TURMA")[2]  } )
AADD(aFields,{"TR_SITCUR", "C", TamSx3("RA3_RESERV")[1], TamSx3("RA3_RESERV")[2] } )
AADD(aFields,{"TR_GRUPO",  "C", TamSx3("Q3_GRUPO")[1],   TamSx3("Q3_GRUPO")[2]   } )
AADD(aFields,{"TR_NOMEG",  "C", TamSx3("Q0_DESCRIC")[1], TamSx3("Q0_DESCRIC")[2] } )
AADD(aFields,{"TR_DEPTO",  "C", TamSx3("Q3_DEPTO")[1],   TamSx3("Q3_DEPTO")[2]   } )
AADD(aFields,{"TR_NOMED",  "C", TamSx3("QB_DESCRIC")[1], TamSx3("QB_DESCRIC")[2] } )
AADD(aFields,{"TR_CARGO",  "C", TamSx3("Q3_CARGO")[1],   TamSx3("Q3_CARGO")[2]   } )
AADD(aFields,{"TR_NOMEC",  "C", TamSx3("Q3_DESCSUM")[1], TamSx3("Q3_DESCSUM")[2] } )

DbCreate(cArqDbf,aFields)
DbUseArea(.T.,,cArqDbf,"TRA",.F.)
If nOrdem == 1
	cIndCond := "TR_CALEND + TR_CURSO + TR_TURMA + TR_FILIAL + TR_NOME + TR_MAT"
ElseIf nOrdem == 2
	cIndCond := "TR_CALEND + TR_CURSO + TR_TURMA + TR_FILIAL + TR_MAT"
EndIf

cArqNtx  := CriaTrab(NIL,.f.)
IndRegua("TRA",cArqNtx,cIndCond,,,STR0012) //"Selecionando Registros..."
dbGoTop()

dbSelectArea( "RA3" )
dbSetOrder(2)
dbGoTop()

cFil 	:= xFilial("RA3", cFilDe)
cInicio := "RA3->RA3_FILIAL + RA3->RA3_CALEND"
cFim    := cFilAte + cCalAte
dbSeek(cFilDe + cCalDe, .T.)

SetRegua(RecCount())

While !Eof() .And. &cInicio <= cFim

	//+--------------------------------------------------------------+
	//¦ Incrementa Regua de Processamento.                           ¦
	//+--------------------------------------------------------------+
	IncRegua()

	If lEnd
		IMPR(STR0026,"C") //"CANCELADO PELO USUARIO"
		Exit
	Endif

	
	If !Eval(cAcessaRA3)
		dbSkip()  
		Loop
	EndIf

	//+--------------------------------------------------------------+
	//¦ Consiste Parametrizaç¦o do Intervalo de Impress¦o.           ¦
	//+--------------------------------------------------------------+
	If 	(RA3->RA3_FILIAL 	< cFilDe) .Or. (RA3->RA3_FILIAL 	> cFilAte) .Or.;
		(RA3->RA3_MAT 		< cMatDe) .Or. (RA3->RA3_MAT 		> cMatAte) .Or.;
		(RA3->RA3_TURMA		< cTurDe) .Or. (RA3->RA3_TURMA		> cTurAte) .Or.;
		(RA3->RA3_CALEND 	< cCalDe) .Or. (RA3->RA3_CALEND 	> cCalAte) .Or.;
		(RA3->RA3_CURSO  	< cCurDe) .Or. (RA3->RA3_CURSO 	> cCurAte) .Or.;
	   	!(RA3->RA3_RESERV $ cSitCur)

		dbSkip()
		Loop
	EndIf                          
		
	// Inicializa as variaveis do SQ3 - Cargos	
	cGrupo 	:= ""
	cDepto	:= ""
	cCargo	:= ""
	cCC		:= ""
		
	dbSelectArea("RA2")
	dbSeek(xFilial("RA2")+RA3->RA3_CALEND+RA3->RA3_CURSO+RA3->RA3_TURMA)	
	
	dbSelectArea( "SRA" )
	dbSetOrder(1)	
	
	If dbSeek( RA3->RA3_FILIAL + RA3->RA3_MAT ) 
		//Gera relatorio somente de pessoas que possuem Cargo Preenchidos
		If !Empty(SRA->RA_CARGO)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Situacao do Funcionario  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSitFol := TrmSitFol()
			
			If (!(cSitfol $ cSituacao) .And. (cSitFol <> "P")) .Or.;
				(cSitfol == "P"	 .And. nFerProg == 2) .Or.; 
				(SRA->RA_NOME < cNomDe) .Or. (SRA->RA_NOME > cNomAte) 
				dbSelectArea( "RA3" )
				dbSkip()
				Loop
			EndIf                      
			cCargo  := fGetCargo(SRA->RA_MAT,SRA->RA_FILIAL)
			cCC		:= SRA->RA_CC
				
			dbSelectArea( "SQ3" )
			dbSetOrder(1)
			cFil := xFilial("SQ3", SRA->RA_FILIAL)
			If dbSeek( cFil + cCargo + cCC ) .Or. dbSeek( cFil + cCargo )
				cGrupo:= SQ3->Q3_GRUPO            
				cDepto:= SQ3->Q3_DEPTO            
	
				If 	(cGrupo < cGruDe) .Or. (cGrupo > cGruAte) .Or.;
					(cDepto < cDepDe) .Or. (cDepto > cDepAte) .Or.;
					(cCargo < cCarDe) .Or. (cCargo > cCarAte)
						
					dbSelectArea( "RA3" )
					dbSkip()
					Loop					
				EndIf
			EndIf
			
			Reclock("TRA",.T.)
				TRA->TR_CALEND  := RA3->RA3_CALEND
				TRA->TR_CURSO   := RA3->RA3_CURSO
				TRA->TR_TURMA   := RA3->RA3_TURMA
				TRA->TR_FILIAL  := SRA->RA_FILIAL
				TRA->TR_CC      := SRA->RA_CC
				TRA->TR_MAT     := SRA->RA_MAT
				TRA->TR_NOME    := SRA->RA_NOME
				TRA->TR_SITCUR  := RA3->RA3_RESERV
				TRA->TR_GRUPO   := cGrupo 
				TRA->TR_NOMEG   := IIf(!Empty(cGrupo),TrmDesc("SQ0",cGrupo,"SQ0->Q0_DESCRIC"), Space(GetSx3Cache("Q0_DESCRIC", "X3_TAMANHO")) )
				TRA->TR_DEPTO   := cDepto 
				TRA->TR_NOMED   := IIf(!Empty(cDepto),TrmDesc("SQB",cDepto,"SQB->QB_DESCRIC"), Space(GetSx3Cache("QB_DESCRIC", "X3_TAMANHO")) )
				TRA->TR_CARGO   := cCargo 
				TRA->TR_NOMEC   := IIf(!Empty(cCargo),TrmDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"), Space(GetSx3Cache("Q3_DESCSUM", "X3_TAMANHO")) )
			MsUnlock()	
		EndIf
	EndIf
	
	dbSelectArea("RA3")
	dbSkip()
EndDo

For nImprVias := 1 To nVias

	dbSelectArea("TRA")
	dbGotop()

	SetRegua(RecCount())
   
	Do While ! Eof()
		cCalend	:= TRA->TR_CALEND
	    cCurso	:= TRA->TR_CURSO
	    cTurma	:= TRA->TR_TURMA
	    cFil1	:= TRA->TR_FILIAL
		Do While ! Eof() .And.	cCalend == TRA->TR_CALEND .And.;
								cCurso 	== TRA->TR_CURSO .And.;
								cTurma 	== TRA->TR_TURMA .And.;
								cFil1   == TRA->TR_FILIAL    
		
		    IncRegua()

			dbSelectArea("RA2")
			dbSetOrder(1)
			If ! dbSeek(xFilial("RA2")+TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA)

	            dbSelectArea("TRA")
	            dbSkip()
	            Loop
            EndIf
            
            dbSelectArea("TRA")
            //Imprime Cabecalho
			fImpCab()
			//Imprime Detalhe
			fImpDet()
        
			dbSelectArea("TRA")
			
		EndDo
	EndDo

Next nImprVias

//+--------------------------------------------------------------+
//¦ Termino do Relatorio                                         ¦
//+--------------------------------------------------------------+

dbSelectArea( "RA3" )
dbSetOrder(1)

If lImp
	IMPR("","F")
EndIf

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

TRA->(dbCloseArea())
fErase(cArqNtx + OrdBagExt())
fErase(cArqDbf + GetDBExtension())

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fImpCab  ³ Autor ³ Equipe RH		        ³ Data ³ 19/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Cabecalho.										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpCab()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpCab()

DET := STR0013 + PadR(TRA->TR_CALEND,4) + " - " + PadR(RA2->RA2_DESC,30) + Repl(" ",14) //"CALENDARIO: "
DET := DET + STR0014 + PadR(TRA->TR_CURSO,4) + " - " + PadR(TrmDesc("RA1",TRA->TR_CURSO,"RA1->RA1_DESC"),30) + Repl(" ",14) //"CURSO: "
DET := DET + STR0015 + PadR(TRA->TR_TURMA,3) //"TURMA: "
IMPR(DET,"C")

DET := STR0029 + RA2->RA2_SINON + " - " + TrmDesc("RA9",RA2->RA2_SINON,"RA9->RA9_DESCR")  //"SINONIMO DO CURSO: "
IMPR(DET,"C")

DET := STR0016 + DtoC(RA2->RA2_DATAIN) + STR0017 + DtoC(RA2->RA2_DATAFI) + Repl(" ",14) + STR0018 + PadR(RA2->RA2_HORARI,20) //"PERIODO: "###" A "###"HORARIO: "
DET := DET + Space(6) + STR0027 + RA2->RA2_LOCAL // "LOCAL: "
IMPR(DET,"C")
IMPR("","C")
//FIL. MATR.  MOME                                  VISTO          SIT.  GRUPO           DEPARTAMENTO         CARGO                   
//XX   XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX _____________________ XXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 

DET := STR0019 //"FIL. MATR.  MOME                                  VISTO          SIT.  GRUPO           DEPARTAMENTO         CARGO                   "
IMPR(DET,"C")
IMPR("","C")
IMPR("","C")
lImp := .T.
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fImpDet  ³ Autor ³ Equipe RH		        ³ Data ³ 19/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Detalhe											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpDet()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpDet()

Local cReserva := ""

dbSelectArea( "TRA" )
While !Eof() .And.	RA2->RA2_CALEND+RA2->RA2_CURSO+RA2->RA2_TURMA == ;
						TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA
	If LI >= 60
		fImpCab()
	EndIf
	DET := TRA->TR_FILIAL + "   " + TRA->TR_MAT + " " + TRA->TR_NOME + " "

	dbSelectArea("RA4")
	dbSetOrder(3)                                          
	lFalta := .F.
	dbSeek(xFilial("RA4")+TRA->TR_CALEND)
	While !Eof() .And. RA4->RA4_CALEND == TRA->TR_CALEND
	    If RA4->RA4_MAT == TRA->TR_MAT .And. RA4->RA4_PRESEN != 100
	    	lFalta := .T.
	    EndIf
		dbSkip()                                       
	EndDo                
	
	dbSelectArea( "TRA" )
	
	If ! lFalta
		DET := DET + Repl("_",16) + " "
	Else
//		DET := DET + STR0028 + " " // "       FALTOU        "
		DET := DET + Repl("_",15)+"*" + " "
	EndIf

	If TRA->TR_SITCUR == "R"
		cReserva := STR0020 //"RESERVADO"
	ElseIf TRA->TR_SITCUR == "L"
		cReserva := STR0021 //"LISTA ESPERA"
	ElseIf TRA->TR_SITCUR == "S"
		cReserva := STR0022 //"SOLICITACAO"
	Else
		cReserva := STR0023 //"CONCLUIDO"
	EndIf

	DET := DET + PadR(cReserva,5) + " "
	DET := DET + PadR(TRA->TR_NOMEG,15)+ " "
	DET := DET + PadR(TRA->TR_NOMED,20) + " "
	DET := DET + PadR(TRA->TR_NOMEC,30)
	
	IMPR(DET,"C")
	IMPR("","C")
	IMPR("","C")

	dbSelectArea( "TRA" )
	dbSkip()
EndDo

IMPR("","C")
DET := REPL("-",132)
IMPR(DET,"C")
IMPR("","C")
		
dbSelectArea("RA7")
dbSeek(xFilial()+RA2->RA2_INSTRU)
DET := STR0024 + PadR(RA7->RA7_NOME,30) + " - " + Repl("_",85) //"INSTRUTOR: "
IMPR(DET,"C")
IMPR("","F")
LI := 00

Return Nil
