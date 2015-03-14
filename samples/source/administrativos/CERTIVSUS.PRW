#INCLUDE "CERTIVSUS.ch"
#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  CERTIVSUS  ºAutor  ³ Ana Paula Nascimento º Data ³ 26/05/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Certificado de IVA e SUSS							 	   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CERTIVSUS(aCertImp,cCodAss,lIncPa)
Local aNfs	:= {}
Local cChave
Local oPrint  
Local aDados := {}      
Local lExiste := .F.
Local nValRet := 0 
Local nTotRet := 0  
Local aRets := {}   
Local nX := 0
Local cImposto:=aCertImp[2] 
Local cTitulo	:= Iif(cImposto=="S",STR0002,STR0001)
Local nValMerc := 0
Local nValImp := 0
Local nValOp	:= 0
Local cDescCon := ""

Default lIncPa := .F.

oPrint	:= TMSPrinter():New( cTitulo )
oPrint:SetPortrait() //Retrato
//oPrint:SetLandscape() //Paisagem


DbSelectArea("SFE")
DbSetOrder(9)
If DbSeek(xFilial("SFE")+aCertImp[1]+aCertImp[2])
cFornece:=SFE->FE_FORNECE
cLoja:=SFE->FE_LOJA
dEmisCert:=SFE->FE_EMISSAO 
cNumOp:= SFE->FE_ORDPAGO
nAliq:= SFE->FE_ALIQ  
cCert := SFE->FE_NROCERT

	
While SFE->(!EOF() ).and. (xFilial("SFE")+aCertImp[1]+aCertImp[2]) ==(SFE->FE_FILIAL+SFE->FE_NROCERT+SFE->FE_TIPO)
	if cFornece == SFE->FE_FORNECE .AND. cLoja == SFE->FE_LOJA
		nTotRet += SFE->FE_RETENC 
		Aadd(aRets,{SFE->FE_NFISCAL,SFE->FE_SERIE,SFE->FE_RETENC, SFE->FE_PARCELA, "", 0,0})	
	endif
	SFE->(DBSKIP())
EndDo    


DbSelectArea("SEK")
DbSetOrder(1)
DbSeek(xFilial("SEK")+cNumOp)
While SEK->(!EOF() ).and. (xFilial("SEK")+ cFornece+cLoja) == (SEK->EK_FILIAL+SEK->EK_FORNECE+SEK->EK_LOJA)
	If SEK->EK_TIPODOC == "CP"
		nValOP := SEK->EK_VALOR 
	ElseIF 	SEK->EK_TIPODOC $ "TB|PA"	
       nPos:=AScan(aRets,{|x| x[1]== SEK->EK_NUM .And. x[2]==SEK->EK_PREFIXO .And. x[4]==SEK->EK_PARCELA})

       If nPos > 0
	       aRets[nPos][5]:= SEK->EK_TIPO //Aadd(aRets[nPos],SEK->EK_TIPO)	
	   ElseIf SEK->EK_TIPODOC $ "PA"	    
	       aRets[1][5]:= SEK->EK_TIPO //Aadd(aRets[1],SEK->EK_TIPO)	
	   EndIf    
	EndIf
	SEK->(DBSKIP())
EndDo  

If !lIncPa     
For nX:=1 to Len(aRets)		
If aRets[nX][5] $ MV_CPNEG+"/"+MVPAGANT
	DbSelectArea("SF2")
	DbSetOrder(1)
	If DbSeek(xFilial("SF2")+aRets[nX][1]+aRets[nX][2]+cFornece+cLoja/*+aRets[nX][5]*/)
		nValMerc:= SF2->F2_VALMERC
		nValImp:= SF2->F2_VALIMP1+SF2->F2_VALIMP2+SF2->F2_VALIMP3+SF2->F2_VALIMP4+SF2->F2_VALIMP5	
	Else
		aRets[nx][6]:= 0 //aAdd(aRets[nX],0)
		aRets[nx][7]:= 0 //aAdd(aRets[nX],0)	
	EndIf
Else
	DbSelectArea("SF1")
	DbSetOrder(1)
	If DbSeek(xFilial("SF1")+aRets[nX][1]+aRets[nX][2]+cFornece+cLoja/*+aRets[nX][5]*/)
		nValMerc:= SF1->F1_VALMERC
		nValImp:= SF1->F1_VALIMP1+SF1->F1_VALIMP2+SF1->F1_VALIMP3+SF1->F1_VALIMP4+SF1->F1_VALIMP5	
		nPos:=AScan(aRets,{|x| x[1]== SF1->F1_DOC .And. x[2]==SF1->F1_SERIE .And. x[4]==aRets[nX][4]})
		aRets[nPos][6] := nValMerc //Aadd(aRets[nPos],nValMerc)
		aRets[nPos][7] := nValImp //Aadd(aRets[nPos],nValImp)
	Else
		aRets[nx][6]:= 0 //aAdd(aRets[nX],0)
		aRets[nx][7]:= 0 //aAdd(aRets[nX],0)	
	EndIf
EndIF
	Next nX
EndIf	

If aCertImp[2] == "S"
	DbSelectArea("SFF")
	DbSetOrder(2)
	DbSeek(xFilial("SFF")+SFE->FE_CONCEPT)
	cDescCon := SFF->FF_CONCEPT
ElseIf aCertImp[2] == "I"
	SFF->(DbSetOrder(5))
	SFF->(DbSeek(xFilial("SFF")+"IVR"+SFE->FE_CFO))
	If  !lIncPa  
		While SFF->(!EOF() ).and. (xFilial("SFF")+"IVR") ==(SFF->FF_FILIAL+SFF->FF_IMPOSTO) .And.  !lExiste
			If Alltrim(aRets[1][2]) == Alltrim(SFF->FF_SERIENF)
				lExiste:=.T.
				cDescCon := Alltrim(SFF->FF_CONCEPT)
				nAliq:= SFF->FF_ALIQ 
			Else
				SFF->(DbSkip())
			EndIf
		EndDO
	Else
		cDescCon := Alltrim(SFF->FF_CONCEPT)
		nAliq:= SFF->FF_ALIQ 
	EndIf		
EndIf



PrintPag( oPrint,cFornece,cLoja,dEmisCert,cNumOp,nAliq,cCert,nTotRet,nValOP,aRets,cCodAss,cDescCon,cImposto,lIncPa)//, aNfs,cCert,cSerieC )
oPrint:Preview()
EndIf	

Return
              

Static Function PrintPag( oPrint,cFornece,cLoja,dEmisCert,cNumOp,nAliq,cCert,nTotRet,nValOP,aRets,cCodAss,cDescCon,cImposto,lIncPa)// , aNfs,cCert,cSerieC)

Local cStartPath:= GetSrvProfString("StartPath","")
Local cTitCabec 	:= Iif(cImposto=="S",STR0003,STR0004)

Local oFont1		:= TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)// Fonte o Titulo Negrito
Local oFont2		:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)// Fonte do Sub-Titulo
Local nI			:= 0
//Alterado por Fernando Radu Muscalu em 07/10/2011
//diminuido o tamanho da fonte para não cortar os dados do relatorio
oFont1 := TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
oFont2 := TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)

cObserv:=STR0024 + " " + MesExtenso(Month(dEmisCert)) + " "+STR0025+" "+ Alltrim(Str(Year(dEmisCert)))
SX5->(DbSeek(xFilial()+"12"+SM0->M0_ESTENT))
cProvEmp:=Alltrim(X5Descri())

oPrint:StartPage()

oPrint:Box(0150,0100,0450,0750)  // caixa 1 Empresas
oPrint:Box(0150,0750,0450,1800)  // caixa 2 Cabeçalho
oPrint:Box(0150,1800,0450,2400)  // caixa 3 Emissao e certificado

oPrint:Say(0170,0140,SM0->M0_NOMECOM,oFont1)
oPrint:Say(0220,0140,SM0->M0_ENDENT,oFont1)
oPrint:Say(0280,0140,cProvEmp,oFont1)
oPrint:Say(0330,0140,transf(SM0->M0_CGC,pesqpict("SA2","A2_CGC")),oFont1)


oPrint:Say(0250,0825,cTitCabec,oFont1)


oPrint:Say(0180,1840,STR0005,oFont1)// Data de emissão 
oPrint:Say(0180,1995,Dtoc(dEmisCert),oFont1)// Data de emissão 

oPrint:Say(0230,1840,STR0006,oFont1)// Numero do certificado 
oPrint:Say(0230,2025,cCert,oFont1)// Numero do certificado

	


// Dados do Fornecedor

oPrint:box(0450,0100,0750,2400) 

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2") + cFornece+cLoja)  
cNome:=SA2->A2_NOME
cCUITForn:=Transf(SA2->A2_CGC,pesqpict("SA2","A2_CGC")) // Numero CUIT do fornecedor
cEnd := SA2->A2_END

SX5->(DbSeek(xFilial()+"12"+SA2->A2_EST))
cProvForn:=Alltrim(X5Descri())


oPrint:Say(0500,0150,STR0007,oFont2)  
oPrint:Say(0560,0150,STR0008,oFont2)
oPrint:Say(0620,0150,STR0009,oFont2) 
oPrint:Say(0680,0150,STR0010,oFont2) 
							
oPrint:Say(0500,0350,cNome,oFont2)  
oPrint:Say(0560,0350,cEnd,oFont2) 
oPrint:Say(0620,0350,cProvForn,oFont2) 
oPrint:Say(0680,0350,cCUITForn,oFont2)

  		


oPrint:Say(0780,0140,STR0011,oFont2) // Ordem de pago
oPrint:box(0750,0100,0845,0450) // Ordem de pago 	

oPrint:Say(0780,0490,STR0012,oFont2) // Tot. Ordem Pago
oPrint:box(0750,0450,0845,0800)// Tot. Ordem Pago
                                    
oPrint:Say(0780,0829,STR0013,oFont2) // Base Imponible
oPrint:box(0750,0800,0845,1090) // Base Imponible	                                    
                                    
oPrint:Say(0780,1115,STR0014,oFont2) // Retençaõ Mes
oPrint:box(0750,1090,0845,1400) // ret mes	                                            

oPrint:Say(0780,1480,STR0015,oFont2) // Diferença de retenção
oPrint:box(0750,1400,0845,2400) // Diferença de retenção                                       


oPrint:box(0845,0100,0947,0450) 
oPrint:Say(0875,0120,cNumOp,oFont2) // Ordem de pagp 	

oPrint:box(0845,0450,0947,0800) 	
oPrint:Say(0875,0470,Transform(nValOp, "@E 999,999,999.99"),oFont2) // Ordem de pagp 	
	

oPrint:box(0845,0800,0947,1090)                                                            
oPrint:Say(0875,0820,Transform(nAliq, "@E 999")+"%",oFont2)  //Aliquota		

oPrint:box(0845,1090,0947,1400) 
oPrint:Say(0875,1100,Transform(nTotRet, "@E 999,999,999.99"),oFont2)  //Valor retenção		

oPrint:box(0845,1400,0947,2400)                             

oPrint:Say(0875,1420,SubStr(cDescCon,1,60),oFont2)  //Conceito			
                               
oPrint:Say(0960,0115,STR0016,oFont2) 
oPrint:box(0947,0100,1020,2400)

oPrint:Say(1035,0115,STR0017,oFont2) 
oPrint:box(1020,0100,1105,0300)

oPrint:Say(1035,0315,STR0018,oFont2) 
oPrint:box(1020,0300,1105,0950)

oPrint:Say(1035,0965,STR0019,oFont2) 
oPrint:box(1020,0950,1105,1300)            
                                           
oPrint:Say(1035,1315,STR0020,oFont2) 
oPrint:box(1020,1300,1105,1650)


oPrint:Say(1035,1665,STR0021,oFont2) 
oPrint:box(1020,1650,1105,2050)

oPrint:Say(1035,2065,STR0022,oFont2) 
oPrint:box(1020,2050,1105,2400)



nLin:=1105
If !lIncPa
For nI:= 1 To Len(aRets)

	oPrint:box(nLin,0100,nLin+69,0300) // Tipo Doc						
 	oPrint:box(nLin,0300,nLin+69,0950) // numero e serie
 	oPrint:box(nLin,0950,nLin+69,1300)  // emissao
 	oPrint:box(nLin,1300,nLin+69,1650)  //base
 	oPrint:box(nLin,1650,nLin+69,2050) //aliq
 	oPrint:box(nLin,2050,nLin+69,2400)  //percepcao

	oPrint:Say( nLin+10,0125,aRets[nI,5],oFont2) // Serie
	oPrint:Say( nLin+10,0315,aRets[nI,2],oFont2) // Numero da nota fiscal 
	oPrint:Say( nLin+10,0390,aRets[nI,1],oFont2) // Data emissão NF
	oPrint:Say( nLin+10,1000,aRets[nI,4],oFont2) // Data emissão NF
	oPrint:Say( nLin+10,1315,Transform(aRets[nI,6],"@E 999,999,999.99"),oFont2)	// aliquota
	oPrint:Say( nLin+10,1665,Transform(aRets[nI,7], "@E 999,999,999.99"),oFont2) // valor da percepção
	oPrint:Say( nLin+10,2065,Transform((aRets[nI,3]), "@E 999,999,999.99"),oFont2)   // Total recebido

    nLin+=69
Next
EndIf		
	       
oPrint:box(nLin,0100,nLin+200,2400) 
oPrint:Say( nLin+20,125,cObserv,oFont2) 
oPrint:box(nLin+200,0100,nLin+650,2400)  
  
DbSelectArea("FIZ")
DbSetOrder(1)
DbSeek(xFilial("FIZ")+cCodAss)

oPrint:Say( nLin+265,0120,FIZ->FIZ_NOME,oFont2) //Baixado"	
oPrint:Say( nLin+310,0120,FIZ->FIZ_CARGO,oFont2) //Baixado"		


oPrint:SayBitmap(nLin+290,1600,cStartPath + AllTrim(FIZ->FIZ_BITMAP)+ ".JPG") // Ordem de pagp 		

oPrint:Line(nLin+410,1600,nLin+410,2230)
oPrint:Say( nLin+430,1850,STR0023,oFont2) //Assinatura
oPrint:EndPage()			

Return
