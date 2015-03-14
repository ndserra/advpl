#INCLUDE "protheus.ch"
#INCLUDE "RTMSR19.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR19  ³ Autor ³ Richard Anderson      ³ Data ³21.12.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Carta de Correção                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR19                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR19()

Local titulo  := STR0001 //"Carta de Correção
Local cString := "DIC"
Local wnrel   := "RTMSR19"
Local cDesc1  := STR0002 //"Este programa ira imprimir a Carta de Correção"
Local cDesc2  := ""
Local cDesc3  := ""
Local tamanho := "P"
Local Limite  := 80
Local cPerg   := "RTMR19"
Local aOrd    := {}

Private aReturn  := {STR0003,1,STR0004,2, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private nLastKey := 0

AjustaSX1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            	// Fil.Documento De                   ³
//³ mv_par02            	// Documento De       	         	  ³
//³ mv_par03            	// Serie De        	      		     ³
//³ mv_par04            	// Fil.Documento Ate  		           ³
//³ mv_par05            	// Documento Ate	   		           ³
//³ mv_par06            	// Serie Ate            	           ³
//³ mv_par07            	// Sequencia De         	           ³
//³ mv_par08            	// Sequencia Ate        	           ³
//³ mv_par09            	// Impressao / Reimpressao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR19Imp(@lEnd,wnRel,titulo,tamanho,Limite)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR19Imp³ Autor ³ Richard Anderson      ³ Data ³22.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR19			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR19Imp(lEnd,wnRel,titulo,tamanho,Limite)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local   nX       := 0
Local   nLinAnt  := 0
Local   nObs     := 0
Local   cObs     := ''
Local   cAliasQry:= GetNextAlias()
Local   cQuery   := ''
Local   aAreaAtu := GetArea()
Local   aStruDIC := DIC->(dbStruct())
Local   aAreaDTC := DTC->(GetArea())
Local   nLin     := 99
Local   nPag     := 0
Local   aPages   := {}
Local   cChave   := ''
Local   lTem13   := .F.

SetRegua(DIC->(LastRec()))

cQuery := "SELECT DIC.*, DIC.R_E_C_N_O_ RECNODIC, DIM_CPODOC, DIM_CODODC, DIM_CODDVC, DT6_SIGTRA FROM "
cQuery += RetSqlName("DIC")+" DIC, "
cQuery += RetSqlName("DIM")+" DIM, "
cQuery += RetSqlName("DT6")+" DT6  "
cQuery += " WHERE DIC.DIC_FILIAL = '"+xFilial("DID")+"'"
cQuery += "   AND DIC.DIC_FILDOC BETWEEN '"+mv_par01+"' AND '"+mv_par04+"'"
cQuery += "   AND DIC.DIC_DOC    BETWEEN '"+mv_par02+"' AND '"+mv_par05+"'"
cQuery += "   AND DIC.DIC_SERIE  BETWEEN '"+mv_par03+"' AND '"+mv_par06+"'"
cQuery += "   AND DIC.DIC_SEQUEN BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
cQuery += "   AND DIC.DIC_FIMP   IN "+Iif(mv_par09 == 1,"( ' ', '0')","( '1' )")
cQuery += "   AND DIC.D_E_L_E_T_ = ' '" 
cQuery += "   AND DIM.DIM_FILIAL = '"+xFilial('DIM')+"'"
cQuery += "   AND DIM.DIM_FILDOC = DIC_FILDOC"
cQuery += "   AND DIM.DIM_DOC    = DIC_DOC"
cQuery += "   AND DIM.DIM_SERIE  = DIC_SERIE"
cQuery += "   AND DIM.DIM_SEQUEN = DIC_SEQUEN"
cQuery += "   AND DIM.D_E_L_E_T_ = ' '"
cQuery += "   AND DT6.DT6_FILIAL = '"+xFilial('DT6')+"'"
cQuery += "   AND DT6.DT6_FILDOC = DIC_FILDOC"
cQuery += "   AND DT6.DT6_DOC    = DIC_DOC"
cQuery += "   AND DT6.DT6_SERIE  = DIC_SERIE"
cQuery += "   AND DT6.D_E_L_E_T_ = ' '"
cQuery += "   ORDER BY DIC_FILIAL,DIC_FILDOC,DIC_DOC,DIC_SERIE,DIC_SEQUEN"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
For nX := 1 To Len(aStruDIC)
	If aStruDIC[nX][2]<>"C"
		TcSetField(cAliasQry,aStruDIC[nX][1],aStruDIC[nX][2],aStruDIC[nX][3],aStruDIC[nX][4])
	EndIf
Next nX  
	
While (cAliasQry)->(!Eof())

	cChave := (cAliasQry)->(DIC_FILIAL+DIC_FILDOC+DIC_DOC+DIC_SERIE+DIC_SEQUEN) 
	nLin:= 99
	
	While (cAliasQry)->(!Eof()) .And. cChave == (cAliasQry)->(DIC_FILIAL+DIC_FILDOC+DIC_DOC+DIC_SERIE+DIC_SEQUEN)		
		
		IncRegua()
					
		If Interrupcao(@lEnd)
			Exit
		EndIf
		
		If nLin > 62
			RTMSR19Cab(cAliasQry,@nLin,@nPag,@aPages,.T.,Limite)
		EndIf
		
		nLinAnt:= nLin
		aPages[nPag,2,nLin] := STR0015 //"Ref.Campo Onde Consta"
		nLin += 1
		aPages[nPag,2,nLin] := "--------- --------------------------------------------------------------------"
		nLin += 1
		aPages[nPag,2,nLin] := (cAliasQry)->DIM_CPODOC+Space(8)
		cObs   := StrTran(MsMM((cAliasQry)->DIM_CODODC,80),Chr(10),'')
		cDados := ''
		lTem13 := .F.
		For nObs := 1 To Len(cObs)
			If Substr(cObs,nObs,1) == Chr(13)
			   lTem13 := .T.
				If nLin > 62
					RTMSR19Cab(cAliasQry,@nLin,@nPag,@aPages,.F.,Limite)
					nLinAnt := nLin
				EndIf
				If Empty(aPages[nPag,2,nLin])
					aPages[nPag,2,nLin] += Space(10)
				EndIf
				aPages[nPag,2,nLin] += cDados
				nObs   += 1
				nLin   += 1
				cDados := ''
				//-- Verifica linhas em branco
				While Substr(cObs,nObs,1) == Chr(13)
					nObs += 1
				EndDo
			EndIf
			cDados += Substr(cObs,nObs,1)
		Next nObs   
		If !lTem13
			If nLin > 62
				RTMSR19Cab(cAliasQry,@nLin,@nPag,@aPages,.F.,Limite)
				nLinAnt := nLin
			EndIf
			If Empty(aPages[nPag,2,nLin])
				aPages[nPag,2,nLin] += Space(10)
			EndIf
			aPages[nPag,2,nLin] += cDados
		EndIf
		nLin += 1				
		aPages[nPag,2,nLin] := Space(10)+STR0016 //"Devera Constar"
		nLin += 1
		aPages[nPag,2,nLin] := Space(10)+"--------------------------------------------------------------------"
		nLin += 1
		cObs   := StrTran(MsMM((cAliasQry)->DIM_CODDVC,80),Chr(10),'')
		cDados := '' 
		lTem13 := .F.
		For nObs := 1 To Len(cObs)
			If Substr(cObs,nObs,1) == Chr(13) 
			   lTem13 := .T.
				If nLin > 62
					RTMSR19Cab(cAliasQry,@nLin,@nPag,@aPages,.F.,Limite)
					nLinAnt := nLin
				EndIf
				If Empty(aPages[nPag,2,nLin])
					aPages[nPag,2,nLin] += Space(10)
				EndIf
				aPages[nPag,2,nLin] += cDados
				nObs   += 1
				nLin   += 1
				cDados := ''
				//-- Verifica linhas em branco
				While Substr(cObs,nObs,1) == Chr(13)
					nObs += 1
				EndDo
			EndIf
			cDados += Substr(cObs,nObs,1)
		Next nObs
		If !lTem13
			If nLin > 62
				RTMSR19Cab(cAliasQry,@nLin,@nPag,@aPages,.F.,Limite)
				nLinAnt := nLin
			EndIf
			If Empty(aPages[nPag,2,nLin])
				aPages[nPag,2,nLin] += Space(10)
			EndIf
			aPages[nPag,2,nLin] += cDados
		EndIf
		
		If nLin <= nLinAnt
			nLin := nLinAnt
		EndIf
		
		nLin += 1
		
		If nLin > 62
			RTMSR19Cab(cAliasQry,@nLin,@nPag,@aPages,.T.,Limite)
		EndIf
		
		//-- Atualiza flag de impressao
		DIC->(dbGoTo((cAliasQry)->RECNODIC))
		RecLock('DIC',.F.)
		DIC->DIC_FIMP := '1' //-- Impresso
		MsUnLock()
		
		(cAliasQry)->(dbSkip())			
		
	EndDo	
EndDo

If nPag > 0
	nLin += 2
	aPages[nPag,2,nLin] := STR0012 //-- "Sem outro motivo para o momento, subscrevemo-nos."
	nLin += 3
	aPages[nPag,2,nLin] := Padl(STR0013,67) //-- "Atenciosamente"
EndIf

For nPag := 1 To Len(aPages)
	For nLin := 1 To Len(aPages[nPag,2])
		If nLin == 1
			@ nLin,00 PSay AvalImp(Limite)+__PrtLogo()
		ElseIf nLin == 3
		@ nLin,00 PSay Padl(STR0014+StrZero(nPag,2)+'/'+StrZero(Len(aPages),2),Limite) //-- "Folha "
		Else
			@ nLin,00 Psay aPages[nPag,2,nLin]
		EndIf
	Next nLin
Next nPag

(cAliasQry)->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

RestArea(aAreaDTC)
RestArea(aAreaAtu)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR19Cab³ Autor ³ Richard Anderson      ³ Data ³23.11.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressão do cabeçalho                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR19			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR19Cab(cAliasQry,nLin,nPag,aPages,lImpCab,Limite)

Local   nI       := 0
Local   nObs     := 0
Local   cObs     := ''
Local   aDoctos  := Array(3)
Local   cDoctos  := ''
Local   cSeekDTC := ''
Default lImpCab  := .T.

nPag += 1
nLin := 5
Aadd(aPages,{ StrZero(nPag,2), Array(62) })
For nI := 1 To 62
	aPages[nPag,2,nI] := ''
Next nI
If lImpCab
	aPages[nPag,2,nLin] := Padl(AllTrim(SM0->M0_CIDCOB)+', '+AllTrim(Str(Day((cAliasQry)->DIC_DATCAR),2))+" de "+AllTrim(MesExtenso(Month((cAliasQry)->DIC_DATCAR)))+" de "+Str(Year((cAliasQry)->DIC_DATCAR),4),Limite)
	nLin += 2
	aPages[nPag,2,nLin] := 'A'
	nLin += 1
	cObs := StrTran(MsMM((cAliasQry)->DIC_CODENV,80),Chr(10),'')
	cDados := ''
	For nObs := 1 To Len(cObs)
		If Substr(cObs,nObs,1) == Chr(13)
			aPages[nPag,2,nLin] := cDados
			nObs   += 1
			nLin   += 1
			cDados := ''
			//-- Verifica linhas em branco
			While Substr(cObs,nObs,1) == Chr(13)
				nI   += 1
				nObs += 1
			EndDo
		EndIf
		cDados += Substr(cObs,nObs,1)
	Next nObs
	nLin += 2
	aPages[nPag,2,nLin] := Padc(STR0006,Limite) //-- 'CARTA DE CORREÇÃO'
	nLin += 1
	aPages[nPag,2,nLin] := Padc('-----------------',Limite)
	nLin += 2
	aPages[nPag,2,nLin] := STR0007 //-- 'Ref.: Conferência de documento fiscal e comunicação de incorreções'
	nLin += 1
	aPages[nPag,2,nLin] := '      CRT  No.: '+Transform((cAliasQry)->(DT6_SIGTRA+DIC_SERIE+DIC_DOC),"@R AA.XXX.XXXXXX")
	nLin += 1
	aPages[nPag,2,nLin] := '      FACT.No.: '
	nI := 0
	cDoctos := ''
	aFill(aDoctos,Space(65))
	DTC->(dbSetOrder(3))
	DTC->(MsSeek(cSeekDTC := xFilial('DTC')+(cAliasQry)->(DIC_FILDOC+DIC_DOC+DIC_SERIE)))
	While DTC->(!Eof()) .And. DTC->(DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE) == cSeekDTC
		If Len(cDoctos) > 65
			nI += 1
			If nI > 3
				Exit
			EndIf
			aDoctos[nI] := Substr(cDoctos,1,65)
			cDoctos     := AllTrim(Substr(cDoctos,66))
		EndIf			
		If !Empty(cDoctos)
			cDoctos += '/'
		EndIf
		cDoctos += DTC->DTC_NUMNFC
		DTC->(dbSkip())
	EndDo
	If !Empty(cDoctos) .And. (nI+1) <= 3
		nI += 1
		aDoctos[nI] := Substr(cDoctos,1,65)
	EndIf		
	For nI := 1 To Len(aDoctos)
		aPages[nPag,2,nLin] := aDoctos[nI]
	Next nI
	nLin += 3
	aPages[nPag,2,nLin] := STR0008 //-- "Em face do que determina a legislação fiscal  vigente  vimos  pela"
	nLin += 1
	aPages[nPag,2,nLin] := STR0009 //-- "presente comunicar que o conhecimento  em  referência  contem a(s)"
	nLin += 1
	aPages[nPag,2,nLin] := STR0010 //-- "irregularidade(s) que abaixo apontamos:"
	nLin += 3
EndIf

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1  ³ Autor ³Richard Anderson    ³ Data ³ 22/11/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Inclui Perguntas no SX1                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³RTMSR19                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1(cPerg)

SX1->(dbSetOrder(1))
If SX1->(dbSeek(Padr(cPerg,Len(SX1->X1_GRUPO))+"07")) .And. !('Sequencia' $ SX1->X1_PERGUNT)
	RecLock('SX1',.F.)
	dbDelete()
	MsUnLock()
EndIf

If SX1->(dbSeek(Padr(cPerg,Len(SX1->X1_GRUPO))+"08")) .And. !('Sequencia' $ SX1->X1_PERGUNT)
	RecLock('SX1',.F.)
	dbDelete()
	MsUnLock()
EndIf

SX1->(DbSetOrder(1))
If Sx1->(dbSeek(cPerg)) 
	If Alltrim(SX1->X1_PERGUNT)==Alltrim(SX1->X1_PERSPA)
		While SX1->(!Eof()) .And. Alltrim(SX1->X1_GRUPO)==Alltrim(cPerg)
			Reclock("SX1",.F.)
			DBDelete()
			SX1->(MsUnlock())
			SX1->(dbSkip())
		EndDo
	EndIf
EndIf

PutSx1( cPerg,"01","Fil.Documento De ?  ","¿De Suc.Documento ? ","Fil.Documento De ?  ","mv_ch1","C",2,0,0,"G","","DIC","","","mv_par01")
PutSx1( cPerg,"02","Documento De ?      ","¿De Documento ?     ","Documento De ?      ","mv_ch2","C",6,0,0,"G","",""   ,"","","mv_par02")
PutSx1( cPerg,"03","Serie De ?          ","¿De Serie ?         ","Serie De ?          ","mv_ch3","C",3,0,0,"G","",""   ,"","","mv_par03")
PutSx1( cPerg,"04","Fil.Documento Até ? ","¿A Suc.Documento ?  ","Fil.Documento Até ? ","mv_ch4","C",2,0,0,"G","","DIC","","","mv_par04")
PutSx1( cPerg,"05","Documento Até ?     ","¿A Documento ?      ","Documento Até ?     ","mv_ch5","C",6,0,0,"G","",""   ,"","","mv_par05")
PutSx1( cPerg,"06","Serie Até ?         ","¿A Serie ?          ","Serie Até ?         ","mv_ch6","C",3,0,0,"G","",""   ,"","","mv_par06")
PutSx1( cPerg,"07","Sequencia De ?      ","¿De Secuencia ?     ","Sequencia De ?      ","mv_ch7","C",2,0,0,"G","",""   ,"","","mv_par07")
PutSx1( cPerg,"08","Sequencia Ate ?     ","¿A Secuencia  ?     ","Sequencia Ate ?     ","mv_ch8","C",2,0,0,"G","",""   ,"","","mv_par08")
PutSx1( cPerg,"09","Impressão/Reimpre.? ","¿Impresion/Nuev.Imp.?","Impressão/Reimpre.? ","mv_ch9","N",1,0,0,"C","",""   ,"","","mv_par09","Impressão","Impresion","Impressão","","Reimpressão","Nueva Impresion","Reimpressão")

Return
