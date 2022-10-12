% Peano arithmetic.
% The Art of Prolog, Section 3.1.

natural_number(0).
natural_number(s(X)) :- natural_number(X).

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

gcd(X,0,X) :- gt(X,0).
gcd(X,Y,Gcd) :- mod(X,Y,Z), gcd(Y,Z,Gcd).

lcm(X,Y,Lcm) :- gcd(X,Y,Gcd), times(X,Y,XY), times(Lcm,Gcd,XY).

even(0).
even(s(s(X))) :- even(X).

odd(s(0)).
odd(s(s(X))) :- odd(X).

fib(0,0).
fib(s(0),s(0)).
fib(s(s(N)), F2) :- fib(s(N), F1), fib(N, F), plus(F, F1, F2).

quotient(X,Y,Q) :- times(Y,Q,YQ), mod(X,Y,Rem), plus(YQ,Rem,X).

gcd_sub(X,X,X) :- natural_number(X).
gcd_sub(X,Y,Gcd) :- lt(X,Y), plus(Z,X,Y), gcd_sub(Z,X,Gcd).
gcd_sub(X,Y,Gcd) :- gcd_sub(Y,X,Gcd).

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

*/
