#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³NfeMun    ³ Autor ³ Eduardo Riera         ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Programa de ajuste do cadastro de municipios                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NfeMun()
                      
nCadastro := Aviso("Cadastro","Selecione o cadastro",{"Cliente","Fornecedores"})

While NfeMun(nCadastro)
EndDo
Return
	

Static Function NfeMun(nCadastro)

Local nUsado    := 0
Local nX        := 0
Local aSize     := MsAdvSize()
Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aPosGet   := {}
Local cCursor   := GetNextAlias()
Local cEstado   := ""
Local nOpcA     := 0
Local cIndice   := ""
Local nIndice   := 0
Local nRecno    := 0
Local lRetorno  := .F.
Private aHeader := {}
Private aCols   := {}
Private aRotina := {{"","",0,4}}
Private cCadastro := "Acerto de Municipios"
Private M->A1_EST := Space(2)
Private M->A2_EST := Space(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aheader                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nCadastro == 1
	Aadd(aHeader,{ "Estado",;
				"A1_EST",;
				"@!",;
				2,;
				0,;
				".F.",;
				"",;
				"C",;
				"SA1",;
				"R",;
				"",;
				"",;
				".F."})
	Aadd(aHeader,{ "Municipio",;
				"TRB_MUN",;
				"",;
				TamSx3("A1_MUN")[1],;
				0,;
				".F.",;
				"",;
				"C",;
				"SA1",;
				"R",;
				"",;
				"",;
				".F."})
	Aadd(aHeader,{ "Cod.IBGE",;
				"A1_COD_MUN",;
				"",;
				5,;
				0,;
				"ExistCpo('CC2',M->A1_EST+M->A1_COD_MUN)",;
				"",;
				"C",;
				"CC2SA1",;
				"R",;
				"",;
				"",;
				".T."})
	Aadd(aHeader,{ "Munic.New",;
				"A1_MUN",;
				"",;
				TamSx3("A1_MUN")[1],;
				0,;
				".F.",;
				"",;
				"C",;
				"SA1",;
				"R",;
				"",;
				"",;
				".F."})				
				
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do acols                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nUsado := Len(aHeader)
	#IFDEF TOP
		BeginSql Alias cCursor				
			
			SELECT	A1_FILIAL,A1_EST,A1_MUN,count(*) XX
			FROM %Table:SA1% SA1
			WHERE	SA1.A1_FILIAL = %xFilial:SA1% AND
					SA1.A1_COD_MUN = '    ' AND 
					SA1.%notdel%
			GROUP BY A1_FILIAL,A1_EST,A1_MUN
			ORDER BY A1_FILIAL,A1_EST,A1_MUN
			
		EndSql
	
	#ELSE
		cCursor := "SA1"
		dbSelectArea("SA1")
		cIndice := CriaTrab(,.F.)
		IndRegua("SA1",cIndice,"A1_FILIAL+A1_EST+A1_MUN",,"A1_COD_MUN==Space(5)")		
	#ENDIF	
	nX := 0
	dbSelectArea(cCursor)
	dbGotop()
	M->A1_EST := cEstado := (cCursor)->A1_EST
	
	While !Eof() .And. cEstado == (cCursor)->A1_EST
		
		nX ++
		aadd(aCOLS,Array(nUsado+1))
		aCols[nX][1] := (cCursor)->A1_EST
		aCols[nX][2] := (cCursor)->A1_MUN
		aCols[nX][3] := Space(5)
		aCols[nX][4] := (cCursor)->A1_MUN
		aCOLS[nX][nUsado+1] := .F.
		
		While !Eof() .And. cEstado == (cCursor)->A1_EST .And. aCols[nX][2] == (cCursor)->A1_MUN
			dbSelectArea(cCursor)
			DbSkip()
		EndDo
	EndDo
	#IFDEF TOP
		dbSelectArea(cCursor)
		dbCloseArea()	
		dbSelectArea("SA1")	
	#ELSE
		dbSelectArea("SA1")
		RetIndex("SA1")
		FErase(cIndice+OrdBagExt())		
	#ENDIF
	If !Empty(aCols)
		lRetorno := .T.
	EndIf	
Else
	Aadd(aHeader,{ "Estado",;
				"A2_EST",;
				"@!",;
				2,;
				0,;
				".F.",;
				"",;
				"C",;
				"SA2",;
				"R",;
				"",;
				"",;
				".F."})
	Aadd(aHeader,{ "Municipio",;
				"TRB_MUN",;
				"",;
				TamSx3("A2_MUN")[1],;
				0,;
				".F.",;
				"",;
				"C",;
				"SA2",;
				"R",;
				"",;
				"",;
				".F."})
	Aadd(aHeader,{ "Cod.IBGE",;
				"A2_COD_MUN",;
				"",;
				5,;
				0,;
				"ExistCpo('CC2',M->A2_EST+M->A2_COD_MUN)",;
				"",;
				"C",;
				"SA2",;
				"R",;
				"",;
				"",;
				".T."})
	Aadd(aHeader,{ "Munic.New",;
				"A2_MUN",;
				"",;
				TamSx3("A2_MUN")[1],;
				0,;
				".F.",;
				"",;
				"C",;
				"SA2",;
				"R",;
				"",;
				"",;
				".F."})				
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do acols                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nUsado := Len(aHeader)
	#IFDEF TOP
		BeginSql Alias cCursor				
			
			SELECT	A2_FILIAL,A2_EST,A2_MUN,count(*) XX
			FROM %Table:SA2% SA2
			WHERE	SA2.A2_FILIAL = %xFilial:SA2% AND
					SA2.A2_COD_MUN = '    ' AND 
					SA2.%notdel%
			GROUP BY A2_FILIAL,A2_EST,A2_MUN
			ORDER BY A2_FILIAL,A2_EST,A2_MUN
			
		EndSql
	
	#ELSE
		cCursor := "SA2"
		dbSelectArea("SA2")
		cIndice := CriaTrab(,.F.)
		IndRegua("SA2",cIndice,"A2_FILIAL+A2_EST+A2_MUN",,"A2_COD_MUN==Space(5)")
	#ENDIF
	
	nX := 0
	dbSelectArea(cCursor)
	dbGotop()
	M->A2_EST := cEstado := (cCursor)->A2_EST
	While !Eof() .And. cEstado == (cCursor)->A2_EST		
		nX ++
		aadd(aCOLS,Array(nUsado+1))
		aCols[nX][1] := (cCursor)->A2_EST
		aCols[nX][2] := (cCursor)->A2_MUN
		aCols[nX][3] := Space(5)
		aCols[nX][4] := (cCursor)->A2_MUN
		aCOLS[nX][nUsado+1] := .F.
	
		While !Eof() .And. cEstado == (cCursor)->A2_EST .And. aCols[nX][2] == (cCursor)->A2_MUN
			dbSelectArea(cCursor)
			DbSkip()
		EndDo
	EndDo
	#IFDEF TOP
		dbSelectArea(cCursor)
		dbCloseArea()	
		dbSelectArea("SA2")	
	#ELSE
		dbSelectArea("SA2")
		RetIndex("SA2")
		FErase(cIndice+OrdBagExt())		
	#ENDIF	
	If !Empty(aCols)
		lRetorno := .T.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo do tamanho dos objetos                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno
	AAdd( aObjects, { 100, 015, .t., .f. } )		
	AAdd( aObjects, { 100, 100, .t., .t. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{160,200,240,265}} )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	@ aPosObj[1,1],aPosObj[1,2] SAY "Estado: "+cEstado SIZE 040,09 OF oDlg PIXEL
	oGetD:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],1,"AllwaysTrue","AllwaysTrue","",.T.,,1)
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})
	
	If nOpcA==1
		Begin Transaction
			If nCadastro == 1
				dbSelectArea("SA1")
				cIndice := CriaTrab(,.F.)
				IndRegua("SA1",cIndice,"A1_FILIAL+A1_EST+A1_MUN",,"A1_COD_MUN==Space(5)")
				nIndice := RetIndex("SA1")
				#IFNDEF TOP
					dbSetIndex(cIndice+OrdBagExt())
				#ENDIF
				dbSetOrder(nIndice+1)
				
				For nX := 1 To Len(aCols)
					If !aCols[nX][nUsado+1]
						dbSelectArea("SA1")
						dbSetOrder(nIndice+1)
						MsSeek(xFilial("SA1")+aCols[nX][1]+aCols[nX][2])
						While !Eof() .And. xFilial("SA1")+aCols[nX][1]+aCols[nX][2] == SA1->A1_FILIAL+SA1->A1_EST+SA1->A1_MUN
							dbSelectArea("SA1")
							dbSkip()
							nRecno := SA1->(RecNo())
							dbSkip(-1)
							RecLock("SA1")
							SA1->A1_COD_MUN := aCols[nX][3]
							SA1->A1_MUN     := aCols[nX][4]
							MsUnLock()
							MsGoto(nRecno)
					    EndDo
					  EndIf
			    Next nX
			
				dbSelectArea("SA1")
				RetIndex("SA1")
				FErase(cIndice+OrdBagExt())
			Else
				dbSelectArea("SA2")
				cIndice := CriaTrab(,.F.)
				IndRegua("SA2",cIndice,"A2_FILIAL+A2_EST+A2_MUN",,"A2_COD_MUN==Space(5)")
				nIndice := RetIndex("SA2")
				#IFNDEF TOP
					dbSetIndex(cIndice+OrdBagExt())
				#ENDIF
				dbSetOrder(nIndice+1)
				
				For nX := 1 To Len(aCols)
					If !aCols[nX][nUsado+1]
						dbSelectArea("SA2")
						dbSetOrder(nIndice+1)
						MsSeek(xFilial("SA2")+aCols[nX][1]+aCols[nX][2])
						While !Eof() .And. xFilial("SA2")+aCols[nX][1]+aCols[nX][2] == SA2->A2_FILIAL+SA2->A2_EST+SA2->A2_MUN
							dbSelectArea("SA2")
							dbSkip()
							nRecno := SA2->(RecNo())
							dbSkip(-1)
							RecLock("SA2")
							SA2->A2_COD_MUN := aCols[nX][3]
							SA2->A2_MUN     := aCols[nX][4]
							MsUnLock()
							MsGoto(nRecno)
					    EndDo
					 EndIf
			    Next nX
			
				dbSelectArea("SA2")
				RetIndex("SA2")
				FErase(cIndice+OrdBagExt())		
			EndIf
		End Transaction
	Else
		lRetorno := .F.
	EndIf
EndIf
Return(lRetorno)

