#INCLUDE "protheus.ch"
#INCLUDE "Rtmsr01.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR01  ³ Autor ³Patricia A. Salomao    ³ Data ³14.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conhecimento de Transporte Rodoviario de Carga             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR01                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gestao de Transporte                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR01()

Local cSelFis := SuperGetMv('MV_SELFIS')
Local cSeloFis:= ""
Local cSerSelo:= ""
LOCAL titulo  := STR0001 //"Impressao do Conhecimento de Transporte"
LOCAL cString := "DTP"
LOCAL wnrel   := "RTMSR01"
LOCAL cDesc1  := STR0002 //"Este programa ira listar o Conhecimento de Transporte"
LOCAL cDesc2  := STR0003 //"Rodoviario de Carga."
LOCAL cDesc3  := ""
LOCAL tamanho := "M"
LOCAL aOrd    := {STR0007,STR0008} //"Documento"###"Nota Fiscal"
Local nZ      :=0

PRIVATE aReturn  := {STR0004,1,STR0005,2, 2, 1, "",1 } //"Zebrado"###"Administracao"
PRIVATE cPerg    := "RTMR01"
PRIVATE nLastKey := 0
PRIVATE aParamRl := Array(20)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ aParamRl[01]        	// Lote Inicial 		                 ³
//³ aParamRl[02]        	// Lote Final         	         	  ³
//³ aParamRl[03]        	// Documento De 		      		     ³
//³ aParamRl[04]        	// Documento Ate      		           ³
//³ aParamRl[05]        	// Serie De     	   		           ³
//³ aParamRl[06]        	// Serie Ate            	           ³
//³ aParamRl[07]        	// Impressao / Reimpressao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("RTMR01",.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

For nz:=1 to 20
	aParamRl[nz]:=&("mv_par"+StrZero(nz,2))
Next nz

//-- Obtem o nr. do selo fiscal, se a filial estiver contida no parametro
If	cFilAnt $ cSelFis
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas como parametros                                  ³
	//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	//³ MV_PAR01	// Selo Fiscal   ?                                         ³
	//³ MV_PAR02	// Serie do Selo ?                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	PutSx1( "TMA200", "02","Serie Selo ?","¿Serie Sello?","Seal Series?","mv_ch2","C" ,3,0,0,"G","","","","","mv_par02","","","","","")

	If	Pergunte('TMA200',.T.)
		cSeloFis := mv_par01
		cSerSelo := mv_par02
	Else
		Return
	EndIf
EndIf

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR01Imp(@lEnd,wnRel,titulo,tamanho,cSelFis,cSeloFis,cSerSelo)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR01Imp³ Autor ³Patricia A. Salomao    ³ Data ³14.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR01			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR01Imp(lEnd,wnRel,titulo,tamanho,cSelFis,cSeloFis,cSerSelo)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lFirstSelo    := .T.
Local  cLotNfc      := ""
Local  nLin         := 80
Local  cStatus      := "3/4"
Local  aPicICM      := {}
Local  aEnder       := {}
Local  nTotal       := 0
Local  lAgrega 	  := .F. 
Local  aCompFrete   := Array(12,2)      
Local  cNumNotas    := ""
Local  cNumCot      := ""
Local  bCondDTC     := {|| }
Local  aObservacoes := Array(6)
Local  aDoctos      := {}
Local  bWhile       := {|| }
Local  nOrdDT6      := 0
Local  nCnt         := 0
Local  nOrdem       := aReturn[8]
Local nX            :=0

Private cNomRem     := cEndRem    := cCEPRem    := cMunRem    := cEstRem    := cCGCRem    := cInscRem    := ""
Private cNomDev     := cEndDev    := cCEPDev    := cMunDev    := cEstDev    := cCGCDev    := cInscDev    := ""
Private cNomDes     := cEndDes    := cCEPDes    := cMunDes    := cEstDes    := cCGCDes    := cInscDes    := cEndEnt := ""
Private cNomCONDPC  := cEndCONDPC := cCEPCONDPC := cMunCONDPC := cEstCONDPC := cCGCCONDPC := cInscCONDPC := ""
Private cDevFrete   := cTipFrete  := cDestCalc  := ""

SM0->(MsSeek(cEmpAnt+cFilAnt, .T.))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta Arquivo de Trabalho                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("DTP")
dbSetOrder(2)
MsSeek(xFilial("DTP") + cFilAnt + aParamRl[01], .T.)
SetRegua(LastRec())

Do While !Eof() .And. (DTP_FILIAL+DTP_FILORI==xFilial("DTP")+cFilAnt) .And. (DTP_LOTNFC <= aParamRl[02])
	
	IncRegua()
	
	If Interrupcao(@lEnd)
		Exit
	Endif
	
	If !(DTP->DTP_STATUS $ cStatus)
		DTP->(dbSkip())
		Loop
	EndIf
	
	aDoctos := {}
	cLotNfc := DTP_LOTNFC
	cFilOri := DTP_FILORI
	
	If nOrdem == 1 //-- Documento
		bWhile  := { || DT6->(!Eof()) .And. DT6->DT6_FILIAL + DT6->DT6_FILORI + DT6->DT6_LOTNFC == xFilial("DT6")+aDoctos[nCnt] }
		nOrdDT6 := 2
		Aadd( aDoctos, cFilOri + cLotNfc )
	ElseIf nOrdem == 2 //-- Nota Fiscal
		bWhile  := { || DT6->(!Eof()) .And. DT6->DT6_FILIAL + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE == xFilial("DT6")+aDoctos[nCnt] }
		nOrdDT6 := 1
		cIndex  := CriaTrab(NIL,.F.)
		cFiltro := " DTC->DTC_FILIAL == '" + xFilial("DTC")  + "' "
		cFiltro += " .And. DTC->DTC_FILORI == '" + cFilOri + "' "
		cFiltro += " .And. DTC->DTC_LOTNFC == '" + cLotNfc + "' "
		IndRegua('DTC',cIndex,'DTC_FILIAL+DTC_FILORI+DTC_NUMNFC',,cFiltro,STR0013,.F.) //"Selecionando Registros..."
			
		While DTC->(!Eof())
			If Ascan( aDoctos, { |x| x == DTC->DTC_FILDOC + DTC->DTC_DOC + DTC->DTC_SERIE } ) == 0
				Aadd( aDoctos, DTC->DTC_FILDOC + DTC->DTC_DOC + DTC->DTC_SERIE )
			EndIf
			DTC->(DbSkip())
		EndDo
	
		RetIndex("DTC")
		If	File(cIndex+OrdBagExt())
			Ferase(cIndex+OrdBagExt())
		EndIf
	EndIf

	For nCnt := 1 To Len(aDoctos)

		dbSelectArea("DT6")
		dbSetOrder(nOrdDT6)
		MsSeek(xFilial("DT6")+aDoctos[nCnt])
	
		Do While Eval(bWhile)
			If (DT6_FIMP == '1' .And. aParamRl[07]==1) .Or. !(DT6->DT6_DOCTMS $ '26789AE')			
				dbSkip()
				loop
			EndIf
			If ((DT6_DOC < aParamRl[03]) .Or. (DT6_DOC > aParamRl[04])) .Or. ((DT6_SERIE < aParamRl[05]) .Or. (DT6_SERIE > aParamRl[06])) .Or.;			
				(DT6_SERIE == "PED")
				dbSkip()
				Loop
			EndIf

			//-- Obtem o nr. do selo fiscal, se a filial estiver contida no parametro	
			If	cFilAnt $ cSelFis
				// Nao soma um item no primeiro selo
				If	!lFirstSelo
					cSeloFis := Soma1(cSeloFis)					
				EndIf
				If lFirstSelo
					lFirstSelo:=.F.
				EndIf
			EndIf
			
			// Busca as notas do cliente para o 1o percurso.
			If DT6->DT6_PRIPER == StrZero(1, Len(DT6->DT6_PRIPER))
				bCondDTC := {|| !DTC->(Eof()) .And. DTC->(DTC_FILIAL+DTC_FILDOC+DTC_DOCPER+DTC_SERIE) ==;
				DT6->(DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE)}
				
				RTmsr01NFCli(4, bCondDTC, @cNumNotas, @cNumCot, @aEnder)
				
				// Busca as notas do cliente para o 2o percurso.
			Else
				bCondDTC := {|| !DTC->(Eof()) .And. DTC->(DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE) ==;
				DT6->(DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE)}
				
				RTmsr01NFCli(3, bCondDTC, @cNumNotas, @cNumCot, @aEnder)
			EndIf
			
			//-- Itens da Nota Fiscal de Saida
			SD2->(dbSetOrder(3))
			SD2->(MsSeek(xFilial("SD2")+DT6->(DT6_DOC + DT6_SERIE)))
			cCodPro := SD2->D2_COD
			
			aAreaSD2 := SD2->(GetArea())
			SD2->( DbEval( { || IIF(!SD2->(Eof()) .And. D2_PICM <> 0,AADD(aPicICM, Transform(SD2->D2_PICM,PesqPict('SD2','D2_PICM'))) ,.T.) },, ;
			{ || D2_FILIAL+D2_DOC + D2_SERIE == ;
			xFilial("SD2")+DT6->DT6_DOC + DT6->DT6_SERIE } ) )
			RestArea(aAreaSD2)
			
			//-- Nota Fiscal de Saida
			SF2->(dbSetOrder(1))
			SF2->(MsSeek(xFilial("SF2")+DT6->(DT6_DOC + DT6_SERIE)))
			
			//-- Verifica os dados dos Clientes
			RTMSR01DT6()

			//-- Imprime cabecalho com dados do Emitente
			RTMSR01Cabec(@nLin)
			
			//-- Imprime dados do Remetente / Devedor do Frete
			nLin+=1
			@ nLin,000 PSay cNomRem    //--Nome Rem
			@ nLin,046 PSay cNomDev    //--Nome Devedor
			nLin+=1
			@ nLin,000 PSay cEndRem    //-- Endereco Remetente
			@ nLin,046 PSay cEndDev	   //-- Endereco Devedor
			nLin+=1
			@ nLin,000 PSay cCEPRem+ "  " + AllTrim(cMunRem)+"/"+cEstRem  //--CEP/Municipio/Est. Remetente
			@ nLin,046 PSay cCEPDev+ "  " + AllTrim(cMunDev)+"/"+cEstDev  //--CEP/Municipio/Est. Remetente
			nLin+=1
			@ nLin,000 PSay cCGCRem+ "  " + cInscRem  //-- CGC/Inscricao Remetente
			@ nLin,046 PSay cCGCDev+ "  " + cInscDev  //-- CGC/Inscricao Devedor
			nLin+=2
			
			@ nLin,000 PSay cNomDes  //--Nome Destinatario
			
			//-- Redespacho / Consignatario
			If cDevFrete=="4"
				@ nLin,046 PSay "XX"
			ElseIf cDevFrete=="3"
				@ nLin,061 PSay "XX"
			EndIf
			
			//-- CIF / FOB
			If cTipFrete == "1"
				@ nLin,087 PSay "XX"
			Else
				@ nLin,095 PSay "XX"
			EndIf
	
			nLin+=1
			@ nLin,000 PSay cEndDes     //--Endereco Destinatario
			@ nLin,046 PSay cNomCONDPC //-- Nome Consignatario ou Despachante
			nLin+=1
			@ nLin,000 PSay cCEPDes + "  " + AllTrim(cMunDes)+"/"+cEstDes //--CEP/Municipio/Est.
			@ nLin,046 PSay cEndCONDPC //-- End. Consignatario ou Despachante
			nLin+=1
			@ nLin,000 PSay cCGCDes+ "  " + cInscDes	//-- CGC/Inscricao Destinatario
			@ nLin,046 PSay cCEPCONDPC + "  " + AllTrim(cMunCONDPC)+" "+cEstCONDPC //--CEP/Municipio/Est. Consig. ou Despach.
			nLin+=1
			@ nLin,046 PSay cCGCCONDPC+ "  " + cInscCONDPC	//-- CGC/Inscricao do Consig. ou Despach.
			
			nLin+=1
			//-- Imprime Endereco para Coleta
			@ nLin,000 PSay cEndRem    //-- Endereco Coleta
			//-- CIF / FOB
			If cTipFrete == "1"
				@ nLin,048 PSay "XX"
			Else
				@ nLin,057 PSay "XX"
			EndIf
			@ nLin,071 PSay cDestCalc	//-- Destino de Calculo
			
			@ nLin++,000 PSay cCEPRem+ "  " + AllTrim(cMunRem)+"/"+cEstRem //-- CEP/Municipio/Est. Coleta
			@ nLin++,000 PSay cCGCRem+ "  " + cInscRem //-- CGC/Inscricao Coleta
			
			//-- Tipo de Transporte : Rodoviario/Aereo
			If DC5->(MsSeek(xFilial("DC5")+DTC->DTC_SERVIC))
				If DC5->DC5_TIPTRA == '1'
					@ nLin,047 PSay "XX"
				ElseIf DC5->DC5_TIPTRA == '2'
					@ nLin,067 PSay "XX"
				EndIf
			EndIf
			
			aEval(aCompFrete, {|x| x[1]:= ""})
			aEval(aCompFrete, {|x| x[2]:=  0})
			nX := 1
			DT8->(dbSetOrder(2))
			DT8->(MsSeek(xFilial("DT8")+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
			Do While !DT8->(Eof()) .And. DT8->(DT8_FILIAL+DT8_FILDOC+DT8_DOC+DT8_SERIE) == DT6->(DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE)
				If nX > 10
					Exit
				EndIf
				If DT8->DT8_CODPAS <> "TF"
					aCompFrete[nx][1] := DT8->DT8_CODPAS
				EndIf
				nX++
				DT8->(dbSkip())
			EndDo
			
			nX     := 1
			nTotal := 0
			DT8->(MsSeek(xFilial("DT8")+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
			Do While !DT8->(Eof()) .And. DT8->(DT8_FILIAL+DT8_FILDOC+DT8_DOC+DT8_SERIE) == DT6->(DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE)
				nZ := nX
				If DT9->(MsSeek(xFilial("DT9")+DT6->DT6_NCONTR+DT8->DT8_CODPAS))
					nX := Ascan(aCompFrete, {|x| x[1] == DT9->DT9_AGRPAS })
					If nX > 0
						lAgrega := .T.
						nX      := Val(DT9->DT9_AGRPAS)
					Else
						lAgrega := .F.
						nX      := nZ
					EndIf
				EndIf
				If DT8->DT8_CODPAS <> "TF"
					If nX <= 10
						aCompFrete[nx][1] := IIf(!lAgrega,DT8->DT8_CODPAS,aCompFrete[nx][1])
						aCompFrete[nx][2] += DT8->DT8_VALTOT
					Else
						aCompFrete[11][1] := "XX"
						aCompFrete[11][2] += DT8->DT8_VALTOT
						nTotal += DT8->DT8_VALTOT
					EndIf
					nTotal += DT8->DT8_VALTOT
				Else
					aCompFrete[12][1] := "TF"
					aCompFrete[12][2] :=  nTotal
				EndIf
				nX := nZ
				nX++
				DT8->(dbSkip())
			EndDo
			
			//-- Endereco para Entrega
			@ nLin++,000 PSay cEndEnt
			nLin++
			
			//-- Pesquisa Grupo do Produto
			SB1->(dbSetOrder(1))
			If SB1->(dbSeek(xFilial("SB1")+DTC->DTC_CODPRO))
				SBM->(dbSetOrder(1))
				If SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))
					@ nLin,048 PSay SubStr(SBM->BM_DESC,1,20) Picture PesqPict("SBM","BM_DESC")
					nLin++
				EndIf
			EndIf
			
			@ nLin,048 PSay DTC->DTC_CODEMB   Picture PesqPict("DTC","DTC_CODEMB")
			@ nLin,071 PSay aCompFrete[1][2]  Picture PesqPict("DT8","DT8_VALPAS")
			nLin++
			@ nLin,048 PSay DT6->DT6_QTDVOL   Picture PesqPict("DT6","DT6_QTDVOL")
			@ nLin,071 PSay aCompFrete[2][2]  Picture PesqPict("DT8","DT8_VALPAS")
			nLin++
			@ nLin,000 PSay cNumNotas
			@ nLin,071 PSay aCompFrete[3][2]  Picture PesqPict("DT8","DT8_VALPAS")
			nLin++
			@ nLin,048 PSay DT6->DT6_PESO     Picture PesqPict("DT6","DT6_PESO")
			@ nLin,071 PSay aCompFrete[4][2]  Picture PesqPict("DT8","DT8_VALPAS")
			nLin++
			@ nLin,048 PSay DT6->DT6_PESOM3   Picture PesqPict("DT6","DT6_PESOM3")
			@ nLin,071 PSay aCompFrete[5][2]  Picture PesqPict("DT8","DT8_VALPAS")
			nLin++
	
			RTMSR01Obs(@aObservacoes)
	
			@ nLin,000 PSay aObservacoes[1]
			@ nLin,048 PSay DT6->DT6_VALMER   Picture PesqPict("DT6","DT6_VALMER")
			@ nLin,071 PSay aCompFrete[6][2]  Picture PesqPict("DT8","DT8_VALPAS")
			nLin++
			@ nLin,000 PSay aObservacoes[2]
			@ nLin,048 PSay DTC->DTC_BASSEG   Picture PesqPict("DTC","DTC_BASSEG")
			@ nLin,071 PSay aCompFrete[7][2]  Picture PesqPict("DT8","DT8_VALPAS")
			nLin++
			@ nLin,000 PSay aObservacoes[3]
			@ nLin,048 PSay DT6->DT6_TABFRE+DT6->DT6_TIPTAB+DT6->DT6_SEQTAB
			@ nLin,071 PSay aCompFrete[8][2]  Picture PesqPict("DT8","DT8_VALPAS")
			nLin++
			@ nLin,000 PSay aObservacoes[4]
			@ nLin,048 PSay DTC->DTC_CTRDPC
			@ nLin,071 PSay aCompFrete[9][2]  Picture PesqPict("DT8","DT8_VALPAS")
			nLin++
			@ nLin,000 PSay aObservacoes[5]
			@ nLin,071 PSay aCompFrete[10][2] Picture PesqPict("DT8","DT8_VALPAS")
			nLin++
			@ nLin,000 PSay aObservacoes[6]
			@ nLin,071 PSay aCompFrete[11][2] Picture PesqPict("DT8","DT8_VALPAS")
			nLin+=3
			@ nLin,080 PSay aCompFrete[12][2] Picture PesqPict("DT8","DT8_VALPAS")
			nLin+=2
			@ nLin,071 PSay SD2->D2_CF        Picture PesqPict("SD2","D2_CF")
			nLin++
			@ nLin,052 PSay SF2->F2_BASEICM   Picture PesqPict("SF2","F2_BASEICM")
			If Len(aPicICM) > 0
				@ nLin,071 PSay aPicICM[1]
			Else
				@ nLin,071 PSay 0 Picture PesqPict("SD2","D2_PICM")
			EndIf
			nLin++
			@ nLin,052 PSay SF2->F2_VALICM  Picture PesqPict("SF2","F2_VALICM")
			@ nLin,071 PSay DT6->DT6_DATEMI
			@ nLin,084 PSay DT6->DT6_HOREMI Picture PesqPict("DT6","DT6_HOREMI")
			nLin+=2
			@ nLin,071 PSay cFilAnt
			@ nLin,080 PSay DT6->DT6_DOC
			
			If !Empty(cSeloFis) .And. !Empty(cSerSelo)
				nLin+=1
				@ nLin,071 PSay cSeloFis
				@ nLin,082 PSay cSerSelo
			Else
				nLin+=1
			Endif	

			nLin+=2
			@ nLin,010 PSay STR0009 + DTP->DTP_LOTNFC //"Lote : "
			@ nLin,026 PSay STR0006 //"Endereco(s) :  "
			If Len(aEnder) > 0
				nCol := 42
				For nX := 1 to  Len(aEnder)
					@ nLin,nCol PSay aEnder[nX]
					nCol+=Len(aEnder[nX])+1
				Next
			EndIf
			
			// Imprime o numero da cotacao.
			If !Empty(cNumCot)
				nLin += 1
				@ nLin, 010 PSay STR0010 + cNumCot //"No. Cotacao : "
			EndIf
			
			//-- Atualiza campo DT6_FIMP (Flag de Impressao)
			RecLock("DT6", .F.)
			DT6_FIMP := "1"
			DT6->DT6_SELFIS := cSeloFis
			MsUnlock()
			
			DT6->(dbSkip())
		EndDo
	Next nCnt
	
	dbSelectArea("DTP")
	dbSkip()
	
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

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR01Cab³ Autor ³Patricia A. Salomao    ³ Data ³14.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime Cabecalho com os Dados da Empresa                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR01Cabec(ExpN1)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpN1 - No. da Linha                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR01			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR01Cabec(nLin) 
Local cQuery    := ""
Local cAliasNew := "" 

If SA2->(FieldPos("A2_RNTRC")) > 0

	cAliasNew := GetNextAlias()
	
	cQuery := "SELECT DA3_FROVEI,A2_RNTRC,A2_DTRNTRC "
	cQuery += " FROM " + RetSqlName("DT6") + " DT6 "
	cQuery += " INNER JOIN " + RetSqlName("DTR") + " DTR ON "
	cQuery += " DT6.DT6_FILIAL = DTR.DTR_FILIAL AND "
	cQuery += " DT6.DT6_FILVGA = DTR.DTR_FILORI AND "
	cQuery += " DT6.DT6_NUMVGA = DTR.DTR_VIAGEM "
	cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON "
	cQuery += " DTR.DTR_CODFOR = SA2.A2_COD AND "
	cQuery += " DTR.DTR_LOJFOR = SA2.A2_LOJA "
	cQuery += " INNER JOIN " + RetSqlName("DA3") + " DA3 ON "
	cQuery += " DTR.DTR_CODVEI = DA3.DA3_COD "
	cQuery += " WHERE DT6.DT6_FILIAL = '" + DT6->DT6_FILIAL + "' AND "
	cQuery += " DT6.DT6_FILVGA = '" + DT6->DT6_FILVGA + "' AND "
	cQuery += " DT6.DT6_NUMVGA = '" + DT6->DT6_NUMVGA + "' "

	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasNew, .F., .T. )			
	
EndIf

nLin:=0
@ 00,00 PSAY AvalImp(132)

@nLin++,021 PSay SM0->M0_CODFIL+" "+SM0->M0_FILIAL+" "+SM0->M0_NOME
@nLin++,021 PSay SM0->M0_ENDCOB
@nLin++,021 PSay SM0->M0_CEPCOB+" "+SM0->M0_ENDCOB+" "+SM0->M0_ESTCOB
@nLin++,021 PSay SM0->M0_TEL+" "+SM0->M0_FAX
@nLin++,021 PSay SM0->M0_CGC+" "+SM0->M0_INSC

If SA2->(FieldPos("A2_RNTRC")) > 0
	If (cAliasNew)->DA3_FROVEI == StrZero(1, Len(DA3->DA3_FROVEI))
		@nLin++,021 PSay SM0->M0_RNTRC
		@nLin++,021 PSay SM0->M0_DTRNTRC
	Else
		@nLin++,021 PSay (cAliasNew)->A2_RNTRC
		@nLin++,021 PSay StoD((cAliasNew)->A2_DTRNTRC)
	EndIf
EndIf

nLin+=3

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR01DT6³ Autor ³Patricia A. Salomao    ³ Data ³14.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica todos os clientes                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR01DT6()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR01			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR01DT6()

Local aAreaDT6  := DT6->(GetArea())		
Local aCliCalc  := {}
Local cImpDev   := ""

//-- Dados do Consignatario                         
cNomCONDPC  := cEndCONDPC := cCEPCONDPC := cMunCONDPC := cEstCONDPC := cCGCCONDPC := cInscCONDPC := ""

cDevFrete := DT6->DT6_DEVFRE
cTipFrete := DT6->DT6_TIPFRE

//-- Dados do Remetente
SA1->(dbSetOrder(1))
SA1->(MsSeek(xFilial()+DT6->DT6_CLIREM+DT6->DT6_LOJREM))
cNomRem  := SA1->A1_NOME
cEndRem  := SA1->A1_END
cCEPRem  := SA1->A1_CEP
cMunRem  := SA1->A1_MUN
cEstRem  := SA1->A1_ESTADO
cCGCRem  := SA1->A1_CGC
DV3->(dbSetOrder(1))
If DV3->(MsSeek(xFilial("DV3") + DTC->DTC_CLIREM + DTC->DTC_LOJREM + If(DTC->(FieldPos("DTC_SQIREM"))>0,DTC->DTC_SQIREM,'')))
	cInscRem := DV3->DV3_INSCR
Else
	cInscRem := SA1->A1_INSCR
EndIf		
If cDevFrete == "1"
	cInscDev := cInscRem
EndIf

//-- Dados do Destinatario
SA1->(MsSeek(xFilial()+DT6->DT6_CLIDES+DT6->DT6_LOJDES))
cNomDes  := SA1->A1_NOME
cEndDes  := SA1->A1_END
cCEPDes  := SA1->A1_CEP
cMunDes  := SA1->A1_MUN
cEstDes  := SA1->A1_ESTADO
cCGCDes  := SA1->A1_CGC
DV3->(dbSetOrder(1))
If DV3->(MsSeek(xFilial("DV3") + DTC->DTC_CLIDES + DTC->DTC_LOJDES + If(DTC->(FieldPos("DTC_SQIDES"))>0,DTC->DTC_SQIDES,'')))
	cInscDes := DV3->DV3_INSCR
Else
	cInscDes := SA1->A1_INSCR
EndIf		
cEndEnt  := SA1->A1_ENDENT
If cDevFrete == "2"
	cInscDev := cInscDes
EndIf

//-- Dados do Devedor
SA1->(MsSeek(xFilial()+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV))
cNomDev  := SA1->A1_NOME
cEndDev  := SA1->A1_END
cCEPDev  := SA1->A1_CEP
cMunDev  := SA1->A1_MUN
cEstDev  := SA1->A1_ESTADO
cCGCDev  := SA1->A1_CGC

aCliCalc := TmsCliCalc(DT6->DT6_CLIREM,DT6->DT6_LOJREM,DT6->DT6_CLIDES,DT6->DT6_LOJDES)

If Empty( aCliCalc )
	aCliCalc := {DT6->DT6_CLIDEV,DT6->DT6_LOJDEV,"1"}
EndIf

cImpDev := aCliCalc[3]  // Imprime Devedor do Frete ?
                         
//-- Se o Devedor do Frete for o Consignatario ou o Despachante
If cImpDev == StrZero(1, Len(DTI->DTI_IMPDEV)) .And. (cDevFrete  == "3" .Or. cDevFrete  == "4")
    //-- Dados do Consignatario ou Despachante
	If cDevFrete=="4"
		SA1->(MsSeek(xFilial()+DT6->DT6_CLIDPC+DT6->DT6_LOJDPC))
		DV3->(dbSetOrder(1))
		If DV3->(MsSeek(xFilial("DV3") + DTC->DTC_CLIDPC + DTC->DTC_LOJDPC + If(DTC->(FieldPos("DTC_SQIDPC"))>0,DTC->DTC_SQIDPC,'')))
			cInscCONDPC := DV3->DV3_INSCR
		Else
			cInscCONDPC := SA1->A1_INSCR
		EndIf		
	ElseIf cDevFrete=="3"
		SA1->(MsSeek(xFilial()+DT6->DT6_CLICON+DT6->DT6_LOJCON))
		DV3->(dbSetOrder(1))
		If DV3->(MsSeek(xFilial("DV3") + DTC->DTC_CLICON + DTC->DTC_LOJCON + If(DTC->(FieldPos("DTC_SQICON"))>0,DTC->DTC_SQICON,'')))
			cInscCONDPC := DV3->DV3_INSCR
		Else
			cInscCONDPC := SA1->A1_INSCR
		EndIf		
	EndIf
	cNomCONDPC  := SA1->A1_NOME
	cEndCONDPC  := SA1->A1_END
	cCEPCONDPC  := SA1->A1_CEP
	cMunCONDPC  := SA1->A1_MUN
	cEstCONDPC  := SA1->A1_ESTADO
	cCGCCONDPC  := SA1->A1_CGC
	cInscDev    := cInscCONDPC
EndIf

//-- Destino de Calculo
DUY->(dbSetOrder(1))
If DUY->(MsSeek(xFilial("DUY")+ DT6->DT6_CDRCAL ))
	cDestCalc := DUY->DUY_DESCRI+"  "+DUY->DUY_EST
EndIf	          

RestArea(aAreaDT6)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTmsr01NfC³ Autor ³Robson Alves           ³ Data ³09.10.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Busca as Nf's do Cliente.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1:=TmsPesoVge(ExpC1,ExpC2)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Indice do DTC.                                     ³±±
±±³          ³ ExpB1 = Bloco com a condicao do While.                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function RTmsr01NFCli(nOrdem, bBloco, cNumNotas, cNumCot, aEnder)

Local aAreaDTC := {}
Local aAreaDUH := {}

//-- Notas Fiscais do Cliente
DTC->(dbSetOrder(nOrdem))
DTC->(MsSeek(xFilial("DTC")+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))

aAreaDTC  := DTC->(GetArea())
cNumNotas := ""

While Eval(bBloco)
	//-- Enderecamento de Notas Fiscais
	DUH->(dbSetOrder(1))
	DUH->(MsSeek(xFilial("DUH")+DTC->(DTC_FILORI+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM)))
	
	aAreaDUH := DUH->(GetArea())
	DUH->( DbEval( { || IIf(Ascan(aEnder, {|x| x == AllTrim(DUH->DUH_LOCALI)+"/" })== 0,AADD(aEnder,AllTrim(DUH_LOCALI)+"/" ),.T.) },, ;
	{ || DUH_FILIAL+DUH_FILORI+DUH_NUMNFC+DUH_SERNFC+DUH_CLIREM+DUH_LOJREM == ;
	xFilial("DTC")+DTC->(DTC_FILORI+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM) } ) )
	RestArea(aAreaDUH)
	
	cNumNotas += "/"+DTC->DTC_NUMNFC
	cNumCot   := DTC->DTC_NUMCOT // Numero da cotacao.
	
	DTC->(dbSkip())
EndDo
RestArea(aAreaDTC)

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR01Obs³ Autor ³ Robson Alves          ³ Data ³19.11.02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Obtem as observacoes.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³RTMSR01Obs(ExpA1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array para devolver as observacoes.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTMSR01Obs(aObservacoes)

Local cObs     := ""
Local cObs1    := ""
Local cObs2    := ""
Local nI       := 1
Local cSeekSD2 := ""
Local nPercDif := 0

AFill(aObservacoes, Space(40))

/* Obtem a observacao fiscal. */
cObs  := StrTran(MsMM(DT6->DT6_CODMSG,80),Chr(13),"")
cObs  := StrTran(cObs, Chr(10),"")
cObs1 := SubStr(cObs,  1, 40)
cObs2 := SubStr(cObs, 41, 40)
If !Empty(cObs1)
	aObservacoes[nI] := cObs1
	nI += 1
	If !Empty(cObs2)
		aObservacoes[nI] := cObs2
		nI += 1
	EndIf	
	If SF2->(FieldPos("F2_ICMSDIF")) > 0
		SF2->(dbSetOrder(1))
		If SF2->(MsSeek(xFilial("SF2")+DT6->(DT6_DOC+DT6_SERIE+DT6_CLIDEV+DT6_LOJDEV))) .And. SF2->F2_ICMSDIF > 0
			SD2->(dbSetOrder(3))
			SD2->(MsSeek(cSeekSD2 := xFilial("SD2")+DT6->(DT6_DOC+DT6_SERIE+DT6_CLIDEV+DT6_LOJDEV)))
			While SD2->(!Eof()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == cSeekSD2
				SF4->(dbSetOrder(1))
				If SF4->(MsSeek(xFilial("SF4")+SD2->D2_TES)) .And. SF4->F4_PICMDIF > 0
					nPercDif := SF4->F4_PICMDIF
					Exit
				EndIf
				SD2->(dbSkip())
			EndDo
			If nPercDif > 0
				aObservacoes[nI] := STR0011 + Transform(nPercDif,"@E 999.99") + "%: " + Transform(SF2->F2_ICMSDIF,"@E 999,999.99") //"Substituto  "
				nI += 1
				aObservacoes[nI] := STR0012 + Transform((100 - nPercDif),"@E 999.99") + "%: " + Transform(SF2->(F2_VALICM - F2_ICMSDIF),"@E 999,999.99") //"Substituido "
				nI += 1
			EndIf
		EndIf
	EndIf
EndIf

/* Obtem a observacao do conhecimento. */
DUO->(dbSetOrder(1))
If DUO->(MsSeek(xFilial("DUO") + DTC->DTC_CLIREM + DTC->DTC_LOJREM))
	cObs  := StrTran(MsMM(DUO->DUO_CDOCTR,80),Chr(13),"")
	cObs  := StrTran(cObs, Chr(10),"")
	cObs1 := SubStr(cObs,  1, 40)
	cObs2 := SubStr(cObs, 41, 40)
	If !Empty(cObs1)
		aObservacoes[nI] := cObs1
		nI += 1
		If !Empty(cObs2)
			aObservacoes[nI] := cObs2
			nI += 1
		EndIf	
	EndIf
EndIf	

/* Obtem a observacao do cliente. */
cObs  := StrTran(MsMM(DTC->DTC_CODOBS,80),Chr(13),"")
cObs  := StrTran(cObs, Chr(10),"")
cObs1 := SubStr(cObs,  1, 40)
cObs2 := SubStr(cObs, 41, 40)
If !Empty(cObs1)
	aObservacoes[nI] := cObs1
	nI += 1
	If !Empty(cObs2)
		aObservacoes[nI] := cObs2
		nI += 1
	EndIf	
EndIf

Return Nil