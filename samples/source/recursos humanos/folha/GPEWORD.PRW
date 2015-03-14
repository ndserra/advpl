#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "MSOLE.CH"
#INCLUDE "GPEWORD.CH"

//зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
//ЁPrograma  Ё GpeWord  Ё Autor ЁMarinaldo de Jesus     Ё Data Ё05/07/2000Ё
//цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
//ЁDescri┤└o Ё Impressao de Documentos tipo Word                          Ё
//цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//ЁSintaxe   Ё Chamada padr└o para programas em RdMake.                   Ё
//цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//ЁUso       Ё Generico                                                   Ё
//цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//ЁObs.:     Ё                                                            Ё
//цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//Ё         ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL.             Ё
//цддддддддддддбддддддддддбддддддбдддддддддддддддддддддддддддддддддддддддд╢
//ЁProgramador ЁData      Ё BOPS ЁMotivo da Alteracao                     Ё
//цддддддддддддеддддддддддеддддддедддддддддддддддддддддддддддддддддддддддд╢
//Ё            Ё23/05/2002Ё      ЁInicial.nDepen qdo impr.variaveis       Ё
//Ё            Ё06/01/2003Ё------ЁBuscar o codigo CBO no cadastro funcoes Ё
//Ё            Ё          Ё------Ёde acordo com os novos codigos CBO/2002.Ё
//Ё            Ё28/04/2003|------|Incl.de Variaveis novas no Array aExp.  Ё
//Ё            Ё          Ё------|Alteracao na perg.Verific.Dependente, naЁ
//Ё            Ё          Ё------|Perg.Funcao(tamanho)e Ordem de Impress. Ё
//Ё            Ё          Ё------|para imprimir por Ordem de Dt. Admissao.Ё
//Ё            Ё          Ё061017ЁAjuste na varialvel CGC p/ trazer corre Ё
//Ё            Ё          Ё      Ёtamente o numero do CGC c/ 14 dig.      Ё
//ЁPedro Eloy  Ё27/11/03  Ё067893Ёretirada o tratamento da foto.          Ё
//ЁEmerson     Ё14/06/04  Ё072134|Tratar impressao da categoria Prof. "J".Ё
//ЁRicardo D.  Ё01/02/05  Ё075835|Tratar a impressao do documento buscandoЁ
//Ё            Ё          Ё      Ёo modelo a partir do rootpath. Ajuste noЁ
//Ё            Ё          Ё      Ёtamanho maximo do caminho+nome do modeloЁ
//Ё            Ё          Ё      Ёpara 60 caracteres.                     Ё
//Ё            Ё22/03/05  Ё075835|Ajuste na exclusao do arq.temporario p/ Ё
//Ё            Ё          Ё      Ёsomente quando a impressao for a partir Ё
//Ё            Ё          Ё      Ёdo servidor.                            Ё
//ЁAndreia     Ё14/07/06  Ё101032|Criacao do campo "RA_MUNNASC" para ser  Ё
//Ё            Ё          Ё      Ёutilizado na impressao do Cadastro do   Ё
//Ё            Ё          Ё      ЁTrabalhador(gpecadPis).                 Ё
//ЁAndreia     Ё06/09/06  Ё105588|Criacao da variavel "GPE_NOMECMP" para  Ё
//Ё            Ё          Ё      Ёguardar o conteudo do campo RA_NOMECMP. Ё
//ЁNatie       Ё24/11/06  Ё114085ЁTestar o campo RA_NOMECMP               Ё
//ЁPedro Eloy  Ё26/04/07  Ё123899Ёtratamento para compor os espacos no SX1Ё
//ЁAdemar Jr.  Ё05/11/07  Ё125744ЁVerifica se o Remote eh Linux e apresen-Ё
//Ё            Ё          Ё      Ёta Mensagem de Alerta.                  Ё
//ЁTania       Ё13/06/2008ЁProj. ЁIncluidos novos campos para impressao   Ё
//Ё            Ё          ЁMexicoЁqdo for Mexico.                         Ё
//ЁRenata      Ё03/07/08  Ё147857|Ajuste na funcao fOpen_Word(), alterandoЁ
//Ё            Ё          Ё      Ёpara static funtion  				      Ё
//ЁMarcos Kato Ё17/07/08  |150176ЁCorrigido a funcao Aviso(STR0012 ,      Ё
//Ё            Ё          Ё      Ё{ STR0010 } ) adicionando a virgula que Ё
//Ё            Ё          Ё      |estava faltando alem de incluir o STR.  Ё
//Ё            Ё          Ё      |EX:Aviso(STR0012 ,STR0007,{ STR0010 } ) Ё   
//Ё            Ё          Ё      |Incluido espacos em branco no DBSEEK do Ё   
//Ё            Ё          Ё      |SX1 referente a ordem 25.Motivo: O campoЁ  
//Ё            Ё          Ё      |do cperg tem que possuir tam 10 e nao 6.Ё  
//Ё            Ё          Ё      |para encontrar o registro.              Ё
//ЁLeandro Dr. Ё08/09/08  Ё153457|Retirado espacos do DbSeek do SX1 ref. aЁ
//Ё            Ё          Ё      Ёordem 25. Motivo: Ja foi incluido       |
//Ё            Ё          Ё      Ёespacos na cPerg com a funcao Space.    |
//ЁMarcelo     Ё18/09/08  Ё152602|Ajuste na funcao GpeWord() para avaliar Ё
//Ё            Ё          Ё      Ёo conteudo gravado no profile e bloquearЁ
//Ё            Ё          Ё      Ёfull path maior que 75 caracteres.      Ё
//ЁMauricio T. Ё11/10/08  Ё------|Correcao do nome do campo RA_FECREI da  Ё
//Ё            Ё          Ё      Ёlista de campos.                        Ё
//ЁAbel RibeiroЁ06/09/09  Ё011342ЁCriacao Funcao fpesqfer() para armazenarЁ
//Ё            Ё          Ё      ЁDt.Per.Inicio Ferias e Dt.Per.Fim FeriasЁ
//Ё            Ё          Ё      Ёe criado novas variaveis                Ё  
//Ё            Ё          Ё      ЁGPE_DIA_INIFERIAS,GPE_MES_INIFERIAS     Ё
//Ё            Ё          Ё      ЁGPE_ANO_INIFERIAS,GPE_DIA_FIMFERIAS     Ё
//Ё            Ё          Ё      ЁGPE_MES_FIMFERIAS,GPE_ANO_FIMFERIAS     Ё
//Ё            Ё          Ё      Ёespecifico para Colombia.               Ё
//ЁAlex        Ё24/07/09  Ё      ЁAjuste do Campo Filial no Grupo de      Ё
//Ё            Ё          Ё      ЁCampos                                  Ё
//ЁTiago Malta Ё01/12/09  Ё028007ЁCriado as variАveis (GPE_BIDENT,        Ё
//Ё            Ё          Ё      Ё GPE_BIEMISS e GPE_DESC_EST_CIV ) para  Ё
//Ё            Ё          Ё      Ё localizaГЦo Angola.                    Ё  
//ЁTiago Malta Ё02/02/10  Ё004074ЁAlterado para angola a variavel         Ё
//Ё            Ё          Ё  2010Ё GPE_ESTADO.                            Ё
//ЁErika K.    Ё16/06/10  Ё013196ЁAlteracoes para possibilitar geracao pa-Ё
//Ё            Ё          Ё  2010Ёra localizacao Peru.                    Ё
//ЁTania       Ё04/08/2010Ё16698/ЁInclusao FieldPos para o campo RA_DEPSF.Ё
//Ё            Ё          Ё2010  Ё                                        Ё
//ЁEmerson CampЁ27/12/2010Ё28320/ЁAjuste para nova interface 11. Com a    Ё
//Ё            Ё          Ё2010  ЁaplicaГЦo do parametro MV_ECMFTPP que   Ё
//Ё            Ё          Ё      Ёafirma ser a versЦo 11.5 do Protheus    Ё 
//ЁAlessandro  Ё18/03/11  Ё006427ЁTratamento de novas funcionalidades p/ oЁ
//ЁSantos      Ё          Ё  2011Ёcalculo de professores.                 Ё
//ЁAldo Marini Ё22/08/2011Ё017723ЁAlteracao efetuada para prever impressaoЁ
//Ё            ЁTDJEMN    Ё  2011Ёde duas linhas para as descricoes  das  Ё
//Ё            Ё          Ё      Ёvariaveis do word.                      Ё
//ЁFlor Monroy Ё15/09/11  Ё024225ЁInclusao de novos campos para a Costa   Ё
//ЁHUB-MИxico  Ё          Ё  2011ЁRica.                                   Ё
//ЁR.Berti     Ё11/11/11  ЁTDZU16ЁAjusta help da perg. "Nome Ate".		  Ё
//ЁEmerson CampЁ06/02/2012Ё01453/ЁRemocao dos campos RA_ANOCHEG, VCTOEXP, Ё
//Ё            Ё          Ё  2012ЁEXAMEDI e ANTEAUM para a localizaГЦo do Ё
//Ё            Ё          ЁTEJJAAЁEquador.								  Ё
//ЁFabio G.    Ё07/03/2012ЁTEQGK3ЁAjuste do campo RA_RGUF para integracao Ё
//Ё            Ё  		  Ё		 Ёcom Word.								  Ё
//ЁLeandro Dr. Ё14/05/12  ЁTEZVE4ЁInclusao de campos para preenchimento doЁ
//Ё     	   Ё 		  Ё		 Ёnovo Cadastro NIS da CEF.				  Ё
//ЁEmerson CampЁ21/05/2012ЁREQ182ЁRemov. o campo VAM de dentro dos campos Ё
//Ё     	   Ё 		  Ё		 Ёdispon Costa Rica e disponibilizado  CC2Ё
//Ё            Ё  		  Ё		 Ёp todos os paises a partir do release R7Ё
//Ё            Ё  		  Ё		 Ёe COS e DOM na release anterior		  Ё
//ЁRaquel HagerЁ05/07/2012ЁTEQYKFЁCorrecao para captura correta do valor  Ё
//Ё     	   Ё 		  Ё		 Ёdo campo a ser utilizado na func. fDesc.Ё
//ЁAllyson M   Ё01/08/2012ЁTFKW36ЁInclusao de campos da segunda data de   Ё
//Ё     	   Ё 		  Ё		 Ёexperiencia.				 			  Ё
//ЁFabio G.    Ё18/12/2012ЁTGGIZDЁAjuste para integracao do Word aceitar  Ё
//Ё     	   Ё 		  Ё		 Ёarquivos de Entrada com extensao ".DOTX"Ё
//ЁClaudinei S.Ё20/12/2012ЁTFWBGYЁCriacao de 53 variaveis para o DCN/DMN  Ё
//Ё     	   Ё 		  Ё      Ёdo NIS-PIS e novo pergunte MV_PAR30     Ё
//ЁClaudinei S.Ё26/12/2012ЁTFWBGYЁInclusao de validaГЦo da execucao do    Ё
//Ё     	   Ё 		  Ё      Ёcompatibilizador opcao 206              Ё
//ЁM. Silveira Ё27/12/2012ЁTGGEUBЁNovas variaveis p/ Localidade de Pagto. Ё
//ЁClaudinei S.Ё25/02/2013ЁTGQQC3ЁDeclaracao da fOpTipPis() como Static.  Ё
//ЁAdilson     Ё22/04/2013ЁTHBKCEЁAcerto no controle de uso da tabela CC2 Ё
//ЁSilva	   Ё 		  Ё      Ёpara localizacao Argentina.             Ё
//юддддддддддддаддддддддддаддддддадддддддддддддддддддддддддддддддддддддддды

User Function GpeWord()

Local   cCampo  := ""
Local	oDlg	:= NIL  
Local cMsgDic		:= ""					//Mensagem para validacao de dicionario de dados
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё DeclaraГЦo de arrays para dimensionar tela		                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local aGDCoord		:= {}

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Valida necessidade de execucao do update para alterar a ordemЁ
Ё e o valid dos campos RCJ_DIACAL e RCJ_DIAPRO.	               Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
If ! fValSX3SRA()
	Aviso( STR0238, STR0239, { STR0240 } ) // "AtenГЦo"## "Execute a opГЦo do compatibilizador referente ao 'DisponibilizaГЦo dos campos RA_HABILIT e RA_COMPLEM para o Equador'. Para maiores informaГУes, verifique respectivo Boletim TИcnico." ## "OK"
	Return
EndIf

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Valida necessidade de execucao do update para criacao dos    Ё
Ё campos do pis na SRA opcao 206.	                           Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/  
fChkUpd( @cMsgDic )
If !Empty(cMsgDic)
	MsgAlert( cMsgDic ) 
	Return()
EndIf

Private	cPerg	:= "GPWORD"
Private aInfo	:= {}
Private aDepenIR:= {}
Private aDepenSF:= {}
Private aPerSRF := {}
Private nDepen	:= 0
Private lDepSf	:= Iif(SRA->(FieldPos("RA_DEPSF"))>0,.T.,.F.)
//tratando os espacos do novo tamanho do X1_GRUPO
cPerg	:= cPerg + (Space( Len(SX1->X1_GRUPO)  - Len(cPerg) ) )

AjustaSX1()  //Ajusta Perguntas

Pergunte(cPerg,.F.)
     
OpenProfile()
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁAvalia o conteudo ja existente no profile e o altera se necessario   Ё
//Ёpara que o erro nao ocorra apos a atualizacao do sistema.            Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If ( ProfAlias->( DbSeek( SM0->M0_CODIGO + Padl( CUSERNAME, 13 ) + "GPWORD    ") ) )
	cCampo := SubStr( AllTrim( ProfAlias->P_DEFS ), 487, 75 )
	If !( ".DOT" $ UPPER( cCampo ) )
		RecLock( "ProfAlias", .F. )
		ProfAlias->P_DEFS := ""
		ProfAlias->( MsUnLock() )
	EndIf
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё         Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Monta as Dimensoes dos Objetos         					   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
aAdvSize		:= MsAdvSize()
aAdvSize[5]	:=	(aAdvSize[5]/100) * 60	//horizontal
aAdvSize[6]	:=  (aAdvSize[6]/100) * 40	//Vertical
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize	:= MsObjSize( aInfoAdvSize , aObjCoords )
aGdCoord	:= { (aObjSize[1,1]+3), (aObjSize[1,2]+5), (((aObjSize[1,3])/100)*20), (((aObjSize[1,4])/100)*59) }	//1,3 Vertical /1,4 Horizontal

DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0001) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL  
	
	@ aGdCoord[1],aGdCoord[2] TO aGdCoord[3],aGdCoord[4] PIXEL
	@ aGdCoord[1]+10,aGdCoord[2]+10 SAY OemToAnsi(STR0002) PIXEL						 												
	@ aGdCoord[1]+20,aGdCoord[2]+10 SAY OemToAnsi(STR0003) PIXEL

	@ (((aObjSize[1,3])/100)*25),(aGdCoord[4]/2)-95 BMPBUTTON TYPE 5 ACTION Eval( { || fPerg_Word() , Pergunte(cPerg,.T.) } )	
		
	@ (((aObjSize[1,3])/100)*25),(aGdCoord[4]/2)-60 BUTTON OemToAnsi(STR0004) SIZE 55,11 ACTION Eval( { || fPerg_Word() , (ndepen:= 0,fVarW_Imp() ) }  )      
	@ (((aObjSize[1,3])/100)*25),(aGdCoord[4]/2)+5 BUTTON OemToAnsi(STR0005) SIZE 55,11 ACTION Eval( { || fPerg_Word() , fWord_Imp() } )
	     
	@ (((aObjSize[1,3])/100)*25),(aGdCoord[4]/2)+70 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return( NIL )

/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁfWord_Imp Ё Autor ЁMarinaldo de Jesus     Ё Data Ё05/07/2000Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁImpressao do Documento Word                                 Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function fWord_Imp()

/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁDefinindo Variaveis Locais                                             Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Local oWord			:= NIL
Local cExclui		:= ""
Local cFilAnt   	:= Space(FWGETTAMFILIAL)
Local aCampos		:= {}
Local nX			:= 0
Local nSvOrdem		:= 0
Local nSvRecno		:= 0
Local cAcessaSRA	:= &( " { || " + ChkRH( "GPEWORD" , "SRA" , "2" ) + " } " )

/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁCarregando mv_par para Variaveis Locais do Programa                    Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Local cFilDe		:= mv_par01
Local cFilAte		:= mv_par02
Local cCcDe			:= mv_par03
Local cCcAte		:= mv_par04
Local cMatDe		:= mv_par05
Local cMatAte		:= mv_par06
Local cNomeDe		:= mv_par07
Local cNomeAte		:= mv_par08
Local cTnoDe		:= mv_par09
Local cTnoAte		:= mv_par10
Local cFunDe		:= mv_par11
Local cFunAte		:= mv_par12
Local cSindDe		:= mv_par13
Local cSindAte		:= mv_par14
Local dAdmiDe		:= mv_par15
Local dAdmiAte		:= mv_par16
Local cSituacao		:= mv_par17
Local cCategoria	:= mv_par18
Local nCopias		:= If ( Empty(mv_par23),1,mv_par23 )
Local nOrdem		:= mv_par24
Local cArqWord		:= mv_par25
Local cAux			:= ""
Local cPath 		:= GETTEMPPATH()
Local nAt			:= 0
Local lDepende		:= If (Mv_par26 = 1, .T., .F.)
Local nDepende  	:= mv_par27
Local lImpress      := ( mv_par28 == 1 )
Local cArqSaida     := AllTrim( mv_par29 )
nDepen				:= If ( ! lDepende, 4,nDepende )

//?-Checa o SO do Remote (1=Windows, 2=Linux)
If GetRemoteType() == 2
	MsgAlert(OemToAnsi(STR0167), OemToAnsi(STR0168))	//?-"IntegraГЦo Word funciona somente com Windows !!!")###"AtenГЦo !"
	Return	
EndIf
/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁVerifica se o usuario escolheu um drive local (A: C: D:) caso contrarioЁ
Ёbusca o nome do arquivo de modelo,  copia para o diretorio temporario  Ё
Ёdo windows e ajusta o caminho completo do arquivo a ser impresso.      Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
If substr(cArqWord,2,1) <> ":"
	cAux 	:= cArqWord
	nAT		:= 1
	for nx := 1 to len(cArqWord)
		cAux := substr(cAux,If(nx==1,nAt,nAt+1),len(cAux))
		nAt := at("\",cAux)
		If nAt == 0
			Exit
		Endif
	next nx
	CpyS2T(cArqWord,cPath, .T.)
	cArqWord	:= cPath+cAux
Endif
/*
зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁBloco que definira a Consistencia da Parametrizacao dos Intervalos seleЁ
Ёcionados nas Perguntas De? Ate?.                                       Ё
юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
cExclui := cExclui + "{ || "
cExclui := cExclui + "(RA_FILIAL  < cFilDe     .or. RA_FILIAL  > cFilAte    ).or."
cExclui := cExclui + "(RA_MAT     < cMatDe     .or. RA_MAT     > cMatAte    ).or." 
cExclui := cExclui + "(RA_CC      < cCcDe      .or. RA_CC      > cCCAte     ).or." 
cExclui := cExclui + "(RA_NOME    < cNomeDe    .or. RA_NOME    > cNomeAte   ).or." 
cExclui := cExclui + "(RA_TNOTRAB < cTnoDe     .or. RA_TNOTRAB > cTnoAte    ).or." 
cExclui := cExclui + "(RA_CODFUNC < cFunDe     .or. RA_CODFUNC > cFunAte    ).or." 
cExclui := cExclui + "(RA_SINDICA < cSindDe    .or. RA_SINDICA > cSindAte   ).or." 
cExclui := cExclui + "(RA_ADMISSA < dAdmiDe    .or. RA_ADMISSA > dAdmiAte   ).or." 
cExclui := cExclui + "!(RA_SITFOLH$cSituacao).or.!(RA_CATFUNC$cCategoria)"
cExclui := cExclui + " } "

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁInicializa o Ole com o MS-Word 97 ( 8.0 )						      Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oWord	:= OLE_CreateLink() ; OLE_NewFile( oWord , cArqWord )

dbSelectArea("SRB")
nSBOrdem := IndexOrd() ; nSBRecno := Recno()
dbGotop()

dbSelectArea("SRA")
nSvOrdem := IndexOrd() ; nSvRecno := Recno()
dbGotop()


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Posicionando no Primeiro Registro do Parametro               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
IF nOrdem == 1	   							//Matricula
	dbSetOrder(nOrdem)
	dbSeek( cFilDe + cMatDe , .T. )
	cInicio := '{ || RA_FILIAL + RA_MAT }'
	cFim    := cFilAte + cMatAte
ElseIF nOrdem == 2							//Centro de Custo
	dbSetOrder(nOrdem)
	dbSeek( cFilDe + cCcDe + cMatDe , .T. )
	cInicio  := '{ || RA_FILIAL + RA_CC + RA_MAT }'
	cFim     := cFilAte + cCcAte + cMatAte
ElseIF nOrdem == 3							//Nome 
	dbSetOrder(nOrdem)
	dbSeek( cFilDe + cNomeDe + cMatDe , .T. )
	cInicio := '{ || RA_FILIAL + RA_NOME + RA_MAT }'
	cFim    := cFilAte + cNomeAte + cMatAte
ElseIF nOrdem == 4							//Turno
	dbSetOrder(nOrdem)
	dbSeek( cFilDe + cTnoDe ,.T. )
	cInicio  := '{ || RA_FILIAL + RA_TNOTRAB } '
	cFim     := cFilAte + cCcAte + cNomeAte
ElseIF nOrdem == 5							//Admissao
	cIndCond:= "RA_FILIAL + DTOS (RA_ADMISSA)"
   	cArqNtx  := CriaTrab(Nil,.F.)
   	IndRegua("SRA",cArqNtx,cIndCond,,,STR0162)		//"Selecionando Registros..."
	dbSeek( cFilDe + DTOS(dAdmiDe) ,.T. )
	cInicio  :='{ || RA_FILIAL + DTOS(RA_ADMISSA)}' 
	cFim     := cFilAte + DTOS(dAdmiAte)
EndIF

cFilialAnt := Space(FWGETTAMFILIAL)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ira Executar Enquanto Estiver dentro do Escopo dos ParametrosЁ
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
While SRA->( !Eof() .and. Eval( &(cInicio) ) <= cFim )
//    здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//    Ё Consiste Parametrizacao do Intervalo de Impressao            Ё
//    юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		IF SRA->( Eval ( &(cExclui) ) )
	       dbSelectArea("SRA")
	       dbSkip()
	       Loop
	    EndIF
	    
//	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//	ЁConsiste Filiais e Acessos                                             Ё
//	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	IF !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
		dbSelectArea("SRA")
      		dbSkip()
       		Loop
	EndIF 
	
//	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©	
//  ЁConsiste os dependentes  de Salario Familia                            Ё
//	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lDepende
		If nDepende == 1 //Salario Familia //
//			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
// 		    ЁConsiste os dependentes  de Salario Familia                            Ё
//			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))         
		    	fDepSF( )
			Else
				SRA->(dbSkip())
				Loop
			Endif		
		ElseIf nDepende == 2 //Imposto de Renda	//
//			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
// 		    ЁConsiste os dependentes  de Imposto de Renda                           Ё
// 		    юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
   			If SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))
	    		fDepIR( )
	    	Else
				SRA->(dbSkip())
				Loop
			Endif	
		ElseIf nDepende == 3 // Todos os Tipos de Dependente (Salario Familia e Imposto de Renda //
//			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
// 		    ЁConsiste todos os tipos de Dependentes                            Ё
//			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   			If SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))         
	       		fDepIR( )
	       	Else
				SRA->(dbSkip())
				Loop
			Endif
			If SRB->(dbSeek(SRA->RA_Filial+SRA->RA_Mat,.F.))         
	    		fDepSF( )
	    	Else                                                                         
				SRA->(dbSkip())
				Loop
			Endif	
		Endif
	
		If (nDepende == 1)
			If  empty(aDepenSF[1,1])
				SRA->(dbSkip())
				Loop
			Endif	
		ElseIf	(nDepende == 2)
			If  empty(aDepenIR[1,1])
				SRA->(dbSkip())
				Loop
			Endif	          
		ElseIf	(nDepende == 3)
			If  empty(aDepenIR[1,1])  .and. empty(aDepenSF[1,1])
				SRA->(dbSkip())
				Loop
			EndIf
		Endif	                                                          
	Endif			
	If cPaisLoc == "COL"
	   fPesqSRF( )                  //Busca Periodo Aquisitivo para Colombia
	Endif   

//  здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//  Ё Carregando Informacoes da Empresa                            Ё
//  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		IF SRA->RA_FILIAL # cFilialAnt
			IF !fInfo(@aInfo,SRA->RA_FILIAL)
//   		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//	        Ё Encerra o Loop se Nao Carregar Informacoes da Empresa        Ё
//     		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				Exit
			EndIF			
// 		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//      Ё Atualiza a Variavel cFilialAnt                               Ё
// 		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			dbSelectArea("SRA")
			cFilialAnt := SRA->RA_FILIAL
		EndIF	
//	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//  Ё Carrega Campos Disponiveis para Edicao                       Ё
//	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		aCampos := fCpos_Word()
   
//	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//  Ё Ajustando as Variaveis do Documento                          Ё
//	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		Aeval(	aCampos																								,; 
				{ |x| OLE_SetDocumentVar( oWord, x[1]  																,;
											IF( Subst( AllTrim( x[3] ) , 4 , 2 )  == "->"          					,; 
												Transform( x[2] , PesqPict( Subst( AllTrim( x[3] ) , 1 , 3 )		,;
																			Subst( AllTrim( x[3] )  				,;
										        			         			  - ( Len( AllTrim( x[3] ) ) - 5 )	 ;	
										          								 )	  	 							 ; 
																	      )                                          ;
												         )															,; 
												Transform( x[2] , x[3] )                                     		 ;
				  	 						  ) 														 	 		 ; 
										)																			 ;
				}     																 							 	 ;
			 )
        	
//		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//      Ё Atualiza as Variaveis                                        Ё
// 		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
        OLE_UpDateFields( oWord )

//	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//	ЁImprimindo o Documento                                                 Ё
//	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		IF lImpress
			For nX := 1 To nCopias
				OLE_SetProperty( oWord, '208', .F. ) ; OLE_PrintFile( oWord )
			Next nX
		Else
			OLE_SaveAsFile( oWord, cArqSaida )
		EndIF
		
		dbSelectArea("SRA")                                               
        dbSkip()
        //Iniciliaza array 
        aDepenIR:= {}
        aDepenSF:= {}
        aPerSRF := {}
Enddo	
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁEncerrando o Link com o Documento                                      Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
OLE_CloseLink( oWord )
If Len(cAux) > 0
	fErase(carqword)
Endif
 
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁRestaurando dados de Entrada                                           Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea('SRA')
dbSetOrder( nSvOrdem )
dbGoTo( nSvRecno )

Return( NIL )

//зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
//ЁFun┤фo    ЁfOpen_WordЁ Autor Ё Marinaldo de Jesus    Ё Data Ё06/05/2000Ё
//цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
//ЁDescri┤фo ЁSelecionaro os Arquivos do Word.                            Ё
//юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function fOpen_Word()                                                   		

Local cSvAlias		:= Alias()
Local lAchou		:= .F.
Local cTipo			:= STR0006														
Local cNewPathArq	:= cGetFile( cTipo , STR0007 )									

IF !Empty( cNewPathArq )
	IF Len( cNewPathArq ) > 75
    	MsgAlert( STR0187 ) //"O endereco completo do local onde estА o arquivo do Word excedeu o limite de 75 caracteres!"
    	Return			
	Else
		IF  Upper( Subst( AllTrim( cNewPathArq ), - 3 ) ) == Upper( AllTrim( STR0008 ) ) 
			Aviso( STR0009 , cNewPathArq , { STR0010 } )								
	    ElseIf	Upper( Subst( AllTrim( cNewPathArq ), - 4 ) ) == Upper( AllTrim( STR0294 ) )	
				Aviso( STR0009 , cNewPathArq , { STR0010 } )								
	    Else
	    	MsgAlert( STR0011 )															
	    	Return
	    EndIf
	EndIf
Else
    Aviso(STR0012 ,STR0007,{ STR0010 } )//Aviso(STR0012 ,{ STR0010 } )													
    Return
EndIF
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁLimpa o parametro para a Carga do Novo Arquivo                         Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("SX1")  
IF lAchou := ( SX1->( dbSeek( cPerg + "25" , .T. ) ) )
	RecLock("SX1",.F.,.T.)
	SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
	mv_par25 := cNewPathArq
	MsUnLock()
EndIF	
dbSelectArea( cSvAlias )
Return(.T.)


//зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
//ЁFun┤фo    ЁfVarW_Imp Ё Autor Ё Marinaldo de Jesus    Ё Data Ё07/05/2000Ё
//цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
//ЁDescri┤фo ЁImpressao das Variaveis disponiveis para uso                Ё
//юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function fVarW_Imp()

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Define Variaveis Locais                                      Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Local cString	:= 'SRA'                                	     
Local aOrd		:= {STR0142,STR0143}
Local cDesc1	:= STR0144
Local cDesc2	:= STR0145                     
Local cDesc3	:= STR0146                                
Local Tamanho	:= "P"

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Define Variaveis Privates Basicas                            Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Private nomeprog	:= 'GPEWORD'
Private AT_PRG		:= nomeProg
Private aReturn		:= {STR0147, 1,STR0148, 2, 2, 1, '',1 }
Private wCabec0		:= 1
Private wCabec1		:= STR0149
Private wCabec2		:= ""
Private wCabec3		:= ""
Private nTamanho	:= "P"
Private lEnd		:= .F.
Private Titulo		:= cDesc1
Private Li			:= 0
Private ContFl		:= 1
Private cBtxt		:= ""
Private aLinha		:= {}
Private nLastKey	:= 0

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Envia controle para a funcao SETPRINT                        Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
WnRel := "WORD_VAR" 
WnRel := SetPrint(cString,Wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho,,.F.)

IF nLastKey == 27
	Return( NIL )
EndIF

SetDefault(aReturn,cString)

IF nLastKey == 27
	Return( NIL )
EndIF

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Chamada do Relatorio.                                        Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
RptStatus( { |lEnd| fImpVar() } , Titulo )

Return( NIL )

/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤фo    ЁfImpVar   Ё Autor Ё Marinaldo de Jesus    Ё Data Ё07/05/2000Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤фo ЁImpressao das Variaveis disponiveis para uso                Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function fImpVar()

Local nOrdem	:= aReturn[8]
Local aCampos	:= {}
Local nX		:= 0
Local cDetalhe	:= ""
Local cDescr	:= ""

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Carregando Informacoes da Empresa                            Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/ 
IF !fInfo(@aInfo,xFilial("SRA"))
	Return( NIL )
EndIF			

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Carregando Variaveis                                         Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/ 
aCampos := fCpos_Word()

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Ordena aCampos de Acordo com a Ordem Selecionada             Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/        
IF nOrdem = 1
	aSort( aCampos , , , { |x,y| x[1] < y[1] } )
Else
	aSort( aCampos , , , { |x,y| x[4] < y[4] } )
EndIF

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Carrega Regua de Processamento                               Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/        
SetRegua( Len( aCampos ) )

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Impressao do Relatorio                                       Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/        
For nX := 1 To Len( aCampos )

        /*
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Movimenta Regua Processamento                                Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/        
        IncRegua()  

        /*
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Cancela Impresфo                                             Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
        IF lEnd
           @ Prow()+1,0 PSAY cCancel
           Exit
        EndIF            

		/*
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Mascara do Relatorio                                         Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
        //        10        20        30        40        50        60        70        80
        //12345678901234567890123456789012345678901234567890123456789012345678901234567890
		//Variaveis                      Descricao
		//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

		/*
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Carregando Variavel de Impressao                             Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
		cDescr := AllTrim( aCampos[nX,4] )

      	/*
        здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё Imprimindo Relatorio                                         Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
        Impr( Padr(aCampos[nX,1],31) + Left(cDescr,50) )
        
		If Len(cDescr) > 50
	        Impr( Space(31) + SubStr(cDescr,51,50) )
		Endif        

		If Len(cDescr) > 100
	        Impr( Space(31) + SubStr(cDescr,101,50) )
		Endif        

Next nX

IF aReturn[5] == 1
   Set Printer To
   dbCommit()
   OurSpool(WnRel)
EndIF
//--APAGA OS INDICES TEMPORARIOS--//
If nOrdem == 5
	fErase( cArqNtx + OrdBagExt() )
Endif                      

MS_FLUSH()

Return( NIL )

/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁfPerg_WordЁ Autor ЁMarinaldo de Jesus     Ё Data Ё05/07/2000Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁGrava as Perguntas utilizadas no Programa no SX1            Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function fPerg_Word()

Local aArea		:= getarea()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ajusta o tamanho da pergunta 25 - Arquivo do Word            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbselectarea("SX1")
If dbseek(cPerg+"25") .And. SX1->X1_TAMANHO <> 75
	Reclock("SX1",.f.)
	SX1->X1_TAMANHO		:= 75
	MsUnlock()
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Retorna para a area corrente.                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
restarea(aArea)

Return( Nil )

/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁfDepIR    Ё Autor ЁR.H.                   Ё Data Ё02/04/2001Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁCarrega Dependentes de Imp. de Renda                        Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/                                                                                                                                                  
Static Function fDepIR( )
Local Nx,nVezes
	/*
	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁConsiste os dependentes  de I.R.                                       Ё
	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	aDepenIR:= {}
	Do  while SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		If  (SRB->RB_TipIr == '1') .Or.;
         	(SRB->RB_TipIr == '2' .And. Year(dDataBase)-Year(SRB->RB_DtNasc) <= 21) .Or. ;
            (SRB->RB_TipIr == '3' .And. Year(dDataBase)-Year(SRB->RB_DtNasc) <= 24)
			//	Nome do Depend., Dta Nascimento,Grau de parentesco
      		aAdd(aDepenIR,{left(SRB->RB_Nome,30),SRB->RB_DtNasc,If(SRB->RB_GrauPar=='C','Conjuge   ',If(SRB->RB_GrauPar=='F','Filho     ','Outros    '))   })
        EndIf
        SRB->(dbSkip())
	EndDo 
	If  Len(aDepenIR) < 10
      	nVezes := (10 - Len(aDepenIR))
		For Nx := 1 to nVezes
			 aAdd(aDepenIR,{Space(30),Space(10),Space(10) } )
		Next Nx
	EndIf
Return(aDepenIR)

/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁfDepSF    Ё Autor ЁR.H.                   Ё Data Ё02/04/2001Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁCarrega Dependentes de Salario Familia                      Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function  fDepSF()
Local Nx,nVezes
	/*
	зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁConsiste os dependentes  de I.R.                                       Ё
	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	aDepenSF:= {}
   	Do While SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		If (SRB->RB_TipSf == '1') .Or. (SRB->RB_TipSf == '2' .And. ;
			Year(dDAtABase) - Year(SRB->RB_DtNasc) <= 14)
			//Nome do Depend., Dta Nascimento,Grau Parent.,Local Nascimento,Cartorio,Numero Regr.,Numero do Livro, Numero da Folha, Data Entrega,Data baixa. //
      		aAdd(aDepenSF,{left(SRB->RB_Nome,30),SRB->RB_DtNasc,If(SRB->RB_GrauPar=='C','Conjuge   ',If(SRB->RB_GrauPar=='F','Filho     ','Outros    ')),;
      						SRB->RB_LOCNASC,SRB->RB_CARTORI,SRB->RB_NREGCAR,SRB->RB_NUMLIVR,SRB->RB_NUMFOLH,SRB->RB_DTENTRA,SRB->RB_DTBAIXA})
		EndIf
		SRB->(dbSkip())
	Enddo
   	If  Len(aDepenSF) < 10
      	nVezes := (10 - Len(aDepenSF))
		For Nx := 1 to nVezes
			 aAdd(aDepenSF,{Space(30),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10),Space(10) } )
		Next Nx
	EndIf

Return(aDepenSF)
/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁfPesqSRF  Ё Autor ЁR.H.                   Ё Data Ё05/01/2009Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁCarrega Periodo Aquisitivo SRF                              Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function  fPesqSRF()
Local cAliasSRF := "SRF"
	/* Rotina de Busca Periodo Aquisitivo SRF */

	aPerSRF := {}
	
	dbSelectArea(cAliasSRF)
	
	dbSetOrder(RETORDER(cAliasSRF,"RF_FILIAL+RF_MAT+DTOS(RF_DATABAS") )
	
	IF dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
   
		While !Eof() .And. SRF->RF_MAT == SRA->RA_MAT
				       
				
				IF SRF->RF_STATUS == "1"                       //1= Ativo
					
					//Verifica se o Periodo Aberto nЦo esta Expirado (3 Anos)
					nAnoExp := DDATABASE - SRF->RF_DATAFIM
					
					IF (nAnoExp < 1080 )          
			
			           //Data Inicial Periodo de Ferias, Data Final Periodo de Ferias
      		           aAdd(aPerSRF,{SRF->RF_DATABAS,SRF->RF_DATAFIM } )
					Else
					   ( cAliasSRF )->( dbSkip(1) )
					   Loop
					ENDIF
					EXIT
				ENDIF
			   ( cAliasSRF )->( dbSkip(1) )
		EndDO
	ENDIF	
Return(aPerSRF)

/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁfTarProf  Ё Autor ЁJonatas A. T. Alves    Ё Data Ё18/02/2011Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁCarrega Informacoes dos lancamentos de tarefas p/ professor Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function  fTarProf(dDtRef)

Local nI		:= 0
Local nP		:= 0
Local nCont		:= 0
Local nQtTar	:= 2				// Quantidade de tarefas
Local aArea		:= GetArea()
Local aCpos		:= Array(nQtTar,0)
Local aRet		:= Array(nQtTar,0)
Local bTar		:= { || .T. }

DEFAULT dDtRef := SRA->RA_ADMISSA

For nI := 1 To nQtTar
	aAdd( aCpos[nI], { "RO_DESTAR",	} )
	aAdd( aCpos[nI], { "RO_QTDSEM",	} )
	aAdd( aCpos[nI], { "RO_QUANT",	} )
	aAdd( aCpos[nI], { "RO_VALOR",	} )
	aAdd( aCpos[nI], { "RO_VALTOT",	} )
Next

// Professores mensalistas so considerar tarefas fixas
If SRA->RA_CATFUNC == "I"
	bTar := { || SRO->RO_TIPO == "1" }
EndIf

dbSelectArea("SRO")
If dbSeek( SRA->( RA_FILIAL + RA_MAT ) )
	While !Eof() .And. SRA->( RA_FILIAL + RA_MAT ) == SRO->( RO_FILIAL + RO_MAT ) .And. nCont < nQtTar
		If MesAno(SRO->RO_DATA) == MesAno(dDtRef) .And. Eval(bTar) // Fitlra data de referencia e tarefas fixas
			If SRO->RO_TPALT == "001" .And. SRO->RO_QUANT > 0 // Considera apenas salario Inicial e despreza se for h.e./falta
				nCont++
				For nP := 1 To Len( aCpos[1] )
					If aCpos[nCont][nP][1] == "RO_DESTAR"
						aCpos[nCont][nP][2] := fDescTarefa(SRO->RO_CODTAR)
					Else
						aCpos[nCont][nP][2] := SRO->( &( aCpos[nCont][nP][1] ) )
					EndIf
				Next
			EndIf
		EndIf
		dbSkip()
	EndDo
EndIf

For nI := 1 To nQtTar
	aEval( aCpos[nI], { |x| aAdd( aRet[nI], x[2] ) } )
Next

RestArea( aArea )

Return( aRet )


//зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
//ЁFun┤└o    ЁfCpos_WordЁ Autor ЁMarinaldo de Jesus     Ё Data Ё06/07/2000Ё
//цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
//ЁDescri┤└o ЁRetorna Array com as Variaveis Disponiveis para Impressao   Ё
//цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//Ё          ЁaExp[x,1] - Variavel Para utilizacao no Word (Tam Max. 30)  Ё
//Ё          ЁaExp[x,2] - Conteudo do Campo                (Tam Max. 49)  Ё
//Ё          ЁaExp[x,3] - Campo para Pesquisa da Picture no X3 ou Picture Ё
//Ё          ЁaExp[x,4] - Descricao da Variaval                           Ё
//юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
STATIC Function fCpos_Word()

Local aExp			:= {}
Local aRet			:= {}
Local cTexto_01		:= AllTrim( mv_par19 )
Local cTexto_02		:= AllTrim( mv_par20 )
Local cTexto_03		:= AllTrim( mv_par21 )
Local cTexto_04		:= AllTrim( mv_par22 ) 
Local cApoderado	:= ""
Local cRamoAtiv		:= ""   
Local cEstCiv		:= "" //Estado Civil para DCN/DMN - PIS
Local cTipCertd		:= "" //Tipo de Certidao Civil para DCN/DMN - PIS
Local cGrauInstr	:= "" //Grau de Instrucao conforme DCN/DMN - PIS
Local cTipNIS		:= ""

Local cDESMTSS		:=""
Local cDESCCSS		:=""
Local cDESINS		:=""
Local cDESCAN		:=""
Local cDESCIC		:=""
Local cDESJOR		:=""
Local cDESFON		:=""

Local cCodMunLP		:= ""
Local cCodReqFun	:= ""

If cPaisLoc == "BRA"
	cTipNIS := MV_PAR30  //Pergunte exclusivo do Brasil // Tipo PIS - DCN/DMN
EndIf

If cPaisLoc == "ARG"
	If fPHist82(xFilial(),"99","01")
		cApoderado := SubStr(SRX->RX_TXT,1,30)
	EndIf
	If fPHist82(xFilial(),"99","02")
		cRamoAtiv := SubStr(SRX->RX_TXT,1,50) 
	EndIf	           
EndIf	

aAdd( aExp, {'GPE_FILIAL'				,	SRA->RA_FILIAL 										  	, "SRA->RA_FILIAL"			,STR0013	} ) 
aAdd( aExp, {'GPE_MATRICULA'			,	SRA->RA_MAT												, "SRA->RA_MAT"				,STR0014	} ) 
aAdd( aExp, {'GPE_CENTRO_CUSTO'			,	SRA->RA_CC												, "SRA->RA_CC"				,STR0015	} ) 
aAdd( aExp, {'GPE_DESC_CCUSTO'			,	fDesc("SI3",SRA->RA_CC,"I3_DESC")		 				, "@!"						,STR0016	} ) 
aAdd( aExp, {'GPE_NOME'		   			,	SRA->RA_NOME											, "SRA->RA_NOME"			,STR0017	} ) 
aAdd( aExp, {'GPE_NOMECMP'           	,   If(SRA->(FieldPos("RA_NOMECMP")) # 0  ,SRA->RA_NOMECMP,space(40)), "@!"           ,STR0017 	} )
aAdd( aExp, {'GPE_CPF'		   			,	SRA->RA_CIC												, "SRA->RA_CIC"				,STR0018	} ) 
aAdd( aExp, {'GPE_PIS'		   			,	SRA->RA_PIS												, "SRA->RA_PIS"				,STR0019	} ) 
aAdd( aExp, {'GPE_RG'		   			,	SRA->RA_RG												, "SRA->RA_RG"				,STR0020	} ) 
aAdd( aExp, {'GPE_RG_ORG'	   			,	SRA->RA_RGORG											, "@!"						,STR0152	} ) 
aAdd( aExp, {'GPE_RG_ORGUF'	   			,	SRA->RA_RGUF											, "@!"						,STR0241	} ) 
aAdd( aExp, {'GPE_CTPS'					,	SRA->RA_NUMCP							 				, "SRA->RA_NUMCP"			,STR0021	} ) 
aAdd( aExp, {'GPE_SERIE_CTPS'			,	SRA->RA_SERCP							 				, "SRA->RA_SERCP"			,STR0022	} ) 
aAdd( aExp, {'GPE_UF_CTPS'				,	SRA->RA_UFCP							 				, "SRA->RA_UFCP"			,STR0023	} ) 
aAdd( aExp, {'GPE_CNH'   	  			,	SRA->RA_HABILIT							 				, "SRA->RA_HABILIT"			,STR0024	} ) 
aAdd( aExp, {'GPE_RESERVISTA'			,	SRA->RA_RESERVI							 				, "SRA->RA_RESERVI"			,STR0025	} ) 
aAdd( aExp, {'GPE_TIT_ELEITOR' 			,	SRA->RA_TITULOE							 				, "SRA->RA_TITULOE"			,STR0026	} ) 
aAdd( aExp, {'GPE_ZONA_SECAO'  			,	SRA->RA_ZONASEC							 				, "SRA->RA_ZONASEC"			,STR0027	} ) 
aAdd( aExp, {'GPE_ENDERECO'				,	SRA->RA_ENDEREC							 				, "SRA->RA_ENDEREC"			,STR0028	} ) 
aAdd( aExp, {'GPE_COMP_ENDER'			,	SRA->RA_COMPLEM							 				, "SRA->RA_COMPLEM"			,STR0029	} )	

If cPaisLoc == "PER"
	aAdd( aExp, {'GPE_BAIRRO'				,	RetContUbigeo("SRA->RA_CEP", "RA_BAIRRO") 				, "@!"						,STR0030	} ) 
	aAdd( aExp, {'GPE_MUNICIPIO'			,	RetContUbigeo("SRA->RA_CEP", "RA_MUNICIP") 				, "@!"						,STR0031	} )
	aAdd( aExp, {'GPE_DESC_ESTADO'			,	RetContUbigeo("SRA->RA_CEP", "RA_DEPARTA")				, "@!"						,STR0033	} )	
Else
	aAdd( aExp, {'GPE_BAIRRO'				,	SRA->RA_BAIRRO							 				, "SRA->RA_BAIRRO"			,STR0030	} ) 
	aAdd( aExp, {'GPE_MUNICIPIO'			,	SRA->RA_MUNICIP							 				, "SRA->RA_MUNICIP"			,STR0031	} )	
Endif

If !(cPaisLoc $ "ANG*PER")
	aAdd( aExp, {'GPE_ESTADO'				,	SRA->RA_ESTADO											, "SRA->RA_ESTADO"			,STR0032	} )	
ENDIF

If cPaisLoc <> "PER"
	aAdd( aExp, {'GPE_DESC_ESTADO'			,	fDesc("SX5","12"+SRA->RA_ESTADO,"X5_DESCRI")			, "@!"						,STR0033	} ) 
Endif
aAdd( aExp, {'GPE_CEP'		   			,	SRA->RA_CEP												, "SRA->RA_CEP"				,STR0034	} ) 
aAdd( aExp, {'GPE_TELEFONE'	   			,	SRA->RA_TELEFON											, "SRA->RA_TELEFON"			,STR0035	} ) 
aAdd( aExp, {'GPE_NOME_PAI'	   			,	SRA->RA_PAI												, "SRA->RA_PAI"				,STR0036	} ) 
aAdd( aExp, {'GPE_NOME_MAE'	   			,	SRA->RA_MAE												, "SRA->RA_MAE"				,STR0037	} ) 
aAdd( aExp, {'GPE_COD_SEXO'	   			,	SRA->RA_SEXO											, "SRA->RA_SEXO"			,STR0038	} ) 
aAdd( aExp, {'GPE_DESC_SEXO'   			,	SRA->(IF(RA_SEXO ="M","Masculino","Feminino"))			, "@!"						,STR0039	} ) 
If cPaisLoc <> "ARG"
	aAdd( aExp, {'GPE_EST_CIVIL'  			,	SRA->RA_ESTCIVI										, "SRA->RA_ESTCIVI"			,STR0040	} ) 
Else	
	aAdd( aExp, {'GPE_EST_CIVIL'  			,	fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")		, "SRA->RA_ESTCIVI"			,STR0040	} ) 
EndIf	
aAdd( aExp, {'GPE_COD_NATURALIDADE'		,	If(SRA->RA_NATURAL # " ",SRA->RA_NATURAL," ")	    	, "SRA->RA_NATURAL"			,STR0041	} ) 
aAdd( aExp, {'GPE_DESC_NATURALIDADE'	,	fDesc("SX5","12"+SRA->RA_NATURAL,"X5_DESCRI")			, "@!"						,STR0042	} ) 
aAdd( aExp, {'GPE_COD_NACIONALIDADE'	,	SRA->RA_NACIONA											, "SRA->RA_NACIONA"			,STR0043	} ) 
aAdd( aExp, {'GPE_DESC_NACIONALIDADE'	,	fDesc("SX5","34"+SRA->RA_NACIONA,"X5_DESCRI")			, "@!"						,STR0044	} ) 
If cPaisLoc <> "EQU"
	aAdd( aExp, {'GPE_ANO_CHEGADA' 			,	SRA->RA_ANOCHEG											, "SRA->RA_ANOCHEG"			,STR0045	} )
EndIf
aAdd( aExp, {'GPE_DEP_IR'   			,	SRA->RA_DEPIR										 	, "SRA->RA_DEPIR"			,STR0046	} )	
If lDepSf
	aAdd( aExp, {'GPE_DEP_SAL_FAM'			,	SRA->RA_DEPSF											, "SRA->RA_DEPSF"			,STR0047 	} )
EndIf
aAdd( aExp, {'GPE_DATA_NASC'  			,	SRA->RA_NASC											, "SRA->RA_NASC"			,STR0048	} )
aAdd( aExp, {'GPE_DATA_ADMISSAO'		,	SRA->RA_ADMISSA											, "SRA->RA_ADMISSA"			,STR0049	} )
aAdd( aExp, {'GPE_DIA_ADMISSAO' 		,	StrZero( Day( SRA->RA_ADMISSA ) , 2 )					, "@!"						,STR0050	} )
aAdd( aExp, {'GPE_MES_ADMISSAO'			,	StrZero( Month( SRA->RA_ADMISSA ) , 2 )					, "@!"						,STR0051 	} )
aAdd( aExp, {'GPE_ANO_ADMISSAO'			,	StrZero( Year( SRA->RA_ADMISSA ) , 4 )					, "@!"						,STR0052	} )
aAdd( aExp, {'GPE_DT_OP_FGTS'  			,	SRA->RA_OPCAO											, "SRA->RA_OPCAO"			,STR0053	} )
aAdd( aExp, {'GPE_DATA_DEMISSAO'		,	SRA->RA_DEMISSA											, "SRA->RA_DEMISSA"			,STR0054	} ) 
If cPaisLoc <> "EQU"
	aAdd( aExp, {'GPE_DATA_EXPERIENCIA'		,	SRA->RA_VCTOEXP											, "SRA->RA_VCTOEXP"			,STR0055	} )
	aAdd( aExp, {'GPE_DIA_EXPERIENCIA' 		,	StrZero( Day( SRA->RA_VCTOEXP ) , 2 )					, "@!"						,STR0056	} )
	aAdd( aExp, {'GPE_MES_EXPERIENCIA'		,	StrZero( Month( SRA->RA_VCTOEXP ) , 2 )					, "@!"						,STR0057	} )
	aAdd( aExp, {'GPE_ANO_EXPERIENCIA'		,	StrZero( Year( SRA->RA_VCTOEXP ) , 4 ) 					, "@!"						,STR0058	} )
	aAdd( aExp, {'GPE_DIAS_EXPERIENCIA'		,	StrZero(SRA->(RA_VCTOEXP-RA_ADMISSA)+1,03)				, "@!"						,STR0059	} )
	aAdd( aExp, {'GPE_DATA_EXPERIENCIA2'	,	SRA->RA_VCTEXP2											, "SRA->RA_VCTEXP2"			,STR0245	} )
	aAdd( aExp, {'GPE_DIA_EXPERIENCIA2' 	,	StrZero( Day( SRA->RA_VCTEXP2 ) , 2 )					, "@!"						,STR0246	} )
	aAdd( aExp, {'GPE_MES_EXPERIENCIA2'		,	StrZero( Month( SRA->RA_VCTEXP2 ) , 2 )					, "@!"						,STR0247	} )
	aAdd( aExp, {'GPE_ANO_EXPERIENCIA2'		,	StrZero( Year( SRA->RA_VCTEXP2 ) , 4 ) 					, "@!"						,STR0248	} )
	aAdd( aExp, {'GPE_DIAS_EXPERIENCIA2'	,	StrZero(SRA->(RA_VCTEXP2-RA_ADMISSA)+1,03)				, "@!"						,STR0249	} )
	aAdd( aExp, {'GPE_DATA_EX_MEDIC'		,	SRA->RA_EXAMEDI											, "SRA->RA_EXAMEDI"			,STR0060	} )
EndIf


aAdd( aExp, {'GPE_BCO_AG_DEP_SAL'		, 	SRA->RA_BCDEPSA											, "SRA->RA_BCDEPSA"			,STR0061	} )
aAdd( aExp, {'GPE_DESC_BCO_SAL'			, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOME")					, "@!"						,STR0062	} )
aAdd( aExp, {'GPE_DESC_AGE_SAL'			, 	fDesc("SA6",SRA->RA_BCDEPSA,"A6_NOMEAGE")				, "@!"						,STR0063	} )
aAdd( aExp, {'GPE_CTA_DEP_SAL'			,	SRA->RA_CTDEPSA											, "SRA->RA_CTDEPSA"			,STR0064	} )
aAdd( aExp, {'GPE_BCO_AG_FGTS'			,	SRA->RA_BCDPFGT											, "SRA->RA_BCDPFGT"			,STR0065	} )
aAdd( aExp, {'GPE_DESC_BCO_FGTS'		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOME")					, "@!"						,STR0066	} )
aAdd( aExp, {'GPE_DESC_AGE_FGTS'		, 	fDesc("SA6",SRA->RA_BCDPFGT,"A6_NOMEAGE")				, "@!"						,STR0067	} )
aAdd( aExp, {'GPE_CTA_Dep_FGTS'			,	SRA->RA_CTDPFGT											, "SRA->RA_CTDPFGT"			,STR0068	} )
aAdd( aExp, {'GPE_SIT_FOLHA'	  		,	SRA->RA_SITFOLH											, "SRA->RA_SITFOLH"			,STR0069	} )
aAdd( aExp, {'GPE_DESC_SIT_FOLHA'  		,	fDesc("SX5","30"+SRA->RA_SITFOLH,"X5_DESCRI")			, "@!"						,STR0070	} )
aAdd( aExp, {'GPE_HRS_MENSAIS'			,	SRA->RA_HRSMES											, "SRA->RA_HRSMES"			,STR0071	} )
aAdd( aExp, {'GPE_HRS_SEMANAIS'			,	SRA->RA_HRSEMAN											, "SRA->RA_HRSEMAN"			,STR0072	} )
aAdd( aExp, {'GPE_CHAPA'		  		,	SRA->RA_CHAPA											, "SRA->RA_CHAPA"			,STR0073	} )
aAdd( aExp, {'GPE_TURNO_TRAB'	 		,	SRA->RA_TNOTRAB											, "SRA->RA_TNOTRAB"			,STR0074	} )
aAdd( aExp, {'GPE_DESC_TURNO'	  		,	fDesc('SR6',SRA->RA_TNOTRAB,'R6_DESC')					, "@!"						,STR0075	} )
aAdd( aExp, {'GPE_COD_FUNCAO'	 		,	SRA->RA_CODFUNC											, "SRA->RA_CODFUNC"			,STR0076 	} )
aAdd( aExp, {'GPE_DESC_FUNCAO'			,	fDesc('SRJ',SRA->RA_CODfUNC,'RJ_DESC')					, "@!"						,STR0077	} )
aAdd( aExp, {'GPE_CBO'			   		,	fCodCBO(SRA->RA_FILIAL,SRA->RA_CODFUNC,dDataBase)		, "@!"				        ,STR0078	} )
aAdd( aExp, {'GPE_CONT_SINDIC'			,	SRA->RA_PGCTSIN											, "SRA->RA_PGCTSIN"			,STR0079	} )
aAdd( aExp, {'GPE_COD_SINDICATO'		,	SRA->RA_SINDICA											, "SRA->RA_SINDICA"			,STR0080	} )
aAdd( aExp, {'GPE_DESC_SINDICATPO'		,	AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40) ), "@!"						,STR0081	} )
aAdd( aExp, {'GPE_COD_ASS_MEDICA'		,	SRA->RA_ASMEDIC											, "SRA->RA_ASMEDIC"			,STR0082	} )
aAdd( aExp, {'GPE_DEP_ASS_MEDICA'		,	SRA->RA_DPASSME											, "SRA->RA_DPASSME"			,STR0083	} )
aAdd( aExp, {'GPE_ADIC_TEMP_SERVIC'		,	SRA->RA_ADTPOSE											, "SRA->RA_ADTPOSE"			,STR0084	} )
aAdd( aExp, {'GPE_COD_CESTA_BASICA'		,	SRA->RA_CESTAB											, "SRA->RA_CESTAB"			,STR0085	} )
aAdd( aExp, {'GPE_COD_VALE_REF' 		,	SRA->RA_VALEREF											, "SRA->RA_VALEREF"			,STR0086	} )
If cPaisLoc $ ("ANG/ARG/BOL/BRA/CHI/COL/EQU/MEX/PER/PTG/URU/")
	aAdd( aExp, {'GPE_COD_SEG_VIDA' 		,	SRA->RA_SEGUROV											, "SRA->RA_SEGUROV"			,STR0087	} )
EndIf
aAdd( aExp, {'GPE_%ADIANTAM'	 		,	SRA->RA_PERCADT											, "SRA->RA_PERCADT"			,STR0089	} )
aAdd( aExp, {'GPE_CATEG_FUNC'	  		,	SRA->RA_CATFUNC											, "SRA->RA_CATFUNC"			,STR0090	} )
aAdd( aExp, {'GPE_DESC_CATEG_FUNC'		,	fDesc("SX5","28"+SRA->RA_CATFUNC,"X5_DESCRI")			, "@!"						,STR0091	} )
aAdd( aExp, {'GPE_POR_MES_HORA'			,	SRA->(IF(RA_CATFUNC$"H","P/Hora",IF(RA_CATFUNC$"J","P/Aula","P/Mes"))) 			, "@!"						,STR0092	} )
aAdd( aExp, {'GPE_TIPO_PAGTO'  			,	SRA->RA_TIPOPGT								 			, "SRA->RA_TIPOPGT"			,STR0093	} )
aAdd( aExp, {'GPE_DESC_TIPO_PAGTO'  	,	fDesc("SX5","40"+SRA->RA_TIPOPGT,"X5_DESCRI")			, "@!"						,STR0094	} )
aAdd( aExp, {'GPE_SALARIO'		   		,	SRA->RA_SALARIO											, "SRA->RA_SALARIO"			,STR0095	} )
If cPaisLoc <> "EQU"
	aAdd( aExp, {'GPE_SAL_BAS_DISS'			,	SRA->RA_ANTEAUM											, "SRA->RA_ANTEAUM"			,STR0096	} )
EndIf
aAdd( aExp, {'GPE_HRS_PERICULO'  		,	SRA->RA_PERICUL											, "SRA->RA_PERICUL"			,STR0099	} )
aAdd( aExp, {'GPE_HRS_INS_MINIMA'		,	SRA->RA_INSMIN											, "SRA->RA_INSMIN"			,STR0100	} )
aAdd( aExp, {'GPE_HRS_INS_MEDIA'		,	SRA->RA_INSMED											, "@!"						,STR0101	} )
aAdd( aExp, {'GPE_HRS_INS_MAXIMA'		,	SRA->RA_INSMAX											, "SRA->RA_INSMAX"			,STR0102	} )
aAdd( aExp, {'GPE_TIPO_ADMISSAO'		,	SRA->RA_TIPOADM											, "SRA->RA_TIPOADM"			,STR0103	} )
aAdd( aExp, {'GPE_DESC_TP_ADMISSAO'		,	fDesc("SX5","38"+SRA->RA_TIPOADM,"X5_DESCRI")			, "@!"						,STR0104	} )
aAdd( aExp, {'GPE_COD_AFA_FGTS'			,	SRA->RA_AFASFGT											, "SRA->RA_AFASFGT"			,STR0105	} )
aAdd( aExp, {'GPE_DESC_AFA_FGTS'		,	fDesc("SX5","30"+SRA->RA_AFASFGT,"X5_DESCRI")			, "@!"						,STR0106	} )
If cPaisLoc <> "PER"
	aAdd( aExp, {'GPE_VIN_EMP_RAIS'			,	SRA->RA_VIEMRAI											, "SRA->RA_VIEMRAI"			,STR0107	} )
	aAdd( aExp, {'GPE_DESC_VIN_EMP_RAIS'	,	fDesc("SX5","25"+SRA->RA_VIEMRAI,"X5_DESCRI")				, "@!"						,STR0108	} )
Endif
aAdd( aExp, {'GPE_COD_INST_RAIS'		,	SRA->RA_GRINRAI											, "SRA->RA_GRINRAI"			,STR0109	} )
aAdd( aExp, {'GPE_DESC_GRAU_INST'		,	fDesc("SX5","26"+SRA->RA_GRINRAI,"X5_DESCRI")			, "@!"						,STR0110	} )
aAdd( aExp, {'GPE_COD_RESC_RAIS'		,	SRA->RA_RESCRAI											, "SRA->RA_RESCRAI"			,STR0111	} )
aAdd( aExp, {'GPE_CRACHA'		  		,	SRA->RA_CRACHA											, "SRA->RA_CRACHA"			,STR0112	} )
aAdd( aExp, {'GPE_REGRA_APONTA'			,	SRA->RA_REGRA											, "SRA->RA_REGRA"			,STR0113	} )
aAdd( aExp, {'GPE_NO_REGISTRO'	 		,	SRA->RA_REGISTR											, "SRA->RA_REGISTR"			,STR0115	} )
aAdd( aExp, {'GPE_NO_FICHA'	    		,	SRA->RA_FICHA											, "SRA->RA_FICHA"			,STR0116	} )
aAdd( aExp, {'GPE_TP_CONT_TRAB'			,	SRA->RA_TPCONTR											, "SRA->RA_TPCONTR"			,STR0117	} )
aAdd( aExp, {'GPE_DESC_TP_CONT_TRAB'	,	SRA->(IF(RA_TPCONTR="1","Indeterminado","Determinado")) , "@!"						,STR0118	} )
aAdd( aExp, {'GPE_APELIDO'		   		,	SRA->RA_APELIDO											, "SRA->RA_APELIDO"			,STR0119	} )
aAdd( aExp, {'GPE_E-MAIL'		 		,	SRA->RA_EMAIL											, "SRA->RA_EMAIL"			,STR0120	} )
aAdd( aExp, {'GPE_TEXTO_01'				,	cTexto_01								   				, "@!"						,STR0121	} ) 
aAdd( aExp, {'GPE_TEXTO_02'				,	cTexto_02												, "@!"						,STR0122	} )
aAdd( aExp, {'GPE_TEXTO_03'				,	cTexto_03												, "@!"						,STR0123	} )
aAdd( aExp, {'GPE_TEXTO_04'				,	cTexto_04												, "@!"						,STR0124	} )
aAdd( aExp, {'GPE_EXTENSO_SAL'			,	Extenso( SRA->RA_SALARIO , .F. , 1 )					, "@!"						,STR0125 	} )
aAdd( aExp, {'GPE_DDATABASE'			,	dDataBase                    	        				, "" 						,STR0126	} )
aAdd( aExp, {'GPE_DIA_DDATABASE'		,	StrZero( Day( dDataBase ) , 2 )            				, "@!"						,STR0127	} )
aAdd( aExp, {'GPE_MES_DDATABASE'		,	MesExtenso( dDataBase ) 								, "@!"						,STR0128	} )
aAdd( aExp, {'GPE_ANO_DDATABASE'		,	StrZero( Year( dDataBase ) , 4 )            			, "@!"						,STR0129	} )
aAdd( aExp, {'GPE_NOME_EMPRESA' 		,	aInfo[03]                              					, "@!"						,STR0130	} )
aAdd( aExp, {'GPE_END_EMPRESA'			,	aInfo[04]                              					, "@!"						,STR0131	} )
aAdd( aExp, {'GPE_CID_EMPRESA'			,	aInfo[05]                              					, "@!"						,STR0132	} )
aAdd( aExp, {'GPE_CEP_EMPRESA'         	,   aInfo[07]                                              	, "!@R #####-###"          	,STR0034 	} )
aAdd( aExp, {'GPE_EST_EMPRESA'         	,   aInfo[06]												, "@!"						,STR0032 	} )
aAdd( aExp, {'GPE_CGC_EMPRESA' 			,	aInfo[08]             									, "@R ##.###.###/####-##"	,STR0134	} )
aAdd( aExp, {'GPE_INSC_EMPRESA' 		,	aInfo[09]                              					, "@!" 						,STR0135	} )
aAdd( aExp, {'GPE_TEL_EMPRESA'	 		,	aInfo[10]                              					, "@!" 						,STR0136	} )
aAdd( aExp, {'GPE_FAX_EMPRESA'         	,   If(aInfo[11]#nil ,aInfo[11], "        ")              	, "@!"                     	,STR0136 	} )
aAdd( aExp, {'GPE_BAI_EMPRESA'			,	aInfo[13]                              					, "@!" 						,STR0137	} )
aAdd( aExp, {'GPE_DESC_RESC_RAIS'		,	fDesc("SX5","31"+SRA->RA_RESCRAI,"X5_DESCRI")			, "@!" 						,STR0138	} )
aAdd( aExp, {'GPE_DIA_DEMISSAO'			,	StrZero( Day( SRA->RA_DEMISSA ) , 2 )					, "@!" 						,STR0139	} )
aAdd( aExp, {'GPE_MES_DEMISSAO'			,	StrZero( Month( SRA->RA_DEMISSA ) , 2 )					, "@!" 						,STR0140 	} )
aAdd( aExp, {'GPE_ANO_DEMISSAO'			,	StrZero( Year( SRA->RA_DEMISSA ) , 4 )					, "@!" 						,STR0141 	} )
If cPaisLoc == "BRA"
	aAdd( aExp, {'GPE_RG_EMISSAO'			,	SRA->RA_DTRGEXP											, "SRA->RA_DTRGEXP"       	,STR0242	} )
	aAdd( aExp, {'GPE_CTPS_EMISSAO'			,	SRA->RA_DTCPEXP											, "SRA->RA_DTCPEXP"       	,STR0243	} )
EndIf
aAdd( aExp, {'GPE_FUNC_COR'				,	If( SRA->RA_RACACOR == "1" , "IndМgena" , ( If( SRA->RA_RACACOR == "2" , "Branca" , ( If( SRA->RA_RACACOR == "4" , "Negra" , ( If( SRA->RA_RACACOR == "6" , "Amarela" , ( If( SRA->RA_RACACOR == "8" , "Parda" , "NЦo informado" ) ) ) ) ) ) ) ) ) 											, "@!"       	,STR0244	} )
//Periodo Aquisitivo de Ferias

IF cPaisLoc == "COL"
   aAdd( aExp, {'GPE_DIA_INIFERIAS'           ,   if(Len(aPerSRF) > 0,StrZero( Day( aPerSRF[1,1] ) , 2 ),space(02))   , "@!"		,STR0188 	} )
   aAdd( aExp, {'GPE_MES_INIFERIAS'           ,   if(Len(aPerSRF) > 0,MesExtenso(aPerSRF[1,1] ),space(12)) , "@!"    ,STR0189 	} )
   aAdd( aExp, {'GPE_ANO_INIFERIAS'           ,   if(Len(aPerSRF) > 0,StrZero( Year( aPerSRF[1,1] ) , 4 ),space(04))  , "@!"		,STR0190 	} )
   
   aAdd( aExp, {'GPE_DIA_FIMFERIAS'           ,   if(Len(aPerSRF) > 0,StrZero( Day( aPerSRF[1,2] ) , 2 ),space(02))   , "@!"		,STR0191 	} )
   aAdd( aExp, {'GPE_MES_FIMFERIAS'           ,   if(Len(aPerSRF) > 0,MesExtenso(aPerSRF[1,2] ),space(12)) , "@!"    ,STR0192 	} )
   aAdd( aExp, {'GPE_ANO_FIMFERIAS'           ,   if(Len(aPerSRF) > 0,StrZero( Year( aPerSRF[1,2] ) , 4 ),space(04))  , "@!"		,STR0193 	} )
ENDIF   

//SALARIO FAMILIA//
aAdd( aExp, {'GPE_CFILHO01'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[1,1],space(30))		, "@!"						,STR0150 	} )
aAdd( aExp, {'GPE_DTFL01'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[1,2],space(08))		, ""						,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO02'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[2,1],space(30))		, "@!"						,STR0150 	} )
aAdd( aExp, {'GPE_DTFL02'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[2,2],space(08))		, ""						,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO03'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[3,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL03'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[3,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO04'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[4,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL04'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[4,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO05'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[5,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL05'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[5,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO06'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[6,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL06'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[6,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO07'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[7,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL07'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[7,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO08'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[8,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL08'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[8,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO09'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[9,1],space(30))		, "@!"                      ,STR0150 	} )
aAdd( aExp, {'GPE_DTFL09'              	,   if(nDepen==1 .or. nDepen==3,aDepenSF[9,2],space(08))		, ""                        ,STR0151 	} )
aAdd( aExp, {'GPE_CFILHO10'            	,   if(nDepen==1 .or. nDepen==3,aDepenSF[10,1],space(30))		, "@!"                    	,STR0150 	} )
aAdd( aExp, {'GPE_DESC_ESTEMP'         	,   alltrim(fDesc("SX5","12"+aInfo[06],"X5_DESCRI"))      		, "@!"                     	,STR0134 	} ) 
aAdd( aExp, {'GPE_cGrau01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,3],space(10))		, "@!"						,STR0153 	} )
aAdd( aExp, {'GPE_cGrau07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,3],space(10))		, "@!"						,STR0153 	} )
aAdd( aExp, {'GPE_cGrau08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,3],space(10))		, "@!"						,STR0153 	} )
aAdd( aExp, {'GPE_cGrau09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_cGrau10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_LOCAL01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA01'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA01'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[1,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA02'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA02'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[2,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,5],space(10))	 	, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,6],space(10))	 	, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,7],space(10))	 	, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA03'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,8],space(10))	 	, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,9],space(10))	 	, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA03'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[3,10],space(10))  	, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,4],space(10))	 	, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,5],space(10))	 	, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,06],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA04'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA04'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[4,10],space(10)) 		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,5],space(10))		, "@!"						,STR0156 	} )
aAdd( aExp, {'GPE_NREGISTRO05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA05'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA05'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[5,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,7],space(10))	    , "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA06'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA06'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[6,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA07'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA07'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[7,10],space(10)) 		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA08'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA08'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[8,10],space(10)) 		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA09'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA09'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[9,10],space(10))		, "@!"						,STR0161 	} ) 
aAdd( aExp, {'GPE_LOCAL10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,4],space(10))		, "@!"						,STR0164 	} ) 
aAdd( aExp, {'GPE_CARTORIO10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,5],space(10))		, "@!"						,STR0156 	} ) 
aAdd( aExp, {'GPE_NREGISTRO10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,6],space(10))		, "@!"						,STR0165 	} ) 
aAdd( aExp, {'GPE_NLIVRO10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,7],space(10))		, "@!"						,STR0158 	} ) 
aAdd( aExp, {'GPE_NFOLHA10'				,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,8],space(10))		, "@!"						,STR0159 	} ) 
aAdd( aExp, {'GPE_DT_ENTREGA10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,9],space(10))		, "@!"						,STR0160 	} ) 
aAdd( aExp, {'GPE_DT_BAIXA10'			,	if(nDepen==1 .or. nDepen==3,aDepenSF[10,10],space(10))		, "@!"						,STR0161 	} ) 
//IMPOSTO DE RENDA//
aAdd( aExp, {'GPE_CDEPE01'             	,   if(nDepen==2 .or. nDepen==3,aDepenIR[1,1],space(30))		, "@!"						,STR0154   	} )
aAdd( aExp, {'GPE_cGrDp01'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[1,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR01'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[1,2],space(08)) 		, ""						,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE02'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[2,1],space(30))		, "@!" 						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp02'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[2,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR02'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[2,2],space(08))		, ""						,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE03'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[3,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp03'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[3,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR03'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[3,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE04'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[4,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp04'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[4,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR04'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[4,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE05'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[5,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp05'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[5,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR05'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[5,2],space(08))		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE06'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[6,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp06'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[6,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR06'				,   if(nDepen==2 .or. nDepen==3,aDepenIR[6,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE07'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[7,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp07'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[7,3],space(10))		, "@!"						,STR0153	} ) 
aAdd( aExp, {'GPE_DTFLIR07'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[7,2],space(08))		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE08'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[8,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp08'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[8,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR08'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[8,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE09'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[9,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp09'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[9,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR09'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[9,2],space(08)) 		, ""                        ,STR0163 	} )
aAdd( aExp, {'GPE_CDEPE10'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[10,1],space(30))		, "@!"						,STR0154 	} )
aAdd( aExp, {'GPE_cGrDp10'				,	if(nDepen==2 .or. nDepen==3,aDepenIR[10,3],space(10))		, "@!"						,STR0153 	} ) 
aAdd( aExp, {'GPE_DTFLIR10'            	,   if(nDepen==2 .or. nDepen==3,aDepenIR[10,2],space(08))		, ""                        ,STR0163 	} )

If cPaisLoc == "ARG"
	aAdd( aExp, {'GPE_MES_ADEXT'		    ,	MesExtenso( Month( SRA->RA_ADMISSA ) )					    , "@!"						,STR0155	} )
	aAdd( aExp, {'GPE_APODERADO'		    ,	cApoderado												    , "@!"						,STR0156	} )
	aAdd( aExp, {'GPE_ATIVIDADE'		    ,	cRamoAtiv												    , "@!"						,STR0157	} )
EndIf	

aAdd( aExp, {'GPE_MUNICNASC'           	,   if(SRA->(FieldPos("RA_MUNNASC")) # 0  ,SRA->RA_MUNNASC,space(20)), "@!"                    ,STR0166 	} )
If SRA->(FieldPos("RA_PROCES" )) # 0
	aAdd( aExp, {'GPE_PROCES'	,	SRA->RA_PROCES	,	"SRA->RA_PROCES"	,STR0173 	} )	//Codigo do Processo
EndIf

If SRA->(FieldPos("RA_DEPTO"  )) # 0                                                                         
	aAdd( aExp, {'GPE_DEPTO'	,	SRA->RA_DEPTO	,	"SRA->RA_DEPTO"		,STR0181 	} )	//Codigo do Departamento
EndIf

If SRA->(FieldPos("RA_POSTO"  )) # 0
	aAdd( aExp, {'GPE_POSTO'	,	SRA->RA_POSTO  ,	"SRA->RA_POSTO"		,STR0182 	} )	//Codigo do Posto
EndIf

If cPaisLoc == "MEX"

	cCodMunLP  := POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_MUNIC")
	cCodReqFun := POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_DESCREQ")
	
	aAdd( aExp, {'GPE_PRINOME'	, SRA->RA_PRINOME	,												"SRA->RA_PRINOME"	,STR0169	} ) 	//Primeiro Nome 
	aAdd( aExp, {'GPE_SECNOME'	, SRA->RA_SECNOME	,												"SRA->RA_SECNOME"	,STR0170	} ) 	//Segundo Nome
	aAdd( aExp, {'GPE_PRISOBR'	, SRA->RA_PRISOBR	,												"SRA->RA_PRISOBR"	,STR0171	} ) 	//Primeiro Sobrenome
	aAdd( aExp, {'GPE_SECSOBR'	, SRA->RA_SECSOBR	,												"SRA->RA_SECSOBR"	,STR0172	} ) 	//Segundo Sobrenome
	aAdd( aExp, {'GPE_KEYLOC'	, SRA->RA_KEYLOC	,												"SRA->RA_KEYLOC"	,STR0174	} ) 	//Codigo Local de Pagamento
	aAdd( aExp, {'GPE_TSIMSS'	, SRA->RA_TSIMSS	,												"SRA->RA_TSIMSS"	,STR0175	} ) 	//Tipo de Salario IMSS
	aAdd( aExp, {'GPE_TEIMSS'	, SRA->RA_TEIMSS	,												"SRA->RA_TEIMSS"	,STR0176	} ) 	//Tipo de Empregado IMSS
	aAdd( aExp, {'GPE_TJRNDA'	, SRA->RA_TJRNDA	,												"SRA->RA_TJRNDA"	,STR0177	} ) 	//Tipo de Jornada IMSS
	aAdd( aExp, {'GPE_FECREI'	, SRA->RA_FECREI	,												"SRA->RA_FECREI"	,STR0178	} ) 	//Data de Readmissao
	aAdd( aExp, {'GPE_DTBIMSS'	, SRA->RA_DTBIMSS	,						  						"SRA->RA_DTBIMSS"	,STR0179	} ) 	//Data de Baixa IMSS
	aAdd( aExp, {'GPE_CODRPAT'	, SRA->RA_CODRPAT	,						  						"SRA->RA_CODRPAT"	,STR0180	} ) 	//Codigo do Registro Patronal
	aAdd( aExp, {'GPE_CURP'		, SRA->RA_CURP	,						  							"SRA->RA_CURP"		,STR0183	} ) 	//CURP
	aAdd( aExp, {'GPE_TIPINF'	, SRA->RA_TIPINF	,  						  						"SRA->RA_TIPINF"	,STR0184	} ) 	//Tipo de Infonavit
	aAdd( aExp, {'GPE_VALINF'	, SRA->RA_VALINF	,						   						"SRA->RA_VALINF"	,STR0185	} ) 	//Valor do Infonavit
	aAdd( aExp, {'GPE_NUMINF'	, SRA->RA_NUMINF	,						   						"SRA->RA_NUMINF"	,STR0186	} ) 	//Nro. de Credito Infonavit
	aAdd( aExp, {'GPE_IDADE'	, cValToChar(Year(DDATABASE)-Year(SRA->RA_NASC))	,				"!@"				,STR0335	} ) 	//Idade
	aAdd( aExp, {'GPE_REQFUNC'	, MSMM(cCodReqFun,80),												"!@"				,STR0334	} )		//Requisitos da Funcao
	aAdd( aExp, {'GPE_DESCMUNIC', POSICIONE("VAM",1,XFILIAL("VAM")+SRA->RA_MUNICIP,"VAM_DESCID"),	"!@"				,STR0031	} ) 	//Descricao do Municipio

	//Campos da Localidade de Pagamento
	aAdd( aExp, {'GPE_DESCLP',		POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_DESLOC"),	"RGC->RGC_DESLOC"	,STR0216	} )		//Descricao do Local de Pagamento
	aAdd( aExp, {'GPE_ENDERECOLP',	POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_ENDER"),	"RGC->RGC_ENDER"	,STR0328	} )		//Endereco da Localidade de Pagamento
	aAdd( aExp, {'GPE_BAIRROLP',	POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_BAIRRO"),	"RGC->RGC_BAIRRO"	,STR0329	} )		//Bairro da Localidade de Pagamento
	aAdd( aExp, {'GPE_CIDADELP',	POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_CIDADE"),	"RGC->RGC_CIDADE"	,STR0330	} )		//Cidade da Localidade de Pagamento
	aAdd( aExp, {'GPE_ESTADOLP',	POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_ESTADO"),	"RGC->RGC_ESTADO"	,STR0331	} )		//Estado da Localidade de Pagamento
	aAdd( aExp, {'GPE_CEPLP',		POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_CODPOS"),	"RGC->RGC_CODPOS"	,STR0333	} )		//CEP da Localidade de Pagamento
	aAdd( aExp, {'GPE_DESCMUNICLP',	POSICIONE("VAM",1,XFILIAL("VAM")+cCodMunLP,"VAM_DESCID"), 	"!@"					,STR0332	} )		//Municipio da Localidade de Pagamento

EndIf    

If ( AliasInDic( "CC2" ) .And. GetRpoRelease() >= "R7" ) .Or. cPaisLoc $ "COS/DOM"
	aAdd( aExp, {'GPE_DISTEMP'	,	POSICIONE("CC2",1,XFILIAL("CC2")+SRA->RA_ESTADO+SRA->RA_MUNICIP,"CC2_MUN")			,	"CC2->CC2_MUN"		,STR0220	} )//"DescripciСn del distrito"
EndIf   

If cPaisLoc == "COS" 

	cDESMTSS:=getQuery(	" SELECT SUBSTRING(RCC_CONTEU,5,40) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S006' AND SUBSTRING(RCC_CONTEU,1,4)= '"+POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODMTSS")+"'")
	cDESCCSS:=getQuery(	" SELECT SUBSTRING(RCC_CONTEU,5,80) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S007' AND SUBSTRING(RCC_CONTEU,1,4)= '"+POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODCCSS")+"'")
	cDESINS:=getQuery ( " SELECT SUBSTRING(RCC_CONTEU,6,80) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S008' AND SUBSTRING(RCC_CONTEU,1,5)= '"+POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODINS")+"'")
	cDESCAN:=getQuery ( " SELECT SUBSTRING(RCC_CONTEU,6,40) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S013' AND SUBSTRING(RCC_CONTEU,1,5)= '"+SRA->RA_MUNICIP+"'")
	cDESCIC:=getQuery ( " SELECT SUBSTRING(RCC_CONTEU,5,40) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S014' AND SUBSTRING(RCC_CONTEU,1,4)= '"+SRA->RA_TPCIC+"'")
	cDESJOR:=getQuery ( " SELECT SUBSTRING(RCC_CONTEU,5,100) CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S021' AND SUBSTRING(RCC_CONTEU,1,2)= '"+SRA->RA_TJRNDA+"'")
	cDESFON:=getQuery ( " SELECT SUBSTRING(RCC_CONTEU,5,40)  CONTEU FROM "+InitSqlName("RCC") +" WHERE RCC_CODIGO= 'S004' AND SUBSTRING(RCC_CONTEU,1,4)= '"+SRA->RA_FONSOL+"'")

	aAdd( aExp, {'GPE_CODRPAT'	,	SRA->RA_CODRPAT														,	"SRA->RA_CODRPAT"	,STR0180	} )//Codigo do Registro Patronal
	aAdd( aExp, {'GPE_NRPAT'	,	POSICIONE("RCO",1,XFILIAL("RCO")+SRA->RA_CODRPAT,"RCO_NREPAT")		,	"RCO->RCO_NREPAT"	,STR0207	} )//Codigo do Registro Patronal
	aAdd( aExp, {'GPE_POLRT'	,	POSICIONE("RCO",1,XFILIAL("RCO")+SRA->RA_CODRPAT,"RCO_POLRT")		,	"RCO->RCO_POLRT"	,STR0208	} )//"NЗmero de PСliza para MTSS"
	aAdd( aExp, {'GPE_SUCCSS'	,	POSICIONE("RCO",1,XFILIAL("RCO")+SRA->RA_CODRPAT,"RCO_SUCCSS")		,	"RCO->RCO_SUCCSS"	,STR0209	} )//"NЗmero de Sucursal del CCSS"
	aAdd( aExp, {'GPE_CODMTSS'	,	POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODMTSS")		,	"SRJ->RJ_CODMTSS"	,STR0210	} )//"CСdigo OcupaciСn MTSS"
	aAdd( aExp, {'GPE_CODCCSS'	,	POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODCCSS")		,	"SRJ->RJ_CODCCSS"	,STR0211	} )//"CСdigo OcupaciСn CCSS"
	aAdd( aExp, {'GPE_CODCINS'	,	POSICIONE("SRJ",1,XFILIAL("SRJ")+SRA->RA_CODFUNC,"RJ_CODINS")		,	"SRJ->RJ_CODINS"	,STR0212	} )//"CСdigo OcupaciСn INS"
	aAdd( aExp, {'GPE_DESMTSS'	,	cDESMTSS															,	"!@             "	,STR0213	} )//"DescripciСn de cСdigo OcupaciСn MTSS"
	aAdd( aExp, {'GPE_DESCCSS'	,	cDESCCSS															,	"!@            "	,STR0214	} )//"DescripciСn de cСdigo OcupaciСn CCSS"
	aAdd( aExp, {'GPE_DESINS'	,	cDESINS																,	"!@            "	,STR0215	} )//"DescripciСn de cСdigo OcupaciСn INS" 	
	aAdd( aExp, {'GPE_KEYLOC'	,	SRA->RA_KEYLOC														,	"SRA->RA_KEYLOC"	,STR0174	} )//Codigo Local de Pagamento
	aAdd( aExp, {'GPE_DESLOC'	,	POSICIONE("RGC",1,XFILIAL("RGC")+SRA->RA_KEYLOC,"RGC_DESLOC")		,	"RGC->RGC_DESLOC"	,STR0216	} )//"DescripciСn Localidad de Pago"
	aAdd( aExp, {'GPE_TNOTRAB'	,	SRA->RA_TNOTRAB														,	"SRA->RA_TNOTRAB"	,STR0217	} )//"Turno Trabajado"
	aAdd( aExp, {'GPE_HRDIA'	,	POSICIONE("SR6",1,XFILIAL("SR6")+SRA->RA_TNOTRAB,"R6_HRDIA")		,	"SR6->R6_HRDIA"		,STR0218	} )//"Horas por DМa"
	aAdd( aExp, {'GPE_BAIRROEMP',	SRA->RA_BAIRRO														,	"SRA->RA_BAIRRO"	,STR0219	} )//"Distrito donde vive el trabajador"
	aAdd( aExp, {'GPE_PRINOME'	,	SRA->RA_PRINOME														,	"SRA->RA_PRINOME"	,STR0169	} )//Primeiro Nome 
	aAdd( aExp, {'GPE_SECNOME'	,	SRA->RA_SECNOME														,	"SRA->RA_SECNOME"	,STR0170	} )//Segundo Nome
	aAdd( aExp, {'GPE_PRISOBR'	,	SRA->RA_PRISOBR														,	"SRA->RA_PRISOBR"	,STR0171	} )//Primeiro Sobrenome
	aAdd( aExp, {'GPE_SECSOBR'	,	SRA->RA_SECSOBR														,	"SRA->RA_SECSOBR"	,STR0172	} )//Segundo Sobrenome
	aAdd( aExp, {'GPE_CANTEMP'	,	SRA->RA_MUNICIP														,	"SRA->RA_MUNICIP"	,STR0221	} )//"CantСn donde vive el Trabajador"
	aAdd( aExp, {'GPE_DESCCANEMP'	,cDESCAN															,	"!@             "	,STR0222	} )//"DescripciСn del cantСn donde vive el Trabjador"
	aAdd( aExp, {'GPE_PROVEMP'	,	SRA->RA_ESTADO														,	"SRA->RA_ESTADO"	,STR0223	} )//"Provincia donde vive el Trabjador"
	aAdd( aExp, {'GPE_TIPOFIN'	,	SRA->RA_TIPOFIN														,	"SRA->RA_TIPOFIN"	,STR0225	} )//"Tipo de Baja de Acuerdo a la Empresa"
	aAdd( aExp, {'GPE_IDENEMP'	,	cDESCIC																,	"SRA->RA_CIC"	,	STR0226		} )//"Tipo nЗmero de identificaciСn"
	aAdd( aExp, {'GPE_SEGSOC'	,	SRA->RA_RG															,	"SRA->RA_RG"	,	STR0227		} )//"NЗmero de Seguridad Social"
	aAdd( aExp, {'GPE_DESTIPJOR',	cDESJOR																,	"!@            "	,STR0228	} )//"DescripciСn Jornada"
	aAdd( aExp, {'GPE_FECAUM'	,	SRA->RA_FECAUM														,	"SRA->RA_FECAUM"	,STR0229	} )//"Fecha de ModificaciСn de Salario"
	aAdd( aExp, {'GPE_DOMICIL'	,	SRA->RA_DOMICIL														,	"SRA->RA_DOMICIL"	,STR0230	} )//"Extranjero viviendo en el Pais(1=Si; 2=No"
	aAdd( aExp, {'GPE_MOEDAPG'	,	SRA->RA_MOEDAPG														,	"SRA->RA_MOEDAPG"	,STR0231	} )//Tipo de Moneda para el salario en contrato (1=Local, 2=DСlares)
	aAdd( aExp, {'GPE_FONSOL'	,	SRA->RA_FONSOL 														,	"SRA->RA_FONSOL"	,STR0232	} )//"AsociaciСn Solidarista"
	
	aAdd( aExp, {'GPE_DESFONSOL',	cDESFON																,	"!@            "	,STR0233	} )//"DescripciСn AsociaciСn Solidarista"
	aAdd( aExp, {'GPE_TPCCSS'	,	SRA->RA_TPCCSS														,	"SRA->RA_TPCCSS"	,STR0234	} )//"Clase Seguro"
	aAdd( aExp, {'GPE_NSEGURO'	,	SRA->RA_NSEGURO														,	"SRA->RA_NSEGURO"	,STR0235	} )//"NЗmero Asegurado"	
	aAdd( aExp, {'GPE_GROSSUP'	,	SRA->RA_GROSSUP														,	"SRA->RA_GROSSUP"	,STR0236	} )//"Tipo de Gross Up de Salario"
	aAdd( aExp, {'GPE_ANTEAUM'	,	SRA->RA_ANTEAUM														,	"SRA->RA_ANTEAUM"	,STR0237	} )//"Salario Anterior"	

EndIf                  

If cPaisLoc == "ANG"
	aAdd( aExp, {'GPE_BIDENT'	     ,	SRA->RA_BIDENT                                	, "SRA->RA_BIDENT"	,STR0195	} ) //Nr. Bilhete Identidade
	aAdd( aExp, {'GPE_BIEMISS'	     ,	SRA->RA_BIEMISS                             	, "SRA->RA_BIEMISS"	,STR0196	} )	//Data de EmissЦo do Bilhete Identidade
    aAdd( aExp, {'GPE_ESTADO'		 ,  Alltrim(fDescRCC("S001",SRA->RA_ESTADO,1,2,3,30))  , "SRA->RA_ESTADO"	,STR0032	} ) // DescriГЦo do Distrito
EndIf

aAdd( aExp, {'GPE_DESC_EST_CIV'  ,	fDesc("SX5","33"+SRA->RA_ESTCIVI,"X5DESCRI()")	, "SRA->RA_ESTCIVI"	,STR0194	} ) //DescriГЦo do Estado Civil
    
If SRA->RA_CATFUNC $ "I*J"
	
	aRet := fTarProf()
	
	//Inclusao de variaveis contendo as tarefas fixas e aditamentos fixos dos professores
	aAdd( aExp, {'GPE_DESC_TAR_01'      	,   aRet[1,1], "@!"				, STR0197 	} ) // "DescriГЦo da primeira tarefa"
	aAdd( aExp, {'GPE_AULS_TAR_01'         	,   aRet[1,2], "SRO->RO_QTDSEM"	, STR0198 	} ) // "Aulas por semana da primeira tarefa"
	aAdd( aExp, {'GPE_QTD_TAR_01'         	,   aRet[1,3], "SRO->RO_QUANT"	, STR0199 	} ) // "Quantidade da primeira tarefa"
	aAdd( aExp, {'GPE_VUNI_TAR_01'         	,   aRet[1,4], "SRO->RO_VALOR"	, STR0200 	} ) // "Valor unitАrio da primeira tarefa"
	aAdd( aExp, {'GPE_VTOT_TAR_01'         	,   aRet[1,5], "SRO->RO_VALTOT"	, STR0201	} ) // "Valor total da primeira tarefa"
	
	aAdd( aExp, {'GPE_DESC_TAR_02'         	,   aRet[2,1], "@!"          	, STR0202 	} ) // "DescriГЦo da segunda tarefa"
	aAdd( aExp, {'GPE_AULS_TAR_02'         	,   aRet[2,2], "SRO->RO_QTDSEM"	, STR0203 	} ) // "Aulas por semana da segunda tarefa"
	aAdd( aExp, {'GPE_QTD_TAR_02'         	,   aRet[2,3], "SRO->RO_QUANT"	, STR0204 	} ) // "Quantidade da segunda tarefa"
	aAdd( aExp, {'GPE_VUNI_TAR_02'         	,   aRet[2,4], "SRO->RO_VALOR"	, STR0205 	} ) // "Valor unitАrio da segunda tarefa"
	aAdd( aExp, {'GPE_VTOT_TAR_02'         	,   aRet[2,5], "SRO->RO_VALTOT"	, STR0206 	} ) // "Valor total da segunda tarefa"
EndIf

If cPaisLoc == "BRA"    
	//Variaveis criadas para utilizacao no DCN/DMN Documento de Cadastro/Manutencao do NIS - PIS   

	cEstCiv :=SRA->RA_ESTCIVI  					//Adequacao do estado civil conforme o leiaute do DCN/DMN - PIS
	Do Case
		Case cEstCiv$"C|M"
			cEstCiv :="CASADO(A)
		Case cEstCiv$"D"
			cEstCiv :="DIVORCIADO(A)
		Case cEstCiv$"Q"
			cEstCiv :="SEPARADO(A)
		Case cEstCiv$"S"
			cEstCiv :="SOLTEIRO(A)
		Case cEstCiv$"V"
			cEstCiv :="VIUVO(A)
	EndCase	
	
    cTipCertd := SRA->RA_TIPCERT 				//Adequacao da descricao do certificado civil conforme o leiaute do DCN/DMN - PIS
    Do Case
    	Case cTipCertd == "1"
    		cTipCertd :=OemToAnsi(STR0317)
    	Case cTipCertd == "2"
    		cTipCertd :=OemToAnsi(STR0318)
    	Case cTipCertd == "3"
    		cTipCertd :=OemToAnsi(STR0317)
    	Case cTipCertd == "4"
    		cTipCertd :=OemToAnsi(STR0320)
    EndCase
    		
	
	cGrauInstr :=SRA->RA_GRINRAI
	Do Case										//Adequacao da descricao do grau de instrucao conforme o leiaute do DCN/DMN - PIS
		Case cGrauInstr == "10"  
			cGrauInstr := OemToAnsi(STR0295)
		Case cGrauInstr == "20"  
			cGrauInstr := OemToAnsi(STR0296)
		Case cGrauInstr == "25"  
			cGrauInstr := OemToAnsi(STR0297)
		Case cGrauInstr == "30"  
			cGrauInstr := OemToAnsi(STR0298)
		Case cGrauInstr == "35"  
			cGrauInstr := OemToAnsi(STR0299)
		Case cGrauInstr == "40"  
			cGrauInstr := OemToAnsi(STR0300)
		Case cGrauInstr == "45"  
			cGrauInstr := OemToAnsi(STR0301)
		Case cGrauInstr == "50"  
			cGrauInstr := OemToAnsi(STR0302)
		Case cGrauInstr == "55"  
			cGrauInstr := OemToAnsi(STR0303)
		Case cGrauInstr == "65"  
			cGrauInstr := OemToAnsi(STR0304)
		Case cGrauInstr == "75"  
			cGrauInstr := OemToAnsi(STR0305)
		Case cGrauInstr == "85"  
			cGrauInstr := OemToAnsi(STR0306)
		Case cGrauInstr == "95"  
			cGrauInstr := OemToAnsi(STR0307)																											
	EndCase                                     

	aAdd( aExp, {'GPE_NACION_BRASILEIRA'	,SRA->(IF(RA_BRNASEX$"1","",(IF(RA_NACIONA$"10","x",""))))						 	 		,"SRA->RA_BRNASEX"	, STR0250   } ) // "Marca 'x' se Nacionalidade Brasileira"
	aAdd( aExp, {'GPE_NACION_ESTRANGEIRA'	,SRA->(IF(RA_BRNASEX$"1","",(IF(RA_NACIONA$"10","",(IF(RA_NACIONA$"20","","x"))))))			,"SRA->RA_BRNASEX"	, STR0251   } ) // "Marca 'x' se Nacionalidade Extrangeira"
	aAdd( aExp, {'GPE_NACION_BRA_NATURA'	,SRA->(IF(RA_BRNASEX$"1","",(IF(RA_NACIONA$"10","",(IF(RA_NACIONA$"20","x",""))))))			,"SRA->RA_BRNASEX"	, STR0252   } ) // "Marca 'x' se Nacionalidade Brasileira Naturalizada"
	aAdd( aExp, {'GPE_NACION_BRA_NASC_EXTE'	,SRA->(IF(RA_BRNASEX$"1","x",""))			 													,"SRA->RA_BRNASEX"	, STR0253   } ) // "Marca 'x' se Nacionalidade Brasileiro Nascido no Exterior"
	aAdd( aExp, {'GPE_EST_CIVIL_DCN'  		,cEstCiv																						,"SRA->RA_ESTCIVI"	, STR0254	} ) // "Estado civil de acordo com o NIS/PIS"
	aAdd( aExp, {'GPE_NOME_PAI_DCN'	   		,SRA->(IF(Empty (SRA->RA_PAI),"IGNORADO",SRA->RA_PAI))											,"SRA->RA_PAI"		, STR0255	} ) // "Nome do Pai, informa IGNORADO caso esteja em branco"
	aAdd( aExp, {'GPE_NOME_MAE_DCN'	   		,SRA->(IF(Empty (SRA->RA_MAE),"IGNORADA",SRA->RA_MAE))											,"SRA->RA_MAE"		, STR0256	} ) // "Nome da Mae, informa IGNORADO caso esteja em branco"
	aAdd( aExp, {'GPE_COMPLEM_RG'			,SRA->RA_COMPLRG																				,"SRA->RA_COMPLRG"	, STR0257   } ) // "Complemento do RG"
	aAdd( aExp, {'GPE_TIP_CERTID'			,cTipCertd																						,"SRA->RA_TIPCERT"	, STR0258   } ) // "Tipo de Certidao Civil"
	aAdd( aExp, {'GPE_EMIS_CERTID'			,SRA->RA_EMICERT																				,"SRA->RA_EMICERT"	, STR0259   } ) // "Data de Emissao da Certidao Civil"
	aAdd( aExp, {'GPE_MAT_CERTID'			,SRA->RA_MATCERT																				,"SRA->RA_MATCERT"	, STR0260   } ) // "Termo/Matricula da Certidao Civil"
	aAdd( aExp, {'GPE_LIVRO_CERT'			,SRA->RA_LIVCERT																				,"SRA->RA_LIVCERT"	, STR0261   } ) // "Livro da Certidao Civil"
	aAdd( aExp, {'GPE_FOLHA_CERT'			,SRA->RA_FOLCERT																				,"SRA->RA_FOLCERT"	, STR0262   } ) // "Folha da Certidao Civil"
	aAdd( aExp, {'GPE_CART_CERTID'			,SRA->RA_CARCERT																				,"SRA->RA_CARCERT"	, STR0263   } ) // "Cartorio da Certidao Civil"
	aAdd( aExp, {'GPE_UF_CERTIDAO'			,SRA->RA_UFCERT			 																		,"SRA->RA_UFCERT"	, STR0264   } ) // "UF da Certidao Civil"
	aAdd( aExp, {'GPE_MUN_CERTIDAO'			,fDesc("CC2",SRA->RA_UFCERT+SRA->RA_CDMUCER,"CC2_MUN")											,"SRA->RA_MUNCERT"	, STR0265   } ) // "Municipio da Certidao Civil"
	aAdd( aExp, {'GPE_NUM_PASSAPOR'			,SRA->RA_NUMEPAS																				,"SRA->RA_NUMEPAS"	, STR0266   } ) // "Numero do Passaporte"
	aAdd( aExp, {'GPE_EMIS_PASSAPOR'		,SRA->RA_EMISPAS																				,"SRA->RA_EMISPAS"	, STR0267   } ) // "Orgao Emissor do Passaporte"
	aAdd( aExp, {'GPE_UF_PASSAPORTE'		,SRA->RA_UFPAS  																				,"SRA->RA_UFPAS"	, STR0268   } ) // "UF do Passaporte"
	aAdd( aExp, {'GPE_DT_EMIS_PAS'			,SRA->RA_DEMIPAS																				,"SRA->RA_DEMIPAS"	, STR0269   } ) // "Data Emissao Passaporte"
	aAdd( aExp, {'GPE_DT_VALID_PAS'			,SRA->RA_DVALPAS																				,"SRA->RA_DVALPAS"	, STR0270   } ) // "Data Validade Passaporte"
	aAdd( aExp, {'GPE_PAIS_PASSAPOR'		,fDesc("CCH",SRA->RA_CODPAIS,"CCH_PAIS")														,"SRA->RA_PAISPAS"	, STR0271   } ) // "Pais de Emissao Passaporte"
	aAdd( aExp, {'GPE_NUM_NATURALIZ'		,SRA->RA_NUMNATU																				,"SRA->RA_NUMNATU"	, STR0272   } ) // "Numero de Naturalizacao"
	aAdd( aExp, {'GPE_DATA_NATURALIZ'		,SRA->RA_DATNATU																				,"SRA->RA_DATNATU"	, STR0273   } ) // "Data de Naturalizacao"
	aAdd( aExp, {'GPE_NUMERO_RIC'			,SRA->RA_NUMRIC 																				,"SRA->RA_NUMRIC" 	, STR0274   } ) // "Numero do RIC"
	aAdd( aExp, {'GPE_EMISSAO_RIC'			,SRA->RA_EMISRIC																				,"SRA->RA_EMISRIC"	, STR0275   } ) // "Orgao Emissor do RIC"
	aAdd( aExp, {'GPE_UF_RIC'				,SRA->RA_UFRIC  																				,"SRA->RA_UFRIC"  	, STR0276   } ) // "UF do RIC"
	aAdd( aExp, {'GPE_MUNICIPIO_RIC'		,fDesc("CC2",SRA->RA_UFRIC+SRA->RA_CDMURIC,"CC2_MUN")											,"SRA->RA_MUNIRIC"	, STR0277   } ) // "Municipio do RIC"
	aAdd( aExp, {'GPE_DATA_EXP_RIC'			,SRA->RA_DEXPRIC																				,"SRA->RA_DEXPRIC"	, STR0278   } ) // "Data de Expedicao do RIC"
	aAdd( aExp, {'GPE_TIPO_ENDERECO_COM'	,SRA->(IF(RA_TIPENDE$"1","x" ,""))																,"SRA->RA_TIPENDE"	, STR0279   } ) // "Marca 'x' se Endereco for Comercial"
	aAdd( aExp, {'GPE_TIPO_ENDERECO_RES'	,SRA->(IF(RA_TIPENDE$"2","x" ,""))																,"SRA->RA_TIPENDE"	, STR0280   } ) // "Marca 'x' se Endereco for Residencial"	
	aAdd( aExp, {'GPE_NUM_ENDERECO'			,SRA->RA_NUMENDE																				,"SRA->RA_NUMENDE"	, STR0281   } ) // "Numero do Endereco"
	aAdd( aExp, {'GPE_CAIXA_POSTAL'			,SRA->RA_CPOSTAL																				,"SRA->RA_CPOSTAL"	, STR0282  	} ) // "Caixa Postal"
 	aAdd( aExp, {'GPE_CEP_CAIXA_POSTAL'		,SRA->RA_CEPCXPO																				,"SRA->RA_CEPCXPO"	, STR0283	} ) // "CEP da Caixa Postal" 
 	aAdd( aExp, {'GPE_DDD_TELEFONE'			,SRA->RA_DDDFONE																				,"SRA->RA_DDDFONE"	, STR0284   } ) // "DDD do Telefone"
	aAdd( aExp, {'GPE_DDD_CELULAR'			,SRA->RA_DDDCELU																				,"SRA->RA_DDDCELU"	, STR0285   } ) // "DDD do Celular"
	aAdd( aExp, {'GPE_NUM_CELULAR'			,SRA->RA_NUMCELU																				,"SRA->RA_NUMCELU"	, STR0286   } ) // "Numero do Celular"
   	aAdd( aExp, {'GPE_EMPRESA_TIPO_CNPJ'	,IF(aInfo[15]==2,"x","")																		,"@!"				, STR0287	} ) // "Marca 'x' se Empresa por CNPJ"
   	aAdd( aExp, {'GPE_EMPRESA_TIPO_CEI'		,IF(aInfo[15]==1,"x","")																		,"@!"				, STR0288	} ) // "Marca 'x' se Empresa por CEI"
	aAdd( aExp, {'GPE_DATA_CHEGADA'			,SRA->RA_DATCHEG																				,"SRA->RA_DATCHEG"	, STR0289   } ) // "Data de Expedicao do RIC"   	
	aAdd( aExp, {'GPE_SECAO'				,SRA->RA_SECAO												  									,"SRA->RA_SECAO"	, STR0290  	} ) // "Secao Eleitoral"
	aAdd( aExp, {'GPE_INST_DCN'				,cGrauInstr																						,"@!"				, STR0291	} ) // "Grau de Instrucao conforme NIS/PIS"
	aAdd( aExp, {'GPE_PAIS_ORIGEM_PIS'		,SRA->(IF(RA_NACIONA<>"10" .OR. RA_BRNASEX=="1",fDesc("CCH",SRA->RA_CPAISOR,"CCH_PAIS"),""))	,"SRA->RA_PAISORI"	, STR0292   } ) // "Pais de Origem para o DCN/DMN"    
	aAdd( aExp, {'GPE_COD_UF_NASCTO_PIS'	,SRA->(IF(RA_NACIONA=="10" .AND. RA_BRNASEX<>"1",SRA->RA_NATURAL,""))	    					,"SRA->RA_NATURAL"	, STR0308   } ) // "Estado de Nascimento NIS/PIS"     
	aAdd( aExp, {'GPE_MUNICIPIO_NASCTO_PIS'	,SRA->(IF(RA_NACIONA=="10" .AND. RA_BRNASEX<>"1",SRA->RA_MUNNASC,""))							,"SRA->RA_MUNNASC"	, STR0309	} ) // "Municipio de Nascimento NIS/PIS"	
	aAdd( aExp, {'GPE_TIPO_MANUT_NIS_ALTER'	,IF(cTipNIS=="1","x","")																		,"@!"				, STR0310	} )	// "Marca 'x' para tipo de DMN - Alteracao"	
	aAdd( aExp, {'GPE_TIPO_MANUT_NIS_CADAS'	,IF(cTipNIS=="2","x","")																		,"@!"				, STR0311	} )	// "Marca 'x' para tipo de DMN - Cadastro Retroativo"	
	aAdd( aExp, {'GPE_TIPO_MANUT_NIS_CANCE'	,IF(cTipNIS=="3","x","")																		,"@!"				, STR0312	} )	// "Marca 'x' para tipo de DMN - Cancelamento"	
	aAdd( aExp, {'GPE_TIPO_MANUT_NIS_REATI'	,IF(cTipNIS=="4","x","")																		,"@!"				, STR0313	} )	// "Marca 'x' para tipo de DMN - Reativacao"
	aAdd( aExp, {'GPE_TIPO_MANUT_NIS_RETRO'	,IF(cTipNIS=="5","x","")																		,"@!"				, STR0314	} )	// "Marca 'x' para tipo de DMN - Retroacao Cadastral"	
	aAdd( aExp, {'GPE_COD_SEXO_MASCULINO'	,SRA->(IF(RA_SEXO=="M","x",""))																, "SRA->RA_SEXO"	, STR0315	} )	// "Marca 'x' se sexo for Masculino" 
	aAdd( aExp, {'GPE_COD_SEXO_FEMININO'	,SRA->(IF(RA_SEXO=="F","x",""))																, "SRA->RA_SEXO"	, STR0316	} )	// "Marca 'x' se sexo for Feminino" 

EndIf

Return( aExp )


//зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
//ЁFun┤└o    ЁGetQuery  Ё Autor ЁFlor - HUB MИxico      Ё Data Ё15/09/2011Ё
//цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
//ЁDescri┤└o ЁRetorna Informacoes da Definicao de Tabelas                 Ё
//цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//Ё          ЁaExp[x,1] - Variavel Para utilizacao no Word (Tam Max. 30)  Ё
//Ё          ЁaExp[x,2] - Conteudo do Campo                (Tam Max. 49)  Ё
//Ё          ЁaExp[x,3] - Campo para Pesquisa da Picture no X3 ou Picture Ё
//Ё          ЁaExp[x,4] - Descricao da Variaval                           Ё
//юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function GetQuery(cQuery)

Local cDes:=""
Local cAliasTmp:=CriaTrab(Nil,.F.)

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.) 
(cAliasTmp)->(dbgotop())
IF(cAliasTmp)->(!EOF())
	cDes:=(cAliasTmp)->CONTEU
EndIf
	(cAliasTmp)->( dbCloseArea()) 
Return cdes

/*
зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁAjustaSX1 Ё Autor ЁRicardo Berti          Ё Data Ё11/11/2011Ё
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁAjusta Perguntas 											Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function AjustaSX1()

Local aArea		:= GetArea()

dbSelectArea("SX1")
If dbSeek(cPerg+"08") .And. Trim(X1_HELP) <> ".RHNOMEA."
	RecLock("SX1",.F.)
	SX1->X1_HELP	:= ".RHNOMEA."
	MsUnlock()
EndIf
RestArea(aArea)

Return( Nil )

/*                                	
зддддддддддбддддддддддддддддбдддддбдддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    Ё fValSX3SRA  	ЁAutorЁ Emerson Campos    Ё Data Ё09/02/2012Ё
цддддддддддеддддддддддддддддадддддадддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o Ё Valida necessidade de execucao do update para Disponibili- Ё
Ё          Ё zacao dos campos RA_HABILIT e RA_COMPLEM para o Equador.   Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё < Vide Parametros Formais >							    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё Uso      Ё GPEWORD                                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё Retorno  Ё lRet														Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ < Vide Parametros Formais >								Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static Function fValSX3SRA()
Local aGetArea	:= GetArea()
Local aAreaSX3	:= SX3->( getarea() )
Local lRet		:= .F.

If cPaisLoc == "EQU"
	dbSelectArea( "SX3" )
	SX3->( dbSetOrder( 02 ) )
	SX3->( DbSeek( "RA_HABILIT" ) )
	If AllTrim( SX3->X3_USADO ) == "ЪЪu═─▀nA─────┐─"	
		SX3->( dbGoTop() )
		SX3->( DbSeek( "RA_COMPLEM" ) )
		If AllTrim( SX3->X3_USADO ) == "ЪЪu╓─▐nA─│───┐─"
			lRet := .T.
		EndIf*/		
	EndIf 
Else
	//Para os demais paises, nao hА necessidade
	lRet := .T.
EndIf

// Restaura Areas
RestArea( aAreaSX3 )
RestArea( aGetArea )
Return  lRet

/*                                 
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤└o    ЁfOpTipPIS Ё Autor Ё Claudinei Soares      Ё Data Ё 12/12/12 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤└o Ё Opcoes dos Tipos de NIS para o cadastro de PIS			  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё GPEWORD                                                    Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function fOpTipPis()

Local cTitulo	:= "" 
Local MvParDef	:= ""
Local MvPar
Local lRet	    := .T.

Private aInc	:={}

If Alltrim(ReadVar() )= "MV_PAR30"	

	MvPar		:=	&(Alltrim(ReadVar()))	 		    // Carrega Nome da Variavel do Get em Questao
	mvRet		:=	Alltrim(ReadVar())			 	    // Iguala Nome da Variavel ao Nome variavel de Retorno
	aInc		:=	{STR0322,STR0323,STR0324,STR0325,STR0326,STR0327}// "Nenhum";"Alteracao";"Cadastro Retroativo";"Cancelamento";
														//"Reativacao";"Retroacao Cadastral"
	MvParDef	:=	"012345"
	cTitulo		:=	STR0321							  	//"Informe o Tipo de Alteracao do NIS-PIS"

	f_Opcoes(@MvPar,cTitulo,aInc,MvParDef,12,49,.T.)  	// Chama funcao f_Opcoes

	&MvRet := mvpar										// Devolve Resultado

EndIf

Return(.T.)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁfChkUpd   Ё Autor Ё Marcelo Silveira	    Ё Data Ё 08/10/12 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Checa se atualizacoes foram processadas no ambiente        Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      ЁImpedir a execucao da rotina caso falte alguma atualizacao. Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/  
Static Function fChkUpd( cMsg )

DEFAULT cMsg := ""

//Retorna as informacoes sobre a atualizacao que precisa ser executada pelo RHUPDMOD
If cPaisLoc == "BRA"
	If !CpoUsado( "RA_BRNASEX" )
		cMsg := fRhUpdMsg( 206 )
	EndIf
EndIf

Return(cMsg)
