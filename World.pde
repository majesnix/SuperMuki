/**************************************************************************************
 **  Basecode: http://www.hobbygamedev.com/int/platformer-game-source-in-processing/  **
 **************************************************************************************/

class World {

  int coinsInStage, itemsInStage, rubysInStage;

  /*********************************************
   **  Bausteine der einzelnen Welten / Level  **
   *********************************************/
  
  static final int BALLON_CAT = -3;
  static final int MAGICAL_DOGE = -2;
  static final int TILE_START = -1;      //Spawnpunkte

  static final int TILE_EMPTY = 0;        //LUFT
  static final int TILE_SOLID = 1;       //Dirt + Top Grass
  static final int TILE_SOLID2 = 2;      //Dirt
  static final int TILE_GRASS_LEFT_TOP=3;    //Dirt + Links Grass
  static final int TILE_GRASS_RIGHT_TOP=4;    // Dirt + Rechts Grass
  static final int TILE_GRASS_LTR=5;      //Dirt + Links / Rechts / Top Grass
  static final int TILE_STONE = 6;        //Stein
  static final int TILE_LAVA = 7;          //Tödliche Lava
  static final int TILE_LAVA_TOP = 8;     //Lava mit "Kruste" begehbar
  static final int TILE_CLOUD = 9;        //Wölkchen 
  static final int TILE_MOVING = 10;
  static final int TILE_ALGE = 11;
  static final int TILE_BLASE = 12;      //Blase
  static final int TILE_GRASS_LEFT=13;
  static final int TILE_GRASS_RIGHT=14;
  static final int TILE_WATER=15;
  static final int TILE_FLOWER=16;
  static final int TILE_ALGE_BOTTOM = 17;
  static final int TILE_MAGIC = 18;

  static final int COIN = 20;      //Münze

  static final int ITEM_DOMINIC_APPLE = 21;
  static final int ITEM_DOMINIC_BIER = 22;
  static final int ITEM_DOMINIC_KAFFEE = 23;
  static final int ITEM_DOMINIC_COMPUTER = 24;
  static final int ITEM_DOMINIC_BURGER = 25;
  static final int ITEM_DOMINIC_GOLF = 26;
  static final int ITEM_DOMINIC_JAVA = 27;

  static final int ITEM_LENA_BRILLE = 28;
  static final int ITEM_LENA_HUND = 29;
  static final int ITEM_LENA_KUNST = 30;
  static final int ITEM_LENA_VEGGIE = 31;
  static final int ITEM_LENA_SPORT = 32;
  static final int ITEM_LENA_METAL = 33;
  static final int ITEM_LENA_NOTEN = 34;

  static final int ITEM_CENNET_BRILLE = 35;
  static final int ITEM_CENNET_CAT = 36;
  static final int ITEM_CENNET_BURGER = 37;
  static final int ITEM_CENNET_SCHMINKE = 38;
  static final int ITEM_CENNET_KUNST = 39;
  static final int ITEM_CENNET_NOTEN = 40;
  static final int ITEM_CENNET_GAMEBOY = 41;

  static final int ITEM_LORI_BRILLE = 42;
  static final int ITEM_LORI_COMPUTER = 43;
  static final int ITEM_LORI_NOTEN = 44;
  static final int ITEM_LORI_TOPF = 45;
  static final int ITEM_LORI_SCHUHE = 46;
  static final int ITEM_LORI_EIS = 47;
  static final int ITEM_LORI_KUNST = 48;

  static final int RUBY = 49;

  static final int TILE_MUNCHER = 60;    //NomNom Pflanzen
  static final int NINJA = 61;            //Ninja spawnpunkt
  static final int ARCHER = 62;           //Archer spawnpunkt
  static final int FIREFACE = 63;        //Fireface spawnpunkt
  static final int EVILPIG = 64;          //Evilpig spawnpunkt
  static final int BEE = 65;              //Bee spawnpunkt

  static final int TILE_TRIGGER_EVENT = 90;
  static final int TILE_CHECKPOINT = 91;
  static final int TILE_DOGE_CHECKPOINT = 92;

  static final int TILE_BLOCK=98;
  static final int TILE_KILL=99;
  static final int TILE_WIN=100;

  static final int GRID_UNIT_SIZE = 30; // Größe eines einzelnen Blocks

  // Größe der Welt
  static final int GRID_UNITS_WIDE = 400;
  static final int GRID_UNITS_TALL = 35;

  int[][] worldGrid = new int[GRID_UNITS_TALL][GRID_UNITS_WIDE];

  World() {
  }

  /*
  **  GridSpotX = zwischen 0-400 (12.000 X) SPALTE
   **  GridSpotY = zwischen 0 - 35 (1.050 Y) ZEILE
   */

  // returns what type of tile is at a given pixel coordinate
  int worldSquareAt(PVector thisPosition) {
    float gridSpotX = thisPosition.x/GRID_UNIT_SIZE;
    float gridSpotY = thisPosition.y/GRID_UNIT_SIZE;

    // first a boundary check, to avoid looking outside the grid
    // if check goes out of bounds, treat it as a solid tile (wall)
    if (gridSpotX<0) {
      return TILE_SOLID;
    }
    if (gridSpotX>=GRID_UNITS_WIDE) {
      return TILE_SOLID;
    }
    if (gridSpotY<0) {
      return TILE_SOLID;
    }
    if (gridSpotY>=GRID_UNITS_TALL) {
      return TILE_SOLID;
    }

    return worldGrid[int(gridSpotY)][int(gridSpotX)];
  }//worldSquareAt

  /********************************
   **  Helper Methoden für Enemy  **
   ********************************/

  int worldSquareAtPlusOneSquare(PVector thisPosition) {
    float gridSpotX = thisPosition.x/GRID_UNIT_SIZE;
    float gridSpotY = thisPosition.y/GRID_UNIT_SIZE;

    if (gridSpotX+1<0) {
      return TILE_SOLID;
    }
    if (gridSpotX+1>=GRID_UNITS_WIDE) {
      return TILE_SOLID;
    }
    if (gridSpotY+1<0) {
      return TILE_SOLID;
    }
    if (gridSpotY+1>=GRID_UNITS_TALL) {
      return TILE_SOLID;
    }

    return worldGrid[int(gridSpotY)+1][int(gridSpotX)];
  }//worldSquareAtPlusOneSquare

  void setSquareAtToThis(PVector thisPosition, int newTile) {
    int gridSpotX = int(thisPosition.x/GRID_UNIT_SIZE);
    int gridSpotY = int(thisPosition.y/GRID_UNIT_SIZE);

    if (gridSpotX<0 || gridSpotX>=GRID_UNITS_WIDE || 
      gridSpotY<0 || gridSpotY>=GRID_UNITS_TALL) {
      return; // can't change grid units outside the grid
    }

    worldGrid[gridSpotY][gridSpotX] = newTile;
  }//setSquareAtToThis

  // these helper functions help us correct for the player moving into a world tile
  float topOfSquare(PVector thisPosition) {
    int thisY = int(thisPosition.y);
    thisY /= GRID_UNIT_SIZE;
    return float(thisY*GRID_UNIT_SIZE);
  }//topOfSquare

  float bottomOfSquare(PVector thisPosition) {
    if (thisPosition.y<0) {
      return 0;
    }
    return topOfSquare(thisPosition)+GRID_UNIT_SIZE;
  }//bottomOfSquare

  float leftOfSquare(PVector thisPosition) {
    int thisX = int(thisPosition.x);
    thisX /= GRID_UNIT_SIZE;
    return float(thisX*GRID_UNIT_SIZE);
  }//leftOfSquare

  float rightOfSquare(PVector thisPosition) {
    if (thisPosition.x<0) {
      return 0;
    }
    return leftOfSquare(thisPosition)+GRID_UNIT_SIZE;
  }//rightOfSquare

  /************
   **  LVL 1  **
   ************/

  void generate(int n) {
    coinsInStage = 0; // we count them while copying in level data
    itemsInStage = 0;
    rubysInStage = 0;

    int[][] a = loadWorld(n);

    for (int i=0; i<GRID_UNITS_WIDE; i++) {
      for (int ii=0; ii<GRID_UNITS_TALL; ii++) {
        if (a[ii][i] == TILE_START && !thePlayer.checkpointTriggered) { // player start position
          worldGrid[ii][i] = TILE_EMPTY; // put an empty tile in that spot

          // then update the player spot to the center of that tile
          thePlayer.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          thePlayer.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
        } else if (a[ii][i] == TILE_CHECKPOINT && thePlayer.checkpointTriggered) { // player start position
          worldGrid[ii][i] = TILE_EMPTY; // put an empty tile in that spot

          // then update the player spot to the center of that tile
          thePlayer.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          thePlayer.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
        } else if (a[ii][i] == MAGICAL_DOGE && !thePlayer.checkpointTriggered) {
          worldGrid[ii][i] = TILE_EMPTY;
          theDoge.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          theDoge.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
        } else if (a[ii][i] == TILE_DOGE_CHECKPOINT && thePlayer.checkpointTriggered) {
          worldGrid[ii][i] = TILE_EMPTY;
          theDoge.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          theDoge.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
        } else if (a[ii][i] == BALLON_CAT) {
          worldGrid[ii][i] = TILE_EMPTY;
          theBallonCat.position.x = i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2);
          theBallonCat.position.y = ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2-30);
        } else if (a[ii][i] == NINJA) {
          worldGrid[ii][i] = TILE_EMPTY;
          ninjas.add(new Ninja(i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2), ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2)));
        } else if (a[ii][i] == ARCHER) {
          worldGrid[ii][i] = TILE_EMPTY;
          archers.add(new Archer(i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2), ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2)));
        } else if (a[ii][i] == FIREFACE) {
          worldGrid[ii][i] = TILE_EMPTY;
          firefaces.add(new Fireface(i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2), ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2)));
        } else if (a[ii][i] == EVILPIG) {
          worldGrid[ii][i] = TILE_EMPTY;
          evilpigs.add(new Evilpig(i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2), ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2)));
        } else if (a[ii][i] == BEE) {
          worldGrid[ii][i] = TILE_EMPTY;
          bees.add(new Bee(i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2), ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE/2+10)));
        } else if (a[ii][i] == TILE_MOVING) {
          worldGrid[ii][i] = TILE_EMPTY;
          platforms.add(new MovingPlatform(i*GRID_UNIT_SIZE+(GRID_UNIT_SIZE), ii*GRID_UNIT_SIZE+(GRID_UNIT_SIZE), "TILE_CLOUD"));
        } else {
          if (a[ii][i]==COIN) {
            coinsInStage++;
          }
          if (a[ii][i]==RUBY) {
            rubysInStage++;
          }
          if (a[ii][i]== ITEM_DOMINIC_APPLE || a[ii][i]== ITEM_DOMINIC_BIER || a[ii][i]== ITEM_DOMINIC_KAFFEE || a[ii][i]== ITEM_DOMINIC_COMPUTER || a[ii][i]== ITEM_DOMINIC_BURGER || a[ii][i]== ITEM_DOMINIC_GOLF || a[ii][i]== ITEM_DOMINIC_JAVA ||
            a[ii][i]== ITEM_LENA_BRILLE || a[ii][i]== ITEM_LENA_HUND || a[ii][i]== ITEM_LENA_KUNST || a[ii][i]== ITEM_LENA_VEGGIE || a[ii][i]== ITEM_LENA_SPORT || a[ii][i]== ITEM_LENA_METAL || a[ii][i]== ITEM_LENA_NOTEN ||
            a[ii][i]== ITEM_CENNET_BRILLE || a[ii][i]== ITEM_CENNET_CAT || a[ii][i]== ITEM_CENNET_BURGER || a[ii][i]== ITEM_CENNET_SCHMINKE || a[ii][i]== ITEM_CENNET_KUNST || a[ii][i]== ITEM_CENNET_NOTEN || a[ii][i]== ITEM_CENNET_GAMEBOY ||
            a[ii][i]== ITEM_LORI_BRILLE || a[ii][i]== ITEM_LORI_COMPUTER || a[ii][i]== ITEM_LORI_NOTEN || a[ii][i]== ITEM_LORI_TOPF || a[ii][i]== ITEM_LORI_SCHUHE || a[ii][i]== ITEM_LORI_EIS || a[ii][i]== ITEM_LORI_KUNST) {
            itemsInStage++;
          }
          worldGrid[ii][i] = a[ii][i];
        }
      }
    }
  }//generate

  /*********************
   **  Draw the world  **
   *********************/

  void render() {

    for (int i=0; i<GRID_UNITS_WIDE; i++) {
      for (int ii=0; ii<GRID_UNITS_TALL; ii++) {
        if (worldGrid[ii][i]==TILE_SOLID) {
          image(grass_top, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_MUNCHER) {
          image(muncher, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_SOLID2) {
          image(dirt, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_GRASS_LEFT) {
          image(grass_left, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_GRASS_RIGHT) {
          image(grass_right, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_GRASS_LEFT_TOP) {
          image(grass_left_top, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_GRASS_RIGHT_TOP) {
          image(grass_right_top, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_GRASS_LTR) {
          image(grass_ltr, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_STONE) {
          image(stone, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_LAVA) {
          image(lava, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_LAVA_TOP) {
          image(lava_top, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_CLOUD) {
          image(wolke, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_ALGE) {
          image(alge, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_BLASE) {
          image(blase, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_WATER) {
          image(water, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_FLOWER) {
          image(flower, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        } else if (worldGrid[ii][i]==TILE_ALGE_BOTTOM) {
          image(water, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==COIN) { // Münze     + Werte, damit die Gegenstände ca. im Zentrum des Blocks liegen
          image(coin, i*GRID_UNIT_SIZE+10, ii*GRID_UNIT_SIZE+8);
        }
        if (worldGrid[ii][i]==RUBY) { // Münze     + Werte, damit die Gegenstände ca. im Zentrum des Blocks liegen
          image(rubin, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_DOMINIC_APPLE) {
          image(dcl_apple, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_DOMINIC_BIER) {
          image(dcl_bier, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_DOMINIC_KAFFEE) {
          image(dcl_kaffe, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_DOMINIC_COMPUTER) {
          image(dcl_computer, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_DOMINIC_BURGER) {
          image(dcl_burger, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_DOMINIC_GOLF) {
          image(dcl_golf, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_DOMINIC_JAVA) {
          image(dcl_java, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LENA_BRILLE) {
          image(lena_brille, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LENA_HUND) {
          image(lena_hund, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LENA_KUNST) {
          image(lena_kunst, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LENA_VEGGIE) {
          image(lena_veggie, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LENA_SPORT) {
          image(lena_sport, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LENA_METAL) {
          image(lena_metal, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LENA_NOTEN) {
          image(lena_noten, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_CENNET_BRILLE) {
          image(cennet_brille, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_CENNET_CAT) {
          image(cennet_cat, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_CENNET_BURGER) {
          image(cennet_burger, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_CENNET_SCHMINKE) {
          image(cennet_schminke, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_CENNET_KUNST) {
          image(cennet_kunst, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_CENNET_NOTEN) {
          image(cennet_noten, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_CENNET_GAMEBOY) {
          image(cennet_gameboy, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LORI_BRILLE) {
          image(lori_brille, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LORI_COMPUTER) {
          image(lori_computer, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LORI_NOTEN) {
          image(lori_noten, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LORI_TOPF) {
          image(lori_topf, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LORI_SCHUHE) {
          image(lori_schuhe, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LORI_EIS) {
          image(lori_eis, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
        if (worldGrid[ii][i]==ITEM_LORI_KUNST) {
          image(lori_kunst, i*GRID_UNIT_SIZE, ii*GRID_UNIT_SIZE);
        }
      }
    }
  }//render
}//World.class