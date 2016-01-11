class BallonCat{


  PVector position, velocity;

  Boolean facingRight;

  static final float AIR_RUN_SPEED = 0.3;
  static final float AIR_SLOWDOWN_PERC = 0.5;

  BallonCat() {
    facingRight = false;
    position = new PVector();
    velocity = new PVector();
  }//BallonCat

  void reset() {
    facingRight=false;
  }//reset

  void move() {

    float speedHere = AIR_RUN_SPEED;
    float frictionHere = AIR_SLOWDOWN_PERC;

      if (position.x>0) {
        velocity.x -= speedHere;
      }
      
      velocity.x *= frictionHere;
      
      position.add(velocity);
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

    image(ballon_cat, 0, 0);

    popMatrix();
  }//draw
}//BallonCat.class