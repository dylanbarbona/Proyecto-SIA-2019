:- include('heuristica.pl').


/*
Funciones utiles importadas:

meta(Estado, [X,Y]).
h(Estado, Distancia).
grafo(EstadoActual, EstadoNuevo, Operacion, Costo).
*/

encontrar_mejor_camino(EInicial, Plan, Destino, Costo):- 
	EInicial = estado([_X,_Y], _Dir, _, _),								% Defino el estado inicial
	EFinal = estado([XFinal,YFinal], _, _, 'no'),						% Defino el estado meta final	
	Destino = [XFinal, YFinal],											% Retorno el destino con [X,Y]
	a_estrella([[0,EInicial]], Destino, [Costo, EFinal | PlanAux]),		% Comienzo a recorrer el grafo con el algoritmo A*
	reverse([EFinal | PlanAux], Plan), !.								% Invierto la lista. El resultado es [EInicial, .... , EFinal]	

a_estrella(Frontera, Destino, [Estado|Camino]):- 
	member(Nodo, Frontera),
	Nodo = [Estado, Destino | Camino],
	elegir_mejorf(Frontera, [Estado | _]).

a_estrella(Frontera, Destino, Camino):- 
	elegir_mejorf(Frontera, Nodo),
	seleccionar(Nodo, Frontera, FronteraSinNodo),
	vecinos(Nodo, NuevosCaminos),
	agregar(NuevosCaminos, FronteraSinNodo, L),
	a_estrella(L, Destino, Camino).

seleccionar(Nodo, Caminos, FronteraSinNodo):-
	delete(Caminos, Nodo, FronteraSinNodo).

agregar(Vecinos, ViejaFrontera, NuevaFrontera) :-
    append(Vecinos, ViejaFrontera, NuevaFrontera).

vecinos([Costo,PosActual|Camino], Caminos):- 
	findall([Costo,PosSiguiente,PosActual|Camino], (grafo(PosActual, PosSiguiente, _, _), not(member(PosSiguiente,Camino))), L),
	cambiar_costos(L, Caminos).

cambiar_costos([],[]):- !.
cambiar_costos([[CostoTotal, C1, C2 | Camino] | Y], [[NuevoCostoTotal, C1, C2 | Camino] | Z]):-
	grafo(C2, C1, _Operacion, CostoOperacion),
	NuevoCostoTotal is CostoTotal + CostoOperacion,
	cambiar_costos(Y,Z).


/*Mejorar este predicado*/
/*Para eso tengo que mejorar las heuristicas. Calculo que tengo
que crear un predicado h(C, H) Donde C sea la celda actual, y H la distancia a la meta mas cercana (La meta varia de acuerdo
a los objetivos del minero)
*/
elegir_mejorf([X],X):- !.
elegir_mejorf([[C1,Ci1|Y],[C2,Ci2|_]|Z], MejorF):-
	h(Ci1, H1),
	h(Ci2, H2),
	H1 +  C1 =< H2 +  C2,
	elegir_mejorf([[C1,Ci1|Y]|Z], MejorF).
elegir_mejorf([[C1,Ci1|_],[C2,Ci2|Y]|Z], MejorF):-
	h(Ci1, H1),
	h(Ci2, H2),
	H1  + C1 > H2 +  C2,
	elegir_mejorf([[C2,Ci2|Y]|Z], MejorF).