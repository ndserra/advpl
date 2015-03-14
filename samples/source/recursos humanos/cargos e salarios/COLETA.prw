#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "MSOLE.CH"
#INCLUDE "COLETA.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ COLETA   ³ Autor ³ Equipe R.H.           ³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio                        - VIA WORD                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function COLETA()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros usados na rotina                   ³
//³ mv_par01         Filial                       ³
//³ mv_par02         Cod Pesquisa                 ³
//³ mv_par03         Empresa Patrocinadora        ³
//³ mv_par04         Personalizar S/N             ³
//³ mv_par05         1-Impressora / 2-Arquivo     ³
//³ mv_par06         Nome do arquivo de saida     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Pergunte("COLETA",.F.)

cCadastro := OemtoAnsi(STR0001)	//"Integra‡„o com MS-Word"
aSays	  :={}
aButtons  :={}
nOpca	  := 0

AADD(aSays,OemToAnsi(STR0002) ) //"Esta rotina ir  imprimir o Caderno de Dados para a Pesquisa Salarial"

AADD(aButtons, { 5,.T.,{|| Pergunte("COLETA",.T. )}})
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch()}})
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|| WORDIMP()})  // Chamada do Processamento
EndIf

dbSelectArea("RB0")
dbSetOrder(1)
dbGotop()

dbSelectArea("SRJ")
dbSetOrder(1)
dbGotop()
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ WORDIMP  ³ Autor ³ Cristina Ogura        ³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Coleta das Pesquisas Salariais                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
STATIC FUNCTION WORDIMP()

// Inicializa as variaveis do programa                                        
Local aEmpresa	:= {}
Local aCargos 	:= {}
Local aFator  	:= {}
Local nAte		:= 0       
Local nx		:= 0                     
Local ny		:= 0         
Local nz		:= 0   
Local cFil 		:= ""
Local lImpress	:= ( mv_par05 == 1 )	// Verifica se a saida sera em Tela ou Impressora
Local cArqSaida	:= AllTrim( mv_par06 )	// Nome do arquivo de saida
Local cArqPag	:= ""
Local nPag		:= 0 
Local cPath		:= ""
Local cArqLoc	:= ""
Local nPos		:= 0
Local nBegin	:= 0
    
// Verifica se existe a Empresa Patrocinadora
dbSelectArea("RB0")
dbSetOrder(1)       
cFil := If(xFilial("RB0") == Space(FWGETTAMFILIAL),xFilial("RB0"),mv_par01)

If 	!dbSeek(cFil+mv_par03)			// Filial + Patrocinadora
	Help("",1,"NAOCAD")			// Empresa Patrocinadora nao cadastrada
	Return .T.
EndIf

// Verifica se existe a Pesquisa com os Cargos e Empresas 
dbSelectArea("RB4")   
dbSetOrder(1)                                               
cFil := If(xFilial("RB4") == Space(FWGETTAMFILIAL),xFilial("RB4"),mv_par01)

If dbSeek(cFil+mv_par02)			// Filial + Pesquisa Salarial
	While !Eof() .And. cFil+mv_par02 == RB4->RB4_FILIAL+RB4_PESQ
	
		Aadd(aCargos,{RB4->RB4_FUNCAO,RB4->RB4_FUNPES})
		Aadd(aEmpresa,RB4->RB4_EMPRES)
		
		dbSkip()
	EndDo
	
	If 	Empty(aCargos)
		Help("",1,"NAOFUNCAO")		// Nao ha funcoes selecionadas na pesquisa
		Return .T.
	EndIf
	
	If	Empty(aEmpresa)
		Help("",1,"NAOEMPRESA")	// Nao ha empresas selecionadas na pesquisa
		Return .T.
	EndIf
Else
	Help("",1,"PESQNCAD")				// Pesquisa nao cadastrada
	Return .T.
EndIf

// Seleciona Arquivo Modelo 
cType := "COLETA     | *.DOT"
cArquivo := cGetFile(cType, OemToAnsi(STR0003+Subs(cType,1,6)),,,.T.,GETF_ONLYSERVER )//"Selecione arquivo "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Copiar Arquivo .DOT do Server para Diretorio Local ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos := Rat("\",cArquivo)
If nPos > 0
	cArqLoc := AllTrim(Subst(cArquivo, nPos+1,20 ))
Else 
	cArqLoc := cArquivo
EndIF
cPath := GETTEMPPATH()
If Right( AllTrim(cPath), 1 ) != "\"
   cPath += "\"
Endif
If !CpyS2T(cArquivo, cPath, .T.)
	Return
Endif


// Inicia o Word 
nVez := 1

// Inicializa o Ole com o MS-Word 97 ( 8.0 )	
oWord := OLE_CreateLink('TMsOleWord97')		
   
OLE_NewFile(oWord,cPath+cArqLoc)

If lImpress
	OLE_SetProperty( oWord, oleWdVisible,   .F. )
	OLE_SetProperty( oWord, oleWdPrintBack, .T. )
Else
	OLE_SetProperty( oWord, oleWdVisible,   .T. )
	OLE_SetProperty( oWord, oleWdPrintBack, .F. )
EndIf

// Inicializa as variaveis
cPatroc		:= CriaVar("RB0->RB0_NOME")
cPatrEnd	:= CriaVar("RB0->RB0_ENDERE")
cPatrCid	:= CriaVar("RB0->RB0_CIDADE")
cPatrEst	:= CriaVar("RB0->RB0_ESTADO")
cPatrCep	:= CriaVar("RB0->RB0_CEP")
cPatrTot	:= CriaVar("RB0->RB0_NRFUNC")
cPatrCont	:= CriaVar("RB0->RB0_CONTATO")
cPatrFone	:= CriaVar("RB0->RB0_FONE")
cPatrEmail	:= CriaVar("RB0->RB0_EMAIL")

// Buscar os dados da Empresa Patrocinadora
dbSelectArea("RB0")
dbSetOrder(1)     
cFil := If(xFilial("RB0") == Space(FWGETTAMFILIAL),xFilial("RB0"),mv_par01)

If 	dbSeek(cFil+mv_par03)			// Filial + Patrocinadora
	cPatroc		:= RB0->RB0_NOME
	cPatrEnd	:= RB0->RB0_ENDERE
	cPatrCid	:= RB0->RB0_CIDADE
	cPatrEst	:= RB0->RB0_ESTADO
	cPatrCep	:= RB0->RB0_CEP
	cPatrTot	:= RB0->RB0_NRFUNC  
	cPatrCont	:= RB0->RB0_CONTATO
	cPatrFone	:= RB0->RB0_FONE
	cPatrEmail	:= RB0->RB0_EMAIL
	
	cPatrObs:= ""
	cAuxDet := MSMM(RB0->RB0_OBSERV,,,,3)	// Leitura do campo memo da descricao detalhada
	nLinha	:= MLCount(cAuxDet,80)
	If nLinha > 0
		For nBegin := 1 To nLinha
			cPatrObs := Memoline(cAuxDet,80,nBegin,,.f.)
		Next nBegin
	EndIf
EndIf         

// Carrega as Empresas Convidadas                  
cConvid :=""
For ny :=1 To Len(aEmpresa)
	dbSelectArea("RB0")
	dbSetOrder(1)
	If dbSeek(xFilial("RB0")+aEmpresa[ny])
		cConvid := cConvid + " - " + RB0->RB0_NOME + CHR(13)
	EndIf	
Next ny

// Carrega os Cargos a serem pesquisados
cCargos:=""      
aCargos:= aSort(aCargos,,,{|x,y| x[2] < y[2]})
For ny:=1 To Len(aCargos)
	dbSelectArea("SRJ")
	dbSetOrder(1)
	If	dbSeek(xFilial("SRJ")+ aCargos[ny][1])
		cCargos := cCargos + " - " + aCargos[ny][2]+ "  " +SRJ->RJ_DESC + CHR(13)
	EndIf	
Next ny                                     

// Carrega a descricao Sumaria dos Cargos
cSumaria := ""
For ny:=1 To Len(aCargos)
	dbSelectArea("SRJ")
	dbSetOrder(1)
	If dbSeek(xFilial("SRJ")+aCargos[ny][1])
		cSumaria += STR0004+Substr(aCargos[ny][2],1,4)+Space(15)+STR0005 + Substr(SRJ->RJ_DESC,1,30)+Space(16)+CHR(13) //"CODIGO: "###"CARGO: "
		cSumaria += Space(80)+CHR(13)
		dbSelectArea("SQ3")
		dbSetOrder(1)
		If dbSeek(xFilial("SQ3")+SRJ->RJ_CARGO)
			cSumaria += STR0006 + Space(59)+ CHR(13) //"OBJETIVOS DO CARGO: "
			cSumaria += Space(05)
			cAuxDet := ""
			cAuxDet := MSMM(SQ3->Q3_DESCDET,,,,3)	// Leitura do campo memo da descricao detalhada
			nLinha	:= MLCount(cAuxDet,80)
			If nLinha > 0
				For nBegin := 1 To nLinha
					cSumaria += Memoline(cAuxDet,80,nBegin,,.f.)
				Next nBegin
			EndIf                     
			cSumaria += CHR(13) + CHR(13)
			cSumaria += STR0007+Space(67)+CHR(13) //"ESPECIFICACAO: "
			FMontaFator(SQ3->Q3_FILIAL,,SQ3->Q3_CARGO,,,,@aFator)
			For nz:=1 To Len(aFator)
				cSumaria += Space(05)+ PADR(aFator[nz][2],30)+ Space(2)+ Alltrim(aFator[nz][4])+Space(13)+CHR(13)
			Next nz
		EndIf
	EndIf		
	
	// Pular duas linhas entre um cargo e outro		
	cSumaria += Space(80)+CHR(13)
	cSumaria += Space(80)+CHR(13)
Next ny	

// Personalizar as pesquisas
If mv_par04 == 1		// Sim
	nAte := Len(aEmpresa)
Else
	nAte := 1
EndIf		

// Verifica se saira preenchido os dados das empresas participantes
For nx:= 1 To nAte

	// Dados da Empresa Patrocinadora
	OLE_SetDocumentVar(oWord,"cPatroc" 		,cPatroc)
	OLE_SetDocumentVar(oWord,"cPatrEnd"		,cPatrEnd)
	OLE_SetDocumentVar(oWord,"cPatrCid"		,cPatrCid)
	OLE_SetDocumentVar(oWord,"cPatrEst"		,cPatrEst)
	OLE_SetDocumentVar(oWord,"cPatrCep"		,cPatrCep)
	OLE_SetDocumentVar(oWord,"cPatrTot"		,cPatrTot)  
	OLE_SetDocumentVar(oWord,"cPatrCont"	,cPatrCont)
	OLE_SetDocumentVar(oWord,"cPatrFone" 	,cPatrFone)
	OLE_SetDocumentVar(oWord,"cPatrEmail"	,cPatrEmail)
	OLE_SetDocumentVar(oWord,"cPatrObs"		,cPatrObs)	
	                                            
	// Empresas Convidadas
	OLE_SetDocumentVar(oWord,"cConvid",cConvid)
	                        
	// Cargos a serem Pesquisados
	OLE_SetDocumentVar(oWord,"cCargos",cCargos)
	
	// Inicializa as variaveis das Empresas Participantes
	cDescRegiao	:= ""	
	cDescPorte	:= ""
	cEmpresa	:= CriaVar("RB0_NOME")
	cEnderec	:= CriaVar("RB0_ENDERE")
	cBairro		:= CriaVar("RB0_BAIRRO")
	cCidade		:= CriaVar("RB0_CIDADE")
	cRegiao		:= CriaVar("RB0_REGIAO")
	cTotal		:= CriaVar("RB0_NRFUNC")
	cPorte		:= CriaVar("RB0_PORTE")	
	cContato	:= CriaVar("RB0_CONTATO")
	cFone		:= CriaVar("RB0_FONE")
	cEmail		:= CriaVar("RB0_EMAIL")
	
	// Personalizar as pesquisas
	If 	mv_par04 == 1	// Sim
		dbSelectArea("RB0")
		dbSetOrder(1)
		If dbSeek(xFilial("RB0")+aEmpresa[nx])
			cEmpresa	:= RB0->RB0_NOME
			cEnderec	:= RB0->RB0_ENDERE
			cBairro		:= RB0->RB0_BAIRRO
			cCidade		:= RB0->RB0_CIDADE
			cRegiao		:= RB0->RB0_REGIAO
			cTotal		:= RB0->RB0_NRFUNC
			cPorte		:= RB0->RB0_PORTE	
			cContato	:= RB0->RB0_CONTATO
			cFone		:= RB0->RB0_FONE
			cEmail		:= RB0->RB0_EMAIL           
			
			dbSelectArea("SX5")
			dbSetOrder(1)
			If dbSeek(xFilial("SX5")+"RC"+cRegiao)
				cDescRegiao := Substr(SX5->X5_DESCRI,1,30)
			EndIf			
			If cPorte == "P"
				cDescPorte := STR0008 //"PEQUENO"
			ElseIf cPorte == "M"
				cDescPorte := STR0009 //"MEDIO"
			ElseIf cPorte == "G"
				cDescPorte := STR0010 //"GRANDE"
			EndIf			
		EndIf		
	EndIf        

	// Dados da Empresa Participantes	                                          
	OLE_SetDocumentVar(oWord,"cEmpresa"	,cEmpresa)
	OLE_SetDocumentVar(oWord,"cEnderec"	,cEnderec)
	OLE_SetDocumentVar(oWord,"cBairro"	,cBairro)
	OLE_SetDocumentVar(oWord,"cCidade"	,cCidade)
	OLE_SetDocumentVar(oWord,"cRegiao"	,cDescRegiao)
	OLE_SetDocumentVar(oWord,"cTotal"	,cTotal)
	OLE_SetDocumentVar(oWord,"cPorte"	,cDescPorte)
	OLE_SetDocumentVar(oWord,"cContato"	,cContato)
	OLE_SetDocumentVar(oWord,"cFone"	,cFone)
	OLE_SetDocumentVar(oWord,"cEmail"	,cEmail)          

	// Descricao Sumaria dos Cargos	
	OLE_SetDocumentVar(oWord,"cSumaria"	,cSumaria)		

	//--Atualiza Variaveis
	OLE_UpDateFields(oWord)

	//Alterar nome do arquivo para Cada Pagina do arquivo para evitar sobreposicao.
	nPag ++ 
	cArqPag := cArqSaida + Strzero(nPag,3)
	
	//-- Imprime as variaveis				
	IF lImpress
		OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord, "ALL",,, 1 ) 
	Else                     
		Aviso("", STR0011 +cArqPag+ STR0012, {STR0013}) //"Alterne para o programa do Ms-Word para visualizar o documento "###" ou clique no botao para fechar."###"Fechar"		
		OLE_SaveAsFile( oWord, cArqPag )
	EndIF
	
Next nx

OLE_CloseLink( oWord ) 			// Fecha o Documento

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Apaga arquivo .DOT temporario da Estacao 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cPath+cArqLoc)
	FErase(cPath+cArqLoc)
Endif

Return
