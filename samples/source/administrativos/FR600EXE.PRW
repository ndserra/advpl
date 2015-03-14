#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FR600EXE  ºAutor  ³Eduardo Gomes Juniorº Data ³  19/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exemplo para preenchimento de variaveis e tabelas usando	  º±±
±±º          ³a integracao com o WORD.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FR600Exe()

Local aArea			:= GetArea()						//Armazena area atual
Local hWord 		:= ParamIXB[1]						//Objeto usado para preenchimento
Local cProposta		:= Space(TamSX3("CJ_PROPOST")[1])	//Numero da proposta comercial 
Local cDtEmissao	:= Space(TamSX3("CJ_EMISSAO")[1])	//Data de emissao
Local cCodigo		:= Space(TamSX3("A1_COD")[1])		//Codigo da entidade (cliente ou prospect)
Local cLoja			:= Space(TamSX3("A1_LOJA")[1])		//Loja 
Local cNome 		:= Space(TamSX3("A1_NOME")[1])		//Nome
Local cEndereco		:= Space(TamSX3("A1_END")[1])   	//Endereco
Local cBairro		:= Space(TamSX3("A1_BAIRRO")[1])   //Bairro
Local cCidade		:= Space(TamSX3("A1_MUN")[1])  	//Cidade
Local cUF			:= Space(TamSX3("A1_ESTADO")[1])  	//Estado (UF)
Local nTotProsp		:= 0								//Total da proposta comercial
Local nI			:= 0                               	//Usado no laco do WHILE

cProposta	:= ADY->ADY_PROPOS 
cDescEnt	:= Space(30)
cDtEmissao	:= Dtoc(ADY->ADY_DATA)

If ADY->ADY_ENTIDA == "1"
	dbSelectArea("SA1")
	dbSetOrder(1)
	IF	dbSeek(xFilial("SA1")+ADY->ADY_CODIGO+ADY->ADY_LOJA)
		cCodigo		:= ADY->ADY_CODIGO
		cLoja		:= ADY->ADY_LOJA
		cNome 		:= A1_NOME
		cEndereco	:= A1_END
		cBairro		:= A1_BAIRRO
		cCidade		:= A1_MUN
		cUF			:= A1_EST
		cDescEnt	:= A1_NREDUZ
	Endif
Else
	dbSelectArea("SUS")
	dbSetOrder(1)
	IF	dbSeek(xFilial("SUS")+ADY->ADY_CODIGO+ADY->ADY_LOJA)
		cCodigo		:= ADY->ADY_CODIGO
		cLoja		:= ADY->ADY_LOJA
		cNome 		:= US_NOME
		cEndereco	:= US_END
		cBairro		:= US_BAIRRO
		cCidade		:= US_MUN
		cUF			:= US_EST
		cDescEnt	:= US_NREDUZ
	Endif
Endif 

cNomeWord	:=	""
cNomeWord	:= "Proposta Comercial - "+Alltrim(cDescEnt)+" - " +cProposta

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza variaveis do cabecalho - Variaveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_SetDocumentVar(hWord,'cProposta'	,cProposta)
OLE_SetDocumentVar(hWord,'cDtEmissao'	,cDtEmissao)
OLE_SetDocumentVar(hWord,'cCodigo'		,cCodigo)
OLE_SetDocumentVar(hWord,'cNome'		,cNome)
OLE_SetDocumentVar(hWord,'cEndereco'	,cEndereco)
OLE_SetDocumentVar(hWord,'cBairro'		,cBairro)
OLE_SetDocumentVar(hWord,'cCidade'		,cCidade)
OLE_SetDocumentVar(hWord,'cUF'			,cUF)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza variaveis do item - Tabela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("ADZ")
DbSetOrder(1) //ADZ_FILIAL+ADZ_PROPOS+ADZ_ITEM
If DbSeek(xFilial("ADZ")+cProposta)

	While ADZ->(!Eof()) .and. xFilial("ADZ")+ cProposta == ADZ->(ADZ_FILIAL+ADZ_PROPOS)
		
		nI++

		OLE_SetDocumentVar(hWord,"cProd1"+Alltrim(str(nI))  ,Alltrim( Posicione("SB1",1,xFilial("SB1")+ADZ->ADZ_PRODUT,"B1_DESC") ) )
		OLE_SetDocumentVar(hWord,"nQuant1"+Alltrim(str(nI)) ,Transform(ADZ->ADZ_QTDVEN,"999,999,999.99"))
		OLE_SetDocumentVar(hWord,"nValUni1"+Alltrim(str(nI)),Transform(ADZ->ADZ_PRCVEN,"@EZ 999,999,999.99"))
		OLE_SetDocumentVar(hWord,"nTotal1"+Alltrim(str(nI)) ,Transform(ADZ->ADZ_TOTAL,"@EZ 999,999,999.99")) 
		nTotProsp += ADZ->ADZ_TOTAL

		dbSelectArea("ADZ")
		dbSkip()

	Enddo
	
   	OLE_SetDocumentVar(hWord,'nTotProsp',Transform(nTotProsp,"@EZ 999,999,999.99"))
	
Endif 

If nI > 0

	OLE_SetDocumentVar(hWord,'nItens_Proposta',alltrim(Str(nI))) //Nome do indicado da tabela no WORD
	OLE_ExecuteMacro(hWord,"Itens_Proposta") // Nome da macro usada para atualizar os itens	

Endif

RestArea(aARea)

Return