/**
 * Doge.pde
 * Purpose: Provides the Player with Tips while he is playing the game
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Doge {

  PVector position, velocity;

  Boolean facingRight;
  Boolean positionReached;

  int delay=0;

  static final float SPEED = 0.8;
  static final float SLOWDOWN_PERC = 0.9;

  Doge() {
    facingRight = false;
    position = new PVector();
    velocity = new PVector();
    dogeIntro=false;
    positionReached=false;
  }//Doge

  void reset() {
    facingRight=false;
    positionReached=true;
  }//reset

  void dogeRandom() {
    delay++;
    if(delay>900 && int(random(100))<1 && !dogeIntro){
    dogeMessages.textPosition=1;
    dogeRandomText();
    delay=0;
    }
  }

  void move() {

    float speedHere = SPEED;
    float frictionHere = SLOWDOWN_PERC;
    int topEdge = World.GRID_UNITS_TALL*World.GRID_UNIT_SIZE-height;

    if (!dogeIntro) {
      if ((int)position.x==(int)thePlayer.position.x-30) {
        velocity.x = 0;
      } else if (position.x>=thePlayer.position.x) {
        velocity.x -= speedHere;
      } else if (position.x<=thePlayer.position.x-150) {
        velocity.x += speedHere;
      }
      if (position.y<thePlayer.position.y-100 || position.y<0) {
        velocity.y +=speedHere;
      } else if ((int)position.y==(int)thePlayer.position.y-100) {
        velocity.y=0;
      }  else if (position.y>thePlayer.position.y-100) {
        velocity.y -=speedHere;
      }
      velocity.x *= frictionHere;
      velocity.y *=frictionHere;
      position.add(velocity);
    }
  }//move

  /*********************
   ** Figur "zeichnen" **
   *********************/

  void draw() {

    int guyWidth = magical_doge.width;
    int guyHeight = magical_doge.height;

    if (!dogeIntro && positionReached) {
      if (thePlayer.facingRight==false && thePlayer.position.x<position.x) {
        facingRight = false;
      } else {
        facingRight = true;
      }
    }

    pushMatrix();
    translate(position.x, position.y);

    if (facingRight==false) {
      scale(-1, 1);
    }
    translate(-guyWidth/2, -guyHeight);

    image(magical_doge, 0, 0);

    popMatrix();
  }//draw
}//Doge.class