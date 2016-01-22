/**
 * Pigshot.pde
 * Purpose: Replaces Arrow Texture with a little piggie
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Pigshot extends Arrow {

  Pigshot(float positionX, float positionY, boolean b) {
    facingRight = b;
    alive=true;
    isOnGround=false;
    position.x = positionX;
    position.y = positionY;
    velocity.y = -7;
  }//Pigshot

  void draw() {
    int pigshotWidth = pigshot.width;
    int pigshotHeight = pigshot.height;

    pushMatrix();
    translate(position.x, position.y);

    /***********************************
     **  Rotation of the mini Piggie  **
     **********************************/
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
    translate(-pigshotWidth/2, -pigshotHeight);

    image(pigshot, 0, 0);

    popMatrix();
  }//draw
}//Pigshot.class