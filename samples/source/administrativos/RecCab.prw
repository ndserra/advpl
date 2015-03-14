#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Array     ³aProcedure³ Autor ³ Bruno Sobieski        ³ Data ³ 12.27.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri?.o   ³ Efetuar o processamento de toda a tabela SEL                   ³±±
±±³          ³ Validar se o recibo possui cabeçalho associado,Se não      ³±±
±±³          ³ houver, gerar o cabeçalho de acordo com a seguinte regra   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Criação do cabeçalho para recibos antigos                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RecCab()

Local nTB	:=	0
Local nTR	:=	0
Local nTRa	:=	0
Local nRet	:=	0     
Local lRet:=.F.
Local aCposSEL:= {}
Local nX:=0
Local cSN:= ''
Local cVersao:= ''
Local aArea:={}
DbSelectArea('SEL')
DbSetorder(8)
DbGoTop()

// Lendo o recibo
Do while !EOF()

	aadd(aCposSEL,{;
	EL_FILIAL,;
	EL_DTDIGIT,; 
 	EL_SERIE,;
  	EL_RECIBO,;
   	EL_VERSAO,;
   	EL_EMISSAO,;
   	EL_NATUREZ,;
   	EL_CLIORIG,;
   	EL_LOJORIG,;
   	SA1->A1_NOME,;
   	IIf(EL_CANCEL==.T.,'1',''),;
   	EL_COBRAD,;
   	EL_RECPROV,;
   	EL_VALOR,;
   	EL_TIPO,;
 	})
 	aArea:=GetArea()
 	   cVersao:= SEL->(F841VERSA(EL_RECIBO,EL_SERIE)) // Encontra a ultima versao do recibo.
 	RestArea(aArea)
 	cSN:=IIf(EL_VERSAO # cVersao,'0','1')   // Verifica se eh a ultima versao do recibo.
	// Zera acumuladores para próximo Recibo.
	nTB	:=	0
	nTR	:=	0
	nTRa	:=	0
	nRet	:=	0
	nDecs := MsDecimais(1)
 	nX:= len(aCposSEL)
	// Lendo o mesmo recibo para acumular os valores.
 	Do While !EOF() .AND. aCposSEL[nX,1]==EL_FILIAL .And. EL_RECIBO==aCposSEL[nX,4] .And. EL_SERIE == aCposSEL[nX,3] .And. EL_VERSAO == aCposSEL[nX,5]
		If Subs(EL_TIPODOC,1,2)=="TB"
			nTB	+= EL_VLMOED1
		ElseIf   Subs(EL_TIPODOC,1,2)$"RI|RG|RB|RS"
			nTR	+= EL_VLMOED1
		ElseIf Subs(EL_TIPODOC,1,2)=="RA"
			nTRa+=	EL_VLMOED1
		Endif
		DbSkip()
	Enddo
	// Procura para ver se já existe este cabeçalho, senão Grava.
	DbSelectArea('FJT')
	DbSetorder(1)
	DbGoTop()
	If !FJT->(DbSeek(aCposSEL[nX,1]+aCposSEL[nX,3]+aCposSEL[nX,4]+aCposSEL[nX,5]))
		// Grava no Cabeçalho Alias (FJT)
		Reclock("FJT",.T.)
    	FJT_FILIAL  := aCposSEL[nX,1]
      	FJT_DTDIGI  := aCposSEL[nX,2]
      	FJT_SERIE   := aCposSEL[nX,3]
      	FJT_RECIBO  := aCposSEL[nX,4]
      	FJT_VERSAO  := aCposSEL[nX,5]
      	FJT_EMISSA  := aCposSEL[nX,6]
      	FJT_NATURE  := aCposSEL[nX,7]
      	FJT_CLIENT  := aCposSEL[nX,8]
      	FJT_LOJA    := aCposSEL[nX,9]
      	FJT_NOME    := aCposSEL[nX,10]
      	FJT_CANCEL  := aCposSEL[nX,11]	      	
      	FJT_COBRAD  := aCposSEL[nX,12]
      	FJT_RECPRV  := aCposSEL[nX,13]
      	FJT_VALDOC  := nTB    //'Soma de todos os tipos NF, NCC, DUP etc.'
      	FJT_VALBX   := nTB    //'Soma do tipo TB'
      	FJT_VALRA   := nTRa   //'Soma do Tipo RA'
      	FJT_VLRRET  := nTR    //'Soma dos tipos RG, RB, RI, RS'
      	FJT_VERATU  := cSN    // 'Última versão - 0=Não;1=Sim'
      	MsUnlock()
     	lRet:= .T.
  	Endif
    DbSelectArea('SEL')
Enddo

If lRet
   MsgInfo ( "Ejecución finalizó con éxito ! ")
Else
   MsgInfo ( "Error de ejecución ! ")             
Endif
Return  lRet
 
 
 

 

