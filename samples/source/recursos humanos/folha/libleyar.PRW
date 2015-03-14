#INCLUDE "PROTHEUS.CH"
#INCLUDE "GPER800.CH"
#INCLUDE "REPORT.CH"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   ³GPER800   ºAutor   ³Erika Kanamori      º Data ³  08/18/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.      ³Imprime o Relatorio Livro de Saldos da Argentina.            º±±
±±º           ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso        ³ AP                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºMarcos Kato³01/04/09|73232009  ³Ajuste no relatorio R3 e R4 referente     º±±
±±º           ³        |          ³impressao da informacoes do dados         º±±
±±º           ³        |          ³funcionarios(Ex:Cuilt) e separacao dos    º±±
±±º           ³        |          ³valores de remuneracao de acordo comos    º±±
±±º			  ³		   ³          ³itens relacionados da Lei 20744.          º±±
±±ºAlceu P.   ³27/04/09³06142/2009³Feitos ajustes na traducao.E aumentado o  º±±
±±º			  ³		   ³	      ³Tamanho dos campos e ajuste no lay-out.   º±±
±±ºAlceu P.   ³05/02/10³0014442010³Alterada a verificacao do campo RV_INSS   º±±
±±º			  ³		   ³          ³para o campo RV_REMUNE.	                 º±±
±±ºL.Trombini ³26/11/10³26148/2010³Ajustado o programa para verificar a data º±±
±±º			  ³		   ³		  ³de demissao para imprimir somenta na data º±±
±±º			  ³		   ³		  ³da Emissao, Acertado tambem para respeitarº±±
±±º			  ³		   ³		  ³a data de admissao com a emissao.         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/

User Function LIBLEYAR()
Local oReport 
Private lTabela:= .F.
Private cMesAno	:= ""     
Private cArqDBF := ""
Private cDatPgt := ""
Private cAtivEmp := If(!Empty(GetMv("MV_ATVEMPR")),GetMv("MV_ATVEMPR"), " ") //PARAMETRO NÃO ENCONTRADO 
   
	AjustaSx6() //retirar nas proximas versoes =)
	
	If FindFunction("TRepInUse") .And. TRepInUse()

		//-- Ajusta SX1 para trabalhar com range.               
		AjustaGP800RSx1()     
		
		//-- Interface de impressao
		Pergunte("GP800R",.F.)      
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Variaveis utilizadas para parametros                         ³
		//³ mv_par01        //  Processo                                 ³
		//³ mv_par02        //  Procedimento                             ³
		//³ mv_par03        //  Periodo                                  ³
		//³ mv_par04        //  De Numero de Pagamento                   ³
		//³ mv_par05        //  Ate Numero de Pagamento                  ³
		//³ mv_par06        //  Filial                                   ³
		//³ mv_par07        //  Matricula                                ³
		//³ mv_par08        //  Tipo de impressao                        ³
		//³ mv_par09        //  Numero inicial da folha a imprimir       ³
		//³ mv_par10        //  quantidade de folhas a imprimir          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 	oReport:= ReportDef()  
	 	                                             
   		oReport:PrintDialog() 
	#IFNDEF TOP     		
   		If lTabela       //Se criou tabela temporária, apaga a tabela.
			tLANC->(dbCloseArea()) 
			msErase(cArqDBF+".dbf")
		Endif
	#ENDIF			 
 	Else
 		GPER800R3()
	EndIF                                         
	
	Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef ³ Autor ³ Erika Kanamori        ³ Data ³ 07.18.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definicao do relatorio                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef()
                                  
//-- Objeto Relatorio
Local oReport  

//-- Objeto Section
Local oSection1
Local oSection2

//-- Objeto Function
Local oLiquido    

Local	cDesc		:=	STR0002 +" "+ STR0003 + STR0004 // "Emision del Libro de Sueldos" # "Ser  impresso de acordo com os parametros solicitados pelo" # "usuario." 

	//-- Inicio definicao do Relatorio
	DEFINE REPORT oReport NAME "GPER800" TITLE OemToAnsi(STR0001) PARAMETER "GP800R" ACTION {|oReport| PrintReport(oReport)} DESCRIPTION cDesc TOTAL IN COLUMN
                                     
		//-- Section de Funcionario
		DEFINE SECTION oSection1 OF oReport TABLES "SRA","SRC" TITLE STR0013 TOTAL IN COLUMN
		oSection1:SetHeaderBreak(.T.)
  	   	oSection1:SetLineStyle(.T.)      
	   	oSection1:SetCols(2)
			DEFINE CELL NAME "RA_MAT" 		OF oSection1 ALIAS "SRA"
			DEFINE CELL NAME "RA_NOME" 		OF oSection1 ALIAS "SRA" SIZE 30 
			DEFINE CELL NAME "RA_ADMISSA"	OF oSection1 ALIAS "SRA" Title OemToAnsi(STR0030)
			DEFINE CELL NAME "RA_DEMISSA"	OF oSection1 ALIAS "SRA" Title OemToAnsi(STR0031)
			DEFINE CELL NAME "RA_NASC"		OF oSection1 ALIAS "SRA" 
			DEFINE CELL NAME "RA_CIC"		OF oSection1 ALIAS "SRA" PICTURE "999999999999" SIZE 12
			DEFINE CELL NAME "RA_NACIONA" 	OF oSection1 ALIAS "SRA" BLOCK {|| If(Empty(RA_NACIONA),"",Tabela("34",RA_NACIONA))} 	SIZE 12
			DEFINE CELL NAME "RA_SEXO"		OF oSection1 ALIAS "SRA" BLOCK {|| IIF((cQrySRA)->RA_SEXO == "M",STR0022,STR0023) }		SIZE 4
			DEFINE CELL NAME "RA_ESTCIVI" 	OF oSection1 ALIAS "SRA" BLOCK {|| If(Empty(RA_ESTCIVI),"",Tabela("33",RA_ESTCIVI))}	SIZE 14
			DEFINE CELL NAME "RA_CODFUNC"	OF oSection1 ALIAS "SRA" BLOCK {|| fDesc("SRJ",(cQrySRA)->RA_CODFUNC,"RJ_DESC") }       SIZE 30
			DEFINE CELL NAME "RA_CARGO"		OF oSection1 ALIAS "SRA" BLOCK {|| fDesc("SQ3",(cQrySRA)->RA_CARGO,"Q3_DESCSUM") }		SIZE 30
			DEFINE CELL NAME "RA_ENDEREC"	OF oSection1 ALIAS "SRA" SIZE 20
			DEFINE CELL NAME "RA_BAIRRO"	OF oSection1 ALIAS "SRA" 
			DEFINE CELL NAME "RA_CEP"		OF oSection1 ALIAS "SRA" BLOCK {|| IIF(empty((cQrySRA)->RA_CEP),"","(" + ALLTRIM((cQrySRA)->RA_CEP) + ")") }
			DEFINE CELL NAME "RA_ESTADO"  	OF oSection1 ALIAS "SRA" BLOCK {|| If(Empty(RA_ESTADO), "", Tabela("12",RA_ESTADO))} 	SIZE 15
			DEFINE CELL NAME "NRO.RECIBO"	OF oSection1             BLOCK {|| fDesc("SRC",(cQrySRA)->RA_MAT+(cQrySRA)->RA_PROCES+MV_PAR02+MV_PAR03,"SRC->RC_SEQIMP",,(cQrySRA)->RA_FILIAL,6) } 	SIZE 30 //+

			oSection1:Cell("RA_NOME"):SetCellBreak(.T.)
			//-- Section de Dependentes
			DEFINE SECTION oSection2 OF oSection1 TABLES "SRB" TITLE STR0014 TOTAL IN COLUMN
			//oSection2:SetHeaderBreak(.T.)
				
				DEFINE CELL NAME "RB_NOME"		OF oSection2 ALIAS "SRB"
				DEFINE CELL NAME "RB_GRAUPAR"	OF oSection2 ALIAS "SRB" BLOCK {|| IF(RB_GRAUPAR == "C",STR0024,IF(RB_GRAUPAR == "F",STR0025,STR0026))}
				DEFINE CELL NAME "DATA"			OF oSection2 ALIAS "SRB" BLOCK {|| IF(RB_GRAUPAR == "C",STR0027 + dtoc(RB_DTCASAM),STR0028 + dtoc(RB_DTNASC))} TITLE STR0019 SIZE 20
	
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PrintReport³ Autor ³ Erika Kanamori          ³ Data ³ 18.08.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Verbas dos Funcionarios.                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrintReport(oReport)     
            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis Locais                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//-- Objeto
Local oSection1 	:= oReport:Section(1) 		// Funcionario
Local oSection2 	:= oSection1:Section(1)		// Dependente
Local oSection3 	:= oSection1:Section(2)		// Lancamentos
Local oSection4 	:= oSection1:Section(2)		// Lancamentos

//-- String
Local cFiltro			:= ""
Local cFiltro2			:= ""
Local cAcessaSRB  	:= &("{ || " + ChkRH("GPER800","SRB","2") + "}")
Local cAcessaSRC  	:= &("{ || " + ChkRH("GPER800","SRC","2") + "}")
Local cAcessaSRD  	:= &("{ || " + ChkRH("GPER800","SRD","2") + "}")

Local nReg			:= 0
Local nX			:= 0
Public nIni		:= 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis Privadas                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cAcessaSRA  	:= &("{ || " + ChkRH("GPER800","SRA","2") + "}")
Private cProcAnt:= ""
Private cFilAnt := ""		

DbSelectArea('RCH')
dbSetOrder( RetOrder("RCH","RCH_FILIAL+RCH_PROCES+RCH_ROTEIR+RCH_PER+RCH_NUMPAG") )
	
oReport:HideHeader()
oReport:HideFooter()
			                                                             
#IFDEF TOP                                                              

	//-- Section de Lancamentos
	DEFINE SECTION oSection3 OF oSection1 TABLES "SRC", "SRV" TITLE STR0015 TOTAL IN COLUMN
	oSection3:SetHeaderBreak(.T.)

		DEFINE CELL NAME "RC_PD"		OF oSection3 ALIAS "SRC"          	BLOCK {|| (cQryLanc)->RD_PD}
		DEFINE CELL NAME "RV_DESC"		OF oSection3 ALIAS "SRV"            BLOCK {|| (cQryLanc)->RV_DESC}
		DEFINE CELL NAME "RC_HORAS"		OF oSection3 ALIAS "SRC" 			   										PICTURE "999.99"   BLOCK {|| (cQryLanc)->RD_HORAS} SIZE 08
		DEFINE CELL NAME "PROVENTOC"	OF oSection3 ALIAS "SRC" 							TITLE STR0016+" CON" 	PICTURE "@EZ 9,999,999.99" BLOCK {|| IF(((cQryLanc)->RV_TIPOCOD == "1" .And. (cQryLanc)->RV_REMUNE=="S"),(cQryLanc)->RD_VALOR,0)} SIZE 16
		DEFINE CELL NAME "PROVENTOS"	OF oSection3 ALIAS "SRC" 							TITLE STR0016+" SIN" 	PICTURE "@EZ 9,999,999.99" BLOCK {|| IF(((cQryLanc)->RV_TIPOCOD == "1" .And. (cQryLanc)->RV_REMUNE=="N"),(cQryLanc)->RD_VALOR,0)} SIZE 16
		DEFINE CELL NAME "DESCONTOS"	OF oSection3 ALIAS "SRC" 							TITLE STR0017 			PICTURE "@EZ 9,999,999.99" BLOCK {|| IF((cQryLanc)->RV_TIPOCOD == "2"							,(cQryLanc)->RD_VALOR,0)} SIZE 16


	cQrySRA := GetNextAlias()
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	MakeSqlExpr("GP800R")

	cOrdem := "%RA_FILIAL,RA_MAT%"
	
	cDtIni := MV_PAR03+"01"    
	cUltdt := dtos(lastdate(stod(cDtIni)+1))
	cDtFim := strzero(Val(substr(Mv_par03,1,4))+1,4)+substr(mv_par03,5,2)+'25'      
	cFiltro := "% RA_ADMISSA < '"+ cUltDt + "' and '"
	cFiltro += "(RA_DEMISSA = ('"+ Space(8) + " ') OR " 
	cFiltro +=  "RA_DEMISSA BETWEEN '"+ cDtIni + "' and '"+ cDtFim + "' )%"
	  
	BEGIN REPORT QUERY oSection1
		BeginSql alias cQrySRA
			SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_NASC,RA_CIC,RA_NACIONA,RA_SEXO,RA_ESTCIVI,RA_CODFUNC,RA_CARGO,RA_ENDEREC,
			RA_BAIRRO,RA_CEP,RA_ESTADO,RA_MUNICIP,RA_CODFUNC,RA_CATFUNC,RA_CARGO,RA_PROCES,RA_SITFOLH
			FROM %table:SRA% SRA                                        
			Where %exp:cFiltro%
					   AND SRA.%notDel%
		EndSql
	
	END REPORT QUERY oSection1 PARAM mv_par06, mv_par07  
    
#ELSE 
      

	//-- Section de Lancamentos
	DEFINE SECTION oSection3 OF oSection1 TABLES "tLanc", "SRV" TITLE STR0015 TOTAL IN COLUMN
	oSection3:SetHeaderBreak(.T.)

		DEFINE CELL NAME "PD"			OF oSection3 ALIAS "tLanc"             
		DEFINE CELL NAME "RV_DESC"		OF oSection3 ALIAS "SRV"       
		DEFINE CELL NAME "HORAS"		OF oSection3 ALIAS "tLanc" 			   										PICTURE "999.99" SIZE 08                                                                             
		DEFINE CELL NAME "PROVENTOC"	OF oSection3 ALIAS "SRC" 							TITLE STR0016+" CON" 	PICTURE "@EZ 9,999,999.99" BLOCK {|| IF((SRV->RV_TIPOCOD == "1" .And. SRV->RV_REMUNE=="S"),("tLANC")->VALOR,0)} SIZE 16
		DEFINE CELL NAME "PROVENTOS"	OF oSection3 ALIAS "SRC" 							TITLE STR0016+" SIN" 	PICTURE "@EZ 9,999,999.99" BLOCK {|| IF((SRV->RV_TIPOCOD == "1" .And. SRV->RV_REMUNE=="N"),("tLANC")->VALOR,0)} SIZE 16
		DEFINE CELL NAME "DESCONTOS"	OF oSection3 ALIAS "SRC" 							TITLE STR0017 			PICTURE "@EZ 9,999,999.99" BLOCK {|| IF(SRV->RV_TIPOCOD == "2"						    ,("tLANC")->VALOR,0)} SIZE 16

		DEFINE CELL NAME "DATAS"		OF oSection3 ALIAS "tLanc"		

		//-- Posiciona as tabelas de verbas e tipo de ausencia
		TRPosition():New(oSection3,"SRV",1,{|| xFilial("SRV") + ("tLANC")->PD}) 
		
		
	DbSelectArea('SRC')               
	DbSetOrder(1)
	DbSelectArea('SRD')
	DbSetOrder(1)
	
	dbSelectArea('SRB')
	dbSetOrder(1)
	dbSelectArea('SRV')
	dbSetOrder(1)
                     
	cQrySRA 	:= "SRA"
	cFiltro 	:= ""

	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	MakeAdvplExpr("GP800R")
	dbSelectArea(cQrySRA)

	cIndCond	:= "RA_FILIAL+RA_MAT"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz filtro no arquivo...                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//-- Adiciona no filtro o parametro tipo Range
	//-- Filial
	If !Empty(mv_par06)
		cFiltro := mv_par06
	EndIf                 

	//-- Matricula
	If !Empty(mv_par07)
		If !Empty(cFiltro)
			cFiltro += " .AND. "
		EndIf	
		cFiltro += mv_par07
	EndIf                 

  	oSection1:SetFilter(cFiltro,cIndCond)     
  	
  	
#ENDIF	

oSection1:SetLineCondition({|| fCondSRA() })

//-- Relaciona a Section Filha (Dependente) com a Section Pai (Funcionario)
oSection2:SetRelation({|| (cQrySRA)->RA_FILIAL + (cQrySRA)->RA_MAT },"SRB",1,.T.)

//-- Condicao de relacionamento da secao filha em relacao a sua secao pai
//-- Filial e matricula da tabela de funcionarios (SRA) com a tabela de dependente (SRB)
oSection2:SetParentFilter({|cParam| SRB->RB_FILIAL + SRB->RB_MAT == cParam},{|| (cQrySRA)->RA_FILIAL + (cQrySRA)->RA_MAT })

oSection2:SetLineCondition({|| Eval(cAcessaSRB) })                                                 

 
#IFDEF TOP
	cQryLanc := GetNextAlias()
	
	cProcessos:= AllTrim(mv_par01)
	If AllTrim(cProcessos) <> "*"
		cRProc := ""
		nTamCod := GetSx3Cache( "RCJ_CODIGO" , "X3_TAMANHO" )   
		For nReg := 1 to Len(cProcessos) Step 5
				cAuxPrc := Subs(cProcessos,nReg,5)
			cRProc += cAuxPrc
			If ( nReg+5 ) <= Len(cProcessos)
				cRProc += "','"
			EndIf
		Next
		cFiltro := "% RC_PROCES IN ('"+ cRProc + "')"
		cFiltro2:= "% RD_PROCES IN ('"+ cRProc + "')"
	EndIf 
	  
	//-- Roteiro
	If !Empty(mv_par02)	
		cFiltro += " AND RC_ROTEIR = '" + mv_par02 + "'"
		cFiltro2+= " AND RD_ROTEIR = '" + mv_par02 + "'"
	EndIf
	
	//-- Periodo  
	If !Empty(mv_par03)	
		cFiltro += " AND RC_PERIODO = '" + mv_par03 + "'"
		cFiltro2+= " AND RD_PERIODO = '" + mv_par03 + "'"
	EndIf
	                  
	//-- Numero de Pagamento
	cFiltro += " AND RC_SEMANA BETWEEN '" + mv_par04 + "' AND '"  + mv_par05 + "' %"
	cFiltro2 += " AND RD_SEMANA BETWEEN '" + mv_par04 + "' AND '"  + mv_par05 + "' %"
    
    
	BEGIN REPORT QUERY oSection3
		BeginSql alias cQryLanc
			SELECT RC_FILIAL RD_FILIAL, 
				   RC_MAT RD_MAT, 
				   RC_PD RD_PD,
				   RC_HORAS RD_HORAS,
				   RC_VALOR RD_VALOR, 
				   RC_DATA RD_DATPGT,
				   RV_TIPOCOD, 
				   RV_REMUNE,				   
				   RV_DESC,           
				   RC_ROTEIR RD_ROTEIR
			FROM %Table:SRC% SRC Left Join %Table:SRV% SRV On RC_PD = RV_COD
			WHERE %exp:cFiltro%
					   AND SRC.%notDel%
					   AND SRV.%notDel% 
					   AND SRV.RV_TIPOCOD IN ('1','2')
			UNION 
			SELECT RD_FILIAL, 
				   RD_MAT, 
				   RD_PD,
				   RD_HORAS,
				   RD_VALOR, 
                   RD_DATPGT,				   				   				   
				   RV_TIPOCOD, 
   				   RV_REMUNE,
				   RV_DESC,
				   RD_ROTEIR
			FROM %Table:SRD% SRD Left Join %Table:SRV% SRV On RD_PD = RV_COD
			WHERE %exp:cFiltro2%
					   AND SRD.%notDel%
					   AND SRV.%notDel% 
					   AND SRV.RV_TIPOCOD IN ('1','2')
		EndSql	
	END REPORT QUERY oSection3     

    (cQryLanc)->(DbGoTop())
    cDatPgt:=DToc((cQryLanc)->RD_DATPGT)
	Do While (cQryLanc)->(!Eof())
		If (cQryLanc)->RD_ROTEIR=='FOL'
		    cDatPgt:=Dtoc((cQryLanc)->RD_DATPGT)
		Endif
		(cQryLanc)->(DbSkip())
	End     
	(cQryLanc)->(DbGoTop())
	//-- Condicao de relacionamento da secao filha em relacao a sua secao pai
	//-- Filial e matricula da tabela de funcionarios (SRA) com a tabela de lancamentos (SRC)
	oSection3:SetParentFilter({|cParam| (cQryLanc)->RD_FILIAL + (cQryLanc)->RD_MAT == cParam},{|| (cQrySRA)->RA_FILIAL + (cQrySRA)->RA_MAT })
	
#ELSE         

	oSection3:SetRelation({|| (cQrySRA)->RA_FILIAL + (cQrySRA)->RA_MAT },"tLANC",1,.T.)  
	oSection3:SetParentFilter({|cParam| ("tLANC")->FILIAL + ("tLANC")->MAT == cParam},{|| (cQrySRA)->RA_FILIAL + (cQrySRA)->RA_MAT })	
	
#ENDIF
	
	oSection3:SetLineCondition({|| Eval(cAcessaSRC)  })       

//-- Define o total da regua da tela de processamento do relatorio
oReport:SetMeter((cQrySRA)->( RecCount() ))  

nIni := MV_PAR09

If MV_PAR08 == 1
	oSection1:Hide() 		// Funcionario
	oSection2:Hide()		// Dependente
	oSection3:Hide()		// Lancamentos

	nFim := (nIni+ MV_PAR10)-1
	For nx := nIni to nfim
	   nIni := nX
	   oReport:StartPage()
	   fCabec( oReport )
	   oReport:EndPage()
	Next	   
Else
	#IFDEF TOP                                                              

		//-- Total do Funcionario e Total da Empresa
		DEFINE FUNCTION 				FROM oSection1:Cell("RA_MAT")		FUNCTION COUNT 	TITLE STR0013 NO END SECTION
		DEFINE FUNCTION NAME "TOTAL1"	FROM oSection3:Cell("PROVENTOC")	FUNCTION SUM 	TITLE STR0016+" CON" 	OF oSection1
		DEFINE FUNCTION NAME "TOTAL2"	FROM oSection3:Cell("PROVENTOS")	FUNCTION SUM 	TITLE STR0016+" SIN" 	OF oSection1		
		DEFINE FUNCTION NAME "TOTAL3"	FROM oSection3:Cell("DESCONTOS")	FUNCTION SUM 	TITLE STR0017			OF oSection1
		DEFINE FUNCTION oLiquido 		FROM oSection3:Cell("DESCONTOS") 	FUNCTION ONPRINT 	TITLE STR0021 OF oSection1 FORMULA {|| oSection1:GetFunction("TOTAL1"):GetLastValue() + oSection1:GetFunction("TOTAL2"):GetLastValue() - oSection1:GetFunction("TOTAL3"):GetLastValue() }

		oLiquido:ShowHeader()
	#ELSE         
		//-- Total do Funcionario e Total da Empresa
		DEFINE FUNCTION 				FROM oSection1:Cell("RA_MAT")		FUNCTION COUNT 	TITLE STR0013 NO END SECTION
		DEFINE FUNCTION NAME "TOTAL1"	FROM oSection3:Cell("PROVENTOC")	FUNCTION SUM 	TITLE STR0016+" CON" 	OF oSection1
		DEFINE FUNCTION NAME "TOTAL2"	FROM oSection3:Cell("PROVENTOS")	FUNCTION SUM 	TITLE STR0016+" SIN" 	OF oSection1		
		DEFINE FUNCTION NAME "TOTAL3"	FROM oSection3:Cell("DESCONTOS")	FUNCTION SUM 	TITLE STR0017			OF oSection1
		DEFINE FUNCTION oLiquido 		FROM oSection3:Cell("DESCONTOS") 	FUNCTION ONPRINT 	TITLE STR0021 OF oSection1 FORMULA {|| oSection1:GetFunction("TOTAL1"):GetLastValue() + oSection1:GetFunction("TOTAL2"):GetLastValue() - oSection1:GetFunction("TOTAL3"):GetLastValue() }
		oLiquido:ShowHeader()      

	#ENDIF
EndIf

//-- Impressao na quebra de pagina - Impressao das informacoes da Empresa e Filial
If MV_PAR08 ==3 
	oReport:OnPageBreak({|| fCabec(oReport) })
ElseIf MV_PAR08 == 2 
	oReport:OnPageBreak({|| fPulaLinha(oReport) })
EndIf	

//-- Impressao do Relatorio
oSection1:Print()


Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fCondSRA   ³ Autor ³ Erika Kanamori          ³ Data ³ 09.16.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se a linha deve ser impressa                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCondSRA()                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCondSRA(oSection) 

Local lRetorno  
//Local aFields := {}


            
	lRetorno := .T.           

   If !((cQrySRA)->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
  	   lRetorno := .F.
  	EndIf
    
	
	If ("RCH")->(dbSeek(xFilial("RCH")+(cQrySRA)->RA_PROCES+mv_par02+mv_par03, .T.)) 
		cMesAno := RCH->RCH_MES+RCH->RCH_ANO     
	Elseif ("RCH")->(dbSeek(xFilial("RCH")+(cQrySRA)->RA_PROCES+"   "+mv_par03, .T.))
		cMesAno := RCH->RCH_MES+RCH->RCH_ANO
	Else
		lRetorno := .F.
	Endif      
	 
	
	#IFNDEF TOP  
	                  
	If (cQrySRA)->RA_FILIAL <> cFilAnt .Or. (cQrySRA)->RA_PROCES <> cProcAnt	  
		    
		If lTabela
			tLANC->(dbCloseArea())
			msErase(cArqDBF+".dbf")
		Endif
		
			AADD(aFields,{"FILIAL" ,"C",02,0})
			AADD(aFields,{"MAT","C",06,0})
			AADD(aFields,{"PROCES","C",05,0})
			AADD(aFields,{"ROTEIR","C",03,0})
			AADD(aFields,{"PERIODO","C",06,0})
			AADD(aFields,{"SEMANA","C",02,0})
			AADD(aFields,{"PD","C",03,0})
			AADD(aFields,{"HORAS","N",06,0})
			AADD(aFields,{"VALOR","N",12,0})	
			AADD(aFields,{"DATAS","D",08,0})
		
			//DbCreate(cArqDBF,aFields)	                        
			cArqDBF  := CriaTrab(aFields,.T.)
		
			DbUseArea( .T., , cArqDBF, 'tLANC', .F. )		
			dbCreateIndex( "1","FILIAL+MAT",{|| FILIAL + MAT}, .F. )
			cFilAnt:= SRA->RA_FILIAL
			cProcAnt:= SRA->RA_PROCES     
			lTabela:= .T.
		
			                                      
		dbSelectArea("SRC")
		dbSetOrder(RetOrder("SRC", "RC_FILIAL+RC_PROCES+RC_PERIODO+RC_SEMANA+RC_ROTEIR" ))
		If dbSeek(SRA->RA_FILIAL+SRA->RA_PROCES+mv_par03, .T.)
			While ("SRC")->(!Eof()) .And. ;
				("SRC")->(RC_FILIAL+RC_PROCES+RC_PERIODO) == SRA->RA_FILIAL+SRA->RA_PROCES+mv_par03 .And.;
				("SRC")->RC_ROTEIR == mv_par02 .And. ;
				('SRC')->RC_SEMANA >= mv_par04 .And. ('SRC')->RC_SEMANA <= mv_par05
					DbSelectArea("tLANC")
					RecLock( 'tLANC', .T. )   
					Replace ("tLANC")->FILIAL  with ("SRC")->RC_FILIAL					
					Replace ("tLANC")->MAT     with ("SRC")->RC_MAT
					Replace ("tLANC")->PROCES  with ("SRC")->RC_PROCES
					Replace ("tLANC")->ROTEIR  with ("SRC")->RC_ROTEIR
					Replace ("tLANC")->PERIODO with ("SRC")->RC_PERIODO
					Replace ("tLANC")->SEMANA  with ("SRC")->RC_SEMANA
					Replace ("tLANC")->PD      with ("SRC")->RC_PD
					Replace ("tLANC")->HORAS   with ("SRC")->RC_HORAS
					Replace ("tLANC")->DATAS   with ("SRC")->RC_DATA
					Replace ("tLANC")->VALOR   with ("SRC")->RC_VALOR  
					
					tLANC->(msUnLock())
					("SRC")->(dbSkip())   			
			Enddo
		Endif
				 

		
	  
		dbSelectArea("SRD") 
		dbSetOrder(RetOrder("SRD", "RD_FILIAL+RD_PROCES+RD_PERIODO+RD_SEMANA+RD_ROTEIR" ))		 
		If dbSeek(SRA->RA_FILIAL+SRA->RA_PROCES+mv_par03, .T.)
			While ("SRD")->(!Eof()) .And. ;
				("SRD")->(RD_FILIAL+RD_PROCES+RD_PERIODO) == SRA->RA_FILIAL+SRA->RA_PROCES+mv_par03 .And.;
				("SRD")->RD_ROTEIR == mv_par02 .And. ;
				('SRD')->RD_SEMANA >= mv_par04 .And. ('SRD')->RD_SEMANA <= mv_par05            
			   		DbSelectArea("tLANC")
					RecLock( "tLANC", .T. )
					Replace ("tLANC")->FILIAL  with ("SRD")->RD_FILIAL					
					Replace ("tLANC")->MAT     with ("SRD")->RD_MAT
					Replace ("tLANC")->PROCES  with ("SRD")->RD_PROCES
					Replace ("tLANC")->ROTEIR  with ("SRD")->RD_ROTEIR
					Replace ("tLANC")->PERIODO with ("SRD")->RD_PERIODO
					Replace ("tLANC")->SEMANA  with ("SRD")->RD_SEMANA
					Replace ("tLANC")->PD      with ("SRD")->RD_PD
					Replace ("tLANC")->HORAS   with ("SRD")->RD_HORAS
					Replace ("tLANC")->DATAS   with ("SRC")->RD_DATPGT					
					Replace ("tLANC")->VALOR   with ("SRD")->RD_VALOR  

				    tLANC->(msUnLock())
					
					("SRD")->(dbSkip())
					
			EndDo 
			
		Endif   
		
	Endif
	
	#ENDIF
	
	If (cQrySRA)->RA_SITFOLH $'D' .And. MesAno((cQrySRA)->RA_DEMISSA) < cMesAno
  	   lRetorno := .F.
	Endif

Return lRetorno
	
/*                            


ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fCabec     ³ Autor ³ R.H. - Tatiane Matias   ³ Data ³ 08.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cabecalho do relatorio                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCabec()                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCabec(oReport)

Local cAtivEmp  := If(!Empty(GetMv("MV_ATVEMPR")),GetMv("MV_ATVEMPR"), " ")


		oReport:PrintText("HABILITACION DEL REGISTRO DE HOJAS MOVILES EN REEMPLAZO DEL LIBRO ESPECIAL ART. 52§ LEY 20744 (T.O.)")
		oReport:PrintText(Alltrim(SM0->M0_NOMECOM) + Space(10) + Alltrim(SM0->M0_ENDCOB) + Space(10) + Alltrim(SM0->M0_CIDCOB)+ Space(10)+ Alltrim(SM0->M0_CGC))
		oReport:PrintText(cAtivEmp+ Space(10) + STR0018 + ": " + mv_par03  + Space(10) + "Fecha Pago: "+cDatPgt + space(10)+"Hoja: "+strzero(nIni,4))
		oReport:ThinLine()
		oReport:SkipLine()

		If MV_PAR08 == 3
			nIni++			
        EndIf
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER800   ºAutor  ³Microsiga           º Data ³  07/23/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fPulaLinha(oReport)


		oReport:SkipLine()
		oReport:SkipLine()
		oReport:SkipLine()
		oReport:SkipLine()
		oReport:SkipLine()
		oReport:SkipLine()
		
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Erika Kanamori      º Data ³  08/13/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaGP800RSx1()
Local cPerg 	:= "GP800R"
Local aRegs 	:= {}

Local aHelpPor	:= {}
Local aHelpSpa	:= {}
Local aHelpEng	:= {}
                     

		/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³             Grupo    Ordem    Perg.Port.                             Perg.Esp.                              Perg.Ingles                       Variavel     Tipo   Tam       Dec     Presel  GSC    Valid                                                     Var01           Def01    DefSPA1  DefEng1   Cnt01         Var02   Def02          DefSpa2    DefEng2   Cnt02   Var03   Def03         DefSpa3   DefEng3    Cnt03     Var04    Def04    DefSpa4    DefEng4    Cnt04 	    Var05      Def05     DefSpa5     DefEng5     Cnt05     XF3       GrgSxg     cPyme    aHelpPor    aHelpEng	   aHelpSpa      cHelp   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ */
Aadd( aRegs,{ cPerg ,  '01'  , "Seleção de Processos?"            , "¿Seleccion de Procesos?"             , "Selection of Processes?"        ,  "mv_ch1" ,  "C" ,    50   ,   0   ,   0   , "G" , "fListProc()                                           "  , "MV_PAR01" ,  ""    ,    ""   ,    ""   ,  ""  	 	  ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , ""     ,       " "   ,   "S"   ,  ""       ,   ""       , ""         ,      ""    } )
Aadd( aRegs,{ cPerg ,  '02'  , "Roteiro?"                         , "¿Procedimiento?"                     , "Procedure?"                     ,  "mv_ch2" ,  "C" ,    3    ,   0   ,   0   , "G" , "fRoteiro()                                            "  , "MV_PAR02" ,  ""    ,    ""   ,    ""   ,  ""  		  ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , ""     ,       " "   ,   "S"   ,  ""       ,   ""       , ""         ,  ".RHROT." } )
Aadd( aRegs,{ cPerg ,  '03'  , "Período?"                         , "¿Periodo?"                           , "Period?"                        ,  "mv_ch3" ,  "C" ,    6    ,   0   ,   0   , "G" , "Gpr040Valid(mv_par01 + mv_par02 + mv_par03)           "  , "MV_PAR03" ,  ""    ,    ""   ,    ""   ,  ""   	  ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "RCH  ",       " "   ,   "S"   ,  ""       ,   ""       , ""         ,  ".RHPER." } )  
Aadd( aRegs,{ cPerg ,  '04'  , "Numero de Pagamento De?"          , "¿De Numero Pago?"                    , "From Payment Number?"           ,  "mv_ch4" ,  "C" ,    2    ,   0   ,   0   , "G" , "Gpr040Valid(mv_par01 + mv_par02 + mv_par03 + mv_par04)"  , "MV_PAR04" ,  ""    ,    ""   ,    ""   ,  ""   	  ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "RCH01",       " "   ,   "S"   ,  ""       ,   ""       , ""         , ".RHNPGDE."} )
Aadd( aRegs,{ cPerg ,  '05'  , "Numero de Pagamento Até?"         , "¿Ate Numero Pago?"                   , "To Payment Number?"             ,  "mv_ch5" ,  "C" ,    2    ,   0   ,   0   , "G" , "Gpr040Valid(mv_par01 + mv_par02 + mv_par03 + mv_par05)"  , "MV_PAR05" ,  ""    ,    ""   ,    ""   ,  ""         ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "RCH01",       " "   ,   "S"   ,  ""       ,   ""       , ""         , ".RHNPGAT."} )
Aadd( aRegs,{ cPerg ,  '06'  , "Filial?"                          , "¿Sucursal?"                          , "Branch?"                        ,  "mv_ch6" ,  "C" ,    99   ,   0   ,   0   , "R" , ""  														  , "MV_PAR06" ,  ""    ,    ""   ,    ""   ,"RA_FILIAL" ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "SM0"  ,       " "   ,   "S"   ,  ""       ,   ""       , ""         , ".RHFILDE."} )
Aadd( aRegs,{ cPerg ,  '07'  , "Matrícula?"                       , "¿Matricula?"                         , "Registration?"                  ,  "mv_ch7" ,  "C" ,    99   ,   0   ,   0   , "R" , "" 								   			              , "MV_PAR07" ,  ""    ,    ""   ,    ""   ,"RA_MAT"  	  ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "SRA"  ,       " "   ,   "S"   ,  ""       ,   ""       , ""         ,".RHMATRIC."} )

aHelpSPA := { 	"Tipo de impresión:" 				,;
				"1-Cabecera: imprime solamente"		,;
				"a cabecera"						,;
				"2-Cuerpo Solamente: imprime todos"	,;
				"los datos del empleado, pero no se",;
				"imprime la cabecera"				,;
				"3-Completo: imprime la cabecera y"	,;
				"el cuerpo del libro ley." }
				
aHelpPOR := { 	"Tipo de impressao:"			,;
				"1-Cabeçalho: imprime somente"	,;
				"o cabeçalho"					,;
				"2-Somente corpo: imprime todos",;
				"os dados do funcionario, lançamentos",;
				"mas não imprime o cabeçalho"	,;
				"3-Completo: imprime o cabeçalho e o" ,;
				"corpo do livro lei."	}
				
Aadd( aRegs,{ cPerg ,  '08'  , "Tipo impressao?"                  , "¿Tipo de Impresion?"                 , "Print type  ?"                  ,  "mv_ch8" ,  "C" ,    1    ,   0   ,   0   , "C" , "" 								   			              , "MV_PAR08" ,"1-Cabeçalho" ,"1-Cabecera","1-Header"   ,""   ,  " "  ,"2-Somente Corpo","2-Cuerpo Solamente","2-Body Only"," "   ,  " "  ,  "3-Completo",  "3-Completo","3-Complete "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , ""     ,     " "   ,   "S"   , aHelpPor      ,   aHelpEng       , aHelpSpa         ,""} )

aHelpPOR := { 	"Informe a numeracao da folha inicial ",;
				"do livro lei" }
aHelpSPA := { 	"Informar la numeracion inicial ",;
				"del libro lei" }

Aadd( aRegs,{ cPerg ,  '09'  , "Folha Inicial"                    , "¿Hoja inicial"                        , "First Sheet"                    ,  "mv_ch9" ,  "N" ,    4   ,   0   ,   0   , "G" , "" 								   			              , "MV_PAR09" ,  ""    ,    ""   ,    ""   ,""  	      ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , ""  ,     " "   ,   "S"   ,  aHelpPor       ,   ""       , aHelpSpa         ,""} )

aHelpPOR := { 	"Informe quantidade de folhas a       ",;
				"imprimir." ,;
				"Esta pergunta so sera utilizada ",;
				"quando a pergunta 'Tipo de impressao'" ,;
				"for igual a '1-Cabecalho'"}
aHelpSPA := { 	"Informar la cantidade de hojas ",;
				"para imprimir." ,;
				"Esta pregunta solo se utiliza cuando" ,;
				"la pregunta 'Tipo impresion' es igual" ,;
				"a '1-Cabecera'"}
Aadd( aRegs,{ cPerg ,  '10'  , "Quantidade de Folhas"             , "¿Cantidad Hojas"                      , "Amount Sheet"                    ,  "mv_cha",  "N" ,    4   ,   0   ,   0   , "G" , "" 								   			              , "MV_PAR10" ,  ""    ,    ""   ,    ""   ,""  	      ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , ""  ,     " "   ,   "S"   ,  aHelpPor       ,   ""       , aHelpSpa         ,""} )

ValidPerg(aRegs,cPerg,.F.)			//-- Inclui Pergunta    

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER800R3 ºAutor  ³Erika Kanamori      º Data ³  08/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function GPER800R3()

Local cString,cDesc1,cDesc2,cDesc3
Local cPerg := 'GPR800'
Local cTitulo,Wnrel
Local lImp	:=	.T.
Private lEnd	:=	.F.
Private aReturn,Li
Private nLastKey	:=	0
Private nRelat    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Basicas Genericas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString   := 'SRA' //-- Alias do arquivo principal (Base).
cDesc1    := STR0002 //"Emision del Libro de Sueldos"
cDesc2    := STR0003	//'Ser  impresso de acordo com os parametros solicitados pelo'
cDesc3    := STR0004 //'usuario.'

Li        := 99
lEnd      := .F.
aReturn   := {STR0005, 1,STR0006, 2, 2, 1, '',1 }  //'Zebrado'###'Administra‡„o'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Basicas Programa                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo    := STR0001 //"EMISION DEL LIBRO DE SUELDOS"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AjustaGPR800()    //Retirar nas proximas versoes =]


Pergunte('GPR800',.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WnRel := 'GPER800' //-- Nome Default do relatorio em Disco.
WnRel := SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.)

If LastKey() = 27 .Or. nLastKey = 27
	Return  .F. 
Endif 

SetDefault(aReturn,cString)

If LastKey() = 27 .Or. nLastKey = 27
	Return  .F. 
Endif  

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis utilizadas para parametros                         ³
³ mv_par01        //  Processo?						           ³ 
³ mv_par02        //  Procedimento?					           ³
³ mv_par03        //  Periodo? 						           |
³ mv_par04        //  Nº de Pago De?                           ³
³ mv_par05        //  Nº de Pago Ate?                          ³
³ mv_par06        //  Filial De?                               ³
³ mv_par07        //  Filial Ate?                              ³
³ mv_par08        //  Matricula De?                            ³
³ mv_par09        //  Matricula Ate?                           ³
³ mv_par10        //  Tipo de impressao                        ³
³ mv_par11        //  Numero inicial da folha a imprimir       ³
³ mv_par12        //  quantidade de folhas a imprimir          ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/                  
cProcesso := mv_par01
cRoteiro  := mv_par02
cPeriodo  := mv_par03 
cNumPagoDe:= mv_par04
cNumPagoAt:= mv_par05
cFilialDe := mv_par06
cFilialAte:= mv_par07
cMatDe	  := mv_par08
cMatAte   := mv_par09
nTpImp	  := mv_par10
nFolIni	  := mv_par11
nQtdfol	  := mv_par12	

ProcGPE({|lEnd| lImp	:=	fRC_Imp()})
If lImp
	If aReturn[5] == 1
		Set Printer To
		dbCommit()
		OurSpool(WnRel)
	Endif
Endif
MS_FLUSH()

Return Nil  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRC_Imp   ºAutor  ³Erika Kanamori      º Data ³  08/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRC_Imp()

Local cAcessaSRA  := &("{ || " + ChkRH("GPER800","SRA","2") + "}")
Local cMes 		  := 0
Local cAno 		  := 0  
Local nAux		  := 0   
Local cFilAnt	  := "" 
Local aPerAberto  := {}
Local aPerFechado := {} 
Local aPerAberto1 := {}
Local aPerFechado1:= {} 
Local aPerTodos	  := {}
Local nx		  := 0	
Private nCTotHab  := 0
Private nSTotHab  := 0
Private nTotDesc  := 0                                            
Private Li 		  := 99
Private nCant	  := 0  
Private lRotBlank := .F.  
Private cDatPgt   := ""
               

dbSelectArea("SRA")   
dbSetOrder(1)
dbSeek( cFilialDe + cMatDe, .T. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GPProcRegua(RecCount())// Total de elementos da regua

	
If nTpImp == 1 //só cabeçalho

	nFim := (nFolIni+ nQtdfol)-1
	For nx := nFolIni to nfim
	   nFolIni := nX
	   Li := 66
	   SALTO()
	Next	   
		
Else
	While ("SRA")->(!Eof()) .And. SRA->(RA_FILIAL+RA_MAT) <= (cFilialAte+cMatAte) 
		  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta Regua de Processamento                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GPIncProc(SRA->RA_FILIAL+" - "+SRA->RA_MAT+" - "+SRA->RA_NOME)  
		
			 	
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		Endif	 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste controle de acessos e filiais validas				 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
	  	   SRA->(dbSkip())
	  	   Loop
		EndIf		
	   	           
	   	          
		If SRA->RA_FILIAL <> cFilAnt 
		
			If nCant <> 0                       
				//imprime totais, zera variaveis totalizadoras e inicia nova pagina
				IMPRTOTALES() 
				nCTotHab  := 0
				nSTotHab  := 0
				nTotDesc  := 0                                            
				nCant	  := 0
				Li		  := 99
			Endif
			
			//carrega mes e ano do periodo selecionado
			dbSelectArea("RCH")
			dbSetOrder( RetOrder("RCH","RCH_FILIAL+RCH_PROCES+RCH_ROTEIR+RCH_PER+RCH_NUMPAG") )
			If dbSeek(xFilial("RCH")+cProcesso+cRoteiro+cPeriodo+cNumPagoDe, .T.)
				lRotBlank := .F.
			Elseif dbSeek(xFilial("RCH")+cProcesso+"   "+cPeriodo+cNumPagoDe, .T.) 
				lRotBlank:= .T.
			Else
				Loop
			Endif
			
			cMes := RCH->RCH_MES
			cAno := RCH->RCH_ANO
			cDatPgt:= DToc(RCH->RCH_DTPAGO)
			fRetPerComp( 	cMes		,;		// Obrigatorio - Mes para localizar as informacoes
							cAno		,;		// Obrigatorio - Ano para localizar as informacoes
							xFilial("RCH"),;		 // Opcional - Filial a Pesquisar
							cProcesso	,;		// Opcional - Filtro por Processo
							Iif(lRotBlank,"   ",cRoteiro)	,;		// Opcional - Filtro por Roteiro
							aPerAberto1	,;		// Por Referencia - Array com os periodos Abertos
							aPerFechado1, ;		// Por Referencia - Array com os periodos Fechados
							aPerTodos    ;		// Por Referencia - Array com os periodos Abertos e Fechados em Ordem Crescente
							 )	      
			If !(len(aPerAberto1) < 1)
				For nAux:= 1 to len(aPerAberto1)
					If aPerAberto1[nAux,2] >= cNumPagoDe .And. aPerAberto1[nAux,2] <= cNumPagoAt
						aAdd(aPerAberto, aPerAberto1[nAux])
					Endif
				Next
			End
			If !(len(aPerFechado1) < 1)
				For nAux:= 1 to len(aPerFechado1)
					If aPerFechado1[nAux,2] >= cNumPagoDe .And. aPerFechado1[nAux,2] <= cNumPagoAt
						aAdd(aPerFechado, aPerFechado1[nAux])
					Endif
				Next
			End
								
			cFilAnt:= SRA->RA_FILIAL		     	
		Endif
	
		If SRA->RA_SITFOLH $'D' .And. Mesano(SRA->RA_DEMISSA) < (cMes+cAno)
	 		SRA->(dbSkip())
			Loop
		Endif
	
		IMPRFUNC(cMes,cAno)
	    IMPRHABERES(aPerAberto,aPerFechado)
	
		SRA->(dbSkip())
	End
	
	IMPRTOTALES()
EndIf
Return .T.     
  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImprFunc  ºAutor  ³Erika Kanamori      º Data ³  08/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImprFunc(cMes,cAno)

Local aArea := GetArea( )
Local cAcessaSRB  := &("{ || " + ChkRH("GPER800","SRB","2") + "}")


SALTO()        

@ Li, 00 PSAY SRA->RA_MAT
@ Li, 07 PSAY SRA->RA_NOME
@ Li, 46 PSAY DToC(SRA->RA_ADMISSA)
@ Li, 56 PSAY IIF(Empty(SRA->RA_DEMISSA),"  /  /  ",DToC(SRA->RA_DEMISSA))
@ Li, 66 PSAY DToC(SRA->RA_NASC)
@ Li, 78 PSAY Alltrim(SRA->RA_CIC)
SX5->(dbSeek( xFilial()+"34"+SRA->RA_NACIONA ))
@ Li, 92 PSAY Substr(SX5->X5_DESCSPA,1,12)
@ Li, 105 PSAY IIF(SRA->RA_SEXO == "M", "Masc" , "Fem." )
Sx5->(dbSeek( xFilial()+"33"+SRA->RA_ESTCIVI ))
@ Li, 110 PSAY Substr(SX5->X5_DESCSPA,1,12)    

SALTO() 

@ Li, 00 PSAY Alltrim(SRA->RA_ENDEREC)+Space(6)+Alltrim(SRA->RA_BAIRRO)+Alltrim(SRA->RA_ESTADO)+"-"+Alltrim(SRA->RA_MUNICIP)
Sx5->(dbSeek( xFilial()+"33"+SRA->RA_ESTCIVI ))
@ Li, 092 PSAY SRA->RA_CATFUNC

SALTO() 
/*
Legajo Apellido y Nombre                      Fec.Alta   Fec.Baja   Fec.Nac.    Cuilt         Nacionalidad Sexo Estado Civil"
Domicilio                                                                                     Categoria            "

@ Li, 78 PSAY Alltrim(SRA->RA_CIC)
SX5->(dbSeek( xFilial()+"34"+SRA->RA_NACIONA ))
@ Li, 92 PSAY Substr(SX5->X5_DESCSPA,1,12)
@ Li, 105 PSAY IIF(SRA->RA_SEXO == "M", "Masc" , "Fem." )
Sx5->(dbSeek( xFilial()+"33"+SRA->RA_ESTCIVI ))
@ Li, 110 PSAY Substr(SX5->X5_DESCSPA,1,12)    

          1         2         3         4         5         6         7         8         9        10        11
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
*/

SALTO()

DbSelectArea("SRB")   
DbSetOrder(1)
If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
	While !Eof() .And. SRB->RB_FILIAL+SRB->RB_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		If Eval(cAcessaSRB)
	 		@ Li, 40 PSAY RB_NOME
			
			Do Case
				Case RB_GRAUPAR == "C"
	            @ Li, 75 PSAY "CONYUGE"
				Case RB_GRAUPAR == "F"
	            @ Li, 75 PSAY "HIJO"
				Otherwise
	            @ Li, 75 PSAY "OTROS"
			EndCase
	      
	      If RB_GRAUPAR == "C"
	         @ Li, 85 PSAY "F.Cas: " + dtoc(RB_DTCASAM)
	      Else
	         @ Li, 85 PSAY "F.Nac: " + dtoc(RB_DTNASC)
	      EndIf    
	      
		Endif	
		dbSkip()
		
		SALTO()

	Enddo
Endif

RestArea( aArea ) 

Return      



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ImprHaberesºAutor  ³Erika Kanamori      º Data ³  08/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImprHaberes(aPerAberto,aPerFechado)    

Local nCHaberes  := 0
Local nSHaberes  := 0
Local nDescuentos:= 0
Local nAux:= 0            
Local aVerbasFunc:= {} 
Local aVerbas:= {}
        

  
aVerbasFunc:= RetornaVerbasFunc(SRA->RA_FILIAL, SRA->RA_MAT, , cRoteiro,aVerbas, aPerAberto, aPerFechado)           

If len(aVerbasFunc)	>= 1
	For nAux:= 1 to len(aVerbasFunc)			
		cInSS:=Posicione("SRV",1,xFilial("SRV")+aVerbasFunc[nAux,3],"RV_REMUNE" )
		Do Case
			Case PosSRV( aVerbasFunc[nAux,3], SRA->RA_FILIAL, "RV_TIPOCOD" ) == "1" .And. cInSS=="S"
		    	@ Li, 00 PSAY aVerbasFunc[nAux,3]
				@ Li, 09 PSAY fDesc("SRV",aVerbasFunc[nAux,3],"RV_DESC")
				@ Li, 39 PSAY aVerbasFunc[nAux,6] Picture "999.99"         
				@ Li, 58 PSAY aVerbasFunc[nAux,7] Picture "@E 9,999,999.99"
				@ Li, 77 PSAY 0        			  Picture "@E 9,999,999.99"
				@ Li, 96 PSAY 0 				  Picture "@E 9,999,999.99"

		  		nCHaberes += aVerbasFunc[nAux,7]
				SALTO()                                                               
			Case PosSRV( aVerbasFunc[nAux,3], SRA->RA_FILIAL, "RV_TIPOCOD" ) == "1" .And. cInSS=="S"
		    	@ Li, 00 PSAY aVerbasFunc[nAux,3]
				@ Li, 09 PSAY fDesc("SRV",aVerbasFunc[nAux,3],"RV_DESC")
				@ Li, 39 PSAY aVerbasFunc[nAux,6] Picture "999.99"
				@ Li, 58 PSAY 0        			  Picture "@E 9,999,999.99"
				@ Li, 77 PSAY aVerbasFunc[nAux,7] Picture "@E 9,999,999.99"
				@ Li, 96 PSAY 0 				  Picture "@E 9,999,999.99"  
				
		  		nSHaberes += aVerbasFunc[nAux,7]
				SALTO()                                                               
			Case PosSrv( aVerbasFunc[nAux,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "2"
		 		@ Li, 00 PSAY aVerbasFunc[nAux,3]
				@ Li, 09 PSAY fDesc("SRV",aVerbasFunc[nAux,3],"RV_DESC")
				@ Li, 39 PSAY aVerbasFunc[nAux,6] Picture "999.99"      
				@ Li, 58 PSAY 0        			  Picture "@E 9,999,999.99"
				@ Li, 77 PSAY 0  				  Picture "@E 9,999,999.99"
				@ Li, 96 PSAY aVerbasFunc[nAux,7] Picture "@E 9,999,999.99"
				nDescuentos += aVerbasFunc[nAux,7]
				SALTO() 
		EndCase
	Next
	    
Endif  

        
SALTO()
		
@ Li, 40  PSAY "TOTALES LEGAJO"
@ Li, 58  PSAY nCHaberes   Picture "@E 9,999,999.99"
@ Li, 77  PSAY nSHaberes   Picture "@E 9,999,999.99"
@ Li, 96  PSAY nDescuentos Picture "@E 9,999,999.99"
SALTO()
@ Li, 100 PSAY "NETO: "
@ Li, 107 PSAY (nCHaberes+nSHaberes) - nDescuentos Picture "@E 9,999,999.99"

SALTO()

nCant++
nCTotHab   	+=nCHaberes
nSTotHab   	+=nSHaberes
nTotDesc 	+=nDescuentos

@ Li, 00 PSAY __PrtThinLine()

SALTO()

Return
         


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpTotalesºAutor  ³Erika Kanamori      º Data ³  08/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImprTotales()

SALTO() 

@ Li,  00 PSAY "TOTALES EMPRESA"
@ LI,  30 PSAY "EMPLEADOS: "
@ Li,  42 PSAY nCant     Picture "@E 99999999"
@ Li,  58 PSAY nCTotHab  Picture "@E 9,999,999.99"
@ Li,  77 PSAY nSTotHab  Picture "@E 9,999,999.99"
@ Li,  96 PSAY nTotDesc  Picture "@E 9,999,999.99"
SALTO()
@ Li, 100 PSAY "NETO: "
@ Li, 107 PSAY (nCTotHab+nSTotHab) - nTotDesc Picture "@E 9,999,999.99"

Return             
      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SALTO     ºAutor  ³Erika Kanamori      º Data ³  08/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SALTO()
Local cAtivEmp  := If(!Empty(GetMv("MV_ATVEMPR")),GetMv("MV_ATVEMPR"), " ")

Li := Li + 1

If Li > 65
   	Li := 3

	If nTpImp <> 2

	   @ Li, 16 PSAY "HABILITACION DEL REGISTRO DE HOJAS MOVILES EN REEMPLAZO DEL LIBRO ESPECIAL ART. 52§ LEY 20744 (T.O.)"
	   Li := Li + 1
	   @ Li, 18 PSAY Alltrim(SM0->M0_NOMECOM) + Space(10) + Alltrim(SM0->M0_ENDCOB) + Space(10) + Alltrim(SM0->M0_CIDCOB)+ Space(10)+ Alltrim(SM0->M0_CGC)
	   Li := Li + 1
	   @ Li, 36 PSAY cAtivEmp+Space(10)+ STR0018 + ": " + mv_par03  + Space(10) + "Fecha Pago: "+cDatPgt+ space(10) +"Hoja: "+STRZERO(nFolIni,4)
	   Li := Li + 1
	   @ Li, 00 PSAY __PrtFatLine()
	   Li := Li + 1
	EndIf	
   	
   	If nTpImp <> 1   
 		If nTpImp ==2 
   	   		Li := 8
   	   	EndIf		        
		@ Li, 00 PSAY "Matric.   Apellido y Nombre                  Fec.Alta   Fec.Baja   Fec.Nac.    Cuilt       Nacional.      Sexo Estado Civil"
	   Li := Li + 1
	   @ Li, 00 PSAY "Domicilio                                                                                  Categoria "
	//                          1         2         3         4         5         6         7         8         9        10        11
	//                0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	
	   Li := Li + 1
	   @ Li, 00 PSAY "Codigo"
	   @ Li, 09 PSAY "Concepto"
	   @ Li, 40 PSAY "Cant."
	   @ Li, 63 PSAY "Haberes Con"
	   @ Li, 79 PSAY "Haberes Sin"
	   @ Li, 98 PSAY "Descuentos"
	   Li := Li + 1
	   @ Li, 00 PSAY __PrtFatLine()
	   Li := 11          
	EndIf         
	
   	If nTpImp == 3
		nFolIni++
   	EndIf

Endif

Return 
  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Erika Kanamori      º Data ³  08/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSx6() 
Local aArea		:= GetArea()

dbSelectArea("SX6")
dbSetOrder(1)

If !( dbSeek( "  " + "MV_ATVEMPR" ) )
	RecLock("SX6",.T.)
	Replace X6_FIL    With "  "
	Replace X6_VAR    With "MV_ATVEMPR"
	Replace X6_TIPO   With "C"
	
	Replace X6_DESCRIC  With "Parametro que indica o ramo de atividade da Empresa "
	Replace X6_DESC1    With "deve aparecer no relatorio GPER800."
	
	Replace X6_DSCSPA   With "Parametro que indica la actividad de la Empresa"
	Replace X6_DSCSPA1  With "aparecer en el informe GPER800." 
	
	Replace X6_DSCENG   With "This parameter indicates the Company activity  " 
	Replace X6_DSCENG1  With "displayed in GPER800 report.       " 
	MsUnlock()
EndIf

RestArea( aArea )
Return( NIL ) 




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Erika Kanamori      º Data ³  08/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaGPR800() 
Local cPerg 	:= "GPR800"
Local aRegs 	:= {}
Local aHelpPor	:= {}
Local aHelpSpa	:= {}
Local aHelpEng	:= {}
                     
Aadd( aRegs,{ cPerg ,  '01'  , "Processo?"                        , "¿Proceso?"                           , "Process?"                       ,  "mv_ch1" ,  "C" ,    5    ,   0   ,   0   , "G" , "Gpr040Valid(mv_par01)                                 "  , "MV_PAR01" ,  ""    ,    ""   ,    ""   ,  ""   ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "RCJ  ",     " "   ,   "S"   ,  ""       ,   ""       , ""         ,  ".RHPRO." } )
Aadd( aRegs,{ cPerg ,  '02'  , "Roteiro?"                         , "¿Procedimiento?"                     , "Procedure?"                     ,  "mv_ch2" ,  "C" ,    3    ,   0   ,   0   , "G" , "fRoteiro()                                            "  , "MV_PAR02" ,  ""    ,    ""   ,    ""   ,  ""   ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , ""     ,     " "   ,   "S"   ,  ""       ,   ""       , ""         ,  ".RHROT." } )
Aadd( aRegs,{ cPerg ,  '03'  , "Período?"                         , "¿Periodo?"                           , "Period?"                        ,  "mv_ch3" ,  "C" ,    6    ,   0   ,   0   , "G" , "Gpr040Valid(mv_par01 + mv_par02 + mv_par03)           "  , "MV_PAR03" ,  ""    ,    ""   ,    ""   ,  ""   ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "RCH  ",     " "   ,   "S"   ,  ""       ,   ""       , ""         ,  ".RHPER." } )  
Aadd( aRegs,{ cPerg ,  '04'  , "Numero de Pagamento De?"          , "¿De Numero Pago?"                    , "From Payment Number?"           ,  "mv_ch4" ,  "C" ,    2    ,   0   ,   0   , "G" , "                                                      "  , "MV_PAR04" ,  ""    ,    ""   ,    ""   ,  ""   ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "RCH01",     " "   ,   "S"   ,  ""       ,   ""       , ""         ,      ""    } )
Aadd( aRegs,{ cPerg ,  '05'  , "Numero de Pagamento Até?"         , "¿Ate Numero Pago?"                   , "To Payment Number?"             ,  "mv_ch5" ,  "C" ,    2    ,   0   ,   0   , "G" , "                                                      "  , "MV_PAR05" ,  ""    ,    ""   ,    ""   ,  ""   ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "RCH01",     " "   ,   "S"   ,  ""       ,   ""       , ""         ,      ""    } )
Aadd( aRegs,{ cPerg ,  '06'  , "Filial De?"                       , "¿De Sucursal?"                       , "From Branch?"                   ,  "mv_ch6" ,  "C" ,    2    ,   0   ,   0   , "G" , ""  														  , "MV_PAR06" ,  ""    ,    ""   ,    ""   ,  ""   ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "SM0"  ,     " "   ,   "S"   ,  ""       ,   ""       , ""         , ".RHFILDE."} )
Aadd( aRegs,{ cPerg ,  '07'  , "Filial Até"                       , "¿Ate Sucursal?"                      , "To Branch?"                     ,  "mv_ch7" ,  "C" ,    2    ,   0   ,   0   , "G" , "naovazio" 								   			      , "MV_PAR07" ,  ""    ,    ""   ,    ""   ,  ""   ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "SM0"  ,     " "   ,   "S"   ,  ""       ,   ""       , ""         , ".RHFILAT."} )
Aadd( aRegs,{ cPerg ,  '08'  , "Matricula De?"                    , "¿De Matricula?"                      , "From Registration?"             ,  "mv_ch8" ,  "C" ,    6    ,   0   ,   0   , "G" , ""       							       			      , "MV_PAR08" ,  ""    ,    ""   ,    ""   ,  ""   ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "SRA"  ,     " "   ,   "S"   ,  ""       ,   ""       , ""         ,  ".RHMATD."} )
Aadd( aRegs,{ cPerg ,  '09'  , "Matricula Até?"                   , "¿Ate Matricula?"                     , "To Registration?"               ,  "mv_ch9" ,  "C" ,    6    ,   0   ,   0   , "G" , "naovazio"          									      , "MV_PAR09" ,  ""    ,    ""   ,    ""   ,  ""   ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , "SRA"  ,     " "   ,   "S"   ,  ""       ,   ""       , ""         ,  ".RHMATA."} )

aHelpSPA := { 	"Tipo de impresión:" 				,;
				"1-Cabecera: imprime solamente"		,;
				"a cabecera"						,;
				"2-Cuerpo Solamente: imprime todos"	,;
				"los datos del empleado, pero no se",;
				"imprime la cabecera"				,;
				"3-Completo: imprime la cabecera y"	,;
				"el cuerpo del libro ley." }
				
aHelpPOR := { 	"Tipo de impressao:"			,;
				"1-Cabeçalho: imprime somente"	,;
				"o cabeçalho"					,;
				"2-Somente corpo: imprime todos",;
				"os dados do funcionario, lançamentos",;
				"mas não imprime o cabeçalho"	,;
				"3-Completo: imprime o cabeçalho e o" ,;
				"corpo do livro lei."	}
				
Aadd( aRegs,{ cPerg ,  '10'  , "Tipo impressao?"                  , "¿Tipo de Impresion?"                 , "Print type  ?"                  ,  "mv_chA" ,  "C" ,    1    ,   0   ,   0   , "C" , "" 								   			              , "MV_PAR10" ,"1-Cabeçalho" ,"1-Cabecera","1-Header"   ,""   ,  " "  ,"2-Somente Corpo","2-Cuerpo Solamente","2-Body Only"," "   ,  " "  ,  "3-Completo",  "3-Completo","3-Complete "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , ""     ,     " "   ,   "S"   , aHelpPor      ,   aHelpEng       , aHelpSpa         ,""} )

aHelpPOR := { 	"Informe a numeracao da folha inicial ",;
				"do livro lei" }
aHelpSPA := { 	"Informar la numeracion inicial ",;
				"del libro lei" }
Aadd( aRegs,{ cPerg ,  '11'  , "Folha Inicial"                    , "¿Hoja inicial"                        , "First Sheet"                    ,  "mv_chB" ,  "N" ,    4   ,   0   ,   0   , "G" , "" 								   			              , "MV_PAR11" ,  ""    ,    ""   ,    ""   ,""  	      ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , ""  ,     " "   ,   "S"   ,  aHelpPor      ,   ""       , aHelpSpa         ,""} )

aHelpPOR := { 	"Informe quantidade de folhas a       ",;
				"imprimir." ,;
				"Esta pergunta so sera utilizada ",;
				"quando a pergunta 'Tipo de impressao'" ,;
				"for igual a '1-Cabecalho'"}
aHelpSPA := { 	"Informar la cantidade de hojas ",;
				"para imprimir." ,;
				"Esta pregunta solo se utiliza cuando" ,;
				"la pregunta 'Tipo impresion' es igual" ,;
				"a '1-Cabecera'"}
Aadd( aRegs,{ cPerg ,  '12'  , "Quantidade de Folhas"             , "¿Cantidad Hojas"                      , "Amount Sheet"                    ,  "mv_chC",  "N" ,    4   ,   0   ,   0   , "G" , "" 								   			              , "MV_PAR12" ,  ""    ,    ""   ,    ""   ,""  	      ,  " "  ,   ""          ,   ""   ,  ""   ,   " "   ,  " "  ,  " "         ,  " "   ,   " "   ,   " "   ,  " "   ,  " "  ,    " "   ,    " "   ,    " "    ,   " "   ,   " "   ,    " "    ,    " "    ,   " "   , ""  ,     " "   ,   "S"   ,  aHelpPor       ,   ""       , aHelpSpa         ,""} )

ValidPerg(aRegs,cPerg,.F.)			//-- Inclui Pergunta    

Return


