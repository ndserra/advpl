#INCLUDE "protheus.ch"
#INCLUDE "RTMSR17.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR17  ³ Autor ³ Richard Anderson      ³ Data ³22.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CRT - Conhecimento Internacional                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR17                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR17()

LOCAL titulo  := STR0001 //"CRT - Conhecimento Internacional"
LOCAL cString := "DTP"
LOCAL wnrel   := "RTMSR17"
LOCAL cDesc1  := STR0002 //"Este programa ira imprimir o CRT - Conhecimento Internacional"
LOCAL cDesc2  := ""
LOCAL cDesc3  := ""
LOCAL aOrd    := {STR0005,STR0006} //"CRT"###"Doc.Cliente"
Local nZ      := 0

Private aReturn  := {STR0003,1,STR0004,2, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private cPerg    := "RTMR17"
Private nLastKey := 0
Private aParamRl := Array(20)
Private Tamanho  := "M"
Private Limite   := 132 // 80/132/220

AjustaSX1()
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
pergunte("RTMR17",.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

For nz := 1 To 20
	aParamRl[nz]:=&("mv_par"+StrZero(nz,2))
Next nz

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR17Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR17Imp³ Autor ³ Richard Anderson      ³ Data ³22.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR17			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR17Imp(lEnd,wnRel,titulo,tamanho)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local  aAreaAtu     := GetArea()
Local  cLotNfc      := ''
Local  cFilOri      := ''
Local  nLin         := 0
Local  aDadosMer    := Array(12,2)
Local  aDadosFrt    := Array(07,4)
Local  aDocAne      := {}
Local  cDados       := ''
Local  aDoctos      := {}
Local  bCondDTC     := {||.T.}
Local  bWhile       := {||.T.}
Local  nOrdDT6      := 0
Local  nCnt         := 0
Local  nOrdem       := aReturn[8]
Local  nX           := 0
Local  nI           := 0
Local  cAliasQry    := GetNextAlias()
Local  cAliasDT6    := GetNextAlias()
Local  nTotalFrt    := 0
Local  cSeekDT8     := ''
Local  cSimbMd      := ''
Local  aDadCli      := {}
Local  aObsDoc      := {}
Local  cQuery       := ''
Local  aDadCRT      := {}
Local  aNomRem      := {}

//-- Vias do CRT
Local  nVia         := 0
Local  aVias        := { 'Primer original para el remitente. Unico valido para retirar las mercancias.',; 
                         'Segundo original - acompanha la mercaderia.                                 ',;
                         'Tercer original - Transportista.                                            ' ;
                       }
Local  nQtdVia      := Len(aVias)

SetRegua(DTP->(LastRec()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta Arquivo de Trabalho                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT DT6_FILIAL, DT6_FILORI, DT6_LOTNFC FROM "
cQuery += RetSqlName("DT6")+" DT6, "
cQuery += RetSqlName("DTP")+" DTP  "
cQuery += " WHERE DT6.DT6_FILIAL = '"+xFilial('DT6')+"'"
cQuery += "   AND DT6.DT6_FILORI = '"+cFilAnt+"'"
cQuery += "   AND DT6.DT6_LOTNFC BETWEEN '"+aParamRl[01]+"' AND '"+aParamRl[02]+"'"
cQuery += "   AND DT6.DT6_FILDOC = '"+cFilAnt+"'"
cQuery += "   AND DT6.DT6_DOC    BETWEEN '"+aParamRl[03]+"' AND '"+aParamRl[04]+"'"
cQuery += "   AND DT6.DT6_SERIE  BETWEEN '"+aParamRl[05]+"' AND '"+aParamRl[06]+"'"
cQuery += "   AND DT6.D_E_L_E_T_ = ' '"
cQuery += "   AND DTP.DTP_FILIAL = '"+xFilial('DTP')+"'"
cQuery += "   AND DTP.DTP_FILORI = DT6_FILORI"
cQuery += "   AND DTP.DTP_LOTNFC = DT6_LOTNFC"
cQuery += "   AND DTP.DTP_STATUS IN ( '3', '4' )"
cQuery += "   AND DTP.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY DT6_FILIAL, DT6_FILORI, DT6_LOTNFC"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDT6)
While (cAliasDT6)->(!Eof())

	IncRegua()
	
	If Interrupcao(@lEnd)
		Exit
	EndIf
	
	aDoctos := {}
	cFilOri := (cAliasDT6)->DT6_FILORI
	cLotNfc := (cAliasDT6)->DT6_LOTNFC
	
	If nOrdem == 1 //-- CRT
		bWhile  := { || DT6->(!Eof()) .And. DT6->DT6_FILIAL + DT6->DT6_FILORI + DT6->DT6_LOTNFC == xFilial("DT6")+aDoctos[nCnt] }
		nOrdDT6 := 2
		Aadd( aDoctos, cFilOri + cLotNfc )
	ElseIf nOrdem == 2 //-- Doc.Cliente 
		bWhile  := { || DT6->(!Eof()) .And. DT6->DT6_FILIAL + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE == xFilial("DT6")+aDoctos[nCnt] }
		nOrdDT6 := 1
		cIndex  := CriaTrab(NIL,.F.)
		cFiltro := " DTC->DTC_FILIAL == '" + xFilial("DTC")  + "' "
		cFiltro += " .And. DTC->DTC_FILORI == '" + cFilOri + "' "
		cFiltro += " .And. DTC->DTC_LOTNFC == '" + cLotNfc + "' "
		IndRegua('DTC',cIndex,'DTC_FILIAL+DTC_FILORI+DTC_NUMNFC',,cFiltro,STR0007,.F.) //"Selecionando Registros..."
			
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
		dbSeek(xFilial("DT6")+aDoctos[nCnt])
	
		Do While Eval(bWhile)
		
			If (DT6->DT6_FIMP == '1' .And. aParamRl[07]==1) .Or. DT6->DT6_DOCTMS != 'J'
				DT6->(dbSkip())
				Loop
			EndIf
			
			If ((DT6_DOC < aParamRl[03]) .Or. (DT6_DOC > aParamRl[04])) .Or. ((DT6_SERIE < aParamRl[05]) .Or. (DT6_SERIE > aParamRl[06])) .Or.;
				(DT6_SERIE == "PED")
				DT6->(dbSkip())
				Loop
			EndIf
			
			For nVia := 1 To nQtdVia
			
				DTC->(dbSetOrder(3))
				DTC->(dbSeek(xFilial('DTC')+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
	
				//-- Controle de Impressao
				nLin := 0
				@ nLin,000 PSay AvalImp(Limite)
	
				//-- Campo 01: Dados do Remetente
				nLin += 9
				aDadCRT := TMSDadCRT('01',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				@ nLin,004 PSay aDadCRT[1]
				
				//-- Campo 02: Numero
				@ nLin,080 PSay Transform(DT6->(DT6_SIGTRA+DT6_SERIE+DT6_DOC),"@R AA.999.999999999")
	
				//-- Campo 01: Dados do Remetente
				nLin += 1
				@ nLin,004 PSay aDadCRT[2]
				nLin += 1
				@ nLin,004 PSay aDadCRT[3]
	
				//-- Campo 04: Dados do Destinatario
				nLin += 5
				aDadCRT := TMSDadCRT('04',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				@ nLin,004 PSay aDadCRT[1]
				nLin += 1
				@ nLin,004 PSay aDadCRT[2]
				nLin += 1
				@ nLin,004 PSay aDadCRT[3]
	
				//-- Campo 05: Localidade e pais de emissao
				nLin += 2
				@ nLin,070 PSay TMSDadCRT('05',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)[1]
									
				//-- Campo 06: Dados Consignatario
				nLin += 2
				aDadCRT := TMSDadCRT('06',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				@ nLin,004 PSay aDadCRT[1]
				nLin += 1
				@ nLin,004 PSay aDadCRT[2]
				
				//-- Campo 07: Localidade Mercadoria
				@ nLin,070 PSay TMSDadCRT('07',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)[1]
				
				//-- Campo 06: Dados do Consignatario
				nLin += 1
				@ nLin,004 PSay aDadCRT[3]
	
				//-- Campo 08: Localidade de Entrega
				nLin += 3
				@ nLin,070 PSay TMSDadCRT('08',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)[1]
				
				//-- Campo 09: Cliente a Notificar
				nLin += 2
				aDadCRT := TMSDadCRT('09',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				@ nLin,004 PSay aDadCRT[1]
				nLin += 1
				@ nLin,004 PSay aDadCRT[2]
				nLin += 1
				@ nLin,004 PSay aDadCRT[3]
				
				//-- Campo 11: Descricao das Mercadorias
				Aeval(aDadosMer,{ | e | e[1] := Space(1), e[2] := Space(1) })
				
				aDadCRT:= TMSDadCRT('11',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				For nI := 1 To Len(aDadCRT)
					aDadosMer[nI,1] := aDadCRT[nI]
				Next nI				
				
				//-- Campo 12: Peso bruto em Kg
				aDadosMer[01,2] := 'Bruto..: '+Transform(DT6->DT6_PESO  ,"@E 999,999.999")
				aDadosMer[02,2] := 'Neto...: '+Transform(DT6->DT6_PESLIQ,"@E 999,999.999")
				
				//-- Campo 13: Volume cubico
				aDadosMer[07,2] := Space(08)+Transform(DT6->DT6_METRO3,"@E 999,999.999")+Space(2)+"m3"
				
				//-- Campo 14: Valor
				aDadosMer[11,2] := Space(09)+Transform(DT6->DT6_VALMER,"@E 99999,999.99")
				aDadosMer[12,2] := Space(13)+GetMv('MV_SIMB'+Str(DTC->DTC_MOENFC,1),,1)
				
				nLin += 4
				For nI := 1 To Len(aDadosMer)
					@ nLin,004 PSay aDadosMer[nI,1]
					@ nLin,100 PSay aDadosMer[nI,2]
					nLin += 1
				Next nI
				
				//-- Campo 16: Declaracao do Valor das Mercadorias
				nLin   += 2
				cDados := ''
				If !(TMSCfgCRT(DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE,'16') $ "2;4")
					cDados += DTC->DTC_INCOTE
				EndIf
				DIK->(dbSetOrder(4))
				DIK->(dbSeek(xFilial('DIK')+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
				cDados += Space(30)+GetMv('MV_SIMB'+Str(DTC->DTC_MOENFC,1),,1)+Space(6)+Transform(DIK->DIK_VALMER,"@E 99999,999.99")
				@ nLin,070 PSay cDados
				
				//-- Campo 15: Composicao do Frete
				//-- Campo 17: Documentos Anexos
				Aeval(aDadosFrt,{ | e | e[1] := Space(1), e[2] := 0, e[3] := 0, e[4] := Space(1) })
				
				If DTC->DTC_INCOTE == "DAF" //-- Ate Fronteira
					cQuery := "SELECT DIA_CODPAS, DT3_DESCRI, DIA_VALCIF, DIA_VALFOB FROM "
					cQuery += RetSqlName("DIA")+" DIA "
					cQuery += "  LEFT JOIN "
					cQuery += RetSqlName("DT3")+" DT3 "
					cQuery += "    ON DT3.DT3_FILIAL  = '"+xFilial("DT3") +"'"
					cQuery += "   AND DT3.DT3_CODPAS  = DIA_CODPAS"
					cQuery += "   AND DT3.D_E_L_E_T_  = ' '"
					cQuery += " WHERE DIA.DIA_FILIAL  = '"+xFilial("DIA") +"'"
					cQuery += "   AND DIA.DIA_FILDOC  = '"+DT6->DT6_FILDOC+"'"
					cQuery += "   AND DIA.DIA_DOC     = '"+DT6->DT6_DOC   +"'"
					cQuery += "   AND DIA.DIA_SERIE   = '"+DT6->DT6_SERIE +"'"
					cQuery += "   AND DIA.D_E_L_E_T_  = ' '"
					cQuery += " ORDER BY DIA_CODPAS"
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
					TcSetField(cAliasQry,"DIA_VALCIF","N",TamSX3("DIA_VALCIF")[1],TamSX3("DIA_VALCIF")[2])
					TcSetField(cAliasQry,"DIA_VALFOB","N",TamSX3("DIA_VALFOB")[1],TamSX3("DIA_VALFOB")[2])
					nI := 1
					While (cAliasQry)->(!Eof())
						If Empty(aDadosFrt[nI,1])
							aDadosFrt[nI,1] := (cAliasQry)->DT3_DESCRI
						EndIf
						If (cAliasQry)->DIA_CODPAS == "TF"
							aDadosFrt[07,2] += (cAliasQry)->DIA_VALCIF
							aDadosFrt[07,3] += (cAliasQry)->DIA_VALFOB
						Else						
							aDadosFrt[nI,2] += (cAliasQry)->DIA_VALCIF
							aDadosFrt[nI,3] += (cAliasQry)->DIA_VALFOB
						EndIf						
						If nI <= 3
							nI += 1
						EndIf
						(cAliasQry)->(dbSkip())
					EndDo
					(cAliasQry)->(dbCloseArea())
				Else
					cQuery := "SELECT DT8_CODPAS, MIN(DT3_DESCRI) DT3_DESCRI, SUM(DT8_VALTOT) DT8_VALTOT FROM "
					cQuery += RetSqlName("DT8")+" DT8 "
					cQuery += "  LEFT JOIN "
					cQuery += RetSqlName("DT3")+" DT3 "
					cQuery += "    ON DT3.DT3_FILIAL  = '"+xFilial("DT3") +"'"
					cQuery += "   AND DT3.DT3_CODPAS  = DT8_CODPAS"
					cQuery += "   AND DT3.D_E_L_E_T_  = ' '"
					cQuery += " WHERE DT8.DT8_FILIAL  = '"+xFilial("DIA") +"'"
					cQuery += "   AND DT8.DT8_FILDOC  = '"+DT6->DT6_FILDOC+"'"
					cQuery += "   AND DT8.DT8_DOC     = '"+DT6->DT6_DOC   +"'"
					cQuery += "   AND DT8.DT8_SERIE   = '"+DT6->DT6_SERIE +"'"
					cQuery += "   AND DT8.D_E_L_E_T_  = ' '"
					cQuery += " GROUP BY DT8_CODPAS"
					cQuery += " ORDER BY DT8_CODPAS"
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
					TcSetField(cAliasQry,"DT8_VALTOT","N",TamSX3("DT8_VALTOT")[1],TamSX3("DT8_VALTOT")[2])
					nI := 1
					While (cAliasQry)->(!Eof())
						If Empty(aDadosFrt[nI,1])
							aDadosFrt[nI,1] := (cAliasQry)->DT3_DESCRI
						EndIf
						If DT6->DT6_TIPFRE == "1" //-- CIF
							If (cAliasQry)->DT8_CODPAS == "TF"
								aDadosFrt[07,2] += (cAliasQry)->DT8_VALTOT
							Else							
								aDadosFrt[nI,2] += (cAliasQry)->DT8_VALTOT
							EndIf							
						Else						
							If (cAliasQry)->DT8_CODPAS == "TF"
								aDadosFrt[07,3] += (cAliasQry)->DT8_VALTOT
							Else
								aDadosFrt[nI,3] += (cAliasQry)->DT8_VALTOT
							EndIf
						EndIf						
						If nI <= 3
							nI += 1
						EndIf
						(cAliasQry)->(dbSkip())
					EndDo
					(cAliasQry)->(dbCloseArea())
				EndIf
				
				dbSelectArea("DT6")
				aDocAne := TMSDadCRT('17',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				aDadosFrt[4,4] := aDocAne[1]
				aDadosFrt[5,4] := aDocAne[2]
				aDadosFrt[6,4] := aDocAne[3]
				aDadosFrt[7,4] := aDocAne[4]
				
				//-- Simbolo da moeda do documento
				cSimbMd:= GetMv('MV_SIMB'+Str(DT6->DT6_MOEDA,1),,1)
				
				nLin += 3
				For nI := 1 To Len(aDadosFrt)
					@ nLin,000 PSay aDadosFrt[nI,1]
					If !Empty(aDadosFrt[nI,2])
						@ nLin,024 PSay Transform(aDadosFrt[nI,2],"@E 99,999.99")
						@ nLin,038 PSay cSimbMd
					EndIf					
					If !Empty(aDadosFrt[nI,3])
						@ nLin,050 PSay Transform(aDadosFrt[nI,3],"@E 99,999.99")
						@ nLin,060 PSay cSimbMd
					EndIf
					@ nLin,070 PSay aDadosFrt[nI,4]
					nLin += 1
				Next nI				
	
				//-- Campo 19: Valor do Frete Externo
				nLin += 2
				If TMSCfgCRT(DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE,'19') != "2" //-- Nao Imprime
					@ nLin,014 PSay TMSDadCRT('19',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)[1]
				EndIf				
	
				//-- Campo 18: Instrucoes de Alfandega
				nLin += 3
				aDadCRT := TMSDadCRT('18',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				For nI  := 1 To Len(aDadCRT)
					@ nLin,060 PSay aDadCRT[nI]
					nLin += 1
				Next nI
				
				//-- Campo 21: Nome e assinatura do remetente
				aNomRem := TMSDadCRT('21',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				
				//-- Campo 22: Declaracoes e Observacoes
				nLin += 2
				aDadCRT := TMSDadCRT('22',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				For nI  := 1 To Len(aDadCRT)
					If nI == 2
						@ nLin,000 PSay Padr(aNomRem[1],TamSX3('DIK_NOMREM')[1])
					EndIf
					@ nLin,060 PSay aDadCRT[nI]
					nLin += 1
				Next nI
				
				dbSelectArea("DT6")
				//-- Campo 23: Data
				nLin += 1
				@ nLin,010 PSay Dtoc(DT6->DT6_DATEMI)
				
				//-- Campo 24: Nome do Representante
				@ nLin,065 PSay AllTrim(UsrRetName(DT6->DT6_USRGER))+' '+AllTrim(UsrRetName(RetCodUsr()))+' crt: '+DT6->(DT6_FILORI+' '+DT6_FILDES+' '+DT6_DOC)
				
				//-- Via
				nLin += 1
				@ nLin,001 PSay aVias[nVia]
				
			Next nVia
			//-- Atualiza campo DT6_FIMP (Flag de Impressao)
			RecLock("DT6",.F.)
			DT6->DT6_FIMP   := StrZero(1,Len(DT6->DT6_FIMP))
			DT6->DT6_USRIMP := RetCodUsr()
			MsUnlock()
			DT6->(dbSkip())
		EndDo
	Next nCnt
	(cAliasDT6)->(dbSkip())
EndDo

(cAliasDT6)->(dbCloseArea())
RestArea(aAreaAtu)

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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1  ³ Autor ³Richard Anderson    ³ Data ³ 22/11/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Inclui Perguntas no SX1                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³RTMSR17                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1()

Local aHlpPor1 := {"Informe o numero do Lote Inicial"}
Local aHlpEsp1 := {"Informe el Numero del Lote Inicial"}
Local aHlpIng1 := {"Enter the First Lot Number"}

Local aHlpPor2 := {"Informe o Numero do Lote Final"}
Local aHlpEsp2 := {"Informe el Numero del Lote Final"}
Local aHlpIng2 := {"Enter the Last Lot Number"}

Local aHlpPor3 := {"Informe o numero do Documento Inicial"}
Local aHlpEsp3 := {"Informe el Numero del Documento Inicial"}
Local aHlpIng3 := {"Enter the First Document Number"}

Local aHlpPor4 := {"Informe o numero do Documento Final"}
Local aHlpEsp4 := {"Informe el Numero del Documento Final"}
Local aHlpIng4 := {"Enter the Last Document Number"}                                

Local aHlpPor5 := {"Informe o numero de Serie Inicial"}
Local aHlpEsp5 := {"Informe la Serie del Documento Inicial"}
Local aHlpIng5 := {"Enter the First Series Number"}

Local aHlpPor6 := {"Informe o numero de Serie Final"}
Local aHlpEsp6 := {"Informe la Serie del Documento Final"}
Local aHlpIng6 := {"Enter the Last Series Number"}                            

Local aHlpPor7 := {"Informe se e Impressao ou Reimpressao."}
Local aHlpEsp7 := {"Informe la Impression/Reimpresion "}
Local aHlpIng7 := {"Enter the Printing or Reprinting"}    

SX1->(DbSetOrder(1))
If SX1->( DbSeek(Padr(cPerg,Len(SX1->X1_GRUPO),' ')+"08")) .And. "Impressão/Reimpr" $ Alltrim(SX1->X1_PERGUNT)
	Reclock("SX1",.F.)
	DBDelete()
	SX1->(MsUnLock())
EndIf

PutSx1( cPerg, "01","Lote De  ?           ","De Lote ?           ","From Lot ?           ","mv_ch1","C",6,0,0,"G","","DTP","","","mv_par01","","","","","","","","","","","","","","","","",aHlpPor1,aHlpIng1,aHlpEsp1)
PutSx1( cPerg, "02","Lote Ate  ?          ","A Lote ?            ","To Lot ?          ","mv_ch2","C",6,0,0,"G","","DTP","","","mv_par02","","","","","","","","","","","","","","","","",aHlpPor2,aHlpIng2,aHlpEsp2)
PutSx1( cPerg, "03","Documento De  ?      ","De Documento ?      ","From Document ?	   ","mv_ch3","C",9,0,0,"G","","DT6","","","mv_par03","","","","","","","","","","","","","","","","",aHlpPor3,aHlpIng3,aHlpEsp3)
PutSx1( cPerg, "04","Documento Ate  ?     ","A Documento  ?      ","To Document ?     ","mv_ch4","C",9,0,0,"G","","DT6","","","mv_par04","","","","","","","","","","","","","","","","",aHlpPor4,aHlpIng4,aHlpEsp4)
PutSx1( cPerg, "05","Serie De  ?          ","De Serie ?          ","From Series ?          ","mv_ch5","C",3,0,0,"G","",""   ,"","","mv_par05","","","","","","","","","","","","","","","","",aHlpPor5,aHlpIng5,aHlpEsp5)
PutSx1( cPerg, "06","Serie Ate  ?         ","A Serie  ?          ","To Series ?         ","mv_ch6","C",3,0,0,"G","",""   ,"","","mv_par06","","","","","","","","","","","","","","","","",aHlpPor6,aHlpIng6,aHlpEsp6)
PutSx1( cPerg, "07","Impressão/Reimpre. ? ","Impresion/Reimpresion?","Printing/Reprint ? ","mv_ch7","N",1,0,0,"C","",""   ,"","","mv_par07","Impressão","Impresion","Printing","","Reimpressão","Reimpresion","Reprinting","","","","","","","","","",aHlpPor7,aHlpIng7,aHlpEsp7)

Return
