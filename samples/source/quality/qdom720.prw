#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/06/00

User Function qdom720()        // incluido pelo assistente de conversao do AP5 IDE em 26/06/00

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³QDOM720   ³ Autor ³ Programcao Quality    ³ Data ³ 14/09/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Transfere os valores das var. de memoria para var. do word  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ 			                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Variaveis do .DOT Padrao
OLE_SetDocumentVar( oWord, "Adv_CopiaControlada", cTpCopia )                                             	//02 - Copia Controlada
OLE_SetDocumentVar( oWord, "Adv_Cancel"         , If( M->QDH_CANCEL == 'S','Documento Cancelado',' ' ) ) //03 - Cancelado
OLE_SetDocumentVar( oWord, "Adv_Obsoleto"       , If( M->QDH_OBSOL  == 'S','Documento Obsoleto' ,' ' ) ) //04 - Obsoleto
OLE_SetDocumentVar( oWord, "Adv_DataVigencia"   , DtoC( M->QDH_DTVIG ) )                                 	//05 - Data de Vigencia
OLE_SetDocumentVar( oWord, "Adv_NUsrR"          , cNomRece )                                             	//08 - Destinatario
If Empty( cNomRece )
   OLE_SetDocumentVar( oWord, "Adv_NDeptoR"     , " " )
Else                                                                                                        	//09 - Departamento do Destinatario ( Nome )
   OLE_SetDocumentVar( oWord, "Adv_NDeptoR"     , QA_NDEPT( cDepRece,.T.,QDG->QDG_FILMAT) )     
Endif
OLE_SetDocumentVar( oWord, "Adv_Rodape"         , cRodape )                                              	//18 - Rodape
OLE_SetDocumentVar( oWord, "Adv_NDeptoD"        , QA_nDeptos( M->QDH_FILIAL, M->QDH_DOCTO, M->QDH_RV ) )	//10 - Departamento Recebedores - Distribuicao ( Nome )

// Outras variaveis ja definidas que podem ser utilizadas
/*
OLE_SetDocumentVar( oWord, "Adv_NomeFilial",         cNomFilial )                                           	//01 - Filial do Sistema
OLE_SetDocumentVar( oWord, "Adv_DTpDoc",             QDXFNANTPD( M->QDH_CODTP, .t. ) )                         //04 - Tipo
OLE_SetDocumentVar( oWord, "Adv_Titulo",             M->QDH_TITULO )                                        	//06 - Titulo
OLE_SetDocumentVar( oWord, "Adv_Objetivo",           cObjetivo )                                            	//07 - Objetivo
OLE_SetDocumentVar( oWord, "Adv_NDeptoD",            QA_nDeptos( M->QDH_FILIAL, M->QDH_DOCTO, M->QDH_RV ) ) 	//10 - Departamento Recebedores - Distribuicao ( Nome )
OLE_SetDocumentVar( oWord, "Adv_Sumario",            cSumario )                                             	//11 - Sumario
OLE_SetDocumentVar( oWord, "Adv_MotivoRevisao",      cMotRevi )                                             	//12 - Motivo da Revisao
OLE_SetDocumentVar( oWord, "Adv_ApelidoElaborador",  cApElabo )                                             	//13 - Elaboradores( Apelido )
OLE_SetDocumentVar( oWord, "Adv_ApelidoRevisor",     cApRevis )                                             	//14 - Revisores( Apelido )
OLE_SetDocumentVar( oWord, "Adv_ApelidoAprovador",   cApAprov )                                             	//15 - Aprovadores( Apelido )
OLE_SetDocumentVar( oWord, "Adv_Docto",              Alltrim( M->QDH_DOCTO ) )                              	//16 - Codigo do Documento
OLE_SetDocumentVar( oWord, "Adv_Rv",                 M->QDH_RV )                                            	//17 - Numero da Revisao
OLE_SetDocumentVar( oWord, "Adv_ApelidoHomologador", cApHomol )                                             	//19 - Homologador ( Apelido )
OLE_SetDocumentVar( oWord, "Adv_ApelidoDestino",     QA_nUsr( cFilApDes, cCodApDes, .t., "A" ) )            	//20 - Destinatario ( Apelido ) 
OLE_SetDocumentVar( oWord, "Adv_ApelidoSolicitante", QA_nUsr( cFilApSol, cCodApSol, .t., "A" ) )            	//21 - Solicitante ( Apelido ) *** Quando de uma solicitacao de alteracao ***
OLE_SetDocumentVar( oWord, "Adv_Elaborador",         cElabora )                                             	//22 - Elaborador ( Nome )
OLE_SetDocumentVar( oWord, "Adv_Revisor",            cRevisor )                                             	//23 - Revisor ( Nome )
OLE_SetDocumentVar( oWord, "Adv_Aprovador",          cAprovad )                                             	//24 - Aprovador ( Nome )
OLE_SetDocumentVar( oWord, "Adv_Homologador",        cHomolog )                                             	//25 - Homologador ( Nome ) 
OLE_SetDocumentVar( oWord, "Adv_Ass1",               QDXFNANASS( M->QDH_CODASS, .t. ) )                        //26 - Assunto ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_Ass2",               QDXFNANASS( M->QDH_CODAS1, .t. ) )                        //27 - Assunto 1 ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_Ass3",               QDXFNANASS( M->QDH_CODAS2, .t. ) )                        //28 - Assunto 2 ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_Ass4",               QDXFNANASS( M->QDH_CODAS3, .t. ) )                        //29 - Assunto 3 ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_Ass5",               QDXFNANASS( M->QDH_CODAS4, .t. ) )                        //30 - Assunto 4 ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_CRespR",             SI3->I3_MAT )                                          	//34 - Responsavel pelo Centro de Custo ( Matricula )
OLE_SetDocumentVar( oWord, "Adv_DeptoD",             M->QDH_DEPTOD )                                        	//35 - Departamento Recebedores - Distribuicao ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_DeptoE",             M->QDH_DEPTOE )                                        	//36 - Departamento Elaborador ( Codigo ) 
OLE_SetDocumentVar( oWord, "Adv_NDeptoE",            QA_nDept( M->QDH_DEPTOE, .t., M->QDH_FILMAT ) )        	//37 - Departamento Elaborador ( Nome )
OLE_SetDocumentVar( oWord, "Adv_CPastaR",            QDG->QDG_CODMAN )                                      	//38 - Pasta ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_NPastaR",            QDXFNANMAN( QDG->QDG_CODMAN, .t., QDJ->QDJ_FILMAT ) )     //39 - Pasta ( Nome )
OLE_SetDocumentVar( oWord, "Adv_DeptoR",             QDG->QDG_DEPTO )                                       	//40 - Departamento do Destinatario ( Codigo )
OLE_SetDocumentVar( oWord, "Adv_NRespR",             QA_nUsr( SI3->I3_FILMAT, SI3->I3_MAT ) )               	//41 - Responsavel pelo Departamento doDestinatario ( Nome )
OLE_SetDocumentVar( oWord, "Adv_DataEmissao",        DtoC( cDtEmiss ) )                                     	//42 - Data de Emissao
OLE_SetDocumentVar( oWord, "Adv_DataValidade",       DtoC( M->QDH_DTLIM ) )                                 	//43 - Data de Validade
OLE_SetDocumentVar( oWord, "Adv_DataImplantacao",    DtoC( M->QDH_DTIMPL ) )                                	//44 - Data de Implantacao
OLE_SetDocumentVar( oWord, "Adv_DataDistribuicao",   DtoC( QD1->QD1_DTGERA ) )                              	//45 - Data de Distribuicao
*/

Return 

