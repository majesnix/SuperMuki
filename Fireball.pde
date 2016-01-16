class Fireball extends Arrow {

  PVector dir, acceleration;

  Fireball(float x, float y, boolean b) {
    facingRight = b;
    alive=true;
    isOnGround=false;
    acceleration = new PVector();
    position.x = x;
    position.y = y;
    dir = PVector.sub(thePlayer.position,position);
    dir.normalize().mult(0.4);
    acceleration = dir;
  }//Fireball

  void move() {
    
    velocity.add(acceleration);
    velocity.limit(10);
    position.add(velocity);

    checkForWallBumping();

  }

  void draw() {
    int fireballWidth = fireball.width;
    int fireballHeight = fireball.height;

    pushMatrix();
    translate(position.x, position.y);
    
    if (facingRight==true) {
      scale(-1, 1);
    }
    translate(-fireballWidth/2, -fireballHeight);

    image(fireball, 0, 0);

    popMatrix();
  }//draw
}//Fireball.class