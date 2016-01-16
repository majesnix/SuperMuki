class Piranha extends Bee{

    Piranha() {
    isOnGround = false;
    facingRight = true;
    alive=false;
    moveLeft=true;
  }
   Piranha(int x, int y) {
    isOnGround = false;
    facingRight = true;
    alive=true;
    moveLeft=true;
    position.x=x;
    position.y=y;
  }

  void draw() {
    int guyWidth = piranha.width;
    int guyHeight = piranha.height;

    if (velocity.x<-TRIVIAL_SPEED) {
      facingRight = false;
    } else if (velocity.x>TRIVIAL_SPEED) {
      facingRight = true;
    }

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