#include "fileio.ch"
#Include "protheus.ch"
#Include "folder.ch"
#Include "tbiconn.ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบMetodo    RHIMP03CCusto        บAutor  ณRafael F. B.        บ Data ณ 27/08/2009 บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao do Centro de Custos da     บฑฑ
ฑฑบ          ณTabela CTT.                                                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณIntegracao do Modulo de RH dos Sistemas Logix X Protheus.        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณfName  - Nome do Arquivo 						                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                 บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER Function RHIMP03CCusto(fName)
	   Local cBuffer       := ""
    Local lEmpresaArq   := ""
    Local lFilialArq    := ""
    Local lEmpOrigem    := ""
    Local lFilialOrigem := ""
    Local cCusto        := ""
    Local cData         := ""
    Local nPosIni       := 0
    Local nPosFim       := 0
    Local nPosFimFilial := 0
    Local nCount        := 0
    Local nlidos        := 0
    LOCAL lIncluiu      := .F.
    LOCAL lExiste       := .F.
    LOCAL cITOBRG       := ""
    LOCAL cCLOBRG       := ""
    LOCAL cACITEM       := ""
    LOCAL cACCLVL       := ""
    LOCAL cBLOQ         := ""
     LOCAL cDescErro		   := ""
    Local aCampos       := {}
    LOCAL lErroAuto 		  := .F.
    PRIVATE aErro       := {}
    PRIVATE lMsErroAuto   := .F.

    nCount := U_RIM01Line(fName)

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Numero de registros a importar                                      ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    ProcRegua(nCount)

    FT_FUSE(fName)
    FT_FGOTOP()

    lEmpOrigem := '00'
    lFilialOrigem := '00'

    WHILE !FT_FEOF()
    	   cBuffer := FT_FREADLN()

	       nPosFimFilial := At("|", cBuffer)
	       lEmpresaArq      := Substr(cBuffer, 1, nPosFimFilial - 1)

    	   nPosIni := nPosFimFilial
	       cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
    	   nPosFim := At("|", cBuffer)

	       lFilialArq := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
	       IF Empty(lFilialArq)
	          lFilialArq := "  "
	       ENDIF

        IF lEmpresaArq <> lEmpOrigem .OR. lFilialArq <> lFilialOrigem
           lExiste:= .F.
        	  dbSelectArea("SM0")
           dbGoTop()

           RpcClearEnv()
           OpenSm0Excl()
           While ! Eof()
              lEmpresa:= SM0->M0_CODIGO
              lFilial := SM0->M0_CODFIL

              IF lEmpresa =  lEmpresaArq .AND. (Empty(lFilialArq) .OR. lFilialArq = lFilial)
                 lExiste := .T.
                 SM0->(dbSkip())
                 EXIT
              ENDIF
              SM0->(dbSkip())
           ENDDO

           IF lExiste == .T.
              RpcSetType(3)
              PREPARE ENVIRONMENT EMPRESA (lEmpresaArq) FILIAL (lFilialArq) MODULO "CTB" USER "ADMIN" FUNNAME "CTBA030"
              CHKFILE("CTT")
              CHKFILE("ST3")
              CHKFILE("CT3")
              CHKFILE("QAD")
              CHKFILE("SB1")
              CHKFILE("SRA")
              CHKFILE("SRD")
              CHKFILE("SRC")
              CHKFILE("SHB")
              CHKFILE("SH1")
              CHKFILE("SQB")
              CHKFILE("CW8")
              CHKFILE("SYP")
           ELSE
              lIncluiu := .F.
           ENDIF

        ENDIF

        IF lExiste == .T.
		         //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	          //ณ Incrementa a regua                                                  ณ
		         //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	          nlidos += 1
	          lIncluiu := .T.

           aCampos := {}

           nPosIni := At("|", cBuffer)
           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
           nPosFim := At("|", cBuffer)

           cCusto := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

	          If 1 == nPosFimFilial
	             aAdd(aCampos,{'CTT_FILIAL','',NIL})
	          ELSE
	             	aAdd(aCampos,{'CTT_FILIAL',lFilialArq,NIL})
	          ENDIF

	          IF (nPosIni + 1) == nPosFim
	              aAdd(aCampos,{'CTT_CUSTO','',NIL})
	          ELSE
	            	 aAdd(aCampos,{'CTT_CUSTO',cCusto,NIL})
	          ENDIF

	          nPosIni := At("|", cBuffer)
	          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          nPosFim := At("|", cBuffer)

	          If (nPosIni + 1) == nPosFim
	             	aAdd(aCampos,{'CTT_DESC01','',NIL})
	          ELSE
	             aTam := TAMSX3("CTT_DESC01")
	             IF aTam[1] < length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
	                cDescErro := "Centro de Custo: "+AllTrim(lEmpresaArq)+'/'+AllTrim(lFilialArq)+'/'+AllTrim(cCusto)+" - Nใo foi importado para a tabela. Alterar o tamanho do campo no Configurador."
			              //U_RIM01ERR(cDescErro)
			              aAdd(aErro,cDescErro)
			              lIncluiu := .F.
			           ELSE
                  aAdd(aCampos,{'CTT_DESC01',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1)),NIL})
              ENDIF
	          EndIf

	          nPosIni := At("|", cBuffer)
	          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          nPosFim := At("|", cBuffer)

	          If (nPosIni + 1) == nPosFim
	             	cBLOQ := CriaVar("CTT_BLOQ")
	             	aAdd(aCampos,{'CTT_BLOQ',cBLOQ,NIL})
	          Else
	              aAdd(aCampos,{'CTT_BLOQ',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	          ENDIF

	          nPosIni := At("|", cBuffer)
	          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          nPosFim := At("|", cBuffer)

	          If (nPosIni + 1) == nPosFim
	             	aAdd(aCampos,{'CTT_NOME','',NIL})
	          ELSE
	             aTam := TAMSX3("CTT_NOME")
	             IF aTam[1] < length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
	                cDescErro := "Centro de Custo: "+AllTrim(lEmpresaArq)+'/'+AllTrim(lFilialArq)+'/'+AllTrim(cCusto)+" - Nใo foi importado para a tabela. Alterar o tamanho do campo Nome do Tomador (CTT_NOME). Tam. Protheus:" + ALLTRIM(AllToChar(aTam[1]))+ " Tam. Sist. Ext:"+ ALLTRIM(AllToChar(length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))))) + "."
			              aAdd(aErro,cDescErro)
			              lIncluiu := .F.
			           ELSE
	                 aAdd(aCampos,{'CTT_NOME',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
              ENDIF
	          ENDIF

           nPosIni := At("|", cBuffer)
	          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          nPosFim := At("|", cBuffer)

	          If (nPosIni + 1) == nPosFim
	             	aAdd(aCampos,{'CTT_ENDER','',NIL})
	          ELSE
	             aTam := TAMSX3("CTT_ENDER")
	             IF aTam[1] < length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
	                cDescErro := "Centro de Custo: "+AllTrim(lEmpresaArq)+'/'+AllTrim(lFilialArq)+'/'+AllTrim(cCusto)+" - Nใo foi importado para a tabela. Alterar o tamanho do campo Endere็o do Tomador (CTT_ENDER). Tam. Protheus:" + ALLTRIM(AllToChar(aTam[1]))+ " Tam. Sist. Ext:"+ ALLTRIM(AllToChar(length(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))))) + "."
			              aAdd(aErro,cDescErro)
			              lIncluiu := .F.
			           ELSE
                 aAdd(aCampos,{'CTT_ENDER',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
              ENDIF
	          ENDIF

	          nPosIni := At("|", cBuffer)
	          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          nPosFim := At("|", cBuffer)

	          If (nPosIni + 1) == nPosFim
	             	aAdd(aCampos,{'CTT_BAIRRO','',NIL})
	          Else
	              aAdd(aCampos,{'CTT_BAIRRO',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	          ENDIF

	          nPosIni := At("|", cBuffer)
	          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          nPosFim := At("|", cBuffer)

	          If (nPosIni + 1) == nPosFim
	             	aAdd(aCampos,{'CTT_CEP','',NIL})
	          Else
	              aAdd(aCampos,{'CTT_CEP',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	          ENDIF

	          nPosIni := At("|", cBuffer)
	          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          nPosFim := At("|", cBuffer)

	          If (nPosIni + 1) == nPosFim
	             	aAdd(aCampos,{'CTT_MUNIC','',NIL})
	          Else
	              aAdd(aCampos,{'CTT_MUNIC',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	          ENDIF

	          nPosIni := At("|", cBuffer)
	          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          nPosFim := At("|", cBuffer)

	          If (nPosIni + 1) == nPosFim
	             	aAdd(aCampos,{'CTT_ESTADO','',NIL})
	          Else
	              aAdd(aCampos,{'CTT_ESTADO',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	          ENDIF

	          nPosIni := At("|", cBuffer)
	          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          nPosFim := At("|", cBuffer)

	          If (nPosIni + 1) == nPosFim
	             	aAdd(aCampos,{'CTT_TIPO','',NIL})
	          Else
	              aAdd(aCampos,{'CTT_TIPO',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	          ENDIF

	          nPosIni := At("|", cBuffer)
	          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          nPosFim := At("|", cBuffer)

	          If (nPosIni + 1) == nPosFim
	             	aAdd(aCampos,{'CTT_CEI','',NIL})
	          Else
	              aAdd(aCampos,{'CTT_CEI',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	          ENDIF


	          cCLASSE  := CriaVar("CTT_CLASSE")
           aAdd(aCampos,{'CTT_CLASSE',cCLASSE,NIL})

	          cITOBRG := CriaVar("CTT_ITOBRG")
	          aAdd(aCampos,{'CTT_ITOBRG',cITOBRG,NIL})

	          cCLOBRG := CriaVar("CTT_CLOBRG")
	          aAdd(aCampos,{'CTT_CLOBRG',cCLOBRG,NIL})

	          cACITEM := CriaVar("CTT_ACITEM")
	          aAdd(aCampos,{'CTT_ACITEM',cACITEM,NIL})

	          cACCLVL := CriaVar("CTT_ACCLVL")
	          aAdd(aCampos,{'CTT_ACCLVL',cACCLVL,NIL})

	          MSUnLock()
	          IncProc()
		      ENDIF

			     IF  lIncluiu == .T.
	           Begin Transaction
	               lMsErroAuto := .F.
	               DBSelectArea("CTT")
                DBSetOrder(1)
                If !DbSeek(xFilial('CTT') + aCampos[2,2])
                    MSExecAuto({|x,y| CTBA030(x,y)},aCampos,3)
                ELSE
                    MSExecAuto({|x,y| CTBA030(x,y)},aCampos,4)
                EndIf

              	 	IF lMsErroAuto
                  	DisarmTransaction()
            			    //lMsErroAuto := .F.
            		    	//lErroAuto := .T.
            		    	aLog := GetAutoGrLog()
   		              Aeval(aLog, { |x| aAdd(aErro, x)  } )
          	      	ENDIF
            END Transaction
        ENDIF
		      lEmpOrigem := lEmpresaArq
        lFilialOrigem := lFilialArq
    	   FT_FSKIP()
    ENDDO
    U_RIM01ERA(aErro)

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Libera o arquivo                                                    ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    FT_FUSE()
RETURN