/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³TMKMala   ºAutor  ³Rafael M. Quadrotti º Data ³  23/04/01   º±±
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
User Function TmkMala(cWord,cPEEntida,cPECodEnt,cPEContat) //Arquivo do Word,Entidade,Cod.Entidade,Contato


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
OLE_SetDocumentVar(cWord, "c_Data"     , DtoC(dDatabase) )
OLE_SetDocumentVar(cWord, "c_Contato"  , cContato         )
OLE_SetDocumentVar(cWord, "c_Empresa"  , cEmpresa         )
OLE_SetDocumentVar(cWord, "c_End"      , cEnd             )
OLE_SetDocumentVar(cWord, "c_Bairro"   , cBairro          )
OLE_SetDocumentVar(cWord, "c_Cep"      , cCep             )
OLE_SetDocumentVar(cWord, "c_Mun"      , cMun             )
OLE_SetDocumentVar(cWord, "c_Est"      , cEst             )
OLE_SetDocumentVar(cWord, "c_Remetente", cRemetente       )



RestArea(aSaveArea)

Return .T.
