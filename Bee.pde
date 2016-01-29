/**
 * Bee.pde
 * Purpose: "transforms" Ninja "into" Bee
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Bee extends Ninja {

  static final float AIR_RUN_SPEED = 1.0;
  static final float AIR_SLOWDOWN_PERC = 0.75;

  Bee() {
    this(0,0);
  }//Bee
  
  Bee(int positionX, int positionY) {
    isOnGround = false;
    facingRight = false;
    alive=true;
    moveLeft=true;
    position.x=positionX;
    position.y=positionY;
  }//Bee

  /*******************************************
   **  Permanentes patrollieren des Gegners  **
   *******************************************/

  void move() {
    float speedHere = AIR_RUN_SPEED;
    float frictionHere = AIR_SLOWDOWN_PERC;

    if (thePlayer.position.x>position.x && thePlayer.position.x-position.x<80 &&  thePlayer.position.y==position.y) {
      speedHere*=2;
      moveLeft=false;
      facingRight=true;
    } else if (position.x - thePlayer.position.x<80 && thePlayer.position.x<position.x && thePlayer.position.y==position.y) {
      speedHere*=2;
      moveLeft=true;
      facingRight=false;
    }

    if (moveLeft && !gameWon()) {
      velocity.x -= speedHere;
    } else if (!moveLeft && !gameWon()) {
      velocity.x += speedHere;
    }
    velocity.x *= frictionHere;

    position.add(velocity);

    checkForWallBumping();
    checkForFalling();
  }//move

  void draw() {
    int guyWidth = bee.width;
    int guyHeight = bee.height;

    pushMatrix();
    translate(position.x, position.y);
    if (facingRight==true) {
      scale(-1, 1);
    }
    translate(-guyWidth/2, -guyHeight);

    /* 
     *  Bild des "Gegners"
     */

      image(bee, 0, 0);

    popMatrix();
  }//draw
}//Bee.class