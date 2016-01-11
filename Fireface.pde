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

  Fireface(int x, int y) {
    isOnGround = false;
    alive=true;
    moveLeft=true;
    position = new PVector();
    velocity = new PVector();
    position.x=x;
    position.y=y;
    shootingAllowed=true;
    shootDelay=0;
  }//Enemy

  void reset() {
    velocity.x = 0;
    velocity.y = 0;
    alive=false;
    moveLeft=true;
  }//reset

  /************************                    
   **  Prüft Collisionen  **    
   ************************/

  void checkForWallBumping() {
    int guyWidth = fireface.width;
    int guyHeight = fireface.height;
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
      theWorld.worldSquareAt(topSide)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(topSide)==World.TILE_CLOUD) {
      if (theWorld.worldSquareAt(position)==World.TILE_SOLID || theWorld.worldSquareAt(position)==World.TILE_SOLID2 ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT_TOP ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(position)==World.TILE_STONE ||
        theWorld.worldSquareAt(position)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(position)==World.TILE_CLOUD) {
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

    /*if ( theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_EMPTY || 
     theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_LAVA ||
     theWorld.worldSquareAtPlusOneSquare(rightSideLow)==World.TILE_MUNCHER) {
     position.x = (theWorld.leftOfSquare(rightSideLow)-wallProbeDistance);
     if (velocity.x > 0) {
     velocity.x = 0.0;
     moveLeft=true;
     }
     }
     
     if ( theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_EMPTY || 
     theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_LAVA ||
     theWorld.worldSquareAtPlusOneSquare(leftSideLow)==World.TILE_MUNCHER) {
     position.x = (theWorld.rightOfSquare(leftSideLow)+wallProbeDistance);
     if (velocity.x < 0) {
     velocity.x = 0.0;
     moveLeft=false;
     }
     }*/
  }

  /*******************************************
   **  Permanentes patrollieren des Gegners  **
   *******************************************/

  void move() {
    float speedHere = (isOnGround ? RUN_SPEED : AIR_RUN_SPEED);
    float frictionHere = (isOnGround ? SLOWDOWN_PERC : AIR_SLOWDOWN_PERC);

    if (thePlayer.position.x>position.x && thePlayer.position.x-position.x<150) {
      moveLeft=false;
    } else if (position.x - thePlayer.position.x<150 && thePlayer.position.x<position.x) {
      moveLeft=true;
    }

    if (moveLeft && !gameWon()) {
      velocity.x -= speedHere;
    } else if (!moveLeft && !gameWon()) {
      velocity.x += speedHere;
    }
    velocity.x *= frictionHere;

    position.add(velocity);
  }//move

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