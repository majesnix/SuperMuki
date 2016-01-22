/**
 * Fireface.pde
 * Purpose: Stationary Enemy, shoots Fireballs @ Player direction
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Fireface {
  PVector position, velocity;

  Boolean isOnGround;
  Boolean moveLeft;
  Boolean alive;
  Boolean shootingAllowed;

  int shootDelay;
  
  static final float RUN_SPEED = 1.0;
  static final float AIR_RUN_SPEED = 2.0;
  static final float SLOWDOWN_PERC = 0.6;
  static final float AIR_SLOWDOWN_PERC = 0.85;
  static final float TRIVIAL_SPEED = 1.0;

  int timer, wait;
  int arrowStart;

  Fireface() {
    isOnGround = false;
    alive=false;
    moveLeft=true;
    position = new PVector();
    velocity = new PVector();
    shootingAllowed=true;
    shootDelay=0;
  }//Fireface

  Fireface(int positionX, int positionY) {
    isOnGround = false;
    alive=true;
    moveLeft=true;
    position = new PVector();
    velocity = new PVector();
    position.x=positionX;
    position.y=positionY;
    shootingAllowed=true;
    shootDelay=0;
  }//Enemy

  void reset() {
    velocity.x = 0;
    velocity.y = 0;
    alive=false;
    moveLeft=true;
  }//reset

  void draw() {
    int guyWidth = fireface.width;
    int guyHeight = fireface.height;

    pushMatrix();
    translate(position.x, position.y);
    translate(-guyWidth/2, -guyHeight);

    /***********************************************
     **  Animation ändert sich, je nach Situation  **
     ***********************************************/

    if (position.x - thePlayer.position.x<350 && thePlayer.position.x<position.x) {
      image(fireface_left, 0, 0);
      if (shootingAllowed) {
        fireballs.add(new Fireball(position.x, position.y+15, false));
        shootingAllowed=false;
        shootDelay = 0;
      }
    } else if (thePlayer.position.x>position.x && thePlayer.position.x-position.x<350) {
      image(fireface_right, 0, 0);
      if (shootingAllowed) {
        fireballs.add(new Fireball(position.x, position.y+15, true));
        shootingAllowed=false;
        shootDelay = 0;
      }
    } else {
      image(fireface, 0, 0);
    }
    //3 Sekunden timer
    shootDelay++;
    if (shootDelay >= 90) {
      shootingAllowed=true;
    }
    popMatrix();
  }//draw
}//fireface.class