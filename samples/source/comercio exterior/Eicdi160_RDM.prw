#INCLUDE "Eicdi160.ch"
#include "rwmake.ch"        
#INCLUDE "avprint.ch"
#INCLUDE "AVERAGE.CH"

#DEFINE  LINHA_BOX  oPrn:Box( Linha   ,  50 , Linha+7 , 2280)

User Function Eicdi160()     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/* By A. Caetano Sciancalepre Jr - 22/12/2003 -----------*/
Private _PICTPO      := Alltrim(X3Picture("W2_PO_NUM"))
Private _PICTNBM     := E_Tran("YD_TEC",,.t.)
Private _PICTPRTOT   := Alltrim(X3Picture("W2_FOB_TOT"))   
/* -----------------------------------------------------*/ 

SetPrvt("UVAR>,MFLAG,LBUTTON,DI160FIM,PPARTE2>,CLOCAL")
SetPrvt("OPRINT>,OFONT>,NOPCAO,SAREA,CFILEMEN,CHOUSE")
SetPrvt("CTITULO,ODLG,OFNTDLG,BOK,BCANCEL,BINIT")
SetPrvt("APO,CREF,NCONT,AREGPLI,CLINHA,CDESCRITEM")
SetPrvt("CCONDPAG,CENDE2SM0,CTEXTOENCAMINHO,SW2CONSIG,SW2CONDPA,SW2DIASPA")
SetPrvt("SW2COMPRA,SFILIAL,BGRAVA,BWHILE,AFONTES,LINHA")
SetPrvt("I,LI_INI,AVETOR,NAUX1,NNUMERO,LI_FIM")
SetPrvt("W,SALIAS,")


#xtranslate :TIMES_NEW_ROMAN_12            => \[1\]
#xtranslate :TIMES_NEW_ROMAN_14_BOLD       => \[2\]
#xtranslate :TIMES_NEW_ROMAN_18_BOLD       => \[3\]
#xtranslate :TIMES_NEW_ROMAN_14_UNDERLINE  => \[4\]
#xtranslate :TIMES_NEW_ROMAN_10            => \[5\]
#xtranslate   bSETGET(<uVar>)              => {|u| If(PCount() == 0, <uVar>, <uVar> := u) }
#xtranslate   AVPict(<Cpo>)                => AllTrim(X3Picture(<Cpo>))


#COMMAND TRACOS_LATERAIS                   => oPrn:Box( Linha-20,   50, Linha+50, 56 ) ;
                                           ;  oPrn:Box( Linha-20, 2273, Linha+50, 2280)


#COMMAND E_RESET_AREA                      => DBSELECTAREA(sArea)


/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçao    ¦ EICDI160 ¦ Autor ¦ AVERAGE / A.C.D.      ¦ Data ¦ 03.12.97 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Emissäo da Instruçao de Despacho.                          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   ¦ #EICDI160                                                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
nOpcao:=0
sArea:=SELECT()
cFileMen:=""

WHILE .T.

// TDF - 26/05/11 - Posiciona na filial antes de inicializar a variável
SW6->(DbSeek(xFilial("SW6")) ) 
cHouse := SW6->W6_HAWB

  /*+--------------------------------------------------------------+
    ¦ Define a Dialog com get's iniciais                           ¦
    +--------------------------------------------------------------+*/

   cTitulo:=STR0001 //"EmissÒo da InstruþÒo de Despacho"

    oDlg:= oSend( MSDialog(), "New", 9, 0, 17, 50,;
                cTitulo,,,.F.,,,,,GetWndDefault(),.F.,,,.F.)

    oFntDlg := NIL
    DEFINE FONT oFntDlg  NAME "Ms Sans Serif" SIZE 0,-9

    oSend(TSay(),"New",2.0 ,1.0  ,{|| "Processo"},oDlg,,oFntdlg,,,,.F. )
    oSend(TGet(),"New",2.0 ,6.0  ,bSetGet(cHouse)    ,oDlg,50,8,;
                                  AVPict("W6_HAWB"),{|| DI160Val()   },,,oFntDlg,,,.F.,,,,,,,,,"SW6")// Substituido pelo assistente de conversao do AP5 IDE em 22/11/99 ==>                                   AVPict("W6_HAWB"),{|| Execute(DI160Val)   },,,oFntDlg,,,.F.,,,,,,,,,"SW6")
    @ 25, 160 BUTTON STR0002 SIZE 34,11 ACTION (nOpcao:=2,oSend(oDlg,'End')) of oDlg Pixel //"Mensagens"
    oSend( SButton(), "New", 25, 120 ,6 ,{||nOpcao:=1,oSend(oDlg,"End") }, oDlg, .T.,,)

    nOpcao:=0

        bOk    := {||nOpcao:=1,oSend(oDlg,"End")}
        bCancel:= {||nOpcao:=0,oSend(oDlg,"End")}

        bInit  := {|| EnchoiceBar(oDlg,bOk,bCancel) }

        oSend( oDlg, "Activate",,,,.T.,,, bInit )

        If nOpcao == 1
           Processa({|| EDI160Relatorio()})
        ELSEIf nOpcao == 2
           Processa({|| AV_ESC_OBS("7")})
        ELSEIf nOpcao == 0
           IF SELECT("WORK_MEN") #0
              Work_Men->(E_ERASEARQ(cFileMen))
           ENDIF
           E_RESET_AREA
           Return .F.
        Endif
END

Return(.T.) 

*-------------------------*
Static FUNCTION Di160Val()
*-------------------------*

*Do Case

*   Case MFlag == "HOUSE"

        If Empty( cHouse )
           Help("", 1, "AVG0000117")
           Return .F.
        Endif

        SW6->( DbSetOrder( 1 ) )
        If !SW6->( DbSeek( xFilial()+cHouse ) )
           Help("", 1, "AVG0000118")
           Return .F.
        Endif


*EndCase

Return .T.

*-------------------------------*
Static FUNCTION EDI160Relatorio()
*-------------------------------*
LOCAL nTotal := 0, i, W
LOCAL nPos, nInc   //TRP-10/10/07
LOCAL aMoedas := {} //TRP-10/10/07

aPo       := {}
cRef      := ""
nCont     := 1
aRegPli   := {}
cLinha    := ""
cDescrItem:= ""
cCondPag  := ""
cEnde2SM0 := ""
cTextoEncaminho:=STR0006 //"ENCAMINHAMOS, ANEXOS, OS DOCUMENTOS ABAIXO RELACIONADOS, PEDINDO PARA QUE O DESEMBARAÃO ADUANEIRO SEJA INSTRU-DO DA SEGUINTE MANEIRA:"
cInv:=" "

/*+---------------------------------------------------------+
  ¦   Seek's e Inicializacoes - A.C.D.                      ¦
  +---------------------------------------------------------+*/
//-----> Dados do Despachante.
SY5->( DbSetOrder( 1 ) )
SY5->( DbSeek( xFilial()+SW6->W6_DESP) )

//-----> Dados do Portos.
SW7->( DbSetOrder( 1 ) )
SW7->( DbSeek( xFilial()+SW6->W6_HAWB ) )

SW2->( DbSetOrder( 1 ) )
SW2->( DbSeek( xFilial()+SW7->W7_PO_NUM ) )

sW2Consig := SW2->W2_IMPORT
sW2CondPa := SW2->W2_COND_PA
sW2DiasPa := SW2->W2_DIAS_PA
sW2Compra := SW2->W2_COMPRA

SY9->( DbSetOrder( 2 ) )
SY9->( DbSeek( xFilial("SY9")+SW2->W2_DEST ) )

//ORDEM 
SW3->( DbSetOrder(8) )
SW9->(DBSETORDER(3))
//-----> Pedidos do Hawb.
sFilial := xFilial("SW7")

bGrava := {|| If( (Ascan(aPo,Alltrim(SW7->W7_PO_NUM))==0), Aadd(aPo,Alltrim(SW7->W7_PO_NUM)),) }
bWhile := {|| sFilial==SW7->W7_FILIAL .AND. SW7->W7_HAWB == cHouse  }

SW7->( DbEval( bGrava,,bWhile ) )

//-----> Dados da Empresa.

IF GetMv("MV_ID_EMPR") $ cSim
   cEnde2SM0 := cEnde2SM0 + IF( !Empty(SM0->M0_CIDCOB), ALLTRIM(SM0->M0_CIDCOB)+" - ","" )
   cEnde2SM0 := cEnde2SM0 + IF( !Empty(SM0->M0_ESTCOB), ALLTRIM(SM0->M0_ESTCOB)+" - ","" )
   cEnde2SM0 := cEnde2SM0 + IF( !Empty(SM0->M0_CEPCOB), ALLTRIM(SM0->M0_CEPCOB)+" - ","" )
   cEnde2SM0 := Left( cEnde2SM0, Len(cEnde2SM0)-3 )
ELSE
   SYT->( DBSETORDER( 1 ) )
   SYT->(DBSEEK(xFilial()+SW2->W2_IMPORT))
   cEnde2SM0 := cEnde2SM0 + IF( !EMPTY(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+" - ", "" )
   cEnde2SM0 := cEnde2SM0 + IF( !EMPTY(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO)+" - ", "" )
   cEnde2SM0 := cEnde2SM0 + IF( !EMPTY(SYT->YT_CEP), ALLTRIM(SYT->YT_CEP)+" - ", "" )
   cEnde2SM0 := LEFT( cEnde2SM0, LEN(cEnde2SM0)-3 )
ENDIF

ProcRegua(6)

AVPRINT oPrn NAME STR0007 //"InstruþÒo de Despacho"


   DEFINE FONT oFont1  NAME "Times New Roman"    SIZE 0,12                  OF oPrn
   DEFINE FONT oFont2  NAME "Times New Roman"    SIZE 0,14  BOLD            OF oPrn
   DEFINE FONT oFont3  NAME "Times New Roman"    SIZE 0,18  BOLD            OF oPrn
   DEFINE FONT oFont4  NAME "Times New Roman"    SIZE 0,12        UNDERLINE OF oPrn
   DEFINE FONT oFont5  NAME "Times New Roman"    SIZE 0,10                  OF oPrn

   aFontes := { oFont1, oFont2, oFont3, oFont4, oFont5 }

   AVPAGE

        IncProc(STR0008) //"Imprimindo..."

        DI160CabPrincipal()

       /*+---------------------------------------------------------+
         ¦   Bate todos os P.O.'s do Hawb.                         ¦
         +---------------------------------------------------------+*/
        Linha:=Linha+50
        LINHA_BOX

        Linha:=Linha+20
        oPrn:Say( Linha,  60, "REF.: ", aFontes:TIMES_NEW_ROMAN_10 )

        cRef := ""
        nCont:= 0

        FOR i:=1 TO Len( aPo )

            cRef := cRef + If( nCont > 0, ", ", "" ) + Trans(aPo[i],_PictPo)
            nCont:= nCont+ 1

            If nCont == 8
               TRACOS_LATERAIS

               oPrn:Say( Linha, 190, cRef,aFontes:TIMES_NEW_ROMAN_10  )
               Linha:=Linha+50

               nCont:= 0
               cRef:= ""
            Endif

        NEXT

        If !Empty( cRef )
           TRACOS_LATERAIS

           oPrn:Say( Linha, 190, cRef ,aFontes:TIMES_NEW_ROMAN_10 )
           Linha:=Linha+50

        Endif

        LINHA_BOX

        oPrn:Say( Linha:=Linha+70,  50 , MemoLine(cTextoEncaminho,80,1),aFontes:TIMES_NEW_ROMAN_10  )

        oPrn:Say( Linha:=Linha+50,  50 , MemoLine(cTextoEncaminho,80,2),aFontes:TIMES_NEW_ROMAN_10  )

        Linha:=Linha+90

        Li_Ini:=Linha

        DI160Cab()

       /*+---------------------------------------------------------+
         ¦   Posicionamentos para Itens - A.C.D.                   ¦
         +---------------------------------------------------------+*/

        //-----> Declaracao (Itens).
        SW7->( DbSetOrder( 1 ) )
        SW7->( DbSeek( xFilial()+SW6->W6_HAWB ) )

        aVetor:={}
        DO WHILE  !SW7->(EOF()) .AND. SW7->W7_FILIAL == xFILIAL("SW7");
                                .AND. SW7->W7_HAWB   == cHouse

          //-----> Produtos.
          SB1->( DbSetOrder( 1 ) )
          SB1->( DbSeek( xFilial()+SW7->W7_COD_I ) )

          //-----> "Memos".
          cDescrItem:=""
          cDescrItem := MSMM(SB1->B1_DESC_GI,48)
//          STRTRAN(SB1->B1_DESC_GI,CHR(13)+CHR(10), " ")


          //-----> Pedidos (Capa).
          SW2->( DbSetOrder( 1 ) )
          SW2->( DbSeek( xFilial()+SW7->W7_PO_NUM ) )

          //-----> Produto X Fornecedor.
          SA5->( DbSetOrder( 3 ) )
          SA5->( DbSeek( xFilial()+SW7->W7_COD_I+SW7->W7_FABR+SW7->W7_FORN ) )

          //-----> Registro do Ministerio.
          SYG->( DbSetOrder( 1 ) )
          SYG->( DbSeek( xFilial()+SW2->W2_IMPORT+SW7->W7_FABR+SW7->W7_COD_I ) )

          //-----> PLIs (Capa).
          SW4->( DbSetOrder( 1 ) )
          SW4->( DbSeek( xFilial()+SW7->W7_PGI_NUM ) )

          //-----> SIs (Capa).
          SW0->( DbSetOrder( 1 ) )
          SW0->( DbSeek( xFilial()+SW7->W7_CC+SW7->W7_SI_NUM ) )

          //-----> Locais de Entrega
          SY2->( DbSetOrder(1) )
          SY2->( DbSeek( xFilial()+SW0->W0__POLE ) )

          //-----> Regime de Importacao.
          SY8->( DbSetOrder(1) )
          SY8->( DbSeek( xFilial()+SW4->W4_REGIMP ) )

          //-----> Pedidos (Itens).
            SW3->(DBSEEK(xFilial("SW3")+SW7->W7_PO_NUM+SW7->W7_POSICAO))

//          SW3->( PosO1_ItPedidos( SW7->W7_PO_NUM, SW7->W7_CC  , SW7->W7_SI_NUM, SW7->W7_COD_I, ;
//                                  SW7->W7_FABR  , SW7->W7_FORN, SW7->W7_REG   , SW7->W7_SEQ  , 0 ) )

          //-----> Capa da L.I.
          SWP->( DbSetOrder(1) )
          SWP->( DbSeek( xFilial()+SW7->W7_PGI_NUM+SW7->W7_SEQ_LI ) )

          DI160VerFim(1)

          Linha:=Linha+20
                           
          oPrn:Say( Linha, 350 , Trans( SW7->W7_QTDE,AVSX3("W7_QTDE",6)),aFontes:TIMES_NEW_ROMAN_10,,,,1)

          oPrn:Say( Linha, 380 , MemoLine( cDescrItem, 25, 1),aFontes:TIMES_NEW_ROMAN_10)

          oPrn:Say( Linha, 1040, Trans(SB1->B1_POSIPI,_PictNBM),aFontes:TIMES_NEW_ROMAN_10 )

          If SubStr( SW7->W7_PGI_NUM, 1, 1 ) #"*"
             oPrn:Say( Linha, 1245, SWP->WP_REGIST ,aFontes:TIMES_NEW_ROMAN_10 )

             IF (nAux1 := ASCAN(aVetor,{|x| x[1]==SWP->WP_REGIST})) == 0
                AADD(aVetor,{SWP->WP_REGIST,SW2->W2_MOEDA,SW7->W7_QTDE*SW7->W7_PRECO,SW4->W4_REGIMP,SY8->Y8_DES,SY8->Y8_REG_TRI})
             ELSE
                aVetor[nAux1,3]:=aVetor[nAux1,3]+SW7->W7_QTDE*SW7->W7_PRECO
             ENDIF

          Else
             oPrn:Say( Linha, 1245, STR0009,aFontes:TIMES_NEW_ROMAN_10) //"N+O REQUERIDA"

          Endif

          oPrn:Say( Linha, 1600, SW3->W3_REG_TRI,aFontes:TIMES_NEW_ROMAN_10)

          oPrn:Say( Linha, 1660, ALLTRIM(MemoLine( SY2->Y2_DESC, 15, 1)),aFontes:TIMES_NEW_ROMAN_10)

          oPrn:Say( Linha, 2270, DTOC( SW3->W3_DT_ENTR),aFontes:TIMES_NEW_ROMAN_10,,,,1)

          Linha:=Linha+40
          /*FCD
          If ! EMPTY(SB1->B1_UM)
             oPrn:Say( Linha, 140, SB1->B1_UM,aFontes:TIMES_NEW_ROMAN_10)
          Endif
          */                                                             
          //SO.:0022/02 OS.:0156/02
          oPrn:Say( Linha, 140, BUSCA_UM(SW3->W3_COD_I+SW3->W3_FABR +SW3->W3_FORN,SW3->W3_CC+SW3->W3_SI_NUM),aFontes:TIMES_NEW_ROMAN_10)
          IF ! EMPTY(MemoLine( SY2->Y2_DESC, 15, 2))
             oPrn:Say( Linha, 1660, ALLTRIM(MemoLine( SY2->Y2_DESC, 15, 2)),aFontes:TIMES_NEW_ROMAN_10)
          ENDIF


          FOR i:=2 TO MlCount( cDescrItem, 25 ) 
              DI160VerFim(1)
              If !Empty( MemoLine(cDescrItem,25,i) )
                 oPrn:Say( Linha,380,MemoLine( cDescrItem, 25, i ),aFontes:TIMES_NEW_ROMAN_10)
              Endif
              Linha:=Linha+40
          NEXT

          If i > MlCount( cDescrItem, 25 ) 
             If SW3->(FieldPos("W3_PART_N")) # 0 .And. !Empty(SW3->W3_PART_N) //ASK 08/10/2007
                DI160VerFim(1)
                oPrn:Say( Linha, 380 , SW3->W3_PART_N,aFontes:TIMES_NEW_ROMAN_10)
                Linha:=Linha+40
             Else                
                IF !EMPTY(SA5->A5_CODPRF) 
                   DI160VerFim(1)
                   oPrn:Say( Linha, 380 , SA5->A5_CODPRF,aFontes:TIMES_NEW_ROMAN_10)
                   Linha:=Linha+40
                EndIf
             ENDIF   
             IF !EMPTY(SA5->A5_PARTOPC) 
                DI160VerFim(1)
                oPrn:Say( Linha, 380 , MEMOLINE(SA5->A5_PARTOPC,25,1),aFontes:TIMES_NEW_ROMAN_10)
                Linha:=Linha+40
                oPrn:Say( Linha, 380 , MEMOLINE(SA5->A5_PARTOPC,25,2),aFontes:TIMES_NEW_ROMAN_10)
                Linha:=Linha+40
             ENDIF   
             IF !EMPTY(SYG->YG_REG_MIN)
                DI160VerFim(1)
                oPrn:Say( Linha, 380 , SYG->YG_REG_MIN,aFontes:TIMES_NEW_ROMAN_10)
                Linha:=Linha+40
             ENDIF   
          Endif

          oPrn:Box( Linha:=Linha+50 ,  50, Linha+1, 2300)

          SW7->( DbSkip() )

        ENDDO

        IncProc(STR0008) //"Imprimindo..."
        SA5->( DbSetOrder( 1 ) )

        Li_Fim:=Linha

        DI160Fim()

       /*+---------------------------------------------------------+
         ¦ Bate todas as PLI's c/ seus Regimes, envolvidos - A.C.D.¦
         +---------------------------------------------------------+*/

        DI160VerFim(0)
        oPrn:Say( Linha:=Linha+90,50,STR0010,aFontes:TIMES_NEW_ROMAN_12 ) //"SENDO: L.I. Nr."
       
        
        FOR i:=1 TO Len( aVetor )
//AADD(aVetor,{SWP->WP_REGIST,SW2->W2_MOEDA,SW7->W7_QTDE*SW7->W7_PRECO,SW4->W4_REGIMP,SY8->Y8_DES,SY8->Y8_REG_TRI})

            oPrn:Say( Linha, 380  , aVetor[i,1],aFontes:TIMES_NEW_ROMAN_12  )
            oPrn:Say( Linha, 610 , aVetor[i,2],aFontes:TIMES_NEW_ROMAN_12  )
            
            oPrn:Say( Linha,1300  , TRANS(aVetor[i,3],_PictPrTot),aFontes:TIMES_NEW_ROMAN_12 ,,,,1 )           

            
            oPrn:Say( Linha,1370  , aVetor[i,4],aFontes:TIMES_NEW_ROMAN_12  )
            oPrn:Say( Linha,1440  , Memoline(aVetor[i,5],30,1),aFontes:TIMES_NEW_ROMAN_12  )
            oPrn:Say( Linha,2300  , aVetor[i,6],aFontes:TIMES_NEW_ROMAN_12  )

            Linha:=Linha+50
            DI160VerFim(0)

            FOR W:=2 TO ((LEN(aVetor[i,5])/30)+1)
                If ! EMPTY(ALLTRIM(Memoline(aVetor[i,5],30,W)))
                   oPrn:Say( Linha, 1440 , Memoline(aVetor[i,5],30,W),aFontes:TIMES_NEW_ROMAN_12  )
                   Linha:=Linha+50
                   DI160VerFim(0)
                Endif
            NEXT
  
        NEXT  
        
        IncProc(STR0008) //"Imprimindo..."

        //-----> Tabelas.
        SX5->( DbSetOrder( 1 ) )
        SX5->( DbSeek( xFilial()+"Y2" ) )
        DI160VerFim(0)
        oPrn:Say( Linha:=Linha+90 , 50  ,STR0011,aFontes:TIMES_NEW_ROMAN_12 ) //"LEGENDA DE REGIME: "
        Do While ! SX5->(Eof()) .AND. SX5->X5_TABELA=="Y2" .AND. ;
                                      SX5->X5_FILIAL==xFilial("SX5")
           DI160VerFim(0)
           oPrn:Say( Linha ,590 ,SX5->X5_CHAVE + " - " + X5DESCRI(),aFontes:TIMES_NEW_ROMAN_12)
           Linha:=Linha+50
           SX5->(DBSKIP())
        Enddo
        IncProc(STR0008) //"Imprimindo..."

        //-----> Importador.
        SYT->( DbSetOrder( 1 ) )
        SYT->( DbSeek( xFilial()+sW2Consig ) )

        //-----> Condiçao de Pagamento.
        SY6->( DbSetOrder( 1 ) )
        SY6->( DbSeek( xFilial()+sW2CondPa+Str(sW2DiasPa,3,0) ) )

        //-----> "Memos".
        cCondPag:=""
        cCondPag := MSMM(SY6->Y6_DESC_P,48)
        STRTRAN(cCondPag,CHR(13)+CHR(10)," ")

        //-----> Compradores.
        SY1->( DbSetOrder( 1 ) )
        SY1->( DbSeek( xFilial()+sW2Compra ) )

        DI160VerFim(0)
        oPrn:Say( Linha:=Linha+90 , 50  ,STR0036 +" "+ SW6->W6_FREMOED+" "+;
                  Trans(SW6->W6_VLFREPP,AVSX3("W6_VLFREPP",6)),aFontes:TIMES_NEW_ROMAN_12) //TRP-10/10/07

        oPrn:Say( Linha:=Linha+50 , 50  ,STR0037 +" "+ SW6->W6_FREMOED+" "+;
                  Trans(SW6->W6_VLFRECC,AVSX3("W6_VLFRECC",6)),aFontes:TIMES_NEW_ROMAN_12) //TRP-10/10/07
        
        
        oPrn:Say( Linha:=Linha+50 , 50  ,STR0038 +" "+ SW6->W6_FREMOED+" "+;
                  Trans(SW6->W6_VLFRETN,AVSX3("W6_VLFRETN",6)),aFontes:TIMES_NEW_ROMAN_12) //TRP-10/10/07
        
        DI160VerFim(0)
        oPrn:Say( Linha:=Linha+50 , 50  ,STR0032 + SYT->YT_NOME ,aFontes:TIMES_NEW_ROMAN_12)//"IMPORTADOR: "

        DI160VerFim(0)
        oPrn:Say( Linha:=Linha+50 , 50  ,AVSX3("YT_CGC",5)+": " + TRANS(SYT->YT_CGC,"@R 99.999.999/9999-99") ,aFontes:TIMES_NEW_ROMAN_12) //"C.G.C.: " //STR0013

        DI160VerFim(0)
        oPrn:Say( Linha:=Linha+90 , 50  ,STR0014 + MEMOLINE(cCondPag,48,1) ,aFontes:TIMES_NEW_ROMAN_12) //"FORMA DE PAGAMENTO: "

        DI160VerFim(0)
        oPrn:Say( Linha:=Linha+90 , 50  ,STR0015 + SW6->W6_IDENTVEI,aFontes:TIMES_NEW_ROMAN_12 ) //"NAVIO: "
        oPrn:Say( Linha     ,1200 ,STR0016  + DTOC(SW6->W6_DT_EMB) ,aFontes:TIMES_NEW_ROMAN_12) //"EMB.: "
        oPrn:Say( Linha     ,1700 ,STR0017 + DTOC(SW6->W6_DT_ETA) ,aFontes:TIMES_NEW_ROMAN_12) //"CHEG.: "

        
        IF SW9->(DBSEEK(xFilial("SW9")+SW6->W6_HAWB))
           lPri:=.T.
           DO WHILE ! SW9->(EOF()) .AND. SW9->W9_FILIAL == xFilial("SW9") .AND. SW9->W9_HAWB == SW6->W6_HAWB
              cInv+= IF(!lPri,", "," ") +ALLTRIM(SW9->W9_INVOICE)
              lPri:=.F.
              
              //TRP-10/10/07- Total por Moeda
              If (nPos := aScan(aMoedas, {|x| x[1] == SW9->W9_MOE_FOB })) > 0
                 aMoedas[nPos][2] += SW9->W9_FOB_TOT + SW9->W9_INLAND + SW9->W9_PACKING + SW9->W9_FRETEIN - SW9->W9_DESCONT
              Else
                 aAdd(aMoedas, {SW9->W9_MOE_FOB, SW9->W9_FOB_TOT + SW9->W9_INLAND + SW9->W9_PACKING + SW9->W9_FRETEIN - SW9->W9_DESCONT})
              EndIf
              
              SW9->(DBSKIP())
           ENDDO
           
           //TRP-10/10/07
             For nInc := 1 to Len(aMoedas)
              oPrn:Say( Linha:=Linha+90 , 50  ,STR0033 +aMoedas[nInc][1] +": "+ TRANS(aMoedas[nInc][2],AVSX3("W6_FOB_TOT",6)),aFontes:TIMES_NEW_ROMAN_12 ) 
             Next
            
           oPrn:Say( Linha     ,1200 ,STR0034 + SW6->W6_HOUSE ,aFontes:TIMES_NEW_ROMAN_12)
           
           oPrn:Say( Linha:=Linha+90 , 50  ,STR0035 ,aFontes:TIMES_NEW_ROMAN_12 )
           
           FOR I := 1 TO MLCOUNT(cInv,80)
              If I > 1
                 Linha := Linha +50
              Endif                    
              oPrn:Say( Linha ,250  ,MEMOLINE(cInv,80,I) ,aFontes:TIMES_NEW_ROMAN_12 ) 
           NEXT
        ENDIF
       /*+---------------------------------------------------------+
         ¦ Bate todas as Mensagens selecionadas na tela - A.C.D.   ¦
         +---------------------------------------------------------+*/

        sAlias := Alias()

        IncProc(STR0008) //"Imprimindo..."
        IF SELECT("WORK_MEN") #0

           Work_Men->( DbGoTop() )

           IF !Work_Men->(EOF())  .AND.  Work_Men->WKORDEM < "zzzzz"

              DI160VerFim(0)
              oPrn:Say( Linha:=Linha+90 , 50 ,STR0018, aFontes:TIMES_NEW_ROMAN_14_UNDERLINE) //"DOCUMENTOS ANEXOS:"
              Linha:=Linha+65
              Li_Ini:=Linha

              WHILE !Work_Men->(EOF())  .AND.  Work_Men->WKORDEM < "zzzzz"

                 DI160VerFim(0,"MEM")

                 oPrn:Box(Linha,  50, Linha+1 , 2280 )
                 Linha:=Linha+20

                 FOR W:=1 TO MLCOUNT(Rtrim(Work_Men->WKOBS),80)

                     IF !EMPTY( MEMOLINE(Work_Men->WKOBS,80,W) )

                        IF DI160VerFim(0,"MEM")
                           oPrn:Box(Linha,  50,Linha+1, 2280 )
                           Linha:=Linha+20
                        ENDIF
                        oPrn:Say(Linha,170, Memoline(Work_Men->WKOBS,80,W) ,aFontes:TIMES_NEW_ROMAN_12)
                        Linha:=Linha+50
                     ENDIF
   
                 NEXT
   
                 Work_Men->(DBSKIP())
                 Linha:=Linha+50
   
              End
              Li_Fim:=Linha:=Linha+30
              DI160Fim("MEM")

           ENDIF

        Endif
        
        DbSelectArea( sAlias )

          DI160VerFim(0,"FIM")
        IF ExistBlock("IC195DI1")
           // Rdmake para Klabin
           ExecBlock("IC195DI1",.F.,.F.,Linha)
        Else
           oPrn:Say( Linha:=Linha+120, 50 ,STR0019,aFontes:TIMES_NEW_ROMAN_12 ) //"ATENCIOSAMENTE,"
           oPrn:Say( Linha:=Linha+150,120 ,SY1->Y1_NOME,aFontes:TIMES_NEW_ROMAN_12 )
           oPrn:Say( Linha:=Linha+50 ,120 ,STR0020,aFontes:TIMES_NEW_ROMAN_12 ) //"DEPTO. DE IMPORTAÃ+O"
        EndIf
        IncProc(STR0008) //"Imprimindo..."

   AVENDPAGE

AVENDPRINT

oFont1:End()
oFont2:End()
oFont3:End()
oFont4:End()
oFont5:End()
SW3->(DBSETORDER(1))
SW9->(DBSETORDER(1))
Return NIL

*----------------------------------------*
Static FUNCTION DI160VerFim(Parte2,cLocal)
*----------------------------------------*

If cLocal #NIL  .AND.  cLocal=="FIM"

   IF Linha >= 2700 //3200
      AVNEWPAGE
      DI160CabPrincipal()
      RETURN .T.
   ENDIF

Endif

IF cLocal #NIL  .AND.  cLocal=="MEM"

   IF Linha >= 2700 //3200
      Li_Fim:=(Linha+50)
      DI160Fim(cLocal)
      cLocal:= NIL
      AVNEWPAGE

      DI160CabPrincipal()

      Linha:=Linha+60
      Li_Ini:=Linha
      RETURN .T.
   ENDIF

ENDIF

IF Linha >= 2700 //3200

   IF PARTE2 > 0
      Li_Fim:=(Linha+50)
      DI160Fim()
   ENDIF

   AVNEWPAGE

   DI160CabPrincipal()

   IF PARTE2 > 0
      Linha:=Linha+50
      Li_Ini:=Linha
      DI160Cab()
   ENDIF
   RETURN .T.

ENDIF

RETURN .F.

*-------------------------*
Static FUNCTION DI160Cab()
*-------------------------*

oPrn:Line( Linha,  50, Linha, 2300 )

oPrn:Say( Linha:=Linha+10, 150 , STR0021,aFontes:TIMES_NEW_ROMAN_10 ) //"QTD."
oPrn:Say( Linha          , 550 , STR0022,aFontes:TIMES_NEW_ROMAN_10 ) //"PRODUTO"
oPrn:Say( Linha          , 1060, STR0023,aFontes:TIMES_NEW_ROMAN_10 ) //"N.C.M."
oPrn:Say( Linha          , 1350, STR0024,aFontes:TIMES_NEW_ROMAN_10 ) //"L.I."
oPrn:Say( Linha          , 1580, STR0025,aFontes:TIMES_NEW_ROMAN_10 ) //"REG"
oPrn:Say( Linha          , 1830, STR0026,aFontes:TIMES_NEW_ROMAN_10 ) //"DESTINO"
oPrn:Say( Linha          , 2135, STR0027,aFontes:TIMES_NEW_ROMAN_10 ) //"NEC.FAB."

oPrn:Box( Linha:=Linha+50,50, Linha+1, 2300 )


RETURN NIL

*-----------------------------*
Static FUNCTION DI160Fim(cMeio)
*-----------------------------*         


oPrn:Box( Li_Fim ,  50 , Li_Fim+1 , 2300  )
oPrn:Box( Li_Ini ,  50 , Li_Fim    ,  51  )//COL INICIAL
oPrn:Box( Li_Ini , 2300, Li_Fim    , 2301 )//COL FINAL

IF cMeio==NIL

   oPrn:Box(Li_Ini , 370, Li_Fim     , 371  )
   oPrn:Box(Li_Ini , 1035, Li_Fim    , 1036 )
   oPrn:Box(Li_Ini , 1235, Li_Fim    , 1236 )
   oPrn:Box(Li_Ini , 1575, Li_Fim    , 1576 )
   oPrn:Box(Li_Ini , 1650, Li_Fim    , 1651 )
   oPrn:Box(Li_Ini , 2125, Li_Fim    , 2126 )                                              

ENDIF

RETURN NIL

*-----------------------------------*
Static FUNCTION DI160CabPrincipal()
*-----------------------------------*

Linha:=100

IF GetMv("MV_ID_EMPR") $ cSim
   oPrn:Say( Linha           , 1280, ALLTRIM(SM0->M0_NOME)  ,aFontes:TIMES_NEW_ROMAN_18_BOLD,,,,2 )
   oPrn:Say( Linha:=Linha+90 , 1280, ALLTRIM(SM0->M0_ENDCOB),aFontes:TIMES_NEW_ROMAN_18_BOLD,,,,2 )
ELSE
   oPrn:Say( Linha           , 1280, ALLTRIM(SYT->YT_NOME)  ,aFontes:TIMES_NEW_ROMAN_18_BOLD,,,,2 )
   oPrn:Say( Linha:=Linha+90 , 1280, ALLTRIM(SYT->YT_ENDE)  ,aFontes:TIMES_NEW_ROMAN_18_BOLD,,,,2 )
ENDIF
oPrn:Say( Linha:=Linha+90, 1280, cEnde2SM0     ,aFontes:TIMES_NEW_ROMAN_18_BOLD,,,,2 )

oPrn:Say( Linha:=Linha+120, 1280  ,STR0028,aFontes:TIMES_NEW_ROMAN_18_BOLD,,,,2 ) //' "INSTRUÇÃO DE DESPACHO" '


oPrn:Say( Linha:=Linha+130,  50  ,ALLTRIM(GetNewPar("MV_CIDADE",STR0029))+" "+STR(DAY(dDataBase),2,0)+" de " +;
         MesExtenso(MONTH(dDataBase))+" de "+STR(YEAR(dDataBase),4,0),aFontes:TIMES_NEW_ROMAN_12 ) //"SÃO PAULO (SP),"

//oPrn:Say( Linha:=Linha+90 ,  50  , "+" ,aFontes:TIMES_NEW_ROMAN_12)

oPrn:Say( Linha:=Linha+90 ,  50  , SY5->Y5_NOME,aFontes:TIMES_NEW_ROMAN_12 )

oPrn:Say( Linha:=Linha+50 ,  50  , STR0030,aFontes:TIMES_NEW_ROMAN_12 ) //"PORTO :"
oPrn:Say( Linha     , 300  , SY9->Y9_DESCR,aFontes:TIMES_NEW_ROMAN_12 )

oPrn:Say( Linha:=Linha+50 ,  50  , STR0031 ,aFontes:TIMES_NEW_ROMAN_12) //"CONHECIMENTO NR :"
oPrn:Say( Linha     , 580  , SW6->W6_HAWB ,aFontes:TIMES_NEW_ROMAN_12)
Linha:=Linha+55

RETURN NIL


