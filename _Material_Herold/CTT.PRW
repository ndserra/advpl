#INCLUDE "Totvs.ch"
#INCLUDE "Totvswebsrv.ch"
#INCLUDE "Tbiconn.ch"

WsService CTT description "Treinamento do WebService para o Curso CTT"

Wsdata cCodEmp		as String      				// codigo da empresa 
Wsdata aEmpresa	as array of  EstruturaEmp	// estrutura inteira do sigamat.emp
Wsdata cRet			as String					   // Mensagem de Retorno
WSDATA CREGSA1		as string 	               // RETORNO DA MENSAGEM DO EXECAUTO
WSDATA CCPF			as string	               // VARIAVEL PARA RECEBER O CPF DO CLIENTE "CONFERENCIA SE JA EXISTE""
WSDATA ACLIENTE	as CLIENTES                // ESTRUTURA DE DADOS RECEBIDOS DO CLIENTE
WsData _cEmp		as String
WsData _cFil		as String

WsMethod LISTAEMPRESA DESCRIPTION "APRESENTA TODOS OS DADOS DO SIGAMAT.EMP DO CLIENTE" 
WsMethod GRAVACLIENTE DESCRIPTION "GRAVACAO DE CLIENTE NO PROTHEUS" 

EndWsservice

//+----------------------------------------------+
//|Estrutura para apresentar no retorno do array |
//+----------------------------------------------+

WsStruct EstruturaEmp
WsData	M0_CODIGO	as String
WsData	M0_CODFIL	as String
WsData	M0_FILIAL	as String
WsData	M0_NOME		as String
WsData	M0_NOMECOM	as String
WsData	M0_ENDCOB	as String
WsData	M0_CIDCOB	as String
WsData	M0_ESTCOB	as String
WsData	M0_CEPCOB	as String
WsData	M0_ENDENT	as String
WsData	M0_CIDENT	as String
WsData	M0_ESTENT	as String
WsData	M0_CEPENT	as String
WsData	M0_CGC		as String
WsData	M0_INSC		as String
WsData	M0_TEL		as String
WsData	M0_EQUIP	   as String
WsData	M0_SEQUENC	as String
WsData	M0_DOCSEQ	as Integer
WsData	M0_FAX		as String
WsData	M0_PRODRUR	as String
WsData	M0_BAIRCOB	as String
WsData	M0_BAIRENT	as String
WsData	M0_COMPCOB	as String
WsData	M0_COMPENT	as String
WsData	M0_TPINSC	as Integer
WsData	M0_CNAE		as String
WsData	M0_FPas		as String
WsData	M0_ACTRAB	as String
WsData	M0_CODMUN	as String
WsData	M0_NATJUR	as String
WsData	M0_DTBasE	as String
WsData	M0_NUMPROP	as Integer
WsData	M0_MODEND	as String
WsData	M0_MODINSC	as String
WsData	M0_CAUSA		as String
WsData	M0_INSCANT	as String
WsData	M0_TEL_IMP	as String
WsData	M0_FAX_IMP	as String
WsData	M0_TEL_PO	as String
WsData	M0_FAX_PO	as String
WsData	M0_IMP_CON	as String
WsData	M0_CODZOSE	as String
WsData	M0_DESZOSE	as String
WsData	M0_COD_ATV	as String
WsData	M0_INS_SUF	as String
WsData	M0_EMERGEN	as String
WsData	M0_LIBMOD	as String
WsData	M0_TPESTAB	as String
WsData	M0_DTAUTOR	as Date
WsData	M0_EMPB2B	as String
WsData	M0_CAIXA		as String
WsData	M0_LICENSA	as String
WsData	M0_CORPKEY	as String
WsData	M0_CHKSUM	as Integer
WsData	M0_DTVLD		as Date
WsData	M0_PSW		as String
WsData	M0_CTPSW		as String
WsData	M0_INTCTRL	as String
WsData	M0_INSCM		as String
WsData	M0_NIRE		as String
WsData	M0_DTRE		as date
WsData	M0_CNES		as String
WsData	M0_PSWSTRT	as String
WsData	M0_DSCCNA	as String
WsData	M0_asSPAT1	as String
WsData	M0_asSPAT2	as String
WsData	M0_asSPAT3	as String
WsData	M0_SIZEFIL	as integer
WsData	M0_LEIAUTE	as String
WsData	M0_PICTURE	as String
WsData	M0_STATUS	as String
WsData	M0_RNTRC		as String
WsData	M0_DTRNTRC	as Date
WsData	X_MENSAGEM	as String
EndWsStruct


//+------------------------------------------------------+
//| criação da estrutura de recebimentos de dados        |
//| do cliente sobre a importação de cadastro de cliente |
//+------------------------------------------------------+

WsStruct CLIENTES

WsData	A1_COD	 	 as	String
WsData	A1_LOJA	 	 as	String
WsData	A1_PESSOA	 as	String
WsData	A1_NOME	 	 as	String
WsData	A1_NREDUZ	 as	String
WsData	A1_END	 	 as	String
WsData	A1_TIPO	 	 as	String
WsData	A1_EST	 	 as	String
WsData	A1_MUN	    as	String

EndWsStruct

//+------------------------------------------------------+
//| Lista a empresa para apresentar ao cliente           |
//+------------------------------------------------------+

WsMethod LISTAEMPRESA WsReceive cCodEmp WsSend aEmpresa WsService CTT
Local cEmp		:= "99" 
Local cFil		:= "01"
Local aTab		:= {"SA1"}
Local aRet		:= {}
Local nDados	:= 0
RpcSetEnv(cEmp,cFil,,,'FIN','ListEmpresa',aTab)//abre a conexão com o banco e a empresa padrão

if cCodEmp != 'Abrir'
	::cRet := "Palavra Chave Invalida"
	aadd(aEmpresa,WsClassNew("EstruturaEmp"))
	aEmpresa[1]:M0_CODIGO	 := ""
	aEmpresa[1]:M0_CODFIL	 := ""
	aEmpresa[1]:M0_FILIAL	 := ""
	aEmpresa[1]:M0_NOME	 	 := ""
	aEmpresa[1]:M0_NOMECOM	 := ""
	aEmpresa[1]:M0_ENDCOB	 := ""
	aEmpresa[1]:M0_CIDCOB	 := ""
	aEmpresa[1]:M0_ESTCOB	 := ""
	aEmpresa[1]:M0_CEPCOB	 := ""
	aEmpresa[1]:M0_ENDENT	 := ""
	aEmpresa[1]:M0_CIDENT	 := ""
	aEmpresa[1]:M0_ESTENT	 := ""
	aEmpresa[1]:M0_CEPENT	 := ""
	aEmpresa[1]:M0_CGC	 	 := ""
	aEmpresa[1]:M0_INSC	 	 := ""
	aEmpresa[1]:M0_TEL	 	 := ""
	aEmpresa[1]:M0_EQUIP	 	 := ""
	aEmpresa[1]:M0_SEQUENC	 := ""
	aEmpresa[1]:M0_DOCSEQ	 := 0
	aEmpresa[1]:M0_FAX	 	 := ""
	aEmpresa[1]:M0_PRODRUR	 := ""
	aEmpresa[1]:M0_BAIRCOB	 := ""
	aEmpresa[1]:M0_BAIRENT	 := ""
	aEmpresa[1]:M0_COMPCOB	 := ""
	aEmpresa[1]:M0_COMPENT	 := ""
	aEmpresa[1]:M0_TPINSC	 := 0
	aEmpresa[1]:M0_CNAE	 	 := ""
	aEmpresa[1]:M0_FPas	 	 := ""
	aEmpresa[1]:M0_ACTRAB	 := ""
	aEmpresa[1]:M0_CODMUN	 := ""
	aEmpresa[1]:M0_NATJUR	 := ""
	aEmpresa[1]:M0_DTBasE	 := ""
	aEmpresa[1]:M0_NUMPROP	 := 0
	aEmpresa[1]:M0_MODEND	 := ""
	aEmpresa[1]:M0_MODINSC	 := ""
	aEmpresa[1]:M0_CAUSA	 	 := ""
	aEmpresa[1]:M0_INSCANT	 := ""
	aEmpresa[1]:M0_TEL_IMP	 := ""
	aEmpresa[1]:M0_FAX_IMP	 := ""
	aEmpresa[1]:M0_TEL_PO	 := ""
	aEmpresa[1]:M0_FAX_PO	 := ""
	aEmpresa[1]:M0_IMP_CON	 := ""
	aEmpresa[1]:M0_CODZOSE	 := ""
	aEmpresa[1]:M0_DESZOSE	 := ""
	aEmpresa[1]:M0_COD_ATV	 := ""
	aEmpresa[1]:M0_INS_SUF	 := ""
	aEmpresa[1]:M0_EMERGEN	 := ""
	aEmpresa[1]:M0_LIBMOD	 := ""
	aEmpresa[1]:M0_TPESTAB	 := ""
	aEmpresa[1]:M0_DTAUTOR	 := STOD("")
	aEmpresa[1]:M0_EMPB2B	 := ""
	aEmpresa[1]:M0_CAIXA	 	 := ""
	aEmpresa[1]:M0_LICENSA	 := ""
	aEmpresa[1]:M0_CORPKEY	 := ""
	aEmpresa[1]:M0_CHKSUM	 := 0
	aEmpresa[1]:M0_DTVLD	 	 := STOD("")
	aEmpresa[1]:M0_PSW	 	 := ""
	aEmpresa[1]:M0_CTPSW	 	 := ""
	aEmpresa[1]:M0_INTCTRL	 := ""
	aEmpresa[1]:M0_INSCM	 	 := ""
	aEmpresa[1]:M0_NIRE	 	 := ""
	aEmpresa[1]:M0_DTRE	 	 := STOD("")
	aEmpresa[1]:M0_CNES	 	 := ""
	aEmpresa[1]:M0_PSWSTRT	 := ""
	aEmpresa[1]:M0_DSCCNA	 := ""
	aEmpresa[1]:M0_asSPAT1	 := ""
	aEmpresa[1]:M0_asSPAT2	 := ""
	aEmpresa[1]:M0_asSPAT3	 := ""
	aEmpresa[1]:M0_SIZEFIL	 := 0
	aEmpresa[1]:M0_LEIAUTE	 := ""
	aEmpresa[1]:M0_PICTURE	 := ""
	aEmpresa[1]:M0_STATUS	 := ""
	aEmpresa[1]:M0_RNTRC	 	 := ""
	aEmpresa[1]:M0_DTRNTRC	 := STOD("")
	aEmpresa[1]:X_MENSAGEM 	 := ::cRet
	Return (.T.)
EndIf

aRet		:= SM0->(GETAREA())

While SM0->( ! EOF() ) 
	nDados	+= 1
	aadd( aEmpresa,WsClassNew( "EstruturaEmp" ) )
	aEmpresa[nDados]:M0_CODIGO	 := SM0->M0_CODIGO
	aEmpresa[nDados]:M0_CODFIL	 := SM0->M0_CODFIL
	aEmpresa[nDados]:M0_FILIAL	 := SM0->M0_FILIAL
	aEmpresa[nDados]:M0_NOME	 := SM0->M0_NOME
	aEmpresa[nDados]:M0_NOMECOM := SM0->M0_NOMECOM
	aEmpresa[nDados]:M0_ENDCOB	 := SM0->M0_ENDCOB
	aEmpresa[nDados]:M0_CIDCOB	 := SM0->M0_CIDCOB
	aEmpresa[nDados]:M0_ESTCOB	 := SM0->M0_ESTCOB
	aEmpresa[nDados]:M0_CEPCOB	 := SM0->M0_CEPCOB
	aEmpresa[nDados]:M0_ENDENT	 := SM0->M0_ENDENT
	aEmpresa[nDados]:M0_CIDENT	 := SM0->M0_CIDENT
	aEmpresa[nDados]:M0_ESTENT	 := SM0->M0_ESTENT
	aEmpresa[nDados]:M0_CEPENT	 := SM0->M0_CEPENT
	aEmpresa[nDados]:M0_CGC	 	 := SM0->M0_CGC
	aEmpresa[nDados]:M0_INSC	 := SM0->M0_INSC
	aEmpresa[nDados]:M0_TEL	 	 := SM0->M0_TEL
	aEmpresa[nDados]:M0_EQUIP	 := SM0->M0_EQUIP
	aEmpresa[nDados]:M0_SEQUENC := SM0->M0_SEQUENC
	aEmpresa[nDados]:M0_DOCSEQ	 := SM0->M0_DOCSEQ
	aEmpresa[nDados]:M0_FAX	 	 := SM0->M0_FAX
	aEmpresa[nDados]:M0_PRODRUR := SM0->M0_PRODRUR
	aEmpresa[nDados]:M0_BAIRCOB := SM0->M0_BAIRCOB
	aEmpresa[nDados]:M0_BAIRENT := SM0->M0_BAIRENT
	aEmpresa[nDados]:M0_COMPCOB := SM0->M0_COMPCOB
	aEmpresa[nDados]:M0_COMPENT := SM0->M0_COMPENT
	aEmpresa[nDados]:M0_TPINSC	 := SM0->M0_TPINSC
	aEmpresa[nDados]:M0_CNAE	 := SM0->M0_CNAE
	aEmpresa[nDados]:M0_FPas	 := SM0->M0_FPas
	aEmpresa[nDados]:M0_ACTRAB	 := SM0->M0_ACTRAB
	aEmpresa[nDados]:M0_CODMUN	 := SM0->M0_CODMUN
	aEmpresa[nDados]:M0_NATJUR	 := SM0->M0_NATJUR
	aEmpresa[nDados]:M0_DTBasE	 := SM0->M0_DTBasE
	aEmpresa[nDados]:M0_NUMPROP := SM0->M0_NUMPROP
	aEmpresa[nDados]:M0_MODEND	 := SM0->M0_MODEND
	aEmpresa[nDados]:M0_MODINSC := SM0->M0_MODINSC
	aEmpresa[nDados]:M0_CAUSA	 := SM0->M0_CAUSA
	aEmpresa[nDados]:M0_INSCANT := SM0->M0_INSCANT
	aEmpresa[nDados]:M0_TEL_IMP := SM0->M0_TEL_IMP
	aEmpresa[nDados]:M0_FAX_IMP := SM0->M0_FAX_IMP
	aEmpresa[nDados]:M0_TEL_PO	 := SM0->M0_TEL_PO
	aEmpresa[nDados]:M0_FAX_PO	 := SM0->M0_FAX_PO
	aEmpresa[nDados]:M0_IMP_CON := SM0->M0_IMP_CON
	aEmpresa[nDados]:M0_CODZOSE := SM0->M0_CODZOSE
	aEmpresa[nDados]:M0_DESZOSE := SM0->M0_DESZOSE
	aEmpresa[nDados]:M0_COD_ATV := SM0->M0_COD_ATV
	aEmpresa[nDados]:M0_INS_SUF := SM0->M0_INS_SUF
	aEmpresa[nDados]:M0_EMERGEN := SM0->M0_EMERGEN
	aEmpresa[nDados]:M0_LIBMOD	 := SM0->M0_LIBMOD
	aEmpresa[nDados]:M0_TPESTAB := SM0->M0_TPESTAB
	aEmpresa[nDados]:M0_DTAUTOR := SM0->M0_DTAUTOR
	aEmpresa[nDados]:M0_EMPB2B	 := SM0->M0_EMPB2B
	aEmpresa[nDados]:M0_CAIXA	 := SM0->M0_CAIXA
	aEmpresa[nDados]:M0_LICENSA := SM0->M0_LICENSA
	aEmpresa[nDados]:M0_CORPKEY := SM0->M0_CORPKEY
	aEmpresa[nDados]:M0_CHKSUM	 := SM0->M0_CHKSUM
	aEmpresa[nDados]:M0_DTVLD	 := SM0->M0_DTVLD
	aEmpresa[nDados]:M0_PSW	 	 := SM0->M0_PSW
	aEmpresa[nDados]:M0_CTPSW	 := SM0->M0_CTPSW
	aEmpresa[nDados]:M0_INTCTRL := SM0->M0_INTCTRL
	aEmpresa[nDados]:M0_INSCM	 := SM0->M0_INSCM
	aEmpresa[nDados]:M0_NIRE	 := SM0->M0_NIRE
	aEmpresa[nDados]:M0_DTRE	 := SM0->M0_DTRE
	aEmpresa[nDados]:M0_CNES	 := SM0->M0_CNES
	aEmpresa[nDados]:M0_PSWSTRT := SM0->M0_PSWSTRT
	aEmpresa[nDados]:M0_DSCCNA	 := SM0->M0_DSCCNA
	aEmpresa[nDados]:M0_asSPAT1 := SM0->M0_asSPAT1
	aEmpresa[nDados]:M0_asSPAT2 := SM0->M0_asSPAT2
	aEmpresa[nDados]:M0_asSPAT3 := SM0->M0_asSPAT3
	aEmpresa[nDados]:M0_SIZEFIL := SM0->M0_SIZEFIL
	aEmpresa[nDados]:M0_LEIAUTE := SM0->M0_LEIAUTE
	aEmpresa[nDados]:M0_PICTURE := SM0->M0_PICTURE
	aEmpresa[nDados]:M0_STATUS	 := SM0->M0_STATUS
	aEmpresa[nDados]:M0_RNTRC	 := SM0->M0_RNTRC
	aEmpresa[nDados]:M0_DTRNTRC := SM0->M0_DTRNTRC
	aEmpresa[nDados]:X_MENSAGEM := "Sucesso "+strzero(nDados,2)
	SM0->(dbSkip())
EndDo

RestArea(aRet)

Return( .T. )


//+------------------------------------------------------+
//| criação do webService para a gravação do Cliente     |       
//| usando ExecAuto                                      |
//+------------------------------------------------------+

WSMETHOD GRAVACLIENTE WSRECEIVE ACLIENTE,CCPF,_cEmp,_cFil  WSSEND CREGSA1 WSSERVICE CTT

Local cEmp		:= _cEmp
Local cFil		:= _cFil
Local aTab		:= {"SA1"}
Local cPdCpf    := ""
Local aDat		:= {}
Local asa1Stru	:= {}
Local aComplem	:= {}
Local cCodigo	:= ""
Local cLoja		:= ""
Local NOPC		:= 3
Local bQuery 		:= {|X| Iif(Select(X) > 0, (X)->(dbCloseArea()), Nil),;
						dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),X,.F.,.T.),;
						dbSelectArea(X),;
						(X)->(dbGoTop())}
Private lMsErroauto		:= .f.
Private lMsHelpAuto		:= .f.
Private lautoErrNoFile	:= .T.
conout('empresa')
conout(_cEmp)
conout(valtype(_cEmp))
conout('filial')
conout(valtype(_cFil))
RpcSetEnv(cEmp,cFil,,,'FIN','ListEmpresa',aTab)//abre a conexão com o banco e a empresa padrão

cPdCpf		:= tamsx3("A1_CGC")[1]

//--Cria estrutura de retorno
::ACLIENTE := WsClassNew( 'CLIENTES' )

DBSELECTAREA("SA1") 
SA1->(DBSETORDER(3))

IF SA1->(DBSEEK(XFILIAL("SA1")+PADR(CCPF,cPdCpf)))
	NOPC	:= 4
	cCodigo	:= SA1->A1_COD
	cLoja	:= SA1->A1_LOJA
ENDIF


//+------------------------------------------------------+
//| iniciando a gravação do cadastro do cliente			   |       
//+------------------------------------------------------+

AADD( asa1Stru,{ 'A1_COD'   ,		"C",6,0  } )
AADD( asa1Stru,{ 'A1_LOJA'  ,		"C",2,0  } )
AADD( asa1Stru,{ 'A1_PESSOA',		"C",10,0 } )
AADD( asa1Stru,{ 'A1_NOME'  ,		"C",50,0 } )
AADD( asa1Stru,{ 'A1_NREDUZ',		"C",40,0 } )
AADD( asa1Stru,{ 'A1_END'   ,		"C",50,0 } )
AADD( asa1Stru,{ 'A1_TIPO'  ,		"C",60,0 } )
AADD( asa1Stru,{ 'A1_EST'   ,		"C",60,0 } )
AADD( asa1Stru,{ 'A1_MUN'   ,		"C",10,0 } )

                                                          
//+-----------------------------------------------------------------------+
//|Analisa se existe outros campos obrigatorio que não estava na estrutura|       
//|campo adicionado posteriormente a sua criação do web services          |
//+-----------------------------------------------------------------------+


SX3->(DBSETORDER(1))
SX3->(DBSEEK("SA1"))
WHILE SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == "SA1"
   	IF ascan(asa1Stru,{|X| alltrim(x[1]) == alltrim(SX3->X3_CAMPO)})=0 .AND. X3OBRIGAT(SX3->X3_CAMPO) //ANALISA SE E OBRIGATORIO E SE NÃO ESTA NA LISTA
  		AADD(aComplem,{alltrim(SX3->X3_CAMPO),SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL})  // CAMPO ADICIONADO
   	ENDIF
   	SX3->(DBSKIP())
END

//+-----------------------------------+
//|Regra de gravação do Array Recebido|       
//+-----------------------------------+
aEval(asa1Stru,{|x| ;
   			aadd(aDat,{	x[1],;
				iif(valtype(&('ACLIENTE:'+x[1]))!="U",&('ACLIENTE:'+x[1]),;
					iif(x[2]=='C',CRIAVAR(x[1]),;
						iif(x[2]=='D',DATE(),;
							iif(x[2]=='N',1,;
								iif(x[2]=='L',.F.," "))))) ,;
				nil });
				})



//+---------------------------------------------+
//|Tratamento para os campos que passaram a ser |
//|obrigatorio apos a criação do WebService     |       
//+---------------------------------------------+

aEval(aComplem,{|x| aadd(aDat,{	x[1],CRIAVAR(x[1]),nil })	})

//+--------------------------------------------------+
//|Regra de identificação dos campos para adicionar  |
//|informações proprias do Sistema                   |
//+--------------------------------------------------+

nA1COD 	:= ascan(adat,{|x| alltrim(x[1])== 'A1_COD'})
nA1LOJ 	:= ascan(adat,{|x| alltrim(x[1])== 'A1_LOJA'})

if nA1COD > 0 
	IF NOPC ==3
		cCodigo := GETSXENUM("SA1","A1_COD")
		CONFIRMSX8()
		cLoja	:= "01"
    ENDIF
	ADAT[nA1COD][2] 	:= cCodigo
	ADAT[nA1LOJ][2] 	:= cLoja
ENDIF


nA1EST		:= ascan(adat,{|x| alltrim(x[1])== 'A1_EST'})
nA1MUN		:= ascan(adat,{|x| alltrim(x[1])== 'A1_MUN'})

SX3->(DBSETORDER(2))
For nFor := 1 to len(aDat)
	  if empty(aDat[nFor][2])
	  	SX3->(DBSEEK(aDat[nFor][1]))
	  	aDat[nFor][2] := &(SX3->X3_RELACAO)
	  endif
Next nFor


//+----------------------+
//|Normalizando os Dados |
//+----------------------+

aDeletar := {}
For nFor2 := 1 to len(adat)
	if VALTYPE(adat[nFor2])<> "U"
		nLin	:= ascan(asa1Stru,{|x| alltrim(x[1]) == alltrim(adat[nFor2][1])})
		if  nLin<= 0 .OR. EMPTY(adat[nFor2][2])
			aadd(aDeletar,nFor2)
		else
			if valtype(adat[nFor2][2]) != asa1Stru[nLin][2]
				if empty(adat[nFor2][2])
					do case
						case  asa1Stru[nLin][2] == 'D'
							adat[nFor2][2] := stod('')
						case  asa1Stru[nLin][2] == 'N'
							adat[nFor2][2] := 0
						case  asa1Stru[nLin][2] == 'C'
							adat[nFor2][2] := padr(" ",TAMSX3(adat[nFor2][1])[1])
						case  asa1Stru[nLin][2] == 'L'
							adat[nFor2][2] := .F.
						case  asa1Stru[nLin][2] == 'M'
							adat[nFor2][2] := " "
					endcase
				else
					do case
						case  asa1Stru[nLin][2] == 'D'
							adat[nFor2][2] := iif(empty(stod(adat[nFor2][2])),ctod(adat[nFor2][2]),stod(adat[nFor2][2]))
						case  asa1Stru[nLin][2] == 'N'
							adat[nFor2][2] := VAL(adat[nFor2][2])
						case  asa1Stru[nLin][2] == 'C'
							adat[nFor2][2] := cValtochar(adat[nFor2][2])
						case  asa1Stru[nLin][2] == 'L'
							adat[nFor2][2] := iif(upper(adat[nFor2][2])=='.F.',.f.,.t.)
						case  asa1Stru[nLin][2] == 'M'
							adat[nFor2][2] := cValtochar(adat[nFor2][2])
					endcase
				endif
			ELSE
				IF valtype(adat[nFor2][2]) == 'C'
					adat[nFor2][2] := PADR(adat[nFor2][2],TAMSX3(adat[nFor2][1])[1])
				ENDIF
			endif
		endif
	endif
Next nfor2


FOR nFor2 := len(aDeletar) to 1 step -1
	adel(aDat,aDeletar[nFor2])
next nFor2


aDat := asize(aDat,len(aDat)-len(aDeletar))
DBSELECTAREA("SA1")
nQtdDel := 0

BeginTran()

MSEXECAUTO( {|X,Y| MATA030(X,Y) },adat,NOPC)


IF lMsErroauto
	nPx := 0
	DisarmTransaction()
	aAutoErro	:= GETAUTOGRLOG()
	cMsg := ""
	IF LEN(aAutoErro)>=2
		cCpox := '- '+alltrim(substr(aAutoErro[1],at('_',aAutoErro[1])-2,10))
		nPx		:= ascan(aAutoErro,{|W| cCpox$W })
		if nPx<=0
			nPx		:= ascan(aAutoErro,{|W| '< -- '$W })
		endif
	ENDIF
	nTotV := iif(len(aAutoErro)>20,20,len(aAutoErro))
	For nFor1 := 1 to nTotV
		if !empty(alltrim(STRTRAN(STRTRAN(aAutoErro[nFor1],"'",'"'),'---','')))
			cMsg		+= alltrim(STRTRAN(STRTRAN(aAutoErro[nFor1],"'",'"'),'---',''))+CRLF
		endif
	nExt nfor1
	if nPx>0
		cMsg		+= alltrim(STRTRAN(STRTRAN(aAutoErro[nPx],"'",'"'),'---',''))+CRLF
	endif
	::CREGSA1:= "ERRO AO GRAVAR O CLIENTE:"+CRLF+cMsg
ELSE
	EndTran()
	::CREGSA1:= "SUCESSO CODIGO DO CLIENTE:"+cCodigo
ENDIF

RETURN .T.