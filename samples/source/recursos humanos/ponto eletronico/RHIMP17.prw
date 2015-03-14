#include "fileio.ch"
#Include "protheus.ch"
#Include "folder.ch"
#Include "tbiconn.ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบMetodo    RHIMP17Ocorren   บAutor  ณEdna Dalfovoบ Data ณ 08/02/2013 บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao das funcoes para a tabela  บฑฑ
ฑฑบ          ณSP9.			                                                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณIntegracao do Modulo de RH dos Sistemas Logix X Protheus.        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณfName  - Nome do Arquivo 	   				                   	 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                 บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER Function RHIMP17Ocorren(fName)
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
 LOCAL cP9_Ocorren	  := ""
 LOCAL cP9_FILIAL    := ""
 LOCAL cP9_DESC      := ""
 LOCAL cP9_Codfol    := ""
 LOCAL cDescErro		   := ""
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
          CHKFILE("SRV")
       ELSE
          lIncluiu := .F.
          cDescErro := "Ocorr๊ncia cujo c๓digo da empresa igual a " + AllTrim(cEmpresaArq)+'/'+ AllTrim(cFilialArq)+" nใo foram importados."
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

   	   cP9_Ocorren := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

	   	  nPosIni := At("|", cBuffer)
	   	  cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	   	  nPosFim := At("|", cBuffer)

	   	  If (nPosIni + 1) == nPosFim
	         	cP9_DESC:= ""
	   	  ELSE
	   	     cP9_DESC:= Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))
   	      aTam := TAMSX3("P9_DESC")
          IF aTam[1] < length(cP9_DESC)
            cDescErro := "Ocorr๊ncia: "+AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+alltrim(cP9_Ocorren)+" - Nใo foi importado para a tabela. Alterar o tamanho do campo descri็ใo no Configurador. Tam. Protheus:" + ALLTRIM(AllToChar(aTam[1]))+ " Tam. Sist. Ext:"+ ALLTRIM(AllToChar(length(Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))))) + "."
			         //U_RIM01ERR(cDescErro)
			         aAdd(aErro,cDescErro)
			       ELSE


            nPosIni := At("|", cBuffer)
	   	       cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	   	       nPosFim := At("|", cBuffer)

            cP9_Codfol:=Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

            DbSelectArea("SRV")
  		        DbSetOrder(1)
  		        //Verifica se o evento enviado no arquivo possui cadastro no sistema protheus, ou se o evento estแ nulo
  		        //Caso uma dessas centensas sejam verdadeiras o registro ้ carregado e inserido na tabela.
            IF 	(DbSeek(cFilialArq + cP9_Codfol + Space(TamSX3("RV_COD")[1] - Len(cP9_Codfol)))) .OR. Empty(cP9_Codfol)


  	   	         DbSelectArea("SP9")
  		            DbSetOrder(1)

 	    	         If 	!DbSeek(cFilialArq + cP9_Ocorren + Space(TamSX3("P9_CODIGO")[1] - Len(cP9_Ocorren)))
 	                 	RecLock("SP9", .T.)

 		                 IF 1 == nPosFimFilial
     	                	cP9_FILIAL := ""
 	                 	ELSE
   	                 		cP9_FILIAL := cFilialArq
 		                 EndIf

 	    	         Else
 	                 	RecLock("SP9", .F.)
 	    	         EndIf

                P9_FILIAL := cP9_FILIAL
                P9_CODIGO := cP9_Ocorren
                P9_DESC   := cP9_DESC
                P9_CODFOL := cP9_Codfol

                nPosIni := At("|", cBuffer)
	   	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	   	           nPosFim := At("|", cBuffer)

                If (nPosIni + 1) == nPosFim
                   P9_TIPOCOD:=""
                Else
                   P9_TIPOCOD:=Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
                ENDIF

                nPosIni := At("|", cBuffer)
	   	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	   	           nPosFim := At("|", cBuffer)

                If (nPosIni + 1) == nPosFim
                   P9_DESCDSR:=""
                Else
                   P9_DESCDSR:=Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
                ENDIF

                nPosIni := At("|", cBuffer)
	   	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	   	           nPosFim := At("|", cBuffer)

                If (nPosIni + 1) == nPosFim
                   P9_CLASEV:=""
                Else
                   P9_CLASEV:=Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
                ENDIF

                nPosIni := At("|", cBuffer)
	   	           cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	   	           nPosFim := At("|", cBuffer)

                If (nPosIni + 1) == nPosFim
                   P9_BHORAS:=""
                Else
                   P9_BHORAS:=Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
                ENDIF


                P9_IDPON := CriaVar("P9_IDPON")
                P9_BHNDE := CriaVar("P9_BHNDE")
                P9_BHNATE := CriaVar("P9_BHNATE")
                P9_BHPERC := CriaVar("P9_BHPERC")
                P9_BHAGRU := CriaVar("P9_BHAGRU")
                P9_BHAVAL := CriaVar("P9_BHAVAL")
                P9_PBH := CriaVar("P9_PBH")
                P9_PFOL := CriaVar("P9_PFOL")
                P9_DIVERGE := CriaVar("P9_DIVERGE")
                P9_EVECONT := CriaVar("P9_EVECONT")


 	          ELSE
                cDescErro := "Evento: "+AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+alltrim(cP9_Codfol)+" - Verba nใo cadastrada no cadastro de Verbas (SRV)."
			             //U_RIM01ERR(cDescErro)
			            aAdd(aErro,cDescErro)
 	          ENDIF

            MSUnLock()
	           IncProc()
      			 ENDIF
	   	  ENDIF

    ENDIF

    IF ((cEmpOrigem <> cEmpresaArq) .OR. (cFilialOrigem <> cFilialArq))  .AND. lIncluiu == .F.
	   	    cDescErro := "Eventos cujo c๓digo da empresa/filial igual a " + alltrim(cEmpresaArq)+'/'+alltrim(cFilialArq)+" nใo foram importados."
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

