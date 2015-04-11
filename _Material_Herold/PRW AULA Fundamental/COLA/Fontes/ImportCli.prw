#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"

User Function ImportCli()

Private oLeTxt

@200,1 to 380,380 Dialog oLeTxt Title OemToAnsi("Leitua de Arquivo Texto")

@02,10 To 80,190

@10,018 Say "Este programa ira ler o conteudo de um arquivo texto, conforme"
@18,018 Say "os parametros definidos pelo usuario, com os registros do arquivo"
@26,018 Say "SA1"

@70,128 BmpButton Type 01 Action (OkLeTxt(), Close(oLeTxt))
@70,158 BmpButton Type 02 Action Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return Nil

//-----------------------------------------------------------------------//
Static Function OkLeTxt()

Private cArqTxt := "C:\AP8\SYSTEMN\CLIENTES.TXT"
Private nHdl := FOpen(cArqTxt,68)
Private cEOL := "Chr(13)+Chr(10)"

If Empty(cEOL)
   cEOL := Chr(13)+Chr(10)
 Else
   cEOL := Trim(cEOL)
   cEOL := &cEOL
EndIf

If nHdl == -1
   MsgAlert("O arquivo de nome " + cArqTxt + " nao pode ser aberto!", "Atencao!")
   Return
EndIf

Processa({||RunCont()},"Processando...")

Return Nil

//-----------------------------------------------------------------------//
Static Function RunCont()

Local nTamFile, nTamLin, cBuffer, nBtLidos
Local cLinha
Local cEOL := Chr(13)+Chr(10)


nTamFile := FSeek(nHdl,0,2)
FSeek(nHdl,0,0)
nTamLin := 127 + Len(cEOL)
cBuffer := Space(nTamLin)
nBtLidos := FRead(nHdl,@cBuffer,nTamLin)

ProcRegua(nTamFile)

While nBtLidos >= nTamLin

   IncProc()

   cLinha := "Codigo: " + Substr(cBuffer,3,6)   + cEOL +;
             "Loja:   " + Substr(cBuffer,9,2)   + cEOL +;
             "Nome:   " + Substr(cBuffer,11,40) + cEOL +;
             "PF/PJ:  " + Substr(cBuffer,51,1)

   MsgInfo(cLinha)

   nBtLidos := FRead(nHdl,@cBuffer,nTamLin)

End

FClose(nHdl)

Return Nil
