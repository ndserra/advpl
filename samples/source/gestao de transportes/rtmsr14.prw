#INCLUDE "RTMSR14.CH"
#INCLUDE "PROTHEUS.CH"

Static cFileLogo := "lgrl"+SM0->M0_CODIGO+cFilAnt+".bmp"

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥FUNCAO    ≥ RTMSR14  ≥ AUTOR ≥ Eduardo de Souza      ≥ DATA ≥ 16/03/2006 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DESCRICAO ≥ Programa de impressao da Proposta Comercial                  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ USO      ≥ SIGATMS                                                      ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
User Function RTMSR14()

Local oPrint
Local aArea    := GetArea()
Local lEnd     := .T.
Local cDesNeg  := Posicione("DW5",1,xFilial("DW5")+DW7->DW7_CODNEG,Iif(DW5->(FieldPos('DW5_DESPRO')) > 0,"DW5_DESPRO","DW5_DESNEG"))
Local aRodaPe  := {}
Local lRet     := .T.
Local aAreaDW7 := DW7->(GetArea())
Private nLin   := 200
Private Inclui := .F.

If DW7->DW7_TIPTRA == StrZero(2,Len(DW7->DW7_TIPTRA)) //  Aereo
	cFileLogo := "lgrl"+SM0->M0_CODIGO+cFilAnt+".bmp"
Else
	cFileLogo := "lgrl"+SM0->M0_CODIGO+cFilAnt+".bmp"
EndIf

If !Empty(DW7->DW7_NUMPRI)
	MsgAlert("Proposta complementar somente poder· ser impressa a partir da principal")
	lRet := .F.
EndIf

If lRet	
	If DW7->DW7_STATUS == StrZero(9,Len(DW7->DW7_STATUS)) .Or. ; //-- Cancelada
		DW7->DW7_STATUS == StrZero(1,Len(DW7->DW7_STATUS)) //-- Pendente
		Help("",1,"TMSAW1001",,"N„o sera permitido a impress„o de proposta pendente ou cancelada.",1)
		lRet := .F.
	EndIf
	
	If lRet
		Aadd( aRodaPe, {"Expresso AraÁatuba Transportes e Logistica Ltda.",.F.})
		Aadd( aRodaPe, {"Filial: " + AllTrim(SM0->M0_FILIAL) + " - End.: " + AllTrim(SM0->M0_ENDENT) + " - Tel.: " + AllTrim(SM0->M0_TEL) + " - e-mail: " + "xxx@xxxxxx.xxx.xx",.F.})
		Aadd( aRodaPe, {"1 Via - Cliente - 1 Via - Filial - 1 Via - Matriz",.T.})

		oPrint := PcoPrtIni(cDesNeg,.F.,2,.T.,@lRet,,,,,,aRodaPe)
		If lRet
			RptStatus( {|lEnd| RTMSR14Imp(@lEnd,oPrint)})
			PcoPrtEnd(oPrint)
		EndIf
	EndIf		
EndIf	
	
RestArea(aArea)

Return lRet

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥RTMSR14Imp≥ Autor ≥ Eduardo de Souza      ≥ Data ≥16-03-2006≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Funcao de impressao                                         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥RTMSR14Imp(lEnd)                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ lEnd - Variavel para cancelamento da impressao pelo usuario≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function RTMSR14Imp(lEnd,oPrint)

Local aItensPro := {}
Local	cAliasDWI := GetNextAlias()
Local n1Cnt     := 0 
Local n2Cnt     := 0
Local aSqlOri   := {}
Local aSQLDes   := {}
Local nQuebra   := 800
Local cFilOri   := DW7->DW7_FILORI
Local cNumPro   := DW7->DW7_NUMPRO
Local cSqlOri	 := ""
Local cSqlDes	 := ""
Local nX			 := 0

Private aValorEst := {}          

cQuery := " SELECT DWI_CDRORI, DWI_CDRDES, "
cQuery += " 		 CASE WHEN DWM_TIPREG <> ' ' THEN DWM_TIPREG ELSE '0' END DWM_TIPREG "
cQuery += "   FROM ( "
cQuery += "   SELECT DWI_CDRORI, DWI_CDRDES, DWM_TIPREG "
cQuery += "   FROM " + RetSqlName("DWI") + " DWI "
cQuery += "   LEFT JOIN " + RetSqlName("DWM") + " DWM "
cQuery += "     ON DWM_FILIAL = '" + xFilial("DWM") + "' "
cQuery += "     AND DWM_CODREG = DWI_CDRDES "
cQuery += "     AND DWM.D_E_L_E_T_ = ' ' "
cQuery += "     WHERE DWI_FILIAL = '" + xFilial("DWI") + "' "
cQuery += "     	AND DWI_FILORI = '" + cFilOri + "' "
cQuery += "     	AND DWI_NUMPRO = '" + cNumPro + "' "
cQuery += "     	AND DWI.D_E_L_E_T_ = ' ' ) QUERY "
cQuery += " ORDER BY DWM_TIPREG "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDWI)
While (cAliasDWI)->(!Eof())
	//-- Verifica as regioes superiores
	aRegioes := {}
	TMSAddReg(@aRegioes,(cAliasDWI)->DWI_CDRORI,(cAliasDWI)->DWI_CDRDES,,StrZero(1,Len(DT3->DT3_PSQTXA)))
	For nX := 1 To Len(aRegioes)
		If !( aRegioes[nX,1] $ cSqlOri ) .And. Ascan(aSQLOri,{|x| (aRegioes[nX,1] $ x)}) == 0	 
			cSqlOri += "'"+aRegioes[nX,1]+"',"
			If Mod(nX,nQuebra) == 0 
				cSqlOri := Substr(cSqlOri,1,Len(cSqlOri) - 1)
				Aadd( aSQLOri, cSqlOri )
				cSqlOri := ''
			EndIf
		EndIf
		If !( aRegioes[nX,2] $ cSqlDes )  .And. Ascan(aSQLDes,{|x| (aRegioes[nX,2] $ x)}) == 0	 
			cSqlDes += "'"+aRegioes[nX,2]+"',"
			If Mod(nX,nQuebra) == 0
				cSqlDes := Substr(cSqlDes,1,Len(cSqlDes) - 1)
				Aadd( aSQLDes, cSqlDes )
				cSqlDes := ''
			EndIf
		EndIf
	Next nX
	(cAliasDWI)->(DbSkip())
EndDo
If Mod(nX,nQuebra) <> 0 .And. cSqlOri <> ''
	cSqlOri := Substr(cSqlOri,1,Len(cSqlOri) - 1)
   Aadd( aSQLOri, cSqlOri )
EndIf
If Mod(nX,nQuebra) <> 0 .And. cSqlDes <> ''
	cSqlDes := Substr(cSqlDes,1,Len(cSqlDes) - 1)
	Aadd( aSQLDes, cSqlDes )
EndIf

For n1Cnt := 1 To Len(aSqlOri)
	For n2Cnt := 1 To Len(aSqlDes)
		MontaArr(aItensPro,aSqlOri[n1Cnt],aSqlDes[n2Cnt],cAliasDWI)
	Next n2Cnt
Next n1Cnt

If !Empty(aItensPro)
	RTMSR14Cab(oPrint,aItensPro)
	RTMSR14It(oPrint,aItensPro)
	ImpFinal(oPrint)
EndIf

(cAliasDWI)->(dbCloseArea())

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ MontaArr ≥ Autor ≥ Eduardo de Souza      ≥ Data ≥ 16/03/06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Monta array da Proposta Comercial                          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGATMS - Proposta Comercial                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function MontaArr(aItensPro,cSqlOri,cSqlDes,cAliasDWI)

Local nX			 := 0
Local cQuery    := ""
Local cCompImp  := ""
Local aCompImp  := {}
Local aCompFai  := {}
Local cCompFai  := ""
Local cCompFaiPri := ""
Local cSeekDW6  := ""
Local cCodNeg   := DW7->DW7_CODNEG
Local cTipFre   := DW7->DW7_TIPFRE
Local cFilOri   := DW7->DW7_FILORI
Local cNumPro   := DW7->DW7_NUMPRO
Local cNumPri   := DW7->DW7_NUMPRI
Local cTabFre   := DW7->DW7_TABFRE
Local cTipTab   := DW7->DW7_TIPTAB
Local cTabFrePri:= ""
Local cTipTabPri:= ""
Local	cAliasDWJ := GetNextAlias()
Local	cAliasQry := GetNextAlias()
Local	aStruDWJ  := DWJ->(dbStruct())
Local	cCdrOri   := ""
Local cCdrDes   := ""
Local	cCodPro   := ""
Local	cServic   := ""
Local	cEst      := ""
Local	cRegiao   := ""
Local nPrcTab   := 0
Local nPrcAju   := 0
Local aRegioes  := {}
Local aEstado   := {}
Local aCab      := {}
Local cRegPri   := ""
Local cOrdem    := ""
Local cCompPri  := ""
Local lMin      := .F.
Local lMinPri   := .F.
Local nValMin   := 0
Local lPraca    := ( DW7->DW7_TIPPRC == "1" )
Local cCompEst  := ""
Local cCompEstPri:= ""
Local cEstOri    := ""
Local cCompMin   := ""
Local cCompPrMin := ""
Local aAreaDW7   := {}
Local cRegOri    := ""
Local cRegDes    := ""
Local lReajuste  := ( DW7->DW7_TIPPRO == StrZero(2,Len(DW7->DW7_TIPPRO)) ) 

//-- Pesquisa se a uma proposta com complementar
If Empty(cNumPri)
	aAreaDW7 := DW7->(GetArea())
	DW7->(dbSetorder(4))
	If DW7->(DbSeek(xFilial("DW7")+DW7->DW7_FILORI+DW7->DW7_NUMPRO))
		cNumPri := DW7->DW7_NUMPRO
	EndIf                        
	RestArea(aAreaDW7)	
EndIf

//-- Verifica componentes para serem impressos do tipo de negociaÁ„o da proposta
DW6->(dbSetOrder(1))
DW6->(MsSeek(cSeekDW6 := xFilial("DW6")+cCodNeg))
While DW6->(!Eof()) .And. DW6->(DW6_FILIAL+DW6_CODNEG) == cSeekDW6
	If DW6->DW6_IMPCOM == "1" //-- Sim
		If !Empty(cCompImp)
			cCompImp += "',"
		EndIf
		cCompImp += "'"+DW6->DW6_CODPAS
		If DW6->DW6_IMPMIN == "1" //-- Sim
			lMin := .T.
			If !Empty(cCompMin)
				cCompMin += "',"
			EndIf				             
			cCompMin += "'"+DW6->DW6_CODPAS
		EndIf
	EndIf
	If DW6->DW6_IMPFAI == "1" //-- Sim
		If !Empty(cCompFai)
			cCompFai += ","
		EndIf
		cCompFai += DW6->DW6_CODPAS
	EndIf
	DW6->(dbSkip())
EndDo
If Empty(cCompImp)
	MsgAlert(STR0022+cCodNeg) // "N„o existem componentes configurados para impress„o no tipo de negociaÁ„o "
	Return aItensPro
Else	
	cCompImp += "'"
	cCompMin += "'"
EndIf

If !Empty(cNumPri)
	//-- Verifica componentes para serem impressos do tipo de negociaÁ„o da proposta principal
	aAreaDW7 := DW7->(GetArea())
	DW7->(DbSetOrder(1))
	If DW7->(MsSeek(xFilial("DW7")+cFilOri+cNumPri))
		cTabFrePri := DW7->DW7_TABFRE
		cTipTabPri := DW7->DW7_TIPTAB
		cCodNeg    := DW7->DW7_CODNEG
		DW6->(dbSetOrder(1))
		DW6->(MsSeek(cSeekDW6 := xFilial("DW6")+cCodNeg))
		While DW6->(!Eof()) .And. DW6->(DW6_FILIAL+DW6_CODNEG) == cSeekDW6
			If DW6->DW6_IMPCOM == "1" //-- Sim
				If !Empty(cCompPri)
					cCompPri += "',"
				EndIf
				cCompPri += "'"+DW6->DW6_CODPAS
				If DW6->DW6_IMPMIN == "1" //-- Sim
					lMinPri := .T.
					If !Empty(cCompPrMin)
						cCompPrMin += "',"
					EndIf				
					cCompPrMin += "'"+DW6->DW6_CODPAS
				EndIf	
			EndIf
			If DW6->DW6_IMPFAI == "1" //-- Sim
				If !Empty(cCompFaiPri)
					cCompFaiPri += ","
				EndIf
				cCompFaiPri += DW6->DW6_CODPAS
			EndIf
			DW6->(dbSkip())
		EndDo
		If Empty(cCompPri)
			MsgAlert(STR0022+cCodNeg) // "N„o existem componentes configurados para impress„o no tipo de negociaÁ„o "
			Return aItensPro
		Else	
			cCompPri += "'"
			cCompPrMin += "'"
		EndIf
	EndIf
	RestArea( aAreaDW7 )
EndIf

If !Empty(cSqlOri) .And. !Empty(cSqlDes)
	cQuery := " SELECT CODPAS,MIN(ITEM) ITEM,VALATE,MIN(INTERV) INTERV, MAX(ORIGEM) ORIGEM "
	cQuery += " 	FROM ( "
	cQuery += " SELECT DWJ_CODPAS CODPAS, DWJ_ITEM ITEM, DWJ_VALATE VALATE, MIN(DWJ_INTERV) INTERV, '1' ORIGEM FROM "
	cQuery += RetSqlName("DWJ")+" DWJ "
	cQuery += "   JOIN " + RetSqlName("DWA")+" DWA " //-- Join para verificar se a cobranca existe
	cQuery += " 	 ON DWA_FILIAL = '"+xFilial("DWA")+"'"
	cQuery += "    AND DWA_FILORI = DWJ_FILORI "
	cQuery += " 	AND DWA_NUMPRO = DWJ_NUMPRO "
	cQuery += " 	AND DWA_CODPAS = DWJ_CODPAS "
	cQuery += " 	AND DWA_PERCOB > 0  "
	cQuery += " 	AND DWA.D_E_L_E_T_ = ' ' "
	cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
	cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
	cQuery += "    AND DWJ_NUMPRO = '"+cNumPro+"'"
	cQuery += "    AND DWJ_CODPAS IN ( " +cCompImp+ " )"
	cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
	cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
	cQuery += "    AND DWJ_PERAJU <> 0 "
	cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
	cQuery += " GROUP BY DWJ_CODPAS,DWJ_ITEM,DWJ_VALATE"
	If lMin
		cQuery += " UNION ALL "
		cQuery += " SELECT 'MN'||DWJ_CODPAS CODPAS , MIN(DWJ_ITEM) ITEM , MAX(DWJ_VALATE) VALATE , MIN(DWJ_INTERV) INTERV ,'1' ORIGEM  FROM "
		cQuery += RetSqlName("DWJ")+" DWJ "
		cQuery += "  JOIN " + RetSqlName("DWD")+" DWD "
		cQuery += "    ON DWD_FILIAL = '"+xFilial("DWD")+"'"
		cQuery += " 	AND DWD_FILORI = DWJ_FILORI "        
		cQuery += " 	AND DWD_NUMPRO = DWJ_NUMPRO "
		cQuery += " 	AND DWD_CODPAS = DWJ_CODPAS "
		cQuery += " 	AND DWD_VALMIN > 0 "
		cQuery += " 	AND DWD.D_E_L_E_T_ = ' ' "
		cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
		cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
		cQuery += "    AND DWJ_NUMPRO = '"+cNumPro+"'"
		cQuery += "    AND DWJ_CODPAS IN ( " +cCompMin+ " )"
		cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
		cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
		cQuery += "    AND DWJ_PERAJU <> 0 "
		cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
		cQuery += " GROUP BY DWJ_CODPAS"
		
		cQuery += " UNION ALL "
		cQuery += " SELECT 'MN'||DWJ_CODPAS CODPAS , MIN(DWJ_ITEM) ITEM , MAX(DWJ_VALATE) VALATE , MIN(DWJ_INTERV) INTERV ,'1' ORIGEM  FROM "
		cQuery += RetSqlName("DWJ")+" DWJ "
		cQuery += "   JOIN " + RetSqlName("DWA")+" DWA "
		cQuery += " 	 ON DWA_FILIAL = '"+xFilial("DWA")+"'"
		cQuery += " 	AND DWA_FILORI = DWJ_FILORI "					
		cQuery += " 	AND DWA_NUMPRO = DWJ_NUMPRO "
		cQuery += " 	AND DWA_CODPAS = DWJ_CODPAS "
		cQuery += " 	AND DWA_VALMIN > 0 "
		cQuery += " 	AND DWA_PERCOB > 0 "
		cQuery += " 	AND DWA.D_E_L_E_T_ = ' ' "
		cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
		cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
		cQuery += "    AND DWJ_NUMPRO = '"+cNumPro+"'"
		cQuery += "    AND DWJ_CODPAS IN ( " +cCompMin+ " )"
		cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
		cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
		cQuery += "    AND DWJ_PERAJU <> 0 "
		cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
		cQuery += " GROUP BY DWJ_CODPAS"
	EndIf
	If !Empty(cNumPri)
		cQuery += " UNION ALL "
		cQuery += " SELECT DWJ_CODPAS CODPAS, DWJ_ITEM ITEM, DWJ_VALATE VALATE, MIN(DWJ_INTERV) INTERV, '2' ORIGEM FROM "
		cQuery += RetSqlName("DWJ")+" DWJ "
		cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
		cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
		cQuery += "    AND DWJ_NUMPRO = '"+cNumPri+"'"
		cQuery += "    AND DWJ_CODPAS IN ( " +cCompPri+ " )"
		cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
		cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
		cQuery += "    AND DWJ_PERAJU <> 0 "
		cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
		cQuery += " GROUP BY DWJ_CODPAS,DWJ_ITEM,DWJ_VALATE "
		If lMinPri
			cQuery += " UNION ALL "
			cQuery += " SELECT 'MN'||DWJ_CODPAS CODPAS , MIN(DWJ_ITEM) ITEM , MAX(DWJ_VALATE) VALATE , MIN(DWJ_INTERV) INTERV ,'2' ORIGEM  FROM "
			cQuery += RetSqlName("DWJ")+" DWJ "
			cQuery += "  JOIN " + RetSqlName("DWD")+" DWD "
			cQuery += " 	ON  DWD_FILIAL = '"+xFilial("DWD")+"'"
			cQuery += " 	AND DWD_FILORI = DWJ_FILORI "					
			cQuery += " 	AND DWD_NUMPRO = DWJ_NUMPRO "
			cQuery += " 	AND DWD_CODPAS = DWJ_CODPAS "
			cQuery += " 	AND DWD_VALMIN > 0 "
			cQuery += " 	AND DWD.D_E_L_E_T_ = ' ' "
			cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
			cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
			cQuery += "    AND DWJ_NUMPRO = '"+cNumPri+"'"
			cQuery += "    AND DWJ_CODPAS IN ( " +cCompPrMin+ " )"
			cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
			cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
			cQuery += "    AND DWJ_PERAJU <> 0 "
			cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
			cQuery += " GROUP BY DWJ_CODPAS "

			cQuery += " UNION ALL "
			cQuery += " SELECT 'MN'||DWJ_CODPAS CODPAS , MIN(DWJ_ITEM) ITEM , MAX(DWJ_VALATE) VALATE , MIN(DWJ_INTERV) INTERV ,'2' ORIGEM  FROM "
			cQuery += RetSqlName("DWJ")+" DWJ "
			cQuery += "   JOIN " + RetSqlName("DWA")+" DWA "
			cQuery += " 	 ON DWA_FILIAL = '"+xFilial("DWA")+"'"
			cQuery += " 	AND DWA_FILORI = DWJ_FILORI "						
			cQuery += " 	AND DWA_NUMPRO = DWJ_NUMPRO "
			cQuery += " 	AND DWA_CODPAS = DWJ_CODPAS "
			cQuery += " 	AND DWA_VALMIN > 0 "
			cQuery += " 	AND DWA_PERCOB > 0 "
			cQuery += " 	AND DWA.D_E_L_E_T_ = ' ' "
			cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
			cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
			cQuery += "    AND DWJ_NUMPRO = '"+cNumPri+"'"
			cQuery += "    AND DWJ_CODPAS IN ( " +cCompPrMin+ " )"
			cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
			cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
			cQuery += "    AND DWJ_PERAJU <> 0 "
			cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
			cQuery += " GROUP BY DWJ_CODPAS "
		EndIf
	EndIf
	cQuery += " ) QRY GROUP BY CODPAS,VALATE "
	cQuery += " ORDER BY ORIGEM,CODPAS,VALATE"      
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDWJ)
	While (cAliasDWJ)->(!Eof())
		If (cAliasDWJ)->ORIGEM == "2"
			If (AllTrim((cAliasDWJ)->CODPAS) $ cCompFaiPri)        
				Aadd(aCab,{Alltrim((cAliasDWJ)->CODPAS),(cAliasDWJ)->VALATE,0,(cAliasDWJ)->INTERV,cTabFrePri,cTipTabPri,!Empty(cNumPri)})			
			ElseIf (Left(AllTrim((cAliasDWJ)->CODPAS),2)  == "MN") 
				Aadd(aCab,{"MN",(cAliasDWJ)->VALATE,0,(cAliasDWJ)->INTERV,cTabFrePri,cTipTabPri,!Empty(cNumPri)})
			EndIf
		Else
			If AllTrim((cAliasDWJ)->CODPAS) $ cCompFai 
				Aadd(aCab,{Alltrim((cAliasDWJ)->CODPAS),(cAliasDWJ)->VALATE,0,(cAliasDWJ)->INTERV,cTabFre,cTipTab,!Empty(cNumPri)})
			ElseIf (Left(AllTrim((cAliasDWJ)->CODPAS),2)  == "MN")
				Aadd(aCab,{"MN",(cAliasDWJ)->VALATE,0,(cAliasDWJ)->INTERV,cTabFre,cTipTab,!Empty(cNumPri)})
			EndIf
		EndIf
		(cAliasDWJ)->(DbSkip())
	EndDo
	(cAliasDWJ)->(DbCloseArea())
	
	(cAliasDWI)->(DbGotop())
	While (cAliasDWI)->(!Eof())
	
		//-- Verifica se o estado j· foi impresso.
	   If Ascan( aEstado, { |x| x == AllTrim(Posicione("DUY",1,xFilial("DUY")+(cAliasDWI)->DWI_CDRDES,"DUY_EST")) } ) <> 0	  
			(cAliasDWI)->(DbSkip())
			Loop
		EndIf
	
		cQuery := " SELECT DUY_EST, DUY_DESCRI, DUY_GRPVEN, "
		cQuery += " 		 DWJ_CDRORI,DWJ_CDRDES,DWJ_CODPRO,DWJ_SERVIC, "
		cQuery += " 		 DWJ_RGOTAB,DWJ_RGDTAB,DWJ_PRDTAB,DWJ_CODPAS,DWJ_ITEM, "
		cQuery += " 		 DWJ_PERAJU,DWJ_VALATE,DWJ_INTERV, '1' ORIGEM, 0 VALMIN "
		cQuery += " FROM "
		cQuery += RetSqlName("DWJ")+" DWJ, "
		cQuery += RetSqlName("DUY")+" DUY "
		cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
		cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
		cQuery += "    AND DWJ_NUMPRO = '"+cNumPro+"'"
		cQuery += "    AND DWJ_CODPAS IN ( " +cCompImp+ " )"
		cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
		cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
		cQuery += "    AND DWJ_PERAJU <> 0 "
		cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
		cQuery += "    AND DUY_FILIAL = '"+xFilial("DUY")+"'"
		If cTipFre == "1" //-- CIF
			cQuery += " AND DUY_GRPVEN = DWJ_CDRDES"
			cQuery += " AND DUY.D_E_L_E_T_ = ' '"
		Else
			cQuery += " AND DUY_GRPVEN = DWJ_CDRORI"
			cQuery += " AND DUY.D_E_L_E_T_ = ' '"
		EndIf
		If lMin
			cQuery += " UNION ALL "
			cQuery += " SELECT DUY_EST, DUY_DESCRI, DUY_GRPVEN, "
			cQuery += " 		 DWJ_CDRORI,DWJ_CDRDES,DWJ_CODPRO,DWJ_SERVIC, "
			cQuery += " 		 DWJ_RGOTAB,DWJ_RGDTAB,DWJ_PRDTAB,'MN' DWJ_CODPAS,DWJ_ITEM, "
			cQuery += " 		 DWJ_PERAJU,DWJ_VALATE,DWJ_INTERV, '1' ORIGEM, (DWK_PERMIN * (DTK_VALMIN/100)) VALMIN"
			cQuery += " FROM "
			cQuery += RetSqlName("DWJ")+" DWJ, "
			cQuery += RetSqlName("DUY")+" DUY, "
			cQuery += RetSqlName("DTK")+" DTK, "
			cQuery += RetSqlName("DWK")+" DWK "
			cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
			cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
			cQuery += "    AND DWJ_NUMPRO = '"+cNumPro+"'"
			cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
			cQuery += "    AND DWJ_CODPAS IN ( " +cCompMin+ " )"
			cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
			cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
			cQuery += "    AND DWJ_PERAJU <> 0 "
			cQuery += "    AND DUY_FILIAL = '"+xFilial("DUY")+"'"
			If cTipFre == "1" //-- CIF
				cQuery += " AND DUY_GRPVEN = DWJ_CDRDES"
				cQuery += " AND DUY.D_E_L_E_T_ = ' '"
			Else
				cQuery += " AND DUY_GRPVEN = DWJ_CDRORI"
				cQuery += " AND DUY.D_E_L_E_T_ = ' '"
			EndIf
			cQuery += "  AND DWK.DWK_FILIAL = DWJ.DWJ_FILIAL "
			cQuery += "  AND DWK.DWK_FILORI = DWJ.DWJ_FILORI "
			cQuery += "  AND DWK.DWK_NUMPRO = DWJ.DWJ_NUMPRO "
			cQuery += "  AND DWK.DWK_CDRORI = DWJ.DWJ_CDRORI "
			cQuery += "  AND DWK.DWK_CDRDES = DWJ.DWJ_CDRDES "
			cQuery += "  AND DWK.DWK_CODPAS = DWJ.DWJ_CODPAS "
			cQuery += "  AND DWK.D_E_L_E_T_ = ' ' "
			cQuery += "  AND DTK.DTK_FILIAL = DWJ.DWJ_FILIAL "
			cQuery += "  AND DTK.DTK_TABFRE = '"+cTabFre+"'"
			cQuery += "  AND DTK.DTK_TIPTAB = '"+cTipTab+"'"
			cQuery += "  AND DTK.DTK_CDRORI = DWJ.DWJ_CDRORI "
			cQuery += "  AND DTK.DTK_CDRDES = DWJ.DWJ_CDRDES "
			cQuery += "  AND DTK.DTK_CODPRO = DWJ.DWJ_CODPRO "
			cQuery += "  AND DTK.DTK_CODPAS = DWJ.DWJ_CODPAS "
			cQuery += "  AND DTK.D_E_L_E_T_ = ' ' "
			If !lReajuste
				cQuery += " UNION ALL "
				cQuery += " SELECT DUY_EST, DUY_DESCRI, DUY_GRPVEN, "
				cQuery += " 		 DWJ_CDRORI,DWJ_CDRDES,DWJ_CODPRO,DWJ_SERVIC, "
				cQuery += " 		 DWJ_RGOTAB,DWJ_RGDTAB,DWJ_PRDTAB,'MN' DWJ_CODPAS,DWJ_ITEM, "
				cQuery += " 		 DWJ_PERAJU,DWJ_VALATE,DWJ_INTERV, '1' ORIGEM, DWD_VALMIN VALMIN "
				cQuery += " FROM "
				cQuery += RetSqlName("DWJ")+" DWJ, "
				cQuery += RetSqlName("DUY")+" DUY, "
				cQuery += RetSqlName("DWD")+" DWD "
				cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
				cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
				cQuery += "    AND DWJ_NUMPRO = '"+cNumPro+"'"
				cQuery += "    AND DWJ_CODPAS IN ( " +cCompMin+ " )"
				cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
				cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
				cQuery += "    AND DWJ_PERAJU <> 0 "
				cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
				cQuery += "    AND DUY_FILIAL = '"+xFilial("DUY")+"'"
				If cTipFre == "1" //-- CIF
					cQuery += " AND DUY_GRPVEN = DWJ_CDRDES"
					cQuery += " AND DUY.D_E_L_E_T_ = ' '"
				Else
					cQuery += " AND DUY_GRPVEN = DWJ_CDRORI"
					cQuery += " AND DUY.D_E_L_E_T_ = ' '"
				EndIf
				cQuery += " 	AND DWD_FILIAL = '"+xFilial("DWD")+"'"
				cQuery += " 	AND DWD_FILORI = DWJ_FILORI "						
				cQuery += " 	AND DWD_NUMPRO = DWJ_NUMPRO "
				cQuery += " 	AND DWD_CODPAS = DWJ_CODPAS "
				cQuery += " 	AND DWD_CODREG = DUY_GRPVEN "
				cQuery += "    AND DWD_VALMIN > 0 "
				cQuery += " 	AND DWD.D_E_L_E_T_ = ' ' "
				
				cQuery += " UNION ALL "
				cQuery += " SELECT DUY_EST, DUY_DESCRI, DUY_GRPVEN, "
				cQuery += " 		 DWJ_CDRORI,DWJ_CDRDES,DWJ_CODPRO,DWJ_SERVIC, "
				cQuery += " 		 DWJ_RGOTAB,DWJ_RGDTAB,DWJ_PRDTAB,'MN' DWJ_CODPAS,DWJ_ITEM, "
				cQuery += " 		 DWJ_PERAJU,DWJ_VALATE,DWJ_INTERV, '1' ORIGEM, DWA_VALMIN  VALMIN"
				cQuery += " FROM "
				cQuery += RetSqlName("DWJ")+" DWJ, "
				cQuery += RetSqlName("DUY")+" DUY, "
				cQuery += RetSqlName("DWA")+" DWA  "
				cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
				cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
				cQuery += "    AND DWJ_NUMPRO = '"+cNumPro+"'"
				cQuery += "    AND DWJ_CODPAS IN ( " +cCompMin+ " )"
				cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
				cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
				cQuery += "    AND DWJ_PERAJU <> 0 "
				cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
				cQuery += "    AND DUY_FILIAL = '"+xFilial("DUY")+"'"
				If cTipFre == "1" //-- CIF
					cQuery += " AND DUY_GRPVEN = DWJ_CDRDES"
					cQuery += " AND DUY.D_E_L_E_T_ = ' '"
				Else
					cQuery += " AND DUY_GRPVEN = DWJ_CDRORI"
					cQuery += " AND DUY.D_E_L_E_T_ = ' '"
				EndIf
				cQuery += " 	AND DWA_FILIAL = '"+xFilial("DWA")+"'"
				cQuery += " 	AND DWA_FILORI = DWJ_FILORI "			
				cQuery += " 	AND DWA_NUMPRO = DWJ_NUMPRO "
				cQuery += " 	AND DWA_CODPAS = DWJ_CODPAS "
				cQuery += "    AND DWA_VALMIN > 0 "
				cQuery += " 	AND DWA.D_E_L_E_T_ = ' ' "    
			EndIf
		EndIf
		If !Empty(cNumPri)
			cQuery += " UNION ALL "
			cQuery += " SELECT DUY_EST, DUY_DESCRI, DUY_GRPVEN, "
			cQuery += " 		 DWJ_CDRORI,DWJ_CDRDES,DWJ_CODPRO,DWJ_SERVIC, "
			cQuery += " 		 DWJ_RGOTAB,DWJ_RGDTAB,DWJ_PRDTAB,DWJ_CODPAS,DWJ_ITEM, "
			cQuery += " 		 DWJ_PERAJU,DWJ_VALATE,DWJ_INTERV, '2' ORIGEM, 0 VALMIN "
			cQuery += " FROM "
			cQuery += RetSqlName("DWJ")+" DWJ, "
			cQuery += RetSqlName("DUY")+" DUY "
			cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
			cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
			cQuery += "    AND DWJ_NUMPRO = '"+cNumPri+"'"
			cQuery += "    AND DWJ_CODPAS IN ( " +cCompPri+ " )"
			cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
			cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
			cQuery += "    AND DWJ_PERAJU <> 0 "
			cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
			cQuery += "    AND DUY_FILIAL = '"+xFilial("DUY")+"'"
			If cTipFre == "1" //-- CIF
				cQuery += " AND DUY_GRPVEN = DWJ_CDRDES"
				cQuery += " AND DUY.D_E_L_E_T_ = ' '"
			Else
				cQuery += " AND DUY_GRPVEN = DWJ_CDRORI"
				cQuery += " AND DUY.D_E_L_E_T_ = ' '"
			EndIf
			If lMinPri			
				cQuery += " UNION ALL "
				cQuery += " SELECT DUY_EST, DUY_DESCRI, DUY_GRPVEN, "
				cQuery += " 		 DWJ_CDRORI,DWJ_CDRDES,DWJ_CODPRO,DWJ_SERVIC, "
				cQuery += " 		 DWJ_RGOTAB,DWJ_RGDTAB,DWJ_PRDTAB,'MN' DWJ_CODPAS,DWJ_ITEM, "
				cQuery += " 		 DWJ_PERAJU,DWJ_VALATE,DWJ_INTERV, '2' ORIGEM, (DWK_PERMIN * (DTK_VALMIN/100)) VALMIN"
				cQuery += " FROM "
				cQuery += RetSqlName("DWJ")+" DWJ, "
				cQuery += RetSqlName("DUY")+" DUY, "
				cQuery += RetSqlName("DTK")+" DTK, "
				cQuery += RetSqlName("DWK")+" DWK "
				cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
				cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
				cQuery += "    AND DWJ_NUMPRO = '"+cNumPri+"'"
				cQuery += "    AND DWJ_CODPAS IN ( " +cCompPrMin+ " )"
				cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
				cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
				cQuery += "    AND DWJ_PERAJU <> 0 "
				cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
				cQuery += "    AND DUY_FILIAL = '"+xFilial("DUY")+"'"
				If cTipFre == "1" //-- CIF
					cQuery += " AND DUY_GRPVEN = DWJ_CDRDES"
					cQuery += " AND DUY.D_E_L_E_T_ = ' '"
				Else
					cQuery += " AND DUY_GRPVEN = DWJ_CDRORI"
					cQuery += " AND DUY.D_E_L_E_T_ = ' '"
				EndIf
				cQuery += "  AND DWK.DWK_FILIAL = DWJ.DWJ_FILIAL "
				cQuery += "  AND DWK.DWK_FILORI = DWJ.DWJ_FILORI "
				cQuery += "  AND DWK.DWK_NUMPRO = DWJ.DWJ_NUMPRO "
				cQuery += "  AND DWK.DWK_CDRORI = DWJ.DWJ_CDRORI "
				cQuery += "  AND DWK.DWK_CDRDES = DWJ.DWJ_CDRDES "
				cQuery += "  AND DWK.DWK_CODPAS = DWJ.DWJ_CODPAS "
				cQuery += "  AND DWK.D_E_L_E_T_ = ' ' "
				cQuery += "  AND DTK.DTK_FILIAL = DWJ.DWJ_FILIAL "
				cQuery += "  AND DTK.DTK_TABFRE = '"+cTabFrePri+"'"
				cQuery += "  AND DTK.DTK_TIPTAB = '"+cTipTabPri+"'"
				cQuery += "  AND DTK.DTK_CDRORI = DWJ.DWJ_CDRORI "
				cQuery += "  AND DTK.DTK_CDRDES = DWJ.DWJ_CDRDES "
				cQuery += "  AND DTK.DTK_CODPRO = DWJ.DWJ_CODPRO "
				cQuery += "  AND DTK.DTK_CODPAS = DWJ.DWJ_CODPAS "
				cQuery += "  AND DTK.D_E_L_E_T_ = ' ' "
				If !lReajuste 
					cQuery += " UNION ALL "
					cQuery += " SELECT DUY_EST, DUY_DESCRI, DUY_GRPVEN, "
					cQuery += " 		 DWJ_CDRORI,DWJ_CDRDES,DWJ_CODPRO,DWJ_SERVIC, "
					cQuery += " 		 DWJ_RGOTAB,DWJ_RGDTAB,DWJ_PRDTAB,'MN' DWJ_CODPAS,DWJ_ITEM, "
					cQuery += " 		 DWJ_PERAJU,DWJ_VALATE,DWJ_INTERV, '2' ORIGEM, DWD_VALMIN VALMIN"
					cQuery += " FROM "
					cQuery += RetSqlName("DWJ")+" DWJ, "
					cQuery += RetSqlName("DUY")+" DUY, "
					cQuery += RetSqlName("DWD")+" DWD "
					cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
					cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
					cQuery += "    AND DWJ_NUMPRO = '"+cNumPri+"'"
					cQuery += "    AND DWJ_CODPAS IN ( " +cCompPrMin+ " )"
					cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
					cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
					cQuery += "    AND DWJ_PERAJU <> 0 "
					cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
					cQuery += "    AND DUY_FILIAL = '"+xFilial("DUY")+"'"
					If cTipFre == "1" //-- CIF
						cQuery += " AND DUY_GRPVEN = DWJ_CDRDES"
						cQuery += " AND DUY.D_E_L_E_T_ = ' '"
					Else
						cQuery += " AND DUY_GRPVEN = DWJ_CDRORI"
						cQuery += " AND DUY.D_E_L_E_T_ = ' '"
					EndIf
					cQuery += " 	AND DWD_FILIAL = '"+xFilial("DWD")+"'"
					cQuery += " 	AND DWD_FILORI = DWJ_FILORI "					
					cQuery += " 	AND DWD_NUMPRO = DWJ_NUMPRO "
					cQuery += " 	AND DWD_CODPAS = DWJ_CODPAS "
					cQuery += " 	AND DWD_CODREG = DUY_GRPVEN "
					cQuery += "    AND DWD_VALMIN > 0 "
					cQuery += " 	AND DWD.D_E_L_E_T_ = ' ' "
					cQuery += " UNION ALL "
					cQuery += " SELECT DUY_EST, DUY_DESCRI, DUY_GRPVEN, "
					cQuery += " 		 DWJ_CDRORI,DWJ_CDRDES,DWJ_CODPRO,DWJ_SERVIC, "
					cQuery += " 		 DWJ_RGOTAB,DWJ_RGDTAB,DWJ_PRDTAB,'MN' DWJ_CODPAS,DWJ_ITEM, "
					cQuery += " 		 DWJ_PERAJU,DWJ_VALATE,DWJ_INTERV, '2' ORIGEM, DWA_VALMIN  VALMIN"
					cQuery += " FROM "
					cQuery += RetSqlName("DWJ")+" DWJ, "
					cQuery += RetSqlName("DUY")+" DUY, "
					cQuery += RetSqlName("DWA")+" DWA  "
					cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
					cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
					cQuery += "    AND DWJ_NUMPRO = '"+cNumPri+"'"
					cQuery += "    AND DWJ_CODPAS IN ( " +cCompPrMin+ " )"
					cQuery += "    AND DWJ_CDRORI IN ( " +cSqlOri + " )"
					cQuery += "    AND DWJ_CDRDES IN ( " +cSqlDes + " )"
					cQuery += "    AND DWJ_PERAJU <> 0 "
					cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
					cQuery += "    AND DUY_FILIAL = '"+xFilial("DUY")+"'"
					If cTipFre == "1" //-- CIF
						cQuery += " AND DUY_GRPVEN = DWJ_CDRDES"
						cQuery += " AND DUY.D_E_L_E_T_ = ' '"
					Else
						cQuery += " AND DUY_GRPVEN = DWJ_CDRORI"
						cQuery += " AND DUY.D_E_L_E_T_ = ' '"
					EndIf
					cQuery += " 	AND DWA_FILIAL = '"+xFilial("DWA")+"'"
					cQuery += " 	AND DWA_FILORI = DWJ_FILORI "					
					cQuery += " 	AND DWA_NUMPRO = DWJ_NUMPRO "
					cQuery += " 	AND DWA_CODPAS = DWJ_CODPAS "
					cQuery += "    AND DWA_VALMIN > 0 "
					cQuery += " 	AND DWA.D_E_L_E_T_ = ' ' "
				EndIf
			EndIf
			
		EndIf
		If cTipFre == "1" //-- CIF
			cQuery += " ORDER BY DUY_EST,DWJ_CDRORI,DWJ_CDRDES,ORIGEM,DWJ_CODPAS,DWJ_ITEM"
		Else
			cQuery += " ORDER BY DUY_EST,DWJ_CDRDES,DWJ_CDRORI,ORIGEM,DWJ_CODPAS,DWJ_ITEM"
		EndIf
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDWJ)
		For nX := 1 To Len(aStruDWJ)
			If aStruDWJ[nX][2]<>"C" 
				TcSetField(cAliasDWJ,aStruDWJ[nX][1],aStruDWJ[nX][2],aStruDWJ[nX][3],aStruDWJ[nX][4])
			EndIf
		Next nX                     
		TcSetField(cAliasDWJ,"VALMIN","N",TamSX3("DWD_VALMIN")[1],TamSX3("DWD_VALMIN")[2])
		While (cAliasDWJ)->(!Eof())
			cCdrOri  := (cAliasDWJ)->DWJ_CDRORI
			cCdrDes  := (cAliasDWJ)->DWJ_CDRDES
			cCodPro  := (cAliasDWJ)->DWJ_CODPRO
			cServic  := (cAliasDWJ)->DWJ_SERVIC
			cEst     := (cAliasDWJ)->DUY_EST
			cRegiao  := (cAliasDWJ)->DUY_DESCRI
			cRegPri  := (cAliasDWJ)->DUY_GRPVEN
			aCompImp := {}
			aCompFai := {}
			cCompEstPri := ""
			cCompEst    := ""
			While (cAliasDWJ)->(!Eof()) .And. (cAliasDWJ)->(DWJ_CDRORI+DWJ_CDRDES+DWJ_CODPRO+DWJ_SERVIC) == cCdrOri+cCdrdes+cCodPro+cServic
				nPrcTab := 0
				If (cAliasDWJ)->ORIGEM == "2"
					cTab := cTabFrePri
					cTip := cTipTabPri
				Else
					cTab := cTabFre
					cTip := cTipTab
				EndIf
				DT1->(dbSetOrder(1))
				If DT1->(MsSeek(xFilial("DT1")+cTab+cTip+(cAliasDWJ)->(DWJ_RGOTAB+DWJ_RGDTAB+DWJ_PRDTAB+DWJ_CODPAS+DWJ_ITEM)))
					nPrcTab := DT1->DT1_VALOR
				Else
					DT0->(dbSetOrder(1))
					DT0->(MsSeek(xFilial("DT0")+cTab+cTip+(cAliasDWJ)->(DWJ_RGOTAB+DWJ_RGDTAB+DWJ_PRDTAB)))
					DTG->(dbSetOrder(1))
					DTG->(MsSeek(xFilial("DTG")+cTab+cTip+DT0->DT0_TABTAR+(cAliasDWJ)->(DWJ_CODPAS+DWJ_ITEM)))
					nPrcTab := DTG->DTG_VALOR
				EndIf
				nPrcAju := (nPrcTab * (cAliasDWJ)->DWJ_PERAJU) / 100

				//-- Valores por Estado
				nValMin := 0
				If Posicione("DUY",1,xFilial("DUY")+cRegPri,"DUY_CATGRP") == StrZero(1,Len(DUY->DUY_CATGRP)) //-- Estado
					If Ascan(aValorEst, { |x| x[1]+x[2] == cEst + (cAliasDWJ)->DWJ_CODPAS } ) == 0					
						If lReajuste

							If Left(AllTrim((cAliasDWJ)->DWJ_CODPAS),2)  == "MN"  
								 nValMin := (cAliasDWJ)->VALMIN
							Else
								DTK->(dbSetOrder(1))
								If DTK->(DbSeek(xFilial("DTK")+cTab+cTip+(cAliasDWJ)->(DWJ_CDRORI+DWJ_CDRDES+DWJ_CODPRO+DWJ_CODPAS)))
								   DWK->(dbSetOrder(1))
									If DWK->(DbSeek(xFilial("DWK")+cFilOri+cNumPro+(cAliasDWJ)->(DWJ_CDRORI+DWJ_CDRDES+DWJ_CODPRO+DWJ_SERVIC+DWJ_CODPAS)))								   
								   	//DWK_FILIAL+DWK_FILORI+DWK_NUMPRO+DWK_CDRORI+DWK_CDRDES+DWK_CODPRO+DWK_SERVIC+DWK_CODPAS                                                                         
										nValMin := (DWK->DWK_PERMIN * (DTK->DTK_VALMIN / 100	))
									EndIf
								EndIf								
							EndIf	
						Else
							DWA->(DbSetOrder(1))						                                        						
							If DWA->(MsSeek(xFilial("DWA")+cFilOri+cNumPro+(cAliasDWJ)->DWJ_CODPAS))   
							   If DWA->DWA_PROBRC == StrZero(2,Len(DWA->DWA_PROBRC)) //-- Nao
									nValMin := DWA->DWA_VALMIN
								Else 
									DWD->(DbSetOrder(1))						                                        						
									If DWD->(MsSeek(xFilial("DWD")+cFilOri+cNumPro+(cAliasDWJ)->DWJ_CODPAS))   							
										nValMin := DWD->DWD_VALMIN								
								   EndIf
								EndIf
							EndIf
						EndIf
						Aadd(aValorEst,{ cEst, (cAliasDWJ)->DWJ_CODPAS, nPrcAju, nValMin })
					EndIf
				EndIf

				If (!lPraca .Or. Posicione("DUY",1,xFilial("DUY")+cRegPri,"DUY_CATGRP") <> StrZero(1,Len(DUY->DUY_CATGRP)))
					If (cAliasDWJ)->ORIGEM == "2"
						If (cAliasDWJ)->DWJ_CODPAS $ cCompFaiPri .Or. Left(AllTrim((cAliasDWJ)->DWJ_CODPAS),2)  == "MN"  
							If !( (cAliasDWJ)->DWJ_CODPAS $ cCompEstPri )
								cCompEstPri += "'" + (cAliasDWJ)->DWJ_CODPAS + "',"
							EndIf
							If Left(AllTrim((cAliasDWJ)->DWJ_CODPAS),2)  == "MN"  
								Aadd(aCompFai,{ Alltrim((cAliasDWJ)->DWJ_CODPAS), (cAliasDWJ)->DWJ_VALATE, (cAliasDWJ)->VALMIN, (cAliasDWJ)->DWJ_INTERV, .F. })
							Else
								Aadd(aCompFai,{ Alltrim((cAliasDWJ)->DWJ_CODPAS), (cAliasDWJ)->DWJ_VALATE, nPrcAju, (cAliasDWJ)->DWJ_INTERV, .F. })
							EndIf
						Else
							If Left(AllTrim((cAliasDWJ)->DWJ_CODPAS),2)  == "MN"  
								Aadd(aCompImp,{ Alltrim((cAliasDWJ)->DWJ_CODPAS), 0, (cAliasDWJ)->VALMIN, (cAliasDWJ)->DWJ_INTERV })
							Else
								Aadd(aCompImp,{ Alltrim((cAliasDWJ)->DWJ_CODPAS), 0, nPrcAju, (cAliasDWJ)->DWJ_INTERV })
							EndIf
						EndIf
					Else
						If (cAliasDWJ)->DWJ_CODPAS $ cCompFai .Or. Left(AllTrim((cAliasDWJ)->DWJ_CODPAS),2)  == "MN"  
							If !( (cAliasDWJ)->DWJ_CODPAS $ cCompEst )
								cCompEst += "'" + (cAliasDWJ)->DWJ_CODPAS + "',"
							EndIf
							If Left(AllTrim((cAliasDWJ)->DWJ_CODPAS),2) == "MN"  
								Aadd(aCompFai,{ Alltrim((cAliasDWJ)->DWJ_CODPAS), (cAliasDWJ)->DWJ_VALATE, (cAliasDWJ)->VALMIN, (cAliasDWJ)->DWJ_INTERV, .F. })
							Else
								Aadd(aCompFai,{ Alltrim((cAliasDWJ)->DWJ_CODPAS), (cAliasDWJ)->DWJ_VALATE, nPrcAju, (cAliasDWJ)->DWJ_INTERV, .F. })
							EndIf
						Else
							If Left(AllTrim((cAliasDWJ)->DWJ_CODPAS),2) == "MN"  
								Aadd(aCompImp,{ Alltrim((cAliasDWJ)->DWJ_CODPAS), 0, (cAliasDWJ)->VALMIN, (cAliasDWJ)->DWJ_INTERV })
							Else
								Aadd(aCompImp,{ Alltrim((cAliasDWJ)->DWJ_CODPAS), 0, nPrcAju, (cAliasDWJ)->DWJ_INTERV })
							EndIf
						EndIf		
					EndIf
				EndIf
				(cAliasDWJ)->(dbSkip())
			EndDo
			
			
			//-- Componentes por estado
			cCompEst := SubStr(cCompEst,1,Len(cCompEst)-1)
			If !Empty(cCompEst)
				cCompEstPri := SubStr(cCompEstPri,1,Len(cCompEstPri)-1)
				If Empty(cCompEstPri)
					cCompEstPri := "' '"
				EndIf			
				cEstOri := Posicione("DUY",1,xFilial("DUY")+cCdrOri,"DUY_EST")
				cEstDes := Posicione("DUY",1,xFilial("DUY")+cCdrDes,"DUY_EST")
								
				cQuery := " SELECT DUY_EST, DUY_DESCRI, DUY_GRPVEN, "
				cQuery += " 		 DWJ_CDRORI,DWJ_CDRDES,DWJ_CODPRO,DWJ_SERVIC, "
				cQuery += " 		 DWJ_RGOTAB,DWJ_RGDTAB,DWJ_PRDTAB,DWJ_CODPAS,DWJ_ITEM, "
				cQuery += " 		 DWJ_PERAJU,DWJ_VALATE,DWJ_INTERV, '1' ORIGEM, 0 VALMIN "
				cQuery += " FROM "
				cQuery += RetSqlName("DWJ")+" DWJ, "
				cQuery += RetSqlName("DUY")+" DUY "
				cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
				cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
				cQuery += "    AND DWJ_NUMPRO = '"+cNumPro+"'"
				cQuery += "    AND DWJ_CODPAS IN ( " +cCompImp+ " )"
				cQuery += "    AND DWJ_CODPAS NOT IN ( " +cCompEst+ " )"
				cQuery += "    AND DWJ_CDRORI = '" +cEstOri+ "' "
				cQuery += "    AND DWJ_CDRDES = '" +cEstDes+ "' "
				cQuery += "    AND DWJ_PERAJU <> 0 "
				cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
				cQuery += "    AND DUY_FILIAL = '"+xFilial("DUY")+"'"
				cQuery += "    AND DUY_CATGRP = '1' "
				If cTipFre == "1" //-- CIF
					cQuery += " AND DUY_GRPVEN = DWJ_CDRDES"
					cQuery += " AND DUY.D_E_L_E_T_ = ' '"
				Else
					cQuery += " AND DUY_GRPVEN = DWJ_CDRORI"
					cQuery += " AND DUY.D_E_L_E_T_ = ' '"
				EndIf	
				If !Empty(cNumPri)
					cQuery += " UNION ALL "
					cQuery += " SELECT DUY_EST, DUY_DESCRI, DUY_GRPVEN, "
					cQuery += " 		 DWJ_CDRORI,DWJ_CDRDES,DWJ_CODPRO,DWJ_SERVIC, "
					cQuery += " 		 DWJ_RGOTAB,DWJ_RGDTAB,DWJ_PRDTAB,DWJ_CODPAS,DWJ_ITEM, "
					cQuery += " 		 DWJ_PERAJU,DWJ_VALATE,DWJ_INTERV, '2' ORIGEM, 0 VALMIN"
					cQuery += " FROM "
					cQuery += RetSqlName("DWJ")+" DWJ, "
					cQuery += RetSqlName("DUY")+" DUY "
					cQuery += "  WHERE DWJ_FILIAL = '"+xFilial("DWJ")+"'"
					cQuery += "    AND DWJ_FILORI = '"+cFilOri+"'"
					cQuery += "    AND DWJ_NUMPRO = '"+cNumPri+"'"
					cQuery += "    AND DWJ_CODPAS IN ( " +cCompPri+ " )"
					cQuery += "    AND DWJ_CODPAS NOT IN ( " +cCompEstPri+ " )"
					cQuery += "    AND DWJ_CDRORI = '" +cEstOri+ "' "
					cQuery += "    AND DWJ_CDRDES = '" +cEstDes+ "' "
					cQuery += "    AND DWJ_PERAJU <> 0 "
					cQuery += "    AND DWJ.D_E_L_E_T_ = ' '"
					cQuery += "    AND DUY_FILIAL = '"+xFilial("DUY")+"'"
					cQuery += "    AND DUY_CATGRP = '1' "
					If cTipFre == "1" //-- CIF
						cQuery += " AND DUY_GRPVEN = DWJ_CDRDES"
						cQuery += " AND DUY.D_E_L_E_T_ = ' '"
					Else
						cQuery += " AND DUY_GRPVEN = DWJ_CDRORI"
						cQuery += " AND DUY.D_E_L_E_T_ = ' '"
					EndIf	
				EndIf
				If cTipFre == "1" //-- CIF
					cQuery += " ORDER BY DUY_EST,DWJ_CDRORI,DWJ_CDRDES,ORIGEM,DWJ_CODPAS,DWJ_ITEM"
				Else
					cQuery += " ORDER BY DUY_EST,DWJ_CDRDES,DWJ_CDRORI,ORIGEM,DWJ_CODPAS,DWJ_ITEM"
				EndIf	
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
				For nX := 1 To Len(aStruDWJ)
					If aStruDWJ[nX][2]<>"C"
						TcSetField(cAliasQry,aStruDWJ[nX][1],aStruDWJ[nX][2],aStruDWJ[nX][3],aStruDWJ[nX][4])
					EndIf
				Next nX                      
				TcSetField(cAliasDWJ,"VALMIN","N",TamSX3("DWD_VALMIN")[1],TamSX3("DWD_VALMIN")[2])
				While (cAliasQry)->(!Eof())
					nPrcTab := 0
					If (cAliasQry)->ORIGEM == "2"
						cTab := cTabFrePri
						cTip := cTipTabPri
					Else
						cTab := cTabFre
						cTip := cTipTab
					EndIf
					DT1->(dbSetOrder(1))
					If DT1->(MsSeek(xFilial("DT1")+cTab+cTip+(cAliasQry)->(DWJ_RGOTAB+DWJ_RGDTAB+DWJ_PRDTAB+DWJ_CODPAS+DWJ_ITEM)))
						nPrcTab := DT1->DT1_VALOR
					Else
						DT0->(dbSetOrder(1))
						DT0->(MsSeek(xFilial("DT0")+cTab+cTip+(cAliasQry)->(DWJ_RGOTAB+DWJ_RGDTAB+DWJ_PRDTAB)))
						DTG->(dbSetOrder(1))
						DTG->(MsSeek(xFilial("DTG")+cTab+cTip+DT0->DT0_TABTAR+(cAliasQry)->(DWJ_CODPAS+DWJ_ITEM)))
						nPrcTab := DTG->DTG_VALOR
					EndIf
					nPrcAju := (nPrcTab * (cAliasQry)->DWJ_PERAJU) / 100
					If (cAliasQry)->ORIGEM == "2"
						If (cAliasQry)->DWJ_CODPAS $ cCompFaiPri
							If Ascan( aCompFai, { |x| x[1]+Alltrim(Str(x[2])) == (cAliasQry)->DWJ_CODPAS + AllTrim(Str((cAliasQry)->DWJ_VALATE)) } ) == 0
								Aadd(aCompFai,{ Alltrim((cAliasQry)->DWJ_CODPAS), (cAliasQry)->DWJ_VALATE, nPrcAju, (cAliasQry)->DWJ_INTERV, .F. })
							EndIf
						Else
							If Ascan( aCompImp, { |x| x[1] == (cAliasQry)->DWJ_CODPAS } ) == 0
								Aadd(aCompImp,{ Alltrim((cAliasQry)->DWJ_CODPAS), 0, nPrcAju, (cAliasQry)->DWJ_INTERV })
							EndIf
						EndIf
					Else
						If (cAliasQry)->DWJ_CODPAS $ cCompFai
							If Ascan( aCompFai, { |x| x[1]+Alltrim(Str(x[2])) == (cAliasQry)->DWJ_CODPAS + AllTrim(Str((cAliasQry)->DWJ_VALATE)) } ) == 0
								Aadd(aCompFai,{ Alltrim((cAliasQry)->DWJ_CODPAS), (cAliasQry)->DWJ_VALATE, nPrcAju, (cAliasQry)->DWJ_INTERV, .F. })
							EndIf
						Else
							If Ascan( aCompImp, { |x| x[1] == (cAliasQry)->DWJ_CODPAS } ) == 0
								Aadd(aCompImp,{ Alltrim((cAliasQry)->DWJ_CODPAS), 0, nPrcAju, (cAliasQry)->DWJ_INTERV })
							EndIf
						EndIf
					EndIf
					(cAliasQry)->(DbSkip())
				EndDo
				(cAliasQry)->(DbCloseArea())
			EndIf
			

			If (Len(aCompFai) > 0 .Or. Len(aCompImp) > 0) .And. Posicione("DUY",1,xFilial("DUY")+cRegPri,"DUY_CATGRP") <> "1"
	         DWM->(DbSetOrder(1))
				If DWM->(MsSeek(xFilial("DWM")+cEst+cRegPri))
					cOrdem := DWM->DWM_PRIORI
				Else
					cOrdem := Replicate("9",Len(DWM->DWM_PRIORI))
				EndIf
				If cTipFre == '3' //-- CIF/FOB
					cRegOri := Posicione('DUY',1,xFilial('DUY')+(cAliasDWI)->DWI_CDRORI,'DUY_DESCRI')
					cRegDes := Posicione('DUY',1,xFilial('DUY')+(cAliasDWI)->DWI_CDRDES,'DUY_DESCRI')
					If Ascan( aItensPro, { |x| x[1]+x[2] == cRegOri+cRegDes } ) == 0 
						Aadd(aItensPro,{ cRegOri, cRegDes, AClone(aCompFai), AClone(aCompImp), AClone(aCab), cOrdem })
					EndIf
				Else
					If Ascan( aItensPro, { |x| x[1]+x[2] == cEst + cRegiao } ) == 0 
						Aadd(aItensPro,{ cEst, cRegiao, AClone(aCompFai), AClone(aCompImp), AClone(aCab), cOrdem })
						//-- Armazena o estado da regiao
						If Ascan( aEstado, { |x| x == cEst } ) == 0
							aAdd( aEstado, cEst )
						EndIf
					EndIf
				EndIf					
			EndIf
		EndDo
		(cAliasDWJ)->(dbCloseArea())
		(cAliasDWI)->(	DbSkip())
	EndDo
	
	//-- Ordena por estado e regiao
	aItensPro := ASort( aItensPro,,,{|x,y| x[1]+x[6]+x[2] < y[1]+y[6]+y[2] })
EndIf

Return aItensPro


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥RTMSR14Cab≥ Autor ≥ Eduardo de Souza      ≥ Data ≥16-03-2006≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Funcao de impressao do Cabecario                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥RTMSR14Cab()                                                ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function RTMSR14Cab(oPrint,aItensPro)

Local lCliente := !Empty(DW7->DW7_CODCLI)
Local cTipFre  := DW7->DW7_TIPFRE
Local cCodReg  := Iif(cTipFre == "1",DW7->DW7_CDRORI,DW7->DW7_CDRDES)
Local cContato := ""
Local cTel     := ""
Local cFax     := ""
Local cEnd     := ""
Local cMun     := ""
Local cEst     := ""
Local cCEP     := ""
Local cMail    := ""
Local cCod     := ""
Local cLoja    := ""
Local nIniCell := 0
Local nTotBox  := 0
Local cCodPas  := ""
Local cDesPas  := ""
Local lTemFai  := .F.
Local lPerFai  := .F.
Local cDesFai  := ""
Local nX       := 0
Local lAcima   := .F.
Local cNome    := ""
Local cCNPJ    := ""
Local cIE      := ""
Local cDepto   := ""
Local cTabOld  := ""
Local cTipOld  := ""
Local nTotCab  := 0
Local aAreaSM0 := SM0->(GetArea())
Local cDesFTit	:= ""
Local cTabFrePri:= ""
Local cTipTabPri:= ""


If !Empty(aItensPro)
	If lCliente
		SA1->(dbSetOrder(1))
		SA1->(MsSeek(xFilial("SA1")+DW7->DW7_CODCLI+DW7->DW7_LOJCLI))
		cNome    := SA1->A1_NOME
		cCNPJ    := SA1->A1_CGC
		cIE      := SA1->A1_INSCR
		cContato := SA1->A1_CONTATO
		cTel     := AllTrim(SA1->A1_DDD)+" "+SA1->A1_TEL
		cFax     := SA1->A1_FAX
		cEnd     := SA1->A1_END
		cMun     := SA1->A1_MUN
		cEst     := SA1->A1_EST
		cCEP     := SA1->A1_CEP
		cMail    := SA1->A1_EMAIL
	Else
		SUS->(DbSetOrder(1))
		cCod  := Left(DW7->DW7_NUMPRO+Space(Len(SUS->US_COD )),Len(SUS->US_COD ))
		cLoja := Left(DW7->DW7_FILORI+Space(Len(SUS->US_LOJA)),Len(SUS->US_LOJA))
		SUS->(MsSeek(xFilial("SUS")+cCod+cLoja))
		cNome    := SUS->US_NOME
		cCNPJ    := SUS->US_CGC
		cIE      := SUS->US_INSCR
		cContato := SUS->US_CONTATO
		cDepto   := SUS->US_DEPTO
		cTel     := AllTrim(SUS->US_DDD)+" "+SUS->US_TEL
		cFax     := SUS->US_FAX
		cEnd     := SUS->US_END
		cMun     := SUS->US_MUN
		cEst     := SUS->US_EST
		cCEP     := SUS->US_CEP
		cMail    := SUS->US_EMAIL
	EndIf	
	
	PcoPrtCab(oPrint,4,cFileLogo)
	nLin  := 200

	PcoPrtCol({20,800,1600,2000},.T.,1)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,cNome,oPrint,4,2,/*RgbColor*/,STR0002) // 'Raz„o Social'
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,Transform(cCNPJ,"@R 99.999.999/9999-99"),oPrint,4,2,/*RgbColor*/,STR0003) // 'CNPJ'
	PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),60,cIE,oPrint,4,2,/*RgbColor*/,STR0004) // 'InscriÁ„o Estadual'
	nLin+=60

	If cTipFre == "1"
		PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,Alltrim(Posicione("SM0",1,cEmpAnt+DW7->DW7_FILORI,"M0_FILIAL"))+"("+SM0->M0_ESTCOB+")",oPrint,4,2,/*RgbColor*/,"Filial Emitente") 
		PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,DW7->DW7_FILORI+" "+DW7->DW7_NUMPRO,oPrint,4,2,/*RgbColor*/,STR0007) // 'No. Proposta'
		PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),60,DtoC(DW7->DW7_DATA),oPrint,4,2,/*RgbColor*/,"Data")
		RestArea(aAreaSM0)
	Else
		PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,cContato,oPrint,4,2,/*RgbColor*/,STR0005) // 'Contato'
		PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,cDepto,oPrint,4,2,/*RgbColor*/,STR0006) // 'Depto/Setor'
		PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),60,DW7->DW7_FILORI+" "+DW7->DW7_NUMPRO,oPrint,4,2,/*RgbColor*/,STR0007) // 'No. Proposta'
		nLin+=60
		PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,cTel,oPrint,4,2,/*RgbColor*/,STR0008) // 'Fone'
		PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,cFax,oPrint,4,2,/*RgbColor*/,STR0009) // 'Fax'
		PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),60,cMail,oPrint,4,2,/*RgbColor*/,STR0010) // 'e-mail'
		nLin+=60
		PcoPrtCol({20,800,1600,1800,2000},.T.,1)
		PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1)  ,60,cEnd,oPrint,4,2,/*RgbColor*/,STR0011) // 'EndereÁo'
		PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2)  ,60,cMun,oPrint,4,2,/*RgbColor*/,STR0012) // 'Cidade'
		PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3)  ,60,cEst,oPrint,4,2,/*RgbColor*/,STR0013) // 'Estado'
		PcoPrtCell(PcoPrtPos(4),nLin,PcoPrtTam(4)  ,60,cCep,oPrint,4,2,/*RgbColor*/,STR0014) // 'CEP'
	EndIf
	nLin+=80
	
	If cTipFre != "3" //-- CIF/FOB
		PcoPrtCol({20,2000},.T.,1)
		If cTipFre == "1" //-- CIF
			PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,STR0015 + Posicione("DUY",1,xFilial("DUY")+cCodReg,"DUY_DESCRI"),oPrint,4,2,RGB(230,230,230))
		Else
			PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,STR0016 + Posicione("DUY",1,xFilial("DUY")+cCodReg,"DUY_DESCRI"),oPrint,4,2,RGB(230,230,230))
		EndIf	
	EndIf		
	nLin+=80
	
	If cTipFre == "1" //-- CIF
		PcoPrtCol({020,070,450,2000},.T.,3)
		PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),120,STR0017,oPrint,4,2,/*RgbColor*/) // 'UF'
		PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),120,STR0019,oPrint,4,2,/*RgbColor*/) // 'Destinos'
	ElseIf cTipFre == "2" //-- FOB
		PcoPrtCol({020,070,450,2000},.T.,3)
		PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),120,STR0017,oPrint,4,2,/*RgbColor*/) // 'UF'
		PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),120,STR0018,oPrint,4,2,/*RgbColor*/) // 'Origens'
	ElseIf cTipFre == "3" //-- CIF/FOB
		PcoPrtCol({020,415,850,2000},.T.,3)
		PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),120,STR0031,oPrint,4,2,/*RgbColor*/) // 'Origem'
		PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),120,STR0032,oPrint,4,2,/*RgbColor*/) // 'Destino'
	EndIf
	
	//-- Qtde de texto no primeiro item do cabecalho
	cCodPas := aItensPro[1,5,1,1]
	For nX := 1 To Len(aItensPro[1,5])
		If cCodPas == aItensPro[1,5,nX,1]
			nTotCab ++
		Else
			Exit
		EndIf
		cCodPas := aItensPro[1,5,nX,1]
	Next nX

	nTotBox := Len(aItensPro[1,5])
	cCodPas := aItensPro[1,5,1,1]
	cTabFre := aItensPro[1,5,1,5]
	cTipTab := aItensPro[1,5,1,6]
	lNumPri := aItensPro[1,5,1,7]
	cTabFrePri:= cTabFre
	cTipTabPri:= cTipTab

	If cCodPas == "MN"
		cDesPas := 	"Frete MÌn."
		Posicione("DT3",1,xFilial("DT3")+"02","DT3_DESCRI")
	Else
		cDesPas := AllTrim(Posicione("DT3",1,xFilial("DT3")+cCodPas,"DT3_DESCRI"))
		If "FRETE PESO" $ Upper(cDesPas) .And. AllTrim(DW7->DW7_CODNEG) == "01"
			cDesPas += " ( Reais por Conhecimento ) "
		EndIf
	EndIf
	lTemFai := (aItensPro[1,5,1,2] > 0)
	lPerFai := DT3->DT3_TIPFAI == "02"
	cDesFai := ""

	//PcoPrtCell(PcoPrtPos(3),nLin,(PcoPrtTam(3)/nTotBox)*nTotCab,60,If(lNumPri .And. cTabFre+cTipTab<>cTabOld+cTipOld,"Tabela 1 - " + cDesPas,cDesPas),oPrint,4,2,/*RgbColor*/,,,,,.T.) 
	PcoPrtCell(PcoPrtPos(3),nLin,(PcoPrtTam(3)/nTotBox)*nTotCab,60,If(lNumPri ,"Tabela 1 - " + cDesPas,cDesPas),oPrint,4,2,/*RgbColor*/,,,,,.T.) 
	nLin+=60

	nIniCell := PcoPrtPos(3)
	For nX := 1 To nTotBox
		If nX > 1
			nIniCell := nIniCell + PcoPrtTam(3)/nTotBox
		EndIf
		If aItensPro[1,5,nX,1] <> cCodPas
			cCodPas := aItensPro[1,5,nX,1]
			cTabFre := aItensPro[1,5,nX,5]
			cTipTab := aItensPro[1,5,nX,6]
			lNumPri := aItensPro[1,5,nX,7]
			If cCodPas == "MN"
				cDesPas := 	"Frete MÌn."
				Posicione("DT3",1,xFilial("DT3")+"02","DT3_DESCRI")
			Else
				cDesPas := AllTrim(Posicione("DT3",1,xFilial("DT3")+cCodPas,"DT3_DESCRI"))
				If "FRETE PESO" $ Upper(cDesPas) .And. AllTrim(DW7->DW7_CODNEG) == "01"
					cDesPas += " ( Reais por Conhecimento ) " 
				EndIf
			EndIf
			lTemFai := (aItensPro[1,5,nX,2] > 0)
			lPerFai := DT3->DT3_TIPFAI == "02"
			If lPerFai
				If cCodPas == "MN"
					cDesFai := "(R$)"
				Else
					cDesFai := "(%)"
				EndIf
				lPerFai := .F.
			EndIf	
			PcoPrtCell(nIniCell,nLin-60,PcoPrtTam(3)/nTotBox,60,IIf(lNumPri,"Tabela "+Iif(cTabFre+cTipTab==cTabFrePri+cTipTabPri,"1","2")+" - "+ cDesPas,cDesPas),oPrint,4,2,/*RgbColor*/,,,,,.T.) 
		EndIf
		cTabOld := cTabFre
		cTipOld := cTipTab
		cDesFai := ""
		lAcima  := .F.
		
		If lTemFai
			If aItensPro[1,5,nX,2] >= 999999.9999
				If nX-1 > 0 .And. aItensPro[1,5,nX,1] == aItensPro[1,5,nX-1,1]				   
					lAcima  := .T.
					cDesFai := AllTrim(Transform(aItensPro[1,5,nX-1,2],"@E 99,999.99"))
				EndIf              
				cDesFTit:= ""
				If DT3->DT3_TIPFAI == "01" //-- Peso
				   If aItensPro[1,5,nX,4] == 1000   //-- Intervalo
						cDesFTit := "-R$/Ton"				  		
					ElseIF aItensPro[1,5,nX,4] == 100   //-- Intervalo	
						cDesFTit := "R$/100 Kg ou"
						cDesFai  := "FraÁ„o"
					Else	
						cDesFTit := "-R$/Kg"
					EndIf	
					
				ElseIf DT3->DT3_TIPFAI == "02"
					If cCodPas == "MN"
						cDesFai := "(R$)"
					Else
						cDesFai := "(%)"
					EndIf
				EndIf
				PcoPrtCell(nIniCell,nLin,PcoPrtTam(3)/nTotBox,60,cDesFai,oPrint,4,2,/*RgbColor*/,If(lAcima,STR0021,"")+cDesFTit,,,,.T.) // 'Acima'
			Else
				cDesFai := AllTrim(Transform(aItensPro[1,5,nX,2],"@E 99,999.99"))
				cDesFTit:= ""
				If DT3->DT3_TIPFAI == "01" //-- Peso
					cDesFTit:= "-Kg"
				ElseIf DT3->DT3_TIPFAI == "02"
					If cCodPas == "MN"
						cDesFai := "(R$)"
					Else
						cDesFai := "(%)"
					EndIf
				EndIf
				PcoPrtCell(nIniCell,nLin,PcoPrtTam(3)/nTotBox,60,cDesFai,oPrint,4,2,/*RgbColor*/,STR0020+cDesFTit,,,,.T.) // 'AtÈ'
			EndIf
		EndIf

	Next nX
EndIf
nLin+= 60

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥RTMSR14It ≥ Autor ≥ Eduardo de Souza      ≥ Data ≥16-03-2006≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Funcao de impressao dos itens                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥RTMSR14It(lEnd)                                             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ lEnd - Variavel para cancelamento da impressao pelo usuario≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function RTMSR14It(oPrint,aItensPro)

Local nX      := 0
Local nCnt    := 0
Local nCnt1   := 0
Local nTotBox := 0
Local nTamBox := 0
Local cDesPrc := ''
Local cTipFre := DW7->DW7_TIPFRE

For nX := 1 To Len(aItensPro)
	If PcoPrtLim(nLin)
		RTMSR14Cab(oPrint,aItensPro)
	EndIf
	If cTipFre == '1' .Or. cTipFre == '2'
		//-- Impressao do Estado
		PcoPrtCol({020,070,450,2000},.T.,3)
		PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),50,aItensPro[nX,1],oPrint,4,2,/*RgbColor*/)
		//-- Impressao do Municipio
		PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),50,Capital(aItensPro[nX,2]),oPrint,4,2,/*RgbColor*/)
	ElseIf cTipFre == '3'
		PcoPrtCol({020,415,850,2000},.T.,3)
		PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),50,Capital(aItensPro[nX,1]),oPrint,4,2,/*RgbColor*/) // 'Origem'
		PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),50,Capital(aItensPro[nX,2]),oPrint,4,2,/*RgbColor*/) // 'Destino'
	EndIf		
	//-- Impressao dos precos
	nTotBox  := Len(aItensPro[nX,5])
	nIniCell := PcoPrtPos(3)
	nTamBox  := PcoPrtTam(3)/nTotBox
	For nCnt := 1 To nTotBox
		If nCnt > 1
			nIniCell := nIniCell + nTamBox
		EndIf
		nValor := 0
		For nCnt1 := 1 To Len(aItensPro[nX,3])
			If !aItensPro[nX,3,nCnt1,5]
				If aItensPro[nX,3,nCnt1,1] == aItensPro[nX,5,nCnt,1] .And. ;
					aItensPro[nX,3,nCnt1,2] <= aItensPro[nX,5,nCnt,2]
					nValor := aItensPro[nX,3,nCnt1,3]
					aItensPro[nX,3,nCnt1,5] := .T.
				EndIf				
			EndIf
		Next nCnt1
		cDesPrc := AllTrim(TransForm(nValor,"@E 9,999.99"))
		PcoPrtCell(nIniCell,nLin,nTamBox,50,cDesPrc,oPrint,4,2,/*RgbColor*/,,.T.,,,.T.)
	Next nCnt
	nLin += 50
Next nX

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ ImpFinal ≥ Autor ≥ Richard Anderson      ≥ Data ≥ 23.07.05 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Imprime fim da proposta comercial                          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGATMS                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function ImpFinal(oPrint)

Local cCodNeg   := DW7->DW7_CODNEG
Local cObs      := ""
Local cObsDW7   := E_MsMM(Posicione("DW7",1,xFilial("DW7")+DW7->DW7_FILORI+DW7->DW7_NUMPRO,"DW7_CODOBS"),80)
Local cObsDWE   := E_MsMM(Posicione("DWE",1,xFilial("DWE")+DW5->DW5_CODPOL,"DWE_CODOBS"),80)
Local nCnt      := 0
Local cMsg      := ""
Local cQuery    := ""
Local cTexto    := ""
Local nTamObs   := 0
Local cAliasDW6 := GetNextAlias()
Local cTipFre   := DW7->DW7_TIPFRE
Local cTxt      := ""

cQuery := "SELECT DW6_CODPAS, DW6_TEXTO FROM "+RetSqlName("DW6")
cQuery += " WHERE DW6_FILIAL = '"+xFilial("DW6")+"'"
cQuery += "   AND DW6_CODNEG = '"+cCodNeg+"'"
cQuery += "   AND DW6_TEXTO <> ' '"
cQuery += "   AND D_E_L_E_T_ = ' '"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDW6)
If (cAliasDW6)->(!Eof())
	While (cAliasDW6)->(!Eof())
		If !Empty(Posicione("DWA",1,xFilial("DWA")+DW7->(DW7_FILORI+DW7_NUMPRO)+(cAliasDW6)->DW6_CODPAS,"DWA_PERCOB"))
			cTxt := &((cAliasDW6)->DW6_TEXTO)
			If !Empty(cTxt)
				cObs+= AllTrim(Posicione("DT3",1,xFilial("DT3")+(cAliasDW6)->DW6_CODPAS,"DT3_DESCRI"))+": "+cTxt+CHR(13)+CHR(10)
			EndIf
		EndIf
		(cAliasDW6)->(dbSkip())
	EndDo
EndIf
If !Empty(cObsDW7)
	cObs += cObsDW7 + CHR(13)+CHR(10) + CHR(13)+CHR(10)
EndIf
If !Empty(cObsDWE)
	cObs += cObsDWE + CHR(13)+CHR(10)
EndIf

nTamObs := MlCount(cObs,250) * 35
If nTamObs > 0
	nLin += 60
	If PcoPrtLim(nLin + nTamObs)
		PcoPrtCab(oPrint,4,cFileLogo)
		nLin  := 200
	EndIf
	PcoPrtCol({20,2000},.T.,1)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),nTamObs,cObs,oPrint,4,2,/*RgbColor*/,STR0030) // 'ObservaÁ„o'
EndIf

nLin += ( nTamObs + 060 )
If PcoPrtLim(nLin)
	PcoPrtCab(oPrint,4,cFileLogo)
	nLin  := 200
EndIf

PcoPrtCol({20,2000},.T.,1)
If cTipFre == "1"
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"Validade: "+AllTrim(Str(SuperGetMv("MV_VLDPRO")))+" Dias",oPrint,4,2,RGB(230,230,230),,,,,.T.) 
Else
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,STR0024+Dtoc(dDataBase),oPrint,4,2,RGB(230,230,230)) // "PreÁos Atualizados em "
EndIf

nLin += 120
If PcoPrtLim(nLin)
	PcoPrtCab(oPrint,4,cFileLogo)
	nLin  := 200
EndIf

If cTipFre == "1"
	PcoPrtCol({20,800,1200,2000},.T.,2)
	PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),60,STR0027 +"   Data:   ______/_______/_________",oPrint,5,2) // "De Acordo:" 
	nLin += 120
	If PcoPrtLim(nLin)
		PcoPrtCab(oPrint,4,cFileLogo)
		nLin  := 200
	EndIf
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"",oPrint,5,2)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),1,Replicate("_",50),oPrint,5,2)
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,Posicione("SA3",1,xFilial("SA3")+DW7->DW7_CODVEN,"A3_NOME"),oPrint,5,2)
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),1,Replicate("_",50),oPrint,5,2)
	PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),60,"",oPrint,5,2)
	PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),1,Replicate("_",50),oPrint,5,2)
	nLin += 30
	If PcoPrtLim(nLin)
		PcoPrtCab(oPrint,4,cFileLogo)
		nLin  := 200
	EndIf
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,"Gerente Filial",oPrint,5,2) 
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,"Executivo de Contas",oPrint,5,2) 
	PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),60,"Respons·vel cliente",oPrint,5,2) 
Else
	PcoPrtCol({20,2000},.T.,1)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,STR0025,oPrint,4,2,RGB(230,230,230)) // "Proposta Elaborada por:"
	
	nLin += 060
	If PcoPrtLim(nLin)
		PcoPrtCab(oPrint,4,cFileLogo)
		nLin  := 200
	EndIf
	PcoPrtCol({20,800,800,1200,2000},.T.,2)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,Posicione("SA3",1,xFilial("SA3")+DW7->DW7_CODVEN,"A3_NOME"),oPrint,4,2,,STR0026) // 'Nome'
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,SA3->A3_TEL,oPrint,4,2,,STR0008) // 'Fone'
	PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),60,SA3->A3_FAX,oPrint,4,2,,STR0009) // 'Fax'
	PcoPrtCell(PcoPrtPos(4),nLin,PcoPrtTam(4),60,SA3->A3_EMAIL,oPrint,4,2,,STR0010) // 'e-mail'
	
	nLin += 100
	If PcoPrtLim(nLin)
		PcoPrtCab(oPrint,4,cFileLogo)
		nLin  := 200
	EndIf
	PcoPrtCol({20,800,1200,2000},.T.,2)
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,STR0027,oPrint,5,2) // "De Acordo:"
	
	nLin += 100
	If PcoPrtLim(nLin)
		PcoPrtCab(oPrint,4,cFileLogo)
		nLin  := 200
	EndIf
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,Replicate("_",10),oPrint,5,2)
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,Replicate("_",50),oPrint,5,2)
	PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),60,Replicate("_",50),oPrint,5,2)
	
	nLin += 30
	If PcoPrtLim(nLin)
		PcoPrtCab(oPrint,4,cFileLogo)
		nLin  := 200
	EndIf
	PcoPrtCell(PcoPrtPos(1),nLin,PcoPrtTam(1),60,STR0028,oPrint,5,2) // 'Data'
	PcoPrtCell(PcoPrtPos(2),nLin,PcoPrtTam(2),60,STR0026,oPrint,5,2) // 'Nome'
	PcoPrtCell(PcoPrtPos(3),nLin,PcoPrtTam(3),60,STR0029,oPrint,5,2) // 'Assinatura'
EndIf

Return NIL

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ RTM14Val ≥ Autor ≥ Eduardo de Souza      ≥ Data ≥ 03/08/06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Imprime valores por estado                                 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ SIGATMS                                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
User Function RTM14Val(cCodPas)

Local nPos   := 0
Local nCnt   := 0
Local nValor := 0
Local cTexto := ""

If Type("aValorEst") == "A"
	aValorEst := ASort( aValorEst,,,{|x,y| x[2]+AllTrim(Str(x[3]))+x[1] < y[2]+AllTrim(Str(y[3]))+y[1] })
	nPos      := Ascan( aValorEst, { |x| x[2] == cCodPas } )
	
	If nPos > 0
		For nCnt := nPos To Len(aValorEst)
			If cCodPas <> aValorEst[nCnt,2]
				Exit
			EndIf
			If nValor <> aValorEst[nCnt,3]
				If nCnt == nPos
					If aValorEst[nCnt,4] > 0
						cTexto +=  "Valor MÌnimo R$ " + AllTrim(TransForm(aValorEst[nCnt,4],"@E 999,999.99")) + " - "
					EndIf
					cTexto +=  "R$ " + AllTrim(TransForm(aValorEst[nCnt,3],"@E 999,999.99"))
					nValor := aValorEst[nCnt,3]
				Else
					cTexto += "R$ " + AllTrim(TransForm(aValorEst[nCnt,3],"@E 999,999.99"))
					nValor := aValorEst[nCnt,3]
				EndIf
				cTexto += " para " + aValorEst[nCnt,1] + "," 
			Else
				cTexto += aValorEst[nCnt,1] + ","
				nValor := aValorEst[nCnt,3]
			EndIf
		Next nCnt
		If Len(aValorEst) > 0
			cTexto := SubStr(cTexto,1,Len(cTexto)-1)
		EndIf
	EndIf
EndIf

Return cTexto

User Function VldCliPr()

Local lRet     := .T.
Local aHlpPor1 := {"N„o existe registro relacionado a este","CNPJ."}
Local aSolPor1 := {"Informe um CNPJ j· cadastrado ou efetue","cadastro no bot„o superior Cliente Novo","escolhendo no campo 'Tipo' a opÁ„o ","F=Consumidor Final, L=Produtor Rural","ou R=Revendedor (Industria ou ComÈrico)"}
Local aHlpIng1 := {}
Local aHlpEsp1 := {}

PutHelp("PTMSAW1044",aHlpPor1,aHlpIng1,aHlpEsp1,.T.)
PutHelp("STMSAW1044",aSolPor1,aHlpIng1,aHlpEsp1,.T.)

aHlpPor1 := {"Para aprovaÁ„o ou impress„o de uma","proposta pendente È necess·rio a","aprovaÁ„o da matriz. Contate seu","Coordenador de Filial ou Gerente","Regional."}
PutHelp("PTMSAW1026",aHlpPor1,aHlpIng1,aHlpEsp1,.T.)

aHlpPor1 := {"Para aprovaÁ„o desta proposta È","necess·rio alterar o campo Status","para Aprovado ou Reprovado"}
PutHelp("PTMSAW1028",aHlpPor1,aHlpIng1,aHlpEsp1,.T.)

aHlpPor1 := {"Componente baseado em peso. Informar","se a cobranÁa ser· sobre o Peso Real,","Peso Cubado, ou M3 na linha Cubagem."}
PutHelp("PTMSAW1043",aHlpPor1,aHlpIng1,aHlpEsp1,.T.)

aHlpPor1 := {"CNPJ do cliente dever· ser informado."}
PutHelp("PTMSAW1012",aHlpPor1,aHlpIng1,aHlpEsp1,.T.)

aHlpPor1 := {"Origens e Destinos n„o informados.","Clicar no bot„o superior 'SeleÁ„o de","Estados' para inserir as informaÁıes"}
PutHelp("PTMSAW1031",aHlpPor1,aHlpIng1,aHlpEsp1,.T.)

SA1->(DbSetOrder(1))
If !SA1->(MsSeek(xFilial("SA1")+M->DW7_CODCLI+AllTrim(M->DW7_LOJCLI)))
	Help("",1,"TMSAW1044")
	lRet := .F.
EndIf

Return lRet
