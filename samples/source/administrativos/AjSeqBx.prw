#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.ch"

#DEFINE nTamNomeArq		21

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjSeqBx   บAutor  ณPablo Gollan Carreras บ Data ณ  19/04/10   บฑฑ4
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para ajustar o sequencial do SE5                     บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCitrino                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AjSeqBx()

Local aAreaSM0		:= SM0->(GetArea())
Local cServer		:= IIf(Empty(GetSrvProfString("TopServer","")),GetServerIP(), GetSrvProfString("TopServer","")) 
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
Local oTabRefEst
Local oAjSX3
Local oTAjSX3
Local oFilOr       
Local oAjSeqBX           
Local oAjTabDep    
Local oGLOG
Local aMens			:= {}                                   
Local cMens			:= ""
Local aCamposSX3	:= {{"E5_SEQ",0},{"EV_SEQ",0},{"EZ_SEQ",0},{"EF_SEQUENC",0},{"E3_SEQ",0},{"E1_SEQBX",0},{"E2_SEQBX",0},{"FQ_SEQORI",0},{"FQ_SEQDES",0},;
						{"FIP_SEQBX",0},{"FIS_SEQBX",0}}

Private cRotina	:= "AjSeqBx"
Private cAlias		:= "TMP"
Private cMarca		:= GetMark()
Private aEmp		:= {}
Private cTabTMP	:= ""
Private aInterChv	:= {}	//Intervalos de variacoes dos tamanhos dos campos envolvidos na composicao do E5_DOCUMEN
Private aTipoTit	:= {}	//Lista dos tipos de titulos
Private aREGProc	:= {}
Private cDir		:= IIf(Right(GetSrvProfString("StartPath",""),1)=="\",GetSrvProfString("StartPath",""),GetSrvProfString("StartPath","")+"\")
Private cArqLOG	:= ""
Private aTipoDoc 	:= {"CP","BA","VL","V2","LJ"/*,"ES"*/}
Private aTamChv	:= {TamSX3("E5_PREFIXO")[1],TamSX3("E5_NUMERO")[1],TamSX3("E5_PARCELA")[1],TamSX3("E5_TIPO")[1]}
Private aLstArq 	:= {}
Private lJob		:= (Select('SX6') == 0)
Private nTamSeq	:= TamSX3("E5_SEQ")[1]
Private cTabRefEst	:= Space(50)
Private lUsaTabSec	:= .F.
Private lSomaPad	:= .T.
Private lAjSX3		:= .F.
Private nTAjSX3	:= TamSX3("E5_SEQ")[1]
Private lFilOr		:= .F.
Private lAjSeqBx	:= .F.
Private lAjTabDep	:= .F. 
Private lGLOG		:= .T.
Private aLstFilial	:= {}
Private nContGRVArq:= 0
Private cSeqZer	:= Replicate("0",nTamSeq)

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
oDlg := tDialog():New(200,200,IIf(AllTrim(PtGetTheme()) $ "MDI/TEMAP10",692,687),600,"Ajuste de sequ๊ncia de movimentos de baixas",,,,,CLR_WHITE,CLR_WHITE,,,.T.)

oEtq01 := tSay():New(03,03,{||"Selecione as empresas desejadas :"},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oMarca := MsSelect():New(cAlias,"SEL",,aCamposBrw,@lInverte,@cMarca,{13,03,135,198})
oMarca:oBrowse:lCanAllmark := .T.
oMarca:oBrowse:lHasMark = .T.
oMarca:bAval := {||	InverteSel(1),oMarca:oBrowse:Refresh(.T.)}
oMarca:oBrowse:bAllMark := { || InverteSel(2),oMarca:oBrowse:Refresh(.T.)}
oMarca:oBrowse:Align := CONTROL_ALIGN_NONE

oGroup:= tGroup():New(138,03,230,198,"Opera็๕es",oDlg,0,,.T.)

oAjSeqBX := tCheckBox():New(151,06,"Ajustar a sequencia de baixa do SE5 (E5_SEQ)?",{|| lAjSeqBx},oDlg,150,010,,;
				{|| lAjSeqBx := !lAjSeqBx,If(!lAjSeqBx,Eval({|| cTabRefEst := Space(50)}),Eval({|| lAjTabDep := .T.})),oDlg:Refresh()},,;
				/*valid*/,0,/*panelcolor*/,,.T.,"Marque este box caso queira ajustar o E5_SEQ",,/*when*/)

oFilOr := tCheckBox():New(161,06,"Ajustar o campo de filial de origem (E5_FILORIG)?",{|| lFilOr},oDlg,135,010,,;
				{|| lFilOr := !lFilOr},,/*valid*/,0,/*panelcolor*/,,.T.,"Marque este box caso queira validar e ajustar o campo E5_FILORIG",,{|| .T.})

oAjTabDep := tCheckBox():New(171,06,"Ajustar a sequencia das tabelas dependentes?",{|| lAjTabDep},oDlg,150,010,,;
				{|| lAjTabDep := !lAjTabDep, oDlg:Refresh()},,/*valid*/,0,/*panelcolor*/,,.T.,"Marque este box caso queira ajustar as tabelas dependentes",,{|| !lAjSeqBx})

oAjSX3 := tCheckBox():New(181,06,"Ajustar tamanho do sequencial (E5_SEQ)?",{|| lAjSX3},oDlg,114,010,,;
				{|| IIf(!VldUsoExc(1,aCamposSX3),lAjSX3 := .F.,lAjSX3 := !lAjSX3), oDlg:Refresh()},,/*valid*/,0,/*panelcolor*/,,.T.,"Marque este box caso queira ajustar o tamanho do campo E5_SEQ",,/*when*/)

oTAjSX3 := tGet():New(181,123,{|x| If(PCount()>0,nTAjSX3 := x,nTAjSX3)},oDlg,15,10,"99",{|x| VldTAjSX3("E5_SEQ",nTAjSX3)},,,,,,.T.,,,;
				{|| lAjSX3 == .T.},,,,,,,"nTAjSX3")				

oGLOG := tCheckBox():New(191,06,"Gerar LOG das opera็๕es?",{|| lGLOG},oDlg,90,010,,;
				{|| lGLOG := !lGLOG},,/*valid*/,0,/*panelcolor*/,,.T.,"Marque este box caso queira gerar LOG das opera็๕es",,/*when*/)

oEtq01 := tSay():New(206,06,{||"Tabela de refer๊ncia para processamento, caso nใo seja a padrใo :"},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,190,10)
oTabRefEst := tGet():New(214,06,{|x| If(PCount()>0,cTabRefEst := x,cTabRefEst)},oDlg,190,10,"@!",{|x| VldTab(cTabRefEst)},,,,,,.T.,,,{|| lAjSeqBx},,,,,,,"cTabRefEst")

Define SButton From 233,03 Type 1 Enable Of oDlg Action (nOpca := 1, oDlg:End())
Define SButton From 233,33 Type 2 Enable Of oDlg Action (nOpca := 2, oDlg:End())

oDlg:Activate(,,,.T.,Nil)
If nOpca # 1
	FechaArqT(cAlias)
	Return Nil
Endif
If !lAjSeqBx .AND. !lAjTabDep .AND. !lAjSX3 .AND. !lFilOr
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
If lAjSeqBx
	aAdd(aMens,"Reprocessar toda a seqüencia da tabela SE5?")
Endif                 
If lFilOr
	aAdd(aMens,"Reprocessar a filial de origem?")
Endif                                                                                  
If lAjTabDep
	aAdd(aMens,"Reprocessar toda a seqüencia das tabelas dependentes?")
Endif
If lAjSX3
	aAdd(aMens,"Alterar o dicionแrio de dados para os campos de seqüencia?")
Endif
Eval({|| ni := 0, aEval(aMens,{|x| ni++, cMens += Space(3) + cValToChar(ni) + ". " + x + CRLF}), cMens := "Deseja realmente : " + CRLF + cMens})
If !ApMsgYesNo(cMens,cRotina)
	Return Nil
Endif
If lAjSX3
	For ni := 1 to Len(aCamposSX3)
		aCamposSX3[ni][2] := nTAjSX3
	Next ni
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
			lRet := .T.
			If lJob
				For ni := 1 to Len(aLstArq)
					If Select(aLstArq[ni]) == 0
						ChkFile(aLstArq[ni])
					Endif
				Next ni
			Endif    
			//Se for processar a validacao do campo E5_FILORIG, montar array com as filiais da empresa processada                            
			If lFilOr
				aLstFilial := RetQtdeFil(aEmp[ni][1])
			Endif
			If lAjSX3
				//Processamento do ajustador do SX3
				Processa({|| lRet:=AjustaSX3(aCamposSX3)},cRotina,OemToAnsi("Atualizando dicionario de dados da empresa " + aEmp[ni][1]),.T.)
				If lRet 
					//Obter o novo tamanho do campo SX3, usar o Posicione pois o TamSX3 nao se atualiza
					nTamSeq	:= Posicione("SX3",2,"E5_SEQ","X3_TAMANHO")
				Endif				
			Endif                             
			If lRet .AND. (lAjSeqBx .OR. lFilOr)
				Processa({|lFim| lRet:=AjSeqBxProc(aEmp[ni][1]/*,aEmp[ni][2]*/,@lFim)},cRotina,OemToAnsi("Processando empresa " + aEmp[ni][1] /*+ "-" + aEmp[ni][2]*/),.T.)
				If !lRet
					MsgAlert("Problemas no processamento da empresa : " + CRLF + aEmp[ni][1] + "-" + aEmp[ni][2] + "  " + Upper(aEmp[ni][3]),cRotina)
				Else
					If TotREGTab(cTabTMP) > 0
						//Finalizando processo da empresa
						If lAjSeqBx  
							cMens := "ษ aconselhแvel que a tabela SE5 nใo esteja sendo utilizada na finaliza็ใo do processo, por favor, certifique-se." + CRLF
							cMens += "Deseja realmente substituir a SE5 atual pela tabela temporแria? (Caso a resposta seja SIM, a SE5 original por seguran็a serแ copiada. "
							cMens += "Caso seja NรO, a tabela original serแ mantida e a temporแria estarแ disponํvel no SGBD (SE5XX0_TMP))"
						Else
							cMens := "Gravar o ajuste do campo E5_FILORIG na tabela SE5 ativa?"
						Endif
						If ApMsgYesNo(cMens,cRotina)
							Processa({|| lRet:=ProcFinal("SE5",aEmp[ni][1])},cRotina,OemToAnsi("Finalizando processo da empresa " + aEmp[ni][1]),.F.)
							If !lRet
								MsgAlert("Problemas na finaliza็ใo do processo da empresa : " + CRLF + aEmp[ni][1] + "  " + Upper(aEmp[ni][3]),cRotina)
							Endif
						Endif
					Else
						MsgAlert("Aviso : nenhum registro foi alterado, nใo foram necessแrios ajustes.",cRotina)
					Endif
				Endif
			Endif
		Endif
	Endif
Next ni	
If lRet
	If lAjTabDep
		AjTabFilha()
	Endif          
	If lAjSeqBx .OR. lAjTabDep .OR. lAjSX3 .OR. lFilOr
		MsgAlert("Processo concluido!",cRotina)
	Endif
Else
	MsgAlert("Processo foi interrompido pela ocorr๊ncia de erro(s)!",cRotina)
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjSeqBxProcบAutor  ณPablo Gollan Carreras บ Data ณ  19/04/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                               บฑฑ
ฑฑบ          ณ                                                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjSeqBxProc(cEmp,lFim)

Local lRet			:= .T.
Local cAlias		:= GetNextAlias()
Local nTotREG		:= 0
Local ni			:= 0
Local nx			:= 0
Local nPos			:= 0
Local aEstru		:= {}
Local cQry			:= ""
Local nCampos		:= 0
Local cArqTMP		:= ""
Local aCmpAlter		:= {}
Local cSeqBx		:= ""
Local cSeqBx02		:= ""
Local cSeqBxTMP		:= ""
Local nTamTit		:= 0
Local nTamTit02		:= 0
Local cTipoDoc		:= ""
Local cTitCmp		:= ""
Local cTitCmpTMP	:= ""
Local cTipoTit		:= ""
Local nREGAtu		:= 0
Local nREGTmp		:= 0
Local aTotTam		:= 0
Local lOk			:= .F.
Local lAltera		:= .F.
Local aSeqCMP		:= {}
Local aAreaSE5 		:= SE5->(GetArea())
Local aREGPAT		:= {}
Local cFil			:= ""
Local nContRP		:= 0
Local aREGEstor 	:= {}
Local aREGNGS		:= {}
Local aREGNGS02		:= {}
Local cCabecLOG		:= "FILIAL | PREFIXO | NUMERO     | PARCELA | TIPO | TIPODOC | CLIFOR | LOJA | SEQ.ORIG. | SEQ.PROX. | SEQ.GRAV. | RECNO    | E5_DOCUMEN "
Local aCabecLOG		:= {7,9,12,9,6,9,8,6,11,11,11,10,TamSX3("E5_DOCUMEN")[1]}
Local cSeqBxID		:= ""
Local lGrvSBID		:= .F.
Local cSeqBxIDOri	:= ProxSEQID(2)
Local cSeqBxIDIni	:= ""
Local cSeqBxIDCont	:= ""
Local nMargem		:= 10
Local cSeqTMP		:= ""
Local nUltRegTS		:= 0

Static nVerLRP		:= 3000
Static nRetRP		:= 200	//Limite minimo para indicar a sequencia de continuidade de reprocessamento

ProxSEQID(1,@cSeqBxIDCont)
If Empty(cEmp)
	Return !lRet
Endif        
If !MsFile("SE5" + cEmp + "0",Nil, __cRDD)
	Return !lRet
Endif
dbSelectArea("SE5")
aEstru := SE5->(dbStruct())
nCampos := Len(aEstru)
//Remover os campos de somente visualizacao
dbSelectArea("SX3")
SX3->(dbSetOrder(2))
For ni := 1 to nCampos
	If SX3->(dbSeek(aEstru[ni][1]))
		If SX3->X3_CONTEXT == "V"
			aDel(aEstru,ni)
			nCampos--
		Endif
	Else 
		aDel(aEstru,ni)
		nCampos--
	Endif
Next ni
//Marcar empresa como processada
nPos := aScan(aEmp, {|x| x[1] == cEmp})
If nPos > 0
	aEmp[nPos,Len(aEmp[1])] := .T.
Endif
If SX2Modo("SE5") == "C"
	cFil := Space(TamSX3("E5_FILIAL")[1])
Endif
//Pesquisar por movimentos que possuam compensa็๕es
/*cQry := "SELECT * "
cQry += "FROM " + RetSqlName("SE5") + " "
cQry += "WHERE ((E5_FILIAL = '" + cFil + "') AND (D_E_L_E_T_ <> '*')) "
cQry +=	"ORDER BY R_E_C_N_O_ ASC "                                                                  
cQry := ChangeQuery(cQry)
dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAlias,.T.,.T.)
For ni := 1 to Len(aEstru)
	If aEstru[ni,2] # "C"
		TcSetField(cAlias,aEstru[ni,1],aEstru[ni,2],aEstru[ni,3],aEstru[ni,4])
	Endif
Next ni*/
FechaArqT(cAlias)                             
//Alias para pesquisa na compensacao
ChkFile("SE5",.F.,"__SUB")
dbSelectArea("__SUB")
__SUB->(dbSetOrder(2))

//Se o processamento for por uma tabela estabelecida (nao padrao), configurar o alias de processameno para utilizar esta tabela secundaria
//Tabela temporaria utilizada (temp = tab. secundaria + diferenca da tab. atual SE5)
If !Empty(cTabRefEst)
	Processa({|| lRet := ProcTabSec(cAlias,aEstru)},cRotina,OemToAnsi("Mont. arq. para processamento de tab. secundแria"),.T.)
	If !lRet
		Return !lRet
	Endif
Endif

//Alias para realizar a varredura no SE5
If !lUsaTabSec
	ChkFile("SE5",.F.,cAlias)
Endif
dbSelectArea(cAlias)
(cAlias)->(dbSetOrder(0)) //Recno
(cAlias)->(dbGoTop())
//Caso necessario, totalizar registros
nTotREG := (cAlias)->(RecCount())
If (!(cAlias)->(Eof()) .AND. nTotREG == 0) .OR. lUsaTabSec
	If nTotREG == 0
		(cAlias)->(dbEval({|| nTotREG++}))
	Endif
	If lUsaTabSec
		If (cAlias)->(Eof())
			(cAlias)->(dbSkip(-1))
		Else
			(cAlias)->(dbGoBottom())
		Endif
		nUltRegTS := (cAlias)->(Recno())
	Endif
	(cAlias)->(dbGoTop())
Endif
If nTotREG == 0
	MsgAlert("A empresa (" + cEmp + ") nao possui registros na base!",cRotina)
	AjSeqBxAlias(cAlias,aAreaSE5)
	Return lRet
Endif
//Clonar a estrutura da tabela de movimentos que recebera os dados do novo processamento
If !ClonarTab("SE5",cEmp)
	AjSeqBxAlias(cAlias,aAreaSE5)
	Return !lRet		
Endif
//Montando a lista de variacoes de chaves
Processa({|| MLInterChv("SE5", nTotREG)},cRotina,"Mont. a lista de var. de chaves da empresa (" + cEmp + ")",.F.)
If Valtype(aTipoTit) # "A" .OR. Len(aTipoTit) == 0
	AjSeqBxAlias(cAlias,aAreaSE5)
	Return !lRet	
Endif
If nTotREG > 0
	ProcRegua(nTotREG)
	//Posicionar no ultimo registro processado, caso se tenha optado pela continuidade de processamento
	(cTabTMP)->(dbGoTop())
	If !(cTabTMP)->(Eof())
		(cTabTMP)->(dbGoBottom())
		Do While !(cTabTMP)->(Bof())
			nContRP++
			If nContRP <= nVerLRP
				aAdd(aREGProc,(cTabTMP)->(Recno()))
			Endif
			IncProc()
			(cTabTMP)->(dbSkip(-1))
		EndDo
		nREGAtu := 0
		//Verif. se o ultimo registro eh realmente o ponto de reinicializacao ou se eh preciso retroceder para encontrar o ultimo registro que respeite a seq. do recno
		aSort(aREGProc,,,{|x,y| x < y}) //Ordem crescente
		nContRP := Len(aREGProc)
		If nContRP > nRetRP
			For ni := nContRP to 1 Step -1
				nREGTmp := aREGProc[ni]
				lOk := .T.
				For nx := 1 to nRetRP
					//Se chegou no final do arquivo
					If (ni - nx) <= 0
						lOk := .F.
						Exit
					Endif
					//Se a diferenca for maior que 1, descaracteriza continuidade, entao invalidar numero
					If (nREGTmp - aREGProc[ni - nx]) > 1
						lOk := .F.
						Exit
					Endif
					//Armazenar registro para proxima comparacao
					nREGTmp := aREGProc[ni - nx]
				Next nx 
				//Se o recno pertencer a uma sequencia minima continua, trata-se do ultimo recno valido, ponto inicial para o reprocessamento
				If lOK
					nREGAtu := aREGProc[ni]
					If ApMsgYesNo("Confirma que o registro " + cValToChar(nREGAtu) + " como ponto de partida para o reprocessamento?",cRotina)
						Exit
					Else
						nREGAtu := 0
					Endif
				Endif
			Next ni 
		Endif
		(cTabTMP)->(dbGoTop())
		If Empty(nREGAtu)
			nREGAtu := (cTabTMP)->(Recno())
		Endif
		(cAlias)->(dbGoTo(nREGAtu))
		//Reinicializando variaveis utilizadas
		nREGAtu := 0
		nREGTmp	:= 0		
		nContRP := 0
		lOk		:= .F.
	Endif
Endif   
//Agregar margem de seguranca ao codigo de sequencia do E5_IDENTEE
For ni := 1 to nMargem Step 1
	cSeqBxIDCont := Soma1(cSeqBxIDCont,6)	
Next ni
cSeqBxIDIni := cSeqBxIDCont
//Inicio do laco de processamento
Do While !(cAlias)->(Eof())
	If lFim
		lRet := .F.
		Exit       
	Endif                                                                      
	IncProc()
	nContRP++
	If nContRP >= nVerLRP
		AjustaLRP() 	//Descartar registros no array aREGProc depois exceder o limite determinado, para evitar lentidใo no processamento
		nContRP := 0
	Endif
	aCmpAlter	:= {}
	cFil		:= (cAlias)->E5_FILIAL		
	cSeqBx 		:= ""
	cSeqBx02	:= ""
	cSeqBxTMP	:= ""
	lAltera		:= .F.
	aSeqCMP		:= {}
	aREGPAT		:= {}
	aREGEstor	:= {}
	aSize(aREGEstor,2)
	aREGNGS		:= {}
	aREGNGS02	:= {}
	cSeqBxID	:= ""
	lGrvSBID 	:= .F.
	cSeqTMP		:= ""
	cFilTMP		:= ""
	nREGTmp		:= 0

    //Se o registro jah estiver gravado, verificar o campo E5_FILORIG e depois saltar
	If ExREGTMP((cAlias)->(Recno())) .OR. (cAlias)->(Deleted())
		//Se estiver ativa a validacao do FILORIG, verificar a sua consistencia e em caso de falha buscar o titulo em outras filiais da empresa
		If lFilOr .AND. !Empty((cAlias)->E5_FILORIG) .AND. !Empty((cAlias)->(E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO)) .AND. !(cAlias)->(Deleted())
			cFilTMP := AllTrim(RetFilCorr((cAlias)->E5_FILORIG,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,;
						(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_RECPAG,.T.))
							
			If cFilTMP # AllTrim((cAlias)->E5_FILORIG)
				If !GrvFilOr(cAlias,nCampos,aEstru,cFilTMP,cCabecLOG,aCabecLOG,cFil)
					AjSeqBxAlias(cAlias,aAreaSE5)
					Return !lRet
				Endif
			Endif
		Endif
		If lUsaTabSec .AND. lAjSeqBx
			If (cAlias)->(Recno()) == nUltRegTS
				(cAlias)->(dbSkip())
				AtTabSec(cAlias,nUltRegTS)
			Else
				(cAlias)->(dbSkip())
			Endif
		Else
			(cAlias)->(dbSkip())
		Endif
		Loop
	Else
		//Se estiver ativa a validacao do FILORIG, verificar a sua consistencia e em caso de falha buscar o titulo em outras filiais da empresa
		If lFilOr .AND. !Empty((cAlias)->E5_FILORIG) .AND. !Empty((cAlias)->(E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO))
			cFilTMP := AllTrim(RetFilCorr((cAlias)->E5_FILORIG,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,;
						(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_RECPAG,.T.))
							
			If cFilTMP # AllTrim((cAlias)->E5_FILORIG)
				If !GrvFilOr(cAlias,nCampos,aEstru,cFilTMP,cCabecLOG,aCabecLOG,cFil) 
					AjSeqBxAlias(cAlias,aAreaSE5)
					Return !lRet
				Endif
			Endif
		Endif
	Endif
	//Se nao for para fazer o processamento da sequencia de baixa, saltar
	If !lAjSeqBx
		aAdd(aREGProc,(cAlias)->(Recno()))
		(cAlias)->(dbSkip())
		Loop	
	Endif
		
	If !Empty((cAlias)->E5_SEQ) .OR. (!Empty((cAlias)->(E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO)) .AND. AllTrim((cAlias)->E5_TIPO) $ "CP/BA/VL/V2/LJ")
		If Empty((cAlias)->(E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO))
			//Se o movimento nao for baseado em titulo e a sequencia estiver com tamanho identico ao padrao, manter o registro inalterado
			If Len(AllTrim((cAlias)->E5_SEQ)) # nTamSeq
				aCmpAlter := {{"E5_SEQ",PadL(AllTrim((cAlias)->E5_SEQ),nTamSeq,"0")}}
				If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
					AjSeqBxAlias(cAlias,aAreaSE5)						
					Return !lRet
				Endif
			Else
				If !GrvRegMov(1, cAlias, nCampos, aEstru)
					AjSeqBxAlias(cAlias,aAreaSE5)		
					Return !lRet			
				Endif                                    
			Endif
		Else
			If !AllTrim((cAlias)->E5_MOTBX) == "CMP"
				//Se a compensacao for de estorno, gravar o movimento (se nao gravado), mas nao alterar a sequencia pois 
				//eh tarefa do titulo que gerou o estorno
				If (cAlias)->E5_TIPODOC == "ES"                         
					If !ExREGTMP((cAlias)->(Recno()))
						//Gravar o titulo com o E5_SEQ vazio, pois que deve sequencia-lo eh o titulo pai
						aCmpAlter := {{"E5_SEQ",""}}
						If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
							AjSeqBxAlias(cAlias,aAreaSE5)						
							Return !lRet
						Endif
					Endif
				Else			
					nREGAtu := (cAlias)->(Recno())
					cSeqBx := ProxSeqBx(cTabTMP, 	{cFil,;
										(cAlias)->E5_PREFIXO,;
										(cAlias)->E5_NUMERO,;
										(cAlias)->E5_PARCELA,;
										(cAlias)->E5_TIPO,;
										(cAlias)->E5_CLIFOR,;
										(cAlias)->E5_LOJA,;
										(cAlias)->E5_TIPODOC})
					
					//Verificar se o titulo processado possui um estorno associado
					If AllTrim((cAlias)->E5_TIPODOC) # "ES"
						aREGEstor[1] := TemMovEst("__SUB", (cAlias)->E5_FILIAL, (cAlias)->E5_PREFIXO, (cAlias)->E5_NUMERO, (cAlias)->E5_PARCELA, (cAlias)->E5_TIPO, ;
							(cAlias)->E5_DATA, (cAlias)->E5_CLIFOR, (cAlias)->E5_LOJA, (cAlias)->E5_SEQ,  (cAlias)->E5_RECPAG, (cAlias)->E5_MOTBX, (cAlias)->E5_VALOR)
	        		Endif
	        		//Verificar se o titulo possui outros movimentos associados (exceto)
					aREGNGS := LevOutDoc("__SUB", (cAlias)->E5_FILIAL, (cAlias)->E5_TIPODOC, (cAlias)->E5_PREFIXO, (cAlias)->E5_NUMERO, (cAlias)->E5_PARCELA, ;
						(cAlias)->E5_TIPO, 	(cAlias)->E5_DATA, (cAlias)->E5_CLIFOR, (cAlias)->E5_LOJA, (cAlias)->E5_SEQ,  (cAlias)->E5_RECPAG, (cAlias)->(Recno()))
	        		If !Empty(cSeqBx)
	        			cSeqBx := Substr(cSeqBx,1,nTamSeq)
						If cSeqBx # (cAlias)->E5_SEQ
							lAltera := .T.
						Endif
						//Verificar se nao houve estouro da capacidade da sequencia, indicado pelo valor preenchido com '0' e alertar via arquivo de LOG
						If cSeqBx == cSeqZer
							WriteLOG("**** ALERTA! ESTOURO DA CAPACIDADE DO E5_SEQ - VIDE REGISTRO AFETADO LOGO ABAIXO. ****")
							lAltera := .T.
							//Forcar a gravacao do 00, para identificar o estouro de sequencia
							cSeqBx := cSeqZer
							If (cAlias)->E5_MOTBX # "CEC"
								cSeqBxID := ProxSEQID(1,@cSeqBxIDCont)
							Endif
						Endif								
						If lAltera      
							//Caso tenha havido estouro de sequencia e nao for CEC, gravar sequencia com 00 e agregar uma sequencia no E5_IDENTEE
							If !Empty(cSeqBxID)
								aCmpAlter := {{"E5_SEQ",cSeqBx},{"E5_IDENTEE",cSeqBxID}}
								lGrvSBID := .T.
							Else
								aCmpAlter := {{"E5_SEQ",cSeqBx}}
							Endif
							If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
								AjSeqBxAlias(cAlias,aAreaSE5)						
								Return !lRet
							Endif
							If lGLOG
								WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
								MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
										(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,cSeqBx,cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.F.,"|")
								WriteLOG(IIf(!Empty(aREGEstor[1]) .OR. Len(aREGNGS) > 0," ",Replicate("-",150)))
							Endif
						Else 
							If !GrvRegMov(1, cAlias, nCampos, aEstru)
								AjSeqBxAlias(cAlias,aAreaSE5)						
								Return !lRet			
							Endif									
						Endif 
						
						//Caso existam, gravar outros tipos de documentos contidos no movimento alinhado com s sequencia do 'pai'
						If Len(aREGNGS) > 0
							For ni := 1 to Len(aREGNGS)
								//Posicionar
								(cAlias)->(dbGoTo(aREGNGS[ni]))
								If lAltera
									If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
										AjSeqBxAlias(cAlias,aAreaSE5)						
										Return !lRet
									Endif  
									If lGLOG
										WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
										MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
											(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,cSeqBx,cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.F.,"|")
										WriteLOG(IIf(ni < Len(aREGNGS), IIf(!Empty(aREGEstor[1]), " ", Replicate("-",150)),Replicate("-",150)))
									Endif
								Else 
									If !GrvRegMov(1, cAlias, nCampos, aEstru)
										AjSeqBxAlias(cAlias,aAreaSE5)						
										Return !lRet			
									Endif																	
								Endif
								aAdd(aREGPAT,(cAlias)->(Recno()))
							Next ni
							(cAlias)->(dbGoTo(nREGAtu))
						Endif						
						
						//Caso exista, gravar o movimento de estorno
						If !Empty(aREGEstor[1])
							(cAlias)->(dbGoTo(aREGEstor[1]))
							If lAltera
								If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
									AjSeqBxAlias(cAlias,aAreaSE5)
									Return !lRet
								Endif
								If lGLOG
									WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
									MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
										(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,cSeqBx,cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.F.,"|")
									WriteLOG(Replicate("-",150))
								Endif
							Else 
								If !GrvRegMov(1, cAlias, nCampos, aEstru)
									AjSeqBxAlias(cAlias,aAreaSE5)
									Return !lRet			
								Endif								
							Endif
							aAdd(aREGPAT,(cAlias)->(Recno()))
							(cAlias)->(dbGoTo(nREGAtu))
						Endif
					Else
						AjSeqBxAlias(cAlias,aAreaSE5)
						Return !lRet
					Endif
				Endif
			Else
				//COMPENSACAO
				//Se a compensacao for de estorno, gravar o movimento, mas nao alterar a sequencia pois eh tarefa do titulo que gerou o estorno
				If (cAlias)->E5_TIPODOC == "ES"
					If !ExREGTMP((cAlias)->(Recno()))
						//Gravar o titulo com o E5_SEQ vazio, pois que deve sequencia-lo eh o titulo pai
						aCmpAlter := {{"E5_SEQ",""}}
						If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
							AjSeqBxAlias(cAlias,aAreaSE5)						
							Return !lRet
						Endif
					Endif							
				Else
					//Determinar a sequencia de baixa do titulo principal
					lOk := .F.
					nREGAtu := (cAlias)->(Recno())
					cSeqBx := ProxSeqBx(cTabTMP, 	{cFil,;
										(cAlias)->E5_PREFIXO,;
										(cAlias)->E5_NUMERO,;
										(cAlias)->E5_PARCELA,;
										(cAlias)->E5_TIPO,;
										(cAlias)->E5_CLIFOR,;
										(cAlias)->E5_LOJA,;
										(cAlias)->E5_TIPODOC})
					nTamTit := 0                                                       
					//Trazendo tamanho do titulo corrente do E5_DOCUMEN
					If (nPos := aScan(aInterChv,{|x| x[1] <= (cAlias)->E5_DTDIGIT})) > 0
						nTamTit := aInterChv[nPos][2]									
		 			Endif                                           
		 			//Validando o tamanho do titulo
		 			nTamTit := TamTitDoc((cAlias)->E5_DOCUMEN,nTamTit)
					//Determinar a sequencia de baixa do outro titulo da compensacao
					If (cAlias)->E5_RECPAG == "R"
						If (cAlias)->E5_TIPO $ MV_CRNEG + "/" + MVRECANT
							cTipoDoc := "CP"
						Else
							cTipoDoc := "BA"
						Endif
					Else 
						If (cAlias)->E5_TIPO $ MV_CPNEG + "/" + MVPAGANT
							cTipoDoc := "CP"
						Else
							cTipoDoc := "BA"
						Endif				
					Endif         
					//Verificar se o titulo processado possui um estorno associado
					If AllTrim((cAlias)->E5_TIPODOC) # "ES"
						aREGEstor[1] := TemMovEst("__SUB", (cAlias)->E5_FILIAL, (cAlias)->E5_PREFIXO, (cAlias)->E5_NUMERO, (cAlias)->E5_PARCELA, (cAlias)->E5_TIPO, ;
							(cAlias)->E5_DATA, (cAlias)->E5_CLIFOR, (cAlias)->E5_LOJA, (cAlias)->E5_SEQ,  (cAlias)->E5_RECPAG, (cAlias)->E5_MOTBX, (cAlias)->E5_VALOR)
					Endif
					
	        		//Verificar se o titulo possui outros movimentos associados (exceto)
	        		If (cAlias)->E5_MOTBX # "CMP"
						aREGNGS := LevOutDoc("__SUB", (cAlias)->E5_FILIAL, (cAlias)->E5_TIPODOC, (cAlias)->E5_PREFIXO, (cAlias)->E5_NUMERO, (cAlias)->E5_PARCELA, ;
							(cAlias)->E5_TIPO, 	(cAlias)->E5_DATA, (cAlias)->E5_CLIFOR, (cAlias)->E5_LOJA, (cAlias)->E5_SEQ,  (cAlias)->E5_RECPAG, (cAlias)->(Recno()))
					Endif									
					cTitCmp := Substr((cAlias)->E5_DOCUMEN,1,nTamTit)
					cTipoTit := (cAlias)->E5_TIPO
					//Ajuste do tamanho da chave de pesquisa
					//Os campos da chave que podem ser alterados sao os de parcela e numero, no caso Citrino o primeiro foi alterado manualmente e o segundo na virada de versao
					cTitCmpTMP := AjustaChv(2, nTamTit, cTitCmp, aTamChv)
					__SUB->(dbSeek(cFil + cTipoDoc + cTitCmpTMP))
					//Titulo nao encontrado com a formatacao de chave determinada, tentar outras formatacoes
					If __SUB->(Eof())
						aTotTam := AjustaChv(1)
						For ni := 1 to Len(aTotTam)
							cTitCmpTMP := AjustaChv(2, aTotTam[ni], cTitCmp, aTamChv)
							__SUB->(dbSeek(cFil + cTipoDoc + cTitCmpTMP))
							If !__SUB->(Eof())
								cTitCmp := cTitCmpTMP
								lOk := .T.
								nTamTit := aTotTam[ni]
								Exit
							Endif
						Next ni	          
					Else
						cTitCmp := cTitCmpTMP
						lOk := .T.
					Endif
					If lOk
						While !__SUB->(Eof()) .AND. __SUB->E5_FILIAL == (cAlias)->E5_FILIAL .AND. ;
							AllTrim(__SUB->(E5_TIPODOC + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO)) == AllTrim(cTipoDoc + cTitCmp)
							//Verificando se o movimento eh compensacao, se o tipo de movimento eh o mesmo e se o movimento nao esta cancelado
							If (__SUB->E5_MOTBX # "CMP" .OR. __SUB->E5_RECPAG # (cAlias)->E5_RECPAG) .OR. __SUB->E5_SITUACA == "C"
								__SUB->(dbSkip())
								Loop
							Endif                                                                        
		                    //Validando as informacoes complementares de amarracao
							If __SUB->E5_DTDIGIT # (cAlias)->E5_DTDIGIT .OR. __SUB->E5_CLIFOR # (cAlias)->E5_CLIFOR .OR. ;
								__SUB->E5_LOJA # (cAlias)->E5_LOJA .OR. __SUB->E5_VALOR # (cAlias)->E5_VALOR
		
								__SUB->(dbSkip())
								Loop
							Endif
							//Validando o sequencial
							If !lUsaTabSec
								If __SUB->E5_SEQ # (cAlias)->E5_SEQ	
									__SUB->(dbSkip())
								Endif
								cSeqBxTMP := __SUB->E5_SEQ
							Else
								(cAlias)->(dbGoTo(__SUB->(Recno())))
								cSeqTMP := (cAlias)->E5_SEQ
								(cAlias)->(dbGoTo(nREGAtu))         
								If cSeqTMP # (cAlias)->E5_SEQ	
									__SUB->(dbSkip())
								Endif
								cSeqBxTMP := cSeqTMP
							Endif
							
							//Formatar a chave do primeiro titulo para comparar com o E5_DOCUMEN do secundario, para verificar se a compensacao eh realmente entre os dois
							If AjustaDoc(nTamTit, {(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO}) # Substr(__SUB->E5_DOCUMEN,1,nTamTit)
								//Existem casos de E5_DOCUMEN sem prefixo, simular a exist๊ncia do mesmo
								If AjustaDoc(nTamTit, {(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO}) # ;
									Substr(Space(TamSX3("E5_PREFIXO")[1]) + __SUB->E5_DOCUMEN,1,nTamTit)
									
									//Verificar se o tamanho das chaves sao diferentes e igualar para nova validacao
									nTamTit02 := TamTitDoc(__SUB->E5_DOCUMEN,nTamTit)
									If AjustaDoc(nTamTit02, {(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO}) # ;
										Substr(__SUB->E5_DOCUMEN,1,nTamTit02)
									
										__SUB->(dbSkip())
										Loop
									Endif
								Endif
							Endif
							
							//Trazendo a sequencia de baixa do titulo compensado
							cSeqBx02 := ""
							If ExREGTMP(__SUB->(Recno()))
								TcRefresh(cTabTMP)
								(cTabTMP)->(dbGoto(__SUB->(Recno())))
								If !Empty((cTabTMP)->E5_SEQ)
									cSeqBx02 := (cTabTMP)->E5_SEQ
									//Procurar se na tabela temporaria jah existe um estorno desta compensacao, que foi processada anteriormente mas nao havia
									//encontrado sua contra-partida, que neste processamento acabou por encontra-la. Para evitar uso indevido de outro estorno.
									aREGEstor[2] := ExEstCmpTMP({(cTabTMP)->E5_FILIAL, (cTabTMP)->E5_PREFIXO, (cTabTMP)->E5_NUMERO, (cTabTMP)->E5_PARCELA, ;
																(cTabTMP)->E5_TIPO, (cTabTMP)->E5_CLIFOR, (cTabTMP)->E5_LOJA, (cTabTMP)->E5_SEQ})
								Endif
							Endif
							If Empty(cSeqBx02)
								cSeqBx02 := ProxSeqBx(cTabTMP, 	{cFil,;
													__SUB->E5_PREFIXO,;
													__SUB->E5_NUMERO,;
													__SUB->E5_PARCELA,;
													__SUB->E5_TIPO,;
													__SUB->E5_CLIFOR,;
													__SUB->E5_LOJA,;
													__SUB->E5_TIPODOC})
							Endif
							nREGTmp := __SUB->(Recno())
							If AllTrim((cAlias)->E5_TIPODOC) # "ES"
								If !lUsaTabSec
									//Verificar se o titulo processado possui um estorno associado
									If Empty(aREGEstor[2])
										aREGEstor[2] := TemMovEst("__SUB", __SUB->E5_FILIAL, __SUB->E5_PREFIXO, __SUB->E5_NUMERO, __SUB->E5_PARCELA, ;
											__SUB->E5_TIPO, __SUB->E5_DATA, __SUB->E5_CLIFOR, __SUB->E5_LOJA, __SUB->E5_SEQ,  __SUB->E5_RECPAG, ;
											__SUB->E5_MOTBX, __SUB->E5_VALOR)
									Endif										
					        		//Verificar se o titulo possui outros movimentos associados (exceto)
					        		If __SUB->E5_MOTBX # "CMP"
								   		aREGNGS02 := LevOutDoc("__SUB", __SUB->E5_FILIAL, __SUB->E5_TIPODOC, __SUB->E5_PREFIXO, __SUB->E5_NUMERO, __SUB->E5_PARCELA, ;
											__SUB->E5_TIPO, __SUB->E5_DATA, __SUB->E5_CLIFOR, __SUB->E5_LOJA, __SUB->E5_SEQ,  __SUB->E5_RECPAG, __SUB->(Recno()))
									Endif
								Else
									//Em caso de uso de tabela secundaria, como pode haver disparidade na sequencia, utilizar a propria tabela 
									//secundaria posicionada para identificar se existe movimento de estorno, nao a replica da SE5
									(cAlias)->(dbGoTo(__SUB->(Recno())))
									//Verificar se o titulo processado possui um estorno associado
									If Empty(aREGEstor[2])
										aREGEstor[2] := TemMovEst(cAlias, (cAlias)->E5_FILIAL, (cAlias)->E5_PREFIXO, (cAlias)->E5_NUMERO, ;
											(cAlias)->E5_PARCELA, (cAlias)->E5_TIPO, (cAlias)->E5_DATA, (cAlias)->E5_CLIFOR, (cAlias)->E5_LOJA, ;
											(cAlias)->E5_SEQ,  (cAlias)->E5_RECPAG, (cAlias)->E5_MOTBX, (cAlias)->E5_VALOR)                
									Endif
					        		//Verificar se o titulo possui outros movimentos associados (exceto)
					        		If (cAlias)->E5_MOTBX # "CMP"
									   	aREGNGS02 := LevOutDoc("__SUB", (cAlias)->E5_FILIAL, (cAlias)->E5_TIPODOC, (cAlias)->E5_PREFIXO, (cAlias)->E5_NUMERO, ;
									   		(cAlias)->E5_PARCELA, (cAlias)->E5_TIPO, (cAlias)->E5_DATA, (cAlias)->E5_CLIFOR, (cAlias)->E5_LOJA, (cAlias)->E5_SEQ, ;
									   		(cAlias)->E5_RECPAG, __SUB->(Recno()))
									Endif
									(cAlias)->(dbGoTo(nREGAtu))         
								Endif							
							Endif
							//Titulo de compensado encontrado, sair
							Exit
						EndDo
					Else
						lOk := .F.
					Endif
					If !Empty(cSeqBx) .AND. !Empty(cSeqBx02)
						//Gravar sequencia para LOG
						cSeqBx := Substr(cSeqBx,1,nTamSeq)
						cSeqBx02 := Substr(cSeqBx02,1,nTamSeq)
						aSeqCMP	:= {cSeqBx,cSeqBx02}                                                                         
						//Comparar qual a maior sequencia entre os titulos, o maior predomina e eh gravado para manter rastreabilidade
						cSeqBx := IIf(cSeqBx < cSeqBx02, cSeqBx02, cSeqBx)
						//Comparar a sequencia determinada com a sequencia do compensador e do compensado, se houver diferenca, alterar
						If cSeqBx # (cAlias)->E5_SEQ .OR. cSeqBx # cSeqBxTMP
							lAltera := .T.
						Endif
						//Verificar se nao houve estouro da capacidade da sequencia, indicado pelo valor preenchido com '0' e alertar via arquivo de LOG
						If aSeqCMP[1] == cSeqZer .OR. aSeqCMP[2] == cSeqZer
							WriteLOG("**** ALERTA! ESTOURO DA CAPACIDADE DO E5_SEQ - VIDE REGISTROS AFETADOS LOGO ABAIXO. ****")
							lAltera := .T.      
							//Forcar a gravacao do 0, para identificar o estouro de sequencia
							cSeqBx := cSeqZer
							If (cAlias)->E5_MOTBX # "CEC"
								cSeqBxID := ProxSEQID(1,@cSeqBxIDCont)
							Endif
						Endif					
						If lAltera
							//Caso tenha havido estouro de sequencia e nao for CEC, gravar sequencia com 00 e agregar uma sequencia no E5_IDENTEE
							If !Empty(cSeqBxID)
								aCmpAlter := {{"E5_SEQ",cSeqBx},{"E5_IDENTEE",cSeqBxID}}
								lGrvSBID := .T.
							Else
								aCmpAlter := {{"E5_SEQ",cSeqBx}}
							Endif
							If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
								AjSeqBxAlias(cAlias,aAreaSE5)
								Return !lRet
							Endif
							If lGLOG
								WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
								MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
									(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,aSeqCMP[1],cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.T.,"|")
							Endif
						Else 
							If !GrvRegMov(1, cAlias, nCampos, aEstru)
								AjSeqBxAlias(cAlias,aAreaSE5)
								Return !lRet			
							Endif								
						Endif
						
						//Caso existam, gravar os outros tipos de documentos contidos na mesma movimentacao do 'pai' - parte 01
						If Len(aREGNGS) > 0
							For ni := 1 to Len(aREGNGS)
								(cAlias)->(dbGoto(aREGNGS[ni]))
								If lAltera
									If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
										AjSeqBxAlias(cAlias,aAreaSE5)
										Return !lRet
									Endif
									If lGLOG
										WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
										MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
											(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,aSeqCMP[1],cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.T.,"|")
									Endif
								Else
									If !GrvRegMov(1, cAlias, nCampos, aEstru)
										AjSeqBxAlias(cAlias,aAreaSE5)
										Return !lRet			
									Endif																
								Endif                     
								aAdd(aREGPAT,(cAlias)->(Recno()))
							Next ni      
							(cAlias)->(dbGoto(nREGAtu))
						Endif
						
						//Gravando a sequencia do titulo compensado
						(cAlias)->(dbGoTo(nREGTmp))
						If lAltera
							If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
								AjSeqBxAlias(cAlias,aAreaSE5)
								Return !lRet
							Endif        
							If lGLOG
								WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
								MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
									(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,aSeqCMP[2],cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.F.,"|")
								WriteLOG(Replicate("-",150))
							Endif
						Else 
							If !GrvRegMov(1, cAlias, nCampos, aEstru)
								AjSeqBxAlias(cAlias,aAreaSE5)
								Return !lRet			
							Endif								
						Endif
						aAdd(aREGPAT,(cAlias)->(Recno()))
						(cAlias)->(dbGoto(nREGAtu))
						
						//Caso existam, gravar os outros tipos de documentos contidos na mesma movimentacao do 'pai' - parte 02 compensados
						If Len(aREGNGS02) > 0
							For ni := 1 to Len(aREGNGS02)
								(cAlias)->(dbGoto(aREGNGS02[ni]))
								If lAltera
									If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
										AjSeqBxAlias(cAlias,aAreaSE5)
										Return !lRet
									Endif
									If lGLOG
										WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
										MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
											(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,aSeqCMP[2],cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.F.,"|")
										WriteLOG(IIf(ni < Len(aREGNGS02), " ", IIf(Len(aREGNGS02) > 0 .OR. !Empty(aREGEstor[1])," ",Replicate("-",150))))
									Endif
								Else
									If !GrvRegMov(1, cAlias, nCampos, aEstru)
										AjSeqBxAlias(cAlias,aAreaSE5)
										Return !lRet			
									Endif																
								Endif                     
								aAdd(aREGPAT,(cAlias)->(Recno()))
							Next ni      
							(cAlias)->(dbGoto(nREGAtu))
						Endif						
						
						//Caso exista, gravar o movimento de estorno do primeiro titulo 
						If !Empty(aREGEstor[1])
							(cAlias)->(dbGoTo(aREGEstor[1]))
							If lAltera
								If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
									AjSeqBxAlias(cAlias,aAreaSE5)
									Return !lRet
								Endif
								If lGLOG
									WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
									MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
										(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,aSeqCMP[1],cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.F.,"|")
									WriteLOG(IIf(!Empty(aREGEstor[2])," ",Replicate("-",150)))
								Endif
							Else 
								If !GrvRegMov(1, cAlias, nCampos, aEstru)
									AjSeqBxAlias(cAlias,aAreaSE5)
									Return !lRet			
								Endif								
							Endif
							aAdd(aREGPAT,(cAlias)->(Recno()))
						Endif
						(cAlias)->(dbGoto(nREGAtu))
						
						//Caso exista, gravar o movimento de estorno do segundo titulo 
						If !Empty(aREGEstor[2])
							(cAlias)->(dbGoTo(aREGEstor[2]))
							If lAltera                   
								If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
									AjSeqBxAlias(cAlias,aAreaSE5)
									Return !lRet
								Endif
								If lGLOG
									WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
									MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
										(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,aSeqCMP[2],cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.F.,"|")
									WriteLOG(Replicate("-",150))
								Endif
							Else 
								If !GrvRegMov(1, cAlias, nCampos, aEstru)
									AjSeqBxAlias(cAlias,aAreaSE5)
									Return !lRet			
								Endif								
							Endif
							aAdd(aREGPAT,(cAlias)->(Recno()))
						Endif										
						(cAlias)->(dbGoTo(nREGAtu))					
					Else     
						//Compensacao orfa
						If !Empty(cSeqBx) .AND. Empty(cSeqBx02)
							cSeqBx := Substr(cSeqBx,1,nTamSeq)
							WriteLOG("**** COMPENSACAO ORFร ****")
							//Verificar se nao houve estouro da capacidade da sequencia, indicado pelo valor preenchido com '0' e alertar via arquivo de LOG
							If cSeqBx == cSeqZer
								WriteLOG("**** ALERTA! ESTOURO DA CAPACIDADE DO E5_SEQ - VIDE REGISTROS AFETADOS LOGO ABAIXO. ****")
								lAltera := .T.
								//Forcar a gravacao do 00, para identificar o estouro de sequencia
								cSeqBx := cSeqZer
								If (cAlias)->E5_MOTBX # "CEC"
									cSeqBxID := ProxSEQID(1,@cSeqBxIDCont)
								Endif
							Endif					
							//Caso tenha havido estouro de sequencia e nao for CEC, gravar sequencia com 00 e agregar uma sequencia no E5_IDENTEE
							If !Empty(cSeqBxID)
								aCmpAlter := {{"E5_SEQ",cSeqBx},{"E5_IDENTEE",cSeqBxID}} 
								lGrvSBID := .T.
							Else
								aCmpAlter := {{"E5_SEQ",cSeqBx}}
							Endif
							If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
								AjSeqBxAlias(cAlias,aAreaSE5)
								Return !lRet
							Endif
							If lGLOG                  
								WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
								MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
									(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,cSeqBx,cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.F.,"|")
								WriteLOG(IIf(!Empty(aREGEstor[1])," ",Replicate("-",150)))
							Endif
							//Caso existam, gravar os outros tipos de documentos contidos na mesma movimentacao do 'pai'
							If Len(aREGNGS) > 0
								For ni := 1 to Len(aREGNGS)
									(cAlias)->(dbGoto(aREGNGS[ni]))
									If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
										AjSeqBxAlias(cAlias,aAreaSE5)
										Return !lRet
									Endif
									If lGLOG
										WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
										MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
											(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,cSeqBx,cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.F.,"|")
										WriteLOG(IIf(ni < Len(aREGNGS), " ", IIf(Len(aREGNGS02) > 0 .OR. !Empty(aREGEstor[1])," ",Replicate("-",150))))
										aAdd(aREGPAT,(cAlias)->(Recno()))
									Endif
								Next ni      
								(cAlias)->(dbGoto(nREGAtu))
							Endif						
							
							//Caso exista, gravar o movimento de estorno do primeiro titulo 
							If !Empty(aREGEstor[1])
								(cAlias)->(dbGoTo(aREGEstor[1]))
								If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
									AjSeqBxAlias(cAlias,aAreaSE5)
									Return !lRet
								Endif
								If lGLOG
									WriteLOG("Motivo : " + (cAlias)->E5_MOTBX)
									MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
										(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,cSeqBx,cSeqBx+IIf(lGrvSBID,"-"+cSeqBxID,""),(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.F.,"|")
									WriteLOG(Replicate("-",150))
								Endif
								aAdd(aREGPAT,(cAlias)->(Recno()))
								(cAlias)->(dbGoTo(nREGAtu))
							Endif						     
							(cAlias)->(dbGoTo(nREGAtu))
						Endif
					Endif
				Endif
			Endif
		Endif
	Else 
		If !GrvRegMov(1, cAlias, nCampos, aEstru)
			AjSeqBxAlias(cAlias,aAreaSE5)
			Return !lRet			
		Endif
	Endif
	aAdd(aREGPAT,(cAlias)->(Recno()))
	For ni := 1 to Len(aREGPAT)
		If aScan(aREGProc,{|x| x == aREGPAT[ni]}) == 0
			aAdd(aREGProc,aREGPAT[ni])
		Endif
	Next ni
	If lUsaTabSec .AND. lAjSeqBx
		If (cAlias)->(Recno()) == nUltRegTS
			(cAlias)->(dbSkip())
			//Em caso de uso da tabela secundaria de referencia de processamento, atualizar a tab. de referencia com os ultimos registros incluidos na tab. padrao incluidos apos o inicio do processamento
			AtTabSec(cAlias,nUltRegTS)
		Else
			(cAlias)->(dbSkip())
		Endif
	Else
		(cAlias)->(dbSkip())
	Endif
EndDo
AjSeqBxAlias(cAlias,aAreaSE5)
//Se houve utilizacao do E5_IDENTEE, ajustar parametro MV_NUMCOMP
If cSeqBxIDCont # cSeqBxIDIni
	ProxSEQID(4,cSeqBxIDCont)
Endif	

//Caso tenha sido usado uma tabela de referencia secundaria para processamento, apagar a tabela temporaria utilizada (temp = tab. backup + diferenca da tab. atual SE5)
If lUsaTabSec
	If MsFile(cTabRefEst,Nil,__cRDD)
		TcDelFile(cTabRefEst)
		TcRefresh(cTabRefEst)
	Endif
Endif

Return lRet

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
ฑฑบPrograma  ณClonarTab บAutor  ณPablo Gollan Carreras บ Data ณ  20/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ClonarTab(cAlias,cEmp)

Local lRet		:= .T.
Local cQry		:= "" 
Local cTabOr	:= RetSqlName(cAlias)
Local lRecriar	:= .T.

//Definindo o nome da tabela temporaria
cTabTMP	:= AllTrim(cAlias + cEmp) + "0_TMP"
//Caso ela jah exista, apagar pra recriar
If Select(cTabTMP) > 0
	dbSelectArea(cTabTMP)
	dbCloseArea()
Endif
If MsFile(cTabTMP,Nil,__cRDD)
	If (lRecriar := IIf(lAjSeqBx,!ApMsgYesNo("Houve um processamento anterior, deseja continuar de onde o processamento foi interrompido?",cRotina),.T.))
		TcDelFile(cTabTMP)
		TcRefresh(cTabTMP)
		//Caso a exclusao tenha falhado, tentar diretamente por ANSI SQL
		If MsFile(cTabTMP,Nil,__cRDD)
			cQry := "DROP TABLE " + cTabTMP + " "
			If TcSQLExec(cQry) < 0
				UserException("Erro na exclusใo da tabela temporaria " + AllTrim(cTabTMP) + CRLF + TCSqlError())
				lRet := .F.
			Else
				If TcGetDB() == "ORACLE"
					TcSQLExec("COMMIT")
				Endif                   
			Endif
		Endif
	Endif
Endif 
If lRecriar
	//Gerando uma nova tabela copiando a estrutura da original
	If TcGetDB() $ "ORACLE"
		cQry := " CREATE TABLE " + cTabTMP + " AS "
		cQry += "SELECT * "
		cQry += "FROM " + cTabOr + " "
		cQry += "WHERE 1 = 0"
	Else		
		cQry := "SELECT * "
		cQry += "INTO " + cTabTMP + " "
		cQry += "FROM " + cTabOr + " "
		cQry += "WHERE 1 = 0"
	EndIf
	If TcSQLExec(cQry) < 0
		UserException("Erro na gera็ใo da tabela temporaria " + AllTrim(cTabTMP) + CRLF + TCSqlError())
		lRet := .F.
	Else
		If TcGetDB() $ "ORACLE"
			cQry := "COMMIT"
			TcSQLExec(cQry)	
		Endif                 
		If !TcCanOpen(cTabTMP)
			UserException("A tabela temporแria criada (" + AllTrim(cTabTMP) + ") nใo pode ser aberta!")
			lRet := .F.
		Endif
	Endif
	//Definir e excluir arquivos de LOG com a database de processamento em seu nome
	AbreArqLOG(1,cEmp)
Else
	//Definir, manter e procurar ultimo arquivo de LOG com a database de processamento em seu nome, para utilizar
	AbreArqLOG(2,cEmp)
Endif    
If lGLOG
	WriteLOG(" ")
	WriteLOG("REGISTRO DE ALTERACOES DE SEQUENCIA DE BAIXA NO SE5" + IIf(!lRecriar," - CONTINUACAO",""))
	WriteLOG(Replicate("-",150))
	If lUsaTabSec
		WriteLOG(" ")
		WriteLOG("UTILIZAวรO DA TABELA SECUNDARIA COMO REFERENCIA PARA PROCESSAMENTO - " + Substr(cTabRefEst,1,Len(cTabRefEst)-4))
		WriteLOG(" ")
	Endif
Endif
//Colocar a tabela criada na workarea
TcSetDummy(.T.)
dbUseArea(.T.,__cRDD,cTabTMP,cTabTMP,.T.,.F.)
TcSetDummy(.F.)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProxSeqBx บAutor  ณPablo Gollan Carreras บ Data ณ  20/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProxSeqBx(cTabTMP, aTitRef)

Local aArea		:= GetArea()
Local aAreaSE5 	:= (cTabTMP)->(GetArea())
Local cSeqBx   	:= Replicate("0",nTamSeq)
Local ni		:= 0
Local cQry		:= ""

If Len(aTitRef) == 0
	Return Nil
Endif
cQry := "SELECT MAX(E5_SEQ) ULTSEQ "
cQry += "FROM " + cTabTMP + " SE5 "
cQry += "WHERE SE5.E5_FILIAL='" + aTitRef[1] +"' AND "
cQry += "SE5.E5_PREFIXO='" + AjustaSTR(aTitRef[2]) + "' AND "
cQry += "SE5.E5_NUMERO='" + AjustaSTR(aTitRef[3]) + "' AND "
cQry += "SE5.E5_PARCELA='" + AjustaSTR(aTitRef[4]) + "' AND "
cQry += "SE5.E5_TIPO='" + aTitRef[5] + "' AND "
cQry += "SE5.E5_CLIFOR='" + AjustaSTR(aTitRef[6]) + "' AND "
cQry += "SE5.E5_LOJA='" + aTitRef[7] + "' AND "
cQry += "SE5.E5_TIPODOC IN ("
For ni := 1 To Len(aTipoDoc)
	cQry += "'" + aTipoDoc[ni] + "'"
	cQry += If(ni == Len(aTipoDoc),"",",")
Next ni
cQry += ") AND "
cQry += " SE5.D_E_L_E_T_ = ' ' "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),"SEQBX",.T.,.F.)
SEQBX->(dbGoTop())
If !SEQBX->(Eof())
	If !Empty(SEQBX->ULTSEQ)
		cSeqBx := Left(SEQBX->ULTSEQ, nTamSeq)
	Endif
Endif
FechaArqT("SEQBX")                
//Adicionar sequencia apenas aos tipos de baixas que geram sequencia ou se estiver zerado
If !aTitRef[8] $ "ES" .OR. cSeqBx == cSeqZer
	If Len(AllTrim(cSeqBx)) # nTamSeq
		cSeqBx := PadL(AllTrim(cSeqBx),nTamSeq,"0")
	Endif
	If lSomaPad
		cSeqBx := Soma1(cSeqBx,Len(cSeqBx))
	Else
		cSeqBx := ProxSeq(cSeqBx,nTamSeq,.T.,.F.,.T.)
	Endif
Endif
RestArea(aAreaSE5)
RestArea(aArea)

Return(cSeqBx)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvRegMov บAutor  ณPablo Gollan Carreras บ Data ณ  22/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ1. Clonar registro                                            บฑฑ
ฑฑบ          ณ2. Clonar permitindo a alteracao de campos declarados         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvRegMov(nMetodo, cAlias, nCampos, aEstru, aCmpAlter)

Local aAreaTMP		:= (cTabTMP)->(GetArea())
Local lRet			:= .T.
Local cQry			:= ""
Local uValor		:= Nil   
Local uValor02		:= Nil                    
Local nPos			:= 0
Local ni			:= 0
Local nModoOP		:= 0	//1 - Insercao  2 - Alteracao
Local aLstCmpNA		:= {}	//Campos para nao alterar
Local cSeqRev		:= ""	//Codigo de sequencia revisado
Local cSeqRev02		:= ""	//Codigo de sequencia revisado (tabela temporaria)

Default aCmpAlter	:= {}

If Empty(nMetodo) .OR. Empty(cAlias) .OR. Empty(nCampos) .OR. Empty(aEstru)
	lRet := !lRet
	Return lRet
Endif
TcRefresh(cTabTMP)
If ExREGTMP((cAlias)->(Recno()))
	nModoOP := 2
Else
	nModoOP := 1
Endif
//Revisar o tamanho do campo E5_SEQ que sera gravado, se necessario, ajustar
If Len(AllTrim((cAlias)->E5_SEQ)) < nTamSeq .AND. !Empty((cAlias)->E5_SEQ)
	cSeqRev := PadL(AllTrim((cAlias)->E5_SEQ),nTamSeq,"0")
Else
	cSeqRev := (cAlias)->E5_SEQ
Endif                                          
//Atualizacao - Verificar se existem campos do registro jah gravados na temporaria que nao devem ser sobrescritos
//Verificar apenas se existirem mais de um processo concomitante que possa efetuar alteracoes no registro
If nModoOP == 2 .AND. (lFilOr .AND. lAjSeqBx) 	
	(cTabTMP)->(dbGoto((cAlias)->(Recno())))
	If Len(AllTrim((cTabTMP)->E5_SEQ)) < nTamSeq
		cSeqRev02 := PadL(AllTrim((cTabTMP)->E5_SEQ),nTamSeq,"0")
	Else 
		cSeqRev02 := (cTabTMP)->E5_SEQ
	Endif
	For ni := 1 to nCampos
		uValor := IIf(AllTrim(aEstru[ni][1]) == "E5_SEQ",cSeqRev,(cAlias)->&(aEstru[ni][1]))
		uValor02 := IIf(AllTrim(aEstru[ni][1]) == "E5_SEQ",cSeqRev02,(cTabTMP)->&(aEstru[ni][1]))
		//Trabalhar somente com o tipo CARACTER que eh o tipo dos campos manipulados nas alteracoes
		If aEstru[ni][2] == "C"
			If !AllTrim(aEstru[ni][1]) $ "E5_SEQ/E5_IDENTEE" //Estes campos precisam ser sobreescritos caso sejam modificados, no demais o que houver de diferente, manter
				If Substr(AjustaSTR(uValor,.T.),1,aEstru[ni][3]) # Substr(AjustaSTR(uValor02,.T.),1,aEstru[ni][3])
					aAdd(aLstCmpNA,AllTrim(aEstru[ni][1]))
				Endif
			Endif
		Endif
	Next ni     		   	
Endif
If nMetodo == 1
	If nModoOP == 1
		//Inclusao
		cQry := "INSERT INTO " + cTabTMP + " ("
		For ni := 1 to nCampos
			cQry += aEstru[ni][1] + ", "
		Next ni                        
		cQry += "D_E_L_E_T_, R_E_C_N_O_) "
		cQry += "VALUES ("
		For ni := 1 to nCampos                  
			uValor := IIf(AllTrim(aEstru[ni][1]) == "E5_SEQ",cSeqRev,(cAlias)->&(aEstru[ni][1]))
			Do Case
				Case aEstru[ni][2] == "C"
					cQry += "'" + Substr(AjustaSTR(uValor,.T.),1,aEstru[ni][3]) + "'"
				Case aEstru[ni][2] == "D"
					cQry += "'" + DtoS(uValor) + "'"
				Case aEstru[ni][2] == "N"
					cQry += cValtoChar(uValor)
				Case aEstru[ni][2] == "L"
					cQry += "'" + DtoS(uValor) + "'"
				Otherwise
					cQry += "'" + Substr(AjustaSTR(uValor,.T.),1,aEstru[ni][3]) + "'"					
			EndCase
			cQry += ", "
		Next ni     
		cQry += "' ', " + cValtoChar((cAlias)->(Recno())) + ")"
	Else         
		//Alteracao
		cQry := "UPDATE " + cTabTMP + " SET "
		For ni := 1 to nCampos
			If aScan(aLstCmpNA,{|x| x == AllTrim(aEstru[ni][1])}) == 0
				cQry += aEstru[ni][1] + " = "
				uValor := IIf(AllTrim(aEstru[ni][1]) == "E5_SEQ",cSeqRev,(cAlias)->&(aEstru[ni][1]))
				Do Case
					Case aEstru[ni][2] == "C"
						cQry += "'" + Substr(AjustaSTR(uValor,.T.),1,aEstru[ni][3]) + "'"
					Case aEstru[ni][2] == "D"
						cQry += "'" + DtoS(uValor) + "'"
					Case aEstru[ni][2] == "N"
						cQry += cValtoChar(uValor)
					Case aEstru[ni][2] == "L"
						cQry += "'" + DtoS(uValor) + "'"
					Otherwise
						cQry += "'" + Substr(AjustaSTR(uValor,.T.),1,aEstru[ni][3]) + "'"
				EndCase
				cQry += IIf(ni < nCampos, ", ", " ")
			Endif
		Next ni     		                
		cQry += "WHERE R_E_C_N_O_ = " + cValtoChar((cAlias)->(Recno())) + " "
	Endif
	If TCSqlExec(cQry) < 0
		MsgAlert("Erro ao inserir o registro " + AllTrim((cAlias)->(Recno())) + "." + CRLF + TCSqlError(),cRotina)
		lRet := !lRet
	Endif
ElseIf nMetodo == 2
	If nModoOP == 1
		//Inclusao
		cQry := "INSERT INTO " + cTabTMP + " ("
		For ni := 1 to nCampos
			cQry += aEstru[ni][1] + ", "
		Next ni                        
		cQry += "D_E_L_E_T_, R_E_C_N_O_) "
		cQry += "VALUES ("
		For ni := 1 to nCampos
			If (nPos := aScan(aCmpAlter,{|x| AllTrim(x[1]) == AllTrim(aEstru[ni][1])})) > 0
				If AllTrim(aCmpAlter[nPos][1]) == "E5_SEQ"
					If Len(AllTrim(aCmpAlter[nPos][2])) < nTamSeq .AND. !Empty(aCmpAlter[nPos][2])
						uValor := PadL(AllTrim(aCmpAlter[nPos][2]),nTamSeq,"0")
					Else
						uValor := aCmpAlter[nPos][2]
					Endif
				Else
					uValor := aCmpAlter[nPos][2]
				Endif
			Else
				uValor := IIf(AllTrim(aEstru[ni][1]) == "E5_SEQ",cSeqRev,(cAlias)->&(aEstru[ni][1]))
			Endif
			Do Case
				Case aEstru[ni][2] == "C"
					cQry += "'" + Substr(AjustaSTR(uValor,.T.),1,aEstru[ni][3]) + "'"
				Case aEstru[ni][2] == "D"
					cQry += "'" + DtoS(uValor) + "'"
				Case aEstru[ni][2] == "N"
					cQry += cValtoChar(uValor)
				Case aEstru[ni][2] == "L"
					cQry += "'" + DtoS(uValor) + "'"
				Otherwise
					cQry += "'" + Substr(AjustaSTR(uValor,.T.),1,aEstru[ni][3]) + "'"					
			EndCase
			cQry += ", "
		Next ni     
		cQry += "' ', " + cValtoChar((cAlias)->(Recno())) + ")"
	Else
		//Alteracao
		cQry := "UPDATE " + cTabTMP + " SET "
		For ni := 1 to nCampos
			If aScan(aLstCmpNA,{|x| x == AllTrim(aEstru[ni][1])}) == 0
				cQry += aEstru[ni][1] + " = "
				If (nPos := aScan(aCmpAlter,{|x| AllTrim(x[1]) == AllTrim(aEstru[ni][1])})) > 0
					If AllTrim(aCmpAlter[nPos][1]) == "E5_SEQ"
						If Len(AllTrim(aCmpAlter[nPos][2])) < nTamSeq .AND. !Empty(aCmpAlter[nPos][2])
							uValor := PadL(AllTrim(aCmpAlter[nPos][2]),nTamSeq,"0")
						Else 
							uValor := aCmpAlter[nPos][2]
						Endif
					Else
						uValor := aCmpAlter[nPos][2]
					Endif					
				Else
					uValor := IIf(AllTrim(aEstru[ni][1]) == "E5_SEQ",cSeqRev,(cAlias)->&(aEstru[ni][1]))
				Endif
				Do Case
					Case aEstru[ni][2] == "C"
						cQry += "'" + Substr(AjustaSTR(uValor,.T.),1,aEstru[ni][3]) + "'"
					Case aEstru[ni][2] == "D"
						cQry += "'" + DtoS(uValor) + "'"
					Case aEstru[ni][2] == "N"
						cQry += cValtoChar(uValor)
					Case aEstru[ni][2] == "L"
						cQry += "'" + DtoS(uValor) + "'"
					Otherwise
						cQry += "'" + Substr(AjustaSTR(uValor,.T.),1,aEstru[ni][3]) + "'"					
				EndCase
				cQry += IIf(ni < nCampos, ", ", " ")
			Endif
		Next ni     		
		cQry += "WHERE R_E_C_N_O_ = " + cValtoChar((cAlias)->(Recno())) + " "
	Endif
	If TCSqlExec(cQry) < 0
		MsgAlert("Erro ao inserir o registro " + AllTrim((cAlias)->(Recno())) + "." + CRLF + TCSqlError(),cRotina)
		lRet := !lRet
	Endif
Else
	lRet := !lRet
Endif
RestArea(aAreaTMP)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMLInterChvบAutor  ณPablo Gollan Carreras บ Data ณ  22/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta lista com intervalos de variacoes no tamanho dos campos บฑฑ
ฑฑบ          ณque compoe o documento em compensacoes no SE5.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MLInterChv(cAlias,nTotREG)

Local aTamMin 		:= {3 /*prefixo*/,6 /*numero*/, 1 /*parcela*/, 3 /*tipo*/}
Local aTamPad		:= {TamSX3("E5_PREFIXO")[1],TamSX3("E5_NUMERO")[1],TamSX3("E5_PARCELA")[1],TamSX3("E5_TIPO")[1]}
Local aAreaAlias	:= (cAlias)->(GetArea())
Local nTamMin		:= 0
Local nTamPad		:= 0
Local dInicio		:= Nil
Local nTamAtu		:= 0
Local nPos			:= 0    
Local ni			:= 0
Local cAliasQ		:= GetNextAlias()
Local cQry			:= ""
Local cSGBD			:= TCGetDB()
Local nTamTipo		:= TamSX3("E5_TIPO")[1]
Local nContREG		:= 0

Default nTotREG	:= 0

//Montar lista com os tipos de titulos
dbSelectArea("SX5")
SX5->(dbSetOrder(1))
SX5->(dbSeek(xFilial("SX5") + "05"))
Do While !SX5->(Eof()) .AND. AllTrim(SX5->X5_TABELA) == "05"
	aAdd(aTipoTit, {SX5->X5_CHAVE,0})                                 
	SX5->(dbSkip())
EndDo
aSort(aTipoTit,,,{|x,y| x > y})
If !lAjSeqBx
	Return Nil
Endif
//Pesquisar data inicial de movimentos
Do Case
	Case cSGBD $ "MSSQL"   
		cQry := "SELECT TOP 1 E5_DTDIGIT "
		cQry += "FROM " + RetSqlName("SE5") + " "
		cQry += "WHERE D_E_L_E_T_ <> '*' AND E5_DTDIGIT <> '' AND E5_DTDIGIT >= '19800101' "
		cQry += "ORDER BY E5_DTDIGIT ASC"
	Case cSGBD $ "ORACLE"
		cQry := "SELECT E5_DTDIGIT "
		cQry += "FROM " + RetSqlName("SE5") + " "
		cQry += "WHERE D_E_L_E_T_ <> '*' AND E5_DTDIGIT <> '' AND ROWNUM <= 1 AND E5_DTDIGIT >= '19800101' "
		cQry += "ORDER BY E5_DTDIGIT ASC"	
	Case cSGBD $ "MYSQL/POSTGRES"
		cQry := "SELECT E5_DTDIGIT "
		cQry += "FROM " + RetSqlName("SE5") + " "
		cQry += "WHERE D_E_L_E_T_ <> '*' AND E5_DTDIGIT <> '' AND E5_DTDIGIT >= '19800101'"
		cQry += "ORDER BY E5_DTDIGIT ASC LIMIT 1 "		
	Case cSGBD $ "SYBASE" 
		cQry := "SET ROWCOUNT 1 "
		cQry += "SELECT E5_DTDIGIT "
		cQry += "FROM " + RetSqlName("SE5") + " "
		cQry += "WHERE D_E_L_E_T_ <> '*' AND E5_DTDIGIT <> '' AND E5_DTDIGIT >= '19800101' "
		cQry += "ORDER BY E5_DTDIGIT ASC"		
	Case cSGBD $ "INFORMIX"
		cQry := "SELECT FIRST 1 E5_DTDIGIT "
		cQry += "FROM " + RetSqlName("SE5") + " "
		cQry += "WHERE D_E_L_E_T_ <> '*' AND E5_DTDIGIT <> '' AND E5_DTDIGIT >= '19800101' "
		cQry += "ORDER BY E5_DTDIGIT ASC"	
	OtherWise
EndCase
cQry := ChangeQuery(cQry)
dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAliasQ,.T.,.F.)
If !(cAliasQ)->(Eof())
	TcSetField(cAliasQ,(cAliasQ)->(dbStruct())[1,1],"D",8,0)
	dInicio	:= (cAliasQ)->(FieldGet(1))
Endif
FechaArqT(cAliasQ)
aEval(aTamMin, {|x| nTamMin += x})
aEval(aTamPad, {|x| nTamPad += x})
dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
If nTotREG == 0
	nTotREG := (cAlias)->(RecCount())
Endif
ProcRegua(nTotREG)
Do While !(cAlias)->(Eof())
	IncProc()
	If Empty((cAlias)->E5_PREFIXO) .OR. Empty((cAlias)->E5_NUMERO) .OR. Empty((cAlias)->E5_PARCELA) .OR. Empty((cAlias)->E5_TIPO) .OR. ;
		Empty((cAlias)->E5_DOCUMEN) .OR. (cAlias)->E5_SITUACA == "C"
		
		(cAlias)->(dbSkip())
		Loop
	Endif
	nTamAtu := 0
	For ni := 1 to Len(aTipoTit)
		If PadR(aTipoTit[ni][1],nTamTipo) $ (cAlias)->E5_DOCUMEN
			nPos := At(PadR(aTipoTit[ni][1],nTamTipo), (cAlias)->E5_DOCUMEN)
			If nPos > 0
				nTamAtu := nPos + (nTamTipo - 1)
				aTipoTit[ni][2]++
				Exit
			Endif
		Endif	    
	Next ni         
	//Organizar a lista pelos mais utilizados para acelerar o processo de busca do tipo de titulo               
	nContREG++
	If nContREG == 10                             	
		aSort(aTipoTit,,,{|x,y| x[2] > y[2]})
		nContREG := 0
	Endif
	If nTamAtu >= nTamMin
		If Len(aInterChv) == 0
			aAdd(aInterChv,{IIf(!Empty(dInicio),dInicio,(cAlias)->E5_DTDIGIT),nTamAtu})
		Else
			If (nPos := aScan(aInterChv, {|x| DtoS(x[1]) > DtoS((cAlias)->E5_DTDIGIT) .AND. x[2] == nTamAtu})) > 0
				aInterChv[nPos][1] := (cAlias)->E5_DTDIGIT	
			ElseIf nTamAtu > nTamMin
				If (nPos := aScan(aInterChv, {|x| x[2] >= nTamAtu})) == 0
					aAdd(aInterChv,{(cAlias)->E5_DTDIGIT,nTamAtu})
					If nTamMin < nTamAtu
						nTamMin := nTamAtu
					Endif
				Endif
			Endif
		Endif
	Endif
	(cAlias)->(dbSkip())
EndDo              
//Ordernar decrescente
aSort(aInterChv,,,{|x,y| x[1] > y[1]})   
RestArea(aAreaAlias)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSTR บAutor  ณPablo Gollan Carreras บ Data ณ  27/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSTR(cString,lRemovApIF)

Local cRet		:= ""  
Local ni		:= 0                   
Local nTamTot	:= 0 
Local cSGBD := TcGetDB()

Default lRemovApIF	:= .F.
If cSGBD <> "ORACLE"
	cString := RTrim(cString)
EndIf
If At("'", cString) > 0
	nTamTot := Len(cString)
	For ni := 1 to nTamTot
		If Substr(cString,ni,1) == "'"
			If lRemovApIF
				Do Case
					Case ni == 1
						cRet += ""
					Case ni == nTamTot
						cRet += ""
					Otherwise
						cRet += Replicate("'",2)
				EndCase
			Else 
				cRet += Replicate("'",2)
			Endif
		Else
			cRet += Substr(cString,ni,1)
		Endif
	Next ni
Else
	cRet := cString
Endif                   

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaChv บAutor  ณPablo Gollan Carreras บ Data ณ  27/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta o conteudo do E5_DOCUMEN para montar uma chave de pes- บฑฑ
ฑฑบ          ณquisa utilizando o indice 02 da SE5                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaChv(nProc, nTamTit, cTitCmp, aTamChv)

Local nOpc			:= 0
Local cChave		:= ""
Local aTam			:= {13,14,15,16,17,18}

Default aTamChv	:= {TamSX3("E5_PREFIXO")[1],TamSX3("E5_NUMERO")[1],TamSX3("E5_PARCELA")[1],TamSX3("E5_TIPO")[1]}

If nProc == 1
	Return aTam
Endif

nOpc := aScan(aTam,{|x| x == nTamTit})
If nOpc > 0
	nOpc--
Endif
Do Case 
	Case nOpc == 1	//Numero (06) / Parcela (02) = 14
		cChave := PadR(Substr(cTitCmp,1,3),aTamChv[1]) + PadR(Substr(cTitCmp,4,6),aTamChv[2]) + PadR(Substr(cTitCmp,10,2),aTamChv[3]) + ;
					PadR(Substr(cTitCmp,12,3),aTamChv[4])
	Case nOpc == 2	//Numero (06) / Parcela (03) = 15
		cChave := PadR(Substr(cTitCmp,1,3),aTamChv[1]) + PadR(Substr(cTitCmp,4,6),aTamChv[2]) + PadR(Substr(cTitCmp,10,3),aTamChv[3]) + ;
					PadR(Substr(cTitCmp,13,3),aTamChv[4])
	Case nOpc == 3	//Numero (09) / Parcela (01) = 16
		cChave := PadR(Substr(cTitCmp,1,3),aTamChv[1]) + PadR(Substr(cTitCmp,4,9),aTamChv[2]) + PadR(Substr(cTitCmp,13,1),aTamChv[3]) + ;
					PadR(Substr(cTitCmp,14,3),aTamChv[4])
	Case nOpc == 4	//Numero (09) / Parcela (02) = 17
		cChave := PadR(Substr(cTitCmp,1,3),aTamChv[1]) + PadR(Substr(cTitCmp,4,9),aTamChv[2]) + PadR(Substr(cTitCmp,13,2),aTamChv[3]) + ;
					PadR(Substr(cTitCmp,15,3),aTamChv[4])
	Case nOpc == 5	//Numero (09) / Parcela (03) = 18
		cChave := PadR(Substr(cTitCmp,1,3),aTamChv[1]) + PadR(Substr(cTitCmp,4,9),aTamChv[2]) + PadR(Substr(cTitCmp,13,3),aTamChv[3]) + ;
					PadR(Substr(cTitCmp,16,3),aTamChv[4])
	Otherwise		//Numero (06) / Parcela (01) = 13
		cChave := PadR(Substr(cTitCmp,1,3),aTamChv[1]) + PadR(Substr(cTitCmp,4,6),aTamChv[2]) + PadR(Substr(cTitCmp,10,1),aTamChv[3]) + ;
					PadR(Substr(cTitCmp,11,3),aTamChv[4])						
EndCase

Return cChave

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaDoc บAutor  ณPablo Gollan Carreras บ Data ณ  28/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta uma string composta pela chave prefixo+num+parcela+tipo บฑฑ
ฑฑบ          ณno formato de gravacao do SE5                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                     

Static Function AjustaDoc(nTamTit, aChave)

Local nOpc			:= 0
Local cChave		:= ""
Local aTam			:= {13,14,15,16,17,18}

nOpc := aScan(aTam,{|x| x == nTamTit})
If nOpc > 0
	nOpc--
Endif
Do Case 
	Case nOpc == 1	//Numero (06) / Parcela (02) = 14
		cChave := PadR(Substr(aChave[1],1,3) + Substr(aChave[2],1,6) + Substr(aChave[3],1,2) + Substr(aChave[4],1,3),aTam[nOpc+1])
	Case nOpc == 2	//Numero (06) / Parcela (03) = 15
		cChave := PadR(Substr(aChave[1],1,3) + Substr(aChave[2],1,6) + Substr(aChave[3],1,3) + Substr(aChave[4],1,3),aTam[nOpc+1])
	Case nOpc == 3	//Numero (09) / Parcela (01) = 16                                                                   
		cChave := PadR(Substr(aChave[1],1,3) + Substr(aChave[2],1,9) + Substr(aChave[3],1,1) + Substr(aChave[4],1,3),aTam[nOpc+1])
	Case nOpc == 4	//Numero (09) / Parcela (02) = 17
		cChave := PadR(Substr(aChave[1],1,3) + Substr(aChave[2],1,9) + Substr(aChave[3],1,2) + Substr(aChave[4],1,3),aTam[nOpc+1])
	Case nOpc == 5	//Numero (09) / Parcela (03) = 18                                                                   
		cChave := PadR(Substr(aChave[1],1,3) + Substr(aChave[2],1,9) + Substr(aChave[3],1,3) + Substr(aChave[4],1,3)	,aTam[nOpc+1])
	Otherwise		//Numero (06) / Parcela (01) = 13                                                                                           
		cChave := PadR(Substr(aChave[1],1,3) + Substr(aChave[2],1,6) + Substr(aChave[3],1,1) + Substr(aChave[4],1,3)	,aTam[nOpc+1])
EndCase

Return cChave

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWriteLog  บAutor  ณPablo Gollan Carreras บ Data ณ  28/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function WriteLog(cTexto)

Local nHandle 		:= 0
Local cPath			:= cDir + cArqLOG
Local nNumMaxREG	:= 100000
Local nTotArqGrv	:= 0

//Se ficou determinado que nao se deve gerar LOG, sair
If !lGLOG
	Return
Endif
CurDir(cDir)
If !File(cPath)
	nHandle := fCreate(cPath)
	fClose(nHandle)
Endif
If nContGRVArq == 0           
	nHandle := FT_FUSE(cPath)
	FT_FGoto(FT_FLASTREC())
	nContGRVArq := FT_FRECNO()
	FT_FUSE()
Else
	nContGRVArq++
Endif	
//Verificar se o tamanho do arquivo jah atingiu o tamanho maximo permitido, em caso afirmativo abrir um arquivo de sequencia
If nContGRVArq > nNumMaxREG       
	aEval(Directory((cDir + Substr(cArqLOG,1,nTamNomeArq)) + "*.TXT"),{|| nTotArqGrv++})	
	cArqLOG := Substr(cArqLOG,1,nTamNomeArq) + "_" + StrZero(nTotArqGrv,3) + ".TXT"
	cPath	:= cDir + cArqLOG
	//Criar novo arquivo
	nHandle := fCreate(cPath)
	fClose(nHandle)
	nContGRVArq := 1
Endif
nHandle := fOpen(cPath, 2)
fSeek(nHandle, 0, 2)	// Posiciona no final do arquivo
fWrite(nHandle, cTexto + CRLF, Len(cTexto) + 2)
fClose(nHandle) 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcFinal บAutor  ณPablo Gollan Carreras บ Data ณ  28/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ1. Sincronizar o campo E5_SITUACA da tab. temp. c/ SE5 em uso บฑฑ
ฑฑบ          ณ2. fazer backup da tabela ativa - inclusive os deletados      บฑฑ
ฑฑบ          ณ3. backup feito, deletar seu conteudo                         บฑฑ
ฑฑบ          ณ4. incluir todo o conteudo da tabela temporaria na ativa      บฑฑ
ฑฑบ          ณ5. conferir numero de registros entre as tabelas              บฑฑ
ฑฑบ          ณ6. estando ok, pesquisar o ultimo recno da tabela ativa       บฑฑ
ฑฑบ          ณ7. inserir os registros da tabela de backup a partir do recno บฑฑ
ฑฑบ          ณ   da ativa + 1 (novos registros - nใo deletados)             บฑฑ
ฑฑบ          ณ8. excluir a tabela temporแria                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcFinal(cAlias, cEmp)

Local lRet			:= .T.
Local cQry			:= "" 
Local cTabOr		:= RetSqlName(cAlias)
Local cTabBCKP		:= AllTrim(cAlias + cEmp) + "0_BCKP" + DtoS(dDataBase)
Local cASCBase		:= 65
Local ni			:= 0
Local cAlias02		:= GetNextAlias()
Local nUltREG		:= 0
Local nEtapa		:= 0
Local aCmpAjSE5		:= {"E5_SITUACA","E5_PRETPIS","E5_PRETCOF","E5_PRETCSL","E5_DTDISPO","E5_MODSPB","E5_PRETIRF","E5_BANCO","E5_AGENCIA","E5_CONTA","E5_NUMCHEQ","E5_LA"}

ProcRegua(6)
WriteLOG(" ")
WriteLOG("FINALIZACAO DO PROCESSO DA EMPRESA - " + cEmp)
WriteLOG(Replicate("-",150))
Do While MsFile(cTabBCKP + IIf(ni == 0,"",CHR(cASCBase + ni)),Nil,__cRDD)
	ni++	
EndDo
cTabBCKP += IIf(ni == 0,"",CHR(cASCBase + ni))
IncProc()          
//Sincronizacao dos campos do SE5 que podem ser alterados durante o processamento
If lAjSeqBx
	For ni := 1 to Len(aCmpAjSE5)
		nEtapa++                                                                        
		WriteLOG(Upper(cValToChar(nEtapa) + ". Sincronizar o campo " + aCmpAjSE5[ni] + " da tab. temporแria com o da SE5 em uso (" + cTabTMP + ") - ( OK )"))
		cQry := "UPDATE " + cTabTMP + " TMP "
		cQry += "SET TMP." + aCmpAjSE5[ni] + " = (SELECT B." + aCmpAjSE5[ni] + " FROM " + cTabOr + " B WHERE B.R_E_C_N_O_ = TMP.R_E_C_N_O_) "
		cQry += "WHERE TMP." + aCmpAjSE5[ni] + " <> (SELECT B." + aCmpAjSE5[ni] + " FROM " + cTabOr + "  B WHERE B.R_E_C_N_O_ = TMP.R_E_C_N_O_) AND TMP.D_E_L_E_T_ <> '*'"
		If TcSQLExec(cQry) < 0
			UserException("Erro na sincronia do campo " + aCmpAjSE5[ni] + " " + AllTrim(cTabTMP) + CRLF + TCSqlError())
			lRet := .F.
			Return lRet
		Else
			If TcGetDB() $ "ORACLE"
				cQry := "COMMIT"
				TcSQLExec(cQry)	
			Endif
		Endif
	Next ni
Endif
nEtapa++
WriteLOG(Upper(cValToChar(nEtapa) + ". Fazer backup da tabela ativa - inclusive os deletados (" + cTabBCKP + ") - ( OK )"))
If TcGetDB() $ "ORACLE"
	cQry := " CREATE TABLE " + cTabBCKP + " AS "
	cQry += "SELECT * "
	cQry += "FROM " + cTabOr + " "
	cQry += "WHERE 1 = 1"
Else
	cQry := "SELECT * "
	cQry += "INTO " + cTabBCKP + " "
	cQry += "FROM " + cTabOr + " "
	cQry += "WHERE 1 = 1"
EndIf	
If TcSQLExec(cQry) < 0
	UserException("Erro na gera็ใo da tabela de backup " + AllTrim(cTabBCKP) + CRLF + TCSqlError())
	lRet := .F.
Else
	If TcGetDB() $ "ORACLE"
		cQry := "COMMIT"
		TcSQLExec(cQry)	
	Endif                 
	If !TcCanOpen(cTabBCKP)
		UserException("A tabela de backup criada (" + AllTrim(cTabBCKP) + ") nใo pode ser aberta!")
		lRet := .F.
	Endif
Endif        
If !lRet
	Return lRet
Endif    
IncProc()
//Caso seja apenas um processamento de ajuste de filial de origem, sem ajuste de sequencia, alinhar o FILORIG da atual com os dados da temporaria
If lFilOr .AND. !lAjSeqBx
	nEtapa++
	WriteLOG(Upper(cValToChar(nEtapa) + ". Sincronizar o campo E5_FILORIG da SE5 em uso com os dados atualizados da temporแria (" + cTabTMP + ") - ( OK )"))
	cQry := "UPDATE " + cTabOr + " "
	cQry += "SET E5_FILORIG = (SELECT B.E5_FILORIG FROM " + cTabTMP + " B WHERE (B.R_E_C_N_O_ = " + AllTrim(cTabOr) + ".R_E_C_N_O_)) "
	cQry += "WHERE ((E5_FILORIG <> (SELECT B.E5_FILORIG FROM " + cTabTMP + " AS B WHERE (B.R_E_C_N_O_ = " + AllTrim(cTabOr) + ".R_E_C_N_O_))) AND (D_E_L_E_T_ <> '*'))"
	If TcSQLExec(cQry) < 0
		UserException("Erro na sincronia do campo E5_FILORIG " + AllTrim(cTabOr) + CRLF + TCSqlError())
		lRet := .F.
		Return lRet
	Else
		If TcGetDB() $ "ORACLE"
			cQry := "COMMIT"
			TcSQLExec(cQry)	
		Endif                 
	Endif
Endif
If lAjSeqBx
	nEtapa++
	WriteLOG(Upper(cValToChar(nEtapa) + ". Backup feito, deletar seu conteudo - ( OK )"))
	cQry := "TRUNCATE TABLE " + cTabOr + " "
	If TcSQLExec(cQry) < 0
		UserException("Erro na exclusใo de registros da tabela ativa." + CRLF + TCSqlError())
		lRet := .F.
	Else
		If TcGetDB() $ "ORACLE"
			cQry := "COMMIT"
			TcSQLExec(cQry)	
		Endif                 
	Endif             
	If !lRet
		Return lRet
	Endif    
Endif
IncProc() 
If lAjSeqBx
	nEtapa++
	WriteLOG(Upper(cValToChar(nEtapa) + ". Incluir todo o conteudo da tabela temporaria na ativa - ( OK )"))
	cQry := "INSERT "
	cQry += "INTO " + cTabOr + " "
	cQry += "SELECT * FROM " + cTabTMP + " "
	cQry += "WHERE 1 = 1"
	If TcSQLExec(cQry) < 0
		UserException("Erro na gravacao dos registros da tabela temporaria na tabela ativa." + CRLF + TCSqlError())
		lRet := .F.
	Else
		If TcGetDB() $ "ORACLE"
			cQry := "COMMIT"
			TcSQLExec(cQry)	
		Endif                 
	Endif        
	If !lRet
		Return lRet
	Endif
Endif
IncProc()
If lAjSeqBx
	nEtapa++
	WriteLOG(Upper(cValToChar(nEtapa) + ". Pesquisar o ultimo recno da tabela ativa - ( OK )"))
	TcRefresh(cTabOr)
	cQry := "SELECT MAX(R_E_C_N_O_) NMAXREC "
	cQry += "FROM " + cTabOr + " "
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAlias02,.T.,.T.)
	TcSetField(cAlias02,"NMAXREC","N",18,0)
	(cAlias02)->(dbGoTop())
	If !(cAlias02)->(Eof())
		If !Empty((cAlias02)->NMAXREC)
			nUltREG := (cAlias02)->NMAXREC
		Endif	
	Endif
	FechaArqT(cAlias02)                                                     
Endif
IncProc()
If lAjSeqBx
	nEtapa++
	WriteLOG(Upper(cValToChar(nEtapa) + ". Inserir os registros da tabela de backup a partir do recno da ativa + 1 (novos registros - nใo deletados) - ( OK )"))
	cQry := "INSERT "
	cQry += "INTO " + cTabOr + " "
	cQry += "SELECT * FROM " + cTabBCKP + " "
	cQry += "WHERE D_E_L_E_T_ <> '*' AND R_E_C_N_O_ > " + cValToChar(nUltREG) + " "
	If TcSQLExec(cQry) < 0
		UserException("Erro na gravacao dos registros excedentes da tabela de backup na tabela ativa " + CRLF + TCSqlError())
		lRet := .F.
	Else
		If TcGetDB() $ "ORACLE"
			cQry := "COMMIT"
			TcSQLExec(cQry)	
		Endif                 
	Endif        
	If !lRet
		Return lRet
	Endif     
	IncProc()
Endif
nEtapa++
WriteLOG(Upper(cValToChar(nEtapa) + ". Excluir a tabela temporแria - ( OK )"))
dbSelectArea(cTabTMP)
dbCloseArea()
cQry := "DROP TABLE " + cTabTMP + " "
If TcSQLExec(cQry) < 0
	UserException("Erro na exclusใo da tabela temporaria. (" + cTabTMP + ")" + CRLF + TCSqlError())
	lRet := .F.
Else
	If TcGetDB() $ "ORACLE"
		cQry := "COMMIT"
		TcSQLExec(cQry)	
	Endif                 
Endif             
If !lRet
	Return lRet
Endif
WriteLOG(Replicate("-",150))

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaLRP บAutor  ณPablo Gollan Carreras บ Data ณ  30/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjustar o array de controle de reg.processados p/ otimizar    บฑฑ
ฑฑบ          ณLRP - Limite Registros Processados                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaLRP()

Local aREGP02		:= {} 
Local ni			:= 0
Local nLimIni		:= 0
Local nLimFin		:= 0

Static nLIMRP		:= 2000	//Limite a ser mantido na array a aREGProc

nLimIni := Len(aREGProc)
If nLimIni > nLIMRP
	aREGP02 := aClone(aREGProc)
	aREGProc := Array(0)
	nLimFin := nLimIni - nLIMRP
	For ni := nLimFin to nLimIni Step 1
		aAdd(aREGProc, aREGP02[ni])
    Next ni
    aREGP02 := Array(0)
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExREGTMP  บAutor  ณPablo Gollan Carreras บ Data ณ  30/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica a existencia de um registro na tabela temporaria     บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExREGTMP(nREG)

Local lRet			:= .F.
Local cQry			:= ""
Local cAliasRG		:= "cVRP"

Default nREG		:= 0

If nREG == 0
	Return lRet
Endif          
cQry := "SELECT R_E_C_N_O_ REG "
cQry += "FROM " + cTabTMP + " "
cQry += "WHERE R_E_C_N_O_ = " + cValtoChar(nREG) + " "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAliasRG,.T.,.F.)
If !(cAliasRG)->(Eof())
	If !Empty((cAliasRG)->REG)
		lRet := .T.
	Endif
Endif      
FechaArqT(cAliasRG)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTemMovEst บAutor  ณPablo Gollan Carreras บ Data ณ  30/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se o movimento possui estorno                        บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TemMovEst(cAlias, cFil, cPrefixo, cNumero, cParc, cTipo, dData, cCliFor, cLoja, cSeq, cRP, cMotBx, nValor)

Local nREGEst		:= 0
Local aArea			:= GetArea()
Local cTitulo		:= ""
Local cAliasNovo	:= IIf(lUsaTabSec,GetNextAlias(),"")
Local cQry			:= ""
Static cTipoDoc		:= "ES"

If Len(cFil + cTipoDoc + cPrefixo + cNumero + cParc + cTipo + cCliFor + cLoja + cSeq + cRP + cMotBx) == 0 .OR. Empty(dData)
	Return nREGEst
Endif                                                       
cTitulo := AllTrim(cFil + cPrefixo + cNumero + cParc + cTipo + cCliFor + cLoja + cSeq)
If !lUsaTabSec
	//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
	If (cAlias)->(IndexOrd()) # 7
		(cAlias)->(dbSetOrder(7))
	Endif
	If (cAlias)->(dbSeek(cTitulo))
		While !(cAlias)->(Eof()) .AND. ;
			AllTrim((cAlias)->(E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA + E5_SEQ)) == cTitulo
			
			//Verificando se o movimento eh compensacao, se o tipo de movimento eh o mesmo, se o tipo do documento nao for estorno e se o movimento nao esta cancelado
			If (cAlias)->E5_MOTBX # cMotBx .OR. (cAlias)->E5_RECPAG == cRP .OR. (cAlias)->E5_TIPODOC # cTipoDoc .OR. (cAlias)->E5_VALOR # nValor
				(cAlias)->(dbSkip())
				Loop
			Endif
			If !ExREGTMP((cAlias)->(Recno()))
				nREGEst := (cAlias)->(Recno())
			Else 
				(cTabTMP)->(dbGoto((cAlias)->(Recno())))
				If Empty((cTabTMP)->E5_SEQ) .OR. (cTabTMP)->E5_SEQ == cSeqZer
					nREGEst := (cAlias)->(Recno())
				Else
					(cAlias)->(dbSkip())
					Loop
				Endif
			Endif
			Exit
		EndDo
	Endif
Else    
	If !TcCanOpen(cTabRefEst)
		Return nREGEst
	Endif               
	cQry := "SELECT E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ, E5_MOTBX, E5_RECPAG, E5_TIPODOC, "
	cQry += "E5_VALOR, R_E_C_N_O_ REG "
	cQry += "FROM " + cTabRefEst + " " 
	cQry += "WHERE ((E5_FILIAL = '" + AjustaSTR(cFil) + "') AND (E5_PREFIXO = '" + AjustaSTR(cPrefixo) + "') AND (E5_NUMERO = '" + AjustaSTR(cNumero) + "') AND "
	cQry += "(E5_PARCELA = '" + AjustaSTR(cParc) + "') AND (E5_TIPO = '" + AjustaSTR(cTipo) + "') AND (E5_CLIFOR = '" + AjustaSTR(cCliFor) + "') AND "
	cQry += "(E5_LOJA = '" + AjustaSTR(cLoja) + "') AND (E5_SEQ = '" + AjustaSTR(cSeq) + "')) "
	cQry += "ORDER BY E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ, R_E_C_N_O_ "
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAliasNovo,.T.,.T.)
	TcSetField(cAliasNovo,"E5_VALOR","N",17,2)
	TcSetField(cAliasNovo,"REG","N",10,0)
	dbSelectArea(cAliasNovo)
	(cAliasNovo)->(dbGoTop())
	Do While !(cAliasNovo)->(Eof())
		//Verificando se o movimento eh compensacao, se o tipo de movimento eh o mesmo, se o tipo do documento nao for estorno e se o movimento nao esta cancelado
		If (cAliasNovo)->E5_MOTBX # cMotBx .OR. (cAliasNovo)->E5_RECPAG == cRP .OR. (cAliasNovo)->E5_TIPODOC # cTipoDoc .OR. ;
			(cAliasNovo)->E5_VALOR # nValor
			
			(cAliasNovo)->(dbSkip())
			Loop
		Endif
		//O registro de estorno pode ser usado quando : 1. Nao existe registro na tab. temp. de grav. / 2. Se existir, o sequencial estiver vazio
		If !ExREGTMP((cAlias)->(Recno()))
			nREGEst := (cAliasNovo)->REG
		Else 
			(cTabTMP)->(dbGoto((cAliasNovo)->REG))
			If Empty((cTabTMP)->E5_SEQ)
				nREGEst := (cAliasNovo)->REG
			Else
				(cAliasNovo)->(dbSkip())
				Loop
			Endif
		Endif		
		Exit
	EndDo       
	FechaArqT(cAliasNovo)
Endif	
RestArea(aArea)

Return nREGEst

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjSeqBxAliบAutor  ณPablo Gollan Carreras บ Data ณ  30/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEncerrar os alias utilizados apos o processamento             บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjSeqBxAlias(cAlias,aArea)

If Select(cAlias) > 0
	dbSelectArea(cAlias)
	dbCloseArea()
Endif
If Select("__SUB") > 0
	dbSelectArea("__SUB")
	dbCloseArea()
Endif
RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLevOutDoc บAutor  ณPablo Gollan Carreras บ Data ณ  03/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLevantar todos os outros tipos de documentos envolvidos em    บฑฑ
ฑฑบ          ณuma sequencia de baixa,para que a seq.do pai seja replicada   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LevOutDoc(cAlias, cFil, cTipoDoc, cPrefixo, cNumero, cParc, cTipo, dData, cCliFor, cLoja, cSeq, cRP, nREG)

Local aRet			:= {}
Local aArea			:= GetArea()
Local cTitulo		:= ""
Local cAliasNovo	:= IIf(lUsaTabSec,GetNextAlias(),"")

If Len(cFil + cTipoDoc + cPrefixo + cNumero + cParc + cTipo + cCliFor + cLoja + cSeq + cRP) == 0 .OR. Empty(dData)
	Return aRet
Endif
//Se o titulo corrente nao for do tipo de documento que gera sequencia de movimento, sair
If aScan(aTipoDoc,{|x| AllTrim(x) == AllTrim(cTipoDoc)}) == 0
	Return aRet
Endif
cTitulo := AllTrim(cFil + cPrefixo + cNumero + cParc + cTipo + cCliFor + cLoja + cSeq)
If !lUsaTabSec
	If (cAlias)->(IndexOrd()) # 7	//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
		(cAlias)->(dbSetOrder(7))
	Endif
	If (cAlias)->(dbSeek(cTitulo))
		While !(cAlias)->(Eof()) .AND. ;
			AllTrim((cAlias)->(E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA + E5_SEQ)) == cTitulo
		
			//Caso o tipo de operacao seja diferente, a data seja diferente ou o tipo do documento for de estorno, sair
			If (cAlias)->E5_RECPAG # cRP .OR. (cAlias)->E5_DATA # dData .OR. (cAlias)->E5_TIPODOC == "ES"
				(cAlias)->(dbSkip())
				Loop
			Endif
			//Caso o tipo do documento seja de um tipo de documento que gera sequencia de baixa, saltar
			If aScan(aTipoDoc, {|x| AllTrim(x) == (cAlias)->E5_TIPODOC}) > 0
				(cAlias)->(dbSkip())
				Loop			
			Endif         
			//Caso o numero do registro for inferior ao do tipo que gerou a seq do movimento, desconsiderar pois ele automaticamente ficara alinhado ao principal
			If (cAlias)->(Recno()) < nREG
				(cAlias)->(dbSkip())
				Loop
			Endif
			aAdd(aRet,(cAlias)->(Recno()))
			(cAlias)->(dbSkip())
		EndDo
	Endif
Else    
	If !TcCanOpen(cTabRefEst)
		Return aRet
	Endif               
	cQry := "SELECT E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ, E5_MOTBX, E5_RECPAG, E5_TIPODOC, "
	cQry += "E5_VALOR, E5_DATA, R_E_C_N_O_ REG "
	cQry += "FROM " + cTabRefEst + " " 
	cQry += "WHERE ((E5_FILIAL = '" + AjustaSTR(cFil) + "') AND (E5_PREFIXO = '" + AjustaSTR(cPrefixo) + "') AND (E5_NUMERO = '" + AjustaSTR(cNumero) + "') AND "
	cQry += "(E5_PARCELA = '" + AjustaSTR(cParc) + "') AND (E5_TIPO = '" + AjustaSTR(cTipo) + "') AND (E5_CLIFOR = '" + AjustaSTR(cCliFor) + "') AND "
	cQry += "(E5_LOJA = '" + AjustaSTR(cLoja) + "') AND (E5_SEQ = '" + AjustaSTR(cSeq) + "')) "
	cQry += "ORDER BY E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ, R_E_C_N_O_ "
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAliasNovo,.T.,.T.)
	TcSetField(cAliasNovo,"E5_VALOR","N",17,2)
	TcSetField(cAliasNovo,"E5_DATA","D",8,0)
	TcSetField(cAliasNovo,"REG","N",10,0)
	dbSelectArea(cAliasNovo)
	(cAliasNovo)->(dbGoTop())
	Do While !(cAliasNovo)->(Eof())
		//Caso o tipo de operacao seja diferente, a data seja diferente ou o tipo do documento for de estorno, sair
		If (cAliasNovo)->E5_RECPAG # cRP .OR. (cAliasNovo)->E5_DATA # dData .OR. (cAliasNovo)->E5_TIPODOC == "ES"
			(cAliasNovo)->(dbSkip())
			Loop
		Endif
		//Caso o tipo do documento seja de um tipo de documento que gera sequencia de baixa, saltar
		If aScan(aTipoDoc, {|x| AllTrim(x) == (cAliasNovo)->E5_TIPODOC}) > 0
			(cAliasNovo)->(dbSkip())
			Loop			
		Endif         
		//Caso o numero do registro for inferior ao do tipo que gerou a seq do movimento, desconsiderar pois ele automaticamente ficara alinhado ao principal
		If (cAliasNovo)->REG < nREG
			(cAliasNovo)->(dbSkip())
			Loop
		Endif
		aAdd(aRet,(cAliasNovo)->REG)
		(cAliasNovo)->(dbSkip())
	EndDo       
	FechaArqT(cAliasNovo)
Endif	
RestArea(aArea)         

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTamTitDoc บAutor  ณPablo Gollan Carreras บ Data ณ  04/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o tamanho do E5_DOCUMEN que deve ser utilizado para   บฑฑ
ฑฑบ          ณformar chave de pesquisa e limitar strings de documentos      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TamTitDoc(cDocumen,nTamAtu)

Local aTamMin 		:= {3 /*prefixo*/,6 /*numero*/, 1 /*parcela*/, 3 /*tipo*/}
Local nTamMin		:= 0
Local nTamTit		:= 0      
Local nTamNovo		:= 0
Local ni			:= 0
Local nPos			:= 0      

Default nTamAtu	:= 0

nTamTit := nTamAtu
If Empty(cDocumen)
	Return nTamTit
Endif
aEval(aTamMin,{|x| nTamMin += x})
For ni := 1 to Len(aTipoTit)
	If !Empty(aTipoTit[ni][1])
		If PadR(aTipoTit[ni][1],aTamChv[4]) $ cDocumen            
			nPos := At(PadR(aTipoTit[ni][1],aTamChv[4]), cDocumen)
			nTamNovo := nPos + (aTamChv[4] - 1)
			//Se o tipo encontrado nao estiver na posicao minima esperada, procurar novamente
			If nPos > 0 .AND. nTamNovo < nTamMin
				nPos := At(PadR(aTipoTit[ni][1],aTamChv[4]),Substr(cDocumen,nTamNovo+1,Len(cDocumen)))
				nTamNovo := nPos + ((aTamChv[4] * 2) - 1)
			Endif
			If nPos > 0 .AND. nTamNovo >= nTamMin
				If nTamTit == 0
					nTamTit := nPos + nTamNovo
				Else
					If nTamTit # nTamNovo
						nTamTit := nTamNovo
					Endif
				Endif
				Exit
			Endif
		Endif
	Endif
Next ni

Return nTamTit

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROXSEQ   บAutor  ณPablo G. Carreras   บ Data ณ  10/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบParametrosณcCodigo - Codigo sequencial                                 บฑฑ
ฑฑบ          ณnCasas - Para fixar o numero de casas a ser utilizado       บฑฑ
ฑฑบ          ณlNaoPerReg - Nao permite a regressao do primeiro digito     บฑฑ
ฑฑบ          ณlNum - Se .T. nos valores numericos sequencia apenas numerosบฑฑ
ฑฑบ          ณlUsaMin - Se .T. usa caracteres minusculas para sequencia   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFinanceiro                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProxSeq(cCodigo,nCasas,lNaoPerReg,lNum,lUsaMin)

Local ni			:= 0
Local nTMP			:= 0
Local lSobePS		:= .F.
Local cNCod			:= ""
Local lAltera		:= .T.

Static aInter01		:= {48 /*0*/,57 /*9*/}
Static aInter02		:= {65 /*A*/,90 /*Z*/}
Static aInter03		:= {97 /*a*/,122 /*z*/}

Default nCasas		:= Len(AllTrim(cCodigo))
Default lNaoPerReg	:= .T.
Default lNum		:= .T.                           
Default lUsaMin		:= .T.
                                                
//Sequencia : 1 - Numero, 2 - Maiusculas, 3 - Minusculas + Maiusculas, 4 - Minusculas
If Empty(cCodigo)
	Return cNCod
Endif
For ni := Len(cCodigo) to 1 Step -1
	If!lSobePS
		nTMP := Asc(Substr(cCodigo,ni,1))
	Else
		nTMP := Asc(Substr(cCodigo,ni,1)) + 1 
		lAltera := .F.
		If lNaoPerReg .AND. ni == 1 .AND. (nTMP > aInter03[2])
			//Nao permitir regressao do primeiro caracter, para efeito de classificacao, zerar
			cNCod := StrZero(0,nCasas)
			Exit
		Else
			If nTMP > aInter01[2] .AND. nTMP < aInter02[1]
				nTMP := aInter02[1]
			ElseIf nTMP > aInter02[2] .AND. nTMP < aInter03[1]
				If lUsaMin
					nTMP := aInter03[1]
				Else 
					nTMP := aInter01[1]
				Endif
			ElseIf nTMP < aInter01[1]
				nTMP := aInter01[1]
			ElseIf nTMP > aInter03[2]
				nTMP := aInter01[1]
			Else
				nTMP := Asc(Substr(cCodigo,ni,1))
				lAltera := .T.
			Endif
		Endif
	Endif  
	If lAltera
		//Numeros
		If nTMP >= aInter01[1] .AND. nTMP <= aInter01[2]
			If nTMP == aInter01[2] //Ultimo
				lSobePS := .F.
				If ni > 1 .AND. lNum //Se nao for a 1a posicao e para numericos somente seq. numerica, permitir apenas numeros
					If Substr(cCodigo,ni - 1,1) $ "0123456789"
						lSobePS := .T.
						nTMP := aInter01[1]
					Else
						nTMP := aInter02[1]	
					Endif  
				Else
					nTMP := aInter02[1]				
				Endif
			Else 
				lSobePS := .F.
				nTMP++
			Endif
		Else              
			//Maiusculas
			If nTMP >= aInter02[1] .AND. nTMP <= aInter02[2]
				If lUsaMin
					If nTMP == aInter02[2] //Ultimo
						lSobePS := .F.
						nTMP := aInter03[1]
					Else 
						lSobePS := .F.
						nTMP++
					Endif
				Else 
					If nTMP == aInter02[2] //Ultimo     
						If lNaoPerReg .AND. ni == 1
							cNCod := StrZero(0,nCasas)
							Exit
						Else
							lSobePS := .T.
							nTMP := aInter01[1]
						Endif
					Else 
						lSobePS := .F.
						nTMP++
					Endif				
				Endif
			Else
				//Minusculas
				If nTMP >= aInter03[1] .AND. nTMP <= aInter03[2] .AND. lUsaMin
					If nTMP == aInter03[2] //Ultimo     
						If lNaoPerReg .AND. ni == 1
							cNCod := StrZero(0,nCasas)
							Exit
						Else
							lSobePS := .T.
							nTMP := aInter01[1]
						Endif
					Else 
						lSobePS := .F.
						nTMP++
					Endif
				Endif
			Endif
		Endif                                                   
		lAltera := .F.
	Endif
	cNCod := Chr(nTMP) + cNCod
Next ni       

Return cNCod

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldTab    บAutor  ณPablo Gollan Carreras บ Data ณ  14/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldTab(cArq)

Local lRet			:= .F.

If Empty(cArq)
	Return !lRet
Endif
If !(lRet := MsFile(cArq,Nil, __cRDD))
	MsgAlert("A tabela digitada nใo existe!",cRotina)
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcTabSecบAutor  ณPablo Gollan Carreras บ Data ณ  14/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para efetuar o processamento de uma tab. secundaria    บฑฑ
ฑฑบ          ณ1. Validar se o nome da tabela jah nao eh a padrao (ex.SE5990)บฑฑ
ฑฑบ          ณ2. Criar nova tabela, copiando a sugestionada                 บฑฑ
ฑฑบ          ณ3. Buscar o ultimo recno                                      บฑฑ
ฑฑบ          ณ4. Trazer os registros acima do recno determinado na tabela   บฑฑ
ฑฑบ          ณ   padrao, que eh quem sera substituida                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcTabSec(cAlias,aEstru)

Local lRet		:= .T.
Local cQry		:= "" 
Local ni		:= 0
Local cTabOr	:= RetSqlName("SE5")
Local cTabNova	:= AllTrim(cTabRefEst) + "_REF"
Local cAlias02	:= GetNextAlias()
Local nUltREG	:= 0

If Empty(cTabRefEst)
	Return lRet                            
Else        
	//Caso a tabela sugerida seja a padrao, sair
	If AllTrim(cTabRefEst) == AllTrim(RetSQLName("SE5"))
		Return lRet
	Endif
Endif
If !lRet
	Return lRet
Endif   
ProcRegua(3)
IncProc()
//1. CRIAR NOVA TABELA, COPIANDO A SECUNDARIA
If MsFile(cTabNova,Nil,__cRDD)
	cQry := "DROP TABLE " + cTabNova
	If TcSQLExec(cQry) < 0
		UserException("Erro ao tentar excluir a tabela temporaria secundaria " + AllTrim(cTabNova) + CRLF + TCSqlError())
		lRet := .F.
	Else
		If TcGetDB() $ "ORACLE"
			cQry := "COMMIT"
			TcSQLExec(cQry)	
		Endif 
	Endif  
Endif
//Criando estrutura da tabela de processamento baseada na tabela padrao (criar a partir da estrutura da tab. padrao, pois a secundaria pode ter uma estrutura antiga)
If TcGetDB() $ "ORACLE"
	cQry := " CREATE TABLE " + cTabNova + " AS " 
	cQry := "SELECT * "
	cQry += "FROM " + cTabOr + " "
	cQry += "WHERE 1 = 0" 
Else
	cQry := "SELECT * "
	cQry += "INTO " + cTabNova + " "
	cQry += "FROM " + cTabOr + " "
	cQry += "WHERE 1 = 0" 
EndIf	
If TcSQLExec(cQry) < 0
	UserException("Erro na gera็ใo da copia da tabela secundaria " + AllTrim(cTabNova) + CRLF + TCSqlError())
	lRet := .F.
Else
	If TcGetDB() $ "ORACLE"
		cQry := "COMMIT"
		TcSQLExec(cQry)	
	Endif                 
	If !TcCanOpen(cTabNova)
		UserException("A c๓pia da tabela secundaria criada (" + AllTrim(cTabNova) + ") nใo pode ser aberta!")
		lRet := .F.
	Endif
Endif        
//Gravando os dados da tabela secundaria na tabela temporaria de processamento
cQry := "INSERT "
cQry += "INTO " + cTabNova + " "
cQry += "SELECT * FROM " + cTabRefEst + " "
cQry += "WHERE D_E_L_E_T_ <> '*' "
If TcSQLExec(cQry) < 0
	UserException("Erro na grava็ใo dos dados da tabela secundaria " + AllTrim(cTabNova) + CRLF + TCSqlError())
	lRet := .F.
Else
	If TcGetDB() $ "ORACLE"
		cQry := "COMMIT"
		TcSQLExec(cQry)	
	Endif                 
Endif        
If !lRet
	Return lRet
Endif   
IncProc()          
TcRefresh(cTabOr)
cQry := "SELECT MAX(R_E_C_N_O_) NMAXREC "
cQry += "FROM " + cTabRefEst + " "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAlias02,.T.,.T.)
TcSetField(cAlias02,"NMAXREC","N",18,0)
(cAlias02)->(dbGoTop())
If !(cAlias02)->(Eof())
	If !Empty((cAlias02)->NMAXREC)
		nUltREG := (cAlias02)->NMAXREC                                               
	Endif	
Endif
FechaArqT(cAlias02)
IncProc()
cQry := "INSERT "
cQry += "INTO " + cTabNova + " "
cQry += "SELECT * FROM " + cTabOr + " "
cQry += "WHERE D_E_L_E_T_ <> '*' AND R_E_C_N_O_ > " + cValToChar(nUltREG) + " AND "
cQry += "R_E_C_N_O_ NOT IN (SELECT B.R_E_C_N_O_ FROM " + cTabNova + " B)"
If TcSQLExec(cQry) < 0
	UserException("Erro na gravacao dos registros excedentes da tabela atual na tabela temporaria " + CRLF + TCSqlError())
	lRet := .F.
Else
	If TcGetDB() $ "ORACLE"
		cQry := "COMMIT"
		TcSQLExec(cQry)	
	Endif                 
Endif        
If !lRet
	Return lRet
Endif      
TcSetDummy(.T.)
dbUseArea(.T.,__cRDD,cTabNova,cAlias,.T.,.F.)
For ni := 1 to Len(aEstru)
	If aEstru[ni][2] # "C"
		TcSetField(cAlias,aEstru[ni,1],aEstru[ni,2],aEstru[ni,3],aEstru[ni,4])
	Endif
Next ni
TcSetDummy(.F.)
cTabRefEst := cTabNova
lUsaTabSec := .T.

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProxSEQID บAutor  ณ                      บ Data ณ  17/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProxSEQID(nModo,cSeqBxIDCont)

Local cNumC		:= ""     
Local cPar		:= "MV_NUMCOMP"
Local lGrvPar	:= .F.

Default nModo	:= 1

Do Case
	Case nModo == 1	//Agregar variavel
		If Empty(cSeqBxIDCont)
			cSeqBxIDCont := Soma1(SuperGetMv(cPar,.T.,Replicate("0",6)),6)
		Else
			cSeqBxIDCont := Soma1(cSeqBxIDCont,6)
		Endif
		cNumC := cSeqBxIDCont
	Case nModo == 2 //Original                                  
		cNumC := SuperGetMv(cPar,.T.,Replicate("0",6))
	Case nModo == 3 //Agregar parametro
		cNumC := Soma1(SuperGetMv(cPar,.T.,Replicate("0",6)),6)
		Do While !MayIUseCode("IDENTEE" + xFilial("SE1") + cNumC)
			cNumC := Soma1(cNumC)
		EndDo                        
		lGrvPar := .T.
	Case nModo == 4	//Gravar parametro
		cNumC := cSeqBxIDCont
		lGrvPar := .T.	
EndCase
If lGrvPar
	dbSelectArea("SX6")                                                            
	If SX6->(dbSeek(xFilial("SX6") + cPar))
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD	:= cNumC
		SX6->X6_CONTSPA	:= cNumC
		SX6->X6_CONTENG	:= cNumC
		MsUnlock()
	Endif
Endif

Return cNumC

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
ฑฑบPrograma  ณRetQtdeFilบAutor  ณPablo Gollan Carreras บ Data ณ  28/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para retornar a quantidade total de filiais empresa    บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetQtdeFil(cEmp, cEmp)

Local aAreaSM0	:= SM0->(GetArea())
Local aRet		:= {}              

If Empty(cEmp)
	cEmp := cEmpAnt
Endif
dbSelectArea("SM0")   
SM0->(dbGoTop())
Do While !SM0->(Eof())
	If AllTrim(SM0->M0_CODIGO) == AllTrim(cEmp)
		aAdd(aRet,SM0->M0_CODFIL)
	Endif
	SM0->(dbSkip())
EndDo
RestArea(aAreaSM0)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetFilCorrบAutor  ณPablo Gollan Carreras บ Data ณ  28/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para retornar a filial correta, caso o campo E5_FILORIGบฑฑ
ฑฑบ          ณesteja incorreto.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                            

Static Function RetFilCorr(cFilOrig,cPrefixo,cNumero,cParcela,cTipo,cCliFor,cLoja,cRP,lForcaPesq)

Local aAreaSE1		:= SE1->(GetArea())
Local aAreaSE2		:= SE2->(GetArea())
Local ni			:= 0

Default lForcaPesq		:= .F.

If (Len(aLstFilial) == 0 .AND. !lForcaPesq) .OR. Empty(cFilOrig) .OR. !lFilOr
	Return cFilOrig
Endif                                           
//Normal ou adiantamento
If (cRP == "R" .AND. !(cTipo $ MVPAGANT + "/" + MV_CPNEG )) .OR. (cRP == "P" .AND. (cTipo $ MVRECANT + "/" + MV_CRNEG ))
	//Se a filial nao existe, assumir que a filial correta eh a 01
	If aScan(aLstFilial,{|x| x == cFilOrig}) == 0           
		cFilOrig := PadL("1",TamSX3("E5_FILIAL")[1],"0")
	Endif
	dbSelectArea("SE1")
	SE1->(dbSetOrder(1))
	If SE1->(dbSeek(cFilOrig + cPrefixo + cNumero + cParcela + cTipo))
		Do While !SE1->(Eof()) .AND. RTrim(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)) == RTrim(cFilOrig + cPrefixo + cNumero + cParcela + cTipo)
			If AllTrim(SE1->E1_CLIENTE) == AllTrim(cCliFor) .AND. AllTrim(SE1->E1_LOJA) == AllTrim(cLoja)
				//Titulo encontrado com a filial determinada pelo campo E5_FILORIG, sair sem alterar a E5_FILORIG
				Exit
			Endif
			SE1->(dbSkip())
		EndDo
	Else
		//Titulo nao encontrado com a filial determinada pelo campo E5_FILORIG, varrer as outras filiais
		For ni := 1 to Len(aLstFilial)
			If aLstFilial[ni] # cFilOrig
				SE1->(dbSeek(aLstFilial[ni] + cPrefixo + cNumero + cParcela + cTipo))
				Do While !SE1->(Eof()) .AND. RTrim(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)) == ;
					RTrim(aLstFilial[ni] + cPrefixo + cNumero + cParcela + cTipo)

					If AllTrim(SE1->E1_CLIENTE) == AllTrim(cCliFor) .AND. AllTrim(SE1->E1_LOJA) == AllTrim(cLoja)
						//Titulo encontrado com a filial determinada pelo campo E5_FILORIG, alterar
						cFilOrig := aLstFilial[ni]
						Exit
					Endif
					SE1->(dbSkip())
				EndDo			
			Endif
		Next ni
	Endif
Else                                               
	//Se a filial nao existe, assumir que a filial correta eh a 01
	If aScan(aLstFilial,{|x| x == cFilOrig}) == 0           
		cFilOrig := PadL("1",TamSX3("E5_FILIAL")[1],"0")
	Endif
	dbSelectArea("SE2")
	SE2->(dbSetOrder(1))
	If !SE2->(dbSeek(cFilOrig + cPrefixo + cNumero + cParcela + cTipo + cCliFor + cLoja))
		//Titulo nao encontrado com a filial determinada pelo campo E5_FILORIG, varrer as outras filiais
		For ni := 1 to Len(aLstFilial)
			If aLstFilial[ni] # cFilOrig
				If SE2->(dbSeek(aLstFilial[ni] + cPrefixo + cNumero + cParcela + cTipo + cCliFor + cLoja))
					//Titulo encontrado com a filial determinada pelo campo E5_FILORIG, alterar
					cFilOrig := aLstFilial[ni]
					Exit
				Endif
			Endif
		Next ni
	Endif	
Endif
RestArea(aAreaSE1)
RestArea(aAreaSE2)

Return cFilOrig

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvFilOr  บAutor  ณPablo Gollan Carreras บ Data ณ  05/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para gravar a filial de origem na tabela temporaria de บฑฑ
ฑฑบ          ณreprocessamento.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvFilOr(cAlias,nCampos,aEstru,cFilTMP,cCabecLOG,aCabecLOG,cFil)

Local lRet			:= .T.
Local aCmpAlter		:= {}  

Default aEstru 	:= SE5->(dbStruct())
Default nCampos	:= Len(aEstru)

If Empty(cFilTMP) .OR. Empty(cAlias)
	Return lRet
Endif
aCmpAlter := {{"E5_FILORIG",cFilTMP}}                   
If (!Empty(cCabecLOG) .OR. Len(aCabecLOG) > 0) .AND. lGLOG
	WriteLOG("Motivo : AJUSTE E5_FILORIG - " + (cAlias)->E5_FILORIG + " -> " + cFilTMP)
	MontaLOG(cCabecLOG,aCabecLOG,{cFil,(cAlias)->E5_PREFIXO,(cAlias)->E5_NUMERO,(cAlias)->E5_PARCELA,(cAlias)->E5_TIPO,(cAlias)->E5_TIPODOC,;
		(cAlias)->E5_CLIFOR,(cAlias)->E5_LOJA,(cAlias)->E5_SEQ,"---","---",(cAlias)->(Recno()),(cAlias)->E5_DOCUMEN},.F.,"|")	
	WriteLOG(Replicate("-",150))
Endif
If !GrvRegMov(2, cAlias, nCampos, aEstru, aCmpAlter)
	Return !lRet
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTotREGTab บAutor  ณPablo Gollan Carreras บ Data ณ  06/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para retornar o total de registros da tabela temporariaบฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TotREGTab(cAlias)

Local cQry			:= ""
Local nTotREG		:= 0
Local cAlias02		:= GetNextAlias()

If Empty(cAlias)
	Return nTotREG
Endif
cQry := "SELECT COUNT(R_E_C_N_O_) CONT "
cQry += "FROM " + cAlias + " "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAlias02,.T.,.T.)
TcSetField(cAlias02,"CONT","N",18,0)
(cAlias02)->(dbGoTop())
If !(cAlias02)->(Eof())
	If !Empty((cAlias02)->CONT)
		nTotREG := (cAlias02)->CONT
	Endif	
Endif
FechaArqT(cAlias02)

Return nTotREG

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtTabSec  บAutor  ณPablo Gollan Carreras บ Data ณ  07/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para inserir na tabela temporaria de referencia de     บฑฑ
ฑฑบ          ณproc. registros novos inseridos apos o inicio do processamentoบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtTabSec(cAlias,nUltRegTS)

Local lRet			:= .T.
Local cQry			:= ""
Local cAlias02		:= GetNextAlias()    
Local cTabOr		:= RetSqlName("SE5")
Local nUltREG		:= 0
Local nProxREG		:= 0

Default nUltRegTS	:= 0

If !lUsaTabSec .OR. Empty(cAlias)
	Return lRet
Endif            
If nUltRegTS == 0
	//Pesquisar ultimo registro da tabela de referencia temporaria
	cQry := "SELECT MAX(R_E_C_N_O_) NMAXREC "
	cQry += "FROM " + cTabRefEst + " "
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAlias02,.T.,.T.)
	TcSetField(cAlias02,"NMAXREC","N",18,0)
	(cAlias02)->(dbGoTop())
	If !(cAlias02)->(Eof())
		If !Empty((cAlias02)->NMAXREC)
			nUltREG := (cAlias02)->NMAXREC                                               
		Endif	
	Endif
	FechaArqT(cAlias02)
Else
	nUltREG	:= nUltRegTS
Endif
//Incluir registros novos da tabela padrao, caso existam
cQry := "INSERT "
cQry += "INTO " + cTabRefEst + " "
cQry += "SELECT * FROM " + cTabOr + " "
cQry += "WHERE D_E_L_E_T_ <> '*' AND R_E_C_N_O_ > " + cValToChar(nUltREG) + " AND "
cQry += "R_E_C_N_O_ NOT IN (SELECT B.R_E_C_N_O_ FROM " + cTabRefEst + " B)"
If TcSQLExec(cQry) < 0
	UserException("Erro na gravacao dos registros excedentes da tabela atual na tabela temporaria " + CRLF + TCSqlError())
	lRet := .F.
Else
	If TcGetDB() $ "ORACLE"
		cQry := "COMMIT"
		TcSQLExec(cQry)	
	Endif
Endif      
//Procurar o proximo registro a posicionar para continuar o processamento
cQry := "SELECT MIN(R_E_C_N_O_) NMINREC "
cQry += "FROM " + cTabRefEst + " "
cQry += "WHERE D_E_L_E_T_ <> '*' AND R_E_C_N_O_ > " + cValToChar(nUltREG) + " "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAlias02,.T.,.T.)
TcSetField(cAlias02,"NMINREC","N",18,0)
(cAlias02)->(dbGoTop())
If !(cAlias02)->(Eof())
	If !Empty((cAlias02)->NMINREC)
		nProxREG := (cAlias02)->NMINREC
	Endif	
Endif
FechaArqT(cAlias02)
//Posicionar a tabela temporaria de referencia no proximo recno encontrado
If nProxREG > nUltREG .AND. nProxREG > 0
	(cAlias)->(dbGoto(nProxREG))
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIsBxCanc   บAutor  ณPablo Gollan Carreras บ Data ณ  14/06/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para identificar se um dado movimento possui um estorno บฑฑ
ฑฑบ          ณ(Usar esta funcao ao inves do TemBxCanc, pois trabalha com     บฑฑ
ฑฑบ          ณvarias filiais, nao chumbando a filial corrente.)              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IsBxCanc(aParam,lBxFut)

Local lRet			:= .F.
Local cAliasTMP		:= GetNextAlias()
Local cQry			:= ""
Local ni			:= 0

Default lBxFut		:= .F.

For ni := 1 to Len(aParam)
	If Empty(aParam[ni]) .AND. !cValToChar(ni) $ "1/2/4"	//Se o parametro estiver vazio e nao for os de filial, prefixo e parcela, sair.
		If ni == 1
			If SX2Modo("SE5") == "E"
				Return lRet
			Endif
		Else
			Return lRet
		Endif
	Endif
Next ni
cQry := "SELECT COUNT(R_E_C_N_O_) EST "
cQry += "FROM " + RetSqlName("SE5") + " "
cQry += "WHERE E5_FILIAL = '" + aParam[1] + "' AND E5_PREFIXO = '" + AjustaSTR(aParam[2]) + "' AND E5_NUMERO = '" + AjustaSTR(aParam[3]) + "' AND "
cQry += "E5_PARCELA = '" + AjustaSTR(aParam[4]) + "' AND E5_TIPO = '" + aParam[5] + "' AND E5_CLIFOR = '" + AjustaSTR(aParam[6]) + "' AND "
cQry += "E5_LOJA = '" + aParam[7] + "' AND E5_SEQ = '" + aParam[8] + "' AND D_E_L_E_T_ <> '*' AND "
cQry += "E5_TIPODOC = 'ES' "
If lBxFut
	cQry += "AND E5_DATA <= '" + DtoS(dDataBase) + "' "
EndIf
cQry := ChangeQuery(cQry)
dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAliasTMP,.T.,.T.)
TcSetField(cAliasTMP,"EST","N",10,0)
dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())
If !(cAliasTMP)->(Eof())
	If (cAliasTMP)->EST > 0
		lRet := .T.
	Endif
Endif
FechaArqT(cAliasTMP)		

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExEstCmpTMPบAutor  ณPablo Gollan Carreras บ Data ณ  14/06/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para identificar se jah existe algum estorno de compen- บฑฑ
ฑฑบ          ณsacao processado dentro da tabela temporaria, para nao usar    บฑฑ
ฑฑบ          ณoutro registro indevidamente.                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExEstCmpTMP(aParam)

Local nRegEst		:= 0
Local ni			:= 0
Local cAliasTMP		:= GetNextAlias()
Local cQry			:= ""

For ni := 1 to Len(aParam)
	If Empty(aParam[ni]) .AND. !cValToChar(ni) $ "1/2/4"	//Se o parametro estiver vazio e nao for os de filial, prefixo e parcela, sair.
		If ni == 1
			If SX2Modo("SE5") == "E"
				Return nRegEst
			Endif
		Else
			Return nRegEst
		Endif
	Endif
Next ni
cQry := "SELECT R_E_C_N_O_ REG "
cQry += "FROM " + cTabTMP + " "
cQry += "WHERE E5_FILIAL = '" + aParam[1] + "' AND E5_PREFIXO = '" + AjustaSTR(aParam[2]) + "' AND E5_NUMERO = '" + AjustaSTR(aParam[3]) + "' AND "
cQry += "E5_PARCELA = '" + AjustaSTR(aParam[4]) + "' AND E5_TIPO = '" + aParam[5] + "' AND E5_CLIFOR = '" + AjustaSTR(aParam[6]) + "' AND "
cQry += "E5_LOJA = '" + aParam[7] + "' AND E5_SEQ = '" + aParam[8] + "' AND D_E_L_E_T_ <> '*' "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAliasTMP,.T.,.T.)
TcSetField(cAliasTMP,"REG","N",10,0)
dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())
If !(cAliasTMP)->(Eof())
	nRegEst := (cAliasTMP)->REG
Endif
FechaArqT(cAliasTMP)

Return nRegEst

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBackupTab  บAutor  ณPablo Gollan Carreras บ Data ณ  14/06/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para criar backup de uma determinada tabela de acordo   บฑฑ
ฑฑบ          ณcom o alias passado como parametro.                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BackupTab(cAlias,cEmp)

Local cTabBCKP	:= AllTrim(cAlias + cEmp) + "0_BCKP" + DtoS(dDataBase)
Local cTabOr	:= RetSQLName(cAlias)
Local cASCBase	:= 65
Local ni		:= 0    
Local lRet		:= .T.

If Empty(cAlias) .OR. Empty(cEmp)
	Return !lRet
Endif
Do While MsFile(cTabBCKP + IIf(ni == 0,"",CHR(cASCBase + ni)),Nil,__cRDD)
	ni++	
EndDo
cTabBCKP += IIf(ni == 0,"",CHR(cASCBase + ni))
If TcGetDB() $ "ORACLE"
	cQry := " CREATE TABLE " + cTabBCKP + " AS "
	cQry += "SELECT * "
	cQry += "FROM " + cTabOr + " "
	cQry += "WHERE 1 = 1"      
Else
	cQry := "SELECT * "
	cQry += "INTO " + cTabBCKP + " "
	cQry += "FROM " + cTabOr + " "
	cQry += "WHERE 1 = 1"      
EndIF
If TcSQLExec(cQry) < 0
	UserException("Erro na gera็ใo da tabela de backup " + AllTrim(cTabBCKP) + CRLF + TCSqlError())
	lRet := .F.
Else
	If TcGetDB() $ "ORACLE"
		cQry := "COMMIT"
		TcSQLExec(cQry)	
	Endif                 
	If !TcCanOpen(cTabBCKP)
		UserException("A tabela de backup criada (" + AllTrim(cTabBCKP) + ") nใo pode ser aberta!")
		lRet := .F.
	Endif
Endif        

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbreArqLOG บAutor  ณPablo Gollan Carreras บ Data ณ  16/06/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para abertura do arquivo de LOG que sera utilizado para บฑฑ
ฑฑบ          ณregistrar as alteracoes de base e alertas.                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AbreArqLOG(nMetodo,cEmp)

cArqLOG := "AJ_E5_SEQ_" + cEmp + "_" + DtoS(dDataBase) + ".TXT"
If nMetodo == 1		
	//Criar arquivo
	If lGLOG
		//Apagar os arquivos de LOG da empresa selecionada
		CurDir(cDir)
		aEval(Directory(cDir + Substr(cArqLOG,1,nTamNomeArq) +  "*.TXT"), {|aArq| fErase(aArq[1])})
	Endif
Else
	//Utilizar o jah criado
	If lGLOG
		//Em caso de reprocessamento, buscar o ultimo arquivo da sequencia de LOG
		CurDir(cDir)
		aEval(Directory(cDir + Substr(cArqLOG,1,nTamNomeArq) +  "*.TXT"), {|aArq| cArqLOG := aArq[1]})
	Endif
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaLOG   บAutor  ณPablo Gollan Carreras บ Data ณ  17/06/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                               บฑฑ
ฑฑบ          ณ                                                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaLOG(cCabec,aCabec,aCampos,lEspaco,cSepara)

Local ni			:= 0
Local nTam			:= 0
Local cLinha		:= ""

Default lEspaco	:= .F.
Default cSepara	:= "|"

If Empty(cCabec) .OR. Len(aCabec) == 0 .OR. Len(aCampos) == 0
	Return Nil
Endif
WriteLOG(cCabec)
For ni := 1 to Len(aCampos)
	If !Empty(aCabec[ni])
		nTam := aCabec[ni]
		If ValType(aCampos[ni]) == "C"
			cLinha += PadR(RTrim(aCampos[ni]), nTam) + cSepara
		Else 
			cLinha += PadR(cValToChar(aCampos[ni]), nTam) + cSepara
		Endif
	Endif	
Next ni
If !Empty(cLinha)
	WriteLOG(cLinha)
	If lEspaco
		WriteLOG(" ")
	Endif
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjTabFilhaบAutor  ณPablo Gollan Carreras บ Data ณ  02/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para processar todos os ajustes nos campos de sequenciaบฑฑ
ฑฑบ          ณde movimentos bancarios em tabelas relacionadas.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjTabFilha()

Local lRet		:= .T.

If !lAjSeqBX .AND. Empty(cArqLOG)
	AbreArqLOG(1,cEmpAnt)
Endif
Processa({|| lRet := AjustaSE2()},cRotina,OemToAnsi("Ajustando a seq. baixa do tํt. orig. dos titulos PCC"),.T.)
If !lRet
	MsgAlert("Erro no ajuste de seq. baixa dos tํtulos do PCC!",cRotina)
	Return lRet
Endif
Processa({|| lRet := AjustaSEF()},cRotina,OemToAnsi("Ajustando a seq. baixa dos cheques"),.T.)
If !lRet
	MsgAlert("Erro no ajuste de seq. baixa dos cheques!",cRotina)
	Return lRet
Endif
If FindFunction("AliasInDic")
	If AliasInDic("SFQ")
		Processa({|| lRet := AjustaSFQ()},cRotina,OemToAnsi("Ajustando a seq. da amarra็ใo de parcelas"),.T.)
		If !lRet
			MsgAlert("Erro no ajuste de seq. da amarra็ใo de parcelas!",cRotina)
			Return lRet
		Endif
	Endif
Endif

Return lRet        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSE2 บAutor  ณPablo Gollan Carreras บ Data ณ  02/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para ajustar o campo de sequencia de baixa do titulo   บฑฑ
ฑฑบ          ณoriginadores dos titulos do PCC. Para ret. de PCC na baixa.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSE2()

Local lRet			:= .T.
Local aArea			:= GetArea()
Local cAliasSE2	 	:= GetNextAlias()
Local cSGBD			:= TcGetDB()
Local aLstTitProc	:= {}
Local nMovTit		:= 0
Local cChave		:= ""
Local aEstru		:= {}
Local ni			:= 0           
Local nPos			:= 0
Local nTotREG		:= 0
Local lEncont		:= .F.
Local nTamSeq		:= TamSX3("E5_SEQ")[1]
Local aLstFil		:= RetQtdeFil(cEmpAnt)
Local cUniao		:= SuperGetMV("MV_UNIAO",.F.,"UNIAO")
Local cLoja			:= Replicate("0",TamSX3("E2_LOJA")[1])
Local aNat			:= {AllTrim(SuperGetMv("MV_PISNAT",.F.,"PIS")),AllTrim(SuperGetMv("MV_COFINS",.F.,"COFINS")),AllTrim(SuperGetMv("MV_CSLL",.F.,"CSLL"))} //PCC
Local aNatNome		:= {"PIS","COFINS","CSLL"}		//Caso a natureza do imposto tenha conteudo diferente ao nome do imposto
Local cNatNome		:= ""
Local cNatPCC		:= ""
Local nREGAtu		:= 0
Local lCanc			:= .F.
Local nTotAj		:= 0
Local cPicVal		:= PesqPict("SE2","E2_VALOR")
Local lPCCBaixa 	:= (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .AND. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .AND. ;
				 		  !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .AND. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .AND. ;
						  !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .AND. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .AND. ;
						  !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .AND. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
Local cCabecLOG		:= "FILIAL | PREFIXO | NUMERO     | PARCELA | TIPO | TIPODOC | CLIFOR | LOJA | SEQ.ORIG. | SEQ. SE5  | SEQ.GRAV. | RECNO    | VALOR              |"
Local aCabecLOG		:= {7,9,12,9,6,9,8,6,11,11,11,10,20}
Local aREG			:= {}

If !lPCCBaixa
	Return lRet
Endif
//Criar backup da SE2
If !BackupTab("SE2",cEmpAnt)
	Return !lRet	
Endif                        
WriteLOG(Replicate("-",150))
WriteLOG("AJUSTADOR DE SEQUENCIAL - TABELA SE2 (CONTAS A PAGAR) - SEQ. DOS TIT. ORIGINADORES DE IMP. PCC (RET.PCC BAIXA)")
WriteLOG(" ")
//Abrir as tabelas de referencia e definir ordem de pesquisa
dbSelectArea("SE2")
SE2->(dbSetOrder(0))
aEstru := SE2->(dbStruct())
dbSelectArea("SE5")
SE5->(dbSetOrder(7))   
//Montar a lista de naturezas do PCC
Eval({|| aEval(aNat,{|x| cNatPCC += "'" + x + "',"}), cNatPCC := Substr(cNatPCC,1,Len(cNatPCC)-1)})
nTotREG := SE2->(RecCount())
ProcRegua(nTotREG)
SE2->(dbGoTop())
Do While !SE2->(Eof())
	IncProc()
	If SE2->E2_TIPO == "TX" .OR. !Empty(SE2->E2_TITPAI) .OR. SE2->(Deleted())
		SE2->(dbSkip())
		Loop
	Endif
	If (Empty(SE2->E2_PIS) .AND. Empty(SE2->E2_COFINS) .AND. Empty(SE2->E2_CSLL)) .AND. ;
		(Empty(SE2->E2_VRETPIS) .AND. Empty(SE2->E2_VRETCOF) .AND. Empty(SE2->E2_VRETCSL))
		
		SE2->(dbSkip())
		Loop	
	Endif    
	nREGAtu := SE2->(Recno())
	//Montar a query com os registros que precisam ser reprocessados do PCC
	cQry := "SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_EMISSAO, E2_NATUREZ, E2_VALOR, E2_SEQBX, "
	cQry += "R_E_C_N_O_ REG "
	cQry += "FROM " + RetSQLName("SE2") + " "  
	cQry += "WHERE ((D_E_L_E_T_ <> '*') AND "
	Do Case
		Case cSGBD $ "MSSQL/SYBASE"
			cQry += "(LEN(E2_SEQBX) > 0) AND "
		Case cSGBD $ "ORACLE/MYSQL/POSTGRES/INFORMIX"
			cQry += "(LENGTH(E2_SEQBX) > 0) AND "
		OtherWise
			cQry += "(LEN(E2_SEQBX) > 0) AND "			
	EndCase                                                                            
	cQry += "(E2_PREFIXO = '" + AjustaSTR(SE2->E2_PREFIXO) + "') AND (E2_NUM = '" + AjustaSTR(SE2->E2_NUM) + "') AND (E2_TIPO = 'TX') AND "
	cQry += "(E2_FORNECE = '" + cUniao + "') AND (E2_LOJA = '" + cLoja + "') AND (E2_NATUREZ IN (" + cNatPCC + "))) "
	cQry += "ORDER BY E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, R_E_C_N_O_ "
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,__cRDD,TcGenQry(,,ChangeQuery(cQry)),cAliasSE2,.T.,.F.)
	(cAliasSE2)->(dbGoTop())
	If (cAliasSE2)->(Eof())
		FechaArqT(cAliasSE2)
		SE2->(dbSkip())
		Loop
	Endif
	//Ajustar o tipo dos dados
	For ni := 1 to Len(aEstru)
		If aEstru[ni][2] # "C" .AND. (cAliasSE2)->(FieldPos(aEstru[ni][1])) > 0
			TcSetField(cAliasSE2,aEstru[ni][1],aEstru[ni][2],aEstru[ni][3],aEstru[ni][4])
		Endif
	Next ni
	Do While !(cAliasSE2)->(Eof())
		lEncont := .F.
		cNatNome := ""
		If aScan(aREG,{|x| x == (cAliasSE2)->REG}) > 0
			(cAliasSE2)->(dbSkip())
			Loop
		Endif
		For ni := 1 to Len(aLstFil)
			cChave := AllTrim(aLstFil[ni] + (cAliasSE2)->(E2_PREFIXO + E2_NUM) + SE2->(E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA))
			//Pesquisar se existe dentro da array de titulos processados, algum registro com a chave e a sequencia original jah processado,se tiver, utilizar
			If (nPos := aScan(aLstTitProc,{|aREG| aREG[1] == cChave .AND. aREG[2] == AllTrim((cAliasSE2)->E2_SEQBX)})) > 0
				//Se a sequencia for diferente, rever
				If AllTrim((cAliasSE2)->E2_SEQBX) # aLstTitProc[nPos][3]
					SE2->(dbGoto((cAliasSE2)->REG))
					RecLock("SE2",.F.)
					SE2->E2_SEQBX := aLstTitProc[nPos][3]
					MsUnlock()                     
					SE2->(dbGoto(nREGAtu))
					If lGLOG
						cNatNome := aNatNome[aScan(aNat,{|x| x == AllTrim((cAliasSE2)->E2_NATUREZ)})]
						WriteLOG(Replicate("-",150))
						WriteLOG("TITULO DE IMPOSTO AJUSTADO - " + cNatNome)
						WriteLOG("TIPO - FORNECEDOR : " + AllTrim(SE2->E2_TIPO) + " - " + AllTrim(SE2->E2_FORNECE) + " " + AllTrim(E2_LOJA))
						WriteLOG(" ")
						MontaLOG(cCabecLOG,aCabecLOG,{(cAliasSE2)->E2_FILIAL,(cAliasSE2)->E2_PREFIXO,(cAliasSE2)->E2_NUM,(cAliasSE2)->E2_PARCELA,;
							(cAliasSE2)->E2_TIPO,SE5->E5_TIPODOC,(cAliasSE2)->E2_FORNECE,(cAliasSE2)->E2_LOJA,(cAliasSE2)->E2_SEQBX,aLstTitProc[nPos][3],;
							aLstTitProc[nPos][3],(cAliasSE2)->REG,Transform((cAliasSE2)->E2_VALOR,cPicVal)},.T.,"|")
					Endif		
					nTotAj++
				Endif
				aAdd(aREG,(cAliasSE2)->REG)
				lEncont := .T.
			Else
				If SE5->(dbSeek(cChave))
					Do While !SE5->(Eof()) .AND. RTrim(SE5->(E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA)) == cChave
						lCanc := .F.
						//Se a carteira for a receber, movimento cancelado ou data movimento diferente da geracao do imposto PCC, saltar
						If 	SE5->E5_RECPAG == "R" .OR. SE5->E5_SITUACA == "C" .OR. SE5->E5_DATA # (cAliasSE2)->E2_EMISSAO 
							//Como existem cancelamentos de baixa com titulos de PCC gerados e baixados (MV_CB10925), considerar esta sequencia, mas que podera ser 
							//sobreescrita com uma nova sequencia nao cancelada, caso exista
							If SE5->E5_SITUACA == "C" .AND. SE5->E5_DATA == (cAliasSE2)->E2_EMISSAO 
								lCanc := .T.
							Else
								SE5->(dbSkip())
								Loop
							Endif
						Endif            
						//Se o movimento esta cancelado, saltar (usar IsBxCanc e nao o TemBxCanc)
						If IsBxCanc({SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_SEQ},.F.)
							SE5->(dbSkip())
							Loop
						Endif
						//Se a natureza do movimento nao for do PCC ou o valor do imposto for diferente, saltar
						Do Case 
							Case AllTrim((cAliasSE2)->E2_NATUREZ) == aNat[1]
								If Empty(SE5->E5_VRETPIS) .OR. (cAliasSE2)->E2_VALOR # SE5->E5_VRETPIS
									SE5->(dbSkip())
									Loop
								Endif
							Case AllTrim((cAliasSE2)->E2_NATUREZ) == aNat[2]
								If Empty(SE5->E5_VRETCOF) .OR. (cAliasSE2)->E2_VALOR # SE5->E5_VRETCOF
									SE5->(dbSkip())
									Loop
								Endif
							Case AllTrim((cAliasSE2)->E2_NATUREZ) == aNat[3]
								If Empty(SE5->E5_VRETCSL) .OR. (cAliasSE2)->E2_VALOR # SE5->E5_VRETCSL
									SE5->(dbSkip())
									Loop
								Endif
							Otherwise
								SE5->(dbSkip())
								Loop
						EndCase
						cNatNome := aNatNome[aScan(aNat,{|x| x == AllTrim((cAliasSE2)->E2_NATUREZ)})]
						//Se esta chave + sequencia jah foi processada, saltar pois os impostos desta sequencia devem utilizar a sequencia definida na array
						If aScan(aLstTitProc,{|aREG| aREG[1] == cChave .AND. aREG[2] == AllTrim((cAliasSE2)->E2_SEQBX) .AND. aREG[3] == AllTrim(SE5->E5_SEQ) .AND. aREG[4] == .F.}) > 0
							SE5->(dbSkip())
							Loop
						Endif
						//Se a sequencia for diferente, rever
						If (cAliasSE2)->E2_SEQBX # SE5->E5_SEQ
							SE2->(dbGoto((cAliasSE2)->REG))
							RecLock("SE2",.F.)
							SE2->E2_SEQBX := AllTrim(SE5->E5_SEQ)
							MsUnlock()
							SE2->(dbGoto(nREGAtu))
							If lGLOG
								WriteLOG(Replicate("-",150))
								WriteLOG("TITULO DE IMPOSTO AJUSTADO - " + cNatNome)
								WriteLOG("TIPO - FORNECEDOR : " + AllTrim(SE2->E2_TIPO) + " - " + AllTrim(SE2->E2_FORNECE) + " " + AllTrim(E2_LOJA))
								WriteLOG(" ")
								MontaLOG(cCabecLOG,aCabecLOG,{(cAliasSE2)->E2_FILIAL,(cAliasSE2)->E2_PREFIXO,(cAliasSE2)->E2_NUM,(cAliasSE2)->E2_PARCELA,;
									(cAliasSE2)->E2_TIPO,SE5->E5_TIPODOC,(cAliasSE2)->E2_FORNECE,(cAliasSE2)->E2_LOJA,(cAliasSE2)->E2_SEQBX,SE5->E5_SEQ,;
									SE5->E5_SEQ,(cAliasSE2)->REG,Transform((cAliasSE2)->E2_VALOR,cPicVal)},.T.,"|")
							Endif
							aAdd(aREG,(cAliasSE2)->REG)
							nTotAj++
						Endif
						aAdd(aLstTitProc,{cChave,AllTrim((cAliasSE2)->E2_SEQBX),AllTrim(SE5->E5_SEQ),lCanc})
						If !lCanc
							lEncont := .T.
							Exit
						Else 
							SE5->(dbSkip())
							Loop
						Endif
					EndDo
                Endif
			Endif
			If lEncont
				Exit
			Endif
		Next ni
		(cAliasSE2)->(dbSkip())
	EndDo
	FechaArqT(cAliasSE2)
	SE2->(dbSkip())
EndDo
FechaArqT(cAliasSE2)
//Caso existam registros sem correspondencia no SE5, ajustar o tamanho do E2_SEQBX
cQry := "SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_EMISSAO, E2_NATUREZ, E2_VALOR, E2_SEQBX, "
cQry += "R_E_C_N_O_ REG "
cQry += "FROM " + RetSQLName("SE2") + " "  
cQry += "WHERE ((D_E_L_E_T_ <> '*') AND "
Do Case
	Case cSGBD $ "MSSQL/SYBASE"
		cQry += "(LEN(E2_SEQBX) > 0) AND (LEN(E2_SEQBX) < " + cValToChar(nTamSeq) + ") AND "
	Case cSGBD $ "ORACLE/MYSQL/POSTGRES/INFORMIX"
		cQry += "(LENGTH(E2_SEQBX) > 0) AND (LENGTH(E2_SEQBX) < " + cValToChar(nTamSeq) + ") AND "
	OtherWise
		cQry += "(LEN(E2_SEQBX) > 0) AND (LEN(E2_SEQBX) < " + cValToChar(nTamSeq) + ") AND "
EndCase                                                                            
cQry += "(E2_NATUREZ IN (" + cNatPCC + "))) "
cQry += "ORDER BY E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, R_E_C_N_O_ "
cQry := ChangeQuery(cQry)
dbUseArea(.T.,__cRDD,TcGenQry(,,ChangeQuery(cQry)),cAliasSE2,.T.,.F.)
(cAliasSE2)->(dbGoTop())
If !(cAliasSE2)->(Eof())
	//Ajustar o tipo dos dados
	For ni := 1 to Len(aEstru)
		If aEstru[ni][2] # "C" .AND. (cAliasSE2)->(FieldPos(aEstru[ni][1])) > 0
			TcSetField(cAliasSE2,aEstru[ni][1],aEstru[ni][2],aEstru[ni][3],aEstru[ni][4])
		Endif
	Next ni
	Do While !(cAliasSE2)->(Eof())
		If aScan(aREG,{|x| x == (cAliasSE2)->REG}) > 0
			(cAliasSE2)->(dbSkip())
			Loop
		Endif		
		If !Empty((cAliasSE2)->E2_SEQBX) .AND. Len(AllTrim((cAliasSE2)->E2_SEQBX)) < nTamSeq
			SE2->(dbGoto((cAliasSE2)->REG))
			RecLock("SE2",.F.)
			SE2->E2_SEQBX := PadL(AllTrim((cAliasSE2)->E2_SEQBX),nTamSeq,"0")
			MsUnlock()
			If lGLOG
				cNatNome := aNatNome[aScan(aNat,{|x| x == AllTrim((cAliasSE2)->E2_NATUREZ)})]
				WriteLOG(Replicate("-",150))
				WriteLOG("TITULO DE IMPOSTO AJUSTADO - " + cNatNome)
				WriteLOG("(MOV. DO TITULO GERADOR NAO ENCONTRADO NO SE5 OU COM DIVERGสNCIA DE DADOS)")
				WriteLOG(" ")
				MontaLOG(cCabecLOG,aCabecLOG,{(cAliasSE2)->E2_FILIAL,(cAliasSE2)->E2_PREFIXO,(cAliasSE2)->E2_NUM,(cAliasSE2)->E2_PARCELA,;
					(cAliasSE2)->E2_TIPO,"",(cAliasSE2)->E2_FORNECE,(cAliasSE2)->E2_LOJA,(cAliasSE2)->E2_SEQBX,"",;
					SE2->E2_SEQBX,(cAliasSE2)->REG,Transform((cAliasSE2)->E2_VALOR,cPicVal)},.T.,"|")
			Endif						
			nTotAj++
		Endif		
		(cAliasSE2)->(dbSkip())
	EndDo
Endif
FechaArqT(cAliasSE2)
RestArea(aArea)     
WriteLOG(Replicate("-",150))
WriteLOG("FIM DO AJUSTE DO SE2")
WriteLOG(Space(10) + "- TOTAL DE REGISTROS PROCESSADOS : " + cValToChar(nTotREG))
WriteLOG(Space(10) + "- TOTAL DE REGISTROS AJUSTADOS : " + cValToChar(nTotAj))
For ni := 1 to 10
	WriteLOG(" ")
Next ni

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSEF บAutor  ณPablo Gollan Carreras บ Data ณ  15/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para ajustar o campo de sequencia de baixa do titulo   บฑฑ
ฑฑบ          ณoriginadores dos titulos do PCC. Para ret. de PCC na baixa.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSEF()

Local lRet			:= .T.
Local aArea			:= GetArea()
Local aChave		:= {"EF_FILIAL","EF_BANCO","EF_AGENCIA","EF_CONTA","EF_NUM"}
Local aTitulo		:= {{"E5_PREFIXO","EF_PREFIXO"},{"E5_NUMERO","EF_TITULO"},{"E5_PARCELA","EF_PARCELA"},{"E5_TIPO","EF_TIPO"},{"E5_CLIFOR","EF_FORNECE"},;
						{"E5_LOJA","EF_LOJA"}}
Local ni			:= 0
Local SEFModo		:= SX2Modo("SEF")
Local cChave		:= ""
Local cChvAnt		:= ""
Local lImpCab		:= .T.
Local lMovEnc		:= .F.
Local cSeqOr		:= ""
Local nTotAj		:= 0 
Local nTotREG		:= 0
Local cFil			:= ""
Local lAltera		:= .F.
Local lSaltar		:= .F.
Local cPicVal		:= PesqPict("SEF","EF_VALOR")
Local lDivComp		:= IIf(SX2Modo("SE5") # SX2Modo("SEF"), .T., .F.)
Local cCabecLOG		:= "FILIAL | PREFIXO | NUMERO     | PARCELA | TIPO | TIPODOC | CLIFOR | LOJA | SEQ.ORIG. | SEQ. SE5  | SEQ.GRAV. | RECNO    | VALOR              |"
Local aCabecLOG		:= {7,9,12,9,6,9,8,6,11,11,11,10,20}

WriteLOG(Replicate("-",150))
WriteLOG("AJUSTADOR DE SEQUENCIAL - TABELA SEF (CHEQUES)")
WriteLOG(Replicate("-",150))
WriteLOG("REGRAS DE AMARRACAO CHEQUE x MOVIMENTO : ")                                                   
WriteLOG(" ")
WriteLOG(Space(10) + "1. CHAVE COINCIDENTE COM SE5: FILIAL + BANCO + AGENCIA + CONTA + CHEQUE + EMISSรO")
WriteLOG(Space(10) + "2. CHAVE COINCIDENTE TITULO : PREFIXO + PARCELA + NUMERO + TIPO + FORNECEDOR + LOJA")
WriteLOG(Space(10) + "3. TEM DE TER MESMO VALOR, CARTEIRA, TER O MOVIMENTO NรO CANCELADO E COM SEQÜENCIA")
WriteLOG(Space(10) + "4. MOVIMENTO SEM ESTORNO")
WriteLOG(" ")
//Criar backup da SEF
If !BackupTab("SEF",cEmpAnt)
	Return !lRet	
Endif
dbSelectArea("SE5")
SE5->(dbSetOrder(11))	//E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+DTOS(E5_DATA) (11)
dbSelectArea("SEF")
SEF->(dbSetOrder(1))
nTotREG := SEF->(RecCount())
ProcRegua(nTotREG)
SEF->(dbGoTop())
Do While !SEF->(Eof())
	IncProc()
	cSeqOr 	:= SEF->EF_SEQUENC
	lSaltar := .F.
	lAltera	:= .F.	
	//Validar campos obrigatorios, se vazios, saltar
	For ni := 1 to Len(aChave)
		If Empty(SEF->&(aChave[ni]))
			If ni == 1 .AND. SEFModo == "E"
				lSaltar := .T.
				Exit
			Else
				lSaltar := .T.
				Exit
			Endif
		Endif
	Next ni
	If lSaltar
		If !Empty(SEF->EF_SEQUENC) .AND. Len(AllTrim(SEF->EF_SEQUENC)) < nTamSeq
			RecLock("SEF",.F.)
			SEF->EF_SEQUENC := PadL(AllTrim(SEF->EF_SEQUENC),nTamSeq,"0")
			MsUnlock()
			lAltera := .T.
			nTotAj++
		Endif
		If lAltera
			If lGLOG
				WriteLOG(Replicate("-",150))
				WriteLOG("BANCO - AGENCIA - CONTA : " + AllTrim(SEF->EF_BANCO) + " - " + AllTrim(SEF->EF_AGENCIA) + " - " + AllTrim(SEF->EF_CONTA))
				WriteLOG("CHEQUE - EMISSรO : " + AllTrim(SEF->EF_NUM) + " - " + DtoC(SEF->EF_DATA))
				WriteLOG(" ")
				MontaLOG(cCabecLOG,aCabecLOG,{SEF->EF_FILIAL,SEF->EF_PREFIXO,SEF->EF_TITULO,SEF->EF_PARCELA,SEF->EF_TIPO,"",;
					SEF->EF_FORNECE,SEF->EF_LOJA,cSeqOr,"",SEF->EF_SEQUENC,SEF->(Recno()),Transform(SEF->EF_VALOR,cPicVal)},.T.,"|")
			Endif		
		Endif
		SEF->(dbSkip())
		Loop	
	Endif
	//Caso o campo de sequencia esteja em branco, saltar
	If Empty(SEF->EF_SEQUENC)
		SEF->(dbSkip())
		Loop
	Endif
	cChave 	:= ""
	lImpCab	:= .T.
	lMovEnc	:= .F.
	If SEF->EF_IMPRESS == "C"
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCheques cancelados nao estao amarrados ao movimento ณ
		//ณbancแrio, porque o campo E5_NUMCHEQ eh deixado em   ณ
		//ณbranco no momento do cancelamento.                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !Empty(SEF->EF_SEQUENC) .AND. Len(AllTrim(SEF->EF_SEQUENC)) < nTamSeq
			RecLock("SEF",.F.)
			SEF->EF_SEQUENC := PadL(AllTrim(SEF->EF_SEQUENC),nTamSeq,"0")
			MsUnlock()
			lAltera := .T.
			nTotAj++
		Endif    
		If lAltera
			If lGLOG
				WriteLOG(Replicate("-",150))
				WriteLOG("BANCO - AGENCIA - CONTA : " + AllTrim(SEF->EF_BANCO) + " - " + AllTrim(SEF->EF_AGENCIA) + " - " + AllTrim(SEF->EF_CONTA))
				WriteLOG("CHEQUE - EMISSรO : " + AllTrim(SEF->EF_NUM) + " - " + DtoC(SEF->EF_DATA))
				WriteLOG(" ")
				MontaLOG(cCabecLOG,aCabecLOG,{SEF->EF_FILIAL,SEF->EF_PREFIXO,SEF->EF_TITULO,SEF->EF_PARCELA,SEF->EF_TIPO,"",;
					SEF->EF_FORNECE,SEF->EF_LOJA,cSeqOr,"",SEF->EF_SEQUENC,SEF->(Recno()),Transform(SEF->EF_VALOR,cPicVal)},.T.,"|")
			Endif		
		Endif		
		lMovEnc := .T.
	Else              
		If SE5->(IndexOrd()) # 11
			SE5->(dbSetOrder(11))	//E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+DTOS(E5_DATA)
		Endif
		If lDivComp
			cFil := xFilial("SE5")
		Else 
			cFil := SEF->EF_FILIAL
		Endif
		cChave := cFil + SEF->(EF_BANCO + EF_AGENCIA + EF_CONTA + EF_NUM) + DtoS(SEF->EF_DATA)
		If cChave == cChvAnt
			lImpCab := .F.
		Endif
		lMovEnc := .F.
		If SE5->(dbSeek(cChave))
			Do While !SE5->(Eof()) .AND. RTrim(SE5->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ) + DtoS(SE5->E5_DATA)) == cChave
				//Pesquisar a compatibilidade da chave do titulo SE5 x SEF
				For ni := 1 to Len(aTitulo)
					If AllTrim(SE5->&(aTitulo[ni][1])) # AllTrim(SEF->&(aTitulo[ni][2]))
						SE5->(dbSkip())
						Loop
					Endif
				Next ni
				//Se o titulo nao tiver o mesmo valor, carteira nao for a pagar, se for cancelado, ou se o movimento nao tiver sequencia saltar
				If SE5->E5_VALOR # SEF->EF_VALOR .OR. SE5->E5_RECPAG # "P" .OR. SE5->E5_SITUACA = "C" .OR. Empty(SE5->E5_SEQ)
					SE5->(dbSkip())
					Loop
				Endif
				//Se o movimento esta cancelado, saltar (usar IsBxCanc e nao o TemBxCanc)
				If IsBxCanc({SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_SEQ},.F.)
					SE5->(dbSkip())
					Loop
				Endif
				//Verificar se a sequencia preterida jah nao foi utilizada por outro cheque com a mesma chave e com RECNO inferior
				cQry := "SELECT EF_NUM "
				cQry += "FROM " + RetSQLName("SEF") + " "
				cQry += "WHERE D_E_L_E_T_ <> '*' AND R_E_C_N_O_ < " + SEF->(Recno()) + " AND EF_SEQUENC = '" + SE5->E5_SEQ + "' AND "
				cQry += "EF_FILIAL = '" + SE5->E5_FILIAL + "' AND EF_BANCO = '" + SE5->E5_BANCO + "' AND EF_AGENCIA = '" + SE5->E5_AGENCIA + "' AND "
				cQry += "EF_CONTA = '" + SE5->E5_CONTA + "' AND EF_NUM = '" + SE5->E5_NUMCHEQ + "' AND EF_DATA = '" + DtoS(SE5->E5_DATA) + "'"
				dbUseArea(.T.,__cRDD,TcGenQry(,,cQry),cAliasTMP,.T.,.T.)
				(cAliasTMP)->(dbGoTop())
				If !(cAliasTMP)->(Eof())
					If !Empty((cAliasTMP)->EF_NUM)
						FechaArqT(cAliasTMP)
						SE5->(dbSkip())
						Loop
					Endif
				Endif
				FechaArqT(cAliasTMP)				
				lMovEnc := .T.				
				//Verificar diferenca entre sequencial do SE5 x SEF
				If AllTrim(SE5->E5_SEQ) # Alltrim(SEF->EF_SEQUENC)
					If !Empty(SE5->E5_SEQ)
						RecLock("SEF",.F.)
						SEF->EF_SEQUENC := SE5->E5_SEQ
						MsUnlock()    
						lAltera := .T.
					Else
						If Len(AllTrim(SEF->EF_SEQUENC)) < nTamSeq
							RecLock("SEF",.F.)
							SEF->EF_SEQUENC := PadL(AllTrim(SEF->EF_SEQUENC),nTamSeq,"0")
							MsUnlock()
							lAltera := .T.
						Endif
					Endif
					If lAltera
						nTotAj++
						If lGLOG
							If lImpCab
								WriteLOG(Replicate("-",150))
								WriteLOG("BANCO - AGENCIA - CONTA : " + AllTrim(SEF->EF_BANCO) + " - " + AllTrim(SEF->EF_AGENCIA) + " - " + AllTrim(SEF->EF_CONTA))
								WriteLOG("CHEQUE - EMISSรO : " + AllTrim(SEF->EF_NUM) + " - " + DtoC(SEF->EF_DATA))
								WriteLOG(" ")
							Endif
							MontaLOG(cCabecLOG,aCabecLOG,{SEF->EF_FILIAL,SEF->EF_PREFIXO,SEF->EF_TITULO,SEF->EF_PARCELA,SEF->EF_TIPO,SE5->E5_TIPODOC,;
								SEF->EF_FORNECE,SEF->EF_LOJA,cSeqOr,SE5->E5_SEQ,SE5->E5_SEQ,SEF->(Recno()),Transform(SEF->EF_VALOR,cPicVal)},.T.,"|")
						Endif
					Endif
				Endif
				Exit
			EndDo
		Endif    
		//Caso o cheque nao tenha encontrado movimento correspondente no SE5, alertar
		If !lMovEnc
			//Cheque nao encontrado no SE5
			If !Empty(SEF->EF_SEQUENC) .AND. Len(AllTrim(SEF->EF_SEQUENC)) < nTamSeq
				RecLock("SEF",.F.)
				SEF->EF_SEQUENC := PadL(AllTrim(SEF->EF_SEQUENC),nTamSeq,"0")
				MsUnlock()
				nTotAj++
			Endif    					
			If lGLOG
				If lImpCab
					WriteLOG(Replicate("-",150))
					WriteLOG("BANCO - AGENCIA - CONTA : " + AllTrim(SEF->EF_BANCO) + " - " + AllTrim(SEF->EF_AGENCIA) + " - " + AllTrim(SEF->EF_CONTA))
					WriteLOG("CHEQUE - EMISSรO : " + AllTrim(SEF->EF_NUM) + " - " + DtoC(SEF->EF_DATA))
					WriteLOG(" ")
				Endif
				WriteLOG("(CHEQUE PODE ESTAR COM DIVERGENCIA DE INFORMACOES COM MOV. DO SE5 OU ESTA SEM MOVIMENTO CORRESPONDENTE)")
				WriteLOG(" ")
				MontaLOG(cCabecLOG,aCabecLOG,{SEF->EF_FILIAL,SEF->EF_PREFIXO,SEF->EF_TITULO,SEF->EF_PARCELA,SEF->EF_TIPO,"",;
					SEF->EF_FORNECE,SEF->EF_LOJA,cSeqOr,"",SEF->EF_SEQUENC,SEF->(Recno()),Transform(SEF->EF_VALOR,cPicVal)},.T.,"|")
			Endif		
		Endif
	Endif
	cChvAnt := cChave
	SEF->(dbSkip())
EndDo
RestArea(aArea)
WriteLOG(Replicate("-",150))
WriteLOG("FIM DO AJUSTE DO SEF")                                               
WriteLOG(Space(10) + "- TOTAL DE REGISTROS PROCESSADOS : " + cValToChar(nTotREG))
WriteLOG(Space(10) + "- TOTAL DE REGISTROS AJUSTADOS : " + cValToChar(nTotAj))
For ni := 1 to 10
	WriteLOG(" ")
Next ni

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSFQ บAutor  ณPablo Gollan Carreras บ Data ณ  16/06/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para ajustar o campo de sequencia de baixa na amarra-  บฑฑ
ฑฑบ          ณcao de parcelas.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustaSFQ()

Local lRet			:= .T.
Local aArea			:= GetArea()
Local ni			:= 0
Local nTotREG		:= 0
Local cChave		:= ""
Local aLstTitProc	:= {}
Local nPos			:= 0
Local lDivComp		:= IIf(SX2Modo("SE5") # SX2Modo("SFQ"), .T., .F.)
Local cFil			:= ""
Local aSeqOr		:= {}
Local lAltera		:= .F.
Local lMovEnc		:= .F.
Local nTotAj		:= 0
Local lPCCBaixa 	:= (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .AND. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .AND. ;
				 		  !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .AND. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .AND. ;
						  !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .AND. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .AND. ;
						  !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .AND. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
Local cCabecLOG		:= "FILIAL | PREFIXO | NUMERO     | PARCELA | TIPO | TIPODOC | CLIFOR | LOJA | SEQ.ORIG. | SEQ. SE5  | SEQ.GRAV. | RECNO    |"
Local aCabecLOG		:= {7,9,12,9,6,9,8,6,11,11,11,10}
Local cMens			:= "(AMARRAวรO DE PARCELA ESTม S/ MOVIMENTO CORRESP. NO SE5 OU SEM INF. DOS DADOS DO PCC)"

If !lPCCBaixa
	Return lRet
Endif
//Criar backup da SFQ
If !BackupTab("SFQ",cEmpAnt)
	Return !lRet	
Endif
WriteLOG(Replicate("-",150))
WriteLOG("AJUSTADOR DE SEQUENCIAL - TABELA SFQ (AMARRAวรO DE PARCELAS)")
WriteLOG(" ")
dbSelectArea("SE5")
SE5->(dbSetOrder(7))
dbSelectArea("SFQ")
SFQ->(dbSetOrder(0))  
nTotREG := SFQ->(RecCount())
ProcRegua(nTotREG)
SFQ->(dbGoTop())
Do While !SFQ->(Eof())
	IncProc()
	aSeqOr := {SFQ->FQ_SEQORI,SFQ->FQ_SEQDES}
	If Empty(aSeqOr[1]) .AND. Empty(aSeqOr[2])
		SFQ->(dbSkip())
		Loop
	Endif
	If AllTrim(SFQ->FQ_ENTORI) # "SE5"
		If Len(AllTrim(SFQ->FQ_SEQORI)) # nTamSeq .OR. Len(AllTrim(SFQ->FQ_SEQDES)) # nTamSeq
			RecLock("SFQ",.F.)
			SFQ->FQ_SEQORI := PadL(AllTrim(SFQ->FQ_SEQORI),nTamSeq,"0")
			SFQ->FQ_SEQDES := PadL(AllTrim(SFQ->FQ_SEQDES),nTamSeq,"0")
			MsUnlock()
			lAltera := .T.
			nTotAj++
		Endif                
		If lGLOG
			WriteLOG(Replicate("-",150))
			WriteLOG("PARCELA DE ORIGEM - ENTIDADE (" + AllTrim(SFQ->FQ_ENTORI) + ")")
			WriteLOG(" ")
			MontaLOG(cCabecLOG,aCabecLOG,{SFQ->FQ_FILIAL,SFQ->FQ_PREFORI,SFQ->FQ_NUMORI,SFQ->FQ_PARCORI,SFQ->FQ_TIPOORI,"",SFQ->FQ_CFORI,SFQ->FQ_LOJAORI,;
					aSeqOr[1],"",SFQ->FQ_SEQORI,SFQ->(Recno())},.T.,"|")
			WriteLOG("PARCELA DE DESTINO - ENTIDADE (" + AllTrim(SFQ->FQ_ENTDES) + ")")
			WriteLOG(" ")
			MontaLOG(cCabecLOG,aCabecLOG,{SFQ->FQ_FILDES,SFQ->FQ_PREFDES,SFQ->FQ_NUMDES,SFQ->FQ_PARCDES,SFQ->FQ_TIPODES,"",SFQ->FQ_CFDES,SFQ->FQ_LOJADES,;
					aSeqOr[2],"",SFQ->FQ_SEQDES,SFQ->(Recno())},.T.,"|")		
		Endif
	Else
		If SE5->(IndexOrd()) # 7
			SE5->(dbSetOrder(7))
		Endif     
		If lDivComp
			cFil := xFilial("SE5")
		Else 
			cFil := SFQ->FQ_FILIAL
		Endif
		lAltera := .F.
		lMovEnc	:= .F.
		//ORIGEM
		cChave := cFil + SFQ->(FQ_PREFORI + FQ_NUMORI + FQ_PARCORI + FQ_TIPOORI + FQ_CFORI + FQ_LOJAORI)
		If (nPos := aScan(aLstTitProc,{|aREG| aREG[1] == cChave .AND. aREG[2] == AllTrim(SFQ->FQ_SEQORI)})) > 0
			//Se a sequencia for diferente, rever
			If AllTrim(SFQ->FQ_SEQORI) # aLstTitProc[nPos][3]
				RecLock("SFQ",.F.)
				SFQ->FQ_SEQORI := aLstTitProc[nPos][3]
				MsUnlock()
				lAltera := .T.
			Endif
			lMovEnc	:= .T.
		Else
			If SE5->(dbSeek(cChave))
				Do While !SE5->(Eof()) .AND. RTrim(SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)) == cChave
					//Se nao for movimento de baixa, saltar
					If !AllTrim(SE5->E5_TIPODOC) $ "BA/VL"
						SE5->(dbSkip())
						Loop
					Endif 
					//Caso os campos de valores de retencao estejam todos vazios, saltar
					If Empty(SE5->E5_VRETPIS) .AND. Empty(SE5->E5_VRETCOF) .AND. Empty(SE5->E5_VRETCSL)
						SE5->(dbSkip())
						Loop					
					Endif
					//No caso do pai, caso os campos de controle de retencao nao estar em branco, saltar
					If !Empty(SE5->E5_PRETPIS) .AND. !Empty(SE5->E5_PRETCOF) .AND. !Empty(SE5->E5_PRETCSL)
						SE5->(dbSkip())
						Loop								
					Endif              
					//Se o movimento esta cancelado, saltar (usar IsBxCanc e nao o TemBxCanc)
					If IsBxCanc({SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_SEQ},.F.)
						SE5->(dbSkip())
						Loop
					Endif
					lMovEnc	:= .T.
					If AllTrim(SFQ->FQ_SEQORI) # AllTrim(SE5->E5_SEQ)
						If !Empty(SE5->E5_SEQ)
							RecLock("SFQ",.F.)
							SFQ->FQ_SEQORI := SE5->E5_SEQ
							MsUnlock()
							lAltera := .T.
						Else 
							If Len(AllTrim(SFQ->FQ_SEQORI)) # nTamSeq
								RecLock("SFQ",.F.)
								SFQ->FQ_SEQORI := PadL(AllTrim(SFQ->FQ_SEQORI),nTamSeq,"0")
								MsUnlock()
								lAltera := .T.
							Endif
						Endif
					Endif
					If lAltera
						nTotAj++
						aAdd(aLstTitProc,{cChave,AllTrim(SFQ->FQ_SEQORI),AllTrim(SE5->E5_SEQ)})
						If lGLOG
							WriteLOG(Replicate("-",150))
							WriteLOG("PARCELA DE ORIGEM - ENTIDADE (" + AllTrim(SFQ->FQ_ENTORI) + ")")
							WriteLOG(" ")
							MontaLOG(cCabecLOG,aCabecLOG,{SFQ->FQ_FILIAL,SFQ->FQ_PREFORI,SFQ->FQ_NUMORI,SFQ->FQ_PARCORI,SFQ->FQ_TIPOORI,SE5->E5_TIPODOC,SFQ->FQ_CFORI,SFQ->FQ_LOJAORI,;
								aSeqOr[1],SE5->E5_SEQ,SFQ->FQ_SEQORI,SFQ->(Recno())},.T.,"|")
						Endif
					Endif
					Exit
				EndDo
			Endif
		Endif
		If !lMovEnc
			If !Empty(SFQ->FQ_SEQORI) .AND. Len(AllTrim(SFQ->FQ_SEQORI)) < nTamSeq
				RecLock("SFQ",.F.)
				SFQ->FQ_SEQORI := PadL(AllTrim(SFQ->FQ_SEQORI),nTamSeq,"0")
				MsUnlock()
				nTotAj++
			Endif
			If lGLOG
				WriteLOG(Replicate("-",150))
				WriteLOG("PARCELA DE ORIGEM - ENTIDADE (" + AllTrim(SFQ->FQ_ENTORI) + ")")
				WriteLOG(" ")
				WriteLOG(cMens)
				WriteLOG(" ")
				MontaLOG(cCabecLOG,aCabecLOG,{SFQ->FQ_FILIAL,SFQ->FQ_PREFORI,SFQ->FQ_NUMORI,SFQ->FQ_PARCORI,SFQ->FQ_TIPOORI,"",SFQ->FQ_CFORI,SFQ->FQ_LOJAORI,;
					aSeqOr[1],"",SFQ->FQ_SEQORI,SFQ->(Recno())},.T.,"|")						
			Endif				
		Endif
		//DESTINO 
		lAltera := .F.
		lMovEnc	:= .F.
		cChave := cFil + SFQ->(FQ_PREFDES + FQ_NUMDES + FQ_PARCDES + FQ_TIPODES + FQ_CFDES + FQ_LOJADES)
		If SE5->(dbSeek(cChave))
			Do While !SE5->(Eof()) .AND. RTrim(SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)) == cChave
				//Se nao for movimento de baixa, saltar
				If !AllTrim(SE5->E5_TIPODOC) $ "BA/VL"
					SE5->(dbSkip())
					Loop
				Endif 
				//Caso os campos de valores de retencao estejam todos vazios, saltar
				If Empty(SE5->E5_VRETPIS) .AND. Empty(SE5->E5_VRETCOF) .AND. Empty(SE5->E5_VRETCSL)
					SE5->(dbSkip())
					Loop					
				Endif
				//No caso do filho, caso os campos de controle de retencao nao estar preenchidos com 2 (retido), saltar
				If AllTrim(SE5->E5_PRETPIS) # "2" .OR. AllTrim(SE5->E5_PRETCOF) # "2" .AND. AllTrim(SE5->E5_PRETCSL) # "2"
					SE5->(dbSkip())
					Loop								
				Endif              
				//Se o movimento esta cancelado, saltar (usar IsBxCanc e nao o TemBxCanc)
				If IsBxCanc({SE5->E5_FILIAL,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_SEQ},.F.)
					SE5->(dbSkip())
					Loop
				Endif
				lMovEnc	:= .T.
				If AllTrim(SFQ->FQ_SEQDES) # AllTrim(SE5->E5_SEQ)
					If !Empty(SE5->E5_SEQ)
						RecLock("SFQ",.F.)
						SFQ->FQ_SEQDES := SE5->E5_SEQ
						MsUnlock()
						lAltera := .T.
					Else 
						If Len(AllTrim(SFQ->FQ_SEQDES)) # nTamSeq
							RecLock("SFQ",.F.)
							SFQ->FQ_SEQDES := PadL(AllTrim(SFQ->FQ_SEQDES),nTamSeq,"0")
							MsUnlock()
							lAltera := .T.
						Endif
					Endif
				Endif
				If lAltera
					nTotAj++
					If lGLOG
						WriteLOG("PARCELA DE DESTINO - ENTIDADE (" + AllTrim(SFQ->FQ_ENTDES) + ")")
						WriteLOG(" ")
						MontaLOG(cCabecLOG,aCabecLOG,{SFQ->FQ_FILDES,SFQ->FQ_PREFDES,SFQ->FQ_NUMDES,SFQ->FQ_PARCDES,SFQ->FQ_TIPODES,SE5->E5_TIPODOC,SFQ->FQ_CFDES,SFQ->FQ_LOJADES,;
							aSeqOr[2],SE5->E5_SEQ,SFQ->FQ_SEQDES,SFQ->(Recno())},.T.,"|")		
					Endif
				Endif
				Exit
			EndDo
		Endif
		If !lMovEnc
			If !Empty(SFQ->FQ_SEQDES) .AND. Len(AllTrim(SFQ->FQ_SEQDES)) < nTamSeq
				RecLock("SFQ",.F.)
				SFQ->FQ_SEQDES := PadL(AllTrim(SFQ->FQ_SEQDES),nTamSeq,"0")
				MsUnlock()
				nTotAj++
			Endif
			If lGLOG
				WriteLOG("PARCELA DE DESTINO - ENTIDADE (" + AllTrim(SFQ->FQ_ENTDES) + ")")
				WriteLOG(" ")
				WriteLOG(cMens)
				WriteLOG(" ")				
				MontaLOG(cCabecLOG,aCabecLOG,{SFQ->FQ_FILDES,SFQ->FQ_PREFDES,SFQ->FQ_NUMDES,SFQ->FQ_PARCDES,SFQ->FQ_TIPODES,"",SFQ->FQ_CFDES,SFQ->FQ_LOJADES,;
					aSeqOr[2],"",SFQ->FQ_SEQDES,SFQ->(Recno())},.T.,"|")		
			Endif				
		Endif		
	Endif
	SFQ->(dbSkip())
EndDo
RestArea(aArea)
WriteLOG(Replicate("-",150))
WriteLOG("FIM DO AJUSTE DO SFQ")                                               
WriteLOG(Space(10) + "- TOTAL DE REGISTROS PROCESSADOS : " + cValToChar(nTotREG))
WriteLOG(Space(10) + "- TOTAL DE REGISTROS AJUSTADOS : " + cValToChar(nTotAj))
For ni := 1 to 10
	WriteLOG(" ")
Next ni

Return lRet 
