#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 17/11/00
#IFDEF WINDOWS
	 #include "Dialog.ch"
#ELSE
	 #include "INKEY.CH"
#ENDIF

#include "RAUMSAL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RAUMSAL   º Autor ³Mauricio MR         º Data ³  21/09/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime Aumentos Salariais de Acordo com os Tipos Definidosº±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Program.  ³ Data   ³ BOPS ³  Motivo da Alteracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Natie    ³07/09/02³v 7.10³Exclusao ValidPerg()                        ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Siga                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RAUMSAL()      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,TITULO,AT_PRG")
SetPrvt("CONTFL,LI,NTAMANHO,LEND,AINFO")
SetPrvt("WNREL,NORDEM,CFILDE,CFILATE,CCCDE,CCCATE")
SetPrvt("CMATDE,CMATATE,CNOMEDE,CNOMEATE,DPERDE,DPERATE")
SetPrvt("CTIPODE,CTIPOATE,NULTIMOS,LSALTA")
SetPrvt("WCABEC0,WCABEC1,WCABEC2,CBTXT,NVALSALARIO,NRECNO")
SetPrvt("CFILIALANT,CANOMESATU,LIMPMESATU,CARQTMP,CINDCOND")
SetPrvt("CARQNTX,CFOR,CTMPFILIAL,CTMPMAT,CTMPNOME,CTMPCC")



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Basicas)                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString:="SRA"                      // alias do arquivo principal (Base)
aOrd   := {STR0001,STR0002,STR0003} //"Matricula"###"C.Custo"###"Nome"
cDesc1 := STR0004       //"Emissao demonstrativa das alteracoes salariais."
cDesc2 := STR0005       //"Ser  impresso de acordo com os parametros solicitados pelo"
cDesc3 := STR0006       //"usu rio."

aReturn := {STR0007, 1,STR0008, 2, 2, 1, "",1 }    // "Zebrado"###"Administra‡„o"
nomeprog:= "RAUMSAL"
aLinha  := {}
nLastKey:= 0
cPerg   := "RAUMSA"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo   := STR0009        //"DEMONSTRATIVO DAS ALTERACOES SALARIAIS"
AT_PRG   := "RAUMSAL"
CONTFL   := 1
Li       := 0                          
nTamanho := "M"
lEnd     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Programa)                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aInfo := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("RAUMSA",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "RAUMSAL"       //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem    := aReturn[8]
cFilDe    := mv_par01				//-- Filial  De 
cFilAte   := mv_par02  				//-- Filial  Ate
cCcDe     := mv_par03  				//-- C.Custo De 
cCcAte    := mv_par04  				//-- C.Custo Ate
cMatDe    := mv_par05  				//-- Matricula De 
cMatAte   := mv_par06  				//-- Matricula Ate
cNomeDe   := mv_par07  				//-- Nome De
cNomeAte  := mv_par08  				//-- Nome Ate  
cSituacao := mv_par09   			//-- Situacoes  
cCategoria:= mv_par10   			//-- Categorias   
dPerDe    := mv_par11  				//-- Periodo De
dPerAte   := mv_par12  				//-- Periodo Ate 
cTipo     := mv_par13  				//-- Tipo Aumento De 
nUltimos  := mv_par14  				//- Ultimos Aumentos
lSalta    := If( mv_par15 == 1 , .T. , .F. )  			//-- C.C. em outra Pagina 
lListaSemAumento:= If( mv_par16 == 1 , .T. , .F. )  	//-- Lista Funcionario Sem Aumento
lTotFunc  := If( mv_par17 == 1 , .T. , .F. )			//-- Lista Totais por Funcionario 

Titulo    := STR0009 //"DEMONSTRATIVO DAS ALTERACOES SALARIAIS"
wCabec0   := 2
wCabec1   := STR0011 
wCabec2	  := STR0012
         

/*
 FIL C. CUSTO  MATRIC. NOME DO FUNCIONARIO            FUNCAO   					   DATA	   VINCULO          SALARIO %AUMENTO MOTIVO
															          
 12  123456789 123456  123456789012345678901234567890 1234-1234567890124567890 99/99/9999   99/99   999,999.999.99    99.99    001 
 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
           1        2         3         4         5         6         7         8         9         10        11        12        13
*/

If nLastKey == 27
	Return Nil
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

#IFDEF WINDOWS
	RptStatus({|| GPERImp() },Titulo)// Substituido pelo assistente de conversao do AP5 IDE em 17/11/00 ==> 	RptStatus({|| Execute(GPERImp) },Titulo)
#ELSE
	GPERImp()
#ENDIF

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPERImp  ³ Autor ³ Mauricio MR           ³ Data ³ 24/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Alteracoes Salarias do Periodo Selecionado   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GPERImp()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RDmake                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GPERImp()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nCont   		:= 	0
Local nValSalario	:=	0
Local nRecSR7		:=	0
Local aFixo			:=	{}
Local aAumentos		:=	{}
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis de Acesso do Usuario                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "RAUMSAL" , "SRA" , "2" ) + " } " )

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis Totalizadoras                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Private aPosicao	:=	{}
Private aTotCc1		:=	{}
Private aTotFil1	:=	{}
Private aTotEmp1	:=	{}


//Seleciona o Indice Escolhido
dbSelectArea( "SRA" )
If nOrdem == 1
	dbSetOrder( 1 )
ElseIf nOrdem == 2
	dbSetOrder( 2 )
ElseIf nOrdem == 3
	DbSetOrder(3)
Endif

DbGoTop()

//Inicializa variaveis auxiliares de ordem do Relatorio
If nOrdem == 1
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim    := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	DbSeek(cFilDe + cNomeDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomeAte + cMatAte
Endif

cFilialAnt := "  "
cCcAnt     := Space(9)

//Corre Todo o Cadastro de Funcionarios 
dbSelectArea( "SRA" )
SetRegua(SRA->(RecCount()))

While   !EOF() .And. &cInicio <= cFim
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif	 

	//Verifica Quebra de Filial
	If SRA->RA_FILIAL # cFilialAnt
	    //Alimenta Matriz com informacoes da Filial a ser utilizada na impressao
	    //do cabec
	    If !fInfo(@aInfo,SRA->RA_FILIAL)
		    Exit
	    Endif
	    dbSelectArea( "SRA" )
	    cFilialAnt := SRA->RA_FILIAL
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 If (Sra->Ra_Nome < cNomeDe) .Or. (Sra->Ra_Nome > cNomeAte) .Or. ;
	    (Sra->Ra_Mat < cMatDe)   .Or. (Sra->Ra_Mat > cMatAte) .Or. ;
	    (Sra->Ra_CC < cCcDe)     .Or. (Sra->Ra_CC > cCCAte)
	   
            fTestaTotal()			 
            Loop
	 EndIf
	    
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Consiste Filiais e Acessos                                             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF !( SRA->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
		fTestaTotal()			 	
	   	Loop
	EndIF

	   
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Verifica Situacao do Funcionario            			     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If  !( SRA->RA_SITFOLH $ cSituacao )  .OR. !( SRA->RA_CATFUNC $ cCategoria )
	    fTestaTotal()
	    Loop
    Endif                
    
    //-- Guarda Identificacao do Funcionario 
    aFixo:={} //-- Retire essa Linha para Guarda as Informacoes Cabec de Todos os
              //-- Funcionarios Lidos
              
    AADD(aFixo,{SRA->RA_FILIAL,SRA->RA_MAT,SRA->RA_NOME,SRA->RA_CC,SRA->RA_Salario,;
                        SRA->RA_Admissa,SRA->RA_CodFunc,fDesc("SRJ",SRA->RA_CodFunc,"RJ_DESC")})
                  
    //-- Obtem Historico Salarial
    fHistorico(@aAumentos)

    //Restaura processamento para o Cadastro de Funcionarios
    dbSelectArea( "SRA" )
    
    //Se a variavel estiver Vazia significa que nao encontramos nenhum lancamento
    //de acordo com os parametros solicitados 
    //-- Se o Usuario nao deseja Listar nem mesmo o salario base desconsidera o funcionario
    If Empty(aAumentos) 
       If !lListaSemAumento
          fTestaTotal()
	      Loop
	   Endif   
    Endif                 
    
		 
   
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Atualizando Totalizadores                                    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    fAtuCont(@aToTCc1)  // Centro de Custo
    fAtuCont(@aTotFil1) // Filial
    fAtuCont(@aTotEmp1) // Empresa

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Impressao do Funcionario                                     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    fImpFun(@aFixo,@aAumentos)

    fTestaTotal()  // Quebras e Skips
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do Relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA" )
Set Filter to
dbSetOrder(1)
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()
                
RETURN NIL                                                                      

//*----------------------------------------------------*
Static Function fHistorico(aAumentos)
//*----------------------------------------------------*
Local aArea 		:= 	GetArea()
Local nValSalario	:= 	0
Local nSalAnt		:=	0
Local nPerc			:=	0
Local cVinculo		:=	''
Local nTam			:=	0
Local nI			:=	0
Local aSal			:=	{}

//Posiciona nos registros de aumento Salarial do funcionario lido
dbSelectArea( "SR7" )
SR7->( dbSeek( SRA->RA_FILIAL+SRA->RA_MAT ) )
    
aAumentos:={}
While SR7->(!Eof()) .AND. (SR7->R7_FILIAL + SR7->R7_MAT == SRA->RA_FILIAL + SRA->RA_MAT)
      
 	  //-- Obtem Salario
 	  fObtemSal(@nValSalario)                                       
 	  nTam:=Len(aAumentos)
 	  //--Calcula Temp de Vinculo e Percentual de Aumento
 	  //-- Sempre em relacao ao ultimo salario e data aumento lidos
 	  If nTam>0
 	     nSalAnt	:=	aAumentos[nTam,5]
 	     cVinculo	:=	fAnoMes(aAumentos[nTam,1],SR7->R7_DATA)
 	     //Se o Salario Anterior for Nulo
 	     //o Perc de aumento eh nulo tambem
 	     If EMPTY(nSalAnt)
 	     	nPerc	:=	0
 	     ElseIf nValSalario>=aAumentos[nTam,5]
 	     	nPerc	:=	Round( ( (nValSalario/aAumentos[nTam,5]) -1  ) * 100,2)
 	     Else
 	     	nPerc	:=	Round( ( (aAumentos[nTam,5]/nValSalario)* 100) * (-1),2)
 	     
 	     Endif
 	  Else
 	  	 cVinculo	:=	fAnoMes(SRA->RA_ADMISSA,SR7->R7_DATA)
 	  	 nPerc		:=	0
 	  	 nSalAnt	:=	0
 	  Endif   
 	  
 	  AADD(aAumentos,{SR7->R7_DATA, SR7->R7_TIPO, SR7->R7_FUNCAO,SR7->R7_DESCFUN,nValSalario,cVinculo,nPerc,nSalAnt})
 	 
 	  SR7->(dbSkip())
Enddo    
  
aSal:={}
//Filtra Aumentos Salariais de acordo com os parametros
For nI:=1 TO Len(aAumentos)
	If  !(aAumentos[nI,2] $cTipo)  .Or. ;
   	  (aAumentos[nI,1] < dPerDe)  .Or. (aAumentos[nI,1] > dPerAte)     
 	    Loop
 	EndIf
 	//Copia Somente os Aumentos Salariais que enquadram nos paramentros selecionados
 	//pelo usuario
 	AADD(aSal,aClone(aAumentos[nI]))
Next nI

//Retorna apenas os Aumentos desejados
aAumentos:=Aclone(aSal)


RestArea(aArea)
Return  .T.

//*--------------------------------------*
Static Function fObtemSal(nValSalario)
//*--------------------------------------*
Local aArea := GetArea()
nValSalario := 0

dbSelectArea( "SR3" )
dbSetOrder(1)
dbSeek(SR7->R7_FILIAL+SR7->R7_MAT+Dtos(SR7->R7_DATA)+SR7->R7_TIPO)
While SR7->R7_FILIAL+SR7->R7_MAT+Dtos(SR7->R7_DATA)+SR7->R7_TIPO==;
	  SR3->R3_FILIAL+SR3->R3_MAT+Dtos(SR3->R3_DATA)+SR3->R3_TIPO
	  If SR3->R3_PD=='000'
	  	nValSalario := SR3->R3_VALOR
	    Exit
	  Endif	
	  SR3->(dbSkip())
EndDo
RestArea(aArea)

Return .T.


*--------------------------*
Static Function fTestaTotal
*--------------------------*
dbSelectArea( "SRA" )
cFilialAnt := SRA->RA_FILIAL              // Iguala Variaveis
cCcAnt     := SRA->RA_CC
dbSkip()

If  Eof() .Or. &cInicio > cFim
	fImpCc()
	fImpFil()
	fImpEmp()
Elseif cFilialAnt # SRA->RA_FILIAL
	fImpCc()
	fImpFil()
Elseif cCcAnt # SRA->RA_CC
	fImpCc()
Endif

Return Nil

*------------------------*
Static Function fImpFun(aFixo,aAumentos)
*------------------------*
Local lRetu1 	:= .T.

//Bloco para reorganizar o Historico Salarial    
Local bSort	  	:= { |x,y|	Dtos(x[1])	>  Dtos(y[1])	 }

Local nFim		:=	0 	//-- Qtde Final de Aumentos a Lista
Local nI		:=	0 	//-- Qtde Inicial de Aumentos
Local nAumento  :=	0 	//-- Total de Aumentos
Local nJ		:=	0	//-- Dados do Funcionario Corrente
Local aTotFunc	:=	{0,0} 	//-- Totalizacoes do Funcionario	

//-- LAYOUT de IMPRESSAO

//FIL#C.CUSTO###MATRIC.#NOME#DO#FUNCIONARIO#############DATA####TEMPO#MOTIVO##################%AUMENTO#####SAL.ANTERIOR########SALARIO"
//##############################################################AA/MM#################################################################
//                                                                                                                      999.999.999,99 
//12##123456789#123456##123456789012345678901234567890                                                                  999.999.999,99
//######FUNCAO ->######1234-1234567890124567890#####99/99/9999#99/99#123-12345678901234567890#9999.99###999.999.999,99 999.999.999,99

//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//         1         2         3         4         5         6         7         8         9         10        11        12       13

//Imprime Cabec de Funcionario  
nJ:=Len(aFixo)
cDet	:= 	aFixo[nJ,1]+SPACE(2)+aFixo[nJ,4]+SPACE(01)+aFixo[nJ,2]
cDet	+= 	SPACE(02)+Left(aFixo[nJ,3],30)+SPACE(03)
cDet	+= 	STR0013+SPACE(1)+PADL(DtoC(aFixo[nJ,6]),10)+SPACE(3)+STR0014+'('+STR0015+")-> "
cDET	+=	fAnoMes(aFixo[nJ,6],Date())+SPACE(14)+TRANSFORM(aFixo[nJ,5],"@E 999,999,999.99") 
Impr(cDet,"C")
                                
//-- Imprime Funcao
cDet:=PADL(STR0010,16)+SPACE(2)+aFixo[nJ,7]+'-'+aFixo[nJ,8]+SPACE(1)+STR0022  // "FUNCAO ->"
Impr(cDet,"C")
cDet:=''

//Imprime Historico Salarial
nAumento:=Len(aAumentos)
aSort(aAumentos,,, bSort )                        
                           

//-- Verifica se os Aumentos(nAumentos) superam o limite de aumentos (nUltimos) a ser
//-- considerado na Impressao do historico

nFim:= iif (nAumento< nUltimos,nAumento,nUltimos)
//-- Corre Aumentos
For nI:=1 To nFim
	
	//-- Para a Ultima Linha Nao Imprime Tempo entre aumentos e Percentual 
	//-- Se ela nao for o primeiro aumento apos a admissao
	If nI==nFim .AND. nFim <> nAumento
	   cTempo	:=	SPACE(5)
	   //cAumento	:=	SPACE(7)
	Else
	   cTempo	:=	aAumentos[nI,6]
    Endif
    cAumento	:=	TRANSFORM(aAumentos[nI,7],"@E 99999.99") 	
	//-- Calcula TEMPO, em MESES, dos  Aumentos Salariais do Func.
	aTotFunc[1]+= Val(Substr(aAumentos[nI,6],1,2))*12 + Val(Substr(aAumentos[nI,6],4,5))	
	//-- Calcula total de PERCENTUAL de AUMENTO no Periodo
	aTotFunc[2]+= aAumentos[nI,7]
	                     
	//-- Assegura que Totais sejam impressos na mesma pagina
	If Li-4>53
		Impr("","P")
	Endif
	//-- Imprime Aumento	
    cDet	:= SPACE(18)+aAumentos[nI,3]+'-'+aAumentos[nI,4]+SPACE(06)
	cDet	+= PADL(DtoC(aAumentos[nI,1]),10)+SPACE(1)+cTempo+SPACE(1)+aAumentos[nI,2]+'-'+Left(fDesc("SX5","41"+aAumentos[nI,2],"X5_DESCRI"),20)+SPACE(01)+cAumento
	cDet	+= SPACE(3)+TRANSFORM(aAumentos[nI,8],"@E 999,999,999.99") + SPACE(1)+TRANSFORM(aAumentos[nI,5],"@E 999,999,999.99")  
	Impr(cDet,"C")
Next  

If lTotFunc
	//-- Imprime Total do Funcionario	
	cDet := Repl("-",132)
	Impr(cDet,"C")
	
	cDet	:= PADR(STR0016 + SPACE(2)+ Left(aFixo[nJ,3],30),60)+fAnoMes(,,aTotFunc[1]) + SPACE(26) + TRANSFORM(aTotFunc[2],"@E 99999.99") 	
	Impr(cDet,"C")
	
	cDet := Repl("-",132)
	Impr(cDet,"C")
Else
	cDet := Repl("-",132)
	Impr(cDet,"C")
Endif


cDet:=''

Return Nil

*-----------------------*
Static Function fImpCc()
*-----------------------*
Local lRetu1 := .T.

If  Len(aTotCc1) == 0 .Or. nOrdem # 2
	Return Nil
Endif

cDet := Repl("-",132)
Impr(cDet,"C")
cDet := STR0017+ cCcAnt +" - "+DescCc(cCcAnt,cFilialAnt) + Space(11)		//"TOTAL C.CUSTO -> "
lRetu1 := fImpComp(aTotCc1) // Imprime

aTotCc1 :={}      // Zera

cDet := Repl("-",132)
Impr(cDet,"C")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salta de Pagina na Quebra de Centro de Custo (lSalta = .T.)  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lSalta
	Impr("","P")
Endif

Return Nil

*------------------------*
Static Function fImpFil()
*------------------------*
Local lRetu1 := .T.
Local cDescFil

If  Len(aTotFil1) == 0
	Return Nil
Endif

If  nOrdem # 2
	cDet := Repl("-",132)
	Impr(cDet,"C")
Endif

cDescFil := aInfo[1] 
cDet     := STR0018 + cFilialAnt+" - " + cDescFil + Space(24)	//"TOTAL FILIAL -> "

lRetu1 := fImpComp(aTotFil1) // Imprime

aTotFil1 :={}      // Zera

cDet := Repl("-",132)

Impr(cDet,"C")

Impr('',"P")

Return Nil

*------------------------*
Static Function fImpEmp()
*------------------------*
Local lRetu1 := .T.

If  Len(aTotEmp1) == 0
	Return Nil
Endif

cDet := STR0019+aInfo[3]+Space(4)	//"TOTAL EMPRESA -> "

lRetu1 := fImpComp(aTotEmp1) // Imprime

aTotEmp1 :={}      // Zera

cDet := Repl("-",132)
Impr(cDet,"C")

Impr("","F")

Return Nil
                                   
*-------------------------------------------------------------*
Static Function fImpComp(aPosicao) // Complemento da Impressao
*-------------------------------------------------------------*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Resultado de Impressao para testar se tudo nao esta zerado   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nResImp := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Auxiliar para Tratamento do Bloco de Codigo                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AeVal(aPosicao,{ |X| nResImp += X[1] })  // Testa se a Soma == 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime se Possui Valores                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  nResImp > 0
	cDet += TRANSFORM(aPosicao[1,1],"@E 999,999,999")
	cDet += If( aPosicao[1,1] == 1 ,STR0020,STR0021)	//"  FUNCIONARIO"###"  FUNCIONARIOS"
	Impr(cDet,"C")
	Return( .T. )
Else
	Return( .F. )
Endif
Return .T.

*---------------------------------------------------------*
Static Function fAtuCont(aArray1)  // Atualiza Acumuladores
*---------------------------------------------------------*
If  Len(aArray1) > 0
	aArray1[1,1] += 1
Else
	aArray1      :=Aclone({{1}})
Endif

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fAnoMes  ³ Autor ³ Mauricio MR           ³ Data ³ 24/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula Dif. Entre Datas e Retorna Ano e Mes no form. AA/MM³±±
±±³          ³ ou Retorna Ano e Mes se Meses for Passado.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fAnoMes(Data Ini, Data Fim, nMese)  --> cAnoMes            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RDmake                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fAnoMes(dDataI, dDataF,nMeses)

Local nAno		:=	0
Local nMes  	:=	0
Local cAnoMes 	:=	''

If nMeses==Nil 
   nMeses:=0
Else
   If Empty(nMeses)
      Return('00/00')
   Endif
Endif


//Se a Qtde de Meses Nao for Passada, Calcula
If EMPTY(nMeses)
	nMeses	:=	fMesesTrab(dDataI,dDataF) 
Endif
	
nAno	:=	Int(nMeses/12) 
nMes	:= ((nMeses/12)-nAno) * 12
cAnoMes	:= 	STRZERO(nAno,2)+'/'+STRZERO(nMes,2)
Return (cAnoMes)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMesesTrabºAutor  ³Microsiga           º Data ³  08/31/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calcula os Meses trabalhado entre duas datas considerando   º±±
±±º          ³um mes para cada 15 dias trabalhados dentro do mes.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fMesesTrab(dDtIni,dDtFim)  

Local nAno
Local nMeses
Local nDias
Local nUltDia := If (! Empty(dDtIni),F_ULTDIA(dDtIni),30)

nAno 	:= Year(dDtFim) - Year(dDtIni) 
nMeses 	:= nAno * 12
nMeses	+= Month(dDtFim) - Month(dDtIni)  
nMeses  -= 1                                                                

If MesAno(ddtini) == mesAno(ddtFim)
	nDias := Day(dDtFim) - Day(dDtIni)  + 1
	If nDias > 15
		nMeses ++
	Endif	
Else
	If (nUltdia - day(ddtini) + 1) >= 15 
		nMeses ++
	Endif	
	If Day(dDtFim) >= 15
		nMeses ++
	Endif
Endif	
nMeses := If (nMeses < 0,0,nMeses)
Return nMeses	



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fCodAum   ³ Autor ³ Mauricio MR    		³ Data ³ 26/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecionar Tipos de Aumento                              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fCodAum()  												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Function fCodAum(l1Elem)

Local cTitulo	:=	""
Local MvPar
Local MvParDef	:=	""
Local oWnd
Local MvRetor	:= 	""
Local MvParam	:= 	"" 
Local nAuxFor	:= 	1
Local nFor		:= 0
Local I			:= 0 
Local aArea		:=	{}

Private aCod	:=	{}

l1Elem 	:= If (l1Elem = Nil , .F. , .T.)

oWnd 	:= GetWndDefault()

aArea	:=	GetArea()				// Salva Alias Anterior
MvPar	:=&(Alltrim(ReadVar()))	// Carrega Nome da Variavel do Get em Questao
mvRet	:=  Alltrim(ReadVar())		// Iguala Nome da Variavel ao Nome variavel de Retorno

If !l1Elem 
	For nFor := 1 TO Len(alltrim(MvPar))
		Mvparam += Subs(MvPar,nAuxFor,3)
		MvParam += Replicate("*",3)
		nAuxFor := (nFor * 3) + 1
	Next
Endif
mvPar 	:= MvParam


dbSelectArea("SX5")
cChave:=If(Empty(xFilial('SX5')), Space(2), cFilial)+'41'

If DbSeek(cChave)
	While !Eof() .and. cChave == SX5->X5_FILIAL+SX5->X5_TABELA
		Aadd(aCod,SX5->X5_CHAVE+ " - "+SX5->X5_DESCRI)
		MvParDef+=Left(SX5->X5_CHAVE,3)         
		dbSkip(	)
	Enddo 
Else
	Help(" ",1,"")	 //Cadastro de Aumentos Nao Existe para a Filial 
	RestArea(aArea)
	Return(.F.) 	
Endif
f_Opcoes(@MvPar,cTitulo,aCod,MvParDef,12,49,l1Elem,3,10)

For I=1 to len(mvpar) step 3
	If substr(mvpar,I,3) # "***"
		mvRetor += substr(mvpar,I,3)  
	Endif
Next 
	
&MvRet :=alltrim(Mvretor)	//Devolve Resultado
RestArea(aArea) 		 	//Retorna Alias
Return .T.