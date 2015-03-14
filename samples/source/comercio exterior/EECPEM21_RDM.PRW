#INCLUDE "EECPEM21.ch"

/*
Programa        : EECPEM21.PRW
Objetivo        : Booking Change
Autor           : Heder M Oliveira
Data/Hora       : 29/10/1999 11:16
Obs.            : 
*/                

/*
considera que estah posicionado no registro de processos (embarque) (EEC)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPEM21
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     :
Obs.        :
*/
User Function EECPEM21

Local lRet := .T.
Local aOrd := SaveOrd({"EEC","EEB","SA2","SY5"})

Local cPEDIDO,cTO_NOME,cTO_ATTN,cTO_FAX
Local cAux

Local cEXP_NOME,cEXP_CONTATO,cEXP_FONE,cEXP_FAX
Local nCol,W,nTotLin

Private cCHANGED,cNAVIOAT,cNAVIONO,cETAATUA,cETANOVO,cETSATUA,cETSNOVO 
Private cAGEMBNO,cArmNOVO, cAgEmb 

cFileMen:= ""

Begin Sequence
   
   cCHANGED := Padr(cMonth(dDATABASE)+" "+AllTrim(Str(Day(dDATABASE)))+", "+Str(Year(dDATABASE),4),25)
   cNAVIOAT := Posicione("EE6",1,XFILIAL("EE6")+EEC->EEC_EMBARC,"EE6_NOME")
   cNAVIONO := SPACE(AVSX3("EE6_NOME",3))
   cETAATUA := EEC->EEC_ETA
   cETANOVO := AVCTOD("")
   cETSATUA := EEC->EEC_ETD
   cETSNOVO := AVCTOD("")
   cAGEMBNO := SPACE(AVSX3("EEB_NOME",3))
   cArmNOVO := SPACE(AVSX3("EEB_NOME",3))
   
   cPEDIDO:=AVKey(EEC->EEC_PREEMB,"EEB_PEDIDO")

   //tentar 1. o agente recebedor documentos
   IF ( !EMPTY(cTO_NOME:=BUSCAEMPRESA(cPEDIDO,OC_EM,CD_AGQ)))
      cTO_ATTN:=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1) //nome do contato seq 1
      cTO_FAX :=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",7) //fax do contato seq 1
      SY5->(DBSETORDER(1))
      IF ( SY5->(DBSEEK(XFILIAL("SY5")+EEB->EEB_CODAGE )))
         cTO_FAX:=SY5->Y5_FAX
      ENDIF
            
   //se 1 falhou, 2 tentar agente comissao
   ELSEIF ( !EMPTY(cTO_NOME:=BUSCAEMPRESA(cPEDIDO,OC_EM,CD_AGC)))
      cTO_ATTN:=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",1) //nome do contato seq 1
      cTO_FAX :=EECCONTATO(CD_SY5,EEB->EEB_CODAGE,,"1",7) //fax do contato seq 1
      SY5->(DBSETORDER(1))
      IF ( SY5->(DBSEEK(XFILIAL("SY5")+EEB->EEB_CODAGE )))
         cTO_FAX:=SY5->Y5_FAX
      ENDIF
      
   //se 2 falhou, 3 tentar importador
   ELSE
      cTO_NOME := EEC->EEC_IMPODE //nome importador no processo
      cTO_ATTN := EECCONTATO(CD_SA1,EEC->EEC_IMPORT,EEC->EEC_IMLOJA,"1",1) //nome do contato seq 1
      cTO_FAX  := EECCONTATO(CD_SA1,EEC->EEC_IMPORT,EEC->EEC_IMLOJA,"1",7) //fax do contato seq 1
   ENDIF
   
   // Verifica se o tipo de transporte eh rodoviario
   cAux := Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1)
   IF cAux == "7" // Rodoviario
      cAGEMB:=BUSCAEMPRESA(cPEDIDO,OC_EM,CD_TRA)  // Transportadora
      cEEB_TIPO := CD_TRA+STR0001 //"-TRANSPORTADORA"
   Elseif cAux == "4" // Aereo
      //tentar 1. o agente recebedor documentos
      cAgEmb := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_AGE)
      cEEB_TIPO := CD_AGE+STR0002 //"-AGENTE EMBARCADOR"
   Else // Maritimo / outros
      //tentar 1. o agente recebedor documentos
      cAgEmb := BuscaEmpresa(EEC->EEC_PREEMB,OC_EM,CD_AGE)
      cEEB_TIPO := CD_AGE+STR0002 //"-AGENTE EMBARCADOR"
   Endif   
   
   cEEB_PED  := EEC->EEC_PREEMB
   cAgEmb:=LEFT(cAgEmb,30)
   cNAVIOAT:=LEFT( cNAVIOAT,30)
   
   IF ! TelaGets()
      lRet := .f.
      Break
   Endif
   
   //regras para carregar dados
   IF !EMPTY(EEC->EEC_EXPORT)
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_EXPORT+EEC->EEC_EXLOJA,"A2_NOME")
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_EXPORT,EEC->EEC_EXLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
   ELSE
      cEXP_NOME    :=Posicione("SA2",1,xFilial("SA2")+EEC->EEC_FORN+EEC->EEC_FOLOJA,"A2_NOME") 
      cEXP_CONTATO :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",1,EEC->EEC_RESPON)  //nome do contato seq 1
      cEXP_FONE    :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",4,EEC->EEC_RESPON)  //fone do contato seq 1
      cEXP_FAX     :=EECCONTATO(CD_SA2,EEC->EEC_FORN,EEC->EEC_FOLOJA,"1",7,EEC->EEC_RESPON)  //fax do contato seq 1
   ENDIF

   cEXP_NOME    :=ALLTRIM(cEXP_NOME)
   cEXP_CONTATO :=ALLTRIM(cEXP_CONTATO)
   cEXP_FONE    :=ALLTRIM(cEXP_FONE)
   cEXP_FAX     :=ALLTRIM(cEXP_FAX)
   
   cTO_NOME     :=ALLTRIM(cTO_NOME)
   cTO_ATTN     :=ALLTRIM(cTO_ATTN)
   cTO_FAX      :=ALLTRIM(cTO_FAX)
   
   //gerar arquivo padrao de edicao de carta
   IF ! E_AVGLTT("G")
      lRet := .F.
      Break
   Endif
   
   //adicionar registro no AVGLTT
   AVGLTT->(DBAPPEND())

   //gravar dados a serem editados
   AVGLTT->AVG_CHAVE :=cPEDIDO //nr. do processo
   AVGLTT->AVG_C01_60:=cEXP_NOME
   AVGLTT->AVG_C02_60:=WORKID->EEA_TITULO
   

   //carregar detalhe
   mDETALHE:="FAC SIMILE NUMBER: "+cTO_FAX+SPACE(20)+"DATE: "+DTOC(dDATABASE)+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"TO  : "+cTO_NOME+ENTER
   mDETALHE:=mDETALHE+"ATTN: "+cTO_ATTN+SPACE(20)+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"FROM: "+cEXP_CONTATO+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"TOTAL NUMBER OF PAGES INCLUDING THIS COVER: 01"+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"RE  : Y/ORDER (S) : "+EEC->EEC_REFIMP+ENTER
   mDETALHE:=mDETALHE+ENTER              
   mDETALHE:=mDETALHE+"      O/ORDER (S) : "+EEC->EEC_PREEMB+ENTER
   mDETALHE:=mDETALHE+ENTER
   mDETALHE:=mDETALHE+"ADVICE OF BOOKING CHANGED ON "+cCHANGED+" AS FOLLOWS:"+ENTER+ENTER
   mDETALHE:=mDETALHE+SPACE(19)+"WAS"+SPACE(30)+"CHANGED TO"+ENTER
   
   // Verifica se o tipo de transporte eh rodoviario
   cAux := Left(Posicione("SYQ",1,XFILIAL("SYQ")+EEC->EEC_VIA,"YQ_COD_DI"),1)
   IF cAux == "7" .AND. !EMPTY(cAgEmbNO)// Rodoviario
      mDETALHE:=mDETALHE+"TRUCKER NAME"
	  mDETALHE:=mDETALHE+SPACE(07)+cAgEmb+ENTER
      mDETALHE:=mDETALHE+SPACE(1)+cAgEmbNO+ENTER
   Elseif cAux == "4" .AND. !EMPTY(cAgEmbNO)// Aereo
      mDETALHE:=mDETALHE+"SHIPPING LINE"
	  mDETALHE:=mDETALHE+SPACE(06)+cAgEmb
      mDETALHE:=mDETALHE+SPACE(3)+cAgEmbNO+ENTER
   Else // Maritimo / outros
      IF ( !EMPTY(cNAVIONO) )
         mDETALHE:=mDETALHE+"VESSEL NAME"
         mDETALHE:=mDETALHE+SPACE(08)+cNAVIOAT
         mDETALHE:=mDETALHE+SPACE(3)+cNAVIONO+ENTER
      ENDIF
      IF ( !EMPTY(cAgEmbNO) )
         mDETALHE:=mDETALHE+"SHIPPING LINE"
         mDETALHE:=mDETALHE+SPACE(06)+cAgEmb
         mDETALHE:=mDETALHE+SPACE(3)+cAgEmbNO+ENTER
      ENDIF
   Endif   
   IF ( !EMPTY(cETANOVO) )
      mDETALHE:=mDETALHE+"ETA"
	  mDETALHE:=mDETALHE+SPACE(16)+DTOC(cETAATUA)
      mDETALHE:=mDETALHE+SPACE(25-IF(ISYEAR4(),2,0))+DTOC(cETANOVO)+ENTER
   ENDIF
   IF ( !EMPTY(cETSNOVO) )
      mDETALHE:=mDETALHE+"ETS"
	  mDETALHE:=mDETALHE+SPACE(16)+DTOC(cETSATUA)
      mDETALHE:=mDETALHE+SPACE(25-IF(ISYEAR4(),2,0))+DTOC(cETSNOVO)+ENTER
   ENDIF
   
   mDETALHE:=mDETALHE+ENTER+ENTER
   mDETALHE:=mDETALHE+"REASON:"+ENTER
   
   IF SELECT("Work_Men") > 0
      nCol:=80 //AVSX3("EE4_VM_TEX",3)
      Work_Men->(DBGOTOP())
      DO WHILE !Work_Men->(EOF()) .AND. WORK_MEN->WKORDEM<"zzzzz"

         nTotLin:=MLCOUNT(Work_Men->WKOBS,nCol) 
        
         FOR W := 1 TO nTotLin
            If !EMPTY(MEMOLINE(Work_Men->WKOBS,nCol,W))
               mDETALHE:=mDETALHE+MEMOLINE(Work_Men->WKOBS,nCol,W)+ENTER
            EndIf
         NEXT
  
         Work_Men->(DBSKIP())
      ENDDO
   ENDIF

   mDETALHE:=mDETALHE+ENTER+ENTER
   
   mDETALHE:=mDETALHE+"REGARDS"+ENTER
   mDETALHE:=mDETALHE+ENTER
   
   mDETALHE:=mDETALHE+"IF YOU DO NOT RECEIVE ALL PAGES, PLEASE CALL US "
   mDETALHE:=mDETALHE+"PHONE "+cEXP_FONE
     
   //gravar detalhe
   AVGLTT->WK_DETALHE := mDETALHE

   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //executar rotina de manutencao de caixa de texto
   lRet := E_AVGLTT("M",WORKID->EEA_TITULO)
   
   IF ( lRet )
         EEC->(RECLOCK("EEC",.F.))
      EEC->EEC_ETA:=IF(!EMPTY(cETANOVO),cETANOVO,EEC->EEC_ETA)
      EEC->EEC_ETD:=IF(!EMPTY(cETSNOVO),cETSNOVO,EEC->EEC_ETD)
      EEC->EEC_ETADES:=IF(!EMPTY(cETSNOVO),cETSNOVO+EEC->EEC_TRSTIM,EEC->EEC_ETADES)
      EEC->EEC_EMBARC := IF(!EMPTY(cNAVIONO),EE6->EE6_COD,EEC->EEC_EMBARC)
      
	     M->EEC_ETA      := IF(!EMPTY(cETANOVO),cETANOVO,EEC->EEC_ETA)                    
      M->EEC_ETD      := IF(!EMPTY(cETSNOVO),cETSNOVO,EEC->EEC_ETD)                    
      M->EEC_ETADES   := IF(!EMPTY(cETSNOVO),cETSNOVO+EEC->EEC_TRSTIM,EEC->EEC_ETADES) 
      M->EEC_EMBARC   := IF(!EMPTY(cNAVIONO),EE6->EE6_COD,EEC->EEC_EMBARC)             

	     If !EMPTY(cAGEMBNO)
         IF !EMPTY(cAGEMB)
            EEB->(RECLOCK("EEB",.F.))
            EEB->(DBDELETE())
            EEB->(MSUNLOCK())
   		    ENDIF
      		 EEB->(RECLOCK("EEB",.T.))
						   EEB->EEB_FILIAL := XFILIAL("EEB")
		       EEB->EEB_PEDIDO := cEEB_PED
		       EEB->EEB_CODAGE := SY5->Y5_COD
		       EEB->EEB_NOME   := SY5->Y5_NOME
		       EEB->EEB_TIPOAGE:= cEEB_TIPO
		       EEB->EEB_OCORRE := OC_EM
										   
		       M->EEB_FILIAL   := XFILIAL("EEB") 
         M->EEB_PEDIDO   := cEEB_PED       
		       M->EEB_CODAGE   := SY5->Y5_COD    
		       M->EEB_NOME     := SY5->Y5_NOME   
		       M->EEB_TIPOAGE  := cEEB_TIPO      
		       M->EEB_OCORRE   := OC_EM
							            
         EEB->(MSUNLOCK())
         
   	  EndIf
   ENDIF
   
End Sequence

IF Select("Work_Men") > 0
   Work_Men->(E_EraseArq(cFileMen))
Endif

//retorna a situacao anterior ao processamento
RestOrd(aOrd)

Return lRet

/*
Funcao      : TelaGets()
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder M Oliveira
Data/Hora   : 29/10/99 11:20  
Revisao     :
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.
Local nOpc := 0
Local bOk     := {||lRet:=.t.,oDlg:End()}
Local bCancel := {||oDlg:End()}

Local oDlg 

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE AllTrim(WorkId->EEA_TITULO) FROM 9,0 TO 35,62 OF oMainWnd 

      @ 20,5 SAY "Changed on" PIXEL
      @ 20,42 MSGET cCHANGED SIZE 80,8 PIXEL
      
      @ 33,5  SAY STR0003 PIXEL //"Agente Atual"
      @ 33,42 MSGET cAGEMB SIZE 123,8 WHEN .F. PIXEL
      
      @ 46,5  SAY STR0004 PIXEL //"Agente Novo"
      @ 46,42 MSGET cAGEMBNO SIZE 115,8 F3 "Y5A" PIXEL
      
      @ 59,5  SAY STR0005 PIXEL //"Embarc.Atual"
      @ 59,42 MSGET cNAVIOAT SIZE 123,8 WHEN .F. PIXEL
      
      @ 72,5  SAY STR0006 PIXEL //"Embarc. Novo"
      @ 72,42 MSGET cNAVIONO SIZE 123,8 F3 "E61" PIXEL
      
      @ 85,5  SAY STR0007 PIXEL //"ETA Atual"
      @ 85,42 MSGET cETAATUA SIZE 80,8 WHEN .F. PIXEL
      
      @ 98,5  SAY STR0008 PIXEL //"ETA Novo"
      @ 98,42 MSGET cETANOVO SIZE 80,8 PIXEL

      @ 111,5  SAY STR0009 PIXEL //"ETS Atual"
      @ 111,42 MSGET cETSATUA SIZE 80,8 WHEN .F. PIXEL
      
      @ 124,5  SAY STR0010 PIXEL //"ETS Novo"
      @ 124,42 MSGET cETSNOVO SIZE 80,8 PIXEL

      EECMensagem(EEC->EEC_IDIOMA,"2",{138,1,195,245})
  
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

End Sequence

Return lRet

*------------------------------------------------------------------------------*
* FIM DO PROGRAMA EECPEM21.PRW                                                 *
*------------------------------------------------------------------------------*
