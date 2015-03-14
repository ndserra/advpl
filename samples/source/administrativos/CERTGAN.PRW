#INCLUDE "CERTGAN.ch"      
#INCLUDE "Protheus.ch"      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  CERTGAN   ºAutor  ³ Ana Paula Nascimento º Data ³ 26/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Certificado de Ganancias									   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CERTGAN(aCertImp,cCodAss)
Local cTitulo	:= STR0001
Local oPrint  
Local aDados := {}
Local nValOP := 0

oPrint	:= TMSPrinter():New( cTitulo )
oPrint:SetPortrait() //Retrato
//oPrint:SetLandscape() //Paisagem


DbSelectArea("SFE")
DbSetOrder(9)
DbSeek(xFilial("SFE")+aCertImp[1]+"G")
cFornece:=SFE->FE_FORNECE
cLoja:=SFE->FE_LOJA
dEmisCert:=SFE->FE_EMISSAO 
nValRet := SFE->FE_RETENC
cCert := SFE->FE_NROCERT
cAliq:= SFE->FE_ALIQ 
cNumOp:= SFE->FE_ORDPAGO


DbSelectArea("SFF")
DbSetOrder(2)
DbSeek(xFilial("SFF")+SFE->FE_CONCEPT)
cDescCon := SFF->FF_CONCEPT
cConceito := SFF->FF_ITEM

DbSelectArea("SEK")
DbSetOrder(1)
DbSeek(xFilial("SEK")+cNumOp+"CP")

While !SEK->(Eof()) .And. xFilial("SEK")+cNumOp+"CP" == SEK->(EK_FILIAL+EK_ORDPAGO+EK_TIPODOC)
	nValOP += SEK->EK_VALOR   
	SEK->(dbSkip())
EndDo

cDataIni :=	Str(Year(dDataBase),4)+StrZero(Month(dDataBase),2)+"01"

cQuery := " SELECT  SUM(FE_VALBASE) FE_BASIMPO, SUM(FE_RETENC) FE_RETMES  FROM " + RetSqlName("SFE")
cQuery += " WHERE "
cQuery += " FE_FORNECE = '"+cFornece+"' AND "
cQuery += " FE_TIPO = '"+"G"+"' AND "
cQuery += " FE_CONCEPT = '"+cConceito+"' AND "
cQuery += " FE_EMISSAO BETWEEN '"+cDataIni+"' AND '"+DTos(dDataBase)+"' AND "	
cQuery += " D_E_L_E_T_ = ' ' "
cQuery 	:= 	ChangeQuery(cQuery)                    
cAlias	:=	GetNextAlias()
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

nBsImpo:= FE_BASIMPO
nRetMes := FE_RETMES
nRetAnt:= nRetMes - nValRet        


DbCloseArea()

Aadd(aDados,{cFornece,cLoja,cCert,dEmisCert,nValRet,nBsImpo,nRetMes,nRetAnt,cDescCon,cAliq,nValOP,cNumOp})
 

PrintPag( oPrint,aDados,cCodAss )
oPrint:Preview()


Return

Static Function PrintPag( oPrint ,aDados,cCodAss)

Local oFont1		//:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)// Fonte o Titulo Negrito
Local oFont2		//:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)// Fonte do Sub-Titulo
Local cStartPath 	:= GetSrvProfString( "Startpath", "" ) 
Local cTitCabec1 	:= STR0002 
Local cTitCabec2 	:= STR0003 
Local cTitCabec3 	:= STR0004

cObserv:=STR0020 + " " + MesExtenso(Month(dEmisCert)) + " "+STR0021+" "+ Alltrim(Str(Year(dEmisCert)))
SX5->(DbSeek(xFilial()+"12"+SM0->M0_ESTENT))
cProvEmp:=Alltrim(X5Descri())


oFont1 := TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)// Fonte o Titulo Negrito
oFont2 := TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)// Fonte do Sub-Titulo


oPrint:StartPage()

//Cabeçalho
oPrint:Box(0150,0100,0450,0750)  
oPrint:Box(0150,0750,0450,1800)  
oPrint:Box(0150,1800,0450,2400)  

oPrint:Say(0180,0990,cTitCabec1,oFont1)
oPrint:Say(0255,1110,cTitCabec2,oFont1)
oPrint:Say(0315,1100,cTitCabec3,oFont1)

oPrint:Say(0170,0140,SM0->M0_NOMECOM,oFont1)
oPrint:Say(0225,0140,SM0->M0_ENDENT,oFont1)
oPrint:Say(0305,0140,cProvEmp,oFont1)// Provincia d aempresa do Protheus
oPrint:Say(0380,0140,transf(SM0->M0_CGC,pesqpict("SA2","A2_CGC")),oFont1) //CUIT da empresa do Protheus
oPrint:Say(0180,1840,STR0005,oFont1)
oPrint:Say(0180,1995,Dtoc(aDados[1][4]),oFont1)// Data de emissão 
oPrint:Say(0230,1840,STR0006,oFont1)
oPrint:Say(0230,2025,aDados[1][3],oFont1)// Numero do certificado
	


// Dados do Fornecedor

oPrint:box(0450,0100,0750,2400) 

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2") + aDados[1][1] + aDados[1][2])  
cNome:=SA2->A2_NOME
cCUITForn:=Transf(SA2->A2_CGC,pesqpict("SA2","A2_CGC")) // Numero CUIT
cEnd := SA2->A2_END

SX5->(DbSeek(xFilial()+"12"+SA2->A2_EST))
cProvForn:=Alltrim(X5Descri())


oPrint:Say(0500,0150,STR0007,oFont2)  // Fornecedor
oPrint:Say(0500,0350,cNome,oFont2)  

oPrint:Say(0560,0150,STR0008,oFont2)	// Endereço
oPrint:Say(0560,0350,cEnd,oFont2) 

oPrint:Say(0620,0150,STR0009,oFont2)   // Provincia
oPrint:Say(0620,0350,cProvForn,oFont2) 

oPrint:Say(0680,0150,STR0010,oFont2)   // CUIT do Fornecedor
oPrint:Say(0680,0350,cCUITForn,oFont2)								

oPrint:box(0750,0100,1750,2400) 


oPrint:Say(0775,0150,STR0019,oFont2) // Conceito									
oPrint:Say(0775,0350,SubStr(aDados[1][9],1,100),oFont2)  //Conceito


oPrint:Say(0848,0140,STR0011,oFont2) // Ordem de pago
oPrint:box(0830,0100,0910,0450) // Ordem de pago 	

oPrint:Say(0848,0490,STR0012,oFont2) // Tot. Ordem Pago
oPrint:box(0830,0450,0910,0800)// Tot. Ordem Pago
                                    
oPrint:Say(0848,0829,STR0013,oFont2) // BAse Imponible
oPrint:box(0830,0800,0910,1050) // BAse Imponible	                                    
                                    
oPrint:Say(0848,1105,STR0014,oFont2) // Retençaõ Mes
oPrint:box(0830,1050,0910,1400) // ret mes	                                            

oPrint:Say(0848,1510,STR0015,oFont2) // Diferença de retenção
oPrint:box(0830,1400,0910,1800) // Diferença de retenção                                       

oPrint:Say(0848,1875,STR0016,oFont2) // Aliq									
oPrint:box(0830,1800,0910,2100) // aliq

oPrint:Say(0848,2160,STR0017,oFont2) // Retenção
oPrint:box(0830,2100,0910,2400) // Retenção

oPrint:box(0910,0100,0990,0450) 
oPrint:Say(0930,0120,aDados[1][12],oFont2) // Ordem de pagp 	

oPrint:box(0910,0450,0990,0800) 	
oPrint:Say(0930,0470,Transform(aDados[1][11], "@E 999,999,999.99"),oFont2) // Ordem de pagp 	

oPrint:box(0910,0800,0990,1050) // base impo	
oPrint:Say(0930,0820,Transform(aDados[1][6], "@E 999,999,999.99"),oFont2)	

oPrint:box(0910,1050,0990,1400)                                                             
oPrint:Say(0930,1070,Transform(aDados[1][7], "@E 999,999,999.99"),oFont2)  //ret mes		

oPrint:box(0910,1400,0990,1800) 
oPrint:Say(0930,1420,Transform(aDados[1][8], "@E 999,999,999.99"),oFont2)  //Dif. Retenção

oPrint:box(0910,1800,0990,2100) 
oPrint:Say(0930,1830,Transform(aDados[1][10], "@E 999")+"%",oFont2)  //Aliquota

oPrint:box(0910,2100,0990,2400)
oPrint:Say(0930,2120,Transform(aDados[1][5], "@E 999,999,999.99"),oFont2)  //Valor retenção


oPrint:Say( 1030,120,cObserv,oFont2) 
oPrint:Line(1230,0100,1230,2400)

DbSelectArea("FIZ")
DbSetOrder(1)
DbSeek(xFilial("FIZ")+cCodAss)

oPrint:Say( 1300,0120,FIZ->FIZ_NOME,oFont2) //Nome do assinante
oPrint:Say( 1350,0120,FIZ->FIZ_CARGO,oFont2) // Cargo do assinante


oPrint:SayBitmap(1410,1600,cStartPath + AllTrim(FIZ->FIZ_BITMAP)+ ".JPG") // Imagem da assinatura

oPrint:Line(1480,1600,1480,2230)
oPrint:Say( 1510,1850,STR0018,oFont2) 
			
oPrint:EndPage()

Return
