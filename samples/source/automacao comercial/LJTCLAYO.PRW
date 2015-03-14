#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 12/07/00
#INCLUDE "FiveWin.ch"
#INCLUDE "LJENCNAB.CH"
#INCLUDE "PROTHEUS.ch"

User Function ljencnab()        // incluido pelo assistente de conversao do AP5 IDE em 12/07/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,NTAMARQ,NTAM,NDEC,NLIDOS,CBUFFER")
SetPrvt("LRESP,LHEADER,LFIRST,LGRAVA,ABORDERO,NHDLBCO")
SetPrvt("NHDLSAIDA,CINDD2,CCHAVD2,NINDD2,CCONTEUDO,EXPL1")
SetPrvt("CCAMPO,BBLOCK,BERRO,LRET,XCONTEUDO,CFILTRO")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/07/00 ==> #INCLUDE "FiveWin.ch"
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/07/00 ==> #INCLUDE "LJENCNAB.CH"
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/07/00 ==> #INCLUDE "PROTHEUS.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LjEnCnab ³ Autor ³ Almeida               ³ Data ³ 20/05/90 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite ativar a funcao de envio de arquivo LjGerCnab      ³±±
±±³          ³ Manualmente.                                               ³±±
±±³          ³ com base nos arquivos  SL2 -[SD2]- SF2 - SA1               ³±±
±±³          ³ onde SD2 e o arquivo no qual faremos o filtro              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LjEnvCnab()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 12/07/00

// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> Function  LJENCNAB()
Static Function  LJENCNAB()
Local cPerg      := "LECNAB"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
If !Pergunte(cPerg,.T.)
   Return
Endif   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01		 // Da Emissao         ³
//³ mv_par02		 // Ate o Emissao      ³
//³ mv_par03		 // Arq.Config 	     ³
//³ mv_par04       // Arq. Saida         ³
//³ mv_par05		 // Configuracao Cnab  ³
//³ mv_par06		 // De Filial          ³
//³ mv_par07		 // Ate Filial         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LjGerCnab(mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07)

Return (.T.)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LjGerCnab³ Autor ³ Almeida               ³ Data ³ 10/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ - Gera‡„o do Arquivo de Envio com base nos sequintes       ³±±
±±³          ³   arquivos: SL2 -[SD2]- SF2 - SL1 - SA1 - SB1              ³±±
±±³          ³   onde SD2 e o centro sobre o qual faremos o filtro com    ³±±
±±³          ³   base nos parametros abaixo.                              ³±±
±±³          ³ - Esta funcao vai poder ser disparada manualmente atraves  ³±±
±±³          ³   da funcao LjEnvCnab ou disparada automaticamente exemp.  ³±±
±±³          ³   Via Work Flow.                                           ³±±
±±³          ³   Nesta funcao foi abolida qualquer uso de tela devido     ³±±
±±³          ³   futuramente ser acionada via WORK FLOW.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³   .T. Operacao Bem Sucedida                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³   MV_PAR01  -  Da Emissao                                  ³±±
±±³          ³   MV_PAR02  -  Ate Emissao                                 ³±±
±±³          ³   MV_PAR03  -  Arquivo Conf.                               ³±±
±±³          ³   MV_PAR04  -  Arq. Saida                                  ³±±
±±³          ³   MV_PAR05  -  Configuracao do Cnab                        ³±±
±±³          ³   MV_PAR06  -  De Filial                                   ³±±
±±³          ³   MV_PAR07  -  Ate Filial                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ LjGerCnab                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> Function LjGerCnab(mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07)
Static Function LjGerCnab(mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07)()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nTamArq           := 0
Local nTam              := 0
Local nDec              := 0
Local nLidos            := 0
Local cBuffer           := ""
Local lResp             :=.T.
Local lHeader           :=.F.
Local lFirst            :=.F.
Local lGrava            :=.T.
Local aBordero          := {}
Private nHdlBco         := 0  // Arquivo do Banco
Private nHdlSaida       := 0  // Arquivo de Saida

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta express„o do Filtro para sele‡„o	- SD2   		        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD2")
dbsetorder(5)
cIndD2 := CriaTrab(nil,.f.)
cChavD2:= IndexKey()
cChavD2:= "D2_FILIAL+DTOS(D2_EMISSAO)"
IndRegua("SD2",cIndD2,cChavD2,,LJCNABIn(),OemtoAnsi(STR0001))//          STR0001  "Selecionando Registros"
nIndD2 := RetIndex("SD2")
dbSelectArea("SD2")
#IFNDEF TOP
   dbSetIndex(cIndD2+OrdBagExt())
#ENDIF
dbSetOrder(nIndD2+1)
dbGoTop()
If BOF() .and. EOF()
   Help(" ",1,"RECNO")
   RetIndex("SD2")
   dbSetOrder(1)
   Set Filter to
   FErase (cIndD2+OrdBagExt())
   Return .F.
EndIf                                                         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a Abertura do Arquivos ASC II de Envio e Configuracao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lResp:=AbrePar(MV_PAR03,MV_PAR04,MV_PAR05)	
If !lResp
	Return .F.
Endif


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Arquivo de Com.Bancaria ³
³    Remessa/Retorno      ³
³                         ³
³ Memoria de Calculo      ³     ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Registro 1 - USUARIOS   ³     ³Identificadores          ³
³ - Identif    CHR(n)   1 ³     ³ CHR(1)   - Header       ³
³ - Descricao do Campo 15 ³     ³ CHR(2)   - Detalhe      ³
³ - Posicao Inical      3 ³     ³ CHR(3)   - Trailler     ³
³ - Posicao Final       3 ³     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
³ - Decimais            1 ³
³ - Campo/Conteudo     60 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/


DBGOTOP() 
While !Eof() 
      
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Movimenta todos os ponteiros de acordo com  SD2		        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      SF2->(DBSETORDER(1))                                // Cabecalho NF
      SF2->(DBSEEK(SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE))

      SL1->(DBSETORDER(2))                                // Cabecalho dos Itens
      SL1->(DBSEEK(SD2->D2_FILIAL+SD2->D2_SERIE+SD2->D2_DOC))

      SL2->(DBSETORDER(1))                                // Itens do Orcamento
      SL2->(DBSEEK(SD2->D2_FILIAL+SL1->L1_NUM+SD2->D2_ITEM))

      SA1->(DBSETORDER(1))                                // Clientes
      SA1->(DBSEEK(xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA))
  
      SA3->(DBSETORDER(1))                                // Fornecedor
      SA3->(DBSEEK(xFilial("SA3")+SL1->L1_VEND))

      SB1->(DBSETORDER(1))                                // Produto
      SB1->(DBSEEK(xFilial("SB1")+SD2->D2_COD))

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Ativar este ponto casa seja PC - Pagamento de Contas         ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      //IF SB1->B1_TIPO # "PC"                             // Pagamento de Conta
      //   SD2->(DBSKIP())
      //   LOOP
      //ENDIF      

      If ( MV_PAR05 == 1 )
         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Le Arquivo de Parametrizacao                                 ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		   nLidos:=0
		   FSEEK(nHdlBco,0,0)                                // Posiciona no Inicio do Arquivo  
		   nTamArq:=FSEEK(nHdlBco,0,2)                       // Traz o Tamanho do Arquivo TXT
		   FSEEK(nHdlBco,0,0)                                // Posicona novamemte no Inicio  
	
         While nLidos <= nTamArq

		        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			     //³ Verifica o tipo qual registro foi lido                       ³
			     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			     cBuffer:=Space(85)
			     FREAD(nHdlBco,@cBuffer,85)                   // Le 85 caracteres em cada Linha

			     Do Case
			        Case SubStr(cBuffer,1,1) == CHR(1)       // Haider
				          IF lHeader                            // Finalizou leitura do Heider
					          nLidos+=85
						       Loop
					       EndIF
				     Case SubStr(cBuffer,1,1) == CHR(2)       // Detalhes
        		          IF !lFirst                           //  Se todo detalhe ja tiver sido lido 
					          lFirst := .T.                     // Finaliza o operacao arquivo Detalhe.
						       FWRITE(nHdlSaida,CHR(13)+CHR(10))
					       EndIF
			        Case SubStr(cBuffer,1,1) == CHR(3)       // Trailler
					       nLidos+=85
					       Loop
			        Otherwise
				          nLidos+=85
					       Loop
			      EndCase

			      nTam := 1+(Val(SubStr(cBuffer,20,3))-Val(SubStr(cBuffer,17,3)))
			      nDec := Val(SubStr(cBuffer,23,1))
			      cConteudo:= SubStr(cBuffer,24,60)
                                                           // Quando entra aqui esta usando modelo 1
			      lGrava := LJ150Grava(nTam,nDec,cConteudo,@aBordero,MV_PAR05)

			      If !lGrava                                  // Caso o conteudo da expressao gere  
			         Exit                                     // Erro.
			      Endif
			      nLidos+=85

         EndDO
		   If !lGrava                                        // Abandonou a Linha e agora toda
		      Exit                                           // operacao caso conteudo com erro
		   Endif
      Else                   
                                                           // Guando entra aqui esta usando modelo 2
	 	   lGrava := LJ150Grava(,,,@aBordero,MV_PAR05)

	   EndIf

	   If lGrava
	      If ( MV_PAR05 == 1 ) 
	         fWrite(nHdlSaida,CHR(13)+CHR(10))
		    	IF !lHeader
			      lHeader := .T.
			   EndIF
		   Endif
	  Endif

     RecLock("SD2")
	  SD2->D2_ENVCNAB := dDataBase
     Dbcommit()
	  MsUnlock()
  
 	  SD2->(dbSkip())
EndDO
     

If ( MV_PAR05 == 1 )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Registro Trailler - Usando Modelo 1                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLidos:=0
	FSEEK(nHdlBco,0,0)
	nTamArq:=FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)
	While nLidos <= nTamArq

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tipo qual registro foi lido                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cBuffer:=Space(85)
		FREAD(nHdlBco,@cBuffer,85)

		IF SubStr(cBuffer,1,1) == CHR(3)
			nTam := 1+(Val(SubStr(cBuffer,20,3))-Val(SubStr(cBuffer,17,3)))
			nDec := Val(SubStr(cBuffer,23,1))
			cConteudo:= SubStr(cBuffer,24,60)
			lGrava:=LJ150Grava( nTam,nDec,cConteudo,@aBordero,MV_PAR05)
		 End
		 nLidos+=85
	End
Else
	RodaCnab2(nHdlSaida,MV_PAR03)                // Usando Modelo 2
EndIf

If ( MV_PAR05 == 1 )
	FWRITE(nHdlSaida,CHR(13)+CHR(10))            // Usando Modelo 1
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o arquivo gerado.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FCLOSE(nHdlBco)
FCLOSE(nHdlSaida)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o SD2 Filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SD2->(DBCLOSEAREA())

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AbrePar   ³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Abre arquivo de Parametros                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³AbrePar()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³LOJA150                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> Static Function AbrePar(MV_PAR03,MV_PAR04,MV_PAR05)
Static Static Function AbrePar(MV_PAR03,MV_PAR04,MV_PAR05)()
IF !FILE(MV_PAR03)
	Help(" ",1,"NOARQPAR")
	Return .F.
Else
	If ( MV_PAR05 == 1 )
		nHdlBco:=FOPEN(MV_PAR03,0+64)
	Endif
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo Saida                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( MV_PAR05 == 1 )
	nHdlSaida:=MSFCREATE(MV_PAR04,0)
Else
	nHdlSaida:=HeadCnab2(MV_PAR04,MV_PAR03)
Endif
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LJ150Grava³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Geracao do Arquivo de Remessa de Comunicacao      ³±±
±±³          ³Bancaria                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpL1:=LJ150Grava(ExpN1,ExpN2,ExpC1,ExpN3)                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ LOJA150                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> STATIC Function LJ150Grava( nTam,nDec,cConteudo,aBordero,MV_PAR05)
Static STATIC Function LJ150Grava( nTam,nDec,cConteudo,aBordero,MV_PAR05)()
Private xConteudo      
         
If ( MV_PAR05 == 1 )
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Analisa conteudo                                         ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   IF Empty(cConteudo)
      cCampo:=Space(nTam)
   Else
	   IF !LJ150Orig( cConteudo )
	   	 Return .f.
	   Else
	      do case
	         case ValType(xConteudo)="D"
		           cCampo := GravaData(xConteudo,.F.)
		      case ValType(xConteudo)="N"
			        cCampo:=Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
			   otherwise
			        cCampo:=Substr(xConteudo,1,nTam)
		   endcase
	   Endif
   End
   If Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
      cCampo:=cCampo+Space(nTam-Len(cCampo))
   End
   Fwrite( nHdlSaida,cCampo,nTam )
Else
   DetCnab2(nHdlSaida,MV_PAR03)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apenas esta sendo armazenado para uso futuro             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aBordero,SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_ITEM)
Return .T.


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LJ150Orig ³ Autor ³ Wagner Xavier         ³ Data ³ 10/11/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se expressao e' valida para Remessa CNAB.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³LOJA150                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> Function LJ150Orig( cForm )
Static Function LJ150Orig( cForm )()
Local bBlock:=ErrorBlock(),bErro := ErrorBlock( { |e| ChecErr260(e,cForm) } )
Private lRet := .T.

BEGIN SEQUENCE
	xConteudo := &cForm
END SEQUENCE
ErrorBlock(bBlock)
Return lRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ LJCnabIn   ³ Autor ³ Almeida              ³ Data ³ 15.06.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Criar Indice Condicional da indRegua                        ³±±
±±³          ³ Filtro Consiste: Data Emissao/Nao Enviados/Filial           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ IndRegua                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 12/07/00 ==> Function LJCnabIn()
Static Function LJCnabIn()

Local cFiltro := ""
       
cFiltro := 'D2_FILIAL >= "' + mv_par06 + '" .And. '
cFiltro += 'D2_FILIAL <= "' + mv_par07 + '" .And. '
cFiltro += 'DTOS(D2_ENVCNAB) == "' + DTOS(CTOD("")) + '" .And. '
cFiltro += 'DTOS(D2_EMISSAO) >= "' + DtoS(mv_par01) + '" .And. '
cFiltro += 'DTOS(D2_EMISSAO) <= "' + DtoS(mv_par02) + '"'

Return cFiltro

