#include "fileio.ch"
#Include "protheus.ch"
#Include "folder.ch"
#Include "tbiconn.ch"
#Include "topconn.ch"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Metodo    ≥RHIMP08Mat       ∫Autor  ≥Josias de Afelis    ∫ Data ≥ 09/03/2010 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Responsavel em Processar a Importacao dos funcionarios para a 	  ∫±±
±±∫          ≥Tabela SRA.                                                       ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥Integracao do Modulo de RH dos Sistemas Logix X Protheus.         ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Parametros≥fName - Nome do Arquivo 						                    	  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Retorno   ≥                                                                  ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function RHIMP08Mat(fName)
Local cBuffer       := ""
Local cEmpresaArq   := ""
Local cFilialArq    := ""
Local cRA_mat	    := ""
Local cEmpAux	    := ""
Local cFilAux       := ""
Local cDescErro	   	:= ""
Local cRAtpContr    := ""
Local cEmpOrigem    := '00'
Local cFilialOrigem := '00'
Local lIncluiu 	    := .F.
Local lExiste       := .F.
Local nPosIni       := 0
Local nPosFim       := 0
Local nPosFimFilial := 0
Local nCount        := 0
Local nlidos        := 0
Local aCampos       := {}
Local aRotina       := {}
Local dRAvctoExp2   := CtoD('  /  /    ')
Local dRAvctoExp    := CtoD('  /  /    ')
LOCAL lErroAuto 		  := .F.

PRIVATE aErro := {}
Private lMsErroAuto   := .F.
PRIVATE lAutoErrNoFile := .T.


	nCount := U_RIM01Line(fName)

    //⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
    //≥ Numero de registros a importar                                      ≥
    //¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
    ProcRegua(nCount)

    FT_FUSE(fName)
    FT_FGOTOP()

    AAdd(aRotina, {"Pesquisar"    , "PesqBrw",    0, 1, NIL, .F.})		//"Pesquisar"
   	AAdd(aRotina, {"Visualizar" , "Gpea010Vis", 0, 2})	 	   		//"Visualizar"
   	AAdd(aRotina, {"Incluir", "Gpea010Inc", 0, 3, 81})	//"Incluir"
   	AAdd(aRotina, {"Alterar", "Gpea010Alt", 0, 4, 82})	//"Alterar"
   	AAdd(aRotina, {"Excluir", "Gpea010Del", 0, 5, 3}) 	//"Excluir"
   	AAdd(aRotina, {"Legenda", "GpLegend",   0, 6,, .F.})		//"Legenda"
   	AAdd(aRotina, {"Conhecimento", "MsDocument", 0, 4})           //"Conhecimento"

    While !FT_FEOF()

    	 cBuffer := FT_FREADLN()

	     nPosFimFilial := At("|", cBuffer)
	cEmpresaArq      := Substr(cBuffer, 1, nPosFimFilial - 1)

    	 nPosIni := nPosFimFilial
    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
    	 nPosFim := At("|", cBuffer)

	cFilialArq := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
	If Empty(cFilialArq)
		cFilialArq := "  "
	EndIf

	IF (cEmpresaArq <> cEmpOrigem) .OR. (cFilialArq <> cFilialOrigem)
		lExiste:= .F.
		dbSelectArea("SM0")
		dbGoTop()

		RpcClearEnv()
		OpenSm0Excl()

		While ! Eof()
			cEmpAux := SM0->M0_CODIGO
			cFilAux := SM0->M0_CODFIL

			IF cEmpAux == cEmpresaArq .AND. (Empty(cFilialArq) .OR. cFilialArq == cFilAux)
				lExiste := .T.
				SM0->(dbSkip())
				EXIT
			EndIf
			SM0->(dbSkip())
		EndDo

		IF lExiste == .T.
			RpcSetType(3)
			PREPARE ENVIRONMENT EMPRESA (cEmpAux) FILIAL (cFilAux) MODULO "GPE" USER "ADMIN" FUNNAME "GPEA010"
			CHKFILE("SR9")
			CHKFILE("SRA")
			CHKFILE("SR3")
			CHKFILE("QAA")
			CHKFILE("SR7")
			CHKFILE("SQ3")
			CHKFILE("RB6")
			CHKFILE("ST1")
			CHKFILE("RD4")
			CHKFILE("RHK")
			CHKFILE("RDk")
			CHKFILE("SRC")
			CHKFILE("CTT")
			CHKFILE("CT0")
			CHKFILE("CTD")
			CHKFILE("CVJ")
			CHKFILE("CVA")
			CHKFILE("CT5")
			CHKFILE("CVG")
			CHKFILE("CW0")
			CHKFILE("CTK")
			CHKFILE("CT2")
			CHKFILE("AKI")
			CHKFILE("AKA")
			CHKFILE("SRF")
			CHKFILE("SPA")
			CHKFILE("SA6")
			CHKFILE("SR6")
			CHKFILE("RCE")
			CHKFILE("SQB")
			CHKFILE("RD0")
			CHKFILE("RDZ")
		Else
			lIncluiu := .F.
			cDescErro := "Funcion·rios cujo cÛdigo da empresa igual a " + AllTrim(cEmpresaArq)+'/'+ AllTrim(cFilialArq)+" n„o foram importados."
			//U_RIM01ERR(cDescErro)
			aAdd(aErro,cDescErro)
		EndIf

	EndIf

      IF lExiste == .T.

         aCampos := {}

	        nlidos += 1
         lIncluiu := .T.

		If 1 == nPosFimFilial
			aAdd(aCampos,{'RA_FILIAL','',NIL})
		Else
			aAdd(aCampos,{'RA_FILIAL',cFilialArq,NIL})
		EndIf

    	    nPosIni := At("|", cBuffer)
    	    cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
    	    nPosFim := At("|", cBuffer)

    	    cRA_mat  := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

    	    If Empty(cRA_mat)
	           aAdd(aCampos,{'RA_MAT','',NIL})
	        Else
	           aAdd(aCampos,{'RA_MAT',cRA_mat,NIL})
	        EndIf

	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_CC',CriaVar("RA_CC"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_CC',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/

	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_NOME','',NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_NOME',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------------------area e linha----------------------------*/
	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_ITEM',CriaVar("RA_ITEM"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_ITEM',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_DEPTO',CriaVar("RA_DEPTO"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_DEPTO',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       	  	aAdd(aCampos,{'RA_CODFUNC',CriaVar("RA_CODFUNC"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_CODFUNC',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_ADMISSA',CriaVar("RA_ADMISSA"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_ADMISSA',CtoD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_OPCAO ',CriaVar("RA_OPCAO"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_OPCAO ',CtoD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_DEMISSA ',CriaVar("RA_DEMISSA"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_DEMISSA ',CtoD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_BCDEPSA',CriaVar("RA_BCDEPSA"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_BCDEPSA',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_CTDEPSA',CriaVar("RA_CTDEPSA"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_CTDEPSA',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_BCDPFGT',CriaVar("RA_BCDPFGT"),NIL})
	       	Else
	       	  	aAdd(aCampos,{'RA_BCDPFGT',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_CTDPFGT',CriaVar("RA_CTDPFGT"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_CTDPFGT',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       			 aAdd(aCampos,{'RA_HRSMES',CriaVar("RA_HRSMES"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_HRSMES',Val(AllTrim(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/

         /*----------------------------hora semana trab---------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   		 aAdd(aCampos,{'RA_HRSEMAN',CriaVar("RA_HRSEMAN"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_HRSEMAN',Val(AllTrim(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_TNOTRAB',CriaVar("RA_TNOTRAB"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_TNOTRAB',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_PERCADT',CriaVar("RA_PERCADT"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_PERCADT',Val(AllTrim(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_CATFUNC',CriaVar("RA_CATFUNC"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_CATFUNC',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/


	       	nPosIni := At("|", cBuffer)
	       	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	nPosFim := At("|", cBuffer)

	       	If (nPosIni + 1) == nPosFim
	       		  aAdd(aCampos,{'RA_VIEMRAI',CriaVar("RA_VIEMRAI"),NIL})
	       	Else
	       		  aAdd(aCampos,{'RA_VIEMRAI',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------qtde dependentes para irrf-------------------------*/
	       	   nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_DEPIR',CriaVar("RA_DEPIR"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_DEPIR',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------qtde dependentes sal·rio familia-------------------*/
         	  nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_DEPSF',CriaVar("RA_DEPSF"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_DEPSF',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------nome completo--------------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_NOMECMP',CriaVar("RA_NOMECMP"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_NOMECMP',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

        /*--------------------situaÁ„o--------------------------------------------*/
         	  nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_SITFOLH',CriaVar("RA_SITFOLH"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_SITFOLH',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------contribuiÁ„o sindical------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_PGCTSIN',CriaVar("RA_PGCTSIN"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_PGCTSIN',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/


         /*--------------------------periculosidade-------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_PERICUL',CriaVar("RA_PERICUL"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_PERICUL',Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------------insalbridade min-----------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_INSMIN',CriaVar("RA_INSMIN"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_INSMIN',Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------------------isalubridade med------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_INSMED',CriaVar("RA_INSMED"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_INSMED',Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------------------insalubridade max-----------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_INSMAX',CriaVar("RA_INSMAX"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_INSMAX',Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------------------Tipo de Admiss„o-----------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_TIPOADM',CriaVar("RA_TIPOADM"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_TIPOADM',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------------------Categoria SEFIP------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_CATEG',CriaVar("RA_CATEG"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_CATEG',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
		EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------------Contrato de Trabalho--------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'RA_TPCONTR',CriaVar("RA_TPCONTR"),NIL})
		Else
			cRAtpContr := AllTrim(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
			IF cRAtpContr = 'I'
				cRAtpContr := '1'
			ElseIf cRAtpContr = 'D'
				cRAtpContr:= '2'
				aAdd(aCampos,{'RA_CLAURES','2',NIL})
			ElseIf cRAtpContr = 'C'
				cRAtpContr:= '2'
				aAdd(aCampos,{'RA_CLAURES','1',NIL})
			EndIf

			aAdd(aCampos,{'RA_TPCONTR',cRAtpContr,NIL})
		EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------OcorrÍncia SEFIP (exposiÁ„o a agentes nocivos)-----------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

		If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'RA_OCORREN',CriaVar("RA_OCORREN"),NIL})
		Else
			IF length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))) = 1
				aAdd(aCampos,{'RA_OCORREN','0' + Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
			Else
				aAdd(aCampos,{'RA_OCORREN',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
			EndIf
		EndIf
	       	   //Edna OCORR NCIA SEFIP (EXPOSI«√O A AGENTES NOCIVOS): RHU_SEFIP_30_FUN.OCORREN_SEFIP (LOGIX) ?SRAXX0.RA_OCORREN (PROTHEUS) I. PARA OS REGISTROS QUE TENHAM VALORES, EXPORTAR COM UM 0 NA FRENTE. NO LOGIX COMO … UM CAMPO NUM…RICO, N√O ARMAZENA ESTE 0, MAS
	       	/*-----------------------------------------------------------------------*/

         /*--------------------N˙mero do Registro---------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_FICHA',CriaVar("RA_FICHA"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_FICHA',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

	       	/*--------------------Forma de Demiss„o para a RAIS--------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_RESCRAI',CriaVar("RA_RESCRAI"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_RESCRAI',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------------------EndereÁo--------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_ENDEREC',CriaVar("RA_ENDEREC"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_ENDEREC',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------------------Complemento do EndereÁo-----------------*/
		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)

		If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'RA_COMPLEM',CriaVar("RA_COMPLEM"),NIL})
		Else
			aTam := TAMSX3("RA_COMPLEM")
			IF aTam[1] < length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
				cDescErro := "Funcion·rio: "+AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+alltrim(cRA_mat)+" - Campo complemento do endereÁo foi importado com a limitaÁ„o definida no configurador. Tam. Protheus:" + ALLTRIM(AllToChar(aTam[1]))+ " Tam. Sist. Ext:"+ ALLTRIM(AllToChar(length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))))) + "."
				//U_RIM01ERR(cDescErro)
				aAdd(aErro,cDescErro)
			EndIf
			aAdd(aCampos,{'RA_COMPLEM',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
		EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------------------CEP------------------------------------*/
	       	   nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_CEP',CriaVar("RA_CEP"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_CEP',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*------------------------------DenominaÁ„o da Cidade--------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

		If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'RA_MUNICIP',CriaVar("RA_MUNICIP"),NIL})
		Else
			aTam := TAMSX3("RA_MUNICIP")
			IF aTam[1] < length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
				cDescErro := "Funcion·rio: "+AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+alltrim(cRA_mat)+" - Campo descriÁ„o do municÌpio foi importado com a limitaÁ„o definida no configurador. Tam. Protheus:" + ALLTRIM(AllToChar(aTam[1]))+ " Tam. Sist. Ext:"+ ALLTRIM(AllToChar(length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))))) + "."
				//U_RIM01ERR(cDescErro)
				aAdd(aErro,cDescErro)
			EndIf
			aAdd(aCampos,{'RA_MUNICIP',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
		EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-----------------------CÛdigo da Unidade de FederaÁ„o------------------*/
         	  nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_ESTADO',CriaVar("RA_ESTADO"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_ESTADO',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-----------------------Bairro------------------------------------------*/
           	nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

		If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'RA_BAIRRO',CriaVar("RA_BAIRRO"),NIL})
		Else
			aTam := TAMSX3("RA_BAIRRO")
			IF aTam[1] < length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
				cDescErro := "Funcion·rio: "+AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+alltrim(cRA_mat)+" - Campo descriÁ„o do bairro foi importado com a limitaÁ„o definida no configurador. Tam. Protheus:" + ALLTRIM(AllToChar(aTam[1]))+ " Tam. Sist. Ext:"+ ALLTRIM(AllToChar(length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))))) + "."
				//U_RIM01ERR(cDescErro)
				aAdd(aErro,cDescErro)
			EndIf
			aAdd(aCampos,{'RA_BAIRRO',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
		EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-----------------------N˙mero do Telefone------------------------------*/
	       	   nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
  	          		aAdd(aCampos,{'RA_TELEFON',CriaVar("RA_TELEFON"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_TELEFON',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-----------------------Data de Nascimento------------------------------*/
	       	   nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_NASC','',NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_NASC',CtoD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-----------------------Naturalidade------------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_NATURAL',CriaVar("RA_NATURAL"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_NATURAL',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*------------------------------Nacionalidade----------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_NACIONA',CriaVar("RA_NACIONA"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_NACIONA',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------------------CPF-------------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
               aAdd(aCampos,{'RA_CIC',CriaVar("RA_CIC"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_CIC',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------------------PIS-------------------------------------*/
	       	   nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_PIS',CriaVar("RA_PIS"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_PIS',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*------------------------------N˙mero do tÌtulo eleitoral---------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_TITULOE',CriaVar("RA_TITULOE"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_TITULOE',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*----------------------Zona eleitoral / SeÁ„o--------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_ZONASEC',CriaVar("RA_ZONASEC"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_ZONASEC',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-----------------------------N˙mero da Carteira de Reservista----------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_RESERVI',CriaVar("RA_RESERVI"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_RESERVI',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/


         /*---------------N˙mero da Carteira de Identifidade----------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_RG',CriaVar("RA_RG"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_RG',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*------------------Org„o emissor da Carteira de Identifidade------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_RGORG',CriaVar("RA_RGORG"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_RGORG',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-----------Unidade da FederaÁ„o da Carteira de Identifidade------------*/
	       	   nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_RGUF',CriaVar("RA_RGUF"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_RGUF',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*----------------------------Sexo---------------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_SEXO',CriaVar("RA_SEXO"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_SEXO',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*------------------------------Grau de InstruÁ„o------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_GRINRAI',CriaVar("RA_GRINRAI"),NIL})
		Else
	       	     cGrauIns := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

			If cGrauIns == "1"     	//Analfabeto
				cGrauIns := "10"
			ElseIf cGrauIns == "2"	//4a serie incompleta
				cGrauIns := "20"
			ElseIf cGrauIns == "3"	//4a serie completa
				cGrauIns := "25"
			ElseIf cGrauIns == "4"	//Primeiro grau incompleto
				cGrauIns := "30"
			ElseIf cGrauIns == "5"	//Primeiro grau completo
				cGrauIns := "35"
			ElseIf cGrauIns == "6"	//Segundo grau incompleto
				cGrauIns := "40"
			ElseIf cGrauIns == "7"	//Segundo grau completo
				cGrauIns := "45"
			ElseIf cGrauIns == "8"	//Superior incompleto
				cGrauIns := "50"
			ElseIf cGrauIns == "9" //.or. (cGrauCampo == "85")	//Superior completo ou Pos-Graduacao (Especializacao)
				cGrauIns := "55"
			ElseIf cGrauIns == "10"	//Mestrado
				cGrauIns := "65"
			ElseIf cGrauIns == "11" //.or. (cGrauCampo == "95")	//Doutorado ou Pos-Doutorado
				cGrauIns := "75"
			EndIf

	       	     aAdd(aCampos,{'RA_GRINRAI',cGrauIns,NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------------------Estado Civil----------------------------*/
	       	   nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_ESTCIVI',CriaVar("RA_ESTCIVI"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_ESTCIVI',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------------Sal·rio--------------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_SALARIO',CriaVar("RA_SALARIO"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_SALARIO',Val(AllTrim(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------------------Data de emiss„o do CTPS-----------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

		If !(Type('SRA->RA_DTCPEXP') == "U")
			If (nPosIni + 1) == nPosFim
				aAdd(aCampos,{'RA_DTCPEXP',CriaVar("RA_DTCPEXP"),NIL})
			Else
				aAdd(aCampos,{'RA_DTCPEXP',CtoD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
			EndIf
		EndIf

         /*----------------Data de Emiss„o da Carteira de Identidade--------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

		If !(Type('SRA->RA_DTRGEXP') == "U")
			If (nPosIni + 1) == nPosFim
				aAdd(aCampos,{'RA_DTRGEXP',CriaVar("RA_DTRGEXP"),NIL})
			Else
				aAdd(aCampos,{'RA_DTRGEXP',CtoD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
			EndIf
		EndIf

         /*---------------------N˙mero da Carteira de HabilitaÁ„o-----------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_HABILIT',CriaVar("RA_HABILIT"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_HABILIT',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------------N˙mero da InscriÁ„o do INSS-------------------*/
	       	   nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	            		aAdd(aCampos,{'RA_NUMINSC',CriaVar("RA_NUMINSC"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_NUMINSC',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------------N˙mero da Carteira Profissional--------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_NUMCP',CriaVar("RA_NUMCP"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_NUMCP',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*---------------------SÈrie da Carteira Profissional--------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	     	aAdd(aCampos,{'RA_SERCP',CriaVar("RA_SERCP"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_SERCP',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------Unidade de FederaÁ„o da Carteira Profissional-------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_UFCP',CriaVar("RA_UFCP"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_UFCP',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*---------------------------RaÁa/Cor------------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_RACACOR',CriaVar("RA_RACACOR"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_RACACOR',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-----------------------------E-mail------------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_EMAIL',CriaVar("RA_EMAIL"),NIL})
		Else
			aTam := TAMSX3("RA_EMAIL")
			IF aTam[1] < length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
				cDescErro := "Funcion·rio: "+AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+alltrim(cRA_mat)+" - N„o foi importado o e-mail do funcion·rio. Alterar o tamanho do campo no Configurador. Tam. Protheus:" + ALLTRIM(AllToChar(aTam[1]))+ " Tam. Sist. Ext:"+ ALLTRIM(AllToChar(length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))))) + "."
				//U_RIM01ERR(cDescErro)
				aAdd(aErro,cDescErro)
				lIncluiu := .F.
			Else
				aAdd(aCampos,{'RA_EMAIL',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
			EndIf
		EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------------Data de chegada no Brasil--------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_ANOCHEG',CriaVar("RA_ANOCHEG"),NIL})
	       	   Else
			aAdd(aCampos,{'RA_ANOCHEG',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------------DeficiÍncia FÌsica--------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_DEFIFIS',CriaVar("RA_DEFIFIS"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_DEFIFIS',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf

         /*-----------------------Tipo de deficiÍncia fÌsica---------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_TPDEFFI',CriaVar("RA_TPDEFFI"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_TPDEFFI',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   EndIf
	       	/*-----------------------------------------------------------------------*/

         /*---------------------------Sindicato Representativo--------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_SINDICA',CriaVar("RA_SINDICA"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_SINDICA',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
		EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-----------Data de Vencimento do 1∫ perÌodo de experiÍncia-------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

		If !(Type('SRA->RA_VCTOEXP') == "U")
			If (nPosIni + 1) == nPosFim
				aAdd(aCampos,{'RA_VCTOEXP',CriaVar("RA_VCTOEXP"),NIL})
			Else
				dRAvctoExp := CTOD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
				aAdd(aCampos,{'RA_VCTOEXP',CTOD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
			EndIf
		EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------Data de Vencimento do 2∫ perÌodo de experiÍncia-----------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

		If !(Type('SRA->RA_VCTEXP2') == "U")
			If (nPosIni + 1) == nPosFim
				aAdd(aCampos,{'RA_VCTEXP2',CriaVar("RA_VCTEXP2"),NIL})
			Else
				dRAvctoExp2 := CTOD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
				aAdd(aCampos,{'RA_VCTEXP2',CTOD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
			EndIf
		EndIf
	       	/*-----------------------------------------------------------------------*/
		If cRAtpContr == '2'
			If Empty(dRAvctoExp) .AND. Empty(dRAvctoExp2)
				cDescErro := "Funcion·rio: "+AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+alltrim(cRA_mat)+" - … obrigatÛrio a informaÁ„o da Data de tÈrmino do contrato devido o tipo de contrato ser Determinado."
				//U_RIM01ERR(cDescErro)
				aAdd(aErro,cDescErro)
				lIncluiu := .F.
			Else
				If !Empty(dRAvctoExp) .AND. dRAvctoExp > dRAvctoExp2
					aAdd(aCampos,{'RA_DTFIMCT',dRAvctoExp,NIL})
				Else
					aAdd(aCampos,{'RA_DTFIMCT',dRAvctoExp2,NIL})
				EndIf
			EndIf
		EndIf

         /*----------------------Nome do Pai--------------------------------------*/
		nPosIni := At("|", cBuffer)
		cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		nPosFim := At("|", cBuffer)

		If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'RA_PAI',CriaVar("RA_PAI"),NIL})
		Else
			aTam := TAMSX3("RA_PAI")
			IF aTam[1] < length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
				cDescErro := "Funcion·rio: "+AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+alltrim(cRA_mat)+" - N„o foi importado o nome do pai. Alterar o tamanho do campo no configurador. Tam. Protheus:" + ALLTRIM(AllToChar(aTam[1]))+ " Tam. Sist. Ext:"+ ALLTRIM(AllToChar(length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))))) + "."
				//U_RIM01ERR(cDescErro)
				aAdd(aErro,cDescErro)
				lIncluiu := .F.
			Else
				aAdd(aCampos,{'RA_PAI',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
			EndIf
		EndIf
	       	/*-----------------------------------------------------------------------*/

         /*--------------------------Nome do M„e----------------------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
			aAdd(aCampos,{'RA_MAE',CriaVar("RA_MAE"),NIL})
		Else
			aTam := TAMSX3("RA_MAE")
			IF aTam[1] < length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
				cDescErro := "Funcion·rio: "+AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+alltrim(cRA_mat)+" - Campo Nome da M„e foi importado com a limitaÁ„o definida no Configurador. Tam. Protheus:" + ALLTRIM(AllToChar(aTam[1]))+ " Tam. Sist. Ext:"+ ALLTRIM(AllToChar(length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))))) + "."
				//U_RIM01ERR(cDescErro)
				aAdd(aErro,cDescErro)
			EndIf
			aAdd(aCampos,{'RA_MAE',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
		EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-----------------------------Data de ReintegraÁ„o----------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_FECREI',CriaVar("RA_FECREI"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_FECREI',CTOD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
		          EndIf
	       	/*-----------------------------------------------------------------------*/

         /*-------------------Data de Vencimento da Estabilidade------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_DTVTEST',CriaVar("RA_DTVTEST"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_DTVTEST',CTOD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
	       	   ENDIF
	       	/*-------------------N˙mero do Crach·------------------*/
            nPosIni := At("|", cBuffer)
	       	   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	       	   nPosFim := At("|", cBuffer)

	       	   If (nPosIni + 1) == nPosFim
	       	   	  aAdd(aCampos,{'RA_CRACHA',CriaVar("RA_CRACHA"),NIL})
	       	   Else
	       	   	  aAdd(aCampos,{'RA_CRACHA',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	       	   ENDIF

            DbSelectArea("SPA")
  		        DbSetOrder(1)

	       	  IF 	(DbSeek(xFilial("SPA") + '01'))
	       	       aAdd(aCampos,{'RA_REGRA','01',Nil})
	       	       aAdd(aCampos,{'RA_SEQTURN','01',Nil})
	       	  ENDIF

		/*Campos fixos devido a estrutura do LOGIX*/

	       	/*-------------------Tipo Pagamento---------------------*/
            aAdd(aCampos,{'RA_TIPOPGT','M',NIL})
	       	/*------------------------------------------------------*/

	       	/*-------------------Contrato parcial-------------------*/
            aAdd(aCampos,{'RA_HOPARC','2',NIL})
	       	/*------------------------------------------------------*/

	       	/*-------------------Sabado Compensado------------------*/
            aAdd(aCampos,{'RA_COMPSAB','2',NIL})
	       	/*------------------------------------------------------*/

	       	aAdd(aCampos,{'RA_ADTPOSE','******',Nil})
	       	aAdd(aCampos,{'RA_ASSIST',CriaVar("RA_ASSIST"),Nil})
         aAdd(aCampos,{'RA_CONFED',CriaVar("RA_CONFED"),Nil})
         aAdd(aCampos,{'RA_MENSIND',CriaVar("RA_MENSIND"),Nil})
         aAdd(aCampos,{'RA_RESEXT',CriaVar("RA_RESEXT"),Nil})
         aAdd(aCampos,{'RA_TPMAIL',CriaVar("RA_TPMAIL"),Nil})

	       	MSUnLock()
	       	IncProc()
	EndIf

	        Begin Transaction
	          lMsErroAuto := .F.
	          DBSelectArea("SRA")
           DBSetOrder(1)
           If !DbSeek(xFilial('SRA') + aCampos[2,2])
               MSExecAuto({|x,y,w,z| GPEA010(x,y,w,z)},Nil,aRotina,aCampos,3)
           Else
               MSExecAuto({|x,y,w,z| GPEA010(x,y,w,z)},Nil,aRotina,aCampos,4)
           EndIf

           /*IF lMsErroAuto
              DisarmTransaction()
              MostraErro()
              break
           ENDIF*/
           		If lMsErroAuto
             			DisarmTransaction()
            			//lMsErroAuto := .F.
            			//cMemo := MemoRead(NomeAutoLog())
            			aLog := GetAutoGrLog()
            			//U_RIM01ERA(aLog)
   		          Aeval(aLog, { |x| aAdd(aErro, x)  } )
            			//U_RIM01ERR(cMemo)
            			//RHMostraErro(,NomeAutoLog())
            			//lErroAuto := .T.
          		ENDIF
	End Transaction


	cEmpOrigem 		:= cEmpresaArq
	cFilialOrigem 	:= cFilialArq

	FT_FSKIP()
EndDo
    U_RIM01ERA(aErro)
    //⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
    //≥ Libera o arquivo                                                    ≥
    //¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
    FT_FUSE()

Return


