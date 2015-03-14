#INCLUDE "rtmsr03.ch"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RTMSR03  ³ Autor ³Patricia A. Salomao    ³ Data ³18.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Romaneio de Coleta                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR03                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gestao de Transporte                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR03()

Local titulo   := STR0001 //"Romaneio de Coleta"
Local cString  := "DTQ"
Local wnrel    := "RTMSR03"
Local cDesc1   := STR0002 //"Este programa ira listar o Romaneio de Coleta"
Local cDesc2   := ""
Local cDesc3   := ""
Local tamanho  := "G"

Private NomeProg := "RTMSR03"
Private aReturn  := {STR0003,1,STR0004,1, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private cPerg    := "RTMR03"
Private nLastKey := 0

//Chamada do relatorio padrao
If FindFunction("TRepInUse") .And. TRepInUse()
	TMSR570()
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Viagem De                                ³
//³ mv_par02        	// Viagem Ate            	                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("RTMR03",.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RTMSR03Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR03Imp³ Autor ³Patricia A. Salomao    ³ Data ³18.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR03			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR03Imp(lEnd,wnRel,titulo,tamanho)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1      := ""
Local cDesc2      := ""
//Local Cabec1      := ""        
//Local Cabec2      := ""
Local cString     := ""
Local cViagem     := ""
Local aCabec      := {}
Local lImp        := .F.
Local lSE         := .F.
Local nCountVei   := 0
Local nCountMot   := 0
Local nCountAju   := 0
Local nTotPed     := 0
Local nTotPeso    := 0
Local nTotVol     := 0
Local nTamMaxCol  := 180
Local nA          :=0
Local nX          :=0

//  "Fil.Orig. Documento   Solicitante                               Endereco                                  Bairro                            Vols.           Peso Chegada        Hora Chg  Saida          Hora Sai"
//  xx         xxxxxx     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  123456    123456789 ____/____/____ ____:____ ____/____/____ ____:____
//  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis utilizadas para Impressao do cabecalho e rodape.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cbtxt  := Space(10)
Private cbcont := 0
Private m_pag  := 1
Private Li     := 80
Private nTipo  := aReturn[4]

Inclui := .F.
SM0->(dbSeek(cEmpAnt+cFilAnt, .T.))

//-- Viagens
DTQ->(dbSetOrder(1))    

//-- Rotas
DA8->(dbSetOrder(1))    

//-- Composicao do Frete
DT8->(dbSetOrder(2))    

//-- Cotacao de Frete
DT4->(dbSetOrder(1))    

//-- Solicitacao de Coleta
DT5->(dbSetOrder(4))    

//-- Solicitantes
DUE->(dbSetOrder(1))    

//-- Endereco de Solicitantes
DUL->(dbSetOrder(1))    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta Arquivo de Trabalho                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("DUD")
dbSetOrder(2)  

MsSeek(xFilial("DUD") + cFilAnt + mv_par01, .T.)

SetRegua(LastRec())

Do While !Eof() .And. DUD->DUD_FILIAL == xFilial("DUD") .And. DUD->DUD_FILORI == cFilAnt .And.;
	DUD->DUD_VIAGEM <= mv_par02

	If DUD->DUD_VIAGEM < mv_par01
		DUD->(dbSkip())
		Loop
	EndIf

	cViagem := DUD_VIAGEM
	
	// DOCUMENTOS DE TRANSPORTE
	DT6->( MsSeek(xFilial("DT6") + DUD->(DUD_FILDOC + DUD_DOC + DUD_SERIE)) )
	
	If  Empty(cViagem) .Or. (DT6->DT6_DOCTMS != "1")  // Somente Coleta
	    IncRegua()
	    If Interrupcao(@lEnd)
		   Exit
	    Endif

		dbSkip()
		Loop
	EndIf
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o array aCabec (Informacoes iniciais do cabecalho)              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nCountVei:=nCountMot:=nCountAju:=0
	
	RTMSR03Cabec(@nCountVei,@nCountMot,@nCountAju,@aCabec, cViagem, nTamMaxCol)
	
	cDesc1 := STR0013 + cFilAnt + " " + cViagem  // Viagem: ## ######
	cDesc2 := STR0014 + AllTrim(DA8->DA8_COD) + " - " + AllTrim(DA8->DA8_DESC)  // Rota: ### - #######
	
	nTotPed:=nTotPeso:=nTotVol:=0
	li   := 80
	nCol := 0		
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o cabecalho                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do While !Eof() .And. DUD_FILIAL+DUD_FILORI+DUD_VIAGEM == xFilial("DUD")+cFilAnt+cViagem
	    
	    IncRegua()
	    If Interrupcao(@lEnd)
		   Exit
	    Endif

		// DOCUMENTOS DE TRANSPORTE
		DT6->( MsSeek(xFilial("DT6") + DUD->(DUD_FILDOC + DUD_DOC + DUD_SERIE)) )
	
		If  (DT6->DT6_DOCTMS != "1")  // Somente Coleta
			dbSkip()
			Loop
		EndIf
	
		If Li > 55
			Cabec(Titulo, cDesc1, cDesc2, NomeProg, Tamanho)
			For nA := 1 to len(aCabec)
				@ Li++, 0 PSay aCabec[nA,1]
			Next
			++Li                    
			@Li,000 PSay __PrtThinLine()
			++Li
 			@Li,000 PSay STR0005
			++Li                    
			@Li,000 PSay __PrtThinLine()
            Li += 2
		EndIf
		
		//-- Viagens
		DTQ->(MsSeek(xFilial("DTQ")+cViagem))
	
		//-- Rotas
		DA8->(MsSeek(xFilial("DA8")+DTQ->DTQ_ROTA))
	
		//-- Composicao do Frete
		DT8->(MsSeek(xFilial("DT8")+DUD->( DUD_FILDOC+DUD_DOC+DUD_SERIE )))
	
		//-- Solicitacao de Frete
		DT4->(MsSeek(xFilial("DT4")+DT8->DT8_NUMCOT))
	
		//-- Solicitacao de Coleta
		DT5->(MsSeek(xFilial("DT5")+DUD->( DUD_FILDOC+DUD_DOC+DUD_SERIE )))

		//-- Solicitantes
		DUE->(MsSeek(xFilial("DUE")+DT5->( DT5_DDD+DT5_TEL )))
		
		//-- Endereco de Solicitantes
		If !Empty(DT5->DT5_SEQEND)
			DUL->(MsSeek(xFilial("DUE")+DT5->(DT5_DDD+DT5_TEL+DT5_SEQEND)))
			lSE := .T.
		EndIf
		
		@Li,000 PSAY DUD_FILDOC           					  Picture "99"
		@Li,010 PSAY DUD_DOC+"/"+DUD_SERIE
		@Li,022 PSay DUE->DUE_NOME 							  Picture PesqPict("DUE","DUE_NOME")
		@Li,064 PSay If(lSE,DUL->DUL_END,DUE->DUE_END)       Picture PesqPict("DUE","DUE_END")
		@Li,106 PSay If(lSE,DUL->DUL_BAIRRO,DUE->DUE_BAIRRO) Picture PesqPict("DUE","DUE_BAIRRO")
		@Li,140 PSay DT6->DT6_QTDVOL     					  Picture PesqPict("DT6","DT6_QTDVOL")
		@Li,148 PSay DT6->DT6_PESO       					  Picture PesqPict("DT6","DT6_PESO")
		@Li,161 PSay "____/____/____ ____:____"
		@Li,186 PSay "____/____/____ ____:____"		
      Li++

		nTotPed ++
		
		//-- Totalizadores
		nTotVol   += DT6->DT6_QTDVOL
		nTotPeso  += DT6->DT6_PESO
		lImp := .T.

		dbSkip()
	EndDo
	
	If lEnd
	   Exit
	EndIf   
	
	If lImp
		Li+=2
		@Li,000 PSay __PrtThinLine()
		Li+=2
		@Li,000 PSay STR0006 //"TOTAIS -> "
		@Li,013 PSay STR0007 + AllTrim(STR(nTotPed)) //"PEDIDOS : "
		@Li,032 PSay STR0008 + TransForm(nTotPeso ,PesqPict("DT6","DT6_PESO"))  //"PESO : "
		@Li,057 PSay STR0009 + TransForm(nTotVol  ,PesqPict("DT6","DT6_QTDVOL")) //"VOLUME : "
		
		Li+=6
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime o cabecalho                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Li > 55
			Cabec(Titulo, cDesc1, cDesc2, NomeProg, Tamanho)
		EndIf
		
		nCol:=0
		Li++
		For nX:=1 to nCountMot+1
			ImpLin(Li,@nCol,nTamMaxCol)
		Next
		
		nCol:=0
		Li++
		For nX:=1 to Len(aCabec)
			If aCabec[nX,2] == "2"
				cString := Right(aCabec[nX,1],Len(DA4->DA4_NREDUZ)+2)
				ImpAss(@Li,@nCol,cString,nX,nCountMot,nTamMaxCol)
			EndIf	
		Next
		nCol:=0
		Li+=3
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime o cabecalho                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Li > 55
			Cabec(Titulo, cDesc1, cDesc2, NomeProg, Tamanho)
		EndIf
		
		Li++
		For nX:=1 to nCountAju +1
			ImpLin(Li,@nCol,nTamMaxCol)
		Next
		
		nCol:=0
		Li++
		For nX:=1 to Len(aCabec)
			If aCabec[nX,2] == "3"
				cString := Right(aCabec[nX,1],Len(DAU->DAU_NREDUZ)+2)
				ImpAss(@Li,@nCol,cString,nX,nCountMot,nTamMaxCol)
			EndIf	
		Next   
	EndIf

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
±±³Fun‡„o    ³RTMSR03Cab³ Autor ³Patricia A. Salomao    ³ Data ³18.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime Cabecalho com os Dados da Empresa                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR03Cabec(ExpN1,ExpN2,ExpN3,ExpN4,ExpN5)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpN1 - No. Total de Veiculos a serem Impressos            ³±±
±±³          ³ ExpN2 - No. Total de Motoristas a serem Impressos          ³±±
±±³          ³ ExpN3 - No. Total de Ajudante a serem Impressos            ³±±
±±³          ³ ExpA4 - Array contendo as informacoes iniciais do cabecalho³±± 
±±³          ³ ExpC5 - Codigo da Viagem.                                  ³±±
±±³          ³ ExpN4 - Tamanho                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR03			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR03Cabec(nCountVei,nCountMot,nCountAju,aCabec,cViagem,nTamMaxCol)

Local lOk
Local nBegin   :=0


nCountVei   := 0
nCountMot   := 0
nCountAju   := 0
aCabec      := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta as linhas do cabecalho.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//-- Lista Veiculos
DTR->(dbSetOrder(1))
DTR->(dbSeek(xFilial("DTR") + cFilAnt + cViagem))

lOk := .F.

Do While !DTR->(Eof()) .And. DTR->DTR_FILIAL + DTR->DTR_FILORI + DTR->DTR_VIAGEM == xFilial('DTR') + cFilAnt + cViagem

	If DA3->(dbSeek(xFilial("DA3")+DTR->DTR_CODVEI))
		Aadd(aCabec,{if(nCountvei==0, STR0015+" : ", space(len(STR0015+" : "))) + AllTrim(Str(++nCountVei)) + "-" + DA3->DA3_COD + "  -  " + Left(DA3->DA3_DESC, 15)+ Space(1) +; //"VEICULO "
			STR0016 + DA3->DA3_PLACA + Space(05)+ STR0017 + Transform(DA3->DA3_CAPACM,PesqPict("DA3","DA3_CAPACM")) +  Space(05)+ STR0018  + Left(Tabela("M2", DA3->DA3_TIPVEI, .F.), 25) +; //"PLACA : "###"   CAPACIDADE : "###"TIPO VEIC.: "
			Space((26 - Len(Tabela("M2", DA3->DA3_TIPVEI, .F.))))+ STR0019 + Replicate("_",25) + STR0020 + Replicate("_",25),"1"}) //"KM SAIDA : "###" KM CHEGADA : "
		
		lOK := .T.
	EndIf

	If !Empty(DTR->DTR_CODRB1) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB1)) 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
		//³ Monta uma linha com os dados do 1o. Reboque                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aCabec,{if(nCountvei==0, STR0015+" : ", space(len(STR0015+" : "))) + AllTrim(Str(++nCountVei)) + "-" + DA3->DA3_COD + "  -  " + Left(DA3->DA3_DESC, 15)+ Space(1) +; //"VEICULO "
			STR0016 + DA3->DA3_PLACA + Space(05)+ STR0017 + Transform(DA3->DA3_CAPACM,PesqPict("DA3","DA3_CAPACM")) +  Space(05)+ STR0018  + Left(Tabela("M2", DA3->DA3_TIPVEI, .F.), 25)+; //"PLACA : "###"   CAPACIDADE : "###"TIPO VEIC.: "
			Space((26 - Len(Tabela("M2", DA3->DA3_TIPVEI, .F.))))+ STR0019 + Replicate("_",25) + STR0020 + Replicate("_",25),"1"}) //"KM SAIDA : "###" KM CHEGADA : "		
	EndIf

	If !Empty(DTR->DTR_CODRB2) .And. DA3->(MsSeek(xFilial("DA3") + DTR->DTR_CODRB2)) 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
		//³  Monta uma linha com os dados do 2o. Reboque                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aCabec,{if(nCountvei==0, STR0015+" : ", space(len(STR0015+" : "))) + AllTrim(Str(++nCountVei)) + "-" + DA3->DA3_COD + "  -  " + Left(DA3->DA3_DESC, 15)+ Space(1) +; //"VEICULO "
			STR0016 + DA3->DA3_PLACA + Space(05)+ STR0017 + Transform(DA3->DA3_CAPACM,PesqPict("DA3","DA3_CAPACM")) +  Space(05)+ STR0018  + Left(Tabela("M2", DA3->DA3_TIPVEI, .F.), 25)+; //"PLACA : "###"   CAPACIDADE : "###"TIPO VEIC.: "
			Space((26 - Len(Tabela("M2", DA3->DA3_TIPVEI, .F.))))+ STR0019 + Replicate("_",25) + STR0020 + Replicate("_",25),"1"}) //"KM SAIDA : "###" KM CHEGADA : "		
	EndIf           
	
	DTR->(dbSkip())	
EndDo

If lOk
   Aadd(aCabec,{ " ", " " })
EndIf   

lOk := .F.

//-- Lista Motoristas
DUP->(dbSetOrder(1))
DUP->(dbSeek(xFilial("DUP") + cFilAnt + cViagem))
Do While !DUP->(Eof()) .And. DUP->DUP_FILIAL + DUP->DUP_FILORI + DUP->DUP_VIAGEM == xFilial('DUP') + cFilAnt + cViagem

	If DA4->(dbSeek(xFilial("DA4")+DUP->DUP_CODMOT))
		Aadd(aCabec,{if(nCountMot==0, STR0021+" : ", space(len(STR0021+" : "))) + AllTrim(Str(++nCountMot)) + "-" + DA4->DA4_NREDUZ,"2"} ) //"MOTORISTA "
		
		lOk := .T.
	EndIf

	DUP->(dbSkip())
EndDo

If lOk
   Aadd(aCabec,{ " ", " " })
EndIf   

lOk := .F.

//-- Lista Ajudantes
DUQ->(dbSeek(xFilial("DUQ") + cFilAnt + cViagem))
Do While !DUQ->(Eof()) .And. DUQ->DUQ_FILIAL + DUQ->DUQ_FILORI + DUQ->DUQ_VIAGEM == xFilial('DUQ')+cFilAnt+cViagem
	//-- Ajudante
	If DAU->(dbSeek(xFilial()+DUQ->DUQ_CODAJU))
		Aadd(aCabec,{if(nCountAju==0, STR0022+" : ", space(len(STR0022+" : "))) + AllTrim(Str(++nCountAju)) + "-" + DAU->DAU_NREDUZ,"3"} ) //"AJUDANTE "
		
		lOk := .T.
	EndIf

	DUQ->(dbSkip())
EndDo

//-- Imprime Campo memo
If !Empty(DTQ->DTQ_CODOBS)
    If lOk
       Aadd(aCabec,{ " ", " " })
    EndIf   

	cDescri := E_MsMM(DTQ->DTQ_CODOBS,80)
	nLinha:= MLCount(cDescri,nTamMaxCol)
	Aadd(aCabec, {STR0010 + MemoLine(cDescri,nTamMaxCol,1), ""})
	For nBegin := 2 To nLinha
		Aadd(aCabec,{ space(len(STR0010)) + Memoline(cDescri,nTamMaxCol,nBegin)," "} )
	Next nBegin
EndIf

Return Nil

   /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ImpLin    ³ Autor ³Patricia A. Salomao    ³ Data ³18.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprime Linha para as Assinaturas dos Motoristas / Ajudantes³±±
±±³          ³(de 1 a n ...)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpLin(ExpN1,ExpN2,ExpN3)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpN1 - No. da Linha                                       ³±±
±±³          ³ ExpN2 - No. da Coluna                                      ³±±
±±³          ³ ExpN3 - Tam. Max da Coluna; Controla a Impressao dos dados ³±±
±±³          ³         na proxima linha.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR03			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpLin(Li,nCol,nTamMaxCol)
If nCol <= nTamMaxCol
	@Li,nCol PSay "______________________________"
	nCol+=35
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ImpAss    ³ Autor ³Patricia A. Salomao    ³ Data ³18.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprime Linha para as Assinaturas dos Motoristas / Ajudantes³±±
±±³          ³(de 1 a n ...)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpAss(ExpN1,ExpN2,ExpC1,ExpN3,ExpN4,ExpN5)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpN1 - No. da Linha                                       ³±±
±±³          ³ ExpN2 - No. da Coluna                                      ³±±
±±³          ³ ExpC1 - Descricao da Assinatura (Motorista / Ajudante)     ³±±
±±³          ³ ExpN3 - No. para controlar se imprime ou nao na outra linha³±±
±±³          ³ ExpN4 - No. Total de Motoristas/Ajudantes a serem Impressos³±±
±±³          ³ ExpN5 - Tam. Max da Coluna; Controla a Impressao dos dados ³±±
±±³          ³         na proxima linha.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR03			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpAss(Li,nCol,cString,nNumDe,nNumAte,nTamMaxCol)

Local nY      :=0

If nCol >= nTamMaxCol
	nCol:=0
	Li+=2
	For nY := nNumDe To nNumAte+1
		ImpLin(@Li,@nCol)
	Next
	nCol:=0
	Li++
EndIf
If nCol == 0
	@Li,nCol PSay STR0023 //"Data"
	nCol+=35
EndIf
@Li,nCol PSay cString
nCol+=35

Return
