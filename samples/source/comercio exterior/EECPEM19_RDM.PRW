#INCLUDE "EECPEM19.ch"

/*
Programa        : EECPEM19.PRW
Objetivo        : Retorno de Memorando
Autor           : Flavio Yuji Arakaki
Data/Hora       : 15/10/1999 15:50
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

#xTranslate xLin1(<nVar>) => (<nVar> := <nVar>+10)
#xTranslate xLin2(<nVar>) => (<nVar> := <nVar>+08)

/*
Funcao      : EECPEM19
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Flavio Yuji Arakaki
Data/Hora   : 15/10/1999 15:50
Revisao     :
Obs.        :
*/
User Function EECPEM19

Local lRet := .T.
Local nAlias := Select()
Local aOrd := SaveOrd({"EEC","SA2"})

Local cEXP_CODP    := SPACE(AVSX3("A2_PAIS",3))    
Local cEXP_CONTATO := SPACE(35)                    
Local cEXP_FONE    := SPACE(30)                    
Local cEXP_FAX     := SPACE(30)                    
Local cEXP_PAIS    := SPACE(AVSX3("YA_DESCR",3))   
Local cEXP_END     := SPACE(AVSX3("A2_END",3))     
Local cEXP_BAIRRO  := SPACE(AVSX3("A2_BAIRRO",3))  
Local cEXP_CEP     := SPACE(AVSX3("A2_CEP",3))     
Local cEXP_MUN     := SPACE(AVSX3("A2_MUN",3))     
Local cEXP_ESTADO  := SPACE(AVSX3("A2_EST",3))     

Local cTO_CON1	:= SPACE(AVSX3("EE3_NOME",3))

Local cFOR_FONE,cFOR_FAX,cFOR_DEPTO
//Local cPara1,cPara2,cPara3
Local cProcs

Local mLinha1,mLinha2,mLinha3, i:=0

Private cPara1 := Space(60)
Private cPara2 := Space(60)
Private cPara3 := Space(60)

Private cCC1 := Space(60)
Private cCC2 := Space(60)
Private cCC3 := Space(60)

Private cF3COD,cF3LOJ

Begin Sequence

   SA2->(DBSETORDER(1)) 

   //regras para carregar dados 
   IF !EMPTY(EEC->EEC_EXPORT) .AND. ;                                                                                    
      SA2->(DBSEEK(xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA))                                                      
      cEXP_CODP    := SA2->A2_PAIS 
      cEXP_END     := SA2->A2_END
      cEXP_BAIRRO  := SA2->A2_BAIRRO
      cEXP_CEP     := SA2->A2_CEP
      cEXP_MUN     := SA2->A2_MUN
      cEXP_ESTADO  := SA2->A2_EST
      cEXP_FONE    := SA2->A2_TEL
      cEXP_FAX     := SA2->A2_FAX
      cEXP_PAIS    := Posicione("SYA",1,xFilial("SYA")+cEXP_CODP,"YA_DESCR") 
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1)  //nome do contato seq 1      
   ELSE
      HELP(" ",1,"AVG0005052") //MSGINFO("Exportador não cadastrado.","Aviso")
      lRet := .F.
      Break
   ENDIF                                                                                                                 
   
   cEXP_END     := ALLTRIM(cEXP_END)
   cEXP_BAIRRO  := ALLTRIM(cEXP_BAIRRO)
   cEXP_CEP     := ALLTRIM(cEXP_CEP)
   cEXP_MUN     := ALLTRIM(cEXP_MUN)
   cEXP_ESTADO  := ALLTRIM(cEXP_ESTADO)
   cEXP_FONE    := ALLTRIM(cEXP_FONE)
   cEXP_FAX     := ALLTRIM(cEXP_FAX)
   
   //  FORNECEDOR
   cF3COD   := EEC->EEC_FORN
   cF3LOJ   := EEC->EEC_FOLOJA
                                                                                                                
   cTO_CON1     :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
   cFOR_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
   cFOR_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1 
   cFOR_DEPTO   :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",6)  //departamento do contato seq 1         

/*    
   cPara1 := cTO_CON1
   cPara2 := cFOR_DEPTO
   cPara3 := "Telefone: "+cFOR_FONE
*/   
   cProcs := SelecProcs()
   
   IF Empty(cProcs)
      Break
   Endif
                                                                                                                    
   cTO_CON1     :=ALLTRIM(cTO_CON1)                                                                          
   cFOR_FONE    :=ALLTRIM(cFOR_FONE)                                                                             
   cFOR_FAX     :=ALLTRIM(cFOR_FAX)                                                                              
   cFOR_DEPTO   :=ALLTRIM(cFOR_DEPTO)
   
   mLINHA1 :=cEXP_END+" "+cEXP_BAIRRO+STR0001+cEXP_CEP+" "+cEXP_MUN //" CEP "
   mLINHA2 :=cEXP_ESTADO+" - "+cEXP_PAIS                                           
   mLINHA3 :=STR0002+cEXP_FONE+STR0003+cEXP_FAX                                    //"Tel: "###" / Fax: "
   
   //gerar arquivo padrao de edicao de carta 
   IF ! E_AVGLTT("G")                        
      Break
   Endif                                     
                                             
   //adicionar registro no AVGLTT            
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=EEC->EEC_PREEMB //nr. do processo
   AVGLTT->AVG_C01_60:=STR0004 //"CENTRO DE SERVICO A CLIENTES"
   AVGLTT->AVG_C02_60:=mLINHA1
   AVGLTT->AVG_C03_60:=mLINHA2
   AVGLTT->AVG_C04_60:=mLINHA3

   //carregar detalhe
   mDETALHE:=ALLTRIM(cEXP_MUN)+", "+STR(DAY(dDATABASE),2)+STR0005+UPPER(MesExtenso(dDATABASE))+STR0005+STR(Year(dDATABASE),4)+ENTER //" DE "###" DE "
   mDETALHE:=mDETALHE+ENTER+ENTER
   mDETALHE:=mDETALHE+STR0006+ENTER //"        A(o) Senhor(a)"
   mDETALHE:=mDETALHE+ENTER 
   mDETALHE:=mDETALHE+"           "+cPara1+ENTER
   mDETALHE:=mDETALHE+"           "+cPara2+ENTER 
   mDETALHE:=mDETALHE+"           "+cPara3+ENTER+ENTER
   mDETALHE:=mDETALHE+STR0007+ENTER //"           C/C"
   mDETALHE:=mDETALHE+"           "+cCC1+ENTER
   mDETALHE:=mDETALHE+"           "+cCC2+ENTER
   mDETALHE:=mDETALHE+"           "+cCC3+ENTER
   
   mDETALHE:=mDETALHE+ENTER+ENTER
   
   mDETALHE:=mDETALHE+STR0008+ENTER //"           Venho por meio desta informar-lhe o envio em anexo da 1a. via do Memorando"
   mDETALHE:=mDETALHE+STR0009+ENTER //"de Exportacao e seus respectivos documentos - Bill of Landing, Registro de Exportacao"
   mDETALHE:=mDETALHE+STR0010+ENTER //"e Declaracao de Despacho - referente aos processos:"
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+ENTER 
   
   For i:=1 To MlCount(cProcs,85)
      mDetalhe := mDetalhe+ltrim(MemoLine(cProcs,85,i))+ENTER
   Next 
   
   mDETALHE:=mDETALHE+ENTER+ENTER+ENTER
   
   mDETALHE:=mDETALHE+STR0011+ENTER //"                                Atenciosamente,"
   
   mDETALHE := mDETALHE + ENTER + ENTER                                                                                                              
   mDetalhe := mDETALHE +"                                "+cEXP_CONTATO+ENTER     
          
   mDETALHE := mDETALHE + ENTER + ENTER + ENTER                                                                                                                                                        
   mDETALHE := mDETALHE +STR0012+ENTER                                                                 //"           FAVOR DEVOLVER ESTA VIA PROTOCOLADA"
   
         
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO)
   
End Sequence

//retorna a situacao anterior ao processamento
RestOrd(aOrd)
Select(nAlias)

Return lRet

/*
Funcao      : SelecProcs
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function SelecProcs

Local nAliasOld := Select()
Local aOrd := SaveOrd({"EEC"})

Local nOpc := 0
Local bOk  := {|| cRet := ClickOk(), IF(!Empty(cRet),(nOpc := 1, oDlg:End()),) }
Local bCancel := {|| oDlg:End() }

Local cFile := E_CriaTrab("EEC",{{"WKMARCA","C",02,0}},"WkProcs")
Local aCampos := { {"WKMARCA",," "},;
                   {"EEC_PREEMB",,AVSX3("EEC_PREEMB",5)} }

Local cRet := ""
Local y    := 15

Local oDlg, oMark, nRegEEC

Private cMarca := GetMark()

Begin Sequence
   nRegEEC := EEC->(RECNO())

   EEC->(dbSeek(xFilial()))

   While EEC->(!Eof() .And. EEC_FILIAL==xFilial("EEC"))
      WkProcs->(dbAppend())
      AvReplace("EEC","WkProcs") 
      EEC->(dbSkip())
   Enddo
   EEC->(DBGOTO(nRegEEC))
   
   WkProcs->(dbGoTop())


   DEFINE MSDIALOG oDlg TITLE STR0013 FROM 9,0 TO 28,80 OF oMainWnd //"Seleção de Processos"
              
      @ y,01 SAY STR0014 PIXEL //"Para"
      @ xLin2(y),01 MSGET cPara1 PICTURE "@!" F3 "E32" SIZE 210,08 PIXEL
      @ xLin1(y),01 MSGET cPara2 PICTURE "@!" SIZE 210,08 PIXEL
      @ xLin1(y),01 MSGET cPara3 PICTURE "@!" SIZE 210,08 PIXEL
      
      @ xLin1(y),01 SAY STR0015 PIXEL //"Copia"
      @ xLin2(y),01 MSGET cCC1 PICTURE "@!" F3 "E32" SIZE 210,08 PIXEL
      @ xLin1(y),01 MSGET cCC2 PICTURE "@!" SIZE 210,08 PIXEL
      @ xLin1(y),01 MSGET cCC3 PICTURE "@!" SIZE 210,08 PIXEL
      
      //GFP 25/10/2010
      aCampos := AddCpoUser(aCampos,"EEC","2")
      
      oMark:= MsSelect():New("WkProcs","WKMARCA",,aCampos,.f.,@cMarca,{xLin1(y),1,143,320})
   
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)
   
End Sequence

WkProcs->(E_EraseArq(cFile))

RestOrd(aOrd)
Select(nAliasOld)

Return cRet

/*
Funcao      : ClickOk
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Cristiano A. Ferreira
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function ClickOk

Local cRet := ""

Begin Sequence
   WkProcs->(dbGotop())
   WkProcs->(dbEval({|| cRet := cRet+" "+WkProcs->EEC_PREEMB},{||!Empty(WKMARCA)}))
   IF Empty(cRet)
      HELP(" ",1,"AVG0005053") //MsgInfo("Não há processos selecionados para a impressão !","Aviso")
   Endif
End Sequence

Return cRet      

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM19.PRW                                                 *
*------------------------------------------------------------------------------*
