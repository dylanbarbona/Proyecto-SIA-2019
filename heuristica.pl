:- include('grafo.pl').

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

/* Obtengo una lista de las metas desordenadas, de acuerdo al estado del minero */
metasDesordenadas(Estado, ListaMetas):-
   Estado = estado([_,_], _, _ListadoPosesiones, _ColocacionCargaPendiente),
   findall([X,Y], meta(Estado, [X,Y]), ListaMetas).

/*Obtiene una lista con las distancias del estado actual hasta las metas
   con el formato Resultado-[X,Y].
*/
distanciasMeta(_Estado, [], []).
distanciasMeta(Estado, [[X,Y] | ListaMetas], [Resultado-[X,Y] | ListaResultados]):-
   Estado = estado([XInicial, YInicial], _, _, _),
   Resultado is sqrt((X-XInicial)^2 + (Y-YInicial)^2),
   distanciasMeta(Estado, ListaMetas, ListaResultados).

/* Auxiliar para separar las metas de las distancias */
separar_pares_valores([], []).
separar_pares_valores([_-V|T0], [V|T]) :-
   separar_pares_valores(T0, T).

/*
Ordena todas las metas
*/
metasOrdenadas(Estado, MetasOrdenadas):-
   Estado = estado([_XInicial, _YInicial], _, _, _),
   metasDesordenadas(Estado, ListaMetas),
   distanciasMeta(Estado, ListaMetas, ListaResultados),
   keysort(ListaResultados, Pares),
   separar_pares_valores(Pares, MetasOrdenadas), !.

/* Esta heuristica retorna la distancia de la meta mas cercana */
h(Estado, Distancia):-
   Estado = estado([XActual, YActual], _, _, _),
   metasOrdenadas(Estado, [[X,Y] | _]),
   Distancia is abs((X-XActual) + (Y-YActual)).

metaFinalMasCercana(EstadoActual, [XFinal,YFinal]):-
   EstadoActual = estado([_X, _Y], _, _, 'no'),
   metasOrdenadas(EstadoActual, [[XFinal,YFinal] | _]).