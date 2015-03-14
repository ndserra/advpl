#INCLUDE "FERARG.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFERARG    บAutor  ณErika Kanamori      บ Data ณ  09/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao de Recibo de Ferias da Argentina.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FERARG()   

Private aProve	:= {}
Private aDesco	:= {}
Private aBases	:= {}   
Private nTOTVENC:= 0
Private nTOTDESC:= 0

  
ImpCabecArg()

dbSelectArea( "SRR" )                          
dbSetOrder(retorder("SRR", "RR_FILIAL+RR_MAT+RR_TIPO3+DTOS(RR_DATA)"))
If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + "F" + Dtos(SRH->RH_DTRECIB) )
	While SRR->(RR_FILIAL+RR_MAT+RR_TIPO3+DTOS(RR_DATA)) == SRA->RA_FILIAL+SRA->RA_MAT+"F"+DtoS(SRH->RH_DTRECIB)
		Do Case
			Case PosSRV( SRR->RR_PD, SRA->RA_FILIAL, "RV_TIPOCOD" ) == "1"
				Aadd(aProve, {SRR->RR_PD, PosSRV( SRR->RR_PD, SRA->RA_FILIAL, "RV_DESC" ), SRR->RR_HORAS, SRR->RR_VALOR} )
				nTOTVENC+= SRR->RR_VALOR
			Case PosSRV( SRR->RR_PD, SRA->RA_FILIAL, "RV_TIPOCOD" ) == "2"
				Aadd(aDesco, {SRR->RR_PD, PosSRV( SRR->RR_PD, SRA->RA_FILIAL, "RV_DESC" ), SRR->RR_HORAS, SRR->RR_VALOR} )
				nTOTDESC+= SRR->RR_VALOR
			Case PosSRV( SRR->RR_PD, SRA->RA_FILIAL, "RV_TIPOCOD" ) $ "3|4" 		 
		 		Aadd(aBases, {SRR->RR_PD, PosSRV( SRR->RR_PD, SRA->RA_FILIAL, "RV_DESC" ), SRR->RR_HORAS, SRR->RR_VALOR} )                                                   
		EndCase
		SRR->(dbSkip())
	End
fLancaZ()
Endif

Return                                                                       





     





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ImpCabecArgบAutor  ณErika Kanamori      บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpCabecArg()

Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cCargo		:= ""		//-- Codigo do Cargo do Funcionario

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  ณ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ณ
  ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
fBuscaFunc(SRH->RH_DTRECIB, @cCodFunc, @cDescFunc   )     //VERIFICAR DDATAREF


@ ++LI,00 PSAY "*"+REPLICATE("=",130)+"*"

@ ++LI,00 PSAY "|"
@ LI,46   PSAY STR0001		//"RECIBO DE VACACIONES  "
@ LI,131  PSAY "|"

@ ++LI,00 PSAY "|"+REPLICATE("-",130)+"|"

@ ++LI,00 PSAY "|" + STR0002 + SRH->RH_PERIODO + " " + STR0003 + SRH->RH_NPAGTO   //Periodo:  //Num. Pago:
@ LI,131  PSAY "|"

@ ++LI,00 PSAY STR0004 + DESC_Fil		//"| Empregador   : "
@ LI,131  PSAY "|"

@ ++LI,00 PSAY STR0005 + Alltrim(Desc_End)+" "+Alltrim(Desc_Comp)+"-"+Desc_Est	//" Domicilio : "
@ LI,131  PSAY "|"

@ ++Li,00 PSAY STR0006 + DESC_CGC    //"| CUIT: "
@ LI,131  PSAY "|"
@ ++LI,00 PSAY STR0007 + DtoC(SRH->RH_DTRECIB)  //"| Fec. Ult. Dep.: "
@ LI,35   PSAY STR0008 + SRH->RH_PERIODO                  //"Periodo: "
@ LI,70   PSAY STR0009 + Alltrim(SRA->RA_BCDEPSA) + "-" + DescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL) //"Dep. en Bco: "
@ LI,131  PSAY "|"
@ ++LI,00 PSAY "|"+REPLICATE("-",130)+"|"
@ ++Li,00 PSAY STR0010 + SRA->RA_NOME   //"| Beneficiario: "
@ Li,45   PSAY STR0011 + SRA->RA_CIC       //"CUIL "
@ LI,130  PSAY "|"

@ ++Li,00 PSAY STR0012 + DTOC(SRA->RA_ADMISSA) //"| Fec. de Ing. "
@ Li,30   PSAY STR0013 + Substr(cDescFunc ,1,15) //"Calif. Prof "
cCargo := fGetCargo(SRA->RA_MAT)
@ Li,80   PSAY STR0014 + Substr(fDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"),1,6)  //"Tarea Cump. "
@ LI,131  PSAY "|"
LI ++
@ LI,00   PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,000  PSAY STR0015		//"| H A B E R E S "
@ LI,046  PSAY STR0016		//"  D E D U C C I O N E S"
@ LI,090  PSAY STR0017		//"  B A S E S
@ LI,131  PSAY "|"

LI ++
@ LI,00   PSAY "|"+REPLICATE("-",130)+"|"
LI++
        
Return Nil










/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfLancaZ   บAutor  ณErika Kanamori      บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fLancaZ()   // Impressao dos Lancamentos

Local nTermina  := 0
Local nCont     := 0
Local nCont1    := 0
Local nValidos  := 0
Local nTam		:= 0

nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))

For nCont := 1 To nTermina
	@ LI,00 PSAY "|"
	IF nCont <= LEN(aProve)
		@ LI,02 PSAY aProve[nCont,1]+aProve[nCont,2]+TRANSFORM(aProve[nCont,3],'999.99')+TRANSFORM(aProve[nCont,4],"@E 99,999,999")
	ENDIF
	@ LI,44 PSAY "|"
	IF nCont <= LEN(aDesco)
		@ LI,46 PSAY aDesco[nCont,1]+aDesco[nCont,2]+TRANSFORM(aDesco[nCont,3],'999.99')+TRANSFORM(aDesco[nCont,4],"@E 99,999,999")
	ENDIF
	@ LI,88 PSAY "|"
	IF nCont <= LEN(aBases)
		@ LI,90 PSAY aBases[nCont,1]+aBases[nCont,2]+TRANSFORM(aBases[nCont,3],'999.99')+TRANSFORM(aBases[nCont,4],"@E 99,999,999")
	ENDIF
	@ LI,131 PSAY "|"
	
	//---- Soma 1 nos nValidos e Linha
	nValidos ++
	Li ++
	
	If nValidos = 10
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
		LI ++
		@ LI,00 PSAY "|"
		@ LI,05 PSAY STR0018			// "CONTINUA !!!"
		//		@ LI,76 PSAY "|"+&cCompac
		LI ++
		@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
		LI += 8
		If li >= 60
			li := 0
		Endif

		ImpCabecArg()

		nValidos := 0
	ENDIF
Next nCont

For nCont1 := nValidos+1 To 10
	@ Li,00  PSAY "|"
	@ Li,44  PSAY "|"
	@ Li,88  PSAY "|"
	@ Li,131 PSAY "|"
	Li++
Next nCont1


fRodapeAr()


Li += 1

//Quebrar pagina
If LI > 63
	LI := 0
EndIf
Return Nil







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRodapeAr บAutor  ณErika Kanamori      บ Data ณ  09/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRodapeAr()

@ LI,00   PSAY "|"+REPLICATE("-",130)+"|"
@ ++LI,00 PSAY "| " + STR0019 + TRANS(nTOTVENC,"@E 99,999,999,999")  //" TOTAL DE HABERES "
@ LI,44   PSAY STR0020 +TRANS(nTOTDESC,"@E 99,999,999,999")            //"| IMPORTE NETO "
@ LI,88   PSAY STR0021 +TRANS((nTOTVENC-nTOTDESC),"@E 99,999,999,999") //"| IMPORTE NETO A COBRAR "
@ LI,131  PSAY "|"
@ ++LI,00 PSAY "|" + REPLICATE("-",130)+"|"
Li ++
@ Li,00   PSAY STR0022 + MesExtenso(MONTH(SRH->RH_DTRECIB)) + STR0023 + STR(YEAR(SRH->RH_DTRECIB),4) //"| Anticipo correspondiente al mes de xx de"
@ LI,131  PSAY "|"
@ ++LI,00 PSAY "|" + REPLICATE("-",130) + "|"
@ ++Li,00 PSAY STR0024 +EXTENSO(nTOTVENC-nTOTDESC,,,"-")+REPLICATE("*",95-LEN(EXTENSO(nTOTVENC-nTOTDESC,,,"-"))) //"| Recibi conforme la suma de pesos "
@ LI,131  PSAY "|"
@ ++Li,00 PSAY STR0025 //"| por concepto de mis haberes correspondientes al periodo anteriormente indicado y segun la presente liquidacion, dejando "
@ LI,131  PSAY "|"
@ ++Li,00 PSAY "|" + STR0026  //" constancia de haber recibido un duplicado de este recibo. "
@ LI,131  PSAY "|"
@ ++Li,00 PSAY "|"
@ LI,131  PSAY "|"
@ ++Li,00 PSAY STR0027 + StrZero(Day(SRH->RH_DTRECIB),2) + STR0023 + MesExtenso(MONTH(SRH->RH_DTRECIB)) + STR0023+STR(YEAR(SRH->RH_DTRECIB),4) //"| Lugar y Fecha XX de XX de"
@ Li,070  PSAY + REPLICATE("_",40)
@ LI,131  PSAY "|"
@ ++Li,00 PSAY STR0028 + TRANS((nTOTVENC-nTOTDESC),"@E 99,999,999,999")		//"| SON $ "
@ LI,131  PSAY "|"
@ ++Li,00 PSAY STR0029  //"| ORIGINAL "
@ LI,131  PSAY "|"
@ ++Li,00 PSAY "|"
@ LI,131  PSAY "|"
@ ++LI,00 PSAY "*"+REPLICATE("-",130)+"*"

Return Nil

