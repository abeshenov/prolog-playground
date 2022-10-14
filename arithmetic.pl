% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% The Art of Prolog
% Section 3.1: Arithmetic
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

natural_number(0).
natural_number(s(X)) :- natural_number(X).

plus(0,X,X) :- natural_number(X).
plus(s(X),Y,s(Z)) :- plus(X,Y,Z).

times(0,X,0) :- natural_number(X).
times(s(X),Y,Z) :- times(X,Y,XY), plus(XY,Y,Z).

exp(0,s(N),0) :- natural_number(N).
exp(X,0,s(0)) :- natural_number(X).
exp(X,s(N),Y) :- exp(X,N,Z), times(Z,X,Y).

factorial(0, s(0)).
factorial(s(N), X) :- factorial(N, Y), times(s(N), Y, X).

mod(X,Y,X) :- lt(X,Y).
mod(X,Y,Z) :- plus(X1,Y,X), mod(X1,Y,Z).

ackermann(0, N, s(N)).
ackermann(s(M), 0, Val) :- ackermann(M, s(0), Val).
ackermann(s(M), s(N), Val) :- ackermann(s(M), N, Val1), ackermann(M,Val1,Val).

gcd(X,0,X) :- gt(X,0).
gcd(X,Y,Gcd) :- mod(X,Y,Z), gcd(Y,Z,Gcd).

lcm(X,Y,Lcm) :- gcd(X,Y,Gcd), times(X,Y,XY), times(Lcm,Gcd,XY).

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Exercises

% Exercise (i). Modify Program 3.2 for < to axiomatize the relations
% <, >, and >=. Discuss multiple uses of these programs.

lt(0, s(X)) :- natural_number(X).
lt(s(X), s(Y)) :- lt(X, Y).

le(0, X) :- natural_number(X).
le(s(X), s(Y)) :- le(X, Y).

gt(X,Y) :- natural_number(X), natural_number(Y), \+ le(X,Y).
ge(X,Y) :- natural_number(X), natural_number(Y), \+ lt(X,Y).

minimum(X,Y,X) :- le(X,Y).
minimum(X,Y,Y) :- le(Y,X).

maximum(X,Y,X) :- ge(X,Y).
maximum(X,Y,Y) :- ge(Y,X).

% Exercise (iv). Define predicates even(X) and odd(X) for determining if
% a natural number is even or odd.

even(0).
even(s(s(X))) :- even(X).

odd(s(0)).
odd(s(s(X))) :- odd(X).

% Exercise (v). Write a logic program defining the relation fib(N,F) to
% determine the Nth Fibonacci number F.

fib(0,0).
fib(s(0),s(0)).
fib(s(s(N)), F2) :- fib(s(N), F1), fib(N, F), plus(F, F1, F2).

% Exercise (vi). The predicate times can be used for computing exact quotients
% with queries such as times(s(s(0)),X,s(s(s(s(0)))))? to find the result of
% 4 divided by 2. The query times(s(s(0)),X,s(s(s(0))))? to find 3/2 has no
% solution. Many applications require the use of integer division that would
% calculate 3/2 to be 1. Write a program to compute integer quotients. 

quotient(X,Y,Q) :- times(Y,Q,YQ), mod(X,Y,Rem), plus(YQ,Rem,X).

% Exercise (vii). Modify Program 3.10 for finding the gcd of two integers so
% that it performs repeated subtraction directly rather than use the mod
% function.

gcd_sub(X,X,X) :- natural_number(X).
gcd_sub(X,Y,Gcd) :- lt(X,Y), plus(Z,X,Y), gcd_sub(Z,X,Gcd).
gcd_sub(X,Y,Gcd) :- gcd_sub(Y,X,Gcd).

% Exercise (viii). Rewrite the logic programs in Section 3.1 using a different
% representation of natural numbers, namely as a sum of 1's. 

natural_number_(1).
natural_number_(X+1) :- natural_number_(X).

plus_(1,X,X+1) :- natural_number_(X).
plus_(X+1,Y,Z+1) :- plus_(X,Y,Z).

times_(1,X,X) :- natural_number_(X).
times_(X+1,Y,Z) :- times_(X,Y,XY), plus_(XY,Y,Z).

even_(1+1).
even_(X+1+1) :- even_(X).

odd_(1).
odd_(X+1+1) :- odd_(X).

/*

This is to see full terms:
?- set_prolog_flag(answer_write_options, [quoted(true), portray(true), spacing(next_argument)]).
true.


?- le(s(s(0)), s(s(s(0)))).
true.

?- le(s(s(0)), s(0)).
false.

?- plus(s(s(0)), s(s(0)), X).
X = s(s(s(s(0)))).

?- factorial(s(s(s(0))), X).
X = s(s(s(s(s(s(0)))))).

?- lcm(s(s(s(0))), s(s(s(s(0)))), X).
X = s(s(s(s(s(s(s(s(s(s(s(s(0)))))))))))) 

?- even(s(s(s(0)))).
false.

?- odd(s(s(s(0)))).
true.

?- fib(s(s(s(s(s(s(s(0))))))), X).
X = s(s(s(s(s(s(s(s(s(s(s(s(s(0))))))))))))).

?- quotient(s(s(s(s(s(s(s(0))))))), s(s(0)), X).
X = s(s(s(0))) .

?- quotient(s(s(s(s(s(s(s(0))))))), s(s(s(0))), X).
X = s(s(0)) .

?- ackermann(s(s(0)), s(s(0)), X).
X = s(s(s(s(s(s(s(0))))))) .

?- ackermann(s(s(s(0))), s(0), X).
X = s(s(s(s(s(s(s(s(s(s(s(s(s(0))))))))))))) .

*/
