#INCLUDE "rwmake.ch"

User Function ExportSAH

Private oGeraTxt
Private cString := "SAH"

dbSelectArea(cString)
(cString)->(dbSetOrder(1))


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

Private cArqTxt := "C:\ExportSAH.txt"

Private nHdl    := fCreate(cArqTxt)

Private cEOL    := CHR(13)+CHR(10)


If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return( NIL )
Endif


Processa({|| RunCont() },"Processando...")

Return( NIL )

//***********************************************************************

Static Function RunCont()

Local nTamLin, cLin

dbSelectArea(cString)

(cString)->( dbGoTop() )

ProcRegua((cString)->(RecCount())) // Numero de registros a processar

While ! (cString)->( EOF() )

    IncProc()
   
    cLin	:= Iif( Empty(AH_UNIMED), "|#|", Alltrim( AH_UNIMED ) ) + ";"
    cLin	+= Iif( Empty(AH_UMRES),  "|#|", Alltrim( AH_UMRES  ) ) + ";"
    cLin	+= Iif( Empty(AH_DESCPO), "|#|", Alltrim( AH_DESCPO ) ) + ";"        
    cLin	+= Iif( Empty(AH_DESCIN), "|#|", Alltrim( AH_DESCIN ) ) + ";"
    cLin	+= Iif( Empty(AH_DESCES), "|#|", Alltrim( AH_DESCES ) ) + cEOL
    
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
