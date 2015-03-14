#INCLUDE "Eicpo562.ch"
#include "rwmake.ch"   
#include "Avprint.ch"   
#include "Average.ch"
#DEFINE   TITULO      STR0001 //"EmissÒo da Proposta de ImportaþÒo "

User Function Eicpo562()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("UVAR>,LINHA,OPRINT>,OFONT>,NOPCAO,CPONUM")
SetPrvt("ODLGTELAPRINCIPAL,OFNTDLG,BOK,BCANCEL,BINIT,CENDSA2")
SetPrvt("AFABR,AMODALIDADE,CMODALIDADE,MOBS,CREGIME,CORIG")
SetPrvt("LBATESUBCAB,NCONT,AFONTES,I,BGRAVA,BWHILE")
SetPrvt("PARTE2,MAUX,NTOTALGERAL,PTIPO,CDESCRITEM,NNUMERO")
SetPrvt("SFILIAL,BACUMULA,N1,N2,LPULALINHA,XLINHA")

Private _PictPO      := ALLTRIM(X3Picture("W2_PO_NUM"))
Private _PictPrTot   := ALLTRIM(X3Picture("W2_FOB_TOT"))
Private _PictPrUn    := ALLTRIM(X3Picture("W3_PRECO"))
Private _PictQtde    := ALLTRIM(X3Picture("W3_QTDE"))
Private _PictNBM     := E_Tran("YD_TEC",,.T.)

#xtranslate :TIMES_NEW_ROMAN_12            => \[1\]
#xtranslate :COURIER_12                    => \[2\]
#xtranslate :TIMES_NEW_ROMAN_14_BOLD       => \[3\]
#xtranslate :TIMES_NEW_ROMAN_14_UNDERLINE  => \[4\]
#xtranslate :COURIER_20_NEGRITO            => \[5\]
#xtranslate :TIMES_NEW_ROMAN_10_NEGRITO    => \[6\]
#xtranslate :TIMES_NEW_ROMAN_08_NEGRITO    => \[7\]
#xtranslate :COURIER_08_NEGRITO            => \[8\]
#xtranslate :COURIER_12_NEGRITO            => \[9\]

#xtranslate DATA_MES(<x>) => SUBSTR(DTOC(<x>),1,2)+ " " + ;
                             SUBSTR(CMONTH(<x>),1,3)+ " " + ;
                             SUBSTR(DTOC(<x>),7,2)

#xtranslate   bSETGET(<uVar>)              => {|u| If(PCount() == 0, <uVar>, <uVar> := u) }

#xtranslate   AVPict(<Cpo>)                => AllTrim(X3Picture(<Cpo>))

#xtranslate   TRACO_NORMAL                 => oPrn:Line( Linha  ,  05, Linha  , 2305 ) ;
                                           ;  oPrn:Line( Linha+1,  05, Linha+1, 2305 )

#xtranslate   TRACO_REDUZIDO               => oPrn:Line( Linha  ,1175, Linha  , 2305 ) ;
                                           ;  oPrn:Line( Linha+1,1175, Linha+1, 2305 )

#xtranslate   COMECA_PAGINA                => AVNEWPAGE                                ;
                                           ;  Linha := 180                             ;
                                           ;  PO562Cab(); PO562Cab_Itens()


 /*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçao    ¦ EICPO562 ¦ Autor ¦ Jose Marcio Soler     ¦ Data ¦ 28.08.99 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Emissäo da Proposta de Impotaçao.                          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   ¦ #EICPO562                                                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

nOpcao :=0
cPoNum := SW2->W2_PO_NUM

/*+--------------------------------------------------------------+
  ¦ Define a Dialog com get's iniciais                           ¦
  +--------------------------------------------------------------+*/

WHILE .T.

   nOpcao:=0
   oDlgTelaPrincipal:= oSend( TDialog(), "New", 120, 100, 250, 490,;
                       TITULO,,,.F.,,,,,GetWndDefault(),.T.,,)

    oFntDlg := NIL                    
       
    DEFINE FONT oFntDlg  NAME "Ms Sans Serif" SIZE 0,-9

        oSend(TSay(),"New",25, 10 ,{|| STR0002},oDlgTelaPrincipal,,oFntdlg,,,,.T. ) //"Nº do P.O.:"
        @25,50 MSGET cPoNum Picture AVPict("W2_PO_NUM");
                            Valid {|| PO562Val()} Size 40,08 PIXEL F3 "SW2"
                            
//        oSend(TGet(),"New",25, 50 ,bSetGet(cPoNum)   ,oDlgTelaPrincipal,,8,;
//                      AVPict("W2_PO_NUM"),{|| PO562Val()},,,oFntDlg,,,.T.,,,,,,,,,"SW2")

        oSend( SButton(), "New", 25, 145 ,6 ,{||nOpcao:=1,oSend(oDlgTelaPrincipal,"End") }, oDlgTelaPrincipal, .T.,,)

        bOk    := {||nOpcao:=1,oSend(oDlgTelaPrincipal,"End")}
        bCancel:= {||nOpcao:=0,oSend(oDlgTelaPrincipal,"End")}

        bInit  := {|| EnchoiceBar(oDlgTelaPrincipal,bOk,bCancel) }

        oSend( oDlgTelaPrincipal, "Activate",,,,.T.,,, bInit )

        If nOpcao == 1
           Processa({|| PO562Relatorio()},STR0003) //"Processando Relatorio..."
           LOOP
        Endif
        If nOpcao == 0
           Return .F.
        Endif
END

Return(NIL)        


*-------------------------*
Static FUNCTION PO562Val()
*-------------------------*

If Empty( cPoNum ) 
   Help("", 1, "AVG0000120")
   Return .F.
Endif

SW2->( DbSetOrder(1) )
If !SW2->( DbSeek( xFilial()+cPoNum ) )
   Help("", 1, "AVG0000121")
   Return .F.
Endif

Return .T.


*-------------------------------*
Static FUNCTION Po562Relatorio()
*-------------------------------*
Local I
cEndSA2:=""
aFabr:={}
aModalidade:={"House to House","House to Pier","Pier to House","Pier to Pier"}
cModalidade:=""
mObs:=""
cRegime:=""
cOrig:= " "
lBateSubCab:=.T.
nCont:=0

//-----------> Importador.
SYT->( DBSETORDER( 1 ) )
SYT->( DBSEEK( xFilial()+SW2->W2_IMPORT ) )

//----------->  Fornecedor.
SA2->( DBSETORDER( 1 ) )
SA2->( DBSEEK( xFilial()+SW2->W2_FORN+EICRetLoja("SW2","W2_FORLOJ") ) )

SYA->(DBSETORDER(1))
SYA->(DBSEEK(xFilial()+SA2->A2_REPPAIS))
cEndSA2 := cEndSA2 + IF( !EMPTY(SA2->A2_REPRMUN), ALLTRIM(SA2->A2_REPRMUN)+' - ', "" )
cEndSA2 := cEndSA2 + IF( !EMPTY(SA2->A2_REPREST), ALLTRIM(SA2->A2_REPREST)+' - ', "" )
cEndSA2 := cEndSA2 + IF( !EMPTY(SYA->YA_DESCR)  , ALLTRIM(SYA->YA_DESCR)  +' - ', "" )
cEndSA2 := LEFT( cEndSA2, LEN(cEndSA2)-2 )

//-----------> Agentes Embarcadores.
SYQ->( DBSEEK( xFilial()+SW2->W2_TIPO_EMB ) )

IF GetMv("MV_ID_CLI") $ cSim
   //-----------> Cliente.
   SA1->( DBSETORDER( 1 ) )
   SA1->( DBSEEK( xFilial()+SW2->W2_CLIENTE+EICRetLoja("SW2","W2_CLILOJ") ) )
ELSE
   //-----------> Comprador.
   SY1->( DBSETORDER( 1 ) )
   SY1->( DBSEEK( xFilial()+SW2->W2_COMPRA ) )
ENDIF

// A pedido do JS=JONATO.
If !Empty( SW2->W2_CONTAIN )
   cModalidade := aModalidade[VAL(SW2->W2_CONTAIN)]
Endif

AVPRINT oPrn NAME STR0007 //"Proposta de Importacao"

   ProcRegua(10)

   DEFINE FONT oFont1  NAME "Times New Roman"    SIZE 0,12                  OF oPrn
   DEFINE FONT oFont2  NAME "Courier"            SIZE 0,12                  OF oPrn
   DEFINE FONT oFont3  NAME "Times New Roman"    SIZE 0,14  BOLD            OF oPrn
   DEFINE FONT oFont4  NAME "Times New Roman"    SIZE 0,14  BOLD UNDERLINE  OF oPrn
   DEFINE FONT oFont5  NAME "Courier"            SIZE 0,26  BOLD            OF oPrn
   DEFINE FONT oFont6  NAME "Times New Roman"    SIZE 0,10  BOLD            OF oPrn
   DEFINE FONT oFont7  NAME "Times New Roman"    SIZE 0,08  BOLD            OF oPrn
   DEFINE FONT oFont8  NAME "Courier"            SIZE 0,10  BOLD            OF oPrn
   DEFINE FONT oFont9  NAME "Courier"            SIZE 0,12  BOLD            OF oPrn

   aFontes := { oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8, oFont9}

   AVPAGE

      IncProc(STR0008) //"Imprimindo..."
      PO562Cab()

      oPrn:Say( Linha:= Linha+50 , 175  , STR0009,aFontes:COURIER_12_NEGRITO ) //"Importador......:"
      oPrn:Say( Linha     , 725  , SW2->W2_IMPORT +" - "+ SYT->YT_NOME_RE,aFontes:TIMES_NEW_ROMAN_12)
      oPrn:Line( Linha:=Linha+80,  85, Linha  , 2345 )  ;  oPrn:Line( Linha+1,  75, Linha+1, 2345 )

      IF EMPTY(SA2->A2_REPRES)
         oPrn:Say( Linha:=Linha+30 , 175  , STR0010,aFontes:TIMES_NEW_ROMAN_14_UNDERLINE ) //"** REPRESENTANTE **"
         oPrn:Say( Linha:=Linha+80 , 175  , STR0011 ) //"NAO HA"
      ELSE
         oPrn:Say( Linha:=Linha+30 , 175  , STR0010,aFontes:TIMES_NEW_ROMAN_14_UNDERLINE ) //"** REPRESENTANTE **"

         oPrn:Say( Linha:=Linha+80 , 175  , ALLTRIM(SA2->A2_COD)+" - "+ALLTRIM(SA2->A2_REPRES)+" - "+ALLTRIM(SA2->A2_REPRCGC),aFontes:TIMES_NEW_ROMAN_12 )

         oPrn:Say( Linha:=Linha+50 , 175  , STR0012,aFontes:COURIER_12 ) //"C.G.C...........:"
         oPrn:Say( Linha     , 725  , TRANS(SA2->A2_REPRCGC,"@R 99.999.999/9999-99"),aFontes:TIMES_NEW_ROMAN_12 )

         oPrn:Say( Linha:=Linha+50 , 175  , STR0013,aFontes:COURIER_12 ) //"Tel.............:"
         oPrn:Say( Linha     , 725  , SA2->A2_REPRTEL,aFontes:TIMES_NEW_ROMAN_12)

         oPrn:Say( Linha:=Linha+50 , 175  , STR0014,aFontes:COURIER_12 ) //"Fax.............:"
         oPrn:Say( Linha     , 725  , SA2->A2_REPRFAX,aFontes:TIMES_NEW_ROMAN_12 )

         oPrn:Say( Linha:=Linha+50 , 175  , STR0015,aFontes:COURIER_12 ) //"Contato.........:"
         oPrn:Say( Linha     , 725  , SA2->A2_REPCONT,aFontes:TIMES_NEW_ROMAN_12 )

         oPrn:Say( Linha:=Linha+50 , 175  , STR0016,aFontes:COURIER_12 ) //"Endereco........:"
         oPrn:Say( Linha     , 725  , SA2->A2_REPR_EN,aFontes:TIMES_NEW_ROMAN_12 )

         oPrn:Say( Linha:=Linha+50 , 175  , STR0017,aFontes:COURIER_12 ) //"Bairro..........:"
         oPrn:Say( Linha     , 725  , SA2->A2_REPBAIR,aFontes:TIMES_NEW_ROMAN_12 )

         oPrn:Say( Linha:=Linha+50 , 175  , STR0018,aFontes:COURIER_12 ) //"Cidade/Est/País.:"
         oPrn:Say( Linha     , 725  , cEndSA2,aFontes:TIMES_NEW_ROMAN_12 )

         oPrn:Say( Linha:=Linha+50 , 175  , STR0019,aFontes:COURIER_12 ) //"CEP.............:"
         oPrn:Say( Linha     , 725  , TRANS(SA2->A2_REPRCEP,"@R 99999-999"),aFontes:TIMES_NEW_ROMAN_12 )

         oPrn:Say( Linha:=Linha+50 , 175  , STR0020,aFontes:COURIER_12 ) //"Comissäo........:"
         IF !SW2->W2_COMIS $ cSim
            oPrn:Say( Linha ,725  ,STR0021,aFontes:TIMES_NEW_ROMAN_12) //"*** NONE ***"
         ELSE
            IF SW2->W2_TIP_COM == '1'
               oPrn:Say( Linha ,725 , trans(SW2->W2_PER_COM,"@E 9,999.99")+'%',aFontes:TIMES_NEW_ROMAN_12 )
            ELSEIF SW2->W2_TIP_COM $ '2,3'
               oPrn:Say( Linha ,725 , SW2->W2_MOEDA+' '+trans(SW2->W2_VAL_COM,AVSX3("W2_VAL_COM",6)),aFontes:TIMES_NEW_ROMAN_12 )
            ELSEIF SW2->W2_TIP_COM == '4'
               oPrn:Say( Linha ,725 , SW2->W2_OUT_COM,aFontes:TIMES_NEW_ROMAN_12 )
            ENDIF
         ENDIF

         SA6->( DBSETORDER( 1 ) )
         SA6->( DBSEEK( xFilial()+SA2->A2_REPR_BA+SA2->A2_REPR_AG) )
         oPrn:Say( Linha:=Linha+50 , 175  , STR0022,aFontes:COURIER_12 ) //"Domicilio Bancario:"
         oPrn:Say( Linha     , 755  , IF(!EMPTY(ALLTRIM(SA2->A2_REPR_BA)),ALLTRIM(SA2->A2_REPR_BA),"")+;
                                      IF(!EMPTY(ALLTRIM(SA2->A2_REPR_AG))," - "+ALLTRIM(SA2->A2_REPR_AG),"")+;
                                      IF(!EMPTY(ALLTRIM(SA6->A6_NOME))," - "+ALLTRIM(SA6->A6_NOME),"")+;
                                      IF(!EMPTY(ALLTRIM(SA2->A2_REPR_CO))," - "+ALLTRIM(SA2->A2_REPR_CO),"") ,aFontes:TIMES_NEW_ROMAN_12)
      ENDIF
      oPrn:Line( Linha:=Linha+60, 85, Linha  , 2345 )  ;  oPrn:Line( Linha+1,  75, Linha+1, 2345 )

      IncProc(STR0008) //"Imprimindo..."
      FOR I:=1 TO 2

          SA2->( DBSETORDER( 1 ) )

          IF I==1
             IF EMPTY( SW2->W2_EXPORTA ) .AND. EICEmptyLJ("SW2","W2_EXPLOJ")
                oPrn:Say( Linha:=Linha+30 , 175  , STR0023,aFontes:TIMES_NEW_ROMAN_14_UNDERLINE ) //"** EXPORTADOR **"
                oPrn:Say( Linha:=Linha+80 , 175  , STR0024,aFontes:TIMES_NEW_ROMAN_12) //"VIDE FORNECEDOR"
                oPrn:Line( Linha:=Linha+60, 85, Linha  , 2345 )  ;  oPrn:Line( Linha+1,  75, Linha+1, 2345 )
                LOOP
             ELSE
                SA2->( DBSEEK( xFilial()+SW2->W2_EXPORTA+EICRetLoja("SW2","W2_EXPLOJ") ) )
                oPrn:Say( Linha:=Linha+30 , 175  , STR0023,aFontes:TIMES_NEW_ROMAN_14_UNDERLINE ) //"** EXPORTADOR **"
                oPrn:Say( Linha:=Linha+80 , 175  , ALLTRIM(SW2->W2_EXPORTA) + Space(2) + IF(EICLOJA(),ALLTRIM(SW2->W2_EXPLOJ),"")+" - "+ALLTRIM(SA2->A2_NOME),aFontes:TIMES_NEW_ROMAN_12)
             ENDIF
          ELSE
             SA2->( DBSEEK( xFilial()+SW2->W2_FORN+EICRetLoja("SW2","W2_FORLOJ") ) )
             oPrn:Say( Linha:=Linha+30 , 175  , STR0025,aFontes:TIMES_NEW_ROMAN_14_UNDERLINE ) //"** FORNECEDOR **"
             oPrn:Say( Linha:=Linha+80 , 175  , ALLTRIM(SW2->W2_FORN) + Space(2) + IF(EICLOJA(),ALLTRIM(SW2->W2_FORLOJ),"")+" - "+ALLTRIM(SA2->A2_NOME),aFontes:TIMES_NEW_ROMAN_12)
          ENDIF

          SYA->(DBSEEK(xFilial("SYA")+SA2->A2_PAIS))
          cEndSA2 :=""
          cEndSA2 :=cEndSa2 + IF( !EMPTY(SA2->A2_MUN)   , ALLTRIM(SA2->A2_MUN)   +' - ', "" )
          cEndSA2 :=cEndSa2 + IF( !EMPTY(SA2->A2_ESTADO), ALLTRIM(SA2->A2_ESTADO)+' - ', "" )
          cEndSA2 :=cEndSa2 + IF( !EMPTY(SYA->YA_DESCR) , ALLTRIM(SYA->YA_DESCR) +' - ', "" )
          cEndSA2 := LEFT( cEndSA2, LEN(cEndSA2)-2 )

             oPrn:Say( Linha:=Linha+50 , 175  , STR0013,aFontes:COURIER_12 ) //"Tel.............:"
             oPrn:Say( Linha     , 725  , SA2->A2_TEL,aFontes:TIMES_NEW_ROMAN_12 )

             oPrn:Say( Linha:=Linha+50 , 175  , STR0014,aFontes:COURIER_12 ) //"Fax.............:"
                          oPrn:Say( Linha     , 725  , SA2->A2_FAX,aFontes:TIMES_NEW_ROMAN_12 )

             oPrn:Say( Linha:=Linha+50 , 175  , STR0015,aFontes:COURIER_12 ) //"Contato.........:"
             oPrn:Say( Linha     , 725  , SA2->A2_CONTATO,aFontes:TIMES_NEW_ROMAN_12 )

             oPrn:Say( Linha:=Linha+50 , 175  , STR0016,aFontes:COURIER_12 ) //"Endereco........:"
             oPrn:Say( Linha     , 725  , ALLTRIM(SA2->A2_END) +" "+ALLTRIM(SA2->A2_NR_END),aFontes:TIMES_NEW_ROMAN_12 )

             oPrn:Say( Linha:=Linha+50 , 725  , cEndSA2)

             SA6->(DBSETORDER(1))
             SA6->( DBSEEK( xFilial()+SA2->A2_BANCO+SA2->A2_AGENCIA) )
             oPrn:Say( Linha:=Linha+90 , 175  , STR0026,aFontes:COURIER_12 ) //"Dados Banqueiro.:"
             oPrn:Say( Linha     , 725  , IF(!EMPTY(ALLTRIM(SA2->A2_BANCO)),ALLTRIM(SA2->A2_BANCO),"")+;
                                          IF(!EMPTY(ALLTRIM(SA2->A2_AGENCIA))," - "+ALLTRIM(SA2->A2_AGENCIA),"")+;
                                          IF(!EMPTY(ALLTRIM(SA6->A6_NOME))," - "+ALLTRIM(SA6->A6_NOME),"")+;
                                          IF(!EMPTY(ALLTRIM(SA2->A2_NUMCON))," - "+ALLTRIM(SA2->A2_NUMCON),"") ,aFontes:TIMES_NEW_ROMAN_12)

          oPrn:Line( Linha:=Linha+60, 85, Linha  , 2345 )  ;  oPrn:Line( Linha+1,  75, Linha+1, 2345 )
      NEXT

      IncProc(STR0008) //"Imprimindo..."
      
      IF EICLOJA()
         bGrava  := {|| If( Ascan(aFabr,{|x| x[1]== SW3->W3_FABR .and. x[2]== SW3->W3_FABLOJ} )=0 ,Aadd( aFabr, {SW3->W3_FABR,SW3->W3_FABLOJ} ),)}   
      ELSE
         bGrava  := {|| If( Ascan(aFabr, SW3->W3_FABR )=0 ,Aadd( aFabr, SW3->W3_FABR ),)}
      ENDIF
      
      bWhile  := {|| xFilial("SW3") == SW3->W3_Filial  .AND.  SW2->W2_PO_NUM == SW3->W3_PO_NUM  }

      SW3->( DbSetOrder(1) )
      SW3->( DbSeek( xFilial("SW3")+SW2->W2_PO_NUM ) )
      SW3->( DbEval( bGrava,,bWhile ) )

      FOR i:=1 TO Len( aFabr )

          IF EICLOJA()
             If !Empty( aFabr[i][1] )  .and. !Empty( aFabr[i][2] )
                lContinua:= .T.
                SA2->(DBSETORDER(1))
                SA2->(DBSEEK(xFilial("SA2")+aFabr[i][1]+aFabr[i][2] ) )
                SYA->(DBSEEK(xFilial("SYA")+SA2->A2_PAIS))
             ENDIF
          ELSE
             If !Empty( aFabr[i] )
                lContinua:= .T.
                SA2->(DBSETORDER(1))
                SA2->(DBSEEK(xFilial("SA2")+aFabr[i] ) )
                SYA->(DBSEEK(xFilial("SYA")+SA2->A2_PAIS))
             ENDIF
          ENDIF
             
          IF lContinua   
                       
             cEndSA2 :=""
             cEndSA2 :=cEndSA2 + IF( !EMPTY(SA2->A2_BAIRRO), ALLTRIM(SA2->A2_BAIRRO)+' - ', "" )
             cEndSA2 :=cEndSA2 + IF( !EMPTY(SA2->A2_ESTADO), ALLTRIM(SA2->A2_ESTADO)+' - ', "" )
             cEndSA2 :=cEndSA2 + IF( !EMPTY(SA2->A2_PAIS  ), ALLTRIM(SA2->A2_PAIS  )+' - ', "" )
             cEndSA2 :=cEndSA2 + IF( !EMPTY(SYA->YA_DESCR ), ALLTRIM(SYA->YA_DESCR )+' - ', "" )
             cEndSA2 := LEFT( cEndSA2, LEN(cEndSA2)-2 )

             IF EMPTY(cOrig)
                cOrig:= ALLTRIM(SYA->YA_DESCR )
             ENDIF

             PARTE2:=0
             VERFIM()
             IF i==1
                oPrn:Say( Linha:=Linha+30 , 175  , STR0027,aFontes:TIMES_NEW_ROMAN_14_UNDERLINE ) //"** FABRICANTE **"
                IF EICLOJA()
                   oPrn:Say( Linha:=Linha+80 , 175  , aFabr[i][1]+aFabr[i][2]+'-'+SA2->A2_NOME ,aFontes:TIMES_NEW_ROMAN_12)
                ELSE
                   oPrn:Say( Linha:=Linha+80 , 175  , aFabr[i]+'-'+SA2->A2_NOME ,aFontes:TIMES_NEW_ROMAN_12)
                ENDIF
             ELSE
                IF EICLOJA()
                   oPrn:Say( Linha:=Linha+100, 175  , aFabr[i][1] + Space(2) + Alltrim(aFabr[i][2])+'-'+SA2->A2_NOME ,aFontes:TIMES_NEW_ROMAN_12)
                ELSE
                   oPrn:Say( Linha:=Linha+100, 175  , aFabr[i]+'-'+SA2->A2_NOME ,aFontes:TIMES_NEW_ROMAN_12)
                ENDIF
             ENDIF

             PARTE2:=0
             VERFIM()
             oPrn:Say( Linha:=Linha+50 , 175  , STR0028,aFontes:COURIER_12 ) //"Tel..............:"
             oPrn:Say( Linha     , 725  , SA2->A2_TEL,aFontes:TIMES_NEW_ROMAN_12 )

             PARTE2:=0
             VERFIM()
             oPrn:Say( Linha:=Linha+50 , 175  , STR0029,aFontes:COURIER_12 ) //"Fax..............:"
             oPrn:Say( Linha     , 725  , SA2->A2_FAX,aFontes:TIMES_NEW_ROMAN_12 )

             PARTE2:=0
             VERFIM()
             oPrn:Say( Linha:=Linha+50 , 175  , STR0030,aFontes:COURIER_12 ) //"Contato..........:"
             oPrn:Say( Linha     , 725  , SA2->A2_CONTATO,aFontes:TIMES_NEW_ROMAN_12 )

             PARTE2:=0
             VERFIM()
             oPrn:Say( Linha:=Linha+50 , 175  , STR0031,aFontes:COURIER_12 ) //"Endereco.........:"
             oPrn:Say( Linha     , 725  , SA2->A2_END+" "+SA2->A2_NR_END,aFontes:TIMES_NEW_ROMAN_12 )

             PARTE2:=0
             VERFIM()
             oPrn:Say( Linha:=Linha+50 , 725  , cEndSA2,aFontes:TIMES_NEW_ROMAN_12)
          Endif

          lContinua:= .F.
      NEXT

      oPrn:Line( Linha:=Linha+60, 85, Linha  , 2345 )  ;  oPrn:Line( Linha+1,  75, Linha+1, 2345 )

      IncProc(STR0008) //"Imprimindo..."
      PARTE2:=0
      VERFIM()
      oPrn:Say( Linha:=Linha+30 , 175  , STR0032,aFontes:TIMES_NEW_ROMAN_14_UNDERLINE ) //"** OBSERVACAO **"
      Linha:=Linha+40

      FOR I := 1 TO MLCOUNT(MSMM(SW2->W2_OBS),85)
          IF ! EMPTY(MSMM(SW2->W2_OBS,85,I))
             PARTE2:=0
             VERFIM()// Substituido pelo assistente de conversao do AP5 IDE em 26/11/99 ==>              Execute(VERFIM)
             oPrn:Say( Linha:=Linha+50 , 175  , MSMM(SW2->W2_OBS,85,I))
          ENDIF
      NEXT
      Linha:=Linha+40

      PARTE2:=0
      VERFIM()// Substituido pelo assistente de conversao do AP5 IDE em 26/11/99 ==>       Execute(VERFIM)

      IncProc(STR0008) //"Imprimindo..."
      oPrn:Say( Linha:=Linha+30 , 175  , STR0033,aFontes:COURIER_12 ) //"INCOTERMS................:"
      oPrn:Say( Linha     , 975 , ALLTRIM(SW2->W2_INCOTERMS)+" "+ALLTRIM(SW2->W2_COMPL_I) ,aFontes:TIMES_NEW_ROMAN_12)

      SYR->(DBSEEK(xFilial()+SW2->W2_TIPO_EM+SW2->W2_ORIGEM+SW2->W2_DEST))
      SYA->(DBSEEK(xFilial()+SYR->YR_PAIS_OR))
      PARTE2:=0
      VERFIM()// Substituido pelo assistente de conversao do AP5 IDE em 26/11/99 ==>       Execute(VERFIM)
      oPrn:Say( Linha:=Linha+50 , 175  , STR0034,aFontes:COURIER_12 ) //"PAIS DE PROCEDENCIA......:"
      oPrn:Say( Linha     , 975 , SYA->YA_DESCR,aFontes:TIMES_NEW_ROMAN_12 )
      PARTE2:=0
      VERFIM()// Substituido pelo assistente de conversao do AP5 IDE em 26/11/99 ==>       Execute(VERFIM)
      oPrn:Say( Linha:=Linha+50 , 175  , STR0035,aFontes:COURIER_12 ) //"PAIS DE ORIGEM...........:"
      oPrn:Say( Linha     , 975 , cOrig,aFontes:TIMES_NEW_ROMAN_12 )
      PARTE2:=0
      VERFIM()// Substituido pelo assistente de conversao do AP5 IDE em 26/11/99 ==>       Execute(VERFIM)
      oPrn:Say( Linha:=Linha+50 , 175  , STR0036,aFontes:COURIER_12 ) //"TRANSPORTE...............:"
      oPrn:Say( Linha     , 975 , SYQ->YQ_DESCR,aFontes:TIMES_NEW_ROMAN_12 )
      PARTE2:=0
      VERFIM()// Substituido pelo assistente de conversao do AP5 IDE em 26/11/99 ==>       Execute(VERFIM)
      oPrn:Say( Linha:=Linha+50 , 175  , STR0037,aFontes:COURIER_12 ) //"MODALIDADE DE CONTAINERS.:"
      oPrn:Say( Linha     , 975 , cModalidade,aFontes:TIMES_NEW_ROMAN_12 )
      PARTE2:=0
      VERFIM()// Substituido pelo assistente de conversao do AP5 IDE em 26/11/99 ==>       Execute(VERFIM)
      oPrn:Say( Linha:=Linha+50 , 175  , STR0038,aFontes:COURIER_12 ) //"DESTINO..................:"
      SY9->(DBSETORDER(2))
      SY9->(DBSEEK(xFilial()+SW2->W2_DEST))
      oPrn:Say( Linha     , 975 , ALLTRIM(SW2->W2_DEST) + " - " + ALLTRIM(SY9->Y9_DESCR),aFontes:TIMES_NEW_ROMAN_12 )
      SY9->(DBSETORDER(1))
      PARTE2:=0
      VERFIM()// Substituido pelo assistente de conversao do AP5 IDE em 26/11/99 ==>       Execute(VERFIM)
      IF !EMPTY(SW2->W2_REG_TRI)
         cRegime:=Tabela("Y2",SW2->W2_REG_TRI)
      ENDIF
      oPrn:Say( Linha:=Linha+50 , 175  , STR0039,aFontes:COURIER_12 ) //"REGIME...................:"
      oPrn:Say( Linha     , 975 , cRegime,aFontes:TIMES_NEW_ROMAN_12)

      IncProc(STR0008) //"Imprimindo..."
      PARTE2:=0
      VERFIM()
      SY6->(DBSEEK(xFILIAL()+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0)))
      mAux:=''
      mAux := MSMM(SY6->Y6_DESC_I,48)
      STRTRAN(mAux,CHR(13)+ CHR(10), " ")
      oPrn:Say( Linha:=Linha+50 , 175  , STR0040,aFontes:COURIER_12 ) //"FORMA DE PAGTO ao Forn...:"
      FOR I:=1 TO MLCOUNT(ALLTRIM(mAux),40)
          PARTE2:=0
          VERFIM()
          oPrn:Say( Linha , 975 , MEMOLINE(mAux,35,I),aFontes:TIMES_NEW_ROMAN_12 )
          Linha:=Linha+50
      NEXT

      PARTE2:=0
      VERFIM()
      SY6->(DBSEEK(xFILIAL()+SW2->W2_COND_EX+STR(SW2->W2_DIAS_EX,3,0)))
      mAux:=''
      mAux := MSMM(SY6->Y6_DESC_I,48)
      STRTRAN(mAux,CHR(13)+ CHR(10), " ")
      oPrn:Say( Linha:=Linha+50 , 175  , STR0041,aFontes:COURIER_12 ) //"FORMA DE PAGTO ao Export.:"
      IncProc(STR0008) //"Imprimindo..."

      FOR I:= 1 TO MLCOUNT(ALLTRIM(mAux),40)
          PARTE2:=0
          VERFIM()
          oPrn:Say( Linha     , 975 , MEMOLINE(mAux,35,I) )
          Linha:=Linha+50
      NEXT
      PARTE2:=0
      VERFIM()
      
      // GFP - 30/03/2012 - Ajuste no alinhamento dos campos do relatorio
      oPrn:Say( Linha:=Linha+50 , 175  , STR0042 /*+SW2->W2_MOEDA+spac(13)+TRANS(SW2->W2_INLAND,AVSX3("W2_INLAND",6))*/,aFontes:COURIER_12,,,1) //"FRETE INTERNO............: "
      oPrn:Say( Linha           , 850  , SW2->W2_MOEDA ,aFontes:COURIER_12,,,1)
      oPrn:Say( Linha           , 975  , TRANS(SW2->W2_INLAND,AVSX3("W2_INLAND",6)) ,aFontes:COURIER_12,,,1)
      PARTE2:=0
      VERFIM()
      oPrn:Say( Linha:=Linha+50 , 175  , STR0043 /*+SW2->W2_MOEDA+spac(13)+TRANS(0,'@E 999,999,999,999.99')*/,aFontes:COURIER_12,,,1) //"DESP. DOCUMENTACAO.......: "
      oPrn:Say( Linha           , 850  , SW2->W2_MOEDA ,aFontes:COURIER_12,,,1)
      oPrn:Say( Linha           , 975  , TRANS(0,'@E 999,999,999,999.99') ,aFontes:COURIER_12,,,1)
      PARTE2:=0
      VERFIM()
      oPrn:Say( Linha:=Linha+50 , 175  , STR0044 /*+SW2->W2_MOEDA+spac(13)+TRANS(SW2->W2_PACKING,AVSX3("W2_PACKING",6))*/,aFontes:COURIER_12,,,1) //"DESP. EMBALAGEM..........: "
      oPrn:Say( Linha           , 850  , SW2->W2_MOEDA ,aFontes:COURIER_12,,,1)
      oPrn:Say( Linha           , 975  , TRANS(SW2->W2_PACKING,AVSX3("W2_PACKING",6)) ,aFontes:COURIER_12,,,1)
      PARTE2:=0
      VERFIM()
      oPrn:Say( Linha:=Linha+50 , 175  , STR0045 /*+SW2->W2_MOEDA+spac(13)+TRANS(SW2->W2_FRETEINT,AVSX3("W2_FRETEINT",6))*/,aFontes:COURIER_12,,,1) //"FRETE INTERNACIONAL......: "
      oPrn:Say( Linha           , 850  , SW2->W2_MOEDA ,aFontes:COURIER_12,,,1)
      oPrn:Say( Linha           , 975 , TRANS(SW2->W2_FRETEINT,AVSX3("W2_FRETEINT",6)) ,aFontes:COURIER_12,,,1)
      PARTE2:=0
      VERFIM()
      oPrn:Say( Linha:=Linha+50 , 175  , STR0046 /*+SW2->W2_MOEDA+spac(13)+TRANS(SW2->W2_DESCONT,AVSX3("W2_DESCONT",6))*/,aFontes:COURIER_12,,,1) //"DESCONTOS................: "
      oPrn:Say( Linha           , 850  , SW2->W2_MOEDA ,aFontes:COURIER_12,,,1)
      oPrn:Say( Linha           , 975 , TRANS(SW2->W2_DESCONT,AVSX3("W2_DESCONT",6)) ,aFontes:COURIER_12,,,1)
      PARTE2:=0
      VERFIM()

      //TDF 02/02/12 - TRATAMENTO PARA FRETE INCLUSO SIM
      If SW2->W2_FREINC == "1" 
         nTotalGeral := SW2->W2_FOB_TOT - SW2->W2_DESCONT 
      Else
         nTotalGeral := (SW2->W2_FOB_TOT+SW2->W2_INLAND+SW2->W2_PACKING+SW2->W2_FRETEINT)-SW2->W2_DESCONT 
      EndIf
      
      oPrn:Say( Linha:=Linha+50, 175, STR0047+ALLTRIM(SW2->W2_INCOTER)+" "+ALLTRIM(SW2->W2_COMPL_I)+": " /*+SW2->W2_MOEDA+" "+TRANS(nTotalGeral,_PictPrTot)*/,aFontes:COURIER_12,,,1) //"TOTAL "
      oPrn:Say( Linha          , 850, SW2->W2_MOEDA ,aFontes:COURIER_12,,,1)
      oPrn:Say( Linha          , 975, TRANS(nTotalGeral,_PictPrTot) ,aFontes:COURIER_12,,,1)      
      // Fim GFP - 30/03/2012
      
      PARTE2:=0
      IF ! VERFIM()
         oPrn:Line( Linha:=Linha+60, 85, Linha , 2345 )  ;  oPrn:Line( Linha+1,  75, Linha+1, 2345 )
      ENDIF
      oPrn:Say( Linha:=Linha+30 , 175  , STR0048,aFontes:TIMES_NEW_ROMAN_14_UNDERLINE ) //"*** MATERIAL A IMPORTAR ***"
      Linha:=Linha+100

      //+---------------------------------------------------------+
      //¦ Imprime os Itens                                        ¦
      //+---------------------------------------------------------+

      SW3->( DbSetOrder(1) )
      SW3->( DbSeek( xFilial()+SW2->W2_PO_NUM ) )

      IncProc(STR0008) //"Imprimindo..."

      PO562Cab_Itens()

      While !SW3->(Eof()) .and. SW3->W3_FILIAL == xFilial("SW3") .AND. SW3->W3_PO_NUM == SW2->W2_PO_NUM

              //+--------------------------------------------------------------+
              //¦ Verifica se havera salto de formulario                       ¦
              //+--------------------------------------------------------------+

            If SW3->W3_SEQ #0
               SW3->(DBSKIP())
               LOOP
            Endif

            If Linha >= 3000
               COMECA_PAGINA
            Endif

              //+--------------------------------------------------------------+
              //¦ Imprimir a Linha de Itens                                    ¦
              //+--------------------------------------------------------------+

              PO562Item()

              dbSelectArea("SW3")
              dbSkip()

      End
      IncProc(STR0008) //"Imprimindo..."

      lBateSubCab:=.F.

      PO562Totais()

      TRACO_NORMAL
      Linha:=Linha+200

      oPrn:Line( Linha, 25, Linha, 1175 )  ;  oPrn:Line( Linha+1, 25, Linha+1, 1175 )
      Linha := Linha+70
      oPrn:Say( Linha, 25, IF(GetMv("MV_ID_CLI")$cSim,SA1->A1_NOME,SY1->Y1_NOME), aFontes:TIMES_NEW_ROMAN_12 )
      IncProc(STR0008) //"Imprimindo..."

   AVENDPAGE

AVENDPRINT

oFont1:End()
oFont2:End()
oFont3:End()
oFont4:End()
oFont5:End()
oFont6:End()
oFont7:End()
oFont8:End()
oFont9:End()

RETURN NIL


*---------------------------*
Static FUNCTION Po562Cab()
*---------------------------*

Linha := 100

oPrn:Line( Linha, 85, Linha  , 2345 )      ;  oPrn:Line( Linha+1,  75, Linha+1, 2345 )
oPrn:Line( Linha:=Linha+10, 85, Linha  , 2345 )  ;  oPrn:Line( Linha+1,  75, Linha+1, 2345 )

oPrn:Say( Linha:=Linha+15, 800 , STR0007, aFontes:TIMES_NEW_ROMAN_14_BOLD ) //"PROPOSTA DE IMPORTACAO"
oPrn:Say( Linha:=Linha+70, 85 , STR0049+dtoc(dDataBase), aFontes:TIMES_NEW_ROMAN_12) //"Data: "
oPrn:Say( Linha    , 2000 , STR0050+STRZERO(oPrn:nPage,3),aFontes:TIMES_NEW_ROMAN_12) //"PAG.: "

oPrn:Say( Linha:=Linha+70 , 85 , STR0051 + TRANS(SW2->W2_PO_NUM,_PictPO),aFontes:TIMES_NEW_ROMAN_14_BOLD ) //"Pedido No.: "

oPrn:Line( Linha:=Linha+80, 85, Linha  , 2345 ) ;  oPrn:Line( Linha+1,  75, Linha+1, 2345 )
oPrn:Line( Linha:=Linha+10, 85, Linha  , 2345 ) ;  oPrn:Line( Linha+1,  75, Linha+1, 2345 )


Return NIL

*---------------------*
Static FUNCTION VERFIM()
*---------------------*

//****PARTE2 E VARIAVEL PARAMETRIZADA NAS CHAMADAS DA FUNCAO

IF Linha >= 3000
   oPrn:Line( Linha:=Linha+70 , 85, Linha  , 2345 )  ;  oPrn:Line( Linha+1,  75, Linha+1, 2345 )

   AVNEWPAGE

   Po562Cab()
   IF PARTE2 > 0
      PO562Cab_Itens()// Substituido pelo assistente de conversao do AP5 IDE em 26/11/99 ==>       Execute(PO562Cab_Itens)
   ENDIF
   RETURN .T.
ENDIF

RETURN .F.

*------------------------------*
Static FUNCTION PO562Cab_Itens()
*------------------------------*

Linha:=Linha+20

lBateSubCab:=IF(lBateSubCab==NIL,.T.,lBateSubCab)

IF lBateSubCab
   pTIPO:=4
   PO562BateTraco()
   TRACO_NORMAL
   pTIPO:=2
   PO562BateTraco()          

   Linha:=Linha+20
   pTIPO:=4
   PO562BateTraco()

   oPrn:Say( Linha,   20, STR0052           , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"IT"
   oPrn:Say( Linha,  125, STR0053           , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Consignee"
   oPrn:Say( Linha,  390, STR0054           , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Quantidade"
   oPrn:Say( Linha,  650, STR0055           , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"DescriþÒo"
   oPrn:Say( Linha, 1270, STR0056           , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Fabricante"
   oPrn:Say( Linha, 1540, STR0057           , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Preþo"
   oPrn:Say( Linha, 1760, STR0058           , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"   Total"
   oPrn:Say( Linha, 1980, STR0059           , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Dt Prev."
   oPrn:Say( Linha, 2140, STR0059           , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Dt Prev."

   Linha:=Linha+50
   pTIPO:=5
   PO562BateTraco()
   oPrn:Say( Linha,   20, STR0060                   , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Nb"
   oPrn:Say( Linha, 1540, STR0061             , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Unitßrio"
   oPrn:Say( Linha, 1790, SW2->W2_MOEDA          , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
   oPrn:Say( Linha, 1980, STR0062              , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Embarq."
   oPrn:Say( Linha, 2140, STR0063              , aFontes:TIMES_NEW_ROMAN_10_NEGRITO ) //"Entrega"

   Linha:=Linha+50
   TRACO_NORMAL

ENDIF

RETURN NIL

*--------------------------*
Static FUNCTION PO562Item()
*--------------------------*
Local i
Local nInc:= 0
cDescrItem:=""
nNumero   :=1

//-----------> Unidade Requisitante (C.Custo).
SY3->( DBSETORDER( 1 ) )
SY3->( DBSEEK( xFilial()+SW3->W3_CC ) )

//-----------> Fornecedores.
SA2->( DBSETORDER( 1 ) )
SA2->( DBSEEK( xFilial()+SW3->W3_FABR+EICRetLoja("SW3","W3_FABLOJ") ) )

//-----------> Produtos (Itens) e Textos.
SB1->( DBSETORDER(1) )
SB1->( DBSEEK( xFilial()+SW3->W3_COD_I ) )

cDescrItem := MSMM(SB1->B1_DESC_I,36)
STRTRAN(cDescrItem,CHR(13)+CHR(10)," ")

//-----------> Produtos X Fornecedor.
SA5->( DBSETORDER( 3 ) )
SA5->( DBSEEK( xFilial()+SW3->W3_COD_I+SW3->W3_FABR+SW3->W3_FORN ) )

//-----------> Registro no Ministerio.
SYG->(DBSETORDER(1))
SYG->(DBSEEK(xFilial()+SW2->W2_IMPORT+SW3->W3_FABR+SW3->W3_COD_I))

//--> Inicio da Impressao ( Itens )

pTIPO:=2
PO562BateTraco()

Linha:=Linha+50

pTIPO:=4
PO562BateTraco()


oPrn:Say( Linha,  20, STRZERO(nCont:=nCont+1,3)  , aFontes:TIMES_NEW_ROMAN_08_NEGRITO )

SYT->(DbSetOrder(1))
If SYT->(DbSeek(xFilial("SYT")+ SW2->W2_CONSIG))
   oPrn:Say( Linha, 105, Substr(SYT->YT_NOME_RE,1,15), aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
Endif

oPrn:Say( Linha, 560, TRANS(SW3->W3_QTDE,_PictQtde), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )

/* FCD
If !Empty(SA5->A5_UNID)
   oPrn:Say( Linha, 570, SA5->A5_UNID                         , aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
Else
   oPrn:Say( Linha, 570, SB1->B1_UM                           , aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
EndIf
*/                           
//SO.:0022/02 OS.:0155/02
oPrn:Say( Linha, 570,BUSCA_UM(SW3->W3_COD_I+SW3->W3_FABR +SW3->W3_FORN,SW3->W3_CC+SW3->W3_SI_NUM)                            , aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
oPrn:Say( Linha, 645, MEMOLINE( cDescrItem,30 ,1 ), aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
oPrn:Say( Linha,1185, LEFT(SA2->A2_NREDUZ,10)     , aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
oPrn:Say( Linha,1690, TRANS(SW3->W3_PRECO,_PictPrUn), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
oPrn:Say( Linha,1930, TRANS(SW3->W3_QTDE*SW3->W3_PRECO,_PictPrUn ), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )
oPrn:Say( Linha,1980, DATA_MES(SW3->W3_DT_EMB)        , aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
oPrn:Say( Linha,2155, DATA_MES(SW3->W3_DT_ENTR)       , aFontes:TIMES_NEW_ROMAN_08_NEGRITO )

Linha:=Linha+50

n1 := ( MlCount( cDescrItem, 30 ) + 1 + 2 + 1 ) - 1

SYT->(DbSetOrder(1))
SYT->(DbSeek(xFilial("SYT")+ SW2->W2_CONSIG))

n2 := (MLCOUNT( ALLTRIM(SYT->YT_NOME_RE), 12 )  + 1 + 2 + 1 ) - 1

n1 := IF( n1 > n2, n1, n2 )

nInc:= 1

FOR i:=1 TO n1 + 1   // Soma um para bater o ultimo.

    lPulaLinha := .F.

    IF Linha >= 3000
       TRACO_NORMAL
       COMECA_PAGINA
       pTIPO:=5
       PO562BateTraco()
       Linha:=Linha+50
    ENDIF

   
    //IF nInc == 1
      // IF !EMPTY(SYT->YT_NOME_RE)   
          
        //  oPrn:Say( Linha, 105, Substr(SYT->YT_NOME_RE,1,15), aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
        //  lPulaLinha := .T.
      // ENDIF
    //ENDIF
    
    IF !EMPTY( MEMOLINE(SYT->YT_NOME_RE,12,i) )
       oPrn:Say( Linha, 105, MEMOLINE(SYT->YT_NOME_RE,12,i), aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
       lPulaLinha := .T.
    ENDIF
    
    IF ! EMPTY( MEMOLINE( cDescrItem,30, i ) )
       oPrn:Say( Linha, 645, MEMOLINE( cDescrItem,30,i ), aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
       lPulaLinha := .T.
    ENDIF


    IF EMPTY( MEMOLINE( cDescrItem,30, i ) )
       IF nNumero == 1
           If SW3->(FieldPos("W3_PART_N")) # 0 .AND. !EMPTY(SW3->W3_PART_N) //ASK 08/10/2007 
              oPrn:Say( Linha, 645 , SW3->W3_PART_N,  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
              lPulaLinha := .T.     
           Else   
              If !Empty( SA5->A5_CODPRF )
                 oPrn:Say( Linha, 645 , SA5->A5_CODPRF,  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
                 lPulaLinha := .T.
              Endif
           EndIf
           nNumero:=nNumero+1

        ELSEIF nNumero == 2
           If !Empty( MEMOLINE(SA5->A5_PARTOPC,24,1) )
              oPrn:Say( Linha, 645 , MEMOLINE(SA5->A5_PARTOPC,24,1),  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
              lPulaLinha := .T.
           Endif
           nNumero:=nNumero+1

        ELSEIF nNumero == 3
           If !Empty( MEMOLINE(SA5->A5_PARTOPC,24,2) )
              oPrn:Say( Linha, 645 , MEMOLINE(SA5->A5_PARTOPC,24,2),  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
              lPulaLinha := .T.
           Endif
           nNumero:=nNumero+1

        ELSEIF nNumero == 4
           If !Empty( SYG->YG_REG_MIN )
              oPrn:Say( Linha, 645 , SYG->YG_REG_MIN,  aFontes:TIMES_NEW_ROMAN_08_NEGRITO )
              lPulaLinha := .T.
           Endif
           nNumero:=nNumero+1

        ENDIF
    ENDIF

    IF !EMPTY( RIGHT(SA2->A2_NREDUZ, 10 ) )  .AND.  i == 2
       oPrn:Say( Linha,1275, RIGHT(SA2->A2_NREDUZ,10), aFontes:TIMES_NEW_ROMAN_08_NEGRITO)
       lPulaLinha := .T.
    ENDIF

    pTIPO:=5
    PO562BateTraco()

    If lPulaLinha
       Linha:=Linha+50
    Endif
    
    nInc++

NEXT

RETURN NIL

*----------------------------*
Static FUNCTION PO562Totais()
*----------------------------*
          
pTIPO:=5
PO562BateTraco()

If Linha >= 3000
   TRACO_NORMAL
   COMECA_PAGINA
   oPrn:Box( Linha:=Linha+50, 05, Linha+1, 2305 )
   pTIPO:=6
   PO562BateTraco()
   Linha:=Linha+50
else
   pTIPO:=4
   PO562BateTraco()
   Linha:=Linha+50
   TRACO_NORMAL
Endif

pTIPO:=6
PO562BateTraco()
Linha:=Linha+50

pTIPO:=6
PO562BateTraco()
oPrn:Say( Linha, 1205 , STR0047 + ALLTRIM( SW2->W2_INCOTER )      , aFontes:COURIER_08_NEGRITO ) //"TOTAL "
oPrn:Say( Linha, 1595 , SW2->W2_MOEDA                              , aFontes:COURIER_08_NEGRITO )
oPrn:Say( Linha,2045, TRANS(SW2->W2_FOB_TOT,_PictPrTot)  , aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )


Linha:=Linha+50
If Linha >= 3000
   TRACO_NORMAL
   COMECA_PAGINA
   oPrn:Box( Linha:=Linha+50, 05, Linha+1, 2305 )
   pTIPO:=6
   PO562BateTraco()
   Linha:=Linha+50
else
   pTIPO:=6
   PO562BateTraco()
   TRACO_REDUZIDO
   Linha:=Linha+50
Endif

pTIPO:=6
PO562BateTraco()
oPrn:Say( Linha, 1205 , STR0064                           , aFontes:COURIER_08_NEGRITO ) //"INLAND CHARGES"
oPrn:Say( Linha,2045, TRANS(SW2->W2_INLAND,AVSX3("W2_INLAND",6)), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )

Linha:=Linha+50
If Linha >= 3000
   TRACO_NORMAL
   COMECA_PAGINA
   oPrn:Box( Linha:=Linha+50, 05, Linha+1, 2305 )
   pTIPO:=6
   PO562BateTraco()
   Linha:=Linha+50
else
   pTIPO:=6
   PO562BateTraco()
   TRACO_REDUZIDO
   Linha:=Linha+50
Endif

pTIPO:=6
PO562BateTraco()
oPrn:Say( Linha, 1205 , STR0065                           , aFontes:COURIER_08_NEGRITO ) //"PACKING CHARGES"
oPrn:Say( Linha,2045, TRANS(SW2->W2_PACKING,AVSX3("W2_PACKING",6)), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )

Linha:=Linha+50
If Linha >= 3000
   TRACO_NORMAL
   COMECA_PAGINA
   oPrn:Box( Linha:=Linha+50, 05, Linha+1, 2305 )
   pTIPO:=6
   PO562BateTraco()
   Linha:=Linha+50
else
   pTIPO:=6
   PO562BateTraco()
   TRACO_REDUZIDO
   Linha:=Linha+50
Endif

pTIPO:=6
PO562BateTraco()
oPrn:Say( Linha, 1205 , STR0066                              , aFontes:COURIER_08_NEGRITO ) //"INT'L FREIGHT"
oPrn:Say( Linha,2045, TRANS(SW2->W2_FRETEINT,AVSX3("W2_FRETEINT",6)), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )

Linha:=Linha+50
If Linha >= 3000
   TRACO_NORMAL
   COMECA_PAGINA
   oPrn:Box( Linha:=Linha+50, 05, Linha+1, 2305 )
   pTIPO:=6
   PO562BateTraco()
   Linha:=Linha+50
else
   pTIPO:=6
   PO562BateTraco()
   TRACO_REDUZIDO
   Linha:=Linha+50
Endif

pTIPO:=6
PO562BateTraco()
oPrn:Say( Linha, 1205 , STR0067                                  , aFontes:COURIER_08_NEGRITO ) //"DISCOUNT"
oPrn:Say( Linha,2045, TRANS(SW2->W2_DESCONT,AVSX3("W2_DESCONT",6)), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )


Linha:=Linha+50
If Linha >= 3000
   TRACO_NORMAL
   COMECA_PAGINA
   oPrn:Box( Linha:=Linha+50, 05, Linha+1, 2305 )
   pTIPO:=6
   PO562BateTraco()
   Linha:=Linha+50
else
   pTIPO:=6
   PO562BateTraco()
   TRACO_REDUZIDO
   Linha:=Linha+50
Endif

pTIPO:=6
PO562BateTraco()
//TDF 02/02/12 - TRATAMENTO PARA FRETE INCLUSO SIM
If SW2->W2_FREINC == "1" 
   nTotalGeral := SW2->W2_FOB_TOT - SW2->W2_DESCONT 
Else
   nTotalGeral := (SW2->W2_FOB_TOT+SW2->W2_INLAND+SW2->W2_PACKING+SW2->W2_FRETEINT)-SW2->W2_DESCONT  
EndIf

oPrn:Say( Linha, 1205 , STR0047 + ALLTRIM( SW2->W2_INCOTER )         , aFontes:COURIER_08_NEGRITO ) //"TOTAL "
oPrn:Say( Linha,2045, TRANS(nTotalGeral,_PictPrTot), aFontes:TIMES_NEW_ROMAN_08_NEGRITO,,,,1 )

Linha:=Linha+50


RETURN NIL


*------------------------------*
Static FUNCTION PO562BateTraco()
*------------------------------*

//pTIPO E VARIAVEL PARAMETRIZADA NAS CHAMADAS DA FUNCAO

If pTipo == 1      .OR.  pTipo == 2  .OR. pTipo == 7
   xLinha := 100

ElseIf pTipo == 3  .OR.  pTipo == 4
   xLinha := 20

ElseIf pTipo == 5  .OR.  pTipo == 6
   xLinha := 50

Endif


DO CASE

   CASE pTipo == 1  .OR.  pTipo == 3
        oPrn:Line( Linha,   05, (Linha+xLinha),   05 )
        oPrn:Line( Linha,   06, (Linha+xLinha),   06 )
        
        oPrn:Line( Linha, 2345, (Linha+xLinha), 2345 )        
        oPrn:Line( Linha, 2346, (Linha+xLinha), 2346 )


   CASE pTipo == 2  .OR.  pTipo == 4  .OR.  pTipo == 5
   
        oPrn:Line( Linha,   05, (Linha+xLinha),   05 )
        oPrn:Line( Linha,   06, (Linha+xLinha),   06 )//1
        
        oPrn:Line( Linha,   75, (Linha+xLinha),   75 )
        oPrn:Line( Linha,   76, (Linha+xLinha),   76 )//2
        
        oPrn:Line( Linha,  325, (Linha+xLinha),  325 )
        oPrn:Line( Linha,  326, (Linha+xLinha),  326 )//3
        
        oPrn:Line( Linha,  615, (Linha+xLinha),  615 )
        oPrn:Line( Linha,  614, (Linha+xLinha),  614 )//4
        
        oPrn:Line( Linha, 1470, (Linha+xLinha), 1470 )
        oPrn:Line( Linha, 1471, (Linha+xLinha), 1471 )//5
        
        oPrn:Line( Linha, 1700, (Linha+xLinha), 1700 )
        oPrn:Line( Linha, 1701, (Linha+xLinha), 1701 )//6
        
        oPrn:Line( Linha, 1950, (Linha+xLinha), 1950 )
        oPrn:Line( Linha, 1951, (Linha+xLinha), 1951 )//7
        
        oPrn:Line( Linha, 2125, (Linha+xLinha), 2125 )
        oPrn:Line( Linha, 2126, (Linha+xLinha), 2126 )//8
        
        oPrn:Line( Linha, 2305, (Linha+xLinha), 2305 )
        oPrn:Line( Linha, 2306, (Linha+xLinha), 2306 )//9

   CASE pTipo == 6  .OR.  pTipo == 7
        oPrn:Line( Linha,   05, (Linha+xLinha),   05 )
        oPrn:Line( Linha,   06, (Linha+xLinha),   06 )
        
        oPrn:Line( Linha, 1175, (Linha+xLinha), 1175 )        
        oPrn:Line( Linha, 1176, (Linha+xLinha), 1176 )
        
        oPrn:Line( Linha, 2305, (Linha+xLinha), 2305 )        
        oPrn:Line( Linha, 2306, (Linha+xLinha), 2306 )


ENDCASE


RETURN NIL


