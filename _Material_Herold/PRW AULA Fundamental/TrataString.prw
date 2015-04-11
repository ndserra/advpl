User Function Trata()

Set Date To British  // Data no formato DD/MM/AA

Set Epoch To 1943    // DD/MM/43 a DD/MM/99 --> 1943 a 1999
                     // DD/MM/00 a DD/MM/42 --> 2000 a 2042

/////////////////////////////////////////////////////////////////////
// Tratamento de caracters                                         //
/////////////////////////////////////////////////////////////////////

// Trim(cString): retira espaços da direita.
// Trim("   Jose   ") -> "   Jose"

// LTrim(cString): retira espaços da esquerda.
// LTrim("   Maria   ") -> "Maria   "

// RTrim(cString): retira espaços da direita.
// RTrim("   Maria   ") -> "   Maria"

// AllTrim(cString): retira espaços da direita e da esquerda.
// AllTrim("   Sao Paulo   ") -> "Sao Paulo"

// Left(cString, nCaracteres): retorna N caracteres da esquerda.
// Left("Abcdef", 3) -> "Abc"

// Right(cString, nCaracteres): retorna N caracteres da direita.
// Right("Abcdef", 2) -> "ef"

// Substr(cString, nPosicao, nCaracteres): retorna N caracteres a partir de uma posição.
// Substr("Programa", 3, 2) -> "og"

// Stuff(cString, nPosicao, nSubstituir, cTexto): substitui e incrementa caracteres para
//                                                dentro de uma string.
// Stuff("ABCDE", 3, 2, "123") -> "AB123E"  substitui "CD" por "123"

// PadR(cString, nTamanho, cCaracter) -> Inclui o caracter na direita da string, ate o
//                                       tamanho especificado.
// PadL(cString, nTamanho, cCaracter) -> Inclui o caracter na esquerda da string, ate o
//                                       tamanho especificado.
// PadC(cString, nTamanho, cCaracter) -> Inclui o caracter na direita e na esquerda da string, ate o
//                                       tamanho especificado.
// PadR("ABC", 10, "*") -> "ABC*******"
// PadL("ABC", 10, "*") -> "*******ABC"
// PadC("ABC", 10, "*") -> "***ABC****"

// Replicate(cString, nVezes): replica a String.
// Replicate("*", 5) -> "*****"
// Replicate("Abc/", 5) -> "Abc/Abc/Abc/Abc/Abc/"

// At(cProcura, cString, nApos): retorna a posição da primeira ocorrencia de cProcura em cString,
//                               apos a posicao nApos. Se nApos for omitido, procura desde o inicio.
// At("a", "abcde")   -> 1
// At("cde", "abcde") -> 3
// At("a", "bcde")    -> 0
// At("A", "MARIANO") -> 2

// RAt(cProcura, cString): retorna a posição da ultima ocorrencia de cProcura em cString.
// RAt("A", "MARIANO") -> 5

// $: pertence.
// "a" $ "Maria"     -> .T.
// "A" $ "Maria"     -> .F.
// "ana" $ "Mariana" -> .T.

// Upper(cString): retorna cString em maiúscula.
// Upper("Maria") -> "MARIA"

// Lower(cString): retorna cString em minúscula.
// Lower("AbCdE") -> "abcde"

// Len(cString): retorna a quantidade de caracteres em cString.
// Len( {"Jose", "Maria", "Joao"} ) -> 3 elementos
// Len("Maria")                     -> 5 caracteres
// Len(SA1->A1_Nome)                -> tamanho do campo.

// Space(n): retorna n espaços. Utilizado para inicializar variaveis do tipo caracter.
// Space(10) -> "          "
// cNome := Space(30)

// Capital(cTexto): retorna o texto com a primeira letra de cada palavra em maiuscula.
// Capital("TEXTO") -> "Texto"
// Capital("jose da silva") -> "Jose Da Silva"

/////////////////////////////////////////////////////////////////////
// Tratamento de numeros                                           //
/////////////////////////////////////////////////////////////////////

// Str(nNumero, nTamanho, nDecimal): converte um número para caracter.
// Str(500)       -> "              500"
// Str(500, 8, 2) -> "  500.00"

// StrZero(nNumero, nTamanho, nDecimal): converte um número para caracter preenchendo com zeros à esquerda.
// StrZero(1528.35, 10, 2) -> "0001528.35"

// Val(cNumero): converte um caracter para número.
// Val("123456") -> 123456

// Transform(nNumero, cPicture): converte um número para caracter com máscara de edição.
// Transform(1528.35, "999,999.99")    -> "  1,528.35"
// Transform(1528.35, "@E 999,999.99") -> "  1.528,35"

// Extenso(nValor[,lQuantid][,nMoeda][,cPrefixo][,cIdioma][,lCent][,lFrac])
// Retorna valor por extenso (só funciona via Remote pois usa o arquivo SX6).

/////////////////////////////////////////////////////////////////////
// Tratamento de datas e hora                                      //
/////////////////////////////////////////////////////////////////////

// Date(): obtem a data da maquina.

// CtoD(cData): converte uma string em data.
// CtoD("12/08/05")     -> 12/08/2005 (em formato Data)
// CtoD("12/08/05") + 5 -> 17/08/2005

// DtoC(dData): converte uma data em string.
// DtoC(Date()) -> data da maquina em formato "DD/MM/AA" caracter.

// DtoS(dData): converte uma data em string, no formato "AAAAMMDD"
// DtoS(CtoD("28/03/05")) -> "20050328"

// DOW(dData): retorna o dia da semana de uma data (1-domingo, 2-segunda, ..., 7-sabado)
// DOW(CtoD("15/04/05")) -> 6 (sexta-feira)

// Day(dData): retorna o dia de uma data.
// Day(CtoD("28/03/05")) -> 28

// Month(dData): retorna o mes de uma data.
// Month(CtoD("28/03/05")) -> 3

// Year(dData): retorna o ano de uma data.
// Year(CtoD("28/03/05")) -> 2005

// Time(): retorna a hora atual no formato "HH:MM:SS"

// Elaptime(Hora Ini, Hora Fin): retorna o tempo decorrido.

Return( NIL )