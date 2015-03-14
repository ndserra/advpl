#INCLUDE "Eicdi450.ch"
#INCLUDE "rwmake.ch"  
#INCLUDE "AVERAGE.CH"

#DEFINE cPicVL "@E 999,999,999.99"
#DEFINE cPicNo "@E 9999"


/*/                       

Funcao    : EICDI450()
Objetivo  : Impressao do Relatorio de Demourrage
Parametro : ARMADOR - Valida o Armador no pergunte. 
              DATAS - Valida se a data final e > que a data inicial nos perguntes.
Autor     : Osman Medeiros Jr.
Data      : 13/07/2001 19:34
Observacao:                       

/*/

*----------------------------------------------------*
User Function EICDI450()
*----------------------------------------------------*
Local lRet :=.T.,cPrograma := ''

If Type('ParamIXB') == 'C'
   cPrograma := ParamIXB
EndIf  

If cPrograma == 'ARMADOR' 
   lRet := DI450_ValAr(MV_PAR03)
ElseIf cPrograma == 'DATAS'
   lRet := DI450_ValDt()
Else
   DI450_Rel()
Endif

Return lRet 


*----------------------------------------------------*
Static Function DI450_Rel()
*----------------------------------------------------*

Local aOrd         := {}
Local cDesc1       := ""
Local cDesc2       := ""
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := STR0001 //"Relatorio de Demourrage"
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.

Private nLin         := 80
Private cInd         := ""
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "EICDI450"
Private nTipo      := 15
Private aReturn    := { STR0002, 1, STR0003, 1, 2, 1, "", 1} //"Zebrado"###"Importacao"
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "EICDI450"        
Private nInd, cCond

Begin Sequence

	If !Pergunte("EICDI4",.T.)
		Break
	Endif

	nPago      := MV_PAR01  // 1-Sim , 2-Nao , 3-Ambos
	lDevolvido := If(MV_PAR02=1,.T.,.F.) // .T.=Sim , .F.=Nao 
	cArmador   := MV_PAR03   

	If nPago = 1
		If !Pergunte("EICDI5",.T.)
			Break
  	    Endif
        dDtPgIni   := MV_PAR01
        dDtPgFim   := MV_PAR02  
	Else
	    dDtPgIni   := CtoD('')
	    dDtPgFim   := CtoD('')
	Endif

	If lDevolvido 
  	    If !Pergunte("EICDI6",.T.)
			Break
  	    Endif
        dDtDvIni   := MV_PAR01
        dDtDvFim   := MV_PAR02  
	Else
	    dDtDvIni   := CtoD('')
	    dDtDvFim   := CtoD('')
	Endif

    lEmtpy := DI450QUERY(lDevolvido,dDtDvIni,dDtDvFim) //GFP - 30/03/2012
      
    If lEmtpy    //GFP - 30/03/2012
       Help(" ",1,"AVG0005112")//"Não há Dados para Impressão!"
       Break
	EndIf

	wnrel := SetPrint("SJD",NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Break
	EndIf

	SetDefault(aReturn,"SJD")

	If nLastKey == 27
	    Break
	EndIf

	nTipo := If(aReturn[4]==1,15,18)
    
    SJD->(dbSetOrder(3))
    If !Empty(cArmador) 
	   SJD->(dbSeek(xFilial("SJD")+cArmador))
	   cCond := "SJD->JD_ARMADOR = cArmador"
    Else
	   //SJD->(dbGoTop())
	   SJD->(dbSeek(xFilial("SJD")))//ACb - 20/01/2011
	   cCond := ".T."
    EndIf
    
    If !SJD->(Eof()) .And. SJD->JD_FILIAL = xFilial("SJD") .And. &(cCond)
       RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
    Else
       DI450_FIMIMP()
       break
    EndIf

End Sequence

Return

*----------------------------------------------------*
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
*----------------------------------------------------*
Local nTotPg := 0 , nTotRel := {0,0}, lDados

SetRegua(SJD->(RecCount()))
If !Empty(cArmador) 
   SJD->(dbSeek(xFilial("SJD")+cArmador))
Else
   //SJD->(dbGoTop())
   SJD->(dbSeek(xFilial("SJD")))//ACb - 20/01/2011
EndIf
 
lImpArmador := .t.
lImpProc    := .t.

While !SJD->(Eof()) .And. SJD->JD_FILIAL = xFilial("SJD") .And. &(cCond) 
	lImpTots := .f.  
	IncRegua()
/*/
         1         2         3         4         5         6         7         8        9          10        11        12        13
123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
      Processo              Dt.Atracacao         No. da D.I.     Dt.Embarque    Dt.Desemb.      Tot.Containers     Conts.Recebido
      XXXXXXXXXXXXXXXXX         99/99/99       99/9999999-99        99/99/99      99/99/99                9999               9999
Nr. Container  Tipo Container    Moeda  Dt.Devolucao Dt.Pagto.  Periodo                 No. Dias   Moeda Estrageira  Moeda Nacional
9999-999999/9  CONTAINER 40' HC    XXX      99/99/99  99/99/99  De 99/99/99 a 99/99/99      9999     999,999,999.99  999,999,999.99
               														                             Total do Container: 999,999,999.99					
               														                              Total do Processo: 999,999,999.99					
               														                               Total do Armador: 999,999,999.99					                														                              
/*/               																			
	SW6->(dbSetOrder(1))
	SW6->(dbSeek(xFilial("SW6")+SJD->JD_HAWB))
	
	If lAbortPrint
		@nLin,00 PSAY STR0030 //"*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf

	If nPago = 1
		If SJD->JD_PAGO_EM < dDtPgIni .Or. SJD->JD_PAGO_EM > dDtPgFim
			SJD->(dbSkip())
			Loop
		Endif  	  
	ElseIf nPago = 2
		If !Empty(SJD->JD_PAGO_EM)
			SJD->(dbSkip())
			Loop
		Endif  	       
	Endif
               
	If lDevolvido 
		If SJD->JD_DEVOLUC < dDtDvIni .Or. SJD->JD_DEVOLUC > dDtDvFim
			SJD->(dbSkip())
			Loop
		Endif  	  
	Else
		If !Empty(SJD->JD_DEVOLUC) 
			SJD->(dbSkip())
			Loop
		Endif  	       
	Endif

	If nLin > 60 
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5 
		nLin  := nLin + 1  
		@nLin,007 PSAY STR0012 //"Processo"
		@nLin,029 PSAY STR0013 //"Dt.Atracacao"
		@nLin,050 PSAY STR0014 //"No. da D.I."
		@nLin,066 PSAY STR0015 //"Dt.Embarque"
		@nLin,081 PSAY STR0016 //"Dt.Desemb."
		@nLin,097 PSAY STR0017 //"Tot.Containers"
		@nLin,116 PSAY STR0018 //"Conts.Recebido"
		nLin  := nLin + 1  
		@nLin,001 PSAY STR0019 //"Nr. Container"
		@nLin,016 PSAY STR0020 //"Tipo Container"
		@nLin,034 PSAY STR0021 //"Moeda"
		@nLin,041 PSAY STR0022 //"Dt.Devolucao"
		@nLin,054 PSAY STR0023 //"Dt.Pagto."
		@nLin,065 PSAY STR0024 //"Periodo"
		@nLin,089 PSAY STR0025 //"No. Dias"
		@nLin,100 PSAY STR0026 //"Moeda Estrageira"
		@nLin,118 PSAY STR0027 //"Moeda Nacional"
		nLin  := nLin + 1  
		@nLin,001 PSAY REPL("-",132)
		nLin  := nLin + 1  
		lImpArmador := .t.
		lImpProc    := .t.
		lDados      := .T.
	EndIf
	
	If lImpArmador
		nLin := nLin + 1  
        If (SJD->JD_ARMADOR=SW6->W6_ARMADOR,cDif := "",cDif := STR0031)        // "Armador Diferente do Processo"
		@nLin,01  PSAY STR0004 + SJD->JD_ARMADOR + " - " + Posicione("SY5",1,xFilial("SY5")+SJD->JD_ARMADOR,"Y5_NOME")+"  *"+cDif //"Armador: " 
		nLin := nLin + 1  
		lImpArmador := .f.
	EndIf

	If lImpProc
		nLin := nLin + 1  
		@nLin,07  PSAY SW6->W6_HAWB
		@nLin,33  PSAY SW6->W6_CHEG
		@nLin,48  PSAY Transform(SW6->W6_DI_NUM,(AVSX3("W6_DI_NUM",6)))
		@nLin,69  PSAY SW6->W6_DT_EMB
		@nLin,83  PSAY SW6->W6_DT_DESE
		@nLin,107 PSAY Transform(SW6->W6_CONTA20+SW6->W6_CONTA40+SW6->W6_CON40HC+SW6->W6_OUTROS,cPicNo)
		@nLin,126 PSAY Transform(SW6->W6_TOT_REC,cPicNo)   
		nLin := nLin + 1  
		lImpProc    := .f.
	Endif   

	@nLin,01 PSAY Transform(SJD->JD_CONTAIN,AVSX3("JD_CONTAIN",6))
	@nLin,16 PSAY AllTrim(Tabela('C3',SJD->JD_TIPO_CT))
	@nLin,36 PSAY SJD->JD_MOEDA
	@nLin,45 PSAY DtoC(SJD->JD_DEVOLUC)
	@nLin,55 PSAY DtoC(SJD->JD_PAGO_EM)
 
	If !Empty(SJD->JD_DEVOLUC)

		nInd  := 1        
		nTotPg:=0
         
		nDias := (SJD->JD_DEVOLUC - SW6->W6_CHEG) /*+ 1*/ // TDF - 05/04/11  
 
		cVar1 := 'SJD->JD_ATE'+AllTrim(Str(nInd))
		cVar2 := 'SJD->JD_VAL'+AllTrim(Str(nInd))

		dDiaDe:= SW6->W6_CHEG  
         
		nSaldoDias := 0
		nSaldoAnt  := 0 
      
		Do While Type('SJD->JD_ATE'+AllTrim(Str(nInd))) <> "U" .And.;
                 Type('SJD->JD_VAL'+AllTrim(Str(nInd))) <> "U" .And. nDias >= nSaldoDias                              

			If nInd = 1
				nSaldoDias += &cVar1   
				nDiasCalc  := nSaldoDias   
			Else
				nSaldoDias += (&cVar1 - nSaldoDias) 
				nDiasCalc  := (&cVar1 - nSaldoAnt) 
			Endif
       
			If nSaldoDias >= nDias
				nSaldoDias := nSaldoAnt + (nDias - nSaldoAnt)
				nDiasCalc  := nDias - nSaldoAnt                    
				nPag       := &cVar2 * nDiasCalc      
				If !Empty(SJD->JD_MOEDA)
				    //nPagNac    := nPag * BuscaTaxa(SJD->JD_MOEDA,dDataBase,,.f.) 
					nPagNac    := nPag * BuscaTaxa(SJD->JD_MOEDA,IF(!EMPTY(SJD->JD_PAGO_EM),SJD->JD_PAGO_EM,dDataBase),,.f.) //NCF - 12/01/2010  
				Else
					nPagNac    := nPag 
				EndIf
				nTotPg     += nPagNac 
				dDiaA      := dDiaDe + nDiasCalc      
			Else
				nPag       := &cVar2 * nDiasCalc      
				If !Empty(SJD->JD_MOEDA) 
					//nPagNac    := nPag * BuscaTaxa(SJD->JD_MOEDA,dDataBase,,.f.)
					nPagNac    := nPag * BuscaTaxa(SJD->JD_MOEDA,IF(!EMPTY(SJD->JD_PAGO_EM),SJD->JD_PAGO_EM,dDataBase),,.f.) //NCF - 12/01/2010
				Else
					nPagNac    := nPag 
				EndIf
				nTotPg     += nPagNac
				dDiaA      := dDiaDe + nDiasCalc
				/* TDF - 29/09/10 - Para calcular o dDiaA, devemos contar o dia dDiaDe como o primeiro dia.
				//por isso quando desejamos um período de 10 dias devemos somar apenas 9.*/ 
				dDiaA      := dDiaA - 1//FSY - 30/04/2013 - Ambev
			Endif
       
			nSaldoAnt := nSaldoDias
      
			nInd++
  
			@nLin,65  PSAY STR0005 + DtoC(dDiaDe) + STR0006 + DtoC(dDiaA) //"De "###" a "
			@nLin,93  PSAY Transform(nDiasCalc,cPicNo)

			If &cVar2 > 0 
				@nLin,102 PSAY Transform(nPag,cPicVL)
				@nLin,118 PSAY Transform(nPagNac,cPicVL)
			Else                
				@nLin,102 PSAY STR0007 //"        ISENTO"
				@nLin,118 PSAY STR0007 //"        ISENTO"
			Endif

			cVar1 := 'SJD->JD_ATE'+AllTrim(Str(nInd))
			cVar2 := 'SJD->JD_VAL'+AllTrim(Str(nInd))
	             
			If Type('SJD->JD_ATE'+AllTrim(Str(nInd))) <> "U" .And. Type('SJD->JD_VAL'+AllTrim(Str(nInd))) <> "U" 
				dDiaDe:= dDiaA  + 1 
			EndIf   
             
			nLin  := nLin + 1  
   
		EndDo             
    
		If nDias > nSaldoDias
			nDiasCalc := nDias - nSaldoDias
            nPag      := SJD->JD_ATRASO * nDiasCalc        
			If !Empty(SJD->JD_MOEDA) 
				//nPagNac    := nPag * BuscaTaxa(SJD->JD_MOEDA,dDataBase,,.f.)
				nPagNac    := nPag * BuscaTaxa(SJD->JD_MOEDA,IF(!EMPTY(SJD->JD_PAGO_EM),SJD->JD_PAGO_EM,dDataBase),,.f.) //NCF - 12/01/2010
			Else
				nPagNac    := nPag 
			EndIf
			nTotPg    += nPagNac 
			@nLin,65  PSAY STR0008 + DtoC(dDiaA) //"Apos "
			@nLin,93  PSAY Transform(nDiasCalc,cPicNo)
			@nLin,102 PSAY Transform(nPag,cPicVL)
			@nLin,118 PSAY Transform(nPagNac,cPicVL)

			nLin  := nLin + 1  

		Endif                 

		@nLin,098 PSAY STR0009 //"Total do Container:"
		@nLin,118 PSAY Transform(nTotPg,cPicVL)

		nLin  := nLin + 1  
         
	EndIf
      
	nTotRel[1] += nTotPg   // Sub-Total por Processo
	nTotRel[2] += nTotPg   // Sub-Total por Armador
	lImpTots   := .t.
  
	cArmaAnt := SJD->JD_ARMADOR
	cProcAnt := SJD->JD_HAWB
     
	SJD->(dbSkip())  

	If lImpTots
		If cProcAnt <> SJD->JD_HAWB .Or. cArmaAnt <> SJD->JD_ARMADOR 
			nLin  := nLin + 1  
			@nLin,099 PSAY STR0010 //"Total do Processo:"
			@nLin,118 PSAY Transform(nTotRel[1],cPicVL)
			nLin       := nLin + 1  
			lImpProc   := .t.
			nTotRel[1] := 0 
		Endif
		If cArmaAnt <> SJD->JD_ARMADOR                              
			@nLin,100 PSAY STR0011 //"Total do Armador:"
			@nLin,118 PSAY Transform(nTotRel[2],cPicVL)
			lImpArmador := .t.      
			nTotRel[2]  := 0   
		Endif
	EndIf
    
EndDo

If lDados
   nLin  := nLin + 1  
   @nLin,01  PSAY ""
EndIf

DI450_FIMIMP()

Return

*----------------------------------------------------*
Static Function DI450_FimImp()
*----------------------------------------------------*
SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
EndIf

MS_FLUSH()

Return .T.


*----------------------------------------------------*
Static Function DI450_ValAr(cArmador)
*----------------------------------------------------*
Local lRet := .t.

If !Empty(cArmador)
    SY5->(dbSetOrder(1))
    If SY5->(dbSeek(xFilial("SY5")+cArmador))
		If SY5->Y5_TIPOAGE <> "4"
		    Help("", 1,"AVG0000660")
            Return .f.
		EndIf
	Else
        Help("", 1,"AVG0003033") // Codigo do Armador nao Encontrado.
        Return .f.	
	EndIf	
EndIf	

Return lRet

*----------------------------------------------------*
Static Function DI450_ValDt()
*----------------------------------------------------*
Local lRet := .t.
      
If MV_PAR02 < MV_PAR01
   MsgInfo(STR0028,STR0029) //"Data Final não pode ser menor que Data Inicial"###"Aviso"
   lRet := .f.
Endif   

Return lRet

/*
Funcao    : DI450QUERY()
Objetivo  : Filtro de registros
Parametro : lDevolvido - Flag de registros com data de devolução do conteiner
            dDtDvIni - Data Inicial
            dDtDvFim - Data Final
Autor     : Guilherme Fernandes Pilan - GFP
Data      : 30/03/2012 - 15h18                              
*/
*----------------------------------------------------*
Static Function DI450QUERY(lDevolvido,dDtDvIni,dDtDvFim)
*----------------------------------------------------*
Local lEmpty := .F.
Local cQuery := ""
Local aOrd := SaveOrd({"SJD"})

If select("WorkSJD") > 0
   WorkSJD->(dbClosearea())
EndIf

If lDevolvido
   //Filtra por datas fornecidas no Pergunte.
   cQuery := "Select * From " + RetSqlName("SJD") + " where D_E_L_E_T_ <> '*' And JD_DEVOLUC <> '' And (JD_DEVOLUC > " + DtoS(dDtDvIni) + " And JD_DEVOLUC < " + DtoS(dDtDvFim) + ")"
Else
   cQuery := "Select * From " + RetSqlName("SJD") + " where D_E_L_E_T_ <> '*' And JD_DEVOLUC = ''"
EndIf

cQuery := ChangeQuery(cQuery)
DBUseArea(.T., "TopConn", TCGenQry(,, cQuery), "WorkSJD", .T., .T.) 
      
lEmpty := WorkSJD->(Eof()) .AND. WorkSJD->(Bof()) 

RestOrd(aOrd,.T.)

Return lEmpty