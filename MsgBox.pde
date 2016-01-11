/******************************************************************************************************
 **  https://forum.processing.org/two/discussion/10746/how-to-make-typewriter-effect    (24.12.2015)  **
 **  Angepasst durch dcl                                                                              **
 *******************************************************************************************************/

/**
 *************************************
 * Code for a Message Box.*
 * by _vk 2014oct                    *
 *************************************
 */


/**
 *************************************************
 *************************************************
 **             CLASS MSGBOX                    **
 *************************************************
 *************************************************
 */

class MsgBox {

  /**
   ******************************************************************************************
   **                                    MEMBER FIELDS                                      **
   ******************************************************************************************
   */
   
  String[] s ={ "", 
    ""};

  int index =0;

  Boolean textDone;
  Boolean dogeSpeaking;

  // the text and a holder
  String text, displayText;

  //positioning 
  PVector bgPos, textPos;
  float w, h;

  //font and color
  color textColor  =#ffffff;

  //timimng
  int timer, wait;

  int textPosition;

  /**
   ******************************************************************************************
   **                                    CONSTRUCTOR                                       **
   ******************************************************************************************
   */

  /*************THE CONSTRUCTOR**********/
  //it takes the text, positioning stuff and init everything
  
  MsgBox(PVector _bg, float _w, PFont _f, int _wait) {
    bgPos   = _bg;
    font    = _f;
    w       = _w;
    h       = 55;
    text    = "";
    dogeSpeaking=false;

    textFont(font);

    //calc text pos relative to bg pos
    textPos = new PVector(bgPos.x + 27, (bgPos.y + h) - 35);

    // the speed of "typing"
    wait = _wait;
  }

  /**
   ******************************************************************************************
   **                                  LOGIC FUNCTIONS                                     **
   ******************************************************************************************
   */



  /*************RUN IS WRAPPER 4 ALL FUNCTIONALITY - *********/
  void run() {
    update();
    display();
  }//run


  /*************DISPLAY IS WRAPPER 4 ALL DRAWING - *********/
  void display() {
    drawBg();
    drawText();
  }//display

  /*************SETS A NEW TEXT, - *********/
  void setText(String s) {
    if (!text.equals(s)) {
      text = s;
      displayText = text;
    }
  }//setText

  /*************SETS DISPLAY TEXT TO EMPTY THUS TRIGGERING THE ANIMATION - ****************/
  /*************ALSO SETS THE TIMER. TIMER IS FOR THE SPEED OF EACH CHAR APPEARING - *********/
  void animateText() {   
    displayText = "";
    timer = millis();
  }//animateText



  /********************* - ANIMATE IT - ***************************/
  void update() {
    if (!isFinished() && (millis() - timer) > wait) {      
      displayText = text.substring(0, displayText.length()+1);
      timer = millis();
    }
  }//update()

  /********** - CHECK IF BOTH STRING ARE SAME SIZE - ***************/
  boolean isFinished() {
    return displayText.length() == text.length();
  }//isFinished

  /**
   ******************************************************************************************
   **                                    DRAWING FUNCTIONS                                 **
   ******************************************************************************************
   */
  /*************************DRAWS BG***********************/
  void drawBg() {
    rectMode(CORNER);
    noStroke();
    fill(100, 100, 100, 127);
    rect(bgPos.x, bgPos.y, w, h);
    noFill();
    stroke(15);
    rect(bgPos.x, bgPos.y, w, h, 5);
  }//drawBg

  /*************************DRAWS TEXT***********************/
  void drawText() {
    fill(textColor);
    text(displayText, textPos.x, textPos.y);
  }//drawText

/**
 * Method to hold the MsgBox on screen
 * 
 * @author Claßen, Dominic
 */
  
  boolean displayTimer() {
    if (millis()/1000-timer/1000==3) {
      textPosition++;
      setText(s[1]);
      animateText();
      timer = millis()/1000;
      return false;
    } else {
      return true;
    }
  }//displayTimer


  void reset() {
    textPosition=0;
    index=0;
    dogeSpeaking=false;
  }//reset
}//MsgBox.class