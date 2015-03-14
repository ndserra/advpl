#INCLUDE "RTMSR24.ch"
#INCLUDE "protheus.ch"                               
#INCLUDE "rwmake.ch"

Static lAWBRepete := DTX->(FieldPos("DTX_CODCIA")) > 0 
Static lDT8_DIGAWB:= ( DT8->(FieldPos("DT8_DIGAWB")) > 0 ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RTMSR24  ºAutor  ³Richard Anderson    º Data ³  26/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa de impressao de AWB's emitidas, faturadas e       º±±
±±º          ³ não faturadas                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RTMSR24                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMSR24()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           
Local cDesc1  	 := "Este relatorio ira imprimir dependendo da seleção as AWB´s emitidas, "
Local cDesc2  	 := "faturadas e não faturadas"
Local cDesc3  	 := ""
Local cPerg     := "RTMSR24"
Local Titulo  	 := "Relatório de AWB´s"
Local nLin      := 80
Local Cabec1    := "No.AWB    Dig. Data Emissao Cia Aerea                           Fil.Orig. Fil.Destino Aeroporto Orig. Aeroporto Destino       Valor AWB       ICMS     Vl.Decresc.    Vl.AWB Desc. "
Local Cabec2    := ""
Local Cabec3    := "Fatura         Data Fatura  Valor Fatura Valor IRPF Vl.Comissao Valor ISS Desc. Ret. "
Local lContinua := .T.
Local aOrd      := {}
Local cAliasQry := GetNextAlias() 

Private lEnd    	  := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private Limite   	  := 220
Private Tamanho  	  := "G"
Private NomeProg 	  := "RTMSR24"
Private nTipo    	  := 0
Private aReturn  	  := { STR0006, 1, STR0007, 2, 2, 1, "", 1} //"Zebrado"###"Administracao"
Private nLastKey    := 0
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel    	  := "RTMSR24" 
Private cString     := " " 
Private cInd        := ''

//                                                                                                    1         1         1         1         1         1         1             
//          1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         1
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//No.AWB    Dig. Data Emissão Cia Aerea                           Fil.Orig. Fil.Destino Aeroporto Orig. Aeroporto Destino       Valor AWB       ICMS     Vl.Decresc.    Vl.AWB Desc. "
//999999999 9    99/99/99     999999999/9999 12345678901234567890 XX        XX          XXX             XXX                999,999,999.99 999,999.99  999,999,999.99  999,999,999.99 "
//
//Fatura         Data Fatura  Valor Fatura Valor IRPF Vl.Comissao Valor ISS Desc. Ret.
//999999999      99/99/99     9,999,999.99 999,999.99  999,999.99 99,999.99 999,999.99

Rtmsr24SX1(cPerg)

DbSelectArea('DTV')
DbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                         

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RTMSR24Fil(cAliasQry) 	//Chama os filtros

Titulo := Alltrim(Titulo) + " ["+Iif(mv_par09 == 1,'Emitidas',Iif(mv_par09 == 2,'não Faturadas', 'Faturadas'))+"]"
nTipo  := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Cabec3,Titulo,nLin,cAliasQry) },Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RunReport ºAutor  ³Richard Anderson    º Data ³  26/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao que monta o layout de impressão                     º±±
±±º          ³ conforme os parametros informados                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunReport(Cabec1,Cabec2,Cabec3,Titulo,nLin,cAliasQry)

Local	nQtAWB    := 0
Local	nTVAWB    := 0
Local	nTValImp  := 0
Local	nTDecres  := 0
Local	nTVAWBDec := 0
Local aAreaAtu  := GetArea()
Local cFatura   := ""
Local cCodCia   := ""
Local cLojCia   := ""
Local lImpFat   := .T.
Local bWhile    := {|| (cAliasQry)->(!Eof()) }

If mv_par09 == 3
	bWhile   := {|| (cAliasQry)->(!Eof()) .And. (cAliasQry)->(DTV_FATURA+DTV_CODCIA+DTV_LOJCIA) == cFatura+cCodCia+cLojCia }
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())
While (cAliasQry)->(!Eof())

	cFatura := (cAliasQry)->DTV_FATURA
	cCodCia := (cAliasQry)->DTV_CODCIA
	cLojCia := (cAliasQry)->DTV_LOJCIA
	lImpFat := (mv_par09 == 3)
	
	While Eval(bWhile)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 //determina tamanho da linha
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
			nLin    := 9 
			lImpFat := (mv_par09 == 3)
		EndIf
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		EndIf 
		
		If lAWBRepete
			If lDT8_DIGAWB
				nValImp := Posicione("DT8",3,xFilial("DT8")+(cAliasQry)->(DTV_NUMAWB+DTV_DIGAWB+DTV_CODCIA+DTV_LOJCIA)+"TF","DT8_VALIMP")
			Else
				nValImp := Posicione("DT8",3,xFilial("DT8")+(cAliasQry)->(DTV_NUMAWB+DTV_CODCIA+DTV_LOJCIA)+"TF","DT8_VALIMP")
			EndIf
		Else
			If lDT8_DIGAWB
				nValImp := Posicione("DT8",3,xFilial("DT8")+(cAliasQry)->DTV_NUMAWB+DTV_DIGAWB+"TF","DT8_VALIMP")
			Else
				nValImp := Posicione("DT8",3,xFilial("DT8")+(cAliasQry)->DTV_NUMAWB+"TF","DT8_VALIMP")
			EndIf
		EndIf
		
		If lImpFat
			nLin++
			@ nLin,000 PSay Cabec3
			nLin++
			@ nLin,000 PSay (cAliasQry)->DTV_FATURA
			@ nLin,015 PSay (cAliasQry)->DD8_DATLIB
			@ nLin,028 PSay Transform((cAliasQry)->DD8_VALOR ,"@E 9,999,999.99")
			@ nLin,041 PSay Transform((cAliasQry)->DD8_IRRF  ,"@E 999,999.99")
			@ nLin,051 PSay Transform((cAliasQry)->DD8_COMISS,"@E 999,999.99")
			@ nLin,064 PSay Transform((cAliasQry)->DD8_ISS   ,"@E 99,999.99")
			@ nLin,074 PSay Transform((cAliasQry)->DD8_DECRET,"@E 999,999.99")
			nLin    += 2
			lImpFat := .F.
		EndIf		
			
		@ nLin,000 PSay (cAliasQry)->DTV_NUMAWB
		@ nLin,010 Psay (cAliasQry)->DTV_DIGAWB
		@ nLin,015 PSay (cAliasQry)->DTV_DATEMI
		@ nLin,028 PSay (cAliasQry)->(DTV_CODCIA+"-"+DTV_LOJCIA)+" "+Posicione("SA2",1,xFilial("SA2")+(cAliasQry)->(DTV_CODCIA+DTV_LOJCIA),"A2_NREDUZ")        
	   @ nLin,064 PSay (cAliasQry)->DTV_FILORI
	   @ nLin,074 PSay (cAliasQry)->DTV_FILDES
	   @ nLin,086 PSay (cAliasQry)->DTV_AERORI
	   @ nLin,102 PSay (cAliasQry)->DTV_AERDES
		@ nLin,121 PSay Transform((cAliasQry)->DTV_VAWB				   ,"@E 999,999,999.99")
		@ nLin,136 PSay Transform(nValImp                   			,"@E 999,999.99")
		@ nLin,148 PSay Transform((cAliasQry)->DTV_DECRES				,"@E 999,999,999.99")
		@ nLin,164 PSay Transform((cAliasQry)->(DTV_VAWB-DTV_DECRES),"@E 999,999,999.99")
		nLin++
	
		nQtAWB    += 1
		nTVAWB    += (cAliasQry)->DTV_VAWB
		nTValImp  += nValImp
		nTDecres  += (cAliasQry)->DTV_DECRES
		nTVAWBDec += (cAliasQry)->(DTV_VAWB-DTV_DECRES)
		
		(cAliasQry)->(dbSkip())
	EndDo
EndDo
(cAliasQry)->(dbCloseArea())
RestArea(aAreaAtu)

If nQtAWB > 0
	nLin++         
	@ nLin,000 PSAY __PrtThinLine()
	nLin++         
	@ nLin,000 PSay "Qtde. AWBs=>"
	@ nLin,016 PSay Transform(nQtAWB  ,"@E 999,999")
	nLin++         
	@ nLin,000 PSay Padr("Total",120,".")
	@ nLin,121 PSay Transform(nTVAWB   ,"@E 999,999,999.99")
	@ nLin,136 PSay Transform(nTValImp ,"@E 999,999.99")
	@ nLin,148 PSay Transform(nTDecres ,"@E 999,999,999.99")
	@ nLin,164 PSay Transform(nTVAWBDec,"@E 999,999,999.99")
	nLin++
	@ nLin,00 PSay __PrtThinLine()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil                     

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RTMSR24Fil³ Autor ³ Richard Anderson     ³ Data ³ 28/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Seleciona as informacoes                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR24                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTMSR24Fil(cAliasQry)

Local cQuery := ""

If mv_par09 == 1 .Or. mv_par09 == 2 //-- AWB´s emitidas e AWB´s não faturadas
	cQuery += " SELECT DTV_NUMAWB, DTV_DIGAWB, DTV_DATEMI AS DTV_DATEMI, DTV_CODCIA, DTV_LOJCIA, DTV_FILORI, DTV_FILDES, "
	cQuery += "        DTV_AERORI, DTV_AERDES, DTV_DECRES              , DTV_VAWB  , DTV_FATURA"
	cQuery += "   FROM "
	cQuery += RetSqlName("DTV")
	cQuery += "  WHERE DTV_FILIAL  = '"+xFilial("DTV")+"'"
	cQuery += "    AND DTV_CODCIA  BETWEEN '"+mv_par01+"' AND '"+mv_par03+"'"
	cQuery += "    AND DTV_LOJCIA  BETWEEN '"+mv_par02+"' AND '"+mv_par04+"'"
	cQuery += "    AND DTV_FILORI  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += "    AND DTV_DATEMI  BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"'"
	cQuery += "    AND DTV_BALCAO  = '2'" 
	If mv_par09 == 2 //-- AWB´s não faturadas 
		cQuery += " AND DTV_FATURA  = ' '"
	EndIf		
	cQuery += "    AND D_E_L_E_T_  = ' '"
	cQuery += "  UNION ALL "
	cQuery += " SELECT DTV_NUMAWB, DTV_DIGAWB, DTV_DATEFE AS DTV_DATEMI, DTV_CODCIA, DTV_LOJCIA, DTV_FILORI, DTV_FILDES, "
	cQuery += "        DTV_AERORI, DTV_AERDES, DTV_DECRES              , DTV_VAWB  , DTV_FATURA"
	cQuery += "   FROM "
	cQuery += RetSqlName("DTV")
	cQuery += "  WHERE DTV_FILIAL  = '"+xFilial("DTV")+"'"
	cQuery += "    AND DTV_CODCIA  BETWEEN '"+mv_par01+"' AND '"+mv_par03+"'"
	cQuery += "    AND DTV_LOJCIA  BETWEEN '"+mv_par02+"' AND '"+mv_par04+"'"
	cQuery += "    AND DTV_FILORI  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += "    AND DTV_DATEFE  BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"'"
	cQuery += "    AND DTV_BALCAO  = '1'"
	cQuery += "    AND DTV_NUMORI <> ' '"
	cQuery += "    AND DTV_DATEFE <> ' '"
	If mv_par09 == 2 //-- AWB´s não faturadas 
		cQuery += " AND DTV_FATURA  = ' '"
	EndIf		
	cQuery += "    AND D_E_L_E_T_  = ' '"
	cQuery += "  ORDER BY DTV_DATEMI,DTV_NUMAWB,DTV_DIGAWB"
Else
	cQuery := " SELECT DTV_NUMAWB, DTV_DIGAWB, DTV_DATEMI AS DTV_DATEMI, DTV_CODCIA, DTV_LOJCIA, DTV_FILORI, DTV_FILDES, "
	cQuery += "        DTV_AERORI, DTV_AERDES, DTV_DECRES              , DTV_VAWB  , DTV_FATURA, DD8_DATLIB, DD8_VALOR , "
	cQuery += "        DD8_IRRF  , DD8_COMISS, DD8_ISS                 , DD8_DECRET"
	cQuery += "   FROM "
	cQuery += RetSqlName("DTV")+" DTV, "
	cQuery += RetSqlName("DD8")+" DD8  "
	cQuery += "  WHERE DD8.DD8_FILIAL  = '"+xFilial("DD8")+"'"
	cQuery += "    AND DD8.DD8_CODCIA  BETWEEN '"+mv_par01+"' AND '"+mv_par03+"'"
	cQuery += "    AND DD8.DD8_LOJCIA  BETWEEN '"+mv_par02+"' AND '"+mv_par04+"'"
	cQuery += "    AND DD8.DD8_DATLIB  BETWEEN '"+Dtos(mv_par05)+"' AND '"+Dtos(mv_par06)+"'"
	cQuery += "    AND DTV.DTV_FILIAL  = '"+xFilial("DTV")+"'"
	cQuery += "    AND DTV.DTV_FATURA  = DD8_FATURA"
	cQuery += "    AND DTV.DTV_CODCIA  = DD8_CODCIA"
	cQuery += "    AND DTV.DTV_LOJCIA  = DD8_LOJCIA"
	cQuery += "    AND DTV.DTV_FILORI  BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += "    AND DTV.D_E_L_E_T_  = ' '"
	cQuery += "  ORDER BY DTV_FATURA,DTV_CODCIA,DTV_LOJCIA,DTV_DATEMI,DTV_NUMAWB,DTV_DIGAWB"
EndIf
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
TCSetField(cAliasQry,"DTV_DECRES","N",TamSX3("DTV_DECRES")[1],TamSX3("DTV_DECRES")[2])
TCSetField(cAliasQry,"DTV_VAWB  ","N",TamSX3("DTV_VAWB  ")[1],TamSX3("DTV_VAWB  ")[2])
TCSetField(cAliasQry,"DTV_DATEMI","D",TamSX3("DTV_DATEMI")[1],TamSX3("DTV_DATEMI")[2])
If mv_par09 == 3
	TCSetField(cAliasQry,"DD8_DATLIB","D",TamSX3("DD8_DATLIB")[1],TamSX3("DD8_DATLIB")[2])
	TCSetField(cAliasQry,"DD8_VALOR ","N",TamSX3("DD8_VALOR ")[1],TamSX3("DD8_VALOR ")[2])
	TCSetField(cAliasQry,"DD8_IRRF  ","N",TamSX3("DD8_IRRF  ")[1],TamSX3("DD8_IRRF  ")[2])
	TCSetField(cAliasQry,"DD8_COMISS","N",TamSX3("DD8_COMISS")[1],TamSX3("DD8_COMISS")[2])
	TCSetField(cAliasQry,"DD8_ISS   ","N",TamSX3("DD8_ISS   ")[1],TamSX3("DD8_ISS   ")[2])
	TCSetField(cAliasQry,"DD8_DECRET","N",TamSX3("DD8_DECRET")[1],TamSX3("DD8_DECRET")[2])
EndIf	

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RTMSR24Sx1³ Autor ³Richard Anderson    ³ Data ³ 26/03/2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Inclui Perguntas no SX1                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³RTMSR24                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTMSR24Sx1(cPerg)

Local nTamCia  := Len(DTV->DTV_CODCIA)
Local nTamLoj  := Len(DTV->DTV_LOJCIA)
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpEsp := {}

SX1->(dbSetOrder(1))
If SX1->(dbSeek(Padr(cPerg,Len(SX1->X1_GRUPO))+"09")) .And. !("Emitidas" $ SX1->X1_DEF01)
	SX1->(dbSeek(Padr(cPerg,Len(SX1->X1_GRUPO))+"01"))
	While SX1->(!Eof()) .And. SX1->X1_GRUPO == Padr(cPerg,Len(SX1->X1_GRUPO))
		RecLock("SX1",.F.)
		dbDelete()
		MsUnLock()
		SX1->(dbSkip())
	EndDo
EndIf			


aHelpPor := {}
Aadd(aHelpPor, 'Codigo da Cia Aerea.' )
PutSx1( cPerg, "01","Cia Aerea de?       ","Cia Aérea de?        ","Cia Aérea de?       ","mv_ch1","C",nTamCia,0,0,"G","","FOR","","","mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpEsp)

aHelpPor := {}
Aadd(aHelpPor, 'Loja da Cia Aerea.' )
PutSx1( cPerg, "02","Loja Cia de?        ","Loja Cia de?         ","Loja Cia de?        ","mv_ch2","C",nTamLoj,0,0,"G","",""   ,"","","mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpEsp)

aHelpPor := {}
Aadd(aHelpPor, 'Codigo da Cia Aerea.' )
PutSx1( cPerg, "03","Cia Aerea Até?      ","Cia Aérea Até?       ","Cia Aérea Até?      ","mv_ch3","C",nTamCia,0,0,"G","","FOR","","","mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpEsp)

aHelpPor := {}
Aadd(aHelpPor, 'Loja da Cia Aerea.' )
PutSx1( cPerg, "04","Loja Cia Até?       ","Loja Cia Até?        ","Loja Cia Até?       ","mv_ch4","C",nTamLoj,0,0,"G","",""   ,"","","mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpEsp)

aHelpPor := {}
Aadd(aHelpPor, 'Data Inicial.' )
PutSx1( cPerg, "05","Data de?            ","Data de?             ","Data de?            ","mv_ch5","D",8      ,0,0,"G","",""   ,"","","mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpEsp)

aHelpPor := {}
Aadd(aHelpPor, 'Data Final.' )
PutSx1( cPerg, "06","Data Até?           ","Data Até?            ","Data Até?           ","mv_ch6","D",8      ,0,0,"G","",""   ,"","","mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpEsp)

aHelpPor := {}
Aadd(aHelpPor, 'Filial Origem Inicial.' )
PutSx1( cPerg, "07","Fil.Origem de?      ","Fil.Origem de?       ","Fil.Origem de?      ","mv_ch7","C",2      ,0,0,"G","","DLB","","","mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpEsp)

aHelpPor := {}
Aadd(aHelpPor, 'Filial de Origem Final.' )
PutSx1( cPerg, "08","Fil.Origem Até?     ","Fil.Origem Até?      ","Fil.Origem Até?     ","mv_ch8","C",2      ,0,0,"G","","DLB","","","mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpEsp)

aHelpPor := {}
Aadd(aHelpPor, 'Informe o Tipo do Relatorio ser Impresso.' )
PutSX1( cPerg, '09',"Tipo do Relatório?  ","Tipo do Relatório?   ","Tipo do Relatório?  ","mv_ch9","N",1      ,0,1,"C","",""   ,"","","mv_par09","AWB´s Emitidas","AWB´s Emitidas","AWB´s Emitidas",'',"AWB´s não Fat.","AWB´s não Fat.","AWB´s não Fat.","AWB´s faturadas","AWB´s faturadas","AWB´s faturadas", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpEsp)

Return
