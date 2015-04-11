#INCLUDE "rwmake.ch"


User Function ExpSa1Exc() // Exportar SA1 Para fazer o MSEXECAUTO

Private oGeraTxt
Private cString := "SB1"

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say "                                                            "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)

Activate Dialog oGeraTxt Centered

Return( NIL )

//***********************************************************************

Static Function OkGeraTxt

Local cExtens   := "*.TXT"     
Local cTitulo1  := "Informe o Arquivos " 

Private cArqTxt := "C:\ExportSB1.txt"

Private nHdl    := fCreate(cArqTxt)

Private cEOL    := CHR(13)+CHR(10)

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return( NIL )
Endif

Processa({|| RunContSB1() },"Processando...")

Return( NIL )

//***********************************************************************

Static Function RunContSB1()

Local cLin

dbSelectArea(cString)

(cString)->( dbGoTop() )

ProcRegua(RecCount()) // Numero de registros a processar

While ! (cString)->( EOF() )

    IncProc()

    cLin	:= Iif( Empty( (cString)->B1_COD    ), "|#|", Alltrim( (cString)->B1_COD    ) ) + ";"
    cLin	+= Iif( Empty( (cString)->B1_DESC   ), "|#|", Alltrim( (cString)->B1_DESC   ) ) + ";"
    cLin	+= Iif( Empty( (cString)->B1_TIPO   ), "|#|", Alltrim( (cString)->B1_TIPO   ) ) + ";"        
    cLin	+= Iif( Empty( (cString)->B1_UM     ), "|#|", Alltrim( (cString)->B1_UM     ) ) + ";"
    cLin	+= Iif( Empty( (cString)->B1_LOCPAD ), "|#|", Alltrim( (cString)->B1_LOCPAD ) ) + ";"
    cLin	+= Iif( Empty( (cString)->B1_GARANT ), "1"  , Alltrim( (cString)->B1_GARANT ) ) + cEOL
    
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            Exit
        Endif
    Endif

    (cString)->(dbSkip())
    
EndDo

fClose(nHdl)
Close(oGeraTxt)

MsgInfo("Arquivo Gerado com Sucesso: " + cArqTxt )


Return( NIL )

//*********************************************************************************************************************************

User Function MsExcSA1() 

Private oLeTxt

Private cString := "SB1"

dbSelectArea("SB1")
dbSetOrder(1)

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme    "
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo "
@ 26,018 Say " SB1                                                               "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return( NIL )

//***********************************************************************
Static Function OkLeTxt

Local cExtens	:= "Arquivo TXT | *.TXT"
Local cTitulo1 := "Selecione o arquivo"

Private cArqTxt := ""
Private nHdl    := fOpen(cArqTxt,68)
Private cEOL    := "CHR(13)+CHR(10)" 

cArqTxt := cGetFile(cExtens,cTitulo1,,,.T.)

If !File(cArqTxt)
	MsgAlert("Arquivo texto: "+cArqTxt+" não localizado",cCadastro)
	Return
Endif


Processa({|| RunCont() },"Processando...")

Return( NIL )

//***************************************************************************************************

Static Function RunCont

Local cBuffer
Local nOpc := 3

Private lMsHelpAuto := .T. // Variavel de controle interno do ExecAuto
Private lMsErroAuto := .F. // Variavel que informa a ocorrência de erros no ExecAuto

cBuffer    := ""
aDadCab    := {}  
aExecItens := {}

FT_FUSE(cArqTxt)  //ABRIR

FT_FGOTOP() //PONTO NO TOPO

ProcRegua(FT_FLASTREC()) //QTOS REGISTROS LER

While ! FT_FEOF()     

	IncRegua()

	cBuffer := FT_FREADLN() //LENDO LINHA
	
	aDadCab := StrToKArr( cBuffer, ";" )

   aExecItens := {}
	
   aAdd( aExecItens, { "B1_COD"	   , IIF( Alltrim( aDadCab[01] ) == "|#|", "", Alltrim( aDadCab[01] ) ), Nil } )    //Codigo do Produto
   aAdd( aExecItens, { "B1_DESC"   , IIF( Alltrim( aDadCab[02] ) == "|#|", "", Alltrim( aDadCab[02] ) ), Nil } )    //Descrição      
   aAdd( aExecItens, { "B1_TIPO"   , IIF( Alltrim( aDadCab[03] ) == "|#|", "", Alltrim( aDadCab[03] ) ), Nil } )    //Tipo 
   aAdd( aExecItens, { "B1_UM"	   , IIF( Alltrim( aDadCab[04] ) == "|#|", "", Alltrim( aDadCab[04] ) ), Nil } )    //Unidade
   aAdd( aExecItens, { "B1_LOCPAD" , IIF( Alltrim( aDadCab[05] ) == "|#|", "", Alltrim( aDadCab[05] ) ), Nil } )    //Armazem
   aAdd( aExecItens, { "B1_GARANT" , IIF( Alltrim( aDadCab[06] ) == "|#|", "", Alltrim( aDadCab[06] ) ), Nil } )    //Garantia 1-Sim 2-Nao
	
	MSExecAuto( { | x, y | MATA010( x, y ) }, aExecItens, nOpc ) 
		
	If lMsErroAuto
		MsAlert("Erro no ExecAuto","Atenção !!!")
		DisarmTransaction() // Libera sequencial
		RollBackSx8()                      
		MostraErro()
		Return( NIL )
	EndIf
	
	FT_FSKIP()
		
EndDo

FT_FUSE() //fecha o arquivo txt

If !lMsErroAuto
	MsInfo("Sucesso na execução do ExecAuto","Atenção !!!")
EndIf

Return( NIL )