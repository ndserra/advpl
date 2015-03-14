#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ORDBUSCA  ºAutor  ³Fabio               º Data ³  07/16/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime ordem de busca                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ORDBUSCA() 

SetPrvt("cAlias , cNomRel , cGPerg , cTitulo , cDesc1 , cDesc2 , cDesc3 , aOrdem , lHabil , cTamanho , aReturn , ")
SetPrvt("titulo,cabec1,cabec2,nLastKey,wnrel,tamanho")

Private aVetCampos := {}

cAlias := "VO3"
cNomRel:= "ORDBUSCA"
cGPerg := ""
cTitulo:= "Ordem de Busca"
cDesc1 := "Ordem de Busca"
cDesc2 := cDesc3 := ""
aOrdem := {"Nosso Numero","Codigo do Item"}
lHabil := .f.
lServer := ( GetMv("MV_LSERVER") == "S" )

cTamanho:= "P"
nLastKey:=0

aDriver := LeDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

cDrive  := GetMv("MV_DRVORB")
cPorta  := GetMv("MV_PORORB")
aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 3, cPorta, "",1 }  //"Zebrado"###"Administracao"

//cNomRel := SetPrint(cAlias,cNomRel,nil,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,cTamanho,nil,nil,nil,cDrive,.T.,lServer,cNomeImp)


If nlastkey == 27
   Return(Allwaystrue())
EndIf

SetDefault(aReturn,cAlias)

RptStatus({|lEnd| FS_IMPORDBUSC(@lEnd,"OFIM020",'VO3')},Titulo)

If GetNewPar("MV_ORDBUST",80) == 80
	Eject
EndIf

Set Printer to
Set device to Screen
If aReturn[5] == 1
   OurSpool( cNomRel )
EndIf
MS_FLUSH()

Return(Allwaystrue())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS_IMPORDBºAutor  ³Fabio               º Data ³  07/07/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime relatorio de ordem de busca para pecas requisitadas.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Oficina                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_IMPORDBUSC()

Local i := 0 

SetPrvt("nLin , i , nTotal ")
SetPrvt("cbTxt , cbCont , cString , Li , m_Pag , wnRel , cTitulo , cabec1 , cabec2 , nomeprog , tamanho , nCaracter ")

&& Cria Arquivo de Trabalho - LISTAGEM
aadd(aVetCampos,{ "TRB_TIPTEM" , "C" , 4 , 0 })  && TIPO DE TEMPO
aadd(aVetCampos,{ "TRB_CODITE" , "C" ,48 , 0 })  && GRUPO+CODITE+DESCR
aadd(aVetCampos,{ "TRB_LOCPAD" , "C" , 2 , 0 })  && LOCACAO
aadd(aVetCampos,{ "TRB_LOCALI" , "C" ,15 , 0 })  && LOCALIZACAO
aadd(aVetCampos,{ "TRB_QTDREQ" , "N" , 8 , 2 })  && REQUISITADA
aadd(aVetCampos,{ "TRB_VALPEC" , "N" ,12 , 2 })  && VALOR DE PECA
aadd(aVetCampos,{ "TRB_VALTOT" , "N" ,12 , 2 })  && VALOR TOTAL
aadd(aVetCampos,{ "TRB_PROREQ" , "C",  6 , 0 })  && REQUISITANTE
aadd(aVetCampos,{ "TRB_QTDDIS" , "N",  8 , 2 })  && QTD. DISPONIVEL
aadd(aVetCampos,{ "TRB_CHAINT" , "C",  6 , 0 })  && CHASSI INTERNO

cArqTra := CriaTrab(aVetCampos, .T.)
DbUseArea( .T.,, cArqTra, "TRB", Nil, .F. )

DbSelectArea("TRB")
cArqInd1 := CriaTrab(NIL, .F.)
cChave := "TRB->TRB_LOCALI+left(TRB->TRB_CODITE,32)"
IndRegua("TRB",cArqInd1,cChave,,,OemToAnsi("Selecionando Registro") )

nCaracter := 0 
nLin := 1 
nTotal := 0

Set Printer to &cNomRel
Set Printer On
Set device to Printer

cbTxt    := Space(10)
cbCont   := 0
cString  := "VO3"
Li       := 80
m_Pag    := 1
wnRel    := "OFIM020"
nomeprog := "ORDBUSCA"
tamanho  := "P"
nCaracter:= 18
limite   := 80
nTotal   := 0

AA1->(dbsetorder(1))
AA1->(dbgotop())
AA1->(dbseek(xFilial("AA1")+M->VO2_FUNREQ))
cNomreq := AA1->AA1_NOMTEC
cPlaca  := ""
DbSelectArea("VV1")
DbSetOrder(2)
If DbSeek( xFilial("VV1") + VO1->VO1_CHASSI )
	cPlaca := Transform(VV1->VV1_PLAVEI,"@R !!!-9999")
EndIf
If GetNewPar("MV_ORDBUST",80) == 80
	cTitulo:= "OS:"+M->VO2_NUMOSV+" Rq:"+M->VO2_NOSNUM+" At:"+left(cNOMREQ,10)
	cabec1 := "Cliente:"+M->VO2_PROVEI+"-"+left(M->VO2_NOMPRO,15)+Space(01)+"Chassi:"+left(VV1->VV1_CHASSI,20)+Space(1)+"Frota:"+M->VO2_CODFRO+If(cReqDev=="1"," Requisic"," Devoluc")
	cabec2 := "Placa: "+cPlaca
	ccabx  := "    Sq Tp Codigo                           Descricao        Locacao   QtDisp  Qt.Req        Vl.Unit       Vl.Total Mecan. Tipo" 
Else
	cTitulo:= "OS:"+M->VO2_NUMOSV+" Rq:"+M->VO2_NOSNUM+" At:"+left(cNOMREQ,10)+If(cReqDev=="1","  Requisic","  Devoluc")
	cabec1 := left("Cliente:"+M->VO2_PROVEI+"-"+left(M->VO2_NOMPRO,20),48)
	cabec2 := "Placa: "+cPlaca
	ccabx  := "Codigo                     TTpo  Qt.Req Locacao"
EndIf

For i:=1 to Len(aCols)

   If !( aCols[i,Len(aCols[i])] )

      DbSelectArea("SB1")
      DbSetOrder(7)
      DbSeek( xFilial("SB1") + aCols[i,FG_POSVAR("VO3_GRUITE")] + aCols[i,FG_POSVAR("VO3_CODITE")] )

      DbSelectArea("SB5")
      DbSetOrder(1)
      DbSeek( xFilial("SB5") + SB1->B1_COD )
    
      DbSelectArea("SB2")
      DbSetOrder(1)
      DbSeek( xFilial("SB2") + SB1->B1_COD + "01")

      RecLock("TRB",.t.)  
      TRB->TRB_TIPTEM := aCols[i,FG_POSVAR("VO3_TIPTEM")]
      TRB->TRB_CODITE := aCols[i,FG_POSVAR("VO3_GRUITE")]+" "+aCols[i,FG_POSVAR("VO3_CODITE")]+" "+Substr( aCols[i,FG_POSVAR("VO3_DESITE")],1,15) //55
      TRB->TRB_LOCPAD := SB1->B1_LOCPAD 
      If FunName() == "#M_AREQPEC"      
	      TRB->TRB_LOCALI := SB5->B5_LOC2
	   Else   
	      TRB->TRB_LOCALI := SB5->B5_LOCALIZ
	   Endif   
      TRB->TRB_QTDREQ := aCols[i,FG_POSVAR("VO3_QTDREQ")]
      TRB->TRB_VALPEC := aCols[i,FG_POSVAR("VO3_VALPEC")]
      TRB->TRB_VALTOT := aCols[i,FG_POSVAR("VO3_QTDREQ")]*aCols[i,FG_POSVAR("VO3_VALPEC")]
      TRB->TRB_PROREQ := aCols[i,FG_POSVAR("VO3_PROREQ")]
      TRB->TRB_QTDDIS := SB2->B2_QATU
      TRB->TRB_CHAINT := VO1->VO1_CHAINT 
      MsunLock()

      nTotal := nTotal + (aCols[i,FG_POSVAR("VO3_QTDREQ")]*aCols[i,FG_POSVAR("VO3_VALPEC")])
    
   EndIf
  
Next

dbselectarea("TRB")
dbgotop()
SetRegua(reccount())

setprc(0,0)
If GetNewPar("MV_ORDBUST",80) == 80
	nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1
	i:= 1
	@ nLin++,0 PSAY &cCompac + ccabx + &cNormal     
	do while !eof()
	   if nLin > 60
      	eject
   	   setprc(0,0)
	      nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1
   	   @ nLin++,0 PSAY &cCompac + ccabx + &cNormal     
	   endif
   	If FS_GARANTIA( TRB->TRB_CHAINT , TRB->TRB_TIPTEM , substr(TRB->TRB_CODITE,1,4) , substr(TRB->TRB_CODITE,5,27) , dDataBase )
	      @ nLin++,0 PSAY &cCompac +"(*) "+StrZero(i,2)+"  "+TRB->TRB_TIPTEM+" "+TRB->TRB_CODITE+"  "+left(TRB->TRB_LOCALIZ,8)+transform(TRB->TRB_QTDDIS,"@E 99999.99")+Transform(TRB->TRB_QTDREQ,"@E 99999.99")+" "+Transform(TRB->TRB_VALPEC,"@E 999,999,999.99")+" "+Transform(TRB->TRB_QTDREQ*TRB->TRB_VALPEC,"@E 999,999,999.99")+" "+TRB->TRB_PROREQ+If(cReqDev=="1"," Requisicao"," Devolucao")+&cNormal
   	Else
	      @ nLin++,0 PSAY &cCompac +"    "+StrZero(i,2)+"  "+TRB->TRB_TIPTEM+" "+TRB->TRB_CODITE+"  "+left(TRB->TRB_LOCALIZ,8)+transform(TRB->TRB_QTDDIS,"@E 99999.99")+Transform(TRB->TRB_QTDREQ,"@E 99999.99")+" "+Transform(TRB->TRB_VALPEC,"@E 999,999,999.99")+" "+Transform(TRB->TRB_QTDREQ*TRB->TRB_VALPEC,"@E 999,999,999.99")+" "+TRB->TRB_PROREQ+If(cReqDev=="1"," Requisicao"," Devolucao")+&cNormal
   	Endif
	   IncRegua()
	   dbselectarea("TRB")
	   dbskip()
	   i++
	enddo
	if nLin > 60
	   eject
	   setprc(0,0)
	   nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1
	   @ nLin++,0 PSAY &cCompac + ccabx + &cNormal     
	endif
	@ nLin++,109 PSAY &cCompac + Repl("_",15)+ &cNormal
	if nLin > 60
	   eject
	   setprc(0,0)
	   nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1
	   @ nLin++,0 PSAY &cCompac + ccabx + &cNormal     
	Endif
	@ nLin++,50  PSAY &cCompac + "Total Geral..:" + Transform(nTotal,"999,999,999.99") + &cNormal
	nLin := nLin + 3
	if nLin > 60
	   eject
	   setprc(0,0)
   	nLin := cabec(ctitulo,cabec1,cabec2,nomeprog,tamanho,nCaracter) + 1
   	@ nLin++,0 PSAY &cCompac + ccabx + &cNormal     
	Endif
	@ nLin++,0 PSAY &cCompac + Repl("_",32)+Space(18)+Repl("_",32)+ &cNormal  
	@ nLin,0 PSAY &cCompac + "          Atendente             "+Space(18)+"          Mecanico   "+ &cNormal
Else
	@ nLin++,0 PSAY CHR(15)+" "
	nLin++
	@ nLin++,0 PSAY cTitulo
	@ nLin++,0 PSAY cabec1
	@ nLin++,0 PSAY cabec2
	nLin++
	@ nLin++,0 PSAY ccabx
	do while !eof()
	   @ nLin++,0 PSAY left(TRB->TRB_CODITE,31)+Transform(TRB->TRB_QTDREQ,"@E 99999.99")+" "+left(TRB->TRB_LOCALIZ,8)
		@ nLin++,4 PSAY substr(TRB->TRB_CODITE,33,15)+space(8)+TRB->TRB_TIPTEM
	   dbselectarea("TRB")
	   dbskip()
	enddo
	nLin += 2
	@ nLin++,0 PSAY "____________________        ____________________"  
	@ nLin++,0 PSAY "     Atendente                    Mecanico      "
	nLin += val(substr(str(GetNewPar("MV_ORDBUST",4010),4),3,2))
	@ nLin++,0 PSAY " "
EndIf

TRB->(DBCLOSEAREA())

#IFNDEF TOP
	If File(cArqTra+OrdBagExt())
		fErase(cArqTra+OrdBagExt())
	Endif
#ENDIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  FG_POSVAR    ³ Autor ³ Andre/Emilton    ³ Data ³ 05/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  Retorna a posicao do campo no aHeader                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  Nome do Campo                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³  Posicao do Campo                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³  Geral                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FG_POSVAR(Arg1,Arg2)

If Arg2 == Nil
   Arg2 := "aHeader"
Endif

Return (aScan(&Arg2,{|x| AllTrim(x[2])==Arg1}))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARANTIA  ºAutor  ³Fabio               º Data ³  03/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica garantia                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_GARANTIA( cChaInt , cTipTem , cGruIte , cCodIte , dDataGar , nKmGar , lTela )
                            
Local nVar := 0 , dDataPesq := Ctod("  /  /  ") , nKmReq := 0
Local aArea := {} , aVetGar := {} , lRetorno := .f. , cVerificacao := ""
Local bTitulo   := {|cCampo| If( SX3->( DbSeek( cCampo ) ) , X3Titulo() , "" )  }
Local bConteudo := {|x,cCampo| Ascan( aVetGar[x] , cCampo )  }
local lAchou := .f.
Default cGruIte := ""
Default cCodIte := ""
Default dDataGar := Ctod("  /  /  ")
Default nKmGar := 0
Default lTela := .t.

&& Salva posicoes do arquivo
aArea := sGetArea(aArea,Alias())
aArea := sGetArea(aArea,"VV1")
aArea := sGetArea(aArea,"VO5")
aArea := sGetArea(aArea,"VV2")
aArea := sGetArea(aArea,"VE4")
aArea := sGetArea(aArea,"VVL")
aArea := sGetArea(aArea,"VEC")
aArea := sGetArea(aArea,"SBM")
aArea := sGetArea(aArea,"VO1")
aArea := sGetArea(aArea,"VOI")
aArea := sGetArea(aArea,"VSC")
aArea := sGetArea(aArea,"VOU")
aArea := sGetArea(aArea,"VOP")
                     
Aadd( aVetGar , {} )  && Cabecalho do veiculo
Aadd( aVetGar , {} )  && Conteudo do veiculo
Aadd( aVetGar , {} )  && Cabecalho do list box
Aadd( aVetGar , {} )  && Conteudo do list box

&& Verifica a garantia do veiculo                         

Aadd( aVetGar[2] , {} )

DbSelectArea("VV1")
DbSetOrder(1)
DbSeek( xFilial("VV1") + cChaInt )

For nVar := 1 to FCount()
  	Aadd( aVetGar[1] , FieldName( nVar ) )
Next	

For nVar := 1 to FCount()
  	Aadd( aVetGar[2,Len(aVetGar[2])] , FieldGet(nVar) )
Next	

DbSelectArea("VO5")
DbSetOrder(1)
DbSeek( xFilial("VO5") + cChaInt )

For nVar := 1 to FCount()
  	Aadd( aVetGar[1] , FieldName( nVar ) )
Next	

For nVar := 1 to FCount()
  	Aadd( aVetGar[2,Len(aVetGar[2])] , FieldGet(nVar) )
Next	

DbSelectArea("VV2")
DbSetOrder(1)
DbSeek( xFilial("VV2") + VV1->VV1_CODMAR + VV1->VV1_MODVEI + VV1->VV1_SEGMOD )

DbSelectArea("VE4")
DbSetOrder(1)
DbSeek( xFilial("VE4") + VV1->VV1_CODMAR )

If VE4->VE4_VDAREV == "1"   			&& 1 - Data da venda do veiculo
                           
	dDataPesq := VO5->VO5_DATVEN

ElseIf VE4->VE4_VDAREV == "2"   	&& 2 - Data da primeira revisao do veiculo

	dDataPesq := VO5->VO5_PRIREV

Else			 						      && 3 - Data da entrega do veiculo
	
	dDataPesq := VO5->VO5_DATSAI

EndIf

DbSelectArea("VVL")
DbSetOrder(1)
If !DbSeek( xFilial("VVL") + VV1->VV1_CODMAR + VV1->VV1_MODVEI + VV1->VV1_SEGMOD + Dtos( dDataPesq ) , .t. ) ;
   .And. ( VVL->VVL_FILIAL+VVL->VVL_CODMAR+VVL->VVL_MODVEI+VVL->VVL_SEGMOD # xFilial("VVL") + VV1->VV1_CODMAR + VV1->VV1_MODVEI + VV1->VV1_SEGMOD .Or. VVL->VVL_DATGAR > dDataPesq )
       
	DbSkip(-1)
	
EndIf	
                   
&& Valida garantia por data
If VVL->VVL_FILIAL+VVL->VVL_CODMAR+VVL->VVL_MODVEI+VVL->VVL_SEGMOD == xFilial("VVL") + VV1->VV1_CODMAR + VV1->VV1_MODVEI + VV1->VV1_SEGMOD

	If !Empty( dDataGar )
	
		If ( dDataPesq + VVL->VVL_PERGAR ) >= dDataGar
		     
			lRetorno := .t.
		
		EndIf
	
	EndIf
	
	&& Valida garantia por kilometro
	If !Empty( nKmGar )
	
		If VVL->VVL_KILGAR >= nKmGar
		     
			lRetorno := .t.
		
		EndIf
	
	EndIf
	
EndIf

&& Verifica a garantia da peca ou da venda balcao

DbSelectArea("VEC")
					
For nVar := 1 to FCount()
  	Aadd( aVetGar[3] , FieldName( nVar ) )
Next	
										
Aadd( aVetGar[3] , "VSC_KILROD" )   && Armazenara o kilometro da aplicacao do item VSC

DbSelectArea("SBM")
DbSetOrder(1)
DbSeek( xFilial("SBM") + cGruIte )

DbSelectArea("VE4")
DbSetOrder(1)
DbSeek( xFilial("VE4") + SBM->BM_CODMAR )

DbSelectArea("VO1")
DbSetOrder(4)
DbSeek( xFilial("VO1") + cChaInt + "F" )

Do While !Eof() .And. VO1->VO1_CHAINT + VO1->VO1_STATUS == cChaInt + "F" .And. VO1->VO1_FILIAL == xFilial("VO1")

	&& Valida garantia por data
	If !Empty( dDataGar )
		
		DbSelectArea("VEC")
		DbSetOrder(5)
		DbSeek( xFilial("VEC") + VO1->VO1_NUMOSV )
	
		Do While !Eof() .And. VEC->VEC_NUMOSV == VO1->VO1_NUMOSV .And. VEC->VEC_FILIAL == xFilial("VEC")
	
			lCondicao := (Alltrim(VEC->VEC_GRUITE) == alltrim(cGruIte) .And. alltrim(VEC->VEC_CODITE) == alltrim(cCodIte))

			If lCondicao

				DbSelectArea("VOI")
				DbSetOrder(1)
				DbSeek( xFilial("VOI") + VEC->VEC_TIPTEM )

				If VEC->VEC_BALOFI == "O"  && Verifica garantia de peca
						
					If !Empty( dDataGar ) //renata
						If  VEC->VEC_DATVEN + VE4->VE4_PERPEC >= dDataGar							     		     
 							dDataPesq := VEC->VEC_DATVEN
							aVetGar[4] := {}
 				         lAchou := .t.							
						EndIf
					EndIf

					&& Valida garantia por kilometro
					DbSelectArea("VSC")
					DbSetOrder(1)
					If DbSeek( xFilial("VSC") + VO1->VO1_NUMOSV )
						nKmReq := VSC->VSC_KILROD
				   EndIf     
            
				   && Adiciona no vetor
					DbSelectArea("VEC")
			   	Aadd( aVetGar[4] , {} )
				   For nVar := 1 to FCount()
				   	Aadd( aVetGar[4,Len(aVetGar[4])] , FieldGet(nVar) )
				   Next	

			   	Aadd( aVetGar[4,Len(aVetGar[4])] , VSC->VSC_KILROD )
					
            ElseIf VEC->VEC_BALOFI == "B"  && Verifica garantia de peca balcao

					&& Salva a data da aplicadacao da peca balcao nao garantia
					If VOI->VOI_SITTPO # "2" .Or. Empty(dDataPesq) .Or. ( dDataPesq + VE4->VE4_PERBAL ) < VEC->VEC_DATVEN
					     
						dDataPesq := VEC->VEC_DATVEN    
						aVetGar[4] := {}
							
					EndIf
            
				   && Adiciona no vetor
					DbSelectArea("VEC")
					
			   	Aadd( aVetGar[4] , {} )
				   For nVar := 1 to FCount()
				   	Aadd( aVetGar[4,Len(aVetGar[4])] , FieldGet(nVar) )
				   Next	

			   	Aadd( aVetGar[4,Len(aVetGar[4])] , 0 )

            EndIf  
            
            cVerificacao := VEC->VEC_BALOFI
                                                                      
			EndIf
	
			DbSelectArea("VEC")
			DbSkip()
	
		EndDo

	EndIf

	DbSelectArea("VO1")		
	DbSkip()

EndDo

If cVerificacao == "O"  && Verifica garantia de peca

	&& Valida garantia por kilometro
	If !Empty( nKmGar )
		If ( nKmReq + VE4->VE4_KILPEC ) >= nKmGar
			lRetorno := .t.
		EndIf
	EndIf

ElseIf cVerificacao == "B"             && Verifica garantia de peca BALCAO
		
	&& Valida garantia por data
	If !Empty( dDataGar )

		If ( dDataPesq + VE4->VE4_PERBAL ) >= dDataGar
		     
			lRetorno := .t.
		
		EndIf
	
	EndIf

EndIf	

DbSelectArea("VOI")
DbSetOrder(1)
DbSeek( xFilial("VOI") + cTipTem )

If VOI->VOI_SITTPO # "2"	     && Se o tipo de tempo nao for de garantia e a peca esta na garantia mostra historico da peca

	If lTela .And. lRetorno
	
		If Len(aVetGar[4]) == 0

	   	Aadd( aVetGar[4] , {} )
		   For nVar := 1 to Len( aVetGar[3] )
		   	Aadd( aVetGar[4,Len(aVetGar[4])] , CriaVar(aVetGar[3,nVar]) )
		   Next	
		
		EndIf
	        
	    lAchou := .t.
   EndIf

	lRetorno := .t.

Else

	&& Verifica campanha
	DbSelectArea("VOU")
	DbSetOrder(2)
	DbSeek( xFilial("VOU") + VV1->VV1_CHASSI )
	Do While !Eof() .And. VOU->VOU_FILIAL + VOU->VOU_CHASSI == xFilial("VOU")+VV1->VV1_CHASSI
	           
		DbSelectArea("VOP")
		DbSetOrder(1)
		If DbSeek( xFilial("VOP") + VOU->VOU_NUMINT ) ;
			.And. ( Empty(VOP->VOP_DATCAM) .Or. dDataGar >= VOP->VOP_DATCAM ) ;
			.And. ( Empty(VOP->VOP_DATVEN) .Or. dDataGar <= VOP->VOP_DATVEN )
	
			lRetorno := .t.
			Exit
	
		EndIf
	     
		DbSelectArea("VOU")
		DbSkip()
	
	EndDo

EndIf      

If !VO1->( Found() ) .Or. !VEC->( Found() )
     
	lRetorno := .t.

EndIf

&& Volta posicoes originais
sRestArea(aArea)

If !lRetorno .And. lTela

	Help("   ",1,"VGARNEXIST" )

EndIf
	
Return( lAchou )
