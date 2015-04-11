/*
Exemplo de utilização da função MPReport 
Revisão: 03/05/2006
Abrangência
Versão 8.11
Para utilizar o exemplo abaixo verifique se o seu repositório está com Release 4 do Protheus
*/
#include "protheus.ch"

User Function MyReport1()

//Informando o vetor com as ordens utilizadas pelo relatório

MPReport("MYREPORT1","SA1","Relacao de Clientes","Este relatório irá imprimir a relacao de clientes",{"Por Codigo","Alfabetica","Por "+RTrim(RetTitle("A1_CGC"))})
Return

User Function MyReport2()

//Informando para função carregar os índices do Dicionário de Índices (SIX) da tabela

MPReport("MYREPORT2","SA1","Relacao de Clientes","Este relatório irá imprimir a relacao de clientes",,.T.)
Return
