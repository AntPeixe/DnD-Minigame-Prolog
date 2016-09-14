%---NÓS DO GRAFO------------------------
%---no(IDno, NOME)-------------------- 
no(1, 'Quarto 1').
no(2, 'Arrecadação').
no(3, 'Sala Principal').
no(4, 'Sala de Jogos').
no(5, 'Quarto 2').
no(6, 'Cruzamento Quartos').
no(7, 'Cruzamento 1 SalaJogos').
no(8, 'Cruzamento 2 SalaJogos').
no(9, 'Cruzamento Arrecadação').
no(10, 'Sala do Sótão').
no(11, 'Quarto Sótão').
no(12, 'Casa de Banho').


%---CRUZAMENTOS-------------------------
%---cruza(IDno)-----------
cruza(6).
cruza(7).
cruza(8).
cruza(9).


%---QUARTOS-----------------------------
%---quarto(IDno)------------------------
quarto(1).
quarto(2).
quarto(3).
quarto(4).
quarto(5).
quarto(10).
quarto(11).
quarto(12).


%---LUZ/VISIBILIDADE--------------------
%---light(IDno)-------------------------
light(2).
light(3).
light(4).
light(7).
light(8).
light(9).


%---PASSAGENS---------------------------
%---passagem(IDno1, IDno2, DIR)-------------
passagem(1, 6, o).
passagem(1, 3, s).
passagem(2, 9, s).
passagem(3, 4, e).
passagem(3, 6, o1).
passagem(3, 7, o2).
passagem(3, 1, n).
passagem(4, 3, o).
passagem(4, 7, s1).
passagem(4, 8, s2).
passagem(4, 9, n).
passagem(5, 6, e).
passagem(5, 10, up).
passagem(6, 1, e).
passagem(6, 5, o).
passagem(6, 3, s).
passagem(7, 3, o).
passagem(7, 4, n).
passagem(7, 8, e).
passagem(8, 7, o).
passagem(8, 4, n).
passagem(8, 9, e).
passagem(9, 2, n).
passagem(9, 4, s).
passagem(9, 8, e).
passagem(10, 11, e).
passagem(10, 5, down).
passagem(11, 12, n).
passagem(11, 10, o).
passagem(12, 11, s).


%---ITEMS-------------------------------
%---item(NOMEitem, DESCRICAO)-----------
item(chave, 'Chaveiro de Ouro').
item(espada, 'Espada do Rei Artur').
item(lanterna, 'Lanterna de LEDs').
item(corda, 'Corda de Alpinismo').
item(escudo, 'Escudo de Ossos').
item(pera, 'Pêra Super Nutritiva').
item(agua, 'Água Mineral').
item(burger, 'Delicioso Cheeseburger').


%---VALOR DOS ITEMS---------------------
%---itemvalue(NOMEitem, PRECOVENDA, PRECOCOMPRA)
itemvalue(chave, 10, 40).
itemvalue(espada, 20, 35).
itemvalue(lanterna, 20, 60).
itemvalue(corda, 5, 15).
itemvalue(escudo, 20, 35).
itemvalue(pera, 1, 10).
itemvalue(agua, 5, 20).
itemvalue(burger, 3, 15).


%---COMIDA------------------------------
%---food(NOMEitem, NUTRICAO, QUANTliquidos)
food(pera, -5, 0).
food(burger, -10, 2).
food(agua, 0, -15).

%---SITIOS DOS ITEMS NOS QUARTOS--------
%---itempos(NOMEitem, IDno)-------------
itempos(chave, 12).
itempos(espada, 4).
itempos(lanterna, 2).
itempos(corda, 3).
itempos(escudo, 4).
itempos(pera, vendor).
itempos(agua, vendor).
itempos(burger, vendor).


%---POSIÇÃO INICIAL DO JOGADOR----------
%---inicial(IDno)-----------------------
inicial(3).


%---PASSWORD PARA MODO WIZARD-----------
%---password(X)-------------------------
password(526).


%---SITIOS DO/S VENDEDOR/ES-------------
%---vendorpos(IDno)---------------------
vendorpos(3).


%---ITEM QUE DÁ A VIITÓRIA--------------
%---winitem(NOMEitem)-------------------
winitem(chave).