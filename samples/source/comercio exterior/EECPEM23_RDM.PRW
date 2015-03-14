/*
Programa        : EECPEM23.PRW
Objetivo        : Instrucao de Embarque
Autor           : Cristiano A. Ferreira
Data/Hora       : 29/10/1999 23:44
Obs.            :
*/
// Alterado por Heder M Oliveira - 11/12/1999
// Alterado por Heder M Oliveira - 11/19/1999
/*
considera que estah posicionado no registro de embarque (EEC)
*/
#define EEM_NF    "N"
#define ENTER CHR(13)+CHR(10)
#define MARGEM Space(6)

User Function EECPEM23

#xtranslate bSETGET(<uVar>) => {|u| If(PCount() == 0, <uVar>, <uVar> := u) } 

// *** Declara variaveis utilizadas ...
aOrd := SaveOrd({"EE9","SA2","SA1","SYR","EEM","SYQ","SYR","EEN","EEB","SY5"})
mDet := ""
cFileMen:=""

cPictDecPes := if(EEC->EEC_DECPES > 0, "."+Replic("9",EEC->EEC_DECPES),"")
cPictPeso   := "@E 999,999,999"+cPictDecPes

EE9->(dbSetOrder(4)) // FILIAL+PREEMB+POSIPI
SA2->(dbSetOrder(1)) // FILIAL+CODIGO+LOJA
SA1->(dbSetOrder(1)) // FILIAL+CODIGO+LOJA
SYR->(dbSetOrder(1)) // FILIAL+VIA+ORIGEM+DESTINO+TIPO TRANSP.
EEM->(dbSetOrder(1)) // FILIAL+PREEMB+TIPO
SYQ->(dbSetOrder(1)) // FILIAL+VIA
SYR->(dbSetOrder(1)) // FILIAL+VIA+ORIGEM+DEST+TIPTRAN
EEN->(dbSetOrder(1))
EEB->(dbSetOrder(1))

// *** Cria Arquivo de Trabalho ...
aHeader := {}
aCAMPOS := ARRAY(0)

nCod := Max(AVSX3("EEN_IMPORT",3)+AVSX3("EEN_IMLOJA",3),AVSX3("EEB_CODAGE",3))

aFields := {{"WKMARCA","C",02,0},;
            {"WKTIPO","C",01,0},;
            {"WKCODIGO","C",nCod,0},;
            {"WKDESCR","C",AVSX3("EEN_IMPODE",3),0}}
            
cFile := E_CriaTrab(,aFields,"Work")
IndRegua("Work",cFile+OrdBagExt(),"WKTIPO+WKCODIGO")

lInverte := .F.
tg_cMarca := GetMark()

aNotify := Array(4)
aAgente := Array(4)

aFill(aNotify,"")
aFill(aAgente,"")

cTO_CON1:=SPACE(AVSX3("EE3_NOME",3))
cTO_CON2:=SPACE(AVSX3("EE3_NOME",3))
cTO_CON3:=SPACE(AVSX3("EE3_NOME",3))
cF3COD   := ""
cF3LOJ   := ""

While .t.
   
   IF !TelaGets()
      lRet := .F. 
      Exit
   Endif

   //gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      lRet := .F.
      Exit
   Endif

   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo

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
   
   AVGLTT->AVG_C05_60 := SA2->A2_NOME
   AVGLTT->AVG_C06_60 := SA2->A2_END
   AVGLTT->AVG_C07_60 := AllTrim(SA2->A2_MUN)+"-"+AllTrim(SA2->A2_EST)
   
   SYQ->(dbSeek(xFilial()+EEC->EEC_VIA))
   
   IF Left(SYQ->YQ_COD_DI,1) == "7" // Rodoviario
      // A Transportadora
      AVGLTT->AVG_C03_30 := "A TRANSPORTADORA"
      AVGLTT->AVG_C02_60 := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA)
   Else
      // Ao Despachante
      AVGLTT->AVG_C03_30 := "AO DESPACHANTE"
      AVGLTT->AVG_C02_60 := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_DES)
   Endif
   
   AVGLTT->AVG_C03_60 := AllTrim(EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1))+"-"+;
                         AllTrim(EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",6))+"-"+;
                         AllTrim(EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",7))

   // Processo/Ref/Nf
   AVGLTT->AVG_C01_20 := Transf(EEC->EEC_PREEMB,AVSX3("EEC_PREEMB",6))
   
   // Gravar todas as N.F.
   EEM->(dbSeek(xFilial()+EEC->EEC_PREEMB+EEM_NF))
   
   cNotas := ""
   bGrvNF := {|| cNotas := cNotas+AllTrim(EEM->EEM_NRNF)+" " }
   
   EEM->(dbEval(bGrvNF,,{|| SysRefresh() .And. EEM_FILIAL==xFilial("EEM") .And. EEM_PREEMB == EEC->EEC_PREEMB .And. EEM_TIPOCA==EEM_NF}))
   
   AVGLTT->AVG_C04_60 := cNotas // Gravar todas as N.F.

   // Transporte
   IF Left(SYQ->YQ_COD_DI,1) == "7" // Rodoviario
      AVGLTT->AVG_C03_20 := "TRUCKER"
      AVGLTT->AVG_C01_30 :=  AllTrim(BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_TRA))+"/"+SYQ->YQ_DESCR
   Else
      AVGLTT->AVG_C03_20 := "VESSEL"
      AVGLTT->AVG_C01_30 :=  AllTrim(EEC->EEC_EMBARCAC)+"/"+BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_AGE)
   Endif
   
   IF SYR->(dbSeek(xFilial()+EEC->EEC_VIA+EEC->EEC_ORIGEM+EEC->EEC_DEST+EEC->EEC_TIPTRA))
      AVGLTT->AVG_C02_30 := Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR")
      AVGLTT->AVG_C08_60 := Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")
      AVGLTT->AVG_C04_20 := SYQ->(Subst(YQ_COD_DI,At("-",YQ_COD_DI)+1))
   Endif
   
   // Importador
   SA1->(dbSeek(xFilial()+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
   
   IF Empty(EEC->EEC_IMPODE)
      AVGLTT->AVG_C09_60 := SA1->A1_NOME
   Else
      AVGLTT->AVG_C09_60 := EEC->EEC_IMPODE
   Endif
   
   cLine1 := ""
   cLine2 := ""
   
   IF Empty(EEC->EEC_ENDIMP)
      cLine1 := MemoLine(AllTrim(SA1->A1_END)+"-"+AllTrim(SA1->A1_MUN),50,1)
      cLine2 := MemoLine(AllTrim(SA1->A1_END)+"-"+AllTrim(SA1->A1_MUN),50,2)
      AVGLTT->AVG_C10_60 := cLine1
   Else
      cLine1 := MemoLine(EEC->EEC_ENDIMP,50,1)
      cLine2 := MemoLine(EEC->EEC_ENDIMP,50,2)
      AVGLTT->AVG_C10_60 := cLine1
   Endif
   IF Empty(EEC->EEC_END2IM)
      AVGLTT->AVG_C11_60 := AllTrim(SA1->A1_ESTADO)+"-"+Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR")
   Else
      AVGLTT->AVG_C11_60 := EEC->EEC_END2IM
   Endif
   IF !Empty(cLine2)
      AVGLTT->AVG_C11_60 := AllTrim(cLine2)+" "+AVGLTT->AVG_C11_60
   Endif
   
   AVGLTT->AVG_C05_20 := ""//
   
   // Consignee
   IF !Empty(EEC->EEC_CONSIG) .And.;
      SA1->(dbSeek(xFilial()+EEC->EEC_CONSIG+EEC->EEC_COLOJA))
      
      AVGLTT->AVG_C12_60 := SA1->A1_NOME                                              
      AVGLTT->AVG_C13_60 := AllTrim(SA1->A1_END)                                      
      AVGLTT->AVG_C14_60 := AllTrim(SA1->A1_MUN)+AllTrim(SA1->A1_ESTADO)              
      AVGLTT->AVG_C06_20 := Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR") 
   Endif
   
   // Ship To
   IF !Empty(EEC->EEC_CLIENT) .And.;
      SA1->(dbSeek(xFilial()+EEC->EEC_CLIENT+EEC->EEC_CLLOJA))
   Else
      SA1->(dbSeek(xFilial()+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
   Endif
   
   cLine1 := MemoLIne(AllTrim(SA1->A1_END),50,1)
   cLine2 := MemoLIne(AllTrim(SA1->A1_END),50,2)
   
   
   AVGLTT->AVG_C18_60 := SA1->A1_NOME                                               
   AVGLTT->AVG_C19_60 := cLine1
   AVGLTT->AVG_C20_60 := AllTrim(SA1->A1_MUN)+AllTrim(SA1->A1_ESTADO)               
   
   IF !Empty(cLine2)
      AVGLTT->AVG_C20_60 := AllTrim(cLine2)+" "+AVGLTT->AVG_C20_60
   Endif
   
   AVGLTT->AVG_C07_20 := Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR")  
   
   // Notifys ...
   AVGLTT->AVG_C15_60 := aNotify[1]
   AVGLTT->AVG_C16_60 := aNotify[2]
   AVGLTT->AVG_C17_60 := aNotify[3]
   AVGLTT->AVG_C23_60 := aNotify[4]
   
   // Agentes ...
   AVGLTT->AVG_C22_60 := aAgente[1]
   AVGLTT->AVG_C24_60 := aAgente[2]
   AVGLTT->AVG_C25_60 := aAgente[3]
   AVGLTT->AVG_C26_60 := aAgente[4]
   //CC
   AVGLTT->AVG_C27_60 := cTO_CON1
   AVGLTT->AVG_C28_60 := cTO_CON2
   AVGLTT->AVG_C29_60 := cTO_CON3
   
   
   // Marcacao ...
   AVGLTT->AVG_C08_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),1)
   AVGLTT->AVG_C09_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),2)
   AVGLTT->AVG_C10_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),3)
   AVGLTT->AVG_C11_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),4)
   AVGLTT->AVG_C12_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),5)
   AVGLTT->AVG_C13_20 := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",3),6)
   
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   AVGLTT->AVG_C14_20 := Transf(EEC->EEC_PESLIQ,cPictPeso)+" "+EE9->EE9_UNIDAD
   AVGLTT->AVG_C15_20 := Transf(EEC->EEC_PESBRU,cPictPeso)+" "+EE9->EE9_UNIDAD
   AVGLTT->AVG_C16_20 := Transf(EEC->EEC_CUBAGE,AVSX3("EEC_CUBAGE",6))+" M3"
   
   AVGLTT->AVG_C21_60 := EEC->EEC_PACKAG
   
   AVGLTT->AVG_C01_10 := EEC->EEC_INCOTE
   //nFobValue := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN)
   AVGLTT->AVG_C17_20 := EEC->EEC_MOEDA+" "+Transf(EEC->EEC_TOTPED,AVSX3("EEC_TOTPED",6))
   AVGLTT->AVG_C18_20 := EEC->EEC_MOEDA+" "+Transf(EEC->EEC_FRPREV,AVSX3("EEC_FRPREV",6))
   
   IF EEC->EEC_FRPPCC == "CC"
      AVGLTT->AVG_C02_10 := "COLLECT"
   Else
      AVGLTT->AVG_C02_10 := "PREPAID"
   Endif
   
   AVGLTT->AVG_C19_20 := EEC->EEC_LC_NUM
   AVGLTT->AVG_C20_20 := EEC->EEC_LICIMP
   
   AVGLTT->AVG_C21_20 := Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_DESCR")
   
   // Grava Itens ...
   GravaItens()
  
   cSEQREL :=GETSX8NUM("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO)
   
   Exit
Enddo

IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cFileMen))
Endif

Work->(E_EraseArq(cFile))

RestOrd(aOrd)

__RETURN(lRet)

//----------------------------------------------------------------------
STATIC Function GravaItens

Local gi_w

gi_mDet := ""

EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
AVGLTT->AVG_C02_20 := Transf(EE9->EE9_RE,AVSX3("EE9_RE",6))
While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
      EE9->EE9_PREEMB == EEC->EEC_PREEMB
   SysRefresh()
   gi_mDet := gi_mDet+MARGEM+LTrim(Transf(EE9->EE9_PSLQTO,AVSX3("EE9_PSBRTO",6)))+" "+AllTrim(EE9->EE9_UNIDAD)+" "+MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3),1)+ENTER
   EE9->(dbSkip())
Enddo 

IF Select("Work_Men") > 0
   gi_mDet := gi_mDet+ENTER
   gi_mDet := gi_mDet+MARGEM+"Observacoes"+ENTER
   
   gi_nCol := 60
   Work_Men->(dbGoTop())
   
   While ! Work_Men->(Eof()) .And. Work_Men->WKORDEM < "zzzzz"
      gi_nTotLin:=MlCount(Work_Men->WKOBS,gi_nCol) 
      
      For gi_w := 1 To gi_nTotLin
         IF !Empty(MemoLine(Work_Men->WKOBS,gi_nCol,gi_w))
            gi_mDet := gi_mDet+MARGEM+MemoLine(Work_Men->WKOBS,gi_nCol,gi_w)+ENTER
         EndIf
      Next
      
      Work_Men->(dbSkip())
   Enddo
Endif

gi_mDet := gi_mDet+ENTER+ENTER
gi_mDet := gi_mDet+Space(50)+Replicate("-",Len(EEC->EEC_RESPON))+ENTER
gi_mDet := gi_mDet+Space(50)+EEC->EEC_RESPON+ENTER

AVGLTT->WK_DETALHE := gi_mDet

Return NIL

//----------------------------------------------------------------------
STATIC Function TelaGets
Local tg_i

tg_lRet := .f.
tg_nOpc := 0
tg_bOk  := tb_bCancel := nil

tg_aCampos := { {"WKMARCA",," "},;
                {{||if(AllTrim(Work->WKTIPO)=="A","Agente","Notify")},,"Tipo"},;
                {"WKCODIGO",,"Código"},;
                {"WKDESCR",,"Descrição"}}

aMarcados := Array(4)

// Notify
EEN->(dbSeek(xFilial()+EEC->EEC_PREEMB+OC_EM))

While EEN->(!Eof() .And. EEN_FILIAL == xFilial("EEN")) .And.;
    EEN->EEN_PROCES+EEN->EEN_OCORRE == EEC->EEC_PREEMB+OC_EM
    
   SysRefresh()
   
   Work->(dbAppend())
   Work->WKTIPO := "N"
   Work->WKCODIGO := EEN->EEN_IMPORT+EEN->EEN_IMLOJA
   Work->WKDESCR  := EEN->EEN_IMPODE
    
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
   
   Work->(dbAppend())
   Work->WKTIPO := "A"
   Work->WKCODIGO := EEB->EEB_CODAGE
   Work->WKDESCR := EEB->EEB_NOME
   
   EEB->(dbSkip())
Enddo   

Work->(dbGoTop())

While .t.

   tg_bOk     := {||tg_nOpc:=1,oSend(tg_oDlg,"End")}
   tg_bCancel := {||tg_nOpc:=0,oSend(tg_oDlg,"End")}

   tg_bInit := {|| EnchoiceBar(tg_oDlg,tg_bOk,tg_bCancel) }
       
      
   tg_oDLG := oSend( MSDialog(), "New", 9, 0, 28, 80,;
              "Instrução de Embarque",,,.F.,,,,,oMainWnd,.F.,,,.F.)
   
      tg_oFLD:=oSEND(TFolder(),"New",15,1,{"Contatos","Agentes"},;
               {"CON","AGE"},tg_oDLG,,,,.T.,.F.,314,130)
      
      tg_aFLDF:=oSEND(tg_oFLD,"aDIALOGS")
       tg_oFLDF:=tg_aFLDF[1] //CONTATOS
	   oSEND(tg_oFLD,"SetOption",1)
       //para encontrar a proxima linha, some 9. Ex.: 10+9=19
       oSEND(TSAY(),     "New",26,20,{|| "Contato 1 " },tg_oFLDF,,tg_oFLD:oFONT,,,,.T.,,,232,10)
       oSEND(TGET(),     "New",26,50,bSETGET(M->cCONTATO),tg_oFLDF,140,08,,{||cTO_CON1:=M->cCONTATO,.T.},,,tg_oFLDF:oFONT,,,.T.,,,{||M->cCONTATO:=cTO_CON1,.T.},,,,,,"E32")
       oSEND(TSAY(),     "New",42,20,{|| "Contato 2 " },tg_oFLDF,,tg_oFLD:oFONT,,,,.T.,,,232,10)
       oSEND(TGET(),     "New",42,50,bSETGET(M->cCONTATO),tg_oFLDF,140,08,,{||cTO_CON2:=M->cCONTATO,.T.},,,tg_oFLDF:oFONT,,,.T.,,,{||M->cCONTATO:=cTO_CON2,.T.},,,,,,"E32")
       oSEND(TSAY(),     "New",58,20,{|| "Contato 3 " },tg_oFLDF,,tg_oFLD:oFONT,,,,.T.,,,232,10)
       oSEND(TGET(),     "New",58,50,bSETGET(M->cCONTATO),tg_oFLDF,140,08,,{||cTO_CON3:=M->cCONTATO,.T.},,,tg_oFLDF:oFONT,,,.T.,,,{||M->cCONTATO:=cTO_CON3,.T.},,,,,,"E32")
	   
	   oSEND(tg_oFLD,"SetOption",2)
       oSEND(tg_oFLDF,"SetFont",oSEND(tg_oDlg,"oFont"))
       tg_oMark:=oSend(MsSelect(),"New","Work","WKMARCA",,tg_aCampos,@lInverte,@tg_cMarca,{14,1,110,315})
       E_MarkbAval(tg_oMark,{|| ChkMarca() })
       oSEND(tg_oFLD,"SetOption",1)
       
   oSend( tg_oDlg, "Activate",,,,.T.,,, tg_bInit )
   oSend( tg_oDlg, "Destroy" )
   
   IF tg_nOpc == 0
      Exit
   Endif
      
   tg_oDlg := oSend( MSDialog(), "New", 9, 0, 28, 80,;
              "Instrução de Embarque",,,.F.,,,,,oMainWnd,.F.,,,.F.)
      
    EECMensagem(EEC->EEC_IDIOMA,"4",{14,1,140,325})
      
   oSend( tg_oDlg, "Activate",,,,.T.,,, tg_bInit )
   oSend( tg_oDlg, "Destroy" )

   IF tg_nOpc == 1
      tg_lRet := .t.
   Endif 

   tg_n := 1
   For tg_i:=1 To 2
      IF !Empty(aMarcados[tg_i])
         tg_nTamLoj := AVSX3("EEN_IMLOJA",3)
         tg_cKey    := Subst(aMarcados[tg_i],2)
         tg_cLoja   := Right(tg_cKey,tg_nTamLoj) 
         tg_cImport := Subst(tg_cKey,1,Len(tg_cKey)-tg_nTamLoj)
         
         IF EEN->(dbSeek(xFilial()+AvKey(EEC->EEC_PREEMB,"EEN_PROCES")+OC_EM+AvKey(tg_cImport,"EEN_IMPORT")+AvKey(tg_cLoja,"EEN_IMLOJA")))
            aNotify[tg_n] := EEN->EEN_IMPODE
            aNotify[tg_n+1] := EEN->EEN_ENDIMP
            tg_n := tg_n +2
         Endif
      Endif
   Next

   tg_n := 1
   For tg_i:=3 To 4
      IF !Empty(aMarcados[tg_i])
         IF EEB->(dbSeek(xFilial()+AvKey(EEC->EEC_PREEMB,"EEB_PEDIDO")+OC_EM+AvKey(Subst(aMarcados[tg_i],2),"EEB_CODAGE")))
            aAgente[tg_n] := EEB->EEB_NOME
            SY5->(dbSeek(xFilial()+AvKey(Subst(aMarcados[tg_i],2),"Y5_COD")))
            aAgente[tg_n+1] := SY5->Y5_END
            tg_n := tg_n +2
         Endif
      Endif
   Next
   
   Exit
Enddo

Return tg_lRet

//----------------------------------------------------------------------
STATIC Function ChkMarca

// Parametros : cm_aMarcados
//              cm_oMark

While .T.
   IF !Empty(Work->WKMARCA) 
      // Desmarca
      cm_n := aScan(aMarcados,Work->WKTIPO+Work->WKCODIGO)
      IF cm_n > 0
         aMarcados[cm_n] := ""
      Endif
      
      Work->WKMARCA := Space(2)
   Else
      // Marca
      IF Work->WKTIPO == "N" // Notify
         IF !Empty(aMarcados[1]) .And. !Empty(aMarcados[2])
            MsgStop("Já existem dois notify's selecionados !","Aviso")
            Exit
         Endif
         
         IF Empty(aMarcados[1])
            aMarcados[1] := Work->WKTIPO+Work->WKCODIGO
         Else
            aMarcados[2] := Work->WKTIPO+Work->WKCODIGO
         Endif
      Else
         IF !Empty(aMarcados[3]) .And. !Empty(aMarcados[4])
            MsgStop("Já existem dois agentes selecionados !","Aviso")
            Exit
         Endif
         
         IF Empty(aMarcados[3])
            aMarcados[3] := Work->WKTIPO+Work->WKCODIGO
         Else
            aMarcados[4] := Work->WKTIPO+Work->WKCODIGO
         Endif
      Endif
      
      Work->WKMARCA := tg_cMarca
   Endif
   
   oSend(tg_oMark,"Refresh")
   SysRefresh()
   
   Exit
Enddo

Return NIL

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM23.PRW                                                 *
*------------------------------------------------------------------------------*

