/**
 * Archer.pde
 * Purpose: Transforms Ninja to Archer, Archers can shoot Arrows
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Archer extends Ninja {

  Boolean shootingAllowed=true;
  Boolean rngShoot=false;

  int shootDelay=0;

  int timer, wait;
  int arrowStart;

  Archer() {
    isOnGround = false;
    facingRight = false;
    alive=false;
    moveLeft=true;
  }//Archer

  Archer(int x, int y) {
    isOnGround = false;
    facingRight = false;
    alive=true;
    moveLeft=true;
    position.x=x;
    position.y=y;
  }//Archer
  
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
    int guyWidth = archer.width;
    int guyHeight = archer.height;
    arrowStart=int(guyWidth*0.3);

    pushMatrix();
    translate(position.x, position.y);
    if (facingRight==false) {
      scale(-1, 1);
    }
    translate(-guyWidth/2, -guyHeight);

    if (position.x - thePlayer.position.x<100 && thePlayer.position.x<position.x && !facingRight || thePlayer.position.x>position.x && thePlayer.position.x-position.x<100 && facingRight) {
      image(archer_attack2, 0, 0);
    }
    //Player left of the Archer
    else if (position.x - thePlayer.position.x<350 && thePlayer.position.x<position.x && !facingRight || thePlayer.position.x>position.x && thePlayer.position.x-position.x<350 && facingRight) {
      image(archer_attack, 0, 0);
      if (shootingAllowed || rngShoot) {
        arrows.add(new Arrow(position.x-arrowStart, position.y-0.8*guyHeight, false));
        shootingAllowed=false;
        rngShoot=false;
        shootDelay = 0;
      }
      //Player right of the Archer
    } else {
      image(archer, 0, 0);
    }
    //3 Sec timer
    shootDelay++;
    if (shootDelay >= 90) {
      shootingAllowed=true;
    }
    //15% chance for a RNG Shot
    if (shootDelay==30) {
      if (random(100) < 15) {
        rngShoot=true;
      }
    }
    popMatrix();
  }//draw
}//Archer.class