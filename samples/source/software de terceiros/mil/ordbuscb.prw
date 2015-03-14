/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ORDBUSCB º Autor ³ Andre Luis Almeida º Data ³  07/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime Ordem de Busca                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Balcao                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ORDBUSCB(cT) 

Private aVetCampos := {}
Private cX := If(cT==Nil,"",cT)

DbSelectArea("VS3")
DbSetOrder(1)
If !DbSeek(xFilial("VS3")+M->VS1_NUMORC)
	Return()
EndIf

SetPrvt("cAlias , cNomRel , cGPerg , cTitulo , cDesc1 , cDesc2 , cDesc3 , aOrdem , lHabil , cTamanho , aReturn , ")
SetPrvt("titulo,cabec1,cabec2,nLastKey,wnrel,tamanho")

cAlias  := "VS3"
cNomRel := "ORDBUSCB"
cGPerg  := ""
cTitulo := "Req. de Pecas NF Balcao"
cDesc1  := "Ordem de Busca"
cDesc2  := cDesc3 := ""
aOrdem  := {}
lHabil  := .f.
lServer := ( GetMv("MV_LSERVER") == "S" )
cTamanho:= "P"
nLastKey:=0
aDriver := LeDriver()
cDrive  := GetMv("MV_DRVORB")
cPorta  := GetMv("MV_PORORB")
aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 3, cPorta, "",1 }  //"Zebrado"###"Administracao"
lVS1_OBSNFI := .f.
DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("VS1_OBSNFI")
	lVS1_OBSNFI := .t. 
EndIf 

//cNomRel := SetPrint(cAlias,cNomRel,nil,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,nil,nil,nil,cDrive,.T.  ,lServer,cPorta)

If nlastkey == 27
   Return(Allwaystrue())
EndIf

SetDefault(aReturn,cAlias)
RptStatus({|lEnd| FS_IMPORDBUSC(@lEnd,"OFIM110",'VS3')},Titulo)

If GetNewPar("MV_ORDBUST",80) == 80
	Eject
EndIf

Set Printer to
Set device to Screen

If aReturn[5] == 1
   OurSpool( cNomRel )
EndIf
                      
MS_FLUSH()

Return(Allwaystrue())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPORDBUSCº Autor ³ Andre Luis Almeida º Data ³  07/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime Relatorio Ordem de Busca                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Balcao                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_IMPORDBUSC()

SetPrvt("nLin , i , nTotal ")
SetPrvt("cbTxt , cbCont , cString , Li , m_Pag , wnRel , cTitulo , cabec1 , cabec2 , nomeprog , tamanho , nCaracter ")

// Cria Arquivo de Trabalho - LISTAGEM
aadd(aVetCampos,{ "TRB_CODITE" , "C" ,53 , 0 })  && GRUPO+CODITE+DESCR
aadd(aVetCampos,{ "TRB_LOCALI" , "C" ,15 , 0 })  && LOCALIZACAO
aadd(aVetCampos,{ "TRB_QTDREQ" , "N" , 8 , 2 })  && REQUISITADA

cArqTra := CriaTrab(aVetCampos, .T.)
DbUseArea( .T.,, cArqTra, "TRB", Nil, .F. )

DbSelectArea("TRB")
cArqInd1 := CriaTrab(NIL, .F.)
cChave := "TRB->TRB_LOCALI+left(TRB->TRB_CODITE,32)"
IndRegua("TRB",cArqInd1,cChave,,,OemToAnsi("Selecionando Registro") )

nCaracter := 0
nLin := 1 
i := 0 
nTotal := 0

Set Printer to &cNomRel
Set Printer On
Set device to Printer

cbTxt    := Space(10)
cbCont   := 0
cString  := "VS3"
Li       := 80
m_Pag    := 1
wnRel    := "OFIM110"
nomeprog := "ORDBUSCB"
tamanho  := "P"
nCaracter:= 18
limite   := 80
nTotal   := 0

If cX # "O" // Pela NF  
	DbSelectArea("VS1")
	DbSetOrder(3)
	DbSeek(xFilial("VS1")+SF2->F2_DOC+SF2->F2_SERIE)
EndIf
DbSelectArea("AA1")
DbSetOrder(1)
DbSeek(xFilial("AA1")+VS1->VS1_CODVEN)
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+VS1->VS1_CLIFAT+VS1->VS1_LOJA)
cPlaca := space(8)
DbSelectArea("VV1")
DbSetOrder(1)
DbSeek(xFilial("VV1")+VS1->VS1_CHAINT)
cPlaca := Transform(VV1->VV1_PLAVEI,"@R !!!-9999")
If GetNewPar("MV_ORDBUST",80) == 80
	If cX # "O" // Pela NF  
		cTitulo:= "NF:"+SF2->F2_DOC+"-"+SF2->F2_SERIE+" Orcamento:"+VS1->VS1_NUMORC
	Else // Pelo Orcamento  
		cTitulo:= "Orcamento:"+VS1->VS1_NUMORC
	EndIf
	cabec1 := "Cliente:"+left(VS1->VS1_CLIFAT+"-"+VS1->VS1_LOJA+" "+SA1->A1_NOME,52)+" Vendedor:"+left(AA1->AA1_NOMTEC,10)
	cabec2 := "Placa: "+cPlaca
	ccabx  := "  Seq  Codigo                           Descricao             Locacao     Qtde  "
Else
	If cX # "O" // Pela NF  
		cTitulo:= "NF:"+SF2->F2_DOC+"-"+SF2->F2_SERIE+" Orcamto:"+VS1->VS1_NUMORC+" Vended:"+left(AA1->AA1_NOMTEC,10)
	Else // Pelo Orcamento  
		cTitulo:= "Orcamento:"+VS1->VS1_NUMORC+"   Vendededor:"+left(AA1->AA1_NOMTEC,10)
	EndIf
	cabec1 := left("Cliente:"+VS1->VS1_CLIFAT+"-"+VS1->VS1_LOJA+" "+SA1->A1_NOME,48)
	cabec2 := "Placa: "+cPlaca
	ccabx  := "Codigo                             Qtde Locacao "
EndIf
DbSelectArea("VS3")
DbSetOrder(1)
DbSeek(xFilial("VS3")+VS1->VS1_NUMORC)
While !Eof() .and. VS3->VS3_FILIAL == xFilial("VS3") .and. VS3->VS3_NUMORC == VS1->VS1_NUMORC
   DbSelectArea("SB1")
   DbSetOrder(7)
   DbSeek( xFilial("SB1") + VS3->VS3_GRUITE + VS3->VS3_CODITE )
   DbSelectArea("SB5")
   DbSetOrder(1)
   DbSeek( xFilial("SB5") + SB1->B1_COD )
   DbSelectArea("SB2")
   DbSetOrder(1)
   DbSeek( xFilial("SB2") + SB1->B1_COD + "01")
   RecLock("TRB",.t.)  
      TRB->TRB_CODITE := VS3->VS3_GRUITE+" "+VS3->VS3_CODITE+" "+Substr(SB1->B1_DESC,1,20)
      TRB->TRB_LOCALI := SB5->B5_LOCALIZ
      TRB->TRB_QTDREQ := VS3->VS3_QTDITE
   MsunLock()
   DbSelectArea("VS3")
   DbSkip()
EndDo

dbselectarea("TRB")
dbgotop()
SetRegua(reccount())

//setprc(0,0)
If GetNewPar("MV_ORDBUST",80) == 80
	nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1
	i:= 1
	@ nLin++,0 PSAY ccabx     
	do while !eof()
	   if nLin > 60
	      eject
	      setprc(0,0)
	      nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1
	      @ nLin++,0 PSAY ccabx     
	   endif
	   @ nLin++,0 PSAY "  "+StrZero(i,3)+"  "+TRB->TRB_CODITE+"  "+left(TRB->TRB_LOCALIZ,8)+Transform(TRB->TRB_QTDREQ,"@E 99999.99")
	   dbselectarea("TRB")
	   dbskip()
	   i++
	enddo
	if nLin > 60
	   eject
	   setprc(0,0)
	   nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1
	   @ nLin++,0 PSAY ccabx     
	Endif
	If lVS1_OBSNFI
	   If	!Empty(VS1->VS1_OBSNFI)
		   nLin++
			@ nLin++,002 PSAY "OBS: "+VS1->VS1_OBSNFI
		EndIf
	EndIf
	nLin += 2
	@ nLin++,0 PSAY "       ________________________               ________________________        "
	@ nLin++,0 PSAY "              Atendente                             Retirado por              "
Else               
	@ nLin++,0 PSAY CHR(15)+" "
	nLin++
	@ nLin++,0 PSAY cTitulo
	@ nLin++,0 PSAY cabec1
	@ nLin++,0 PSAY cabec2
	nLin++
	@ nLin++,0 PSAY ccabx
	do while !eof()                          
	   @ nLin++,0 PSAY left(TRB->TRB_CODITE,31)+Transform(TRB->TRB_QTDREQ,"@E 99999.99")+" "+left(TRB->TRB_LOCALIZ,8)
		@ nLin++,4 PSAY substr(TRB->TRB_CODITE,33,30)
	   dbselectarea("TRB")
	   dbskip()
	enddo
	nLin += 2
	@ nLin++,0 PSAY "____________________        ____________________"  
	@ nLin++,0 PSAY "     Atendente                  Retirado por    "
	nLin += val(substr(str(GetNewPar("MV_ORDBUST",4010),4),3,2))
	@ nLin++,0 PSAY " "  
	SetPrc(0,0)
EndIf

TRB->(DBCLOSEAREA())

#IFNDEF TOP
	If File(cArqTra+OrdBagExt())
		fErase(cArqTra+OrdBagExt())
	Endif
#ENDIF

Return
