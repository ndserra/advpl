#include "AVERAGE.CH"


/*
Programa...: EICDI520
Objetivo...: Formularios de Pagamentos de Impostos.
             1 - DARF
             2 - Exoneracao ICMS
             3 - GARE
Paramentro.:              
Retorno....: Nil
Autor......: Osman Medeiros Jr.
Data.......: 05/10/2001
*/
#Define DARF      1 
#Define ICMS      2
#Define GARE      3
#Define ICMS_PAG2 4
	
*-------------------------------------------*
USER Function EICDI520()
*-------------------------------------------*
Private nOpc,oDlg,oRadio,nTipo:=1,nOldArea:=Select()
Private cFilSW8:=xFilial("SW8"),cFilEIJ:=xFilial("EIJ"),cFilSW7:=xFilial("SW7")
Private cFilSWZ:=xFilial("SWZ")

Private cNomArq,cNomArq1,cNomArq2,nLenDesc:=60,;
          nFreAdicao := 0,;
		  cDespesa   := Space(03),;
		  cMultaDF   := Space(03),; //FCD 28/02/02
  		  cJuroDF    := Space(03),;	//FCD 28/02/02	  
    	  cCodRec    := Space(10),; 
		  dVenc      := dDataBase,;
		  cHawb      := Space(AvSx3("W6_HAWB",3))

SW6->(DbSeek(xFilial()))
PROCESSA({||DI520CRIAWORKS()})

Do While .T.

	nOpc := 0 
   
   /* ISS - 25/03/10 - Alteração do tamanho da tela, para que a mesma não corte o botão "Confirmar"
   Define MsDialog oDlg Title "Formularios de Impostos";
  											From 9,0 To 18,45 Of oMainWnd  */
   Define MsDialog oDlg Title "Formularios de Impostos";
  											From 9,0 To 18,50 Of oMainWnd

		@ 25,30 RADIO oRadio VAR nTipo ;
						SIZE 80,09 ITEMS  "01 - DARF",; 
												"02 - Exoneracao ICMS",; 
												"03 - GARE"  OF oDlg PIXEL 
												
		bOk     := {|| nOpc:=1,oDlg:End()}
		bCancel := {|| nOpc:=0,oDlg:End()}

   Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) Centered
   
   If nOpc = 0 	
   	Exit
   EndIf  
		
	DI520Telas(nTipo)
	Loop
	
EndDo

Work->(E_EraseArq(cNomArq))
Work1->(E_EraseArq(cNomArq1))		
TRB->(E_EraseArq(cNomArq2))
SWZ->(dbSetOrder(1))
SW7->(dbSetOrder(1))
dbSelectArea(nOldArea)

Return Nil 


/*
Programa...: 
Funcao.....: DI520Telas
Objetivo...: Tela de Selecao de Processo.
Paramentro.: nTipo (DARF,ICMS,GARE)             
Retorno....: Nil
Autor......: Osman Medeiros Jr.
Data.......: 05/10/2001
Obs........:
*/
*-------------------------------------------*
STATIC Function DI520Telas(nTipo)
*-------------------------------------------*
/* ISS - 25/03/10 - Alteração do tamanho da tela, para que a mesma não corte o botão "Confirmar"
Local nLinhai:=09,nLinhaf:=22,nColunai:=0,nColinaf:=45 */
Local nLinhai:=09,nLinhaf:=22,nColunai:=0,nColinaf:=50
LOCAL bOk     := {|| nOpc:=1,oDlgTela:End()}
LOCAL bCancel := {|| nOpc:=0,oDlgTela:End()}
Local oDlgTela,;
		nOpc,;
		nLinIni,;
		nColIni,;
		nLinFim,;
		nColFim,;
		nOldArea:=Select(),;
		cTitulo := "Impressao "+If(nTipo = DARF,"DARF",;
   									If(nTipo = ICMS,"Exoneracao do ICMS",;
   									If(nTipo = GARE,"GARE",)))            									
//FCD 05/03/02                            
PRIVATE cCodConta := SPACE(LEN(SU5->U5_CODCONT))
PRIVATE cContNome := SPACE(LEN(SU5->U5_CONTAT))
PRIVATE cContCPF  := SPACE(LEN(SU5->U5_CPF))
PRIVATE cContEnd  := SPACE(LEN(SU5->U5_END))
PRIVATE cContCEP  := SPACE(LEN(SU5->U5_CEP))
PRIVATE cContFON  := SPACE(LEN(SU5->U5_FCOM1))
PRIVATE cContMUN  := SPACE(LEN(SU5->U5_MUN))
PRIVATE cContEST  := SPACE(LEN(SU5->U5_EST))

cHawb   := SW6->W6_HAWB
cCodRec := If(nTipo=GARE,"120-0     ",Space(10))
dVenc   := dDataBase


IF nTipo==GARE
   nLinhaf:=32
   cTexto:=SPACE(10)
   cObs:=SPACE(3)
   bOk:={||IF(EMPTY(cObs),(MsgInfo("Favor Informar o Mens. Obs."),.F.),(nOpc:=1,oDlgTela:End()))}
ENDIF


If nTipo = DARF
   nLinhaf:=25   
Endif

Do While .T.

   Define MsDialog oDlgTela Title cTitulo From nLinhai,nColunai To nLinhaf,nColinaf Of oMainWnd
		
		nOpc := 0
		
		nLin1 := 25
		
		@ nLin1, 10 Say "Processo" Pixel
		@ nLin1, 50 MsGet cHawb F3 "SW6" Picture AvSx3("W6_HAWB",6) Valid NaoVazio() .AND. DI520VALID("HAWB") SIZE 70,8 Pixel
		
		If nTipo <> ICMS

			If nTipo = DARF

				nLin1 += 15
	
				@ nLin1, 10 Say "II/IPI" Pixel //FCD 28/02/02
				@ nLin1, 50 MsGet cDespesa F3 "SYB" Picture "@!" Valid Vazio() .or. ExistCpo("SYB",cDespesa) SIZE 40,8 Pixel
				nLin1 += 15
	
				@ nLin1, 10 Say "Multa" Pixel //FCD 28/02/02
				@ nLin1, 50 MsGet cMultaDF F3 "SYB" Picture "@!" Valid Vazio() .or. ExistCpo("SYB",cMultaDF) SIZE 40,8 Pixel
				nLin1 += 15
	
				@ nLin1, 10 Say "Juros" Pixel //FCD 28/02/02
				@ nLin1, 50 MsGet cJuroDF F3 "SYB" Picture "@!" Valid Vazio() .or. ExistCpo("SYB",cJuroDF) SIZE 40,8 Pixel
                                                         
                                                         
			EndIf

			nLin1 += 15

			@ nLin1, 10 Say "Cod. Receita" Pixel
			@ nLin1, 50 MsGet cCodRec Valid NaoVazio() SIZE 40,8 Pixel

			nLin1 += 15

			@ nLin1, 10 Say "Vencimento" Pixel
			@ nLin1, 50 MsGet dVenc Valid NaoVazio(dVenc) SIZE 40,8 Pixel
			
			IF nTipo = GARE			
            nLin1 += 15
            @ nLin1, 10 Say "Mens. Obs." Pixel
            @ nLin1, 50 MsGet cObs F3 "SY7" Valid (NaoVazio() .AND. DI520VALID("MENSAGEM")) SIZE 40,8 Pixel
            nLin1 += 15
            @ nLin1,10 GET cTexto MEMO HSCROLL SIZE 140,80 Pixel of oDlgTela UPDATE WHEN .F.
            
			ENDIF
		Else //FCD 05/03/02
              cContNome := SPACE(LEN(SU5->U5_CONTAT))
              cContCPF  := SPACE(LEN(SU5->U5_CPF))
              cContEnd  := SPACE(LEN(SU5->U5_END))
              cContCEP  := SPACE(LEN(SU5->U5_CEP))
              cContMUN  := SPACE(LEN(SU5->U5_MUN))
              cContEST  := SPACE(LEN(SU5->U5_EST))
              cContFON  := SPACE(LEN(SU5->U5_FONE))
              cCodConta := SPACE(LEN(SU5->U5_CODCONT))  
				nLin1 += 15
	
				@ nLin1, 10 Say "Cod.Contato" Pixel //FCD 28/02/02
				@ nLin1, 50 MsGet cCodConta F3 "SU5" Picture "@!" Valid Vazio() .or. ValContato() SIZE 40,8 Pixel
				nLin1 += 15
	
				@ nLin1, 10 Say "Nome" Pixel 
				@ nLin1, 50 MsGet cContNome Picture "@!" WHEN .F. SIZE 80,8 Pixel
				nLin1 += 15

		EndIf

	
   Activate MsDialog oDlgTela On Init EnchoiceBar(oDlgTela,bOk,bCancel) Centered

	If nOpc = 0
		Exit
	EndIf		

	If nTipo = ICMS
		DI520SelIcms()
	Else
		DI520Impr(nTipo)	
	EndIf	  

EndDo

dbSelectArea(nOldArea)
	
Return Nil
*--------------------------------------*	
Static Function ValContato()		
*--------------------------------------*	
Local lRetConta := .F.	
lRetConta:=ExistCpo("SU5",cCodConta)	
If lRetConta
   cContNome := TRIM(SU5->U5_CONTAT)
   cContCPF  := SU5->U5_CPF
   cContEnd  := TRIM(SU5->U5_END)
   cContCEP  := SU5->U5_CEP
   cContFON  := SU5->U5_FONE      
   cContMUN  := TRIM(SU5->U5_MUN)
   cContEST  := SU5->U5_EST 
Endif
Return(lRetConta)							
/*
Programa...: 
Funcao.....: DI520SelIcms
Objetivo...: Selecao de adicao para a impressao Exoneracao do ICMS
Paramentro.: 
Retorno....: Nil
Autor......: Osman Medeiros Jr.
Data.......: 08/10/2001
Obs........:
*/
*-------------------------------------------*
STATIC Function DI520SelIcms()
*-------------------------------------------*
Local oDlg,;
		oMark,;
		oBtnRes,;
		lInverte := .f.,;
		nOldArea:=Select(),;
		nTotMark := nExor := 0

						
Local TB_Campos := {{"WK_FLAG","","  "},;
						  {{|| Work1->EIJ_ADICAO   },"","Adicao"},;
						  {{|| Trans(Work1->EIJ_TEC   ,AvSx3("YD_TEC"    ,6)) },"","NCM"            },;
						  {{|| Posicione("SYD",1,xFilial("SYD")+Work1->EIJ_TEC,"YD_DESC_P")},"","Descricao da NCM"},;						
						  {{|| Work1->EIJ_MOEDA    },"","Moeda" },;
						  {{|| Trans(Work1->EIJ_VLMLE ,AvSx3("EIJ_VLMLE" ,6)) },"","Valor na Moeda" },;
						  {{|| Trans(Work1->EIJ_VLMMN ,AvSx3("EIJ_VLMMN" ,6)) },"","Valor em R$"    },;
						  {{|| Trans(Work1->EIJ_NROLI ,AvSx3("EIJ_NROLI" ,6)) },"","Numero da L.I." },;
						  {{|| Trans(Work1->EIJ_VLICMS,AvSx3("EIJ_VLICMS",6)) },"","Valor do ICMS"  }}

Local bMarca := {||    DI520Marca("M",nTotMark),oMark:oBrowse:Refresh()}
                                                                  
Local bDesMarca := {|| DI520Marca("D",nTotMark),oMark:oBrowse:Refresh()}

Local bExec := {|| DI520GrvWork(nExor)}
                
Local bWhile:= {|| EIJ->EIJ_FILIAL== xFilial("EIJ") .And.;
                   EIJ->EIJ_HAWB  == cHawb }
                   
Local bFor:= {|| EIJ->EIJ_ADICAO<>"MOD"}
                   
Private oBtnPag2,;
        lPassou := .F.,;
		aHeader:={},;
		aCampos:={},;
		cMarca :=GetMark()

EIJ->(dbSeek(xFilial("EIJ")+cHawb))             



WORK->(__DBZAP())
WORK1->(__DBZAP())

nFreAdicao := 0
lPassou := .F.

Processa({|| ProcRegua(SW6->W6_QTD_ADI),EIJ->(dbEval(bExec,bFor,bWhile)) },"Lendo Adicoes...")

Work->(dbGoTop())
Work1->(dbGoTop())

If Work1->(RecCount()) > 0 
	
	nTotMark := Work->(RecCount())

	oMainWnd:ReadClientCoords()

    TB_Campos:= AddCpoUser(TB_Campos,"EIJ","5","Work1") 
	
   Define MsDialog oDlg Title "Selecao de Adicoes - Processo: " + Trans(cHawb,AvSx3("W6_HAWB",6));
										From oMainWnd:nTop+100,oMainWnd:nLeft+5 To;
										oMainWnd:nBottom-60,oMainWnd:nRight-10 Of oMainWnd Pixel

		oMark := MsSelect():New("Work1","WK_FLAG",,TB_Campos,@lInverte,@cMarca,;
										{60,1,(oDlg:nHeight-30)/2,(oDlg:nClientWidth-4)/2})

		oMark:bAval := {|| if(Empty(WORK1->WK_FLAG),Eval(bMarca),Eval(bDesMarca))}           

		@18,(oDlg:nClientWidth-4)/2-380 BUTTON "Marca/Desmarca Todos" SIZE 67,12 ;
												 ACTION (Processa({|| nTotMark:=DI520MarkAll()}),oMark:oBrowse:Refresh()) Pixel
    
		@35,(oDlg:nClientWidth-4)/2-380 BUTTON oBtnRes PROMPT "Restaurar" SIZE 67,12 ;
												 ACTION (PROCESSA({||DI520Restau()})) Pixel            
												 
     /*  
		@18,(oDlg:nClientWidth-4)/2-400 BUTTON "Altera Todas Marcadas" SIZE 67,12 ;
												 ACTION (DI520AltAdi(.t.,nTotMark)) Pixel

		@35,(oDlg:nClientWidth-4)/2-400 BUTTON "Altera Adicao" SIZE 67,12 ;
												 ACTION (DI520AltAdi(.f.,nTotMark)) Pixel
      */
		@13,(oDlg:nClientWidth-4)/2-120 To 55,(oDlg:nClientWidth-4)/2-25 Label "Imprimir" Pixel
		
		@18,(oDlg:nClientWidth-4)/2-100 BUTTON "1a. Pagina" SIZE 67,12 ;
												 ACTION (DI520Impr(ICMS)) Pixel

		@35,(oDlg:nClientWidth-4)/2-100 BUTTON oBtnPag2 PROMPT "Restante" SIZE 67,12 ;
												 ACTION (DI520Impr(ICMS_PAG2)) Pixel

		DI520AtuBtn(nTotMark)
      /*
		If nExor > 0
			oBtnRes:Enable()
		Else
			oBtnRes:Disable()			
		EndIf
		*/			
		bOk     := {|| oDlg:End()}
		bCancel := {|| oDlg:End()}

   Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) 

	Processa({|| DI520GravaEIJ()},"Gravando")
   
Else

	MsgInfo("Este Processo nao possui adicoes","Informacao")

EndIf

dbSelectArea(nOldArea)

Return Nil

/*
Programa...: 
Funcao.....: DI520MarkAll
Objetivo...: Marca ou Desmarca todos as Adicoes na Exoneracao do ICMS.
Paramentro.: 
Retorno....: nTotMark
Autor......: Osman Medeiros Jr.
Data.......: 08/10/2001
Obs........:
*/
*-------------------------------------------*
STATIC Function DI520MarkAll()
*-------------------------------------------*
Local   cMark    := cMarca,;
		nRecno   := Work1->(Recno()),;
		nTotMark := Work->(RecCount())
		

ProcRegua(Work1->(RecCount()))

WORK1->(DBGOTOP())      

DO WHILE WORK1->(!EOF())
   IncProc("Marcando")			  			
	If EMPTY(Work1->WK_FLAG)
	   Work1->WK_FLAG := cMark
	ELSE
      Work1->WK_FLAG :=" "	   
   Endif
   WORK1->(DBSKIP())
ENDDO
Work1->(dbGoto(nRecno))



ProcRegua(Work->(RecCount()))

WORK->(DBGOTOP())      

DO WHILE WORK->(!EOF())
   IncProc("Marcando")			  			
	If EMPTY(Work->WK_FLAG)
	   Work->WK_FLAG := cMark
	ELSE
      Work->WK_FLAG :=" "	   
   Endif
   WORK->(DBSKIP())   
ENDDO




DI520AtuBtn(nTotMark)

Return nTotMark


/*
Programa...: 
Funcao.....: DI520GravaEIJ
Objetivo...: Grava no EIJ o Flag de Impressao do ICMS.
Paramentro.: 
Retorno....: Nil
Autor......: Osman Medeiros Jr.
Data.......: 10/10/2001
Obs........:
*/
*-------------------------------------------*
STATIC Function DI520GravaEIJ()
*-------------------------------------------*

Work1->(dbGoTop())

ProcRegua(Work1->(RecCount()))
EIJ->(dbSetOrder(1))
	
While !Work1->(Eof())
	IncProc()
	EIJ->(dbSeek(xFilial("EIJ")+cHawb+Work1->EIJ_ADICAO))
	EIJ->(RecLock("EIJ",.f.))   
	EIJ->EIJ_FLGICM := Work1->EIJ_FLGICM	
	EIJ->(MsUnlock())

	Work1->(dbSkip())	
	
EndDo

Return Nil 
/*
Programa...: 
Funcao.....: DI520AltAdi
Objetivo...: Altera Regime de Tributacao e Fundamentacao Legal da Adicao
Paramentro.: lTodos (Se for .T. altera todas as Adicoes)
Retorno....: Nil
Autor......: Osman Medeiros Jr.
Data.......: 08/10/2001
Obs........:

*-------------------------------------------*
STATIC Function DI520AltAdi(lTodos,nTotMark)
*-------------------------------------------*
Local oDlg,;
		oRegTri,;
		oFunReg,;
		nOpc:=0,;
		cRegTri ,cFunReg,cTitulo 
		
WORK->(DBSEEK(WORK1->EIJ_AUXIL))		
EIQ->(DBSEEK(xFilial("EIQ")+WORK1->WKCOD))

cRegTri := Work1->EIJ_REGICM
cFunReg :=EIQ->EIQ_CODIGO

cTitulo := "Alterar " + If(lTodos,"Todos","Adicao "+Work->EIJ_ADICAO)


If !lTodos .And. Empty(Work1->WK_FLAG)
	MsgInfo("O item nao esta marcado.","Atencao")
	Return Nil
EndIf


If lTodos .And. nTotMark = 0
	MsgInfo("Nao existe itens marcados.","Atencao")
	Return Nil
EndIf

   Define MsDialog oDlg Title cTitulo From 9,0 To 18,55 Of oMainWnd

		nLin1 := 25
		
		@ nLin1, 10 Say "Trat. Tribut." Pixel
		@ nLin1, 50 MsGet oRegTri Var cRegTri F3 "C5" SIZE 25,8 Pixel
		
		nLin1 += 15

		@ nLin1, 10 Say "Fundam. Legal" Pixel
		@ nLin1, 50 MsGet oFunReg Var cFunReg F3 "EIQ" VALID ExistCpo("EIQ",cFunReg) SIZE 150,8 Pixel

		bOk     := {|| nOpc:=1,oDlg:End()}
		bCancel := {|| nOpc:=0,oDlg:End()}

   Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) Centered
   
   If nOpc = 1 		
	   Processa({||DI520ALTERA(lTodos,cRegTri ,cFunReg)})		
	EndIf

Return Nil 
*/
/*
Programa...: 
Funcao.....: DI520AtuBtn
Objetivo...: Habilita ou Desabilita o Botao de Impressao da Segunda pagina do ICMS.
Paramentro.: nTotMark ( Total de Registros Marcados ) 
Retorno....: Nil
Autor......: Osman Medeiros Jr.
Data.......: 08/10/2001
Obs........:
*/
*-------------------------------------------*
STATIC Function	DI520AtuBtn(nTotMark)
*-------------------------------------------*
/*
If nTotMark < 7 
	oBtnPag2:Disable()   
	oBtnPag2:Refresh()
Else
	oBtnPag2:Enable()	
	oBtnPag2:Refresh()
EndIf		
*/
Return Nil


/*
Programa...: 
Funcao.....: DI520Restau
Objetivo...: Zera todos os flags de exoneracao de icms.
Paramentro.: 
Retorno....: Nil
Autor......: Osman Medeiros Jr.
Data.......: 10/10/2001
Obs........:
*/
*-------------------------------------------*
STATIC Function DI520Restau()
*-------------------------------------------*
Local nRecno := Work->(Recno())

If !MsgYesNo("Deseja que TODAS as adicoes retornem a condicao de nao impressao?","Atencao")
	Return Nil 
EndIf
PROCREGUA(WORK1->(RECCOUNT()))

Work1->(dbGoTop())
DO WHILE WORK1->(!EOF())
   IncProc("Restaurando")
   Work1->EIJ_FLGICM :=" "
   WORK1->(DBSKIP())
ENDDO

Work1->(dbGoto(nRecno))


PROCREGUA(WORK->(RECCOUNT()))

Work->(dbGoTop())
DO WHILE WORK->(!EOF())
   IncProc("Restaurando")
   Work->EIJ_FLGICM :=" "
   WORK->(DBSKIP())
ENDDO              

Return Nil


/*
Programa...: 
Funcao.....: DI520Impr
Objetivo...: Imprime o formulario do Imposto de acordo com o paramentro.
Paramentro.: nTipo (DARF,ICMS,GARE)             
Retorno....: Nil
Autor......: Osman Medeiros Jr.
Data.......: 08/10/2001
Obs........:
*/
*-------------------------------------------*
STATIC Function DI520Impr(nTipo)
*-------------------------------------------*
LOCAL   oDlg, oBtnOk, oRdPorta,	oCmbPorta, oBtnCancel

Private nHdl, nCol,	lImp:=.F., cDevice,;
		cConteudo,; //Guarda o Conteudo a ser impresso. Pode ser alterado no RdMake.
		nLinAnt:=nColAnt:=0, nPorta := 1,;
		cTitulo := "Impressao",;
		aPtClient := RetPortAct(.F.),;
		aPtServer := RetPortAct(.T.)

PRIVATE cMens := "Nao foram enviados dados para a impressora."
//Para Utilizacao em RdMakes de ajuste de impressao
Private nLin,nCol1,nCol2,;//Para GARE,DARF e Exoneracao de ICMS
		nColEst,nColTel,nColCAE,;//Para a Exoneracao de ICMS e GARE
		nColDI,nColDtDI,nColCPF,;//Para a Exoneracao de ICMS
		nColLocal,nColUFDI,nColMun,nColUFImp,;//Para a Exoneracao de ICMS
		nColClass,nColReg,nColFund,nColVlR,nColRepr,;//Para a Exoneracao de ICMS
		nTotAdi1,nTotAdi2// Totais de Adicao pagina 1 e 2.

cSpool   := CriaTrab(,.F.)
nHdl     := FCreate(cSpool)     
/* ISS - 25/03/10 - Alteração do diretório substituto do "MV_DIREXON" para o proprio diretório do "MV_RELT"
cDirRelato := AllTrim(GetMv("MV_RELT",,"\RELATO\"))
cDirExoner := AllTrim(GetMv("MV_DIREXON",,"\RELATO\"))  */
cDirRelato := AllTrim(GetMv("MV_RELT",,"\RELATO\"))
cDirExoner := AllTrim(GetMv("MV_DIREXON",,"MV_RELT"))   

 If nHdl == -1
   MsgStop("Erro na abertura do arquivo nro. "+LTrim(Str(FError())),"Atencao")	
   return .f.
Endif

Processa( {|| DI520Imprimir(nTipo)} ,"Impressao..")

RETURN .T.


*-----------------------------------*
STATIC FUNCTION DI520Imprimir(nTipo)
*-----------------------------------*
LOCAL cTextoAtual  ,nCol
LOCAL cNrRefer, nVlrMtDF := 0.00, nVlrJRDF := 0.00, nVlrDPDF := 0.00, nVlrTot := 0.00 //FCD 28/02/02
Local cAlias := ''
Local cDesc1 := ''
Local cDesc2 := ''
Local cDesc3 := ''
Local oDlg,nOpc:=0
LOCAL aCposGare :={ {"W6_HAWB"   ,"", "PROCESSO" } ,;
                    {"WZ_CFO"    ,"", "CFO"      } ,;
                    {"W8_VLII"   ,"", "VALOR II"  ,AVSX3("W8_VLII")[6]   },;
                    {"W8_VLIPI"  ,"", "VALOR IPI" ,AVSX3("W8_VLIPI")[6]  },;
                    {"W8_BASEII" ,"", "BASE II"   ,AVSX3("W8_BASEII")[6] },;
                    {"W8_BASEICM","", "BASE ICMS" ,AVSX3("W8_BASEICM")[6]},;
                    {"W8_VLICMS" ,"", "VALOR ICMS",AVSX3("W8_VLICMS")[6] } }

Private m_pag := 1, aReturn, wrel
PRIVATE cMarca := GetMark(), lInverte := .F.

nTotAdi1  := 6
nLin := 0       
Do Case 

	Case nTipo = DARF

		//***********************************************************//
		//*****            INICIO DA IMPRESSAO DO DARF          *****//  
		//***********************************************************//

		nCol1 := 10
		nCol2 := 110	

		SW6->(dbSetOrder(1))
		SWD->(dbSetOrder(1))
		SW7->(dbSetOrder(1))
		SW2->(dbSetOrder(1))
		SYT->(dbSetOrder(1))

		SW6->(dbSeek(xFilial("SW6")+cHawb))
		If !empty(cMultaDF) //FCD 28/02/02
  		   lImp := SWD->(dbSeek(xFilial("SWD")+cHawb+cMultaDF))
           IF !lImp
             cMens := "Multa nao cadastrada" 
           ELSE  
             nVlrMtDF := SWD->WD_VALOR_R
           ENDIF                                    
        Endif
        If !empty(cJuroDF) //FCD 28/02/02
           lImp := SWD->(dbSeek(xFilial("SWD")+cHawb+cJuroDF))
           IF !lImp
              cMens := "Juros nao cadastrado" 
           ELSE                        
              nVlrJRDF := SWD->WD_VALOR_R
           ENDIF
		EndIf
		If !Empty(cDespesa)	 
		   lImp := SWD->(dbSeek(xFilial("SWD")+cHawb+cDespesa))
           IF !lImp
              cMens := "Despesa nao cadastrada" 
           ELSE
              nVlrDPDF := SWD->WD_VALOR_R   
           ENDIF
        Endif
                                   
        If empty(cDespesa).and.empty(cJuroDF).and.Empty(cMultaDF)
           lImp := .F.
           cMens := "E obrigatorio o preenchimento de apenas um codigo de despesa(II/IPI,Multa,Juros)"
        Endif
        ProcRegua(13)
		SW7->(dbSeek(xFilial("SW7")+cHawb))
		SW2->(dbSeek(xFilial("SW2")+SW7->W7_PO_NUM))
		SYT->(dbSeek(xFilial("SYT")+SW2->W2_IMPORT))
        
        cNrRefer := Trans(SW6->W6_URF_DES,Avsx3("W6_URF_DES",6))
		nVlrTot  := nVlrDPDF+nVlrJRDF+nVlrMTDF
		Titulo   := "Impressao de Darf"
		cAlias   := "SYT"
  	
		Define MsDialog oDlg Title Titulo From 5,0 To 21,60 Of oMainWnd
           @ 15, 10 SAY "D.I.: " +Trans(SW6->W6_DI_NUM ,AvSx3("W6_DI_NUM",6))+;
                    " / N/REF.: "+Trans(SW6->W6_REF_DES,AvSx3("W6_REF_DES",6)) Pixel          
           
           @ 15, 120 SAY "AWB: "+SW6->W6_MAWB+SPACE(2)+"HAWB: "+SW6->W6_HOUSE Pixel                     
			
		   @ 27, 10 Say "Cod. Receita" Pixel
		   @ 27, 90 MsGet cCodRec When .F. Size 60,8 Pixel
		   
		   @ 39, 10 Say "Nr. Referencia" Pixel
		   @ 39, 90 MsGet cNrRefer When .F. Size 60,8 Pixel
		   
		   @ 51, 10 Say "Dt. Vencimento" Pixel
		   @ 51, 90 MsGet dVenc When .F. Size 60,8 Pixel
		   
		   @ 63, 10 Say "Valor do Principal" Pixel
		   @ 63, 90 MsGet nVlrDPDF PICTURE AvSx3("WD_VALOR_R",6) When .F. Size 60,8 Pixel
		   
		   @ 75, 10 Say "Valor da Multa" Pixel
		   @ 75, 90 MsGet nVlrMTDF PICTURE AvSx3("WD_VALOR_R",6) When .F. Size 60,8 Pixel
		   
		   @ 87, 10 Say "Valor dos Juros e/ou Encargos" Pixel
		   @ 87, 90 MsGet nVlrJRDF PICTURE AvSx3("WD_VALOR_R",6) When .F. Size 60,8 Pixel
		   		   
		   @ 99, 10 Say "Valor Total" Pixel   
		   @ 99, 90 MsGet nVlrTot PICTURE AvSx3("WD_VALOR_R",6) When .F. Size 60,8 Pixel
		   		               
	       DEFINE SBUTTON FROM 45,180 TYPE 1 ACTION(nOpc:=1,oDlg:End()) ENABLE OF oDlg PIXEL
           DEFINE SBUTTON FROM 70,180 TYPE 2 ACTION(nOpc:=0,oDlg:End()) ENABLE OF oDlg PIXEL

        Activate MsDialog oDlg Centered
        
        IF nOpc == 0
           FClose(nHdl)
           FErase(cSpool)
           RETURN NIL
        ENDIF                                                
        
        aReturn := { "Zebrado", 1,"Administracao",1,2,1,"",1}
        wnrel   := "DARF001" 
        wnrel   := SetPrint(cAlias,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,,,.F.,.F.,,,.F.)
 
        If LastKey() == 27 .OR. nLastKey == 27
           FClose(nHdl)
           FErase(cSpool)
           Return
        EndIf
 
        SetDefault( aReturn, cAlias )
        
        If LastKey() == 27 .OR. nLastKey == 27
           FClose(nHdl)
           FErase(cSpool)
           Return                        
        EndIf

        Set Print On
        Set Device to Print
        SetPrc(0,0)

        nLin := 0
		    
		cConteudo := Chr(15)
		@ nLin, 1 PSAY cConteudo 	
		DI520GrvLin(nLin,1,cConteudo)//1

//		nLin++

		cConteudo := DTOC(dDataBase)
		@ nLin, nCol2+9 PSAY cConteudo
		DI520GrvLin(nLin,nCol2+9,cConteudo)//2

		nLin+=2

		cConteudo := Trans(SYT->YT_CGC,AvSx3("YT_CGC",6))
		@ nLin, nCol2 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol2,cConteudo)//3
				
		nLin+=2
		
		cConteudo := AllTrim(cCodRec)
        @ nLin, nCol2+7 PSAY cConteudo
		DI520GrvLin(nLin,nCol2+7,cConteudo)//4

		nLin+=2 //1
		
		cConteudo := "D.I. : "+Trans(SW6->W6_DI_NUM,AvSx3("W6_DI_NUM",6))+" / N/REF.: "+;
		             Trans(SW6->W6_REF_DES,AvSx3("W6_REF_DES",6))
		@ nLin, nCol1+23 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol1+23,cConteudo)//5

//		nLin+=1
		
		cConteudo :=Trans(SW6->W6_URF_DES,Avsx3("W6_URF_DES",6))
		@ nLin, nCol2+10 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol2+10,cConteudo)//6

		nLin++   //+=1.5

		cConteudo := AllTrim(SYT->YT_NOME)
		@ nLin, nCol1 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol1,cConteudo)//7

        nLin++  //=0.5

		cConteudo := AllTrim(SYT->YT_TEL_IMP)
		@ nLin, nCol1 PSAY cConteudo	
		DI520GrvLin(nLin,nCol1,cConteudo)//9

		cConteudo := DtoC(dVenc)
		@ nLin, nCol2+9 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol2+9,cConteudo)//8

		//nLin+=2 //FCD
        nLin +=1

        cConteudo :="AWB: "+SW6->W6_MAWB+SPACE(5)+"HAWB: "+SW6->W6_HOUSE
		@ nLin, nCol1 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol1,cConteudo)//10
                                                           
		nLin++  //=0.5

//		cConteudo := Trans(SWD->WD_VALOR_R,AvSx3("WD_VALOR_R",6))
		cConteudo := Trans(nVlrDPDF,AvSx3("WD_VALOR_R",6))
		@ nLin, nCol2 PSAY cConteudo	
		DI520GrvLin(nLin,nCol2,cConteudo)//10
		
		nLin+=2
		
		cConteudo := Trans(nVlrMTDF,AvSx3("WD_VALOR_R",6))
		@ nLin, nCol2 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol2,cConteudo)//10
		
		nLin+=1		
		cConteudo := AllTrim(SYB->YB_DESCR)
        @ nLin, nCol1 PSAY cConteudo	
		DI520GrvLin(nLin,nCol1,cConteudo)//11

		nLin++   //=0.5				//4
		
		cConteudo := Trans(nVlrJRDF,AvSx3("WD_VALOR_R",6))
		@ nLin, nCol2 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol2,cConteudo)//10

		nLin+=2				//4

		cConteudo := Trans((nVlrDPDF+nVlrJRDF+nVlrMTDF),AvSx3("WD_VALOR_R",6))
		@ nLin, nCol2 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol2,cConteudo)//12

		nLin+=8

		cConteudo := chr(18)  //"  "
		@ nLin, 1 PSAY cConteudo
		DI520GrvLin(nLin,1,cConteudo)//13
				
		//***********************************************************//
		//*****                    FIM DO DARF                  *****//  
		//***********************************************************//

	Case nTipo = ICMS

		//***********************************************************//
		//*****    INICIO DA IMPRESSAO DA EXONERACAO DO ICMS    *****//  
		//***********************************************************//

		nCol1     := 15
		nCol2     := 125
		nColEst   := 73
		nColTel   := 83
		nColCAE   := 095
		nColDI    := 112
		nColDtDI  := 137
		nColCPF   := 60
		nColLocal := 112
		nColUFDI  := 142
		nColMun   := 40
		nColUFImp := 73
		nColClass := 37
		nColReg   := 52
		nColFund  := 56
		nColVlR   := 125
		nColRepr  := 35    		

		SW6->(dbSetOrder(1))
		SW7->(dbSetOrder(1))
		SW2->(dbSetOrder(1))
		SYT->(dbSetOrder(1))

		SW6->(dbSeek(xFilial("SW6")+cHawb))
		SW7->(dbSeek(xFilial("SW7")+cHawb))
		SW2->(dbSeek(xFilial("SW2")+SW7->W7_PO_NUM))
		SYT->(dbSeek(xFilial("SYT")+SW2->W2_IMPORT))
   	
        ProcRegua(16)
        
        aReturn := { "Zebrado", 1,"Administracao",1,1,1,"",1}
        wnrel   := "ICM1001" 
        cAlias  := "SYT"
        Titulo  := "Exoneracao de ICMS - 1a. Pagina"
        wnrel   := SetPrint(cAlias,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,,,.F.,.F.,,,.F.)
 
        If LastKey() == 27 .OR. nLastKey == 27
           FClose(nHdl)
           FErase(cSpool)
           Return
        EndIf
 
        SetDefault( aReturn, cAlias )
        
        If LastKey() == 27 .OR. nLastKey == 27
           FClose(nHdl)
           FErase(cSpool)
           Return                        
        EndIf

        Set Print On
        Set Device to Print
        SetPrc(0,0)

        nLin := 0
//     	nLin := 1.5
		cConteudo := Chr(15)
		@ nLin, 1 PSAY cConteudo 	
		DI520GrvLin(nLin,1,cConteudo)//1
	
		nLin += 1
		SY9->(dbSetOrder(2))	              
		SY9->(dbSeek(xFilial("SY9")+SW6->W6_DEST))		
		cConteudo := Tabela("12",SY9->Y9_ESTADO) 
		@ nLin, nColLocal PSAY cConteudo 	
		DI520GrvLin(nLin,nColLocal,cConteudo)//2
		
		nLin+=2
		cConteudo := " "
		@ nLin, nCol1+6 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol1+6,cConteudo)//2
		
		nLin+=1   //3.5
		cConteudo := AllTrim(SYT->YT_NOME)
		@ nLin, nCol1 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol1,cConteudo)//3
		
		cConteudo := Trans(SW6->W6_DI_NUM,AvSx3("W6_DI_NUM",6))
		@ nLin, nColDI PSAY cConteudo 	
		DI520GrvLin(nLin,nColDI,cConteudo)//4

		cConteudo := DtoC(SW6->W6_DTREG_D) 
		@ nLin, nColDtDi-2 PSAY cConteudo 	
		DI520GrvLin(nLin,nColDtDI-2,cConteudo)//5

		nLin+=2 
		cConteudo := Trans(SYT->YT_INSCR_E,AvSx3("YT_INSCR_E",6))
		@ nLin, nCol1 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol1,cConteudo)//6

		cConteudo := Trans(SYT->YT_CGC,AvSx3("YT_CGC",6))
		@ nLin, nColCPF PSAY cConteudo
		DI520GrvLin(nLin,nColCPF,cConteudo)//7

		cConteudo := AllTrim(Trans(SYT->YT_CAE,AvSx3("YT_CAE",6)))
		@ nLin, nColCAE-5 PSAY cConteudo 	
		DI520GrvLin(nLin,nColCAE-5,cConteudo)//8

		SY9->(dbSetOrder(2))	
		SY9->(dbSeek(xFilial("SY9")+SW6->W6_LOCAL))
		cConteudo := AllTrim(SY9->Y9_DESCR)
		@ nLin, nColLocal PSAY cConteudo	
		DI520GrvLin(nLin,nColLocal,cConteudo)//9

		cConteudo := AllTrim(SY9->Y9_ESTADO)
		@ nLin, nColUfDI PSAY cConteudo 	
		DI520GrvLin(nLin,nColUfDI,cConteudo)//10

		nLin+=2 
		If SYT->(FieldPos("YT_COMPEND")) > 0 // TLM - 09/06/2008 Inclusão do campo complemento, SYT->YT_COMPEND
 	       cConteudo := AllTrim(SYT->YT_ENDE) + " " + If(!EMPTY(SYT->YT_COMPEND),ALLTRIM(SYT->YT_COMPEND) + " , ","") + AllTrim(Str(SYT->YT_NR_END))  
 	    Else
 	       cConteudo := AllTrim(SYT->YT_ENDE) + " " + AllTrim(Str(SYT->YT_NR_END)) 
 	    EndIf   
		@ nLin, nCol1 PSAY cConteudo
		DI520GrvLin(nLin,nCol1,cConteudo)

		cConteudo := AllTrim(SYT->YT_BAIRRO)
		@ nLin, nColCAE-8 PSAY cConteudo 	
		DI520GrvLin(nLin,nColCAE-8,cConteudo)//8

		cConteudo := " "
		@ nLin, nColCAE PSAY cConteudo 	
		DI520GrvLin(nLin,nColCAE,cConteudo)//11

		nLin+=2 
		cConteudo := Trans(SYT->YT_CEP,AvSx3("YT_CEP",6))
		@ nLin, nCol1 PSAY cConteudo 	
		DI520GrvLin(nLin,nCol1,cConteudo)//12

		cConteudo := AllTrim(SYT->YT_CIDADE)
		@ nLin, nColMun PSAY cConteudo
		DI520GrvLin(nLin,nColMun,cConteudo)//13

		cConteudo := SYT->YT_ESTADO
		@ nLin, nColUfImp PSAY cConteudo 	
		DI520GrvLin(nLin,nColUfImp,cConteudo)//14

		cConteudo := AllTrim(SYT->YT_TEL_IMP)
		@ nLin, nColTel PSAY cConteudo
		DI520GrvLin(nLin,nColTel,cConteudo)//15

//		cConteudo := SW6->W6_FOB_TOT + If(!SW6->W6_INCOTER $"CFR/CPT",ValorFrete(SW6->W6_HAWB,,,1),)+ConvDespFobMoeda(SW6->W6_HAWB,"R$ ",SW6->W6_DTREG_D,"TUDO")[1][2]
		cConteudo := SW6->W6_FOB_TOT + nFreAdicao +ConvDespFobMoeda(SW6->W6_HAWB,"R$ ",SW6->W6_DTREG_D,"TUDO")[1][2]
		@ nLin, nCol2 PSAY TRANS(cConteudo,AVSX3("W6_FOB_TOT",6))
		DI520GrvLin(nLin,nCol2,TRANS(cConteudo,AVSX3("W6_FOB_TOT",6)))//16

   		nLin+=6   //5.9//5.7 FCD
   		nLine := nLin
		nCont := 1 
        ProcRegua(Work->(LASTREC())+4)
		Work->(dbGoTop())
		cAdicao:="  "
		DO While !Work->(Eof()) .And. nCont < (nTotAdi1+1)
		  IncProc("Gerando Arquivo Temporario...")
		             
		  IF cAdicao<>WORK->EIJ_AUXIL 
              nRecno:=WORK->(RECNO())
			  nAuxiliar:=0                                            
			  cAdicao:=Work->EIJ_ADICAO                     
			  
			  DO WHILE WORK->(!EOF()) .AND. WORK->EIJ_AUXIL==cAdicao
                 If Empty(Work->WK_FLAG)
                   Work->(dbSkip())
			       Loop			
           	     Endif
   		         nAuxiliar++
                 WORK->(DBSKIP())
              ENDDO
            
              IF nAuxiliar>( (nTotAdi1+1)-nCont)
                nTotAdi1:=nAuxiliar
                EXIT         
              ELSE
                WORK->(DBGOTO(nRecno))
              ENDIF
           ENDIF  
                
          If Empty(Work->WK_FLAG)
		     Work->(dbSkip())
		     Loop			
		  Endif
			
		  IF !EMPTY(Work->EIJ_ADICAO)
			 cConteudo := Work->EIJ_ADICAO
		     @ nLin, nCol1 PSAY cConteudo 	
		     DI520GrvLin(nLin,nCol1,cConteudo,.F.)
	      
	         cConteudo := Trans(Work->EIJ_TEC,AvSx3("YD_TEC",6))
             @ nLin, nColClass PSAY cConteudo 	
             DI520GrvLin(nLin,nColClass,cConteudo,.F.)

             cConteudo := AllTrim(Work->EIJ_REGICM)
             @ nLin, nColReg PSAY cConteudo 	
             DI520GrvLin(nLin,nColReg,cConteudo,.F.)
		  ENDIF
			
		  cConteudo := AllTrim(Work->WK_FUNLEG)
		  @ nLin, nColFund PSAY cConteudo
		  DI520GrvLin(nLin,nColFund,cConteudo,.F.)

		  cConteudo :=IF(!EMPTY(Work->EIJ_VLMMN),Trans(Work->EIJ_VLMMN,AvSx3("EIJ_VLMMN",6))," ")
		  @ nLin, nCol2 PSAY cConteudo 	
          DI520GrvLin(nLin,nCol2,cConteudo,.F.)

		  nLin++                 
		
 		  Work->EIJ_FLGICM := "S"       
		  Work->(dbSkip())		
		  nCont++
		  lImp := .T.
		EndDo
		

        nLin := nLine + 8
        
		cConteudo := DtoC(dDataBase)
		@ nLin, nCol1 PSAY cConteudo	 	
		DI520GrvLin(nLin,nCol1,cConteudo)

		cConteudo := cContNome+'  '+cContcpf
		@ nLin, nColRepr-8 PSAY cConteudo
		DI520GrvLin(nLin,nColRepr-8,cConteudo)

		nLin++
		cConteudo := cContEnd + '  '+cContMUN +'  '+cContEST  
		@ nLin, nColRepr-8 PSAY cConteudo
		DI520GrvLin(nLin,nColRepr-8,cConteudo)
		
		If !Empty(cContNome)
  		   nLin++
   		   cConteudo := cContFon +'  '+cContCEP
		   @ nLin, nColRepr-8 PSAY cConteudo 	
		   DI520GrvLin(nLin,nColRepr-8,cConteudo)
		Endif
		nLin+=13 
		cConteudo :=  CHR(18)
		@ nLin, 1 PSAY cConteudo
		DI520GrvLin(nLin,1,cConteudo)
		
		//***********************************************************//
		//*****                    FIM DO ICMS                  *****//  
		//***********************************************************//
		 
	Case nTipo = GARE

		//***********************************************************//
		//*****            INICIO DA IMPRESSAO DO GARE          *****//  
		//***********************************************************//
		
		nCol1   := 15
		nCol2   := 120
		nColEst := 56
		nColTel := 67
		nColCAE := 90
		nRegua:=0
		cTextoAtual:=cTexto
		TRB->(__DBZAP())
		

		SW8->(dbSetOrder(1))
		SWZ->(dbSetOrder(2))
		SW8->(dbSeek(cFilSW8+cHawb))
        SW6->(dbSeek(xFilial()+cHawb))		
        SW7->(dbSetOrder(4))
				
        ProcRegua(10)
      
        Do While !SW8->(Eof()) .And. SW8->W8_FILIAL+SW8->W8_HAWB = cFilSW8+cHawb
           EIJ->(DBSEEK(cFilEIJ+cHawb+SW8->W8_ADICAO))
         
           IncProc("Lendo Adicoes "+SW8->W8_ADICAO)
           nRegua++
         
           IF(nRegua>10,ProcRegua(10),)
         
           If EIJ->EIJ_FLGICM $ "Ss1"
              SW8->(dbSkip())
              Loop
           EndIf
			
           SW7->(DbSeek(cFilSW7+SW8->W8_HAWB+SW8->W8_PO_NUM+SW8->W8_POSICAO+SW8->W8_PGI_NUM))
           SWZ->(DbSeek(cFilSWZ+SW7->W7_OPERACA))
         
           IF TRB->(DBSEEK(SWZ->WZ_CFO))
              TRB->W8_VLII   +=SW8->W8_VLII
              TRB->W8_VLIPI  +=SW8->W8_VLIPI
              TRB->W8_BASEII +=SW8->W8_BASEII
              TRB->W8_BASEICM+=SW8->W8_BASEICM
              TRB->W8_VLICMS +=SW8->W8_VLICMS 
           ELSE 
              TRB->(DBAPPEND())            
              IF ! SWZ->(EOF())
                 TRB->WZ_AL_ICMS:= DITRANS(SWZ->WZ_AL_ICMS,2)
                 TRB->WZ_RED_ICM:= SWZ->WZ_RED_ICM
              ELSE
                 TRB->WZ_AL_ICMS:= DITRANS(SYD->YD_ICMS_RE,2)               
              ENDIF
              TRB->WZ_CFO    :=SWZ->WZ_CFO
              TRB->W8_VLII   :=SW8->W8_VLII
              TRB->W8_VLIPI  :=SW8->W8_VLIPI
              TRB->W8_BASEII :=SW8->W8_BASEII
              TRB->W8_BASEICM:=SW8->W8_BASEICM
              TRB->W8_VLICMS :=SW8->W8_VLICMS 
              TRB->W6_HAWB   :=SW6->W6_HAWB
              TRB->W6_REF_DES:=SW6->W6_REF_DES
           ENDIF
           SW8->(dbSkip())
		EndDo
		
		SW2->(dbSetOrder(1))
		SYT->(dbSetOrder(1))
		
		SW7->(dbSeek(xFilial("SW7")+cHawb))
		SW2->(dbSeek(xFilial("SW2")+SW7->W7_PO_NUM))
		SYT->(dbSeek(xFilial("SYT")+SW2->W2_IMPORT))
		
		TRB->(DBGOTOP())
		
		Titulo  := "Impressao de Gare"
		nOpc    := 0
        oMainWnd:ReadClientCoors()
     	DEFINE MSDIALOG oDlg TITLE Titulo FROM 3,0 To 21,95 Of oMainWnd
	       oMark:= MsSelect():New("TRB",,,aCposGare,@lInverte,@cMarca,{34,1,(oDlg:nHeight-30)/2,(oDlg:nClientWidth-4)/2})
        ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpc:=1,oDlg:End()}, {||oDlg:End()})	CENTERED
		
		IF nOpc == 0
           FClose(nHdl)
           FErase(cSpool)
		   RETURN NIL
		ENDIF
		                     
        aReturn := { "Zebrado", 1,"Administracao",1,1,1,"",1}
		cAlias  := "TRB"      
        wnrel   := "GARE001" 
        
        wnrel   := SetPrint(cAlias,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,,,.F.,.F.,,,.F.)
 
        If LastKey() == 27 .OR. nLastKey == 27
           FClose(nHdl)
           FErase(cSpool)
           Return
        EndIf
 
        SetDefault( aReturn, cAlias )
        
        If LastKey() == 27 .OR. nLastKey == 27
           FClose(nHdl)
           FErase(cSpool)
           Return                        
        EndIf

        Set Print On
        Set Device to Print
        SetPrc(0,0)
        
		
		lprim :=.t. //FCD
		nLin  := 0
		DO WHILE TRB->(!EOF())
           If lprim  
              cConteudo :=Chr(15)
              @ nLin, 1 PSAY cConteudo 	
       	      DI520GrvLin(nLin,1,cConteudo)
       	      lprim := .f.
           Endif
	       nLin += 2
           cConteudo := DtoC(dVenc)
   		   @ nLin, nCol2 PSAY cConteudo 	
	   	   DI520GrvLin(nLin,nCol2,cConteudo)
	
   		   nLin+=2
           cConteudo := SYT->YT_NOME
   		   @ nLin, nCol1 PSAY cConteudo 	
	   	   DI520GrvLin(nLin,nCol1,cConteudo)

           cConteudo := cCodRec
           @ nLin, nCol2 PSAY cConteudo           
           DI520GrvLin(nLin,nCol2,cConteudo)
	
           nLin++
           If SYT->(FieldPos("YT_COMPEND")) > 0 // TLM - 09/06/2008 Inclusão do campo complemento, SYT->YT_COMPEND
 	          cConteudo := AllTrim(SYT->YT_ENDE) + " " + If(!EMPTY(SYT->YT_COMPEND),ALLTRIM(SYT->YT_COMPEND) + " ","") + AllTrim(Str(SYT->YT_NR_END))              
           Else
              cConteudo := AllTrim(SYT->YT_ENDE) + " " + AllTrim(Str(SYT->YT_NR_END))
           EndIf
           @ nLin, nCol1 PSAY cConteudo 	
           DI520GrvLin(nLin,nCol1,cConteudo)

           cConteudo := Trans(SYT->YT_INSCR_E,AvSx3("YT_INSCR_E",6))
           @ nLin, nCol2 PSAY cConteudo 	
           DI520GrvLin(nLin,nCol2,cConteudo)
	      
           nLin+=2
           cConteudo := AllTrim(SYT->YT_CIDADE)
           @ nLin, nCol1 PSAY cConteudo 	
           DI520GrvLin(nLin,nCol1,cConteudo) 

           cConteudo := AllTrim(SYT->YT_ESTADO)
           @ nLin, nColEst PSAY cConteudo 	
           DI520GrvLin(nLin,nColEst,cConteudo)

           cConteudo := AllTrim(SYT->YT_TEL_IMP)
           @ nLin, nColTel PSAY cConteudo 	
           DI520GrvLin(nLin,nColTel,cConteudo)

           cConteudo := TRANS(SYT->YT_COD_ATV,AVSX3("YT_COD_ATV",6))
           @ nLin, nColCAE PSAY cConteudo 	
           DI520GrvLin(nLin,nColCAE,cConteudo)

           cConteudo := Trans(SYT->YT_CGC,AvSx3("YT_CGC",6))
           @ nLin, nCol2 PSAY cConteudo 	
           DI520GrvLin(nLin,nCol2,cConteudo)

           nLin+=2
           nLine:=nLin
	   	
           DI520OBSERVACAO()
           nTotColunas:=MLCOUNT(cTexto,AVSX3("Y7_VM_TEXT",3)) 
           nTamanho:=AVSX3("Y7_VM_TEXT",3)
	   	
	 	   FOR nCol:=1 TO nTotColunas
               cConteudo :=MEMOLINE(cTexto,nTamanho,nCol)
               @ nLin, nCol1+10 PSAY cConteudo 	
               DI520GrvLin(nLin,nCol1+10,cConteudo)

               IF nCol == 2				
                  cConteudo := STRZERO(MONTH(dVenc),2,0)+"/"+STRZERO(YEAR(dVenc),4,0)
                  @ nLin, nCol2 PSAY cConteudo
                  DI520GrvLin(nLin,nCol2,cConteudo)//FCD 28/02/02
               ENDIF
               
               IF nCol == 3
                  cConteudo := TRANS(SW6->W6_DI_NUM,AVSX3("W6_DI_NUM",6))
                  @ nLin, nCol2 PSAY cConteudo
                  DI520GrvLin(nLin,nCol2,cConteudo)
               ENDIF

               IF nCol == 5
                  cConteudo :=Trans(TRB->W8_VLICMS,AvSx3("W8_VLICMS",6))
                  @ nLin, nCol2 PSAY cConteudo
                  DI520GrvLin(nLin,nCol2,cConteudo)
               ENDIF
               nLin++
	 	   NEXT
	 	   
   	 	   IF nTotColunas < 5
	 	      IF nTotColunas == 0
	 	         nLin++
	 	      ENDIF
	 	      IF nTotColunas < 2
                 cConteudo := STRZERO(MONTH(dVenc),2,0)+"/"+STRZERO(YEAR(dVenc),4,0)
                 @ nLin, nCol2 PSAY cConteudo
                 DI520GrvLin(nLin,nCol2,cConteudo)//FCD 28/02/02
                 nLin+=1
              ENDIF
              IF nTotColunas < 3
                 cConteudo := TRANS(SW6->W6_DI_NUM,AVSX3("W6_DI_NUM",6))
                 @ nLin, nCol2 PSAY cConteudo
                 DI520GrvLin(nLin,nCol2,cConteudo)
                 nLin+=2
              ELSEIF nTotColunas == 3
                 nLin++
              ENDIF     
              cConteudo :=Trans(TRB->W8_VLICMS,AvSx3("W8_VLICMS",6))
              @ nLin, nCol2 PSAY cConteudo
              DI520GrvLin(nLin,nCol2,cConteudo)              
           ENDIF      		
	   
	   	   nLin:=nLine + 9
	 	   

           cConteudo :=" "
   		   @ nLin, nCol1+10 PSAY cConteudo
	   	   DI520GrvLin(nLin,nCol1+10,cConteudo)

  	   	   cConteudo :=" "
	   	   @ nLin, nCol2 PSAY cConteudo
   		   DI520GrvLin(nLin,nCol2,cConteudo)

	   	   nLin++                                            
	   	
	   	   cConteudo :=" "
   		   @ nLin, nCol1+10 PSAY cConteudo
	   	   DI520GrvLin(nLin,nCol1+10,cConteudo)
	   	
	   	   cConteudo :=" "
   		   @ nLin, nCol2 PSAY cConteudo
	   	   DI520GrvLin(nLin,nCol2,cConteudo)
	
   		   nLin+=1        
   		
	   	   cConteudo :=" "
   		   @ nLin, nCol1+10 PSAY cConteudo
	   	   DI520GrvLin(nLin,nCol1+10,cConteudo)
   		
	   	   cConteudo := Trans(TRB->W8_VLICMS,AvSx3("W8_VLICMS",6))
           @ nLin, nCol2 PSAY cConteudo
   		   DI520GrvLin(nLin,nCol2,cConteudo)
   		   
           nLin += 4
           cConteudo := " "
	       @ nLin, 0 PSAY cConteudo
   		   DI520GrvLin(nLin,1,cConteudo)
   		   
   		   TRB->(DBSKIP())
   		   cTexto:=cTextoAtual
        ENDDO                 
        @ nLin, 2 PSAY CHR(18)
        
      	cTexto:=cTextoAtual
        
		//***********************************************************//
		//*****                    FIM DO GARE                  *****//  
		//***********************************************************//

	Case nTipo = ICMS_PAG2

		//***********************************************************//
		//***** INICIO DA IMPRESSAO DA EXONERACAO DO ICMS PAG.2 *****//  
		//***********************************************************//
		nCol1     := 15
		nColClass := 37
		nColReg   := 52
		nColFund  := 56
   	    nColVlR   := 125
		nTotAdi2  := 30

        ProcRegua((Work->(LASTREC())*2)+2)
     
         
         Titulo  := "Exoneracao de ICMS - Restante"
         aReturn := { "Zebrado", 1,"Administracao",1,1,1,"",1}
		 cAlias  := "Work"      
         wnrel   := "ICM2001" 
        
         wnrel   := SetPrint(cAlias,wnrel,,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,,,.F.,.F.,,,.F.)
 
         If LastKey() == 27 .OR. nLastKey == 27
            FClose(nHdl)
            FErase(cSpool)
            Return
         EndIf
 
         SetDefault( aReturn, cAlias )
        
         If LastKey() == 27 .OR. nLastKey == 27
            FClose(nHdl)
            FErase(cSpool)
            Return                        
         EndIf

         Set Print On
         Set Device to Print
         SetPrc(0,0)
        
         nLin := 0
         
         cConteudo := Chr(15)
         @ nLin, 1 PSAY cConteudo
         DI520GrvLin(nLin,1,cConteudo)
         
         cConteudo := " "
         @ nLin, nCol1 PSAY cConteudo
         DI520GrvLin(nLin,nCol1,cConteudo)

         nLin+=6 
                         
      	 nCont := 1 
		 Work->(dbGoTop())
		 cWKAUX := "   "
		 DO While !Work->(Eof())
            IncProc("Gerando Arquivo Temporario...")
            
			If Empty(Work->WK_FLAG) .OR. Work->EIJ_FLGICM $ "Ss1"
               Work->(dbSkip())
               Loop			
			Endif
			
			IF WORK->EIJ_AUXIL <> cWKAUX 			            
			   nRecWRK:= WORK->(recno())
	           cWKAUX := WORK->EIJ_AUXIL
	           ncont25 := 0
	           Do while !Work->(eof()) .AND. cWKAUX = WORK->EIJ_AUXIL	           
	              nCont25++
                  WORK->(DBSKIP())
               Enddo      
               WORK->(DBGOTO(nRecWRK)) 
               
               If nCont25+nCont >nTotAdi2
                  ndiflin:=0
                  ndiflin:=(nTotAdi2-nCont)+1
                  nCont := 1

                  nLin += (3+nDifLin)
               
                  cConteudo := " "
                  @ nLin, nCol1 PSAY cConteudo
                  DI520GrvLin(nLin,nCol1,cConteudo)
    
                  nLin+=6                				
               Endif
	        ENDIF   
	        
	        IF !EMPTY(Work->EIJ_ADICAO)
               cConteudo := Work->EIJ_ADICAO
               @ nLin, nCol1 PSAY cConteudo 	
               DI520GrvLin(nLin,nCol1,cConteudo,.F.)
	
               cConteudo :=Trans(Work->EIJ_TEC,AvSx3("YD_TEC",6))
               @ nLin, nColClass PSAY cConteudo
               DI520GrvLin(nLin,nColClass,cConteudo,.F.)

               cConteudo := AllTrim(Work->EIJ_REGICM)
               @ nLin, nColReg PSAY cConteudo 	
               DI520GrvLin(nLin,nColReg,cConteudo,.F.)
            ENDIF   
			
			cConteudo := AllTrim(Work->WK_FUNLEG)
			@ nLin, nColFund PSAY cConteudo 	
			DI520GrvLin(nLin,nColFund,cConteudo,.F.)

			cConteudo :=IF(!EMPTY(Work->EIJ_VLMMN),Trans(Work->EIJ_VLMMN,AvSx3("EIJ_VLMMN",6))," ")
			@ nLin, nColVlr PSAY cConteudo 	
			DI520GrvLin(nLin,nColVlR,cConteudo,.F.)
			
			nLin++                 
			
			Work->(RecLock("Work",.F.))
 			Work->EIJ_FLGICM := "S"       
 			Work->(MsUnlock())
			Work->(dbSkip())		
			nCont++
			lImp := .T.
			
		 EndDo

		 nLin += (nTotAdi2+4-nCont)
		 
         cConteudo := CHR(18)
         @ nLin, 1 PSAY cConteudo
         DI520GrvLin(nLin,1,cConteudo)
        
         cTexto:=cTextoAtual
         	
		//***********************************************************//
		//*****                FIM DO ICMS PAG.2                *****//  
		//***********************************************************//

EndCase
Set Device to Screen
Set Printer to

MS_FLUSH()

FClose(nHdl)
CpyFile(cSpool,cDirRelato+cSpool+".##R")
If nTipo = ICMS         
   CpyFile(cSpool,cDirExoner+AllTrim(Upper(SW6->W6_HOUSE))+".PG1")
ElseIf nTipo = ICMS_PAG2
   CpyFile(cSpool,cDirExoner+AllTrim(Upper(SW6->W6_HOUSE))+".PG2")
EndIf   
FErase(cSpool)
Return Nil

/*
Programa...: 
Funcao.....: DI520GrvLin
Objetivo...: Grava o Arquivo de acordo com a linha e a coluna especificada.
Paramentro.: nLinha , nColuna , cTexto
Retorno....: Nil
Autor......: Osman Medeiros Jr.
Data.......: 08/10/2001
Obs........:
*/
*------------------------------------------------------------*
STATIC Function DI520GrvLin(nLinha,nColuna,cTexto,lInc)
*------------------------------------------------------------*
Local cLin, i
IF lInc = nil
   IncProc("Gerando Arquivo Temporario...")
ENDIF
If (nLinAnt+1) = nLinha
	cLin := Chr(13) + Chr(10)
 	FWrite(nHdl,cLin,Len(cLin))    
	nLinAnt := nLinha
	nColAnt := 0
EndIf 

If nLinAnt < nLinha
	cLin := Chr(13) + Chr(10)
 	FWrite(nHdl,cLin,Len(cLin))    
	nLinAnt++
	For i := 1 to (nLinha-nLinAnt)	
		cLin := " " + Chr(13) + Chr(10)
	 	FWrite(nHdl,cLin,Len(cLin)) 
	Next i
	nColAnt := 0
EndIf 

If nColAnt < nColuna 	
	cLin := Space(nColuna-nColAnt) 
 	FWrite(nHdl,cLin,Len(cLin)) 
EndIf

cLin := cTexto
FWrite(nHdl,cLin,Len(cLin)) 

nLinAnt := nLinha
nColAnt := nColuna+Len(cTexto)

Return Nil					
*--------------------------------------*
Static Function CpyFile(cOrigem,cDestino)
*--------------------------------------*
Local lRet := .f.  
Local hFile1,hFile2
Local cBuffer,nBuffer := 0,nRead,nReadTot := 0,nTotal := 0

Begin Sequence   

   hFile1 := FOpen(cOrigem,0) 
   
   IF hFile1 == -1 
      MsgStop("Nao foi possivel abrir o arquivo: "+cOrigem,"Atenção")
      Break
   Endif
   
   hFile2 := FCreate(cDestino,0) 
   
   IF hFile2 == -1 
      MsgStop("Nao foi possivel criar o arquivo: "+cDestino,"Atenção")
      Break
   Endif
   
   nTotal := FSeek(hFile1,0,2)
   
   nBuffer := Min(50*1024,nTotal) 
   
   FSeek(hFile1,0,0)
   
   DO While nReadTot < nTotal
      cBuffer  := Space(nBuffer) 
      nRead    := FRead(hFile1,@cBuffer,nBuffer) 
      nReadTot += nRead
      
      IF (nRead <> nBuffer .And. nReadTot <> nTotal)
         MsgStop("Nao foi possivel gravar o arquivo: "+cDestino,"Atenção")
         Break
      Endif
      
      FWrite(hFile2,cBuffer,nRead)
   Enddo
   
   FClose(hFile1)
   FClose(hFile2)
   
   lRet := .t.
   
End Sequence

Return lRet

*----------------------------------*
STATIC FUNCTION DI520GrvWork(nExor)
*----------------------------------*
LOCAL cDesc,nCont,nColuna
IncProc("Adicao: " + EIJ->EIJ_ADICAO)

WORK->(DBAPPEND())
WORK1->(DBAPPEND())

If !lPassou
   If !EIJ->EIJ_INCOTE $"CFR/CPT"
      nFreAdicao := ValorFrete(SW6->W6_HAWB,,,1)
   Endif
   lPassou := .T.
Endif   

nFreAdicao += EIJ->EIJ_VSEGMN

AvReplace("EIJ","Work")
AvReplace("EIJ","Work1")

WORK->EIJ_AUXIL:=EIJ->EIJ_ADICAO
WORK1->EIJ_AUXIL:=EIJ->EIJ_ADICAO

If !(EIJ->EIJ_FLGICM $ "Ss1")
   Work->WK_FLAG:=cMarca
   WORK1->WK_FLAG:=cMarca   
   nExor++
ENDIF


EIQ->(DBSEEK(xFilial("EIQ")+EIJ->EIJ_EXOICM))

cDesc:=MSMM(EIQ->EIQ_TEXCOD,nLenDesc)
cDesc:=STRTRAN(cDesc, CHR(13)+CHR(10), " ")
WORK->WK_FUNLEG:=MEMOLINE(cDesc,nLenDesc,1)
WORK1->WK_FUNLEG:=MEMOLINE(cDesc,nLenDesc,1)
WORK1->WKCOD:=EIJ->EIJ_EXOICM

nColuna:=MlCount(cDesc,nLenDesc)

FOR nCont:=2 TO nColuna                     

   IF EMPTY(MEMOLINE(cDesc,nLenDesc,nCont))
      LOOP
   ENDIF
   
   WORK->(DBAPPEND())
   WORK->EIJ_AUXIL:=EIJ->EIJ_ADICAO   
   WORK->WK_FUNLEG:=MEMOLINE(cDesc,nLenDesc,nCont)
   WORK->WK_FLAG:=cMarca   
NEXT    

RETURN .T.               

*-----------------------------------------*
STATIC FUNCTION DI520Marca(cTipo,nTotMark)
*-----------------------------------------*
DO CASE

  CASE cTipo=="M"
  
     If Work1->EIJ_FLGICM $ "Ss1"
        MsgInfo("A exoneracao do ICMS desta adicao ja foi impressa.","Informacao")
     ENDIF   
     Work1->WK_FLAG:=cMarca     
     WORK->(DBSEEK(WORK1->EIJ_AUXIL))
     DO WHILE !WORK->(EOF()) .AND. WORK->EIJ_AUXIL==WORK1->EIJ_AUXIL
        Work->WK_FLAG:=cMarca
        nTotMark++
        WORK->(DBSKIP())
     ENDDO   
     DI520AtuBtn(nTotMark)     
   
  CASE cTipo=="D"
  
	Work1->WK_FLAG := " "
   WORK->(DBSEEK(WORK1->EIJ_AUXIL))
   
   DO WHILE !WORK->(EOF()) .AND. WORK->EIJ_AUXIL==WORK1->EIJ_AUXIL
      Work->WK_FLAG:=" "
      nTotMark--
      WORK->(DBSKIP())
   ENDDO
	DI520AtuBtn(nTotMark)	
ENDCASE

RETURN .T.  

*-----------------------------------*
STATIC FUNCTION DI520VALID(cTipo)
*-----------------------------------*
DO CASE 

   CASE cTipo=="HAWB"
   
      IF !ExistCpo("SW6",cHawb)
         RETURN .F.
      ENDIF   
   
   CASE cTipo=="MENSAGEM"
     SY7->(DBSETORDER(3))
     IF !SY7->(DBSEEK(xFilial()+'A'+cObs))
        Help(" ",1,"REGNOIS",,,,)
        SY7->(DBSETORDER(1))
        Return .F.
     ENDIF
     SY7->(DBSETORDER(1))
     DI520ALTERA()
    
ENDCASE

RETURN .T.

*---------------------------------*
STATIC FUNCTION DI520CRIAWORKS()
*---------------------------------*
Local aSemSx3 := {{"WK_FLAG"    ,"C",2,0},;
						{"EIJ_ADICAO" ,AvSx3("EIJ_ADICAO",2),AvSx3("EIJ_ADICAO",3),AvSx3("EIJ_ADICAO",4)},;
						{"WKCOD"      ,AvSx3("EIQ_CODIGO",2),AvSx3("EIQ_CODIGO",3),AvSx3("EIQ_CODIGO",4)},;						
						{"EIJ_AUXIL" ,AvSx3("EIJ_ADICAO",2),AvSx3("EIJ_ADICAO",3),AvSx3("EIJ_ADICAO",4)},;//CAMPO AUXLIAR PARA IMPRESSAO DA EXONERACAO
						{"EIJ_TEC"    ,AvSx3("EIJ_TEC"   ,2),AvSx3("EIJ_TEC"   ,3),AvSx3("EIJ_TEC"   ,4)},;
						{"EIJ_MOEDA"  ,AvSx3("EIJ_MOEDA" ,2),AvSx3("EIJ_MOEDA" ,3),AvSx3("EIJ_MOEDA" ,4)},;
						{"EIJ_VLMLE"  ,AvSx3("EIJ_VLMLE" ,2),AvSx3("EIJ_VLMLE" ,3),AvSx3("EIJ_VLMLE" ,4)},;
						{"EIJ_VLMMN"  ,AvSx3("EIJ_VLMMN" ,2),AvSx3("EIJ_VLMMN" ,3),AvSx3("EIJ_VLMMN" ,4)},;
						{"EIJ_NROLI"  ,AvSx3("EIJ_NROLI" ,2),AvSx3("EIJ_NROLI" ,3),AvSx3("EIJ_NROLI" ,4)},;
						{"EIJ_FLGICM" ,AvSx3("EIJ_FLGICM",2),AvSx3("EIJ_FLGICM",3),AvSx3("EIJ_FLGICM",4)},;
						{"EIJ_REGICM" ,"C",01,0},;
						{"WK_REGTRI"  ,"C",01,0},;
						{"WK_FUNLEG"  ,"C",nLenDesc,0},;
						{"EIJ_VLICMS" ,AvSx3("EIJ_VLICMS",2),AvSx3("EIJ_VLICMS",3),AvSx3("EIJ_VLICMS",4)}}
						
LOCAL aTRB:={{"W6_REF_DES","C",AVSX3("W6_REF_DES",3),0},;
             {"W6_HAWB"  ,"C" ,AVSX3("W6_HAWB",3),0},;
             {"W8_VLII" ,"N",AVSX3("W8_VLII",3),AVSX3("W8_VLII",4)},;
             {"W8_VLIPI","N",AVSX3("W8_VLIPI",3),AVSX3("W8_VLIPI",4)},;
             {"W8_BASEII","N",AVSX3("W8_BASEII",3),AVSX3("W8_BASEII",4)},;
             {"W8_BASEICM","N",AVSX3("W8_BASEICM",3),AVSX3("W8_BASEICM",4)},;
             {"W8_VLICMS","N",AVSX3("W8_VLICMS",3),AVSX3("W8_VLICMS",4)},;             
             {"WZ_CFO"    ,"C",AVSX3("WZ_CFO",3),0},;
             {"WZ_AL_ICMS","N",AVSX3("WZ_AL_ICMS",3),AVSX3("WZ_AL_ICMS",4)},;
             {"WZ_RED_ICM","N",AVSX3("WZ_RED_ICM",3),AVSX3("WZ_RED_ICM",4)}}

aSemSx3:= AddWkCpoUser(aSemSx3,"EIJ")   

cNomArq := E_CriaTrab(,aSemSx3,"WORK")
IndRegua("WORK",cNomArq+OrdBagExt(),"EIJ_AUXIL")

cNomArq1:= E_CriaTrab(,aSemSx3,"Work1")
IndRegua("Work1",cNomArq1+OrdBagExt(),"EIJ_AUXIL")

cNomArq2:= E_CriaTrab(,aTRB,"TRB")
IndRegua("TRB",cNomArq2+OrdBagExt(),"WZ_CFO")


RETURN .T.

*--------------------------------*
STATIC FUNCTION DI520ALTERA()
*--------------------------------*
SY7->(DBSETORDER(3))
SY7->(DBSEEK(xFilial()+'A'+cObs))
cTexto:=MSMM(SY7->Y7_TEXTO,AVSX3("Y7_VM_TEXT",3))
SY7->(DBSETORDER(1))
RETURN .T.                   

*--------------------------------*
STATIC FUNCTION DI520OBSERVACAO()
*--------------------------------*
cTexto:=StrTran(cTexto,"#CIF",TRANS(TRB->W8_BASEII,AVSX3("W8_BASEII",6)))
cTexto:=StrTran(cTexto,"#II",TRANS(TRB->W8_VLII,AVSX3("W8_VLII",6)))
cTexto:=StrTran(cTexto,"#IPI",TRANS(TRB->W8_VLIPI,AVSX3("W8_VLIPI",6)))
cTexto:=StrTran(cTexto,"#ALIQUOTA",TRANS(TRB->WZ_RED_ICM,AVSX3("EIJ_ALI_II",6)))
cTexto:=StrTran(cTexto,"#BASE REDUZIDA",TRANS(TRB->W8_BASEICM,AVSX3("W8_BASEICM",6)))
cTexto:=StrTran(cTexto,"#ALIQ.ICMS",TRANS(TRB->WZ_AL_ICMS,AVSX3("EIJ_ALI_II",6)))
cTexto:=StrTran(cTexto,"#N/REF","  "+TRANS(TRB->W6_REF_DES,AVSX3("W6_REF_DES",6)))
cTexto:=StrTran(cTexto,"#S/REF","  "+TRANS(TRB->W6_HAWB,AVSX3("W6_HAWB",6)))   

RETURN 
