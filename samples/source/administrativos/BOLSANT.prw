#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa  ³ BOLSANT.PRW ³ Autor ³ Flavio Novaes    ³ Data ³ 03/02/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Impressao de Boleto Bancario do Banco Santander com Codigo ³±±
±±³           ³ de Barras, Linha Digitavel e Nosso Numero.                 ³±±
±±³           ³ Baseado no Fonte TBOL001 de 01/08/2002 de Raimundo Pereira.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FINANCEIRO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION BOLITAU()
LOCAL aCampos      := {{"E1_NOMCLI","Cliente","@!"},{"E1_PREFIXO","Prefixo","@!"},{"E1_NUM","Titulo","@!"},;
							 {"E1_PARCELA","Parcela","@!"},{"E1_VALOR","Valor","@E 9,999,999.99"},{"E1_VENCTO","Vencimento"}}
LOCAL nOpc         := 0
LOCAL aMarked      := {}
LOCAL aDesc        := {"Este programa imprime os boletos de","cobranca bancaria de acordo com","os parametros informados"}
PRIVATE Exec       := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
Tamanho  := "M"
titulo   := "Impressao de Boleto Santander
cDesc1   := "Este programa destina-se a impressao do Boleto Santander."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLITA"
lEnd     := .F.
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0
dbSelectArea("SE1")
cPerg    := "TBOL01"
PERGUNTE(cPerg,.F.)
wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)
IF nLastKey == 27
	Set Filter to
	Return
ENDIF
SETDEFAULT(aReturn,cString)
IF nLastKey == 27
	Set Filter to
	Return
ENDIF
nOpc := 1
IF nOpc == 1
	cIndexName := Criatrab(Nil,.F.)
	cIndexKey  := 	"E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
	cFilter    := 	"E1_PREFIXO >= '" + MV_PAR01 + "' .And. E1_PREFIXO <= '" + MV_PAR02 + "' .And. " + ;
						"E1_NUM     >= '" + MV_PAR03 + "' .And. E1_NUM     <= '" + MV_PAR04 + "' .And. " + ;
						"E1_PARCELA >= '" + MV_PAR05 + "' .And. E1_PARCELA <= '" + MV_PAR06 + "' .And. " + ;
						"E1_PORTADO >= '" + MV_PAR07 + "' .And. E1_PORTADO <= '" + MV_PAR08 + "' .And. " + ;
						"E1_CLIENTE >= '" + MV_PAR09 + "' .And. E1_CLIENTE <= '" + MV_PAR10 + "' .And. " + ;
						"E1_EMISSAO >= CTOD('" + DTOC(MV_PAR15) + "') .And. E1_EMISSAO <= CTOD('" + DTOC(MV_PAR16) + "') .And. " + ;
						"E1_VENCTO  >= CTOD('" + DTOC(MV_PAR13) + "') .And. E1_VENCTO <= CTOD('" + DTOC(MV_PAR14) + "') .And. "+ ;
						"E1_LOJA    >= '"+MV_PAR11+"' .And. E1_LOJA <= '"+MV_PAR12+"' .And. "+;
						"E1_FILIAL   = '"+xFilial()+"' .And. E1_SALDO > 0 .And. " + ;
						"SubsTring(E1_TIPO,3,1) != '-' .And. "+;
						"E1_PORTADO != '   '"
	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	dbSelectArea("SE1")
	#IFNDEF TOP
		dbSetIndex(cIndexName + OrdBagExt())
	#ENDIF
	dbGoTop()
	IF mv_par17 = 1
		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"
		@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
		@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
		@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
		ACTIVATE DIALOG oDlg CENTERED
	ENDIF
	dbGoTop()
	WHILE !EOF()
		IF MARKED("E1_OK")
			AADD(aMarked,.T.)
		ELSE
			AADD(aMarked,.F.)
		ENDIF
		dbSkip()
	ENDDO
	dbGoTop()
	IF Exec
		PROCESSA({|lEnd|MontaRel(aMarked)})
	ENDIF
	RETINDEX("SE1")
	fErase(cIndexName+OrdBagExt())
ENDIF
RETURN Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ MONTAREL()  ³ Autor ³ Flavio Novaes    ³ Data ³ 03/02/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Impressao de Boleto Bancario do Banco Santander com Codigo ³±±
±±³           ³ de Barras, Linha Digitavel e Nosso Numero.                 ³±±
±±³           ³ Baseado no Fonte TBOL001 de 01/08/2002 de Raimundo Pereira.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FINANCEIRO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION MontaRel(aMarked)
LOCAL oPrint
LOCAL n         := 0
LOCAL aBitmap   := {MV_PAR19,;		// Banner Publicitario
						  "LGRL.bmp"}		// Logo da Empresa
LOCAL aDadosEmp := {SM0->M0_NOMECOM,;																					//[1]Nome da Empresa
						  SM0->M0_ENDCOB,; 																					//[2]Endereço
						  AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						  "CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3),; 					//[4]CEP
						  "PABX/FAX: "+SM0->M0_TEL,; 																		//[5]Telefones
						  "C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+;				//[6]
						  Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+;								//[6]
						  Subs(SM0->M0_CGC,13,2),;																		//[6]CGC
						  "I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+;					//[7]
						  Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)}									//[7]I.E
LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText  := {"Após o vencimento cobrar multa de R$ ",;
						  "Mora Diaria de R$ ",;
						  "Sujeito a Protesto apos 05 (cinco) dias do vencimento"}
LOCAL aBMP      := aBitMap
LOCAL i         := 1
LOCAL CB_RN_NN  := {}
LOCAL nRec      := 0
LOCAL _nVlrAbat := 0
oPrint  := TMSPrinter():New("Boleto Laser")
lImpBol := oPrint:Setup()		// Se retorna .T. imprime direto na impressora
IF !(lImpBol)
	RETURN
ENDIF
oPrint:SetPortrait()				// ou SetLandscape()
oPrint:SetPaperSize(9)			// Seta para papel A4
oPrint:StartPage()				// Inicia uma nova pagina
dbGoTop()
WHILE !EOF()
	nRec := nRec + 1
	dbSkip()
ENDDO
dbGoTop()
ProcRegua(nRec)
WHILE !EOF()
	// Posiciona o SA6 (Bancos)
	dbSelectArea("SA6")
	dbSetOrder(1)
	dbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)
	// Posiciona na Arq de Parametros CNAB
	dbSelectArea("SEE")
	dbSetOrder(1)
	dbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	// Posiciona o SA1 (Cliente)
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	// Seleciona o SE1 (Contas a Receber)
	dbSelectArea("SE1")
	aDadosBanco := {"353",;																		//SA6->A6_COD [1]Numero do Banco
						 "SANTANDER",;																// [2]Nome do Banco
						 SUBSTR(SA6->A6_AGENCIA,1,4),;										// [3]Agencia
						 SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),;	// [4]Conta Corrente
						 SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1),;	// [5]Digito da conta corrente
						 " "}																			// [6]Codigo da Carteira
	IF EMPTY(SA1->A1_ENDCOB)
		aDatSacado := {AllTrim(SA1->A1_NOME),;											// [1]Razao Social
							AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA,;						// [2]Codigo
							AllTrim(SA1->A1_END)+"-"+AllTrim(SA1->A1_BAIRRO),;		// [3]Endereco
							AllTrim(SA1->A1_MUN),;												// [4]Cidade
							SA1->A1_EST,;															// [5]Estado
							SA1->A1_CEP,;															// [6]CEP
							SA1->A1_CGC}															// [7]CGC
	ELSE
		aDatSacado := {AllTrim(SA1->A1_NOME),;											// [1]Razao Social
							AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA,;						// [2]Codigo
							AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;	// [3]Endereco
							AllTrim(SA1->A1_MUNC),;												// [4]Cidade
							SA1->A1_ESTC,;															// [5]Estado
							SA1->A1_CEPC,;															// [6]CEP
							SA1->A1_CGC}															// [7]CGC
	ENDIF
	_nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	CB_RN_NN  := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat),E1_VENCTO)
	aDadosTit := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA),;	// [1] Numero do Titulo
					  E1_EMISSAO,;										// [2] Data da Emissao do Titulo
					  Date(),;											// [3] Data da Emissao do Boleto
					  E1_VENCTO,;										// [4] Data do Vencimento
					  (E1_SALDO - _nVlrAbat),;						// [5] Valor do Titulo
					  CB_RN_NN[3],;									// [6] Nosso Numero (Ver Formula para Calculo)
					  E1_PREFIXO,;										// [7] Prefixo da NF
					  E1_TIPO}											// [8] Tipo do Titulo
	IF MV_PAR18 == 1
		aBMP[1] := "\Bitmaps\Banner"+str(n,1,0)+".bmp"
	ENDIF
	IF aMarked[i]
		Impress(oPrint,aBMP,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
		n := n + 1
	ENDIF
	dbSkip()
	INCPROC()
	i := i + 1
ENDDO
oPrint:EndPage()	// Finaliza a Pagina.
oPrint:Preview()	// Visualiza antes de Imprimir.
RETURN nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ IMPRESS()   ³ Autor ³ Flavio Novaes    ³ Data ³ 03/02/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Impressao de Boleto Bancario do Banco Santander com Codigo ³±±
±±³           ³ de Barras, Linha Digitavel e Nosso Numero.                 ³±±
±±³           ³ Baseado no Fonte TBOL001 de 01/08/2002 de Raimundo Pereira.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FINANCEIRO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
LOCAL oFont8
LOCAL oFont10
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL i        := 0
LOCAL _nLin    := 200
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {_nLin+0710,1900,_nLin+0810,2300}
LOCAL aCoords4 := {_nLin+0980,1900,_nLin+1050,2300}
LOCAL aCoords5 := {_nLin+1330,1900,_nLin+1400,2300}
LOCAL aCoords6 := {_nLin+2000,1900,_nLin+2100,2300}
LOCAL aCoords7 := {_nLin+2270,1900,_nLin+2340,2300}
LOCAL aCoords8 := {_nLin+2620,1900,_nLin+2690,2300}
LOCAL oBrush
// Parâmetros de TFont.New()
// 1.Nome da Fonte (Windows)
// 3.Tamanho em Pixels
// 5.Bold (T/F)
oFont8  := TFont():New("Arial",9,08,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
oBrush  := TBrush():New("",4)
oPrint:StartPage()	// Inicia uma nova Pagina
// "Pinta" os Campos com Cinza.
oPrint:FillRect(aCoords1,oBrush)
oPrint:FillRect(aCoords2,oBrush)
oPrint:FillRect(aCoords3,oBrush)
oPrint:FillRect(aCoords4,oBrush)
oPrint:FillRect(aCoords5,oBrush)
oPrint:FillRect(aCoords6,oBrush)
oPrint:FillRect(aCoords7,oBrush)
oPrint:FillRect(aCoords8,oBrush)
// Inicia aqui a alteracao para novo layout - RAI
oPrint:Line(0150,0560,0050,0560)
oPrint:Line(0150,0800,0050,0800)
oPrint:Say (0084,0100,aDadosBanco[2],oFont16)					// [2] Nome do Banco
oPrint:Say (0062,0567,aDadosBanco[1],oFont24)					// [1] Numero do Banco
oPrint:Say (0084,1870,"Comprovante de Entrega",oFont10)
oPrint:Line(0150,0100,0150,2300)
oPrint:Say (0150,0100,"Cedente",oFont8)
oPrint:Say (0200,0100,aDadosEmp[1]	,oFont10)					// [1] Nome + CNPJ
oPrint:Say (0150,1060,"Agência/Código Cedente",oFont8)
oPrint:Say (0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
oPrint:Say (0150,1510,"Nro.Documento",oFont8)
oPrint:Say (0200,1510,aDadosTit[7]+aDadosTit[1],oFont10)	// [7] Prefixo + [1] Numero + Parcela
oPrint:Say (0250,0100,"Sacado",oFont8)
oPrint:Say (0300,0100,aDatSacado[1],oFont10)					// [1] Nome
oPrint:Say (0250,1060,"Vencimento",oFont8)
oPrint:Say (0300,1060,DTOC(aDadosTit[4]),oFont10)
oPrint:Say (0250,1510,"Valor do Documento",oFont8)
oPrint:Say (0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
oPrint:Say (0400,0100,"Recebi(emos) o bloqueto/título",oFont10)
oPrint:Say (0450,0100,"com as características acima.",oFont10)
oPrint:Say (0350,1060,"Data",oFont8)
oPrint:Say (0350,1410,"Assinatura",oFont8)
oPrint:Say (0450,1060,"Data",oFont8)
oPrint:Say (0450,1410,"Entregador",oFont8)
oPrint:Line(0250,0100,0250,1900)
oPrint:Line(0350,0100,0350,1900)
oPrint:Line(0450,1050,0450,1900) //---
oPrint:Line(0550,0100,0550,2300)
oPrint:Line(0550,1050,0150,1050)
oPrint:Line(0550,1400,0350,1400)
oPrint:Line(0350,1500,0150,1500) //--
oPrint:Line(0550,1900,0150,1900)
oPrint:Say (0150,1910,"(  )Mudou-se",oFont8)
oPrint:Say (0190,1910,"(  )Ausente",oFont8)
oPrint:Say (0230,1910,"(  )Não existe nº indicado",oFont8)
oPrint:Say (0270,1910,"(  )Recusado",oFont8)
oPrint:Say (0310,1910,"(  )Não procurado",oFont8)
oPrint:Say (0350,1910,"(  )Endereço insuficiente",oFont8)
oPrint:Say (0390,1910,"(  )Desconhecido",oFont8)
oPrint:Say (0430,1910,"(  )Falecido",oFont8)
oPrint:Say (0470,1910,"(  )Outros(anotar no verso)",oFont8)
FOR i := 100 TO 2300 STEP 50
	oPrint:Line(_nLin+0600,i,_nLin+0600,i+30)
NEXT i
oPrint:Line(_nLin+0710,0100,_nLin+0710,2300)
oPrint:Line(_nLin+0710,0560,_nLin+0610,0560)
oPrint:Line(_nLin+0710,0800,_nLin+0610,0800)
oPrint:Say (_nLin+0644,0100,aDadosBanco[2],oFont16)	// [2]Nome do Banco
oPrint:Say (_nLin+0622,0567,aDadosBanco[1],oFont24)	// [1]Numero do Banco
oPrint:Say (_nLin+0644,1900,"Recibo do Sacado",oFont10)
oPrint:Line(_nLin+0810,0100,_nLin+0810,2300)
oPrint:Line(_nLin+0910,0100,_nLin+0910,2300)
oPrint:Line(_nLin+0980,0100,_nLin+0980,2300)
oPrint:Line(_nLin+1050,0100,_nLin+1050,2300)
oPrint:Line(_nLin+0910,0500,_nLin+1050,0500)
oPrint:Line(_nLin+0980,0750,_nLin+1050,0750)
oPrint:Line(_nLin+0910,1000,_nLin+1050,1000)
oPrint:Line(_nLin+0910,1350,_nLin+0980,1350)
oPrint:Line(_nLin+0910,1550,_nLin+1050,1550)
oPrint:Say (_nLin+0710,0100,"Local de Pagamento",oFont8)
oPrint:Say (_nLin+0750,0100,"QUALQUER BANCO ATÉ A DATA DO VENCIMENTO",oFont10)
oPrint:Say (_nLin+0710,1910,"Vencimento",oFont8)
oPrint:Say (_nLin+0750,1950,DTOC(aDadosTit[4]),oFont10)
oPrint:Say (_nLin+0810,0100,"Cedente",oFont8)
oPrint:Say (_nLin+0850,0100,aDadosEmp[1]+"                  - "+aDadosEmp[6],oFont10) //Nome + CNPJ
oPrint:Say (_nLin+0810,1910,"Agência/Código Cedente",oFont8)
oPrint:Say (_nLin+0850,1950,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
oPrint:Say (_nLin+0910,0100,"Data do Documento",oFont8)
oPrint:Say (_nLin+0940,0100,DTOC(aDadosTit[2]),oFont10) // Emissao do Titulo (E1_EMISSAO)
oPrint:Say (_nLin+0910,0505,"Nro.Documento",oFont8)
oPrint:Say (_nLin+0940,0605,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela
oPrint:Say (_nLin+0910,1005,"Espécie Doc.",oFont8)
oPrint:Say (_nLin+0940,1050,aDadosTit[8],oFont10) //Tipo do Titulo
oPrint:Say (_nLin+0910,1355,"Aceite",oFont8)
oPrint:Say (_nLin+0940,1455,"N",oFont10)
oPrint:Say (_nLin+0910,1555,"Data do Processamento",oFont8)
oPrint:Say (_nLin+0940,1655,DTOC(aDadosTit[3]),oFont10) // Data impressao
oPrint:Say (_nLin+0910,1910,"Nosso Número",oFont8)
oPrint:Say (_nLin+0940,1950,SUBSTR(aDadosTit[6],1,3)+"/"+SUBSTR(aDadosTit[6],4),oFont10)
oPrint:Say (_nLin+0980,0100,"Uso do Banco",oFont8)
oPrint:Say (_nLin+0980,0505,"Carteira",oFont8)
oPrint:Say (_nLin+1010,0555,aDadosBanco[6],oFont10)
oPrint:Say (_nLin+0980,0755,"Espécie",oFont8)
oPrint:Say (_nLin+1010,0805,"R$",oFont10)
oPrint:Say (_nLin+0980,1005,"Quantidade",oFont8)
oPrint:Say (_nLin+0980,1555,"Valor",oFont8)
oPrint:Say (_nLin+0980,1910,"Valor do Documento",oFont8)
oPrint:Say (_nLin+1010,1950,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
oPrint:Say (_nLin+1050,0100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say (_nLin+1150,0100,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99")),oFont10)
oPrint:Say (_nLin+1200,0100,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.05)/30),"@E 99,999.99")),oFont10)
oPrint:Say (_nLin+1250,0100,aBolText[3],oFont10)
oPrint:Say (_nLin+1050,1910,"(-)Desconto/Abatimento",oFont8)
oPrint:Say (_nLin+1120,1910,"(-)Outras Deduções",oFont8)
oPrint:Say (_nLin+1190,1910,"(+)Mora/Multa",oFont8)
oPrint:Say (_nLin+1260,1910,"(+)Outros Acréscimos",oFont8)
oPrint:Say (_nLin+1330,1910,"(=)Valor Cobrado",oFont8)
oPrint:Say (_nLin+1400,0100,"Sacado",oFont8)
oPrint:Say (_nLin+1430,0400,aDatSacado[1]+" ("+aDatSacado[2]+")",oFont10)
oPrint:Say (_nLin+1483,0400,aDatSacado[3],oFont10)
oPrint:Say (_nLin+1536,0400,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say (_nLin+1589,0400,"CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
oPrint:Say (_nLin+1589,1950,SUBSTR(aDadosTit[6],1,3)+"/00"+SUBSTR(aDadosTit[6],4,8),oFont10)
oPrint:Say (_nLin+1605,0100,"Sacador/Avalista",oFont8)
oPrint:Say (_nLin+1645,1500,"Autenticação Mecânica -",oFont8)
oPrint:Line(_nLin+0710,1900,_nLin+1400,1900)
oPrint:Line(_nLin+1120,1900,_nLin+1120,2300)
oPrint:Line(_nLin+1190,1900,_nLin+1190,2300)
oPrint:Line(_nLin+1260,1900,_nLin+1260,2300)
oPrint:Line(_nLin+1330,1900,_nLin+1330,2300)
oPrint:Line(_nLin+1400,0100,_nLin+1400,2300)
oPrint:Line(_nLin+1640,0100,_nLin+1640,2300)
FOR i := 100 TO 2300 STEP 50
	oPrint:Line(_nLin+1890,i,_nLin+1890,i+30)
NEXT i
// Encerra aqui a alteracao para o novo layout - RAI
oPrint:Line(_nLin+2000,0100,_nLin+2000,2300)
oPrint:Line(_nLin+2000,0560,_nLin+1900,0560)
oPrint:Line(_nLin+2000,0800,_nLin+1900,0800)
oPrint:Say (_nLin+1934,0100,aDadosBanco[2],oFont16)	// [2] Nome do Banco
oPrint:Say (_nLin+1912,0567,aDadosBanco[1],oFont24)	// [1] Numero do Banco
oPrint:Say (_nLin+1934,0820,CB_RN_NN[2],oFont14n)		// [2] Linha Digitavel do Codigo de Barras
oPrint:Line(_nLin+2100,0100,_nLin+2100,2300)
oPrint:Line(_nLin+2200,0100,_nLin+2200,2300)
oPrint:Line(_nLin+2270,0100,_nLin+2270,2300)
oPrint:Line(_nLin+2340,0100,_nLin+2340,2300)
oPrint:Line(_nLin+2200,0500,_nLin+2340,0500)
oPrint:Line(_nLin+2270,0750,_nLin+2340,0750)
oPrint:Line(_nLin+2200,1000,_nLin+2340,1000)
oPrint:Line(_nLin+2200,1350,_nLin+2270,1350)
oPrint:Line(_nLin+2200,1550,_nLin+2340,1550)
oPrint:Say (_nLin+2000,0100,"Local de Pagamento",oFont8)
oPrint:Say (_nLin+2040,0100,"QUALQUER BANCO ATÉ A DATA DO VENCIMENTO",oFont10)
oPrint:Say (_nLin+2000,1910,"Vencimento",oFont8)
oPrint:Say (_nLin+2040,1950,DTOC(aDadosTit[4]),oFont10)
oPrint:Say (_nLin+2100,0100,"Cedente",oFont8)
oPrint:Say (_nLin+2140,0100,aDadosEmp[1]+"                  - "+aDadosEmp[6],oFont10) //Nome + CNPJ
oPrint:Say (_nLin+2100,1910,"Agência/Código Cedente",oFont8)
oPrint:Say (_nLin+2140,1950,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
oPrint:Say (_nLin+2200,0100,"Data do Documento",oFont8)
oPrint:Say (_nLin+2230,0100,DTOC(aDadosTit[2]),oFont10)			// Emissao do Titulo (E1_EMISSAO)
oPrint:Say (_nLin+2200,0505,"Nro.Documento",oFont8)
oPrint:Say (_nLin+2230,0605,aDadosTit[7]+aDadosTit[1],oFont10)	//Prefixo + Numero + Parcela
oPrint:Say (_nLin+2200,1005,"Espécie Doc.",oFont8)
oPrint:Say (_nLin+2230,1050,aDadosTit[8],oFont10)					//Tipo do Titulo
oPrint:Say (_nLin+2200,1355,"Aceite",oFont8)
oPrint:Say (_nLin+2230,1455,"N",oFont10)
oPrint:Say (_nLin+2200,1555,"Data do Processamento",oFont8)
oPrint:Say (_nLin+2230,1655,DTOC(aDadosTit[3]),oFont10) // Data impressao
oPrint:Say (_nLin+2200,1910,"Nosso Número",oFont8)
oPrint:Say (_nLin+2230,1950,SUBSTR(aDadosTit[6],1,3)+"/"+SUBSTR(aDadosTit[6],4),oFont10)
oPrint:Say (_nLin+2270,0100,"Uso do Banco",oFont8)
oPrint:Say (_nLin+2270,0505,"Carteira",oFont8)
oPrint:Say (_nLin+2300,0555,aDadosBanco[6],oFont10)
oPrint:Say (_nLin+2270,0755,"Espécie",oFont8)
oPrint:Say (_nLin+2300,0805,"R$",oFont10)
oPrint:Say (_nLin+2270,1005,"Quantidade",oFont8)
oPrint:Say (_nLin+2270,1555,"Valor",oFont8)
oPrint:Say (_nLin+2270,1910,"Valor do Documento",oFont8)
oPrint:Say (_nLin+2300,1950,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
oPrint:Say (_nLin+2340,0100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say (_nLin+2440,0100,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99")),oFont10)
oPrint:Say (_nLin+2490,0100,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.05)/30),"@E 99,999.99")),oFont10)
oPrint:Say (_nLin+2540,0100,aBolText[3],oFont10)
oPrint:Say (_nLin+2340,1910,"(-)Desconto/Abatimento",oFont8)
oPrint:Say (_nLin+2410,1910,"(-)Outras Deduções",oFont8)
oPrint:Say (_nLin+2480,1910,"(+)Mora/Multa",oFont8)
oPrint:Say (_nLin+2550,1910,"(+)Outros Acréscimos",oFont8)
oPrint:Say (_nLin+2620,1910,"(=)Valor Cobrado",oFont8)
oPrint:Say (_nLin+2690,0100,"Sacado",oFont8)
oPrint:Say (_nLin+2720,0400,aDatSacado[1]+" ("+aDatSacado[2]+")",oFont10)
oPrint:Say (_nLin+2773,0400,aDatSacado[3],oFont10)
oPrint:Say (_nLin+2826,0400,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10)	// CEP+Cidade+Estado
oPrint:Say (_nLin+2879,0400,"CGC: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10)	// CGC
oPrint:Say (_nLin+2879,1950,SUBSTR(aDadosTit[6],1,3)+"/00"+SUBSTR(aDadosTit[6],4,8),oFont10)
oPrint:Say (_nLin+2895,0100,"Sacador/Avalista",oFont8)
oPrint:Say (_nLin+2935,1500,"Autenticação Mecânica -",oFont8)
oPrint:Say (_nLin+2935,1850,"Ficha de Compensação",oFont10)
oPrint:Line(_nLin+2000,1900,_nLin+2690,1900)
oPrint:Line(_nLin+2410,1900,_nLin+2410,2300)
oPrint:Line(_nLin+2480,1900,_nLin+2480,2300)
oPrint:Line(_nLin+2550,1900,_nLin+2550,2300)
oPrint:Line(_nLin+2620,1900,_nLin+2620,2300)
oPrint:Line(_nLin+2690,0100,_nLin+2690,2300)
oPrint:Line(_nLin+2930,0100,_nLin+2930,2300)
MSBAR("INT25",14,0.8,CB_RN_NN[1],oPrint,.F.,,.T.,0.013,0.7,,,"A",.F.)
oPrint:EndPage()	// Finaliza a Pagina
RETURN Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ MODULO10()  ³ Autor ³ Flavio Novaes    ³ Data ³ 03/02/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Impressao de Boleto Bancario do Banco Santander com Codigo ³±±
±±³           ³ de Barras, Linha Digitavel e Nosso Numero.                 ³±±
±±³           ³ Baseado no Fonte TBOL001 de 01/08/2002 de Raimundo Pereira.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FINANCEIRO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
WHILE L > 0
	P := VAL(SUBSTR(cData, L, 1))
	IF (B)
		P := P * 2
		IF P > 9
			P := P - 9
		ENDIF
	ENDIF
	D := D + P
	L := L - 1
	B := !B
ENDDO
D := 10 - (Mod(D,10))
IF D = 10
	D := 0
ENDIF
RETURN(D)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ MODULO11()  ³ Autor ³ Flavio Novaes    ³ Data ³ 03/02/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Impressao de Boleto Bancario do Banco Santander com Codigo ³±±
±±³           ³ de Barras, Linha Digitavel e Nosso Numero.                 ³±±
±±³           ³ Baseado no Fonte TBOL001 de 01/08/2002 de Raimundo Pereira.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FINANCEIRO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION Modulo11(cData)
LOCAL L, D, P := 0
L := LEN(cdata)
D := 0
P := 1
WHILE L > 0
	P := P + 1
	D := D + (VAL(SUBSTR(cData, L, 1)) * P)
	IF P = 9
		P := 1
	ENDIF
	L := L - 1
ENDDO
D := 11 - (mod(D,11))
IF (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
ENDIF
RETURN(D)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ RET_CBARRA()³ Autor ³ Flavio Novaes    ³ Data ³ 03/02/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Impressao de Boleto Bancario do Banco Santander com Codigo ³±±
±±³           ³ de Barras, Linha Digitavel e Nosso Numero.                 ³±±
±±³           ³ Baseado no Fonte TBOL001 de 01/08/2002 de Raimundo Pereira.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FINANCEIRO                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION RET_CBARRA(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
LOCAL bldocnufinal := STRZERO(VAL(cNroDoc),8)
LOCAL blvalorfinal := STRZERO(int(nValor*100),10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := STRZERO(dVencto - ctod("07/10/97"),4)
LOCAL _cCart		 := '109'
LOCAL cConta       := RIGHT(cConta,5)
LOCAL _cNossoNum   := ''
//-------- Definicao do NOSSO NUMERO
_cNossoNum := U_FGERANNU('341')
NN   := _cCart+SUBSTR(_cNossoNum,1,8)+'-'+SUBSTR(_cNossoNum,9,1)
//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + _cfator + blvalorfinal + _cCart + SUBSTR(_cNossoNum,1,8) + SUBSTR(_cNossoNum,9,1) + cAgencia + cConta + cDacCC + '000'
dvcb := modulo11(s)
CB   := SUBSTR(s, 1, 4) + AllTrim(Str(dvcb)) + SUBSTR(s,5)
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	CAMPO 1:
//	AAA = Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := cBanco + _cCart + SUBSTR(_cNossoNum,1,2)
dv   := modulo10(s)
RN   := SUBSTR(s, 1, 5) + '.' + SUBSTR(s, 6, 4) + AllTrim(Str(dv)) + '  '
//	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SUBSTR(_cNossoNum,3,6) + SUBSTR(_cNossoNum,9,1) + SUBSTR(cAgencia, 1, 3)
dv   := modulo10(s)
RN   := RN + SUBSTR(s, 1, 5) + '.' + SUBSTR(s, 6, 5) + AllTrim(Str(dv)) + '  '
//	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SUBSTR(cAgencia, 4, 1) + cConta + cDacCC + '000'
dv   := modulo10(s)
RN   := RN + SUBSTR(s, 1, 5) + '.' + SUBSTR(s, 6, 5) + AllTrim(Str(dv)) + '  '
//	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + '  '
//	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
RN   := RN + _cfator + STRZERO(Int(nValor * 100),14-LEN(_cfator))
RETURN({CB,RN,NN})