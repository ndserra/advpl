#INCLUDE "EECPEM11.ch"

/*
Programa        : EECPEM11.PRW
Objetivo        : Impressao da Fatura Comercial (Commercial Invoice)
Autor           : Cristiano A. Ferreira
Data/Hora       : 29/12/1999 09:23
Obs.            : 
*/

#include "EECRDM.CH"
#define NUMLINPAG 23
#define TAMDESC 29 //*** JBJ - 20/06/01 - 15:08 - Diminuir tamanho da descrição do produto.

/*
considera que estah posicionado no registro de embarque (EEC)
*/

/*
Funcao      : EECPEM11
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
User Function EECPEM11

Local lRet    := .t.
Local lIngles := UPPER(GetMv("MV_AVG0037",,"INGLES")) $ Upper(WorkId->EEA_IDIOMA)
Local nAlias  := Select()
Local aOrd    := SaveOrd({"EE9","SA2","EE2","DETAIL_P"})
Local nCod, aFields, cFile
LOCAL aMESES := {"ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"}

Local nInc, cPackag, acRETPAC, nFobValue, nComisValue

Private cPict := "999,999,999.99"

Private cPictDecPrc := if(EEC->EEC_DECPRC > 0, "."+Replic("9",EEC->EEC_DECPRC),"")
Private cPictDecPes := if(EEC->EEC_DECPES > 0, "."+Replic("9",EEC->EEC_DECPES),"")
Private cPictDecQtd := if(EEC->EEC_DECQTD > 0, "."+Replic("9",EEC->EEC_DECQTD),"")

Private cPictPreco := "999,999,999"+cPictDecPrc
Private cPictPeso  := "9,999,999"+cPictDecPes
Private cPictQtde  := "9,999,999"+cPictDecQtd
   
Private cObs   := ""
Private aNotify[6]
aFill(aNotify,"")

Private cFileMen:=""
Private cMarca := GetMark(), lInverte := .f.
Private lNcm := .f., lPesoBru := .t.

//USADO NO EECF3EE3 VIA SXB "E34" PARA GET ASSINANTE
Private M->cSEEKEXF:=""
Private M->cSEEKLOJA:=""

// *** Cria Arquivo de Trabalho ...
Private aHeader := {}, aCAMPOS := ARRAY(0)

// ** Disponibiliza a edicao e impressao das unidades de medida para o preco e peso dos itens...
Private lUnidade:=.f.,cUnQtde,cUnPeso,cUnPreco,nPesLiq:=0,nPesBru:=0

Private lPesoManual := GetMV("MV_AVG0004",,.F.) // By JPP - 06/03/2007 - 15:40 - Não Recalcular os pesos quando o parametro MV_AVG0004 for true.

Begin Sequence

   If EE9->(FieldPos("EE9_UNPES")) # 0 .And. EE9->(FieldPos("EE9_UNPRC")) # 0
      lUnidade:=.t.      
      cUnQtde:=CriaVar("EE9_UNPRC")
      cUnPeso:=CriaVar("EE9_UNPES")
      cUnPreco:=CriaVar("EE9_UNPRC")
   EndIf
   
   // *** Cria Arquivo de Trabalho ...
   nCod := AVSX3("EEN_IMPORT",3)+AVSX3("EEN_IMLOJA",3)

   aFields := {{"WKMARCA","C",02,0},;
               {"WKTIPO","C",01,0},;
               {"WKCODIGO","C",nCod,0},;
               {"WKDESCR","C",AVSX3("EEN_IMPODE",3),0}}
            
   cFile := E_CriaTrab(,aFields,"Work")
   IndRegua("Work",cFile+OrdBagExt(),"WKTIPO+WKCODIGO")

   EEM->(dbSetOrder(1)) // FILIAL+PREEMB+TIPO
   EE2->(dbSetOrder(1))
   EE9->(dbSetOrder(/*4*/2)) // FILIAL+PREEMB+NCM //NCF - 11/06/2013 - Alterada ordem para ordenar Embarque+Pedido+Sequencia
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   // ***
   
   // regras para carregar dados
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
   IF ! TelaGets()
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
   HEADER_P->AVG_C01_60:=ALLTRIM(cEXP_NOME) // TITULO 1
   HEADER_P->AVG_C02_60:=ALLTRIM(SA2->A2_END)+" "+ALLTRIM(SA2->A2_BAIRRO)  //NCF - 27/06/2013
   HEADER_P->AVG_C03_60:=ALLTRIM(SA2->A2_MUN)+" "+ALLTRIM(SA2->A2_EST+" "+AllTrim(BuscaPais(SA2->A2_PAIS))+" CEP: "+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6))) 
   HEADER_P->AVG_C04_60:=ALLTRIM(STR0001+AllTrim(cEXP_FONE)+STR0002+AllTrim(cEXP_FAX)) //"TEL.: "###" FAX: "
   
   HEADER_P->AVG_C19_20:=TRANSFORM(Posicione("SA2",1,xFILIAL("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_CGC"),AVSX3("A2_CGC",AV_PICTURE))
   
   // Informacoes do Cabecalho 
   HEADER_P->AVG_C06_60 := AllTrim(SA2->A2_MUN)+", "+Upper(IF(lIngles,cMonth(EEC->EEC_DTINVO),IF(EMPTY(EEC->EEC_DTINVO),"",aMeses[Month(EEC->EEC_DTINVO)])))+" "+StrZero(Day(EEC->EEC_DTINVO),2)+", "+Str(Year(EEC->EEC_DTINVO),4)+"."
   HEADER_P->AVG_C01_20 := EEC->EEC_NRCONH
   //HEADER_P->AVG_C02_20 := EEC->EEC_PREEMB
   If Type("lDocImpInv") <> "U" .And. lDocImpInv
      HEADER_P->AVG_C02_20:= EXP->EXP_NRINVO
   Else
      HEADER_P->AVG_C02_20:= EEC->EEC_PREEMB //nr. do processo
   EndIf
   
   // TO
   HEADER_P->AVG_C07_60 := EEC->EEC_IMPODE
   HEADER_P->AVG_C08_60 := EEC->EEC_ENDIMP
   HEADER_P->AVG_C09_60 := EEC->EEC_END2IM
   // GFP - 23/05/2012
   HEADER_P->AVG_C05_60 := EEC->EEC_RESPON   // CONTATO
   HEADER_P->AVG_C20_20 := If(!Empty(EEC->EEC_RESPON),Posicione("EE3",2,xFilial("EE3")+AvKey(EEC->EEC_RESPON,"EE3_NOME"),"EE3_FONE"),"")  //TELEFONE
   HEADER_P->AVG_C06_30 := If(!Empty(EEC->EEC_RESPON),Posicione("EE3",2,xFilial("EE3")+AvKey(EEC->EEC_RESPON,"EE3_NOME"),"EE3_EMAIL"),"") //EMAIL
   
   // Consignee
   HEADER_P->AVG_C10_60 := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_CONSIG+EEC->EEC_COLOJA,"A1_NOME")
   HEADER_P->AVG_C11_60 := EECMEND("SA1",1,EEC->EEC_CONSIG+EEC->EEC_COLOJA,.T.,58,1)
   HEADER_P->AVG_C12_60 := EECMEND("SA1",1,EEC->EEC_CONSIG+EEC->EEC_COLOJA,.T.,60,2)
   // GFP - 23/05/2012
   HEADER_P->AVG_C32_60 := Posicione("EE3",1,xFilial("EE3")+"I"+AvKey(EEC->EEC_CONSIG,"EE3_CONTAT")+AvKey(EEC->EEC_COLOJA,"EE3_COMPL"),"EE3_NOME")  //CONTATO
   HEADER_P->AVG_C21_20 := Posicione("EE3",1,xFilial("EE3")+"I"+AvKey(EEC->EEC_CONSIG,"EE3_CONTAT")+AvKey(EEC->EEC_COLOJA,"EE3_COMPL"),"EE3_FONE")  //TELEFONE
   HEADER_P->AVG_C08_30 := Posicione("EE3",1,xFilial("EE3")+"I"+AvKey(EEC->EEC_CONSIG,"EE3_CONTAT")+AvKey(EEC->EEC_COLOJA,"EE3_COMPL"),"EE3_EMAIL") //EMAIL
   
   // Titulos ...
   HEADER_P->AVG_C01_10 := EEC->EEC_MOEDA
   
   If lUnidade .And. !Empty(cUnPeso)
      // ** Verifica se a unidade de medida para o peso esta cadastrada no idioma ...
      IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnPeso))
         MsgStop(STR0003+cUnPeso+STR0004+EEC->EEC_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
      Else
         HEADER_P->AVG_C02_10 := AllTrim(EE2->EE2_DESCMA)
      EndIf
   Else
      HEADER_P->AVG_C02_10 := "KG"
   EndIf 
   
   // Packing
   //quebrar linha para 1 virgula
   IF ( len(alltrim(EEC->EEC_PACKAG))>0 )
      cPACKAG  :=ALLTRIM(EEC->EEC_PACKAG)
      acRETPAC:={}
      FOR nINC:=1 TO LEN(cPACKAG)
         nCONT:=AT(",",cPACKAG)	  //PREPARADO PARA VARIAS VIRGULAS
         nCONT:=IF(nCONT==0,LEN(cPACKAG),nCONT)
         AADD(acRETPAC,SUBSTR(cPACKAG,1,nCONT)) //DFS - 14/12/2010 - Retirado o -1 que estava cortando sempre a ultima letra do campo.
         IF ( LEN(cPACKAG)<nCONT+1 )
            EXIT 
         ENDIF
         cPACKAG  :=ALLTRIM(SUBSTR(cPACKAG,nCONT+1))
      NEXT nINC
	  //GRAVAR APENAS DUAS VIRGULAS
      HEADER_P->AVG_C13_60 := IF(LEN(acRETPAC)>=1,acRETPAC[1],"") //EEC->EEC_PACKAG
      HEADER_P->AVG_C31_60 := IF(LEN(acRETPAC)>=2,acRETPAC[2],"") //EEC->EEC_PACKAG
   ENDIF
   
   If !lUnidade .Or. lPesoManual   // By JPP - 06/03/2007 - 15:40 - Não Recalcular os pesos quando o parametro MV_AVG0004 for true.
      // Pesos/Cubagem
      HEADER_P->AVG_C03_20 := AllTrim(Transf(EEC->EEC_PESLIQ,cPictPeso))
      HEADER_P->AVG_C04_20 := AllTrim(Transf(EEC->EEC_PESBRU,cPictPeso))
   EndIf
   
   cPictCub := AllTrim(StrTran(Upper(AVSX3("EEC_CUBAGE",6)),"@E",""))
   HEADER_P->AVG_C05_20 := Transf(EEC->EEC_CUBAGE,cPictCub)  //AVSX3("EEC_CUBAGE",6))
   
   // TOTAIS
   nComisValue:= (EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
   nFobValue :=  (EEC->EEC_TOTPED+EEC->EEC_DESCON)-nComisValue
   //HEADER_P->AVG_C12_20 := Transf(nFobValue,AVSX3("EEC_TOTPED",6))
   
   HEADER_P->AVG_C05_30 := ALLTRIM(Transf(nComisValue,cPICT))
   HEADER_P->AVG_C14_20 := ALLTRIM(Transf(nFobValue,cPICT))  //AVSX3("EEC_TOTPED",6))
   HEADER_P->AVG_C15_20 := ALLTRIM(Transf(EEC->EEC_FRPREV,cPICT))  //AVSX3("EEC_FRPREV",6))
   HEADER_P->AVG_C16_20 := ALLTRIM(Transf(EEC->EEC_SEGPRE,cPICT))  //AVSX3("EEC_SEGPRE",6))
   HEADER_P->AVG_C17_20 := ALLTRIM(Transf(EEC->EEC_FRPCOM+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2")-EEC->EEC_DESCON,cPict))
   HEADER_P->AVG_C18_20 := ALLTRIM(Transf(EEC->EEC_TOTPED,cPICT))  //AVSX3("EEC_TOTPED",6))
   
   HEADER_P->AVG_C03_10 := EEC->EEC_INCOTE
   
   // pais de origem
   HEADER_P->AVG_C01_30 := Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM")
   
   // VIA
   SYQ->(dbSetOrder(1))
   SYQ->(dbSeek(xFilial()+EEC->EEC_VIA))
   
   HEADER_P->AVG_C02_30 := IF(Left(SYQ->YQ_COD_DI,1) == "4",IF(lIngles,"BY AIR","AEREA"), If(Left(SYQ->YQ_COD_DI,1) == "1",IF(lIngles,"MARITIME","MARITIMO"),SYQ->YQ_DESCR)) // VIA //CORRETO 
   
   IF Left(SYQ->YQ_COD_DI,1) == "7" // Rodoviario
      HEADER_P->AVG_C14_60 := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA)
   Else
      HEADER_P->AVG_C14_60 := Posicione("EE6",1,xFilial("EE6")+EEC->EEC_EMBARC,"EE6_NOME")// Embarcacao
   Endif
   //CASE PARA HEADER_P->AVG_C03_30
   IF Left(SYQ->YQ_COD_DI,1) == "1" // MARITIMO
      HEADER_P->AVG_C05_10:="FOB"
   Else 
      HEADER_P->AVG_C05_10:="FCA"
   Endif
   
   SYR->(dbSeek(xFilial()+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))
   
   //*** BHF - 12/08/08 - Não descreve a origem no total.    
   IF Posicione("SYJ",1,xFilial("SYJ")+EEC->EEC_INCOTE,"YJ_CLFRETE") $ cSim
      HEADER_P->AVG_C03_30 := " "+AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // Porto de Destino
   Else
      HEADER_P->AVG_C03_30 := " "+AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR")) // Porto de Origem
   Endif
   
   // Port of Unloading
   HEADER_P->AVG_C04_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // +" "+AllTrim(BuscaPais(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_PAIS")))
   
   // Port of Loading
   //*** BHF - 12/08/08 - Verific. existência do Porto interm... Se preenchido, recebe o porto interm., senão, porto de origem.
   If EEC->(FieldPos("EEC_PTINT")) > 0 .And. !Empty(EEC->EEC_PTINT)
      HEADER_P->AVG_C13_20 := alltrim(Posicione("SY9",2,xFilial("SY9")+EEC->EEC_PTINT,"Y9_DESCR")) //+" "+AllTrim(BuscaPais(Posicione("SY9",2,xFilial("SY9")+EEC->EEC_PTINT,"Y9_PAIS")))
   Else 
      HEADER_P->AVG_C13_20 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR")) //+" "+AllTrim(BuscaPais(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_PAIS")))
   EndIf
   //***
   
   // MARKS
   cMemo := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
   HEADER_P->AVG_C06_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),1)
   HEADER_P->AVG_C07_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),2)
   HEADER_P->AVG_C08_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),3)
   HEADER_P->AVG_C09_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),4)
   HEADER_P->AVG_C10_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),5)
   //HEADER_P->AVG_C11_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),6)
   
   // NOTIFY
   HEADER_P->AVG_C15_60 := aNotify[1]
   HEADER_P->AVG_C16_60 := aNotify[2]
   HEADER_P->AVG_C17_60 := aNotify[3]
   HEADER_P->AVG_C18_60 := aNotify[4]
   HEADER_P->AVG_C19_60 := aNotify[5]
   HEADER_P->AVG_C20_60 := aNotify[6]
   
   //DOCUMENTS
   HEADER_P->AVG_C21_60 := cC2160
   HEADER_P->AVG_C22_60 := cC2260
   HEADER_P->AVG_C23_60 := cC2360
   HEADER_P->AVG_C24_60 := cC2460
   HEADER_P->AVG_C29_60 := cC2960
   HEADER_P->AVG_C30_60 := cC3060
   
   // Cond.Pagto ...
   HEADER_P->AVG_C01100 := SY6Descricao(EEC->EEC_CONDPA+Str(EEC->EEC_DIASPA,AVSX3("EEC_DIASPA",3),AVSX3("EEC_DIASPA",4)),EEC->EEC_IDIOMA,1)+" "+; // Terms of Payment   //NCF - 27/06/2013
                           LEFT(SY6Descricao(EEC->EEC_CONDPA+Str(EEC->EEC_DIASPA,AVSX3("EEC_DIASPA",3),AVSX3("EEC_DIASPA",4)),EEC->EEC_IDIOMA,2),39)
   // I/L
   HEADER_P->AVG_C25_60 := EEC->EEC_LICIMP
   // L/C
   HEADER_P->AVG_C11_20 := EEC->EEC_LC_NUM
   
   // RODAPE
   HEADER_P->AVG_C26_60 := cEXP_NOME
   
   HEADER_P->AVG_C27_60 := cEXP_CONTATO
   HEADER_P->AVG_C28_60 := cEXP_CARGO
   HEADER_P->AVG_C01150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),1)
   HEADER_P->AVG_C02150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),2)
   HEADER_P->AVG_C03150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),3)
   HEADER_P->AVG_C04150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),4)
   HEADER_P->AVG_C05150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),5)
   
   //Acb - 22/10/2010 - Tratamento para impressão de data de vencimento.
   cDataVenc := ""
   
   SY6->(DbsetOrder(1))
   SY6->(DbSeek(xFilial("SY6")+EEC->EEC_CONDPA))
   
   If !Empty(EEC->EEC_DTEMBA)  // GFP - 01/10/2012
      Do Case
         Case SY6->Y6_TIPO == "2"
   	        cDataVenc := "Pagamiento efectuado en " + DtoC(EEC->EEC_DTEMBA)  // GFP - 11/10/2012
      	 Case SY6->Y6_TIPO == "1"
	        cDataVenc := "Vencimiento: " + DtoC(EEC->EEC_DTEMBA + SY6->Y6_DIAS_PA)   // GFP - 11/10/2012
         Case SY6->Y6_TIPO == "3"
	        If !Empty(SY6->Y6_DIAS_01)
		       cDataVenc += "Vencimientos: " + DtoC(EEC->EEC_DTEMBA + SY6->Y6_DIAS_01) + " - "   // GFP - 11/10/2012
		    End IF
		    If !Empty(SY6->Y6_DIAS_02)
		       cDataVenc += Dtoc(EEC->EEC_DTEMBA + SY6->Y6_DIAS_02) + " - "
		    EndIf
		    If !Empty(SY6->Y6_DIAS_03)
		       cDataVenc += Dtoc(EEC->EEC_DTEMBA + SY6->Y6_DIAS_03) + " - "
		    EndIf
		    If !Empty(SY6->Y6_DIAS_04)
		       cDataVenc += Dtoc(EEC->EEC_DTEMBA + SY6->Y6_DIAS_04) + " - "
		    End If
    	    If !Empty(SY6->Y6_DIAS_05)
		       cDataVenc += Dtoc(EEC->EEC_DTEMBA + SY6->Y6_DIAS_05) + " - "
		    EndIf
		    If !Empty(SY6->Y6_DIAS_06)
		       cDataVenc += Dtoc(EEC->EEC_DTEMBA + SY6->Y6_DIAS_06) + " - "
		    EndIf
		    If !Empty(SY6->Y6_DIAS_07)
		       cDataVenc += Dtoc(EEC->EEC_DTEMBA + SY6->Y6_DIAS_07) + " - "
		    End
		    If !Empty(SY6->Y6_DIAS_08)
		       cDataVenc += Dtoc(EEC->EEC_DTEMBA + SY6->Y6_DIAS_08) + " - "
		    EndIf
		    If !Empty(SY6->Y6_DIAS_09)
		       cDataVenc += Dtoc(EEC->EEC_DTEMBA + SY6->Y6_DIAS_09) + " - "
		    EndIf
		    If !Empty(SY6->Y6_DIAS_10)
		       cDataVenc += Dtoc(EEC->EEC_DTEMBA + SY6->Y6_DIAS_10)
		    EndIf
      End Case
   Else
      cDataVenc := ""
   EndIf
   
   HEADER_P -> AVG_C06150 := cDataVenc
   
   GravaItens()

   If lUnidade .And. !lPesoManual   // By JPP - 06/03/2007 - 15:40 - Não Recalcular os pesos quando o parametro MV_AVG0004 for true.
      HEADER_P->AVG_C03_20 := AllTrim(Transf(nPesLiq,cPictPeso))
      HEADER_P->AVG_C04_20 := AllTrim(Transf(nPesBru,cPictPeso))
   EndIf
   
   HEADER_P->(dbUnlock())
   
   //*** JBJ - 19/06/01 11:25 - Gravar dados no histórico - (Inicio)
  
   HEADER_H->(dbAppend())
   AvReplace("HEADER_P","HEADER_H")

   DETAIL_P->(dbSetOrder(0))      
   DETAIL_P->(DbGoTop())
   Do While ! DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo

   DETAIL_P->(dbSetOrder(1))      
   
   // (Fim)
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
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function GravaItens

Local nTotQtde := 0
Local nTotal   := 0
Local cUnidade := ""
Local bCond    := IF(lNcm,{|| EE9->EE9_POSIPI == cNcm },{|| .t. })
Local cNcm     := "",lDescUnid:=.f., i:=0, gi_W:=0 , nX
PRIVATE nLin :=0,nPag := 1

While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
      EE9->EE9_PREEMB == EEC->EEC_PREEMB

   IF lNcm
      cNcm := EE9->EE9_POSIPI
      
      If lUnidade .And. !lDescUnid .And. ( !Empty(cUnQtde) .Or. !Empty(cUnPreco) )
         AppendDet()
         // ** Verifica se a unidade de medida para o qtde esta cadastrada no idioma ...
         IF !Empty(cUnQtde) .And. ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnQtde))
            MsgStop(STR0003+cUnQtde+STR0004+EEC->EEC_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
         Else
            DETAIL_P->AVG_C01_20 := AllTrim(EE2->EE2_DESCMA)         
         EndIf
         
         // ** Verifica se a unidade de medida para o preco esta cadastrada no idioma ...
         IF !Empty(cUnPreco) .And. ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnPreco))
            MsgStop(STR0003+cUnPreco+STR0004+EEC->EEC_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
         Else
            DETAIL_P->AVG_C06_20 := AllTrim(EEC->EEC_MOEDA)+"/"+EE2->EE2_DESCMA
         EndIf

         lDescUnid:=.t.

         UnlockDet()
      
      ElseIf !lUnidade
         IF cUnidade <> EE9->EE9_UNIDAD  
            cUnidade := EE9->EE9_UNIDAD
            AppendDet()

            IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
               MsgStop(STR0003+EE9->EE9_UNIDAD+STR0004+EEC->EEC_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
            Endif
            DETAIL_P->AVG_C06_20 := AllTrim(EEC->EEC_MOEDA)+"/"+EE2->EE2_DESCMA
         
            UnlockDet()
         Endif   

      EndIf

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
         
      If lUnidade .And. !lDescUnid .And. ( !Empty(cUnQtde) .Or. !Empty(cUnPreco) )
         AppendDet()
         // ** Verifica se a unidade de medida para o qtde esta cadastrada no idioma ...
         IF !Empty(cUnQtde) .And.  ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnQtde))
            MsgStop(STR0003+cUnQtde+STR0004+EEC->EEC_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
         Else
            DETAIL_P->AVG_C01_20 := AllTrim(EE2->EE2_DESCMA)
         EndIf
        
         // ** Verifica se a unidade de medida para o preco esta cadastrada no idioma ...
         IF !Empty(cUnPreco) .And. ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+cUnPreco))
            MsgStop(STR0003+cUnPreco+STR0004+EEC->EEC_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
         Else
            DETAIL_P->AVG_C06_20 := AllTrim(EEC->EEC_MOEDA)+"/"+EE2->EE2_DESCMA
         EndIf

         UnlockDet()
         
         lDescUnid:=.t.
         
      ElseIf !lUnidade
            
         IF cUnidade <> EE9->EE9_UNIDAD  
            cUnidade := EE9->EE9_UNIDAD
            AppendDet()

            IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
               MsgStop(STR0003+EE9->EE9_UNIDAD+STR0004+EEC->EEC_IDIOMA,STR0005) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
            Endif
                  
            DETAIL_P->AVG_C06_20 := AllTrim(EEC->EEC_MOEDA)+"/"+EE2->EE2_DESCMA
         
         EndIf
         
         UnlockDet()
      Endif   
      
      AppendDet()           
      
      If lUnidade
         DETAIL_P->AVG_C01_20 := ALLTRIM(Transf(AVTransUnid(EE9->EE9_UNIDAD,cUnQtde,EE9->EE9_COD_I,EE9->EE9_SLDINI,.f.),cPictQtde)) 
         DETAIL_P->AVG_C04_20 := AllTrim(Transf(AVTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSLQTO,.f.),cPictPeso))
      Else
         DETAIL_P->AVG_C01_20 := ALLTRIM(Transf(EE9->EE9_SLDINI,cPictQtde)) 
         DETAIL_P->AVG_C04_20 := AllTrim(Transf(EE9->EE9_PSLQTO,cPictPeso))
      EndIf
      
      DETAIL_P->AVG_C02_20 := Transf(EE9->EE9_COD_I,AVSX3("EE9_COD_I",6))
      If !Empty(EE9->EE9_REFCLI)  // GFP - 05/10/2012
         DETAIL_P->AVG_C03_20 := Alltrim(EE9->EE9_REFCLI)
      Else
         DETAIL_P->AVG_C03_20 := Alltrim(EE9->EE9_PEDIDO)
      EndIf
      
      cMemo := MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))
      
      //DFS - 28/11/12 - Retirado tratamento da Commercial Invoice modelo 1, visto que, independente do idioma do processo,  
      //sistema deve levar em consideração a descrição digitada no EE9. Ao digitar o idioma na capa do processo e
      // colocar o codigo do produto, sistema trará o idioma corrente. Porém, caso houvesse alteração na descrição, esta não era levada ao Relatório.
      //DETAIL_P->AVG_C01_60 := AA100Idioma(EE9->EE9_COD_I)  //GFP - 29/05/2012 - Tratamento de idiomas.
      DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,1)
            
      IF lPesoBru
         If lUnidade
            DETAIL_P->AVG_C05_20 := AllTrim(Transf(AVTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSBRTO,.f.),cPictPeso))
            //DETAIL_P->AVG_C06_20 := AllTrim(Transf(AVTransUnid(EE9->EE9_UNIDAD,cUnPreco,EE9->EE9_COD_I,EE9->EE9_PRECO,.f.),cPictPreco))
         Else               
            DETAIL_P->AVG_C05_20 := AllTrim(Transf(EE9->EE9_PSBRTO,cPictPeso))
            //DETAIL_P->AVG_C06_20 := AllTrim(Transf(EE9->EE9_PRECO,cPictPreco))
         EndIf
      ENDIF
      
      // FJH - 17/02/06 - Mudando para fora do lPesoBrut para o preco unit sair mesmo quando o peso brut não.
      If lUnidade
         DETAIL_P->AVG_C06_20 := AllTrim(Transf(AVTransUnid(EE9->EE9_UNIDAD,cUnPreco,EE9->EE9_COD_I,EE9->EE9_PRECO,.f.),cPictPreco))
      Else
         DETAIL_P->AVG_C06_20 := AllTrim(Transf(EE9->EE9_PRECO,cPictPreco))
      Endif
      // FJH
      
      If EEC->EEC_PRECOA = "1"
         DETAIL_P->AVG_C07_20 := AllTrim(Transf(EE9->EE9_PRCINC,cPict))
      Else
         DETAIL_P->AVG_C07_20 := AllTrim(Transf(Round(EE9->EE9_PRECO*EE9->EE9_SLDINI,2),cPict))
      EndIf
      
      For i := 2 To MlCount(cMemo,TAMDESC,3)
         IF !EMPTY(MemoLine(cMemo,TAMDESC,i))
            UnLockDet()
            AppendDet()
            DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,i)
         ENDIF
      Next
      
      // Totaliza os valores da quantidade e dos pesos liquido e bruto...
      If lUnidade
         nTotQtde := nTotQtde+AVTransUnid(EE9->EE9_UNIDAD,cUnQtde,EE9->EE9_COD_I,EE9->EE9_SLDINI,.f.)
         nPesLiq  += AVTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSLQTO,.f.)

         IF lPesoBru
            nPesBru +=AVTransUnid(EE9->EE9_UNIDAD,cUnPeso,EE9->EE9_COD_I,EE9->EE9_PSBRTO,.f.)
         EndIf      
  
      Else
         nTotQtde := nTotQtde+EE9->EE9_SLDINI            
      EndIf

      If EEC->EEC_PRECOA = "1"
         nTotal   := nTotal  + EE9->EE9_PRCINC
      Else      
         nTotal   := nTotal  + Round(EE9->EE9_PRECO*EE9->EE9_SLDINI,2)
      EndIf
      
      UnLockDet()
      
      EE9->(dbSkip())         
   Enddo
Enddo

AppendDet()
DETAIL_P->AVG_C01_20 := Replic("-",20)
DETAIL_P->AVG_C04_20 := Replic("-",20)
DETAIL_P->AVG_C05_20 := Replic("-",20)
DETAIL_P->AVG_C07_20 := Replic("-",20)
UnLockDet()

AppendDet()

DETAIL_P->AVG_C01_20 := ALLTRIM(Transf(nTotQtde,cPictQtde))

If lUnidade  .And. !lPesoManual   // By JPP - 06/03/2007 - 15:40 - Não Recalcular os pesos quando o parametro MV_AVG0004 for true.
   DETAIL_P->AVG_C04_20 := ALLTRIM(Transf(nPesLiq,cPictPeso))
   DETAIL_P->AVG_C05_20 := ALLTRIM(Transf(nPesBru,cPictPeso))
   DETAIL_P->AVG_C07_20 := ALLTRIM(Transf(nTotal,cPict))
Else
   DETAIL_P->AVG_C04_20 := ALLTRIM(Transf(EEC->EEC_PESLIQ,cPictPeso))
   DETAIL_P->AVG_C05_20 := ALLTRIM(Transf(EEC->EEC_PESBRU,cPictPeso))
   DETAIL_P->AVG_C07_20 := ALLTRIM(Transf(nTotal,cPict))
EndIf

UnLockDet()

// Gravar todas as N.F.  Igor Chiba 18/08/08
cNotas := ""
EEM->(dbSeek(xFilial()+EEC->EEC_PREEMB+EEM_NF))
lMV_AVG0161:=GETMV("MV_AVG0161",,.T.)// parametro que indica se irá imprimir n° da NF na Commercial  Invoice  

DO While EEM->(!Eof() .And. EEM_FILIAL == xFilial()) .And.;
         EEM->EEM_PREEMB == EEC->EEC_PREEMB .And. EEM->EEM_TIPOCA == EEM_NF .AND. lMV_AVG0161
   
   SysRefresh() 
   
   IF Empty(cNotas)
       cNotas := cNotas+STR0006  //"Notas Fiscais:"
   Endif
   cNotas := cNotas+" "+AllTrim(EEM->EEM_NRNF)+if(!Empty(EEM->EEM_SERIE),"-"+AllTrim(EEM->EEM_SERIE),"")

 
   EEM->(dbSkip())
Enddo

For i:=1 To MlCount(cNotas,30)
   AppendDet()
   DETAIL_P->AVG_C01_60 := MemoLine(cNotas,30,i)
   UnLockDet()
Next i

HEADER_P->AVG_C12_20 := ALLTRIM(Transf(nTotal,cPict))

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

//8888888888888888888888888888888888888888888888888888888888888888888888*8888888
//NCF - 24/06/2013 - INICIO - Para imprimir Observações na descrição dos itens 
If !Empty(   If( EEC->(FieldPos("EEC_LC_NUM")) > 0,EEC->EEC_LC_NUM,"" )   ) 
   aOrdEEL := SaveOrd("EEL")
   EEL->(DbSeek(xFilial("EEL")+EEC->EEC_LC_NUM))
   cObsCrtCre := MSMM(EEL->EEL_TEXTO,AVSX3("EEL_VM_TEX",3))
   nLinObsCDC := MlCount(cObsCrtCre,AVSX3("EEL_VM_TEX",3))
   If nLinObsCDC > 0     
      AppendDet()
      DETAIL_P->AVG_C01_60 := MemoLine(cObsCrtCre,AVSX3("EEL_VM_TEX",3),1)
      UnLockDet()                                                                   	          
      If nLinObsCDC > 1
         For nX:=2 To nLinObsCDC
            AppendDet()
            DETAIL_P->AVG_C01_60 := MemoLine(cObsCrtCre,AVSX3("EEL_VM_TEX",3),nX) 
            UnLockDet()  
         Next     
      EndIf
   EndIf
   RestOrd(aOrdEEL)
EndIf 
//NCF - 24/06/2013 - FIM - Para imprimir Observações na descrição dos itens
//88888888888888888888888888888888888888888888888888888888888888888888888888888 

DO WHILE MOD(nLin,NUMLINPAG) <> 0
   APPENDDET()   
ENDDO 

Return NIL

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
   nLin := nLin+1
   IF nLin > NUMLINPAG
      nLin := 1
      nPag := nPag+1
   ENDIF
   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSEQREL   
   DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB  //DFS - 19/07/13 - Inclusão de chave para trazer o item no relatório.   
   DETAIL_P->AVG_CONT   := STRZERO(nPag,6,0)
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

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.
Local nOpc := 0
Local oDlg

Local bOk     := {||nOpc:=1,oDlg:End()}
Local bCancel := {||nOpc:=0,oDlg:End()}

Local bSet  := {|x,o| lNcm := x, o:Refresh(), lNcm }
Local bSetP := {|x,o| lPesoBru := x, o:Refresh(), lPesoBru }
Local bHide,bHideAll

 /* {"WKMARCA",," "},;*/
//{{||if(AllTrim(Work->WKTIPO)=="A","Agente","Notify")},,"Tipo"},;
Local aCampos := {{"WKMARCA",," "},;
                   {"WKCODIGO",,STR0007},; //"Código"
                   {"WKDESCR",,STR0008}} //"Descrição"

Local oFld, oFldDoc, oFldNot,oFldCFG, oBtnOk, oBtnCancel
Local oYes, oNo, oYesP, oNoP, oMark, oMark2, oMark3

Local bShow    := {|nTela,o| if(nTela==2,dbSelectArea("Work"),if(nTela==3,dbSelectArea("WkMsg"),;
                                 if(nTela==4,dbSelectArea("Work_Men"),))),;
                              o := if(nTela==2,oMark,if(nTela==3,oMark2,oMark3)):oBrowse,;
                              o:Show(),o:SetFocus() }

Local n,i,nTamLoj,cKey,cLoja,cImport
Local xx := "",nPosLin:=20

Private aMarcados[2], nMarcado := 0

Begin Sequence
   
   If lUnidade
       bHide    := {|nTela| if(nTela==2,oMark:oBrowse:Hide(),;
                              if(nTela==3,oMark2:oBrowse:Hide(),;
                                if(nTela==4,oMark3:oBrowse:Hide(),;
                                  If(nTela==5,(oMark:oBrowse:Hide(),oMark2:oBrowse:Hide(),oMark3:oBrowse:Hide()),))))}
       
       bHideAll := {|| Eval(bHide,2), Eval(bHide,3), Eval(bHide,4),Eval(bHide,5) }
       
   Else
       bHide    := {|nTela| if(nTela==2,oMark:oBrowse:Hide(),;
                              if(nTela==3,oMark2:oBrowse:Hide(),;
                                if(nTela==4,oMark3:oBrowse:Hide(),))) }

       bHideAll := {|| Eval(bHide,2), Eval(bHide,3), Eval(bHide,4)}                                                         
   EndIf

   // Notify - TRP - 19/08/2011 - Caso o embarque possua Carta de Crédito, buscar as informações de Notify da Carta de Crédito.   
   If !Empty(EEC->EEC_LC_NUM) .And. EEL->(dbSeek(xFilial("EEL")+EEC->EEC_LC_NUM))
       Work->(dbAppend())
       Work->WKTIPO   := "N"
       Work->WKCODIGO := EEL->EEL_IMPORT+EEL->EEL_IMLOJA
       Work->WKDESCR  := EEL->EEL_IMPODE
   Else
      EEN->(dbSeek(xFilial()+EEC->EEC_PREEMB+OC_EM))

      While EEN->(!Eof() .And. EEN_FILIAL == xFilial("EEN")) .And.;
          EEN->EEN_PROCES+EEN->EEN_OCORRE == EEC->EEC_PREEMB+OC_EM
       
         SysRefresh()
      
         Work->(dbAppend())
         Work->WKTIPO   := "N"
         Work->WKCODIGO := EEN->EEN_IMPORT+EEN->EEN_IMLOJA
         Work->WKDESCR  := EEN->EEN_IMPODE
       
         EEN->(dbSkip())
      Enddo   
   Endif   
      
      Work->(dbGoTop())
   
   DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 9,0 TO 28,80 OF oMainWnd
   
     //oFld := TFolder():New(1,1,{STR0009,STR0010,STR0011,STR0012},{"IPC","IBC","OBS","MEN"},oDlg,,,,.T.,.F.,315,127) //"Documentos Para"###"Notify's"###"Mensagens"###"Observações"
     
     oFld := TFolder():New(1,1,If(lUnidade,{STR0009,STR0010,STR0011,STR0012,STR0021},{STR0009,STR0010,STR0011,STR0012}),; //"Configurações"
             If(lUnidade,{"IPC","IBC","OBS","MEN","CFG"},{"IPC","IBC","OBS","MEN"}),oDlg,,,,.T.,.F.,315,127) //"Documentos Para"###"Notify's"###"Mensagens"###"Observações"
     
     aEval(oFld:aControls,{|x| x:SetFont(oDlg:oFont) })
          
     // Documentos Para
     oFldDoc := oFld:aDialogs[1]     
     
     
     If !lUnidade
        @ 10,001 SAY STR0013 SIZE 232,10 PIXEL OF oFldDoc //"Imprime N.C.M."
      
        oYes := TCheckBox():New(10,42,STR0014,{|x| If(PCount()==0, lNcm,Eval(bSet, x,oNo ))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
        oNo  := TCheckBox():New(10,65,STR0015,{|x| If(PCount()==0,!lNcm,Eval(bSet,!x,oYes))},oFldDoc,21,10,,,,,,,,.T.) //"Não"
   
        @ 10,100 SAY STR0016 SIZE 232,10 PIXEL OF oFldDoc //"Imprime Peso Bruto"
     
        oYesP := TCheckBox():New(10,157,STR0014,{|x| If(PCount()==0, lPesoBru,Eval(bSetP, x,oNoP ))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
        oNoP  := TCheckBox():New(10,180,STR0015,{|x| If(PCount()==0,!lPesoBru,Eval(bSetP,!x,oYesP))},oFldDoc,21,10,,,,,,,,.T.) //"Não"
     Else
        nPosLin := 10
     EndIf     

     M->cCONTATO   := EEC->EEC_RESPON  //cEXP_CONTATO
     M->cEXP_CARGO := "EXPORT COORDINATOR"     
     
     @ nPosLin,001 SAY STR0017 SIZE 232,10 PIXEL OF oFldDoc //"Assinante"
     @ nPosLin,043 GET M->cCONTATO SIZE 120,08 PIXEL OF oFldDoc
        
     @ nPosLin+10,001 SAY STR0018 SIZE 232,10 PIXEL OF oFldDoc //"Cargo"
     @ nPosLin+10,043 GET M->cEXP_CARGO SIZE 120,08 PIXEL OF oFldDoc
     
     @ nPosLin+24,001 SAY STR0019 SIZE 232,10 PIXEL OF oFldDoc //"Doct.Para"
     
     @ nPosLin+24,043 GET cC2160 SIZE 120,08 PIXEL OF oFldDoc     
     @ nPosLin+34,043 GET cC2260 SIZE 120,08 PIXEL OF oFldDoc
     @ nPosLin+44,043 GET cC2360 SIZE 120,08 PIXEL OF oFldDoc
     @ nPosLin+54,043 GET cC2460 SIZE 120,08 PIXEL OF oFldDoc
     @ nPosLin+64,043 GET cC2960 SIZE 120,08 PIXEL OF oFldDoc
     @ nPosLin+74,043 GET cC3060 SIZE 120,08 PIXEL OF oFldDoc
     
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

     If lUnidade
        // Folder Configuções ...
        oFldCFG:= oFld:aDialogs[5]

        @ 05,03 To 60,310 LABEL STR0022 OF oFldCFG PIXEL //"Unidades de Medida"
        
        @ 15,08 SAY STR0023 SIZE 50,07 OF oFldCFG PIXEL //"U.M. Qtde.:"
        @ 15,55 MSGET cUnQtde SIZE 20,07 F3 "SAH" OF oFldCFG PIXEL

        @ 27,08 SAY STR0024 SIZE 50,07 OF oFldCFG PIXEL //"U.M. Preço.:"
        @ 27,55 MSGET cUnPreco SIZE 20,07 F3 "SAH" OF oFldCFG PIXEL 
                
        @ 39,08 SAY STR0025 SIZE 50,07 OF oFldCFG PIXEL //"U.M. Peso.:"
        @ 39,55 MSGET cUnPeso SIZE 20,07 F3 "SAH" OF oFldCFG PIXEL 
             
        @ 65,03 To 100,310 LABEL STR0026 OF oFldCFG PIXEL     //"Impressão"
  
        @ 75,08 SAY STR0013 SIZE 232,10 PIXEL OF oFldCFG //"Imprime N.C.M."
      
        oYes := TCheckBox():New(75,62,STR0014,{|x| If(PCount()==0, lNcm,Eval(bSet, x,oNo ))},oFldCFG,21,10,,,,,,,,.T.) //"Sim"
        oNo  := TCheckBox():New(75,85,STR0015,{|x| If(PCount()==0,!lNcm,Eval(bSet,!x,oYes))},oFldCFG,21,10,,,,,,,,.T.) //"Não"
   
        @ 87,08 SAY STR0016 SIZE 232,10 PIXEL OF oFldCFG //"Imprime Peso Bruto"
  
        oYesP := TCheckBox():New(87,62,STR0014,{|x| If(PCount()==0, lPesoBru,Eval(bSetP, x,oNoP ))},oFldCFG,21,10,,,,,,,,.T.) //"Sim"
        oNoP  := TCheckBox():New(87,85,STR0015,{|x| If(PCount()==0,!lPesoBru,Eval(bSetP,!x,oYesP))},oFldCFG,21,10,,,,,,,,.T.) //"Não"
    
     EndIf   
     
     Eval(bHideAll)
     
     If lUnidade
        oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),;
                                              IF(nOption <> 1 .And. nOption <> 5,Eval(bShow,nOption),) }
     ELse
        oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),;
                                              IF(nOption <> 1,Eval(bShow,nOption),)}
     EndIf

     DEFINE SBUTTON oBtnOk     FROM 130,258 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
     DEFINE SBUTTON oBtnCancel FROM 130,288 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg

   ACTIVATE MSDIALOG oDlg CENTERED
   
   IF nOpc == 0
      Break
   Endif
   
   lRet := .t.
   SA1->(dbSetOrder(1))
   n := 1
   
   //TRP - 19/08/2011 - Caso o embarque possua Carta de Crédito, buscar as informações de Notify da Carta de Crédito.  
   If !Empty(EEC->EEC_LC_NUM) .And. EEL->(dbSeek(xFilial("EEL")+EEC->EEC_LC_NUM))
       aNotify[1] := EEL->EEL_IMPODE
       aNotify[2] := EEL->EEL_IMPEND
       aNotify[3] := EEL->EEL_IMPEN2
       If SA1->(dbSeek(xFilial("SA1")+EEL->EEL_IMPORT+EEL->EEL_IMLOJA))
          aNotify[4]    := SA1->A1_EMAIL
          aNotify[5]    := SA1->A1_TEL
       EndIf    
   Else
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
               If SA1->(dbSeek(xFilial("SA1")+EEN->EEN_IMPORT+EEN->EEN_IMLOJA))
                  aNotify[n+3]    := SA1->A1_EMAIL
                  aNotify[n+4]      := SA1->A1_TEL
               EndIf       
               n := n+5
            Endif
         Endif
      Next
   Endif
   
   cEXP_CONTATO := M->cCONTATO

End Sequence

OBSERVACOES("END")

Return lRet

/*
Funcao      : ChkMarca
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function ChkMarca(oMark,cMarca)

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
            HELP(" ",1,"AVG0005046") //MsgStop("Já existem dois notify's selecionados !","Aviso")
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
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Cristiano A. Ferreira 
              04/05/2000 - Protheus
Obs.        :
*/
Static Function Observacoes(cAcao,cMarca)

Local xRet := nil

Local cPaisEt := Posicione("SA1",1,xFilial("SA1")+EEC->EEC_IMPORT+EEC->EEC_IMLOJA,"A1_PAIS")
Local nAreaOld, aOrd, aSemSx3
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
                       
      oMark := MsSelect():New("WkMsg","WKMARCA",,aCampos,lInverte,@cMarca,{18,3,125,312}) //{1,1,110,315})
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
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Cristiano A. Ferreira 
              04/05/2000 - Protheus
Obs.        :
*/
Static Function EditObs(cMarca)

Local nOpc, cMemo, oDlg

Local bOk     := {|| nOpc:=1, oDlg:End() }
Local bCancel := {|| oDlg:End() }

Local nRec

IF WkMsg->(!Eof())
   IF Empty(WkMsg->WKMARCA)
      nOpc:=0
      cMemo := WkMsg->WKTEXTO

      DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 7,0.5 TO 26,79.5 OF oMainWnd
      
         @ 05,05 SAY STR0020 PIXEL //"Tipo Mensagem"
         @ 05,45 GET WkMsg->EE4_TIPMEN WHEN .F. PIXEL
         @ 20,05 GET cMemo MEMO SIZE 300,105 OF oDlg PIXEL HSCROLL 

         DEFINE SBUTTON oBtnOk     FROM 130,246 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
         DEFINE SBUTTON oBtnCancel FROM 130,278 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg

      ACTIVATE MSDIALOG oDlg CENTERED // ON INIT EnchoiceBar(oDlg,bOk,bCancel)

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

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM11.PRW                                                 *
*------------------------------------------------------------------------------*
