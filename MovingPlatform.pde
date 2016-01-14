class MovingPlatform {
  PVector position, velocity;

  Boolean moveLeft;

  String tile;

  static final float RUN_SPEED = 1.0;
  static final float SLOWDOWN_PERC = 0.6;
  static final float TRIVIAL_SPEED = 1.0;

  MovingPlatform() {
    moveLeft=true;
    position = new PVector();
    velocity = new PVector();
  }//Moving_Platform
  
  MovingPlatform(int x, int y) {
    moveLeft=true;
    position = new PVector();
    velocity = new PVector();
    position.x=x;
    position.y=y;
    tile = "TILE_CLOUD";
  }//Moving_Platform

  MovingPlatform(int x, int y, String s) {
    moveLeft=true;
    position = new PVector();
    velocity = new PVector();
    position.x=x;
    position.y=y;
    tile = s;
  }//Moving_Platform

  void reset() {
    velocity.x = 0;
    velocity.y = 0;
    moveLeft=true;
    tile = "";
  }//Reset

  /********************************
   **  Plattform Kollision check  **
   ********************************/

  void checkForWallBumping() {

    int guyWidth;
    int guyHeight;

    if (tile=="TILE_CLOUD") {
      guyWidth = wolke.width;
      guyHeight = wolke.height;
    } else if (tile=="TILE_SOLID") {
      guyWidth = grass_top.width;
      guyHeight = grass_top.height;
    } else if (tile=="TILE_STONE") {
      guyWidth = stone.width;
      guyHeight = stone.height;
    } else {
      guyWidth = wolke.width;
      guyHeight = wolke.height;
    }
    int wallProbeDistance = int(guyWidth*0.3);
    int ceilingProbeDistance = int(guyHeight*0.95);
    Boolean shiftUp = false;


    PVector leftSideHigh, rightSideHigh, leftSideLow, rightSideLow, topSide;
    leftSideHigh = new PVector();
    rightSideHigh = new PVector();
    leftSideLow = new PVector();
    rightSideLow = new PVector();
    topSide = new PVector();

    // update wall probes
    leftSideHigh.x = leftSideLow.x = position.x - wallProbeDistance;
    rightSideHigh.x = rightSideLow.x = position.x + wallProbeDistance;
    leftSideLow.y = rightSideLow.y = position.y-0.3*guyHeight;
    leftSideHigh.y = rightSideHigh.y = position.y-0.5*guyHeight;

    topSide.x = position.x;
    topSide.y = position.y-ceilingProbeDistance;                    

    if (theWorld.worldSquareAt(rightSideHigh)==World.TILE_CLOUD || theWorld.worldSquareAt(rightSideLow)==World.TILE_CLOUD ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_SOLID || theWorld.worldSquareAt(rightSideLow)==World.TILE_SOLID ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_SOLID2 || theWorld.worldSquareAt(rightSideLow)==World.TILE_SOLID2 ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_LEFT_TOP ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_RIGHT_TOP || theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_RIGHT_TOP ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_LTR ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_STONE || theWorld.worldSquareAt(rightSideLow)==World.TILE_STONE ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_LAVA || theWorld.worldSquareAt(rightSideLow)==World.TILE_LAVA ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(rightSideLow)==World.TILE_LAVA_TOP ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_ALGE || theWorld.worldSquareAt(rightSideLow)==World.TILE_ALGE ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_BLASE || theWorld.worldSquareAt(rightSideLow)==World.TILE_BLASE ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_LEFT ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_RIGHT || theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_RIGHT ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_WATER || theWorld.worldSquareAt(rightSideLow)==World.TILE_WATER ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_BLOCK || theWorld.worldSquareAt(rightSideLow)==World.TILE_BLOCK ||
        theWorld.worldSquareAt(rightSideHigh)==World.TILE_MAGIC || theWorld.worldSquareAt(rightSideLow)==World.TILE_MAGIC) {
      //position.x = (theWorld.leftOfSquare(rightSideLow)-wallProbeDistance);
      //if (velocity.x > 0) {
        //velocity.x = 0.0;
        moveLeft=true;
      //}
    }

    if (theWorld.worldSquareAt(leftSideHigh)==World.TILE_CLOUD || theWorld.worldSquareAt(leftSideLow)==World.TILE_CLOUD ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_SOLID || theWorld.worldSquareAt(leftSideLow)==World.TILE_SOLID ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_SOLID2 || theWorld.worldSquareAt(leftSideLow)==World.TILE_SOLID2 ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_LEFT_TOP ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_RIGHT_TOP || theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_RIGHT_TOP ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_LTR ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_STONE || theWorld.worldSquareAt(leftSideLow)==World.TILE_STONE ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_LAVA || theWorld.worldSquareAt(leftSideLow)==World.TILE_LAVA ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(leftSideLow)==World.TILE_LAVA_TOP ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_ALGE || theWorld.worldSquareAt(leftSideLow)==World.TILE_ALGE ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_BLASE || theWorld.worldSquareAt(leftSideLow)==World.TILE_BLASE ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_LEFT ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_RIGHT || theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_RIGHT ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_WATER || theWorld.worldSquareAt(leftSideLow)==World.TILE_WATER ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_BLOCK || theWorld.worldSquareAt(leftSideLow)==World.TILE_BLOCK ||
        theWorld.worldSquareAt(leftSideHigh)==World.TILE_MAGIC || theWorld.worldSquareAt(leftSideLow)==World.TILE_MAGIC) {
      //position.x = (theWorld.rightOfSquare(leftSideLow)+wallProbeDistance);
      //if (velocity.x < 0) {
       // velocity.x = 0.0;
        moveLeft=false;
      //}
    }

    if ((position.x-guyWidth/2)-thePlayer.position.x<=5  && 
      thePlayer.position.x-(position.x+guyWidth/2)<=5 &&
      position.y-guyHeight<=thePlayer.position.y && position.y>=thePlayer.position.y) {
      thePlayer.position.add(velocity);
      thePlayer.isOnPlatform=true;
      thePlayer.velocity.y=0.0;
      if (!shiftUp) {
        thePlayer.position.y=position.y-guyHeight;
        shiftUp=true;
      } else {
        shiftUp=false;
      }
    } else {
      thePlayer.isOnPlatform=false;
    }
  }//checkForWallbumping

  /************************
   **  Plattform bewegen  **
   ************************/

  void move() {
    float speedHere = RUN_SPEED;
    float frictionHere = SLOWDOWN_PERC;

    if (moveLeft && !gameWon()) {
      velocity.x -= speedHere;
    } else if (!moveLeft && !gameWon()) {
      velocity.x += speedHere;
    }
    velocity.x *= frictionHere;

    position.add(velocity);

    checkForWallBumping();
  }//move

  void draw() {

    int guyWidth, guyHeight;

    switch(tile) {
    case "TILE_CLOUD":
      guyWidth = wolke.width;
      guyHeight = wolke.height;
      break;
    case "TILE_STONE":
      guyWidth = stone.width;
      guyHeight = stone.height;
      break;
    case "TILE_SOLID":
      guyWidth = grass_top.width;
      guyHeight = grass_top.height;
      break;
    case "TILE_BLASE3":
      guyWidth = blase3.width;
      guyHeight = blase3.height;
    default:
      guyWidth = wolke.width;
      guyHeight = wolke.height;
      break;
    }

    pushMatrix();
    translate(position.x, position.y);
    translate(-guyWidth/2, -guyHeight);

    if (tile=="TILE_CLOUD") {
      image(wolke, 0, 0);
    } else if (tile=="TILE_SOLID") {
      image(grass_top, 0, 0);
    } else if (tile=="TILE_STONE") {
      image(stone, 0, 0);
    } else if (tile=="TILE_BLASE3") {
      image(blase3, 0, 0);
    }  
    popMatrix();
  }//draw
}//Moving_Platform.class