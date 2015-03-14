#INCLUDE "RTMSR15.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR15  ³ Autor ³Vitor Raspa            ³ Data ³ 21.Ago.06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Plano de Viagem                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR15                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gestao de Transporte                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RTMSR15()

Local titulo   := STR0001 //"Impressao do Plano de Viagem"
Local cString  := "DTQ"
Local wnrel    := "RTMSR15"
Local cDesc1   := STR0002 //"Este programa ira listar o Plano de Viagem das viagens selecionadas"
Local cDesc2   := ""
Local cDesc3   := ""
Local tamanho  := "M"
Local nLimite  := 132

Private NomeProg := "RTMSR15"
Private aReturn  := {STR0003,1,STR0004,2, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private cPerg    := "RTMR15"
Private nLastKey := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Filial Origem De                      ³
//³ mv_par02        	// Filial Origem Ate  	                 ³
//³ mv_par03        	// Viagem De                             ³
//³ mv_par04        	// Viagem Ate         	                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR15Imp(@lEnd,wnRel,titulo,tamanho,nLimite)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR15Imp³ Autor ³Vitor Raspa            ³ Data ³ 21.Ago.06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR15			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTMSR15Imp(lEnd,wnRel,cTitulo,nTamanho,nLimite)

Local nLin     := 80
Local cDesc1   := ''
Local cDesc2   := ''
Local lContrat := .F.
Local cObsVge  := ''
Local nLinObs  := 0
Local nAux     := 0
Local cTMSOPdg := SuperGetMV( 'MV_TMSOPDG',, '0' )
Local aSentido := {}

Private m_pag  := 1

DTQ->(DbSetOrder(2)) //-- DTQ_FILIAL+DTQ_FILORI+DTQ_VIAGEM+DTQ_ROTA
DTQ->(MsSeek(xFilial('DTQ') + MV_PAR01 + MV_PAR02, .T.))
SetRegua(LastRec())

While !DTQ->(EoF()) .And. DTQ->DTQ_FILIAL == xFilial('DTQ') .And.;
		DTQ->DTQ_FILORI <= MV_PAR03 .And. DTQ->DTQ_VIAGEM <= MV_PAR04

	IncRegua()
	If Interrupcao(@lEnd)
		Exit
	Endif
	
	If nLin > 60
		cDesc1 := STR0005 + DTQ->DTQ_FILORI + '/' + DTQ->DTQ_VIAGEM//-- 'Numero da Viagem ..: '
		If DTR->(FieldPos('DTR_PRCTRA')) > 0
			cDesc2 := STR0006 + Posicione('DTR',1,xFilial('DTR') + DTQ->(DTQ_FILORI+DTQ_VIAGEM), 'DTR_PRCTRA') //-- 'Proc. de Transporte:'
		EndIf
		nLin := Cabec( cTitulo, cDesc1, cDesc2, NomeProg, nTamanho ) + 1
	EndIf
	
	@ nLin,000 PSay Posicione('SX3', 2, 'DA8_COD', 'X3Titulo()' )
	@ nLin,015 PSay DTQ->DTQ_ROTA
	VerLin(@nLin,1)
	@ nLin,000 PSay Posicione('SX3', 2, 'DA8_DESC', 'X3Titulo()' )
	@ nLin,015 PSay Posicione('DA8', 1, xFilial('DA8') + DTQ->DTQ_ROTA, 'DA8_DESC')
	@ nLin,060 PSay Posicione('SX3', 2, 'DA8_SERVIC', 'X3Titulo()' )
	@ nLin,075 PSay	Posicione('DA8',1,xFilial('DA8') + DTQ->DTQ_ROTA, 'DA8_SERVIC' ) + ' - ' +;
					Tabela("L4", DA8->DA8_SERVIC, .F.)
	VerLin(@nLin,2)

	@ nLin,000 PSay PadC(STR0007,132,"=") //-- ' V E I C U L O S '
	VerLin(@nLin,1)
	@ nLin,000 PSay STR0008 //-- 'Veiculo   Nome             Cor                   Tipo                       Placa     Cidade           UF  Ano'
	VerLin(@nLin,1)
	DTR->(dbSetOrder(1))
	DTR->(MsSeek(xFilial("DTR") + DTQ->(DTQ_FILORI+DTQ_VIAGEM)))
	Do While !DTR->(Eof()) .And. DTR->DTR_FILIAL+DTR->DTR_FILORI+DTR->DTR_VIAGEM == xFilial('DTR')+DTQ->(DTQ_FILORI+DTQ_VIAGEM)
		//-- Veiculo Principal
		If DA3->(MsSeek(xFilial()+DTR->DTR_CODVEI))
		
			//-- Verifica a Existencia de Contrato de Carreteiro para a Viagem...
			If DA3->DA3_FROVEI <> '1'
				DTY->(DbSetOrder(2)) //--DTY_FILIAL+DTY_FILORI+DTY_VIAGEM+DTY_NUMCTC 
				If DTY->(MsSeek(xFilial('DTY') + DTQ->(DTQ_FILORI+DTQ_VIAGEM)))
					lContrat := .T.
				Else
					lContrat := .F.
				EndIf
			Else
				lContrat := .F.
			EndIF

			@ nLin,000 PSay	DA3->DA3_COD + Space(02) +;
							PadR( Tabela( 'M6', DA3->DA3_MARVEI, .F. ), 20 ) + Space(02) +;
							PadR( Tabela( 'M7', DA3->DA3_CORVEI, .F. ), 20 ) + Space(02) +;
							PadR( TMSTipoVei( DTR->DTR_CODVEI ), 25 ) + Space(02) +;
							DA3->DA3_PLACA + Space(02) +;
							DA3->DA3_MUNPLA + Space(02) +;
							DA3->DA3_ESTPLA + Space(02) +;
							DA3->DA3_ANOFAB
		EndIf
		//-- 1.o Reboque
		If !Empty(DTR->DTR_CODRB1) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB1))
			VerLin(@nLin,1)
			@ nLin,000 PSay	DA3->DA3_COD + Space(02) +;
							PadR( Tabela( 'M6', DA3->DA3_MARVEI, .F. ), 20 ) + Space(02) +;
							PadR( Tabela( 'M7', DA3->DA3_CORVEI, .F. ), 20 ) + Space(02) +;
							PadR( TMSTipoVei( DTR->DTR_CODRB1 ), 25 ) + Space(02) +;
							DA3->DA3_PLACA + Space(02) +;
							DA3->DA3_MUNPLA + Space(02) +;
							DA3->DA3_ESTPLA + Space(02) +;
							DA3->DA3_ANOFAB
		EndIf
	    //-- 2.o Reboque
		If !Empty(DTR->DTR_CODRB2) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB2))
			VerLin(@nLin,1)
			@ nLin,000 PSay	DA3->DA3_COD + Space(02) +;
							PadR( Tabela( 'M6', DA3->DA3_MARVEI, .F. ), 20 ) + Space(02) +;
							PadR( Tabela( 'M7', DA3->DA3_CORVEI, .F. ), 20 ) + Space(02) +;
							PadR( TMSTipoVei( DTR->DTR_CODRB2 ), 25 ) + Space(02) +;
							DA3->DA3_PLACA + Space(02) +;
							DA3->DA3_MUNPLA + Space(02) +;
							DA3->DA3_ESTPLA + Space(02) +;
							DA3->DA3_ANOFAB
		EndIf					
		DTR->(dbSkip())
	EndDo

	VerLin(@nLin,1)	
	@ nLin,000 PSay PadC(STR0009,132,"=") //-- ' M O T O R I S T A '
	VerLin(@nLin,1)
	@ nLin,000 PSay STR0010 //-- 'Nome                                      Endereco                                  Cidade           UF  CNH/PGU'
	VerLin(@nLin,1)	
	DUP->(DbSetOrder(1))
	DUP->(MsSeek(xFilial("DUP") + DTQ->(DTQ_FILORI+DTQ_VIAGEM)))
	While DUP->(!Eof()) .And. DUP->(DUP_FILIAL+DUP_FILORI+DUP_VIAGEM) == xFilial('DUP')+DTQ->(DTQ_FILORI+DTQ_VIAGEM)
		@ nLin,000 PSay	Substr(DA4->DA4_NOME,1,40) +  Space(02) +; 
						Substr(DA4->DA4_END,1,40) + Space(02) +;
						Substr(DA4->DA4_MUN,1,20) + Space(02) +; 
						DA4->DA4_EST + Space(02) +; 
						DA4->DA4_NUMCNH
		VerLin(@nLin,1)
		DUP->(dbSkip())
	EndDo

	@ nLin,000 PSay PadC(STR0019,132,"=") //-- ' A T I V I D A D E S '
	VerLin(@nLin,1)
	@ nLin,000 PSay STR0020 //-- 'Ordem  Ativid.  Desc. Tarefa'
	VerLin(@nLin,1)
	DTW->(DbSetOrder(1))
	DTW->(MsSeek(xFilial('DTW') + DTQ->(DTQ_FILORI+DTQ_VIAGEM)))
	While !DTW->(EoF()) .And. DTW->(DTW_FILIAL+DTW_FILORI+DTW_VIAGEM) == xFilial('DTW') + DTQ->(DTQ_FILORI+DTQ_VIAGEM)
		@ nLin,000 PSay	DTW->DTW_SEQUEN + Space(02) +;
						DTW->DTW_ATIVID + " - " + Tabela("L3",DTW->DTW_ATIVID,.F.)
		VerLin(@nLin,1)
		DTW->(DbSkip())
	EndDo

	If cTMSOPdg <> '0'
		DEN->(DbSetOrder(1))
		If DEN->(MsSeek(xFilial('DEN') + DTQ->(DTQ_FILORI+DTQ_VIAGEM)))
			@ nLin,000 PSay PadC(STR0011,132,"=") //-- " P O N T O S   D E   A P O I O "
			VerLin(@nLin,1)
			@ nLin,000 PSay STR0012 //-- 'Previsao          Posto                                           Endereco                                Telefone        Vl. Diesel'
			VerLin(@nLin,1)
			While !DEN->(EoF()) .And. DEN->(DEN_FILIAL+DEN_FILORI+DEN_VIAGEM) == xFilial('DEN') + DTY->(DTY_FILORI+DTY_VIAGEM)
				SA2->(DbSetOrder(1))
				SA2->(MsSeek(xFilial('SA2') + DEN->(DEN_CODFOR+DEN_LOJFOR)))
				@ nLin,000 PSay	DtoC(DEN->DEN_DTPREV) + ' - ' + Transform(DEN->DEN_HRPREV, '@R 99:99') + Space(02) +;
								DEN->DEN_CODFOR + '/' + DEN->DEN_LOJFOR + ' - ' + IIF(Len(DEN->DEN_CODFOR) > 6, Left(SA2->A2_NOME, 30), Left(SA2->A2_NOME, 34)) + Space(02) +;
								Left(SA2->A2_END, 38) + Space(02) +;
								Left(SA2->A2_TEL, 14) + Space(07) +;
								Transform(DEN->DEN_VALCOM, '@E 9.999')
				VerLin(@nLin,1)
				DEN->(DbSkip())
			EndDo
			VerLin(@nLin,1)
			@ nLin,000 PSay '*' + STR0013 // "Os precos dos combustiveis estao em vigor na data/hora da impressao do documento, porem estao sujeitos a alteracao."
		EndIf
	EndIf

	DU2->(DbSetOrder(1))
	If DU2->(MsSeek(xFilial('DU2') + DTQ->DTQ_ROTA))
		VerLin(@nLin,1)	
		@ nLin,000 PSay PadC(STR0017,132,"=") //-- ' P R A C A S   D E   P E D A G I O '
		VerLin(@nLin,1)
		@ nLin,000 PSay STR0018 //-- 'Seq. Pdg.  Rodovia                                                 KM  Municipio        Sentido         Vlr. Eixo    Vlr. Veiculo'
		VerLin(@nLin,1)	
		While DU2->(!EoF()) .And. DU2->(DU2_FILIAL + DU2_ROTA) == xFilial('DU2') + DTQ->DTQ_ROTA
			If DU2->(FieldPos('DU2_SENTID')) > 0
				aSentido := RetSx3Box( Posicione('SX3', 2, 'DU2_SENTID', 'X3CBox()' ),,, Len(DU2->DU2_SENTID) )
				nAux := AScan( aSentido, {|x| DU2->DU2_SENTID $ X[2]} )
			EndIf
			@ nLin,000 PSay	PadL(DU2->DU2_SEQPDG,9) + Space(02) + ;
							DU2->DU2_CODROD + ' - ' + Posicione('DTZ',1,xFilial('DTZ') + DU2->DU2_CODROD, 'DTZ_NOMROD') + Space(02) +;
							Transform(DU2->DU2_KM, '@E 99999.9') + Space(02) +;
							Posicione('DU0', 1, xFilial('DU0') + DU2->(DU2_CODROD + DU2_SEQPDG), 'DU0_MUNPDG') + Space(02) +;
							IIF(DU2->(FieldPos('DU2_SENTID')) > 0, PadR(aSentido[nAux,3], 9), PadC('-',9)) + Space(02) + ;
							Transform(Posicione('DU0', 1, xFilial('DU0') + DU2->(DU2_CODROD + DU2_SEQPDG), 'DU0_VALEIX'), '@E 999,999,999.99') + Space(02) +;
							Transform(Posicione('DU0', 1, xFilial('DU0') + DU2->(DU2_CODROD + DU2_SEQPDG), 'DU0_VALVEI'), '@E 999,999,999.99')
			VerLin(@nLin,1)
			DU2->(dbSkip())
		EndDo
	EndIf
		
	If lContrat
		@ nLin,000 PSay PadC(STR0014,132,'=') //-- " C O N T R A T O   D E   C A R R E T E I R O "
		VerLin(@nLin,1)
		@ nLin,000 PSay STR0015 //-- "Contrato  Emissao           Proprietario                                    Vlr. Frete    Vlr. Pedagio      Vlr. Adto."
		VerLin(@nLin,1)
		While !DTY->(EoF()) .And. DTY->(DTY_FILIAL+DTY_FILORI+DTY_VIAGEM) == xFilial('DTY') + DTQ->(DTQ_FILORI+DTQ_VIAGEM)
			SA2->(DbSetOrder(1))
			SA2->(MsSeek(xFilial('SA2') + DTY->(DTY_CODFOR+DTY_LOJFOR)))
        	@ nLin,000 PSay	PadR(DTY->DTY_NUMCTC,08) + Space(02) +;
							DtoC(DTY->DTY_DATCTC) + ' - ' + Transform(DTY->DTY_HORCTC, '@R 99:99') + Space(02) +;
							DTY->(DTY_CODFOR + '/' + DTY_LOJFOR) + ' - ' + Left(SA2->A2_NOME, IF(Len(DTY->DTY_CODFOR) > 6, 26, 30)) + Space(02) +;
							Transform(DTY->DTY_VALFRE, '@E 999,999,999.99') + Space(02) +; 
							Transform(DTY->DTY_VALPDG, '@E 999,999,999.99') + Space(02) +; 
							Transform(DTY->DTY_ADIFRE, '@E 999,999,999.99')
			VerLin(@nLin,1)
			DTY->(DbSkip())
		EndDo
	EndIf

	@ nLin,000 PSay PadC(STR0016,132,'=') //-- " O B S E R V A C O E S "
	VerLin(@nLin,1)
	cObsVge := If(!Empty(DTQ->DTQ_CODOBS), MSMM(DTQ->DTQ_CODOBS,132,,,,,,'DTQ','DTQ_CODOBS'), '')
	nLinObs := MLCount(cObsVge,132)
	@ nLin,000 PSAY MemoLine(cObsVge,132,1)
	VerLin(@nLin,1)
	For nAux := 2 To nLinObs
		@ nLin,000 PSAY Memoline(cObsVge,132,nAux)
		VerLin(@nLin,1)
	Next nAux

	nLin := 80
	DTQ->(DbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³VerLin    ³ Autor ³Patricia A. Salomao    ³ Data ³27.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Soma Linha                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ VerLin(ExpN1,ExpN2)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpN1 - No. da Linha atual                                 ³±±
±±³          ³ ExpN2 - No. de Linhas que devera ser somado                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR06			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VerLin(Li,nSoma)

Li+=nSoma

If Li > 70
	Li:=1
EndIf

Return
