#INCLUDE "rwmake.ch"  
#INCLUDE "Protheus.ch"
//#INCLUDE "impcigna.ch"
                                  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPCIGNA  บ Autor ณ Kleber Dias Gomes  บ Data ณ  28/07/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importacao CIGNA.                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5 IDE                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณProgramadoณ Data	  ณ BOPS ณ  Motivo da Alteracao 					  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ28/09/04ณ------ณRetorna ao Menu principal final processo    ณฑฑ
ฑฑณFrancisco ณ11/01/09ณ------ณCompatibilizacao para Gestao Corporativa    ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function IMPCIGNA


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private _cString     := "SRA"
Private _cPerg       := "IMPCIG"
Private _oLeTxt

Pergunte(_cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,450 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 060,215
@ 10,018 Say " Este programa ira ler o movimento de um arquivo texto, gerado pela CIGNA"	SIZE 196,0
@ 18,018 Say " Esse procedimento devera ser realizado antes do calculo da folha de "		SIZE 196,0
@ 26,018 Say " pagamento."																	SIZE 196,0

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 01 ACTION OkLeTxt( oLeTxt )
@ 70,188 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ AP5 IDE            บ Data ณ  28/07/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a leitura do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkLeTxt( oLeTxt )

Local aVerba := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas na pergunte                                 ณ
//ณ mv_par01	// Path origem                                       ณ
//ณ mv_par02	// Semana                                            ณ
//ณ mv_par03	// Data Geracao                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private _cFile		:= mv_par01
Private _cSemana	:= mv_par02
Private _dDatGer    := mv_par03

Private _nHdlR	:= fOpen(_cFile,68)

If 	TRIM(_cSemana) == "" .or. TRIM(_cFile) == ""
	MsgAlert("Os parametros obrigatorios nao estao preenchidos! Verifique os parametros.","Atencao!")
	Return
EndIf

If _nHdlR == -1
	MsgAlert("O arquivo "+_cFile+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado.                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fClose(_nHdlR)

aAdd(aVerba,{"FILIAL", "C",FWGETTAMFILIAL+3,0})
aAdd(aVerba,{"MAT",    "C",16,0})
aAdd(aVerba,{"DATA",   "D",08,0})
aAdd(aVerba,{"VERBA",  "C",04,0})
aAdd(aVerba,{"HORA",   "C",06,0})
aAdd(aVerba,{"VALREF", "N",15,2})
aAdd(aVerba,{"VALOR",  "N",15,2})
aAdd(aVerba,{"VALORIG","N",15,2})
aAdd(aVerba,{"ALTERA", "C",01,0})
aAdd(aVerba,{"STATUS", "C",01,0})

cArqVerba := CriaTrab(aVerba, .T.)
dbUseArea(.T.,,cArqVerba,"VER",.F.)
dbSelectArea("VER")
Append From (_cFile) Delimited With ";"
dbGoTop()
cIndVerba := CriaTrab(Nil,.F.)
IndRegua("VER",cIndVerba,"FILIAL+MAT",,,"Selecionando Registros...")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa({|| RunCont() },"Processando...")
close(oLeTxt) 
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  28/07/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont

Local _lGravou	:= .F.
Local _cEFilMat	:= ""
Local _cChave	:= ""
Local _cCc		:= ""
Local _aRecTrf	:= {}
Local _cFilialP	:= ""
Local _cMatP	:= ""
Local _cFileEnv := Subst(_cFile,1,At("FFRM",UPPER(_cFile))-1)+"FFRT"+Subst(_cFile,At("FFRM",UPPER(_cFile))+4,Len(_cFile))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo texto                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	File(_cFileEnv)
	fErase(_cFileEnv)
EndIf

Private _nHdlE    := fCreate(_cFileEnv)

Private _cEOL    := "CHR(13)+CHR(10)"

If Empty(_cEOL)
	_cEOL := CHR(13)+CHR(10)
Else
	_cEOL := Trim(_cEOL)
	_cEOL := &_cEOL
Endif

If _nHdlE == -1
	MsgAlert("O arquivo "+_cFileEnv+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
EndIf

dbSelectArea("VER")
dbGoTop()

ProcRegua(VER->(RecCount()))

_nTamLin := 26
_cLin    := Space(_nTamLin)+_cEOL // Variavel para criacao da linha do registros para gravacao

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Substitui nas respectivas posicioes na variavel cLin pelo conteudo  ณ
//ณ dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     ณ
//ณ string dentro de outra string.                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cCpo := "H"+"00"+"      "+"RE2"+"CR"+Transforma(_dDatGer)+"POS"
_cLin := Stuff(_cLin,01,26,_cCpo)

If fWrite(_nHdlE,_cLin,Len(_cLin)) != Len(_cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return( NIL )
	Endif
Endif

While !Eof()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Incrementa a regua                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IncProc()
	
	dbSelectArea("SRA")
	dbSetOrder(1)
	If dbSeek(StrZero(Val(Trim(VER->FILIAL)),FWGETTAMFILIAL)+Trim(VER->MAT))
		If SRA->RA_SITFOLH # "D"
			If SRA->RA_TIPOPGT == "S"
				GravaSRC(SRA->RA_FILIAL,SRA->RA_MAT,Subs(VER->VERBA,2,3),_dDatGer,SRA->RA_CC,"","V","G",,VER->VALOR,0,,.F.,)
				_lGravou := .T.
			Else
				GravaSRC(SRA->RA_FILIAL,SRA->RA_MAT,Subs(VER->VERBA,2,3),_dDatGer,SRA->RA_CC,cSemana,"V","G",,VER->VALOR,0,,.F.,)
				_lGravou := .T.
			EndIf
		EndIf
	Else
		_cChave := StrZero(Val(Trim(VER->FILIAL)),FWGETTAMFILIAL)+Trim(VER->MAT)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Seleciona o Arquivo de Transferencias                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("SRE")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(cEmpAnt+_cChave)
			_cEFilMat := cEmpAnt+_cChave
			_cCc      := SRE->RE_CCD
			While ! EOF() .And. SRE->RE_EMPD+SRE->RE_FILIALD+SRE->RE_MATD == _cEFilMat
				If SRE->RE_CCD == _cCc
					If Ascan(_aRecTrf,SRE->(RECNO())) > 0
						dbSkip()
						Loop
					Else
						Aadd(_aRecTrf,SRE->(RECNO()))
					Endif
				EndIf
				If(SRE->RE_EMPD+SRE->RE_FILIALD+SRE->RE_MATD+SRE->RE_CCD==_cEFilMat+_cCc)
					_cEFilMat := SRE->RE_EMPP + SRE->RE_FILIALP + SRE->RE_MATP
					_cCc      := SRE->RE_CCP
					If SRE->RE_EMPD + SRE->RE_FILIALD + SRE->RE_MATD # _cEFilMat
						If MesAno(SRE->RE_DATA) >= MesAno(CtoD("01"+"/"+StrZero(Month(_dDatGer)-1,2)+"/"+Str(Year(_dDatGer),4)))
							If SRE->RE_EMPP == SRE->RE_EMPD
								_cFilialP := SRE->RE_FILIALP
								_cMatP	  := SRE->RE_MATP
							EndIf
						EndIf
					EndIf
					dbSeek(_cEFilMat)
				Else
					dbSkip()
				EndIf
			EndDo
			If _cFilialP+_cMatP # "" .And. _cFilialP+_cMatP # StrZero(Val(Trim(VER->FILIAL)),FWGETTAMFILIAL)+Trim(VER->MAT)
				dbSelectArea("SRA")
				dbSetOrder(1)
				If dbSeek(_cFilialP+_cMatP)
					If SRA->RA_TIPOPGT == "S"
						GravaSRC(SRA->RA_FILIAL,SRA->RA_MAT,Subs(VER->VERBA,2,3),_dDatGer,SRA->RA_CC,"","V","G",,VER->VALOR,0,,.F.,)
						_lGravou := .T.
					Else
						GravaSRC(SRA->RA_FILIAL,SRA->RA_MAT,Subs(VER->VERBA,2,3),_dDatGer,SRA->RA_CC,cSemana,"V","G",,VER->VALOR,0,,.F.,)
						_lGravou := .T.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	
	RecLock("VER",.F.)
	If _lGravou
		VER->STATUS    := "1"
	Else
		VER->STATUS    := "2"
	EndIf
	MsUnLock()
	
	_nTamLin := 94
	_clin    := Space(_nTamLin)+_cEOL // Variavel para criacao da linha do registros para gravacao
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Substitui nas respectivas posicioes na variavel _clin pelo conteudo ณ
	//ณ dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     ณ
	//ณ string dentro de outra string.                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	_cCpo := PADR("D",01)
	_clin := Stuff(_clin,01,01,_cCpo)
	_cCpo := PADR("23",02)
	_clin := Stuff(_clin,02,02,_cCpo)
	_cCpo := PADR("NW",02)
	_clin := Stuff(_clin,04,02,_cCpo)
	_cCpo := PADR("00",03)
	_clin := Stuff(_clin,06,03,_cCpo)
	_cCpo := PADR(Space(25),25)
	_clin := Stuff(_clin,09,25,_cCpo)
	_cCpo := PADR(Space(10),10)
	_clin := Stuff(_clin,34,10,_cCpo)
	_cCpo := StrTran(StrZero(VER->VALOR,13,2),".",",")
	_clin := Stuff(_clin,44,13,_cCpo)
	_cCpo := PADR(VER->STATUS,01)
	_clin := Stuff(_clin,57,01,_cCpo)
	_cCpo := PADR(StrZero(Val(Trim(VER->FILIAL)),FWGETTAMFILIAL),FWGETTAMFILIAL + 3)
	_clin := Stuff(_clin,58,05,_cCpo)
	_cCpo := PADR(Trim(VER->MAT),10)
	_clin := Stuff(_clin,63,10,_cCpo)
	_cCpo := PADR(StrZero(Month(_dDatGer),2)+Right(Str(Year(_dDatGer)),4),06)
	_clin := Stuff(_clin,73,06,_cCpo)
	_cCpo := PADR(Trim(VER->VERBA),16)
	_clin := Stuff(_clin,79,16,_cCpo)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
	//ณ linha montada.                                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If fWrite(_nHdlE,_clin,Len(_clin)) != Len(_clin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif
	
	
	dbSelectArea("VER")
	dbSkip()
	_lGravou := .F.
EndDo

dbSelectArea("VER")
dbCloseArea()
FErase(cArqVerba+GetDBExtension())

fClose(_nHdlR)
fClose(_nHdlE)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Deve ser fechado, o dialogo criado na funcao anterior.              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Close(oLeTxt)

Return

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณTransforma ณ Autor ณ Kleber Dias Gomes    ณ Data ณ 17/07/00 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Transforma as datas no formato DDMMAAAA                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ Transforma(ExpD1)                                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpD1 = Data a ser convertido                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ ExpCigna                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function Transforma(dData)
Return(StrZero(Day(dData),2)+StrZero(Month(dData),2)+Right(Str(Year(dData)),4))