/**
 * Potion.pde
 * Purpose: Creates a Potion, which can be collected by the Player
 *
 * @author Claßen, Dominic
 * @version 1.0
 */
class Potion extends Fish{
	
	Potion(float positionX,float positionY){
		position.x=positionX;
		position.y=positionY;
		alive=true;
		rotation = 0;
	}//Potion

	void checkPlayerCollision(){
		PVector top= new PVector(position.x,position.y-potion.height);
		PVector potionCenter = new PVector(position.x,position.y-potion.height/2);
		PVector sideLeft = new PVector(position.x-potion.width/2,position.y-potion.height);
		PVector sideRight = new PVector(position.x+potion.width/2,position.y-potion.height);
		PVector playerCenter = new PVector(thePlayer.position.x,thePlayer.position.y-player1.height/2);
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