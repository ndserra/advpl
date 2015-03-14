#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "MSOLE.CH"
#INCLUDE "RESULT.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RESULT   ³ Autor ³ Equipe R.H.			³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio do resultado da Pesquisa Salarial conf parametro ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Eduardo Ju. ³07/11/07³112882³Arquivos utilizados conforme o Idioma.    ³±±
±±³Alex        ³28/12/09³027799³Adaptação da Gestão Corporativa,          ³±±
±±³            ³        ³ /2009³respeitar o grupo de campos de filiais.   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function RESULT()
Local cDesc1  	:= STR0001		//"Este programa tem como objetivo imprimir os curriculos"
Local cDesc2  	:= STR0002		//"conforme parametros selecionados."
Local cDesc3 	:= ""
Local cString 	:= "RB5"  	
Local aOrd    	:= {}
Local Imprime 	:= .T.
Local lEnd    	:= .F.
Local DET		:= ""
Local cFil      := ""

Private aEmpresa	:= {}
Private aCargos 	:= {}
Private cPerg   	:= ""
Private nTamanho	:= "G"    

// Variaveis da pergunte
Private cAuxFil		:= ""
Private cCodPesq	:= ""
Private cCodPatroc	:= ""
Private cCodConvid	:= ""
Private cMoeda		:= ""
Private nIndice		:= 0
Private nMetodo		:= 0
Private nPatroc		:= 0
Private nCargos		:= 0
Private nEmpresas	:= 0
Private nResultado	:= 0
Private nCompara	:= 0
Private cNomeDir	:= ""
Private Contfl  	:= 1
Private Li      	:= 0
Private wCabec0		:= 2
Private wCabec1		:= ""
Private wCabec2		:= ""

Private lImpress	:= .T.
Private cArqSaida	:= ""
Private cArqPag		:= ""
Private nPag		:= 0

aReturn  := {STR0003,1,STR0004,2,2,1,"",1 } //"Zebrado"###"Administracao"
NomeProg := "RESULT"
aLinha   := {}
nLastKey := 0

Titulo  := STR0005	//"Resultado da Pesquisa Salarial"
At_prg  := "RESULT"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros usados na rotina                   						³
//³ mv_par01         Filial   						                    ³
//³ mv_par02         Cod Pesquisa                						³
//³ mv_par03         Empresa Patrocinadora       						³
//³ mv_par04         Selecionar Convidadas       						³
//³ mv_par05         Moeda                        						³
//³ mv_par06         Imprimir Indice S/N          						³
//³ mv_par07         Imprimir Metodologia         S/N               	³
//³ mv_par08         Imprimir Empresa Patrocinadora S/N               	³
//³ mv_par09         Imprimir Cargos Pesquisados  S/N               	³
//³ mv_par10         Imprimir Empresas Convidadas S/N               	³
//³ mv_par11         Imprimir Resultado Pesquisa  S/N               	³
//³ mv_par12         Imprimir Comparacao Empresas x Mercado	S/N			³
//³ mv_par13         Diretorio Arquivos de Impressao             		³
//³ mv_par14         1-Impressora / 2-Arquivo     						³
//³ mv_par15         Nome do arquivo de saida     						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
Pergunte("RESULT",.F.)

// Carrega as variaveis da pergunte
cAuxFil		:= 	mv_par01
cCodPesq	:= 	mv_par02
cCodPatroc 	:= 	mv_par03
cCodConvid	:= 	mv_par04
cMoeda		:= 	mv_par05
nIndice		:= 	mv_par06
nMetodo		:= 	mv_par07
nPatroc		:= 	mv_par08
nCargos		:= 	mv_par09
nEmpresas	:= 	mv_par10
nResultado	:= 	mv_par11
nCompara	:= 	mv_par12
cNomeDir	:= 	Alltrim(mv_par13)
cCadastro 	:= OemtoAnsi(STR0006)		//"Integra‡„o com MS-Word"
aSays	  	:= {}
aButtons  	:= {}
nOpca	  	:= 0

AADD(aSays,OemToAnsi(STR0007) )	//"Esta rotina ir  imprimir o Resultado da Pesquisa Salarial conforme os parametros definidos."

AADD(aButtons, { 5,.T.,{|| Pergunte("RESULT",.T. )}})
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch()}})
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1

	// Carrega as variaveis da pergunte
	cAuxFil		:= 	mv_par01
	cCodPesq	:= 	mv_par02
	cCodPatroc 	:= 	mv_par03
	cCodConvid	:= 	mv_par04
	cMoeda		:= 	mv_par05
	nIndice		:= 	mv_par06
	nMetodo		:= 	mv_par07
	nPatroc		:= 	mv_par08
	nCargos		:= 	mv_par09
	nEmpresas	:= 	mv_par10
	nResultado	:= 	mv_par11
	nCompara	:= 	mv_par12
	cNomeDir	:= 	Alltrim(mv_par13)
	lImpress	:= ( mv_par14 == 1 )	// Verifica se a saida sera em Tela ou Impressora
	cArqSaida	:= AllTrim( mv_par15 )	// Nome do arquivo de saida

	// Verifica Moeda
	If Val(cMoeda) == 0
		Aviso(STR0023, STR0024, {"Ok"})	//"Atencao"###"Deve ser escolhida uma Moeda nos Parametros."
		Return
	EndIf
	
	// Verifica hse existe a Empresa Patrocinadora
	dbSelectArea("RB0")
	dbSetOrder(1)
	cFil := If(xFilial("RB0") == Space(FWGETTAMFILIAL),xFilial("RB0"),cAuxFil)
	
	If 	!dbSeek(cFil+cCodPatroc)		// Filial + Patrocinadora
		Help("",1,"NAOCAD")			// Empresa Patrocinadora nao cadastrada
		Return .T.
	EndIf

	// Verifica se existe a Pesquisa com os Cargos e Empresas 
	dbSelectArea("RB4")   
	dbSetOrder(1)
	cFil := If(xFilial("RB4") == Space(FWGETTAMFILIAL),xFilial("RB4"),cAuxFil)
	
	If dbSeek(cFil+cCodPesq)			// Filial + Pesquisa Salarial
		While !Eof() .And. cFil+cCodPesq == RB4->RB4_FILIAL+RB4_PESQ
		
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

	Processa({|| FCalcPesq()})  // Chamada do Processamento

	// Imprimir Resultado Pesquisa ou EmpresaxMercado
	If 	nResultado ==1 .Or. nCompara ==1

		wnrel:="RESULT" 	
		wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)
	
		If nLastKey == 27
			Return 
		EndIf

		SetDefault(aReturn,cString)

		If nLastKey == 27
			Return 
		EndIf

		RptStatus({|| FCalcResult()})
	         
		DET:=""
		IMPR(DET,"F")

		If aReturn[5] = 1
			Set Printer To
			Commit
			ourspool(wnrel)
		Endif

		MS_FLUSH()
		
	EndIf
    
EndIf

dbSelectArea("RB0")
dbSetOrder(1)
dbGotop()

dbSelectArea("SRJ")
dbSetOrder(1)
dbGotop()
	        
dbSelectArea("RB5")
dbSetOrder(1)
dbGotop()
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FCalcPesq ³ Autor ³	Equipe R.H.		    ³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica o calculo da pesquisa Salarial                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Function FCalcPesq()
Local aFator	:= {}
Local nAte 		:= 0       
Local nx		:= 0
Local ny		:= 0
Local nz		:= 0
Local cConvid	:= ""
Local cCargos	:= ""
Local cArquivo	:= ""
Local cPatroc	:= ""
Local cPatrEnd	:= ""
Local cPatrCid	:= ""
Local cPatrEst	:= ""
Local cPatrCep	:= ""
Local cPatrTot	:= ""
Local cPatrCont	:= ""
Local cPatrFone	:= ""
Local cPatrEmail:= ""
Local cPatrObs	:= ""
Local oWord     
Local cFil		:= ""
Local cPath 	:= GETTEMPPATH()
Local nI		:= 0
Local nBegin 	:= 0 
#Ifdef SPANISH
	Local aArquivos := {"ESP_INDICE.DOT", "ESP_METODO.DOT", "ESP_PATROC.DOT", "ESP_CARGOS.DOT", "ESP_CONVID.DOT"}
#Else
	#Ifdef ENGLISH
		Local aArquivos := {"ING_INDICE.DOT", "ING_METODO.DOT", "ING_PATROC.DOT", "ING_CARGOS.DOT", "ING_CONVID.DOT"}
	#Else
    	Local aArquivos := {"INDICE.DOT", "METODO.DOT", "PATROC.DOT", "CARGOS.DOT", "CONVID.DOT"}         
	#Endif
#Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Copiar Arquivo .DOT do Server para Diretorio Local ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Right( AllTrim(cNomeDir), 1 ) != "\"
   cNomeDir += "\"
Endif 
If Right( AllTrim(cPath), 1 ) != "\"
   cPath += "\"
Endif  
For nI := 1 To Len(aArquivos)
	CpyS2T(cNomeDir+aArquivos[nI], cPath, .T.)
Next nI    

// Imprimir Indices
If 	nIndice == 1		// Sim
	
	#Ifdef SPANISH
		cArquivo := cPath+"ESP_INDICE.DOT"
	#Else
		#Ifdef ENGLISH
			cArquivo := cPath+"ING_INDICE.DOT"
		#Else
	    	cArquivo := cPath+"INDICE.DOT" 
		#Endif
	#Endif
	
	OpenWord(@oWord,cArquivo)
	CloseWord(@oWord)
EndIf	
                
// Imprimir Metodologia
If 	nMetodo == 1 	// Sim                                                       

	#Ifdef SPANISH
		cArquivo := cPath+"ESP_METODO.DOT"
	#Else
		#Ifdef ENGLISH
			cArquivo := cPath+"ING_METODO.DOT"
		#Else
	    	cArquivo := cPath+"METODO.DOT" 
		#Endif
	#Endif
	
	OpenWord(@oWord,cArquivo)
	CloseWord(@oWord)	
EndIf      

// Imprimir Patrocinadora
If 	nPatroc == 1		// Sim
	dbSelectArea("RB0")
	dbSetOrder(1)    
	cFil := If(xFilial("RB0") == Space(FWGETTAMFILIAL),xFilial("RB0"),cAuxFil)
	
	If 	dbSeek(cFil+cCodPatroc)			// Filial + Patrocinadora
		cPatroc		:= RB0->RB0_NOME
		cPatrEnd	:= RB0->RB0_ENDERE
		cPatrCid	:= RB0->RB0_CIDADE
		cPatrEst	:= RB0->RB0_ESTADO
		cPatrCep	:= RB0->RB0_CEP
		cPatrTot	:= RB0->RB0_NRFUNC  
		cPatrCont	:= RB0->RB0_CONTATO
		cPatrFone	:= RB0->RB0_FONE
		cPatrEmail	:= RB0->RB0_EMAIL
	
		cPatrObs:= " "
		cAuxDet := MSMM(RB0->RB0_OBSERV,,,,3)	// Leitura do campo memo da descricao detalhada
		nLinha	:= MLCount(cAuxDet,80)
		If nLinha > 0
			For nBegin:=1 To nLinha
				cPatrObs := Memoline(cAuxDet,80,nBegin,,.f.)
			Next nBegin
		EndIf
	EndIf         
	
	#Ifdef SPANISH
		cArquivo := cPath+"ESP_PATROC.DOT"
	#Else
		#Ifdef ENGLISH
			cArquivo := cPath+"ING_PATROC.DOT"
		#Else
	    	cArquivo := cPath+"PATROC.DOT"  
	 	#Endif
	#Endif
	
	OpenWord(@oWord,cArquivo)
	
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

	CloseWord(@oWord)	

EndIf

// Imprime os Cargos Pesquisados
If 	nCargos == 1		// Sim
	
	#Ifdef SPANISH
		cArquivo := cPath+"ESP_CARGOS.DOT"
	#Else
		#Ifdef ENGLISH
			cArquivo := cPath+"ING_CARGOS.DOT"
		#Else
	    	cArquivo:= cPath+"CARGOS.DOT"
		#Endif
	#Endif
	
	cCargos	:=""      
	aCargos	:= aSort(aCargos,,,{|x,y| x[2] < y[2]})
	For ny:=1 To Len(aCargos)
		dbSelectArea("SRJ")
		dbSetOrder(1)
		If	dbSeek(xFilial("SRJ")+aCargos[ny][1])
			cCargos := cCargos + " - " + SRJ->RJ_DESC + CHR(13)
		EndIf	
	Next ny                                     
	OpenWord(@oWord,cArquivo)
	OLE_SetDocumentVar(oWord,"cCargos",cCargos)
	CloseWord(@oWord)	
EndIf	

// Imprime Empresas Convidadas
If 	nEmpresas == 1		// Sim
	
	#Ifdef SPANISH
		cArquivo := cPath+"ESP_CONVID.DOT"
	#Else
		#Ifdef ENGLISH
			cArquivo := cPath+"ING_CONVID.DOT"
		#Else
	 		cArquivo:= cPath+"CONVID.DOT" 
		#Endif
	#Endif
	
	cConvid :=""
	For ny :=1 To Len(aEmpresa)
		dbSelectArea("RB0")
		dbSetOrder(1)
		If dbSeek(xFilial("RB0")+aEmpresa[ny])
			cConvid := cConvid + " - " + RB0->RB0_NOME + CHR(13)
		EndIf	
	Next ny
	OpenWord(@oWord,cArquivo)
	OLE_SetDocumentVar(oWord,"cConvid",cConvid)
	CloseWord(@oWord)	
EndIf	
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Apaga arquivo .DOT temporario da Estacao 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 To Len(aArquivos)
	If File(cPath+aArquivos[nI])
		FErase(cPath+aArquivos[nI])
	Endif  
Next nI    

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FCalcResult ³ Autor ³ Equipe R.H.		    ³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica o resultado da Pesquisas Salariais              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function FCalcResult()
Local cAuxFuncao	:= ""
Local cAuxRegiao	:= ""
Local cAuxPorte		:= ""
Local cDet			:= ""
Local l1Vez			:= .T.
Local cCancel 		:= STR0008	//"Cancelado pelo usuario"
Local cNomeFunc		:= ""
Local cNomePorte	:= ""
Local cNomeRegiao	:= ""
Local nQ1			:= 0
Local nQ3			:= 0
Local nMedia		:= 0
Local nMediana		:= 0
Local nFreq			:= 0
Local nTQ1			:= 0
Local nTQ3			:= 0
Local nTMedia		:= 0
Local nTMediana		:= 0
Local nValor		:= 0
Local cRegiao		:= ""
Local cDRegiao		:= ""
Local cFuncao		:= ""
Local cPorte		:= ""
Local aDados		:= {}
Local aEmpDados		:= {}
Local nx			:= 0
Local cFil			:= ""

// Usadas na funcao CS050Array
Private aVl1	:= {}
Private aVl2	:= {}

dbSelectArea("RB0")
dbSetOrder(1)
If dbSeek(xFilial("RB0")+cCodConvid)                       
	If RB0->RB0_PORTE == "P"   
		cNomePorte := STR0009	//"PEQUENO"
	ElseIf RB0->RB0_PORTE == "M"
		cNomePorte := STR0010	//"MEDIO"
	ElseIf RB0->RB0_PORTE == "G"
		cNomePorte := STR0011	//"GRANDE"
	EndIf
		
	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+"RC"+RB0->RB0_REGIAO)	
		cNomeRegiao := Substr(SX5->X5_DESCRI,1,30)
	EndIf			            
	cAuxPorte := RB0->RB0_PORTE
	cAuxRegiao:= RB0->RB0_REGIAO
EndIf		

dbSelectArea("RB1")
dbSetOrder(1)
cFil := If(xFilial("RB1") == Space(FWGETTAMFILIAL),xFilial("RB1"),cAuxFil)

dbSeek(cFil+cCodPesq)

// Buscar o valor da Moeda da data base da Pesquisa Salarial					 
dbSelectArea("SM2")					 
dbSetOrder(1)
If dbSeek(RB1->RB1_DTBASE)   
	nValor := &("SM2->M2_MOEDA"+cMoeda)
EndIf

If nValor == 0
	nValor := 1	
EndIf

// Armazena os dados da Pesquisa Salarial 
dbSelectArea("RB5")
dbSetOrder(1)
cFil := If(xFilial("RB5") == Space(FWGETTAMFILIAL),xFilial("RB5"),cAuxFil)

dbSeek(cFil+cCodPesq)

cRegiao := RB5->RB5_REGIAO
cFuncao	:= RB5->RB5_FUNCAO
cPorte	:= RB5->RB5_PORTE

//0001	- 1o Decil
//0002	- 9o Decil
//0003	- 1o Quartil
//0004	- 3o Quartil
//0005	- Mediana
//0006	- Media
//0007	- Total Frequencia
//0008	- Variancia
//0009	- Desvio Padrao
//0010	- Coeficiente Variacao
//0011	- Nr Classes
//0012	- Amplitude Amostral                   	
//0013	- Amplitude Classe

While !Eof() .And. cFil+cCodPesq == RB5->RB5_FILIAL+RB5->RB5_PESQ

	If cRegiao+cFuncao+cPorte == RB5->RB5_REGIAO+RB5->RB5_FUNCAO+RB5->RB5_PORTE
		If 	RB5->RB5_CODVL =="0003"		
			nQ1 := RB5->RB5_VALOR      
			nTQ1:= RB5->RB5_VLOUTR			
		ElseIf RB5->RB5_CODVL == "0004"
			nQ3 := RB5->RB5_VALOR 
			nTQ3:= RB5->RB5_VLOUTR
		ElseIf RB5->RB5_CODVL == "0005"
			nMediana := RB5->RB5_VALOR
			nTMediana:= RB5->RB5_VLOUTR
		ElseIf RB5->RB5_CODVL == "0006"
			nMedia := RB5->RB5_VALOR   
			nTMedia:= RB5->RB5_VLOUTR
		ElseIf RB5->RB5_CODVL =="0007"
			nFreq  := RB5->RB5_VALOR  
		EndIf  
		
		dbSkip()
		
	Else
		Aadd(aDados,{	cFuncao,;						// 1-Funcao   
						cRegiao,;						// 2-Regiao
						cPorte,;						// 3-Porte
						Round(nQ1/nValor,2),;			// 4-1o Quartil
						Round(nQ3/nValor,2),;			// 5-3o Quartil
						Round(nMediana/nValor,2),;		// 6-Mediana
						Round(nMedia/nValor,2),;		// 7-Media
						nFreq,;							// 8-Frequencia
						Round(nTQ1/nValor,2),;			// 9-Total 1o.Quartil
						Round(nTQ3/nValor,2),;			// 10-Total 3o.Quartil
						Round(nTMediana/nValor,2),;	// 11-Total Mediana
						Round(nTMedia/nValor,2)})		// 12-Total Media		
		
		cRegiao := RB5->RB5_REGIAO
		cFuncao	:= RB5->RB5_FUNCAO
		cPorte	:= RB5->RB5_PORTE
	EndIf
EndDo

Aadd(aDados,{cFuncao,cRegiao,cPorte,nQ1,nQ3,nMediana,nMedia,nFreq,nTQ1,nTQ3,nTMediana,nTMedia})	

aDados := aSort(aDados,,,{|x,y| x[2]+x[1] < y[2]+y[1]})

If Len(aDados) == 0
	Return 
EndIf

// Imprime o Resultado da Pesquisa Salarial
If 	nResultado == 1			// Sim
	Titulo	:= 	Space(30)+STR0012+Space(20)+STR0013+DTOC(RB1->RB1_DTBASE)		//"RESULTADO PESQUISA SALARIAL"###"BASE:"
	wCabec1 :=	Space(05)+STR0015	//"CARGO                                PORTE FREQ.   1o.QUARTIL        MEDIA      MEDIANA   3o.QUARTIL"
									//"12345-123456789012345678901234567890     1 99999 999999999.99 999999999.99 999999999.99 999999999.99 
	cRegiao := "xxxx"
	cFuncao := ""	
	For nx:=1 To Len(aDados) 
    	
		If cRegiao # aDados[nx][2]
			If cRegiao !="xxxx"
				cDet 	:= Repl("-",220)
				IMPR(cDet)
			EndIf

			cRegiao := aDados[nx][2]
			cDRegiao:= Subs(FVerRegiao(cRegiao),1,30)
			If !Empty(Alltrim(cDRegiao))
				cDet := Space(02)+STR0016+cRegiao + " - " + cDRegiao	//"REGIAO: "
				IMPR(cDet)   
			EndIf	

		EndIf
    
		If cFuncao # aDados[nx][1]
			dbSelectarea("SRJ")
			dbSetOrder(1)
			If  dbSeek(xFilial("SRJ")+aDados[nx][1])   
				cNomeFunc := Substr(SRJ->RJ_DESC,1,30)
			EndIf
			cAux 	:= aDados[nx][1]+"-"+PADR(cNomeFunc,30)
			cFuncao := aDados[nx][1]
		Else
			cAux := Space(35)
		EndIf	

	// 	"CARGO                               PORTE FREQ.   1o.QUARTIL        MEDIA      MEDIANA   3o.QUARTIL"
	//	"1234-123456789012345678901234567890     1 99999 999999999.99 999999999.99 999999999.99 999999999.99 
		
		cDet := Space(05)+cAux+ Space(06)+aDados[nx][3]+Space(01)+Transform(aDados[nx][8],"@E 99999")+Space(01)
		cDet += Transform(aDados[nx][4],"@E 999999999.99")+Space(01)+Transform(aDados[nx][7],"@E 999999999.99")+Space(01)
		cDet += Transform(aDados[nx][6],"@E 999999999.99")+Space(01)+Transform(aDados[nx][5],"@E 999999999.99")
	
		IMPR(cDet)
	
	Next nx
	
EndIf

// Imprime Comparativo Empresa x Mercado
If 	nCompara == 1		//Sim           

	wCabec1 := Space(05)+STR0020	//"                                     -----EMPRESA (SALARIO MEDIO)-----  -------------------MERCADO (SALARIO BASE)----------------------    --------------MERCADO (SALARIO TOTAL)--------------"
	wCabec2 := Space(05)+STR0021	//"CARGO                                FREQ. SALARIO BASE SALARIO TOTAL   PORTE FREQ.   1o.QUARTIL        MEDIA      MEDIANA   3o.QUARTIL      1o.QUARTIL        MEDIA      MEDIANA   3o.QUARTIL"	
									//"12345-123456789012345678901234567890 99999 999999999.99  999999999.99       X 99999 999999999.99 999999999.99 999999999.99 999999999.99    999999999.99 999999999.99 999999999.99 999999999.99
	LI		:= 0
	Titulo	:= Space(30)+STR0014+Space(30)+STR0013+DTOC(RB1->RB1_DTBASE)		//"COMPARATIVO EMPRESA x MERCADO"###"BASE:"
	
	dbSelectArea("RB0")
	dbSetOrder(1)
	If dbSeek(xFilial("RB0")+cCodConvid)
	
		If RB0->RB0_PORTE="P"
			cPorte := STR0009	//"PEQUENO"
		ElseIf RB0->RB0_PORTE="M"
			cPorte := STR0010	//"MEDIO"
		ElseIf RB0->RB0_PORTE="G"	
			cPorte := STR0011	//"GRANDE"
		EndIf	
			
		DET := STR0017+RB0->RB0_EMPRES+" - "+RB0->RB0_NOME+Space(10)	//"EMPRESA: "
		DET += STR0018+RB0->RB0_REGIAO+" - "+FVerRegiao(RB0->RB0_REGIAO)+Space(10)	//"REGIAO: "
		DET += STR0019+RB0->RB0_PORTE+" - "+cPorte		//"PORTE: "
		    
		IMPR(DET,"C")
	EndIf
	
	cRegiao := "xxxx"
	cFuncao := ""	
	For nx:=1 To Len(aDados) 
    	
		If cRegiao # aDados[nx][2]
			If cRegiao !="xxxx"
				cDet 	:= Repl("-",220)
				IMPR(cDet)
			EndIf
			
			cRegiao := aDados[nx][2]			
			cDRegiao:= Subs(FVerRegiao(cRegiao),1,30)
			If !Empty(Alltrim(cDRegiao))
				cDet := Space(02)+STR0016+cRegiao + " - " + cDRegiao	//"REGIAO: "
				IMPR(cDet)   
			EndIf	
		EndIf
    
		If cFuncao # aDados[nx][1]
			aVl1:={}
			aVl2:={}
			aEmpDados:={}
			dbSelectarea("SRJ")                                                        
			dbSetOrder(1)
			If  dbSeek(xFilial("SRJ")+aDados[nx][1])   
				cNomeFunc := Substr(SRJ->RJ_DESC,1,30)
			EndIf
			Cs050Array(aDados[nx][1],RB1->RB1_DTBASE,RB1->RB1_HORAS,RB1->RB1_INDICE,RB0->RB0_EMPRES)
			aEmpDados	:= FEmpDados()
			
			cAux 		:= aDados[nx][1]+"-"+PADR(cNomeFunc,30)+Space(02)
			cAux		+= Transform(aEmpDados[1],"@E 99999")+Space(01)
			cAux		+= Transform(aEmpDados[2],"@E 999999999.99")+Space(02)
			cAux		+= Transform(aEmpDados[3],"@E 999999999.99")+Space(06)			
			
			cFuncao 	:= aDados[nx][1]
		Else
			cAux 	:= Space(75)
		EndIf	
		
		cDet := Space(05)+cAux+ Space(01)+aDados[nx][3]+Space(01)+Transform(aDados[nx][8],"@E 99999")+Space(01)
		cDet += Transform(aDados[nx][4],"@E 999999999.99")+Space(01)+Transform(aDados[nx][7],"@E 999999999.99")+Space(01)
		cDet += Transform(aDados[nx][6],"@E 999999999.99")+Space(01)+Transform(aDados[nx][5],"@E 999999999.99")+Space(04)
		cDet += Transform(aDados[nx][9],"@E 999999999.99")+Space(01)+Transform(aDados[nx][12],"@E 999999999.99")+Space(01)
		cDet += Transform(aDados[nx][11],"@E 999999999.99")+Space(01)+Transform(aDados[nx][10],"@E 999999999.99")+Space(01)
		
		IMPR(cDet)
				
		cDet := Space(92)+"("+Transform(FPercent(aDados[nx][4],aEmpDados[2]),"@E 999.99")+"%)"
		cDet += Space(04)+"("+Transform(FPercent(aDados[nx][7],aEmpDados[2]),"@E 999.99")+"%)"
		cDet += Space(04)+"("+Transform(FPercent(aDados[nx][6],aEmpDados[2]),"@E 999.99")+"%)"
		cDet += Space(04)+"("+Transform(FPercent(aDados[nx][5],aEmpDados[2]),"@E 999.99")+"%)"		
		cDet += Space(07)+"("+Transform(FPercent(aDados[nx][9],aEmpDados[3]),"@E 999.99")+"%)"		
		cDet += Space(04)+"("+Transform(FPercent(aDados[nx][12],aEmpDados[3]),"@E 999.99")+"%)"		
		cDet += Space(04)+"("+Transform(FPercent(aDados[nx][11],aEmpDados[3]),"@E 999.99")+"%)"		
		cDet += Space(04)+"("+Transform(FPercent(aDados[nx][10],aEmpDados[3]),"@E 999.99")+"%)"		
		
		IMPR(cDet)
		
		cDet :=""  
		IMPR(cDet)
				 
	Next nx
	
EndIf
		
Return                   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OpenWord    ³ Autor ³ Equipe R.H.		    ³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Trata as variaveis de abertura quando utiliza o Word     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function OpenWord(oWord,cArquivo)

// Inicializa o Ole com o MS-Word 97 ( 8.0 )	
oWord := OLE_CreateLink('TMsOleWord97')		

OLE_NewFile(oWord,cArquivo) 
If lImpress
	OLE_SetProperty( oWord, oleWdVisible,   .F. )
	OLE_SetProperty( oWord, oleWdPrintBack, .T. )
Else
	OLE_SetProperty( oWord, oleWdVisible,   .T. )
	OLE_SetProperty( oWord, oleWdPrintBack, .F. )
EndIf

Return
               
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CloseWord   ³ Autor ³ Equipe R.H.		    ³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Trata as variaveis de fechamento quando se utiliza o Word	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function CloseWord(oWord)

//Alterar nome do arquivo para Cada Pagina do arquivo para evitar sobreposicao.
nPag ++ 
cArqPag := cArqSaida + Strzero(nPag,3)

//--Atualiza Variaveis
OLE_UpDateFields(oWord)

//-- Imprime as variaveis				
IF lImpress 
	OLE_PrintFile( oWord, "ALL",,, 1 ) 
Else
	Aviso("", STR0025 +cArqPag+ STR0026, {STR0027} ) 		//"Alterne para o programa do Ms-Word para visualizar o documento "###" ou clique no botao para fechar."###"Fechar"
	OLE_SaveAsFile( oWord, cArqPag )
EndIF

//-- Fecha o Documento	
OLE_CloseLink( oWord ) 			

Return
               
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LeTab       ³ Autor ³ Equipe R.H.		    ³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta a janela para selecionar a moeda a ser impressa   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Function LeTab(nQual)
Local nTam 		:= 0
Local cTitulo	:= ""
Local oWnd 		:= GetWndDefault()
Local aSaveArea := GetArea()
Local i   		:= 0
Local aArray	:= {}
Local MvPar		:= ""
Local MvParDef	:= ""
Local aAux		:= {}  
Local cFil		:= ""

MvPar	:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
MvRet	:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

If nQual == 1				// Moeda
	nTam	:= 1
	cTitulo := STR0030	//"Moedas do Sistema"
	For i:=1 To 5
		cMoeda := "MV_MOEDA"+Str(i,1)
		Aadd(aArray,Alltrim(GETMV(cMoeda)))
		MvParDef:=MvParDef+Str(i,1)
	Next i
Else      
	dbSelectArea("RB4")   
	dbSetOrder(1)   
	cFil := If(xFilial("RB4") == Space(FWGETTAMFILIAL),xFilial("RB4"),cAuxFil)
	
	If dbSeek(cFil+cCodPesq)			// Filial + Pesquisa Salarial
		While !Eof() .And. cFil+cCodPesq == RB4->RB4_FILIAL+RB4_PESQ
		
			Aadd(aAux,RB4->RB4_EMPRES)
			
			dbSkip()
		EndDo
	EndIf
	
	nTam	:= 4	
	cTitulo := STR0031	//"Empresas Convidadas na Pesquisa"
	For i :=1 To Len(aAux)    
		dbSelectArea("RB0")
		dbSetOrder(1)
		If dbSeek(xFilial("RB0")+aAux[i])
			Aadd(aArray,Alltrim(RB0->RB0_NOME))
			MvParDef:=MvParDef+SubStr(aAux[i],1,4)			
		EndIf	
	Next i
EndIf

If Len(aArray) > 0
	f_Opcoes(@MvPar,cTitulo,aArray,MvParDef,12,49,.T.,nTam) 	// Chama funcao f_Opcoes
	&MvRet := mvpar										    	// Devolve Resultado
Else 
	Help("",1,"NEXISTPESQ")			//Pesquisa Salarial nao existe. Verifique os paramentros.
EndIf	

RestArea(aSaveArea)

If oWnd != Nil
	GetdRefresh()
EndIf
       
Return .T.
               
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FVerRegiao  ³ Autor ³ Equipe R.H.		    ³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Traz a descricao da Regiao                               	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function FVerRegiao(cRegiao)
Local aSaveArea := GetArea()
Local cDesc		:= ""

dbSelectArea("SX5")
dbSetOrder(1)
If dbSeek(xFilial("SX5")+"RC"+cRegiao)
	cDesc := Substr(SX5->X5_DESCRI,1,30)
EndIf
            
RestArea(aSaveArea)
          
Return cDesc
        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FEmpDados   ³ Autor ³ Equipe R.H.	        ³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Busca os dados da Empresa no RB2                         	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Function FEmpDados()
Local nTFreq	:= 0
Local nTValor	:= 0
Local nTotal	:= 0
Local nValor1	:= 0
Local nValor2	:= 0
Local nX		:= 0 

For nx := 1 To Len(aVl1)
	nTValor := aVl1[nx][1] * aVl1[nx][2]
	nTotal  := nTotal + nTValor
	nTFreq  := nTFreq + aVl1[nx][1]
Next nx

If nTFreq > 0
	nValor1 := nTotal / nTFreq
EndIf	
                             
nTValor := 0
nTotal 	:= 0 
For nx:=1 To Len(aVl2)
	nTValor := aVl2[nx][1] * aVl2[nx][2]
	nTotal  := nTotal + nTValor
Next nx

If nTFreq > 0
	nValor2 := nTotal / nTFreq
EndIf	

Return {nTFreq,nValor1,nValor2}
               
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FPercent    ³ Autor ³ Equipe R.H.	        ³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Calcula os percentuais dos Valores para impressao        	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function FPercent(nValor1,nValor2)
Local nMaior	:= 0
Local nMenor	:= 0
Local nPerc 	:= 0

If nValor1 > nValor2
	nMaior := nValor1
	nMenor := nValor2
Else
	nMaior := nValor2
	nMenor := nValor1
EndIf	
	                  
If nMenor # 0
	nPerc := Round(((nMaior/nMenor) - 1) * 100,2)
EndIf
	
Return nPerc

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FPercent    ³ Autor ³ Equipe R.H.	 	    ³ Data ³ 19.04.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Calcula os percentuais dos Valores para impressao        	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Function FGetDir()                                                                                                                                 
Local _mvRet  := Alltrim(ReadVar())
Local _cPath  := mv_par13

_oWnd := GetWndDefault()

&_mvRet := _cPath

_cPath := cGetFile( STR0028 ,OemToAnsi(STR0029),,"",.F.,GETF_RETDIRECTORY)	

&_mvRet := _cPath

If _oWnd != Nil
	GetdRefresh()
EndIf

Return .T.
