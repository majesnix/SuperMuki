/********************************************************************************************************************************************
 ***************************************************************SOURCES**********************************************************************
 **                                                                                                                                        **
 **  Basecode: http://www.hobbygamedev.com/int/platformer-game-source-in-processing/                                                       **
 **  modifiziert durch dcl                                                                                                                 **
 **                                                                                                                                        **
 **  Music: http://ericskiff.com/music/            'A Night Of Dizzy Spells'                                                               **
 **                                                                                                                                        **
 **  SoundEffects: http://www.opengameart.org/                                                                                             **
 **                                                                                                                                        **
 **  Ninja: http://opengameart.org/content/ninja-animated                                                                                  **
 **  Archer: http://opengameart.org/content/ranger-animated                                                                                **
 **                                                                                                                                        **
 **  Typewriting text: https://forum.processing.org/two/discussion/10746/how-to-make-typewriter-effect  (24.12.2015)                       **
 **  modifiziert durch dcl                                                                                                                 **
 **                                                                                                                                        **
 **  Font: http://sourcefoundry.org/hack/                                                                                                  **
 **                                                                                                                                        **
 **  Verständnis ArrayLists: http://www.openprocessing.org/sketch/57710    (29.12.2015)                                                    **
 **                                                                                                                                        **
 **  https://forum.processing.org/one/topic/arraylist-remove-object-causes-flickering-problem-rendering.html (29.12.2015)                  **
 **                                                                                                                                        **
 **  How to Save a Game: https://forum.processing.org/two/discussion/6800/how-can-save-and-load-a-game                                     **
 **                                                                                                                                        **
 **  LVL Speicherort ausgelagert (Danke Jan)  (09.01.2016)                                                                                 **
 **                                                                                                                                        **
 ********************************************************************************************************************************************
 *******************************************************************************************************************************************/

/*****************************************
 **  Imports für Musik, Video und Gifs  **
 ****************************************/

import ddf.minim.*;      //https://github.com/ddf/Minim
import processing.video.*;
import gifAnimation.*;   //https://github.com/01010101/GifAnimation

Minim minim;
Movie ending;

/****************************
 **  Bilder initialisieren  **
 ****************************/

PImage player1, player1_run1, player1_run2;
PImage player2, player2_run1, player2_run2;
PImage player3, player3_run1, player3_run2;
PImage player4, player4_run1, player4_run2;
PImage bg, bg2, bg3, bg4, menu;
PImage dirt, grass_top, grass_left_top, grass_right_top, grass_ltr, stone, alge, alge_bottom, blase, grass_left, grass_right, dirt_big;
PImage arrow, fireball, pigshot;
PImage questionmark;
PImage rubin;

Gif muncher, ninja, archer, archer_attack, archer_attack2, ninja_attack, fireface, fireface_left, fireface_right, evilpig, bee, ballon_cat, piranha;
Gif lava, lava_top, wolke, water, flower, fon1, fon2, blase2;
Gif coin;
/************
 **  ITEMS  **
 ************/

Gif dcl_bier, dcl_computer;
PImage dcl_apple, dcl_kaffe, dcl_burger, dcl_golf, dcl_java;
PImage lena_brille, lena_hund, lena_kunst, lena_veggie, lena_sport, lena_metal, lena_noten;
PImage cennet_brille, cennet_cat, cennet_burger, cennet_schminke, cennet_kunst, cennet_noten, cennet_gameboy;
Gif lori_computer;
PImage lori_brille, lori_noten, lori_topf, lori_schuhe, lori_eis, lori_kunst;

Gif magical_doge;

PFont font;

// Kamerabewegung
float cameraOffsetX;
float cameraOffsetY;

//Gravity
final float GRAVITY_POWER = 0.8;

/*********************
 **  Hilfsvariablen  **
 *********************/

int lifes; //Leben
int rememberLifes;
int level; //Level Counter
int checkpointReachedDisplayTimer;

Boolean debug, MusicOn;
Boolean dogeIntro;
Boolean gameStarted;
Boolean dogeSpeaking;

int gameStartTimeSec, gameCurrentTimeSec;

static final String SAVEGAME = "savegame.dat";

/******************************
 **  music and sound effects  **
 ******************************/

AudioPlayer music, sndPlayerDead; // AudioPlayer uses less memory. Better for music.
AudioSample sndJump, sndCoin, sndEnemieDead, sndLifeLost, sndGameWon; // AudioSample plays more respnosively. Better for sound effects.

/********************************************************************
 **  Objekte für Spieler, Gegner, die Welt, Keyboardeingaben, etc.  **
 ********************************************************************/

ArrayList<Ninja> ninjas = new ArrayList<Ninja>();
ArrayList<Archer> archers = new ArrayList<Archer>();
ArrayList<Arrow> arrows = new ArrayList<Arrow>();
ArrayList<Fireface> firefaces = new ArrayList<Fireface>();
ArrayList<Fireball> fireballs = new ArrayList<Fireball>();
ArrayList<Evilpig> evilpigs = new ArrayList<Evilpig>();
ArrayList<Pigshot> pigshots = new ArrayList<Pigshot>();
ArrayList<Bee> bees = new ArrayList<Bee>();
ArrayList<Piranha> piranhas = new ArrayList<Piranha>();
ArrayList<MovingPlatform> platforms = new ArrayList<MovingPlatform>();
ArrayList<Timer> timers = new ArrayList<Timer>();

Player thePlayer = new Player();
World theWorld = new World();
Keyboard theKeyboard = new Keyboard();
Doge theDoge = new Doge();
BallonCat theBallonCat = new BallonCat();
MsgBox messages;
MsgBox dogeMessages;
ItemBox itembox;

/************
 **  SETUP  **
 ************/

void setup() {
  size(1280, 960);

  pixelDensity(1);

  font = loadFont("Hack-20.vlw");

  messages = new MsgBox(new PVector(width/2-280, height-(height/100)*10), 560, font, 40);
  dogeMessages = new MsgBox(new PVector(width/2-280, height-height/100*99), 560, font, 30);
  itembox = new ItemBox(new PVector(10, height-height/100*7), 290);

  loadImages();

  menu.resize(width, height);
  bg.resize(width, height);
  bg2.resize(width, height);
  bg3.resize(width, height);
  bg4.resize(width, height);

  lifes = 3;
  level = 0;
  checkpointReachedDisplayTimer = 0;

  cameraOffsetX = 0.0;
  cameraOffsetY = 0.0;

  ending=new Movie(this, "ende.mp4");

  /*******************************************
   **  Läd die Sound"engine" / Soundeffekte  **
   *******************************************/

  minim = new Minim(this);
  music = minim.loadFile("sounds/music.mp3", 1024);
  music.setGain(-30.0); //Lautstärke ertragbar machen
  music.loop();
  int buffersize = 256;
  sndJump = minim.loadSample("sounds/Jump.wav", buffersize);
  sndCoin = minim.loadSample("sounds/coin.wav", buffersize);
  sndEnemieDead = minim.loadSample("sounds/Sound_Boese_Wicht.mp3", buffersize);
  sndLifeLost = minim.loadSample("sounds/life_lost.mp3", buffersize);
  sndPlayerDead = minim.loadFile("sounds/game_over.mp3", 1024);
  sndGameWon = minim.loadSample("sounds/Sound_Gewonnen.mp3", buffersize);

  frameRate(30);

  dogeIntro=false;
  gameStarted=false;
}//Setup

void loadGame() {
  dogeIntro=false;
  String[] values = loadStrings(SAVEGAME);
  level = int(values[0]);
  thePlayer.checkpointTriggered=boolean(values[1]);
  thePlayer.itemsRemembered=int(values[2]);
  thePlayer.coinsRemembered=int(values[3]);
  itembox.item1=boolean(values[4]);
  itembox.item2=boolean(values[5]);
  itembox.item3=boolean(values[6]);
  itembox.item4=boolean(values[7]);
  itembox.item5=boolean(values[8]);
  itembox.item6=boolean(values[9]);
  itembox.item7=boolean(values[10]);
  lifes=int(values[11]);
  thePlayer.rubysRemembered=int(values[12]);
}//loadGame

void saveGame() {

  String [] values = {
    str(level), 
    str(thePlayer.checkpointTriggered), 
    str(thePlayer.itemsCollected), 
    str(thePlayer.coinsCollected), 
    str(itembox.item1), 
    str(itembox.item2), 
    str(itembox.item3), 
    str(itembox.item4), 
    str(itembox.item5), 
    str(itembox.item6), 
    str(itembox.item7), 
    str(lifes), 
    str(thePlayer.rubysCollected)
  };

  saveStrings(dataFile(SAVEGAME), values);
}//saveGame

void loadImages() {

  /*******************
   **  BACKGROUNDS  **
   ******************/

  menu = loadImage("backgrounds/supermuki_background.png");
  bg=loadImage("backgrounds/background.jpg");
  bg2=loadImage("backgrounds/background2.jpg");
  bg3=loadImage("backgrounds/background3.jpg");
  bg4=loadImage("backgrounds/background4.jpg");

  /**************
   **  PLAYERS  **
   **************/

  player1 = loadImage("players/guy.png");
  player1_run1 = loadImage("players/run1.png");
  player1_run2 = loadImage("players/run2.png");
  player2 = loadImage("players/lori.png");
  player2_run1 = loadImage("players/lori1.png");
  player2_run2 = loadImage("players/lori2.png");
  player3 = loadImage("players/cennet.png");
  player3_run1 = loadImage("players/cennet1.png");
  player3_run2 = loadImage("players/cennet2.png");
  player4 = loadImage("players/lena.png");
  player4_run1 = loadImage("players/lena1.png");
  player4_run2 = loadImage("players/lena2.png");

  /************
   **  TILES  **
   ************/

  dirt = loadImage("tiles/dirt_dcl.png");
  dirt_big = loadImage("tiles/dirt_23x10.png");
  grass_top=loadImage("tiles/ground-top_dcl.png");
  grass_left_top=loadImage("tiles/gL.png");
  grass_right_top=loadImage("tiles/gR.png");
  grass_left=loadImage("tiles/dirt_grass_left.png");
  grass_right=loadImage("tiles/dirt_grass_right.png");
  grass_ltr=loadImage("tiles/gLOR.png");
  stone=loadImage("tiles/stone_dcl.png");
  lava = new Gif(this, "tiles/lava.gif");
  lava.loop();
  lava_top = new Gif(this, "tiles/lava_top.gif");
  lava_top.loop();
  wolke = new Gif(this, "tiles/wolke.gif");
  wolke.loop();
  alge = loadImage("tiles/algen.png");
  alge_bottom = loadImage("tiles/algen_b.png");
  blase = loadImage("tiles/blase.png");
  water = new Gif(this, "tiles/water.gif");
  water.loop();
  flower = new Gif(this, "tiles/flower.gif");
  flower.loop();
  blase2 = new Gif(this, "tiles/blase2.gif");
  blase2.loop();
  fon1 = new Gif(this, "tiles/fontaeneLinks.gif");
  fon1.loop();
  fon2 = new Gif(this, "tiles/fontaeneRechts.gif");
  fon2.loop();

  /**************
   **  ENEMIES  **
   **************/

  arrow = loadImage("enemies/arrow.png");
  fireball = loadImage("enemies/fire.png");
  archer = new Gif(this, "enemies/archer.gif");
  archer.loop();
  archer_attack = new Gif(this, "enemies/archer_attack.gif");
  archer_attack.loop();
  archer_attack2 = new Gif(this, "enemies/archer_attack2.gif");
  archer_attack2.loop();
  ninja = new Gif(this, "enemies/ninja.gif");
  ninja.loop();
  ninja_attack = new Gif(this, "enemies/ninja_attack.gif");
  ninja_attack.loop();
  fireface = new Gif (this, "enemies/fireface_animated.gif");
  fireface.loop();
  fireface_left = new Gif (this, "enemies/fireface_animated_l.gif");
  fireface_left.loop();
  fireface_right = new Gif (this, "enemies/fireface_animated_r.gif");
  fireface_right.loop();
  evilpig = new Gif(this, "enemies/evilpig.gif");
  evilpig.loop();
  pigshot = loadImage("enemies/pigshot.png");
  bee = new Gif(this, "enemies/bee.gif");
  bee.loop();
  ballon_cat = new Gif(this,"enemies/ballon_cat.gif");
  ballon_cat.loop();
  piranha = new Gif(this, "enemies/piranha.gif");
  piranha.loop();

  muncher = new Gif(this, "tiles/muncher_dcl.gif");
  muncher.loop();

  /***********
   **  DOGE  **
   ***********/

  magical_doge = new Gif(this, "magical_doge.gif");
  magical_doge.loop();

  /************
   **  ITEMS  **
   ************/

  coin = new Gif(this, "items/Coin.gif");
  coin.loop();
  rubin = loadImage("items/rubin.png");

  dcl_apple = loadImage("items/dominic/apple.png");
  dcl_bier = new Gif(this, "items/dominic/bier.gif");
  dcl_bier.loop();
  dcl_kaffe = loadImage("items/dominic/kaffee.png");
  dcl_computer = new Gif(this, "items/dominic/pc.gif");
  dcl_computer.loop();
  dcl_burger = loadImage("items/dominic/burger.png");
  dcl_golf = loadImage("items/dominic/golf.png");
  dcl_java = loadImage("items/dominic/java.png");
  lena_brille = loadImage("items/lena/brille.png");
  lena_hund = loadImage("items/lena/dog.png");
  lena_kunst = loadImage("items/lena/kunst.png");
  lena_veggie = loadImage("items/lena/veggie.png");
  lena_sport = loadImage("items/lena/sport.png");
  lena_metal = loadImage("items/lena/metal.png");
  lena_noten = loadImage("items/lena/note.png");
  cennet_brille = loadImage("items/cennet/brille.png");
  cennet_cat = loadImage("items/cennet/cat.png");
  cennet_burger = loadImage("items/cennet/burger.png");
  cennet_schminke = loadImage("items/cennet/schminke.png");
  cennet_kunst = loadImage("items/cennet/kunst.png");
  cennet_noten = loadImage("items/cennet/note.png");
  cennet_gameboy = loadImage("items/cennet/gameboy.png");
  lori_brille = loadImage("items/lori/brille.png");
  lori_computer = new Gif(this, "items/lori/pc.gif");
  lori_computer.loop();
  lori_noten = loadImage("items/lori/note.png");
  lori_topf = loadImage("items/lori/topf.png");
  lori_schuhe = loadImage("items/lori/schuhe.png");
  lori_eis = loadImage("items/lori/eis.png");
  lori_kunst = loadImage("items/lori/kunst.png");

  /***********
   **  ELSE  **
   **********/

  questionmark = loadImage("fragezeichen.png");
}//loadImages

/**
 * Method to load the world - array from external file *.tsv
 * 
 * @author Wystub, Jan
 *
 * @param n Number of world to load from
 * e.g. if n is 3, file 'world3.tsv.xls' will load
 */
 
int[][] loadWorld(int n) {
  Table t;
  try {
    t = loadTable("worlds/world" + n + ".tsv.xls", "tsv");
  } 
  catch (NullPointerException e) {
    e.printStackTrace();
    t = null;
  }
  if (t == null) {
    return null;
  } else {
    int[][] a = new int[t.getRowCount()][t.getColumnCount()];
    for (int i = 0; i < a.length; i++) {
      for (int j = 0; j < a[i].length; j++) {
        a[i][j] = t.getInt(i, j);
      }
      println();
    }
    return a;
  }
}

/************
 **  LVL 1  **
 ************/

void loadLVL1() {

  resetEverything(); // resettet Spieler, Gegener, Platformen, etc.
  theWorld.generate(1);
  if (!thePlayer.checkpointTriggered) {
    gameCurrentTimeSec = gameStartTimeSec = millis()/1000; // Setz timer zurück
  }
}//loadLVL1

/************
 **  LVL 2  **
 ************/

void loadLVL2() {

  resetEverything(); // resettet Spieler, Gegener, Platformen, etc.
  theWorld.generate(2);
  if (!thePlayer.checkpointTriggered) {
    gameCurrentTimeSec = gameStartTimeSec = millis()/1000; // Setz timer zurück
  }
}//loadLVL2

/************
 **  LVL 3  **
 ************/

void loadLVL3() {

  resetEverything(); // resettet Spieler, Gegener, Platformen, etc.
  theWorld.generate(3);
  if (!thePlayer.checkpointTriggered) {
    gameCurrentTimeSec = gameStartTimeSec = millis()/1000; // Setz timer zurück
  }
}//loadLVL3

/************
 **  LVL 4  **
 ************/

void loadLVL4() {

  resetEverything(); // resettet Spieler, Gegener, Platformen, etc.
  theWorld.generate(4);
  if (!thePlayer.checkpointTriggered) {
    gameCurrentTimeSec = gameStartTimeSec = millis()/1000; // Setz timer zurück
  }
}//loadLVL4

/************
 **  TEST  **
 ************/

void loadLVLtest() {

  resetEverything(); // resettet Spieler, Gegener, Platformen, etc.
  theWorld.generate(9);
  if (!thePlayer.checkpointTriggered) {
    gameCurrentTimeSec = gameStartTimeSec = millis()/1000; // Setz timer zurück
  }
}//loadLVLtest

/**************
 **  ending  **
 *************/

void ending() {

  music.pause();
  resetEverything();
  theWorld.generate(5);
  ending.play();
}//ending

void movieEvent(Movie m) {
  m.read();
}//movieEvent

void resetEverything() {

  arrows.clear();//Löscht alle elemente der ArrayLists
  timers.clear();
  fireballs.clear();
  platforms.clear(); 
  ninjas.clear();
  archers.clear();
  firefaces.clear();
  evilpigs.clear();
  pigshots.clear();
  bees.clear();
  piranhas.clear();

  itembox.reset();
  theDoge.reset();
  thePlayer.reset();
}//resetEverything

/**********************
 **  Siegesbedingung  **
 **********************/

Boolean gameWon() {
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

  PVector rightSideHigh, rightSideLow, topSide, centerOfPlayer;
  rightSideHigh = new PVector();
  rightSideLow = new PVector();
  topSide = new PVector();
  centerOfPlayer = new PVector();

  // update wall probes
  rightSideHigh.x = rightSideLow.x = thePlayer.position.x + wallProbeDistance;
  rightSideLow.y = thePlayer.position.y-0.3*guyHeight;
  rightSideHigh.y = thePlayer.position.y-0.8*guyHeight;

  topSide.x = thePlayer.position.x;
  topSide.y = thePlayer.position.y-ceilingProbeDistance;
  centerOfPlayer.x = thePlayer.position.x;
  centerOfPlayer.y = thePlayer.position.y-guyHeight/2;

  if (theWorld.worldSquareAt(thePlayer.position)==World.TILE_WIN || theWorld.worldSquareAt(rightSideHigh)==World.TILE_WIN ||
    theWorld.worldSquareAt(rightSideLow)==World.TILE_WIN || theWorld.worldSquareAt(topSide)==World.TILE_WIN ||
    theWorld.worldSquareAt(centerOfPlayer)==World.TILE_WIN) {
      sndGameWon.trigger();
    return true;
  } else {
    return false;
  }
}//gameWon


/*************************************************
 **  Umrandet den Text mit einem schwarzen Rand  **
 **************************************************/

void outlinedText(String sayThis, float atX, float atY) {
  textFont(font);
  fill(0);
  text(sayThis, atX-1, atY);
  text(sayThis, atX+1, atY);
  text(sayThis, atX, atY-1);
  text(sayThis, atX, atY+1);
  fill(255);
  text(sayThis, atX, atY);
}//outlinedText

/************************************************************************************************************
 **  Aktualisiert die Kamera perspektive, sobald der Spieler die Mitte des Bildes erreicht hat X / Y Wert,  **
 **  wird das Bild mitbewegt                                                                                **
 **                                                                                                         **
 **  Y "Verfolgung" hinzugefügt, dcl                                                                        **
 ************************************************************************************************************/

void updateCameraPosition() {
  int rightEdge = World.GRID_UNITS_WIDE*World.GRID_UNIT_SIZE-width;
  int topEdge = World.GRID_UNITS_TALL*World.GRID_UNIT_SIZE-height;
  // the left side of the camera view should never go right of the above number
  // think of it as "total width of the game world" (World.GRID_UNITS_WIDE*World.GRID_UNIT_SIZE)
  // minus "width of the screen/window" (width)

  cameraOffsetX = thePlayer.position.x-width/2;
  cameraOffsetY = thePlayer.position.y-height/2;
  if (cameraOffsetX < 0) {
    cameraOffsetX = 0;
  }

  if (cameraOffsetX > rightEdge) {
    cameraOffsetX = rightEdge;
  }

  if (cameraOffsetY < 0) {
    cameraOffsetY = 0;
  }

  if (cameraOffsetY-topEdge > 0) {
    cameraOffsetY = topEdge;
  }
}//updateCameraPosition

/***********************************************************
 **  Setz den passenden Text, je nach eingesammeltem Item  **
 ***********************************************************/

void storyDCL() {
  messages.s[0] = "Dominic likes Apple(s). As long as one \nWindows PC is left!";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyDCL

void storyDCL2() {
  messages.s[0] = "He really likes to drink one or two\nBeer, after work is done";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyDCL2

void storyDCL3() {
  messages.s[0] = "He is also a heavy coffee drinker.\nCoffee helps to find solutions!";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyDCL3

void storyDCL4() {
  messages.s[0] = "He always loves to play and work\nwith the Computer.";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyDCL4

void storyDCL5() {
  messages.s[0] = "He likes to eat delicous burgers";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyDCL5

void storyDCL6() {
  messages.s[0] = "His Sport of choice is Golf.";
  messages.s[1] = "Because Golf is played all around the World\nand is always in nice places";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyDCL6

void storyDCL7() {
  messages.s[0] = "He started to like Java in his\napprenticeship.";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyDCL7

void storyLENA() {
  messages.s[0] = "She has to wear glasses in lectures and\nwhile driving with her car.";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLENA

void storyLENA2() {
  messages.s[0] = "She has a little dog, since she's 10 years\nold";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLENA2

void storyLENA3() {
  messages.s[0] = "She loves art and designes a lot of things";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLENA3

void storyLENA4() {
  messages.s[0] = "She wants to eat less meat and\nis going to be a vegetarian";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLENA4

void storyLENA5() {
  messages.s[0] = "She does a lot of sports and has\nbeen in an athletics club";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLENA5

void storyLENA6() {
  messages.s[0] = "Her favorite music is metal and her favorite\nbands are While She Sleeps and BMTH";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLENA6

void storyLENA7() {
  messages.s[0] = "She is playing paino for more than 6 years";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLENA7

void storyCENNET() {
  messages.s[0] = "Cennet needs glasses since the 5th Class.";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyCENNET

void storyCENNET2() {
  messages.s[0] = "Cennet's favorite animals are cats.";
  messages.s[1] = "She also owns a cat called País.";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyCENNET2

void storyCENNET3() {
  messages.s[0] = "Cennet loves fast food like Burgers , Pizza ,\nFries.";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyCENNET3

void storyCENNET4() {
  messages.s[0] = "One of Cennet's passion is Makeup.";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyCENNET4

void storyCENNET5() {
  messages.s[0] = "She loves being creative.";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyCENNET5

void storyCENNET6() {
  messages.s[0] = "Cennet loves music, she also had 3 years\nof piano lessons.";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyCENNET6

void storyCENNET7() {
  messages.s[0] = "Cennets playes lots of video games like\nLeague of Legends, Osu!and S4League.";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyCENNET7

void storyLORI() {
  messages.s[0] = "Lori wears glasses";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLORI

void storyLORI2() {
  messages.s[0] = "Lori likes to work with the computer\non her free time";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLORI2

void storyLORI3() {
  messages.s[0] = "Lori sings alot";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLORI3

void storyLORI4() {
  messages.s[0] = "Lory cooks everyday";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLORI4

void storyLORI5() {
  messages.s[0] = "Lori often buys shoes";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLORI5

void storyLORI6() {
  messages.s[0] = "Lori enjoys to eat Ice cream\n(especiially in summer)";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLORI6

void storyLORI7() {
  messages.s[0] = "Lori also does painting";
  messages.s[1] = "";

  messages.setText(messages.s[messages.index]);
  messages.animateText();
}//storyLORI7

void dogeText1() {
  dogeSpeaking=true;
  dogeMessages.s[0] = "Hello, my name is Doge and I will support \nyou on your journey!";
  dogeMessages.s[1] = "Watch out, the Ninjas and Archers\nwill try to kill you...";

  dogeMessages.setText(dogeMessages.s[dogeMessages.index]);
  dogeMessages.animateText();
}

void dogeText2() {
  dogeSpeaking=true;
  dogeMessages.s[0] = "Watch out, the clouds are ending!\nYou need to jump!!";
  dogeMessages.s[1] = "Fear not, I will protect you with my magical\nPower and soften your landing!";

  dogeMessages.setText(dogeMessages.s[dogeMessages.index]);
  dogeMessages.animateText();
}

void dogeRandomText() {
  switch(int(random(7))) {
  case 1:
    dogeMessages.s[0] = "Much wow, Such skill";
    dogeMessages.s[1] = "";
    break;
  case 2:
    dogeMessages.s[0] = "Much fate";
    dogeMessages.s[1] = "";
    break;
  case 3:
    dogeMessages.s[0] = "Such skill";
    dogeMessages.s[1] = "";
    break;
  case 4:
    dogeMessages.s[0] = "Very skill";
    dogeMessages.s[1] = "";
    break;
  case 5:
    dogeMessages.s[0] = "Such 2D";
    dogeMessages.s[1] = "";
    break;
  case 6:
    dogeMessages.s[0] = "Very code";
    dogeMessages.s[1] = "";
    break;
  case 7:
    dogeMessages.s[0] = "Much wow";
    dogeMessages.s[1] = "";
    break;
  }
  dogeMessages.setText(dogeMessages.s[dogeMessages.index]);
  dogeMessages.animateText();
}

/***********
 **  DRAW  **
 ***********/

void draw() {

  /*****************************************************
   **  Wechselnde Hintergründe je LVL + Abspann Video  **
   *****************************************************/

  if (level==0) {
    image(menu, 0, 0);
  } else if (level==1) {
    image(bg, 0, 0);
  } else if (level==2) {
    image(bg2, 0, 0);
  } else if (level==3) {
    image(bg3, 0, 0);
  } else if (level==4) {
    image(bg4, 0, 0);
  } else if (level==5) {
    image(ending, 0, 0);
  }

  pushMatrix();
  translate(-cameraOffsetX, -cameraOffsetY); // affects all upcoming graphics calls, until popMatrix

  updateCameraPosition();

  if (level!=0) {
    theWorld.render();
  }
  if (level!=5 && lifes!=0 && level!=0 && !gameWon()) {
    for (int i=0; i < ninjas.size(); i++) {
      Ninja ninja = ninjas.get(i);
      if (ninja.position.x<thePlayer.position.x+width && ninja.position.x>thePlayer.position.x-width) {
        ninja.move();
        ninja.draw();
      }
    }

    for (int i = ninjas.size(); i != 0; ) {
      Ninja ninja = ninjas.get(--i);
      if ( !ninja.alive ) {  
        ninjas.remove(i);
      }
    }
    for (int i=0; i < archers.size(); i++) {
      Archer archer = archers.get(i);
      if (archer.position.x<thePlayer.position.x+width && archer.position.x>thePlayer.position.x-width) {
        archer.move();
        archer.draw();
      }
    }
    for (int i = archers.size(); i != 0; ) {
      Archer archer = archers.get(--i);
      if ( !archer.alive ) {  
        archers.remove(i);
      }
    }
    for (int i=0; i < arrows.size(); i++) {
      Arrow arrow = arrows.get(i);
      arrow.move();
      arrow.draw();
    }
    for (int i = arrows.size(); i != 0; ) {
      Arrow arrow = arrows.get(--i);
      if ( !arrow.alive ) {  
        arrows.remove(i);
      }
    }
    for (int i=0; i < firefaces.size(); i++) {
      Fireface fireface = firefaces.get(i);
      if (fireface.position.x<thePlayer.position.x+width && fireface.position.x>thePlayer.position.x-width) {
        //fireface.move();
        fireface.draw();
      }
    }
    for (int i=0; i < fireballs.size(); i++) {
      Fireball fireball = fireballs.get(i);
      fireball.move();
      fireball.draw();
    }
    for (int i = fireballs.size(); i != 0; ) {
      Fireball fireball = fireballs.get(--i);
      if ( !fireball.alive ) {  
        fireballs.remove(i);
      }
    }
    for (int i=0; i < evilpigs.size(); i++) {
      Evilpig evilpig = evilpigs.get(i);
      if (evilpig.position.x<thePlayer.position.x+width && evilpig.position.x>thePlayer.position.x-width) {
        evilpig.move();
        evilpig.draw();
      }
    }
    for (int i = evilpigs.size(); i != 0; ) {
      Evilpig evilpig = evilpigs.get(--i);
      if ( !evilpig.alive ) {  
        evilpigs.remove(i);
      }
    }
    for (int i=0; i < pigshots.size(); i++) {
      Pigshot pigshot = pigshots.get(i);
      pigshot.move();
      pigshot.draw();
    }
    for (int i = pigshots.size(); i != 0; ) {
      Pigshot pigshot = pigshots.get(--i);
      if ( !pigshot.alive ) {  
        pigshots.remove(i);
      }
    }
    for (int i=0; i < bees.size(); i++) {
      Bee bee = bees.get(i);
      if (bee.position.x<thePlayer.position.x+width && bee.position.x>thePlayer.position.x-width) {
        bee.move();
        bee.draw();
      }
    }
    for (int i = bees.size(); i != 0; ) {
      Bee bee = bees.get(--i);
      if ( !bee.alive ) {  
        bees.remove(i);
      }
    }
    for (int i=0; i < piranhas.size(); i++) {
      Piranha piranha = piranhas.get(i);
      if (piranha.position.x<thePlayer.position.x+width && piranha.position.x>thePlayer.position.x-width) {
        piranha.move();
        piranha.draw();
      }
    }
    for (int i = piranhas.size(); i != 0; ) {
      Piranha piranha = piranhas.get(--i);
      if ( !piranha.alive ) {  
        piranhas.remove(i);
      }
    }
    for (int i=0; i < platforms.size(); i++) {
      MovingPlatform platform = platforms.get(i);
      if (platform.position.x<thePlayer.position.x+width && platform.position.x>thePlayer.position.x-width) {
        platform.move();
        platform.draw();
      }
    }
    for (int i=0; i < timers.size(); i++) {
      Timer timer = timers.get(i);
        timer.run();
    }
    for (int i = timers.size(); i != 0; ) {
      Timer timer = timers.get(--i);
      if ( timer.done ) {  
        timers.remove(i);
      }
    }
    
    if(!dogeMessages.dogeSpeaking){
    theDoge.dogeRandom();
    }
    theDoge.move();
    theDoge.draw();
    
    theBallonCat.move();
    theBallonCat.draw();

    if (!dogeIntro) {
      thePlayer.inputCheck();
    }
    thePlayer.move();
    thePlayer.draw();
  }

  popMatrix();

  if (level>0 && level<5) {
    itembox.display();
  }

  textAlign(LEFT);
  if (lifes>0) {
    if (dogeMessages.textPosition==1 && dogeMessages.displayTimer() || dogeMessages.textPosition==2 && dogeMessages.displayTimer() && !dogeMessages.s[1].isEmpty()) {
      dogeMessages.run();
    } else if (dogeMessages.textPosition==3) {
      dogeMessages.reset();
      dogeIntro=false;
    }
    if (messages.textPosition==1 && messages.displayTimer() || messages.textPosition==2 && messages.displayTimer() && !messages.s[1].isEmpty()) {
      messages.run();
    } else if (messages.textPosition==3) {
      messages.reset();
    }
  }

  if (focused == false) { // Fenster ausgewählt?
    textAlign(CENTER);
    outlinedText("Click here to Play!\n\nUse the arrow keys to move.\nSpacebar or UP to jump.", width/2, height-height/100*31.25);
  } else {
    if (level!=0) {
      textAlign(LEFT); 
      if (level!=5 && lifes!=0) {
        outlinedText("Rubys: "+thePlayer.rubysCollected +"/"+theWorld.rubysInStage, 8, height-height/100*14);
        outlinedText("Coins: "+thePlayer.coinsCollected +"/"+theWorld.coinsInStage, 8, height-height/100*11);
        outlinedText("Items Collected:", 8, height-height/100*8);
        outlinedText("Lifes: "+lifes, 10, 25);
        outlinedText("Level: "+level+"/4", 10, 55);

        textAlign(RIGHT);
        if (gameWon() == false) { // stop updating timer after player finishes
          gameCurrentTimeSec = millis()/1000; // dividing by 1000 to turn milliseconds into seconds
        }
        int minutes = (gameCurrentTimeSec-gameStartTimeSec)/60;
        int seconds = (gameCurrentTimeSec-gameStartTimeSec)%60;
        if (seconds < 10) { // pad the "0" into the tens position
          outlinedText(minutes +":0"+seconds, width-8, height-10);
        } else {
          outlinedText(minutes +":"+seconds, width-8, height-10);
        }
        fill(100, 100, 100, 127);
        rect(width-110, 5, 108, 48);
        outlinedText("Pause: P", width-8, 25);
        outlinedText("Mute: M", width-8, 45);


        if (debug) {
          outlinedText("Player X: "+thePlayer.position.x, width-8, 75);
          outlinedText("Player Y: "+thePlayer.position.y, width-8, 95);
          outlinedText("Doge X: "+theDoge.position.x, width-8, 115);
          outlinedText("Doge Y: "+theDoge.position.y, width-8, 135);
          outlinedText("Cam X: "+cameraOffsetX, width-8, 155);
          outlinedText("Cam Y: "+cameraOffsetY, width-8, 175);
          outlinedText("topEdge: "+(World.GRID_UNITS_TALL*World.GRID_UNIT_SIZE-height+0.), width-8, 195);
          outlinedText("Ninja Count: "+ninjas.size(), width-8, 235);
          outlinedText("Archer Count: "+archers.size(), width-8, 255);
          outlinedText("ArrowCount: "+arrows.size(), width-8, 275);
          outlinedText("isOnGround: "+thePlayer.isOnGround, width-8, 295);
          outlinedText("Doge Intro: "+dogeIntro, width-8, 315);
          outlinedText("Coins Remembered: "+thePlayer.coinsRemembered, width-8, 335);
          outlinedText("Items Remembered: "+thePlayer.itemsRemembered, width-8, 355);
          outlinedText("Item 1: "+itembox.item1, width-8, 375);
          outlinedText("Item 2: "+itembox.item2, width-8, 395);
          outlinedText("Item 3: "+itembox.item3, width-8, 415);
          outlinedText("Item 4: "+itembox.item4, width-8, 435);
          outlinedText("Item 5: "+itembox.item5, width-8, 455);
          outlinedText("Item 6: "+itembox.item6, width-8, 475);
          outlinedText("Item 7: "+itembox.item7, width-8, 495);
          outlinedText("Level: "+level, width-8, 515);
          outlinedText("Checkpoint Triggered: "+thePlayer.checkpointTriggered, width-8, 535);
          outlinedText("Doge Speaking: "+dogeMessages.dogeSpeaking, width-8, 555);
          outlinedText("Bubble Timers: "+timers.size(), width-8, 575);
          outlinedText("Bubble Timers: "+thePlayer.bubbleBoom, width-8, 595);
        }

        textAlign(CENTER);
        outlinedText("SuperMuki", width/2, 25);
        if (gameWon()) {
          outlinedText("Congrats!\nPress R for next Level.", width/2, height/2-12);
        }
        if (thePlayer.checkpointTriggered && checkpointReachedDisplayTimer<90) {
          outlinedText("CHECKPOINT REACHED\nGAME SAVED..", width/2, height/2);
          checkpointReachedDisplayTimer++;
        }
      }
      if (lifes==0) {
        textAlign(CENTER);
        outlinedText("GAME OVER!", width/2, height/2);
        outlinedText("R to restart", width/2, height/2+50);
      }
    }
    if (level==0) {
      textAlign(CENTER);
      outlinedText("PRESS R TO START", width/2, height/2-85);
      outlinedText("PRESS L TO LOAD GAME", width/2, height/2+height/100*3.64-85);
      outlinedText("PRESS ESC TO EXIT", width/2, height/2+height/100*7.29-85);
    }
  }
}//draw

void keyPressed() {
  theKeyboard.pressKey(key, keyCode);
}//keyPressed

void keyReleased() {
  theKeyboard.releaseKey(key, keyCode);
}//keyReleased

void stop() { // automatically called when program exits. here we'll stop and unload sounds.
  music.close();
  sndJump.close();
  sndPlayerDead.close();
  sndCoin.close();

  minim.stop();

  super.stop(); // tells program to continue doing its normal ending activity
}//stop