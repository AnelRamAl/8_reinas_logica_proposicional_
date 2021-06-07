% Autor:
% Fecha: 10/10/2019

          %vert([[1,4],[2,2],[3,8]],4).
vert([[_,Y]|_],Y).                      %se barre en Y
vert([[_,_]|Resto],Colum):-vert(Resto,Colum).

          %diag([[1,4],[2,2],[3,8]],4,1).
diag([[X,Y]|_],X1,Y1):-Xn is abs(X-X1), Yn is abs(Y-Y1), Xn==Yn.    %se barre en y para todas las x´s
diag([_|Resto],X1,Y1):-diag(Resto,X1,Y1).

          %sacando la .cadena de los libres de la fila i=4  ,...,8      LL=coor. reinas ya asignadas
           %fre(LL,X,Y,L). -> fre([[1,4],[2,2],[3,8]],4,1,L).      L= [[4, 3], [4, 5], [4, 6]].
fre(_,_,9,[],[]).
fre(LL,X,Y,L,M):- vert(LL,Y), Yn is Y + 1, fre(LL,X,Yn,L,M); diag(LL,X,Y),
                 Yn is Y + 1, fre(LL,X,Yn,L,M).
fre(LL,X,Y,[[X,Y]|R],[M|Resto]):- Yn is Y + 1, append(LL,[[X,Y]],M),fre(LL,X,Yn,R,Resto).
                 %fre([[1,4],[2,2],[3,8]],4,1,_,M).

         % 1. sacando heuristica
         % 2. tomamos el elemento 1 de L y lo agregamos a LL
         % 3. hacemos corrimiento en X para todo Y e incrementamos el contador Cont cada vez
         %    que tengamos un lugar disponible.
         %

         % heuristic(LL,L,X,Y,Cont,Comp). ->
         % fre([[1,4],[2,2],[3,8]],4,1,L), asigna([[1,4],[2,2],[3,8]],L,4,1,0,Comp).
         % fre solo corre una vez,   heuristic corre las veces restantes necesarias 4 anidando fre.
  %Comp = [[1, 4], [2, 2], [3, 8], [4, 3]]

         % aqui LL ya es mi nueva cadena propuesta a evaluar con heuristica y L no se usa de aqui en adelante.
      % fren( [[[1, 4], [2, 2], [3, 8], [4, 3]], [[1, 4], [2, 2], [3, 8], [4, 5]], [[1, 4], [2, 2], [3, 8], [4, 6]]],5,1,0,U,LL).
      %fre([[1,4],[2,2],[3,8]],4,1,_,M), fren(M,5,1,0,U,LL).
                                         % LL = [[8], [9], [10]]
                                         
                %resulfin([[1,4],[2,2],[3,8]],3,4,1,0,1,_,_,_,Resultado).
resulfin(L,X,Xnex,Y,Cont,Contp,U,Finp,Lnew,Un):- final(L,X,Xnex,Y,Cont,Contp,U,Finp,Lnew),
                                        ultimo(Lnew,Un).

          %X=3 Y=1 Xnex=4 Cont=0 Contp=1.
%final([[1,4],[2,2],[3,8]],3,4,1,0,1,U,Finp,Lnew).
final(_,8,_,_,_,_,_,_,[]).
final(L,X,Xnex,Y,Cont,Contp,U,Finp,[Lnew|Resto]):- Xn is X +1, Y is 1, Cont is 0, Contp is 1,
                                          Xnexn is Xnex +1,
                                          fre(L,Xn,Y,U,M),
                                          fren(M,Xnexn,Xnexn,Y,Cont,_,LL),
                                          mejor(LL,LL,_,N), pos(N,LL,Contp,C),
                                          eleccion(C,1,U,Finp),
                                          append(L,[Finp],Lnew), %write(Lnew), nl,
                                          final(Lnew,Xn,Xnexn,_,_,_,_,_,Resto).
                                       
  %Fre([[1,4],[2,2],[3,8]],4,1,U,M), fren(M,5,5,1,0,_,LL), mejor(LL,LL,_,N), pos(N, LL, 1, C), eleccion(C,1,U,E), append([[1,4],[2,2],[3,8]],[E],Lnew).
%U = [[4, 3], [4, 5], [4, 6]],
%M = [[[1, 4], [2, 2], [3, 8], [4, 3]], [[1, 4], [2, 2], [3, 8], [4, 5]], [[1, 4], [2, 2], [3, 8], [4, 6]]],
%LL = [[8], [9], [10]],
%N = 10,
%C = 3,
%E = [4, 6],
%Lnew = [[1, 4], [2, 2], [3, 8], [4, 6]]

 %fre([[1,4],[2,2],[3,8],[4,6],[5,1],[6,3],[7,5]],8,1,U,M), fren(M,9,9,1,0,_,LL), mejor(LL,LL,_,N), pos(N, LL, 1, C), eleccion(C,1,U,E).
%U = [[4, 3], [4, 5], [4, 6]],
%M = [[[1, 4], [2, 2], [3, 8], [4, 3]], [[1, 4], [2, 2], [3, 8], [4, 5]], [[1, 4], [2, 2], [3, 8], [4, 6]]]
%LL = [[8], [9], [10]],
%N = 10,
%C = 3,
%E = [4, 6]
%fre([[1,4],[2,2],[3,8]],4,1,U,M), fren(M,5,5,1,0,_,LL), mejor(LL,LL,_,N), pos(N, LL, 1, C), eleccion(C,1,U,E).

eleccion(Pos,Pos,[],_).
eleccion(Pos,Cont,[L|_],L):- Pos == Cont.
eleccion(Pos,Cont,[_|Rest],S):- Contn is Cont +1, eleccion(Pos,Contn,Rest,S).

%fre([[1,4],[2,2],[3,8]],4,1,U,M), fren(M,5,5,1,0,_,LL), mejor(LL,LL,_,N), pos(N, LL, 1, C).


pos(_,[],_,_).            %pos(10, [[8], [9], [10]], 1, C).
pos(Mejor,[[LL]|Rest],Cont,Cont):- Mejor == LL, pos(Mejor,Rest,Cont,Cont).
pos(Mejor,[[LL]|Rest],Cont,C):- Contn is Cont + 1, pos(Mejor,Rest,Contn,C).

mejor([],_,Lj,Lj).                        %mejor([[11], [33], [10]],[[11], [33], [10]],L,LL).
mejor([Li|Resto],[_,Lj|Rest],Lj,S):- Li>=Lj, Lmax is Li + 0, mejor(Resto,_,Lmax,S).
mejor([Li|Resto],[_,Lj|Rest],Lj,S):- mejor(Resto,_,Lj,S).
mejor([K],_,_,S):- S is K.

fren([],9,_,_,_,_,[]).
fren([Mj|Rest],X,Xsig,Y,Cont,L,[[Ln]|Resto]):- X is Xsig, heur(Mj,X,Y,Cont,Us,Lcont),
                                           suma(Lcont,Cont,L),
                                           Ln is L, fren(Rest,Xn,Xsig,Y,Cont,_,Resto).

suma([],Sum,Sum).                                    %suma([[2], [1], [2], [3]],0,M).
suma([[X]|Resto],Sum,L):- Suma is Sum, Sumn is X+Suma, suma(Resto,Sumn,L).

heur(_,9,_,_,_,[]).    %heur([[1,4],[2,2],[3,8],[4,3]],5,1,0,U,Ur).
heur(LL,X,Y,Cont,Us,[[Uaux]|Resto]):- Xn is X + 1, Yn is 1, Cont is 0,
                                       enlace(LL,X,Y,Cont,U),
                                 Uaux is U, heur(LL,Xn,Yn,Cont,Uaux,Resto).
       % Xm=4, X=5 Xm es fija y X se icrementa
enlace(LL,X,Y,Cont,U):- heuristic(LL,X,Y,Cont,Compi), ultimo(Compi,U).
ultimo(L,U):- append(_,[U|[]],L).% heuristic(LL,X,Y,Cont,Compi).
ultimo(L,U):- U is 0.
heuristic(_,_,9,_,[]).
heuristic(LL,X,Y,Cont,Compi):- vert(LL,Y), Yn is Y + 1, heuristic(LL,X,Yn,Cont,Compi);
                      diag(LL,X,Y), Yn is Y + 1, heuristic(LL,X,Yn,Cont,Compi).
heuristic(LL,X,Y,Cont,[[Contn]|R]):- Yn is Y + 1, Contn is Cont + 1,
                                     heuristic(LL,X,Yn,Contn,R). % writeln(Contn).

                         %fre([[1,4],[2,2],[3,8]],4,1,L), enlace(L,5,1,0,U).