/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ORCAMTO  ³ Autor ³ Andre                 ³ Data ³ 01/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Orcamento                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Renata      ³14/12/04³      ³Solicitado Correio p/nao imprimir mod     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ORCAMTO()

SetPrvt("cTamanho,Limite,aOrdem,cTitulo,nLastKey,aReturn,cTitulo")
SetPrvt("cTamanho,cNomProg,cNomeRel,nLastKey,Limite,aOrdem,cAlias")
SetPrvt("cDesc1,cDesc2,cDesc3,lHabil,nOpca,nTipo,aPosGru,Inclui")
SetPrvt("cMarca,cObserv")

cTamanho := "P"                    // P/M/G
Limite   := 80                     // 80/132/220
aOrdem   := {}                     // Ordem do Relatorio
cTitulo  := "Orcamento"
cMarca   := "   "
nLastKey := 0
aReturn  := { "Zebrado", 1,"Administracao", 2, 1, 1, "",1 }
cTitulo  := "Orcamento"
cNomProg := "ORCAMTO"
cNomeRel := "ORCAMTO"
nLastKey := 0
cAlias   := "VS1"
cDesc1   := "Orcamento"
cDesc2   := ""
cDesc3   := ""
cObserv  := ""
lHabil   := .f.
nOpca    := 0
nTipo    := 18
aPosGru  := {}
Inclui   := .F.
nSemEstoque := 0
nMenEstoque := 0
lin      := 0
Private cPerg := "ORCAMT"
Private nSeq  := 0
Private Outputfile

if Type("ParamIXB") == "U"
	ParamIXB := Nil
Endif

if ParamIXB == Nil
	Private cCadastro := "Orcamentos"
	Private aRotina := { { "Pesquisar" ,"AxPesqui", 0 , 1},;
	{ "Imprimir"  ,"IMPORC"  , 0 , 3}}
	
	mBrowse( 6, 1,22,75,"VS1")
Else
	FS_ORCAMENTO(ParamIXB[1])
Endif

Return

/////////////////
Static Function IMPORC()

FS_ORCAMENTO(VS1->VS1_NUMORC)

Return


//////////////////////////////
Static Function FS_ORCAMENTO(cCodigo)

SetPrvt("cTipo,cOrdem,cTpoPad,cCusMed")

cPerg := "ORCAMT"
ValidPerg()

Pergunte(cPerg,.f.)

lServer  := ( GetMv("MV_LSERVER") == "S" )

aImp     := RetImpWin(lServer ) // .T. Quando for no SERVER e .F. no CLIENT (Retorna o nome das impressoras instaladas)
cDrive   := GetMv("MV_DRVRLP")
cNomeImp := getmv("MV_PORTORC")  //"LPT2"

cNomeRel := SetPrint(cAlias,cNomeRel,cPerg,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,nil    ,nil    ,nil)

If File(__RELDIR+cNomeRel+"_80.##R")
	Dele File &(__RELDIR+cNomeRel+"_80.##R")
EndIf
cArq := __RELDIR+cNomeRel+"_80.##R"
Outputfile := FCREATE(cArq,0)

cOrdem  := mv_par01
cTpoPad := if(mv_par02==1,"S","N")
cSeqSer := mv_par03
//CCusMed := mv_par04
CCusMed := 1

if nLastKey = 27
	Return
Endif

//Posicionamento dos Arquivos
DbSelectArea("VS1")
DbSetOrder(1)
DbSeek(xFilial("VS1")+cCodigo)
cMarca   := VS1->VS1_CODMAR

DbSelectArea("VV1")
FG_SEEK("VV1","VS1->VS1_CHAINT",1,.f.)

DbSelectArea("VV2")
FG_SEEK("VV2","cMarca+VV1->VV1_MODVEI",1,.f.)

DbSelectArea("VVC")
FG_SEEK("VVC","cMarca+VV1->VV1_CORVEI",1,.F.)

DbSelectArea("VS1")
FG_Seek("SE4","VS1->VS1_FORPAG",1,.f.)

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+VS1->VS1_CLIFAT)

nUltKil := 0

if VS1->VS1_KILOME != 0
	nUltKil := VS1->VS1_KILOME
else
	DBSelectArea("VFB")
	DBSetOrder(8)
	DBSeek(xFilial("VFB")+VV1->VV1_CHAINT)
	while !eof() .and. VV1->VV1_CHAINT == VFB->VFB_CHAINT
		nUltKil := VFB->VFB_KILOME
		DBSkip()
	enddo
endif
	
SetDefault(aReturn,cAlias)

RptStatus({|lEnd| FS_ORCAMTO(@lEnd,cNomeRel,cAlias)},cTitulo)
      
fwrite(outputfile," "+CHR(13)+CHR(10)+CHR(12)+" "+CHR(8))
fclose(Outputfile)

Eject

MS_FLUSH()

Set Printer to
Set Device  to Screen

If (aReturn[ 5 ] == 1)
	OurSpool(cNomeRel)
Endif

Return


//////////////////////////////////////////////
Static Function FS_ORCAMTO(lEnd,wNRel,cAlias)

SetPrvt("lin,Pag,nTotPec,nTotSer,nTotal,nTotDesP,nTotDesS")
SetPrvt("oPr,nX,aDriver,cCompac,cNormal")

aDriver := LeDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]
cOpcao  := "1"

//IF SM0->M0_CODIGO = "04"     //COTAVE
If Subs(cOpcao,1,1) != "1" // 1- Imprimir em impressora matricial / 2 - Impressora Grafica
//	cCompac := "CHR(27)" + "(s16.67H " + "chr(27)" + "(s9V"  //compacta e aumenta altura para laiser
	cCompac := "CHR(27)+chr(40)+chr(115)+"+"'16.67'"+"+chr(72)+chr(32)+chr(27)+chr(40)+chr(115)+"+"'9'"+"+chr(86)"  //compacta e aumenta altura para laiser
	cNormal := "CHR(27)+chr(40)+chr(115)+"+"'10'"+"chr(72)"
endif

nTotal   := 0
nTotPec  := nTotSer  := 0
nTotDesS := nTotDesP := 0

// Impressao do Orcamento
Set Printer to &wNRel
Set Printer On
Set Device  to Printer

Pag := 1       

FS_CABEC()
FS_DETALHE()
FS_RODAPE()

Return


//////////////////////////
Static Function FS_CABEC()

// SM0->(dbgotop())
cNomeEmp := SM0->M0_NOMECOM
cEndeEmp := SM0->M0_ENDENT
cNomeCid := "  Cidade: " + SM0->M0_CIDENT
cEstaEmp := SM0->M0_ESTENT
cCep_Emp := SM0->M0_CEPENT
cFoneEmp := "  -  FONE: " + SM0->M0_TEL
cFax_Emp := "FAX:  " + SM0->M0_FAX
cCNPJEmp := transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
cInscEmp := SM0->M0_INSC
cCodMun  := SM0->M0_CODMUN

setprc(0,0)
lin := 1
@ lin,01 psay &cCompac
lin+=1
@ lin,001 pSay repl([=],132)
lin+=1
@ lin,001 pSay "ORCAMENTO No. "+VS1->VS1_NUMORC+"                           PECAS e SERVICOS                     Emissao: " + DtoC(dDataBase) + "  Hora: " + time()  + "   Pag: " + StrZero(Pag,5)
lin+=1
@ lin,001 pSay repl([=],132)
lin+=1
@ lin,001 pSay "Emitente: " + cNomeEmp + " - CNPJ " + cCNPJEmp + " - IE " + CInscEmp+cFoneEmp
lin++
@ lin,001 pSay "Endereco: " + cEndeEmp + " CEP " + transform(cCep_Emp,"@R 99999-999") +  "   -   " + cNomeCid + " - " + cEstaEmp +"  -  "+cFax_Emp
lin++
@ lin,001 pSay repl([-],132)
lin++
// ORCAMENTO EM 80 COLUNAS // 
fwrite(outputfile,CHR(27)+'(s10H'+CHR(13)+CHR(10))
fwrite(outputfile,repl([=],80)+CHR(13)+CHR(10))
fwrite(outputfile,"ORCAMENTO "+VS1->VS1_NUMORC+"    PECAS e SERVICOS    Emissao: " + DtoC(dDataBase) + " - " + left(time(),5)  + "   Pag: " + StrZero(Pag,5)+CHR(13)+CHR(10))
fwrite(outputfile,repl([=],80)+CHR(13)+CHR(10))
fwrite(outputfile,left("Emitente: " + Alltrim(cNomeEmp) +"  -  "+ Alltrim(cNomeCid) + "-" + cEstaEmp,80)+CHR(13)+CHR(10))
fwrite(outputfile,left("CNPJ " + cCNPJEmp + "   -   IE " + CInscEmp + cFoneEmp,80)+CHR(13)+CHR(10))
fwrite(outputfile,left("End: " + cEndeEmp + " CEP " + transform(cCep_Emp,"@R 99999-999") + " - "+cFax_Emp,80)+CHR(13)+CHR(10))
fwrite(outputfile,repl([-],80)+CHR(13)+CHR(10))
/////////////////////////////

SA3->(DbSetOrder(1))    
SA3->(dbgotop())
SA3->(DbSeek(xFilial("SA3")+VS1->VS1_CODVEN))        

@ lin,001 pSay "Data do Orcamento....: " + DTOC(VS1->VS1_DATORC)

if VS1->VS1_TIPORC == "2"
   dbSelectArea("VOI")
   dbSetOrder(1)
   dbSeek(xFilial("VOI")+VS1->VS1_TIPTEM)
   @ lin,045 pSay "Validade do Orcamento.: " + DTOC(VS1->VS1_DATVAL) +"     Tipo de Tempo..:"+VS1->VS1_TIPTEM+" - "+VOI->VOI_DESTTE
   lin++
   @ lin,001 pSay "Vendedor: " + VS1->VS1_CODVEN + " - " + left(SA3->A3_NREDUZ,15)
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,left("Orcamento: " + DTOC(VS1->VS1_DATORC)+"  Validade: " + DTOC(VS1->VS1_DATVAL) +"  Tipo de Tempo: "+VS1->VS1_TIPTEM+" - "+VOI->VOI_DESTTE,80)+CHR(13)+CHR(10))
	fwrite(outputfile,left("Vendedor: " + VS1->VS1_CODVEN + " - " + left(SA3->A3_NREDUZ,15),80)+CHR(13)+CHR(10))
/////////////////////////////
Else
   @ lin,055 pSay "Validade do Orcamento.: " + DTOC(VS1->VS1_DATVAL) + "            Vendedor: " + VS1->VS1_CODVEN + " - " + left(SA3->A3_NREDUZ,15)
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,left("Orcamento: " + DTOC(VS1->VS1_DATORC)+"  Validade: " + DTOC(VS1->VS1_DATVAL) +"  Vendedor: " + VS1->VS1_CODVEN + " - " + left(SA3->A3_NREDUZ,15),80)+CHR(13)+CHR(10))
/////////////////////////////
Endif

lin++

@ lin,001 pSay repl([-],132)
lin++
// ORCAMENTO EM 80 COLUNAS // 
fwrite(outputfile,repl([-],80)+CHR(13)+CHR(10))
/////////////////////////////

cCGCCPF1  := subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
cCGCPro   := cCGCCPF1 + space(18-len(cCGCCPF1))

@ lin,001 pSay "Cliente.: " + VS1->VS1_CLIFAT + " - " + left(SA1->A1_NOME,40) + "   CNPJ/CPF: " + cCGCPro
// ORCAMENTO EM 80 COLUNAS // 
fwrite(outputfile,left("Cliente: " + VS1->VS1_CLIFAT + " - " + left(SA1->A1_NOME,33) + " CNPJ/CPF: " + cCGCPro ,80)+CHR(13)+CHR(10))
/////////////////////////////

lin++
@ lin,001 pSay "Endereco: " + left(SA1->A1_END,40)
@ lin,063 pSay "Cidade : " + SA1->A1_MUN+ " - " +SA1->A1_EST
lin++
// ORCAMENTO EM 80 COLUNAS // 
fwrite(outputfile,left("End.: " + left(SA1->A1_END,40)+ " - " + Alltrim(SA1->A1_MUN)+ "-" +SA1->A1_EST,80)+CHR(13)+CHR(10))
/////////////////////////////

VAM->( DbSeek( xFilial("VAM") + SA1->A1_IBGE ) )

@ lin,001 pSay "Telefone: (" + VAM->VAM_DDD + ") " + Alltrim(SA1->A1_TEL)
@ lin,063 pSay "Fax: (" + VAM->VAM_DDD + ") " + Alltrim(SA1->A1_FAX)
lin+=1
// ORCAMENTO EM 80 COLUNAS // 
fwrite(outputfile,left("Fone: (" + VAM->VAM_DDD + ") " + Alltrim(SA1->A1_TEL)+"  Fax: (" + VAM->VAM_DDD + ") " + Alltrim(SA1->A1_FAX),80)+CHR(13)+CHR(10))
/////////////////////////////

if VS1->VS1_TIPORC == "2"
	@ lin,001 pSay repl([-],132)
	lin+=1
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,repl([-],80)+CHR(13)+CHR(10))
/////////////////////////////
	@ lin,001 pSay "Dados do Veiculo - Chassi: " + VV1->VV1_CHASSI + "                  Placa: " + VV1->VV1_PLAVEI + "      Cor: " + VV1->VV1_CORVEI + " - " + VVC->VVC_DESCRI
	lin++
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,left("Veiculo - Chassi: " + Alltrim(VV1->VV1_CHASSI) + " Placa: " + VV1->VV1_PLAVEI + " Cor: " + VV1->VV1_CORVEI + "-" + VVC->VVC_DESCRI,80)+CHR(13)+CHR(10))
/////////////////////////////
	IF SM0->M0_CODIGO = "20" .and. VV1->VV1_CHAINT $ "003123/003120/003119" .and. VV1->VV1_PROATU = "004794"  //ELMAZ BH VEIC DO CORREIO (alterado em 14/12/04 p/ Monica)
		@ lin,001 pSay "                   Fab/Mod: " + left(VV1->VV1_FABMOD,4)+"/"+right(VV1->VV1_FABMOD,4) + "     Km: " + strzero(nUltKil,8)
// ORCAMENTO EM 80 COLUNAS // 
		fwrite(outputfile,left("          Fab/Mod: " + left(VV1->VV1_FABMOD,4)+"/"+right(VV1->VV1_FABMOD,4) + " Km: " + strzero(nUltKil,8),80)+CHR(13)+CHR(10))
/////////////////////////////
   else
		@ lin,001 pSay "                   Modelo: " + left(VV1->VV1_MODVEI,20) + "-" + left(VV2->VV2_DESMOD,15) + "       Fab/Mod: " + left(VV1->VV1_FABMOD,4)+"/"+right(VV1->VV1_FABMOD,4) + "     Km: " + strzero(nUltKil,8)
// ORCAMENTO EM 80 COLUNAS // 
		fwrite(outputfile,left("          Modelo: " + left(VV1->VV1_MODVEI,15) + "-" + left(VV2->VV2_DESMOD,14) + " Fab/Mod: " + left(VV1->VV1_FABMOD,4)+"/"+right(VV1->VV1_FABMOD,4) + " Km: " + strzero(nUltKil,8),80)+CHR(13)+CHR(10))
/////////////////////////////
   endif
endif

lin+=1
@ lin,001 pSay repl([-],132)
lin+=1
// ORCAMENTO EM 80 COLUNAS // 
fwrite(outputfile,repl([-],80)+CHR(13)+CHR(10))
/////////////////////////////

Return


////////////////////////////
Static Function FS_DETALHE()

Local bCampo := { |nCPO| Field(nCPO) }
Local i := 0

SetPrvt("nSubTot,cGrupo,aStru,cTipSer,nSaldo")

nSubtot := 0

if VS1->VS1_TIPORC == "2"
	
	aStru := {}
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("VS4")
	Do While !Eof() .And. x3_arquivo == "VS4"
		if x3_context # "V"
			Aadd(aStru,{x3_campo,x3_tipo,x3_tamanho,x3_decimal})
		Endif
		DbSkip()
	EndDo
	
	cArqTemp := CriaTrab(aStru)
	dbUseArea( .T.,,cArqTemp,"TRB", .F. , .F. )
	if cSeqSer == 2
		cChave  := "VS4_FILIAL+VS4_NUMORC+VS4_TIPSER+VS4_GRUSER+VS4_CODSER"
	Else
		cChave  := "VS4_FILIAL+VS4_NUMORC+VS4_SEQUEN"
	Endif
	IndRegua("TRB",cArqTemp,cChave,,,"Filtrando Servicos")
	DbSelectArea("TRB")
	DbSetOrder(1)
	
	DbSelectArea("VS4")
	DbSeek(xFilial("VS4")+VS1->VS1_NUMORC)
	Do While !Eof() .and. VS4->VS4_NUMORC == VS1->VS1_NUMORC
		DbSelectArea("TRB")
		RecLock("TRB",.T.)
		For i := 1 to FCOUNT()
			cCpo := aStru[i,1]
			TRB->&(cCpo) := VS4->&(Field(i))
		Next
		MsUnlock()
		DbSelectArea("VS4")
		DbSkip()
	EndDo
	
	DbSelectArea("TRB")
	DbGotop()
	
Endif

//Pecas

DbSelectArea("VS3")
DbGotop()
DbSetOrder(1)
if cOrdem == 2
	DbSetOrder(2)
Endif

if DbSeek(xFilial("VS3")+VS1->VS1_NUMORC)
	
	@ lin,000 pSay &cCompac+" "
	lin+=1
	@ lin,001 pSay "******** PECAS ********"
	lin+=1
	@ lin,001 pSay repl([=],132)
	lin++
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile," "+CHR(13)+CHR(10))
	fwrite(outputfile,"******** PECAS ********"+CHR(13)+CHR(10))
	fwrite(outputfile,repl([=],80)+CHR(13)+CHR(10))
/////////////////////////////
	
	If SM0->M0_CODIGO == "05" // Elmaz Veiculos
		If cCusMed = 2
			@ lin,001 pSay "Seq Grup"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao            Local            Qtde                               Valor Total Custo Med"
		else
			@ lin,001 pSay "Seq Grup"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao            Local            Qtde                               Valor Total"
		endif
	Else	
		If cCusMed = 2
			@ lin,001 pSay "Seq Grup"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao            Local            Qtde    Vl Unitar %Desct Vl Descto Valor Total Custo Med"
		else
			@ lin,001 pSay "Seq Grup"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao            Local            Qtde    Vl Unitar %Desct Vl Descto Valor Total"
		endif
	Endif
	lin++
	@ lin,001 pSay repl([=],132)
	lin++
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,left("Grup"+If(MV_PAR05#1," Codigo              "," ")+"Descricao                "+If(MV_PAR05#1," ",Space(21))+"Qtde   Vlr Unitar   Vlr Total",80)+CHR(13)+CHR(10))
	fwrite(outputfile,repl([=],80)+CHR(13)+CHR(10))
/////////////////////////////
	
	DbSelectArea("SB1")
	DbSetOrder(7)
	DbSelectArea("SB5")
	DbSelectArea("VS3")
	
	cGrupo := VS3->VS3_GRUITE
	nSeq	 := 0
	
	cGrp    := VS3->VS3_GRUITE
	nQtdIte := 0
   nPerDes := 0 
   nTotDes := 0 
   nTotGer := 0
	Do While !EOF() .and. VS3->VS3_NUMORC == VS1->VS1_NUMORC
		
		DbSelectArea("SB1")
		DbGotop()
		DbSeek(xFilial("SB1")+VS3->VS3_GRUITE+VS3->VS3_CODITE)
		
		DbSelectArea("SB5")
		DbGotop()
		DbSeek(xFilial("SB5")+SB1->B1_COD)
		
		DbSelectArea("SBM")
		DbGotop()
		DbSeek(xFilial("SBM")+VS3->VS3_GRUITE)
		
		DbSelectArea("SB2")
		DbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
		nSaldo := SaldoSB2()
		
		DbSelectArea("VS3")
		
      if cOrdem == 2
         if cGrp <> VS3->VS3_GRUITE
	   		@ lin,001 pSay "Total "+cGrp+"........................................................:"
      		@ lin,075 pSay Transform(nQtdIte,"@E 99999")
	   		@ lin,094 pSay Transform(nPerDes,"999.99")
		   	@ lin,101 pSay Transform(nTotDes,"@E 99,999.99")
			   @ lin,111 pSay Transform(nTotGer,"@E 9999,999.99")
            lin+=2
// ORCAMENTO EM 80 COLUNAS // 
				fwrite(outputfile,left("Total "+cGrp+"......................................: "+Transform(nQtdIte,"@E 99999")+"             "+Transform(nTotGer,"@E 99999,999.99"),80)+CHR(13)+CHR(10))
				fwrite(outputfile," "+CHR(13)+CHR(10))
/////////////////////////////
      		nQtdIte := 0
            nPerDes := 0
            nTotDes := 0
	   	   nTotGer := 0
         Endif
      Endif
		nSeq++
		@ lin,001 pSay strzero(nSeq,3)+" "+VS3->VS3_GRUITE
		If MV_PAR05 # 1
			@ lin,010 pSay VS3->VS3_CODITE
		EndIf
		
		@ lin,038 pSay left(SB1->B1_DESC,20)
		@ lin,059 pSay SB5->B5_LOCALIZ
		@ lin,075 pSay Transform(VS3->VS3_QTDITE,"@E 99999")
		if nSaldo <= 0
		   nSemEstoque++
		   @ lin,081 pSay "**"
      elseif nSaldo < VS3->VS3_QTDITE
         nMenEstoque++      
		   @ lin,081 pSay "*"                         
  		Endif
  		If SM0->M0_CODIGO == "05" // Elmaz Veiculos
			@ lin,111 pSay Transform(VS3->VS3_VALTOT,"@E 9999,999.99")
		Else	
			@ lin,084 pSay Transform(VS3->VS3_VALPEC,"@E 99,999.99")
			@ lin,094 pSay Transform(VS3->VS3_PERDES,"999.99")
			@ lin,101 pSay Transform(VS3->VS3_VALDES,"@E 99,999.99")
			@ lin,111 pSay Transform(VS3->VS3_VALTOT,"@E 9999,999.99")
		Endif	
		
		If cCusMed = 2
			@ lin,123 pSay Transform(SB2->B2_CM1,"@E 99,999.99")
		endif

// ORCAMENTO EM 80 COLUNAS // 
		fwrite(outputfile,left(VS3->VS3_GRUITE+" "+If(MV_PAR05#1,left(VS3->VS3_CODITE,19)+" "+left(SB1->B1_DESC,25),left(SB1->B1_DESC+space(45),45))+Transform(VS3->VS3_QTDITE,"@E 99999")+" "+If(nSaldo<VS3->VS3_QTDITE,"*"," ")+If(nSaldo<=0,"*"," ")+Transform((VS3->VS3_VALTOT/VS3->VS3_QTDITE),"@E 999,999.99")+Transform(VS3->VS3_VALTOT,"@E 99999,999.99"),80)+CHR(13)+CHR(10))
/////////////////////////////
		
		nTotPec  := nTotPec  + VS3->VS3_VALTOT
		nTotDesP := nTotDesP + VS3->VS3_VALDES
		
		if cOrdem == 2
			nSubTot := nSubTot + VS3->VS3_VALTOT
		Endif

		nQtdIte += VS3->VS3_QTDITE
      nPerDes += VS3->VS3_PERDES
      nTotDes += VS3->VS3_VALDES
		nTotGer += VS3->VS3_VALTOT
      cGrp    := VS3->VS3_GRUITE		
		DbSelectArea("VS3")
		DbSkip()
		
		lin++
		
		if lin > 60
// ORCAMENTO EM 80 COLUNAS // 
			fwrite(outputfile," "+CHR(12)+" "+CHR(8))
/////////////////////////////
			Pag := Pag + 1
			eject
			FS_CABEC()
			@ lin,000 pSay &cCompac+" "
			lin+=1
			@ lin,001 pSay "******** PECAS ********"
			lin+=1
			@ lin,001 pSay repl([=],132)
			lin++
// ORCAMENTO EM 80 COLUNAS // 
			fwrite(outputfile," "+CHR(13)+CHR(10))
			fwrite(outputfile,"******** PECAS ********"+CHR(13)+CHR(10))
			fwrite(outputfile,repl([=],80)+CHR(13)+CHR(10))
/////////////////////////////
	  		If SM0->M0_CODIGO == "05" // Elmaz Veiculos
				If cCusMed = 2
					@ lin,001 pSay "Seq Grup"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao            Local            Qtde                               Valor Total Custo Med"
				else
					@ lin,001 pSay "Seq Grup"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao            Local            Qtde                               Valor Total"
				endif
			Else	
				If cCusMed = 2
					@ lin,001 pSay "Seq Grup"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao            Local            Qtde    Vl Unitar %Desct Vl Descto Valor Total Custo Med"
				else
					@ lin,001 pSay "Seq Grup"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao            Local            Qtde    Vl Unitar %Desct Vl Descto Valor Total"
				endif
			Endif	
			lin++
			@ lin,001 pSay repl([=],132)
			lin++
// ORCAMENTO EM 80 COLUNAS // 
			fwrite(outputfile,left("Grup"+If(MV_PAR05#1," Codigo              "," ")+"Descricao                "+If(MV_PAR05#1," ",Space(21))+"Qtde   Vlr Unitar   Vlr Total",80)+CHR(13)+CHR(10))
			fwrite(outputfile,repl([=],80)+CHR(13)+CHR(10))
/////////////////////////////
		Endif
	EndDo

   if cOrdem == 2
		@ lin,001 pSay "Total "+cGrp+"........................................................:"
		@ lin,075 pSay Transform(nQtdIte,"@E 99999")
	   @ lin,094 pSay Transform(nPerDes,"999.99")
		@ lin,101 pSay Transform(nTotDes,"@E 99,999.99")
		@ lin,111 pSay Transform(nTotGer,"@E 9999,999.99")
		lin++
		@ lin,001 pSay repl([-],132)
		lin++
// ORCAMENTO EM 80 COLUNAS // 
		fwrite(outputfile,left("Total "+cGrp+"......................................: "+Transform(nQtdIte,"@E 99999")+"             "+Transform(nTotGer,"@E 99999,999.99"),80)+CHR(13)+CHR(10))
		fwrite(outputfile,repl([-],80)+CHR(13)+CHR(10))
/////////////////////////////
   EndIf
		
	if lin > 60
// ORCAMENTO EM 80 COLUNAS // 
		fwrite(outputfile," "+CHR(12)+" "+CHR(8))
/////////////////////////////
		Pag := Pag + 1
		EJECT
		FS_CABEC()
	Endif
	
	If SM0->M0_CODIGO != "05" // Elmaz Veiculos
		if nTotDesP > 0
			@ lin,021 pSay "Desconto em Pecas.....:"
			@ lin,044 pSay Transform(nTotDesP,"@E 9999,999.99")
		endif
	endif
	
	@ lin,084 pSay "SubTotal de Pecas.......:"
	@ lin,111 pSay Transform(nTotPec,"@E 9999,999.99")
	lin++
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,left(space(40)+"Sub-Total de Pecas.........:"+Transform(nTotPec,"@E 99999,999.99"),80)+CHR(13)+CHR(10))
/////////////////////////////
	
Endif

//Servicos

aTipoSer := {}

if VS1->VS1_TIPORC == "2" //.and. TRB->(DbSeek(xFilial("TRB")+VS1->VS1_NUMORC))

   DbSelectArea("TRB")
   DbGotop()
   if reccount() > 0

	lin++
	
	if lin > 55
// ORCAMENTO EM 80 COLUNAS // 
		fwrite(outputfile," "+CHR(12)+" "+CHR(8))
/////////////////////////////
		Pag := Pag + 1
		eject
		FS_CABEC()
	Endif
	
	@ lin,000 pSay &cCompac+" "
	@ lin,001 pSay "******** SERVICOS ********"
	lin+=1
	@ lin,001 pSay repl([=],132)
	lin++

// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile," "+CHR(13)+CHR(10))
	fwrite(outputfile,"******** SERVICOS ********"+CHR(13)+CHR(10))
	fwrite(outputfile,repl([=],80)+CHR(13)+CHR(10))
/////////////////////////////

	If SM0->M0_CODIGO == "05" // Elmaz Veiculos
		if cTpoPad == "N"
			@ lin,001 pSay "Grupo"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao                      Tipo                                         Tot Servico"
		Else
			@ lin,001 pSay "Grupo"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao                      Tipo TpPad                                   Tot Servico"
		Endif
	Else	
		if cTpoPad == "N"
			@ lin,001 pSay "Grupo"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao                      Tipo        Vlr Servico %Desct Valor Descto  Tot Servico"
		Else
			@ lin,001 pSay "Grupo"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao                      Tipo TpPad  Vlr Servico %Desct Valor Descto  Tot Servico"
		Endif
	Endif	
	lin++
	@ lin,001 pSay repl([=],132)
	lin++
// ORCAMENTO EM 80 COLUNAS // 
	if cTpoPad == "N"
		fwrite(outputfile,left("Grup Codigo               Descricao                                  Vlr.Servico",80)+CHR(13)+CHR(10))
	Else
		fwrite(outputfile,left("Grup Codigo               Descricao                           TpPad  Vlr.Servico",80)+CHR(13)+CHR(10))
	EndIf
	fwrite(outputfile,repl([=],80)+CHR(13)+CHR(10))
/////////////////////////////
			
	DbSelectArea("SB1")
	DbSetOrder(7)
	DbSelectArea("TRB")
	
	nSubTot := 0
	cTipSer := TRB->VS4_TIPSER
	Do While !EOF() .and. TRB->VS4_NUMORC == VS1->VS1_NUMORC
		
		DbSelectArea("VO6")
		DbSetOrder(2)
		DbGotop()
		DbSeek(xFilial("VO6")+cMarca+TRB->VS4_CODSER)
		
		DbSelectArea("VOK")
		DbSetOrder(1)
		DbGotop()
		DbSeek(xFilial("VS4")+TRB->VS4_TIPSER)
		
		DbSelectArea("TRB")
		
		@ lin,001 pSay TRB->VS4_GRUSER
		@ lin,007 pSay TRB->VS4_CODSER
		@ lin,035 pSay VO6->VO6_DESSER
		@ lin,066 pSay TRB->VS4_TIPSER
		if cTpoPad == "S"
			@ lin,071 pSay Transform(TRB->VS4_TEMPAD,"@R 99:99")
		Endif
  		If SM0->M0_CODIGO != "05" // Elmaz Veiculos
			@ lin,079 pSay Transform(TRB->VS4_VALSER,"@E 999,999.99")
			@ lin,090 pSay Transform(TRB->VS4_PERDES,"999.99")
			@ lin,097 pSay Transform(TRB->VS4_VALDES,"@E 9,999,999.99")
			@ lin,111 pSay Transform(TRB->VS4_VALTOT,"@E 9999,999.99")
		Else	
			@ lin,111 pSay Transform(TRB->VS4_VALTOT,"@E 9999,999.99")
		Endif	

// ORCAMENTO EM 80 COLUNAS // 
		fwrite(outputfile,left(TRB->VS4_GRUSER+"   "+left(TRB->VS4_CODSER+space(20),20)+" "+left(VO6->VO6_DESSER+space(35),35)+if(cTpoPad=="N",space(6),Transform(TRB->VS4_TEMPAD,"@R 999:99"))+Transform(TRB->VS4_VALTOT,"@E 999999,999.99"),80)+CHR(13)+CHR(10))
/////////////////////////////
		
		nTotSer  := nTotSer  + TRB->VS4_VALTOT
		nTotDesS := nTotDesS + TRB->VS4_VALDES
		
		if cSeqSer == 2
			nSubTot := nSubTot + TRB->VS4_VALTOT
		Endif
		
		DbSelectArea("TRB")
		DbSkip()
		
		lin++
		
		if lin > 60
// ORCAMENTO EM 80 COLUNAS // 
			fwrite(outputfile," "+CHR(12)+" "+CHR(8))
/////////////////////////////
			Pag := Pag + 1
			eject
			FS_CABEC()
			@ lin,000 pSay &cCompac+" "
			@ lin,001 pSay "******** SERVICOS ********"
			lin+=1
			@ lin,001 pSay repl([=],132)
			lin++
// ORCAMENTO EM 80 COLUNAS // 
			fwrite(outputfile," "+CHR(13)+CHR(10))
			fwrite(outputfile,"******** SERVICOS ********"+CHR(13)+CHR(10))
			fwrite(outputfile,repl([=],80)+CHR(13)+CHR(10))
/////////////////////////////
			If SM0->M0_CODIGO == "05" // Elmaz Veiculos
				if cTpoPad == "N"
					@ lin,001 pSay "Grupo"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao                      Tipo                                         Tot Servico"
				Else
					@ lin,001 pSay "Grupo"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao                      Tipo TpPad                                   Tot Servico"
				Endif
			Else	
				if cTpoPad == "N"
					@ lin,001 pSay "Grupo"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao                      Tipo        Vlr Servico %Desct Valor Descto  Tot Servico"
				Else
					@ lin,001 pSay "Grupo"+If(MV_PAR05#1," Codigo                      ",Space(29))+"Descricao                      Tipo TpPad  Vlr Servico %Desct Valor Descto  Tot Servico"
				Endif
			Endif	
			lin++
			@ lin,001 pSay repl([=],132)
			lin++
// ORCAMENTO EM 80 COLUNAS //
			if cTpoPad == "N" 
				fwrite(outputfile,left("Grup Codigo               Descricao                                  Vlr.Servico",80)+CHR(13)+CHR(10))
			Else
				fwrite(outputfile,left("Grup Codigo               Descricao                           TpPad  Vlr.Servico",80)+CHR(13)+CHR(10))
			EndIf
			fwrite(outputfile,repl([=],80)+CHR(13)+CHR(10))
/////////////////////////////
		Endif
	EndDo
	if lin > 60
// ORCAMENTO EM 80 COLUNAS // 
		fwrite(outputfile," "+CHR(12)+" "+CHR(8))
/////////////////////////////
		Pag := Pag + 1
		eject
		FS_CABEC()
	Endif
	@ lin,001 pSay repl([-],132)
	lin++
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,repl([-],80)+CHR(13)+CHR(10))
/////////////////////////////
	If SM0->M0_CODIGO != "05" // Elmaz Veiculos
		if nTotDesS > 0
			@ lin,021 pSay "Desconto em Servicos..:"
			@ lin,044 pSay Transform(nTotDesS,"@E 9999,999.99")
		endif
	endif
	@ lin,084 pSay "SubTotal de Servicos......:"
	@ lin,111 pSay Transform(nTotSer,"@E 9999,999.99")
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,left(space(40)+"Sub-Total de Servicos......:"+Transform(nTotSer,"@E 99999,999.99"),80)+CHR(13)+CHR(10))
/////////////////////////////
	endif
Endif

if VS1->VS1_TIPORC == "2"

   DbSelectArea("TRB")
   TRB->(DbCloseArea())

&& Apaga Arquivo de Trabalho
   #IFNDEF TOP
	   If File(cArqTemp+".dbf")
	   	fErase(cArqTemp+".dbf")
    	Endif
   #ENDIF

&& Apaga Arquivo de Trabalho
   #IFNDEF TOP
	   If File(cArqTemp+OrdBagExt())
		   fErase(cArqTemp+OrdBagExt())
   	Endif
   #ENDIF

endif

lin+=3

if lin > 60
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile," "+CHR(12)+" "+CHR(8))
/////////////////////////////
	Pag := Pag + 1
	eject
	FS_CABEC()
Endif

// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile," "+CHR(13)+CHR(10))
/////////////////////////////

if nSemEstoque > 0
	@ lin++,001 pSay "OBS: OS ITENS ASSINALADOS COM '**' AO LADO DA QUANTIDADE ESTAO COM SALDO ZERO NO MOMENTO "
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,left("OS ITENS ASSINALADOS COM '**' AO LADO DA QTDE ESTAO COM SALDO ZERO NO MOMENTO",80)+CHR(13)+CHR(10))
/////////////////////////////
Endif

if nMenEstoque > 0
	@ lin++,001 pSay "OBS: OS ITENS ASSINALADOS COM '* ' AO LADO DA QUANTIDADE ESTAO INSUFICIENTES NO MOMENTO"
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,left("OS ITENS ASSINALADOS COM '* ' AO LADO DA QTDE ESTAO INSUFICIENTES NO MOMENTO",80)+CHR(13)+CHR(10))
/////////////////////////////
Endif

@ lin,001 pSay &cCompac+" "

Return


////////////////////
Static Function FS_RODAPE()

lin++

if lin > 60
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile," "+CHR(12)+" "+CHR(8))
/////////////////////////////
	Pag := Pag + 1
	eject
	FS_CABEC()
	lin++
Endif

@ lin,001 pSay "Observacao:"
cKeyAce := VS1->VS1_OBSMEM + [001]
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile," "+CHR(13)+CHR(10))
	fwrite(outputfile,"Observacoes:"+CHR(13)+CHR(10))
/////////////////////////////


DbSelectArea("SYP")
DbSetOrder(1)
FG_SEEK("SYP","cKeyAce",1,.f.)

do while xFilial("SYP")+VS1->VS1_OBSMEM == SYP->YP_FILIAL+SYP->YP_CHAVE .and. !eof()
	
	nPos := AT("\13\10",SYP->YP_TEXTO)
	if nPos > 0
		nPos-=1
	Else
		nPos := Len(SYP->YP_TEXTO)
	Endif
	cObserv := Substr(SYP->YP_TEXTO,1,nPos)
	
	@ lin,013 pSay cObserv
	lin++
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,left("   "+cObserv,80)+CHR(13)+CHR(10))
/////////////////////////////

	SYP->(DbSkip())

	if lin > 60
// ORCAMENTO EM 80 COLUNAS // 
		fwrite(outputfile," "+CHR(12)+" "+CHR(8))
/////////////////////////////
		Pag := Pag + 1
		eject
		FS_CABEC()
	Endif

enddo
lin++
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile," "+CHR(13)+CHR(10))
/////////////////////////////

nTotal := nTotPec + nTotSer

lin++
if lin > 47
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile," "+CHR(12)+" "+CHR(8))
/////////////////////////////
	Pag := Pag + 1
	eject
	FS_CABEC()
	lin++
	lin++
// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile," "+CHR(13)+CHR(10))
/////////////////////////////
Endif


@ lin++,01 pSay "*****  T O T A I S  *****"
lin++
@ lin++,01 pSay "Pecas....: " + Transform(nTotPec,"@E 999,999,999.99")
@ lin++,01 pSay "Servicos.: " + Transform(nTotSer,"@E 999,999,999.99")
@ lin++,01 pSay "Orcamento: " + Transform(nTotal,"@E 999,999,999.99") + "    Cond.Pagto.: " + VS1->VS1_FORPAG + "-" + SE4->E4_DESCRI
lin++
@ lin++,40 pSay "A U T O R I Z O ( A M O S )   O   F A T U R A M E N T O   D E S T E   O R C A M E N T O ."
lin++
@ lin++,40 pSay "Local:________________________________________, Data:________/__________________/________"
lin++
@ lin++,60 pSay "CARIMBO"
lin++
lin++
@ lin++,60 pSay "Ass.:_________________________________________"


// ORCAMENTO EM 80 COLUNAS // 
	fwrite(outputfile,"*****  T O T A I S  *****"+CHR(13)+CHR(10))
	fwrite(outputfile,"Pecas....: " + Transform(nTotPec,"@E 999,999,999.99")+CHR(13)+CHR(10))
	fwrite(outputfile,"Servicos.: " + Transform(nTotSer,"@E 999,999,999.99")+CHR(13)+CHR(10))
	fwrite(outputfile,"Orcamento: " + Transform(nTotal,"@E 999,999,999.99") + "   C.Pgto: " + VS1->VS1_FORPAG + "-" + SE4->E4_DESCRI+CHR(13)+CHR(10))
	fwrite(outputfile," "+CHR(13)+CHR(10))
	fwrite(outputfile,"                    AUTORIZO(AMOS)    O    FATURAMENTO    DESTE    ORCAMENTO"+CHR(13)+CHR(10))
	fwrite(outputfile," "+CHR(13)+CHR(10))
	fwrite(outputfile,"                    Local:_____________________, Data:____/___________/_____"+CHR(13)+CHR(10))
	fwrite(outputfile," "+CHR(13)+CHR(10))
	fwrite(outputfile,"                                CARIMBO"+CHR(13)+CHR(10))
	fwrite(outputfile," "+CHR(13)+CHR(10))
	fwrite(outputfile," "+CHR(13)+CHR(10))
	fwrite(outputfile,"                                Ass.:____________________________"+CHR(13)+CHR(10))
/////////////////////////////


Return


//////////////////////////
Static Function LEDriver()

Local aSettings := {}
Local cStr, cLine, i

if !File(__DRIVER)
	aSettings := {"CHR(15)","CHR(18)","CHR(15)","CHR(18)","CHR(15)","CHR(15)"}
Else
	cStr := MemoRead(__DRIVER)
	For i:= 2 to 7
		cLine := AllTrim(MemoLine(cStr,254,i))
		AADD(aSettings,SubStr(cLine,7))
	Next
Endif

Return(aSettings)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ FG_Seek  ³ Autor ³Alvaro/Andre           ³ Data ³ 05/07/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Posiciona Reg e permanece nele. Atribui Valor a outro Campo³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ (Alias,Chave,Ordem,.t./.f.-p/softseek on/off,CpoDes,CpoOri)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
   Sintaxe: FG_Seek( <ExpC1>, <ExpC2>, [ExpN], [ExpL], <ExpC3>, <ExpC4> )
   Funcao.: Executa pesquisa em tabelas
              ExpC1 = arquivo alvo
              ExpC2 = chave de pesquisa
              ExpN  = numero do indice associado a ExpC1  (Opcional)
                      Se nao informado assume 1
              ExpL  = se .t. softseek ON                  (Opcional)
                      Se nao informado assume .f.
              ExpC3 = Campo Destino (que recebera conteudo)
              ExpC4 = Campo Origem do conteudo
   Retorna: .t. se o reg. existir, deixando posicionado no mesmo
            .f. se o reg. nao existir, deixando posic. no final do Arquivo
*/

Static Function FG_Seek(cAlias,Chv_,Ord_,Sss_,cCpoDest,cCpoOrig)

Local Atu_:=SELECT(),Ind_, Sem_dbf:=ALIAS(), Achou_
Local i := 0

Ord_:=IF(Ord_=NIL,1,Ord_)
Sss_:=IF(Sss_=NIL,.f.,Sss_)
cCom:=IF(cCpoOrig=NIL," ",cAlias+"->"+cCpoOrig)

Select(cAlias)
Ind_:=IndexOrd()
DbSetOrder(Ord_)
Set SoftSeek (Sss_)

if Type("aCols") == "A"    && Modelo 3

   cChave := ""

   if type(readvar()) == "U"
	  cUlCpo := ""
   Else
	  cUlCpo := &(readvar())
   Endif

   //k > 0 .and. ( Subs(chv_,k-1,1) == "+" .or. Subs(chv_,k-1,1) == "" .or. !SX2->(dbSeek(Subs(chv_,k-2,3))) )

   k := at("M->",chv_)
   if k > 0 .and. ( Subs(chv_,k-1,1) == "+" .or. (k-1 == 0) .or. !SX2->(dbSeek(Subs(chv_,k-2,3))) )
      bCampo := {|x| aHeader[x,2]}
      w1 := READVAR()
      For i=1 to Len(aHeader)
         wVar := "M->"+(EVAL(bCampo,i))
         If wVar != w1
            Private &wVar := aCols[n,i]
         Endif
      Next
   Endif

   While .t.

      k := at("+",chv_)
      if k > 0
         cCPO := substr(chv_,1,k-1)
         chv_ := substr(chv_,k+1)
         if at("->",cCpo) == 0 .and. type(cCpo) == "U"
            cChave := cChave + FieldGet(FieldPos(cCPO))
         else
            cChave := cChave + &cCpo
         endif
     Else
         if !Chv_ == readvar()
            cUlCpo := &Chv_
         endif
         Exit
     Endif

   Enddo

   cChv_ := cChave+cUlCpo

Else

   cChv_ := (&Chv_) 

Endif

DbGotop()
DbSeek(xFilial(cAlias)+cChv_)
Achou_:=FOUND()

DbSetOrder(ind_)
IF Empty(sem_dbf)
   Sele 0
ELSE
   Sele (Atu_)
ENDI

Set SoftSeek (.f.)

if cCom != " "
   M->&cCpoDest := &cCom
endif

RETU Achou_


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  13/07/01   º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg

local _sAlias := Alias()
local aRegs := {}
local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Ordem Seq/Codigo","",""   ,"mv_ch1","N",1,0,0,"C","","mv_par1","Sequencia","","","","","Codigo","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Imprime Tempo Padrao","","","mv_ch2","N",1,0,0,"C","","mv_par2","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Ordem Seq/Tipo Serv","","","mv_ch3","N",1,0,0,"C","","mv_par3","Sequencia","","","","","Tipo de Servico","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Imprime Custo Medio","","","mv_ch4","N",1,0,0,"C","","mv_par4","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Imprime Cod do Item","","","mv_ch5","N",1,0,0,"C","","mv_par5","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
