#INCLUDE "rtmsr12.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTMSR12  ³ Autor ³ Eduardo de Souza      ³ Data ³ 20/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio Programacao Diaria                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR12()	   			                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGATMS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RTMSR12()

Local wnrel      := "RTMSR12"
Local Titulo     := STR0001 //"Relacao de Agendamentos"
Local cDesc1     := STR0002 //"Emite a relacao dos Agendamento conforme os parametros informados"
Local cDesc2     := ""
Local cDesc3     := ""
Local cString    := "DF0"
Local cPerg      := "RTMR12"
Local Tamanho    := "G"
Local lEnd       := .F.
Local cNomeProg  := "RTMSR12"
Local cAliasTRB  := ""

Private nLastKey  := 0
Private aReturn   := { STR0003, 1, STR0004, 1, 2, 1, "", 1 } //"Zebrado"###"Administracao"
Private cArqTmp   := ""

//Chamada do relatorio padrao
If FindFunction("TRepInUse") .And. TRepInUse()
	TMSR610()
	Return
EndIf

//-- Atualiza as perguntas de impressao.
RTMSR12SX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01	 // Agendamento De                                ³
//³ mv_par02	 // Agendamento Ate                               ³
//³ mv_par03	 // DDD De                                        ³
//³ mv_par04	 // Telefone De                                   ³
//³ mv_par05	 // DDD Ate                                       ³
//³ mv_par06    // Telefone Ate                                  ³
//³ mv_par07	 // Data De                                       ³
//³ mv_par08	 // Data Ate                                      ³
//³ mv_par09	 // Status Agendamento De                         ³
//³ mv_par10	 // Status Agendamento Ate                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

// Envia para a SetPrinter
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho)

If nLastKey == 27
	DbSelectArea(cString)
	DbSetOrder(1)
	DbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	DbSelectArea(cString)
	DbSetOrder(1)
	DbClearFilter()
	Return
Endif

// Chamada da rotina de armazenamento de dados...
Processa({||RTMSR12Trb(@cAliasTRB) })

// Chamada da rotina de impressao do relat¢rio...
RptStatus({|lEnd| RTMSR12Imp(@lEnd,wnRel,cString,cNomeProg,Titulo,Tamanho,cAliasTRB)},Titulo)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR12TRB³ Autor ³Eduardo de Souza       ³ Data ³ 20/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Armazenamento e Tratamento dos dados 					        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³RTMSR12TRB()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR12                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTMSR12TRB(cAliasTRB)

Local cQuery      := ""

cAliasTRB := GetNextAlias()
cQuery := " SELECT "
cQuery += " DF0.DF0_NUMAGE NUMAGE      , MAX(DF0.DF0_DATCAD) DATCAD , MAX(DF0.DF0_DDD) DDD       , "
cQuery += " MAX(DF0.DF0_TEL) TEL       , MAX(DF0.DF0_SEQEND) SEQEND , DF1.DF1_ITEAGE ITEAGE      , "
cQuery += " MAX(DF1.DF1_STACOL) STACOL , MAX(DF1.DF1_STAENT) STAENT , MAX(DF1.DF1_LOCCOL) LOCCOL , "
cQuery += " MAX(DF1.DF1_CLIREM) CLIREM , MAX(DF1.DF1_LOJREM) LOJREM , MAX(DF1.DF1_CLIDES) CLIDES , "
cQuery += " MAX(DF1.DF1_LOJDES) LOJDES , MAX(DF1.DF1_DATPRC) DATPRC , MAX(DF1.DF1_HORPRC) HORPRC , "
cQuery += " MAX(DF1.DF1_DATPRE) DATPRE , MAX(DF1.DF1_HORPRE) HORPRE , " 
cQuery += " SB1.B1_DESC PRODUTO        , SX5.X5_DESCRI EMBALAGEM    , MAX(DF2.DF2_QTDVOL) QTDVOL , "
cQuery += " MAX(DF2.DF2_QTDUNI) QTDUNI , MAX(DF2.DF2_PESO) PESO     , MAX(DF2.DF2_PESOM3) PESOM3 , "
cQuery += " MAX(DF2.DF2_VALMER) VALMER , DUT.DUT_DESCRI TIPVEI "
cQuery += "   FROM " + RetSqlName("DF0") + " DF0 "
cQuery += "   JOIN " + RetSqlName("DF1") + " DF1 "
cQuery += "     ON  DF1.DF1_FILIAL = '" + xFilial("DF1") + "' "
cQuery += "     AND DF1.DF1_NUMAGE = DF0.DF0_NUMAGE "
cQuery += "     AND DF1.D_E_L_E_T_ = ' ' "
cQuery += "   LEFT JOIN " + RetSqlName("DF2") + " DF2 "
cQuery += "     ON  DF2.DF2_FILIAL = '" + xFilial("DF2") + "' "
cQuery += "     AND DF2.DF2_NUMAGE = DF1.DF1_NUMAGE "
cQuery += "     AND DF2.DF2_ITEAGE = DF1.DF1_ITEAGE "
cQuery += "     AND DF2.D_E_L_E_T_ = ' ' "
cQuery += "   LEFT JOIN " + RetSqlName("DF5") + " DF5 "
cQuery += "     ON  DF5.DF5_FILIAL = '" + xFilial("DF5") + "' "
cQuery += "     AND DF5.DF5_NUMAGE = DF1.DF1_NUMAGE "
cQuery += "     AND DF5.DF5_ITEAGE = DF1.DF1_ITEAGE "
cQuery += "     AND DF5.D_E_L_E_T_ = ' ' "
cQuery += "   LEFT JOIN " + RetSqlName("SB1") + " SB1 "
cQuery += "     ON  SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "     AND SB1.B1_COD    = DF2.DF2_CODPRO "
cQuery += "     AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "   LEFT JOIN " + RetSqlName("SX5") + " SX5 "
cQuery += "     ON  SX5.X5_FILIAL = '" + xFilial("SX5") + "' "
cQuery += "     AND SX5.X5_TABELA  = 'MG' "
cQuery += "     AND SX5.X5_CHAVE   = DF2.DF2_CODEMB "
cQuery += "     AND SX5.D_E_L_E_T_ = ' ' "
cQuery += "   LEFT JOIN " + RetSqlName("DUT") + " DUT "
cQuery += "     ON  DUT.DUT_FILIAL = '" + xFilial("DUT") + "' "
cQuery += "     AND DUT.DUT_TIPVEI = DF5.DF5_TIPVEI "
cQuery += "     AND DUT.D_E_L_E_T_ = ' ' "
cQuery += "	  WHERE DF0.DF0_FILIAL = '" + xFilial("DF0") + "' "
cQuery += "	  AND DF0.DF0_NUMAGE BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
cQuery += "	  AND DF0.DF0_DDD    BETWEEN '" + mv_par03 + "' AND '" + mv_par05 + "' "
cQuery += "	  AND DF0.DF0_TEL    BETWEEN '" + mv_par04 + "' AND '" + mv_par06 + "' "
cQuery += "	  AND DF0.DF0_DATCAD BETWEEN '" + DTOS(mv_par07) + "' AND '" + DTOS(mv_par08) + "' "
cQuery += "	  AND DF0.DF0_STATUS BETWEEN '" + StrZero(mv_par09,Len(DF0->DF0_STATUS)) + "' AND '" + StrZero(mv_par10,Len(DF0->DF0_STATUS)) + "' "
cQuery += "	  AND DF0.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY DF0.DF0_NUMAGE,DF1.DF1_ITEAGE,DUT.DUT_DESCRI,SB1.B1_DESC,SX5.X5_DESCRI "
cQuery += " ORDER BY DF0.DF0_NUMAGE,DF1.DF1_ITEAGE,DUT.DUT_DESCRI,SB1.B1_DESC,SX5.X5_DESCRI "

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasTRB, .F., .T.)

TcSetField(cAliasTRB,"DATCAD","D",8,0)
TcSetField(cAliasTRB,"DATPRC","D",8,0)
TcSetField(cAliasTRB,"DATPRE","D",8,0)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR12Imp³ Autor ³Eduardo de Souza       ³ Data ³ 03/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao da relacao de agendamentos 					        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³RTMSR12Imp()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR12                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTMSR12Imp(lEnd,wnrel,cString,cNomeProg,Titulo,Tamanho,cAliasTRB)

Local cbCont	 := 00
Local Cbtxt	    := Space( 10 )
Local Cabec1	 := ""
Local Cabec2	 := ""
Local Cabec3	 := ""
Local cOrigem   := ""
Local cDestino  := ""
Local nTamVol   := TamSx3("DF2_QTDVOL")[1]+1
Local nTamUni   := TamSx3("DF2_QTDUNI")[1]+1
Local nTamPes   := TamSx3("DF2_PESO"  )[1]+TamSx3("DF2_PESO"  )[2]+2
Local nTamPM3   := TamSx3("DF2_PESOM3")[1]+TamSx3("DF2_PESOM3")[2]+2
Local nTamVMer  := TamSx3("DF2_VALMER")[1]+TamSx3("DF2_VALMER")[2]+2
Local nPosAtu   := 0
Local nCnt      := 0
Local aRetBox1  := {}
Local aProduto  := {}
Local cStatus   := ""
Local cNumAge   := ""
Local cIteAge   := ""
Local cEnd      := ""
Local cBairro   := ""
Local cMun      := ""
Local cEst      := ""
Local cCEP      := ""
Local cTipVei   := ""

m_pag := 1
li    := 80

DbSelectArea(cAliasTRB)
DbGoTop()
SetRegua(RecCount())
While (cAliasTRB)->(!Eof())	
	
	cNumAge := (cAliasTRB)->NUMAGE

	If lEnd
		li++
		@ PROW()+1,001 PSAY STR0005 //"CANCELADO PELO OPERADOR"
		Exit
	EndIf			

	Cabec(titulo,cabec1,cabec2,cNomeProg,Tamanho,IIF(aReturn[4]==1,15,18))

	@ li,000 PSAY STR0006 + (cAliasTRB)->NUMAGE //"Agendamento.: "
	@ li,056 PSAY STR0007 + DtoC((cAliasTRB)->DATCAD) //"Dt.Cadastro: "
	li++

	@ li,000 PSAY STR0008 + AllTrim((cAliasTRB)->DDD) + " " + (cAliasTRB)->TEL //"DDD/Telefone: "
	li++

	@ li,000 PSAY STR0009 + Posicione("DUE",1,xFilial("DUE")+(cAliasTRB)->DDD+(cAliasTRB)->TEL,"DUE_NOME") //"Solicitante.: "
	@ li,056 PSAY STR0010 + DUE->DUE_CONTAT //"Contato....: "
	li++
	
	If !Empty((cAliasTRB)->SEQEND)
		cEnd := Posicione("DUL",1,xFilial("DUE")+(cAliasTRB)->DDD+(cAliasTRB)->TEL+(cAliasTRB)->SEQEND,"DUL_END")
		cBairro := DUL->DUL_BAIRRO
		cMun    := DUL->DUL_MUN
		cEst    := DUL->DUL_EST
		cCEP    := DUL->DUL_CEP		
	Else
		cEnd    := DUE->DUE_END
		cBairro := DUE->DUE_BAIRRO
		cMun    := DUE->DUE_MUN
		cEst    := DUE->DUE_EST
		cCEP    := DUE->DUE_CEP
	EndIf

	@ li,000 PSAY STR0011 + cEnd //"Endereco....: "
	@ li,056 PSAY STR0012 + cBairro //"Bairro.....: "
	li++

	@ li,000 PSAY STR0013 + cMun //"Municipio...: "
	@ li,056 PSAY STR0014 + cEst //"Estado.....: "
	li++

	@ li,000 PSAY STR0015 + Transform( cCEP, PesqPict("DUE","DUE_CEP") ) //"CEP.........: "
	li++
		
	//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
	//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//Item Status Col   Status Ent   Local Coleta Remetente            Destinatario         Origem                         Destino                        Dt.Prev.Col Hr.Prev.Col  Dt.Prev.Ent  Hr.Prev.Ent       Tipo de Veiculo
	//                                                                                      Produto                        Embalagem          Qtd.Vol.    Qtd.Unit.   Peso Real    Peso Cubado  Vlr.Mercadoria
	//999  xxxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 99/99/9999  99:99        99/99/9999   99:99             xxxxxxxxxxxxxxx"       
	//                                                                                      xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxx     99,999     99,999      999,999.9999 999,999.9999 99,999,999,999.99                "
	
	li++
	@ li,000 PSAY __PrtFatLine()
	li++
	@ li,000 PSAY STR0016 //"Item Status Col   Status Ent   Local Coleta Remetente            Destinatario         Origem                         Destino                        Dt.Prev.Col Hr.Prev.Col  Dt.Prev.Ent  Hr.Prev.Ent       Tipo de Veiculo "
	li++
	@ li,000 PSAY STR0017 //"                                                                                      Produto                        Embalagem          Qtd.Vol.    Qtd.Unit.   Peso Real    Peso Cubado  Vlr.Mercadoria"
	li++
	@ li,000 PSAY __PrtFatLine()
	li+=2

	While (cAliasTRB)->(!Eof()) .And. (cAliasTRB)->NUMAGE == cNumAge

		cIteAge  := (cAliasTRB)->ITEAGE
		aProduto := {}

		If lEnd
			li++
			@ PROW()+1,001 PSAY STR0005 //"CANCELADO PELO OPERADOR"
			Exit
		EndIf			

		If li > 55
			cabec1 := STR0016 //"Item Status Col   Status Ent   Local Coleta Remetente            Destinatario         Origem                         Destino                        Dt.Prev.Col Hr.Prev.Col  Dt.Prev.Ent  Hr.Prev.Ent       Tipo de Veiculo "
			cabec2 := STR0017 //"                                                                                      Produto                        Embalagem          Qtd.Vol.    Qtd.Unit.   Peso Real    Peso Cubado  Vlr.Mercadoria"
			Cabec(titulo,cabec1,cabec2,cNomeProg,Tamanho,IIF(aReturn[4]==1,15,18))
		EndIf

		@ li,000 PSAY (cAliasTRB)->ITEAGE
	
		aRetBox1 := RetSx3Box( Posicione('SX3', 2, 'DF1_STACOL', 'X3CBox()' ),,, 1 )
		cStatus  := AllTrim( aRetBox1[ Ascan( aRetBox1, { |x| x[ 2 ] == (cAliasTRB)->STACOL} ), 3 ])
		@ li,005 PSAY cStatus
	
		aRetBox1 := RetSx3Box( Posicione('SX3', 2, 'DF1_STAENT', 'X3CBox()' ),,, 1 )
		cStatus  := AllTrim( aRetBox1[ Ascan( aRetBox1, { |x| x[ 2 ] == (cAliasTRB)->STAENT} ), 3 ])
		@ li,018 PSAY cStatus
	
		aRetBox1 := RetSx3Box( Posicione('SX3', 2, 'DF1_LOCCOL', 'X3CBox()' ),,, 1 )
		cStatus  := AllTrim( aRetBox1[ Ascan( aRetBox1, { |x| x[ 2 ] == (cAliasTRB)->LOCCOL} ), 3 ])
		@ li,031 PSAY cStatus
	
		@ li,044 PSAY Posicione("SA1",1,xFilial("SA1")+(cAliasTRB)->CLIREM+(cAliasTRB)->LOJREM,"A1_NREDUZ")
		cOrigem  := SA1->A1_MUN
	
		@ li,065 PSAY Posicione("SA1",1,xFilial("SA1")+(cAliasTRB)->CLIDES+(cAliasTRB)->LOJDES,"A1_NREDUZ")
		cDestino := SA1->A1_MUN
	
		@ li,086 PSAY cOrigem
		@ li,117 PSAY cDestino
		@ li,148 PSAY (cAliasTRB)->DATPRC 
		@ li,160 PSAY Transform((cAliasTRB)->HORPRC, PesqPict("DF1","DF1_HORPRC"))
		@ li,173 PSAY (cAliasTRB)->DATPRE
		@ li,186 PSAY Transform((cAliasTRB)->HORPRE, PesqPict("DF1","DF1_HORPRE"))
		@ li,204 PSAY (cAliasTRB)->TIPVEI
		li++      

		cTipVei := (cAliasTRB)->TIPVEI

		While (cAliasTRB)->(!Eof()) .And. (cAliasTRB)->NUMAGE + (cAliasTRB)->ITEAGE == cNumAge + cIteAge
			//-- Imprime todos tipos de veiculos.
			If cTipVei <> (cAliasTRB)->TIPVEI
				cTipVei := (cAliasTRB)->TIPVEI
				@ li,204 PSAY (cAliasTRB)->TIPVEI
				li++      
			EndIf
			//-- Armazena os produtos
			If Ascan( aProduto, { |x| x[1] + x[2] + x[3] + x[4] == cNumAge + cIteAge + (cAliasTRB)->PRODUTO + (cAliasTRB)->EMBALAGEM } ) == 0
				Aadd( aProduto, { cNumAge, cIteAge, (cAliasTRB)->PRODUTO, (cAliasTRB)->EMBALAGEM, (cAliasTRB)->QTDVOL, (cAliasTRB)->QTDUNI, (cAliasTRB)->PESO, (cAliasTRB)->PESOM3, (cAliasTRB)->VALMER } )
			EndIf
			(cAliasTRB)->(DbSkip())
		EndDo

		//-- Imprime os produtos
		For nCnt := 1 To Len(aProduto)
			@ li,086 PSAY SubStr(aProduto[nCnt,3],1,30)
			@ li,117 PSAY SubStr(aProduto[nCnt,4],1,15)
			@ li,136 PSAY Right(Transform(aProduto[nCnt,5],PesqPictQt("DF2_QTDVOL")),nTamVol  )
			@ li,148 PSAY Right(Transform(aProduto[nCnt,6],PesqPictQt("DF2_QTDUNI")),nTamUni  )
			@ li,160 PSAY Right(Transform(aProduto[nCnt,7],PesqPictQt("DF2_PESO"  )),nTamPes  )
			@ li,173 PSAY Right(Transform(aProduto[nCnt,8],PesqPictQt("DF2_PESOM3")),nTamPM3  )
			@ li,186 PSAY Right(Transform(aProduto[nCnt,9],PesqPictQt("DF2_VALMER")),nTamVMer )
			li++
		Next nCnt
		li++
	EndDo
EndDo

If Li != 80
	roda(CbCont,cbtxt,Tamanho)
EndIf

//-- Se impressao em disco, chama o gerenciador de impressao...
If aReturn[5] == 1
	SET PRINTER TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

//-- Apaga arquivos tempor rios
If Select(cAliasTRB) > 0
	(cAliasTRB)->(DbCloseArea())
EndIf

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR12SX1³ Autor ³Eduardo de Souza       ³ Data ³ 08/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajuste de Perguntas (SX1)                 				     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR12SX1()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR12                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTMSR12SX1()

PutSx1( "RTMR12", "01","Agendamento De  ?"   ,"¿De Agendamiento?"		,"From Scheduling ?"	,"mv_ch1","C" , 6,0,0,"G","","DUW","","","mv_par01")
PutSx1( "RTMR12", "02","Agendamento Até ?"   ,"¿A Agendamiento?"		,"To Scheduling?"		,"mv_ch2","C" , 6,0,0,"G","","DUW","","","mv_par02")
PutSx1( "RTMR12", "03","DDD De ?"            ,"¿De DDN?"         		,"From DDD?"         ,"mv_ch3","C" , 3,0,0,"G","","DUE","","","mv_par03")
PutSx1( "RTMR12", "04","Telefone De ?"       ,"¿De Teléfono?"    		,"From Telephone?"   ,"mv_ch4","C" ,15,0,0,"G","",""   ,"","","mv_par04")
PutSx1( "RTMR12", "05","DDD Ate ?"           ,"¿A DDN?"          		,"To DDD?"           ,"mv_ch5","C" , 3,0,0,"G","","DUE","","","mv_par05")
PutSx1( "RTMR12", "06","Telefone Ate ?"      ,"¿A Teléfono?"     		,"To Telephone?"     ,"mv_ch6","C" ,15,0,0,"G","",""   ,"","","mv_par06")
PutSx1( "RTMR12", "07","Data De"             ,"¿De Fecha?"       		,"From Date"         ,"mv_ch7","D" , 8,0,0,"G","",""   ,"","","mv_par07")
PutSx1( "RTMR12", "08","Data Ate"            ,"¿A Fecha?"        		,"To Date"           ,"mv_ch8","D" , 8,0,0,"G","",""   ,"","","mv_par08")
PutSx1( "RTMR12", "09","Status Agend. De ?"  ,"¿De Estatus Agend.?"	,"From Sched.Status?","mv_ch9","N" , 1,0,1,"C","",""   ,"","","mv_par09","A Confirmar","Por Confirmar","To be Confirmed","","Confirmado","Confirmado","Confirmed","Em Processo","En Proceso","In Process","Encerrado","Finalizado","Concluded","Cancelado","Anulado","Cancelled")
PutSx1( "RTMR12", "10","Status Agend. Ate ?" ,"¿A Estatus Agend.?"	,"To Sched.Status?"	,"mv_chA","N" , 1,0,1,"C","",""   ,"","","mv_par10","A Confirmar","Por Confirmar","To be Confirmed","","Confirmado","Confirmado","Confirmed","Em Processo","En Proceso","In Process","Encerrado","Finalizado","Concluded","Cancelado","Anulado","Cancelled")

Return Nil
