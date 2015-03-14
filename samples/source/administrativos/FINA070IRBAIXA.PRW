#INCLUDE "PROTHEUS.CH"

USER FUNCTION F070GerAb()
Local aArea := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSE1_ := __SE1->(GetArea())
Local cChave := PARAMIXB[1]
Local dBaixa := PARAMIXB[2]
Local cLoteFin := PARAMIXB[3]
Local dVencRea
Local cVenctoPF 	:= SuperGetMv("MV_ACMIRPF",.T.,"3")  //1 = Emissao    2= Vencimento Real	3=Data Contabilizacao
Local cVenctoPJ 	:= SuperGetMv("MV_ACMIRPJ",.T.,"3")  //1 = Emissao    2= Vencimento Real	3=Data Contabilizacao
Local cTITPAI := PARAMIXB[5]
Local nNovoVlr := 0
Local lIRPFBaixa := (SA1->A1_TPESSOA == "EP") .And. ;
		!Empty( SE1->( FieldPos( "E1_VRETIRF" ) ) ) .And. ;
		!Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) )
		// .And. !Empty( SE1->( FieldPos( "E1_PRETIRF" ) ) ) NAO EXISTE ESTE CAMPO NO SE1
Local bCampo 	:= {|n| FieldName(n) }
Local nX	:= 0
Local cParcela := ""
Local cNewParc := ""
//ALERT("PONTO DE ENTRADA: F070GerAb")
Local nTotAb2 := 0

if lIRPFBaixa .AND. FUNNAME() $ 'FINA070;FINA740' 
	IF TYPE("nTotAbImp") <> 'U'
		nTotAb2 := nTotAbImp
	Endif
	
	dbSelectArea("__SE1")
	__SE1->(dbSetOrder(2))
	__SE1->(dbSeek(xFilial("SE1")+cChave))
	While !EOF() .And. E1_FILIAL==xFilial("SE1") .And. (E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)==cChave
		IF E1_TIPO $ MVIRABT .And. E1_TIPO $ MVABATIM .AND. SA1->A1_TPESSOA == "EP" .AND. E1_SALDO > 0
			dVencRea := E1_VENCREA
			nNovoVlr := E1_VALOR - nTotAb2
			cNewParc := E1_PARCELA
			cParcela := E1_PARCELA
			While .T.
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ VerIfica se ja' ha' titulo de CIDE com esta numera‡„o ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SE1")
				DbSetOrder(1)
				If (DbSeek(xFilial("SE1")+E1_PREFIXO+E1_NUM+PadR(cNewParc,TamSx3("E1_PARCELA")[1])+"IR-"+E1_CLIENTE+E1_LOJA))
					If Empty(cNewParc)
						cNewParc := '1'
					Else
						cNewParc := Soma1( Alltrim(cNewParc),,.t.)
					Endif
					Loop
				Else
					Exit
				EndIf
			EndDo
	
	        SE1->(DbGoTo(__SE1->(RECNO()))) // POSICIONA NO REGISTRO DA SE1 BASEANDO-ME NA __SE1
	
			RecLock("SE1",.F.) // altera o registro anterior de IR- que será baixado.
			Replace E1_SALDO	With 0
			Replace E1_BAIXA	With dBaixa
			Replace E1_LOTE	With cLoteFin
			Replace E1_MOVIMEN With dBaixa
			Replace E1_STATUS  With "B"
			Replace E1_SDACRES With 0
			Replace E1_SDDECRE With 0
			Replace E1_VENCTO With dVencRea
			Replace E1_VENCREA With dVencRea
			Replace E1_VALOR With nTotAb2
			Replace E1_VLCRUZ With nTotAb2
			Replace E1_VALLIQ With nTotAb2
			Replace E1_PARCELA With cNewParc
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gravar o titulo que baixou o AB- para evitar estornos de ³
			//³abatimentos baixados por outras rotinas. Evita que um AB-³
			//³baixado pelo FINA070 / 110 seja estornado indevidamente  ³
			//³pelo FINA330, que gera erro na composicao do saldo do    ³
			//³titulo principal com abatimento.                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE1->(FieldPos("E1_TITPAI")) # 0
				If Empty(SE1->E1_TITPAI) .OR. (!MV_CRNEG $ SE1->E1_TITPAI .AND. !MVRECANT $ SE1->E1_TITPAI)
					Replace E1_TITPAI	With ( cTITPAI )
				Endif
			Endif
			MsUnlock()
	
			//Grava a parcela do titulo de IR- que foi baixado neste movimento. Sera utilizado no cancelamento da baixa futura.
			IF SE5->E5_TIPODOC $ "VL.BA" .AND. SE5->E5_DATA == dBaixa
				Reclock("SE5",.F.)
					E5_TESTE := SE1->E1_PARCELA + E5_SEQ
					E5_VRETIRF := nTotAb2
					E5_BASEIRF := E5_VALOR
				MsUnlock()
			ENDIF
	
			RecLock("SE1",.T.)
			For nX := 1 TO FCount()
				FieldPut(nx,__SE1->&(EVAL(bCampo,nx)))
			Next nX
			
			E1_PARCELA := cParcela
			E1_VALOR := nNovoVlr
			E1_SALDO := nNovoVlr
			E1_VLCRUZ:= nNovoVlr
			E1_VALLIQ:= 0
			SE1->(MsUnlock())

/*			dbselectarea("SE5") // E5_VALOR QUANDO BAIXA PARCIAL NÃO DEVE ABATAR O VALOR DO IR-, SOMENTE NA ULTIMA BAIXA. AQUI REPOE O VALOR
 			Reclock("SE5",.F.)
				E5_VALOR += nTotAb2
				E5_BASEIRF += nTotAb2
			MsUnlock()   */

		EndIF
		dbselectarea("__SE1")
		dbSkip()
	Enddo
	__SE1->(dbSetOrder(1))
Endif

Restarea(aAreaSE1_)
Restarea(aAreaSE1)
Restarea(aArea)

RETURN nTotAb2

USER FUNCTION F070IRBX()
LOCAL NVALORREC := PARAMIXB[1]
LOCAL NVALIR	 := PARAMIXB[2]
LOCAL NIRBAIXA := 0
LOCAL NPERC := 0
LOCAL nTotAbImp := 0
LOCAL nTotAbat  := SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,"S",dDATABASE,@nTotAbImp)

//ALERT("PONTO DE ENTRADA: F070IRBX")
                      
If SA1->A1_TPESSOA == "EP"
	NPERC := (NVALORREC/SE1->E1_VALOR)
	NIRBAIXA := NPERC * SE1->E1_IRRF
	NVALIR := NIRBAIXA
Endif

RETURN NVALIR



USER FUNCTION F070CANABT()
Local aArea := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSE5 := SE5->(GetArea())
Local nValor := 0
                        
//ALERT("PONTO DE ENTRADA: F070CANABT")
IF !EMPTY(SE5->E5_TESTE) .AND. FUNNAME() $ 'FINA070;FINA740' 

	dbselectArea("SE1")
	dbsetorder(2)													//Padr() Pois o tamanho do campo E5_TESTE É MAIOR QUE O E1_PARCELA
	IF dbseek(xFilial("SE1")+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)+SUBSTR(SE5->E5_TESTE,1,TAMSX3("E1_PARCELA")[1])+"IR-")
		nValor := E1_VALOR
		Reclock("SE1")
			dbDelete()
		MsUnlock()
	Endif

Endif

Restarea(aAreaSE5)
Restarea(aAreaSE1)
Restarea(aArea)

Return nValor


USER FUNCTION F70ALTABAT()
Local nVlrAbtIR := 0
Local aArea := GetArea()
Local aAreaSE5 := SE5->(GetArea())
Local aAreaSE1 := SE1->(GetArea())
//Local cChv  := SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
//Local nXValAbat := PARAMIXB

//ALERT("PONTO DE ENTRADA: F70ALTABAT")
If SA1->A1_TPESSOA == "EP"  .AND. FUNNAME() $ 'FINA070;FINA740' 
	DbSelectArea("SE1")
	DbSetOrder(1)                                        //Padr() Pois o tamanho do campo E5_TESTE É MAIOR QUE O E1_PARCELA
	If DbSeek(xFilial("SE1")+SE5->(E5_PREFIXO+E5_NUMERO)+SUBSTR(SE5->E5_TESTE,1,TAMSX3("E1_PARCELA")[1])+'IR-')
		nVlrAbtIR := SE1->E1_VALOR
	Endif
Endif	
  /*
dbSelectArea("SE1")
dbSetOrder(2) // E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
If DbSeek(xFilial("SE1")+cChv)
	While SE1->(!eof()) .AND. SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == cChv
		If ( E1_TIPO $ MVIRABT .OR. E1_TIPO $ MVABATIM ) .AND. ( SE1->E1_SALDO > 0 )
			nXValAbat -= SE1->E1_VALOR
		Endif
		SE1->(dbSkip())
	EndDo
Endif	
    */
RestArea(aAreaSE1)
RestArea(aAreaSE5)
RestArea(aArea)

RETURN (nVlrAbtIR)


// Função que reconstroi ordens das parcelas de IR- no cancelamento da baixa
USER FUNCTION F070BXABT()

Local aAreaSE5 := SE5->(GetArea())
Local nRecOld 	:= SE1->(recno())
Local nRecNew 	:= 0
Local cOldParcel := SUBSTR(SE5->E5_TESTE,1,TAMSX3("E1_PARCELA")[1])
Local nPos 		:= TAMSX3("E1_PARCELA")[1]+1
Local nRecSE5 	:= SE5->(RECNO())
Local cSeq		:= ALLTRIM(SUBSTR(SE5->E5_TESTE, nPos ))
Local cTeste	:= SE5->E5_TESTE
Local cMotivo	:= PARAMIXB[1]
//ALERT("PONTO DE ENTRADA: F070BXABT")
Local nValRetIr := SE5->E5_VRETIRF

IF FUNNAME() $ 'FINA070;FINA740' 
	IF aBaixaSE5[LEN(aBaixaSE5)][9] <> cSeq .AND. E1_PARCELA <> cOldParcel
		
		// Altera a ultima parcela de IR- gerada para não dar error.log de chave duplicada
		RECLOCK("SE1")
			E1_PARCELA := "X"
		MSUNLOCK()
	
		SE1->(DbSetOrder(2)) // Filial + Cliente + Loja + Prefixo + Número + Parcela + Tipo
		If SE1->(MsSeek(xFilial("SE1")+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+cOldParcel+"IR-"))
		
			RECLOCK("SE1") // Passa a parcela que está sendo cancelada na baixa para parcela principal
				E1_PARCELA 	:= ""
				E1_HIST 	:= ""
			MSUNLOCK()
		
			nRecNew := SE1->(recno())
		
			SE1->(dbGoTo(nRecOld))
		
			RECLOCK("SE1")
				E1_PARCELA	:= cOldParcel
				E1_HIST		:= ""
			MSUNLOCK()
	
			dbselectArea("SE5")
			dbSetOrder(7) //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
			If dbSeek(xFilial("SE5")+ALLTRIM(SE1->E1_TITPAI)+aBaixaSE5[LEN(aBaixaSE5)][9] )
				RecLock("SE5")
					E5_TESTE := cTeste
				MsUnlock()
			Endif
				
		Endif
	
		SE1->( DBGOTO(nRecNew) )
	Elseif !MovBcoBx(cMotivo,.T.)
	
		RECLOCK("SE1")
			E1_HIST 	:= ""
		MSUNLOCK()
	
	Endif
Endif
	
RestArea(aAreaSE5)
Return

// função que retorna o valor de IR- parcial para descontar no E1_SALDO do título pai.
User Function FinSalTit()
Local nValIR := 0
Local nTipo := PARAMIXB
Local lIRBaixa := (Posicione("SA1", 1, xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA, "A1_TPESSOA") == "EP")

If lIRBaixa .and. FUNNAME() $ 'FINA070;FINA740' 
	Do Case
		Case nTipo == 1 // atualiza saldo da baixa (E1_SALDO)
			If Valtype(nTotAbImp)<> "U"
				nValIR := nTotAbImp
			Endif
		Case nTipo == 2 // Atualiza valor recebido (E1_VALLIQ)
			If Valtype(nTotAbImp)<> "U"
				nValIR := nTotAbImp
			Endif	
		Case nTipo == 3 // Atualiza valor Saldo no cancelamento da baixa (E1_SALDO)
			If Valtype(nTotAbImp)<> "U"
				nValIR := nTotAbImp
			Endif	
	End Case
Endif

Return nValIR

USER FUNCTION F070GrvHis()
Local aArea := SE1->(getArea())
Local nRecnoI := __SE1->(Recno())

If !MovBcoBx(cMotBx,.T.)  .and. FUNNAME() $ 'FINA070;FINA740' 
	SE1->(dbGoTo(nRecnoI))
	
	Reclock("SE1",.F.)
		E1_HIST := "Baixado por GLOSA"
	MsUnlock()
Endif	
RestArea(aArea)
Return

USER FUNCTION FIN70IRAB()
Local nValorIR := 0
Local aArea := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local cChv  := SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
Local cParcOri := SE1->E1_PARCELA
Local lIRBaixa := (Posicione("SA1", 1, xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA, "A1_TPESSOA") == "EP")

If lIRBaixa  .and. FUNNAME() $ 'FINA070;FINA740'  // pesquisa todos os abatimentos IR- já baixados deste título pai.
	dbSelectArea("SE1")
	dbSetOrder(2) // E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If DbSeek(xFilial("SE1")+cChv)
		While SE1->(!eof()) .AND. SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == cChv
			If ( E1_TIPO $ MVIRABT ) .AND. ( cParcOri <> SE1->E1_PARCELA ) .AND. ( SE1->E1_SALDO == 0 )
				nValorIR += SE1->E1_VALOR
			Endif
			SE1->(dbSkip())
		EndDo
	Endif	
Endif

RestArea(aAreaSE1)
RestArea(aArea)

Return nValorIR

User Function F070VRETIR()

IF FUNNAME() $ 'FINA070;FINA740' 
	SE5->E5_VRETIRF := SE1->E1_IRRF  - U_FIN70IRAB()
Endif

Return

User Function F070EST()
Local nValRetIR := PARAMIXB[1]
Local lIRBaixa := (Posicione("SA1", 1, xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA, "A1_TPESSOA") == "EP")

If lIRBaixa  .and. FUNNAME() $ 'FINA070;FINA740' // pesquisa todos os abatimentos IR- já baixados deste título pai.
	REPLACE SE5->E5_VRETIRF WITH nValRetIR
Endif

Return