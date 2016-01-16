class Bee extends Ninja {

  static final float AIR_RUN_SPEED = 1.0;
  static final float AIR_SLOWDOWN_PERC = 0.75;
  static final float TRIVIAL_SPEED = 1.0;

  Bee() {
    isOnGround = false;
    facingRight = true;
    alive=false;
    moveLeft=true;
  }//Bee
  
  Bee(int x, int y) {
    isOnGround = false;
    facingRight = true;
    alive=true;
    moveLeft=true;
    position.x=x;
    position.y=y;
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
    } else if (position.x - thePlayer.position.x<80 && thePlayer.position.x<position.x && thePlayer.position.y==position.y) {
      speedHere*=2;
      moveLeft=true;
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

    if (velocity.x<-TRIVIAL_SPEED) {
      facingRight = false;
    } else if (velocity.x>TRIVIAL_SPEED) {
      facingRight = true;
    }

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