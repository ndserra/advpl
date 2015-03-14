//Funcao    :EICLOTE   
//Autor     :Cristiano A. Ferreira 
//Co-Autor  :Alex Wallauer (NF)
//Data      :04/05/1999
//Descricao :Customizacao Geral
//Sintaxe   :ExecBlock("EICLOTE",.F.,F.,<Arg>)
//             <Arg> = "ESTORNO" - Estorno da Gi
//             <Arg> = "ENVIO"   - Envio ao Orientador
//             <Arg> = "NF"      - Receb. Importacao
//Uso       :SIGAEIC - LOTE - (EICGI400/EICOR101/EICDI154)
#include "rwmake.ch"
#include "EICLOTE.CH"
#include "AVERAGE.CH"

#define CRLF Chr(13)+Chr(10)

*----------------------------------------*
User Function Eiclote()
*----------------------------------------*
//Local C, j, D, N
STATIC cREPL
IF ! GetMv("MV_LOTEEIC") $ cSim
   RETURN NIL
ENDIF

IF ParamIXB == "ESTORNO"

   IF SWV->(dbSeek(xFilial()+SPACE(17)+SW5->(W5_PGI_NUM+W5_PO_NUM+W5_CC+W5_SI_NUM+W5_COD_I+Str(W5_REG,AVSX3("W5_REG",3)))))
      IF SW5->W5_QTDE - SW5->W5_SALDO_Q <= 0

         //Exclui registros do arquivo de lotes ...
         While !SWV->(Eof()) .And. SWV->WV_FILIAL == xFilial("SWV") .And.;
                SWV->WV_HAWB == SPACE(17).AND.;
                SW5->(W5_PGI_NUM+W5_PO_NUM+W5_CC+W5_SI_NUM+W5_COD_I+Str(W5_REG,AVSX3("W5_REG",3))) == ;
                SWV->(WV_PGI_NUM+WV_PO_NUM+WV_CC+WV_SI_NUM+WV_COD_I+Str(WV_REG,AVSX3("WV_REG",3)))

            SWV->(RecLock("SWV",.F.))
            SWV->(dbDelete())
            SWV->(MSUnlock("SWV",.F.))

            SWV->(dbSkip())
         End
      Else 
         //Existem embarques para este item ...
         Help("", 1, "AVG0000119")
/*       MsgInfo(STR0001+CRLF+; //"Os lotes do item abaixo não podem ser estornados, pois há embarques cadastrados."
            STR0002+SW5->W5_PGI_NUM+CRLF+; //"PGI: "
            STR0003+SW5->W5_PO_NUM+CRLF+; //"PO: "
            STR0004+SW5->W5_CC+CRLF+; //"CC: "
            STR0005+SW5->W5_SI_NUM+CRLF+;//"SI: "
            STR0006+SW5->W5_COD_I+CRLF+; //"Cod.Item: "
            STR0007+(Transf(SW5->W5_QTDE,AVSX3("W5_QTDE",6)),STR0008) //"Qtde: "###"Atenção"*/
      Endif
   Endif

Elseif ParamIXB == "ENVIO"
   IF cREPL = NIL
      cREPL:=REPL("=",LEN(SWV->WV_LOTE))+" "+REPL("=",LEN(AVSX3("W5_QTDE",6))-3)+" ========"
   ENDIF
   If SWV->(dbSeek(xFilial()+SPACE(17)+SW5->(W5_PGI_NUM+W5_PO_NUM+W5_CC+W5_SI_NUM+W5_COD_I+Str(W5_REG,AVSX3("W5_REG",3)))))
      //Grava os lotes na descricao detalhada da mercadoria ...
      ItemLi->DES_DETMER := ItemLi->DES_DETMER + CRLF
      ItemLi->DES_DETMER := ItemLi->DES_DETMER + STR0009 +CRLF //"Lote            Quantidade Validade"
      ItemLi->DES_DETMER := ItemLi->DES_DETMER + cREPL

      While !SWV->(Eof()) .And. SWV->WV_FILIAL == xFilial("SWV") .And.;
          SWV->WV_HAWB == SPACE(17) .AND.;
          SW5->(W5_PGI_NUM+W5_PO_NUM+W5_CC+W5_SI_NUM+W5_COD_I+Str(W5_REG,AVSX3("W5_REG",3))) == ;
          SWV->(WV_PGI_NUM+WV_PO_NUM+WV_CC+WV_SI_NUM+WV_COD_I+Str(WV_REG,AVSX3("WV_REG",3)))

         ItemLi->DES_DETMER := ItemLi->DES_DETMER+CRLF+SWV->WV_LOTE+" "+Transf(SWV->WV_QTDE,AVSX3("W5_QTDE",6))+" "+Dtoc(SWV->WV_DT_VALI)
         SWV->(dbSkip())  
      End
   Endif

Elseif ParamIXB == "NF"

   lExecFuncPrograma:=.T.
   
/* nRecW7 := SW7->(RECNO())
   nOrdW7 := SW7->(INDEXORD())
   DBSELECTAREA("Work1")

   Work1->(DBGOTOP())
   lTemItemcomLote:=.F.
   ProcRegua(LEN(aRecWork1))
   IF TYPE("aCposLote") = "A"
      aCampos:=ACLONE(aCposLote)
   ELSE
      aCampos:={}
   ENDIF
   nTamReg:=AVSX3("WV_REG",3)

   AADD(aCampos,"WKPRECO" );AADD(aCampos,"WKREC_ID"  )
   AADD(aCampos,"WK_REG"  );AADD(aCampos,"WKICMS_RED")
   AADD(aCampos,"WKRECSW9");AADD(aCampos,"WK_DIASPAG")
   
   DBSELECTAREA("Work1")
   FOR C := 1 TO FCOUNT()
       IF VALTYPE(FIELDGET(C)) $ "CDL" .AND. ASCAN(aCampos,FIELD(C)) = 0
          AADD(aCampos,FIELD(C))
       ENDIF
   NEXT
   
   aDados:=ARRAY(LEN(aCampos))
   aValor:=ARRAY(15,3)
   SW7->(DBSETORDER(1))
   FOR N := 1 TO LEN(aRecWork1)

      Work1->(dbGoTo(aRecWork1[N]))

      IncProc(STR0011 +Work1->WKCOD_I) //"Verificando Lotes, Item: "

      IF IF(LEFT(Work1->WKPGI_NUM,1) == "*" ,;
      SWV->(dbSeek(xFilial()+SW6->W6_HAWB+Work1->(WKPGI_NUM+WKPO_NUM+WK_CC+WKSI_NUM+WKCOD_I+Str(WK_REG,nTamReg)))),;
      SWV->(dbSeek(xFilial()+SPACE(17)+Work1->(WKPGI_NUM+WKPO_NUM+WK_CC+WKSI_NUM+WKCOD_I+Str(WK_REG,nTamReg)))))

         nQtde       :=Work1->WKQTDE
         aValor[01,1]:=Work1->WKFOB     // FOB
         aValor[02,1]:=Work1->WKFOB_R   // FOB R$
         aValor[03,1]:=Work1->WKFOB_ORI // FOB    original
         aValor[04,1]:=Work1->WKFOBR_ORI// FOB R$ original
         aValor[05,1]:=Work1->WKVALMERC // Preco Total
         aValor[06,1]:=Work1->WKRDIFMID // Diferenca cambial e Midia
         aValor[07,1]:=Work1->WKPESOL   // Peso Liquido
         aValor[08,1]:=Work1->WKRATEIO  // Rateio FOB
         aValor[09,1]:=Work1->WK_VLMID_M// Valor da Midia em Real
         aValor[10,1]:=Work1->WK_QTMID  // B1_QTMIDIA * W7_QTDE
         aValor[11,1]:=Work1->WKOUTDESP
         aValor[12,1]:=Work1->WKINLAND 
         aValor[13,1]:=Work1->WKPACKING
         aValor[14,1]:=Work1->WKDESCONT
         aValor[15,1]:=Work1->WKSEGURO

         AEVAL(aValor,{|t,I|aValor[I,2]:=0})
 
         Rateio()

         SWV->(dbSkip())
         cHAWB:=IF(LEFT(Work1->WKPGI_NUM,1)#"*",SPACE(17),SW6->W6_HAWB)
         While !SWV->(Eof())                       .And.;
                SWV->WV_FILIAL  == xFilial("SWV")  .And.;
                SWV->WV_HAWB    == cHawb .AND.;
                SWV->WV_PGI_NUM == Work1->WKPGI_NUM.And.; 
                SWV->WV_PO_NUM  == Work1->WKPO_NUM .And.; 
                SWV->WV_CC      == Work1->WK_CC    .And.; 
                SWV->WV_SI_NUM  == Work1->WKSI_NUM .And.; 
                SWV->WV_COD_I   == Work1->WKCOD_I  .And.; 
                SWV->WV_REG     == Work1->WK_REG
   
   
            For j := 1 To LEN(aCampos)
                aDados[J]:=Work1->(FieldGet(FieldPos(aCampos[j])))
            Next

            Work1->(DBAPPEND())

            For j := 1 To LEN(aCampos)
                IF !EMPTY(aDados[J])
                   Work1->(FieldPut(FieldPos(aCampos[j]),aDados[J]))
                ENDIF
            Next

            Rateio()

            SWV->(dbSkip())
            cHAWB:=IF(LEFT(Work1->WKPGI_NUM,1)#"*",SPACE(17),SW6->W6_HAWB)
   
         EndDo
   
       //Diferenca  :=Total Original - Somatoria
         FOR D := 1 TO LEN(aValor)
             aValor[D,3]:= aValor[D,1] - aValor[D,2]
         NEXT
         
         Work1->WKFOB     :=Work1->WKFOB     +aValor[01,3]
         Work1->WKFOB_R   :=Work1->WKFOB_R   +aValor[02,3]// FOB R$
         Work1->WKFOB_ORI :=Work1->WKFOB_ORI +aValor[03,3]
         Work1->WKFOBR_ORI:=Work1->WKFOBR_ORI+aValor[04,3]
         Work1->WKVALMERC :=Work1->WKVALMERC +aValor[05,3]// Preco Total
         Work1->WKRDIFMID :=Work1->WKRDIFMID +aValor[06,3]// Peso Liquido
         Work1->WKPESOL   :=Work1->WKPESOL   +aValor[07,3]// Peso Liquido
         Work1->WKRATEIO  :=Work1->WKRATEIO  +aValor[08,3]// Rateio FOB
         Work1->WK_VLMID_M:=Work1->WK_VLMID_M+aValor[09,3]
         Work1->WK_QTMID  :=Work1->WK_QTMID  +aValor[10,3]
         Work1->WKOUTDESP :=Work1->WKOUTDESP +aValor[11,3]
         Work1->WKINLAND  :=Work1->WKINLAND  +aValor[12,3]
         Work1->WKPACKING :=Work1->WKPACKING +aValor[13,3]
         Work1->WKDESCONT :=Work1->WKDESCONT +aValor[14,3]
         Work1->WKSEGURO  :=Work1->WKSEGURO  +aValor[15,3]
   
      Endif

   NEXT
*/
Endif

Return(NIL)

/*-------------------------------------*
Static Function Rateio()
*-------------------------------------*

nPerc:=SWV->WV_QTDE/nQtde

Work1->WKQTDE    :=SWV->WV_QTDE
Work1->WK_LOTE   :=SWV->WV_LOTE   
Work1->WKDTVALID :=SWV->WV_DT_VALI
Work1->WKFOB     :=aValor[01,1] * nPerc
Work1->WKFOB_R   :=aValor[02,1] * nPerc// FOB R$
Work1->WKFOB_ORI :=aValor[03,1] * nPerc
Work1->WKFOBR_ORI:=aValor[04,1] * nPerc
Work1->WKVALMERC :=aValor[05,1] * nPerc//Preco Total
Work1->WKRDIFMID :=aValor[06,1] * nPerc
Work1->WKPESOL   :=aValor[07,1] * nPerc
Work1->WKRATEIO  :=aValor[08,1] * nPerc
Work1->WK_VLMID_M:=aValor[09,1] * nPerc
Work1->WK_QTMID  :=aValor[10,1] * nPerc
Work1->WKOUTDESP :=aValor[11,1] * nPerc
Work1->WKINLAND  :=aValor[12,1] * nPerc
Work1->WKPACKING :=aValor[13,1] * nPerc
Work1->WKDESCONT :=aValor[14,1] * nPerc
Work1->WKSEGURO  :=aValor[15,1] * nPerc

                               
//Somatoria                    
aValor[01,2]:=aValor[01,2]+Work1->WKFOB
aValor[02,2]:=aValor[02,2]+Work1->WKFOB_R   // FOB R$
aValor[03,2]:=aValor[03,2]+Work1->WKFOB_ORI
aValor[04,2]:=aValor[04,2]+Work1->WKFOBR_ORI
aValor[05,2]:=aValor[05,2]+Work1->WKVALMERC
aValor[06,2]:=aValor[06,2]+Work1->WKRDIFMID
aValor[07,2]:=aValor[07,2]+Work1->WKPESOL
aValor[08,2]:=aValor[08,2]+Work1->WKRATEIO // Rateio FOB
aValor[09,2]:=aValor[09,2]+Work1->WK_VLMID_M
aValor[10,2]:=aValor[10,2]+Work1->WK_QTMID
aValor[11,2]:=aValor[11,2]+Work1->WKOUTDESP
aValor[12,2]:=aValor[12,2]+Work1->WKINLAND
aValor[13,2]:=aValor[13,2]+Work1->WKPACKING
aValor[14,2]:=aValor[14,2]+Work1->WKDESCONT
aValor[15,2]:=aValor[15,2]+Work1->WKSEGURO
Return*/

//-------------------------------------------------------------------------------------*
//                         FIM DO PROGRAMA EICLOTE.PRW
//-------------------------------------------------------------------------------------*
