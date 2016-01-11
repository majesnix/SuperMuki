class Pigshot {

  PVector position, velocity;

  Boolean facingRight;
  Boolean alive;

  Boolean isOnGround;

  static final float AIR_RUN_SPEED = 1.5;
  static final float AIR_SLOWDOWN_PERC = 0.85;
  static final float TRIVIAL_SPEED = 1.0;
  static final float ARROW_GRAVITY = 0.1;

  Pigshot(float x, float y, boolean b) {
    facingRight = b;
    alive=true;
    isOnGround=false;
    position = new PVector();
    velocity = new PVector();
    position.x = x;
    position.y = y;
    velocity.y = -7;
  }//Pigshot

  void checkForWallBumping() {
    int pigshotWidth = pigshot.width;
    int pigshotHeight = pigshot.height;
    int wallProbeDistance = int(pigshotWidth*0.3);
    int ceilingProbeDistance = int(pigshotHeight*0.95);
    
    int playerHeight;

    if (level==1) {
      playerHeight=int(player1.height*0.95);
    } else if (level==2) {
      playerHeight=int(player2.height*0.95);
    } else if (level==3) {
      playerHeight=int(player3.height*0.95);
    } else if (level==4) {
      playerHeight=int(player4.height*0.95);
    } else {
      playerHeight=int(player1.height*0.95);
    }


    // used as probes to detect running into walls, ceiling
    PVector leftSideHigh, rightSideHigh, leftSideLow, rightSideLow, topSide;
    leftSideHigh = new PVector();
    rightSideHigh = new PVector();
    leftSideLow = new PVector();
    rightSideLow = new PVector();
    topSide = new PVector();

    // update wall probes
    leftSideHigh.x = leftSideLow.x = position.x - wallProbeDistance;
    rightSideHigh.x = rightSideLow.x = position.x + wallProbeDistance;
    leftSideLow.y = rightSideLow.y = position.y-0.3*pigshotHeight;
    leftSideHigh.y = rightSideHigh.y = position.y-0.8*pigshotHeight; 

    topSide.x = position.x;
    topSide.y = position.y-ceilingProbeDistance;
    
    if ( theWorld.worldSquareAt(topSide)==World.TILE_MUNCHER || theWorld.worldSquareAt(leftSideHigh)==World.TILE_MUNCHER ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_MUNCHER || theWorld.worldSquareAt(rightSideHigh)==World.TILE_MUNCHER ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_MUNCHER || theWorld.worldSquareAt(position)==World.TILE_MUNCHER ||
      theWorld.worldSquareAt(topSide)==World.TILE_LAVA || theWorld.worldSquareAt(leftSideHigh)==World.TILE_LAVA ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_LAVA || theWorld.worldSquareAt(rightSideHigh)==World.TILE_LAVA ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_LAVA || theWorld.worldSquareAt(position)==World.TILE_LAVA ||
      theWorld.worldSquareAt(topSide)==World.TILE_KILL || theWorld.worldSquareAt(leftSideHigh)==World.TILE_KILL ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_KILL || theWorld.worldSquareAt(rightSideHigh)==World.TILE_KILL ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_KILL || theWorld.worldSquareAt(position)==World.TILE_KILL ||
      theWorld.worldSquareAt(topSide)==World.TILE_CLOUD || theWorld.worldSquareAt(leftSideHigh)==World.TILE_CLOUD ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_CLOUD || theWorld.worldSquareAt(rightSideHigh)==World.TILE_CLOUD ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_CLOUD || theWorld.worldSquareAt(position)==World.TILE_CLOUD ||
      theWorld.worldSquareAt(topSide)==World.TILE_SOLID || theWorld.worldSquareAt(leftSideHigh)==World.TILE_SOLID ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_SOLID || theWorld.worldSquareAt(rightSideHigh)==World.TILE_SOLID ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_SOLID || theWorld.worldSquareAt(position)==World.TILE_SOLID ||
      theWorld.worldSquareAt(topSide)==World.TILE_SOLID2 || theWorld.worldSquareAt(leftSideHigh)==World.TILE_SOLID2 ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_SOLID2 || theWorld.worldSquareAt(rightSideHigh)==World.TILE_SOLID2 ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_SOLID2 || theWorld.worldSquareAt(position)==World.TILE_SOLID2 ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_LEFT ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_LEFT ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_RIGHT || theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_RIGHT ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_RIGHT || theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_RIGHT ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_RIGHT || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_LTR ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_LTR ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(position)==World.TILE_GRASS_LTR ||
      theWorld.worldSquareAt(topSide)==World.TILE_STONE || theWorld.worldSquareAt(leftSideHigh)==World.TILE_STONE ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_STONE || theWorld.worldSquareAt(rightSideHigh)==World.TILE_STONE ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_STONE || theWorld.worldSquareAt(position)==World.TILE_STONE ||
      theWorld.worldSquareAt(topSide)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(leftSideHigh)==World.TILE_LAVA_TOP ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(rightSideHigh)==World.TILE_LAVA_TOP ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(position)==World.TILE_LAVA_TOP ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_RIGHT_TOP ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_RIGHT_TOP ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT_TOP) {

      alive=false;
      return;
    }

    /*****************************************
     **  Pig berührt Player -> Player kill  **
     ****************************************/
    if (!debug) {
      if ((position.x-pigshotWidth/2)-(thePlayer.position.x+player1.width/2)<=1  && 
        (thePlayer.position.x-player1.width/2)-(position.x+pigshotWidth/2)<=1 &&
        leftSideLow.y<thePlayer.position.y && leftSideLow.y>thePlayer.position.y-(playerHeight*0.95)) {
        thePlayer.velocity.x=0.0;
        thePlayer.calculateLifes();
      }
    }
  }//checkForWallbumping

  void checkForFalling() {
    if (theWorld.worldSquareAt(position)==World.TILE_EMPTY) {
      isOnGround=false;
    }

    if (isOnGround==false) {  
      if (theWorld.worldSquareAt(position)==World.TILE_SOLID ||
        theWorld.worldSquareAt(position)==World.TILE_SOLID2 || theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT || theWorld.worldSquareAt(position)==World.TILE_GRASS_LTR ||
        theWorld.worldSquareAt(position)==World.TILE_STONE || theWorld.worldSquareAt(position)==World.TILE_LAVA_TOP ||
        theWorld.worldSquareAt(position)==World.TILE_CLOUD) {
        isOnGround = true;
        position.y = theWorld.topOfSquare(position);
        velocity.y = 0.0;
      } else { // fall
        float r = random(0,0.95);
        velocity.y += ARROW_GRAVITY+r;
      }
    }
  }//checkForFalling

  void move() {
    float speedHere = AIR_RUN_SPEED;
    float frictionHere = AIR_SLOWDOWN_PERC;

    if (!facingRight && !gameWon()) {
      velocity.x -= speedHere;
    } else if (facingRight && !gameWon()) {
      velocity.x += speedHere;
    }
    velocity.x *= frictionHere;

    position.add(velocity);

    checkForWallBumping();

    checkForFalling();
  }

  void draw() {
    int pigshotWidth = pigshot.width;
    int pigshotHeight = pigshot.height;

    pushMatrix();
    translate(position.x, position.y);

    /*************************
     **  Rotation des Pigs  **
     *************************/
    if (!facingRight) {
      if (velocity.y<0) {
        rotate(radians(10));
      } else if (velocity.y==0) {
        rotate(radians(-10));
      } else if (velocity.y>0 && velocity.y<2) {
        rotate(radians(-20));
      } else if (velocity.y>=2) {
        rotate(radians(-30));
      }
    } else if (facingRight) {
      if (velocity.y<0) {
        rotate(radians(-10));
      } else if (velocity.y==0) {
        rotate(radians(+10));
      } else if (velocity.y>0 && velocity.y<2) {
        rotate(radians(+20));
      } else if (velocity.y>=2) {
        rotate(radians(+30));
      }
    }

    if (facingRight==false) {
      scale(-1, 1);
    }
    translate(-pigshotWidth/2, -pigshotHeight);

    image(pigshot, 0, 0);

    popMatrix();
  }//draw
}//Pigshot.class