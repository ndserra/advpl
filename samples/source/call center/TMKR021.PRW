#INCLUDE "TMKR021.ch"
#INCLUDE "RWMAKE.CH"  
#INCLUDE "TMKR021.CH"

#DEFINE DESLOC_ETQ  57

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TMKR021  ³ Autor ³ Armando M. Tessaroli  ³ Data ³ 01/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Etiquetas para mala direta de clientes                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Clientes (SA1)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data/Bops/Ver ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TMKR021()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local wnrel   	:= "TMKR021"  	 	// Nome do Arquivo utilizado no Spool
Local Titulo 	:= STR0001			// "Etiqueta para Mala Direta"
Local cDesc1 	:= STR0002 			// "Este programa ira emitir etiquetas para"
Local cDesc2 	:= STR0003 			// "mala direta."
Local cDesc3 	:= STR0004 			// "Informe os parametros de selecao dos clientes"
Local nReg   	:= 0
Local nomeprog	:= "TMKR021.PRX"		// nome do programa
Local cString 	:= "SA1"				// Alias utilizado na Filtragem
Local lDic    	:= .F. 					// Habilita/Desabilita Dicionario
Local lComp   	:= .F. 					// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro 	:= .T. 					// Habilita/Desabilita o Filtro

Private Tamanho := "G" 					// P/M/G
Private Limite  := 220 					// 80/132/220
Private aReturn := { STR0005,;			// [1] Reservado para Formulario	//"Zebrado"
					 1,;				// [2] Reservado para N§ de Vias
					 STR0006,;			// [3] Destinatario					//"Administracao"
					 2,;				// [4] Formato => 1-Comprimido 2-Normal	
					 2,;	    		// [5] Midia   => 1-Disco 2-Impressora
					 1,;				// [6] Porta ou Arquivo 1-LPT1... 4-COM1...
					 "",;				// [7] Expressao do Filtro
					 1 } 				// [8] Ordem a ser selecionada
					 					// [9]..[10]..[n] Campos a Processar (se houver)
Private m_pag   := 1  				 	// Contador de Paginas
Private nLastKey:= 0  				 	// Controla o cancelamento da SetPrint e SetDefault
Private cPerg   := "TMK021"  		 	// Pergunta do Relatorio
Private aOrdem  := {}  				 	// Ordem do Relatorio

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                          ³
//³ Mv_Par01           // Do CLiente                              ³
//³ Mv_Par02           // Ate o Cliente                           ³
//³ Mv_Par03           // Do CEP                                  ³
//³ Mv_Par04           // Ate o CEP                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	Set Filter to
	Return
Endif

RptStatus({|lEnd| TK021Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Return(.T.)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TK021Imp ³ Autor ³ Armando M. Tessaroli  ³ Data ³ 01/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Emissao das etiquetas para mala direta.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Call Center                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TK021Imp(lEnd,wnrel,cString,nomeprog,Titulo)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao Do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aStruSA1	:= {}
Local nLi		:= 0			// Linha a ser impressa
Local nMax		:= 58			// Maximo de linhas suportada pelo relatorio
Local cbCont	:= 0			// Numero de Registros Processados
Local cbText	:= SPACE(10)	// Mensagem do Rodape
Local cCabec1	:= "" 			// Label dos itens
Local cCabec2	:= "" 			// Label dos itens
Local cQryAd	:= ""
Local cName		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis especificas para este relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aEtiq[8,4]				// Array que gerencia a impressão das etiquetas
Local nEtiqueta		:= 1		// Coluna da etiqueta
Local nI			:= 0		// Controle
Local nJ			:= 0		// Controle
Local nX			:= 0
Local nCol			:= 0		// Coluna de impressao

#IFDEF TOP
	Local cQuery		:= ""		// Monta a query para top
	Local aSetField		:= {}		// Parametros para SetField do alias principal
	Local cCampos		:= ""		// Campos do alias principal para select
#ENDIF


DbSelectArea("SA1")
DbSetOrder(1)
SetRegua(RecCount())

#IFDEF TOP

	aStruSA1  := SA1->(dbStruct())
	
	TkSelect(cString, @cCampos, @aSetField)

	cQuery :=	" SELECT	A1_COD, A1_CEP, A1_NOME, A1_END, A1_ENDENT, A1_MUN, A1_EST "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca campos especificos no filtro de usuário³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aReturn[7])
		For nX := 1 To SA1->(FCount())
			cName := SA1->(FieldName(nX))
			If AllTrim( cName ) $ aReturn[7]
				If aStruSA1[nX,2] <> "M"
					If !cName $ cQuery .And. !cName $ cQryAd
		        	cQryAd += ","+cName
					EndIf
				EndIf
			EndIf
		Next nX
	EndIf

    cQuery += cQryAd		
	
	cQuery +=	" FROM " +	RetSqlName("SA1") + " SA1 "
	
	cQuery +=	" WHERE	SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND " +;
				" 		SA1.A1_COD BETWEEN '" + Mv_Par01 + "' AND '" + Mv_Par02 + "' AND" +;
				" 		SA1.A1_CEP BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "' AND" +;
				"		SA1.D_E_L_E_T_ = ' '" +;
				" ORDER BY " + SqlOrder(IndexKey())
	
	DbSelectArea("SA1")
	DbCloseArea()
	cQuery	:= ChangeQuery(cQuery)
	// MemoWrite("TMKR021.SQL", cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SA1', .F., .T.)
	
	For nI := 1 To Len(aSetField)
		TCSetField(cString, aSetField[nI][1], aSetField[nI][2], aSetField[nI][3], aSetField[nI][4])
	Next nI
	TCSetField('SA1', 'A1_VENCLC',	'D')
	TCSetField('SA1', 'A1_PRICOM',	'D')
	TCSetField('SA1', 'A1_ULTCOM',	'D')
	TCSetField('SA1', 'A1_ULTVIS',	'D')
	TCSetField('SA1', 'A1_DTULTIT',	'D')
	TCSetField('SA1', 'A1_DTULCHQ',	'D')
	TCSetField('SA1', 'A1_DTNASC',	'D')
#ELSE
	DbSeek(xFilial("SA1") + Mv_Par01, .T.)
#ENDIF     

AvalImp(nMax)

While	(!Eof())					.AND.;
		SA1->A1_COD >= Mv_Par01		.AND.;
		SA1->A1_COD <= Mv_Par02
	
	IncRegua()
	
	If lEnd
		@Prow()+1,001 PSay STR0007 //"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (!Empty(aReturn[7])) .AND. (!&(aReturn[7]))
		DbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Avalia os parametros para DBF³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFNDEF TOP
		If SA1->A1_CEP <= Mv_Par03 .or. SA1->A1_CEP >= Mv_Par04
			DbSkip()
			Loop
		Endif
	#ENDIF
	
	For nI:=1 TO 4
			
			_n_Lin := pRow()
			_n_Col := pCol()
			@ _n_Lin,_n_Col PSay chr( getMV( "MV_COMP" ) )
			setPrc( _n_Lin,_n_Col )
			
			Do Case
				Case nEtiqueta == 1 .And. ! Empty(SA1->A1_COD)
					
					aEtiq[1,nEtiqueta] := STR0008 + SA1->A1_COD //"Cliente: "
					aEtiq[2,nEtiqueta] := SA1->A1_NOME
					aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_END),Subs(SA1->A1_END,1,49),Subs(SA1->A1_ENDENT,1,49))
					aEtiq[4,nEtiqueta] := AllTrim(SA1->A1_MUN)+" - "+SA1->A1_EST
					aEtiq[5,nEtiqueta] := STR0009 + Transform(SA1->A1_CEP,"@R 99999-999") //"Cep: "
					aEtiq[6,nEtiqueta] := ""
					aEtiq[7,nEtiqueta] := ""
					aEtiq[8,nEtiqueta] := ""
					
					nEtiqueta++
					
				Case nEtiqueta == 2 .And. ! Empty(SA1->A1_COD)
					
					aEtiq[1,nEtiqueta] := STR0008 + SA1->A1_COD //"Cliente: "
					aEtiq[2,nEtiqueta] := SA1->A1_NOME
					aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_END),Subs(SA1->A1_END,1,49),Subs(SA1->A1_ENDENT,1,49))
					aEtiq[4,nEtiqueta] := AllTrim(SA1->A1_MUN)+" -  "+SA1->A1_EST
					aEtiq[5,nEtiqueta] := STR0009 + Trans(SA1->A1_CEP,"@R 99999-999") //"CEP: "
					aEtiq[6,nEtiqueta] := ""
					aEtiq[7,nEtiqueta] := ""
					aEtiq[8,nEtiqueta] := ""
					
					nEtiqueta++
					
				Case nEtiqueta == 3 .And. ! Empty(SA1->A1_COD)
					
					aEtiq[1,nEtiqueta] := STR0008 + SA1->A1_COD //"Cliente: "
					aEtiq[2,nEtiqueta] := SA1->A1_NOME
					aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_END),Subs(SA1->A1_END,1,49),Subs(SA1->A1_ENDENT,1,49))
					aEtiq[4,nEtiqueta] := AllTrim(SA1->A1_MUN)+" - "+SA1->A1_EST
					aEtiq[5,nEtiqueta] := STR0009 + Trans(SA1->A1_CEP,"@R 99999-999") //"CEP: "
					aEtiq[6,nEtiqueta] := ""
					aEtiq[7,nEtiqueta] := ""
					aEtiq[8,nEtiqueta] := ""
					
					nEtiqueta++
					
				Case nEtiqueta == 4 .And. ! Empty(SA1->A1_COD)
					
					
					aEtiq[1,nEtiqueta] := STR0008 + SA1->A1_COD //"Cliente: "
					aEtiq[2,nEtiqueta] := SA1->A1_NOME
					aEtiq[3,nEtiqueta] := IIF(!empty(SA1->A1_END),Subs(SA1->A1_END,1,49),Subs(SA1->A1_ENDENT,1,49))
					aEtiq[4,nEtiqueta] := AllTrim(SA1->A1_MUN)+" - "+SA1->A1_EST
					aEtiq[5,nEtiqueta] := STR0009 + Trans(SA1->A1_CEP,"@R 99999-999") //"CEP: "
					aEtiq[6,nEtiqueta] := ""
					aEtiq[7,nEtiqueta] := ""
					aEtiq[8,nEtiqueta] := ""
					
					nEtiqueta := 1
					For nI:= 1 TO 8
						For nJ := 1 TO 4
							@ nLi,nCol  PSay aEtiq[nI,nJ]
							nCol += DESLOC_ETQ
						Next nJ
						nLi++
						nCol := 0
					Next nI
					
					For nI:= 1 TO 8
						For nJ:=1 TO 4
							aEtiq[nI,nJ] := ""
						Next nJ
					Next nI
					nLi++
					If nLi > nMax
						nLi := 0
						m_pag++
					EndIf
			EndCase

			DbSelectArea("SA1")
			Dbskip()
		
			While !SA1->( Eof())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Considera filtro do usuario                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (!Empty(aReturn[7])) .AND. (&(aReturn[7]))
					Exit
				Else 
					DbSkip()
					Loop		
				Endif		
			End	
	Next nI
	
End

For nI:= 1 TO 8
	For nJ:=1 TO 4
		If !EMPTY(aEtiq[nI,nJ])
			@ nLi,nCol  PSay aEtiq[nI,nJ]
			nCol += DESLOC_ETQ
		Endif
	Next nJ
	nLi++
	nCol := 0
Next nI


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso nada tenha sido impresso, entao imprime uma menssagem de aviso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLi == 0
	nLi := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,nChrComp)
	nLi++
	@ nLi,000 PSay STR0010 //"Nao existem dados a serem impressos para este relatorio com os parametros informados"
Endif

#IFDEF TOP
	DbSelectArea("SA1")
	DbCloseArea()
	ChkFile("SA1")
#ENDIF

Set Device To Screen
If ( aReturn[5] = 1 )
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return(.T.)
