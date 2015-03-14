User Function APD80B01()

Return {"S4WB005N",{||U_APDFIMAVA()},"Encerramento","Encerramento"}

User Function APDFimAva()
Local oAgenda	:= aFolders[2][3][1][20]

If !MsgNoYes("Confirma o encerramento da Avaliação: "+oAgenda:Acols[oAgenda:nAt][2]+Chr(13)+chr(10)+" Agenda: "+dToc(oAgenda:Acols[oAgenda:nAt][3])+ " a "+dToC(oAgenda:Acols[oAgenda:nAt][4]))
   Return NIL
EndIf   
MsAguarde( { || APDProcAva(oAgenda)} )

Return nil


Function APDProcAva(oAgenda)
Local aArea		:= GetArea()
Local cIndexKey	:= "RDC_FILIAL+RDC_CODAVA+RDC_CODADO+RDC_CODPRO+RDC_CODDOR+DTOS(RDC_DTIAVA)+RDC_CODNET+RDC_NIVEL+RDC_TIPOAV"
Local nRdcOrder	:= RetOrdem( "RDC" , cIndexKey )
Local cIndexRDB	:= "RDB_FILIAL+RDB_CODAVA+RDB_CODADO+RDB_CODPRO+RDB_CODDOR+DTOS(RDB_DTIAVA)+RDB_CODCOM+RDB_ITECOM+RDB_CODQUE+RDB_TIPOAV"
Local nRDBOrder	:= RetOrdem( "RDC" , cIndexRDB )
Local cSeekRDC	:= xFilial("RDC")+oAgenda:Acols[oAgenda:nAt][2] 	//Codigo da Avaliacao
Local dDatIni	:= oAgenda:Acols[oAgenda:nAt][3]					// Data Inicio da Agenda
Local dDatFim	:= oAgenda:Acols[oAgenda:nAt][4]					// Data Final da Agenda
Local nX		:= 0
Local aLogTit	:= {}
Local aLog		:= {}
Local cStatus	:= ""
Local cCan		:= ""

//Posicionar na pesquisa para pegar descrição
RD6->(dbSetOrder(1))
RD6->(dbSeek(cSeekRDC, .F.))

RDC->(dbSeek(cSeekRDC, .F.))
//SetRegua(RDA->(RecCount()))
cCab:= "Log de Encerramento de avaliação da Avaliacao    :"+RDC->RDC_CODAVA+" "+ RD6->RD6_DESC+" Agenda :"+dToc(dDatIni)+ " a "+dToc(dDatfim)
aAdd(aLogTit , "Avaliado                              Avaliador                             Status")

cCodAdo		:=RDC->RDC_CODADO
aStatusAva	:={}
aadd(aStatusAva,{"1","N",0}) 
aadd(aStatusAva,{"2","N",0}) 
aadd(aStatusAva,{"3","N",0}) 
//-- Inicializa regua de processamento
//SetRegua(RDC->(RecCount()))

While !RDC->(Eof()) .AND.cSeekRDC==RDC->RDC_FILIAL+RDC->RDC_CODAVA
	//-- Incrementa regua de processamento
	//IncRegua()

    If RDC->RDC_DTIAVA==dDatIni.AND.cCodAdo==RDC->RDC_CODADO
		nPos				:= aScan( aStatusAva , { |x| x[1] == RDC->RDC_TIPOAV} )
		aStatusAva[nPos,2]	:= If(Empty(RDC->RDC_DATRET),"N","S")
		aStatusAva[nPos,3]	:= RDC->(RECNO())
    Else
        nReg	:=RDC->(RECNO())
		If ( aStatusAva[1,2]="N".AND.aStatusAva[2,2]="S".AND.aStatusAva[3,2]="N").OR.;
		   ( aStatusAva[1,2]="S".AND.aStatusAva[2,2]="S".AND.aStatusAva[3,2]="N")
	        cStatus:="4" //Não finalizado pelo avaliador - Para os casos em que tenha sido feito somente a auto-avaliação, sendo:
		ElseIf aStatusAva[1,2]="S".AND.aStatusAva[2,2]="N".AND.aStatusAva[3,2]="N"
	        cStatus:="5" //Não finalizado pelo avaliado - Para os casos em que o avaliado nao fez a sua avaliação 
		ElseIf aStatusAva[1,2]="N".AND.aStatusAva[2,2]="N".AND.aStatusAva[3,2]="N"
	        cStatus:="6" //Não iniciado - Para os casos em que o avaliado nao fez a sua avaliação 
	    EndIf
        If !Empty(cStatus)
	        For nX:=1 to 3
	           If aStatusAva[nX,3]=0
	              Loop
	           EndIf   
	           RDC->(dbgoto(aStatusAva[nX,3]))
	           RDC->( RecLock( "RDC" , .F. ) )
               If nX==3
					// Incluir as questoes para a avaliação de consenso
					RD8->(dbSetOrder(1))
					RD8->(dbSeek(xFilial("RD8")+RD6->RD6_CODMOD, .F.))
					While !RD8->(Eof()).AND.RD8->RD8_CODMOD==RD6->RD6_CODMOD
						RDB->(dbSetOrder(nRDBOrder))
                        //Incluir a questão casao Tenha
						If !(RDB->(dbSeek(xFilial("RDB")+RDC->RDC_CODAVA+RDC->RDC_CODADO+RDC->RDC_CODPRO+RDC->RDC_CODDOR+DTOS(RDC->RDC_DTIAVA)+RD8->RD8_CODCOM+RD8->RD8_ITECOM+RD8->RD8_CODQUE+RDC->RDC_TIPOAV, .F.)))
				            RDB->(RecLock( "RDB",.T.))
							RDB->RDB_FILIAL		:= xFilial("RDB")
							RDB->RDB_CODAVA		:=RDC->RDC_CODAVA
							RDB->RDB_CODADO		:=RDC->RDC_CODADO
							RDB->RDB_CODPRO		:=RDC->RDC_CODPRO
							RDB->RDB_CODDOR		:=RDC->RDC_CODDOR
							RDB->RDB_TIPOAV		:=RDC->RDC_TIPOAV
							RDB->RDB_DTIAVA		:=RDC->RDC_DTIAVA
							RDB->RDB_DTFAVA		:=RDC->RDC_DTFAVA
							RDB->RDB_CODMOD		:=RD8->RD8_CODMOD
							RDB->RDB_CODCOM		:=RD8->RD8_CODCOM
							RDB->RDB_ITECOM		:=RD8->RD8_ITECOM
							RDB->RDB_CODNET		:=RDC->RDC_CODNET
							RDB->RDB_CODQUE		:=RD8->RD8_CODQUE
							RDB->RDB_ESCALA		:=RD8->RD8_ESCALA
							RDB->RDB_ID			:=RDC->RDC_ID
						    RDB->(MsUnLock())
				        EndIf
				        RD8->(dbSkip())
					End
			       RDC->RDC_TIPO:=cStatus
			       If Empty(RDC->RDC_DATRET)
		              RDC->RDC_DATRET:=dDataBase
		           EndIf
				   RDC->( MsUnLock() )
				   //Posicionar na pesquisa para pegar descrição
				   RD0->(dbSetOrder(1))
				   RD0->(dbSeek(xFilial("RD0")+RDC->RDC_CODADO, .F.))
				   cAdo:=RD0->RD0_NOME
				   RD0->(dbSeek(xFilial("RD0")+RDC->RDC_CODDOR, .F.))
				   cDor:=RD0->RD0_NOME
				   If cStatus=="4"
			    		aAdd(aLog , RDC->RDC_CODADO+" "+cAdo+" "+RDC->RDC_CODDOR+" "+cDor+" "+"Não finalizado pelo avaliador")
	        	   ElseIf cStatus=="5"
				     	aAdd(aLog , RDC->RDC_CODADO+" "+cAdo+" "+RDC->RDC_CODDOR+" "+cDor+" "+"Não finalizado pelo avaliado")
			       ElseIf cStatus=="6"
				     	aAdd(aLog , RDC->RDC_CODADO+" "+cAdo+" "+RDC->RDC_CODDOR+" "+cDor+" "+"Não Iniciado")
		           EndIf
		       Else
			        If Empty(RDC->RDC_DATRET)
						//Casa o avaliador não tenha preenchido a avaliação deletar
						RDA->(dbSetOrder(1))
						If RDA->(dbSeek(xFilial("RDA")+RDC->RDC_CODAVA+RDC->RDC_CODADO+RDC->RDC_CODPRO+RDC->RDC_CODDOR+DTOS(RDC->RDC_DTIAVA)+RDC->RDC_CODNET+RDC->RDC_NIVEL+RDC->RDC_TIPOAV,.F.))
				        	RDA->(RecLock("RDA" ,.F.))
		 		        	RDA->(dbDelete())
		                	RDA->(MsUnLock())
					    EndIf
		 		        RDC->(dbDelete())
			        EndIf
		       EndIf
	        Next nX
	    EndIf
        RDC->(dbgoto(nReg))
	    cCodAdo		:=RDC->RDC_CODADO
		aStatusAva	:={}
		cStatus		:=""
		aadd(aStatusAva,{"1","N",0}) 
		aadd(aStatusAva,{"2","N",0}) 
		aadd(aStatusAva,{"3","N",0}) 
	    Loop
	EndIf
	RDC->(dbSkip())
End
MsAguarde( { || fMakeLog( { aLog } , aLogTit , NIL , NIL , FunName() , cCab)} )
RestArea( aArea)

Return nil
    