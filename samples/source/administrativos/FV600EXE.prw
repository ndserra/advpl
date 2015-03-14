#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FV600EXE  ºAutor  ³Microsiga           º Data ³  01/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exemplo para preenchimento de variaveis da vistoria         º±±
±±º          ³tecnica usando a integracao com o WORD.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
    
User Function FV600EXE()

Local aArea		:= GetArea()						//Armazena area atual
Local hWord 	:= ParamIXB[1]						//Objeto usado para preenchimento       
Local cVistoria	:= Space(TamSX3("AAT_CODVIS")[1])  //Código da Vistoria
Local cOportun	:= Space(TamSX3("AAT_OPORTU")[1])	//Código da Oportunidade 
Local cDtEmiss	:= Space(TamSX3("AAT_EMISSA")[1])	//Data de emissao   
Local cProposta	:= Space(TamSX3("AAT_PROPOS")[1])  //Código da Proposta Comercial
Local cCodigo	:= Space(TamSX3("A1_COD")[1])		//Codigo da entidade (cliente ou prospect)
Local cLoja		:= Space(TamSX3("A1_LOJA")[1])		//Loja 
Local cNome 	:= Space(TamSX3("A1_NOME")[1])		//Nome
Local cEndereco	:= Space(TamSX3("A1_END")[1])   	//Endereco
Local cBairro	:= Space(TamSX3("A1_BAIRRO")[1])   //Bairro
Local cCidade	:= Space(TamSX3("A1_MUN")[1])  	//Cidade
Local cUF		:= Space(TamSX3("A1_ESTADO")[1])  	//Estado (UF)  
Local nY		:= 0    
Local nI		:= 0

cPeriodo	:= DTOC(AAT->AAT_DTINI)+" "+AAT->AAT_HRINI+" até "+DTOC(AAT->AAT_DTFIM)+" "+AAT->AAT_HRFIM
cVistoria 	:= AAT->AAT_CODVIS
cDtEmiss 	:= DTOC(AAT->AAT_EMISSA) 
cOportun 	:= AAT->AAT_OPORTU   
cProposta 	:= AAT->AAT_PROPOS
cVistoriad	:= AAT->AAT_VISTOR+" - "+Capital(Posicione("AA1",1,xFilial("AA1")+AAT->AAT_VISTOR,"AA1_NOMTEC"))
cORevis		:= AAT->AAT_OREVIS
cPRevis		:= AAT->AAT_PREVIS
     

If AAT->AAT_ENTIDA == "1"
	dbSelectArea("SA1")
	dbSetOrder(1)
	IF	dbSeek(xFilial("SA1")+AAT->AAT_CODENT+AAT->AAT_LOJENT)
		cCodigo		:= AAT->AAT_CODENT
		cLoja		:= AAT->AAT_LOJENT
		cNome 		:= A1_NOME
		cEndereco	:= A1_END
		cBairro		:= A1_BAIRRO
		cCidade		:= A1_MUN
		cUF			:= A1_EST
		cDescEnt	:= A1_NREDUZ
	EndIf
Else
	dbSelectArea("SUS")
	dbSetOrder(1)
	IF	dbSeek(xFilial("SUS")+AAT->AAT_CODENT+AAT->AAT_LOJENT)
		cCodigo		:= AAT->AAT_CODENT
		cLoja		:= AAT->AAT_LOJENT
		cNome 		:= US_NOME
		cEndereco	:= US_END
		cBairro		:= US_BAIRRO
		cCidade		:= US_MUN
		cUF			:= US_EST
		cDescEnt	:= US_NREDUZ
	EndIf
EndIf 

cNomeWord	:=	""
cNomeWord	:= "VT"+cVistoria

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descricao da Oportunidade de Venda         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_SetDocumentVar(hWord,'cDesOport',Capital(Posicione("AD1",1,xFilial("AD1")+AAT->AAT_OPORTU,"AD1_DESCRI")))  

//Cabeçalho  
OLE_SetDocumentVar(hWord,'cVistoria'	,cVistoria)
OLE_SetDocumentVar(hWord,'cTpVist'	,Capital(Posicione("ABT",1,xFilial("ABT")+AAT->AAT_CODABT,"ABT_DESCRI")))
OLE_SetDocumentVar(hWord,'cCodigo'	,cCodigo) 
OLE_SetDocumentVar(hWord,'cLoja'	,cLoja) 
OLE_SetDocumentVar(hWord,'cNome'	,cNome) 
OLE_SetDocumentVar(hWord,'cDtEmissao'	,cDtEmiss)
OLE_SetDocumentVar(hWord,'cOportun'	,cOportun)
OLE_SetDocumentVar(hWord,'cProposta'	,cProposta) 
OLE_SetDocumentVar(hWord,'cPeriodo'	,cPeriodo)
OLE_SetDocumentVar(hWord,'cVistoriador'	,cVistoriad)
OLE_SetDocumentVar(hWord,'cORevis'	,cORevis)
OLE_SetDocumentVar(hWord,'cPRevis'	,cPRevis)

DbSelectArea("AAU")
DbSetOrder(1)
If DbSeek(xFilial("AAU")+cVistoria)

	While AAU->(!Eof()) .AND. xFilial("AAU")+ cVistoria == AAU->(AAU_FILIAL+AAU_CODVIS)
		 
	  	DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+AAU->AAU_PRODUT)
		
	  	If SB1->B1_TIPO == "MO" //(Produto mão de obra) fica no quadro colaboradores
		
			nI++
		        
			OLE_SetDocumentVar(hWord,"cDescMO"+Alltrim(str(nI))  ,Alltrim( Posicione("SB1",1,xFilial("SB1")+AAU->AAU_PRODUT,"B1_DESC") ) )
			OLE_SetDocumentVar(hWord,"nColab"+Alltrim(str(nI))  ,"")
			OLE_SetDocumentVar(hWord,"cTurno"+Alltrim(str(nI))  ,"")
			OLE_SetDocumentVar(hWord,"cLocalMO"+Alltrim(str(nI))  ,Alltrim(Posicione("ABS",1,xFilial("ABS")+AAU->AAU_LOCAL,"ABS_DESCRI")))

		Else  
		
			nY++
		
			OLE_SetDocumentVar(hWord,"cDescP"+Alltrim(str(nY))  ,Alltrim( Posicione("SB1",1,xFilial("SB1")+AAU->AAU_PRODUT,"B1_DESC") ) )
			OLE_SetDocumentVar(hWord,"cFabric"+Alltrim(str(nY)) ,"")
			OLE_SetDocumentVar(hWord,"nQuant"+Alltrim(str(nY)) ,Alltrim(Transform(AAU->AAU_QTDVEN,"999,999,999.99")))
			OLE_SetDocumentVar(hWord,"cUnidade"+Alltrim(str(nY)) ,AAU->AAU_UM) 
			OLE_SetDocumentVar(hWord,"cLocal"+Alltrim(str(nY)) ,Alltrim(Posicione("ABS",1,xFilial("ABS")+AAU->AAU_LOCAL,"ABS_DESCRI"))) 
			OLE_SetDocumentVar(hWord,"nDeprec"+Alltrim(str(nY)) ,"") 

		
	 	EndIf            
		
	AAU->(DbSkip())		
	End   

	If nY > 0

	OLE_SetDocumentVar(hWord,'nItens_Vistoria',Alltrim(Str(nY))) //Nome do indicado da tabela no WORD
	OLE_ExecuteMacro(hWord,"Itens_Vistoria") // Nome da macro usada para atualizar os itens	

	EndIf
     
   If nI > 0
    
    OLE_SetDocumentVar(hWord,'nItens_VistoriaMO',Alltrim(Str(nI))) //Nome do indicado da tabela no WORD
	OLE_ExecuteMacro(hWord,"Itens_VistoriaMO") // Nome da macro usada para atualizar os itens	
    
   EndIf        
    
EndIf	

RestArea(aArea)

Return