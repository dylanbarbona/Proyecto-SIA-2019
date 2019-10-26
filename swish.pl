
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

hay_camino([X,Y], [XNew, YNew], TipoSuelo):-
    celda([X,Y], _TipoSuelo1), celda([XNew,YNew], TipoSuelo),
    ((XNew is X+1, YNew is Y); (XNew is X-1, YNew is Y);
     (XNew is X, YNew is Y+1); (XNew is X, YNew is Y-1)).

/*
Operacion para caminar.
*/
grafo(EstadoActual, EstadoNuevo, caminar, Costo):- 
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    hay_camino([X,Y], [XNew, YNew], TipoSuelo),                                     % Encuentra un camino de [X,Y] a [XNew, YNew]

    ((Dir == o, XNew is X, YNew is Y-1); (Dir == e, XNew is X, YNew is Y+1);        % Obtiene las posiciones validas de acuerdo a la direccion del minero
    (Dir == n, YNew is X, XNew is X-1); (Dir == s, YNew is Y, XNew is X+1)),    
    ((TipoSuelo = firme, Costo is 2); (TipoSuelo = resbaladizo, Costo is 3)),       % Obtiene el costo de la accion, de acuerdo al tipo de suelo
    not(estaEn([p, _Pilar, _AlturaPilar], [XNew, YNew])),                           % No puede cruzar un camino con pilar, independientemente de su altura. 
    not(estaEn([v, _Valla, _AlturaValla], [XNew, YNew])),                           % No puede cruzar un camino con valla, necesariamente debe saltarla.
    (
        (not(estaEn([r, _Reja],[XNew,YNew])));                                      % O biene no hay una reja
        (estaEn([r, Reja],[XNew,YNew]), member([l,Llave], ListadoPosesiones), abreReja([l,Llave],[r,Reja]))    % O bien hay una y la cruza solo si tiene la llave correspondiente
    ),
    EstadoNuevo = estado([XNew,YNew], Dir, ListadoPosesiones, ColocacionCargaPendiente).       % Se crea un nuevo hecho con la direccion nueva 


/*
Operacion para rotar(Dir).
*/
grafo(EstadoActual, EstadoNuevo, rotar(Dir), Costo):-
    EstadoActual = estado([X,Y], DirVieja, ListadoPosesiones, ColocacionCargaPendiente),
    member(Dir, [n, s, e, o]),
    (DirVieja \= Dir),                                                             % Debe haber necesariamente un cambio de direcciones
    (                                                                              % Se obtienen los costos asociados a las distintas posibilidades de las direcciones
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
    EstadoNuevo = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente).       % Se crea un nuevo hecho con la direccion nueva 

/*
Operacion para saltar(Dir).

Falta hacer que solamente sea posible que salte una vez
*/
grafo(EstadoActual, EstadoNuevo, saltar_valla(Valla), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    Valla = [v, _NombreV, AlturaV],                                                 % Obtiene la direccion actual del minero
    hay_camino([X,Y], [XNew,YNew], _TipoSuelo),                                     % Se chequea que haya un tipo de suelo
    estaEn(Valla, [XNew, YNew]),                                                    % Se chequea que la valla exista en esas cordenadas
    AlturaV =< 4,                                                                   % La altura de la valla debe ser menor que 4
    not(estaEn([p,_,_],[XNew,YNew])),                                               % No puede saltar pilares
    not(estaEn([r,_],[XNew,YNew])),                                                 % No puede pasar rejas saltando
    
    EstadoIntermedio1 = estado([XNew,YNew], Dir, ListadoPosesiones, ColocacionCargaPendiente),    % Estado intermedio para obtener el costo del suelo donde va a caer
    grafo(EstadoIntermedio1, EstadoIntermedio2, caminar, CostoSalto),
    EstadoIntermedio2 = estado([XSalto,YSalto], Dir, ListadoPosesiones, ColocacionCargaPendiente), % Estado intermedio para obtener ese resultado
    Costo is CostoSalto+1,
    ((Dir == o, XNew is X, YNew is Y-1); (Dir == e, XNew is X, YNew is Y+1);        % Obtiene las posiciones validas de acuerdo a la direccion del minero
    (Dir == n, YNew is X, XNew is X-1); (Dir == s, YNew is Y, XNew is X+1)),
    
    EstadoNuevo = estado([XSalto,YSalto], Dir, ListadoPosesiones, ColocacionCargaPendiente).

/*
Operacion para juntar_llave(Llave)
*/

grafo(EstadoActual, EstadoNuevo, juntar_llave(Llave), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    Llave = [l, _NombreL],
    estaEn(Llave, [X,Y]),                                                                       % Evalua si existe la llave en la Celda
    Costo = 1,                                                                                  % Esto tiene un costo de 1
    not(member(Llave, ListadoPosesiones)),
    EstadoNuevo = estado([X,Y], Dir, [Llave | ListadoPosesiones], ColocacionCargaPendiente).    % Se agrega la llave a la lista de posesiones

/*
Operacion para juntar_carga(Carga)
*/

grafo(EstadoActual, EstadoNuevo, juntar_carga(Carga), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, _ColocacionCargaPendiente),
    Carga = [c, _NombreC],
    estaEn(Carga, [X,Y]),                                                          % Evalua si la carga esta en su posicion
    not(member(Carga, ListadoPosesiones)),
    Costo = 3,                                                                          % Esto tiene un costo de 3
    EstadoNuevo = estado([X,Y], Dir, [Carga | ListadoPosesiones], 'si').           % Se agrega la carga y se setea la colocación pendiente como si

/*
Operacion para dejar_carga(Carga)
*/
grafo(EstadoActual, EstadoNuevo, dejar_carga(Carga), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, 'si'),
    ubicacionCarga([X,Y]),
    member(Carga, ListadoPosesiones),
    Costo = 1,
    EstadoNuevo = estado([X,Y], Dir, ListadoPosesiones, 'no').

/*
Operacion para juntar_detonador(Detonador)
*/  

grafo(EstadoActual, EstadoNuevo, juntar_detonador(Detonador), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, 'no'),
    Detonador = [d, _NombreD, no],
    estaEn(Detonador, [X,Y]),
    member([c,_], ListadoPosesiones),
    not(member(Detonador, ListadoPosesiones)),
    Costo = 2,
    EstadoNuevo = estado([X,Y], Dir, [Detonador | ListadoPosesiones], 'no').

/*
Operacion para detonar(Detonador)
*/
grafo(EstadoActual, EstadoNuevo, detonar(Detonador), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, 'no'),
    Detonador = [d, NombreD, 'no'],
    member([c,_], ListadoPosesiones),
    member(Detonador, ListadoPosesiones),
    not(member([d, NombreD, 'si'], ListadoPosesiones)),
    sitioDetonacion([X,Y]),
    Costo = 1,
    EstadoNuevo = estado([X,Y], Dir, [[d, NombreD, 'si'] | ListadoPosesiones], 'no').

/* Tiene que encontrar la carga */
meta(Estado, [X,Y]):-
   Estado = estado([_,_], _, ListadoPosesiones, _),
   not(member([c, Carga], ListadoPosesiones)),
   not(member([d, _Detonador, no], ListadoPosesiones)),
   estaEn([c, Carga], [X,Y]).

/* Ya encontro la carga y tiene que ubicarla */
meta(Estado, [X,Y]):-
   Estado = estado([_,_], _, ListadoPosesiones, 'si'),
   member([c, _], ListadoPosesiones),
   ubicacionCarga([X,Y]).

/* Ya coloco la carga y debe buscar el detonador */
meta(Estado, [X,Y]):-
   Estado = estado([_,_], _, ListadoPosesiones, 'no'),
   member([c, _Carga], ListadoPosesiones),
   not(member([d, Detonador, no], ListadoPosesiones)),
   estaEn([d, Detonador, no], [X,Y]).

/* Ya encontro el detonador y debe ir al sitio de detonacion */
meta(Estado, [X,Y]):-
   Estado = estado([_,_], _, ListadoPosesiones, 'no'),
   member([d, _, no], ListadoPosesiones),
   not(member([d, _, si], ListadoPosesiones)),
   sitioDetonacion([X,Y]).

/* Solo queda detonar la bomba */
meta(Estado, [X,Y]):-
   Estado = estado([X,Y], _, ListadoPosesiones, 'no'),
   member([d, _, no], ListadoPosesiones),
   member([d, _, si], ListadoPosesiones),
   sitioDetonacion([X,Y]).

/* Esta heuristica retorna la distancia de la meta mas cercana */
h(Estado, Metas, Distancia):-
    metasOrdenadas(Estado, Metas, [[Xm,Ym] | _]),
    Estado = estado([X,Y], _, _, _),
    Distancia is (Xm-X) + (Ym-Y).

metasOrdenadas(Estado, ListaMetas, MetasOrdenadas):-
   distanciasMeta(Estado, ListaMetas, ListaResultados),
   keysort(ListaResultados, Pares),
   separar_pares_valores(Pares, MetasOrdenadas), !.
    
distanciasMeta(_Estado, [], []).
distanciasMeta(Estado, [[X,Y] | ListaMetas], [Resultado-[X,Y] | ListaResultados]):-
   Estado = estado([XInicial, YInicial], _, _, _),
   Resultado is sqrt((X-XInicial)^2 + (Y-YInicial)^2),
   distanciasMeta(Estado, ListaMetas, ListaResultados).

separar_pares_valores([], []).
separar_pares_valores([_-V|T0], [V|T]) :-
   separar_pares_valores(T0, T).
    

obtenerListaMetas(ListaMetas):-
   	findall([X,Y], meta(estado([_,_], _, [], no), [X,Y]), MetasBuscarCarga),
   	findall([X,Y], meta(estado([_,_], _, [[c,_]], si), [X,Y]), MetasUbicarCarga), 
   	findall([X,Y], meta(estado([_,_], _, [[c,_]], no), [X,Y]), MetasEncontrarDetonador), 
   	findall([X,Y], meta(estado([_,_], _, [[c,_], [d,_,no]], no), [X,Y]), MetasIrADetonacion),
    findall([X,Y], meta(estado([X,Y], _, [[c,_], [d,_,no], [d,_,si]], no), [X,Y]), MetasDetonarCarga),
    ListaMetas = [MetasBuscarCarga, MetasUbicarCarga, MetasEncontrarDetonador, MetasIrADetonacion, MetasDetonarCarga].

/*---------------------------------------------------------------------------------*/

encontrar_mejor_camino(EInicial, Plan, Destino, Costo):- 
    obtenerListaMetas(ListaMetas),
	a_estrella([[0,[inicio, EInicial]]], ListaMetas, [], NodoFinal),
    NodoFinal = [Costo, [Operacion, EFinal] | CaminoRev],
    EFinal = estado([X,Y],_,_,_),
    Destino = [X,Y],
    obtenerOperaciones([[Operacion, EFinal] | CaminoRev], PlanRev),
	reverse(PlanRev, Plan), !.

obtenerOperaciones([[inicio, _Estado]], []).
obtenerOperaciones([[Operacion, _Estado] | Camino], [Operacion | RestoPlan]):-
    obtenerOperaciones(Camino, RestoPlan).

a_estrella([Costo | Nodos], [], _Visitados, [Costo | Nodos]).
a_estrella([[Costo | Nodos]], [Metas | ListaMetas], Visitados, UltimoNodo):-
    a_estrella_cascara([[0 | Nodos]], Metas, Visitados, Nodo), !,
    Nodo = [CostoParcial, [Operacion, Estado] | RestoNodos],
    CostoTotal is CostoParcial + Costo,
    a_estrella([[CostoTotal, [Operacion, Estado] | RestoNodos]], ListaMetas, Visitados, UltimoNodo).
    
a_estrella_cascara(Frontera, Metas, _Vis, NodoF):-
    elegir_mejorf(Frontera, Metas, NodoF),
    NodoF = [_Costo, [_Operacion, Estado] | _Camino],
    Estado = estado([X,Y], _, _, _),
    member([X,Y], Metas).

a_estrella_cascara(Frontera, Metas, Visitados, MejorCamino):- 
    elegir_mejorf(Frontera, Metas, Nodo),
	delete(Frontera, Nodo, FronteraSinNodo),
	vecinos(Nodo, Frontera, Visitados, Vecinos),
	eliminar_peores_caminos(Vecinos, FronteraSinNodo, NuevaFrontera),
    Nodo = [_Costo, [_Operacion, Estado] | _Camino],
	a_estrella_cascara(NuevaFrontera, Metas, [Estado | Visitados], MejorCamino).

eliminar_peores_caminos([], CaminosViejos, CaminosViejos).

eliminar_peores_caminos([[CostoNuevo, [Estado | RestoNuevo]] | RestoCaminosNuevos], CaminosViejos, [[CostoNuevo, [Estado | RestoNuevo]] | RestoCaminosFiltrados]):-
	member([CostoViejo, [Estado|RestoViejo]], CaminosViejos),
	CostoNuevo < CostoViejo,
	delete([CostoViejo, [Estado | RestoViejo]], CaminosViejos, CaminosViejosSinPeor),
	eliminar_peores_caminos(RestoCaminosNuevos, CaminosViejosSinPeor, RestoCaminosFiltrados).

eliminar_peores_caminos([[_CostoNuevo, [Estado |_RestoNuevo]] | RestoCaminosNuevos], CaminosViejos, CaminosFiltrados):-
	member([_CostoViejo,[Estado | _RestoViejo]], CaminosViejos),
	eliminar_peores_caminos(RestoCaminosNuevos, CaminosViejos, CaminosFiltrados).

eliminar_peores_caminos([CaminoNuevo | RestoCaminosNuevos], CaminosViejos, [CaminoNuevo | RestoCaminosFiltrados]):-
	eliminar_peores_caminos(RestoCaminosNuevos, CaminosViejos, RestoCaminosFiltrados).

vecinos(Nodo, Frontera, Visitados, Vecinos):-
	Nodo = [Costo, [Operacion,Estado] | Camino],
    findall(
    	[Costo, [OperacionSiguiente, EstadoSiguiente], [Operacion,Estado] | Camino],
        (grafo(Estado, EstadoSiguiente, OperacionSiguiente, _),
         not(member(EstadoSiguiente, Visitados)),
         not(member([[_,EstadoSiguiente] | _], Frontera))),
        Lista),
    cambiar_costos(Lista, Vecinos).
vecinos(_Nodo, _Frontera, _Visitados,[]).

cambiar_costos([],[]):- !.
cambiar_costos([[CostoTotal, [OperacionSiguiente, EstadoSiguiente], [Operacion,EstadoActual] | Camino] | Y],
               [[NuevoCostoTotal, [OperacionSiguiente, EstadoSiguiente], [Operacion,EstadoActual] | Camino] | Z]):-
	grafo(EstadoActual, EstadoSiguiente, OperacionSiguiente, CostoOperacion),
	NuevoCostoTotal is CostoTotal + CostoOperacion,
	cambiar_costos(Y,Z).

elegir_mejorf([X], _Metas, X):- !.

elegir_mejorf([[C1, [Op, E1] | Y], [C2, [_, E2] | _] | Z], Metas, MejorF):-
	h(E1, Metas, H1),
	h(E2, Metas, H2),
	H1 +  C1 =< H2 +  C2,
	elegir_mejorf([[C1, [Op, E1] | Y] | Z], Metas, MejorF).

elegir_mejorf([[C1, [_,E1] | _], [C2, [Op, E2] | Y] | Z], Metas, MejorF):-
	h(E1, Metas, H1),
	h(E2, Metas, H2),
	H1 + C1 > H2 +  C2,
	elegir_mejorf([[C2, [Op, E2] | Y] | Z], Metas, MejorF).