% Permutations

permutation(Xs, [Z|Zs]) :- select(Z, Xs, Ys), permutation(Ys, Zs).
permutation([], []).

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Naive sort

permutation_sort(Xs, Ys) :- permutation(Xs, Ys), ordered(Ys).

ordered([]).
ordered([_]).
ordered([X, Y|Ys]) :- X =< Y, ordered([Y|Ys]).

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Parity

count_inversions(_, [], 0).
count_inversions(X, [Y|Ys], N) :- Y > X, count_inversions(X, Ys, N1), N is N1 + 1.
count_inversions(X, [_|Ys], N) :- count_inversions(X, Ys, N).

inversion_num([], 0).
inversion_num([X|Xs], N) :- count_inversions(X, Xs, N1), inversion_num(Xs, N2), N is N1 + N2.

even_permutation(Xs, Ys) :- permutation(Xs, Ys), inversion_num(Ys, N), even(N).
odd_permutation(Xs, Ys) :- permutation(Xs, Ys), inversion_num(Ys, N), odd(N).

even(X) :- 0 is mod(X, 2).
odd(X) :- 1 is mod(X, 2).
