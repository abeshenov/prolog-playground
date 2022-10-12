% Biblical genealogy.
% The Art of Prolog, Chapter 1-2.

% Genesis 11.

% And Terah lived seventy years, and begat Abram, Nahor, and Haran.

parent(terah,abram).
parent(terah,nahor).
parent(terah,haran).

% Now these are the generations of Terah:
% Terah begat Abram, Nahor, and Haran; and Haran begat Lot.

parent(haran,lot).

% And Abram and Nahor took them wives: the name of Abram's wife was Sarai;
% and the name of Nahor's wife, Milcah, the daughter of Haran,
% the father of Milcah, and the father of Iscah.

parent(haran,milcah).
parent(haran,iscah).

% Genesis 21.

% And the Lord visited Sarah as he had said, and the Lord did unto Sarah as
% he had spoken. For Sarah conceived, and bare Abraham a son in his old age,
% at the set time of which God had spoken to him. And Abraham called the name
% of his son that was born unto him, whom Sarah bare to him, Isaac.

parent(abram,isaac).
parent(sarai,isaac).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

male(terah).
male(abram).
male(nahor).
male(haran).
male(isaac).
male(lot).

female(sarai).
female(milcah).
female(iscah).

% UNIVERSAL FACT: "everyone likes pomegranates"
likes(_, pomegranates).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

father(X,Y) :- parent(X,Y), male(X).
father(X) :- father(X,_).

mother(X,Y) :- parent(X,Y), female(X).
mother(X) :- mother(X,_).

child(X,Y) :- parent(Y,X).
son(X,Y) :- child(X,Y), male(X).
daughter(X,Y) :- child(X,Y), female(X).

grandparent(X,Y) :- parent(X,Z), parent(Z,Y).

procreated(Man,Woman) :- father(Man,Child), mother(Woman,Child).

sibling(X,Y) :- parent(Z,X), parent(Z,Y), X \= Y.
brother(X,Y) :- sibling(X,Y), male(X).

ancestor(Ancestor,Descendant) :- parent(Ancestor,Descendant).
ancestor(Ancestor,Descendant) :- parent(Ancestor,Person), ancestor(Person,Descendant).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*

?- father(abram,X).
X = isaac.

?- son(X,terah).
X = abram ;
X = nahor ;
X = haran

?- likes(sarai,pomegranates).
true.

?- grandparent(X,isaac).
X = terah .

?- sibling(X,abram).
X = nahor ;
X = haran

?- brother(X,abram).
X = nahor ;
X = haran

?- ancestor(terah,X).
X = abram ;
X = nahor ;
X = haran ;
X = isaac ;
X = lot ;
X = milcah ;
X = iscah

*/
