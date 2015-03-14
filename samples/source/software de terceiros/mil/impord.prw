/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³  IMPORD  ³ Autor ³ Andre Luis Almeida    ³ Data ³ 07/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao da Ordem de Servico                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³ Duplicado o IMPOS (Grupo FS), alterado com os campos de VEI³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ImpOrd()

Local cDesc1      := "Impressao da Ordem de Servico" 
Local cDesc2      := ""  
Local cDesc3      := ""  
Local cString     :="VO1"
Local cPerg       :="IMPORD"
Local titulo      := SM0->M0_NOMECOM
Local cabec1      := ""
Local cabec2      := ""
Private wnrel     := "IMPORD" 
Private Tamanho   := "P"     
Private aReturn   := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog  := "IMPORD"
Private nLin      := 80,nLastKey := 0   
Private nTipo     := 18
Private m_pag     := 1
Private cTipPrg   := ""
cTipPrg := If(type("ParamIxb")=="U","IMPORD",ParamIxb[3])
If cTipPrg == "IMPORD"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ          
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao REPORTINI substituir as variaveis.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLastKey == 27
	  Return
	Endif
	SetDefault(aReturn,cString)
	If nLastKey == 27
	  Return
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	If FunName() # "#IMPORD"
		cIndVO1 := CriaTrab(Nil, .F.)
		cChave  := "VO1_FILIAL+VO1_NUMOSV"
		cCond   := "VO1->VO1_STATUS == 'A'"
		IndRegua("VO1",cIndVO1,cChave,,cCond,"" )
		DbSelectArea("VO1")
		nIndVO1 := RetIndex("VO1")
		#IFNDEF TOP
		   dbSetIndex(cIndVO1+ordBagExt())
		#ENDIF
		dbSetOrder(nIndVO1+1)
	EndIf
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o  ³ FA470IMP ³ Autor ³ Wagner Xavier           ³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Banc rio.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)    
Local cObs := ""
Local nValDes := 0
Local aValSer := {}
Local lOk := .f.
Local dData
Local nHora        
Local lVei := .t.
Local lCli := .t.
If Type("aRotina") == "A" // Rotina de impressao da tela de Pedido de Venda
   Mv_Par01 := VO1->VO1_NUMOSV 
   Mv_Par02 := VO1->VO1_NUMOSV
   If SM0->M0_CODIGO == "04"
      Mv_Par03 := 1
   Else            
      Mv_Par03 := 2
   Endif   
Endif   

If MV_PAR03 = 1
   cabec := OemToAnsi("Codigo    Descricao                              |")
Else
   cabec := OemToAnsi("Codigo    Descricao                       UM   Quant.  Vlr. Unit.    Vlr. Total")    
EndIf

_Primeiro := .T.

DbSelectArea("VO1") 
DbSetOrder(1)
DbSeek(xFilial("VO1")+Mv_Par01,.t.)
While !Eof() .And. VO1->VO1_NUMOSV >= Mv_Par01 .and. VO1->VO1_NUMOSV <= Mv_Par02  
   If _Primeiro == .F.
   	Eject
      Setprc(0,0)
   EndIf

   _Primeiro := .F.
   nVias := 1
   While nVias <= Mv_par04   
   
      DbSelectArea("VV1")   
      DbSetOrder(1)
      DbSeek(xFilial("VV1")+VO1->VO1_CHAINT)   

      lVei := .t.
		lCli := .t.
		If left(VV1->VV1_CHASSI,7) == "INTERNO" .and. Empty(VO1->VO1_FATPAR)
			lVei := .f.
			lCli := .f.
		ElseIf left(VV1->VV1_CHASSI,7) == "INTERNO" .and. !Empty(VO1->VO1_FATPAR)
			lVei := .f.
			lCli := .t.
		EndIf	

      DbSelectArea("SA1")
      DbSetOrder(1)
   	If ( Empty(VO1->VO1_FATPAR) .Or. !SA1->( DbSeek( xFilial("SA1")+VO1->VO1_FATPAR+VO1->VO1_LOJA ) ) )
			SA1->( DbSeek( xFilial("SA1")+VV1->VV1_PROATU+VV1->VV1_LJPATU ) )
   	EndIf
          
      DbSelectArea("SA3")
      DbSetOrder(1)
      DbSeek(xFilial("SA3")+VO1->VO1_FUNABE)

      DbSelectArea("VE1")   
      DbSetOrder(1)
      DbSeek(xFilial("VE1")+VV1->VV1_CODMAR)
      
      DbSelectArea("VV2")   
      DbSetOrder(1)
      DbSeek(xFilial("VV2")+VV1->VV1_CODMAR+VV1->VV1_MODVEI)

      Cabec1 := "Ordem de Servico - "+"Emissao: "+TRANS(VO1->VO1_DATABE,"@D")+" "+TRANS(VO1->VO1_HORABE,"@R 99:99")+" hs"

		If VO1->VO1_STATUS == "F"
			lOk := .f.
	      DbSelectArea("VO2")
   	   DbSetOrder(1)
      	If DbSeek(xFilial("VO2")+VO1->VO1_NUMOSV)
      		If VO2->VO2_TIPREQ == "S"
		      	DbSelectArea("VO4")
		   	   DbSetOrder(1)
	   	   	If DbSeek(xFilial("VO4")+VO2->VO2_NOSNUM)
	  	   			dData := VO4->VO4_DATFEC
   	   			nHora := VO4->VO4_HORFEC
	      			lOk := .t.
   	   		EndIf
   	   	Else
		         DbSelectArea("VO3")    
   			 	DbSetOrder(1)
	   		  	If DbSeek(xFilial("VO3")+VO2->VO2_NOSNUM)
		   	   	dData := VO3->VO3_DATFEC
	   	   		nHora := VO3->VO3_HORFEC
	   	   		lOk := .t.
			   	EndIf
				EndIf
      	EndIf
      	If lOk
			   Cabec1 += " - Fim: "+TRANS(dData,"@D")+" "+TRANS(nHora,"@R 99:99")+" hs"
		 	EndIf
		EndIf
      Cabec2 := "Recepcionista: " +SA3->A3_COD+" "+LEFT(ALLTRIM(SA3->A3_NOME),30) 

      If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas... 
          Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)          
          nLin := 9
      Endif 

      @nLin,22 PSAY "ORDEM DE SERVICO: " + VO1->VO1_NUMOSV
  
	   nLin+=2
	   @nLin,00 PSAY "Cliente.: "+If(lCli,LEFT(SA1->A1_COD,6)+" "+LEFT(ALLTRIM(SA1->A1_NOME),31)," ")
      @nLin,49 PSAY "| Placa..: " + If(lVei,TRANS(VV1->VV1_PLAVEI,"@R XXX-9999")," ")
      nLin++
	   @nLin,00 PSAY "Endereco: "  + If(lCli,LEFT(SA1->A1_END,37)," ")
      @nLin,49 PSAY "| Modelo.: " + If(lVei,LEFT(VV2->VV2_DESMOD,15)," ")
   	nLin++
	   @nLin,00 PSAY "Bairro..: "  + If(lCli,LEFT(SA1->A1_BAIRRO,37)," ")
      @nLin,49 PSAY "| Marca..: " + If(lVei,LEFT(VE1->VE1_DESMAR,15)," ")
   	nLin++
	   @nLin,00 PSAY "Cidade..: "  + If(lCli,LEFT(SA1->A1_MUN,37)," ")
      @nLin,49 PSAY "| Chassi.: " + If(lVei,LEFT(ALLTRIM(VV1->VV1_CHASSI),17)," ")
   	nLin++
	   @nLin,00 PSAY "Telefone: "  + If(lCli,LEFT(SA1->A1_TEL,37)," ")
      @nLin,49 PSAY "| Ano....: " + If(lVei,TRANS(VV1->VV1_FABMOD,"@R 9999/9999")," ")
   	nLin++
	   @nLin,00 PSAY "CNPJ/CPF: "  + If(lCli,TRANS(SA1->A1_CGC,"@R 99.999.999/9999-99")," ")
      @nLin,49 PSAY "| Odomet.: " + If(lVei,TRANS(VO1->VO1_KILOME,"@E 99,999,999")," ")
   	nLin++
	   @nLin,00 PSAY "Insc....: "  + If(lCli,LEFT(SA1->A1_INSCR,37)," ")
      @nLin,49 PSAY "| Frota..: " + If(lVei,LEFT(VV1->VV1_CODFRO,15)," ")
   	nLin++
	   @nLin,00 PSAY "Contato.: "  + If(lCli,LEFT(SA1->A1_CONTATO,37)," ")
      @nLin,49 PSAY "| CPF Mot: " + If(lVei,TRANS(VO1->VO1_CPFMOT,"@R 999.999.999-99")," ")
   	nLin++
	   @nLin,49 PSAY "| Motoris: " + If(lVei,LEFT(VO1->VO1_MOTORI,20)," ")
      nLin++
      @nLin,00 PSAY Replicate("-",80)
      nLin++
      If Mv_par03 = 1
         @nLin,14 PSAY "SERVICOS SOLICITADOS"
         @nLin,49 PSAY "|"
         @nLin,56 PSAY "SERVICOS EXECUTADOS"
         nLin++                       
         @nLin,00 PSAY Cabec  
         nLin++                       
         @nLin,00 PSAY Replicate("_",80) 
         nLin++
      Else       
         @nLin,00 PSAY "SERVICOS EXECUTADOS"
         nLin++                       
         @nLin,00 PSAY Cabec 
         nLin++                       
         @nLin,00 PSAY Replicate("-",80)     
         nLin++ 
      Endif          
      nTotal    := 0   
      nDesconto := 0
      DbSelectArea("VO2")
      DbSetOrder(1)
      If DbSeek(xFilial("VO2")+VO1->VO1_NUMOSV+"S")
	      DbSelectArea("VO4")
   	   DbSetOrder(1)
      	DbSeek(xFilial("VO4")+VO2->VO2_NOSNUM)
			While !Eof() .and. VO2->VO2_NOSNUM == VO4->VO4_NOSNUM
				If VO4->VO4_DATCAN == ctod("  /  /  ")
					nValDes := 0
					If	!Empty(VO4->VO4_DATFEC)
				      DbSelectArea("VSC")
			   	   DbSetOrder(1)
			      	DbSeek(xFilial("VSC")+VO1->VO1_NUMOSV+VO4->VO4_TIPTEM+VO4->VO4_CODSER)
						nValDes := VSC->VSC_VALDES
						aValSer := {}
						aValSer := FG_CALVLSER( aValSer , VO4->VO4_TIPTEM+VO4->VO4_TIPSER+VO4->VO4_CODSER , "F" )
					Else
						aValSer := {}
						aValSer := FG_CALVLSER( aValSer , VO4->VO4_TIPTEM+VO4->VO4_TIPSER+VO4->VO4_CODSER , "A" )
					EndIf
		         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   		      //³ Impressao do cabecalho do relatorio. . .                            ³
      		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
	         	    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)          
   	         	 nLin := 9
	      	   Endif  
			      DbSelectArea("VO6")
		   	   DbSetOrder(2)
		      	DbSeek(xFilial("VO6")+FG_MARSRV(VV1->VV1_CODMAR,VO4->VO4_CODSER)+VO4->VO4_CODSER)
	   	      cDescri := VO6->VO6_DESSER
			      DbSelectArea("VOK")
		   	   DbSetOrder(1)
		      	DbSeek(xFilial("VOK")+VO4->VO4_TIPSER)
	         	If Mv_par03 = 1
		             nTamDesc := 35         
      		       @nLin,00 PSAY LEFT(VO4->VO4_CODSER,8)    
         		    @nLin,10 PSAY substr(cDescri,1,nTamDesc) 
            		 @nLin,49 PSAY "|"
            		 If !Empty(alltrim(substr(cDescri,nTamDesc+1,nTamDesc)))
            		 	nlin++
            		 	@ nLin,10 PSAY substr(cDescri,nTamDesc+1,nTamDesc)
	            		@nLin,49 PSAY "|"
            		 EndIf
	         	Else       
		   	       nTamDesc := 28
   		          @nLin,00 PSAY LEFT(VO4->VO4_CODSER,8)    
      		       @nLin,10 PSAY substr(cDescri,1,nTamDesc)
				       DbSelectArea("SB1")
			   	    DbSetOrder(1)
			      	 DbSeek(xFilial("SB1")+VOK->VOK_GRUITE+VOK->VOK_CODITE)
	         	    @nLin,42 PSAY SB1->B1_UM
	         	    nTemPad := aValser[2]
   		          IF !( VOK->VOK_INCMOB == "0" .and. VOK->VOK_TIPHOR == "2" )
	  	            	  @nLin,45 PSAY Transform(nTemPad,"@R 99999:99")
   		              @nLin,55 PSAY TRANS(((aValser[1]+nValDes)/nTemPad),"@E 999,999.99")
      		           @nLin,67 PSAY TRANS(aValser[1]+nValDes,"@E 9,999,999.99")  
         		    ELSE 
            		     @nLin,50 PSAY "***** CORTESIA *****"
		             ENDIF
            		 If !Empty(alltrim(substr(cDescri,nTamDesc+1,70)))
            		 	nlin++
            		 	@ nLin,10 PSAY substr(cDescri,nTamDesc+1,70)
            		 EndIf
   		      EndIf
   		      IF !( VOK->VOK_INCMOB == "0" .and. VOK->VOK_TIPHOR == "2" )
         		    nTotal += aValser[1]+nValDes
         		ENDIF 
      		   nLin++
		         If ( nValDes > 0)
		             @nLin,55 PSAY "DESCONTO: "
		             @nLin,67 PSAY TRANS(nValDes,"@E 9,999,999.99") 
		             nDesconto += nValDes
		             nLin++         
		         EndIf    
					cObs := "Obs.: "
	      	   DbSelectArea("SYP")
			   	DbSetOrder(1)
		         DbSeek( xFilial("SYP") + VO4->VO4_OBSMEM )
	   	      While !Eof() .and. SYP->YP_CHAVE == VO4->VO4_OBSMEM
						cDescri := Alltrim(SYP->YP_TEXTO)
						nTamDesc := AT("\13\10",cDescri)
						If nTamDesc > 0
							nTamDesc-- 
						Else
							nTamDesc := Len(cDescri)
						EndIf
   	   		   @nLin++,00 PSAY cObs+substr(cDescri,1,nTamDesc)
   	   		   cObs := "      "
		            DbSelectArea("SYP")
		            DbSkip()
		         EndDo
		         @nLin,00 PSAY Replicate("-",80)          
		         nLin++
				EndIf
   	      DbSelectArea("VO4")
	         DbSkip()
         End
      EndIf 
      If Mv_par03 = 1
         While nLin < 45
            @nLin,49 PSAY "|"
            nLin++
            @nLin,00 PSAY Replicate("-",80) 
            nLin++
         End  
      Endif   
      nLin++
      @nLin,00 PSAY Replicate("_",80)
      nLin++   
      If SM0->M0_CODIGO == "03"
         @nLin,038 PSAY OemToAnsi("SUB-TOTAL DE PECAS..: ")        
         @nLin,065 PSAY TRANS(nTotal,"@E 999,999,999.99")               
         nLin++                                                          
         @nLin,038 PSAY OemToAnsi("DESCONTOS...........: ")                 
         @nLin,065 PSAY TRANS(nDesconto,"@E 999,999,999.99")               
         nLin++
         @nLin,038 PSAY OemToAnsi("TOTAL DE PECAS......: ")  
      Else             
         If Mv_Par03 = 1                                     
             @nLin,038 PSAY OemToAnsi("TOTAL DE SERVICO....: ")                    
         Else    
             @nLin,038 PSAY OemToAnsi("SUB-TOTAL DE SERVICO: ")        
             @nLin,065 PSAY TRANS(nTotal,"@E 999,999,999.99")               
             nLin++         
             @nLin,038 PSAY OemToAnsi("DESCONTOS...........: ")              
             @nLin,065 PSAY TRANS(nDesconto,"@E 999,999,999.99")                  
             nLin++         
             @nLin,038 PSAY OemToAnsi("TOTAL DE SERVICO....: ")  
         EndIf    
      Endif 
      If Mv_Par03 = 1  
         nLin+=1
         @nLin,00 PSAY "AUTORIZO"   
         nLin ++                 
         @nLin,00 PSAY "A execucao dos servicos constantes desta ordem de servico bem como aplicacoes"
         nLin ++                 
         @nLin,00 PSAY "de pecas e materiais que forem necessarias"  
         nLin +=3 
         @nLin,00 PSAY "________________________________"
         nLin ++
         @nLin,00 PSAY "     ASSINATURA RESPONSAVEL     " +"              CPF/RG:" +TRANS(VO1->VO1_CPFMOT,"@R 999.999.999-99")
      Else   
         @nLin,065 PSAY TRANS(nTotal-nDesconto,"@E 999,999,999.99")      
         nLin+=2
         nLin := 52
         @nLin,00 PSAY "________________________________"   
         @nLin,44 PSAY "________________________________"
         nLin ++
         @nLin,00 PSAY "    ASSINATURA RECEPCIONISTA    "  
         @nLin,44 PSAY "    ASSINATURA ADMINISTRACAO    "      
      Endif       
   	nVias ++
	   nLin :=80      
   End  
   DbSelectArea("VO1")
   DbSkip()
End      
 /*
 ________________________________           ________________________________
 12345678901234567890123456789012345678901234567890123456789012345678901234567890
 */

Set Device To Screen

If aReturn[5] = 1
  Set Printer To
  dbCommit()
  ourspool(wnrel)
Endif
MS_FLUSH()
   
********************************
Static Function ValidPerg(cPerg)
********************************
Local _sAlias := Alias()
Local aRegs := {}
Local i,j
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da OS          ?","","","mv_ch1","C",08,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate OS         ?","","","mv_ch2","C",08,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","OS P/Mecanico  ?","","","mv_ch3","N",01,00,0,"C","","mv_par03","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"04","Quant. Vias    ?","","","mv_ch4","N",03,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
If FunName() # "#IMPORD"
	For i:=1 to 4
	  	If aRegs[i,2] == "01" .or. aRegs[i,2] == "02"
			dbSelectArea("SX1")
			dbSetOrder(1)
	  		dbSeek(cPerg+aRegs[i,2])
   	 	RecLock("SX1",.f.)
    			X1_CNT01 := VO1->VO1_NUMOSV
	    	MsUnlock()
  		Else
			dbSelectArea("SX1")
			dbSetOrder(1)
  			dbSeek(cPerg+aRegs[i,2])
	    	RecLock("SX1",.f.)
   	 		X1_CNT01 := "1"
    		MsUnlock()
	  	EndIf
	Next
EndIf	
dbSelectArea(_sAlias)
Return
