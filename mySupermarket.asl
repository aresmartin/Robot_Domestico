// Agent mySupermarket in project DomesticRobot.mas2j

/* Initial beliefs and rules */

// Identificador de la última orden entregada
last_order_id(1).
stock(beer, 2).

/* Initial goals */

!deliverBeer.

/* Plans */

+!deliverBeer : last_order_id(N) & orderFrom(Ag, Qtd) & stock(beer,B) & B < Qtd <-
	.print("No tengo cantidad suficiente de cervezas");
	-orderFrom(Ag, Qtd);
	!deliverBeer.

+!deliverBeer : last_order_id(N) & orderFrom(Ag, Qtd) & stock(beer,B) & B > Qtd <-
	OrderId = N + 1;
    -+last_order_id(OrderId);
    deliver(Product,Qtd);
	NumberOfBeers = B - Qtd;
	+stock(beer, NumberOfBeers);
    .send(Ag, tell, delivered(Product, Qtd, OrderId));
	-orderFrom(Ag, Qtd);
	!deliverBeer.
	
+!deliverBeer <- !deliverBeer.
	
// plan to achieve the goal "order" for agent Ag
+!order(beer, Qtd)[source(Ag)] <- 
	+orderFrom(Ag, Qtd);
	.println("Pedido de ", Qtd, " cervezas recibido de ", Ag).
	
	
