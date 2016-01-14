class ItemBox {

  //positioning 
  PVector bgPos, itemPos;
  float w, h;

  Boolean item1, item2, item3, item4, item5, item6, item7;

  ItemBox(PVector _bg, float _w) { 
    bgPos   = _bg;
    w       = _w;
    h       = 55;

    itemPos = new PVector(bgPos.x + 27, (bgPos.y + h) - 35);
  }//itemBox

  void display() {
    drawBg();
    drawItem();
  }//display

  void drawItem() {
    if (level==1) {
      if (item1) {
        image(dcl_apple, 20, height-height/100*5.5);
      } else {
        image(questionmark, 20, height-height/100*5.5);
      }
      if (item2) {
        image(dcl_bier, 60, height-height/100*5.5);
      } else {
        image(questionmark, 60, height-height/100*5.5);
      }
      if (item3) {
        image(dcl_kaffe, 100, height-height/100*5.5);
      } else {
        image(questionmark, 100, height-height/100*5.5);
      }
      if (item4) {
        image(dcl_computer, 140, height-height/100*5.5);
      } else {
        image(questionmark, 140, height-height/100*5.5);
      }
      if (item5) {
        image(dcl_burger, 180, height-height/100*5.5);
      } else {
        image(questionmark, 180, height-height/100*5.5);
      }
      if (item6) {
        image(dcl_golf, 220, height-height/100*5.5);
      } else {
        image(questionmark, 220, height-height/100*5.5);
      }
      if (item7) {
        image(dcl_java, 260, height-height/100*5.5);
      } else {
        image(questionmark, 260, height-height/100*5.5);
      }
    }
    if (level==2) {
      if (item1) {
        image(lori_brille, 20, height-height/100*5.5);
      } else {
        image(questionmark, 20, height-height/100*5.5);
      }
      if (item2) {
        image(lori_computer, 60, height-height/100*5.5);
      } else {
        image(questionmark, 60, height-height/100*5.5);
      }
      if (item3) {
        image(lori_noten, 100, height-height/100*5.5);
      } else {
        image(questionmark, 100, height-height/100*5.5);
      }
      if (item4) {
        image(lori_topf, 140, height-height/100*5.5);
      } else {
        image(questionmark, 140, height-height/100*5.5);
      }
      if (item5) {
        image(lori_schuhe, 180, height-height/100*5.5);
      } else {
        image(questionmark, 180, height-height/100*5.5);
      }
      if (item6) {
        image(lori_eis, 220, height-height/100*5.5);
      } else {
        image(questionmark, 220, height-height/100*5.5);
      }
      if (item7) {
        image(lori_kunst, 260, height-height/100*5.5);
      } else {
        image(questionmark, 260, height-height/100*5.5);
      }
    }
    if (level==3) {
      if (item1) {
        image(cennet_brille, 20, height-height/100*5.5);
      } else {
        image(questionmark, 20, height-height/100*5.5);
      }
      if (item2) {
        image(cennet_cat, 60, height-height/100*5.5);
      } else {
        image(questionmark, 60, height-height/100*5.5);
      }
      if (item3) {
        image(cennet_burger, 100, height-height/100*5.5);
      } else {
        image(questionmark, 100, height-height/100*5.5);
      }
      if (item4) {
        image(cennet_schminke, 140, height-height/100*5.5);
      } else {
        image(questionmark, 140, height-height/100*5.5);
      }
      if (item5) {
        image(cennet_kunst, 180, height-height/100*5.5);
      } else {
        image(questionmark, 180, height-height/100*5.5);
      }
      if (item6) {
        image(cennet_noten, 220, height-height/100*5.5);
      } else {
        image(questionmark, 220, height-height/100*5.5);
      }
      if (item7) {
        image(cennet_gameboy, 260, height-height/100*5.5);
      } else {
        image(questionmark, 260, height-height/100*5.5);
      }
    }
    if (level==4) {
      if (item1) {
        image(lena_brille, 20, height-height/100*5.5);
      } else {
        image(questionmark, 20, height-height/100*5.5);
      }
      if (item2) {
        image(lena_hund, 60, height-height/100*5.5);
      } else {
        image(questionmark, 60, height-height/100*5.5);
      }
      if (item3) {
        image(lena_kunst, 100, height-height/100*5.5);
      } else {
        image(questionmark, 100, height-height/100*5.5);
      }
      if (item4) {
        image(lena_veggie, 140, height-height/100*5.5);
      } else {
        image(questionmark, 140, height-height/100*5.5);
      }
      if (item5) {
        image(lena_sport, 180, height-height/100*5.5);
      } else {
        image(questionmark, 180, height-height/100*5.5);
      }
      if (item6) {
        image(lena_metal, 220, height-height/100*5.5);
      } else {
        image(questionmark, 220, height-height/100*5.5);
      }
      if (item7) {
        image(lena_noten, 260, height-height/100*5.5);
      } else {
        image(questionmark, 260, height-height/100*5.5);
      }
    }
  }//drawItem

  void drawBg() {
    rectMode(CORNER);
    noStroke();
    fill(100, 100, 100, 127);
    rect(bgPos.x, bgPos.y, w, h);
    noFill();
    stroke(15);
    rect(bgPos.x, bgPos.y, w, h, 5);
  }//drawBg

  void reset() {
    if (!thePlayer.checkpointTriggered) {
      item1=false;
      item2=false;
      item3=false;
      item4=false;
      item5=false;
      item6=false;
      item7=false;
    } else {
      item1=true;
      item2=true;
      item3=true;
      item4=true;
      item5=false;
      item6=false;
      item7=false;
    }
  }//reset
}//class.Itembox