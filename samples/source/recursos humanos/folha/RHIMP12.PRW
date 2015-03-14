#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบFuncao    ณRHIMP12          บAutor  ณLeandro Drumond     บ Data ณ 27/10/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao da Folha dos  funcionarios  บฑฑ
ฑฑบ          ณTabela SRD e SR7                                                  บฑฑ
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
User Function RHIMP12(fName)
Local aFuncImp		:= {}
Local aPDImp		:= {}
Local aCpoSRD		:= {}
Local aCpoSRC		:= {}
Local cDatarq		:= ""
Local cBuffer       := ""
Local cEmpAux   	:= ""
Local cFilAux    	:= ""
Local cDescErro		:= ""
Local cEmpSMO		:= ""
Local cFilSMO		:= ""
Local cMatImp		:= ""
Local cVerbImp		:= ""
Local cEmpOri    	:= "##"
Local cFilOri		:= "##"
Local lIncluiu 		:= .F.
Local nSeqSRC		:= 0
Local nCount        := 0
Local nLidos        := 0
Local nX			:= 0

PRIVATE aErro :={}
Private lPicFormat  := 	(Upper(GetSrvProfString("PictFormat", "DEFAULT")) == "DEFAULT")

nCount := U_RIM01Line(fName)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Numero de registros a importar                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ProcRegua(nCount)

FT_FUSE(fName)
FT_FGOTOP()

/*Ordem dos campos no array que sera montado com base na linha do TXT
01 - * - Empresa Protheus
02 - RD_FILIAL 	- Filial Protheus
03 - RD_MAT 	- Matrํcula
04 - RD_PD 		- Verba
05 - RD_DATARQ 	- Data de Refer๊ncia
06 - RD_CC 		- Centro de Custo
07 - RD_TIPO1 	- Tipo da Verba
08 - RD_HORAS 	- Quantidade
09 - RD_VALOR 	- Valor
10 - RD_DATPGT 	- Data de Pagamento
11 - RD_DEPTO 	- Departamento
12 - RD_ITEM    - Item Contabil
13 - RD_INSS 	- Incid๊ncia de INSS
14 - RD_IR 		- Incid๊ncia de IR
15 - RD_FGTS 	- Incid๊ncia de FGTS
16 - RD_TIPO2 	- Tipo de Processamento
*/

While !FT_FEOF()
	cBuffer := FT_FREADLN()

	aLinha := {}
	aLinha := Separa(cBuffer,"|") //Distribui os itens no array

	cEmpAux   := aLinha[1]

	cFilAux   := aLinha[2]

	If Empty(cFilAux)
		cFilAux := "  "
	EndIf

	If !Empty(cDatarq) .and. cDatarq <> aLinha[5]
		fCloseSRC(cDatarq)
		cDatarq := ""
	EndIf

	If cEmpAux <> cEmpOri .or. cFilAux <> cFilOri
		If !Empty(cDatarq) .and. cEmpAux <> cEmpOri //Se mudar a empresa, fecha SRC
			fCloseSRC(cDatarq)
			cDatarq := ""
		EndIf

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
			CHKFILE("SRD")
			CHKFILE("SRC")
			CHKFILE("SRA")
			CHKFILE("SRV")

			fDelMov('SRC')	//Exclui todos os registros tipo C e A (RC_TIPO2) da SRD
			fDelMov('SRD')  //Exclui todos os registros tipo C e A (RD_TIPO2) da SRD
		Else
			lIncluiu := .F.
		EndIf
	EndIf

	If lExiste == .T.

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Incrementa a regua                                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nLidos += 1
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

		SRV->(DbSetOrder(1))

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
			nSeqSRC := fFindSeqSRC(cFilAux,cVerbImp,cMatImp)

			cDatarq  := aLinha[5]
			aCpoSRD  := {}
			aCpoSRC	 := {}

			aAdd(aCpoSRD,{'RD_FILIAL',xFilial('SRD'),NIL})
			aAdd(aCpoSRC,{'RC_FILIAL',xFilial('SRC'),NIL})

			aAdd(aCpoSRD,{'RD_MAT',cMatImp,NIL})
			aAdd(aCpoSRC,{'RC_MAT',cMatImp,NIL})

			aAdd(aCpoSRD,{'RD_PD',aLinha[4],NIL})
			aAdd(aCpoSRC,{'RC_PD',aLinha[4],NIL})

			aAdd(aCpoSRD,{'RD_DATARQ',aLinha[5],NIL})

			aAdd(aCpoSRD,{'RD_MES',SubStr(aLinha[5],5,2),NIL})

			aAdd(aCpoSRD,{'RD_CC',aLinha[6],NIL})
			aAdd(aCpoSRC,{'RC_CC',aLinha[6],NIL})

			aAdd(aCpoSRD,{'RD_TIPO1',aLinha[7],NIL})
			aAdd(aCpoSRC,{'RC_TIPO1',aLinha[7],NIL})

			aAdd(aCpoSRD,{'RD_HORAS',Val(aLinha[8]),NIL})
			aAdd(aCpoSRC,{'RC_HORAS',Val(aLinha[8]),NIL})

			aAdd(aCpoSRD,{'RD_VALOR',If(lPicFormat,Val(STRTRAN(aLinha[9],',','.')),Val(STRTRAN(aLinha[9],'.',','))),NIL})
			aAdd(aCpoSRC,{'RC_VALOR',If(lPicFormat,Val(STRTRAN(aLinha[9],',','.')),Val(STRTRAN(aLinha[9],'.',','))),NIL})

			aAdd(aCpoSRD,{'RD_DATPGT',CtoD(aLinha[10]),NIL})
			aAdd(aCpoSRC,{'RC_DATA',CtoD(aLinha[10]),NIL})

			aAdd(aCpoSRD,{'RD_DEPTO',aLinha[11],NIL})
			aAdd(aCpoSRC,{'RC_DEPTO',aLinha[11],NIL})

			aAdd(aCpoSRD,{'RD_ITEM',aLinha[12],NIL})
			aAdd(aCpoSRC,{'RC_ITEM',aLinha[12],NIL})

			aAdd(aCpoSRD,{'RD_INSS',aLinha[13],NIL})

			aAdd(aCpoSRD,{'RD_IR',aLinha[14],NIL})

			aAdd(aCpoSRD,{'RD_FGTS',aLinha[15],NIL})

			aAdd(aCpoSRD,{'RD_TIPO2',aLinha[16],NIL})
			aAdd(aCpoSRC,{'RC_TIPO2',aLinha[16],NIL})

			aAdd(aCpoSRD,{'RD_SEQ',AllTrim(STR(nSeqSRC)),NIL})
			aAdd(aCpoSRC,{'RC_SEQ',AllTrim(STR(nSeqSRC)),NIL})

			fGrvSrcSrd(aCpoSRC,aCpoSRD)
		EndIf

	EndIf

	MSUnLock()
	IncProc()

	FT_FSKIP()

	cEmpOri  := cEmpAux
	cFilOri  := cFilAux

EndDo

If !Empty(cDatarq)
	fCloseSRC(cDatarq)
EndIf

If !Empty(aFuncImp)
	aSort( aFuncImp ,,, { |x,y| x[1]+x[2]+X[3] < y[1]+Y[2]+Y[3] } )
	For nCount := 1 to Len(aFuncImp)
		cDescErro := "Folha de Pagamento: " + AllTrim(aFuncImp[nCount,1]) + '/' + AllTrim(aFuncImp[nCount,2]) + '/' + AllTrim(aFuncImp[nCount,3]) + " - Funcionแrio nใo encontrado. Registros da folha de pagamento nใo foram importados."
		//U_RIM01ERR(cDescErro)
		aAdd(aErro,cDescErro)
	Next nCount
EndIf

If !Empty(aPDImp)
	aSort( aPDImp ,,, { |x,y| x[1]+x[2]+X[3] < y[1]+Y[2]+Y[3] } )
	For nCount := 1 to Len(aPDImp)
		cDescErro := "Folha de Pagamento: " + AllTrim(aPDImp[nCount,1]) + '/' + AllTrim(aPDImp[nCount,2]) + '/' + AllTrim(aPDImp[nCount,3]) + " - Verba nใo cadastrada."
		//U_RIM01ERR(cDescErro)
		aAdd(aErro,cDescErro)
	Next nCount
ENDIF

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
ฑฑบFuncao    ณfGrvSrcSrdบAutor  ณLeandro Drumond     บ Data ณ  27/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava os dados nas tabelas SRC e SRD.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGrvSrcSrd(aCpoSRC,aCpoSRD)
Local nX := 0

Begin Transaction

	DbSelectArea("SRC")

	RecLock('SRC',.T.)

	For nX := 1 to Len(aCpoSRC)
		&(aCpoSRC[nX,1]) := aCpoSRC[nX,2]
	Next nX

	MsUnLock()

	DbSelectArea("SRD")

	RecLock('SRD',.T.)

	For nX := 1 to Len(aCpoSRD)
		&(aCpoSRD[nX,1]) := aCpoSRD[nX,2]
	Next nX

	MsUnLock()

End Transaction

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfDelMov   บAutor  ณLeandro Drumond     บ Data ณ  27/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณApaga os dados da SRD e SRC.                                บฑฑ
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
	cQuery += " WHERE RD_TIPO2 IN ('C','A')"
EndIf

TcSqlExec( cQuery )

TcRefresh( InitSqlName(cAlias) )

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfCloseSRC บAutor  ณLeandro Drumond     บ Data ณ  28/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณApaga os dados da SRC.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCloseSRC(cDataRef)
Local aArea	   := GetArea()
Local cArqRC   := ''
Local cArqSrc  := ''
Local cPath	   := ''
Local cSx2Src  := ''

dbSelectArea("SX2")
dbSeek("SRC")
cPath   := TRIM(Sx2->X2_PATH)
cSx2Src := TRIM(SX2->X2_ARQUIVO)

cArqRc  := RetArq(__cRDD,cPath+"RC"+cEmpAnt+SubStr(cDataRef,3,4),.T.)

cArqSrc := RetArq(__cRDD,cPath+cSx2Src,.T.)

If MsFile(cArqRc) //Se ja existir arquivo de fechamento, deleta a tabela
	MsErase(cArqRc)
EndIf

MsRename(cArqSrc,cArqRc)	//Renomeia a tabela SRCEE0 para RCEEAAMM

DbSelectArea('SRC')
DbCloseArea()

If MsFile(cArqSRC)
	MsErase(cArqSrc) //Apaga a tabela SRC
EndIf

ChkFile("SRC") //Recria a tabela SRC

RestArea(aArea)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfFindSeqSRC บAutor  ณLeandro Drumond   บ Data ณ  05/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcura proxima sequencia na SRC                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fFindSeqSRC(cFilAux,cPdAux,cMatAux)
Local cAliasAux := "QTABAUX"
Local cWhere	:= ''
Local nRet 		:= 0

cWhere += "%"
cWhere += " SRC.RC_FILIAL = 		'" + cFilAux + "' "
cWhere += " AND SRC.RC_PD = 		'" + cPdAux    + "' "
cWhere += " AND SRC.RC_MAT = 	'" + cMatAux + "' "
cWhere += "%"

BeginSql alias cAliasAux
	SELECT MAX(RC_SEQ) SEQMAX
	FROM %table:SRC% SRC
 	    WHERE 		%exp:cWhere% AND
					SRC.%NotDel%
EndSql

If Val((cAliasAux)->SEQMAX) > 0
	nRet := Val((cAliasAux)->SEQMAX) + 1
Else
	nRet := 1
EndIf

(cAliasAux)->(DbCloseArea())

Return nRet