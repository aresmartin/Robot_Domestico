import jason.environment.grid.*;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;


/** class that implements the View of Domestic Robot application */
public class MyHouseView extends GridWorldView {

    MyHouseModel hmodel;

    public MyHouseView(MyHouseModel model) {
        super(model, "Domestic Robot", 700);
        hmodel = model;
        defaultFont = new Font("Arial", Font.BOLD, 16); // change default font
        setVisible(true);
        repaint();
    }

    /** draw application objects */
    @Override
    public void draw(Graphics g, int x, int y, int object) {
        Location lRobot = hmodel.getAgPos(0);
        super.drawObstacle(g,x,y);
		//super.drawAgent(g, x, y, Color.lightGray, -1);
        switch (object) {
        case MyHouseModel.FRIDGE:
			super.drawAgent(g, x, y, Color.white, -1);
			if (lRobot.equals(hmodel.lFridge)) {
                super.drawAgent(g, x, y, Color.yellow, -1);
            }
            g.setColor(Color.black);
            drawString(g, x, y, defaultFont, "Fdg ("+hmodel.availableBeers+")");
            break;
        case MyHouseModel.DELIVERY:
			super.drawAgent(g, x, y, Color.green, -1);
            if (lRobot.equals(hmodel.lDelivery)) {
                super.drawAgent(g, x, y, Color.yellow, -1);
            }
            g.setColor(Color.black);
            drawString(g, x, y, defaultFont, "Del");
            break;
        case MyHouseModel.OWNER:
			super.drawAgent(g, x, y, Color.red, -1);
            if (lRobot.equals(hmodel.lOwner)) {
                super.drawAgent(g, x, y, Color.yellow, -1);
            }
            String o = "Own";
            if (hmodel.sipCount > 0) {
                o +=  " ("+hmodel.sipCount+")";
            }
            g.setColor(Color.black);
            drawString(g, x, y, defaultFont, o);
            break;
        }
        repaint();
    }

    @Override
    public void drawAgent(Graphics g, int x, int y, Color c, int id) {
        Location lRobot = hmodel.getAgPos(0);
        if (!lRobot.equals(hmodel.lOwner) && !lRobot.equals(hmodel.lFridge)) {
            c = Color.yellow;
            if (hmodel.carryingBeer) c = Color.orange;
            super.drawAgent(g, x, y, c, -1);
            g.setColor(Color.black);
            super.drawString(g, x, y, defaultFont, "Rob");
        }
    }
}
