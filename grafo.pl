:- include('minaExample.pl').

/*
estado(PosActual, Dir, _ListaPosesiones, ColocacionCargaPendiente):-
    PosActual = [X,Y],
    (Dir = n; Dir = s; Dir = e; Dir = o),                                          
    (ColocacionCargaPendiente = 'si'; _ColocacionCargaPendiente = 'no').
*/


hay_camino([X,Y], [XNew, YNew], TipoSuelo):-
    celda([X,Y], _TipoSuelo1), celda([XNew,YNew], TipoSuelo),
    ((XNew is X+1, YNew is Y); (XNew is X-1, YNew is Y);
     (XNew is X, YNew is Y+1); (XNew is X, YNew is Y-1)).

tieneLlave(Llave, [Llave]):- !.
tieneLlave(Llave, [Llave | _ListaPosesiones]):- !.
tieneLlave(Llave, [X | ListaPosesiones]):- X \= Llave, tieneLlave(Llave, ListaPosesiones).


/*
Operacion para caminar.
*/
grafo(EstadoActual, EstadoNuevo, caminar, Costo):- 
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    hay_camino([X,Y], [XNew, YNew], TipoSuelo),                                     % Encuentra un camino de [X,Y] a [XNew, YNew]

    ((Dir == n, XNew is X, YNew is Y-1); (Dir == s, XNew is X, YNew is Y+1);        % Obtiene las posiciones validas de acuerdo a la direccion del minero
    (Dir == o, YNew is X, XNew is X-1); (Dir == e, YNew is Y, XNew is X+1)),    
    ((TipoSuelo = firme, Costo is 2); (TipoSuelo = resbaladizo, Costo is 3)),       % Obtiene el costo de la accion, de acuerdo al tipo de suelo
    not(estaEn([p, _Pilar, _AlturaPilar], [XNew, YNew])),                           % No puede cruzar un camino con pilar, independientemente de su altura. 
    not(estaEn([v, _Valla, _AlturaValla], [XNew, YNew])),                           % No puede cruzar un camino con valla, necesariamente debe saltarla.
    (
        (not(estaEn([r, _Reja],[XNew,YNew])));                                      % O biene no hay una reja
        (estaEn([r, Reja],[XNew,YNew]), tieneLlave([l,Llave], ListadoPosesiones), abreReja([l,Llave],[r,Reja]))    % O bien hay una y la cruza solo si tiene la llave correspondiente
    ),
    EstadoNuevo = estado([XNew,YNew], Dir, ListadoPosesiones, ColocacionCargaPendiente).       % Se crea un nuevo hecho con la direccion nueva 

/*
Operacion para rotar(Dir).
*/
grafo(EstadoActual, EstadoNuevo, rotar(Dir), Costo):-
    EstadoActual = estado([X,Y], DirVieja, ListadoPosesiones, ColocacionCargaPendiente),
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
    EstadoIntermedio1 = estado([XNew,YNew], Dir, ListaPosesiones, ColocacionCargaPendiente),    % Estado intermedio para obtener el costo del suelo donde va a caer
    grafo(EstadoIntermedio1, EstadoIntermedio2, caminar, CostoSalto),
    EstadoIntermedio2 = estado([XSalto,YSalto], Dir, ListaPosesiones, ColocacionCargaPendiente), % Estado intermedio para obtener ese resultado
    Costo is CostoSalto+1,
    ((Dir == n, XNew is X, YNew is Y-1); (Dir == s, XNew is X, YNew is Y+1);        % Obtiene las posiciones validas de acuerdo a la direccion del minero
    (Dir == o, YNew is X, XNew is X-1); (Dir == e, YNew is Y, XNew is X+1)),
    
    EstadoNuevo = estado([XSalto,YSalto], Dir, ListadoPosesiones, ColocacionCargaPendiente).

/*
Operacion para juntar_llave(Llave)
*/

grafo(EstadoActual, EstadoNuevo, juntar_llave(Llave), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    estaEn([l,Llave], [X,Y]),                       % Evalua si existe la llave en la Celda
    not(tieneLlave([l,Llave], ListadoPosesiones)),  % No tiene que tener esa llave
    Costo = 1,                                      % Esto tiene un costo de 1
    EstadoNuevo = estado([X,Y], Dir, [[l,Llave] | ListadoPosesiones], ColocacionCargaPendiente).

/*
Operaacion para juntar_carga(Carga)
*/

grafo(EstadoActual, EstadoSiguiente, juntar_carga(Carga), Costo):-
    

/*
juntar_carga(Carga). Carga = [c, NombreC]
juntar_detonador(Detonador). Detonador = [d, NombreD, ActivadoD].
dejar_carga(Carga). Carga = [c, NombreC]
detonar(Detonador). Detonador = [d, NombreD, ActivadoD].

tieneLlave([l,Llave]).
*/