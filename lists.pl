% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% The Art of Prolog
% Section 3.2: Lists
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

list([]).
list([_|Xs]) :- list(Xs).

member(X, [X|_]).
member(X, [_|Ys]) :- member(X, Ys).

prefix([], _).
prefix([X|Xs], [X|Ys]) :- prefix(Xs, Ys).

suffix(Xs, Xs).
suffix(Xs, [_|Ys]) :- suffix(Xs, Ys).

sublist(Xs, Ys) :- prefix(Xs, Ys).
sublist(Xs, [_|Ys]) :- sublist(Xs, Ys).

append([], Ys, Ys).
append([X|Xs],Ys,[X|Zs]) :- append(Xs,Ys,Zs).

/*

prefix, suffix, member in terms of append:

prefix(Xs, Ys) :- append(Xs, _, Ys).
suffix(Xs, Ys) :- append(_, Xs, Ys).
member(X, Ys) :- append(_, [X|Xs], Ys).

*/

reverse([], []).
reverse([X|Xs], Zs) :- reverse(Xs, Ys), append(Ys, [X], Zs).

reverse_acc(Xs, Ys) :- reverse_acc(Xs, [], Ys).
reverse_acc([X|Xs], Acc, Ys) :- reverse_acc(Xs, [X|Acc], Ys).
reverse_acc([], Ys, Ys).

adjacent(X, Y, Zs) :- append(_, [X,Y|_], Zs).
last(X, Xs) :- append(_, [X], Xs).

% list length:
len([], 0) :- !.
len([_|Xs], N) :- len(Xs, N1), N is N1 + 1.

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Exercises

% Exercise (i).
% subsequence is different from sublist: e.g.
% subsequence([1,3], [1,2,3]) = true
% sublist([1,3], [1,2,3]) = false
subsequence([X|Xs], [X|Ys]) :- subsequence(Xs, Ys).
subsequence(Xs, [_|Ys]) :- subsequence(Xs, Ys).
subsequence([], _).

% Exercise (ii). Write recursive programs for adjacent and last that have the
% same meaning as the predicates defined in the text in terms of append.
adjacent_rec(X, Y, [X|[Y|_]]).
adjacent_rec(X, Y, [_|Zs]) :- adjacent_rec(X, Y, Zs).

last_rec(X, [X]).
last_rec(Y, [_|[X|Xs]]) :- last_rec(Y, [X|Xs]).

% Exercise (iii). Write a program for double (List,ListList), where every
% element in List appears twice in ListList, e.g.,
% double([1,2,3] [1,1,2,2,3,3]) is true.
double([], []).
double([X|Xs], [X|[X|Zs]]) :- double(Xs, Zs).

% Exercise (v). Define the relation sum(ListofIntegers,Sum), which holds if
% Sum is the sum of the ListOfIntegers.
% * Here we'll use real arithmetic in Prolog.
sum([], 0).
sum([X|Xs], S) :- sum(Xs, S1), S is S1 + X.

/*

?- sublist([3,4,5],[1,2,3,4,5,6]).
true.

?- append([1,2,3],[4,5,6],Zs).
Zs = [1, 2, 3, 4, 5, 6].

?- prefix(Xs, [1,2,3]).
Xs = [] ;
Xs = [1] ;
Xs = [1, 2] ;
Xs = [1, 2, 3] ;

?- last([1,2,3], X).
X = 3.

?- reverse([1,2,3], Xs).
Xs = [3, 2, 1].

?- reverse_acc([1,2,3], Xs).
Xs = [3, 2, 1].

?- suffix(Xs, [1,2,3]).
Xs = [1, 2, 3] ;
Xs = [2, 3] ;
Xs = [3] ;
Xs = [] ;

?- sublist(Xs, [1,2,3]).
Xs = [] ;
Xs = [1] ;
Xs = [1, 2] ;
Xs = [1, 2, 3] ;
Xs = [] ;
Xs = [2] ;
Xs = [2, 3] ;
Xs = [] ;
Xs = [3] ;
Xs = [] ;

?- adjacent(X, Y, [0,1,2,3]).
X = 0,
Y = 1 ;
X = 1,
Y = 2 ;
X = 2,
Y = 3 ;

*/
