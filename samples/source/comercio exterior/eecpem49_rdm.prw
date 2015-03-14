/*
Programa  : EECPEM49_RDM.
Objetivo  : Impressão da Proforma Invoice (Modelo 2).
Autor     : Jeferson Barros Jr.
Data/Hora : 20/12/2003 13:25.
Obs       : Desenvolvido Inicialmente para Henkel.
*/

#include "EECRDM.CH"
#INCLUDE "EECPEM49.CH"

#define ITENSPAG  15
#define ITENSPAG1 7

/*
Funcao      : EECPEM49.
Parametros  : Nenhum.
Retorno     : .t.
Objetivos   : Impressão da Proforma Invoice (Modelo 2).
Autor       : Jeferson Barros Jr.
Data/Hora   : 20/12/2003 13:25.
Revisao     :
Obs.        : Revisão - Inicialmente desenvolvido para a Henkel.
*/
*---------------------*
User Function EECPEM49
*---------------------*
Local lRet    := .t.
Local lIngles := UPPER(GetMv("MV_AVG0037",,"INGLES")) $ Upper(WorkId->EEA_IDIOMA)
Local nAlias  := Select()
Local aOrd    := SaveOrd({"EE8","SA2"})
Local nCod, aFields, cFile
Local nItens:=0, x

Private nTotBruto := 0
Private aMemos
Private cPict := "999,999,999.99"
Private cPictPreco  := "999,999,999.99"
Private cPictPeso   := "999,999,999.99"
Private cPictQtde   := "999,999,999.99"
Private cObs   := ""
Private aNotify[6]  ; aFill(aNotify,"")
Private cFileMen:=""
Private cMarca := GetMark(), lInverte := .f.
Private lNcm := .f., lPesoBru := .t., lSH := .T. ,lNaladi := .f.,lCopia := .t.;lNacional := .t.
Private M->cSEEKEXF  := ""
Private M->cSEEKLOJA := ""
Private aHeader := {}, aCAMPOS := ARRAY(0)
Private cMercadoria , cImport := "", cMsg:= ""
Private lPagAnt := .F.
Private cEmbalagem := GetEmbs()
Private cContainer := Space(60)

Begin Sequence

   cContainer := "Container: "+;
          If(EE7->EE7_QTD40H > 0, AllTrim(Str(EE7->EE7_QTD40H)) + "x'40 HC' ","")+ ;
          If(EE7->EE7_QTD20 > 0, AllTrim(Str(EE7->EE7_QTD20)) + "x'20' ","") + ;
          If(EE7->EE7_QTD40 > 0, AllTrim(Str(EE7->EE7_QTD40)) + "x'40'","")

   // *** Cria Arquivo de Trabalho ...
   nCod := AVSX3("EEN_IMPORT",3)+AVSX3("EEN_IMLOJA",3)

   aFields := {{"WKMARCA","C",02,0},;
               {"WKTIPO","C",01,0},;
               {"WKCODIGO","C",nCod,0},;
               {"WKDESCR","C",AVSX3("EEN_IMPODE",3),0}}
   
   //GFP 25/10/2010
   aFields := AddWkCpoUser(aFields,"EEN")
            
   cFile := E_CriaTrab(,aFields,"Work")
   IndRegua("Work",cFile+OrdBagExt(),"WKTIPO+WKCODIGO")
   
   EEM->(dbSetOrder(1)) // FILIAL+PREEMB+TIPO
   If lNCM
      EE8->(dbSeek(xFilial("EE8")+EE7->EE7_PEDIDO+EE8->EE8_POSIPI)) // FILIAL+PREEMB+NCM
   ElseIf lSH
      EE8->(dbSeek(xFilial("EE8"))) // FILIAL+PREEMB+NALADI SH
   Endif      
   EE8->(dbSeek(xFilial()+EE7->EE7_PEDIDO))

   cEXP_CARGO := SPACE(10)
   SA2->(dbSetOrder(1))
   IF !EMPTY(EE7->EE7_EXPORT) .AND. ;
      SA2->(DBSEEK(xFilial("SA2")+EE7->EE7_EXPORT+EE7->EE7_EXLOJA))      
      cExp_Cod     := EE7->EE7_EXPORT+EE7->EE7_EXLOJA
      cEXP_NOME    := Posicione("SA2",1,xFilial("SA2")+EE7->EE7_EXPORT+EE7->EE7_EXLOJA,"A2_NOME")
      cEXP_CONTATO := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",1)  //nome do contato seq 1
      cEXP_FONE    := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",4)  //fone do contato seq 1
      cEXP_FAX     := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",7)  //fax do contato seq 1
      cEXP_CARGO   := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",3)  //EMAIL
      M->cSEEKEXF  :=EE7->EE7_EXPORT
      M->cSEEKLOJA :=EE7->EE7_EXLOJA
   ELSE
      SA2->(DBSEEK(xFilial("SA2")+EE7->EE7_FORN+EE7->EE7_FOLOJA))
      cExp_Cod     := EE7->EE7_FORN+EE7->EE7_FOLOJA
      cEXP_NOME    := SA2->A2_NOME
      cEXP_CONTATO := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",1,EE7->EE7_RESPON)  //nome do contato seq 1
      cEXP_FONE    := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",4,EE7->EE7_RESPON)  //fone do contato seq 1
      cEXP_FAX     := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",7,EE7->EE7_RESPON)  //fax do contato seq 1
      cEXP_CARGO   := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",3,EE7->EE7_RESPON)  //E-MAIL      
      M->cSEEKEXF  :=EE7->EE7_FORN
      M->cSEEKLOJA :=EE7->EE7_FOLOJA
   ENDIF
   EE3->(DBSETORDER(2))
   IF EE3->(DBSEEK(xFILIAL("EE3")+EE7->EE7_RESPON))
     cEXP_CONTATO := EE7->EE7_RESPON
     cEXP_FONE    := EE3->EE3_FONE
     cEXP_FAX     := EE3->EE3_FAX
     cEXP_CARGO   := EE3->EE3_EMAIL
   ENDIF   
   
   cC2160  := EE7->EE7_IMPODE
   cC2260  := EE7->EE7_ENDIMP
   cC2360  := EE7->EE7_END2IM
   cC2460  := SPACE(60)
   cC2960  := SPACE(60)
   cC3060  := SPACE(60)
   
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
   HEADER_P->AVG_CHAVE :=EE7->EE7_PEDIDO //nr. do processo

   // Dados do Exportador/Fornecedor   
   HEADER_P->AVG_C01_60:=ALLTRIM(cEXP_NOME) // TITULO 1
   HEADER_P->AVG_C02_60:=ALLTRIM(SA2->A2_END)
   HEADER_P->AVG_C03_60:="CEP: "+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6))+" "+ALLTRIM(SA2->A2_MUN)+" "+ALLTRIM(SA2->A2_EST+" "+AllTrim(BuscaPais(SA2->A2_PAIS)))
   HEADER_P->AVG_C04_60:=ALLTRIM("TEL.: "+AllTrim(cEXP_FONE)+" FAX: "+AllTrim(cEXP_FAX))
   
   CCDATA := DTOC(EE7->EE7_DTPROC)
   CCDATA1:= SUBSTR(CCDATA,1,2)+"/"+SUBSTR(CCDATA,4,2)+"/"+SUBSTR(CCDATA,7,4)
   HEADER_P->AVG_C06_60 := CCDATA1
   HEADER_P->AVG_C02_20 := EE7->EE7_PEDIDO
   HEADER_P->AVG_C20_20 := EE7->EE7_REFIMP
   
   // TO
   HEADER_P->AVG_C07_60 := EE7->EE7_IMPODE
   HEADER_P->AVG_C08_60 := EE7->EE7_ENDIMP
   HEADER_P->AVG_C09_60 := EE7->EE7_END2IM
   
   // Consignee
   HEADER_P->AVG_C10_60 := Posicione("SA1",1,xFilial("SA1")+EE7->EE7_CONSIG+EE7->EE7_COLOJA,"A1_NOME")
   HEADER_P->AVG_C11_60 := EECMEND("SA1",1,EE7->EE7_CONSIG+EE7->EE7_COLOJA,.T.,58,1)
   HEADER_P->AVG_C12_60 := EECMEND("SA1",1,EE7->EE7_CONSIG+EE7->EE7_COLOJA,.T.,60,2)
   
   // Titulos ...
   HEADER_P->AVG_C01_10 := EE7->EE7_MOEDA
   HEADER_P->AVG_C02_10 := "KG"    
   
   // Pesos/Cubagem
   HEADER_P->AVG_C03_20 := AllTrim(Transf(EE7->EE7_PESLIQ,cPictPeso))  
   HEADER_P->AVG_C04_20 := AllTrim(Transf(EE7->EE7_PESBRU,cPictPeso))  
   cPictCub := AllTrim(StrTran(Upper(AVSX3("EE7_CUBAGE",6)),"@E",""))
   HEADER_P->AVG_C05_20 := Transf(EE7->EE7_CUBAGE,cPictCub) 

   HEADER_P->AVG_C13_60 := cContainer
   HEADER_P->AVG_C02100 := SubStr(cEmbalagem,1,100)
   
   HEADER_P->AVG_C15_20 := Transf(EE7->EE7_FRPREV,cPICT)  
   HEADER_P->AVG_C16_20 := Transf(EE7->EE7_SEGPRE,cPICT)  
   HEADER_P->AVG_C17_20 := Transf(EE7->EE7_FRPCOM+EE7->EE7_DESPIN,cPict)
   HEADER_P->AVG_C18_20 := Transf(EE7->EE7_TOTPED,cPICT)  
   HEADER_P->AVG_C19_20 := Transf(EE7->EE7_DESCON,cPICT)  // verificar se este campo existe na henkel

   HEADER_P->AVG_C03_10 := EE7->EE7_INCOTE//--INCOTERM
  
   //--------------------------------------------------------------||
   //Se produto for importado, abre uma janela Memo, para editar   ||
   //a Obs. Esta Observacao sera gravada no campo da descricao     ||
   //generica, podendo ser alterada na capa do embarque.           ||
   //--------------------------------------------------------------||
  
   cMercadoria := "BRASIL                        "
   aMemos := ({"EE7_GENERI","EE7_DSCGEN"})  
   If !lNacional
      While EE8->(!Eof() .And. EE8_FILIAL == xFilial("EE8")) .And.;
         EE8->EE8_PEDIDO == EE7->EE7_PEDIDO
         nItens := nItens +1
         EE8->(DbSkip())
      End
      
      cDescrGen := MSMM(EE7->EE7_DSCGEN,AVSX3("EE7_GENERI",3))
      MSMM(EE7->EE7_DSCGEN,,,,EXCMEMO)//--LIMPA CAMPO MEMO
      IF AT(GetMv("MV_AVG0037",,"INGLES"), EE7->EE7_IDIOMA) >0  
         If AT("ORIGIN",cDescrGen)=0
	        If empty(MemoLine(cDescrGen,90,1))
	           cDescrGen := cDescrGen + ENTER +STR0001 //"ORIGIN: BRAZIL. EXCEPT XXX, ORIGEM: XXXX."
	        ElseIf empty(MemoLine(cDescrGen,90,2))
	           cDescrGen := cDescrGen + ENTER +STR0001 //"ORIGIN: BRAZIL. EXCEPT XXX, ORIGEM: XXXX."
	        ElseIf empty(MemoLine(cDescrGen,90,3))
	           cDescrGen := cDescrGen + ENTER +STR0001 //"ORIGIN: BRAZIL. EXCEPT XXX, ORIGEM: XXXX."
	        ElseIf empty(MemoLine(cDescrGen,90,4))
	           cDescrGen := cDescrGen + ENTER +STR0001 //"ORIGIN: BRAZIL. EXCEPT XXX, ORIGEM: XXXX."
	        ElseIf empty(MemoLine(cDescrGen,90,5))
	           cDescrGen := cDescrGen + ENTER +STR0001 //"ORIGIN: BRAZIL. EXCEPT XXX, ORIGEM: XXXX."
	        ElseIf empty(MemoLine(cDescrGen,90,6))
	           cDescrGen := cDescrGen + ENTER +STR0001 //"ORIGIN: BRAZIL. EXCEPT XXX, ORIGEM: XXXX."
	        EndIf
	     EndIf
	  ElseIf AT("ESPANHOL", EE7->EE7_IDIOMA) >0
	     If AT("ORIGEN",cDescrGen)=0
	        If nItens == 1
	           If empty(MemoLine(cDescrGen,90,1))
	              cDescrGen := cDescrGen + ENTER +STR0002 //"ORIGEN: BRASIL. EXCEPTO EL PRODUCTO XXXX , ORIGEM XXX  ."
	           ElseIf empty(MemoLine(cDescrGen,90,2))
	              cDescrGen := cDescrGen + ENTER +STR0002 //"ORIGEN: BRASIL. EXCEPTO EL PRODUCTO XXXX , ORIGEM XXX  ."
	           ElseIf empty(MemoLine(cDescrGen,90,3))
	              cDescrGen := cDescrGen + ENTER +STR0002 //"ORIGEN: BRASIL. EXCEPTO EL PRODUCTO XXXX , ORIGEM XXX  ."
	           ElseIf empty(MemoLine(cDescrGen,90,4))
	              cDescrGen := cDescrGen + ENTER +STR0002 //"ORIGEN: BRASIL. EXCEPTO EL PRODUCTO XXXX , ORIGEM XXX  ."
	           ElseIf empty(MemoLine(cDescrGen,90,5))
	              cDescrGen := cDescrGen + ENTER +STR0002 //"ORIGEN: BRASIL. EXCEPTO EL PRODUCTO XXXX , ORIGEM XXX  ."
	           ElseIf empty(MemoLine(cDescrGen,90,6))
	              cDescrGen := cDescrGen + ENTER +STR0002 //"ORIGEN: BRASIL. EXCEPTO EL PRODUCTO XXXX , ORIGEM XXX  ."
	           EndIf
	        Else
	           If empty(MemoLine(cDescrGen,90,1))
	              cDescrGen := cDescrGen + ENTER +STR0003 //"ORIGEN: BRASIL. EXCEPTO LOS PRODUCTOS XXXX , ORIGEM XXX  ."
	           ElseIf empty(MemoLine(cDescrGen,90,2))
	              cDescrGen := cDescrGen + ENTER +STR0003 //"ORIGEN: BRASIL. EXCEPTO LOS PRODUCTOS XXXX , ORIGEM XXX  ."
	           ElseIf empty(MemoLine(cDescrGen,90,3))
	              cDescrGen := cDescrGen + ENTER +STR0003 //"ORIGEN: BRASIL. EXCEPTO LOS PRODUCTOS XXXX , ORIGEM XXX  ."
	           ElseIf empty(MemoLine(cDescrGen,90,4))
	              cDescrGen := cDescrGen + ENTER +STR0003 //"ORIGEN: BRASIL. EXCEPTO LOS PRODUCTOS XXXX , ORIGEM XXX  ."
	           ElseIf empty(MemoLine(cDescrGen,90,5))
	              cDescrGen := cDescrGen + ENTER +STR0003 //"ORIGEN: BRASIL. EXCEPTO LOS PRODUCTOS XXXX , ORIGEM XXX  ."
	           ElseIf empty(MemoLine(cDescrGen,90,6))
	              cDescrGen := cDescrGen + ENTER +STR0003 //"ORIGEN: BRASIL. EXCEPTO LOS PRODUCTOS XXXX , ORIGEM XXX  ."
	           EndIf
	        EndIf
	     EndIf  
	  EndIf 	  
      Nacional()
      MSMM(,TAMSX3("EE7_GENERI")[1],,cMsg,INCMEMO,,,"EE7","EE7_DSCGEN")
   EndIf

   // pais de origem   
   If lNACIONAL
      HEADER_P->AVG_C01_30 := alltrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR"))    
   Else
      HEADER_P->AVG_C01_30 := cMercadoria
   Endif
         
   // VIA
   SYQ->(dbSetOrder(1))
   SYQ->(dbSeek(xFilial()+EE7->EE7_VIA))  
   HEADER_P->AVG_C02_30 := IF(Left(SYQ->YQ_COD_DI,1) == "4",IF(lIngles,"BY AIR","AEREO"),SYQ->YQ_DESCR) // VIA      
   IF Left(SYQ->YQ_COD_DI,1) == "7" // Rodoviario
      HEADER_P->AVG_C14_60 := BuscaEmpresa(EE7->EE7_PEDIDO,OC_PE,CD_TRA)
   EndIf

   IF Left(SYQ->YQ_COD_DI,1) == "1" // MARITIMO
      HEADER_P->AVG_C05_10:="FOB"
   Else 
      HEADER_P->AVG_C05_10:="FCA"
   Endif

   If !(EE7->EE7_INCOTE $ "CIF/CFR/CPT/CIP")
      SYR->(dbSeek(xFilial()+EE7->EE7_VIA+EE7->ee7_ORIGEM+EE7->EE7_DEST+EE7->EE7_TIPTRA))
      HEADER_P->AVG_C03_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))
   Else
      SYR->(dbSeek(xFilial()+EE7->EE7_VIA+EE7->EE7_ORIGEM+EE7->EE7_DEST+EE7->EE7_TIPTRA))
      HEADER_P->AVG_C03_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR"))
   EndIf

   SYR->(dbSeek(xFilial()+EE7->EE7_VIA+EE7->EE7_ORIGEM+EE7->EE7_DEST+EE7->EE7_TIPTRA))
   IF Posicione("SYJ",1,xFilial("SYJ")+EE7->EE7_INCOTE,"YJ_CLFRETE") $ cSim
      HEADER_P->AVG_C13_20 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // Porto de Destino
   Else
      HEADER_P->AVG_C13_20 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))  // Porto de Origem
   Endif
      
   // Place of Discharge
   HEADER_P->AVG_C04_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR"))
   
   // Port of Loading
   HEADER_P->AVG_C10_20 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))
   HEADER_P->AVG_C10_20 := ALLTRIM(SY9->Y9_CIDADE)      
 
   // MARKS
   cMemo := MSMM(EE7->EE7_CODMAR,AVSX3("EE7_MARCAC",AV_TAMANHO))
   //cDescrGen :=MSMM(EE7->EE7_DSCGEN,AVSX3("EE7_GENERI",3)) 
   cDescrGen :=MSMM(EE7->EE7_CODMEM,AVSX3("EE7_OBS",3)) 
   HEADER_P->AVG_C01150 := MemoLine(cDescrGen,90,1)  
   HEADER_P->AVG_C02150 := MemoLine(cDescrGen,90,2)
   HEADER_P->AVG_C03150 := MemoLine(cDescrGen,90,3)
   HEADER_P->AVG_C04150 := MemoLine(cDescrGen,90,4)
   HEADER_P->AVG_C05150 := MemoLine(cDescrGen,90,5)
   HEADER_P->AVG_C06150 := MemoLine(cDescrGen,90,6)
    
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
   HEADER_P->AVG_C01100 := SY6Descricao(EE7->EE7_CONDPA+Str(EE7->EE7_DIASPA,AVSX3("EE7_DIASPA",3),AVSX3("EE7_DIASPA",4)),EE7->EE7_IDIOMA) // Terms of Payment
   
   // I/L
   HEADER_P->AVG_C25_60 := EE7->EE7_LICIMP
   // L/C
   HEADER_P->AVG_C04_10 := EE7->EE7_LC_NUM
   
   // RODAPE
   HEADER_P->AVG_C26_60 := cEXP_NOME   
   HEADER_P->AVG_C27_60 := cEXP_CONTATO
   HEADER_P->AVG_C28_60 := cEXP_CARGO

   //Banco recebedor de pagamento
   DbSelectArea("EEJ")

   IF ( !EMPTY(BuscaInst(EE7->EE7_PEDIDO,OC_PE,BC_DBR)))
      HEADER_P->AVG_C05_30 := AllTrim(EEJ->EEJ_NOME)
      HEADER_P->AVG_C06_30 := ALLTRIM(EEJ->EEJ_NUMCON)

      If !Empty(EEJ->EEJ_FAVORE)    
         HEADER_P->AVG_C14_60 := STR0004+AllTrim(EEJ->EEJ_NUMCON) //"ACCOUT:  "
         HEADER_P->AVG_C21_60 := STR0005+ALLTRIM(cEXP_NOME) //"BENEFICIARY:  "

         HEADER_P->AVG_C05_60 := Alltrim(EEJ->EEJ_FAVORE)
         IF AT(GetMv("MV_AVG0037",,"INGLES"), EE7->EE7_IDIOMA) >0
            HEADER_P->AVG_C14_60 := STR0005+ALLTRIM(cEXP_NOME) //"BENEFICIARY:  "

            If !Empty(EEJ->EEJ_BENEDE)
               HEADER_P->AVG_C21_60 := STR0004+ALLTRIM(EEJ->EEJ_BENEDE)  //"ACCOUT:  "
               HEADER_P->AVG_C22_60 := STR0006+Alltrim(EE7->EE7_PEDIDO) //"REFERENCE: NR. INVOICE:  "
            Else
               HEADER_P->AVG_C21_60 := STR0006+Alltrim(EE7->EE7_PEDIDO) //"REFERENCE: NR. INVOICE:  "
            EndIf

         ElseIf AT("ESPANHOL", EE7->EE7_IDIOMA) >0
            HEADER_P->AVG_C14_60 := STR0007+ALLTRIM(cEXP_NOME) //"BENEFICIARIO:  "

            If !Empty(EEJ->EEJ_BENEDE)
               HEADER_P->AVG_C21_60 := STR0008+ALLTRIM(EEJ->EEJ_BENEDE) //"CUENTA:  "
               HEADER_P->AVG_C22_60 := STR0009+Alltrim(EE7->EE7_PEDIDO) //"REFERENCIA: NR. INVOICE:  "
            Else
               HEADER_P->AVG_C21_60 := STR0006+Alltrim(EE7->EE7_PEDIDO) //"REFERENCE: NR. INVOICE:  "
           EndIf
         EndIf

      ElseIf !Empty(EEJ->EEJ_BENEDE)

         IF AT(GetMv("MV_AVG0037",,"INGLES"), EE7->EE7_IDIOMA) > 0

            HEADER_P->AVG_C14_60 := STR0004+ALLTRIM(EEJ->EEJ_NUMCON)  //"ACCOUT:  "
            HEADER_P->AVG_C21_60 := STR0005+ALLTRIM(cEXP_NOME) //"BENEFICIARY:  "
            If !Empty(EEJ->EEJ_BENEDE)
               HEADER_P->AVG_C22_60 := STR0004+ALLTRIM(EEJ->EEJ_BENEDE) //"ACCOUT:  "
               HEADER_P->AVG_C27_60 := STR0006+Alltrim(EE7->EE7_PEDIDO) //"REFERENCE: NR. INVOICE:  "
            Else
               HEADER_P->AVG_C22_60 := STR0006+Alltrim(EE7->EE7_PEDIDO) //"REFERENCE: NR. INVOICE:  "
            EndIf

         ElseIf AT("ESPANHOL", EE7->EE7_PEDIDO) > 0

            HEADER_P->AVG_C14_60 := STR0008+ALLTRIM(EEJ->EEJ_NUMCON) //"CUENTA:  "
            HEADER_P->AVG_C21_60 := STR0007+ALLTRIM(cEXP_NOME) //"BENEFICIARIO:  "

            If !Empty(EEJ->EEJ_BENEDE)
               HEADER_P->AVG_C22_60 := STR0008+ALLTRIM(EEJ->EEJ_BENEDE) //"CUENTA:  "
               HEADER_P->AVG_C27_60 := STR0009+Alltrim(EE7->EE7_PEDIDO) //"REFERENCIA: NR. INVOICE:  "
            Else          
               HEADER_P->AVG_C22_60 := STR0009+Alltrim(EE7->EE7_PEDIDO) //"REFERENCIA: NR. INVOICE:  "
            EndIf

         EndIf
      EndIf
   EndIf

   //ER - 30/08/05. Verifica se existe parecela de pagamento antecipado no pedido.
   SY6->(dbSetOrder(1))
   SY6->(dbSeek(xFilial()+EE7->EE7_CONDPA))

   For x:=1 to 10
      nDias := SY6->&("Y6_DIAS_" + StrZero(x,2))
      If nDias < 0
         lPagAnt := .T.
         Exit   
      EndIF
   Next

   GravaItens()
         
   HEADER_P->(dbUnlock())
      
   cMemo := MSMM(EE7->EE7_CODMAR,AVSX3("EE7_MARCAC",AV_TAMANHO))
   RECLOCK("DETAIL_P",.F.)
   RECLOCK("HEADER_P",.F.)
   DETAIL_P->AVG_C01100 := ALLTRIM(MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),1))
   DETAIL_P->AVG_C02100 := ALLTRIM(MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),2))
   DETAIL_P->AVG_C03100 := ALLTRIM(MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),3))
   DETAIL_P->AVG_C01120 := ALLTRIM(MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),4))
   DETAIL_P->AVG_C01150 := ALLTRIM(MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),5))
   HEADER_P->AVG_C31_60 := ALLTRIM(MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),6))
   HEADER_P->AVG_C32_60 := ALLTRIM(MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),7))
   HEADER_P->(dbUnlock())
   DETAIL_P->(dbUnlock())

   EECPEM11FLAG()

End Sequence

IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cFileMen+OrdBagExt()))
Endif
Work->(E_EraseArq(cFile+OrdBagExt()))
RestOrd(aOrd)
EE8->(DBSETORDER(1))
EE3->(DBSETORDER(1))
Select(nAlias)

Return lRet

/*
Funcao      : GravaItens
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     : Jeferson Barros Jr. - 20/12/03 - 13:34.
Obs.        :
*/
*-------------------------*
Static Function GravaItens
*-------------------------*
Local nTotQtde := 0
Local nTotal   := 0
Local bCond := {|| .t. }
Local cNcm := "", cSH := ""
Local nOutros  := 0, nDesconto := 0, i:=0,gi_W:=0

If lNcm
   EE8->(dbSeek(xFilial()+EE7->EE7_PEDIDO))
   bCond := IF(lNcm, {|| EE8->EE8_POSIPI == cNcm },{|| .t. })
Elseif lSH
   EE8->(dbSeek(xFilial()+EE7->EE7_PEDIDO))
   bCond := If(lSH, {|| EE8->EE8_NALSH  == cSH  },{|| .t. })
Endif

While EE8->(!Eof() .And. EE8_FILIAL == xFilial("EE8")) .And.;
      EE8->EE8_PEDIDO == EE7->EE7_PEDIDO
   If lNCM
      cNcm := EE8->EE8_POSIPI 
      AppendDet()
      DETAIL_P->AVG_C01_60 := Transf(EE8->EE8_POSIPI,AVSX3("EE8_POSIPI",6))
      UnlockDet()                                 
   ElseIf lSH
      cSH  := EE8->EE8_NALSH  
      AppendDet()
      DETAIL_P->AVG_C01_60 := Transf(EE8->EE8_NALSH,AVSX3("EE8_NALSH",6))
      UnlockDet()
   Endif   
   UnlockDet()
   While EE8->(!Eof() .And. EE8_FILIAL == xFilial("EE8")) .And.;
         EE8->EE8_PEDIDO == EE7->EE7_PEDIDO .AND. Eval(bCond)    
      
       AppendDet()
       DETAIL_P->AVG_C01_20 := Transf(EE8->EE8_SLDINI,cPictQtde)
       DETAIL_P->AVG_C05_60 := Transf(EE8->EE8_COD_I,AVSX3("EE8_COD_I",6))
       DETAIL_P->AVG_C02_20 := Transf(EE8->EE8_COD_I,AVSX3("EE8_COD_I",6))
       DETAIL_P->AVG_C02_20 := SUBSTR(DETAIL_P->AVG_C02_20,4,15)
       DETAIL_P->AVG_C03_20 := UPPER(Alltrim(EE8->EE8_REFCLI))

       DETAIL_P->AVG_C02_10 := LOWER(AllTrim(EE8->EE8_UNIDAD))
       
       cMemo := MSMM(EE8->EE8_DESC,AVSX3("EE8_VM_DES",3))
       For I:=1 to len(Cmemo)
           If substr(Cmemo,i,1)=="®"
              cMEMO:=SUBSTR(cMEMO,1,I-1)+CHR(169)+SUBSTR(cMEMO,I+1,LEN(CMEMO))
           Endif
       Next
       DETAIL_P->AVG_C01_60 := MemoLine(cMemo,AVSX3("EE8_VM_DES",3),1)
       DETAIL_P->AVG_C02_60 := AllTrim(Transf(EE8->EE8_PSLQTO,cPictPeso))            
       IF lPesoBru
          DETAIL_P->AVG_C03_60 := AllTrim(Transf(EE8->EE8_PSBRTO,cPictPeso))
          nTotBruto := nTotBruto+EE8->EE8_PSBRTO
       ENDIF
      
       HEADER_P->AVG_C06_10 := If(lCopia,"ORIGINAL", "COPIA")
       DETAIL_P->AVG_C06_20 := AllTrim(Transf(EE8->EE8_PRECO,cPictPreco))
       DETAIL_P->AVG_C07_20 := AllTrim(Transf(EE8->EE8_PRCINC,cPict))
   
       nTotQtde := nTotQtde+EE8->EE8_SLDINI
       nTotal   := nTotal  +EE8->EE8_PRCINC      
       
       //ER - 30/08/05. Caso o pedido possua parcela de pagamento antecipado, grava a Previsão de Embarque.
       IF lPagAnt
          IF AT(GetMv("MV_AVG0037",,"INGLES"), EE7->EE7_IDIOMA) > 0
             DETAIL_P->AVG_C04_60 := "Shipping Forecast: " + DTOC(EE8->EE8_DTPREM)
          ElseIf AT("ESPANHOL", EE7->EE7_IDIOMA) > 0
             DETAIL_P->AVG_C04_60 := "Previsión de Embarque: " + DTOC(EE8->EE8_DTPREM)
          Else
             DETAIL_P->AVG_C04_60 := "Previsão de Embarque: " + DTOC(EE8->EE8_DTPREM)
          EndIF
       EndIF
       
       For i := 2 To MlCount(cMemo,AVSX3("EE8_VM_DES",3))
          IF !EMPTY(MemoLine(cMemo,AVSX3("EE8_VM_DES",3),i))
             UnlockDet()
             AppendDet()
             DETAIL_P->AVG_C01_60 := MemoLine(cMemo,AVSX3("EE8_VM_DES",3),i)
          ENDIF
       Next

       UnLockDet()
       EE8->(dbSkip())         
   Enddo           
Enddo                      

AppendDet()

IF AT(GetMv("MV_AVG0037",,"INGLES"), EE7->EE7_IDIOMA) >0  
   DETAIL_P->AVG_C02_60 := Transf(EE7->EE7_PESLIQ,cPictPeso)
   DETAIL_P->AVG_C03_60 := Transf(EE7->EE7_PESBRU,cPictPeso) 
ELSEIF AT("ESPANHOL",EE7->EE7_IDIOMA)>0
   DETAIL_P->AVG_C02_60 := Transf(EE7->EE7_PESLIQ,cPictPeso)
   DETAIL_P->AVG_C03_60 := Transf(nTotBruto,cPictPeso)
ELSE
   pTAM:=18
   MSGINFO(STR0010)  //"Idioma nao encontrado para a descricao do total de peso !"
   DETAIL_P->AVG_C02_60 := Transf(EE7->EE7_PESLIQ,cPictPeso)
   DETAIL_P->AVG_C03_60 := Transf(EE7->EE7_PESBRU,cPictPeso) 
ENDIF

nOutros   := EE7->EE7_FRPCOM+EE7->EE7_DESPIN+nTotal
nDesconto := nOutros - EE7->EE7_DESCON
DETAIL_P->AVG_C07_20 := Transf(nTotal,cPict)
UnLockDet()

IF Select("Work_Men") > 0
   Work_Men->(dbGoTop())
   
   While !Work_Men->(Eof()) .And. Work_Men->WKORDEM < "zzzzz"
      gi_nTotLin:=MLCOUNT(Work_Men->WKOBS,40) 
      For gi_W := 1 To gi_nTotLin
         SysRefresh()
         If !Empty(MEMOLINE(Work_Men->WKOBS,40,gi_W))
            AppendDet()                                              
            DETAIL_P->AVG_C01_60 := MemoLine(Work_Men->WKOBS,40,gi_W)        
            UnLockDet()
         EndIf
      Next
      Work_Men->(dbSkip())
   Enddo
Endif

Return NIL

/*
Funcao      : AppendDet
Parametros  : 
Retorno     : 
Objetivos   : Adiciona registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira 
Data/Hora   : 05/05/2000
Revisao     : Jeferson Barros Jr. 20/12/03 - 13:36.
Obs.        :
*/
*-------------------------*
Static Function AppendDet()
*-------------------------*
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
Revisao     : Jeferson Barros Jr - 20/12/03 - 13:36.
Obs.        :
*/
*-------------------------*
Static Function UnlockDet()
*-------------------------*
Begin Sequence
   DETAIL_P->(dbUnlock())
   
   DETAIL_H->(dbAppend())
   AvReplace("DETAIL_P","DETAIL_H")
   DETAIL_H->(dbUnlock())
End Sequence

Return NIL

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira 
Data/Hora   : 
Revisao     : Jeferson Barros Jr. 20/12/03 - 13:15
Obs.        :
*/
*-----------------------*
Static Function TelaGets
*-----------------------*
Local lRet := .f.
Local nOpc := 0
Local oDlg

Local bOk     := {||nOpc:=1,oDlg:End()}
Local bCancel := {||nOpc:=0,oDlg:End()}

Local bSet  := {|x,o| lNcm     := x, o:Refresh(), lNcm     }    
Local bSetC := {|x,o| lCopia   := x, o:Refresh(), lCopia   }
Local bSetN := {|x,o| lNacional:= x, o:Refresh(), lNacional}
Local bSetSH:= {|x,o| lSH      := x, o:Refresh(), lSH      } 
*Local bSetNa:= {|x,o| lNaladi  := x, o:Refresh(), lNaladi  } 
Local bSetP := {|x,o| lPesoBru := x, o:Refresh(), lPesoBru }

Local aCampos := {{"WKMARCA",," "},;
                  {"WKCODIGO",,STR0011},; //"Código"
                  {"WKDESCR",,STR0012}} //"Descrição"

Local oFld, oFldDoc, oBtnOk, oBtnCancel
Local oYes, oNo, oYesP, oNoP, oMark, oMark2, oMark3, oYesC, oNoC, oYesN, oNoN, ;
      oYesSH, oNoSH
      
      
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


   EEN->(dbSeek(xFilial()+EE7->EE7_PEDIDO+OC_PE))
   While EEN->(!Eof() .And. EEN_FILIAL == xFilial("EEN")) .And.;
       EEN->EEN_PROCES+EEN->EEN_OCORRE == EE7->EE7_PEDIDO+OC_PE

      Work->(dbAppend())
      Work->WKTIPO   := "N"
      Work->WKCODIGO := EEN->EEN_IMPORT+EEN->EEN_IMLOJA
      Work->WKDESCR  := EEN->EEN_IMPODE
       
      EEN->(dbSkip())
   Enddo   

   Work->(dbGoTop())
   
   DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 9,0 TO 32,80 OF oMainWnd
   
     oFld := TFolder():New(1,1,{STR0013,STR0014,STR0015,STR0016},{"IPC","IBC","OBS","MEN"},oDlg,,,,.T.,.F.,315,163) //"Documentos Para"###"Notify's"###"Observações"###"Mensagem"
     
     aEval(oFld:aControls,{|x| x:SetFont(oDlg:oFont) })
          
     // Documentos Para
     oFldDoc := oFld:aDialogs[1]     
     
     @ 01,001 SAY STR0017 SIZE 232,010  PIXEL OF oFldDoc       //"Original"
     oYesC := TCheckBox():New(01,22,STR0018,  {|x| If(PCount()==0, lCopia,    Eval(bSetC,  x,oNoC ))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
     oNoC  := TCheckBox():New(01,45,STR0019,  {|x| If(PCount()==0,!lCopia,    Eval(bSetC, !x,oYesC))},oFldDoc,21,10,,,,,,,,.T.)      //"Não"
  
     @ 01,080 SAY STR0020 SIZE 232,010  PIXEL OF oFldDoc       //"Nacional"
     oYesN := TCheckBox():New(01,101,STR0018,  {|x| If(PCount()==0, lNacional,Eval(bSetN,  x,oNoN ))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
     oNoN  := TCheckBox():New(01,121,STR0019,  {|x| If(PCount()==0,!lNacional,Eval(bSetN, !x,oYesN))},oFldDoc,21,10,,,,,,,,.T.)       //"Não"
     
     @ 10,001 SAY "N.C.M." SIZE 232,010    PIXEL OF oFldDoc      
     oYes := TCheckBox():New(10,22,STR0018,  {|x| If(PCount()==0,  lNcm,     Eval(bSet,   x,oNo ))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
     oNo  := TCheckBox():New(10,45,STR0019,  {|x| If(PCount()==0, !lNcm,     Eval(bSet,  !x,oYes))},oFldDoc,21,10,,,,,,,,.T.) //"Não"
     
     @ 10,160 SAY "S.H." SIZE 232,010      PIXEL OF oFldDoc      
     oYesSH  := TCheckBox():New(10,181,STR0018, {|x| If(PCount()==0,  lSH    ,  Eval(bSetSH, x,oNoSH ))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
     oNoSH   := TCheckBox():New(10,201,STR0019, {|x| If(PCount()==0, !lSH    ,  Eval(bSetSH,!x,oYesSH))},oFldDoc,21,10,,,,,,,,.T.) //"Não"
     
     @ 10,240 SAY STR0021 SIZE 232,010 PIXEL OF oFldDoc      //"Peso Bruto"
     oYesP := TCheckBox():New(10,271,STR0018, {|x| If(PCount()==0, lPesoBru,Eval(bSetP,   x,oNoP ))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
     oNoP  := TCheckBox():New(10,291,STR0019, {|x| If(PCount()==0,!lPesoBru,Eval(bSetP,  !x,oYesP))},oFldDoc,21,10,,,,,,,,.T.) //"Não"

     M->cCONTATO   := EE7->EE7_RESPON  

     @ 20,001 SAY STR0022 SIZE 232,10 PIXEL OF oFldDoc //"Assinante"
     @ 20,043 GET M->cCONTATO SIZE 120,08 PIXEL OF oFldDoc
        
     @ 30,001 SAY STR0023 SIZE 232,10 PIXEL OF oFldDoc //"Cargo"
     @ 30,043 GET M->cEXP_CARGO SIZE 120,08 PIXEL OF oFldDoc
     
     @ 44,001 SAY STR0024 SIZE 232,10 PIXEL OF oFldDoc //"Doct.Para"
     
     @ 44,043 GET cC2160 SIZE 120,08 PIXEL OF oFldDoc

     @ 54,043 GET cC2260 SIZE 120,08 PIXEL OF oFldDoc
     @ 64,043 GET cC2360 SIZE 120,08 PIXEL OF oFldDoc
     @ 74,043 GET cC2460 SIZE 120,08 PIXEL OF oFldDoc
     @ 84,043 GET cC2960 SIZE 120,08 PIXEL OF oFldDoc
     @ 94,043 GET cC3060 SIZE 120,08 PIXEL OF oFldDoc

     @ 104,001 SAY "Embalagem" SIZE 232,10 PIXEL OF oFldDoc //"Doct.Para"
     @ 104,043 GET cContainer  SIZE 240,08 PIXEL OF oFldDoc
     @ 114,043 GET cEmbalagem  SIZE 240,08 PIXEL OF oFldDoc
          
     //GFP 25/10/2010
     aCampos := AddCpoUser(aCampos,"EEN","2")
     
     // Folder Notify's ...
     oMark := MsSelect():New("Work","WKMARCA",,aCampos,@lInverte,@cMarca,{18,3,125,312})
     oMark:bAval := {|| ChkMarca(oMark,cMarca) }
     @ 14,043 GET xx OF oFld:aDialogs[2]     
     AddColMark(oMark,"WKMARCA")
     
     // Folder Mensagens ...
     @ 14,043 GET xx OF oFld:aDialogs[3]
     oMark3 := EECMensagem(EE7->EE7_IDIOMA,"3",{18,3,125,312},,,,oDlg)

     // Folder Observações ...
     oMark2 := Observacoes("New",cMarca)
     @ 14,043 GET xx OF oFld:aDialogs[4]
     AddColMark(oMark2,"WKMARCA")

     Eval(bHideAll)
     
     oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),;
                                           IF(nOption <> 1,Eval(bShow,nOption),) }

     DEFINE SBUTTON oBtnOk     FROM 145,258 TYPE 1 ACTION Eval(bOk)     ENABLE OF oDlg
     DEFINE SBUTTON oBtnCancel FROM 145,288 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg

   ACTIVATE MSDIALOG oDlg CENTERED
   
   IF nOpc == 0
      Break
   Endif
   
   lRet := .t.
   SA1->(dbSetOrder(1))
   n := 1
   For i:=1 To 2
      IF !Empty(aMarcados[i])
         nTamLoj := AVSX3("EEN_IMLOJA",3)
         cKey    := Subst(aMarcados[i],2)
         cLoja   := Right(cKey,nTamLoj) 
         cImport := Subst(cKey,1,Len(cKey)-nTamLoj)
         
         IF EEN->(dbSeek(xFilial()+AvKey(EE7->EE7_PEDIDO,"EEN_PROCES")+OC_PE+AvKey(cImport,"EEN_IMPORT")+AvKey(cLoja,"EEN_IMLOJA")))
            aNotify[n]   := EEN->EEN_IMPODE
            aNotify[n+1] := EEN->EEN_ENDIMP
            aNotify[n+2] := EEN->EEN_END2IM
            If SA1->(dbSeek(xFilial("SA1")+EEN->EEN_IMPORT+EEN->EEN_IMLOJA))
               aNotify[n+3]      := SA1->A1_EMAIL
               aNotify[n+4]      := SA1->A1_TEL
            EndIf       
            n := n+5
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
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira 
Data/Hora   : 
Revisao     : Jeferson Barros Jr. - 20/12/03 - 13:37.
Obs.        :
*/           
*------------------------------------*
Static Function ChkMarca(oMark,cMarca)
*------------------------------------*
Local n

Begin Sequence
   IF ! Work->(Eof() .Or. Bof())
      IF !Empty(Work->WKMARCA) 
         n := aScan(aMarcados,Work->WKTIPO+Work->WKCODIGO)
         IF n > 0
            aMarcados[n] := ""
         Endif
         
         Work->WKMARCA := Space(2)
      Else
         IF !Empty(aMarcados[1]) .And. !Empty(aMarcados[2])
            MsgStop(STR0025,STR0026) //"Já existem dois notify's selecionados !"###"Aviso"
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
Revisao     : Jeferson Barros Jr - 20/12/03 - 13:38.
Obs.        :
*/
*---------------------------------------*
Static Function Observacoes(cAcao,cMarca)
*---------------------------------------*
Local xRet := nil

Local cPaisEt := Posicione("SA1",1,xFilial("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA,"A1_PAIS")
Local aOrd, aSemSx3
Local cTipMen, cIdioma, cTexto, i

Local oMark
Local lInverte := .F.

Static aOld
Private aHeader := {}, aCAMPOS := array(EE4->(fcount()))
Begin Sequence
   cAcao := Upper(AllTrim(cAcao))

   IF cAcao == "NEW"
      aOrd := SaveOrd({"EE4","EE1"})
      
      EE1->(dbSetOrder(1))
      EE4->(dbSetOrder(1))
      
      
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
      WkMsg->(dbGoTop())
      Do While !WkMsg->(Eof())
         If !Empty(WkMsg->WKMARCA)
            Work_Men->(dbAppend())
            Work_Men->WKOBS  := WkMsg->WKTEXTO
            Work_Men->WKOBS1 := WkMsg->WKTEXTO
         EndIF
         WkMsg->(DbSkip())
      EndDo
      
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
Revisao     : Jeferson Barros Jr - 20/12/03 - 13:38.
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
      
         @ 05,05 SAY "Tipo Mensagem" PIXEL
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
Funcao      : Nacional
Parametros  : 
Retorno     : 
Objetivos   : Editar Obs. para produto importado
Autor       : Sandra Yuriko Inoue
Data/Hora   : 15/05/2001 - 12:30
Revisao     : 20/12/03 - 13:39.
*/
*-----------------------*
Static Function Nacional
*-----------------------*
Local oDlg
Local lRec:=.f.,nOpc:=0,bOk:={||nOpc:=1,oDlg:End()}
Local bCancel := {||oDlg:End()}

Private cImport := cDescrGen

BEGIN SEQUENCE
   DEFINE MSDIALOG oDlg TITLE "Produto Importado" FROM 7,0.5 TO 26,79.5 OF oMainWnd

      @ 16,05 SAY "Origem da Mercadoria" PIXEL
      @ 16,65 GET cMercadoria SIZE 105,08 of oDlg Pixel
      @ 30,05 GET cImport MEMO SIZE 300,105 OF oDlg PIXEL HSCROLL 

   ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,bOk,bCancel)) CENTERED

   IF nOpc == 1
      cMsg := cMsg + cImport
      lRet := .t.
   Endif
   
END SEQUENCE

Return lRec

/*
Funcao      : EECPEM11FLAG
Parametros  : Nenhum
Retorno     : .T.
Objetivos   : Gravar campo flag 
Autor       : Jeferson Barros Jr.
Data/Hora   : 06/08/2001 - 16:30
Revisao     : Jeferson Barros Jr. 20/12/03 - 13:40 
Obs.        : 
*/
*-----------------------------
Static Function EECPEM11FLAG()
*-----------------------------
Local lRet :=.T., nContItem:=0,;
      nPag:=0, nZ:=0,;
      nPos:=21 // ** Valor p/ a 3 pag. (Tratamento para o Detail B no Crystal)

Begin Sequence
   // ** Conta qtos itens gravados...
   DETAIL_P->(DbGoTop())
   Do While DETAIL_P->(!Eof())      
      // **Gravar o campo com o nro 2...
      RECLOCK("DETAIL_P",.F.)                              
      DETAIL_P->AVG_N01_04 := 2 
      DETAIL_P->(dbUnlock())            
      nContItem:= nContItem+1  
      DETAIL_P->(DbSkip()) 
   EndDo

   nContItem:= nContItem - ITENSPAG1 // ** Não conta os itens que irão na primeira pagina...

   nPag:=Int(nContItem/ITENSPAG)+1   // ** Calcula o nro de paginas ...   
  
   nContItem:= nContItem + ITENSPAG1 
   
   DETAIL_P->(DbGoTop())   
 
   // ** Grava os registros flag...
   For nZ:=1 to nContItem                                    
      If nZ <= ITENSPAG1
         // ** Grava flag p/ os 3 primeiros registros (Tratamento para o Detail A no Crystal)
         DETAIL_P->(DbGoTo(nZ))
         RECLOCK("DETAIL_P",.F.)
         DETAIL_P->AVG_N01_04 := nZ
         DETAIL_P->(dbUnlock())                                  
      EndIf   
      // ** Grava flag p/ os registros restantes (Tratamento para o Detail B no Crystal)
      If nContItem > 3
         If nZ = 1
            DETAIL_P->(DbGoTo(4))
            RECLOCK("DETAIL_P",.F.)                              
            DETAIL_P->AVG_N01_04 := 8
            DETAIL_P->(dbUnlock())
         Else
            If nPag > 1
               // ** Grava flag p/ o inicio de cada pag. (Tratamento para o Detail B no Crystal)                     
               DETAIL_P->(DbGoTo(nPos))
               RECLOCK("DETAIL_P",.F.)                              
               DETAIL_P->AVG_N01_04 := 8
               DETAIL_P->(dbUnlock())
               nPag:= nPag-1 
               nPos:=nPos+ITENSPAG
            Endif
         EndIf
      EndIf                      
   Next                    
End Sequence

Return lRet


Static Function GetEmbs()
Local cTexto := ""
Local aEmbs := {}
Local cCodMemo := ""
Local i 

EE8->(dbSetOrder(1)) // FILIAL+PEDIDO
EE8->(dbSeek(xFilial("EE8")+EE7->EE7_PEDIDO))
   
While EE8->(!EOF()) .and. EE8->(EE8_FILIAL + EE8_PEDIDO) == xFilial("EE8") + EE7->EE7_PEDIDO
   If (nPos := aScan(aEmbs,{|X| AllTrim(Upper(X[1])) == AllTrim(Upper(EE8->EE8_EMBAL1)) })) == 0
      cCodMemo := Posicione("EE2",1,xFilial("EE2")+AvKey("6","EE2_CODCAD")+AvKey("*","EE2_TIPMEN")+AvKey(EEC->EEC_IDIOMA,"EE2_IDIOMA")+AvKey(EE8->EE8_EMBAL1,"EE2_COD"),"EE2_TEXTO")
      If !Empty(cCodMemo)
         aAdd(aEmbs,cCodMemo)     
      EndIf
   EndIf
   EE8->(DbSkip())
EndDo  

For i := 1 To Len(aEmbs)
   cTexto += aEmbs[i] + " "
Next

If Empty(cTexto)
   cTexto := Space(100)
EndIf

Return cTexto
*-----------------------------------------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM49_RDM.PRW                                                                                *
*-----------------------------------------------------------------------------------------------------------------*
