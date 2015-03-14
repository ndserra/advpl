#INCLUDE "PROTHEUS.CH"   
#INCLUDE "LJTC505.CH"

#DEFINE SEPARADOR "|"                          // utilizado com delimitador na gera็ใo do arquivo

User Function LJTC505()                        // "dummy" function - Internal Use
	Local oArqTC505 := Nil                     // objeto da Classe LJCGeraArqTC505
	oArqTC505 := LJCGeraArqTC505():New()  
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบClasse    ณLJCGeraArqTC505  บAutor  ณVendas Clientes     บ Data ณ  23/06/08   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณClasse responsavel em gerar arquivo de produtos                    บฑฑ
ฑฑบ          ณsera lido pelo Terminal de Consulta TC505 da GERTEC       	     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSigaLoja                                                  		 บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Class LJCGeraArqTC505     

	Data oArquivo                                              //Objeto para manupulacao de dados
	Data cPath                                                 //Caminho para o arquivo
	Data cNomeArq                                              //Nome do arquivo
	Data cArquivo                                              //Nome do arquivo + Path
	Data lRetorno                                              //Passa retorno dos metodos
    Data aProdutos                                             //Array onde serแ armazenado Codigo, Descri็ใo e Pre็o
	
	Method New()                                               //Construtor da Classe
	Method Executar()                                          //Method que Executa os Metodos outros Metodos da Classe e Verifica os Retornos
	Method PegaPath()                                          //Metodo responsavel em pegar path do arquivo informado pelo usuario
	Method RenCriar()                                          //Metodo que renomeia e cria um arquivo novo
	Method BuscaProd()                                         //Metodo que busca os produtos 
    Method Escreve()                                           //Metodo que escreve no arquivo
    Method FormatVal()                                         //Metodo que formata o pre็o dos produtos

EndClass

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบMetodo    ณNew       บAutor  ณVendas Clientes     บ Data ณ  23/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConstrutor da classe LJCGeraArqTC505  		              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSigaLoja                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                              			  บฑฑ
ฑฑบ          ณ                                          			      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Method New() Class LJCGeraArqTC505     
    ::oArquivo:= Nil
	::cPath:= "" 
	::cNomeArq:= ""
	::cArquivo:= ""
	::lRetorno:= .F.      
    ::aProdutos:= {}      
	::Executar() 
Return Self

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบMetodo    ณExecutar  บAutor  ณVendas Clientes     บ Data ณ  23/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta os Metodos da Classe e Verifica os Retornos         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSigaLoja                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                            บฑฑ
ฑฑบ          ณ   			                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Method Executar() Class LJCGeraArqTC505    
	
	Local lRet := .F.								//Controle do processa    

	//nใo tem path ou foi precionado a tecla cancela
	If ::PegaPath() == .F.
	    Return()
	EndIf
	
	::oArquivo:= LJCArquivo():New(::cArquivo)

	//nao conseguiu renomear ou criar o arquivo 	
	If ::RenCriar() == .F.     
	    Alert(STR0001)
	    Return()
	EndIf

    //carrega array aProdutos
    Processa({|| lRet := ::BuscaProd()},"")
    
    //nใo consegui escrever no arquivo
    If !lRet
	    Alert(STR0002)
	    Return()
    EndIf      
      
    //nใo consegui fechar o arquivo
   	If ::oArquivo:Fechar() == .F.         
	    Alert(STR0003)		// "Nใo foi possivel fechar o arquivo"
	    Return()
   	EndIf        
   	                                
   	//apresenta mensagem de Sucesso
   	MsgAlert(STR0004,STR0005)	//"Arquivo Gerado com Sucesso" "Gera็ใo de Arquivo Texto"

Return(Nil) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบMetodo    ณPegaPath  บAutor  ณVendas Clientes     บ Data ณ  23/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta tela e pega o Path do Arquivo informado pelo Usuario  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSigaLoja                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                               			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบRetorno   ณ::lRetorno:= retorno logico do Metodo                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Method PegaPath() Class LJCGeraArqTC505

   Local cMask  := PadR('Texto (*.txt)',27) + '|*.txt|' + PadR('Todos (*.*)',27)+ '|*.*|'     // mascara passada para Fun็ใo cGetFile
   Local oGrupo := Nil                                                                         // objeto grupo box
   Local oGet   := Nil                                                                         // objeto caixa de texto
   Local oDlg   := Nil                                                                         // objeto janela de dialogo
   Local nOpca  := 0                                                                           // indica que botใo foi precionado

   DEFINE MSDIALOG oDlg TITLE STR0006 FROM 323,412 TO 450,800 PIXEL STYLE DS_MODALFRAME STATUS	//"Gera Arquivo"

   oGrupo := TGroup():New(5,2,62,195, STR0007 ,,,,.T.)											// "Arquivo de Pre็o de Produtos"
   
   oGet := TGet():New(14,8, bSETGET(::cArquivo),,150,10,,,,,,,,.T.,,,,,,,.T.,,,)

   SButton():New(14,160,14,{|| ::cArquivo := cGetFile(cMask, STR0008,0,,.F.,GETF_LOCALHARD + GETF_OVERWRITEPROMPT)},)//"Selecione o Arquivo"
 
   DEFINE SBUTTON FROM 45, 70 TYPE 1 ACTION (nOpca:= 1, oDlg:End());
   ENABLE OF oDlg
    
   DEFINE SBUTTON FROM 45, 101 TYPE 2 ACTION (nOpca:= 2, oDlg:End());
   ENABLE OF oDlg
      
   ACTIVATE MSDIALOG oDlg CENTERED                         
   
   If nOpca == 1 .AND. ::cArquivo <> ""
      ::lRetorno:= .T.
   EndIf
	
Return(::lRetorno) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบMetodo    ณRenCriar  บAutor  ณVendas Clientes     บ Data ณ  23/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     |Renomeia o arquivo ******_old.*** e cria um novo            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSigaLoja                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                              			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบRetorno   ณ::lRetorno:= retorno logico do Metodo                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Method RenCriar()Class LJCGeraArqTC505   

	Local nRetorno:= 0                        // recebe o retorno da fun็ใo Remonear do objeto ::oArquivo
	
  	//deleta arquivo anterior se existir xxxxxxxxx_OLD.txt
   	If ::oArquivo:Existe(Stuff(::cArquivo,RAT(".",::cArquivo),1,"_OLD."))
   		nRetorno := FERASE(Stuff(::cArquivo,RAT(".",::cArquivo),1,"_OLD."))
   	EndIf

	If ::oArquivo:Existe(::cArquivo)                     
	    
	    // renomeia o arquivo adicionando "_OLD" no seu fim
	    nRetorno:= ::oArquivo:Renomear(Stuff(::cArquivo,RAT(".",::cArquivo),1,"_OLD."))
	    
		If(nRetorno > -1)
		   ::lRetorno:= ::oArquivo:Criar()	
		Else
		   ::lRetorno:= .F.   
		EndIf
		
	EndIf      
	
Return(::lRetorno) 
          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบMetodo    ณBuscaProd บAutor  ณVendas Clientes     บ Data ณ  23/06/08    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณBusca os Produtos no formato:                                บฑฑ
ฑฑบ          ณ    - Codigo de Barras|Descri็ใo|Pre็o de Venda|             บฑฑ
ฑฑบ          ณCarrega array aProdutos                                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSigaLoja                                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                              			   บฑฑ
ฑฑบ          ณ                                          			       บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Method BuscaProd() Class LJCGeraArqTC505
	
	Local cCodBar    	:= ""                   				// recebe codigo de barras da tabela SLK
	Local cCodBarB1    	:= ""                   				// recebe codigo de barras da tabela SB1->B1_CODBAR
	Local lRetorno		:= .F.									//Retorno do metodo
	Local cDescricao 	:= ""                   				// recebe a descricao do produto da tabela SB1->B1_DESC
	Local nPreco     	:= 0                    				// recebe o preco do produto da tabela SB1->B1_PRV1 
	Local cTabPad		:= AllTrim(SuperGetMv("MV_TABPAD"))		//Tabela de preco padrao    
    Local cCampo 		:= ""									//Campo de preco da padrao do SB0
	Local nPrecoFin    	:= 0                    				//Preco SBO x quantidade SLK
    Local cTexto		:= ""									//String que serแ gravada no arquivo
    Local aBtn			:= {}
    Local nSelected		:= 0
    Local lCenVenda		:= SuperGetMv("MV_LJCNVDA",,.F.)		//Indica se existe integracao com cenario de vendas
    
	cCampo := "B0_PRV" + cTabPad

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1"))
	
	ProcRegua(RecCount())
	
	While !Eof()

		cCodBarB1   := SB1->B1_CODBAR
		cDescricao	:= SB1->B1_DESC
		
		If lCenVenda
			DbSelectArea("DA1")
			DbSetOrder(2)  
			//Posiciona na DA1 para buscar o preco
			If DbSeek(xFilial("DA1") + DA1->DA1_CODPRO + cTabPad )
				
				nPreco := DA1->DA1_PRCVEN			
	            
				dbSelectArea("SLK")
				dbSetOrder(2)	
			    //Posiciona no SLK para buscar todos os codigos de barra do produto
				If dbSeek(xFilial("SLK") + SB1->B1_COD)
					
					While !Eof() .AND. SLK->LK_CODIGO == SB1->B1_COD
						cCodBar		:= SLK->LK_CODBAR
					 	nPrecoFin 	:= SLK->LK_QUANT * nPreco
					 	
	 					cTexto:= ALLTRIM(cCodBar) + SEPARADOR + RTRIM(cDescricao) + SEPARADOR ;
			        	+ ::FormatVal(nPrecoFin) + SEPARADOR
					
						lRetorno := ::oArquivo:Escrever(cTexto)
	 					
	 					SLK->(dbSkip())
					End
					
					//contatena codigo do produto com descricao e preco formado pelo metodo FormatVal()
					cTexto:= ALLTRIM(cCodBarB1) + SEPARADOR + RTRIM(cDescricao) + SEPARADOR ;
			        + ::FormatVal(nPreco) + SEPARADOR
					
					lRetorno:= ::oArquivo:Escrever(cTexto)
					
				Else
					cTexto:= ALLTRIM(cCodBarB1) + SEPARADOR + RTRIM(cDescricao) + SEPARADOR ;
			        + ::FormatVal(nPreco) + SEPARADOR
					
					lRetorno:= ::oArquivo:Escrever(cTexto)
				EndIf 
	
				//"Caso nao consiga gravar o txt pergunta se deve continuar
				If !lRetorno .AND. nSelected <> 2
					//# "Sim" # "Sim para Todos" #"Cancelar"
					aBtn := {STR0010,STR0011,STR0012}
					//"Nใo foi possivel Incluir o produto : " # "Deseja continuar mesmo assim ? "
					nSelected := Aviso(STR0013,STR0014+cDescricao+CHR(13)+CHR(10)+STR0015,aBtn,2)
					If nSelected == 3 .OR. nSelected == 0
						Exit
				    EndIf
				EndIf
			EndIf
		Else
			dbSelectArea("SB0")
			dbSetOrder(1)	
			//Posiciona no SBO para buscar o preco
			If dbSeek(xFilial("SB0") + SB1->B1_COD)
				
				nPreco := SB0->(&cCampo)			
	            
				dbSelectArea("SLK")
				dbSetOrder(2)	
			    //Posiciona no SLK para buscar todos os codigos de barra do produto
				If dbSeek(xFilial("SLK") + SB1->B1_COD)
					
					While !Eof() .AND. SLK->LK_CODIGO == SB1->B1_COD
						cCodBar		:= SLK->LK_CODBAR
					 	nPrecoFin 	:= SLK->LK_QUANT * nPreco
					 	
	 					cTexto:= ALLTRIM(cCodBar) + SEPARADOR + RTRIM(cDescricao) + SEPARADOR ;
			        	+ ::FormatVal(nPrecoFin) + SEPARADOR
					
						lRetorno := ::oArquivo:Escrever(cTexto)
	 					
	 					SLK->(dbSkip())
					End
					
					//contatena codigo do produto com descricao e preco formado pelo metodo FormatVal()
					cTexto:= ALLTRIM(cCodBarB1) + SEPARADOR + RTRIM(cDescricao) + SEPARADOR ;
			        + ::FormatVal(nPreco) + SEPARADOR
					
					lRetorno:= ::oArquivo:Escrever(cTexto)
					
				Else
					cTexto:= ALLTRIM(cCodBarB1) + SEPARADOR + RTRIM(cDescricao) + SEPARADOR ;
			        + ::FormatVal(nPreco) + SEPARADOR
					
					lRetorno:= ::oArquivo:Escrever(cTexto)
				EndIf 
	
				//"Caso nao consiga gravar o txt pergunta se deve continuar
				If !lRetorno .AND. nSelected <> 2
					//# "Sim" # "Sim para Todos" #"Cancelar"
					aBtn := {STR0010,STR0011,STR0012}
					//"Nใo foi possivel Incluir o produto : " # "Deseja continuar mesmo assim ? "
					nSelected := Aviso(STR0013,STR0014+cDescricao+CHR(13)+CHR(10)+STR0015,aBtn,2)
					If nSelected == 3 .OR. nSelected == 0
						Exit
				    EndIf
				EndIf
			EndIf
		EndIf
		
		IncProc(STR0009)		// "Aguarde, Gerando arquivo de pre็o GERTEC..."
		
		dbSelectArea("SB1")
		dbSkip()
		
	End 
	
Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบMetodo    ณEscreve   บAutor  ณVendas Clientes     บ Data ณ  23/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAdciona informa็๕es no Arquivo                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSigaLoja                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                               			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบRetorno   ณ::lRetorno:= retorno logico do Metodo                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Method Escreve() Class LJCGeraArqTC505

	Local cTexto := ""                       // linha de informacao que serแ gravada no arquivo
	Local nCont  := 0                        // variavel auxiliar utilizada no For                       	

	ProcRegua(Len(::aProdutos))    

	For nCont:= 1 To Len(::aProdutos)
		
		IncProc( STR0009 )					// "Aguarde, Gerando arquivo de pre็o GERTEC..."
		
		//contatena codigo do produto com descricao e preco formado pelo metodo FormatVal()
		cTexto:= ::aProdutos[nCont][1] + SEPARADOR + ::aProdutos[nCont][2] + SEPARADOR ;
		         + ::FormatVal(::aProdutos[nCont][3]) + SEPARADOR
		         
	    ::lRetorno:= ::oArquivo:Escrever(cTexto)
	Next	    
	
Return(::lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบMetodo    ณFormatVal บAutor  ณVendas Clientes     บ Data ณ  23/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     |Formata o preco com 2 casas decimais  		              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณSigaLoja                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnPreco:= preco nใo formatado                     			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบRetorno   ณxRetorno:= Retorna um caracter como valor com 2 casas       บฑฑ
ฑฑบ          ณ           decimais                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Method FormatVal(nPreco) Class LJCGeraArqTC505  

	Local xRetorno:= 0                       // o retorno do metodo que recebe um numero e retorno um caracter
	
	// Parametro "@E" transforma em moeda nao sendo necessario a multiplicacao por 100
	// para formatacao dos valores          	
	xRetorno:= Transform(nPreco, "@E 9999999999.99")		
	
Return(ALLTRIM(CVALTOCHAR(xRetorno)))
\
