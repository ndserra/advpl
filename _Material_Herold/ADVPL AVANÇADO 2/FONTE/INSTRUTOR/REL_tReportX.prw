	#include "protheus.ch"

//#######################################################################################################
// Relatorio Resumo de recebimento usado para fechamento mensal

User Function tReportX()

Local oReport

Local cPerg := "tReportX"

Private cTabTmp := GetNextAlias()
Private cArqTmp

Private cTabSE1 := GetNextAlias()
Private cArqSE1

Private aTotRec := {}
Private aResRec := {}
Private aTotais := {}
Private aTotSE1 := {}

Private nVlrNId := 0

AjustSX1(cPerg)

Pergunte(cPerg,.F.)

CriarTmp() // Criar tabela temporaria com dados para impressao

oReport := ReportDef(cPerg)
oReport:PrintDialog()

dbSelectArea(cTabTmp)
fErase(cArqTmp+GetDbExtension())
fErase(cArqTmp+OrdBagExt())

Return

//#######################################################################################################

Static Function AjustSX1(cPerg)

PutSx1( cPerg,"01","Data de"			,"","","mv_ch1","D",08,0,0,"G","",""   ,"","","MV_PAR01","","","","","","","","","","","","","","","","",{""},{""},{""},"")
PutSx1( cPerg,"02","Data ate"			,"","","mv_ch2","D",08,0,0,"G","",""   ,"","","MV_PAR02","","","","","","","","","","","","","","","","",{""},{""},{""},"")
PutSx1( cPerg,"03","Tipo Relatorio"		,"","","mv_ch3","N",01,0,0,"C","",""   ,"","","MV_PAR03","Analitico","Analitico","Analitico","","Sintetico","Sintetico","Sintetico","","","","","","","","","")
PutSx1( cPerg,"04","Titulos em aberto?"	,"","","mv_ch4","N",01,0,0,"C","",""   ,"","","MV_PAR04","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","")
PutSx1( cPerg,"05","Emissao de"			,"","","mv_ch5","D",08,0,0,"G","",""   ,"","","MV_PAR05","","","","","","","","","","","","","","","","",{""},{""},{""},"")
PutSx1( cPerg,"06","Emissao ate"		,"","","mv_ch6","D",08,0,0,"G","",""   ,"","","MV_PAR06","","","","","","","","","","","","","","","","",{""},{""},{""},"")
PutSx1( cPerg,"07","Vencimento"			,"","","mv_ch7","D",08,0,0,"G","",""   ,"","","MV_PAR07","","","","","","","","","","","","","","","","",{""},{""},{""},"")
PutSx1( cPerg,"08","Detalhar em ab."	,"","","mv_ch8","N",01,0,0,"C","",""   ,"","","MV_PAR08","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","")
PutSx1( cPerg,"09","Sel.Titulo"			,"","","mv_ch9","C",12,0,0,"G","",""   ,"","","MV_PAR09","","","","","","","","","","","","","","","","",{"Caso queira exibir apenas um titulo de rec. digitar aqui prefixo+parcela"},{""},{""},"")

Return

//#######################################################################################################
// Criar arquivo temporario para os recebimentos

Static Function CriarTmp()

Local aCampos := {}

aCampos := {;
{"TITULO"	,"C",20,00},;
{"DATABX"	,"D",08,00},;
{"DATADS"	,"D",08,00},;
{"CODCLI"	,"C",09,00},;
{"NOMCLI"	,"C",20,00},;
{"VALREC"	,"N",12,02},;
{"MOTBX"	,"C",03,00},;
{"LOTE"		,"C",08,00},;
{"BANCO"	,"C",03,00},;
{"HIST"		,"C",40,00},;
{"VENTIT"	,"D",08,00},;
{"EMITIT"	,"D",08,00},;
{"OBS"		,"C",30,00},;
{"OBS2"		,"C",03,00},;
{"OBS3"		,"C",03,00},;
{"OBS4"		,"C",03,00},;
{"OBS5"		,"C",03,00},;
{"DOCUME"	,"C",50,00},;
{"VALORI"	,"N",12,02},;
{"VALRC"	,"N",12,02},;
{"ARQCNAB"	,"C",60,00}}

cArqTmp := CriaTrab(aCampos, .T.)

dbUseArea(.T.,, cArqTmp, cTabTmp, .F., .F.)
IndRegua(cTabTmp, cArqTmp, "TITULO")

Return

//#######################################################################################################
// Criar arquivo temporario para os titulos em aberto

Static Function CriarTMP2()

Local aCampos := {}

aCampos := {;
{"E1_TITULO","C",TamSX3("E1_PREFIXO")[1]+TamSX3("E1_NUM")[1]+TamSX3("E1_PARCELA")[1]+TamSX3("E1_TIPO")[1]+4},;
{"E1_EMISSAO"	,"D",08,00},;
{"E1_VENCTO" 	,"D",08,00},;
{"E1_VALOR"		,"N",12,02},;
{"E1_SALDO"		,"N",12,02},;
{"E1_CODCLI"	,"C",09,00},;
{"E1_NOMCLI" 	,"C",TamSX3("E1_NOMCLI")[1],00},;
{"OBS"			,"C",20,00}}

cArqSE1 := CriaTrab(aCampos, .T.)

dbUseArea(.T.,, cArqSE1, cTabSE1, .F., .F.)
IndRegua(cTabSE1, cArqSE1, "E1_TITULO")

Return

//#######################################################################################################

Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local oSection4
Local oSection5

oReport := TReport():New(cPerg,"Resumo Recebimento - Fechamento",cPerg,{|oReport| PrintReport(oReport)},"Resumo Recebimento - Fechamento")
oReport:SetLandscape()
oReport:oPage:NPAPERSIZE	:= 9

oSection1 := TRSection():New(oReport,"Resumo Recebimento",{cTabTmp})
//oSection2 := TRSection():New(oSection1,"Resumos",{})
oSection2 := TRSection():New(oReport,"Resumos1",{})
oSection3 := TRSection():New(oReport,"Resumos2",{})
oSection4 := TRSection():New(oReport,"Resumos3",{})
oSection5 := TRSection():New(oReport,"Resumo a Vencer",{cTabSE1})

TRCell():New(oSection1,"OBS"	,cTabTmp,"Obs"				,,20,,)
TRCell():New(oSection1,"OBS2"	,cTabTmp,"Ob2"				,,03,,)
TRCell():New(oSection1,"OBS3"	,cTabTmp,"Ob3"				,,03,,)
TRCell():New(oSection1,"OBS4"	,cTabTmp,"Ob4"				,,03,,)
TRCell():New(oSection1,"OBS5"	,cTabTmp,"Ob5"				,,03,,)

TRCell():New(oSection1,"TITULO"	,cTabTmp,"Titulo"			,,20,,)
TRCell():New(oSection1,"DATABX"	,cTabTmp,"Data"				,,08,,)
TRCell():New(oSection1,"DATADS"	,cTabTmp,"Dt.Disp"			,,08,,)
TRCell():New(oSection1,"CODCLI"	,cTabTmp,"Cod.Cli"			,,09,,)
TRCell():New(oSection1,"NOMCLI"	,cTabTmp,"Cliente"			,,20,,)
TRCell():New(oSection1,"VALREC"	,cTabTmp,"Valor Rec."		,"@E 999,999,999.99" ,TamSX3("E5_VALOR")[1],,)
TRCell():New(oSection1,"MOTBX"	,cTabTmp,"Mot.Bx"			,,03,,)
//TRCell():New(oSection1,"LOTE"	,cTabTmp,"Lote"				,,08,,)
TRCell():New(oSection1,"BANCO"	,cTabTmp,"Banco"			,,03,,)
TRCell():New(oSection1,"HIST"	,cTabTmp,"Historico"		,,30,,)
TRCell():New(oSection1,"VENTIT"	,cTabTmp,"Venc.Tit"			,,08,,)
TRCell():New(oSection1,"EMITIT"	,cTabTmp,"Emis.Tit"			,,08,,)
TRCell():New(oSection1,"VALORI"	,cTabTmp,"Valor Original" 	,"@E 999,999,999.99",TamSX3("E5_VALOR")[1],,)
TRCell():New(oSection1,"VALRC"	,cTabTmp,"Valor RC" 		,"@E 999,999,999.99",TamSX3("E5_VALOR")[1],,)
TRCell():New(oSection1,"cArqCnab"," "	,"Arquivo"			,,12,,)

TRCell():New(oSection2,"cLinha",," ",,40,,)
TRCell():New(oSection2,"nTotal",,"$","@E 999,999,999.99",TamSX3("E5_VALOR")[1],,,"RIGHT",,"RIGHT")

TRCell():New(oSection3,"cLinha"		,,"Tipo Recebimento"	,,25,,)
TRCell():New(oSection3,"nTotal1"	,,"Total"				,"@E 999,999,999.99",TamSX3("E5_VALOR")[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection3,"nTotal2"	,,"Atrasado"			,"@E 999,999,999.99",TamSX3("E5_VALOR")[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection3,"nTotal3"	,,"a Vista"				,"@E 999,999,999.99",TamSX3("E5_VALOR")[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection3,"nTotal4"	,,"Antecipado"			,"@E 999,999,999.99",TamSX3("E5_VALOR")[1],,,"RIGHT",,"RIGHT")

TRCell():New(oSection4,"cLinha"		,,""                	,,25,,)//,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"nTotal1"	,,"Geral"		,"@E 999,999,999.99",TamSX3("E5_VALOR")[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"nTotal2"	,,"RC"			,"@E 999,999,999.99",TamSX3("E5_VALOR")[1],,,"RIGHT",,"RIGHT")
TRCell():New(oSection4,"nTotal3"	,,"a Vista"		,"@E 999,999,999.99",TamSX3("E5_VALOR")[1],,,"RIGHT",,"RIGHT")

TRCell():New(oSection5,"E1_TITULO"	,cTabSE1    ,"Titulo" 		,,TamSX3("E1_PREFIXO")[1]+TamSX3("E1_NUM")[1]+TamSX3("E1_PARCELA")[1]+TamSX3("E1_TIPO")[1]+4,,)
TRCell():New(oSection5,"E1_EMISSAO"	,cTabSE1  	,"Emissao" 		,,08,,)
TRCell():New(oSection5,"E1_VENCTO" 	,cTabSE1 	,"Vencto" 		,,08,,)
TRCell():New(oSection5,"E1_VALOR"	,cTabSE1	,"Valor Orig"	,"@E 999,999,999.99",TamSX3("E1_VALOR")[1],,)
TRCell():New(oSection5,"E1_SALDO"	,cTabSE1	,"Saldo" 		,"@E 999,999,999.99",TamSX3("E1_SALDO")[1],,)
TRCell():New(oSection5,"E1_CODCLI"	,cTabSE1	,"Cod.Cli" 		,,09,,)
TRCell():New(oSection5,"E1_NOMCLI" 	,cTabSE1	,"Nome Cliente"	,,TamSX3("E1_NOMCLI")[1],,)
//TRCell():New(oSection5,"E1_X_FORMA"	,cTabSE1 	,"Forma"			,,TamSX3("E1_X_FORMA")[1],,)
TRCell():New(oSection5,"OBS"		,cTabSE1	,"OBS"			,,20,,)

Return oReport

//#######################################################################################################

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
//Local oSection2 := oReport:Section(1):Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local oSection4 := oReport:Section(4)
Local oSection5 := oReport:Section(5)

Local nCount := 0

Local nTotal1 := 0
Local nTotal2 := 0

If MV_PAR08 == 1
	CriarTmp2()
EndIf

//----------------------------------------------------------------------------------------------------
// Processar os dados, alimentar as tabelas temporarias

Processa( { || fGravaTmp() },"Movimentacao Bancaria (SE5)" )  // Recebimentos

If Empty(MV_PAR09)
	Processa( { || fOutrosCred()},"Outros Creditos" )  // Outros creditos (banco do brsil)
EndIf

If MV_PAR04 == 1
	Processa( { || fGravaTmp2() },"Titulos em aberto (SE1)" )  // Titulos em aberto
EndIf

//----------------------------------------------------------------------------------------------------

dbSelectArea(cTabTmp)
dbGoTop()

Count to nCount

oReport:SetMeter(nCount)

dbGoTop()

If MV_PAR03 == 1 // se for analitico exibir os recebimentos
	
	oSection1:Init()
	
	While !Eof() .and. !oReport:Cancel()
		
		If oReport:Cancel()
			Exit
		EndIf
		
		oReport:IncMeter()
		
		oSection1:Cell("cArqCnab"):SetValue( Right( AllTrim( (cTabTmp)->ARQCNAB ),12) )
		
		oSection1:PrintLine()
		
		dbSelectArea(cTabTmp)
		dbSkip()
		
	EndDo
	
	oReport:SkipLine()
	oReport:ThinLine()
	
	oSection1:Finish()
	
EndIf

oSection2:Init()

oReport:SkipLine()

If MV_PAR03 == 1
	oReport:PrintText("Totais na proxima pagina")
	oReport:EndPage()
EndIf

//------------------------------------------------------------------------------------
// Exibir totais

oReport:PrintText("Periodo:" + Dtoc(MV_PAR01) + " ate " + Dtoc(MV_PAR02),,25)
oReport:SkipLine()

For _x := 1 to Len(aTotRec)
	
	If _x == 8
		oReport:SkipLine()
		
		oSection2:Cell("cLinha"):SetValue("Recebimento (Extrato + Dinheiro)")
		oSection2:Cell("nTotal"):SetValue(nTotal1)
		
		oSection2:PrintLine()
		
		oReport:SkipLine()
		
		nTotal1 := 0
	EndIf
	
	oSection2:Cell("cLinha"):SetValue(aTotRec[_x,1])
	oSection2:Cell("nTotal"):SetValue(aTotRec[_x,2])
	
	nTotal1+=aTotRec[_x,2]
	nTotal2+=aTotRec[_x,2]
	
	oSection2:PrintLine()
	
Next

oReport:SkipLine()

oSection2:Cell("cLinha"):SetValue("Outras movimentações no CR")
oSection2:Cell("nTotal"):SetValue(nTotal1)

oSection2:PrintLine()

oReport:SkipLine()

oSection2:Cell("cLinha"):SetValue("Recebimento + Outras movimentações")
oSection2:Cell("nTotal"):SetValue(nTotal2)

oSection2:PrintLine()

oReport:SkipLine()

oSection2:Cell("cLinha"):SetValue("Movimentos não identificados")
oSection2:Cell("nTotal"):SetValue(nVlrNId)

oSection2:PrintLine()

oReport:SkipLine()

oSection2:Finish()

oSection3:Init()

For _x := 1 to Len(aResRec)

	oSection3:Cell("cLinha"):SetValue(aResRec[_x,1])
	oSection3:Cell("nTotal1"):SetValue(aResRec[_x,2])
	oSection3:Cell("nTotal2"):SetValue(aResRec[_x,3])
	oSection3:Cell("nTotal3"):SetValue(aResRec[_x,4])
	oSection3:Cell("nTotal4"):SetValue(aResRec[_x,5])
	
	oSection3:PrintLine()

	oReport:SkipLine()

Next

oReport:SkipLine()

oSection3:Finish()

//------------------------------------------------------------------------------------
// Exibir totais dos titulos em aberto

If MV_PAR04 == 1

	oSection4:Init()

	oReport:PrintText("Titulos em aberto (a receber)")

	For _x := 1 to Len(aTotSE1)

		oSection4:Cell("cLinha"):SetValue(aTotSE1[_x,1])
		oSection4:Cell("nTotal1"):SetValue(aTotSE1[_x,2])
		oSection4:Cell("nTotal2"):SetValue(aTotSE1[_x,3])
		oSection4:Cell("nTotal3"):SetValue(aTotSE1[_x,4])

		oSection4:PrintLine()
	
		oReport:SkipLine()

	Next

	oReport:SkipLine()

	oSection4:Finish()

EndIf

//------------------------------------------------------------------------------------
// Detalhas os titulos em aberto

oReport:ThinLine()

If MV_PAR03 == 1 .and. MV_PAR04 == 1 .and. MV_PAR08 == 1

	dbSelectArea(cTabSE1)
	dbGoTop()

	Count to nCount

	oReport:SetMeter(nCount)

	dbGoTop()
	
	oSection5:Init()
	
	While !Eof() .and. !oReport:Cancel()
		
		If oReport:Cancel()
			Exit
		EndIf
		
		oReport:IncMeter()
		
		oSection5:PrintLine()
		
		dbSelectArea(cTabSE1)
		dbSkip()
		
	EndDo
	
	oReport:SkipLine()
	oReport:ThinLine()
	
	oSection5:Finish()

	dbSelectArea(cTabSE1)
	fErase(cArqSE1+GetDbExtension())
	fErase(cArqSE1+OrdBagExt())
	
EndIf

//------------------------------------------------------------------------------------

Return

//#######################################################################################################
// Gravar tabela tempoaria com os recebimentos

Static Function fGravaTmp()

Local cQuery := ""
Local cAlias := GetNextAlias()

Local nCount := 0

Local dDatMov := Ctod(Space(08))

Local cMAnoR := "" // Mes Ano Recebimento
Local cMAnoV := "" // Mes Ano Vencimento
Local cMAnoE := "" // Mes Ano Emissao

Local lRc := .f. 
Local lQuadro := .f.

Local nVlrRC := 0

Local nAuxRc := 0

//--------------------------------------------------------------------------
// Usado no oSection2

aAdd( aTotRec, {"Bradesco cnab"		,0} )
aAdd( aTotRec, {"Bradesco RA"		,0} )
aAdd( aTotRec, {"Brasil cnab"		,0} )
aAdd( aTotRec, {"Brasil RA"			,0} )
aAdd( aTotRec, {"Bradesco deposito"	,0} )
aAdd( aTotRec, {"Brasil deposito"	,0} )
aAdd( aTotRec, {"Caixa (dinheiro)"	,0} )

aAdd( aTotRec, {"NCC"	,0} )
aAdd( aTotRec, {"CEC"	,0} )

//--------------------------------------------------------------------------

aAdd( aTotais, {"Recebimento RC"			,0} )
aAdd( aTotais, {"Recebimento AV"			,0} )
aAdd( aTotais, {"Recebimento Atrasado"		,0} )
aAdd( aTotais, {"Recebimento Antecipado"	,0} )

//--------------------------------------------------------------------------
// Usado no oSection3

aAdd( aResRec, {"Geral"				,0			,0			,0			,0				} )
aAdd( aResRec, {"RC"   				,0			,0			,0			,0				} )

//--------------------------------------------------------------------------

cQuery += " SELECT "
cQuery += "    E5_DATA, E5_DTDIGIT, E5_DTDISPO, E5_VALOR, E5_BANCO, E5_TIPODOC, E5_LOTE, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, "
cQuery += "    E5_MOTBX, E5_ARQCNAB, E5_CLIENTE, E5_LOJA, E5_HISTOR, E5_DOCUMEN, E5_SEQ, E5_CLIENTE, E5_LOJA "
cQuery += " FROM " + RetSQLName("SE5")
cQuery += " WHERE
cQuery += "    E5_FILIAL = '" + xFilial("SE5") + "' AND "
cQuery += "    (
cQuery += "    (E5_DATA >= '" + Dtos(MV_PAR01) + "' AND E5_DATA <= '" + Dtos(MV_PAR02) + "') OR
cQuery += "    (E5_DTDISPO >= '" + Dtos(MV_PAR01) + "' AND E5_DTDISPO <= '" + Dtos(MV_PAR02) + "')
cQuery += "    ) AND
cQuery += "    D_E_L_E_T_ <> '*' AND "
cQuery += "    E5_FATURA =' '  AND "
cQuery += "    E5_RECPAG = 'R' AND "
cQuery += "    E5_MOTBX NOT IN ('LUC','LIQ') AND "
cQuery += "    E5_SITUACA <> 'C' AND E5_TIPODOC <> 'ES' AND E5_VALOR > 0"


If !Empty(MV_PAR09)
	cQuery += "    AND E5_PREFIXO = '" + SubStr(MV_PAR09,1,3) + "' AND E5_NUMERO = '" + SubStr(MV_PAR09,4,9) + "' "
Endif

MemoWrit( "C:\RELATORIOS\RO_RELREC.SQL", cQuery )

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)

TCSetField( cAlias, "E5_DATA" 		, "D", 08, 0 )
TCSetField( cAlias, "E5_DTDIGIT" 	, "D", 08, 0 )
TCSetField( cAlias, "E5_DTDISPO"	, "D", 08, 0 )
TCSetField( cAlias, "E5_VALOR" 		, "N", 14, 2 )

dbSelectArea(cAlias)
dbGoTop()

Count to nCount

ProcRegua(nCount)

dbGoTop()

nVlrNId := 0

While !Eof()
	
	IncProc()

	nVlrRC := 0
	
	//-----------------------------------------------------------------------------------
	// Tipos de registros que nao podem ser exibidos

	If fCancela((cAlias)->E5_PREFIXO, (cAlias)->E5_NUMERO, (cAlias)->E5_PARCELA, (cAlias)->E5_CLIENTE, (cAlias)->E5_LOJA, (cAlias)->E5_TIPO, (cAlias)->E5_SEQ)
		dbSelectArea(cAlias)
		dbSkip()
		Loop
	EndIf

	dbSelectArea(cAlias)
	
	Do Case
		Case Empty((cAlias)->E5_NUMERO)
			dbSkip()
			Loop
		Case AllTrim((cAlias)->E5_TIPO) == "NDF" // Multa
			dbSkip()
			Loop
		Case AllTrim((cAlias)->E5_TIPODOC) == "MT" // Multa
			dbSkip()
			Loop
		Case AllTrim((cAlias)->E5_TIPODOC) == "JR" // Juros
			dbSkip()
			Loop
		Case AllTrim((cAlias)->E5_TIPODOC) == "DC" // Descontos
			dbSkip()
			Loop
		Case AllTrim((cAlias)->E5_MOTBX) == "CMP" .and. AllTrim((cAlias)->E5_TIPO) == "DCB" 
			dbSkip()
			Loop
		Case AllTrim((cAlias)->E5_MOTBX) == "CMP" .and. AllTrim((cAlias)->E5_TIPO) == "JP" 
			dbSkip()
			Loop
		Case AllTrim((cAlias)->E5_MOTBX) == "CMP" .and. AllTrim((cAlias)->E5_TIPO) == "NF"
			dbSkip()
			Loop
		Case AllTrim((cAlias)->E5_MOTBX) == "CMP" .and. AllTrim((cAlias)->E5_TIPO) == "RA"
			dbSkip()
			Loop
		Case AllTrim((cAlias)->E5_MOTBX) == "CMP" .and. AllTrim((cAlias)->E5_TIPO) == "RC"
			dbSkip()
			Loop
		Case AllTrim((cAlias)->E5_MOTBX) == "CMP" .and. AllTrim((cAlias)->E5_TIPO) == "JC"
			dbSkip()
			Loop
		Case AllTrim((cAlias)->E5_MOTBX) == "LIQ" .and. AllTrim((cAlias)->E5_TIPO) == "NF"
			dbSkip()
			Loop
	EndCase
	
	//-----------------------------------------------------------------------------------
	// Buscar registro contas a receber
	
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSeek(xFilial("SE1")+(cAlias)->E5_PREFIXO + (cAlias)->E5_NUMERO + (cAlias)->E5_PARCELA + (cAlias)->E5_TIPO)

	If AllTrim((cAlias)->E5_PARCELA) == "1" .and. AllTrim((cAlias)->E5_TIPO) == "NF"
		nVlrRC := fVerRC((cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_CLIENTE,(cAlias)->E5_LOJA)
	EndIf
	
	//-----------------------------------------------------------------------------------

	dbSelectArea(cAlias)

	dDatMov := (cAlias)->E5_DATA
	
	Do Case
		Case (cAlias)->E5_BANCO == "237"
			If !( (cAlias)->E5_DTDISPO >= MV_PAR01 .and. (cAlias)->E5_DTDISPO <= MV_PAR02 )
				dbSkip()
				Loop
			EndIf
			dDatMov := (cAlias)->E5_DTDISPO
		Case (cAlias)->E5_BANCO == "237"
			If !((cAlias)->E5_DTDISPO >= MV_PAR01 .and. (cAlias)->E5_DTDISPO <= MV_PAR02)
				dbSkip()
				Loop
			EndIf
			dDatMov := (cAlias)->E5_DTDISPO
		Otherwise
			If !((cAlias)->E5_DATA >= MV_PAR01 .and. (cAlias)->E5_DATA <= MV_PAR02)
				dbSkip()
				Loop
			EndIf
	EndCase
	
	//-----------------------------------------------------------------------------------
	
	dbSelectArea(cAlias)
	
	RecLock(cTabTmp,.t.)
	(cTabTmp)->TITULO 	:= (cAlias)->E5_PREFIXO + "-" +(cAlias)->E5_NUMERO + "-" + (cAlias)->E5_PARCELA + "-" + (cAlias)->E5_TIPO
	(cTabTmp)->DATABX 	:= (cAlias)->E5_DATA
	(cTabTmp)->DATADS 	:= (cAlias)->E5_DTDISPO
	(cTabTmp)->CODCLI 	:= (cAlias)->E5_CLIENTE + "-" + (cAlias)->E5_LOJA
	(cTabTmp)->NOMCLI 	:= GetAdvFVal("SA1","A1_NREDUZ",xFilial("SA1")+(cAlias)->E5_CLIENTE+(cAlias)->E5_LOJA,1,)
	(cTabTmp)->VALREC 	:= (cAlias)->E5_VALOR
	(cTabTmp)->MOTBX 	:= (cAlias)->E5_MOTBX
	(cTabTmp)->LOTE 	:= (cAlias)->E5_LOTE
	(cTabTmp)->BANCO 	:= (cAlias)->E5_BANCO
	(cTabTmp)->HIST 	:= (cAlias)->E5_HISTOR
	(cTabTmp)->DOCUME 	:= (cAlias)->E5_DOCUMEN
	(cTabTmp)->VENTIT 	:= SE1->E1_VENCTO
	(cTabTmp)->EMITIT 	:= SE1->E1_EMISSAO
	(cTabTmp)->VALORI 	:= SE1->E1_VALOR
	(cTabTmp)->ARQCNAB	:= (cAlias)->E5_ARQCNAB
	
	//-----------------------------------------------------------------------------------
	// Totalizadores

	cMAnoR := SubStr(AllTrim(Dtos(dDatMov)),1,6)			// Mes Ano Recebimento
	cMAnoV := SubStr(AllTrim(Dtos(SE1->E1_VENCTO)),1,6) 	// Mes Ano Vencimento
	cMAnoE := SubStr(AllTrim(Dtos(SE1->E1_EMISSAO)),1,6) 	// Mes Ano Emissao

	lRc := .f.
	lQuadro := .f.
	nAuxRc := 0

	If AllTrim((cAlias)->E5_TIPO) == "RC"
		(cTabTmp)->VALRC	:= (cAlias)->E5_VALOR
		(cTabTmp)->OBS3 	:= "RC"
		nAuxRc 				:= (cAlias)->E5_VALOR
		lRc := .t.
	Else
		If nVlrRC > 0 
			(cTabTmp)->VALRC	:= nVlrRC
			(cTabTmp)->OBS3 	:= "RC"
			nAuxRc 				:= nVlrRC
			lRc := .t.
		EndIf
	EndIf
		
	Do Case
		Case (cAlias)->E5_BANCO == "237" .and. AllTrim((cAlias)->E5_TIPO) <> "RA" .and. !Empty((cAlias)->E5_ARQCNAB)
			aTotRec[1,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Bradesco cnab"
			//
			lQuadro := .t.
			//

		Case (cAlias)->E5_BANCO == "237" .and. AllTrim((cAlias)->E5_TIPO) <> "RA" .and. Empty((cAlias)->E5_ARQCNAB) .and. (cAlias)->E5_MOTBX == "NOR"
			// segundo a patricia as baixas manuais considerar como cnab
			aTotRec[1,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Bradesco cnab"
			//
			lQuadro := .t.
			//

		Case (cAlias)->E5_BANCO == "237" .and. AllTrim((cAlias)->E5_TIPO) <> "RA" .and. (cAlias)->E5_MOTBX == "DEP"
			aTotRec[5,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Bradesco deposito"
			//
			lQuadro := .t.
			//
			
		Case (cAlias)->E5_BANCO == "001" .and. AllTrim((cAlias)->E5_TIPO) <> "RA" .and. !Empty((cAlias)->E5_ARQCNAB)
			aTotRec[3,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Brasil cnab"
			//
			lQuadro := .t.
			//

		Case (cAlias)->E5_BANCO == "001" .and. AllTrim((cAlias)->E5_TIPO) <> "RA" .and. Empty((cAlias)->E5_ARQCNAB) .and. (cAlias)->E5_MOTBX == "NOR"
			// segundo a patricia as baixas manuais considerar como cnab
			aTotRec[3,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Brasil cnab"
			//
			lQuadro := .t.
			//
			
		Case (cAlias)->E5_BANCO == "001" .and. AllTrim((cAlias)->E5_TIPO) <> "RA" .and. (cAlias)->E5_MOTBX == "DEP"
			aTotRec[6,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Brasil deposito"
			//
			lQuadro := .t.
			//
			
		Case (cAlias)->E5_BANCO == "000" .and. ((cAlias)->E5_MOTBX == "DIN" .OR. (cAlias)->E5_MOTBX == "NOR")
			aTotRec[7,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Caixa (dinheiro)"
			//
			lQuadro := .t.
			//
			
		Case (cAlias)->E5_BANCO == "237" .and. AllTrim((cAlias)->E5_TIPO) == "RA" .and. "CNAB" $ (cAlias)->E5_HISTOR
			aTotRec[2,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Bradesco RA"
			//
			lQuadro := .t.
			//
			
		Case (cAlias)->E5_BANCO == "001" .and. AllTrim((cAlias)->E5_TIPO) == "RA" .and. "CNAB" $ (cAlias)->E5_HISTOR
			aTotRec[4,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Brasil RA"
			//
			lQuadro := .t.
			//
			
		Case (cAlias)->E5_BANCO == "237" .and. AllTrim((cAlias)->E5_TIPO) == "RA" .and. !("CNAB" $ (cAlias)->E5_HISTOR)
			aTotRec[5,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Bradesco deposito"
			//
			lQuadro := .t.
			//
			
		Case (cAlias)->E5_BANCO == "001" .and. AllTrim((cAlias)->E5_TIPO) == "RA" .and. !("CNAB" $ (cAlias)->E5_HISTOR)
			aTotRec[6,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Brasil deposito"
			//
			lQuadro := .t.
			//

		Case (cAlias)->E5_MOTBX == "DEV"
			aTotRec[8,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "NCC"
			
		Case (cAlias)->E5_MOTBX == "CMP" .and. (cAlias)->E5_TIPO == "NCC"
			aTotRec[8,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "NCC"
			
		Case (cAlias)->E5_MOTBX == "CEC"
			aTotRec[9,2] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "CEC"
			
		Otherwise
			nVlrNId += (cAlias)->E5_VALOR
			(cTabTmp)->OBS := "Movimentos não identificados"

	EndCase

	If lQuadro
		aResRec[1,2] += (cAlias)->E5_VALOR // Geral

		If dDatMov > SE1->E1_VENCTO .and. cMAnoR > cMAnoE // atrasado GERAL
			aResRec[1,3] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS5:= "ATR"
		EndIf

		If cMAnoR == cMAnoV .and. cMAnoR == cMAnoE .and. cMAnoE == cMAnoV // a vista GERAL
			aResRec[1,4] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS2:= "AV"
		EndIf

		If SE1->E1_VENCTO > dDatMov // antecipado Geral
			aResRec[1,5] += (cAlias)->E5_VALOR
			(cTabTmp)->OBS4:= "ANT"
		EndIf
	EndIf

	If lRc
		aResRec[2,2] += nAuxRc // Geral

		If dDatMov > SE1->E1_VENCTO .and. cMAnoR > cMAnoE // atrasado RC
			aResRec[2,3] += nAuxRc
			(cTabTmp)->OBS5:= "ATR"
		EndIf

		If cMAnoR == cMAnoV .and. cMAnoR == cMAnoE .and. cMAnoE == cMAnoV // a vista RC
			aResRec[2,4] += nAuxRc
			(cTabTmp)->OBS2:= "AV"
		EndIf

		If SE1->E1_VENCTO > dDatMov // antecipado RC
			aResRec[2,5] += nAuxRc
			(cTabTmp)->OBS4:= "ANT"
		EndIf
	EndIf

	//-----------------------------------------------------------------------------------

	MsUnlock()
	
	dbSelectArea(cAlias)
	dbSkip()
	
EndDo

dbSelectArea(cAlias)
dbCloseArea()

Return

//#######################################################################################################
// Verificar se um titulo tem Imposto Sub.Tributaria embutido

Static Function fVerRC(cPrefixo, cDoc, cCliente, cLoja)

Local nRet := 0
Local aArea := GetArea()
Local cQry  := ""
Local cAlTRB := GetNextAlias()
Local lRet := .f.

dbSelectArea("SF2")
dbSetOrder(1)
If dbSeek(xFilial("SF2")+cDoc+cPrefixo+cCliente+cLoja)
	nRet := SF2->F2_ICMSRET
EndIf

//----------------------------------------------------------------------------------------------
// So mostrar o campo F2_ICMSRET das notas que não tiveram parcela do tipo RC

cQry := "SELECT NVL (COUNT (E1_NUM), 0) AS TOTAL "
cQry += "  FROM " + RetSQLName("SE1")
cQry += " WHERE E1_FILIAL = '" + xFilial("SE1") + "'"
cQry += "   AND E1_NUM = '" + cDoc + "'"
cQry += "   AND E1_PREFIXO = '" + cPrefixo + "'"
cQry += "   AND E1_TIPO = 'RC'"
cQry += "   AND D_E_L_E_T_ <> '*'"

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQry), cAlTRB, .F., .T. )

lRet := ( (cAlTRB)->TOTAL > 0 )

dbSelectArea(cAlTRB)
dbCloseArea()

RestArea(aArea)

If lRet
	nRet := 0 // Se encontrou uma parcela RC em um titulo NF nao exibir valor do F2_ICMSRET
EndIf

//----------------------------------------------------------------------------------------------

Return(nRet)

//#######################################################################################################
// Gravar titulos em aberto

Static Function fGravaTmp2()

Local cQuery := ""
Local cAlias := GetNextAlias()

Local cObs	:= ""

Local nCount := 0

//--------------------------------------------------------------------------

aAdd( aTotSE1, {"Atraso"	,0,0,0} )
aAdd( aTotSE1, {"a Vencer"	,0,0,0} )
aAdd( aTotSE1, {"Total"		,0,0,0} )

//--------------------------------------------------------------------------

cQuery += " SELECT "
cQuery += "    E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_PORTADO, E1_EMISSAO, E1_VENCTO, E1_VALOR, E1_SALDO, E1_CLIENTE, E1_LOJA, E1_NOMCLI "
cQuery += " FROM " + RetSQLName("SE1")
cQuery += " WHERE
cQuery += "    E1_FILIAL = '" + xFilial("SE1") + "' AND "
cQuery += "    E1_EMISSAO >= '" + DtoS(MV_PAR05) + "' AND "
cQuery += "    E1_EMISSAO <= '" + Dtos(MV_PAR06) + "' AND " 
cQuery += "    E1_VENCTO >= '20080101' AND "
cQuery += "    E1_SALDO > 0 AND D_E_L_E_T_ <> '*' AND E1_TIPO <> 'RA' AND E1_TIPO <> 'NCC' "

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .F., .T.)

TCSetField( cAlias, "E1_EMISSAO", "D", 08, 0 )
TCSetField( cAlias, "E1_VENCTO"	, "D", 08, 0 )
TCSetField( cAlias, "E1_SALDO"	, "N", 14, 2 )
TCSetField( cAlias, "E1_VALOR"	, "N", 14, 2 )

dbSelectArea(cAlias)
dbGoTop()

Count to nCount

ProcRegua(nCount)

dbGoTop()

While !Eof()
	
	IncProc()

	aTotSE1[3,2] += (cAlias)->E1_SALDO // Total Geral

	Do Case 
		Case (cAlias)->E1_VENCTO < MV_PAR07 // Atraso Geral
			aTotSE1[1,2] += (cAlias)->E1_SALDO
			cObs := "Atraso"
		OtherWise // A vencer geral
			aTotSE1[2,2] += (cAlias)->E1_SALDO
			cObs := "a Vencer"
	EndCase

	If (cAlias)->E1_VENCTO < MV_PAR07 .and. AllTrim((cAlias)->E1_TIPO) == "RC" // RC Atraso
		aTotSE1[1,3] += (cAlias)->E1_SALDO
		aTotSE1[3,3] += (cAlias)->E1_SALDO // RC Total Geral
		cObs += " RC"
	EndIf

	If (cAlias)->E1_VENCTO >= MV_PAR07 .and. AllTrim((cAlias)->E1_TIPO) == "RC" // RC a vencer
		aTotSE1[2,3] += (cAlias)->E1_SALDO
		aTotSE1[3,3] += (cAlias)->E1_SALDO // RC Total Geral
		cObs += " RC"
	EndIf

	If (cAlias)->E1_VENCTO < MV_PAR07 .and. AllTrim((cAlias)->E1_TIPO) <> "RC" 
		aTotSE1[1,4] += (cAlias)->E1_SALDO
		aTotSE1[3,4] += (cAlias)->E1_SALDO // a vista Geral
		cObs += " A Vista"
	EndIf

	If (cAlias)->E1_VENCTO >= MV_PAR07 .and. AllTrim((cAlias)->E1_TIPO) <> "RC" 
		aTotSE1[2,4] += (cAlias)->E1_SALDO
		aTotSE1[3,4] += (cAlias)->E1_SALDO // a vista Geral
		cObs += " A Vista"
	EndIf

	//------------------------------------------------------------------------------------------
	// se for para detalhar os titulos em aberto gravar na tabela temporaria os titulos

	If MV_PAR08 == 1 
		RecLock(cTabSE1,.t.)
		(cTabSE1)->E1_TITULO 	:= (cAlias)->E1_PREFIXO+"-"+(cAlias)->E1_NUM+"-"+(cAlias)->E1_PARCELA+"-"+(cAlias)->E1_TIPO
		(cTabSE1)->E1_EMISSAO	:= (cAlias)->E1_EMISSAO
		(cTabSE1)->E1_VENCTO	:= (cAlias)->E1_VENCTO
		(cTabSE1)->E1_VALOR		:= (cAlias)->E1_VALOR
		(cTabSE1)->E1_SALDO		:= (cAlias)->E1_SALDO
		(cTabSE1)->E1_CODCLI	:= (cAlias)->E1_CLIENTE + "-" + (cAlias)->E1_LOJA
		(cTabSE1)->E1_NOMCLI	:= (cAlias)->E1_NOMCLI
		
		(cTabSE1)->OBS			:= cObs
		MsUnLock()
	EndIF

	//------------------------------------------------------------------------------------------
	
	dbSelectArea(cAlias)
	dbSkip()
	
EndDo

dbSelectArea(cAlias)
dbCloseArea()

Return

//#######################################################################################################
// Funcao para verificar se houve cancelamento da baixa

Static Function fCancela(cPrefixo, cNumero, cParcela, cCliente, cLoja, cTipo, cSeq)

Local lRet := .f.

Local cAliasC := GetNextAlias()
Local cQuery  := ""

cQuery += " SELECT "
cQuery += "    COUNT(*) AS QTDEREG "
cQuery += " FROM " + RetSQLName("SE5")
cQuery += " WHERE    
cQuery += "    E5_FILIAL 	= '" + xFilial("SE5")	+ "' AND "
cQuery += "    E5_PREFIXO	= '" + cPrefixo 		+ "' AND "
cQuery += "    E5_NUMERO 	= '" + cNumero 			+ "' AND "
cQuery += "    E5_PARCELA 	= '" + cParcela 		+ "' AND "
cQuery += "    E5_TIPO 		= '" + cTipo 			+ "' AND "
cQuery += "    E5_SEQ 		= '" + cSeq 			+ "' AND "
cQuery += "    E5_CLIENTE 	= '" + cCliente 		+ "' AND "
cQuery += "    E5_LOJA 		= '" + cLoja 			+ "' AND "
cQuery += "    E5_FATURA  	= ' ' AND 
cQuery += "    E5_RECPAG 	= 'P' AND "  
cQuery += "    E5_TIPODOC 	= 'ES' AND " 
cQuery += "    D_E_L_E_T_ 	<> '*' "

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasC, .F., .T.)

TCSetField( cAliasC, "QTDEREG"	, "N", 14, 0 )

If (cAliasC)->QTDEREG > 0
	lRet := .t.
EndIf

dbSelectArea(cAliasC)
dbCloseArea() 

Return(lRet)

//#######################################################################################################
// Funcao para tratar os outros creditos.

Static Function fOutrosCred()

Local cAliasC 	:= GetNextAlias()
Local cQuery  	:= ""
Local dDtCred	:= Ctod(Space(08))

cQuery += " SELECT "
cQuery += "   E5_DTDISPO, E5_VALOR, E5_MOTBX, E5_LOTE, E5_DOCUMEN, E5_HISTOR, E5_ARQCNAB, E5_BANCO "
cQuery += " FROM " + RetSQLName("SE5")
cQuery += " WHERE
cQuery += "   E5_FILIAL = '" + xFilial("SE5") + "' AND "
cQuery += "   E5_BANCO = '001' AND "
cQuery += "   E5_DOCUMEN = 'OUTROS CREDITOS' AND "
cQuery += "   D_E_L_E_T_ <> '*' AND "
cQuery += "   E5_RECPAG = 'R' "

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasC, .F., .T.)

TCSetField( cAliasC, "E5_VALOR"		, "N", 14, 2 )
TCSetField( cAliasC, "E5_DTDISPO"	, "D", 08, 0 )

dbSelectArea(cAliasC)
dbGoTop()

Count to nCount

ProcRegua(nCount)

dbGoTop()

While !EOF()

	IncProc()

	dDtCred := DataValida( ((cAliasC)->E5_DTDISPO - 1), .f. )

	If dDtCred >= MV_PAR01 .and. dDtCred <= MV_PAR02

		RecLock(cTabTmp,.t.)
		(cTabTmp)->NOMCLI	:= (cAliasC)->E5_DOCUMEN
		(cTabTmp)->DATABX 	:= dDtCred
		(cTabTmp)->DATADS 	:= dDtCred
		(cTabTmp)->VALREC 	:= (cAliasC)->E5_VALOR
		(cTabTmp)->MOTBX 	:= (cAliasC)->E5_MOTBX
		(cTabTmp)->LOTE 	:= (cAliasC)->E5_LOTE
		(cTabTmp)->BANCO 	:= (cAliasC)->E5_BANCO
		(cTabTmp)->HIST 	:= (cAliasC)->E5_HISTOR
		(cTabTmp)->DOCUME 	:= (cAliasC)->E5_DOCUMEN
		(cTabTmp)->ARQCNAB	:= (cAliasC)->E5_ARQCNAB

		aTotRec[3,2] += (cAliasC)->E5_VALOR
		(cTabTmp)->OBS := "Brasil cnab"

		aResRec[1,2] += (cAliasC)->E5_VALOR // Geral

		MsUnLock()	
	
	EndIf

	dbSelectArea(cAliasC)
	dbSkip()

EndDo

dbSelectArea(cAliasC)
dbCloseArea() 

Return

//#######################################################################################################