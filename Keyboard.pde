/**************************************************************************************
 **  Basecode: http://www.hobbygamedev.com/int/platformer-game-source-in-processing/  **
 ***************************************************************************************
 **
 **  Keeps track of keystrokes
 **
 */

class Keyboard {
  // used to track keyboard input
  Boolean holdingUp, holdingRight, holdingLeft, holdingSpace, holdingDown;
  Boolean throwFish;

  Keyboard() {
    holdingUp=holdingRight=holdingLeft=holdingSpace=holdingDown=false;
    debug=false;
    throwFish=false;
  }//keyboard

  /* The way that Processing, and many programming languages/environments, deals with keys is
   * treating them like events (something can happen the moment it goes down, or when it goes up).
   * Because we want to treat them like buttons - checking "is it held down right now?" - we need to
   * use those pressed and released events to update some true/false values that we can check elsewhere.
   */

  void pressKey(int key, int keyCode) {
    if (key == 'r') { // never will be held down, so no Boolean needed to track it
      if (level==0) {
        level=1;
        loadLVL1();
        dogeIntro=true;
        gameStarted=true;
        saveGame();
      } else if (gameWon() && level==1) {//If gameWon()...
        thePlayer.checkpointTriggered=false;
        level=2;
        loadLVL2(); // ...load next lvl
        saveGame();
      } else if (gameWon() && level==2) {
        thePlayer.checkpointTriggered=false;
        level=3;
        loadLVL3();
        saveGame();
      } else if (gameWon() && level==3) {
        thePlayer.checkpointTriggered=false;
        level=4;
        loadLVL4();
        saveGame();
      } else if (gameWon() && level==4) {
        level=5;
        ending();
      }
      if (lifes==0) {
        thePlayer.checkpointTriggered=false;
        music.play();
        if(level==1){
          loadLVL1();
          lifes=3;
        } else if(level==2){
          loadLVL2();
          lifes=3;
        } else if(level==3){
          loadLVL3();
          lifes=3;
        } else if(level==4){
          loadLVL4();
          lifes=3;
        }
      }
    }
    if (key == 'l'  && !gameStarted) {
      loadGame();
      if (level==1) {
        gameStarted=true;
        loadLVL1();
        if(!thePlayer.checkpointTriggered){
        dogeIntro=true;
        }
        
      }
      if (level==2) {
        loadLVL2();
        dogeIntro=false;
        gameStarted=true;
      } else if (level==3) {
        loadLVL3();
        dogeIntro=false;
        gameStarted=true;
      } else if (level==4) {
        loadLVL4();
        dogeIntro=false;
        gameStarted=true;
      }
    }
    if (key == 'd' && !debug) {
      debug=true;
      rememberLifes=lifes;
      lifes=999;
    } else if (key == 'd' && debug)
    { 
      debug=false;
      lifes=rememberLifes;
    }
    if (debug) {
      if (key == '1') {
        dogeIntro=false;
        thePlayer.checkpointTriggered=false;
        level=1;
        loadLVL1();
      } else if (key == '2') {
        dogeIntro=false;
        thePlayer.checkpointTriggered=false;
        level=2;
        loadLVL2();
      } else if (key == '3') {
        dogeIntro=false;
        thePlayer.checkpointTriggered=false;
        level=3;
        loadLVL3();
      } else if (key == '4') {
        dogeIntro=false;
        thePlayer.checkpointTriggered=false;
        level=4;
        loadLVL4();
      } else if (key == '9') {
        dogeIntro=false;
        thePlayer.checkpointTriggered=false;
        loadLVLtest();
      }
    }
    if(key == 'f'){
      throwFish=true;
    }
    /***************************
     **  Mute music / resume  **
     **************************/

    if (!music.isMuted() && key == 'm') {
      music.mute();
      sndJump.mute();
      sndCoin.mute();
      sndLifeLost.mute();
      sndPlayerDead.mute();
      sndGameWon.mute();
    } else if (music.isMuted() && key =='m') { 
      music.unmute();
      sndJump.unmute();
      sndCoin.unmute();
      sndLifeLost.unmute();
      sndPlayerDead.unmute();
      sndGameWon.unmute();
    }

    /******************************************************************************************************
     **  Pauses the game and loads the Menu background, game can be resumed (loop stopped and relooped)  ** 
     *****************************************************************************************************/

    if (key == 'p' && level!=0) {
      if (looping) {
        music.pause();
        noLoop();
        image(menu,0,0);
        textAlign(CENTER);
        outlinedText("P to Resume", width/2, height/2);
      } else {
        loop();
        music.loop();
      }
    }

    if (keyCode == UP) {
      holdingUp = true;
    }
    if (keyCode == LEFT) {
      holdingLeft = true;
    }
    if (keyCode == RIGHT) {
      holdingRight = true;
    }
    if (keyCode == ' ') {
      holdingSpace = true;
    }
  }//pressKey

  void releaseKey(int key, int keyCode) {
    if (keyCode == UP) {
      holdingUp = false;
    }
    if (keyCode == LEFT) {
      holdingLeft = false;
    }
    if (keyCode == RIGHT) {
      holdingRight = false;
    }        
    if (keyCode == ' ') {
      holdingSpace = false;
    }
    if(key == 'f'){
      throwFish = false;
    }
  }//releaseKey
}//Keyboard.class