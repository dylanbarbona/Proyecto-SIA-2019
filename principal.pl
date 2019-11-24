:- include('minaExample.pl').
:- include('estados_minero.pl').
:- include('metas_minero.pl').
:- dynamic frontera/1.
:- dynamic visitados/1.

/*---------------------------------------------------------------------------------*/
/*-------------------------------ALGORITMO A*--------------------------------------*/
/*---------------------------------------------------------------------------------*/
% buscar_plan([[+X,+Y], +Dir, +Posesiones, +CargaPendiente], -Plan, -Destino, -Costo)

/* A partir de un estado inicial, obtiene un plan, el destino y el costo total asociado */
buscar_plan([[X,Y], Dir, ListaPosesiones, ColocacionCargaPendiente], Plan, Destino, Costo):-
    limpiar,
    
    EstadoInicial = estado([X,Y], Dir, ListaPosesiones, ColocacionCargaPendiente),    
    
    Nodo = nodo(0, EstadoInicial, [inicial]),
    asserta(frontera(Nodo)),
    
    NodoFinal = nodo(Costo, EFinal, Lista),
    buscarEn(NodoFinal),
    EFinal = estado([XFinal,YFinal],_,_,_),
    Destino = [XFinal,YFinal],
    
    % La lista de operadores está al revés, por lo que es necesario darlo vuelta
    reverse(Lista, [_ | Plan]), 
    limpiar, !.

buscarEn(Nodo):-
    seleccionar(Nodo),
	esMeta(Nodo).

buscarEn(MejorNodo):- 
    seleccionar(Nodo),
    retract(frontera(Nodo)),
	vecinos(Nodo, Vecinos),
	agregar(Vecinos),
    asserta(visitados(Nodo)),
	buscarEn(MejorNodo).

/* Genero los vecinos del nodo */
vecinos(Nodo, Vecinos):-
	Nodo = nodo(Costo, EstadoActual, ListaOperaciones),
    findall(
    	nodo(NuevoCosto, EstadoSiguiente, [OperacionSiguiente | ListaOperaciones]),
        (grafo(EstadoActual, EstadoSiguiente, OperacionSiguiente, CostoOperacion),
         NuevoCosto is Costo+CostoOperacion),
        Vecinos).

agregar([]).

/* Si no esta ni en la frontera ni en visitados, lo agrego a la frontera */
agregar([Nodo | Vecinos]):-
    Nodo = nodo(_, Estado, _),
    NodoVisitado = nodo(_, Estado, _),
    not(frontera(NodoVisitado)),
    not(visitados(NodoVisitado)),
    assert(frontera(Nodo)),
    agregar(Vecinos).

/* Si el nuevo vecino tiene menor costo que el nodo en la frontera, se intercambia */
agregar([Nodo | Vecinos]):-
    Nodo = nodo(CostoVecino, Estado, _),
    NodoFrontera = nodo(CostoFrontera, Estado, _),
    frontera(NodoFrontera),
    CostoVecino < CostoFrontera,
    retract(frontera(NodoFrontera)),
    assert(frontera(Nodo)),
    agregar(Vecinos).

/* Si el nuevo vecino tiene mayor costo que el nodo en la frontera, no se agrega */
agregar([Nodo | Vecinos]):-
    Nodo = nodo(CostoVecino, Estado, _),
    NodoFrontera = nodo(CostoFrontera, Estado, _),
    frontera(NodoFrontera),
    CostoVecino >= CostoFrontera,
    agregar(Vecinos).

/* Si el nuevo vecino tiene menor costo que el nodo en visitados, se saca el nodo de visitados y el vecino se agrega a la frontera */
agregar([Nodo | Vecinos]):-
    Nodo = nodo(CostoVecino, Estado, _),
    NodoVisitado = nodo(CostoVisitado, Estado, _),
    visitados(NodoVisitado),
    CostoVecino < CostoVisitado,
    retract(visitados(NodoVisitado)),
    assert(frontera(Nodo)),
    agregar(Vecinos).

/* Si el nuevo vecino tiene mayor costo que el nodo en visitados, no se agrega */
agregar([Nodo | Vecinos]):-
    Nodo = nodo(CostoVecino, Estado, _),
    NodoVisitado = nodo(CostoVisitado, Estado, _),
    visitados(NodoVisitado),
    CostoVecino >= CostoVisitado,
    agregar(Vecinos).

/* Selecciono el nodo de menor F = 3*H + G */
seleccionar(Nodo):-
    findall(N, frontera(N), FronteraAux),
    ordenar_por_f(FronteraAux, [Nodo | _]).

ordenar_por_f(FronteraDesordenada, NuevaFrontera):-
    asignar_f(FronteraDesordenada, Resultado),
    keysort(Resultado, Pares),
    separar_pares_valores(Pares, NuevaFrontera).
   
asignar_f([], []).
asignar_f([Nodo | RestoNodos], [F-Nodo | RestoNodosConF]):-
    Nodo = nodo(Costo, Estado, _Operaciones),
    h(Estado, Heuristica),
    F is Heuristica + Costo,
    asignar_f(RestoNodos, RestoNodosConF).

limpiar():-
    retractall(frontera(_)),
    retractall(visitados(_)).