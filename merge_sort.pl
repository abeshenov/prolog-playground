% Merge sort

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
