:- include('grafo.pl').

meta([X,Y]):-
   sitioDetonacion([X,Y]).

metasDesordenadas(ListaMetas):-
   findall([X,Y], meta([X,Y]), ListaMetas).

distanciasMeta([_XInicial, _YInicial], [], []).
distanciasMeta([XInicial, YInicial], [[X,Y] | ListaMetas], [Resultado-[X,Y] | ListaResultados]):-
   Resultado is sqrt((X-XInicial)^2 + (Y-YInicial)^2),
   distanciasMeta([XInicial, YInicial], ListaMetas, ListaResultados).

separar_pares_valores([], []).
separar_pares_valores([_-V|T0], [V|T]) :-
   separar_pares_valores(T0, T).

metasOrdenadas([XInicial, YInicial], MetasOrdenadas):-
   metasDesordenadas(ListaMetas),
   distanciasMeta([XInicial, YInicial], ListaMetas, ListaResultados),
   keysort(ListaResultados, Pares),
   separar_pares_valores(Pares, MetasOrdenadas).

/* Esta heuristica retorna la distancia de la meta mas cercana */
h([XActual,YActual], DistanciaMeta):-
   metasOrdenadas([XActual,YActual], [[X,Y] | _]),
   DistanciaMeta is sqrt((X-XActual)^2 + (Y-YActual)^2). 