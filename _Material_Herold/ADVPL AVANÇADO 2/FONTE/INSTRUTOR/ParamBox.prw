#include "Protheus.ch"

User Function ParamBox()

Local aRet 		:= {}
Local aParamBox := {}
Local aCombo 	:= {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Local i			:= 0

Private cCadastro := "xParambox"

AADD(aParamBox,{1,"Produto",Space(15),"","","SB1","",0,.F.})

AADD(aParamBox,{2,"Tipo de cliente",1,aCombo,50,"",.F.})

AADD(aParamBox,{3,"Mostra deletados",IIF(Set(_SET_DELETED),1,2),{"Sim","Não"},50,"",.F.})

AADD(aParamBox,{4,"Marca todos ?",.F.,"Marque todos se necessário FOR",50,"",.F.})

AADD(aParamBox,{5,"Marca todos ?",.F.,50,"",.F.})

AADD(aParamBox,{6,"Qual arquivo",Space(50),"","","",50,.F.,"Arquivo .DBF |*.DBF"})

AADD(aParamBox,{7,"Monte o filtro","SX5","X5_FILIAL==xFilial('SX5')"})

AADD(aParamBox,{8,"Digite a senha",Space(15),"","","","",80,.F.})

If ParamBox(aParamBox,"Teste ParamBox...",@aRet)                   

	For i := 1 To Len(aRet)
		MsgInfo(aRet[i],"Opção escolhida")
	Next
Endif

Return( NIL )