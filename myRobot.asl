/* Initial beliefs and rules */

// initially, I believe that there is some beer in the fridge
available(beer,fridge).

// my owner should not consume more than 10 beers a day :-)
limit(beer,5).

too_much(B) :-
   .date(YY,MM,DD) &
   .count(consumed(YY,MM,DD,_,_,_,B),QtdB) &
   limit(B,Limit) &
   QtdB > Limit.

/* Initial goals */

!bringBeer.

/* Plans */

+!bring(myOwner, beer) <-
	+asked(beer).
	
+!bringBeer : healthMsg(_) <- 
	!go_at(myRobot,base);
	.println("El Robot descansa porque Owner ha bebido mucho hoy.").
+!bringBeer : asked(beer) & not healthMsg(_) <- 
	.println("Owner me ha pedido una cerveza.");
	!go_at(myRobot,fridge);
	!take(fridge,beer);
	!go_at(myRobot,myOwner);
	!hasBeer(myOwner);
	.println("Ya he servido la cerveza y elimino la petición.");
	.abolish(asked(Beer));
	!bringBeer.
+!bringBeer : not asked(beer) & not healthMsg(_) <- 
	.wait(2000);
	.println("Robot esperando la petición de Owner.");
	!bringBeer.

+!take(fridge, beer) : not too_much(beer) <-
	.println("El robot está cogiendo una cerveza.");
	!check(fridge, beer).
+!take(fridge,beer) : too_much(beer) & limit(beer, L) <-
	.concat("The Department of Health does not allow me to give you more than ", L," beers a day! I am very sorry about that!", M);
	-+healthMsg(M).
	
+!check(fridge, beer) : not ordered(beer) & available(beer,fridge) <-
	.println("El robot está en el frigorífico y coge una cerveza.");
	.wait(1000);
	open(fridge);
	.println("El robot abre la nevera.");
	get(beer);
	.println("El robot coge una cerveza.");
	close(fridge);
	.println("El robot cierra la nevera.").
+!check(fridge, beer) : not ordered(beer) & not available(beer,fridge) <-
	.println("El robot está en el frigorífico y hace un pedido de cerveza.");
	!orderBeer(mySupermarket);
	!check(fridge, beer).
+!check(fridge, beer) <-
	.println("El robot está esperando ................");
	.wait(5000);
	!check(fridge, beer).

+!orderBeer(Supermarket) : not ordered(beer) <-
	.println("El robot ha realizado un pedido al supermercado.");
	!go_at(myRobot,delivery);
	.println("El robot va a la ZONA de ENTREGA.");
	.send(Supermarket, achieve, order(beer,3));
	+ordered(beer).
+!orderBeer(Supermarket).

+!hasBeer(myOwner) : not too_much(beer) <-
	hand_in(beer);
	.println("He preguntado si Owner ha cogido la cerveza.");
	?has(myOwner,beer);
	.println("Se que Owner tiene la cerveza.");
	// remember that another beer has been consumed
	.date(YY,MM,DD); .time(HH,NN,SS);
	+consumed(YY,MM,DD,HH,NN,SS,beer).
+!hasBeer(myOwner) : too_much(beer) & healthMsg(M) <- 
	//.abolish(msg(_));
	.send(myOwner,tell,msg(M)).

+!go_at(myRobot,P) : at(myRobot,P) <- true.
+!go_at(myRobot,P) : not at(myRobot,P)
  <- move_towards(P);
     !go_at(myRobot,P).

// when the supermarket makes a delivery, try the 'has' goal again
+delivered(beer,_Qtd,_OrderId)[source(mySupermarket)] <- 
	-ordered(beer);
	+available(beer,fridge);
	.wait(1000);
	!go_at(myRobot,fridge).

// when the fridge is opened, the beer stock is perceived
// and thus the available belief is updated
+stock(beer,0) :  available(beer,fridge) <-
	-available(beer,fridge).
+stock(beer,N) :  N > 0 & not available(beer,fridge) <-
	-+available(beer,fridge).

+?time(T) : true
  <-  time.check(T).

/*
-!bringBeer : true <-
	.current_intention(I);
	.println("Failed to achieve goal '!bring(owner,beer)'.");
	.println("Current intention is: ", I).
*/
