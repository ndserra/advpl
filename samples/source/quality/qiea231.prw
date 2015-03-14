#INCLUDE "RWMAKE.CH" 
#INCLUDE "QIEA231.CH"

User Function qiea231() 

SetPrvt("LCONT,CINDINF,LCONSISTE,NFATIQI,NFATIPR,NFATIES")
SetPrvt("CIE230MES,AFATIQP,CFATAPR,CFATREP,CFATLU,DDTINI")
SetPrvt("DDTFIM,NMVMESACU,AANOMES,CANOINI,CANOFIM,CMESINI")
SetPrvt("CMESFIM,NI,CINDEX,CKEY,CCOND,NINDEX")
SetPrvt("NORDSA5,NORDQEV,NORDQE0,NORDQEK,CMVQTREJ,NMVDIATR")
SetPrvt("LFLGMEN,LFLGACU,ATAMLAB,CFOR,CPROD,AFATINF")
SetPrvt("NCTENT,NCTDEM,NQTDENT,NNIDI,NTOTDEM,NQTREJ")
SetPrvt("NLTINSP,NLTSKIP,NQTINSP,NQTSKIP,NY,CSEEK")
SetPrvt("CCHVMED,NSOMA,NAUX,NX,NIA,NK")
SetPrvt("NIQP,NIQS,NFC,NIQI,NIPR,NIPO")
SetPrvt("NITR,NIES,NIQF,NRECQEV,AFATACUM,ALOTENT")
SetPrvt("ALOTDEM,AIQD,AIPO,NCTMES,LACUMULA,NIQPA")
SetPrvt("NIQIA,NIPOA,NIQFA,CALIAS,NRETFAT,ALAUAC")
SetPrvt("NIPRA,NDIV,NIESA,NPOS,")

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ QIEA231  ¦ Autor ¦ Vera Lucia S. Simoes  ¦ Data ¦ 14/05/98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Calculo do IQF Individual (para uma Filial)                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ QIEA230 - RDMAKE                                           ¦¦¦
¦¦+-----------------------------------------------------------------------¦¦¦
¦¦¦			ATUALIZACOES SOFRIDAS DESDE A CONSTRUÇAO INICIAL.				  ¦¦¦
¦¦+-----------------------------------------------------------------------¦¦¦
¦¦¦Programador ¦ Data	¦ BOPS ¦  Motivo da Alteracao 						  ¦¦¦
¦¦+------------+--------+------+------------------------------------------¦¦¦
¦¦¦Vera        ¦17/03/99¦------¦ Usa Dias de Atraso em modulo             ¦¦¦
¦¦¦Vera        ¦15/04/99¦------¦ Inclusao da Loja do Fornecedor           ¦¦¦
¦¦¦Vera        ¦03/11/99¦------¦ Conceito de Liberacao Urgente            ¦¦¦
¦¦¦Vera        ¦14/01/00¦------¦ Inclusao do arquivo CH                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
//+-------------------------------------------------------------------------+
//¦ Formulas:                                                               ¦
//¦ IQP por Tabela Completa:                                                ¦
//¦   IA = ((Fator A*Qtd. A + Fator B*Qtd. B + ...)/(Qtd. A+Qtd. B)) * 100  ¦
//¦   Se IQI por Tabela:                                                    ¦
//¦     IQP = (100 - K) - Total Demerito   (K é obtido em funcao do IA)     ¦
//¦   Se IQI por Soma:                                                      ¦
//¦     IQP = IA                                                            ¦
//¦ IQP por Tabela Simplificada:                                            ¦
//¦   IQP = 101-((Qt.A+(Fat. B*100)*Qt.B+(Fat. C*100)*Qt.C)/(Qt.A+Qt.B+...))¦
//¦                                                                         ¦
//¦ IQI por Tabela:                                                         ¦
//¦   IQI = IQP * FC   (FC é obtido em funcao do IQS)                       ¦
//¦ IQI por Soma:                                                           ¦
//¦   IQI = 0.80 * IQP + 0.20 * IQS                                         ¦
//¦                                                                         ¦
//¦ IES (IPO):                                                              ¦
//¦   IPO = (1- (Somat.(Tam.Lote*Dias Atraso)/(MV_QDIAATR*Qtd.Total))) * 100¦
//¦                                                                         ¦
//¦ ICT = IPR = 0                                                           ¦
//¦                                                                         ¦
//¦ IQF:                                                                    ¦
//¦   IQF = Fat.IQI * IQI + Fat.IPR * IPR + Fat.IES * IES + Fat.ICT * ICT   ¦
//¦                                                                         ¦
//¦ Calculo do Acumulado:                                                   ¦
//¦ Flexivel:                                                               ¦
//¦   Pelo menos 1 Entrada nos n meses                       -> Calcula     ¦
//¦ Rigido:                                                                 ¦
//¦   Menos de n/2 meses com Entradas                        -> Nao Calcula ¦
//¦   De n/2 a n-1 meses c/ Entrada: menos de 6 Entradas     -> Nao Calcula ¦
//¦                              6 ou mais Entradas          -> Calcula     ¦
//¦   n meses com Entradas                                   -> Calcula     ¦
//+-------------------------------------------------------------------------+
// Obs.: Para as Entradas que tiverem laudo com categoria Liberado Urgente,
//       o sistema assumira Laudo Aprovado. Se for dado um laudo diferente de
//       Aprovado, no cadastro de Resultados, o sistema exibira mensagem para
//       o usuario, orientando-o a gerar novamente o Indice de Qualidade.
*/

// Indica se prossegue o programa
lCont := .T.

//+-------------------------------------------------------------------------+
//¦ Verifica se as Tabelas do IA e do IQS estao cadastradas                 ¦
//+-------------------------------------------------------------------------+
dbSelectArea("QEJ")
dbSetOrder(1)
If !dbSeek(xFilial("QEJ")+"1")
	MsgAlert(STR0001,STR0002)	// "Favor cadastrar a Tabela do Indice Aceitacao (IA)"###"Atencao"
	Return .F.
EndIf
If !dbSeek(xFilial("QEJ")+"2")
	MsgAlert(STR0003,STR0002)	// "Favor cadastrar a Tabela do Indice Qualidade Sistema (IQS)"###"Atencao"
	Return .F.
EndIf

//+-------------------------------------------------------------------------+
//¦ Verifica se cadastrou os Indices do IQF                                 ¦
//+-------------------------------------------------------------------------+
dbSelectArea("QF1")
dbSetOrder(1)
If !dbSeek(xFilial("QF1"))
	MsgAlert(STR0004,STR0002)	// "Favor cadastrar os Indices do IQF"###"Atencao"
	Return .F.
EndIf

//+-------------------------------------------------------------------------+
//¦ Obtem os fatores de todos os indices do IQF calculados neste RDMAKE.    ¦
//¦ Obs.: Se incluir algum indice (do usuario) deve checar aqui se existe   ¦
//¦       seu respectivo fator.                                             ¦
//+-------------------------------------------------------------------------+
// IQI
cIndInf		:= "IQI"
lConsiste	:= .T.
A231IndC()
If !lCont
	Return .F.
EndIf	
nFatIQI	:= nRetFat

// IPR
cIndInf		:= "IPR"
lConsiste	:= .F.	// Se colocar o calculo, passar para .T.
A231IndC()
If !lCont
	Return .F.
EndIf	
nFatIPR	:= nRetFat

// IES
cIndInf		:= "IES"
lConsiste	:= .T.
A231IndC()
If !lCont
	Return .F.
EndIf	
nFatIES	:= nRetFat

//+---------------------------------------+
//¦ Transforma mes informado para strzero ¦
//+---------------------------------------+
cIE230Mes := StrZero(Val(cIE230Mes),2)

//+-------------------------------------------------------------------------+
//¦ Define os Fatores do IQP                                                ¦
//+-------------------------------------------------------------------------+
aFatIQP := {}
cFatApr := " "
cFatRep := " "
cFatLU  := " "

dbSelectArea("QED")
dbSetOrder(1)
dbSeek(xFilial("QED"))
While !Eof() .And. QED_FILIAL == xFilial("QED")
	If QED_CATEG == "4"	// Fator com categoria Liberado Urgente
		cFatLU := QED_CODFAT
	Else
		Aadd(aFatIQP,{ QED_CODFAT, SuperVal(QED_FATOR), QED_CATEG, 0})

		If QED_CATEG == "1"	// Fator Aprovado
			cFatApr := QED_CODFAT
		ElseIf QED_CATEG == "3"	// Fator Reprovado
			cFatRep := QED_CODFAT
		EndIf
	EndIf
	dbSkip()
EndDo

// Ordena vetor pela Categoria+Cod. Laudo
aFatIQP := aSort(aFatIQP,,, { | x,y | x[3]+x[1] < y[3]+y[1] } )

//+-------------------------------------------------------------------------+
//¦ Define o periodo a ser considerado para a geracao IQF mensal            ¦
//+-------------------------------------------------------------------------+
If cIE230Dia $ "30.31"
	dDtIni := Ctod("01/"+cIE230Mes+"/"+cIE230Ano)
	dDtFim := UltDia(cIE230Mes,cIE230Ano)	// QAXFUN
Else
	dDtIni := Ctod(StrZero(Val(cIE230Dia)+1,2)+"/"+;
						Iif(cIE230Mes == "01","12",StrZero(Val(cIE230Mes)-1,2))+"/"+;
						Iif(cIE230Mes == "01",StrZero(Val(cIE230Ano)-1,4),cIE230Ano))
	dDtFim := Ctod(cIE230Dia+"/"+cIE230Mes+"/"+cIE230Ano)
EndIf

//+-------------------------------------------------------------------------+
//¦ Define o periodo a ser considerado para a geracao IQF acumulado         ¦
//¦ Volta n meses a partir do mes/ano solicitado, de acordo com parametro.  ¦
//+-------------------------------------------------------------------------+

// Obtem o numero de meses para o calculo do acumulado
nMvMesAcu := GetMv("MV_QMESACU")
aAnoMes   := {}
cAnoIni   := cIE230Ano
cAnoFim   := cIE230Ano
cMesIni   := cIE230Mes
cMesFim   := cIE230Mes

For nI := 1 to nMvMesAcu
	Aadd(aAnoMes, { cAnoIni, cMesIni })
	cMesIni := StrZero(Val(cMesIni)-1,2)
	If cMesIni == '00'
		cAnoIni := StrZero(Val(cAnoIni)-1,4)
		cMesIni := '12'
	EndIf
Next nI
// Ordena vetor por Ano+Mes
aAnoMes := aSort(aAnoMes,,, { | x,y | x[1]+x[2] < y[1]+y[2] } )
cMesIni := aAnoMes[1][2]
cAnoIni := aAnoMes[1][1]
cMesFim := aAnoMes[Len(aAnoMes)][2]
cAnoFim := aAnoMes[Len(aAnoMes)][1]

//+---------------------------+
//¦ Guarda os indices ativos  ¦
//+---------------------------+
dbSelectArea("SA5")
nOrdSA5 := IndexOrd()

dbSelectArea("QEV")
nOrdQEV := IndexOrd()

dbSelectArea("QE0")
nOrdQE0 := IndexOrd()

//+-------------------------------------------------------------------------+
//¦ Seleciona as Entradas do periodo                                        ¦
//+-------------------------------------------------------------------------+
dbSelectArea("QEK")
nOrdQEK := IndexOrd()
// Abre indice com as ultimas Entradas por Fornec./Produto (independente da Loja)
// Quando gerar Indice por Fornecedor/Loja, pode usar o order 1, e excluir o 9,
// se nao utilizar em mais nenhum lugar.

//dbSetOrder(9)	// Fornecedor+Produto+Data Entrada invertida+Lote invertido
dbSetOrder(8)	// Fornecedor+Produto+Data Entrada invertida+Lote invertido
If !Empty(cIE230For)
	dbSeek(xFilial("QEK")+cIE230For)
Else
	dbSeek(xFilial("QEK"))
EndIf

// Parametro que indica se acumula a qtde. rejeitada no laudo reprovado
cMvQtRej := GetMv("MV_QQTDREJ")

// Parametro que indica o numero maximo de dias em atraso
nMvDiAtr := GetMv("MV_QDIAIPO")

// Flag que indica se há dados para a geracao dos Indices Mensais
lFlgMen := .f.
// Flag que indica se somente há dados para a geracao dos Indices Acumulados
lFlgAcu := .f.

// Define Tamanho do campo Laboratorio
aTamLab := Array(2)
aTamLab := TamSX3("QEL_LABOR")

QDProcRegua(QEK->(RecCount()))

While QEK_FILIAL == xFilial("QEK") .And. !Eof()
	// Deixa os Ifs por data pq. se for Top Connect ou Geracao p/ Data Laudo, nao cria IndRegua

	QDIncProc(STR0006+QEK_FORNEC+"   "+STR0007 +QEK_PRODUT )	// "Fornecedor : "###"Produto : "
	
	If !Empty(cIE230For) .And. QEK_FORNEC <> cIE230For
		dbSkip()
		Loop
	EndIf

	// Verifica se nao é Produto de Permuta
	dbSelectArea("SA5")
	dbSetOrder(2)
	dbSeek(xFilial("SA5")+QEK->QEK_PRODUT+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)
	If A5_FABREV == "P"	// Permuta
		dbSelectArea("QEK")
		dbSkip()
		Loop
	EndIf

	cFor  := QEK->QEK_FORNEC
	cProd := QEK->QEK_PRODUT

	//+----------------------------------------------------------------------+
	//¦ Calculos dos Indices Mensais Informados                              ¦
	//+----------------------------------------------------------------------+
	dbSelectArea("QF1")
	dbSetOrder(1)
	dbSeek(xFilial("QF1"))
	
	aFatInf := {}
	While !Eof() .And. QF1_FILIAL == xFilial("QF1")
		If QF1_CALC == "I" .And. QF1_FATIQF <> 0	// Indice informado mensalmente
			dbSelectArea("QE0")
			dbSetOrder(1)
			If	!dbSeek(xFilial("QE0")+cIe230Ano+cIe230Mes+cFor+cProd+QF1->QF1_INDICE)
				MsgAlert(STR0005+;	// "Indice Mensal nao informado para o Produto/Fornecedor: "
					Alltrim(cProd)+" / "+Alltrim(cFor)+" ("+QF1->QF1_INDICE +")",STR0002)	// "Atencao"
				lCont := .F.
				Exit
			Else
				// Guarda num array o valor mensal multiplicado pelo seu fator IQF
				Aadd(aFatInf, QF1->QF1_FATIQF * QE0->QE0_VALOR) 
			EndIf
			dbSelectArea("QF1")	
		EndIf
		dbSkip()
	EndDo

	// Se nao houver indice mensal informado, retorna sem calcular nada
	If !lCont
		Exit
	EndIf

	//+----------------------------------------------------------------------+
	//¦ Indices Mensais Calculados                                           ¦
	//+----------------------------------------------------------------------+

	// Define as variaveis a serem zeradas p/ cada Fornecedor/Produto
	nCtEnt	:= 0		// Numero total de Entradas
	nCtDem	:= 0		// Qtde de Entradas demeritadas
	nQtdEnt	:= 0		// Qtde total entregue (Tam. Lote)
	nNidi	:= 0		// Qtde entregue * N. dias de atraso
	nTotDem	:= 0		// Total de demeritos das Entradas
	nQtRej	:= 0		// Total de qtde. rejeitada do forn./item
	nLtInsp	:= 0		// Total de lotes inspecionados
	nLtSkip	:= 0		// Total de lotes em skip-lote
	nQtInsp	:= 0		// Qtde. total (tam. lote) inspecionada
	nQtSkip	:= 0		// Qtde. total (tam. lote) em skip-lote

	// Zera a ocorrencia de cada Fator
	For nI := 1 to Len(aFatIQP)
		aFatIQP[nI][4] := 0
	Next nI

	// Seleciona as Entradas do Fornecedor/Produto
	dbSelectArea("QEK")
	While QEK_FILIAL+QEK_FORNEC+QEK_PRODUT == xFilial("QEK")+cFor+cProd .And. !Eof()

		// Localiza o laudo geral da Entrada
		dbSelectArea("QEL")
		dbSetOrder(1)
		If !dbSeek(xFilial("QEL")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+;
				Dtos(QEK->QEK_DTENTR)+QEK->QEK_LOTE+Space(aTamLab[1]))
			dbSelectArea("QEK")
			dbSkip()
			Loop
		EndIf

		// Considera aqui a Data do Laudo
		If QEL_DTLAUD < dDtIni .Or. QEL_DTLAUD > dDtFim .Or. Empty(QEL_LAUDO)
			dbSelectArea("QEK")
			dbSkip()
			Loop
		EndIf
		// Seta flag que indica que tem dados para geracao dos indices mensais
		lFlgMen := .t.

		// Contabiliza no. de Entradas
		nCtEnt := nCtEnt+1

		dbSelectArea("QEL")
		// Identifica o Laudo da Entrada
        // Se o Laudo da Entrada tiver categoria Liberado Urgente, considera como Aprovado
		nI := Ascan(aFatIQP, {|x| x[1] == Iif(QEL_LAUDO == cFatLU,cFatApr,QEL_LAUDO) })

		// Identifica o Laudo Reprovado
		nY := Ascan(aFatIQP, {|x| x[1] == cFatRep })

		// IQP por Tabela Completa
		If cMvQtRej == "S"	// Cons. qtde. rejeitada
			// Acumula a Qtde. Rejeitada no laudo reprovado
			// Acumula a diferenca do tam. lote e a qtde. rej. no laudo Entrada		
			If !Empty(QEL_QTREJ)
				If nI > 0
					aFatIQP[nI][4] := aFatIQP[nI][4]+;
										(SuperVal(QEK->QEK_TAMLOT)-SuperVal(QEL->QEL_QTREJ))
				EndIf									
				If nY > 0
					aFatIQP[nY][4] := aFatIQP[nY][4]+SuperVal(QEL->QEL_QTREJ)
				EndIf	
			Else     
				If nI > 0
					aFatIQP[nI][4] := aFatIQP[nI][4]+SuperVal(QEK->QEK_TAMLOT)
				EndIf	
			EndIf
		Else         
			If nI > 0
				aFatIQP[nI][4] := aFatIQP[nI][4]+SuperVal(QEK->QEK_TAMLOT)
			EndIf	
		EndIf

		// Acumula Ocorrencias e Qtde. Lote - Inspec. e em Skip-Lote
		If QEK->QEK_VERIFI == 2	// Certificada
			nLtSkip := nLtSkip+1
			nQtSkip := nQtSkip+SuperVal(QEK->QEK_TAMLOT)
		Else
			nLtInsp := nLtInsp+1
			nQtInsp := nQtInsp+SuperVal(QEK->QEK_TAMLOT)
		EndIf

		// Acumula a Qtde. Rejeitada
		nQtRej := nQtRej+SuperVal(QEL->QEL_QTREJ)

		// Verifica se a Entrada é demeritada
		If nI > 0
			If aFatIQP[nI][3] <> "1"
				nCtDem := nCtDem+1
			EndIf
		EndIf
		// Acumula valores para o calculo do IPO
		// Utiliza Dias em Atraso em modulo porque pode ser negativo
		nQtdEnt := nQtdEnt+SuperVal(QEK->QEK_TAMLOT)
		If QEK->QEK_DIASAT <> 0
			nNiDi := nNiDi+(SuperVal(QEK->QEK_TAMLOT)*;
					Iif(Abs(QEK->QEK_DIASAT)>nMvDiAtr,nMvDiAtr,Abs(QEK->QEK_DIASAT)))
		EndIf

		// Acumula pontos de demeritos oriundos das NCs
		cSeek := QEK->QEK_PRODUT+QEK->QEK_REVI+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
				Dtos(QEK->QEK_DTENTR)+QEK->QEK_LOTE
		dbSelectArea("QER")
		dbSetOrder(1)
		dbSeek(xFilial("QER")+cSeek)
		QDProcRegua(QER->(RecCount()))
			
		While QER_FILIAL+QER_PRODUT+QER_REVI+QER_FORNEC+QER_LOJFOR+;
				Dtos(QER_DTENTR)+QER_LOTE==xFilial("QER")+cSeek .And. !Eof()

			QDincProc(STR0007+QER_PRODUT)	// "Produto : "
			// Obtem chave de ligacao da medicao com os outros arquivos
			cChvMed := QER->QER_CHAVE
			// Verifica se a medicao tem NC
			dbSelectArea("QEU")
			dbSetOrder(1)
			dbSeek(xFilial("QEU")+cChvMed)
			While ! Eof() .And. QEU_FILIAL == xFilial("QEU") .And. QEU_CODMED == cChvMed 
				If QEU_DEMIQI == "S"
					dbSelectArea("QEE")
					dbSetOrder(1)
					dbSeek(xFilial("QEE")+QEU->QEU_CLASSE)
					// Acumula os pontos relativos às classes das NCs
					nTotDem := nTotDem+QEE_PONTOS
				EndIf
				dbSelectArea("QEU")
				dbSkip()
			EndDo
			dbSelectArea("QER")
			dbSkip()
		EndDo
		dbSelectArea("QEK")
		dbSkip()
	EndDo

	If nCtEnt == 0 
		Loop
	EndIf

	//+----------------------------------------------------------------------+
	//¦ Calculo do IQI Mensal                                                ¦
	//+----------------------------------------------------------------------+

	// Calculo do IQP por Tabela Completa
	nSoma := nAux := 0
	For nX := 1 to Len(aFatIQP)
		nAux := nAux+(aFatIQP[nX][2] * aFatIQP[nX][4])	// Fator * Ocorr. Laudo
		nSoma := nSoma+aFatIQP[nX][4]
	Next nX
	nIA := Iif(nSoma<>0, (nAux/nSoma)*100, 0)

	// Calculo do IQI por Tabela
	// Obtem o Fator K, de acordo com o IA
	dbSelectArea("QEJ")
	dbSetOrder(1)
	dbSeek(xFilial("QEJ")+"1"+Str(nIA,6,2),.T.)
	nK := SuperVal(QEJ_FATOR)
	nIQP := ( 100 - nK ) - nTotDem
	nIQP := Iif(nIQP < 0, 0, nIQP)

	// Calculo do IQS
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+cFor)
	If A2_FATAVA == 0 .And. Empty(A2_DTAVA)
		nIQS := 999.99
	Else
		nIQS := A2_FATAVA
	EndIf

	// Calculo do IQI por Tabela
	dbSelectArea("QEJ")
	dbSetOrder(1)
	If nIQS <> 999.99
		// Obtem o Fator FC, de acordo com o IQS
		dbSeek(xFilial("QEJ")+"2"+Str(nIQS,6,2),.T.)
		nFC := SuperVal(QEJ_FATOR)
	Else
		// Obtem o Fator FC para quando nao tiver a nota do IQS (999.99)
		If dbSeek(xFilial("QEJ")+"2"+Str(nIQS,6,2))
			nFC := SuperVal(QEJ_FATOR)
		Else
			// IQP por Tabela Completa, assume 1
			nFC := 1

		EndIf
	EndIf
	nIQI := nIQP * nFC

	//+----------------------------------------------------------------------+
	//¦ Calculo do IPR Mensal                                                ¦
	//+----------------------------------------------------------------------+
	nIPR := 0

	//+----------------------------------------------------------------------+
	//¦ Calculo do IES Mensal                                                ¦
	//+----------------------------------------------------------------------+
	// Calcula o IPO
	nIPO := Iif(nQtdEnt<>0, (1 - (nNiDi / (nMvDiAtr * nQtdEnt))) * 100, 0)

	nITR := 0
	nIES := nIPO

	//+----------------------------------------------------------------------+
	//¦ Calculo do IQF Mensal                                                ¦
	//+----------------------------------------------------------------------+
	// Indices calculados:
	nIQF := nFatIQI*nIQI + nFatIPR*nIPR + nFatIES*nIES

	// Indices informados:
	For nI := 1 to Len(aFatInf)
		nIQF := nIQF + aFatInf[nI]
	Next nI

	//+----------------------------------------------------------------------+
	//¦ Gravacao dos indices mensais calculados                              ¦
	//+----------------------------------------------------------------------+
	// Grava somente os laudos que tiveram ocorrencia no mes/ano
	dbSelectArea("QEW")
	dbSetOrder(1)
	For nX := 1 to Len(aFatIQP)
		If aFatIQP[nX][4] <> 0
			If !dbSeek(xFilial("QEW")+cFor+cProd+cIE230Ano+cIE230Mes+aFatIQP[nX][1])
				RecLock("QEW",.T.)
				QEW->QEW_FILIAL	:= xFilial("QEW")
				QEW->QEW_ANO	:= cIE230Ano
				QEW->QEW_MES	:= cIE230Mes
				QEW->QEW_FORNEC	:= cFor
				QEW->QEW_PRODUT	:= cProd
				QEW->QEW_LAUDO 	:= aFatIQP[nX][1]
			Else
				RecLock("QEW",.F.)
			EndIf
			QEW->QEW_QTDLAU	:= aFatIQP[nX][4]
			MsUnLock()
		EndIf
	Next nX

	// Grava os indices mensais
	dbSelectArea("QEV")
	dbSetOrder(1)
	If !dbSeek(xFilial("QEV")+cIE230Ano+cIE230Mes+cFor+cProd)
		RecLock("QEV",.T.)
		QEV->QEV_FILIAL	:= xFilial("QEV")
		QEV->QEV_ANO		:= cIE230Ano
		QEV->QEV_MES		:= cIE230Mes
		QEV->QEV_FORNEC	:= cFor
		QEV->QEV_PRODUT	:= cProd
	Else
		RecLock("QEV",.F.)
	EndIf
	QEV->QEV_LOTENT	:=	nCtEnt
	QEV->QEV_LOTDEM	:=	nCtDem
	QEV->QEV_LOTINS	:=	nLtInsp
	QEV->QEV_LOTSKP	:=	nLtSkip
	QEV->QEV_QTDINS	:=	nQtInsp
	QEV->QEV_QTDSKP	:=	nQtSkip
	QEV->QEV_QTDREJ	:=	nQtRej
	QEV->QEV_IQP	:=	nIQP
	QEV->QEV_IQD	:=	nTotDem
	QEV->QEV_IQS	:=	nIQS
	QEV->QEV_IQI	:=	nIQI
	QEV->QEV_IPO	:=	nIPO
	QEV->QEV_ITR	:=	nITR
	QEV->QEV_IES	:=	nIES
	QEV->QEV_IPR	:=	nIPR
	QEV->QEV_IQF	:=	nIQF
	QEV->QEV_DTGER	:=	dDataBase
	nRecQEV := Recno()
	MsUnLock()

	//+----------------------------------------------------------------------+
	//¦ Calculo do IQF Acumulado                                             ¦
	//+----------------------------------------------------------------------+

	// Vetor que guarda a qtde nos n meses de cada Fator Laudo
	aFatAcum := Array(len(aFatIQP),nMvMesAcu+1)
	For nI := 1 to len(aFatIQP)
		aFatAcum[nI][1] := aFatIQP[nI][1]
		For nX := 1 to nMvMesAcu
			aFatAcum[nI][nX+1] := 0
		Next nX
	Next nI

	// Vetores que terao as respect. somas nos n meses 
	aLotEnt := Array(nMvMesAcu)	// Lotes entregues
	Afill(aLotEnt,0)

	aLotDem := Array(nMvMesAcu)	// Lotes demeritados
	Afill(aLotDem,0)

	aIQD := Array(nMvMesAcu)	// IQDs
	Afill(aIQD,0)

	aIPO := Array(nMvMesAcu)	// IPOs
	Afill(aIPO,0)

	// Seleciona os indices dos meses a serem cons. p/ o acumulado
	dbSetOrder(2)
	dbSeek(xFilial("QEV")+cFor+cProd+cAnoIni+cMesIni,.T.)
	While QEV_FILIAL+QEV_FORNEC+QEV_PRODUT == xFilial("QEV")+cFor+cProd .and. !Eof()
		If QEV_ANO+QEV_MES < cAnoIni+cMesIni .Or. QEV_ANO+QEV_MES > cAnoFim+cMesFim
			Exit
		EndIf
		nI := Ascan(aAnoMes, {|x| x[1]+x[2] == QEV_ANO+QEV_MES })

		// Acumula as qtdes. de cada Laudo
		For nX := 1 to Len(aFatAcum)
			dbSelectArea("QEW")
			dbSetOrder(1)
			If dbSeek(xFilial("QEW")+QEV->QEV_FORNEC+QEV->QEV_PRODUT+;
					QEV->QEV_ANO+QEV->QEV_MES+aFatAcum[nX][1])
				aFatAcum[nX][nI+1] := aFatAcum[nX][nI+1]+QEW_QTDLAU
			EndIf
		Next nX

		// Acumula Lotes entregues, demeritados, IQDs e IPOs
		dbSelectArea("QEV")
		aLotEnt[nI] := aLotEnt[nI]+QEV_LOTENT
		aLotDem[nI] := aLotDem[nI]+QEV_LOTDEM
		aIQD[nI] 	:= aIQD[nI]+Iif(QEV_IQD<>999.99,QEV_IQD,0)
		aIPO[nI] 	:= aIPO[nI]+Iif(QEV_IPO<>999.99,QEV_IPO,0)

		dbSkip()
	EndDo
	
	// Verifica a possibilidade de geracao do acumulado
	nCtMes := nCtEnt := 0
	For nX := 1 to nMvMesAcu
		If aLotEnt[nX] <> 0
			nCtMes := nCtMes+1
			nCtEnt := nCtEnt+aLotEnt[nX]
		EndIf
	Next nX

	// Criterio Flexivel
	lAcumula := Iif(nCtEnt > 0, .t., .f.)

	// Chama a funcao que calcula o acumulado
	nIQPa := nIQIa := nIPOa := nIQFa := nTotDem := 999.99
	If lAcumula
		A231CaAc()
	EndIf
	//+----------------------------------------------------------------------+
	//¦ Gravacao dos indices acumulados gerados                              ¦
	//+----------------------------------------------------------------------+
	dbSelectArea("QEV")
	dbGoto(nRecQEV)
	RecLock("QEV",.F.)
	QEV->QEV_IQPA	:= nIQPa
	QEV->QEV_IQDA	:= nTotDem	
	QEV->QEV_IQIA	:= nIQIa
	QEV->QEV_IPOA	:= nIPOa
	QEV->QEV_IQFA	:= nIQFa
	MsUnLock()
	dbSelectArea("QEK")
EndDo

If lCont
	//+----------------------------------------------------------------------+
	//¦ Calc. o IQF Acum. p/ os produtos/fornecedores s/ Entrada no mes/ano  ¦
	//+----------------------------------------------------------------------+

	dbSelectArea("QEV")
	dbSetOrder(2)

	dbSelectArea("SA5")
	dbSetOrder(1)

	If Empty(cIE230For)
		dbSeek(xFilial("SA5"))
	Else
		dbSeek(xFilial("SA5")+cIE230For)
	EndIf
	
	QDProcRegua(RecCount())
	While A5_FILIAL == xFilial("SA5") .And. !Eof()
		QDIncProc(STR0006+A5_FORNECE+"   "+STR0007+A5_PRODUTO )	// "Fornecedor : "###"Produto : "
		
		If !Empty(cIE230For) .And. A5_FORNECE <> cIE230For
			Exit
		EndIf

		// Verifica se nao é Produto de Permuta
		If A5_FABREV == "P"	// Permuta
			dbSkip()
			Loop
		EndIf

		cFor := A5_FORNECE
		cProd := A5_PRODUTO

		// Verifica se gerou IQF com Entrada no mes/ano p/ o Produto/Fornecedor
		dbSelectArea("QEV")
		If dbSeek(xFilial("QEV")+cFor+cProd+cIE230Ano+cIE230Mes)
			If QEV_LOTENT <> 0
				dbSelectArea("SA5")
				dbSkip()
				Loop
			EndIf
		EndIf

		//+----------------------------------------------------------------------+
		//¦ Calculos dos Indices Mensais Informados                              ¦
		//+----------------------------------------------------------------------+
		aFatInf := {}
		dbSelectArea("QF1")
		dbSetOrder(1)
		dbSeek(xFilial("QF1"))
		While !Eof() .And. QF1_FILIAL == xFilial("QF1")
			If QF1_CALC == "I" .And. QF1_FATIQF <> 0	// Indice informado mensalmente
				dbSelectArea("QE0")	
				dbSetOrder(1)
				If	dbSeek(xFilial("QE0")+cIe230Ano+cIe230Mes+cFor+cProd+QF1->QF1_INDICE)
					// Guarda num array o valor mensal multiplicado pelo seu fator IQF
					Aadd(aFatInf, QF1->QF1_FATIQF * QE0->QE0_VALOR) 
				EndIf
				dbSelectArea("QF1")	
			EndIf
			dbSkip()
		EndDo

		//+---------------------------------------------------------+
		//¦ Indices Mensais Calculados                              ¦
		//+---------------------------------------------------------+
		// Vetor que guarda a qtde nos n meses de cada Fator Laudo
		aFatAcum := Array(len(aFatIQP),nMvMesAcu+1)
		For nI := 1 to len(aFatIQP)
			aFatAcum[nI][1] := aFatIQP[nI][1]
			For nX := 1 to nMvMesAcu
				aFatAcum[nI][nX+1] := 0
			Next nX
		Next nI

		// Vetores que terao as respect. somas nos n meses 
		aLotEnt := Array(nMvMesAcu)	// Lotes entregues
		Afill(aLotEnt,0)

		aLotDem := Array(nMvMesAcu)	// Lotes demeritados
		Afill(aLotDem,0)

		aIQD := Array(nMvMesAcu)	// IQDs
		Afill(aIQD,0)

		aIPO := Array(nMvMesAcu)	// IPOs
		Afill(aIPO,0)

		// Verifica se existe pelo menos 1 Entrada nos ultimos n meses
		dbSelectArea("QEV")
		dbSeek(xFilial("QEV")+cFor+cProd+cAnoIni+cMesIni, .T.)
		While QEV_FILIAL+QEV_FORNEC+QEV_PRODUT == xFilial("QEV")+cFor+cProd .and. !Eof()
	
			If QEV_ANO+QEV_MES < cAnoIni+cMesIni .Or. QEV_ANO+QEV_MES > cAnoFim+cMesFim
				Exit
			EndIf
			nI := Ascan(aAnoMes, {|x| x[1]+x[2] == QEV_ANO+QEV_MES })

			// Acumula as qtdes. de cada Laudo
			dbSelectArea("QEW")
			dbSetOrder(1)
			For nX := 1 to Len(aFatAcum)
				If dbSeek(xFilial("QEW")+QEV->QEV_FORNEC+QEV->QEV_PRODUT+;
						QEV->QEV_ANO+QEV->QEV_MES+aFatAcum[nX][1])
					aFatAcum[nX][nI+1] := aFatAcum[nX][nI+1]+QEW_QTDLAU // A 1a. pos. é o laudo
				EndIf
			Next nX

			// Acumula Lotes entregues, demeritados, IQDs e IPOs
			dbSelectArea("QEV")
			aLotEnt[nI] := aLotEnt[nI]+QEV_LOTENT
			aLotDem[nI] := aLotDem[nI]+QEV_LOTDEM
			aIQD[nI] 	:= aIQD[nI]+Iif(QEV_IQD<>999.99,QEV_IQD,0)
			aIPO[nI] 	:= aIPO[nI]+QEV_IPO

			dbSkip()
		EndDo

		// Verifica se nos ult. n meses houve algum mes com Entrada
		nCtMes := 0
		For nX := 1 to nMvMesAcu
			If aLotEnt[nX] <> 0
				nCtMes := nCtMes+1
			EndIf
		Next nX
		If nCtMes == 0
			dbSelectArea("SA5")
			dbSkip()
			Loop
		EndIf
	
		// Verifica a possibilidade de geracao do acumulado
		nCtMes := nCtEnt := 0
		For nX := 1 to nMvMesAcu
			If aLotEnt[nX] <> 0
				nCtMes := nCtMes+1
				nCtEnt := nCtEnt+aLotEnt[nX]
			EndIf
		Next nX

		// Criterio Flexivel
		lAcumula := Iif(nCtEnt > 0, .t., .f.)

		// Define o IQS do Fornecedor
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+cFor)
		If A2_FATAVA == 0 .And. Empty(A2_DTAVA)
			nIQS := 999.99
		Else
			nIQS := A2_FATAVA
		EndIf

		// Chama a funcao que calcula o acumulado
		nIQPa := nIQIa := nIPOa := nIQFa := nTotDem := 999.99
		If lAcumula
			A231CaAc()
		EndIf

		// Seta flag que indica que gerou o acumulado p/ os itens s/ Entrada
		lFlgAcu := .t.

		//+----------------------------------------------------------------------+
		//¦ Gravacao acumulados p/ forn./prod. s/ Entradas no mes/ano            ¦
		//+----------------------------------------------------------------------+
		// Nao grava as qtdes. no QEW porque somente tem os acumulados
		dbSelectArea("QEV")
		dbSetOrder(2)
		If !dbSeek(xFilial("QEV")+cFor+cProd+cIE230Ano+cIE230Mes)
			RecLock("QEV",.T.)
			QEV->QEV_FILIAL	:= xFilial("QEV")
			QEV->QEV_ANO	:= cIE230Ano
			QEV->QEV_MES	:= cIE230Mes
			QEV->QEV_FORNEC	:= cFor
			QEV->QEV_PRODUT	:= cProd
		Else
			RecLock("QEV",.F.)
		EndIf
		QEV->QEV_LOTENT	:=	0
		QEV->QEV_LOTDEM	:=	0
		QEV->QEV_LOTINS	:=	0
		QEV->QEV_LOTSKP	:=	0
		QEV->QEV_QTDINS	:=	0
		QEV->QEV_QTDSKP	:=	0
		QEV->QEV_QTDREJ	:=	0
		QEV->QEV_IQP	:=	999.99
		QEV->QEV_IQD	:=	999.99
		QEV->QEV_IQS	:=	nIQS
		QEV->QEV_IQI	:=	999.99
		QEV->QEV_IPO	:=	999.99
		QEV->QEV_ITR	:=	999.99
		QEV->QEV_IES	:=	999.99
		QEV->QEV_IPR	:=	999.99
		QEV->QEV_IQF	:=	999.99
		QEV->QEV_IQPA	:= nIQPa
		QEV->QEV_IQDA	:= nTotDem	
		QEV->QEV_IQIA	:= nIQIa
		QEV->QEV_IPOA	:= nIPOa
		QEV->QEV_IQFA	:= nIQFa
		QEV->QEV_DTGER	:=	dDataBase
		MsUnLock()

		dbSelectArea("SA5")
		dbSkip()
	EndDo

	dbSelectArea("QEV")
	dbSetOrder(1)

	//+--------------------------------------------------------------+
	//¦ Avisa se gerou os indices mensais/ acumulados ou N.D.A.      ¦
	//+--------------------------------------------------------------+
	If !lFlgMen
		If !lFlgAcu
			MsgAlert(STR0008,STR0002)	// "Nao h  dados para a geracao Ind. Qual. neste mes/ano"###"Atencao"
		Else
			MsgAlert(STR0009,STR0002)	// "Somente foram gerados os Indices acumulados, para produtos sem Entrada no mes/ano"###"Atencao"
		EndIf
	EndIf
EndIf
dbSelectArea("QEK")
dbSetOrder(nOrdQEK)

dbSelectArea("SA5")
dbSetOrder(nOrdSA5)

dbSelectArea("QEV")
dbSetOrder(nOrdQEV)

dbSelectArea("QE0")
dbSetOrder(nOrdQE0)

Return NIL

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ A231IndC ¦ Autor ¦ Vera Lucia S. Simoes  ¦ Data ¦ 31/07/98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Identifica o Fator do Indice no Calculo do IQF (QF1)       ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ QIEA231                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 03/12/99 ==> Function A231IndC
Static Function A231IndC()
cAlias	:= Alias()
nRetFat	:= 0.00

dbSelectArea("QF1")
dbSetOrder(1)
If !dbSeek(xFIlial("QF1")+cIndInf)
	If lConsiste
		MsgAlert(STR0010 + cIndInf,STR0002)	// "Indice nao cadastrado: "###"Atencao"
		lCont := .F.	// Forca saida do programa
	EndIf
Else
	nRetFat := QF1_FATIQF
EndIf

dbSelectArea(cAlias)
Return NIL

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ A231CaAc ¦ Autor ¦ Vera Lucia S. Simoes  ¦ Data ¦ 21/05/98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Calculo do IQF Acumulado  (para uma Filial)                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ QIEA231                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function A231CaAc()

//+----------------------------------------------------------------------+
//¦ Calculo dos Acumulados para os Indices Calculados                    ¦
//+----------------------------------------------------------------------+

// Calcula o IQI Acumulado
// Acumula a qtde. de cada Fator (de todos os meses)
aLauAc := {}
For nI := 1 to Len(aFatAcum)
	nSoma := 0
	For nX := 1 to nMvMesAcu
		nSoma := nSoma+aFatAcum[nI][nX+1]
	Next nX
	Aadd(aLauAc, { aFatAcum[nI][1], nSoma })
Next nI

// Acumula os demeritos
nTotDem := 0
For nI := 1 to nMvMesAcu
	nTotDem := nTotDem+aIQD[nI]
Next nI

//+----------------------------------------------------------------------+
//¦ Calculo do IQI Acumulado                                             ¦
//+----------------------------------------------------------------------+

// Calculo do IQPa por Tabela Completa
nSoma	:= 0
nAux	:= 0
For nX := 1 to Len(aLauAc)
	nAux := nAux+(aFatIQP[nX][2] * aLauAc[nX][2]) // Fator * Ocorr. Acum. Laudo
	nSoma := nSoma+aLauAc[nX][2]
Next nX
nIA := Iif(nSoma<>0, (nAux/nSoma)*100, 0)

// Calculo do IQIa por Tabela
// Obtem o Fator K, de acordo com o IA
dbSelectArea("QEJ")
dbSetOrder(1)
dbSeek(xFilial("QEJ")+"1"+Str(nIA,6,2),.T.)
nK := SuperVal(QEJ_FATOR)
nIQPa := ( 100 - nK ) - nTotDem
nIQPa := Iif(nIQPa < 0, 0, nIQPa)

// Calculo do IQS
dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2")+cFor)
If A2_FATAVA == 0 .And. Empty(A2_DTAVA)
	nIQS := 999.99
Else
	nIQS := A2_FATAVA
EndIf

// Calculo do IQIa por Tabela
dbSelectArea("QEJ")
dbSetOrder(1)
If nIQS <> 999.99
	// Obtem o Fator FC, de acordo com o IQS
	dbSeek(xFilial("QEJ")+"2"+Str(nIQS,6,2),.T.)
	nFC := SuperVal(QEJ_FATOR)
Else
	// Obtem o Fator FC para quando nao tiver a nota do IQS (999.99)
	If dbSeek(xFilial("QEJ")+"2"+Str(nIQS,6,2))
		nFC := SuperVal(QEJ_FATOR)
	Else
		// IQP por Tabela Completa, assume 1
		nFC := 1

	EndIf
EndIf
nIQIa := nIQPa * nFC

//+----------------------------------------------------------------------+
//¦ Calculo do IPR Acumulado                                             ¦
//+----------------------------------------------------------------------+
nIPRa := 0

//+----------------------------------------------------------------------+
//¦ Calculo do IES Acumulado                                             ¦
//+----------------------------------------------------------------------+

// Calcula o IPOa: Media dos IPOs dos n meses
nSoma := nDiv := nIPOa := 0
For nX := 1 to nMvMesAcu
	If aLotEnt[nX] <> 0
		nSoma := nSoma+aIPO[nX]
		nDiv := nDiv+1
	EndIf
Next nX
If nDiv <> 0
	nIPOa := nSoma / nDiv
EndIf

nIESa := nIPOa


//+----------------------------------------------------------------------+
//¦ Calculos dos Acumulados para os Indices Informados: media            ¦
//+----------------------------------------------------------------------+
aFatInf := {}
dbSelectArea("QF1")
dbSetOrder(1)
dbSeek(xFilial("QF1"))
While !Eof() .And. QF1_FILIAL == xFilial("QF1")
	If QF1_CALC == "I"	// Indice informado mensalmente
		dbSelectArea("QE0")
		dbSetOrder(1)
		For nI := 1 to Len(aAnoMes)
			If	dbSeek(xFilial("QE0")+aAnoMes[nI,1]+aAnoMes[nI,2]+cFor+cProd+QF1->QF1_INDICE)
				nPos := Ascan(aFatInf, {|x| x[1] == QF1->QF1_INDICE })
				If nPos == 0
					// Guarda o Indice, a soma valores mensais, no. de meses, Fator Indice no calc. IQF
					Aadd(aFatInf, {QF1->QF1_INDICE, QE0->QE0_VALOR, 1, QF1->QF1_FATIQF} )
				Else
					aFatInf[nPos,2] := aFatInf[nPos,2]+QE0->QE0_VALOR
					aFatInf[nPos,3] := aFatInf[nPos,3]+1
				EndIf
			EndIf
		Next nI
		dbSelectArea("QF1")	
	EndIf
	dbSkip()
EndDo

//+----------------------------------------------------------------------+
//¦ Calculo do IQF Acumulado                                             ¦
//+----------------------------------------------------------------------+
// Indices calculados
nIQFa := nFatIQI*nIQIa + nFatIPR*nIPRa + nFatIES*nIESa

// Indices informados: Media dos valores mensais
For nI := 1 to Len(aFatInf)
	nIQFa := nIQFa + ((aFatInf[nI,2] / aFatInf[nI,3])*aFatInf[nI,4])
Next nI
Return NIL
