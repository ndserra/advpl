#INCLUDE "RTMSR06.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR06  ³ Autor ³Patricia A. Salomao    ³ Data ³26.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Contrato de Carreteiro                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR06                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gestao de Transporte                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RTMSR06()

Local titulo   := STR0001 //"Impressao do Contrato de Carreteiro"
Local cString  := "DTQ"
Local wnrel    := "RTMSR06"
Local cDesc1   := STR0002 //"Este programa ira listar os Contratos de Carreteiros"
Local cDesc2   := ""
Local cDesc3   := ""
Local tamanho  := "M"
Local nLimite := 132

Private NomeProg := "RTMSR06"
Private aReturn  := {STR0003,1,STR0004,2, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private cPerg    := "RTMR06"
Private nLastKey := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Filial Origem De                      ³
//³ mv_par02        	// Filial Origem Ate  	                 ³
//³ mv_par03        	// Viagem De                             ³
//³ mv_par04        	// Viagem Ate         	                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR06Imp(@lEnd,wnRel,titulo,tamanho,nLimite)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR06Imp³ Autor ³Patricia A. Salomao    ³ Data ³27.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR06			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTMSR06Imp(lEnd,wnRel,titulo,tamanho,nLimite)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nContrat, cDesc1, cDesc2
Local aCabec := {}
Local cCdrOri, cCdrDes, cDesCidDes, cDesCidOri, cCidOrigem, cCidDestino
Local nBegin   :=0
Local nLinha   :=0
Local nTotCTRC :=0
Local nPesoTot :=0
Local nValFre:=nValAdi:=nValPdg:=nIRRF:=nSEST:=nTotValFre:=0
Local lImp := .F.
Local nCol, aFrete, cArea
Local cAreaSM0 := SM0->( GetArea() )
Local nX       := 0
Local cTMSOPdg   := SuperGetMV( 'MV_TMSOPDG',, '0' )
Local aLocQTC    := {}
Local nIniPos    := 0
Private cTitulo
Private cbtxt  := Space(10)
Private cbcont := 0
Private m_pag  := 1
Private Li:=80
Private nTipo  := aReturn[4]
Private cMens:=cLibSeg := " "
Private nTotCapac

Inclui := .F.

dbSelectArea("DTY")
dbSetOrder(2)	

MsSeek(xFilial("DTY")+mv_par01+mv_par03, .T.)

SetRegua(LastRec())

Do While !Eof() .And. DTY->DTY_FILIAL == xFilial("DTY") .And. DTY->DTY_FILORI <= mv_par02 .And.;
		DTY->DTY_VIAGEM <= mv_par04
	
	If DTY->DTY_FILORI < mv_par01 .Or. DTY->DTY_VIAGEM < mv_par03
		DTY->(dbSkip())
		Loop
	EndIf
	
	IncRegua()
	If Interrupcao(@lEnd)
		Exit
	Endif
	
	lImp := .F.
	nContrat := DTY_NUMCTC
	Li:=80
	
	cDesc1 :=STR0005 + cFilAnt + " " + DTY_VIAGEM //"Viagem : "
	If cTMSOPdg <> '0'
		DTR->(DbSetOrder(1))
		DTR->(MsSeek(xFilial('DTR') + DTY->(DTY_FILORI+DTY_VIAGEM)))	
		cDesc2 :=STR0006 + DTY_NUMCTC  + ' - ' + STR0045 +  DTR->DTR_PRCTRA //"No. Contrato : #### - Processo de Transporte: ###"
	Else
		cDesc2 :=STR0006 + DTY_NUMCTC
	EndIf
	
	
	nTotCTRC:=nPesoTot:=0
	nTotCapac:=nValFre:=nValAdi:=nValPdg:=nIRRF:=nSEST:=nTotValFre:=0
	
	DTQ->( dbSetOrder(2) )
	If DTQ->( !MsSeek(xFilial("DTQ") + cFilAnt + DTY->DTY_VIAGEM) .Or. (DTQ_STATUS != "1" .And. DTQ_SERTMS != "2") )
		dbSkip()
		Loop
	EndIf    	
	
	cMens := If(!Empty(DTQ->DTQ_CODOBS), E_MsMM(DTQ->DTQ_CODOBS,70), " ")
	
	//-- Complemento de Viagem
	DTR->(dbSetOrder(1))
	DTR->(MsSeek(xFilial("DTR") + cFilAnt + DTY->DTY_VIAGEM))
	
	//-- Manifesto de Carga
	DTX->(dbSetOrder(3))
	DTX->(MsSeek(xFilial("DTX") + cFilAnt + DTY->DTY_VIAGEM))
	
	Do While DTX->( !Eof() .And. (DTX_FILORI == cFilAnt) .And. (DTX_VIAGEM == DTY->DTY_VIAGEM) )
		nPesoTot += DTX->DTX_PESO
		nTotCTRC += DTX->DTX_QTDDOC
		DTX->(dbSkip())
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿      	
	//³	Verifica a Regiao de Origem e o Ultimo Destino da Rota     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 		 	
	aRet := TMSRegDca(DTQ->DTQ_ROTA)
	
	cCdrOri := If(Len(aRet)>0,aRet[Len(aRet)][1],"")
	cCdrDes := If(Len(aRet)>0,aRet[Len(aRet)][2],"")	
	cDesCidOri := Posicione("DUY",1,xFilial("DUY")+cCdrOri,"DUY->DUY_DESCRI")
	cDesCidDes := Posicione("DUY",1,xFilial("DUY")+cCdrDes,"DUY->DUY_DESCRI")
	cEstCidDes := DUY->DUY_EST
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o array aCabec (Informacoes iniciais do cabecalho)              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !RTMSR06Cabec(@aCabec, nLimite)
		dbSkip()
		Loop
	EndIf
	
	nValFre := DTY->DTY_VALFRE
	nValAdi := DTY->DTY_ADIFRE
	nValPdg := DTY->DTY_VALPDG
	nIRRF   := DTY->DTY_IRRF
	nSEST   := DTY->DTY_SEST
	nTotValFre := (nValFre+nValPdg)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o cabecalho                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aFrete := {}
	
	DTX->(dbSetOrder(3))
	DTX->(MsSeek(xFilial("DTX") + cFilAnt + DTY->DTY_VIAGEM))
	Do While DTX->( !Eof() .And. (DTX_FILIAL+DTX_FILORI+DTX_VIAGEM == xFilial("DTX")+cFilAnt+DTY->DTY_VIAGEM) )
		lImp := .T.
		If Li > 60
			Li := Cabec(cTitulo, cDesc1, cDesc2, NomeProg, Tamanho) + 1
			For nX := 1 To Len(aCabec)
				@Li,000 PSay aCabec[nX]
				VerLin(@Li,1)				
			Next
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime o Manifesto em duas colunas.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCol := 0
		Do While DTX->( !Eof() .And. (DTX_FILIAL+DTX_FILORI+DTX_VIAGEM == xFilial("DTX")+cFilAnt+DTY->DTY_VIAGEM) ) .and. (nCol < 90)
			// Obtem Cidade Origem e Destino no SM0.
			cArea := GetArea()
			SM0->(MsSeek(cEmpAnt+DTX->DTX_FILMAN, .T.))
			cCidOrigem := SM0->M0_CIDENT
			SM0->(MsSeek(cEmpAnt+DTX->DTX_FILDCA, .T.))
			cCidDestino := SM0->M0_CIDENT
			RestArea(cAreaSM0)
			RestArea(cArea)
			
			@Li,nCol 		 PSay DTX->DTX_FILMAN
			@Li,nCol + 003	 PSay DTX->DTX_MANIFE Picture PesqPict("DTX","DTX_MANIFE")
			@Li,nCol + 012  PSay Left(cCidOrigem,15)
			@Li,nCol + 029  PSay Left(cCidDestino,15)
			@Li,nCol + 046  PSay DTX->DTX_PESO   Picture PesqPict("DTX","DTX_PESO")
			
			nCol += 62
			
			DTX->(dbSkip())
			
		EndDo
		
		VerLin(@Li,1)				  		
		
	EndDo
	
	If lImp
		If AliasInDic('DEN')
			DEN->(DbSetOrder(1))
			If DEN->(MsSeek(xFilial('DEN') + DTY->(DTY_FILORI+DTY_VIAGEM)))
				@Li,000 PSay PadC(STR0048,132,"=") // " P O N T O S   D E   A P O I O "
				VerLin(@Li,1)
				@Li,000 PSay STR0049 //"Previsao          Posto                                           Endereco                                Telefone        Vl. Diesel"
				VerLin(@Li,1)
				While !DEN->(EoF()) .And. DEN->(DEN_FILIAL+DEN_FILORI+DEN_VIAGEM) == xFilial('DEN') + DTY->(DTY_FILORI+DTY_VIAGEM)
					SA2->(DbSetOrder(1))
					SA2->(MsSeek(xFilial('SA2') + DEN->(DEN_CODFOR+DEN_LOJFOR)))
			
					@Li,000 PSay 	DtoC(DEN->DEN_DTPREV) + ' - ' + Transform(DEN->DEN_HRPREV, '@R 99:99') + Space(02) +;
									DEN->DEN_CODFOR + '/' + DEN->DEN_LOJFOR + ' - ' + IIF(Len(DEN->DEN_CODFOR) > 6, Left(SA2->A2_NOME, 30), Left(SA2->A2_NOME, 34)) + Space(02) +;
									Left(SA2->A2_END, 38) + Space(02) +;
									Left(SA2->A2_TEL, 14) + Space(07) +;
									Transform(DEN->DEN_VALCOM, '@E 9.999')
					VerLin(@Li,1)
					DEN->(DbSkip())
				EndDo
				@Li,000 PSay STR0047 // "Os precos dos combustiveis estao em vigor na data/hora da impressao do documento, porem estao sujeitos a alteracao."
			EndIf
		EndIf
		VerLin(@Li,1)			
		@Li,000 PSay Replicate("-",132)
		VerLin(@Li,1)
		@Li,000 PSay PadC(AllTrim(STR0007) + ' ' + AllTrim(cDesCidOri) + ' ' + AllTrim(STR0008) + ' ' + AllTrim(cDesCidDes),132) //"Trajeto de ###" para "
		VerLin(@Li,1)				
		@Li,000 PSay Replicate("-",132)
		VerLin(@Li,1)
		@Li,000 PSay STR0009 + TransForm(nPesoTot ,PesqPict("DTX","DTX_PESO"))   //"Peso Total..............: "
		@Li,045 PSay STR0010 + TransForm(nTotCapac,PesqPict("DA3","DA3_CAPACM")) //"Peso Pago...............: "
		VerLin(@Li,1)				
		@Li,000 PSay STR0012 + TransForm(nValFre,PesqPict("DTR","DTR_VALFRE")) //"Valor Frete.............: "
		@Li,045 PSay STR0013 + TransForm(nValAdi,PesqPict("DTR","DTR_ADIFRE")) //"Adiantamento............: "
		VerLin(@Li,1)				
		@Li,000 PSay STR0014 + TransForm(nValPdg,PesqPict("DTR","DTR_VALPDG")) //"Valor Pedagio...........: "
		@Li,045 PSay "IRRF....................: " + TransForm(nIRRF,PesqPict("DTY","DTY_IRRF"))
		VerLin(@Li,1)				
		@Li,000 PSay STR0016 + TransForm(nTotValFre,PesqPict("DTR","DTR_VALFRE")) //"Valor Total.............: "
		@Li,045 PSay "SEST/SENAT..............: " + TransForm(nSEST,PesqPict("DTY","DTY_SEST"))
		VerLin(@Li,1)				
		nSldPag := nTotValFre - (nValAdi+nIRRF+nSEST)
		@Li,045 PSay STR0017  + TransForm(nSldPag,PesqPict("DTR","DTR_VALFRE")) //"Saldo no Destino........: "
		VerLin(@Li,2)
		cExtenso := Extenso(nSldPag,.F.,1)
		nLinhas  := MlCount(cExtenso,60)
		For nLinha := 1 To nLinhas
			If nLinha == 1
				@Li,000 PSay STR0018 //"Saldo a Pagar por Extenso : "
			Endif
			@Li,30 PSay "( " + AllTrim(MemoLine(cExtenso,60,nLinha)) + Replicate("*", 60 - Len(AllTrim(cExtenso))) + " )"
			VerLin(@Li,1)		
		Next
		VerLin(@Li,1)				
		@Li,000 PSay STR0019 + AllTrim(cDesCidDes) + "  " + cEstCidDes //"O Saldo sera pago em "
		VerLin(@Li,2)				
		@Li,000 PSay PadC(AllTrim(STR0020),132) //"O Motorista e ou proprietarios(s) assumem obrigacoes aqui estabelecidas,"
		VerLin(@Li,1)				
		@Li,000 PSay PadC(AllTrim(STR0021),132) //"bem como as do termo de responsabilidade inerentes ao transporte anexo."
		VerLin(@Li,2)				
		@Li,000 PSay AllTrim(SM0->M0_CIDCOB) + ", " + DTOC(DTY->DTY_DATCTC)
		VerLin(@Li,2)				
		@Li,000 PSay "_____________________________________"
		VerLin(@Li,2)				
		@Li,000 PSay Replicate("-",132)
		VerLin(@Li,1)				
		@Li,000 PSay STR0022 //"Declaro ter recebido o saldo deste contrato, dando total e plena quitacao :"
		VerLin(@Li,2)		
		@Li,000 PSay STR0042 + "_____________________________" //"Local: "
		@Li,050 PSay STR0023 + "___/___/___" //"Data:"
		VerLin(@Li,2)				
		/* Imprime o proprietario e motorista do veiculo. */
		@Li,000 PSay STR0024 + "_____________________________________" //"Ass.Motorista : "
		VerLin(@Li,1)				
		@Li,000 PSay 	DTY->DTY_CODFOR + "/" + DTY->DTY_LOJFOR + " - " + AllTrim(Posicione("SA2", 1, xFilial("SA2") +;
						DTY->(DTY_CODFOR + DTY_LOJFOR), "A2_NREDUZ")) + " - " + DTY->DTY_CODMOT + " - " + AllTrim(Posicione("DA4", 1, xFilial("DA4") +;
						DTY->DTY_CODMOT, "DA4_NREDUZ"))
		VerLin(@Li,2)				
		@Li,000 PSay STR0025 //"Data Cheg           Horas            Valor Premio          Perc"
		VerLin(@Li,1)
		RTMSR06Frt(@Li, cCdrDes, DTY->DTY_DATCTC, DTY->DTY_HORCTC, nValFre)
		VerLin(@Li,2)				
		@Li,000 PSay PadC(" "+STR0026+" ",132,"=") //"O B S E R V A C O E S"
		VerLin(@Li,1)		 		
		nLinha:= MLCount(cMens,80)
		@Li,000 PSAY MemoLine(cMens,80,1)
		For nBegin := 2 To nLinha
			VerLin(@Li,1)		 							
			@Li,000 PSAY Memoline(cMens,80,nBegin)
		Next nBegin
		VerLin(@Li,2)				
		If DTY->(FieldPos('DTY_LOCQTC')) > 0
			aLocQTC := RetSx3Box( Posicione('SX3', 2, 'DTY_LOCQTC', 'X3CBox()' ),,, Len(DTY->DTY_LOCQTC) )
			nIniPos := Ascan(aLocQTC,{|x| DTY->DTY_LOCQTC $ x[2]})
			nIniPos := Iif(nIniPos == 0,Len(aLocQTC),nIniPos)
			@Li,000 PSay STR0046 + 	aLocQTC[nIniPos,3] // "Local de Quitacao"
			If DTY->DTY_LOCQTC == '1'
				@Li,030 PSay Posicione('SM0',1,cEmpAnt + DTY->DTY_FILQTC,'M0_NOMECOM')
			Else
				@Li,030 PSay Posicione('SA2',1,xFilial('SA2') + DTY->(DTY_FORQTC+DTY_LOJQTC), 'A2_COD' + '/' + 'A2_LOJA' + ' - ' + 'A2_NOME')
			EndIf
			VerLin(@Li,1)
		EndIf
		@Li,000 PSay STR0027 + AllTrim(cLibSeg) //"Numero da Consulta Telerisco: "
		@Li,050 PSay STR0028 +Transform(DTY->DTY_HORCTC,"@R 99:99") //"Hora Emissao Contrato: "
		@Li,085 PSay "CTRC's:" + TransForm(nTotCTRC, PesqPict("DTX","DTX_QTDDOC"))
		VerLin(@Li,1)				
	EndIf
	
	dbSelectArea("DTY")
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
±±³Fun‡„o    ³RTMSR06Cab³ Autor ³Patricia A. Salomao    ³ Data ³27.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta Cabecalho                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR06Cabec(ExpN1,ExpN2,ExpA1)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpA1 - Array contendo as informacoes iniciais do cabecalho³±±
±±³          ³ ExpN1 - Tamanho                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR06			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTMSR06Cabec(aCabec, nLimite)
aCabec := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica os Veiculos da Viagem                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCabec,PadC(" "+STR0029+" ",132,"="))  //"V E I C U L O S"
Aadd(aCabec,STR0030) //"Veiculo   Nome             Cor                   Tipo                       Placa     Cidade           UF  Ano "
//            xxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxx  xxxxxxxxxxxxxxx  xx  xxxx  xxxxxx       //-- Lista Veiculos
//            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
//            0         1         2         3         4         5         6         7         8         9        10        11        12        13

DTR->(dbSetOrder(1))
DTR->(MsSeek(xFilial("DTR") + cFilAnt + DTY->DTY_VIAGEM ))
Do While !DTR->(Eof()) .And. DTR->DTR_FILIAL+DTR->DTR_FILORI+DTR->DTR_VIAGEM == xFilial('DTR')+cFilAnt+DTY->DTY_VIAGEM
	If DA3->(MsSeek(xFilial('DA3')+DTR->DTR_CODVEI))
		Aadd(aCabec, DA3->DA3_COD + ;
			Space( 2 ) + Padr( Tabela( 'M6', DA3->DA3_MARVEI, .F. ), 20 ) + ;
			Space( 2 ) + Padr( Tabela( 'M7', DA3->DA3_CORVEI, .F. ), 20 ) + ;
			Space( 2 ) + Padr( TMSTipoVei( DTR->DTR_CODVEI ), 25 ) + ;
			Space( 2 ) + DA3->DA3_PLACA  + ;
			Space( 2 ) + DA3->DA3_MUNPLA + ;
			Space( 2 ) + DA3->DA3_ESTPLA + ;
			Space( 2 ) + DA3->DA3_ANOFAB )
		nTotCapac += DA3->DA3_CAPACM
	EndIf
	If !Empty(DTR->DTR_CODRB1) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB1))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
		//³ Monta uma linha com os dados do 1o. Reboque                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aCabec, DA3->DA3_COD + ;
			Space( 2 ) + Padr( Tabela( 'M6', DA3->DA3_MARVEI, .F. ), 20 ) + ;
			Space( 2 ) + Padr( Tabela( 'M7', DA3->DA3_CORVEI, .F. ), 20 ) + ;
			Space( 2 ) + Padr( TMSTipoVei( DTR->DTR_CODVEI ), 25 ) + ;
			Space( 2 ) + DA3->DA3_PLACA  + ;
			Space( 2 ) + DA3->DA3_MUNPLA + ;
			Space( 2 ) + DA3->DA3_ESTPLA + ;
			Space( 2 ) + DA3->DA3_ANOFAB )
	EndIf
	If !Empty(DTR->DTR_CODRB2) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB2))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
		//³  Monta uma linha com os dados do 2o. Reboque                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aCabec, DA3->DA3_COD + ;
			Space( 2 ) + Padr( Tabela( 'M6', DA3->DA3_MARVEI, .F. ), 20 ) + ;
			Space( 2 ) + Padr( Tabela( 'M7', DA3->DA3_CORVEI, .F. ), 20 ) + ;
			Space( 2 ) + Padr( TMSTipoVei( DTR->DTR_CODVEI ), 25 ) + ;
			Space( 2 ) + DA3->DA3_PLACA  + ;
			Space( 2 ) + DA3->DA3_MUNPLA + ;
			Space( 2 ) + DA3->DA3_ESTPLA + ;
			Space( 2 ) + DA3->DA3_ANOFAB )
	EndIf					
	DTR->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica os Proprietarios dos Veiculos da Viagem             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCabec,PadC(" "+STR0031+" ",132,"="))  //"P R O P R I E T A R I O S"
Aadd(aCabec,STR0032) //"Veiculo   Nome                                      Endereco                                  Cidade           UF    CGC/CPF"
//            xxxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxx  xx

DTR->(dbSetOrder(1))
DTR->(MsSeek(xFilial("DTR") + cFilAnt + DTY->DTY_VIAGEM ))
Do While !DTR->(Eof()) .And. DTR->DTR_FILIAL+DTR->DTR_FILORI+DTR->DTR_VIAGEM == xFilial('DTR')+cFilAnt+DTY->DTY_VIAGEM
	DA3->(dbSetOrder(1))
	SA2->(dbSetOrder(1))
	If DA3->(MsSeek(xFilial('DA3')+DTR->DTR_CODVEI)) .And. SA2->(MsSeek(xFilial('SA2')+DA3->DA3_CODFOR+DA3->DA3_LOJFOR))
		Aadd(aCabec,DA3->DA3_COD+"  "+SA2->A2_NOME + "  " + SA2->A2_END+ "  " +SA2->A2_MUN+ "  "+;
			SA2->A2_EST +  "   " +SA2->A2_CGC)
	EndIf
	DTR->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica os Motoristas da Viagem                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCabec,PadC(" "+STR0033+" ",132,"=")) //"M O T O R I S T A"
Aadd(aCabec,STR0034) //"Nome                 e                    Endereco                                  Cidade           UF  CNH/PGU"
//            xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxx  xx
If !DUP->(MsSeek(xFilial("DUP") + cFilAnt + DTY->DTY_VIAGEM))
	Help(' ', 1, 'RTMSR061',,STR0043 + DTY->DTY_VIAGEM,5,11)		//-- Nao foram informados Motoristas para a Viagem No :
	Return .f.
EndIf

While DUP->(!Eof()) .And. DUP->DUP_FILORI == cFilAnt .And. DUP->DUP_VIAGEM == DTY->DTY_VIAGEM
	DA4->(dbSetOrder(1))
	If DA4->(!MsSeek(xFilial('DA4')+DUP->DUP_CODMOT))
		Help(' ', 1, 'RTMSR062',,STR0044 + DUP->DUP_CODMOT,5,11)		//-- Motorista nao encontrado ! //'Motorista No : '###
		Return .f.
	EndIf
	
	Aadd(aCabec,Substr(DA4->DA4_NOME,1,40) +  "  " + Substr(DA4->DA4_END,1,40)+ "  " + Substr(DA4->DA4_MUN,1,20) + "  " + DA4->DA4_EST +"  "+DA4->DA4_NUMCNH )
	
	DUP->(dbSkip())
EndDo	

cTitulo    := STR0035 + STR0037 //"Contrato de Transporte - Carreto "TERCEIRO"
cLibSeg    := DA4->DA4_LIBSEG

Aadd(aCabec," ")
Aadd(aCabec,STR0038) //"Os Motoristas e ou Proprietarios acima discriminados, se obrigam por este, a transportar a carga, no trajeto e nas condicoes abaixo"
Aadd(aCabec,STR0039) //"como segue :  "
Aadd(aCabec," ")

Aadd(aCabec,PadC(" "+STR0040+" ",132,"="))  //" D E T A L H A M E N T O    D A   C A R G A"
Aadd(aCabec,STR0041) //"MANIFESTO   FIL.ORIGEM   FIL.DESTINO                    PESO   MANIFESTO    FL.ORIGEM   FL.DESTINO              PESO "

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR06Frt³ Autor ³  Antonio C Ferreira   ³ Data ³22.04.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime os Fretes da Viagem                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR06Frt(ExpN1,ExpN2,ExpN3)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpN1 - Linha do Relatorio.                                ³±±
±±³          ³ ExpN2 - Matriz com os codigos do frete do DTX.             ³±±
±±³          ³ ExpN3 - Data do Contrato p/ Calculo de Frete               ³±±
±±³          ³ ExpN4 - Hora do Contrato p/ Calculo de Frete               ³±±
±±³          ³ ExpN5 - Total de Frete.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR06			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTMSR06Frt(Li, cCdrDes, dDtInicial, cHrInicial, nTFrete)

Local dDtFinal, cHrFinal, cTabFre, cSeek
Local nPerc, nValor

DTR->(MsSeek(xFilial("DTR") + cFilAnt + DTY->DTY_VIAGEM + "2" + DTY->DTY_CODMOT))
cTabFre := DTR->DTR_TABCAR


DTM->(DbSetOrder(1))	
DTM->(MsSeek(cSeek := xFilial("DTM") + cTabFre + DTQ->DTQ_ROTA))

Do While DTM->(!eof() .and. (DTM_FILIAL+DTM_TABCAR+DTM_ROTA == cSeek) )
	dDtFinal := dDtInicial
	cHrFinal := cHrInicial
	//-- Calcula a data e hora prevista
	SomaDiaHor( @dDtFinal, @cHrFinal, TmsHrToInt(DTM->DTM_PONTUA) )
	
	if (DTM->DTM_TIPPRE == '2')     // Percentual
		nPerc  := DTM->DTM_PREMIO
		nValor := ((nTFrete * nPerc) / 100)
	else
		nValor := DTM->DTM_PREMIO
		nPerc  := ((nValor * 100) / nTFrete)
	endif
	
	@Li,010 PSay dDtFinal
	@Li,030 PSay cHrFinal
	@Li,045 PSay TransForm(nValor, PesqPict("DTM","DTM_PREMIO"))
	@Li,069 PSay TransForm(nPerc, "@R 999.99 %")
	
	VerLin(@Li,1)
	
	DTM->(DbSkip())
	
EndDo

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³VerLin    ³ Autor ³Patricia A. Salomao    ³ Data ³27.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Soma Linha                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ VerLin(ExpN1,ExpN2)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpN1 - No. da Linha atual                                 ³±±
±±³          ³ ExpN2 - No. de Linhas que devera ser somado                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR06			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VerLin(Li,nSoma)
Li+=nSoma
If Li > 70
	Li:=1
EndIf
Return
