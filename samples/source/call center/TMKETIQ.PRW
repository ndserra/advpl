/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³TMKEtiq   ºAutor  ³Rafael M. Quadrotti º Data ³  23/04/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao com o Microsoft Word para criacao dos arquivos  º±±
±±º          ³ de Mala Direta                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data/Bops/Ver ³Manutencao Efetuada                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAndrea F. ³12/05/04³811   ³Impl. Continua- Identificar o campo CIDADE  º±±
±±º          ³        ³      ³da tabela ACH com o ALIAS na frente.        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TMKETIQ(cWord,cPEEntida,cPECodEnt,cPEContat,cLista) //Entidade,Cod.Entidade,Contato,Codigo da Lista


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cContato     := ""
Local cEnd     	   := ""
Local cBairro      := ""
Local cCep         := ""
Local cMun         := ""
Local cEst         := ""
Local cEmpresa     := ""
Local cRemetente   := SM0->M0_NOMECOM

Local cAlias       := ""
Local aSaveArea    := GetArea()

Local cCampo       := ""

Local cCPOEnd      := ""
Local cCPOBairro   := ""
Local cCPOMun      := ""
Local cCPOEst 	   := ""
Local cCPOCep      := ""

//Variaveis para envio dos dados ao word
Local c_Data      := ""
Local c_Contato   := ""
Local c_Empresa   := ""
Local c_End       := ""
Local c_Bairro    := ""
Local c_Cep       := ""
Local c_Mun       := ""
Local c_Est       := ""
Local c_Remetente := ""

//Controle de impressao de etiquetas.
Local nEtiqueta := 0  // Contador do Contato


DbSelectArea("SU6")
DbSetOrder(1)   
DbSeek(xFilial("SU6") + cLista)
While !Eof() .AND. (SU6->U6_FILIAL == xFilial("SU6")) .AND. (SU6->U6_LISTA == cLista)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Incrementa o contador de etiquetas.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nEtiqueta++
			
	
	
	cAlias  := Alltrim(cPEEntida)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega a descricao da empresa .³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea(cAlias)
	DbSetOrder(1)
	
	If  cAlias == "SU2"
		cCampo := SubStr(cAlias,2,2) + "_DPRO"
	ElseIf cAlias == "ACH"
		cCampo := cAlias + "_RAZAO"
	Else
		If UPPER(Substr(cAlias,1,1)) == "S"
			cCampo := SubStr(cAlias,2,2) + "_NOME"
		Else
			cCampo := cAlias + "_NOME"		
		EndIf
	EndIf
	
	If DbSeek (xFilial(cAlias) + Alltrim(cPECodEnt))
		cEmpresa := &(cAlias +"->"+cCampo)
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega o nome do contato se este existir.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cPEContat)
		dbSelectArea("SU5")
		dbSetOrder(1)
		dbSeek(xFilial("SU5") + cPEContat)
		cContato:= SU5->U5_CONTAT
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica qual o tipo de endereco selecionado.³
		//³1= Residencial, 2= Comercial                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SU4->U4_TIPOEND == "1") //Endereco Residencial
			cEnd    := SU5->U5_END
			cBairro := SU5->U5_BAIRRO
			cMun    := SU5->U5_MUN
			cEst    := SU5->U5_EST
			cCep    := SU5->U5_CEP
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o Endereco for comercial ou o contato nao³
	//³existir os dados para envio serao os dados da³
	//³entidade.                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	(SU4->U4_TIPOEND == "2") .Or. Empty(cPEContat)
		
		cCPOEnd    := Iif(UPPER(SubStr(cAlias,1,1))=="S", SubStr(cAlias,2,2) + "_END",cAlias+"_END"   )
		cCPOBairro := Iif(UPPER(SubStr(cAlias,1,1))=="S", SubStr(cAlias,2,2) + "_END",cAlias+"_BAIRRO")
		cCPOMun    := Iif(UPPER(SubStr(cAlias,1,1))=="S", SubStr(cAlias,2,2) + "_END",cAlias+"_MUN"   )
		cCPOEst    := Iif(UPPER(SubStr(cAlias,1,1))=="S", SubStr(cAlias,2,2) + "_END",cAlias+"_EST"   )
		cCPOCep    := Iif(UPPER(SubStr(cAlias,1,1))=="S", SubStr(cAlias,2,2) + "_END",cAlias+"_CEP"   )
		
		If DbSeek (xFilial(cAlias) + Alltrim(cPECodEnt))
			cEnd    := &(cAlias + "->" + cCPOEnd)
			cBairro := Iif(cAlias == "SUS"," ",&(cAlias + "->" + cCPOBairro))
			If cAlias == "ACH"
				cMun := ACH->ACH_CIDADE
			ElseIf  cAlias == "JA2"
				cMun := " "
			else 
				cMun :=	&(cAlias + "->" + cCPOMun )
			EndIf
			cEst    := &(cAlias +"->"+ cCPOEst)
			cCep    := &(cAlias +"->"+ cCPOCep)
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ -Funcao que atualiza as variaveis do Word.                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nEtiqueta = 1
		OLE_SetDocumentVar(cWord, "c_Data"     , DtoC(dDatabase) )
		OLE_SetDocumentVar(cWord, "c_Contato"  , cContato         )
		OLE_SetDocumentVar(cWord, "c_Empresa"  , cEmpresa         )
		OLE_SetDocumentVar(cWord, "c_End"      , cEnd             )
		OLE_SetDocumentVar(cWord, "c_Bairro"   , cBairro          )
		OLE_SetDocumentVar(cWord, "c_Cep"      , cCep             )
		OLE_SetDocumentVar(cWord, "c_Mun"      , cMun             )
		OLE_SetDocumentVar(cWord, "c_Est"      , cEst             )
		OLE_SetDocumentVar(cWord, "c_Remetente", cRemetente       )
	
	ElseIf  nEtiqueta > 1
	
		c_Data      := "c_Data"      + Alltrim(Str(nEtiqueta))
		c_Contato   := "c_Contato"   + Alltrim(Str(nEtiqueta))
		c_Empresa   := "c_Empresa"   + Alltrim(Str(nEtiqueta))
		c_End       := "c_End"       + Alltrim(Str(nEtiqueta))
		c_Bairro    := "c_Bairro"    + Alltrim(Str(nEtiqueta))
		c_Cep       := "c_Cep"       + Alltrim(Str(nEtiqueta))
		c_Mun       := "c_Mun"       + Alltrim(Str(nEtiqueta))
		c_Est       := "c_Est"       + Alltrim(Str(nEtiqueta))
		c_Remetente := "c_Remetente" + Alltrim(Str(nEtiqueta))
		
	
		OLE_SetDocumentVar(cWord, c_Data     , DtoC(dDatabase) )
		OLE_SetDocumentVar(cWord, c_Contato  , cContato         )
		OLE_SetDocumentVar(cWord, c_Empresa  , cEmpresa         )
		OLE_SetDocumentVar(cWord, c_End      , cEnd             )
		OLE_SetDocumentVar(cWord, c_Bairro   , cBairro          )
		OLE_SetDocumentVar(cWord, c_Cep      , cCep             )
		OLE_SetDocumentVar(cWord, c_Mun      , cMun             )
		OLE_SetDocumentVar(cWord, c_Est      , cEst             )
		OLE_SetDocumentVar(cWord, c_Remetente, cRemetente       )
		
	EndIf
     
    DbSelectArea("SU6")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³A funcao DbSkip esta posicionada aqui para que a validação de quebra   ³
	//³de pagina das etiquetas para que possa funcionar normalmente e nao seja|
	//³apresentada a mensagem de erro do word.                                ³
	//³A posicao do Skip nao influenciara diretamente na logica normal de laco³
	//³while                                                                  ³
	//³  dbskip()                                                             ³
	//³End                                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	DbSkip()
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se preencheu as 10 etiquetas imprime uma pagina.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nEtiqueta == 10) .OR. (EOF())
		nEtiqueta:= 0
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³-Funcao que atualiza os campos da memoria para o Documento, utilizada logo apos a  ³
		//³funcao OLE_SetDocumentVar().														  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		OLE_UpdateFields(cWord)
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³-Funcao que imprime o Documento corrente podendo ser especificado o numero de copias,  ³
		//³podedo tambem imprimir com um intervalo especificado nos parametros "nPagInicial" ate  ³
		//³"nPagFinal" retirando o parametro "ALL".												  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		OLE_PrintFile(cWord,"ALL",,,)
		
	Endif
End

RestArea(aSaveArea)
	
Return .T.
