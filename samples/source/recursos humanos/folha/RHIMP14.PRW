#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบFuncao    ณRHIMP14          บAutor  ณLeandro Drumond     บ Data ณ 21/11/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao das rescisoes (Dados de     บฑฑ
ฑฑบ          ณrescisao e folha de rescisao )                                    บฑฑ
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
User Function RHIMP14(fName)
Local aGrvCpo		:= {}
Local aCampos		:= {}
Local aFuncImp		:= {}
Local aTpRescImp	:= {}
Local aPDImp		:= {}
Local aFuncNot		:= {}
Local cBuffer       := ""
Local cEmpAux   	:= ""
Local cFilAux    	:= ""
Local cEmpSMO		:= ""
Local cFilSMO		:= ""
Local cMatImp		:= ""
Local cTpRescImp	:= ""
Local cTipo			:= ""
Local cDescErro		:= ""
Local cEmpOri    	:= "##"
Local cFilOri		:= "##"
Local lIncluiu 		:= .F.
Local nCount        := 0
Local nX			:= 0
Local nSeqSRD		:= 0

PRIVATE aErro := {}
Private lPicFormat  := 	(Upper(GetSrvProfString("PictFormat", "DEFAULT")) == "DEFAULT")

/*Ordem dos campos no array que sera montado com base na linha do TXT rescisao_logix.unl
01 - Tipo = 1
02 - * - Empresa Protheus
03 - RG_FILIAL 	- Filial Protheus
04 - RG_MAT 	- Matrํcula
05 - RG_TIPORES	- Tipo de Rescisao
06 - RG_DATDEM 	- Data de Demissao
07 - RG_DATHOM	- Data de Homologacao
08 - RG_DTAVISO	- Data do Aviso Previo
09 - RG_DAVISO 	- Dias de Aviso Previo
10 - RG_NORMAL 	- Horas Normais de Trabalho
11 - RG_DESCANS - Horas de DSR
12 - RG_SALMES 	- Salario Mensal
13 - RG_SALHORA - Salario Hora
14 - RG_SALDIA 	- Salario Dia
15 - RG_TPAVISO	- Tipo Aviso de Demissao
16 - RG_DFERVEN	- Dias de Ferias Vencidas
17 - RG_DFERPRO	- Dias de Ferias Proporcionais

01 - Tipo = 2
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
			fGrvResc(aGrvCpo)
		EndIf
		aGrvCpo	 := Array(3,0)
		aFuncNot := {}

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
			CHKFILE("SRG")
			CHKFILE("SRD")
			CHKFILE("SRC")
			CHKFILE("SRX")
			CHKFILE("SRR")

			SRV->(DbSetOrder(1))

			fDelMov('SRR')	//Exclui todos os registros tipo R (RR_TIPO2) da SRR
			fDelMov('SRD')  //Exclui todos os registros tipo R (RD_TIPO2) da SRD
			fDelMov('SRG')	//Exclui todos os registros da SRG
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

		If cTipo == "1"
			cTpRescImp := aLinha[5]
			If !(SRX->(dbSeek( xFilial( "SRX" ) + "32" + cTpRescImp )))
				If !Empty(aTpRescImp)
					If aScan(aTpRescImp,  { |x|  X[1]+X[2]+X[3] == cEmpAux + cFilAux + aLinha[5] }) == 0
						aAdd(aTpRescImp, {cEmpAux,cFilAux,aLinha[5]})
					EndIf
				Else
					aAdd(aTpRescImp,{cEmpAux,cFilAux,aLinha[5]})
				EndIf
				aAdd(aFuncNot,{cFilAux,cMatImp})
				lIncluiu := .F.
			EndIf
		Else

			If !(aScan(aFuncNot,  { |x|  X[1]+X[2] == cFilAux + cMatImp }) == 0)
				lIncluiu := .F.
			Else

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
		EndIf

		If lIncluiu

			If cTipo == "1"
				aCampos := {}

				aAdd(aCampos,{'RG_FILIAL',xFilial('SRG'),'SRG'})
				aAdd(aCampos,{'RG_MAT',cMatImp,'SRG'})
				aAdd(aCampos,{'RG_TIPORES',cTpRescImp,'SRG'})
				aAdd(aCampos,{'RG_DATADEM',CtoD(aLinha[6]),'SRG'})
				aAdd(aCampos,{'RG_DATAHOM',CtoD(aLinha[7]),'SRG'})
				aAdd(aCampos,{'RG_DTGERAR',CtoD(aLinha[7]),'SRG'})
				aAdd(aCampos,{'RG_DTAVISO',CtoD(aLinha[8]),'SRG'})
				aAdd(aCampos,{'RG_DAVISO',If(lPicFormat,Val(STRTRAN(aLinha[9],',','.')),Val(STRTRAN(aLinha[9],'.',','))),'SRG'})
				aAdd(aCampos,{'RG_NORMAL',If(lPicFormat,Val(STRTRAN(aLinha[10],',','.')),Val(STRTRAN(aLinha[10],'.',','))),'SRG'})
				aAdd(aCampos,{'RG_DESCANS',If(lPicFormat,Val(STRTRAN(aLinha[11],',','.')),Val(STRTRAN(aLinha[11],'.',','))),'SRG'})
				aAdd(aCampos,{'RG_SALMES',If(lPicFormat,Val(STRTRAN(aLinha[12],',','.')),Val(STRTRAN(aLinha[12],'.',','))),'SRG'})
				aAdd(aCampos,{'RG_SALHORA',If(lPicFormat,Val(STRTRAN(aLinha[13],',','.')),Val(STRTRAN(aLinha[13],'.',','))),'SRG'})
				aAdd(aCampos,{'RG_SALDIA',If(lPicFormat,Val(STRTRAN(aLinha[14],',','.')),Val(STRTRAN(aLinha[14],'.',','))),'SRG'})
				aAdd(aCampos,{'RG_TPAVISO',aLinha[15],'SRG'})
				aAdd(aCampos,{'RG_DFERVEN',If(lPicFormat,Val(STRTRAN(aLinha[16],',','.')),Val(STRTRAN(aLinha[16],'.',','))),'SRG'})
				aAdd(aCampos,{'RG_DFERPRO',If(lPicFormat,Val(STRTRAN(aLinha[17],',','.')),Val(STRTRAN(aLinha[17],'.',','))),'SRG'})
				aAdd(aCampos,{'RG_MEDATU','S','SRG'})
				aAdd(aCampos,{'RG_EFETIVA','S','SRG'})

				aAdd(aGrvCpo[1] , aCampos)
			Else

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
				aAdd(aCampos,{'RR_TIPO2','R','SRR'})
				aAdd(aCampos,{'RR_TIPO3','R','SRR'})

				aAdd(aGrvCpo[2],aCampos)

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
				aAdd(aCampos,{'RD_TIPO2','R','SRD'})
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
	fGrvResc(aGrvCpo)
EndIf

If !Empty(aTpRescImp)
	aSort( aTpRescImp ,,, { |x,y| x[1]+x[2]+X[3] < y[1]+Y[2]+Y[3] } )
	For nCount := 1 to Len(aTpRescImp)
		cDescErro := "Rescisใo: " + AllTrim(aTpRescImp[nCount,1]) + '/' + AllTrim(aTpRescImp[nCount,2]) + '/' + AllTrim(aTpRescImp[nCount,3]) + " - Tipo de Rescisใo " + AllTrim(aTpRescImp[nCount,3]) + " nใo cadastrado no sistema Protheus. Deverแ incluir este c๓digo no parโmetro 32 - Tipos de Rescisใo.
		//U_RIM01ERR(cDescErro)
		aAdd(aErro,cDescErro)
	Next nCount
EndIf

If !Empty(aFuncImp)
	aSort( aFuncImp ,,, { |x,y| x[1]+x[2]+X[3] < y[1]+Y[2]+Y[3] } )
	For nCount := 1 to Len(aFuncImp)
		cDescErro := "Rescisใo: " + AllTrim(aFuncImp[nCount,1]) + '/' + AllTrim(aFuncImp[nCount,2]) + '/' + AllTrim(aFuncImp[nCount,3]) + " - Funcionแrio nใo encontrado. Registros da folha de pagamento nใo foram importados."
		//U_RIM01ERR(cDescErro)
		aAdd(aErro,cDescErro)
	Next nCount
EndIf

If !Empty(aPDImp)
	aSort( aPDImp ,,, { |x,y| x[1]+x[2]+X[3] < y[1]+Y[2]+Y[3] } )
	For nCount := 1 to Len(aPDImp)
		cDescErro := "Rescisใo: " + AllTrim(aPDImp[nCount,1]) + '/' + AllTrim(aPDImp[nCount,2]) + '/' + AllTrim(aPDImp[nCount,3]) + " - Verba nใo cadastrada."
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
ฑฑบFuncao    ณfGrvResc  บAutor  ณLeandro Drumond     บ Data ณ  21/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava os dados nas tabelas SRG, SRR e SRD.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGrvResc(aCampos)
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
				RecLock(cAlias,.T.)
				For nZ := 1 to Len(aCampos[nX,nY])
					&(aCampos[nX,nY,nZ,1]) := aCampos[nX,nY,nZ,2]
				Next nZ
				MsUnLock()
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
	cQuery += " WHERE RD_TIPO2 = 'R'"
EndIf
If cAlias == "SRR"
	cQuery += " WHERE RR_TIPO2 = 'R'"
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
