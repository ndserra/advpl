#INCLUDE "Rtmsr07.ch"
#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR07   ³ Autor ³Robson / Patricia      ³ Data ³25.03.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime a Ficha do Motorista                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR07()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ EXPC1 - Numero da Entrada                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR07			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RTMSR07()

Local titulo   := STR0002 //"Ficha do Motorista"
Local cString  := "DTO"
Local wnrel    := "RTMSR07" // Nome Default do relatorio em Disco.
Local cDesc1   := STR0001 //"Este programa ir  emitir a Ficha do Motorista."
Local cDesc2   := ""
Local cDesc3   := ""
Local Tamanho  := "M"

Private NomeProg := "RTMSR07"
Private aReturn  := { STR0003, 1,STR0004, 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
Private cPerg    := ''
Private nLastKey := 0
Private lContVei := GetMV('MV_CONTVEI',,.T.)

If	lContVei
	cPerg := 'RTMR07'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas como parametros                                  ³
	//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	//³ mv_par01	// Entrada De         ?                                    ³
	//³ mv_par02	// Entrada Ate        ?                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte('RTMR07', .F.)
Else
	RTmsR07SX1()
	cPerg := 'RTMR7A'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas como parametros                                  ³
	//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	//³ mv_par01	// Motorista De       ?                                    ³
	//³ mv_par02	// Motorista Ate      ?                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte('RTMR7A', .F.)
EndIf

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

If	lContVei
	RptStatus({|lEnd| RTmsr07Imp(@lEnd, wnRel, Titulo, Tamanho)}, STR0005) //"Imprimindo a Ficha do Motorista"
Else
	RptStatus({|lEnd| RTmsR07DA4(@lEnd, wnRel, Titulo, Tamanho)}, STR0005)  //"Imprimindo a Ficha do Motorista"
EndIf

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTmsr07Imp³ Autor ³ Robson Alves          ³ Data ³20.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime a Ficha do Motorista baseado no arquivo de         ³±±
±±³          ³ movimento de motoristas quando o parametro MV_CONTVEI = .T.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Abandona a impressao(.T. = Sim/.F. = Nao).         ³±±
±±³          ³ ExpC1 = Retorno da funcao SetPrint.                        ³±±
±±³          ³ ExpC2 = Titulo do relatorio.                               ³±±
±±³          ³ ExpN1 = Tamanho do relatorio.                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTmsr07Imp(lEnd, wnRel, Titulo, Tamanho)

Local cIndDTO  := ""
Local cKeyDTO  := ""
Local cCond    := ""
Local nIndDTO  := ""
Local cStatus  := StrZero(4, Len(DTO->DTO_STATUS)) // Baixado.
Local aRetBox1 := RetSx3Box( Posicione("SX3", 2, "DA3_ATIVO", "X3CBox()" ),,, 1 )
Local aRetBox3 := RetSx3Box( Posicione("SX3", 2, "DA4_BLQMOT", "X3CBox()" ),,, 1 )
Local aPropri  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis utilizadas para Impressao do cabecalho e rodape.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cbtxt  := Space(10)
Private cbcont := 0
Private m_pag  := 1
Private Li     := 80
Private nTipo  := aReturn[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera indice temporario do DTO(Movimento de Motoristas).      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("DTO")
cIndDTO := CriaTrab(Nil, .F.)
cKeyDTO := IndexKey()

cCond := 'DTO_FILIAL == "' + xFilial("DTO") + '".And.' 
cCond += 'DTO_NUMENT >= "' + mv_par01 + '".And.'
cCond += 'DTO_NUMENT <= "' + mv_par02 + '".And.'
cCond += 'DTO_STATUS != "' + cStatus + '"'

IndRegua("DTO",cIndDTO,cKeyDTO,,cCond, STR0011 ) //"Selecionando Registros ..."
nIndDTO := RetIndex("DTO")
dbSelectArea("DTO")
dbSetOrder(nIndDTO + 1)
dbGoTop()
SetRegua(RecCount())

While !Eof()
	Li := 80 // Uma ficha por pagina.
	
	If li > 58
		Cabec(titulo,"","",wnrel,Tamanho)
	EndIf
	IncRegua()

	dbSelectArea("DTU")
	dbSetOrder(1)
	MsSeek(xFilial("DTU") + DTO->DTO_NUMENT)
	
	While !Eof() .And. DTU->DTU_FILIAL + DTU->DTU_NUMENT == xFilial("DTU") + DTO->DTO_NUMENT
		
		RTmsR07Vei( aPropri, aRetBox1, DTU->DTU_CODVEI, @Li )

		dbSelectArea("DTU")
		dbSkip()
	EndDo

	RTmsR07Pro( aPropri, @Li )

	RTmsR07Mot( aRetBox3, DTO->DTO_CODMOT, @Li )

	dbSelectArea("DTO")
	dbSkip()
EndDo

// Apaga o indice temporario do DTO(Movimento de Motoristas).
dbSelectArea("DTO")
RetIndex("DTO")
Ferase(cIndDTO + OrdBagExt())

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTmsR07DA4³ Autor ³ Alex Egydio           ³ Data ³05.04.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime a Ficha do Motorista baseado no arquivo de         ³±±
±±³          ³ motoristas quando o parametro MV_CONTVEI = .F.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Abandona a impressao(.T. = Sim/.F. = Nao).         ³±±
±±³          ³ ExpC1 = Retorno da funcao SetPrint.                        ³±±
±±³          ³ ExpC2 = Titulo do relatorio.                               ³±±
±±³          ³ ExpN1 = Tamanho do relatorio.                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function RTmsR07DA4(lEnd,wnRel,Titulo,Tamanho)

Local aRetBox1 := RetSx3Box(Posicione('SX3',2,'DA3_ATIVO' ,'X3CBox()'),,,1)
Local aRetBox3 := RetSx3Box(Posicione('SX3',2,'DA4_BLQMOT','X3CBox()'),,,1)
Local aPropri  := {}
Local cBlqMot	:= StrZero(2,Len(DA4->DA4_BLQMOT))
Local cIndDA4	:= ''
Local cQuery	:= ''
Local cSeek		:= ''
Local nIndex	:= 0
//-- Variaveis utilizadas p/impressao do cabecalho e rodape
Private cbtxt  := Space(10)
Private cbcont := 0
Private m_pag  := 1
Private Li     := 80
Private nTipo  := aReturn[4]

//-- Gera indice temporario p/motoristas
DbSelectArea('DA4')
cIndDA4 := CriaTrab(Nil,.F.)
DA4->(DbSetOrder(1))

cQuery := 'DA4_FILIAL == "' + xFilial("DA4") + '".And.'
cQuery += 'DA4_COD    >= "' + mv_par01 + '".And.'
cQuery += 'DA4_COD    <= "' + mv_par02 + '".And.'
cQuery += 'DA4_BLQMOT == "' + cBlqMot  + '"'
	
IndRegua('DA4',cIndDA4,DA4->(IndexKey()),,cQuery, STR0042 ) //"Selecionando Motoristas..."
nIndex := RetIndex('DA4')
DbSetOrder(nIndex+1)
DbGoTop()

SetRegua(RecCount())

While DA4->(!Eof())
	Li := 80			//-- Uma ficha por pagina
	If Li > 58
		Cabec(titulo,'','',wnrel,Tamanho)
	EndIf
	IncRegua()
	//-- Verifica se o motorista esta em viagem
	If	! TMSEmViag(,,DA4->DA4_COD,2,.F.)
		DA4->(DbSkip())
		Loop
	EndIf

	DA3->(DbSetOrder(2))
	DA3->(MsSeek(cSeek:=xFilial('DA3') + DA4->DA4_COD))
	While DA3->(!Eof() .And. DA3->DA3_FILIAL + DA3->DA3_MOTORI == cSeek)
		//-- Verifica se o veiculo esta em viagem
		If	! TMSEmViag(,,DA3->DA3_COD,1,.F.)
			DA3->(DbSkip())
			Loop
		EndIf

		RTmsR07Vei(aPropri, aRetBox1, , @Li, .F.)
		
		DA3->(DbSkip())
	EndDo

	RTmsR07Pro( aPropri, @Li )

	RTmsR07Mot( aRetBox3, DA4->DA4_COD, @Li, .F. )

	DA4->(DbSkip())
EndDo

//-- Apaga o indice temporario do DA4
DbSelectArea('DA4')
RetIndex('DA4')
Ferase(cIndDA4 + OrdBagExt())

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTmsR07Vei³ Autor ³ Alex Egydio           ³ Data ³05.04.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime dados do veiculo na Ficha do Motorista             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Vetor contendo os proprietarios do veiculo         ³±±
±±³          ³ ExpA2 = Vetor contendo o status do veiculo                 ³±±
±±³          ³ ExpC1 = Codigo do veiculo                                  ³±±
±±³          ³ ExpN1 = Linha p/ impressao                                 ³±±
±±³          ³ ExpL1 = .T. Posiciona o arquivo de veiculos                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function RTmsR07Vei( aPropri, aRetBox1, cVeiculo, Li, lSeek )

Local aAreaAnt := GetArea()
Local aAreaDA3 := DA3->(GetArea())

DEFAULT cVeiculo := ''
DEFAULT lSeek := .T.

DA3->(DbSetOrder(1))
If	(lSeek .And. DA3->(MsSeek(xFilial('DA3') + cVeiculo))) .Or. DA3->(!Eof())
	If	AScan(aPropri,{|x| x[1] == DA3->DA3_CODFOR}) == 0
		AAdd(aPropri,{DA3->DA3_CODFOR, DA3->DA3_LOJFOR})
	EndIf

	@ Li,001 PSay Replicate("-",57) + STR0043 + Replicate("-",59) //"V E I C U L O S"
	Li++
	@ Li,001 PSay STR0012 //"|Veiculo  Placa              Fab/Mod     Modelo                 Chassi              Capac.Carga Cubagem  Bloq.                    |"
	Li++
	@ Li,001 PSay "|" + Space(41) + STR0044 + Space(80) + "|"
	Li ++
	@ Li,001 PSay "|" + DA3->DA3_COD
	@ Li,011 PSay DA3->DA3_PLACA
	@ Li,030 PSay DA3->DA3_ANOFAB + " " + DA3->DA3_ANOMOD
	@ Li,042 PSay Padr(DA3->DA3_DESC, 22)
	@ Li,065 PSay DA3->DA3_CHASSI
	@ Li,086 PSay Transform(DA3->DA3_CAPACM, "@R 999,999.99")
	@ Li,106 PSay AllTrim(aRetBox1[Ascan(aRetBox1, { |aBox| aBox[2] = AllTrim(DA3->DA3_ATIVO)})][3])
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay "|" + Space(9) + AllTrim(DA3->DA3_MUNPLA)
	@ Li,027 PSay DA3->DA3_ESTPLA
	@ Li,043 PSay Padr(Tabela("M6", DA3->DA3_MARVEI, .F.), 10) + "/" + Padr(Tabela("M7", DA3->DA3_CORVEI, .F.), 10)
	@ Li,131 PSay "|"
	Li ++

EndIf

RestArea(aAreaDA3)
RestArea(aAreaAnt)

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTmsR07Pro³ Autor ³ Alex Egydio           ³ Data ³05.04.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime dados do proprietario de veiculo na Ficha Motorista³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Vetor contendo os proprietarios do veiculo         ³±±
±±³          ³ ExpN1 = Linha p/ impressao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function RTmsR07Pro( aPropri, Li )

Local aAreaAnt := GetArea()
Local aAreaSA2 := SA2->(GetArea())
Local nCntFor	:= 0

//|Veiculo  Nome                           Endereco                                   CGC/CPF              Cidade          CEP      |
//|         Telefone                       Bairro                                     INSS                 UF              Filial   |
//|         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXX       XXXXXXXXXXXXXXX XXXXXXXX |
//|         (XXX) XXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX                                            XX
SA2->(DbSetOrder(1))
For nCntFor := 1 To Len(aPropri)
	If SA2->(MsSeek(xFilial('SA2') + aPropri[nCntFor,1] + aPropri[nCntFor,2]))
		@ Li,001 PSay Replicate("-",53) + STR0045 + Replicate("-",53)
		Li++
		@ Li,001 PSay STR0013 //"|Veiculo  Nome                           Endereco                                   CGC/CPF              Cidade          CEP      |"
		Li++
		@ Li,001 PSay STR0014 //"|         Telefone                       Bairro                                     INSS                 UF              Filial   |"
		Li++
		@ Li,001 PSay "|"
		@ Li,011 PSay Left(SA2->A2_NOME,30)
		@ Li,042 PSay AllTrim(SA2->A2_END)
		@ Li,085 PSay SA2->A2_CGC
		@ Li,106 PSay SA2->A2_MUN
		@ Li,122 PSay Transform(SA2->A2_CEP, PesqPict("SA2", "A2_CEP"))
		@ Li,131 PSay "|"
		Li++
		@ Li,001 PSay "|"
		@ Li,011 PSay SA2->A2_DDD + " " + Left(SA2->A2_TEL,24)
		@ Li,042 PSay SA2->A2_BAIRRO
		@ Li,106 PSay SA2->A2_EST
		@ Li,131 PSay "|"
		Li++
	EndIf
Next

RestArea(aAreaSA2)
RestArea(aAreaAnt)

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTmsR07Mot³ Autor ³ Alex Egydio           ³ Data ³05.04.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime dados do motorista na Ficha do Motorista           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Vetor contendo o status do motorista               ³±±
±±³          ³ ExpC1 = Codigo do motorista                                ³±±
±±³          ³ ExpN1 = Linha p/ impressao                                 ³±±
±±³          ³ ExpL1 = .T. Posiciona o arquivo de veiculos                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function RTmsR07Mot( aRetBox3, cMotorista, Li, lSeek )

Local aAreaAnt := GetArea()
Local aAreaDA4 := DA4->(GetArea())

DEFAULT cMotorista := ''
DEFAULT lSeek := .T.

If lSeek
	DA4->(DbSetOrder(1))
EndIf

If (lSeek .And. DA4->(MsSeek(xFilial('DA4') + cMotorista))) .Or. DA4->(!Eof())
	@ Li,001 PSay Replicate("-",56) + STR0046 + Replicate("-",58) //"M O T O R I S T A"
	Li++
	@ Li,001 PSay STR0015 +  DA4->DA4_NOME  //"|Motorista...: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0017 + DA4->DA4_NREDUZ + Space(42) + STR0018 +  TransForm(DA4->DA4_DATNAS, PesqPict("DA4","DA4_DATNAS") ) //"|Apelido.....: "###"Data Nascto.: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0019 + DA4->DA4_END + Space(17) + STR0047 + ".........: "  + TransForm(DA4->DA4_CEP,PesqPict("DA4","DA4_CEP") ) //"|Endereco....: "###"CEP"
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0020 + DA4->DA4_MUN + Space(42) + STR0021 + DA4->DA4_BAIRRO //"|Cidade......: "###"Bairro......: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0022 + DA4->DA4_EST + Space(17) +  STR0023 + DA4->DA4_TEL + Space(12)+ STR0024 + DA4->DA4_TELREC //"|Estado......: "###"Telefone : "###"Recados.....: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0025 +  DA4->DA4_FALCOM  + Space(42) + STR0048 + ".........: " + TransForm(DA4->DA4_CGC, PesqPict("DA4","DA4_CGC")) //"|Falar Com...: "###"CPF"
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0026 + DA4->DA4_NUMSEG  + Space(47) + STR0027 + Padr(Tabela("33", DA4->DA4_ESTCIV,.F.), 30) //"|No.Seguro...: "###"Est.Civil...: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0028 + DA4->DA4_PAI + Space(17) + STR0029 + TransForm(DA4->DA4_ALTURA, PesqPict("DA4","DA4_ALTURA") ) //"|Pai.........: "###"Altura.....:  "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0030 + DA4->DA4_MAE + Space(17) + STR0031 + TransForm(DA4->DA4_PESO, PesqPict("DA4","DA4_PESO") ) //"|Mae.........: "###"Peso.......: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0032 + DA4->DA4_SINAIS + Space(27) + STR0049 + ".......: " +  DA4->DA4_RG+" "+DA4->DA4_RGORG+" "+DA4->DA4_RGEST //"|Sinais......: "###"RG"
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0033 + Padr(Tabela("M7", DA4->DA4_CORPEL, .F.), 30) //"|Cor Pele....: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0034 + Padr(Tabela("M7", DA4->DA4_CORBAR, .F.), 30) //"|Cor Barba...: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0035 + Padr(Tabela("M7", DA4->DA4_CORCAB, .F.), 30) + Space(27) + STR0036 + AllTrim(aRetBox3[Ascan(aRetBox3, { |aBox| aBox[2] = DA4->DA4_BLQMOT})][3]) //"|Cor Cabelo..: "###"Bloqueado..: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0037 + Padr(Tabela("M7", DA4->DA4_COROLH, .F.), 30) + Space(27) + STR0038 + TransForm(DA4->DA4_DTVCNH, PesqPict("DA4","DA4_DTVCNH") ) //"|Cor Olhos...: "###"Venc CNH...: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay "|" + STR0050 + ".........: " +  Left(DA4->DA4_NUMCNH + Space(20),20) + Space(37) + STR0039 + DTOC(DA4->DA4_DTECNH) + " " + DA4->DA4_MUNCNH + " " + DA4->DA4_ESTCNH //"CNH"###"Exped.CNH: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay STR0040 + DA4->DA4_REGCNH //"|No.Reg.CNH..: "
	@ Li,131 PSay "|"
	Li++
	@ Li,001 PSay Replicate("-",131)
	Li++
EndIf

RestArea(aAreaDA4)
RestArea(aAreaAnt)

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTmsR07SX1³ Autor ³ Alex Egydio           ³ Data ³05.04.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inclui pergunta no SX1 para a Ficha do Motorista           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function RTmsR07SX1()

Local	aHelpPor := {}
Local	aHelpSpa := {}
Local	aHelpEng := {}

Aadd(aHelpPor,'Informe o Código do Motorista Inicial  ')
Aadd(aHelpSpa,'Informe el Código del Conductor Inicial')
Aadd(aHelpEng,'Enter the Initial Driver Code          ')

PutSx1('RTMR7A','01','Motorista De ?'	,'¿De Conductor?'	,'From Driver?','mv_ch1','C',6,0,0,'G','','DA4','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd(aHelpPor,'Informe o Código do Motorista Final   ')
Aadd(aHelpSpa,'Informe el Código del Conductor Final ')
Aadd(aHelpEng,'Enter the Final Driver Code			  ')

PutSx1('RTMR7A','02','Motorista Até ?'	,'¿A Conductor?'	,'To Driver?','mv_ch2','C',6,0,0,'G','','DA4','','','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,aHelpEng,aHelpSpa)

Return NIL