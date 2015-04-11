#INCLUDE "PROTHEUS.CH"
//----------------------------------------------------------------------------------------------------------------// 
// Exemplo de estrutua de envio de WorkFlow
//----------------------------------------------------------------------------------------------------------------// 
User Function WFXXX1()

Local   oWF  
Local cNumero,cLoja,cNome
Local cEMail   := "Herold.leite@totvs.com.br"
Local cContato := "Herold"

Default cNumero := "000001"
Default cLoja   := "01"
Default cNome   := "NOME DO CLIENTE"

If select("SX6")==0
	RpcClearEnv() //LIMPA O AMBIENTE
	RpcSetType( 3 ) //Nao utiliza licenca
	RpcSetEnv("99","01",,,"FAT",,{"SA2","SA3"})
Endif

// Inicializa a classe TWFProcess (WorkFlow).

oWF := TWFProcess():New( "APROVA", "Aprovação de cadastro" )

// Cria uma nova tarefa para o processo.
oWF:NewTask( "Cliente NOVO", "\workflow\WFCLIENTE.html" )

// Preenche as variaveis no html relacionando com variavel do protheus.
oWF:oHtml:ValByName("Usuario"  , "Herold"  )
oWF:oHtml:ValByName("Codigo"   , cNumero)
oWF:oHtml:ValByName("Loja"     , cLoja  )
oWF:oHtml:ValByName("Nome"     , cNome  )

// Destinatário do WorkFlow envio do workflow
oWF:cTo := cEMail

// Assunto da mensagem.
oWF:cSubject := "Teste Envio " + cNome

// Função a ser executada quando a resposta chegar.
oWF:bReturn  := "U_WFCliRet"

// Função a ser executada quando expirar o tempo do TimeOut.
// Tempos limite de espera das respostas, em dias, horas e minutos.
//oWF:bTimeOut := {{"U_WFTmOut",0,0,10}}

// Enviando o Workflow

oWF:Start()

	
Return( NIL )	
//-----------------------------------------------------------------------------------------------------
// Função tem que retornar o nome do objeto
User function WFCliRet(oWF)

Local cNumero
Local cLoja
Local cAprova     
Local cObserv     

// Retorno do html
cNumero := oWF:oHtml:RetByName("Codigo")         // Obtem o Nr.da Transacao.
cLoja   := oWF:oHtml:RetByName("Loja")           // Obtem o Nr.do Item.
cAprova := oWF:oHtml:RetByName("APROVA")         // Obtem a resposta do Aprovador.
cObserv := oWF:oHtml:RetByName("OBSERV")         // Obtem a resposta do Aprovador.
 

conout(APROVA) 
conout(OBSERV)                  

// Finaliza o processo.
oWF:Finish()

Return( NIL )	      

//-----------------------------------------------------------------------------------------------------
