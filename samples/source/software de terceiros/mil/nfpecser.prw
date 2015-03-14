/*                                             
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ NFPECSER ³ Autor ³ Andr‚                 ³ Data ³ 17/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rdmake Emissao da Nota Fiscal de Pecas e Servicos - AUDI   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function NFPECSER()

SetPrvt("wnrel,cString,aRegistros,cDesc1,cDesc2,cDesc3,cAlias,aRegistros,cNomeImp")
SetPrvt("nLin,aPag,aReturn,cTamanho,Limite,lServer,cDrive")
SetPrvt("aOrdem,cTitulo,ctamanho,cNomProg,cNomRel,nLastKey,cSelect")

cSelect    := Alias()
cDesc1     := ""
cDesc2     := ""
cDesc3     := ""
cString    := "SD2"
cAlias     := "SD2"
aRegistros := {}
cTitulo    := OemToAnsi("Emissao da Nota Fiscal de Saida")
cTamanho   := "M"
Tamanho    := "M" 
cNomProg   := "NFPECSER"
nLastKey   := 0
cNomRel    := "NFPECSER"
nLin       := 4
aPag       := 1
nIte       := 1
limite     := 220
lServer    := GetMv("MV_LSERVER") == "S"
cDrive     := GetMv("MV_DRVNFI")
cPorta     := GetMv("MV_PORNFI")
aReturn    := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 3, cPorta, "",1 }  //"Zebrado"###"Administracao"

if ParamIXB == Nil
   PERGUNTE("OFR030")
Else
   mv_par01 := ParamIXB[1] //Nro da Nota
   mv_par02 := ParamIXB[2] //Serie
Endif

//cNomRel := SetPrint(cString,cNomRel,nil,@ctitulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
   Set Filter To
   Return
Endif

SetDefault(aReturn,cAlias)

RptStatus({|lEnd| ImprimeNF(@lEnd,cNomRel,cAlias)},cTitulo)

Set filter to                  

dbSelectArea(cSelect)

Return

Static Function ImprimeNF(lEnd,wNRel,cAlias)
************************************
Local nQtdIte := 0
Local nQtdSrv := 0
Local i, xz, lRestFiltro := .f.
Local nTamDesc:=0, cDescri:=""

Private ntrans := 0, nQtdPag :=  0
Private aIte      := {}
Private aSrv      := {}
Private aValSrv   := {}
Private aCfOp     := {}           
Private aDesc     := {}
Private nTotalSrv := 0
Private nTotalIss := 0
Private aliq      := 0
Private nDesSer   := 0
Private nDesPec   := 0
Private lIssRet   := .f.
Private lPisCof   := .f.
Private cPedido   := ""

lflagm := .t.
lflagT := .t.
SetPrvt("oPr,nX,aDriver,lVez,nValor1,aCab,nLin,aIte")
SetPrvt("cNomeEmp,cEndeEmp,cNomeCid,cEstaEmp,cCep_Emp,cFoneEmp,cCodMun")
SetPrvt("cFax_Emp,cCNPJEmp,cInscEmp,cCompac,cNormal")

aDriver := LeDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

Set Printer to &cNomRel
Set Printer On
Set Device  to Printer

dbSelectArea("SM0")
cNomeEmp := SM0->M0_NOMECOM
cEndeEmp := SM0->M0_ENDENT
cNomeCid := SM0->M0_CIDENT
cEstaEmp := "ESTADO: " + SM0->M0_ESTENT
cCep_Emp := SM0->M0_CEPENT
cFoneEmp := "FONE: " + SM0->M0_TEL
cFax_Emp := "FAX: " + SM0->M0_FAX
cCNPJEmp := SM0->M0_CGC
cInscEmp := SM0->M0_INSC
cCodMun  := SM0->M0_CODMUN 
dbSelectArea("SF2")
dbSeek(xFilial("SF2")+mv_par01+mv_par02)
  
#IFDEF TOP
	lRestFiltro := .t.
	dbSelectArea("VOO")
	RetIndex()
	dbClearFilter()
#ENDIF

dbSelectArea("VOO")
dbsetorder(4)
dbSeek(xFilial("VOO")+mv_par01+mv_par02)

aOsv := {}
Do while !eof() .and. (VOO->VOO_SERNFI + VOO->VOO_NUMNFI) = mv_par02+mv_par01
   aadd(aOsv,VOO->VOO_NUMOSV)
   dbSelectArea("VOO")
   dbskip()
Enddo
   
dbSelectArea("VV1")
dbSetOrder(1)

aPla := {}
if SF2->F2_PREFIXO <> "BAL"
	dbSelectArea("VO1")
	Set filter to
	dbSetOrder(1)
	For i = 1 to len(aOsv)
	   dbSelectArea("VO1")
	   dbSeek(xFilial("VO1")+aOsv[i])

	   dbSelectArea("VV1")
   	dbSeek(xFilial("VV1")+VO1->VO1_CHAINT)
   	
	   if ascan(aPla,VV1->VV1_PLAVEI) = 0
	      aadd(aPla,VV1->VV1_PLAVEI)
   	Endif
	Next
Else
	dbSelectArea("VS1")
	dbSetOrder(3)
  	if dbSeek(xFilial("VS1")+SF2->F2_DOC+SF2->F2_SERIE)
	   dbSelectArea("VV1")
  		dbSeek(xFilial("VV1")+VS1->VS1_CHAINT)
   	
	   if ascan(aPla,VV1->VV1_PLAVEI) = 0
   	   aadd(aPla,VV1->VV1_PLAVEI)
	  	Endif
	Endif  	
Endif	

aCab := {}
aAdd(aCab,SF2->F2_DOC  )       //1
aAdd(aCab,SF2->F2_SERIE)       //2
aAdd(aCab,SF2->F2_CLIENTE)     //3
aAdd(aCab,SF2->F2_LOJA)        //4
aAdd(aCab,SF2->F2_EMISSAO)     //5
aAdd(aCab,SF2->F2_BASEICM)     //6
aAdd(aCab,SF2->F2_VALICM)      //7
aAdd(aCab,SF2->F2_FRETE)       //8
aAdd(aCab,SF2->F2_SEGURO)      //9
aAdd(aCab,SF2->F2_VALMERC)     //10
aAdd(aCab,SF2->F2_DESCONT)     //11

dbSelectArea("SE4")
dbsetorder(1)
dbgotop()
dbSeek(xFilial("SE4")+SF2->F2_COND)

aTit  := {}
aTit1 := {}
dAnt := ctod("  /  /  ")
nRazao := 0

dbselectArea("SE1")
dbSetOrder(1)
dbgotop()
dbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DUPL)

do while !eof() .and. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM = SF2->F2_FILIAL+SF2->F2_PREFIXO+SF2->F2_DUPL
   if AllTrim(SE1->E1_TIPO) == "DP"
	   aAdd(aTit,{SE1->E1_PREFIXO+SE1->E1_NUM+"/"+SE1->E1_PARCELA,transform(SE1->E1_VALOR,"@e 999,999.99"),SE1->E1_VENCTO})
   	if SE4->E4_TIPO = "A"
	      if SE1->E1_PARCELA = "1"
   	      n_Razao := SE1->E1_VENCTO - SE1->E1_EMISSAO 
      	   d_Ant := SE1->E1_VENCTO  
	         aAdd(aTit1,strzero(n_Razao,3)) 
   	   else                                             
      	   n_Razao := SE1->E1_VENCTO - d_Ant 
         	d_Ant := SE1->E1_VENCTO       
	         aAdd(aTit1,strzero(n_Razao,3)) 
   	   endif
   	endif   
   endif
     
   dbselectArea("SE1")
   dbskip()
enddo  

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3")+SF2->F2_VEND1)

aAdd(aCab,SF2->F2_VEND1+ " - "+SA3->A3_NOME)               //12

dbSelectArea("SE4")
dbsetorder(1)
dbSeek(xFilial("SE4")+SF2->F2_COND)
if SE4->E4_TIPO # "A"
   aAdd(aCab,SF2->F2_COND+" - "+SE4->E4_DESCRI)                //13
else                               
   cDescri := ""
   for xz = 1 to len(aTit1)
      cDescri := cDescri + atit1[xz] + ","
   next                           
   cDescri := cDescri + " Dias"
   aAdd(aCab,SF2->F2_COND+" - "+cDESCRI)                //13
endif

if !SF2->F2_TIPO $ "D/B"
	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)

	aAdd(aCab,A1_NOME)                                         //14
	aAdd(aCab,A1_END)                                          //15
	aAdd(aCab,A1_BAIRRO)                                       //16
	aAdd(aCab,A1_CEP)                                          //17
	aAdd(aCab,A1_MUN)                                          //18
	aAdd(aCab,A1_TEL)                                          //19
	aAdd(aCab,A1_EST)                                          //20
	cCGCCPF1  := subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
	cCGCPro   := cCGCCPF1 + space(18-len(cCGCCPF1))
	aAdd(aCab,cCGCPro)                                          //21
	aAdd(aCab,A1_INSCR)                                        //22
Else
	dbSelectArea("SA2")
	dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)

	aAdd(aCab,A2_NOME)                                         //14
	aAdd(aCab,A2_END)                                          //15
	aAdd(aCab,A2_BAIRRO)                                       //16
	aAdd(aCab,A2_CEP)                                          //17
	aAdd(aCab,A2_MUN)                                          //18
	aAdd(aCab,substr(A2_TEL,1,15))                                          //19
	aAdd(aCab,A2_EST)                                          //20
	cCGCCPF1  := subs(transform(SA2->A2_CGC,PicPes(RetPessoa(SA2->A2_CGC))),1,at("%",transform(SA2->A2_CGC,PicPes(RetPessoa(SA2->A2_CGC))))-1)
	cCGCPro   := cCGCCPF1 + space(18-len(cCGCCPF1))
	aAdd(aCab,cCGCPro)                                          //21
	aAdd(aCab,A2_INSCR)                                        //22
Endif

dbSelectArea("VO1")
dbSetOrder(1)

dbSelectArea("SF2")
aAdd(aCab,SF2->F2_PLIQUI)                                  //23

aAdd(aCab,SF2->F2_VALIPI)                                 //24
aAdd(aCab,SF2->F2_BRICMS)                                 //25
aAdd(aCab,SF2->F2_ICMSRET)                                //26

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
While SF2->F2_DOC+SF2->F2_SERIE == D2_DOC+D2_SERIE .and. xFilial("SD2") == D2_FILIAL .and. !SD2->(EOF())
   
   cPedido := SD2->D2_PEDIDO
   
   dbSelectArea("SB1")
   dbSeek(xFilial("SB1")+SD2->D2_COD)

   dbSelectArea("SF4")
   dbSeek(xFilial("SF4")+SD2->D2_TES)
   
   if SD2->D2_TES == "502"
      lIssRet := .t.
   Endif   

   If SF4->F4_ISS == "S"

		dbSelectArea("VOO")
		dbSeek(xFilial("VOO")+SD2->D2_DOC+SD2->D2_SERIE)
		dbSelectArea("VO1")
		dbSeek(xFilial("VO1")+VOO->VOO_NUMOSV)

      //aAdd(aSrv,alltrim(SB1->B1_DESC)+"  (OS:"+VO1->VO1_NUMOSV+" Placa:"+VO1->VO1_PLAVEI+")")
      aAdd(aSrv,alltrim(SB1->B1_DESC))
      aAdd(aValSrv,"  (R$ "+transform(SD2->D2_TOTAL+SD2->D2_DESCON,"@E 9,999,999.99")+")")

      nTotalSrv := nTotalSrv+SD2->D2_TOTAL
      nTotalIss := nTotalIss + SD2->D2_VALISS
      nDesSer += SD2->D2_DESCON
      if Aliq = 0
         Aliq := SD2->D2_ALIQISS
      endif
      if ascan(aCfOp,SD2->D2_CF,) = 0
         aAdd(aCfOp,SD2->D2_CF)
         aAdd(aDesc,SF4->F4_TEXTO)
      endif       
      nQtdSrv += 1
   Else
      dbSelectArea("SB1")
      nPos := Recno()
      cDescri := SB1->B1_DESC
      if dbSeek(xFilial("SB1")+substr(SB1->B1_CODITE,1,6))
         cDescri := SB1->B1_DESC
      Endif
      dbGoto(nPos)

		if !SF2->F2_TIPO $ "D/B"
         aAdd(aIte,{SD2->D2_ITEM,SB1->B1_GRUPO+" "+SB1->B1_CODITE,cDescri,SD2->D2_UM,SD2->D2_QUANT,TRANSFORM((SD2->D2_PRUNIT+(SD2->D2_DESCON/SD2->D2_QUANT)),"@E 999,999,999.99"),SD2->D2_TOTAL+SD2->D2_DESCON,Transform(SD2->D2_PICM,"@E 999.99" ),SB1->B1_ORIGEM})
      else
         aAdd(aIte,{SD2->D2_ITEM,SB1->B1_GRUPO+" "+SB1->B1_CODITE,cDescri,SD2->D2_UM,SD2->D2_QUANT,TRANSFORM(SD2->D2_PRUNIT,"@E 999,999,999.99"),SD2->D2_PRUNIT*SD2->D2_QUANT,Transform(SD2->D2_PICM,"@E 999.99" ),SB1->B1_ORIGEM})
      Endif   

      nDesPec += SD2->D2_DESCON
      if ascan(aCfOp,SD2->D2_CF,) = 0
         aAdd(aCfOp,SD2->D2_CF)
         aAdd(aDesc,SF4->F4_TEXTO)
      endif
      nQtdIte += 1
   Endif

   dbSelectArea("SD2")
   dbSkip()

Enddo

nQtdPag := nQtdIte / 21
nQtdPgs := nQtdSrv / 18

If nQtdPag > Int(nQtdPag)
   nQtdPag := Int(nQtdPag) + 1
Else
   nQtdpag := int(nqtdpag)
Endif

If nQtdIte == 16 
   nQtdPag := 1
Endif

If nQtdPgs > Int(nQtdPgs)
   nQtdPgs := Int(nQtdPgs) + 1
Else
   nQtdpgs := int(nqtdpgs)
Endif

@ 00, 001 pSay CHR(27)+	"0"

FS_CABEC()
FS_DETALHE()  

nLin := 46
lVez := .f.
nCol := 1

For i:=1 to Len(aSrv)

    if aPag > 1 .and. len(aSrv) > 18
       i:= 19
    endif  

    if ( nCol + Len(aSrv[i])+Len(aValSrv[i])+2 ) >= 100
       nCol := 1
       nLin++
    Endif

    @ nLin, nCol pSay &cCompac+aSrv[i]+aValSrv[i]+if(i=Len(aSrv),"",", ")

    nCol := nCol + Len(aSrv[i])+Len(aValSrv[i])+2

    if nLin = 51  .and. nQtdPgs = 1 
       @ nLin, 00 pSay &cNormal+" "
       @ nLIn, 65 pSay Transform(nTotalSrv,"@E 999,999,999.99") + &cCompac
    endif

    if nLin = 55 .and. nQtdPgs = 1 
       @ nLin, 00 pSay &cNormal + " "
       @ nLin, 60 pSay &cCompac + Transform(aliq,"@E 999,999,999.99") + &cNormal  
       @ nLin, 65 pSay Transform(nTotalIss,"@E 999,999,999.99")+&cCompac
       lVez := .t.
    endif

    if nLin = 56 .and. nQtdPgs = 1
       if nDesSer > 0
          @ nLin, 00 pSay &cCompac + "Desconto...: "+Transform(nDesSer,"@E 999,999,999.99") + &cNormal
          nLin++
       Endif
       if lIssRet 
          @ nLin, 00 pSay &cCompac + "IMPOSTO RETIDO CONFORME DETERMINA O ARTIGO 5PARAGRAFO II LEI 1446 DE 04/03/1999 DA P.M.D.C." + &cNormal
          nLin++
       Endif   
       if SF2->F2_VALPIS <> 0 .or. SF2->F2_VALCOFI <> 0 .or. SF2->F2_VALCSLL 
          @ nLin, 00 pSay &cCompac + "Retencao PIS R$"+Transform(SF2->F2_VALPIS,"@E 999,999,999.99")+;
                                     " COFINS R$"+Transform(SF2->F2_VALCOFI,"@E 999,999,999.99")+;
                                     " CSLL R$"+Transform(SF2->F2_VALCSLL,"@E 999,999,999.99")
          nLin++
       Endif   

       if nLin = 56
          nLin++
       Endif   
       if !lIssRet
          @ nLin, 00 pSay &cCompac + "Valor Liquido...:" + Transform(nTotalSrv,"@E 999,999,999.99") + &cNormal
       Else
          @ nLin, 00 pSay &cCompac + "Valor Liquido...:" + Transform(nTotalSrv-(nTotalIss+SF2->F2_VALPIS+SF2->F2_VALCOFI+SF2->F2_VALCSLL),"@E 999,999,999.99") + &cNormal
       Endif   
    Endif
    
Next

dbSelectArea("SC5")
dbSetOrder(1)
if dbSeek(xFilial("SC5")+cPedido)
   nDesAce := SC5->C5_DESPESA
Endif

If len(aSrv) # 0 

   if !lVez

      nLin := 51
      @ nLin, 00 pSay &cCompac  +" "
      @ nLin, 121 pSay Transform(nTotalSrv,"@E 999,999,999.99")

      nLin := 55
      @ nLin, 122 pSay Transform(aliq,"@E 999,999,999.99")

      if nDesSer > 0
         @ nLin, 00 pSay &cCompac + "Desconto...: "+Transform(nDesSer,"@E 999,999,999.99") + &cNormal
         nLin++
      Endif

      if lIssRet 
         @ nLin, 00 pSay &cCompac + "IMPOSTO RETIDO CONFORME DETERMINA O ARTIGO 5 PARAGRAFO II LEI 1446 DE 04/03/1999 DA P.M.D.C." + &cNormal
         nLin++
      Endif   

      if SF2->F2_VALPIS <> 0 .or. SF2->F2_VALCOFI <> 0 .or. SF2->F2_VALCSLL <> 0
         @ nLin, 00 pSay &cCompac + "Retencao PIS R$"+Transform(SF2->F2_VALPIS,"@E 999,999,999.99")+;
                                    " COFINS R$"+Transform(SF2->F2_VALCOFI,"@E 999,999,999.99")+;
                                    " CSLL R$"+Transform(SF2->F2_VALCSLL,"@E 999,999,999.99")
         nLin++
      Endif   

      if nLin = 55
         nLin++
      Endif   
      if !lIssRet
         @ nLin, 00 pSay &cCompac + "Valor Liquido...:" + Transform(nTotalSrv,"@E 999,999,999.99") + &cNormal
      Else
         @ nLin, 00 pSay &cCompac + "Valor Liquido...:" + Transform(nTotalSrv-(nTotalIss+SF2->F2_VALPIS+SF2->F2_VALCOFI+SF2->F2_VALCSLL),"@E 999,999,999.99") + &cNormal
      Endif
         
      nLin := 59
      @ nLin, 00 pSay &cCompac  +" "
      @ nLin, 122 pSay Transform(nTotalIss,"@E 999,999,999.99")+ &cNormal

      lVez := .t.

   Endif

EndIf

//Base do ICMS
@ 63, 000 pSay &cNormal + Transform(aCab[6],"@E 999,999,999.99")
@ 63, 015 pSay Transform(aCab[7],"@E 999,999,999.99")
@ 63, 063 pSay Transform((aCab[10] - nTotalSrv),"@E 999,999,999.99")
//ICMS Retido
if aCab[26] > 0 
   @ 63, 032 pSay Transform(aCab[25],"@E 999,999,999.99")
   @ 63, 046 pSay Transform(aCab[26],"@E 999,999,999.99")
Endif   
//Despesas acessorias
@ 65, 030 pSay Transform(nDesAce,"@E 999,999,999.99")
//Valor do IPI
if aCab[24] > 0 
   @ 65, 042 pSay Transform(aCab[24],"@E 999,999,999.99")
Endif   
//Total da Nota Fiscal
//@ 65, 063 pSay Transform((aCab[10] + nDesAce + aCab[24] + aCab[26]),"@E 999,999,999.99")
@ 65, 063 pSay Transform(SF2->F2_VALBRUT,"@E 999,999,999.99")

@ 68, 001 pSay &cCompac+" "
@ 68, 079 pSay "2" 

@ 72, 001 pSay &cNormal+" "
@ 72, 015 pSay "DIVERSAS"    
@ 72, 75 pSay transform(aCab[23],"@E 99.999")   //120

@ 73, 001 pSay &cCompac + " "   

nLin := 75
nCol := 19  
if len(aOsv) >= 1                            
  @ nLin, 002 pSay "Ordem Servico..: "
  for i = 1 to len(aOsv)
     @ nLin, nCol pSay aOsv[i] + "/"
     nCol := nCol + 9
     if nCol >= 72
        nCol := 2
        nLin := nLin + 1
     endif      
  next 
endif

nLin++

nCol := 19  
if len(aPla) >= 1                            
  @ nLin, 002  pSay "Placa Veiculo..: "
  for i = 1 to len(aPla)
     @ nLin, nCol pSay alltrim(aPla[i]) + "/"
     nCol := nCol + 9
     if nCol >= 73
        nCol := 2
        nLin := nLin + 1
     endif      
  next 
endif
   
if SF2->F2_TIPO == "N"
   if Len(aIte) > 0 .and. GetMv("MV_ESTADO") == SA1->A1_EST
      nLin++
      @ nLin, 002 pSay "Imposto Retido por Substituicao em fase anterior"
   Endif
Endif   

&& Imprime a OBS da NF

if SF2->F2_TIPO == "N"
	If SF2->(FieldPos("F2_OBSMEM")) # 0
		DbSelectArea("SYP")
		DbSetOrder(1)
		DbSeek( xFilial("SYP") + SF2->F2_OBSMEM )
		While !Eof() .and. SYP->YP_CHAVE == SF2->F2_OBSMEM
			cDescri := Alltrim(SYP->YP_TEXTO)
			If ( nTamDesc := AT("\13\10",cDescri) ) == 0
				nTamDesc := AT("\14\10",cDescri)
			EndIf
			If nTamDesc > 0
				nTamDesc-- 
			Else
				nTamDesc := Len(cDescri)
			EndIf
	   	@ ++nLin,01 PSAY substr(cDescri,1,nTamDesc)

		   && Imprime somente 4 linhas da observacao
		   If nLin >= 85
				Exit   
		   EndIf
	   
		   DbSelectArea("SYP")
		  	DbSkip()
		EndDo
	EndIf
ElseIf SF2->F2_TIPO $ "D/B"
   dbSelectArea("SC5")
   dbSetOrder(1)
   if dbSeek(xFilial("SC5")+cPedido)
   	cDescri := Alltrim(SC5->C5_MENNOTA)
      @ ++nLin,01 PSAY cDescri
   Endif  
Endif

// IMPRIME NUMERO DA NOTA FISCAL NO RODAPE DO FORMULARIO
@ 89, 01 psay &cNormal
@ 90, 65 pSay aCab[1]  +" / "+ StrZero(aPag,2)+"/"+ Strzero(nQtdPag,2) 

nlin := 96
@ nlin , 001 pSay " "+CHR(27)+"2"
SETPRC(0,0)

Set Printer to
Set Device  to Screen

MS_Flush()

If aReturn[5] == 1
	dbCommitAll()
	ourspool(wnrel)
Endif

If lRestFiltro
	If Type("bFiltraBrw") # "U"
		Eval(bFiltraBrw)
	EndIf	
EndIf	

Return

// FUNCAO PARA IMPRIMIR O CABECALHO DA NOTA FISCAL
Static Function FS_CABEC(ntrans)
*********************
Local xv

@ 01, 001 pSay &cNormal+" "
@ 01, 052 pSay "X"
@ 03, 049 pSay space(15) + aCab[1] + " / " + StrZero(aPag,2) + "/" + Strzero(nQtdPag,2)
          
@ 07, 000 pSay + &cCompac

if len(aCfOp) = 1
   @ 07, 001 pSay aDesc[1]
   @ 07, 041 pSay aCfOp[1]
elseif len(aCfOp) = 2
   nLin:= 7
   for xv = 1 to len(aCfOp)
      @ nLin, 001 pSay aDesc[xv]
      @ nLin, 041 pSay aCfOp[xv]        
      nlin++
   next
elseif len(aCfOp) = 3
   nLin:= 7
   for xv = 1 to len(aCfOp)
      @ nLin, 001 pSay aDesc[xv]
      @ nLin, 041 pSay aCfOp[xv]        
      nlin++
   next
endif

@ 11, 000 pSay &cNormal+" "+aCab[14]  //CLIENTE 
@ 11, 052 pSay aCab[21]
@ 11, 072 pSay aCab[5]

@ 13, 001 pSay aCab[15]      //ENDERECO
@ 13, 043 pSay SUBSTR(aCab[16],1,15)
@ 13, 060 pSay transform(aCab[17],"@R 99999-999")
@ 13, 073 pSay aCab[5] 

@ 15, 001 pSay aCab[18]   //MUNICIPIO
@ 15, 034 pSay aCab[19]
@ 15, 048 pSay aCab[20]
@ 15, 050 pSay aCab[22]+&cCompac

FS_FATUR()    

If aPag # 1 
   @ 22 ,005 pSay "De Transporte" 
   @ 22 ,113 pSay transform(nTrans,"@E 999,999,999.99") 
EndIf  
       
Return .t.


// FUNCAO PARA IMPRIMIR OS TITULOS DA NOTA FISCAL
Static Function FS_FATUR()
***********************

Local xa

nLin := 18

for xa = 1 to len(aTit)

   if xa = 13
      exit
   endif   
  
   if strzero(xa,2) $ "01/04/07/10"
      @ nLin, 019 pSay aTit[xa,1] //DUPLICATA
      @ nLin, 035 pSay aTit[xa,3] //VENCTO 
      @ nLin, 048 pSay aTit[xa,2] //VALOR
   elseif strzero(xa,2) $ "02/05/08/11"
      @ nLin, 061 pSay aTit[xa,1] 
      @ nLin, 076 pSay aTit[xa,3]  
      @ nLin, 089 pSay aTit[xa,2]
   elseif strzero(xa,2) $ "03/06/09/12"   
      @ nLin, 102 pSay aTit[xa,1] 
      @ nLin, 117 pSay aTit[xa,3]  
      @ nLin, 129 pSay aTit[xa,2]
      nLin++
   endif

next

return

// FUNCAO PARA IMPRIMIR OS ITEMS DA NOTA FISCAL
Static Function FS_DETALHE()
***********************
Local ii
Private nContIte := 1
           
nLin:=22

For ii:=1 to Len(aIte)
    @ nLin, 001 pSay aIte[ii,2]
    @ nLin, 025 pSay aIte[ii,3]
    @ nLin, 084 pSay aIte[ii,9]
    @ nLin, 088 pSay aIte[ii,4]
    @ nLin, 097 pSay aIte[ii,5]
    @ nLin, 103 pSay aIte[ii,6]
    @ nLin, 120 pSay TRANSFORM(aIte[ii,7],"@E 999,999,999.99")
    @ nLin, 135 pSay aIte[ii,8]
    nTrans+= aIte[ii,7]
    nLin++
            
    if (ii <= Len(aIte) .and. nLin == 43) .or. (ii == Len(aIte))
       if nDesPec > 0
          @ nLin ,001 pSay "Descontos...: "+transform(nDesPec,"@E 999,999,999.99")
          nLin++
       Endif   
    Endif       

    //TESTE PARA SABER SE O FORMULARIO CONTEM MAIS DE 1 VIA OU SEJA OS ITEMS NAO CABEM EM UM SO FORMULARIO
    If nLin > 43 .and. (ii < Len(aIte))
       @ nLin ,005 pSay "A Transportar"
       @ nLin ,113 pSay transform(nTrans,"@E 999,999,999.99")

       // IMPRIME NUMERO DA NOTA FISCAL NO RODAPE DO FORMULARIO
       @ 89, 01 psay &cNormal
       @ 90, 66 pSay  aCab[1]  +" / "+ StrZero(aPag,2)+"/"+ Strzero(nQtdPag,2)

       nlin := 96
       @ nlin , 001 pSay " "
       SETPRC(0,0)
       nLin := 1
       aPag++
       FS_CABEC(ntrans)
		 nLin := 23
    EndIf
Next

Return

Static Function FS_VALNF1()
**********************

DbSelectArea("SF2")
DbSetOrder(1)
dbgotop()
If DbSeek(xFilial("SF2")+mv_par01)
   Return .f.
EndIf

Return .t.


Static Function FS_VALNF2()
**********************

DbSelectArea("SF2")
DbSetOrder(1)
dbgotop()
If DbSeek(xFilial("SF2")+mv_par01+mv_par02)
   Return .t.
Else              
   DbSelectArea("SA1")
   Dbgotop()
   DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
   mv_par03 := iif(SF2->F2_TIPO $ "D/B",sa2->a2_nome,sa1->a1_nome)
   mv_par04 := sf2->f2_emissao
EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LeDriver ³ Autor ³ Tecnologia            ³ Data ³ 17/05/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Emissao da Nota Fiscal de Balcao                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Geral                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LeDriver()

Local aSettings := {}
Local cStr, cLine, i

If !File(__DRIVER)
   aSettings := {"CHR(15)","CHR(18)","CHR(15)","CHR(18)","CHR(15)","CHR(15)"}
Else
   cStr := MemoRead(__DRIVER)
   For i:= 2 to 7
      cLine := AllTrim(MemoLine(cStr,254,i))
      aAdd(aSettings,SubStr(cLine,7))
   Next
EndIf

Return aSettings
