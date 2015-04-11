#INCLUDE "rwmake.ch"

User Function ImpSAH()

Private oLeTxt

Private cString := "SAH"

dbSelectArea("SAH")
dbSetOrder(1)

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say " SAH                                                           "

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
Private cEOL    := CHR(13)+CHR(10)

cArqTxt := cGetFile(cExtens,cTitulo1,,,.T.)

If !File(cArqTxt)
	MsgAlert("Arquivo texto: "+cFileOpen+" não localizado",cCadastro)
	Return
Endif
                 

Processa({|| RunCont() },"Processando...")

Return( NIL )

//***************************************************************************************************

Static Function RunCont

Local cBuffer

cBuffer  := ""
aDadCab  := {}

DbSelectArea("SAH")
SAH->( DbSetOrder(1) )

FT_FUSE(cArqTxt)  //ABRIR

FT_FGOTOP() //PONTO NO TOPO

ProcRegua(FT_FLASTREC()) //QTOS REGISTROS LER

While ! FT_FEOF()
	cBuffer := FT_FREADLN() //LENDO LINHA
	
	aDadCab := StrToKArr( cBuffer, ";" )
	
	SAH->(DbSetOrder(1))

	If SAH->( dbSeek(xFilial("SAH")+AvKey(aDadCab[01],"AH_UNIMED") ) )
		RecLock("SAH",.F.)                                                
	Else	                                                               
		RecLock("SAH",.T.)                                                
	EndIf	                                                                      
	
	SAH->AH_UNIMED	:= IIF(Alltrim(aDadCab[01]) == "|#|","",Alltrim(aDadCab[01]))
	SAH->AH_UMRES	:= IIF(Alltrim(aDadCab[02]) == "|#|","",Alltrim(aDadCab[02]))
	SAH->AH_DESCPO := IIF(Alltrim(aDadCab[03]) == "|#|","",Alltrim(aDadCab[03]))
	SAH->AH_DESCIN := IIF(Alltrim(aDadCab[04]) == "|#|","",Alltrim(aDadCab[04]))
	SAH->AH_DESCES := IIF(Alltrim(aDadCab[05]) == "|#|","",Alltrim(aDadCab[05]))
	SAH->(MsUnLock())
	
	FT_FSKIP()
	
EndDo

FT_FUSE() //fecha o arquivo txt

MsgInfo("Processo finalizado")

Return( NIL )