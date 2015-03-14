#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PREFECTO | Autor ³Fabio / Andre Luis Almeida³ Data ³ 01/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Pre-Fechamento  (Individual)                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PREFECTO()

SetPrvt("oOsv,oTemTra,oTemPad,lOsv,lTemTra,lTemPad,lCheckObserv,oChekObserv,oObserv,cObserv")
SetPrvt("aTempos,cAliasSrv,cAliasPec,cObserv,oDlgPreFecto,c_TipTpo")

aTempos  := ParamIXB[1] //Vetor com os tipos de tempo
cAliasSrv:= ParamIXB[2] //Alias de Servicos
cAliasPec:= ParamIXB[3] //Alias de Pecas
lOsv     := .t.
lTemTra  := .t.
lTemPad  := .t.
lCheckObserv := .f.
cObserv  := ""
c_TipTpo := ""            
cTitulo	:= SM0->M0_NOMECOM
cabec1 	:= ""
cabec2 	:= ""
nomeprog	:="PREFECTO"
tamanho	:="P"
nCaracter:=18

DEFINE MSDIALOG oDlgPreFecto FROM 001,000 TO 016,050 TITLE "OS por Cliente e Prod/Serv" OF oMainWnd

@ 001,002 TO 025,198 LABEL "Informacoes adcionais" OF oDlgPreFecto PIXEL
//@ 010,005 CHECKBOX oOsv VAR lOsv PROMPT "Ordem Servico" OF oDlgPreFecto SIZE 55,08 PIXEL
//@ 010,075 CHECKBOX oTemTra VAR lTemTra PROMPT "Tempo Trabalhado" OF oDlgPreFecto SIZE 55,08 PIXEL
//@ 010,140 CHECKBOX oTemPad VAR lTemPad PROMPT "Tempo Padrao" OF oDlgPreFecto SIZE 55,08 PIXEL
@ 030,002 TO 100,198 LABEL "Observacao" OF oDlgPreFecto PIXEL
@ 037,005 CHECKBOX oChekObserv VAR lCheckObserv PROMPT "Lista Observacao" OF oDlgPreFecto ON CLICK If( lCheckObserv , oObserv:Enable() , oObserv:Disable() ) SIZE 60,08 PIXEL
@ 047,005 GET oObserv VAR cObserv OF oDlgPreFecto MEMO SIZE 190,50 PIXEL //READONLY MEMO
DEFINE SBUTTON FROM 101,120 TYPE 6 ACTION ( FS_SETPREFECTO() , oDlgPreFecto:End() ) ENABLE OF oDlgPreFecto
DEFINE SBUTTON FROM 101,160 TYPE 2 ACTION oDlgPreFecto:End() ENABLE OF oDlgPreFecto

ACTIVATE MSDIALOG oDlgPreFecto CENTER

Return

Static Function FS_SETPREFECTO()

SetPrvt("cAlias,nLin,aPag,nIte,aReturn,Limite,aOrdem,cTitulo,cTamanho,nomeprog,nomeprog,cgPerg,nLastKey")
SetPrvt("cDesc1,cDesc2,cDesc3")

cAlias   := Alias()
nLin 	  	:= 2
m_Pag		:= 1
nIte 		:= 1
aReturn 	:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
Limite 	:= 80           // 80/132/220
aOrdem  	:= {}           // Ordem do Relatorio
cTitulo	:= SM0->M0_NOMECOM+" OS por Cliente e Prod/Serv"
cTamanho	:= "P"
cgPerg  	:= ""
nLastKey	:= 0
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
lserver  := .t.
cabec1 	:= ""
cabec2 	:= ""
nCaracter:=18
Do While File(__RELDIR+nomeprog+".##R")
	Dele File &(__RELDIR+nomeprog+".##R")
EndDo	

nomeprog := SetPrint(cAlias,nomeprog,nil ,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,cTamanho)

If nLastKey == 27
	Return
Endif

Pergunte("FECHAM",.f.)

SetDefault(aReturn,cAlias)

//RptStatus({|lEnd| IMPPREFECTO(aTempos,cAliasSrv,cAliasPec)},cTitulo)
IMPPREFECTO(aTempos,cAliasSrv,cAliasPec)

Set Printer to
Set Device  to Screen

If aReturn[5] == 1
	OurSpool( nomeprog )
EndIf

MS_Flush()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPPREFECTºAutor  ³Fabio               º Data ³  05/28/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime pre-fechamento                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IMPPREFECTO(aTempos,cAliasSrv,cAliasPec)

Local nOsImp := 0
Local nObs   := 0

//SetPrvt("nLin,cQuebraCli,cQuebraVei,cQuebraGruTp,aTotaliz,aObserv,nObs,aOsImp")

cTitulo	:= SM0->M0_NOMECOM+" OS por Cliente e Prod/Serv"
cabec1 	:= ""
cabec2 	:= ""
tamanho	:= "P"
nCaracter:= 18

Set Printer to &nomeprog
Set Printer On
Set Device  to Printer

&(cAliasSrv)->(DbSetOrder(4))
&(cAliasPec)->(DbSetOrder(4))

SetRegua( &(cAliasSrv)->( RecCount() ) + &(cAliasPec)->( RecCount() ) )

aTotaliz := {}
aObserv  := {}

Aadd( aTotaliz , { 0 , 0 } )	//  1 - Totaliza Servicos
Aadd( aTotaliz , { 0 , 0 } )	//  2 - Totaliza Pecas
Aadd( aTotaliz , { 0 , 0 } )	//  3 - Totaliza OS e Descontos

cQuebraCli  := ""
cQuebraVei  := ""
cQuebraGruTp:= ""
cPosSrv     := ""
cPulaImprSRV:= "INICIAL"
lCabCli     := .t.
nTotTOS     := 0  //  Valor Total das OS's
nPECRecNo   := 0
aOsImp      := {}
cFatPar     := ""
nPos        := 0
 
DbSelectArea(cAliasSrv)
DbSetOrder(4)
DbGoTop()
Do While !Eof()
	nPos := Ascan( aTempos , {|x| x[2] == SRV->SRV_TIPTEM } )
 	If nPos > 0
 		If aTempos[nPos,1]
		   If Ascan( aOsImp , {|x| x[1]+x[2]+x[3]+x[4]+x[5] == SRV->SRV_CODCLI+SRV->SRV_LOJCLI+SRV->SRV_NUMOSV+SRV->SRV_TIPTEM+SRV->SRV_CHAINT } ) == 0
				Aadd( aOsImp , { SRV->SRV_CODCLI , SRV->SRV_LOJCLI , SRV->SRV_NUMOSV , SRV->SRV_TIPTEM , SRV->SRV_CHAINT } )
			EndIf
		EndIf
	EndIf
	DbSkip()     
EndDo

DbSelectArea(cAliasPec)
DbSetOrder(4)
DbGoTop()
Do While !Eof()
	nPos := Ascan( aTempos , {|x| x[2] == PEC->PEC_TIPTEM } )
 	If nPos > 0
 		If aTempos[nPos,1]
		   If Ascan( aOsImp , {|x| x[1]+x[2]+x[3]+x[4]+x[5] == PEC->PEC_CODCLI+PEC->PEC_LOJCLI+PEC->PEC_NUMOSV+PEC->PEC_TIPTEM+PEC->PEC_CHAINT } ) == 0
				Aadd( aOsImp , { PEC->PEC_CODCLI , PEC->PEC_LOJCLI , PEC->PEC_NUMOSV , PEC->PEC_TIPTEM , PEC->PEC_CHAINT } )
			EndIf
		EndIf
	EndIf
	DbSkip()     
EndDo
     
If Len(aOsImp) # 0
	asort(aOsImp,,,{|x,y| x[1]+x[2]+x[3]+x[4] < y[1]+y[2]+y[3]+y[4] })
EndIf
	
&(cAliasSrv)->(DbSetOrder(4))
&(cAliasSrv)->(DbGoTop())

&(cAliasPec)->(DbSetOrder(4))
&(cAliasPec)->(DbGoTop())

For nOsImp := 1 to Len(aOsImp)
   
	If !Empty(aOsImp[nOsImp,3])

	   DbSelectArea("VO1")   
   	DbSetOrder(1)
	   DbSeek(xFilial("VO1")+aOsImp[nOsImp,3])

   	DbSelectArea("VV1")   
	   DbSetOrder(1)
   	DbSeek(xFilial("VV1")+VO1->VO1_CHAINT)

	   DbSelectArea("SA3")
   	DbSetOrder(1)
	   DbSeek(xFilial("SA3")+VO1->VO1_FUNABE)

   	DbSelectArea("VE1")   
	   DbSetOrder(1)
	   DbSeek(xFilial("VE1")+VV1->VV1_CODMAR)
     
   	DbSelectArea("VV2")   
	   DbSetOrder(1)
	   DbSeek(xFilial("VV2")+VV1->VV1_CODMAR+VV1->VV1_MODVEI)
      
      Cabec1 := "OS por Cliente e Prod/Serv - "+"Emissao: "+TRANS(VO1->VO1_DATABE,"@D")+" "+TRANS(VO1->VO1_HORABE,"@R 99:99")+" hs"
		lOk := .f.
      DbSelectArea("VO2")
  	   DbSetOrder(1)
     	If DbSeek(xFilial("VO2")+VO1->VO1_NUMOSV)
     		If VO2->VO2_TIPREQ == "S"
	      	DbSelectArea("VO4")
	   	   DbSetOrder(1)
   	   	If DbSeek(xFilial("VO4")+VO2->VO2_NOSNUM)
  	   			dData := VO4->VO4_DATDIS
  	   			nHora := VO4->VO4_HORDIS
      			lOk := .t.
      			cFatPar := "VO4"
  	   		EndIf
  	   	Else
	         DbSelectArea("VO3")
  			 	DbSetOrder(1)
   		  	If DbSeek(xFilial("VO3")+VO2->VO2_NOSNUM)
	   	   	dData := VO3->VO3_DATDIS
   	   		nHora := VO3->VO3_HORDIS
   	   		lOk := .t.     
   	   		cFatPar := "VO3"
		   	EndIf
			EndIf
		   DbSelectArea("SA1")
	   	DbSetOrder(1)
	   	If cFatPar == "VO4"
			 	If ( Empty(VO4->VO4_FATPAR) .or. !SA1->( DbSeek( xFilial("SA1")+VO4->VO4_FATPAR+VO4->VO4_LOJA ) ) )
					cFatPar := "VO3"
			 	EndIf
			EndIf
	   	If cFatPar == "VO3"
			 	If ( Empty(VO3->VO3_FATPAR) .or. !SA1->( DbSeek( xFilial("SA1")+VO3->VO3_FATPAR+VO3->VO3_LOJA ) ) )
				 	If ( Empty(VO1->VO1_FATPAR) .or. !SA1->( DbSeek( xFilial("SA1")+VO1->VO1_FATPAR+VO1->VO1_LOJA ) ) )
						SA1->( DbSeek( xFilial("SA1")+VV1->VV1_PROATU+VV1->VV1_LJPATU ) )
				 	EndIf
			 	EndIf
			EndIf
     	Else
		   DbSelectArea("SA1")
	   	DbSetOrder(1)
		 	If ( Empty(VO1->VO1_FATPAR) .or. !SA1->( DbSeek( xFilial("SA1")+VO1->VO1_FATPAR+VO1->VO1_LOJA ) ) )
				SA1->( DbSeek( xFilial("SA1")+VV1->VV1_PROATU+VV1->VV1_LJPATU ) )
		 	EndIf
     	EndIf
     	If lOk
		   Cabec1 += " - Fim: "+TRANS(dData,"@D")+" "+TRANS(nHora,"@R 99:99")+" hs"
	 	EndIf
      Cabec2 := "Recepcionista: " +SA3->A3_COD+" "+LEFT(ALLTRIM(SA3->A3_NOME),30) 

		nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1

		FS_DADOSCLI()
		nLin++
		@ CABPREFECTO(),00 PSAY "           OS Preventiva (    )                 OS Corretiva (    )"
		nLin++
	                    
		cQuebraGruTp := ""
		
	   DbSelectArea("SRV") 
	   DbSetOrder(4)
	   DbSeek( aOsImp[nOsImp,3]+aOsImp[nOsImp,4]+aOsImp[nOsImp,1]+aOsImp[nOsImp,2]+aOsImp[nOsImp,5] )
		If SRV->(Found())

			@ CABPREFECTO(),00 PSAY Repl("-",80) 
//			@ CABPREFECTO(),00 PSAY "SERVICOS EXECUTADOS                       UM   Quant.  Vlr. Unit.    Vlr. Total"
			@ CABPREFECTO(),00 PSAY "SERVICOS EXECUTADOS                                                  Vlr. Total"
			@ CABPREFECTO(),00 PSAY Repl("-",80) 

			Do While !Eof() .And. SRV->SRV_NUMOSV+SRV->SRV_TIPTEM+SRV->SRV_CODCLI+SRV->SRV_LOJCLI+SRV->SRV_CHAINT == aOsImp[nOsImp,3]+aOsImp[nOsImp,4]+aOsImp[nOsImp,1]+aOsImp[nOsImp,2]+aOsImp[nOsImp,5]
		
  		      cDescri := SRV->SRV_DESCRI+space(55)
   		   nTamDesc := 55
			   DbSelectArea("VOK")
	   		DbSetOrder(1)
	      	DbSeek(xFilial("VOK")+SRV->SRV_TIPSER)
			   DbSelectArea("SB1")
		   	DbSetOrder(7)
	   	   DbSeek(xFilial("SB1")+VOK->VOK_GRUITE+VOK->VOK_CODITE)
	      	DbSelectArea("VO2")
	   	   DbSetOrder(1)
   	   	DbSeek(xFilial("VO2")+VO1->VO1_NUMOSV+"S")
	   	   DbSelectArea("VO4")
   	   	DbSetOrder(1)
	      	DbSeek(xFilial("VO4")+VO2->VO2_NOSNUM+SRV->SRV_TIPTEM+SRV->SRV_CODIGO)
		     	nTemPad := SRV->SRV_TEMPAD
            IF !( VOK->VOK_INCMOB == "0" .and. VOK->VOK_TIPHOR == "2" )
//		   	   @ CABPREFECTO(),00 PSAY LEFT(SRV->SRV_CODIGO,8) +"  "+ substr(cDescri,1,nTamDesc)+"    "+SB1->B1_UM+" "+Transform(nTemPad,"@R 99999:99")+TRANS((((SRV->SRV_VALSRV+SRV->SRV_VALDES)/nTemPad)*100),"@E 99999,999.99")+TRANS(SRV->SRV_VALSRV+SRV->SRV_VALDES,"@E 9999999,999.99")
		   	   @ CABPREFECTO(),00 PSAY LEFT(SRV->SRV_CODIGO,8) +"  "+ substr(cDescri,1,nTamDesc)+TRANS(SRV->SRV_VALSRV,"@E 999,999,999.99")
		   	   If !Empty(alltrim(substr(cDescri,nTamDesc+1,nTamDesc)))
			   	   nlin++
						@ nLin,10 PSAY substr(cDescri,nTamDesc+1,nTamDesc)
					EndIf
     		   	aTotaliz[1,1] += SRV->SRV_VALSRV
	     		   aTotaliz[3,1] += SRV->SRV_VALSRV-SRV->SRV_VALDES
		         aTotaliz[1,2] += SRV->SRV_VALDES
   		      aTotaliz[3,2] += SRV->SRV_VALDES
      		Else 
//			      @ CABPREFECTO(),00 PSAY LEFT(SRV->SRV_CODIGO,8) +"  "+ substr(cDescri,1,nTamDesc)+"    "+SB1->B1_UM+" "+Transform(nTemPad,"@R 99999:99")+"  *****  CORTESIA  *****  "
			      @ CABPREFECTO(),00 PSAY LEFT(SRV->SRV_CODIGO,8) +"  "+ substr(cDescri,1,nTamDesc)+" ***** CORTESIA *****"
		   	   If !Empty(alltrim(substr(cDescri,nTamDesc+1,nTamDesc)))
				      nlin++
						@ nLin,10 PSAY substr(cDescri,nTamDesc+1,nTamDesc)
					EndIf
				EndIf
				cObs := "Obs.: "
     	   	DbSelectArea("SYP")
		   	DbSetOrder(1)
   	      DbSeek( xFilial("SYP") + VO4->VO4_OBSMEM )
  	   	   While !Eof() .and. SYP->YP_CHAVE == VO4->VO4_OBSMEM
					cDescri := Alltrim(SYP->YP_TEXTO)
					nTamDesc := AT("\13\10",cDescri)
					If nTamDesc > 0
						nTamDesc-- 
					Else
						nTamDesc := Len(cDescri)
					EndIf
			      @ CABPREFECTO(),00 PSAY cObs+substr(cDescri,1,nTamDesc)
   			   cObs := "      "
         	   DbSelectArea("SYP")
            	DbSkip()
	         EndDo
   	
				IncRegua()
			
				DbSelectArea("SRV")
				DbSkip()
			EndDo
   	
			@ CABPREFECTO(),00 PSAY Repl("-",80) 
   	   @ CABPREFECTO(),38 PSAY "SUB-TOTAL DE SERVICO: "+TRANS(aTotaliz[1,1],"@E 99999999,999,999.99")               
      	@ CABPREFECTO(),38 PSAY "DESCONTOS...........: "+TRANS(aTotaliz[1,2],"@E 99999999,999,999.99")                  
	      @ CABPREFECTO(),38 PSAY "TOTAL DE SERVICO....: "+TRANS(aTotaliz[1,1]-aTotaliz[1,2],"@E 99999999,999,999.99")
   	   nLin++
	      aTotaliz[1,1] := 0
	   	aTotaliz[1,2] := 0
		EndIf

		cQuebraGruTp := ""

	   DbSelectArea("PEC")
//	   DbSetOrder(4)
	   DbSetOrder(5)
   	DbSeek( aOsImp[nOsImp,3]+aOsImp[nOsImp,1]+aOsImp[nOsImp,2]+aOsImp[nOsImp,5]+aOsImp[nOsImp,4] )

		If PEC->(Found())  

			@ CABPREFECTO(),00 PSAY Repl("-",80) 
			@ CABPREFECTO(),00 PSAY "PECAS UTILIZADAS                          UM   Quant.  Vlr. Unit.    Vlr. Total"
			@ CABPREFECTO(),00 PSAY Repl("-",80) 
	
			Do While !Eof() .And. PEC->PEC_NUMOSV+PEC->PEC_CODCLI+PEC->PEC_LOJCLI+PEC->PEC_CHAINT+PEC->PEC_TIPTEM == aOsImp[nOsImp,3]+aOsImp[nOsImp,1]+aOsImp[nOsImp,2]+aOsImp[nOsImp,5]+aOsImp[nOsImp,4]

				If PEC->PEC_QTDITE == 0
					DbSelectArea("PEC")
					DbSkip()
					Loop
				EndIf

			   DbSelectArea("SB1")
	   		DbSetOrder(1)
	      	DbSeek(xFilial("SB1")+left(PEC->PEC_CODIGO,6))
		      @ CABPREFECTO(),00 PSAY LEFT(PEC->PEC_CODIGO,8) +" "+ left(SB1->B1_DESC+space(32),32)+" "+SB1->B1_UM+" "+Transform(PEC->PEC_QTDITE,"@R 99999.99")+TRANS(((PEC->PEC_VALTOT)/PEC->PEC_QTDITE),"@E 99999,999.99")+TRANS(PEC->PEC_VALTOT,"@E 9999999,999.99")
			   aTotaliz[2,1] += PEC->PEC_VALTOT
	   		aTotaliz[3,1] += PEC->PEC_VALTOT-PEC->PEC_VALDES
         	aTotaliz[2,2] += PEC->PEC_VALDES
	         aTotaliz[3,2] += PEC->PEC_VALDES
			
				IncRegua()

				DbSelectArea("PEC")
				DbSkip()
			EndDo
		
			@ CABPREFECTO(),00 PSAY Repl("-",80) 
      	@ CABPREFECTO(),38 PSAY "SUB-TOTAL DE PECAS..: "+TRANS(aTotaliz[2,1],"@E 99999999,999,999.99")               
	      @ CABPREFECTO(),38 PSAY "DESCONTOS...........: "+TRANS(aTotaliz[2,2],"@E 99999999,999,999.99")                  
   	   @ CABPREFECTO(),38 PSAY "TOTAL DE PECAS......: "+TRANS(aTotaliz[2,1]-aTotaliz[2,2],"@E 99999999,999,999.99")
	      nLin++ 
	      aTotaliz[2,1] := 0
	   	aTotaliz[2,2] := 0
		EndIf

		nTotTOS += aTotaliz[3,1]
		aTotaliz[3,2] := 0
		aTotaliz[3,1] := 0

	EndIf
		
Next
	
If nTotTOS > 1
	@ CABPREFECTO(),00 PSAY Repl("=",80) 
	nLin++
	@ CABPREFECTO(),38 PSAY "TOTAL PECAS/SERVICOS: " + Transform(nTotTOS,"@E 9999,999,999,999.99")
EndIf

If lCheckObserv
	nLin++
	@ CABPREFECTO(),00 PSAY left(Repl("=",3)+" Observacoes do Pre-fechamento "+Repl("=",80),80)
	For nObs := 1 to Len( cObserv ) Step 100
		@ CABPREFECTO(),08 PSAY Substr( cObserv , nObs , 100 )
	Next
EndIf

nLin+=3 
@ CABPREFECTO(),03 PSAY Repl("_",25) + space(23) + Repl("_",25)  
@ CABPREFECTO(),09 PSAY "Recepcionista" + space(35) + "Administracao"

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CABPREFECTºAutor  ³Fabio               º Data ³  05/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cabecalho do pre-fechamento                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CABPREFECTO()

SetPrvt("cTitulo , cabec1 , cabec2 , nomeprog , tamanho , nCaracter")
SetPrvt("cbTxt,cbCont,cString,Li,m_Pag,nomeprog,cTitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter")

cbTxt    := Space(10)
cbCont   := 0
cString  := cAliasSrv
Li       := 80
cTitulo	:= SM0->M0_NOMECOM+" OS por Cliente e Prod/Serv"
cabec1 	:= ""
cabec2 	:= ""
tamanho	:="P"
nCaracter:=18

nLin++
If nLin > 58
   nLin := 0
   nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1
	nLin++
EndIf

Return( nLin )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS_DADOSCLºAutor  ³Fabio               º Data ³  05/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dados do cliente cabecalho                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_DADOSCLI()   
   lVei := .t.   
   lCli := .t.
   @ CABPREFECTO(),25 PSAY "ORDEM DE SERVICO: " + VO1->VO1_NUMOSV
   nLin++
	If left(VV1->VV1_CHASSI,7) == "INTERNO" .and. Empty(VO1->VO1_FATPAR)
		lVei := .f.
		lCli := .f.
	ElseIf left(VV1->VV1_CHASSI,7) == "INTERNO" .and. !Empty(VO1->VO1_FATPAR)
		lVei := .f.
		lCli := .t.
	EndIf	
	@ CABPREFECTO(),00 PSAY "Cliente.: " + LEFT(If(lCli,SA1->A1_COD,space(6)),6)+" "+LEFT(If(lCli,SA1->A1_NOME," ")+space(31),31)+"| Placa..: "+If(lVei,TRANS(VV1->VV1_PLAVEI,"@R XXX-9999")," ")
   @ CABPREFECTO(),00 PSAY "Endereco: " + LEFT(If(lCli,SA1->A1_END," ")+space(38),38)+"| Modelo.: "+If(lVei,LEFT(VV2->VV2_DESMOD,17)," ")
	@ CABPREFECTO(),00 PSAY "Bairro..: " + LEFT(If(lCli,SA1->A1_BAIRRO," ")+space(38),38)+"| Marca..: "+If(lVei,LEFT(VE1->VE1_DESMAR,17)," ")
   @ CABPREFECTO(),00 PSAY "Cidade..: " + LEFT(If(lCli,SA1->A1_MUN," ")+space(38),38)+"| Chassi.: "+If(lVei,LEFT(ALLTRIM(VV1->VV1_CHASSI),17)," ")
	@ CABPREFECTO(),00 PSAY "Telefone: " + LEFT(If(lCli,SA1->A1_TEL," ")+space(38),38)+"| Ano....: "+If(lVei,TRANS(VV1->VV1_FABMOD,"@R 9999/9999")," ")
   @ CABPREFECTO(),00 PSAY "CNPJ/CPF: " + LEFT(If(lCli,TRANS(SA1->A1_CGC,"@R 99.999.999/9999-99")," ")+space(38),38)+"| Odomet.: "+If(lVei,TRANS(VO1->VO1_KILOME,"@E 999,999,999")," ")
	@ CABPREFECTO(),00 PSAY "Insc....: " + LEFT(If(lCli,SA1->A1_INSCR," ")+space(38),38)+"| Frota..: "+If(lVei,LEFT(VV1->VV1_CODFRO,15)," ")
   @ CABPREFECTO(),00 PSAY "Contato.: " + LEFT(If(lCli,SA1->A1_CONTATO," ")+space(38),38)+"| CPF Mot: "+If(lVei,TRANS(VO1->VO1_CPFMOT,"@R 999.999.999-99")," ")
	@ CABPREFECTO(),48 PSAY "| Motoris: "+If(lVei,LEFT(VO1->VO1_MOTORI+space(15),15)," ")
   @ CABPREFECTO(),00 PSAY Replicate("-",80) 
Return
