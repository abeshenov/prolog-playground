%% Arithmetic.
%% The Art of Prolog, Section 3.1.

square(X,Y) :- Y is X*X.

exp(0, N, 0) :- N > 0, !.
exp(X, 0, 1) :- X >= 0, !.
exp(X, N, Y) :- even(N), N1 is div(N,2), exp(X,N1,Z), square(Z, Y).
exp(X, N, Y) :- odd(N), N1 is N - 1, exp(X,N1,Z), Y is Z*X.

even(X) :- 0 is mod(X,2).
odd(X) :- 1 is mod(X,2).

factorial(0, 1) :- !.
factorial(N, X) :- N1 is N - 1, factorial(N1, Y), X is N*Y.

table fib/2.
fib(0, 1) :- !.
fib(1, 1) :- !.
fib(N, F) :-
        N > 1,
        N1 is N-1,
        N2 is N-2,
        fib(N1, F1),
        fib(N2, F2),
        F is F1+F2.

gcd(X,0,X) :- X > 0, !.
gcd(X,Y,Gcd) :- Z is mod(X,Y), gcd(Y,Z,Gcd).

lcm(X,Y,Lcm) :- gcd(X,Y,Gcd), XY is X*Y, Lcm is div(XY, Gcd).

/*

?- square(256, X).
X = 65536.

?- exp(2, 16, X).
X = 65536 .

?- factorial(10, X).
X = 3628800.

?- fib(7, X).
X = 21.

?- fib(10, X).
X = 89.

?- gcd(30,75,X).
X = 15.

?- lcm(30,75,X).
X = 150.

*/
