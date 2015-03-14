#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE "CONVIT.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ convite  ³ Autor ³ Equipe Desenv. R.H.   ³ Data ³ 02.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio                        - VIA WORD                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programador  ³ Data     ³ FNC            ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³Rogerio R.   ³29/07/2009³00000018278/2009³Compatibilizacao dos fontes para aumento do³±±
±±³             ³          ³                ³campo filial e gestão corporativa.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CONVIT()       

SetPrvt("CCADASTRO,ASAYS,ABUTTONS,NOPCA,CTYPE,CARQUIVO")
SetPrvt("NVEZ,OWORD,CINICIO,CFIM,CFIL")
SetPrvt("LIMPRESS,CARQSAIDA,CARQPAG,NPAG,CPATH,CARQLOC,NPOS") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros usados na rotina                   ³
//³ MV_PAR01         Filial   De                  ³
//³ MV_PAR02         Filial   Ate                 ³
//³ MV_PAR03         C.Custo  De                  ³
//³ MV_PAR04         C.Custo  Ate                 ³
//³ MV_PAR05         Matricula De                 ³
//³ MV_PAR06         Matricula Ate                ³
//³ MV_PAR07         Calendario De                ³
//³ MV_PAR08         Calendario Ate               ³
//³ MV_PAR09         Curso De                     ³
//³ MV_PAR10         Curso Ate                    ³   
//³ MV_PAR11         Turma De 	                  ³   
//³ MV_PAR12         Turma Ate 	                  ³   
//³ MV_PAR13         Situacao Folha               ³ 
//³ MV_PAR14         1-Impressora / 2-Arquivo     ³
//³ MV_PAR15         Nome do arquivo de saida     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("CONVIT",.F.)

cCadastro := OemtoAnsi(STR0001) //"Integra‡„o com MS-Word"
aSays	  :={}
aButtons  :={}

AADD(aSays,OemToAnsi(STR0002) ) //"Esta rotina ir  imprimir os convites dos cursos realizados "

AADD(aButtons, { 5,.T.,{|| Pergunte("CONVIT",.T. )}})
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch()}})
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|| WORDIMP()})  // Chamada do Processamento// Substituido pelo assistente de conversao do AP5 IDE em 14/02/00 ==> 	Processa({|| Execute(WORDIMP)})  // Chamada do Processamento
EndIf
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ WORDIMP  ³ Autor ³ Equipe Desenv. R.H.   ³ Data ³ 31.03.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de convites dos cursos  - VIA WORD               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static FUNCTION WORDIMP()

// Seleciona Arquivo Modelo 
cType 		:= "CONVITE     | *.DOT"
cArquivo 	:= cGetFile(cType, OemToAnsi(STR0003+Subs(cType,1,6)),,,.T.,GETF_ONLYSERVER )//"Selecione arquivo "

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

lImpress	:= ( MV_PAR14 == 1 )	// Verifica se a saida sera em Tela ou Impressora
cArqSaida	:= AllTrim( MV_PAR15 )	// Nome do arquivo de saida

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
	
cInicio := "RA3->RA3_FILIAL+RA3->RA3_CALEND"
cFim	:= MV_PAR02+MV_PAR08
cFil	:= xFilial("RA3", MV_PAR01)
nPag	:= 0

dbSelectArea("RA3")   
dbSetOrder(2)
dbSeek(cFil+MV_PAR07,.T.)
While ! Eof() .And. &cInicio <= cFim       
	IF  RA3->RA3_FILIAL	< MV_PAR01 .Or. RA3->RA3_FILIAL > MV_PAR02 .Or.;
		RA3->RA3_CALEND	< MV_PAR07 .Or. RA3->RA3_CALEND > MV_PAR08 .Or.;
		RA3->RA3_CURSO 	< MV_PAR09 .Or. RA3->RA3_CURSO > MV_PAR10	.Or.;
		RA3->RA3_TURMA 	< MV_PAR11 .Or. RA3->RA3_TURMA > MV_PAR12	.Or.;
		RA3->RA3_RESERV != "R"
	
		dbSkip()
		Loop
	Endif
	
    dbSelectArea("RA2")
    dbSetOrder(1)        
	cFil	:= xFilial("RA2", RA3->RA3_FILIAL)
    If dbSeek(cFil+RA3->RA3_CALEND)
    
    	While !Eof() .And. RA3->RA3_CALEND == RA2->RA2_CALEND
    		If (RA3->RA3_CURSO+RA3->RA3_TURMA != RA2->RA2_CURSO+RA2_TURMA) 
    		
    			dbSelectArea("RA2")
    			dbSkip()
    			Loop
    		EndIf
			If RA2->RA2_REALIZA == "S"
	
				dbSelectArea("RA3")
				dbSkip()
				Loop
			EndIf
			exit
		EndDo
	Else     
		dbSelectArea("RA3")
		dbSkip()
		Loop	
	EndIf
   			
	dbSelectArea("SRA")
	dbSetOrder(1)
	If dbSeek(RA3->RA3_FILIAL+RA3->RA3_MAT)
	    	
		If 	SRA->RA_CC < MV_PAR03 .Or.;
			SRA->RA_CC > MV_PAR04 .Or.;
			SRA->RA_MAT < MV_PAR05 .Or.;
			SRA->RA_MAT > MV_PAR06 .Or.;
			!(SRA->RA_SITFOLH $ MV_PAR13)

			dbSelectArea("RA3")
			dbSkip()
			Loop
		EndIf		     	
		                                         
		dbSelectArea("RA1")
		cFil:= xFilial("RA1", SRA->RA_FILIAL)
		dbSeek(cFil+RA3->RA3_CURSO)
				
		dbSelectArea("RA7")
		cFil:= xFilial("RA7", SRA->RA_FILIAL)
		dbSeek(cFil+RA2->RA2_INSTRU)
				
		dbSelectArea("SI3")
		cFil:= xFilial("SI3", SRA->RA_FILIAL)
		dbSeek(cFil+SRA->RA_CC)
				
		dbSelectArea("RA0")
		cFil:= xFilial("RA0", SRA->RA_FILIAL)				
		dbSeek(cFil+RA2->RA2_ENTIDA)
				
		// Variaveis a serem usadas na Montagem do Documento no Word    
		//--Cadastro Funcionario
		OLE_SetDocumentVar(oWord,"cNome",SRA->RA_NOME)
		OLE_SetDocumentVar(oWord,"cMat" ,SRA->RA_MAT)
		
		//--Centro de Custo                            
		OLE_SetDocumentVar(oWord,"cCC",SI3->I3_DESC)

		//--Curso 
		OLE_SetDocumentVar(oWord,"cLocal" 	,RA2->RA2_LOCAL)
		OLE_SetDocumentVar(oWord,"cCurso" 	,RA1->RA1_DESC)
		OLE_SetDocumentVar(oWord,"dInicio"	,RA2->RA2_DATAIN)
		OLE_SetDocumentVar(oWord,"dFim"		,RA2->RA2_DATAFI)
		OLE_SetDocumentVar(oWord,"cHorario"	,RA2->RA2_HORARI)
		OLE_SetDocumentVar(oWord,"cEntidade",RA0->RA0_DESC)

		//--Data atual
		OLE_SetDocumentVar(oWord,"cDia"	, StrZero(Day(dDataBase),2))
		OLE_SetDocumentVar(oWord,"cAno"	, StrZero(Year(dDataBase),4))
		OLE_SetDocumentVar(oWord,"cMes"	, MesExtenso(Month(dDataBase)))

		//--Sinonimo de Curso
		OLE_SetDocumentVar(oWord,"cSinon" ,Fdesc("RA9", RA2->RA2_SINON, "RA9_DESCR"))		
						
		//--Atualiza Variaveis
		OLE_UpDateFields(oWord)
        
		//Alterar nome do arquivo para Cada Pagina do arquivo para evitar sobreposicao.
		nPag ++ 
		cArqPag := cArqSaida + Strzero(nPag,3)

		//-- Imprime as variaveis				
		IF lImpress
			OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord, "ALL",,, 1 ) 
		Else
			Aviso("", STR0004 +cArqPag+ STR0005, {STR0006}) //"Alterne para o programa do Ms-Word para visualizar o documento "###" ou clique no botao para fechar."###"Fechar"
			OLE_SaveAsFile( oWord, cArqPag )
		EndIF

	EndIf	
			
	dbSelectArea("RA3")
	dbSkip()	
EndDo

OLE_CloseLink( oWord ) 			// Fecha o Documento

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Apaga arquivo .DOT temporario da Estacao 		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cPath+cArqLoc)
	FErase(cPath+cArqLoc)
Endif

Return
