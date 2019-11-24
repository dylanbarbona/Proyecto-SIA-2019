:- include('estados_minero.pl').

/*---------------------------------------------------------------------------------*/
/*-------------------------------METAS DEL MINERO----------------------------------*/
/*---------------------------------------------------------------------------------*/

proximoOperador(Estado, ListaOperadores):-
   Estado = estado(_, _, ListadoPosesiones, _),
   not(member([c, c1], ListadoPosesiones)),
   not(member([d, d1, _], ListadoPosesiones)),
   (ListaOperadores = [juntar_carga([c,c1]), juntar_detonador([d,d1,no]), dejar_carga([c,c1]), detonar([d,d1,si])];
   ListaOperadores = [juntar_detonador([d,d1,no]), juntar_carga([c,c1]), dejar_carga([c,c1]), detonar([d,d1,si])];
   ListaOperadores = [juntar_carga([c,c1]), dejar_carga([c,c1]), juntar_detonador([d,d1,no]),detonar([d,d1,si])]).

proximoOperador(Estado, ListaOperadores):-
   Estado = estado(_, _, ListadoPosesiones, si),
   member([c, c1], ListadoPosesiones),
   not(member([d, d1, _], ListadoPosesiones)),
   (ListaOperadores = [juntar_detonador([d,d1,no]), dejar_carga([c,c1]), detonar([d,d1,si])];
   ListaOperadores = [dejar_carga([c,c1]), juntar_detonador([d,d1,no]), detonar([d,d1,si])]).

proximoOperador(Estado, ListaOperadores):-
   Estado = estado(_, _, ListadoPosesiones, _),
   not(member([c, c1], ListadoPosesiones)),
   member([d, d1, no], ListadoPosesiones),
   ListaOperadores = [juntar_carga([c,c1]), dejar_carga([c,c1]), detonar([d,d1,si])].

proximoOperador(Estado, ListaOperadores):-
   Estado = estado(_, _, ListadoPosesiones, no),
   member([c, c1], ListadoPosesiones),
   not(member([d, d1, _], ListadoPosesiones)),
   ListaOperadores = [juntar_detonador([d,d1,no]), detonar([d,d1,si])].

proximoOperador(Estado, ListaOperadores):-
   Estado = estado(_, _, ListadoPosesiones, si),
   member([c, c1], ListadoPosesiones),
   member([d, d1, no], ListadoPosesiones),
   ListaOperadores = [dejar_carga([c,c1]), detonar([d,d1,si])].

proximoOperador(Estado, ListaOperadores):-
   Estado = estado(_, _, ListadoPosesiones, no),
   member([c, c1], ListadoPosesiones),
   member([d, d1, no], ListadoPosesiones),
   ListaOperadores = [detonar([d,d1,si])].

/* Ya encontro el detonador y debe ir al sitio de detonacion */
esMeta(Nodo):-
   Nodo = nodo(_, Estado, [detonar([d,d1,si]) | _]),
   Estado = estado([X,Y], _, ListadoPosesiones, no),
   member([c, c1], ListadoPosesiones),
   member([d, d1, no], ListadoPosesiones),
   member([d, d1, si], ListadoPosesiones),
   sitioDetonacion([X,Y]).

h(Estado, Heuristica):-
    Estado = estado([X,Y], _, _, _),
    findall(D, (proximoOperador(Estado, ListaOperadores), hAux([X,Y], ListaOperadores, 0, D)), Distancias),
    sort(0, @=<, Distancias, [Distancia | _]),
    Heuristica is 3*Distancia.

hAux([_,_], [], Distancia, Distancia).
hAux([X,Y], [Operadores | ListaOperadores], DistanciaActual, Distancia):-
    findall([Xm,Ym], meta(Operadores, [Xm,Ym]), Metas),
    metasOrdenadas([X,Y], Metas, [[Xm,Ym] | _]),
    DistanciaNueva is DistanciaActual + (abs(Xm - X) + abs(Ym - Y)),
    hAux([Xm,Ym], ListaOperadores, DistanciaNueva, Distancia).

meta(juntar_carga([c,c1]), [X,Y]):-
   estaEn([c, _], [X,Y]).

meta(juntar_detonador([d,d1,no]), [X,Y]):-
   estaEn([d, _, no], [X,Y]).

meta(dejar_carga([c,c1]), [X,Y]):-
   ubicacionCarga([X,Y]).

meta(detonar([d,d1,si]), [X,Y]):-
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