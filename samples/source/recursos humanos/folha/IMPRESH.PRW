#INCLUDE "Protheus.CH"
#INCLUDE "IMPRESH.CH"
#INCLUDE "MSOLE.CH"
#DEFINE   nColMax	2264
#DEFINE   nLinMax  2900
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPRESW   ºAutor  ³Wagner Montenegro            º Data ³  15/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao da Rescisao em modo Grafico Homolognet                     º±±
±±º          ³                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±  
±±³                ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ BOPS/FNC  ³  Motivo da Alteracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|            ³          ³           ³                                            |±±
±±³Mauricio MR ³07/02/2011³002412/2011³Ajuste para forcar a impressao do campo 71  ³±±
±±³Mauricio MR ³16/02/2011³002361/2011³Ajuste no laco de impressao do campo 95 - Ou³±±
±±³            ³          ³           ³tras verbas.								   ³±±
±±³Mauricio MR ³16/02/2011³003385/2011³Ajuste p/ obter adequadamente remuneracao do³±±
±±³            ³          ³           ³mes anterior ao afastamento (campo 23).     ³±±
±±³Kelly Soares³12/04/2011³006161/2011³Alteracoes para impressao de ferias por     ³±±
±±³            ³          ³           ³periodos aquisitivos - homolognet.          ³±±
±±³            ³          ³           ³Horas extras ordenadas por percentual.      ³±±
±±³Kelly Soares³17/05/2011³006161/2011³Ajuste no campo 27-Cod Afastamento para pagi³±±
±±³            ³          ³           ³nar codigo de saque. Quando nao houver codi-³±±
±±³            ³          ³           ³go valido, pagina NAO.                      ³±±
±±³Mauricio MR ³22/06/2011³015039/2011³Ajuste para descontar as verbas de descontos³±±
±±³            ³          ³           ³no saldo de salario qdo solicitado.		   ³±±
±±³Renata Elena³04/07/2011³013875/2011³Ajuste na paginacao da qtd de horas do      ³±±
±±³            ³          ³           ³adicional noturno p\paginar com 2 decimais  ³±±
±±³Mauricio MR ³27/07/2011³016361/2011³Ajuste p/ iniciar a numeracao dos descontos ³±±
±±³            ³          ³           ³denominados "Outros" em '115'.			   ³±±
±±³            ³          ³017899/2011³Ajuste p/ deduzir do saldo de salario dedu- ³±±
±±³            ³          ³           ³coes determinadas na parametrizacao da roti-³±±
±±³            ³          ³           ³na , mesmo que o total de deducoes seja i-  ³±±
±±³            ³          ³           ³gual ao saldo de salario.				   ³±±
±±³            ³          ³           ³Realizados ajustes para considerar a confi- ³±± 
±±³            ³          ³           ³guração do parametro que determina a impres-³±± 
±±³            ³          ³           ³são da data de homologação no campo 154 do  ³±± 
±±³            ³          ³           ³TRCT.                                       ³±± 
±±³Renata Elena³25/08/2011³022030/2011³Ajuste na paginacao do item 66.ferias inde- ³±±
±±³            ³          ³           ³nizadas, mesmo que funcionario nao tenha.   ³±±
±±³Allyson M   ³09/09/2011³021625/2011³Ajuste no desconto de valores no campo 50.  ³±±
±±³            ³          ³           ³Caso o valor desconto ultrapasse o saldo do ³±±
±±³            ³          ³           ³salario, zera o saldo no campo 50 e exibe   ³±±
±±³            ³          ³           ³as verbas em Deducoes com valor descontado. ³±±
±±³Allyson M   ³16/09/2011³024155/2011³Ajuste no desconto de valores no campo 50.  ³±±
±±³            ³          ³           ³Caso as verbas informadas sejam em horas,   ³±±
±±³            ³          ³           ³efetua a conversao em dias, conforme horas/ ³±±
±±³            ³          ³           ³dia do cadastro do funcionario. 			   ³±±
±±³Allyson M   ³06/12/2011³031461/2011³Ajuste na somatoria dos avos das ferias pro-³±±
±±³            ³          ³     TEDGA4³porcionais e indenizadas p/ considerar os   ³±±
±±³            ³          ³           ³das medias, quando nao ha o id de ferias.   ³±±
±±³Allyson M   ³08/12/2011³031755/2011³Ajuste na impressao do campo 66 - Ferias    ³±±
±±³            ³          ³     TEDRWQ³vencidas p/ fazer o controle nos dias venci-³±±
±±³            ³          ³           ³dos e nao proporcionais.      			   ³±±
±±³Allyson M   ³27/12/2011³033415/2011³Ajuste na somatoria dos avos do 13o. propor-³±±
±±³            ³          ³     TEGCPO³cionais p/ considerar os avos das medias    ³±±
±±³            ³          ³           ³quando nao ha o id de 13o.   			   ³±±
±±³Allyson M   ³06/01/2012³000513/2012³Ajustes p/ aumentar o tamanho do fonte uti- ³±±
±±³            ³          ³     TEHQDB³lizado p/ melhor legibilidade.    		   ³±±
±±³Leandro Dr. ³02/02/2012³002790/2012³Inclusao do Termo de Quitacao de Rescisao de³±±
±±³            ³          ³     TELSO6³acordo com Portaria 2.685 do MTE. 		   ³±±
±±³Leandro Dr. ³04/04/2012³           ³Inclusao do Termo de Homologacao de Rescisao³±±
±±³            ³          ³     TETNUX³de acordo com Portaria 2685 do MTE.   	   ³±±
±±³Mauricio MR ³11/04/2012³008451/2012³Ajuste para recuperar o salario anterior ao ³±±
±±|            |          |TETIB0	  |afastamento (campo 23 do TRCT) . 		   ³±±
±±³Leandro Dr. ³20/04/2012³           ³Ajuste para no codigo de afastamento conside³±±
±±³            ³          ³     TEWGER³rar o cadastro do parametro 32.       	   ³±±
±±³Leandro Dr. ³21/05/2012³           ³Ajuste para suprimir item "Formalizacao da  ³±±
±±³            ³          ³     TFAOA6³rescisao" do TRCT.                    	   ³±±
±±³Gustavo M.  ³25/06/2012³           ³Ajuste para adicionar a qtde de dias de av  ³±±
±±³            ³          ³     TFEUHX³previo - campo 69 - Legislacao.         	   ³±±
±±³Allyson M.  ³23/07/2012³           ³Ajustes diversos para adequacao da portaria ³±±
±±³            ³          ³     TFJLCZ³MTE 1.057/2012.   					       ³±±
±±³Allyson M.  ³01/08/2012³           ³Adicao da referencia da tabela SRA no campo ³±±
±±³            ³          ³     TFMTAK³RA_VIEMRAI.   					           ³±±
±±³Luis Artuso ³02/08/2012³019467/2012³Ajuste na impressao do Termo de rescisao do ³±±
±±³            ³          ³     TFMJXN³Grupo 56. Impressao fora de ordem.		   ³±±
±±³Luis Artuso ³08/08/2012³020024/2012³Ajuste na impressao do Termo de rescisao -  ³±±
±±³            ³          ³     TFNKOR³grupo 69, verificacao de dias de aviso pre- ³±±
±±³            ³          ³     	  ³vio.                                        ³±±
±±³Renata Elena³19/10/2012³     TFZJCS³Ajuste para deixar o campo 99 fixo.		   ³±±
±±³            ³          ³     	  ³Ajuste para paginar % nos campos 53 e 54    ³±±
±±³            ³          ³     	  ³(Insalubridade e Periculosidade)            ³±±
±±³Renata Elena³23/10/2012³     TFZJCS³Ajuste na variavel n_x1 para caso retornar  ³±±
±±³            ³          ³     	  ³em branco ou nula, iniciliza-la com zero    ³±±
±±³Allyson M.  ³25/10/2012³           ³Ajustes nos posicionamento dos campos e     ³±±
±±³            ³          ³     TG9241³ajuste no tamanho dos fontes utilizados.    ³±±  
±±³Marcia Moura³06/11/2012³     TFYWEQ³Ajuste na impressao da linha 22- mot afast  ³±±    
±±³Marcia Moura³08/11/2012³     TGCADP³Impressao do campo 27 corretamente          ³±±    
±±³Allyson M.  ³05/12/2012³     TGFVVG³Ajuste no titulo dos campos 56 e 64.		   ³±±    
±±³Marcia Moura³14/11/2012³     TGDANL³O campo 71 estava sem a palavra inden,e ocpo³±±              
±±³            ³          ³     	  ³103 - Av. Previo, sem a qtde dias            ±±
±±³            ³          ³     	  ³Somente o segundo erro ocorreu na minha base ±±
±±³            ³          ³     	  ³e foi corrigido                              ±± 
±±³Marcia Moura³11/12/2012³     TFZHOU³O campo 31 não deve ser preenchido para os  ³±±             
±±³            ³          ³     	  ³funcionarios rurais.                         ±±
±±³            ³          ³     	  ³Conforme Portaria 1057 de 09/07/2012         ±±
±±³            ³          ³     	  ³Anexo VIII. para todos os doctos             ±±   
±±³Gustavo M.  ³07/02/2013³     TGQKMO³Ajuste no layout do TRCT.				   ³±±
±±³Gustavo M.  ³08/03/2013³     TGRMIT³Ajuste para hachurar conforme item 2. da    ³±±
±±³            ³          ³     	  ³Portaria 1057.       					   ³±±  
±±³Allyson M   ³25/03/2013|     TGXVDG|Ajuste na validacao do tempo de empresa p/  ³±±
±±³            ³          |      	  |geracao do termo de homologacao/quitacao.   ³±±
±±³            ³          |           |Ajuste na quebra de pagina, quando ha muitas³±±
±±³            ³       	  |           |verbas rescisorias. 						   ³±±
±±³Luis Artuso ³02/05/2013|     THAOGT|Ajuste na exibicao do campo 31. Exibir o    ³±±
±±³            ³          |      	  |codigo da entidade sindical sem alteracoes  ³±±
±±³            ³          |           |caso haja caracteres especiais.             ³±±
±±³Gustavo M.  ³03/05/2013³     THAMOD³Ajuste para demonstrar corretamente o valor ³±±
±±³            ³          ³     	  ³do campo 50, caso descontado faltas.		   ³±± 
±±³Allyson M   ³06/05/2013|     THBXNT|Ajuste na quebra de pagina, quando ha muitas³±±
±±³            ³          |      	  |verbas rescisorias; o cabecalho da rescisao ³±±
±±³            ³          |      	  |sera gerado novamente, se assim configurado ³±±
±±³            ³          |      	  |na parametrizacao da impressao.			   ³±±
±±³Allyson M   ³24/05/2013|     THHNDU|Impressao do Id 430 no campo 58 (DSR)	   ³±±
±±³Gustavo M   ³06/06/2013|     THH683|Ajuste para nao sobrepor o campo 116.	   ³±±
±±³Gustavo M   ³20/06/2013|     THHHWA|Ajustes na fonte, margem e verbas nao obrig.³±±
±±³			   ³		  |     	  |com valores zerados.						   ³±±
±±³Allyson M   ³24/06/2013|     THCYYD|Ajuste na validacao do tempo trabalhado, p/ ³±±
±±³            ³          ³      	  |geracao do termo de quitacao/homologacao.   ³±±
±±³Fabio G.    ³28/06/2013³		THLAEB³Ajuste p/ identificar em qual campo foi inf.³±±
±±³       	   ³		  ³  		  ³numero do endereco RA_ENDEREC ou RA_NUMENDE.³±±
±±³Gustavo M.  ³04/07/2013³		THKB51³Ajuste na centralizacao e letras maiusculas.³±±
±±³Gustavo M.  ³17/07/2013³		THMVQT³Ajuste campo 115.1 e posicionamento campo 80³±±
±±³Gustavo M.  ³22/07/2013³		THNHKN³Ajuste na geracao das ferias vencidas.	   ³±±
±±³Gustavo M.  ³31/07/2013³		THOEEW³Ajuste na adicao de linha quando existir	   ³±±
±±³			   ³		  ³		      ³codigo de desconto da homolognet.		   ³±±
±±³Fabio G.    ³01/08/2013³		THPJVY³Ajuste no Endereco do Empregador para nao   ³±±
±±³			   ³		  ³		      ³sobrepor informacoes de complemento.		   ³±±
±±³Mariana M   ³22/08/2013|     THRBIM|Ajuste no campo 30 para trazer a descricao  ³±±
±±³            ³          |      	  |da Categoria    							   ³±±
±±³Allyson M   ³27/08/2013|     TGWGPD|Ajuste p/ tratamento do campo M0_CEI no     ³±±
±±³            ³          |      	  |array aInfo.								   ³±±
±±³Gustavo M   ³03/09/2013|     THRGKW|Ajuste para seguir layout em relacao a qtde ³±±
±±³            ³          |      	  |de linhas.								   ³±±
±±³Gustavo M   ³10/09/2013|     THUH43|Ajuste na posicao dos totais dos descontos. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/              
User Function IMPRESH()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis PRIVATE utilizadas para Impressao Grafica³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nPos		:= 0				//LINHA DE IMPRESSAO DO RELATORIO GRAFICO
Private nTot		:= 0
Private nNumMax		:= 18			//Numero maximo de verbas impressas no Detalhe da rescisao 
Private nImprime	:= 1 				//Variavel Auxiliar 
Private nImpre		:= 1 
Private CONTFL		:= 1				//CONTA PAGINA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Objetos para Impressao Grafica - Declaracao das Fontes Utilizadas.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oFont08, oFont09, oFont09n, oFont10, oFont13n

oFont08	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.,)
oFont08n:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.,)
oFont09	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
oFont09n:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)    //Negrito//
oFont10	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.) 
oFont12n:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)		//Negrito//
oFont13n:= TFont():New("Arial",17,17,,.T.,,,,.T.,.F.)    //Negrito// 


nEpoca:= SET(5,1910)
//-- MUDAR ANO PARA 4 DIGITOS 
SET CENTURY ON 

fHomolog()

Set(5,nEpoca)
If nTdata > 8
	SET CENTURY ON
Else
	SET CENTURY OFF
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fHomolog³ Autor ³ Wagner Montenegro       ³ Data ³ 15.12.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Formulario Homolonet                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RdMake                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fHomolog()

Local aString	:= {} 
Local aAreaRCE	:= {} 
Local nBloco1	:=360
Local nX
Local aAreaSRD
Local aAreaSRV
Local nDescAux	:= 0
Local nDescRes	:= 0
Local nFalta	:= 0
Local nOrderSRD
Local nY,nW
Local nCkHomV:=0
Local n_XX 
Local n_X
Local n_Y
Local n_XX1           
Local n_X1
Local n_X2
Local n_Y1,nFor,nT
Local aPreSelect:={}
Local cPreSelect:=MV_PAR32
Local nAchou:=0
Local cD1:=""
Local cD2:=""
Local aPer	:= {}
Local cOrgao:=""  
Local nCont   
Local nPosFixa := 0
Local cVrbFixa := ""
Local cString      
Local cCompet := GetMv( "MV_FOLMES",,Space(06) ) 
Local cDSRSalV	:= LoadCodDSR(.F.,SRA->RA_FILIAL)    
Local lTemVerba := .F.
Local lHomolog		:= .F.
Local aTab25  := {}
Local nPenunSal := 0.00
Local cItem			:= ''
Local cTpFalta		:= ""
Local lTrabRural	:= .F.
Local cVal69		:= ""
Local nValLin		:= 0 
Local nHomD			:= 0 
Local lTotal  		:= .F.  
Local lTotal2  		:= .F.

Private aCpoForm:={}
Private aCpoFor1:={}
Private aCpoFormD:={}
Private cCateg	:= fCateg(0)
Private cPercSRV:=""
Private aCpoExtra:={}
Private lQuebraD:=.F.
Private lQuebraP:=.F.
Private oBrush1
Private oBrush2		
Private nBoxIni	:=0
Private nCl01a	:=120
Private nCl01b	:=634
Private nCl02a	:=834
Private nCl02b	:=1348
Private nCl03a	:=1548
Private nCl03b	:=2062
Private nL		:=0 
Private nPD 	:=40
Private nPT 	:=05
Private nTamL	:=10
Private nAddL	:=85 
Private nTit	:=60 
Private nSubT	:=42
Private nTip	:=151
Private nXCol 
Private cCodAfa := ""
Private nPagina  := 1 
Private cDescCateg	:= "EMPREGADO"
Static aCodFol:={}  

fp_CodFol( @aCodFol , xFilial("SRV"), .F. ) 

oPrint:StartPage() 			//Inicia uma nova pagina  

Aadd(aCpoForm,{"72",2,"Percentagem","006","",""})
Aadd(aCpoForm,{"73",2,"Prêmios","008","",""})
Aadd(aCpoForm,{"74",2,"Viagens","010","",""})
Aadd(aCpoForm,{"75",2,"Sobreaviso","015","",""})
Aadd(aCpoForm,{"76",2,"Prontidão","016","",""})
Aadd(aCpoForm,{"77",2,"Adicional por tempo de serviço","018","",""})
Aadd(aCpoForm,{"78",2,"Adicional por Transferência de Localidade de Trabalho","019","",""})
Aadd(aCpoForm,{"79",2,"Salário Família excedente ao Valor Legal","020","",""})
Aadd(aCpoForm,{"80",2,"Abono/Gratificação de Férias Excedente 20 dias de salário","021","",""})
Aadd(aCpoForm,{"81",2,"Valor global diárias para viagem Excedente 50% salário","022","",""})
Aadd(aCpoForm,{"82",2,"Ajuda de Custo art. 470/CLT","023","",""})
Aadd(aCpoForm,{"83",2,"Etapas marítimos","024","",""})
Aadd(aCpoForm,{"84",2,"Licença Prêmio indenizada","025","",""})
Aadd(aCpoForm,{"85",2,"Quebra de Caixa","026","",""})
Aadd(aCpoForm,{"86",2,"PLR","027","",""})
Aadd(aCpoForm,{"87",2,"Indenização a Título de Incentivo à demissão","028","",""})
Aadd(aCpoForm,{"88",2,"Bolsa Aprendizagem","029","",""})
Aadd(aCpoForm,{"89",2,"Abonos Desvinculados do Salário","030","",""})
Aadd(aCpoForm,{"90",2,"Ganhos Eventuais Desvinculados do Salário","031","",""})
Aadd(aCpoForm,{"91",2,"Reembolso Creche","032","",""})
Aadd(aCpoForm,{"92",2,"Reembolso Babá","033","",""})
Aadd(aCpoForm,{"93",2,"Gratificação Semestral","034","",""})

Aadd(aCpoFor1,{"96",1,"Indenização art 9º Lei 7238/84","178","",""})
Aadd(aCpoFor1,{"98",2,"Multa art. 476-A & 5º da CLT","036","",""})

Aadd(aCpoFormD,{"115",1,"Outros descontos não previstos acima","","",""})

GPER140Sum(1,,,.T.)
GPER140Sum(2,,,.T.)
For nY:=1 to Len(aCpoForm)
	If Val(Strtran(StrTran(aCpoForm[nY,5],".",""),",","."))>0 
		nCkHomV++
	Endif
Next             
For nY:=1 to Len(aCpoFor1)
	If Val(Strtran(StrTran(aCpoFor1[nY,5],".",""),",","."))>0 
		nCkHomV++
	Endif
Next
For nW:= 1 to Len(aHomV)
	If aHomV[nW,7]==0
	   nCkHomV++
	Endif
Next	   
If nCkHomV>=3
	nTamL:=nTamL+Int(nCkHomV/3)	
Endif                 

fRetTab(@aTab25,"S025",,,,,.T.)

//Imprime o cabecalho da rescisao (Campos 01 a 32)
fCabec()

oPrint:say (nL+nSubT,nCl01a+30,STR0036, oFont09n) //-- "VERBAS RESCISÓRIAS"

nL:=nL+nSubT
nBoxIni:=nL      

// -------------------------------------------------------------------------------------------------------
//  Cabecalho de Verbas Rescisorias
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+02+nSubT,nCl01a+30		,STR0037	, oFont09n) //"RUBRICAS"
oPrint:say (nL+02+nSubT,nCl01b+30		,STR0038	, oFont09n) //"VALOR"
oPrint:say (nL+02+nSubT,nCl02a+30		,STR0037	, oFont09n) //"RUBRICAS"
oPrint:say (nL+02+nSubT,nCl02b+30		,STR0038	, oFont09n) //"VALOR"
oPrint:say (nL+02+nSubT,nCl03a+30		,STR0037	, oFont09n) //"RUBRICAS"
oPrint:say (nL+02+nSubT,nCl03b+30		,STR0038	, oFont09n) //"VALOR" 
nL+=nSubT	
oPrint:line(nL,135,nL,nColMax )

// -------------------------------------------------------------------------------------------------------
//  |50| Saldo de dias trabalhados 
// -------------------------------------------------------------------------------------------------------
n_Y:=0
n_Y1:=0
n_X:= GPER140Sum(1,1,"048/112",,,1)    //Considerar aviso previo trabalhado no mes como saldo de salario
n_X1:=GPER140Sum(1,1,"048/112",,2,1)                     
n_X2:=GPER140Sum(2,1,"113",,2,1)

If n_X1 == Nil .or. empty(n_X1)
	n_X1 := 0
EndIf

If n_X2 == Nil .or. empty(n_X2)
	n_X2 := 0
EndIf

If !(Empty(Alltrim(cPreSelect)))
   	For nFor := 1 To Len( Alltrim(cPreSelect) ) Step 3
		aAdd( aPreSelect , SubStr( cPreSelect , nFor , 3 ) )
	Next nFor
	For nY:= 1 to Len(aPreSelect)
		For nT:= 1 to Len(aHomD)
			If aHomD[nT,4]==aPreSelect[nY]
				//-- Verifica se o tipo de lancamento da verba e' em horas ou em dias
				cTpFalta := PosSrv(aHomD[nT,4],xFilial("SRV", SRA->RA_FILIAL),"RV_TIPO")
				//-- Se Verba e' em horas, converte as horas de falta em dias de acordo com as horas/mes do cadastro do funcionario
				If cTpFalta == "H"
					nFalta := Int(aHomD[nT,2]/Round(SRA->RA_HRSMES/30,2))
					//-- Se a falta for menor do que um dia, nao sera descontada do campo 50
					If nFalta >= 1
						n_Y	+= aHomD[nT,3]
						n_Y1+= nFalta
						aHomD[nT,7]	:= 2
					EndIf
			   	//-- Se Verba e' em Dias, utiliza os valores diretamente
			   	ElseIf cTpFalta == "D"
					n_Y	+= aHomD[nT,3]
					n_Y1+= aHomD[nT,2]
					aHomD[nT,7]	:= 2
			   	EndIf
			Endif
		Next
	Next
Else
   n_Y:=0
   n_Y1:=0
Endif	
n_XX := n_X - n_Y   //Valor
n_XX1:= n_X1 - n_Y1 //Dias
nL+=37
If n_X >= n_Y .and. n_X1 >= n_Y1 
    //-- Retira o valor anteriormente somado ao Provento
    nProv-= n_X
    //-- Recompoe o valor de provento através do valor liquido do saldo de salario
    nProv+= n_XX
    
    //-- Recompoe o valor do desconto, deduzindo as faltas (ou demais verbas correspondentes) utilizadas
    //-- no calculo do saldo de salario liquido
    nDesc-= n_Y
Else
    //-- Retira o valor anteriormente somado ao Provento
    nProv -= n_X
    //-- Recompoe o valor do desconto, deduzindo as faltas (ou demais verbas correspondentes) utilizadas
    //-- no calculo do saldo de salario liquido
    nDesc 		-= n_X
	//-- Guarda o valor maximo do desconto do saldo
    nDescRes 	:= n_X
	//-- Guarda a diferenca entre os descontos e saldo de salario
	nDescAux	:= Abs(n_XX)
	For nY := 1 To Len(aPreSelect)
		For nT := 1 To Len(aHomD)
			If nDescAux > 0 .And. aHomD[nT,4] == aPreSelect[nY]
				//-- Habilita a exibicao da verba em deducoes
				aHomD[nT,7] := 0
				//-- Verifica se ha valor a descontar e se o valor de desconto da verba eh maior ao desconto
				If aHomD[nT,3] >= nDescRes
					//-- Desconta o valor da verba
					aHomD[nT,3] -= nDescRes
					//-- Desconta o valor descontado do total a ser descontado
					nDescAux	-= nDescRes
					//-- Zera o valor a descontar
					nDescRes 	:= 0
				ElseIf nDescRes > 0 
					//-- Guarda o valor que necessita ser descontado
					nDescRes := ( nDescRes - aHomD[nT,3] )
					//-- Zera o valor a descontar 
					aHomD[nT,3] -= aHomD[nT,3]
					//-- Desabilita a exibicao da verba em deducoes
					aHomD[nT,7] := 2
					//-- Desconta o valor descontado do total a ser descontado
					nDescAux	-= nDescRes
				EndIf
			EndIf
		Next nT
	Next nY
EndIf
oPrint:say (nL+nPT+10,nCl01a+30		,STR0039 + If(n_XX1<0,"00",StrZero(n_XX1,2)) + STR0040, oFont08) // 50 Saldo de 00/dias Salario 
oPrint:say (nL+nPD+10,nCl01a+30		,STR0154 + StrZero(n_Y1,2)+STR0041, oFont08)                
oPrint:say (nL+nPD+10,nCl01b+10	,TransForm(n_XX,"@E 99,999,999.99"), oFont10) 

// -------------------------------------------------------------------------------------------------------
//  |51| Comissoes
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT+10,nCl02a+30	,STR0045, oFont08)  //"51 Comissoes"
oPrint:say (nL+nPD+10,nCl02b+10	,GPER140Sum(1,2,"007"), oFont10) 

// -------------------------------------------------------------------------------------------------------
//  |52| Gratificacoes
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT+10,nCl03a+30	,STR0046, oFont08)  //"52 Gratificaçâo"
oPrint:say (nL+nPD+10,nCl03b+10	,GPER140Sum(1,2,"017"), oFont10) 

nL+=nAddL+10
oPrint:line(nL,135,nL,nColMax )

// -------------------------------------------------------------------------------------------------------
//  |53| Insalubridade
// -------------------------------------------------------------------------------------------------------
cPercSRV:="" 
oPrint:say (nL+nPT,nCl01a+30		,STR0047 +  TransForm(GPER140Sum(1,2,"013",,2,1),"@E 999.99")  , oFont08)  //"53 Adicional de Insalubridade"
oPrint:say (nL+nPD,nCl01a+30	,cPercSRV+" %", oFont08) 
oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(1,2,"013"), oFont10) 

// -------------------------------------------------------------------------------------------------------
//  |54| Periculosidade
// -------------------------------------------------------------------------------------------------------
cPercSRV:="" 
oPrint:say (nL+nPT,nCl02a+30	,STR0048 +  TransForm(GPER140Sum(1,2,"014",,2,1),"@E 999.99"), oFont08)  //"54 Adicional de Periculosidade"
oPrint:say (nL+nPD,nCl02a+30	,cPercSRV+" %", oFont08) 
oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(1,2,"014"), oFont10)

// -------------------------------------------------------------------------------------------------------
//  |55| Adicional Noturno
// -------------------------------------------------------------------------------------------------------
cPercSRV:="" 
oPrint:say (nL+nPT,nCl03a+30	,STR0049 + TransForm(GPER140Sum(1,2,"012",,2,1),"@E 999.99") + STR0050, oFont08) // "55 Adicional Noturno XX horas"
oPrint:say (nL+nPD,nCl03a+30	,cPercSRV+" %", oFont08) 
oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(1,2,"012"), oFont10) 
  
nL+=nAddL+05
oPrint:line(nL,135,nL,nColMax )

// -------------------------------------------------------------------------------------------------------
//  |56| Horas Extras
// -------------------------------------------------------------------------------------------------------

aAreaSRV:=GetArea()
SRV->(DbSetOrder(RETORDER("SRV","RV_FILIAL+RV_HOMOLOG+STR(RV_PERC,7,3)+RV_COD")))
SRV->(DbSeek(xFilial("SRV")+"004")) //004 = Cod.Homolognet p/ H.Extra
While !SRV->(EOF()) .and. SRV->RV_HOMOLOG=="004"
	Aadd(aCpoExtra,{"56.",2,SRV->RV_DESC,(SRV->RV_PERC-100),0,0,SRV->RV_COD,""})
	SRV->(DbSkip())
Enddo 
RestArea(aAreaSRV)
aSort(aCpoExtra,,,{|x,y| x[7] < y[7]}) //ordenado por codigo da verba

nCont := 1
For nY := 1 to Len(aCpoExtra)
	If ( nAchou := Ascan(aHomV,{|x| x[4]==aCpoExtra[nY,7]}) ) > 0	.and. aHomV[nAchou,3] > 0
		aCpoExtra[nY,5] += aHomV[nAchou,2]
		aCpoExtra[nY,6] += aHomV[nAchou,3]						
		aHomV[nAchou,7]:=1
	Else
		aCpoExtra[nY,8] := "D" //Deletado
	Endif
Next nY

aSort(aCpoExtra,,, {|x,y| x[8]+Str(x[4])+x[7] < y[8]+Str(y[4])+y[7]})
nXCol := 1
If ( Len(aCpoExtra) = 0 ) .or. ( Len(aCpoExtra) > 0 .and. !Empty(aCpoExtra[1,8]) )
	oPrint:say (nL+nPT,nCl01a+30		,"56.1 " + STR0051 + " 0,00" + STR0050, oFont08) 
	oPrint:say (nL+nPD,nCl01a+30		,"   0,00%"	, oFont08) 
	oPrint:say (nL+nPD,nCl01b+10	,TransForm(0,"@E 99,999,999.99"), oFont10)
	fNewLine()    				
Else
	nCont	:=	1			
	For nY := 1 to Len(aCpoExtra)
		If !Empty(aCpoExtra[nY,8])
			Exit
		Endif
		aCpoExtra[nY,1] += cValToChar(nCont++)
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30+If(nXCol>1,30,0),aCpoExtra[nY,1] + STR0051 + TransForm(aCpoExtra[nY,5],"@E 999.99") + STR0050, oFont08)
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30+If(nXCol>1,80,40),TransForm(aCpoExtra[nY,4],"@E 999.99") + "%", oFont08)
		oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10,TransForm(aCpoExtra[nY,6],"@E 99,999,999.99"), oFont10)
		fNewLine()
	Next nY
Endif
           
// -------------------------------------------------------------------------------------------------------
//  |57| Gorjetas
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30, STR0052, oFont08) 
oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,2,"011"), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |58| DSR
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30, STR0053, oFont08)
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30, STR0054, oFont08)
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"033/430"), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |59| Reflexo do DSR
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0057, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0058, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,GPER140Sum(1, 1,cDSRSalV,/*lCampo*/,/*nRef*/,/*nType*/,.T.), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |60| Multa Art. 477
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0059, oFont08)  
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,2,"009"), oFont10) 
fNewLine()

If Alltrim(GPER140Sum(1,1,"176")) <> "0,00"
	// -------------------------------------------------------------------------------------------------------
	//  |61| Multa Art. 479
	// -------------------------------------------------------------------------------------------------------
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,STR0060, oFont08) 
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"176"), oFont10) 
	fNewLine()
Endif
// -------------------------------------------------------------------------------------------------------
//  |62| Salario Familia
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0055, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"034"), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |63| 13o. Salario Proporcional
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0061, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , If(aScan(aHomV, {|aHomV| aHomV[5] == "114"}) == 0, GPER140Sum(1,1,"251",,2), GPER140Sum(1,1,"114",,2) )+"/12 avos"	, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"114/251"), oFont10) 
fNewLine()
                  
// -------------------------------------------------------------------------------------------------------
//  |64| 13o. Salario Vencido
// -------------------------------------------------------------------------------------------------------
If Len(aTab25) > 0 .and. (nAchou := aScan(aTab25, {|x| x[5] = '64'})) > 0
	cVrbFixa := aTab25[nAchou,6]
	nPosFixa := aScan(aHomV, {|x| x[4] = cVrbFixa})
Endif

If nPosFixa > 0
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0062 + " " + SubStr(aHomV[nPosFixa,9],3,4), oFont08)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , SubStr(aHomV[nPosFixa,9],1,2) + "/12 " + STR0064, oFont08)  
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b" + 30)+10, TransForm(aHomV[nPosFixa,3],"@E 99,999,999.99"), oFont10)  
	aHomV[nPosFixa,7] := 1
Else
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0062, oFont08)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , " __/12 " + STR0064, oFont08)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, TransForm(0,"@E 99,999,999.99"), oFont10)  
Endif
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |65| Ferias Proporcionais
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0065, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , If(aScan(aHomV, {|aHomV| aHomV[5] == "087"}) == 0, GPER140Sum(1,1,"249",,2), GPER140Sum(1,1,"087",,2) )+"/12 " + STR0064, oFont08)  
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"087/249"), oFont10)
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |66| Ferias Vencidas
// -------------------------------------------------------------------------------------------------------
aPer := fPerArquisitivo()
If Len(aPer) = 0 .or. (Len(aPer) == 1 .and. aPer[1,4] < 30)
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , "66 " + STR0066, oFont08) 
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , '  /  /  '+" a "+'  /  /  ', oFont08)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, TransForm(0,"@E 99,999,999.99"), oFont10)  
	fNewLine()
Else
	nCont := 1
	For nY := 1 to Len(aPer)            
		If aPer[nY,4] > 0
			oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , "66." + cValToChar(nCont) + " " + STR0066, oFont08) 
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,DTOC(aPer[nY,1])+" a "+DTOC(aPer[nY,2]), oFont08) 
			If Len(aPer) > 1 .And. DTOS(SRA->RA_DEMISSA) < DTOS(aPer[nY,2]) .And. DTOS(SRA->RA_DEMISSA) > DTOS(aPer[nY,1])
				oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10,GPER140Sum(1,1,"086/248",,,,,DTOS(aPer[nY,1]) + " - " + DTOS(SRA->RA_DEMISSA)), oFont10) 
			Else
				oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10,GPER140Sum(1,1,"086/248",,,,,DTOS(aPer[nY,1]) + " - " + DTOS(aPer[nY,2])), oFont10) 
			Endif	
			fNewLine()
			nCont++
		Endif
	Next nY
Endif

// -------------------------------------------------------------------------------------------------------
//  |67| Ferias em Dobro
// -------------------------------------------------------------------------------------------------------
aPerDobra := {}
If aCodFol[224,1] # Space(3)
	If ( nAchou := Ascan(aHomV,{|x| x[4]==aCodFol[224,1]}) ) > 0
		While nAchou <= Len(aHomV) .and. aHomV[nAchou,4]==aCodFol[224,1]
			cString := aHomV[nAchou,9]
			aAdd(aPerDobra,{STOD(SubStr(cString,1,At("-",cString)-1)),STOD(SubStr(cString,At("-",cString)+2,Len(cString))),aHomV[nAchou,3]})
			aHomV[nAchou,7]:=1
			nAchou++
		Enddo
	Endif
Endif
If aCodFol[925,1] # Space(3)
	If ( nAchou := Ascan(aHomV,{|x| x[4]==aCodFol[925,1]}) ) > 0
		While nAchou <= Len(aHomV) .and. aHomV[nAchou,4]==aCodFol[224,1]
			cString := aHomV[nAchou,9]
			aAdd(aPerDobra,{STOD(SubStr(cString,1,At("-",cString)-1)),STOD(SubStr(cString,At("-",cString)+2,Len(cString))),aHomV[nAchou,3]})
			aHomV[nAchou,7]:=1
			nAchou++
		Enddo
	Endif
Endif

IF Len(aPerDobra) > 0
	aSort(aPerDobra,,,{|x,y| x[1] < y[1]})
	For nY := 1 to Len(aPerDobra)
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , "67." + cValToChar(nY) + " " + STR0063, oFont08) 
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,DTOC(aPerDobra[nY,1])+STR0067+DTOC(aPerDobra[nY,2]), oFont08)
		oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10,TransForm(aPerDobra[nY,3],"@E 99,999,999.99"), oFont10)
		fNewLine()
	Next nY
Endif

// -------------------------------------------------------------------------------------------------------
//  |68| 1/3 de Ferias 
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0068, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10	,GPER140Sum(1,1,"125/226/231/926"), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |69| Aviso Previo Indenizado
// -------------------------------------------------------------------------------------------------------
cVal69	:= GPER140Sum(1,1,"111/250")
If ( Val(cVal69) > 0 )

	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0069, oFont08)
	oPrint:say(nL+nPT+28,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,If(ValType(nDiasAv)!="U",Space(1)+Str (nDiasAv,5,1)+STR0151,Space(6)+STR0151), oFont08)	

Else

	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0069 , oFont08)

EndIf

oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, cVal69 , oFont10) 

fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |70| 13o. Salario s/ Aviso Previo
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0070, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0071, oFont08) 		
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"115/253"), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |71| Ferias s/ Aviso Previo
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0119, oFont08)
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0071, oFont08) 		
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"230/252"), oFont10) 
fNewLine()
       
// -------------------------------------------------------------------------------------------------------
//  |72| Percentagem - A - |93| Gratificacao Semestral
// -------------------------------------------------------------------------------------------------------
For nY := 1 to Len(aCpoForm)
   	If Val(Strtran(StrTran(aCpoForm[nY,5],".",""),",","."))>0 
		oPrint:line(nL,135,nL,nColMax )
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,aCpoForm[nY,1]+" "+Substr(aCpoForm[nY,3],1,31), oFont08) 
		If Len(aCpoForm[nY,3])>31
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,Substr(aCpoForm[nY,3],32,34), oFont08) 
		Endif
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,aCpoForm[nY,5], oFont10) 
		fNewLine()
	Endif
Next
		
// -------------------------------------------------------------------------------------------------------
//  |94| Salario do mes anterior a rescisao
// -------------------------------------------------------------------------------------------------------
nPosFixa := 0
If Len(aTab25) > 0 .and. (nAchou := aScan(aTab25, {|x| x[5] = '94'})) > 0
	cVrbFixa := aTab25[nAchou,6]
	nPosFixa := aScan(aHomV, {|x| x[4] = cVrbFixa})
Endif

If nPosFixa > 0
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0120, oFont08) 
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, TransForm(aHomV[nPosFixa,3],"@E 99,999,999.99"), oFont10) 
	aHomV[nPosFixa,7] := 1
	fNewLine()
Endif

// -------------------------------------------------------------------------------------------------------
//  |95| Outros
// -------------------------------------------------------------------------------------------------------
nCont := 1
For nY:= 1 to Len(aHomV)
	If aHomV[nY,7]==0
		oPrint:line(nL,135,nL,nColMax )
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,"95."+AllTrim(Str(nCont))+" "+Capital(Substr(aHomV[nY,1],1,33)), oFont08) 
		If Len(aHomV[nY,1])>33
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,Substr(aHomV[nY,1],34,33), oFont08) 
		Endif
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,TransForm(aHomV[nY,3],"@E 99,999,999.99"), oFont10) 
		nCont++
		fNewLine()
	Endif
Next  
        
// -------------------------------------------------------------------------------------------------------
//  |96| Indenização art. 9º, Lei nº 7.238/1984 - A - |98| Multa art. 476-A & 5º da CLT"
// -------------------------------------------------------------------------------------------------------
For nY := 1 to Len(aCpoFor1)
	If Val(Strtran(StrTran(aCpoFor1[nY,5],".",""),",","."))>0 
		oPrint:line(nL,135,nL,nColMax )
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,aCpoFor1[nY,1]+" "+Substr(aCpoFor1[nY,3],1,33), oFont08) 
		If Len(aCpoFor1[nY,3])>33
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,aCpoFor1[nY,1]+" "+Substr(aCpoFor1[nY,3],34,33), oFont08) 
		Endif
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,aCpoFor1[nY,5], oFont10) 
		fNewLine()
	Endif
Next

IF nL <= 2500
	While nL <= 2500
   		fNewLine()
	Enddo
Endif

nxCol:= 2
// -------------------------------------------------------------------------------------------------------
//  |99| Ajuste do Saldo Devedor
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0153, oFont08) 
oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"045"), oFont10) 

fNewLine()
 
oPrint:FillRect( {nL+05, nCl03a+02, nL+nAddL+05, nColMax}, oBrush1 )  

oPrint:say (nL+nPT+20,nCl03a+30,STR0072, oFont08n) //"TOTAL BRUTO" 
oPrint:say (nL+nPD,nCl03b-10,Transform(nProv,"@E 999,999,999.99"), oFont10)

nL+=nAddL+05

//Fecha o box e cria as linhas verticais
oPrint:Box( nBoxIni, 135 ,nL,nColMax )
oPrint:line(nBoxIni,nCl01b+20,nL,nCl01b+20 )
oPrint:line(nBoxIni,nCl02a,nL,nCl02a )
oPrint:line(nBoxIni,nCl02b+20,nL,nCl02b+20 )
oPrint:line(nBoxIni,nCl03a,nL,nCl03a )
oPrint:line(nBoxIni,nCl03b+20,nL,nCl03b+20 )

nTamL:=5

fVerQuebra(2, .F.)

oPrint:Box(nL, 135,nL+nSubT, nColMax ) 									
oPrint:say (nL+05,nCl01a+30,STR0073, oFont09n)	//"DEDUÇÕES"
nL+=nSubT

fVerQuebra(2, .F.)

nCkHomV:=0
For nY:=1 to Len(aCpoFormD)
	If Val(Strtran(StrTran(aCpoFormD[nY,5],".",""),",","."))>0 
		nCkHomV++
	Endif
Next		
nBoxIni:=nL	
For nX:=1 to nTamL
	If nX==1
		oPrint:say (nL+02,nCl01a+30   ,STR0074, oFont09n)	 //"DESCONTO"
		oPrint:say (nL+02,nCl01b+30	,STR0038, oFont09n) 	 //"VALOR"
		oPrint:say (nL+02,nCl02a+30	,STR0074, oFont09n) 	 //"DESCONTO"
		oPrint:say (nL+02,nCl02b+30	,STR0038, oFont09n) 	 //"VALOR"
		oPrint:say (nL+02,nCl03a+30	,STR0074, oFont09n) 	 //"DESCONTO"
		oPrint:say (nL+02,nCl03b+30	,STR0038, oFont09n) 	 //"VALOR"
	Elseif nX==2
		oPrint:say (nL+nPT,nCl01a+30		,STR0075, oFont08)  //"100 Pensão Alimentícia"
		oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(2,3,"172/170/128/058/056"), oFont10) // dentro da rotina os identificadores serao ignorados
		oPrint:say (nL+nPT,nCl02a+30	,STR0076, oFont08)  //"101 Adiantamento Salarial"
		oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(2,2,"A01"), oFont10) 
		oPrint:say (nL+nPT,nCl03a+30	,STR0077, oFont08)  //"102 Adiantamento de 13º Salário"
		oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(2,2,"A02"), oFont10) 
	Elseif nX==3
		oPrint:say (nL+nPT,nCl01a+30		,STR0078+" ", oFont08)  //"103 Aviso-Prévio Indenizado" 
		oPrint:say (nL+nPT+28,nCl01a+30		, StrZero(n_X2,2)+STR0151, oFont08)  //"103 Aviso-Prévio Indenizado"      
		oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(2,1,"113"), oFont10) 
		
	    nValLin:=2
	     
	   	If Alltrim(GPER140Sum(2,2,"A09") ) <> "0,00" 
	   		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a") +30	,STR0079, oFont08)  //"104 Multa Art. 480/CLT"
	   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A09"), oFont10)
	   		nValLin++
	   	ElseIF Alltrim(GPER140Sum(2,2,"A08")) <> "0,00" 
	   		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0080, oFont08)  //"105 Empréstimo em Consignação"
	   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A08"), oFont10)
	   		fDesconto(@nValLin)
		ElseIF Alltrim(GPER140Sum(2,2,"A04")) <> "0,00" 
			oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0081, oFont08)  //"106 Vale-Transporte"
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A04"), oFont10)
		    fDesconto(@nValLin)
	   	ElseIF Alltrim(GPER140Sum(2,2,"A06")) <> "0,00" 
	   		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0082, oFont08)  //"107 Reembolso do Vale-Transporte"
	   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A06"), oFont10)
	   		fDesconto(@nValLin)
	   	ElseIF Alltrim(GPER140Sum(2,2,"A05")) <> "0,00" 
	   		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0083, oFont08)  //"108 Vale-Alimentação"
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A05"), oFont10)
		    fDesconto(@nValLin)
	   	ElseIF Alltrim(GPER140Sum(2,2,"A07")) <> "0,00" 	 
			oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30  		,STR0084, oFont08)  //"109 Reembolso Vale-Alimentação"
	   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A07"), oFont10)
	   		fDesconto(@nValLin)
		ElseIF Alltrim(GPER140Sum(2,2,"A11")) <> "0,00" 
			oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0085, oFont08)  //"110 Contibuição para o FAPI"
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A11"), oFont10)
			fDesconto(@nValLin)
		ElseIF Alltrim(GPER140Sum(2,2,"A13")) <> "0,00" 
			oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0086, oFont08)  //"111 Contribuição Sindical Laboral"
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A13"), oFont10)
			fDesconto(@nValLin)
		Endif
		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30  	,STR0087, oFont08)  //"112.1 Previdência Social"
   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,1,"064/065"), oFont10)
   		fDesconto(@nValLin)
   		
  		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0088, oFont08)  //"112.2 Previdência Social 13º Salario"
   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,1,"070"), oFont10)
   		fDesconto(@nValLin)
	   		 
        IF Alltrim(GPER140Sum(2,2,"A10")) <> "0,00" 
        	oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0089, oFont08)  //"113 Contribuição Previdência "
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0090, oFont08)  //"Complementar"
	   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A10"), oFont10)
	   		fDesconto(@nValLin)
	   	Endif  
	   	
   		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30  	,STR0091, oFont08)  //"114.1 IRRF"
		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,1,"066/067"), oFont10)
		fDesconto(@nValLin)
     
		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0092, oFont08)  //"114.2 IRRF sobre 13º Salário"
		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,1,"071"), oFont10)
		fDesconto(@nValLin)
			
		IF Alltrim(GPER140Sum(2,1,"152")) <> "0,00" 
			oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0093, oFont08)  //"114.3 IRRF sobre Participação nos "
		  	oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0094, oFont08)  //"Lucros ou Resultados"
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,1,"152"), oFont10)
			nValLin++
		  	fDesconto(@nValLin)
		Endif
	Elseif nX=4 
   		For nY:= 1 to Len(aHomD)
			If aHomD[nY,7]==0
			   nCkHomV++
			Endif
		Next
		If nCkHomV>=4
			nTamL:=nTamL+Int((nCkHomV-4)/3)	
		Endif  
			
		If nCkHomV<4
			nW:=nValLin-1
			For nY := 1 to Len(aCpoFormD)
				If Val(Strtran(StrTran(aCpoFormD[nY,5],".",""),",","."))>0 
					nW++
					If nW==1
						oPrint:say (nL+nPT,nCl01a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08) 
						If Len(aCpoFormD[nY,3])>33
							oPrint:say (nL+nPD,nCl01a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl01b+10,aCpoFormD[nY,5], oFont10) 
					Elseif nW==2
						oPrint:say (nL+nPT,nCl02a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08) 
						If Len(aCpoFormD[nY,3])>33
							oPrint:say (nL+nPD,nCl02a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl02b+10,aCpoFormD[nY,5], oFont10) 
					Elseif nW==3
						nW:=0
						oPrint:say (nL+nPT,nCl03a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08) 
						If Len(aCpoFormD[nY,3])>33
							oPrint:say (nL+nPD,nCl03a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl03b+10,aCpoFormD[nY,5], oFont10) 
						nL+=nAddL+10
						oPrint:line(nL,135,nL,nColMax )	
						fVerQuebra(2)
					Endif
				Endif
			Next
			nT:=0	
			For nY:= 1 to Len(aHomD)
				If aHomD[nY,7]==0
					nW++
					nT++
					cItem:= "115."+AllTrim(Str(nT))
					If nW==1
						oPrint:say (nL+nPT,nCl01a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
						If Len(aHomD[nY,1])>33
							oPrint:say (nL+nPD,nCl01a+30,Substr(aHomD[nY,1],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl01b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10) 
					Elseif nW==2
						oPrint:say (nL+nPT,nCl02a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
						If Len(aHomD[nY,1])>33
							oPrint:say (nL+nPD,nCl02a+30,Substr(aHomD[nY,1],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl02b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10) 
					Elseif nW==3
						nW:=0
						oPrint:say (nL+nPT,nCl03a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
						If Len(aHomD[nY,1])>33
							oPrint:say (nL+nPD,nCl03a+30,Substr(aHomD[nY,1],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl03b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10)   
						nL+=nAddL+10
						oPrint:line(nL,135,nL,nColMax )	
						fVerQuebra(2)
					Endif
				Endif
			Next
			If nW ==0 
				oPrint:say (nL+nPT,nCl01a+30,STR0095, oFont08)      //"116 Desc. de Valor Liq. de TRCT-"
				oPrint:say (nL+nPD,nCl01a+30,STR0096, oFont08)      //"Quitado"
				oPrint:say (nL+nPD,nCl01b+10,TransForm(0,"@E 99,999,999.99"), oFont10) 
				If nL < 3131 .And. !lQuebraP .And. !lQuebraD
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )						
				EndIf
			Elseif nW==1
				oPrint:say (nL+nPT,nCl02a+30,STR0095	, oFont08) //"116 Desc. de Valor Liq. de TRCT-"
				oPrint:say (nL+nPD,nCl02a+30,STR0096	, oFont08) //"Quitado"
				oPrint:say (nL+nPD,nCl02b+10,TransForm(0,"@E 99,999,999.99"), oFont10) 
				If nL < 3131 .And. !lQuebraP .And. !lQuebraD
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )						
				EndIf
			Elseif nW==2 
				If nL < 3131 .And. !lQuebraP .And. !lQuebraD
					oPrint:say (nL+nPT,nCl03a+30,STR0095, oFont08)   //"116 Desc. de Valor Liq. de TRCT-"
					oPrint:say (nL+nPD,nCl03a+30,STR0096, oFont08)   //"Quitado"
					oPrint:say (nL+nPD,nCl03b+10,TransForm(0,"@E 99,999,999.99"), oFont10)  
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )						
				ElseIf nL == 3131
					oPrint:say (nL+nPT+nAddL+05,nCl01a+30,STR0095, oFont08)   //"116 Desc. de Valor Liq. de TRCT-"
					oPrint:say (nL+nPD+nAddL+05,nCl01a+30,STR0096, oFont08)   //"Quitado"
					oPrint:say (nL+nPD+nAddL+05,nCl01b+10,TransForm(0,"@E 99,999,999.99"), oFont10)  
				ElseIf nL == 3221
					oPrint:say (nL+nPT,nCl03a+30,STR0095, oFont08)   //"116 Desc. de Valor Liq. de TRCT-"
					oPrint:say (nL+nPD,nCl03a+30,STR0096, oFont08)   //"Quitado"
					oPrint:say (nL+nPD,nCl03b+10,TransForm(0,"@E 99,999,999.99"), oFont10)  
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )	
					fVerQuebra(2)
				Else
					oPrint:say (nL+nPT+nAddL+05,nCl01a+30,STR0095, oFont08)   //"116 Desc. de Valor Liq. de TRCT-"
					oPrint:say (nL+nPD+nAddL+05,nCl01a+30,STR0096, oFont08)   //"Quitado"
					oPrint:say (nL+nPD+nAddL+05,nCl01b+10,TransForm(0,"@E 99,999,999.99"), oFont10)  
				EndIf
				lTemVerba := .T.
		    	nL+=nAddL+05
				oPrint:line(nL,135,nL,nColMax )	
				fVerQuebra(2)
			Endif
			Exit 
		Else
			Loop
		Endif
	Elseif nX > 4
		nW:=nValLin-1
  		For nY := 1 to Len(aCpoFormD)
			If Val(Strtran(StrTran(aCpoFormD[nY,5],".",""),",","."))>0   		
				nW++
				If nW==1 
					oPrint:say (nL+nPT,nCl01a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08)
					If Len(aCpoFormD[nY,3]) >33
						oPrint:say (nL+nPD,nCl01a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08)
					Endif
					oPrint:say (nL+nPD,nCl01b+10,aCpoFormD[nY,5], oFont10) 
				Elseif nW==2
					oPrint:say (nL+nPT,nCl02a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08) 
					If Len(aCpoFormD[nY,3]) >33
						oPrint:say (nL+nPD,nCl02a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08)
					Endif					
					oPrint:say (nL+nPD,nCl02b+10,aCpoFormD[nY,5], oFont10) 
				Elseif nW==3 
					nW:=0
					oPrint:say (nL+nPT,nCl03a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08) 
					If Len(aCpoFormD[nY,3]) >33
						oPrint:say (nL+nPD,nCl03a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08)
					Endif					
					oPrint:say (nL+nPD,nCl03b+10,aCpoFormD[nY,5], oFont10) 				
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )
					fVerQuebra(2)
				Endif
			Endif
		Next	
	   	nT:=0	      
	         
	   	aEval( aHomD, { |x| nHomD += If ( X[7] == 0 ,1,0) })
		For nY:= 1 to Len(aHomD)
			If aHomD[nY,7]==0
				nW++
				nT++
				cItem:= "115."+AllTrim(Str(nT))
				If nW == 3 
					If (nL > 3100 .And. nL < 3194 .OR. nPagina <> 1) .And. (nHomD - nT) <= 1
				 		lTotal:= .T.
						nW:=1
						nL+=nAddL+05
						oPrint:line(nL,135,nL,nColMax )	
					ElseIf nL >= 3194
						fVerQuebra(2)
					Endif
				Endif
				If nW == 2 .And. nL >= 3194	
					lTotal2:= .T.
				Endif
				If nW==1
					oPrint:say (nL+nPT,nCl01a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
					If Len(aHomD[nY,1])>33
						oPrint:say (nL+nPD,nCl01a+30,cItem+" "+Substr(aHomD[nY,1],34,33), oFont08) 					
					Endif
					oPrint:say (nL+nPD,nCl01b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10) 
				Elseif nW==2
					oPrint:say (nL+nPT,nCl02a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
					If Len(aHomD[nY,1])>33
						oPrint:say (nL+nPD,nCl02a+30,cItem+" "+Substr(aHomD[nY,1],34,33), oFont08) 					
					Endif
					oPrint:say (nL+nPD,nCl02b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10) 
				Elseif nW==3
					nW:=0
					oPrint:say (nL+nPT,nCl03a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
					If Len(aHomD[nY,1])>33
						oPrint:say (nL+nPD,nCl03a+30,cItem+" "+Substr(aHomD[nY,1],34,33), oFont08) 					
					Endif
					oPrint:say (nL+nPD,nCl03b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10)   
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )						
					fVerQuebra(2)
				Endif
			Endif
		Next
		Exit 
	Endif
	If (nX < 4 .And. nValLin == 0) .or. (nX<5 .and. nCkHomV>3 )
		nL+=If(nX==1,(nAddL-42),nAddL+05)
		oPrint:line(nL,135,nL,nColMax )
		fVerQuebra(2)
	Endif
Next

While nL <= 3104 .And. nPagina==1
	nL+=nAddL+05
	oPrint:line(nL,135,nL,nColMax )
EndDo

If (nW < 2 .Or. (nW <= 2 .And. nHomD <> 0)).And. (nL > 3190 .Or. (lTotal .And. nPagina <> 1))
	nL -= nAddL+05
Endif   

If lTotal .And. !lTotal2 .And. nL > 3104
	nL-=(nAddL+05)
Endif

If lTotal2 .And. !lTotal
	nL+=(nAddL+05)
Endif

IF lTemVerba
	oPrint:FillRect( {nL+05-90, nCl03a, nL+nAddL-90, nColMax}, oBrush1 )
	oPrint:say (nL+nPT-70,nCl03a+30,STR0097, oFont08n)   //"TOTAL DEDUÇÕES"
	oPrint:say (nL+nPD-90,nCl03b-10,Transform(nDesc,"@E 999,999,999.99"), oFont10)
	oPrint:FillRect( {nL+5, nCl03a+01, nL+nAddL+05, nColMax}, oBrush1 ) 
	oPrint:say (nL+nPT,nCl02a+30	,"            ", oFont08) 
	oPrint:say (nL+nPD,nCl02b+10	,"            ", oFont08) 
	oPrint:say (nL+nPT+20,nCl03a+30	,STR0099, oFont08n)  //"VALOR LÍQUIDO"
	oPrint:say (nL+nPD,nCl03b-15,Transform(nProv - nDesc,"@E 999,999,999.99"), oFont10)  	
Else
	oPrint:FillRect( {nL+05, nCl03a, nL+nAddL, nColMax}, oBrush1 )
	oPrint:say (nL+nPT+20,nCl03a+30,STR0097, oFont08n)   //"TOTAL DEDUÇÕES"
	oPrint:say (nL+nPD,nCl03b-10,Transform(nDesc,"@E 999,999,999.99"), oFont10)
	nL+=nAddL+05         
	fVerQuebra(2)
	oPrint:FillRect( {nL+5, nCl03a+01, nL+nAddL+05, nColMax}, oBrush1 )
	oPrint:line(nL,135,nL,nColMax )
	oPrint:say (nL+nPT,nCl01a+30,"        "	   , oFont08)
	oPrint:say (nL+nPD,nCl01b+10,"            ", oFont08) 
	oPrint:say (nL+nPT,nCl02a+30,"            ", oFont08) 
	oPrint:say (nL+nPD,nCl02b+10,"            ", oFont08) 
	oPrint:say (nL+nPT+20,nCl03a+30,STR0099, oFont08n)  //"VALOR LÍQUIDO"
	oPrint:say (nL+nPD,nCl03b-10,Transform(nProv - nDesc,"@E 999,999,999.99"), oFont10) 	
Endif	

nL+=nAddL+05 

//Fecha o box e cria as linhas verticais
oPrint:Box( nBoxIni,  135,nL,nColMax )
oPrint:line(nBoxIni,nCl01b+20,nL,nCl01b+20 )
oPrint:line(nBoxIni,nCl02a,nL,nCl02a )
oPrint:line(nBoxIni,nCl02b+20,nL,nCl02b+20 )
oPrint:line(nBoxIni,nCl03a,nL,nCl03a )
oPrint:line(nBoxIni,nCl03b+20,nL,nCl03b+20 )          

oPrint:EndPage()

//Se teve mais de um ano trabalhado deve ser impresso o termo de homologacao (Anexo VII) ao inves do termo de quitacao (Anexo VI)
//Se possuir aviso previo indenizado, deve-se considerar os dias de aviso na validacao do ano trabalhado
lHomolog := ( ( YearSum( SRA->RA_ADMISSA, 1 ) <= SRG->RG_DATADEM ) .Or. ( Val(cVal69) > 0 .And. YearSum( SRA->RA_ADMISSA, 1 ) <= DaySum( SRG->RG_DATADEM, nDiasAv ) ) )

//INICIO DA IMPRESSAO DO TERMO DE QUITACAO/HOMOLOGACAO DE RESCISAO DE CONTRATO DE TRABALHO - ANEXO VI/VII - PORTARIA MTE N. 2.685 - 26/12/2011 - DOU 27/12/2011
oPrint:StartPage() 			//Inicia uma nova pagina
 
nL:=077

If lHomolog   
	oPrint:FillRect( {nL, 135, nL+nTit, nColMax}, oBrush1 )
	oPrint:Box(nL, 135,nL+(nAddL+50)+(nPT*5)+nAddL+(nAddL*9)+(nPT*5)-125+nSubT , nColMax ) 		//-- Box   -155
	oPrint:say (nL+05,278,STR0138, oFont13n) //-- "TERMO DE HOMOLOGAÇÃO DE RESCISÃO DE CONTRATO DE TRABALHO"	
Else   
	oPrint:FillRect( {nL, 135, nL+nTit, nColMax}, oBrush1 )
	oPrint:Box(nL, 135,nL+(nAddL+50)+(nPT*2)+nAddL+(nAddL*8)+(nPT*3)-100+nSubT , nColMax ) 		//-- Box 
	oPrint:say (nL+05,354,STR0121, oFont13n) //-- "TERMO DE QUITAÇÃO DE RESCISÃO DE CONTRATO DE TRABALHO"	
EndIf

oPrint:FillRect( {nL+nTit, 037, nL+nTit+nSubT-05, nColMax+10}, oBrush2 )

nL:=nL+nTit
oPrint:line(nL,135 ,nL,nColMax)

nL+=nSubT

oPrint:FillRect( {nL, 137, nL+nSubT, nColMax}, oBrush1 )
oPrint:line(nL,135 ,nL,nColMax) 			//Linha Horizontal

nL:=nL+nPT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³IDENTIFICACAO DO EMPREGADOR                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:say (nL,160,STR0122, oFont09n) 	//-- "EMPREGADOR"

nL:=nL+nSubT-05

oPrint:line(nL,135 ,nL,nColMax) 										//Linha Horizontal
oPrint:line(nL,535 ,nL+nAddL+10,535 )									//Linha Vertical Meio
oPrint:say (nL+05,155,STR0056, oFont08) 		 						//"01- CNPJ/CEI: 	
oPrint:say (nl+05,550,STR0001, oFont08)								    //"02- Razão Social / Nome:"
oPrint:say (nL+nPD,175 ,SUBSTR(If( Len(aInfo) >= 27 .And. !Empty( aInfo[27] ), aInfo[27], aInfo[8] )+Space(20),1,20), oFont10 ) //"|01- CNPJ: 
oPrint:say (nL+nPD,565 ,aInfo[3], oFont10 )							//"02- Razao Social / Nome:"

oPrint:FillRect( {nL+nAddL+10, 137, nL+nPT+nSubT+nAddL+05, nColMax}, oBrush1 )
oPrint:line(nL+nAddL+10,135 ,nL+nAddL+10,nColMax)						//Linha Horizontal
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³IDENTIFICACAO DO EMPREGADOR                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nL:=nL+nPT
nL:=nL+nAddL+10

oPrint:say (nL,160,STR0123, oFont09n)   			//-- "TRABALHADOR"
oPrint:line(nL+nSubT-05,135 ,nL+nSubT-05,nColMax) 		//Linha Horizontal

nL:=nL+nSubT-05

oPrint:say (nL+nPT,160 ,STR0025, oFont08) 		//"10 PIS/PASEP:" 
oPrint:say (nL+nPT,650 ,STR0023, oFont08)		//"11 NOME:"
oPrint:line(nL+nAddL+10,135 ,nL+nAddL+10,nColMax) 	//Linha Horizontal
oPrint:line(nL,635 ,nL+nAddL+10,635 )			

oPrint:say (nL+nPD,175 ,SRA->RA_PIS,oFont10) //PIS
If SRA->(FieldPos("RA_NOMECMP")) # 0 .And. !Empty(SRA->RA_NOMECMP)
	oPrint:say (nL+nPD,665 ,Subs(SRA->RA_NOMECMP+Space(60),1,60),oFont10) //NOME
Else
	oPrint:say (nL+nPD,665 ,Subs(SRA->RA_NOME+Space(30),1,30),oFont10) //NOME
EndIf	
	
oPrint:say (nL+nAddL+nPT+10,160 ,"17 "+STR0024, oFont08) 	//17 Carteira de Trabalho
oPrint:say (nL+nAddL+nPT+10,650 , STR0012, oFont08)		//18 CPF:"
oPrint:say (nL+nAddL+nPT+10,1045 , STR0027, oFont08)		//19 Nasc.:"
oPrint:say (nL+nAddL+nPT+10,1440, STR0007, oFont08)		//20 Nome da Mae"

oPrint:say (nL+nAddL+nPD+10,175 , SRA->RA_NUMCP+"- "+SRA->RA_SERCP+"/"+SRA->RA_UFCP, oFont10)	//17 CNAE
oPrint:say (nL+nAddL+nPD+10,665 , SRA->RA_CIC, oFont10)											//18 CPF:"
oPrint:say (nL+nAddL+nPD+10,1060 , DtoC(SRA->RA_NASC), oFont10)									//19 Nasc.:"
oPrint:say (nL+nAddL+nPD+10,1455, SUBSTR(SRA->RA_MAE+Space(30),1,40), oFont10)					//20 Nome da Mae"  

nL := nL + nAddL + 10

oPrint:line(nL,635 ,nL+nAddL+10,635 )		//Linha Vertical Meio	
oPrint:line(nL,1030,nL+nAddL+10,1030)		//Linha Vertical Meio	
oPrint:line(nL,1425,nL+nAddL+10,1425)		//Linha Vertical Meio	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DADOS DO CONTRATO	                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nL:=nL+nAddL+10

oPrint:FillRect( {nL, 137, nL+nSubT, nColMax}, oBrush1 )
oPrint:Line(nL,135,nL,nColMax) //Linha Horizontal
oPrint:say (nL+05,160,STR0124, oFont09n) //-- "CONTRATO"
nL:=nL+nSubT
oPrint:Box(nL,135,nL,nColMax) //Linha Horizontal
oPrint:say (nL+nPT,160,STR0019, oFont08) 							//22 Causa do Afastamento
oPrint:say (nL+nPD,175,Left(cCausa,100), oFont10)

oPrint:say (nL+nTip+nPT,160,STR0021	, oFont08) 					//24 Data de Admissao
oPrint:say (nL+nTip+nPD,175,DtoC(SRA->RA_ADMISSA), oFont10) 
oPrint:say (nL+nTip+nPT,650,STR0022, oFont08) 					//25 Data do Aviso Previo
oPrint:say (nL+nTip+nPD,665,DtoC(SRG->RG_DTAVISO), oFont10) 
oPrint:say (nL+nTip+nPT,1045,STR0026, oFont08) 					//26 Data de Afastamento
oPrint:say (nL+nTip+nPD,1060,DtoC(SRG->RG_DATADEM), oFont10) 
oPrint:say (nL+nTip+nPT,1440	,STR0028	, oFont08)	 			//27 Cod. Afast.
oPrint:say (nL+nTip+nPD,1455	,cCodAfa, oFont10) 
oPrint:say (nL+nTip+nPT,1735,STR0136	, oFont08) 					//29 Pensao Alimenticia (FGTS)
oPrint:say (nL+nTip+nPD,1750,Transform(nPerFGTS,"@E 999.99"), oFont10)

nL := nL + nTip + nPT - 05

oPrint:line(nL,135 ,nL,nColMax) 		//Linha Horizontal
oPrint:line(nL,635,nL+nAddL+10,635)		//Linha Vertical Meio	
oPrint:line(nL,1030,nL+nAddL+10,1030)		//Linha Vertical Meio	
oPrint:line(nL,1425,nL+nAddL+10,1425)		//Linha Vertical Meio
oPrint:line(nL,1720,nL+nAddL+10,1720)		//Linha Vertical Meio

nL := nL + nAddL + 10

oPrint:line(nL,135 ,nL,nColMax) 										//Linha Horizontal
          
oPrint:say (nL+nPT,160,STR0031	, oFont08) //30 Categoria do Trabalhador    

/*Categorias funcionarios considerados no TRCT através da portaria 1057/2012 	
01 - Empregado
03 - Trabalhador não vinculado ao RGPS, mas com direito ao FGTS
04 - Empregado - contrato de trab. por prazo determ. (Lei nº 9.601/98)
06 - Empregado Doméstico
07 - Menor Aprendiz (Lei 10.097/2000)*/
     
If SRA->RA_CATEG $ "03/04/06/07"
	If SRA->RA_CATEG == "03"
		cDescCateg := STR0159
	ElseIf SRA->RA_CATEG == "04"
		cDescCateg := STR0160
	ElseIf SRA->RA_CATEG == "06"
		cDescCateg := STR0161
	ElseIf SRA->RA_CATEG == "07"
		cDescCateg := STR0162
	EndIf
EndIf

oPrint:say (nL+nPD,180,cCateg+' - '+cDescCateg, oFont10)


If lHomolog
	cCodSind   := ''
	cNomeSind  := ''
	lTrabRural := ( SRA->RA_VIEMRAI == "20" .Or. SRA->RA_VIEMRAI == "25" )
	
	If !Empty(SRA->RA_SINDICA)
		aAreaRCE := GetArea()
		
		DbSelectArea("RCE")
		If DbSeek(xFilial('RCE',SRA->RA_FILIAL)+SRA->RA_SINDICA)                          
			if !lTrabRural
				If ( ALLTRIM(STR(VAL(RCE->RCE_ENTSIN))) == ALLTRIM(RCE->RCE_ENTSIN) )
					cCodSind  := Transform(RCE->RCE_ENTSIN,"@R 999.999.999.99999-9")
				Else
					cCodSind  := ALLTRIM(RCE->RCE_ENTSIN)					
				EndIf
		    Endif
			cNomeSind := Transform( RCE->RCE_CGC , "@R 99.999.999/9999-99") + " - " + RCE->RCE_DESCRI
		EndIf
		
		RestArea(aAreaRCE)
	EndIf
	
	//Se nao existir entidade representativa da categoria, deve ser usado os dados do MTE
	If !lTrabRural .And. Empty(cCodSind)
		cCodSind  := '999.000.000.00000-3'
		cNomeSind := '37.115.367/0035-00 - Ministério do Trabalho e Emprego - MTE'
	EndIf
	
	nL := nL + nPT
//	oPrint:line(nL,035 ,nL,nColMax) 		//Linha Horizontal

	nL := nL + nAddL + 05	
	oPrint:say (nL+nPT,160,STR0139	, oFont08) //31 Código Sindical                                      
	oPrint:say (nL+nPD,175,cCodSind, oFont10)	
	oPrint:say (nL+nPT,650,STR0140, oFont08)  //32 CNPJ e Nome da Entidade Sindical Laboral
	oPrint:say (nL+nPD,665,cNomeSind, oFont10)

	oPrint:line(nL,135 ,nL,nColMax) 		//Linha Horizontal	
	oPrint:line(nL,635,nL+nAddL+nPT+05,635)		//Linha Vertical Meio
	
EndIf	

nL := nL + (nAddl*2) + nPT

If lHomolog
	oPrint:say (nL+nPT,140		,STR0141, oFont08)  //"Foi prestada, gratuitamente, assistência na rescisão do contrato de trabalho, nos termos do artigo n.º 477, § 1º, da Consolidaçao das Leis do Trabalho "                                                                                                                                                                                                                                                                                                                                                           
	nL += 35	
	oPrint:say (nL+nPT,140		,STR0142 , oFont08)  //"(CLT), sendo comprovado neste ato o efetivo pagamento das verbas rescisórias especificadas no corpo do TRCT, no valor líquido de R$ "
	nL += 35	
	oPrint:say (nL+nPT,140		,STR0157 + Transform(nProv - nDesc,"@E 999,999,999.99") + "," + STR0143, oFont08)  //"o qual, devidamente rubricado pelas partes, é parte integrante do presente Termo de Homologaçao."    
	nL += 35
	
	nL += 35
	oPrint:say (nL+nPT,140		,STR0144, oFont08)  //"As partes assistidas no presente ato de rescisão contratual foram identificadas como legítimas conforme previsto na Instruçao Normativa/SRT"                                                                                                                                                                                                                                                                                                                                                                       
	nL += 35	
	oPrint:say (nL+nPT,140		,STR0145, oFont08)  //"n.º 15/2010."
	                                                                                                      	
	nL += 35
	oPrint:say (nL+nPT,140		,STR0146, oFont08)  //“Fica ressalvado o direito de o trabalhador pleitear judicialmente os direitos informados no campo 155, abaixo."
				       
Else
	oPrint:say (nL+nPT,140		,STR0125, oFont08)  //"Foi realizada a rescisão do contrato de trabalho do trabalhador acima qualificado, nos termos do artigo nº 477 da Consolidação das Leis do Trabalho (CLT). "                                                                                                                                                                                                                                                                                                                                                       
	nL += 35
	oPrint:say (nL+nPT,140		,STR0126, oFont08)  //"A assistência à rescisão prevista no § 1º do art. nº 477 da CLT não é devida, tendo em vista a duração do contrato de trabalho não ser superior a um ano "                                                                                                                                                                                                                                                                                                                                                         
	nL += 35
	oPrint:say (nL+nPT,140		,STR0127, oFont08)  //"de serviço e não existir previsão de assistência à rescisão contratual em Acordo ou Convenção Coletiva de Trabalho da categoria a qual pertence o "                                                                                                                                                                                                                                                                                                                                                                
	nL += 35
	oPrint:say (nL+nPT,140		,STR0128, oFont08)  //"trabalhador."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	
	nL += 35
	oPrint:say (nL+nPT,140		,STR0130 + Space(1)+ " ___/___/______ " + STR0131, oFont08) //"No dia __/__/____  foi realizado, nos termos do art. 23 da Instrução Normativa/SRT nº 15/2010, o efetivo pagamento das verbas rescisórias especificadas" 
	nL += 35
	oPrint:say (nL+nPT,140		,STR0132 + Space(2)+ Transform(nProv - nDesc,"@E 999,999,999.99") + STR0152, oFont08)  //"no corpo do TRCT, no valor líquido de R$ "##//", o qual, devidamente rubricado pelas partes, é parte integrante do presente Termo de Quitação." 
	nL += 35
	oPrint:say (nL+nPT,140		,STR0158, oFont08)
EndIf

nL += 70

oPrint:say (nL+nPT,140		," __________________________/___, ____ de __________________________ de ________ " , oFont10) 

nL := nL + nAddl * 2

oPrint:say (nL+nPT,140		," ___________________________________________________________ " , oFont08) 

oPrint:say (nL+nPT+35,140		,STR0129 , oFont09) //150 Assinatura do Empregador ou Preposto

nL := nL + nAddl * 2

oPrint:say (nL+nAddL,140,"_________________________________________________________", oFont08) 
oPrint:say (nL+nAddL+nPT+30,150,STR0133, oFont09)//-- 151 Assinatura do Trabalhador

oPrint:say (nL+nAddL,1200,"_________________________________________________________", oFont08) 
oPrint:say (nL+nAddL+nPT+30,1215,STR0134, oFont09)//-- 152 Assinatura do Responsável Legal do Trabalhador

If lHomolog
	nL := nL + nAddl * 2
	oPrint:say (nL+nAddL,140,"_________________________________________________________", oFont08) 
	oPrint:say (nL+nAddL+nPT+40,150,STR0148, oFont09)//-- "153 Carimbo e Assinatura do Assistente"                                                                                                                                                                                                                                                                                                                                                                                                                                                                            

	oPrint:say (nL+nAddL,1200,"_________________________________________________________", oFont08) 
	oPrint:say (nL+nAddL+nPT+40,1215,STR0149, oFont09)//-- "154 Nome do Órgão Homologador"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

	nL:=nL+(nAddL*2)+(nPT)+15

	oPrint:Box(nL,135,nL+((nAddL+nPT)*12.5) - 60,nColMax) //BOX
	oPrint:say (nL+nPT+5,160,STR0150, oFont09)//-- "155 Ressalvas"

	nL := nL + ( ( nAddl + nPT + nPD ) * 6 ) - 60
Else
	nL := nL + nAddl * 2
	nL:=nL+(nAddL*2)+(nPT)+15	
	nL := nL + ( ( nAddl + nPT + nPD ) * 6 ) - 60
EndIf

nL:=nL+20+nPT

If !lHomolog
	nL+=95
	oPrint:Box((nL+((nAddL+nPT)*1.4)),135,(nL+((nAddL+nPT)*2.0))+55,nColMax) //BOX
Endif

oPrint:say (nL+((nAddL+nPT)*1.4)+25+nPT,160,STR0135, oFont09)//-- "156 Informações à CAIXA:"

nL:=nL+20 

If lHomolog                                                                             
	oPrint:line((nL+((nAddL+nPT)*1.4)),135 ,(nL+((nAddL+nPT))*1.4),nColMax) 		//Linha Horizontal  
Endif


nL:=(nL+((nAddL+nPT)*2.0))+35

oPrint:FillRect( {nL, 135, nL+nPD+nPD+nPD+45, nColMax+01}, oBrush1 )
oPrint:line(nL,135 ,nL,nColMax) 		//Linha Horizontal 
oPrint:say (nL,480			,STR0115, oFont12n) //"A ASSISTÊNCIA NO ATO DA RESCISÃO CONTRATUAL É GRATUITA."
oPrint:say (nL+nPD+10,180		,STR0116, oFont09n) //"Pode o trabalhador iniciar ação judicial quanto aos créditos resultantes das relações de trabalho até o limite de dois anos após a extinção do contrato de trabalho"
oPrint:say (nL+nPD+nPD+10,400	,STR0117, oFont09n) //"(Inc. XXIX, Art.7º da Constituição Federal/1988)."


oPrint:EndPage()

//FIM DA IMPRESSAO DO TEMRO DE QUITACAO DE RESCISAO

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fNewLine  ³ Autor ³ Kelly Soares          ³ Data ³ 20.01.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicia nova linha na impressao das verbas rescisorias.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RdMake                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fNewLine()

If nXCol = 3
	nXCol := 0
	nL+=nAddL+05
	oPrint:line(nL,135,nL,nColMax )		
Endif
nXCol++

//Verifica se atingiu o limite de linhas e efetua a quebra da pagina
fVerQuebra(1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PenunSal  ³ Autor ³ Mauricio MR		    ³ Data ³ 16.02.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Obtem o penultimo salario do funcionario antes da demissao.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ IMPRESH                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function PenunSal(dAdmissao, dDemissao, cVerbas, cFolMes, cVerbSal)

Local nEpoch	:= Set( _SET_EPOCH  )	//Obtem a configuracao de seculo corrente

Local aArea		:= GetArea()
Local aSRCArea	:= SRC->(GetArea())

//-- Data do Penultimo Salario.
Local dDTPenSal 
Local nValPenSal     
Local cFilMat	:= SRA->(RA_FILIAL+RA_MAT)

DEFAULT dAdmissao	:= SRA->RA_ADMISSA	
DEFAULT	dDemissao  	:= SRG->RG_DATADEM  
DEFAULT	cVerbas		:= ''  
DEFAULT cFolMes		:= SuperGetMv("MV_FOLMES")  
DEFAULT cVerbSal	:= acodfol[318,1]


Set( _SET_EPOCH , 1920 )	//Altera o Set Epoch para 1920

dDTPenSal := If(Month(dDemissao)-1 != 0, CtoD('01/' +StrZero(Month(dDemissao)-1,2)+'/'+Right(StrZero(Year(dDemissao),4),2)),CtoD('01/12/'+Right(StrZero(Year(dDemissao)-1,4),2)) )

If MesAno(dDtPenSal) < MesAno(dAdmissao)
	dDTPenSal 	:= CTOD("  /  /  ")
	nValPenSal 	:= 0.00
Endif
//--Penultimo 
If !Empty(dDTPenSal)              
	nValPenSal := fBuscaAcm(cVerbas + cVerbSal  ,,dDTPenSal,dDTPenSal,"V")	//-- Salario do mes + verbas que incorporaram  ao salario
	//--Pesquisa no movimento mensal quando o mes corrente estiver aberto
	//--e nao encontrar salario nos acumulados anuais.
	If nValPenSal == 0 .And. MesAno(dDTPenSal) == cFolMes
		If SRC->(Dbseek(cFilMat))
			While !SRC->(eof()) .And. cFilMat == SRC->(RC_FILIAL+RC_MAT)
				If SRC->RC_PD $cVerbas + cVerbSal
					nValPenSal += SRC->RC_VALOR
				Endif
				SRC->(dbskip())
			Enddo
		Endif
	Endif
Endif             

/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Restaura o Set Epoch Padrao								 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Set( _SET_EPOCH , nEpoch )
	
RestArea(aSRCArea)
RestArea(aArea)

Return(nValPenSal)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fVerQuebra³ Autor ³ Allyson M	            ³ Data ³ 25.03.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se quebra linha e finaliza os box e ilinhas.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RdMake                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fVerQuebra( nTipo, lLinhas )

Default lLinhas := .T.

If nL > 3280 

	//Quebra nos proventos
	If nTipo == 1
		lQuebraP := .T.    
	//Quebra nos descontos
	Else
		lQuebraD := .T.
	EndIf
	//Fecha o box e cria as linhas verticais
	oPrint:Box( nBoxIni,  135,nL,nColMax )
	If lLinhas
		oPrint:line(nBoxIni,nCl01b+20,nL,nCl01b+20 )
		oPrint:line(nBoxIni,nCl02a,nL,nCl02a )
		oPrint:line(nBoxIni,nCl02b+20,nL,nCl02b+20 )
		oPrint:line(nBoxIni,nCl03a,nL,nCl03a )
		oPrint:line(nBoxIni,nCl03b+20,nL,nCl03b+20 )  
	EndIf
	
	oPrint:EndPage()  //Termina a página
	oPrint:StartPage()//Inicia uma nova pagina

	//Se imprime cabecalho novamente
	If lImpCabec
		//Imprime o cabecalho da rescisao novamente (Campos 01 a 32)
		fCabec()
		//Quebra nos proventos
		If nTipo == 1
			oPrint:say (nL+nSubT,nCl01a+30,STR0036, oFont09n) //-- "VERBAS RESCISÓRIAS"
			nL := nL+nSubT
			nBoxIni := nL      
			oPrint:say (nL+02+nSubT,nCl01a+30		,STR0037	, oFont09n) //"RUBRICAS"
			oPrint:say (nL+02+nSubT,nCl01b+30		,STR0038	, oFont09n) //"VALOR"
			oPrint:say (nL+02+nSubT,nCl02a+30		,STR0037	, oFont09n) //"RUBRICAS"
			oPrint:say (nL+02+nSubT,nCl02b+30		,STR0038	, oFont09n) //"VALOR"
			oPrint:say (nL+02+nSubT,nCl03a+30		,STR0037	, oFont09n) //"RUBRICAS"
			oPrint:say (nL+02+nSubT,nCl03b+30		,STR0038	, oFont09n) //"VALOR" 
		//Quebra nos descontos
		Else
			//oPrint:Box(nL, 035,nL+nSubT, nColMax ) 									
			oPrint:say (nL+nSubT,nCl01a+30,STR0073, oFont09n)	//"DEDUÇÕES"
			nL := nL+nSubT
			nBoxIni := nL
			oPrint:say (nL+02+nSubT,nCl01a+30   ,STR0074, oFont09n)	 //"DESCONTO"
			oPrint:say (nL+02+nSubT,nCl01b+30	,STR0038, oFont09n) 	 //"VALOR"
			oPrint:say (nL+02+nSubT,nCl02a+30	,STR0074, oFont09n) 	 //"DESCONTO"
			oPrint:say (nL+02+nSubT,nCl02b+30	,STR0038, oFont09n) 	 //"VALOR"
			oPrint:say (nL+02+nSubT,nCl03a+30	,STR0074, oFont09n) 	 //"DESCONTO"
			oPrint:say (nL+02+nSubT,nCl03b+30	,STR0038, oFont09n) 	 //"VALOR"
		EndIf
		nL += nSubT	
		oPrint:line(nL,135,nL,nColMax )
		nL += nSubT + 1
	Else
		nL := nBoxIni := 077
	EndIf  
	nPagina+= 1
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fCabec	³ Autor ³ Allyson M	            ³ Data ³ 06.05.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho da Rescisoa.      					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RdMake                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCabec( nTipo, lLinhas )

nL:=078

oBrush1 := TBrush():New( ,  RGB(197,197,197)  )  
oBrush2	:=  TBrush():New( ,  CLR_WHITE  )  
oPrint:FillRect( {nL, 135, nL+(nTit-60)+nTit, nColMax}, oBrush1 )

oPrint:Box(nL, 135,nL+(nTit-50)+(nTit+10)+nPT+10+nTit+nTit+(nTit*3)+20+nPT+nTit+(nTit*4)+nTit+(nTit*3)+540   , nColMax ) 		//-- Box p/ Tit. "TERMO DE RESCISÃO DO CONTRATO DE TRABALHO"

nL:=nL+nTit-60
oPrint:say (nL,537,STR0003, oFont13n) //-- "TERMO DE RESCISÃO DO CONTRATO DE TRABALHO"
                                              
oPrint:FillRect( {nL+nTit, 037, nL+nTit+nSubT-15, nColMax+10}, oBrush2 )
oPrint:line(nL+nTit,135 ,nL+nTit,nColMax) 			//Linha Horizontal
nL:=nL+nTit
//oPrint:line(nL,035 ,nL,nColMax) 			//Linha Horizontal

oPrint:FillRect( {nL+nSubT-15, 137, nL+nSubT+nSubT-15, nColMax}, oBrush1 )
oPrint:line(nL+nSubT-15,135 ,nL+nSubT-15,nColMax)
nL:=nL+nSubT+nPT-15
oPrint:say (nL-05,890,STR0002, oFont09n) 	//-- "IDENTIFICAÇÃO DO EMPREGADOR"



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³IDENTIFICACAO DO EMPREGADOR                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nL:=nL+nSubT+05
//oPrint:Box( nL , 0035 , nL+(nAddL*3) ,nColMax ) 	//-- Box Identificacao do Trabalhador
                                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a impressao do texto na vertical                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPrint:line(nL-10,135 ,nL-10,nColMax) 							//Linha Horizontal
oPrint:line(nL-10,635 ,nL+nAddL,635 )							//Linha Vertical Meio
oPrint:say (nL+05,155,STR0056, oFont08) 		 			//"01- CNPJ/CEI: 	
oPrint:say (nl+05,650,STR0001, oFont08)					//"02- Razão Social / Nome:"  
oPrint:say (nL+nPD,175 ,SUBSTR(If( Len(aInfo) >= 27 .And. !Empty( aInfo[27] ), aInfo[27], aInfo[8] )+Space(20),1,20), oFont10 ) 	//"|01- CNPJ: 
oPrint:say (nL+nPD,665 ,aInfo[3], oFont10 )					//"02- Razao Social / Nome:"

oPrint:line(nL+nAddL,135 ,nL+nAddL,nColMax) 				//Linha Horizontal	
oPrint:line(nL+nAddL,1580,nL+(nAddL*2)+10,1580)				//Linha Vertical Meio	BAIRRO
oPrint:say (nL+nAddL+05,155 ,"03 "+STR0005, oFont08)      	//"Endereço (Logradouro, nº, andar, apartamento)"
oPrint:say (nL+nAddL+05,1620,"04 "+STR0014, oFont08)		//04 Bairro : "
oPrint:say (nL+nAddL+nPD,175 ,aInfo[4] , oFont08)			//03 Endereco   : "
oPrint:say (nL+nAddL+nPD,1175,"- "+aInfo[14], oFont08)			//03 Complemento
oPrint:say (nL+nAddL+nPD,1635,aInfo[13], oFont10)	   		//04 Bairro : "
	
oPrint:line(nL+(nAddL*2)+10,900 ,nL+(nAddL*3)+20,900 )		//Linha Vertical Meio
oPrint:line(nL+(nAddL*2)+10,1080,nL+(nAddL*3)+20,1080)		//Linha Vertical Meio
oPrint:line(nL+(nAddL*2)+10,1300,nL+(nAddL*3)+20,1300)		//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2)+10,1580,nL+(nAddL*3)+20,1580)  		//Linha Vertical Meio
oPrint:line(nL+(nAddL*2)+10,0135,nL+(nAddL*2)+10,nColMax) 		//Linha Horizontal
oPrint:say (nL+(nAddL*2)+15,155 ,"05 "+STR0015, oFont08)										//"|05 Munic.: "
oPrint:say (nL+(nAddL*2)+15,920 ,"06 "+STR0016, oFont08)										//"|06 UF : "
oPrint:say (nL+(nAddL*2)+15,1100,"07 "+STR0013, oFont08)								   		//"|07 Cep: "
oPrint:say (nL+(nAddL*2)+15,1320,"08 "+STR0017, oFont08)										//"|08 CNAE " 
oPrint:say (nL+(nAddL*2)+15,1600,"09 "+STR0004, oFont08)										//"|09 CNPJ/CEI Tomador/Obra: "

oPrint:say (nL+(nAddL*2)+10+nPD,175 ,aInfo[5] , oFont10)									  	 	//"|05 Munic.: "
oPrint:say (nL+(nAddL*2)+10+nPD,920 ,aInfo[6] , oFont10)									 	  	//"|06 UF : "
oPrint:say (nL+(nAddL*2)+10+nPD,1120,aInfo[7] , oFont10)									  		//"|07 Cep: "
oPrint:say (nL+(nAddL*2)+10+nPD,1310,aInfo[16], oFont10)									  		//"|08 CNAE"
oPrint:say (nL+(nAddL*2)+10+nPD,1600,Substr(fDesc("CTT",SRA->RA_CC,"CTT_CEI")+Space(5),1,15), oFont10)//"|09 CNPJ/CEI Tomador/Obra: "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³IDENTIFICACAO DO TRABALHADOR                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//nL:=535
nL:=nL+(nAddL*3)+20 

//oPrint:Box(nL, 035,nL+81+(nAddL*4), nColMax ) 	//-- Box p/ Tit. Identificacao do Trabalhador  
oPrint:FillRect( {nL, 137, nL+nSubT, nColMax}, oBrush1 )
oPrint:line(nL,135 ,nL,nColMax) 		//Linha Horizontal	
oPrint:say (nL+05,880,STR0006, oFont09n)			//"IDENTIFICAÇÃO DO TRABALHADOR"  
oPrint:line(nL+nSubT,135 ,nL+nSubT,nColMax) 		//Linha Horizontal	//-- Identificacao do Trabalhador 
nL:=nL+nSubT										//-- Identificacao do Trabalhador 
nL:=nL+nPT


oPrint:say (nL+nPT,155 ,STR0025, oFont08) 		//"10 PIS/PASEP:" 
oPrint:say (nL+nPT,525 ,STR0023, oFont08)		//"11 NOME:"
oPrint:line(nL+nAddL+10,135 ,nL+nAddL+10,nColMax) //Linha Horizontal
oPrint:line(nL,505 ,nL+nAddL+nPT,505 )				//Linha Vertical Meio	

oPrint:say (nL+nPD,175 ,SRA->RA_PIS,oFont10) //PIS
If SRA->(FieldPos("RA_NOMECMP")) # 0 .And. !Empty(SRA->RA_NOMECMP)
	oPrint:say (nL+nPD,540 ,Subs(SRA->RA_NOMECMP+Space(60),1,60),oFont10) //NOME
Else
	oPrint:say (nL+nPD,540 ,Subs(SRA->RA_NOME+Space(30),1,30),oFont10) //NOME
EndIf	
	
oPrint:say (nL+nAddL+nPT+15,155 ,"12 "+STR0005, oFont08)  	//"Endereço (Logradouro, nº, andar, apartamento)"
oPrint:say (nL+nAddL+nPT+15,1825,"13 "+STR0014, oFont08)	  	//"|04 Bairro : "
If SRA->(FieldPos("RA_NUMENDE")) # 0 .And. !Empty(SRA->RA_NUMENDE) 
	oPrint:say (nL+nAddL+nPD+15,175 ,Subs(SRA->RA_ENDEREC+', '+SRA->RA_NUMENDE+Space(40),1,40),oFont10) // "|03 Endereco + Numero de Endereço
Else
	oPrint:say (nL+nAddL+nPD+15,175 ,Subs(SRA->RA_ENDEREC+Space(30),1,30),oFont10)	//"|03 Endereco   : "
EndIf
oPrint:say (nL+nAddL+nPD+15,935 ,SRA->RA_COMPLEM, oFont10)	//"|03 Complemento
oPrint:say (nL+nAddL+nPD+15,1840,SRA->RA_BAIRRO, oFont10)		//"|04 Bairro : "
oPrint:line(nL+(nAddL*2)+20,135 ,nL+(nAddL*2)+20,nColMax) 		//Linha Horizontal
oPrint:line(nL+nAddL+10,1805,nL+(nAddL*2)+20,1805)				//Linha Vertical Meio	

oPrint:say (nL+(nAddL*2)+nPT+20,155 ,"14 "+STR0015, oFont08)	//"|Munic.: "
oPrint:say (nL+(nAddL*2)+nPT+20,720 ,"15 "+STR0016, oFont08)	//"|UF : "
oPrint:say (nL+(nAddL*2)+nPT+20,1020,"16 "+STR0013, oFont08)	//"|Cep: "
oPrint:say (nL+(nAddL*2)+nPT+20,1370,"17 "+STR0024, oFont08)	//"|CTPS"
oPrint:say (nL+(nAddL*2)+nPT+20,1825, STR0012, oFont08)		//18 CPF:"

oPrint:say (nL+(nAddL*2)+nPD+20,175 ,SRA->RA_MUNICIP, oFont10)	//"|Munic.: " 
oPrint:say (nL+(nAddL*2)+nPD+20,740 ,SRA->RA_ESTADO , oFont10)	//"|UF : "
oPrint:say (nL+(nAddL*2)+nPD+20,1035,SRA->RA_CEP , oFont10)		//"|Cep: "
oPrint:say (nL+(nAddL*2)+nPD+20,1385,SRA->RA_NUMCP+"- "+SRA->RA_SERCP+"/"+SRA->RA_UFCP, oFont10)	//"|CTPS"
oPrint:say (nL+(nAddL*2)+nPD+20,1840,SRA->RA_CIC, oFont10)		//18 CPF:"

oPrint:line(nL+(nAddL*3)+30,135 ,nL+(nAddL*3)+30,nColMax) 	//Linha Horizontal 
oPrint:line(nL+(nAddL*2)+20,700 ,nL+(nAddL*3)+30,700 )		//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2)+20,1000,nL+(nAddL*3)+30,1000)		//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2)+20,1350,nL+(nAddL*3)+30,1350)		//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2)+20,1805,nL+(nAddL*3)+30,1805)		//Linha Vertical Meio	

oPrint:say (nL+(nAddL*3)+nPT+30,155 , STR0027, oFont08)		//19 Nasc.:"
oPrint:say (nL+(nAddL*3)+nPT+30,510, STR0007, oFont08)		//20 Nome da Mae"
oPrint:say (nL+(nAddL*3)+nPD+30,180 , DtoC(SRA->RA_NASC), oFont10)	//19 Nasc.:"
oPrint:say (nL+(nAddL*3)+nPD+30,520, SUBSTR(SRA->RA_MAE+Space(30),1,40), oFont10)	//20 Nome da Mae"  
oPrint:line(nL+(nAddL*3)+30,0500,nL+(nAddL*4)+40,0500)	//Linha Vertical Meio	

nL:=nL+(nAddL*4)+40
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DADOS DO CONTRATO	                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oPrint:Box(nL, 035,nL+70+80+(nAddL*3), nColMax ) 	//-- Box p/ Tit. "DADOS DO CONTRATO"   
oPrint:FillRect( {nL, 137, nL+nSubT, nColMax}, oBrush1 )

oPrint:Line(nL,135,nL,nColMax) //Linha Horizontal
oPrint:say (nL+05,997,STR0008, oFont09n) //-- "DADOS DO CONTRATO"

nL:=nL+nSubT
oPrint:Box(nL+nTip,135,nL,nColMax) //Linha Horizontal

oPrint:say (nL+nPT,155	,STR0009	  , oFont08) //"21 Tipo de Contrato" 
oPrint:say (nL+nPD,180	,If( ( ( SRA->RA_TPCONTR=="1" ) .or. Empty(SRA->RA_TPCONTR)),;
								STR0010 ,;//"1. Contrato de trabalho por prazo indeterminado"
								If(SRA->RA_CLAURES=="1", STR0011, STR0018)), oFont10)  //"2. Contrato de trabalho por prazo determinado com cláusula assecuratória de direito recíproco de rescisão antecipada."##"3. Contrato de trabalho por prazo determinado sem cláusula assecuratória de direito recíproco de rescisão antecipada."

nL:=nL+nTip-5
oPrint:say (nL+nPT,155,STR0019, oFont08) //"22 Causa do Afastamento" 
oPrint:say (nL+nPD,180,Left(cCausa,100), oFont10) 

oPrint:say (nL+nTip+nPT+10,155	,STR0020	, oFont08) //"23 Remuneração Mês Ant."
aAreaSRD:=GetArea()
nOrderSRD:=SRD->(DbSetOrder())

nPenunSal:= PenunSal(SRA->RA_ADMISSA, SRG->RG_DATADEM, cVerbas_Aux, /*cFolMes*/, acodfol[318,1])

IF Empty(nPenunSal)  
	nPenunSal:= SRG->RG_SALMES
Endif

oPrint:say (nL+nTip+nPD+10,180	,Transform(nPenunSal,"@E 999,999,999.99"), oFont10)  

DbSelectArea(aAreaSRD)

fPHist82(SRA->RA_FILIAL ,"32",SRG->RG_TIPORES+"  ",57,3,@cCodAfa)

oPrint:say (nL+nTip+nPT+10,586+15,STR0021	, oFont08) //"24 Data de Admissão"
oPrint:say (nL+nTip+nPD+10,586+30,DtoC(SRA->RA_ADMISSA), oFont10) 
oPrint:say (nL+nTip+nPT+10,972+15,STR0022, oFont08) //"25 Data do Aviso Prévio"
oPrint:say (nL+nTip+nPD+10,972+30,DtoC(SRG->RG_DTAVISO), oFont10) 
oPrint:say (nL+nTip+nPT+10,1358+15,STR0026, oFont08)//"26 Data de Afastamento" 
oPrint:say (nL+nTip+nPD+10,1358+30,DtoC(SRG->RG_DATADEM), oFont10) 
oPrint:say (nL+nTip+nPT+10,1758+15,STR0155	, oFont08) //"27 Cód. Afastamento"
oPrint:say (nL+nTip+nPD+10,1758+30,cCodAfa, oFont10) 

oPrint:line(nL+nTip,576,nL+nTip+nAddL+10,576)	//Linha Vertical Meio	
oPrint:line(nL+nTip,962,nL+nTip+nAddL+10,962)	//Linha Vertical Meio	
oPrint:line(nL+nTip,1348,nL+nTip+nAddL+10,1348)	//Linha Vertical Meio
oPrint:line(nL+nTip,1748,nL+nTip+nAddL+10,1748)	//Linha Vertical Meio
oPrint:line(nL+nTip,135 ,nL+nTip,nColMax) 	//Linha Horizontal
          

oPrint:say (nL+nTip+nAddL+nPT+10,155,STR0029	, oFont08) //"28 Pensão Alim. (%) (TRCT)"
oPrint:say (nL+nTip+nAddL+nPD+10,180,Transform(nPerPensa,"@E 999.99"), oFont10) 
oPrint:say (nL+nTip+nAddL+nPT+10,572+15,STR0030	, oFont08) //"29 Pensão Alim. (%) (FGTS)"
oPrint:say (nL+nTip+nAddL+nPD+10,572+30,Transform(nPerFGTS,"@E 999.99"), oFont10) 
oPrint:say (nL+nTip+nAddL+nPT+10,1158+15,STR0031	, oFont08)//"30 Categoria do Trabalhador" 

/*Categorias funcionarios considerados no TRCT através da portaria 1057/2012 	
01 - Empregado
03 - Trabalhador não vinculado ao RGPS, mas com direito ao FGTS
04 - Empregado - contrato de trab. por prazo determ. (Lei nº 9.601/98)
06 - Empregado Doméstico
07 - Menor Aprendiz (Lei 10.097/2000)*/

If SRA->RA_CATEG $ "03/04/06/07"
	If SRA->RA_CATEG == "03"
		cDescCateg := STR0163
	ElseIf SRA->RA_CATEG == "04"
		cDescCateg := STR0164
	ElseIf SRA->RA_CATEG == "06"
		cDescCateg := STR0161
	ElseIf SRA->RA_CATEG == "07"
		cDescCateg := STR0162
	EndIf
EndIf

oPrint:say (nL+nTip+nAddL+nPD+10,1158+30,cCateg+' - '+cDescCateg, oFont10) 
                                                  	
oPrint:line(nL+nTip+nAddL+10,0562,nL+nTip+(nAddL*2)+20,562 )										//Linha Vertical Meio	
oPrint:line(nL+nTip+nAddL+10,1148,nL+nTip+(nAddL*2)+20,1148)										//Linha Vertical Meio	
oPrint:line(nL+nTip+nAddL+10,135 ,nL+nTip+nAddL+10,nColMax) 									//Linha Horizontal

IF MV_PAR25 == 1
	cOrgao	:=	fGetOrgao(SRA->RA_SINDICA,xFilial("RCE"))
ElseIf MV_PAR25 == 2
	cOrgao	:=	fGetOrgao(MV_PAR26,xFilial("RCE"))
Else                                            
	cOrgao	:=	""
EndIf

oPrint:say (nL+nTip+(nAddL*2)+nPT+30,155	,STR0033	, oFont08) //"31 Codigo Sindical"
oPrint:say (nL+nTip+(nAddL*2)+nPT+30,576+15 ,STR0140	, oFont08) //"32 CNPJ e Nome da Entidade Sindical Laboral"
If MV_PAR25 <> 3                      
	If ( SRA->RA_VIEMRAI <> "20" .AND. SRA->RA_VIEMRAI <> "25" )
		oPrint:say (nL+nTip+(nAddL*2)+30+nPD,180	,RCE->RCE_ENTSIN, oFont10) 
	Endif
	oPrint:say (nL+nTip+(nAddL*2)+nPD+30,576+30,RCE->RCE_CGC+" "+RCE->RCE_DESCRI, oFont10)  
Endif	

oPrint:line(nL+nTip+(nAddL*2)+20,576,nL+nTip+(nAddL*3)+30,576 )											//Linha Vertical Meio	
oPrint:line(nL+nTip+(nAddL*2)+20,135 ,nL+nTip+(nAddL*2)+20,nColMax) 										//Linha Horizontal

nL:=nL+nTip+(nAddL*3)+30

oPrint:FillRect( {nL, 135, nL+nSubT, nColMax}, oBrush1 )
oPrint:Box(nL, 135,nL+(nSubT*3), nColMax ) 	//-- Box p/ Tit. "DISCRIMINAÇÃO DAS VERBAS RESCISÓRIAS"
oPrint:say (nL+05,805,STR0035, oFont09n) 	//-- "DISCRIMINAÇÃO DAS VERBAS RESCISÓRIAS"

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fDesconto ³ Autor ³ Gustavo M		        ³ Data ³ 20/06/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Quebra de linha para os descontos.						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ IMPRESH                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fDesconto(nValLin)

nValLin++
If nValLin > 3
	nL+=nAddL+05
 	oPrint:line(nL,135,nL,nColMax )
   	fVerQuebra(2)
   	nValLin := 1
Endif
 
Return