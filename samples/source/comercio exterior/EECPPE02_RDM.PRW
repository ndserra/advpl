/*
Programa        : EECPPE02.PRW
Objetivo        : DOCUMENTO DE CONFIRMACAO DE PEDIDO
Autor           : CRISTIANE FIGUEREDO
Data/Hora       : 30/12/99
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (pedidos) (EE7)
*/

#include "EECRDM.CH"

// Alterado por Heder M Oliveira - 4/7/2000

#define LenCol1 11 // +0
#define LenCol2 13 // +0
#define LenCol3 09 // +1
#define LenCol4 60 // +1
#define LenCol5 12 // +1
#define LenCol6 18

#define LIMITE_ITENS 18

/*
Funcao      : EECPPE02
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : CRISTIANE FIGUEREDO
Data/Hora   : 
Revisao     :
Obs.        :
*/
User Function EECPPE02

Local nAlias := Select()
Local lRet := .t.
Local aOrd := SaveOrd({"EE8","SYQ"})
Local lIngles := "INGLES" $ WorkId->EEA_IDIOMA
Local nFobValue, cPaisDest,cPaisOrig
Local nTotPedi,nTOTQTY, nValorTot  

// * by JBJ - 27/06/2001 - 14:10

Private cPictDecPrc, cPictDecPes,;
        cPictDecQtd, cPictPreco ,;
        cPictPeso  , cPictQtde        

If Type ("EE7->EE7_DECPRC") == "N"
   cPictDecPrc := if(EE7->EE7_DECPRC > 0, "."+Replic("9",EE7->EE7_DECPRC),"")
   cPictPreco  := "9,999" +cPictDecPrc
Else
   cPictPreco  := "999,999.999"
EndIf
     
If Type("EE7->EE7_DECPES") == "N"
   cPictDecPes := if(EE7->EE7_DECPES > 0, "."+Replic("9",EE7->EE7_DECPES),"")
   cPictPeso   := "9,999,999"+cPictDecPes
Else  
   cPictPeso   := AVSX3("EE7_PESLIQ",6) 
Endif

If Type("EE7->EE7_DECQTD") == "N"
   cPictDecQtd := if(EE7->EE7_DECQTD > 0, "."+Replic("9",EE7->EE7_DECQTD),"")
   cPictQtde  := "9,999,999"+cPictDecQtd
Else
   cPictQtde  := "999,999,999,999"
EndIf

//* (FIM)


Begin Sequence
   EE8->(DBSETORDER(1))
   SYQ->(dbSetOrder(1))
   
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //adicionar registro no header_p
   HEADER_P->(DBAPPEND())
   
   HEADER_P->AVG_SEQREL := cSEQREL
   HEADER_P->AVG_CHAVE  := EE7->EE7_PEDIDO
   HEADER_P->AVG_FILIAL := xfilial("SY0")
   
   HEADER_P->AVG_C01_60 := AllTrim(EE7->EE7_IMPODE) // Para Import
   HEADER_P->AVG_C02_60 := AllTrim(EE7->EE7_ENDIMP) // End Import
   HEADER_P->AVG_C03_60 := AllTrim(EE7->EE7_END2IM) // Compl End Import
   
   SYQ->(dbSeek(xFilial()+EE7->EE7_VIA))
   
   IF Left(SYQ->YQ_COD_DI,1) == "1" // MARITIMO
      HEADER_P->AVG_C32_60:="FOB"
   Else 
      HEADER_P->AVG_C32_60:="FCA"
   Endif

   HEADER_P->AVG_C31_60:=EE7->EE7_INCOTE

   IF Posicione("SYJ",1,xFilial("SYJ")+EEC->EEC_INCOTE,"YJ_CLFRETE") $ cSim
      HEADER_P->AVG_C04_60 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // Porto de Destino
   Else
      HEADER_P->AVG_C04_60 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))  // Porto de Origem
   Endif
   
   HEADER_P->AVG_C02_30 := Posicione("SYQ",1,XFILIAL("SYQ")+EE7->EE7_VIA, "YQ_DESCR") // Via
   HEADER_P->AVG_C05_60 := Posicione("SY9",2,xFilial("SY9")+EE7->EE7_DEST,"Y9_DESCR")// Puerto Destino
   HEADER_P->AVG_C09_30 := Posicione("SY9",2,xFilial("SY9")+EE7->EE7_ORIGEM,"Y9_DESCR")// Puerto Origem
   
   cPAISDEST:=Posicione("SYR",1,xFilial("SYR")+EE7->EE7_VIA+EE7->EE7_ORIGEM+EE7->EE7_DEST+EE7->EE7_TIPTRA,"YR_PAIS_DE")
   HEADER_P->AVG_C01_30 := Posicione("SYA",1,xFilial("SYA")+cPAISDEST,"YA_DESCR")//Destinacion
   cPAISORIG:=Posicione("SY9",2,xFilial("SY9")+EE7->EE7_ORIGEM,"Y9_PAIS")
   HEADER_P->AVG_C08_30 := Posicione("SYA",1,xFilial("SYA")+cPAISORIG,"YA_DESCR")//Pais Origen
   
   HEADER_P->AVG_C04_20 := MSMM(EE7->EE7_CODMAR,AVSX3("EE7_MARCAC",3),1) // Marcas 1
   HEADER_P->AVG_C05_20 := MSMM(EE7->EE7_CODMAR,AVSX3("EE7_MARCAC",3),2) // Marcas 2
   HEADER_P->AVG_C06_20 := MSMM(EE7->EE7_CODMAR,AVSX3("EE7_MARCAC",3),3) // Marcas 3
   HEADER_P->AVG_C07_20 := MSMM(EE7->EE7_CODMAR,AVSX3("EE7_MARCAC",3),4) // Marcas 4
   HEADER_P->AVG_C08_20 := MSMM(EE7->EE7_CODMAR,AVSX3("EE7_MARCAC",3),5) // Marcas 5
   HEADER_P->AVG_C09_20 := MSMM(EE7->EE7_CODMAR,AVSX3("EE7_MARCAC",3),6) // Marcas 6
   

   
   HEADER_P->AVG_C10_20 := ALLTRIM(Transf(EE7->EE7_PESLIQ,cPictPeso)+" KGS") // Total Peso Neto //AQUI
   HEADER_P->AVG_C11_20 := ALLTRIM(Transf(EE7->EE7_PESBRU,cPictPeso)+" KGS") // Total Peso Bruto //AQUI
   
   HEADER_P->AVG_C12_20 := ALLTRIM(Transf(EE7->EE7_CUBAGE,AVSX3("EE7_CUBAGE",6))+" M3") // Total Cubaje
   
   nFobValue := (EE7->EE7_TOTPED+EE7->EE7_DESCON)-(EE7->EE7_FRPREV+EE7->EE7_FRPCOM+EE7->EE7_SEGPRE+EE7->EE7_DESPIN+AvGetCpo("EE7->EE7_DESP1")+AvGetCpo("EE7->EE7_DESP2"))
             
   HEADER_P->AVG_C14_20 := ALLTRIM(Transf(nFobValue,"999,999,999.99")) // Total FOB
   HEADER_P->AVG_C15_20 := ALLTRIM(Transf(EE7->EE7_FRPREV+EE7->EE7_FRPCOM,"999,999,999.99")) // Flete
   HEADER_P->AVG_C16_20 := ALLTRIM(Transf(EE7->EE7_SEGPRE,"999,999,999.99")) // Seguro
   HEADER_P->AVG_C17_20 := ALLTRIM(Transf(EE7->EE7_TOTPED,"999,999,999.99")) // Total FCA

   HEADER_P->AVG_C18_20 := ALLTRIM(Transf((EE7->EE7_DESPIN+AvGetCpo("EE7->EE7_DESP1")+AvGetCpo("EE7->EE7_DESP2"))-EE7->EE7_DESCON,"999,999,999.99")) // Otros
   
   //COND. DE PAGO
   HEADER_P->AVG_C06_60 := SY6Descricao(EE7->EE7_CONDPA+Str(EE7->EE7_DIASPA,AVSX3("EE7_DIASPA",3),AVSX3("EE7_DIASPA",4)),EE7->EE7_IDIOMA,1) // Terms of Payment
   HEADER_P->AVG_C03_30 := EE7->EE7_EMBAFI // EMPAQUE
   
   IF EE5->(DBSEEK(xFilial()+EE7->EE7_EMBAFI))
      HEADER_P->AVG_C04_30 := EE5->EE5_DIMENS //DIMENSIONE EMPAQUE
   ENDIF
   
   HEADER_P->AVG_C02_20 := EE7->EE7_PEDIDO //Pedido No.
   HEADER_P->AVG_C03_20 := EE7->EE7_REFIMP //Pedido Cliente
   
   HEADER_P->AVG_C06_30 := AllTrim(SA2->A2_MUN)+", "
   HEADER_P->AVG_C07_30 := DicIdMes({Left(EE7->EE7_IDIOMA,6),EE7->EE7_DTPEDI})+" "+StrZero(Day(EE7->EE7_DTPEDI),2)+", "+Str(Year(EE7->EE7_DTPEDI),4)+"."
   
   IF ( EE7->EE7_VALCOM > 0 )
      HEADER_P->AVG_C05_30 := IF(lIngles,"COMISSION ","CON COMISION ") + EE7->EE7_MOEDA + " " + Alltrim(Transf(EE7->EE7_VALCOM,AVSX3("EE7_VALCOM",6)))
   ELSE
      HEADER_P->AVG_C05_30 := IF(lIngles,"NO COMISSION","SIN COMISION")     
   ENDIF
    
   EE8->(DBSEEK(xFilial()+EE7->EE7_PEDIDO))
  
   DBSELECTAREA("EE8")
   
   nTotPedi := 0
   nTOTQTY  :=0
         
   WHILE !EOF() .And. EE8_FILIAL == xFilial("EE8") .And. EE8->EE8_PEDIDO == EE7->EE7_PEDIDO
      //adicionar registro no DETAIL_p
      AppendDet()
      
      DETAIL_P->AVG_C01_60 := MSMM(EE8->EE8_DESC,LenCol4)

      nValorTot := EE8->EE8_PRECOI * EE8->EE8_SLDINI
      
      DETAIL_P->AVG_C01_20 := EE8->EE8_COD_I

      DETAIL_P->AVG_C02_20 := ALLTRIM(Transf(EE8->EE8_SLDINI,cPictQtde)) //AQUI
      DETAIL_P->AVG_C03_20 := ALLTRIM(Transf(EE8->EE8_PRECOI,cPictPreco))//AQUI
      DETAIL_P->AVG_C04_20 := ALLTRIM(Transf(nValorTot,"999,999,999.99"))
      
      UnlockDet()
   	  
      nTOTQTY :=nTOTQTY+EE8->EE8_SLDINI
      nTotPEdi := nTotPedi + nValorTot
      
      EE8->(DBSKIP())
   ENDDO

   //adicionar registro no DETAIL_p
   AppendDet()
   
   DETAIL_P->AVG_C02_20 := Replic("-",20)
   DETAIL_P->AVG_C04_20 := Replic("-",20)
   
   UnlockDet()

   //adicionar registro no DETAIL_p
   AppendDet()
   DETAIL_P->AVG_C02_20 := ALLTRIM(Transf(nToTQTY,cPictQtde)) // AQUI
   DETAIL_P->AVG_C04_20 := ALLTRIM(Transf(nTotPedi,"999,999,999.99"))
   UnlockDet()

   HEADER_P->AVG_C13_20 := ALLTRIM(Transf(nTotPedi,"999,999,999.99"))
   nTotGeral := nTotPedi+EE7->EE7_FRPREV+EE7->EE7_SEGPRE+EE7->EE7_DESPIN+AvGetCpo("EE7->EE7_DESP1")+AvGetCpo("EE7->EE7_DESP2")
   HEADER_P->AVG_C17_20 := ALLTRIM(Transf(nTotGeral,"999,999,999.99"))
   HEADER_P->(dbUnlock())
    
   //*** JBJ - 19/06/01 - 11:52 - Gravar histórico de documentos - (INICIO)
   
   HEADER_H->(dbAppend())
   AvReplace("HEADER_P","HEADER_H")
   DETAIL_P->(DBSETORDER(0),DBGOTOP())
   Do While ! DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo
   DETAIL_P->(DBSETORDER(1))
   
   //*** (FIM) 
   
   /*    
   cRpt := Upper(WORKID->EEA_ARQUIV) //JBJ        
          
   // AvgCrw32 acrescenta o path do crystal 
   IF !(AvgCrw32(cRpt,WorkId->EEA_TITULO,cSeqRel))
      Break
   ENDIF     
           
   //gravar historico de documentos
   E_HISTDOC(,WorkId->EEA_TITULO,dDATABASE,,,cRPT,cSeqRel)
   */
   
End Sequence

RestOrd(aOrd)
Select(nAlias)

Return lRet

/*
Funcao      : AppendDet
Parametros  : 
Retorno     : 
Objetivos   : Adiciona registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira 
Data/Hora   : 05/05/2000
Revisao     : 
Obs.        :
*/
Static Function AppendDet()

Begin Sequence
   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSEQREL
   DETAIL_P->AVG_CHAVE  := EE7->EE7_PEDIDO //nr. do processo
End Sequence

Return NIL

/*
Funcao      : UnlockDet
Parametros  : 
Retorno     : 
Objetivos   : Desaloca registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira 
Data/Hora   : 05/05/2000
Revisao     : 
Obs.        :
*/
Static Function UnlockDet()

Begin Sequence
   DETAIL_P->(dbUnlock())
End Sequence

Return NIL

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPPE02.PRW                                                 *
*------------------------------------------------------------------------------*