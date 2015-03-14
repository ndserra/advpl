# Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UpdPA         º Autor ³ Marcelo Celi MarquesºData ³ 24/09/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Conceitualmente um Pagamento Antecipado no Brasil não pode serº±±
±±º          ³ compensado sem movimento bancario, como existiam clientes     º±±
±±º          ³ utilizando a rotina antes do conceito ser aplicado, esse      º±± 
±±º          ³ RDMake foi criado para gerar a movimentação bancaria de PAs   º±±
±±º          ³ que na geracao nao gerou movimento.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gera Movimento Bancario para PAs sem cheque                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function UpdPA()

	Local cAlias 	:= "SE5" 
	Local cMarca 	:= GetMark()  
	Local aCampos	:= {}   
	Local nOpcA 	:= 0
	Local nCntRegs 	:= 0
	Local dChaveDe	:= dDataBase
	Local dChaveAte	:= dDataBase 
	Local cFiltro	:= ""
	Local oDlg, oPanel	
	
	DEFINE MSDIALOG oDlg FROM	22,9 TO 260,750 TITLE "Pagamentos Antecipados sem Movimentação Bancária" PIXEL  
	oDlg:lMaximized := .F.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT    			
	
	@ 005,005 TO 102,365 OF oPanel PIXEL
	@ 055,010 TO 098,135 LABEL " Composição da Chave: DATA DE EMISSÃO " OF oPanel PIXEL
	
	@ 010,015 Say "Este rdmake retorna os registros de PA - Pagamento Antecipado que não movimentaram saldo bancário dentro de um periodo." OF oPanel PIXEL
	@ 020,015 Say "será necessário informar a faixa de Data Emissao Inicio e Fim para que os registros sejam disponibilizados na tela." OF oPanel PIXEL
	@ 030,015 Say "Os titulos de PA marcados terão um registro gerado na tabela SE5 - Movimentacao bancaria, e o saldo bancário atualizado." OF oPanel PIXEL
	@ 040,015 Say "Referente ao processo de contabilização, observar o exposto no Boletim Tecnico." OF oPanel PIXEL
			
	@ 065,015 Say "Data de:" OF oPanel PIXEL
	@ 080,015 Say "Data ate:" OF oPanel PIXEL
	@ 065,050 MSGET dChaveDe valid dChaveDe <> cTod("") SIZE 30, 10 OF oPanel PIXEL Hasbutton
	@ 080,050 MSGET dChaveAte Valid dChaveAte >= dChaveDe SIZE 30, 10 OF oPanel PIXEL Hasbutton
	
	ACTIVATE MSDIALOG oDlg ON INIT	EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=0,oDlg:End()})	
	If nOpcA <> 1
	   Return
	Endif	
	
	cFiltro := "DTOS(SE5->E5_DATA) >= '" + DTOS(dChaveDe) + "' .And. "
	cFiltro += "DTOS(SE5->E5_DATA) <= '" + DTOS(dChaveAte) + "' .And. " 
	cFiltro += "SE5->E5_FILIAL == '" + xFilial("SE5") + "' .And. "
	cFiltro += "E5_TIPODOC == 'BA' .AND. E5_TIPO == 'PA ' .AND. E5_MOTBX == 'NOR'"
	
	DbSelectArea("SE5")
	cIndex := CriaTrab(nil,.f.)
	cChave	:= SE5->(IndexKey(7))
	IndRegua("SE5",cIndex,cChave,,cFiltro,"Selecionando Registros")
	nIndex := RetIndex(cAlias)
	dbSelectArea("SE5")
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	
	dbGotop()
	If Eof() .Or. BOF()
		MsgAlert("Não existem pagamentos antecipados sem movimentação bancaria para o range informado")
	Else
		AADD(aCampos,{"E5_OK"		,"","  "		,""})     
		AADD(aCampos,{"E5_FILIAL"	,"","Filial"	,""})  
		AADD(aCampos,{"E5_DATA"		,"","Data"		,""})  
		AADD(aCampos,{"E5_BANCO"	,"","Banco"		,""})  
		AADD(aCampos,{"E5_AGENCIA"	,"","Agencia"	,""})  
		AADD(aCampos,{"E5_CONTA"	,"","Conta"		,""})		
		AADD(aCampos,{"E5_PREFIXO"	,"","Prefixo"	,""})  
		AADD(aCampos,{"E5_NUMERO"	,"","Numero"	,""})  
		AADD(aCampos,{"E5_PARCELA"	,"","Parcela"	,""})  
		AADD(aCampos,{"E5_TIPO"		,"","Tipo"		,""})   
		AADD(aCampos,{"E5_CLIFOR"	,"","Fornecedor",""})  
		AADD(aCampos,{"E5_LOJA"		,"","Loja"		,""})  		
		AADD(aCampos,{"E5_VALOR"	,"","Valor"		,"@e 999,999,999.99"})  		 
				
		DEFINE MSDIALOG oDlg FROM	22,9 TO 260,750 TITLE "Pagamentos Antecipados sem movimentação bancaria" PIXEL  
		oDlg:lMaximized := .F.
		oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT 
		nOpcA := 0
		
		oMark :=MsSelect():New(cAlias,"E5_OK",,aCampos,,@cMarca,{45,oDlg:nLeft,oDlg:nBottom,oDlg:nRight})
		oMark:oBrowse:lhasMark := .t.
		oMark:oBrowse:lCanAllmark := .f.
		oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
		ACTIVATE MSDIALOG oDlg ON INIT	EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=0,oDlg:End()})	
		If nOpcA == 1
			If MsgYesNo("Confirma a geração de movimento bancário para os pagamentos antecipados selecionados?")	    		    	
		    	Processa( {|| GeraMovimPA(cMarca)},"Inicializando o Processo","Aguarde...",.T.)		    		    	
			Endif		
		Endif	
	Endif
	
	DbSelectArea(cAlias)
	#IFDEF TOP	
		DbCloseArea()
	#ENDIF
	RetIndex("SE5")
	If !Empty(cIndex)
		fErase(cIndex+OrdBagExt())
	Endif
			
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ ÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GeraMovimPA³ Autor ³ Marcelo Celi Marques   ³Data³24/09/09³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ ÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento para geracao do movimento bancario da PA  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ UpdPA     									           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraMovimPA(cMarca)
	dbGotop()
   	nCntRegs := RecCount()
   	ProcRegua(nCntRegs)
   	While ! Eof()   		
		If SE5->E5_OK == cMarca	    	
	    	IncProc("Gerando Movimento Bancário: " + SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
	    	Reclock( "SE5" , .F. )
			E5_TIPODOC := "PA"
	    	MsUnlock()	    	
	    	AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DATA,SE5->E5_VALOR,"-")	    	
	    Else
	    	IncProc("Gerando Movimento Bancário: ")	
	    Endif
	    dbSkip()
	EndDo
Return





