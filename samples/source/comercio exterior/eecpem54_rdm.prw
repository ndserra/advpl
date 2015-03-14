
/*
Programa        : EECPEM54_RDM.
Objetivo        : Impressao do Packing List (Modelo 3).
Autor           : Jeferson Barros Jr.
Data/Hora       : 17/12/2003 13:38.
Obs.            : Inicialmente desenvolvido p/ SAI. (ECSAIE05.PRW)
*/

#INCLUDE "EECRDM.CH"
#INCLUDE "EECPEM54.CH"

#define NUMLINPAG 22
#define TAMDESC 22
#define cPict1 "@E 999,999,999"
#define cPict2 "@E 999,999,999.99"

/*
Funcao      : EECPEM54.
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Impressao do Packing List (Modelo 3).
Autor       : Jeferson Barros Jr.
Data/Hora   : 17/12/2003 13:38.
Revisao     :
Obs.        : ER - 10/09/2007 - Alteração no cáculo de Volume e Qtde de Embalagens.
              Colunas:
              Dimensões: Dimensão da Embalagem mais Externa
              Volume   : Volume Total das Embalagens mais Externas
              Total de Embalagens : Total de Embalagens Unitárias
              Total de Peças/Embalagens : Capacidade das Embalagens Unitárias
              Total Embalagens Externas : Qtde. total das embalagens mais externas

              Totais:
              Total Geral de Rack: Qtde. total de embalagens do tipo Rack
              Total Geral de Caixas : Qtde. total de embalagens unitárias
              Quantidade de Volumes : Qtde. total de embalagens mais externas
              Volume Total : Soma dos valores da coluna "Volume"
*/
*----------------------*
User Function EECPEM54()
*----------------------*
Local lRet := .f.
Local nAlias := Select()
Local aOrd := SaveOrd({"EE9","SA2","SY9","SA1","SYA","SYQ","EEK","EE5"})
Local cCod,cLoja

Private nTotRacks, nTotCaixa, nTotPesLi, nTotPesBr, nTotQtdVo, nTotVolum 
Private nLin :=0,nPag := 1, nTotPag := 1
Private nComEmb := 0, nLarEmb := 0, nAltEmb := 0
Private cUltEmb := "", nQtdUltEmb := 0

Begin Sequence

   EE9->(dbSetOrder(3))
   //EEK->(dbSetOrder(2))
   EE5->(dbSetOrder(1))
   EE7->(dbSetOrder(1))
   EEO->(dbSetorder(2))      
   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))
   EE7->(dbSeek(xFilial()+EE9->EE9_PEDIDO))
   
   cSeqRel := GetSXENum("SY0","Y0_SEQREL")
   ConfirmSX8()
   
   HEADER_P->(Add())

   IF !Empty(EEC->EEC_EXPORT)
      cCod := EEC->EEC_EXPORT
      cLoja:= EEC->EEC_EXLOJA
   Else
      cCod := EEC->EEC_FORN
      cLoja:= EEC->EEC_FOLOJA
   Endif

   // Exportador ou Fornecedor
   SA2->(dbSeek(xFilial("SA2")+cCod+cLoja))
   HEADER_P->AVG_C01_60 := SA2->A2_NOME
   cEnd := AllTrim(SA2->A2_END) +; 
           If(!Empty(SA2->A2_NR_END)," "+AllTrim(SA2->A2_NR_END),"") +; 
           If(!Empty(SA2->A2_BAIRRO)," - "+AllTrim(SA2->A2_BAIRRO),"") +;
           " - " + AllTrim(SA2->A2_MUN) +;
           "/" +  SA2->A2_EST +;
           " " + AllTrim(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM"))
   
   HEADER_P->AVG_C01150 := cEnd
   cEnd := If(!Empty(SA2->A2_CGC),"CNPJ "+AllTrim(SA2->A2_CGC),"")
   
   HEADER_P->AVG_C03_60 := cEnd
   cEnd := If(!Empty(SA2->A2_TEL),"TEL.: "+AllTrim(SA2->A2_TEL),"")+;
           If(!Empty(SA2->A2_FAX),"  FAX.: "+AllTrim(SA2->A2_FAX),"")
   
   HEADER_P->AVG_C04_60 := cEnd

   // Importador
   HEADER_P->AVG_C05_60 := EEC->EEC_IMPODE
   HEADER_P->AVG_C06_60 := EEC->EEC_ENDIMP
   HEADER_P->AVG_C07_60 := EEC->EEC_END2IM

   //No do Pedido
   HEADER_P->AVG_C01_30 := EEC->EEC_PEDREF //DFS - 30/05/11 - Inclusão do Pedido de Referência, ao invés da Referência do Importador. //EEC->EEC_REFIMP

   //Data do Pedido 
   HEADER_P->AVG_C01_10 := DtoC(EE7->EE7_DTPEDI)

   //No do Packing List
   HEADER_P->AVG_C02_30 := EEC->EEC_NRINVO

   //Data do Packing List
   HEADER_P->AVG_C02_10 := DtoC(EEC->EEC_DTINVO)
   
   nTotRacks := 0
   nTotCaixa := 0
   nTotPesLi := 0
   nTotPesBr := 0
   nTotQtdVo := 0
   nTotVolum := 0
   nQtdPallet:= 0 
   
   GravaItens()
  
   // Totais
   cTotRacks := DecPoint(LTrim(Transf(nTotRacks,cPict1)))
   HEADER_P->AVG_C03_30 := cTotRacks

   cTotCaixa := DecPoint(LTrim(Transf(nTotCaixa,cPict1)))
   HEADER_P->AVG_C04_30 := cTotCaixa

   cTotPesLi := DecPoint(LTrim(Transf(EEC->EEC_PESLIQ,cPict2)),2)
   cTotPesLi += If(!Empty(cTotPesLi)," Kg","")
   HEADER_P->AVG_C05_30 := cTotPesLi

   cTotPesBr := DecPoint(LTrim(Transf(EEC->EEC_PESBRU,cPict2)),2)  
   cTotPesBr += If(!Empty(cTotPesBr)," Kg","")
   HEADER_P->AVG_C06_30 := cTotPesBr

   cTotQtdVo := DecPoint(LTrim(Transf(nTotQtdVo,cPict1)))  
   HEADER_P->AVG_C07_30 := cTotQtdVo

   cTotVolum := DecPoint(LTrim(Transf(nTotVolum,cPict2)),2)  
   cTotVolum += If(!Empty(cTotVolum)," m3","")
   HEADER_P->AVG_C08_30 := cTotVolum

   HEADER_P->AVG_C08_10 := AllTrim(Str(nTotPag))    

   // Marks
   cMemo := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO))
   HEADER_P->AVG_C04_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),1)
   HEADER_P->AVG_C05_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),2)
   HEADER_P->AVG_C06_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),3)
   HEADER_P->AVG_C07_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),4)
   HEADER_P->AVG_C08_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),5)
   HEADER_P->AVG_C09_20 := MemoLine(cMemo,AVSX3("EEC_MARCAC",AV_TAMANHO),6)     
   HEADER_P->(dbUnlock())

   HEADER_H->(dbAppend())
   AvReplace("HEADER_P","HEADER_H") 

   DETAIL_P->(DbGoTop())
   Do While ! DETAIL_P->(Eof())
      DETAIL_H->(DbAppend())
      AvReplace("DETAIL_P","DETAIL_H")
      DETAIL_P->(DbSkip())
   EndDo   

   HEADER_P->(DBCOMMIT())
   DETAIL_P->(DBCOMMIT())

   lRet := .t.

End Sequence

RestOrd(aOrd)
Select(nAlias)

Return lRet

/*
Funcao      : GravaItens
Parametros  : Nenhum.
Retorno     : Nil
Objetivos   : Gravar os itens.
Autor       : Jeferson Barros Jr.
Data/Hora   : 17/12/03 - 13:57.
Revisao     :
Obs.        :
*/
*-------------------------*
Static Function GravaItens
*-------------------------*
Local i:=0

Begin Sequence

   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))

   While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB
      
      cDimensao := ""
      cVolume   := ""
      /*
      nComPallet:= 0
      nLarPallet:= 0
      nAltPallet:= 0     
      nVolume   := 0
      nQtdPallet:= 0       
      nQtd      := 0
      */
      
      nVolume    := 0      
      nQtdUltEmb := 0      

      AppendDet()
      
      // Referencia 
      DETAIL_P->AVG_C01_20 := EE9->EE9_REFCLI

      // Quantidade
      IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EEC->EEC_IDIOMA+EE9->EE9_UNIDAD))
          MsgStop(STR0001+EE9->EE9_UNIDAD+STR0002+EEC->EEC_IDIOMA,STR0003) //"Unidade de medida "###" nào cadastrada em "###"Aviso"
      Endif
      
      DETAIL_P->AVG_C02_20 := DecPoint(Transf(EE9->EE9_SLDINI,"@E 999,999,999")) + " " + AllTrim(EE2->EE2_DESCMA)     
   
      /*      
      If EEK->(dbSeek(xFilial()+OC_EM+EEC->EEC_PREEMB+EE9->EE9_SEQEMB+EE9->EE9_EMBAL1))
      
         While !EEK->(Eof()) .And.;
                EEK->EEK_FILIAL = xFilial("EEK")  .And.;
                EEK->EEK_TIPO   = OC_EM           .And.;
                EEK->EEK_PEDIDO = EEC->EEC_PREEMB .And.;
                EEK->EEK_SEQUEN = EE9->EE9_SEQEMB .And.;
                EEK->EEK_CODIGO = EE9->EE9_EMBAL1
      */ 
      
      EEK->(DbSetOrder(1))
      If EEK->(dbSeek(xFilial("EEK")+OC_EMBA+EE9->EE9_EMBAL1))
         While EEK->(!EOF()) .and. EEK->(EEK_FILIAL+EEK_TIPO+EEK_CODIGO) == xFilial("EEK")+OC_EMBA+EE9->EE9_EMBAL1
      
  	        EE5->(dbSeek(xFilial()+EEK->EEK_EMB))
            
            If EEK->EEK_SEQ == "01"
               nQtd := EE9->EE9_QTDEM1
            Else
               nQtd := nQtdUltEmb
            EndIf
            
            nQtdUltEmb := nQtd / EEK->EEK_QTDE
            
            cUltEmb := EEK->EEK_EMB

            If At("RACK",EE5->EE5_DESC) > 0
               nTotRacks += nQtdUltEmb
            EndIf

            /*
            If At("PALLET",EE5->EE5_DESC) > 0   
               
		 	   nAltPallet := EE5->EE5_HALT
               nLarPallet := EE5->EE5_LLARG
               nComPallet := EE5->EE5_CCOM
              
           
               EE5->(dbSeek(xFilial()+EE9->EE9_EMBAL1))

               nMin := 9999999
      		   nMax := 0

               If EEO->(dbSeek(xFilial("EEO")+EEC->EEC_PREEMB+TIPO_ITEM+EE9->EE9_SEQEMB))
	              While !EEO->(Eof()) .And. ;
	    	             EEO->EEO_PREEMB = EEC->EEC_PREEMB .And. ;
    	    	         EEO->EEO_TIPO   = TIPO_ITEM .And. ;
                         EEO->EEO_CODEMB = EE9->EE9_SEQEMB
       		      
       		         nMin := Min(nMin,Val(EEO->EEO_SEQ)) 
      		         nMax := Max(nMax,Val(EEO->EEO_SEQ)) 
             
	                 EEO->(dbSkip())
	 		      EndDo    
               Endif                       

               nMin := Str(nMin,2)
               nMax := Str(nMax,2)

	           If EEO->(dbSeek(xFilial("EEO")+EEC->EEC_PREEMB+TIPO_EMB+EE9->EE9_EMBAL1))
	              While !EEO->(Eof()) .And. ;
	    	             EEO->EEO_PREEMB = EEC->EEC_PREEMB .And. ;
    	    	         EEO->EEO_TIPO   = TIPO_EMB .And. ;
	                     EEO->EEO_CODEMB = EE9->EE9_EMBAL1      		   
       		      
       		         nVal := Str(Val(EEO->EEO_SEQ),2)
       		      
       		         If nVal > nMin .or. nVal = nMin 
       		            If nVal < nMax .or. nVal = nMax 
	       	 	           nQtd += EEO->EEO_QTDE
                        Endif
                     Endif
	                 EEO->(dbSkip())
	 		      EndDo    
               Endif                       
	        
               nRec_EEK := EEK->(Recno())
               EEK->(dbSetOrder(3))
               If EEK->(dbSeek(xFilial("EEK")+OC_EMBA+EE9->EE9_EMBAL1+EEK->EEK_EMB))
	              nQtd := If ( nQtd < EEK->EEK_QTDE , nQtd , EEK->EEK_QTDE ) 
               EndIf
               EEK->(dbSetOrder(2))
               EEK->(dbGoTo(nRec_EEK))
            
               DETAIL_P->AVG_C08_20 := DecPoint(LTrim(Transf(nQtd,cPict1)))  

               If EEO->(dbSeek(xFilial("EEO")+EEC->EEC_PREEMB+TIPO_EMB+EEK->EEK_EMB))
                  While !EEO->(Eof()) .And. ;
                     EEO->EEO_PREEMB = EEC->EEC_PREEMB .And. ;
                     EEO->EEO_TIPO   = TIPO_EMB .And. ;
				     EEO->EEO_CODEMB = EEK->EEK_EMB

       		         nVal := Str(Val(EEO->EEO_SEQ),2)
       		      
       		         IF nVal > nMin .or. nVal = nMin 
       		            If nVal < nMax .or. nVal = nMax 
                           nQtdPallet += EEO->EEO_QTDE
   	                    Endif
                     Endif              				  
             
  				     EEO->(dbSkip())
                  EndDo    
               Endif
           
		       nAltPallet += EE5->EE5_HALT

		       nVolume := nAltPallet*nLarPallet*nComPallet   
		       nVolume:=Round(nVolume,2)
		       cVolume := DecPoint(Transf(nVolume,cPict2),2) + " m3/pallet"

	        ElseIf At("RACK",EE5->EE5_DESC) > 0
               
		       nAltPallet := EE5->EE5_HALT
		       nLarPallet := EE5->EE5_LLARG
		       nComPallet := EE5->EE5_CCOM
               
		       nVolume := EE5->EE5_HALT*EE5->EE5_LLARG*EE5->EE5_CCOM 
		       nVolume:=Round(nVolume,2)
		       cVolume := DecPoint(Transf(nVolume,cPict2),2) + " m3/rack"
               
		       DETAIL_P->AVG_C08_20 := "0"  
   		       nTotRacks += EE9->EE9_QTDEM1
              
	        Endif
            */
            
            EEK->(dbSkip())
         
         EndDo
         
         //Verifica a Embalagem mais externa
         If EE5->(dbSeek(xFilial()+AvKey(cUltEmb,"EEK_EMB")))
            
            nComEmb := EE5->EE5_CCOM
            nLarEmb := EE5->EE5_LLARG
            nAltEmb := EE5->EE5_HALT
         
            nVolume := (nAltEmb*nLarEmb*nComEmb) * nQtdUltEmb
		    nVolume := Round(nVolume,2)
		    cVolume := DecPoint(Transf(nVolume,cPict2),2) + " m3"

         EndIf
     
      Else

	     EE5->(dbSeek(xFilial()+EE9->EE9_EMBAL1))
          
         nQtdUltEmb := EE9->EE9_QTDEM1
         
         nAltEmb := EE5->EE5_HALT
         nLarEmb := EE5->EE5_LLARG
	     nComEmb := EE5->EE5_CCOM

         nVolume := (nAltEmb*nLarEmb*nComEmb) * nQtdUltEmb
         nVolume := Round(nVolume,2)
	     cVolume := DecPoint(Transf(nVolume,cPict2),2) + " m3"
                  
	     If At("RACK",EE5->EE5_DESC) > 0
            /*	    
		    nAltPallet := EE5->EE5_HALT
		    nLarPallet := EE5->EE5_LLARG
		    nComPallet := EE5->EE5_CCOM

		    nVolume := EE5->EE5_HALT*EE5->EE5_LLARG*EE5->EE5_CCOM   
		    nVolume:=Round(nVolume,2)
		    cVolume := DecPoint(Transf(nVolume,cPict2),2) + " m3/rack"
            
		    
		    DETAIL_P->AVG_C08_20 := "0"  

		    nTotRacks += EE9->EE9_QTDEM1
	        
	        nQtdPallet:= EE9->EE9_QTDEM1
	        */
	        nTotRacks += nQtdUltEmb 
	     Endif
         
      EndIf
      
      /*
      cDimensao := AllTrim(Str((nComPallet*1000)))+" x "+;
                   AllTrim(Str((nLarPallet*1000)))+" x "+;
                   AllTrim(Str((nAltPallet*1000)))+" mm"
      */

      cDimensao := AllTrim(Str((nComEmb*1000)))+" x "+;
                   AllTrim(Str((nLarEmb*1000)))+" x "+;
                   AllTrim(Str((nAltEmb*1000)))+" mm"

      // Dimensoes
      DETAIL_P->AVG_C02_60 := cDimensao

      nQtdPallet := If( nQtdPallet >= EE9->EE9_QTDEM1,EE9->EE9_QTDEM1, nQtdPallet )     
       
      // Volume
      DETAIL_P->AVG_C03_20 := cVolume
      //nTotVolum := Round(nTotVolum + ( nVolume * nQtdPallet ),2)
      //nTotQtdVo += nQtdPallet
      nTotVolum := Round(nTotVolum + nVolume ,2)      
      nTotQtdVo += nQtdUltEmb

      // Peso Líquido / Peça
      DETAIL_P->AVG_C04_20 := DecPoint(Transf(EE9->EE9_PSLQUN,AvSx3("EE9_PSLQUN",AV_PICTURE)),AvSx3("EE9_PSLQUN",AV_DECIMAL)) + " Kg/Pc"
      
      // Peso Bruto Total
      DETAIL_P->AVG_C05_20 := DecPoint(Transf(EE9->EE9_PSBRTO,AvSx3("EE9_PSBRTO",AV_PICTURE)),AvSx3("EE9_PSBRTO",AV_DECIMAL)) + " Kg"
      
      //Total Embalagens/Pallet -> Qtde. de Embalagens mais Externas
      DETAIL_P->AVG_C08_20 := DecPoint(LTrim(Transf(nQtdUltEmb,cPict1)))  
      
      // Total Embalagens
      DETAIL_P->AVG_C06_20 := DecPoint(Transf(EE9->EE9_QTDEM1,cPict1))

      // Total Peças / Embalagens
      DETAIL_P->AVG_C07_20 := DecPoint(Transf(EE9->EE9_QE,cPict1))

      // Descricao Produto 
      cMemo := AA100Idioma(EE9->EE9_COD_I) //MSMM(EE9->EE9_DESC,AVSX3("EE9_VM_DES",3))   //GFP - 29/05/2012 - Tratamento de idiomas.   
      DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,1) 
      lCodProd := .t.
      For i := 2 To MlCount(cMemo,TAMDESC,3)
         IF !EMPTY(MemoLine(cMemo,TAMDESC,i))
            UnLockDet()
            AppendDet()
            DETAIL_P->AVG_C01_60 := MemoLine(cMemo,TAMDESC,i)
            If lCodProd
               DETAIL_P->AVG_C01_20 := "(" + AllTrim(EE9->EE9_COD_I) + ")" 
               lCodProd := .f.
            Endif
         ENDIF
         If lCodProd
            UnLockDet()
            AppendDet()
            DETAIL_P->AVG_C01_20 := "(" + AllTrim(EE9->EE9_COD_I) + ")" 
            lCodProd := .f.
         Endif
      Next

      If lCodProd
         UnLockDet()
         AppendDet()
         DETAIL_P->AVG_C01_20 := "(" + AllTrim(EE9->EE9_COD_I) + ")" 
         lCodProd := .f.
      Endif
      
      //Total de Caixas Unitárias
      nTotCaixa += EE9->EE9_QTDEM1

      UnlockDet()       

      AppendDet()     
      UnLockDet()

      EE9->(dbSkip())
   Enddo

   DO WHILE MOD(nLin,NUMLINPAG) <> 0
      APPENDDET()   
   ENDDO 

   nTotPag := nPag

End Sequence

Return NIL

/*
Funcao      : Add
Parametros  : Nenhum.
Retorno     : Nil
Objetivos   : Add de registros no header.
Autor       : Jeferson Barros Jr. 
Data/Hora   : 17/12/03 - 14:01.
Revisao     :
Obs.        :
*/
*------------------*
Static Function Add
*------------------*

Begin Sequence
   dbAppend()

   bAux:=FieldWBlock("AVG_FILIAL",Select())

   IF ValType(bAux) == "B"
      Eval(bAux,xFilial("SY0"))
   Endif

   bAux:=FieldWBlock("AVG_CHAVE",Select())

   IF ValType(bAux) == "B"
      Eval(bAux,EEC->EEC_PREEMB)
   Endif

   bAux:=FieldWBlock("AVG_SEQREL",Select())

   IF ValType(bAux) == "B"
      Eval(bAux,cSeqRel)
   Endif
   
End Sequence

Return NIL         

/*
Funcao      : DecPoint()
Parametros  : cStr,nDec.
Retorno     : String convertida.
Objetivos   : Muda os pontos da casas decimais para virgula e as virgulas p/ pontos 
              Ex. 999,999,999.99 p/ 999.999.999,99.
Autor       : Jeferson Barros Jr.
Data/Hora   : 17/12/03 - 14:02.
Revisao     : 
Obs.        :
*/
*---------------------------------*
Static Function DecPoint(cStr,nDec)
*---------------------------------*
Local cStrIni, cStrFim

Begin Sequence

   nDec := If(nDec = Nil,0,nDec)
   cStr := AllTrim(cStr)

   If nDec > 0 
      cStrFim := Right(cStr,nDec+1)
      cStrFim := StrTran(cStrFim,".",",")
   Else
      cStrFim := ""
   EndIf

   if nDec > 0 
      cStrIni := SubStr(cStr,1,Len(cStr)-(nDec+1))
      cStrIni := StrTran(cStrIni,",",".")  
   Else
      cStrIni := cStr
      cStrIni := StrTran(cStrIni,",",".")  
   Endif

End Sequence

Return AllTrim(cStrIni+cStrFim)


/*
Funcao      : AppendDet
Parametros  : 
Retorno     : 
Objetivos   : Adiciona registros no arquivo de detalhes.
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
*-------------------------*
Static Function AppendDet()
*-------------------------*
Begin Sequence
   nLin := nLin+1
   IF nLin > NUMLINPAG
      nLin := 1
      nPag := nPag+1
   ENDIF
   DETAIL_P->(Add())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSEQREL
   DETAIL_P->AVG_CHAVE  := EEC->EEC_PREEMB //nr. do processo
   DETAIL_P->AVG_CONT   := STRZERO(nPag,6,0)
End Sequence

Return NIL

/*
Funcao      : UnlockDet
Parametros  : 
Retorno     : 
Objetivos   : Desaloca registros no arquivo de detalhes
Autor       : 
Data/Hora   : 
Revisao     : 
Obs.        :
*/
*-------------------------*
Static Function UnlockDet()
*-------------------------*
Begin Sequence
   DETAIL_P->(dbUnlock())
End Sequence

Return NIL

*-----------------------------------------------------------------------------------------------------------------*
*  FIM DO RDMAKE EECPEM54_RDM
*-----------------------------------------------------------------------------------------------------------------*