#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.ch"    
#INCLUDE "AVERAGE.CH"

/*
Função   :EICSTATPROD()
Autor    :Igor de Araújo Chiba 
Objetivo : Relatorio de status dos itens importados por conta e ordem
Data     : 13/02/2009
*/
*---------------------------------------------------------
User Function EICSTATPROD()
*---------------------------------------------------------
LOCAL oDlg
LOCAL lOk:=.F.
LOCAL lRelat  := .F.
 
LOCAL bCancel :={||lOk:=.T. , oDlg:End()}
LOCAL bOk     :={||lOk:=.F. , oDlg:End()}

LOCAL nLinha1    := 20
LOCAL nCol1      := 2
LOCAL nCol2      := 40
LOCAL nCol3      := 95
LOCAL nCol4      := 125
LOCAL nPulaLinha := 15
PRIVATE  lImportador:=GETMV("MV_PCOIMPO",,.T.)//Se for importador é .T., e Adquirente é .F.

IF !lImportador
   MSGSTOP("Esse relatorio só serve para controle do Importador.")
   Return .t.
ENDIF

PRIVATE  cTit1    := "Relatório de Status de Itens Importados Por Conta e Ordem"
PRIVATE  aStru    := {}
PRIVATE  cCliente := SPACE(LEN(SW2->W2_CLIENTE))     
PRIVATE  cProdIni := SPACE(LEN(SW3->W3_COD_I))
PRIVATE  cProdFin := SPACE(LEN(SW3->W3_COD_I))
PRIVATE  dEmbFin  := CTOD(" / / ")
PRIVATE  dEmbIni  := CTOD(" / / ") 
PRIVATE  cFilSW2  := XFILIAL("SW2")
PRIVATE  cFilSW3  := XFILIAL("SW3")
PRIVATE  cFilSB1  := XFILIAL("SB1")
PRIVATE  cFilSW6  := XFILIAL("SW6")
PRIVATE  cFilSW7  := XFILIAL("SW7")
PRIVATE  cFilSA1  := XFILIAL("SA1")
PRIVATE  cFilSA2  := XFILIAL("SA2")
PRIVATE  cNomArqu := "" 
PRIVATE  WORKInd1 := ""  
PRIVATE  cPictQtde:= AVSX3("W3_QTDE"    ,6) 
PRIVATE  aDados   := {}
PRIVATE  aRCampos := {}
PRIVATE  cMV_EASY   :=GETMV('MV_EASY')//Se for "S" é integrado com Microsiga

SB1->(DBSETORDER(1))
SW2->(DBSETORDER(1))
SW6->(DBSETORDER(1)) 
SA1->(DBSETORDER(1))
SA2->(DBSETORDER(1)) 
SW7->(DBSETORDER(2)) 

DO WHILE .T.
   DEFINE MSDIALOG oDlg TITLE cTit1 FROM 0,0 TO 180,400 OF oDlg PIXEL 
      nLinha1 := 20
      lOK     := .F.
     
     @nLinha1,nCol1  SAY "Prod.Inicial"  SIZE 35,10 OF oDlg PIXEL
     @nLinha1,nCol2  MSGET cProdIni      SIZE 50,08 OF oDlg PIXEL   F3 "SB1" VALID (VAZIO() .OR. (ExistCPO("SB1").AND. ValDtEmb('I',.T.)) )   
     @nLinha1,nCol3  SAY "Prod.Final"    SIZE 35,10 OF oDlg PIXEL
     @nLinha1,nCol4  MSGET cProdFin      SIZE 50,08 OF oDlg PIXEL   F3 "SB1" VALID (VAZIO() .OR. (ExistCPO("SB1").AND. ValDtEmb('F',.T.)) )
     nLinha1+=nPulaLinha
     
     @nLinha1,nCol1  SAY "Dt.Emb.Inicial" SIZE 35,10 OF oDlg PIXEL
     @nLinha1,nCol2  MSGET dEmbIni        SIZE 50,08 OF oDlg PIXEL  VALID ( VAZIO() .OR. ValDtEmb('I',.F.))                                        
     @nLinha1,nCol3  SAY "Dt.Emb.Final"   SIZE 35,10 OF oDlg PIXEL
     @nLinha1,nCol4  MSGET dEmbFin        SIZE 50,08 OF oDlg PIXEL  VALID ( VAZIO() .OR. ValDtEmb('F',.F.) )
     nLinha1+=nPulaLinha   
      
     @nLinha1,nCol1  SAY "Cliente"       SIZE 30,08 OF oDlg PIXEL
     @nLinha1,nCol2  MSGET cCliente      SIZE 50,08 OF oDlg PIXEL   F3 "SA1"  VALID (VAZIO() .OR.ExistCPO("SA1")) 
     
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bCancel,bOK ) CENTERED
  
   IF lOk  
      #ifdef TOP
         Processa( {||lRelat:= Query()} ,"Pesquisando Dados",,.T.)  
      #else
         Processa( {||lRelat:= PesqDado()} ,"Pesquisando Dados",,.T.)  
      #endif
      
      IF lRelat
         Processa( {||Relatorio()} ,"Gerando Relatorio",,.T.)  
         WORK->(E_ERASEARQ(cNomArqu))
      ENDIF                                                    
      Loop
   Else      
      Exit   
   ENDIF

ENDDO 

RETURN .T.

/*
Função   :ValDtEmb(cTipo)
Autor    :Igor de Araújo Chiba 
Objetivo : Validar data inicial e final
Paramentro: cTipo, se for I=trata da data inicial se for F=trata da data final, lProd .t. se for valid do produto e .f. se for valid da data
Data     : 13/02/2009
*/
*------------------------------------------------------------*
STATIC FUNCTION ValDtEmb(cTipo,lProd)
*------------------------------------------------------------*
LOCAL lRet  :=.T.                                                   

IF lProd     //valida produtos
   If cTipo == 'I'
       IF !EMPTY(cProdFin) .AND. cProdFin < cProdIni
          Alert('Produto inicial nao pode ser maior que Produto final')
       lRet := .F.
    ENDIF
   EndIf    

   If cTipo == 'F'
       IF !EMPTY(cProdIni) .AND. cProdIni > cProdFin
          Alert('Produto Final nao pode ser menor que Produto Inicial')
          lRet := .F.
       ENDIF
   EndIF
ELSE  //valida datas
   If cTipo == 'I'
       IF !EMPTY(dEmbFin) .AND. dEmbIni > dEmbFin
          Alert('Data inicial nao pode ser maior que data final')
       lRet := .F.
    ENDIF
   EndIf    

   If cTipo == 'F'
       IF !EMPTY(dEmbIni) .AND. dEmbIni > dEmbFin   
          Alert('Data Final nao pode ser menor que data Inicial')
          lRet := .F.
       ENDIF
   EndIF
ENDIF

RETURN lRet   



/*
Função:Query())
Autor: Igor de Araújo Chiba
Data:13/02/009
Parametros:nenhum
Objetivo: Função que irá realizar uma query através dos filtros selecionados
*/
#ifdef TOP
*-----------------------------*
Static Function Query()
*-----------------------------*                 
LOCAL cQuery1
LOCAL cQuery2
LOCAL cCampos 
LOCAL nTotal     :=10
LOCAL nCont      :=0  
LOCAL aPO        := {}  
LOCAL nI         := 0   
LOCAL nTamSx3    := AVSX3("B1_VM_I",3) //guardar tamanho da variavel B1_VM_I
LOCAL cDescProd  := ''

CriaEstrutura()    

ProcRegua(nTotal) 
//TRAZENDO PEDIDO QUE TENHAM CLIENTE E SEJAM DE CONTA E ORDEM 
cQuery1 := "(SELECT W2.W2_PO_NUM FROM "+RetSqlName("SW2")+" WHERE" 
cQuery1 += " W2.W2_IMPCO = '1'"
IF !EMPTY(cCliente)
   cQuery1 += " AND W2.W2_CLIENTE = '"+ALLTRIM(cCliente)+"'" 
ENDIF
cQuery1 += " AND W2.D_E_L_E_T_ <> '*'"
cQuery1 += " AND W2.W2_FILIAL ='"+cFilSW2+"')" 

//TRAZER OS ITENS DOS PEDIDOS ACIMA 
cCampos := "W3.W3_COD_I,W3.W3_POSICAO,W3.W3_PO_NUM,W3.W3_FLUXO,W3.W3_QTDE,W3.W3_DT_EMB,W3.W3_FORN"
cQuery2 := "SELECT "+ cCampos +" FROM "+RetSqlName("SW3")+" W3,"+RetSqlName("SW2") +" W2 WHERE"
cQuery2 += " W3.W3_PO_NUM IN "+cQuery1  
IF !EMPTY(cProdIni )
   cQuery2 += " AND W3.W3_COD_I>= '"+ALLTRIM(cProdIni)+"'"
ENDIF                                                   
IF !EMPTY(cProdFin )
   cQuery2 += " AND W3.W3_COD_I<= '"+ALLTRIM(cProdFin)+"'"
ENDIF                                                   
IF !EMPTY(dEmbIni )
   cQuery2 += " AND W3.W3_DT_EMB >= '"+DTOS(dEmbIni)+"'"
ENDIF                                                   
IF !EMPTY(dEmbFin )
   cQuery2 += " AND W3.W3_DT_EMB <= '"+DTOS(dEmbFin)+"'"
ENDIF  
cQuery2 += " AND W3.D_E_L_E_T_ <> '*'"
cQuery2 += " AND W3.W3_FILIAL ='"+cFilSW3+"'"


cQuery  :=ChangeQuery(cQuery2)
Dbusearea(.T.,"TOPCONN",TcGenQry(,,cQuery2 ),"QRY",.F.,.T.)  

TCSetField("QRY", "W3_DT_EMB","D")

WORK->(DBGOTOP())
DO WHILE QRY->(!EOF())
   If nCont > nTotal
      ProcRegua(nTotal)
      nCont:=0 
   EndIf 
   nCont++
   IncProc('Pesquisando Item ')

   WORK->(DBAPPEND())
   SW2->(DBSEEK(cFilSW2+QRY->W3_PO_NUM ))
   WORK->WK_CLIENTE  := SW2->W2_CLIENTE   
   IF SA1->(DBSEEK(cFilSA1+SW2->W2_CLIENTE ))
       WORK->WK_CLIENTE  := ALLTRIM(WORK->WK_CLIENTE)+'-'+ALLTRIM(SA1->A1_NREDUZ)
      //WORK->WK_NOMCLI  := SA1->A1_NREDUZ
   ENDIF                                                   
   WORK->WK_PO_NUM   := QRY->W3_PO_NUM
   IF ASCAN(aPO,QRY->W3_PO_NUM) == 0
      AADD(aPO,AVKEY(QRY->W3_PO_NUM,"W3_PO_NUM"))
   ENDIF                
   WORK->WK_COD_I    := ALLTRIM(QRY->W3_COD_I )
   DBSELECTAREA("SB1")
   IF SB1->(DBSEEK(cFilSB1+QRY->W3_COD_I))  .AND. !EMPTY(SB1->B1_DESC_I)
     cDescProd         := MSMM(SB1->B1_DESC_I,nTamSx3) 
     WORK->WK_DESC     := STRTRAN(cDescProd ,CHR(13)+CHR(10),' ')
   ENDIF  
   WORK->WK_DT_EMB    := DTOC(QRY->W3_DT_EMB)  
   WORK->WK_QTDE_P    := QRY->W3_QTDE     //PEDIDO  
   WORK->WK_POSICAO   := QRY->W3_POSICAO  
   WORK->WK_FORN      := QRY->W3_FORN  
   IF SA2->(DBSEEK(cFilSA2+QRY->W3_FORN ))
      WORK->WK_NFORN  := SA2->A2_NREDUZ
   ENDIF

   QRY->(DBSKIP())
ENDDO
QRY->(DBCLOSEAREA())
DBSELECTAREA("WORK")

IF WORK->(LASTREC())=0
   Alert("Nao foi encontrado registro nenhum para os filtros selecionados ") 
   WORK->(E_ERASEARQ(cNomArqu))
   RETURN .F.
ENDIF
  
WORK->(DBSETORDER(1))


nTotal := len (aPO)
nCont  := 1 

FOR nI:=1 to len(aPO)
   IncProc('Gravando Itens  '+ALLTRIM(STR(nCont))+"/"+ALLTRIM(str(nTotal)) )
   nCont++
   IF SW7->(DBSEEK(cFilSW7+aPO[nI] )) //.AND. SW6->(DBSEEK(cFilSW6+SW7->W7_HAWB))
      DO WHILE  SW7->(!EOF()) .AND. SW7->W7_FILIAL == cFilSW7 .AND. SW7->W7_PO_NUM == aPO[nI]
         IF WORK->(DBSEEK(SW7->W7_PO_NUM+SW7->W7_COD_I+SW7->W7_POSICAO))
            WORK->WK_QTDE_EM += SW7->W7_QTDE //embarque
            WORK->WK_PO_NUM  := SW7->W7_PO_NUM
            IF SW6->(DBSEEK(cFilSW6+SW7->W7_HAWB))
               IF(!EMPTY(SW6->W6_DT_ENTR) ,WORK->WK_QTDE_EN+= SW7->W7_QTDE,) //entregue
               IF cMV_EASY =='S' 
                  IF PVNFS() //pedido de venda tem NFS
                     WORK->WK_QTDE_ES += SW7->W7_QTDE
                  ENDIF    
               ELSE 
                  IF(SW6->W6_MERCTRA =='1'   ,WORK->WK_QTDE_ES+= SW7->W7_QTDE,) //transferido
               ENDIF
            ENDIF
         ENDIF
         SW7->(DBSKIP())
      ENDDO    
   ENDIF
NEXT
   
WORK->(DBGOTOP())

Return .T.    

#else

*-----------------------------*
Static Function PesqDado               
*-----------------------------*   
LOCAL nTotal     :=10
LOCAL nCont      := 1  
LOCAL aPO        := {}  
LOCAL nI         := 0   
LOCAL nTamSx3    := AVSX3("B1_VM_I",3) //guardar tamanho da variavel B1_VM_I
LOCAL cDescProd  := ''
LOCAL cFiltroSW2 := "SW2->W2_IMPCO == '1'"
LOCAL cFiltroSW3 := ".T."

CriaEstrutura()          

IF !EMPTY(cCliente)
   cFiltroSW2 +=  ".AND. SW2->W2_CLIENTE == '"+cCliente+"'"
ENDIF
bFiltroSW2 := &("{|| "+cFiltroSW2+"}")

IF !EMPTY(cProdIni )
   cFiltroSW3 += " .AND. SW3->W3_COD_I >= '"+ALLTRIM(cProdIni)+"'"
ENDIF                                                   
IF !EMPTY(cProdFin )
   cFiltroSW3 += " .AND. SW3->W3_COD_I<= '"+ALLTRIM(cProdFin)+"'"
ENDIF                                                   

IF !EMPTY(dEmbIni )
   cFiltroSW3 += " .AND. DTOS(SW3->W3_DT_EMB) >= '"+DTOS(dEmbIni)+"'"
ENDIF                                                   
IF !EMPTY(dEmbFin )
   cFiltroSW3 += " .AND. DTOS(SW3->W3_DT_EMB) <= '"+DTOS(dEmbFin)+"'"
ENDIF  
bFiltroSW3 := &("{||"+cFiltroSW3+"}")


IF SW2->(DBSEEK(cFilSW2))
   nTotal := SW2->(LASTREC())
   ProcRegua(nTotal)  
   DO WHILE SW2->(!EOF()) .AND. SW2->W2_FILIAL ==  cFilSW2 
      IncProc('Lendo Pedido: '+ALLTRIM(str(nCont))+' / '+ALLTRIM(str(nTotal)) )
      IF !EVAL(bFiltroSW2)
         SW2->(DBSKIP())  
         LOOP
      ENDIF
      IF SW3->(DBSEEK(cFilSW3+SW2->W2_PO_NUM))
         DO WHILE SW3->(!EOF()) .AND. SW3->W3_PO_NUM == SW2->W2_PO_NUM .AND. SW3->W3_FILIAL == cFilSW3
            IF EVAL(bFiltroSW3)
               WORK->(DBAPPEND())
               WORK->WK_CLIENTE  := SW2->W2_CLIENTE   
               IF SA1->(DBSEEK(cFilSA1+SW2->W2_CLIENTE ))
                  WORK->WK_CLIENTE  := ALLTRIM(WORK->WK_CLIENTE)+'-'+ALLTRIM(SA1->A1_NREDUZ)
               ENDIF                                                   
               WORK->WK_PO_NUM   := SW3->W3_PO_NUM
               IF ASCAN(aPO,SW3->W3_PO_NUM) == 0
                  AADD(aPO,SW3->W3_PO_NUM)
               ENDIF                
               WORK->WK_COD_I    := SW3->W3_COD_I 
               DBSELECTAREA("SB1")
               IF SB1->(DBSEEK(cFilSB1+SW3->W3_COD_I))  .AND. !EMPTY(SB1->B1_DESC_I)
                 cDescProd         := MSMM(SB1->B1_DESC_I,nTamSx3) 
                 WORK->WK_DESC     := STRTRAN(cDescProd ,CHR(13)+CHR(10),' ')
               ENDIF  
               WORK->WK_DT_EMB    := DTOC(SW3->W3_DT_EMB)  
               WORK->WK_QTDE_P    := SW3->W3_QTDE     //PEDIDO  
               WORK->WK_POSICAO   := SW3->W3_POSICAO  
               WORK->WK_FORN      := SW3->W3_FORN  
               IF SA2->(DBSEEK(cFilSA2+SW3->W3_FORN ))
                  WORK->WK_NFORN  := SA2->A2_NREDUZ
               ENDIF
            ENDIF   
            SW3->(DBSKIP())
         ENDDO
      ENDIF
      nCont+=1
      SW2->(DBSKIP())
   ENDDO
ENDIF              

DBSELECTAREA("WORK")

IF WORK->(LASTREC())=0
   Alert("Nao foi encontrado registro nenhum para os filtros selecionados ") 
   WORK->(E_ERASEARQ(cNomArqu))
   RETURN .F.
ENDIF
  
WORK->(DBSETORDER(1))

nTotal := len (aPO)
FOR nI:=1 to len (aPO)
   nCont++
   IncProc('Gravando Itens '+ALLTRIM(str(nCOnt) )+"/"+ALLTRIM(STR(nTotal)) )

   IF SW7->(DBSEEK(cFilSW7+aPO[nI] )) //.AND. SW6->(DBSEEK(cFilSW6+SW7->W7_HAWB))
      DO WHILE  SW7->(!EOF()) .AND. SW7->W7_FILIAL == cFilSW7 .AND. SW7->W7_PO_NUM == aPO[nI]
         IF WORK->(DBSEEK(SW7->W7_PO_NUM+SW7->W7_COD_I+SW7->W7_POSICAO))
            WORK->WK_QTDE_EM += SW7->W7_QTDE //embarque
            WORK->WK_PO_NUM  := SW7->W7_PO_NUM
            IF SW6->(DBSEEK(cFilSW6+SW7->W7_HAWB))
               IF !EMPTY(SW6->W6_DT_ENTR) 
                  WORK->WK_QTDE_EN+= SW7->W7_QTDE //entregue
               ENDIF
               IF cMV_EASY =='S' 
                  IF PVNFS() //pedido de venda tem NFS
                     WORK->WK_QTDE_ES += SW7->W7_QTDE
                  ENDIF    
               ELSE 
                  IF(SW6->W6_MERCTRA =='1'   ,WORK->WK_QTDE_ES+= SW7->W7_QTDE,) //transferido
               ENDIF
            ENDIF
         ENDIF
         SW7->(DBSKIP())
      ENDDO    
   ENDIF
NEXT
   
WORK->(DBGOTOP())

Return .T.    

#endif

/*
Função   :PVNFS()
Autor    :Igor de Araújo Chiba 
Objetivo : Verifica se o PV possui NFS
Data     : 13/02/2009
*/
*-----------------------------*
Static Function PVNFS()
*-----------------------------*
LOCAL lRet    := .F.
LOCAL cFilSC5 := XFILIAL("SC5") 
LOCAL cFilSF2 := XFILIAL("SF2") 


SC5->(DBSETORDER(1))//pedido numero
SC6->(DBSETORDER(1))//pedido numero+item+cod.produto 
SF2->(DBSETORDER(1))//HAWB    

IF SC5->(DBSEEK(cFilSC5+SW6->W6_PEDFAT)) .AND. SF2->(DBSEEK(cFilSF2+SC5->C5_NOTA+SC5->C5_SERIE))  
   lRet := .T.
ENDIF


Return lRet


/*
Função   :CriaEstrutura()
Autor    :Igor de Araújo Chiba 
Objetivo : Criar uma work area de trabaho
Data     : 13/02/2009
*/
*-----------------------------*
Static Function CriaEstrutura()
*-----------------------------*
aStru:= {}

AADD(aStru, {"WK_CLIENTE"  , "C", AVSX3("W2_CLIENTE"  ,3)+AVSX3("A1_NREDUZ"  ,3), 0})                             	                                              	
AADD(aStru, {"WK_PO_NUM"   , "C", AVSX3("W2_PO_NUM"   ,3)   , 0})
AADD(aStru, {"WK_FORN"     , "C", AVSX3("W2_FORN"     ,3)   , 0})
AADD(aStru, {"WK_NFORN"	   , "C", AVSX3("A2_NREDUZ"   ,3)   , 0})						
AADD(aStru, {"WK_COD_I"    , "C", AVSX3("W3_COD_I"    ,3)   , 0}) 						                                       
AADD(aStru, {"WK_DESC"     , "C", 50                        , 0}) 						                                       
AADD(aStru, {"WK_QTDE_P"   , "N", AVSX3("W3_QTDE"    ,3), AVSX3("W3_QTDE"      ,4)})							
AADD(aStru, {"WK_QTDE_EM"  , "N", AVSX3("W3_QTDE"    ,3), AVSX3("W3_QTDE"      ,4)}) 
AADD(aStru, {"WK_QTDE_EN"  , "N", AVSX3("W3_QTDE"    ,3), AVSX3("W3_QTDE"      ,4)}) 
AADD(aStru, {"WK_QTDE_ES"  , "N", AVSX3("W3_QTDE"    ,3), AVSX3("W3_QTDE"      ,4)}) 
//AADD(aStru, {"WK_HAWB"     , "C", AVSX3("W7_HAWB"    ,3), 0})												
AADD(aStru, {"WK_POSICAO"  , "C", AVSX3("W3_POSICAO" ,3), 0})							
AADD(aStru, {"WK_DT_EMB"   , "C", AVSX3("W3_DT_EMB"  ,3), 0})

 
DBSELECTAREA("SW7")
                                        
IF SELECT("WORK") > 0
   WORK->(E_ERASEARQ(cNomArqu))
ENDIF

cNomArqu := E_CRIATRAB(,aStru,"WORK")

//WORKInd1 :=E_Create(,.F.)

IndRegua("Work", cNomArqu+OrdBagExt(), "WK_PO_NUM+WK_COD_I+WK_POSICAO")
//Set Index To (WORKInd1+OrdBagExt())

Return .T.



/*
Função   : Relatorio()
Autor    : Igor de Araújo Chiba 
Objetivo : Criar relatorio E_Report
Data     : 17/02/2009
*/
*------------------------------------------------------------*
STATIC FUNCTION Relatorio()
*------------------------------------------------------------*
LOCAL aTB_Campos := {} 
LOCAL cCabec1    := ''  
LOCAL cCabec2    := ''                                    
LOCAL cPicture   := AVSX3("W3_QTDE",6)

cCabec1+='CLIENTE: '    + If (!EMPTY(cCliente),cCliente,'Todos')
cCabec2+='DT.EMBARQUE: '+ If (!EMPTY(dEmbIni),DTOC(dEmbIni),'//') 
cCabec2+= If (!EMPTY(dEmbFin),'  a  '+DTOC(dEmbFin),' a  // ')
cCabec2+= '                     '
cCabec2+='PRODUTO: '    + If (!EMPTY(cProdIni),alltrim(cProdIni),'') +' a '
cCabec2+= If (!EMPTY(cProdFin),alltrim(cProdFin),'')  


aDados := {"WORK",;
          "Importacao Conta Ordem",; //CAMBIO/SEGURO
          "",;
          "",;
          "G",;
          "220",;
          cCabec1,;  
          cCabec2,;
          cTit1,;
          {"Zebrado",1,"IMPORTACAO",1,2,1,"",1},;
          "EICSTATPROD",;
          {{||.T.},{||.T.}}}    


aAdd(aTB_Campos, {"WK_CLIENTE"  							 , , 'Cliente'       })
aAdd(aTB_Campos, {"WK_PO_NUM"   							 , , 'Pedido '       })
aAdd(aTB_Campos, {"WK_FORN"     							 , , 'Cod.Forn'      })
aAdd(aTB_Campos, {"WK_NFORN"     							 , , 'Fornecedor'    })
aAdd(aTB_Campos, {"WK_COD_I"    							 , , 'Cod.Item'      })
aAdd(aTB_Campos, {"WORK->WK_DESC"                            , , 'Desc.Item'     })
aAdd(aTB_Campos, {{||TRANSFORM(WORK->WK_QTDE_P ,	cPicture)}   , ,'Qtde.Pedida     '})
aAdd(aTB_Campos, {{||TRANSFORM(WORK->WK_QTDE_EM,	cPicture)}   , ,'Qtde.Embarcada  '})
aAdd(aTB_Campos, {{||TRANSFORM(WORK->WK_QTDE_EN,	cPicture)}   , ,'Qtde.Em Estoque '})
aAdd(aTB_Campos, {{||TRANSFORM(WORK->WK_QTDE_ES,	cPicture)}   , ,'Qtde.Transferida'})


aRCampos:=E_CriaRCampos(aTB_Campos)
   
E_Report(aDados,aRCampos)


RETURN .T.
