#INCLUDE "RWMAKE.CH" 
#INCLUDE "QIEM021.CH"

User Function QIEM021() 

SetPrvt("LATUAL,NNOTAMIN,NORDSA5,NORDQEF,NORDQEG,NMESES")
SetPrvt("AANOMES,CANOINI,CANOFIM,CMESINI,CMESFIM,NI")
SetPrvt("CMVASSIQS,NMVIQSQUA,LVERIQSQUA,CMVSKLIQS,AQEX,ATAMSKL")
SetPrvt("LATUALIZA,NIQS,NRECQEV,CFOR,CPROD,CSKIP")
SetPrvt("LATUSIT,NINDICE,CSITU,CCATEG,NFAIXADEM,CUNID")
SetPrvt("NQTDE,NCTDEM,CSITUANT,CSKIPANT,CUNIDANT,CESPEC")
SetPrvt("CCODANT,LATUSKIP,CINDICE,NSOMA,NDIV,NMEDIA")
SetPrvt("NNOTA,NPOS,CCHVHIS,CMVUTSK25")

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ QIEM021  ¦ Autor ¦ Vera Lucia S. Simoes  ¦ Data ¦ 28/05/98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Atualizacao Automatica Situacao e Skip-Lote para os        ¦¦¦
¦¦¦          ¦ Produtos/Fornecedores marcados para atualizacao ("S")      ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ QIEM020 - RDMAKE                                           ¦¦¦
¦¦+-----------------------------------------------------------------------¦¦¦
¦¦¦			ATUALIZACOES SOFRIDAS DESDE A CONSTRUÇAO INICIAL.			  ¦¦¦
¦¦+-----------------------------------------------------------------------¦¦¦
¦¦¦Programador ¦ Data	¦ BOPS ¦  Motivo da Alteracao 					  ¦¦¦
¦¦+------------+--------+------+------------------------------------------¦¦¦
¦¦¦Vera        ¦20/04/99¦------¦ Inclusao do conceito Loja do Fornecedor  ¦¦¦
¦¦¦Vera        ¦14/01/00¦------¦ Inclusao do arquivo CH                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define se sera utilizado o Skip-Lote de 25% 							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMvUtSk25 := GetMv("MV_QUTSK25")

// Controla se atualizou 
lAtual := .f.
NI:=0
//+-------------------------------------------------------------------------+
//¦ Verifica se existe o Indice Qualidade gerado para este mes/ano          ¦
//+-------------------------------------------------------------------------+
dbSelectArea("QEV")
dbSetOrder(1)
If !dbSeek(xFilial("QEV")+cIE020Ano+cIE020Mes)
	Help(" ",1,"QE_NAOINQU")	// Indice de Qualidade nao foi gerado para este mes/ano.
	Return(.F.)
Endif

//+-------------------------------------------------------------------------+
//¦ Verifica se a Tabela de Criterios do Skip-Lote está cadastrada          ¦
//+-------------------------------------------------------------------------+
dbSelectArea("QEX")
dbSetOrder(1)
If !dbSeek(xFilial("QEX"))
	Help(" ",1,"M020CSLVAZ")	// "Favor cadastrar os Criterios do Skip-Lote"
	Return(.F.)
EndIf

// Define a nota minima do Skip-Lote
nNotaMin := QEX_VLSUP

//+-------------------------------+
//¦ Guarda os indices anteriores  ¦
//+-------------------------------+
dbSelectArea("SA5")
nOrdSA5 := IndexOrd()

dbSelectArea("QEF")
nOrdQEF := IndexOrd()

dbSelectArea("QEG")
nOrdQEG := IndexOrd()

//+-------------------------------------------------------------------------+
//¦ Define o periodo a ser considerado para a media do Skip-Lote            ¦
//+-------------------------------------------------------------------------+
// Por default, assume 12 meses p/ o calculo da media
nMeses  := 12
aAnoMes := {}
cAnoIni := cIE020Ano
cAnoFim := cIE020Ano
cMesIni := cIE020Mes
cMesFim := cIE020Mes

For nI := 1 to nMeses
	Aadd(aAnoMes, { cAnoIni, cMesIni })
	cMesIni := StrZero(Val(cMesIni)-1,2)
	If cMesIni == '00'
		cAnoIni := StrZero(Val(cAnoIni)-1,4)
		cMesIni := '12'
	EndIf
Next nI
// Ordena vetor por Ano+Mes
aAnoMes := aSort(aAnoMes,,, { | x,y | x[1]+x[2] < y[1]+y[2] } )

// Obtem os Parametros envolvidos:
// Situacao pode ser Assegurado sem IQS
cMvAssIQS := GetMv("MV_QASSIQS")

// IQS minimo para Situacao Qualificado
nMvIQSQua := GetMv("MV_QIQSQUA")

// IQS minimo para Situacao Assegurado
mMvIQSAss := GetNewPar("MV_QIQSASS",80)

// Define se sera utilizado o Skip-Lote de 25% 
cMvUtSk25 := GetNewPar("MV_QUTSK25","S")

// Somente checa este parametro se existir Situacao c/ Categoria == "3"
lVerIQSQua := .F.
dbSelectArea("QEG")
dbSetOrder(1)
dbSeek(xFilial("QEG"))
While QEG_FILIAL == xFilial("QEG") .And. !Eof()
	If QEG_CATEG == "3"
		lVerIQSQua := .T.
		Exit
	EndIf
	dbSkip()
EndDo

// Skip-Lote vinculado ao IQS
cMvSklIQS := GetMv("MV_QSKLIQS")
If cMvSklIQS == "S"
	// Guarda o arquivo em vetor para simular o dbskip(-1)
	aQEX := {}
	dbselectArea("QEX")
	dbSetOrder(1)
	dbSeek(xFilial("QEX"))
	While QEX_FILIAL == xFilial("QEX") .And. !Eof()
		Aadd(aQEX, QEX_VLSUP)
		dbSkip()
	EndDo
EndIf

dbSelectArea("SA5")
dbSetOrder(2)

//Define o tamanho do campo Skip-Lote
aTamSkl := {}
aTamSkl := TamSX3("A5_SKPLOT")

QDProcRegua(QEV->(RecCount()))

//+-------------------------------------------------------------------------+
//¦ Seleciona os Indices gerados no mes/ano determinado                     ¦
//+-------------------------------------------------------------------------+
dbSelectArea("QEV")
dbSetOrder(1)
dbSeek(xFilial("QEV")+cIE020Ano+cIE020Mes)
While QEV_FILIAL+QEV_ANO+QEV_MES == xFilial("QEV")+cIE020Ano+cIE020Mes .And. !Eof()

	QDIncProc(STR0001+QEV_FORNEC+"  "+STR0002+QEV_PRODUT )	// "Fornecedor : "###"Produto : "

	// Verifica se algum Fornecedor/Produto está marcado para atualizacao
	lAtualiza := .F.
	dbSelectArea("SA5")
	If dbSeek(xFilial("SA5")+QEV->QEV_PRODUT+QEV->QEV_FORNEC)
		While A5_FILIAL+A5_PRODUTO+A5_FORNECE == xFilial("SA5")+QEV->QEV_PRODUT+;
				QEV->QEV_FORNEC .And. !Eof()
			If A5_ATUAL == "S"
				lAtualiza := .T.
				Exit
			EndIf
			dbSkip()
		EndDo		
	EndIf
	If !lAtualiza
		dbSelectArea("QEV")
		dbSkip()
		Loop
	EndIf

	// Obtem a nota de IQS do Fornecedor
	dbSelectArea("SA2")
	dbSetOrder(1)
	If dbSeek(xFilial("SA2")+QEV->QEV_FORNEC)
		If A2_FATAVA == 0 .And. Empty(A2_DTAVA)
			nIQS := 999.99
		Else
			nIQS := A2_FATAVA
		EndIf
	Else
		dbSelectArea("QEV")
		dbSkip()
		Loop
	EndIf

	// Guarda registro que está posicionado no QEV
	dbSelectArea("QEV")
	nRecQEV	:= Recno()
	cFor	:= QEV_FORNEC
	cProd	:= QEV_PRODUT

	//+------------------------------------+
	//¦ Atualizacao Automatica da Situacao ¦
	//+------------------------------------+
	// Flag que controla se atualiza a Situacao
	lAtuSit := .f.

	// Define o Indice de atualizacao
	nIndice := QEV_IQFA	// Atualizacao pelo IQF Acumulado

	If nIndice <> 999.99
		// Identifica a Classe da Situacao
		dbSelectArea("QEG")
		dbSetOrder(2)
		dbSeek(xFilial("QEG")+Str(nIndice,6,2), .T.)
		If !Eof() .And. QEG_FILIAL == xFilial("QEG")
			lAtuSit := .t.
		EndIf
	EndIf

	If lAtuSit
		cSitu	:= QEG_SITU
		cCateg	:= QEG_CATEG

		// Se Situacao for Assegurada (Categ. 1-> Skip-Lote Total),
		// verifica se Fornecedor tem IQS
		If QEG_CATEG == "1" 
			If cMvAssIQS == "N"  .And. nIQS <> 999.99 .And. nIQS < mMvIQSAss 
				// Muda Situacao p/ Qualificado (Categ. 2-> Skip-Lote 25%)
				dbSetOrder(1)
				dbSeek(xFilial("QEG"))
				While QEG_FILIAL == xFilial("QEG") .And. !Eof()
					If QEG_CATEG == "2"
						cSitu	:= QEG_SITU
						cCateg	:= QEG_CATEG
						Exit
					EndIf
					dbSkip()
				EndDo
			EndIf

		// Se Sit. for Asseg. ou Qualif. (Categ. 1 ou 2 -> Skip-Lote Total ou 25%),
		// Verifica se o IQS é >= à Nota minima p/ Qualificado
	    ElseIf QEG_CATEG $ "2"	// Skip-Lote Total ou 25%  ( Asseg. ou Qualif. )
			If lVerIQSQua .And. nIQS <> 999.99 .And. nIQS < nMvIQSQua
				// Muda Situacao p/ Pre-Qualificado (Categ. 3-> Sem Skip-Lote)
				dbSetOrder(1)
				dbSeek(xFilial("QEG"))
				While QEG_FILIAL == xFilial("QEG") .And. !Eof()
					If QEG_CATEG == "3"
						cSitu	:= QEG_SITU
						cCateg	:= QEG_CATEG
						Exit
					EndIf
					dbSkip()
				EndDo
			EndIf
		EndIf

		//Atualiza Situacao para todas as lojas do Fornecedor
		dbSelectArea("SA5")
		dbSeek(xFilial("SA5")+QEV->QEV_PRODUT+QEV->QEV_FORNEC)
		While A5_FILIAL+A5_PRODUTO+A5_FORNECE == xFilial("SA5")+QEV->QEV_PRODUT+;
				QEV->QEV_FORNEC .And. !Eof()

			If A5_ATUAL == "S"
				If cSitu <> A5_SITU
					// Guarda a Situacao e Skip-Lote anteriores
					cSituAnt	:= A5_SITU
					cSkipAnt	:= A5_SKPLOT
					cSkip		:= A5_SKPLOT

					// Guarda a Unidade do Skip-Lote anterior
					dbSelectArea("QEF")
					dbSetOrder(1)
					dbSeek(xFilial("QEF")+cSkipAnt)
					cUnidAnt := QEF_UNSKLT

					dbSelectArea("SA5")
					If FieldPos("A5_TIPATU ") > 0
						If	A5_TIPATU $ ("0/2 ") 
							RecLock("SA5",.F.)
							lAtual       := .t.
							SA5->A5_SITU := cSitu
							MsUnLock()
	
							// Gera historico da Situacao
							cEspec	:= "MATA060T"
							cCodAnt	:= cSituAnt
							M021GrHi()
						EndIf
					Else
						RecLock("SA5",.F.)
						lAtual       := .t.
						SA5->A5_SITU := cSitu
						MsUnLock()
	
						// Gera historico da Situacao
						cEspec	:= "MATA060T"
						cCodAnt	:= cSituAnt
						M021GrHi()
					Endif
					
					// Atualiza o Skip-Lote de acordo com a Situacao:
					// Se a nova categoria nao tem skip-lote associado:
					If cCateg $ "3.4"		// Sem Skip-Lote e Nao Recebe
						cSkip := Space(aTamSkl[1])
					EndIf

					// Se a categoria é skip-lote 25%, verifica o skip-lote:
					If cMvUtSk25 == "S"
						If cCateg == "2" .And. ;
							(cUnidAnt == "D" .Or. (cUnidAnt == "E" .And. QEF->QEF_QTDE > 4))
							// Assume o Skip-Lote "Controla 1 a cada 4 Entradas"
							dbSelectArea("QEF")
							dbSetOrder(2)
							For nI := 4 to 1 Step-1
								If dbSeek(xFilial("QEF")+"E"+Str(nI,4))
									cSkip := QEF->QEF_SKPLOT
									Exit
								EndIf
							Next nI
						EndIf
					Else 
						If cCateg == "2" .And. ;
							(cUnidAnt == "D" .Or. cUnidAnt == "E")
							
							// Assume o Skip-Lote 
							dbSelectArea("QEF")
							dbSetOrder(2)
							If dbSeek(xFilial("QEF")+"E"+Str(QEF->QEF_QTDE,4),.T.)
								cSkip := QEF->QEF_SKPLOT
							EndIf
						EndIf              
					EndIf

					// Se houve alteracao, grava o novo skip-lote
					If FieldPos("A5_TIPATU ") > 0
						If cSkip <> cSkipAnt .AND. A5_TIPATU $ ("0/1 ")
							RecLock("SA5", .F.)
							SA5->A5_SKPLOT	:= cSkip
							MsUnLock()
	
							// Gera historico do Skip-Lote
							cEspec	:= "MATA060L"
							cCodAnt	:= cSkipAnt
							M021GrHi()
						EndIf
					Else
						If cSkip <> cSkipAnt
							RecLock("SA5", .F.)
							SA5->A5_SKPLOT	:= cSkip
							MsUnLock()
	
							// Gera historico do Skip-Lote
							cEspec	:= "MATA060L"
							cCodAnt	:= cSkipAnt
							M021GrHi()
						EndIf
					Endif
				EndIf
			EndIf	
			dbSelectArea("SA5")
			dbSkip()
		EndDo
	EndIf

	//+--------------------------------------+
	//¦ Atualizacao Automatica do Skip-Lote  ¦
	//+--------------------------------------+
	dbSelectArea("QEV")
	// Flag que controla se atualiza o Skip-Lote
	lAtuSkip := .F.

	// Define o Indice de atualizacao
	cIndice := "QEV_IQFA"	// Atualizacao pelo IQF Acumulado

	// Calc. media dos ultimos n meses indice escolhido, se existir IQF acumulado
	If QEV_IQFA <> 999.99
		nSoma := 0
		nDiv	:= 0
		For nI := 1 to Len(aAnoMes)
			If dbSeek(xFilial("QEV")+aAnoMes[nI][1]+aAnoMes[nI][2]+cFor+cProd)
				If &cIndice <> 999.99
					nSoma := nSoma+&cIndice
					nDiv := nDiv+1
				EndIf
			EndIf
		Next nI
		dbGoTo(nRecQEV)

		// Calculo da Media
		nMedia := Iif(nDiv<>0,nSoma/nDiv,0)

		dbSelectArea("QEX")
		// Verifica se o Skip-Lote está vinculado ao IQS
		If cMvSklIQS == "S"
			// Calcula nova media com o IQS
			nNota := Iif(nIQS<>999.99,(nMedia+nIQS)/2, nMedia)

			// Verifica em que faixa do Criterio Skip-Lote se encontra
			dbSeek(xFilial("QEX")+Str(nNota,6,2), .T.)
			If !Eof() .And. QEX_FILIAL == xFilial("QEX")
				lAtuSkip := .T.
			EndIf

			If nIQS == 999.99
				// Sem IQS: pega 2 faixas anteriores
				nPos := Ascan(aQEX,QEX_VLSUP)
				nPos := Iif(nPos>2,nPos-2,1)

				// Posiciona no arquivo a faixa correspondente
				dbSeek(xFilial("QEX")+Str(aQEX[nPos],6,2))

			ElseIf nIQS < nNotaMin
				// Posiciona na 1a. faixa
				dbSeek(xFilial("QEX"))
			EndIf
		Else

			// Verifica em que faixa do Criterio Skip-Lote se encontra
			dbSeek(xFilial("QEX")+Str(nMedia,6,2), .T.)
			If !Eof() .And. QEX_FILIAL == xFilial("QEX")
				lAtuSkip := .T.
			EndIf
		EndIf

		If lAtuSkip
			// Atualiza Skip-Lote para todas as lojas do Fornecedor
			dbSelectArea("SA5")
			dbSeek(xFilial("SA5")+QEV->QEV_PRODUT+QEV->QEV_FORNEC)
			While A5_FILIAL+A5_PRODUTO+A5_FORNECE == xFilial("SA5")+QEV->QEV_PRODUT+;
					QEV->QEV_FORNEC .And. !Eof()

				cSkip := QEX->QEX_SKPLOT

				// Grava novo Skip-Lote para todas as lojas do fornecedor
				If A5_ATUAL == "S"

					// Identifica a Classe da Situacao do Prod/Fornec/Loja
					dbSelectArea("QEG")
					dbSetOrder(1)
					dbSeek(xFilial("QEG")+cSITU)

					If QEG_CATEG $ "3.4"		// Sem Skip-Lote e Nao Recebe
						cSkip := Space(aTamSkl[1])
					ElseIf QEG_CATEG == "2"	// Skip-Lote 25%
						// Verifica a Unidade do novo Skip-Lote
						dbSelectArea("QEF")
						dbSetOrder(1)
						dbSeek(xFilial("QEF")+cSkip)

						// Se nao for Controla 1/Doc. Entrada, passa p/ 1/4:
						If cMvUtSk25 == "S"
							If (QEF_UNSKLT == "D" .Or. (QEF_UNSKLT == "E" .And. QEF_QTDE > 4))
								// Assume o Skip-Lote "Controla 1 a cada 4 Entradas"
								dbSetOrder(2)
								For nI := 4 to 1 Step-1
									If dbSeek(xFilial("QEF")+"E"+Str(nI,4))
										cSkip := QEF_SKPLOT
										Exit
									EndIf
								Next nI
							EndIf
						Else 
							cSkip := QEF_SKPLOT
						EndIf	
					EndIf

					dbSelectArea("SA5")

					If FieldPos("A5_TIPATU ") > 0
						If cSkip <> A5_SKPLOT .AND. A5_TIPATU $ ("0/1 ")
							cSkipAnt := A5_SKPLOT
							RecLock("SA5", .F.)
							SA5->A5_SKPLOT	:= cSkip
							MsUnLock()
							lAtual := .t.
	
							// Gera historico do Skip-Lote
							cEspec	:= "MATA060L"
							cCodAnt	:= cSkipAnt
							M021GrHi()
						EndIf
					Else
						If cSkip <> A5_SKPLOT
							cSkipAnt := A5_SKPLOT
							RecLock("SA5", .F.)
							SA5->A5_SKPLOT	:= cSkip
							MsUnLock()
							lAtual := .t.
	
							// Gera historico do Skip-Lote
							cEspec	:= "MATA060L"
							cCodAnt	:= cSkipAnt
							M021GrHi()
						EndIf
					Endif
				EndIf
				dbSelectArea("SA5")
				dbSkip()
			EndDo
		EndIf
	EndIf

	dbSelectArea("QEV")
	dbSkip()
EndDo

If lAtual
	MsgInfo(STR0003,STR0004)	// "Atualizacao realizada com sucesso."###"Atencao"
Else
	MsgInfo(STR0005,STR0004)	// "Atualizacao nao foi necessária."###"Atencao"
EndIf

dbSelectArea("SA5")
dbSetOrder(nOrdSA5)

dbSelectArea("QEG")
dbSetOrder(nOrdQEG)

dbSelectArea("QEF")
dbSetOrder(nOrdQEF)

Return NIL

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ M021GrHi ¦ Autor ¦ Vera Lucia S. Simoes  ¦ Data ¦ 01/06/98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Grava Historico                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ QIEM021                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
// Substituido pelo assistente de conversao do AP5 IDE em 03/12/99 ==> Function M021GrHi
Static Function M021GrHi()

// Monta chave para o Historico
cChvHis := QA_CvKey(xFilial("SA5")+SA5->A5_FORNECE+SA5->A5_PRODUTO,"SA5",6)

RecLock("QA3",.T.)
QA3->QA3_FILIAL	:= xFilial("QA3")
QA3->QA3_ESPEC  := cEspec
QA3->QA3_CHAVE  := cChvHis
QA3->QA3_TEXTO	:= STR0006	// "Atualizado automaticamente pelo sistema."
QA3->QA3_DATA	:= dDataBase
QA3->QA3_DATINV	:= Inverte(dDataBase)
QA3->QA3_ANT	:= cCodAnt
MsUnLock()
Return(NIL)
