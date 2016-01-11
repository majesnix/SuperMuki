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
  static final float TRIVIAL_SPEED = 1.0;

  Ninja() {
    isOnGround = false;
    facingRight = true;
    alive=false;
    moveLeft=true;
    position = new PVector();
    velocity = new PVector();
  }//Enemy

  Ninja(int x, int y) {
    isOnGround = false;
    facingRight = true;
    alive=true;
    moveLeft=true;
    position = new PVector();
    velocity = new PVector();
    position.x=x;
    position.y=y;
  }//Enemy

  void reset() {
    velocity.x = 0;
    velocity.y = 0;
    alive=false;
    moveLeft=true;
  }//eReset

  /************************                    
   **  Prüft Collisionen  **    
   ************************/

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
      theWorld.worldSquareAt(topSide)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(topSide)==World.TILE_CLOUD
       || theWorld.worldSquareAt(topSide)==World.TILE_ALGE) {
      if (theWorld.worldSquareAt(position)==World.TILE_SOLID || theWorld.worldSquareAt(position)==World.TILE_SOLID2 ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT_TOP ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(position)==World.TILE_STONE ||
        theWorld.worldSquareAt(position)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(position)==World.TILE_CLOUD
         || theWorld.worldSquareAt(position)==World.TILE_ALGE) {
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

    /**************************************
     **  Hält Gegner auf den Plattformen  **
     **************************************/

    if ( theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_EMPTY || 
      theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_LAVA ||
      theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_KILL ||
      theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_WATER ||
      theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_MUNCHER) {
      position.x = (theWorld.leftOfSquare(rightSideLow)-wallProbeDistance);
      if (velocity.x > 0) {
        velocity.x = 0.0;
        moveLeft=true;
      }
    }

    if ( theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_EMPTY || 
      theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_LAVA ||
      theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_KILL ||
      theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_WATER ||
      theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_MUNCHER) {
      position.x = (theWorld.rightOfSquare(leftSideLow)+wallProbeDistance);
      if (velocity.x < 0) {
        velocity.x = 0.0;
        moveLeft=false;
      }
    }

    /****************************
     **  Wenn wahr, Kill Enemy  **
     ****************************/

    if ((position.x-guyWidth/2-2)-(thePlayer.position.x+player1.width/2)<=1  && 
      (thePlayer.position.x-player1.width/2)-(position.x+guyWidth/2-2)<=1 &&
      position.y-guyHeight<=thePlayer.position.y && position.y>=thePlayer.position.y && thePlayer.velocity.y>0) {
      alive=false;
      thePlayer.isOnGround=true;
      thePlayer.velocity.y=-2.0;
    }


    /*******************************************
     **  Gegner berührt Player -> Player kill  **
     *******************************************/
    if (!debug) {
      if ((position.x-guyWidth/2)-(thePlayer.position.x+player1.width/2)<=1  && 
        (thePlayer.position.x-player1.width/2)-(position.x+guyWidth/2)<=1 &&
        position.y-guyHeight*0.49<thePlayer.position.y && position.y>=thePlayer.position.y && thePlayer.velocity.y==0) {
        thePlayer.calculateLifes();
      }
    }
  }//checkForWallbumping

  /*
  *  Boden unter den Füßen?
   */
  void checkForFalling() {
    if (theWorld.worldSquareAt(position)==World.TILE_EMPTY) {
      isOnGround=false;
    }

    if (isOnGround==false) {  
      if (theWorld.worldSquareAt(position)==World.TILE_SOLID ||
        theWorld.worldSquareAt(position)==World.TILE_SOLID2 || theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT || theWorld.worldSquareAt(position)==World.TILE_GRASS_LTR ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT_TOP ||
        theWorld.worldSquareAt(position)==World.TILE_STONE || theWorld.worldSquareAt(position)==World.TILE_LAVA_TOP ||
        theWorld.worldSquareAt(position)==World.TILE_CLOUD  || theWorld.worldSquareAt(position)==World.TILE_ALGE) {
        isOnGround = true;
        position.y = theWorld.topOfSquare(position);
        velocity.y = 0.0;
      } else { // fall
        velocity.y += GRAVITY_POWER;
      }
    }
  }//checkForFalling

  /*******************************************
   **  Permanentes patrollieren des Gegners  **
   *******************************************/

  void move() {
    float speedHere = (isOnGround ? RUN_SPEED : AIR_RUN_SPEED);
    float frictionHere = (isOnGround ? SLOWDOWN_PERC : AIR_SLOWDOWN_PERC);

    if (thePlayer.position.x>position.x && thePlayer.position.x-position.x<80) {
      speedHere*=3;
      moveLeft=false;
    } else if (position.x - thePlayer.position.x<80 && thePlayer.position.x<position.x) {
      speedHere*=3;
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
    int guyWidth = ninja.width;
    int guyHeight = ninja.height;

    if (velocity.x<-TRIVIAL_SPEED) {
      facingRight = false;
    } else if (velocity.x>TRIVIAL_SPEED) {
      facingRight = true;
    }

    pushMatrix();
    translate(position.x, position.y);
    if (facingRight==false) {
      scale(-1, 1);
    }
    translate(-guyWidth/2, -guyHeight);

    /* 
     *  Bild des "Gegners"
     */

    if (position.x - thePlayer.position.x<120 && thePlayer.position.x<position.x && !facingRight || thePlayer.position.x>position.x && thePlayer.position.x-position.x<120 && facingRight) {
      image(ninja_attack, 0, 0);
    } else {
      image(ninja, 0, 0);
    }

    popMatrix();
  }//draw
}//Enemy.class