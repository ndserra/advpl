#INCLUDE "ScrFsArg.ch"
#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ScrFsArg  ³ Autor ³ Diego Fernando Rivero  ³Fecha ³ 17.04.01³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Impresion del Cupon Fiscal                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ HASAR SMH/P-PR4F o SMH/PL-8F                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ScrFsArg()

Local cA1TIPO	    :=	""
Local cProduto	    :=	""
Local cVend			:= SL1->L1_VEND
Local cCond			:= SL1->L1_CONDPG
Local cCgc          := ""
Local cTipoID       := ""
Local cHasar1
Local cHasar2
Local cUnit         := ""
Local cValDescIt    := ""
Local cQuant        := ""
Local cTmpHas       := ""
Local cRetorno	    := ""
Local cLinVend      := ""
Local cLinCond      := ""
Local cLinCliente   := ""
Local cDescProd     := ""
Local cLine         := ""
Local cTotAcrs      := ""
Local cDescTotal    := ""
Local cIncluiIVA    := "B"  //Se T indica que o preco contem IVA incluido. Se B, o IVA eh discriminado
Local nQuant	    :=	0
Local nAliq
Local nAliqIVA
Local nX
Local nPosHas
Local nVlrUnit
Local nImp
Local nJuros		:=	PARAMIXB[9]
Local nTotalDesc	:=	PARAMIXB[1]
Local nVlrTot		:= SL1->L1_VLRTOT
Local nTamL1DOC     := TamSX3("L1_DOC")[1]
Local nPosProd      := 0
Local nPosQuant     := 0
Local nPosUnit      := 0
Local nPosDesc      := 0
Local nPosPrcTab    := 0
Local nPosVItem     := 0
Local nPosVDesc     := 0
Local nRet          := 1
Local nI
Local lFirst	    :=	.T.
Local aRet          := {}
Local aFormPgto     := {{"$"},{"CC"},{"CD"},{"CH"}}
Local cNumCupFis    := TamSx3("L1_NUMCFIS")[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a data do sistema eh a mesma data da impressora fiscal. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ChIFDatArg()
	Return (.F.)
EndIf

nPosProd	:=	Ascan(aHeader,{|X| Alltrim(x[2])=="L2_PRODUTO"})
nPosQuant   :=  Ascan(aHeader,{|X| Alltrim(x[2])=="L2_QUANT"})
nPosUnit	:=	Ascan(aHeader,{|X| Alltrim(x[2])=="L2_VRUNIT"})
nPosDesc	:=	Ascan(aHeader,{|X| Alltrim(x[2])=="L2_DESCRI"})
nPosVItem   :=  Ascan(aHeader,{|X| Alltrim(x[2])=="L2_VLRITEM"}) 
nPosVDesc   :=  Ascan(aHeader,{|X| Alltrim(x[2])=="L2_VALDESC"})
nPosPrcTab  :=  Ascan(aHeader,{|X| Alltrim(x[2])=="L2_PRCTAB"})
cTmpHas     :=  Alltrim(GetMV("MV_IMPSIVA",,"IVA|"))  //Codigo dos impostos que somam no IVA
nPosHas	    :=	AT("|",cTmpHas)
nPosHas	    :=	IIf(nPosHas==0,Len(cTmpHas),nPosHas)
cHasar1	    :=	Substr(cTmpHas,1,nPosHas-1)
cHasar2	    :=	Substr(cTmpHas,nPosHas+1)

lFirst   := ( ParamIxb[15] == 1 )

If lFirst    //Cabecalho
   
   lFirst   := .F.
   cRetorno := Space(40)
   nRet     := IFStatus(nHdlECF, '5', @cRetorno)      

   If nRet == 1 
      Return( .F. )
   EndIf      

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³se exitir cupom aberto, faz o cancelamento e abre um novo.          ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
   If nRet = 7
	  nRet := IFCancCup( nHdlECF )
	  If L010AskImp(.F.,nRet)
		 Return (.F.)
	  EndIf
	  Inkey(8)   // dá um tempo para a impressora fazer a impressao do cancelamento
   Endif

   nRet := IFPegPDV(nHdlECF, @cNumPdv)  

   aRet  := LjStr2Array(cNumPDV)
   If nRet == 1 

      Return( .F. )
   EndIf      
   cNumPDV  := aRet[1]      

   SA3->(DbSetOrder(1))
   SA3->(DbSeek( xFilial("SA3") + cVend ))

   If SA3->(Found())
      cLinVend  := "Vendedor: " + Alltrim(cVend) + " " + Capital( SA3->(A3_NOME) )
      //aRet := ExecHsr( Chr(93) + "|4|Vendedor: " + Alltrim(cVend) + " " + Capital( SA3->(A3_NOME) ) )
   Else
      cLinVend  := " "
//      aRet := ExecHsr( Chr(93) + "|4| " )
   End

   SE4->(DbSetOrder(1))
   SE4->(DbSeek( xFilial("SE4") + cCond ))

   If SE4->(Found())
      cLinCond   := "Cond. de Pago: " + Capital( SE4->(E4_DESCRI) )
//      aRet := ExecHsr( Chr(93) + "|5|Cond. de Pago: " + Capital( SE4->(E4_DESCRI) ) )
   Else
      cLinCond   := " "   
//      aRet := ExecHsr( Chr(93) + "|5| "  )
   End

   Do Case
      Case SA1->A1_TIPO = "X"
         cA1Tipo := "E"    //Isento
      Case SA1->A1_TIPO = "F" .or. Empty( SA1->A1_TIPO )
         cA1Tipo := "C"   //Consumidor Final
      Case SA1->A1_TIPO = "S"
         cA1Tipo := "A"   //Nao responsavel
      Case SA1->A1_TIPO = "Z"
         cA1Tipo := "I"   //Responsavel Inscrito
      OtherWise
         cA1Tipo := SA1->A1_TIPO
   EndCase
   If SA1->A1_TIPO == "F"
      cCgc     := SA1->A1_RG
      cTipoID  := "2"   //DNI - Documento Nacional de Identidad
   Else
      cCgc     := Alltrim( SA1->A1_CGC )
      cTipoID  := "C"  //CUIT
      If Empty(cCGC)
         MsgAlert(STR0001,STR0002) //"O cliente nao tem CUIT cadastrado. Nao sera gerada a nota fiscal."###"Atualize os dados do cliente!"
         GrabLogHsr(STR0003 + SL1->L1_NUM ) //"O cliente nao tem CUIT cadastrado "
         Return( .F. )
      EndIf
      If !Cuit(cCGC,"A1_CGC")
         MsgAlert(STR0004,STR0002) //"O cliente nao tem CUIT valido cadastrado. Nao sera gerada a nota fiscal."###"Atualize os dados do cliente!"
         GrabLogHsr(STR0005 + SL1->L1_NUM  ) //"O CUIT e invalido "
         Return( .F. )
      EndIf
   Endif
   cLinCliente  := Padr(Substr(SA1->A1_NOME,1,30),30) + ;       
                   "|" + StrTran( AllTrim(cCGC), "-", "" ) + ;
                   "|" + cA1Tipo + ;
                   "|" + cTipoID
/*   aRet  := ExecHsr( "b|" + OemToAnsi( SA1->A1_COD + " - " + AllTrim( SA1->A1_NOME ) ) + ;
               "|" + StrTran( AllTrim(cCGC), "-", "" ) + ;
               "|" + cA1Tipo + ;
               "|" + cTipoID+;
               "|" + OemToAnsi( SA1->A1_END ) )

   If !HsrStat( aRet[1], aRet[2], STR0006 ) //"Dados do Cliente"
      aRet   := ExecHsr( Chr( 152 ) )   // Cancel
      GrabLogHsr( aRet[1] + ' ' + aRet[2] + ' ' + STR0007 + SL1->L1_NUM ) //"Dados do Cliente "
      Return( .F. )
   EndIf
*/
                    
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Abre o Cupom Fiscal                                        ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   cSerie  := IIF( cA1Tipo $ "INZ", "A", "B" )
   cRetorno:= cSerie+"|"+cLinCliente+"|"+cLinVend+"|"+cLinCond
   nRet    := IFAbreCup(nHdlECF, cRetorno)      
//   aRet  := ExecHsr( "@|" + cSerie +  "|T" )   
//   aRet  := LjStr2Array(cRetorno)   
   If nRet == 1
//      GrabLogHsr( aRet[1] + ' ' + aRet[2] + ' ' + STR0009 + SL1->L1_NUM ) //"Abertura de Documento "   
      Return( .F. )   
   EndIf

/*   If !HsrStat( aRet[1], aRet[2], STR0008 ) //"Abertura de Documento"
      GrabLogHsr( aRet[1] + ' ' + aRet[2] + ' ' + STR0009 + SL1->L1_NUM ) //"Abertura de Documento "   
      nRet  := IFCancCup(nHdlECF)
//      aRet   := ExecHsr( Chr( 152 ) )   // Cancel      
      Return( .F. )
   EndIf
*/
   cRetorno   := Space(nTamL1DOC)
   nRet       := IFPegCupom( nHdlECF, @cRetorno, "D|"+AllTrim(cSerie))
   If nRet == 1
      Return( .F. )      
   EndIf   

   cNumNota := StrZero(Val(cRetorno),nTamL1DOC,0)
   cNumNota := cNumPdv + Substr( cNumNota,1+Len(cNumPdv),Len(cNumNota)-Len(cNumPdv) )

/*   If Len( aRet ) < 3  .Or. ValType( aRet[3] ) != 'C'
      MsgAlert( STR0023, STR0024 )         //"Erro na abertura do Documento!"###"Erro da Impressora Fiscal"
      GrabLogHsr( STR0025 + SL1->L1_NUM ) //"Erro na abertura do Documento, nao retorna numero de Documento "
      nRet  := IFCancCup(nHdlECF)
//      aRet   := ExecHsr( Chr( 152 ) )   // Cancel      
      Return( .F. )
   EndIf
*/   

   Return( .T. )

Endif   //Fim do cabecalho

For nX	:=	1	To Len(aCols)
	If !aCols[nX][Len(aCols[nX])]

        nAliqIVA := 0
		nAliq    := 0
		cUnit	  := ""
		cValDescIt:= ""
		
		cProduto	:=	aCols[nX][nPosProd]
		cDescrip    :=	aCols[nX][nPosDesc]
		nQuant      :=	aCols[nX][nPosQuant]
//		If nTotalDesc == 0
//			nVlrUnit	:=	aCols[nX][nPosVItem]+aCols[nX][nPosVDesc]/aCols[nX][nPosQuant]
//		Else
			nVlrUnit	:=	aCols[nX][nPosPrcTab]
//		EndIf
		// Posiciona produto para pegar a descricao.
		SB1->( DBSetOrder( 1 ) )
		SB1->( DBSeek( xFilial( "SB1" ) + cProduto ) )

		cQuant     := Str(nQuant,12,3)
		cUnit      := Str(nVlrUnit,12,4)
		cValDescIt := Str(aCols[nX][nPosVDesc],9,2)

		For nImp := 1 to Len(aImps[nX][6])
			If aImps[nX][6][nImp][3] > 0
				If Upper(Alltrim(aImps[nX][6][nImp][1])) $ cHasar1     //Os impostos que soman no IVA
				   nAliqIVA := nAliqIVA + aImps[nX][6][nImp][2]
				ElseIf Upper(Alltrim(aImps[nX][6][nImp][1])) $ cHasar2 //Os impostos internos
                   nAliq    := nAliq + aImps[nX][6][nImp][2]
				Endif
			Endif
		Next
        
        cProduto  := Padr(cProduto,20)
		cDescProd := Padr( SubStr( cDescrip, 1, 30 ), 30 )
        cRetorno  := " "
        nRet      := IFRegItem(nHdlECF,cProduto,cDescProd,AllTrim(cQuant),AllTrim(cUnit),cValDescIt,Alltrim(Str(nAliqIVA,5,2));
                               +"|"+Alltrim(Str(nAliq,4,2))+"|"+cIncluiIVA)
/*		aRet     := ExecHsr( "B" +;
							"|" + OemToAnsi( cDescProd ) +;         // Descripcion
							"|" + AllTrim(cQuant) +;                // Cantidad
							"|" + AllTrim(cUnit) +;                 // Precio Unitario
							"|" + Alltrim(Str(nAliqIVA,5,2)) +;     // Alicuota de IVA
							"|M" +;	                                 
							"|%" + Alltrim(Str(nAliq,5,2)) +;       // Impuestos Internos
							"|0" +;                                 // Parametro Display
							"|s" )

*/      
        If nRet  == 1 
           Return(.F.)
        EndIf
/*		If !HsrStat( aRet[1], aRet[2], STR0010 + cProduto ) //"Dados do Produto "
            nRet  := IFCancCup(nHdlECF)		
//			aRet   := ExecHsr( Chr( 152 ) )   // Cancel
			GrabLogHsr( aRet[1] + ' ' + aRet[2] + ' ' + STR0010 + SL1->L1_NUM ) //"Dados do Produto "
			Return( .F. )
		EndIf
*/
	Endif
Next
If nJuros <= 0
   	SE4->(DbSetOrder(1))
   	SE4->(DbSeek( xFilial("SE4") + cCond ))
	If nTotalDesc <> 0 .Or. SE4->E4_DESCFIN <> 0
		cDescTotal := " |"+Strzero(SL1->L1_DESCONT,12,2)+"|0|"
		IFDescTot(nHdlECF,cDescTotal)
//		aRet := ExecHsr( "T| |" + cDescTotal + "|m|0|B" )
	Endif
Else
	// Acrescimo em valor no total
	cTotAcrs   := " |"+StrZero( nVlrTot * nJuros / 100,12,2)+"|0|"
	IFAcresTot(nHdlECF,cTotAcrs)
//	ExecHsr( "T| |"+cTotAcrs+"|M|0|T")
EndIf

If !ScrImprTot()
   Return(.F.)
EndIf
nLineRod	:=	11

SL4->(DbSeek(xFilial()+SL1->L1_NUM))

While !SL4->(EOF()) .And. SL4->L4_NUM == SL1->L1_NUM
	If IsMoney(Alltrim(SL4->L4_FORMA))
		If Len(aFormPgto[1]) == 1
			AAdd(aFormPgto[1],Round(SL4->L4_VALOR,2))
		Else 
			aFormPgto[1][2] += Round(SL4->L4_VALOR,2)
		EndIf
//		aRet := ExecHsr( "D|Efectivo|"+Alltrim(Str(Round(SL4->L4_VALOR,2),14,2))+"|T|0" )
   	EndIf

	If Alltrim(SL4->L4_FORMA) == "CC" .Or. Alltrim(SL4->L4_FORMA) == "CD"
		If Alltrim(SL4->L4_FORMA) == "CC"
			If Len(aFormPgto[2]) == 1
				AAdd(aFormPgto[2],{Substr(SL4->L4_ADMINIST,1,3),Capital(Tabela("24",Alltrim(SL4->L4_FORMA),.F.)),;
				     Capital(Alltrim(Posicione("SAE",1,xFilial("SAE")+Substr(SL4->L4_ADMINIST,1,3),"SAE->AE_DESC"))),;
				     Alltrim(SL4->L4_NUMCART)})
			Else 
				nPos := aScan(aFormPgto[2],{|x| Trim(x[1])==Substr(SL4->L4_ADMINIST,1,3)},2)
				If nPos <> 0
					aFormPgto[2][nPos][4] += "/"+Alltrim(SL4->L4_NUMCART)
				Else
					AAdd(aFormPgto[2],{Substr(SL4->L4_ADMINIST,1,3),Capital(Tabela("24",Alltrim(SL4->L4_FORMA),.F.)),;
					     Capital(Alltrim(Posicione("SAE",1,xFilial("SAE")+Substr(SL4->L4_ADMINIST,1,3),"SAE->AE_DESC"))),;
					     Alltrim(SL4->L4_NUMCART)})
				EndIf
			EndIF				
		Else
			If Len(aFormPgto[3]) == 1
				AAdd(aFormPgto[3],{Substr(SL4->L4_ADMINIST,1,3),Capital(Tabela("24",Alltrim(SL4->L4_FORMA),.F.)),;
				     Capital(Alltrim(Posicione("SAE",1,xFilial("SAE")+Substr(SL4->L4_ADMINIST,1,3),"SAE->AE_DESC"))),;
				     Alltrim(SL4->L4_NUMCART)})
			Else 
				nPos := aScan(aFormPgto[2],{|x| Trim(x[1])==Substr(SL4->L4_ADMINIST,1,3)},2)
				If nPos <> 0
					aFormPgto[3][nPos][4] += "/"+Alltrim(SL4->L4_NUMCART)
				Else
					AAdd(aFormPgto[3],{Substr(SL4->L4_ADMINIST,1,3),Capital(Tabela("24",Alltrim(SL4->L4_FORMA),.F.)),;
					     Capital(Alltrim(Posicione("SAE",1,xFilial("SAE")+Substr(SL4->L4_ADMINIST,1,3),"SAE->AE_DESC"))),;
					     Alltrim(SL4->L4_NUMCART)})
				EndIF
			EndIF				
		EndIf
//		aRet := ExecHsr(Chr(93) +cLine)
//		aRet := ExecHsr(Chr(93) +cLine2)
	Endif

	If Alltrim(SL4->L4_FORMA) == "CH"
		If Len(aFormPgto[4]) == 1
			AAdd(aFormPgto[4],{Alltrim(SL4->L4_ADMINIST),Alltrim(SL4->L4_AGENCIA),Alltrim(SL4->L4_CONTA),;
			     SL4->L4_RG,Alltrim(SL4->L4_NUMCART)})				
		Else 
			nPos := aScan(aFormPgto[4],{|x| Trim(x[1])==Alltrim(SL4->L4_ADMINIST) .And. Trim(x[2])==Alltrim(SL4->L4_AGENCIA) .And. Trim(x[3])==Alltrim(SL4->L4_CONTA)},2)
			If nPos <> 0
				aFormPgto[4][nPos][5] += "/"+Alltrim(SL4->L4_NUMCART)
			Else
				AAdd(aFormPgto[4],{Alltrim(SL4->L4_ADMINIST),Alltrim(SL4->L4_AGENCIA),Alltrim(SL4->L4_CONTA),;
				     SL4->L4_RG,Alltrim(SL4->L4_NUMCART)})				
			EndIF
		EndIF				
//		aRet := ExecHsr(Chr(93) +cLine)
//		aRet := ExecHsr(Chr(93) +cLine2)
	Endif

	SL4->(DbSkip())
Enddo

For nI :=  1 To Len(aFormPgto)
	If nI == 1 .AND. LEN(aFormPgto[nI]) > 1
		cLine := Substr("|Efectivo "+Alltrim(Str(aFormPgto[nI][02],14,2)),1,40)
//		aRet := ExecHsr( "D|Efectivo|"+Alltrim(Str(Round(SL4->L4_VALOR,2),14,2))+"|T|0" )
	EndIf

	If nI == 2 .Or. nI == 3
		For nX := 2 To Len(aFormPgto[nI])
			cLine += "|"+aFormPgto[nI][nX][2]+" "+aFormPgto[nI][nX][3]+" Nro "+aFormPgto[nI][nX][4]
		Next nX
//		aRet := ExecHsr(Chr(93) +cLine)
//		aRet := ExecHsr(Chr(93) +cLine2)
	EndIf
	
	If nI == 4                                  
		For nX := 2 To Len(aFormPgto[nI])
			cLine += "|Banco : "+aFormPgto[nI][nX][01]+"-"+aFormPgto[nI][nX][02]+"-"+aFormPgto[nI][nX][03]+" Doc : "+aFormPgto[nI][nX][04]+" Cheque "+aFormPgto[nI][nX][05]
		Next nX
//		aRet := ExecHsr(Chr(93) +cLine)
//		aRet := ExecHsr(Chr(93) +cLine2)
	EndIf	
Next nI

If Empty( SL1->L1_NROPCLI )
    cLine  += Padr(Substr(("|Presupuesto Nro: "  + SL1->L1_NUM),1,40),40)
//	aRet := ExecHsr(  Chr(93) + "|14|Presupuesto Nro: "  + SL1->L1_NUM )
Else	
    cLine  += Padr(Substr(("|Presupuesto Nro: "  + SL1->L1_NUM),1,40),40)
    cLine  += Padr(Substr(("|Orden de Compra Nro: "  + SL1->L1_NROPCLI),1,40),40)
//	aRet := ExecHsr(  Chr(93) + "|14|Presupuesto Nro: "  + SL1->L1_NUM + "  Orden de Compra Nro: "  + SL1->L1_NROPCLI )
EndIf

nRet     := IFFechaCup( nHdlECF,cLine )	
If nRet == 1
   Return(.F.)
EndIf
//aRet   := ExecHsr( 'E' )              // CloseFiscalReceipt

/*If !HsrStat( aRet[1], aRet[2] )
    nRet  := IFCancCup(nHdlECF)
//	aRet   := ExecHsr( Chr( 152 ) )   // Cancel
	GrabLogHsr( aRet[1] + ' ' + aRet[2] + ' ' + "CloseFiscalReceipt " + SL1->L1_NUM )
	Return( .F. )
EndIf
*/

//SE4->( DbSetOrder(1) )
//SE4->( DbSeek( xFilial('SE4') + SL1->L1_CONDPG ) )

/*aRet := ExecHsr(  Chr(93) + "|11|" + Chr(127) )
aRet := ExecHsr(  Chr(93) + "|12|" + Chr(127) )
aRet := ExecHsr(  Chr(93) + "|13|" + Chr(127) )
aRet := ExecHsr(  Chr(93) + "|14|" + Chr(127) )
*/

//GrabLogHsr( aRet[1] + ' ' + aRet[2] + ' ' + STR0011 + SL1->L1_NUM ) //"Fim de Impressao"

Return(  .T.  )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ GrabLogHsr³ Autor ³ Diego Fernando Rivero ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Grabacion de Log                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ HASAR SMH/PL-8F y SMHP-PR4F                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrabLogHsr( cText )
Local cFile	:= '\LOGHASAR\'

xNumCaixa()

cFile += SA6->A6_COD + SubStr(  Dtos( dDataBase ), 5 ) + '.LOG'

If !File(cFile)
	nHnd	:= FCreate( cFile )
Else
	nHnd	:= FOpen( cFile, 2 )
EndIf

FSeek( nHnd, 0, 2 )
FWrite( nHnd, Time() + '  ' + cText + Chr(13) + Chr(10) )

FClose( nHnd )

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ HsrStat   ³ Autor ³ Diego Fernando Rivero ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Control de Errores para impresora Hasar.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ HASAR SMH/PL-8F y SMHP-PR4F                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function HsrStat( cPrinter, cFiscal, cTitle, lMsgBox )

Local cMsg
Local lRet    := .T.
Local cBinPrn := Hex2Bin( cPrinter )
Local cBinFis := Hex2Bin( cFiscal  )                     

If ValType( lMsgBox ) != 'L'
   lMsgBox := .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificacion de Status de la Impresora                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDieghoÄÄÙ
// Bit  0 - Siempre Cero
// Bit  1 - Siempre Cero
// Bit  2 - 1 = Error de Impresora
// Bit  3 - 1 = Impresora Off-line
// Bit  4 - 1 = Falta Papel del Diario
// Bit  5 - 1 = Falta Papel de Tickets
// Bit  6 - 1 = Buffer de Impresora Lleno
// Bit  7 - 1 = Buffer de Impresora Vacio
// Bit  8 - 1 = Tapa de Impresora Abierta
// Bit  9 - Siempre Cero
// Bit 10 - Siempre Cero
// Bit 11 - Siempre Cero
// Bit 12 - Siempre Cero
// Bit 13 - Siempre Cero
// Bit 14 - 1 = Cajon de dinero cerrado o ausente
// Bit 15 - 1 = OR logico de los bits 2-5, 8 y 14

If SubStr( cBinPrn, 14, 1 ) == '1'  // Bit 2                                        
   lRet    := .F.
   MsgAlert( STR0026 , STR0027 ) //"Erro de Impressora Fiscal"###"Verificar Problema"   
EndIf
If SubStr( cBinPrn, 13, 1 ) == '1'  // Bit 3
   lRet    := .F.
   MsgAlert( STR0028 , STR0027 ) //"Impressora Fiscal Off-Line!"###"Verificar Problema"
EndIf
If SubStr( cBinPrn, 12, 1 ) == '1'  // Bit 4
   lRet    := .F.
   MsgAlert( STR0029 , STR0027 ) //"Falta Papel em Impressora Fiscal"###"Verificar Problema"
EndIf
If SubStr( cBinPrn, 11, 1 ) == '1'  // Bit 5
   lRet    := .F.
   MsgAlert( STR0030 , STR0027 ) //"Falta Papel na Impressora Fiscal"###"Verificar Problema"
EndIf
If SubStr( cBinPrn, 10, 1 ) == '1'  // Bit 8
   lRet    := .F.
   MsgAlert( STR0031, STR0027 ) //"Tampa de Impressora Aberta!"###"Verificar Problema"
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificacion de Status Fiscal                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Bit  0 - 1 = Error en chequeo de memoria fiscal
// Bit  1 - 1 = Error en chequeo de memoria de trabajo
// Bit  2 - Siempre Cero
// Bit  3 - 1 = Comando Desconocido
// Bit  4 - 1 = Datos no validos en un campo
// Bit  5 - 1 = Comando no valido para el estado fiscal actual
// Bit  6 - 1 = Desborde del Total
// Bit  7 - 1 = Memoria Fiscal llena, bloqueada o dada de baja
// Bit  8 - 1 = Memoria Fiscal a punto de llenarse
// Bit  9 - 1 = Terminal fiscal certificada
// Bit 10 - 1 = Terminal dfiscal fiscalizada
// Bit 11 - 1 = Error en ingreso de fecha
// Bit 12 - 1 = Documento Fiscal Abierto
// Bit 13 - 1 = Documento Abierto
// Bit 14 - Siempre Cero
// Bit 15 - 1 = OR logico de los bits 0 a 8

If Left( cBinFis, 1 ) == '1'   // Bit 15

   If SubStr( cBinFis, 16, 1 ) == '1'  // Bit 0
      cMsg := STR0012 //"Error no Check de Memoria Fiscal. Terminal Bloqueado!"

   ElseIf SubStr( cBinFis, 15, 1 ) == '1'  // Bit 1
      cMsg := STR0013 //"Error no Check de Memoria de Trabalho. Terminal Bloqueado!"

   ElseIf SubStr( cBinFis, 13, 1 ) == '1'  // Bit 3
      cMsg := STR0014 //"Comando Desconhecido"

   ElseIf SubStr( cBinFis, 12, 1 ) == '1'  // Bit 4
      cMsg := STR0015 //"Dados Nao Validos em um Campo"

   ElseIf SubStr( cBinFis, 11, 1 ) == '1'  // Bit 5
      cMsg := STR0016 //"Comando Nao Valido para o Estado Fiscal Atual"

   ElseIf SubStr( cBinFis, 10, 1 ) == '1'  // Bit 6
      cMsg := STR0017 //"Acima do Total"

   ElseIf SubStr( cBinFis,  9, 1 ) == '1'  // Bit 7
      cMsg := STR0018 //"Memoria Fiscal cheia, bloqueada ou dada de baixa. Terminal Bloqueado!"

   ElseIf SubStr( cBinFis,  8, 1 ) == '1'  // Bit 8
      cMsg := STR0019 //"Memoria Fiscal a ponto de ser totalmente preenchida!"

   Else
      cMsg := STR0020 //"Error nao determinado na Impressora Fiscal!"

   EndIf

   If lMsgBox
      MsgAlert( cMsg, 'HASAR' + Iif( ValType(cTitle)<>'C', '', ' - ' + cTitle ) )
      lRet := .F.
   Else
      lRet := cMsg
   EndIf

EndIf

Return( lRet )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n   ³ Hex2Bin   ³ Autor ³ Diego Fernando Rivero ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ HASAR SMH/PL-8F                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Hex2Bin( cHex )

Local nX, cChar, nPos
Local cRet := ''
Local cAux := '0123456789ABCDEF'
Local aHex := { '0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111', ;
                '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111' }

For nX := 1 To Len( cHex )
   cChar := Upper( SubStr( cHex, nX, 1 ) )
	nPos  := At( cChar, cAux )
	If nPos <> 0
		cRet += aHex[nPos]
	EndIf
Next

Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ScrImprTotºAutor  ³Diego Fernando      º Data ³  18/04/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Hace la impresion del total tender en la factura            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SigaLoja                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ScrImprTot()
Local nX, nY
Local nTotPag := 0
Local nDif
Local nRet    := 1
Local _nIVA
Local _nTotal
Local nIBP, nIB2
Local bGrava :=	{|| .T. }
Local aRet   := {}
Local cAliqIVA  := ""
Local cTexto    := ""
Local cValor    := ""
Local cRetorno  := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perceptions - Impresion de Percepciones  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aImps   := If(Type("aImps") == "A",aClone(aImps),{}) 
nIB2    := 0
nIBP    := 0
For nX := 1 To Len( aImps )
	For nY := 1 To Len( aImps[nX][6] )
		If aImps[nX][6][nY][1] $ "IB2" .and. aImps[nX][6][nY][4] != 0
			nIB2	+=	aImps[nX][6][nY][4]
		ElseIf aImps[nX][6][nY][1] $ "IBP" .and. aImps[nX][6][nY][4] != 0
			nIBP	+=	aImps[nX][6][nY][4]
		Endif 
	Next
Next

If nIB2 > 0                 
    cAliqIVA  := "**.**"
    cTexto    := "Perc. 2,0% Bs.As."
    cValor    := Alltrim(Str(nIB2,14,2))
    nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cValor, @aRet)        
    If nRet == 1
       Return(.F.)
    EndIf

Endif

If nIBP > 0
    cAliqIVA  := "**.**"
    cTexto    := "Perc. 1,5% Cap.Fed"
    cValor    := Alltrim(Str(nIBP,14,2))
    aRet      := {}
    nRet      := IFPercepcao(nHdlECF, cAliqIVA, cTexto, cValor, @aRet)    
    If nRet == 1
       Return(.F.)
    EndIf    

Endif

xNumCaixa()

cRetorno  := " |c|0" + Space(50)
nRet      := IFSubTotal(nHdlECF,@cRetorno)
If nRet == 1
   Return(.F.)
EndIf
//aRet    := ExecHsr( "C||c|0" )  //Sub-Total

aRet     := LjStr2Array(cRetorno)
If Len( aRet ) < 3
   MsgAlert( STR0034, STR0024 )         //"Erro no Sub-Total do documento"###"Erro da Impressora Fiscal"
   GrabLogHsr( STR0035 + SL1->L1_NUM ) //"Erro no Sub-Total, nao retorna os dados do documento"                         
   nRet  := IFCancCup(nHdlECF)
   If nRet == 1
      Return( .F. )      
   EndIf   

   Return( .F. )
EndIf

_nTotal  := Val( aRet[4] )  //Total da venda
_nIVA    := Val( aRet[5] )  //Total de IVA

_nIVA    := If(_nIVA==NIL,0,_nIVA)
_nTotal  := If(_nTotal==NIL,0,_nTotal)
nTotPag	 :=	_nTotal

If AllTrim(FunName()) == "LOJA010"
	nReceb :=	0
	For nX := 1 To Len(aReceb)
		nReceb	+=	aReceb[1,2]
	Next
	nDif	:=	(_nTotal-nReceb)
	If nDif > 0
		aReceb[1,2]	 += nDif
		Do Case
			Case Trim(aReceb[1][3]) == "$"
				bGrava	:=	{|x| SL1->L1_DINHEIRO += x }
			Case Trim(aReceb[1][3]) == "CH"
				bGrava	:=	{|x| SL1->L1_CHEQUES  += x }
			Case Trim(aReceb[1][3]) == "CC"
				bGrava	:=	{|x| SL1->L1_CARTAO   += x }
			Case Trim(aReceb[1][3]) == "CD"
				bGrava	:=	{|x| SL1->L1_VLRDEBI  += x }
			Case Trim(aReceb[1][3]) == "CO"
				bGrava	:=	{|x| SL1->L1_CONVENI  += x }
			Case Trim(aReceb[1][3]) == "VA"
				bGrava   := {|x| SL1->L1_VALES    += x }
			Case Trim(aReceb[1][3]) == "FI"
				bGrava	:=	{|x| SL1->L1_FINANC   += x }
			Otherwise
				bGrava	:=	{|x| SL1->L1_OUTROS   += x }
		Endcase
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TotalTender - Total pagado en letras   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cRetorno  := Padr(Substr(Extenso(Round(nTotPag,2)),1,30),30)+"|"+Alltrim(Str(Round(nTotPag,2),14,2))
nRet      := IFPagto(nHdlECF,cRetorno)
If nRet == 1
   Return(.F.)
EndIf

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³ CheckIFData ³ Autor ³ Danilo Calil        ³ Data ³ 20/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica se a data do sistema eh a mesma data da impressora ³±±
±±³			 ³ fiscal.													   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ChIFDatArg -> ExpL    						       		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 	     ³ SigaLoja (Venda R pida e Venda Balcao )					   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ChIFDatArg()
Local nRet	   := 0		// Retorno da funcao da dll
Local lRet     := .T.	// Variavel de controle
Local cRetorno := ""	// Retorno do ECF

If lFiscal
	nRet := IFStatus( nHdlECF, '2', @cRetorno )
	If nRet == 0 .AND. CtoD( cRetorno ) <> dDataBase
		MsgStop( OemToAnsi( STR0036 ), OemToAnsi( STR0037 ) )     // Data da impressora fiscal diferente da data do sistema.
		lRet := .F.
	EndIf                      
EndIf  

Return( lRet )