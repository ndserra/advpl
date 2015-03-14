#INCLUDE "protheus.ch"
Static aRemune
Static aDatasSR8


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrauPar   ºAutor  ³Rafael P. Rizzatto  ºFecha ³ 19/04/2004         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica si ha dependientes para determinado graudo del parentesco.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ENTRADA:                                                           º±±
±±º          ³ cTipo(caracter) = Grado del Parentesco                            º±±
±±º          ³                                                                   º±±
±±º          ³  C = Conjuge                                                      º±±
±±º          ³  F = Hijo                                                         º±±
±±º          ³                                                                   º±±
±±º          ³ lQtd(logico) = Indica si la funcion debe contener el nr. de       º±±
±±º          ³ dependientes ou apenas verificar a existencia.                    º±±
±±º          ³                                                                   º±±
±±º          ³ .T. = Conta el nr. de dependientes.                               º±±
±±º          ³ .F. = Verificar si ha existencia.                                 º±±
±±º          ³                                                                   º±±
±±º          ³RETORNO:                                                           º±±
±±º          ³ Se lQtd == .T. entonces,Cantidad de dependientes(Retorno numerico)º±±
±±º          ³                                                                   º±±
±±º          ³ ou                                                                º±±
±±º          ³                                                                   º±±
±±º          ³ Se lQtd == .F. entonces, S = Possui ou                            º±±
±±º          ³ N = nao possui dependientes(Retorno caracter)                     º±±
±±º          ³                                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Liquidacion                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            
User Function GrauPar(cTipo,lQtd)

Local nQtd:=0, xQtd
Local aArea := GetArea()

lQtd  := If(ValType(lQtd) == "L", lQtd, .F.) //Valores default
cTipo := If(ValType(cTipo) == "C", cTipo, "") //Valores default
	
DbSelectArea("SRB")
DbSetOrder(1)
MSSeek(SRA->RA_FILIAL + SRA->RA_MAT)
While !EOF() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRB->RB_FILIAL + SRB->RB_MAT 
	If SRB->RB_GRAUPAR == cTipo
		nQtd++       
	EndIf 
	SRB->(DbSkip())	                   
EndDo
If lQtd 
	xQtd := StrZero(nQtd,2)
Else            
	xQtd := If(nQtd>0,"S","N")
EndIf
RestArea(aArea)		
Return xQtd	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Situacion ºAutor  ³Rafael P. Rizzatto  º Data ³  19/04/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³ PARAMETROS:                                                º±±
±±º          ³                                                            º±±
±±º          ³  cVerSitua == "1", entao, verifica a situcao 1             º±±
±±º          ³  cVerSitua == "1D", entao, verifica a data da situcao 1    º±±
±±º          ³                                                            º±±
±±º          ³  cVerSitua == "2", entao, verifica a situcao 2             º±±
±±º          ³  cVerSitua == "2D", entao, verifica a data da situcao 2    º±±
±±º          ³                                                            º±±
±±º          ³  cVerSitua == "3", entao, verifica a situcao 3             º±±
±±º          ³  cVerSitua == "3D", entao, verifica a data da situcao 3    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Situacion(cVerSitua)

Local cCond   := "01"
Local aData   := {}
Local aArea   := GetArea()
cVerSitua     := If(ValType(cVerSitua) == "C", cVerSitua, "")//Valores default

If aDatasSR8 == Nil
	aDatasSR8	:=	{}
	DbSelectArea ("SR8")
	DbSetOrder(1)
	MsSeek(SRA->RA_FILIAL + SRA->RA_MAT+AnoMes(dPeriodo))
	While !EOF() .And. SRA->RA_FILIAL + SRA->RA_MAT+AnoMes(dPeriodo) == SR8->R8_FILIAL + R8_MAT+AnoMes(SR8->R8_DATAINI)
		AAdd(aDatasSR8,{SR8->R8_SITUAC, StrZero(Day(SR8->R8_DATAINI),2),SR8->R8_DATAFIM})
		aSort(aDatasSR8,,,{|aReg1,aReg2| aReg1[2] < aReg2[2]})//Ordena as datas em ordem crescente.	
		DbSkip()            	
	EndDo  
	RestArea(aArea)
Endif	
If Len(aDatasSR8) > 0
	If AnoMes(aDatasSR8[Len(aDatasSR8)][3]) > AnoMes(dPeriodo) .Or.;
		Day(aDatasSR8[Len(aDatasSR8)][3]) == Day(LastDay(dPeriodo))
		If cVerSitua == "1" .Or.cVerSitua == "0"
			cCond := aDatasSR8[Len(aDatasSR8),1]
		ElseIf cVerSitua =="1D" .Or. cVerSitua =="0D"
			cCond := aDatasSR8[Len(aDatasSR8),2]
		Endif
	Endif
Endif              

If !Empty(SRA->RA_DEMISSA) .And. AnoMes(SRA->RA_DEMISSA) == AnoMes(dPeriodo)
	cCond := "06"
Endif
               
Return cCond

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³HoraExtra ºAutor  ³Rafael P. Rizzatto  º Data ³  19/04/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Verifica se o funcionario possui horas extras.            º±±
±±º          ³                                                            º±±
±±º          ³  RETORNO:                                                  º±±
±±º          ³   nHoras == Ao total de horas extras do funcionario        º±±
±±º          ³   nHoras retornara 0 quando o funcionario nao tiver        º±±
±±º          ³   horas extras.                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HoraExtra()//**VERIFICAR COM BRUNO**. Se deve-se contabilizar o Nº de Horas ou valor.

Local nHoras := 0 //N. de horas extras.
Local aArea := GetArea()

DbSelectArea("SRC")
DbSeek(SRA->RA_FILIAL + SRA->RA_MAT)                                                
While !EOF() .And. SRA->RA_FILIAL + SRA->RA_MAT ==  SRC->RC_FILIAL + SRC->RC_MAT 
	If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_HE" ) == "S"  .And. PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_REMUNE" ) == "S"// Verifica Horas Extras!!
		nHoras += RC_VALOR
	Endif	
	DbSkip()
EndDo   

If nHoras > 0
	ValTotal(@nHoras)
Endif	
   
RestArea(aArea)
Return nHoras

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RemuneImp ºAutor  ³Rafael Rizatto      º Data ³  05/18/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna as Remuneracoes Imponiveis.                        º±±
±±º          ³                                                            º±±
±±º          ³   PARAMETROS:                                              º±±
±±º          ³    cTipo == "1" -> VERBAS   (Remunerativos/NaoRemunerativosº±±
±±º          ³    cTipo == "2" -> VERBAS   (Remunerativos)                º±±
±±º          ³    cTipo == "3" ->                    pagam impostos)      º±±
±±º          ³    cLancs == "1" -> Folha e aguinaldo                      º±±
±±º          ³    cLancs == "2" -> So Folha                               º±±
±±º          ³    cLancs == "3" -> So aguinaldo                           º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RemuneImp(cTipo,cLancs)

Local lRet   := .F.
Local nTotal := 0 //N. de horas extras.
Local nTotal13 := 0
Local aArea  := GetArea()    

DEFAULT cLancs	:=	"1" 

cTipo := If(ValType(cTipo) == "C", cTipo, "") //Valores default
If aRemune == Nil
	aRemune	:=	{}
Endif
If (nPosRes	:=	Ascan(aRemune,	{|x| x[1] ==cTipo+cLancs})) > 0
	nTotal	:=	aRemune[nPosRes][2]
Else	
	If cLancs $ '12'
		If cTipo == "1"
			DbSelectArea("SRC")
			DbSetOrder(1)
			MsSeek(SRA->RA_FILIAL + SRA->RA_MAT)                                                
			While !EOF() .And. SRA->RA_FILIAL + SRA->RA_MAT ==  SRC->RC_FILIAL + SRC->RC_MAT 
            If PosSrv(SRC->RC_PD, SRA->RA_FILIAL,"RV_REMUNE") $ "SN"
					If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"  //PROVENTOS(soma de todas as verbas) 
						nTotal += RC_VALOR
					ElseIf PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"  //DESCONTOS(soma de todas as verbas) 
						nTotal -= RC_VALOR
					Endif
				Endif
				DbSkip()
			EndDo      
		ElseIf cTipo $ "23"
			DbSelectArea("SRC")
			DbSetOrder(1)//BASE DE CALCULO(so das verbas que pagam impostos)
			MsSeek(SRA->RA_FILIAL + SRA->RA_MAT) 
			While !EOF() .And. SRA->RA_FILIAL + SRA->RA_MAT ==  SRC->RC_FILIAL + SRC->RC_MAT 
		      If PosSrv(SRC->RC_PD, SRA->RA_FILIAL,"RV_REMUNE") == "S"
					If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"  //PROVENTOS(soma de todas as verbas) 
						nTotal += RC_VALOR
					ElseIf PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"  //DESCONTOS(soma de todas as verbas) 
						nTotal -= RC_VALOR
					Endif
				Endif
				DbSkip()
			EndDo
			If cTipo == "2"      
	         If nTotal > nMaxEM
	         	nTotal := nMaxEM
	         Endif	            
	      Endif   

			DbSelectArea("SRI")
			DbSetOrder(1)//BASE DE CALCULO(so das verbas que pagam impostos)
			MsSeek(SRA->RA_FILIAL + SRA->RA_MAT) 
			While !EOF() .And. SRA->RA_FILIAL + SRA->RA_MAT ==  SRI->RI_FILIAL + SRI->RI_MAT 
            If PosSrv(SRI->RI_PD, SRA->RA_FILIAL,"RV_REMUNE") $ "S"
					If PosSrv( SRI->RI_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"  //PROVENTOS(soma de todas as verbas) 
						nTotal13 += RC_VALOR
					ElseIf PosSrv( SRI->RI_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"  //DESCONTOS(soma de todas as verbas) 
						nTotal13 -= RC_VALOR
					Endif	
				Endif	
				DbSkip()
			EndDo 
			If cTipo == "2"     // Se o Tipo for 2 o Total deve ser Limitado, caso seja 3 nao tem Limite
	         If nTotal13 > nMaxEM
	         	nTotal13 := nMaxEM
	         Endif
	      Endif   
         nTotal += nTotal13	
		EndIf
	Endif
	If cLancs $ '13'
		//E SOMADO ALEM DO VALOR ACIMA OS VALORES DE 13(1 e/ou 2 parcela)
		If Left(cMesAnoRef,2) $ "06|12"//Verifica 13 Salario. 
			DbSelectArea ("SRI")
			DbSetOrder(1)
			If	MsSeek(SRA->RA_FILIAL + SRA->RA_MAT+If(Left(cMesAnoRef,2) == "06",aCodFol[22,1],aCodFol[24,1])  )
		  		nTotal += SRI->RI_VALOR
			EndIf
		EndIf 
		If cTipo == '2' .And. cLancs == '3'
			If nTotal > 0
				ValTotal(@nTotal)
			Endif	
		Endif	
	Endif			
	RestArea(aArea)		
	aadd(aRemune,{cTipo+cLancs,nTotal})
Endif
Return nTotal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SaldoAdicionalº Autor ³Rafael P. Rizzatto  º Data ³  02/06/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o valor do Saldo Adiocional.                           º±±
±±º          ³                                                                º±±
±±º          ³                                                                º±±
±±º          ³                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SaldoAdicional() //CONCEITOS
Local aArea := GetArea()
Local nTotal := 0.00

DbSelectArea("SRC")
DbSetOrder(1)
MsSeek(SRA->RA_FILIAL + SRA->RA_MAT)                                                
While !EOF() .And. SRA->RA_FILIAL + SRA->RA_MAT ==  SRC->RC_FILIAL + SRC->RC_MAT 
	If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_REMUNE" ) == "S" 
	 	If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1" 
			nTotal += RC_VALOR
		ElseIf PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2" 
			nTotal -= RC_VALOR
		Endif
	Endif	
	DbSkip()
EndDo      

If nTotal > 0
	ValTotal(@nTotal)
Endif	

RestArea(aArea)

Return nTotal                                                                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpAdicionalOSº Autor ³Rafael P. Rizzatto  º Data ³  02/06/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o valor do Importe Adiocional.                         º±±
±±º          ³                                                                º±±
±±º          ³                                                                º±±
±±º          ³                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ImpAdicionalOS()

Local nTotal := 0.00
Local aArea := GetArea()

If FPHIST82( xFilial("SRX") , "22" ,  SRA->RA_FILIAL+SRA->RA_ASMEDIC+"2" )
	cImpOS:= SubStr ( SRX->RX_TXT ,  23 , 03 )
	DbSelectArea("SRC")
	DbSetOrder(1)
	If MsSeek(SRA->RA_FILIAL + SRA->RA_MAT+cImpOS)
		nTotal := RC_VALOR	
	Endif
Endif          
RestArea(aArea)
Return nTotal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CodigoOS  ºAutor  ³Rafael P. Rizzatto  º Data ³  02/06/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o codigo da Obra Social.                           º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CodigoOS()

Local cObra := ""
Local aArea := GetArea()

If FPHIST82( xFilial("SRX") , "22" ,  SRA->RA_FILIAL+SRA->RA_ASMEDIC+"2" )
	cObra := SubStr ( SRX->RX_TXT ,  50 , 08 )
Endif

RestArea(aArea)

Return cObra

User Function LimpiaStatic()
	aRemune	:=	Nil
	aDatasSR8:=	Nil
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SALFAMIL  ºAutor  ³Silvia Taguti       º Data ³  24/01/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o Valor do Salario Familia                         º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SalFamil()

Local aArea := GetArea()
Local nTotal := 0.00

DbSelectArea("SRC")
DbSetOrder(1)
If DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+ACODFOL[34,1])                                        
	nValor := SRC->RC_VALOR
Endif	
	
RestArea(aArea)

Return nTotal                                                                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Val_Vacac    º Autor ³Luis Trombini        º Data ³  24/01/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o valor de vacacion en el mes                          º±±
±±º          ³                                                                º±±
±±º          ³                                                                º±±
±±º          ³                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Val_Vacac() //CONCEITOS
Local aArea := GetArea()
Local nTotal := 0.00

DbSelectArea("SRC")
DbSetOrder(1)
IF dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + ACODFOL[72,1])                                   
   nTotal += RC_VALOR
Endif	

If nTotal > 0
	ValTotal(@nTotal)
Endif	

RestArea(aArea)

Return nTotal                                                                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Dias_trab    º Autor ³Luis Trombini        º Data ³  24/01/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o valor de vacacion en el mes                          º±±
±±º          ³                                                                º±±
±±º          ³                                                                º±±
±±º          ³                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Dias_Trab() //CONCEITOS
Local aArea := GetArea()
Local nTotal := 0.00
              
DbSelectArea("SRC")
DbSetOrder(1)

IF SRA->RA_CATFUNC == "M"
	DbSelectArea("SRC")
  	DbSetOrder(1)
  	If DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+ACODFOL[31,1])                                        
     	nTotal += RC_horas
  	ELSE 
   	If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + ACODFOL[48,1])                                   
   		nTotal += RC_horas
   	Endif	
	Endif   	
ELSEIF SRA->RA_CATFUNC =="H"
 	DbSeek(SRA->RA_FILIAL + SRA->RA_MAT + ACODFOL[32,1])                                   
  	While !EOF() .And. SRA->RA_FILIAL + SRA->RA_MAT + ACODFOL[32,1] ==  SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PD 
		nTotal += RC_HORAS
		DbSkip() 
  	EndDo      
  	NTOTAL := INT(ROUND(NTOTAL / 8,2))
  	IF NTOTAL == 0.00
    	NTOTAL := 1
  	ENDIF  
ELSEIF SRA->RA_CATFUNC =="E"
	If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + ACODFOL[219,1])                                   
 		nTotal += RC_HORAS
 	EndIF
ELSEIF SRA->RA_CATFUNC =="A"
  If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + "105")                                   
  		nTotal += 30
  EndIF         
ENDIF

RestArea(aArea)

Return nTotal                                                                          

                             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALTOTAL  ºAutor  ³Silvia Taguti       º Data ³  03/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se os valores ultrapassam o Limite                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function ValTotal(nTotal)

nTope := U_REMUNEIMP("2")

If nTotParc >= nTope
	nTotal := 0
ElseIf nTotal >= nTope
	nTotal := nTope
Endif	
If (nTotParc+nTotal) >= nTope
	nTotal := nTotal - (nTotParc+nTotal-nTope)
Endif	

nTotParc := nTotParc + nTotal

Return
