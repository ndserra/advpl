#INCLUDE "protheus.ch"
#INCLUDE "RTMSR18.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR18G ³ Autor ³ Jose L. Pinheiro Jr.  ³ Data ³29.02.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao MIC/DTA Grafico                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR18G                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±³          ³ Para uso em impressora a LASER                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR18G()

Local   nZ       := 0
Local   cPerg    := "RTMR18G"
Private aParamRl := Array(9)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            	// Fil.Origem De		                 ³
//³ mv_par02            	// Viagem De          	         	  ³
//³ mv_par03            	// Fil.Origem Ate  	      		     ³
//³ mv_par04            	// Viagem Ate         		           ³
//³ mv_par05            	// Veiculo De   	   		           ³
//³ mv_par06            	// Veiculo Ate          	           ³
//³ mv_par07            	// Impressao / Reimpressao            ³
//³ mv_par08            	// Originais / Copias		           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AjustaSX1(cPerg)

If Pergunte( cPerg, .T. )
	For nZ := 1 To Len(aParamRl)
		aParamRl[nZ]:=&("mv_par"+StrZero(nZ,2))
	Next nZ
	Processa( { | lEnd | MontaRel( @lEnd ) }, "Gerando MIC Grafico, Aguarde...",, .T. )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR18Imp³ Autor ³ Richard Anderson      ³ Data ³22.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR18			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaRel( lEnd )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local  nLin         := 0, nI := 0
Local  cQuery       := ''
Local  aAreaAtu     := GetArea()
Local  aAreaSM0     := SM0->(GetArea())
Local  aRegDCA      := {}
Local  nTotVol      := 0
Local  nTotPes      := 0
Local  nVolAnt      := 0
Local  nPesAnt      := 0
Local  nVolAcu      := 0
Local  nPesAcu      := 0
Local  _nSubpeso	  := 0
Local  _nSubVol     := 0
//-- Vias do MIC/DTA
Local  aVias        	 := {}
Local  nQtdVia        := 0
Local  lFim           := .F.
Local  cCodAdu        := ''  
Local  nX             := 0, nVia := 0

Private  aDadMIC      := {}
Private  aDadCli      := {}
Private  aDocAne      := {}
Private  aObsDoc      := {}
Private  aDadEmb      := {}
Private  nQtdDoc      := 0
Private  cAliasQry  	 := GetNextAlias()
Private  oPrint,oFont1,oFont2,oFont3,oFontD,oFontD1,oFontE
Private  cFilMIC      := ''
Private  cNumMIC      := ''
Private  cCodVei      := ''
Private  cIteMIC      := ''
Private  cDatMic      := ''

Private cLogoMIC  := "lgmic.bmp"
Private cFileLogo := "lgrl"+SM0->M0_CODIGO+SM0->M0_CODFIL+".bmp" // Empresa+Filial

If !File(cFileLogo)
	cFileLogo := "lgmic"+SM0->M0_CODIGO+".bmp" // Empresa
EndIf

Aadd(aVias, 'Primeira via - Alfandega de partida.')
Aadd(aVias, 'Duplicado - Aduana de salida en Pais de partida.')
Aadd(aVias, 'Triplicado - Aduana de entrada en Pais de destino.')
Aadd(aVias, 'Quadruplicado - Aduana de destino.')
Aadd(aVias, 'Quintuplicado - Transportista.')

If aParamRl[08] == 2
	aVias := {}
	Aadd(aVias, 'Copia.')
ElseIf aParamRl[08] == 3
	Aadd(aVias, 'Copia.')
EndIf

nQtdVia        := Len(aVias)

oFont1  := TFont():New("Arial"        ,00,12,,.T.,,,,.T.,.F.)
oFont1a := TFont():New("Arial"        ,00,09,,.T.,,,,.T.,.F.)
oFont2  := TFont():New("Arial"        ,00,07,,.T.,,,,.T.,.F.)
oFont3  := TFont():New("Arial Narrow" ,00,09,,.T.,,,,.T.,.F.)
oFontD  := TFont():New("Courier New"  ,06,10)
oFontD1 := TFont():New("Courier New"  ,06,08)
oFontE  := TFont():New("Arial"        ,00,15,,.T.,,,,.T.,.F.)

oPrint := TMSPrinter():New( "MIC/DTA - Gráfico" )

cQuery := "SELECT * FROM ("
cQuery += "SELECT DT6_FILDOC, DT6_DOC  , DT6_SERIE , DID_FILORI, DID_VIAGEM, DID_CODVEI, DII_ITEMIC, DII_CDAORI, DII_CDADES, DID_QTDDOC , "
cQuery += "       DT6_QTDVOL, DT6_PESO , DT6_PESLIQ, DT6_VALMER, DID_FILMIC, DID_NUMMIC, DID_DATMIC, DTQ_ROTA  , DII.R_E_C_N_O_ RECNODII, "
cQuery += "       DT6_SIGTRA, DT6_MOEDA, DT6_VALTOT, DID_QTDFOL, DII_NUMFOL"
cQuery += " FROM "
cQuery += RetSqlName("DID")+" DID, "
cQuery += RetSqlName("DII")+" DII, "
cQuery += RetSqlName("DT6")+" DT6, "
cQuery += RetSqlName("DTQ")+" DTQ  "
cQuery += " WHERE DID.DID_FILIAL = '"+xFilial("DID")+"'"
cQuery += "   AND DID.DID_FILORI BETWEEN '"+aParamRl[01]+"' AND '"+aParamRl[03]+"'"
cQuery += "   AND DID.DID_VIAGEM BETWEEN '"+aParamRl[02]+"' AND '"+aParamRl[04]+"'"
cQuery += "   AND DID.DID_CODVEI BETWEEN '"+aParamRl[05]+"' AND '"+aParamRl[06]+"'"
cQuery += "   AND DID.D_E_L_E_T_  = ' '"
cQuery += "   AND DII.DII_FILIAL  = '"+xFilial("DII")+"'"
cQuery += "   AND DII.DII_FILMIC  = DID_FILMIC"
cQuery += "   AND DII.DII_NUMMIC  = DID_NUMMIC"
cQuery += "   AND DII.DII_CODVEI  = DID_CODVEI"
cQuery += "   AND DII.DII_IMPMIC IN "+Iif(aParamRl[07] == 1,"( ' ', '0')","( '1' )")
cQuery += "   AND DII.D_E_L_E_T_  = ' '"
cQuery += "   AND DT6.DT6_FILIAL  = '"+xFilial("DT6")+"'"
cQuery += "   AND DT6.DT6_FILDOC  = DII_FILDOC"
cQuery += "   AND DT6.DT6_DOC     = DII_DOC"
cQuery += "   AND DT6.DT6_SERIE   = DII_SERIE"
cQuery += "   AND DT6.DT6_DOCTMS <> 'K'"
cQuery += "   AND DT6.D_E_L_E_T_  = ' '"
cQuery += "   AND DTQ.DTQ_FILIAL  = '"+xFilial("DTQ")+"'"
cQuery += "   AND DTQ.DTQ_FILORI  = DID_FILORI"
cQuery += "   AND DTQ.DTQ_VIAGEM  = DID_VIAGEM"
cQuery += "   AND DTQ.DTQ_TIPVIA IN ( '1', '3' )"
cQuery += "   AND DTQ.D_E_L_E_T_  = ' '"
cQuery += " UNION ALL "
cQuery += "SELECT DT6_FILDCO DT6_FILDOC, DT6_DOCDCO DT6_DOC  , DT6_SERDCO DT6_SERIE , DID_FILORI, DID_VIAGEM, DID_CODVEI, DII_ITEMIC, DII_CDAORI, DII_CDADES, DID_QTDDOC , "
cQuery += "       DT6_QTDVOL           , DT6_PESO            , DT6_PESLIQ           , DT6_VALMER, DID_FILMIC, DID_NUMMIC, DID_DATMIC, DTQ_ROTA  , DII.R_E_C_N_O_ RECNODII, "
cQuery += "       DT6_SIGTRA           , DT6_MOEDA           , DT6_VALTOT           , DID_QTDFOL, DII_NUMFOL"
cQuery += " FROM "
cQuery += RetSqlName("DID")+" DID, "
cQuery += RetSqlName("DII")+" DII, "
cQuery += RetSqlName("DT6")+" DT6, "
cQuery += RetSqlName("DTQ")+" DTQ  "
cQuery += " WHERE DID.DID_FILIAL = '"+xFilial("DID")+"'"
cQuery += "   AND DID.DID_FILORI BETWEEN '"+aParamRl[01]+"' AND '"+aParamRl[03]+"'"
cQuery += "   AND DID.DID_VIAGEM BETWEEN '"+aParamRl[02]+"' AND '"+aParamRl[04]+"'"
cQuery += "   AND DID.DID_CODVEI BETWEEN '"+aParamRl[05]+"' AND '"+aParamRl[06]+"'"
cQuery += "   AND DID.D_E_L_E_T_  = ' '"
cQuery += "   AND DII.DII_FILIAL  = '"+xFilial("DII")+"'"
cQuery += "   AND DII.DII_FILMIC  = DID_FILMIC"
cQuery += "   AND DII.DII_NUMMIC  = DID_NUMMIC"
cQuery += "   AND DII.DII_CODVEI  = DID_CODVEI"
cQuery += "   AND DII.DII_IMPMIC IN "+Iif(aParamRl[07] == 1,"( ' ', '0')","( '1' )")
cQuery += "   AND DII.D_E_L_E_T_  = ' '"
cQuery += "   AND DT6.DT6_FILIAL  = '"+xFilial("DT6")+"'"
cQuery += "   AND DT6.DT6_FILDOC  = DII_FILDOC"
cQuery += "   AND DT6.DT6_DOC     = DII_DOC"
cQuery += "   AND DT6.DT6_SERIE   = DII_SERIE"
cQuery += "   AND DT6.DT6_DOCTMS  = 'K'"
cQuery += "   AND DT6.D_E_L_E_T_  = ' '"
cQuery += "   AND DTQ.DTQ_FILIAL  = '"+xFilial("DTQ")+"'"
cQuery += "   AND DTQ.DTQ_FILORI  = DID_FILORI"
cQuery += "   AND DTQ.DTQ_VIAGEM  = DID_VIAGEM"
cQuery += "   AND DTQ.DTQ_TIPVIA IN ( '1', '3' )"
cQuery += "   AND DTQ.D_E_L_E_T_  = ' ' ) MIC_QRY"
cQuery += " ORDER BY DID_FILORI,DID_VIAGEM,DID_CODVEI,DII_ITEMIC"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
TcSetField(cAliasQry,"DT6_QTDVOL","N",TamSX3("DT6_QTDVOL")[1],TamSX3("DT6_QTDVOL")[2])
TcSetField(cAliasQry,"DT6_PESO"  ,"N",TamSX3("DT6_PESO"  )[1],TamSX3("DT6_PESO"  )[2])
TcSetField(cAliasQry,"DT6_PESLIQ","N",TamSX3("DT6_PESLIQ")[1],TamSX3("DT6_PESLIQ")[2])
TcSetField(cAliasQry,"DT6_VALMER","N",TamSX3("DT6_VALMER")[1],TamSX3("DT6_VALMER")[2])
TcSetField(cAliasQry,"DID_DATMIC","D",TamSX3("DID_DATMIC")[1],TamSX3("DID_DATMIC")[2])
TcSetField(cAliasQry,"DT6_MOEDA" ,"N",TamSX3("DT6_MOEDA" )[1],TamSX3("DT6_MOEDA" )[2])
TcSetField(cAliasQry,"DT6_VALTOT","N",TamSX3("DT6_VALTOT")[1],TamSX3("DT6_VALTOT")[2])

aLin := {}

While (cAliasQry)->(!Eof())
	
	cFilOri := (cAliasQry)->DID_FILORI
	cViagem := (cAliasQry)->DID_VIAGEM
	cCodVei := (cAliasQry)->DID_CODVEI
	nTotVol := 0
	nTotPes := 0
	nVolAnt := 0
	nPesAnt := 0
	nVolAcu := 0
	nPesAcu := 0
	nQtdDoc := 0
	
	While (cAliasQry)->(!Eof()) .And. (cAliasQry)->(DID_FILORI+DID_VIAGEM+DID_CODVEI) == cFilOri+cViagem+cCodVei
		
		
		IncProc()
		
		If Interrupcao(@lEnd)
			Exit
		EndIf
		
		SM0->(dbSetOrder(1))
		SM0->(dbSeek(cEmpAnt+(cAliasQry)->DID_FILMIC))
		
		cFilMIC := (cAliasQry)->DID_FILMIC
		cNumMIC := (cAliasQry)->DID_NUMMIC
		cIteMIC := (cAliasQry)->DII_ITEMIC
		
		// Data MIC
		aDadMIC := TmsDadMIC('06',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
		If ValType(aDadMIC[1]) == 'D'
			cDatMic := DtoC(aDadMIC[1])
		Else
			cDatMic := aDadMIC[1]
		EndIf
		
		//-- Obtem as regioes de origem/destino a partir da rota da viagem
		aRegDCA := TmsRegDCA((cAliasQry)->DTQ_ROTA)
		cCdrOri := ' '
		cPaiOri := ' '
		cCdrDes := ' '
		cPaiDes := ' '
		If Len(aRegDCA) > 0
			cCdrOri := aRegDCA[1,1]
			cPaiOri := Posicione('DUY',1,xFilial('DUY')+cCdrOri,'DUY_PAIS')
			cCdrDes := aRegDCA[Len(aRegDCA),1]
			cPaiDes := Posicione('DUY',1,xFilial('DUY')+cCdrDes,'DUY_PAIS')
		EndIf
		
		
		If (cAliasQry)->DII_ITEMIC == StrZero(1,Len(DII->DII_ITEMIC)) //--  Caratola
			
			//-- Imprime folha de rosto - Caratula
			ImpCaratula(oPrint,oFont1,oFont1a,oFont2,oFont3)
			
			//-- Campo 03: Transporte Aduaneiro
			If DID->DID_TRANAD =='1' // SIM
				Aadd(aLin, { "Say", 0250, 1245, 'X', oFontD  })
			Else
				Aadd(aLin, { "Say", 0250, 1500, 'X', oFontD  })
			EndIf
			
			//-- Campo 04: Numero MIC/DTA
			Aadd(aLin, { "Say", 0210, 1800,  Transform((cAliasQry)->DID_NUMMIC,PesqPict('DID','DID_NUMMIC')) , oFontE  })
			
			//-- Campo 05: Folha
			Aadd(aLin, { "Say", 0370, 1270,  (cAliasQry)->DII_NUMFOL+'/'+(cAliasQry)->DID_QTDFOL , oFontD  })
			
			//-- Campo 06: Data de emissão
			Aadd(aLin, { "Say", 0370, 1850,  cDatMic , oFontD  })
			
			//-- Campo 07: Alfândega
			cCodAdu := ' '
			aDadMIC := TmsDadMIC('07',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If Empty(aDadMIC[2])
				Aadd(aLin, { "Say", 0520, 1140,  Left(AllTrim(aDadMIC[1]),Len(AllTrim(aDadMIC[1]))-TamSx3('DI1_CODADU')[1]) , oFontD  })
				cCodAdu := Right(AllTrim(aDadMIC[1]),TamSx3('DI1_CODADU')[1])
			Else
				Aadd(aLin, { "Say", 0520, 1140,  aDadMIC[1] , oFontD  })
				cCodAdu := aDadMIC[2]
			EndIf
			Aadd(aLin, { "Say", 0520, 2050,  Substr(cCodAdu,1,1) , oFontD  })
			Aadd(aLin, { "Say", 0520, 2090,  Substr(cCodAdu,2,1) , oFontD  })
			Aadd(aLin, { "Say", 0520, 2130,  Substr(cCodAdu,3,1) , oFontD  })
			Aadd(aLin, { "Say", 0520, 2170,  Substr(cCodAdu,4,1) , oFontD  })
			Aadd(aLin, { "Say", 0520, 2210,  Substr(cCodAdu,5,1) , oFontD  })
			Aadd(aLin, { "Say", 0520, 2250,  Substr(cCodAdu,6,1) , oFontD  })
			Aadd(aLin, { "Say", 0520, 2290,  Substr(cCodAdu,7,1) , oFontD  })
			
			//-- Campo 08: Cidade e pais de destino final
			aDadMIC := TmsDadMIC('08',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0660, 1140,  Left(AllTrim(aDadMIC[1]),Len(AllTrim(aDadMIC[1]))-Len(DUY->DUY_PAIS)) , oFontD  })
			Aadd(aLin, { "Say", 0680, 2212,  Transform(Right(AllTrim(aDadMIC[1]),Len(DUY->DUY_PAIS)),'@R X X X') , oFontD  })
			Aadd(aLin, { "Say", 0690, 1140,  aDadMIC[2] , oFontD  })
			
			//-- Campo 09: Caminhão Original
			aDadMIC   := TmsDadMIC('09',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0830, 0050,  aDadMIC[1] , oFontD  })
			Aadd(aLin, { "Say", 0860, 0050,  aDadMIC[2] , oFontD  })
			Aadd(aLin, { "Say", 0890, 0050,  aDadMIC[3] , oFontD  })
			Aadd(aLin, { "Say", 0920, 0050,  aDadMIC[4] , oFontD  })
			
			//-- Campo 16: Caminhão Substitutito
			aDadMIC := TmsDadMIC('16',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0830, 1140,  aDadMIC[1] , oFontD  })
			Aadd(aLin, { "Say", 0860, 1140,  aDadMIC[2] , oFontD  })
			Aadd(aLin, { "Say", 0890, 1140,  aDadMIC[3] , oFontD  })
			Aadd(aLin, { "Say", 0920, 1140,  aDadMIC[4] , oFontD  })
			
			//-- Campo 10: Cadastro geral do contribuinte
			aDadMIC := TmsDadMIC('10',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			aDadMIC[1] := AllTrim(StrTran(Transform(aDadMIC[1], '@R 99999999999999999999'),'-',''))
			If !Empty(aDadMIC[1])
				Aadd(aLin, { "Say", 1080, 0050,  TRANSFORM(aDadMIC[1],If(Len(aDadMIC[1])>11,'@R 99.999.999/9999-99','@R 999.999.999-99')) , oFontD  })
			EndIf
			
			//-- Campo 11: Placa do caminhão
			aDadMIC := TmsDadMIC('11',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1080, 0680,  aDadMIC[1] , oFontD  })
			
			//-- Campo 17: Cadastro Geral de Contribuintes
			aDadMIC := TmsDadMIC('17',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			aDadMIC[1] := AllTrim(StrTran(Transform(aDadMIC[1], '@R 99999999999999999999'),'-',''))
			If !Empty(aDadMIC[1])
				Aadd(aLin, { "Say", 1080, 1140,  TRANSFORM(aDadMIC[1],If(Len(aDadMIC[1])>11,'@R 99.999.999/9999-99','@R 999.999.999-99')) , oFontD  })
			Endif
			
			//-- Campo 18: Placa do caminhão
			aDadMIC := TmsDadMIC('18',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1080, 1850,  aDadMIC[1] , oFontD  })
			
			//-- Campo 12: Marca e numero
			aDadMIC := TmsDadMIC('12',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1200, 0050,  aDadMIC[1] , oFontD  })
			Aadd(aLin, { "Say", 1230, 0050,  aDadMIC[2] , oFontD  })
			
			//-- Campo 13: Capacidade de tração
			aDadMIC := TmsDadMIC('13',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1240, 0760,  Transform(aDadMIC[1],PesqPict('DA3','DA3_CAPACM')) , oFontD  })
			
			//-- Campo 19: Marca e numero
			aDadMIC := TmsDadMIC('19',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1200, 1140,  aDadMIC[1] , oFontD  })
			Aadd(aLin, { "Say", 1230, 1140,  aDadMIC[2] , oFontD  })
			
			//-- Campo 20: Capacidade de tração
			aDadMIC := TmsDadMIC('20',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If aDadMIC[1] > 0
				Aadd(aLin, { "Say", 1240, 1750,  Transform(aDadMIC[1],PesqPict('DA3','DA3_CAPACM')) , oFontD  })
			End If
			
			//-- Campo 14: Ano
			aDadMIC := TmsDadMIC('14',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1380, 0150,  aDadMIC[1] , oFontD  })
			
			//-- Campo 15: Reboque
			aDadMIC := TmsDadMIC('15',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If !Empty(aDadMIC[1])
				cReboque := 'X'
				cPlacaRb := Padr(aDadMIC[1],Len(DA3->DA3_PLACA))
			Else
				cReboque := ''
				cPlacaRb := ''
			EndIf
			Aadd(aLin, { "Say", 1320, 0630,  cReboque , oFontD  })
			Aadd(aLin, { "Say", 1400, 0780,  cPlacaRb , oFontD  })
			
			//-- Campo 21: Ano
			aDadMIC := TmsDadMIC('21',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1380, 1340,  aDadMIC[1] , oFontD  })
			
			//-- Campo 22: Reboque
			aDadMIC := TmsDadMIC('22',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If !Empty(aDadMIC[1])
				cReboque := 'X'
				cPlacaRb := Padr(aDadMIC[1],Len(DA3->DA3_PLACA))
				
				Aadd(aLin, { "Say", 1320, 1780,  cReboque , oFontD  })
				Aadd(aLin, { "Say", 1400, 1850,  cPlacaRb , oFontD  })
				
			EndIf
			
			//-- Campo 23: Numero do Conhecimento
			Aadd(aLin, { "Say", 1540, 0050,  Transform((cAliasQry)->(DT6_SIGTRA+DT6_SERIE+DT6_DOC),'@R AA.999.999999') , oFontD  })
			
			//-- Campo 24: Alfandega de destino
			cCodAdu := ' '
			aDadMIC := TmsDadMIC('24',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If Empty(aDadMIC[2])
				Aadd(aLin, { "Say", 1540, 0400, Left(AllTrim(aDadMIC[1]),Len(AllTrim(aDadMIC[1]))-TamSx3('DI1_CODADU')[1]) , oFontD1  })
				cCodAdu := Right(AllTrim(aDadMIC[1]),TamSx3('DI1_CODADU')[1])
			Else
				Aadd(aLin, { "Say", 1540, 0400,  Substr(aDadMIC[1],1,23), oFontD1  })
				cCodAdu := StrTran(aDadMIC[2],' ','')
			EndIf
			Aadd(aLin, { "Say", 1540, 0845,  Substr(cCodAdu,1,1) , oFontD  })
			Aadd(aLin, { "Say", 1540, 0885,  Substr(cCodAdu,2,1) , oFontD  })
			Aadd(aLin, { "Say", 1540, 0925,  Substr(cCodAdu,3,1) , oFontD  })
			Aadd(aLin, { "Say", 1540, 0965,  Substr(cCodAdu,4,1) , oFontD  })
			Aadd(aLin, { "Say", 1540, 1005,  Substr(cCodAdu,5,1) , oFontD  })
			Aadd(aLin, { "Say", 1540, 1045,  Substr(cCodAdu,6,1) , oFontD  })
			Aadd(aLin, { "Say", 1540, 1085,  Substr(cCodAdu,7,1) , oFontD  })
			
			
			//-- Campo 33: Dados do Cliente Remetente
			aDadCli := TmsDadMIC('33',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1490, 1140,  aDadCli[1] , oFontD  })
			Aadd(aLin, { "Say", 1520, 1140,  aDadCli[2] , oFontD  })
			Aadd(aLin, { "Say", 1550, 1140,  aDadCli[3] , oFontD  })
			
			//-- Campo 25: Moeda
			aDadMIC := TmsDadMIC('25',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1680, 0100,  aDadMIC[1] , oFontD  })
			
			//-- Campo 26: Origem das Mercadorias
			aDadMIC := TmsDadMIC('26',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If SYA->(MsSeek(xFilial('SYA')+Right(aDadMIC[1],Len(DUY->DUY_PAIS)) ))
				Aadd(aLin, { "Say", 1680, 0400,  Left(aDadMIC[1],Len(aDadMIC[1])-Len(DUY->DUY_PAIS))  , oFontD  })
				Aadd(aLin, { "Say", 1680, 1006,  Transform(Right(aDadMIC[1],Len(DUY->DUY_PAIS)),'@R X X X') , oFontD  })
			Else
				Aadd(aLin, { "Say", 1680, 0400,  aDadMIC[1] , oFontD  })
			EndIf
			
			//-- Campo 34: Dados do Cliente Destinatario
			aDadCli := TmsDadMIC('34',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1640, 1140,  aDadCli[1] , oFontD  })
			Aadd(aLin, { "Say", 1670, 1140,  aDadCli[2] , oFontD  })
			Aadd(aLin, { "Say", 1700, 1140,  aDadCli[3] , oFontD  })
			
			
			//-- Campo 27: Valor FOT
			aDadMIC := TmsDadMIC('27',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1840, 0010,  Transform(aDadMIC[1],PesqPict('DT6','DT6_VALMER')) , oFontD  })
			
			//-- Campo 28: Frete
			aDadMIC := TmsDadMIC('28',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1840, 0410,  Transform(aDadMIC[1],'@E 9,999,999.99') , oFontD  })
			
			//-- Campo 29: Seguro
			aDadMIC := TmsDadMIC('29',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1840, 0770,  Transform(aDadMIC[1],PesqPict('DTC','DTC_VALSEG')) , oFontD  })
			
			//-- Campo 35: Dados do Cliente Consignatário
			aDadCli := TmsDadMIC('35',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1790, 1140,  aDadCli[1] , oFontD  })
			Aadd(aLin, { "Say", 1820, 1140,  aDadCli[2] , oFontD  })
			Aadd(aLin, { "Say", 1850, 1140,  aDadCli[3] , oFontD  })
			
			//-- Campo 30: Tipo de Volumes
			aDadEmb := _DadEmb((cAliasQry)->DT6_FILDOC,(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE)
			Aadd(aLin, { "Say", 1990, 0030,  aDadEmb[1] , oFontD  })
			Aadd(aLin, { "Say", 1990, 0310,  Transform( aDadEmb[2],'@R X X') , oFontD  })
			
			//-- Campo 31: Qtde.de Volumes
			aDadMIC := TmsDadMIC('31',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If valtype(aDadMIC[1]) == 'C'
				aDadMIC[1] := Val(StrTran(aDadMIC[1],',',''))
			EndIf
			
			If (aDadMic[1] > 9)
				Aadd(aLin, { "Say", 1990, 0390,  Transform(aDadMic[1],'@E 999,999') , oFontD  })
			Else
				Aadd(aLin, { "Say", 1990, 0510,  StrZero(aDadMic[1],2) , oFontD  })
			EndIf
			
			//-- Campo 32: Peso Bruto
			aDadMIC := TmsDadMIC('32',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1980, 0770, 'Bruto: ' + Transform(aDadMIC[1],'@E 999,999.999') , oFontD1 })
			//-- Campo 32: Peso Liquido
			aDadMIC := TmsDadMIC('41',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 2010, 0770, 'Liqu.: ' + Transform(aDadMIC[1],'@E 999,999.999') , oFontD1 })
			
			//-- Campo 36: Documentos Anexos
			aDocAne := TmsDadMIC('36',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1940, 1140,  aDocAne[1] , oFontD  })
			Aadd(aLin, { "Say", 1980, 1140,  aDocAne[2] , oFontD  })
			Aadd(aLin, { "Say", 2020, 1140,  aDocAne[3] , oFontD  })
			Aadd(aLin, { "Say", 2060, 1140,  aDocAne[4] , oFontD  })
			Aadd(aLin, { "Say", 2100, 1140,  aDocAne[5] , oFontD  })
			
			//-- Campo 37: Lacres
			aDadMIC := TmsDadMIC('37',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 2090, 0030,  aDadMIC[1] , oFontD  })
			
			//-- Campo 38: Marcas e numeros dos volumes
			nLin := 2240
			aObsDoc:= TmsDadMIC('38',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			For nI := 1 To Len(aObsDoc)
				Aadd(aLin, { "Say", nLin, 0030,  aObsDoc[nI] , oFontD  })
				nLin += 30
				If nI > 8
					Exit
				EndIf
			Next nI
			
			//-- Campo 40: Rota e prazo de transporte
			nLin := 2580
			aPercRt:= TmsDadMIC('40',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			For nI := 1 To Len(aPercRt)
				Aadd(aLin, { "Say", nLin, 1140,  aPercRt[nI] , oFontD  })
				nLin += 30
			Next nI
			
			//-- Campo 39: Assinatura e carimbo do transportador
			Aadd(aLin, { "Say", 3140, 0300,  cDatMic , oFontD  })
			
		ElseIf nQtdDoc == 2
			nQtdDoc := 1
		Else
			nQtdDoc += 1
		EndIf
		
		
		If nQtdDoc == 1
			//-- Rosto continuacao - parte superior
			//-- Imprime folha de rosto - Continuacao
			ImpContinua(oPrint,oFont1,oFont1a,oFont2,oFont3)
			
			//-- Campo 32 - Peso Bruto
			aDadMIC := TmsDadMIC('32',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			_nSubPeso     := aDadMIC[1]
			_nSubVol      := (cAliasQry)->DT6_QTDVOL
			
			
			//-- Campo 04: Numero MIC/DTA
			Aadd(aLin, { "Say", 0210, 1800,  Transform((cAliasQry)->DID_NUMMIC,PesqPict('DID','DID_NUMMIC')) , oFontE  })
			
			//-- Campo 05: Folha
			Aadd(aLin, { "Say", 0370, 1270,  (cAliasQry)->DII_NUMFOL+'/'+(cAliasQry)->DID_QTDFOL , oFontD  })
			
			//-- Campo 06: Data de emissão
			Aadd(aLin, { "Say", 0370, 1850,  cDatMic , oFontD  })
			
			//-- Campo 23: Numero do Conhecimento
			Aadd(aLin, { "Say", 0540, 0050,  Transform((cAliasQry)->(DT6_SIGTRA+DT6_SERIE+DT6_DOC),'@R AA.999.999999') , oFontD  })
			
			//-- Campo 24: Alfandega de destino
			cCodAdu := ' '
			aDadMIC := TmsDadMIC('24',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If Empty(aDadMIC[2])
				Aadd(aLin, { "Say", 0540, 0400,  Left(AllTrim(aDadMIC[1]),Len(AllTrim(aDadMIC[1]))-TamSx3('DI1_CODADU')[1]) , oFontD1  })
				cCodAdu := Right(AllTrim(aDadMIC[1]),TamSx3('DI1_CODADU')[1])
			Else
				Aadd(aLin, { "Say", 0540, 0400,  Substr(aDadMIC[1],1,23) , oFontD1  })
				cCodAdu := StrTran(aDadMIC[2],' ','')
			EndIf
			Aadd(aLin, { "Say", 0540, 0845,  Substr(cCodAdu,1,1) , oFontD  })
			Aadd(aLin, { "Say", 0540, 0885,  Substr(cCodAdu,2,1) , oFontD  })
			Aadd(aLin, { "Say", 0540, 0925,  Substr(cCodAdu,3,1) , oFontD  })
			Aadd(aLin, { "Say", 0540, 0965,  Substr(cCodAdu,4,1) , oFontD  })
			Aadd(aLin, { "Say", 0540, 1005,  Substr(cCodAdu,5,1) , oFontD  })
			Aadd(aLin, { "Say", 0540, 1045,  Substr(cCodAdu,6,1) , oFontD  })
			Aadd(aLin, { "Say", 0540, 1085,  Substr(cCodAdu,7,1) , oFontD  })
			
			//-- Campo 33: Dados do Cliente Remetente
			aDadCli := TmsDadMIC('33',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0490, 1140,  aDadCli[1] , oFontD  })
			Aadd(aLin, { "Say", 0520, 1140,  aDadCli[2] , oFontD  })
			Aadd(aLin, { "Say", 0550, 1140,  aDadCli[3] , oFontD  })
			
			//-- Campo 25: Moeda
			aDadMIC := TmsDadMIC('25',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0680, 0100,  aDadMIC[1] , oFontD  })
			
			//-- Campo 26: Origem das Mercadorias
			aDadMIC := TmsDadMIC('26',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If SYA->(MsSeek(xFilial('SYA')+Right(aDadMIC[1],Len(DUY->DUY_PAIS)) ))
				Aadd(aLin, { "Say", 0680, 0400,  Left(aDadMIC[1],Len(aDadMIC[1])-Len(DUY->DUY_PAIS)) , oFontD  })
				Aadd(aLin, { "Say", 0680, 1006,  Transform(Right(aDadMIC[1],Len(DUY->DUY_PAIS)),'@R X X X') , oFontD  })
			Else
				Aadd(aLin, { "Say", 0680, 0400,  aDadMIC[1] , oFontD  })
			EndIf
			
			//-- Campo 34: Dados do Cliente Destinatario
			aDadCli := TmsDadMIC('34',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0640, 1140,  aDadCli[1] , oFontD  })
			Aadd(aLin, { "Say", 0670, 1140,  aDadCli[2] , oFontD  })
			Aadd(aLin, { "Say", 0700, 1140,  aDadCli[3] , oFontD  })
			
			//-- Campo 27: Valor FOT
			aDadMIC := TmsDadMIC('27',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0840, 0010,  Transform(aDadMIC[1],PesqPict('DT6','DT6_VALMER')) , oFontD  })
			
			//-- Campo 28: Frete
			aDadMIC := TmsDadMIC('28',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0840, 0410,  Transform(aDadMIC[1],'@E 9,999,999.99') , oFontD  })
			
			//-- Campo 29: Seguro
			aDadMIC := TmsDadMIC('29',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0840, 0770,  Transform(aDadMIC[1],PesqPict('DTC','DTC_VALSEG')) , oFontD  })
			
			//-- Campo 35: Dados do Cliente Consignatário
			aDadCli := TmsDadMIC('35',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0790, 1140,  aDadCli[1] , oFontD  })
			Aadd(aLin, { "Say", 0820, 1140,  aDadCli[2] , oFontD  })
			Aadd(aLin, { "Say", 0850, 1140,  aDadCli[3] , oFontD  })
			
			//-- Campo 30: Tipo de Volumes
			aDadEmb := _DadEmb((cAliasQry)->DT6_FILDOC,(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE)
			Aadd(aLin, { "Say", 0990, 0030,  aDadEmb[1] , oFontD  })
			Aadd(aLin, { "Say", 0990, 0310,  Transform( aDadEmb[2],'@R X X') , oFontD  })
			
			//-- Campo 31: Qtde.de Volumes
			aDadMIC := TmsDadMIC('31',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			If valtype(aDadMIC[1]) == 'C'
				aDadMIC[1] := Val(StrTran(aDadMIC[1],',',''))
			EndIf
			
			If (aDadMic[1] > 9)
				Aadd(aLin, { "Say", 0990, 0400,  Transform(aDadMic[1],'@E 999,999') , oFontD  })
			Else
				Aadd(aLin, { "Say", 0990, 0550,  StrZero(aDadMic[1],2) , oFontD  })
			EndIf
			
			//-- Campo 32: Peso Bruto
			aDadMIC := TmsDadMIC('32',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0980, 0770, 'Bruto: ' + Transform(aDadMIC[1],'@E 999,999.999') , oFontD1 })
			//-- Campo 32: Peso Liquido
			aDadMIC := TmsDadMIC('41',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1010, 0770, 'Liqu.: ' + Transform(aDadMIC[1],'@E 999,999.999') , oFontD1 })
			
			//-- Campo 36: Documentos Anexos
			aDocAne := TmsDadMIC('36',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 0940, 1140,  aDocAne[1] , oFontD  })
			Aadd(aLin, { "Say", 0980, 1140,  aDocAne[2] , oFontD  })
			Aadd(aLin, { "Say", 1020, 1140,  aDocAne[3] , oFontD  })
			Aadd(aLin, { "Say", 1060, 1140,  aDocAne[4] , oFontD  })
			
			//-- Campo 37: Lacres
			aDadMIC := TmsDadMIC('37',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			Aadd(aLin, { "Say", 1090, 0030,  aDadMIC[1] , oFontD  })
			
			//-- Campo 38: Marcas e numeros dos volumes
			nLin := 1250
			aObsDoc:= TmsDadMIC('38',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			For nI := 1 To Len(aObsDoc)
				Aadd(aLin, { "Say", nLin, 0030,  aObsDoc[nI] , oFontD  })
				nLin += 30
				If nI > 6
					Exit
				EndIf
			Next nI
			
			
			If (cAliasQry)->DID_QTDDOC > 2
				If (cAliasQry)->RECNODII > 0
					DII->(dbGoTo((cAliasQry)->RECNODII))
					RecLock('DII',.F.)
					DII->DII_IMPMIC := '1' //-- Impresso
					MsUnLock()
				EndIf
				
				(cAliasQry)->(dbSkip())
				If (cAliasQry)->(!Eof())
					
					//-- Rosto continuacao - parte inferior
					cFilMIC := (cAliasQry)->DID_FILMIC
					cNumMIC := (cAliasQry)->DID_NUMMIC
					cIteMIC := (cAliasQry)->DII_ITEMIC
					
					//-- Armazena o conteudo do campo 32 para impressao no campo 42 e 43.
					//-- Campo 32 - Peso Bruto
					aDadMIC := TmsDadMIC('32',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					_nSubPeso     += aDadMIC[1]
					_nSubVol      += (cAliasQry)->DT6_QTDVOL
					
					//-- Campo 23: Numero do Conhecimento
					Aadd(aLin, { "Say", 1590, 0050,  Transform((cAliasQry)->(DT6_SIGTRA+DT6_SERIE+DT6_DOC),'@R AA.999.999999') , oFontD  })
					
					//-- Campo 24: Alfandega de destino
					cCodAdu := ' '
					aDadMIC := TmsDadMIC('24',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					If Empty(aDadMIC[2])
						Aadd(aLin, { "Say", 1590, 0400,  Left(AllTrim(aDadMIC[1]),Len(AllTrim(aDadMIC[1]))-TamSx3('DI1_CODADU')[1]) , oFontD1  })
						cCodAdu := Right(AllTrim(aDadMIC[1]),TamSx3('DI1_CODADU')[1])
					Else
						Aadd(aLin, { "Say", 1590, 0400,  Substr(aDadMIC[1],1,23) , oFontD1  })
						cCodAdu := StrTran(aDadMIC[2],' ','')
					EndIf
					Aadd(aLin, { "Say", 1590, 0845,  Substr(cCodAdu,1,1) , oFontD  })
					Aadd(aLin, { "Say", 1590, 0885,  Substr(cCodAdu,2,1) , oFontD  })
					Aadd(aLin, { "Say", 1590, 0925,  Substr(cCodAdu,3,1) , oFontD  })
					Aadd(aLin, { "Say", 1590, 0965,  Substr(cCodAdu,4,1) , oFontD  })
					Aadd(aLin, { "Say", 1590, 1005,  Substr(cCodAdu,5,1) , oFontD  })
					Aadd(aLin, { "Say", 1590, 1045,  Substr(cCodAdu,6,1) , oFontD  })
					Aadd(aLin, { "Say", 1590, 1085,  Substr(cCodAdu,7,1) , oFontD  })
					
					
					//-- Campo 33: Dados do Cliente Remetente
					aDadCli := TmsDadMIC('33',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					Aadd(aLin, { "Say", 1540, 1140,  aDadCli[1] , oFontD  })
					Aadd(aLin, { "Say", 1570, 1140,  aDadCli[2] , oFontD  })
					Aadd(aLin, { "Say", 1600, 1140,  aDadCli[3] , oFontD  })
					
					//-- Campo 25: Moeda
					aDadMIC := TmsDadMIC('25',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					Aadd(aLin, { "Say", 1730, 0100,  aDadMIC[1] , oFontD  })
					
					//-- Campo 26: Origem das Mercadorias
					aDadMIC := TmsDadMIC('26',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					If SYA->(MsSeek(xFilial('SYA')+Right(aDadMIC[1],Len(DUY->DUY_PAIS)) ))
						Aadd(aLin, { "Say", 1730, 0400,  Left(aDadMIC[1],Len(aDadMIC[1])-Len(DUY->DUY_PAIS)) , oFontD  })
						Aadd(aLin, { "Say", 1730, 1006,  Transform(Right(aDadMIC[1],Len(DUY->DUY_PAIS)),'@R X X X') , oFontD  })
					Else
						Aadd(aLin, { "Say", 1730, 0400,  aDadMIC[1] , oFontD  })
					EndIf
					
					//-- Campo 34: Dados do Cliente Destinatario
					aDadCli := TmsDadMIC('34',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					Aadd(aLin, { "Say", 1680, 1140,  aDadCli[1] , oFontD  })
					Aadd(aLin, { "Say", 1710, 1140,  aDadCli[2] , oFontD  })
					Aadd(aLin, { "Say", 1750, 1140,  aDadCli[3] , oFontD  })
					
					//-- Campo 27: Valor FOT
					aDadMIC := TmsDadMIC('27',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					Aadd(aLin, { "Say", 1890, 0020,  Transform(aDadMIC[1],'@E 9,999,999.99') , oFontD  })
					
					//-- Campo 28: Frete
					aDadMIC := TmsDadMIC('28',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					Aadd(aLin, { "Say", 1890, 0410,  Transform(aDadMIC[1],'@E 9,999,999.99') , oFontD  })
					
					//-- Campo 29: Seguro
					aDadMIC := TmsDadMIC('29',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					Aadd(aLin, { "Say", 1890, 0770,  Transform(aDadMIC[1],PesqPict('DTC','DTC_VALSEG')) , oFontD  })
					
					//-- Campo 35: Dados do Cliente Consignatário
					aDadCli := TmsDadMIC('35',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					Aadd(aLin, { "Say", 1830, 1140,  aDadCli[1] , oFontD  })
					Aadd(aLin, { "Say", 1860, 1140,  aDadCli[2] , oFontD  })
					Aadd(aLin, { "Say", 1890, 1140,  aDadCli[3] , oFontD  })
					
					//-- Campo 30: Tipo de Volumes
					aDadEmb := _DadEmb((cAliasQry)->DT6_FILDOC,(cAliasQry)->DT6_DOC,(cAliasQry)->DT6_SERIE)
					Aadd(aLin, { "Say", 2040, 0030,  aDadEmb[1] , oFontD  })
					Aadd(aLin, { "Say", 2040, 0310,  Transform( aDadEmb[2],'@R X X') , oFontD  })
					
					//-- Campo 31: Qtde.de Volumes
					aDadMIC := TmsDadMIC('31',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					If valtype(aDadMIC[1]) == 'C'
						aDadMIC[1] := Val(StrTran(aDadMIC[1],',',''))
					EndIf
					
					If (aDadMic[1] > 9)
						Aadd(aLin, { "Say", 2040, 0400,  Transform(aDadMic[1],'@E 999,999') , oFontD  })
					Else
						Aadd(aLin, { "Say", 2040, 0550,  StrZero(aDadMic[1],2) , oFontD  })
					EndIf
					
					//-- Campo 32: Peso Bruto
					aDadMIC := TmsDadMIC('32',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					Aadd(aLin, { "Say", 2020, 0770, 'Bruto: ' + Transform(aDadMIC[1],'@E 999,999.999') , oFontD1 })
					//-- Campo 32: Peso Liquido
					aDadMIC := TmsDadMIC('41',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					Aadd(aLin, { "Say", 2050, 0770, 'Liqu.: ' + Transform(aDadMIC[1],'@E 999,999.999') , oFontD1 })
					
					//-- Campo 36: Documentos Anexos
					aDocAne := TmsDadMIC('36',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					Aadd(aLin, { "Say", 1990, 1140,  aDocAne[1] , oFontD  })
					Aadd(aLin, { "Say", 2030, 1140,  aDocAne[2] , oFontD  })
					Aadd(aLin, { "Say", 2070, 1140,  aDocAne[3] , oFontD  })
					Aadd(aLin, { "Say", 2110, 1140,  aDocAne[4] , oFontD  })
					
					//-- Campo 37: Lacres
					aDadMIC := TmsDadMIC('37',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					Aadd(aLin, { "Say", 2110, 0030,  aDadMIC[1] , oFontD  })
					
					//-- Campo 38: Marcas e numeros dos volumes
					nLin := 2290
					aObsDoc:= TmsDadMIC('38',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
					For nI := 1 To Len(aObsDoc)
						Aadd(aLin, { "Say", nLin, 0030,  aObsDoc[nI] , oFontD  })
						nLin += 30
						If nI > 6
							Exit
						EndIf
					Next nI
					
				Else
					lFim := .T.
				EndIf
			EndIf
			
			nQtdDoc += 1
		EndIf
		
		
		If nQtdDoc == 2 .or. lFim
			
			aPercRt:= TmsDadMIC('40',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
			
			//-- Campo 42: Subtotal de volume
			If (_nSubVol > 9)
				Aadd(aLin, { "Say", 2615, 0420,  Transform(_nSubVol,'@E 999,999'), oFontD  })
			Else
				Aadd(aLin, { "Say", 2615, 0520,  StrZero(_nSubVol,2) , oFontD  })
			EndIf
			
			//-- Campo 43: Subtotal Peso Bruto
			Aadd(aLin, { "Say", 2615, 0770,  Transform(_nSubPeso,'@E 9,999,999.999') , oFontD  })
			
			//-- Campo 40: Rota e prazo de transporte
			nLin := 2620
			For nI := 1 To Len(aPercRt)
				Aadd(aLin, { "Say", nLin, 1150,  aPercRt[nI] , oFontD  })
				nLin += 35
			Next nI
			
			//-- Campo 44: Total folha anterior (Volume)
			If (nVolAnt > 9)
				Aadd(aLin, { "Say", 2725, 0420,  Transform(nVolAnt,'@E 999,999'), oFontD  })
			Else
				Aadd(aLin, { "Say", 2725, 0520,  StrZero(nVolAnt,2) , oFontD  })
			EndIf
			
			//-- Campo 45: Total folha anterior (Peso Bruto)
			Aadd(aLin, { "Say", 2725, 0770,  Transform(nPesAnt,'@E 9,999,999.999') , oFontD  })
			
			nVolAcu := _nSubVol  + nVolAnt
			nPesAcu := _nSubPeso + nPesAnt
			nVolAnt := nVolAcu
			nPesAnt := nPesAcu
			
			//-- Campo 46: Total folha anterior (Volume)
			If (nVolAcu > 9)
				Aadd(aLin, { "Say", 2835, 0420,  Transform(nVolAcu,'@E 999,999'), oFontD  })
			Else
				Aadd(aLin, { "Say", 2835, 0520,  StrZero(nVolAcu,2) , oFontD  })
			EndIf
			
			//-- Campo 47: Total folha anterior (Peso Bruto)
			Aadd(aLin, { "Say", 2835, 0770,  Transform(nPesAcu,'@E 9,999,999.999') , oFontD  })
			
			//-- Campo 39: Assinatura e carimbo do transportador
			Aadd(aLin, { "Say", 3145, 0300,  cDatMic , oFontD  })
			
			nVolAcu 		:= 0
			nPesAcu		:= 0
			nTotVol 		:= 0
			nTotPes 		:= 0
			_nSubPeso   := 0
			_nSubVol    := 0
			lFim        := .F.
		EndIf
		
		//-- Campo 32 - Peso Bruto
		aDadMIC := TmsDadMIC('32',cAliasQry,cFilMIC,cNumMIC,cCodVei,cIteMIC)
		If (cAliasQry)->DII_ITEMIC == StrZero(1,Len(DII->DII_ITEMIC)) //-- Caratola
			//-- Soma Volume e Peso
			nVolAnt += (cAliasQry)->DT6_QTDVOL
			nPesAnt += aDadMIC[1]
		ElseIf nQtdDoc < 2
			//-- Soma Volume e Peso
			nTotVol += (cAliasQry)->DT6_QTDVOL
			nTotPes += aDadMIC[1]
		EndIf
		
		
		//-- Atualiza flag de impresso do MIC/DTA
		If (cAliasQry)->RECNODII > 0
			DII->(dbGoTo((cAliasQry)->RECNODII))
			RecLock('DII',.F.)
			DII->DII_IMPMIC := '1' //-- Impresso
			MsUnLock()
		EndIf
		
		//-- Finaliza a página
		Aadd(aLin, { "EndPage",' ' })
		
		(cAliasQry)->(dbSkip())
		
	EndDo
	
EndDo

(cAliasQry)->(dbCloseArea())

For nVia := 1 To nQtdVia
	For nX := 1 to Len(aLin)
		
		If "StartPage" == aLin[nX,1]
			oPrint:StartPage()
			
		ElseIf "EndPage" == aLin[nX,1]
			//-- Via
			oPrint:Say( 3210, 0020, aVias[nVia], oFontD )
			oPrint:EndPage()
			
		ElseIf "Say" == aLin[nX,1]
			oPrint:Say(aLin[nX,2], aLin[nX,3], aLin[nX,4], aLin[nX,5])
			
		ElseIf "Box" == aLin[nX,1]
			oPrint:Box(aLin[nX,2], aLin[nX,3], aLin[nX,4], aLin[nX,5])
			
		ElseIf "SayBitmap" == aLin[nX,1]
			oPrint:SayBitmap(aLin[nX,2], aLin[nX,3], aLin[nX,4], aLin[nX,5], aLin[nX,6] )      // oPrint:SayBitmap(0040, 0200, cFileLogo, 500, 150 )
			
		EndIf
		
	Next nX
	
Next nVia


If !lEnd
	oPrint:Preview()
EndIf

RestArea(aAreaSM0)
RestArea(aAreaAtu)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpCaratula³ Autor ³ Jose Luiz Pinheiro Jr³ Data ³ 29.02.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime folha de rosto do MIC - Caratula                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR18G                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCaratula(oPrint,oFont1,oFont1a,oFont2,oFont3)

Aadd(aLin, { "StartPage", ' ' }) // Inicia uma nova página

Aadd(aLin, { "Box", 0020, 0010, 0150, 2325  })
Aadd(aLin, { "Say", 0040, 0600, 'Manifesto Internacional de Carga Rodoviária / Declaração de Trânsito Aduaneiro'      , oFont1  })
Aadd(aLin, { "Say", 0090, 0600, 'Manifiesto Internacional de Carga por Carretera / Declaración de Tránsito Aduanero'   , oFont1a })

If !File(cLogoMIC)
	Aadd(aLin, { "Say", 0060, 0200, 'MIC/DTA'                      , oFont1  })
Else
	Aadd(aLin, { "SayBitmap", 0045, 0270, cLogoMIC , 220, 070  })
EndIf

// Nome e Endereco da Transportadora
Aadd(aLin, { "Box", 0150, 0010, 0600, 1120 })
Aadd(aLin, { "SayBitmap", 0240, 0340, cFileLogo , 450, 120 })   // logo 
Aadd(aLin, { "Say", 0160, 0020, '1. Nome e endereço do Transportador / Nombre y domicilio del porteador', oFont2  })
Aadd(aLin, { "Say", 0400, 0300,  AllTrim(SM0->M0_NOMECOM), oFont2  })  //Transportadora
Aadd(aLin, { "Say", 0430, 0220,  AllTrim(SM0->M0_ENDCOB) + ' - ' + AllTrim(SM0->M0_CIDCOB) + '  -  ' + AllTrim(SM0->M0_ESTCOB) + '  CEP.:  ' + AllTrim(SM0->M0_CEPCOB), oFont2  })  //Endereco
Aadd(aLin, { "Say", 0460, 0300,  AllTrim(SM0->M0_TEL) + ' - FAX: ' + AllTrim(SM0->M0_FAX), oFont2  })  //Telefone/FAX

Aadd(aLin, { "Box", 0150, 1120, 0300, 1650  })
Aadd(aLin, { "Say", 0160, 1130, '3. Trânsito aduaneiro / Tránsito aduanero' , oFont2  })
// 2 box para resposta sim ou nao
Aadd(aLin, { "Box", 0220, 1220, 0300, 1280  })   // Campo 3 - box SIM
Aadd(aLin, { "Say", 0230, 1290, 'Sim' , oFont2  })
Aadd(aLin, { "Say", 0260, 1290, 'Si'  , oFont2  })
Aadd(aLin, { "Box", 0220, 1450, 0300, 1510  })   // Campo 3 - box NAO
Aadd(aLin, { "Say", 0230, 1520, 'Não' , oFont2  })
Aadd(aLin, { "Say", 0260, 1520, 'No'  , oFont2  })

Aadd(aLin, { "Box", 0150, 1650, 0300, 2325 })
Aadd(aLin, { "Say", 0160, 1665, '4. No.' , oFont2  })

Aadd(aLin, { "Box", 0300, 1120, 0450, 1650 })
Aadd(aLin, { "Say", 0310, 1130, '5. Folha / Hoja' , oFont2 })

Aadd(aLin, { "Box", 0300, 1650, 0450, 2325 })
Aadd(aLin, { "Say", 0310, 1665, '6. Data de emissão / Fecha de emisión' , oFont2 })

Aadd(aLin, { "Box", 0450, 1120, 0600, 2325 })
Aadd(aLin, { "Say", 0460, 1130, '7. Alfândega, cidade e país de partida / Aduana, ciudad y país de partida' , oFont2 })
// 7 box para o codigo da aduana.
Aadd(aLin, { "Box", 0480, 2045, 0600, 2085 })   // Campo 7 - box 1
Aadd(aLin, { "Box", 0480, 2085, 0600, 2125 })   // Campo 7 - box 2
Aadd(aLin, { "Box", 0480, 2125, 0600, 2165 })   // Campo 7 - box 3
Aadd(aLin, { "Box", 0480, 2165, 0600, 2205 })   // Campo 7 - box 4
Aadd(aLin, { "Box", 0480, 2205, 0600, 2245 })   // Campo 7 - box 5
Aadd(aLin, { "Box", 0480, 2245, 0600, 2285 })   // Campo 7 - box 6
Aadd(aLin, { "Box", 0480, 2285, 0600, 2325 })   // Campo 7 - box 7


Aadd(aLin, { "Box", 0600, 0010, 0750, 1120 })
Aadd(aLin, { "Say", 0610, 0020, '2. Cadastro geral de contribuintes / Rol de contribuyente' , oFont2 })
Aadd(aLin, { "Say", 0665, 0150, '57.692.055/0001-27'      , oFont1 })

Aadd(aLin, { "Box", 0600, 1120, 0750, 2325 })
Aadd(aLin, { "Say", 0610, 1130, '8. Cidade e país de destino final / Ciudad y país de destino final' , oFont2 })
// 3 box para o codigo do pais.
Aadd(aLin, { "Box", 0630, 2205, 0750, 2245  })   // Campo 8 - box 1
Aadd(aLin, { "Box", 0630, 2245, 0750, 2285  })   // Campo 8 - box 2
Aadd(aLin, { "Box", 0630, 2285, 0750, 2325  })   // Campo 8 - box 3

Aadd(aLin, { "Box", 0750, 0010, 1000, 1120  })
Aadd(aLin, { "Say", 0760, 0020, '9. CAMINHÃO ORIGINAL: Nome e endereço do proprietário'   , oFont2  })
Aadd(aLin, { "Say", 0790, 0020, '     CAMION ORIGINAL: nombre y domicilio del proprietario' , oFont2  })

Aadd(aLin, { "Box", 0750, 1120, 1000, 2325  })
Aadd(aLin, { "Say", 0760, 1130, '16. CAMINHÃO SUBSTITUTO: Nome e endereço do proprietário'   , oFont2  })
Aadd(aLin, { "Say", 0790, 1130, '      CAMION SUBSTITUTO: nombre y domicilio del propietario' , oFont2  })

Aadd(aLin, { "Box", 1000, 0010, 1150, 0550  })
Aadd(aLin, { "Say", 1010, 0020, '10. Cadastro geral de contribuintes'  , oFont2  })
Aadd(aLin, { "Say", 1040, 0020, '      Rol de Contribuyente'            , oFont2 })

Aadd(aLin, { "Box", 1000, 0550, 1150, 1120  })
Aadd(aLin, { "Say", 1010, 0560, '11. Placa do caminhão'      , oFont2  })
Aadd(aLin, { "Say", 1040, 0560, '      Placa del camión'      , oFont2  })

Aadd(aLin, { "Box", 1000, 1120, 1150, 1700  })
Aadd(aLin, { "Say", 1010, 1130, '17. Cadastro geral de contribuintes'  , oFont2  })
Aadd(aLin, { "Say", 1040, 1130, '      Rol de Contribuyente'            , oFont2  })

Aadd(aLin, { "Box", 1000, 1700, 1150, 2325  })
Aadd(aLin, { "Say", 1010, 1710, '18. Placa do caminhão'      , oFont2  })
Aadd(aLin, { "Say", 1040, 1710, '      Placa del camión'      , oFont2  })

Aadd(aLin, { "Box", 1150, 0010, 1300, 0550  })
Aadd(aLin, { "Say", 1160, 0020, '12. Marca e número / Marca y número' , oFont2 })

Aadd(aLin, { "Box", 1150, 0550, 1300, 1120  })
Aadd(aLin, { "Say", 1160, 0560, '13. Capacidade de tração (t.)'    , oFont2  })
Aadd(aLin, { "Say", 1190, 0560, '      Capacidad de arrastre (t.)'  , oFont2  })

Aadd(aLin, { "Box", 1150, 1120, 1300, 1700  })
Aadd(aLin, { "Say", 1160, 1130, '19. Marca e número / Marca y número' , oFont2  })

Aadd(aLin, { "Box", 1150, 1700, 1300, 2325  })
Aadd(aLin, { "Say", 1160, 1710, '20. Capacidade de tração (t.)'     , oFont2  })
Aadd(aLin, { "Say", 1190, 1710, '      Capacidad de arrastre (t.)'   , oFont2  })

Aadd(aLin, { "Box", 1300, 0010, 1450, 0550  })
Aadd(aLin, { "Say", 1310, 0020, '14. Ano / Año'			, oFont2 })

Aadd(aLin, { "Box", 1300, 0550, 1450, 1120  })
Aadd(aLin, { "Say", 1310, 0560, '15'    						, oFont2  })
Aadd(aLin, { "Box", 1300, 0600, 1375, 0675  })   // Campo 15 - box Semi-reboque
Aadd(aLin, { "Say", 1310, 0685, 'Semi-reboque' 	, oFont2 })
Aadd(aLin, { "Say", 1340, 0685, 'Semiremolque'  , oFont2 })
Aadd(aLin, { "Box", 1300, 0860, 1375, 0935  })   // Campo 15 - box Reboque
Aadd(aLin, { "Say", 1310, 0945, 'Reboque' 		, oFont2 })
Aadd(aLin, { "Say", 1340, 0945, 'Remolque'  		, oFont2  })
Aadd(aLin, { "Say", 1420, 0570, 'Placa:'  		, oFont2  })


Aadd(aLin, { "Box", 1300, 1120, 1450, 1700  })
Aadd(aLin, { "Say", 1310, 1130, '21. Ano / Año'			, oFont2  })

Aadd(aLin, { "Box", 1300, 1700, 1450, 2325 })
Aadd(aLin, { "Say", 1310, 1710, '22'    						, oFont2  })
Aadd(aLin, { "Box", 1300, 1750, 1375, 1825  })   // Campo 22 - box Semi-reboque
Aadd(aLin, { "Say", 1310, 1835, 'Semi-reboque' 	, oFont2 })
Aadd(aLin, { "Say", 1340, 1835, 'Semiremolque'  	, oFont2 })
Aadd(aLin, { "Box", 1300, 2100, 1375, 2175  })   // Campo 22 - box Reboque
Aadd(aLin, { "Say", 1310, 2185, 'Reboque' 			, oFont2 })
Aadd(aLin, { "Say", 1340, 2185, 'Remolque'  		, oFont2  })
Aadd(aLin, { "Say", 1420, 1720, 'Placa:'  		   , oFont2  })

Aadd(aLin, { "Box", 1450, 0010, 1600, 0380  })
Aadd(aLin, { "Say", 1460, 0020, '23. No. do conhecimento'   , oFont2  })
Aadd(aLin, { "Say", 1490, 0020, '      No. carta de porte' , oFont2  })

Aadd(aLin, { "Box", 1450, 0380, 1600, 1120  })
Aadd(aLin, { "Say", 1460, 0390, '24. Alfândega de destino / Aduana de destino'   , oFont2  })
// 7 box para o codigo da aduana.
Aadd(aLin, { "Box", 1500, 0840, 1600, 0880  })   // Campo 24 - box 1
Aadd(aLin, { "Box", 1500, 0880, 1600, 0920  })   // Campo 24 - box 2
Aadd(aLin, { "Box", 1500, 0920, 1600, 0960  })   // Campo 24 - box 3
Aadd(aLin, { "Box", 1500, 0960, 1600, 1000  })   // Campo 24 - box 4
Aadd(aLin, { "Box", 1500, 1000, 1600, 1040  })   // Campo 24 - box 5
Aadd(aLin, { "Box", 1500, 1040, 1600, 1080  })   // Campo 24 - box 6
Aadd(aLin, { "Box", 1500, 1080, 1600, 1120  })   // Campo 24 - box 7


Aadd(aLin, { "Box", 1450, 1120, 1600, 2325  })
Aadd(aLin, { "Say", 1460, 1130, '33. Remetente / Remitente' , oFont2  })

Aadd(aLin, { "Box", 1600, 0010, 1750, 0380  })
Aadd(aLin, { "Say", 1610, 0020, '25. Moeda / Moneda'   , oFont2  })

Aadd(aLin, { "Box", 1600, 0380, 1750, 1120  })
Aadd(aLin, { "Say", 1610, 0390, '26. Origem das mercadorias / Origen de las mercancias' , oFont2  })
// 3 box para o codigo do pais.
Aadd(aLin, { "Box", 1650, 1000, 1750, 1040  })   // Campo 26- box 1
Aadd(aLin, { "Box", 1650, 1040, 1750, 1080  })   // Campo 26- box 2
Aadd(aLin, { "Box", 1650, 1080, 1750, 1120  })   // Campo 26- box 3

Aadd(aLin, { "Box", 1600, 1120, 1750, 2325  })
Aadd(aLin, { "Say", 1610, 1130, '34. Destinatário / Destinatario' , oFont2  })

Aadd(aLin, { "Box", 1750, 0010, 1900, 0380  })
Aadd(aLin, { "Say", 1760, 0020, '27. Valor FOT / Valor FOT'   , oFont2  })

Aadd(aLin, { "Box", 1750, 0380, 1900, 0750  })
Aadd(aLin, { "Say", 1760, 0390, '28. Frete em US$'   , oFont2  })
Aadd(aLin, { "Say", 1790, 0390, '      Flete en US$'   , oFont2  })

Aadd(aLin, { "Box", 1750, 0750, 1900, 1120  })
Aadd(aLin, { "Say", 1760, 0760, '29. Seguro em US$'   , oFont2  })
Aadd(aLin, { "Say", 1790, 0760, '      Seguro en US$'   , oFont2  })

Aadd(aLin, { "Box", 1750, 1120, 1900, 2325  })
Aadd(aLin, { "Say", 1760, 1130, '35. Consignatário / Consignatario' , oFont2  })

Aadd(aLin, { "Box", 1900, 0010, 2050, 0380  })
Aadd(aLin, { "Say", 1910, 0020, '30. Tipo de Volumes'   , oFont2  })
Aadd(aLin, { "Say", 1940, 0020, '      Tipo de bultos'   , oFont2  })
// 2 box para o codigo da embalagem.
Aadd(aLin, { "Box", 1950, 0300, 2050, 0340  })   // Campo 30- box 1
Aadd(aLin, { "Box", 1950, 0340, 2050, 0380  })   // Campo 30- box 2

Aadd(aLin, { "Box", 1900, 0380, 2050, 0750  })
Aadd(aLin, { "Say", 1910, 0390, '31. Quantidade de volumes'   , oFont2  })
Aadd(aLin, { "Say", 1940, 0390, '      Cantidad de bultos'     , oFont2  })

Aadd(aLin, { "Box", 1900, 0750, 2050, 1120  })
Aadd(aLin, { "Say", 1910, 0760, '32. Peso bruto (kg.)'   , oFont2  })
Aadd(aLin, { "Say", 1940, 0760, '      Peso bruto (kg.)'     , oFont2  })

Aadd(aLin, { "Box", 1900, 1120, 2200, 2325  })
Aadd(aLin, { "Say", 1910, 1130, '36. Documentos anexos / Documentos anexos'   , oFont2  })

Aadd(aLin, { "Box", 2050, 0010, 2200, 1120  })
Aadd(aLin, { "Say", 2060, 0020, '37. Números dos lacres / Números de los precintos'   , oFont2  })

Aadd(aLin, { "Box", 2200, 0010, 2500, 2325  })
Aadd(aLin, { "Say", 2210, 0020, '38. Marcas e números dos volumes, descrição das mercadorias / Marcas y números de los bultos, descripción de las mercancias'   , oFont2  })
// 10 box para o codigo.
Aadd(aLin, { "Box", 2380, 1925, 2500, 1965  })   // Campo 38 - box 1
Aadd(aLin, { "Box", 2380, 1965, 2500, 2005  })   // Campo 38 - box 2
Aadd(aLin, { "Box", 2380, 2005, 2500, 2045  })   // Campo 38 - box 3
Aadd(aLin, { "Box", 2380, 2045, 2500, 2085  })   // Campo 38 - box 4
Aadd(aLin, { "Box", 2380, 2085, 2500, 2125  })   // Campo 38 - box 5
Aadd(aLin, { "Box", 2380, 2125, 2500, 2165  })   // Campo 38 - box 6
Aadd(aLin, { "Box", 2380, 2165, 2500, 2205  })   // Campo 38 - box 7
Aadd(aLin, { "Box", 2380, 2205, 2500, 2245  })   // Campo 38 - box 8
Aadd(aLin, { "Box", 2380, 2245, 2500, 2285  })   // Campo 38 - box 9
Aadd(aLin, { "Box", 2380, 2285, 2500, 2325  })   // Campo 38 - box 10


// campo 39
Aadd(aLin, { "Box", 2500, 0010, 3200, 1120  })
Aadd(aLin, { "Say", 2520, 0030, 'Declaramos que  as  informações  prestadas  neste  Documento  são  a  expressão   da'   	 , oFont2  })
Aadd(aLin, { "Say", 2550, 0030, 'verdade, que os  dados  referentes  às  mercadorias  foram   transcritos   exatamente'  	 , oFont2  })
Aadd(aLin, { "Say", 2580, 0030, 'conforme a declaração do remetente, os quais são de sua exclusiva responsabilidade,'  	 , oFont2  })
Aadd(aLin, { "Say", 2610, 0030, 'e que esta operação obedece ao disposto no Convênio sobre Transporte Internacional'   	 , oFont2  })
Aadd(aLin, { "Say", 2640, 0030, 'Terrestre dos Países do Cone Sul.'																		    , oFont2  })


Aadd(aLin, { "Say", 2700, 0030, 'Declaramos que las informaciones prestadas en este Documento son expresión de verdad,'   , oFont2  })
Aadd(aLin, { "Say", 2730, 0030, 'que los datos referentes a las mercancias fueron transcriptos exactamente conforme a la'    , oFont2  })
Aadd(aLin, { "Say", 2760, 0030, 'declaración del remitente,  los  cuales  son  de  su  exclusiva  responsabilidad, y que esta'    , oFont2  })
Aadd(aLin, { "Say", 2790, 0030, 'operación obedece a lo dispuesto en el Convenio sobre Transporte Internacional Terrestre'    , oFont2  })
Aadd(aLin, { "Say", 2820, 0030, 'de los Países del Cono Sur.'   , oFont2  })

Aadd(aLin, { "Say", 2890, 0020, '39. Assinatura e carimbo do transportador / Firma y sello del porteador'   , oFont2  })
Aadd(aLin, { "Say", 3150, 0020, 'Data / Fecha'   , oFont2  })

Aadd(aLin, { "Box", 2500, 1120, 2800, 2325  })
Aadd(aLin, { "Say", 2510, 1130, '40. No. DTA, rota e prazo de transporte'    , oFont2  })
Aadd(aLin, { "Say", 2540, 1130, '      No. DTA, ruta y plazo de transporte'   , oFont2  })

Aadd(aLin, { "Box", 2800, 1120, 3200, 2325  })
Aadd(aLin, { "Say", 2810, 1130, '41. Assinatura e carimbo da Alfândega de Partida / Firma y sello de la Aduana de Partida'    , oFont2  })
Aadd(aLin, { "Say", 3150, 1130, 'Data / Fecha'   , oFont2  })

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpContinua   ³ Autor ³ Jose Luiz P. Jr   ³ Data ³ 29.02.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime folha de rosto do MIC continuacao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR18G                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpContinua(oPrint,oFont1,oFont1a,oFont2,oFont3)

Aadd(aLin, { "StartPage()" }) // Inicia uma nova página

Aadd(aLin, { "Box", 0020, 0010, 0150, 2325  })
Aadd(aLin, { "Say", 0040, 0600, 'Manifesto Internacional de Carga Rodoviária / Declaração de Trânsito Aduaneiro'      , oFont1  })
Aadd(aLin, { "Say", 0090, 0600, 'Manifiesto Internacional de Carga por Carretera / Declaración de Tránsito Aduanero'   , oFont1a })

If !File(cLogoMIC)
	Aadd(aLin, { "Say", 0060, 0200, 'MIC/DAT'                      , oFont1  })
Else
	Aadd(aLin, { "SayBitmap", 0045, 0270, cLogoMIC , 220, 070  })
EndIf
                                                                        
// Nome e Endereco da Transportadora
Aadd(aLin, { "Box", 0150, 0010, 0450, 1120  })
Aadd(aLin, { "SayBitmap", 0210, 0370, cFileLogo, 350, 100  })  // logo 
Aadd(aLin, { "Say", 0160, 0020, '1. Nome e endereço do Transportador / Nombre y domicilio del porteador', oFont2  })
Aadd(aLin, { "Say", 0320, 0300, AllTrim(SM0->M0_NOMECOM), oFont2  })
Aadd(aLin, { "Say", 0350, 0220, AllTrim(SM0->M0_ENDCOB) + ' - ' + AllTrim(SM0->M0_CIDCOB) + '  -  ' + AllTrim(SM0->M0_ESTCOB) + '  CEP.:  ' + AllTrim(SM0->M0_CEPCOB), oFont2  })
Aadd(aLin, { "Say", 0380, 0300, AllTrim(SM0->M0_TEL) + ' - FAX: ' + AllTrim(SM0->M0_FAX), oFont2  })
                      
Aadd(aLin, { "Box", 0150, 1120, 0300, 1650  })
Aadd(aLin, { "Say", 0180, 1230, 'Continuação'  , oFont1  })
Aadd(aLin, { "Say", 0230, 1230, 'Continuación' , oFont1  })

Aadd(aLin, { "Box", 0150, 1650, 0300, 2325  })
Aadd(aLin, { "Say", 0160, 1665, '4. No.' , oFont2  })

Aadd(aLin, { "Box", 0300, 1120, 0450, 1650  })
Aadd(aLin, { "Say", 0310, 1130, '5. Folha / Hoja' , oFont2  })

Aadd(aLin, { "Box", 0300, 1650, 0450, 2325  })
Aadd(aLin, { "Say", 0310, 1665, '6. Data de emissão / Fecha de emisión' , oFont2  })

Aadd(aLin, { "Box", 0450, 0010, 0600, 0380  })
Aadd(aLin, { "Say", 0460, 0020, '23. No. do conhecimento'   , oFont2  })
Aadd(aLin, { "Say", 0490, 0020, '      No. carta de porte' , oFont2  })

Aadd(aLin, { "Box", 0450, 0380, 0600, 1120  })
Aadd(aLin, { "Say", 0460, 0390, '24. Alfândega de destino / Aduana de destino'   , oFont2  })
// 7 box para o codigo da aduana.
Aadd(aLin, { "Box", 0500, 0840, 0600, 0880  })   // Campo 24 - box 1
Aadd(aLin, { "Box", 0500, 0880, 0600, 0920  })   // Campo 24 - box 2
Aadd(aLin, { "Box", 0500, 0920, 0600, 0960  })   // Campo 24 - box 3
Aadd(aLin, { "Box", 0500, 0960, 0600, 1000  })   // Campo 24 - box 4
Aadd(aLin, { "Box", 0500, 1000, 0600, 1040  })   // Campo 24 - box 5
Aadd(aLin, { "Box", 0500, 1040, 0600, 1080  })   // Campo 24 - box 6
Aadd(aLin, { "Box", 0500, 1080, 0600, 1120  })   // Campo 24 - box 7

Aadd(aLin, { "Box", 0450, 1120, 0600, 2325  })
Aadd(aLin, { "Say", 0460, 1130, '33. Remetente / Remitente' , oFont2  })

Aadd(aLin, { "Box", 0600, 0010, 0750, 0380  })
Aadd(aLin, { "Say", 0610, 0020, '25. Moeda / Moneda'   , oFont2  })

Aadd(aLin, { "Box", 0600, 0380, 0750, 1120  })
Aadd(aLin, { "Say", 0610, 0390, '26. Origem das mercadorias / Origen de las mercancias' , oFont2  })
// 3 box para o codigo do pais.
Aadd(aLin, { "Box", 0650, 1000, 0750, 1040  })   // Campo 26- box 1
Aadd(aLin, { "Box", 0650, 1040, 0750, 1080  })   // Campo 26- box 2
Aadd(aLin, { "Box", 0650, 1080, 0750, 1120  })   // Campo 26- box 3

Aadd(aLin, { "Box", 0600, 1120, 0750, 2325  })
Aadd(aLin, { "Say", 0610, 1130, '34. Destinatário / Destinatario' , oFont2  })

Aadd(aLin, { "Box", 0750, 0010, 0900, 0380  })
Aadd(aLin, { "Say", 0760, 0020, '27. Valor FOT / Valor FOT'   , oFont2  })

Aadd(aLin, { "Box", 0750, 0380, 0900, 0750  })
Aadd(aLin, { "Say", 0760, 0390, '28. Frete em US$'   , oFont2  })
Aadd(aLin, { "Say", 0790, 0390, '      Flete en US$'   , oFont2  })

Aadd(aLin, { "Box", 0750, 0750, 0900, 1120  })
Aadd(aLin, { "Say", 0760, 0760, '29. Seguro em US$'   , oFont2  })
Aadd(aLin, { "Say", 0790, 0760, '      Seguro en US$'   , oFont2  })

Aadd(aLin, { "Box", 0750, 1120, 0900, 2325  })
Aadd(aLin, { "Say", 0760, 1130, '35. Consignatário / Consignatario' , oFont2  })

Aadd(aLin, { "Box", 0900, 0010, 1050, 0380  })
Aadd(aLin, { "Say", 0910, 0020, '30. Tipo de Volumes'   , oFont2  })
Aadd(aLin, { "Say", 0940, 0020, '      Tipo de bultos'   , oFont2  })
// 2 box para o codigo da embalagem.
Aadd(aLin, { "Box", 0950, 0300, 1050, 0340  })   // Campo 30- box 1
Aadd(aLin, { "Box", 0950, 0340, 1050, 0380  })   // Campo 30- box 2

Aadd(aLin, { "Box", 0900, 0380, 1050, 0750  })
Aadd(aLin, { "Say", 0910, 0390, '31. Quantidade de volumes'   , oFont2  })
Aadd(aLin, { "Say", 0940, 0390, '      Cantidad de bultos'     , oFont2  })

Aadd(aLin, { "Box", 0900, 0750, 1050, 1120  })
Aadd(aLin, { "Say", 0910, 0760, '32. Peso bruto (kg.)'   , oFont2  })
Aadd(aLin, { "Say", 0940, 0760, '      Peso bruto (kg.)'     , oFont2  })

Aadd(aLin, { "Box", 0900, 1120, 1200, 2325  })
Aadd(aLin, { "Say", 0910, 1130, '36. Documentos anexos / Documentos anexos'   , oFont2  })

Aadd(aLin, { "Box", 1050, 0010, 1200, 1120  })
Aadd(aLin, { "Say", 1060, 0020, '37. Números dos lacres / Números de los precintos'   , oFont2  })

Aadd(aLin, { "Box", 1200, 0010, 1500, 2325  })
Aadd(aLin, { "Say", 1210, 0020, '38. Marcas e números dos volumes, descrição das mercadorias / Marcas y números de los bultos, descripción de las mercancias'   , oFont2  })
// 10 box para o codigo.
Aadd(aLin, { "Box", 1380, 1925, 1500, 1965  })   // Campo 38 - box 1
Aadd(aLin, { "Box", 1380, 1965, 1500, 2005  })   // Campo 38 - box 2
Aadd(aLin, { "Box", 1380, 2005, 1500, 2045  })   // Campo 38 - box 3
Aadd(aLin, { "Box", 1380, 2045, 1500, 2085  })   // Campo 38 - box 4
Aadd(aLin, { "Box", 1380, 2085, 1500, 2125  })   // Campo 38 - box 5
Aadd(aLin, { "Box", 1380, 2125, 1500, 2165  })   // Campo 38 - box 6
Aadd(aLin, { "Box", 1380, 2165, 1500, 2205  })   // Campo 38 - box 7
Aadd(aLin, { "Box", 1380, 2205, 1500, 2245  })   // Campo 38 - box 8
Aadd(aLin, { "Box", 1380, 2245, 1500, 2285  })   // Campo 38 - box 9
Aadd(aLin, { "Box", 1380, 2285, 1500, 2325  })   // Campo 38 - box 10


Aadd(aLin, { "Box", 1500, 0010, 1650, 0380  })
Aadd(aLin, { "Say", 1510, 0020, '23. No. do conhecimento'   , oFont2  })
Aadd(aLin, { "Say", 1540, 0020, '      No. carta de porte' , oFont2  })

Aadd(aLin, { "Box", 1500, 0380, 1650, 1120  })
Aadd(aLin, { "Say", 1510, 0390, '24. Alfândega de destino / Aduana de destino'   , oFont2  })
// 7 box para o codigo da aduana.
Aadd(aLin, { "Box", 1550, 0840, 1650, 0880  })   // Campo 24 - box 1
Aadd(aLin, { "Box", 1550, 0880, 1650, 0920  })   // Campo 24 - box 2
Aadd(aLin, { "Box", 1550, 0920, 1650, 0960  })   // Campo 24 - box 3
Aadd(aLin, { "Box", 1550, 0960, 1650, 1000  })   // Campo 24 - box 4
Aadd(aLin, { "Box", 1550, 1000, 1650, 1040  })   // Campo 24 - box 5
Aadd(aLin, { "Box", 1550, 1040, 1650, 1080  })  // Campo 24 - box 6
Aadd(aLin, { "Box", 1550, 1080, 1650, 1120  })   // Campo 24 - box 7

Aadd(aLin, { "Box", 1500, 1120, 1650, 2325  })
Aadd(aLin, { "Say", 1510, 1130, '33. Remetente / Remitente' , oFont2  })

Aadd(aLin, { "Box", 1650, 0010, 1800, 0380  })
Aadd(aLin, { "Say", 1660, 0020, '25. Moeda / Moneda'   , oFont2  })

Aadd(aLin, { "Box", 1650, 0380, 1800, 1120  })
Aadd(aLin, { "Say", 1660, 0390, '26. Origem das mercadorias / Origen de las mercancias' , oFont2  })
// 3 box para o codigo do pais.
Aadd(aLin, { "Box", 1700, 1000, 1800, 1040  })   // Campo 26- box 1
Aadd(aLin, { "Box", 1700, 1040, 1800, 1080  })  // Campo 26- box 2
Aadd(aLin, { "Box", 1700, 1080, 1800, 1120  })  // Campo 26- box 3

Aadd(aLin, { "Box", 1650, 1120, 1800, 2325  })
Aadd(aLin, { "Say", 1660, 1130, '34. Destinatário / Destinatario' , oFont2  })

Aadd(aLin, { "Box", 1800, 0010, 1950, 0380  })
Aadd(aLin, { "Say", 1810, 0020, '27. Valor FOT / Valor FOT'   , oFont2  })

Aadd(aLin, { "Box", 1800, 0380, 1950, 0750  })
Aadd(aLin, { "Say", 1810, 0390, '28. Frete em US$'   , oFont2  })
Aadd(aLin, { "Say", 1840, 0390, '      Flete en US$'   , oFont2  })

Aadd(aLin, { "Box", 1800, 0750, 1950, 1120  })
Aadd(aLin, { "Say", 1810, 0760, '29. Seguro em US$'   , oFont2  })
Aadd(aLin, { "Say", 1840, 0760, '      Seguro en US$'   , oFont2  })

Aadd(aLin, { "Box", 1800, 1120, 1950, 2325  })
Aadd(aLin, { "Say", 1810, 1130, '35. Consignatário / Consignatario' , oFont2  })

Aadd(aLin, { "Box", 1950, 0010, 2100, 0380  })
Aadd(aLin, { "Say", 1960, 0020, '30. Tipo de Volumes'   , oFont2  })
Aadd(aLin, { "Say", 1990, 0020, '      Tipo de bultos'   , oFont2  })
// 2 box para o codigo da embalagem.
Aadd(aLin, { "Box", 2000, 0300, 2100, 0340  })   // Campo 30- box 1
Aadd(aLin, { "Box", 2000, 0340, 2100, 0380  })   // Campo 30- box 2

Aadd(aLin, { "Box", 1950, 0380, 2100, 0750  })
Aadd(aLin, { "Say", 1960, 0390, '31. Quantidade de volumes'   , oFont2  })
Aadd(aLin, { "Say", 1990, 0390, '      Cantidad de bultos'     , oFont2  })

Aadd(aLin, { "Box", 1950, 0750, 2100, 1120  })
Aadd(aLin, { "Say", 1960, 0760, '32. Peso bruto (kg.)'   , oFont2  })
Aadd(aLin, { "Say", 1990, 0760, '      Peso bruto (kg.)'     , oFont2  })

Aadd(aLin, { "Box", 1950, 1120, 2250, 2325  })
Aadd(aLin, { "Say", 1960, 1130, '36. Documentos anexos / Documentos anexos'   , oFont2  })

Aadd(aLin, { "Box", 2100, 0010, 2250, 1120  })
Aadd(aLin, { "Say", 2110, 0020, '37. Números dos lacres / Números de los precintos'   , oFont2  })

Aadd(aLin, { "Box", 2250, 0010, 2550, 2325  })
Aadd(aLin, { "Say", 2260, 0020, '38. Marcas e números dos volumes, descrição das mercadorias / Marcas y números de los bultos, descripción de las mercancias'   , oFont2  })
// 10 box para o codigo.
Aadd(aLin, { "Box", 2430, 1925, 2550, 1965  })   // Campo 38 - box 1
Aadd(aLin, { "Box", 2430, 1965, 2550, 2005  })   // Campo 38 - box 2
Aadd(aLin, { "Box", 2430, 2005, 2550, 2045  })   // Campo 38 - box 3
Aadd(aLin, { "Box", 2430, 2045, 2550, 2085  })   // Campo 38 - box 4
Aadd(aLin, { "Box", 2430, 2085, 2550, 2125  })   // Campo 38 - box 5
Aadd(aLin, { "Box", 2430, 2125, 2550, 2165  })   // Campo 38 - box 6
Aadd(aLin, { "Box", 2430, 2165, 2550, 2205  })   // Campo 38 - box 7
Aadd(aLin, { "Box", 2430, 2205, 2550, 2245  })   // Campo 38 - box 8
Aadd(aLin, { "Box", 2430, 2245, 2550, 2285  })   // Campo 38 - box 9
Aadd(aLin, { "Box", 2430, 2285, 2550, 2325  })   // Campo 38 - box 10


//subtotais
Aadd(aLin, { "Box", 2550, 0010, 2660, 0380  })
Aadd(aLin, { "Say", 2560, 0020, 'SUBTOTAIS'    , oFont2  })
Aadd(aLin, { "Say", 2590, 0020, 'SUBTOTALES'   , oFont2  })

Aadd(aLin, { "Box", 2550, 0380, 2660, 0750  })
Aadd(aLin, { "Say", 2555, 0390, '42. Quantidade de volumes'   , oFont2  })
Aadd(aLin, { "Say", 2580, 0390, '      Cantidad de bultos'    , oFont2  })

Aadd(aLin, { "Box", 2550, 0750, 2660, 1120  })
Aadd(aLin, { "Say", 2555, 0760, '43. Peso bruto (kg.)'     , oFont2  })
Aadd(aLin, { "Say", 2580, 0760, '      Peso bruto (kg.)'   , oFont2  })

//Totais folha anterior
Aadd(aLin, { "Box", 2660, 0010, 2770, 0380  })
Aadd(aLin, { "Say", 2665, 0020, 'TOTAIS FOLHA ANTERIOR'   , oFont2  })
Aadd(aLin, { "Say", 2690, 0020, 'TOTALES HOJA ANTERIOR'   , oFont2  })

Aadd(aLin, { "Box", 2660, 0380, 2770, 0750  })
Aadd(aLin, { "Say", 2665, 0390, '44. Quantidade de volumes'   , oFont2  })
Aadd(aLin, { "Say", 2690, 0390, '      Cantidad de bultos'    , oFont2  })

Aadd(aLin, { "Box", 2660, 0750, 2770, 1120  })
Aadd(aLin, { "Say", 2665, 0760, '45. Peso bruto (kg.)'     , oFont2  })
Aadd(aLin, { "Say", 2690, 0760, '      Peso bruto (kg.)'   , oFont2  })

//Totais Acumulados
Aadd(aLin, { "Box", 2770, 0010, 2880, 0380  })
Aadd(aLin, { "Say", 2775, 0020, 'TOTAIS ACUMULADOS'    , oFont2  })
Aadd(aLin, { "Say", 2800, 0020, 'TOTALES ACUMULADOS'   , oFont2  })

Aadd(aLin, { "Box", 2770, 0380, 2880, 0750  })
Aadd(aLin, { "Say", 2775, 0390, '46. Quantidade de volumes'   , oFont2  })
Aadd(aLin, { "Say", 2800, 0390, '      Cantidad de bultos'    , oFont2  })

Aadd(aLin, { "Box", 2770, 0750, 2880, 1120  })
Aadd(aLin, { "Say", 2775, 0760, '47. Peso bruto (kg.)'     , oFont2  })
Aadd(aLin, { "Say", 2800, 0760, '      Peso bruto (kg.)'   , oFont2  })

// campo 39
Aadd(aLin, { "Box", 2880, 0010, 3200, 1120  })
Aadd(aLin, { "Say", 2890, 0020, '39. Assinatura e carimbo do transportador / Firma y sello del porteador'   , oFont2  })
Aadd(aLin, { "Say", 3150, 0020, 'Data / Fecha'   , oFont2  })

Aadd(aLin, { "Box", 2550, 1120, 2880, 2325  })
Aadd(aLin, { "Say", 2560, 1130, '40. No. DTA, rota e prazo de transporte'    , oFont2  })
Aadd(aLin, { "Say", 2590, 1130, '      No. DTA, ruta y plazo de transporte'   , oFont2  })

Aadd(aLin, { "Box", 2880, 1120, 3200, 2325  })
Aadd(aLin, { "Say", 2890, 1130, '41. Assinatura e carimbo da Alfândega de Partida / Firma y sello de la Aduana de Partida'    , oFont2  })
Aadd(aLin, { "Say", 3150, 1130, 'Data / Fecha'   , oFont2  })

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1  ³ Autor ³Richard Anderson    ³ Data ³ 22/11/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Inclui Perguntas no SX1                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³RTMSR18                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1(cPerg)

Local aHlpPor1 := {"Informe a Filial de Origem Inicial"}
Local aHlpEsp1 := {"Informe el Sucursal Origen Inicial"}
Local aHlpIng1 := {"Enter the First Branch Origin"}

Local aHlpPor2 := {"Informe a Viagem Inicial"}
Local aHlpEsp2 := {"Informe la Viagen Inicial"}
Local aHlpIng2 := {"Enter the First Number Trip"}               

Local aHlpPor3 := {"Informe a Filial de Origem Final"}
Local aHlpEsp3 := {"Informe el Sucursal Origen Final"}
Local aHlpIng3 := {"Enter the Last Branch Origin "}

Local aHlpPor4 := {"Informe a Viagem Final"}
Local aHlpEsp4 := {"Informe la Viagen Final"}
Local aHlpIng4 := {"Enter the Last Number Trip"}               

Local aHlpPor5 := {"Informe o Veiculo Inicial"}
Local aHlpEsp5 := {"Informe el Vehiculo Inicial"}
Local aHlpIng5 := {"Enter the First Vehicle"}                      

Local aHlpPor6 := {"Informe o Veiculo Final"}
Local aHlpEsp6 := {"Informe el Vehiculo Final"}
Local aHlpIng6 := {"Enter the Last Vehicle"}                      

Local aHlpPor7 := {"Informe se é Impressao ou Reimpressao."}
Local aHlpEsp7 := {"Informe la Impression/Reimpresion "}
Local aHlpIng7 := {"Enter the Printing or Reprinting"}                                                             

Local aHlpPor8 := {"Informe o Tipo de Via"}
Local aHlpEsp8 := {""}
Local aHlpIng8 := {""}    

PutSx1( cPerg,'01','Fil.Origem De ?     ','¿De Suc.Origen ?    ','From Branch Orig.?','mv_ch1','C',2,0,0,'G','','DL5','','','mv_par01',"","","","","","","","","","","","","","","","",aHlpPor1,aHlpIng1,aHlpEsp1)
PutSx1( cPerg,'02','Viagem De ?         ','¿De Viaje ?         ','From Number Trip?','mv_ch2','C',6,0,0,'G','',''   ,'','','mv_par02',"","","","","","","","","","","","","","","","",aHlpPor2,aHlpIng2,aHlpEsp2)
PutSx1( cPerg,'03','Fil.Origem Até ?    ','¿A Suc.Origen ?     ','To Branch Orig.?','mv_ch3','C',2,0,0,'G','','DL5','','','mv_par03',"","","","","","","","","","","","","","","","",aHlpPor3,aHlpIng3,aHlpEsp3)
PutSx1( cPerg,'04','Viagem Até ?        ','¿A Viaje ?          ','To Number Trip ?','mv_ch4','C',6,0,0,'G','',''   ,'','','mv_par04',"","","","","","","","","","","","","","","","",aHlpPor4,aHlpIng4,aHlpEsp4)
PutSx1( cPerg,'05','Veículo De ?        ','¿De Vehículo ?      ','From Vehicle ?','mv_ch5','C',8,0,0,'G','','DA3','','','mv_par05',"","","","","","","","","","","","","","","","",aHlpPor5,aHlpIng5,aHlpEsp5)
PutSx1( cPerg,'06','Veículo Até ?       ','¿A Vehículo ?       ','To Vehicle ?','mv_ch6','C',8,0,0,'G','','DA3','','','mv_par06',"","","","","","","","","","","","","","","","",aHlpPor6,aHlpIng6,aHlpEsp6)
PutSx1( cPerg,'07','Impressão/Reimpre.? ','¿Impresion/Nuev.Imp?','Printing/Reprint.?','mv_ch7','N',1,0,0,'C','','','','','mv_par07','Impressão','Impresion','Printing','','Reimpressão','Reimpresion','Reprinting',"","","","","","","","","",aHlpPor7,aHlpIng7,aHlpEsp7)
PutSx1( cPerg,'08','Tipo de Vias ?      ','Tipo de Vias ?      ','Tipo de Vias ?','mv_ch8','N',1,0,0,'C','','' ,'','','mv_par08','Originais','Originais','Originais','','Copias','Copias','Copias','Todas','Todas','Todas',"","","","","","",aHlpPor8,aHlpIng8,aHlpEsp8)

If AllTrim(FunName()) == 'TMSAI45'
	SX1->(dbSetOrder(1))
	If SX1->(MsSeek(cPerg+'01'))
		Reclock('SX1',.F.)
		SX1->X1_CNT01  := DID->DID_FILORI
		SX1->(MsUnlock())
	EndIf
	If SX1->(MsSeek(cPerg+'02'))
		Reclock('SX1',.F.)
		SX1->X1_CNT01  := DID->DID_VIAGEM
		SX1->(MsUnlock())
	EndIf
	If SX1->(MsSeek(cPerg+'03'))
		Reclock('SX1',.F.)
		SX1->X1_CNT01  := DID->DID_FILORI
		SX1->(MsUnlock())
	EndIf
	If SX1->(MsSeek(cPerg+'04'))
		Reclock('SX1',.F.)
		SX1->X1_CNT01  := DID->DID_VIAGEM
		SX1->(MsUnlock())
	EndIf
	If SX1->(MsSeek(cPerg+'05'))
		Reclock('SX1',.F.)
		SX1->X1_CNT01  := DID->DID_CODVEI
		SX1->(MsUnlock())
	EndIf
	If SX1->(MsSeek(cPerg+'06'))
		Reclock('SX1',.F.)
		SX1->X1_CNT01  := DID->DID_CODVEI
		SX1->(MsUnlock())
	EndIf
	If SX1->(MsSeek(cPerg+'07'))
		Reclock('SX1',.F.)
		SX1->X1_PRESEL := 1
		SX1->(MsUnlock())
	EndIf
	If SX1->(MsSeek(cPerg+'08'))
		Reclock('SX1',.F.)
		SX1->X1_PRESEL := 1
		SX1->(MsUnlock())
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³   _DadEmb ³ Autor ³ Jose Luiz Pinheiro Jr³ Data ³22.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna Descricao da Embalagem do Documento e              ³±±
±±³          ³ o codigo da embalagem conforme tabela do siscomex.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TMSDadEmb([ExpC1],[ExpC2],[ExpC3])                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 - Filial Documento                                   ³±±
±±³          ³ ExpC2 - Numero Documento                                   ³±±
±±³          ³ ExpC3 - Serie  Documento                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Expresso Aracatuba                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _DadEmb(cFilDoc,cDoc,cSerie)
Local   aAreaDTC := DTC->(GetArea())
Local   aEmb     := Array(2)
Default cFilDoc  := ''
Default cDoc     := ''
Default cSerie   := ''

Afill(aEmb,Space(2))

If !Empty(cDoc)
	DTC->(dbSetOrder(3))
	DTC->(MsSeek(xFilial('DTC')+cFilDoc+cDoc+cSerie))
	
	aEmb[1] := Tabela('MG',DTC->DTC_CODEMB,.F.)
	
	SX5->(dbSetOrder(1))
	If SX5->(MsSeek(xFilial('SX5')+'MG'+DTC->DTC_CODEMB))
		aEmb[2] := AllTrim(SX5->X5_DESCRI)		// codigo da embalagem
	EndIf
	
EndIf
RestArea(aAreaDTC)
Return aEmb
