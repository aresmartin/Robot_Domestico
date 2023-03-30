/* Initial beliefs and rules */

/* Initial goals */

!drink(beer).   

/* Plans */

// if I have not beer finish, in other case while I have beer, sip

+!drink(beer) : ~couldDrink(beer) <-
	.println("Owner ha bebido demasiado por hoy.").	
+!drink(beer) : has(myOwner,beer) & asked(beer) <-
	.println("Owner va a empezar a beber cerveza.");
	-asked(beer);
	sip(beer);
	!drink(beer).
+!drink(beer) : has(myOwner,beer) & not asked(beer) <-
	sip(beer);
	.println("Owner está bebiendo cerveza.");
	!drink(beer).
+!drink(beer) : not has(myOwner,beer) & not asked(beer) <-
	.println("Owner no tiene cerveza.");
	!get(beer);
	!drink(beer).
+!drink(beer) : not has(myOwner,beer) & asked(beer) <- 
	.println("Owner está esperando una cerveza.");
	.wait(5000);
	!drink(beer).
	
+!get(beer) : not asked(beer) <-
	.send(myRobot, achieve, bring(myOwner,beer));
	.println("Owner ha pedido una cerveza al robot.");
	+asked(beer).

+msg(M)[source(Ag)] <- 
	.print("Message from ",Ag,": ",M);
	+~couldDrink(beer);
	-msg(M).

