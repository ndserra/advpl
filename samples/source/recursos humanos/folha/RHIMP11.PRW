#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบFuncao    ณRHIMP11          บAutor  ณLeandro Drumond     บ Data ณ 20/10/2012 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao dos historico salarial dos  บฑฑ
ฑฑบ          ณfuncionarios. Tabelas SR3 e SR7                                   บฑฑ
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
User Function RHIMP11(fName)
Local aMotivos		:= {}
Local aFuncImp		:= {}
Local cBuffer       := ""
Local cEmpAux   	:= ""
Local cFilAux    	:= ""
Local cDescErro		:= ""
Local cEmpSMO		:= ""
Local cFilSMO		:= ""
Local cMatImp		:= ""
Local cTipoImp		:= ""
Local cEmpOri    	:= "##"
Local cFilOri		:= "##"
Local lIncluiu 		:= .F.
Local nCount        := 0
Local nLidos        := 0

PRIVATE aErro  := {}
Private lPicFormat  := 	(Upper(GetSrvProfString("PictFormat", "DEFAULT")) == "DEFAULT")

nCount := U_RIM01Line(fName)

/*Ordem dos campos no array que sera montado com base na linha do TXT
01 - Empresa Protheus
02 - Filial Protheus
03 - Matrํcula
04 - Data de Alteracao salarial
05 - Sequencia de Alteracao
06 - Motivo de Reajuste
07 - Salario
08 - Cargo
09 - Descricao abreviada do Cargo
10 - Categoria
11 - Usuario
*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Numero de registros a importar                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ProcRegua(nCount)

FT_FUSE(fName)
FT_FGOTOP()

While !FT_FEOF()
	cBuffer := FT_FREADLN()

	aLinha := {}
	aLinha := Separa(cBuffer,"|")

	cEmpAux   := aLinha[1]

	cFilAux   := aLinha[2]

	If Empty(cFilAux)
		cFilAux := "  "
	EndIf

	If cEmpAux <> cEmpOri .OR. cFilAux <> cFilOri
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
				SM0->(dbSkip())
				Exit
			EndIf
			SM0->(dbSkip())
		EndDo

		If lExiste == .T.
			RpcSetType(3)
			PREPARE ENVIRONMENT EMPRESA (cEmpSMO) FILIAL (cFilSMO) MODULO "GPE" USER "ADMIN" FUNNAME "GPEA250"
			CHKFILE("SR3")
			CHKFILE("SRA")
			CHKFILE("SR7")
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

		cMatImp	 := aLinha[3]

		If !(SRA->(DbSeek(xFilial("SRA")+cMatImp)))
			If !Empty(aFuncImp)
				If aScan(aFuncImp,  { |x|  X[1]+X[2] == cFilAux + cMatImp }) == 0
					aAdd(aFuncImp, {cFilAux,cMatImp})
				EndIf
			Else
				aAdd(aFuncImp,{cFilAux,cMatImp})
			EndIf
			lIncluiu := .F.
		Else
			cTipoImp := aLinha[6] + Space(3-Len(aLinha[6]))

			dbSelectArea( "SX5" )
			If !(dbSeek( xFilial( "SX5" ) + "41" + cTipoImp ))
				If !Empty(aMotivos)
					If aScan(aMotivos,  { |x|  X == cTipoImp }) == 0
						aAdd(aMotivos, cTipoImp)
					EndIf
				Else
					aAdd(aMotivos, cTipoImp)
				EndIf
				lIncluiu := .F.
			EndIf

		EndIf

		If lIncluiu
			fGrvSr3Sr7(aLinha)
		EndIf

		MSUnLock()
	 IncProc()
	EndIf

	FT_FSKIP()

	cEmpOri  := cEmpAux
	cFilOri  := cFilAux

EndDo

If !Empty(aMotivos)
	aSort( aMotivos ,,, { |x,y| x < y } )
	For nCount := 1 to Len(aMotivos)
		cDescErro := "Hist๓rico Salarial: Registros com o Motivo " + aMotivos[nCount] + " nใo foram importados no sistema. Cadastrar o motivo no Configurador, tabela gen้rica SX5, tabela 41."
		//U_RIM01ERR(cDescErro)
		 aAdd(aErro,cDescErro)
	Next nCount
EndIf

If !Empty(aFuncImp)
	For nCount := 1 to Len(aFuncImp)
		cDescErro := "Hist๓rico Salarial: " + AllTrim(aFuncImp[nCount,1]) + '/' + AllTrim(aFuncImp[nCount,2]) + " - Funcionแrio nใo encontrado. Registros do hist๓rico nใo foram gerados."
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
ฑฑบfGrvSr3Sr7ณ          บAutor  ณLeandro Drumond     บ Data ณ  21/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava os dados nas tabelas SR3 e SR7.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGrvSr3Sr7(aLinha)

dDataImp := If(Empty(aLinha[4]),CtoD(''),Ctod(aLinha[4]))
cMatAux	 := aLinha[3] + Space(TAMSX3('R3_MAT')[1] - Len(aLinha[3]))
cTipoAux := aLinha[6] + Space(TAMSX3('R3_TIPO')[1] - Len(aLinha[6]))

Begin Transaction

	DbSelectArea("SR3")
	DbSetOrder(2)

	If DbSeek(xFilial('SR3')+cMatAux+DtoS(dDataImp)+aLinha[5]+cTipoAux+"000") //R3_FILIAL+R3_MAT+DTOS(R3_DATA)+R3_SEQ+R3_TIPO+R3_PD
		RecLock('SR3',.F.)
	Else
		RecLock('SR3',.T.)
	EndIf

	SR3->R3_FILIAL 	:= xFilial('SR3')
	SR3->R3_MAT		:= aLinha[3]
	SR3->R3_DATA	:= dDataImp
	SR3->R3_SEQ		:= aLinha[5]
	SR3->R3_TIPO	:= aLinha[6]
	SR3->R3_PD		:= '000'
	SR3->R3_DESCPD	:= "SALARIO BASE"
	SR3->R3_VALOR	:= If(lPicFormat,Val(STRTRAN(aLinha[7],',','.')),Val(STRTRAN(aLinha[7],'.',',')))

	MsUnLock()

	DbSelectArea("SR7")
	DbSetOrder(2)

	If DbSeek(xFilial('SR7')+cMatAux+DtoS(dDataImp)+aLinha[5]+aLinha[6])//R7_FILIAL+R7_MAT+DTOS(R7_DATA)+R7_SEQ+R7_TIPO
		RecLock('SR7',.F.)
	Else
		RecLock('SR7',.T.)
	EndIf

	SR7->R7_FILIAL	:= xFilial('SR7')
	SR7->R7_MAT		:= aLinha[3]
	SR7->R7_DATA	:= dDataImp
	SR7->R7_SEQ		:= aLinha[5]
	SR7->R7_TIPO	:= aLinha[6]
	SR7->R7_FUNCAO	:= aLinha[8]
	SR7->R7_DESCFUN	:= aLinha[9]
	SR7->R7_TIPOPGT	:= "M"
	SR7->R7_CATFUNC	:= aLinha[10]
	SR7->R7_CARGO	:= ""
	SR7->R7_DESCCAR	:= ""
	SR7->R7_USUARIO	:= aLinha[11]

	MsUnLock()

End Transaction

Return Nil