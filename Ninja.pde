/**
 * Ninja.pde
 * Purpose: Enemy Main.class, checks Collision detection, Falling and Enemy-Kill / Player-Kill triggers
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Ninja {
  PVector position, velocity;

  Boolean isOnGround;
  Boolean facingRight;
  Boolean moveLeft;
  Boolean alive;

  static final float RUN_SPEED = 1.0;
  static final float AIR_RUN_SPEED = 2.0;
  static final float SLOWDOWN_PERC = 0.6;
  static final float AIR_SLOWDOWN_PERC = 0.85;

  Ninja() {
    isOnGround = false;
    facingRight = false;
    alive=false;
    moveLeft=true;
    position = new PVector();
    velocity = new PVector();
  }//Ninja

  Ninja(int x, int y) {
    isOnGround = false;
    facingRight = false;
    alive=true;
    moveLeft=true;
    position = new PVector();
    velocity = new PVector();
    position.x=x;
    position.y=y;
  }//Ninja

  void reset() {
    velocity.x = 0;
    velocity.y = 0;
    alive=false;
    moveLeft=true;
  }//reset

  /***************************                    
   **  Collision detection  **    
   **************************/

  void checkForWallBumping() {
    int guyWidth = ninja.width;
    int guyHeight = ninja.height;
    int wallProbeDistance = int(guyWidth*0.3);
    int ceilingProbeDistance = int(guyHeight*0.95);


    PVector leftSideLow, rightSideLow, topSide;
    leftSideLow = new PVector();
    rightSideLow = new PVector();
    topSide = new PVector();

    // update wall probes
    leftSideLow.x = position.x - wallProbeDistance;
    rightSideLow.x = position.x + wallProbeDistance;
    leftSideLow.y = rightSideLow.y = position.y-0.3*guyHeight;

    topSide.x = position.x; // center of player
    topSide.y = position.y-ceilingProbeDistance; // top of guy                   

    if ( theWorld.worldSquareAt(topSide)==World.TILE_SOLID || theWorld.worldSquareAt(topSide)==World.TILE_SOLID2 ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(topSide)==World.TILE_GRASS_RIGHT ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(topSide)==World.TILE_GRASS_RIGHT_TOP ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(topSide)==World.TILE_STONE ||
      theWorld.worldSquareAt(topSide)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(topSide)==World.TILE_CLOUD||
      theWorld.worldSquareAt(topSide)==World.TILE_ALGE || theWorld.worldSquareAt(topSide)==World.TILE_ALGE_BOTTOM ||
      theWorld.worldSquareAt(topSide)==World.TILE_MAGIC || theWorld.worldSquareAt(topSide)==World.TILE_BLASE2 ||
      theWorld.worldSquareAt(topSide)==World.TILE_FON1 || theWorld.worldSquareAt(topSide)==World.TILE_FON2) {
      if (theWorld.worldSquareAt(position)==World.TILE_SOLID || theWorld.worldSquareAt(position)==World.TILE_SOLID2 ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT_TOP ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(position)==World.TILE_STONE ||
        theWorld.worldSquareAt(position)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(position)==World.TILE_CLOUD ||
        theWorld.worldSquareAt(position)==World.TILE_ALGE || theWorld.worldSquareAt(position)==World.TILE_ALGE_BOTTOM ||
        theWorld.worldSquareAt(position)==World.TILE_MAGIC || theWorld.worldSquareAt(position)==World.TILE_BLASE2 ||
        theWorld.worldSquareAt(position)==World.TILE_FON1 || theWorld.worldSquareAt(position)==World.TILE_FON2) {
        position.sub(velocity);
        velocity.x=0.0;
        velocity.y=0.0;
      } else {
        position.y = theWorld.bottomOfSquare(topSide)+ceilingProbeDistance;
        if (velocity.y < 0) {
          velocity.y = 0.0;
        }
      }
    }

    /*********************************
     **  Enemy walking on platform  **
     ********************************/

    if ( theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_EMPTY || 
      theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_LAVA ||
      theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_KILL ||
      theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_WATER ||
      theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_WATER2 ||
      theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_MUNCHER ||
      theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.COIN ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_BLASE ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_BLASE2 ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_ALGE ||
      position.x>World.GRID_UNITS_WIDE*World.GRID_UNIT_SIZE-15) {
      position.x = (theWorld.leftOfSquare(rightSideLow)-wallProbeDistance);
      if (velocity.x > 0) {
        velocity.x = 0.0;
        moveLeft=true;
        facingRight=false;
      }
    }

    if ( theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_EMPTY || 
      theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_LAVA ||
      theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_KILL ||
      theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_WATER ||
      theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_WATER2 ||
      theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_MUNCHER ||
      theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.COIN ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_BLASE ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_BLASE2 ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_ALGE ||
      position.x<1) {
      position.x = (theWorld.rightOfSquare(leftSideLow)+wallProbeDistance);
      if (velocity.x < 0) {
        velocity.x = 0.0;
        moveLeft=false;
        facingRight=true;
      }
    }

    /******************************************
     **  Kill Enemy when jumping on his head **
     *****************************************/

    if ((position.x-guyWidth/2-2)-(thePlayer.position.x+player1.width/2)<=1  && 
      (thePlayer.position.x-player1.width/2)-(position.x+guyWidth/2-2)<=1 &&
      position.y-guyHeight<=thePlayer.position.y && position.y>=thePlayer.position.y && thePlayer.velocity.y>0) {
      alive=false;
      thePlayer.isOnGround=true;
      thePlayer.velocity.y=-2.0;
    }


    /**********************
     **  Player killable **
     *********************/

    if (!debug) {
      if ((position.x-guyWidth/2)-(thePlayer.position.x+player1.width/2)<=1  && 
        (thePlayer.position.x-player1.width/2)-(position.x+guyWidth/2)<=1 &&
        position.y-guyHeight*0.49<thePlayer.position.y && position.y>=thePlayer.position.y && thePlayer.velocity.y==0) {
        thePlayer.calculateLifes();
      }
    }
  }//checkForWallbumping

  /*
  *  On Ground ?
   */

  void checkForFalling() {
    if (theWorld.worldSquareAt(position)==World.TILE_EMPTY) {
      isOnGround=false;
    }

    if (isOnGround==false) {  
      if (theWorld.worldSquareAt(position)==World.TILE_SOLID || theWorld.worldSquareAt(position)==World.TILE_SOLID2 ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT_TOP ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT_TOP || theWorld.worldSquareAt(position)==World.TILE_STONE ||
        theWorld.worldSquareAt(position)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(position)==World.TILE_CLOUD  ||
        theWorld.worldSquareAt(position)==World.TILE_ALGE || theWorld.worldSquareAt(position)==World.TILE_ALGE_BOTTOM ||
        theWorld.worldSquareAt(position)==World.TILE_MAGIC || theWorld.worldSquareAt(position)==World.TILE_BLASE2 ||
        theWorld.worldSquareAt(position)==World.TILE_FON1 || theWorld.worldSquareAt(position)==World.TILE_FON2) {
        isOnGround = true;
        position.y = theWorld.topOfSquare(position);
        velocity.y = 0.0;
      } else { // fall
        velocity.y += GRAVITY_POWER;
      }
    }
  }//checkForFalling

  /********************************
   **  Enemy moving permanently  **
   *******************************/

  void move() {
    float speedHere = (isOnGround ? RUN_SPEED : AIR_RUN_SPEED);
    float frictionHere = (isOnGround ? SLOWDOWN_PERC : AIR_SLOWDOWN_PERC);

    if (thePlayer.position.x>position.x && thePlayer.position.x-position.x<80) {
      speedHere*=3;
      moveLeft=false;
      facingRight=true;
    } else if (position.x - thePlayer.position.x<80 && thePlayer.position.x<position.x) {
      speedHere*=3;
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
    int guyWidth = ninja.width;
    int guyHeight = ninja.height;

    pushMatrix();
    translate(position.x, position.y);
    if (facingRight==false) {
      scale(-1, 1);
    }
    translate(-guyWidth/2, -guyHeight);

    /* 
     *  Enemy picture
     */

    if (position.x - thePlayer.position.x<120 && thePlayer.position.x<position.x && !facingRight || thePlayer.position.x>position.x && thePlayer.position.x-position.x<120 && facingRight) {
      image(ninja_attack, 0, 0);
    } else {
      image(ninja, 0, 0);
    }

    popMatrix();
  }//draw
}//Ninja.class