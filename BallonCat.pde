/**
 * BallonCat.pde
 * Purpose: Flying Cat with a Ballon, who gives the Player some lifes, when he throws a Fish @ BallonCat
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class BallonCat{


  PVector position, velocity;

  Boolean facingRight;

  static final float AIR_RUN_SPEED = 0.3;
  static final float AIR_SLOWDOWN_PERC = 0.5;

  BallonCat() {
    facingRight = false;
    position = new PVector();
    velocity = new PVector();
  }//BallonCat

  void reset() {
    facingRight=false;
  }//reset

  void checkForFish(){
    for(int i=0; i<fishs.size();i++){
      Fish tmpFish = fishs.get(i);
      if(position.y==tmpFish.position.y-fish.height && position.x-ballon_cat.width/2-5 < tmpFish.position.x && position.x+ballon_cat.width/2+5 > tmpFish.position.x ){
        tmpFish.alive = false;
        lifes++;
      }
    }
  }

  void move() {

    float speedHere = AIR_RUN_SPEED;
    float frictionHere = AIR_SLOWDOWN_PERC;

      if (position.x>0) {
        velocity.x -= speedHere;
      }
      
      velocity.x *= frictionHere;
      
      position.add(velocity);
      checkForFish();
  }//move

  /*********************
   ** Figur "zeichnen" **
   *********************/

  void draw() {

    int guyWidth = ballon_cat.width;
    int guyHeight = ballon_cat.height;

    pushMatrix();
    translate(position.x, position.y);

    if (facingRight==false) {
      scale(-1, 1);
    }
    translate(-guyWidth/2, -guyHeight);

    image(ballon_cat, 0, 0);

    popMatrix();
  }//draw
}//BallonCat.class