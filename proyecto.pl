:- include('grafo.pl').

/* heuristica usada: distancia de la posicion actual hasta la proxima meta */

/* 
   encontrar_mejor_camino
   Predicado que aplica A* al grafo anteriormente definido 
   para encontrar el mejor camino entre el Origen y Destino.
   Encuentra el mejor camino (uno solo) y lo imprime primero.
   Nota: Para representar un camino voy a usar una lista
   que tiene como primer elemento el costo total del camino
   en distancia y como cola el indice de cada ciudad del camino.
   O sea, [CostoTotal|Camino_Recorrido].
*/

encontrar_mejor_camino(Pos1, Pos2):- 
	ciudad(C1,Origen),
	ciudad(C2,Destino),
	a_estrella([[0,C1]], C2, CaminoRev),
	reverse(CaminoRev, _Camino). 

a_estrella(Frontera, Destino, [Estado|Camino]):- 
	member(Nodo, Frontera),
	Nodo = [Estado, Destino | Camino],
	elegir_mejorf(Frontera, [Estado|_]).

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