#INCLUDE "Protheus.ch"
#INCLUDE "CSA010.CH"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ CSA010   ³ Autor ³ Eduardo Ju            ³ Data ³ 15.08.06   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Aprovacao de Vagas (Quadro de Funcionario)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CSA010(void)	 	 	 	 	 	 	 	 	        	    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 		ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.   		    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ BOPS ³  Motivo da Alteracao 		   	 	    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tania       ³26/09/2006³100714³Acertos para o Relatorio personalizavel,  ³±±
±±³            ³          ³      ³do Release 4. Help da pergunta 4 do SX1.  ³±±
±±³Alex        ³11/11/2009|026633³Ajuste Gestão Corporativa                 ³±±
±±³            ³          | /2009³Respeitar o Grupo de campos de Filiais.   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSA010()

Local oReport
Local aArea := GetArea()

If FindFunction("TRepInUse") .And. TRepInUse()	//Verifica se relatorio personalizavel esta disponivel
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CS10ARSX1()	//Criacao do Pergunte (SX1)
	Pergunte("CS10AR",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	              
Else
	U_CSA010R3()
EndIf  

RestArea( aArea )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 15.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Definicao do Componente de Impressao do Relatorio           ³±±
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
Local oBreakFuncao
Local oBreakPer
Local oBreakCC
Local cAliasQry := GetNextAlias()
Local aOrd	  := {STR0004}  	//"Centro de Custo"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:=TReport():New("CSA010",STR0008,"CS10AR",{|oReport| PrintReport(oReport,cAliasQry)},STR0026,,,.F.)	// "Este Programa Emite Relatorio de Aprovacao de Vagas"
Pergunte("CS10AR",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Primeira Secao: "Quadro Funcionario Por Função" ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection1 := TRSection():New(oReport,STR0014,{"RBE"},aOrd,/*Campos do SX3*/,/*Campos do SIX*/)	//"Aprovacao de Vagas"
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderBreak(.T.)   
TRCell():New(oSection1,"RBE_FILIAL","RBE")					//Filial 
TRCell():New(oSection1,"RBE_CC","RBE")						//Centro de Custo
TRCell():New(oSection1,"I3_DESC","SI3","")					//Descricao do Centro de Custo
TRCell():New(oSection1,"RBE_ANOMES","RBE")					//Ano/Mes

#IFNDEF TOP 
	TRPosition():New(oSection1,"SI3",1,{|| xFilial("SI3") + RBE->RBE_CC})
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Segunda Secao: Aumento Programado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,STR0014 +" / " + STR0015,{"RBE","RBD"},/*aOrdem*/,/*Campos do SX3*/,/*Campos do SIX*/)		//Aprovacao de Vagas / Quadro de Funcionario por Funcao
oSection2:SetTotalInLine(.F.)  
oSection2:SetHeaderBreak(.T.)
oSection2:SetLeftMargin(3)	//Identacao da Secao

TRCell():New(oSection2,"RBE_FUNCAO","RBE")				//Funcao
TRCell():New(oSection2,"RJ_DESC","SRJ","")				//Descricao da Funcao
TRCell():New(oSection2,"RBD_VLATUA","RBD",STR0016)		//Valor do Salario Atual
TRCell():New(oSection2,"RBD_VLPREV","RBD",STR0017)		//Valor do Salario Previsto
TRCell():New(oSection2,"RBE_VLAPRO","RBE") 				//Valor Aprovado
TRCell():New(oSection2,"RBD_QTATUA","RBD",STR0018)		//Nr. Funcionario Atual
TRCell():New(oSection2,"RBD_QTPREV","RBD",STR0019)		//Nr. Funcionario Previsto
TRCell():New(oSection2,"RBE_QTAPRO","RBE",STR0022)		//Nr. Funcionario Aprovado
TRCell():New(oSection2,"RBE_DTAPRO","RBE")				//Data da Aprovacao
TRCell():New(oSection2,"RBE_USUARI","RBE",STR0021)		//Nome do Usuario/Aprovador
	
#IFNDEF TOP 
	TRPosition():New(oSection2,"SRJ",1,{|| xFilial("SRJ") + RBE->RBE_FUNCAO})
	TRPosition():New(oSection2,"RBD",1,{|| xFilial("RBD") + RBE->RBE_CC + RBE->RBE_ANOMES + RBE->RBE_FUNCAO})
#ENDIF

Return oReport 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 15.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Relatorio                                      ³±±
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
Local cTitFun	 := ""
Local cTitCC	 := ""
Local cTitPer	 := ""

#IFDEF TOP
	Local lQuery    := .F. 
	Local cOrder	:= "" 
	Local cSitQuery	:= ""
#ELSE
	Local cFiltro:= ""
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                          ³
//³ mv_par01        //  Filial?                                                   ³
//³ mv_par02        //  Centro de Custo ?                                         ³
//³ mv_par03        //  Funcao ?                                                  ³
//³ mv_par04        //  Ano/Mes ?                                                 ³
//³ mv_par05        //  Imprime: 1-Analitico; 2-Sintetico?                        ³
//³ mv_par06        //  Totaliza Funcao ? 1-Sim; 2-Nao?                           ³
//³ mv_par07        //  Totaliza Periodo ? 1-Sim; 2-Nao?                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

#IFNDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Transforma parametros Range em expressao (intervalo) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr("CS10AR")	                                  	

	If !Empty(mv_par01)	//RBE_FILIAL
		cFiltro:= mv_par01 + ' .And. '
	EndIf  
	
	If !Empty(mv_par02)	//RBE_CC
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += mv_par02
	EndIf  
	
	If !Empty(mv_par03)	//RBE_FUNCAO
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += mv_par03

	EndIf  
	
	If !Empty(mv_par04)	//RBE_ANOMES
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += mv_par04
 
	EndIf  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro para a Tabela Principal da Secao Pai  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:SetFilter(cFiltro)

	oReport:SetMeter(RBE->(LastRec()))	  
	   
	oSection2:SetParentFilter({|cParam| RBE->RBE_CC + RBE->RBE_ANOMES == cParam},{|| RBE->RBE_CC + RBE->RBE_ANOMES})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Desabilita a impressao das celulas do Arquivo Secundario RBD ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par05 <> 2 //Analitico
		oSection2:Cell("RBD_VLATUA"):Hide()
		oSection2:Cell("RBD_VLPREV"):Hide()
		oSection2:Cell("RBD_QTATUA"):Hide()
		oSection2:Cell("RBD_QTPREV"):Hide()
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Totalizacao por Funcao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par06 == 1 .And. mv_par05 <> 2
		
		oBreakFuncao := TRBreak():New(oSection2,oSection2:Cell("RBE_FUNCAO"),STR0023) // "Total por Função"
		oBreakFuncao:OnBreak({|x,y|cTitFun:=OemToAnsi(STR0023)+x}) 
    	oBreakFuncao:SetTotalText({||cTitFun})
	                                                             
		TRFunction():New(oSection2:Cell("RBD_VLATUA"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_VLPREV"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_VLAPRO"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		
		TRFunction():New(oSection2:Cell("RBD_QTATUA"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_QTPREV"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_QTAPRO"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
	
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Totalizacao por Periodo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par07 == 1 .And. mv_par05 <> 2 
				
		oBreakPer := TRBreak():New(oSection2,oSection1:Cell("RBE_ANOMES"),STR0024) // "Total por Periodo
		oBreakPer:OnBreak({|x,y|cTitPer:=OemToAnsi(STR0024)+x}) 
    	oBreakPer:SetTotalText({||cTitPer})
	                                                                 
		TRFunction():New(oSection2:Cell("RBD_VLATUA"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_VLPREV"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_VLAPRO"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		
		TRFunction():New(oSection2:Cell("RBD_QTATUA"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_QTPREV"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_QTAPRO"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)	

	EndIf      
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Totalizacao por Funcao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par05 <> 2
		oBreakCC := TRBreak():New(oReport,oSection1:Cell("RBE_CC"),OemToAnsi(STR0025)) // "Total por C.Custo" 
		oBreakCC:OnBreak({|x,y|cTitCC:=OemToAnsi(STR0025)+x}) 
    	oBreakCC:SetTotalText({||cTitCC})
		                                                             
		TRFunction():New(oSection2:Cell("RBD_VLATUA"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_VLPREV"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_VLAPRO"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_QTATUA"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_QTPREV"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_QTAPRO"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
	EndIf
	
	oSection1:Print() //Imprimir 	
#ELSE	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Transforma parametros Range em expressao SQL ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr("CS10AR")    
	
	//-- Filtragem do relatório
	//-- Query do relatório da secao 1
	lQuery := .T.         
		                                           
	oReport:Section(1):BeginQuery()	
	
 	cOrder := "%RBE_FILIAL,RBE_CC%" 

	BeginSql Alias cAliasQry	
		SELECT RBE_FILIAL,RBE_CC,I3_DESC,RBE_ANOMES,RBE_FUNCAO,RJ_DESC,RBD_VLATUA,RBD_VLPREV,RBE_VLAPRO,RBD_QTATUA,RBD_QTPREV,RBE_QTAPRO,RBE_DTAPRO,RBE_USUARI
		FROM 	%table:RBE% RBE 
		LEFT JOIN %table:SI3% SI3
			ON I3_FILIAL = %xFilial:SI3%
			AND I3_CUSTO = RBE_CC
			AND SI3.%NotDel%
		LEFT JOIN %table:SRJ% SRJ
			ON RJ_FILIAL = %xFilial:SRJ%
			AND RJ_FUNCAO = RBE_FUNCAO
			AND SRJ.%NotDel%
		LEFT JOIN %table:RBD% RBD
			ON RBD_FILIAL = %xFilial:RBD%
			AND RBD_CC = RBE_CC
			AND RBD_ANOMES = RBE_ANOMES
			AND RBD_FUNCAO = RBE_FUNCAO
			AND RBD.%NotDel%								
		WHERE RBE_FILIAL = %xFilial:RBE% AND
			RBE.%NotDel%   													
		ORDER BY %Exp:cOrder%                 				
	EndSql
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery({mv_par01,mv_par02,mv_par03,mv_par04})	/*Array com os parametros do tipo Range*/
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Utiliza a query do Pai  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection2:SetParentQuery()                                
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio da impressao do fluxo do relatório ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     
	oSection2:SetParentFilter({|cParam| (cAliasQry)->RBE_CC + (cAliasQry)->RBE_ANOMES == cParam},{|| (cAliasQry)->RBE_CC + (cAliasQry)->RBE_ANOMES})
	oReport:SetMeter(RBE->(LastRec()))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Desabilita a impressao das celulas do Arquivo Secundario RBD ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par05 <> 2 //Analitico
		oSection2:Cell("RBD_VLATUA"):Hide()
		oSection2:Cell("RBD_VLPREV"):Hide()
		oSection2:Cell("RBD_QTATUA"):Hide()
		oSection2:Cell("RBD_QTPREV"):Hide()
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Totalizacao por Funcao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par06 == 1 .And. mv_par05 <> 2
		
		oBreakFuncao := TRBreak():New(oSection2,oSection2:Cell("RBE_FUNCAO"),STR0023) // "Total por Função" 
		oBreakFuncao:OnBreak({|x,y|cTitFun:=OemToAnsi(STR0023)+x}) 
    	oBreakFuncao:SetTotalText({||cTitFun})
	                                                             
		TRFunction():New(oSection2:Cell("RBD_VLATUA"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_VLPREV"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_VLAPRO"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		
		TRFunction():New(oSection2:Cell("RBD_QTATUA"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_QTPREV"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_QTAPRO"),/*cId*/,"SUM",oBreakFuncao,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
	
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Totalizacao por Periodo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par07 == 1 .And. mv_par05 <> 2 
		
		oBreakPer := TRBreak():New(oSection2,oSection1:Cell("RBE_ANOMES"),STR0024) // "Total por Periodo
		oBreakPer:OnBreak({|x,y|cTitPer:=OemToAnsi(STR0024)+x}) 
    	oBreakPer:SetTotalText({||cTitPer})
	                                                                 
		TRFunction():New(oSection2:Cell("RBD_VLATUA"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_VLPREV"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_VLAPRO"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		
		TRFunction():New(oSection2:Cell("RBD_QTATUA"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_QTPREV"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_QTAPRO"),/*cId*/,"SUM",oBreakPer,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)	

	EndIf      
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Totalizacao por Funcao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par05 <> 2
		oBreakCC := TRBreak():New(oReport,oSection1:Cell("RBE_CC"),STR0025) // "Total por C.Custo" 
		oBreakCC:OnBreak({|x,y|cTitCC:=OemToAnsi(STR0025)+x}) 
    	oBreakCC:SetTotalText({||cTitCC})
		                                                             
		TRFunction():New(oSection2:Cell("RBD_VLATUA"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_VLPREV"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_VLAPRO"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_QTATUA"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBD_QTPREV"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
		TRFunction():New(oSection2:Cell("RBE_QTAPRO"),/*cId*/,"SUM",oBreakCC,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,/*lEndReport*/,/*lEndPage*/)
	EndIf
	
	oSection1:Print() //Imprimir 	
	
#ENDIF 

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS10ARSX1 ³ Autor ³Eduardo Ju             ³ Data ³ 18.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Criacao do Pergunte CS10AR no Dicionario SX1                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CSA010                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 
Static Function CS10ARSX1()             

Local aRegs		:= {} 
Local cPerg		:= "CS10AR"  
Local aHelp		:= {}
Local cHelp		:= ""             
Local aHelpE	:= {}
Local aHelpI	:= {}   

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Filial      																³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aHelp := {	"Informe intervalo de filiais que deseja ",;
			"considerar para impressao do relatorio." }
aHelpE:= {	"Informe intervalo de sucursales ",;
			"que desea considerar para impresion ",;
			"del informe." }
aHelpI:= {	"Enter branch range to be considered to ",;
			"print report." }
cHelp := ".RHFILIAL."     
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel       GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01                    Var02  Def02    		DefSpa2         DefEng2	   	     Cnt02  	Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  GrgSxg cPyme aHelpPor	aHelpEng	aHelpSpa    cHelp    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{cPerg	,"01"	,"Filial?"	   		,"¿Sucursal ?"     		,"Branch ?"				,"mv_ch1"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par01"	,""				,""				,""				,"RBE_FILIAL"			,""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"XM0",""    ,"S"  ,""      ,""      ,""     ,cHelp})

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
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel       GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01                    Var02  Def02    		DefSpa2         DefEng2	   	     Cnt02  	Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  GrgSxg cPyme aHelpPor	aHelpEng	aHelpSpa    cHelp    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{cPerg ,"02","Centro de Custo  ?","¿Centro de Costo ?","Cost Center?" ,"MV_CH2","C" ,99      ,0      ,0     ,"R"  ,""     ,"MV_PAR02",""    ,""      ,""     ,"RBE_CC",""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"CTT","004"  ,"S"  ,""      ,""      ,""     ,cHelp})

aHelp := {	"Informe intervalo de Funcoes ",;
			"que deseja considerar para impressao ",;
			"do relatorio." }
aHelpE:= {	"Informe intervalo de Funciones ",;
			"que desea considerar para impresion ",;
			"del informe." }
aHelpI:= {	"Enter the function range to be ",;
			"considered for printing the report." }
cHelp := ".RHFUNCAO."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  	Ordem 	Pergunta Portugues  Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  	Tamanho Decimal Presel       GSC   	Valid       Var01      	Def01           DefSPA1        	DefEng1      	Cnt01                    Var02  Def02    		DefSpa2         DefEng2	   	     Cnt02  	Var03 	Def03      			DefSpa3    			DefEng3  		Cnt03  	Var04  	Def04     	DefSpa4    	DefEng4  	Cnt04  	Var05  	Def05       DefSpa5		DefEng5   	Cnt05  	XF3  GrgSxg cPyme aHelpPor	aHelpEng	aHelpSpa    cHelp    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Aadd(aRegs,{cPerg	,"03"	,"Funcao?"	   		,"¿Funcion ?"     		,"Position ?"			,"mv_ch3"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par03"	,""				,""				,""				,"RBE_FUNCAO"			,""    ,""   ,""     ,""     ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"SRJ"," "  ,"S"  ,""      ,""      ,""     ,cHelp})

aHelp := {	"Informe o intervalo de Ano e Mes, ",;
			"no formato AAAAMM, que deseja consi- ",;
			"derar para o Processamento. Exemplo: ",;
			"para solicitar o intervalo de agosto ",;
			"a dezembro de 2006, informe ",;
			"'200608-200612'." }
aHelpE:= {	"Informe intervalo de Ano y Mes, ",;
			"en el formato AAAAMM, que desea ",;
			"considerar para el Procesamiento.",;
			" Ejemplo: 200608-200612 "}
aHelpI:= {	"Enter Year and Month range in ",;
			 "format YYYYMM to be considered to ",;
			"Process. Example: 200608-200612." }
cHelp := ".CS10AR04."
PutSX1Help("P"+cHelp,aHelp,aHelpI,aHelpE)	 
Aadd(aRegs,{cPerg	,"04"	,"Ano/Mes   ?"	   	,"¿Ano/Mes ?"     	    ,"Year/Month ?"	        ,"mv_ch4"  	,"C"	,99			,0		,0		,"R"	,""			,"mv_par04"	,"" 	 	    ,""				,""				,"RBE_ANOMES"			,""		,""				,""				,""				,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""	,""   ,"S"	,aHelp  ,aHelpI   ,aHelpE  ,cHelp})

Aadd(aRegs,{cPerg	,"05"	,"Imprime ?"	   	,"¿Imprime ?"     		,"Print ?"				,"mv_ch5"  	,"N"	,1			,0		,1		,"C"	,""			,"mv_par05"	,"Analitico"	,"Analitico"	,"Detailed"		,""						,""		,"Sintetico"	,"Sintetico"	,"Summarized"	,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""	,""   ,"S"	,{}			,{}			,{}			,'.RHTPREL.'})              
Aadd(aRegs,{cPerg	,"06"	,"Totaliza Funcao ?","¿Totaliza Funcion?" 	,"Totalize Function ?"	,"mv_ch6"  	,"N"	,1			,0		,1		,"C"	,""			,"mv_par06"	,"Sim"			,"Si"			,"Yes"			,""						,""		,"Nao"			,"No"			,"No"			,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""	,""   ,"S"	,{}			,{}			,{}			,""})              
Aadd(aRegs,{cPerg	,"07"	,"Totaliza Periodo ?","¿Totaliza Periodo ?" ,"Total Period ?"		,"mv_ch7"  	,"N"	,1			,0		,1		,"C"	,""			,"mv_par07"	,"Sim"			,"Si"			,"Yes"			,""						,""		,"Nao"			,"No"			,"No"			,""			,""		,""					,""					,""				,""		,""		,""			,""			,""			,""		,""     ,""			,""			,""			,""		,""	,""   ,"S"	,{}			,{}			,{}			,""})              
 
ValidPerg(aRegs,cPerg)

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CSA010R3 ³ Autor ³ Equipe Desenvolv. R.H.³ Data ³ 04/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Aprovacao de Vagas de uma empresa.     		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CSA010(void)												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 		ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	³ BOPS ³  Motivo da Alteracao			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³		³      ³ 										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSA010R3()

Local cDesc1  := STR0001		//"Relatorio de Aprovacao de Aumento de Quadro de Funcionarios."
Local cDesc2  := STR0002		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := STR0003		//"usuario."
Local cString := "RBE"
Local cAux	  := ""
Local aOrd	  := {STR0004}  	//"Centro de Custo"

Private aReturn  := {STR0005,1,STR0006,2,2,1,"",1 } //"Zebrado"###"Administra‡„o"
Private NomeProg := "CSA010"
Private nLastKey := 0
Private cPerg	 := "CS010A"
Private nOrdem 	 := 1
Private AT_PRG	 := "CSA010"
Private wCabec0  := 1
Private wCabec1	 :=	STR0007 //"     ANO/MES FUNCAO                          VL.ATUAL  VL.PREVISTO  VL.APROVADO QT.ATUAL QT.PREV. QT.APROV. DT. APROV. APROVADOR " 
							//      9999/01 123456789012345678901234567 123456789012 123456789012 123456789012  123456   123456    123456  99/99/9999 1234567890
Private Contfl   := 1
Private Li		 := 0
Private nTamanho := "M"
Private TITULO   := STR0008		//" Aprovacao de Aumento de Quadro "
Private cFilDe, cFilAte, cCCDe, cCCAte, cDtDe, cDtAte

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("CS010A",.F.)             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na pergunte                                 ³
//³ mv_par01				// Filial De                             ³
//³ mv_par02				// Filial Ate                            ³
//³ mv_par03				// Centro de Custo De                    ³
//³ mv_par04				// Centro de Custo Ate                   ³
//³ mv_par05				// Funcao De                             ³
//³ mv_par06				// Funcao Ate                            ³
//³ mv_par07				// Ano/Mes De                            ³
//³ mv_par08				// Ano/Mes Ate                           ³
//³ mv_par09				// Imprime:	   1-Analitico / 2-Sintetico ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="CSA010"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@TITULO,cDesc1,cDesc2,cDesc3,.F.,aOrd)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilDe	:= Iif(xFilial("RBE")== Space(FWGETTAMFILIAL), Space(FWGETTAMFILIAL), mv_par01)
cFilAte	:= mv_par02
cCCDe	:= mv_par03
cCCAte	:= mv_par04
cFunDe 	:= mv_par05
cFunAte	:= mv_par06
cDtDe	:= mv_par07
cDtAte	:= mv_par08
nImprim	:= mv_par09
nTotFun := mv_par10
nTotPer := mv_par11

If 	Val(Substr(cDtDe,1,4)) < 1900 .Or.;
	Val(Substr(cDtAte,1,4)) < 1900
    Help("",1,"CSR060ANO")      // Verifique o Ano das perguntes
    Return Nil
EndIf             

If	Val(Substr(cDtDe,5,2)) < 1 	.Or.;
	Val(Substr(cDtDe,5,2)) > 12 	.Or.;
	Val(Substr(cDtAte,5,2)) < 1 	.Or.;
	Val(Substr(cDtAte,5,2)) > 12
	Help("",1,"CSR060MES")		// Verifique o Mes das perguntes	
	Return Nil
EndIf		

If 	cDtDe > cDtAte
	Help("",1,"CSR060MAIO")	// Ano/Mes De deve ser menor que ANO/MES Ate
	Return Nil
EndIf

cAux := cDtDe
While Val( cAux ) <= Val( cDtAte)
	nMes := Val(Substr(cAux,5,2)) + 1
	nAno := Val(Substr(cAux,1,4))
	If nMes > 12
		cAux := StrZero(nAno + 1,4) + "01"
	Else
		cAux := StrZero(nAno,4) + StrZero(nMes,2)
	EndIf
EndDo    

nOrdem  := aReturn[8]

If 	nLastKey == 27
	Return Nil
EndIf

SetDefault(aReturn,cString)

If 	nLastKey == 27
	Return Nil
EndIf

RptStatus({|lEnd| Cs010Imp()},TITULO)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CS010Imp ³ Autor ³ Equipe Desenv. R.H.   ³ Data ³ 04/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Aprovacoes de vagas.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Cs010Imp()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico 											  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function Cs010Imp()
Local cAcessaRBE:= &("{ || " + ChkRH(FunName(),"RBE","2") + "}")
Local cInicio	:=""
Local cFim		:=""                                    
Local cAuxCC	:= "!!!!!!!!!"
Local l1Vez		:= .T.
Local lPrimF 	:= .T.
Local lPrimP 	:= .T.
Local cAnoMes   := ""
Local cFunc  	:= ""
Local cDtApro   := ""                                                                        
Local nP_VLATUA := nP_VLPREV := nP_VLAPRO := nP_QTATUA := nP_QTPREV := nP_QTAPRO := 0	//Totais Periodo
Local nC_VLATUA := nC_VLPREV := nC_VLAPRO := nC_QTATUA := nC_QTPREV := nC_QTAPRO := 0	//Totais C.Custo
Local nG_VLATUA := nG_VLPREV := nG_VLAPRO := nG_QTATUA := nG_QTPREV := nG_QTAPRO := 0	//Totais Geral

dbSelectArea("RBE")
dbSetOrder(1)     
dbSeek(cFilDe+cCCDe+cDtDe+cFunDe,.T.)
cInicio := "RBE->RBE_FILIAL+RBE->RBE_CC+RBE->RBE_ANOMES+RBE->RBE_FUNCAO"
cFim    := cFilAte+cCCAte+cDtAte+cFunAte

SetRegua(RBE->(RecCount()))

While	!Eof() .And. &cInicio <= cFim

	If !Eval(cAcessaRBE)
		dbSkip()  
		Loop
	EndIf      

	If RBE->RBE_FILIAL < cFilDe .Or. RBE->RBE_FILIAL > cFilAte
		dbSkip()
		Loop
	EndIf
	
	If RBE->RBE_CC < cCCDe .Or. RBE->RBE_CC > cCCAte
		dbSkip()
		Loop
	EndIf
	
	If RBE->RBE_ANOMES < cDtDe .Or. RBE->RBE_ANOMES > cDtAte
		dbSkip()
		Loop
	EndIf
	
	If RBE->RBE_FUNCAO < cFunDe .Or. RBE->RBE_FUNCAO > cFunAte
		dbSkip()
		Loop
	EndIf
	
	IncRegua()
	
	If 	!l1Vez	
		cDet := ""
		IMPR(cDet,"C")			
	Else
		l1Vez := .F.
	EndIf

	cDet:=	Space(01)+RBE->RBE_FILIAL
	If 	cAuxCC # RBE->RBE_CC .Or.;
		(li >= 58 .And. cAuxCC == RBE->RBE_CC)
		cDet	:= STR0009 +RBE->RBE_CC+Space(01)+DescCC(RBE->RBE_CC,xFilial("SI3"),25)	//"Centro de Custo: "
		cAuxCC 	:= RBE->RBE_CC
		Impr(cDet,"C")         
		Impr("","C")
	EndIf	          

	//"     ANO/MES FUNCAO                          VL.ATUAL  VL.PREVISTO  VL.APROVADO QT.ATUAL QT.PREV. QT.APROV. DT. APROV. APROVADOR " 
	//      9999/01 123456789012345678901234567 123456789012 123456789012 123456789012  123456   123456    123456  99/99/9999 1234567890

	nC_VLATUA := 0
    nC_VLPREV := 0
    nC_VLAPRO := 0
    nC_QTATUA := 0
    nC_QTPREV := 0
    nC_QTAPRO := 0
    
	While RBE->RBE_CC == cAuxCC	// C.Custo

		If !Eval(cAcessaRBE)
			dbSkip()  
			Loop
		EndIf      

		If RBE->RBE_CC < cCCDe .Or. RBE->RBE_CC > cCCAte
			dbSkip()
			Loop
		EndIf

		If RBE->RBE_ANOMES < cDtDe .Or. RBE->RBE_ANOMES > cDtAte
			dbSkip()
			Loop
		EndIf
	
		cAnoMes := RBE->RBE_ANOMES
		lPrimP 	:= .T.	  		
		
		nP_VLATUA := 0
        nP_VLPREV := 0
        nP_VLAPRO := 0
        nP_QTATUA := 0
        nP_QTPREV := 0
        nP_QTAPRO := 0
	
		While RBE->RBE_CC+RBE->RBE_ANOMES == cAuxCC+cAnoMes  // Periodo
	
			If RBE->RBE_FUNCAO < cFunDe .Or. RBE->RBE_FUNCAO > cFunAte
				dbSkip()
				Loop
			EndIf

			lPrimF 	:= .T.	  

			cFunc	:= RBE->RBE_FUNCAO		
			While RBE->RBE_CC+RBE->RBE_ANOMES+RBE_FUNCAO == cAuxCC+cAnoMes+cFunc // Funcao
      
				If nImprim == 1		//Analitico
					If lPrimP == .T.
						cDet:= 	Space(05)+Substr(RBE->RBE_ANOMES,1,4)+"/"+Substr(RBE->RBE_ANOMES,5,2)
						cDet+= 	Space(01)+RBE->RBE_FUNCAO+" - "+FDesc("SRJ",RBE->RBE_FUNCAO,"RJ_DESC",20)
						lPrimP := .F.
						lPrimF := .F.
					ElseIf lPrimF == .T.
						cDet:= 	Space(12)
						cDet+= 	Space(01)+RBE->RBE_FUNCAO+" - "+FDesc("SRJ",RBE->RBE_FUNCAO,"RJ_DESC",20)					
						lPrimF := .F.	
					Else 
					    cDet:= Space(40)
					EndIf
		    
					cDet+= 	Space(27)+Transform(RBE->RBE_VLAPRO,"@E 99999,999.99")  			
					cDet+=	Space(21)+Transform(RBE->RBE_QTAPRO,"@E 999999")  
					cDtApro:= If(__SetCentury(),Dtoc(RBE->RBE_DTAPRO),Dtoc(RBE->RBE_DTAPRO)+Space(2))
					cDet+= 	Space(02)+cDtApro
					cDet+= 	Space(01)+Transform(RBE->RBE_USUARI,"@!")  			
					IMPR(cDet,"C")
				EndIf

				dbSkip()
			EndDo

			dbSelectArea("RBD")
			dbSetOrder(1)
			If dbSeek(xFilial("RBD")+cAuxCC+cAnoMes+cFunc) 
	
				If nImprim == 1 .And. nTotFun == 1
					If Li > 54
						Impr("","P")
					EndIf
					cDet := __PrtThinLine()
					Impr(cDet,"C")
				EndIf
		
				If nImprim == 2 .Or. nTotFun == 1 //Sim
					If nImprim == 2
						cDet:= Space(05)+Substr(RBD->RBD_ANOMES,1,4)+"/"+Substr(RBD->RBD_ANOMES,5,2)
					Else 
						cDet:= Space(05)+ STR0013 //"Total -"					
					Endif
					cDet+= 	Space(01)+cFunc+" - "+FDesc("SRJ",cFunc,"RJ_DESC",20)
					cDet+= 	Space(01)+Transform(RBD->RBD_VLATUA,"@E 99999,999.99")
					cDet+= 	Space(01)+Transform(RBD->RBD_VLPREV,"@E 99999,999.99")
					cDet+= 	Space(01)+Transform(RBD->RBD_VLAPRO,"@E 99999,999.99")  					
					cDet+= 	Space(02)+Transform(RBD->RBD_QTATUA,"@E 999999")
					cDet+=	Space(03)+Transform(RBD->RBD_QTPREV,"@E 999999") 
					cDet+=	Space(04)+Transform(RBD->RBD_QTAPRO,"@E 999999") 
					Impr(cDet,"C")
				EndIf
		
				If nImprim == 1 .And. nTotFun == 1
					cDet := __PrtThinLine()
					Impr(cDet,"C")
					Impr("","C")
				EndIf
			
		        nP_VLATUA += RBD->RBD_VLATUA
     			nP_VLPREV += RBD->RBD_VLPREV
        		nP_VLAPRO += RBD->RBD_VLAPRO
        		nP_QTATUA += RBD->RBD_QTATUA
        		nP_QTPREV += RBD->RBD_QTPREV
        		nP_QTAPRO += RBD->RBD_QTAPRO
	
			EndIf
		
			dbSelectArea("RBE")	
		EndDo

		// Total do Periodo
		If nImprim == 1 .And. nTotPer == 1
			If Li > 54
				Impr("","P")
			EndIf
			cDet := __PrtThinLine()
			Impr(cDet,"C")

			cDet:= 	Space(05)+STR0012	//"Total do Periodo - "
			cDet+= 	Space(01)+Substr(cAnoMes,1,4)+"/"+Substr(cAnoMes,5,2)+ Space(08)
			cDet+= 	Space(01)+Transform(nP_VLATUA,"@E 99999,999.99")
			cDet+= 	Space(01)+Transform(nP_VLPREV,"@E 99999,999.99")
			cDet+= 	Space(01)+Transform(nP_VLAPRO,"@E 99999,999.99")  					
			cDet+= 	Space(02)+Transform(nP_QTATUA,"@E 999999")
			cDet+=	Space(03)+Transform(nP_QTPREV,"@E 999999") 
			cDet+=	Space(04)+Transform(nP_QTAPRO,"@E 999999") 
			Impr(cDet,"C")

			cDet := __PrtThinLine()
			Impr(cDet,"C")
			Impr("","C")
		EndIf
        nC_VLATUA += nP_VLATUA
        nC_VLPREV += nP_VLPREV
        nC_VLAPRO += nP_VLAPRO
        nC_QTATUA += nP_QTATUA
        nC_QTPREV += nP_QTPREV
        nC_QTAPRO += nP_QTAPRO
	EndDo   

	// Total do Centro de Custo
	cDet := __PrtThinLine()
	Impr(cDet,"C")

	cDet:= 	Space(05)+STR0010		// "Total C.Custo - "
	cDet+= 	Space(01)+cAuxCC + Space(09)
	cDet+= 	Space(01)+Transform(nC_VLATUA,"@E 99999,999.99")
	cDet+= 	Space(01)+Transform(nC_VLPREV,"@E 99999,999.99")
	cDet+= 	Space(01)+Transform(nC_VLAPRO,"@E 99999,999.99")  					
	cDet+= 	Space(02)+Transform(nC_QTATUA,"@E 999999")
	cDet+=	Space(03)+Transform(nC_QTPREV,"@E 999999") 
	cDet+=	Space(04)+Transform(nC_QTAPRO,"@E 999999") 
	Impr(cDet,"C")

	cDet := __PrtThinLine()
	Impr(cDet,"C")           
	Impr("","C")	
	
	nG_VLATUA += nC_VLATUA
    nG_VLPREV += nC_VLPREV
    nG_VLAPRO += nC_VLAPRO
    nG_QTATUA += nC_QTATUA
    nG_QTPREV += nC_QTPREV
    nG_QTAPRO += nC_QTAPRO
    
EndDo	

// Total Geral
If Li > 54
	Impr("","P")
EndIf
cDet := __PrtThinLine()
Impr(cDet,"C")

cDet:= 	Space(05)+STR0011 + Space(22)	//"Total Geral: "
cDet+= 	Space(01)+Transform(nG_VLATUA,"@E 99999,999.99")
cDet+= 	Space(01)+Transform(nG_VLPREV,"@E 99999,999.99")
cDet+= 	Space(01)+Transform(nG_VLAPRO,"@E 99999,999.99")  					
cDet+= 	Space(02)+Transform(nG_QTATUA,"@E 999999")
cDet+=	Space(03)+Transform(nG_QTPREV,"@E 999999") 
cDet+=	Space(04)+Transform(nG_QTAPRO,"@E 999999") 
Impr(cDet,"C")
	
cDet := __PrtThinLine()
Impr(cDet,"C")

//--Termino do Relatorio                                      
IMPR("","F")

Set Device To Screen                  

dbSelectArea("RBE")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
EndIf

MS_FLUSH()

Return