#include "protheus.ch"
/*                                             
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ NEPECSER ³ Autor ³ Andre Luis Almeida    ³ Data ³ 25/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Emissao da NF de Entrada de Pecas e Servicos - Grupo FS    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function NEPECSER()
Local lRet := .f.
Private cNF        := space(6)
Private cSr        := space(3)
Private cFo        := space(6)
Private cLj        := space(2)
Private cTp        := space(20)
Private cTpX       := " "
Private cNome      := " "
Private lTp        := .t.
Private aForn 		 := {}
Private cDesc1     := ""
Private cDesc2     := ""
Private cDesc3     := ""
Private cString    := "SD1"
Private cAlias     := "SD1"
Private aRegistros := {}
Private cTitulo    := OemToAnsi("Emissao da Nota Fiscal de Entrada")
Private cTamanho   := "M"
Private Tamanho    := "M" 
Private cNomProg   := "NEPECSER"
Private nLastKey   := 0
Private cNomRel    := "NEPECSER"
Private nLin       := 4
Private aPag       := 1
Private nIte       := 1
Private limite     := 220
Private lServer    := GetMv("MV_LSERVER") == "S"
Private cDrive     := GetMv("MV_DRVNFI")
Private cPorta     := GetMv("MV_PORNFI")
Private aReturn    := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 3, cPorta, "",1 }  //"Zebrado"###"Administracao"
DEFINE MSDIALOG oNEPECSER FROM 000,000 TO 007,042 TITLE "Impressao da NF Entrada" OF oMainWnd
	@ 009,010 SAY "NF:" SIZE 30,08 OF oNEPECSER PIXEL COLOR CLR_BLUE 
	@ 008,020 MSGET oNF VAR cNF F3 "SF1" SIZE 23,08 OF oNEPECSER PIXEL COLOR CLR_HBLUE
	@ 008,053 MSGET oSr VAR cSr VALID FS_VER() SIZE 08,08 OF oNEPECSER PIXEL COLOR CLR_HBLUE
	@ 009,090 SAY "Tipo:" SIZE 30,08 OF oNEPECSER PIXEL COLOR CLR_BLUE 
	@ 008,105 MSGET oTp VAR cTp SIZE 52,08 OF oNEPECSER PIXEL COLOR CLR_HBLUE WHEN .f.
	@ 020,010 SAY If(!Empty(cTpX),cTpX+":","") SIZE 50,08 OF oNEPECSER PIXEL COLOR CLR_BLUE 
	@ 019,041 MSGET oFo VAR cFo SIZE 25,08 OF oNEPECSER PIXEL COLOR CLR_HBLUE WHEN .f.
	@ 019,066 MSGET oLj VAR cLj SIZE 08,08 OF oNEPECSER PIXEL COLOR CLR_HBLUE WHEN .f.
	@ 019,081 MSGET oNome VAR cNome SIZE 65,08 OF oNEPECSER PIXEL COLOR CLR_HBLUE WHEN .f.
	DEFINE SBUTTON FROM 034,035 TYPE 1 ACTION (lRet:=.t.,oNEPECSER:End()) ENABLE OF oNEPECSER
	DEFINE SBUTTON FROM 034,100 TYPE 2 ACTION (oNEPECSER:End()) ENABLE OF oNEPECSER
   @ 019,145 BUTTON oVer PROMPT OemToAnsi("...") OF oNEPECSER SIZE 11,10 PIXEL ACTION FS_VER() WHEN (len(aForn)>1)
  	@ 003,003 TO 050,163 LABEL "" OF oNEPECSER PIXEL // Caixa
ACTIVATE MSDIALOG oNEPECSER CENTER 
If lRet
   DbSelectArea("SF1") 
   DbSetOrder(1)
   If DbSeek( xFilial("SF1") + cNF + cSr + cFo + cLj ) 
		SetDefault(aReturn,cAlias)
		RptStatus({|lEnd| ImprimeNF(@lEnd,cNomRel,cAlias)},cTitulo)
		DbClearFilter()                  
	Else
		MsgAlert("NF de Entrada nao existente!","Atencao")
		aForn := {}
	EndIf
EndIf

Return

Static Function FS_VER()
	aForn := {}
   DbSelectArea("SF1") 
   DbSetOrder(1)
   DbSeek( xFilial("SF1") + cNF + cSr ) 
	While !Eof() .and. xFilial("SF1") == SF1->F1_FILIAL .and. ( SF1->F1_DOC + SF1->F1_SERIE == cNF + cSr )
		cFo := SF1->F1_FORNECE
		cLj := SF1->F1_LOJA
		If SF1->F1_TIPO == "D" 
			lTp := .f.
			cTp := "Devolucao"
			cTpX := "Cliente"
		   DbSelectArea("SA1") 
		   DbSetOrder(1)
		   DbSeek( xFilial("SA1") + cFo + cLj ) 
			cNome := SA1->A1_NOME
		Else
			lTp := .t.
			cTp := "Entrada Normal"
			cTpX := "Fornecedor"
		   DbSelectArea("SA2")  
		   DbSetOrder(1)
		   DbSeek( xFilial("SA2") + cFo + cLj ) 
		   cNome := SA2->A2_NOME
		EndIf		
		aAdd(aForn,{ cFo , cLj , cNome , cTp , lTp , cTpX })
	   DbSelectArea("SF1")
   	DbSkip()
   EndDo
   If len(aForn) == 0
		MsgAlert("NF de Entrada nao existente!","Atencao")
		cFo := space(6)
		cLj := space(3)
		cTp := space(20)
		cTpX := " "
		cNome := " "
	   oNF:SetFocus()
   ElseIf len(aForn) > 1
		DEFINE MSDIALOG oFoCl FROM 000,000 TO 013,080 TITLE "Fornecedor/Cliente" OF oMainWnd
				@ 003,010 SAY ("NF: "+cNF+"-"+cSr) SIZE 150,08 OF oFoCl PIXEL COLOR CLR_BLUE 
			   @ 002,265 BUTTON oSair PROMPT OemToAnsi("Sair") OF oFoCl SIZE 48,10 PIXEL ACTION (cFo:=aForn[oFoClLx:nAt,1],cLj:=aForn[oFoClLx:nAt,2],cNome:=aForn[oFoClLx:nAt,3],cTp:=aForn[oFoClLx:nAt,4],lTp:=aForn[oFoClLx:nAt,5],cTpX:=aForn[oFoClLx:nAt,6],oFoCl:End())
				@ 013,003 LISTBOX oFoClLx FIELDS HEADER "Tipo","Codigo","Nome" 50,40,80 SIZE 311,82 OF oFoCl PIXEL ON DBLCLICK (cFo:=aForn[oFoClLx:nAt,1],cLj:=aForn[oFoClLx:nAt,2],cNome:=aForn[oFoClLx:nAt,3],cTp:=aForn[oFoClLx:nAt,4],lTp:=aForn[oFoClLx:nAt,5],cTpX:=aForn[oFoClLx:nAt,6],oFoCl:End())
	   		oFoClLx:SetArray(aForn)
			   oFoClLx:bLine := { || {	aForn[oFoClLx:nAt,4]+" - "+aForn[oFoClLx:nAt,6],; 
			   								aForn[oFoClLx:nAt,1]+"-"+aForn[oFoClLx:nAt,2],; 
											   aForn[oFoClLx:nAt,3]}}
	   ACTIVATE MSDIALOG oFoCl CENTER 
   EndIf
Return

Static Function ImprimeNF(lEnd,wNRel,cAlias)
************************************

Local nTotal  := 0
Local nValIPI := 0
Local nICMRet := 0

Local nQtdIte := 0
Local nQtdSrv := 0
Local i, xz, lRestFiltro := .f.
Private ntrans := 0, nQtdPag :=  0
Private aIte      := {}
Private aSrv      := {}
Private aValSrv   := {}
Private aCfOp     := {}           
Private aDesc     := {}
Private nTotalSrv := 0
Private nTotalIss := 0
Private aliq      := 0

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

aCab := {}
aAdd(aCab,SF1->F1_DOC  )                                   //1
aAdd(aCab,SF1->F1_SERIE)                                   //2
aAdd(aCab,SF1->F1_FORNECE)                                 //3
aAdd(aCab,SF1->F1_LOJA)                                    //4
aAdd(aCab,SF1->F1_DTDIGIT)                                 //5
aAdd(aCab,Transform(SF1->F1_BASEICM,"@E 9,999,999.99"))    //6
aAdd(aCab,Transform(SF1->F1_VALICM ,"@E 9,999,999.99"))    //7
aAdd(aCab,Transform(SF1->F1_FRETE  ,"@E 9,999,999.99"))    //8
aAdd(aCab,Transform(SF1->F1_SEGURO ,"@E 9,999,999.99"))    //9
aAdd(aCab,SF1->F1_VALMERC)                                 //10
aAdd(aCab,SF1->F1_DESCONT)                                 //11

dbSelectArea("SE4")
dbsetorder(1)
dbSeek(xFilial("SE4")+SF1->F1_COND)

aTit  := {}
aTit1 := {}
dAnt := ctod("  /  /  ")
nRazao := 0

dbselectArea("SE2") 
dbSetOrder(1)
dbSeek(xFilial("SE2")+SF1->F1_PREFIXO+SF1->F1_DUPL)

do while !eof() .and. SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM = SF1->F1_FILIAL+SF1->F1_PREFIXO+SF1->F1_DUPL                        
   aAdd(aTit,{SE2->E2_PREFIXO+SE2->E2_NUM+"/"+SE2->E2_PARCELA,transform(SE2->E2_VALOR,"@e 999,999.99"),SE2->E2_VENCTO})
   if SE4->E4_TIPO = "A"
      if SE2->E2_PARCELA = "1"
         n_Razao := SE2->E2_VENCTO - SE2->E2_EMISSAO 
         d_Ant := SE2->E2_VENCTO  
         aAdd(aTit1,strzero(n_Razao,3)) 
      else                                             
         n_Razao := SE2->E2_VENCTO - d_Ant 
         d_Ant := SE2->E2_VENCTO       
         aAdd(aTit1,strzero(n_Razao,3)) 
      endif
   endif
     
   dbselectArea("SE2")
   dbskip()
enddo  

aAdd(aCab," ")               //12

if SE4->E4_TIPO # "A"
   aAdd(aCab,SF1->F1_COND+" - "+SE4->E4_DESCRI)                //13
else                               
   cDescri := ""
   for xz = 1 to len(aTit1)
      cDescri := cDescri + atit1[xz] + ","
   next                           
   cDescri := cDescri + " Dias"
   aAdd(aCab,SF1->F1_COND+" - "+cDESCRI)                //13
endif

If lTp
	dbSelectArea("SA2") 
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
	aAdd(aCab,A2_NOME)                                         //14
	aAdd(aCab,A2_END)                                          //15
	aAdd(aCab,A2_BAIRRO)                                       //16
	aAdd(aCab,A2_CEP)                                          //17
	aAdd(aCab,A2_MUN)                                          //18
	aAdd(aCab,A2_TEL)                                          //19
	aAdd(aCab,A2_EST)                                          //20
	cCGCCPF1  := subs(transform(SA2->A2_CGC,PicPes(RetPessoa(SA2->A2_CGC))),1,at("%",transform(SA2->A2_CGC,PicPes(RetPessoa(SA2->A2_CGC))))-1)
	cCGCPro   := cCGCCPF1 + space(18-len(cCGCCPF1))
	aAdd(aCab,cCGCPro)                                          //21
	aAdd(aCab,A2_INSCR)                                        //22
	aAdd(aCab," ")                                  //23
Else
	dbSelectArea("SA1") 
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
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
	aAdd(aCab," ")                                  //23
EndIf

aAdd(aCab,SF1->F1_VALIPI)                                  //24
aAdd(aCab,SF1->F1_BRICMS)                                  //25
aAdd(aCab,SF1->F1_ICMSRET)                                 //26

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SD1")
dbSetOrder(1)
dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
While SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA .and. xFilial("SD1") == D1_FILIAL .and. !SD1->(EOF())

   dbSelectArea("SB1")
   dbSeek(xFilial("SB1")+SD1->D1_COD)

   dbSelectArea("SF4")
   dbSeek(xFilial("SF4")+SD1->D1_TES)

   If SF4->F4_ISS == "S"

      aAdd(aSrv,alltrim(SB1->B1_DESC))
      aAdd(aValSrv,"  (R$ "+transform(SD1->D1_TOTAL,"@E 9,999,999.99")+")")

      nTotalSrv := nTotalSrv+SD1->D1_TOTAL
      nTotalIss := nTotalIss + SD1->D1_VALISS
      if Aliq = 0
         Aliq := SD1->D1_ALIQISS
      endif
      if ascan(aCfOp,SD1->D1_CF,) = 0
         aAdd(aCfOp,SD1->D1_CF)
         aAdd(aDesc,SF4->F4_TEXTO)
      endif       
      nQtdSrv += 1
   Else
      aAdd(aIte,{SD1->D1_ITEM,SB1->B1_GRUPO+" "+SB1->B1_CODITE,SB1->B1_DESC,SD1->D1_UM,SD1->D1_QUANT,TRANSFORM(SD1->D1_VUNIT,"@E 999,999,999.99"),SD1->D1_TOTAL,Transform(SD1->D1_PICM,"@E 999.99" ),SB1->B1_ORIGEM})
      if ascan(aCfOp,SD1->D1_CF,) = 0
         aAdd(aCfOp,SD1->D1_CF)
         aAdd(aDesc,SF4->F4_TEXTO)
      endif
      nQtdIte += 1
   Endif

   dbSelectArea("SD1")
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
    
Next

If len(aSrv) # 0 

   if !lVez

      nLin := 51
      @ nLin, 00 pSay &cCompac  +" "
      @ nLin, 121 pSay Transform(nTotalSrv,"@E 999,999,999.99")

      nLin := 55
      @ nLin, 122 pSay Transform(aliq,"@E 999,999,999.99")

      nLin := 59
      @ nLin, 122 pSay Transform(nTotalIss,"@E 999,999,999.99")+ &cNormal

      lVez := .t.

   Endif

EndIf

//Base do ICMS
@ 63, 000 pSay &cNormal + aCab[6]
@ 63, 015 pSay aCab[7]
//Total dos produtos
@ 63, 063 pSay Transform((aCab[10] - nTotalSrv),"@E 999,999,999.99")
//Base e valor do ICMS Retido
if aCab[26] > 0 
   @ 63, 032 pSay Transform(aCab[25],"@E 999,999,999.99")
   @ 63, 046 pSay Transform(aCab[26],"@E 999,999,999.99")
Endif   
//Valor do IPI 
if aCab[24] > 0 
   @ 65, 042 pSay Transform(aCab[24],"@E 999,999,999.99")
Endif   
//Total da Nota Fiscal
//@ 65, 063 pSay Transform((aCab[10]+aCab[24]+aCab[26]),"@E 999,999,999.99")
@ 65, 063 pSay Transform(SF1->F1_VALBRUT,"@E 999,999,999.99")

@ 68, 001 pSay &cCompac+" "
@ 68, 079 pSay "1" 

@ 72, 001 pSay &cNormal+" "
@ 72, 015 pSay "DIVERSAS"    
@ 72, 75 pSay transform(aCab[23],"@E 99.999")   //120

@ 73, 001 pSay &cCompac + " "   

nLin := 75
nCol := 19  
If !lTp
	dbSelectArea("SD1")
	dbSetOrder(1)
	if dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
      @ nLin, 002 pSay "Nota Fiscal Original: "
      cOri := "#"
   	While !eof() .and. SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
   	   if cOri <> SD1->D1_NFORI+SD1->D1_SERIORI
            @ nLin, 025 pSay SD1->D1_NFORI+" / "+SD1->D1_SERIORI
            cOri := SD1->D1_NFORI+SD1->D1_SERIORI
      	   nLin++
         Endif   
         dbSkip()
      EndDo
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
@ 01, 061 pSay "X"
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
@ 15, 051 pSay aCab[22]+&cCompac

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
      @ nLin, 066 pSay aTit[xa,1] 
      @ nLin, 081 pSay aTit[xa,3]  
      @ nLin, 094 pSay aTit[xa,2]
   elseif strzero(xa,2) $ "03/06/09/12"   
      @ nLin, 112 pSay aTit[xa,1] 
      @ nLin, 128 pSay aTit[xa,3]  
      @ nLin, 142 pSay aTit[xa,2]
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
