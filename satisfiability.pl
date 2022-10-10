%% Satisfiability of boolean formulae.
%% The Art of Prolog, Section 3.5.

satisfiable(true) :- !.
satisfiable(and(X,Y)) :- satisfiable(X), satisfiable(Y).
satisfiable(or(X,_)) :- satisfiable(X).
satisfiable(or(_,Y)) :- satisfiable(Y).
satisfiable(not(X)) :- invalid(X).

invalid(false) :- !.
invalid(or(X,Y)) :- invalid(X), invalid(Y).
invalid(and(X,_)) :- invalid(X).
invalid(and(_,Y)) :- invalid(Y).
invalid(not(Y)) :- satisfiable(Y).

/*

?- satisfiable(and(X, not(X))).
false.

?- satisfiable(or(X, not(X))).
X = true .

*/
