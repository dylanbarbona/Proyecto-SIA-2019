/* Grafo de fronteras y pesos (distancias)
   Agregado el ciclo pedido
*/

grafo(1,2,operacion,199).
grafo(1,3,operacion,264).
grafo(1,4,operacion,237).
grafo(2,5,operacion,134).
grafo(3,5,operacion,69).
grafo(4,6,operacion,136).
grafo(6,7,operacion,207).
grafo(5,7,operacion,118).
grafo(5,8,operacion,130).
grafo(8,2,operacion,47).

/* heuristica usada                  */
/* distancia en linea recta ficticia */
h(1,300).
h(2,250).
h(3,250).
h(4,100).
h(5,80).
h(6,50).
h(7,50).
h(8,200).

encontrar_mejor_camino(C1, C2, Camino):- 
	a_estrella([[0,C1]], C2, CaminoAux),
	reverse(CaminoAux, Camino), !.

/* a_estrella
   Aplicamos el algoritmo de busqueda A*.
   Empezando del nodo inicial, construimos los caminos posibles
   utilizando los predicados auxiliares definidos mas abajo. 
   Primero elegimos el camino de mejor f (en el caso inicial va a tomar el nodo inicial), 
   expandimos las fronteras de este ultimo, saco el camino viejo de los caminos actuales
   y sigo aplicando el algoritmo en la lista de caminos que tiene a los caminos viejos sin el 
   borrado y los caminos nuevos expandidos, para comparar todos.
*/

a_estrella(Caminos, Dest, [C,Dest|Camino]):- 
	member([C, Dest | Camino], Caminos),
	elegir_mejorf(Caminos, [C1|_]),
	C1 == C.
a_estrella(Caminos, Destino, MejorCamino):- 
	elegir_mejorf(Caminos, MejorF),
	delete(Caminos, MejorF, CaminosAnteriores),
	expandir_frontera(MejorF, NuevosCaminos),
	append(CaminosAnteriores, NuevosCaminos, L),
	a_estrella(L, Destino, MejorCamino).

/*
   elegir_mejorf
   De todos los caminos nuevos expandidos por la frontera elegimos
   el de mejor f = h + g, es decir, la eleccion que hace el algoritmo A*.
   Comparamos cada primer elemento del camino (o sea los costos) y a eso
   le sumamos la heuristica correspondiente del penultimo elemento de 
   la lista (o sea la ciudad actual). Eso nos da f, y elegimos el camino de mejor f.
*/

elegir_mejorf([X],X):-!.
elegir_mejorf([[C1,Ci1|Y],[C2,Ci2|_]|Z], MejorF):-
	h(Ci1, H1),
	h(Ci2, H2),
	H1 +  C1 =< H2 +  C2,
	elegir_mejorf([[C1,Ci1|Y]|Z], MejorF).
elegir_mejorf([[C1,Ci1|_],[C2,Ci2|Y]|Z], MejorF):-
	h(Ci1, H1),
	h(Ci2, H2),
	H1  + C1 > H2 +  C2,
	elegir_mejorf([[C2,Ci2|Y]|Z], MejorF).


/* 
expandirFrontera.
Buscamos todos los nodos del grafo que
   sean frontera de la ciudad actual
   y lo adherimos a la lista L.
   Luego actualizamos los costos de todos los caminos nuevos
   que hay en L.
   Nota: el not member es para no pasar por nodos ya visitados y corregir el error
   de los ciclos.
*/
expandir_frontera([Costo,Ciudad|Camino],Caminos):- 
	findall([Costo,CiudadNueva,Ciudad|Camino],
		(grafo(Ciudad, CiudadNueva, _Operacion,_),
		not(member(CiudadNueva,Camino))),
		L),
	cambiar_costos(L, Caminos).

/* cambiar_costos 
   Actualizo los costos de cada camino, una vez agregado
   el ultimo nodo. 
   Recordar que cada camino esta representado por una lista donde el primer
   elemento es el costo total del camino y los elementos siguientes de la cola son
   los indices de las ciudades que reprensentan.
   [Costo_Total|Camino]. 
*/
cambiar_costos([],[]):-!.
cambiar_costos([[Costo_Total,Ci1,Ci2|Camino]|Y],[[NuevoCosto_Total,Ci1,Ci2|Camino]|Z]):-
	grafo(Ci2, Ci1, _Operacion, Distancia),
	NuevoCosto_Total is Costo_Total + Distancia,
	cambiar_costos(Y,Z).