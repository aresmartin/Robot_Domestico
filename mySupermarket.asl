// Agent mySupermarket in project DomesticRobot.mas2j

/* Initial beliefs and rules */

// Identificador de la última orden entregada
last_order_id(1).

/* Initial goals */

!deliverBeer.

/* Plans */

+!deliverBeer : last_order_id(N) & orderFrom(Ag, Qtd) <-
	OrderId = N + 1;
    -+last_order_id(OrderId);
    deliver(Product,Qtd);
    .send(Ag, tell, delivered(Product, Qtd, OrderId));
	-orderFrom(Ag, Qtd);
	!deliverBeer.
	
+!deliverBeer <- !deliverBeer.
	
// plan to achieve the goal "order" for agent Ag
+!order(beer, Qtd)[source(Ag)] <- 
	+orderFrom(Ag, Qtd);
	.println("Pedido de ", Qtd, " cervezas recibido de ", Ag).
