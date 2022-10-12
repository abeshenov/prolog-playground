% Lists.
% The Art of Prolog, Section 3.2, 3.3.

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

% substitution:
% ?- substitute(a,x, [a,b,a,c], Xs).
% Xs = [x, b, x, c]
substitute(_, _, [], []).
substitute(X, Y, [X|Xs], [Y|Ys]) :- substitute(X, Y, Xs, Ys).
substitute(X, Y, [A|Xs], [A|Ys]) :- A \= X, substitute(X, Y, Xs, Ys).

/*

prefix, suffix, member in terms of append:

prefix(Xs, Ys) :- append(Xs, _, Ys).
suffix(Xs, Ys) :- append(_, Xs, Ys).
member(X, Ys) :- append(_, [X|Xs], Ys).

*/

reverse([], []).
reverse([X|Xs], Zs) :- reverse(Xs, Ys), append(Ys, [X], Zs).

reverseAcc(Xs, Ys) :- reverseAcc(Xs, [], Ys).
reverseAcc([X|Xs], Acc, Ys) :- reverseAcc(Xs, [X|Acc], Ys).
reverseAcc([], Ys, Ys).

adjacent(X, Y, [X|[Y|_]]).
adjacent(X, Y, [_|Zs]) :- adjacent(X, Y, Zs).

last([X], X) :- !.
last([_|[X|Xs]], Y) :- last([X|Xs], Y).

% list length:
len([], 0) :- !.
len([_|Xs], N) :- len(Xs, N1), N is N1 + 1.

% subsequence is different from sublist: e.g.
% subsequence([1,3], [1,2,3]) = true
% sublist([1,3], [1,2,3]) = false
subsequence([X|Xs], [X|Ys]) :- subsequence(Xs, Ys).
subsequence(Xs, [_|Ys]) :- subsequence(Xs, Ys).
subsequence([], _).

% repeats each element twice:
% ?- double([1,2,3], Xs).
% Xs = [1, 1, 2, 2, 3, 3].
double([], []).
double([X|Xs], [X|[X|Zs]]) :- double(Xs, Zs).

% ?- sum([1,2,3,4,5], X).
% X = 15.
sum([], 0).
sum([X|Xs], S) :- sum(Xs, S1), S is S1 + X.

% ?- delete([1,2,1,3,1,4,1,5,1], 1, Xs).
% Xs = [2, 3, 4, 5]
% ?- delete([1,2,1,3,1,4,1,5,1], X, [2, 3, 4, 5]).
% X = 1 .
delete([X|Xs], X, Ys) :- delete(Xs, X, Ys).
delete([X|Xs], Z, [X|Ys]) :- X \= Z, delete(Xs, Z, Ys).
delete([], _, []).

% remove one occurrence of X:
select(X, [X|Xs], Xs).
select(X, [Y|Ys], [Y|Zs]) :- select(X, Ys, Zs).

% Q: what is the meaning of this variant of select?
% A: appends X to Ys, unless Ys have the first element repeated.
selectVar(X, [X|Xs], Xs).
selectVar(X, [Y|_], [Y|_]) :- X \= Y.
selectVar(_, _, _).

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Permutation sort
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

permutationSort(Xs, Ys) :- permutation(Xs, Ys), ordered(Ys).

permutation(Xs, [Z|Zs]) :- select(Z, Xs, Ys), permutation(Ys, Zs).
permutation([], []).

ordered([]).
ordered([_]).
ordered([X, Y|Ys]) :- X =< Y, ordered([Y|Ys]).

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Insertion sort
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

insertionSort([X|Xs], Ys) :- insertionSort(Xs, Zs), insert(X, Zs, Ys).
insertionSort([], []).

insert(X, [], [X]).
insert(X, [Y|Ys], [Y|Zs]) :- X > Y, insert(X, Ys, Zs).
insert(X, [Y|Ys], [X, Y|Ys]) :- X =< Y.

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Quick sort
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

quick_sort([X|Xs], Ys) :-
    partition(Xs, X, Small, Big),
    quick_sort(Small, SmallSorted),
    quick_sort(Big, BigSorted),
    append(SmallSorted, [X|BigSorted], Ys).

quick_sort([], []).

partition([X|Xs], Y, [X|Small], Big) :- X =< Y, partition(Xs, Y, Small, Big).
partition([X|Xs], Y, Small, [X|Big]) :- X > Y, partition(Xs, Y, Small, Big).
partition([], _, [], []).

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Permutations by parity
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

count_inversions(_, [], 0).
count_inversions(X, [Y|Ys], N) :- Y > X, count_inversions(X, Ys, N1), N is N1 + 1.
count_inversions(X, [_|Ys], N) :- count_inversions(X, Ys, N).

inversion_num([], 0).
inversion_num([X|Xs], N) :- count_inversions(X, Xs, N1), inversion_num(Xs, N2), N is N1 + N2.

even_permutation(Xs, Ys) :- permutation(Xs, Ys), inversion_num(Ys, N), even(N).
odd_permutation(Xs, Ys) :- permutation(Xs, Ys), inversion_num(Ys, N), odd(N).

even(X) :- 0 is mod(X, 2).
odd(X) :- 1 is mod(X, 2).

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Merge sort
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

take(_, 0, []).
take([X|Xs], N, [X|Ys]) :- take(Xs, N1, Ys), N is N1 + 1.

drop(Xs, 0, Xs).
drop([_|Xs], N, Ys) :- drop(Xs, N1, Ys), N is N1 + 1.

split_in_half(Xs, Ys, Zs) :- len(Xs, Nx), N is div(Nx, 2), take(Xs, N, Ys), drop(Xs, N, Zs).

merge([], Xs, Xs).
merge(Xs, [], Xs).
merge([X|Xs], [Y|Ys], [X|Zs]) :- X =< Y, merge(Xs, [Y|Ys], Zs).
merge([X|Xs], [Y|Ys], [Y|Zs]) :- X > Y, merge([X|Xs], Ys, Zs).

merge_sort([], []).
merge_sort([X], [X]).
merge_sort(Xs, Zs) :-
    split_in_half(Xs, As, Bs),
    merge_sort(As, AsSorted),
    merge_sort(Bs, BsSorted),
    merge(AsSorted, BsSorted, Zs).

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

?- reverseAcc([1,2,3], Xs).
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
