#include "fileio.ch"
#Include "protheus.ch"
#Include "folder.ch"
#Include "tbiconn.ch"
#Include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบMetodo    ณRHIMP10Afast     บAutor  ณJosias de Afelis    บ Data ณ 04/03/2010 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao dos afastamentos para a     บฑฑ
ฑฑบ          ณTabela SR8.                                                       บฑฑ
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
User Function RHIMP10Afast(fName)
Local aCampos       := {}
Local aItens        := {}
Local aFuncAux		:= {}
Local cBuffer       := ""
Local cEmpArq   	:= ""
Local cFilArq    	:= ""
Local cEmpAux     	:= ""
Local cFilAux       := ""
Local cR8_mat	    := ""
Local cR8_tipoAfa   := ""
Local cDescErro		:= ""
Local cR8_DIASEMP   := ""
Local cR8_DPAGAR    := ""
Local cR8_CONTINU   := ""
Local cR8_data      := CtoD(' / / ')
Local cR8_dataIni   := CtoD(' / / ')
Local cR8_dataFim   := CtoD(' / / ')
Local lExiste       := .F.
Local lIncluiu 	 	:= .F.
Local nPosIni       := 0
Local nPosFim       := 0
Local nPosFimFilial := 0
Local nCount        := 0
Local nlidos        := 0

Local cR8_DURACAO   := 0
Local cR8_SDPAGAR   := ""
Local nPosCidi      := 0
Local nPosCidf      := 0
Local lErroAuto 		:= .F.

Private  lMsErroAuto   := .F.
PRIVATE aErro := {}
PRIVATE lAutoErrNoFile := .T.


nCount := U_RIM01Line(fName)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Numero de registros a importar                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ProcRegua(nCount)

cEmpOrigem := '00'
cFilOrigem := '00'

FT_FUSE(fName)
FT_FGOTOP()

aCampos := {}
aItens := {}

While !FT_FEOF()
	cBuffer := FT_FREADLN()

	nPosFimFilial := At("|", cBuffer)
	cEmpArq      := Substr(cBuffer, 1, nPosFimFilial - 1)

	nPosIni := nPosFimFilial
	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	nPosFim := At("|", cBuffer)

	cFilArq := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

	If Empty(cFilArq)
		cFilArq := "  "
	EndIf

	If cEmpArq <> cEmpOrigem .OR. cFilArq <> cFilOrigem
		If lIncluiu .and. !Empty(aItens)
			Begin Transaction
			 lMsErroAuto := .F.
				DBSelectArea("SR8")
				MSExecAuto({|x,y,w,z| GPEA240(x,y,w,z)},Nil,aCampos, aItens,3)
				If lMsErroAuto
					DisarmTransaction()
    				aLog := GetAutoGrLog()
                    Aeval(aLog, { |x| aAdd(aErro, x)  } )
					//MostraErro()
					break
				EndIf
			End Transaction
			lIncluiu := .F.
			aItens := {}
		EndIf

		lExiste:= .F.
		dbSelectArea("SM0")
		dbGoTop()

		RpcClearEnv()
		OpenSm0Excl()
		While ! Eof()
			cEmpAux:= SM0->M0_CODIGO
			cFilAux := SM0->M0_CODFIL

			IF cEmpAux == cEmpArq .AND. (Empty(cFilArq) .OR. cFilArq == cFilAux)
				lExiste:= .T.
				SM0->(dbSkip())
				EXIT
			EndIf
			SM0->(dbSkip())
		EndDo

		If lExiste
			RpcSetType(3)
			PREPARE ENVIRONMENT EMPRESA (cEmpAux) FILIAL (cFilAux) MODULO "GPE" USER "ADMIN" FUNNAME "GPEA240"
			CHKFILE("SRA")
			CHKFILE("SA1")
			CHKFILE("SR8")
			CHKFILE("TMR")
			CHKFILE("SRG")
			If cEmpArq <> cEmpOrigem
				//EXCLUSAO DE TODOS OS REGISTROS PARA REALIZAR A IMPORTACAO
				DbSelectArea("SR8")
				DbSetOrder(1)
				Dbgotop()
				While !EOF()
					RecLock("SR8",.F.,.T.)
					dbDelete()
					MsUnlOCK()
					dbSkip()
				EndDo
			EndIf
		Else
			lIncluiu := .F.
		EndIf
	EndIf


	If lExiste

		nlidos += 1

		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)

		If lIncluiu .and. !Empty(cR8_Mat) .and. !(cR8_Mat == Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))  .and. !Empty(aItens)
			Begin Transaction
			 lMsErroAuto := .F.
				DBSelectArea("SR8")
				MSExecAuto({|x,y,w,z| GPEA240(x,y,w,z)},Nil,aCampos, aItens,3)
				If lMsErroAuto
					DisarmTransaction()
					//MostraErro()
						aLog := GetAutoGrLog()
                        Aeval(aLog, { |x| aAdd(aErro, x)  } )
					 break
				EndIf
			End Transaction
			aItens := {}
		EndIf

		lIncluiu := .T.
		aCampos := {}

		cR8_mat  := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

		If !(SRA->(DbSeek(xFilial("SRA")+cR8_mat)))
			If !Empty(aFuncAux)
				If aScan(aFuncAux,  { |x|  X[2]+X[3] == cFilAux + cR8_Mat }) == 0
					aAdd(aFuncAux, {cEmpAux,cFilAux,cR8_Mat})
				EndIf
			Else
				aAdd(aFuncAux,{cEmpAux,cFilAux,cR8_Mat})
			EndIf
		Else
		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)

		cR8_data  := CtoD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

		IF 1 == nPosFimFilial
			aAdd(aCampos,{'R8_FILIAL','',NIL})
		Else
			aAdd(aCampos,{'R8_FILIAL',cFilArq,NIL})
		EndIf

		If Empty(cR8_mat)
			aAdd(aCampos,{'R8_MAT',CriaVar("R8_MAT"),NIL})
		Else
			aAdd(aCampos,{'R8_MAT',cR8_mat,NIL})
		EndIf

		If Empty(cR8_dataIni)
			aAdd(aCampos,{'R8_DATA',CriaVar("R8_DATA"),NIL})
		Else
			aAdd(aCampos,{'R8_DATA',cR8_data,NIL})
		EndIf

		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)


			If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'R8_TIPO',CriaVar("R8_TIPOAFA"),NIL})   //Motivo de Afastamento
		Else
			aAdd(aCampos,{'R8_TIPO',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
		EndIf

		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)

		If (nPosIni + 1) == nPosFim
			Add(aCampos,{'R8_DATAINI',CriaVar("R8_DATAINI"),NIL})
		Else
			cR8_dataIni := CtoD(Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1)))
			aAdd(aCampos,{'R8_DATAINI',cR8_dataIni,NIL})
		EndIf

		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)

		If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'R8_DATAFIM',CriaVar("R8_DATAFIM"),NIL})
		Else
			cR8_dataFim := CtoD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
			aAdd(aCampos,{'R8_DATAFIM',cR8_dataFim,NIL})
		EndIf

		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)

		nPosCidi := nPosIni
		nPosCidf := nPosFim

		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)

		If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'R8_SEQ',CriaVar("R8_SEQ"),NIL})
		Else
			aAdd(aCampos,{'R8_SEQ',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
		EndIf

		If (nPosCidi + 1) <> nPosCidf
			aAdd(aCampos,{'R8_CID',Substr(cBuffer, nPosCidi + 1, nPosCidf - (nPosCidi + 1)),NIL})
		EndIf

		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)

		cR8_CONTINU  := CriaVar("R8_CONTINU")
		If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'R8_CONTAFA',CriaVar("R8_CONTAFA"),NIL})
		Else
			cR8_CONTINU := 1
			aAdd(aCampos,{'R8_CONTINU',cR8_CONTINU,NIL})

			aAdd(aCampos,{'R8_CONTAFA',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
		EndIf

		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)

		If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'R8_DIASEMP',CriaVar("R8_DIASEMP"),NIL})
		Else
			aAdd(aCampos,{'R8_DIASEMP',Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
		EndIf

		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)

		If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'R8_DPAGAR',CriaVar("R8_DPAGAR"),NIL})
		Else
			aAdd(aCampos,{'R8_DPAGAR',Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
		EndIf

		cR8_DURACAO  := (cR8_dataFim - cR8_dataIni) + 1 // 0 //val(CriaVar("R8_DURACAO"))
		cR8_SDPAGAR  := CriaVar("R8_SDPAGAR")

		aAdd(aCampos,{'R8_DURACAO',cR8_DURACAO,NIL})
		aAdd(aCampos,{'R8_SDPAGAR',cR8_SDPAGAR,NIL})
		EndIf

		MSUnLock()
	 IncProc()
	EndIf

	If !Empty(aCampos)
		aAdd(aItens, aCampos)
	EndIf

	cEmpOrigem := cEmpArq
	cFilOrigem := cFilArq

	FT_FSKIP()

EndDo

If lIncluiu .and. !Empty(aItens)
	Begin Transaction
	 lMsErroAuto := .F.
		DBSelectArea("SR8")
		MSExecAuto({|x,y,w,z| GPEA240(x,y,w,z)},Nil,aCampos, aItens,3)

		If lMsErroAuto
       	    DisarmTransaction()
      		aLog := GetAutoGrLog()
        Aeval(aLog, { |x| aAdd(aErro, x)  } )
    ENDIF
	End Transaction
ENDIF

If !Empty(aFuncAux)
	For nCount := 1 to Len(aFuncAux)
		cDescErro := "Funcionแrio " + AllTrim(aFuncAux[nCount,1])+'/'+AllTrim(aFuncAux[nCount,2])+'/'+AllTrim(aFuncAux[nCount,3]) + " - Nใo encontrado. Afastamento nใo serแ importado."
		//U_RIM01ERR(cDescErro)
		aAdd(aErro,cDescErro)
	Next nCount
ENDIF

U_RIM01ERA(aErro)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Libera o arquivo                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FT_FUSE()

Return
                                                                                                                                     