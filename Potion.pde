/**
 * Potion.pde
 * Purpose: Creates a Potion, which can be collected by the Player
 *
 * @author Claßen, Dominic
 * @version 1.0
 */

class Potion{

	PVector position, velocity;

	Boolean alive;
	float rotation;

	float i = 2.5;
	
	Potion(float positionX,float positionY){
		position = new PVector();
		velocity = new PVector();
		position.x=positionX;
		position.y=positionY;
		alive=true;
		rotation = 0;
	}//Potion

	void checkPlayerCollision(){
		PVector potionCenter = new PVector(position.x,position.y-potion.height/2);
		if(potionCenter.x<=thePlayer.position.x+player1.width && potionCenter.x >= thePlayer.position.x-player1.width && potionCenter.y >= thePlayer.position.y-player1.height && potionCenter.y <=thePlayer.position.y){
			lifes++;
			alive=false;
		}
	}//checkPlayerCollision

	void move(){
    	velocity.y = 3;
    	position.add(velocity);
    	checkPlayerCollision();
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

      	image(potion, 0, 0);

    	popMatrix();
	}//draw
}//Class.Potion