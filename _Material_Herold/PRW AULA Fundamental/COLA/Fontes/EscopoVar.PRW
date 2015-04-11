#Include "RWMake.ch"

//----------------------------------------------------------------------------------------------------------------// 
// Escopo de variaveis.
//----------------------------------------------------------------------------------------------------------------// 

User Function Func1()

Local cVar := "Func1"

u_Func2()

Return

//----------------------------------------------------------------------------------------------------------------// 
User Function Func2()

Local cVar := "Func2"
Local cVar1 := "Func2"
Private cVar2 := "Private Func2"

u_Func3()

Return

//----------------------------------------------------------------------------------------------------------------// 
User Function Func3()

Local cVar := "Func3"
Public cVar3 := "Public Func3"
                                
Return

//----------------------------------------------------------------------------------------------------------------// 


//Mostrar depois - Incluir em Func3: Private cVar2 := "Private Func3"

//Mostrar depois - Incluir em Func2: Static cVar4 := "Static Func2"
//Mostrar depois - Incluir em Func3: Static cVar4 := "Static Func3"


// Se declarar uma variavel como LOCAL e depois declarar a mesma variavel
// como PRIVATE, continua como LOCAL.