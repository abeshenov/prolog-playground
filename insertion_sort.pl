% Insertion sort

insertion_sort([X|Xs], Ys) :- insertion_sort(Xs, Zs), insert(X, Zs, Ys).
insertion_sort([], []).

insert(X, [], [X]).
insert(X, [Y|Ys], [Y|Zs]) :- X > Y, insert(X, Ys, Zs).
insert(X, [Y|Ys], [X, Y|Ys]) :- X =< Y.
