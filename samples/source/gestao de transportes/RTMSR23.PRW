#INCLUDE "RTMSR23.ch"
#INCLUDE "protheus.ch"                               
#INCLUDE "rwmake.ch"

Static lAWBRepete := DT8->(FieldPos("DT8_CODCIA")) > 0 .And. DT8->(FieldPos("DT8_LOJCIA")) > 0
Static lDTX_DIGAWB:= ( DTX->(FieldPos("DTX_DIGAWB")) > 0 ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RTMSR23  ºAutor  ³Richard Anderson    º Data ³  26/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa de impressao da fatura aerea                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RTMSR23                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR23()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           
Local cDesc1  	 := STR0001          //"Este relatorio ira imprimir a fatura das AWB´s emitidas"
Local cDesc2  	 := ""
Local cDesc3  	 := ""
Local cPerg   	 := "RTMSR23"
Local Titulo  	 := STR0002 //"Relatório de Fatura de AWB´s"
Local nLin      := 80
Local Cabec1    := STR0003 //"Cia Area..: "
Local Cabec2    := STR0004 //"No.AWB      Dig.         Peso         Valor AWB      Vl.AWB.Liq.        Frete Calc.       Vl.Decresc.      Vl.AWB Desc.     Frete Docto      %CustxRec  Cliente"
Local Cabec3    := STR0005 //"No.Docto    Origem                                Peso    Destino                     Remetente                   Destinatario               %CustxRec  Vlr.Frete     Imposto    Frete Tot."
Local lContinua := .T.
Local aOrd      := {}
Local aAreaAtu  := GetArea() 

Private lEnd    	  := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private Limite   	  := 220
Private Tamanho  	  := "G"
Private NomeProg 	  := "RTMSR23"
Private nTipo    	  := 0
Private aReturn  	  := { STR0006, 1, STR0007, 2, 2, 1, "", 1} //"Zebrado"###"Administracao"
Private nLastKey    := 0
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel    	  := "RTMSR23" 
Private cString     := " " 
Private nTipoRel    := 2 //-- Sintetico

RTmsr23Sx1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o grupo de perguntas.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                         
wnrel  := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipoRel := Iif( MV_PAR01 == 1,1,2)
Titulo   := Alltrim(Titulo) + "  ["+Iif(nTipoRel == 1,STR0008,STR0009)+"]"	 //"Analítico"###"Sintético"

nTipo  := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Cabec3,Titulo,nLin) },Titulo)

RestArea(aAreaAtu)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RunReport ºAutor  ³Richard Anderson    º Data ³  26/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao que monta o layout de impressão                     º±±
±±º          ³ conforme os parametros informados                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunReport(Cabec1,Cabec2,Cabec3,Titulo,nLin)
Local nCnt
Local nQtAWB    := 0
Local nTVAWB    := 0
Local nTVAWBLq  := 0
Local nTVCalc   := 0
Local nTDecres  := 0
Local nTValFre  := 0
Local nTRentab  := 0 
Local	nTPeso    := 0
Local nTFVAWB   := 0
Local nTFVAWBLq := 0
Local nTFVCalc  := 0
Local nTFDecres := 0
Local nTFDecRet := 0
Local nTFValFre := 0
Local nTFRentab := 0 
Local	nTFPeso   := 0
Local nTotFat   := 0
Local nTotFatLQ := 0
Local nRenFat   := 0
Local cAliasQry := GetNextAlias()
Local cAliasDT6 := GetNextAlias()
Local cAliasDCO := GetNextAlias()
Local cCabAux   := Cabec1 
Local lFalta    := .F.
Local cNomCli   := ''
Local aDoctos   := {}
Local nRentab   := 0
Local nRentRet  := 0
Local nDTVPeso  := 0
Local nDT6Peso  := 0
Local nDTVFrtDc := 0
Local nDTVDecres:= 0 
Local lDWXDecres:= .F.
Local nCDocAtu  := 0
Local nRDocAtu  := 0
Local nCDocRet  := 0
Local nRDocRet  := 0


//                                                                                                    1         1         1         1         1         1         1
//          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6
//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//Cia Area...: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                 
//No.AWB    Dig.    Peso        Valor AWB    Vl.AWB.Liq.    Frete Calc.    Vl.Decresc.   Vl.AWB Desc.     Frete EAL   %CustxRec %CustxRec(R)  Cliente                       "
//1234567   x  999,999.9999 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 99,999,999.99 999,999.99   999,999.99  12345678901234567890          "
//CTRC      Origem                   Peso         Destino                  Remetente            Destinatario                                  Vlr.Frete Imposto   Frete Tot."
//99 999999 123456789012345678901234 999,999.9999 123456789012345678901234 12345678901234567890 12345678901234567890                         999,999.99 99999.99 999,999.99 "
//Total =====>"

cQuery := " SELECT * FROM ( "
cQuery += " SELECT DTV_NUMAWB, DTV_DIGAWB, DTV_CODCIA, DTV_LOJCIA, DTV_VAWB  , DTV_VAWBLQ    , DTV_VCALC, "
cQuery += "        DTV_VALFRE, DTV_DECRES, DTV_RENTAB, DTV_FILORI, DTV_VIAGEM, '0' AS TIPAWB , DTV_PESO , " 
cQuery += "        DTV_PESOM3"
cQuery += "   FROM "        
cQuery += RetSqlName("DTV") + " DTV " 
cQuery += " WHERE DTV.DTV_FILIAL = '"+xFilial("DTV")+"'"
cQuery += "   AND DTV.DTV_FATURA = '"+DD8->DD8_FATURA+"'"
cQuery += "   AND DTV.DTV_CODCIA = '"+DD8->DD8_CODCIA+"'"
cQuery += "   AND DTV.DTV_LOJCIA = '"+DD8->DD8_LOJCIA+"'"
cQuery += "   AND DTV.D_E_L_E_T_ = ' '"
cQuery += " UNION ALL "    
cQuery += " SELECT DWW_NUMAWB AS DTV_NUMAWB, ' ' AS DTV_DIGAWB, DWW_CODCIA AS DTV_CODCIA, DWW_LOJCIA AS DTV_LOJCIA, DWW_VAWB AS DTV_VAWB  ,  DWW_VAWB  AS DTV_VAWBLQ, 0 AS DTV_VCALC, "
cQuery += "        DWW_VALFRE AS DTV_VALFRE, 0   AS DTV_DECRES, DWW_RENTAB AS DTV_RENTAB, ' '        AS DTV_FILORI, ' '     AS DTV_VIAGEM , '1' AS TIPAWB    , 0 AS DTV_PESO , "
cQuery += "        0          AS DTV_PESOM3
cQuery += "   FROM "        
cQuery += RetSqlName("DWW") + " DWW " 
cQuery += " WHERE DWW_FILIAL  = '"+xFilial("DWW")+"'"
cQuery += "   AND DWW_FATURA  = '"+DD8->DD8_FATURA+"'"
cQuery += "   AND DWW_CODCIA  = '"+DD8->DD8_CODCIA+"'"
cQuery += "   AND DWW_LOJCIA  = '"+DD8->DD8_LOJCIA+"'"
cQuery += "   AND DWW.D_E_L_E_T_ = ' ')  FATAWB"
cQuery += " ORDER BY TIPAWB, DTV_NUMAWB, DTV_DIGAWB "
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasQry,.T.,.T.)
TcSetField(cAliasQry,"DTV_VAWB  ","N",TamSX3("DTV_VAWB  ")[1],TamSX3("DTV_VAWB  ")[2])
TcSetField(cAliasQry,"DTV_VAWBLQ","N",TamSX3("DTV_VAWBLQ")[1],TamSX3("DTV_VAWBLQ")[2])
TcSetField(cAliasQry,"DTV_VCALC ","N",TamSX3("DTV_VCALC ")[1],TamSX3("DTV_VCALC ")[2])
TcSetField(cAliasQry,"DTV_VALFRE","N",TamSX3("DTV_VALFRE")[1],TamSX3("DTV_VALFRE")[2])
TcSetField(cAliasQry,"DTV_DECRES","N",TamSX3("DTV_DECRES")[1],TamSX3("DTV_DECRES")[2])
TcSetField(cAliasQry,"DTV_RENTAB","N",TamSX3("DTV_RENTAB")[1],TamSX3("DTV_RENTAB")[2])
TcSetField(cAliasQry,"DTV_PESO  ","N",TamSX3("DTV_PESO  ")[1],TamSX3("DTV_PESO  ")[2])
TcSetField(cAliasQry,"DTV_PESOM3","N",TamSX3("DTV_PESOM3")[1],TamSX3("DTV_PESOM3")[2])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())

While (cAliasQry)->(!Eof())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55 //determina tamanho da linha
	   Cabec1 := cCabAux+" "+Posicione("SA2",1,xFilial('SA2')+(cAliasQry)->(DTV_CODCIA+DTV_LOJCIA),"A2_NOME")
		Cabec(STR0010+DD8->DD8_FATURA,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) //"Fatura Aerea No."
		nLin := 9
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif 
	
	If !lFalta .And. (cAliasQry)->TIPAWB == '1'
		nLin++
		@nLin,00 PSAY "*** AWB'S FALTANTES ***"
		nLin++
		lFalta := .T.
	EndIf		
	
	cNomCli    := ''
	aDoctos    := {}                             
	nDT6Peso   := 0
	nRentab    := (cAliasQry)->DTV_RENTAB
	nRentRet   := nRentab   
	nDTVFrtDc  := (cAliasQry)->DTV_VALFRE
	nDTVPeso   := Max((cAliasQry)->DTV_PESO,(cAliasQry)->DTV_PESOM3)
	nDTVDecres := (cAliasQry)->DTV_DECRES
	lDWXDecres := .F.
	DWX->(dbSetOrder(2))
	If lDTX_DIGAWB
		If DWX->(dbSeek(xFilial('DWX')+(cAliasQry)->(DTV_NUMAWB+DTV_DIGAWB+DTV_CODCIA+DTV_LOJCIA)))
			nDTVDecres := DWX->DWX_DECRES
			lDWXDecres := .T.
		EndIf
	Else
		If DWX->(dbSeek(xFilial('DWX')+(cAliasQry)->(DTV_NUMAWB+DTV_CODCIA+DTV_LOJCIA)))
			nDTVDecres := DWX->DWX_DECRES
			lDWXDecres := .T.
		EndIf
	EndIf		
	If !Empty((cAliasQry)->DTV_VIAGEM)
		cQuery  := "SELECT DT6_CLIDEV, DT6_LOJDEV "
		cQuery  += "  FROM "
		cQuery  += RetSqlName("DT6")+" DT6, "
		cQuery  += RetSqlName("DTX")+" DTX, "
		cQuery  += RetSqlName("DUD")+" DUD  "
		cQuery  += " WHERE DTX.DTX_FILIAL = '"+xFilial('DTX')+"'"
		cQuery  += "   AND DTX.DTX_FILORI = '"+(cAliasQry)->DTV_FILORI+"'"
		cQuery  += "   AND DTX.DTX_VIAGEM = '"+(cAliasQry)->DTV_VIAGEM+"'"
		If lAWBRepete
			cQuery += " AND DTX.DTX_NUMAWB = '"+(cAliasQry)->DTV_NUMAWB+"'"
			If lDTX_DIGAWB
				cQuery += " AND DTX.DTX_DIGAWB = '"+(cAliasQry)->DTV_DIGAWB+"'"
			EndIf
			cQuery += " AND DTX.DTX_CODCIA = '"+(cAliasQry)->DTV_CODCIA+"'"
			cQuery += " AND DTX.DTX_LOJCIA = '"+(cAliasQry)->DTV_LOJCIA+"'"
		EndIf
		cQuery  += "   AND DTX.D_E_L_E_T_ = ' '"
		cQuery  += "   AND DUD.DUD_FILIAL = '"+xFilial('DUD')+"'"
		cQuery  += "   AND DUD.DUD_FILORI = DTX_FILORI"
		cQuery  += "   AND DUD.DUD_VIAGEM = DTX_VIAGEM"
		cQuery  += "   AND DUD.DUD_FILMAN = DTX_FILMAN"
		cQuery  += "   AND DUD.DUD_MANIFE = DTX_MANIFE"
		cQuery  += "   AND DUD.D_E_L_E_T_ = ' '"
		cQuery  += "   AND DT6.DT6_FILIAL = '"+xFilial('DT6')+"'"
		cQuery  += "   AND DT6.DT6_FILDOC = DUD_FILDOC"
		cQuery  += "   AND DT6.DT6_DOC    = DUD_DOC   "
		cQuery  += "   AND DT6.DT6_SERIE  = DUD_SERIE "
		cQuery  += "   AND DT6.D_E_L_E_T_ = ' '
		cQuery  += " GROUP BY DT6_CLIDEV, DT6_LOJDEV
		DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDT6,.T.,.T.)
		While (cAliasDT6)->(!Eof()) 
			If Empty(cNomCli)
				cNomCli := Posicione('SA1',1,xFilial('SA1')+(cAliasDT6)->(DT6_CLIDEV+DT6_LOJDEV),'A1_NREDUZ')
			Else
				cNomCli := 'DIVERSOS'
				Exit
			EndIf
			(cAliasDT6)->(dbSkip())
		EndDo
		(cAliasDT6)->(dbCloseArea())
		If nTipoRel  == 1 //-- Analitico			
			nDTVFrtDc := 0
			cQuery    := "SELECT DT6_FILDOC, DT6_DOC   , DT6_SERIE , DT6_CDRORI             , DT6_CDRCAL              , DT6_CLIREM, DT6_LOJREM, "
			cQuery    += "       DT6_CLIDES, DT6_LOJDES, DT6_CLIDEV, DT6_LOJDEV             , DT6_VALFRE              , DT6_VALIMP, DT6_VALTOT, "
			cQuery    += "       DT6_PESO  , DT6_PESOM3, DT6_DOCTMS, DUY_O.DUY_DESCRI REGORI, DUY_D.DUY_DESCRI REGDES , SA1_R.A1_NREDUZ NOMREM, "
			cQuery    += "       SA1_D.A1_NREDUZ NOMDES"
			cQuery    += "  FROM "
			cQuery    += RetSqlName("DT6")+" DT6    "
			cQuery    += "  LEFT JOIN "             
			cQuery    += RetSqlName("DUY")+" DUY_O  "
			cQuery    += "    ON DUY_O.DUY_FILIAL = '"+xFilial('DUY')+"'"
			cQuery    += "   AND DUY_O.DUY_GRPVEN = DT6_CDRORI "
			cQuery    += "   AND DUY_O.D_E_L_E_T_ = ' ' "        
			cQuery    += "  LEFT JOIN "             
			cQuery    += RetSqlName("DUY")+" DUY_D  "
			cQuery    += "    ON DUY_D.DUY_FILIAL = '"+xFilial('DUY')+"'"
			cQuery    += "   AND DUY_D.DUY_GRPVEN = DT6_CDRCAL "
			cQuery    += "   AND DUY_D.D_E_L_E_T_ = ' ' "        
			cQuery    += "  LEFT JOIN "             
			cQuery    += RetSqlName("SA1")+" SA1_R  "
			cQuery    += "    ON SA1_R.A1_FILIAL  = '"+xFilial('DUY')+"'"
			cQuery    += "   AND SA1_R.A1_COD     = DT6_CLIREM "
			cQuery    += "   AND SA1_R.A1_LOJA    = DT6_LOJREM "
			cQuery    += "   AND SA1_R.D_E_L_E_T_ = ' ' "        
			cQuery    += "  LEFT JOIN "             
			cQuery    += RetSqlName("SA1")+" SA1_D  "
			cQuery    += "    ON SA1_D.A1_FILIAL  = '"+xFilial('DUY')+"'"
			cQuery    += "   AND SA1_D.A1_COD     = DT6_CLIDES "
			cQuery    += "   AND SA1_D.A1_LOJA    = DT6_LOJDES "
			cQuery    += "   AND SA1_D.D_E_L_E_T_ = ' ', "        
			cQuery    += RetSqlName("DTX")+" DTX  , "
			cQuery    += RetSqlName("DUD")+" DUD    "
			cQuery    += " WHERE DTX.DTX_FILIAL = '"+xFilial('DTX')+"'"
			cQuery    += "   AND DTX.DTX_FILORI = '"+(cAliasQry)->DTV_FILORI+"'"
			cQuery    += "   AND DTX.DTX_VIAGEM = '"+(cAliasQry)->DTV_VIAGEM+"'"
			If lAWBRepete
				cQuery += " AND DTX.DTX_NUMAWB = '"+(cAliasQry)->DTV_NUMAWB+"'"
				If lDTX_DIGAWB
					cQuery += " AND DTX.DTX_DIGAWB = '"+(cAliasQry)->DTV_DIGAWB+"'"
				EndIf
				cQuery += " AND DTX.DTX_CODCIA = '"+(cAliasQry)->DTV_CODCIA+"'"
				cQuery += " AND DTX.DTX_LOJCIA = '"+(cAliasQry)->DTV_LOJCIA+"'"
			EndIf
			cQuery    += "   AND DTX.D_E_L_E_T_ = ' '"
			cQuery    += "   AND DUD.DUD_FILIAL = '"+xFilial('DUD')+"'" 
			cQuery    += "   AND DUD.DUD_FILORI = DTX_FILORI"
			cQuery    += "   AND DUD.DUD_VIAGEM = DTX_VIAGEM"
			cQuery    += "   AND DUD.DUD_FILMAN = DTX_FILMAN"
			cQuery    += "   AND DUD.DUD_MANIFE = DTX_MANIFE"
			cQuery    += "   AND DUD.D_E_L_E_T_ = ' '"
			cQuery    += "   AND DT6.DT6_FILIAL = '"+xFilial('DT6')+"'"
			cQuery    += "   AND DT6.DT6_FILDOC = DUD_FILDOC"
			cQuery    += "   AND DT6.DT6_DOC    = DUD_DOC   "
			cQuery    += "   AND DT6.DT6_SERIE  = DUD_SERIE "
			cQuery    += "   AND DT6.D_E_L_E_T_ = ' '
			cQuery    += " ORDER BY DT6_FILDOC, DT6_DOC, DT6_SERIE "
			cQuery    := ChangeQuery(cQuery)
			DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDT6,.T.,.T.)
			TcSetField(cAliasDT6,"DT6_VALFRE","N",TamSX3("DT6_VALFRE")[1],TamSX3("DT6_VALFRE")[2])
			TcSetField(cAliasDT6,"DT6_VALIMP","N",TamSX3("DT6_VALIMP")[1],TamSX3("DT6_VALIMP")[2])
			TcSetField(cAliasDT6,"DT6_VALTOT","N",TamSX3("DT6_VALTOT")[1],TamSX3("DT6_VALTOT")[2])
			TcSetField(cAliasDT6,"DT6_PESO  ","N",TamSX3("DT6_PESO  ")[1],TamSX3("DT6_PESO  ")[2])
			TcSetField(cAliasDT6,"DT6_PESOM3","N",TamSX3("DT6_PESOM3")[1],TamSX3("DT6_PESOM3")[2])
			While (cAliasDT6)->(!Eof()) 
				Aadd(aDoctos, { (cAliasDT6)->DT6_FILDOC,;
				                (cAliasDT6)->DT6_DOC   ,;
				                (cAliasDT6)->DT6_SERIE ,;
				                Padr((cAliasDT6)->REGORI,24),;
				                Padr((cAliasDT6)->REGDES,24),;
				                (cAliasDT6)->NOMREM,;
				                (cAliasDT6)->NOMDES,;
				                (cAliasDT6)->DT6_VALFRE,;
				                (cAliasDT6)->DT6_VALIMP,;
				                (cAliasDT6)->DT6_VALTOT,;
				                Max((cAliasDT6)->DT6_PESO,(cAliasDT6)->DT6_PESOM3),;
				                (cAliasDT6)->DT6_DOCTMS })
				nDT6Peso  += Max((cAliasDT6)->DT6_PESO,(cAliasDT6)->DT6_PESOM3) 
				nDTVFrtDc += (cAliasDT6)->DT6_VALFRE 
				cQuery    := "SELECT DT6_FILDOC, DT6_DOC   , DT6_SERIE , DT6_CDRORI             , DT6_CDRCAL              , DT6_CLIREM, DT6_LOJREM, "
				cQuery    += "       DT6_CLIDES, DT6_LOJDES, DT6_CLIDEV, DT6_LOJDEV             , DT6_VALFRE              , DT6_VALIMP, DT6_VALTOT, "
				cQuery    += "       DT6_PESO  , DT6_PESOM3, DT6_DOCTMS, DUY_O.DUY_DESCRI REGORI, DUY_D.DUY_DESCRI REGDES , SA1_R.A1_NREDUZ NOMREM, "
				cQuery    += "       SA1_D.A1_NREDUZ NOMDES"
				cQuery    += "  FROM "
				cQuery    += RetSqlName("DT6")+" DT6    "
				cQuery    += "  LEFT JOIN "             
				cQuery    += RetSqlName("DUY")+" DUY_O  "
				cQuery    += "    ON DUY_O.DUY_FILIAL = '"+xFilial('DUY')+"'"
				cQuery    += "   AND DUY_O.DUY_GRPVEN = DT6_CDRORI "
				cQuery    += "   AND DUY_O.D_E_L_E_T_ = ' ' "        
				cQuery    += "  LEFT JOIN "             
				cQuery    += RetSqlName("DUY")+" DUY_D  "
				cQuery    += "    ON DUY_D.DUY_FILIAL = '"+xFilial('DUY')+"'"
				cQuery    += "   AND DUY_D.DUY_GRPVEN = DT6_CDRCAL "
				cQuery    += "   AND DUY_D.D_E_L_E_T_ = ' ' "        
				cQuery    += "  LEFT JOIN "             
				cQuery    += RetSqlName("SA1")+" SA1_R  "
				cQuery    += "    ON SA1_R.A1_FILIAL  = '"+xFilial('DUY')+"'"
				cQuery    += "   AND SA1_R.A1_COD     = DT6_CLIREM "
				cQuery    += "   AND SA1_R.A1_LOJA    = DT6_LOJREM "
				cQuery    += "   AND SA1_R.D_E_L_E_T_ = ' ' "        
				cQuery    += "  LEFT JOIN "             
				cQuery    += RetSqlName("SA1")+" SA1_D  "
				cQuery    += "    ON SA1_D.A1_FILIAL  = '"+xFilial('DUY')+"'"
				cQuery    += "   AND SA1_D.A1_COD     = DT6_CLIDES "
				cQuery    += "   AND SA1_D.A1_LOJA    = DT6_LOJDES "
				cQuery    += "   AND SA1_D.D_E_L_E_T_ = ' ' "        
				cQuery    += " WHERE DT6.DT6_FILIAL = '"+xFilial('DT6')+"'"
				cQuery    += "   AND DT6.DT6_FILDCO = '"+(cAliasDT6)->DT6_FILDOC+"'"
				cQuery    += "   AND DT6.DT6_DOCDCO = '"+(cAliasDT6)->DT6_DOC   +"'"
				cQuery    += "   AND DT6.DT6_SERDCO = '"+(cAliasDT6)->DT6_SERIE +"'"
				cQuery    += "   AND DT6.D_E_L_E_T_ = ' '"
				dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasDCO,.T.,.T.)
				TcSetField(cAliasDCO,"DT6_VALFRE","N",TamSX3("DT6_VALFRE")[1],TamSX3("DT6_VALFRE")[2])
				TcSetField(cAliasDCO,"DT6_VALIMP","N",TamSX3("DT6_VALIMP")[1],TamSX3("DT6_VALIMP")[2])
				TcSetField(cAliasDCO,"DT6_VALTOT","N",TamSX3("DT6_VALTOT")[1],TamSX3("DT6_VALTOT")[2])
				TcSetField(cAliasDCO,"DT6_PESO  ","N",TamSX3("DT6_PESO  ")[1],TamSX3("DT6_PESO  ")[2])
				TcSetField(cAliasDCO,"DT6_PESOM3","N",TamSX3("DT6_PESOM3")[1],TamSX3("DT6_PESOM3")[2])
				While (cAliasDCO)->(!Eof()) 
					Aadd(aDoctos, { (cAliasDCO)->DT6_FILDOC ,;
					                (cAliasDCO)->DT6_DOC    ,;
					                (cAliasDCO)->DT6_SERIE  ,;
					                Padr((cAliasDCO)->REGORI,24),;
					                Padr((cAliasDCO)->REGDES,24),;
					                (cAliasDCO)->NOMREM,;
				   	             (cAliasDCO)->NOMDES,;
					                (cAliasDCO)->DT6_VALFRE,;
					                (cAliasDCO)->DT6_VALIMP,;
					                (cAliasDCO)->DT6_VALTOT,;
					                Max((cAliasDCO)->DT6_PESO,(cAliasDCO)->DT6_PESOM3),;
					                (cAliasDCO)->DT6_DOCTMS })
					nDTVFrtDc += (cAliasDCO)->DT6_VALFRE
					(cAliasDCO)->(dbSkip())
				EndDo
				(cAliasDCO)->(dbCloseArea())										                
				(cAliasDT6)->(dbSkip())
			EndDo
			(cAliasDT6)->(dbCloseArea())
		EndIf
		If lDWXDecres
			nRentab  := Round(((cAliasQry)->DTV_VAWBLQ / nDTVFrtDc) * 100,2)  
			If (cAliasQry)->DTV_VAWBLQ > nDTVFrtDc
				nRentab  := nRentab  * -1
			EndIf
			//-- Rentabilidade Desconto Retroativo
			nRentRet := Round((((cAliasQry)->DTV_VAWBLQ - nDTVDecres) / nDTVFrtDc) * 100,2)  
			If ((cAliasQry)->DTV_VAWBLQ - nDTVDecres) > nDTVFrtDc
				nRentRet := nRentRet * -1
			EndIf
		Else
			nRentab  := Round((((cAliasQry)->DTV_VAWBLQ - nDTVDecres) / nDTVFrtDc) * 100,2)  
			If ((cAliasQry)->DTV_VAWBLQ - nDTVDecres) > nDTVFrtDc
				nRentab := nRentab * -1
			EndIf
			nRentRet := nRentab
		EndIf				 
	EndIf

	@ nLin,000 PSay (cAliasQry)->DTV_NUMAWB
	@ nLin,013 Psay (cAliasQry)->DTV_DIGAWB
	@ nLin,018 PSay Transform(nDTVPeso               					,"@E 999,999.9999")
	@ nLin,034 PSay Transform((cAliasQry)->DTV_VAWB  					,"@E 999,999,999.99")
	@ nLin,051 PSay Transform((cAliasQry)->DTV_VAWBLQ					,"@E 999,999,999.99")
	@ nLin,070 PSay Transform((cAliasQry)->DTV_VCALC 					,"@E 999,999,999.99")
	@ nLin,088 PSay Transform(nDTVDecres              					,"@E 999,999,999.99")+Iif(lDWXDecres,'(R)','')
	@ nLin,106 PSay Transform((cAliasQry)->(DTV_VAWB-DTV_DECRES)	,"@E 999,999,999.99")
	@ nLin,122 PSay Transform(nDTVFrtDc                			   ,"@E 999,999,999.99")
	@ nLin,141 PSay Transform(nRentab                   		      ,"@E 999,999.99")
	@ nLin,155 PSay Transform(nRentRet                  		      ,"@E 999,999.99")
	@ nLin,167 PSay cNomCli                                        
	nLin++

	nQtAWB    += 1
	nTVAWB    += (cAliasQry)->DTV_VAWB
	nTVAWBLq  += (cAliasQry)->DTV_VAWBLQ
	nTVCalc   += (cAliasQry)->DTV_VCALC
	nTDecres  += (cAliasQry)->DTV_DECRES
	nTValFre  += (cAliasQry)->DTV_VALFRE
	nTPeso    += nDTVPeso
	nTFDecRet += Iif(lDWXDecres,nDTVDecres,0)
	
	If (cAliasQry)->TIPAWB == '1'
		nTFVAWB   += (cAliasQry)->DTV_VAWB
		nTFVAWBLq += (cAliasQry)->DTV_VAWBLQ
		nTFVCalc  += (cAliasQry)->DTV_VCALC
		nTFDecres += (cAliasQry)->DTV_DECRES
		nTFValFre += (cAliasQry)->DTV_VALFRE
		nTFPeso   += nDTVPeso
		nTFDecRet += Iif(lDWXDecres,nDTVDecres,0)
	EndIf
	
	If Len(aDoctos) > 0
		If nLin+1 > 55
			nLin := 60
		Else			
			@ nLin,000 Psay Cabec3
			nLin += 1
		EndIf			
		For nCnt := 1 To Len(aDoctos)
			If nLin > 55 //determina tamanho da linha
			   Cabec1 := cCabAux+" "+Posicione("SA2",1,xFilial('SA2')+(cAliasQry)->(DTV_CODCIA+DTV_LOJCIA),"A2_NOME")
				Cabec("Fatura Aerea No." + DD8->DD8_FATURA ,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
				@ nLin,000 Psay Cabec3
				nLin += 1
			EndIf
			If lDWXDecres
				nCDocAtu := ((cAliasQry)->(DTV_VAWBLQ * aDoctos[nCnt,11])) / nDT6Peso
				nCDocRet := ((cAliasQry)->(DTV_VAWBLQ - nDTVDecres) * aDoctos[nCnt,11]) / nDT6Peso
			Else
				nCDocAtu := ((cAliasQry)->(DTV_VAWBLQ - nDTVDecres) * aDoctos[nCnt,11]) / nDT6Peso
				nCDocRet := nCDocAtu
			EndIf				 
			//-- Custo do documento atual
			nRDocAtu := Round((nCDocAtu / aDoctos[nCnt,08]) * 100,2)  
			If nCDocAtu > nDTVFrtDc
				nRDocAtu := nRDocAtu * -1
			EndIf
			//-- Custo do documento retroativo
			nRDocRet := Round((nCDocRet / aDoctos[nCnt,08]) * 100,2)  
			If nCDocRet > nDTVFrtDc
				nRDocRet := nRDocRet * -1
			EndIf
			@ nLin,000  Psay aDoctos[nCnt,01]+" "+aDoctos[nCnt,02]
			@ nLin,013  Psay aDoctos[nCnt,12]
			@ nLin,018  Psay aDoctos[nCnt,04]
			@ nLin,043  Psay Transform(aDoctos[nCnt,11],"@E 999999.9999")
			@ nLin,058  Psay aDoctos[nCnt,05]
			@ nLin,086	Psay aDoctos[nCnt,06]
			@ nLin,115  Psay aDoctos[nCnt,07]
			@ nLin,141  PSay Transform(nRDocAtu        ,"@E 999,999.99")
			@ nLin,155  PSay Transform(nRDocRet        ,"@E 999,999.99")
			@ nLin,166  Psay Transform(aDoctos[nCnt,08],"@E 999,999.99")
			@ nLin,180  Psay Transform(aDoctos[nCnt,09],"@E 99999.99")
			@ nLin,192  Psay Transform(aDoctos[nCnt,10],"@E 999,999.99")
			nLin += 1
		Next nCnt
		nLin += 1
	EndIf					
	(cAliasQry)->(dbSkip())
EndDo
(cAliasQry)->(dbCloseArea())

nTRentab := Round(((nTVAWBLQ - nTDecres) / nTValFre) * 100,2)  
If (nTVAWBLQ  - nTDecres) > nTValFre
	nTRentab := nTRentab * -1
EndIf 

nTFRentab := Round(((nTFVAWBLQ - nTFDecres) / nTFValFre) * 100,2)  
If (nTFVAWBLQ - nTFDecres)  > nTFValFre
	nTFRentab := nTFRentab * -1
EndIf                                                        
                                                       
If Empty(nTFDecRet) .And. AliasInDic("DWX")
	cQuery := "SELECT SUM(DWX_DECRES) DWX_DECRES "
	cQuery += "  FROM "
	cQuery += RetSqlName("DWX")+" DWX "
	cQuery += " WHERE DWX.DWX_FILIAL = '"+xFilial("DWX")+"'"
	cQuery += "   AND DWX.DWX_FATURA = '"+DD8->DD8_FATURA+"'"
	cQuery += "   AND DWX.DWX_CODCIA = '"+DD8->DD8_CODCIA+"'"
	cQuery += "   AND DWX.DWX_LOJCIA = '"+DD8->DD8_LOJCIA+"'"
	cQuery += "   AND DWX.D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry,"DWX_DECRES","N",TamSX3("DWX_DECRES")[1],TamSX3("DWX_DECRES")[2])
	If (cAliasQry)->(!Eof())
		nTFDecRet := (cAliasQry)->DWX_DECRES
	EndIf
	(cAliasQry)->(dbCloseArea())
EndIf			 

Cabec("Fatura Aerea No."+DD8->DD8_FATURA,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 9
If nTFVAWB > 0
	@ nLin,000 Psay "Tot.Falta ==>"
	@ nLin,018 PSay Transform(nTFPeso					,"@E 999,999.9999")
	@ nLin,033 PSay Transform(nTFVAWB 					,"@E 999,999,999.99")
	@ nLin,050 PSay Transform(nTFVAWBLq					,"@E 999,999,999.99")
	@ nLin,069 PSay Transform(nTFVCalc 					,"@E 999,999,999.99")
	@ nLin,087 PSay Transform(nTFDecres					,"@E 999,999,999.99")
	@ nLin,105 PSay Transform((nTFVAWB-nTFDecres)	,"@E 999,999,999.99")
	@ nLin,122 PSay Transform(nTFValFre					,"@E 999,999,999.99")
	@ nLin,141 PSay Transform(nTFRentab					,"@E 999,999.99")
	nLin++ 
EndIf	
@ nLin,000 Psay "Total ======>"
@ nLin,018 PSay Transform(nTPeso		  			,"@E 999,999.9999")
@ nLin,033 PSay Transform(nTVAWB  	  			,"@E 999,999,999.99")
@ nLin,050 PSay Transform(nTVAWBLq	  			,"@E 999,999,999.99")
@ nLin,069 PSay Transform(nTVCalc 				,"@E 999,999,999.99")
@ nLin,087 PSay Transform(nTDecres				,"@E 999,999,999.99")
@ nLin,105 PSay Transform((nTVAWB-nTDecres)	,"@E 999,999,999.99")
@ nLin,122 PSay Transform(nTValFre				,"@E 999,999,999.99")
@ nLin,141 PSay Transform(nTRentab				,"@E 999,999.99")
nLin++
@ nLin,000 Psay "Comissão  (-)"
@ nLin,105 PSay Transform(DD8->DD8_COMISS		,"@E 999,999,999.99")

nLin++
@ nLin,000 Psay "IRRF      (+)"
@ nLin,105 PSay Transform(DD8->DD8_IRRF   	,"@E 999,999,999.99")

nLin++         
@ nLin,000 Psay "ISS       (+)"
@ nLin,105 PSay Transform(DD8->DD8_ISS    	,"@E 999,999,999.99")

nLin++         
@ nLin,000 Psay "Total Fat.==>"
nTotFat   := (nTVAWB   - nTDecres) - DD8->DD8_COMISS + DD8->DD8_IRRF + DD8->DD8_ISS
nTotFatLQ := (nTVAWBLQ - nTDecres) - DD8->DD8_COMISS + DD8->DD8_IRRF + DD8->DD8_ISS
nRenFat := Round((nTotFatLQ / nTValFre) * 100,2)  
If nTotFatLQ > nTValFre
	nRenFat := nRenFat * -1
EndIf 
@ nLin,105 PSay Transform(nTotFat	,"@E 999,999,999.99")
@ nLin,141 PSay Transform(nRenFat	,"@E 999,999.99")

//-- Imprime total de desconto retroativo
If nTFDecRet > 0
	nLin++         
	@ nLin,00 PSAY __PrtThinLine()
	nLin++         
	@ nLin,000 Psay "Desc. Ret.(-)"
	@ nLin,105 PSay Transform(nTFDecRet ,"@E 999,999,999.99")
	nTotFat   := (nTVAWB   - nTDecres-nTFDecRet) - DD8->DD8_COMISS + DD8->DD8_IRRF + DD8->DD8_ISS
	nTotFatLQ := (nTVAWBLQ - nTDecres-nTFDecRet) - DD8->DD8_COMISS + DD8->DD8_IRRF + DD8->DD8_ISS
	nRenFat := Round((nTotFatLQ / nTValFre) * 100,2)  
	If nTotFatLQ > nTValFre
		nRenFat := nRenFat * -1
	EndIf 
	nLin++         
	@ nLin,000 Psay "T.Fat.Ret.==>"
	@ nLin,105 PSay Transform(nTotFat	,"@E 999,999,999.99")
	@ nLin,154 PSay Transform(nRenFat	,"@E 999,999.99")
	nLin++         
	@ nLin,00 PSAY __PrtThinLine()
EndIf	
	
nLin++         
@ nLin,00 Psay "Qtde. AWBs =>"
@ nLin,16 PSay Transform(nQtAWB  	,"@E 999,999")

nLin++
@ nLin,00 PSAY __PrtThinLine()

nLin += 5
@ nLin,00 PSAY "Pagto. Autorizado por: ___________________________________________________   ____/____/____ " 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Rtmsr23   ³ Autor ³Richard Anderson    ³ Data ³ 26/03/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Inclui Perguntas no SX1                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³RTMSR24                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RtmsR23SX1()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpEsp := {}

Aadd(aHelpPor, 'Informe o Tipo do Relatório.' )
PutSX1('RTMSR23','01',"Tipo do Relatório?"	,"Tipo do Relatório?"	,"Tipo do Relatório?"	,'mv_ch1','N',1,0,1,'C','',''   ,'','','mv_par01',"Analítico","Analítico","Analítico",'',"Sintético","Sintético","Sintético", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpEsp)

Return NIL
