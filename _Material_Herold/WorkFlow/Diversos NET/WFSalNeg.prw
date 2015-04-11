#INCLUDE "PROTHEUS.CH"
//----------------------------------------------------------------------------------------------------------------// 
// Apos uma transacao, caso o saldo fique negativo, envia um WorkFlow para o aprovador.
// Ele pode aprovar ou nao esta transacao. A resposta (SIM ou NAO), sera gravada no campo Z2_APROV.
//----------------------------------------------------------------------------------------------------------------// 
User Function WFSalNeg(cNome, cEMail, cNumero, cItem, dData, cHist, nValor, nSaldo)

Local   oWF  
Default cNome  := "Herold"
Default cEMail := "herold.leite@totvs.com.br"
Default cNumero:= "001010"
Default cItem  := "0001"
Default dData  := ctod("07/01/13")
Default cHist  := "Teste de workflow"
Default nValor := 200
Default nSaldo := 0     

	If select("SX6")==0
 		RpcClearEnv() //LIMPA O AMBIENTE
		RpcSetType( 3 ) //Nao utiliza licenca
		RpcSetEnv("99","01",,,"FAT",,{"SA2","SA3"})
	Endif


// Inicializa a classe TWFProcess (WorkFlow).
oWF := TWFProcess():New( "APROVA", "Aprovação do Lançamento" )

// Cria uma nova tarefa para o processo.
oWF:NewTask( "Aprovacao", "\workflow\190_WFSalNeg.htm" )

// Preenche as variaveis no html.
oWF:oHtml:ValByName("NOME"  , cNome  )
oWF:oHtml:ValByName("SALDO" , nSaldo )
oWF:oHtml:ValByName("NUMERO", cNumero)
oWF:oHtml:ValByName("ITEM"  , cItem  )
oWF:oHtml:ValByName("DATA"  , dData  )
oWF:oHtml:ValByName("HIST"  , cHist  )
oWF:oHtml:ValByName("VALOR" , nValor )

// Destinatário do WorkFlow. DEVE SER O CAMINHO QUE VAI GRAVAR O HTML
oWF:cTo := "/WORKFLOW/"

// Assunto da mensagem.
//oWF:cSubject := "Aprovação do Lançamento " + cNome
oWF:cSubject := "Desconsiderar esse email " + cNome

// Função a ser executada quando a resposta chegar.
oWF:bReturn  := "U_WFRetorno"

// Função a ser executada quando expirar o tempo do TimeOut.
// Tempos limite de espera das respostas, em dias, horas e minutos.
//oWF:bTimeOut := {{"U_WFTmOut",0,0,10}}

// Gera os arquivos de controle deste processo e envia a mensagem e guarda ID para geracao do arquivo
cNumId := oWF:Start() 

// Destinatário do WorkFlow PARA ENVIAR O LINK

oWF:cTo := cEMail 
_xCaminho := "\workflow\emp"+cEmpant+"\temp\"+cNumID   //caminho que ira gravar o arquivo
cLinkHtml := "http://localhost:9090/emp"+cEmpant+"/temp/"+cNumID+".htm" //link para enviar no email

_cHTML :=  memoread("\workflow\190_WFSalNeg.htm")

 	_xcHTMLH:= ' <input type=hidden name="WFMAILID" value="WF'+alltrim(cNumID)+'">'  
	_xcHTMLH+= ' <input type=hidden name="WFRECNOTIMEOUT" value="{}">'
	_xcHTMLH+= ' <input type=hidden name="WFEMPRESA" value="'+cEmpAnt+'">' 
	_xcHTMLH+= ' <input type=hidden name="WFFILIAL" value="'+cFilAnt+'">' 

	//SALVA O HTML QUE VAI NO LINK 
	_xcHTML := strtran(_cHTML, "|WFQTH|", _xcHTMLH)
	
	//abastece variaveis e acordo com o objeto gerado 
	aADCont:= oWF:OHTML:ALISTVALUES[1]
	For h:=1 to Len(aADCont) 
		cCpo  := aADCont[H][1]   
		cCont := aADCont[H][2]   
		IF TYPE("cCont")=='D'
			cCont := DTOC(cCont)
		ElseIf TYPE("cCont")=='N'
			cCont := cValToChar(cCont)  
		Endif
		If cCont <> Nil
			_xcHTML := strtran(_xcHTML,'!'+cCpo+'!', cCont)	
		Endif
		_xcHTML := strtran(_xcHTML,'%'+cCpo+'%', cCpo)	

	Next

	//gera o html para ser acessado via link
	WFSaveFile(_xCaminho+".htm", _xcHTML ) 

  	oWf:NewTask("WFAPROVAD","\workflow\wflink.htm")	//Gera os arquivos de controle deste processo e envia a mensagem. HTML COM O LINK

	// Preenche as variaveis no html.
	oWF:oHtml:ValByName("USUARIO"  , cNome  )
	oWF:oHtml:ValByName("PROC_LINK" , cLinkHtml )

	oWF:cTo  := cEmail  

	oWF:start()


MsgAlert("SALDO NEGATIVO: Enviado WorkFlow para o Aprovador.")

Return

//----------------------------------------------------------------------------------------------------------------// 
User Function WFRetorno(oWF)

Local cNumero
Local cItem
Local cAprova      


nSaldo:=	oWF:oHtml:RetByName("SALDO" )
dData :=	oWF:oHtml:RetByName("DATA"  )
cHist :=	oWF:oHtml:RetByName("HIST"  )
nValor :=	oWF:oHtml:RetByName("VALOR" )
cNome   := oWF:oHtml:RetByName("NOME")         // Obtem o Nr.da Transacao.
cNumero := oWF:oHtml:RetByName("NUMERO")         // Obtem o Nr.da Transacao.
cItem   := oWF:oHtml:RetByName("ITEM")           // Obtem o Nr.do Item.
cAprova := oWF:oHtml:RetByName("APROVA")         // Obtem a resposta do Aprovador.
cObserv := oWF:oHtml:RetByName("OBSERV")         // Obtem a resposta do Aprovador.

dbSelectArea("SZ1")
dbOrderNickName("NOME")
dbSeek(xFilial("SZ1") + cNome)

dbSelectArea("SZ2")                              // Seleciona o arquivo de Transacoes.
dbOrderNickName("NR_IT")                         // Seleciona a chave primaria.
if dbSeek(xFilial() + cNumero + cItem)              // Procura a transacao.
	RecLock("SZ2")                                   // Bloqueia o registro.
	SZ2->Z2_Aprov := cAprova                         // Grava a resposta do Aprovador.
	MSUnlock()                                       // Desbloqueia o registro.
	conout("gravou cAprova " + cAprova)        
	oWF:cSubject := "Aprovacao Respondida"
Else
	conout("nao encontrou " + cNumero + cItem)
	oWF:cSubject := "Aprovacao Não Encontrada"
Endif

// Finaliza o processo.
	oWF:NewTask( "Aprovacao", "\workflow\191_WFSalNeg.htm" )
	oWF:oHtml:ValByName("NOME"  , cNome  )
	oWF:oHtml:ValByName("SALDO" , nSaldo )
	oWF:oHtml:ValByName("NUMERO", cNumero)
	oWF:oHtml:ValByName("ITEM"  , cItem  )
	oWF:oHtml:ValByName("DATA"  , dData  )
	oWF:oHtml:ValByName("HIST"  , cHist  )
	oWF:oHtml:ValByName("VALOR" , nValor )
	oWF:oHtml:ValByName("APROVA" , cAprova )
	oWF:oHtml:ValByName("OBSERV" , cObserv)
	oWF:cTo := "Herold.leite@totvs.com.br"
	OWF:start()
	oWF:Finish()

Return( NIL )

//----------------------------------------------------------------------------------------------------------------// 

User Function WFTmOut(oWFTM)

// Faz um reenvio da mensagem... Neste instante, é possivel mudar o
// endereço do destinatário.
oWFTM:cSubject += " encerrado por falta de feedback" 

// Reenvia a mensagem.
oWFTM:start()
oWFTM:finish()

Return      


