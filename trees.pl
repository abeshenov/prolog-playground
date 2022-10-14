% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% The Art of Prolog
% Section 3.4: Binary Trees
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

[lists].

binary_tree(void).
binary_tree(tree(_, Left, Right)) :- binary_tree(Left), binary_tree(Right).

tree_member(X, tree(X, _, _)).
tree_member(X, tree(_, Left, _)) :- tree_member(X, Left).
tree_member(X, tree(_, _, Right)) :- tree_member(X, Right).

isotree(void, void).
isotree(tree(X, Left1, Right1),tree(X, Left2, Right2)) :-
    isotree(Left1, Left2), isotree(Right1, Right2).
isotree(tree(X, Left1, Right1), tree(X,Left2, Right2)) :-
    isotree(Left1, Right2), isotree(Right1, Left2).

substitute(_, _, void, void).
substitute(X, Y, tree(Node,Left,Right), tree(Node1,Left1,Right1)) :-
    replace(X, Y, Node, Node1),
    substitute(X, Y, Left, Left1),
    substitute(X, Y, Right, Right1).

replace(X, Y, X, Y).
replace(X, _, Z, Z) :- X \= Z.

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Traversals

preorder(tree(X,L,R), Xs) :-
    preorder(L, Ls),
    preorder(R, Rs),
    append([X|Ls], Rs, Xs).
preorder(void, []).

inorder(tree(X,L,R), Xs) :-
    inorder(L, Ls),
    inorder(R, Rs),
    append(Ls, [X|Rs], Xs).
inorder(void, []).

postorder(tree(X,L,R), Xs) :-
    postorder(L, Ls),
    postorder(R, Rs),
    append(Rs, [X], Rs1),
    append(Ls, Rs1, Xs).
postorder(void, []).

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Heaps

% A binary tree satisfies the heap property if the value at each node
% is at least as large as the value at its children (if they exist).
% Heaps, a class of binary trees that satisfy the heap property, are a useful
% data structure and can be used to implement priority queues efficiently.

% Make into a heap while preserving the shape
heapify(void,void).
heapify(tree(X,L,R), Heap) :-
    heapify(L,HeapL),
    heapify(R,HeapR),
    adjust(X,HeapL,HeapR,Heap).

adjust(X, HeapL, HeapR, tree(X, HeapL, HeapR)) :-
    greater(X,HeapL), greater(X,HeapR).

adjust(X, tree(X1,L,R), HeapR, tree(X1,HeapL,HeapR)) :-
    X < X1, greater(X1,HeapR), adjust(X,L,R,HeapL).

adjust(X, HeapL, tree(X1,L,R), tree(X1,HeapL,HeapR)) :-
    X < X1, greater(X1,HeapL), adjust(X,L,R,HeapR).

greater(_, void).
greater(X, tree(X1,_,_)) :- X >= X1.

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Exercises

% Exercise (i). Define a program for subtree(S, T), where S is a subtree of T.

subtree(S, S).
subtree(S, tree(_, L, _)) :- subtree(S, L).
subtree(S, tree(_, _, R)) :- subtree(S, R).

% Exercise (ii). Define the relation sum_tree(TreeOfIntegers, Sum), which holds
% if Sum is the sum of the integer elements in TreeOfIntegers.

sum_tree(void, 0).
sum_tree(tree(X,L,R), S) :- sum_tree(L, LS), sum_tree(R, RS), S is LS + RS + X.

/*
?- sum_tree(tree(1,tree(2,void,void),tree(3,void,void)), S).
S = 6.
*/

% Exercise (iii).
% Define the relation ordered(TreeofIntegers), which holds if Tree
% is an ordered tree of integers, that is, for each node in the tree
% the elements in the left subtree are smaller than the element in
% the node, and the elements in the right subtree are larger than
% the element in the node. (Hint: Define two auxiliary relations,
% ordered_left(X,Tree) and ordered_right(X,Tree), which hold
% if both Tree is ordered and X is larger (respectively, smaller) than
% the largest (smallest) node of Tree.)

ordered(void).
ordered(tree(X,L,R)) :-
    elements_smaller(X, L),
    elements_larger(X, R),
    ordered(L),
    ordered(R).

elements_smaller(_, void).
elements_smaller(X, tree(Y,L,R)) :-
    Y < X,
    elements_smaller(X, L),
    elements_smaller(X, R).

elements_larger(_, void).
elements_larger(X, tree(Y,L,R)) :-
    Y > X,
    elements_larger(X, L),
    elements_larger(X, R).

/*

?- ordered(tree(5, tree(3,tree(1,void,void),tree(4,void,void)),
                   tree(7,void,void))).
true ;

*/

% Exercise (iv). Define the relation tree_insert(X, Tree, Tree1), which holds if
% Tree1 is an ordered tree resulting from inserting X into the ordered
% tree Tree. If X already occurs in Tree, then Tree and Tree1 are identical.
% (Hint: Four axioms suffice.)

tree_insert(X, void, tree(X, void, void)).
tree_insert(X, tree(X, L, R), tree(X, L, R)).
tree_insert(X, tree(Y, L, R), tree(Y, L1, R)) :- X < Y, tree_insert(X, L, L1).
tree_insert(X, tree(Y, L, R), tree(Y, L, R1)) :- X > Y, tree_insert(X, R, R1).

list_to_tree([], void).
list_to_tree([X|Xs], T) :- list_to_tree(Xs, T1), tree_insert(X, T1, T).

tree_to_list(void, []).
tree_to_list(tree(X, L, R), List) :-
    tree_to_list(L, ListL),
    tree_to_list(R, ListR),
    append(ListL, [X], List1),
    append(List1, ListR, List).

tree_sort(Xs, Ys) :- list_to_tree(Xs, T), tree_to_list(T, Ys).

/*

?- tree_sort([25, -7, 18, 40, -6, -48, -17, 21], Xs).
Xs = [-48, -17, -7, -6, 18, 21, 25, 40]

*/

% Exercise (v). Write a logic program for the relation path(X, Tree, Path),
% where Path is the path from the root of the tree Tree to X.

path(X, tree(X,_,_), [X]).
path(X, tree(Y,L,_), [Y|Xs]) :- path(X, L, Xs).
path(X, tree(Y,_,R), [Y|Xs]) :- path(X, R, Xs).

/*

?- path(3, tree(5,tree(4, tree(1,void,void), tree(3,void,void)),
                  tree(9, tree(3,void,void), tree(10,void,void))), P).
P = [5, 4, 3] ;
P = [5, 9, 3] ;

*/
