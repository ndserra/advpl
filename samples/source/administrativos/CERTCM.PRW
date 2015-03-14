#INCLUDE "CERTCM.ch"      
#INCLUDE "Protheus.ch"      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CERTCM    ºAutor  ³ Marivaldo			 º Data ³  27/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Certificado de Caja Medica       					 	   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CERTCM(aCertImp,cCodAss,lIncPa)
Local aNfs	:= {}
Local cChave
Local cTitulo	:= STR0001
Local oPrint  
Local aDados := {}      
Local lExiste := .F.
Local nValRet := 0 
Local nTotRet := 0
Local nTotNot := 0 
Local aRets := {} 
Local aRetSe2:= {}  
Local nX := 0
Local cImposto:=aCertImp[2] 
Local nValMerc := 0
Local nValImp := 0  
Local cFornece:=""
Local cLoja:=""
Local dEmisCert
Local cCert := ""
Local cAliq:= ""
Local cNumOp:= ""
Local cDescCon := ""
Local cConceito := ""
Local nValOP := 0
Local nBsImpo:= 0
Local nRetMes := 0
Local nRetAnt:= 0

Default lIncPa := .F.

oPrint	:= TMSPrinter():New( cTitulo )
oPrint:SetPortrait() //Retrato
//oPrint:SetLandscape() //Paisagem


DbSelectArea("SFE")
DbSetOrder(9)
DbSeek(xFilial("SFE")+aCertImp[1]+aCertImp[2])
cFornece:=SFE->FE_FORNECE
cLoja:=SFE->FE_LOJA
dEmisCert:=SFE->FE_EMISSAO 
cNumOp:= SFE->FE_ORDPAGO
nAliq:= SFE->FE_ALIQ  
cCert := SFE->FE_NROCERT 
nValBase:= SFE->FE_VALBASE
SX5->(DbSeek(xFilial()+"12"+SFE->FE_EST))
cJurid:=Alltrim(X5Descri())

	
While SFE->(!EOF() ).and. (xFilial("SFE")+aCertImp[1]+SubStr(aCertImp[2],1,1)) ==(SFE->FE_FILIAL+SFE->FE_NROCERT+SFE->FE_TIPO)
	nTotRet += SFE->FE_RETENC
   //	nTotNot += SE2->E2_VALOR 
	Aadd(aRets,{nTotRet,SFE->FE_VALBASE})	
	SFE->(DBSKIP())
EndDo 

DbSelectArea("SE2")
DbSetOrder(8)
DbSeek(xFilial("SE2")+SEK->EK_ORDPAGO)
While SE2->(!EOF() ).and. (xFilial("SE2")+SE2->E2_ORDPAGO ==SEK->EK_FILIAL+SEK->EK_ORDPAGO)
	nTotNot += SE2->E2_VALOR 
	Aadd(aRetSe2,{SE2->E2_VALOR ,SE2->E2_TIPO,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA})	
	SE2->(DBSKIP())
EndDo	

DbSelectArea("SEK")
DbSetOrder(1)
DbSeek(xFilial("SEK")+cNumOp)
While SEK->(!EOF() ).and. (xFilial("SEK")+ cFornece+cLoja) == (SEK->EK_FILIAL+SEK->EK_FORNECE+SEK->EK_LOJA)
	If SEK->EK_TIPODOC == "CP"
		nValOP := SEK->EK_VALOR 
	ElseIF 	SEK->EK_TIPODOC $ "TB|PA"	
       nPos:=AScan(aRetSe2,{|x| x[4]== SEK->EK_NUM .And. x[3]==SEK->EK_PREFIXO .And. x[5]==SEK->EK_PARCELA})

       If nPos > 0
	       Aadd(aRetSe2[nPos],SEK->EK_TIPO)	
	   ElseIf SEK->EK_TIPODOC $ "PA"	    
  	       Aadd(aRetSe2[1],SEK->EK_TIPO)	
	   EndIf    
	EndIf
	SEK->(DBSKIP())
EndDo  

If !lIncPa     
	For nX:=1 to Len(aRetSe2)		
		IF aRetSe2[nX][2] $ MV_CPNEG+"/"+MVPAGANT
			DbSelectArea("SF2")
			DbSetOrder(1)
			DbSeek(xFilial("SF2")+aRetSe2[nX][4]+aRetSe2[nX][3]+cFornece+cLoja)
			nValMerc:= SF2->F2_VALMERC
			nValImp:= SF2->F2_VALIMP1+SF2->F2_VALIMP2+SF2->F2_VALIMP3+SF2->F2_VALIMP4+SF2->F2_VALIMP5	
		Else
			DbSelectArea("SF1")                                                                                  
			DbSetOrder(1)
			DbSeek(xFilial("SF1")+aRetSe2[nX][4]+aRetSe2[nX][3]+cFornece+cLoja)
			nValMerc:= SF1->F1_VALMERC
			nValImp:= SF1->F1_VALIMP1+SF1->F1_VALIMP2+SF1->F1_VALIMP3+SF1->F1_VALIMP4+SF1->F1_VALIMP5	
			nPos:=AScan(aRetSe2,{|x| x[4]== SF1->F1_DOC .And. x[3]==SF1->F1_SERIE })
			Aadd(aRetSe2[nPos],nValMerc)
			Aadd(aRetSe2[nPos],nValImp)
		EndIF
	Next nX
EndIf	

                                                                                                  

SFF->(dbSetOrder(5))
SFF->(dbSeek(xFilial()+"IBR" +SFE->FE_CFO+cJurid))
cDescCon := SFF->FF_CONCEPT



PrintPag( oPrint,cFornece,cLoja,dEmisCert,cNumOp,nAliq,cCert,nTotRet,nValOP,aRetSe2,cCodAss,cDescCon,cImposto,lIncPa,nValBase,nTotNot)//, aNfs,cCert,cSerieC )
oPrint:Preview()


Return

Static Function PrintPag( oPrint,cFornece,cLoja,dEmisCert,cNumOp,nAliq,cCert,nTotRet,nValOP,aRetSe2,cCodAss,cDescCon,cImposto,lIncPa,nValBase,nTotNot)// , aNfs,cCert,cSerieC)


Local oFont1	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)// Fonte o Titulo Negrito
Local oFont2	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)// Fonte do Sub-Titulo
Local nI
Local cStartPath := GetSrvProfString( "Startpath", "" )
               


cTitCabec1 := STR0002
cTitCabec2:= STR0025

cObserv:=STR0028 + " " + MesExtenso(Month(dEmisCert)) + " "+STR0029 +" "+ Alltrim(Str(Year(dEmisCert)))
SX5->(DbSeek(xFilial()+"12"+SM0->M0_ESTENT))
cProvEmp:=Alltrim(X5Descri())

oPrint:StartPage()

oPrint:Box(0150,0100,0400,2400)  
oPrint:Say(0180,0950,cTitCabec1,oFont1)// Tit. Cabeçalho
oPrint:Say(0230,0975,cTitCabec2,oFont1)// Tit. Cabeçalho
oPrint:Say(0350,1000,STR0003,oFont1)
oPrint:Say(0350,1190,cJurid,oFont1)

//oPrint:Say(0180,1840,"Emissão:",oFont1)// Data de emissão 
oPrint:Say(0180,1995,Dtoc(dEmisCert),oFont1)// Data de emissão 
oPrint:Say(0230,2025,cCert,oFont1)// Numero do certificado  

oPrint:box(0400,0100,0650,2400) // Dados do agente retentor

oPrint:Say(0415,0130,STR0004,oFont1)

oPrint:Say(0480,0130,STR0005,oFont2) 
oPrint:Say(0480,0320,transf(SM0->M0_CGC,pesqpict("SA2","A2_CGC")),oFont2)

oPrint:Say(0530,0130,STR0006,oFont2) 
oPrint:Say(0530,0420,SM0->M0_NOMECOM,oFont2)
                                             
oPrint:Say(0580,0130,STR0007,oFont2) 
oPrint:Say(0580,0320,SM0->M0_ENDENT,oFont2)

oPrint:Say(0415,1050,STR0008,oFont2) 
oPrint:Say(0415,1340,cProvEmp,oFont1)

// Dados do Fornecedor

oPrint:box(0650,0100,0940,2400) 

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2") + cFornece+cLoja)  
cNome:=SA2->A2_NOME
cCUITForn:=Transf(SA2->A2_CGC,pesqpict("SA2","A2_CGC")) // Numero CUIT do cliente 
cEnd := SA2->A2_END  
nNumIb := SA2->A2_NROIB

SX5->(DbSeek(xFilial()+"12"+SA2->A2_EST))
cProvForn:=Alltrim(X5Descri())

/*
Box(nRow,nCol,nBottom,nRight,oPen)
Desenha uma caixa, utilizando as especificações do objeto TPen
nRow		Linha no qual inicia o desenho da caixa
nCol		Coluna no qual inicia o desenho da caixa
nBottom	Linha no qual finaliza o desenho da caixa
nRight		Coluna no qual finaliza o desenho da caixa
*/
                                            
oPrint:Say(0665,0130,STR0009,oFont1)  
oPrint:Say(0725,0130,STR0010,oFont2)  
oPrint:Say(0725,0350,cNome,oFont2)  

oPrint:Say(0775,0130,STR0011,oFont2)
oPrint:Say(0775,0350,cEnd,oFont2) 

oPrint:Say(0825,0130,STR0012,oFont2) 
oPrint:Say(0825,0350,cProvForn,oFont2) 

oPrint:Say(0880,0130,STR0005,oFont2) 
oPrint:Say(0880,0350,cCUITForn,oFont2)
   

oPrint:Say(0880,1250,STR0013,oFont2) 
oPrint:Say(0880,1560,nNumIb,oFont2)
  		


oPrint:Say(0955,0140,STR0014,oFont2) // Ordem de pago
oPrint:box(0940,0100,1020,0450) // Ordem de pago 	

oPrint:Say(0955,0490,STR0015,oFont2) // Tot. Ordem Pago
oPrint:box(0940,0450,1020,0900)// Tot. Ordem Pago
                                    
oPrint:Say(0955,0920,STR0021,oFont2) // Base Imponible
oPrint:box(0940,0900,1020,1190) // Base Imponible	                                    
                                    
oPrint:Say(0955,1220,STR0026,oFont2) // Retençaõ Mes
oPrint:box(0940,1190,1020,1500) // ret mes	                                            

oPrint:Say(0955,1530,STR0016,oFont2) // Diferença de retenção
oPrint:box(0940,1500,1020,2400) // Diferença de retenção                                       


oPrint:box(1020,0100,1110,0450) 
oPrint:Say(1035,0120,cNumOp,oFont2) // Ordem de pagp 	

oPrint:box(1020,0450,1110,0900) 	
oPrint:Say(1035,0460,Transform(nValOp, "@E 999,999,999.99"),oFont2) // Ordem de pagp 	
	

oPrint:box(1020,0900,1110,1190)                                                            
oPrint:Say(1035,0940,Transform(nTotNot, "@E 999,999,999.99"),oFont2)  //Conceito			

oPrint:box(1020,1190,1110,1500) 
oPrint:Say(1035,1185,Transform(nAliq, "@E 999.99")+"%",oFont2)  //Conceito		

oPrint:box(1020,1500,1110,2400)  
oPrint:Say(1035,1440,Transform(nTotRet, "@E 999,999,999.99"),oFont2)  //Conceito			
                               
oPrint:box(1110,0100,1200,2400)
oPrint:Say(1125,0115,STR0027,oFont1) // "Referencia



oPrint:Say(1215,0115,STR0018,oFont2) // Tipo
oPrint:box(1200,0100,1280,0300)

oPrint:Say(1215,0315,STR0019,oFont2) // Tipo
oPrint:box(1200,0300,1280,0950)

oPrint:Say(1215,0965,STR0020,oFont2) // Tipo
oPrint:box(1200,0950,1280,1300)            
                                           
oPrint:Say(1215,1315,STR0021,oFont2) // Tipo
oPrint:box(1200,1300,1280,1650)


//oPrint:Say(1215,1665,STR0022,oFont2) // Tipo
oPrint:box(1200,1650,1280,2050)

//oPrint:Say(1215,2065,STR0023,oFont2) // Tipo
oPrint:box(1200,2050,1280,2400)


nLin:=1280
If !lIncPa
For nI:= 1 To Len(aRetSe2)

	oPrint:box(nLin,0100,nLin+69,0300) // Tipo Doc						
 	oPrint:box(nLin,0300,nLin+69,0950) // numero e serie
 	oPrint:box(nLin,0950,nLin+69,1300)  // emissao
 	oPrint:box(nLin,1300,nLin+69,1650)  //base
 	oPrint:box(nLin,1650,nLin+69,2050) //aliq
 	oPrint:box(nLin,2050,nLin+69,2400)  //percepcao

	oPrint:Say( nLin+10,0125,aRetSe2[nI,2],oFont2) // Serie
	oPrint:Say( nLin+10,0315,aRetSe2[nI,3],oFont2) // Numero da nota fiscal 
	oPrint:Say( nLin+10,0390,aRetSe2[nI,4],oFont2) // Data emissão NF
	oPrint:Say( nLin+10,1000,aRetSe2[nI,5],oFont2) // Data emissão NF
	oPrint:Say( nLin+10,1315,Transform(aRetSe2[nI,7],"@E 999,999,999.99"),oFont2)	//Valor do Imposto

    nLin+=69
Next
EndIf		
	       
oPrint:box(nLin,0100,nLin+200,2400) 
oPrint:Say( nLin+20,125,cObserv,oFont2) 
oPrint:box(nLin+200,0100,nLin+650,2400)  
                                                                                                     
DbSelectArea("FIZ")
DbSetOrder(1)
DbSeek(xFilial("FIZ")+cCodAss)

oPrint:Say( nLin+265,0120,FIZ->FIZ_NOME,oFont2) 
oPrint:Say( nLin+310,0120,FIZ->FIZ_CARGO,oFont2) 		


oPrint:SayBitmap(nLin+290,1600,cStartPath + AllTrim(FIZ->FIZ_BITMAP)+ ".JPG") // imagem da assinatura	

oPrint:Line(nLin+410,1600,nLin+410,2230)
oPrint:Say( nLin+430,1850,STR0024,oFont2)
oPrint:EndPage()			

Return
