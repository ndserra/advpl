/*
Programa        : EECPEM51_RDM.
Objetivo        : Impressao da Commercial Invoice (Modelo 3).
Autor           : Jeferson Barros Jr.
Data/Hora       : 17/12/2003 09:13.
Obs.            : Inicialmente desenvolvido p/ SAI. (ECSAIE02.PRW)
*/

#INCLUDE "EECRDM.CH"
#INCLUDE "EECPEM51.CH"

#DEFINE NUMLINPAG 30
#DEFINE TAMDESC 32

/*
Funcao      : EECPEM51()
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Impressão da Commercial Invoice (Modelo 3).
Autor       : Jeferson Barros Jr.
Data/Hora   : 17/12/2003 09:13.
Revisao     :
Obs.        :
*/
*----------------------*
User Function EECPEM51()
*----------------------*
Local lRet    := .t.
Local nAlias  := Select()
Local aOrd    := SaveOrd({"EE9","SA2","EE2"})
Local nCod, aFields, cFile, /*nInc, cPackag, acRETPAC,*/ nFobValue // GFP - 03/12/2012
LOCAL aMESES := {"ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"}
Local aData // GFP - 22/11/2012

Private lIngles := "INGLES" $ Upper(WorkId->EEA_IDIOMA)       // GFP - 22/11/2012
Private cPict := "999,999,999.99"
Private cPictDecPrc := ".99"
Private cPictDecPes := ".99" 
Private cPictDecQtd := ".99" 
Private cPictPreco  := "9,999,999"+cPictDecPrc //"9,999"+cPictDecPrc  // GFP - 21/11/2012 - Estouro de campo
Private cPictPeso   := "9,999,999"+cPictDecPes
Private cPictQtde   := "9,999,999"+cPictDecQtd
Private cObs := ""
Private aNotify[6]
Private cFileMen:=""
Private cMarca := GetMark(), lInverte := .f.
Private lNcm := .f., lPesoBru := .t.

// ** USADO NO EECF3EE3 VIA SXB "E34" PARA GET ASSINANTE.
Private M->cSEEKEXF:=""
Private M->cSEEKLOJA:=""

// *** Cria Arquivo de Trabalho ...
Private aHeader := {}, aCAMPOS := ARRAY(0)
Private nTotPag := 1

Begin Sequence

   aFill(aNotify,"")
   
   // *** Cria Arquivo de Trabalho ...
   nCod := AVSX3("EEN_IMPORT",3)+AVSX3("EEN_IMLOJA",3)

   aFields := {{"WKMARCA","C",02,0},;
               {"WKTIPO","C",01,0},;
               {"WKCODIGO","C",nCod,0},;
               {"WKDESCR","C",AVSX3("EEN_IMPODE",3),0}}
            
   cFile := E_CriaTrab(,aFields,"Work")
   IndRegua("Work",cFile+OrdBagExt(),"WKTIPO+WKCODIGO")

   EEM->(dbSetOrder(1)) // ** FILIAL+PREEMB+TIPO
   EE2->(dbSetOrder(1))
   EE9->(dbSetOrder(4)) // ** FILIAL+PREEMB+NCM
   EE7->(dbSetOrder(1))
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   EE7->(dbSeek(xFilial()+EE9->EE9_PEDIDO))

   // ** regras para carregar dados.
   SA2->(dbSetOrder(1))
   IF !EMPTY(EEC->EEC_EXPORT) .AND. ;
       SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
      cExp_Cod     := EEC->EEC_EXPORT+EEC->EEC_EXLOJA
      cEXP_NOME    := Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1)  //nome do contato seq 1
      cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4)  //fone do contato seq 1
      cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7)  //fax do contato seq 1
      cEXP_CARGO   := EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",2)  //CARGO
      M->cSEEKEXF  :=EEC->EEC_EXPORT
      M->cSEEKLOJA :=EEC->EEC_EXLOJA
   ELSE
      SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA))
      cExp_Cod     := EEC->EEC_FORN+EEC->EEC_FOLOJA
      cEXP_NOME    := SA2->A2_NOME
      cEXP_CONTATO := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
      cEXP_CARGO   := EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",2,EEC->EEC_RESPON)  //CARGO
      M->cSEEKEXF  :=EEC->EEC_FORN
      M->cSEEKLOJA :=EEC->EEC_FOLOJA
   ENDIF
   
   cC2160 := EEC->EEC_IMPODE
   cC2260 := EEC->EEC_ENDIMP
   cC2360 := EEC->EEC_END2IM
   cC2460 := SPACE(60)
   cC2960 := SPACE(60)
   cC3060 := SPACE(60)
   
   // dar get do titulo e das mensagens ...
   IF !TelaGets()
      lRet := .f.
      Break
   Endif
   
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   // adicionar registro no HEADER_P
   HEADER_P->(DBAPPEND())
   HEADER_P->AVG_FILIAL:=xFilial("SY0")
   HEADER_P->AVG_SEQREL:=cSEQREL
   HEADER_P->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo

   // Dados do Exportador/Fornecedor
   HEADER_P->AVG_C01_60:=ALLTRIM(cEXP_NOME)
   HEADER_P->AVG_C02_60:=ALLTRIM(SA2->A2_END)+" - " + AllTrim(SA2->A2_MUN)
   HEADER_P->AVG_C03_60:=ALLTRIM(SA2->A2_EST+" "+AllTrim(BuscaPais(SA2->A2_PAIS))+" CEP: "+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6)))
   HEADER_P->AVG_C04_60:=ALLTRIM("TEL.: "+AllTrim(cEXP_FONE)+" FAX: "+AllTrim(cEXP_FAX))
   
   aData := DataExtenso(EEC->EEC_DTINVO,,.T.)      // GFP - 21/11/2012
   
   // Informacoes do Cabecalho 
   HEADER_P->AVG_C06_60 := AllTrim(SA2->A2_MUN)+", "+ If(lIngles, aData[1] + " " + aData[2] + ", " + aData[3] + ".", If(EMPTY(EEC->EEC_DTINVO),""," "+StrZero(Day(EEC->EEC_DTINVO),2)+" de "+aMeses[Month(EEC->EEC_DTINVO)])+" de "+Str(Year(EEC->EEC_DTINVO),4)+".")  // GFP - 30/11/2012
                                                    //Upper(IF(lIngles,cMonth(EEC->EEC_DTINVO),IF(EMPTY(EEC->EEC_DTINVO),"",aMeses[Month(EEC->EEC_DTINVO)])))+" "+StrZero(Day(EEC->EEC_DTINVO),2)+", "+Str(Year(EEC->EEC_DTINVO),4)+"."  // GFP - 21/11/2012
   HEADER_P->AVG_C06_10 := AjustaData(EEC->EEC_DTINVO) //DtoC(EEC->EEC_DTINVO)  // GFP - 22/11/2012
   HEADER_P->AVG_C01_20 := EEC->EEC_NRCONH
   HEADER_P->AVG_C02_20 := EEC->EEC_PREEMB

   // TO
   HEADER_P->AVG_C07_60 := EEC->EEC_IMPODE
   HEADER_P->AVG_C08_60 := EEC->EEC_ENDIMP
   HEADER_P->AVG_C09_60 := EEC->EEC_END2IM

   // Contato
   EE3->(dbSetOrder(1))
   If EE3->(dbSeek(xFilial("EE3")+CD_SA1+AVKEY(EEC->EEC_IMPORT,"EE3_CONTAT")+AVKey(EEC->EEC_IMLOJA,"EE3_COMPL")))
	   cTO_ATTN := AllTrim(EE3->EE3_NOME)
	   cTO_TEL  := AllTrim(EE3->EE3_FONE)
	   HEADER_P->AVG_C32_60 := AllTrim(SubStr(AllTrim(cTO_ATTN),1,30)) + " - TEL.: " + AllTrim(cTO_TEL)
   Endif

   // Ref. Imp. e  Dt. do Pedido
   HEADER_P->AVG_C15_60 := AllTrim(EEC->EEC_PEDREF)  //AllTrim(EEC->EEC_REFIMP)   // GFP - 21/11/2012
   HEADER_P->AVG_C07_10 := AjustaData(EE7->EE7_DTPEDI) //DtoC(EE7->EE7_DTPEDI)    // GFP - 22/11/2012
   
   // Consignee
   HEADER_P->AVG_C10_60 := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_CONSIG+EEC->EEC_COLOJA,"A1_NOME")
   HEADER_P->AVG_C11_60 := EECMEND("SA1",1,EEC->EEC_CONSIG+EEC->EEC_COLOJA,.T.,58,1)
   HEADER_P->AVG_C12_60 := EECMEND("SA1",1,EEC->EEC_CONSIG+EEC->EEC_COLOJA,.T.,60,2)
   
   // Titulos ...
   HEADER_P->AVG_C01_10 := EEC->EEC_MOEDA
   HEADER_P->AVG_C02_10 := "KG"
   
   // Packing (quebrar linha para 1 virgula).
/* Nopado por GFP - 30/11/2012
   IF ( len(alltrim(EEC->EEC_PACKAG))>0 )
      cPACKAG  :=ALLTRIM(EEC->EEC_PACKAG)
      acRETPAC:={}
      FOR nINC:=1 TO LEN(cPACKAG)
         nCONT:=AT(",",cPACKAG)	  // ** PREPARADO PARA VARIAS VIRGULAS
         nCONT:=IF(nCONT==0,LEN(cPACKAG),nCONT)
         AADD(acRETPAC,SUBSTR(cPACKAG,1,nCONT))
         IF ( LEN(cPACKAG)<nCONT+1 )
            EXIT 
         ENDIF
         cPACKAG  :=ALLTRIM(SUBSTR(cPACKAG,nCONT+1))
      NEXT nINC
*/
	  // ** GRAVAR APENAS DUAS VIRGULAS
      HEADER_P->AVG_C13_60 := Left(EEC->EEC_PACKAG,30)    //IF(LEN(acRETPAC)>=1,acRETPAC[1],"") // ** EEC->EEC_PACKAG  // GFP - 03/12/2012
      HEADER_P->AVG_C31_60 := Right(EEC->EEC_PACKAG,30)   //IF(LEN(acRETPAC)>=2,acRETPAC[2],"") // ** EEC->EEC_PACKAG
//   ENDIF
   
   // Pesos/Cubagem
   HEADER_P->AVG_C03_20 := DecPoint(AllTrim(Transf(EEC->EEC_PESLIQ,cPictPeso)),2)  
   HEADER_P->AVG_C04_20 := DecPoint(AllTrim(Transf(EEC->EEC_PESBRU,cPictPeso)),2)  
   cPictCub := AllTrim(StrTran(Upper(AVSX3("EEC_CUBAGE",6)),"@E",""))
   HEADER_P->AVG_C05_20 := DecPoint(Transf(EEC->EEC_CUBAGE,cPictCub),2)

   // TOTAIS
   If EEC->EEC_PRECOA = "2"
     nFobValue := EEC->EEC_TOTPED
   Else
     nFobValue := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
   Endif
   
   HEADER_P->AVG_C14_20 := DecPoint(ALLTRIM(Transf(nFobValue,cPICT)),2)
   HEADER_P->AVG_C15_20 := DecPoint(ALLTRIM(Transf(EEC->EEC_FRPREV,cPICT)),2)
   HEADER_P->AVG_C16_20 := DecPoint(ALLTRIM(Transf(EEC->EEC_SEGPRE,cPICT)),2)
   HEADER_P->AVG_C17_20 := DecPoint(ALLTRIM(Transf(EEC->EEC_FRPCOM+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2")-EEC->EEC_DESCON,cPict)),2)
   HEADER_P->AVG_C18_20 := DecPoint(ALLTRIM(Transf(EEC->EEC_TOTPED,cPICT)),2) 
   HEADER_P->AVG_C03_10 := EEC->EEC_INCOTE
   
   // pais de origem
   HEADER_P->AVG_C01_30 := Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM")
   
   // VIA
   SYQ->(dbSetOrder(1))
   SYQ->(dbSeek(xFilial()+EEC->EEC_VIA))
   
   HEADER_P->AVG_C02_30 := PEM51TRANSPOR() //IF(Left(SYQ->YQ_COD_DI,1) == "4",IF(lIngles,"BY AIR","VIA AEREA"),SYQ->YQ_DESCR) // ** VIA      //GFP - 03/12/2012
   
   IF Left(SYQ->YQ_COD_DI,1) == "7" // ** Rodoviario
      HEADER_P->AVG_C14_60 := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA)
   Else
      HEADER_P->AVG_C14_60 := Posicione("EE6",1,xFilial("EE6")+EEC->EEC_EMBARC,"EE6_NOME")// ** Embarcacao
   Endif

   IF Left(SYQ->YQ_COD_DI,1) == "1" // ** MARITIMO
      HEADER_P->AVG_C05_10:="FOB"
   Else 
      HEADER_P->AVG_C05_10:="FCA"
   Endif
   
   SYR->(dbSeek(xFilial()+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))   
   IF Posicione("SYJ",1,xFilial("SYJ")+EEC->EEC_INCOTE,"YJ_CLFRETE") $ cSim
      HEADER_P->AVG_C13_20 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // Porto de Destino
   Else
      HEADER_P->AVG_C13_20 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))  // Porto de Origem
   Endif
   
   // Port of Unloading
   HEADER_P->AVG_C04_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR"))
   
   // Port of Loading
   HEADER_P->AVG_C03_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR")) 
   
   // MARKS
   cMemo := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
   HEADER_P->AVG_C06_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),1)
   HEADER_P->AVG_C07_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),2)
   HEADER_P->AVG_C08_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),3)
   HEADER_P->AVG_C09_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),4)
   HEADER_P->AVG_C10_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),5)
   HEADER_P->AVG_C11_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),6)

   // Cond.Pagto ...
   HEADER_P->AVG_C01100 := SY6Descricao(EEC->EEC_CONDPA+Str(EEC->EEC_DIASPA,AVSX3("EEC_DIASPA",3),AVSX3("EEC_DIASPA",4)),EEC->EEC_IDIOMA,1) // ** Terms of Payment
      
   HEADER_P->AVG_C25_60 := EEC->EEC_LICIMP // ** I/L
   HEADER_P->AVG_C04_10 := EEC->EEC_LC_NUM // ** L/C   
   HEADER_P->AVG_C26_60 := cEXP_NOME       // ** RODAPE
   
   HEADER_P->AVG_C27_60 := cEXP_CONTATO
   HEADER_P->AVG_C28_60 := cEXP_CARGO
   HEADER_P->AVG_C01150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),1)
   HEADER_P->AVG_C02150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),2)
   HEADER_P->AVG_C03150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),3)
   HEADER_P->AVG_C04150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),4)
   HEADER_P->AVG_C05150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),5)
   
   GravaItens()

   // ** Total de Páginas.
   HEADER_P->AVG_C08_10 := AllTrim(Str(nTotPag))    
       
   HEADER_P->(dbUnlock())

   HEADER_H->(dbAppend())
   AvReplace("HEADER_P","HEADER_H")
   
   DETAIL_P->(DbGoTop())
   Do While ! DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo
   
End Sequence

IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cFileMen))
Endif

Work->(E_EraseArq(cFile))
RestOrd(aOrd)
Select(nAlias)

Return lRet

/*
Funcao      : GravaItens
Parametros  : Nenhum.
Retorno     : Nil
Objetivos   : Gravar os itens - (Detalhes).
Autor       : Jeferson Barros Jr.
Data/Hora   : 17/12/2003 - 09:40.
Revisao     :
Obs.        :
*/
*-------------------------*
Static Function GravaItens
*-------------------------*
Local nTotQtde := 0
Local nTotal   := 0
Local cUnidade := ""
Local bCond    := IF(lNcm,{|| EE9->EE9_POSIPI == cNcm },{|| .t. })
Local cNcm     := ""
Local lSeg     := .F. 
Local i:=0, gi_W:=0
PRIVATE nLin :=0,nPag := 1

While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
      EE9->EE9_PREEMB == EEC->EEC_PREEMB

   IF lNcm
      cNcm := EE9->EE9_POSIPI
      
      IF cUnidade <> EE9->EE9_UNIDAD  
         cUnidade := EE9->EE9_UNIDAD
         AppendDet()

         IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
             MsgStop(STR0001+EE9->EE9_UNIDAD+STR0002+EEC->EEC_IDIOMA,STR0003) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
         Endif

         DETAIL_P->AVG_C06_20 := AllTrim(EEC->EEC_MOEDA)+"/"+EE2->EE2_DESCMA
         
         UnlockDet()
      Endif   
   
      SYD->(dbSetOrder(1))
      SYD->(dbSeek(xFilial("SYD")+EE9->EE9_POSIPI))
      
      If lSeg         
	      AppendDet()     
	      UnlockDet()
	      AppendDet()     
	      UnlockDet()
      Else
          lSeg := .T.
      EndIf

      AppendDet()
       cMemo := MSMM(SYD->YD_TEXTO,AVSX3("YD_VM_TEXT",3))     
       DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,1) 
      UnlockDet()

      For i := 2 To MlCount(cMemo,TAMDESC,3)
         IF !EMPTY(MemoLine(cMemo,TAMDESC,i))
            AppendDet()
            DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,i)
            UnLockDet()
         ENDIF
      Next
      
      //Impressão de NCM - FRS 21/01/10
      AppendDet()
      DETAIL_P->AVG_C01_60 := Transf(EE9->EE9_POSIPI,AVSX3("EE9_POSIPI",6))
      UnlockDet()
      
      AppendDet()
      DETAIL_P->AVG_C01_60 := Replic("-",25)
      UnlockDet()
   Endif
   
   While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB .And. ;
         Eval(bCond)
         
      IF cUnidade <> EE9->EE9_UNIDAD  
         cUnidade := EE9->EE9_UNIDAD
         AppendDet()
 
         IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
             MsgStop(STR0001+EE9->EE9_UNIDAD+STR0002+EEC->EEC_IDIOMA,STR0003) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
         Endif
                  
         DETAIL_P->AVG_C06_20 := AllTrim(EEC->EEC_MOEDA)+"/"+EE2->EE2_DESCMA
         
         UnlockDet()
      Endif   
      
      AppendDet()
      DETAIL_P->AVG_C01_20 := DecPoint(ALLTRIM(Transf(EE9->EE9_SLDINI,cPictQtde)),2)
      DETAIL_P->AVG_C02_20 := Transf(EE9->EE9_COD_I,AVSX3("EE9_COD_I",6))
      DETAIL_P->AVG_C03_20 := Alltrim(EE9->EE9_REFCLI)
      
      cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
      
      DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,1) 
      DETAIL_P->AVG_C04_20 := DecPoint(AllTrim(Transf(EE9->EE9_PSLQTO,cPictPeso)),2)
     
      DETAIL_P->AVG_C06_20 := DecPoint(AllTrim(Transf(EE9->EE9_PRECO,cPictPreco)),2)
      DETAIL_P->AVG_C07_20 := DecPoint(AllTrim(Transf(EE9->EE9_PRECO*EE9->EE9_SLDINI,cPict)),2)
      
      For i := 2 To MlCount(cMemo,TAMDESC,3)
         IF !EMPTY(MemoLine(cMemo,TAMDESC,i))
            UnLockDet()
            AppendDet()
            DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,i)
         ENDIF
      Next
      
      nTotQtde := nTotQtde+EE9->EE9_SLDINI
      nTotal   := nTotal  +(EE9->EE9_PRECO*EE9->EE9_SLDINI)
      
      UnLockDet()
      
      EE9->(dbSkip())         
   Enddo
Enddo

AppendDet()
DETAIL_P->AVG_C01_20 := Replic("-",20)
DETAIL_P->AVG_C04_20 := Replic("-",20)
DETAIL_P->AVG_C07_20 := Replic("-",20)
UnLockDet()

AppendDet()
DETAIL_P->AVG_C01_20 := DecPoint(ALLTRIM(Transf(nTotQtde,cPictQtde)),2)
DETAIL_P->AVG_C04_20 := DecPoint(ALLTRIM(Transf(EEC->EEC_PESLIQ,cPictPeso)),2)
DETAIL_P->AVG_C07_20 := DecPoint(ALLTRIM(Transf(nTotal,cPict)),2)
UnLockDet()

// Gravar todas as N.F.  Igor Chiba 13/08/08
cNotas := ""
EEM->(dbSeek(xFilial()+EEC->EEC_PREEMB+EEM_NF))
lMV_AVG0161:=GETMV("MV_AVG0161",,.T.)// parametro que indica se irá imprimir n° da NF na Commercial  Invoice  
DO While EEM->(!Eof() .And. EEM_FILIAL == xFilial()) .And.;
         EEM->EEM_PREEMB == EEC->EEC_PREEMB .And. EEM->EEM_TIPOCA == EEM_NF .AND. lMV_AVG0161
   
   SysRefresh()
   IF Empty(cNotas)
      cNotas := cNotas+STR0004 //"Notas Fiscais:"
   Endif
   
   cNotas := cNotas+" "+AllTrim(EEM->EEM_NRNF)+if(!Empty(EEM->EEM_SERIE),"-"+AllTrim(EEM->EEM_SERIE),"")
   EEM->(dbSkip())
Enddo

For i:=1 To MlCount(cNotas,30)
   AppendDet()
   DETAIL_P->AVG_C01_60 := MemoLine(cNotas,30,i)
   UnLockDet()
Next i

HEADER_P->AVG_C12_20 := DecPoint(ALLTRIM(Transf(nTotal,cPict)),2)

IF Select("Work_Men") > 0
   Work_Men->(dbGoTop())
   
   While !Work_Men->(Eof()) .And. Work_Men->WKORDEM < "zzzzz"
      gi_nTotLin:=MLCOUNT(Work_Men->WKOBS,40) 
      For gi_W := 1 To gi_nTotLin
         If !Empty(MEMOLINE(Work_Men->WKOBS,40,gi_W))
            AppendDet()
            DETAIL_P->AVG_C01_60 := MemoLine(Work_Men->WKOBS,40,gi_W)
            UnLockDet()
         EndIf
      Next
      Work_Men->(dbSkip())
   Enddo
Endif

DO WHILE MOD(nLin,NUMLINPAG) <> 0
   APPENDDET()   
ENDDO 

nTotPag := nPag

Return NIL

/*
Funcao      : AppendDet
Parametros  : Nenhum.
Retorno     : Nil
Objetivos   : Adiciona registros no arquivo de detalhes
Autor       : Jeferson Barros Jr.
Data/Hora   : 17/12/2003 - 09:36.
Revisao     : 
Obs.        :
*/
*-------------------------*
Static Function AppendDet()
*-------------------------*
Begin Sequence
   nLin := nLin+1
   IF nLin > NUMLINPAG
      nLin := 1
      nPag := nPag+1
   ENDIF
   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSEQREL
   DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB
   DETAIL_P->AVG_CONT   := STRZERO(nPag,6,0)  
End Sequence

Return NIL

/*
Funcao      : UnlockDet
Parametros  : Nenhum.
Retorno     : Nil
Objetivos   : Desaloca registros no arquivo de detalhes
Autor       : Jeferson Barros Jr
Data/Hora   : 17/12/2003.
Revisao     : 
Obs.        :
*/
*-------------------------*
Static Function UnlockDet()
*-------------------------*
Begin Sequence
   DETAIL_P->(dbUnlock())
End Sequence

Return NIL

/*
Funcao      : TelaGets
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Tela de parâmetros para impressão da Commercial Invoice.
Autor       : Jeferson Barros Jr.
Data/Hora   : 17/12/2003 - 09:30.
Revisao     : 
Obs.        :
*/
*----------------------*
Static Function TelaGets
*----------------------*
Local lRet := .f.
Local nOpc := 0
Local oDlg
Local bOk     := {||nOpc:=1,oDlg:End()},;
      bCancel := {||nOpc:=0,oDlg:End()},;
      bSet  := {|x,o| lNcm := x, o:Refresh(), lNcm }
      //bSetP := {|x,o| lPesoBru := x, o:Refresh(), lPesoBru }

Local aCampos := {{"WKMARCA" ,," "},;
                  {"WKCODIGO",,STR0005},; //"Código"
                  {"WKDESCR" ,,STR0006}} //"Descrição"

Local oFld, oFldDoc, oBtnOk, oBtnCancel
Local oYes, oNo, oMark, oMark2, oMark3
Local bHide    := {|nTela| if(nTela==2,oMark:oBrowse:Hide(),;
                           if(nTela==3,oMark2:oBrowse:Hide(),;
                           if(nTela==4,oMark3:oBrowse:Hide(),))) }

Local bHideAll := {|| Eval(bHide,2), Eval(bHide,3), Eval(bHide,4) }

Local bShow    := {|nTela,o| if(nTela==2,dbSelectArea("Work"),if(nTela==3,dbSelectArea("WkMsg"),;
                             if(nTela==4,dbSelectArea("Work_Men"),))),;
                              o := if(nTela==2,oMark,if(nTela==3,oMark2,oMark3)):oBrowse,;
                              o:Show(),o:SetFocus() }

Local n,i,nTamLoj,cKey,cLoja,cImport
Local xx := ""

Private aMarcados[2], nMarcado := 0

Begin Sequence

   // ** Notify.
   EEN->(dbSeek(xFilial()+EEC->EEC_PREEMB+OC_EM))

   While EEN->(!Eof() .And. EEN_FILIAL == xFilial("EEN")) .And.;
         EEN->EEN_PROCES+EEN->EEN_OCORRE == EEC->EEC_PREEMB+OC_EM

      Work->(dbAppend())
      Work->WKTIPO   := "N"
      Work->WKCODIGO := EEN->EEN_IMPORT+EEN->EEN_IMLOJA
      Work->WKDESCR  := EEN->EEN_IMPODE

      EEN->(dbSkip())
   Enddo

   Work->(dbGoTop())
   
   DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 9,0 TO 28,80 OF oMainWnd

     oFld := TFolder():New(1,1,{STR0007,STR0008,STR0009,STR0010},{"IPC","IBC","OBS","MEN"},oDlg,,,,.T.,.F.,315,127) //"Documentos Para"###"Notify's"###"Mensagens"###"Observações"

     aEval(oFld:aControls,{|x| x:SetFont(oDlg:oFont) })
          
     // Documentos Para
     oFldDoc := oFld:aDialogs[1]     
     
     @ 10,001 SAY STR0011 SIZE 232,10 PIXEL OF oFldDoc //"Imprime N.C.M."
      
     oYes := TCheckBox():New(10,42,STR0012,{|x| If(PCount()==0, lNcm,Eval(bSet, x,oNo ))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
     oNo  := TCheckBox():New(10,65,STR0013,{|x| If(PCount()==0,!lNcm,Eval(bSet,!x,oYes))},oFldDoc,21,10,,,,,,,,.T.) //"Não"

     M->cCONTATO   := EEC->EEC_RESPON
     M->cEXP_CARGO := "EXPORT COORDINATOR"     
     
     @ 20,001 SAY STR0014 SIZE 232,10 PIXEL OF oFldDoc //"Assinante"
     @ 20,043 GET M->cCONTATO SIZE 120,08 PIXEL OF oFldDoc
        
     @ 30,001 SAY STR0015 SIZE 232,10 PIXEL OF oFldDoc //"Cargo"
     @ 30,043 GET M->cEXP_CARGO SIZE 120,08 PIXEL OF oFldDoc
     
     @ 44,001 SAY STR0016 SIZE 232,10 PIXEL OF oFldDoc //"Doct.Para"
     
     @ 44,043 GET cC2160 SIZE 120,08 PIXEL OF oFldDoc WHEN .F.     // GFP - 22/11/2012
     
     @ 54,043 GET cC2260 SIZE 120,08 PIXEL OF oFldDoc WHEN .F.     // GFP - 22/11/2012
     @ 64,043 GET cC2360 SIZE 120,08 PIXEL OF oFldDoc WHEN .F.     // GFP - 22/11/2012
     @ 74,043 GET cC2460 SIZE 120,08 PIXEL OF oFldDoc WHEN .F.     // GFP - 22/11/2012
     @ 84,043 GET cC2960 SIZE 120,08 PIXEL OF oFldDoc WHEN .F.     // GFP - 22/11/2012
     @ 94,043 GET cC3060 SIZE 120,08 PIXEL OF oFldDoc WHEN .F.     // GFP - 22/11/2012
     
     //GFP 25/10/2010
     aCampos := AddCpoUser(aCampos,"EEN","2")
     
     // Folder Notify's ...
     oMark := MsSelect():New("Work","WKMARCA",,aCampos,@lInverte,@cMarca,{18,3,125,312})
     oMark:bAval := {|| ChkMarca(oMark,cMarca) }
     @ 14,043 GET xx OF oFld:aDialogs[2]     
     AddColMark(oMark,"WKMARCA")
     
     // Folder Mensagens ...
     @ 14,043 GET xx OF oFld:aDialogs[3]
     oMark3 := EECMensagem(EEC->EEC_IDIOMA,"3",{18,3,125,312},,,,oDlg)

     // Folder Observações ...
     oMark2 := Observacoes("New",cMarca)
     @ 14,043 GET xx OF oFld:aDialogs[4]
     AddColMark(oMark2,"WKMARCA")

     Eval(bHideAll)
     
     oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),;
                                           IF(nOption <> 1,Eval(bShow,nOption),) }

     DEFINE SBUTTON oBtnOk     FROM 130,258 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
     DEFINE SBUTTON oBtnCancel FROM 130,288 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg

   ACTIVATE MSDIALOG oDlg CENTERED
   
   IF nOpc == 0
      Break
   Endif
   
   lRet := .t.
   
   n := 1
   For i:=1 To 2
      IF !Empty(aMarcados[i])
         nTamLoj := AVSX3("EEN_IMLOJA",3)
         cKey    := Subst(aMarcados[i],2)
         cLoja   := Right(cKey,nTamLoj) 
         cImport := Subst(cKey,1,Len(cKey)-nTamLoj)
         
         IF EEN->(dbSeek(xFilial()+AvKey(EEC->EEC_PREEMB,"EEN_PROCES")+OC_EM+AvKey(cImport,"EEN_IMPORT")+AvKey(cLoja,"EEN_IMLOJA")))
            aNotify[n]   := EEN->EEN_IMPODE
            aNotify[n+1] := EEN->EEN_ENDIMP
            aNotify[n+2] := EEN->EEN_END2IM
            n := n+3
         Endif
      Endif
   Next
   
   cEXP_CONTATO := M->cCONTATO

End Sequence

OBSERVACOES("END")

Return lRet

/*
Funcao      : ChkMarca
Parametros  : oMark,cMarca
Retorno     : Nil.
Objetivos   : Marca/Desmarca.
Autor       : Cristiano A. Ferreira 
Data/Hora   : 
Revisao     : Jeferson Barros Jr.
Obs.        :
*/
*------------------------------------*
Static Function ChkMarca(oMark,cMarca)
*------------------------------------*
Local n

Begin Sequence
   IF ! Work->(Eof() .Or. Bof())
      IF !Empty(Work->WKMARCA) 
         // Desmarca
         n := aScan(aMarcados,Work->WKTIPO+Work->WKCODIGO)
         IF n > 0
            aMarcados[n] := ""
         Endif
         
         Work->WKMARCA := Space(2)
      Else
         // Marca
         IF !Empty(aMarcados[1]) .And. !Empty(aMarcados[2])
            MsgStop(STR0017,STR0003) //"Já existem dois notify's selecionados !"###"Aviso"
            Break
         Endif
         
         IF Empty(aMarcados[1])
            aMarcados[1] := Work->WKTIPO+Work->WKCODIGO
         Else
            aMarcados[2] := Work->WKTIPO+Work->WKCODIGO
         Endif
         
         Work->WKMARCA := cMarca
      Endif
      
      oMark:oBrowse:Refresh()
   Endif
End Sequence

Return NIL

/*
Funcao      : Observacoes
Parametros  : cAcao := New/End
              cMarca 
Retorno     : Nil
Objetivos   : Manutenção de Observaçoes.
Autor       : Cristiano A. Ferreira 
Data/Hora   : 04/05/2000 - Protheus
Revisao     : Jeferson Barros Jr.              
Obs.        :
*/
*---------------------------------------*
Static Function Observacoes(cAcao,cMarca)
*---------------------------------------*
Local xRet := nil
Local cPaisEt := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA,"A1_PAIS")
Local aOrd, aSemSx3
Local cTipMen, cIdioma, cTexto, i

Local oMark
Local lInverte := .F.

Static aOld

Begin Sequence
   cAcao := Upper(AllTrim(cAcao))

   IF cAcao == "NEW"
      aOrd := SaveOrd({"EE4","EE1"})
      
      EE1->(dbSetOrder(1))
      EE4->(dbSetOrder(1))
      
      Private aHeader := {}, aCAMPOS := array(EE4->(fcount()))
      aSemSX3 := { {"WKMARCA","C",02,0},{"WKTEXTO","M",10,0}}

      aOld := {Select(), E_CriaTrab("EE4",aSemSX3,"WkMsg")}

      EE1->(dbSeek(xFilial()+TR_MEN+cPAISET))
      
      While !EE1->(Eof()) .And. EE1->EE1_FILIAL == xFilial("EE1") .And.;
            EE1->EE1_TIPREL == TR_MEN .And.;
            EE1->EE1_PAIS == cPAISET
            
         cTipMen := EE1->EE1_TIPMEN+"-"+Tabela("Y8",AVKEY(EE1->EE1_TIPMEN,"X5_CHAVE"))
         cIdioma := Posicione("SYA",1,xFilial("SYA")+EE1->EE1_PAIS,"YA_IDIOMA")
         
         IF EE4->(dbSeek(xFilial()+AvKey(EE1->EE1_DOCUM,"EE4_COD")+AvKey(cTipMen,"EE4_TIPMEN")+AvKey(cIdioma,"EE4_IDIOMA")))
            WkMsg->(dbAppend())
            cTexto := MSMM(EE4->EE4_TEXTO,AVSX3("EE4_VM_TEX",3))
         
            For i:=1 To MlCount(cTexto,AVSX3("EE4_VM_TEX",3))
               WkMsg->WKTEXTO := WkMsg->WKTEXTO+MemoLine(cTexto,AVSX3("EE4_VM_TEX",3),i)+ENTER
            Next     
         
            WkMsg->EE4_TIPMEN := EE4->EE4_TIPMEN
            WkMsg->EE4_COD    := EE4->EE4_COD
         ENDIF
         
         EE1->(dbSkip())
      Enddo
      
      dbSelectArea("WkMsg")
      WkMsg->(dbGoTop())

      aCampos := { {"WKMARCA",," "},;
                   ColBrw("EE4_COD","WkMsg"),;
                   ColBrw("EE4_TIPMEN","WkMsg"),;
                   {{|| MemoLine(WkMsg->WKTEXTO,AVSX3("EE4_VM_TEX",AV_TAMANHO),1)},"",AVSX3("EE4_VM_TEX",AV_TITULO)}}
      
      //GFP 25/10/2010
      aCampos := AddCpoUser(aCampos,"EE4","2")
                       
      oMark := MsSelect():New("WkMsg","WKMARCA",,aCampos,lInverte,@cMarca,{18,3,125,312})
      oMark:bAval := {|| EditObs(cMarca), oMark:oBrowse:Refresh() }
      xRet := oMark

      RestOrd(aOrd)

   Elseif cAcao == "END"

      IF Select("WkMsg") > 0
         WkMsg->(E_EraseArq(aOld[2]))
      Endif
      
      Select(aOld[1])
   Endif
End Sequence

Return xRet

/*
Funcao      : EditObs
Parametros  : cMarca
Retorno     : Nil
Objetivos   : Manutencao de Observacao.
Autor       : 
Data/Hora   : 
Revisao     : Jeferson Barros Jr.
              17/12/2003.
Obs.        :
*/
*-----------------------------*
Static Function EditObs(cMarca)
*-----------------------------*
Local nOpc, cMemo, oDlg

Local bOk     := {|| nOpc:=1, oDlg:End() }
Local bCancel := {|| oDlg:End() }

Local nRec

IF WkMsg->(!Eof())
   IF Empty(WkMsg->WKMARCA)
      nOpc:=0
      cMemo := WkMsg->WKTEXTO

      DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 7,0.5 TO 26,79.5 OF oMainWnd
      
         @ 05,05 SAY STR0018 PIXEL //"Tipo Mensagem"
         @ 05,45 GET WkMsg->EE4_TIPMEN WHEN .F. PIXEL
         @ 20,05 GET cMemo MEMO SIZE 300,105 OF oDlg PIXEL HSCROLL 

         DEFINE SBUTTON oBtnOk     FROM 130,246 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
         DEFINE SBUTTON oBtnCancel FROM 130,278 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg

      ACTIVATE MSDIALOG oDlg CENTERED

      IF nOpc == 1
         IF !Empty(nMarcado)
            nRec := WkMsg->(RecNo())
            WkMsg->(dbGoTo(nMarcado))
            WkMsg->WKMARCA := Space(2)
            WkMsg->(dbGoTo(nRec))
         Endif
         cObs := cObs + CMemo
         WkMsg->WKTEXTO := cMemo
         WkMsg->WKMARCA := cMarca
         nMarcado := nRec
      Endif
   Else
      cObs := ""
      WkMsg->WKMARCA := Space(2)
      nMarcado := 0
   Endif
Endif
     
Return NIL

/*
Funcao      : DecPoint()
Parametros  : cStr,nDec.
Retorno     : 
Objetivos   : Muda os pontos da casas decimais para virgula e as virgulas p/ pontos 
              Ex. 999,999,999.99 p/ 999.999.999,99
Autor       : Osman Medeiros Jr. 
Data/Hora   : 
Revisao     : Jeferson Barros Jr. 17/12/2003.
Obs.        :
*/
*---------------------------------*
Static Function DecPoint(cStr,nDec)
*---------------------------------*
Local cStrIni, cStrFim

Begin Sequence
   nDec := If(nDec = Nil,0,nDec)
   cStr := AllTrim(cStr)

   If nDec > 0 
      cStrFim := Right(cStr,nDec+1)
      cStrFim := StrTran(cStrFim,".",",")
   Else
      cStrFim := ""
   EndIf

   if nDec > 0 
      cStrIni := SubStr(cStr,1,Len(cStr)-(nDec+1))
      cStrIni := StrTran(cStrIni,",",".")  
   Else
      cStrIni := cStr
      cStrIni := StrTran(cStrIni,",",".")  
   Endif

End Sequence

Return AllTrim(cStrIni+cStrFim)

/*
Funcao      : AjustaData()
Parametros  : dData
Retorno     : cData
Objetivos   : Ajustar padronização de data conforme idioma
Autor       : Guilherme Fernandes Pilan - GFP
Data/Hora   : 22/11/2012 - 09:54
*/
*---------------------------------*
Static Function AjustaData(dData) 
*---------------------------------*
Local cData := cMes := cDia := cAno := ""

If lIngles
   cDia := AllTrim(Str(Day(dData)))
   cMes := AllTrim(Str(Month(dData)))
   cAno := AllTrim(Str(Year(dData)))

   cData := cMes + "/" + cDia + "/" + cAno   
Else
   cData := DtoC(dData)
EndIf

Return cData

*--------------------------------*  
Static Function PEM51TRANSPOR()   
*--------------------------------*
Local cCod := Left(SYQ->YQ_COD_DI,1)

SX5->(DbSetOrder(1))
SX5->(DbSeek(xFilial("SX5")+"Y3"+cCod))

If "INGLES" $ Upper(WorkId->EEA_IDIOMA) 
   cTrans := AllTrim(UPPER(SX5->X5_DESCENG))
ElseIf "ESPANHOL" $ Upper(WorkId->EEA_IDIOMA) 
   cTrans := AllTrim(UPPER(SX5->X5_DESCSPA))
Else
   cTrans := AllTrim(UPPER(SX5->X5_DESCRI))
EndIf

Return cTrans

*-----------------------------------------------------------------------------------------------------------------*
* FIM DO RDMAKE EECPEM51_RDM.PRW                                                                                  *
*-----------------------------------------------------------------------------------------------------------------*
