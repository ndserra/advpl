#include "rwmake.ch"      
//#include "AVERAGE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ EICGI333 ³ Autor ³ AVERAGE-RHP           ³ Data ³ 12/09/00                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ SUFRAMA                                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAEIC / protheus 508                                                             ³±±
±±Rdmake utilizado para atualizar os dados provinientes da Suframa, enquanto o arquivo            ³±±
±± da Suframa não estabilizar ( está sendo alterado diariamente , sua versão mais recente         ³±±
±± está sendo colocada na Internet) - o usuário é obrigado a dar download do arquivo na           ³±±
±± internet e convertê-lo para DBF .                                                              ³±±
±± Com este rdmake o usuario poderá atualizar a LI com os dados da Suframa. Quando é feito isto,  ³±±
±± é gravada a descrição , ncm e insumo na lista de engenharia                                    ³±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Eicgi333()   

DO CASE

   CASE ParamIXB == "ABRIR"  //  ABRE OS ARQUIVOS VINDO DA SUFRAMA
   
     IF FILE("PROD_ITE.DBF") .AND. FILE("SUF_NCM.DBF")      
        DBUSEAREA(.T.,,"PROD_ITE.DBF","Suframa",.T.)
        IF ! USED()
            HELP("", 1, "AVG0000114")
            RETURN .F.
        ENDIF              
        cNomSuf := CriaTrab(,.F.)
        IndRegua("Suframa",cNomSuf+OrdBagExt(),"CD_PRODUTO+CD_MERCADO+SFNCM_DETA")
        
        DBUSEAREA(.T.,,"SUF_NCM.DBF","Desc_Suf",.T.)
        IF ! USED()
           HELP("", 1, "AVG0000114")
           RETURN .F.
        ENDIF
        cOutSuf := CriaTrab(,.F.)
        IndRegua("Desc_Suf",cOutSuf+OrdBagExt(),"SFNCM_CODI+SFNCM_DETA")
        
        aHeader:= aCampos:={}
       aSuf := {{"WKINSUMO", "C" , 4, 0},{"WKDESCR" , "C" , 254, 0}}
       cWorkArq:=E_CriaTrab(,aSuf,"WorkSuf")
       
       IF !USED()
          HELP("", 1, "AVG0000114")
          RETURN  .F.
       ENDIF
   ENDIF
      
   CASE ParamIXB == "BOTAO"  // CRIA O BOTAO PARA ACESSAR O ARQUIVO DA SUFRAMA
      IF FILE("PROD_ITE"+GetdbExtension()) .AND. FILE("SUF_NCM"+GetdbExtension())
        @35,(oDlg:nClientWidth-6)/2-80 BUTTON "Suframa" SIZE 34,11 ACTION U_TelaSuf()
      ENDIF
   CASE ParamIXB == "FECHAR"  // Fechar Arquivos da SUFRAMA
   
   IF FILE("PROD_ITE"+GetdbExtension()) .AND. FILE("SUF_NCM"+GetdbExtension())          
     Suframa->(DBCLOSEAREA())
     Desc_Suf->(DBCLOSEAREA())
     WorkSuf->(E_EraseArq(cWorkArq,cNomSuf,cOutSuf))
   ENDIF                      
   
   CASE ParamIXB == "ALTERA" 
      IF FILE("PROD_ITE"+GetdbExtension()) .AND. FILE("SUF_NCM"+GetdbExtension())
        IF !U_TelaSuf(1)     
          RETURN .F.
        ENDIF  
      ENDIF
   CASE ParamIXB == "ATUALIZA" 
     IF FILE("PROD_ITE"+GetdbExtension()) .AND. FILE("SUF_NCM"+GetdbExtension())
       U_Atualiza(1)     
     ENDIF
   
ENDCASE  

Return(.T.)        

USER FUNCTION TelaSuf(nAlt)

LOCAL oDlg1, Tb_suf:={}, OldArea:=SELECT()
LOCAL oMarK1
LOCAL cTitulo, nBot := 0                                      
cNovaNcm := IF(nAlt == NIL, Work->WKTEC,cNcm)
Suframa->(DBSEEK(LEFT(M->W4_PROD_SU,4)+LEFT(cNovaNcm,8)))
WorkSuf->(__DBZAP()) 

DO WHILE ! Suframa->(EOF()) .AND. LEFT(M->W4_PROD_SU,4) == Suframa->CD_PRODUTO .AND.;
                             Suframa->CD_MERCADO == LEFT(cNovaNcm,8)
  Desc_Suf->(DBSEEK(Suframa->CD_MERCADO+Suframa->SFNCM_DETA))     
  WorkSuf->(DBAPPEND())                                      
  WorkSuf->WKINSUMO := Desc_Suf->SFNCM_DETA
  WorkSuf->WKDESCR  := Desc_Suf->SFNCM_DESC
  Suframa->(DBSKIP())
ENDDO  
WorkSuf->(DBGOTOP())
IF WorkSuf->(EOF()) .AND. WorkSuf->(BOF())
  HELP("", 1, "AVG0000115")
  Work->WKFLAG:= .F.
  Work->WKFLAGWIN:=SPACE(02)
  RETURN .F.
ENDIF       


AADD(Tb_sUF,{"WKINSUMO",,"Insumo"}) 
AADD(Tb_SUF,{"WKDESCR" ,,"Descrição Suframa"})

DBSELECTAREA("WorkSuf")

cTitulo:= "Consulta de Descrições da Suframa"

DEFINE MSDIALOG oDlg1 TITLE cTitulo FROM 4,3 TO 20,100 OF oMainWnd

oMark1:= MsSelect():New("WorkSuf",,,TB_suf,.F.,cMarca,{10,6,100,370},,)
oMark1:bAval:={||DESCGI33()}
                   

DEFINE SBUTTON FROM 100,10 TYPE 1 ACTION (nbot := 1,oDlg1:End()) ENABLE OF oDlg1 PIXEL
IF nAlt == NIL
  DEFINE SBUTTON FROM 100,50 TYPE 2 ACTION (oDlg1:End()) ENABLE OF oDlg1 PIXEL
ENDIF
ACTIVATE MSDIALOG oDlg1 
IF nBot == 1
  IF nAlt ==NIL
    U_Atualiza()
  ENDIF
ENDIF  
DBSELECTAREA("Work")
oMark:oBrowse:Refresh()
oMark:oBrowse:Reset()
  
RETURN .T.


USER FUNCTION Atualiza()
LOCAL nRec := Work->(RECNO()), nChave :=Work->WKTEC ,cCod := Work->WKCOD_I
Work->(DBSEEK(nChave))
DO WHILE ! Work->(EOF()) .AND.  nChave ==Work->WKTEC
  IF Work->WKCOD_I # cCod
    Work->(DBSKIP())
    LOOP
  ENDIF  
  Work->WKDESCR:= MEMOLINE(WorkSuf->WKDESCR,36,1)                                 
  Work->(DBSKIP())
ENDDO             
Work->(DBGOTO(nRec))
SYX->(DBSETORDER(3))
IF ! SYX->(DBSEEK(xFilial("SYX")+M->W4_PROD_SU+Work->WKCOD_I))
  HELP("", 1, "AVG0000116")
  RETURN .F.
ENDIF  
  
SYX->(RECLOCK("SYX",.F.))
SYX->YX_DES_ZFM:= WorkSuf->WKDESCR
SYX->YX_INSUMO := WorkSuF->WKINSUMO
SYX->YX_TEC := Work->WKTEC
SYX->(MSUNLOCK())
RETURN .T.

STATIC FUNCTION DESCGI33()

LOCAL cDesc1:=WorkSuf->WKDESCR,bBotao:={||oDlg4:End()}

DEFINE MSDIALOG oDlg4 TITLE "Descricao Insumo "+WorkSuf->WKINSUMO FROM 7,0.5 TO 20,50 OF oMainWnd

@ 20,20 GET cDesc1 SIZE 150,55  WHEN .F. MEMO

ACTIVATE MSDIALOG oDlg4  ON INIT (ENCHOICEBAR(oDlg4,bBotao,bBotao))CENTERED


RETURN .T.
