#INCLUDE "PROTHEUS.CH"
#INCLUDE "ATUACUM.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ATUACUM  ³ Autor   ³ IP Rh - Inovacao                   ³ Data ³ 19/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualizacao de criterios e sequencias dos Acumuladores na tabela SRD      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³   BOPS/FNC   ³  Motivo da Alteracao                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³          ³              ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function ATUACUM()

Local aArea			:= GetArea()
Local aSays			:= {}		// array com as mensagem para visualizacao na caixa de Processamento
Local aButtons		:= {}		// botoes da caixa de processamento

Local cMens

Local nOpca			:= 0

Private cCadastro	:= OemToAnsi(STR0001) // "Atualização de Critérios e Sequencias dos Acumuladores"

Begin Sequence

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Janela de Processamento do Fechamento                         ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	AADD(aSays, OemToAnsi(STR0002) )	// "Este programa realiza a gravação dos codigos dos criterios e sequencias "
	AADD(aSays, OemToAnsi(STR0003) )	// "nos lançamentos de Histórico de Movimentos conforme os códigos dos "
	AADD(aSays, OemToAnsi(STR0004) )	// "relacionamentos dos critérios e períodos do Cadastro de Periodos."

	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,;
								 IF(GpConfOk( OemToAnsi(STR0005), OemToAnsi(STR0006) ),; // "A atualização poderá ser demorada. Deseja continuar?" ### "Aten‡„o"
								 		FechaBatch(),;
								 		nOpca:=0) ;
							 } ;
					} ) 

	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

	FormBatch( cCadastro, aSays, aButtons )
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Chamada do Processamento                                     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF nOpca == 1

		ProcGpe({|lEnd| U_ATUACUMProcessa() },,,.T.)

	Endif 
	
End Sequence 

RestArea( aArea )

Return( NIL )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³GPM012Processa³ Autor ³IP RH Inovacao         ³ Data ³19/04/2012³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Processamento para Gravacao dos criterios/sequencias            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³ATUACUMProcessa() 									    		³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³                                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ATUACUM()	                                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
User Function ATUACUMProcessa() 

Local cAliasQry		:= GetNextAlias()
Local cWhere		:= ""
Local cSequencia	:= ""						// Sequencia de acumulacao da verba 
Local nPosCriter 	:= 0
Local lExecutou 	:= .F.
Local cQuery 		:= ""
Local cFilBsc 		:= cFilAnt
Local cFilSRM 		:= cFilAnt
Local cFilRCH 		:= cFilAnt
Local nFilBsc		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as filiais em array o processamento                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEmpresas := FwAllFilial(,,,.F.) // seleção de todas filiais da empresa corrente

dbSelectArea("RCH")
dbSetOrder(RetOrder("RCH","RCH_FILIAL+RCH_PROCES+RCH_ROTEIR+RCH_PER+RCH_NUMPAG"))

dbSelectArea("SRM")
dbSetOrder(RetOrder("SRM","RM_FILIAL+RM_PROCES+RM_CALCULO+RM_VERBA"))

GPProcRegua(SRM->(LastRec())*Len(aEmpresas)) // Carrega o numero de Filias X o No. de Verbas no roteiro

For nFilBsc := 1 to Len(aEmpresas)

	cFilBsc := aEmpresas[nFilBsc]
	cFilSRM := xFilial("SRM",cFilBsc )
	cFilRCH := xFilial("RCH",cFilBsc )
		
	If SRM->( dbSeek( cFilSRM ) )

		While SRM->(!Eof()) .And. cFilSRM == SRM->RM_FILIAL

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Movimenta Regua de Processamento                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			GPIncProc( SRM->RM_FILIAL + " - " + SRM->RM_PROCES + " - " + SRM->RM_CALCULO + " - " + SRM->RM_VERBA,, .T. )
		
			If SRM->RM_GERAACU == '1'	// Gera Acumulador
		
				If RCH->( dbSeek( cFilRCH + SRM->RM_PROCES + SRM->RM_CALCULO ) )
					While RCH->(!Eof()) .And. cFilRCH + SRM->RM_PROCES + SRM->RM_CALCULO == RCH->RCH_FILIAL + RCH->RCH_PROCES + RCH->RCH_ROTEIR
			
						// Verifica se possui o codigo da criterio do Verbas por processo na tabela de Periodos
						If  !Empty(SRM->RM_CODCRI) .And. SRM->RM_CODCRI $ AllTrim(RCH->RCH_CRITER)
		
							cWhere := "% "
							cWhere +=     " SRD.RD_FILIAL = '" 	+ cFilBsc + "'"
							cWhere += " AND SRD.RD_PROCES = '"	+ RCH->RCH_PROCES + "' "
							cWhere += " AND SRD.RD_ROTEIR = '"	+ RCH->RCH_ROTEIR + "' "	
							cWhere += " AND SRD.RD_PD = '"		+ SRM->RM_VERBA + "' "
							cWhere += " AND SRD.RD_PERIODO = '"	+ RCH->RCH_PER+ "' "
							cWhere += " AND SRD.RD_SEMANA = '"	+ RCH->RCH_NUMPAG + "' "
							cWhere += " AND SRD.RD_CRITER = '"	+ Space(TAMSX3("RD_CRITER")[1]) + "' "
							cWhere += " AND SRD.RD_SEQUE = '"	+ Space(TAMSX3("RD_SEQUE")[1]) + "' %"
																	
							BeginSql alias cAliasQry
							   	SELECT R_E_C_N_O_ 
							   	FROM  %table:SRD% SRD
								WHERE %exp:cWhere% AND SRD.%notDel%
							EndSql	
							
							If (cAliasQry)->(!Eof())					
		
								// Encontra a posicao do codigo do criterio para buscar sequencia
								If ( nPosCriter := AT(AllTrim(SRM->RM_CODCRI),RCH->RCH_CRITER) ) > 0
		
									cSequencia := SubStr(RCH->RCH_SEQUE,nPosCriter,2)
		
									cQuery := "UPDATE "+RetSqlName("SRD")+" "
									cQuery += "SET RD_CRITER = '" + SRM->RM_CODCRI + "' , RD_SEQUE = '" + cSequencia + "' "
									cQuery += "WHERE "

									cQuery +=     " RD_FILIAL = '" 	+ cFilBsc + "'"
									cQuery += " AND RD_PROCES = '"	+ RCH->RCH_PROCES + "'"
									cQuery += " AND RD_ROTEIR = '"	+ RCH->RCH_ROTEIR + "'"	
									cQuery += " AND RD_PD = '"		+ SRM->RM_VERBA + "'"
									cQuery += " AND RD_PERIODO = '"	+ RCH->RCH_PER+ "'"
									cQuery += " AND RD_SEMANA = '"	+ RCH->RCH_NUMPAG + "'"
									cQuery += " AND RD_CRITER = '"	+ Space(TAMSX3("RD_CRITER")[1]) + "'"
									cQuery += " AND RD_SEQUE = '"	+ Space(TAMSX3("RD_SEQUE")[1]) + "'"	
									cQuery += " AND D_E_L_E_T_ = ' '"	
							   		TcSqlExec(cQuery)
							   		
									lExecutou := .T.
									
								Endif
		                    	
							Endif
							
							(cAliasQry)->(dbCloseArea())
			        
				        Endif
		
						RCH->(dbSkip())
					Enddo
				Endif
			Endif
		
			SRM->(dbSkip())
		Enddo

	Endif

Next

If lExecutou
	MsgAlert( STR0007, OemToAnsi(STR0006) ) // "Atualização realizada com sucesso!" ### "Atenção"
Endif

Return( Nil )