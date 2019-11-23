
/*
  Representacion grafica de una mina irregular con 14 filas y 13 columnas:

     1   2   3   4
   _________________
1  | ~ | P | ~ | ~ |
   |___|___|___|___|
2  | ~ | ~ |   | ! |                    10  11  12  13
   |___|___|___|___|                   ________________
3  |   |   | P | ~ |                   | ~ | ~ | ~ | ~ | 3
   |___|___|___|___|                   |___|___|___|___|
4  | ~ |   | ~ | P | 5   6   7   8   9 |   |   |   |   | 4
   |___|___|___|___|___________________|___|___|___|___|
5  |   | R2| ~ | P |   | ~ | ! | L2| ~ |   | ! | P | ~ | 5
   |___|___|___|___|___|___|___|___|___|___|___|___|___|
6  |   | D | V1| ~ | P | C |   |   | ~ |   | V5|   |   | 6
   |___|___|___|___|___|___|___|___|___|___|___|___|___|
7  |   | P | V2|   | P | ~ | V2| ~ | ~ | R3|   |   | ~ | 7
   |___|___|___|___|___|___|___|___|___|___|___|___|___|
8  | ~ |   |   |   | ~ | ~ |   | P | P | P | ~ | V4|   | 8
   |___|___|___|___|___|___|___|___|___|___|___|___|___|
9  | ~ | V5|   | ~ |   | L1| ~ |   | ~ |   | ~ | V7|   | 9
   |___|___|___|___|___|___|___|___|___|___|___|___|___|
10 |   |   |   |   | ~ | # |   | ~ |
   |___|___|___|___|___|___|___|___|
11 | ~ |   |   | V3|   | ~ |   | V1|
   |___|___|___|___|___|___|___|___|____________
12 | ~ | ! | ~ | P |   | V3|   | P | L3|   | ~ | 12
   |___|___|___|___|___|___|___|___|___|___|___|
13 |   |   | ~ | P |   |   |   | R1| ! | P |   | 13
   |___|___|___|___|___|___|___|___|___|___|___|
14 |   |   | ~ |   | ~ |   |   |   | ~ | P |   | 14
   |___|___|___|___|___|___|___|___|___|___|___|

     1   2   3   4   5   6   7   8   9  10  11


-----------------------------------------------
Referencias de Suelo:

 ____
 |   | : Celda con suelo firme
 |___|

 ____
 | ~ | : Celda con suelo resbaladizo
 |___|

 ____
 | # | : Sitio de colocacion de carga explosiva
 |___|

 ____
 | ! | : Posicion para la detonacion
 |___|


-----------------------------------------------
Referencias de Objetos:

 Ri: Reja i

 Li: Llave i

 C: Carga Explosiva

 D: Detonador

 P: Pilar

 Vi: Valla con altura i

-----------------------------------------------
IMPORTANTE: Para aquellas celdas que albergan objetos (reja, llave, carga, detonador, pilar o valla)
la grilla dibujada no ilustra el tipo de suelo de la celda (debe observarse en la coleccion de hechos
definida a continuacion).

*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
    Configuracion de la mina ilustrada

    Coleccion de Hechos celda/2, estaEn/2, ubicacionCarga/2, sitioDetonacion/1 y abreReja/2:
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Celdas de la mina:

celda([1,1], resbaladizo).
celda([1,2], firme).
celda([1,3], resbaladizo).
celda([1,4], resbaladizo).

celda([2,1], resbaladizo).
celda([2,2], resbaladizo).
celda([2,3], firme).
celda([2,4], resbaladizo).

celda([3,1], firme).
celda([3,2], firme).
celda([3,3], resbaladizo).
celda([3,4], resbaladizo).
celda([3,10], resbaladizo).
celda([3,11], resbaladizo).
celda([3,12], resbaladizo).
celda([3,13], resbaladizo).

celda([4,1], resbaladizo).
celda([4,2], firme).
celda([4,3], resbaladizo).
celda([4,4], firme).
celda([4,10], firme).
celda([4,11], firme).
celda([4,12], firme).
celda([4,13], firme).

celda([5,1], firme).
celda([5,2], firme).
celda([5,3], resbaladizo).
celda([5,4], firme).
celda([5,5], firme).
celda([5,6], resbaladizo).
celda([5,7], resbaladizo).
celda([5,8], firme).
celda([5,9], resbaladizo).
celda([5,10], firme).
celda([5,11], firme).
celda([5,12], firme).
celda([5,13], resbaladizo).

celda([6,1], firme).
celda([6,2], firme).
celda([6,3], firme).
celda([6,4], resbaladizo).
celda([6,5], firme).
celda([6,6], firme).
celda([6,7], firme).
celda([6,8], firme).
celda([6,9], resbaladizo).
celda([6,10], firme).
celda([6,11], resbaladizo).
celda([6,12], firme).
celda([6,13], firme).

celda([7,1], firme).
celda([7,2], firme).
celda([7,3], resbaladizo).
celda([7,4], firme).
celda([7,5], resbaladizo).
celda([7,6], resbaladizo).
celda([7,7], firme).
celda([7,8], resbaladizo).
celda([7,9], resbaladizo).
celda([7,10], resbaladizo).
celda([7,11], firme).
celda([7,12], firme).
celda([7,13], resbaladizo).

celda([8,1], resbaladizo).
celda([8,2], firme).
celda([8,3], firme).
celda([8,4], firme).
celda([8,5], resbaladizo).
celda([8,6], resbaladizo).
celda([8,7], firme).
celda([8,8], firme).
celda([8,9], firme).
celda([8,10], firme).
celda([8,11], resbaladizo).
celda([8,12], firme).
celda([8,13], firme).

celda([9,1], resbaladizo).
celda([9,2], resbaladizo).
celda([9,3], firme).
celda([9,4], resbaladizo).
celda([9,5], firme).
celda([9,6], firme).
celda([9,7], resbaladizo).
celda([9,8], firme).
celda([9,9], resbaladizo).
celda([9,10], firme).
celda([9,11], resbaladizo).
celda([9,12], firme).
celda([9,13], firme).

celda([10,1], firme).
celda([10,2], firme).
celda([10,3], firme).
celda([10,4], firme).
celda([10,5], resbaladizo).
celda([10,6], firme).
celda([10,7], firme).
celda([10,8], resbaladizo).

celda([11,1], resbaladizo).
celda([11,2], firme).
celda([11,3], firme).
celda([11,4], resbaladizo).
celda([11,5], firme).
celda([11,6], resbaladizo).
celda([11,7], firme).
celda([11,8], firme).

celda([12,1], resbaladizo).
celda([12,2], resbaladizo).
celda([12,3], resbaladizo).
celda([12,4], firme).
celda([12,5], firme).
celda([12,6], firme).
celda([12,7], firme).
celda([12,8], firme).
celda([12,9], firme).
celda([12,10], firme).
celda([12,11], resbaladizo).

celda([13,1], firme).
celda([13,2], firme).
celda([13,3], resbaladizo).
celda([13,4], firme).
celda([13,5], firme).
celda([13,6], firme).
celda([13,7], firme).
celda([13,8], firme).
celda([13,9], resbaladizo).
celda([13,10], resbaladizo).
celda([13,11], firme).

celda([14,1], firme).
celda([14,2], firme).
celda([14,3], resbaladizo).
celda([14,4], firme).
celda([14,5], resbaladizo).
celda([14,6], firme).
celda([14,7], firme).
celda([14,8], firme).
celda([14,9], resbaladizo).
celda([14,10], resbaladizo).
celda([14,11], firme).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Objetos en la mina:

% Rejas:
estaEn([r, r1], [13,8]).
estaEn([r, r2], [5,2]).
estaEn([r, r3], [7,10]).

% Llaves:
estaEn([l, l1], [9,6]).
estaEn([l, l2], [5,8]).
estaEn([l, l3], [12,9]).

% Carga:
estaEn([c, c1], [6,6]).

% Detonador:
estaEn([d, d1, no], [6,2]).

% Pilares:
estaEn([p, p1, 3], [1,2]).
estaEn([p, p2, 5], [3,3]).
estaEn([p, p3, 7], [4,4]).
estaEn([p, p4, 6], [5,4]).
estaEn([p, p5, 9], [5,12]).
estaEn([p, p6, 8], [6,5]).
estaEn([p, p7, 2], [7,2]).
estaEn([p, p8, 4], [7,5]).
estaEn([p, p9, 5], [8,8]).
estaEn([p, p10, 6], [8,9]).
estaEn([p, p11, 8], [8,10]).
estaEn([p, p12, 2], [12,4]).
estaEn([p, p13, 5], [12,8]).
estaEn([p, p14, 13], [13,4]).
estaEn([p, p15, 8], [13,10]).
estaEn([p, p16, 4], [14,10]).

% Vallas:
estaEn([v, v1, 1], [6,3]).
estaEn([v, v2, 5], [6,11]).
estaEn([v, v3, 2], [7,3]).
estaEn([v, v4, 2], [7,7]).
estaEn([v, v5, 4], [8,12]).
estaEn([v, v6, 5], [9,2]).
estaEn([v, v7, 7], [9,12]).
estaEn([v, v8, 3], [11,4]).
estaEn([v, v9, 1], [11,8]).
estaEn([v, v10, 3], [12,6]).


% Sitio donde debe ser ubicada la Carga
ubicacionCarga([10,6]).

% Sitios habilitados para efectuar la detonacion
sitioDetonacion([2,4]).
sitioDetonacion([5,7]).
sitioDetonacion([5,11]).
sitioDetonacion([12,2]).
sitioDetonacion([13,9]).

% Indicador de que llave abre que reja
abreReja([l, l1], [r, r2]).
abreReja([l, l2], [r, r3]).
abreReja([l, l3], [r, r1]).

/*---------------------------------------------------------------------------------*/
/*------------------------ESTADOS DEL MINERO---------------------------------------*/
/*---------------------------------------------------------------------------------*/
% grafo(+EstadoActual, -EstadoNuevo, -Operacion, -Costo).

/* Operacion para caminar. */
grafo(EstadoActual, EstadoNuevo, caminar, Costo):- 
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    
    % De acuerdo a la dirección del minero, se obtiene la posición [Xn, Yn]
    ((Dir == n, Xn is X-1, Yn is Y); (Dir == s, Xn is X+1, Yn is Y);       
    (Dir == o, Xn is X, Yn is Y-1); (Dir == e, Xn is X, Yn is Y+1)),  
    
    %Se obtiene el tipo de suelo, y partir de eso, su costo asociado
    celda([Xn,Yn], TipoSuelo),
    ((TipoSuelo = firme, Costo is 2); (TipoSuelo = resbaladizo, Costo is 3)), 
    
    % No debe haber obstaculos en la nueva posicion. Solo rejas que pueden abrirse (con su correspondiente llave)
    not(estaEn([p, _Pilar, _AlturaPilar], [Xn, Yn])),                         
    not(estaEn([v, _Valla, _AlturaValla], [Xn, Yn])),                         
    (
        (not(estaEn([r, _Reja],[Xn,Yn])));                                    
        (estaEn([r, Reja],[Xn,Yn]), member([l,Llave], ListadoPosesiones), abreReja([l,Llave],[r,Reja])) 
    ),
    
    % Se obtiene el estado siguiente del minero, con la nueva posición
    EstadoNuevo = estado([Xn,Yn], Dir, ListadoPosesiones, ColocacionCargaPendiente). 


/* Operacion para rotar(Dir). */
grafo(EstadoActual, EstadoNuevo, rotar(Dir), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], DirVieja, ListadoPosesiones, ColocacionCargaPendiente),
    
    % La dirección solo puede ser [n, s, e, o]
    member(Dir, [n, s, e, o]),
    
    % La direccion nueva debe diferir de la actual
    (DirVieja \= Dir),           
    
    % Distintas configuraciones de rotación, y el costo asociado a cada uno
    (                                                                              
     (DirVieja == n, Dir == s, Costo = 2);
     (DirVieja == n, Dir == e, Costo = 1);
     (DirVieja == n, Dir == o, Costo = 1);
     (DirVieja == s, Dir == n, Costo = 2);
     (DirVieja == s, Dir == e, Costo = 1);
     (DirVieja == s, Dir == o, Costo = 1);
     (DirVieja == e, Dir == o, Costo = 2);
     (DirVieja == e, Dir == n, Costo = 1);
     (DirVieja == e, Dir == s, Costo = 1);
     (DirVieja == o, Dir == e, Costo = 2);
     (DirVieja == o, Dir == n, Costo = 1);
     (DirVieja == o, Dir == s, Costo = 1)
    ),
    
    % Se obtiene el estado siguiente del minero, con la nueva dirección
    EstadoNuevo = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente).      

/* Operacion para saltar(Dir) */
grafo(EstadoActual, EstadoNuevo, saltar_valla(Valla), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    
    % se obtiene la valla, que debe estar en la posición adyacente a la actual
    Valla = [v, _NombreV, AlturaV],                                                
    celda([XNew,YNew], _TipoSuelo),
    estaEn(Valla, [XNew, YNew]),
    
    %La altura es menor a 4, entonces puede saltarla
    AlturaV =< 4,
    
    %No es un pilar ni una reja
    not(estaEn([p,_,_],[XNew,YNew])),
    not(estaEn([r,_],[XNew,YNew])),                                                
    
    % Se crea un estado intermedio (que no forma parte del plan), solo para caer en la celda siguiente a la de la valla
    EstadoIntermedio1 = estado([XNew,YNew], Dir, ListadoPosesiones, ColocacionCargaPendiente),   
    grafo(EstadoIntermedio1, EstadoIntermedio2, caminar, CostoSalto),
    EstadoIntermedio2 = estado([XSalto,YSalto], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    
    % El costo asociado al salto es el costo la celda en que cayó, mas uno.
    Costo is CostoSalto+1,
    
    % La dirección determina la celda que va a saltar
    ((Dir == n, XNew is X-1, YNew is Y); (Dir == s, XNew is X+1, YNew is Y);       
    (Dir == o, XNew is X, YNew is Y-1); (Dir == e, XNew is X, YNew is Y+1)),
    
    % Se obtiene el estado siguiente del minero, con la celda adyacente a la valla que saltó
    EstadoNuevo = estado([XSalto,YSalto], Dir, ListadoPosesiones, ColocacionCargaPendiente).


/* Operacion para juntar_llave(Llave) */
grafo(EstadoActual, EstadoNuevo, juntar_llave(Llave), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    
    % La llave tiene que estar en la posición actual del minero
    Llave = [l, _NombreL],
    estaEn(Llave, [X,Y]),
    
    % El costo asociado a juntar la llave es 1
    Costo = 1,
    
    % El minero no debe tener la llave entre sus posesiones
    not(member(Llave, ListadoPosesiones)),
    
    % Se obtiene el estado siguiente del minero, con la nueva llave
    EstadoNuevo = estado([X,Y], Dir, [Llave | ListadoPosesiones], ColocacionCargaPendiente).

/* Operacion para juntar_carga(Carga) */
grafo(EstadoActual, EstadoNuevo, juntar_carga(Carga), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, _),
    
    % La carga tiene que estar en la posición actual del minero
    Carga = [c, _NombreC],
    estaEn(Carga, [X,Y]),   
    
    % El minero no debe tener la carga entre sus posesiones
    not(member(Carga, ListadoPosesiones)),
    
    % El costo asociado a juntar la carga es 3
    Costo = 3,                              
    
    % Se obtiene el estado siguiente del minero, con la nueva carga, seteando en 'si' el indicador de colocar la carga
    EstadoNuevo = estado([X,Y], Dir, [Carga | ListadoPosesiones], 'si').

/* Operacion para dejar_carga(Carga) */
grafo(EstadoActual, EstadoNuevo, dejar_carga(Carga), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, 'si'),
    
    % El minero debe estar en la ubicación donde debe dejar la carga
    ubicacionCarga([X,Y]),
    
    % La carga debe estar entre las posesiones del minero
    member(Carga, ListadoPosesiones),
    
    %El costo asociado a dejar la carga es 1
    Costo = 1,
    
    % Se obtiene el estado siguiente del minero, seteando en 'no' el indicador de colocar carga
    EstadoNuevo = estado([X,Y], Dir, ListadoPosesiones, 'no').

/* Operacion para juntar_detonador(Detonador) */ 
grafo(EstadoActual, EstadoNuevo, juntar_detonador(Detonador), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    
    % El detonador tiene que estar en la posición actual del minero
    Detonador = [d, _NombreD, no],
    estaEn(Detonador, [X,Y]),
    
    % El minero no debe tener el detonador entre sus posesiones
    not(member(Detonador, ListadoPosesiones)),
    
    % El costo asociado a juntar el detonador es 2
    Costo = 2,
    
    % Se obtiene el estado siguiente del minero, con el nuevo detonador
    EstadoNuevo = estado([X,Y], Dir, [Detonador | ListadoPosesiones], ColocacionCargaPendiente).

/* Operacion para detonar(Detonador) */
grafo(EstadoActual, EstadoNuevo, detonar(Detonador), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, no),
    
    % El minero debe tener el detonador entre sus posesiones, sin detonar
    Detonador = [d, NombreD, si],
    member([c,c1], ListadoPosesiones),
    member([d, NombreD, no], ListadoPosesiones),
    not(member([d, NombreD, si], ListadoPosesiones)),
    sitioDetonacion([X,Y]),
    
    % El costo asociado a detonar es 1
    Costo = 1,
    
    % Se obtiene el estado siguiente del minero, seteando en 'si' el detonador
    EstadoNuevo = estado([X,Y], Dir, [[d, NombreD, si] | ListadoPosesiones], no).

/*---------------------------------------------------------------------------------*/
/*-------------------------------METAS DEL MINERO----------------------------------*/
/*---------------------------------------------------------------------------------*/

/* Tiene que encontrar la carga */
esMeta(Estado, juntar_carga(_)):-
   Estado = estado([X,Y], _, ListadoPosesiones, _),
   member([c, Carga], ListadoPosesiones),
   estaEn([c, Carga], [X,Y]).

/* Ya coloco la carga y debe buscar el detonador */
esMeta(Estado, juntar_detonador(_)):-
   Estado = estado([X,Y], _, ListadoPosesiones, _),
   member([d, Detonador, no], ListadoPosesiones),
   estaEn([d, Detonador, no], [X,Y]).

/* Ya encontro la carga y tiene que ubicarla */
esMeta(Estado, dejar_carga(_)):-
   Estado = estado([X,Y], _, ListadoPosesiones, no),
   member([c, _], ListadoPosesiones),
   ubicacionCarga([X,Y]).

/* Ya encontro el detonador y debe ir al sitio de detonacion */
esMeta(Estado, detonar(Detonador)):-
   Estado = estado([X,Y], _, ListadoPosesiones, no),
   Detonador = [d, D1, si],
   member([c, c1], ListadoPosesiones),
   member([d, D1, no], ListadoPosesiones),
   member(Detonador, ListadoPosesiones),
   sitioDetonacion([X,Y]).

/* Esta heuristica retorna la distancia de la meta mas cercana al minero */

h([X,Y], ListaOperadores, Distancia):-
    hAux([X,Y], ListaOperadores, 0, Distancia).

hAux([_,_], [], Distancia, Distancia).
hAux([X,Y], [Operadores | ListaOperadores], DistanciaActual, Distancia):-
    findall([Xm,Ym], meta(Operadores, [Xm,Ym]), Metas),
    metasOrdenadas([X,Y], Metas, [[Xm,Ym] | _]),
    DistanciaNueva is DistanciaActual + (abs(Xm - X) + abs(Ym - Y)),
    hAux([Xm,Ym], ListaOperadores, DistanciaNueva, Distancia).

meta(juntar_carga(_), [X,Y]):-
   estaEn([c, _], [X,Y]).

meta(juntar_detonador(_), [X,Y]):-
   estaEn([d, _, no], [X,Y]).

meta(dejar_carga(_), [X,Y]):-
   ubicacionCarga([X,Y]).

meta(detonar(_), [X,Y]):-
   sitioDetonacion([X,Y]).

/* Obtiene las metas ordenadas de acuerdo a la distancia con el minero */
metasOrdenadas([X,Y], ListaMetas, MetasOrdenadas):-
   distanciasMeta([X,Y], ListaMetas, ListaResultados),
   keysort(ListaResultados, Pares),
   separar_pares_valores(Pares, MetasOrdenadas), !.
    
/* Obtiene las distancias de cada meta con el minero */
distanciasMeta([_,_], [], []).
distanciasMeta([X,Y], [[Xm,Ym] | ListaMetas], [Resultado-[Xm,Ym] | ListaResultados]):-
   Resultado is (abs(X - Xm) + abs(Y - Ym)),
   distanciasMeta([X,Y], ListaMetas, ListaResultados).

/* Sirve para separar las claves-valores que se obtienen en el keysort */
separar_pares_valores([], []).
separar_pares_valores([_-V|T0], [V|T]) :-
   separar_pares_valores(T0, T).

/*---------------------------------------------------------------------------------*/
/*-------------------------------ALGORITMO A*--------------------------------------*/
/*---------------------------------------------------------------------------------*/
% buscar_plan([[+X,+Y], +Dir, +Posesiones, +CargaPendiente], -Plan, -Destino, -Costo)

/* A partir de un estado inicial, obtiene un plan, el destino y el costo total asociado */
buscar_plan([[X,Y], Dir, ListaPosesiones, ColocacionCargaPendiente], Plan, Destino, Costo):-
    % Crea el estado inicial
    EstadoInicial = estado([X,Y], Dir, ListaPosesiones, ColocacionCargaPendiente),
    
    % Comienza el algoritmo a*, con el nodo inicial y obtiene el nodo final, con su estado, destino y operadores necesarios para llegar
	a_estrella([nodo(0, EstadoInicial, [inicial])],
               [],
               [juntar_carga(_), juntar_detonador(_), dejar_carga(_), detonar(_)],
               nodo(Costo, EFinal, Lista)),
    EFinal = estado([XFinal,YFinal],_,_,_),
    Destino = [XFinal,YFinal],
    
    % La lista de operadores está al revés, por lo que es necesario darlo vuelta
    reverse(Lista, [_ | Plan]), !.

a_estrella([NodoFinal | _], _, [], NodoFinal):-
    NodoFinal = nodo(_Costo, _Estado, [detonar(_) | _Operaciones]).

a_estrella(Frontera, Visitados, OperadoresDisponibles, UltimoNodo):-
    buscarEn(Frontera, Visitados, OperadoresDisponibles, NodoFinal),
    NodoFinal = nodo(_Costo, _Estado, [Operacion | _Operaciones]),
    delete(OperadoresDisponibles, Operacion, NuevosOperadores),
    a_estrella([NodoFinal], [], NuevosOperadores, UltimoNodo).

buscarEn(Frontera, _, Operadores, Nodo):-
    seleccionar(Nodo, Frontera, _FronteraSinNodo),
    Nodo = nodo(_Costo, Estado, [Operacion | _Operaciones]),
    esMeta(Estado, Operacion),
    member(Operacion, Operadores), !.

buscarEn(Frontera, Visitados, Operadores, MejorCamino):- 
    seleccionar(Nodo, Frontera, FronteraSinNodo),
	vecinos(Nodo, FronteraSinNodo, NuevaFrontera1, Visitados, NewVisitados, Vecinos),
	agregar(Vecinos, NuevaFrontera1, Operadores, NuevaFrontera2),
	buscarEn(NuevaFrontera2, [Nodo | NewVisitados], Operadores, MejorCamino).

seleccionar(Nodo, [Nodo | RestoLista], RestoLista).

agregar(Vecinos, FronteraSinNodo, Operadores, NuevaFrontera):-
    append(Vecinos, FronteraSinNodo, NuevaFronteraDesordenada),
    ordenar_por_f(NuevaFronteraDesordenada, Operadores, NuevaFrontera).

ordenar_por_f(NuevaFronteraDesordenada, Operadores, NuevaFrontera):-
    asignar_f(NuevaFronteraDesordenada, Operadores, Resultado),
    keysort(Resultado, Pares),
    separar_pares_valores(Pares, NuevaFrontera).
   
asignar_f([], _, []).
asignar_f([Nodo | RestoNodos], Operadores, [F-Nodo | RestoNodosConF]):-
    Nodo = nodo(Costo, Estado, _Operaciones),
    Estado = estado([X,Y],_,_,_),
    h([X,Y], Operadores, DistanciaHeuristica),
    F is DistanciaHeuristica + Costo,
    asignar_f(RestoNodos, Operadores, RestoNodosConF).

vecinos(Nodo, Frontera, NuevaFrontera, Visitados, NuevosVisitados, Vecinos):-
	Nodo = nodo(Costo, EstadoActual, ListaOperaciones),
    findall(
    	nodo(NuevoCosto, EstadoSiguiente, [OperacionSiguiente | ListaOperaciones]),
        (grafo(EstadoActual, EstadoSiguiente, OperacionSiguiente, CostoOperacion),
         NuevoCosto is Costo+CostoOperacion,
         esMenor(nodo(NuevoCosto, EstadoSiguiente, _), Visitados),
         esMenor(nodo(NuevoCosto, EstadoSiguiente, _), Frontera)
        ),
        Vecinos),
    reemplazarFrontera(Vecinos, Frontera, NewFrontera),
    reemplazarVisitados(Vecinos, NewFrontera, NuevaFrontera, Visitados, NuevosVisitados).

reemplazarVisitados([], Frontera, Frontera, Visitados, Visitados).
reemplazarVisitados([Nodo | Vecinos], Frontera, NuevaFrontera, Visitados, NuevosVisitados):-
    Nodo = nodo(Costo, Estado, Camino),
    member(nodo(_, Estado, _), Visitados),
    delete(Visitados, nodo(_, Estado, _), NewVisitados),
    append(Frontera, nodo(Costo, Estado, Camino), NewFrontera),
    reemplazarVisitados(Vecinos, NewFrontera, NuevaFrontera, NewVisitados, NuevosVisitados).
reemplazarVisitados([Nodo | Vecinos], Frontera, NuevaFrontera, Visitados, NuevosVisitados):-
    Nodo = nodo(_, Estado, _),
    not(member(nodo(_, Estado, _), Visitados)),
    reemplazarVisitados(Vecinos, Frontera, NuevaFrontera, Visitados, NuevosVisitados).

reemplazarFrontera([], NewFrontera, NewFrontera).
reemplazarFrontera([Nodo | Vecinos], Frontera, NuevaFrontera):-
    Nodo = nodo(_, Estado, _),
    member(nodo(_, Estado, _), Frontera),
    delete(Frontera, nodo(_, Estado, _), FronteraAux),
    append(FronteraAux, Nodo, NewFrontera),
    reemplazarFrontera(Vecinos, NewFrontera, NuevaFrontera).
reemplazarFrontera([Nodo | Vecinos], Frontera, NuevaFrontera):-
    Nodo = nodo(_, Estado, _),
    not(member(nodo(_, Estado, _), Frontera)),
    reemplazarFrontera(Vecinos, Frontera, NuevaFrontera).

esMenor(Nodo, Frontera):-
    Nodo = nodo(_, Estado, _),
    not(member(nodo(_, Estado, _), Frontera)).

esMenor(Nodo, Frontera):-
    Nodo = nodo(Costo, Estado, _),
    member(nodo(_, Estado, _), Frontera),
    buscarNodo(Estado, Frontera, NodoFrontera),
    NodoFrontera = nodo(CostoFrontera, Estado, _),
    CostoFrontera > Costo.

buscarNodo(Estado, [Nodo, _], nodo(CostoFrontera, Estado, Camino)):-
    Nodo = nodo(CostoFrontera, Estado, Camino).
buscarNodo(Estado, [Nodo | Frontera], NodoFrontera):-
    Nodo \= NodoFrontera,
    buscarNodo(Estado, Frontera, NodoFrontera).