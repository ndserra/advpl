#INCLUDE "protheus.ch"
#INCLUDE "RTMSR20.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR20  ³ Autor ³ Richard Anderson      ³ Data ³22.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CRT - Conhecimento Internacional (Gráfico)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR20                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR20()

Local   nZ       := 0
Local   cPerg    := "RTMR17"
Local   aAreaDT6 := DT6->(GetArea("DT6"))
Local   cSeekDI5 := ' '
Private aParamRl := Array(9)
Private cFilAtu  := ' '


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            	// Lote Inicial 		                 ³
//³ mv_par02            	// Lote Final         	         	  ³
//³ mv_par03            	// Documento De 		      		     ³
//³ mv_par04            	// Documento Ate      		           ³
//³ mv_par05            	// Serie De     	   		           ³
//³ mv_par06            	// Serie Ate            	           ³
//³ mv_par07            	// Impressao / Reimpressao            ³
//³ mv_par08            	// Tipo de Vias				           ³
//³ mv_par09            	// Imprime Incoterme                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AjustaSX1(cPerg)
DT6->( dbSetOrder(1) )  // DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE

If AllTrim(FunName()) == "TMSAI70" .and. SX1->(MsSeek(cPerg))
	
	DT6->( dbSeek(xFilial("DT6")+DIK->(DIK_FILDOC+DIK_DOC+DIK_SERIE)) )
	
	aParamRl[01] := DIK->DIK_LOTNFC
	aParamRl[02] := DIK->DIK_LOTNFC
	aParamRl[03] := DIK->DIK_DOC
	aParamRl[04] := DIK->DIK_DOC
	aParamRl[05] := DIK->DIK_SERIE
	aParamRl[06] := DIK->DIK_SERIE
	aParamRl[07] := Iif(DT6->DT6_FIMP == '0','1','2')
	aParamRl[08] := '1'
	aParamRl[09] := '1'
	
	cFilAtu := DIK->DIK_FILDOC
	
	SX1->(dbSetOrder(1))
	If SX1->(DbSeek(cPerg+"01"))
		Do While AllTrim(SX1->X1_GRUPO) == cPerg
			RecLock("SX1",.F.)
			SX1->X1_CNT01 := 	aParamRl[val(SX1->X1_ORDEM)]
			MsUnLock()
			SX1->(DbSkip())
		EndDo
	EndIf
	
EndIf

If Pergunte( cPerg, .T. )
	For nZ := 1 To Len(aParamRl)
		aParamRl[nZ]:=&("mv_par"+StrZero(nZ,2))
	Next nZ
	
	If AllTrim(FunName()) <> "TMSAI70"
		cFilAtu := cFilAnt
	EndIf
	
	Processa( { | lEnd | MontaRel( @lEnd ) }, "Gerando CRT Grafico, Aguarde...",, .T. )
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MontaRel ³ Autor ³ Richard Anderson      ³ Data ³ 23.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera impressao do CRT                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR20                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel( lEnd )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local  oPrint,oFont1,oFont2,oFont3,oFontD,nLin
Local  aAreaAtu     := GetArea()
Local  cLotNfc      := ''
Local  cFilOri      := ''
Local  aDadosMer    := Array(12,2)
Local  aDadosFrt    := Array(07,3)
Local  cDados       := ''
Local  aDoctos      := {}
Local  bCondDTC     := {||.T.}
Local  bWhile       := {||.T.}
Local  nOrdDT6      := 0
Local  nCnt         := 0
Local  nOrdem       := 1
Local  nX           := 0
Local  nI           := 0
Local  cAliasQry    := GetNextAlias()
Local  cAliasDT6    := GetNextAlias()
Local  nTotalFrt    := 0
Local  cSimbMd      := ''
Local  aDocAne      := {}
Local  aObsDoc      := {}
Local  aDadCRT      := {}
Local  aNomRem      := {}
Local  cQuery       := ''

//-- Vias do CRT
Local  nVia         := 0
Local  aVias        := {}
Local  nQtdVia      := 0

Aadd(aVias, '1o. - Primer original para el remitente. Unico valido para retirar las mercancias.')
Aadd(aVias, '2o. - Segundo original - acompanha la mercaderia.')
Aadd(aVias, '3o. - Tercer original - Transportista.')

If aParamRl[08] == 2
	aVias := {}
	Aadd(aVias, 'Copia.')
ElseIf aParamRl[08] == 3
	Aadd(aVias, 'Copia.')
EndIf

nQtdVia      := Len(aVias)

oFont1  := TFont():New("Arial"        ,00,13,,.T.,,,,.T.,.F.)
oFont2  := TFont():New("Arial"        ,00,07,,.T.,,,,.T.,.F.)
oFont3  := TFont():New("Arial"        ,00,06,,.T.,,,,.T.,.F.)
oFont4  := TFont():New("Arial Narrow" ,00,09,,.T.,,,,.T.,.F.)
oFontE  := TFont():New("Arial"        ,00,15,,.T.,,,,.T.,.F.)
oFontD  := TFont():New("Courier New"  ,06,10)
oFontD1 := TFont():New("Courier New"  ,06,09)

oPrint := TMSPrinter():New( "CRT - Conhecimento Internacional" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta Arquivo de Trabalho                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT DT6_FILIAL, DT6_FILORI, DT6_LOTNFC FROM "
cQuery += RetSqlName("DT6")+" DT6, "
cQuery += RetSqlName("DTP")+" DTP  "
cQuery += " WHERE DT6.DT6_FILIAL = '"+xFilial('DT6')+"'"
cQuery += "   AND DT6.DT6_FILORI = '"+cFilAtu+"'"
cQuery += "   AND DT6.DT6_LOTNFC BETWEEN '"+aParamRl[01]+"' AND '"+aParamRl[02]+"'"
cQuery += "   AND DT6.DT6_FILDOC = '"+cFilAtu+"'"
cQuery += "   AND DT6.DT6_DOC    BETWEEN '"+aParamRl[03]+"' AND '"+aParamRl[04]+"'"
cQuery += "   AND DT6.DT6_SERIE  BETWEEN '"+aParamRl[05]+"' AND '"+aParamRl[06]+"'"
cQuery += "   AND DT6.D_E_L_E_T_ = ' '"
cQuery += "   AND DTP.DTP_FILIAL = '"+xFilial('DTP')+"'"
cQuery += "   AND DTP.DTP_FILORI = DT6_FILORI"
cQuery += "   AND DTP.DTP_LOTNFC = DT6_LOTNFC"
cQuery += "   AND DTP.DTP_STATUS IN ( '2', '3', '4' )"
cQuery += "   AND DTP.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY DT6_FILIAL, DT6_FILORI, DT6_LOTNFC"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDT6)


SA1->(dbSetOrder(1))
While (cAliasDT6)->(!Eof())
	
	IncProc()
	
	If Interrupcao(@lEnd)
		Exit
	EndIf
	
	// Exibi todos os registros deletados.
	//Set Deleted OFF
	
	aDoctos := {}
	cFilOri := (cAliasDT6)->DT6_FILORI
	cLotNfc := (cAliasDT6)->DT6_LOTNFC
	
	bWhile  := { || DT6->(!Eof()) .And. DT6->DT6_FILIAL + DT6->DT6_FILORI + DT6->DT6_LOTNFC == xFilial("DT6")+aDoctos[nCnt] }
	nOrdDT6 := 2
	
	Aadd( aDoctos, cFilOri + cLotNfc )
	
	For nCnt := 1 To Len(aDoctos)
		
		dbSelectArea("DT6")
		dbSetOrder(nOrdDT6)
		DbSeek(xFilial("DT6")+aDoctos[nCnt])
		
		Do While Eval(bWhile)
			If (DT6->DT6_FIMP == '1' .And. aParamRl[07]==1) .Or. (DT6->DT6_DOCTMS != 'J') .Or. !Empty(DT6->DT6_DOCDCO)
				DT6->(dbSkip())
				Loop
			EndIf
			If ((DT6->DT6_DOC < aParamRl[03]) .Or. (DT6->DT6_DOC > aParamRl[04])) .Or. ((DT6->DT6_SERIE < aParamRl[05]) .Or. (DT6->DT6_SERIE > aParamRl[06])) .Or.;
				(DT6->DT6_SERIE == "PED")
				DT6->(dbSkip())
				Loop
			EndIf
			
			For nVia := 1 To nQtdVia
				
				//-- Imprime folha de rosto
				ImpRosto(oPrint,oFont1,oFont2,oFont3)
				
				DTC->(dbSetOrder(3))
				DTC->(dbSeek(xFilial('DTC')+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
				
				//-- Simbolo da moeda do documento
				cSimbMd := GetMv('MV_SIMB'+Str(DT6->DT6_MOEDA,1),,1)
				
				//-- Campo 01: Dados do Remetente
				aDadCRT := TMSDadCRT('01',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				oPrint:Say( 0360, 0020, aDadCRT[1], oFontD )
				oPrint:Say( 0400, 0020, aDadCRT[2], oFontD )
				oPrint:Say( 0440, 0020, aDadCRT[3], oFontD )
				oPrint:Say( 0480, 0020, aDadCRT[4], oFontD )
				
				//-- Campo 02: Numero
				oPrint:Say( 0360, 1600, Transform(DT6->(DT6_SIGTRA+DT6_SERIE+DT6_DOC),"@R AA.999.999999"), oFontE )
				
				//-- Campo 04: Dados do Destinatario
				aDadCRT := TMSDadCRT('04',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				oPrint:Say( 0610, 0020, aDadCRT[1], oFontD )
				oPrint:Say( 0650, 0020, aDadCRT[2], oFontD )
				oPrint:Say( 0690, 0020, aDadCRT[3], oFontD )
				oPrint:Say( 0730, 0020, aDadCRT[4], oFontD )
				
				
				//-- Campo 05: Localidade e pais de emissao
				oPrint:Say( 0760, 1130, TMSDadCRT('05',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)[1], oFontD )
				
				//-- Campo 06: Dados Consignatario
				aDadCRT := TMSDadCRT('06',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				oPrint:Say( 0860, 0020, aDadCRT[1], oFontD )
				oPrint:Say( 0900, 0020, aDadCRT[2], oFontD )
				oPrint:Say( 0940, 0020, aDadCRT[3], oFontD )
				oPrint:Say( 0980, 0020, aDadCRT[4], oFontD )
				
				
				//-- Campo 07: Localidade Mercadoria
				oPrint:Say( 0935, 1130, AllTrim(StrTran(TMSDadCRT('07',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)[1],Chr(13),'')), oFontD )
				
				//-- Campo 08: Localidade de Entrega
				oPrint:Say( 1060, 1130, TMSDadCRT('08',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)[1], oFontD )
				
				//-- Campo 09: Cliente a Notificar
				aDadCRT := TMSDadCRT('09',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				oPrint:Say( 1110, 0020, aDadCRT[1], oFontD )
				oPrint:Say( 1150, 0020, aDadCRT[2], oFontD )
				oPrint:Say( 1190, 0020, aDadCRT[3], oFontD )
				oPrint:Say( 1230, 0020, aDadCRT[4], oFontD )
				
				//-- Campo 10: Transportadores sucessivos
				oPrint:Say( 1210, 1130, "NIHIL", oFontD )
				
				//-- Campo 11: Descricao das Mercadorias
				nLin   := 1370
				aDadCRT:= TMSDadCRT('11',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				For nI := 1 To Len(aDadCRT)
					oPrint:Say( nLin, 0025, aDadCRT[nI], oFontD1 )
					nLin += 33
				Next nI
				
				//-- Campo 12: Peso bruto em Kg
				aDadCRT:= TMSDadCRT('12',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				oPrint:Say( 1360, 1820, 'Bruto..: '+Transform(aDadCRT[1]  ,"@E 999,999.999"), oFontD )
				oPrint:Say( 1410, 1820, 'Neto...: '+Transform(aDadCRT[2]  ,"@E 999,999.999"), oFontD )
				
				//-- Campo 13: Volume cubico
				aDadCRT:= TMSDadCRT('13',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				oPrint:Say( 1560, 1830, aDadCRT[1]+Space(2)+"m3", oFontD )
				
				//-- Campo 14: Valor
				aDadCRT:= TMSDadCRT('14',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				oPrint:Say( 1760, 1830, aDadCRT[1]  , oFontD )
				oPrint:Say( 1845, 1900, aDadCRT[2]  , oFontD )
				
				//-- Campo 15: Composicao do Frete
				Aeval(aDadosFrt,{ | e | e[1] := Space(1), e[2] := 0, e[3] := 0 })
				
				//-- Ate Fronteira
				If DTC->DTC_INCOTE $ "DAF/DDU"
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
				nLin := 1970
				For nI := 1 To Len(aDadosFrt)
					//-- Soma para imprimir total
					If nI == Len(aDadosFrt)
						nLin += 70
					EndIf
					oPrint:Say( nLin, 0068, aDadosFrt[nI,1], oFontD )
					If !Empty(aDadosFrt[nI,2])
						oPrint:Say( nLin, 0476, Transform(aDadosFrt[nI,2],"@E 99,999.99"), oFontD )
						oPrint:Say( nLin, 0690, cSimbMd, oFontD )
					EndIf
					If !Empty(aDadosFrt[nI,3])
						oPrint:Say( nLin, 0815, Transform(aDadosFrt[nI,3],"@E 99,999.99"), oFontD )
						oPrint:Say( nLin, 1025, cSimbMd, oFontD )
					EndIf
					nLin += 40
				Next nI
				
				//-- Campo 16: Declaracao do Valor das Mercadorias
				cDados := ''
				If !(TMSCfgCRT(DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE,'16') $ "2;4")
					If aParamRl[09] == 1 // imprime incoterme sim/nao
						cDados += DTC->DTC_INCOTE
					EndIf
				EndIf
				aDadCRT := TMSDadCRT('16',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				cDados += Space(30)+aDadCRT[2]+Space(6)+aDadCRT[1]
				oPrint:Say( 1940, 1130, cDados, oFontD )
				
				
				//-- Campo 17: Documentos Anexos
				nLin    := 2040
				aDocAne := TMSDadCRT('17',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				For nI  := 1 To Len(aDocAne)
					oPrint:Say( nLin, 1130, aDocAne[nI], oFontD )
					nLin += 40
				Next nI
				
				//-- Campo 19: Valor do Frete Externo
				If TMSCfgCRT(DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE,'19') != "2" //-- Nao Imprime
					aDadCRT := TMSDadCRT('19',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
					
					If !Empty(aDadCRT[1])
						oPrint:Say( 2400, 0550, cSimbMd + space(02) + aDadCRT[1], oFontD )
					EndIf
					
				EndIf
				
				
				//-- Campo 18: Instrucoes de Alfandega
				nLin := 2300
				aDadCRT := TMSDadCRT('18',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				For nI := 1 To Len(aDadCRT)
					oPrint:Say( nLin, 1130, aDadCRT[nI], oFontD )
					nLin += 40
				Next nI
				
				//-- Campo 21: Nome e assinatura do Remetente ou Representante
				//-- Em branco
				aNomRem := TMSDadCRT('21',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				oPrint:Say( 2650, 0100, Padr(aNomRem[1],TamSX3('DIK_NOMREM')[1]), oFontD )
				              
				//-- Exemplo para impressao do Nome do Remetente no campo 21
				//aNomRem := TMSDadCRT('01',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				//oPrint:Say( 2650, 0100, Padr(aNomRem[1],TamSX3('DIK_NOMREM')[1]), oFontD )
				
				//-- Campo 22: Declaracoes e Observacoes
				nLin := 2550
				aDadCRT := TMSDadCRT('22',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				For nI := 1 To Len(aDadCRT)
					oPrint:Say( nLin, 1130, aDadCRT[nI], oFontD )
					nLin += 40
				Next nI
				
				dbSelectArea('DT6')
				//-- Campo 23: Data
				oPrint:Say( 3100, 0250, Dtoc(DT6->DT6_DATEMI), oFontD )
				
				//-- Campo 24: Nome do Destinatario ou Representante 
				//-- Em Branco
            
				//-- Exemplo para impressao do Nome do Destinatario no campo 24
				//aNomRem := TMSDadCRT('04',DT6->DT6_FILDOC,DT6->DT6_DOC,DT6->DT6_SERIE)
				//oPrint:Say( 3050, 1178, Padr(aNomRem[1],TamSX3('DIK_NOMREM')[1]), oFontD )
				
				//-- Exemplo para impressao dos dados do Usuario
				//oPrint:Say( 3050, 1178, AllTrim(UsrRetName(DT6->DT6_USRGER))+' '+AllTrim(UsrRetName(RetCodUsr())), oFontD )
								
				//-- Via
				oPrint:Say( 3145, 0020, aVias[nVia], oFontD )
				
				//-- Finaliza a página
				oPrint:EndPage()
				
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

// Oculta todos os registros deletados.
//Set Deleted ON


(cAliasDT6)->(dbCloseArea())
RestArea(aAreaAtu)

If !lEnd
	oPrint:Preview()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImRosto  ³ Autor ³ Richard Anderson      ³ Data ³ 23.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime folha de rosto do CRT                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR20                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRosto(oPrint,oFont1,oFont2,oFont3)

Local cLogoCRT  := "lgcrt.bmp"
Local cFileLogo := "lgrl"+SM0->M0_CODIGO+SM0->M0_CODFIL+".bmp" // Empresa+Filial

If !File(cFileLogo)
	cFileLogo := "lgrl"+SM0->M0_CODIGO+".bmp" // Empresa
EndIf

oPrint:StartPage() // Inicia uma nova página

oPrint:Box( 0010, 0010, 0300, 2325 )
oPrint:Say( 0050, 0250, "Carta de Porte Internacional", oFont1 )
oPrint:Say( 0090, 0250, "por Carretera"               , oFont1 )
If !File(cLogoCRT)
	oPrint:Say( 0090, 0070, "CRT"                      , oFont1 )
Else
	oPrint:SayBitmap( 0055, 0020, cLogoCRT, 210, 180 )
EndIf
oPrint:Say( 0140, 0250, "Conhecimento Internacional"  , oFont1 )
oPrint:Say( 0180, 0250, "de Transporte Rodoviário"       , oFont1 )

oPrint:Say( 0040, 1020, "El Transporte realizado bajo esta Carta de Porte Internacional está sujeito a las disposiciones del "   , oFont2 )
oPrint:Say( 0065, 1020, "Convenio sobre el contato de transporte y la Responsabilidade Civil del Porteador en el Transporte "    , oFont2 )
oPrint:Say( 0090, 1020, "Terrestre Internacional de Mercancias, las cuales anulan toda estipulación que se aparte de ellas en "  , oFont2 )
oPrint:Say( 0115, 1020, "prejuicio del remitente o del consignatário"   , oFont2 )

oPrint:Say( 0165, 1020, "O transporte realizado ao amparo deste Conhecimento Internacional de Transporte Rodoviario está sujeito"       , oFont2 )
oPrint:Say( 0190, 1020, "às disposições do Convênio sobre o Contrato de Transporte e a Responsabilidade Civil do Transportador"    , oFont2 )
oPrint:Say( 0215, 1020, "no Transporte Terrestre Internacional de Mercadorias, as quais anulam toda estipulação contrária às"   , oFont2 )
oPrint:Say( 0240, 1020, "mesmas em prejuízo do remetente ao do consignatário" , oFont2 )

oPrint:Box( 0300, 0010, 0550, 1120 )
oPrint:Say( 0310, 0020, "1. Nombre y domicilio del remitente / Nome e endereço do remetente", oFont2 )

oPrint:Box( 0550, 0010, 0800, 1120 )
oPrint:Say( 0560, 0020, "4. Nombre y domicilio del destinatario / Nome e endereço do destinatário", oFont2 )

oPrint:Box( 0800, 0010, 1050, 1120 )
oPrint:Say( 0810, 0020, "6. Nombre y domicilio del consignatario / Nome e endereço do consignatário", oFont2 )

oPrint:Box( 1050, 0010, 1300, 1120 )
oPrint:Say( 1060, 0020, "9. Notificar a: / Notificar a:", oFont2 )

oPrint:Box( 0300, 1120, 0450, 2325 )
oPrint:Say( 0310, 1130, "2. Número / Número", oFont2 )

oPrint:Box( 0450, 1120, 0700, 2325 )
oPrint:SayBitmap( 0530, 1190, cFileLogo, 380, 110 )
oPrint:Say( 0460, 1130, "3. Nombre y domicilio del porteador / Nome e endereço do transportador", oFont2 )

oPrint:Box( 0700, 1120, 0850, 2325 )
oPrint:Say( 0710, 1130, "5. Lugar y pais de emisión / Localidade e país de emissão", oFont2 )

oPrint:Box( 0850, 1120, 1000, 2325 )
oPrint:Say( 0860, 1130, "7. Lugar, pais y fecha en que el porteador se hace cargo e las mercancias", oFont2 )
oPrint:Say( 0885, 1130, "    Localidade, país e data em que o transportador se responsabiliza pela mercadoria", oFont2 )

oPrint:Box( 1000, 1120, 1150, 2325 )
oPrint:Say( 1010, 1130, "8. Lugar, pais y plazo de entrega / Localidade, país e prazo de entrega", oFont2 )

oPrint:Box( 1150, 1120, 1300, 2325 )
oPrint:Say( 1160, 1130, "10. Porteadores sucessivos / Transportadores sucessivos", oFont2 )

oPrint:Box( 1300, 0010, 1900, 1800 )
oPrint:Say( 1310, 0020, "11. Cantidad y clase de bultos, marcas y números, tipo de mercancia, contenedores y accesórios", oFont2 )
oPrint:Say( 1335, 0020, "      Quantidade e categoria de volumes, marcas, números, tipos de mercadoria, containers e peças", oFont2 )

oPrint:Box( 1300, 1800, 1500, 2325 )
oPrint:Say( 1310, 1810, "12. Peso bruto en Kg. / Peso Bruto em Kg." , oFont2 )

oPrint:Box( 1500, 1800, 1700, 2325 )
oPrint:Say( 1510, 1810, "13. Volume en m.cu. / Volume em m.cu."  , oFont2 )

oPrint:Box( 1700, 1800, 1900, 2325 )
oPrint:Say( 1710, 1810, "14. Valor / Valor" , oFont2 )
oPrint:Say( 1810, 1810, "Moeda / Moneda"	   , oFont2 )

oPrint:Box( 1900, 0010, 2350, 0450 )
oPrint:Say( 1910, 0020, "15. Gastos a Pagar", oFont2 )
oPrint:Say( 1940, 0068, "Flete / Frete"     , oFont2 )

oPrint:Box( 1900, 0450, 2350, 0680 )
oPrint:Say( 1910, 0466, "Monto remitente"   , oFont2 )
oPrint:Say( 1940, 0466, "Valor remetente"   , oFont2 )

oPrint:Box( 1900, 0680, 2350, 0790 )
oPrint:Say( 1910, 0690, "Moneda"            , oFont2 )
oPrint:Say( 1940, 0690, "Moeda"             , oFont2 )

oPrint:Box( 1900, 0790, 2350, 1010 )
oPrint:Say( 1910, 0802, "Mon.Destinatário" , oFont2 )
oPrint:Say( 1940, 0802, "Vl.destinatário"    , oFont2 )

oPrint:Box( 1900, 1010, 2350, 1120 )
oPrint:Say( 1910, 1020, "Moneda"            , oFont2 )
oPrint:Say( 1940, 1020, "Moeda"             , oFont2 )

oPrint:Box( 2250, 0010, 2350, 1120 )

oPrint:Box( 2350, 0010, 2450, 1120 )
oPrint:Say( 2360, 0020, "19. Monto del flete externo / Valor do frete externo", oFont2 )

oPrint:Box( 2450, 0010, 2550, 1120 )
oPrint:Say( 2460, 0020, "20. Monto de reembolso contra entrega / Valor de reembolso contra entrega"   , oFont2 )

oPrint:Box( 2550, 0010, 2800, 1120 )
oPrint:Say( 2560, 0020, "21. Nombre y firma del remitente o su representante"	, oFont2 )
oPrint:Say( 2590, 0068, "Nome e assinatura do remetente ou seu representante"	, oFont2 )
oPrint:Say( 2760, 0020, "Data / Fecha"    												, oFont2 )

oPrint:Box( 2800, 0010, 3150, 1120 )
oPrint:Say( 2810, 0020, "As mercadorias consignadas neste Conhecimento de Transporte foram recebidas pelo"		, oFont2 )
oPrint:Say( 2840, 0020, "transportador aparentemente em bom estado, sob as condições gerais que figuram no"		, oFont2 )
oPrint:Say( 2870, 0020, "verso."																											, oFont2 )
oPrint:Say( 2900, 0020, "Las mercancia consignadas en esta Carta de Porte fueron recebidas por el porteador"	, oFont2 )
oPrint:Say( 2930, 0020, "aparentemente em buen estado, bajo las condiciones generales que figuran al dorso."	, oFont2 )

oPrint:Say( 3000, 0020, "23. Nome, assinatura e carimbo do transoportado ou seu representante"				, oFont2 )
oPrint:Say( 3030, 0020, "    Nombre, firma y sello del porteador o su representante"							, oFont2 )
oPrint:Say( 3100, 0020, "Data / Fecha"																							, oFont2 )

oPrint:Box( 1900, 1120, 2000, 2325 )
oPrint:Say( 1910, 1130, "16. Declaración el valor de las mercancias / Declaração do valor das mercadorias" , oFont2 )

oPrint:Box( 2000, 1120, 2250, 2325 )
oPrint:Say( 2010, 1130, "17. Documentos anexos / Documentos anexos"             , oFont2 )

oPrint:Box( 2250, 1120, 2500, 2325 )
oPrint:Say( 2260, 1130, "18. Instruciones sobre formalidades de aduana / Instruções sobre formalidades de alfândega "         , oFont2 )

oPrint:Box( 2500, 1120, 2950, 2325 )
oPrint:Say( 2510, 1130, "22. Declaraciones y observaciones / Declarações e observações"     , oFont2 )

oPrint:Box( 2950, 1120, 3150, 2325 )
oPrint:Say( 2960, 1130, "24. Nombre y firma del destinatario o su representante" , oFont2 )
oPrint:Say( 2990, 1178, "Nome e assinatura do destinatário ou seu representante" , oFont2 )
oPrint:Say( 3100, 1130, "Data / Fecha"															, oFont2 )

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
Static Function AjustaSX1(cPerg)
      
Local aHlpPor7 := {"Informe se é Impressao ou Reimpressao."}
Local aHlpEsp7 := {"Informe la Impression/Reimpresion "}
Local aHlpIng7 := {"Enter the Printing or Reprinting"}   
                 
Local aHlpPor8 := {"Informe o Tipo de Via"}
Local aHlpEsp8 := {"Informe o Tipo de Via"}
Local aHlpIng8 := {"Informe o Tipo de Via"}  
                        
Local aHlpPor9 := {"Informe se Imprime o Incoterm","no Campo de Declaracao do Valor","das Mercadorias"}
Local aHlpEsp9 := {"Indicar si Imprime o Incoterm","no Campo Declaracion de Valor  ","de las mercancias"}
Local aHlpIng9 := {"Prints Incoterm Field Declaration","of Value of Goods"}

SX1->(DbSetOrder(1))
If SX1->( DbSeek(Padr(cPerg,Len(SX1->X1_GRUPO),' ')+"08")) .And. "Impressão/Reimpr" $ Alltrim(SX1->X1_PERGUNT)
	Reclock("SX1",.F.)
	DBDelete()
	SX1->(MsUnLock())
EndIf

PutSx1( cPerg, "01","Lote De ?           ","¿De Lote ?           ","Lote De ?           ","mv_ch1","C",6,0,0,"G","","DTP","","","mv_par01")
PutSx1( cPerg, "02","Lote Ate ?          ","¿A Lote ?            ","Lote Ate ?          ","mv_ch2","C",6,0,0,"G","","DTP","","","mv_par02")
PutSx1( cPerg, "03","Documento De ?      ","¿De Documento ?      ","Documento 0e ?	    ","mv_ch3","C",6,0,0,"G","","DT6","","","mv_par03")
PutSx1( cPerg, "04","Documento Ate ?     ","¿A Documento  ?      ","Documento Ate ?     ","mv_ch4","C",6,0,0,"G","","DT6","","","mv_par04")
PutSx1( cPerg, "05","Serie De ?          ","¿De Serie ?          ","Serie De ?          ","mv_ch5","C",3,0,0,"G","",""   ,"","","mv_par05")
PutSx1( cPerg, "06","Serie Ate ?         ","¿A Serie  ?          ","Serie Ate ?         ","mv_ch6","C",3,0,0,"G","",""   ,"","","mv_par06")
PutSx1( cPerg, "07","Impressão/Reimpre.? ","¿Impresion/Nuev.Imp.?","Impressão/Reimpre.? ","mv_ch7","N",1,0,0,"C","",""   ,"","","mv_par07","Impressão","Impresion","Printing","","Reimpressão","Reimpresion","Reprinting","","","","","","","","","",aHlpPor7,aHlpIng7,aHlpEsp7)
PutSx1( cPerg, "08","Tipo de Vias ?      ","Tipo de Vias ?       ","Tipo de Vias ?      ","mv_ch8","N",1,0,0,"C","",""   ,"","","mv_par08","Originais","Originais","Originais","","Copias","Copias","Copias","Todas","Todas","Todas","","","","","","",aHlpPor8,aHlpIng8,aHlpEsp8)
PutSx1( cPerg, "09","Imprime Incoterm ?  ","Imprime Incoterm ?   ","Imprime Incoterm  ? ","mv_ch9","N",1,0,0,"C","",""   ,"","","mv_par09","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHlpPor9,aHlpIng9,aHlpEsp9)

Return
