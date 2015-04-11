#include "RwMake.ch"
#include "MsOle.ch"
#define oleWdLeft         "201"  // Extremidade esquerda da janela
#define oleWdTop          "202"  // Extremidade superior da janela
#define oleWdWidth        "203"  // Largura da janela
#define oleWdHeight       "204"  // Altura da janela
#define oleWdCaption      "205"  // Nome dado เ janela
#define oleWdVisible      "206"  // Define se a janela vai ser visivel ou nใo
#define oleWdWindowState  "207"  // Define se a janela vai estar maximizada
#define oleWdPrintBack    "208"  // Define forma de impressao (background)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOffFat01  บAutor  ณDaniel Franciulli   บ Data ณ  11/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIntegracao P10 x Word para geracao da proposta Comercial    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function OffFat01()

Local   cPropDOT 	:= "\modelos\exemppms.dot"
Local   cEditor		:= "TMsOleWord97"
Local   cPathPro	:= "c:\Proposta_"+AllTrim(mv_par01)+".DOC"
Local   cNomeCli 	:= ""
Local   cNomeFan 	:= ""
Local   cUnidade 	:= ""
Local   cNumProj 	:= ""
Local   cRevisao 	:= ""
Local   cRefConv 	:= ""
Local   cRefCli   	:= ""
Local   cRespTec 	:= ""
Local   cRespSup 	:= ""
Local   cTitulo  	:= ""
Local   cDescRes 	:= ""
Local   cObs     	:= ""
Local   cVisao   	:= ""
Local   cEmissao	:= ""
Local   cInicio		:= ""
Local   cFinal		:= ""
Local   cPrazo		:= ""
Private _cPerg	 	:= "OFFFAT01"
Private aPrazo 		:= {}
Private aRecurso 	:= {}
Private aEscopo	 	:= {}
Private aTotal   	:= {}

DbSelectArea("AFA")
DbSelectArea("AFC")
DbSelectArea("AF9")
DbSelectArea("AF8")

ValidPerg()
Pergunte(_cPerg,.T.)

_cNumProp := mv_par01
_cRevisa  := mv_par02

DbSelectArea("AF8")
DbSetOrder(1) //AF8_FILIAL+AF8_PROJET+AF8_DESCRI
If DbSeek(xFilial("AF8")+_cNumProp)//+_cRevisa)
	
	// Busca as informacoes do projeto
	cNumProj := AF8->AF8_PROJET
	cRefConv := AF8->AF8_CONVIT
	cRefCli  := AF8->AF8_REFCLI
	cRespTec := AF8->AF8_RESPTE
	cRespSup := AF8->AF8_RESPSU
	cTitulo  := AF8->AF8_TITULO
	cDescRes := AF8->AF8_DESCRE
//	cObs     := AF8->AF8_OBS
	cVisao   := AF8->AF8_VISAO
	cRevisao := AF8->AF8_REVISA   
	cEmissao := DTOC(AF8->AF8_DATA)
	
	// Busca os dados do cliente
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+AF8->(AF8_CLIENT+AF8_LOJA))
	cNomeCli := SA1->A1_NOME
	cNomeFan := SA1->A1_NREDUZ
	cUnidade := SA1->A1_NREDUZ
	
	// Verifica se o arquivo modelo existe
	If !File(cPropDOT)
		Alert("Arquivo Modelo nใo encontrado")
		Return
	Else
		__CopyFile(cPropDOT,cPathPro)
	EndIf

	aPrazo   := RetPrazo(cNumProj,cRevisao)
	aRecurso := RetRecur(cNumProj,cRevisao)
	aEscopo  := RetEscop(cNumProj,cRevisao)
	aTotal 	 := RetTotal(cNumProj,cRevisao)
	cInicio	 := Dtoc(aPrazo[1])								
	cFinal	 := Dtoc(aPrazo[2])								
	cPrazo	 := Transform(aPrazo[3],"@E 999,999")			
	
	// Cria objeto de controle de comunicacao Ap6xWord
	oWord := OLE_CREATELINK(cEditor)
	
	// Cria novo arquivo com dados
	OLE_NEWFILE( oWord , cPathPro)
	
	// Define as propriedades de aparencia da janela do Word
	OLE_SetProperty( oWord, oleWdVisible		, .t.)	 					// A janela serแ visivel
	OLE_SetProperty( oWord, oleWdPrintBack		, .t.)	 					// A impressao sera feita sem travar o desktop
	OLE_SetProperty( oWord, oleWdLeft			, 000)    					// A extremidade esquerda da janela estara na coluna 000
	OLE_SetProperty( oWord, oleWdTop			, 090)    					// A extremidade superior da janela estara na lina 090
	OLE_SetProperty( oWord, oleWdWidth			, 480)    					// A largura da janela tera 480 pixel
	OLE_SetProperty( oWord, oleWdHeight			, 250)    					// A altura da janela tera 250 pixel
	OLE_SetProperty( oWord, oleWdWindowState	, .f.)						// A janela nao vai estar maximizada
	OLE_SetProperty( oWord, oleWdCaption		, "Proposta Comercial")  	// Nome dado เ janela
	
	// Define o conteudo das variaveis do documento
	OLE_SETDOCUMENTVAR( oWord, "cNomeCli"  	, cNomeCli    )
	OLE_SETDOCUMENTVAR( oWord, "cNomeFan"  	, cNomeFan    )
	OLE_SETDOCUMENTVAR( oWord, "cUnidade"  	, cUnidade    )
	OLE_SETDOCUMENTVAR( oWord, "cNumProj"  	, cNumProj    )
	OLE_SETDOCUMENTVAR( oWord, "cRevisao"  	, cRevisao    )
	OLE_SETDOCUMENTVAR( oWord, "cRefConv"  	, cRefConv    )
	OLE_SETDOCUMENTVAR( oWord, "cRefCli"   	, cRefCli     )
	OLE_SETDOCUMENTVAR( oWord, "cRespTec"  	, cRespTec    )
	OLE_SETDOCUMENTVAR( oWord, "cRespSup"  	, cRespSup    )
	OLE_SETDOCUMENTVAR( oWord, "cTitulo"   	, cTitulo     )
	OLE_SETDOCUMENTVAR( oWord, "cDescRes"  	, cDescRes    )
	OLE_SETDOCUMENTVAR( oWord, "cObs"      	, cObs        )
	OLE_SETDOCUMENTVAR( oWord, "cVisao"    	, cVisao      )
	OLE_SETDOCUMENTVAR( oWord, "cInicio"   	, cInicio     )
	OLE_SETDOCUMENTVAR( oWord, "cFinal"    	, cFinal      )
	OLE_SETDOCUMENTVAR( oWord, "cPrazo"    	, cPrazo      )
	OLE_SETDOCUMENTVAR( oWord, "cEmissao"  	, cEmissao    )

	// Preenche o escopo
	OLE_SetDocumentVar(oWord, 'numesc',AllTrim(str(Len(aEscopo))))
	If Len(aEscopo)>0
		xDesDis := ""
		For _x := 1 to Len(aEscopo)
			If xDesDis != aEscopo[_x][1]
				OLE_SetDocumentVar(oWord,"cDesDis"+AllTrim(Str(_x)),aEscopo[_x][1])
				xDesDis := aEscopo[_x][1]
			Else
				OLE_SetDocumentVar(oWord,"cDesDis"+AllTrim(Str(_x)),"")
			EndIf
			OLE_SetDocumentVar(oWord,"cDesAti"+AllTrim(Str(_x)),aEscopo[_x][2])
			OLE_SetDocumentVar(oWord,"cQtdRec"+AllTrim(Str(_x)),aEscopo[_x][3])
			OLE_SetDocumentVar(oWord,"cUMRec" +AllTrim(Str(_x)),aEscopo[_x][4])
		Next
	Endif

	// Preenche os recursos alocados
	OLE_SetDocumentVar(oWord, 'numrec',AllTrim(str(Len(aRecurso))))
	If Len(aRecurso)>0
		For _x := 1 to Len(aRecurso)
			OLE_SetDocumentVar(oWord,"cDesRec"+AllTrim(Str(_x)),aRecurso[_x][1])
			OLE_SetDocumentVar(oWord,"cQtdRcs"+AllTrim(Str(_x)),aRecurso[_x][2])
		Next
	Endif

	// Preenche o total por escopo
	OLE_SetDocumentVar(oWord, 'numtot',AllTrim(str(Len(aTotal))))
	nVlrTotPrc := 0
	If Len(aTotal)>0
		For _x := 1 to Len(aTotal)
			OLE_SetDocumentVar(oWord,"cNomTot"+AllTrim(Str(_x)),aTotal[_x][1])
			OLE_SetDocumentVar(oWord,"cVlrTot"+AllTrim(Str(_x)),Transform(aTotal[_x][2],"@E 999,999.99"))
			nVlrTotPrc += aTotal[_x][2]
		Next
	Endif
	OLE_SETDOCUMENTVAR( oWord, "cVlrTotPrc"	, Transform(nVlrTotPrc,"@E 999,999,999.99") )

	// Executa a macro
	If Len(aEscopo)>0
		OLE_ExecuteMacro(oWord,"Escopo")
	EndIf

	// Executa a macro
	If Len(aRecurso)>0
		OLE_ExecuteMacro(oWord,"Recurso")
    EndIf
	
	// Executa a macro
	If Len(aTotal)>0
		OLE_ExecuteMacro(oWord,"Preco")
	EndIf
	
	// Atualiza o documento de acordo com as variaveis atualizadas
	OLE_UPDATEFIELDS( oWord )
	
	// Encerra o link sem fechar o word
	OLE_CloseLink( oWord, .f. )
Else
	MsgStop("Projeto nใo encontrado!")
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRetRecur  บ Autor ณ Daniel Franciulli  บ Data ณ  07/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Retorna os recurstos e a quantidade de alocacao            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RetRecur(_cProjet, _cRevis)

Local _cQuery := ""
Local _aRet	  := {}
Local _nTotal := 0

_cQuery += "SELECT "
_cQuery += "AE8_DESCRI RECURSO, SUM(AFA_QUANT) QUANT  "
_cQuery += "FROM "
_cQuery += RetSQLName("AFA") + " AFA, "
_cQuery += RetSQLName("AE8") + " AE8 "
_cQuery += "WHERE "
_cQuery += "AFA.D_E_L_E_T_='' "
_cQuery += "AND AE8.D_E_L_E_T_='' "
_cQuery += "AND AFA_FILIAL='"+xFilial("AFA")+"' " 
_cQuery += "and AE8_FILIAL='"+xFilial("AE8")+"' " 
_cQuery += "AND AE8_RECURS=AFA_RECURS "
_cQuery += "AND AFA_PROJET='"+ _cProjet+"' "
_cQuery += "AND AFA_REVISA='"+ _cRevis +"' " 
_cQuery += "GROUP BY AE8_DESCRI "

_cQuery := ChangeQuery(_cQuery)

IF SELECT("TRB")>0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.f.,.t.)

IF  Select( "TRB" )==0 .or. (TRB->(EOF()) .AND. TRB->(BOF()))
Else
	dbSelectArea("TRB")
	TRB->(dbGoTop())
	While TRB->(!Eof())
		AADD(_aRet,{"",""})
		_aRet[Len(_aRet)][1] 	:= Alltrim(TRB->RECURSO)
		_aRet[Len(_aRet)][2] 	:= Transform(TRB->QUANT,"@E 999,999.99")
		_nTotal					+= TRB->QUANT
		TRB->(DbSkip())
	End
	AADD(_aRet,{"Total",Transform(_nTotal,"@E 999,999.99")})
Endif

Return(_aRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRetPrazo  บ Autor ณ Daniel Franciulli  บ Data ณ  07/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Retorna o prazo do projeto                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RetPrazo(_cProjet, _cRevis)

Local _cQuery := ""
Local _aRet	  := {dDataBase,dDataBase,0}

_cQuery += "SELECT MAX(AF9_FINISH) FINAL, MIN(AF9_START) INICIO, DATEDIFF(DAY, MIN(AF9_START), MAX(AF9_FINISH)) PRAZO "
_cQuery += "FROM "
_cQuery += RetSqlName("AF9") + " AF9 "
_cQuery += "WHERE "
_cQuery += "AF9.D_E_L_E_T_ =  '' "
_cQuery += "AND AF9_FILIAL =  '"+xFilial("AF9")+"' "
_cQuery += "AND AF9_FINISH <> '' "
_cQuery += "AND AF9_START  <> '' "
_cQuery += "AND AF9_PROJET = '" + _cProjet +"' "
_cQuery += "AND AF9_REVISA = '" + _cRevis  +"' "

_cQuery := ChangeQuery(_cQuery)

IF 	SELECT("TRB")>0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.f.,.t.)

IF  Select( "TRB" )==0 .or. (TRB->(EOF()) .AND. TRB->(BOF()))
Else
	dbSelectArea("TRB")
	TRB->(dbGoTop())
	_aRet[1] := Stod(TRB->INICIO)
	_aRet[2] := Stod(TRB->FINAL)
	_aRet[3] := TRB->PRAZO
Endif

Return(_aRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRetEscop  บ Autor ณ Daniel Franciulli  บ Data ณ  07/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Retorna o escopo do projeto                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RetEscop(_cProjet, _cRevis)

Local _cQuery := ""
Local _aRet	  := {}

_cQuery += "SELECT "
_cQuery += "AFC_DESCRI DISCIP,SUM(AF9_QUANT) QUANT, AF9_DESCRI ATIVID, AF9_UM UM "
_cQuery += "FROM "
_cQuery += RetSQLName("AF9") + " AF9,"
_cQuery += RetSQLName("AFC") + " AFC "
_cQuery += "WHERE "
_cQuery += "AF9.D_E_L_E_T_=' ' "
_cQuery += "AND AFC.D_E_L_E_T_=' ' "
_cQuery += "AND AF9_FILIAL='"+xFilial("AF9")+"' "
_cQuery += "AND AFC_FILIAL='"+xFilial("AFC")+"' "
_cQuery += "AND AFC.D_E_L_E_T_=' ' "
_cQuery += "AND AFC_PROJET+AFC_REVISA+AFC_EDT=AF9_PROJET+AF9_REVISA+AF9_EDTPAI "
_cQuery += "AND AF9_PROJET='" + _cProjet + "' "
_cQuery += "AND AF9_REVISA='" + _cRevis  + "' "
_cQuery += "GROUP BY AFC_DESCRI, AF9_DESCRI, AF9_UM "
_cQuery += "ORDER BY DISCIP, ATIVID "

_cQuery := ChangeQuery(_cQuery)

IF SELECT("TRB")>0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.f.,.t.)

IF  Select( "TRB" )==0 .or. (TRB->(EOF()) .AND. TRB->(BOF()))
Else
	dbSelectArea("TRB")
	TRB->(dbGoTop())
	While TRB->(!Eof())
		AADD(_aRet,{"","","",""})
		_aRet[Len(_aRet)][1] := TRB->DISCIP
		_aRet[Len(_aRet)][2] := TRB->ATIVID                                                                                     
		_aRet[Len(_aRet)][3] := Transform(TRB->QUANT,"@E 999,999.99")                                                          
		_aRet[Len(_aRet)][4] := TRB->UM
		TRB->(DbSkip())
	End
Endif

Return(_aRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRetTotal  บ Autor ณ Daniel Franciulli  บ Data ณ  07/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Retorna os totais por recursos                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RetTotal(_cProjet, _cRevis)

Local _cQuery := ""
Local _aRet	  := {}

_cQuery += "SELECT AFC_DESCRI DESCRI, SUM(AFC_TOTAL) TOTAL "
_cQuery += "FROM "
_cQuery += RetSQLName("AFC") + " AFC "
_cQuery += "WHERE "
_cQuery += "D_E_L_E_T_='' "
_cQuery += "AND AFC_FILIAL='"+xFilial("AFC")+"' "
_cQuery += "AND AFC_PROJET='"+_cProjet+"' "
_cQuery += "AND AFC_REVISA='"+_cRevis+"' "
_cQuery += "GROUP BY AFC_DESCRI "

_cQuery := ChangeQuery(_cQuery)

IF SELECT("TRB")>0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.f.,.t.)

IF  Select( "TRB" )==0 .or. (TRB->(EOF()) .AND. TRB->(BOF()))
Else
	dbSelectArea("TRB")
	TRB->(dbGoTop())
	While TRB->(!Eof())
		AADD(_aRet,{"",""})
		_aRet[Len(_aRet)][1] := TRB->DESCRI
		_aRet[Len(_aRet)][2] := TRB->TOTAL
		TRB->(DbSkip())
	End
Endif

Return(_aRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  19/04/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs   := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(_cPerg,Len(X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

aAdd(aRegs,{_cPerg,"01","Num. Projeto           ?","Num. Projeto           ?","Num. Projeto          ?","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","AF8",""})
aAdd(aRegs,{_cPerg,"02","Revisใo                ?","Revisใo                ?","Revisใo               ?","mv_ch2","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return