#include "fileio.ch"
#Include "protheus.ch"
#Include "folder.ch"
#Include "tbiconn.ch"
#Include "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบMetodo    RHIMP18Relogio   บAutor  ณEdna Dalfovoบ Data ณ 19/02/2013 บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao das funcoes para a tabela  บฑฑ
ฑฑบ          ณSP0.			                                                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณIntegracao do Modulo de RH dos Sistemas Logix X Protheus.        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณfName - Nome do Arquivo 	   				                   	 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                 บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER Function RHIMP18Relogio(fName)
 Local cBuffer       := ""
 LOCAL lIncluiu 		   := .F.
 Local nPosIni       := 0
 Local nPosFim       := 0
 Local nPosFimFilial := 0
 Local nCount        := 0
 Local nlidos        := 0
 Local cEmpresaArq   := ""
 LOCAL cFilialArq    := ""
 LOCAL cEmpOrigem    := "00"
 LOCAL cFilialOrigem := "00"
 LOCAL cP0_Relogio	  := ""
 LOCAL cP0_FILIAL    := ""
 LOCAL cP0_DESC      := ""
 LOCAL cP0_Codfol    := ""
 LOCAL cDescErro		   := ""
 LOCAL cP0_CONTROL   := ""
 LOCAL cP0_ARQUIVO   := ""
 PRIVATE aErro       := {}

 nCount := U_RIM01Line(fName)

 //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 //ณ Numero de registros a importar                                      ณ
 //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
 ProcRegua(nCount)

 FT_FUSE(fName)
 FT_FGOTOP()

 lExiste:= .T.
 While !FT_FEOF()
    IncProc()
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

    IF cEmpresaArq <> cEmpOrigem .OR. cFilialArq <> cFilialOrigem
       lExiste:= .F.
    	  dbSelectArea("SM0")
       dbGoTop()

       RpcClearEnv()
       OpenSm0Excl()
       While ! Eof()
          lEmpresa:= SM0->M0_CODIGO
          lFilial := SM0->M0_CODFIL

          IF lEmpresa =  cEmpresaArq .AND. (Empty(cFilialArq) .OR. cFilialArq = lFilial)
             lExiste = .T.
             SM0->(dbSkip())
             EXIT
          ENDIF
          SM0->(dbSkip())
       ENDDO
       IF lExiste == .T.
          RpcSetType(3)
          PREPARE ENVIRONMENT EMPRESA (lEmpresa) FILIAL (lFilial) MODULO "PON" USER "ADMIN" FUNNAME "PONA100"

       ELSE
          lIncluiu := .F.
          cDescErro := "Rel๓gios cujo c๓digo da empresa igual a " + AllTrim(cEmpresaArq)+'/'+ AllTrim(cFilialArq)+" nใo foram importados."
			       //U_RIM01ERR(cDescErro)
			        aAdd(aErro,cDescErro)
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

   	   cP0_Relogio := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

	   	  nPosIni := At("|", cBuffer)
	   	  cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	   	  nPosFim := At("|", cBuffer)


	   	     cP0_DESC:= Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))
   	      aTam := TAMSX3("P0_DESC")
          IF (aTam[1] < length(cP0_DESC)) .OR. Empty(cP0_DESC)
             cDescErro := "Rel๓gio: "+AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+alltrim(cP0_Relogio)+" - Nใo foi importado para a tabela. Alterar o tamanho do campo descri็ใo no Configurador. Tam. Protheus:" + ALLTRIM(AllToChar(aTam[1]))+ " Tam. Sist. Ext:"+ ALLTRIM(AllToChar(length(Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))))) + "."
			          //U_RIM01ERR(cDescErro)
			           aAdd(aErro,cDescErro)
			       ELSE

			          nPosIni := At("|", cBuffer)
	    	       cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	       nPosFim := At("|", cBuffer)

             cP0_CONTROL:=Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

             nPosIni := At("|", cBuffer)
	    	       cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	       nPosFim := At("|", cBuffer)

             cP0_ARQUIVO :=Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

             aTam := TAMSX3("P0_ARQUIVO")
             IF aTam[1] < length(cP0_ARQUIVO)
                cDescErro := "Rel๓gio: "+AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+alltrim(cP0_Relogio)+" - Nใo foi importado para a tabela. Alterar o tamanho do campo Nome do Arquivo no Configurador. Tam. Protheus:" + ALLTRIM(AllToChar(aTam[1]))+ " Tam. Sist. Ext:"+ ALLTRIM(AllToChar(length(Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))))) + "."
			             //U_RIM01ERR(cDescErro)
			              aAdd(aErro,cDescErro)
			          ELSE
        	        DbSelectArea("SP0")
        		       DbSetOrder(1)

       	         If 	!DbSeek(cFilialArq + cP0_Relogio + Space(TamSX3("P0_RELOGIO")[1] - Len(cP0_Relogio)))
       	            	RecLock("SP0", .T.)

       		            IF 1 == nPosFimFilial
           	           	cP0_FILIAL := ""
       	            	ELSE
         	            		cP0_FILIAL := cFilialArq
       		            EndIf

       	         Else
       	            	RecLock("SP0", .F.)
       	         EndIf

                 P0_FILIAL  := cP0_FILIAL
                 P0_RELOGIO := cP0_Relogio
                 P0_DESC    := cP0_DESC
                 P0_CONTROL := cP0_CONTROL
                 P0_ARQUIVO := cP0_ARQUIVO

                 P0_TIPOARQ := 'T' //	T - para arquivos padrใo ASCII, esse valor ้ padrใo do logix

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 cP0_REP :=Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

                 P0_REP:= cP0_REP

                 IF !Empty(cP0_REP)
                    P0_INC := '1'
                 ENDIF

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_CODINI:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_CODFIM:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_RELOINI:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_RELOFIM:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_DIAINI:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_DIAFIM:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_MESINI:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_MESFIM:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_ANOINI:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_ANOFIM:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_HORAINI:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_HORAFIM:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_MINUINI:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_MINUFIM:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_FUNCINI:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 nPosIni := At("|", cBuffer)
	    	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	    	           nPosFim := At("|", cBuffer)

                 P0_FUNCFIM:= Val(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)))

                 P9_CC := CriaVar("P0_CC")
                 P9_ONLINE := CriaVar("P0_ONLINE")
                 P9_CODFOR := CriaVar("P0_CODFOR")
                 P9_RELFOR := CriaVar("P0_RELFOR")
                 P9_DIAFOR := CriaVar("P0_DIAFOR")
                 P9_MESFOR := CriaVar("P0_MESFOR")
                 P9_ANOFOR := CriaVar("P0_ANOFOR")
                 P9_HORAFOR := CriaVar("P0_HORAFOR")
                 P9_MINUFOR := CriaVar("P0_MINUFOR")
                 P9_FUNCFOR := CriaVar("P0_FUNCFOR")
                 P9_GIROINI := CriaVar("P0_GIROINI")
                 P9_GIROFIM := CriaVar("P0_GIROFIM")
                 P9_GIROFOR := CriaVar("P0_GIROFOR")
                 P9_CCINI := CriaVar("P0_CCINI")
                 P9_CCFIM := CriaVar("P0_CCFIM")
                 P9_CCFOR := CriaVar("P0_CCFOR")
                 P9_TIPOPER := CriaVar("P0_TIPOPER")
                 P9_ELIMINA := CriaVar("P0_ELIMINA")
                 P9_NOVO := CriaVar("P0_NOVO")

                 MSUnLock()

              ENDIF

            IncProc()
      			 ENDIF

    ENDIF

    IF ((cEmpOrigem <> cEmpresaArq) .OR. (cFilialOrigem <> cFilialArq))  .AND. lIncluiu == .F.
	   	    cDescErro := "Rel๓gios cujo c๓digo da empresa/filial igual a " + alltrim(cEmpresaArq)+'/'+alltrim(cFilialArq)+" nใo foram importados."
	   	    //U_RIM01ERR(cDescErro)
	   	     aAdd(aErro,cDescErro)
	   ENDIF

    FT_FSKIP()

    cEmpOrigem := cEmpresaArq
    cFilialOrigem  := cFilialArq
 ENDDO
 U_RIM01ERA(aErro)
 //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 //ณ Libera o arquivo                                                    ณ
 //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
 FT_FUSE()

RETURN

