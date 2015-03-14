#include "fileio.ch"
#Include "protheus.ch"
#Include "folder.ch"
#Include "tbiconn.ch"
#Include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบMetodo    RHIMP09Dependente บAutor  ณRafael Luis da Silvaบ Data ณ 24/02/2010 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel em Processar a Importacao dos dependentes para a 	  บฑฑ
ฑฑบ          ณTabela SRB.                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณIntegracao do Modulo de RH dos Sistemas Logix X Protheus.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณfName  - Nome do Arquivo 						                 		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RHIMP09Dependente(fName)
Local cBuffer       := ""
Local lIncluiu   	:= .F.
Local nPosIni       := 0
Local nPosFim       := 0
Local nPosFimFilial := 0
Local nCount        := 0
Local nlidos        := 0
Local cEmpAux	    := ""
Local cFilAux       := ""
Local cEmpresaArq   := ""
Local cFilialArq    := ""
Local cEmpOrigem    := "00"
Local cFilialOrigem := "00"
Local aCampos       := {}
Local aItens        := {}
Local aCab			:= {}
Local cRB_mat		:= ""
Local cRB_cod		:= ""
Local cDescErro		:= ""
Local lExtAux       := .F.
LOCAL cRB_mat_ant := "00"
PRIVATE aErro := {}
PRIVATE  lMsErroAuto   := .F.
PRIVATE lAutoErrNoFile := .T.

   nCount := U_RIM01Line(fName)

    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณ Numero de registros a importar                                      ณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    ProcRegua(nCount)


    FT_FUSE(fName)
    FT_FGOTOP()

    lExiste:= .T.
    While !FT_FEOF()
    	 cBuffer := FT_FREADLN()

	     nPosFimFilial := At("|", cBuffer)
	     cEmpresaArq   := Substr(cBuffer, 1, nPosFimFilial - 1)

     	nPosIni := nPosFimFilial
     	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
    	 nPosFim := At("|", cBuffer)

	cFilialArq := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

	If Empty(cFilialArq)
		cFilialArq := "  "
	EndIf

	If cEmpresaArq <> cEmpOrigem .OR. cFilialArq <> cFilialOrigem

		If !Empty(aItens) //Se mudou a empresa ou filial e existir dados, efetua gravacao
			fGrvSRB(aCab,aItens,lExtAux)
			aItens	:= {}
			aCab	:= {}
			lExtAux := .F.
		EndIf

         lExiste:= .F.
    	    dbSelectArea("SM0")
         dbGoTop()

         RpcClearEnv()
         OpenSm0Excl()
		While ! Eof()
			cEmpAux := SM0->M0_CODIGO
			cFilAux := SM0->M0_CODFIL

			IF cEmpAux ==  cEmpresaArq .AND. (Empty(cFilialArq) .OR. cFilialArq == cFilAux)
				lExiste = .T.
				SM0->(dbSkip())
				EXIT
			EndIf
			SM0->(dbSkip())
		EndDo

		If lExiste == .T.
			RpcSetType(3)
			PREPARE ENVIRONMENT EMPRESA (cEmpAux) FILIAL (cFilAux) MODULO "GPE" USER "ADMIN" FUNNAME "GPEA020"
			CHKFILE("SRJ")
			CHKFILE("RCC")
			CHKFILE("SRB")
		Else
			lIncluiu := .F.
			cDescErro := "Dependentes cujo c๓digo da empresa igual a " + AllTrim(cEmpresaArq)+'/'+ AllTrim(cFilialArq)+" nใo foram importados."
			//U_RIM01ERR(cDescErro)
			aAdd(aErro,cDescErro)
		EndIf
	EndIf

	If lExiste == .T.

		   nPosIni := At("|", cBuffer)
		   cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		   nPosFim := At("|", cBuffer)

		   //Caso tenha alterado o funcionario e existir dados em aItens, efetua gravacao
		   If !(cRB_mat  == Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))) .and. !Empty(aItens)
		   	fGrvSRB(aCab,aItens,lExtAux)
		   	aItens	:= {}
		   	aCab	:= {}
		   	lExtAux := .F.
		   EndIf

		   aCampos := {}

            //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	       	   //ณ Incrementa a regua                                                  ณ
		          //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	       	   nlidos += 1
           	lIncluiu := .T.

		   If 1 == nPosFimFilial
		   	aAdd(aCampos,{'RB_FILIAL','',NIL})
		   Else
		   	aAdd(aCampos,{'RB_FILIAL',SubStr(cFilialArq,1,FWGETTAMFILIAL),NIL}) //Garanto o tamanho correto da filial
		   EndIf

		   cRB_mat  := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))

		   If (nPosIni + 1) == nPosFim
		   	aAdd(aCampos,{'RB_MAT',"",NIL})
		   ELSE
		      DbSelectArea("SRA")
     		 DbSetOrder(1)

     		 If !DbSeek(xFilial('SRA') + cRB_mat)
     		    IF cRB_mat_ant <> cRB_mat
              cDescErro := "Dependente " + AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+AllTrim(cRB_mat)+ " - Nใo foram gerados os registros de dependentes do funcionแrio. Necessแrio exportar o cad. de funcionแrios."
		   	        aAdd(aErro,cDescErro)
		   	     ENDIF
		   	     lIncluiu := .F.
     		 ELSE
     		    aAdd(aCampos,{'RB_MAT',cRB_mat,NIL})



		          nPosIni := At("|", cBuffer)
		          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		          nPosFim := At("|", cBuffer)

		          cRB_cod  := Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))
		          cRB_cod  := StrZero(Val(cRb_cod),2)

		          If (nPosIni + 1) == nPosFim
		          	aAdd(aCampos,{'RB_COD',"",NIL})
		          Else
		          	aAdd(aCampos,{'RB_COD',cRB_cod,NIL})
		          EndIf

		          nPosIni := At("|", cBuffer)
		          cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
		          nPosFim := At("|", cBuffer)

		          If TAMSX3("RB_NOME")[1] < Len(Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1)))
		          	cDescErro := "Dependente " + AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+AllTrim(cRB_mat)+'/'+AllTrim(cRb_cod) + " - Nใo foi importado. Alterar o tamanho do campo Nome no Configurador. Tam. Protheus: " + ALLTRIM(AllToChar(TAMSX3("RB_NOME")[1])) + " Tam. Sist. Ext: " + AllTrim(AlltoChar(Len(Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))))) + "."
		          	//U_RIM01ERR(cDescErro)
		          	aAdd(aErro,cDescErro)
		          	lIncluiu := .F.
		          EndIf

		          If (nPosIni + 1) == nPosFim
		          	aAdd(aCampos,{'RB_NOME',"",NIL})
		          Else
		          	aAdd(aCampos,{'RB_NOME',Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1)),NIL})
		          EndIf                                                                                                                                                                                                                                                                                                                                                                                     )
          /*-----------------------------------------------------------------------*/


	          	nPosIni := At("|", cBuffer)
	          	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          	nPosFim := At("|", cBuffer)

	          	If (nPosIni + 1) == nPosFim
			             aAdd(aCampos,{'RB_DTNASC',CtoD(""),NIL})
	          	Else
               aAdd(aCampos,{'RB_DTNASC',CtoD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
	          	EndIf
              /*-----------------------------------------------------------------------*/


	          	nPosIni := At("|", cBuffer)
	          	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          	nPosFim := At("|", cBuffer)

	          	If (nPosIni + 1) == nPosFim
	              aAdd(aCampos,{'RB_SEXO',"",NIL})
          		Else
	          	   aAdd(aCampos,{'RB_SEXO',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	          	EndIf
              /*-----------------------------------------------------------------------*/


	          	nPosIni := At("|", cBuffer)
	          	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          	nPosFim := At("|", cBuffer)

	          	If (nPosIni + 1) == nPosFim
	              aAdd(aCampos,{'RB_GRAUPAR',"",NIL})
	          	Else
               aAdd(aCampos,{'RB_GRAUPAR',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	          	EndIf
              /*-----------------------------------------------------------------------*/


	          	nPosIni := At("|", cBuffer)
	          	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          	nPosFim := At("|", cBuffer)

	          	If (nPosIni + 1) == nPosFim
	              aAdd(aCampos,{'RB_TIPIR',"",NIL})
	          	Else
	          		  aAdd(aCampos,{'RB_TIPIR',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	          	EndIf
            /*-----------------------------------------------------------------------*/

            nPosIni := At("|", cBuffer)
	          	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          	nPosFim := At("|", cBuffer)

	          	If (nPosIni + 1) == nPosFim
	              aAdd(aCampos,{'RB_TIPSF',"",NIL})
	          	Else
	          		  aAdd(aCampos,{'RB_TIPSF',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
		          EndIf
	          	/*-----------------------------------------------------------------------*/

	          	nPosIni := At("|", cBuffer)
	          	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          	nPosFim := At("|", cBuffer)

	          	If (nPosIni + 1) == nPosFim
	              	aAdd(aCampos,{'RB_LOCNASC',"",NIL})
		          Else
		            	If TAMSX3("RB_LOCNASC")[1] < Len(Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1)))
		            		cDescErro := "Dependente " + AllTrim(cEmpresaArq)+'/'+AllTrim(cFilialArq)+'/'+AllTrim(cRB_mat)+'/'+AllTrim(cRb_cod) + " - Nใo foi importado a descri็ใo do Municํpio de Nascimento. Alterar o tamanho do campo no Configurador. Tam. Protheus: " + ALLTRIM(AllToChar(TAMSX3("RB_LOCNASC")[1])) + " Tam. Sist. Ext: " + AllTrim(AlltoChar(Len(Substr(cBuffer, nPosIni + 1, nPosFim  - (nPosIni + 1))))) + "."
		            		aAdd(aErro,cDescErro)
		            		//U_RIM01ERR(cDescErro)
		            	Else
		            		aAdd(aCampos,{'RB_LOCNASC',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
		            	EndIf
		          EndIf

	          	nPosIni := At("|", cBuffer)
	          	cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	          	nPosFim := At("|", cBuffer)

	          	If (nPosIni + 1) == nPosFim
	              	aAdd(aCampos,{'RB_CARTORI',"",NIL})
	          	Else
	          	    aAdd(aCampos,{'RB_CARTORI',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	          	EndIf
			        /*-----------------------------------------------------------------------*/


	      	    nPosIni := At("|", cBuffer)
	      	    cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      	    nPosFim := At("|", cBuffer)

	      	    If (nPosIni + 1) == nPosFim
	              aAdd(aCampos,{'RB_NREGCAR',"",NIL})
		          Else
	      	       aAdd(aCampos,{'RB_NREGCAR',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	      	    EndIf
			        /*-----------------------------------------------------------------------*/


	      	    nPosIni := At("|", cBuffer)
	      	    cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      	    nPosFim := At("|", cBuffer)

	      	    If (nPosIni + 1) == nPosFim
	              aAdd(aCampos,{'RB_NUMLIVR',"",NIL})
		          Else
	      	       aAdd(aCampos,{'RB_NUMLIVR',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	      	    EndIf
			        /*-----------------------------------------------------------------------*/

	      	    nPosIni := At("|", cBuffer)
	      	    cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      	    nPosFim := At("|", cBuffer)

	      	    If (nPosIni + 1) == nPosFim
	              aAdd(aCampos,{'RB_NUMFOLH',"",NIL})
		          Else
	      	       aAdd(aCampos,{'RB_NUMFOLH',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	      	    EndIf
			        /*-----------------------------------------------------------------------*/

	      	    nPosIni := At("|", cBuffer)
	      	    cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      	    nPosFim := At("|", cBuffer)

	      	    If (nPosIni + 1) == nPosFim
			            aAdd(aCampos,{'RB_DTENTRA',CtoD(""),NIL})
		          Else
	      	       aAdd(aCampos,{'RB_DTENTRA',CtoD(Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1))),NIL})
	      	    EndIf
			        /*-----------------------------------------------------------------------*/
	      	    nPosIni := At("|", cBuffer)
	      	    cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      	    nPosFim := At("|", cBuffer)

	      	    If (nPosIni + 1) == nPosFim
	              aAdd(aCampos,{'RB_NUMAT ',"",NIL})
		          Else
	      	       aAdd(aCampos,{'RB_NUMAT ',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	      	    EndIf
		      	  /*-----------------------------------------------------------------------*/

	      	    nPosIni := At("|", cBuffer)
	      	    cBuffer := Stuff(cBuffer, nPosIni, 1, ";")
	      	    nPosFim := At("|", cBuffer)

	      	    If (nPosIni + 1) == nPosFim
	              aAdd(aCampos,{'RB_CIC',"",NIL})
		           Else
	      	       aAdd(aCampos,{'RB_CIC',Substr(cBuffer, nPosIni + 1, nPosFim - (nPosIni + 1)),NIL})
	      	    EndIf
			        /*-----------------------------------------------------------------------*/


	      	    MSUnLock()
	           IncProc()

		          If !lExtAux
			            dbSelectArea("SRB")
			            dbSetOrder(1)
			            // Temos que definir qual a opera็ใo deseja: 3 – Inclusใo / 4 – Altera็ใo / 5 - Exclusใo
			            If DbSeek(xFilial("SRB") + aCampos[2,2])
			              	lExtAux = .T. //Se existir dados da SRB, deve alterar
			            EndIf
		          EndIf

		          IF lIncluiu
		            	aAdd(aItens, aCampos)
			aCab := { {"RA_FILIAL", aCampos[1,2], NIL},{"RA_MAT"	, cRB_mat + Space(TAMSX3('RA_MAT')[1]-Len(cRb_mat)) , NIL} }
		          ENDIF

     		ENDIF



		   EndIf

  ENDIF

  cRB_mat_ant  := cRB_mat
	 cEmpOrigem 		:= cEmpresaArq
	 cFilialOrigem 	:= cFilialArq

	 FT_FSKIP()

ENDDO
  //caso exista dados em aItens, efetua gravacao
  IF !Empty(aItens)
    	fGrvSRB(aCab,aItens,lExtAux)
    	lExtAux := .F.
  ENDIF

  U_RIM01ERA(aErro)
 //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
 //ณ Libera o arquivo                                                    ณ
 //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
 FT_FUSE()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvSRB   บAutor  ณLeandro Drumond     บ Data ณ  11/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua gravacao dos dependentes                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RHIMP09                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fGrvSRB(aCampos,aItens,lExtAux)

Begin Transaction
 lMsErroAuto := .F.

	If lExtAux
		MSExecAuto({|x,y,w,z| GPEA020(x,y,w,z)},Nil,aCampos,aItens,4)
	Else
		MSExecAuto({|x,y,w,z| GPEA020(x,y,w,z)},Nil,aCampos,aItens,3)
	EndIf

	/*If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		lMsErroAuto := .F.
		break
	EndIf*/
	If lMsErroAuto
   	DisarmTransaction()
    //lMsErroAuto := .F.
   	//lErroAuto := .T.
   		aLog := GetAutoGrLog()

   		Aeval(aLog, { |x| aAdd(aErro, x)  } )
  ENDIF

End Transaction

Return Nil