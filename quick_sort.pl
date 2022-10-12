% Quick sort

quick_sort([X|Xs], Ys) :-
    partition(Xs, X, Small, Big),
    quick_sort(Small, SmallSorted),
    quick_sort(Big, BigSorted),
    append(SmallSorted, [X|BigSorted], Ys).

quick_sort([], []).

partition([X|Xs], Y, [X|Small], Big) :- X =< Y, partition(Xs, Y, Small, Big).
partition([X|Xs], Y, Small, [X|Big]) :- X > Y, partition(Xs, Y, Small, Big).
partition([], _, [], []).
