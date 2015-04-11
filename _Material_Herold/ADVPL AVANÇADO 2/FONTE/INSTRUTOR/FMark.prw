#INCLUDE "PROTHEUS.CH" 

User Function FMark() 

Local _astru   := {}
Local _afields := {}     
Local _carq    := ""   
Local lInverte := .F. 

Local cIndTMB := ""   
Local cChavecAlias

Private cCadastro := "MarkBrow SA1 Temporario"


	aRotina   := { { "Marcar Todos"    ,"U_MARCAR"   , 0, 1},;
	               { "Desmarcar Todos" ,"U_DESMAR"   , 0, 2},;
	               { "Inverter Todos"  ,"U_MarTodos" , 0, 3},;
	               { "Deletar Lote"    ,"U_DelLoSa1" , 0, 4}}
	               
// Estrutura da tabela temporaria	               

	AADD(_astru,{"A1_OK"    ,"C",2 ,0 } )
	AADD(_astru,{"A1_FILIAL","C",2 ,0 } )
	AADD(_astru,{"A1_COD"   ,"C",6 ,0 } )
	AADD(_astru,{"A1_LOJA"  ,"C",2 ,0 } )
	AADD(_astru,{"A1_NOME"  ,"C",40,0 } )

// cria a tabela temporária
_carq := "T_" + Criatrab(,.F.)                                         

//Cria um DBF com nome TRB
 MsCreate(_carq, _astru, "DBFCDX" ) 

dbUseArea(.T., "DBFCDX", _cARq, "TRB", .T., .F.) // atribui a tabela temporária ao alias TRB 

cChavecAlias := "A1_COD+A1_LOJA"

IndRegua("TRB",_cARq,cChavecAlias,,,"Criando indice temporario...")

dbselectarea("SA1")

SA1->( dbGotop() )

dbSelectArea("TRB")	

While ! SA1->( EOF() )

	RECLOCK("TRB",.T.) // alimenta a tabela temporária	 		
		
		TRB->A1_FILIAL := SA1->A1_FILIAL		
		TRB->A1_COD    := SA1->A1_COD
		TRB->A1_LOJA   := SA1->A1_LOJA		
		TRB->A1_NOME   := SA1->A1_NOME
//   	TRB->A1_TIPO   := SA1->A1_TIPO

	MSUNLOCK()   

	SA1->( dbSkip() )
	
ENDDO

AADD(_afields,{"A1_OK"    , "", ""       } )
AADD(_afields,{"A1_FILIAL", "", "Filial" } )
AADD(_afields,{"A1_COD"   , "", "Cliente"} )
AADD(_afields,{"A1_LOJA"  , "", "Loja"   } )
AADD(_afields,{"A1_NOME"  , "", "Nome"   } )
//AADD(_afields,{"A1_TIPO"  , "", "Titulo" } )


TRB->( DbGotop() )
SA1->( DbGotop() )                     

TRB->(dbSeek(SA1->A1_COD+SA1->A1_LOJA ))
MsgAlert(TRB->A1_COD+TRB->A1_LOJA ) 

//MarkBrow(cAlias,<campo_marca>,<quem não pode>,<array_camposbrw>,<condição_inicial>,<marca_atual>,,,,,<função_na_marca>)
  MarkBrow( "TRB","A1_OK"      ,               , _afields       ,lInverte           ,GetMark(,"TRB","A1_OK") )

TRB->( DbCloseArea() )        				// fecha a tabela temporária

MsErase( _carq + GetDBExtension(),, "DBFCDX")	// apaga a tabela temporária

Return( NIL )

//********************************************************************************************************************

// Função para marcar todos os registros do browse
User Function Marcar()

Local oMark := GetMarkBrow()    
Local lInvert := ThisInv()
Local  cMark := ThisMark()

DbSelectArea("TRB")
TRB->( DbGotop() )

While !TRB->( Eof() .AND. ! lInvert )	
	IF RecLock( 'TRB', .F. )		
		TRB->A1_OK := cMark
		MsUnLock()	
	EndIf	
	
	TRB->(dbSkip())
	
Enddo       

MarkBRefresh( )      		// atualiza o browse
oMark:oBrowse:Gotop()	// força o posicionamento do browse no primeiro registro

Return( NIL )
//********************************************************************************************************************

// Função para desmarcar todos os registros do browse
User Function DesMar()

Local oMark   := GetMarkBrow()      
Local lInvert := ThisInv()
Local cMark   := ThisMark()

DbSelectArea("TRB")
TRB->( DbGotop())

While ! TRB->(Eof())	

	If RecLock( 'TRB', .F. )		
		TRB->A1_OK := Space(2)
		MsUnLock()	
	EndIf
	
	TRB->(dbSkip())

EndDo

MarkBRefresh()		 // atualiza o browse
oMark:oBrowse:Gotop() // força o posicionamento do browse no primeiro registro

Return( NIL )
//********************************************************************************************************************

// Função para grava marca no campo se não estiver marcado ou limpar a marca se estiver marcado

Static Function ValMarca()       

Local lInvert := ThisInv()
Local cMarca  := ThisMark()

if IsMark( 'A1_OK' )	
	
	RecLock( 'TRB', .F. )	

 		TRB->A1_OK = Space(2)	

	MsUnLock()

Else	

	RecLock( 'TRB', .F. )	

		TRB->A1_OK = cMarca
  
	MsUnLock()
EndIf

Return( NIL ) 
//********************************************************************************************************************
// Função para gravar\limpar marca em todos os registros                                                              

User Function MarTodos()  

Local oMark := GetMarkBrow() 
Local lInvert := ThisInv()
 
dbSelectArea('TRB')

TRB->(dbGotop())

 While ! TRB->(Eof())

 	ValMarca()
 	
	 TRB->( dbSkip() )
	 
 EndDo
 	
MarkBRefresh()		 // atualiza o browse
oMark:oBrowse:Gotop() // força o posicionamento do browse no primeiro registro
 
Return( NIL )    

//********************************************************************************************************************
// Função para Deletar o Lote

User Function DelLoSa1()

Local cMarca  := ThisMark()
Local nX	  := 0
Local lInvert := ThisInv()            
Local aRecDel := {}


dbSelectArea('TRB')

TRB->(dbGotop())

While ! TRB->(Eof())

	IF TRB->A1_OK == cMarca .AND. ! lInvert 
		
		AADD(aRecDel, TRB->( A1_COD ) )
		
	ElseIf TRB->A1_OK != cMarca .AND. lInvert 
	
		AADD(aRecDel, TRB->( A1_COD ) )
		
	EndIf

	TRB->(dbSkip())
	
EndDo


If MsgYesNo( "Deseja excluir os :" +  cValToChar(Len(aRecDel))+ " Clientes Selecionados? ", "ATENÇÃO !!! ")

	If Len(aRecDel) > 0
	
		TRB->( DbGoTop() )
	
     While ! TRB->( EOF() )

			For nX := 1 to Len(aRecDel)
				
				If AllTrim( TRB->( A1_COD ) ) == aRecDel[ nX ]
					RecLock("TRB", .F. )
				
						dbDelete()
					
					MsUnLock()	
				EndIf
			Next nX
			
			TRB->( DbSkip() )
	  EndDo
	  
	EndIf

EndIf

MarkBRefresh( )      		// atualiza o browse
oMark:oBrowse:Gotop()		// força o posicionamento do browse no primeiro registro

Return( NIL )
 
 
 
 
 
 