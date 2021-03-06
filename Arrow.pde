/**
 * Arrow.pde
 * Purpose: Arrow trajectory, rotation while flying and collision detection
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Arrow {

  PVector position, velocity;

  Boolean facingRight;
  Boolean alive;

  Boolean isOnGround;

  static final float AIR_RUN_SPEED = 1.5;
  static final float AIR_SLOWDOWN_PERC = 0.85;
  static final float ARROW_GRAVITY = 0.1;

  Arrow(){
    alive=true;
    isOnGround=false;
    position = new PVector();
    velocity = new PVector();
  }

  Arrow(float positionX, float positionY, boolean b) {
    facingRight = b;
    alive=true;
    isOnGround=false;
    position = new PVector();
    velocity = new PVector();
    position.x = positionX;
    position.y = positionY;
    velocity.y = -7;
  }//Arrow

  void checkForWallBumping() {
    int arrowWidth = arrow.width;
    int arrowHeight = arrow.height;
    int wallProbeDistance = int(arrowWidth*0.3);
    int ceilingProbeDistance = int(arrowHeight*0.95);
    
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
    leftSideLow.y = rightSideLow.y = position.y-0.3*arrowHeight;
    leftSideHigh.y = rightSideHigh.y = position.y-0.8*arrowHeight; 

    topSide.x = position.x;
    topSide.y = position.y-ceilingProbeDistance;

    if (theWorld.worldSquareAt(topSide)!=World.TILE_EMPTY || theWorld.worldSquareAt(leftSideHigh)!=World.TILE_EMPTY ||
      theWorld.worldSquareAt(leftSideLow)!=World.TILE_EMPTY || theWorld.worldSquareAt(rightSideHigh)!=World.TILE_EMPTY ||
      theWorld.worldSquareAt(rightSideLow)!=World.TILE_EMPTY || theWorld.worldSquareAt(position)!=World.TILE_EMPTY) {

      alive=false;
      return;
    }

    /*******************************************
     **  Arrow berührt Player -> Player kill  **
     *******************************************/
    if (!debug) {
      if ((position.x-arrowWidth/2)-(thePlayer.position.x+player1.width/2)<=1  && 
        (thePlayer.position.x-player1.width/2)-(position.x+arrowWidth/2)<=1 &&
        leftSideLow.y<thePlayer.position.y && leftSideLow.y>thePlayer.position.y-(playerHeight*0.95)) {
        thePlayer.velocity.x=0.0;
        thePlayer.calculateLifes();
      }
    }
    for (int i=0; i < ninjas.size(); i++) {
      Ninja ninja = ninjas.get(i);

      if ((position.x-arrowWidth/2)-(ninja.position.x+player1.width/2)<=1  && 
        (ninja.position.x-player1.width/2)-(position.x+arrowWidth/2)<=1 &&
        leftSideLow.y<ninja.position.y && leftSideLow.y>ninja.position.y-(ninjaHeight*0.95)) {
        ninja.velocity.x=0.0;
        ninja.alive=false;
      }
    }
    for (int i=0; i < archers.size(); i++) {
      Archer archer = archers.get(i);

      if ((position.x-arrowWidth/2)-(archer.position.x+player1.width/2)<=1  && 
        (archer.position.x-player1.width/2)-(position.x+arrowWidth/2)<=1 &&
        leftSideLow.y<archer.position.y && leftSideLow.y>archer.position.y-(ninjaHeight*0.95)) {
        archer.velocity.x=0.0;
        archer.alive=false;
      }
    }
  }//checkForWallbumping

  void checkForFalling() {
    if (theWorld.worldSquareAt(position)==World.TILE_EMPTY) {
      isOnGround=false;
    }
        float r = random(0,0.95);
        velocity.y += ARROW_GRAVITY+r;
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
    int arrowWidth = arrow.width;
    int arrowHeight = arrow.height;

    pushMatrix();
    translate(position.x, position.y);

    /**************************
     **  Rotation des Arrows  **
     **************************/
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
    translate(-arrowWidth/2, -arrowHeight);

    image(arrow, 0, 0);

    popMatrix();
  }//draw
}//Bullet.class