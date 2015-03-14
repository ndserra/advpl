/*
Funcao: EICADICAO()
Autor.: Alex Wallauer
Data..: 12/09/2008
====================================================================
Chamada do EICDI500.PRW:
Case ParamIXB = "AROTINA"        
     nPos:=LEN(aRotina)+1
     AADD(aRotina,{"Adicoes","U_EICAdicao(.F.,"+STR(nPos,2)+",.F.)",0,4})
OU
Case ParamIXB = "BROWSE_SELECIONA"
     AADD(aBotaoItem,{"BMPINCLUIR",{|| U_EICAdicao(.F.,4,.T.)},"Adicoes"}) 
====================================================================
Chamada do aRotina:
nPos:=LEN(aRotina)+1
AADD(aRotina,{"Adicoes","U_EICAdicao(.F.,"+STR(nPos,2)+",.F.)",0,4})
====================================================================
Chamada do Menu:
			<MenuItem Status="Enable">
				<Title lang="pt">Adicoes</Title>
				<Title lang="es">Adicoes</Title>
				<Title lang="en">Adicoes</Title>
				<Function>U_EICADICAO</Function>
				<Type>1</Type>
				<Access>xxxxxxxxxx</Access>
				<Module>17</Module>
			</MenuItem>
====================================================================
*/
#include "FiveWin.ch"
*========================================================================================*
User Function EICAdicao(lMenu,nPos,lDI500)//AWR - 11/09/08 - NF-Eletronica
*========================================================================================*
LOCAL oDlg
LOCAL bOk    := {|| IF(NaoVazio(cProcesso) .AND. ExistCpo("SW6",cProcesso),(oDlg:End(),nOpcao:=1),) }
LOCAL bCancel:= {|| (oDlg:End(),nOpcao:=0) }

DEFAULT lDI500:= .F.
DEFAULT lMenu := .T.

IF SW8->(FIELDPOS("W8_SEQ_ADI")) = 0
   MSGINFO("Campos W8_SEQ_ADI nao existe, favor atualizar o dicionario","W8_SEQ_ADI, C, 3")
ENDIF

IF !lMenu
   AdicaoTela(nPos,lDI500)
   RETURN .T.
ENDIF
PRIVATE aRotina:= { { "Alterar","",0,4} }//Para o MSGETDB

cProcesso:=SPACE(LEN(SW6->W6_HAWB))
DO WHILE .T.

   nOpcao:=0

   DEFINE MSDIALOG oDlg FROM 0,0 TO 150,300 PIXEL TITLE "Digitacao das Adicoes"

     nLinha:=25

     @nLinha,005 SAY "Processo:" PIXEL
     @nLinha,035 MSGET cProcesso PIXEL F3 "SW6" SIZE 80,8
     

   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

   IF nOpcao = 1
      SW6->(DBSEEK(xFilial()+cProcesso))
      AdicaoTela(1)
      LOOP
   ENDIF

   EXIT

ENDDO

*========================================================================================*
Static Function AdicaoTela(nPos,lDI500)//AWR - 11/09/08 - NF-Eletronica
*========================================================================================*
LOCAL aBotoes:={},oDlg_wk,aSemSX3SW8,W
LOCAL bOk    := {|| IF(MSGYESNO("Confirma Gravacao ?","Total de adicoes apuradas : "+STR(nContaAdic,4)),(oDlg_wk:End(),nOpcAdi:=1),) }
LOCAL bCancel:= {|| IF(MSGYESNO("Confirma Saida ?"),(oDlg_wk:End(),nOpcAdi:=0),) }
Local aOrd // AST - 07/10/08
PRIVATE nContaAdic:=0
PRIVATE cMensagem:="ATENCAO! Existem itens sem Apropriacao de C.F.O."
PRIVATE lTemOperacao:=.T.
PRIVATE nOrderWorkItens:=1
Private oMark1
SW8->(DBSETORDER(1))
EIJ->(DBSETORDER(1))
IF lDI500        

   If Work_SW8->(RecCount()) == 0
      If !Inclui .And. SW8->(DBSEEK(xFilial()+M->W6_HAWB))
         DI500Existe()
      EndIf
      If Work_SW8->(RecCount()) == 0
         MSGINFO("Nao existe itens de invoices para esse Processo")
         RETURN .F.
      EndIf
   ENDIF

// bBar:= { || DI500EnchoiceBar(oDlg_wk,,,.F.,aBotoes) }  
   //FDR - 15/08/11
   bBar:= { || EnchoiceBar(oDlg_wk,{|| oDlg_wk:End()},{|| oDlg_wk:End()},,aBotoes) }
ELSE

   DBSELECTAREA("SW8")
   DBSETORDER(1)

   IF !SW8->(DBSEEK(xFilial()+SW6->W6_HAWB))
      MSGINFO("Nao existe itens de invoices para esse Processo")
      RETURN .F.
   ENDIF

   bBar:= { || EnchoiceBar(oDlg_wk,bOk,bCancel,,aBotoes) }

   //Essas variaveis ja existe no EICDI500.PRW
   lREGIPIW8:= SW8->(FIELDPOS("W8_REGIPI")) # 0
   lAUTPCDI := FindFunction("DI500AUTPCDI") .AND. DI500AUTPCDI()
   lTemNVE  := EIM->(FIELDPOS("EIM_CODIGO")) # 0 .AND.;
               SW8->(FIELDPOS("W8_NVE"))     # 0 .AND.;
               EIJ->(FIELDPOS("EIJ_NVE"))    # 0 .AND.;
               SIX->(dbSeek("EIM2"))
ENDIF

lTemRegTri:=SW8->(FIELDPOS("W8_REGTRI")#0 .AND. FIELDPOS("W8_FUNREG")#0 .AND.;
                  FIELDPOS("W8_MOTADI")#0 .AND. FIELDPOS("W8_TACOII")#0 .AND.;
                  FIELDPOS("W8_ACO_II")#0)

aSemSX3SW8:={}
AADD(aSemSX3SW8,{"WKINVOICE" ,"C",LEN(SW9->W9_INVOICE),0})
AADD(aSemSX3SW8,{"WKQTDE"    ,"N",AVSX3("W8_QTDE" ,3) ,AVSX3("W8_QTDE" ,4)})
AADD(aSemSX3SW8,{"WKPRECO"   ,"N",AVSX3("W8_PRECO",3) ,AVSX3("W8_PRECO",4)})
AADD(aSemSX3SW8,{"WKCOD_I"   ,"C",LEN(SW5->W5_COD_I)  ,0})
//JVR - 30/10/09
AADD(aSemSX3SW8,{"WKDESCITEM","C",AVSX3("B1_DESC"   ,3),0})
AADD(aSemSX3SW8,{"WKPART_N"  ,"C",AVSX3(IF(SX3->(FieldPos("W3_PART_N"))#0,"W3_PART_N","A5_CODPRF") ,3),0})
//
AADD(aSemSX3SW8,{"WKFABR"    ,"C",LEN(SW8->W8_FABR)   ,0})

IF EICLOJA()
   AADD(aSemSX3SW8,{"W8_FABLOJ"    ,"C",LEN(SW8->W8_FABLOJ)   ,0})
ENDIF

AADD(aSemSX3SW8,{"WKPO_NUM"  ,"C",LEN(SW8->W8_PO_NUM) ,0})
AADD(aSemSX3SW8,{"WKPGI_NUM" ,"C",LEN(SW8->W8_PGI_NUM),0})
AADD(aSemSX3SW8,{"WKSEQ_LI"  ,"C",LEN(SW8->W8_SEQ_LI) ,0})
AADD(aSemSX3SW8,{"WKFLUXO"   ,"C",LEN(SW8->W8_FLUXO)  ,0})
AADD(aSemSX3SW8,{"WKFORN"    ,"C",LEN(SW2->W2_FORN)   ,0})

IF EICLOJA()
   AADD(aSemSX3SW8,{"W8_FORLOJ"    ,"C",LEN(SW8->W8_FORLOJ)   ,0})
ENDIF

AADD(aSemSX3SW8,{"WKTEC"     ,"C",LEN(SW7->W7_NCM)    ,0}) 
AADD(aSemSX3SW8,{"WKEX_NCM"  ,"C",LEN(SW7->W7_EX_NCM) ,0}) 
AADD(aSemSX3SW8,{"WKEX_NBM"  ,"C",LEN(SW7->W7_EX_NBM) ,0})
AADD(aSemSX3SW8,{"WKREGIST"  ,"C",LEN(SWP->WP_REGIST) ,0})
AADD(aSemSX3SW8,{"WKPOSICAO" ,"C",LEN(SW3->W3_POSICAO),0})
AADD(aSemSX3SW8,{"WKRECNO"   ,"N",10,0})
AADD(aSemSX3SW8,{"WKOPERACA" ,"C",LEN(SW7->W7_OPERACA) ,0}) 
AADD(aSemSX3SW8,{"WKCOND_PA" ,"C",LEN(SW9->W9_COND_PA) ,0})
AADD(aSemSX3SW8,{"WKDIAS_PA" ,"N",AVSX3("W9_DIAS_PA",3),0})
AADD(aSemSX3SW8,{"WKADICAO"  ,"C",LEN(EIJ->EIJ_ADICAO) ,0})
AADD(aSemSX3SW8,{"WKMOEDA"   ,"C",LEN(SW9->W9_MOE_FOB) ,0})
AADD(aSemSX3SW8,{"WKINCOTER" ,"C",LEN(SW9->W9_INCOTER) ,0})
AADD(aSemSX3SW8,{"WKSEQ_ADI" ,"C",LEN(EIJ->EIJ_ADICAO) ,0})
AADD(aSemSX3SW8,{"WKREGTRI"  ,"C",01,0})
AADD(aSemSX3SW8,{"WKTACOII"  ,"C",01,0})
AADD(aSemSX3SW8,{"WKACO_II"  ,"C",03,0})
AADD(aSemSX3SW8,{"WKFUNREG"  ,"C",02,0})
AADD(aSemSX3SW8,{"WKMOTADI"  ,"C",02,0})
AADD(aSemSX3SW8,{"WKNVE"     ,"C",03,0})                                                     
IF lREGIPIW8
   AADD(aSemSX3SW8,{"WKREGIPI","C",LEN(SW8->W8_REGIPI),0})
ENDIF
IF lAUTPCDI
   AADD(aSemSX3SW8,{"WKREG_PC" ,"C",LEN(SW8->W8_REG_PC),0})
   AADD(aSemSX3SW8,{"WKFUN_PC" ,"C",LEN(SW8->W8_FUN_PC),0})
   AADD(aSemSX3SW8,{"WKFRB_PC" ,"C",LEN(SW8->W8_FRB_PC),0})
ENDIF
IF SW7->(FIELDPOS("W7_VLR_IPI")) > 0                                                       // NCF - 23/02/2011 - Adicionado o campo de Valor do IPI de Pauta 
   AADD(aSemSX3SW8,{"WKIPIPAUTA","N",AVSX3("W7_VLR_IPI",3),AVSX3("W7_VLR_IPI",4)})         //                    para permitir a quebra de adição por Vlr. IPI de Pauta
ENDIF                                                         
IF lDI500

   aOrd := SaveOrd("Work_SW8") // AST - 07/10/08
   cAliasItensSW8:="Work_SW8"

   DBSELECTAREA(cAliasItensSW8)
   SET FILTER TO

   Work_SW8->(DBSETORDER(3))
   cIndice:=Work_SW8->(INDEXKEY())
   aSemSX3:=aSemSX3SW8
   nOrderWorkItens:=3

ELSE

   cAliasItensSW8:="WorkItens_SW8"
   
   IF EICLOJA()
      cIndice:="WKREGIST+WKFORN+W8_FORLOJ+WKFABR+W8_FABLOJ+WKTEC+WKEX_NCM+WKEX_NBM+WKCOND_PA+STR(WKDIAS_PA,3,0)+WKMOEDA+WKINCOTER"+;
            "+WKREGTRI+WKFUNREG+WKMOTADI+WKTACOII+WKACO_II"+;
            IF(lREGIPIW8,"+WKREGIPI","")+"+WKOPERACA"+;
            IF(lTemNVE,"+WKNVE","")+;
            IF(lAUTPCDI,"+WKREG_PC+WKFUN_PC+WKFRB_PC","")+;
            "+STR(WKIPIPAUTA,15,5)"                           // NCF - 23/02/2011- Adicionado Valor do IPI de Pauta para permitir a quebra de adição
   
   ELSE
   
      cIndice:="WKREGIST+WKFORN+WKFABR+WKTEC+WKEX_NCM+WKEX_NBM+WKCOND_PA+STR(WKDIAS_PA,3,0)+WKMOEDA+WKINCOTER"+;
            "+WKREGTRI+WKFUNREG+WKMOTADI+WKTACOII+WKACO_II"+;
            IF(lREGIPIW8,"+WKREGIPI","")+"+WKOPERACA"+;
            IF(lTemNVE,"+WKNVE","")+;
            IF(lAUTPCDI,"+WKREG_PC+WKFUN_PC+WKFRB_PC","")+;
            "+STR(WKIPIPAUTA,15,5)"                           // NCF - 23/02/2011- Adicionado Valor do IPI de Pauta para permitir a quebra de adição   
   ENDIF

   aCampos:={}
   aHeader:={}
   cFileWk2:=E_CriaTrab(,aSemSX3SW8,cAliasItensSW8,,)
   
   IndRegua(cAliasItensSW8,cFileWk2+OrdBagExt(),cIndice)

   aSemSX3:=(cAliasItensSW8)->(DBSTRUCT())
   nOrderWorkItens:=1
   
ENDIF

aCampos:={}
aHeader:={}
cIndice:=(cAliasItensSW8)->(INDEXKEY())

cFileWkCapa:=E_CriaTrab(,aSemSX3,"WorkCap_SW8",,)

IndRegua("WorkCap_SW8",cFileWkCapa+OrdBagExt(),cIndice)

aCamposSW8:={}
AADD(aCamposSW8,{"WKADICAO"  ,AVSX3("W8_ADICAO" ,5),"999","C"})
AADD(aCamposSW8,{"WKSEQ_ADI" ,"Seq. Adicao"        ,"999","C"})

AADD(aCamposSW8,{"WKPO_NUM"  ,AVSX3("W8_PO_NUM" ,5),"","D"})
AADD(aCamposSW8,{"WKPOSICAO" ,AVSX3("W8_POSICAO",5),"","D"})
AADD(aCamposSW8,{"WKCOD_I"   ,AVSX3("W8_COD_I"  ,5),"","D"})    
//JVR - 30/10/09
AADD(aCamposSW8,{"WKDESCITEM",AVSX3("B1_DESC"   ,5),"","D"})
AADD(aCamposSW8,{"WKPART_N"  ,AVSX3(IF(SX3->(FieldPos("W3_PART_N"))#0,"W3_PART_N","A5_CODPRF") ,5),"","D"})
AADD(aCamposSW8,{"WKQTDE"    ,AVSX3("W8_QTDE",5),AVSX3("W8_QTDE" ,6),"N"})
//
AADD(aCamposSW8,{"WKPGI_NUM" ,AVSX3("W5_PGI_NUM",5),AVSX3("W5_PGI_NUM",6),"D"})
AADD(aCamposSW8,{"WKINVOICE" ,AVSX3('W9_INVOICE',5),"","D"})

AADD(aCamposSW8,{"WKREGIST"  ,AVSX3("WP_REGIST" ,5),AVSX3("WP_REGIST" ,6),"C"})
AADD(aCamposSW8,{"WKFORN"    ,AVSX3("W7_FORN"   ,5),"","C"})
IF EICLOJA()
   AADD(aCamposSW8,{"W8_FORLOJ"    ,AVSX3("W8_FORLOJ"   ,5),"","C"})
ENDIF
AADD(aCamposSW8,{"WKFABR"    ,AVSX3("W8_FABR"   ,5),"","C"})
IF EICLOJA()
   AADD(aCamposSW8,{"W8_FABLOJ"    ,AVSX3("W8_FABLOJ"   ,5),"","C"})
ENDIF
AADD(aCamposSW8,{"WKTEC"     ,AVSX3("W8_TEC"    ,5),"","C"})
AADD(aCamposSW8,{"WKEX_NCM"  ,AVSX3("W7_EX_NCM" ,5),"","C"})
AADD(aCamposSW8,{"WKEX_NBM"  ,AVSX3("W7_EX_NBM" ,5),"","C"})
AADD(aCamposSW8,{"WKCOND_PA" ,AVSX3("W9_COND_PA",5),"","C"})
AADD(aCamposSW8,{"WKDIAS_PA" ,AVSX3("W9_DIAS_PA",5),"","C"})
AADD(aCamposSW8,{"WKMOEDA"   ,AVSX3("W9_MOE_FOB",5),"","C"})
AADD(aCamposSW8,{"WKINCOTER" ,AVSX3("W9_INCOTER",5),"","C"})
AADD(aCamposSW8,{"WKREGTRI"  ,AVSX3("EIJ_REGTRI",5),"","C"})
AADD(aCamposSW8,{"WKFUNREG"  ,AVSX3("EIJ_FUNREG",5),"","C"})
AADD(aCamposSW8,{"WKMOTADI"  ,AVSX3("EIJ_MOTADI",5),"","C"})
AADD(aCamposSW8,{"WKTACOII"  ,AVSX3("EIJ_TACOII",5),"","C"})
AADD(aCamposSW8,{"WKACO_II"  ,AVSX3("EIJ_ACO_II",5),"","C"})
IF lREGIPIW8
   AADD(aSemSX3SW8,{"WKREGIPI",AVSX3("W8_REGIPI",5),"","C"})
ENDIF   
IF lTemNVE
   AADD(aCamposSW8,{"WKNVE",AVSX3("W8_NVE",5),"","C"})
ENDIF
AADD(aCamposSW8,{"WKOPERACA","Operacao","","C"})
IF lAUTPCDI
   AADD(aCamposSW8,{"WKREG_PC",AVSX3("W8_REG_PC",5),AVSX3("W8_REG_PC",6),"C"})
   AADD(aCamposSW8,{"WKFUN_PC",AVSX3("W8_FUN_PC",5),AVSX3("W8_FUN_PC",6),"C"})
   AADD(aCamposSW8,{"WKFRB_PC",AVSX3("W8_FRB_PC",5),AVSX3("W8_FRB_PC",6),"C"})
ENDIF
AADD(aCamposSW8,{"WKIPIPAUTA","Vl.IPI.Pauta","@E 999,999,999.99999","C"})       // NCF - 23/02/2011- Visualizar o Valor do IPI de Pauta para permitir a quebra de adição
AADD(aCamposSW8,{"WKRECNO","Registro","","C"})
aHeader    :={}
aHeaderCapa:={}
aHeaderDet :={}
Private aColsSW8   :={}
FOR W := 1 TO LEN(aCamposSW8)
    IF (S:=ASCAN(aSemSX3,{|SX| SX[1] == aCamposSW8[W,1] } )) = 0
       LOOP
    ENDIF
    IF aCamposSW8[W,4] = "C"
      If !aCamposSW8[W,1] == "WKSEQ_ADI" // AST - 08/10/08 - Retira o campo Seq. Adição do browse da capa das adições
          AADD(aHeaderCapa,{aCamposSW8[W,2] ,aCamposSW8[W,1],aCamposSW8[W,3],aSemSX3[S,3],aSemSX3[S,4],""       ,""      ,aSemSX3[S,2],""        ,""} )//Capa
      EndIf   
    ENDIF
    AADD(aHeaderDet    ,{aCamposSW8[W,2] ,aCamposSW8[W,1],aCamposSW8[W,3],aSemSX3[S,3],aSemSX3[S,4],""       ,""      ,aSemSX3[S,2],""        ,""} )//Detalhe
  //AADD(aHeader       ,{     X3Titulo() ,x3_Campo       ,x3_picture     ,x3_tamanho  ,x3_decimal  ,x3_valid ,x3_usado,x3_tipo     ,x3_arquivo,x3_context}))
NEXT

IF !lDI500
   Processa( {|| AdicaoInvCarrega() } )
   oMainWnd:ReadClientCoors()
ENDIF

Processa( {|| AdicaoWorkGrv(.F.,.F.) } )

(cAliasItensSW8)->(DBSETORDER(0))
(cAliasItensSW8)->(DBGOTOP())
WorkCap_SW8->(DBSETORDER(0))
WorkCap_SW8->(DBGOTOP())

aBotoes:={}
If nOpcAdiVis <> 2
   AADD(aBotoes,{"BMPINCLUIR",{|| oDlg_wk:End(), nOpcAdi:=2                },"Gera Adicoes" ,"Gera" })
   AADD(aBotoes,{"EXCLUIR"   ,{|| Processa( {|| AdicaoWorkGrv(.F.,.T.) } ) },"Limpa Adicoes","Limpa"})
Endif

IF lDI500
   AADD(aBotoes,{"PREV",{|| oDlg_wk:End()},"Tela Anterior","Anterior"})
ENDIF

DO WHILE .T.
   nOpcAdi:=0
   DEFINE MSDIALOG oDlg_wk TITLE "Digitacao das Adicoes "+IF(!lTemOperacao," - "+cMensagem,"") ;
          FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 ;
          TO oMainWnd:nBottom-60,oMainWnd:nRight - 10 OF oMainWnd PIXEL

     nLinha:=1
     nTam:=90

     @000000,001 MSPANEL oPanItem Prompt Size 120,120 of oDlg_wk

     @nLinha,005 SAY ("ADICOES ( Capa ) : "+STR(nContaAdic,4)) PIXEL of oPanItem
     nLinha+=10

     DBSELECTAREA("WorkCap_SW8")
     aHeader:=ACLONE(aHeaderCapa)
     oMark1:=MsNewGetDados():New(nLinha,001  ,(nLinha+nTam),(oDlg_WK:nClientWidth-4)/2,2     ,        ,       ,   ""     ,If(nOpcAdiVis <> 2,{"WKADICAO"},{}),       ,9000,"U_AdicaoGrvAdicao()",         ,       ,oPanItem,aHeaderCapa,aColsSW8)
//                           New(nTop  ,nLeft,nBottom      ,nRight                    ,nStyle,uLinhaOk,uTudoOk,cIniCpos,aAlter      ,nFreeze,nMax,cFieldOk             ,uSuperDel,uDelOk ,oWnd    ,aParHeader         ,aParCols        ,uChange)
     aColsSW8 := oMark1:aCols
     oMark1:oBrowse:bAdd   := {||.F.}     
     oMark1:oBrowse:bDelete:= {||.F.}
         
     nLinha+=nTam+15

     @(nLinha-10),005 SAY ("ITENS DAS ADICOES ( Detalhe ) : "+STR((cAliasItensSW8)->(LASTREC()),5)) PIXEL of oPanItem

     DBSELECTAREA(cAliasItensSW8)
     aHeader:=ACLONE(aHeaderDet)
     aRotina := MenuDef()   // GFP - 03/05/2013
     oMark2:=MsGetDB():New(nLinha,001,(oDlg_WK:nClientHeight-6)/2+If(SetMDIChild(),65,10),(oDlg_WK:nClientWidth-4)/2,nPos,"Allwaystrue","","",.F.,If(nOpcAdiVis <> 2,{"WKADICAO","WKSEQ_ADI"},{}),,.T.,,cAliasItensSW8,"U_ValMark2()",,.T.,oDlg_wk,.F.,,"Allwaystrue")
     oMark2:oBrowse:bAdd   := {||.F.}     
     oMark2:oBrowse:bDelete:= {||.F.}

     oPanItem:Align      := CONTROL_ALIGN_RIGHT
     oPanItem:Align      := CONTROL_ALIGN_TOP
//     oMark2:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT
     oDlg_wk:lMaximized  :=.T.

   ACTIVATE MSDIALOG oDlg_wk ON INIT (EVAL(bBar))//,oMark2:oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT,oMark2:oBrowse:Refresh()

   IF nOpcAdi = 2

      Processa( {|| AdicaoWorkGrv(.T.,.F.) } ) //"Gera Adicoes"
      LOOP

   ENDIF

   IF nOpcAdi = 1 .AND. !lDI500

      Processa( {|| AdicaoGrvInv() } ) //"Grava Adicoes"
   
   ENDIF
   
   If lDi500
      AdicaoLimpaOperaca()
   EndIf
   
   EXIT

ENDDO

WorkCap_SW8->((E_EraseArq(cFileWkCapa)))
IF !lDI500
   (cAliasItensSW8)->((E_EraseArq(cFileWk2)))   
Else
   RestOrd(aOrd) // AST - 07/10/08
ENDIF

Return .T.

*===============================*
User Function AdicaoGrvAdicao()//AWR - 11/09/08 - NF-Eletronica
*================================*
IF ALIAS() = cAliasItensSW8
   Return .T.
ENDIF

// AST
If readVar() == "M->WKADICAO"
   If val(M->WKADICAO) > len(aColsSW8)
      Alert("Nº de adição informado maior que o nº de adições.")   
      Return .F.
          //verifica se já existe o registro no vetor               e   se existir verifica se o usuário não digitou o nº que já estava (não houve alteração)
   ElseIf !Empty(M->WKADICAO) .And. aScan(aColsSW8,{|x| val(x[1]) == val(M->WKADICAO)}) > 0 .And. aScan(aColsSW8,{|x| val(x[1]) == val(M->WKADICAO)}) <> oMark1:nAt
      Alert("Nº de adição informado já existe.")
      Return .F.
   EndIf
   aColsSW8[N][1] := M->WKADICAO //Atualiza o vetor
EndIf


(cAliasItensSW8)->(DBSETORDER(nOrderWorkItens))

nRecno:=oMark1:oBrowse:OMOTHER:ACOLS[N][ LEN( aColsSW8[1] )-1 ]//a Variavel "n" é a linha da posicionada na tela

WorkCap_SW8->(DBGOTO( nRecno ))

IF (cAliasItensSW8)->(DBSEEK( WorkCap_SW8->(&(cIndice) ) ))

   nContaItem:=0
   DO WHILE (cAliasItensSW8)->(!EOF()) .AND. (cAliasItensSW8)->(&(cIndice))  == WorkCap_SW8->(&(cIndice))
   
      nContaItem++
      (cAliasItensSW8)->WKADICAO :=M->WKADICAO
      (cAliasItensSW8)->WKSEQ_ADI:=STRZERO(nContaItem,3)

      (cAliasItensSW8)->(DBSKIP())
   ENDDO
 //  WorkCap_SW8->WKSEQ_ADI:=STRZERO(nContaItem,3)
 //  oMark1:oBrowse:OMOTHER:ACOLS[N][2] := WorkCap_SW8->WKSEQ_ADI
ENDIF

(cAliasItensSW8)->(DBSETORDER(0))
(cAliasItensSW8)->(DBGOTOP())
aHeader:=ACLONE(aHeaderCapa)
oMark1:oBrowse:Refresh()
aHeader:=ACLONE(aHeaderDet)
oMark2:oBrowse:Refresh()

Return .T.
*=======================================================*
Static Function AdicaoWorkGrv(lAutomatico,lLimpa)//AWR - 11/09/08 - NF-Eletronica
*=======================================================*
LOCAL W
Local lIsAllEmpty := isAllEmpty()
LOCAL lNaoSeekou:= .F.
LOCAL nRecnoCap:= 0  

DbSelectArea('SW8')
nTot:=(cAliasItensSW8)->(LASTREC())
ProcRegua(nTot)
cTot:=STR(nTot)
WorkCap_SW8->(DBSETORDER(1))
nCount:=0
nContaItem:=0
IF !lLimpa
   nContaAdic:=0
   aColsSW8:={}
   WorkCap_SW8->(__DBZAP())  
   
   (cAliasItensSW8)->(DBSETORDER(1))
   (cAliasItensSW8)->(DBGOTOP())
   AdicaoChkOper(nCount, cTot)
ENDIF             

(cAliasItensSW8)->(DBSETORDER(nOrderWorkItens))
(cAliasItensSW8)->(DBGOTOP())

DO WHILE (cAliasItensSW8)->(!EOF())
   nCount++
   IncProc("Lendo: "+STR(nCount)+" / "+cTot)

   nRecnoCap := WorkCap_SW8->(Recno())
   
   If SW3->(FieldPos("W3_PART_N")) # 0
      SW3->(DBSetOrder(8))
      SW3->(DbSeek(xFilial("SW3") + (cAliasItensSW8)->WKPO_NUM + (cAliasItensSW8)->WKPOSICAO))   
      If !Empty(SW3->W3_PART_N)
         //WorkCap_SW8->WKPART_N:= SW3->W3_PART_N
         If Work_SW8->(FIELDPOS("WKPART_N")) > 0 
            Work_SW8->WKPART_N:= SW3->W3_PART_N
         EndIf
      Else                        
         //WorkCap_SW8->WKPART_N := SA5->(BuscaPart_N())
         If Work_SW8->(FIELDPOS("WKPART_N")) > 0 
            Work_SW8->WKPART_N := SA5->(BuscaPart_N())
         EndIf         
      EndIf
   Else                        
      //WorkCap_SW8->WKPART_N := SA5->(BuscaPart_N())
      If Work_SW8->(FIELDPOS("WKPART_N")) > 0 
         Work_SW8->WKPART_N := SA5->(BuscaPart_N())
      EndIf         
   EndIf
   
   IF !lLimpa .And. (lNaoSeekou:= !WorkCap_SW8->(DBSEEK( (cAliasItensSW8)->(&(cIndice) ) )) .or. nContaItem >= GetMv("MV_NR_ISUF",,80))
      nContaAdic++
      WorkCap_SW8->(DBAppend())
      AVREPLACE(cAliasItensSW8,"WorkCap_SW8")
      //JVR - 30/10/2009
      RecLock(cAliasItensSW8,.F.)
      //
      If lIsAllEmpty 
         WorkCap_SW8->WKADICAO :=STRZERO(nContaAdic,3)
      EndIf   
      aCpos:={}
      FOR W := 1 TO len(aCamposSW8)-1
          IF aCamposSW8[W,4] = "C"
             If !aCamposSW8[W,1] == "WKSEQ_ADI"
                AADD(aCpos,WorkCap_SW8->(FIELDGET( FIELDPOS(aCamposSW8[W,1]) )))
             EndIf   
          ENDIF
      NEXT   
      AADD(aCpos, WorkCap_SW8->(RECNO()) )
      AADD(aCpos,.F.)
      AADD(aColsSW8,aClone(aCpos))
      nContaItem:=0
 
   
   ENDIF
   
   //TRP - 09/02/2012 - Tratamento para os casos em que a quebra das adições respeita apenas o parâmetro MV_NR_ISUF (todo o restante da chave de quebra é igual).
   IF !lNaoSeekou 
      WorkCap_SW8->(DbGoto(nRecnoCap))
   Endif
   
   nContaItem++
   IF lAutomatico
      (cAliasItensSW8)->WKADICAO :=WorkCap_SW8->WKADICAO
      (cAliasItensSW8)->WKSEQ_ADI:=STRZERO(nContaItem,3)
   ELSEIF lLimpa
      (cAliasItensSW8)->WKADICAO :=""
      (cAliasItensSW8)->WKSEQ_ADI:=""
      WorkCap_SW8->WKADICAO :="000"
      //SVG - 21/10/2009 -
      //If (cAliasItensSW8)->(FIELDPOS("WKGRUPORT")) > 0 .AND. !EIJ->(DBSeek(xFilial("EIJ")+M->W6_HAWB+(cAliasItensSW8)->WKGRUPORT))
         //(cAliasItensSW8)->WKOPERACA :=""
      //EndIf
   ENDIF
   
//   WorkCap_SW8->WKSEQ_ADI   :=STRZERO(nContaItem,3)
//   aColsSW8[LEN(aColsSW8),2]:=WorkCap_SW8->WKSEQ_ADI

   (cAliasItensSW8)->(DBSKIP())
ENDDO

If lLimpa
   For W := 1 to Len(aColsSW8)
      aColsSW8[W][1] := SPACE(LEN(WorkCap_SW8->WKADICAO))
   Next                               
   WorkCap_SW8->(dbGoTop())
   While WorkCap_SW8->(!EOF())
      WorkCap_SW8->WKADICAO := ""
      WorkCap_SW8->(dbSkip())
   EndDo   
   
   oMark1:oBrowse:Refresh()                     
EndIf


(cAliasItensSW8)->(DBSETORDER(0))
(cAliasItensSW8)->(DBGOTOP())
WorkCap_SW8->(DBSETORDER(0))
WorkCap_SW8->(DBGOTOP())             


RETURN .T.

*----------------------------------------*
STATIC FUNCTION AdicaoChkOper(nCount,cTot)
*----------------------------------------*
LOCAL cFilSW7:=xFilial("SW7")
LOCAL cFilEIJ:=xFilial("EIJ")


DO WHILE (cAliasItensSW8)->(!EOF())
   nCount++
   IncProc("Checando Operação de CFO: "+STR(nCount)+" / "+cTot)
   
   IF EMPTY((cAliasItensSW8)->WKOPERACA) .AND. (cAliasItensSW8)->(FIELDPOS("WKGRUPORT")) > 0 //.AND. !EIJ->(DBSeek(cFilEIJ+M->W6_HAWB+(cAliasItensSW8)->WKGRUPORT))
      IF SW7->(DBSEEK(cFilSW7+M->W6_HAWB+(cAliasItensSW8)->(WKPO_NUM+WKPOSICAO+WKPGI_NUM)))  // NCF- 18/05/2010 - Nopado porque este seek faz com que a nota não efetue
         (cAliasItensSW8)->WKOPERACA:= SW7->W7_OPERACA                                       //                   a quebra de CFO por Operação quando o CFO é apropriado
      ENDIF                                                                                  //                   pela rotina de Apropriação de CFO.
   ENDIF

   (cAliasItensSW8)->(DBSKIP())
ENDDO
RETURN NIL


*------------------------------------*
STATIC FUNCTION AdicaoInvCarrega()
*-----------------------------------*
LOCAL cFilSW7:=xFilial("SW7")
LOCAL cFilSW8:=xFilial("SW8")
LOCAL cFilSW9:=xFilial("SW9")
LOCAL cFilSWP:=xFilial("SWP")
LOCAL cFilEIJ:=xFilial("EIJ")
lTemOperacao:=.T.
nCont:=0
ProcRegua(10)
  
SW7->(DBSETORDER(4))
SWP->(DBSETORDER(1))
SW8->(DBSETORDER(1))//W8_FILIAL+W8_HAWB+W8_INVOICE+W8_FORN
SW8->(DBSEEK(xFilial()+SW6->W6_HAWB))

SW9->(DBSETORDER(3))
SW9->(DBSEEK(xFilial()+SW6->W6_HAWB))
DO WHILE SW9->(!EOF()) .AND.;
         SW9->W9_HAWB   == SW6->W6_HAWB .AND.;
         SW9->W9_FILIAL == cFILSW9

   SW8->(DBSEEK(xFilial()+SW6->W6_HAWB+SW9->W9_INVOICE+SW9->W9_FORN+EICRetLoja("SW9","W9_FORLOJ")))

   DO WHILE SW8->(!EOF()) .AND.;
            SW8->W8_FILIAL  == cFILSW8 .AND.;
            SW8->W8_HAWB    == SW6->W6_HAWB .AND.;
            SW8->W8_INVOICE == SW9->W9_INVOICE .AND.;
            SW8->W8_FORN    == SW9->W9_FORN  .AND.;
            (!EICLOJA() .OR. SW8->W8_FORLOJ    == SW9->W9_FORLOJ)

      IF nCont > 10
         ProcRegua(10)
         nCont:=0
      ENDIF
      nCont++
      IncProc("Lendo Item: "+ALLTRIM(SW8->W8_COD_I))

      (cAliasItensSW8)->(DBAPPEND())
      AdicaoGrvWkSW8(.F.)

      IF EMPTY((cAliasItensSW8)->WKOPERACA) .AND. SW7->(DBSEEK(cFilSW7+SW8->W8_HAWB+SW8->W8_PO_NUM+SW8->W8_POSICAO+SW8->W8_PGI_NUM))
         (cAliasItensSW8)->WKOPERACA:= SW7->W7_OPERACA
      ENDIF

      IF SWP->(DBSEEK(cFilSWP+SW8->W8_PGI_NUM+SW8->W8_SEQ_LI))
         (cAliasItensSW8)->WKREGIST := SWP->WP_REGIST
      ENDIF

      (cAliasItensSW8)->WKCOND_PA :=SW9->W9_COND_PA
      (cAliasItensSW8)->WKDIAS_PA :=SW9->W9_DIAS_PA
      (cAliasItensSW8)->WKMOEDA   :=SW9->W9_MOE_FOB
      (cAliasItensSW8)->WKINCOTER :=SW9->W9_INCOTER
      (cAliasItensSW8)->WKRECNO   :=SW8->(RECNO())
      IF !lTemRegTri
         IF EIJ->(DBSEEK(cFilEIJ+SW8->W8_HAWB+SW8->W8_ADICAO))
            (cAliasItensSW8)->WKREGTRI:=EIJ->EIJ_REGTRI
            (cAliasItensSW8)->WKFUNREG:=EIJ->EIJ_FUNREG
            (cAliasItensSW8)->WKMOTADI:=EIJ->EIJ_MOTADI
            (cAliasItensSW8)->WKTACOII:=EIJ->EIJ_TACOII
            (cAliasItensSW8)->WKACO_II:=EIJ->EIJ_ACO_II
         ENDIF
      ENDIF
      IF EMPTY((cAliasItensSW8)->WKOPERACA)
         lTemOperacao:=.F.
      ENDIF
      SW8->(DBSKIP())

   ENDDO
   SW9->(DBSKIP())

ENDDO
SW7->(DBSETORDER(1))
IF !lTemOperacao
   MSGINFO(cMensagem)
ENDIF
RETURN .T.

*------------------------------------*
STATIC FUNCTION AdicaoGrvInv()
*-----------------------------------*
LOCAL aAdicoes:={}

nQuanTot:=0
nTotalItem:=(cAliasItensSW8)->(LASTREC())
ProcRegua(nTotalItem)

(cAliasItensSW8)->(dbGoTop())
DO WHILE !(cAliasItensSW8)->(EOF())

   nQuanTot++
   IncProc("Gravando: "+STR(nQuanTot,10)+" / "+STR(nTotalItem,10))

   IF !EMPTY((cAliasItensSW8)->WKRECNO)
      IF ASCAN(aAdicoes,(cAliasItensSW8)->WKADICAO) = 0
         AADD(aAdicoes,(cAliasItensSW8)->WKADICAO)
      ENDIF
      SW8->(DBGOTO((cAliasItensSW8)->WKRECNO))
      SW8->(RecLock("SW8",.F.))
      AdicaoGrvWkSW8(.T.)
      SW8->(MSUNLOCK())
   ENDIF
   
   (cAliasItensSW8)->(DBSKIP())

ENDDO
SW6->(RecLock("SW6",.F.))
SW6->W6_QTD_ADI := LEN(aAdicoes)
SW6->(MSUNLOCK())

RETURN .T.

*------------------------------------------------------------------------------*
STATIC FUNCTION AdicaoGrvWkSW8(lGrava)
*------------------------------------------------------------------------------*
LOCAL cFieldSW8,cFieldWk,bFieldWk,bFieldSW8,I

For I:=1 To SW8->(FCOUNT())
   
   cFieldSW8:=SW8->(FieldName(i))
   cFieldWk :='WK'+SUBSTR(cFieldSW8,4)
   IF (cAliasItensSW8)->(FieldPos(cFieldWk)) == 0
      Loop
   Else
      //bFieldWk = {|Valor|IF(Valor==NIL,Work_SW8->WK???????,Work_SW8->WK???????:=Valor)}
      bFieldWk:=FieldWBlock(cFieldWk,Select(cAliasItensSW8))
   Endif
   //bFieldSW8 = {|Valor|IF(Valor==NIL,SW8->W8_???????,SW8->W8_???????:=Valor)}
   bFieldSW8:=FieldWBlock(cFieldSW8,Select("SW8"))

   IF lGrava
      Eval(bFieldSW8,Eval(bFieldWk))
   ELSE
      Eval(bFieldWK,Eval(bFieldSW8))
   ENDIF
Next

RETURN .T.

/*------------------------------------------------------------------------------------
Funcao      : ValMark2
Parametros  : 
Retorno     : Valor lógico, .T. para valição aceita e .F. para validação rejeitada
Objetivos   : Validar os campos WKADICAO e WKSEQ_ADI do objeto oMark2
Autor       : Anderson Soares Toledo
Data/Hora   : 08/10/2008 - 11h30
Revisao     :
Obs.        :
*------------------------------------------------------------------------------------*/

User Function ValMark2()
local lRet := .T.  
local nMaxSeq := 0
local cAdicao := "" 

   If readVar() == "M->WKADICAO"
      If val(M->WKADICAO) > (cAliasItensSW8)->(RecCount())
         Alert("Nº de Adição não pode ser maior que nº de itens da adição.")   
         lRet := .F.
      EndIf

   ElseIf readVar() == "M->WKSEQ_ADI"
      //posiciona a work no registro que está sendo editado
      (cAliasItensSW8)->(dbGoTo(oMark2:oBrowse:nAt))
      //armazena a adição do registro atual
      cAdicao := (cAliasItensSW8)->(WKADICAO) 
      (cAliasItensSW8)->(dbGoTop())
      
      //verifica quantas quebras existe com a adição original
      While (cAliasItensSW8)->(!EOF())
         if (cAliasItensSW8)->WKADICAO == cAdicao
            nMaxSeq++
         EndIf        
         (cAliasItensSW8)->(dbSkip())
      EndDo     
      
      //verifica se a sequencia informada é maior que o nº de adições
      if val(M->WKSEQ_ADI) > nMaxSeq
         Alert("Sequência informada maior que o nº de quebras da adição.")
         lRet := .F.
      EndIf
      
      //retorna a work para a posição original
      (cAliasItensSW8)->(dbGoTo(oMark2:oBrowse:nAt))      
   EndIF

return lRet

Static Function isAllEmpty()
   Local lRet := .T.           
   Local aOrd              
              
   aOrd := SaveOrd(cAliasItensSW8)

   (cAliasItensSW8)->(dbGoTop())
   
   While (cAliasItensSW8)->(!EOF())
      If !Empty((cAliasItensSW8)->WKADICAO)
         lRet := .F.
         exit
      EndIf              
      (cAliasItensSW8)->(DbSkip())
   EndDo

   RestOrd(aOrd,.T.)

return lRet

Static Function AdicaoLimpaOperaca()
Local nRecno := (cAliasItensSW8)->(Recno())

   (cAliasItensSW8)->(DbGoTop())
   While (cAliasItensSW8)->(!Eof())
      If Empty((cAliasItensSW8)->WKADICAO) .And. Empty((cAliasItensSW8)->WKSEQ_ADI)
         If (cAliasItensSW8)->(FIELDPOS("WKGRUPORT")) == 0 .Or. !EIJ->(DBSeek(xFilial("EIJ")+M->W6_HAWB+(cAliasItensSW8)->WKGRUPORT))
            (cAliasItensSW8)->WKOPERACA :=""
         EndIf
      EndIf
      (cAliasItensSW8)->(DbSkip())
   EndDo

(cAliasItensSW8)->(DbGoTo(nRecno))
Return Nil
