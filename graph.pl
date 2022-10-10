%% Directed graph.
%% The Art of Prolog, Chapter 2.

edge(a,b).
edge(a,c).
edge(b,d).
edge(c,d).
edge(d,e).
edge(f,g).

connected(Node, Node).
connected(Node1, Node2) :- edge(Node1,Link), connected(Link, Node2).

/*

?- connected(a,X).
X = a ;
X = b ;
X = d ;
X = e ;
X = c ;
X = d ;
X = e

*/
