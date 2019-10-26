:- include('heuristica.pl').


/*
Funciones utiles importadas:

meta(Estado, [X,Y]).
h(Estado, Distancia).
grafo(EstadoActual, EstadoNuevo, Operacion, Costo).
*/

encontrar_mejor_camino(EInicial, Plan, Destino, Costo):- 
	a_estrella([[0,EInicial]], [], [[Costo | EFinal] | CaminoRev]),
    Destino = [X,Y],
    EFinal = estado([X,Y],_,_,_),
	reverse([EFinal | CaminoRev], Plan).
    
a_estrella(Frontera, _Vis, [Costo, Estado | Camino]):-
	elegir_mejorf(Frontera, NodoF),
    NodoF = [Costo, Estado | Camino],
    esMeta(Estado).

a_estrella(Frontera, Visitados, MejorCamino):- 
    elegir_mejorf(Frontera, Nodo),
	delete(Frontera, Nodo, FronteraSinNodo),
	vecinos(Nodo, Frontera, Visitados, Vecinos),
	eliminar_peores_caminos(Vecinos, FronteraSinNodo, NuevaFrontera),
    Nodo = [_Costo, Estado | _Camino],
    metaMasCercana(Estado, [X,Y]),
	writeln([X,Y]),
	a_estrella(NuevaFrontera, [Estado | Visitados], MejorCamino).

eliminar_peores_caminos([], CaminosViejos, CaminosViejos).

eliminar_peores_caminos([[CostoNuevo, [Estado | CaminoNuevo]] | RestoCaminosNuevos], CaminosViejos, [[CostoNuevo, [Estado | CaminoNuevo]] | RestoCaminosFiltrados]):-
	member([CostoViejo, [Estado|RestoViejo]], CaminosViejos),
	CostoNuevo < CostoViejo,
	delete([CostoViejo, [Estado | RestoViejo]], CaminosViejos, CaminosViejosSinPeor),
	eliminar_peores_caminos(RestoCaminosNuevos, CaminosViejosSinPeor, RestoCaminosFiltrados).

eliminar_peores_caminos([[_CostoNuevo, [Estado |_CaminoNuevo]] | RestoCaminosNuevos], CaminosViejos, CaminosFiltrados):-
	member([_CostoViejo,[Estado | _RestoViejo]], CaminosViejos),
	eliminar_peores_caminos(RestoCaminosNuevos, CaminosViejos, CaminosFiltrados).

eliminar_peores_caminos([CaminoNuevo | RestoCaminosNuevos], CaminosViejos, [CaminoNuevo | RestoCaminosFiltrados]):-
	eliminar_peores_caminos(RestoCaminosNuevos, CaminosViejos, RestoCaminosFiltrados).


vecinos(Nodo, Frontera, Visitados, Vecinos):-
	Nodo = [Costo, Estado | Camino],
    findall(
    	[Costo, EstadoSiguiente, Estado | Camino],
        (grafo(Estado, EstadoSiguiente, _, _),
         not(member(EstadoSiguiente, Visitados)),
         not(member([EstadoSiguiente | _], Frontera))),
        Lista),
    cambiar_costos(Lista, Vecinos).

cambiar_costos([],[]):- !.
cambiar_costos([[CostoTotal, EstadoSiguiente, EstadoActual | Camino] | Y],
               [[NuevoCostoTotal, EstadoSiguiente, EstadoActual | Camino] | Z]):-
	grafo(EstadoActual, EstadoSiguiente, _, CostoOperacion),
	NuevoCostoTotal is CostoTotal + CostoOperacion,
	cambiar_costos(Y,Z).

elegir_mejorf([X], X):- !.

elegir_mejorf([[C1, E1 | Y], [C2, E2 | _] | Z], MejorF):-
	h(E1, H1),
	h(E2, H2),
	H1 +  C1 =< H2 +  C2,
	elegir_mejorf([[C1, E1 | Y] | Z], MejorF).

elegir_mejorf([[C1, E1 | _], [C2, E2 | Y] | Z], MejorF):-
	h(E1, H1),
	h(E2, H2),
	H1 + C1 > H2 +  C2,
	elegir_mejorf([[C2, E2 | Y] | Z], MejorF).