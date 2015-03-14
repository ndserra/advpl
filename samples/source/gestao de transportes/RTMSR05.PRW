#INCLUDE "RTMSR05.ch"
#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTMSR05  ³ Autor ³ Robson Alves          ³ Data ³20.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao do Romaneio de Carga.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR05()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Antonio C F ³20.05.02³      ³ReProgramacao                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RTMSR05()

Local cDesc1     := STR0001 //"Este programa ir  emitir o Romaneio de Carga."
Local cDesc2     := ""
Local cDesc3     := ""
Local cString    := "DUD"
Local Tamanho    := "M"
Local Limite     := 130
Local Titulo     := STR0002 //"Romaneio de Carga"
Local Wnrel

Private aReturn  := { STR0003, 1,STR0004, 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private nomeprog := "RTMSR05"
Private nLastKey := 0
Private cPerg    := "RTMR05"

If	DUD->(FieldPos('DUD_SEQIMP'))>0
	RtmsR05SX1()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o grupo de perguntas.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg, .F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                  ³
//³ mv_par01            // Filial De      ?                               ³
//³ mv_par02            // Filial Ate     ?                               ³
//³ mv_par03            // Viagem De      ?                               ³
//³ mv_par04            // Viagem Ate     ?                               ³
//³ mv_par05            // Documentos Carregados ?                        ³
//³ mv_par06            // Impressao/Reimp.      ?                        ³
//³ mv_par07            // Sequencia De   ?                               ³
//³ mv_par08            // Sequencia Ate  ?                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "RTMSR05" // Nome Default do relatorio em Disco.
wnrel:=SetPrint(cString, Wnrel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)

If nLastKey == 27
	Return Nil
Endif

SetDefault(aReturn, cString)

If nLastKey == 27
	Return Nil
Endif

RptStatus({|lEnd| RTmsr05Imp(@lEnd, wnRel, Titulo, Tamanho, Limite)}, STR0005) //"Imprimindo o Romaneio de Carga."

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RtmsR05Imp³ Autor ³ Robson Alves          ³ Data ³20.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime o Romaneio de cargas.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RtmsR05Imp(ExpL1, ExpC2, ExpC3, ExpC4, ExpN5, ExpN6)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Abandona a impressao(.T. = Sim/.F. = Nao).         ³±±
±±³          ³ ExpC2 = Retorno da funcao SetPrint.                        ³±±
±±³          ³ ExpC3 = Titulo do relatorio.                               ³±±
±±³          ³ ExpN4 = Tamanho do relatorio.                              ³±± 
±±³          ³ ExpN5 = Tamanho do relatorio.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Antonio C F ³20.05.02³      ³ReProgramacao                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTmsr05Imp(lEnd, wnRel, Titulo, Tamanho, Limite)

Local cDesc1, nColTam1, nColTam2
Local cFilOri    := ''
Local cViagem    := ''
Local aCabecalho := {}
Local aImprimir  := {}
Local nContCol   := 0
Local nContLin   := 0
Local aDestino   := {}
Local aDescarga  := {}
Local nA         := 0
Local nB         := 0 
Local nC         :=0
Local nZ         := 0
Local nCol       := 0
Local cFilDes    := ""
Local cFilDca    := ""
Local lEndereco  := (GetMV("MV_LOCALIZ") == "S")  // Se for pelo Endereco

Local cFilOriDe  := mv_par01 
Local cFilOriAte := mv_par02
Local cViagemDe  := mv_par03 
Local cViagemAte := mv_par04
Local cDocCarreg := mv_par05   // 1-Sim / 2-Nao / 3-Ambas
Local cSeek      := ''
Local cSeqImp    := ''
Local cParte     := ''
Local cDesc4     := ''
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis utilizadas para Impressao do cabecalho e rodape.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cbtxt  := Space(10)
Private cbcont := 0
Private Li     := 80
Private m_pag  := 1
Private nTipo  := aReturn[4]
Private cTraco := Replicate("=", (Limite - If(lEndereco, 1, 0)))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Layout do Relatorio.                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
                       Romaneio de Carga - Filial de Origem: 01  
Expresso Aracatuba  	                                                   Emissao: 27/02/02 - 17:40:55
Veiculo: 01VLV00020 - VOLVO Tipo: Semi-Pesado (Truck)Placa : VLV01010 - Cidade Placa: SAO PAULO - SP
Motorista: 01000001 - JOAO   Chn : KDKDKDKKDK  
Observacoes:  
                                                                                              
Valor Adto.: 0,00                             Telerisco:                                 Viagem: 000002
 =================================================================================
 |Destino     | 01| 01| 01| 01| 01| 01| 01| 01| 01| 01| 01| 01| 01| 
 =================================================================================
 |Descarga    | 01| 01| 01| 01| 01| 01| 01| 01| 01| 01| 01| 01| 01| 
 =================================================================================
 =================================================================================
 1o Parte   |2o Parte   |3o Parte   |Encerramento |Lacre                         |
 =================================================================================
 =================================================================================
 | 01 104697/CTR | 01 999999/CTR | 01 999999/CTR | 01 999999/CTR | 01 999999/CTR |
 =================================================================================
 |               |               |               |               |               |
 =================================================================================
 |               |               |               |               |               |
 =================================================================================
 |               |               |               |               |               |
 =================================================================================
 |               |               |               |               |               |
 =================================================================================
 |               |               |               |               |               |
 =================================================================================
 |               |               |               |               |               |
 =================================================================================
 |               |               |               |               |               |
 =================================================================================
 |               |               |               |               |               |
 =================================================================================
 |               |               |               |               |               |
 =================================================================================


 ________________________             _____________________________
 Conferente	              		      Arrumador


 ________________________             _____________________________
 Ajudante					          Ajudante
*/

DTQ->(DbSetOrder(2))  // DTQ_FILIAL+DTQ_FILORI+DTQ_VIAGEM
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le o DUD(Viagem).                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("DUD")
dbSetOrder(2)   // DUD_FILIAL+DUD_FILORI+DUD_VIAGEM+DUD_FILDOC+DUD_DOC+DUD_SERIE

MsSeek(xFilial("DUD") + cFilOriDe + cViagemDe,.T.)

SetRegua(RecCount())

While !Eof() .And. (DUD_FILIAL == xFilial("DUD")) .And. (DUD_FILORI <= cFilOriAte) .And. (DUD_VIAGEM <= cViagemAte)
	
	nContCol := 0 // Zera variavel usada para contar as colunas impressas.
	nContLin := 0 // Zera variavel usada para contar as linhas impressas.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le o DUN(Cadastro de Zonas por Rota).                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DTQ->(MsSeek(xFilial("DTQ") + DUD->(DUD_FILORI + DUD_VIAGEM)))
	
	cObserv   := MSMM(DTQ->DTQ_CODOBS)
	
	dbSelectArea("DUN")
	dbSetOrder(1)
	MsSeek(xFilial("DUN") + DTQ->DTQ_ROTA)
	
	aDestino  := {}
	aDescarga := {}

	While !Eof() .And. (DUN->(DUN_FILIAL + DUN_ROTEIR) == (xFilial("DUN") + DTQ->DTQ_ROTA))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona ao array as Filiais de Destino.                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFilDes := DUN->DUN_FILDES

		If Ascan(aDestino, cFilDes) == 0
			Aadd(aDestino, cFilDes)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona ao array as Filiais de Descarga.                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFilDca := DUN->DUN_FILDCA
	
		If Ascan(aDescarga, cFilDca) == 0
			Aadd(aDescarga, cFilDca)
		EndIf
		
		dbSelectArea("DUN")
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta no array(aCabecalho) o restante do layout do relatorio.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RtmsR05Cabec(@aCabecalho, Titulo, cObserv)
	
	DbSelectArea("DUD")
	
	if (len(aCabecalho) <= 0)
		DbSkip()
		Loop
	endif
	
	If	DUD->(FieldPos('DUD_SEQIMP'))>0 .And. mv_par06 == 1 .And. DUD->DUD_FILIAL + DUD->DUD_FILORI + DUD->DUD_VIAGEM != cSeek
		cSeqImp := StrZero(0,Len(DUD->DUD_SEQIMP))
		R05SeqImp(DUD->DUD_FILIAL,DUD->DUD_FILORI,DUD->DUD_VIAGEM, @cSeek, @cSeqImp )
	EndIf

	cFilOri := DUD->DUD_FILORI
	cViagem := DUD->DUD_VIAGEM
	
	cDesc1 := STR0021 + cFilOri + " " + cViagem  // Viagem: ## ######
	
	If lEndereco
		RtmsR05End(@aImprimir, cFilOri, cViagem, cDocCarreg, @lEnd, cSeqImp )
	Else
		RtmsR05Doc(@aImprimir, cFilOri, cViagem, cDocCarreg, @lEnd, cSeqImp )
	EndIf
	
    nColTam1   := If(len(aImprimir) > 0, len(aImprimir[1][1]), 14)
    nColTam2   := If(len(aImprimir) > 0, ((41 + If(lEndereco, 21, 0)) - nColTam1), 10)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a impressao foi cancelada.                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lEnd
		@Prow()+1,000 PSay STR0006 //"CANCELADO PELO OPERADOR"
		Exit
	EndIf
	
	cParte := ''
	li     := 80
	
	For nZ := 1 to len(aImprimir)
		
		If li > 48 .Or. Iif(DUD->(FieldPos('DUD_SEQIMP'))>0 .And. mv_par06==2,cParte!=aImprimir[nZ,3],.F.)
			nCol   := 0

			If	DUD->(FieldPos('DUD_SEQIMP'))>0
				If	mv_par06 == 1
					cDesc4 := ' Parte: '+cSeqImp
				ElseIf mv_par06 == 2 .And. !Empty(aImprimir[nZ,3])
					cParte := aImprimir[nZ,3]
					cDesc4 := ' Parte: '+aImprimir[nZ,3]
				EndIf
			EndIf

			Cabec(Titulo, cDesc1+cDesc4, "", NomeProg, Tamanho)

			For nA := 1 to len(aCabecalho)
				@ Li++, 0 PSay aCabecalho[nA]
			Next
			++Li
			R05ImpReg(aDestino, aDescarga, DUD->DUD_FILORI, DUD->DUD_VIAGEM)
			nContLin := 0
			nContCol := 0
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Quando o contador chegar a 4, a coluna eh fechada e a impressao       ³
		//³continua na proxima linha.                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if empty(nCol)
			@ Li, nCol  PSay "|"
			nCol := PCol()
		endif
		
		@ Li, nCol  PSay aImprimir[nZ][1] + "|" + aImprimir[nZ][2] + space(nColTam2-Len(aImprimir[nZ][2])) + "|" // Imprime a coluna.
		nContCol += 2 // Soma 2 na variavel usada para contar as colunas.(Obs.: As colunas sao impressas de 2 em 2).
		
		If nContCol >= 6
			Li++
			@ Li, 00 PSay cTraco
			Li++
			nContCol := 0       // Zera a variavel usada para contar as colunas.
			nContLin += 1       // Soma 1 na variavel usada para contar as linhas.
			nCol     := 0
		Else
			nCol  := PCol()   // Obtem o numero da coluna.
		EndIf
		
		If	R05Quebra(aImprimir,nZ)

			If Li != 80
				If nContCol != 0 // As colunas do relatorio nao estao completas.
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Completa o quadro do relatorio com as colunas que faltaram.           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nA := 1 To ((If(lEndereco, 4, 6) - nContCol)/2)
						If Empty(nCol)
							@ Li, nCol  PSay "|"
							nCol := PCol()
						EndIf
						
						@ Li, nCol PSay Space(nColTam1) + "|" + Space(nColTam2) + "|"
						nCol  := PCol()
					Next nA
					Li++
					@ Li, 00 PSay cTraco
					Li++
					nContLin += 1
					nCol     := 0
				EndIf
				
				If nContLin < 12 // As linhas do relatorio nao estao completas
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Completa o quadro do relatorio com as linhas que faltaram.            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nB := 1 To (12 - nContLin)
						nCol  := 0
						For nC := 1 To If(lEndereco, 2, 3)
							If Empty(nCol)
								@ Li, nCol  PSay "|"
								nCol := PCol()
							EndIf
							
							@ Li, nCol PSay Space(nColTam1) + "|" + Space(nColTam2) + "|"
							nCol  := PCol()
						Next nC
						Li++
						@ Li, 00 PSay cTraco
						Li++
					Next nB
				EndIf
				
				Li+=3
				@ Li, 00 PSay "________________________             _____________________________"
				Li++
				@ Li, 00 PSay STR0007 //"Conferente	              		       	      Arrumador"
				Li+=3
				@ Li, 00 PSay "________________________             _____________________________"
				Li++
				@ Li, 00 PSay STR0008 //"Ajudante		                              Ajudante"
				Li++
			EndIf

		EndIf
	Next
	dbSelectArea("DUD")
	// Nao precisa dar DbSkip() aqui
EndDo

If aReturn[5] == 1
	Set Printer TO
	dbCommitall()
	OurSpool(wnrel)
EndIf     

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RtmsR05Doc³ Autor ³ Antonio C Ferreira    ³ Data ³20.05.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta vetor dos Documentos a serem impressos.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RtmsR05Doc(ExpA1,ExpC2,ExpC3,ExpC4,ExpL5)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Vetor dos Documentos.                              ³±±
±±³          ³ ExpC2 = Filial Origem.                                     ³±± 
±±³          ³ ExpC3 = Viagem.                                            ³±± 
±±³          ³ ExpC4 = Documto Carregado.                                 ³±±
±±³          ³ ExpL5 = Se interrompido o processo.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC Function RtmsR05Doc(aImprimir, cFilOri, cViagem, cDocCarreg, lEnd, cSeqImp )

Local lGrvSeq := .F.

aImprimir := {}

While DUD->(!Eof() .And. DUD->DUD_FILIAL + DUD->DUD_FILORI + DUD->DUD_VIAGEM == xFilial('DUD') + cFilOri + cViagem)
	IncRegua()
    
	If lEnd
		Return .F.
	EndIf   

	If	DUD->(FieldPos('DUD_SEQIMP'))>0
		If	mv_par06 == 1
			If	! Empty(DUD->DUD_SEQIMP)
				DUD->(DbSkip())
				Loop
			EndIf					
		ElseIf mv_par06 == 2
			If	Empty(DUD->DUD_SEQIMP) .Or. DUD->DUD_SEQIMP < mv_par07 .Or. DUD->DUD_SEQIMP > mv_par08
				DUD->(DbSkip())
				Loop
			EndIf
		EndIf
	EndIf
    
	If	cDocCarreg != 3
		//-- Parametro somente documentos carregados igual a sim
		If cDocCarreg == 1 .And. DUD->DUD_STATUS != StrZero(3,Len(DUD->DUD_STATUS))
			DUD->(DbSkip())
			Loop
		//-- Parametro somente documentos carregados igual a nao
		ElseIf cDocCarreg == 2 .And. DUD->DUD_STATUS == StrZero(3,Len(DUD->DUD_STATUS))
			DUD->(DbSkip())
			Loop
		EndIf
	EndIf
	
	lGrvSeq := .F.
	DT6->(MsSeek(xFilial('DT6') + DUD->DUD_FILDOC + DUD->DUD_DOC + DUD->DUD_SERIE))
	If (DT6->DT6_DOCTMS $ "25")   // Pega os Documentos de Transporte com 2-CTRC e 5-Nota Fiscal.
		Aadd( aImprimir, {DUD_FILDOC + " " + DUD_DOC + "/" + DUD_SERIE +' '+ Transform(DT6->DT6_QTDVOL, PesqPict("DT6","DT6_QTDVOL")), If(DUD_STATUS=="3" /*Carregado*/, " O K ", Space(5)),Iif(DUD->(FieldPos('DUD_SEQIMP'))>0,DUD->DUD_SEQIMP,'')} )
		lGrvSeq := .T.
	EndIf

	If	DUD->(FieldPos('DUD_SEQIMP'))>0 .And. mv_par06 == 1 .And. lGrvSeq .And. Empty(DUD->DUD_SEQIMP)
		RecLock('DUD',.F.)
		DUD->DUD_SEQIMP := cSeqImp
		MsUnLock()
	EndIf
    
	DUD->(DbSkip())
EndDo    

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RtmsR05End³ Autor ³ Antonio C Ferreira    ³ Data ³20.05.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta vetor dos Enderecos a serem impressos.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RtmsR05End(ExpA1,ExpC2,ExpC3,ExpC4,ExpL5)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Vetor dos Enderecos.                               ³±±
±±³          ³ ExpC2 = Filial Origem.                                     ³±±  
±±³          ³ ExpC3 = Viagem.                                            ³±±  
±±³          ³ ExpC4 = Documto Carregado.                                 ³±± 
±±³          ³ ExpL5 = Se interrompido o processo.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC Function RtmsR05End(aImprimir, cFilOri, cViagem, cDocCarreg, lEnd, cSeqImp )

Local lGrvSeq := .F.

aImprimir := {}

DTC->( DbSetOrder( 3 ) )   // DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE
DUH->( DbSetOrder( 1 ) )   // DUH_FILIAL+DUH_FILORI+DUH_NUMNFC+DUH_SERNFC+DUH_CLIREM+DUH_LOJREM

While DUD->( ! Eof() .And. DUD->DUD_FILIAL + DUD->DUD_FILORI + DUD->DUD_VIAGEM == xFilial('DUD') + cFilOri + cViagem )
	IncRegua()
	
	If lEnd
		Return .F.
	EndIf   

	If	DUD->(FieldPos('DUD_SEQIMP'))>0
		If	mv_par06 == 1
			If	! Empty(DUD->DUD_SEQIMP)
				DUD->(DbSkip())
				Loop
			EndIf
		ElseIf mv_par06 == 2
			If	Empty(DUD->DUD_SEQIMP) .Or. DUD->DUD_SEQIMP < mv_par07 .Or. DUD->DUD_SEQIMP > mv_par08
				DUD->(DbSkip())
				Loop
			EndIf
		EndIf
	EndIf

	If	cDocCarreg != 3
		//-- Parametro somente documentos carregados igual a sim
		If cDocCarreg == 1 .And. DUD->DUD_STATUS != StrZero(3,Len(DUD->DUD_STATUS))
			DUD->(DbSkip())
			Loop
		//-- Parametro somente documentos carregados igual a nao
		ElseIf cDocCarreg == 2 .And. DUD->DUD_STATUS == StrZero(3,Len(DUD->DUD_STATUS))
			DUD->(DbSkip())
			Loop
		EndIf
	EndIf

	DT6->(MsSeek(xFilial('DT6') + DUD->DUD_FILDOC + DUD->DUD_DOC + DUD->DUD_SERIE))
	    
	If	! DT6->DT6_DOCTMS $ "25"  // Pega os Documentos de Transporte com 2-CTRC e 5-Nota Fiscal.
		DUD->(DbSkip())
		Loop
	EndIf   
    
	lGrvSeq := .F.
	// Varre as Notas Fiscais do Cliente
	DTC->(MsSeek(xFilial('DTC') + DUD->DUD_FILDOC + DUD->DUD_DOC + DUD->DUD_SERIE))
	Do While DTC->(!Eof()) .and. DTC->(DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE) == xFilial("DTC")+DUD->(DUD_FILDOC+DUD_DOC+DUD_SERIE)
		// Varre os Enderecamentos das Notas Fiscais
		DUH->( MsSeek(xFilial("DUH") + DTC->(DTC_FILORI + DTC_NUMNFC + DTC_SERNFC + DTC_CLIREM + DTC_LOJREM)) )
		Do While DUH->(!Eof()) .and. DUH->(DUH_FILIAL+DUH_FILORI+DUH_NUMNFC+DUH_SERNFC+DUH_CLIREM+DUH_LOJREM) == xFilial("DUH")+DTC->(DTC_FILORI+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM) 
			If Empty( Ascan( aImprimir, DUH->(DUH_LOCAL+" "+DUH_LOCALI) ) )
				Aadd( aImprimir, {DUH->(DUH_LOCAL+"  "+DUH_LOCALI) +"  "+ DUD->(DUD_FILDOC + " " + DUD_DOC + "/" + DUD_SERIE) +' '+ Transform(DT6->DT6_QTDVOL, PesqPict("DT6","DT6_QTDVOL")) , If(DUD_STATUS=="3", " O K ", Space(5)),Iif(DUD->(FieldPos('DUD_SEQIMP'))>0,DUD->DUD_SEQIMP,'')} )
				lGrvSeq := .T.
			EndIf   
			DUH->(DbSkip())
		EndDo // DUH
		DTC->(DbSkip())
	EndDo // DTC
    
	If	DUD->(FieldPos('DUD_SEQIMP'))>0 .And. mv_par06 == 1 .And. lGrvSeq .And. Empty(DUD->DUD_SEQIMP)
		RecLock('DUD',.F.)
		DUD->DUD_SEQIMP := cSeqImp
		MsUnLock()
	EndIf

	DUD->(DbSkip())  // DUD
EndDo // DUD   

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RtmsR05Cab³ Autor ³ Robson Alves          ³ Data ³20.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta no array o cabecalho do relatorio.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RtmsR05Cabec(ExpA1,ExpC2,ExpM3)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array para montar o cabecalho.                     ³±±
±±³          ³ ExpC2 = Titulo do relatorio.                               ³±± 
±±³          ³ ExpM3 = Observacao da Viagem.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RtmsR05Cabec(aCabecalho, Titulo, cObserv)

Local aArea     := GetArea()
Local nAux      := 0
Local cLibSeg   := ""

aCabecalho := {}            

If !empty(cObserv)
   Aadd(aCabecalho, STR0018 + Subs(cObserv, 1 , 60)) //"Observacao: "
   Aadd(aCabecalho, space(12) + Subs(cObserv, 61, 80))
   Aadd(aCabecalho, space(5))
EndIf     
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le o DTR (Complemento de Viagem)                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("DTR")
dbSetOrder(1)
MsSeek(xFilial("DTR") + DUD->( DUD_FILORI + DUD_VIAGEM ))

nAux := 0
					
Do While !Eof() .And. DTR->(DTR_FILIAL + DTR_FILORI + DTR_VIAGEM) == xFilial("DTR") + DUD->(DUD_FILORI + DUD_VIAGEM) 
					
	dbSelectArea("DA3")
	dbSetOrder(1)
	If MsSeek(xFilial("DA3") + DTR->DTR_CODVEI)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta uma linha para cada registro do mesmo tipo(Veiculos).           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Veiculo  : 1-12345678 xxx-xxxx Tipo: 1234567890123456789012345 Capac: 99,999.99
		
		Aadd(aCabecalho, if(nAux==0, STR0012, space(len(STR0012))) + StrZero(++nAux, 1) + "-" + DA3->DA3_COD + " " + DA3->DA3_PLACA +; // Veiculo: ## - #### ###-####
						  " " + STR0013 + Posicione("DUT", 1, xFilial("DUT") + DA3->DA3_TIPVEI, "DUT_DESCRI") +; // Tipo: ############ 
		                  " " + STR0014 + Alltrim(Transform(DA3->DA3_CAPACM, PesqPict("DA3","DA3_CAPACM"))) ) //Capac: 999999.99
	EndIf				

	If !Empty(DTR->DTR_CODRB1) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB1)) 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
		//³ Monta uma linha com os dados do 1o. Reboque                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aCabecalho, if(nAux==0, STR0012, space(len(STR0012))) + StrZero(++nAux, 1) + "-" + DA3->DA3_COD + " " + DA3->DA3_PLACA +; // Veiculo: ## - #### ###-####
						  " " + STR0013 + Posicione("DUT", 1, xFilial("DUT") + DA3->DA3_TIPVEI, "DUT_DESCRI") +; // Tipo: ############ 
		                  " " + STR0014 + Alltrim(Transform(DA3->DA3_CAPACM, PesqPict("DA3","DA3_CAPACM"))) ) //Capac: 999999.99
	EndIf

	If !Empty(DTR->DTR_CODRB2) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB2)) 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
		//³  Monta uma linha com os dados do 2o. Reboque                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aCabecalho, if(nAux==0, STR0012, space(len(STR0012))) + StrZero(++nAux, 1) + "-" + DA3->DA3_COD + " " + DA3->DA3_PLACA +; // Veiculo: ## - #### ###-####
						  " " + STR0013 + Posicione("DUT", 1, xFilial("DUT") + DA3->DA3_TIPVEI, "DUT_DESCRI") +; // Tipo: ############ 
		                  " " + STR0014 + Alltrim(Transform(DA3->DA3_CAPACM, PesqPict("DA3","DA3_CAPACM"))) ) //Capac: 999999.99
	EndIf
		
	dbSelectArea("DTR")
	dbSkip()
EndDo

If len(aCabecalho) > 0
   Aadd(aCabecalho, space(5))
EndIf   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le o DTR(Complemento de Viagem) com o tipo igual a "2"(Motorista).    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("DUP")
dbSetOrder(1)
MsSeek(xFilial("DUP") + DUD->(DUD_FILORI + DUD_VIAGEM))

nAux := 0
							
While !Eof() .And. DUP->(DUP_FILIAL + DUP_FILORI + DUP_VIAGEM) == xFilial("DUP") + DUD->(DUD_FILORI + DUD_VIAGEM) 

	dbSelectArea("DA4")
	dbSetOrder(1)
	If MsSeek(xFilial("DA4") + DUP->DUP_CODMOT)
		cLibSeg := DA4->DA4_LIBSEG
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta uma linha para cada registro do mesmo tipo(Motorista).          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Motorista: 1-123456  Nome56789012345678  CNH:1234567890  Telerisco: 1234567890
		
		Aadd(aCabecalho, if(nAux==0, STR0016, space(len(STR0016))) + StrZero(++nAux, 1) + '-' + DA4->DA4_COD + "  " + Substr(DA4->DA4_NREDUZ,1,18) +; //"Motorista: #-##### Nomexxxxxxxxxxxxxx
		                  "  " + STR0011 + DA4->DA4_NUMCNH +; // CNH : #####
						  "  " + STR0017 + DA4->DA4_LIBSEG ) //" Telerisco : ########
	EndIf
					
	dbSelectArea("DUP")
	dbSkip()
EndDo

RestArea(aArea)

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R05ImpReg ³ Autor ³ Robson Alves          ³ Data ³23.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime as filiais de destino e descarga.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R05ImpReg(ExpA1,ExpA2)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com as filiais de destino.                   ³±±
±±³          ³ ExpA2 = Array com as filiais de descarga.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R05ImpReg(aDestino, aDescarga, cFilOri, cViagem)

Local nAux   := 0
Local nA     :=0
Local nB     :=0
Local nC     :=0
Local nD     :=0
Local nCol   := 15
Local cLacre := ""
Local cSeek  := ""

@ Li, 00 PSay cTraco
Li++
@ Li, 00 PSay STR0022 //"|Destino     |"
				
For nA := 1 To Len(aDestino)
	If nAux >= 14
		Li++
		@ Li, 00 PSay "|            | " + aDestino[nA]+ " | "
		nAux  := 1
		nCol := PCol()
	Else						
		@ Li, nCol PSay aDestino[nA] + " | "
		nCol := PCol()
		nAux += 1
	EndIf						
Next nA
                
If nAux < 13
	For nB := 1 To (13 - nAux)
       	@ Li, nCol PSay "   | "
       	nCol := PCol()
	Next nB
    Li++
EndIf    	            
@ Li, 00 PSay cTraco
Li++

nCol := 15
nAux  := 0

@ Li, 00 PSay STR0023  //"|Descarga    |"
For nC := 1 To Len(aDescarga)
	If nAux >= 14
		Li++
		@ Li, 00 PSay "|            | " + aDescarga[nC]+ " | "
		nAux  := 1
		nCol := PCol()
	Else						
		@ Li, nCol PSay aDescarga[nC]+ " | "
		nCol := PCol()
		nAux += 1
	EndIf						
Next nC
                
If nAux < 13
	For nD := 1 To (13 - nAux)
    	@ Li, nCol PSay "   | "
	  	nCol := PCol()
	Next nD
	Li++
EndIf    	            

/*
array | endereco + documento

-----------------------------------------
| Endereco           | Documento      |  Volume  |       | Endereco           | Documento      |  Volume  |       | 
------------------------------------------
| xx 123456789012345 | XX 123456/xxx  | 999,999 |       |
*/                      

cLacre := ""
DVB->( dbSetOrder( 1 ) )

If DVB->( MsSeek( cSeek := xFilial( "DVB" ) + cFilOri + cViagem ) )
	Do While DVB->( !EoF() ) .And. DVB->(DVB_FILIAL+DVB_FILORI+DVB_VIAGEM) == cSeek
		cLacre += AllTrim(DVB->DVB_LACRE)+"/"
		DVB->( dbSkip() )
	EndDo
	cLacre := SubStr( cLacre,1,Len(cLacre)-1 )
EndIf

@ Li, 00 PSay cTraco
Li++
@ Li, 00 PSay cTraco
Li++
@ Li, 00 PSay STR0024 + STR0025 +cLacre //"|(  ) 1a Parte |(  ) 2a Parte |(  ) 3a Parte |(  ) Encerramento|(  ) Lacre    |" //   " |  No. Lacre: "
Li++
@ Li, 00 PSay cTraco
Li++     
@ Li, 00 PSay STR0026 //"Local/Localizacao  Documento/Serie  Volume"
@ Li, 65 PSay STR0026 //"Local/Localizacao  Documento/Serie  Volume"
Li++                              
@ Li, 00 PSay cTraco
Li++

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R05SeqImp ³ Autor ³ Robson Alves          ³ Data ³23.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inclui perguntas                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Filial                                             ³±±
±±³          ³ ExpC2 = Filial de origem                                   ³±±
±±³          ³ ExpC3 = Viagem                                             ³±±
±±³          ³ ExpC4 = Chave de pesquisa                                  ³±±
±±³          ³ ExpC5 = Sequencia de impressao                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R05SeqImp(cFilPad,cFilOri,cViagem,cSeek,cSeqImp)

Local aAreaDUD := DUD->(GetArea())

cSeek := cFilPad + cFilOri + cViagem

While DUD->( ! Eof() .And. DUD->DUD_FILIAL + DUD->DUD_FILORI + DUD->DUD_VIAGEM == cSeek )
	cSeqImp := Iif(DUD->DUD_SEQIMP >= cSeqImp,DUD->DUD_SEQIMP,cSeqImp)
	DUD->(DbSkip())
EndDo
cSeqImp := SomaIt( cSeqImp )
RestArea(aAreaDUD)

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RtmsR05SX1³ Autor ³ Robson Alves          ³ Data ³23.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inclui perguntas                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RtmsR05SX1()

PutSX1('RTMR05','06',"Impressão/Reimp. ?"	,"¿Impresión/Reimp. ?"	,"Print/Reprint ?"	,'mv_ch6','N',1,0,1,'C','',''   ,'','','mv_par06',"Impressão","Impresión","Printing",'',"Reimpressão","Reimpresión","Reprinting")
PutSx1('RTMR05','07',"Sequência De  ?"   	,"¿De Secuencia ?"		,"From Sequence ?"	,'mv_ch7','C',TamSX3('DUD_SEQIMP')[1],0,0,'G','',''   ,'','','mv_par07')
PutSx1('RTMR05','08',"Sequência Até ?"   	,"¿A Secuencia ?"			,"To Sequence ?"		,'mv_ch8','C',TamSX3('DUD_SEQIMP')[1],0,0,'G','',''   ,'','','mv_par08')

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³R05Quebra³ Autor ³ Robson Alves           ³ Data ³23.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Controla a quebra em partes                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R05Quebra(aImprimir,nItem)

Local lRet		:= .F.
Local nProxIt	:= nItem + 1

If	nProxIt > Len(aImprimir)
	lRet := .T.
ElseIf aImprimir[nItem,3] != aImprimir[nProxIt,3]
	lRet := .T.
EndIf

Return( lRet )