#INCLUDE "Protheus.ch"
#INCLUDE "CompatMuni.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ COMPATMUNI ³ Autor ³ Emerson Campos          ³ Data ³ 19/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Compatibilizacao da tabela VAM existente na base de dados com a³±±
±±³          ³ CC2 populada                                                   ³±±
±±³          ³ REQ182 - Unificação Tabela CC2 e VAM                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CompatMuni()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Chamado  ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³          ³                                          ³±±
±±³            ³        ³          ³                                          ³±±
±±³            ³        ³          ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CompatMuni(cAlias,nReg,nOpcx)

Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local aAdv1Size		:= {}
Local aInfo1AdvSize	:= {}
Local aObj1Size		:= {}
Local aObj1Coords	:= {}
Local aLogTitle		:= {}
Local aLog			:= {}
Local aLogRCE		:= {}
Local aLogRCO		:= {}
Local aLogRGC		:= {}
Local aLogSRA		:= {}
Local bSet15
Local bSet24
Local nOpca, nX, nTam, nTamAcols	:= 0
Local oFont

Private oGet
Private aHeader 	:= {}
Private aCols		:= {}
Private nUsado  	:= 0
Private aColsClon	:= {}
Private aVirtual	:= {}
Private aVisual		:= {}
Private aColsRec	:= {}
Private aRemCpos	:= {"VAM_FILIAL", "VAM_DDD", "VAM_REGIAO", "VAM_REGATU", "VAM_REGATG", "VAM_CEP1", "VAM_CEP2"}
 
DbSelectArea('CC2')	
CC2->(dbSetOrder(3))
If CC2->(LastRec()) == 0
   	Alert(STR0012) //"Para que a compatibilização seja efetuada é necessário que a tabela 'CC2 - Cadastro de Municípios' esteja criada e populada."  
	Return Nil
EndIf

DbSelectArea('VAM')	
VAM->(dbSetOrder(1))
If VAM->(LastRec()) == 0
   	Alert(STR0013) //"Para que a compatibilização seja efetuada é necessário que a tabela 'VAM - Cadastro de Cidades' esteja criada e populada."  
	Return Nil
EndIf

montaColsMuni()

aAdvSize		:= MsAdvSize()
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 5 , 5 }
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )

aAdv1Size    	:= aClone(aObjSize[1])
aInfo1AdvSize   := { aAdv1Size[2] , aAdv1Size[1] , aAdv1Size[4] , aAdv1Size[3] , 5 , 5 }
aAdd( aObj1Coords , { 000 , 010 , .T. , .F. } )
aAdd( aObj1Coords , { 000 , 010 , .T. , .F. } )
aAdd( aObj1Coords , { 000 , 010 , .T. , .F. } )
aAdd( aObj1Coords , { 000 , 000 , .T. , .T. } )
aObj1Size := MsObjSize( aInfo1AdvSize , aObj1Coords )

DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
DEFINE MSDIALOG oDlg FROM aAdvSize[7], 0 TO aAdvSize[6], aAdvSize[5] TITLE OemToAnsi(STR0001) PIXEL//"Compatibilizador da tabela VAM com a CC2"
	bSet15 := {|| If(CompTudOk(),(nOpca := 1, oDlg:End()),Nil)}
	bSet24 := {|| oDlg:End()}    
	
	@ aObjSize[1,1],aObjSize[1,2] GROUP oGroup TO aObjSize[1,3],aObjSize[1,4] PIXEL  
	                     
	@ aObj1Size[1,1], aObj1Size[1,2]	SAY OemToAnsi(STR0002) PIXEL FONT oFont COLOR CLR_BLUE //"Este programa irá efetuar uma compatibilização das informações existentes nas tabelas 'RCE - Cadastro de Sindicatos', 'RCO - Cadastro de Registro Patronal' e"  
	@ aObj1Size[2,1], aObj1Size[2,2]	SAY OemToAnsi(STR0003) PIXEL FONT oFont COLOR CLR_BLUE	//"'RGC - Cadastro de Localidade de Pagamento' existente na base de dados, de acordo com a tabela de município oficial." 
	@ aObj1Size[3,1], aObj1Size[3,2]	SAY OemToAnsi(STR0004) PIXEL FONT oFont COLOR CLR_BLUE	//"Confirma o processamento?" 
	
	oGet := MsNewGetDados():New(	aObj1Size[4,1]					,;
									aObj1Size[4,2]	 				,;
									aObj1Size[4,3]					,;
									aObj1Size[4,4]					,;
									If(nOpcx # 2,GD_UPDATE,Nil)		,; // controle do que podera ser realizado na GetDado - nstyle
									"CompLinOk"						,; 
									"CompTudOk"						,; 
									""								,;
																	,; 
									0								,;
									9999999 						,;
									Nil								,;
									Nil								,;
									.F.								,;
									oDlg							,;
									aHeader							,;
									aCols				 			)
	//Altera a propriedade dos campos da VAM para somente visualizar								
	oGet:aInfo[1,5]  := "V"
	oGet:aInfo[2,5]  := "V"
	oGet:aInfo[3,5]  := "V"							
ACTIVATE MSDIALOG oDlg ON INIT enchoicebar(oDlg, bSet15, bSet24, Nil, Nil) CENTERED 

If nOpca == 1
	nTamAcols	:= Len(oGet:aCols)
	Begin Transaction
		For nX := 1 To nTamAcols
	    	dbSelectArea("RCE")
			RCE->(dbSetOrder(1))
			RCE->(dbGotop())
			While RCE->(!Eof())
				If AllTrim(RCE->RCE_MUNIC) == AllTrim(oGet:aCols[nX,1]) .AND. !Empty(oGet:aCols[nX,4]) 
					RecLock("RCE",.F.)
					RCE->RCE_MUNIC	:= oGet:aCols[nX,4]	
					RCE->(MsUnlock())					
					aAdd(aLogRCE, Space(10) + RCE->RCE_FILIAL + Space(14 - Len(RCE->RCE_FILIAL)) + RCE->RCE_CODIGO + Space(14) + oGet:aCols[nX,1] + Space(50 - Len(oGet:aCols[nX,1])) + oGet:aCols[nX,4])	
				EndIf
				RCE->(dbSkip())
			EndDo
			
			dbSelectArea("RCO")
			RCO->(dbSetOrder(1))
			RCO->(dbGotop())
			While RCO->(!Eof())
				If AllTrim(RCO->RCO_MUNIC) == AllTrim(oGet:aCols[nX,1]) .AND. !Empty(oGet:aCols[nX,4])
					RecLock("RCO",.F.)
					RCO->RCO_MUNIC	:= oGet:aCols[nX,4] 	
					RCO->(MsUnlock())
					aAdd(aLogRCO, Space(10) + RCO->RCO_FILIAL + Space(14 - Len(RCO->RCO_FILIAL)) + RCO->RCO_CODIGO + Space(12) + oGet:aCols[nX,1] + Space(50 - Len(oGet:aCols[nX,1])) + oGet:aCols[nX,4])
				EndIf
				RCO->(dbSkip())
			EndDo
			
			dbSelectArea("RGC")
			RGC->(dbSetOrder(1))
			RGC->(dbGotop())
			While RGC->(!Eof())
				If AllTrim(RGC->RGC_MUNIC) == AllTrim(oGet:aCols[nX,1]) .AND. !Empty(oGet:aCols[nX,4])
					RecLock("RGC",.F.)
					RGC->RGC_MUNIC	:= oGet:aCols[nX,4] 	
					RGC->(MsUnlock())
					aAdd(aLogRGC, Space(10)  + RGC->RGC_FILIAL + Space(14 - Len(RGC->RGC_FILIAL)) + RGC->RGC_KEYLOC + Space(12) +  oGet:aCols[nX,1] + Space(50 - Len(oGet:aCols[nX,1])) + oGet:aCols[nX,4])
				EndIf
				RGC->(dbSkip())
			EndDo
			
			dbSelectArea("SRA")
			SRA->(dbSetOrder(1))
			SRA->(dbGotop())
			While SRA->(!Eof())
				If AllTrim(SRA->RA_MUNICIP) == AllTrim(oGet:aCols[nX,1]) .AND. !Empty(oGet:aCols[nX,4])
					RecLock("SRA",.F.)
					SRA->RA_MUNICIP	:= oGet:aCols[nX,4] 	
					SRA->(MsUnlock())
					aAdd(aLogSRA, Space(10)  + SRA->RA_FILIAL + Space(14 - Len(SRA->RA_FILIAL)) + SRA->RA_MAT + Space(10) +  oGet:aCols[nX,1] + Space(50 - Len(oGet:aCols[nX,1])) + oGet:aCols[nX,4])
				EndIf
				SRA->(dbSkip())
			EndDo
	    Next nX
    End Transaction
    
    //Montagem do array de Log com os dados de cada tabela manipulada
    aAdd(aLog, Space(80))    	
    aAdd(aLog, Space(5) + replicate("_",122))
    aAdd(aLog, Space(5) + STR0005 + STR0008)
    aAdd(aLog, Space(80))
    If Len(aLogRCE) > 0 
    	aAdd(aLog, Space(5) + "RCE_FILIAL      RCE_CODIGO" + Space(4) + "RCE_MUNIC" + STR0006  + Space(50 - Len("RCE_MUNIC"+STR0006)) + "RCE_MUNIC"+STR0007)
       	
       	nTam	:= Len(aLogRCE)
		For nX := 1 To nTam
			aAdd(aLog, aLogRCE[nX])		
		Next nX    	
  	Else  		
    	aAdd(aLog, Space(10)+STR0018 + Space(1) + STR0008 + Space(1) + STR0019) //"Não foram localizados registros na tabela 'RCE - Cadastro de Sindicatos' para serem compatibilizados."	
    EndIf
    aAdd(aLog, Space(80))    	
    aAdd(aLog, Space(80))
    aAdd(aLog, Space(5) + replicate("_",122))
    
    
    aAdd(aLog, Space(5) + STR0005 + STR0009)
    aAdd(aLog, Space(80))
    If Len(aLogRCO) > 0
    	aAdd(aLog, Space(5) + "RCO_FILIAL      RCO_CODIGO" + Space(4) + "RCO_MUNIC"+STR0006  + Space(50 - Len("RCO_MUNIC"+STR0006)) + "RCO_MUNIC"+STR0007)
       	
       	nTam	:= Len(aLogRCO)
		For nX := 1 To nTam
			aAdd(aLog, aLogRCO[nX])		
		Next nX    	
  	Else  		
    	aAdd(aLog, Space(10)+STR0018 + Space(1) + STR0009 + Space(1) + STR0019) //"Não foi localizado registros na tabela 'RCO - Cadastro de Registro Patronal' para serem compatibilizados."	
    EndIf
    aAdd(aLog, Space(80))    	
    aAdd(aLog, Space(80))
    aAdd(aLog, Space(5) + replicate("_",122))
    
    aAdd(aLog, Space(5) + STR0005 + STR0010)
    aAdd(aLog, Space(80))
    If Len(aLogRGC) > 0
    	aAdd(aLog, Space(5) + "RGC_FILIAL      RGC_KEYLOC" + Space(4) + "RGC_MUNIC"+STR0006  + Space(50 - Len("RGC_MUNIC"+STR0006)) + "RGC_MUNIC"+STR0007)
       	
       	nTam	:= Len(aLogRGC)
		For nX := 1 To nTam
			aAdd(aLog, aLogRGC[nX])		
		Next nX    	
  	Else  		
    	aAdd(aLog, Space(10)+STR0018 + Space(1) + STR0010 + Space(1) + STR0019)//"Não foi localizado registros na tabela 'RGC - Cadastro de Localidade de Pagamento' para serem compatibilizados."	
    EndIf
    aAdd(aLog, Space(80))    	
    aAdd(aLog, Space(80))
    aAdd(aLog, Space(5) + replicate("_",122))
    
    aAdd(aLog, Space(5) + STR0005 + STR0015)
    aAdd(aLog, Space(80))
    If Len(aLogSRA) > 0
    	aAdd(aLog, Space(5) + "RA_FILIAL          RA_MAT" + Space(5) + "RA_MUNICIP"+STR0006  + Space(50 - Len("RA_MUNICIP"+STR0006)) + "RA_MUNICIP"+STR0007)
       	
       	nTam	:= Len(aLogSRA)
		For nX := 1 To nTam
			aAdd(aLog, aLogSRA[nX])		
		Next nX    	
  	Else  		
    	aAdd(aLog, Space(10)+STR0018 + Space(1) + STR0015 + Space(1) + STR0019)//"Não foi localizado registros na tabela 'SRA - Cadastro de Funcionário' para serem compatibilizados."	
    EndIf
    aAdd(aLog, Space(80))    	
    aAdd(aLog, Space(80))
    
    If Len(aLog) > 0
    	aAdd( aLogTitle , Space(5) + STR0004) //"Relação de Municípios Compatibilizados"
		fMakeLog( { aLog } , aLogTitle , NIL , NIL , NIL , oEmToAnsi(STR0004), 'M', 'P' ) //"Relação de Municípios Compatibilizados"
    EndIf
EndIf 

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³montaColsMuni³ Autor ³ Emerson Campos      ³ Data ³ 20/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta Cols                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function montaColsMuni()
Local nCont			:= 0
Local cKeySeek		:= xFilial("VAM")

aCols	:= GDMontaCols(	@aHeader				,;	//01 -> Array com os Campos do Cabecalho da GetDados
						@nUsado					,;	//02 -> Numero de Campos em Uso                
						Nil/*@aVirtual*/		,;	//03 -> [@]Array com os Campos Virtuais
						Nil/*@aVisual*/			,;	//04 -> [@]Array com os Campos Visuais
						"VAM"					,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
						aRemCpos				,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
						@aColsRec				,;	//07 -> [@]Array unidimensional contendo os Recnos
						"VAM"		   			,;	//08 -> Alias do Arquivo Pai
						cKeySeek				,;	//09 -> Chave para o Posicionamento no Alias Filho
						Nil/*bSeekWhile*/		,;	//10 -> Bloco para condicao de Loop While
						Nil/*bSkipVAM*/			,;	//11 -> Bloco para Skip no Loop While
						Nil/*lDeleted*/			,;	//12 -> Se Havera o Elemento de Delecao no aCols 
						Nil/*lCriaPub*/			,;	//13 -> Se cria variaveis Publicas
						Nil/*lInitPad*/			,;	//14 -> Se Sera considerado o Inicializador Padrao
						Nil/*cLado*/			,;	//15 -> Lado para o inicializador padrao
						Nil/*lAllFields*/		,;	//16 -> Opcional, Carregar Todos os Campos
						Nil/*lNotVirtual*/ 		,;	//17 -> Opcional, Nao Carregar os Campos Virtuais
						Nil/*uQryCond*/			,;  //18 -> Opcional, Utilizacao de Query para Selecao de Dados
						.F./*lTopExebKey*/		,;	//19 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
						.F./*lTopExebSkip*/		,;	//20 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
						.F./*uGhostBmpCol*/		,;	//21 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
						Nil/*lOnlyNotFields*/	,;	//22 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
						Nil/*lChkX3Uso*/		,;	//23 -> Verifica se Deve Checar se o campo eh usado
						Nil/*lChkNivel*/		,;	//24 -> Verifica se Deve Checar o nivel do usuario
						Nil/*lPutEmpyaCols*/	,;	//25 -> Verifica se Deve Carregar o Elemento Vazio no aCols
						Nil/*aKeyCodes*/		,;	//26 -> [@]Array que contera as chaves conforme recnos
						Nil/*lLockRecnos*/		,;	//27 -> [@]Se devera efetuar o Lock dos Registros
						Nil/*lUseCode*/			,;	//28 -> [@]Se devera obter a Exclusividade nas chaves dos registros
						Nil/*nMaxLocks*/		,;	//29 -> Numero maximo de Locks a ser efetuado
						Nil/*lNumGhostCol*/		,;	//30 -> Utiliza Numeracao na GhostCol
						Nil/*lCposUser*/		,;	//31 -> Carrega os Campos de Usuario
						Nil/*nOpcx*/			,;	//32 -> Numero correspondente a operação a ser executada, exemplo: 3 - inclusao, 4 alteracaão e etc;
						Nil /*lEmpty*/			;	//33 -> 
					  )

//Insercao de campo para associar CC2 a VAM 
aAdd(aHeader, aHeader[5])
aHeader[5] := aClone(aHeader[4])

aHeader[4,1]  := STR0014
aHeader[4,2]  := 'VAM_CODMUN'
aHeader[4,3]  := '@!'
aHeader[4,4]  := 5
aHeader[4,5]  := 0
aHeader[4,6]  := "ExistCpo('CC2', Nil, 3)" 
aHeader[4,7]  := "€€€€€€€€€€€€€€"
aHeader[4,8]  := "C" 
aHeader[4,9]  := "CC2"
aHeader[4,10] := "R"
aHeader[4,11] := "" 
aHeader[4,12] := ""
aHeader[4,13] := ""
aHeader[4,14] := "A"
aHeader[4,15] := ""
aHeader[4,16] := ""
aHeader[4,17] := .F.

//Manipulação do aCols para se adaptar ao novo campo inserido
For nCont:= 1 to Len(aCols) 
	aAdd(aCols[nCont], aCols[nCont,6])
	aCols[nCont,6]  := aCols[nCont,5]
	aCols[nCont,5]  := aCols[nCont,4]	
	aCols[nCont,4]  := Space(aHeader[4,4])
Next nCont  

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CompLinOk ³ Autor ³ Emerson Campos        ³ Data ³ 20/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Critica linha digitada                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CompLinOk()
Local lRet := .T.
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CompTudOk ³ Autor ³ Emerson Campos        ³ Data ³ 20/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CompTudOk()
Local lRet  := .T.
Local nX	:= 0
Local nTamAcols	:= Len(oGet:aCols)

	For nX := 1 To nTamAcols
		If Empty(oGet:aCols[nX,4])			 
			Alert(STR0017) // 'É necessário informar o município correspondente para todos os registros apresenados na lista.'
			lRet := .F.	
			Exit
		EndIf	
	Next nX
Return lRet