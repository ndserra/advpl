#INCLUDE "EECPEM83.ch"

/*
Programa..: "EECPEM83.PRW
Objetivo..: INSTRUCAO EMBARQUE AVGLTT.RPT
Autor.....: Heder M Oliveira
Data/Hora.: 07/12/99
Obs.......: Replicação para o idioma PORTUGUES
Autor.....: Guilherme Fernandes Pilan - GFP
Data/Hora.: 03/10/2012 - 14:23
*/

#include "EECRDM.CH"

#define MARGEM Space(1)
#define COL1 15//25
#define COL2 60//71
#define COL3 45
#define LINCOL1 MARGEM+SPACE(21) //25)
#define LINCOL2 MARGEM+SPACE(6) //8)

User Function EECPEM83

Local lRet := .f.
Local aOrd := SaveOrd({"EE9","SA2","SA1","SYR","EEM","SYQ","EEN","EEB","SY5"})
Local nCod := Max(AVSX3("EEN_IMPORT",3)+AVSX3("EEN_IMLOJA",3),AVSX3("EEB_CODAGE",3))

Local aFields := {{"WKMARCA","C",02,0},;
                  {"WKTIPO","C",01,0},;
                  {"WKCODIGO","C",nCod,0},;
                  {"WKDESCR","C",AVSX3("EEN_IMPODE",3),0}}
Local cFile
Local cPictDecPes := if(EEC->EEC_DECPES > 0, "."+Replic("9",EEC->EEC_DECPES),"")

Local bGrvNF,cNotas
Local cEndUCB,cTelUCB,x
Local nNotify,nAgente,nCol,nTotLin,W

Private aHeader[0],aCAMPOS[0]
Private cPictPeso := "@E 999,999,999"+cPictDecPes

Private lInverte := .F.,cMarca := GetMark()
Private cTO_CON1,cTO_CON2,cTO_CON3

Private aNotify[0],aAgente[0],aObs_Docs[0]
Private mDetalhe

cFileMen:=""

Begin Sequence

   EE9->(dbSetOrder(4)) // FILIAL+PREEMB+POSIPI+COD_I
   SA2->(dbSetOrder(1)) // FILIAL+CODIGO+LOJA
   SA1->(dbSetOrder(1)) // FILIAL+CODIGO+LOJA
   SYR->(dbSetOrder(1)) // FILIAL+VIA+ORIGEM+DESTINO+TIPO TRANSP.
   EEM->(dbSetOrder(1)) // FILIAL+PREEMB+TIPO
   SYQ->(dbSetOrder(1)) // FILIAL+VIA
   SYR->(dbSetOrder(1)) // FILIAL+VIA+ORIGEM+DEST+TIPTRAN
   EEN->(dbSetOrder(1))
   EEB->(dbSetOrder(1))

   // Criacao do Arquivo de Trabalho ...
   cFile := E_CriaTrab(,aFields,"WorkNOT")
   IndRegua("WorkNOT",cFile+OrdBagExt(),"WKTIPO+WKCODIGO")

   cTO_CON1:=SPACE(AVSX3("EE3_NOME",3))
   cTO_CON2:=SPACE(AVSX3("EE3_NOME",3))
   cTO_CON3:=SPACE(AVSX3("EE3_NOME",3))
   
   cF3COD   := ""
   cF3LOJ   := ""
   
   IF !TelaGets()
      Break
   Endif
   
   // Gravar todas as N.F.
   EEM->(dbSeek(xFilial()+EEC->EEC_PREEMB+EEM_NF))
   
   cNotas := ""
   bGrvNF := {|| cNotas := cNotas+AllTrim(EEM->EEM_NRNF)+" " }
  
   /* by jbj - 28/06/04 09:21 - Retirada da função SysRefresh(). As demais condições estão 
                                   mantidas */
   EEM->(dbEval(bGrvNF,{||EEM_TIPONF<>EEM_CP},{|| EEM_FILIAL==xFilial("EEM") .And. EEM_PREEMB == EEC->EEC_PREEMB .And. EEM_TIPOCA==EEM_NF}))   //By JPP - 23/03/2006 - 15:25 - O filtro {||EEM_TIPONF<>EEM_CP} é para o caso de nota fiscal complementar.
   // EEM->(dbEval(bGrvNF,,{|| SysRefresh() .And. EEM_FILIAL==xFilial("EEM") .And. EEM_PREEMB == EEC->EEC_PREEMB .And. EEM_TIPOCA==EEM_NF}))

   //gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      Break
   Endif

   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   
   AVGLTT->AVG_C01_10 := "Pagina"     //GFP - 27/11/2012
   
   mDETALHE:=MARGEM+PADR("DATA",COL1)+DTOC(dDATABASE)
   mDETALHE:=mDETALHE+PADL(STR0001,COL3-1)+SPACE(2)+EEC->EEC_PREEMB+ENTER // "Nr. EXPORTAÇÃO Nr."
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   mDETALHE:=mDETALHE+PADL(STR0002,COL2) //"Nr. R.E."
   mDETALHE:=mDETALHE+SPACE(10)+Transf(EE9->EE9_RE,AVSX3("EE9_RE",6))+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR(STR0003,6)// 8) //"PARA"
   
   SYQ->(dbSeek(xFilial()+EEC->EEC_VIA))
   IF LEFT(SYQ->YQ_COD_DI,1) == "7" // Rodoviario
      // A Transportadora
      mDETALHE:=mDETALHE+PADR(STR0004,45) //39)rhp //"TRANSPORTADORA"
   Else
      // Ao Despachante
      mDETALHE:=mDETALHE+PADR(STR0005,45)//54)       rhp //"DESPACHANTE"
   Endif
   
   mDETALHE:=mDETALHE+STR0006+SPACE(10)+cNotas+ENTER //"Nr. N.F."
   IF LEFT(SYQ->YQ_COD_DI,1) == "7" // Rodoviario
      // A Transportadora
      mDETALHE:=mDETALHE+LINCOL2+PADR(BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA),45) //54) rhp
   Else
      // Ao Despachante
      mDETALHE:=mDETALHE+LINCOL2+PADR(BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_DES),45)//54) rhp
   Endif
   
   // Transporte
   IF LEFT(SYQ->YQ_COD_DI,1) == "7" // Rodoviario
      mDETALHE:=mDETALHE+STR0007+SPACE(11) //"EMPRESA"
      mDETALHE:=mDETALHE+Left(AllTrim(BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA)),25)+ENTER
   Else
      mDETALHE:=mDETALHE+STR0008+SPACE(12) //"NAVIO"
      mDETALHE:=mDETALHE+AllTrim(EEC->EEC_EMBARCAC)+ENTER
   Endif
   
   IF !EEB->(Eof())
      mDETALHE:=mDETALHE+LINCOL2+PADR(AllTrim(EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1))+"-"+;
                         AllTrim(EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",6)),45)       

      mDETALHE:=mDETALHE+STR0009+SPACE(11)+Dtoc(EEC->EEC_ETA)+ENTER //+"-"+Dtoc(EEC->EEC_ETADES)+ENTER //RHP //"ETA    "
                        
      mDETALHE := mDETALHE +LINCOL2+PADR(AllTrim(EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",7)),45) +ENTER
   Else
      mDETALHE:=mDETALHE+LINCOL2+SPACE(45)  //SPACE(54)
      mDETALHE:=mDETALHE+STR0009+SPACE(11)+Dtoc(EEC->EEC_ETA)+ENTER//+"-"+Dtoc(EEC->EEC_ETADES)+ENTER // RHP //"ETA    "
   Endif
   
   // Alterado por Heder M Oliveira - 12/23/1999
   // mDETALHE:=mDETALHE+"ETA    "+SPACE(11)+Dtoc(EEC->EEC_ETA)//+"-"+Dtoc(EEC->EEC_ETADES)+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADL(STR0010,COL2+1)+SPACE(8)+LEFT(AllTrim(BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_AGE)),10)+ENTER //"AGENCIA   "
   mDETALHE:=mDETALHE+MARGEM+PADL(STR0011,COL2+1)+SPACE(8)+/*SYQ->YQ_DESCR*/PEM83TRANSPOR()+ENTER //"TRANSPORTE"   // GFP - 27/11/2012
   mDETALHE:=mDETALHE+ENTER
   
   IF (!EMPTY(cTO_CON1).OR.!EMPTY(cTO_CON2).OR.!EMPTY(cTO_CON3))
      mDETALHE:=mDETALHE+MARGEM+PADR(STR0012,COL1)+ENTER //"C/Copia"
   ENDIF
   
   IIF(!EMPTY(cTO_CON1),mDETALHE:=mDETALHE+LINCOL2+cTO_CON1+ENTER,NIL)
   IIF(!EMPTY(cTo_CON2),mDETALHE:=mDETALHE+LINCOL2+cTO_CON2+ENTER,NIL)
   IIF(!EMPTY(cTo_CON3),mDETALHE:=mDETALHE+LINCOL2+cTO_CON3+ENTER,NIL)

   IF (!EMPTY(cTO_CON1).OR.!EMPTY(cTO_CON2).OR.!EMPTY(cTO_CON3))
      mDetalhe := mDetalhe +ENTER
   ENDIF
   
   mDETALHE:=mDETALHE+SPACE(40)+STR0013+ENTER+ENTER //"INSTRUCAO DE EMBARQUE"
   mDETALHE:=mDETALHE+MARGEM+PADR(STR0014,COL1) //"EXPORTADOR"
   
   // Endereco UCB-SP
   SA2->(dbSeek(xFilial("SA2")+AvKey("UCQ","A2_COD")))
   
   cEndUCB := "HEADER OFFICE: "
   cEndUCB := cEndUCB+IF(!Empty(x:=AllTrim(SA2->A2_END)),x,"")
   cEndUCB := cEndUCB+IF(!Empty(x:=AllTrim(SA2->A2_BAIRRO)),"-"+x,"")
   cEndUCB := cEndUCB+IF(!Empty(x:=AllTrim(SA2->A2_MUN)),"-"+x,"")
   cEndUCB := cEndUCB+IF(!Empty(x:=AllTrim(SA2->A2_EST)),"-"+x,"")
   cEndUCB := cEndUCB+IF(!Empty(x:=AllTrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM"))),"-"+x,"")
   
   cTelUCB := IF(!Empty(x:=AllTrim(SA2->A2_TEL)),STR0015+x,"") //"TEL "
   cTelUCB := cTelUCB+IF(!Empty(x:=AllTrim(SA2->A2_FAX)),STR0016+x,"") //" / FAX "
      
   // Exportador ...
   IF !Empty(EEC->EEC_EXPORT) .And.;
      SA2->(dbSeek(xFilial()+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))
      cF3COD   := EEC->EEC_EXPORT
      cF3LOJ   := EEC->EEC_EXLOJA
   Else
      SA2->(dbSeek(xFilial()+EEC->EEC_FORN+EEC->EEC_FOLOJA))
      cF3COD   := EEC->EEC_FORN
      cF3LOJ   := EEC->EEC_FOLOJA
   Endif
   
   AVGLTT->AVG_C01_60 := SA2->A2_NOME
   // by CAF 23/03/2000 AVGLTT->AVG_C02_60 := Alltrim(SA2->A2_END)+" - "+Alltrim(SA2->A2_BAIRRO)+" CEP "+Alltrim(TRANS(SA2->A2_CEP,X3PICTURE("A2_CEP")))+" " + AllTrim(SA2->A2_MUN)+"-"+AllTrim(SA2->A2_EST)//"RUA DR. EDUARDO DE SOUZA ARANHA, 153, - ITAIM BIBI CEP 04543-904 - SAO PAULO SP BRASIL"
   // by CAF 23/03/2000 AVGLTT->AVG_C03_60 := "TEL " + Alltrim(SA2->A2_TEL) + " / FAX " +Alltrim(SA2->A2_FAX)  //  "TEL (5511) 828 1229 / FAX (5511) 828 1009"
   
   AVGLTT->AVG_C01100 := cEndUCB
   AVGLTT->AVG_C02100 := cTelUCB
   
   mDETALHE:=mDETALHE+SPACE(6)+SA2->A2_NOME+ENTER
   mDETALHE:=mDETALHE+LINCOL1+SA2->A2_END+ENTER
   mDETALHE:=mDETALHE+LINCOL1+AllTrim(SA2->A2_BAIRRO)+" - "+AllTrim(SA2->A2_MUN)+" - "+AllTrim(SA2->A2_CEP)+" - "+AllTrim(SA2->A2_EST)+;
             " - "+AllTrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR"))+ENTER               // GFP - 22/11/2012
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+MARGEM+PADR(/*"SOLD TO"*/ "VENDIDO PARA",COL1)  //GFP - 25/09/2012
   
   // Importador
   SA1->(dbSeek(xFilial()+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
   
   IF Empty(EEC->EEC_IMPODE)
      mDETALHE:=mDETALHE+SPACE(6)+SA1->A1_NOME+ENTER
   Else
      mDETALHE:=mDETALHE+SPACE(6)+EEC->EEC_IMPODE+ENTER
   Endif
   
   IF Empty(EEC->EEC_ENDIMP)
      If Len(EECMEND("SA1",1,EEC->EEC_IMPORT+EEC->EEC_IMLOJA,.T.,NIL,1)) > 60  // GFP - 04/12/2012
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,EEC->EEC_IMPORT+EEC->EEC_IMLOJA,.T.,NIL,1),0,60)+ENTER
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,EEC->EEC_IMPORT+EEC->EEC_IMLOJA,.T.,NIL,1),61,100)+ENTER
      Else
         mDETALHE:=mDETALHE+LINCOL1+EECMEND("SA1",1,EEC->EEC_IMPORT+EEC->EEC_IMLOJA,.T.,NIL,1)+ENTER
      EndIf
   Else
      If Len(EEC->EEC_ENDIMP) > 60    // GFP - 04/12/2012
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EEC->EEC_ENDIMP,0,60)+ENTER
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EEC->EEC_ENDIMP,61,100)+ENTER
      Else
         mDETALHE:=mDETALHE+LINCOL1+EEC->EEC_ENDIMP+ENTER
      EndIf
   Endif
   
   IF Empty(EEC->EEC_END2IM)
      If Len(EECMEND("SA1",1,EEC->EEC_IMPORT+EEC->EEC_IMLOJA,.T.,NIL,2)) > 60       // GFP - 04/12/2012
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,EEC->EEC_IMPORT+EEC->EEC_IMLOJA,.T.,NIL,2),0,60)+ENTER
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,EEC->EEC_IMPORT+EEC->EEC_IMLOJA,.T.,NIL,2),61,100)+ENTER
      Else
         mDETALHE:=mDETALHE+LINCOL1+EECMEND("SA1",1,EEC->EEC_IMPORT+EEC->EEC_IMLOJA,.T.,NIL,2)+ENTER
      EndIf
   Else
      If Len(EEC->EEC_END2IM) > 60       // GFP - 04/12/2012
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EEC->EEC_END2IM,0,60)+ENTER
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EEC->EEC_END2IM,61,100)+ENTER
      Else
         mDETALHE:=mDETALHE+LINCOL1+EEC->EEC_END2IM+ENTER
      EndIf
   Endif
   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR(/*"SHIP TO"*/ "ENVIAR PARA ",COL1)  //GFP - 25/09/2012  
   
   // Ship To
   IF !Empty(EEC->EEC_CLIENT) .And.;
      SA1->(dbSeek(xFilial()+EEC->EEC_CLIENT+EEC->EEC_CLLOJA))
   Else
      SA1->(dbSeek(xFilial()+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
   Endif
   
   mDETALHE:=mDETALHE+SPACE(6)+SA1->A1_NOME+ENTER
   If Len(EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,1)) > 60            // GFP - 04/12/2012
      mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,1),0,60)+ENTER
      mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,1),61,100)+ENTER
      mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,2),0,60)+ENTER
      mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,2),61,100)+ENTER
   Else
      mDETALHE:=mDETALHE+LINCOL1+EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,1)+ENTER
      mDETALHE:=mDETALHE+LINCOL1+EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,2)+ENTER
   EndIf
   mDETALHE:=mDETALHE+ENTER
   
   // Consignee
   IF !Empty(EEC->EEC_CONSIG) .And.;
      SA1->(dbSeek(xFilial()+EEC->EEC_CONSIG+EEC->EEC_COLOJA))
      mDETALHE:=mDETALHE+MARGEM+PADR(/*"CONSIGNEE"*/"CONSIGNATARIO",COL1)  //GFP - 25/09/2012  
      mDETALHE:=mDETALHE+SPACE(6)+SA1->A1_NOME+ENTER
      
      If Len(EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,1)) > 60       // GFP - 04/12/2012
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,1),0,60)+ENTER
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,1),61,100)+ENTER
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,2),0,60)+ENTER
         mDETALHE:=mDETALHE+LINCOL1+SubStr(EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,2),61,100)+ENTER
      Else
         mDETALHE:=mDETALHE+LINCOL1+EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,1)+ENTER
         mDETALHE:=mDETALHE+LINCOL1+EECMEND("SA1",1,SA1->A1_COD+SA1->A1_LOJA,.T.,NIL,2)+ENTER
      EndIf
      mDETALHE:=mDETALHE+ENTER
   Endif
   
   FOR nNOTIFY:=1 TO LEN(aNOTIFY)
      mDETALHE:=mDETALHE+MARGEM+PADR("NOTIFICAÇÃO "+STR(nNOTIFY,1),COL1)
      mDETALHE:=mDETALHE+SPACE(6)+aNotify[nNOTIFY][1]+ENTER
      mDETALHE:=mDETALHE+LINCOL1+aNotify[nNOTIFY][2]+ENTER
      mDETALHE:=mDETALHE+LINCOL1+aNotify[nNOTIFY][3]+ENTER        // GFP - 22/10/2012
      mDETALHE:=mDETALHE+ENTER
   NEXT
   
   SYR->(dbSeek(xFilial()+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))
   mDETALHE:=mDETALHE+MARGEM+PADR(/*"PORT OF SHIPMENT"*/"PORTO DE EMBARQUE",COL1/*+1*/+2)  //GFP - 25/09/2012  
   mDETALHE:=mDETALHE+SPACE(/*5*/4)+Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR")+ENTER+ENTER  //GFP - 25/09/2012 
   
   mDETALHE:=mDETALHE+MARGEM+PADR(/*"PORT OF DISCHARGE"*/"PORTO DE DESEMBARQUE",COL1/*+2*/+5)  //GFP - 25/09/2012  
   mDETALHE:=mDETALHE+SPACE(/*4*/1)+Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")+ENTER+ENTER   //GFP - 25/09/2012 
   
   FOR nAGENTE:=1 TO LEN(aAGENTE)
      mDETALHE:=mDETALHE+MARGEM+PADR(/*"AGENT "*/"AGENTE "+STR(nAGENTE,1),COL1)  //GFP - 25/09/2012 
      mDETALHE:=mDETALHE+SPACE(6)+aAgente[nAGENTE][1]+ENTER
      mDETALHE:=mDETALHE+LINCOL1+aAgente[nAGENTE][2]+ENTER
      mDETALHE:=mDETALHE+ENTER
   NEXT
   
   mDETALHE:=mDETALHE+MARGEM+PADR(/*"DESCRIPTION OF GOODS "*/"DESCRICAO DO PRODUTO ",COL1+5)  //GFP - 25/09/2012
  
   // Grava Itens ...
   GravaItens()
   
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+MARGEM+PADR(/*"TOTAL NET WEIGHT"*/"TOTAL PESO LIQUIDO",COL1/*+1*/+3)  //GFP - 25/09/2012
   mDETALHE:=mDETALHE+PADL(lTrim(Transf(EEC->EEC_PESLIQ,cPictPeso)),COL1/*-1*/-3)+" KG"+ENTER //+EE9->EE9_UNIDAD+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR(/*"TOTAL GROSS WEIGHT"*/"TOTAL PESO BRUTO",COL1+3)  //GFP - 25/09/2012
   mDETALHE:=mDETALHE+PADL(lTrim(Transf(EEC->EEC_PESBRU,cPictPeso)),COL1-3)+" KG"+ENTER //+EE9->EE9_UNIDAD+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR(/*"MEASUREMENT"*/"MEDICAO",COL1)  //GFP - 25/09/2012
   mDETALHE:=mDETALHE+PADL(lTrim(Transf(EEC->EEC_CUBAGE,AVSX3("EEC_CUBAGE",6))),COL1)+" M3"+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR(/*"PACKAGE"*/"EMBALAGEM",COL1)  //GFP - 25/09/2012
   mDETALHE:=mDETALHE+SPACE(06)+EEC->EEC_PACKAG+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR("TOTAL "+EEC->EEC_INCOTE+/*" VALUE"*/" VALOR",COL1+5)  //GFP - 25/09/2012
   mDETALHE:=mDETALHE+SPACE(1)+EEC->EEC_MOEDA+" "+Transf(EEC->EEC_TOTPED,AVSX3("EEC_TOTPED",6))+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR(/*"TOTAL FREIGHT"*/"TOTAL FRETE",COL1+5)  //GFP - 25/09/2012
   cFreight := Padr(IF(EEC->EEC_FRPPCC=="CC","RECOLHER","PRE-PAGO"),15)
   cFREICOM := "FRETE "  //GFP - 25/09/2012
   cCONSCOR := "EMBARQUE LIMPO A BORDO"

   
   mDETALHE:=mDETALHE+SPACE(1)+EEC->EEC_MOEDA+" "+Transf(EEC->EEC_FRPREV,AVSX3("EEC_FRPREV",6))+" "+cFREIGHT+ENTER
   // mDETALHE:=mDETALHE+MARGEM+PADR("FREIGHT",COL1)
   // mDETALHE:=mDETALHE+SPACE(06)+cFreight+ENTER

   mDETALHE:=mDETALHE+MARGEM+PADR(/*"COUNTRY OF ORIGIN"*/"PAIS DE ORIGEM",COL1+2) //GFP - 25/09/2012
   mDETALHE:=mDETALHE+SPACE(4)+Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM")+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR(STR0017,COL1) //"L/C NBR"
   mDETALHE:=mDETALHE+EEC->EEC_LC_NUM+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR(STR0018,COL1) //"I/L NBR"
   mDETALHE:=mDETALHE+PADR(EEC->EEC_LICIMP,COL1)+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR(STR0019,COL1)//"OBSERVACOES"  // GFP - 25/09/2012
   mDETALHE:=mDETALHE+SPACE(6)+MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),1)+ENTER
   mDETALHE:=mDETALHE+LINCOL1+MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),2)+ENTER
   mDETALHE:=mDETALHE+LINCOL1+MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),3)+ENTER
   mDETALHE:=mDETALHE+LINCOL1+MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),4)+ENTER
   mDETALHE:=mDETALHE+LINCOL1+MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),5)+ENTER
   mDETALHE:=mDETALHE+LINCOL1+MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),6)+ENTER+ENTER
   
   mDETALHE:=mDETALHE+MARGEM+PADR(STR0020,COL1+1) //"CONSTAR NO CORPO DO"
   mDETALHE:=mDETALHE+SPACE(5)+cCONSCOR+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR(STR0021,COL1+6) //"CONHECIMENTO"
   
   mDETALHE:=mDETALHE+cFREICOM+cFreight+ENTER
   
   If EEC->(TYPE("EEC_SPCRM1"))#"U" .and. EEC->(TYPE("EEC_SPCRM2"))#"U" .and. EEC->(TYPE("EEC_SPCRM3"))#"U"
   mDETALHE  :=mDETALHE+LINCOL1+IncSpace(EEC->EEC_SPCRM1,100,.f.)+ENTER
   mDETALHE  :=mDETALHE+LINCOL1+IncSpace(EEC->EEC_SPCRM2,100,.f.)+ENTER
   mDETALHE  :=mDETALHE+LINCOL1+IncSpace(EEC->EEC_SPCRM3,100,.f.)+ENTER
   Endif
   
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+MARGEM+PADR(STR0019,COL1) //"OBSERVACOES"
   mDETALHE:=mDETALHE+SPACE(6)+STR0023+ENTER //"EMITIR CONHECIMENTO EM (03) ORIGINAIS E (10) CÓPIAS"
   
   // Alterado por Heder M Oliveira - 4/6/2000
   // mDETALHE:=mDETALHE+LINCOL1+"EMBARQUE SHIPS CONVENIENCE"+ENTER
   IF Select("Work_Men") > 0
      nCol := 60
      Work_Men->(dbGoTop())
      While ! Work_Men->(Eof()) .And. Work_Men->WKORDEM < "zzzzz"
         nTotLin:=MlCount(Work_Men->WKOBS,nCol) 
         
         For w := 1 To nTotLin
            IF !Empty(MemoLine(Work_Men->WKOBS,nCol,w))
               mDETALHE:=mDETALHE+LINCOL1+MemoLine(Work_Men->WKOBS,nCol,w)+ENTER
            EndIf
         Next
         Work_Men->(dbSkip())
      Enddo
   Endif
   
   mDETALHE:=mDETALHE+REPLICATE(ENTER,3)
   mDETALHE:=mDETALHE+MARGEM+STR0024+ENTER //"ATENCIOSAMENTE,"
   mDETALHE:=mDETALHE+REPLICATE(ENTER,3)
   mDETALHE:=mDETALHE+LINCOL1+Replicate("-",Len(EEC->EEC_RESPON))+ENTER
   mDETALHE:=mDETALHE+LINCOL1+EEC->EEC_RESPON+ENTER
   
   AVGLTT->WK_DETALHE := mDETALHE
   
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO)
   
End Sequence

IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cFileMen))
Endif

WorKNOT->(E_EraseArq(cFile))

RestOrd(aOrd)

Return lRet
   
/*
Funcao      : GravaItens
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function GravaItens

Local nVez := 1
Local cCod := ""
Local nQtde:= 0
Local cUnid:= ""
Local /*cDescItFM,*/cDescIt := ""

Begin Sequence

   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   //cDescItFM:=alltrim(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),2))+ENTER

   While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB
      
      nQtde := 0
      cCod  := EE9->EE9_COD_I
      cFam  := EE9->EE9_FPCOD
      cUnid := "KG"//EE9->EE9_UNIDAD
      
      //ER - 14/06/06 - Descrição aparecia duplicada.
      cDescIt := AA100Idioma(EE9->EE9_COD_I)+ENTER //ALLTRIM(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),1))+ENTER     // GFP - 03/10/2012
      
     //cDESCIT:=IF(!EMPTY(cDESCITFM),cDESCITFM+LINCOL1+SPACE(13),"")+ALLTRIM(MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),1))
     //cDESCITFM:=""
      
      While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
            EE9->EE9_PREEMB == EEC->EEC_PREEMB .And. EE9->EE9_COD_I==cCod
         nQtde := nQtde+EE9->EE9_PSLQTO
         EE9->(dbSkip())
      Enddo
      
      //mDetalhe:=mDetalhe+IF(nVez>1,LINCOL1," ")+LTrim(Transf(nQtde,AVSX3("EE9_PSBRTO",6)))+" "+AllTrim(cUnid)+" "
      mDetalhe:=mDetalhe+IF(nVez>1,LINCOL1+Space(1),Space(2))+cDESCIT//+ENTER       // GFP - 22/11/2012
      nVez:=nVez+1
   Enddo 
End Sequence

Return NIL
   
/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.
Local bOk  := {||lRet:=.t.,oDlg:End()}
Local bCancel := {||oDlg:End()}

Local aCampos := { {"WKMARCA",," "},;
                   {{||if(AllTrim(WorkNOT->WKTIPO)=="A",STR0025,STR0026)},,STR0027},; //"Agente"###"Notify"###"Tipo"
                   {"WKCODIGO",,STR0028},; //"Código"
                   {"WKDESCR",,STR0029}} //"Descrição"

Local aMarcados[4]
Local nTamLoj,cKey,cLoja,cImport 

Local oFld,aFld,oFldF,oMark

Local bHide    := {|nTela| if(nTela==2,oMark:oBrowse:Hide(),;
                              if(nTela==3,oMark2:oBrowse:Hide(),)) }

Local bHideAll := {|| Eval(bHide,2), Eval(bHide,3) }

Local bShow    := {|nTela,o| if(nTela==2,dbSelectArea("WorkNOT"),if(nTela==3,dbSelectArea("Work_Men"),)),;
                             o := if(nTela==2,oMark:oBrowse,if(nTela==3,oMark2:oBrowse,NIL)),;
                             if(o <> NIL,(o:Show(),o:SetFocus()),) }
Local xx := "", i:=0

Begin Sequence
   
   GravaWork()
   
   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 9,0 TO 28,80 OF oMainWnd
   
      oFld := TFolder():New(15,1,{STR0030,STR0031,STR0032},{"CON","AGE","OBS"},oDLG,,,,.T.,.F.,314,130) //"Contatos"###"Agentes"###"Observações"
      aFld := oFld:aDialogs
      
      aEval(aFld,{|x| x:SetFont(oDlg:oFont) })
      
      oFldF:=aFld[1] //CONTATOS
      
      //para encontrar a proxima linha, some 9. Ex.: 10+9=19
      TSAY():New(26,20,{|| STR0033 },oFldF,,,,,,.T.,,,232,10) //"Contato 1 "
      TGET():New(26,50,bSETGET(cTO_CON1),oFldF,140,08,,,,,,,,.T.,,,,,,,,,"E32")
      TSAY():New(42,20,{|| STR0034 },oFldF,,,,,,.T.,,,232,10) //"Contato 2 "
      TGET():New(42,50,bSETGET(cTO_CON2),oFldF,140,08,,,,,,,,.T.,,,,,,,,,"E32")
      TSAY():New(58,20,{|| STR0035 },oFldF,,,,,,.T.,,,232,10) //"Contato 3 "
      TGET():New(58,50,bSETGET(cTO_CON3),oFldF,140,08,,,,,,,,.T.,,,,,,,,,"E32")
      
      // Agentes
      @ 14,043 MSGET xx OF oFld:aDialogs[2] PIXEL  
      oMark := MsSelect():New("WorkNOT","WKMARCA",,aCampos,@lInverte,@cMarca,{30,1,140,315})
      oMark:bAval := {|| ChkMarca(aMarcados,oMark) }
      AddColMark(oMark,"WKMARCA")
      
      // Observacoes
      @ 14,043 MSGET xx OF oFld:aDialogs[3] PIXEL    
      oMark2 := EECMensagem(EEC->EEC_IDIOMA,"4",{30,1,140,325})
      
      Eval(bHideAll)
     
      oFld:bChange := {|nOption,nOldOption| Eval(bHide,nOldOption),;
                                            Eval(bShow,nOption) }
   
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)
   
   IF !lRet
      Break
   Endif

   For i:=1 To LEN(aMarcados)
      IF !Empty(aMarcados[i])
         nTamLoj := AVSX3("EEN_IMLOJA",3)
         cKey    := Subst(aMarcados[i],2)
         cLoja   := Right(cKey,nTamLoj) 
         cImport := Subst(cKey,1,Len(cKey)-nTamLoj)
         
         IF EEN->(dbSeek(xFilial()+AvKey(EEC->EEC_PREEMB,"EEN_PROCES")+OC_EM+AvKey(cImport,"EEN_IMPORT")+AvKey(cLoja,"EEN_IMLOJA")))
            AADD(aNotify,{EEN->EEN_IMPODE,EEN->EEN_ENDIMP,EEN->EEN_END2IM})       // GFP - 22/11/2012
         Endif
      Endif
   Next

   For i:=3 To LEN(aMARCADOS)
      IF !Empty(aMarcados[i])
         IF EEB->(dbSeek(xFilial()+AvKey(EEC->EEC_PREEMB,"EEB_PEDIDO")+OC_EM+AvKey(Subst(aMarcados[i],2),"EEB_CODAGE")))
            SY5->(dbSeek(xFilial()+AvKey(Subst(aMarcados[i],2),"Y5_COD")))
            AADD(aAgente,{EEB->EEB_NOME,SY5->Y5_END})
         Endif
      Endif
   Next
   
End Sequence

Return lRet

/*
Funcao      : ChkMarca(aMarcados)
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function ChkMarca(aMarcados,oMark)

Local n

Begin Sequence

   IF !Empty(WorkNOT->WKMARCA) 
      // Desmarca
      n := aScan(aMarcados,WorkNOT->WKTIPO+WorkNOT->WKCODIGO)
      IF n > 0
         aMarcados[n] := ""
      Endif
      
      WorkNOT->WKMARCA := Space(2)
   Else
      // Marca
      IF WorkNOT->WKTIPO == "N" // Notify
         IF Empty(aMarcados[1])
            aMarcados[1] := WorkNOT->WKTIPO+WorkNOT->WKCODIGO
         Else
            aMarcados[2] := WorkNOT->WKTIPO+WorkNOT->WKCODIGO
         Endif
      Else
         IF !Empty(aMarcados[3]) .And. !Empty(aMarcados[4])
            MsgStop(STR0036,STR0037) //"Já existem dois agentes selecionados !"###"Aviso"
            Break
         Endif
         
         IF Empty(aMarcados[3])
            aMarcados[3] := WorkNOT->WKTIPO+WorkNOT->WKCODIGO
         Else
            aMarcados[4] := WorkNOT->WKTIPO+WorkNOT->WKCODIGO
         Endif
      Endif
      
      WorkNOT->WKMARCA := cMarca
   Endif
   
   oMark:oBrowse:Refresh()
   SysRefresh()

End Sequence   

Return NIL

/*
Funcao      : GravaWork
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
Static Function GravaWork

Begin Sequence

   // Notify
   EEN->(dbSeek(xFilial()+EEC->EEC_PREEMB+OC_EM))

   While EEN->(!Eof() .And. EEN_FILIAL == xFilial("EEN")) .And.;
       EEN->EEN_PROCES+EEN->EEN_OCORRE == EEC->EEC_PREEMB+OC_EM
       
      SysRefresh()
      
      WorkNOT->(dbAppend())
      WorkNOT->WKTIPO := "N"
      WorkNOT->WKCODIGO := EEN->EEN_IMPORT+EEN->EEN_IMLOJA
      WorkNOT->WKDESCR  := EEN->EEN_IMPODE
       
      EEN->(dbSkip())
   Enddo   

   // Agentes
   EEB->(dbSeek(xFilial()+EEC->EEC_PREEMB+OC_EM))

   While EEB->(!Eof() .And. EEB_FILIAL == xFilial("EEB")) .And.;
       EEB->EEB_PEDIDO+EEB->EEB_OCORRE == EEC->EEC_PREEMB+OC_EM
       
      SysRefresh()
      
      IF ! (Left(EEB->EEB_TIPOAG,1) $ "2,3") // Ag. de Comissao/Ag.Rec.de Dados
         EEB->(dbSkip())
         Loop
      Endif
      
      WorkNOT->(dbAppend())
      WorkNOT->WKTIPO := "A"
      WorkNOT->WKCODIGO := EEB->EEB_CODAGE
      WorkNOT->WKDESCR := EEB->EEB_NOME
      
      EEB->(dbSkip())
   Enddo   

   WorkNOT->(dbGoTop())

End Sequence

Return NIL
   
*--------------------------------*  
Static Function PEM83TRANSPOR()   
*--------------------------------*
Local cCod := Left(SYQ->YQ_COD_DI,1)
Local cTrans

SX5->(DbSetOrder(1))
SX5->(DbSeek(xFilial("SX5")+"Y3"+cCod))

cTrans := AllTrim(UPPER(SX5->X5_DESCRI))

Return cTrans