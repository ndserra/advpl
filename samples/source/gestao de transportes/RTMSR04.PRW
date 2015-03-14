#Include "Protheus.ch"
#Include "Rtmsr04.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTmsr04  ³ Autor ³ Robson Alves          ³ Data ³20.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao do Manifesto de Carga.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Rtmsr04()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TMS (Modulo de Transporte)                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RTMSR04()
Local cDesc1     := STR0001 // "Este programa ir  emitir o Manifesto de Carga."
Local cDesc2     := ""
Local cDesc3     := ""
Local cString    := "DTX"
Local Tamanho    := "G"
Local Limite     := 220
Local Titulo     := STR0002 // "Manifesto de Carga"
Local Wnrel
Private aReturn  := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }// "Zebrado" / "Administracao"
Private nomeprog := "RTMSR04"
Private nLastKey := 0
Private cPerg    := "RTMR04"

//Chamada do relatorio padrao
If FindFunction("TRepInUse") .And. TRepInUse()
	TMSR590()
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o grupo de perguntas.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg, .F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                  ³
//³ mv_par01            // Filial Origem                                  ³
//³ mv_par02            // Viagem                                         ³
//³ mv_par03            // Fil. Manifesto De                              ³
//³ mv_par04            // Fil. Manifesto Ate                             ³
//³ mv_par05            // Manifesto De                                   ³
//³ mv_par06            // Manifesto Ate                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := nomeprog  // Nome Default do relatorio em Disco.
wnrel:=SetPrint(cString, Wnrel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)

If nLastKey == 27
	Return Nil
Endif

SetDefault(aReturn, cString)

If nLastKey == 27
	Return Nil
Endif

RptStatus({|lEnd| RTmsr04Imp(@lEnd, wnRel, Titulo, Tamanho)}, STR0005) // "Imprimindo o Manifesto de Carga."

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTmsr04Imp³ Autor ³ Robson Alves          ³ Data ³20.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime Manifesto de Carga.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTmsr04Imp(ExpL1, ExpC1, ExpC2, ExpC3, ExpN1)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Abandona a impressao(.T. = Sim/.F. = Nao).         ³±±
±±³          ³ ExpC1 = Retorno da funcao SetPrint.                        ³±±
±±³          ³ ExpC2 = Titulo do relatorio.                               ³±±
±±³          ³ ExpN1 = Tamanho do relatorio.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Rtmsr04                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTmsr04Imp(lEnd, wnRel, Titulo, Tamanho)

Local nA         := 0
Local nVias      := 1
Local nB         := 1
Local lImpEnd    := (GetMV("MV_LOCALIZ") == "S")  // Se for pelo Endereco
Local lImprimir  := .F.
Local aEndereco  := {}
Local cNomRem    := ""
Local cInscRem   := ""
Local cNomDes    := ""
Local cInscDes   := ""
Local aCabecalho := {}
// Totais e Totais Gerais
Local nValMercC  := nGValMercC  := 0
Local nValFreteC := nGValFretC  := 0
Local nValICMC   := nGValICMC   := 0
Local nVolsC     := nGVolsC     := 0
Local nPesoC     := nGPesoC     := 0
Local nPesoCobC  := nGPesoC     := 0
Local nCtrcsC    := nGCtrcsC    := 0
Local nVarNTribC := nGVarNTriC  := 0
Local nVarTribC  := nGVarTribC  := 0
Local nValMercF  := nGValMercF  := 0
Local nValFreteF := nGValFretF  := 0
Local nValICMF   := nGValICMF   := 0
Local nVolsF     := nGVolsF     := 0
Local nPesoF     := nGPesoF     := 0
Local nPesoCobF  := nGPesoF     := 0
Local nCtrcsF    := nGCtrcsF    := 0
Local nVarNTribF := nGVarNTriF  := 0
Local nVarTribF  := nGVarTribF  := 0
Local nGPesoCobC := nGPesoCobF  := 0
Local cNotas     := ""
Local lImpResumo := .F.
Local cPFilOri   := mv_par01
Local cPViagem   := mv_par02
Local cObsViag   := ""
Local cFilSF2    := ""
Local nZ         :=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis utilizadas para Impressao do cabecalho e rodape.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cbtxt  := Space(10)
Private cbcont := 0
Private Li     := 80
Private m_pag  := 1
Private nTipo  := aReturn[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define parte do layout do relatorio.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//  CTRC       Remetente            Insc. Estatual     Destinatario         Insc. Estatudal    Cidade               UF Diz Conter           Vols            Peso     Peso Cob.     Valor Merc      T  Orig Dest
//  xxxxxx/xxx X---------20-------x x------18--------x x-------20---------x x------18--------x x--------20--------x xx x--------20--------x 999999  999,999.9999  999,999.9999 999,999,999.99      x xx   xx

DTQ->(dbSetOrder(2))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le o DTX(Manifesto de Carga).                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("DTX")
dbSetOrder(3) // DTX_FILIAL+DTX_FILORI+DTX_VIAGEM+DTX_FILMAN+DTX_MANIFE
MsSeek(xFilial("DTX") + cPFilOri + cPViagem)
DUH->( DbSetOrder( 1 ) )   // DUH_FILIAL+DUH_FILORI+DUH_NUMNFC+DUH_SERNFC+DUH_CLIREM+DUH_LOJREM
SetRegua(RecCount())
While !Eof() .And. (DTX_FILIAL == xFilial("DTX")) .And. (DTX_FILORI == cPFilOri) .And. (DTX_VIAGEM == cPViagem)
	IncRegua()
	Li    := 80
	nVias := 1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a impressao foi cancelada.                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lEnd
		@Prow()+1,001 PSay STR0007 // "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	
	If DTX_FILMAN < mv_par03 .Or. DTX_FILMAN > mv_par04
		dbSkip()
		Loop
	EndIf
	
	If DTX_MANIFE < mv_par05  .Or. DTX_MANIFE > mv_par06
		dbSkip()
		Loop
	EndIf
	Cabec1 := STR0010 + DTX_FILMAN + ' - ' + DTX_MANIFE // "Manifesto : "
	Cabec2 := STR0011 + DTX_FILORI + ' - ' + DTX_VIAGEM // "Viagem    : "
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta no array(aCabecalho) o restante do layout do relatorio.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RtmsR04Cabec(@aCabecalho, Titulo)
	lImpResumo := .F. // Imprime resumo sim ou nao.
	
	// Obtem o numero de vias para impressao do manifesto.
	If SX6->(MsSeek(DTX->DTX_FILDCA + "MV_VIAMAN")) .And. SX6->X6_TIPO == "N"
		nVias := Val(SX6->X6_CONTEUD)
	EndIf
	
	SetRegua(nVias)
	For nB := 1 To nVias
		Li         := 80
		lImpResumo := .F.
		IncRegua()
		
		DbSelectArea("DUD")
		DbSetOrder(5)   // DUD_FILIAL+DUD_FILORI+DUD_VIAGEM+DUD_FILMAN+DUD_MANIFE
		MsSeek(xFilial("DUD")+DTX->DTX_FILORI+DTX->DTX_VIAGEM+DTX->DTX_FILMAN+DTX->DTX_MANIFE)
		
		While !Eof() .And. (DUD_FILIAL+DUD_FILORI+DUD_VIAGEM+DUD_FILMAN+DUD_MANIFE ==;
			xFilial("DUD")+DTX->DTX_FILORI+DTX->DTX_VIAGEM+DTX->DTX_FILMAN+DTX->DTX_MANIFE)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Le todo o DT6(Header das NF's de Saida) para a viagem e o manifesto   ³
			//³posicionado.                                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("DT6")
			dbSetOrder(1)   // DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE
			
			MsSeek(xFilial("DT6") + DUD->(DUD_FILDOC + DUD_DOC + DUD_SERIE))
			
			While !Eof() .And. DT6->(DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE) == xFilial("DT6")+DUD->(DUD_FILDOC+DUD_DOC+DUD_SERIE)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona o SA1(Cadastro de Clientes) para obter a Inscricao Estatual ³
				//³e nome do Remetente.                                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DTC->( dbSetOrder(3) )    // DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE
				DTC->( MsSeek(xFilial("DTC") + DT6->(DT6_FILDOC + DT6_DOC + DT6_SERIE)) )
				
				SA1->(dbSetOrder(1))
				If SA1->( MsSeek(xFilial("SA1") + DTC->(DTC_CLIREM + DTC_LOJREM)) )
					cInscRem := Iif(Empty(SA1->A1_INSCR), STR0008, SA1->A1_INSCR) // "Em branco"
					cNomRem  := Iif(Empty(SA1->A1_NOME) , STR0008, Left(SA1->A1_NOME, 25)) // "Em branco"
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona o SA1(Cadastro de Clientes) para obter a Inscricao Estatual ³
				//³e nome do Destinatario.                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SA1->( MsSeek(xFilial("SA1") + DTC->(DTC_CLIDES + DTC_LOJDES)) )
					cInscDes := Iif(Empty(SA1->A1_INSCR), STR0008, SA1->A1_INSCR) // "Em branco"
					cNomDes  := Iif(Empty(SA1->A1_NOME) , STR0008, Left(SA1->A1_NOME, 25)) // "Em branco"
				EndIf
				lImprimir := .T.
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime o cabecalho e a linha de detalhe.                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If li > 58
					Li := Cabec(Titulo, cabec1, cabec2, NomeProg, Tamanho)
					
					For nA := 1 to len(aCabecalho)
						@ Li++, 0 PSay aCabecalho[nA]
					Next
					
					/* Imprime a observacao da viagem. */
					If DTQ->(MsSeek(xFilial("DTQ") + DUD->(DUD_FILORI + DUD_VIAGEM)))
						@ Li, 000 PSay STR0030 // "Observacao : "
						cObsViag := MsMM(DTQ->DTQ_CODOBS,300)
						While !Empty(cObsViag) .And. Len( cObsViag ) > 0
							@ Li, 018 PSay AllTrim(Substr( cObsViag, 1, 100 ))
							cObsViag := Substr( cObsViag, 101 )
							Li++
						EndDo
					EndIf
					
					++Li
					@Li,000 PSay __PrtThinLine()
					++Li
					If DTQ->DTQ_TIPTRA == '4' //-- Transporte Internacional
						@ Li,01 PSay STR0034
					Else						
						@ Li,01 PSay STR0006
					EndIf						
					++Li
					@Li,000 PSay __PrtThinLine()
					Li += 2
				EndIf
				SB1->( DbSelectArea(1) )  // B1_FILIAL+B1_COD
				SB1->( MsSeek( xFilial("SB1") + DTC->DTC_CODPRO ) )
				
				@ Li, 001 PSay DT6->DT6_DOC+' '+Iif(DT6->DT6_TIPTRA == '4',DT6->DT6_SERIE,'')
				@ Li, 012 PSay Substr(cNomRem,1,20)
				@ Li, 033 PSay Transform(cInscRem,PesqPict("SA1", "A1_INSCR"))
				@ Li, 052 PSay Substr(cNomDes,1,20)
				@ Li, 073 PSay Transform(cInscDes,PesqPict("SA1", "A1_INSCR"))
				@ Li, 092 PSay SA1->A1_MUN
				@ Li, 113 PSay SA1->A1_EST
				@ Li, 116 PSay Left(SB1->B1_DESC, 20)
				@ Li, 137 PSay Transform(DT6->DT6_QTDVOL,PesqPict("DT6", "DT6_QTDVOL"))
				
				@ Li, 150 PSay AllTrim(Transform(DT6->DT6_PESO,PesqPict("DT6", "DT6_PESO")))
				@ Li, 164 PSay AllTrim(Transform(DT6->DT6_PESCOB,PesqPict("DT6", "DT6_PESCOB")))
				@ Li, 177 PSay AllTrim(Transform(DT6->DT6_VALMER,PesqPict("DT6", "DT6_VALMER")))
				@ Li, 192 PSay Iif(DT6->DT6_TIPFRE == "1", "C", "F")
				@ Li, 197 PSay cFilAnt
				@ Li, 202 PSay DT6->DT6_FILDES
				Li += 1
								
				cNotas := "" // Zera a variavel usada para montar uma string das notas(itens SD2).
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Le todos os itens da nota posicionada(SD2 - Itens das NF's de Saida). ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				While !Eof() .And. (DTC->(DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE) == xFilial("DT6")+DT6_FILDOC+DT6_DOC+DT6_SERIE)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Se a string usada para concatenar as notas passar de 200 caracteres,  ³
					//³os mesmos serao impressos e o restante vai para proxima linha.         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Len(cNotas) >= 200
						@ Li, 15 PSay cNotas
						Li += 1
						cNotas := ""
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Monta string com todas notas.                                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !empty(cNotas)
						cNotas += " / "
					EndIf
					cNotas += DTC->( DTC_NUMNFC + "-" + DTC_SERNFC )
					
					// Verifica se imprime o endereco ou nao dependendo do conteudo do parametro MV_LOCALIZ
					If lImpEnd
						aEndereco := {}
						
						// Varre os Enderecamentos das Notas Fiscais
						DUH->( MsSeek(xFilial("DUH") + DTC->(DTC_FILORI + DTC_NUMNFC + DTC_SERNFC + DTC_CLIREM + DTC_LOJREM)) )
						
						// Este While pega todos os enderecos do documento e joga num array
						Do While DUH->( !Eof() .and. DUH_FILIAL+DUH_FILORI+DUH_NUMNFC+DUH_SERNFC+DUH_CLIREM+DUH_LOJREM == xFilial("DUH")+DTC->(DTC_FILORI+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM) )
							If Empty( Ascan( aEndereco, DUH->(DUH_LOCAL + " - " + DUH_LOCALI) ) )
								Aadd( aEndereco, DUH->DUH_LOCAL + " - " + DUH->DUH_LOCALI)
							EndIf
							DUH->( DbSkip() )
						EndDo // DUH
						
						// **** Impressao do Endereco **** \\
						For nZ := 1 to len(aEndereco)
							If li > 48
								Cabec(Titulo, cDesc1, "", NomeProg, Tamanho)
							EndIf
							@ Li, 001  PSay STR0031 + AllTrim(Str(nZ)) + STR0032 + aEndereco[nZ]  //"Endereco("###"): "
							Li += 1
						Next nZ
						
					EndIf
					
					DTC->( dbSkip() )
				EndDo // DTC
				
				If DT6->DT6_TIPTRA <> '4' //-- Transporte Internacional
					@ Li, 001 PSay STR0009 // "N Fiscais  : "
					@ Li, 14 PSay cNotas // Imprime string com todas a notas.
				EndIf					
				Li += 1
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Obtem o total para o tipo do frete CIF ou FOB.                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cFilSF2 := Iif(Empty(xFilial('SF2')), xFilial('SF2'), DT6->DT6_FILDOC)
				SF2->( DbSetOrder(1) )  // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA
				SF2->( MsSeek(cFilSF2 + DT6->(DT6_DOC + DT6_SERIE)) )
				
				If DT6->DT6_TIPFRE == "1" // Frete CIF
					nValMercC  += DT6->DT6_VALMER  // Valor Mercadoria CIF
					nValFreteC += DT6->DT6_VALTOT  // Valor do Frete CIF
					nValICMC   += DT6->DT6_VALIMP  // Valor do ICMS CIF
					nVolsC     += DT6->DT6_QTDVOL // Volumes CIF
					nPesoC     += DT6->DT6_PESO   // Peso Liquido CIF
					nPesoCobC  += DT6->DT6_PESCOB  // Peso Cobrado Liquido CIF
					nCtrcsC    += 1               // Numero de Conhecimentos CIF
					nVarNTribC += DT6->DT6_VALTOT-SF2->F2_BASEICM // Valor nao Tributavel CIF
					nVarTribC  += SF2->F2_BASEICM  // Valor Tributavel CIF
				Else // Frete FOB
					nValMercF  += DT6->DT6_VALMER  // Valor Mercadoria FOB
					nValFreteF += DT6->DT6_VALTOT   // Valor do Frete FOB
					nValICMF   += DT6->DT6_VALIMP   // Valor do ICMS FOB
					nVolsF     += DT6->DT6_QTDVOL  // Volumes FOB
					nPesoF     += DT6->DT6_PESO    // Peso Liquido FOB
					nPesoCobF  += DT6->DT6_PESCOB  // Peso Cobrado FOB
					nCtrcsF    += 1                 // Numero de Conhecimentos FOB
					nVarNTribF += DT6->DT6_VALTOT-SF2->F2_BASEICM // Valor nao Tributavel CIF
					nVarTribF  += SF2->F2_BASEICM  // Valor Tributavel CIF
				EndIf
				lImpResumo := .T. // Sim, imprime o resumo do manifesto.
				
				DT6->( dbSkip() )  // DT6
			EndDo
			
			DbSelectArea("DUD")
			DbSkip()
		EndDo  // DUD
		
		If lImpResumo
			nGValMercC  += nValMercC
			nGValFretC  += nValFreteC
			nGVarNTriC  += nVarNTribC
			nGVarTribC  += nVarTribC
			nGValICMC   += nValICMC
			nGVolsC     += nVolsC
			nGPesoC     += nPesoC
			nGPesoCobC  += nPesoCobC
			nGCtrcsC    += nCtrcsC
			nGValMercF  += nValMercF
			nGValFretF  += nValFreteF
			nGVarNTriF  += nVarNTribF
			nGVarTribF  += nVarTribF
			nGValICMF   += nValICMF
			nGVolsF     += nVolsF
			nGPesoF     += nPesoF
			nGPesoCobF  += nPesoCobF
			nGCtrcsF    += nCtrcsF
			
			If li > 64
				Li := Cabec(Titulo, cabec1, cabec2, NomeProg, Tamanho)
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime o resumo do Manifesto.                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RTmsR04Resumo("R", nValMercC, nValFreteC, nVarNTribC, nVarTribC, nValICMC, nVolsC,;
			nPesoC, nCtrcsC, nValMercF, nValFreteF, nVarNTribF, nVarTribF, nValICMF, nVolsF,;
			nPesoF, nCtrcsF, nPesoCobF, nPesoCobC)
			
			nValMercC := nValFreteC := nVarNTribC := nVarTribC  := nValICMC   := nVolsC    := 0
			nPesoC    := nCtrcsC    := nValMercF  := nValFreteF := nVarNTribF := nVarTribF := 0
			nValICMF  := nVolsF     := nPesoF     := nCtrcsF    := nPesCobC   := nPesCobF  := 0
			nPesoCobC := nPesoCobF  := 0
		EndIf
		
		/* Se for mais de uma via imprime o resumo geral ao termino da impresao da memsa. */
		If nVias > 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime o Resumo Geral do Manifesto.                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RTmsR04Resumo("G", nGValMercC, nGValFretC, nGVarNTriC, nGVarTribC, nGValICMC, nGVolsC,;
			nGPesoC, nGCtrcsC, nGValMercF, nGValFretF, nGVarNTriF, nGVarTribF, nGValICMF, nGVolsF,;
			nGPesoF, nGCtrcsF, nGPesoCobF, nGPesoCobC)
			
			/* Zera as variavies para impressao do resumo geral da proxima via. */
			nGValMercC  := nGValFretC  := nGVarNTriC  := nGVarTribC  := 0
			nGValICMC   := nGVolsC     := nGPesoC     := nGCtrcsC    := 0
			nGValMercF  := nGValFretF  := nGVarNTriF  := nGVarTribF  := 0
			nGValICMF   := nGVolsF     := nGPesoF     := nGCtrcsF    := 0
			nGPesoCobC  := nGPesoCobF  := 0
			
			If Li != 80
				Roda(cbcont,cbtxt)
			EndIf
			
			/* Ao sair do for nao imprime novamente o resumo geral. */
			lImprimir := .F.
		EndIf
	Next nB
	
	DbSelectArea("DTX")
	DbSkip()
EndDo

If lImprimir
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o cabecalho e a linha de detalhe.                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If li > 64
		Li := Cabec(Titulo, STR0028, STR0029, NomeProg, Tamanho) //"Todos os Manifestos"###"Todas as Viagens"
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Resumo Geral do Manifesto.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RTmsR04Resumo("G", nGValMercC, nGValFretC, nGVarNTriC, nGVarTribC, nGValICMC, nGVolsC,;
	nGPesoC, nGCtrcsC, nGValMercF, nGValFretF, nGVarNTriF, nGVarTribF, nGValICMF, nGVolsF,;
	nGPesoF, nGCtrcsF, nGPesoCobF, nGPesoCobC)
	
	If Li != 80
		Roda(cbcont,cbtxt)
	EndIf
EndIf

If aReturn[5] == 1
	Set Printer TO
	dbCommitall()
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTmsr04Cab³ Autor ³ Robson Alves          ³ Data ³20.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta no array o cabecalho do relatorio.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTmsr04Cabec(ExpA1,ExpC2)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array para montar o cabecalho.                     ³±±
±±³          ³ ExpA2 = Titulo do relatorio.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTmsr04                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTmsR04Cabec(aCabecalho, Titulo)
Local nAux  := 0
Local bLacre := {|| NIL }
Local cLacre := ""
Local cChave := ""

DVB->( dbSetOrder( 1 ) )

aCabecalho := {}         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a 1o linha do cabecalho.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCabecalho, AllTrim(SM0->M0_NOMECOM))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a 2o linha do cabecalho.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCabecalho, AllTrim(SM0->M0_ENDCOB) + " - " + AllTrim(SM0->M0_BAIRCOB) + " - " +; // " - "
AllTrim(SM0->M0_ESTCOB) + " - " + STR0012 + AllTrim(SM0->M0_CEPCOB) + " - " + STR0013 +; // " - Cep : " / " - Cgc : "
Transform(SM0->M0_CGC, PesqPict("SA1", "A1_CGC")) + " - " + STR0014 +; // "IE : "
Transform(SM0->M0_CGC, PesqPict("SA1", "A1_INSCR")))

Aadd(aCabecalho, " ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le o DTR (Veiculos da Viagem)                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("DTR")
dbSetOrder(1)
MsSeek(xFilial("DTR") + DTX->(DTX_FILORI + DTX_VIAGEM))

While !Eof() .And. DTR->(DTR_FILIAL+DTR_FILORI+DTR_VIAGEM) == xFilial("DTR")+DTX->(DTX_FILORI+DTX_VIAGEM)
	
	dbSelectArea("DA3")
	dbSetOrder(1)
	If MsSeek(xFilial("DA3") + DTR->DTR_CODVEI)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta uma linha com os dados do Veiculo                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aCabecalho, if(nAux==0, STR0015 + " :", Space(Len(STR0015 + " :"))) + ; // "Veiculo   "
		StrZero(++nAux, 1) + "-" + DA3->DA3_COD + " - " + Padr( DA3->DA3_DESC, Len( DA4->DA4_NOME ) ) + " " + STR0017 +; // " - " / " - Tipo : "
		Posicione("DUT",1,xFilial("DUT")+DA3->DA3_TIPVEI,"DUT_DESCRI")  + " " + STR0018 + DA3->DA3_PLACA +; // "Placa : "
		" " + STR0019 + DA3->DA3_MUNPLA + " " + DA3->DA3_ESTPLA) // "Cidade Placa : " / " - "
		
 		cLacre := ""

		If DVB->(MsSeek( cChave := xFilial( "DVB" ) + DTR->DTR_FILORI + DTR->DTR_VIAGEM + DTR->DTR_CODVEI ))
	        DVB->( dbEval( {||cLacre += AllTrim(DVB->DVB_LACRE)+"/"} ,, {||DVB->(!Eof()) .AND. DVB->DVB_FILIAL + DVB->DVB_FILORI + DVB->DVB_VIAGEM + DVB->DVB_CODVEI == cChave} ) )
	 	EndIf
		
		aCabecalho[Len(aCabecalho)] += "   " + STR0033 + SubStr( cLacre,1,Len( cLacre ) - 1 )
	EndIf
	
	If !Empty(DTR->DTR_CODRB1) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB1))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta uma linha com os dados do 1o. Reboque                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aCabecalho, if(nAux==0, STR0015 + " :", Space(Len(STR0015 + " :"))) + ; // "Veiculo   "
		StrZero(++nAux, 1) + "-" + DA3->DA3_COD + " - " + Padr( DA3->DA3_DESC, Len( DA4->DA4_NOME ) ) + " " + STR0017 +; // " - " / " - Tipo : "
		Posicione("DUT",1,xFilial("DUT")+DA3->DA3_TIPVEI,"DUT_DESCRI")  + " " + STR0018 + DA3->DA3_PLACA +; // "Placa : "
		" " + STR0019 + DA3->DA3_MUNPLA + " " + DA3->DA3_ESTPLA) // "Cidade Placa : " / " - "

 		cLacre := ""
 		
		If DVB->(MsSeek( cChave := xFilial( "DVB" ) + DTR->DTR_FILORI + DTR->DTR_VIAGEM + DTR->DTR_CODVEI ))
	        DVB->( dbEval( {||cLacre += AllTrim(DVB->DVB_LACRE)+"/"} ,, {||DVB->(!Eof()) .AND. DVB->DVB_FILIAL + DVB->DVB_FILORI + DVB->DVB_VIAGEM + DVB->DVB_CODVEI == cChave} ) )
	 	EndIf
		
		aCabecalho[Len(aCabecalho)] += "   " + STR0033 + SubStr( cLacre,1,Len( cLacre ) - 1 )

	EndIf
	
	If !Empty(DTR->DTR_CODRB2) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB2))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Monta uma linha com os dados do 2o. Reboque                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aCabecalho, if(nAux==0, STR0015 + " :", Space(Len(STR0015 + " :"))) + ; // "Veiculo   "
		StrZero(++nAux, 1) + "-" + DA3->DA3_COD + " - " + Padr( DA3->DA3_DESC, Len( DA4->DA4_NOME ) ) + " " + STR0017 +; // " - " / " - Tipo : "
		Posicione("DUT",1,xFilial("DUT")+DA3->DA3_TIPVEI,"DUT_DESCRI")  + " " + STR0018 + DA3->DA3_PLACA +; // "Placa : "
		" " + STR0019 + DA3->DA3_MUNPLA + " " + DA3->DA3_ESTPLA) // "Cidade Placa : " / " - "

 		cLacre := ""

		If DVB->(MsSeek( cChave := xFilial( "DVB" ) + DTR->DTR_FILORI + DTR->DTR_VIAGEM + DTR->DTR_CODVEI ))
	        DVB->( dbEval( {||cLacre += AllTrim(DVB->DVB_LACRE)+"/"} ,, {||DVB->(!Eof()) .AND. DVB->DVB_FILIAL + DVB->DVB_FILORI + DVB->DVB_VIAGEM + DVB->DVB_CODVEI == cChave} ) )
	 	EndIf
		
		aCabecalho[Len(aCabecalho)] += "   " + STR0033 + SubStr( cLacre,1,Len( cLacre ) - 1 )

	EndIf
	
	dbSelectArea("DTR")
	dbSkip()
EndDo

Aadd(aCabecalho, " ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le o DUP (Motoristas da Viagem)                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("DUP")
dbSetOrder(1)
MsSeek(xFilial("DUP") + DTX->(DTX_FILORI + DTX_VIAGEM))

nAux := 0

While !Eof() .And. DUP->(DUP_FILIAL+DUP_FILORI+DUP_VIAGEM) == xFilial("DUP")+DTX->(DTX_FILORI+DTX_VIAGEM)
	
	dbSelectArea("DA4")
	dbSetOrder(1)
	If MsSeek(xFilial("DA4") + DUP->DUP_CODMOT)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta uma linha para cada registro do mesmo tipo(Motorista).          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aCabecalho, if(nAux==0, STR0020 + " :", Space(Len(STR0020 + " :"))) +; // "Motorista "
		StrZero(++nAux, 1) + "-" + Padr( DA4->DA4_COD, Len( DA3->DA3_COD ) ) + " " + DA4->DA4_NOME + "   " + STR0021 +; // "CNH : "
		DA4->DA4_NUMCNH)
	EndIf
	
	dbSelectArea("DUP")
	dbSkip()
EndDo

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTmsr04Res³ Autor ³ Robson Alves          ³ Data ³20.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime l Manifesto de Carga.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTmsr04Resumo(ExpN01,ExpN02,ExpN03,ExpN04,ExpN05,ExpN06,)  ³±±
±±³          ³ ExpN07,ExpN08,ExpN09,ExpN10,ExpN11,ExpN12,ExpN13,ExpN14,   ³±±
±±³          ³ ExpN15,ExpN16)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN01 = Valor Mercadoria CIF.                             ³±±
±±³          ³ ExpN02 = Valor do Frete CIF.                               ³±±
±±³          ³ ExpN03 = Valor nao Tributavel CIF.                         ³±±
±±³          ³ ExpN04 = Valor Tributavel CIF.                             ³±±
±±³          ³ ExpN05 = Valor do ICMS CIF.                                ³±±
±±³          ³ ExpN06 = Volumes CIF.                                      ³±±
±±³          ³ ExpN07 = Peso Liquido CIF.                                 ³±±
±±³          ³ ExpN08 = Numero de Conhecimentos CIF.                      ³±±
±±³          ³ ExpN09 = Valor Mercadoria FOB.                             ³±±
±±³          ³ ExpN10 = Valor do Frete FOB.                               ³±±
±±³          ³ ExpN11 = Valor nao Tributavel FOB.                         ³±±
±±³          ³ ExpN12 = Valor Tributavel FOB.                             ³±±
±±³          ³ ExpN13 = Valor do ICMS FOB.                                ³±±
±±³          ³ ExpN14 = Volumes FOB.                                      ³±±
±±³          ³ ExpN15 = Peso Liquido FOB.                                 ³±±
±±³          ³ ExpN16 = Numero de Conhecimentos FOB.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTmsr04                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTmsR04Resumo(cTipo, nValMercC, nValFreteC, nVarNTribC, nVarTribC, nValICMC, nVolsC,;
nPesoC, nCtrcsC, nValMercF, nValFreteF, nVarNTribF, nVarTribF,	nValICMF, nVolsF,;
nPesoF, nCtrcsF, nPesoCobF, nPesoCobC)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o layout do resumo do manifesto.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//"              Valor Mercadoria          Valor Frete          Valor N. Tributavel          Valor Tributavel          Valor ICMS          Vols.          Peso Real          Peso Cob.          CTRCs"
//              99,999,999,999.99    99,999,999,999.99            99,999,999,999.99         99,999,999,999.99      999,999,999.99          99999       999,999.9999       999,999.9999          xxxxx

Li += 2
If (cTipo == "G")
	@ Li, 00 PSay STR0016 // "********************************************************************** R E S U M O  G E R A L  D O  M A N I F E S T O ****************************************************************************"
Else
	@ Li, 00 PSay STR0022 // "**************************************************************************** R E S U M O  D O  M A N I F E S T O *********************************************************************************"
EndIf
Li += 1

@ Li, 00 PSay STR0023 // "              Valor Mercadoria          Valor Frete          Valor N. Tributavel          Valor Tributavel          Valor ICMS          Vols.          Peso Real          Peso Cob.          CTRCs"
Li += 1
@ Li, 00 PSay STR0024 // "**************************************************************************************************************************************************************************************************"
Li += 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o linha de detalhe do resumo do manifesto.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ Li, 000 PSay STR0025 // "C I F"
@ Li, 013 PSay Transform(nValMercC , PesqPict("DT6", "DT6_VALMER"))
@ Li, 034 PSay Transform(nValFreteC, PesqPict("SF2", "F2_VALFAT"))
@ Li, 063 PSay Transform(nVarNTribC, PesqPict("DT6", "DT6_VALMER"))
@ Li, 089 PSay Transform(nVarTribC , PesqPict("DT6", "DT6_VALMER"))
@ Li, 112 PSay Transform(nValICMC  , PesqPict("SF2", "F2_VALICM"))
@ Li, 137 PSay Transform(nVolsC    , PesqPict("DT6", "DT6_QTDVOL"))
@ Li, 148 PSay Transform(nPesoC,PesqPict("DT6", "DT6_PESO"))
@ Li, 167 PSay Transform(nPesoCobC,PesqPict("DT6", "DT6_PESO"))
@ Li, 189 PSay nCtrcsC
Li +=1

@ Li, 000 PSay STR0026 // "F O B"
@ Li, 013 PSay Transform(nValMercF , PesqPict("DT6", "DT6_VALMER"))
@ Li, 034 PSay Transform(nValFreteF, PesqPict("SF2", "F2_VALFAT"))
@ Li, 063 PSay Transform(nVarNTribF, PesqPict("DT6", "DT6_VALMER"))
@ Li, 089 PSay Transform(nVarTribF , PesqPict("DT6", "DT6_VALMER"))
@ Li, 112 PSay Transform(nValICMF  , PesqPict("SF2", "F2_VALICM"))
@ Li, 137 PSay transform(nVolsF    , PesqPict("DT6", "DT6_QTDVOL"))
@ Li, 148 PSay Transform(nPesoF,PesqPict("DT6", "DT6_PESO"))
@ Li, 167 PSay Transform(nPesoCobF,PesqPict("DT6", "DT6_PESO"))
@ Li, 189 PSay nCtrcsF
Li +=1

@ Li, 000 PSay STR0027 // "T O T A L"
@ Li, 013 PSay Transform((nValMercC  + nValMercF) , PesqPict("DT6", "DT6_VALMER"))
@ Li, 034 PSay Transform((nValFreteC + nValFreteF), PesqPict("SF2", "F2_VALFAT"))
@ Li, 063 PSay Transform((nVarNTribC + nVarNTribF), PesqPict("DT6", "DT6_VALMER"))
@ Li, 089 PSay Transform((nVarTribC  + nVarTribF) , PesqPict("DT6", "DT6_VALMER"))
@ Li, 112 PSay Transform((nValICMC   + nValICMF)  , PesqPict("SF2", "F2_VALICM"))
@ Li, 137 PSay Transform((nVolsC + nVolsF), PesqPict("DT6", "DT6_QTDVOL"))
@ Li, 148 PSay Transform((nPesoC + nPesoF),PesqPict("DT6", "DT6_PESO"))
@ Li, 167 PSay Transform((nPesoCobC + nPesoCobF),PesqPict("DT6", "DT6_PESO"))
@ Li, 189 PSay (nCtrcsC + nCtrcsF)
Li +=1

Return Nil
