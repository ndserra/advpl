#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjDicSeq  บAutor  ณPablo Gollan Carreras บ Data ณ  31/05/10   บฑฑ4
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCitrino                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AjDicSeq()

Local aAreaSM0		:= SM0->(GetArea())
Local cServer		:= GetServerIP()
Local cTOP			:= IIf(Empty(GetSrvProfString("TopDataBase","")),"MSSQL", GetSrvProfString("TopDataBase","")) + "/" + GetSrvProfString("TopALIAS","")
Local nLink			:= 0 
Local cArqTrab		:= ""
Local oDlg
Local oBotao01
Local oMarca
Local lMarca		:= .F.
Local oEtq01
Local cArq			:= ""
Local aCampos		:= {}
Local aCamposBrw	:= {}
Local nOpca			:= 0
Local lInverte		:= .F.
Local lRet			:= .F.
Local ni			:= 0
Local cLogin		:= "Administrador" //"microsiga"
Local cPWD			:= "1" //"totvs"
Local aEmpAtiva		:= {cEmpAnt, cFilAnt}
Local cModAtivo		:= cModulo
Local aErro			:= {}
Local oAjSX3
Local oTAjSX3
Local aCamposSX3	:= {{"E5_SEQ",0},{"EV_SEQ",0},{"EZ_SEQ",0},{"EF_SEQUENC",0},{"E3_SEQ",0},{"E1_SEQBX",0},{"E2_SEQBX",0},{"FQ_SEQORI",0},{"FQ_SEQDES",0}}

Private cRotina	:= "AjSeqBx"
Private cAlias		:= "TMP"
Private cMarca		:= GetMark()
Private aEmp		:= {}
Private cTabTMP	:= ""
Private cDir		:= IIf(Right(GetSrvProfString("StartPath",""),1)=="\",GetSrvProfString("StartPath",""),GetSrvProfString("StartPath","")+"\")
Private aTamChv	:= {TamSX3("E5_PREFIXO")[1],TamSX3("E5_NUMERO")[1],TamSX3("E5_PARCELA")[1],TamSX3("E5_TIPO")[1]}
Private aLstArq 	:= {}
Private lJob		:= (Select('SX6') == 0)
Private cTabRefEst	:= Space(50)
Private lAjSX3		:= .F.
Private nTAjSX3	:= TamSX3("E5_SEQ")[1]

#IFNDEF TOP
	MsgAlert("Esta rotina somente funciona com banco de dados relacionais.",cRotina)
	Return Nil
#ELSE
	//Segundo o topico do TDN "TCQUERY - TCQUERY PARA AS400" em ambiente AS/400 o campo R_E_C_N_O_ nao existe, campo fundamental para o processamento
	If Upper(AllTrim(TcSrvType())) == "AS/400" .OR. Upper(AllTrim(TcGetDB())) == "DB2/400"
		MsgAlert("Esta rotina nใo funciona em bases de dados situadas em AS/400!",cRotina)
		Return Nil
	Endif
#ENDIF
If !AmIin(6) .OR. nModulo # 6
	MsgAlert("Esta fun็ใo somente pode ser executada a partir do financeiro!",cRotina)
	Return Nil
Endif       
//Em caso de job, guardar em array as tabelas que estใo sendo utilizadas
If lJob
	For ni := 0 to 200 
		If !Empty(Alias(ni))
			aAdd(aLstArq,Alias(ni))
		Endif  	
	Next ni
Endif
nLink := TcLink(cTOP, cServer)
If nLink < 0
	MsgAlert("Nใo foi possํvel conectar o servidor de banco de dados!",cRotina)
	Return Nil
Endif
dbSelectArea("SM0")
SM0->(dbGoTop())
FechaArqT(cAlias)
//Estrutura do arquivo
aAdd(aCampos,{"SEL","C",2,0})
aAdd(aCampos,{"CODIGO","C",Len(SM0->M0_CODIGO),0})
aAdd(aCampos,{"FILIAL","C",Len(SM0->M0_CODFIL),0})
aAdd(aCampos,{"NOME","C",Len(SM0->M0_NOME),0})
//Campos para o browse
aAdd(aCamposBrw,{"SEL",,"",""})
aAdd(aCamposBrw,{"CODIGO",,"C๓digo","@!"})
aAdd(aCamposBrw,{"FILIAL",,"Filial","@!"})
aAdd(aCamposBrw,{"NOME",,"Empresa","@!"})
//Montando e indexando o arquivo temporario
cArqTrab := CriaTrab(aCampos)
dbUseArea(.T.,,cArqTrab,cAlias,Nil,.F.)
cArqTrab := CriaTrab(Nil,.F.)
IndRegua(cAlias,cArqTrab,"CODIGO+FILIAL",,.F.,"","Processando")
Do While !SM0->(Eof())
	If aScan(aEmp,{|x| x == SM0->M0_CODIGO}) == 0
		RecLock(cAlias,.T.)
		(cAlias)->SEL 		:= Space(Len((cAlias)->SEL))
		(cAlias)->CODIGO 	:= SM0->M0_CODIGO
		(cAlias)->FILIAL 	:= SM0->M0_CODFIL
		(cAlias)->NOME 		:= SM0->M0_NOME
		aAdd(aEmp,SM0->M0_CODIGO)
		MsUnlock(cAlias) 
	Endif
	SM0->(dbSkip())
EndDo   
aEmp := Array(0)
(cAlias)->(dbGoTop())       
RestArea(aAreaSM0)
//Montando a tela para selecao de empresas
oDlg := tDialog():New(200,200,700,600,"Ajuste de campos de sequencia no dicionแrio",,,,,CLR_WHITE,CLR_WHITE,,,.T.)

oEtq01 := tSay():New(03,03,{||"Selecione as empresas desejadas :"},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oMarca := MsSelect():New(cAlias,"SEL",,aCamposBrw,@lInverte,@cMarca,{20,03,180,198})
oMarca:oBrowse:lCanAllmark := .T.
oMarca:oBrowse:lHasMark = .T.
oMarca:bAval := {||	InverteSel(1),oMarca:oBrowse:Refresh(.T.)}
oMarca:oBrowse:bAllMark := { || InverteSel(2),oMarca:oBrowse:Refresh(.T.)}
oMarca:oBrowse:Align := CONTROL_ALIGN_NONE

oAjSX3 := tCheckBox():New(210,03,"Ajustar tamanho do sequencial (E5_SEQ)?",{|| lAjSX3},oDlg,114,010,,;
				{|| IIf(!VldUsoExc(1,aCamposSX3),lAjSX3 := .F.,lAjSX3 := !lAjSX3), oDlg:Refresh()},,/*valid*/,0,/*panelcolor*/,,.T.,"Marque este box caso queira ajustar o tamanho do campo E5_SEQ",,/*when*/)
				
oTAjSX3 := tGet():New(210,120,{|x| If(PCount()>0,nTAjSX3 := x,nTAjSX3)},oDlg,15,10,"99",{|x| VldTAjSX3("E5_SEQ",nTAjSX3)},,,,,,.T.,,,;
				{|| lAjSX3 == .T.},,,,,,,"cTabRefEst")				

Define SButton From 240,03 Type 1 Enable Of oDlg Action (nOpca := 1, oDlg:End())
Define SButton From 240,33 Type 2 Enable Of oDlg Action (nOpca := 2, oDlg:End())

oDlg:Activate(,,,.T.,Nil)
If nOpca # 1
	FechaArqT(cAlias)
	Return Nil
Endif
If lAjSX3
	lAjSX3 := ApMsgYesNo("Tem certeza de que deseja alterar o dicionแrio de dados para os campos de sequencia?",cRotina)
	If lAjSX3
		For ni := 1 to Len(aCamposSX3)
			aCamposSX3[ni][2] := nTAjSX3
		Next ni
	Else
		Return Nil
	Endif
Else
	Return Nil
Endif
(cAlias)->(dbGoTop())
Do While !(cAlias)->(Eof())
	If IsMark("SEL",cMarca)
		aCampos := Array(0)
		For ni := 2 to FCount()
			aAdd(aCampos,(cAlias)->(FieldGet(ni)))
		Next ni         
		aAdd(aCampos,.F.)
		aAdd(aEmp,aCampos)
	Endif
	(cAlias)->(dbSkip())
EndDo               
FechaArqT(cAlias)
If Len(aEmp) == 0
	Return Nil
Endif
If !Empty(cTabRefEst)
	cTabRefEst := AllTrim(cTabRefEst)
Endif
For ni := 1 to Len(aEmp)
	//Caso a empresa - filial ainda nao tenha sido processada
	If !aEmp[ni,Len(aEmp[ni])]
		If lJob
			RpcClearEnv()
			RpcSetType(3)
			RpcSetEnv(aEmp[ni][01],aEmp[ni][01],cLogin,cPWD,"FIN",GetEnvServer(),aLstArq) //,"",{"SE5"}),,,.T.,.T.)
			SetModulo("SIGAFIN","FIN")
			SetHideInd(.T.)
			Sleep(5000)
			__LogSiga := "NNNNNNN"
		Else 
			cEmpAnt	:= aEmp[ni][1]
			cFilAnt	:= aEmp[ni][2]
		Endif
		aErro := Array(0)
		If !Eval({|| IIf(lJob, RpcChkSxs(aEmp[ni][1],@aErro), .T.)})
			Alert("Erro ao tentar abrir os arquivo SXs da empresa (" + aEmp[ni][1] + "):" + CRLF + aErro[1][2])
		Else
			If lJob
				For ni := 1 to Len(aLstArq)
					If Select(aLstArq[ni]) == 0
						ChkFile(aLstArq[ni])
					Endif
				Next ni
			Endif    
			//Processamento do ajustador do SX3
			Processa({|| lRet:=AjustaSX3(aCamposSX3)},cRotina,OemToAnsi("Atualizando dicionario de dados da empresa " + aEmp[ni][1]),.T.)
		Endif
	Endif
Next ni	
If lRet                  
	MsgAlert("Processo de ajuste dos campos de sequencia no dicionario finalizado!",cRotina)
Endif
If lJob
	RpcClearEnv()
	RpcSetEnv(aEmpAtiva[1],aEmpAtiva[2],cLogin,cPWD,cModAtivo,"")
	Sleep(5000)
	__LogSiga := GetMV("MV_LOGSIGA")
	//Carregando as tabelas
	For ni := 1 to Len(aLstArq)            
		If Select(aLstArq[ni]) == 0
			ChkFile(aLstArq[ni])
		Endif
	Next ni	
Else
	cEmpAnt	:= aEmpAtiva[1]
	cFilAnt	:= aEmpAtiva[2]
Endif
	
Return Nil                                                           

/*                                                  	
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFechaArqT บAutor  ณPablo Gollan Carreras บ Data ณ  19/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FechaArqT(cAlias)

If Empty(cAlias)
	Return Nil
Endif
If Select(cAlias) > 0
	dbSelectArea(cAlias)
	dbCloseArea()
	fErase(cAlias + OrdBagExt())
	fErase(cAlias + GetDbExtension())
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInverteSelบAutor  ณPablo Gollan Carreras บ Data ณ  19/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function InverteSel(nOpc)

Local nPosREG	:= (cAlias)->(Recno())
Local lCanc		:= {|| !lJob .AND. AllTrim((cAlias)->CODIGO) # AllTrim(cEmpAnt)}

Do Case
	Case nOpc == 1
		RecLock(cAlias,.F.) 
		If !IsMark("SEL",cMarca)
			If Eval(lCanc)
				MsgAlert("Somente a empresa ativa pode ser selecionada!",cRotina)
			Else
				(cAlias)->SEL := cMarca	
			Endif
		Else
			(cAlias)->SEL := Space(Len((cAlias)->SEL))
		Endif
		MsUnlock(cAlias)
	Otherwise
		(cAlias)->(dbGoTop())
		Do While !(cAlias)->(Eof())
			RecLock(cAlias,.F.)
			If !IsMark("SEL",cMarca)
				If !Eval(lCanc)
					(cAlias)->SEL := cMarca
				Endif
			Else 
				(cAlias)->SEL := Space(Len((cAlias)->SEL))
			Endif          
			MsUnlock(cAlias)
			(cAlias)->(dbSkip())
		Enddo
		(cAlias)->(dbGoTo(nPosREG))
EndCase

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldTAjSX3 บAutor  ณPablo Gollan Carreras บ Data ณ  28/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidar campo de tamanho do SX3                               บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldTAjSX3(cCampo,nTam)

Local lRet		:= .T.
Local nTamPad	:= 0
Local aLimites	:= {2,10}

If Empty(cCampo) .OR. Empty(nTam)
	Return !lRet
Endif
nTamPad := TamSX3(cCampo)[1]
If nTam < nTamPad
	MsgAlert("O tamanho do campo " + cCampo + " nใo pode ser menor que o tamanho atual (" + cValToChar(nTamPad) + ").",cRotina)
	nTAjSX3 := nTamPad
	Return !lRet
Endif
If nTam < aLimites[1]
	MsgAlert("O tamanho do campo " + cCampo + " nใo pode ser menor que o tamanho mํnimo (" + cValToChar(aLimites[1]) + ").",cRotina)
	nTAjSX3 := nTamPad
	Return !lRet
Endif
If nTam > aLimites[2]
	MsgAlert("O tamanho do campo " + cCampo + " nใo pode ser maior que o tamanho mแximo (" + cValToChar(aLimites[2]) + ").",cRotina)
	nTAjSX3 := nTamPad
	Return !lRet
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX3 บAutor  ณPablo Gollan Carreras บ Data ณ  28/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para ajustar o dicionario de dados                     บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSX3(aCampos)

Local aArea		:= GetArea()
Local lRet		:= .T.
Local cAlias	:= ""
Local ni		:= 0

If !lAjSX3 .OR. Len(aCampos) == 0 .OR. !VldUsoExc(1,aCampos)
	Return lRet
Endif                 
ProcRegua(Len(aCampos))
For ni := 1 to Len(aCampos)
	IncProc("Atualizando estrutura da tabela " + cAlias + ".")
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	If SX3->(dbSeek(AllTrim(aCampos[ni][1])))
		RecLock("SX3")
		Replace X3_TAMANHO With aCampos[ni][2]
		MsUnlock()
		cAlias := SX3->X3_ARQUIVO
	Else    
		MsgAlert("O campo " + aCampos[ni][1] + " nใo foi encontrado no dicionario de dados!",cRotina)
		RestArea(aArea)
		Return !lRet
	EndIf
	If ni == 1
		#IFDEF TOP
			TCInternal(5,'*OFF') //-- Desliga Refresh no Lock do Top
		#ENDIF
		__SetX31Mode(.F.)
	Endif
	ChkFile(cAlias)	
	If Select(cAlias) > 0
		dbSelectArea(cAlias)
		dbCloseArea()
	Endif
	X31UpdTable(cAlias)
	If __GetX31Error()
		MsgAlert("Ocorreu um erro na atualiza็ใo da tabela (" + cAlias + ") : " + CRLF + __GetX31Trace(),cRotina)
		lRet := .F.
	Endif             
Next ni	
RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldUsoExc บAutor  ณPablo Gollan Carreras บ Data ณ  29/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para verificar se as tabelas que serao atualizadas     บฑฑ
ฑฑบ          ณestao permitindo o acesso exclusivo.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldUsoExc(nOpc,aCampos)

Local aArea		:= GetArea()
Local lRet		:= .T.
Local ni		:= 0

lMSHelpAuto := .T.
dbSelectArea("SX3")
SX3->(dbSetOrder(2))
For ni := 1 to Len(aCampos)
	If SX3->(dbSeek(aCampos[ni][1]))
		TcRefresh(SX3->X3_ARQUIVO)
		If !ChkFile(SX3->X3_ARQUIVO,.T.)
			If nOpc == 1    
				MsgAlert("Impossํvel marcar esta op็ใo, pois a tabela a ser alterada (" + SX3->X3_ARQUIVO + ") nใo pode ser aberta em modo EXCLUSIVO.",cRotina)
			Endif
			lRet := !lRet
			Exit
		Else 
			//Desbloqueio depois da validacao
			dbSelectArea(SX3->X3_ARQUIVO)
			dbCloseArea()
			ChkFile(SX3->X3_ARQUIVO,.F.)
		Endif
	Endif
Next ni
RestArea(aArea)
lMSHelpAuto := .F.

Return lRet