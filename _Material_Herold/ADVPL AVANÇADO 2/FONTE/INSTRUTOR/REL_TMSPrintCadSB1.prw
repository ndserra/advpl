# INCLUDE "PROTHEUS.CH"

USER FUNCTION TMSPRINTER03()

PRIVATE cData := dtoc(Date())
PRIVATE cTime := time()

PRIVATE cTitulo    := "Impressão - Relatório de produtos"
PRIVATE oPrn       := NIL
PRIVATE oArial07   := NIL
PRIVATE oArial09B  := NIL
PRIVATE oArial14B  := NIL
Private nPag       := 0
PRIVATE nLinIni1   := 000, nColIni1:= 000, nLinFim1:= 200, nColFim1:= 100

DEFINE FONT oArial10  NAME "Arial" SIZE 0,10 OF oPrn
DEFINE FONT oArial10B NAME "Arial" SIZE 0,10 OF oPrn BOLD
DEFINE FONT oArial12B NAME "Arial" SIZE 0,12 OF oPrn BOLD
DEFINE FONT oArial20B NAME "Arial" SIZE 0,16 OF oPrn BOLD

oPrn := TMSPrinter():New(cTitulo)
oPrn:SetPortrait()

meucabec()

itens()

oPrn:EndPage()         

oPrn:End()

oPrn:Preview()
oPrn:End()

Return      

STATIC FUNCTION itens()

Local nCont := 0
Local nLin := 300
Local cTipo := " "

BeginSQL Alias "TRB"
   %NoParser%
    
	Select B1_COD, B1_DESC, B1_UM, B1_TIPO from %Table:SB1% B1
	ORDER BY B1_TIPO,B1_UM

EndSQL


TRB->(dbGoTop())//COLOCA-SE O APELIDO ANTES DE QQ COMANDO DE BANCO DE DADOS POR PRECAUCAO
ctipo := TRB->B1_UM
While TRB->(!EOF())// TRB->(<COMANDO>)
		
	If nLin > 2000
		oPrn:EndPage()
		meucabec()
		nLin := 300                                                                         ///
	Endif
	oPrn:Say(nLin,0020,TRB->B1_COD,oArial10)
	oPrn:Say(nLin,0250,TRB->B1_DESC,oArial10)
	oPrn:Say(nLin,1040,TRB->B1_UM,oArial10)
	oPrn:Say(nLin,1240,TRB->B1_TIPO,oArial10)
	nCont := nCont + 1
	nLin := nLin + 50 
		
	TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
	if cTipo <> TRB->B1_UM
		nLin := nLin + 50
		oPrn:Say(nLin,0020,"Total por Unidade : "+cTipo + " - " +cValtochar(nCont),oArial10B,,CLR_RED)
		nCont := 0
		cTipo := TRB->B1_UM
		nLin := nLin + 150
	Endif
Enddo

TRB->(dbCloseArea())

Return

Static function meucabec()
	nPag++
	oPrn:StartPage()
	
	oPrn:SayBitmap(nLinIni1,nColIni1,"FORD.bmp",nLinFim1,nColFim1) 
	oPrn:Say(0020,0600,"RELATÓRIO DO CADASTRO DE PRODUTO",oArial20B)
	oPrn:Say(0100,1040,"DATA:",oArial12B)
	oPrn:Say(0100,1240,cData,oArial12B)
	oPrn:Say(0100,1500,"HORA:",oArial12B)
	oPrn:Say(0100,1700,cTime,oArial12B)
	oPrn:Say(0100,1900,"PAGINA:",oArial12B)
	oPrn:Say(0100,2100,cvaltochar(nPag),oArial12B)
	
	oPrn:Line(0150,0000,0150,3000)
	oPrn:Say(0200,0020,"Cod.Produto",oArial10b)
	oPrn:Say(0200,0250,"Produto",oArial10b)
	oPrn:Say(0200,1040,"Unidade",oArial10b)
	oPrn:Say(0200,1240,"Tipo",oArial10b)
	oPrn:Line(0250,0000,0250,3000)
Return