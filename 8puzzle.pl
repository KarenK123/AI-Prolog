% State represented by list of tile positions
% [t0, t1, t2, t3, t4, t5, t6, t7, t8]
%
%    				  -----x
%    				| 1 2 3
%    				| 8   4
%    				| 7 6 5
%    				y
	
% The goal node
goal([(2,2), (1,1), (2,1), (3,1), (3,2), (3,3), (2,3), (1,3), (1,2)]).

% Starting nodes
% Depth 4
start4([(2,2), (1,1), (3,2), (2,1), (3,1), (3,3), (2,3), (1,3), (1,2)]).

% Depth 5
start5([(2,3), (1,2), (1,1), (3,1), (3,2), (3,3), (2,2), (1,3), (2,1)]).

% Depth 6
start6([(1,3), (1,2), (1,1), (3,1), (3,2), (3,3), (2,2), (2,3), (2,1)]).

% Depth 7
start7([(1,2), (1,3), (1,1), (3,1), (3,2), (3,3), (2,2), (2,3), (2,1)]).

% Depth 8
start8([(2,2), (1,3), (1,1), (3,1), (3,2), (3,3), (1,2), (2,3), (2,1)]).

% Depth 18
start18([(2,2), (2,1), (1,1), (3,3), (1,2), (2,3), (3,1), (1,3), (3,2)]).

% Predicate to help you choose a starting state with solution at different depths
start(I , X) :-
        I == 4, start4(X), !;
        I == 5, start5(X), !;
        I == 6, start6(X), !;
        I == 7, start7(X), !;
        I == 8, start8(X), !;
        I == 18, start18(X).

%  move( State1 , State2 )   generates a successor state
move([E | Tiles], [T| Tiles1])	:-
 	swap(E, T, Tiles, Tiles1).

swap(E, T, [T | Ts], [E | Ts])	:-
	mandist(E , T, 1).

swap(E , T, [T1 | Ts], [T1 | Ts1])	:-
	swap(E, T, Ts, Ts1).

% Manhattan Distance - mandist(TilePos1, TilePos2, Dist) is the distance between two tile positions.

mandist((X,Y), (X1,Y1), D)	:-
	diff(X, X1, Dx),
	diff(Y, Y1, Dy),
	D is Dx + Dy.
	
diff(A, B, D)	:-
    D is A - B, D > 0, !;
	D is B - A.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



showSolPath([]).

showSolPath([P | L])	:-
	showState(P),
    nl,
    write('---'),
    showSolPath(L).
	
showState([P0, P1, P2, P3, P4, P5, P6, P7, P8])	:-
	member( Y , [1, 2, 3] ),
	nl,
	member( X , [1, 2, 3] ), 
	member( Tile-(X,Y), [' '-P0, 1-P1, 2-P2, 3-P3, 4-P4, 5-P5, 6-P6, 7-P7, 8-P8]),
	write(' '),
	write( Tile ),
	fail;
	nl, 
	true.

% Execution predicates
% What is called in Prolog (solve([1,2,3,8,0,4,7,6,5], [0,1,2,3,4,5,6,7,8]).)
%solve(I, X, Soln)			 				:-
%	solve(I, X, [], Soln).



% This predicate helps you choose a starting state and 
% displays the lenght of the eventual solution path.
% More useful here.
dfs2 :-	write('Start at depth 4 5 6 7 8 or 18 ?  : '),
	read(N),
	start(N, X),
	depthControlSolve(X, Sol, 0),
	reverse(Sol, Soln),
	showSolPath(Soln).
    
% This is the central predicate for depth first search
% Same as solve(X, P, S) in notes    
idSolve(X, P, Sol, D) :-
	  D > 0,
	  move(X, Y),
	  not(member(Y, P)),
	  D1 is D - 1,
	  idSolve(Y, [X|P], Sol, D1).
	  
idSolve(X, P, [X|P], D) :-
	  goal(X).

depthControlSolve(X, Sol, D) :-
	  idSolve(X, [], Sol, D),!;
	  D1 is D + 1,
	  depthControlSolve(X, Sol, D1).

