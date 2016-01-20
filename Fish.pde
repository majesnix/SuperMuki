/**
 * Fish.pde
 * Purpose: Little Fish who flys up in the Sky, -> BallonCat
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Fish {
	
	PVector position, velocity;

	Boolean alive;
	float rotation;

	float i = 2.5;

	Fish(){
		velocity = new PVector();
		position = new PVector();
		alive=true;
	}//Fish

	Fish(float positionX, float positionY){
		velocity = new PVector();
		position = new PVector();
		position.x = positionX;
		position.y = positionY;
		alive=true;
		rotation = 0;
	}//Fish

	void move(){

    	velocity.y = -3;

    	position.add(velocity);

	}//move

	void draw(){
		if (position.y<0){
			alive=false;
		}
	int guyWidth = fish.width;
    int guyHeight = fish.height;

    pushMatrix();
    translate(position.x, position.y);
    translate(-guyWidth/2, -guyHeight);

    rotation = rotation+i;
    translate(guyWidth/2,guyHeight/2);
    rotate(radians(rotation));
    translate(-guyWidth/2, -guyHeight/2);

      image(fish, 0, 0);

    popMatrix();
  }//draw
}//Fish.class