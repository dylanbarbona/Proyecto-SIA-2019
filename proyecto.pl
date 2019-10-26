:- include('heuristica.pl').

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