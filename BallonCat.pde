/**
 * BallonCat.pde
 * Purpose: Flying Cat with a Ballon, who gives the Player some lifes, when he throws a Fish @ BallonCat
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class BallonCat{


  PVector position, velocity;

  Boolean facingRight,moveLeft;

  static final float AIR_RUN_SPEED = 0.3;
  static final float AIR_SLOWDOWN_PERC = 0.5;

  BallonCat() {
    facingRight = false;
    moveLeft = true;
    position = new PVector();
    velocity = new PVector();
  }//BallonCat

  void reset() {
    facingRight=false;
  }//reset

  void checkForFish(){
    for(int i=0; i<fishs.size();i++){
      Fish tmpFish = fishs.get(i);
      if(position.y-ballon_cat.height<=tmpFish.position.y-fish.height && position.y>=tmpFish.position.y && position.x-ballon_cat.width/2 <= tmpFish.position.x && position.x+ballon_cat.width/2 >= tmpFish.position.x){
        tmpFish.alive = false;
        //lifes++;
        potions.add(new Potion(position.x,position.y));
      }
    }
  }//checkForFish

  void move() {

    float speedHere = AIR_RUN_SPEED;
    float frictionHere = AIR_SLOWDOWN_PERC;

      if (moveLeft) {
        velocity.x -= speedHere;
        facingRight=false;
        if(position.x<-30){
          moveLeft=false;
        }
      } else if (!moveLeft){
        velocity.x += speedHere;
        facingRight=true;
        if(position.x>1281){
          moveLeft=true;
        }
      }
      
      velocity.x *= frictionHere;
      
      position.add(velocity);
      checkForFish();
  }//move

  /*********************
   ** Figur "zeichnen" **
   *********************/

  void draw() {

    int guyWidth = ballon_cat.width;
    int guyHeight = ballon_cat.height;

    pushMatrix();
    translate(position.x, position.y);

    if (facingRight==false) {
      scale(-1, 1);
    }
    translate(-guyWidth/2, -guyHeight);
    if(level==3){
      image(ballon_cat2, 0, 0);
    }else{
      image(ballon_cat, 0, 0);
    }

    popMatrix();
  }//draw
}//BallonCat.class