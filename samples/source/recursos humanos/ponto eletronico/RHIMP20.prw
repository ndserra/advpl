#include "fileio.ch"
#Include "protheus.ch"
#Include "folder.ch"
#Include "tbiconn.ch"
#Include "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบMetodo    RHIMP19Cracha   บAutor  ณEdna Dalfovoบ Data ณ 01/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao das funcoes para a tabela  บฑฑ
ฑฑบ          ณSPI.			                                                    บฑฑ
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
USER Function RHIMP20BCHoras(fName)
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
 LOCAL cPI_Mat       := ""
 Local dPI_DataOco   := CtoD("//")
 Local cCodEveAux    := ""
 Local cPI_CCusto    := ""
 Local nPI_QtHoras   := 0
 Local cPI_CodDep    := ""
 Local cPI_CodCargo  := ""
 LOCAL cPI_CodOco    := ""
 LOCAL cPI_CodEve    := ""
 LOCAL nInd          := 0
 Local cCondicao     := ""
 LOCAL cQuery        := ""
 Local cAliasQry     := ""
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
          cEmpresa:= SM0->M0_CODIGO
          lFilial := SM0->M0_CODFIL

          IF cEmpresa =  cEmpresaArq .AND. (Empty(cFilialArq) .OR. cFilialArq = lFilial)
             lExiste = .T.
             SM0->(dbSkip())
             EXIT
          ENDIF
          SM0->(dbSkip())
       ENDDO
       IF lExiste == .T.
          RpcSetType(3)
          PREPARE ENVIRONMENT EMPRESA (cEmpresa) FILIAL (lFilial) MODULO "PON" USER "ADMIN" FUNNAME "PONA200"

          IF cEmpresaArq <> cEmpOrigem
            //EXCLUSAO DE TODOS OS REGISTROS PARA REALIZAR A IMPORTACAO
	           dbSelectArea("SPI")
	           dbSetOrder(1)
	           dbgotop()
	           WHILE !EOF()
	            	RecLock("SPI",.F.,.T.)
	            	dbDelete()
	 	           MsUnlOCK()
	 	           dbSkip()
	           ENDDO
	        ENDIF

       ELSE
          lIncluiu := .F.
          cDescErro := "Crachแs Provis๓rios cujo c๓digo da empresa igual a " + AllTrim(cEmpresaArq)+'/'+ AllTrim(cFilialArq)+" nใo foram importados."
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

	      If (nPosIni + 1) == nPosFim
	         	cPI_Mat := ""
	      ELSE
	         	cPI_Mat := Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))
	      EndIf

	      nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      nPosFim := At("|", cBuffer)

       IF (nPosIni + 1) == nPosFim
	         	dPI_DataOco :=  CtoD('//')
	      ELSE
	         	dPI_DataOco := CtoD(Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1)))
	      ENDIF

	      nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      nPosFim := At("|", cBuffer)

       IF (nPosIni + 1) == nPosFim
	         	cPI_CodOco :=  ''
	      ELSE
	         	cPI_CodOco := Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))
	      ENDIF

	      nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      nPosFim := At("|", cBuffer)

       IF (nPosIni + 1) == nPosFim
	         	cPI_CodEve :=  ''
	      ELSE
	         	cPI_CodEve := Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))
	      ENDIF

	      nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      nPosFim := At("|", cBuffer)

       IF (nPosIni + 1) == nPosFim
	         	cPI_CCusto :=  ''
	      ELSE
	         	cPI_CCusto := Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))
	      ENDIF

	      nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      nPosFim := At("|", cBuffer)

       IF (nPosIni + 1) == nPosFim
	         	nPI_QtHoras :=  ''
	      ELSE
	         	nPI_QtHoras := Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))
	      ENDIF

	      nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      nPosFim := At("|", cBuffer)

       IF (nPosIni + 1) == nPosFim
	         	cPI_CodDep :=  ''
	      ELSE
	         	cPI_CodDep := Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))
	      ENDIF

	      nPosIni := At("|", cBuffer)
	      cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      nPosFim := At("|", cBuffer)

       IF (nPosIni + 1) == nPosFim
	         	cPI_CodCargo :=  ''
	      ELSE
	         	cPI_CodCargo := Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))
	      ENDIF

       DbSelectArea("SRA")
       DbSetOrder(1)

		     IF 	DbSeek((cFilialArq) + PADR(cPI_MAT,GetSx3Cache( "RA_MAT", "X3_TAMANHO" ))) //(cPI_Mat + Space(TamSX3("RA_MAT")[1] - Len(cPI_Mat))))
		          //SRA->(dbSkip())

           DbSelectArea("SRV")
           DbSetOrder(1)

		         IF 	DbSeek(xFilial('SRV') + PADR(cPI_CodEve,GetSx3Cache( "RV_COD", "X3_TAMANHO" ))) //(cPI_CodEve + Space(TamSX3("RV_COD")[1] - Len(cPI_CodEve))))
		              //SRV->(dbSkip())
		             /* cFilialAux := xFILIAL("SP9")

		              IF cFilialAux <> NIL
		                 cFilialAux := cFilialArq
		              ENDIF
                       */

                cAliasQry :=  GetNextAlias()
                cQuery =""
                cQuery += " SELECT P9_CODIGO, P9_FILIAL"
                cQuery += " FROM " + RetSqlName("SP9")
                cQuery += "   WHERE P9_CODFOL = " +"'"+cPI_CodEve+"'"
                cQuery += " AND D_E_L_E_T_<>'*' "
                cQuery += " ORDER BY  P9_FILIAL,P9_CODIGO"

                cQuery := ChangeQuery(cQuery)
                dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasQry, .F., .F.)
                dbSelectArea(cAliasQry)
                (cAliasQry)->( DbGoTop() )

                nInd := 0
                While !(cAliasQry)->( Eof() )
                   if (Empty((cAliasQry)->P9_FILIAL) .OR. ((cAliasQry)->P9_FILIAL =cFilialArq) )
                        cCodEveAux := (cAliasQry)->P9_CODIGO
	  	                nInd := nInd +1
                   endif
                   (cAliasQry)->( DbSkip() )
                EndDo

		              IF 	nInd <> 0
		                  IF nInd > 1
                       cDescErro := "Banco de Horas: Empresa/Filial/Verba "+AllTrim(cEmpresaArq)+'/'+ AllTrim(cFilialArq)+'/'+ AllTrim(cPI_CodEve)+" nใo permitido relacionar a mais de um Evento no cadastro de Eventos."
			                    //U_RIM01ERR(cDescErro)
			                    aAdd(aErro,cDescErro)

		                  ELSE

		                     DbSelectArea("SPI")
		                     DbSetOrder(1)
		                     RecLock("SPI", .T.)

                             PI_FILIAL  := cFilialArq
                             PI_MAT	  := cPI_Mat
                             PI_DATA    := dPI_DataOco
                             PI_PD	  := cCodEveAux
                             PI_CC	  := cPI_CCusto
                             PI_QUANTV  := Val(STRTRAN(nPI_QtHoras,',','.'))
                             PI_DEPTO   := cPI_CodDep
                             PI_CODFUNC := cPI_CodCargo
                             PI_QUANT   := Val(nPI_QtHoras)
                             PI_FLAG    := "I"
                             PI_STATUS  := ""
                             PI_DTBAIX  := CtoD("")


                             MSUnLock()

                             IncProc()
		                  ENDIF
		              ELSE
                    cDescErro := "Banco de Horas: Empresa/Filial/Verba "+AllTrim(cEmpresaArq)+'/'+ AllTrim(cFilialArq)+'/'+ AllTrim(cPI_CodEve)+" nใo relacionada a um Evento no cadastro de Eventos."
			                 //U_RIM01ERR(cDescErro)
			                 aAdd(aErro,cDescErro)
		              ENDIF
           ELSE
              cDescErro := "Banco de Horas: "+AllTrim(cEmpresaArq)+'/'+ AllTrim(cFilialArq)+'/'+AllTrim(cPI_CodEve) +" - Verba nใo cadastrada. Necessแrio realizar a importa็ใo do cadastro de Verbas do Logix."
			           //U_RIM01ERR(cDescErro)
			           aAdd(aErro,cDescErro)
           ENDIF
		     ELSE
          cDescErro := "Banco de Horas: "+AllTrim(cEmpresaArq)+'/'+ AllTrim(cFilialArq)+'/'+ AllTrim(cPI_Mat)+" - Funcionแrio nใo encontrado. Registros de Banco de Horas nใo foram importados."
			       //U_RIM01ERR(cDescErro)
			       aAdd(aErro,cDescErro)
		     ENDIF


    ENDIF
    IF ((cEmpOrigem <> cEmpresaArq) .OR. (cFilialOrigem <> cFilialArq))  .AND. lIncluiu == .F.
	   	    cDescErro := "Banco de Horas cujo c๓digo da empresa/filial igual a " + alltrim(cEmpresaArq)+'/'+alltrim(cFilialArq)+" nใo foram importados."
	   	    //U_RIM01ERR(cDescErro)
	   	    aAdd(aErro,cDescErro)
	   ENDIF

    cEmpOrigem := cEmpresaArq
    cFilialOrigem  := cFilialArq
    FT_FSKIP()
 ENDDO
 U_RIM01ERA(aErro)
 //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 //ณ Libera o arquivo                                                    ณ
 //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
 FT_FUSE()

RETURN

