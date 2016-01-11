class Fireball {

  PVector position, velocity, dir, acceleration;

  Boolean facingRight;
  Boolean alive;

  Boolean isOnGround;

  Fireball(float x, float y, boolean b) {
    facingRight = b;
    alive=true;
    isOnGround=false;
    position = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
    position.x = x;
    position.y = y;
    dir = PVector.sub(thePlayer.position,position);
    dir.normalize();
    dir.mult(0.4);
    acceleration = dir;
  }//Fireball

  void checkForWallBumping() {
    int fireballWidth = fireball.width;
    int fireballHeight = fireball.height;
    int wallProbeDistance = int(fireballWidth*0.3);
    int ceilingProbeDistance = int(fireballHeight*0.95);
    
    //Damit Spieler und NPCs getroffen werden können
    int ninjaHeight=int(ninja.height*0.95);
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
    leftSideLow.y = rightSideLow.y = position.y-0.3*fireballHeight;
    leftSideHigh.y = rightSideHigh.y = position.y-0.8*fireballHeight; 

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
      theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_RIGHT_TOP || theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_RIGHT_TOP ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_RIGHT_TOP || theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_RIGHT_TOP ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_RIGHT_TOP || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT_TOP ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_LEFT_TOP ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_LEFT_TOP ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT_TOP) {

      alive=false;
      return;
    }

    if (!debug) {
      if ((position.x-fireballWidth/2)-(thePlayer.position.x+player1.width/2)<=1  && 
        (thePlayer.position.x-player1.width/2)-(position.x+fireballWidth/2)<=1 &&
        leftSideLow.y<thePlayer.position.y && leftSideLow.y>thePlayer.position.y-(playerHeight*0.95)) {
        thePlayer.velocity.x=0.0;
        thePlayer.calculateLifes();
      }
    }
    for (int i=0; i < ninjas.size(); i++) {
      Ninja ninja = ninjas.get(i);

      if ((position.x-fireballWidth/2)-(ninja.position.x+player1.width/2)<=1  && 
        (ninja.position.x-player1.width/2)-(position.x+fireballWidth/2)<=1 &&
        leftSideLow.y<ninja.position.y && leftSideLow.y>ninja.position.y-(ninjaHeight*0.95)) {
        ninja.velocity.x=0.0;
        ninja.alive=false;
      }
    }
  }//checkForWallbumping

  void move() {
    
    velocity.add(acceleration);
    velocity.limit(10);
    position.add(velocity);

    checkForWallBumping();

  }

  void draw() {
    int fireballWidth = fireball.width;
    int fireballHeight = fireball.height;

    pushMatrix();
    translate(position.x, position.y);
    
    if (facingRight==true) {
      scale(-1, 1);
    }
    translate(-fireballWidth/2, -fireballHeight);

    image(fireball, 0, 0);

    popMatrix();
  }//draw
}//Fireball.class