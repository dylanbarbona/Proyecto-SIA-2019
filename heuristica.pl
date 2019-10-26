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
