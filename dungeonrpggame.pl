%---DUNGEON RPG GAME-------------------
%---ANTÓNIO PEIXE - 34164 -------------
%---PROGRAMAÇÃO DECLARATIVA------------


%---Inicialization------------------------------------------
:- initialization(consult(map)).

:- dynamic(pos/1).
:- dynamic(invent/1).
:- dynamic(reco/0).
:- dynamic(trackedactions/1).
:- dynamic(wiz/0).
:- dynamic(itemlocal/2).
:- dynamic(inhand/1).
:- dynamic(vendoritems/1).
:- dynamic(money/1).
:- dynamic(hunger/1).
:- dynamic(thirst/1).

rpg :- reset, inicial(X), !, placeitems, asserta(pos(X)), bigBorder,
    process(vitals), smallBorder, process(look), bigBorder, ciclo.

reset :- retractall(pos(_)), retractall(invent(_)), retractall(reco),
    retractall(trackedactions(_)), retractall(wiz), retractall(itemlocal(_,_)),
    retractall(inhand(_)), retractall(vendoritems(_)), retractall(money(_)),
    assertz(money(10)), retractall(hunger(_)), assertz(hunger(0)),
    retractall(thirst(_)), assertz(thirst(0)).

placeitems :- itempos(X,vendor), assertz(vendoritems(X)), fail.
placeitems :- itempos(X,Y), \+Y==vendor, assertz(itemlocal(X,Y)), fail.
placeitems.

ciclo :- repeat,
    (alive -> read(X),
        (X = stop -> !,true; bigBorder, (process(X) -> true ;
            write('Não é um comando válido'), nl), bigBorder, fail);
        !, true).
%-----------------------------------------------------------


%---Move To A Direction-------------------------------------
process(go(N)) :- reco, !, asserta(trackedactions(go(N))),
    pos(Y), passagem(Y, C, N), retractall(pos(_)),
    asserta(pos(C)), changeHunger(3), changeThirst(5),
    process(vitals), smallBorder, process(look).
process(go(N)) :-
    pos(Y), passagem(Y, C, N), !, retractall(pos(_)),
    asserta(pos(C)), changeHunger(3), changeThirst(5),
    process(vitals), smallBorder, process(look).
process(go(_)) :- write('Não existe passagem nessa direcção'), nl.
%-----------------------------------------------------------
   
    
%---Inventory Methods---------------------------------------
process(inv) :- invent(X), write(X), nl, fail.
process(inv).

process(get(X)) :- inventSize(S),
    (S==3 -> !, write('Não tem mais espaço no inventário'), nl;
        reco, !, asserta(trackedactions(get(X))), pos(Y), itemlocal(X, Y), 
        retract(itemlocal(X,Y)), asserta(invent(X)), item(X,Z),
        write('Apanhou '), write(Z), nl, changeHunger(2)).
process(get(X)) :- inventSize(S),
    (S==3 -> !, write('Não tem mais espaço no inventário'), nl;
        pos(Y), itemlocal(X, Y), !,
        retract(itemlocal(X,Y)), asserta(invent(X)), item(X,Z),
        write('Apanhou '), write(Z), nl, changeHunger(2)).
process(get(_)) :- write('Não pode/consegue apanhar esse item'), nl.

process(drop(X)) :- reco, !, asserta(trackedactions(drop(X))),
    invent(X), pos(Y), retract(invent(X)), assertz(itemlocal(X,Y)),
    item(X,Z), write('Largou '), write(Z), nl.
process(drop(X)) :-
    invent(X), pos(Y), retract(invent(X)), assertz(itemlocal(X,Y)),
    item(X,Z), write('Apanhou '), write(Z), nl.
process(drop(_)) :- write('Não pode/consegue largar esse item'), nl.
%-----------------------------------------------------------


%---Look Methods (room and items inside)--------------------
process(look) :-
    pos(X), \+light(X), inhand(lanterna), !, item(lanterna,Y),
    format('A ~w está a ilumina-lo nesta zona escura', [Y]),
    nl, view, viewvendor.
process(look) :- pos(X), \+light(X), !,
    write('Impossível saber onde está, não há luz'), nl.
process(look) :- view, viewvendor.
%-----------------------------------------------------------


%---Record Methods------------------------------------------
process(record) :- retractall(reco), asserta(reco).

process(forget) :- retractall(reco).

process(track) :- trackedactions(X), write(X), nl, fail.
process(track).
%-----------------------------------------------------------


%---Wizard Mode Methods-------------------------------------
process(wizardon(X)) :-
    password(X), !, retractall(wiz), asserta(wiz),
    write('Está em modo wizard'), nl.
process(wizardon(_)) :- write('Password errada'), nl.

process(wizardoff) :- wiz, !, retractall(wiz), write('Saiu de modo wizard'), nl.
process(wizardoff).

process(jump(N)) :- wiz, !, retractall(pos(_)), asserta(pos(N)),
    process(look).
process(jump(_)).

process(warp(X)) :- wiz, !, retract(itemlocal(X,_)), pos(Y),
    assertz(itemlocal(X, Y)), item(X, Z),
    format('Fez warp de ~w', [Z]), nl.
process(warp(_)).

process(destroy(X)) :- wiz, !, pos(Y), retract(itemlocal(X,Y)), item(X, Z),
    format('Destruiu ~w', [Z]), nl.
process(destroy(_)).
%-----------------------------------------------------------


%---Equip Item Methods----------------------------------------
process(equip(X)) :- invent(X), retract(invent(X)), !, process(deequip), assertz(inhand(X)),
    item(X,Z), write('Equipou '), write(Z), nl.
process(equip(_)) :-
    write('Não pode equipar esse item porque não está no inventário'), nl.
process(deequip) :- retract(inhand(X)), !, assertz(invent(X)).
process(deequip).
process(equipped) :-
    inhand(X), !, item(X, Y), format('Tem equipado ~w', [Y]), nl.
process(equipped) :- write('Não tem nada equipado'), nl.
%-----------------------------------------------------------


%---Shop Methods--------------------------------------------
process(shop) :- pos(X), vendorpos(X), light(X), !, shopping.
process(shop) :- pos(X), vendorpos(X), inhand(lanterna), !, shopping.
process(shop) :- pos(X), light(X), !,
    write('Não existe loja nesta localização'), nl.
process(shop) :- write('Não consegue ver se há loja porque não tem luz'), nl.

process(sell(X)) :- reco, !, asserta(trackedactions(sell(X))),
    pos(Y), vendorpos(Y), invent(X), retract(invent(X)), !,
    itemvalue(X,V,_), retract(money(M)), M1 is V+M, assertz(money(M1)),
    item(X, Z), format('Vendeu ~w', [Z]), nl.
process(sell(X)) :- pos(Y), vendorpos(Y), invent(X), retract(invent(X)), !, 
    itemvalue(X,V,_), retract(money(M)), M1 is V+M, assertz(money(M1)),
    item(X, Z), format('Vendeu ~w', [Z]), nl.
process(sell(_)) :- write('Não pode/consegue vender esse item'), nl.

process(buy(X)) :- inventSize(S),
    (S==3 -> !, write('Não tem mais espaço no inventário'), nl;
        reco,!, asserta(trackedactions(buy(X))),
        pos(Y), vendorpos(Y), vendoritems(X), !, itemvalue(X,_,V), money(M),
        ( M@>=V -> M1 is M-V, retract(money(_)), assertz(money(M1)), assertz(invent(X)),
            item(X, Z), format('Comprou ~w', [Z]), nl;
            write('Não tem dinheiro suficiente.'), nl)).
process(buy(X)) :- inventSize(S),
    (S==3 -> !, write('Não tem mais espaço no inventário'), nl;
        pos(Y), vendorpos(Y), vendoritems(X), !, itemvalue(X,_,V), money(M),
        ( M@>=V -> M1 is M-V, retract(money(_)), assertz(money(M1)), assertz(invent(X)),
            item(X, Z), format('Comprou ~w', [Z]), nl;
            write('Não tem dinheiro suficiente.'), nl)).
process(buy(_)) :- write('Não pode/consegue comprar esse item'), nl.
%-----------------------------------------------------------

%---Vitals Methods------------------------------------------
process(vitals) :- hunger(H), thirst(T),
    format('A sua fome está a ~w', [H]), nl,
    format('A sua sede está a ~w', [T]), nl.

process(use(X)) :- food(X,H,T), inhand(X), !, retract(inhand(X)),
    changeHunger(H), changeThirst(T),
    format('Usou ~w', [X]), nl, smallBorder, process(vitals).
process(use(X)) :- food(X,_,_), !,
    format('Equipe o alimento ~w para poder usar', [X]), nl.
process(use(_)) :- write('Não é um alimento'), nl.
%-----------------------------------------------------------



%---Auxiliar Methods----------------------------------------
bigBorder :- write('----------------------'), nl.
smallBorder :- write('----'), nl.


viewvendor :- pos(X), vendorpos(X), !, smallBorder, write('Nesta zona há uma loja'), nl.
viewvendor.

view :- pos(X), no(X, Z), write('Está em '),
    write(Z), nl, write('Tem saidas nas direcções '),
    setof(A, Y^passagem(X,Y,A), K), write(K),nl,
    viewitems(X).
viewitems(X) :- itemlocal(_,X), !, smallBorder, write('Existem os items:'), nl, viewitems2(X).
viewitems(_).

viewitems2(X) :- itemlocal(I,X), item(I,D), write(D), write(' *'),
    write(I), write('* '), nl, fail.
viewitems2(_).


inventSize(S) :- (inhand(_) -> Z is 1; Z is 0), bagof(X,invent(X),L), !,
    length(L,S1), S is S1 + Z.
inventSize(0).

shopping :- money(M), format('Tem ~w moedas', [M]), nl, smallBorder,
    write('Nesta loja pode comprar:'), nl, shopitems, smallBorder,
    (invent(_) -> write('Pode vender:'), nl, sellitems;
    write('Não tem nenhum item para vender'), nl).
shopitems :- vendoritems(X), item(X,Y), itemvalue(X,_,B),
    format('> ~w *~w* -> ~w moedas', [Y,X,B]), nl, fail.
shopitems.
sellitems :- invent(X), item(X,Y), itemvalue(X,V,_),
    format('> ~w *~w* -> ~w moedas', [Y,X,V]), nl, fail.
sellitems.


changeHunger(X) :- retract(hunger(H)), X1 is H+X,
    (X1 @<0 -> assertz(hunger(0)); assertz(hunger(X1))).
changeThirst(X) :- retract(thirst(T)), X1 is T+X,
    (X1 @<0 -> assertz(thirst(0)); assertz(thirst(X1))).


alive :- hunger(H),
    (H@>=50 -> nl, write('Morreu à fome'),fail;
        thirst(Y), (Y@>=50 -> nl, write('Morreu à sede'),fail;
            winitem(X), (invent(X) -> nl, write('Parabéns!!! Encontrou o item secreto'), fail;
            true))).
%-----------------------------------------------------------
