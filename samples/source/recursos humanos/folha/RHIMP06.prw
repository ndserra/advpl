#include "fileio.ch"
#Include "protheus.ch"
#Include "folder.ch"
#Include "tbiconn.ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบMetodo    ณRHIMP06Verba    บAutor  ณRafael Luis da Silvaบ Data ณ 23/02/2010 บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao das verbas para a tabela   บฑฑ
ฑฑบ          ณSRV.    		                                                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณIntegracao do Modulo de RH dos Sistemas Logix X Protheus.        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณfName  - Nome do Arquivo 						                   	 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                 บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER Function RHIMP06Verba(fName)
  	 Local cBuffer       := ""
    Local lEmpresaArq   := ""
    Local lFilialArq    := ""
    Local lEmpOrigem    := "00"
    Local lFilialOrigem := "00"
    Local lIncluiu 	   	:= .F.
    Local nPosIni       := 0
    Local nPosFim       := 0
    Local nPosFimFilial := 0
    Local nCount        := 0
    Local nlidos        := 0
    LOCAL cRV_cod   	  	:= ""
    LOCAL cDescErro		   := ""



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

    cBuffer := FT_FREADLN()

	   nPosFimFilial := At("|", cBuffer)
	   lEmpresaArq      := Substr(cBuffer, 1, nPosFimFilial - 1)

    nPosIni := nPosFimFilial
    cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
    nPosFim := At("|", cBuffer)

	   lFilialArq := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
	   If Empty(lFilialArq)
	      lFilialArq := "  "
    EndIf

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
             lExiste = .T.
             SM0->(dbSkip())
             EXIT
          ENDIF
          SM0->(dbSkip())
       ENDDO
       IF lExiste == .T.
          RpcSetType(3)
          PREPARE ENVIRONMENT EMPRESA (lEmpresaArq) FILIAL (lFilialArq) MODULO "GPE" USER "ADMIN" FUNNAME "GPEA040"
          CHKFILE("SRV")
          CHKFILE("SR1")
          CHKFILE("SRQ")
          CHKFILE("SRC")
          CHKFILE("SRD")
          CHKFILE("SRT")
          CHKFILE("SRI")
          CHKFILE("SRK")
          CHKFILE("SP9")
          CHKFILE("SRR")
          CHKFILE("SRZ")
          CHKFILE("SPB")
          CHKFILE("SRC")
          CHKFILE("SCC")

         IF lEmpresaArq <> lEmpOrigem
            //EXCLUSAO DE TODOS OS REGISTROS PARA REALIZAR A IMPORTACAO
	           dbSelectArea("SRV")
	           dbSetOrder(1)
	           dbgotop()
	           WHILE !EOF()
	            	RecLock("SRV",.F.,.T.)
	            	dbDelete()
	 	           MsUnlOCK()
	 	           dbSkip()
	           ENDDO
	        ENDIF

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



      	nPosIni := At("|", cBuffer)
      	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
      	nPosFim := At("|", cBuffer)

      	cRV_cod    := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

      	dbSelectArea("SRV")
	      dbSetOrder(1)
		     RecLock("SRV", .T.)


    		 IF 1 == nPosFimFilial
    	     	RV_FILIAL := ""
	      ELSE
  	        RV_FILIAL := lFilialArq
       EndIf

	    	 IF (nPosIni + 1) == nPosFim
	        RV_COD    := ""
	      Else
	         RV_COD    := cRV_cod
	      EndIf

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	RV_DESC := ""
	    	 Else
	         	RV_DESC := Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))
	    	 EndIf

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	RV_TIPOCOD := ""
	    	 Else
            	RV_TIPOCOD := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
	    	 EndIf

	    	 nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
	         	RV_TIPO := ""
	    	 Else
           RV_TIPO := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
	    	 EndIf

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_PERC:= 0
       ELSE
           RV_PERC := val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_LCTOP:= ""
       ELSE
           RV_LCTOP := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
           RV_MED13:= ""
       ELSE
           RV_MED13 := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_MEDFER:= ""
       ELSE
           RV_MEDFER := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_MEDAVI:= ""
       ELSE
          RV_MEDAVI := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_CODFOL:= ""
       ELSE
           RV_CODFOL := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_INSS:= ""
       ELSE
           RV_INSS := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_IR:= ""
       ELSE
           RV_IR := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_FGTS:= ""
       ELSE
           RV_FGTS := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_REF13:= ""
       ELSE
           RV_REF13 := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_REFFER:= ""
       ELSE
           RV_REFFER := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_ADIANTA:= ""
       ELSE
           RV_ADIANTA := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      nPosFim := At("|", cBuffer)

	      IF (nPosIni + 1) == nPosFim
          RV_PERICUL:= ""
       ELSE
            RV_PERICUL := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      nPosFim := At("|", cBuffer)

	      IF (nPosIni + 1) == nPosFim
          RV_INSALUBR:= ""
       ELSE
            RV_INSALUBR := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      nPosFim := At("|", cBuffer)

	      IF (nPosIni + 1) == nPosFim
           RV_SINDICA:= ""
       ELSE
            RV_SINDICA := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      nPosFim := At("|", cBuffer)

	      IF (nPosIni + 1) == nPosFim
          RV_SALFAMI:= ""
       ELSE
            RV_SALFAMI := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	   	  nPosFim := At("|", cBuffer)

	   	  If (nPosIni + 1) == nPosFim
          RV_DEDINSS:= ""
       ELSE
            RV_DEDINSS := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_RAIS:= ""
       ELSE
           RV_RAIS := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

       nPosIni := At("|", cBuffer)
	    	 cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	 nPosFim := At("|", cBuffer)

	    	 If (nPosIni + 1) == nPosFim
          RV_DIRF:= ""
       ELSE
          RV_DIRF := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
       ENDIF

	      MSUnLock()
	      IncProc()
		  EndIf

		  lEmpOrigem := lEmpresaArq
    lFilialOrigem := lFilialArq

  	 FT_FSKIP()
 ENDDO
 //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 //ณ Libera o arquivo                                                    ณ
 //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
 FT_FUSE()
return