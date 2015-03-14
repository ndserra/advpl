#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


#xcommand DEFAULT <uVar1> := <uVal1> ;
      [, <uVarN> := <uValN> ] => 		;
									    <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
   	  [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

//-- Define's de aCONFIG
#DEFINE NETQPARAM 		  29

#DEFINE NETQIMPLINHA     1
#DEFINE NETQIMPCOLUNA    2
#DEFINE NETQALTURA  	  3
#DEFINE NETQLARGURA	  4
#DEFINE NETQDISTH		  5
#DEFINE NETQDISTV		  6
#DEFINE NETQQTDH		  7
#DEFINE NETQQTDV		  8
#DEFINE NPAGMARGESQ 	  9
#DEFINE NPAGMARGSUP 	  10
#DEFINE NLOGALTURA 	  11
#DEFINE NLOGLARGURA 	  12
#DEFINE NLOGPOS 		  13
#DEFINE NIMGALTURA 	  14
#DEFINE NIMGLARGURA 	  15     
#DEFINE NORDEM        	  16		   
#DEFINE CFILDE           17
#DEFINE CFILATE          18
#DEFINE CVISDE           19
#DEFINE CVISATE          20
#DEFINE CEMPDE           21
#DEFINE CEMPATE          22
#DEFINE DDTVISI          23
#DEFINE DDTVISF          24
#DEFINE CCRACHADE        25        
#DEFINE CCRACHAATE       26
#DEFINE NHORDE           27
#DEFINE NHORATE          28
#DEFINE CTPVIS           29

//Define's de aVarBloq
#DEFINE NMAXCOL          01
#DEFINE NMAXLIN          02
#DEFINE NLIN          	  03
#DEFINE NCOL             04
#DEFINE NPOSCOL          05
#DEFINE NPOSLIN          06

/*
  =========================================================================
  Opcoes de Fontes Disponiveis para Uso na Impressao do Texto das Etiquetas
  =========================================================================
  
oCouNew07  	-->	"Courier New"    //-- Modo Normal 
oCouNew07N 	-->	"Courier New" 	 //-- Modo Negrito(5o parametro New() )  
oCouNew08  	-->	"Courier New"
oCouNew08N 	-->	"Courier New"
oCouNew10 	-->	"Courier New"
oCouNew10N	-->	"Courier New"
oCouNew12 	-->	"Courier New"
oCouNew12N	-->	"Courier New"
oCouNew15 	--> "Courier New"
oCouNew15N	-->	"Courier New"
oCouNew21 	--> "Courier New"
oCouNew21N	-->	"Courier New"
oArial08 	--> "Arial"      
oArial08N 	-->	"Arial"      
oArial12  	--> "Arial"      
oArial12N 	--> "Arial"      
oArial16 	-->	"Arial"      
oArial16N 	-->	"Arial"      

*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ETQVIST  ³ Autor ³ MAURICIO MR           ³ Data ³ 22.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Grafica Individual de Etiquetas de Visitantes    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ETQVIST() 		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ETQVIST()

//-- Configuracao de Cracha
If PARAMIXB[1] == 1
   fETQCfg('ETQCFG')      
//-- Impressao Individual de Etiquetas para Cracha   
ElseIf PARAMIXB[1] == 2
       fETQIndiv('ETQCFG', 'ETQIND')              
//-- Impressao Coletiva de Etiquetas para Cracha          
ElseIf PARAMIXB[1] == 3 
       fETQColetiva('ETQCFG','ETQCOL')
Endif    

Return NIL
   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fETQIndiv ³ Autor ³ Mauricio MR           ³ Data ³ 20/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Etiqueta Individual para Cracha 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ETQVIST                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function  fETQIndiv(cPergCfg,cPergImp)
Local aFotos	:= {}         
Local aVisitas	:= Array( 06 )  
Local bProcessa := {|| NIL }   
Local lPreview	:= .T.
Local nColPg	:= 800  
Local nEtiqueta	:= 1
Local nLinPg	:= 3100
Local nQtdeCol 	:= 1
Local nX	    := 0
Local aConfig   := {}

Begin Sequence

	aConfig			:= Array(NETQPARAM)
	
	//-- Obtem Dados da Etiqueta 
	aVisitas[  1   ] 	:= XFILIAL('SPY')				//01 - Filial
	aVisitas[  2   ] 	:= M->PY_CRACHA					//02 - Cracha da Visita
	aVisitas[  3   ] 	:= M->PY_NOMEMP					//03 - Nome da Empresa
	    
	SPW->(DBSEEK(xFilial("SPW")+M->PY_VISITA))
	SPW->( aVisitas[  4	  ]	:= PW_VISITA  )				//04 - Codigo do Visitante
	SPW->( aVisitas[  5	  ]	:= ALLTRIM(PW_NOMFULL) )	//05 - Nome do Visitante
	SPW->( aVisitas[  6	  ]	:= PW_BITMAP	)			//06 - Nome da Foto 	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//-- Obtem Configuracao do Cracha
	Pergunte(cPergCfg, .F.)
	
	aConfig[NETQALTURA  	]:=  mv_par01 //Altura?
	aConfig[NETQLARGURA		]:=  mv_par02 //Comprimento?
	aConfig[NETQDISTH		]:=  mv_par03 //Distancia Horiz.? 
	aConfig[NETQDISTV		]:=  mv_par04 //Distancia Vertical ?
	aConfig[NETQQTDH		]:=  mv_par05 //Qtde por Linha ? 
	aConfig[NETQQTDV		]:=  mv_par06 //Qtde por Coluna ?  
	aConfig[NPAGMARGESQ 	]:=  mv_par07 //Margem Esquerda?
	aConfig[NPAGMARGSUP 	]:=  mv_par08 //Margem Superior?   
	aConfig[NLOGALTURA 		]:=  mv_par09 //Logo Altura?   
	aConfig[NLOGLARGURA 	]:=  mv_par10 //Logo Comp?   
	aConfig[NLOGPOS 		]:=  mv_par11 //Logo Posicao?   
	aConfig[NIMGALTURA 		]:=  If(ValType(mv_par12)=='C' .AND. Empty(mv_par12) ,250,mv_par12) //Imagem Altura?   
	aConfig[NIMGLARGURA 	]:=  If(ValType(mv_par13)=='C' .AND. Empty(mv_par13) ,250,mv_par13) //Imagem Comp?  

	//-- Obtem Posicao da Etiqueta do Cracha	
	If ! Pergunte(cPergImp, .T.)
	   Break
	Endif   
	aConfig[NETQIMPLINHA  	]:=  MIN(mv_par01,aConfig[NPAGMARGSUP 	]) //Imprimir na Linha?
	aConfig[NETQIMPCOLUNA 	]:=  min(mv_par02,aConfig[NPAGMARGESQ 	]) //Imprimir na Coluna?
    
 
	
	bProcessa := {|| fImpCracha(aVisitas, GetSrvProfString("Startpath",""),Nil,aConfig)}
	//Inicializa a Impressao com Opcao de Pre-visualizacao
	fIniPrtGraf( , nLinPg, nColPg, bProcessa,lPreview,.F.)
	//-- Calcula a Localizacao da Proxima Etiqueta                                                               
	fEtqAdd( cPergCFG, cPergImp, '05', '06', '01', '02')
	
	//-- Apaga BMP Foto do Diretorio
	For nX:=1 to Len(aFotos)
		IF File(aFotos[nX])
			fErase( aFotos[nX])
		Endif	
	next nX

End
	
Return Nil                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpCracha³ Autor ³ Mauricio MR           ³ Data ³ 20/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Cracha											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ETQINDIV                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
				
Function fImpCracha(aVisitas, cPath, cFileLogo, aConfig, aFotos, lSalta)
Local cFileFoto		:= ''
Local nLin			:= aConfig[NPAGMARGSUP 	] 
//Local nLinPg		:= (aConfig[NETQQTDV] * (aConfig[NETQALTURA] + aConfig[NETQDISTV] ) ) + aConfig[NPAGMARGSUP] 
Local nLinTexto		:= 150
Local nPosLinI		:= 0
Local nPosColI		:= 0
Local nPosCImg		:= 0
Local nPosCLogo		:= 0
Local nPosCTexto	:= 0


DEFAULT aFotos		:= {}
DEFAULT cPath	 	:= GetSrvProfString("Startpath","")
DEFAULT lSalta		:= .F.

nPosLinI:= aConfig[NPAGMARGSUP 	] + ( aConfig[NETQALTURA  	]  * (aConfig[NETQIMPLINHA 	] - 1)) + ( aConfig[NETQDISTH]* ( aConfig[NETQIMPLINHA	 ] - 1 ) )
nPosColI:= aConfig[NPAGMARGESQ 	] + ( aConfig[NETQLARGURA  	]  * (aConfig[NETQIMPCOLUNA	] - 1)) + ( aConfig[NETQDISTV]* ( aConfig[NETQIMPCOLUNA  ] - 1 ) )

nPosCLogo	:= nPosColI + IF(aConfig[NLOGPOS]==1,aConfig[NIMGLARGURA]+50,0) 
nPosCTexto	:= nPosCLogo
nPosCImg	:= nPosColI + IF(aConfig[NLOGPOS]==1, 0,(aConfig[NETQLARGURA]-aConfig[NIMGLARGURA])+50) 

If lSalta
   oPrint:EndPage()   
   nPosLinI	:=aConfig[NPAGMARGSUP 	]
Endif

//-- Logo Empresa
//-- Obtem Logo 
If cFileLogo == NIl
   fLogoEmp(@cFileLogo)
Endif

If !Empty(cFilelogo)
	oPrint:SayBitmap(nPosLinI, nPosCLogo, cFileLogo, aConfig[NLOGLARGURA], aConfig[NLOGALTURA]) 		//-- Tem que estar abaixo do RootPath
Endif	

cFileFoto:=fGetFoto(cPath, aVisitas[6], @aFotos )  		//-- Localizacao, Nome da Foto, Armazena a Foto
     
//--  Foto Visitante
If !EMPTY(cFileFoto)
	oPrint:SayBitmap(nPosLinI,nPosCImg,cFileFoto, aConfig[NIMGLARGURA], aConfig[NIMGALTURA]) 
Endif                     


//-- Informacoes Visitante
oPrint:say(nPosLinI+nLinTexto		, nPosCTexto	,aVisitas[04]					,oCouNew12N) //Codigo Visitante
oPrint:say(nPosLinI+nLinTexto + 50 	, nPosCTexto	,Substr(aVisitas[05],1,18)		,oCouNew15N) //Nome Visitante
oPrint:say(nPosLinI+nLinTexto + 100	, nPosCTexto	,Substr(aVisitas[03],1,40)		,oCouNew12)	//Empresa

nLin+= MAX(aConfig[NIMGALTURA], (aConfig[NLOGALTURA]+nLinTexto+150))
   

Return (Nil)        
                                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fETQCfg        ³ Autor ³ Mauricio MR           ³ Data ³ 20/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configura parametros para Impressao de Etiqueta para Cracha     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ETQVIST                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function  fETQCfg(cPergCfg)
Local lRet := .T.

lRet:=Pergunte(cPergCfg, .T.)

Return(lRet)
   

	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fETQColetiva   ³ Autor ³ Mauricio MR           ³ Data ³ 20/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Etiquetas para Um Grupo de Visitantes		   	       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ETQVIST                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function  fETQColetiva(cPergCfg,cPergImp)

Local aFotos	:= {}         
Local aVisitas	:= Array( 06 )  
Local bProcessa := {|| NIL }   
Local lPreview	:= .T.
Local nColPg	:= 800  
Local nEtiqueta	:= 1
Local nLinPg	:= 3100
Local nQtdeCol 	:= 1
Local nX	    := 0
Local aConfig   := {}
Local aVarBloq	:= {}

Begin Sequence

	aConfig			:= Array(NETQPARAM)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//-- Obtem Configuracao do Cracha
	Pergunte(cPergCfg, .F.)
	
	aConfig[NETQALTURA  	]:=  mv_par01 //Altura?
	aConfig[NETQLARGURA		]:=  mv_par02 //Comprimento?
	aConfig[NETQDISTH		]:=  mv_par03 //Distancia Horiz.? 
	aConfig[NETQDISTV		]:=  mv_par04 //Distancia Vertical ?
	aConfig[NETQQTDH		]:=  mv_par05 //Qtde por Linha ? 
	aConfig[NETQQTDV		]:=  mv_par06 //Qtde por Coluna ?  
	aConfig[NPAGMARGESQ 	]:=  mv_par07 //Margem Esquerda?
	aConfig[NPAGMARGSUP 	]:=  mv_par08 //Margem Superior?   
	aConfig[NLOGALTURA 		]:=  mv_par09 //Logo Altura?   
	aConfig[NLOGLARGURA 	]:=  mv_par10 //Logo Comp?   
	aConfig[NLOGPOS 		]:=  mv_par11 //Logo Posicao?   
	aConfig[NIMGALTURA 		]:=  If(ValType(mv_par12)=='C' .AND. Empty(mv_par12) ,250,mv_par12) //Imagem Altura?   
	aConfig[NIMGLARGURA 	]:=  If(ValType(mv_par13)=='C' .AND. Empty(mv_par13) ,250,mv_par13) //Imagem Comp?  


	//-- Obtem Posicao da Etiqueta do Cracha	
	If ! Pergunte(cPergImp, .T.)
	   Break
	Endif   
	aConfig[NETQIMPLINHA  	]:=	MIN(mv_par01,aConfig[NPAGMARGSUP 	]) //Imprimir na Linha?
	aConfig[NETQIMPCOLUNA 	]:=	min(mv_par02,aConfig[NPAGMARGESQ 	]) //Imprimir na Coluna?
	aConfig[NORDEM			]:=	mv_par03
	aConfig[CFILDE          ]:=	mv_par04
	aConfig[CFILATE         ]:=	mv_par05
	aConfig[CVISDE          ]:=	mv_par06
	aConfig[CVISATE         ]:=	mv_par07
	aConfig[CEMPDE          ]:=	mv_par08
	aConfig[CEMPATE         ]:=	mv_par09
	aConfig[DDTVISI         ]:=	mv_par10
	aConfig[DDTVISF         ]:=	mv_par11
	aConfig[CCRACHADE       ]:=	mv_par12
	aConfig[CCRACHAATE      ]:=	mv_par13
	aConfig[NHORDE          ]:=	mv_par14
	aConfig[NHORATE         ]:=	mv_par15
	aConfig[CTPVIS          ]:=If(mv_par16=1,'1',If(mv_par16=2,'2','3'))
 
	If DTOS(aConfig[DDTVISI]) > DTOS(aConfig[DDTVISF         ])
		Help(' ',1,'PNR050DATA')
		Break
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Redefine a Ordem de Impressao conforme Indice                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	If 	aConfig[NORDEM			]== 1
	   	aConfig[NORDEM			]:=2
	ElseIf 	aConfig[NORDEM		] == 2
	   	aConfig[NORDEM			]:=3
	ElseIf 	aConfig[NORDEM		] == 3
	   	aConfig[NORDEM			]:=6
	Endif    
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Trata SX1										             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
    //-- Bloqueia e Recupera Dados das Etiquetas
	If Empty((aVarBloq:= fEtqBloq( cPergCFG, cPergImp, '05', '06', '01', '02') ))
	   Break
	Endif
	

	bProcessa := {|| RptStatus( { |lEnd| fImpColet(GetSrvProfString("Startpath",""),aConfig, @aFotos)} , '' )}

	//Inicializa a Impressao com Opcao de Pre-visualizacao
	fIniPrtGraf( , nLinPg, nColPg, bProcessa,lPreview,.F.)
	//-- Salva as Novas Coordenadas da Etiqueta a Ser Impressa
    fEtqSave(aConfig[NETQIMPCOLUNA], aConfig[NETQIMPLINHA  	], aVarBloq[NPOSCOL], aVarBloq[NPOSLIN]) 
    //-- Libera Registros
	PonFreeLocks() 
	
	//-- Apaga BMP Foto do Diretorio
	For nX:=1 to Len(aFotos)
		IF File(aFotos[nX])
			fErase( aFotos[nX])
		Endif	
	next nX

End
	
Return Nil                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpColet³ Autor ³ Mauricio MR 		    ³ Data ³ 22.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Obtem Dados e Imprime Etiquetas para Crachas de Visitantes ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpColet(cLogoEmp, aConfig)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ WnRel       - T¡tulo do relat¢rio                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpColet(cLogoEmp, aConfig, aFotos)
Local aAreaSPY	 	:= SPY->( GetArea() )
Local aTempSPY	 	:= SPY->( dbStruct() )                      
Local aVisitas 		:=	{}  

Local cAcessaSPY 	:= &("{ || " + ChkRH("ETQVIST",'SPY',"2") + "}")  
Local cAliasQuery	:= 'SPY'
Local cDbSeek		:= '' 
Local cFilAlias	 	:= xFilial('SPY')
Local cFilSPW	 	:= xFilial('SPW')	
Local cInicio	 	:= ''
Local cFim		 	:= ''
Local cLastFil		:= "__cLastFil__"     
Local lSalta		:= .F.
Local nContField	:= Len(aTempSPY)   
Local nMaxLin		:= aConfig[NETQQTDV]
Local nMaxCol       := aConfig[NETQQTDH]
Local nLin			:= 0
Local nCol          := 0
Local nX			:= 0                  



#IFDEF TOP
	Local cQuery	 := ""
	Local cSP_Query	 := ""
	Local aStruSPY	 := {}
	Local aCposSPY	 := {} 
	Local nLenStruSPY:= 0.00
#ENDIF

dbSelectArea('SPY')

SPY->( dbSetOrder( 	aConfig[NORDEM] ) )
SPY->( dbGoTop() )

//-- Codigo do Visitante + Data
//-- Filial + Cracha + Data Visita
If 	aConfig[NORDEM] == 2
	cDbSeek	 := aConfig[CFILDE] + aConfig[CCRACHADE] + DTOS(aConfig[DDTVISI])
	cInicio  := 'SPY->PY_FILIAL + SPY->PY_CRACHA + DTOS(SPY->PY_DTVISIT)'
	cFim     := aConfig[CFILATE] + aConfig[CCRACHAATE] + DTOS(aConfig[DDTVISF])
//-- Filial + Data Visita + Cracha
ElseIf 	aConfig[NORDEM] == 3
	cDbSeek	 := aConfig[CFILDE] + DTOS(aConfig[DDTVISI]) + aConfig[CCRACHADE] 
	cInicio  := 'SPY->PY_FILIAL + DTOS(SPY->PY_DTVISIT) + SPY->PY_CRACHA'
	cFim     := aConfig[CFILATE] + DTOS(aConfig[DDTVISF]) + aConfig[CCRACHAATE]
//-- Filial + Empresa + Data Visita
ElseIf 	aConfig[NORDEM] == 6
	cDbSeek	 := aConfig[CFILDE] + aConfig[CEMPDE] + DTOS(aConfig[DDTVISI])
	cInicio  := 'SPY->PY_FILIAL + SPY->PY_NOMEMP + DTOS(SPY->PY_DTVISIT)'
	cFim     := aConfig[CFILATE] + aConfig[CEMPATE] + DTOS(aConfig[DDTVISF])
Endif


#IFDEF TOP
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Seta apenas os Campos do SPY que serao Utilizados           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	nContField	:= Len(aTempSPY)   

	For nX := 1 To nContField
		aAdd( aStruSPY , aClone( aTempSPY[ nX ] ) )
	Next nX 
	
	aCposSPY	:=  NIL
	nLenStruSPY	:= Len( aStruSPY )
	cQuery := "SELECT "
	For nX := 1 To nLenStruSPY
		cQuery += aStruSPY[ nX , 1 ] + ", "
	Next nX
	cQuery := SubStr( cQuery , 1 , Len( cQuery ) - 2 )
	cQuery += "FROM "+RetSqlName('SPY')+" SPY "
	cQuery += "WHERE "
	cQuery += "SPY.PY_FILIAL>='" +aConfig[CFILDE     		] +"' AND "
	cQuery += "SPY.PY_FILIAL<='" +aConfig[CFILATE    		] +"' AND "
	cQuery += "SPY.PY_VISITA>='" +aConfig[CVISDE     		] +"' AND "
	cQuery += "SPY.PY_VISITA<='" +aConfig[CVISATE    		] +"' AND "  
    cQuery += "SPY.PY_DTVISIT>='"+Dtos(aConfig[DDTVISI    	])+"' AND "
    cQuery += "SPY.PY_DTVISIT<='"+Dtos(aConfig[DDTVISF   	])+"' AND "
	cQuery += "SPY.PY_CRACHA>='" +aConfig[CCRACHADE       	] +"' AND "
	cQuery += "SPY.PY_CRACHA<='" +aConfig[CCRACHAATE      	] +"' AND " 
  	cQuery += "SPY.PY_NOMEMP>='" +aConfig[CEMPDE          	] +"' AND "
	cQuery += "SPY.PY_NOMEMP<='" +aConfig[CEMPATE           ]+"'"
	cQuery += " AND SPY.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY "+SqlOrder( SPY->( IndexKey() ) )
	cQuery := ChangeQuery(cQuery)
	( dbSelectArea('SPY') , dbCloseArea() ) //Fecha o SPW para uso da Query
	IF ( lQueryOpened := MsOpenDbf(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQuery,.T.,.T.) )
		For nX := 1 To nLenStruSPY
			IF ( aStruSPY[nX,2] <> "C" )
			   	TcSetField(cAliasQuery,aStruSPY[nX,1],aStruSPY[nX,2],aStruSPY[nX,3],aStruSPY[nX,4])
			EndIF
		Next nX       
		
	Else        

		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Restaura Arquivo Padrao e Ordem                             ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		ChkFile( 'SPY' )
		SPY->( dbSetOrder( 	aConfig[NORDEM] ) )
	
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Procura e posiciona no primeiro Visitante.                  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		SPY->( MsSeek( cDbSeek , .T. ) )
	EndIF

#ELSE
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Procura e posiciona no primeiro funcion rio.                ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	SPY->( MsSeek( cDbSeek , .T. ) )
#ENDIF	



SetRegua(SPY->(RecCount())) //-- Inicializa R‚gua de Contagem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Looping no Arquivo de Funcion rios (SPW)                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

While SPY->( !Eof() .and. PY_FILIAL <= 	aConfig[CFILATE] .AND.  &cInicio <= cFim)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aborta o Calculo, caso seja pressionado Alt + B   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lEnd
		IMPR(cCancela,'C')
		Return Nil
	EndIF
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Incrementa a R‚gua de Impress„o							   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	SPY->(IncRegua())

	 //-- Verifica a quebra de Filial e atualiza o Gauge de Filial
	IF !( cLastFil == SPY->PY_FILIAL ) 
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Atualiza o Filial Anterior								   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		cLastFil := SPY->PY_FILIAL  
		 
		/*	
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Carrega as Filiais dos Arquivoss                             ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		cFilSPW 	:= xFilial("SPW", cLastFil)   
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Obtem Informacoes Empresa	      					     	   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
	Endif
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas				 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !(SPY->PY_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSPY)
	   SPY->(DbSkip())
       Loop
    EndIf

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Consiste filtro do intervalo De / Ate.                       ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	#IFNDEF TOP
    
		If  (SPY->PY_Filial	 	< aConfig[CFILDE          ]		) 			.Or. ( SPY->PY_Filial 			> aConfig[CFILATE         ]		) .Or. ;
		    (SPY->PY_NOMEMP  	< aConfig[CEMPDE          ]		) 			.Or. ( SPY->PY_NOMEMP 			> aConfig[CEMPATE         ]		) .Or. ;
			(SPY->PY_Visita 	< aConfig[CVISDE          ]		) 			.Or. ( SPY->PY_Visita 			> aConfig[CVISATE         ]		) .Or. ;
			(SPY->PY_Cracha 	< aConfig[CCRACHADE       ]		) 			.Or. ( SPY->PY_Cracha			> aConfig[CCRACHAATE      ]	) .Or. ;
			(SPY->(DTOS(PY_DtVisit)) 	< DTOS(aConfig[DDTVISI         ]) )	.Or. ( SPY->(DTOS(PY_DtVisit))	> DTOS(aConfig[DDTVISF    ])) 
		    SPY->(DbSkip())
			Loop
		Endif 
		

   	#ENDIF
       	
   	//-- Verifica Tipo de Visita
	If aConfig[CTPVIS] <> '3'
		If	SPY->PY_TIPOVIS <> aConfig[CTPVIS]  	
		    SPY->(DbSkip())
			Loop
		Endif	    
	Endif 
		
	//-- Verifica Horarios (ATENCAO: Nao Fazer Data + Horas)
	If	SPY->( PY_ENTRADA < aConfig[NHORDE] .OR. 	PY_ENTRADA    > aConfig[NHORATE] ) 
	    SPY->(DbSkip())
		Loop
	Endif
    
     //-- Zera Acumuladores 
	aVisitas	:=Array( 06 )  
	
   	//-- Obtem Dados da Etiqueta 

	SPY->( aVisitas[  1   ] 	:= PY_FILIAL	)	//01 - Filial
	SPY->( aVisitas[  2   ] 	:= PY_CRACHA	)	//02 - Cracha da Visita
	SPY->( aVisitas[  3   ] 	:= SUBSTR(ALLTRIM(PY_NOMEMP),1,30))	//03 - Nome da Empresa
    
    SPW->(DBSEEK(cFilSPW+SPY->PY_VISITA)) 
   	SPW->( aVisitas[  4	  ]	:= PW_VISITA  )				//04 - Codigo do Visitante
   	SPW->( aVisitas[  5	  ]	:= ALLTRIM(PW_NOMFULL) )	//05 - Nome do Funcionario
	SPW->( aVisitas[  6	  ]	:= PW_BITMAP	)			//06 - Nome da Foto 	

    //-- Imprime a Etiqueta
	fImpCracha(aVisitas, cLogoEmp , Nil, aConfig, @aFotos, lSalta) 
	nLin	:= aConfig[NETQIMPLINHA]
    nCol    := aConfig[NETQIMPCOLUNA]
    //-- Calcula Nova Posicao da Etiqueta
	fEtqPosicao( nMaxCol, nMaxLin, @nCol, @nLin)

	//-- Atualiza a Posicao da Proxima Etiqueta a Ser Impressa
	aConfig[NETQIMPLINHA]	:= nLin
	aConfig[NETQIMPCOLUNA]	:= nCol       	
	
	lSalta:=( nLin == 1 .AND. nCol == 1 )
	
	//-- Obtem Proximo Visitante
    SPY->(DbSkip())

End While
                            

#IFDEF TOP
	( dbSelectArea( 'SPY' ) , dbCloseArea() , ChkFile( 'SPY' ) ) //Restaura o SPY Padrao
#ENDIF

RestArea( aAreaSPY ) 



Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fLogoEmp  ºAutor  ³RH - Natie          º Data ³  02/18/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fLogoEmp( cLogo,cTipo)
Local  cStartPath	:= GetSrvProfString("Startpath","")
Default cTipo 	:= "1"

//-- Logotipo da Empresa
If cTipo =="1"
	cLogo := cStartPath + "LGRL"+SM0->M0_CODIGO+FWGETCODFILIAL+".BMP" 	// Empresa+Filial
	If !File( cLogo )
		cLogo := cStartPath + "LGRL"+SM0->M0_CODIGO+".BMP" 				// Empresa
	endif
Else		
	cLogo := cStartPath + "LogoSiga.bmp"
Endif

Return




