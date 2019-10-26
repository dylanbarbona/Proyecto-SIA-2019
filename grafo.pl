:- include('minaExample.pl').

hay_camino([X,Y], [XNew, YNew], TipoSuelo):-
    celda([X,Y], _TipoSuelo1), celda([XNew,YNew], TipoSuelo),
    ((XNew is X+1, YNew is Y); (XNew is X-1, YNew is Y);
     (XNew is X, YNew is Y+1); (XNew is X, YNew is Y-1)).

/*
Operacion para caminar.
*/
grafo(EstadoActual, EstadoNuevo, caminar, Costo):- 
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    hay_camino([X,Y], [XNew, YNew], TipoSuelo),                                     % Encuentra un camino de [X,Y] a [XNew, YNew]

    ((Dir == o, XNew is X, YNew is Y-1); (Dir == e, XNew is X, YNew is Y+1);        % Obtiene las posiciones validas de acuerdo a la direccion del minero
    (Dir == n, YNew is X, XNew is X-1); (Dir == s, YNew is Y, XNew is X+1)),    
    ((TipoSuelo = firme, Costo is 2); (TipoSuelo = resbaladizo, Costo is 3)),       % Obtiene el costo de la accion, de acuerdo al tipo de suelo
    not(estaEn([p, _Pilar, _AlturaPilar], [XNew, YNew])),                           % No puede cruzar un camino con pilar, independientemente de su altura. 
    not(estaEn([v, _Valla, _AlturaValla], [XNew, YNew])),                           % No puede cruzar un camino con valla, necesariamente debe saltarla.
    (
        (not(estaEn([r, _Reja],[XNew,YNew])));                                      % O biene no hay una reja
        (estaEn([r, Reja],[XNew,YNew]), member([l,Llave], ListadoPosesiones), abreReja([l,Llave],[r,Reja]))    % O bien hay una y la cruza solo si tiene la llave correspondiente
    ),
    EstadoNuevo = estado([XNew,YNew], Dir, ListadoPosesiones, ColocacionCargaPendiente).       % Se crea un nuevo hecho con la direccion nueva 


/*
Operacion para rotar(Dir).
*/
grafo(EstadoActual, EstadoNuevo, rotar(Dir), Costo):-
    EstadoActual = estado([X,Y], DirVieja, ListadoPosesiones, ColocacionCargaPendiente),
    member(Dir, [n, s, e, o]),
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
    
    EstadoIntermedio1 = estado([XNew,YNew], Dir, ListadoPosesiones, ColocacionCargaPendiente),    % Estado intermedio para obtener el costo del suelo donde va a caer
    grafo(EstadoIntermedio1, EstadoIntermedio2, caminar, CostoSalto),
    EstadoIntermedio2 = estado([XSalto,YSalto], Dir, ListadoPosesiones, ColocacionCargaPendiente), % Estado intermedio para obtener ese resultado
    Costo is CostoSalto+1,
    ((Dir == o, XNew is X, YNew is Y-1); (Dir == e, XNew is X, YNew is Y+1);        % Obtiene las posiciones validas de acuerdo a la direccion del minero
    (Dir == n, YNew is X, XNew is X-1); (Dir == s, YNew is Y, XNew is X+1)),
    
    EstadoNuevo = estado([XSalto,YSalto], Dir, ListadoPosesiones, ColocacionCargaPendiente).

/*
Operacion para juntar_llave(Llave)
*/

grafo(EstadoActual, EstadoNuevo, juntar_llave(Llave), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    Llave = [l, _NombreL],
    estaEn(Llave, [X,Y]),                                                                       % Evalua si existe la llave en la Celda
    Costo = 1,                                                                                  % Esto tiene un costo de 1
    not(member(Llave, ListadoPosesiones)),
    EstadoNuevo = estado([X,Y], Dir, [Llave | ListadoPosesiones], ColocacionCargaPendiente).    % Se agrega la llave a la lista de posesiones

/*
Operacion para juntar_carga(Carga)
*/

grafo(EstadoActual, EstadoNuevo, juntar_carga(Carga), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, _ColocacionCargaPendiente),
    Carga = [c, _NombreC],
    estaEn(Carga, [X,Y]),                                                          % Evalua si la carga esta en su posicion
    not(member(Carga, ListadoPosesiones)),
    Costo = 3,                                                                          % Esto tiene un costo de 3
    EstadoNuevo = estado([X,Y], Dir, [Carga | ListadoPosesiones], 'si').           % Se agrega la carga y se setea la colocaci�n pendiente como si

/*
Operacion para dejar_carga(Carga)
*/
grafo(EstadoActual, EstadoNuevo, dejar_carga(Carga), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, 'si'),
    ubicacionCarga([X,Y]),
    member(Carga, ListadoPosesiones),
    Costo = 1,
    EstadoNuevo = estado([X,Y], Dir, ListadoPosesiones, 'no').

/*
Operacion para juntar_detonador(Detonador)
*/  

grafo(EstadoActual, EstadoNuevo, juntar_detonador(Detonador), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, 'no'),
    Detonador = [d, _NombreD, no],
    estaEn(Detonador, [X,Y]),
    member([c,_], ListadoPosesiones),
    not(member(Detonador, ListadoPosesiones)),
    Costo = 2,
    EstadoNuevo = estado([X,Y], Dir, [Detonador | ListadoPosesiones], 'no').

/*
Operacion para detonar(Detonador)
*/
grafo(EstadoActual, EstadoNuevo, detonar(Detonador), Costo):-
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, 'no'),
    Detonador = [d, NombreD, 'no'],
    member([c,_], ListadoPosesiones),
    member(Detonador, ListadoPosesiones),
    not(member([d, NombreD, 'si'], ListadoPosesiones)),
    sitioDetonacion([X,Y]),
    Costo = 1,
    EstadoNuevo = estado([X,Y], Dir, [[d, NombreD, 'si'] | ListadoPosesiones], 'no').