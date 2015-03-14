#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบFuncao    ณRHIMP15          บAutor  ณLeandro Drumond     บ Data ณ 08/12/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao dos dados de Ferias         บฑฑ
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
User Function RHIMP15(fName)
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
Local cTipo			:= ""
Local cDescErro		:= ""
Local cEmpOri    	:= "##"
Local cFilOri		:= "##"
Local lIncluiu 		:= .F.
Local nCount        := 0

PRIVATE aErro := {}
Private lPicFormat  := 	(Upper(GetSrvProfString("PictFormat", "DEFAULT")) == "DEFAULT")

/*Ordem dos campos no array que sera montado com base na linha do TXT ferias_logix.unl
01 - IDENTIFICADOR = 1 (Cabecalho)
02 - * - Empresa Protheus
03 - RH_FILIAL 	- Filial Protheus
04 - RH_MAT 	- Matrํcula
05 - RH_DATABAS	- Inicio do Periodo Aquisitivo
06 - RH_DBASEAT	- Fim do Periodo Aquisitivo
07 - RH_DFALTAS	- Dias de Falta
08 - RH_DFERIAS	- Dias de Gozo
09 - RH_DABONPE	- Dias de Abono
10 - RH_DATAINI	- Data Inicio de Gozo
11 - RH_DATAFIM - Data Final de Gozo
12 - RH_TIPCAL 	- Tipo do cแlculo de ferias
13 - RH_PERC13S - Percentual Adiantamento de 13o Salario
14 - RH_DIALREM	- Dias de Licenca Remunerada - 1o Mes
15 - RH_DIALRE1	- Dias de Licenca Remunerada - 2o Mes
16 - RH_SALMES	- Salario Mes
17 - RH_SALDIA	- Salario Dia
18 - RH_SALHRS	- Salario Hora
19 - RH_DTRECIB - Data do Recibo de Ferias
20 - RH_DTAVISO - Data do Aviso de Ferias

01 - IDENTIFICADOR = 2 (Itens)
02 - * - Empresa Protheus
03 - RD_FILIAL 	- Filial Protheus
04 - RD_MAT 	- Matrํcula
05 - RD_PD		- Verba
06 - RD_DATARQ	- Data de Referencia
07 - RD_CC		- Centro de Custos
08 - RD_TIPO1	- Tipo de Verba
09 - RD_HORAS 	- Quantidade Calculada
10 - RD_VALOR 	- Valor da Verba
11 - RD_DATPGT  - Data de Processamento
12 - RR_DATAPAG	- Data de Pagamento
13 - RD_DEPTO   - Departamento
14 - RD_ITEM    - ITEM
15 - RD_INSS 	- Incidencia INSS
16 - RD_IR   	- Incidencia IR
17 - RD_FGTS	- Incidencia FGTS
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

	cTipo	  := aLinha[1]

	cEmpAux   := aLinha[2]

	cFilAux   := aLinha[3]

	If Empty(cFilAux)
		cFilAux := "  "
	EndIf

	If cEmpAux <> cEmpOri .or. cFilAux <> cFilOri

		If cEmpAux <> cEmpOri .and. !Empty(aGrvCpo)
			fGrvFer(aGrvCpo)
		EndIf
		aGrvCpo	 := Array(3,0)

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
			CHKFILE("SRR")
			CHKFILE("SRH")
			CHKFILE("SRD")
			CHKFILE("SR8")

			SRV->(DbSetOrder(1))

			fDelMov('SRR')	//Exclui todos os registros tipo R (RR_TIPO2) da SRR
			fDelMov('SRD')  //Exclui todos os registros tipo R (RD_TIPO2) da SRD
			fDelMov('SRH')	//Exclui todos os registros da SRG
		Else
			lIncluiu := .F.
		EndIf
	EndIf

	If lExiste == .T.

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Incrementa a regua                                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lIncluiu := .T.

		cMatImp	 := aLinha[4] + Space(TAMSX3('RA_MAT')[1]-Len(aLinha[4]))

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

		If cTipo == "2"

			cVerbImp := aLinha[5] + Space(3-Len(aLinha[5]))

			If !SRV->(DbSeek(xFilial("SRV")+cVerbImp))
				If !Empty(aPDImp)
					If aScan(aPDImp,  { |x|  X[1]+X[2]+X[3] == cEmpAux + cFilAux + aLinha[5] }) == 0
						aAdd(aPDImp, {cEmpAux,cFilAux,aLinha[5]})
					EndIf
				Else
					aAdd(aPDImp,{cEmpAux,cFilAux,aLinha[5]})
				EndIf
				lIncluiu := .F.
			EndIf
		EndIf

		If lIncluiu

			If cTipo == "1"
				aCampos := {}

				aAdd(aCampos,{'RH_FILIAL',xFilial('SRH'),'SRH'})
				aAdd(aCampos,{'RH_MAT',cMatImp,'SRH'})
				aAdd(aCampos,{'RH_DATABAS',CtoD(aLinha[5]),'SRH'})
				aAdd(aCampos,{'RH_DBASEAT',CtoD(aLinha[6]),'SRH'})
				aAdd(aCampos,{'RH_DFALTAS',If(lPicFormat,Val(STRTRAN(aLinha[7],',','.')),Val(STRTRAN(aLinha[7],'.',','))),'SRH'})
				aAdd(aCampos,{'RH_DFERIAS',If(lPicFormat,Val(STRTRAN(aLinha[8],',','.')),Val(STRTRAN(aLinha[8],'.',','))),'SRH'})
				aAdd(aCampos,{'RH_DABONPE',If(lPicFormat,Val(STRTRAN(aLinha[9],',','.')),Val(STRTRAN(aLinha[9],'.',','))),'SRH'})
				aAdd(aCampos,{'RH_DATAINI',CtoD(aLinha[10]),'SRH'})
				aAdd(aCampos,{'RH_DATAFIM',CtoD(aLinha[11]),'SRH'})
				aAdd(aCampos,{'RH_TIPCAL',aLinha[12],'SRH'})
				aAdd(aCampos,{'RH_PERC13S',If(lPicFormat,Val(STRTRAN(aLinha[13],',','.')),Val(STRTRAN(aLinha[13],'.',','))),'SRH'})
				aAdd(aCampos,{'RH_DIALREM',If(lPicFormat,Val(STRTRAN(aLinha[14],',','.')),Val(STRTRAN(aLinha[14],'.',','))),'SRH'})
				aAdd(aCampos,{'RH_DIALRE1',If(lPicFormat,Val(STRTRAN(aLinha[15],',','.')),Val(STRTRAN(aLinha[15],'.',','))),'SRH'})
				aAdd(aCampos,{'RH_SALMES',If(lPicFormat,Val(STRTRAN(aLinha[16],',','.')),Val(STRTRAN(aLinha[16],'.',','))),'SRG'})
				aAdd(aCampos,{'RH_SALDIA',If(lPicFormat,Val(STRTRAN(aLinha[17],',','.')),Val(STRTRAN(aLinha[17],'.',','))),'SRH'})
				aAdd(aCampos,{'RH_SALHRS',If(lPicFormat,Val(STRTRAN(aLinha[18],',','.')),Val(STRTRAN(aLinha[18],'.',','))),'SRH'})
				aAdd(aCampos,{'RH_DFERVEN',0,'SRH'})
				aAdd(aCampos,{'RH_DTRECIB',CtoD(aLinha[19]),'SRH'})
				aAdd(aCampos,{'RH_DTAVISO',CtoD(aLinha[20]),'SRH'})

				aAdd(aCampos,{'RH_MEDATU','S','SRH'})

				aAdd(aGrvCpo[1] , aCampos)
			Else

				If !(cVerbImp == "M09")
					aCampos  := {}

					aAdd(aCampos,{'RR_FILIAL',xFilial('SRR'),'SRR'})
					aAdd(aCampos,{'RR_MAT',cMatImp,'SRR'})
					aAdd(aCampos,{'RR_PD',cVerbImp,'SRR'})
					aAdd(aCampos,{'RR_TIPO1',aLinha[8],'SRR'})
					aAdd(aCampos,{'RR_HORAS',If(lPicFormat,Val(STRTRAN(aLinha[9],',','.')),Val(STRTRAN(aLinha[9],'.',','))),'SRR'})
					aAdd(aCampos,{'RR_VALOR',If(lPicFormat,Val(STRTRAN(aLinha[10],',','.')),Val(STRTRAN(aLinha[10],'.',','))),'SRR'})
					aAdd(aCampos,{'RR_DATA',CtoD(aLinha[12]),'SRR'})
					aAdd(aCampos,{'RR_DATAPAG',CtoD(aLinha[11]),'SRR'})
					aAdd(aCampos,{'RR_CC',aLinha[7],'SRR'})
					aAdd(aCampos,{'RR_ITEM',aLinha[14],'SRR'})
					aAdd(aCampos,{'RR_TIPO2','K','SRR'})
					aAdd(aCampos,{'RR_TIPO3','F','SRR'})

					aAdd(aGrvCpo[2],aCampos)
				ENDIF

				nSeqSRD := fFindSeqSRD(cFilAux,cVerbImp,cMatImp,aLinha[6])

	            aCampos := {}

				aAdd(aCampos,{'RD_FILIAL',xFilial('SRD'),'SRD'})
				aAdd(aCampos,{'RD_MAT',cMatImp,'SRD'})
				aAdd(aCampos,{'RD_PD',cVerbImp,'SRD'})
				aAdd(aCampos,{'RD_DATARQ',aLinha[6],'SRD'})
				aAdd(aCampos,{'RD_MES',SubStr(aLinha[6],5,2),'SRD'})
				aAdd(aCampos,{'RD_CC',aLinha[7],'SRD'})
				aAdd(aCampos,{'RD_TIPO1',aLinha[8],'SRD'})
				aAdd(aCampos,{'RD_HORAS',If(lPicFormat,Val(STRTRAN(aLinha[9],',','.')),Val(STRTRAN(aLinha[9],'.',','))),'SRD'})
				aAdd(aCampos,{'RD_VALOR',If(lPicFormat,Val(STRTRAN(aLinha[10],',','.')),Val(STRTRAN(aLinha[10],'.',','))),'SRD'})
				aAdd(aCampos,{'RD_DATPGT',CtoD(aLinha[11]),'SRD'})
				aAdd(aCampos,{'RD_DTREF',CtoD(aLinha[12]),'SRD'})
				aAdd(aCampos,{'RD_DEPTO',aLinha[13],'SRD'})
				aAdd(aCampos,{'RD_ITEM',aLinha[14],'SRD'})
				aAdd(aCampos,{'RD_INSS',aLinha[15],'SRD'})
				aAdd(aCampos,{'RD_IR',aLinha[16],'SRD'})
				aAdd(aCampos,{'RD_FGTS',aLinha[17],'SRD'})
				aAdd(aCampos,{'RD_TIPO2','K','SRD'})
				aAdd(aCampos,{'RD_SEQ',AllTrim(STR(nSeqSRD)),NIL})

				aAdd(aGrvCpo[3],aCampos)
			EndIf

		EndIf

	EndIf

	MSUnLock()
	IncProc()
	FT_FSKIP()

	cEmpOri  := cEmpAux
	cFilOri  := cFilAux

EndDo

If !Empty(aGrvCpo)
	fGrvFer(aGrvCpo)
EndIf

If !Empty(aFuncImp)
	aSort( aFuncImp ,,, { |x,y| x[1]+x[2]+X[3] < y[1]+Y[2]+Y[3] } )
	For nCount := 1 to Len(aFuncImp)
		cDescErro := "F้rias: " + AllTrim(aFuncImp[nCount,1]) + '/' + AllTrim(aFuncImp[nCount,2]) + '/' + AllTrim(aFuncImp[nCount,3]) + " - Funcionแrio nใo encontrado. Registros de f้rias nใo foram importados."
		//U_RIM01ERR(cDescErro)
		aAdd(aErro,cDescErro)
	Next nCount
EndIf

If !Empty(aPDImp)
	aSort( aPDImp ,,, { |x,y| x[1]+x[2]+X[3] < y[1]+Y[2]+Y[3] } )
	For nCount := 1 to Len(aPDImp)
		cDescErro := "F้rias: " + AllTrim(aPDImp[nCount,1]) + '/' + AllTrim(aPDImp[nCount,2]) + '/' + AllTrim(aPDImp[nCount,3]) + " - Verba nใo cadastrada."
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
ฑฑบFuncao    ณfGrvFer   บAutor  ณLeandro Drumond     บ Data ณ  08/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava os dados nas tabelas SRH, SRR e SRD.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGrvFer(aCampos)
Local cAlias	:= ''
Local nX 		:= 0
Local nY		:= 0
Local nZ		:= 0

Begin Transaction

	For nX := 1 to Len(aCampos)
		If Len(aCampos[nX]) > 0
			cAlias := aCampos[nX,1,1,3]
			DbSelectArea(cAlias)

			For nY := 1 to Len(aCampos[nX])
				If cAlias == "SRR"
					DbSetOrder(RetOrdem(cAlias,"RR_FILIAL+RR_MAT+RR_TIPO3+DTOS(RR_DATA)+RR_PD+RR_CC"))
					If Dbseek(aCampos[nX,nY,1,2]+ aCampos[nX,nY,2,2]+aCampos[nX,nY,12,2]+DtoS(aCampos[nX,nY,7,2])+aCampos[nX,nY,3,2]+aCampos[nX,nY,9,2])
						RecLock(cAlias,.F.)
						RR_HORAS += aCampos[nX,nY,5,2]
						RR_VALOR += aCampos[nX,nY,6,2]
						MsUnLock()
						Loop
					EndIf
				EndIf
				RecLock(cAlias,.T.)
				For nZ := 1 to Len(aCampos[nX,nY])
					&(aCampos[nX,nY,nZ,1]) := aCampos[nX,nY,nZ,2]
				Next nZ
				MsUnLock()
				If cAlias == "SRH"
					SRA->(DbSeek(xFilial("SRA")+aCampos[nX,nY,2,2]))
					fGFerSR8(aCampos[nX,nY,8,2], aCampos[nX,nY,9,2])
				EndIf
			Next nY
		EndIf
	Next nX

End Transaction

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfDelMov   บAutor  ณLeandro Drumond     บ Data ณ  21/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณApaga os dados da SRG, SRR e SRD.                           บฑฑ
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
	cQuery += " WHERE RD_TIPO2 = 'K'"
EndIf
If cAlias == "SRR"
	cQuery += " WHERE RR_TIPO2 = 'K'"
EndIf

TcSqlExec( cQuery )

TcRefresh( InitSqlName(cAlias) )

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfDelMov   บAutor  ณEdna Dalfovo     บ Data ณ  08/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIncrementa a sequencia da tabela SRD.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
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
