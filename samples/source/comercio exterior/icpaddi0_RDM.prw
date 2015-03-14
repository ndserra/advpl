//Funcao    : ICPADDI0 
//Autor     : AVERAGE-Alex Wallauer
//Data      : 19/03/2001
//Descricao : Recebimento de Importacao com alteracoes para o MECOSUL
//Uso       : SIGAEIC Integrado com MICROSIGA
#include "rwmake.ch"
#INCLUDE "EICDI154.CH"
#INCLUDE "AVERAGE.CH"
#DEFINE  NFE_PRIMEIRA  1
#DEFINE  NFE_COMPLEMEN 2
#DEFINE  NFE_UNICA     3
#DEFINE  CUSTO_REAL    4
*--------------------------------------------------------------------------------------*
User Function ICPADDI0()
*--------------------------------------------------------------------------------------*
STATIC cFile, aValores, nTotImpostos, Work1FileE, Work1FileF, aTotalForn
LOCAL I
LOCAL cCampo:=""
LOCAL Imp:=0, E:=0//ASR 18/100/2005

cExecute := ""
IF TYPE("ParamIXB") == "C"
   cExecute := ParamIXB
ENDIF

IF cPaisLoc == "BRA"
   IF cExecute == "BOTAO"
      If Type("oDlgPrv") == "O"
         @ 004,055 BUTTON STR0259 SIZE 35,11 ACTION (IF(DIGerou(),Processa({|| DI154PRETXT()},STR0031),)) PIXEL // EXPORTA
      Else
         @ 1.5,040 BUTTON STR0259 SIZE 37,11 ACTION (IF(DIGerou(),Processa({|| DI154PRETXT()},STR0031),)) PIXEL // EXPORTA
      EndIf
      nOpca:=0
   ENDIF
   RETURN .T.
ENDIF

SX3->(DBSETORDER(2))
SX6->(DBSETORDER(1))
SX1->(DBSETORDER(1))            
IF cPaisLoc == "CHI"
   IF(!SX3->(DBSEEK("W6_PER_JUR")),cCampo+=" W6_PER_JUR",) 
   IF(!SX3->(DBSEEK("W6_DIA_JUR")),cCampo+=" W6_DIA_JUR",) 
   IF(!SX3->(DBSEEK("W9_JUROS"  )),cCampo+=" W9_JUROS",) 
ENDIF
IF cPaisLoc # "BRA"
   IF(!SX3->(DBSEEK("YB_TES"    )),cCampo+=" YB_TES",) 
   IF(!SX3->(DBSEEK("YD_TES" )),cCampo+=" YD_TES",) 
   IF(!SX3->(DBSEEK("YB_IMPINS" )),cCampo+=" YB_IMPINS",) 
ENDIF             
IF(!SX3->(DBSEEK("YW_FORN"   )),cCampo+=" YW_FORN",)   // SAM 11/07/2001
IF(!SX3->(DBSEEK("YW_LOJA"   )),cCampo+=" YW_LOJA",)   // SAM 11/07/2001
IF(!SX3->(DBSEEK("Y4_FORN"   )),cCampo+=" Y4_FORN",)   // SAM 11/07/2001
IF(!SX3->(DBSEEK("Y4_LOJA"   )),cCampo+=" Y4_LOJA",)   // SAM 11/07/2001
IF(!SX3->(DBSEEK("W6_CORRETO")),cCampo+=" W6_CORRETO",)// SAM 11/07/2001
IF(!SX3->(DBSEEK("W6_VENCFRE")),cCampo+=" W6_VENCFRE",)// SAM 11/07/2001
IF(!SX3->(DBSEEK("W6_VENCSEG")),cCampo+=" W6_VENCSEG",)// SAM 11/07/2001
IF(!SX3->(DBSEEK("WD_GERFIN" )),cCampo+=" WD_GERFIN",) // SAM 11/07/2001
IF(!SX3->(DBSEEK("WD_DTENVF" )),cCampo+=" WD_DTENVF",) // SAM 11/07/2001
IF(!SX3->(DBSEEK("W6_NF_SEG" )),cCampo+=" W6_NF_SEG",) // AWR 12/07/2001
IF(!SX3->(DBSEEK("YS_FORN"   )),cCampo+=" YS_FORN",) 
IF(!SX3->(DBSEEK("EIC_GERFIN")),cCampo+=" EIC_GERFIN",) 
IF(!SX3->(DBSEEK("Y5_FORNECE")),cCampo+=" Y5_FORNECE",) 
IF(!SX3->(DBSEEK("Y5_LOJAF"  )),cCampo+=" Y5_LOJAF",) 
IF(!SX3->(DBSEEK("Y5_CLIENTE")),cCampo+=" Y5_CLIENTE",) 
IF(!SX3->(DBSEEK("Y5_LOJACLI")),cCampo+=" Y5_LOJACLI",) 
IF(!SX3->(DBSEEK("Y5_NATUREZ")),cCampo+=" Y5_NATUREZ",) 
IF(!SX3->(DBSEEK("W6_NUMDUP" )),cCampo+=" W6_NUMDUP",) 
IF(!SX3->(DBSEEK("WD_CTRFIN1")),cCampo+=" WD_CTRFIN1",) 
IF(!SX3->(DBSEEK("WD_CTRFIN2")),cCampo+=" WD_CTRFIN2",) 
IF(!SX3->(DBSEEK("WD_CTRFIN3")),cCampo+=" WD_CTRFIN3",) 
IF(!SX3->(DBSEEK("W6_TAB_PC" )),cCampo+=" W6_TAB_PC",) 
IF(!SX3->(DBSEEK("WH_DESC"   )),cCampo+=" WH_DESC",) 
IF(!SX3->(DBSEEK("EIC_FORN"  )),cCampo+=" EIC_FORN",) 
IF(!SX3->(DBSEEK("EIC_LOJA"  )),cCampo+=" EIC_LOJA",) 
IF(!SX3->(DBSEEK("WB_NUMDUP" )),cCampo+=" WB_NUMDUP",) 
IF(!SX3->(DBSEEK("WB_PARCELA")),cCampo+=" WB_PARCELA",) 
IF(!SX3->(DBSEEK("W9_NUM"    )),cCampo+=" W9_NUM",) 
IF(!SX3->(DBSEEK("WD_FORN"   )),cCampo+=" WD_FORN",) 
IF(!SX3->(DBSEEK("WD_LOJA"   )),cCampo+=" WD_LOJA",) 
IF(!SX3->(DBSEEK("A6_CODFOR" )),cCampo+=" A6_CODFOR",) //A6_FORN ===> A6_CODFOR AWR 21/07/2001
IF(!SX3->(DBSEEK("A6_LOJFOR" )),cCampo+=" A6_LOJFOR",) //A6_LOJN ===> A6_LOJFOR AWR 21/07/2001
IF(!SX3->(DBSEEK("WD_CODINT" )),cCampo+=" WD_CODINT",) 
IF(!SX3->(DBSEEK("WD_DTLANC" )),cCampo+=" WD_DTLANC",) 
IF(!SX3->(DBSEEK("W6_DTLANCS")),cCampo+=" W6_DTLANCS",) 
IF(!SX3->(DBSEEK("W6_DTLANCF")),cCampo+=" W6_DTLANCF",) 
IF(!SX3->(DBSEEK("W9_DTLANC" )),cCampo+=" W9_DTLANC",) 
IF(!SX6->(DBSEEK(xFilial("SX6")+"MV_FORDESP")),cCampo+=" SX6 => MV_FORDESP",) 
IF(!SX6->(DBSEEK(xFilial("SX6")+"MV_LOJDESP")),cCampo+=" SX6 => MV_LOJDESP",) 
IF(!SX6->(DBSEEK(xFilial("SX6")+"MV_CLIDESP")),cCampo+=" SX6 => MV_CLIDESP",) 
IF(!SX6->(DBSEEK(xFilial("SX6")+"MV_CLODESP")),cCampo+=" SX6 => MV_CLODESP",) 
IF(!SX6->(DBSEEK(xFilial("SX6")+"MV_NATDESP")),cCampo+=" SX6 => MV_NATDESP",) 
IF(!SX1->(DBSEEK("EICFI4")),cCampo+=" SX1 => EICFI4",)

IF !EMPTY(cCampo)
   IF TYPE("ParamIXB") == "L" .AND. ParamIXB
      MSGINFO("Não existe no dicionario: "+cCampo+chr(13)+chr(10)+;//"Não existe no dicionario: "
              "Integracao com Financeiro não pode ser Efetuada")//"Integracao com Financeiro não pode ser Efetuada"
   ENDIF
   SX3->(DBSETORDER(1))
   RETURN .F.
ENDIF

SX3->(DBSETORDER(1))

DO CASE
    CASE cExecute == 'WORK_BROWSES' 
         IF nTipoNF == NFE_COMPLEMEN
            lNFAutomatica := .F.
         ENDIF
         IF !lGravaWorks .AND. nTipoNF # NFE_COMPLEMEN
            IF cPaisLoc # "BRA"
               IF cPaisLoc == "PAR"
                 lRatFreQTDE:=MSGYESNO("Desea hacer el prorateio del flete por Quantidad ?",STR0022)
               ELSE
                 lRatFretePorFOB:=MSGYESNO("Desea hacer el prorateio del flete por FOB ?",STR0022)
               ENDIF
            ENDIF
         ENDIF
         TB_Campos1:={}
         AADD(TB_Campos1,{"WK_CFO"    ,"" , STR0039 }) //"C.F.O."
         AADD(TB_Campos1,{{||Work2->WK_OPERACA+"/"+TRAN(Work2->WKTEC,PICT_CPO03)+"/"+Work2->WKEX_NCM+"/"+Work2->WKEX_NBM},"",STR0040}) //"Operacao/TEC/Ex-NCM/Ex-NBM"
         AADD(TB_Campos1,{"WKPESOL"   ,"" , STR0144 ,PICTPesoT}) //"Peso Adiçào"
         AADD(TB_Campos1,{"WKFOB_R"   ,"" , STR0042 ,PICT15_2}) //"FOB (R$)"
         AADD(TB_Campos1,{"WKFRETE"   ,"" , STR0043 ,PICT15_2}) //"FRETE (R$)"
         AADD(TB_Campos1,{"WKSEGURO"  ,"" , STR0044 ,PICT15_2}) //"SEGURO (R$)"
         AADD(TB_Campos1,{"WKCIF"     ,"" , STR0045 ,PICT15_2}) //"C.I.F. (R$)"
         AADD(TB_Campos1,{{||Work2->WKOUTRDESP+Work2->WKRDIFMID},"",STR0053,PICT15_2}) //"Outras Despesas"
         TB_Campos2:={}                                   
         
         IF !lGravaWorks .AND. !lNFAutomatica .AND. nTipoNF # CUSTO_REAL
            AADD(TB_Campos2,{"WKFLAG","" ,"",})
         ENDIF
         IF nTipoNF == CUSTO_REAL
            AADD(TB_Campos2,{"WK_NFE   " ,"" ,(STR0037),}) //"N§ Custo"
         ELSE
            AADD(TB_Campos2,{"WK_NFE   " ,"" ,(STR0038),}) //"N§ NF"
            AADD(TB_Campos2,{"WK_SE_NFE" ,"" ,(STR0028),}) //"S‚rie NF"
            AADD(TB_Campos2,{"WK_DT_NFE" ,"" ,STR0096,})//"Data da N.F."
            IF nTipoNF = NFE_COMPLEMEN
               AADD(TB_Campos2,{"WKDESPESA" ,"" ,"Despesa",})
            ENDIF
         ENDIF
         AADD(TB_Campos2,{"WKFORN",,AVSX3("W7_FORN",5),})
         AADD(TB_Campos2,{"WK_CFO"    ,"" ,(STR0039)  ,}) //"C.F.O."
         AADD(TB_Campos2,{{||Work1->WK_OPERACA+"/"+TRAN(Work1->WKTEC,PICT_CPO03)+"/"+Work1->WKEX_NCM+"/"+Work1->WKEX_NBM},"",STR0040,}) //"Operacao/TEC/Ex-NCM/Ex-NBM"
         AADD(TB_Campos2,{"WKCOD_I"   ,"" ,(STR0054)           ,}) //"C¢d. Item"
         AADD(TB_Campos2,{{||Left(Work1->WKDESCR,35)},,(STR0055)}) //"Descri‡Æo do Item"
         AADD(TB_Campos2,{"WKPESOL"   ,"" ,(STR0041),PICTPesoI}) //"Peso L¡quido"
         AADD(TB_Campos2,{"WKPRUNI"   ,"" ,(STR0056),PICT21_8 }) //"Pre‡o Unit rio(R$)"
         AADD(TB_Campos2,{"WKQTDE"    ,"" , STR0057          ,PICT_CPO07}) //"Quantidade"
         AADD(TB_Campos2,{"WKVALMERC" ,"" ,(STR0058),_PictPrUn}) //"Pre‡o Total(R$)"
         IF nTipoNF # 1
            AADD(TB_Campos2,{"WKFOB_R","" , STR0042          ,PICT15_2}) //"FOB R$"
         ENDIF
         AADD(TB_Campos2,{"WKFRETE"   ,"" , STR0043          ,PICT15_2}) //"Frete R$"
         AADD(TB_Campos2,{"WKSEGURO"  ,"" , STR0044          ,PICT15_2}) //"Seguro R$"
         AADD(TB_Campos2,{"WKCIF"     ,"" , STR0045          ,PICT15_2}) //"C.I.F. (R$)"
         IF cPaisLoc # "BRA"
            AADD(TB_Campos2,{"WKIMPOSTOS","" , STR0289          ,PICT15_2}) //Impostos
         ENDIF
         AADD(TB_Campos2,{"WKPO_NUM"  ,"" ,(STR0063),}) //"N§ P.O."
         nTotImpostos:=0
         aCampos:={};aHeader:={}     
         nTam:=AVSX3("WZ_CFO",3)+AVSX3("W7_OPERACA",3)+AVSX3("YD_TEC",3)+AVSX3("YD_EX_NCM",3)+AVSX3("YD_EX_NBM",3)
         aSemSX3:={{"WKRECNO"   ,"C",06,0},;
                   {"WKITEM"    ,"C",AVSX3("W7_COD_I",3),0},;
                   {"WK_IMP"    ,"C",03,0},;
                   {"WK_NCM"    ,"C",nTam,0},;
                   {"WK_IMPDESC","C",20,0},;
                   {"WKPERC"    ,"N",06,2},;
                   {"WKVALOR"   ,"N",18,7},;
                   {"WKBASE"    ,"N",18,7},;
                   {"WKVLR_CPO" ,"C",10,0},;
                   {"WKALI_CPO" ,"C",10,0},;
                   {"WKBAS_CPO" ,"C",10,0}}

         cFile:=E_CriaTrab(,aSemSX3,"WorkTES")
         IF ! USED()
            Help("",1,"AVG0000802")//"Nao foi possivel a abertura do Arquivo de Trabalho"###"Atenção"
            Return .F.
         ENDIF
         IndRegua("WorkTES",cFile+OrdBagExt(),"WKRECNO+WK_NCM+WK_IMP")

         AADD(aDBF_Stru ,{"WKIMPOSTOS","N",18,7})
         AADD(aDBF_Stru3,{"WKFORN"    ,"C",AVSX3("W7_FORN",3),0})
         AADD(aDBF_Stru3,{"WKLOJA"    ,"C",AVSX3("A2_LOJA",3),0})

    CASE cExecute == 'OUTROS_INDICES'//'INDICE_D'

         Work1FileE:=E_Create(,.F.)
         IndRegua("Work1",Work1FileE+OrdBagExt(),"WKFORN+WK_NFE+WK_SE_NFE+WK_OPERACA+WKTEC+WKEX_NCM+WKEX_NBM+WKPO_NUM")

         Work1FileF:=E_Create(,.F.)
         IndRegua("Work1",Work1FileF+OrdBagExt(),"WK_NFE+WK_SE_NFE+WKFORN")

         SET INDEX TO (Work1File+OrdBagExt()),(Work1FileA+OrdBagExt()), (Work1FileB+OrdBagExt()), (Work1FileC+OrdBagExt()), (Work1FileD+OrdBagExt()), (Work1FileE+OrdBagExt()), (Work1FileF+OrdBagExt())

    CASE cExecute == "TELA1"
         IF cPaisLoc # "BRA"
            nLin+=12 
            @ nLin,nCoL5 BUTTON "Impuestos" SIZE nSize,12 ACTION (TelaImpostos(!lGravaWorks))// PIXEL
            oMark:bAval:={||TelaImpostos(!lGravaWorks)}
            cTotal :="Total General CIF + Outras Desp. $"
         ENDIF
    CASE cExecute=='TELA_IMPOSTOS'               
         IF cPaisLoc # "BRA"
            oDlgAlt:nHeight:=100         
            oDlgAlt:cCaption:="Modificacion de Peso"
         ENDIF
    CASE (cExecute=="FINALGRAVA" .OR. cExecute=='ALTEROU_IMPOSTOS')
         IF cPaisLoc # "BRA"
            IF nTipoNF = 2
               Processa({||ICGeraDespesas()},"Generando Impuestos")
            ENDIF

            Processa({||ICGeraImpostos(nTipoNF = NFE_COMPLEMEN)},"Generando Impuestos")
         ENDIF
         
    CASE cExecute == 'IniciaVariavel'

         aValores:={}

    CASE cExecute == 'IniciaVar2' .OR. cExecute == 'IniciaVar4'

         nWK1Ordem:=7

    CASE cExecute == 'IniciaVar3' .OR. cExecute == 'IniciaVar5'

         cNotaGrupo:=Work1->WK_NFE+Work1->WK_SE_NFE+Work1->WKFORN+Work1->WKLOJA
         cForn:=Work1->WKFORN

    CASE cExecute == 'Outra_Quebra'

         lQuebra_Espe:=.T.
         IF nNFE # Work1->WK_NFE .OR. nSerie # Work1->WK_SE_NFE .OR. cForn # Work1->WKFORN
            lQuebrou_NF:= .T.
            cForn:=Work1->WKFORN
         ELSE
            lQuebrou_NF:= .F.
         ENDIF

    CASE cExecute == 'QUEBRA_CUSTO'

        IF cForn # Work1->WKFORN
           cForn:=Work1->WKFORN
           nItem:=GetMV("MV_NRCUSTO")
           nItem++
           SetMV("MV_NRCUSTO",nItem)
           cNumero:=STRZERO(nItem,6,0)
        ENDIF

    CASE cExecute == 'TELA_TOTAIS' 
         IF cPaisLoc # "BRA"
            ICPadMostraTotais()    
            lSair:=.T.     
         ENDIF
    CASE cExecute == "BOTAO" 
         IF cPaisLoc # "BRA"
            @ 04,45 BUTTON "Impuestos / Item" SIZE 45,12 ACTION (ICPadItemAltera(),DBSELECTAREA("Work1"),oMark:oBrowse:Refresh()) OBJECT oBotao
            IF(lGerouNFE,oBotao:DISABLE(),)
            IF lNFAutomatica .OR. nTipoNF == 4//CUSTO_REAL
               oMark:bAval:={||ICPadItemAltera(),DBSELECTAREA("Work1"),oMark:oBrowse:Refresh()}
               oMark:oBrowse:bWhen:={|| DBSELECTAREA("Work1"),.T. }
            ENDIF
            @ 04,95 BUTTON STR0259 SIZE 37,11 ACTION Processa({|| DI154PRETXT()},STR0031)// GERAR ARQUIVO
            nOpca:=0
         ENDIF

    CASE (cExecute == 'LER_SF1_SWN' .OR. cExecute == 'LEREI2')

         IF nTipoNF # 2
            lGera:=!EMPTY(Work1->WKTEC) .AND. ;
                   SYD->(DbSeek(xFilial("SYD")+Work1->WKTEC+Work1->WKEX_NCM+Work1->WKEX_NBM)) .AND. ;
                   !EMPTY(SYD->YD_TES)
         ELSE
            SWW->(DBSEEK(xFilial("SWW")+Work1->WK_NFE+Work1->WK_SE_NFE+Work1->WKFORN+;
                         Work1->WKLOJA+Work1->WKPO_NUM+Work1->WKPOSICAO))
            Work1->WKDESPESA := SWW->WW_DESPESA
            lGera:=!EMPTY(Work1->WKDESPESA) .AND. ;
                   SYB->(DbSeek(xFilial("SYB")+LEFT(Work1->WKDESPESA,3))) .AND. ;
                   !EMPTY(SYB->YB_TES)
         ENDIF
         aTotais:={}
         IF lGera
            aTab:=ICPadTab(IF(nTipoNF # 2,SYD->YD_TES,SYB->YB_TES))
            SFB->(DBSETORDER(1))
            IF !EMPTY(aTab)
               FOR I := 1 TO LEN(aTab)
                   IF nTipoNF # 4 //CUSTO_REAL
                      nCpoALI:=SWN->( FIELDPOS("WN"+aTab[I,2]) )
                      nCpoVLR:=SWN->( FIELDPOS("WN"+aTab[I,3]) )
                      nCpoBAS:=SWN->( FIELDPOS("WN"+aTab[I,4]) )
                   ELSE
                      nCpoALI:=EI2->( FIELDPOS("EI2"+STUFF(aTab[I,2],7,1,"")) )
                      nCpoVLR:=EI2->( FIELDPOS("EI2"+STUFF(aTab[I,3],7,1,"")) )
                      nCpoBAS:=EI2->( FIELDPOS("EI2"+STUFF(aTab[I,4],7,1,"")) )
                   ENDIF                     
                   IF nCpoVLR # 0 .AND. nCpoBAS # 0
                      WorkTES->(DBAPPEND())
                      WorkTES->WKRECNO   :=STRZERO(Work1->(RECNO()),6)
                      WorkTES->WKITEM    :=Work1->WKCOD_I
                      WorkTES->WK_IMP    :=aTab[I,1]
                      SFB->(DBSEEK(xFilial("SFB")+WorkTES->WK_IMP))
                      WorkTES->WK_IMPDESC:=LEFT(SFB->FB_DESCR,20)
                      IF nTipoNF # 4 //CUSTO_REAL
                         WorkTES->WKVALOR:=SWN->( FIELDGET(nCpoVLR) )
                         WorkTES->WKBASE :=SWN->( FIELDGET(nCpoBAS) )
                         IF(nCpoALI#0,WorkTES->WKPERC:=SWN->(FIELDGET(nCpoALI)),)
                      ELSE
                         WorkTES->WKVALOR:=EI2->( FIELDGET(nCpoVLR) )
                         WorkTES->WKBASE :=EI2->( FIELDGET(nCpoBAS) )
                         IF(nCpoALI#0,WorkTES->WKPERC:=EI2->(FIELDGET(nCpoALI)),)
                      ENDIF                     
                      Work1->WKIMPOSTOS +=DITRANS(WorkTES->WKVALOR,2)
                      IF (nPos:=ASCAN(aTotais,{|aDesp|aDesp[1]==WorkTES->WK_IMP} )) == 0
                         AADD(aTotais,{WorkTES->WK_IMP,;
                                       DITRANS(WorkTES->WKVALOR),;
                                       DITRANS(WorkTES->WKBASE),} )
                      ELSE
                         aTotais[nPos,2]+=DITRANS(WorkTES->WKVALOR  )//Valor
                         aTotais[nPos,3]+=DITRANS(WorkTES->WKBASE   )//Base
                      ENDIF
                   ENDIF
               NEXT
            ENDIF

            FOR I := 1 TO LEN(aTotais)
               //TOTAL GERAL
               SFB->(DBSEEK(xFilial("SFB")+aTotais[I,1]))
               IF !WorkTES->(DBSEEK( "TOTAIS"+SPACE(LEN(WorkTES->WK_NCM))+aTotais[I,1] ))
                  WorkTES->(DBAPPEND())
                  WorkTES->WKRECNO   :="TOTAIS"
                  WorkTES->WK_IMP    :=aTotais[I,1]
                  WorkTES->WK_IMPDESC:=LEFT(SFB->FB_DESCR,20)
               ENDIF
               WorkTES->WKVALOR   +=aTotais[I,2]
               WorkTES->WKBASE    +=aTotais[I,3]
            NEXT
            nTotImpostos+=Work1->WKIMPOSTOS

         ENDIF

    CASE cExecute == "GRVWORK_1a"

         IF cPaisLoc # "BRA"
            // PARA GARANTIR QUE TEM TES E QUE EXISTE A NCM NO CADASTRO
            // CASO CONTRARIO A CLASSIFICACAO DA NOTA É FEITA COM ERRO, PASSAR AS MSGS PARA STR
            IF !SYD->(DbSeek(xFilial("SYD")+M->WK_TEC+M->WK_EX_NCM+M->WK_EX_NBM))
               IF !EMPTY(M->WK_TEC+M->WK_EX_NCM+M->WK_EX_NBM)
                  MSGSTOP("Producto sen partida arancelaria ! " + M->WK_TEC+M->WK_EX_NCM+M->WK_EX_NBM , "STOP")      
               ELSE       
                  MSGSTOP("Partida Arancelaria en blanco " , "ATENCION")
               ENDIF   
            ELSE       
               IF EMPTY(SYD->YD_TES) 
                  MSGSTOP("TES invalido en archivo de partida arancelaria : " + M->WK_TEC+M->WK_EX_NCM+M->WK_EX_NBM , "STOP")
               ENDIF
            ENDIF   
         ENDIF   
    
    CASE cExecute == "GRAVA_SD1_EI3"

//       If nTipoNF # 4//CUSTO_REAL
//          ICPADGrava("SD1")
//       ELSE
            ICPADGrava("EI3")
//       ENDIF

   CASE (cExecute == "ACUMULA_SD1_EI3" .OR.;
         cExecute == "GRAVA_SWN_EI2"   .OR.;
         cExecute == "GRV_SD1")
         
         aGrvImpSD1:={}
    
         cAlias:=IF(nTipoNF#4,"SWN","EI2")
         cAlias:=IF(cExecute = "GRV_SD1","SD1",cAlias)
         IF cExecute == "GRAVA_SWN_EI2"
            (cAlias)->(RecLock(cAlias,.F.))
         ENDIF

         IF WorkTES->(DBSEEK( STRZERO(Work1->(RECNO()),6) ))
            DO WHILE !WorkTES->(EOF()) .AND. STRZERO(Work1->(RECNO()),6) == WorkTES->WKRECNO
               IF (nPos:=ASCAN(aValores, {|aImp|aImp[1]==WorkTES->WK_IMP} )) == 0
                  AADD(aValores,{WorkTES->WK_IMP,WorkTES->WKVALOR,WorkTES->WKBASE,WorkTES->WKVLR_CPO,WorkTES->WKBAS_CPO,WorkTES->WKALI_CPO} )
               ELSE
                  aValores[nPos,2]+=DITRANS(WorkTES->WKVALOR,2)//Valor
                  aValores[nPos,3]+=DITRANS(WorkTES->WKBASE ,2)//Base
               ENDIF
               IF cExecute == "GRAVA_SWN_EI2" .OR.;
                  cExecute == "GRV_SD1"
                  ICPADGrava(cAlias,aGrvImpSD1)
               ENDIF
               WorkTES->(DBSKIP())
            ENDDO
         ENDIF

         IF cExecute == "GRV_SD1"
            nUltReg:=LEN(aItens)
            FOR Imp := 1 TO LEN(aGrvImpSD1)
                AADD( aItens[nUltReg] , ACLONE(aGrvImpSD1[Imp]) )
            NEXT
         ENDIF

         IF cExecute == "GRAVA_SWN_EI2"
            (cAlias)->(MSUNLOCK())
         ENDIF

    CASE cExecute == "GRV_SF1" .OR. cExecute == "GRV_EI1"

         If nTipoNF # 4//CUSTO_REAL
            ICPADGrava("SF1")
         ELSE
            ICPADGrava("EI1")
         ENDIF

    CASE cExecute == 'ANTES_ESTORNO_NOTA'

         bForSWD:={|| AT(SWD->(LEFT(SWD->WD_DESPESA,1)),"129") = 0 .AND.;
                      cNota = SWD->WD_NF_COMP+SWD->WD_SE_NFC+SWD->WD_FORN+SWD->WD_LOJA }
         
    CASE cExecute == "TAB_DESPESAS"

         IF nTipoNF = 2
            nPos:= ASCAN(aDespesa,{|Desp|Desp[01]==SWD->WD_DESPESA .AND.;
                                         Desp[07]==SWD->WD_DOCTO   .AND.;
                                         Desp[09]==SWD->WD_FORN    .AND.;
                                         Desp[10]==SWD->WD_LOJA})
            IF nPos = 0
               AADD(aDespesa,{SWD->WD_DESPESA,;//1
                              SWD->WD_VALOR_R,;//2
                                            0,;//3
                               SWD->(RECNO()),;//4
                                            0,;//5
                                            0,;//6
                              SWD->WD_DOCTO  ,;//7
                              SWD->WD_DES_ADI,;//8
                              SWD->WD_FORN   ,;//9
                              SWD->WD_LOJA   })//10
            ENDIF
         ELSE
            nPos:= ASCAN(aDespesa,{|Desp|Desp[1]==SWD->WD_DESPESA})
            IF(nPos=0,AADD(aDespesa,{SWD->WD_DESPESA,SWD->WD_VALOR_R,0,SWD->(RECNO()),0,0,"",CTOD(""),"",""}),)
         ENDIF
         IF nPos # 0
            aDespesa[nPos,2]+=SWD->WD_VALOR_R
//          aDespesa[nPos,6]+=SWD->WD_VALOR_R / IF(BuscaTaxa(cMoeDolar,SWD->WD_DES_ADI)#0,BuscaTaxa(cMoeDolar,SWD->WD_DES_ADI),1)
         ENDIF
         lSair:=.T.
    CASE cExecute == "GRVWORK_1"
         aTotalForn:={}

    CASE cExecute == "WHILE_SW9"

         nFobInv:=DITRANS(SW9->W9_FOB_TOT+SW9->W9_INLAND+SW9->W9_PACKING-SW9->W9_DESCONTO,2)
         IF (nPosF:=ASCAN(aTotalForn,{|F| F[1] == SW9->W9_FORN } )) = 0 
            AADD(aTotalForn, {SW9->W9_FORN,nFobInv} )
         ELSE
            aTotalForn[nPosF,2]+=nFobInv
         ENDIF
         
    CASE cExecute == "GRVWORK3"

         nRateio:=((Work1->WKFOB_ORI)/(SW6->W6_FOB_TOT+MDespesas))
         IF !EMPTY(SWD->WD_FORNRAT)            
            nRateio:=0
            IF Work1->WKFORN == SWD->WD_FORNRAT
               IF (nPosF:=ASCAN(aTotalForn,{|F| F[1] == SWD->WD_FORNRAT } )) # 0 
                  nRateio:=((Work1->WKFOB_ORI)/aTotalForn[nPosF,2])
               ENDIF   
            ENDIF
            IF nRateio = 0
               Work3->(DBDELETE())
               IF nTipoNF = 2
                  lAcerta:=.F.
               ENDIF   
               RETURN .F.
            ENDIF
         ENDIF
         nValor:=DITRANS(aDespesa[Wind,2]*nRateio,2)
         Work3->WKVALOR   := nValor
         Work3->WKVALOR_US:= DITRANS(Work3->WKVALOR/nTaxa,2)

         Work3->WK_NF_COMP:= aDespesa[Wind,07]
         Work3->WK_DT_NFC := aDespesa[Wind,08]
         IF !EMPTY(aDespesa[Wind,09])
            Work3->WKFORN := aDespesa[Wind,09]
            Work3->WKLOJA := aDespesa[Wind,10]
         ELSE
            Work3->WKFORN := Work1->WKFORN
            Work3->WKLOJA := Work1->WKLOJA
         ENDIF
         IF nTipoNF = 2
            lAcerta:=.F.
//          IF (nPos:=ASCAN(aDesAcerto,{|D|D[1]==Work3->WKDESPESA .AND. D[6]==Work3->WK_NF_COMP .AND. D[7]==Work3->WKFORN})) = 0
//             AADD(aDesAcerto,{Work3->WKDESPESA,Work3->WKVALOR ,Work3->WKVALOR_US,aDespesa[Wind,2],DITRANS(aDespesa[Wind,2]/nTaxa,2),Work3->WK_NF_COMP,Work3->WKFORN,Work3->(RECNO())})
//          ELSE
//             aDesAcerto[nPos,2] += Work3->WKVALOR
//             aDesAcerto[nPos,3] += Work3->WKVALOR_US
//             aDesAcerto[nPos,8] := Work3->(RECNO())
//          ENDIF
            IF (nPos:=ASCAN(aDesAcerto,{|D|D[1]==Work3->WKDESPESA  .AND.;
                                          D[7]==Work3->WK_NF_COMP .AND.;
                                          D[8]==aDespesa[Wind,09] .AND.;
                                          D[9]==aDespesa[Wind,10] })) = 0
               AADD(aDesAcerto,{Work3->WKDESPESA ,;//1
                                Work3->WKVALOR   ,;//2
                                Work3->WKVALOR_US,;//3
                                aDespesa[Wind,2] ,;//4 Valor Total
                                DITRANS(aDespesa[Wind,2]/nTaxa,2),;//5
                                Work3->(RECNO()) ,;//6
                                Work3->WK_NF_COMP,;//7
                                aDespesa[Wind,09],;//8 Fornecedor
                                aDespesa[Wind,10]})//9 Loja
            ELSE
               aDesAcerto[nPos,2] += nValor
               aDesAcerto[nPos,3] += DITRANS(nValor/nTaxa,2)
            ENDIF
         ENDIF

    CASE cExecute == "GRVWORK_2"

         IF nTipoNF = 2
            FOR E=1 TO LEN(aDesAcerto)
                IF aDesAcerto[E,2] # aDesAcerto[E,4]
                   Work3->(DBGOTO(aDesAcerto[E,6]))
                   Work3->WKVALOR   :=Work3->WKVALOR   +(aDesAcerto[E,4]-aDesAcerto[E,2])
                ENDIF
                IF aDesAcerto[E,3] # aDesAcerto[E,5]
                   Work3->(DBGOTO(aDesAcerto[E,6]))
                   Work3->WKVALOR_US:=Work3->WKVALOR_US+(aDesAcerto[E,5]-aDesAcerto[E,3])
                ENDIF
            NEXT
            aDesAcerto:={}
         ENDIF

    CASE cExecute == "GRAVA_SWW"

         SWW->WW_FORNECE := Work3->WKFORN
         SWW->WW_LOJA    := Work3->WKLOJA

    CASE cExecute == 'DELETAWORK' //.AND. nTipoNF # 2 //NFE_COMPLEMEN

         WorkTES->(E_EraseArq(cFile))
         FErase(Work1FileD+OrdBagExt())
         FErase(Work1FileE+OrdBagExt())
         FErase(Work1FileF+OrdBagExt())
    
    ENDCASE    
RETURN .T.

*-------------------------------------------------------------------------------------------------------*
STATIC FUNCTION DIGerou()
*-------------------------------------------------------------------------------------------------------*
IF nTipoNF # 4 .AND. (!lGeraNF .OR. (!lGerouNFE .AND. lNFAutomatica))
   RETURN MsgYesNo(STR0288,STR0022)//"Nao ha No. de Nota Fiscal! Deseja Exportar?"###"Atencao"
ENDIF

RETURN .T.
*-------------------------------------------------------------------------------------------------------*
FUNCTION DI154PRETXT()
*-------------------------------------------------------------------------------------------------------*
LOCAL OldArea:=SELECT()               
//ASR 18/10/2005 - NÃO UTILIZADA - LOCAL _PictItem := ALLTRIM(X3Picture("B1_COD"))
LOCAL lTXTMV_PIS_EIC:= GETMV("MV_PIS_EIC",,.F.) .AND. SWN->(FIELDPOS("WN_VLRPIS")) # 0 .AND. Work1->(FIELDPOS("WKVLUPIS")) # 0//AWR
LOCAL aEstrutura:={{"WKFORN"    ,"C",15,00},;
                   {"WKTEC"     ,"C",10,00},;
                   {"WKQUAL_NCM","C",03,00},;
                   {"WKQUALIF"  ,"C",03,00},;
                   {"WKCOD_I"   ,"C",30,00},;
                   {"WKDESCR"   ,"C",60,00},;
                   {"WKPESOL"   ,"N",18,08},;				   
                   {"WKQTDE"    ,"N",15,04},;
                   {"WKUNI"     ,"C",03,00},;
                   {"WKFOB"     ,"N",18,08},;
                   {"WKMOE_FOB" ,"C",03,00},;
                   {"WKTX_FOB"  ,"N",15,08},;
                   {"WKCIF"     ,"N",18,08},;
                   {"WKFRETE"   ,"N",18,08},;
                   {"WKMOE_FRE" ,"C",03,00},;
                   {"WKTX_FRETE","N",15,08},;
                   {"WKSEGURO"  ,"N",18,08},;
                   {"WKMOE_SEG" ,"C",03,00},;
                   {"WKTX_USD"  ,"N",15,08},;
                   {"WKOUT_DESP","N",18,08},;
                   {"WKIIVAL"   ,"N",18,08},;
                   {"WKIPIVAL"  ,"N",18,08},;
                   {"WKVL_ICM"  ,"N",18,08},;
                   {"WKRATEIO"  ,"N",18,16},;
                   {"WKIITX"    ,"N",06,02},;
                   {"WKIPITX"   ,"N",06,02},;    
                   {"WKICMS_A"  ,"N",06,02},;
                   {"WKHOUSE"   ,"C",20,00},;
                   {"WKHOUSE_DT","D",10,00},;
                   {"WKDI"      ,"C",10,00},;
                   {"WKDI_DT"   ,"D",10,00},;
                   {"WKNFE"     ,"C",20,00},;
                   {"WKNFE_DT"  ,"D",10,00},;
                   {"WKDT_DESEM","D",10,00},;
                   {"WKDT_ENTR" ,"D",10,00},;
                   {"WKLI_NUM"  ,"C",13,00},;
                   {"WKPO_NUM"  ,"C",15,00},;
                   {"WKSI_NUM"  ,"C",06,00},;
                   {"WKCC_NUM"  ,"C",05,00},;
                   {"WKREG"     ,"C",AVSX3("W7_REG",3),00}} // para Merck

AADD(aEstrutura,{"WKVLUPIS"  ,"N",AVSX3("W8_VLUPIS",3),AVSX3("W8_VLUPIS",4)})//AWR
AADD(aEstrutura,{"WKBASPIS"  ,"N",18,7})
AADD(aEstrutura,{"WKPERPIS"  ,"N",06,2})
AADD(aEstrutura,{"WKVLRPIS"  ,"N",18,7})
AADD(aEstrutura,{"WKVLUCOF"  ,"N",AVSX3("W8_VLUCOF",3),AVSX3("W8_VLUCOF",4)})
AADD(aEstrutura,{"WKBASCOF"  ,"N",18,7})
AADD(aEstrutura,{"WKPERCOF"  ,"N",06,2})
AADD(aEstrutura,{"WKVLRCOF"  ,"N",18,7})

PRIVATE aCampos:={}
PRIVATE aHeader:={}
PRIVATE aTit1:= {} // TDF - 19/05/10
PRIVATE aTit2:= {} // TDF - 19/05/10

cFileTXT:=E_CriaTrab(,aEstrutura,"WorkTxt")
IF ! USED()
   Help("",1,"AVG0000802")//"Nao foi possivel a abertura do Arquivo de Trabalho"###"Atenção"
   Return .F.
ENDIF
IndRegua("WorkTxt",cFileTXT+OrdBagExt(),"WKTEC+WKQUALIF+WKQUAL_NCM+WKCOD_I")

DBSELECTAREA("Work2")
Work1->(DBGOTOP())        
ProcRegua(Work1->(LASTREC()))
WHILE ! Work1->(EOF())

   IncProc("Processando Item: "+Work1->WKCOD_I)
   SW9->(DBSETORDER(1))
   SW9->(Dbseek(xfilial("SW9")+Work1->WKINVOICE+Work1->WKFORN ))
   
   WorkTxt->(DBAPPEND())
   WorkTxt->WKFORN      := BuscaFabr_Forn(Work1->WKFORN)
   WorkTxt->WKTEC       := Work1->WKTEC      
   WorkTxt->WKQUAL_NCM  := Work1->WKEX_NCM  
   WorkTxt->WKQUALIF    := Work1->WKEX_NBM                                                                    
   WorkTxt->WKCOD_I     := Work1->WKCOD_I
   WorkTxt->WKDESCR     := Work1->WKDESCR
   WorkTxt->WKPESOL     := Work1->WKPESOL / Work1->WKQTDE
   WorkTxt->WKQTDE      := Work1->WKQTDE
   WorkTxt->WKUNI       := Work1->WKUNI
   WorkTxt->WKCIF       := Work1->WKCIF     
   WorkTxt->WKFRETE     := Work1->WKFRETE   
   WorkTxt->WKSEGURO    := Work1->WKSEGURO  
   WorkTxt->WKFOB       := Work1->WKFOB_R     
   WorkTxt->WKOUT_DESP  := Work1->WKOUT_DESP
   WorkTxt->WKIIVAL     := Work1->WKIIVAL  // /Work1->WKQTDE
   WorkTxt->WKIPIVAL    := Work1->WKIPIVAL // /Work1->WKQTDE
   WorkTxt->WKVL_ICM    := Work1->WKVL_ICM // /Work1->WKQTDE
   WorkTxt->WKRATEIO    := Work1->WKRATEIO
   WorkTxt->WKIITX      := Work1->WKIITX
   WorkTxt->WKIPITX     := Work1->WKIPITX
   WorkTxt->WKICMS_A    := Work1->WKICMS_A
   WorkTxt->WKTX_FOB    := SW9->W9_TX_FOB
   WorkTxt->WKMOE_FRE   := SW6->W6_FREMOEDA 
   WorkTxt->WKTX_FRETE  := SW6->W6_TX_FRET
   WorkTxt->WKMOE_SEG   := SW6->W6_SEGMOED
   WorkTxt->WKTX_USD    := SW6->W6_TX_US_D
   WorkTxt->WKHOUSE     := SW6->W6_HAWB
   WorkTxt->WKHOUSE_DT  := SW6->W6_DT_HAWB
   //WorkTxt->WKHOUSE_DT  := STRZERO(YEAR(SW6->W6_DT_HAWB),4)+STRZERO(MONTH(SW6->W6_DT_HAWB),2)+STRZERO(DAY(SW6->W6_DT_HAWB),2)
   WorkTxt->WKDI        := SW6->W6_DI_NUM
   WorkTxt->WKDI_DT     := SW6->W6_DT
   //WorkTxt->WKDI_DT     := STRZERO(YEAR(SW6->W6_DT),4)+STRZERO(MONTH(SW6->W6_DT),2)+STRZERO(DAY(SW6->W6_DT),2)
   WorkTxt->WKNFE       := Work1->WK_NFE
   WorkTxt->WKNFE_DT    := Work1->WK_DT_NFE
   //WorkTxt->WKNFE_DT    := STRZERO(YEAR(Work1->WK_DT_NFE),4)+STRZERO(MONTH(Work1->WK_DT_NFE),2)+STRZERO(DAY(Work1->WK_DT_NFE),2)
   WorkTxt->WKDT_DESEM  := SW6->W6_DT_DESE
   WorkTxt->WKDT_ENTR   := SW6->W6_DT_ENTR
   //WorkTxt->WKDT_DESEM  := STRZERO(YEAR(SW6->W6_DT_DESE),4)+STRZERO(MONTH(SW6->W6_DT_DESE),2)+STRZERO(DAY(SW6->W6_DT_DESE),2)
   //WorkTxt->WKDT_ENTR   := STRZERO(YEAR(SW6->W6_DT_ENTR),4)+STRZERO(MONTH(SW6->W6_DT_ENTR),2)+STRZERO(DAY(SW6->W6_DT_ENTR),2)
   WorkTxt->WKMOE_FOB   := SW9->W9_MOE_FOB
   WorkTxt->WKLI_NUM    := Work1->WKLI// não contem informação
   WorkTxt->WKPO_NUM    := Work1->WKPO_NUM
   WorkTxt->WKSI_NUM    := Work1->WKSI_NUM// não contem informação
   WorkTxt->WKCC_NUM    := Work1->WK_CC// não contem informação
   WorkTxt->WKREG       := STRZERO(Work1->WK_REG,AVSX3("W7_REG",3))
   
   IF lTXTMV_PIS_EIC//AWR   // avaliar todos
      WorkTxt->WKVLUPIS := Work1->WKVLUPIS
      WorkTxt->WKPERPIS := Work1->WKPERPIS
      WorkTxt->WKBASPIS := Work1->WKBASPIS
      WorkTxt->WKVLRPIS := Work1->WKVLRPIS
      WorkTxt->WKVLUCOF := Work1->WKVLUCOF
      WorkTxt->WKPERCOF := Work1->WKPERCOF
      WorkTxt->WKBASCOF := Work1->WKBASCOF
      WorkTxt->WKVLRCOF := Work1->WKVLRCOF
    ENDIF

   Work1->(DBSKIP())
ENDDO

/* TDF - 19/05/10
O array aTit1 contém os títulos dos campos da WorkTxt e o aTit2 contém os títulos dos campos da Work3(EICDI154) 
Para todo campo acrescentado na WorkTxt e Work3 é necessário acrescentar o título no array correspondente
*/

AAdd(aTit1, {"Fornecedor"       ,"WKFORN"     ,"",,,"",,"C"})
AAdd(aTit1, {"NCM"              ,"WKTEC"      ,"",,,"",,"C"})
AAdd(aTit1, {"EX-NCM"           ,"WKQUAL_NCM" ,"",,,"",,"C"})
AAdd(aTit1, {"Ex-NBM"           ,"WKQUALIF"   ,"",,,"",,"C"})
AAdd(aTit1, {"Código do Item"   ,"WKCOD_I"    ,"",,,"",,"C"})
AAdd(aTit1, {"Descrição do Item","WKDESCR"    ,"",,,"",,"C"})
AAdd(aTit1, {"Peso Líquido"     ,"WKPESOL"    ,"",,,"",,"C"})
AAdd(aTit1, {"Quantidade"       ,"WKQTDE"     ,"",,,"",,"C"})
AAdd(aTit1, {"Unidade"          ,"WKUNI"      ,"",,,"",,"C"})
AAdd(aTit1, {"FOB"              ,"WKFOB"      ,"",,,"",,"C"})
AAdd(aTit1, {"Moeda FOB"        ,"WKMOE_FOB"  ,"",,,"",,"C"})
AAdd(aTit1, {"Taxa FOB"         ,"WKTX_FOB"   ,"",,,"",,"C"})
AAdd(aTit1, {"CIF (Base II)"    ,"WKCIF"      ,"",,,"",,"C"})
AAdd(aTit1, {"Frete"            ,"WKFRETE"    ,"",,,"",,"C"})
AAdd(aTit1, {"Moeda Frete"      ,"WKMOE_FRE"  ,"",,,"",,"C"})
AAdd(aTit1, {"Taxa Frete"       ,"WKTX_FRETE" ,"",,,"",,"C"})
AAdd(aTit1, {"Seguro"           ,"WKSEGURO"   ,"",,,"",,"C"})
AAdd(aTit1, {"Moeda Seguro"     ,"WKMOE_SEG"  ,"",,,"",,"C"})
AAdd(aTit1, {"Taxa Seguro"      ,"WKTX_USD"   ,"",,,"",,"C"})
AAdd(aTit1, {"Outras Despesas"  ,"WKOUT_DESP" ,"",,,"",,"C"})
AAdd(aTit1, {"Valor II"         ,"WKIIVAL"    ,"",,,"",,"C"})
AAdd(aTit1, {"Valor IPI"        ,"WKIPIVAL"   ,"",,,"",,"C"})
AAdd(aTit1, {"Valor ICMS"       ,"WKVL_ICM"   ,"",,,"",,"C"})
AAdd(aTit1, {"Rateio"           ,"WKRATEIO"   ,"",,,"",,"C"})
AAdd(aTit1, {"Taxa II"          ,"WKIITX"     ,"",,,"",,"C"})
AAdd(aTit1, {"Taxa IPI"         ,"WKIPITX"    ,"",,,"",,"C"})
AAdd(aTit1, {"Taxa ICMS"        ,"WKICMS_A"   ,"",,,"",,"C"})
AAdd(aTit1, {"Pedido"           ,"WKHOUSE"    ,"",,,"",,"C"})
AAdd(aTit1, {"Data Pedido"      ,"WKHOUSE_DT" ,"",,,"",,"C"})
AAdd(aTit1, {"DI"               ,"WKDI"       ,"",,,"",,"C"})
AAdd(aTit1, {"Data DI"          ,"WKDI_DT"    ,"",,,"",,"C"})
AAdd(aTit1, {"NFE"              ,"WKNFE"      ,"",,,"",,"C"})
AAdd(aTit1, {"Data NFE"         ,"WKNFE_DT"   ,"",,,"",,"C"})
AAdd(aTit1, {"Data Desembaraço" ,"WKDT_DESEM" ,"",,,"",,"C"})
AAdd(aTit1, {"Data Entrega"     ,"WKDT_ENTR"  ,"",,,"",,"C"})
AAdd(aTit1, {"LI"               ,"WKLI_NUM"   ,"",,,"",,"C"})
AAdd(aTit1, {"PO"               ,"WKPO_NUM"   ,"",,,"",,"C"})
AAdd(aTit1, {"SI"               ,"WKSI_NUM"   ,"",,,"",,"C"})
AAdd(aTit1, {"Centro de Custo"  ,"WKCC_NUM"   ,"",,,"",,"C"})
AAdd(aTit1, {"Registro"         ,"WKREG"      ,"",,,"",,"C"})

If lTXTMV_PIS_EIC
   AAdd(aTit1, {"Vl.Un. PIS"    ,"WKVLUPIS"   ,"",,,"",,"C"})
   AAdd(aTit1, {"Base PIS"      ,"WKBASPIS"   ,"",,,"",,"C"})
   AAdd(aTit1, {"Perc. PIS"     ,"WKPERPIS"   ,"",,,"",,"C"})
   AAdd(aTit1, {"Valor PIS"     ,"WKVLRPIS"   ,"",,,"",,"C"})
   AAdd(aTit1, {"Vl.Un. COFINS" ,"WKVLUCOF"   ,"",,,"",,"C"})
   AAdd(aTit1, {"Base COFINS"   ,"WKBASCOF"   ,"",,,"",,"C"})
   AAdd(aTit1, {"Perc. COFINS"  ,"WKPERCOF"   ,"",,,"",,"C"})
   AAdd(aTit1, {"Valor COFINS"  ,"WKVLRCOF"   ,"",,,"",,"C"})
   AAdd(aTit1, {""              ,""           ,"",,,"",,"C"})
EndIF 

AAdd(aTit2, {"Código"    ,"WKRECNO"    ,"",,,"",,"C"})
AAdd(aTit2, {"Despesa"   ,"WKDESPESA"  ,"",,,"",,"C"})
AAdd(aTit2, {"Valor"     ,"WKVALOR"    ,"",,,"",,"C"})
AAdd(aTit2, {"Valor US"  ,"WKVALOR_US" ,"",,,"",,"C"})
AAdd(aTit2, {"NF Comp."  ,"WK_NF_COMP" ,"",,,"",,"C"})
AAdd(aTit2, {"Série NF"  ,"WK_SE_NFC"  ,"",,,"",,"C"})
AAdd(aTit2, {"Data NF"   ,"WK_DT_NFC" ,"",,,"",,"C"})
AAdd(aTit2, {"PO"        ,"WKPO_NUM"   ,"",,,"",,"C"})
AAdd(aTit2, {"Posição"   ,"WKPOSICAO"  ,"",,,"",,"C"})
AAdd(aTit2, {"PGI"       ,"WKPGI_NUM"  ,"",,,"",,"C"})
AAdd(aTit2, {"Lote"      ,"WK_LOTE"    ,"",,,"",,"C"}) 

//***
     
IF nTipoNF = 4
   TR350Arquivo("WorkTxt","Work3")
ELSE
   TR350Arquivo("WorkTxt",,aTit1,"Itens da NF")
ENDIF

IF nTipoNF = 4 // SO MERCK
   IF(ExistBlock("IC023PO1"),Execblock("IC023PO1",.F.,.F.,"GRVAS400"),) // MERCK - ALEX
ENDIF

WorkTxt->(E_EraseArq(cFileTXT)) 

Work1->(DBGOTOP())
DBSELECTAREA(OldArea)

RETURN .T.

//************************ L O C A L I Z A Ç Õ E S **********************************

*-------------------------------------------------*
STATIC Function ICPadMostraTotais()
*-------------------------------------------------*
LOCAL nCo1:=5, nCo2:=40, nCo3:=105, nCo4:=150
LOCAL nTotNFE:= nVlTota:= 0, oDlgImp
LOCAL TB_Campos:={},oMark
PRIVATE nFobR:=nFrete:=nSeguro:=nCIF:=nII:=nIPI:=nICMS:=nDIFOB:=0,lSair:=.F.,nLin:=05
PRIVATE cFiltro:="TOTAIS"+SPACE(LEN(WorkTES->WK_NCM))

aAdd(TB_Campos,{"WK_IMP" ,,"Impuesto"})
aAdd(TB_Campos,{"WK_IMPDESC",,"Descripción"})
aAdd(TB_Campos,{"WKBASE" ,,"Base $" ,"@E 99,999,999,999.99"})
aAdd(TB_Campos,{"WKVALOR",,"Valor $","@E 99,999,999,999.99"})

Processa({|lEnd|DI154Soma()},(STR0114)) //"Calculando Totais"

nVlTota:=DITRANS((nDIFOB+nTotImpostos),2)

oMainWnd:ReadClientCoords()
@ 000,oMainWnd:nLeft TO 360,oMainWnd:nRight-300 DIALOG oDlgImp TITLE STR0115//"TOTAIS"

@ nLin    ,nCo1 SAY STR0042 //"FOB (R$)"
@ nLin+=13,nCo1 SAY STR0043 //"Frete (R$)"
@ nLin+=13,nCo1 SAY STR0044 //"Seguro (R$)"
@ nLin+=13,nCo1 SAY STR0045 //"C.I.F. (R$)"
nLin:=5
@ nLin    ,nCo2 GET nFobR   WHEN .F. PICTURE PICT15_2 SIZE 55,8
@ nLin+=13,nCo2 GET nFrete  WHEN .F. PICTURE PICT15_2 SIZE 55,8
@ nLin+=13,nCo2 GET nSeguro WHEN .F. PICTURE PICT15_2 SIZE 55,8
@ nLin+=13,nCo2 GET nCIF    WHEN .F. PICTURE PICT15_2 SIZE 55,8
nLin:=5
@ nLin    ,nCo3 SAY STR0058 //"Vl. Mercadoria"
@ nLin+=13,nCo3 SAY "Impuestos"
@ nLin+=13,nCo3 SAY STR0082 //"Total Geral"
nLin:=5
@ nLin    ,nCo4 GET nDIFOB       WHEN .F. PICTURE PICT15_2 SIZE 55,8 
@ nLin+=13,nCo4 GET nTotImpostos WHEN .F. PICTURE PICT15_2 SIZE 55,8 
@ nLin+=13,nCo4 GET nVlTota      WHEN .F. PICTURE PICT15_2 SIZE 55,8 
nLin+=30

oMark:=MsSelect():New("WorkTES",,,TB_Campos,.F.,@cMarca,{nLin,005,nLin+100,(oDlgImp:nClientWidth-4)/2},"U_ICPADFiltra(cFiltro)","U_ICPADFiltra(cFiltro)")

DEFINE SBUTTON FROM nLin+105,oMainWnd:nLeft+10 TYPE 01 ACTION (oDlgImp:End()) ENABLE

ACTIVATE DIALOG oDlgImp CENTERED

RETURN NIL                  

*-----------------------------------------*
STATIC Function TelaImpostos(lNCM)
*-----------------------------------------*
LOCAL TB_Campos:={},oMark,nLin:=05
PRIVATE cFiltro:=STRZERO(Work1->(RECNO()),6)
IF(lNCM,cFiltro:="TOTAIS"+Work2->WK_CFO+Work2->WK_OPERACA+Work2->WKTEC+Work2->WKEX_NCM+Work2->WKEX_NBM,)
aAdd(TB_Campos,{"WK_IMP" ,,"Impuesto"})
aAdd(TB_Campos,{"WK_IMPDESC",,"Descripción"})
IF(!lNCM,aAdd(TB_Campos,{"WKPERC",,"% Alicuota","@E 999.99"}),)
aAdd(TB_Campos,{"WKBASE" ,,"Base $" ,"@E 99,999,999,999.99"})
aAdd(TB_Campos,{"WKVALOR",,"Valor $","@E 99,999,999,999.99"})

oMainWnd:ReadClientCoords()
DEFINE MSDIALOG oDlgImp TITLE "Impuestos - "+IF(lNCM,"Arancel: "+ALLTRIM(Work2->WK_CFO+Work2->WK_OPERACA+Work2->WKTEC+Work2->WKEX_NCM+Work2->WKEX_NBM),;
  "Item: "+Work1->WKCOD_I);
  FROM 000,oMainWnd:nLeft TO 250,oMainWnd:nRight-200 OF oMainWnd PIXEL

  oMark:=MsSelect():New("WorkTES",,,TB_Campos,.F.,@cMarca,{nLin,005,nLin+100,(oDlgImp:nClientWidth-4)/2},"U_ICPADFiltra(cFiltro)","U_ICPADFiltra(cFiltro)")

  DEFINE SBUTTON FROM nLin+105,oMainWnd:nLeft+10 TYPE 01 ACTION (oDlgImp:End()) ENABLE

ACTIVATE DIALOG oDlgImp CENTERED

RETURN .T.

*--------------------------------------*
STATIC Function ICPadItemAltera()
*--------------------------------------*
LOCAL nCo1:=5, nCo2:=50, nCo3:=115, nCo4:=160, nLin:=05
LOCAL oDlgImp
LOCAL TB_Campos:={},oMark1
LOCAL nCif, oDlg, nOpca:=0, nRecno:=Work1->(RECNO())
LOCAL cConfirma:=(STR0121) //"Recalcula  FOB / CIF / Frete / Seguro ?"
LOCAL cTit2    :=(STR0122) //"Valor da Mercadoria Alterado"
LOCAL cTit     :=(STR0123) //"Altera‡Æo do Item Atual"

LOCAL nFOBRS  :=Work1->WKFOB_R
LOCAL nSeguro :=Work1->WKSEGURO
LOCAL nFrete  :=Work1->WKFRETE
LOCAL nVLCIF  :=Work1->WKCIF
LOCAL nVLMERC :=Work1->WKVALMERC

LOCAL nCFOBRS  :=Work1->WKFOB_R
LOCAL nCSeguro :=Work1->WKSEGURO
LOCAL nCFrete  :=Work1->WKFRETE
LOCAL nCVLCIF  :=Work1->WKCIF
LOCAL nCVLMERC :=Work1->WKVALMERC

LOCAL bValid:=IF(nTipoNF # 4 .AND. !lNFAutomatica,;
              {|| DI154Valid("NFE")       .AND. ;
                  DI154Valid("SERIE",.F.) .AND. ;
                  DI154Valid("DATA")},{||.T.})

PRIVATE cFiltro:=STRZERO(Work1->(RECNO()),6)

aAdd(TB_Campos,{"WK_IMP" ,,"Impuesto"})
aAdd(TB_Campos,{"WK_IMPDESC",,"Descripción"})
aAdd(TB_Campos,{"WKPERC" ,,"% Alicuota","@E 999.99"})
aAdd(TB_Campos,{"WKBASE" ,,"Base $" ,"@E 99,999,999,999.99"})
aAdd(TB_Campos,{"WKVALOR",,"Valor $","@E 99,999,999,999.99"})

cCod     :=Work1->WK_OPERACA+Work1->WKTEC+Work1->WKEX_NCM+Work1->WKEX_NBM
cNumNFE  :=Work1->WK_NFE
cSerieNFE:=Work1->WK_SE_NFE
dDtNFE   :=IF(EMPTY(Work1->WK_DT_NFE),dDataBase,Work1->WK_DT_NFE)

oMainWnd:ReadClientCoords()
@ 000,oMainWnd:nLeft TO 350,oMainWnd:nRight-200 DIALOG oDlgImp TITLE cTit

nLin:=18
@nLin    ,nCo1 SAY (STR0094) //"N§ da N.F."
@nLin+=13,nCo1 SAY (STR0095) //"S‚rie"
@nLin+=13,nCo1 SAY STR0096 //"Data da N.F."
@nLin+=13,nCo1 SAY STR0058 //"Vl. Mercadoria"

nLin:=18
@nLin    ,nCo2 GET cNumNFE   PICTURE "@!" VALID DI154Valid("NFE")       SIZE 57,8 WHEN nTipoNF # 4 .AND. !lNFAutomatica
@nLin+=13,nCo2 GET cSerieNFE PICTURE "@!" VALID DI154Valid("SERIE",.F.) SIZE 15,8 WHEN nTipoNF # 4 .AND. !lNFAutomatica
@nLin+=13,nCo2 GET dDtNFE    VALID DI154Valid("DATA")                   SIZE 40,8 WHEN nTipoNF # 4 //CUSTO_REAL
@nLin+=13,nCo2 GET nVLMERC   VALID nVLMERC>=0 PICTURE PICT15_2          SIZE 57,8

nLin:=18
@nLin    ,nCo3 SAY STR0124 //"Valor FOB"
@nLin+=13,nCo3 SAY STR0125 //"Valor Seguro"
@nLin+=13,nCo3 SAY STR0126 //"Valor Frete"
@nLin+=13,nCo3 SAY STR0127 //"Valor CIF"

nLin:=18
@nLin    ,nCo4 GET nFOBRS    VALID nFOBRS >=0 PICTURE PICT15_2    SIZE 55,8
@nLin+=13,nCo4 GET nSeguro   VALID nSeguro>=0 PICTURE PICT15_2    SIZE 55,8
@nLin+=13,nCo4 GET nFrete    VALID nFrete >=0 PICTURE PICT15_2    SIZE 55,8
@nLin+=13,nCo4 GET nVLCIF    VALID nVLCIF >=0 PICTURE PICT15_2    SIZE 55,8
nLin+=15

oMark1:=MsSelect():New("WorkTES",,,TB_Campos,.F.,@cMarca,{nLin,005,nLin+100,(oDlgImp:nClientWidth-4)/2},"U_ICPADFiltra(cFiltro)","U_ICPADFiltra(cFiltro)")
oMark1:bAval:={||ICPadImpAltera()}

ACTIVATE DIALOG oDlgImp ON INIT EnchoiceBar(oDlgImp,;
         {||If(EVAL(bValid),(nOpcA:=1,oDlgImp:End()),)},;
         {||nOpcA:=0, oDlgImp:End()}) CENTERED

If nOpca = 0
   Return .F.
Endif
Work1->(DBSETORDER(1))
Work1->(DBGOTO(nRecno))
Work2->(DBSEEK(Work1->WK_CFO+Work1->WK_OPERACA+Work1->WKTEC+Work1->WKEX_NCM+Work1->WKEX_NBM))

Work1->WK_NFE   := cNumNFE
Work1->WK_SE_NFE:= cSerieNFE
Work1->WK_DT_NFE:= dDtNFE
Work1->WKCIF    := nCif
Work1->WKFOB_R  := nFOBRS
Work1->WKFRETE  := nFrete
Work1->WKVALMERC:= nVLMERC
Work1->WKSEGURO := nSeguro

IF nTipoNF == 2//NFE_COMPLEMEN
   Work1->WKOUT_DESP:= nVLMERC
ENDIF

Work1->(DBGOTO(nRecno))
Work3->(DBSEEK(Work1->(RECNO())))

WHILE !Work3->(EOF()) .AND. Work1->(RECNO()) == Work3->WKRECNO
   Work3->WK_NF_COMP:=cNumNFE
   Work3->WK_SE_NFC :=cSerieNFE
   Work3->WK_DT_NFC :=dDtNFE
   Work3->(DBSKIP())
ENDDO

// Subtrai os valores anteriores da tela principal
n_CIF    := DITRANS((n_CIF    - nCVLCIF),2)
nFOB_R   := DITRANS((nFOB_R   - nCFOBRS),2)
n_FRETE  := DITRANS((n_FRETE  - nCFrete),2)
n_SEGURO := DITRANS((n_SEGURO - nCSeguro ),2)

// Soma os novos valores na tela principal
n_CIF    := DITRANS((n_CIF    + nVLCIF),2)
nFOB_R   := DITRANS((nFOB_R   + nFOBRS),2)
n_FRETE  := DITRANS((n_FRETE  + nFrete),2)
n_Vl_Fre := DITRANS((n_FRETE  / IF(EMPTY(n_Tx_Fre),1,n_Tx_Fre)),2)
n_SEGURO := DITRANS((n_SEGURO + nSeguro),2)
n_Vl_USS := DITRANS((n_SEGURO / IF(EMPTY(SW6->W6_TX_SEG),1,SW6->W6_TX_SEG)),2)
n_ValM   := DITRANS(n_CIF,2)
n_TotNFE := DITRANS(n_ValM,2)
n_VlTota := DITRANS((n_TotNFE +MDI_OUTR),2)

RETURN NIL
*---------------------------------------*
STATIC Function ICPadImpAltera()
*---------------------------------------*
LOCAL oDlg, nOpcA:=0,nLin:=18, nRecno:=WorkTES->(RECNO())
LOCAL cImp  :=WorkTES->WK_IMP
LOCAL cNCM  :=WorkTES->WK_NCM
LOCAL nPERC :=WorkTES->WKPERC
LOCAL nBASE :=nOldBASE :=WorkTES->WKBASE
LOCAL nVALOR:=nOldVALOR:=WorkTES->WKVALOR
LOCAL bEqual:={||nPERC ==WorkTES->WKPERC .AND.;
                 nBASE ==WorkTES->WKBASE .AND.;
                 nVALOR==WorkTES->WKVALOR}

@ 000,oMainWnd:nLeft TO 150,oMainWnd:nRight-550 DIALOG oDlg TITLE "Modificacion de Impuesto: "+WorkTES->WK_IMP

@nLin,05 SAY "% Alicuota"
@nLin,40 GET nPERC  PICTURE "@E 999.99" SIZE 60,8

@nLin+=18,05 SAY "Base $"
@nLin    ,40 GET nBASE  PICTURE PICT15_2    SIZE 60,8

@nLin+=18,05 SAY "Valor $"
@nLin    ,40 GET nVALOR PICTURE PICT15_2    SIZE 60,8

ACTIVATE DIALOG oDlg ON INIT EnchoiceBar(oDlg,;
{|| If(Eval(bEqual),nOpcA:=0,(nOpcA:=1,oDlg:End()))},;
{|| nOpcA:=0, oDlg:End()}) CENTERED

If nOpcA = 0
   Return .F.
Endif
WorkTES->(DBSEEK("TOTAIS"+SPACE(LEN(cNCM))+cImp))
WorkTES->WKBASE :=DITRANS((WorkTES->WKBASE -nOldBASE )+nBASE ,2)
WorkTES->WKVALOR:=DITRANS((WorkTES->WKVALOR-nOldVALOR)+nVALOR,2)

WorkTES->(DBSEEK("TOTAIS"+cNCM+cImp))
WorkTES->WKBASE :=DITRANS((WorkTES->WKBASE -nOldBASE )+nBASE ,2)
WorkTES->WKVALOR:=DITRANS((WorkTES->WKVALOR-nOldVALOR)+nVALOR,2)

WorkTES->(DBGOTO(nRecno))
WorkTES->WKPERC :=nPERC
WorkTES->WKBASE :=nBASE
WorkTES->WKVALOR:=nVALOR

Work1->WKIMPOSTOS:=DITRANS((Work1->WKIMPOSTOS-nOldVALOR)+nVALOR,2)
nTotImpostos     :=DITRANS((nTotImpostos     -nOldVALOR)+nVALOR,2)
oMark:oBrowse:Refresh()

Return .T.

*-----------------------------------------*
USER Function ICPADFiltra(cFiltro)
*-----------------------------------------*
RETURN cFiltro
*-----------------------------------------------*
STATIC Function ICGeraDespesas()
*-----------------------------------------------*
LOCAL N:=0, J:=0//ASR 18/10/2005
ProcRegua(LEN(aRecWork1))
aCampos:={}
AADD(aCampos,"WKCOD_I"   );AADD(aCampos,"WKTEC"    );AADD(aCampos,"WKEX_NCM" )
AADD(aCampos,"WKEX_NBM"  );AADD(aCampos,"WKDESCR"  );AADD(aCampos,"WKFORN"   )
AADD(aCampos,"WKUNI"     );AADD(aCampos,"WKSI_NUM" );AADD(aCampos,"WKPESOL"  )
AADD(aCampos,"WKPO_NUM"  );AADD(aCampos,"WKPO_SIGA");AADD(aCampos,"WKLOJA"   )
AADD(aCampos,"WKREC_ID"  );AADD(aCampos,"WK_CC"    );AADD(aCampos,"WK_CFO"   )
AADD(aCampos,"WK_NFE"    );AADD(aCampos,"WK_SE_NFE");AADD(aCampos,"WK_DT_NFE")
AADD(aCampos,"WK_OPERACA");AADD(aCampos,"WKPOSICAO");AADD(aCampos,"WKQTDE")
AADD(aCampos,"WKPGI_NUM" );AADD(aCampos,"WK_REG"   )
aDados:=ARRAY(LEN(aCampos))

FOR N := 1 TO LEN(aRecWork1)

    Work1->(dbGoTo(aRecWork1[N]))
    IncProc()
    IF Work3->(DBSEEK(aRecWork1[N]))

       Work1->WKVALMERC :=Work3->WKVALOR//Preco Total
       Work1->WKPRUNI   :=Work1->WKVALMERC / Work1->WKQTDE//Preco Unitario
       Work1->WK_NFE    :=Work3->WK_NF_COMP
       Work1->WK_DT_NFE :=Work3->WK_DT_NFC
       Work1->WKDESPESA :=Work3->WKDESPESA
       Work1->WKOUT_DESP:=Work3->WKVALOR//Preco Total
          Work1->WKFORN :=Work3->WKFORN
          Work1->WKLOJA :=Work3->WKLOJA
       IF EMPTY(Work1->WK_NFE)
          Work1->WKFLAG :=cMarca
       ELSE
          Work1->WKFLAG :=''
       ENDIF
       Work3->(DBSKIP())

       DO WHILE !Work3->(EOF()) .AND. aRecWork1[N] == Work3->WKRECNO
   
          For J := 1 To LEN(aCampos)
              aDados[J]:=Work1->(FieldGet(FieldPos(aCampos[J])))
          Next

          Work1->(DBAPPEND())

          For J := 1 To LEN(aCampos)
             IF !EMPTY(aDados[J])
                Work1->(FieldPut(FieldPos(aCampos[J]),aDados[J]))
             ENDIF
          Next

          Work1->WKVALMERC :=Work3->WKVALOR//Preco Total
          Work1->WKPRUNI   :=Work1->WKVALMERC / Work1->WKQTDE//Preco Unitario
          Work1->WK_NFE    :=Work3->WK_NF_COMP
          Work1->WK_DT_NFE :=Work3->WK_DT_NFC
          Work1->WKDESPESA :=Work3->WKDESPESA
          Work1->WKOUT_DESP:=Work3->WKVALOR//Preco Total
          Work1->WKFORN :=Work3->WKFORN
          Work1->WKLOJA :=Work3->WKLOJA
          IF EMPTY(Work1->WK_NFE)
             Work1->WKFLAG :=cMarca
          ELSE
             Work1->WKFLAG :=''
          ENDIF
          Work3->(DBSKIP())
   
       EndDo
   
    Endif

NEXT

RETURN .F.
*-----------------------------------------------*
STATIC Function ICGeraImpostos(lComplementar)
*-----------------------------------------------*
Local lEof	:=	.F.
LOCAL I:=0//ASR 18/10/2005
aDesp:={};aTotais:={};nTotImpostos:=0
ProcRegua(Work1->(LastRec()))
WorkTES->(__DBZAP())
Work1->(DBGOTOP())
DO WHILE Work1->(!EOF())
   IncProc()
   IF !lComplementar
      lGera:=!EMPTY(Work1->WKTEC) .AND. ;
             SYD->(DbSeek(xFilial("SYD")+Work1->WKTEC+Work1->WKEX_NCM+Work1->WKEX_NBM)) .AND. ;
             !EMPTY(SYD->YD_TES)
   ELSE
      lGera:=!EMPTY(Work1->WKDESPESA) .AND. ;
             SYB->(DbSeek(xFilial("SYB")+LEFT(Work1->WKDESPESA,3))) .AND. ;
             !EMPTY(SYB->YB_TES)
   ENDIF

   IF lGera
      aDesp:={}
      Work1->(DbSkip())
      lEof :=Work1->(EOF())
      Work1->(DbSkip(-1))
      IF !lComplementar
         IF Work3->(DBSEEK(Work1->(RECNO())))
            DO WHILE !Work3->(EOF()) .AND. Work1->(RECNO()) == Work3->WKRECNO
               IF SYB->(DbSeek(xFilial("SYB")+LEFT(Work3->WKDESPESA,3))) .AND. !EMPTY(SYB->YB_IMPINS)
                  AADD(aDesp,{LEFT(Work3->WKDESPESA,3),Work3->WKVALOR,SYB->YB_IMPINS})
               ENDIF
               Work3->(DBSKIP())
            ENDDO
         ENDIF
         aTab:=CalcImpGer(SYD->YD_TES,,,Work1->WKCIF    ,,,,aDesp,Work1->WKTEC+Work1->WKEX_NCM+Work1->WKEX_NBM,MDI_CIF,lEof)
      ELSE
         aTab:=CalcImpGer(SYB->YB_TES,,,Work1->WKVALMERC,,,,aDesp,,MDI_OUTR,lEof)
      ENDIF
      IF !EMPTY(aTab)
         Work1->WKIMPOSTOS:=0//Eh preciso Zerar por causa da alteracao do peso
         SFB->(DBSETORDER(1))
         FOR I := 1 TO LEN(aTab[6])
            WorkTES->(DBAPPEND())
            WorkTES->WKRECNO   :=STRZERO(Work1->(RECNO()),6)
            WorkTES->WKITEM    :=Work1->WKCOD_I
            WorkTES->WK_IMP    :=aTab[6,I,1]
            WorkTES->WK_NCM    :=Work1->WK_CFO+Work1->WK_OPERACA+Work1->WKTEC+Work1->WKEX_NCM+Work1->WKEX_NBM
            SFB->(DBSEEK(xFilial("SFB")+WorkTES->WK_IMP))
            WorkTES->WK_IMPDESC:=LEFT(SFB->FB_DESCR,20)
            WorkTES->WKPERC    :=aTab[6,I,2]
            WorkTES->WKBASE    :=aTab[6,I,3]
            WorkTES->WKVALOR   :=aTab[6,I,4]
            WorkTES->WKVLR_CPO :=SUBSTR(aTab[6,I,6],3)
            WorkTES->WKBAS_CPO :=SUBSTR(aTab[6,I,7],3)
            WorkTES->WKALI_CPO :="_ALQIMP"+RIGHT(ALLTRIM(aTab[6,I,7]),1)
            IF (nPos:=ASCAN(aTotais,{|aDesp|aDesp[1]==WorkTES->WK_IMP.AND.aDesp[4]==WorkTES->WK_NCM} )) == 0
               AADD(aTotais,{WorkTES->WK_IMP,DITRANS(WorkTES->WKVALOR,2),DITRANS(WorkTES->WKBASE,2),WorkTES->WK_NCM} )
            ELSE
               aTotais[nPos,2]+=DITRANS(WorkTES->WKVALOR,2)//Valor
               aTotais[nPos,3]+=DITRANS(WorkTES->WKBASE ,2)//Base
            ENDIF
            Work1->WKIMPOSTOS +=DITRANS(WorkTES->WKVALOR,2)
         NEXT
         nTotImpostos+=Work1->WKIMPOSTOS
      ENDIF
   ENDIF
   Work1->(DBSKIP())
ENDDO
ProcRegua(LEN(aTotais))
SFB->(DBSETORDER(1))
FOR I := 1 TO LEN(aTotais)
   IncProc()
   //TOTAL GERAL
   SFB->(DBSEEK(xFilial("SFB")+aTotais[I,1]))
   IF !WorkTES->(DBSEEK( "TOTAIS"+SPACE(LEN(WorkTES->WK_NCM))+aTotais[I,1] ))
      WorkTES->(DBAPPEND())
      WorkTES->WKRECNO   :="TOTAIS"
      WorkTES->WK_IMP    :=aTotais[I,1]
      WorkTES->WK_IMPDESC:=LEFT(SFB->FB_DESCR,20)
   ENDIF
   WorkTES->WKVALOR   +=aTotais[I,2]
   WorkTES->WKBASE    +=aTotais[I,3]
   //TOTAL POR NCM
   WorkTES->(DBAPPEND())
   WorkTES->WKRECNO   :="TOTAIS"
   WorkTES->WK_IMP    :=aTotais[I,1]
   WorkTES->WK_NCM    :=aTotais[I,4]
   WorkTES->WK_IMPDESC:=LEFT(SFB->FB_DESCR,20)
   WorkTES->WKVALOR   :=aTotais[I,2]
   WorkTES->WKBASE    :=aTotais[I,3]
NEXT

Work1->(DBGOTOP())
Return .T.            

*------------------------------------------------*
Static Function ICPADGrava(cAlias,aGrvImpSD1)
*------------------------------------------------*
LOCAL I:=0//ASR 18/10/2005
IF cAlias = "SD1"

   nCpoVLR:=(cAlias)->( FIELDPOS(RIGHT(cAlias,2)+WorkTES->WKVLR_CPO) )
   nCpoBAS:=(cAlias)->( FIELDPOS(RIGHT(cAlias,2)+WorkTES->WKBAS_CPO) )
   nCpoALI:=(cAlias)->( FIELDPOS(RIGHT(cAlias,2)+WorkTES->WKALI_CPO) )
   
   IF nCpoVLR # 0 .AND. nCpoBAS # 0
      AADD(aGrvImpSD1,{ (cAlias)->(FIELD(nCpoVLR)),WorkTES->WKVALOR,NIL} )
      AADD(aGrvImpSD1,{ (cAlias)->(FIELD(nCpoBAS)),WorkTES->WKBASE ,NIL} )
   ENDIF
   IF nCpoALI # 0
      AADD(aGrvImpSD1,{ (cAlias)->(FIELD(nCpoALI)),WorkTES->WKPERC ,NIL})
   ENDIF

ELSEIF cAlias $ "SWN,EI2"
   IF nTipoNF # 4 //CUSTO_REAL
      nCpoVLR:=(cAlias)->( FIELDPOS(RIGHT(cAlias,2)+WorkTES->WKVLR_CPO) )
      nCpoBAS:=(cAlias)->( FIELDPOS(RIGHT(cAlias,2)+WorkTES->WKBAS_CPO) )
      nCpoALI:=(cAlias)->( FIELDPOS(RIGHT(cAlias,2)+WorkTES->WKALI_CPO) )
   ELSE
      nCpoVLR:=(cAlias)->( FIELDPOS(cAlias+STUFF(WorkTES->WKVLR_CPO,7,1,"")) )
      nCpoBAS:=(cAlias)->( FIELDPOS(cAlias+STUFF(WorkTES->WKBAS_CPO,7,1,"")) )
      nCpoALI:=(cAlias)->( FIELDPOS(cAlias+STUFF(WorkTES->WKALI_CPO,7,1,"")) )
   ENDIF                     
   ICPADPut(cAlias,WorkTES->WKVALOR,WorkTES->WKBASE,WorkTES->WKPERC)
ELSE
// (cAlias)->(RecLock(cAlias,.F.))
   FOR I := 1 TO LEN(aValores)
      IF nTipoNF # 4 //CUSTO_REAL
         nCpoVLR:=(cAlias)->( FIELDPOS(RIGHT(cAlias,2)+aValores[I,4]) )
         nCpoBAS:=(cAlias)->( FIELDPOS(RIGHT(cAlias,2)+aValores[I,5]) )
      ELSE
         nCpoVLR:=(cAlias)->( FIELDPOS(cAlias+STUFF(aValores[I,4],7,1,"")) )
         nCpoBAS:=(cAlias)->( FIELDPOS(cAlias+STUFF(aValores[I,5],7,1,"")) )
      ENDIF                       
      nCpoALI:=0
      ICPADPut(cAlias,aValores[I,2],aValores[I,3],0)
   NEXT
   aValores:={}
// (cAlias)->(MSUNLOCK())
ENDIF

RETURN .T.
*----------------------------------------------------*
Static Function ICPADPut(cAlias,nValor,nBase,nAliq)
*----------------------------------------------------*
IF nCpoVLR # 0 .AND. nCpoBAS # 0
   (cAlias)->( FIELDPUT(nCpoVLR, (FIELDGET(nCpoVLR)+nValor) ) )
   (cAlias)->( FIELDPUT(nCpoBAS, (FIELDGET(nCpoBAS)+nBase ) ) )
ENDIF
IF nCpoALI # 0
   (cAlias)->( FIELDPUT(nCpoALI, (FIELDGET(nCpoALI)+nAliq ) ) )
ENDIF
RETURN .T.
*------------------------------------------------*
Function ICPadTab(cTes)
*------------------------------------------------*
LOCAL ATAB:={}, cFil:=xFilial("SFC")
SFC->(DBSETORDER(1))
SFC->(DBSEEK(xFilial("SFC")+cTes))
DO WHILE cTes == SFC->FC_TES .AND. SFC->(!EOF()) .AND. cFil == SFC->FC_FILIAL
   IF SFB->(DBSEEK(xFilial("SFB")+SFC->FC_IMPOSTO))
//    AADD(ATAB,{ SFC->FC_IMPOSTO,"_ALQIMP"+RIGHT(ALLTRIM(SFB->FB_CPOVREI),1),SUBSTR(SFB->FB_CPOVREI,3),SUBSTR(SFB->FB_CPOBAEI,3) })
      AADD(ATAB,{ SFC->FC_IMPOSTO,"_ALQIMP"+SFB->FB_CPOLVRO,"_VALIMP"+SFB->FB_CPOLVRO,"_BASIMP"+SFB->FB_CPOLVRO })
   ENDIF
   SFC->(DBSKIP())
ENDDO
RETURN ATAB
//--------------------------------------------------------------------------------------*
//                FIM DO PROGRAMA ICPADDI0_AP5.PRW - MERCOSUL
//--------------------------------------------------------------------------------------*
