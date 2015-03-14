#include "fileio.ch"
#Include "protheus.ch"
#Include "folder.ch"
#Include "tbiconn.ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบMetodo    ณRHIMP05SindicatoบAutor  ณRafael Luis da Silvaบ Data ณ 23/02/2010 บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao dos sindicatos para a 	   บฑฑ
ฑฑบ          ณTabela RCE.                                                      บฑฑ
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
USER Function RHIMP05Sindicato(fName)
 Local cBuffer       := ""
 LOCAL lIncluiu 		   := .F.
 Local nPosIni       := 0
 Local nPosFim       := 0
 Local nPosFimFilial := 0
 Local nCount        := 0
 Local nlidos        := 0
 Local aCampos       := {}
 LOCAL lErro         := .F.
 LOCAL lEmpresaArq   := ""
 LOCAL lFilialArq    := ""
 LOCAL lEmpresa      := ""
 LOCAL lFilial       := ""
 LOCAL lEmpOrigem    := ""
 LOCAL lFilialOrigem := ""
	LOCAL cRCE_codigo		 := ""
	LOCAL cDescErro		   := ""
	LOCAL lExiste       := .F.
	PRIVATE aErro       := {}

 nCount := U_RIM01Line(fName)

 //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 //ณ Numero de registros a importar                                      ณ
 //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
 ProcRegua(nCount)

 FT_FUSE(fName)
 FT_FGOTOP()

 lEmpOrigem := '00'
 lFilialOrigem := '00'

 lExiste:= .T.
 While !FT_FEOF()
    IncProc()
    cBuffer := FT_FREADLN()

	   nPosFimFilial := At("|", cBuffer)
	   lEmpresaArq      := Substr(cBuffer, 1, nPosFimFilial - 1)

    nPosIni := nPosFimFilial
    cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
    nPosFim := At("|", cBuffer)

	   lFilialArq := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
	   If Empty(lFilialArq)
	      lFilialArq := "  "
    ENDIF

    IF lEmpresaArq <> lEmpOrigem .OR. lFilialArq <> lFilialOrigem
       lExiste = .F.
    	  dbSelectArea("SM0")
       dbGoTop()

       RpcClearEnv()
       OpenSm0Excl()
       While ! Eof()
          lEmpresa := SM0->M0_CODIGO
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
           PREPARE ENVIRONMENT EMPRESA (lEmpresa) FILIAL (lFilial) MODULO "GPE" FUNNAME "GPEA340"
           CHKFILE("RCE")
           CHKFILE("SRA")
       ELSE
           lIncluiu := .F.
           cDescErro := "Sindicato cujo c๓digo da empresa igual a " + AllTrim(lEmpresaArq)+'/'+ AllTrim(lFilialArq)+" nใo foram importados."
			        //U_RIM01ERR(cDescErro)
			        aAdd(aErro,cDescErro)
       ENDIF
    ENDIF

    IF lExiste == .T.

    	  nPosIni := At("|", cBuffer)
    	  cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
    	  nPosFim := At("|", cBuffer)

    	  cRCE_codigo  := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

       //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	    	 //ณ Incrementa a regua                                                  ณ
		     //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    	 nlidos += 1
       lIncluiu := .T.

       aCampos := {}

	      If 1 == nPosFimFilial
    	     aAdd(aCampos,{'RCE_FILIAL',''})
	      ELSE
  	         aAdd(aCampos,{'RCE_FILIAL',lFilialArq})
	      ENDIF

	    	 IF (nPosIni + 1) == nPosFim
	         aAdd(aCampos,{'RCE_CODIGO',""})
	      ELSE
	         aAdd(aCampos,{'RCE_CODIGO',cRCE_codigo})
	      ENDIF

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_DESCRI',""})
	    	 Else
	         	aAdd(aCampos,{'RCE_DESCRI',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))})
	    	 EndIf

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_MUNIC',""})
	    	 ELSE
           aAdd(aCampos,{'RCE_MUNIC',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))})
	    	 EndIf

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_UF',""})
	    	 Else
           aAdd(aCampos,{'RCE_UF',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))})
	    	 ENDIF

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_MESDIS',""})
	    	 Else
          aAdd(aCampos,{'RCE_MESDIS',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))})
	    	 ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_DIADIS',""})
	    	 Else
          aAdd(aCampos,{'RCE_DIADIS',Val(Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1)))})
	    	 ENDIF

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_PISO',0})
	    	 Else
           aAdd(aCampos,{'RCE_PISO',Val(Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1)))})
	    	 EndIf

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_ENDER',""})
	    	 ELSE
          aAdd(aCampos,{'RCE_ENDER',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))})
	    	 EndIf

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         aAdd(aCampos,{'RCE_NUMER',""})
	    	 Else
          aAdd(aCampos,{'RCE_NUMER',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))})
	    	 EndIf

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_COMPLE',""})
	    	 ELSE
           aAdd(aCampos,{'RCE_COMPLE',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))})
	    	 EndIf

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_BAIRRO',""})
	    	 ELSE
           aAdd(aCampos,{'RCE_BAIRRO',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))})
	    	 EndIf

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_CEP',""})
	    	 Else
           aAdd(aCampos,{'RCE_CEP',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))})
	    	 EndIf


	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_CGC',""})
	    	 Else
           aAdd(aCampos,{'RCE_CGC',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))})
	    	 ENDIF

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	aAdd(aCampos,{'RCE_ENTSIN',""})
	    	 Else
           aAdd(aCampos,{'RCE_ENTSIN',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))})
	    	 EndIf


	      MSUnLock()
	    	 IncProc()
		  ENDIF

    IF lIncluiu == .T.
       cDescErro := 'Sindicato: '+AllTrim(lEmpresaArq)+'/'+AllTrim(lFilialArq)+'/'+AllTrim(cRCE_codigo)
       If !U_RIM01MVC('RCE', aCampos,'GPEA340',cDescErro,cRCE_codigo,'GPEA340_RCE')
          lIncluiu := .F.
          lErro := .T.
       ENDIF
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
