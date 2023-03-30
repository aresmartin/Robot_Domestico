import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.Location;
import java.util.logging.Logger;

public class MyHouseEnv extends Environment {

    // common literals
    public static final Literal of  = Literal.parseLiteral("open(fridge)");
    public static final Literal clf = Literal.parseLiteral("close(fridge)");
    public static final Literal gb  = Literal.parseLiteral("get(beer)");
    public static final Literal hb  = Literal.parseLiteral("hand_in(beer)");
    public static final Literal sb  = Literal.parseLiteral("sip(beer)");
    public static final Literal hob = Literal.parseLiteral("has(myOwner,beer)");

    public static final Literal af = Literal.parseLiteral("at(myRobot,fridge)");
    public static final Literal ao = Literal.parseLiteral("at(myRobot,myOwner)");
    public static final Literal ad = Literal.parseLiteral("at(myRobot,delivery)");
    public static final Literal ab = Literal.parseLiteral("at(myRobot,base)");

    static Logger logger = Logger.getLogger(MyHouseEnv.class.getName());

    MyHouseModel model; // the model of the grid

    @Override
    public void init(String[] args) {
        model = new MyHouseModel();

        if (args.length == 1 && args[0].equals("gui")) {
            MyHouseView view  = new MyHouseView(model);
            model.setView(view);
        }

        updatePercepts();
    }

    /** creates the agents percepts based on the HouseModel */
    void updatePercepts() {
        // clear the percepts of the agents
        clearPercepts("myRobot");
        clearPercepts("myOwner");

        // get the robot location
        Location lRobot = model.getAgPos(0);

        // add agent location to its percepts
        //if (lRobot.equals(model.closeTolFridge)) {
		if (model.atFridge) {
            addPercept("myRobot", af);
        }
        //if (lRobot.equals(model.closeTolOwner)) {
		if (model.atOwner) {
            addPercept("myRobot", ao);
        }

		if (model.atDelivery) {
            addPercept("myRobot", ad);
        }

		if (model.atBase) {
            addPercept("myRobot", ab);
        }

        // add beer "status" the percepts
        if (model.fridgeOpen) {
            addPercept("myRobot", Literal.parseLiteral("stock(beer,"+model.availableBeers+")"));
        }
		
        if (model.sipCount > 0) {
            addPercept("myRobot", hob);
            addPercept("myOwner", hob);
        }
    }


    @Override
    public boolean executeAction(String ag, Structure action) {
        System.out.println("["+ag+"] doing: "+action);
        boolean result = false;
        if (action.equals(of) & ag.equals("myRobot")) { // of = open(fridge)
            result = model.openFridge();

        } else if (action.equals(clf) & ag.equals("myRobot")) { // clf = close(fridge)
            result = model.closeFridge();

        } else if (action.getFunctor().equals("move_towards") & ag.equals("myRobot")) {
            String l = action.getTerm(0).toString();
            Location dest = null;
            if (l.equals("fridge")) {
                dest = model.lFridge;
            } else if (l.equals("myOwner")) {
                dest = model.lOwner;
            } else if (l.equals("delivery")) {
                dest = model.lDelivery;
            } else if (l.equals("base")) {
                dest = model.lRobot;
            }

            try {
                result = model.moveTowards(dest);
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else if (action.equals(gb) & ag.equals("myRobot")) {
            result = model.getBeer();

        } else if (action.equals(hb) & ag.equals("myRobot")) {
            result = model.handInBeer();

        } else if (action.equals(sb) & ag.equals("myOwner")) {
            result = model.sipBeer();

        } else if (action.getFunctor().equals("deliver") & ag.equals("mySupermarket")) {
            // wait 4 seconds to finish "deliver"
            try {
                Thread.sleep(4000);
                result = model.addBeer( (int)((NumberTerm)action.getTerm(1)).solve());
            } catch (Exception e) {
                logger.info("Failed to execute action deliver!"+e);
            }

        } else {
            logger.info("Failed to execute action "+action);
        }

        if (result) {
            updatePercepts();
            try {
                Thread.sleep(100);
            } catch (Exception e) {}
        }
        return result;
    }
}
