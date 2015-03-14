#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHCMGP     บ Autor ณ Leandro M Santos   บ Data ณ  27/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relaciona Gestoes com Paises                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCM                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
function HCMGP
private cCadastro	:= "Cadastro de Gestใo" 
private cAlias		:= "XB2"
private nReg		:= Recno()
private aRotina 	:= {	{"Pesquisar","AxPesqui",0,1} ,;
							{"Visualizar","AxVisual",0,2} ,;
							{"Incluir","HCMGPInclui",0,3} ,;
							{"Alterar","HCMGPAltera",0,4} ,;
							{"Excluir","HCMGPDeleta",0,5}		}

dbSelectArea("XB2")    
dbSetOrder(1)
dbgotop()
mBrowse( 6,1,22,75,"XB2")

return           

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณHCMGPInclui บ Autor ณ Leandro M Santos   บ Data ณ  27/06/05      บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ Inclui a Gestao e os relacionamentos com os paises selecionados บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCMGP                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
function HCMGPInclui()
                        
if(AxInclui("XB2")==1)
	HCMGPPaises(recno(), XB2->XB2_CODIGO, "INCLUI")

	if(existblock("HCMGRV02"))
		execblock("HCMGRV02",.F.,.F.,{3,XB2->XB2_DESCR})
	endif

endif
                    
return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณHCMGPAltera บ Autor ณ Leandro M Santos   บ Data ณ  27/06/05      บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ Altera a Gestao e os relacionamentos com os paises selecionados บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCMGP                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
function HCMGPAltera()

if(AxAltera(cAlias,Recno(),3)==1)
	HCMGPPaises(recno(), XB2->XB2_CODIGO, "ALTERA")

	if(existblock("HCMGRV02"))
		execblock("HCMGRV02",.F.,.F.,{4,XB2->XB2_DESCR})
	endif

endif

return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณHCMGPDeleta บ Autor ณ Leandro M Santos   บ Data ณ  27/06/05      บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ Deleta a Gestao e os relacionamentos com os paises selecionados บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCMGP                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
function HCMGPDeleta()                                
local cGestao := XB2->XB2_CODIGO

XBE->(dbsetorder(2))
             
if(AxDeleta(cAlias,Recno(),2)==2)
	if(XBE->(dbseek(xFilial() + cGestao)))
		do while ! XBE->(eof()) .and. XBE->XBE_IDGEST == cGestao
			if(reclock("XBE"))
				dbdelete()
			endif
			XBE->(dbskip())
		enddo
	endif
endif                   

return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณHCMGPPaises บ Autor ณ Leandro M Santos   บ Data ณ  27/06/05      บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ Selecao dos paises para relacionamento com as Gestoes           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCMGP                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
function HCMGPPaises(nRecno, cGestao, cComando)
local aArea := GetArea(), oDlg, oBrwReconc, oCol, oBtnApura, oBtnOk, oBtnVolta, oBtnTodos, oBtnNaoTodos
local xIDBanco, aBrwReconc := {}
local oOk := LoadBitmap( GetResources(), "LBOK" )
local oNo := LoadBitmap( GetResources(), "LBNO" )
local oBtnMTodos, oBtnDTodos
local nBrwLin, nBrwCol

XBE->(dbsetorder(2))

// Monta array com todos os paises da tabela XBD
dbselectarea("XBD")
dbsetorder(1) 
dbgotop()
do while !XBD->(eof())
	
	if(XBD->XBD_CODIGO == "ALL")
		dbskip()
		loop
	endif
   
   aadd(aBrwReconc, {XBD_CODIGO,.F.,XBD_DESC})
   
   if(cComando=="ALTERA")
		if(XBE->(dbseek(xFilial() + cGestao + XBD->XBD_CODIGO)))
			aBrwReconc[len(aBrwReconc), 2] := .T.
		endif
	endif
   
   XBD->(dbSkip())
   
enddo

define MSDialog oDlg Title "Gestใo vs Paํses" From 0,0 To 400,400 Pixel

@nBrwLin:=5,nBrwCol:=5 ListBox oBrwReconc;
Fields;
Header   "", "Pais", "Descricao";
ColSizes 0,;
CalcFieldSize("C", Len(XBD->XBD_CODIGO), 0, "")+10,;
CalcFieldSize("C", Len(XBD->XBD_DESC), 0, "");
Font     Fonte("Arial", 0, -12);
Size     ERPZLstLarg(oDlg, nBrwCol),ERPZLstAlt(oDlg, nBrwLin)-15 Pixel Of oDlg

oBrwReconc:SetArray(aBrwReconc)

oBrwReconc:bLine := {|| {IIf(aBrwReconc[oBrwReconc:nAt,2], oOk, oNo),;
aBrwReconc[oBrwReconc:nAt,1],;
aBrwReconc[oBrwReconc:nAt,3]} }

oBrwReconc:bLDblClick := {|| HCMGPMarca(oBrwReconc, aBrwReconc)}

@oBrwReconc:nBottom/2+3,oBrwReconc:nLeft/2      Button oBtnTodos    Prompt "&Marcar   todos" Size 47,15 Pixel Action HCMTodos(oBrwReconc, aBrwReconc) Message "Marca  todos os itens" Of oDlg
@oBrwReconc:nBottom/2+3,oBrwReconc:nLeft/2+047  Button oBtnNaoTodos Prompt "&Desmarcar todos" Size 47,15 Pixel Action HCMNaoTodos(oBrwReconc, aBrwReconc) Message "Marca todos os itens" Of oDlg
@oBrwReconc:nBottom/2+3,oBrwReconc:nRight/2-060 Button oBtnOk       Prompt "&Ok"           Size 30,15 Pixel Action if(HCMGPGrava(aBrwReconc, cGestao), oDlg:End(), ) Of oDlg
@oBrwReconc:nBottom/2+3,oBrwReconc:nRight/2-030 Button oBtnVolta    Prompt "&Voltar"       Size 30,15 Pixel Action oDlg:End() Cancel Message "Volta ao menu anterior"  Of oDlg

Activate MSDialog oDlg Centered

RestArea(aArea)

return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณHCMGPGrava  บ Autor ณ Leandro M Santos   บ Data ณ  27/06/05      บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ Grava todos os paises selecionados                              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCMGP                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
function HCMGPGrava(aBrwReconc, cGestao)
	Local nI, nRet := .f., aArea := GetArea()
	
	dbselectarea("XBE")
	dbsetorder(2)
	
	for nI := 1 to len(aBrwReconc)

		//Se encontrar verifica se mudou a selecao do pais
		if XBE->(dbseek(xFilial() + cGestao + aBrwReconc[nI, 1]))
			//Se o pais NAO estiver selecionado apaga o registro
			if !aBrwReconc[nI, 2]
				Begin Transaction
					if(RecLock("XBE"))
						dbdelete()
					endif
				End Transaction
			endif
		else                                              
			//Se nao encontrar inclui caso o pais esteja selecionado
			if aBrwReconc[nI, 2]
				Begin Transaction
					if(RecLock("XBE",.t.))
						XBE_FILIAL     := xFilial()
						XBE_IDPAIS     := aBrwReconc[nI, 1]
						XBE_IDGEST     := cGestao
						MsUnLock()
					endif
				End Transaction
			endif
		endif
	next
	
	for nI := 1 to len(aBrwReconc)
		if aBrwReconc[nI, 2]
			nRet := .t.
			exit
		endif
	next
	
	RestArea(aArea)
return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณHCMGPMarca  บ Autor ณ Leandro M Santos   บ Data ณ  27/06/05      บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDescricao ณ Controla os paises selecionados                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCMGP                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
function HCMGPMarca(oBrwReconc, aBrwReconc)

aBrwReconc[oBrwReconc:nAt, 2]:= ! aBrwReconc[oBrwReconc:nAt, 2]

oBrwReconc:Refresh()

Return Nil
