% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% The Art of Prolog
% Section 3.3: Composing Recursive Programs
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

[lists].

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

% Permutations
permutation(Xs, [Z|Zs]) :- select(Z, Xs, Ys), permutation(Ys, Zs).
permutation([], []).

% Naive permutation sort
permutation_sort(Xs, Ys) :- permutation(Xs, Ys), ordered(Ys).

ordered([]).
ordered([_]).
ordered([X, Y|Ys]) :- X =< Y, ordered([Y|Ys]).

% Insertion sort
insertion_sort([X|Xs], Ys) :- insertion_sort(Xs, Zs), insert(X, Zs, Ys).
insertion_sort([], []).

insert(X, [], [X]).
insert(X, [Y|Ys], [Y|Zs]) :- X > Y, insert(X, Ys, Zs).
insert(X, [Y|Ys], [X, Y|Ys]) :- X =< Y.

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

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Exercises

% Exercise (i). Write a program for substitute(X,Y,L1,L2), where L2 is the
% result of substituting Y for all occurrences of X in L1, e.g.,
% substitute(a,x,[a,b,a,c],[x,b,x,c]) is true, whereas
% substitute(a,x,[a,b,a,c],[a,b,x,c]) is false.

substitute(_, _, [], []).
substitute(X, Y, [X|Xs], [Y|Ys]) :- substitute(X, Y, Xs, Ys).
substitute(X, Y, [A|Xs], [A|Ys]) :- A \= X, substitute(X, Y, Xs, Ys).

% Exercise (ii). What is the meaning of the variant of select.

select_var(X, [X|Xs], Xs).
select_var(X, [Y|_], [Y|_]) :- X \= Y.
select_var(_, _, _).
% --- this appends X to Ys, unless Ys have the first element repeated.

% Exercise (iii). Write a program for no_doubles(L1,L2),
% where L2 is the result of removing all duplicate elements from L1, e.g.,
% no_doubles ([a,b,c,b], [a,c,b]) is true.

no_doubles([], []).
no_doubles([X|Xs], Zs) :- member(X,Xs), no_doubles(Xs,Zs), !.
no_doubles([X|Xs], [X|Zs]) :- \+ member(X,Xs), no_doubles(Xs,Zs), !.

% Exercise (iv). Write programs for even_permutation(Xs, Ys) and
% odd_permutation(Xs, Ys) that find Ys, the even and odd permutations,
% respectively, of a list Xs. For example,
% even_permutation([1,2,3],[2,3,1]) and odd_peimutation([1,2,3],[2,1,3])
% are true.

count_inversions(_, [], 0).
count_inversions(X, [Y|Ys], N) :- Y > X, count_inversions(X, Ys, N1), N is N1 + 1.
count_inversions(X, [_|Ys], N) :- count_inversions(X, Ys, N).

inversion_num([], 0).
inversion_num([X|Xs], N) :- count_inversions(X, Xs, N1), inversion_num(Xs, N2), N is N1 + N2.

even_permutation(Xs, Ys) :- permutation(Xs, Ys), inversion_num(Ys, N), even(N).
odd_permutation(Xs, Ys) :- permutation(Xs, Ys), inversion_num(Ys, N), odd(N).

even(X) :- 0 is mod(X, 2).
odd(X) :- 1 is mod(X, 2).

% Exercise (v). Write a program for merge sort.

take(_, 0, []).
take([X|Xs], N, [X|Ys]) :- take(Xs, N1, Ys), N is N1 + 1.

drop(Xs, 0, Xs).
drop([_|Xs], N, Ys) :- drop(Xs, N1, Ys), N is N1 + 1.

split_in_half(Xs, Ys, Zs) :-
    len(Xs, Nx), N is div(Nx, 2),
    take(Xs, N, Ys),
    drop(Xs, N, Zs).

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

% Exercise (vi). Write a logic program for that implements the linear algorithm
% for finding the kth largest element K of a list Xs.

% I suspect the books refers to https://en.wikipedia.org/wiki/Quickselect
% but something is off with the description.

% Inspired by
% https://github.com/abeshenov/leetcode/blob/main/haskell/KthLargestElement.hs

quick_select_partition([X|Xs], Smaller, Equal, Bigger) :-
    smaller(X, Xs, Smaller),
    equal(X, [X|Xs], Equal),
    bigger(X, Xs, Bigger).

smaller(_, [], []).
smaller(X, [Y|Ys], [Y|Zs]) :- Y < X, smaller(X, Ys, Zs).
smaller(X, [Y|Ys], Zs) :- Y >= X, smaller(X, Ys, Zs).

equal(_, [], []).
equal(X, [Y|Ys], [Y|Zs]) :- Y == X, equal(X, Ys, Zs).
equal(X, [Y|Ys], Zs) :- Y \= X, equal(X, Ys, Zs).

bigger(_, [], []).
bigger(X, [Y|Ys], [Y|Zs]) :- Y > X, bigger(X, Ys, Zs).
bigger(X, [Y|Ys], Zs) :- Y =< X, bigger(X, Ys, Zs).

kth_largest(K, [X|Xs], Y) :-
    quick_select_partition([X|Xs], _, _, Bigger),
    length(Bigger, BiggerLen),
    K =< BiggerLen,
    kth_largest(K, Bigger, Y).

kth_largest(K, [X|Xs], Y) :-
    quick_select_partition([X|Xs], Smaller, Equal, Bigger),
    length(Bigger, BiggerLen),
    length(Equal, EqualLen),
    K > BiggerLen + EqualLen,
    K1 is K - BiggerLen - EqualLen,
    kth_largest(K1, Smaller, Y).

kth_largest(K, [X|Xs], X) :-
    quick_select_partition([X|Xs], _, Equal, Bigger),
    length(Bigger, BiggerLen),
    length(Equal, EqualLen),
    BiggerLen < K, K =< BiggerLen + EqualLen.

% Exercise (vii). Write a program for the relation
% better_poker_hand(Hand1,Hand2,Hand) that succeeds if Hand is the better poker
% hand between Hand1 and Hand2.
%
% For those unfamiliar with this card game, here are some rules of poker
% necessary for answering this exercise:
%
%   - The order of cards is 2, 3, 4, 5, 6, 7, 8, 9, 10, jack, queen, king, ace.
%   - Each hand consists of five cards.
%   - The rank of hands in ascending order is
%       no pairs < one pair < two pairs < three of a kind < flush <
%           straight < full house < four of a kind < straight flush.
%   - Where two cards have the same rank, the higher denomination wins,
%     for example, a pair of kings beats a pair of 7's.

card(2).
card(3).
card(4).
card(5).
card(6).
card(7).
card(8).
card(9).
card(10).
card(jack).
card(queen).
card(king).
card(ace).

rank(jack, 11).
rank(queen, 12).
rank(king, 13).
rank(ace, 14).
rank(N, N) :- integer(N), 2 =< N, N =< 10.

card_lt(X,Y) :- card(X), card(Y), rank(X, R), rank(Y, S), R < S.

% I got bored at this point because I know nothing about poker.
% This looks complicated to me:
% https://en.wikipedia.org/wiki/List_of_poker_hands
