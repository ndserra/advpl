#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบFuncao    ณRHIMP16          บAutor  ณLeandro Drumond     บ Data ณ 22/12/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao dos dados de 13o Salario    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณIntegracao do Modulo de RH dos Sistemas Logix X Protheus.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณfName  - Nome do Arquivo 						                   	บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RHIMP16(fName)
Local aGrvCpo		:= {}
Local aCampos		:= {}
Local aFuncImp		:= {}
Local aPDImp		:= {}
Local cBuffer       := ""
Local cEmpAux   	:= ""
Local cFilAux    	:= ""
Local cEmpSMO		:= ""
Local cFilSMO		:= ""
Local cMatImp		:= ""
Local cDescErro		:= ""
Local cEmpOri    	:= "##"
Local cFilOri		:= "##"
Local lIncluiu 		:= .F.
Local nCount        := 0
Local nSeqSRD		:= 0

PRIVATE aErro := {}
Private lPicFormat  := 	(Upper(GetSrvProfString("PictFormat", "DEFAULT")) == "DEFAULT")

/*Ordem dos campos no array
01 - * - Empresa Protheus
02 - RD_FILIAL 	- Filial Protheus
03 - RD_MAT 	- Matrํcula
04 - RD_PD		- Verba
05 - RD_DATARQ	- Data de Referencia
06 - RD_CC		- Centro de Custos
07 - RD_TIPO1	- Tipo de Verba
08 - RD_HORAS 	- Quantidade Calculada
09 - RD_VALOR 	- Valor da Verba
10 - RD_DATPGT  - Data de Processamento
11 - RD_DEPTO   - Departamento
12 - RD_ITEM    - ITEM
13 - RD_INSS 	- Incidencia INSS
14 - RD_IR   	- Incidencia IR
15 - RD_FGTS	- Incidencia FGTS
16 - RD_TIPO2	- Tipo de Processamento
*/

nCount := U_RIM01Line(fName)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Numero de registros a importar                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ProcRegua(nCount)

FT_FUSE(fName)
FT_FGOTOP()

While !FT_FEOF()
	cBuffer := FT_FREADLN()

	aLinha := {}
	aLinha := Separa(cBuffer,"|") //Distribui os itens no array

	cEmpAux   := aLinha[1]

	cFilAux   := aLinha[2]

	If Empty(cFilAux)
		cFilAux := "  "
	EndIf

	If cEmpAux <> cEmpOri .or. cFilAux <> cFilOri

		lExiste:= .F.
		dbSelectArea("SM0")
		dbGoTop()

		RpcClearEnv()
		OpenSm0Excl()

		While ! Eof()
			cEmpSMO := SM0->M0_CODIGO
			cFilSMO := SM0->M0_CODFIL

			If cEmpSMO == cEmpAux .AND. (Empty(cFilAux) .OR. cFilAux == cFilSMO)
				lExiste = .T.
				Exit
			EndIf
			SM0->(dbSkip())
		EndDo

		If lExiste == .T.
			RpcSetType(3)
			PREPARE ENVIRONMENT EMPRESA (cEmpSMO) FILIAL (cFilSMO) MODULO "GPE" USER "ADMIN" FUNNAME "GPEA250"
			CHKFILE("SRA")
			CHKFILE("SRV")
			CHKFILE("SRD")

			SRV->(DbSetOrder(1))

			fDelMov('SRD')  //Exclui todos os registros tipo R (RD_TIPO2) da SRD
		Else
			lIncluiu := .F.
		EndIf
	EndIf

	If lExiste == .T.

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Incrementa a regua                                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lIncluiu := .T.

		cMatImp	 := aLinha[3] + Space(TAMSX3('RA_MAT')[1]-Len(aLinha[3]))

		If !(SRA->(DbSeek(xFilial("SRA")+cMatImp)))
			If !Empty(aFuncImp)
				If aScan(aFuncImp,  { |x|  X[1]+X[2]+X[3] == cEmpAux + cFilAux + cMatImp }) == 0
					aAdd(aFuncImp, {cEmpAux,cFilAux,cMatImp})
				EndIf
			Else
				aAdd(aFuncImp,{cEmpAux,cFilAux,cMatImp})
			EndIf
			lIncluiu := .F.
		EndIf

		cVerbImp := aLinha[4] + Space(3-Len(aLinha[4]))

		If !SRV->(DbSeek(xFilial("SRV")+cVerbImp))
			If !Empty(aPDImp)
				If aScan(aPDImp,  { |x|  X[1]+X[2]+X[3] == cEmpAux + cFilAux + aLinha[4] }) == 0
					aAdd(aPDImp, {cEmpAux,cFilAux,aLinha[4]})
				EndIf
			Else
				aAdd(aPDImp,{cEmpAux,cFilAux,aLinha[4]})
			EndIf
			lIncluiu := .F.
		EndIf

		If lIncluiu
			nSeqSRD := fFindSeqSRD(cFilAux,cVerbImp,cMatImp,aLinha[5])
           aCampos := {}

			aAdd(aCampos,{'RD_FILIAL',xFilial('SRD'),'SRD'})
			aAdd(aCampos,{'RD_MAT',cMatImp,'SRD'})
			aAdd(aCampos,{'RD_PD',cVerbImp,'SRD'})
			aAdd(aCampos,{'RD_DATARQ',aLinha[5],'SRD'})
			aAdd(aCampos,{'RD_MES',SubStr(aLinha[5],5,2),'SRD'})
			aAdd(aCampos,{'RD_CC',aLinha[6],'SRD'})
			aAdd(aCampos,{'RD_TIPO1',aLinha[7],'SRD'})
			aAdd(aCampos,{'RD_HORAS',If(lPicFormat,Val(STRTRAN(aLinha[8],',','.')),Val(STRTRAN(aLinha[8],'.',','))),'SRD'})
			aAdd(aCampos,{'RD_VALOR',If(lPicFormat,Val(STRTRAN(aLinha[9],',','.')),Val(STRTRAN(aLinha[9],'.',','))),'SRD'})
			aAdd(aCampos,{'RD_DATPGT',CtoD(aLinha[10]),'SRD'})
			aAdd(aCampos,{'RD_DTREF',CtoD(aLinha[10]),'SRD'})
			aAdd(aCampos,{'RD_DEPTO',aLinha[11],'SRD'})
			aAdd(aCampos,{'RD_ITEM',aLinha[12],'SRD'})
			aAdd(aCampos,{'RD_INSS',aLinha[13],'SRD'})
			aAdd(aCampos,{'RD_IR',aLinha[14],'SRD'})
			aAdd(aCampos,{'RD_FGTS',aLinha[15],'SRD'})
			aAdd(aCampos,{'RD_TIPO2',aLinha[16],'SRD'})
           aAdd(aCampos,{'RD_SEQ',AllTrim(STR(nSeqSRD)),NIL})
			fGrvSRD(aCampos)

		EndIf

	EndIf

	IncProc()

	FT_FSKIP()

	cEmpOri  := cEmpAux
	cFilOri  := cFilAux

EndDo

If !Empty(aFuncImp)
	aSort( aFuncImp ,,, { |x,y| x[1]+x[2]+X[3] < y[1]+Y[2]+Y[3] } )
	For nCount := 1 to Len(aFuncImp)
		cDescErro := "13บ Salแrio: " + AllTrim(aFuncImp[nCount,1]) + '/' + AllTrim(aFuncImp[nCount,2]) + '/' + AllTrim(aFuncImp[nCount,3]) + " - Funcionแrio nใo encontrado. Registros de 13บ salแrio nใo foram importados."
		//U_RIM01ERR(cDescErro)
		aAdd(aErro,cDescErro)
	Next nCount
EndIf

If !Empty(aPDImp)
	aSort( aPDImp ,,, { |x,y| x[1]+x[2]+X[3] < y[1]+Y[2]+Y[3] } )
	For nCount := 1 to Len(aPDImp)
		cDescErro := "13บ Salแrio: " + AllTrim(aPDImp[nCount,1]) + '/' + AllTrim(aPDImp[nCount,2]) + '/' + AllTrim(aPDImp[nCount,3]) + " - Verba nใo cadastrada. Os registros que possuem esta verba nใo serใo importados"
		//U_RIM01ERR(cDescErro)
		aAdd(aErro,cDescErro)
	Next nCount
EndIf
U_RIM01ERA(aErro)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Libera o arquivo                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FT_FUSE()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfGrvSRD   บAutor  ณLeandro Drumond     บ Data ณ  22/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava os dados na tabela SRD.      			              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGrvSRD(aCampos)
Local cAlias	:= ''
Local nX 		:= 0

Begin Transaction

	cAlias := aCampos[1,3]
	DbSelectArea(cAlias)

	RecLock(cAlias,.T.)

	For nX := 1 to Len(aCampos)
		&(aCampos[nX,1]) := aCampos[nX,2]
	Next nX

	MsUnLock()

End Transaction

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfDelMov   บAutor  ณLeandro Drumond     บ Data ณ  22/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณApaga os dados da SRD.			                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDelMov(cAlias)
Local cQuery := ''

cQuery := " DELETE FROM " + InitSqlName(cAlias) + " "
If cAlias == "SRD"
	cQuery += " WHERE RD_TIPO2 IN ('S','P')"
EndIf

TcSqlExec( cQuery )

TcRefresh( InitSqlName(cAlias) )

Return Nil


Static Function fFindSeqSRD(cFilAux,cPdAux,cMatAux, cDtArqAx)
Local cAliasAux := "QTABAUX"
Local cWhere	:= ''
Local nRet 		:= 0

cWhere += "%"
cWhere += " SRD.RD_FILIAL     = 	'" + cFilAux    + "' "
cWhere += " AND SRD.RD_PD     = 	'" + cPdAux     + "' "
cWhere += " AND SRD.RD_MAT    = 	'" + cMatAux    + "' "
cWhere += " AND SRD.RD_DATARQ = 	'" + cDtArqAx   + "' "
cWhere += "%"

BeginSql alias cAliasAux
	SELECT MAX(RD_SEQ) SEQMAX
	FROM %table:SRD% SRD
 	    WHERE 		%exp:cWhere% AND
					SRD.%NotDel%
EndSql

If Val((cAliasAux)->SEQMAX) > 0
	nRet := Val((cAliasAux)->SEQMAX) + 1
Else
	nRet := 1
EndIf

(cAliasAux)->(DbCloseArea())

Return nRet
