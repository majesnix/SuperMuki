/**
 * EvilPig.pde
 * Purpose: Transforms Archer to Pig
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Evilpig extends Archer {

  Evilpig() {
    isOnGround = false;
    facingRight = true;
    alive=false;
    moveLeft=true;
  }//Evilpig

  Evilpig(int x, int y) {
    isOnGround = false;
    facingRight = true;
    alive=true;
    moveLeft=true;
    position.x=x;
    position.y=y;
  }//Evilpig

  void reset() {
    velocity.x = 0;
    velocity.y = 0;
    alive=false;
    moveLeft=true;
  }//reset

  void move() {
    float speedHere = (isOnGround ? RUN_SPEED : AIR_RUN_SPEED);
    float frictionHere = (isOnGround ? SLOWDOWN_PERC : AIR_SLOWDOWN_PERC);

    if (thePlayer.position.x>position.x && thePlayer.position.x-position.x<150) {
      moveLeft=false;
      facingRight=true;
    } else if (position.x - thePlayer.position.x<150 && thePlayer.position.x<position.x) {
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
    int guyWidth = evilpig.width;
    int guyHeight = evilpig.height;
    arrowStart=int(guyWidth*0.3);

    pushMatrix();
    translate(position.x, position.y);
    if (facingRight==true) {
      scale(-1, 1);
    }
    translate(-guyWidth/2, -guyHeight);

    /***********************************************
     **  Animation ändert sich, je nach Situation  **
     ***********************************************/


    if (position.x - thePlayer.position.x<350 && thePlayer.position.x<position.x && !facingRight) {
      image(evilpig, 0, 0);
      if (shootingAllowed || rngShoot) {
        pigshots.add(new Pigshot(position.x-arrowStart, position.y-0.8*guyHeight, false));
        shootingAllowed=false;
        rngShoot=false;
        shootDelay = 0;
      }
      //Player steht rechts vom Pig
    } else if (thePlayer.position.x>position.x && thePlayer.position.x-position.x<350 && facingRight) {
      image(evilpig, 0, 0);
      if (shootingAllowed || rngShoot) {
        pigshots.add(new Pigshot(position.x-arrowStart, position.y-0.8*guyHeight, true));
        shootingAllowed=false;
        rngShoot=false;
        shootDelay = 0;
      }
    } else {
      image(evilpig, 0, 0);
    }
    //3 Sekunden timer
    shootDelay++;
    if (shootDelay >= 180) {
      shootingAllowed=true;
    }
    if (shootDelay==30) {
      if (random(100) < 15) {
        rngShoot=true;
      }
    }
    popMatrix();
  }//draw
}//class.evilpig