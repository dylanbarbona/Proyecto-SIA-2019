/*---------------------------------------------------------------------------------*/
/*------------------------ESTADOS DEL MINERO---------------------------------------*/
/*---------------------------------------------------------------------------------*/
% grafo(+EstadoActual, -EstadoNuevo, -Operacion, -Costo).

/* Operacion para caminar. */
grafo(EstadoActual, EstadoNuevo, caminar, Costo):- 
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    
    % De acuerdo a la dirección del minero, se obtiene la posición [Xn, Yn]
    ((Dir == n, Xn is X-1, Yn is Y); (Dir == s, Xn is X+1, Yn is Y);       
    (Dir == o, Xn is X, Yn is Y-1); (Dir == e, Xn is X, Yn is Y+1)),  
    
    %Se obtiene el tipo de suelo, y partir de eso, su costo asociado
    celda([Xn,Yn], TipoSuelo),
    ((TipoSuelo = firme, Costo is 2); (TipoSuelo = resbaladizo, Costo is 3)), 
    
    % No debe haber obstaculos en la nueva posicion. Solo rejas que pueden abrirse (con su correspondiente llave)
    not(estaEn([p, _Pilar, _AlturaPilar], [Xn, Yn])),                         
    not(estaEn([v, _Valla, _AlturaValla], [Xn, Yn])),                         
    (
        (not(estaEn([r, _Reja],[Xn,Yn])));                                    
        (estaEn([r, Reja],[Xn,Yn]), member([l,Llave], ListadoPosesiones), abreReja([l,Llave],[r,Reja])) 
    ),
    
    % Se obtiene el estado siguiente del minero, con la nueva posición
    EstadoNuevo = estado([Xn,Yn], Dir, ListadoPosesiones, ColocacionCargaPendiente). 


/* Operacion para rotar(Dir). */
grafo(EstadoActual, EstadoNuevo, rotar(Dir), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], DirVieja, ListadoPosesiones, ColocacionCargaPendiente),
    
    % La dirección solo puede ser [n, s, e, o]
    member(Dir, [n, s, e, o]),
    
    % La direccion nueva debe diferir de la actual
    (DirVieja \= Dir),           
    
    % Distintas configuraciones de rotación, y el costo asociado a cada uno
    (                                                                              
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
    
    % Se obtiene el estado siguiente del minero, con la nueva dirección
    EstadoNuevo = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente).      

/* Operacion para saltar(Dir) */
grafo(EstadoActual, EstadoNuevo, saltar_valla(Valla), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    
    % se obtiene la valla, que debe estar en la posición adyacente a la actual
    Valla = [v, _NombreV, AlturaV],                                                
    celda([XNew,YNew], _TipoSuelo),
    estaEn(Valla, [XNew, YNew]),
    
    %La altura es menor a 4, entonces puede saltarla
    AlturaV =< 4,
    
    %No es un pilar ni una reja
    not(estaEn([p,_,_],[XNew,YNew])),
    not(estaEn([r,_],[XNew,YNew])),                                                
    
    % Se crea un estado intermedio (que no forma parte del plan), solo para caer en la celda siguiente a la de la valla
    EstadoIntermedio1 = estado([XNew,YNew], Dir, ListadoPosesiones, ColocacionCargaPendiente),   
    grafo(EstadoIntermedio1, EstadoIntermedio2, caminar, CostoSalto),
    EstadoIntermedio2 = estado([XSalto,YSalto], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    
    % El costo asociado al salto es el costo la celda en que cayó, mas uno.
    Costo is CostoSalto+1,
    
    % La dirección determina la celda que va a saltar
    ((Dir == n, XNew is X-1, YNew is Y); (Dir == s, XNew is X+1, YNew is Y);       
    (Dir == o, XNew is X, YNew is Y-1); (Dir == e, XNew is X, YNew is Y+1)),
    
    % Se obtiene el estado siguiente del minero, con la celda adyacente a la valla que saltó
    EstadoNuevo = estado([XSalto,YSalto], Dir, ListadoPosesiones, ColocacionCargaPendiente).


/* Operacion para juntar_llave(Llave) */
grafo(EstadoActual, EstadoNuevo, juntar_llave(Llave), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    
    % La llave tiene que estar en la posición actual del minero
    Llave = [l, _NombreL],
    estaEn(Llave, [X,Y]),
    
    % El costo asociado a juntar la llave es 1
    Costo = 1,
    
    % El minero no debe tener la llave entre sus posesiones
    not(member(Llave, ListadoPosesiones)),
    
    % Se obtiene el estado siguiente del minero, con la nueva llave
    EstadoNuevo = estado([X,Y], Dir, [Llave | ListadoPosesiones], ColocacionCargaPendiente).

/* Operacion para juntar_carga(Carga) */
grafo(EstadoActual, EstadoNuevo, juntar_carga(Carga), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, _),
    
    % La carga tiene que estar en la posición actual del minero
    Carga = [c, c1],
    estaEn(Carga, [X,Y]),   
    
    % El minero no debe tener la carga entre sus posesiones
    not(member(Carga, ListadoPosesiones)),
    
    % El costo asociado a juntar la carga es 3
    Costo = 3,                              
    
    % Se obtiene el estado siguiente del minero, con la nueva carga, seteando en 'si' el indicador de colocar la carga
    EstadoNuevo = estado([X,Y], Dir, [Carga | ListadoPosesiones], 'si').

/* Operacion para dejar_carga(Carga) */
grafo(EstadoActual, EstadoNuevo, dejar_carga(Carga), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, 'si'),
    Carga = [c,c1],
    
    % El minero debe estar en la ubicación donde debe dejar la carga
    ubicacionCarga([X,Y]),
    
    % La carga debe estar entre las posesiones del minero
    member(Carga, ListadoPosesiones),
    
    %El costo asociado a dejar la carga es 1
    Costo = 1,
    
    % Se obtiene el estado siguiente del minero, seteando en 'no' el indicador de colocar carga
    EstadoNuevo = estado([X,Y], Dir, ListadoPosesiones, 'no').

/* Operacion para juntar_detonador(Detonador) */ 
grafo(EstadoActual, EstadoNuevo, juntar_detonador(Detonador), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, ColocacionCargaPendiente),
    
    % El detonador tiene que estar en la posición actual del minero
    Detonador = [d, d1, no],
    estaEn(Detonador, [X,Y]),
    
    % El minero no debe tener el detonador entre sus posesiones
    not(member(Detonador, ListadoPosesiones)),
    
    % El costo asociado a juntar el detonador es 2
    Costo = 2,
    
    % Se obtiene el estado siguiente del minero, con el nuevo detonador
    EstadoNuevo = estado([X,Y], Dir, [Detonador | ListadoPosesiones], ColocacionCargaPendiente).

/* Operacion para detonar(Detonador) */
grafo(EstadoActual, EstadoNuevo, detonar(Detonador), Costo):-
    % Se obtiene el estado actual del minero
    EstadoActual = estado([X,Y], Dir, ListadoPosesiones, no),
    
    % El minero debe tener el detonador entre sus posesiones, sin detonar
    Detonador = [d, d1, si],
    member([c,c1], ListadoPosesiones),
    member([d, d1, no], ListadoPosesiones),
    not(member([d, d1, si], ListadoPosesiones)),
    sitioDetonacion([X,Y]),
    
    % El costo asociado a detonar es 1
    Costo = 1,
    
    % Se obtiene el estado siguiente del minero, seteando en 'si' el detonador
    EstadoNuevo = estado([X,Y], Dir, [[d, d1, si] | ListadoPosesiones], no).