#Include "PROTHEUS.CH"
#Include "RGPER12.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RgPer12   ³ Autor ³Alexandre Silva        ³ Data ³ 17/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera o arquivo de exportacao. Para folha de pagamento       ³±±
±±³          ³Uruguai.                                                    ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³RgPer12()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Liquidacion.                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/   

/*

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programador  ³ Data     ³ FNC            ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³Francisco Jr.³30/11/2009³00000026616/2009³Compatibilizacao dos fontes para aumento do³±±
±±³             ³          ³                ³campo filial e gestão corporativa.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function RgPer12()

Local nOpca		:= 0
Local aSays		:= {STR0002,STR0003}
					
Local aButtons	:= {{ 5,.T.,{| | Pergunte("RGPR12",.T.)  	}},;
					{ 1,.T.,{|o| nOpca := 1,FechaBatch() 	}},;
					{ 2,.T.,{|o| FechaBatch()			 	}}} 

Private cCadastro 	:= OemToAnsi(STR0001) 

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Verifica as perguntas selecionadas                           ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Pergunte("RGPR12",.F.)

FormBatch(cCadastro,aSays,aButtons )  


If nOpca == 1
	Processa({|lEnd|Gpr12Proc(),STR0001})  //"Gera‡„o de liquido em disquete"
EndIf

Return .T.
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³Gpr12Proc     ³Autor ³  Alexandre Silva     ³Data³ 17/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento do relatorio.                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Gpr12Proc()

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ mv_par01        //  Filial  De                               ³
  ³ mv_par02        //  Filial  Ate                              ³
  ³ mv_par03        //  Centro de Custo De                       ³
  ³ mv_par04        //  Centro de Custo Ate                      ³
  ³ mv_par05        //  Matricula De                             ³
  ³ mv_par06        //  Matricula Ate                            ³
  ³ mv_par07        //  Nome De                                  ³
  ³ mv_par08        //  Nome Ate                                 ³
  ³ mv_par09        //  Banco                                    ³
  ³ mv_par10        //  Agencia                                  ³
  ³ mv_par11        //  Conta                                    ³
  ³ mv_par12        //  Data de referencia                       ³
  ³ mv_par13        //  Situacao                                 ³
  ³ mv_par14        //  Categorias                               ³
  ³ mv_par15        //  Data de credito                          ³
  ³ mv_par16        //  Tipo dos creditos                        ³
  ³ mv_par17        //  Numero da semana.                        ³
  ³ mv_par18        //  Num parc. 13 sal.                        ³
  ³ mv_par19        //  Cod. Empresa no Cofac.                   ³
  ³ mv_par20        //  Tipo conta da empresa.                   ³
  ³ mv_par21        //  Incui semana em branco                   ³
  ³ mv_par22        //  Gerar                                    ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

Local aCodFol  	:= {}
Local aOrdBag	 	:= {}
Local cArqMov		:= ""
Local cAliasMov	:= ""
Local cArqSaida	:= ""
Local cVerPag		:= ""
Local cLinha		:= ""
Local cFilAnt		:= Replicate("!",FWGETTAMFILIAL)
Local cMesAno		:= ""
Local lArqSaida	:= .T.
Local lOk			:= .F.
Local nArqSaida	:= 0
Local nTotalQ    	:= 0
Local nS				:= 0
Local aStruSra    := {}
Local cAliasSRA 	:= "SRA" 	//Alias da Query
Local aCodBenef   := {}
Local nCntP			:= 0
Local nX 			:=	0

Private cFilDe    	:= mv_par01
Private cFilAte   	:= mv_par02
Private cCcDe     	:= mv_par03
Private cCcate    	:= mv_par04
Private cMatDe    	:= mv_par05
Private cMatAte   	:= mv_par06
Private cNomDe    	:= mv_par07
Private cNomAte   	:= mv_par08
Private cBanco     	:= mv_par09
Private cAgencia    := mv_par10
Private cConta     	:= mv_par11
Private dDataRef  	:= mv_par12
Private cSituacao 	:= mv_par13
Private cCategoria	:= mv_par14
Private dDataCred 	:= mv_par15
Private cTipoCred 	:= Alltrim(LimpaStr(mv_par16))
Private cSemana		:= iiF(Len(Alltrim(mv_par17)) == 1,"0"+Alltrim(mv_par17),mv_par17)
Private nCota13		:= mv_par18
Private cCodCofac 	:= mv_par19
Private nTipoCta  	:= mv_par20
Private lSemBran	:= mv_par21 == 1
Private nFunBen	   := mv_par22 
Private Semana	      := cSemana

Private cBcoAgeSel	:= Left(cBanco,3) + Left(cAgencia,5)
Private cSitQuery	:= ""
Private cCatQuery	:= ""
Private nTotPago	:= 0.00
Private nTotReg		:= 0
Private cAnoMes 	:= ""
Private nValor    := 0         
Private aValBenef := {}

Private cAcessaSRA	:= &( " { || " + ChkRH( "GPER280" , "SRA" , "2" ) + " } " )
Private cAcessaSRC	:= &( " { || " + ChkRH( "GPER280" , "SRC" , "2" ) + " } " )
Private cAcessaSRG	:= &( " { || " + ChkRH( "GPER280" , "SRG" , "2" ) + " } " )
Private cAcessaSRH	:= &( " { || " + ChkRH( "GPER280" , "SRH" , "2" ) + " } " )
Private cAcessaSRI	:= &( " { || " + ChkRH( "GPER280" , "SRI" , "2" ) + " } " )
Private cAcessaSRR	:= &( " { || " + ChkRH( "GPER280" , "SRR" , "2" ) + " } " )

dDataDe := dDataAte := dDataRef
cMesAno		:= StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)

lAdianta  := If(cTipoCred == "2",.T.,.F.)
lFolha    := If(cTipoCred == "1",.T.,.F.)
lPrimeira := If(cTipoCred == "3",.T.,.F.)
lSegunda  := If(cTipoCred == "3",.T.,.F.)
lFerias   := If(cTipoCred == "4",.T.,.F.)
lExtras   := .F.
lRescisao := .F.

SA6->(dbSetOrder(1))
If ! SA6->(dbSeek(xFiliaL("SA6")+cBcoAgeSel+cConta))
	Aviso(STR0004,STR0005,{"Ok"})	 
	Return .F.
EndIf

If cTipoCred == "3"
	If nCota13 == 1
		cAnoMes	:= StrZero(Year(dDataRef),4) + "13" 
		cMesAno	:= "13" + StrZero(Year(dDataRef),4) 
	Else
		cAnoMes	:= StrZero(Year(dDataRef),4) + "23" 
		cMesAno	:= "23" + StrZero(Year(dDataRef),4) 
	Endif		
Else
	cAnoMes	:= StrZero(Year(dDataRef),4) + StrZero(Month(dDataRef),2) 
	cMesAno	:= StrZero(Month(dDataRef),2)+ StrZero(Year(dDataRef),4)  
EndIf

For nS:=1 to Len(cSituacao)
	cSitQuery += "'"+Subs(cSituacao,nS,1)+"'"
	If (nS+1) <= Len(cSituacao)
		cSitQuery += ","
	EndIf
Next

For nS:=1 to Len(cCategoria)
	cCatQuery += "'"+Subs(cCategoria,nS,1)+"'"
	If ( nS+1) <= Len(cCategoria)
		cCatQuery += ","
	EndIf
Next nS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define se devera ser impresso Funcionarios ou Beneficiarios  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRQ" )
lImprFunci  := ( nFunBen == 1 )
lImprBenef  := ( nFunBen == 2 .And. FieldPos( "RQ_BCDEPBE" ) # 0 .And. FieldPos( "RQ_CTDEPBE" ) # 0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Informa a nao existencia dos campos de bco/age/conta corrente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nFunBen == 2 .And. !lImprBenef
	fAvisoBC()
	Return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !OpenSrc(cMesAno, @cAliasMov, @aOrdBag, @cArqMov, dDataBase )
	Return .f.
Endif

dbSelectArea("SRA")
dbSetOrder(1)
ProcRegua(SRA->(RecCount()))

#IfDEF TOP
	If TcSrvType() != "AS/400"
		cQuery := " SELECT COUNT(*) TOTAL "
		cQuery += " FROM "+	RetSqlName("SRA")
		cQuery += " WHERE RA_FILIAL between '" + cFilDe + "' AND '" + cFilAte + "'"
		cQuery += " AND RA_MAT     between '" + cMatDe + "' AND '" + cMatAte + "'"
		cQuery += " AND RA_NOME    between '" + cNomDe + "' AND '" + cNomAte + "'"
		cQuery += " AND RA_CC      between '" + cCcDe  + "' AND '" + cCcate  + "'"
		cQuery += " AND RA_CATFUNC IN (" + Upper(cCatQuery) + ")"
		cQuery += " AND RA_SITFOLH IN (" + Upper(cSitQuery) + ")"
		cQuery += " AND D_E_L_E_T_ <> '*' "		
	Else
		cQuery := " SELECT COUNT(*) TOTAL "
		cQuery += " FROM "+	RetSqlName("SRA")
		cQuery += " WHERE RA_FILIAL  >= '" + cFilDe + "' AND RA_FILIAL  <= '" + cFilAte + "'"
		cQuery += " AND RA_MAT     >= '" + cMatDe + "' AND RA_MAT     <= '" + cMatAte + "'"
		cQuery += " AND RA_NOME    >= '" + cNomDe + "' AND RA_NOME    <= '" + cNomAte + "'"
		cQuery += " AND RA_CC      >= '" + cCcDe  + "' AND RA_CC      <= '" + cCcate  + "'"
		cQuery += " AND @DELETED@ <> '*' "		
	EndIf		
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)
	dbSelectArea("QUERY")
	nTotalQ := QUERY->TOTAL
	ProcRegua(nTotalQ)		// Total de Elementos da regua	
	dbCloseArea("QUERY")
	dbSelectArea("SRA")		
	
	If TcSrvType() != "AS/400"
		cQuery := " SELECT * "		
		cQuery += " FROM "+	RetSqlName("SRA")
		cQuery += " WHERE RA_FILIAL between '" + cFilDe + "' AND '" + cFilAte + "'"
		cQuery += " AND RA_MAT      between '" + cMatDe + "' AND '" + cMatAte + "'"
		cQuery += " AND RA_NOME     between '" + cNomDe + "' AND '" + cNomAte + "'"
		cQuery += " AND RA_CC       between '" + cCcDe  + "' AND '" + cCcate  + "'"
		cQuery += " AND RA_CATFUNC IN (" + Upper(cCatQuery) + ")"
		cQuery += " AND RA_SITFOLH IN (" + Upper(cSitQuery) + ")"
		cQuery += " AND D_E_L_E_T_ <> '*' "		
	Else
		cQuery := "SELECT * "
		cQuery += " FROM "+	RetSqlName("SRA")
		cQuery += " WHERE RA_FILIAL>= '" + cFilDe + "' AND RA_FILIAL  <= '" + cFilAte + "'"
		cQuery += " AND RA_MAT     >= '" + cMatDe + "' AND RA_MAT     <= '" + cMatAte + "'"
		cQuery += " AND RA_NOME    >= '" + cNomDe + "' AND RA_NOME    <= '" + cNomAte + "'"
		cQuery += " AND RA_CC      >= '" + cCcDe  + "' AND RA_CC      <= '" + cCcate  + "'"
		cQuery += " AND @DELETED@ <> '*' "		
	EndIf		
	cQuery   += " ORDER BY RA_FILIAL, RA_MAT"
	aStruSRA := SRA->(dbStruct())
	dbCloseArea("SRA")
	dbSelectArea("SRC")
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SRA', .F., .T.)
	For nX := 1 To Len(aStruSRA)
		If ( aStruSRA[nX][2] <> "C" )
			TcSetField(cAliasSRA,aStruSRA[nX][1],aStruSRA[nX][2],aStruSRA[nX][3],aStruSRA[nX][4])
		EndIf
	Next nX
#ELSE
	dbSetOrder(1)
	dbSeek( cFilDe + cMatDe , .T. )
#ENDIf

While ! Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT <= cFilAte + cMatAte
	
	IncProc(STR0001) 
	
	If SRA->RA_FILIAL # cFilAnt 
		If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL)
			Exit
		EndIf

		cFilAnt := SRA->RA_FILIAL  

		Do Case
			Case cTipoCred == "1"
				cVerPag	:= aCodFol[047,01] //Sueldo
			Case cTipoCred == "2"
				cVerPag	:= aCodFol[007,01] //Adelanto
			Case cTipoCred == "3"
				cVerPag	:= aCodFol[021,01] //Aguinaldo
			Case cTipoCred == "4"
				cVerPag	:= aCodFol[102,01] // Ferias
			Otherwise
				Aviso(STR0004,STR0006,{"Ok"})	 
				Exit
		EndCase
	EndIf
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Consiste Parametrizacao do Intervalo de Impressao            ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If  (SRA->RA_NOME    < cNomDe) .Or. (SRA->RA_NOME    > cNomAte) .Or. ;
		(SRA->RA_MAT     < cMatDe) .Or. (SRA->RA_MAT     > cMatAte) .Or. ;
		(SRA->RA_CC      < cCcDe)  .Or. (SRA->RA_CC      > cCcate)

		SRA->(dbSkip(1))
		Loop
	EndIf
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Consiste parametros de banco e conta.						 ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If Left(SRA->RA_BCDEPSA,3) <> Left(cBanco,3) .Or.  Empty(SRA->RA_CTDEPSA)
		SRA->(dbSkip(1))
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca os valores de Liquido e Beneficios                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fBuscaLiq(@nValor,@aValBenef,aCodFol)
	If Len(aValBenef) > 0
		aBenefCop  := ACLONE(aValBenef)
		aValBenef  := {}
		Aeval(aBenefCop, { |X| If( ( X[2] == cBcoAgeSel),;
					       AADD(aValBenef, X), "" ) })
	EndIf

	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Testa Situacao e Categoria.	     		 				         ³
	//³ Testa se Valor == 0                                          ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If !( SRA->RA_SITFOLH $ cSituacao ) .Or. !(SRA->RA_CATFUNC $ cCategoria)  .Or.;
		( nValor == 0 .And. Len(aValBenef) == 0 )
		SRA->(dbSkip(1))
		Loop
	EndIf

	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  |        Fim Consistencia da Parametrizacao do Intervalo de Impressao   		   |
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If Empty(cArqSaida) .And. lArqSaida
		cArqSaida := cGetFile(STR0007,STR0008,,"C:\",.F.,GETF_LOCALHARD) 
		nArqSaida := fOpen(cArqSaida,1)
		If nArqSaida == -1 .And. !Empty(cArqSaida)
			nArqSaida := fCreate(cArqSaida)
			If nArqSaida != 0 
				GravaTxt(nArqSaida,Space(60))//Reserva espaco para o cabecalho.
			EndIf			
		Else
			lArqSaida := .F.		
		Endif
	EndIf

	If nArqSaida != 0 
		If Len(aValBenef) == 0
			cLinha	:= GeraLin(cVerPag)
			If ! Empty(cLinha)		
				GravaTxt(nArqSaida,cLinha)
		   	 LOk	:= .T.
			EndIf			
		Else
		    For nCntP := 1 To Len(aValBenef)	
		    	cBancoBen  := aValBenef[nCntP,2]
    			cContaBen  := aValBenef[nCntP,3]
				cDocBen	:= aValBenef[nCntP,6] 	
				cVerBenef :=aValBenef[nCntP,4] 	
	   		If aValBenef[nCntP,5] == 0 .Or. Empty(cBancoBen) .Or. cBcoAgeSel <> cBancoBen
 		  			Loop
   			EndIf
				cLinha	:= GeraLin(cVerBenef)
				If ! Empty(cLinha)		
					GravaTxt(nArqSaida,cLinha)
		   		 LOk	:= .T.
				EndIf			
          Next nCntP
		EndIf			
	EndIf			
	
	dbSelectArea("SRA")
	dbSkip()
Enddo                    

If lOk	
	MsgInfo(STR0009) //Geracao do arquivo concluida.
Else
	MsgInfo(STR0011)
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

If nArqSaida != 0 
	GeraCab(nArqSaida)
	fClose(nArqSaida)
EndIf	

dbSelectArea("SRA")

dbCloseArea()
ChkFile("SRA")     

dbSelectArea( "SRI" )
dbSelectArea( "SRA" )

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GeraCab   ³ Autor ³Alexandre Silva        ³ Data ³ 21/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a geracao da linha de cabecalho.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GeraCab(nArqSaida,cLinha)  							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³RgPer12                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GeraCab(nArqSaida)

Local nTotDolar	:= 0.00 //Total em dolar
Local cContaEmp   
Local cAcentos := "-"

IF ( nAt := At(cAcentos,SA6->A6_NUMCON)) > 0
	cContaEmp := Padl(Trim(SubStr( SA6->A6_NUMCON,1,nAt-1)),5,"0")
Else
	cContaEmp := Padl(Trim(SA6->A6_NUMCON),5,"0")
Endif	
cLinha	:=	Left(cCodCofac,4)								 	//01-04 Empresa
cLinha	+=	Right(Dtos(dDataCred),6)							//05-10 Data de credito
cLinha	+=	TipoCred(cTipoCred)									//11-12 Tipo do credito
cLinha	+=	StrTran(LimpaStr(Str(nTotPago ,14,2))," ","0")		//13-25 Total em pesos
cLinha	+=	StrTran(LimpaStr(Str(nTotDolar,14,2))," ","0")		//26-38 Total em dolar * Nao implementado
cLinha	+=	StrTran(Str(nTotReg,5)," ","0")						//39-43 Quantid. Recibos
cLinha	+=	Padl(Trim(SA6->A6_AGENCIA),3,"0")					//44-46 Agencia
cLinha	+=	LTrim(Str(nTipoCta))								//47-47 Tipo da Conta
cLinha	+=	Replicate("0",7)									//48-54 Relleno
cLinha	+=	cContaEmp					//55-59 Num da conta corrente
cLinha	+=	"0" 												//60-60 Sub-Conta

If nArqSaida != 0 
	fSeek(nArqSaida,0)
	fWrite(nArqSaida,cLinha+chr(13)+chr(10)) 
EndIf			

Return cLinha

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GeraLin   ³ Autor ³Alexandre Silva        ³ Data ³ 21/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a geracao da linha de detalhe.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GeraLin() 											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³RgPer12                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GeraLin(cVerPag)

Local cValor := Gp12Calc(cVerPag)
Local cLinha := ""
Local cTipCta:= iiF(empty(SRA->RA_TPCTDEP),"X",SRA->RA_TPCTDEP)

If ! Empty(cValor)
   If !lImprBenef .And. Len(aValBenef)== 0
		cLinha	:=	Padl(Trim(Left(Right(SRA->RA_BCDEPSA,5),3)),3,"0")	//	1-3*Agencia
		cLinha	+=	Padl(Trim(Left(SRA->RA_CTDEPSA,5)),5,"0")	//	4-8*Conta
		cLinha	+=	iiF(SRA->RA_TIPODOC == "1","01","11")		//Tipo-Doc	9-10
		cLinha	+=	Padl(RTrim(LimpaSTR(SRA->RA_RG)),15,"0")	//Docuement	11-25
	Else 
		cLinha	:=	Padl(Trim(Left(Right(cBancoBen,5),3)),3,"0")	//	1-3*Agencia
		cLinha	+=	Padl(Trim(Left(cContaBen,5)),5,"0")	//		4-8*Conta
		cLinha	+=	iiF(SRA->RA_TIPODOC == "1","01","11")		//Tipo-Doc	9-10
		cLinha	+=	Padl(RTrim(LimpaSTR(cDocBen)),15,"0")	//Docuement	11-25
	Endif
	cLinha	+=	LTrim(cTipCta)								//Tipo-Cta	26-26
	cLinha	+=	"0" 										//Sub-cuent 27-27
	cLinha	+=	Replicate("0",7)							//Filler	28-34	
	cLinha	+=	"0"											//Moneda	35-35 Sempre Peso.
	cLinha	+=	cValor										//Importe	36-48

	nTotReg++      
	
EndIf	

Return cLinha
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TipoCred  ³ Autor ³Alexandre Silva        ³ Data ³ 02/11/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna o codigo de credito.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³TipoCred(cCredSel)		  							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³RgPer12                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function TipoCred(cCredSel)

Local cCredNum	:= ""

Do Case
Case cCredSel == "1"
	cCredNum	:= "01"
Case cCredSel == "2"
	cCredNum	:= "02"
Case cCredSel == "3"
	cCredNum	:= "03"
Case cCredSel == "4"
	cCredNum	:= "04"
Case lImprBenef 
	cCredNum	:= "11"
Otherwise
	cCredNum	:= "0"
EndCase

Return cCredNum
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GeraLin   ³ Autor ³Alexandre Silva        ³ Data ³ 21/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a geracao da linha de cabecalho.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GeraLin() 											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³RgPer12                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LimpaSTR(cTexto)
Local cTmpCar	:= ""
Local cCarac	:= "-.;/\*,:*"
Local nItem		:= 1

For nItem := 1 to len(cCarac)
	cTmpCar	:= Substr(cCarac,nItem,1)
	cTexto	:= StrTran(cTexto,cTmpCar)
Next nItem	

Return cTexto
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Gp12Calc  ³ Autor ³Alexandre Silva        ³ Data ³ 21/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a geracao da linha de cabecalho.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Gp12Calc() 											      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Liquidacion Uruguay                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Gp12Calc(cVerPag)   

Local cValor 	:= ""
Local cParc13	:= iiF(nCota13 == 1,"P","S")
Local nValor 	:= 0
Local lSalario	:= cTipoCred $ "1|2"  
Local lCalc13	:= cTipoCred == "3"  
Local aArea		:= GetArea()

If lCalc13
	dbSelectArea("SRI")
	dbSetOrder(1)
Else
	dbSelectArea("SRC")
	dbSetOrder(1)
EndIf	

If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+cVerPag)
	If lCalc13 
		Do While SRA->RA_FILIAL+SRA->RA_MAT+cVerPag == SRI->RI_FILIAL+SRI->RI_MAT+SRI->RI_PD
			If Trim(SRI->RI_TIPO2) == Trim(cParc13)
				nValor := SRI->RI_VALOR				
				Exit
			EndIf
			SRI->(dbSkip())
		EndDo							
	ElseIf lSalario 
		Do While SRA->RA_FILIAL+SRA->RA_MAT+cVerPag == SRC->(RC_FILIAL+RC_MAT+RC_PD)
			If (Trim(cSemana) == Trim(SRC->RC_SEMANA)) .Or. (lSemBran .And. Empty(SRC->RC_SEMANA))
				nValor := SRC->RC_VALOR				
				Exit
			EndIf
			SRC->(dbSkip())
		EndDo							
	EndIf
EndIf
If cTipoCred == "4"	.And. nValor = 0
	dbSelectArea("SRR")
	dbSetOrder(1)                           
	IF dbSeek(SRA->RA_FILIAL + SRA->RA_MAT +"F"+DToS(mv_par12)+cVerPag )
		nValor := SRR->RR_VALOR
	Endif
Endif	
	
If nValor <> 0
	cValor	:= StrTran(StrTran(Str(nValor,14,2),"." )," ","0")
	nTotPago+= nValor
EndIf	

RestArea(aArea)

Return cValor
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravaTxt  ³ Autor ³Alexandre Silva        ³ Data ³ 21/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a geracao do arquivo de exportacao.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GravaTxt(nArqSaida,cLinha)							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³RgPer12                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GravaTxt(nArqSaida,cLinha)

If nArqSaida != -1
	fSeek(nArqSaida,0,2)
	fWrite(nArqSaida,cLinha+chr(13)+chr(10)) 
EndIf

Return .T.
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fTipoAcred³ Autor ³Alexandre Silva        ³ Data ³ 20/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecao dos creditos para geracao do arquivo de exportacao  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³fTipoAcred()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function fTipoAcred()

Local MvParDef	:= "0123456789ABCDEFGH"
Local MvPar		:= &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
Local MvRet		:= Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
Local aAreaAnt	:= GetArea()

Private aTipCred	:={	"0 - Invalida",;	//"Mensalista"
						"1 - Sueldo",;
						"2 - Adelanto",;
						"3 - Aguinaldo",;
						"4 - Sal. vacacional";
					   }  	
				
If f_Opcoes(@MvPar,STR0010,aTipCred,MvParDef,12,49,.T.)// Chama funcao f_Opcoes
	&MvRet := MvPar									
EndIf

RestArea(aAreaAnt)

Return .T.
