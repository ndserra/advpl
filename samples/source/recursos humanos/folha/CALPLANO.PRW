#INCLUDE "TOTVS.CH"
#INCLUDE "CALPLANO.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    	³ CALPLANO   ³ Autor ³ Mauricio Takakura     	      ³ Data ³ 16/10/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o 	³ Calculo do Plano de Saude                                    			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   	³ CALPLANO()                                                   			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      	³ Generico ( DOS e Windows )                                   			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data     ³ FNC			³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Ricardo ³28/11/2011³00000030433/2011³Replica do Fonte. Inclusao de bloqueio caso³±±
±±³Cinalli		³		   ³				³nao exista a tabela RHR - Calculo do Plano	³±±
±±³				³		   ³				³de Saude.									³±±
±±³Luis Ricardo ³27/12/2011³Chamado:TEGAX2	³Ajustes no percentual de calculo do plano	³±±
±±³Cinalli		³		   ³Replica dos	cha-³de saude para tipo de plano % Salario.		³±±
±±³				³		   ³mados: TEEJDO e	³Ajuste na leitura dos funcionarios conforme³±±
±±³				³		   ³TEDUJF da ver10.³param. Matricula De/Ate para ambientes DBF.³±±
±±³				³		   ³				³Inclusao de Order By na query.				³±±
±±³Luis Ricardo ³03/01/2012³00000000180/2012³Ajuste para permitir o calculo de acordo	³±±
±±³Cinalli		³		   ³Chamado: TEGZCA	³com a data de referencia, a qual deve ser	³±±
±±³				³		   ³				³maior ou igual ao MV_FOLMES. Este ajuste eh³±±
±±³				³		   ³				³devido a data final do plano estar igual ao³±±
±±³				³		   ³				³mv_folmes e incluir um novo plano com data	³±±
±±³				³		   ³				³de inicio maior que o mv_folmes.			³±±
±±³Allyson M .  ³02/04/2012³00000006678/2012³Ajuste para permitir calculo do plano sobre³±±
±±³             ³		   ³TERLS8	   	    ³salario base ou sobre salario incorporado. ³±±
±±³Luis Ricardo ³23/05/2012³00000013479/2012³Incluido arredondamento em 2 casas decimais³±±
±±³Cinalli		³		   ³Chamado: TFBAZ0 ³no calculo do desconto dos tipos faixa sa-	³±±
±±³				³		   ³				³larial e etaria da parte do funcionario	³±±
±±³				³		   ³				³antes do calculo da parte da empresa para	³±±
±±³				³		   ³				³nao gerar diferenca de centavos entre o vl.³±±
±±³				³		   ³				³do calculo e o vl. total do plano de saude.³±±
±±³Luis Ricardo ³23/05/2012³00000013292/2012³Tratamento para gravacao do novo campo		³±±
±±³Cinalli		³		   ³Chamado: TFATCL ³RHR_TIPO com C-Calculado se existir.		³±±
±±³Luis Ricardo ³29/05/2012³00000013901/2012³Tratamento para limpar aTab_Fol a cada Cal-³±±
±±³Cinalli		³		   ³Chamado: TFBUMH ³culo, pois ao existirem informacoes em		³±±
±±³				³		   ³				³aTab_Fol o sistema acatava como sendo da	³±±
±±³				³		   ³				³Empresa e Filial ativa e nao encontrava as	³±±
±±³				³		   ³				³tabelas correspondentes.					³±±
±±³Luis Ricardo ³25/06/2012³00000015040/2012³Incluido tratamento de duplicidade de pla-	³±±
±±³Cinalli		³		   ³Chamado: TFDSIH ³nos de saude do titular com mesmo tipo e	³±±
±±³				³		   ³				³codigo de fornecedor e log para informar	³±±
±±³				³		   ³				³Titular cadastrado que nao possui plano de	³±±
±±³				³		   ³				³saude ativo para calculo conforme periodo	³±±
±±³				³		   ³				³final preenchido. Ajuste de String.		³±±
±±³Luis Ricardo	³02/08/2012³00000019376/2012³Ajuste na gravacao do campo TIPO da tabela	³±±
±±³Cinalli		³		   ³Ch.: TFMEXN		³Calculo de plano de saude.					³±±
±±³Luis Ricardo	³08/08/2012³00000020333/2012³Ajuste no log do calculo para planos saude	³±±
±±³Cinalli		³		   ³Ch.: TFO168		³com Per. Inicial e Final Divergente do Mes	³±±
±±³				³		   ³				³e Ano do calculo.							³±±
±±³Gustavo M.   ³28/08/2012³00000021678/2012³Ajuste para corrigir error no delete quando³±±
±±³             ³          ³          TFQM68³a base e informix			                ³±±
±±³Luis Ricardo	³31/08/2012³00000022509/2012³Ajuste na gravacao do calculo para somar os³±±
±±³Cinalli		³		   ³Ch.: TFRXTO		³os registros de Co-part./Reembolso de um	³±±
±±³				³		   ³				³mesmo funcionario, plano de saude, verba e	³±±
±±³				³		   ³				³mes do calculo.							³±±
±±³M. Silveira  ³05/12/2012³Chamado:  TGEAVX³Ajuste para pesquisar as Tabelas Auxiliares³±±
±±³				³		   ³				³conforme a Filial do funcionario processado³±±
±±³Allyson M    ³04/04/2013³Chamado:  TGYKUW³Ajuste p/ buscar os lancamentos da RHO pela³±±
±±³				³		   ³				³competencia e nao pela data de ocorrencia. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CALPLANO()

	Local aSays			:= {}
	Local aButtons		:= {}
	
	Local bProcesso		:= { |oSelf| GPMProcessa(oSelf)}
	
	Local cPergCal  
	Local cCadastro		:= OemToAnsi(STR0001)	//"Calculo do Plano de Saude"
	Local cDescricao	:= OemToAnsi(STR0002)	//"Este Programa calculará os valores dos Planos de Saude" 
	
	Local nOpca			:= 0
	
	Private aLog		:= {}
	Private aRoteiro 	:= {}
	Private aTitle		:= {}
	
	Private lVersao101 	:= (GetRpoRelease("R1.1"))
	Private lAbortPrint := .F.

	// Var utilizada para forcar a Carga da Tabela a cada processamento. Eh necessaria para
	// que aTab_Fol seja atualizada conforme as tabelas de cada empresa na funcao fPosTab.
	Private lCarTabFol := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica existencia da nova tabela Calculo do Plano de Saude - RHR.		³
	//³ Se Nao Existir apresenta mensagem informando a necessidade da execucao	³
	//³ do update para criacao e aborta o acesso ate que o update seja executado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty( RetTableName( "RHR" ) )
		Aviso( STR0022, STR0023, { STR0024 } ) // "Atenção"## "Execute a opção do compatibilizador referente ao Novo Plano de Saúde. Para maiores informações, verifique respectivo Boletim Técnico." ## "OK"
		Return
	EndIf

	AjustaSX1()

	cPergCal 	:= "GPCALPL"
	Pergunte(cPergCal,.F.)
	
	If lVersao101
		tNewProcess():New( "CALPLAN", cCadastro, bProcesso, cDescricao, cPergCal, , , , , .T., .T. )
	Else
		aAdd(aSays, cDescricao )

		aAdd(aButtons, { 5,.T.,{|| Pergunte(cPergCal,.T. ) } } )
		aAdd(aButtons, { 1,.T.,{|o| nOpca := 1,IF(gpconfOK(),FechaBatch(),nOpca:=0) }} )
		aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )

		FormBatch( cCadastro, aSays, aButtons )
	
		If nOpca == 1
			Processa({|lEnd| GPMProcessa()},OemToAnsi(STR0001))
		EndIf
	EndIf

Return

/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ GPMProcessa	³Autor³  Mauricio Takakura³ Data ³13/10/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Rotina de Processamento.                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³CALPLANO                                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function GPMProcessa(oSelf)
    Local dDataRef
    Local cMesAno
    Local cFilDe
    Local cFilAte
    Local cCcDe
    Local cCcAte
    Local cMatrDe
    Local cMatrAte
    Local cCateg
    Local cTpLan
    Local cSituacao
	
	Local cSpcCodigo 	:= Space(GetSx3Cache("RHR_CODIGO", "X3_TAMANHO"))
	Local cSpcTpPLan 	:= Space(GetSx3Cache("RHK_TPPLAN", "X3_TAMANHO"))
	Local cSpcPlano 	:= Space(GetSx3Cache("RHK_PLANO", "X3_TAMANHO"))
    
    Local cAcessaSRA	:= &( " { || " + IF( Empty( cAcessaSRA := ChkRH( "CALPLANO" , "SRA" , "2" ) ) , ".T." , cAcessaSRA ) + " } " )

	Local cAliasSRA		:= "SRA"
	Local cFolMes 		:= GetMv( "MV_FOLMES",,Space(08) ) 
	Local cRHK_Titular
	Local cCposQuery
	Local cCatQuery
	Local cSitQuery

	Local lRet 
	Local lHasDep

	Local cCodForAnt	:= ""
	Local cTpFornAnt	:= ""

	Local cAnoMesInT	:= ""	// Ano e Mes do Inicio do plano de saude do Titular
	Local cAnoMesFiT	:= ""	// Ano e Mes do Final do plano de saude do Titular
	Local lTemPlAtTi	:= .F.	// Define se Tem Algum Plano de saude Ativo para o Titular ou Nao (.F. = Nao Tem, .T. = Tem plano)

	Local cArqRHO		:= CriaTrab( Nil, .F. )
	Local cIndKeyRHO	:= "RHO_FILIAL+RHO_MAT+RHO_COMPPG"

	Private nSalCalc

	// Carregar as variaveis do grupo de perguntas //
	dDataRef	:=  mv_par01	//	Data de Referencia - Competencia
	cAnoMes		:=  Substr(DTOS( dDataRef ), 1, 6)
	cFilDe		:=	mv_par02	//	Filial De
	cFilAte 	:=	mv_par03	//	Filial Ate
	cCcDe		:=	mv_par04	//	Centro de Custo De
	cCcAte		:=	mv_par05	//	Centro de Custo Ate
	cMatrDe 	:=	mv_par06	//	Matricula De
	cMatrAte	:=	mv_par07	//	Matricula Ate
	cCateg      :=  mv_par08	//  Categorias a serem calculadas
	cSituacao	:=  mv_par09	//  Situacoes a serem calculadas
	nSalCalc	:= 	mv_par10	//  Calcular sobre salario ?
	nSalario	:=  0
	nSalHora	:=  0 
	nSalDia		:=  0 
	nSalMes		:=  0  
	
	If cAnoMes < cFolMes 
		Help(,,'HELP',,OemToAnsi(STR0003),1,0)	//"Informe uma data de Referência maior ou igual à Competência da Folha de Pagamento!"
		Return( .F. )
	EndIf
	
    If lVersao101
		oSelf:SetRegua1(SRA->(RecCount()))
		oSelf:SaveLog( STR0001 + " - " + STR0007) //"Calculo do Plano de Saude"##"Inicio do processamento"
	Else
		ProcRegua(SRA->(RecCount()))
	EndIf

	// Filtrar os funcionarios que serao processados //    
	dbSelectArea( "SRA" )
	dbSetOrder( 1 )
	dbSeek( cFilDe + cMatrDe , .T. )

	#IFDEF TOP
		If !ExeInAs400()
			cAliasSRA 	:= "QSRA"
			If ( Select( cAliasSRA ) > 0 )
				( cAliasSRA )->( dbCloseArea() )
			EndIf 
			cCposQuery 	:= "%SRA.RA_FILIAL, SRA.RA_MAT%"
			If Empty(cCateg)
				cCatQuery 	:= "%'" + "*" + "'%"
			Else
				cCatQuery 	:= Upper("%" + fSqlIN( cCateg, 1 ) + "%")
			EndIf
			If Empty( cSituacao )
				cSitQuery	:= "%'" + " " + "'%"
			Else
				cSitQuery	:= Upper("%" + fSqlIN( cSituacao, 1 ) + "%")
			EndIf
			cRHK_Titular := "%INNER JOIN "+ RetSqlName("RHK") + " RHK "
		    cRHK_Titular += "ON  SRA.RA_FILIAL = RHK.RHK_FILIAL AND SRA.RA_MAT = RHK.RHK_MAT AND RHK.D_E_L_E_T_  = ' ' %" 

			//Sempre que alterar esta query, a query abaixo (count), tb devera ser alterada.
			BeginSql alias cAliasSRA   
				SELECT %exp:cCposQuery%
				FROM %table:SRA% SRA
				%Exp:cRHK_Titular%
				WHERE  SRA.RA_FILIAL BETWEEN %exp:cFilDe% AND %exp:cFilAte% 
					   AND SRA.RA_MAT BETWEEN %exp:cMatrDe% AND %exp:cMatrAte%
					   AND SRA.RA_CC BETWEEN %exp:cCCDe% AND %exp:cCCAte% 
					   AND SRA.RA_CATFUNC IN (%exp:cCatQuery%) 
					   AND SRA.RA_SITFOLH IN (%exp:cSitQuery%) 
	   				   AND SRA.%notDel%
	   			GROUP BY SRA.RA_FILIAL, SRA.RA_MAT
	   			ORDER BY SRA.RA_FILIAL, SRA.RA_MAT
			EndSql
		EndIf
	#ENDIF 

	Aadd( aTitle, OemToAnsi(STR0009 ))		// "Tabela nao Cadastrada ou Valores fora da Faixa" 
	Aadd( aLog, {} )

	Aadd( aTitle, OemToAnsi( STR0018 ))		// "Dependentes e Agregados não calculados"
	Aadd( aLog, {} )

	Aadd( aTitle, OemToAnsi( STR0026 ) )	// "Titular possui mais de um plano com mesmo Fornecedor"
	Aadd( aLog, {} )

	Aadd( aTitle, OemToAnsi( STR0028 ) )	// "Titular possui plano de saúde com Período Inicial e Final divergente do Mês e Ano do cálculo" 
	Aadd( aLog, {} )

	Aadd( aTitle, OemToAnsi( STR0027 ) )	// "Titular nao possui plano de saúde ativo para o Mês e Ano do cálculo"
	Aadd( aLog, {} )

	While (cAliasSRA)->( !Eof() )     
    
		If lVersao101
			If oSelf:lEnd 
				Break
			EndIf
		Else
			If lAbortPrint
				Break
			Endif
        EndIf

		If Eof() .Or. ( (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT > cFilAte + cMatrAte )
			Exit
		Endif

		#IFNDEF TOP
		
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Consiste o De / Ate 										   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
    		If ((cAliasSRA)->RA_CC < cCcDe .or. (cAliasSRA)->RA_CC > cCCAte ) .or. ; 
				((cAliasSRA)->RA_MAT < cMatrDe .or. (cAliasSRA)->RA_MAT > cMatrAte ) .or. ;  
				!( (cAliasSRA)->RA_SITFOLH $ cSituacao ) .or. !( (cAliasSRA)->RA_CATFUNC $ cCateg )
				dbSelectArea(cAliasSRA)
				dbSkip()
				Loop
			EndIf
		#ELSE
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Posiciona na tabela SRA - Fisica                    	 	   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			DbSelectArea( "SRA" )
			DbSetOrder( RetOrder( "SRA", "RA_FILIAL+RA_MAT" ))
			DbSeek( (cAliasSRA)->(RA_FILIAL+RA_MAT),.F.)
		#ENDIF

		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Consiste Filiais e Acessos                                             ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		IF !( (cAliasSRA)->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
			dbSelectArea(cAliasSRA)
			dbSkip()
			Loop
		EndIF
		
		If lVersao101
			oSelf:IncRegua1(OemToAnsi(STR0004) + "  " + (cAliasSRA)->RA_FILIAL + " - " + (cAliasSRA)->RA_MAT + " - " + SRA->RA_NOME) //"Calculando Plano de Saude de:"
		Else
			IncProc( (cAliasSRA)->RA_FILIAL + " - " + (cAliasSRA)->RA_MAT + " - " + SRA->RA_NOME )
		EndIf

		// Deletar o Calculo do Funcionario //
		fDeleCalc()
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Nao calcular funcionarios demitidos fora do Mes                        ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If SRA->RA_SITFOLH == "D" .and. ( cAnoMes > Substr(DTOS( SRA->RA_DEMISSA ), 1, 6) )
			dbSelectArea(cAliasSRA)
			dbSkip()
			Loop
		EndIf

		//Ajuste para verificar se utiliza salario base ou salario incorporado
		If nSalCalc == 1
			fSalario(@nSalario,@nSalHora,@nSalDia,@nSalMes,"A")
		ElseIf nSalCalc == 2	
			fSalInc(@nSalario,@nSalMes,@nSalHora,@nSalDia)
		EndIf

		// Limpa variaveis de controle para iniciar calculo do funcionario
		cCodForAnt	:= ""	// Codigo Fornecedor Anterior
		cTpFornAnt	:= ""	// Tipo do Fornecedor Anterior
		lTemPlAtTi	:= .F.	// Define se Tem Algum Plano de saude Ativo para o Titular ou Nao (.F. = Nao Tem, .T. = Tem plano)

		Begin Transaction 
		
			// Calculo dos Planos do Titular //
			DbSelectArea( "RHK" )
			DbSetorder( RetOrdem( "RHK", "RHK_FILIAL+RHK_MAT+RHK_TPFORN+RHK_CODFOR" ) )
			DbSeek( (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT, .F. )

			cPDDepAgr := ""

			While RHK->( !Eof() ) .and. RHK->RHK_FILIAL + RHK->RHK_MAT == (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT

			 	// Atualiza variaveis de Ano e Mes de Inicio e Fim do plano de saude do Titular
				cAnoMesInT	:= Substr(RHK->RHK_PERINI,3,4) + Substr(RHK->RHK_PERINI,1,2)
				cAnoMesFiT	:= Substr(RHK->RHK_PERFIM,3,4) + Substr(RHK->RHK_PERFIM,1,2)

				// Gera log de calculo se houver duplicidade de plano para o titular
				If RHK->RHK_TPFORN == cTpFornAnt .and. RHK->RHK_CODFOR == cCodForAnt
					If Len( aLog[3] ) == 0 .or. Ascan( aLog[3], { |x| x == Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) } ) == 0
						aAdd( aLog[3], Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) )
					EndIf	
				Else
					// Carrega variaveis de Codigo e Tipo do Fornecedor anterior
					cCodForAnt	:= RHK->RHK_CODFOR
					cTpFornAnt	:= RHK->RHK_TPFORN
				EndIf

				// Gera log de calculo se Per. Inicial e Final do plano do titular estiver divergente do Mes/Ano a calcular
				If (( cAnoMesInT > cAnoMes ) .or. ( cAnoMesInT <= cAnoMes .and. ! Empty( cAnoMesFiT ) .and. cAnoMesFiT < cAnoMes ))
					If Len( aLog[4] ) == 0 .or. Ascan( aLog[4], { |x| x == Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) } ) == 0
						aAdd( aLog[4], 	Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) 		+ ;
										" Início: "	+ Substr(RHK->RHK_PERINI,1,2) + "/" + Substr(RHK->RHK_PERINI,3,4) 	+ ;
										" Fim: " 	+ Substr(RHK->RHK_PERFIM,1,2) + "/" + Substr(RHK->RHK_PERFIM,3,4) )
					EndIf
					DbSkip()
					Loop
				Else
					lTemPlAtTi := .T.	// O Titular Possui um Plano de saude Ativo
				EndIf

				nVlrFunc := 0
				nVlrEmpr := 0
				lRet := fCalcPlano(1, RHK->RHK_TPFORN, RHK->RHK_CODFOR, RHK->RHK_TPPLAN, RHK->RHK_PLANO, dDataRef, SRA->RA_NASC, @nVlrFunc, @nVlrEmpr, (cAliasSRA)->RA_FILIAL )
				
				If lRet 
					fGravaCalc("1", cSpcCodigo, "1", RHK->RHK_TPFORN, RHK->RHK_CODFOR, RHK->RHK_TPPLAN, RHK->RHK_PLANO, RHK->RHK_PD, nVlrFunc, nVlrEmpr )
				EndIf
				
				cPDDAgr := RHK->RHK_PDDAGR
				                                                                    
				// Calculo dos Planos dos Dependentes //
				DbSelectArea( "RHL" )
				DbSetorder( RetOrdem( "RHL", "RHL_FILIAL+RHL_MAT+RHL_TPFORN+RHL_CODFOR+RHL_CODIGO" ) )
				DbSeek( (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT + RHK->RHK_TPFORN + RHK->RHK_CODFOR, .F. )
				While RHL->( !Eof() ) .and. RHL->RHL_FILIAL + RHL->RHL_MAT + RHL->RHL_TPFORN + RHL->RHL_CODFOR == (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT + RHK->RHK_TPFORN + RHK->RHK_CODFOR
                    
					If !((cAnoMes >= Substr(RHL->RHL_PERINI,3,4)+Substr(RHL->RHL_PERINI,1,2)) .and. Empty( RHL->RHL_PERFIM) .or. (cAnoMes >= Substr(RHL->RHL_PERINI,3,4)+Substr(RHL->RHL_PERINI,1,2)) .and. (cAnoMes <=  Substr(RHL->RHL_PERFIM,3,4)+Substr(RHL->RHL_PERFIM,1,2)))
						DbSkip()
						Loop
					EndIf

					DbSelectArea( "SRB" )
					DbSetOrder( RetOrdem( "SRB", "RB_FILIAL+RB_MAT" ) )
					DbSeek( (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT, .F. )
					lHasDep := .F.
					While SRB->( !EOF() ) .and. SRB->RB_FILIAL + SRB->RB_MAT == SRA->RA_FILIAL + SRA->RA_MAT 
						If SRB->RB_COD == RHL->RHL_CODIGO
							lHasDep := .T.
							Exit
						EndIf
						SRB->( DbSkip() )
					EndDo
				
					If lHasDep
						nVlrFunc := 0
						nVlrEmpr := 0
						lRet := fCalcPlano(2, RHL->RHL_TPFORN, RHL->RHL_CODFOR, RHL->RHL_TPPLAN, RHL->RHL_PLANO, dDataRef, SRB->RB_DTNASC, @nVlrFunc, @nVlrEmpr, (cAliasSRA)->RA_FILIAL )
					
						If lRet .and. Round(nVlrFunc,2) > 0 .or. Round(nVlrEmpr,2) > 0
							fGravaCalc("2", RHL->RHL_CODIGO, "1", RHL->RHL_TPFORN, RHL->RHL_CODFOR, RHL->RHL_TPPLAN, RHL->RHL_PLANO, cPDDAgr, nVlrFunc, nVlrEmpr )
						EndIf
						
						If lRet .and. Round(nVlrFunc,2) <= 0 .and. Round(nVlrEmpr,2) <= 0
							aAdd( aLog[2], Substr(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " - " + ;
								  			OemToAnsi( STR0020 ) + " - " + RHL->RHL_CODIGO ) //"Codigo 
                        EndIf
					EndIf
					
					DbSelectArea( "RHL" )
					DbSkip()

				EndDo
	
				// Calculo dos Planos dos Agregados //
				DbSelectArea( "RHM" )
				DbSetorder( RetOrdem( "RHM", "RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO" ) )
				DbSeek( (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT + RHK->RHK_TPFORN + RHK->RHK_CODFOR, .F. )
				While RHM->( !Eof() ) .and. RHM->RHM_FILIAL + RHM->RHM_MAT + RHM->RHM_TPFORN + RHM->RHM_CODFOR == (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT + RHK->RHK_TPFORN + RHK->RHK_CODFOR

					If !((cAnoMes >= Substr(RHM->RHM_PERINI,3,4)+Substr(RHM->RHM_PERINI,1,2)) .and. Empty( RHM->RHM_PERFIM) .or. (cAnoMes >= Substr(RHM->RHM_PERINI,3,4)+Substr(RHM->RHM_PERINI,1,2)) .and. (cAnoMes <=  Substr(RHM->RHM_PERFIM,3,4)+Substr(RHM->RHM_PERFIM,1,2)))
						DbSkip()
						Loop					
					EndIf
					nVlrFunc := 0
					nVlrEmpr := 0
					lRet := fCalcPlano(3, RHM->RHM_TPFORN, RHM->RHM_CODFOR, RHM->RHM_TPPLAN, RHM->RHM_PLANO, dDataRef, RHM->RHM_DTNASC, @nVlrFunc, @nVlrEmpr, (cAliasSRA)->RA_FILIAL )
	            
					If lRet .and. Round(nVlrFunc,2) > 0 .or. Round(nVlrEmpr,2) > 0
						fGravaCalc("3", RHM->RHM_CODIGO, "1", RHM->RHM_TPFORN, RHM->RHM_CODFOR, RHM->RHM_TPPLAN, RHM->RHM_PLANO, cPDDAgr, nVlrFunc, nVlrEmpr )
					EndIf
					
					If lRet .and. Round(nVlrFunc,2) <= 0 .and. Round(nVlrEmpr,2) <= 0
						aAdd( aLog[2], Substr(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " - " + ;
							  			OemToAnsi( STR0021 ) + " - " + RHM->RHM_CODIGO ) //"Codigo 
                    EndIf
	
					DbSelectArea( "RHM" )
					DbSkip()
			
				EndDo

				DbSelectArea( "RHK" )
				DbSkip()
			EndDo

			// Gera log de calculo se nao houver plano do titular ativo para o Mes/Ano a calcular
			If ! lTemPlAtTi
				If Len( aLog[5] ) == 0 .or. Ascan( aLog[5], { |x| x == Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) } ) == 0
					aAdd( aLog[5], 	Substr( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) )
				EndIf
			EndIf

			// Calcular Reembolso e Co-participacao //
			DbSelectArea( "RHO" )
            //Cria indice temporario
			IndRegua( "RHO", cArqRHO, cIndKeyRHO, Nil, Nil, Nil, .F. )
			nIndexRHO	:= RHO->( RetIndex( ) ) + 1
			//Usa o indice temporario
			#IFNDEF TOP
				dbSetIndex( cArqRHO + OrdBagExt() )
			#ENDIF 
			dbSetOrder( nIndexRHO )
			DbSeek( (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT + cAnoMes, .F. )
			While RHO->( !Eof() ) .and. RHO->( RHO_FILIAL + RHO_MAT + RHO_COMPPG ) == (cAliasSRA)->( RA_FILIAL + RA_MAT ) + cAnoMes
				cTpLan := If( RHO->RHO_TPLAN == "1", "2", "3")
				fGravaCalc(RHO->RHO_ORIGEM, RHO->RHO_CODIGO, cTpLan, RHO->RHO_TPFORN, RHO->RHO_CODFOR, cSpcTpPLan, cSpcPlano, RHO->RHO_PD, RHO->RHO_VLRFUN, RHO->RHO_VLREMP, .T. )
				
				DbSelectArea( "RHO" )
				DbSkip()
	        EndDo
	        
        End Transaction 
        
		DbSelectArea( cAliasSRA )
		DbSkip()
	EndDo				
		
	If (Select( "QSRA" ) > 0)
		QSRA->(DbCloseArea())
	EndIf
	
	If lVersao101
		oSelf:SaveLog( STR0001+" - "+STR0008) //"Calculo da Folha de Pagamento"##"Termino do processamento"
	EndIf
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Apresenta com Log de erros                              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	fMakeLog(aLog,aTitle,,.T.,"CALPS"+cAnoMes,STR0019,"M","P",,.F.)  //"LOG de Calculo de Plano de Saude" 
	
	//Apaga registro temporario
	If File( cArqRHO + OrdBagExt() )
		fErase( cArqRHO + OrdBagExt() )
	Endif
	
	RHO->( RetIndex() )

Return

/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fGravaCalc		³Autor³  Mauricio Takakura³ Data ³17/10/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Gravacao do calculo                                         ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³CALPLANO                                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fGravaCalc(cOrigem, cCodDepAgr, cTipoLan, cTpForn, cCodForn, cTpPlan, cPlano, cPD, nVlrFun, nVlrEmp, lCopReemb )
	Local aArea		:= GetArea()
	Local lRHRTipo	:= RHR->( FieldPos( "RHR_TIPO" ) # 0 )
	
	Default lCopReemb := .F.	// Coparticipacao/Reembolso - Padrao eh False, pois esta var somente vira com True para regs da Tab. RHO

	DbSelectArea( "RHR" )
	DbSetOrder( 1 )
	DbSeek( SRA->RA_FILIAL + SRA->RA_MAT + 	cAnoMes + cOrigem + cCodDepAgr + cTipoLan + cTpForn + cCodForn + cTpPlan + cPlano + cPD, .F. )
	If Eof()
		RHR->( RecLock( "RHR" , .T. ) )
		RHR->RHR_FILIAL := SRA->RA_FILIAL
		RHR->RHR_MAT 	:= SRA->RA_MAT
	Else
		RHR->( RecLock( "RHR" , .F. ) )
	EndIf
	
	RHR->RHR_DATA 		:= dDataBase
	RHR->RHR_ORIGEM 	:= cOrigem
	RHR->RHR_CODIGO		:= cCodDepAgr
	RHR->RHR_TPLAN		:= cTipoLan
	RHR->RHR_TPFORN		:= cTpForn
	RHR->RHR_CODFORN	:= cCodForn
	RHR->RHR_TPPLAN		:= cTpPlan
	RHR->RHR_PLANO		:= cPlano
	RHR->RHR_PD			:= cPD

	// Qdo for informacao de Coparticipacao/Reembolso, deve-se somar os valores lancados na tabela RHO
	If lCopReemb
		RHR->RHR_VLRFUN	+= nVlrFun
		RHR->RHR_VLREMP	+= nVlrEmp
	Else
		RHR->RHR_VLRFUN	:= nVlrFun
		RHR->RHR_VLREMP	:= nVlrEmp
	EndIf

	RHR->RHR_COMPPG		:= cAnoMes 

	// Grava novo Campo RHR_Tipo = 1-Calculado
	If lRHRTipo
		RHR->RHR_TIPO := "1"
	EndIf

	MsUnlock()
	
	RestArea( aArea )

Return( .T. )


/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fDeleCalc 		³Autor³  Mauricio Takakura³ Data ³23/10/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Deletar o Calculo anterior da Competencia a Calcular        ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³CALPLANO                                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fDeleCalc()
	Local aArea := GetArea()
                          
	#IFDEF TOP
 		Local cQuery
 		Local cNameDB
 		Local cDelet
 		Local cSqlName := InitSqlName( "RHR" )
 		
 		
 			/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³O banco DB2 nao aceita o nome da tabela apos o comando DELETE			 ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
  		cNameDB	:= Upper(TcGetDb())
  		
		cQuery := "DELETE " 
				
		If TcSrvType() != "AS/400" .And. !( cNameDB $ "INFORMIX" ) 
			cDelet 		:= "RHR.D_E_L_E_T_ = ' ' " 
		ElseIf ( cNameDB $ "INFORMIX" )
	   		cDelet		:= cSqlName +  ".D_E_L_E_T_ = ' ' "
	   	Else		
			cDelet 		:= "RHR.@DELETED@ = ' ' "
		EndIf
              	   		
		If !( cNameDB $ "DB2_ORACLE_INFORMIX_POSTGRES" )
			cQuery += cSqlName
		EndIf
		
 		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³O Informix precisa do nome da tabela ao inves do Alias no comando DELETE³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If ( cNameDB $ "INFORMIX" )
			cQuery += " FROM " + cSqlName
		Else
			cQuery += " FROM " + cSqlName + " RHR"
			cSqlName := "RHR"
		EndIf

		cQuery += " WHERE " + cSqlName + ".RHR_FILIAL = '" + SRA->RA_FILIAL + "'"
		cQuery += " AND " + cSqlName + ".RHR_MAT = '" + SRA->RA_MAT + "'"
		cQuery += " AND " + cSqlName + ".RHR_COMPPG = '" + cAnoMes + "'" 
		cQuery += " AND " + cDelet 
		
		TcSqlExec( cQuery )

	#ELSE
	
		DbSelectArea( "RHR" )
		DbSetOrder( 1 )
		DbSeek( SRA->RA_FILIAL + SRA->RA_MAT + 	cAnoMes, .F. )
		While !Eof() .and. RHR->( RHR_FILIAL + RHR_MAT + RHR_COMPPG ) == SRA->RA_FILIAL + SRA->RA_MAT + 	cAnoMes
			RecLock( "RHR" , .F. )
			dbDelete()
			MsUnlock() 
			DbSkip()
		EndDo

	#ENDIF	
	
	RestArea( aArea )

Return( .T. )

/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fCalcPlano		³Autor³  Mauricio Takakura³ Data ³17/10/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Efetuar o Calculo e Retornar  apenas o valor                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³CALPLANO                                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fCalcPlano( nTipo, cTpForn, cCodForn, cTpPlan, cCodPlan, dDtRef, dDtNasc, nVlrFunc, nVlrEmpr, cFilProc )
	Local cTab
	Local cTpLogForn
	Local cTpLogPlano
	
	Local lRet 	:= .T.
	
	Local nLinha
	Local nLinTab
	Local nColVlr
	Local nColPorc
	Local nColTeto
	Local nBusca
	Local nValor
	Local nPercentual
	Local nTeto	

	If cTpForn == "1"		// Assistencia Medica 
	    If cTpPlan == "1"
			cTab := "S008"
		ElseIf cTpPlan == "2"
			cTab := "S009"
		ElseIf cTpPlan == "3"
			cTab := "S028"
		ElseIf cTpPlan == "4"
			cTab := "S029"
		EndIf
		cTpLogForn := OemToAnsi( STR0011 ) // "Assistência Medica" 
	Else					// Assistencia Odontologica 
	    If cTpPlan == "1"
			cTab := "S013"
		ElseIf cTpPlan == "2"
			cTab := "S014"
		ElseIf cTpPlan == "3"
			cTab := "S030"
		ElseIf cTpPlan == "4"
			cTab := "S031"
		EndIf
		cTpLogForn := OemToAnsi( STR0012 ) // "Assistência Odontologica" 
	EndIf

    //Ajuste para verificar se utiliza salario base ou salario incorporado
	If nSalCalc == 1
		If (SRA->RA_CATFUNC = "H")
			nBusca := SRA->RA_HRSMES * SRA->RA_SALARIO
		Else
			nBusca := nSalMes
		EndIf
	ElseIf nSalCalc == 2
		nBusca := nSalMes
	EndIf

	// Se for por Faixa Etaria, calcular a idade //
	If cTpPlan == "2" 
		nBusca := Year( dDtRef ) - Year( dDtNasc )
        If Month( dDtNasc ) > Month( dDtRef )
             nBusca--
		EndIf
  	EndIf
  	
	If cTpPlan == "1" .or. cTpPlan == "2"
	
		If nTipo == 1 // Titular 
			nColVlr 	:= 7
			nColPorc	:= 10
		ElseIf nTipo == 2 // Dependente
			nColVlr 	:= 8
			nColPorc	:= 11
		ElseIf nTipo == 3 // Agregado
			nColVlr 	:= 9
			nColPorc	:= 12
		EndIf

		nLinTab := 0
		If ( nLinha := fPosTab( cTab, cCodForn, "=", 13, cCodPlan, "=", 4, , , @nLinTab, lCarTabFol, cFilProc ) ) > 0
			If ( nLinha := fPosTab(cTab, cCodPlan,"=",4,nBusca,"<=",6,,nLinTab,,,cFilProc ) ) > 0

				nValor 		:= fTabela(cTab,nLinha,nColVlr,,cFilProc)
				nPercentual := fTabela(cTab,nLinha,nColPorc,,cFilProc) / 100
				nVlrFunc  	:= Round( nValor * nPercentual, 2 )		// Arredondamento para nao dar diferenca entre calculo e valor total do plano
				nVlrEmpr	:= nValor - nVlrFunc

			EndIf
		EndIf
		
		If cTpPlan == "1"
			cTpLogPlano := OemToAnsi( STR0014 ) //"Faixa Salarial" 
		ElseIf cTpPlan == "2" 
			cTpLogPlano := OemToAnsi( STR0015 ) //"Faixa Etaria" 
		EndIf

	ElseIf cTpPlan == "3"
		cTpLogPlano := OemToAnsi( STR0016 ) //"Valor Fixo" 
		If nTipo == 1 // Titular 
			nColVlr 	:= 6
			nColPorc	:= 9 
		ElseIf nTipo == 2 // Dependente
			nColVlr 	:= 7
			nColPorc	:= 10
		ElseIf nTipo == 3 // Agregado
			nColVlr 	:= 8
			nColPorc	:= 11
		EndIf

		nLinTab := 0
		If ( nLinha := fPosTab( cTab, cCodForn, "=", 12, cCodPlan, "=", 4, , , @nLinTab, lCarTabFol, cFilProc ) ) > 0
			If ( nLinha := fPosTab(cTab, cCodPlan,"=",4,,,,,nLinTab,,,cFilProc) ) > 0

				nValor		:= fTabela(cTab,nLinha,nColVlr,,cFilProc)
				nPercentual	:= fTabela(cTab,nLinha,nColPorc,,cFilProc)
				nVlrFunc	:= nPercentual
				nVlrEmpr	:= nValor - nPercentual

			EndIf
		EndIf
	ElseIf cTpPlan == "4"
		cTpLogPlano := OemToAnsi( STR0017 ) //"Porcentagem sobre Salario" 
		If nTipo == 1 // Titular 
			nColVlr 	:= 6
			nColPorc	:= 9 
			nColTeto	:= 10
		ElseIf nTipo == 2 // Dependente
			nColVlr 	:= 7
			nColPorc	:= 11
			nColTeto	:= 12
		ElseIf nTipo == 3 // Agregado
			nColVlr 	:= 8
			nColPorc	:= 13
			nColTeto	:= 14
		EndIf

		nLinTab := 0
		If ( nLinha := fPosTab( cTab, cCodForn, "=", 15, cCodPlan, "=", 4, , , @nLinTab, lCarTabFol, cFilProc ) ) > 0
			If ( nLinha := fPosTab(cTab, cCodPlan,"=",4,,,,,nLinTab,,,cFilProc) ) > 0

				// nValor eh o valor do plano de saude a pagar
				nValor		:= fTabela(cTab,nLinha,nColVlr,,cFilProc)

				nPercentual	:= fTabela(cTab,nLinha,nColPorc,,cFilProc) / 100
				nTeto		:= fTabela(cTab,nLinha,nColTeto,,cFilProc)

				// O valor a pagar do funcionario eh sobre o salario do mes
				nVlrFunc	:= ( nBusca * nPercentual )

				If nVlrFunc > nTeto
					nVlrFunc := nTeto
				EndIf

				nVlrEmpr := nValor - (If( nVlrFunc <= nTeto, nVlrFunc, nTeto )) 
			EndIf
		EndIf
	EndIf	 
	
	If nLinha == 0
		aAdd( aLog[1], Substr(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " - " + ;
						cTpLogForn + " - " +; //"Assistencia Medica" ou "Assistencia Odontologica"
						cTpLogPlano + " - " +; // "Faixa Salarial" ou "Faixa Etaria" ou "Valor Fixo" ou "Porcentagem sobre Salario"
						OemToAnsi(STR0010) + " " + cCodPlan  ) //"Codigo 
		lRet := .F.
	EndIf

	// Apos Primeira Carga, atualiza para .F. para nao carregar a cada funcionario
	lCarTabFol := .F.

Return( lRet )

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³AjustaSX1 ³ Autor ³Equipe RH              ³ Data ³02/04/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Ajusta Perguntas 											³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function AjustaSX1()

Local aArea		:= GetArea()
Local aHelp		:= {}
Local aRegs		:= {}
Local cPerg   	:= "GPCALPL" 

aHelp := {	'Informe "1" se deseja que a rotina',; 
			'efetue o cálcule do plano de saúde',;
			'sobre o salário base ou "2" para ',;
			"efetuar o cálculo sobre o salário",;
			"incorporado."}
Aadd( aRegs, {cPerg,"10","Calcular sobre salário ?" ,"Calcular sobre salário ?","Calcular sobre salário ?"               ,"mv_cha","N"   ,1       ,0      ,0     ,"C","naovazio"       ,"mv_par10" ,"1-Base"   ,"1-Base"     ,"1-Base"      ,""   ,""		,"2-Incorporado"		,"2-Incorporado"		,"2-Incorporado"		,""	,""		,""		,""		,""		,""	,""		,""		,""	,""		,""		,""		,""		,""		,""	,""		,""	,""	,"S", aHelp, aHelp, aHelp} ) 
ValidPerg( aRegs, cPerg, .T.) // Incluir perguntas 

RestArea( aArea )

Return( Nil )

