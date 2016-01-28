/**************************************************************************************
 **  Basecode: http://www.hobbygamedev.com/int/platformer-game-source-in-processing/  **
 **************************************************************************************/

class Player {
  PVector position, velocity, tilePosition;
  
  Boolean isOnGround; // used to keep track of whether the player is on the ground. useful for control and animation.
  Boolean facingRight; // used to keep track of which direction the player last moved in. used to flip player image.
  Boolean checkpointTriggered; // keeps track of whether the player reached the checkpoint or not.
  Boolean isOnPlatform; // keeps track of wheter the player is on a MovingPlatorm or not.
  Boolean boom; // checks wheter the Players stands on a bubble
  int animDelay; // countdown timer between animation updates
  int animFrame; // keeps track of which animation frame is currently shown for the player
  int coinsCollected, itemsCollected, rubysCollected, fishsCollected; // a counter to keep a tally on how many coins the player has collected
  int coinsRemembered, itemsRemembered, rubysRemembered; // rememberes the collected Coins / Rubys / items and loads them after checkpoint / game loaded
  int dogeIntroCount; // starts the Doge intro and deactivates the movement block
  int timer; // timer for boom

  static final float JUMP_POWER = 10.0; // how hard the player jolts upward on jump
  static final float RUN_SPEED = 5.0; // force of player movement on ground, in pixels/cycle
  static final float AIR_RUN_SPEED = 2.0; // like run speed, but used for control while in the air
  static final float SLOWDOWN_PERC = 0.6; // friction from the ground. multiplied by the x speed each frame.
  static final float AIR_SLOWDOWN_PERC = 0.85; // resistance in the air, otherwise air control enables crazy speeds
  static final int RUN_ANIMATION_DELAY = 3; // how many game cycles pass between animation updates?
  static final float TRIVIAL_SPEED = 1.0; // if under this speed, the player is drawn as standing still

  Player() { // constructor, gets called automatically when the Player instance is created
    isOnGround = false;
    isOnPlatform = false;
    facingRight = true;
    position = new PVector();
    velocity = new PVector();
    checkpointTriggered=false;
    boom=false;
  }//Player

  void reset() {
    facingRight=true;
    if (!checkpointTriggered) {
      coinsCollected = 0;
      itemsCollected = 0;
      coinsRemembered = 0;
      itemsRemembered = 0;
      rubysCollected = 0;
      fishsCollected = 0;
    } else {
      coinsCollected = coinsRemembered;
      itemsCollected = itemsRemembered;
      rubysCollected = rubysRemembered;
    }
    animDelay = 0;
    animFrame = 0;
    velocity.x = 0;
    velocity.y = 0;
  }//reset

  /********************
   ** Kwyboard input **
   *******************/

  void inputCheck() {
    // keyboard flags are set by keyPressed/keyReleased in the main .pde

    float speedHere = (isOnGround ? RUN_SPEED : AIR_RUN_SPEED);
    float frictionHere = (isOnGround ? SLOWDOWN_PERC : AIR_SLOWDOWN_PERC);

    if (theKeyboard.holdingLeft) {
      velocity.x -= speedHere;
    } else if (theKeyboard.holdingRight) {
      velocity.x += speedHere;
    } 
    velocity.x *= frictionHere; // causes player to constantly lose speed

    if (isOnGround || isOnPlatform) { // player can only jump if currently on the ground
      if (theKeyboard.holdingSpace || theKeyboard.holdingUp) { // either up arrow or space bar cause the player to jump
        sndJump.trigger(); // play sound
        velocity.y = -JUMP_POWER; // adjust vertical speed
        isOnGround = false; // mark that the player has left the ground, i.e. cannot jump again for now
      }
    }
  }//inputCheck

  /*********************
   ** Collision check **
   ********************/

  void checkForWallBumping() {

    int guyWidth, guyHeight, wallProbeDistance, ceilingProbeDistance;

    if (level==1) {
      guyWidth = player1.width;
      guyHeight = player1.height;
      wallProbeDistance = int(guyWidth*0.3);
      ceilingProbeDistance = int(guyHeight*0.95);
    } else if (level==2) {
      guyWidth = player2.width;
      guyHeight = player2.height;
      wallProbeDistance = int(guyWidth*0.3);
      ceilingProbeDistance = int(guyHeight*0.95);
    } else if (level==3) {
      guyWidth = player3.width;
      guyHeight = player3.height;
      wallProbeDistance = int(guyWidth*0.3);
      ceilingProbeDistance = int(guyHeight*0.95);
    } else if (level==4) {
      guyWidth = player4.width;
      guyHeight = player4.height;
      wallProbeDistance = int(guyWidth*0.3);
      ceilingProbeDistance = int(guyHeight*0.95);
    } else {
      guyWidth = player1.width;
      guyHeight = player1.height;
      wallProbeDistance = int(guyWidth*0.3);
      ceilingProbeDistance = int(guyHeight*0.95);
    }
    
    /* Because of how we draw the player, "position" is the center of the feet/bottom
     * To detect and handle wall/ceiling collisions, we create 5 additional positions:
     * leftSideHigh - left of center, at shoulder/head level
     * leftSideLow - left of center, at shin level
     * rightSideHigh - right of center, at shoulder/head level
     * rightSideLow - right of center, at shin level
     * topSide - horizontal center, at tip of head
     * These 6 points - 5 plus the original at the bottom/center - are all that we need
     * to check in order to make sure the player can't move through blocks in the world.
     * This works because the block sizes (World.GRID_UNIT_SIZE) aren't small enough to
     * fit between the cracks of those collision points checked.
     */

    // used as probes to detect running into walls, ceiling
    PVector leftSideHigh, rightSideHigh, leftSideLow, rightSideLow, topSide;
    leftSideHigh = new PVector();
    rightSideHigh = new PVector();
    leftSideLow = new PVector();
    rightSideLow = new PVector();
    topSide = new PVector();

    // update wall probes
    leftSideHigh.x = leftSideLow.x = position.x - wallProbeDistance; // left edge of player
    rightSideHigh.x = rightSideLow.x = position.x + wallProbeDistance; // right edge of player
    leftSideLow.y = rightSideLow.y = position.y-0.3*guyHeight; // shin high
    leftSideHigh.y = rightSideHigh.y = position.y-0.8*guyHeight; // shoulder high 

    topSide.x = position.x; // center of player
    topSide.y = position.y-ceilingProbeDistance; // top of guy

    if ( theWorld.worldSquareAt(topSide)==World.TILE_MUNCHER || theWorld.worldSquareAt(leftSideHigh)==World.TILE_MUNCHER ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_MUNCHER || theWorld.worldSquareAt(rightSideHigh)==World.TILE_MUNCHER ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_MUNCHER || theWorld.worldSquareAt(position)==World.TILE_MUNCHER ||
      theWorld.worldSquareAt(topSide)==World.TILE_LAVA || theWorld.worldSquareAt(leftSideHigh)==World.TILE_LAVA ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_LAVA || theWorld.worldSquareAt(rightSideHigh)==World.TILE_LAVA ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_LAVA || theWorld.worldSquareAt(position)==World.TILE_LAVA ||
      theWorld.worldSquareAt(topSide)==World.TILE_KILL || theWorld.worldSquareAt(leftSideHigh)==World.TILE_KILL ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_KILL || theWorld.worldSquareAt(rightSideHigh)==World.TILE_KILL ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_KILL || theWorld.worldSquareAt(position)==World.TILE_KILL ||
      theWorld.worldSquareAt(topSide)==World.TILE_WATER || theWorld.worldSquareAt(leftSideHigh)==World.TILE_WATER ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_WATER || theWorld.worldSquareAt(rightSideHigh)==World.TILE_WATER ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_WATER || theWorld.worldSquareAt(position)==World.TILE_WATER ||
      theWorld.worldSquareAt(topSide)==World.TILE_WATER2 || theWorld.worldSquareAt(leftSideHigh)==World.TILE_WATER2 ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_WATER2 || theWorld.worldSquareAt(rightSideHigh)==World.TILE_WATER2 ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_WATER2 || theWorld.worldSquareAt(position)==World.TILE_WATER2) {

      calculateLifes();
      return;
    }

    if (  theWorld.worldSquareAt(topSide)==World.TILE_SOLID || theWorld.worldSquareAt(topSide)==World.TILE_SOLID2 ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(topSide)==World.TILE_GRASS_RIGHT ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(topSide)==World.TILE_GRASS_RIGHT_TOP ||
      theWorld.worldSquareAt(topSide)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(topSide)==World.TILE_STONE ||
      theWorld.worldSquareAt(topSide)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(topSide)==World.TILE_CLOUD ||
      theWorld.worldSquareAt(topSide)==World.TILE_MOVING || theWorld.worldSquareAt(topSide)==World.TILE_ALGE ||
      theWorld.worldSquareAt(topSide)==World.TILE_BLASE || theWorld.worldSquareAt(topSide)==World.TILE_ALGE_BOTTOM ||
      theWorld.worldSquareAt(topSide)==World.TILE_MAGIC || theWorld.worldSquareAt(topSide)==World.TILE_BLASE2 || 
    theWorld.worldSquareAt(topSide)==World.TILE_FON1 || theWorld.worldSquareAt(topSide)==World.TILE_FON2 ){

      if (theWorld.worldSquareAt(position)==World.TILE_SOLID || theWorld.worldSquareAt(position)==World.TILE_SOLID2 ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT_TOP ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(position)==World.TILE_STONE ||
        theWorld.worldSquareAt(position)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(position)==World.TILE_CLOUD ||
        theWorld.worldSquareAt(position)==World.TILE_MOVING || theWorld.worldSquareAt(position)==World.TILE_ALGE ||
        theWorld.worldSquareAt(position)==World.TILE_BLASE || theWorld.worldSquareAt(position)==World.TILE_ALGE_BOTTOM ||
        theWorld.worldSquareAt(position)==World.TILE_MAGIC || theWorld.worldSquareAt(position)==World.TILE_BLASE2 || 
        theWorld.worldSquareAt(position)==World.TILE_FON1 || theWorld.worldSquareAt(position)==World.TILE_FON2 ) {
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

    if ( theWorld.worldSquareAt(leftSideLow)==World.TILE_SOLID || theWorld.worldSquareAt(leftSideLow)==World.TILE_SOLID2 ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_RIGHT ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_RIGHT_TOP ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(leftSideLow)==World.TILE_STONE ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(leftSideLow)==World.TILE_CLOUD ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_MOVING || theWorld.worldSquareAt(leftSideLow)==World.TILE_ALGE ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_BLASE || theWorld.worldSquareAt(leftSideLow)==World.TILE_ALGE_BOTTOM ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_MAGIC || theWorld.worldSquareAt(leftSideLow)==World.TILE_BLASE2 || 
      theWorld.worldSquareAt(leftSideLow)==World.TILE_FON1 || theWorld.worldSquareAt(leftSideLow)==World.TILE_FON2 ||
      theWorld.worldSquareAt(leftSideLow)==World.TILE_CLOUD2 || theWorld.worldSquareAt(leftSideLow)==World.TILE_CLOUD_DIS) {
      position.x = theWorld.rightOfSquare(leftSideLow)+wallProbeDistance;
      if (velocity.x < 0) {
        velocity.x = 0.0;
      }
    }

    if (  theWorld.worldSquareAt(leftSideHigh)==World.TILE_SOLID || theWorld.worldSquareAt(leftSideHigh)==World.TILE_SOLID2 ||
      theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_RIGHT ||
      theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_RIGHT_TOP ||
      theWorld.worldSquareAt(leftSideHigh)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(leftSideHigh)==World.TILE_STONE ||
      theWorld.worldSquareAt(leftSideHigh)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(leftSideHigh)==World.TILE_CLOUD ||
      theWorld.worldSquareAt(leftSideHigh)==World.TILE_MOVING || theWorld.worldSquareAt(leftSideHigh)==World.TILE_ALGE ||
      theWorld.worldSquareAt(leftSideHigh)==World.TILE_BLASE || theWorld.worldSquareAt(leftSideHigh)==World.TILE_ALGE_BOTTOM ||
      theWorld.worldSquareAt(leftSideHigh)==World.TILE_MAGIC || theWorld.worldSquareAt(leftSideHigh)==World.TILE_BLASE2 || 
      theWorld.worldSquareAt(leftSideHigh)==World.TILE_FON1 || theWorld.worldSquareAt(leftSideHigh)==World.TILE_FON2 ||
      theWorld.worldSquareAt(leftSideHigh)==World.TILE_CLOUD2 || theWorld.worldSquareAt(leftSideHigh)==World.TILE_CLOUD_DIS) {
      position.x = theWorld.rightOfSquare(leftSideHigh)+wallProbeDistance;
      if (velocity.x < 0) {
        velocity.x = 0.0;
      }
    }

    if ( theWorld.worldSquareAt(rightSideLow)==World.TILE_SOLID || theWorld.worldSquareAt(rightSideLow)==World.TILE_SOLID2 ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_RIGHT ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_RIGHT_TOP ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(rightSideLow)==World.TILE_STONE ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(rightSideLow)==World.TILE_CLOUD ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_MOVING || theWorld.worldSquareAt(rightSideLow)==World.TILE_ALGE ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_BLASE || theWorld.worldSquareAt(rightSideLow)==World.TILE_ALGE_BOTTOM ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_MAGIC || theWorld.worldSquareAt(rightSideLow)==World.TILE_BLASE2 || 
      theWorld.worldSquareAt(rightSideLow)==World.TILE_FON1 || theWorld.worldSquareAt(rightSideLow)==World.TILE_FON2 ||
      theWorld.worldSquareAt(rightSideLow)==World.TILE_CLOUD2 || theWorld.worldSquareAt(rightSideLow)==World.TILE_CLOUD_DIS) {
      position.x = theWorld.leftOfSquare(rightSideLow)-wallProbeDistance;
      if (velocity.x > 0) {
        velocity.x = 0.0;
      }
    }

    if ( theWorld.worldSquareAt(rightSideHigh)==World.TILE_SOLID || theWorld.worldSquareAt(rightSideHigh)==World.TILE_SOLID2 ||
      theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_LEFT || theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_RIGHT ||
      theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_RIGHT_TOP ||
      theWorld.worldSquareAt(rightSideHigh)==World.TILE_GRASS_LTR || theWorld.worldSquareAt(rightSideHigh)==World.TILE_STONE ||
      theWorld.worldSquareAt(rightSideHigh)==World.TILE_LAVA_TOP || theWorld.worldSquareAt(rightSideHigh)==World.TILE_CLOUD ||
      theWorld.worldSquareAt(rightSideHigh)==World.TILE_MOVING || theWorld.worldSquareAt(rightSideHigh)==World.TILE_ALGE ||
      theWorld.worldSquareAt(rightSideHigh)==World.TILE_BLASE || theWorld.worldSquareAt(rightSideHigh)==World.TILE_ALGE_BOTTOM ||
      theWorld.worldSquareAt(rightSideHigh)==World.TILE_MAGIC || theWorld.worldSquareAt(rightSideHigh)==World.TILE_BLASE2 || 
      theWorld.worldSquareAt(rightSideHigh)==World.TILE_FON1 || theWorld.worldSquareAt(rightSideHigh)==World.TILE_FON2 ||
      theWorld.worldSquareAt(rightSideHigh)==World.TILE_CLOUD2 || theWorld.worldSquareAt(rightSideHigh)==World.TILE_CLOUD_DIS) {
      position.x = theWorld.leftOfSquare(rightSideHigh)-wallProbeDistance;
      if (velocity.x > 0) {
        velocity.x = 0.0;
      }
    }
  }//checkForWallbumping

  /******************************
   ** Coins / Items collection **
   *****************************/

  void checkForCoinGetting() {

    PVector centerOfPlayer,topSide;
    
    int guyWidth, guyHeight, wallProbeDistance, ceilingProbeDistance;

    if (level==1) {
      guyWidth = player1.width;
      guyHeight = player1.height;
      wallProbeDistance = int(guyWidth*0.3);
      ceilingProbeDistance = int(guyHeight*0.95);
    } else if (level==2) {
      guyWidth = player2.width;
      guyHeight = player2.height;
      wallProbeDistance = int(guyWidth*0.3);
      ceilingProbeDistance = int(guyHeight*0.95);
    } else if (level==3) {
      guyWidth = player3.width;
      guyHeight = player3.height;
      wallProbeDistance = int(guyWidth*0.3);
      ceilingProbeDistance = int(guyHeight*0.95);
    } else if (level==4) {
      guyWidth = player4.width;
      guyHeight = player4.height;
      wallProbeDistance = int(guyWidth*0.3);
      ceilingProbeDistance = int(guyHeight*0.95);
    } else {
      guyWidth = player1.width;
      guyHeight = player1.height;
      wallProbeDistance = int(guyWidth*0.3);
      ceilingProbeDistance = int(guyHeight*0.95);
    }

    topSide = new PVector(position.x, position.y-guyHeight);
    centerOfPlayer = new PVector(position.x, position.y-guyHeight/2);

    if (theWorld.worldSquareAt(centerOfPlayer)==World.COIN) { //Coins
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      coinsCollected++;
      if (!checkpointTriggered) {
        coinsRemembered++;
      }
    } else if (theWorld.worldSquareAt(topSide)==World.COIN) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      coinsCollected++;
      if (!checkpointTriggered) {
        coinsRemembered++;
      }
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.RUBY) { //Rubys
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      rubysCollected++;
      if (!checkpointTriggered) {
        rubysRemembered++;
      }
    } else if (theWorld.worldSquareAt(topSide)==World.RUBY) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      rubysCollected++;
      if (!checkpointTriggered) {
        rubysRemembered++;
      }
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.FISH) { //Fish
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      fishsCollected++;
      dogeMessages.textPosition=1;
      dogeMessages.dogeSpeaking=true;
      dogeText3();
    } else if (theWorld.worldSquareAt(topSide)==World.FISH) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      fishsCollected++;
      dogeMessages.textPosition=1;
      dogeMessages.dogeSpeaking=true;
      dogeText3();
    }
    /***************
     **  Dominic  **
     **************/
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_DOMINIC_APPLE) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item1=true;
      messages.textPosition=1;
      storyDCL();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_DOMINIC_APPLE) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item1=true;
      messages.textPosition=1;
      storyDCL();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_DOMINIC_BIER) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item2=true;
      messages.textPosition=1;
      storyDCL2();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_DOMINIC_BIER) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item2=true;
      messages.textPosition=1;
      storyDCL2();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_DOMINIC_KAFFEE) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item3=true;
      messages.textPosition=1;
      storyDCL3();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_DOMINIC_KAFFEE) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item3=true;
      messages.textPosition=1;
      storyDCL3();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_DOMINIC_COMPUTER) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item4=true;
      storyDCL4();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_DOMINIC_COMPUTER) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item4=true;
      messages.textPosition=1;
      storyDCL4();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_DOMINIC_BURGER) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      messages.textPosition=1;
      itembox.item5=true;
      storyDCL5();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_DOMINIC_BURGER) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item5=true;
      messages.textPosition=1;
      storyDCL5();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_DOMINIC_GOLF) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      messages.textPosition=1;
      itembox.item6=true;
      storyDCL6();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_DOMINIC_GOLF) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item6=true;
      messages.textPosition=1;
      storyDCL6();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_DOMINIC_JAVA) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      messages.textPosition=1;
      itembox.item7=true;
      storyDCL7();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_DOMINIC_JAVA) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item7=true;
      messages.textPosition=1;
      storyDCL7();
    }
    /***********
     **  LENA  **
     ***********/
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LENA_BRILLE) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item1=true;
      storyLENA();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LENA_BRILLE) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item1=true;
      messages.textPosition=1;
      storyLENA();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LENA_HUND) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item2=true;
      storyLENA2();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LENA_HUND) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item2=true;
      messages.textPosition=1;
      storyLENA2();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LENA_KUNST) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item3=true;
      storyLENA3();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LENA_KUNST) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item3=true;
      messages.textPosition=1;
      storyLENA3();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LENA_VEGGIE) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item4=true;
      storyLENA4();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LENA_VEGGIE) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item4=true;
      messages.textPosition=1;
      storyLENA4();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LENA_SPORT) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      messages.textPosition=1;
      itembox.item5=true;
      storyLENA5();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LENA_SPORT) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item5=true;
      messages.textPosition=1;
      storyLENA5();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LENA_METAL) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      messages.textPosition=1;
      itembox.item6=true;
      storyLENA6();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LENA_METAL) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item6=true;
      messages.textPosition=1;
      storyLENA6();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LENA_NOTEN) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      messages.textPosition=1;
      itembox.item7=true;
      storyLENA7();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LENA_NOTEN) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item7=true;
      messages.textPosition=1;
      storyLENA7();
    }
    /************
     **  CENNET **
     ************/
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_CENNET_BRILLE) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item1=true;
      storyCENNET();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_CENNET_BRILLE) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item1=true;
      messages.textPosition=1;
      storyCENNET();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_CENNET_CAT) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item2=true;
      storyCENNET2();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_CENNET_CAT) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item2=true;
      messages.textPosition=1;
      storyCENNET2();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_CENNET_BURGER) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item3=true;
      storyCENNET3();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_CENNET_BURGER) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item3=true;
      messages.textPosition=1;
      storyCENNET3();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_CENNET_SCHMINKE) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item4=true;
      storyCENNET4();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_CENNET_SCHMINKE) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item4=true;
      messages.textPosition=1;
      storyCENNET4();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_CENNET_KUNST) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      messages.textPosition=1;
      itembox.item5=true;
      storyCENNET5();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_CENNET_KUNST) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item5=true;
      messages.textPosition=1;
      storyCENNET5();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_CENNET_NOTEN) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      messages.textPosition=1;
      itembox.item6=true;
      storyCENNET6();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_CENNET_NOTEN) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item6=true;
      messages.textPosition=1;
      storyCENNET6();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_CENNET_GAMEBOY) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      messages.textPosition=1;
      itembox.item7=true;
      storyCENNET7();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_CENNET_GAMEBOY) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item7=true;
      messages.textPosition=1;
      storyCENNET7();
    }
    /***********
     **  LORI  **
     ***********/
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LORI_BRILLE) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item1=true;
      storyLORI();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LORI_BRILLE) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item1=true;
      messages.textPosition=1;
      storyLORI();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LORI_COMPUTER) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item2=true;
      storyLORI2();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LORI_COMPUTER) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item2=true;
      messages.textPosition=1;
      storyLORI2();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LORI_NOTEN) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item3=true;
      storyLORI3();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LORI_NOTEN) { 
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item3=true;
      messages.textPosition=1;
      storyLORI3();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LORI_TOPF) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      messages.textPosition=1;
      itembox.item4=true;
      storyLORI4();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LORI_TOPF) {
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      if (!checkpointTriggered) {
        itemsRemembered++;
      }
      itembox.item4=true;
      messages.textPosition=1;
      storyLORI4();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LORI_SCHUHE) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      messages.textPosition=1;
      itembox.item5=true;
      storyLORI5();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LORI_SCHUHE) {
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item5=true;
      messages.textPosition=1;
      storyLORI5();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LORI_EIS) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      messages.textPosition=1;
      itembox.item6=true;
      storyLORI6();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LORI_EIS) {
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item6=true;
      messages.textPosition=1;
      storyLORI6();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.ITEM_LORI_KUNST) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      messages.textPosition=1;
      itembox.item7=true;
      storyLORI7();
    } else if (theWorld.worldSquareAt(topSide)==World.ITEM_LORI_KUNST) {
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      sndCoin.trigger();
      itemsCollected++;
      itembox.item7=true;
      messages.textPosition=1;
      storyLORI7();
    }
    if (position.x<25 && dogeIntroCount==0 && level==1) {
      dogeIntroCount++;
      dogeMessages.textPosition=1;
      dogeMessages.dogeSpeaking=true;
      dogeText1();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.TILE_TRIGGER_EVENT) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_EMPTY);
      dogeMessages.textPosition=1;
      dogeMessages.dogeSpeaking=true;
      dogeText2();
    } else if (theWorld.worldSquareAt(position)==World.TILE_TRIGGER_EVENT) {
      theWorld.setSquareAtToThis(position, World.TILE_EMPTY);
      dogeMessages.textPosition=1;
      dogeMessages.dogeSpeaking=true;
      dogeText2();
    } else if (theWorld.worldSquareAt(topSide)==World.TILE_TRIGGER_EVENT) {
      theWorld.setSquareAtToThis(topSide, World.TILE_EMPTY);
      dogeMessages.textPosition=1;
      dogeMessages.dogeSpeaking=true;
      dogeText2();
    }
    if (theWorld.worldSquareAt(centerOfPlayer)==World.TILE_CHECKPOINT) {
      theWorld.setSquareAtToThis(centerOfPlayer, World.TILE_START);
      checkpointTriggered=true;
      saveGame();
    } else if (theWorld.worldSquareAt(position)==World.TILE_CHECKPOINT) {
      theWorld.setSquareAtToThis(position, World.TILE_START);
      checkpointTriggered=true;
      saveGame();
    } else if (theWorld.worldSquareAt(topSide)==World.TILE_CHECKPOINT) {
      theWorld.setSquareAtToThis(topSide, World.TILE_START);
      checkpointTriggered=true;
      saveGame();
    }
  }//checkForCoinGettin

  /*********************
   ****** Falling ******
   ********************/

  void checkForFalling() {
    // If we're standing on an empty or coin tile, we're not standing on anything. Fall!
    PVector centerOfPlayer;

    int guyHeight;

    if (level==1) {
      guyHeight = player1.height;
    } else if (level==2) {
      guyHeight = player2.height;
    } else if (level==3) {
      guyHeight = player3.height;
    } else if (level==4) {
      guyHeight = player4.height;
    } else {
      guyHeight = player1.height;
    }

    centerOfPlayer = new PVector(position.x, position.y-guyHeight/2);

    if (theWorld.worldSquareAt(position)==World.TILE_EMPTY ||
      theWorld.worldSquareAt(position)==World.TILE_BLOCK ||
      theWorld.worldSquareAt(position)==World.COIN ||
      theWorld.worldSquareAt(position)==World.ITEM_DOMINIC_APPLE ||
      theWorld.worldSquareAt(position)==World.ITEM_DOMINIC_BIER ||
      theWorld.worldSquareAt(position)==World.ITEM_DOMINIC_KAFFEE ||
      theWorld.worldSquareAt(position)==World.ITEM_DOMINIC_COMPUTER ||
      theWorld.worldSquareAt(position)==World.ITEM_DOMINIC_BURGER ||
      theWorld.worldSquareAt(position)==World.ITEM_DOMINIC_GOLF ||
      theWorld.worldSquareAt(position)==World.ITEM_DOMINIC_JAVA ||
      theWorld.worldSquareAt(position)==World.ITEM_LENA_HUND ||
      theWorld.worldSquareAt(position)==World.ITEM_LENA_KUNST ||
      theWorld.worldSquareAt(position)==World.ITEM_LENA_VEGGIE ||
      theWorld.worldSquareAt(position)==World.ITEM_LENA_SPORT ||
      theWorld.worldSquareAt(position)==World.ITEM_LENA_METAL ||
      theWorld.worldSquareAt(position)==World.ITEM_LENA_NOTEN ||
      theWorld.worldSquareAt(position)==World.ITEM_CENNET_BRILLE ||
      theWorld.worldSquareAt(position)==World.ITEM_CENNET_CAT ||
      theWorld.worldSquareAt(position)==World.ITEM_CENNET_BURGER ||
      theWorld.worldSquareAt(position)==World.ITEM_CENNET_SCHMINKE ||
      theWorld.worldSquareAt(position)==World.ITEM_CENNET_KUNST ||
      theWorld.worldSquareAt(position)==World.ITEM_CENNET_NOTEN ||
      theWorld.worldSquareAt(position)==World.ITEM_CENNET_GAMEBOY ||
      theWorld.worldSquareAt(position)==World.ITEM_LORI_BRILLE ||
      theWorld.worldSquareAt(position)==World.ITEM_LORI_COMPUTER ||
      theWorld.worldSquareAt(position)==World.ITEM_LORI_NOTEN ||
      theWorld.worldSquareAt(position)==World.ITEM_LORI_TOPF ||
      theWorld.worldSquareAt(position)==World.ITEM_LORI_SCHUHE ||
      theWorld.worldSquareAt(position)==World.ITEM_LORI_EIS ||
      theWorld.worldSquareAt(position)==World.ITEM_LORI_KUNST) {
      isOnGround=false;
    }

    if (isOnGround==false) { // not on ground?    
      if (theWorld.worldSquareAt(position)==World.TILE_SOLID || theWorld.worldSquareAt(position)==World.TILE_MUNCHER ||
        theWorld.worldSquareAt(position)==World.TILE_SOLID2 || theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT || theWorld.worldSquareAt(position)==World.TILE_GRASS_LTR ||
        theWorld.worldSquareAt(position)==World.TILE_GRASS_LEFT_TOP || theWorld.worldSquareAt(position)==World.TILE_GRASS_RIGHT_TOP ||
        theWorld.worldSquareAt(position)==World.TILE_STONE || theWorld.worldSquareAt(position)==World.TILE_LAVA_TOP ||
        theWorld.worldSquareAt(position)==World.TILE_LAVA || theWorld.worldSquareAt(position)==World.TILE_CLOUD ||
        theWorld.worldSquareAt(position)==World.TILE_ALGE || theWorld.worldSquareAt(position)==World.TILE_BLASE ||
        theWorld.worldSquareAt(position)==World.TILE_ALGE_BOTTOM || theWorld.worldSquareAt(position)==World.TILE_MAGIC || 
        theWorld.worldSquareAt(position)==World.TILE_BLASE2 || theWorld.worldSquareAt(position)==World.TILE_FON1 || 
        theWorld.worldSquareAt(position)==World.TILE_FON2 || theWorld.worldSquareAt(position)==World.TILE_CLOUD2) { // landed on solid square?
        isOnGround = true;
        position.y = theWorld.topOfSquare(position);
        velocity.y = 0.0;
      } else { // fall
        velocity.y += GRAVITY_POWER;
      }
    }
    if (isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_SOLID || isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_MUNCHER ||
        isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_SOLID2 || isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_GRASS_LEFT ||
        isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_GRASS_RIGHT || isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_GRASS_LTR ||
        isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_GRASS_LEFT_TOP || isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_GRASS_RIGHT_TOP ||
        isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_STONE || isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_LAVA_TOP ||
        isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_LAVA || isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_CLOUD ||
        isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_ALGE || isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_BLASE ||
        isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_ALGE_BOTTOM || isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_MAGIC || 
        isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_BLASE2 || isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_FON1 || 
        isOnGround && theWorld.worldSquareAt(centerOfPlayer)==World.TILE_FON2 || theWorld.worldSquareAt(centerOfPlayer)==World.TILE_CLOUD2){
          position.y=position.y-guyHeight;
        }
  }//checkForFalling

/**
 * Method to push Player up when stepping on Spout
 * 
 * @author Claßen, Dominic
 */

  void checkForSpout(){
    if (theWorld.worldSquareAt(position)==World.TILE_FON1 || theWorld.worldSquareAt(position)==World.TILE_FON2){
      velocity.y=-10;
    }
  }//checkForSpout

/**
 * Method to start Bubble Explosion Timers
 * 
 * @author Claßen, Dominic
 */

  void worldEvent(){
    if((theWorld.worldSquareAt(position)==World.TILE_BLASE && !boom) || (theWorld.worldSquareAt(position)==World.TILE_CLOUD2 && !boom)){
      timer = millis();
      tilePosition = new PVector(position.x,position.y);
      boom=true;
    }    
    if(millis()/1000-timer/1000==1 && boom && level==3){
      theWorld.setSquareAtToThis(tilePosition, World.TILE_BLASE2);
        timers.add(new Timer((int)millis(),tilePosition));
        boom=false;
      }
    if(millis()/1000-timer/1000==1 && boom && level==1){
      theWorld.setSquareAtToThis(tilePosition, World.TILE_CLOUD_DIS);
      timers.add(new Timer((int)millis(),tilePosition));
      boom=false;
    }
  }//worldEvent

  void move() {
    position.add(velocity);

    checkForWallBumping();

    checkForCoinGetting();

    checkForFalling();

    checkForSpout();

    worldEvent();
  }//move

/**
 * Method to calculate Player lifes
 * 
 * @author Claßen, Dominic
 */

  void calculateLifes() {
    if (level==1 && !gameWon()) {  
      loadLVL1();
      if (lifes>1) {
        lifes--;
        sndLifeLost.trigger();
      } else if (lifes==1) {
        music.pause();
        sndPlayerDead.play();
        sndPlayerDead.rewind();
        lifes--;
      }
    } else if (level==2 && !gameWon()) {
      loadLVL2();
      if (lifes>1) {
        lifes--;
        sndLifeLost.trigger();
      } else if (lifes==1) {
        music.pause();
        sndPlayerDead.play();
        sndPlayerDead.rewind();
        lifes--;
      }
    } else if (level==3 && !gameWon()) {
      loadLVL3();
      if (lifes>1) {
        lifes--;
        sndLifeLost.trigger();
      } else if (lifes==1) {
        music.pause();
        sndPlayerDead.play();
        sndPlayerDead.rewind();
        lifes--;
      }
    } else if (level==4 && !gameWon()) {
      loadLVL4();
      if (lifes>1) {
        lifes--;
        sndLifeLost.trigger();
      } else if (lifes==1) {
        music.pause();
        sndPlayerDead.play();
        sndPlayerDead.rewind();
        lifes--;
      }
    }
  }//calculateLifes

  /*********************
   ** Figur "zeichnen" **
   *********************/

  void draw() {
    int guyWidth;
    int guyHeight;

//Height / Width per Player
    if (level==1) {
      guyWidth = player1.width;
      guyHeight = player1.height;
    } else if (level==2) {
      guyWidth = player2.width;
      guyHeight = player2.height;
    } else if (level==3) {
      guyWidth = player3.width;
      guyHeight = player3.height;
    } else if (level==4) {
      guyWidth = player4.width;
      guyHeight = player4.height;
    } else {
      guyWidth = player1.width;
      guyHeight = player1.height;
    }

    //Player facing Right / Left
    if (velocity.x<-TRIVIAL_SPEED) {
      facingRight = false;
    } else if (velocity.x>TRIVIAL_SPEED) {
      facingRight = true;
    }

    pushMatrix(); // lets us compound/accumulate translate/scale/rotate calls, then undo them all at once
    translate(position.x, position.y);

    //Player LVL 1

    if (level==1) {
      if (facingRight==false) {
        scale(-1, 1); // flip horizontally by scaling horizontally by -100%
      }
      translate(-guyWidth/2, -guyHeight); // drawing images centered on character's feet

      if (isOnGround==false && !isOnPlatform) { // falling or jumping
        image(player1_run1, 0, 0); // this running pose looks pretty good while in the air
      } else if (abs(velocity.x)<TRIVIAL_SPEED || isOnPlatform && abs(velocity.x)<TRIVIAL_SPEED) { // not moving fast, i.e. standing
        image(player1, 0, 0);
      } else { // running. Animate.
        if (animDelay--<0) {
          animDelay=RUN_ANIMATION_DELAY;
          if (animFrame==0) {
            animFrame=1;
          } else {
            animFrame=0;
          }
        }

        if (animFrame==0) {
          image(player1_run1, 0, 0);
        } else {
          image(player1_run2, 0, 0);
        }
      }
    } else if (level==2) {            //Player LVL 2
      if (facingRight==false) {
        scale(-1, 1);
      }
      translate(-guyWidth/2, -guyHeight);

      if (isOnGround==false && !isOnPlatform) {
        image(player2_run1, 0, 0);
      } else if (abs(velocity.x)<TRIVIAL_SPEED || isOnPlatform && abs(velocity.x)<TRIVIAL_SPEED) {
        image(player2, 0, 0);
      } else {
        if (animDelay--<0) {
          animDelay=RUN_ANIMATION_DELAY;
          if (animFrame==0) {
            animFrame=1;
          } else {
            animFrame=0;
          }
        }

        if (animFrame==0) {
          image(player2_run1, 0, 0);
        } else {
          image(player2_run2, 0, 0);
        }
      }
    } else if (level==3) {            //Player LVL 3
      if (facingRight==false) {
        scale(-1, 1);
      }
      translate(-guyWidth/2, -guyHeight);

      if (isOnGround==false && !isOnPlatform) {
        image(player3_run1, 0, 0);
      } else if (abs(velocity.x)<TRIVIAL_SPEED || isOnPlatform && abs(velocity.x)<TRIVIAL_SPEED) {
        image(player3, 0, 0);
      } else {
        if (animDelay--<0) {
          animDelay=RUN_ANIMATION_DELAY;
          if (animFrame==0) {
            animFrame=1;
          } else {
            animFrame=0;
          }
        }

        if (animFrame==0) {
          image(player3_run1, 0, 0);
        } else {
          image(player3_run2, 0, 0);
        }
      }
    } else if (level==4) {            //Player LVL 4
      if (facingRight==false) {
        scale(-1, 1);
      }
      translate(-guyWidth/2, -guyHeight);

      if (isOnGround==false && !isOnPlatform) {
        image(player4_run1, 0, 0);
      } else if (abs(velocity.x)<TRIVIAL_SPEED || isOnPlatform && abs(velocity.x)<TRIVIAL_SPEED) {
        image(player4, 0, 0);
      } else {
        if (animDelay--<0) {
          animDelay=RUN_ANIMATION_DELAY;
          if (animFrame==0) {
            animFrame=1;
          } else {
            animFrame=0;
          }
        }

        if (animFrame==0) {
          image(player4_run1, 0, 0);
        } else {
          image(player4_run2, 0, 0);
        }
      }
    }
    if(theKeyboard.throwFish && fishsCollected>0){
      fishs.add(new Fish(position.x, position.y));
      fishsCollected--;
    }

    popMatrix(); // undoes all translate/scale/rotate calls since the pushMatrix earlier in this function
  }//draw
}//Player.class