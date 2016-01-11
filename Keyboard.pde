/**************************************************************************************
 **  Basecode: http://www.hobbygamedev.com/int/platformer-game-source-in-processing/  **
 ***************************************************************************************
 **
 **  Gibt die Tastenanschläge weiter
 **
 */

class Keyboard {
  // used to track keyboard input
  Boolean holdingUp, holdingRight, holdingLeft, holdingSpace, holdingDown;


  Keyboard() {
    holdingUp=holdingRight=holdingLeft=holdingSpace=holdingDown=false;
    debug=false;
    MusicOn=true;
  }//keyboard

  /* The way that Processing, and many programming languages/environments, deals with keys is
   * treating them like events (something can happen the moment it goes down, or when it goes up).
   * Because we want to treat them like buttons - checking "is it held down right now?" - we need to
   * use those pressed and released events to update some true/false values that we can check elsewhere.
   */

  void pressKey(int key, int keyCode) {
    if (key == 'r') { // never will be held down, so no Boolean needed to track it
      if(!gameStarted){
      }
      if (level==0) {
        loadLVL1();
        level++;
        dogeIntro=true;
        gameStarted=true;
        saveGame();
      }
      if (gameWon() && level==1) {//Sofern das Spiel gewonnen wurde..
        thePlayer.checkpointTriggered=false;
        loadLVL2(); // wird dass passende LVL geladen
        level++;
        saveGame();
      } else if (gameWon() && level==2) {
        thePlayer.checkpointTriggered=false;
        loadLVL3();
        level++;
        saveGame();
      } else if (gameWon() && level==3) {
        thePlayer.checkpointTriggered=false;
        loadLVL4();
        level++;
        saveGame();
      } else if (gameWon() && level==4) {
        //thePlayer.checkpointTriggered=false;
        ending();
        level++;
      } else if (lifes==0) {
        thePlayer.checkpointTriggered=false;
        music.play();
        loadLVL1();
        lifes=3;
        level=1;
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
        loadLVL1();
        level=1;
      } else if (key == '2') {
        dogeIntro=false;
        thePlayer.checkpointTriggered=false;
        loadLVL2();
        level=2;
      } else if (key == '3') {
        dogeIntro=false;
        thePlayer.checkpointTriggered=false;
        loadLVL3();
        level=3;
      } else if (key == '4') {
        dogeIntro=false;
        thePlayer.checkpointTriggered=false;
        loadLVL4();
        level=4;
      } else if (key == '9') {
        dogeIntro=false;
        thePlayer.checkpointTriggered=false;
        loadLVLtest();
      }
    }
    /*if (key =='s'){
      saveGame();
    }*/

    /***************************************
     **  Musik muten / wieder aufschalten  **
     ***************************************/

    if (!music.isMuted() && key == 'm') {
      music.mute();
      sndJump.mute();
      sndCoin.mute();
      sndEnemieDead.mute();
      sndLifeLost.mute();
      sndPlayerDead.mute();
      sndGameWon.mute();
    } else if (music.isMuted() && key =='m') { 
      music.unmute();
      sndJump.unmute();
      sndCoin.unmute();
      sndEnemieDead.unmute();
      sndLifeLost.unmute();
      sndPlayerDead.unmute();
      sndGameWon.unmute();
    }

    /***************************************************************************************************************************
     **  Spiel kann pausiert werden, Loop von Draw wird angehalten und der Menühintergrund geladen, außerdem ein Hinweistext,  ** 
     **  wie das Spiel fortgesetzt werden kann                                                                                 **
     ***************************************************************************************************************************/

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
  }//releaseKey
}//Keyboard.class