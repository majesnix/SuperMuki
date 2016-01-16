/**
 * Piranha.pde
 * Purpose: Changes Bee Picture to Piranha
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Piranha extends Bee{

    Piranha() {
    isOnGround = false;
    facingRight = false;
    alive=false;
    moveLeft=true;
  }
   Piranha(int x, int y) {
    isOnGround = false;
    facingRight = false;
    alive=true;
    moveLeft=true;
    position.x=x;
    position.y=y;
  }

  void draw() {
    int guyWidth = piranha.width;
    int guyHeight = piranha.height;

    pushMatrix();
    translate(position.x, position.y);
    if (facingRight==true) {
      scale(-1, 1);
    }
    translate(-guyWidth/2, -guyHeight);

    /* 
     *  Bild des "Gegners"
     */

      image(piranha, 0, 0);

    popMatrix();
  }//draw
}//Class.Piranha