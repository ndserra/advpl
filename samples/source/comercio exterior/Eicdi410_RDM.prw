///FunCao    : EICDI410  
///Autor     : AVERAGE/ALEX WALLAUER 
///Data      : 06/09/00
///Descricao : Controle de Saldo de Containers 
///Sintaxe   : EICDI410 
/// Uso      : PROTHEUS V508
#include 'rwmake.ch'        // incluido pelo assistente de conversao do AP5 IDE em 11/02/00
#INCLUDE 'Eicdi410.ch'
#INCLUDE "AVERAGE.CH"

#DEFINE EXCLUIR  4
#DEFINE ALTERAR  3
#DEFINE INCLUIR  2
#DEFINE ESTORNO  3
#DEFINE OK       1
#DEFINE SAIR     0

*--------------------------------*
User Function Eicdi410() 
*--------------------------------*

Private nOpc
lRet :=.T.
lTudo:=.F.

cPrograma := 'TELA'

IF TYPE('ParamIXB') == 'C'
   cPrograma := ParamIXB
ENDIF  

IF cPrograma == 'EICDI410'
   lRet :=DI410_Val()
ElseIf cPrograma == 'JD_DEVOLUC'
   lRet :=DI410_Devo('JD_DEVOLUC') 
   DI410_Saldo()
ElseIf cPrograma == 'JD_DTPREVI' //FSM - 17/06/2011
   lRet :=DI410_Devo('JD_DTPREVI') 
ElseIf cPrograma == 'ATUSALDO'
   lRet :=DI410_Saldo()        
ElseIf cPrograma == 'VERCHAVE'
   lRet :=DI410_ExChave()        
ELSE
   DI410Main()
ENDIF


Return(lRet)

*--------------------------*
Static FUNCTION DI410Main()
*--------------------------*
dbSelectArea('SW6')



lCfg := .T.
aPos := { 15, 1, 142, 315 }
bTam := {|cpo,pos,array| array := TamSx3(cpo), array[pos] }
bEdit:= {||nOpc:=2, DI410Manut() }
bEsto:= {||nOpc:=3, DI410Manut() }
bTotal  := {||SW6->W6_CONTA20+SW6->W6_CONTA40+SW6->W6_CON40HC+SW6->W6_OUTROS}
aFixos  := {}
aRotina := MenuDef()

aAdd( aFixos, { STR0004, "W6_HAWB"     } ) //"Processo"
//aAdd( aFixos, { STR0004, "W6_HAWB"     , 'C', Eval(bTam,"W6_HAWB",1), 0, AllTrim(X3Picture("W6_HAWB")) } ) //"Processo"
aAdd( aFixos, { STR0005, "Eval(bTotal)", 'N', 6, 0, nil } ) //"Total Cont's"
aAdd( aFixos, { STR0006, "W6_TOT_REC"  , 'N', 6, 0, nil } ) //"Total Recibidos"
aAdd( aFixos, { STR0007, "W6_DT_EMB"   , 'D', 8, 0, nil } ) //"Dt Embarque"
//aAdd( aFixos, { STR0008, "W6_DI_NUM"   , 'C', Eval(bTam,"W6_DI_NUM",1), 0, AllTrim(X3Picture("W6_DI_NUM")) } ) //"No. da D.I."
aAdd( aFixos, { STR0008, "W6_DI_NUM"   } ) //"No. da D.I."
aAdd( aFixos, { STR0009, "W6_DT"       , 'D', 8, 0, nil } ) //"Dt Pagto. Imp."
aAdd( aFixos, { STR0010, "W6_DT_DESE"  , 'D', 8, 0, nil } ) //"Dt Desembaraco"
aAdd( aFixos, { STR0011, "W6_CONTA20"  , 'N', 4, 0, nil } ) //"Container 20"
aAdd( aFixos, { STR0012, "W6_CONTA40"  , 'N', 4, 0, nil } ) //"Container 40"
aAdd( aFixos, { STR0013, "W6_CON40HC"  , 'N', 4, 0, nil } ) //"Container 40 HC"
aAdd( aFixos, { STR0014, "W6_OUTROS"   , 'N', 4, 0, nil } ) //"Outros Cont's"

aHeader:={}
aCampos:=ARRAY( SJD->(FCOUNT()) )
aSemSX3:={{'WKRECNO','N',7,0}}
AADD(aSemSX3,{"TRB_ALI_WT","C",03,0})//TRP - 25/01/07 - Campos do WalkThru
AADD(aSemSX3,{"TRB_REC_WT","N",10,0})

cNomArq:=E_CriaTrab('SJD',aSemSX3,'Work')
IndRegua('Work',cNomArq+OrdBagExt(),'JD_TIPO_CT+DTOS(JD_DT_ENT)')

cNomArq2:=CriaTrab(Nil,.f.)
IndRegua('Work',cNomArq2+OrdBagExt(),'JD_ARMADOR+JD_TIPO_CT')

cNomArq3:=CriaTrab(Nil,.f.)
IndRegua('Work',cNomArq3+OrdBagExt(),'JD_CONTAIN')

Set Index to (cNomArq+OrdBagExt()),(cNomArq2+OrdBagExt()),(cNomArq3+OrdBagExt())

//copy to alex
cCadastro:=STR0015 //"Controle de Saldo de Containers"

mBrowse( 6, 1,22,75,'SW6', aFixos)

Work->(E_EraseArq(cNomArq,cNomArq2))
//Work->(E_EraseArq(cNomArq2))

dbSelectArea('SW6')

Return .T. 


/*
Funcao     : MenuDef()
Parametros : Nenhum
Retorno    : aRotina
Objetivos  : Menu Funcional
Autor      : Adriane Sayuri Kamiya
Data/Hora  : 31/01/07 - 17:05
*/
Static Function MenuDef()
Local aRotAdic := {}
Local aRotina  := { { STR0001   ,'AxPesqui'   , 0 , 1},; //"Pesquisar"
                    { STR0002   ,'Eval(bEdit)', 0 , 4},; //"Manut. Cont's"
                    { STR0003   ,'Eval(bEsto)', 0 , 2},;//"Estorno Cont's" 
                    { "Pequisar Container", 'DI410PesqCont()',0,1}} //Pequisar Container

If AvFlags("DEMURRAGE")// FSM -  21/06/11 
   aAdd(aRotina,{ "Rel. Demurrage" , "U_EICDI450()" ,0,1}) //Rel. Demurrage   
EndIf
                    
// P.E. utilizado para adicionar itens no Menu da mBrowse
If ExistBlock("IDI410MNU")
	aRotAdic := ExecBlock("IDI410MNU",.f.,.f.)
	If ValType(aRotAdic) == "A"
		AEval(aRotAdic,{|x| AAdd(aRotina,x)})
	EndIf
EndIf

Return aRotina

*--------------------------------*
Static FUNCTION DI410Manut()
*--------------------------------*
Private oContaTotal, oDlg, oPanel
Private oArmNome

cFilSJD:=xFilial('SJD')
SJD->(DBSETORDER(1))
IF !SJD->(DBSEEK(cFilSJD+SW6->W6_HAWB)) .AND.  nOpc == ESTORNO
   Help("", 1, "AVG0000122")//E_MSG(STR0016,1) //"Processo nÆo tem Containers cadastrados"
   RETURN .F.
ENDIF

cTitle:= STR0017+ALLTRIM(SW6->W6_HAWB) //"Controle de Saldo de Containers - Processo: "
bGrava:={||DI410GeraWork()}
bWhile:={||cFilSJD==SJD->JD_FILIAL .AND. SW6->W6_HAWB==SJD->JD_HAWB}
aPos  :={15,1,70,315}
bTipo :={||IF(Work->JD_TIPO_CT=='1',STR0018,; //"1-Container 20"
           IF(Work->JD_TIPO_CT=='2',STR0019,; //"2-Container 40"
           IF(Work->JD_TIPO_CT=='3',STR0020,; //"3-Container 40 HC"
           STR0021)))} //"4-Outros"

bTipo2:={||IF(M->JD_TIPO_CT=='1',STR0011,; //"Container 20"
           IF(M->JD_TIPO_CT=='2',STR0012,; //"Container 40"
           IF(M->JD_TIPO_CT=='3',STR0013,; //"Container 40 HC"
           STR0022)))} //"Outros"

Conta20_Rec:=0
Conta40_Rec:=0
Con40HC_Rec:=0
Outros_Rec :=0
ConTot_Rec :=0
aDeletados :={}
nRecnoWork := 0

Work->(__DBZAP())

Processa({||ProcRegua(SJD->(LASTREC())),SJD->(DBEVAL(bGrava,,bWhile))},STR0023) //"Processando Registros"

TB_Campos:={}
AADD(Tb_Campos,{{||Posicione("SY5",1,xFilial("SY5")+Work->JD_ARMADOR,"Y5_NOME") },'',STR0066})
AADD(Tb_Campos,{{||Trans(Work->JD_CONTAIN,AVSX3("JD_CONTAIN",6))},'',AVSX3("JD_CONTAIN",5) }) //Numero do container
AADD(Tb_Campos,{bTipo       ,'',STR0024}) //"Tipo Cont's"
AADD(Tb_Campos,{"JD_DT_ENT" ,'',STR0025}) //"Dt Entrega"
AADD(Tb_Campos,{"JD_DEVOLUC",'',STR0064}) //"Dt Devolucao"
AADD(Tb_Campos,{"JD_NF"     ,'',STR0027}) //"No. NF"
AADD(Tb_Campos,{"JD_NF_SERI",'',STR0028}) //"Serie NF"
AADD(Tb_Campos,{"JD_DT_NF"  ,'',STR0029}) //"Data NF"
AADD(Tb_Campos,{"JD_OBS"    ,'',STR0030}) //"Observacoes"

ContaTotal := 0   
nConta20   := SW6->W6_CONTA20 
nConta40   := SW6->W6_CONTA40 
nConta40HC := SW6->W6_CON40HC 
nContaOutr := SW6->W6_OUTROS  
cArmador   := SW6->W6_ARMADOR
cArmNome   := Space(40)

If !Empty(cArmador)
    SY5->(dbSetOrder(1))
    SY5->(dbSeek(xFilial("SY5")+cArmador))
	cArmNome := SY5->Y5_NOME
EndIf	

fSomaCont()

While .T.

   nOpcA:=0        
   
   dbSelectArea('SW6')
   Work->(DBGOTOP())       
   
  TB_Campos:= AddCpoUser(TB_Campos,"SJD","5","Work") 

   oMainWnd:ReadClientCoords()
   DEFINE MSDIALOG oDlg TITLE cTitle FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 TO oMainWnd:nBottom-60,oMainWnd:nRight-10;
    	    OF oMainWnd PIXEL  

      @ 00,00 MsPanel oPanel  Prompt "" Size 60,70 of oDlg //GFC 07/04/04

      DI410_Say()

      oMark:=MsSelect():New('Work',,,TB_Campos,.F.,'X',{75,1,(oDlg:nClientHeight-6)/2,(oDlg:nClientWidth-4)/2})
      oPanel:Align:=CONTROL_ALIGN_TOP
	  oMark:oBrowse:Align:=CONTROL_ALIGN_ALLCLIENT //BCO 16/12/11 - Tratamento para acesso via ActiveX alterando o align para antes do INIT
   ACTIVATE MSDIALOG oDlg ON INIT (DI410_Bar()) //GFC 07/04/04 - Alinhamento MDI.
   
   aRotina := MenuDef()   // GFP - 02/05/2012 - Carrega aRotina novamente para que os campos sejam alteraveis quando inclusão e/ou alteração.

   DO CASE
      CASE nOpcA == INCLUIR
           nManut := INCLUIR
           cTitulo:= OemToAnsi(STR0031) //"InclusÆo"
           DI410GetSJD()

      CASE nOpcA == ALTERAR
           nManut := ALTERAR
           cTitulo:= OemToAnsi(STR0032) //"Altera‡Æo"
           DI410GetSJD()

      CASE nOpcA == EXCLUIR
           nManut := EXCLUIR
           cTitulo:= OemToAnsi(STR0033) //"ExclusÆo"
           DI410GetSJD()

      CASE nOpcA == OK     
           nRecno:=0
           bGrava:={||DI410GravaSJD()}
           Work->(DBGOTOP())

           Processa({||ProcRegua(Work->(LASTREC())),;
                       Work->(DBEVAL(bGrava))},STR0023) //"Processando Registros"

           bGrava:={|nRec|nRecno:=nRec,DI410GravaSJD()}

           Processa({||ProcRegua(LEN(aDeletados)),AEVAL(aDeletados,bGrava) },STR0023) //"Processando Registros"

           SW6->(RECLOCK('SW6',.F.))
           SW6->W6_TOT_REC := ConTot_Rec
		   SW6->W6_CONTA20 := nConta20
		   SW6->W6_CONTA40 := nConta40
		   SW6->W6_CON40HC := nConta40HC
		   SW6->W6_OUTROS  := nContaOutr     
		   SW6->W6_ARMADOR := cArmador
           SW6->(MSUNLOCK())
           
           EXIT

      CASE nOpcA == SAIR; EXIT

   ENDCASE

Enddo

Return .T.

*-------------------*
Static Function DI410GetSJD()
*-------------------*
LOCAL aPos1 := {15,1,140,315}, oEnch1 //GFC 07/04/04
LOCAL aOrd:= {}
IF Work->(BOF()) .AND. Work->(EOF()) .AND. (nManut==ALTERAR .OR. nManut==EXCLUIR)
   Help("", 1, "AVG0000122")
   RETURN .F.
ENDIF

bOk    :={||DI410EndValid()}
bCancel:={||nGet:=0,oDlg:End()}
bInit  :={|| EnchoiceBar(oDlg,bOk,bCancel) }
aTela  :=Array(0,0)
aGets  :=Array(0)
aPos1  :={15,1,100,180}
lTudo  :=.F.
nGet   :=0

If AVFlags("DEMURRAGE") // FSM - 22/03/11 - Novo rotina para controle de Demurrage/Detention -

   aCpos:= {'JD_CONTAIN','JD_DT_ENT','JD_TIPO_CT','JD_QTD_REC','JD_DTPREVI' ,'JD_DEVOLUC'}

   aChange:={'JD_HAWB'   ,'JD_ARMADOR','JD_DT_ENT' ,'JD_CONTAIN','JD_TIPO_CT', 'JD_QTD_REC','JD_DTPREVI' ,'JD_DEVOLUC'}

Else
   aCpos:= {'JD_CONTAIN','JD_DT_ENT' ,'JD_TIPO_CT','JD_QTD_REC',;
            'JD_NF'     ,'JD_NF_SERI','JD_DT_NF' ,'JD_OBS'    ,'JD_CADEADO',;
            'JD_LACRE'  ,'JD_DTPREVI','JD_DEVOLUC','JD_ATE1'  ,'JD_ATE2'   ,'JD_ATE3'   ,;
            'JD_VAL1'   ,'JD_VAL2'   ,'JD_VAL3'  ,'JD_MOEDA'  ,'JD_ATRASO' ,;
            'JD_TOTALPG','JD_PAGO_EM','JD_DEPANTE','JD_TOTALGE'}  

   aChange:={'JD_HAWB'   ,'JD_ARMADOR','JD_DT_ENT' ,'JD_CONTAIN','JD_TIPO_CT',;
             'JD_QTD_REC','JD_NF'     ,'JD_NF_SERI','JD_DT_NF'  ,'JD_OBS'    ,;
             'JD_CADEADO','JD_LACRE'  ,'JD_DTPREVI','JD_DEVOLUC','JD_ATE1'   ,'JD_ATE2'   ,;
             'JD_ATE3'   ,'JD_VAL1'   ,'JD_VAL2'   ,'JD_VAL3'   ,'JD_MOEDA'  ,;
             'JD_ATRASO' ,'JD_TOTALPG','JD_PAGO_EM','JD_DEPANTE','JD_TOTALGE'}
EndIf

dbSelectArea('Work')

IF nManut == INCLUIR

   Work->(dbSetOrder(2))
   If !Work->(dbSeek(cArmador))
      Work->(DBGOTO(nRecnoWork))
   Else
      Work->(DBGOBOTTOM())
   Endif
   Work->(dbSetOrder(1))
   
ENDIF

M->JD_HAWB   :=SW6->W6_HAWB
//M->JD_ARMADOR:=SW6->W6_ARMADOR
M->JD_DT_ENT :=Work->JD_DT_ENT 

IF nManut == INCLUIR
	M->JD_CONTAIN:=Space(AVSX3("JD_CONTAIN",3))     
    M->JD_ARMADOR:=cArmador
    aOrd := SaveOrd("SX3",1)      
    SX3->(dbSeek("SJD"))       
    While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SJD" 
       If SX3->X3_PROPRI=="U" .AND. X3Uso(SX3->X3_USADO)
          If SX3->X3_TIPO == "C"
             M->&(SX3->X3_CAMPO):= Space(Len(SX3->X3_CAMPO))   
          Elseif SX3->X3_TIPO == "N"
             M->&(SX3->X3_CAMPO):= 0
          Elseif SX3->X3_TIPO == "D"
             M->&(SX3->X3_CAMPO):= AVCTOD("")
          Endif
       EndIF   
       SX3->(dbSkip())
    Enddo
    RestOrd(aOrd)
Else
	M->JD_CONTAIN:=Work->JD_CONTAIN
    M->JD_ARMADOR:=Work->JD_ARMADOR
    aOrd := SaveOrd("SX3",1)      
    SX3->(dbSeek("SJD"))       
    While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SJD" 
       If SX3->X3_PROPRI=="U" .AND. X3Uso(SX3->X3_USADO)
          M->&(SX3->X3_CAMPO):= Work->&(SX3->X3_CAMPO)   
       EndIF   
       SX3->(dbSkip())
    Enddo
    RestOrd(aOrd)
EndIf

IF nManut == INCLUIR
   M->JD_TIPO_CT:=SPACE(LEN(Work->JD_TIPO_CT))
ELSE
   M->JD_TIPO_CT:=Work->JD_TIPO_CT
ENDIF
M->JD_QTD_REC:=1
// FDR - 04/11/10 - Carrega os campos vazios ao incluir
If nManut == INCLUIR
   M->JD_NF     :=SPACE(AVSX3("JD_NF",3))
   M->JD_NF_SERI:=SPACE(AVSX3("JD_NF_SERI",3))
   M->JD_DT_NF  :=AvCtoD("  /  /  ")
   M->JD_OBS    :=SPACE(AVSX3("JD_OBS",3))    
   M->JD_CADEADO:=SPACE(AVSX3("JD_CADEADO",3))
   M->JD_LACRE  :=SPACE(AVSX3("JD_LACRE",3))
/* //*** GFP - 18/08/2011 :: 17h26 - Nopado pois campo é criado em ambos os casos de verificação do AVFLAGS
   If AvFlags("DEMURRAGE")//FSM - 21/06/2011
      M->JD_DTPREVI:=AvCtoD("  /  /  ")
   EndIf                              */
   M->JD_DTPREVI:=AvCtoD("  /  /  ")
   M->JD_DEVOLUC:=AvCtoD("  /  /  ")
   M->JD_ATE1   :=0 
   M->JD_ATE2   :=0 
   M->JD_ATE3   :=0 
   M->JD_VAL1   :=0 
   M->JD_VAL2   :=0 
   M->JD_VAL3   :=0 
   M->JD_MOEDA  :=SPACE(AVSX3("JD_MOEDA",3))
   M->JD_ATRASO :=0 
   M->JD_TOTALPG:=0 
   M->JD_DEPANTE:=0 
   M->JD_TOTALGE:=0 
   M->JD_PAGO_EM:=AvCtoD("  /  /  ") //SPACE(AVSX3("JD_PAGO_EM",3))  -   FSM - 21/06/2011 

Else
   M->JD_NF     :=Work->JD_NF     
   M->JD_NF_SERI:=Work->JD_NF_SERI
   M->JD_DT_NF  :=Work->JD_DT_NF  
   M->JD_OBS    :=Work->JD_OBS    
   M->JD_CADEADO:=Work->JD_CADEADO
   M->JD_LACRE  :=Work->JD_LACRE
/* //*** GFP - 18/08/2011 :: 17h26 - Nopado pois campo é criado em ambos os casos de verificação do AVFLAGS
   If AvFlags("DEMURRAGE")//FSM - 21/06/2011
      M->JD_DTPREVI:=Work->JD_DTPREVI       
   EndIf                          */
   M->JD_DTPREVI:=Work->JD_DTPREVI
   M->JD_DEVOLUC:=Work->JD_DEVOLUC
   M->JD_ATE1   :=Work->JD_ATE1
   M->JD_ATE2   :=Work->JD_ATE2
   M->JD_ATE3   :=Work->JD_ATE3
   M->JD_VAL1   :=Work->JD_VAL1
   M->JD_VAL2   :=Work->JD_VAL2
   M->JD_VAL3   :=Work->JD_VAL3
   M->JD_MOEDA  :=Work->JD_MOEDA
   M->JD_ATRASO :=Work->JD_ATRASO
   M->JD_TOTALPG:=Work->JD_TOTALPG
   M->JD_DEPANTE:=Work->JD_DEPANTE
   M->JD_TOTALGE:=Work->JD_TOTALGE
   M->JD_PAGO_EM:=Work->JD_PAGO_EM
Endif


dbSelectArea('SJD')
aCpos:= AddCpoUser(aCpos,"SJD","1")
aChange:= AddCpoUser(aChange,"SJD","1")
oMainWnd:ReadClientCoors()
DEFINE MSDIALOG oDlg TITLE cTitulo+STR0062+" - "+STR0004+": "+ALLTRIM(SW6->W6_HAWB) ; //" de Containers - Processo XXXXXXXXX"
           FROM oMainWnd:nTop+125,oMainWnd:nLeft+5 TO oMainWnd:nBottom-060,oMainWnd:nRight - 010 ;
     	     OF oMainWnd PIXEL                          

    aPos1[3]:=(oDlg:nClientHeight-2)/2
    aPos1[4]:=(oDlg:nClientWidth -2)/2
    oEnCh1:=MsMget():New('SJD',Work->WKRECNO,nOpc,,,,aCpos,aPos1,IF(nManut==EXCLUIR,{},aChange),3)
	oEnch1:oBox:Align:=CONTROL_ALIGN_ALLCLIENT //BCO 16/12/11 - Tratamento para acesso via ActiveX alterando o align para antes do INIT
    
ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||DI410EndValid()},{||nGet:=0,oDlg:End()}))

IF nGet == 1
   DI410GrvWork()
ENDIF

If nManut = INCLUIR .And. nGet == 1 //IF nManut #EXCLUIR .OR. nGet == 0
   DI410CpoVirtual(.T.)
ElseIf nManut = EXCLUIR .And. nGet == 1
   DI410CpoVirtual(.F.)
ENDIF

RETURN .T.

*----------------------*
Static Function DI410EndValid()
*----------------------*
Local I
IF nManut #EXCLUIR
   IF !Obrigatorio(aGets,aTela)
      RETURN .F.
   ENDIF

   lTudo:=.T.
   ATabValid:={'M->JD_TIPO_CT','M->JD_QTD_REC'}

   FOR I := 1 TO LEN(ATabValid)
      PName:=ATabValid[I]
      Campo:=&PName
      IF !DI410_Val()
         lTudo:=.F.
         RETURN .F.
      ENDIF
   NEXT
   // FDR - 04/11/10 - Validação do número do container
   If nManut == INCLUIR 
      Work->(DbSetOrder(3))
      If Work->(DbSeek(M->JD_CONTAIN))
         MsgInfo("Número de container já cadastrado para este processo.")
         RETURN .F.                 
      ENDIF
   ENDIF
ENDIF

nGet:=1
oDlg:End()

RETURN .T.

*------------------*
Static Function DI410_Val()
*------------------*
IF !lTudo
   Campo:=&(READVAR())
   PName:=READVAR()
   PName:=UPPER(PName)
ENDIF

nQtdeTotal:=0

DO CASE
   CASE M->JD_TIPO_CT == '1'
        nQtdeTotal:= nConta20 - Conta20_Rec   //SW6->W6_CONTA20 - AWR - tem que testar contra a variavel de memoria e nao contra o arquivo
                                                     
   CASE M->JD_TIPO_CT == '2'             
        nQtdeTotal:= nConta40 - Conta40_Rec   //SW6->W6_CONTA40 - AWR - a variavel de memoria que tem o ultimo valor digitado
                                                    
   CASE M->JD_TIPO_CT == '3'             
        nQtdeTotal:= nConta40HC - Con40HC_Rec //SW6->W6_CON40HC - AWR - 03/01/2005
                                                    
   CASE M->JD_TIPO_CT == '4'             
        nQtdeTotal:= nContaOutr - Outros_Rec  //SW6->W6_OUTROS

ENDCASE

DO CASE
   CASE PName == "M->JD_QTD_REC"
        IF Campo < 0
           Help("", 1, "AVG0000123")
           RETURN .F.
        ENDIF
//      IF Campo > nQtdeTotal
//         Help("", 1, "AVG0000124",,EVAL(bTipo2)+" nao pode ser maior que a quantidade a Receber: "+STR(nQtdeTotal,4),1,17)//E_Msg(STR0035+EVAL(bTipo2)+STR0036+CHR(13)+CHR(10)+;  //"Quantidade do "###" nÆo pode ser maior"
//               //STR0037+STR(nQtdeTotal,4),1) //"que a quantidade … Receber: "
//         RETURN .F.
//      ENDIF
        //IF (nQtdeTotal-1) < 0
           //Help("", 1, "AVG0000124",,EVAL(bTipo2)+" nao pode ser menor que a quantidade a Receber.",1,17)//E_Msg(STR0035+EVAL(bTipo2)+STR0036+CHR(13)+CHR(10)+;  //"Quantidade do "###" nÆo pode ser maior" //+STR(nQtdeTotal,4)
                 //STR0037+STR(nQtdeTotal,4),1) //"que a quantidade … Receber: "
           //RETURN .F.
        //ENDIF
        
   CASE PName == "M->JD_TIPO_CT"
        
        nRecnoWork2 := Work->(RecNo()) 
        Work->(dbGoTop())
        EIE->(dbSetOrder(1))
        
        If nManut == INCLUIR .AND. !lTudo
           lPasso := .F.
           Work->(dbSetOrder(2))
           If Work->(dbSeek(cArmador+M->JD_TIPO_CT))

              nInd:=1
              cVar1 := 'M->JD_ATE'+AllTrim(Str(nInd))
              cVar2 := 'M->JD_VAL'+AllTrim(Str(nInd))
              Do While Type('M->JD_ATE'+AllTrim(Str(nInd))) <> "U" .And.;
                       Type('M->JD_VAL'+AllTrim(Str(nInd))) <> "U"  

                 If Type('Work->JD_ATE'+AllTrim(Str(nInd))) <> "U" 
                    &cVar1  := &('Work->JD_ATE'+AllTrim(Str(nInd)))
                 Endif
                 If Type('Work->JD_VAL'+AllTrim(Str(nInd))) <> "U" 
                    &cVar2  := &('Work->JD_VAL'+AllTrim(Str(nInd)))
                 Endif
                 nInd++
                 cVar1 := 'M->JD_ATE'+AllTrim(Str(nInd))
                 cVar2 := 'M->JD_VAL'+AllTrim(Str(nInd))
              EndDo             
	     	  M->JD_ATRASO :=Work->JD_ATRASO

	       ElseIf EIE->(dbSeek(xFilial("EIE")+cArmador+M->JD_TIPO_CT))

              nInd:=1
              cVar1 := 'M->JD_ATE'+AllTrim(Str(nInd))
              cVar2 := 'M->JD_VAL'+AllTrim(Str(nInd))
              Do While Type('M->JD_ATE'+AllTrim(Str(nInd))) <> "U" .And.;
                       Type('M->JD_VAL'+AllTrim(Str(nInd))) <> "U"  

                 If Type('EIE->EIE_ATE'+AllTrim(Str(nInd))) <> "U" 
                    &cVar1  := &('EIE->EIE_ATE'+AllTrim(Str(nInd)))
                 Endif
                 If Type('EIE->EIE_VAL'+AllTrim(Str(nInd))) <> "U" 
                    &cVar2  := &('EIE->EIE_VAL'+AllTrim(Str(nInd)))
                 Endif                   
                 nInd++
                 cVar1 := 'M->JD_ATE'+AllTrim(Str(nInd))
                 cVar2 := 'M->JD_VAL'+AllTrim(Str(nInd))
              EndDo             
			  M->JD_ATRASO :=EIE->EIE_ATRASO

           Else

              nInd:=1
              cVar1 := 'M->JD_ATE'+AllTrim(Str(nInd))
              cVar2 := 'M->JD_VAL'+AllTrim(Str(nInd))
              Do While Type('M->JD_ATE'+AllTrim(Str(nInd))) <> "U" .And.;
                       Type('M->JD_VAL'+AllTrim(Str(nInd))) <> "U"  
                  &cVar1  := 0
                  &cVar2  := 0
                  nInd++
                  cVar1 := 'M->JD_ATE'+AllTrim(Str(nInd))
                  cVar2 := 'M->JD_VAL'+AllTrim(Str(nInd))
              EndDo             
			  M->JD_ATRASO :=0

           Endif             

        Endif

        Work->(dbSetOrder(1))
        
        IF EMPTY(Campo)
           Help("", 1, "AVG0000125")
           RETURN .F.
        ENDIF

        DO CASE
           CASE nOpcA == ALTERAR
              IF (nQtdeTotal) < 0
                 Help("", 1, "AVG0000124",,EVAL(bTipo2)+" nao pode ser menor que a quantidade a Receber.",1,17)//E_Msg(STR0035+EVAL(bTipo2)+STR0036+CHR(13)+CHR(10)+;  //"Quantidade do "###" nÆo pode ser maior" //+STR(nQtdeTotal,4)
                       //STR0037+STR(nQtdeTotal,4),1) //"que a quantidade … Receber: "
                 RETURN .F.
              ENDIF
           CASE nOpcA == INCLUIR 
              IF (nQtdeTotal-1) < 0
                 Help("", 1, "AVG0000124",,EVAL(bTipo2)+" nao pode ser menor que a quantidade a Receber.",1,17)//E_Msg(STR0035+EVAL(bTipo2)+STR0036+CHR(13)+CHR(10)+;  //"Quantidade do "###" nÆo pode ser maior" //+STR(nQtdeTotal,4)
                       //STR0037+STR(nQtdeTotal,4),1) //"que a quantidade … Receber: "
                 RETURN .F.
              ENDIF
        ENDCASE
        
        Work->(dbGoTo(nRecnoWork2))
        
ENDCASE 

RETURN .T.


*---------------------*
Static Function DI410GrvWork()
*---------------------*
Local Ind
dbSelectArea('Work')
IF nManut #EXCLUIR              
   IF nManut == INCLUIR           
      Work->(DBAPPEND())                    
      nRecnoWork := Work->(Recno())  
      Work->TRB_ALI_WT:= "SJD"
      Work->TRB_REC_WT:= SJD->(Recno())
   ENDIF
   FOR Ind := 1 TO (Work->(FCOUNT())-2)// -2 para nao pegar o campo DELETE e WKRECNO da Work
       If !(Work->(FieldName(Ind)) $ "DELETE/WKRECNO/TRB_ALI_WT/TRB_REC_WT")
          cCampo:="M->"+Work->(FieldName(Ind))
          Work->( FieldPut( Ind,&cCampo ) )
       EndIf
   NEXT
ELSE
   IF !EMPTY(Work->WKRECNO)
      AADD(aDeletados,Work->WKRECNO)
   ENDIF
   Work->(DBDELETE())

ENDIF

RETURN .T.

*------------------------------*
Static Function DI410GeraWork()
*------------------------------*
Local Ind
IncProc(STR0039+SJD->JD_TIPO_CT) //"Gravando Container: "
Work->(DBAPPEND())
FOR Ind := 1 TO (Work->(FCOUNT())-2)// -2 para nao pegar o campo DELETE e WKRECNO da Work
    cCampo:=Work->(FieldName(Ind))  //Atencao work nao tem as mesmas posicoes de campos que o SJD
    IF (nPos:=SJD->(FIELDPOS(cCampo))) # 0
      Work->( FieldPut( Ind,SJD->( FIELDGET(nPos) ) ) )
    ENDIF
NEXT

Work->WKRECNO:=SJD->(RECNO())
Work->TRB_ALI_WT:= "SJD"
Work->TRB_REC_WT:= SJD->(Recno())
DI410CpoVirtual(.T.)


Return .T.

*---------------------*
Static Function DI410GravaSJD()
*---------------------*
Local Ind
IF nOpc == ESTORNO
   IncProc(STR0040+Work->JD_TIPO_CT) //"Excluindo Container: "
   SJD->(DBGOTO(Work->WKRECNO))
   SJD->(RECLOCK('SJD',.F.))
   SJD->(DBDELETE())
   SJD->(MSUNLOCK())

ELSE

   IncProc(STR0039+Work->JD_TIPO_CT) //"Gravando Container: "
   
   DO CASE 
      CASE nRecno #0
            SJD->(DBGOTO(nRecno))
            SJD->(RECLOCK('SJD',.F.))
            SJD->(DBDELETE())
            SJD->(MSUNLOCK())
            Return .T.

      CASE EMPTY(Work->WKRECNO)
           SJD->(RECLOCK('SJD',.T.))
           SJD->JD_FILIAL:=xFilial('SJD')

      CASE !EMPTY(Work->WKRECNO)
           SJD->(DBGOTO(Work->WKRECNO))
           SJD->(RECLOCK('SJD',.F.))

   ENDCASE

   FOR Ind := 1 TO (Work->(FCOUNT())-2) // -2 para nao pegar o campo DELETE e WKRECNO da Work
       cCampo:=Work->(FieldName(Ind))   //Atencao work nao tem as mesmas 
       IF (nPos :=SJD->( FIELDPOS(cCampo) )) # 0//posicoes de campos que o SJD
          SJD->( FieldPut( nPos,Work->(FIELDGET(Ind)) ) )
       ENDIF
   NEXT

   ConTot_Rec:=ConTot_Rec+SJD->JD_QTD_REC

ENDIF

Return .T.

*------------------*
Static Function DI410_Say()
*------------------*         
nLin :=5; nColS:=05; nColG:=40; nAltu:=7; nPula:=12  

 @ nLin,nColS SAY STR0004 of oPanel Pixel  //"Processo"
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0007 of oPanel Pixel //"Dt Embarque"
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0063 of oPanel Pixel  //"Dt Atracacao"
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0041 of oPanel Pixel  //"Dt Pagto.Imp"
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0008 of oPanel Pixel //"No. da D.I."

 nLin:=5

 @ nLin,nColG msGET SW6->W6_HAWB       WHEN .F. SIZE 50,nAltu of oPanel Pixel
   nLin:=nLin+nPula
 @ nLin,nColG msGET SW6->W6_DT_EMB     WHEN .F. SIZE 33,nAltu of oPanel Pixel
   nLin:=nLin+nPula
 @ nLin,nColG msGET SW6->W6_CHEG       WHEN .F. SIZE 33,nAltu of oPanel Pixel
   nLin:=nLin+nPula
 @ nLin,nColG msGET SW6->W6_DT         WHEN .F. SIZE 33,nAltu of oPanel Pixel
   nLin:=nLin+nPula
 @ nLin,nColG msGET SW6->W6_DI_NUM     WHEN .F. SIZE 50,nAltu of oPanel Pixel

 nLin:=5
 nColS:=105
 nColG:=155

 @ nLin,nColS SAY STR0043  of oPanel Pixel//"Containers 20"
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0044  of oPanel Pixel//"Containers 40"
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0045  of oPanel Pixel//"Containers 40 HC"
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0022  of oPanel Pixel//"Outros"
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0046  of oPanel Pixel//"Total Containers"

 nLin:=5

 @ nLin,nColG msGET nConta20    SIZE 20,nAltu PICT '9999' VALID fSomaCont(.t.) of oPanel Pixel
   nLin:=nLin+nPula                                                   
 @ nLin,nColG msGET nConta40    SIZE 20,nAltu PICT '9999' VALID fSomaCont(.t.) of oPanel Pixel
   nLin:=nLin+nPula                                                   
 @ nLin,nColG msGET nConta40HC  SIZE 20,nAltu PICT '9999' VALID fSomaCont(.t.) of oPanel Pixel
   nLin:=nLin+nPula                                                   
 @ nLin,nColG msGET nContaOutr  SIZE 20,nAltu PICT '9999' VALID fSomaCont(.t.) of oPanel Pixel
   nLin:=nLin+nPula                                                   
 @ nLin,nColG msGET oContaTotal Var ContaTotal  WHEN .F. SIZE 25,nAltu PICTURE '99999' of oPanel Pixel

 nLin:=5
 nColS:=200
 nColG:=255

 @ nLin,nColS SAY STR0047  of oPanel Pixel//"Conts 20 Receb."
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0048  of oPanel Pixel//"Conts 40 Receb."
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0049  of oPanel Pixel//"Conts 40 HC Receb."
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0050  of oPanel Pixel//"Outros Receb."
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0051  of oPanel Pixel//"Total Conts Receb."

 nLin:=5
  
 @ nLin,nColG msGET Conta20_Rec    WHEN .F. SIZE 20,nAltu PICT '9999' of oPanel Pixel
   nLin:=nLin+nPula
 @ nLin,nColG msGET Conta40_Rec    WHEN .F. SIZE 20,nAltu PICT '9999' of oPanel Pixel
   nLin:=nLin+nPula
 @ nLin,nColG msGET Con40HC_Rec    WHEN .F. SIZE 20,nAltu PICT '9999' of oPanel Pixel
   nLin:=nLin+nPula
 @ nLin,nColG msGET Outros_Rec     WHEN .F. SIZE 20,nAltu PICT '9999' of oPanel Pixel
   nLin:=nLin+nPula
 @ nLin,nColG msGET ConTot_Rec     WHEN .F. SIZE 25,nAltu PICT '99999' of oPanel Pixel
 
 nLin:=5
 nColS:=290
 nColG:=325

 @ nLin,nColS SAY STR0042  of oPanel Pixel    //"Dt Desemb."
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0065 of oPanel Pixel     //"Cod.Armador"
   nLin:=nLin+nPula
 @ nLin,nColS SAY STR0066 of oPanel Pixel     //"Armador"

 nLin:=5

 @ nLin,nColG msGET SW6->W6_DT_DESE    WHEN .F. SIZE 33,nAltu of oPanel Pixel
   nLin:=nLin+nPula
 @ nLin,nColG msGET cArmador F3 "EIA" VALID fArmNome(cArmador) SIZE 30,nAltu of oPanel Pixel
   nLin:=nLin+nPula
 @ nLin,nColG msGET oArmNome Var cArmNome WHEN .F. SIZE 70,nAltu of oPanel Pixel


RETURN NIL  

*-------------------*
Static Function DI410Valida()
*-------------------*

IF nOpc == ESTORNO
   IF !MSGYESNO(STR0052,STR0053)//"Confirma o Estorno ?"###"Estorno"
      RETURN .F.
   ENDIF
ELSE

   IF Work->(BOF()) .AND. Work->(EOF())
      Help("", 1, "AVG0000126")//E_MSG(STR0054,1) //"NÆo existe Containers para esse Processo"
   ENDIF

ENDIF

nOpcA:=OK      
oSend(oDlg,"End")

RETURN .T.

*------------------------------*
Static Function DI410_Bar()
*------------------------------*
LOCAL aIncluir := { "EDIT"   ,{|| nOpcA := INCLUIR , oDlg:End() },STR0058}  //"Incluir"
LOCAL aAlterar := { "IC_17"  ,{|| nOpcA := ALTERAR , oDlg:End() },STR0060}  //"Alterar"   
LOCAL aExcluir := { "EXCLUIR",{|| nOpcA := EXCLUIR , oDlg:End() },STR0059}  //"Excluir"                                   
LOCAL aManut   := { aIncluir ,aAlterar,aExcluir}
LOCAL bGravar  := {|| DI410Valida() }
LOCAL bSair    := {|| nOpcA := SAIR, oDlg:End() }
IF nOpc = ESTORNO
   aManut:=NIL
ENDIF
RETURN EnchoiceBar(oDlg,bGravar,bSair,,aManut)

*-----------------------*
Static Function DI410CpoVirtual(lSoma)
*-----------------------*

IF lSoma
	DO CASE
	   CASE Work->JD_TIPO_CT == '1'
	        Conta20_Rec:= Conta20_Rec+1

	   CASE Work->JD_TIPO_CT == '2'
	        Conta40_Rec:= Conta40_Rec+1

	   CASE Work->JD_TIPO_CT == '3'
	        Con40HC_Rec:= Con40HC_Rec+1

	   CASE Work->JD_TIPO_CT == '4'
	        Outros_Rec := Outros_Rec +1

	ENDCASE

	ConTot_Rec:=ConTot_Rec+1

ELSE

	DO CASE
		CASE Work->JD_TIPO_CT == '1'
			Conta20_Rec:= Conta20_Rec - 1

		CASE Work->JD_TIPO_CT == '2'
			Conta40_Rec:= Conta40_Rec - 1

		CASE Work->JD_TIPO_CT == '3'
			Con40HC_Rec:= Con40HC_Rec - 1

		CASE Work->JD_TIPO_CT == '4'
			Outros_Rec := Outros_Rec - 1
	ENDCASE

	ConTot_Rec:=ConTot_Rec - 1

ENDIF

RETURN NIL


*-----------------------*
Static Function DI410_Devo(cNomeCampo)
*-----------------------*
Local lRet := .T.
Local cMsg := ""

If !Empty(M->&(cNomeCampo))

	If Upper(cNomeCampo) == 'JD_DEVOLUC'
       // FDR - 30/10/10 - Verifica se a Data de Atracação no Desembaraço está preenchida
       If Empty(SW6->W6_CHEG)
          cMsg += "Preencher a Data de Atracação no Desembaraço." + ENTER
          lRet := .F.

       ElseIf M->JD_DEVOLUC < SW6->W6_CHEG 
	          Help("", 1, "AVG0000445") 
              lRet := .F.
       EndIf

    EndIf

    /* FSM - 17/06/2011 */	
	If Empty(M->JD_DT_ENT)
	   cMsg += "Preencher o campo 'Dt. Entrada'." + ENTER
	   M->&(cNomeCampo) := cToD("")
	   lRet := .F.

	ElseIf M->&(cNomeCampo) < M->JD_DT_ENT
	       cMsg += "A data " + If(Upper(cNomeCampo) == 'JD_DTPREVI',"prevista ","") + "de devolução deve ser maior que a data de entrada." + ENTER
           lRet := .F.
	EndIf

Endif

If !lRet
   MsgInfo("Para o correto preenchimento do campo favor:" + Replic(ENTER,2) +;
           cMsg,"Atenção")
EndIf

Return lRet


*-----------------------*
Static Function fSomaCont(lAtualiza)
*-----------------------*

If(lAtualiza = Nil,lAtualiza:=.f.,)

ContaTotal:=nConta20+nConta40+nConta40HC+nContaOutr

If lAtualiza
	oContaTotal:Refresh()
Endif

Return .T.

*------------------------*
Static Function DI410_Saldo()        
*------------------------*
Local nDias:=nTaxa:=nTotPG:=0, nInd:=1
Local LRet := .T.
Local Campo:=&(READVAR())
Local PName:=READVAR()
PName:=UPPER(PName)

If SubStr(PName,1,9) = "M->JD_ATE" 
   If PName = "M->JD_ATE1" 
       CampoD := &(SubStr(PName,1,9)+ AllTrim(Str(Val(SubStr(PName,10,1))+1)))
       If CampoD > 0 
          If Campo >= CampoD
             Help("", 1,"AVG0000665") // Numero de Dias menor que o Anterior, ou maior que o Proximo. 
             lRet := .F.
          Endif
       Endif   
   Else
       CampoA := &(SubStr(PName,1,9)+ AllTrim(Str(Val(SubStr(PName,10,1))-1)))
       cValM  := AllTrim(Str(Val(SubStr(PName,10,1))+1))
       cAux   := 'JD_ATE'+ cValM
       If Type('M->'+cAux) <> "U"
           If Campo > CampoA
              CampoD := &(SubStr(PName,1,9)+ AllTrim(Str(Val(SubStr(PName,10,1))+1)))
              If CampoD > 0 
                 If Campo >= CampoD
                    Help("", 1,"AVG0000665") // Numero de Dias menor que o Anterior, ou maior que o Proximo. 
                    lRet := .F.
                 Endif  
              Endif   
           Else  
              If Campo > 0           
                 Help("", 1,"AVG0000665") // Numero de Dias menor que o Anterior, ou maior que o Proximo. 
                 lRet := .F.      
              Endif   
           Endif 
       Else
           If Campo > 0 
              If Campo <= CampoA
                 Help("", 1,"AVG0000665") // Numero de Dias menor que o Anterior, ou maior que o Proximo. 
                 lRet := .F.      
              Endif
           Endif
       Endif   
   Endif
Endif  

If lRet

  If !Empty(M->JD_DEVOLUC)

    nDias := (M->JD_DEVOLUC-SW6->W6_CHEG)+1

    cVar1 := 'M->JD_ATE'+AllTrim(Str(nInd))
    cVar2 := 'M->JD_VAL'+AllTrim(Str(nInd))

/*    Do While Type('M->JD_ATE'+AllTrim(Str(nInd))) <> "U" .And.;
             Type('M->JD_VAL'+AllTrim(Str(nInd))) <> "U" .And. nDias > 0 
                         
//       If nInd = 1 
//         nDias -= 1    // para compensar o 1o dia.
//       Endif   
       
       If (nDias  - &cVar1) > 0 
	       nDias  -= &cVar1 //+ 1
	       nTotPg += &cVar2 * &cVar1
       Else
	       nTotPg += &cVar2 * nDias
	       nDias  -= &cVar1 //+ 1
       Endif
       
       nInd++
   
       cVar1 := 'M->JD_ATE'+AllTrim(Str(nInd))
       cVar2 := 'M->JD_VAL'+AllTrim(Str(nInd))
     
    EndDo
       
    If nDias > 0 
       nTotPG += M->JD_ATRASO * nDias 
    Endif*/

    nSaldoDias := 0
    nSaldoAnt  := 0 
      
    Do While Type('M->JD_ATE'+AllTrim(Str(nInd))) <> "U" .And.;
             Type('M->JD_VAL'+AllTrim(Str(nInd))) <> "U" .And. nDias >= nSaldoDias                              

       If nInd = 1
          nSaldoDias += &cVar1   
          nDiasCalc  := nSaldoDias   
       Else
          If &cVar1 > 1
             nSaldoDias += (&cVar1 - nSaldoDias) 
             nDiasCalc  := (&cVar1 - nSaldoAnt) 
          Endif
       Endif
       
       If nSaldoDias >= nDias
          nSaldoDias := nSaldoAnt + (nDias - nSaldoAnt)
          nDiasCalc  := nDias - nSaldoAnt
          nTotPg += &cVar2 * nDiasCalc      
       Else
          nTotPg += &cVar2 * nDiasCalc      
       Endif
       
       nSaldoAnt := nSaldoDias
       
       nInd++
   
       cVar1 := 'M->JD_ATE'+AllTrim(Str(nInd))
       cVar2 := 'M->JD_VAL'+AllTrim(Str(nInd))
     
    EndDo             
    
    If nDias > nSaldoDias
       nDiasCalc := nDias - nSaldoDias
       nTotPg += M->JD_ATRASO * nDiasCalc        
    Endif
       
  EndIf

  M->JD_TOTALPG:= nTotPG
  M->JD_TOTALGE:= nTotPG - M->JD_DEPANTE

Endif  

Return lRet

*------------------------------------*
Static Function DI410_ExChave()        
*------------------------------------*
Local lRet := .T.,nRecnoWork:=Work->(Recno())

SJD->(dbSetOrder(1))
If (SJD->(dbSeek(xFilial("SJD")+SW6->W6_HAWB+M->JD_CONTAIN)) .Or. Work->(dbSeek(M->JD_CONTAIN)))
   Help("", 1, "AVG0000659") 
   lRet := .F. 
EndIf                    

Work->(DBGOTO(nRecnoWork))

Return lRet


*------------------------------------*
Static Function fArmNome(cArmador)
*------------------------------------*
If !Empty(cArmador)
    SY5->(dbSetOrder(1))
    If SY5->(dbSeek(xFilial("SY5")+cArmador))
		If SY5->Y5_TIPOAGE <> "4"
		    Help("", 1,"AVG0000660")
            cArmNome:=Space(40)
            Return .f.
		Endif
	Else
        Help("", 1,"AVG0003033") // Codigo do Armador nao Encontrado.
        cArmNome:=Space(40)
        Return .f.	
	EndIf	
	cArmNome:=SY5->Y5_NOME
	oArmNome:Refresh()         
Endif	
Return .t.  

/*
Funcao      : DI410PesqCont()
Parametros  : Nenhum
Retorno     : - 
Objetivos   : Apresentar tipo de pesquisa de Container ( 1 = Numero de Container e 2 = Numero de Cadeado )
Autor       : Allan Oliveira Monteiro
Data/Hora   : 24/05/2010 11:30
Obs.        : -
*/

Function DI410PesqCont()
Local oDlgCont,oChave, oDlgChave
Local nRadio, nOpcao:=0, cChave:=SPACE(15), cSay:= SPACE(15), cTit := "Pesquisa por Container"
Local aItens := {"Numero de Container", "Numero de Cadeado"} 
Local bOk := {|| oDlgCont:END()}, bCancel :={|| nRadio :=0, oDlgCont:END()} 
Local bOk2 := {|| nOpcao := 1, oDlgChave:END()}, bCancel2 := {|| nOpcao :=0, oDlgChave:END()}//acb - 23/10/2010

Begin sequence

     DEFINE MSDIALOG oDlgCont FROM 20,30 TO 28,80  TITLE cTit OF oMAINWND //FDR - 30/08/12 - Ajuste na tela  
        @ 20,027 Radio nRadio  ITEMS aItens[1],aItens[2]  size 100,10 of oDlgCont pixel
     ACTIVATE MSDIALOG oDlgCont ON INIT EnchoiceBar(oDlgCont,bOk,bCancel) CENTERED
     
     If nRadio == 0
        Break
     EndIf 
     
     If nRadio == 1
        cTit := "Pesquisa por Nº de Container"
        cSay := AVSX3("JD_CONTAIN",5) 
        cPic := "@R XXXX-XXXXXX/X"//Acb - 24/10/2010
     EndIf
     
     If nRadio == 2
        cTit := "Pesquisa por Nº de Cadeado"
        cSay := AVSX3("JD_CADEADO",5) 
        cPic := "@!" // acb - 24/10/2010
     End If 
     
     DEFINE MSDIALOG oDlgChave FROM 20,30 TO 26,80 TITLE cTit OF oMAINWND
        @ 14,025 SAY cSay OF oDlgChave PIXEL
        @ 21,025 MSGET oChave VAR cChave Picture cPic OF oDlgChave SIZE 100,10 PIXEL
        
//        DEFINE SBUTTON FROM 29,70  TYPE 1 OF oDlgChave ENABLE ACTION (nOpcao:=1, oDlgChave:End())
//        DEFINE SBUTTON FROM 29,100 TYPE 2 OF oDlgChave ENABLE ACTION (oDlgChave:End())
        
     ACTIVATE MSDIALOG oDlgChave ON INIT EnchoiceBar(oDlgchave,bOk2,bCancel2) CENTERED
     
     If nOpcao == 1
        DbSelectArea("SJD")
        If nRadio == 1
           SJD->(DbSetOrder(2))
           If SJD->(DbSeek(xFilial("SJD")+AvKey(cChave,"JD_CONTAIN")))
              DbSelectArea("SW6") 
              SW6->(DbSetOrder(1))
              SW6->(DbSeek(xFilial("SW6")+SJD->JD_HAWB))
           Else
              MsgInfo("Não possui nenhum embarque com o número do container informado!","Aviso")
           EndIf
               
        Else
        SJD->(DbSetOrder(4))
           If SJD->(DbSeek(xFilial("SJD")+AvKey(cChave,"JD_CADEADO")))
              DbSelectArea("SW6") 
              SW6->(DbSetOrder(1))
              SW6->(DbSeek(xFilial("SW6")+SJD->JD_HAWB))
           Else
              MsgInfo("Não possui nenhum embarque com o número de cadeado informado!","Aviso")
           EndIf
        EndIf
     
     EndIf
         
End Sequence      

Return Nil
